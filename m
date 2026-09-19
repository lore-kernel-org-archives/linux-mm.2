Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F24C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 02:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192556B00A9; Fri, 18 Sep 2026 22:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D026B00AA; Fri, 18 Sep 2026 22:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F012F6B00AB; Fri, 18 Sep 2026 22:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C878D6B00A9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:56:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99B1740173
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:56:37 +0000 (UTC)
X-FDA: 85228998834.28.A136D15
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	by imf31.hostedemail.com (Postfix) with ESMTP id 896F120002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:56:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hh06aIAM;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789786595;
	b=iAECm9fkvNVKY8k7bQ59ARut+roMDuvvfuGVuCv7n6DvtGjDYVIFgaUVZQTqDZnVpZzYel
	rJu/9TILUnWyMs+Hpn5jJtK67kQnJJufPLJbL6zaraLzAzL2PGjkV0pkv7s7eiM3na25PM
	iO21RZRhXnS83oc71oR1s2R8jROWy+w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hh06aIAM;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789786595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IisJcy4c24GtaVLQ+uQfP0fyJ5+n7G5+jgIS+fqA08=;
	b=COXC+q2zV7Oy5zGPZdg9xJQfXz1PfRr7jEpAViv169DKK8dXe7S7pSrQ+qwsx1PX12QPqh
	fojfXFcdK1//KwF5r1zsdEZo56IUb85oXTAdPXnbJHwG1TqOhAiN7qrr5dWtHIHNqIpXy2
	usRAzesjPyxaYHsEvG99jmYMX4uTTvA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yW5QWWhUZOq7BqV6E9+8epbPkMvdcw1AQwYZWc1Wphg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789786594; v=1; x=1790391394;
 b=Hh06aIAM7INTTm2SAQkKnoi0XXEorzfU2t6eDKFA6Ea+Gb6D40MbaKp0PXPoY+rjSEsJ+K2T
 9B4dLTNaaO8VAZbXMk7DPL3iPFOs5ofEkQke9K7peBwxYRj3G4/X4LSiM3jjAviKWV9Y5WXx41L
 +SvYDz26aaZqTT0rVVe0+J0w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 1f3e88304aab8456;
	Sat, 19 Sep 2026 02:56:34 +0000
X-Mizu-Trace-ID: 1f3e88304aab8456
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/4] memcg: base swap charge accounting on memcgid root
 status
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-2-5bbf3220d88f@tencent.com>
Date: Sat, 19 Sep 2026 10:56:15 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Bingfang Guo <bfguo@icloud.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BACBDEEA-F7FD-4EC3-81E8-7806289E8762@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-2-5bbf3220d88f@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 896F120002
X-Rspam-User: 
X-Stat-Signature: dqtfs5moeiykixfnxquaiod4y7apx16d
X-HE-Tag: 1789786595-561925
X-HE-Meta: U2FsdGVkX1/KoCt2DXF1m85nZRiifYKp0+dbgbFQDoRD+2UuyOvqPn0t1+SraL89sx7+Wree0MlcoHEj2XQtLjE61S0Xh4qyBX933MsEEymno+PHw639Ad5/xMocLaLxEX9j4WMcMr8i1vkrPMbODqpw+sO0uDmFSMnGTQDAOhdJYDezSufGUj1cJBytZjx70O33DwTeskVQUSWFz/tRvhcj80ORYNj12NKbBEJtWeWqJXToXUoe+nW4p/qp2VxvNSe0kKc2KuYj1g61ISjEU8WKe7wAJ2wNTsR/wFIhWuXlpHT3b7lhVzIrxFot+PBSDWatv8KGfhd8AtoEBg+ZKbk3wgANjOJDIFThUZ5Wc2z3W3G4PR5Hsi4lfLBQgkgFNuPM6cKdxhOui4a3bxK3W2fHZJnV4CokiVE8tUjUz1VeLr1HBulBhDU5xVT0Lx8jc71nq/PeBNr4w5lgwVsnikIZnuZjmubCkJifIaXUYhQlPReg97hXpLpHC3KRnvhtshmotoD71Vzcnz+5bZ/y6rJG8prmLIWZzl/muuunxJP4Y2nFjNSlDP4xqMzqze/sNGNih1Fkblq1pn+pCykLPUmz44Mdba9pS3JZEMJXP3XJc+Ow7+KWG9c5Z6aXrSd9yNXOEfvoPp066Vl6DSxQP5N1whmWLVMy8MRkxKpLo0O49TmV9bc94LRt8AMtmA6tBuHRBNEp9xfKMaM946ypir1m+gYSrHcG5V8ei+eAGEJmTTmmw1tEZbWSjXtdxBemLovtnMcXYcnMw21ErspbSMoVPjPqlVDQAZQ9zWGFvD8ybUzqczWiKp4osTBsEKx2jkOBxiMhFb+Ut2qLFkCvjohkxrnR91IY1cHbhXdgeFpU3TzUDrdMSUbFWRIr1/kNq3yGAsXuWeMa4sXNz5P9n9GAOrQZ8r4z9MUud7RoQFIbOWywdgWsDP8o4p/RN2T7bxocL6vbUfCHPIrjnaY
 RngHL3QR
 YExXVwEHD298OhQKC1U36IZXHFjxbu2389dhskXLhIfJLaXIpmY+I7wXzglkuyi4hOg6Rn2uTF1Og5BMr3S01VD1xYFIXVDQS4uJ0sJ2sopcNyfFPIjiX6RVrAEdj1ljCqWuUGgwqf0EmP0tB9wPJDGWJG35UcoZUxn/ZWlxhY60QYOVzR+FjdHscP4Z2dJ6sz5D5q8+xcERQ6stozITznex0ZqhpoH45L6RH+ifxOf3KAIs297kqxtwo22xtflruXP/iuIyKRV9ApYl4fsl9e2EOMAQEdRVw+9Gdvbnsv0FWkscvhFANDwqcnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 18, 2026, at 17:18, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> A private ID currently pins its original memcg, so testing whether the
> ID belongs to root is equivalent to testing whether the resolved memcg
> is root.
>=20
> That equivalence will no longer hold when IDs refer to objcgs. A
> non-root ID may resolve to root after reparenting, but its swap =
entries
> still carry counter charges inherited by root. Skipping their uncharge
> based on the resolved memcg would leave those charges behind.
>=20
> Use the private ID's root status to decide whether a swap entry =
carries
> a counter charge. A root-ID entry carries none, while a non-root-ID
> entry must release its charge even if its current accounting memcg has
> become root.
>=20
> This patch adds a new helper to check if the memcgid equals to that of
> the root memcg.  For swap uncharging and v2 swap charging, simply =
decide
> whether to charge/uncharge memsw or swap counter based on the swap
> memcgid is root or not. For v1 swapout, don't recharge the memsw
> counter, just cancel the charge if the swap memcg ID refers to the =
root
> memcg.
>=20
> This makes memory and swap charging have similar semantics: one relys =
on
> the objcg's root status, and the other relys on the memcgid's root
> status.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

Acked-by: Muchun Song <muchun.song@linux.dev>



