Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A5A6C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D20F6B025C; Thu, 13 Aug 2026 05:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583716B025D; Thu, 13 Aug 2026 05:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0D96B025E; Thu, 13 Aug 2026 05:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9046B025C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:32:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7F4D1C1736
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:32:21 +0000 (UTC)
X-FDA: 85095730482.16.3887F3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1CB94140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:32:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a3wVsJdN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAWes2BXkarxcSwrrfFt7mtosTy2189oDBYFN8w+S6Q=;
	b=O6aYPW27UrvvJXDTPO6dJ0t8NTZ6CheQFzymrOKzr/LV+Jvc4cVpI9veKLXUMXwPIr3o65
	Vt9oFBon7xLZbBK3/UvgQNV6lkGS9OjiD2zw9MBylfCS5KeWCDUDxUVVnRkW+CeoN/iABH
	MsTV9gnzPJN6px/CbrcYcHs7mDfHfpw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a3wVsJdN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613540;
	b=s0UIwKJpLZFHrGhmnaRGIEeOMZksA0uKweOTijd0WeZEkFfe6O2m2u5vW13kmP9Um/Oa1x
	ibFj8ecWtjL8Qyp/C+z7AidIqlJK0N+DbTKmGSOsQyWupNK1KhChlGAbp10a/NKzjK+sd0
	fOPamDnZ6WTJFJnKR2BtE0Gawvnea98=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E8CA423CC;
	Thu, 13 Aug 2026 09:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE801F000E9;
	Thu, 13 Aug 2026 09:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613539;
	bh=nAWes2BXkarxcSwrrfFt7mtosTy2189oDBYFN8w+S6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a3wVsJdNUj7FbrNxMi7nCwOfx6FTNl8WKwtxgclhKlL3EMzkiG46MX9ojuTBuTBdK
	 L8PFgBapyC2e/SYXTmfBU7BI/I9YIa9lCU3mCKgh1SHZd2y7Bq7Qi1RynAX3M/gqzS
	 TjuScnbX/uZKNt7EjMUjFwjCPPKhfSdIX3Yw6RdM2U/cvpep95+r2auYc6+jnNerNz
	 J3e98r75pAPxrEh9GKbLGY2sAJi6CFAlC3if8YmKhqqzFv5LTw82X56CgJfMxiioWI
	 VHwTO0M01ddM2uMYVhMgRSLWH+yD4cdyPPMWhw1zhrYhm+4SF7gdoWv3OlmJL3EStj
	 In0Gz63gtbT+g==
Date: Thu, 13 Aug 2026 10:31:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org, 
	david@kernel.org, linmiaohe@huawei.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, nao.horiguchi@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	surenb@google.com, mhocko@suse.com, gourry@gourry.net, tony.luck@intel.com, 
	bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <an2O7wR7iYtw3N31@lucifer>
References: <20260812091644.224299-1-xieyuanbin1@huawei.com>
 <anxOypktGGq_9PZw@kernel.org>
 <anxQuhNh8rTUYqpN@lucifer>
 <anx13IlH6PMxhaSL@kernel.org>
 <an2NjwBTWoX7l_tH@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2NjwBTWoX7l_tH@lucifer>
X-Rspamd-Queue-Id: 1CB94140004
X-Stat-Signature: 8q7uwpdd8cw9mf5idnua1mmh94hjyuj4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786613539-928553
X-HE-Meta: U2FsdGVkX1+ZgqV+66jvN0l3mm4IL6Pj3KTX+e1Z/LZgKti77Z1eEOXr0d0ML/HN37zcjnwBKcnP5k7Nt6D8Pn5uuFrxF9KB4khn3gIkwnW9k10OGeA65JkY0Mfh0oV1dUPtCUuLCn4OeKZQY9JXMGtOg8KC4TG8+kv0EcCWGWodKqJ1fdWperKKAoRZqfFiBDLPq4zniwltOD6CWfKCEMCB6SssY4S7SpGTr5KlXTHoZNNk6+YBzksEpB9Q88IcQrLJsV2dkQ7RaTRSX2ntbj1v77sh5GHrg5hwTr5vrXgXVSIZoy0CuEY6myeygfTtM1eZlLVxurJdqungIxAD/kBn9MEsgWDIWhxI8bPQvVsdXXbh6sQtG+cG5a6FuDR3jZ7STIu1nEAbo6dOJeHU271Sn/GmxwUlogBVee6OTCIO0dDK8pasbS46u70bwVwMkMoGlfbQxtGX1mkj/J7OEVyg1y86auh8cJzVB5nM1milXBG+fmPhMbYNHgqlCYuh4rY3o4oAllBWgAMGnvV4owvVg2o3zBqxJyhVjjd4RypdFgrhLyaOIgztkp2L/+KkK51nSH50y04HxbFzsuM7oaoEfTxdf8+xWBYpFOHOBBUf7qY7WC9lrv7fD68J3HF/DNYSRiqV+YJx5laEgFSLZTfk1vw+54RDseMzZhwyPzDFK5mbN57PD6GiL08SErL3JLWb/DRWz8x0etBPkEJquPogVecFe5LzzL3/XodIriyXPH6fCSdhfeTyjYEamCGza0O1A25636xIiKV01c8uUkx0lYplwnjbgk5CY9HjtaeM88uyNtdrjrt+8f5zz+CFHDdoOzbcVyEmhOmf41EZ+E+K+VqG2u9XhxT3J3Tb1uAxgpB4ySMk2vH35b9GtuDcmx/l0gIxfUeU+itWVQtvsJz4OPgvQXJffgMegKpCsqErWtWvpnc2sRMT8asAPZuOYUZ0T8aiPhWVkOSdB/5
 SCiEqu9w
 rlMcHQvZpQvVwPxr/jerSbrjswcOSf83TxZc8LNQgCOYJjZsHxS33NCQA15TS18CAu28Nxt/FEr+gfGuV6vCY1/MxqTDh2HJG0eB97LoqfUZV83JnkCcS+QvtPAq3cFIGR3cORddfV0OmwQC4sh+zose+ApS91OqHVwEd8Kd7GhpEjwkLQtQqY+RRdXPspyL4+m7GGATIGVbuVTpZqKWatk2Dem4yNQCwPZOwgCAW6El8dzNsmPXyzMS+bHQWDOShBVUf7Gv9oUZXw3xL2EdAqk9rLCMhADYeQIdOoUWN1iin/9goC4bYTkHaWTOq666D68zwztHPMNmnEOp0h+Mc+kx1pYNa3bQICETZCVy7qTpULhHAWjHX63uJng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 10:26:04AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 12, 2026 at 04:32:12PM +0300, Mike Rapoport wrote:
> > On Wed, Aug 12, 2026 at 11:55:03AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Wed, Aug 12, 2026 at 01:45:30PM +0300, Mike Rapoport wrote:
> > > > Hi,
> > > >
> > > > On Wed, Aug 12, 2026 at 05:16:44PM +0800, Xie Yuanbin wrote:
> > > > > Currently, memory-failure can be enabled without migration. However,
> > > > > migration cannot be selected by user when memory-failure is enabled.
> > > > >
> > > > > Migration is very useful for soft_offline_page(), which may be triggered
> > > > > by correctable memory errors. Most of the anonymous or file-mapping
> > > > > faulty pages can be migrated to other healthy pages.
> > > > >
> > > > > Allow user to select MIGRATION if MEMORY_FAILURE is enabled.
> > > > > Also, select MIGRATION by default if MEMORY_FAILURE is enabled.
> > > >
> > > > Do we want to make users decide if they need MIGRATION when MEMORY_FAILURE
> > > > is enabled?
> > > >
> > > > Just make MEMORY_FAILURE select MIGRATION.
> > >
> > > NO.
> > >
> > > Explain first why the hell one of the other options that selection migration
> > > can't be enabled.
> >
> > Think small systems ;-P
>
> That need soft offline and migration?...

But still, he did do what I asked and reality > theory so your suggestion seems
the least worst way.

>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

