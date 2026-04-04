Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C4A5E88D7A
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 04:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD846B0005; Sat,  4 Apr 2026 00:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F1C6B0089; Sat,  4 Apr 2026 00:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2847C6B008A; Sat,  4 Apr 2026 00:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 173106B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:05:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3A34BAEF4
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:05:38 +0000 (UTC)
X-FDA: 84619534356.09.8485D24
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF475140002
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:05:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v093PvaP;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775275537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXjD5y2dSw56qiOBNpNICdbINHVWiQ84Ix3CMZ1JlMg=;
	b=Izgk2ZKsPcWdJsSiPknoasaSCPzKkMOpEwF6k+HcKKsrZGYYtGuvqQx5F4GGtIoamoID9h
	h1hBHATsWor8C5mGzSqvrTyGDlUWbIkPVexRy2ZGgT1CzDMmKVORDABwaABIeiO3wQgo0f
	R8CQwhmCMu+lobtIs2nbETL0E29Nf9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775275537; a=rsa-sha256;
	cv=none;
	b=X6akj1vGroQrnN4CAbic96h897PpaCWuexuGQX+WUsldjlYE+CTMiHTuG51+1kEizF8JqD
	QvI7spxIddEQO2IFfyaIS8IbEB2KFCY8ay59prkGxSl0FQ2berxdhcPCauRHpQvXO+B3kh
	ZftaqPkxqa415VC6FUscJHkfoaUq/c4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v093PvaP;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 4 Apr 2026 12:05:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775275534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oXjD5y2dSw56qiOBNpNICdbINHVWiQ84Ix3CMZ1JlMg=;
	b=v093PvaPMdGBuXK3YWnotGDVvjn7QfnCJinIQKhZpLvxj0/ua1tuVnJRM0W/ZKVNDVhRfo
	+M/y+GztmGxzoFHtP4zoVf064sIm/cofg5z5VCB+QxoyTS3I63TMCRa1a2yELHKh7W1qHD
	X+l9JUqWZLBXkkY+SFGhPU2felIvhCU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: use N_NORMAL_MEMORY in can_free_to_pcs to handle
 remote frees
Message-ID: <ox6hzl5fngbwbb7ncw3x3k43f3f6nz22qfo3xh57vs22xidgqg@5jmbx67y5uh7>
References: <20260403073958.8722-1-hao.li@linux.dev>
 <ac-qJ7tYQ-ybegOw@hyeyoo>
 <6c90c152-3341-4a46-bffa-3cfaca66fdd1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c90c152-3341-4a46-bffa-3cfaca66fdd1@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DF475140002
X-Stat-Signature: hage9j1y6iiazctgbhri6u6nmk9i9b68
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775275536-472964
X-HE-Meta: U2FsdGVkX1+hT6eH7PkiekRbhLhmUZVesT1bKygxCQFd/w2QFX5sozkaqFsY+GrF+uWGtRfUc68edFsc+sHvAQYjCYSUMtIHrFBU1tj+CTIjKA6jsf0qzviwsij/gD4xvDIE54rYGHxx9JXCV/H/jRusJMQO4lZ9L6N/XdEJ690n3JD+pBJvQ8OcQO56Xyg+6+EZSHnCgRAyv/jGnLYRrD3E5VOhrQxD2x2AWR/p3OucwDKzFhiukw7XwVU3eotPyfNTDJXA364x6Jiq7pQ3hWyO8vesLLoepxmS1J1ezX4bb7QXSMiMA7qFmJqrFa5wNlJlxuoLxPfpTWFn5XoEV9LlG26w28h+P+Ltbge6Ft42tSBrJESLwcZbgv3hvp+l250/2rVURoeRXHe8RQpv9uazs5OLw8FRH6b+uMLMrnhLKLz3CI9fwQ9qYyQ17ZAcJECeJKGSm6TXtQI/7+/1K4rISMoFadU1qZ8aTuLQ9w6ucPBbUZ5GGzGnIijGUk0oJaPGQWiC3lgonNksuGE6yun/k0bK75Pcfymn2JwU7eusnG6WUE11F7Jtu+kB8mBhsKzdlNydCEVqKWXLNBKo0AvtRf2a+8/qoPeURQ3V7kN7NRqcJl0VRSF8CssMGLU0dzy6f/RTn9PAjcXxTRg93NcMtPMXUsCcm2Sw4ubSFRe7oqmJ/jtoSD0dQRAhyJNSRb1EkMXtVTi5tDkvPzV6SwXeVH+96wfm8N4aJZi2GIyld+sN2+Zp10aXVAXCrgp9Mwakd237yehZRfXyxUE6WxzQ3iIJpAto8QFDChSURU3QToXAKjVdrZyo1IIxPcAwNvQF477fAIWmMd/mdFqi9xgePrHpi/WLneotgt5gPszLlm0X8Hako1NTpOrKT1OlHQtf6fbU0cBvMLV1WJDxPpcY4myxEg6+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 08:14:11PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/3/26 14:02, Harry Yoo (Oracle) wrote:
> > On Fri, Apr 03, 2026 at 03:37:36PM +0800, Hao Li wrote:
> >> Memory hotplug now keeps N_NORMAL_MEMORY up to date correctly, so make
> >> can_free_to_pcs() use it.
> >> 
> >> As a result, when freeing objects on memoryless nodes, or on nodes that
> >> have memory but only in ZONE_MOVABLE, the objects can be freed to the
> >> sheaf instead of going through the slow path.
> >> 
> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> >> ---
> > 
> > Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks for Ack!

> > 
> >> Hi Vlastimil, this patch depends on a prerequisite patch[1] from a few days
> >> ago. I'm not sure how this should be handled.
> > 
> >> I wonder if Andrew might put them in the same tree.
> 
> > But it also depends on the patch series
> > "[PATCH 0/3] slab: support memoryless nodes with sheaves".
> > 
> > So perhaps better send it to Linus after 7.1-rc1?
> 
> [1] is in mm-hotfixes so it should get to mainline before 7.0 final, so then
> it's fine to add this to slab updates PR for 7.1-rc1

Sounds good, thanks!

> 
> > Thanks!
> > 
> >> [1] https://lore.kernel.org/linux-mm/20260330035941.518186-1-hao.li@linux.dev/
> > 
> 

-- 
Thanks,
Hao

