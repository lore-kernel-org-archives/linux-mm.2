Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8334DFF60C2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9A66B008C; Tue, 31 Mar 2026 00:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A09C6B0095; Tue, 31 Mar 2026 00:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD906B0096; Tue, 31 Mar 2026 00:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2D96B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:25:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A8E9C315D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:25:03 +0000 (UTC)
X-FDA: 84605068086.06.1090D2E
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4512B1A000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:25:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWwxbEs+;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774931101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3Y6o5j93R7sTJgQpUSEqOpWjTfzF7tRF8MdJiE9tik=;
	b=0AFc6rc3yut+f0E064nNLn+F4/QmqwMNojvLNF+G8a366Uu91dEAkKSuLXFfTT2swicH+E
	ab6lA2BRuhRaDX16xe8rQXU/tsI82AS+iMlYrO3x30DYLljB+PdERrFG2OHEhG/WneGkyU
	I2QdoIxtf62wiB6AvpYtmyjtCtBb27o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWwxbEs+;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774931101; a=rsa-sha256;
	cv=none;
	b=i4Ji2wdwcQr8w/Z5shmB3yxvaQyj/hqPwpWjhvT1jgodPAOCY5S0oFKStKu2o2r6xPwh8p
	yEcGqPY4ouWrLGMkBGczcCdQ9mDC8N6dj5hwoOqmJTP/3LPSrOITRVMPDI+8mHp/ElhuGn
	1ZsYBow92eYI+pEuCHIkQVDIAjZbrnA=
Date: Tue, 31 Mar 2026 12:24:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774931099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3Y6o5j93R7sTJgQpUSEqOpWjTfzF7tRF8MdJiE9tik=;
	b=CWwxbEs+Qf7usdMzhi3bJHLVHjx+iHXGgFxDj37SYp5Z0a5YzbzxUAJf0STnFi3/6s2Lsj
	tt9fW4FHy9d+uwgHEyiQlzWwIZSOUn0x9lSd3exrZ+Dd4Me4mvO702/lQCiFbiVsLbaDbY
	6+HmyebYsosRgi1kdp+8zGe9ob3Dhjk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, david@kernel.org, 
	osalvador@suse.de, vbabka@suse.cz, joshua.hahnjy@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <ceqmspe2x2p5uv5bk3jyiw67qkyweaviclcjdp6kgwpg6v4kdq@f7yd6rr2lpkl>
References: <20260330035941.518186-1-hao.li@linux.dev>
 <aco0MtqpysMXMZdy@hyeyoo>
 <23feu42lqvc7iymgaxmnywea7c3qie5vmjm4aijbgdiazwvrcb@mmlxjowgtotv>
 <20260330144640.161ca53e94b37b3252de2e95@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330144640.161ca53e94b37b3252de2e95@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: z1hxwuueadg979x5gqz9dj9fsenykppb
X-Rspamd-Queue-Id: 4512B1A000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774931101-975250
X-HE-Meta: U2FsdGVkX19nayXKmJOcnbMSwST0ctrL5VT/rU5mslvVANyA5WOm6YbBkJDzbmS4EhIOAD6WzXTHdOhPEapzKS//7ynounUp3g/caIeKVpbWhRMMYkPu66aqlejjZBPCbqyDE2Bu4Ka8RfS1KTWFBr158IBW9grdxkIvGPopdUjQgWmOqGUUo3Cy/ybnjWoQWK96ONeXn9w0rLseX+o36kge+UXA8R4Mno4Bs0KqluxJMj+5VEjEys9HuI9s3LrT48UUSPzhX7f2U3/MLe3zkffcWP/u1eOX3DrcyxrxtgM0CXlV2WqEYFdUVAX+ctfrxfw6+TxobrPoaKKugQ4dqmBkO4WGzd2UNxIBA58LM/Hevq8MgXMKCaww01j+Ki75J9vJWXY5dr6Zwz8j8Nzd1IsnoMBFLrRfgcQMbYW8EoereGyLoMTfiH09alxcYJxbNxWA8QXsNkMGSdHZklQsXci62zutExaeH/IjaMUb9K2pTsdS4LQeqtDkg++qpB0DldfTpDWNVy40lMnuKmF8EDbPBdTEjdRHnyeapqWsx2hyjVOjCEaeX3Yl2QwKM9amXSTu/sXXuvO+ftqWeopQdG00r2jj4U8kURIDBxofg5uQJ/mayFuxnmSik/8CJ0nN2g8dFmX3GIrSHCmLZ5mYvVf+vI2xwLEPGWNX4X86x3XF6I45bxVeHWjgYKdTYeMYSlzONPs+AfcczPDmngoRfa5UahtHnoBMgvSAyiigi560cX3FvDMe5sODXrDrf5xw7D3wVzUSry5vyNaxLAM9S2/EfM4bcqaSMl3rp1DHf8Xo7heYeluurllq469nvsOVv09+RCIf79gXtwpYrUjos/urndboh4+3/3nuwdHX3m4rLvgdqxQMOIeJTThPLRsYjA9aHc++B/zQ4AuYTBe5/e+PDnfRIBaXl9enqkQZpWUfrjP5ipnjH3VJ/6mMgBgZLTt48MEwIEPlBpQFhkf
 HKwx44ci
 y2xyM0EF+gmltMPLTXlr9scfmmg8Fx1MJ5jw1S92aihGPHT8gt+f3o3zzBOOF911pcegEAiC93ni0pi3NLOMmrEPL3febPn+Mmzjq/GRbmc6ozZ8czClVqIr8hZ2ezyuiGEBbkZXJFis+NlomR0Zkc4RD/ukkKCY8IQehCgG/D5KY+GNmNIvcuM78S8qplOZcCbUI92onLI3LCnpQZdbnKKsURVl8ljLY5nzqvfyAAJsU4RyrP4h9SNYg3gzQKsIL7c3fUAJ4EVTU0gas6uVUooDYrXcg/46hCKWku/Ro4zlcvzwffs4ugwplmkRghdl/vRnPz/DK522wZnDG/gjU2UmjiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 02:46:40PM -0700, Andrew Morton wrote:
> On Mon, 30 Mar 2026 17:34:21 +0800 Hao Li <hao.li@linux.dev> wrote:
> 
> > > > Current users that benefit include list_lru, zswap, nfsd filecache,
> > > > hugetlb_cgroup, and has_normal_memory sysfs reporting.
> > > > 
> > > > Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
> > > 
> > > The Fixes: tag indeed looks correct to me.
> > > 
> > > By the way, MM needs an explicit Cc: stable@vger.kernel.org for backporting.
> > > 
> > > Since this commit was introduced in v6.17 and we have v6.18 as LTS,
> > > this should to be backported to v6.18.
> > 
> > I had gone back and forth on whether to add the Cc tag, but I'm happy to
> > include it now!
> 
> That's OK, I'm very cc:stable-vigilant. Thanks,  I'll get this upstreamed during
> this -rc cycle.

Thanks!

> 
> I do like our cc:stable patches to include a clear description of the
> userspace-visible impacts of the bug.  Two reasons:
> 
> - To explain to -stable maintainers why we're requesting the
>   backport.  If they care.  Heck, and to explain to me why I'm doing
>   this!
> 
> - To help out someone who is using an older kernel (there are many)
>   who is dealing with a bug report.  They're looking at this changelog
>   thinking "hm, I wonder if this patch will fix that bug".  Let's add a
>   few words in there to help out with their pattern matching.

Agreed, and thanks for spelling out the rationale!

> 
> So, and not for the first time ;), what are the userspace-visible
> runtime effects of this bug?
> 

The most visible effect is that
/sys/devices/system/node/has_normal_memory does not report a node even
after that node has gained normal memory via hotplug.

Also, list_lru-based shrinkers can undercount objects on such a node and
may skip reclaim on that node entirely, which can lead to a higher memory
footprint than expected.

Feel free to fold the above into the changelog if useful :)

-- 
Thanks,
Hao

