Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B951DEF584C
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 21:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1246B0005; Sat, 14 Feb 2026 16:36:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234486B0088; Sat, 14 Feb 2026 16:36:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CB06B008A; Sat, 14 Feb 2026 16:36:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0089D6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:36:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94ECDBBE9D
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:36:03 +0000 (UTC)
X-FDA: 84444370206.05.88DF1E8
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id A4F5840007
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:36:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SZzdjwYC;
	spf=pass (imf17.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771104961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ro0ZhP/FlNj+GMkv9hkfY7zWnxPHN/VgorELWyYQ2EU=;
	b=BA0d7HJvN2HNxOU7nyLWBIGsglboZrdSxT8WNYdNuLFSvEiNoyQRKb1OJ6q9A+fUVtT+wd
	KYXvyMq+aVOjjesYD0Qelk4FgUo43zf5zpvy8iyUfXyYiux7jvx1Wph5y2zXoGO3gzvXjU
	pLSqy1SaPdSU/fQ6YCOZFp4yWnyrBLE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SZzdjwYC;
	spf=pass (imf17.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771104961; a=rsa-sha256;
	cv=none;
	b=TbN0cNEvJTBX8yiqz0I3dtgrcWsYZvBfyWIdS2iRZAwhfIdb7SJKrwSJkxIPvQz3wjlquo
	AwSVhHUSRn+ojGcDBEsmhnRZ3II9fu49u3EP8ADvNHFA5/3j9sPwAUUvBduWhbiD+/Eza9
	/uLBKqFBp3NIOZ+NOF0PBuALBYL32nA=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-482f454be5bso38103075e9.0
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 13:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771104960; x=1771709760; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ro0ZhP/FlNj+GMkv9hkfY7zWnxPHN/VgorELWyYQ2EU=;
        b=SZzdjwYCfL/+f9DHUizJhatQlL6wpgSQtjZLKhJL7z1lZxGGO4qG7EYFBGI/3pd7V4
         NZCpIF3gIpSCHkap03YRcE+gGC/UuT4UygrASa8K3StRNss7YM/bHLdkEPjs2s3rVFST
         QXCh2fBN/P5/yj1uirZ78/iGqiLomdxh3iz9AUptzCZW8oUQkk810qPBRGDjvFgg9fhw
         waCXwCjJBD9nV1v/YuLRyuSnwrW17abJmfhThb5XP677942lmdeWGOnbZuRvfQnSie+d
         dA2B4uiPAMokPvTBUmcuf1DTja9K+/NHVcffdgtmdQmkrRXHYBFkLCHVfgjf1eU1fpaL
         j4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771104960; x=1771709760;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ro0ZhP/FlNj+GMkv9hkfY7zWnxPHN/VgorELWyYQ2EU=;
        b=VXObP9mT/PpII9LHNLAgBrekHJc5KmZGVf7tiYRdnLhXJwW+jmHWgLY2mQw+BEpjM6
         MbChQvnESs3HjbseB7I1to1xoAvguHG9sIU86R+lERhB+tEGMIWIEBR5T/j9TJzcfpOF
         4Vk/wlBIa2hBhco6cTMP3wlXwhtqosdskGkDIm+gHR+HaBD+2FCJnXrUaOSD3CSAi4fM
         fTjBldOxLgm/XkwI3JoH+X1ncchjfs4gb+yvYEJt0q9Juc9KRA/ZlP35/+H/ORMoNjRS
         q9yfPyhJBJjAGYfhpevIS55jM6nNnBuYO6PuMy0fMcXMPnSvefZ+SGoAzwpBp9xRRlzl
         Xm1w==
X-Forwarded-Encrypted: i=1; AJvYcCXVDc66r+1zzfu+Q05+3uybAuuokIS/GfJYJvLv2UzK9Kuo0zkyKPcBnEpZSo80ulSJzj8Auaydkg==@kvack.org
X-Gm-Message-State: AOJu0YwX6p7YVtB598EOB4OYY8SjMp8ZcSNDs0WEjn/ZmSDGhsZRE7/e
	yl+C5znutQWQB5DlP2LjlobAo0s4iakqnCz0dKrAI0Nrp8BCmatjxtAV
X-Gm-Gg: AZuq6aKkZngrqzjKRXbmuVTrW6jhoyCRIT/AQyKsTouoZhmh83E19KYdeUsmUY25zTr
	KaRihVPpSivRVS6gckxAInyu2VwJ7rjoPsLTJf7VDFK3Qnw2IXW5T9nMYRtupjPpf1LHqvWF882
	EkxD1Es8GIA/gV2nfKSgc3WDRFuwfUyJIKj1Oi3uZa2qyfHbgQf7/bAFKOOfzOXDOJHw909lEO8
	XxSe+O8J72RNYZS+LoaxFy9Zu8oJOe1s9xIRaAUxHjVanrqPCWMjJfQq6tq0hNoLFd+Oygia4Dv
	xg3+98rcZkWmLly2UL+uH56idEr5Ir+9XvEPdCcSWWon26bbUslajQ9wo9t9ZlIwF8mAYx2QJHA
	DRGiBWQMRY69UG2u1aoLpKjaeeKCR8DK1U0ZVa8zdBqLZLja9/PGmABudhkusBoWmqPGDFhBUJA
	K0WTDdsxBP45A8DSU0fHqYrJvhjm8DpYJWdj8=
X-Received: by 2002:a05:600c:4446:b0:47e:e38b:a83 with SMTP id 5b1f17b1804b1-48378d62a9emr67568155e9.7.1771104960057;
        Sat, 14 Feb 2026 13:36:00 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a4ffafsm49226635e9.5.2026.02.14.13.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 13:35:59 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Date: Sat, 14 Feb 2026 18:35:58 -0300
Message-ID: <aZDqvsUt16ZjB2YM@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aYxx6cq6he6jTIZI@tpad>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka> <aYxviLoWsrLqDU7o@tpad> <aYxx6cq6he6jTIZI@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 31cep19epdxu119eaccndmu9mkw1e5of
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4F5840007
X-HE-Tag: 1771104961-644582
X-HE-Meta: U2FsdGVkX1+fEOE36ydviuwk9eZ/xv4zTIPiK/ZP16/hPr8r+EeP9LFXWiDPF1ogErVSmmlbWOiUSD94Cvr3u+TWw1JhO9lvGNoFY1W14bkGY0RErfvUVkKmesMYIto1w/9fAv/oRs3k8ApccmD9sJ1at7JlRKOtnJHfWwxbpRKyHG7tNIddqdBA98Omcu+XGBGlPPgN747CtNt3pykKe5ZqWa7DeBmsj9kWzGoI/kW2BQonTbPB/JJsEayuqJntp2WL3OO3LOglnJxAcqfck94ZJKtoKeGjNjqNbRNZz7ZdGSNIfozDUI0Zbtu/Y9uQVQBDFo1a11Yyo73mQc/pTj48t8P0wxIRPLLC7Le9RohnRp0w7jH9jQ5el/aWrSlTswgpz6NCK31dCu4dQOik0aZe+PcOy/I79n3Vgx2ToKj/dMGR4n855ID1Xylg/WHPZmQC5/XM1peFmnMgAH56RS/QwDJysPXE+bgEAPRGNRMW82S7j7aWEHoCfQyoXCT6ZJa4kvQbXty0J7b3CTQDcKqk5i+FyJ1vd4MSiTcgcCj/ifAuX3uRJ9GhSdALEXYsVfj3+0l6tzKnjnDdUmtQiKfybPylTTzOdn4+nkxwq6aLRt/1QusxVmZfbdrO9l4SO9QBWacReo+dudAOq5tTXoyX13EpVVA5fd84mJUVZrw7iiKzFeFutktIpmFQukPswNEJoV3a+abaqRvbiKOkUqNzZoulTh1fJbgCbOnXyFwPSdHG5+2FexIIUz18YSpjrMCFCgljBv8MahAI0/kjmjyl8rHgwNH6rAfpgqItLUKFk2tDLr8fAsqoBTP1zJI+TgFeVcIEz8FARRRvYucDgVRY2aTE4fgwNiTGj7qcM845cdA1iBvEVeIM5ndBIxtrBOZwALS7qNkwZ01My3xNtVqWAzBdaoHq+R8okRcm89iZKg89CfVJcACW0pwlQL114OIDyEelp1drZ9p0PR4
 5vVouF6Z
 0/fPX6uXbF29PwlPXoIRBx4AcqobvKzg2nIVNbYzmus7Q+VifuINX8YZQzBA77dtc70GeyDMTq3UNGU2oc6p9v++ji+berE22vhoJtABFbGH/+PjwvlJ7D3VRaWrP2nT7Va6pCjb3s5rL0RfCTa1Y8Jbwd6vGB72t7VVznjfc6D4G/7NVUjOtEWeVdRGQ6zfVTR38QDzwt1zJmdpWfOH6UjO0BS/qCedNYih+ZX/CabJLTB+rrK3Rz0HzCGzZCXbvsPoiE8417j1VHSSoBHYxDPQnMlejUB0dWzCxZJsU/S97Mg+yGcYOrwIKX79xC2PzJ0qJA8psvwmNleIoXQFh0pbO/KthThWxrmVk2QR1HBXazlP3GT5iQAYhYXLmYeiuT6nFEMWFdf62IgMnTL6G7Akv67mCcMdmCQ0aZSsYxeDLJ/YoX7aWWvLR6QOtN4K0Ue3nWLJJ7m6wh6CeWohszF+qwghD2sAPE7pTqBBU9VrKwGVsNSNZC5p0JZXATHNMNNrwiU460eCKVNAJmd8hbPB4gskspONcSD6SVxO+mfOy/PCSByySp9hHLFE+grwdwbWQ7epEoabTL1w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:11:21AM -0300, Marcelo Tosatti wrote:
> On Wed, Feb 11, 2026 at 09:01:12AM -0300, Marcelo Tosatti wrote:
> > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > On Fri 06-02-26 11:34:30, Marcelo Tosatti wrote:
> > > > The problem:
> > > > Some places in the kernel implement a parallel programming strategy
> > > > consisting on local_locks() for most of the work, and some rare remote
> > > > operations are scheduled on target cpu. This keeps cache bouncing low since
> > > > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > > > kernels, even though the very few remote operations will be expensive due
> > > > to scheduling overhead.
> > > > 
> > > > On the other hand, for RT workloads this can represent a problem: getting
> > > > an important workload scheduled out to deal with remote requests is
> > > > sure to introduce unexpected deadline misses.
> > > > 
> > > > The idea:
> > > > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> > > > In this case, instead of scheduling work on a remote cpu, it should
> > > > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > > > work locally. That major cost, which is un/locking in every local function,
> > > > already happens in PREEMPT_RT.
> > > > 
> > > > Also, there is no need to worry about extra cache bouncing:
> > > > The cacheline invalidation already happens due to schedule_work_on().
> > > > 
> > > > This will avoid schedule_work_on(), and thus avoid scheduling-out an
> > > > RT workload.
> > > > 
> > > > Proposed solution:
> > > > A new interface called Queue PerCPU Work (QPW), which should replace
> > > > Work Queue in the above mentioned use case.
> > > > 
> > > > If PREEMPT_RT=n this interfaces just wraps the current
> > > > local_locks + WorkQueue behavior, so no expected change in runtime.
> > > > 
> > > > If PREEMPT_RT=y, or CONFIG_QPW=y, queue_percpu_work_on(cpu,...) will
> > > > lock that cpu's per-cpu structure and perform work on it locally. 
> > > > This is possible because on functions that can be used for performing
> > > > remote work on remote per-cpu structures, the local_lock (which is already
> > > > a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> > > > is able to get the per_cpu spinlock() for the cpu passed as parameter.
> > > 
> > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > have requirements as strong as RT workloads but the underlying
> > > fundamental problem is the same. Frederic (now CCed) is working on
> > > moving those pcp book keeping activities to be executed to the return to
> > > the userspace which should be taking care of both RT and non-RT
> > > configurations AFAICS.
> > 
> > Michal,
> > 
> > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > boot option qpw=y/n, which controls whether the behaviour will be
> > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > 
> > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > (and remote work via work_queue) is used.
> 
> OK, this is not true. There is only CONFIG_QPW and the qpw=yes/no kernel 
> boot option for control.
> 
> CONFIG_PREEMPT_RT should probably select CONFIG_QPW=y and
> CONFIG_QPW_DEFAULT=y.

Fully agree :)

> 
> > What "pcp book keeping activities" you refer to ? I don't see how
> > moving certain activities that happen under SLUB or LRU spinlocks
> > to happen before return to userspace changes things related 
> > to avoidance of CPU interruption ?
> > 
> > Thanks
> > 
> 

