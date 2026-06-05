Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99011CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F076B00A4; Fri,  5 Jun 2026 11:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11B16B00A5; Fri,  5 Jun 2026 11:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00DB6B00A6; Fri,  5 Jun 2026 11:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF5EF6B00A4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:42:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9ED1D1C0D95
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:42:33 +0000 (UTC)
X-FDA: 84846276186.13.5845EA0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1123F140017
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:42:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wkm5OHuS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780674151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykStheHWzMecvQlC8/orrpWH+CEGzXq9KPPg3CU9BFw=;
	b=mdcVGsywjA5iSyCxW7+DpuW2K/pO5M6FbG14lbp/IKXJbV/MTUaSTZcY4Lni5YjCU0iltn
	YovJtMoRiXUppX73P3pTQvgMHbFZ1sOPagUsipWUyymzlBP8vLQIA9tLu5oi+Fkjmv7MtI
	7eerUT/wb9GdCXzthNenUlrornEYPIw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wkm5OHuS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780674151;
	b=4sqlkgXyXx2XZNgZc++dLhURRLGwC43nN8ggJ1BbFRS3e5sH4DLokLy1TU0ZNARrORsfA1
	yHlPGsK3gSzUiDUpbH8W8RKGUWYyLtdyGvMgznpAsfgpN4r310DkY48Gfvjcko/2JKFsTZ
	0koFEZ1KmGFvFauS2wUhCuykk095Qts=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780674150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykStheHWzMecvQlC8/orrpWH+CEGzXq9KPPg3CU9BFw=;
	b=Wkm5OHuSi+DmWKoOEdpiU+hIgQSyLP6VuGQUrH0Y/tIiWwrEhXO+y2PrMIMLBp5oBmg8xj
	Ca9gZhNrsA41N6wgAgqUhdGOhLssc9r8kTqlFsAeLfkSL1i2T4EyFcR/Hsl4/uUhbmMwLE
	eDhwzRyTz7wxu5+79IMxUE2mKJukiL8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-gOiw9Pt8O4SEchRp3wpKaA-1; Fri, 05 Jun 2026 11:42:28 -0400
X-MC-Unique: gOiw9Pt8O4SEchRp3wpKaA-1
X-Mimecast-MFC-AGG-ID: gOiw9Pt8O4SEchRp3wpKaA_1780674148
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-914b4036b15so231572385a.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780674148; x=1781278948;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ykStheHWzMecvQlC8/orrpWH+CEGzXq9KPPg3CU9BFw=;
        b=FXH4JH1WA9Ok4UFs/AKTlwyN+Oj0wxtru5+LKy98ij8UtaGlt28Sc/urSVoso8G47Z
         M0ajyuMzCCnaV40sL0kUKed5YnBh+AYfqrP7a55V2cjkrivWzAY8JxIfZHY+6mfUqFaC
         kxCxTVfaTc5M4VUI7tHzPh+Jol6HJpRr56S4o36vv8HZOu47LhwsSoaPHvum/LD3sqPe
         +RStPRRy01iBCHlqc1C5I4npwYjzEbku2sCnSkQWI1DumSHzz+1/GzJO/tRP2H4iyFkV
         b5sUtWs1VbvSCJQ3lOw7E1TnO+hHy0kaqCscZ3xpKZDxszsJ/GNiqu1peOirRsR5IRWS
         dDTw==
X-Forwarded-Encrypted: i=1; AFNElJ9z04sls92SIZdd3lYTRvmcP/GNIcqBLayDtRsCKY7kF3mKbLm2j1dKxsEDkYljFfLHQe7fpwFYHA==@kvack.org
X-Gm-Message-State: AOJu0YxQ4I+XnFOqt79ONVA5LrCwLQxBtjkTC+rGbTsNEDX9p/9kALRc
	r0rIOvPYyS4bYFAw1NjILwYtaTIDSJYxOIhegioWiLdpafPaG0lCPrjoV59oLBKXsdqDGQWxYij
	zfwIaFMRJgi6RZOCTqThfhKm0WfvgAxrVHV7yYD9QZ4iIksVIOp8c
X-Gm-Gg: Acq92OGN2nQDwRmm67/xQx/hdRvZDpj1k8YfoiefqebbdIJbYvjcUzSi01QtkBHkg0q
	m0l8zIe4y6FnE52lfjQ8eTNiyA8OQ4NAmFLHCb3iuyrd62MyPQ4F3DjopLPllKWlaTDrKBkZQ0x
	tS/htpfHUbQfqM52WsubbC0v8UJsvk0qVNr1GKuj1pSqD+I2K0RFY4YZDwCjsBuJnHwgjrazW5o
	bOkWk9LmZT+nHFar2nRK/QnDIer0GP13S4XnT5BmT/zz1ZMHmwCAzyNfyHS5uvxp2rtyIKDypqf
	wFIleLsoTa6gDXFAY+DMmucE8FbApxekOtxr+n8DrxrmboE0cGs046p3trhc6RuJBg2kh8Zd9vK
	5uxkXydP7X6qf6l6RrkE8XO/jdUBb1U6TOl1QNLlcH9HTfeJ0Z8/Vm+xkBzz7fwUd+EU+ZWImiS
	cv
X-Received: by 2002:a05:620a:f11:b0:915:8f08:5f9d with SMTP id af79cd13be357-915a9dd4bd8mr792213185a.56.1780674147328;
        Fri, 05 Jun 2026 08:42:27 -0700 (PDT)
X-Received: by 2002:a05:620a:f11:b0:915:8f08:5f9d with SMTP id af79cd13be357-915a9dd4bd8mr792205585a.56.1780674146859;
        Fri, 05 Jun 2026 08:42:26 -0700 (PDT)
Received: from localhost (pool-100-17-21-205.bstnma.fios.verizon.net. [100.17.21.205])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3d2384sm921805785a.39.2026.06.05.08.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:42:26 -0700 (PDT)
Date: Fri, 5 Jun 2026 11:42:25 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Maarten Lankhorst <dev@lankhorst.se>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
Message-ID: <aiLVbQPxK1qI1h4p@x1nano>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-2-db4d1407062b@redhat.com>
 <ahBxB5a9sX9DEWvl@localhost.localdomain>
 <ahXKFYBdCMDBvc_N@x1nano>
 <158bc103-7f99-4df4-8d3b-2da9b04ac0ed@lankhorst.se>
MIME-Version: 1.0
In-Reply-To: <158bc103-7f99-4df4-8d3b-2da9b04ac0ed@lankhorst.se>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jKpnPNJ72-H5f8cONHxe5hK6_zEvNtIWlasMjXFUNlw_1780674148
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: oxmd6pj1fiaxo8qsmthh48hwgqx7ycfe
X-Rspamd-Queue-Id: 1123F140017
X-HE-Tag: 1780674150-716702
X-HE-Meta: U2FsdGVkX18v1pyYNRTFq4f5zDDNcerWEVmX3F2azbA2ltk0oMW4k+KRJQoATwWNvofyfTERjQzG/ZVtwxpRHFfC+5lBXNhjtMb4p52+CyfduyrbPveDXhlWPo9M6yj00vkhKtAnnXeJva7mPIuLBsyfbVy+M7/SEBuKHakma4+0hJwQinTimv7mfrnwOzHOYj5JYFMgieaNYhMUsp5w952AuT0Jxlq3hf/NL0bRoj0cXiAd7qoBVAYLD96iszSEqd3ZVYOAiLPGuwyhD9NNzEVwuYhh11QE87Get0/5nNbEiIPHHnJ1/QiilglaLXHWbIac3X/HgSP1NJ2aEQ5dP+fBnwxAA6gnjXNmRAT3uopkNGXpbOOBg9HULtIEkEnBkaJI0DpsUF3V0fTc6m+DdEsGJ98uwJwHVZIMrhtdcUX6PuOxhPW0doqOZzRnaA+HRmZVzDqwoyZkSJh1QR/zNPxDbs2mj2VgLQ2eXHCMDSqAJhAnf+KIMDm5ns/zOnPNOPbHYVdc9ePajhQaqyHcVtFxQeclMxQlOxClBlK2VNG8sqMhnqDnFx3eLYahQjCDv1X5PI82/xbN1ZHtQ+fnllX6ei3g2cxRIFQjShlUTVRs0mTt+huucOjqW0JMdXbUTO8zmEgyznxWD/W4yEqwIxCGIYk5IBNl8Rxi2hwi4jZBQJqHqeUqbVCTvqlnaxrOrqnof/uHOr0aSS4vqIqEiCZFZQ9J9NehO4pbM/mcY5sw6OVrer7sMJcYGx6Bz36ZekziIt5END/Tvg0s7ty0ZIkrhSwHiMxoJlXXdjK2zFNkpKvbx7MEjErzgNQvi5oeCl9CNWMosnh5y+02vk7nviNj6CkrlcC2o0HteJuX4p2XxLoWTk4I3Iwy84wyfIUakxneDPKDpDaizbto/9HV5V605XDAzvxoBdZslkLVrmgJoDrEyiSH2r+9N2fZQMOjXajdLJUbN6SWKYIa+XG
 m0WGQovq
 nTX32SLg3lMXuzwfTdLSLpTG2fJeRx2cOQtdAbmHM+LFiUaVjqjQmsMSLeF0dKQ7y0SAbPUgj3hcIl2MsfZ+Yzrah29N1u+QbgcfCqPb/0k/snPzAIdck8oib4BInHUoagYOpyRWcSeGPUTt34mdpvzc6Oe/TpyxUWv4rOA83hGHpLeV3EyygH4wyfq6zttOqejcio20AZ+yDgB8EZR4YhoUkSu8hMVWWmsad/hwhUYcVZBq1xuacR2jprhM+E7aZjRa4yiLhqQBZh+yTiVos6gmyg/lZRnhVN701gbNaLZTP4IHpl66Rx0oGJhr+ue3CKps8EXP8ys04QLtVUkA1/3h9WDlohUP/iGsa5P5aOoS6gzXi258heEkMxczUHKpgSPask+xgJE14ShDY68Wdzewf2Tv1oG5auJ+3MaTQWGtHSnTl3ux+Xym7JonWUnmMexp9iWZEZl+OIb2Sl8Vs7cP+ot66k3IcZNp2mPMn+ZcS4ImP398+Q2JDS3kBedaF5nzPEX4Rqh+jrDxKNbEMyawgjJZL1mF1xY8rBGxNmTyw9WeEKC+57yfpQCYq1tpYyyVP2HGm+AV98r/ogHYL4hTPbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 01:27:09PM +0200, Maarten Lankhorst wrote:
> Hey,
> 
> On 5/26/26 18:59, Eric Chanudet wrote:
> > On Fri, May 22, 2026 at 05:26:16PM +0200, Michal Koutný wrote:
> >> Hello Eric.
> >>
> >> On Tue, May 19, 2026 at 11:59:02AM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> >>> Add a root-only cgroupfs file "dmem.memcg" that lets an administrator
> >>> configure whether allocations in a dmem region should also be charged to
> >>> the memory controller.
> >>
> >> This kinda makes sense as it is not unlike io.cost.* device
> >> configurators.
> >>
> >> Just for my better understanding -- will there be a space for userspace
> >> to switch this? (No charged dmem allocations happen before responsible
> >> userspace runs, so that the attribute remains unlocked.)
> >>
> >> (I'm rather indifferent about the actual double charging/non-charging
> >> matter.)
> > 
> > Yes, this is intended to be configured before the user space stack that
> > would start allocating things is started. Once it has started (and tried
> > to charge something), the configuration is locked
> > 
> >>
> >>>
> >>> To handle inheritance, dmem adds a depends_on the memory controller,
> >>> unless MEMCG isn't configured in.
> >>>
> >>> Double-charging is disabled by default. Once a charge is attempted, the
> >>> setting is locked to prevent inconsistent accounting by a small 4-state
> >>> machine (off, on, locked off, locked on).
> >>>
> >>> The memcg to charge is derived from the pool's cgroup, since the pool
> >>> holds a reference to the dmem cgroup state that keeps the cgroup alive
> >>> until it gets uncharged.
> >>>
> >>> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> >>> ---
> >>>  Documentation/admin-guide/cgroup-v2.rst |  23 +++++
> >>>  kernel/cgroup/dmem.c                    | 158 +++++++++++++++++++++++++++++++-
> >>>  2 files changed, 178 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> >>> index 6efd0095ed995b1550317662bc1b56c7a7f3db23..1d2fa55ddf0faa17baa916a8914d3033e8e42359 100644
> >>> --- a/Documentation/admin-guide/cgroup-v2.rst
> >>> +++ b/Documentation/admin-guide/cgroup-v2.rst
> >>> @@ -2828,6 +2828,29 @@ DMEM Interface Files
> >>>  	  drm/0000:03:00.0/vram0 12550144
> >>>  	  drm/0000:03:00.0/stolen 8650752
> >>>  
> >>> +  dmem.memcg
> >>> +	A readwrite nested-keyed file that exists only on the root
> >>> +	cgroup.
> >>
> >> Strictly speaking this is not nested-keyed but flat keyed [1],
> > 
> > Indeed,
> > 
> >> which leads me to realization that this is the first instance of a boolean.
> >> All in call, such a composition comes to my mind (latter is RO):
> >>
> >> 	drm/0000:03:00.0/vram0 enable=0|1 locked=0|1
> >>
> > 
> > So per[1] 1 key, 2 sub-keys (enable RW, locked RO), that looks better
> > and match the documentation, thanks!
> > 
> >>
> >>
> >>> +static ssize_t dmem_cgroup_memcg_write(struct kernfs_open_file *of, char *buf,
> >>> +				       size_t nbytes, loff_t off)
> >>> +{
> >>> +	while (buf) {
> >>> +		struct dmem_cgroup_region *region;
> >>> +		char *options, *name;
> >>> +		bool flag;
> >>> +
> >>> +		options = buf;
> >>> +		buf = strchr(buf, '\n');
> >>> +		if (buf)
> >>> +			*buf++ = '\0';
> >>
> >> I recall there was a discussion about accepting only a single device per
> >> write(2) (at the same time I see this idiom is still present in other
> >> dmem.* files, so this is nothing to change in _this_ patch).
> > 
> > I would second that. When setting say dmem.max for 2 regions, with a
> > typo on the second, the first one is set, but write still get EINVAL.
> > 
> > Also, I just notice dmemcg_limit_write() returns EINVAL if the region is
> > not found (this patch returns ENODEV).
> > 
> >>
> >> Thanks,
> >> Michal
> >>
> >> [1] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#format
> > 
> > 
> > 
> 
> Perhaps a bit late, but before we start adding this UAPI we should enforce a
> single region per write?

I can send that separately, although that is a UAPI change. Is there any
user that would be affected?

This series is hung on charging memcg using memory objects from the
context of dmem, when at that level of abstraction it doesn't have
access to the underlying pieces that were allocated.

Best,

> 
> Kind regards,
> ~Maarten Lankhorst
> 

-- 
Eric Chanudet


