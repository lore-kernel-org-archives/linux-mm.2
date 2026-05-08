Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43BFCCD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 11:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DA96B014F; Fri,  8 May 2026 07:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635886B0150; Fri,  8 May 2026 07:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5716B6B0151; Fri,  8 May 2026 07:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45A976B014F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:53:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBB7B1A08EB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:53:51 +0000 (UTC)
X-FDA: 84744093462.17.270007E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 03047140014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:53:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jD/Q8+a8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778241230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcWfX0aS980lh6ScLuEu97wAzEYNTYA7DpQ/RQh5IN8=;
	b=wXf/+lGGat7sldsdKeIXG2z6G3PeJ0SgZSP3eClOhVZ8SMlNJq/oKGW+UGebJaML+VAV42
	XbOOonfkK6Ez9FpKFIGoWj0s+BdtfimeU+KqoMQfm8MNznqRKgB/Fysj6FPkJ8XDvDQYcF
	TSG11fHp0ACL2lnbJfM1jLVY2QjyMXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778241230; a=rsa-sha256;
	cv=none;
	b=4MsHCB82lLB1x2LRuQo7wCiweIdR7Z6Ksv9RYiramAFZr0wDzikxhq0ohhCpXCjBacz2IN
	4FMIzLG4OA+IWJt7ciV1Au0sIokBo0w1Fkfr8oEaD5aR89g8Cwxi6wuYqSil8Do1gMOSTg
	tST2WUcusjybE0QxrhCTa4EZ81UFDgU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jD/Q8+a8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52770600AE;
	Fri,  8 May 2026 11:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630CAC2BCB8;
	Fri,  8 May 2026 11:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778241229;
	bh=xVjGIZ5IQRdyjqPF7MNwq83MBWf3864Rm+exjqz/+zM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jD/Q8+a8K/ft4wOZk8mdokkpVL/c/gQDZFTCQS5ez0XSneYmxlfRAtaMwNNaQPGKy
	 zZEMzW3kW9/4iX7MGKRxUwnQgy0O/TEf42C/hioE6OxLz9jB7bNk8XyJ5Ub1Wq9JHq
	 fLiGzHKIa9jLa3f/feUEcbCXU/PKQ8fSXXcH9SbH8z8T0L28ee8HF7DoWl9f1bvIVa
	 adtf/6zkYF/Q6vWvlHodOxPhFA2fSjRjgpBVtJ6dAKUenY0rhYIoMmVwq6XdFZ5mm0
	 ebfN41jJI5G5vY4XDwd2/zaX30DZAsnMhRrIdksFrwKOGitKtz/LvZE5HdjRgPlmnn
	 JLatZ7qJEknNw==
Message-ID: <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
Date: Fri, 8 May 2026 13:53:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, Alistair Popple <apopple@nvidia.com>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 03047140014
X-Stat-Signature: yt111a5p8sexcu3mmw4khrsye49dfdfe
X-Rspam-User: 
X-HE-Tag: 1778241229-151576
X-HE-Meta: U2FsdGVkX186KNM+5+2Kau3A8LiNrh7+41Lso0JN4JhUdbzhFisaleQVovKksz3GrYCoBBJTetLv6hSBoPgjpggxssb2cDBe/5i+FNrszMTkIbCz+CTMABnYfN1fLt1RChmhKIY/B2HfcHTGafdfahcBggAoHy5ea8h3iNWQlBMf+ld0QPDtEbAGW1f1pxe/viMmDNxsn9e0aQz8NIyNsEX3D4d3xncWzdtFTkYtjtvgsnSpFCXxuWlnOr8RQrHvInXlyXrBtDaRujGebTi0sg2thNQgM3z3y9Wd4pG8xmbuVRfxrzKuMmHLayrJDR8aghoII9H3+mx/CdHaR8O0rxOdQ/2JiZ3yqrK8EXRgDZI+KSYWTsM7Td+LUOd4EoswQ6+pIISVOOuuw9ihgyBZjMYB8gRrKNDHQ8nBwjSAwECLcaGzR+vlg709LslNPYtyJhUNLR47r2m7nKDfvmgh9kSnNDEHpGMU7RuOkXnC9eICzezbVPqk1F2gc5TKzM3oOd6R802D5UMCwPBnO+rLvnk8jgSVI/m80am6hxP6Y87Q7rc/6xGPyCt+2CLWR/0Iaqq0i8J/CY1URNDDK7zJQToPj7k+sbwIoxrHLXJTf/040AMoR2ftk1aRmBycYgTir+Dmdy6ow2DFqRX2Hjtv3qpt/ml2cctlEzvYWrIpDLnO4njg4GTqVBP2HsDW0U7cwMLooCyQdiqMXhxuCRSmsaNF1pMrjC4dRf348uAkEIXTsIa85V2NqVj2jbz4yy8Cw5dJCGkxjtAWXS/yJ4xiiJYGYtUJUDHKA+loMWtp0P9hxLQnVh3YjHatuNBFCehwaFBV0fACPaS77DyUEn7CGOF55a0aTQUUFc4uR5WeYPoyP/PLNdX9W6qDaEQSxHnqJzw0H97NJaJmrPRsc0MFoUCKx/O8Pf1TFRv3XKHO10XAwOUBSmvtooUOSW3dOXqP3wvMSgR0K7zDin57hGg
 m72giSip
 rJZqopLR42YXPTtjSgF3XwgbM3D1AQuJaEfBRymW4W2bEC9Qt013PLVMymlq5oW3Ytto0bJcP0WNJF1TqDbmdlXXfiHVPT1JdYgpPLLwwb8lSorYk91eiqA5pcwBrOukRfSkJmWgAda4zQE1Ehpz1TbHCe0wlmA+uG/qms7l2USNP00Qd3IJrxRUcy3Akb6bBJlRaonlfxLoU+4gQvMGBRExRf04wBqvcASIk9YcnUjZ3sXz5EBIgC2+qOqIyr5+YTt+Xc8avoTVmQcbS0BNPES1zyO4lJEzB4eTY2NH00qy5hDrHuq5krdfTt+Y8rygCy+tlQEr5Exjz2cbcSEd/Ij9BLlYMz90mVkma5XMBhZjJvGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 17:42, Zenghui Yu wrote:
> Hi all,
> 
> Running mm/ksft_hmm.sh triggers the following splat:
> 
>  ------------[ cut here ]------------
>  alloc_tag was not set
>  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0,
> CPU#5: hmm-tests/2020
>  Modules linked in: test_hmm rfkill drm backlight fuse
>  CPU: 5 UID: 0 PID: 2020 Comm: hmm-tests Kdump: loaded Not tainted
> 7.1.0-rc2-00099-gadc1e5c6203c-dirty #285 PREEMPT
>  Hardware name: QEMU QEMU Virtual Machine, BIOS
> edk2-stable202408-prebuilt.qemu.org 08/13/2024
>  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>  pc : ___free_pages+0x2a0/0x2d0
>  lr : ___free_pages+0x2a0/0x2d0
>  sp : ffff80008345b530
>  x29: ffff80008345b530 x28: ffff80008345b700 x27: ffffffffbfff8040
>  x26: ffff0000c41cb360 x25: ffff0000c0c64008 x24: ffff800081aae400
>  x23: 05ffff0000000200 x22: 0000000000000000 x21: 0000000000000000
>  x20: fffffdffc5f20040 x19: 0000000000000000 x18: fffffffffffe7c78
>  x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffe7c98
>  x14: 00000000000001d1 x13: ffff8000818f3d58 x12: 0000000000000573
>  x11: fffffffffffe7c98 x10: ffff80008194bd58 x9 : 3ffffffffffff000
>  x8 : ffff8000818f3d58 x7 : ffff80008194bd58 x6 : 0000000000000000
>  x5 : ffff0001fedb1088 x4 : 0000000000000001 x3 : 0000000000000000
>  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c7f58000
>  Call trace:
>   ___free_pages+0x2a0/0x2d0 (P)
>   __free_pages+0x14/0x20
>   dmirror_devmem_free+0x13c/0x158 [test_hmm]
>   free_zone_device_folio+0x144/0x1e4
>   __folio_put+0x124/0x130
>   free_folio_and_swap_cache+0xa8/0xcc
>   __folio_split+0x664/0x7fc
>   split_folio_to_list+0x50/0x5c
>   migrate_vma_split_folio+0x13c/0x25c
>   migrate_vma_collect_pmd+0xed4/0xf68
>   walk_pgd_range+0x598/0x9a0
>   __walk_page_range+0x90/0x1a0
>   walk_page_range_mm_unsafe+0x194/0x20c
>   walk_page_range+0x20/0x2c
>   migrate_vma_setup+0x18c/0x224
>   dmirror_devmem_fault+0x188/0x2b8 [test_hmm]
>   do_swap_page+0x1458/0x185c
>   __handle_mm_fault+0x85c/0x1ba0
>   handle_mm_fault+0xb0/0x290
>   do_page_fault+0x1f8/0x6f8
>   do_translation_fault+0x60/0x6c
>   do_mem_abort+0x44/0x94
>   el0_da+0x30/0xdc
>   el0t_64_sync_handler+0xd0/0xe4
>   el0t_64_sync+0x198/0x19c
>  ---[ end trace 0000000000000000 ]---
>  lib/test_hmm.c:705 module test_hmm func:dmirror_devmem_alloc_page has
> 16744448 allocated at module unload
> 
> 
> It was tested on kernel built with arm64's virt.config and
> 
> +CONFIG_ZONE_DEVICE=y
> +CONFIG_DEVICE_PRIVATE=y
> +CONFIG_TEST_HMM=m
> +CONFIG_MEM_ALLOC_PROFILING=y
> +CONFIG_MEM_ALLOC_PROFILING_DEBUG=y

I assume there is a weird interaction between alloc tags and simulated
ZONE_DEVICE memory in test_hmm.c

@Alistair, any idea?

-- 
Cheers,

David

