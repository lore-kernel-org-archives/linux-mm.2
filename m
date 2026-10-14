Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F6ECC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F7B6B0092; Wed, 14 Oct 2026 11:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6EF6B0095; Wed, 14 Oct 2026 11:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5CA6B0099; Wed, 14 Oct 2026 11:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 491CB6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:36:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF6CC160637
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:36:10 +0000 (UTC)
X-FDA: 85321632900.08.A4B7ED5
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1102740011
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:36:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dzxVxqTE;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=qA6YOwaVdkDe5WPMOWVzqY8zBl+ZRCOyb3XB7KK+18Y=;
	b=fTP8YLA9xJazgR2cpUJf9JcvoD6vOHBCcHteJSMjNM4dpFkxYL3fHUxDcKgOV+dsgFpcfI
	1QDcJ/OrImq3oP7kZF8R5Wqx2JznxB+o1rpFLoYIYipvocjFMjzQVZ8sksul7WHitlOKj6
	tt0RVpvSK0gbs9uqnnZGwKMli2pU6k8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992169;
	b=epFMU1VdZ0NCCw6modblsG7IlqqCMYqhlVl3xwk88ifApUApn9CxX5hCMG/NUN+sAgMw8q
	3/BXMc/FPFRSPJaZKreqJwwbLyJhGF7dTDvAXHMHa4jhSweEyka4k3vwhjHKgBYFpM1jzK
	4V9fQanG/VLo5WIZ55Z/sRKGJB0qqnU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dzxVxqTE;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3550c917fd3so1544827eec.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791992168; x=1792596968; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qA6YOwaVdkDe5WPMOWVzqY8zBl+ZRCOyb3XB7KK+18Y=;
        b=dzxVxqTEyYOG1bqYhB7urs7M9KeZqAV2tttxcaySQyAJjthYMqysG30ua4+uB8nYuN
         kMSQKyX9g6tJHdWJQCrEeaGdTBpNXPJIup5tSVkDGPYkiuDlioN7u3AId6X+95Eq8m5z
         Etr2+/c7vrnvXIk1lG/ZSYllIhbc2fnG1Ht8L1D8N5IqiSUfNHfebzokmaNGNpNU2XGi
         GW4qlUeSU0QrGXF78MRp5mkuDBWR48tIVF9rRp53kC2fWma4JjNddEbOkvFjnNSEGNf+
         frasdwzlky5NSH0iDA88kUcXYLaVAW2dzjLUx6+kMpYaKPDFBrBQrYMBAoNAUYnO6MDw
         HOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791992168; x=1792596968;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qA6YOwaVdkDe5WPMOWVzqY8zBl+ZRCOyb3XB7KK+18Y=;
        b=nAbgg6X2fTUxtMM3ZslUO9c7HRJupLHxQ8b7rk6ChQeqtlgoqu4nA8lqAb0YgQQKXw
         mYsOyLA1Ywfqsn1kRO7csJO9mODenSJcg5czjmxT0wzzUahRBVqx3K4q/Sb56/IQSSZs
         L5X5lK6DqyMTVj5lyq5b97xsQ8ulH0YQAbJEyMsFvA0Asguk80YtDrDfXH2tv6B7/ETT
         xPdXdd86i/0eVXx/ybjMGoPaNL4I9yWjfRmWQ1k3MjlOpont2REV8z5N2sfFnFv/Avbi
         YQHx+Q4o2BYfmUI+9UkTtufm/ZBYXA5EJdR+p4no3pSDVmTCAFemqMqSp4/RKxU9Saxo
         wXig==
X-Forwarded-Encrypted: i=1; AKwUvBxgpagp6YC/wwhwI80gNrHYMBIfouLl2wkm6OmED4wwVPpfhr25X/Lwkrtnn3qCuvHuhlkR2vuA7A==@kvack.org
X-Gm-Message-State: AFq9FYJ+mfIJ+IKIjgA9OrGBJ713tpn0SY58Y6cbcDg7/Y+cGu2CibAf
	81mzj6FFeK5reCAu0lYQ5SvGRuKu920IvSgOPguu0FJZm5up93S+ePuw
X-Gm-Gg: AYBFou0rzEImpzi/its53NOkj0kQIHMTJnDcuguo35pTmCpy1kUQlmDMhVbkntsWlTY
	FlcSllxXGaI88xI0XfiWZeOY+7l1J1W8XpwbmZJimrtwmPCFMj3A4+aaHUNIPnaJx/2pIh6YHid
	OHlAv8xeRmi2Ex3VeI9EWIFebBUyy+yrRRnfA8zY8tzZhSvUN1a0Z/Metze1krypVVerThEffcn
	xErG4uOPooggL8dAJN5tc0XqctkbwZL6mtxwxv872jW3qXCsmbPfJVGglAh91OhbyiMSvX7rBub
	so+X3BiX7JCrsiOPyZTykIGXX4zLYx5Z9LaSgpViskG3mSAdjJBdaRUW8lRccvsBk1whlgydXuX
	sfvDt7pO3Om9MWpmp2pbTWLOUoMLupGGrds1LURi0Ytxv+0AdVvCD5EbGNwe6aCosBkLiC6O6UY
	uQbbBzzl7E2IkUn/wFprosbp/cYGKLS7SKm1rT/bESPRDgA+JXXvr61HjjUId2IJWuKam7
X-Received: by 2002:a05:7300:e9d6:10b0:359:bdc8:c9d5 with SMTP id 5a478bee46e88-359bdd83104mr17479248eec.21.1791992167458;
        Wed, 14 Oct 2026 08:36:07 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm58172660eec.12.2026.10.14.08.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:36:06 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Shrikanth Hegde <sshegde@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>, muchun.song@linux.dev
Subject: Re: [PATCH v4 0/6] mm: Unify device DAX and HugeTLB vmemmap population paths
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
Date: Wed, 14 Oct 2026 20:19:23 +0530
Message-ID: <wlrkqqvg.ritesh.list@gmail.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1102740011
X-Stat-Signature: cyu6wxcqezhfhics6ftyqxp7yf9kyx3f
X-HE-Tag: 1791992168-37068
X-HE-Meta: U2FsdGVkX1/ZCbQSh/L4S+4ZCRa833JFWfWkUQZ8EcfC0SMCbtDLLydxASbWmyonItE0gls4n7licYEIl7h8xL60orMlMAF0amppJjqE8X4BxH1+UuSrDpiTPjyCMc5YEhK0hlJsnoP3XmRZcmyXBU/Dji39Hco/F5ihAzw9wqK8eOKE6pIJupbf73vV/UENjpR2yZxtm2cCGTTmhYOjl/mHmsBBNFO97U2A3VxTKGJ8qPa9EyfMARnDrS08nr6BXwk/OUqHBGKWlIWVsZjF1DhJVLm5ss6806ikxh4PuEkiR6VfN5X+G8q2nBxigsHCNCpHD2mTElky75oun6SSNpORB/Bq4XS+vaSW9UEIObMCtpQRsEbr7bVcWvPc6ci+SxfWBlEEr8MTX15hmjNTbfR9rUuYU2FimldQpmMLcEaF9SFgEC7ToWcaQJGUKI9Dyyx9yGvjjDEzzDfaipHuplSnKeoK2dq2UxSHnlrC5rg+AqRGtHRSX5rwmjT1kULF4ZMPY1yjcOm1kvpdH5Kj6MCnkNRwwXP1uwv878IYa6TDitrhdCR3rBJGThtE/Cs3+Px3OeeZblk0S8Yz87pJFftccYCdQwWvI54WSxH8zxLawBKy/kcjMYvdceXmLXLYdre2I3ypcijzXem5KADEiNC9WDpJxJ5Z5m9hn4JeXNkSSjwaLfAH4MaHlh2HQKCT47kge3XFvac+kkxF19czOoLCvC5KG647GnOKFHQA9xNXb6f1EWF9fYlCJUJ4Mq/Jaie4NunqPCydimsMy6mKtBVRZz/7j/WeejI+qa2ekAY9URwwztsRylxb0ezh51f7wRX8S+55CsyouCygMdMfBDJ4dY6h8cFzOV9I5PjjqQH35KIBuS1c2WBVRbOFIS5vtkG/rn6VFy/cf8hP6kvPe9O5dgILsKLbS+JaAx7DgKILUxCe3Acy7188PLF4jp6aTscDvv0HJy876exZ4vF
 Uj9rgnq8
 BSSfPtHuFIOD6YcNYAIIXrhugRZ/3F1JnQnpqJmvtXkuM+MGhh/PkzEKxO08C/cWh03L0iY5cskLiqzJ/1/QMHNcNyL5ZiMZ+LlxS4fI6OsmacIGZX2mlbE3JJS0x7ItNQfmYp+B134vuAvHGyK9OhrbUiq+lbteTpqDeSJYrvsiMz2yJRiF4arkNpfq7BL+MJoQqSSksYW7w32lsKymxknXRs0etaEItNNaRZPX0kwRGe8VYOWf2WX+2ggH5S2rRvg5P2w+aI5vdbK5tUnDB8PYc7wHZ+pA0335zMgUyWgLg5ywlMH9Ea/rJgHDxKMpFBd7LRlxiEFom1PtFUT9WO7MrbiimdlEkty1XdPFpbuHtpuUtBl/L3/Wf9gnB0TaV/FsRnO5FneT+9FgRJ0+/BTbynSCkZNKF26de079eHJMdoRpg/CGbPdiFQLj5tFhGvkHzYhRXtEgK55hDFZKWhcTVwyFZWpmerM5cxqRc1wzQN7ae3Idi9D+ql2mTPF0cpsTd4bLZFLXg+3R8FrNOhoLpZmnzpVv3tJf8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <songmuchun@bytedance.com> writes:

> This v4 is based on mm-new commit d5207c6d152c, which contains v6 of
> "mm: Switch device DAX to section-based vmemmap optimization" [1].
>

Hi Muchun,

I was checking this patch series and seems like I am hitting an issue on
mm-new, which most likely is due to this patch series.
(Note that a similar issue was reported by Pavithra on PowerPC)

Let me first give the call stack:

[   79.930815] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x0 pfn:0x140000
[   79.930833] flags: 0x0(node=0|zone=0|lastcpupid=0x0)
[   79.930838] raw: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   79.930840] raw: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   79.930841] page dumped because: VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
[   79.931043] ------------[ cut here ]------------
[   79.931051] kernel BUG at mm/page_alloc.c:373!
[   79.931109] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[   79.940576] CPU: 2 UID: 0 PID: 743 Comm: ndctl Tainted: G                 N  7.3.0-rc5-01065-g45f4c1453cbe #23 PREEMPT(full)
[   79.942647] Tainted: [N]=TEST
[   79.943190] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   79.945080] RIP: 0010:__set_pfnblock_flags_mask.constprop.0+0xef/0x110
[   79.946231] Code: 48 8b 07 48 89 d1 48 f7 d1 48 89 c2 48 21 ca 48 09 f2 f0 48 0f b1 17 75 f0 c3 cc cc cc cc 48 c7 c6 b0 9b 5a 83 e8 91 be fa ff <0f> 0b ba 00 10 00 00 e9 7a ff ff ff 48 c7 c6 a8 b5 56 83 e8 79 be
[   79.949296] RSP: 0018:ffffc90011ebf7b0 EFLAGS: 00010246
[   79.950179] RAX: 000000000000004a RBX: 0000000000140000 RCX: 0000000000000000
[   79.951366] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffffffffff
[   79.952562] RBP: 0000000000180000 R08: 0000000000000001 R09: 0000000000000000
[   79.953759] R10: 0000000000000118 R11: 0000000000008000 R12: 0000000000000001
[   79.954948] R13: 0000000000000000 R14: 0000000000180000 R15: 0000000000190000
[   79.956151] FS:  00007ffff7e36d40(0000) GS:ffff8880f7f22000(0000) knlGS:0000000000000000
[   79.957490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   79.958464] CR2: 000055555572ce90 CR3: 0000000031130003 CR4: 0000000000172ef0
[   79.959657] Call Trace:
[   79.960096]  <TASK>
[   79.960487]  pageblock_migratetype_init_range.constprop.0+0x50/0x90
[   79.961561]  memmap_init_zone_device+0x2fb/0x380
[   79.962392]  pagemap_range+0x272/0x590
[   79.963069]  memremap_pages+0x125/0x210
[   79.963726]  ? lockdep_hardirqs_on+0x7d/0x100
[   79.964488]  devm_memremap_pages+0x21/0x70
[   79.965191]  dev_dax_probe+0x1db/0x300
[   79.965870]  dax_bus_probe+0x6f/0xa0
[   79.966495]  call_driver_probe+0x24/0xf0
[   79.967190]  really_probe+0xb6/0x310
[   79.967810]  ? __pfx___device_attach_driver+0x10/0x10
[   79.968667]  __driver_probe_device+0x87/0x190
[   79.969415]  ? __pfx___device_attach_driver+0x10/0x10
[   79.970270]  driver_probe_device+0x1f/0x90
[   79.970976]  __device_attach_driver+0x89/0x130
[   79.971734]  bus_for_each_drv+0x86/0xe0
[   79.972412]  __device_attach+0xb6/0x1d0
[   79.973078]  device_initial_probe+0x40/0x60
[   79.973791]  bus_probe_device+0x3d/0xa0
[   79.974453]  device_add+0x4f0/0x6c0
[   79.975068]  __devm_create_dev_dax+0x18b/0x3f0
[   79.975830]  devm_create_dev_dax+0x21/0x40
[   79.976530]  __dax_pmem_probe+0x1c3/0x200
[   79.977244]  dax_pmem_probe+0xe/0x20
[   79.977867]  nvdimm_bus_probe+0x89/0x250
[   79.978566]  call_driver_probe+0x24/0xf0
[   79.979242]  really_probe+0xb6/0x310
[   79.979868]  __driver_probe_device+0x87/0x190
[   79.980618]  device_driver_attach+0x47/0xb0
[   79.981336]  bind_store+0x76/0xc0
[   79.981922]  kernfs_fop_write_iter+0x152/0x200
[   79.982715]  vfs_write+0x276/0x520
[   79.983323]  ksys_write+0x6b/0xe0
[   79.983900]  do_syscall_64+0xa6/0x470
[   79.984543]  entry_SYSCALL_64_after_hwframe+0x76/0x7e


also - 

[    4.426995] BUG: kernel NULL pointer dereference, address: 0000000000000090
[    4.428266] #PF: supervisor read access in kernel mode
[    4.428266] #PF: error_code(0x0000) - not-present page
[    4.428266] PGD 0 P4D 0
[    4.428266] Oops: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[    4.428266] CPU: 6 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.3.0-rc5-01065-g45f4c1453c
[    4.428266] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f04
[    4.428266] RIP: 0010:__set_pfnblock_flags_mask.constprop.0+0x3d/0x110
[    4.428266] Code: 84 e3 00 00 00 48 8b 17 48 89 d1 48 c1 ea 37 83 e2 07 48 c1 e9 3a 48 8d 14 52 40
[    4.428266] RSP: 0000:ffffc9000001b770 EFLAGS: 00010246
[    4.428266] RAX: 0000000000140000 RBX: 0000000000140000 RCX: 0000000000000020
[    4.428266] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffea0005000000
[    4.428266] RBP: 0000000000180000 R08: ffff8880093e1600 R09: 0000000000000040
[    4.428266] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
[    4.428266] R13: 0000000000000000 R14: 0000000000180000 R15: 0000000000190000
[    4.428266] FS:  0000000000000000(0000) GS:ffff8880f8722000(0000) knlGS:0000000000000000
[    4.428266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.428266] CR2: 0000000000000090 CR3: 0000000003aac001 CR4: 0000000000172ef0
[    4.428266] Call Trace:
[    4.428266]  <TASK>
[    4.428266]  pageblock_migratetype_init_range.constprop.0+0x50/0x90
[    4.428266]  memmap_init_zone_device+0x2fb/0x380
[    4.428266]  pagemap_range+0x272/0x590
[    4.428266]  memremap_pages+0x125/0x210
[    4.428266]  ? lockdep_hardirqs_on+0x7d/0x100
[    4.428266]  devm_memremap_pages+0x21/0x70
[    4.428266]  dev_dax_probe+0x1db/0x300
[    4.428266]  dax_bus_probe+0x6f/0xa0
[    4.428266]  call_driver_probe+0x24/0xf0
[    4.428266]  really_probe+0xb6/0x310
[    4.428266]  ? __pfx___device_attach_driver+0x10/0x10
[    4.428266]  __driver_probe_device+0x87/0x190
[    4.428266]  ? __pfx___device_attach_driver+0x10/0x10
[    4.428266]  driver_probe_device+0x1f/0x90
[    4.428266]  __device_attach_driver+0x89/0x130
[    4.428266]  bus_for_each_drv+0x86/0xe0
[    4.428266]  __device_attach+0xb6/0x1d0
[    4.428266]  device_initial_probe+0x40/0x60
[    4.428266]  bus_probe_device+0x3d/0xa0
[    4.428266]  device_add+0x4f0/0x6c0
[    4.428266]  __devm_create_dev_dax+0x18b/0x3f0
[    4.428266]  devm_create_dev_dax+0x21/0x40
[    4.428266]  __dax_pmem_probe+0x1c3/0x200
[    4.428266]  dax_pmem_probe+0xe/0x20
[    4.428266]  nvdimm_bus_probe+0x89/0x250
[    4.428266]  call_driver_probe+0x24/0xf0
[    4.428266]  really_probe+0xb6/0x310
[    4.428266]  ? __pfx___driver_attach+0x10/0x10
[    4.428266]  __driver_probe_device+0x87/0x190
[    4.428266]  ? __pfx___driver_attach+0x10/0x10
[    4.428266]  driver_probe_device+0x1f/0x90
[    4.428266]  __driver_attach+0xd7/0x200
[    4.428266]  bus_for_each_dev+0x79/0xc0
[    4.428266]  bus_add_driver+0x127/0x250
[    4.428266]  driver_register+0x59/0x100
[    4.428266]  ? __pfx_dax_pmem_init+0x10/0x10
[    4.428266]  do_one_initcall+0x59/0x3a0
[    4.428266]  do_initcalls+0xdd/0x1b0
[    4.428266]  kernel_init_freeable+0x16f/0x2b0
[    4.428266]  ? __pfx_kernel_init+0x10/0x10
[    4.428266]  kernel_init+0x1f/0x1d0
[    4.428266]  ret_from_fork+0x244/0x280
[    4.428266]  ? __pfx_kernel_init+0x10/0x10
[    4.428266]  ret_from_fork_asm+0x1a/0x30
[    4.428266]  </TASK>


- I am hitting this issue on x86 kvm itself (and also on PowerPC)
- I am able to hit the issue with the following extra qemu params:
    -m 2G,slots=4,maxmem=16G
    -object memory-backend-file,id=mem1,mem-path=/tmp/nvdimm.img,size=2560M,share=on -device nvdimm,id=nvdimm0,memdev=mem1,label-size=256M,addr=0x100000000

    # then once the system comes up
    ndctl disable-region region0
    ndctl init-labels all
    ndctl enable-region region0

    ndctl create-namespace -r region0 -t pmem -m raw -s 256M
    ndctl create-namespace -r region0 -t pmem -m devdax -M mem -a 1G -s 2G 

I am still debugging this issue - but from the logs it looks like that
some struct page was never initialized which caused the VM_BUG_ON().

Can you take a look at this once?

Thanks!
-ritesh



