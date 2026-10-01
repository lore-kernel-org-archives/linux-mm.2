Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21368CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 09:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8216B0088; Thu,  1 Oct 2026 05:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FA26B008A; Thu,  1 Oct 2026 05:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D596B008C; Thu,  1 Oct 2026 05:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B04766B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:11:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADECE1C286E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:11:13 +0000 (UTC)
X-FDA: 85273488426.09.73F3936
Received: from mail-wr2-f38.google.com (mail-wr2-f38.google.com [74.125.225.102])
	by imf04.hostedemail.com (Postfix) with ESMTP id B406D4000D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:11:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gbpzecnt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.102 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790845871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgYU5/10akTn1N7N2UMPo41lgQOn4bzMDShyewdR/1U=;
	b=4Ed/Y5z4vqpjJ0gaUgC9RFRdsQ+7GiQPtpzKnSevwwfR9x1W16YAFf5mRclpzVwhNaQmrB
	WONhqrdmBFduNC1yF3JF3vOKluW9L+qkFoi3pdpm3JnpILndxs9OtrY5jZzLvAK5I/robY
	RKYAP3mh7NZmV368vq5lQ8ac2Y9/0Zs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gbpzecnt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.102 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790845871;
	b=po1JTuhBog8+UjVA4Tx22/3pDx3vhWjmrSxU3yvG8GuPmjWma8Fy/dsxB0ycbAFBdm8Io3
	Cfju+yTw849t4ULZbMJtpnmY2L/p2zc7s0gU1fHUno6cn5lAXprX+Y3Syp5cUXs3OPykzF
	IueNSpFkHEgDJv/bv+GV8mJkqhd3JfU=
Received: by mail-wr2-f38.google.com with SMTP id ffacd0b85a97d-482f6350f89so3818134f8f.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 02:11:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790845870; cv=none;
        d=google.com; s=arc-20260327;
        b=GJReH/YaSLzKTfFNhGk0mpqRFgjRFfrdx5gN9C0xZErM2ZAF310cJbBvoZRTfaKkrc
         UuRWjzV2Au2jfvo5RsLI1hnpyrHhuhcouXWWvVzS7d5z7XvMECpcloE5HVSKZNewKBMR
         yKGyxEoFTG8NjB6K8HsNfBu4L1yWiiJyxx1xA9boLVi8Q0yAAS/pPmWY2N5kHxdK0eLq
         0rkrVFHEic8vD9wROQQyb4+FM8cPYWadCaKFVgXBGLQD+GrgGBioabfw+l9SFNjyZHnh
         lcqGjCE2OcAGZfkAm45xVIUROZmcgvaGmBjdWuRPm9InFmH3wHRC9ELa0xZdb8+fBKT0
         3mvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sgYU5/10akTn1N7N2UMPo41lgQOn4bzMDShyewdR/1U=;
        fh=lfA1nEu4ULhOM7ZEBE8B1a1czjzONTXoWWN+x8o4X+g=;
        b=rkcfz+fEpIXqRUQW48ptJuivLfdBbyiLGuGgtCOsHgzlsVxCsRzryYikK7Zq7Cbq6b
         Y0a10b4lRIty0Ftq0oHsqT0UhxhMpZHFmVCbk9KiEbZr2bdWKICW/46G8ELAFwKYkC8l
         w9ofPX/syhUKvUeRexAUUStB0F061jsSL2VYxFwdZgvB5xCQq3i/m9MMxDVU2YywxGfp
         WxaX1hNDF1jtpj2eDF2GkFt0V+lAm8VR5UOBWTD+6hZ11D+zxPWca8rqW3pF8+YmJE0m
         Wx+WyVIxg/T6nSr3BhacKy6jfWdTw63nY3La+HvOibhs8akmxMcQ5ZZbO41+JJPA58Gt
         dIMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790845870; x=1791450670; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sgYU5/10akTn1N7N2UMPo41lgQOn4bzMDShyewdR/1U=;
        b=Gbpzecnt9oGreZ6lPoOTN6VAK5SC2wefcpn2//FauNopv2qAl1JkyXO+7cSB/kdaCx
         qziSJy2kyUwvPcMBXXyOBmf3ETLT68HimTegVkTmiehq/Xw7xpOtuy1Ox5rzZa7NBq9A
         QaTZMBJfjOoIMZNRqo/q+TVAo+X4wLy+XHAIUGtmWqzuNuNpD5tUbRxFRBoTazPsyilG
         CP1yiLXHqTQhneY1uFrGLwv0p9uiDruS9dchzfOSLm1P5jh3x9g0zNgm2MRCEwpBqmOG
         esSAYQ99GXkneMG9ysJWUVOxKVR9EGTVHWLVjqwEXNSeQ2L4cW8j0lNRL2KnfPw6Jtf2
         bf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790845870; x=1791450670;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sgYU5/10akTn1N7N2UMPo41lgQOn4bzMDShyewdR/1U=;
        b=MuFx34NExHawdhnM7LwOPPMnIVZ0C9TgZsyaQbIZ46mNKiWMAr71UkT7kZkbnJTRna
         MN9LOubAtwpDguQQaQU4OWvm8W9uTIefDPvn1vgIj0Wc8LPYHktXB8pWpUN4RXrgqlFj
         6tlIH6dFpP34yptraISYWFtjiRkUhW+W4aCXoGXhrLhf0CriGECvmcvMB7/ZpHxWnTKu
         8Q/AZR2tKbMyxjTFGJ7EoFAiSh3oVzsKuy664w8kvsxsnIUtP25MiRM59LKB39sWAGB3
         C7PWDeu8D6B9TC2UKcjsu9Ld5DaC4bmGW5Y7M3EOGoSR+Ns1rvbt6HQU8h4uWGK/6KTd
         Ecqw==
X-Forwarded-Encrypted: i=1; AKwUvBwMVbiMZQeI2k6dxGnkO3oZHiJ21JWBPlayEhvOnYcFZkAqIWfezFN4crK4aYviO+VPdwDeXVfssQ==@kvack.org
X-Gm-Message-State: AFq9FYLUPpAm4YnjhYWMHyEkfM9n7I3E+DHXCbg0lwxUrQ9AQ01/lK0K
	NqX3x9/0zu0C9qWDGEJ8Tm3xGWuiFOdkuGgmKjQ5ZwEwZQkLWcqNs7iZq477Pe7xwC3P51srRo9
	KK6qg77riUpp6YgOOjuuSKT58k8rE0mw=
X-Gm-Gg: AYBFou0klWz1DB0UQocJ8/JCaRGNcrWbr4f7OnzrHon6wpSCSXlOHXb89XN51UAIBKQ
	qvf1b4quE7ui7dZeTnk1QeVD9020nKrcopevxaZRHSIiqoFwmW2wIMbSHHxLyV/XNfk2i9vIvrn
	m5G2QkKC+lVIoM8L2r769LodNKkXl+4k+TFqRiF2X/VrSsQBiUU4e6k13BN9Gcd2NUAYV2dOw2B
	ubR1ssoS1+bpNdm3+zmbGKu9vRgofscU62l3PU0pz4EUxxAgB1RwgiLt+e1mS60dZrygqoRYj3K
	TQS4xByY8VeRzNNZNPSk0IqnjeQcaESJRvXb+Uo7Pq6UodfyfJNIGirjlIGbyMXM1zoFThtxLOs
	8Z8ELhCFHH99qKxWuhUaWCbq51552sO80k9UX/TM5LZqJ03dVDYAF4JsbaRVaQhA=
X-Received: by 2002:a5d:6f1b:0:b0:486:f778:6c85 with SMTP id
 ffacd0b85a97d-48b0244dfc7mr8070734f8f.6.1790845869891; Thu, 01 Oct 2026
 02:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev> <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
 <00d07f4a-f679-486f-9413-6917b5213854@kernel.org> <CAJnrk1bD+4tndrOWuSENvEb7ody47HL2aNv2n+RzUqDE8mpkrQ@mail.gmail.com>
 <CAGsJ_4xWC4hg_-MLoDn3Zav7NUM709gu1jPeQpRuODdt8OUpZQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xWC4hg_-MLoDn3Zav7NUM709gu1jPeQpRuODdt8OUpZQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 1 Oct 2026 10:10:55 +0100
X-Gm-Features: AclHuK__67srLEi5NLNp39j3Kxawd3EUgwRWFl-EuVgoOb2YFw2CtCsUxm6L1_0
Message-ID: <CAJnrk1apjnzi2T7+eN4Kaq=xhBM_nZTpxmzgqcSp7ECpeOd2bw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: q3ekyumengna5us99t9d6ffdxzajd5fo
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B406D4000D
X-HE-Tag: 1790845871-108153
X-HE-Meta: U2FsdGVkX1+1017AHVV9xF/XERUZl/cz5hKTcdfV5JXfrN8z82Z2sYWgYXtjiXWbJ4UFeX5xdYXm0hUeuvy2gto9y/7f7b6o9pdUrOsY2/WMKtfH9I/HHKnbn8jXsz/XiDqfpDciTbV/yECu5NoQpQtH0S8lS3sTYBG1UlYbC+zfrfyGv55SwXR7KTMpUMpkVl18RnRSe9ziWfSMlxQ+q0m/C0DMrD+P1mHPmC+KU1+DaQzh93BqIGD6oIUoYEB0AZPUlhmpKZY7AxkGUKq116fGzR/wKYmPj+R/FOLi0aZfpbff4FYBPybZof++fgjq8j2ynYlZHv5d5Sf6llD0UR67QLdBNcU7vTL2ChnfTzG7hKvlvu3KIfmn01JgxfCc03w/PnZqTJB0yhU9sCavVMJZmI9fxtN4iDLnnXpHKPJkOdEfg5ss6agKHcilcQ+/r+uQi1PDs531+GQzdaZPLfEljNCLSyAkaCrSZlILGz+z8qVDgBFoXX/NozMN+GD093DC/9hkMCzgwxsufa/F0wIY709c+qN4ElmnTsiXFLy258vUEzczcE+DCGYQ4EF077cbrynCJOp4BsHSPnAuNay/s5Q/JouLKDUvQW+Ga8OA5I8n+Z4TRR0YoeFzB1WxM/99zoUcKym77wfYi00PBKDHDyHScetUp0xPlYAvds6XChIdf8gVOrTSFjD8fB57q5IalN4oH7maHx8O6Dg/p/KHM3lyg3BIQY3XNxB+xSymxXz7Z8/VYY4qVVrtUxfIwl2Qqwd/CqY27qoDxJPJBBACOuceklFtTVdV+J3EwxTVURV604nv7Vv0TDlcOQ78roghmEuN4pwDfBzeEaJ5lx5O/oeXcWQspsX39p/zsRQOQYCYGWHdUS1PAJ/ZsCoV6xABzwQAHoiZSIF/4vbSCkcX1JRJ9jENu5jnqpwg0iWleKdGitS9LLGKI8Kc2ZV8/mR0PIuGmzP6fK27nTY
 7X1oDjEz
 hMg83qexLFh8MEtQ0H4OC66hzNGxZUXv6mIiJlmghnUtF6hhi+7GONai4i6KC/QYsKX19gheuuIByk0MEwqPdxnlZcJ30SDBaHg5EwIk22Q21zspxIiEqiilRi9PsSMzk5vTCFAdX7kw7d/qfFMGeX7D5xsaMVfDBuISe69unt5P4S5GUpzVCDMTa4uTHilm0c9H8sJcUNIr/xCjSQ/fDCKRkORZBzNygz112wpy3Zt9Z8cpkpfw1ebihRRML5o4Uc9rkudG0+kzuDY5vPr2AWKIXPvwi1sxAdakcfIkE/6u1ZaMbOel1GsQUEELydAk5SIvddGeHSLB9oQXNXrAEZTKQft2YW5ptUyCcMtckJ7KAMHJLm0F2PdsnwCjIlumEdheVp1T8LPml4xMv9HCi+rT9mb/Qlg1Vkvngvr7HhDpq4VPZ3AgA3XB2VdyGRqJug0Ie
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 9:03=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Sat, Sep 26, 2026 at 7:47=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> [...]
> >
> > Based off the benchmark results in [1] and [2], I think the cutoff
> > needs to be at 64k where we exclude anything under that. On 4k base
> > pages, this is order 4, but on 64k base pages, order 4 would mean 1M,
> > which I think would be overly conservative. I think it makes more
> > sense to express it as an absolute threshold value instead of by
> > order. I'll try to find an arm64 machine to double-check this on.
>
> Hi Joanne,

Hi Barry,

>
> I once recommended a hard-coded value such as 2 MB[1]. Would that work?
>
> Maybe 1 MB or 512 KB would also be fine. I=E2=80=99m still worried that 6=
4 KB
> is too small, especially on machines with 64 KB or 16 KB page sizes.
>
> Also, we could have more contention between lru_lock and the deferred
> split lock, since, as you mentioned, folio_unqueue_deferred_split()
> is called under lru_lock in many cases.

For my use case (64k base pages on arm64 with 2M anon THP set to
always), the >=3D 2MB threshold works. My one reservation is that on 4k
base pages this is effectively a no-op since 2M is the PMD size there
and those folios are already queued today. I agree with you though
that it's better to err conservative. I'm happy to go with 2M for now
and revisit lowering it later.

>
> smaller folio sizes make mTHP collapse and the underused shrinker
> more likely to ping-pong?

If collapse and split use the same scaled value, I think they're
self-consistent at a given order. Right now there's no ping-ponging
possible because mTHP collapse supports only 0 or HPAGE_PMD_NR - 1,
but I'm keeping an eye out for Kiryl's patches that'll change that, to
make sure that stays true.

Thanks,
Joanne

>
> Just my two cents. I'd also like to hear what David thinks.
>
> [1] https://lore.kernel.org/linux-mm/CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1=
RuZoBeUBR1iFqOA@mail.gmail.com/
>
> Best Regards
> Barry

