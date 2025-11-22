Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F140CFC522
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 17:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181BA6B000A; Sat, 22 Nov 2025 12:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132876B000D; Sat, 22 Nov 2025 12:58:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0476B6B000E; Sat, 22 Nov 2025 12:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E457E6B000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 12:58:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4076C1609D3
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:58:14 +0000 (UTC)
X-FDA: 84139002108.15.1E60227
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2094414000D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:58:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="RUvPt/l8";
	spf=pass (imf23.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763834292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBD25WHvqvimUX161O9Xcdajk+rB/gauVTWiODhYTog=;
	b=t+DFRGKD1Qe2wk6xbbGb19s/wHs2xpvAwb2K0quwwzKMHp6Ybpbfnuq1e8JAJYjjcehoVQ
	bMDGyjkoE9lsoPYm/1vGBLvak7JSEvFvRn1bPH90vXykLs5d8YkHViKMKLsSfGr0NuCJ+Y
	GpZ0716W9O5p+2RLkGg5dOw1Zg3LYEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763834292; a=rsa-sha256;
	cv=none;
	b=EBki0kmB2VOi9QEOSAesckpfnD0tH6Z4Q5/qOMW1i4SRFVf+Z1Fuo/yn2iTTWOm1MRQjKC
	mv131f9/oMwJTfFs7D20vtsa5fqzNpnv8lViZa/aXbnE71pSxdQSBMy/xsa7pOoXL2QpYN
	RJ1FGYHlYEwoSPSC5aJhZ0VgSv3/+Wg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="RUvPt/l8";
	spf=pass (imf23.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=cB
	D25WHvqvimUX161O9Xcdajk+rB/gauVTWiODhYTog=; b=RUvPt/l8AlX147sonr
	R42c5ndf9KU2rPuLLXCufoO2tVBYfn5T75hWq6QEAHw7GkyiwQNXxbaVwPMnGADB
	X4e0jKY5IHGECkaLD6nuuZL4PdKrhYVuHnsC/xNjY8fsmbNnycQl9Xp/h0nxdD8+
	Yah2c14scDHnp3C+exVNW0BoU=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBHehGP+SFptyDHBw--.20298S2;
	Sun, 23 Nov 2025 01:57:36 +0800 (CST)
From: ranxiaokai627@163.com
To: pratyush@kernel.org
Cc: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	changyuanl@google.com,
	graf@amazon.com,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	rppt@kernel.org
Subject: Re: [PATCH 2/2] liveupdate: Fix boot failure due to kmemleak access to unmapped pages
Date: Sat, 22 Nov 2025 17:57:35 +0000
Message-ID: <20251122175735.92578-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <mafs05xb43ch3.fsf@kernel.org>
References: <mafs05xb43ch3.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHehGP+SFptyDHBw--.20298S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr4kKr1kZw15Gw1UJrWfGrg_yoW8tFW8pr
	yUK3Wjyw4Dt39IyrZrA3W8uryI9ayfKrWUAr1UuryfZr9xWFySqr4FyayvvFy3GF48GF40
	qF48tFyxXryjvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUo5lUUUUUU=
X-Originating-IP: [117.176.242.91]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEBYOTGkh99AiCwAAsC
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2094414000D
X-Stat-Signature: 1r76yxfyxpw8e68tyre95xtqmg9tgiiu
X-Rspam-User: 
X-HE-Tag: 1763834290-235004
X-HE-Meta: U2FsdGVkX18JPGATUvEd7DBqZgTZp1nEl7MEp+WqXczDvstAa6SGMfDsMpE7gOUKEzmsaY02VCgNognrriWX5PGyL9HR+H83TCy/SSAB9aAqZ7qigD5pMftVM94xL2NuBNVGpGdd56jhq53STbFNA92lHx97u7isofoqyvNuKZsqICxfL3pEkc/Jn5GOzVE3SRc28OMCtxxwzpCQGbXHBa6jWZxspiQbhZQg3+dyr+wovKCLeYAxfOJW/BWA0NOOhHxVqZALvMXvvi+LHYar9DLhxNx4GFe/QlyeCh2yE9woB6R/8LSVX6Rgy6PaX/fZsYCI/U+bsjx4WsKO8WHWTrxVHRA+GnISddZ2QMkbs84jUND314KBngf6wtNQOSgKABkUbeokKcCll9pTunT/9j1NnuU6NeY+iTp30QfyaiiWCx2ci7Rd8M9K2ZiZJrv3vuACQfo5/MRy2nxUZEtJLU86Vu3AwroPAMpeDRI0YTraeoKDkTPm1/g9YXSnQL8wX8L1ppYUWTzXtNvYav2JHWiqSSeCjckV6f2NNdabYkqqnwvGpULIVRIOkzvOIvyp7mT5zIllZMwmfzi1NyOoqc+TFMAaxFerfRWXmsq2gKlCxgq4XHUAYk9ixUpagxCeENHKi3rFz4tt5962ARgFkL+o0CyNHWlGQWQ7oGRRaggX6Uv7vYZ3IIyXjGbNvEzKYMO+l9/3qiy+S6DqmUGXT1m0P1w9Q8UchLRRfk2jLMUafqJL4YBtQ+Q4uCzCnqCVkj98X4kcDKTgsuXZVNcDtM9SbVt8yRsL5t2bVC5/hRQ0kv9II9/gDhXdrt6ZSfrKFm6YI51wReZH02deVoJmk8r4c2JOyYc8ipub+rBIdh3TmQ9FWGp0TbECXqFHC8efLTAYsw70VvwMqMN47oojetBkzA0ISaegk/2f6w40TiLmP6TThkIdRrXUWhJJPVYTcgwMUy/gQl8diY19/VU
 6qmh+nnk
 JvhUcZn6MnWz3F8SJAVjJlyd6T1KtPawoUbWUYh8wdpLKmo+Jq6cQwYJxfnf1dgLbJ1mMvp5WQHngcYtEfEzxSVfHMMFo7Nh76QBRBk52Y2brrNa7EhaIt1qrsqQLt3JXXHgv9XNB6rN1qurAfflw7U++FMNxm+VDnnrK07YpAXyVgGaHK22Nu0ncu5eqUcJ706rIJuHXxVJRNHLXXqXJ4Ntey8dOVzUDKNrNH3iP3SF7UKYjn0v6hULKJJmnF5VoG1xprffKcBLHiBymzKKvQW0nP9Iv5aBpbkMG0iwxGXOW0ksvab/M6kD2vR3dzIUMZi713vATyxQwQaQy+NPXOMt7lrFta+SmH2S/Vzk2/2yiBlWpXR21hgD0zLGZvkTOLPVQpQTV2tr5AfHw5kd8Ki6tG0MauB1/LB7oTjvjhtKgafE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Thu, Nov 20 2025, ranxiaokai627@163.com wrote:
>
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> When booting with debug_pagealloc=on while having:
>> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
>> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
>> the system fails to boot due to page faults during kmemleak scanning.
>>
>> This occurs because:
>> With debug_pagealloc enabled, __free_pages() invokes
>> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
>> freed pages in the direct mapping.
>> Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
>> releases the KHO scratch region via init_cma_reserved_pageblock(),
>> unmapping its physical pages. Subsequent kmemleak scanning accesses
>> these unmapped pages, triggering fatal page faults.
>
>I don't know how kmemleak works. Why does kmemleak access the unmapped
>pages? If pages are not mapped, it should learn to not access them,
>right?
>
>>
>> Call kmemleak_no_scan_phys() from kho_reserve_scratch() to
>> exclude the reserved region from scanning before
>> it is released to the buddy allocator.
>
>kho_reserve_scratch() is called on the first boot. It allocates the
>scratch areas for subsequent boots. On every KHO boot after this,
>kho_reserve_scratch() is not called and kho_release_scratch() is called
>instead since the scratch areas already exist from previous boot.
>
>Eventually both paths converge to kho_init() and call
>init_cma_reserved_pageblock().
>
>So shouldn't you call kmemleak_no_scan_phys() from kho_init() instead?
>This would reduce code duplication and cover both paths.

Thanks for your review!

Yes, both paths converge to kho_init(),
for the first boot, kho_get_fdt() returns NULL and
init_cma_reserved_pageblock() is called, but for KHO boot,
kho_get_fdt() returns non-NULL, kho_init() returns before
calling init_cma_reserved_pageblock().

However, in KHO boot, calling kmemleak_no_scan_phys() is unnecessary
because kmemleak objects are created when called memblock_phys_alloc() and
KHO boot does not invoke memblock_phys_alloc(),
moving the kmemleak_no_scan_phys() call into kho_init() both resolves the issue
and reduces code duplication.


