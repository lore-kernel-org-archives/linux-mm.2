Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F3D4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 03:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE836B0005; Mon, 13 Jul 2026 23:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880176B0088; Mon, 13 Jul 2026 23:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797F06B008A; Mon, 13 Jul 2026 23:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52EAB6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:55:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C07DF16024A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:55:25 +0000 (UTC)
X-FDA: 84986017410.21.038B972
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A32A40005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:55:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rp3sJxsE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784001324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OeVWSaO4WQATBC/4qX0BBqStbi2xbbwcGw0Xf5MNwig=;
	b=NUtkRQfd54JM9QAkX9jg+TZwFPYyaaRNrbFJ3Ps+W1SB9llB1NyG2m2EHf5FUjD3VFXqQG
	VaX7W7Xb/Q54RGI44sJ+EAhmYxxdaYhzJqQeLFr/gWyBmSrvSqxcVrRR381WnVBVpwISx0
	8pWR3aYDVEn3MWbU4nTMHDGvY6NMf9s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rp3sJxsE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784001324;
	b=O9v12kGIOdMyq161e81vFN5DDp17gqL8334LudcNHBZleaN/lWOfQt5vWopp3yLg4J0AEt
	ApszWb3AElyTPiYKVPmeppVqDOVTBmPmZAXqd1cRFu3M454LN9ONQf/UQBK/Rv7IxZ2XyX
	aidyYcdHfvd8wwgqlkZPmiIhTAFlEDs=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784001319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OeVWSaO4WQATBC/4qX0BBqStbi2xbbwcGw0Xf5MNwig=;
	b=rp3sJxsELk9vdzoluWh+F/6SnC38h5CF5R9Az5l/xYl8L7Xxz4B92u1aI4Ujic84MweDNn
	OMi8nZnmQ9fNO9JJHmBtcJWeea6LCYHXJofGuekUkmbm0nH19pK9yDAZpZtRXF0e66aKn/
	Yj21CvubIXCwcD8IBSd4rhHz6uW7xAk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 1/2] mm/hugetlb: fix list corruption in
 allocate_file_region_entries()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713171456.300518-2-caixiangfeng@bytedance.com>
Date: Tue, 14 Jul 2026 11:54:28 +0800
Cc: akpm@linux-foundation.org,
 osalvador@suse.de,
 david@kernel.org,
 richard.weiyang@linux.alibaba.com,
 baoquan.he@linux.dev,
 shuah@kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5FB61ABB-6299-4EBE-93DC-BFAE855EE5F1@linux.dev>
References: <20260713171456.300518-1-caixiangfeng@bytedance.com>
 <20260713171456.300518-2-caixiangfeng@bytedance.com>
To: Xiangfeng Cai <caixiangfeng@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2A32A40005
X-Stat-Signature: dqsnk6ernxjxqwin1haiakjqjyoq5nrp
X-Rspam-User: 
X-HE-Tag: 1784001322-46202
X-HE-Meta: U2FsdGVkX18q8vLR/tZ8wXJLAbhy/H6I/yrkSERtSb/U+pP1li0dXVEMGMDuI+lq3Ajb9lvr5vbepJm3cyoVcnJ+V9xnJPlTYN1haFBE72CfD+hJ7NKN8tO+EzJNPDxjfyr/M1H40CS7M46Jv9G5ST/xarE1Klzl1klFO8dkIEyrcjWvJks7xkVmmV8rx511BGZYEt2sX7Gs/3DlUBPhF1+KZrekmgh4wuUsYr40WuE+CQ1Zt+8B3+5zEuKzQJLxVjLCre2TpS+DUZzmL/Bm3Nz3R8EyCAMOknzsZST3F7ErDhn1ynDI4WVeZ0KpoP7Kpd4e70M/LSHJba1v8C9xzxhMX2sHoTmGIlSVaYJ1eBTKxTJZ1GnY0HSpJv9AQokvsVFTHJeYDadh5nhXpWdLneOOPESZt2q4NA+CuwjMCT4JlTs9GEIhriwHB+Tpw6lHbPfIN4MM/3Smk3/gc+bS8hdON1/1HRQvnHoCfm35DYLPQlcmKSoqsvtymS13znrz6zsDuetNP05Y41U0sjFOvbiEICQcKZfhvQbXckjZ4mlgH6sUIj4O+iEV5dJBYAXsUkmZsyzWa9NliE+a7uJaoJfVPeI+XolcQlBiZZusndVgJM3FyHmBDv+jljIDqi74IMwiV8xX/SrQmgEFVY/KitTT7fOiK38U8WH/mtlzxFdBKtHPRkqrAC8xJuUZu/NP//v2p2npyOEBXp7Dc1wxTdt1pTf/YV32q0Kzttyq6rypWe1SU7RBLGBlLqWEYS0HumzBqXxj1UeSKlbztcaHRUXef2oC3lzu4JQPzTLZ377lWGD9IsaZDYViXF6ThdTiiYwT6b8N8ciB0yUTzyHSfSPYUebKmiJU2l343Ve0lnom2Ww5BY2OWzRbn1IV0Wez8krX+8/T5r9kOCY795lmcg9KFj8T6GHt+nXL1WY4IwBSzK/iAXUk3hHMQxdqZq2lDgJBZlN3kRwOKjjarJM
 7oPbrheS
 viciJpdhCz7efGvlNr+cAabPVlJh1ndWC1/TpQY/3Cnr4Qm6hifMRrJ3pZTMGtMUczyAx3rKrHVLzzlrw9lhvYBBRN0TmEB00eLStoQNQEqAAzwdO24vQbznTg0wzCI8SaaE351QpWf1OWjIev9tFSVdWIfSmg8HuSa7XK9hUOZjpo6A4zJxHwEI7TCYAXmRu/rVPL+QXNNwyj1kEin4hsvvBm5bA8LGZkz5tOY1Fi4cJg//AmZM05beEjh/Ta0ncaHh19GfzTPQ/22wshVB2EQbdyoshR/TLXiwvkZGWqvK5vjWIgu+3H0RzmMmJ811JZssoqibQruUmO9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 14, 2026, at 01:14, Xiangfeng Cai <caixiangfeng@bytedance.com> =
wrote:
>=20
> allocate_file_region_entries() tops up resv->region_cache with freshly
> allocated file_region descriptors.  The allocation uses GFP_KERNEL, so
> resv->lock is dropped around it: the new entries are gathered on a
> stack-local list head, allocated_regions, and spliced into
> resv->region_cache once the lock is re-acquired.
>=20
> The splice used list_splice(), which moves the entries but does not
> re-initialize the source head, so allocated_regions is left pointing =
at an
> entry that now lives on resv->region_cache.  The top-up runs in a =
while
> loop that re-checks the cache deficit after re-acquiring the lock.  =
For a
> shared mapping the resv_map is shared by every mapper of the hugetlbfs
> inode, so a concurrent region_chg()/region_add()/region_del() on the =
same
> resv_map can consume cache entries during the unlocked window and =
force a
> second iteration.  That iteration calls list_add() on the stale head =
and
> corrupts the list; with CONFIG_DEBUG_LIST the __list_add_valid() check
> trips:
>=20
>  list_add corruption. next->prev should be prev (ffffc900011ff7f8),
>  but was ffff88814c281460. (next=3Dffff88814c545640).
>  kernel BUG at lib/list_debug.c:31!
>   allocate_file_region_entries+0x191/0x420
>   region_chg+0x267/0x300
>   hugetlb_reserve_pages+0x387/0xc80
>   hugetlbfs_file_mmap+0x2ce/0x3f0
>   mmap_region+0x1348/0x1a80
>   do_mmap+0x85e/0xb90
>   vm_mmap_pgoff+0x18c/0x330
>   ksys_mmap_pgoff+0x2a1/0x3e0
>   do_syscall_64+0xd7/0x420
>=20
> Without CONFIG_DEBUG_LIST the bad list_add() silently links a =
kernel-stack
> address into resv->region_cache, leading to later use-after-free.
>=20
> Use list_splice_init() so the source head is re-initialized empty =
after
> each splice, making the retry loop safe.
>=20
> Fixes: d3ec7b6e09e5 ("mm/hugetlb: use list_splice to merge two list at =
once")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Xiangfeng Cai <caixiangfeng@bytedance.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


