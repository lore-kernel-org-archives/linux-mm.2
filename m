Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC15EB2700
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 23:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C931B6B0089; Tue, 10 Feb 2026 18:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D1C6B008A; Tue, 10 Feb 2026 18:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FF46B008C; Tue, 10 Feb 2026 18:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A18E36B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:01:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 564D81BF2E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:01:33 +0000 (UTC)
X-FDA: 84430070466.07.FD71C6C
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FDCC80003
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:01:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dt8ZNTSY;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770764491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gdZ7g+y11yA/yc1S8C5vrwqug7WtAPc1WlCmDFfWbg=;
	b=7twHXqsrg6q19x9EZX3zy02eYQGfjDpul3qM8MyncthvAmazlCbfyL6hxHsTxFjvt3Ushk
	XS1JlH31LQeiocIb4vxXyXJCoVJsPTI187i9q/v+TnY/SeOq4dt7zUQANrrGLz8iESNkbo
	pMtan9tsp8Flp14uAFAe3WnyT/mnjBA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dt8ZNTSY;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770764491; a=rsa-sha256;
	cv=none;
	b=mhf1Xayt34CjqTzG7fjqvfMhF/muQ4opFugYoa95wvOnuDRDpNwrGL6vRBXTU50DrBXrZD
	/6j8G+uZTRFq3HeKusgb798MhSeYzaK5FTvT+AnAZGYYGGBqnQ04IGOX+wswsDdCc0Wx47
	aIuSvwhBmnklwAuqQsxlOVdLQ1gx26k=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8951c720496so9990966d6.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1770764490; x=1771369290; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+gdZ7g+y11yA/yc1S8C5vrwqug7WtAPc1WlCmDFfWbg=;
        b=dt8ZNTSYR0+I2zn4nWBSsUT2p/nKMg/J9TIdHumJmoj1Y936qwxRP6xgPmR5yp/tRv
         qVhqaP4I4+HJQRs/ii7k+dJ1qCad6qWKCMazna19HAR6roYigTrvdkN4LA9bMjFi1liz
         x5S0pJTVV5CUGYBLShlZkd64dQ7yf0R4lBjwuk6vLsep32KYhAyJdl6WYWymkMMq72t+
         b5+tgGaa5t1JSF7XSMAyQ/twTexWQ3NZpd4cvqVd5SbwBWpMKikLflLbdO3fARqjPyyI
         5hTWvspXeibg5LTLH327vjKa72KJM0iurfSeienaLV8QIOI9mI/taVvkmTEPeMQTEMVP
         CsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770764490; x=1771369290;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gdZ7g+y11yA/yc1S8C5vrwqug7WtAPc1WlCmDFfWbg=;
        b=M258bik2YfHvJBM8J1EzSFP/tqZwHbAZaiinowH2aShTocPuc+5rD9pxLWzNTyY3L9
         psfd3bRKTYZqoNPoJcKf13X4p3hHZy2flWg5Dps9NTYHO6PPUvXQMt1XWXDrZ0otNHiH
         KWdMSaP1D+C4mFWeTNLQRjF9ks4bMKCNycGFHfXt1ffWcvLRcqTZ/0OINJpa59AaQo1Z
         bY7VpAk+DuvtOj9z+/fd4pAvDA+HlSHZukaZ8hQebR7B+lT8CBSmpID+2uGqFGRr00Wb
         AyoQBeU6/cAPwPr2gKGHDa6pCszfc8f6vzxOMkE1YW/4bJSpMNZcoiKv9n4YqPelenlx
         qd0A==
X-Forwarded-Encrypted: i=1; AJvYcCW+7XEasD2xv8IMRajq95YpCEx+Gjt4kurtlcBpqzKlb8atl60J33ZUYTUnn0cV4+gkhzW04mJfEg==@kvack.org
X-Gm-Message-State: AOJu0Yy9D8bBiPczZnLVS+iPhREYrMguUs1PyVKvrlF3T1KDxZ4xvz9I
	IRTudtBJee3hvoX2ci8LHicXZkXj8n5Hz22cqZ9xIOq9ARUGz3QLxjACsS9PyxH2QSQ=
X-Gm-Gg: AZuq6aIEy9bIuRRM66gtE3dFLWFM0w1n/rBi2oSDH1aJLxgdFiwwWrGgPQ9gQWnZ3Jr
	sszIi9oFDa7nlQjNtO9gtOCx5us/ib/Fuq65c591Qx2EWs8LOyq/TJkjaUdCQ6eCMIpTlGLjMlK
	ZSwYHf3+aVN6vVP3L/U3UlKqDHFOXWUwDwl1QzUgz9kSqljxB5Yjxnvdui/z9it3EVGwkhS5C9y
	MHG63SMrbFhfYVLDKMAWFgR2H6q0Q3IeG1y1hSNImgvcVSP7M4n008HUH7EtJrikynTKpYfYOhv
	m28pSExTQRouk2N3DioiPxZZmCxOTJf3f38hKUIbuIH4sEJAa8XUiR2mzQtfADm1zzFNat5rWLJ
	I4cYY4TzYuIFR16LOGF65MsVr94TDlViHTitnrUDL7zimQx/uwa1XkaUX3+JWwgjRXnTRUNh4Zu
	yMG23IApJ4PPnF8wzhU0aV0YSCPRG9XOs=
X-Received: by 2002:a05:6214:762:b0:896:fbdd:ef02 with SMTP id 6a1803df08f44-896fbddfd6bmr128746116d6.3.1770764489838;
        Tue, 10 Feb 2026 15:01:29 -0800 (PST)
Received: from localhost ([2603:7000:c00:100:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc7f2a5sm600336d6.11.2026.02.10.15.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 15:01:29 -0800 (PST)
Date: Tue, 10 Feb 2026 18:01:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org,
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	christophe.leroy@csgroup.eu, pavel@kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-pm@vger.kernel.org,
	peterx@redhat.com, riel@surriel.com, joshua.hahnjy@gmail.com,
	npache@redhat.com, gourry@gourry.net, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, rafael@kernel.org,
	jannh@google.com, pfalcato@suse.de, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
Message-ID: <aYu4xK8HhjO7mLP8@cmpxchg.org>
References: <20260208215839.87595-2-nphamcs@gmail.com>
 <20260208223143.366416-1-nphamcs@gmail.com>
 <CACePvbXsngZmn0OrJZjvMhhHnL5FazxYX7ShEpbU9RwHSJaUuA@mail.gmail.com>
 <aYqZppn4yDbTP2_q@cmpxchg.org>
 <CACePvbWnJFkMOtX8LbL+0hm5RP6jD5nfZcYUyxrJsPNTq0vbPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbWnJFkMOtX8LbL+0hm5RP6jD5nfZcYUyxrJsPNTq0vbPg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: z86ztdbi6admcfb97566ef8e9y935sws
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FDCC80003
X-HE-Tag: 1770764490-275325
X-HE-Meta: U2FsdGVkX1+0IygvJEeRGWtsAm8EfuI1go9dGzaQUO9Fo1dPsjzdpF3025wgPSlkWG6GtbW6C4j+FdyYaWULiFRPfqWc2Dr2uZEoZR6EEHcYKOAlwirBN/EZHqKJ7tj1Q20W5e/F6/Od0RfAEHCz5HvOQhmXT0VM1r7nz3Q7ZWZK3lply0iiBUBCJV/tzDFCS6K/y4DwmQUVfmq6RCOe5DYNCMShVNLyoi+gj0dg+xizgmgw2HySiI6CDaQBzpwLVFkQSlF0IVSWmlQpQCZL/ysLQoJCv42IHV9by801qFQoPuRBL6AWbvgS14299dOiAmwRroWckdAxLaIA4zKmG6+9N2mMUE2rWcQ2BSGjNL1aL2xVd56FI2mgGUkyroyw+bLBph5n08dle+aVkqlC/SkKaumyNDA1TkvWLsSpT1Z2Fn4QgXi8QIhZN2WzeiaH1hMZvttVeuQrkho8grok2NoNL0P53iNuDMNUpDGueAVsqIujOL43Em2YwRc6AOUP89ljSrXQbrxd5d5hnry1ad6T+2vvKz7IOdjBlE7HHyOhwBGO8JzxfYaiXlOPC2hRmdnV8E0KvM5g3b+xYVNQlmlS4WNu3/TQp8l1RZOs6gpNeCRKHQwU9XJbeCDdAfHBHDtUWcqLlJ3NE18tSKy2BfbSEij7GAqkBoXSoUWT2prQoE387AF46nbXhrWRT0XGAL6EFifuOknQ/Vl+LnBD1P+9UOGtBPD0kTlBmE6hCcJdvucshc+/3QVx1Vk5H0uGJfhMCrETgDbjQ6/VBU6ikY9ZHBfUk7dTkEhQzJq2RR4X3PKBoUgiZWTsPLZX2QTBqkTNedVZJZSVpmamDisB+6VIRamr6lw+f15hywyTALxaFBxtvz1C0jx+uYKKnn9yBOGQUnFGpMG5iKzB8ujuhJfU5DKkAsagAwHDxz1gHD6UVsyO3VmRE+JsB9MXXEDQp6sz01ByZISbpF6+PYm
 UPO0sZcF
 yfoHfe1AIGfADP0oi2KuFOvvZdZrbq1qckcLAwHKlnevK3jHUMH0+6CLXmC8mQB3Zj6gHA1oO+6LfrxbhLIWdISGlrIt9ymVPhSk5/dKk8IMYi8hGZ35JsTJNwRdSnynXkxtCC8t2kxhaAaOCZnGgMppbrcckAouI7ns058Lt3+y6y9lZCRTEp/vohq+RH8BlCLvNaEGvd0mSE0t27EnQZM06VgFpwQxBZbDKl6D+9NgZUvBfdKYPk1VKjKljnHl/VVmrK204cMHslm0Tfts/AJ/oU6KV+zbcrmdr6Bi61ATX2gfJtvukhte2CIkG/W6+TwC0sCnBnyyXt6RmiAo9jZGxocSWRwS7Gaj+oi8ruYdhmOxEp2uzO2MSQsFScXXVEfhBGt7n1eG1bUp9uVX688PUM+JABF+69eolpOeM8mWm7JR602xvr5S2bndiXGtCb7YDbcKe/nddoL2alqBVv0inHr3GasWFeYrWiuBHwp0nA7x8NSeVmLlOE0nWcUjT0YeauSUKjL3nDiCCY9ZCD2KsEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chris,

On Tue, Feb 10, 2026 at 01:24:03PM -0800, Chris Li wrote:
> Hi Johannes,
> On Mon, Feb 9, 2026 at 6:36 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > Here is the more detailed breakdown:
> 
> It seems you did not finish your sentence before sending your reply.

I did. I trimmed the quote of Nhat's cover letter to the parts
addressing your questions. If you use gmail, click the three dots:

> > > > The size of the virtual swap descriptor is 24 bytes. Note that this is
> > > > not all "new" overhead, as the swap descriptor will replace:
> > > > * the swap_cgroup arrays (one per swap type) in the old design, which
> > > >   is a massive source of static memory overhead. With the new design,
> > > >   it is only allocated for used clusters.
> > > > * the swap tables, which holds the swap cache and workingset shadows.
> > > > * the zeromap bitmap, which is a bitmap of physical swap slots to
> > > >   indicate whether the swapped out page is zero-filled or not.
> > > > * huge chunk of the swap_map. The swap_map is now replaced by 2 bitmaps,
> > > >   one for allocated slots, and one for bad slots, representing 3 possible
> > > >   states of a slot on the swapfile: allocated, free, and bad.
> > > > * the zswap tree.
> > > >
> > > > So, in terms of additional memory overhead:
> > > > * For zswap entries, the added memory overhead is rather minimal. The
> > > >   new indirection pointer neatly replaces the existing zswap tree.
> > > >   We really only incur less than one word of overhead for swap count
> > > >   blow up (since we no longer use swap continuation) and the swap type.
> > > > * For physical swap entries, the new design will impose fewer than 3 words
> > > >   memory overhead. However, as noted above this overhead is only for
> > > >   actively used swap entries, whereas in the current design the overhead is
> > > >   static (including the swap cgroup array for example).
> > > >
> > > >   The primary victim of this overhead will be zram users. However, as
> > > >   zswap now no longer takes up disk space, zram users can consider
> > > >   switching to zswap (which, as a bonus, has a lot of useful features
> > > >   out of the box, such as cgroup tracking, dynamic zswap pool sizing,
> > > >   LRU-ordering writeback, etc.).
> > > >
> > > > For a more concrete example, suppose we have a 32 GB swapfile (i.e.
> > > > 8,388,608 swap entries), and we use zswap.
> > > >
> > > > 0% usage, or 0 entries: 0.00 MB
> > > > * Old design total overhead: 25.00 MB
> > > > * Vswap total overhead: 0.00 MB
> > > >
> > > > 25% usage, or 2,097,152 entries:
> > > > * Old design total overhead: 57.00 MB
> > > > * Vswap total overhead: 48.25 MB
> > > >
> > > > 50% usage, or 4,194,304 entries:
> > > > * Old design total overhead: 89.00 MB
> > > > * Vswap total overhead: 96.50 MB
> > > >
> > > > 75% usage, or 6,291,456 entries:
> > > > * Old design total overhead: 121.00 MB
> > > > * Vswap total overhead: 144.75 MB
> > > >
> > > > 100% usage, or 8,388,608 entries:
> > > > * Old design total overhead: 153.00 MB
> > > > * Vswap total overhead: 193.00 MB
> > > >
> > > > So even in the worst case scenario for virtual swap, i.e when we
> > > > somehow have an oracle to correctly size the swapfile for zswap
> > > > pool to 32 GB, the added overhead is only 40 MB, which is a mere
> > > > 0.12% of the total swapfile :)
> > > >
> > > > In practice, the overhead will be closer to the 50-75% usage case, as
> > > > systems tend to leave swap headroom for pathological events or sudden
> > > > spikes in memory requirements. The added overhead in these cases are
> > > > practically neglible. And in deployments where swapfiles for zswap
> > > > are previously sparsely used, switching over to virtual swap will
> > > > actually reduce memory overhead.
> > > >
> > > > Doing the same math for the disk swap, which is the worst case for
> > > > virtual swap in terms of swap backends:
> > > >
> > > > 0% usage, or 0 entries: 0.00 MB
> > > > * Old design total overhead: 25.00 MB
> > > > * Vswap total overhead: 2.00 MB
> > > >
> > > > 25% usage, or 2,097,152 entries:
> > > > * Old design total overhead: 41.00 MB
> > > > * Vswap total overhead: 66.25 MB
> > > >
> > > > 50% usage, or 4,194,304 entries:
> > > > * Old design total overhead: 57.00 MB
> > > > * Vswap total overhead: 130.50 MB
> > > >
> > > > 75% usage, or 6,291,456 entries:
> > > > * Old design total overhead: 73.00 MB
> > > > * Vswap total overhead: 194.75 MB
> > > >
> > > > 100% usage, or 8,388,608 entries:
> > > > * Old design total overhead: 89.00 MB
> > > > * Vswap total overhead: 259.00 MB
> > > >
> > > > The added overhead is 170MB, which is 0.5% of the total swapfile size,
> > > > again in the worst case when we have a sizing oracle.

