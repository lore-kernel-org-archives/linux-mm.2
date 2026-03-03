Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76959E67A92
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712876B0088; Tue,  3 Mar 2026 02:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0036B0089; Tue,  3 Mar 2026 02:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEB16B008A; Tue,  3 Mar 2026 02:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481916B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:56:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8656C1952
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:56:47 +0000 (UTC)
X-FDA: 84503995254.24.0DD73B9
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5779D1C0004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:56:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cQ9dMGdS;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772524606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDWRum35XOoYEguLtAtn2u4EvUrjQgF5qvmDIstdPgU=;
	b=VukC8RwbkbwC9RM4IFe5l/MDmkz2Il7jf5EKLRaul4+QKths7HwDunczpLySsIU04RFgrs
	Hl5PuKW14YiwSqyRDu8prroAt3hBKmpeHkPUKIv3dJgabX8lmqVay0VcE8NogRcJFrZW5k
	hu2p2j50dQ8gWR2+mJwW8Pif7KWJrkU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cQ9dMGdS;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772524606; a=rsa-sha256;
	cv=none;
	b=lahsroT7jvo9SfSpUL5q/PlC12xaP0JBx7TEgPCHVvQhXo1LKRke19WE9pZXC90ruShNqY
	0teqiIN+ZC43HYf1wjRiE3Vy3t9zO/b3qZT1b56FX2V1ZIo4HJpABulCWTTilRXM5ZXYeq
	oY6P2SzQpMZyFT4sOvsSr5ooMFusai8=
Date: Tue, 3 Mar 2026 15:56:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772524602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDWRum35XOoYEguLtAtn2u4EvUrjQgF5qvmDIstdPgU=;
	b=cQ9dMGdSLe5PXlA5a3yAXk/3kZiIH+0TQwmQUmjKk2gcJ/GQSY+HeaTgPu2iIyWPGCHV4o
	DG0NiNz7/H5gzL34C9bg0ywNcn9y0B4qnODvhglEmfQCvlf/nekFq8V8PK2RqZYOxOq3vt
	peuFdiDjhqiaFrvvAYq1Amc2U3sbfts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [PATCH 1/5] mm: memcg: factor out trylock_stock() and
 unlock_stock()
Message-ID: <xfnrnmnhgblqfj7xthzxztclo46unhbhfhoeykbbphs5bpuin5@qmfk4mwmgib3>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m5rgbznkds3cttjsuuu835hfh4finu59
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5779D1C0004
X-HE-Tag: 1772524604-358191
X-HE-Meta: U2FsdGVkX1+G9TeiVy8+HoD3ROsTAr+vbWtnqJxryHobwycDH2y7CtZ+ZCw/zUUdkBSwIk7U7AJGzVZbXppAlTOb6t7s6DbjObzsmEg1VpsegSeIfguKqCilFGHbNbYT7TgtU1yXZEXGhUQWZrP6aRbCHvdQ0jxIj3p+LWZgwN2PBI7k4Mw/SRsxbSmb9AA4hILyfHe3XMv16+v1qrbKrr0E5v7n/VDERp0QhfBjyKczx/PQbnScijVVOiC+fTu8AEJU0iwZT2mSCt108ioPDa/Uf5hOkjRyQgt1hFQiFp8Kg1nusGHFZZdfDtXLh3P1zKy9o5mZ0E8EDf+uPqTryIxMYmBKN/fCtDBKWUYMaatlyKuNFU8U3hTu2XfSHIxQnDY9PKm7s0s7TM8ZoMN/j3ANTENbCV5LaOHIwVaIhNPZwgYfvD8/x2GHojShlOwtCSQSuBkp7JjAMhxh1LC6os2Cu9IlkIMnfXiolrjnMCNvat6z1V964fO+Piz1PRvZy0uVjcCmI2BYKFJkIcwgiUVPU55Pq5yVQw9tqbNJUlz4ME7LTFLCVWLlx4nbP7Y+hKequxfVCfViHbQLgIWjRPJdMo/X5DrCE77dInUHBBGMGhmyZYDXuSlO1ifF/VoRvDp7QgaoccBFBwd7KS++XcBNDr0lMO1DbB5eO4yUkRsEI7Q0C8WoadP5dhYCP1xXyogKC0yt8OZkvyxADh12ihtQXWFgbHCiZpRB+A3CwJceRxOBVpkjAvx2Yacr8v307nV2gLWu3F71CCl0yaTdkQlLf43vHe3lvGZee575FxGOTEdbrt4KEaDLu7DIMjJAWvbfsBg/hL4g992TTF6EQxcXHO5JkFYkm9FzE5zgWWy0veHLnkPup9dbCyFBDPx3vzQyDJSGXAC2kMUI8Zf5w/AS7CeR8/mvHcLhwY0OKoWsiZc+WjsnFVryjwrFO++o5o08rVh/+NmAGS1MLAU
 bcWCDrgK
 ssek72/h3APDimcAXs29Dc9Rdxc3wPt9S1KAU0RM40bb5OIMuYabzKIPNsvDRNWKtWda74dUyQ3VnPKhh8NZalLRrLnpupiZ6D8L0k/HHPtAZ2CmCHuWx9awNr71ZdzZSI76vq09BhAdemglgMWn9op5KSaavmGDI6eYs6h1CXHgNuIeDwKghCJyzCsbjgDECU/T6E1yeI4OnIaDWZf1MNLVJpx3xl3cBRZ4Ie2pOdWzr90Jg11832oNpQcxWRVBth2UeJJqjU8pJlVwO5edWBgcIUAjlLUDeYoUG28sdeddrnuSpgtobxCBzpcW2OWDL7sq4IAeH6yVm49jpmV2k1hDTHXIDxQzfWv6KKFXs3jCFqR9SS9018YDHgWhKFPrSxSZbtQ0JGOSrmBRJiUBZimxs/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:14PM -0500, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Consolidate the local lock acquisition and the local stock
> lookup. This allows subsequent patches to use !!stock as an easy way
> to disambiguate the locked vs. contended cases through the callstack.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

