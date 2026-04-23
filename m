Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36471FAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D396B0005; Wed, 22 Apr 2026 22:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE9D6B008A; Wed, 22 Apr 2026 22:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613926B008C; Wed, 22 Apr 2026 22:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3A86B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:12:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACC1EA02F8
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:12:31 +0000 (UTC)
X-FDA: 84688196502.13.7864E1F
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id DBCAF40008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:12:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bxkaAO6l;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776910350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpBKsDPlkpVJUSkb9MFSISFQz8DxRvttE3GzhhSX0bs=;
	b=1jFcb2dx4pIiAAvlb3B+ZUbyDJNDpJZeNYDea+V1TVcbLyPIHQ5qkdr8OQ6j0U5/f1Kdun
	sA++G6h6rJk5h1HiCasLdg0vZOcvKKyOYpRYfJJTAKRNEF9R0HGjoTAlr0X5pp+VJmLMwK
	yXAnQ8Ri3UE9xzaS19sogRIOpOuUUW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776910350; a=rsa-sha256;
	cv=none;
	b=j/BTRYWDzx+ynPXOrxCf0nmxMBFHPNJ+YEB2dYua1t9Wzsy5MNSH4K+OfZyqQK5x4qcRer
	olUlb1i5aoCKBkFeXQquxW1Dg6otEWMnH1y+tWViaykJFpDw7zp6C09mi0j/Dr/dBPe2OO
	pIqxYMUU7Nn6Rr7pIIk7DAEyFtQuq0c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bxkaAO6l;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776910346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dpBKsDPlkpVJUSkb9MFSISFQz8DxRvttE3GzhhSX0bs=;
	b=bxkaAO6lIQSpR7QDsXsmvQZshZ7e3jV02qpyQCOTDJ2hXjVPsA4ndChfVC1MCTLIFyqlDX
	qDulVe9yA/g9UqnCRTLvcaqFer8PCso6pu4tlW0bLJPKibXxh9Ghic02avm3bUH6c/s5DE
	b1JTZPdpnPVNbUCdVzdZlIY2e1S0XsA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/hugetlb_cma: round up per_node before logging it
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260422143353.852257-1-ekffu200098@gmail.com>
Date: Thu, 23 Apr 2026 10:11:58 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <06EBF760-EFAF-4EA7-AFEE-EBDCEB01752B@linux.dev>
References: <20260422143353.852257-1-ekffu200098@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DBCAF40008
X-Rspamd-Server: rspam07
X-Stat-Signature: xhahemmd4au1gom81krog84ne9ttcpqs
X-Rspam-User: 
X-HE-Tag: 1776910349-37866
X-HE-Meta: U2FsdGVkX1+Y5u1wrAxwbi41Ya6xudAJe918la8PRbFxBIrlWTRRwgcx3hIkVpbMbdF1YBZcDWdKRcDctVOHWH4BZa6pZGJzk576wpRKns8t32oMaftErTe0WrhO7dQU/hKgNdcwPO5bbWTZUYkMxbFBkQirSbAW/Mo2s3YvisE7lFRrgFBC+XwDY0qBRaxTEVWT/cBHc5W2ecMSt3IIBdookp07h+b6zx1eHnYoGCgakjLNlPlGlW0oAsyOUI06F68pRV10X0U1S5vvTOkdASbis5xUGVTM9j3/5KOnJHj0cj3DoA5cUn0efP91eMAY/bv80HgCOa6GYgATa1bdDIDe0bn/7F4/fmATD7EjJFfoV/UdV7lGNpMbg+ajheSaa8fYdOhz2JSSf/PLtUCFY3Q4VuFj4600Gf5OStrAKV/yALBSuz7yLh0KFba9llyASqTuDbzRFMANL95OzzFriLVeZcPt9lJxUI45TEPUB0HrQMa690JGDPP2wg4aqwFKMySmsyMxBBmdct44V7mpuUnloQ1lwN1/SfG4jH+/Xju0NVhAt5jSU3qzUWXKrWVxmokq76ymMv5hUH8p0P/yDgm6KEjM1FwQkQHlO1VuO9zh8rHkw/cJtRUYcRsCs+z5R0RzVSaWcqfdY4tyqLFTh525NpKWixawjt/tur7m13o29qvbXKNotr9LKG8Fcmb66kOARopNGvX7z4rYBJPj8NrBHC0UypZhbbg3yzjtW3cjBTaUa2t0dvHkHZOZ8UkxjYDwCJxtqvWyk3YgPa+YMnoa9dbJIMx+jswcc9DiG4LDfgLB6V+3VbVXx5BDF4fQPVr8y6A5Ir4zxW1l0cJY4Uy/A6XRJCAiT/r1RF8FcacgPDHfWOmt3ek632uW3PXaSZjTjSt5ecfgOfuPSGEOD8zQgTjZaqGVsB2AFMc4MtpP/PQ19DKyaKYiMTONy8iv4s/9fYsOviLWZyYRHa1
 iHv8XKcx
 gEjtxNq0ktgjXLJLUeDBRz09TP9XAqC6qYBd4zyd82lQxQAO8C1VdxL4i7rNf8omFyL2YhFKX0BJU+2PUQY2eKQ4EkOcEiY676co+NrP0EY6v0oi1gIYWOTW4CcW7f8N+8CymKhUSPdWPhCjtnRqalBAi/Ha3NhIa9c7980mVpPuMOrE6U/qAiMP7GniyP9BMvapKAryWmPvRnTor7D0uSeEAM4sljhS79b7/EcMJVC7zEXfQnBVueESGvba48sTienJDdHXn/S43hzfl6Irhkx3Iop7rAKGCE0u4pQLBAoP1Fs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 22, 2026, at 22:33, Sang-Heon Jeon <ekffu200098@gmail.com> =
wrote:
>=20
> When the user requests a total hugetlb CMA size without per-node
> specification, hugetlb_cma_reserve() computes per_node from
> hugetlb_cma_size and the number of nodes that have memory
>=20
>        per_node =3D DIV_ROUND_UP(hugetlb_cma_size,
>                                nodes_weight(hugetlb_bootmem_nodes));
>=20
> The reservation loop later computes
>=20
>        size =3D round_up(min(per_node, hugetlb_cma_size - reserved),
>                          PAGE_SIZE << order);
>=20
> So the actually reserved per_node size is multiple of (PAGE_SIZE <<
> order), but the logged per_node is not rounded up, so it may be =
smaller
> than the actual reserved size.
>=20
> For example, as the existing comment describes, if a 3 GB area is
> requested on a machine with 4 NUMA nodes that have memory, 1 GB is
> allocated on the first three nodes, but the printed log is
>=20
>        hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node
>=20
> Round per_node up to (PAGE_SIZE << order) before logging so that the
> printed log always matches the actual reserved size. No functional =
change
> to the actual reservation size, as the following case analysis shows
>=20
> 1. remaining (hugetlb_cma_size - reserved) >=3D rounded per_node
> - AS-IS: min() picks unrounded per_node;
>    round_up() returns rounded per_node
> - TO-BE: min() picks rounded per_node;
>    round_up() returns rounded per_node (no-op)
> 2. remaining < unrounded per_node
> - AS-IS: min() picks remaining;
>    round_up() returns round_up(remaining)
> - TO-BE: min() picks remaining;
>    round_up() returns round_up(remaining)
> 3. unrounded per_node <=3D remaining < rounded per_node
> - AS-IS: min() picks unrounded per_node;
>    round_up() returns rounded per_node
> - TO-BE: min() picks remaining;
>    round_up() returns round_up(remaining) equals rounded per_node
>=20
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic =
hugepages using cma") # 5.7
                                                                         =
                ^
                                                                         =
  we do not add a suffix to Fixes tag.
                                                                         =
  We usually add it to stable tag.

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


