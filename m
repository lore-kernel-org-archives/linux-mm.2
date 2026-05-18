Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB28CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9B76B008C; Mon, 18 May 2026 04:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A4C6B0092; Mon, 18 May 2026 04:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770EE6B0093; Mon, 18 May 2026 04:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA5B6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:26:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16CC11C1E52
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:26:39 +0000 (UTC)
X-FDA: 84779859318.03.440D8F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37B86C0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:26:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3VFbJpm;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779092797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Dvmluo0XzRiGu492kAMvLotLjxquXwpfBqvf+6/6os=;
	b=PeOBRX6/G9DNEiSW4s+QnMc/huavgWmUz4eesKd6AqLKRNfxgym1QfeTLaLodn7T/1jvkg
	eU3KDmhUumy08HCrKbKgBa493JnE1kYU6PxdI7sdtFI1HuPeElCuc04k+7jzEd+XfBv20R
	YAfoYAhGqZJ6T/B86N2KH9Kk8XZnJh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779092797; a=rsa-sha256;
	cv=none;
	b=xjR4OMcccgFYgtJcWhZW55fffGD2C3Ro3OGurg8bLKKjU9iIMKZXsdf9aZ4SQfQu1yzcB9
	b8z2Wtsn+J4VplLeYalbTbW+OIi7b5S+iy4kkqbBiCnTzMkKvgbNeRrTZdo9O7oVVUsOYQ
	9DXZQlFQZnK7bjR8nYxXuftSUvrX66Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3VFbJpm;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 49F9743442;
	Mon, 18 May 2026 08:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D2CC2BCB7;
	Mon, 18 May 2026 08:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779092796;
	bh=4PvfaXRPPE9RDMZilXQdkBPoxKj2jDShuEmzMiZWOXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K3VFbJpmlrHbltRWK6+8l/mrb+LWCe+rypjgJ527R/9H9WxhSMo8Gp9ZRYf6sPdv+
	 IZ2ukc99XPwwrt6ZPf90pcjLdxYx4coYmKWK4CKjzNjiK26OcmXOHXLWLdrVgFFn6S
	 prCzFHeKAncrZaXdUEGQRGuMyors1GTDNTUPHadALpn/Pj17aocUjPD++JszRfalxg
	 3aNqUdtiIhX3gJj03jWkEHNuCQQXVqVSA1673WSovtfidfMGE3ENzdn7W1qmsCYyoX
	 pDLwI9rzx1nhyvRZxOj/wjFQjW9iWzB7b2c1L2nNq9MFCNHy5RyxxlISZCxnUjfK+Y
	 1uQLz84h1eBUA==
Message-ID: <c059d437-b77a-4ea0-881a-39d8fc833c54@kernel.org>
Date: Mon, 18 May 2026 10:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: Fix spurious warning when unmapping
 device-private/exclusive pages
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, aarsenovic@baylibre.com,
 dri-devel@lists.freedesktop.org, matthew.brost@intel.com,
 thomas.hellstrom@linux.intel.com, jhubbard@nvidia.com, stable@vger.kernel.org
References: <20260501065116.2057242-1-apopple@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260501065116.2057242-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37B86C0002
X-Rspam-User: 
X-Stat-Signature: 69r5j6qnchnkjstsms94cnngkfkop9cc
X-HE-Tag: 1779092797-725140
X-HE-Meta: U2FsdGVkX1+4Qi3iu6ciouzrfyBX8SRmEoVDWCwd57nF4r0o6aFa/Zm8e74frgttfVbvEzsvr+BP08Myn94tfnJi9YLj3lOdUNB2kLYiDgEDIKuda0YOZ3Kro5A8/GDdJvTSb655OJKwCiqdyNCsPeUDxFWKbmZn603JQ0thUFtrl5mmNptl50on8j+HAcC9iqhdfVtU/LDPGbmp+/yMiJ6G1iFuTQErQye448dTvARcvPcM5wNOR5yaow1Fzy2E0OzIKXW9ak8pq7zEd1eizdKxDXbN4OfgdHnt9H8Z+X1ffEkW/qp2HYH4MD2PNUwpAKfckYODbViQB4d67D1o8V3evSmB8/E/jOKGaneAgrkC4uaPtwCq5ctVSe6gns3D32wpEQFt3Kgmf28dbHiSpkJx8PC3LSHngLpT/kCr8ib0kxG9+YFV6EUdNwaOPwOXlTedGGTH3hH9wxmDgw1d7SiaaT85sIgM9A86xuRUYSHN//PbAHO+nkhABonbqzDVGp0fD9sNoCTpYXHu6m1blLnxpYAEPPy6Ba+Cs4seytO+1QBfDoqY8y8lhznkJpn8wU+bqQx1C2HO231K+IF40SJzGfKSjIxvDRwe89jk7zy3/fiiqXJ35zyylOKqrlrhqzljxc1zhevai9idVi2qFcbl6RQ1UZ7WeQBAcSCPUTL8uqGXagyz27xEGECnmxAZGI7oF4hPVPivlJ4Vtsrbk+InN2kRwbpmares/gmNh6eT23Q1/FMM72u4Mfd9kPe9Vpqc6GFnL7oJvltY4bDSIEogoyD6kLDS8mTphFTGxiwbLScaZ0YPOL3TxzgRf7m2n2nHg5d88pQgzHvzxWN6iSlet7lffwJJHBRNRu1NO5Tf7lrWW7ch8gIqXVCPpklpEPRDc1ubh27caFnEjuimwRfPGoAeu7RAMR0q3Rc/GT5/9WPfcyEgYBiBlidHL4DcC/W1VtKoTqUHr4HZnRp
 E4kbmuw9
 vFL5vUfbMeV6S0nhWHBOU7q9E961WC2osCwxTUgzjssh0eA1zzFjZqp1pZEmk2v7rCG5Q8JrhoBp4ndKZ3XkHUffLu1O4ckjOrYN+rqjl2YkWTU4lm7/nYVdwdT1XDaONCntBY/TcRgMB5EesWMZ/RW5SmrRTcEdUETmEruopKGwxljD7Iiq8eufdCg18xA9PJz5w9HK2SPMmIcgn7Oa3uvxJjxmU0YKYkgJOAOqHcQ+3tfv7JFUsrtehNcRSi+jtZwegp+aM9pRdJzK/G45voAs3JcRlk9oEforueVD99pjkjd4jCUx+vwz0mFmoLdRKexKQBydZXrowL6lcrqyed4ocWJ9yCoSW+M9Iy0gjgQcyG31R63wPgPp3vg1hZcQyoSjzaZlt/t8rFGNwDU2R78rja721eGfX8/0EGmv1P0mUpmiydETFxsXxYYJzTHvwONvL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 08:51, Alistair Popple wrote:
> Device private and exclusive entries are only supported for anonymous
> folios. This condition is tested in __migrate_device_pages() and
> make_device_exclusive() using folio_test_anon(). However the unmap path
> tests this assumption using vma_is_anonymous().
> 
> This is wrong because whilst anonymous VMAs can only contain folios
> where folio_test_anon() is true the opposite relation does not
> hold. A folio for which folio_test_anon() is true does not imply
> vma_is_anonymous() is true. Such a condition can occur if for example a
> folio is part of a private filebacked mapping.
> 
> In this case vma_is_anonymous() is false as the mapping is filebacked,
> but folio_test_anon() may be true, thus permitting devices to migrate
> the folio to device private memory. This can lead to the following
> spurious warnings during process teardown:
> 
> [  772.737706] ------------[ cut here ]------------
> [  772.739201] WARNING: mm/memory.c:1754 at unmap_page_range.cold+0x26/0x18a, CPU#17: hmm-tests/2041
> [  772.742050] Modules linked in: test_hmm nvidia_uvm(O) nvidia(O)
> [  772.743959] CPU: 17 UID: 0 PID: 2041 Comm: hmm-tests Tainted: G        W  O        7.0.0+ #387 PREEMPT(full)
> [  772.747104] Tainted: [W]=WARN, [O]=OOT_MODULE
> [  772.748509] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [  772.752117] RIP: 0010:unmap_page_range.cold+0x26/0x18a
> [  772.753780] Code: 7e fe ff ff 48 89 4c 24 78 4c 89 44 24 38 e8 f2 ff b1 00 48 8b 4c 24 78 4c 8b 44 24 38 48 8b 44 24 18 48 83 78 48 00 74 04 90 <0f> 0b 90 48 89 ca b8 ff ff 37 00 48 c1 ea 03 48 c1 e0 2a 80 3c 02
> [  772.759602] RSP: 0018:ffff888112607550 EFLAGS: 00010286
> [  772.761310] RAX: ffff88811bbf4dc0 RBX: dffffc0000000000 RCX: ffffea03e9bfffd8
> [  772.763583] RDX: 1ffff1102377e9c1 RSI: 0000000000000008 RDI: ffff88811bbf4e08
> [  772.765914] RBP: 0000000000000006 R08: ffff8881059f7448 R09: ffffed10224c0e68
> [  772.768184] R10: ffff888112607347 R11: 0000000000000001 R12: 0000000000000001
> [  772.770461] R13: ffffea03e9bfffc0 R14: ffff888112607908 R15: ffffea03e9bfffc0
> [  772.772782] FS:  00007f327caa2780(0000) GS:ffff888427b7d000(0000) knlGS:0000000000000000
> [  772.775328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  772.777187] CR2: 00007f327ca89000 CR3: 00000001994d5000 CR4: 00000000000006f0
> [  772.779135] Call Trace:
> [  772.779792]  <TASK>
> [  772.780317]  ? dmirror_interval_invalidate+0x1a3/0x290 [test_hmm]
> [  772.781873]  ? vm_normal_page_pud+0x2b0/0x2b0
> [  772.782992]  ? __rwlock_init+0x150/0x150
> [  772.784006]  ? lock_release+0x216/0x2b0
> [  772.785008]  ? __mmu_notifier_invalidate_range_start+0x505/0x6e0
> [  772.786522]  ? lock_release+0x216/0x2b0
> [  772.787498]  ? unmap_single_vma+0xb6/0x210
> [  772.788573]  unmap_vmas+0x27d/0x520
> [  772.789506]  ? unmap_single_vma+0x210/0x210
> [  772.790607]  ? mas_update_gap.part.0+0x620/0x620
> [  772.791834]  unmap_region+0x19e/0x350
> [  772.792769]  ? remove_vma+0x130/0x130
> [  772.793684]  ? mas_alloc_nodes+0x1f2/0x300
> [  772.794730]  vms_complete_munmap_vmas+0x8c1/0xe20
> [  772.795926]  ? unmap_region+0x350/0x350
> [  772.796917]  do_vmi_align_munmap+0x36a/0x4e0
> [  772.798018]  ? lock_release+0x216/0x2b0
> [  772.799024]  ? vma_shrink+0x620/0x620
> [  772.799983]  do_vmi_munmap+0x150/0x2c0
> [  772.800939]  __vm_munmap+0x161/0x2c0
> [  772.801872]  ? expand_downwards+0xd60/0xd60
> [  772.802948]  ? clockevents_program_event+0x1ef/0x540
> [  772.804217]  ? lock_release+0x216/0x2b0
> [  772.805158]  __x64_sys_munmap+0x59/0x80
> [  772.805776]  do_syscall_64+0xfc/0x670
> [  772.806336]  ? irqentry_exit+0xda/0x580
> [  772.806976]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [  772.807772] RIP: 0033:0x7f327cbb2717
> [  772.808323] Code: 73 01 c3 48 8b 0d f9 76 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 76 0d 00 f7 d8 64 89 01 48
> [  772.811337] RSP: 002b:00007ffde7f57d38 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
> [  772.812564] RAX: ffffffffffffffda RBX: 00007f327cc9c000 RCX: 00007f327cbb2717
> [  772.813733] RDX: 0000000000000000 RSI: 0000000000400000 RDI: 00007f327c289000
> [  772.814867] RBP: 0000000000421360 R08: 000000000000001a R09: 0000000000000000
> [  772.815991] R10: 0000000000000003 R11: 0000000000000202 R12: 00007ffde7f57d74
> [  772.817121] R13: 00007f327c689010 R14: 0000000000100000 R15: 00007f327c289000
> [  772.818272]  </TASK>
> [  772.818614] irq event stamp: 0
> [  772.819159] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [  772.820174] hardirqs last disabled at (0): [<ffffffff82a57ab3>] copy_process+0x19f3/0x6440
> [  772.821511] softirqs last  enabled at (0): [<ffffffff82a57b00>] copy_process+0x1a40/0x6440
> [  772.822869] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [  772.823871] ---[ end trace 0000000000000000 ]---
> 
> Fix this by using the same check for folio_test_anon() in
> zap_nonpresent_ptes(). Also add a hmm-test case for this.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reported-by: Arsen Arsenović <aarsenovic@baylibre.com>
> Fixes: 999dad824c39e ("mm/shmem: persist uffd-wp bit across zapping for file-backed")
> Cc: stable@vger.kernel.org

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

