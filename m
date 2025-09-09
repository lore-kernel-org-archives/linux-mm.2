Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A705CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87AE8E0013; Tue,  9 Sep 2025 16:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F548E0001; Tue,  9 Sep 2025 16:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CB08E0013; Tue,  9 Sep 2025 16:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B8A648E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:11:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F37F59ABD
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:11:45 +0000 (UTC)
X-FDA: 83870807370.05.8AB22CE
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B3A880012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:11:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z1jph/xi";
	spf=pass (imf02.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zF+/R3skTysO2OwLmP+g6xYOgLccfqCBAyrfZM+b9H8=;
	b=ugaBmNerij1ejNkrjFXIUjw9XOP1Pv9EyWyP9yEX1rbLpxwGAdOK5sO9fazSiSGk1Fl/v2
	KGn89RNSJ5xGYVmqLXHNg0m/kX0X3RV2Q1ORhiPOvX2SAj7mt1oYMX9ecMwFJHe7RIEibZ
	6r0M66CQD1FoBQeAdwmdKzzFeDZLXGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448703; a=rsa-sha256;
	cv=none;
	b=4PLhOATEReeVDmxDh4C2xQ2qePegeD3Z5ITBkxDrgmZ+CAnSViz3AD6tVy3Ygw6sj4P/iB
	Z6NEJnY3MXwBwIePgG0SqPSOODrkRwUAf2ubPDnAvZbwY6wzCmRce46l9GgJBx6+LOy60g
	XaslrSh08AUHhMLr07nUx5AZB80AW/g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z1jph/xi";
	spf=pass (imf02.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 9 Sep 2025 20:11:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757448701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zF+/R3skTysO2OwLmP+g6xYOgLccfqCBAyrfZM+b9H8=;
	b=Z1jph/xi2L07bJSUAgXtLFZYg00hfwUMGPwVLRiZ8iNWV+vbOLvq3U2Oxn74CirpHRT7PX
	FtQbynaXy9tPAEmOd6UBxfgcWn79Rv3Hc4xavlFMXkse5I4ggeipB3ICSj9d39aPK7Oefa
	WUP+xQNVPLMYyeDBzC/zAVlGJ6GIGpc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <2aenos6u6gcljdovxjj5wwhtuivicfwtkigfkvg2maachhg4ke@cm5ep6jzxiob>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <CAKEwX=M8ccnsOUc4_ZcFrg-8MSwDDF250=LCFKctvTrL5vJZ6g@mail.gmail.com>
 <4vpqew3bfs74kesmgd6kaafgm6nr6zbtt2t3hl2khkc6ds4zep@hllgy77hdumf>
 <CAKEwX=P=2cm7X4VMGO==xqmcFfBj4tq_YU9DqCSbyAmCioDccg@mail.gmail.com>
 <20250909150326.GC1474@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250909150326.GC1474@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B3A880012
X-Stat-Signature: abx4ho6igc9mbu854xw6shcyncmbxuoe
X-Rspam-User: 
X-HE-Tag: 1757448703-285902
X-HE-Meta: U2FsdGVkX19/+fEjN6oOXQKdHuzyZtp+dQ5kjp8RmWFZVBFj+UbvhhgZLhPerPcc4xjMToYY7tVFJN8eIuoGOR/Ugy1KmVGHT/J+6LIF6JCnG5gGgk3XebGub/LoM60T9rPR2ogRcqrHkV3q5SmXItnikVvKZP7KBaDSiXDGeHqPxyUHkHhbEJtJedMM3ugG0mJC7RPNyo7SOoV6i6RAzljnm2r8CiAY+Xm8n9G3dLnwUwgEkr+U8uTHPWT5TAI/E3gwwblGccGaa25m6Yvz5rCiYDbdX9EmZs2hOLefGDmIQVgsjRU8oCwD5KzIVXLyMqPQsKiboooe4I39SAsE69nOy6RoKUc/E6eh4tTFDJbXB9qkmYiQt+lv0RA69yvEbKm8h3SShOlevsbh76mnRkHDiX19ClEmw92yZEw0pidDNO5M6KXAOJjQ77s6xb+9l1OAmXtiKJMJIXJIiDGvdmqp1n6wutz04t9iMd4dXo6kH1P9s291qSiQxMC7KFD+7tkiYbi8dIS1R08LXN3s0Gk+HJp6HgOcL5EkEPcIgML2okKriqqcLQ0Q6+Y0IjeQKPBTVCy1Gp4mqFJpYrVsdU3wO/KUFvK+UXEYsEQVX7cbXp2fKe/iCUavmq1FHiad95+yp045L28ESW/S8IMj6D8IXNcMSSdMcF89ktoOrdagAAABvbXvUImOEn7aZCde9clqXLYycA23f4M+NUXkDxo+ONRjUsrQ/UL9ZkROknKOWxxEBYzMQoTPHa4fAWbm9KH9PEqsMFQnjyAv/j0jJIsSQIm0DbhjeByK6gwNOC8NqFN63MBCag3QMhnbI1rvKDmE+imhktSbA7GFeqwjnyuP5ccB/RhqbLx7bNfmROLiKwLiKc1rjy6Cy90Ouj/K42/z8VG3YQRPdbVSSuQGzEZCDC80ogNHUkQ5+W+Cmg7NBY7xQj+Z4TW5hSd18knnzjJl/b01OQO9f/YmO1A
 2QAkZQn4
 buObCFCb7u2WsLxmkW9X3X6b/qvpbC8hOTC4VYE/SsXhWnCTx3G3CIBM2y0XpSjnjGDi4Scxm1UQO9jsdJuyVx6Dc6rdRgbxCT7M6b8p3Vq7uxxL0jmk6OcAa2ByLC40NZqaLgAZZP+q5yitH1LHGhv7talU1sQ6+I7MDvIgYUC3eruoeQWqfVmZUFhnUf3chvaK0WmTUmSafmocfHl3Z/cIYQNqI2fIl1Nf9ibH2Endoi69nfnmniox4c+Hf7+FZphNfVHqc6FvuDNw5Xex2MJzK6jVwEe+6+AhH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:03:26PM +0100, Johannes Weiner wrote:
> On Fri, Sep 05, 2025 at 02:35:12PM -0700, Nhat Pham wrote:
> > On Fri, Sep 5, 2025 at 12:45 PM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> > >
> > > On Fri, Sep 05, 2025 at 10:52:18AM -0700, Nhat Pham wrote:
> > > > On Fri, Aug 29, 2025 at 9:22 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > > >
> > > > > zpool is an indirection layer for zswap to switch between multiple
> > > > > allocator backends at runtime. Since 6.15, zsmalloc is the only
> > > > > allocator left in-tree, so there is no point in keeping zpool around.
> > > > >
> > > >
> > > > Taking a step back, even if we do have needs for multiple allocators
> > > > for different setups, having it runtime-selectable makes no sense.
> > >
> > > Honestly I think we should take it a step further and make the
> > > compressor selection only at build/boot time and completely get rid of
> > > supporting having multiple pools. We'd create one pool at initilization
> > > and that would be it.
> > >
> > > I believe this will simplify things considerably, and I doubt changing
> > > the compressor at runtime has a valid use case beyond experimentation.
> > 
> > You are completely right.
> > 
> > And, even if there's a setup where we benefit from multiple
> > compressors, the current setup is definitely not it. How are we
> > realistically going to use these sysfs knobs? Change to one
> > compressor, then quickly change it back? How is this remotely useful?
> > 
> > Let's remove it all. In the future, if we want to do multiple
> > compression tiers, or per-cgroup compression algorithm, we will need a
> > completely different architecture anyway.
> 
> +1 Completely agreed, it's not worth all this fragile code in zswap.c.
> 
> I'll send follow-up patches.

Awesome, thanks!

