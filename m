Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3A5CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 06:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FED6B0093; Fri, 22 May 2026 02:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230A46B0095; Fri, 22 May 2026 02:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E316B0096; Fri, 22 May 2026 02:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 050006B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:28:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A13A1617E8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:28:15 +0000 (UTC)
X-FDA: 84794076150.24.A71F1AF
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A9A0A000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:28:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cItYrSPg;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779431294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zttAzZFpb/rKwt2oY4sDdSbhgKaoVXl86Zh+IIWqhto=;
	b=jlN2+oQz3BARrSKafEeU6lR30txdDMyjzLK3wHAT3A09WjMC61Cono1YuhN4hsEQmmoZjx
	rMITs86QLv8BllIYDem52rjeNGeWp90zYdmPq4ITbxzcajkMGnBrodn7z4wsZd2qU+m21I
	/bhoSy5zyoVix9V6sfLXV2AKK9X4Ws8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cItYrSPg;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779431294; a=rsa-sha256;
	cv=none;
	b=BzONj3/I0kNWI2wSoj2/rywH6VbKJf4xAgVsLB/I9v72T0g41B7SWOQe55PHZYFBENLzPr
	CKHHeJLugZWIn7ej2+TQkboohATtIK8p3F9GankX5sDPlNz77TYJgNTTlVMseT+L3CNjmg
	miC4G658+ZMScROIg/OTmUM8ahDZY4w=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779431288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zttAzZFpb/rKwt2oY4sDdSbhgKaoVXl86Zh+IIWqhto=;
	b=cItYrSPgRfneBTRSimVdj84tcSYtIdaa/RSrXXrLHb2568Hv8ALnbX7lnsOH39up2ldJzm
	q5g4TntcMStGhHSSdbkGE7OgiQG5qjr6oTjCPMP7mC3FX7trLP5s4ot645kaqaoWV0pJUr
	MBn4S4Ptzuaynj9wVu3ePAtfOwp2Y2A=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 3/4] memcg: int16_t for cached slab stats
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260522011908.1669332-4-shakeel.butt@linux.dev>
Date: Fri, 22 May 2026 14:27:23 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7706EBA4-B9A1-4E33-AE96-9D351D91EBE2@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-4-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A9A0A000B
X-Stat-Signature: 7rttok443bhhdd8i68rxbgg3gm43qyus
X-HE-Tag: 1779431292-21535
X-HE-Meta: U2FsdGVkX19i0GFfyF6im9M7EAoKgFtzLMmKSG/MaAwGX051uWDnsGhz8kZyA0MSQZOuS88fPQNzKEoEHqjOTrf8htaM8lWoloN2OzCRC3r5hE99mQwBtyav9Kj74uNFDNiGN//oXzdqmQEgiTGWOmuJJJQqDKNLDddg2Uz73DFJQnj4dBImLsqDtWmSyj74a4vQ9YpQTfpUCkx0xV1y6xirJ6X2RGoUHHjA/Vd6JHrx+fFxlNlSgMQmT12jP/0JLdAbUZ20mgtIoootCeBRmqLAS2Up7TwtNGvJSMZDLUI7ZNNFZXfCV4wbGY7Pg2kpxB4wg1uzxf77uMJJ4nG8axHmBS9iDyR9hClOXdzBCjewbe2GJ0boRC12LcP6PI868KLhuOPvlNMadsugwvLi1nP8zn6C4iMb9FzrHLF+NWfpfK58piDlaQFbqR2+I5ZNTinIjS+z66E9WTFWhpJ23I/vrNj0UzmNBizE92XqXKXqdAy1m/5bvaxJXJkkxpKYI2cgFRo9BWRGuGmfh8mAPEW2NZwsjHiQrO9dU/+9pr2yF43XJOQokNIlwU7yWm0AvIjK/gHO26Mj7y9rGa+pT6WE4IxTVItBciqnwZSOIBcT8lw0rs4M5cizJVblP7osD/nvkPGXllh+41q13J6mt99wgpIyQAoQlNjToVpCjD1pbb8BCMk1b3s4ScE/GsI81uTZ9etmAeU03SFJ3YkO4szmHyfVjtlL4PKZG7vuE5Gwvc31wqD/9CIj/dStB7JBduOTHkTgD+GtrDmMnN0F6FiUeqzigM5uCoVGlInhxKSb8MXW6UpAmIKc4Rrb+SPDwtx7+itnh7788yjE2s7igP84fVxpkrXhb3cOV2s2KJk+hBgebjBLpT69f1k8EcqM49OyOo+Vruzsa5eMt7F+8P/kyHRh2e+6na3zGARVhbzr+fjbMpsoBx5V6HKPb8tLarv/Ofr19FETEsaZZmN
 7WzNd30a
 /6R3B16mXLThpFo1cfVwK2qQSvyhqqhBtOjea6S1R7efwGTmQ6sLVKfcnt3pj5Hvm4/1RROrGphPdZDGKou5Grc/EB9fKE9W39/el2Whff0WyqpBdF9s2sz/Nd4sFZzNMZdHiY4cJDJ+82wFTS6n7EDsDZojijj4uJR3WCCC+L3m9ghsvgEL/VkRDTzee+tnAlr13xb9+NU+KEAolcESozdKH61SGnqDu2QYcE1xWjtcYX15MzeSmrrHsPxHHXdKJTc00r0MrVYkhF1Db2G1ACyTuAhcl3hH0lVG9epYvo4434ou4gcVieYQjm9iOz0D+BwEraL7YgyJYJdK45YAyNWHobEg4enB0f1fxWjBinFvNyJ8/YcZacYsvWNjSaEEX0Cq93khfVfptmAA5OkhwR4rAzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 22, 2026, at 09:19, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> Currently struct obj_stock_pcp stores cached slab stats in 'int' which
> is 4 bytes per counter on 64-bit machines. Switch them to int16_t to
> shrink the cached metadata.
>=20
> The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
> PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t. On 64KiB
> pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
> sufficiently long run of accumulations would overflow the cache. Add
> an explicit S16_MAX guard before each add: when the next add would
> push abs(*bytes) past S16_MAX, fold the cached value into @nr and
> flush directly via mod_objcg_mlstate() before the accumulation.
>=20
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg =
per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.=

