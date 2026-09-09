Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E67B9C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A9F6B008A; Wed,  9 Sep 2026 13:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E586B0099; Wed,  9 Sep 2026 13:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5A06B009B; Wed,  9 Sep 2026 13:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B61D36B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:13:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 193DDC02BC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:13:35 +0000 (UTC)
X-FDA: 85194870390.22.C191754
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1323B1C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:13:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ros+3Dzh;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoITJbg+tcqR4yAMRl6LbU3qdaLtqDYLmTuTo1MWr54=;
	b=4x8ofPQ15NQxLJMoxS1oD301nxcu/nR6DpPZSH4VZPyuD1EBDk8MK6so0mGNseYMPH+eE4
	AFlQyp3m+DASAFo6Ve697lpLsz5cp44oSh/eaEHWhfZAMrpRKnaasyc4k3U5yVWfYVrLP+
	CoRrx+wCaviYT+aHPEPbBLNZEBZtQDI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788974013;
	b=5fOKABKHlrpMHDxgN2k7ZWydZQR9qTHmVsInrMTdQYbpUyCPKOPMgeqOQiD25ggPMIKAcY
	59Aoe0HUmT68Zo37aUPKDlc5oaNl85A+SZXVmoF2tjzJ3Zin5E8omdAs7jD5/CW5Lqyzgh
	ynfKhQC3mMBdY3rMFw75KEIAagRnT/c=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ros+3Dzh;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so283781cf.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 10:13:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788974012; cv=none;
        d=google.com; s=arc-20260327;
        b=ERSaRx10ka0lL3kR52DtdGLzmlNP9Mz1GCL99QJC01tubUbGkhKvh0wvESU7CzcPgs
         NrjLtRpx0u5E1DDB1TIlXMBmqdUyoJWcsnrY0Zj32a5nWM6msdRSzm3S4f2T2Fu8/WEI
         MKbkxmipfNwvAXP1g605JJ2oNYhqsnPkTcbj+NTqWZhcVFcGjtzQIxumU9q9vFrmytCq
         XYzsqhaguwye5vgWC1t0n0p22vPxRfcbu1i1hmhbm1kr0d7d2LMBIxbwH6Mh4IsBisvl
         xlcaSvOJSSOQGplSQt/Nm0eukiv4tNwWFNKzjbzwRwSLtPypsPu6mdzdooE13ZGCHN4D
         NJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BoITJbg+tcqR4yAMRl6LbU3qdaLtqDYLmTuTo1MWr54=;
        fh=7TL9FOb6n+sdFvc6R8+07YPQ5raKnNzixXlBpaaC6m8=;
        b=ZzS/LQwAvAUmudMIhBlX+08bReZYFIOnta2DDdGWjTF3jgM5P8xVOmtowgQfs+UPGR
         rlV8zxvABCxhlukhpJ9RoGp9rBopMSgKuNVcUGJnF89p9B+WwkwuIGYwShf5ZENqTIBl
         1sso7x9oVx5KCayJW1Zfeq8H/FjJ3xDu6pqy7QjI6z9jocO0J68M3bLKyuZ1pQ/b2qNh
         ffJ2XoxtQg6XlAeCN0pMO8x7n4ODomDknydyd7LB+FzfSJoOL0W7ePi4Wik1hZtWY6G/
         vSd5BeZeuImvlT6TRWeHUfMULoMFjUfaMbRXUg94gSJDNqm0BDfmZvlyoetqnJ/sbQ4M
         915A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788974012; x=1789578812; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BoITJbg+tcqR4yAMRl6LbU3qdaLtqDYLmTuTo1MWr54=;
        b=ros+3DzhaluQncA8pS6Oa2r/dTg0Lrt/Pyv+NVEIbHpycbzl+bbFV+0R7CZmk6Zj6Q
         Xf2xexdx26u0YDABqAdngpSxpB2HCwpzrl4lta51Te8uOvWPjj8jT6+cqqTMfxtn+IBc
         P8pAykQ/CbdpAtQ254SAl//1Tsc/5o27bj6iGwbzrKsAnm+lGxEa1RRR4oZbnNUZc8FH
         iFHTJiJwwvGQjvDt2QDudpNrtmX4+Of/V4lG8Tds2pmJ0kgy455dRRTcCWL1UwubJjra
         lm+8+2GjxfFHapvtOjQDon03hCTtqAsmEjLB4SyjgaionJBbE1ThAcI0DzkdTT3Z27D2
         fvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788974012; x=1789578812;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BoITJbg+tcqR4yAMRl6LbU3qdaLtqDYLmTuTo1MWr54=;
        b=D/FTgdE/5eBlkG4D22IYX8StolOxjctDKJ16pX1jQpfO7rWkV5u3NzGRNenJ40zuXz
         oX65mgUsLx6Co+XV+oR2zqxg+uKn7GrNTo4FJH3uQrQoC/qNAO7IkCg0VoWeL6CYSMR/
         mRQtEZX8bBRKD0ILtwdGqB2cf+p+pCd3fj/+CU/3HrusQS09Zmg8sZo5Vsm44ouQmKz9
         BEs5N+KnZRL9+zav8TlO8InyQTPyjtb+L35AlV6JqeNh/F0gqsoV5Fls8q7CKZXONP5W
         WtYiOJZh/mf/MwKV1JTlfugGHCbyL6AL12zSkTgT0y/Sv2ZzgacTGG2VzyXsJFqps4/l
         ziNw==
X-Forwarded-Encrypted: i=1; AKwUvBxyVkU+u2mt1/2RXlswnvbA//X5x6C6QzDBh4L/1vmQMEV6LwxIGgdy+4Q0Q3FN8W/aDJgbIEWc5w==@kvack.org
X-Gm-Message-State: AFuF++kMI1TUMSiZuVOnITahyhrADxYAf/Z4ooF5OuEijz9ZgndA6gcM
	t46mK+iTdW7c93KE+o/C3JQrcbxFpLZGTmYIYCAurvmCu2xW+GZSia62e+A+UODbTG6O0vc+DRG
	ioZO236agwXhP28GdMBWYuNU6zpfXBOVRILwA7+GN
X-Gm-Gg: AYBFou0zqBU5UFk7O69wDuuRfEUveuq+dDlzEGFTDIWOp15/qN/yGus3FsUF/jKcSSq
	q2vlxodH1JZC7kfVXtmijPXBauIFn41nS0oovnA+WrdJpOx4Vc78DtfIXK4DhMZeHg0sTpb2gJB
	hMa7yDKRmOU4YIPJ2hzQ/sNfde6pT1303qgfeOOYtIjN5ca9DSEdqS9Bj9Z0TB29MDRCCEyOUgT
	hYigzJhZm4ce1SdKOepYhH6fDlElwFVvCEMiMlZFFO11j7x/LrpQmIAIME9z3MoxGohMCqjs3IO
	rDMy2kcUqUMPbMPRJGpz0yXNYhw77sHlTYjbt6uqQq/rx8iT5Hcd58bCqQ==
X-Received: by 2002:a05:622a:400d:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-530a5f013ddmr15911cf.7.1788974010867; Wed, 09 Sep 2026 10:13:30
 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-2-surenb@google.com>
 <1d5011f8-26a1-41e1-bb9d-8d72c08b8fe9@kernel.org>
In-Reply-To: <1d5011f8-26a1-41e1-bb9d-8d72c08b8fe9@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Sep 2026 10:13:18 -0700
X-Gm-Features: AcwNN1VviiL9YOndRTSyFCutgcsYgAZMb28lE2qZmCuqHAyOyXU8c5SOoH4lvoQ
Message-ID: <CAJuCfpH25ML1+hdhTtZUoSjgrNcGv9HbQD8o5UErmAdW-7C8Bg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] proc/task_mmu: remove unnecessary helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ifwubqa5dppcdt4fgwng4mmxu9tz3x51
X-Rspam-User: 
X-Rspamd-Queue-Id: 1323B1C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1788974012-541666
X-HE-Meta: U2FsdGVkX181XkKVkbGv8FHa54qJRiJ0xuKG/LSYdhBrycwUsHqcGGOHqA3vhw2bbmAl6G9KwkHTKV7iFPqZ6O653otv+1AT677VFPtJd8Nf2giIfLBZaqKUNBxuSQNFO6UvH6QK18KvuwNI0ZlFGw71T5VOeUH9Kibv08FrxHK5ALQ1iSsJAQ0/9HcR48Zfzr4pEXmwJWeJ9THd3MAOevpyvXfkSKFoBTPp9OIN3vmd77oBXNnooCZb2hQwCs/jDscnFcdPpJqmAzf9GG1zvb9UwpWLQfZj9JQ9o1LiPf6POIzXkhgywZV6xsxqZu0T/BZkAyjPXLTLTu+rl7ROj9/wZ0ZJS2nCN4Tpowzh+gUvPaS87G/ePX4eSpwSG9RQEgEsUHo6dRoek9W70C4PI3rZOZureQpggV2Vn7weaJnkEqtaXJJpXol3IAavkCuzIQ3nIvv2osIP1Hl8m+KhfYjSqKyj0o++Yb22S6hO9LYe+8DBRd8H04Ur9wvxnmsj0wTPeSyqwp4iEKJKmjo0bEjJ8JdLbnH+wYGXIMcngcu/gpdb7JYrvp0/pTav9W93/bzco7KEZBqb+YUrIM0OrYEnNxleUJNFL04okUZcfTW/I5EDqlD4jikwDbl5ROJ14NFHMKT+KMp+6qyq60meQ6tRPr8VdCtV0fKfUQ75G95PsNJC5ZPy96yKLK0dTVYboGfze1Q9g0TO3kA+gYcYViLMUL7wn9XZEDR11mwYIaK23hbW4IeAUt2mJiLFqEo7P8fnhJ17Fl8lGSO6MZiz/uFA40LxlFilwBjKTWOSEdiYkrov98/9qWRJlZ2WWEH2/Zg++gnVa6HCey6AQEcdfVgjO9VN37fstPgIJd9ePYJeqZf5q2jJveC5Sj5KeIUAUPGdLiEIvaT0hOFRi2E4mCldowToVoOcO4sno7lWqlvlmj2h8Eu70/iqqo67BByfJ75pc2CH4fpC1dWOIYZ
 c+duo22n
 s8DBdKLE7ZCuk05EQSC0B2ZtOBzYWdxPGVYxVBHaASVLNwxegOYvinQaAt2UIZkBxveoJw95TaZKFvQ8D6U9GMEU0utaEVsUrErH8oL2PM20MYu/cHEi8aAAcKesX3pM8uRzJA7SosL5iVGl7PWHg/q3YNa4O3kqdIXUMGYk2iZH1XxASrQGjZiuDDKtysDOYufqNwN4zEf45enatC3ZtYqYvUVrcF2+VVy6CdwjQjOVrMdCqTBHMHb3zhu6Bd54V16cfQlfmM7T8e7vrLWRY1XFjSgl5z0QcB/Q1KUrulS+uv72ySSEHl39ClyhaSHZlNTN7VPuUaexe7jI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 10:06=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/7/26 08:39, Suren Baghdasaryan wrote:
> > When per-vma locks were behind a config option, a number of helper
> > functions were needed to simplify the locking code. Now that these
> > locks are universally available, we can do a little cleanup.
> > Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> > query_vma_teardown() helpers.
> >
> > No functional change intended.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
>
> As Usama says, this could get picked up early independent of the rest (ma=
ybe
> even as part of the other patch set)

I can post the 3 cleanup patches separately from the one that switches
to using per-VMA locks if that's preferable. One downside: I'll have
to wait until the cleanups are picked up before posting the last
patch, as it depends on these cleanups. Please let me know if I should
split them anyway; otherwise, will keep v3 as a single patchset.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David
>

