Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014DAC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 00:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E766B0005; Wed, 21 Jan 2026 19:33:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8B46B0089; Wed, 21 Jan 2026 19:33:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE476B008A; Wed, 21 Jan 2026 19:33:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE4946B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:33:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7309A1411C7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:33:05 +0000 (UTC)
X-FDA: 84357725130.11.614A8E5
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A1AF120009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:33:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dhv3FlCM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769041983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTMcoKF6Me937Pd2rtdqS2yy5B8sIYdJqUvW988w77o=;
	b=wUWMq2xqY2B14nSE4gix9h91ycYp3kaXjFscC+ZnpSHBMbKlxaBobgbzvd4/5y+htyp8D5
	1n1reBJVi9kPrjF68XhuATDjARGRwVvUFwZrvyfJbkwKbQaT6g26jfUYociHIEHXwEatY3
	pMm3qyLyXAgISIb+9fqsFHT+w4aJiW0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769041983; a=rsa-sha256;
	cv=pass;
	b=FXUw9MzBONYGndY6P2KWichBl51MClr/DiCHYVbpyvi6OyRDYdfbGKravv5XwfXV9HXJrs
	aLMCw/dmYmrzjZfmRO672cU+j8KJcqhKpqm+TUIJovlAPQ8sU/5jcDN25J8TMx+pGVSqnH
	zE+KJUDKZrHeif1aLBk1Fy2Uh0xtPcE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dhv3FlCM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-88a367a1dbbso6794976d6.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:33:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769041982; cv=none;
        d=google.com; s=arc-20240605;
        b=gRFttt3iKa+d1i3FsuSK/7qiZ5S9QXE4JVxeqdfuUEjGMtSSLM4cpL+N3S7S9DVjdO
         4LVHZup4QSTFVFjiDTyFXsrXKPkWXrXzuXUr/mOjgUR8PczalJ8kEsPIw3PM9gSB4OY2
         MeenHados4bbUfCHXttKeBB21Aid5/HLbwxsMeQRG4OVLnAXa5XAnGovPgZTZsiuuV1p
         KaccK0OgOfenzPi6x1vDuaS5lUw5H8OchPCHhkqRoXov5IPUHGycYo7y+BLLVF2M5Eo3
         QTqnhgXVXAgwrnjO1HFRPruV/WjovAC7VbMTWNz6TpLTTOxIxYbqDSKCyWBi4CXAfjDd
         xf1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iTMcoKF6Me937Pd2rtdqS2yy5B8sIYdJqUvW988w77o=;
        fh=KkKoWVFAnWgmtU+QXQm3niQRwpFiwHNFLbp8owpJs4E=;
        b=fMWv817YDdJmC5GWQKvJmSycBIc6eNVF3DMTQ7gyefyKGvaQDOB6p+2NcHDnkMrmeg
         TSX3N8AjoFuTR+cZqSnH7K6tElxv7q0y9qg73MKdFTadQgwnNXhCrwnLn5IBSyLPKRQu
         39CXts4Fyq4N0rxXQbttF8HEcOtMTdQlqt63BCC31JflCSeBzzO1kkaTYHwsd/AY1xEj
         lV2I8DhrJU+bC2IbhxUgW3m7rh2s8vkvNdIO/0LODHIjkcx5dZymfR7zpJnXB5WuhVgU
         TeG1zhGEkF3vfxXdrh81IsXwQlFum+hQEwY6moemyBHhh2D7hx5uexm6J3E/x3EQFw5M
         flCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769041982; x=1769646782; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTMcoKF6Me937Pd2rtdqS2yy5B8sIYdJqUvW988w77o=;
        b=Dhv3FlCMKYvuMHB6rq1SXcJn1BN3FK+qPJTlNrUtEJM2PDLUuCrU+t4UXpKxC24SeS
         qhLXv5mPFySSk3SCiLTqTQO/eF4H/kCa1GHSPEqZFIS7f8i4b0cjTA6DiBqxEsVj5Ijv
         E2NOC5VoPGZiJ2Cy/pWeWdsMjLkSvVQdBD/0eUA+ryEaLLptTj5Aj7KaLWfp3Bu+GpXg
         Wj9U1m3jUpI4YiIii387naZqCfKSOTEq6i87gXhaBCUde5/2H18ogTHVsGjrRk0otBk0
         A7anFcoFutU8nvQVxDPoBeyYcUW753GlNmWWxnnuoA1h017biZ+dbCE1jD+iITGmI+xQ
         VYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769041982; x=1769646782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iTMcoKF6Me937Pd2rtdqS2yy5B8sIYdJqUvW988w77o=;
        b=KTC3eqaKKoafcgytR949nYN0fhtWG6/JyTX/NBwGnF5r+HRznqK3Of4IMvN+7kZ4M0
         Q7XJPDU7jXAW+NZeGWY+YHikp3LSu83GIbnmVsX6vHcuetJThczcIsNn3BA6DScldrQA
         pjeYpi1PqItoPhjbQEZ4TbYjyJfsjPtMLgg5KmAXZlm9TDU4/r3nge9Q+O5dE28iKZJG
         dLBXsL7B6eo+VRZNuXdDSL/wcbjX1ZAmD/H6caDRtbH53F5TfyF4+X1asFehrtoGkgl0
         JcVOB1N/ghyajBRuxvx8+9f7weyjIl74MYhJY1nj3VjBvxUDXTAEtGCid4vM7H05M2Dx
         fFUA==
X-Forwarded-Encrypted: i=1; AJvYcCXgPg35mklzKvCVGjGamZ8FXfKKTYgSJbxEzDeFhtBJlyjr9XFJIHLC+2XDJO1OiBNLXFzsLrorgg==@kvack.org
X-Gm-Message-State: AOJu0Yy26xESAyab0+fJbNkdF8PnSmagtyHGFPv4k+s/QrRtOHjM7Lcy
	hNdoczE2S03nio6ExGXHHcTNzVpoteqkPNlTLBH3WQWPggIa496C3wQBUD9BXLM2GsutPhFFGm1
	BNxmzAeE8UTJhzjC9vmWZXP5dLTGJPOM=
X-Gm-Gg: AZuq6aJCCfp8QLdoUYIRFlCUZJ6YJVjQXg0352KvMdRDnXh7wUEJfQHkfENRBZ7+tjT
	zECR8g22Mb4dX9eHv4EKgqgLYVGZfTfGCB2ZG1wdVkzkWYRyoKTJ8WqtBBc+oiwoc4wXe+1fxCN
	wk55Zn6iU5ZJHda7t3CcJ5PMliWq8AVpzJ8HxXVaFuJCz/igCbKI29xEcnJsL1A1k/5wlcW1UH1
	xCVt606BbrMmVbojfPgscu/tSnwhYX73HmotrvVo4VpGUg4VVw/aD0DdKGzA9/xx4ICVEfd04Cn
	FBLo4K+snA+mqOTvCtfJTilFykbNlrZD
X-Received: by 2002:a05:6214:1bc6:b0:894:7405:d36d with SMTP id
 6a1803df08f44-8947405d41dmr51481776d6.51.1769041982341; Wed, 21 Jan 2026
 16:33:02 -0800 (PST)
MIME-Version: 1.0
References: <20260113081453.8293-1-akinobu.mita@gmail.com> <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka> <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F> <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
In-Reply-To: <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 22 Jan 2026 09:32:51 +0900
X-Gm-Features: AZwV_QiQiLo2nQtmjoCr7j0d4b1PHgJ9t-S3FgKnJWteMkQEp7_ATEdImoSoiDE
Message-ID: <CAC5umyjOgZE0Qpa3W3qZ=sSkwkuf_md47jctXgi5UKWuG49o1Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Gregory Price <gourry@gourry.net>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	bingjiao@google.com, jonathan.cameron@huawei.com, 
	pratyush.brahma@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7A1AF120009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bytumzq5nztqpafrokj65zt8yyaiwbxc
X-HE-Tag: 1769041983-593328
X-HE-Meta: U2FsdGVkX19BJyBiKwgb8DGOmo4a0F5L2x5z4js+SuNXmSkXH3kdAoEoI/8meFpBF25wKxIsIHiu9WXqICl/8fwau3IXZc7WDvSKosAtVLKAmSzK0zWjcD0i/0mpJ8en22jK3XnsCLOI/t4HJYcYR9u3f6VCFo8/KUIgUP5UYPhbQ1V2WUR5xKN7pH4qqM2Qm3ZS5bRtR0Yw6ZmvwOFVISW1j5I3Fj3FIa+RWq1q6zXUFpw12CCId71IU0r2KW8dj1C7mWXzKB4TNxKjGmEDX9SHv1/TO2utavDK8n2uj1uTUfX+BXGNmxI2W7vP4ogZ5Ijw2mn2WK3RVogGYScY0+/bAfZZ4E7FNY5SwyQ7IAkvhxPP1hjtD3lWM7h0u05QQU5bZoVBwjyMLxUulWGtcLd8fxDLsFS5wnD4yP36RIJuJdYJIZyGNaOIkEwvXNO51AJxzc1n60pIE0ppisZB7VxUmR6TglHpU8iHPZm7nrnXWmDo5Zf0Emp4H/ACDeEe9vA87me88vfnm8zalm0/k2d66V3x5i5nQPPYe4FwvOW+EPdKoo4VaqP2WkNMneR9lnp5keS9IgtgrVpOwkpzKPGJXjitojuLFAAsV2Y2gmbVJBJt/RvJfBFCQuGYdq1twv4SVqa1k46h42tAcHwqC/z1k3G0c4NwSYFRHL9AXjoPse3lSlP/OuIJJ89UwCkw0X/0ajiQjorSiPHY8kCCBUW/4QBUNh4MdMOYflJ+QkaQ2PmTnkXSf/F7UQ1Gy5nWa7e9tPVAiXqKSvRVhRlTJ8PIvHnn0avG55+o4fvDP34nLqvwuo8QsB6fNOUmXxFFt3oPUaH9pzANPJHIAEkgVaIkq+vZk/scS2QzG7NuH/BfqO4H2cZKBSjzlSm6flYiJZgBu+j0c6qnnUghmrE+ktrhFmLSccJR7O/BNnVHVQfct3oLBGycuYrJW0GIH8TbKFpGBmp0Wn51xgGDEsr
 E7Aoqg7R
 q78fQHFT9yMlpWtU8/VWlC5YyobgGv/Gy/ZzJiBOoSpw5C8knIa0z6mlbsu7Zdz4Tlja/UCkFvO2ilLLUbRiuyqQ6Cma3/m+mJwVptJuJrIr3VpOEMuEnvy86JTt6JWsONyFtYy+OQynoIn2GjmP3Q9qDAVw0G4F0EVmqfG01vYXtqcLd2neWWi+/1Dj9NpxfVuH7dV44Y8CLkKGlMJGNxWMc4BLygBB2USGrcgmjJOaV667knvPCFgNSYt6ccTUxH0ZDxlGD3CznKekvsR0ZRfNQOmNwDQtGIuVTfBbJfBJTLrucMMAWVwlprhwbZkStI+nd8RIPFUUjb3R+7CsM1bGKyIstc0Vbd7bCVgxEYUUfOa+Rfnjj521XnBKhgf0gGJgQ+/CDLa3WN3Yu8Gh5aE4KUToFznq3odyHdy88H/OC+E+EluKt9FFGHijQfWJyqWFYDy4ZjmALJ5lwarCMPK5jss5XKvexdYq56//8kudDlCQ4NhORbzLZUWXQJgyebBpS/YmT1wyHf367tPHere8qyzcUzGzfsT5NBYka/ytS1Ze1i8x3H25vyDLqxqgm+h+y3KUwgo74C/N7xuxPaSfjeqNvEpc1ZAydtj1ZIl/PLPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8815=E6=97=A5(=E6=9C=A8) 9:40 Akinobu Mita <akinobu.mi=
ta@gmail.com>:
>
> 2026=E5=B9=B41=E6=9C=8815=E6=97=A5(=E6=9C=A8) 2:49 Gregory Price <gourry@=
gourry.net>:
> >
> > On Wed, Jan 14, 2026 at 09:51:28PM +0900, Akinobu Mita wrote:
> > > can_demote() is called from four places.
> > > I tried modifying the patch to change the behavior only when can_demo=
te()
> > > is called from shrink_folio_list(), but the problem was not fixed
> > > (oom did not occur).
> > >
> > > Similarly, changing the behavior of can_demote() when called from
> > > can_reclaim_anon_pages(), shrink_folio_list(), and can_age_anon_pages=
(),
> > > but not when called from get_swappiness(), did not fix the problem ei=
ther
> > > (oom did not occur).
> > >
> > > Conversely, changing the behavior only when called from get_swappines=
s(),
> > > but not changing the behavior of can_reclaim_anon_pages(),
> > > shrink_folio_list(), and can_age_anon_pages(), fixed the problem
> > > (oom did occur).
> > >
> > > Therefore, it appears that the behavior of get_swappiness() is import=
ant
> > > in this issue.
> >
> > "It appears that..." and the process of twiddling bits and observing
> > behavior does not strike confidence in this solution.
> >
> > Can you take another go at trying to define the bad interaction more
> > explicitly? I worry that we're modifying vmscan.c behavior to induce an
> > OOM for a corner case - but it will also cause another regression.
>
> I agree.
> It surprised me that the behavior of get_swappiness() had an impact on th=
e
> issue, so I'll clarify its relationship to this issue.

To investigate what was happening while the system was inoperable due
to this issue, I applied a patch that automatically resets
demotion_enabled to false after a certain period of time has passed
since demotion_enabled was set to true.

This allowed me to investigate what was happening during this time,
and it showed that the system was not in a permanently inoperable
state such as a deadlock, but was just wasting time while
demotion_enabled was true.

I measured the elapsed time for __alloc_pages_slowpath() that called
out_of_memory() and the number of folios scanned during its execution,
i.e., the total increase in scan_control.nr_to_scan per execution of
shrink_zones(), several times.

When demotion_enabled was initially false, the longest
__alloc_pages_slowpath() execution time was 185 ms, with 18 calls
to try_to_free_pages() and 3095 folio scans.

On the other hand, when demotion_enabled was true,
__alloc_pages_slowpath() took 144692 ms, try_to_free_pages() was
called once, and 5811414 folio scans were performed.

However, as mentioned above, in this case, demotion_enabled
automatically returns to false during execution, limiting the number
of folios that can be scanned and speeding up completion; otherwise,
it would have taken longer and required more folio scans.

Almost all of the execution time is consumed by folio_alloc_swap(),
and analysis using Flame Graph reveals that spinlock contention is
occurring in the call path __mem_cgroup_try_charge_swap ->
__memcg_memory_event -> cgroup_file_notify.

In this reproduction procedure, no swap is configured, and calls to
folio_alloc_swap() always fail. To avoid spinlock contention, I tried
modifying the source code to return -ENOMEM without calling
folio_alloc_swap(), but this caused other lock contention
(lruvec->lru_lock in evict_folios()) in several other places, so it
did not work around the problem.

When demotion_enabled is true, if there is no free memory on the target
node during memory allocation, even if there is no swap device, demotion
may be able to move anonymous pages to a lower node and free up memory,
so more anonymous pages become candidates for eviction.
However, if free memory on the target node for demotion runs out,
various processes will perform similar operations in search of free
memory, wasting time on lock contention.

Reducing lock contention or changing the eviction process is also an
interesting solution, but at present I have not come up with any workaround
other than disabling demotion when free memory on lower-level nodes is
exhausted.

