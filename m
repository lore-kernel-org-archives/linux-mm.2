Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA6DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565CC6B00A0; Mon, 13 Jul 2026 22:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516916B00A1; Mon, 13 Jul 2026 22:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4568D6B00A3; Mon, 13 Jul 2026 22:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 192A16B00A0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:05:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 739A3120210
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:05:21 +0000 (UTC)
X-FDA: 84985740042.16.5019658
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8080140007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:05:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CuDkh283;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783994719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbJ5LwUhuXRY/Z1ZqpnZgDpdVeIUjnlTCRKxmq8/Z5A=;
	b=WH7vmD+xqYzde5wk+1Kc8UozW2eHYcn+/3LksnEsA8VxfP9CUwf5wJYdiwvnJUnLnSMe2h
	g/ShIiCalEiuEkmuGADlgfQ4VsuL8oBdYHOe3f8bTLj1fFVZ2exNgZkoZ7mRFuw6q0qD3J
	+lnANR5Vzel4t0q0GEPql8xdSZp6jtI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CuDkh283;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783994719;
	b=5w/IKv6NS3/YN+1aP7f03/vIERXLQYQapFtJSW6TJIQzfDXx6a2IakktV15fBs4+RF6sqE
	D7GenU68hTFKWRWxDwLOyN3FY4aajqJmLuHU0elRbogWL4jx5CDwOTNbyrLc5siVXjSZqj
	gxQ+zbed1uN8O/cSksm2ai55rScQNF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 961734374F;
	Tue, 14 Jul 2026 02:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0DA1F000E9;
	Tue, 14 Jul 2026 02:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783994717;
	bh=ZbJ5LwUhuXRY/Z1ZqpnZgDpdVeIUjnlTCRKxmq8/Z5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CuDkh283igfk/RoVjv23OF3m85eAWtwTif8W9ydD5h/jT+KADP/avJipKzjv51Pq4
	 jQi6k64QdnaWj+cNQglY7nm/RSDIAJ5HMqW2k/ruRNtkf2A+NPgR63OPHWYtapSQC6
	 YHl2w70jw8BAoUFFmifKvtE2Gh9KvAj2Um672PqE=
Date: Mon, 13 Jul 2026 19:05:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann
 Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, Karim Manaouil
 <kmanaouil.dev@gmail.com>, Frank van der Linden <fvdl@google.com>, Kinsey
 Ho <kinseyho@google.com>, Wei Xu <weixugc@google.com>, Bharata B Rao
 <bharata@amd.com>, David Rientjes <rientjes@google.com>, Dev Jain
 <dev.jain@arm.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] mm: batch rmap walks during large folio migration
Message-Id: <20260713190516.0c669b5207667c893a9c0938@linux-foundation.org>
In-Reply-To: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E8080140007
X-Stat-Signature: stkko8te89p85uxcm3yrbxra9os6kmd4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783994718-590603
X-HE-Meta: U2FsdGVkX19wKPbT61CgspiTbHtrCmzHEVeXPGmhOXBUGI7RyJY6hs4+UFeydLTmoMdgx0/x+S6mE1BjNSXN+lzImmjEEihyRGZWm6nn7ILBEETQ9inGk1dG6Hf0wCxUOsWI8OiM4d13t3Y2Nek/08B/Q66/LrviiXgzxZbSZph96CQuzDnh4NsQd3v0TGCpppNKMpicBVkQOY7UDLGOWHjEJc/ZWod+kcem67UahRoNV4bTKUS/tkef8KjjC01Y78yrQbIn+19gllgM7ophv5A9p5BP7DRDucVLAcyiuHnEjG0uMU3L5nSq9mT0MKf3/LYxU12ksd1H8T+2DMebetgHMIrLy7zZXppCJsSuJFwB0nrZT9aZKs8Yu/4Zr1z9bNj1GZAyw1jHvTbAOTVh2QGXgWLOhgm8tL/91ezX/XJkNznPKh5LSCTG5wQQ8W+CBDiyUTI1+FVRB8E/KpRAAz7OX46MF8WzDC8g0Ddno+MzGRfEsaF6i9olgndt8VaDJ6DAzsCAfobv+sIKv79LxSSdpmVYBpJrWYdjHYvRcvNiDgHZsBEMG+yr3jZR1gBlHG++1gxTlVof/3MEMVMttaWIc44bNjJb+9lkw6k+vVuKfIRyKXX5Sn6rJ3mAXgi8gW0O5KxSPeQ1xRW8Zjn2eLB3vOA1QYcxjsEs+VVb3S7qNHzWtjgrukIbZ7mXyHBPiCpwXohxhf7pMQHLAM3jDHA69xZoqqEsB54o8fRYRjA3zs2tyAZZoz+6bHJKNg2cFokwUUWorzGbnWAMC6o/n9Byx5n/eFBSg9v/ghJ46hfRb0g7QbT7bVGQUcpZm3BBnU6SppRRzV3QqfGMbZtQuVl0woVA9fdMQQPfgeJeiklPd2c6ZYOWEgt2HC26gXdG4WQ9eNV0E+FP0gCVhErAxEUWjTUXAqUNcXBCYjon4xB7DPjUYlO1EcUZMB58Q2QMI8CxPSqqt3q8AEzL8sh
 2uVqYCnA
 fmwmWYnXIJMnMcb6R56V2QvukSG7jqMu0EoGEHJ2MaGgFoyCdVhDupmP+KLdiz5ziG7HIo/h003J5xntk0rsTCpt/x0d0c7zdnVT9pQ2nS7OetJlSZn3TvpIPyU396nSndGGquHkw4zcbsXYFhGo+iT8ipxbsN6tqw0HQjGTZWEFVFTnPE0yxqAHpSlLjocwUX79/I+kAXHHPZq+Yl53KR+lkyMKvXhl6po645BvesFoydxpkQAmIJGjSqXna5stpN3XdjFE0YU+QuVCopKG7R7zBxB9XRcZrr8OX+IAtXExd/+p8iR6JnlDypxRZumFiwodM9f7wVnI5pDoxOEzaIurhxtOfz+moRKuqyjRZ7cn39PzcbDh1aZQY8+eeJaLS+UwGe6801acY0r4V1NTDdmWAWMB+IWMMVdBO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Jul 2026 07:38:46 +0000 Shivank Garg <shivankg@amd.com> wrote:

> Performance:
>=20
> AMD EPYC ZEN 3, 2-socket system (1 node per socket).
> move_pages() migrating 1 GB from node 0 -> node 1, throughput
> in GB/s:
> 		         batch-	        batch-restore +
> folio     vanilla        restore        unmap          restore%  restore+=
unmap%
> 4K        2.98=B10.09      2.95=B10.07      3.06=B10.05        -1.0%    +=
2.6%
> 64K       6.16=B10.09      6.24=B10.08      7.80=B10.08        +1.3%   +2=
6.6%
> 256K      6.85=B10.06      6.85=B10.09      9.54=B10.19        +0.0%   +3=
9.3%
> 1M        7.06=B10.09      7.17=B10.09      9.89=B10.06        +1.5%   +4=
0.1%
> 2M       10.97=B10.17     10.67=B10.13     10.69=B10.15        -2.7%    -=
2.6%
>=20
> In plain migration, the folio copy itself dominate the cost, so these rma=
p walk
> savings are only partly visible end-to-end.
> When the folio copy is batched-copy and offloaded to DMA engine [1], the =
copy is
> no longer the bottlneck and rmap-walk batching translates into much large=
r gains:
>=20
> This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:
>=20
> 		     batch-copy
> folio   vanilla      -offload(dcbm)  dcbm+restore   dcbm+restore+unmap
> 4K      3.36 =B1 0.10   4.16 =B1 0.18     4.10 =B1 0.14    4.12 =B1 0.13
> 64K     6.16 =B1 0.47   9.63 =B1 0.23    10.00 =B1 0.33   14.63 =B1 0.14
> 256K    6.70 =B1 0.09  12.98 =B1 0.18    13.52 =B1 0.15   32.30 =B1 0.65 =
   (2.38x)
> 1M      6.99 =B1 0.02  14.32 =B1 0.67    14.84 =B1 0.17   38.97 =B1 1.03 =
   (2.62x)
> 2M     10.74 =B1 0.29  64.25 =B1 1.48    65.36 =B1 1.00   64.97 =B1 1.75

Well dang.

Thanks.  I'll await reviewer input on this series.

Sashiko said things:
	https://sashiko.dev/#/patchset/20260712-migrate-rmap-batch-v1-0-872a734431=
d1@amd.com

