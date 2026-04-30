Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E2ACCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9F26B0088; Thu, 30 Apr 2026 04:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B416B008A; Thu, 30 Apr 2026 04:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90B06B0092; Thu, 30 Apr 2026 04:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6FE86B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:26:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F34D1C0957
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:26:04 +0000 (UTC)
X-FDA: 84714539448.08.C0A9903
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2456114000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:25:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777537562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h09ExlBip9cTN4qQdIj4CMBGbe/qPM1Z90EhXRl5Kws=;
	b=hvkSIG0xdCIuQW2Lh1FFUX+o9hjQHIfGbLawNQ0rQcAPcRlSbwjPUKbnrbfisuPG3RJfrd
	Xylf3kMg3ZBJgapU/mLHvzMcRH+rGLhMJUr/tK7y1AmZdhdX3d7MHtrOBV0Xj+vbjjpSI9
	Q3fRDykbmZMR0Fq753Nc/+8yCJvakVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777537562; a=rsa-sha256;
	cv=none;
	b=JhtOsr3kC37RlErjLUEpEjvzAoL/AwzVfFHLhlASSfibXQ/QdQtIhIJBTHqDmb7DRu6hDU
	vZTzoWtO7ovyDHi5u5CaHYm0/WbNUsdKtbapEEpGSmtGMqWbtASQiEZct8HjbDJhDP3JN6
	BMbqFlw30dcT4R6JW0chYPPjNCEmGxM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4g5nLT07pxz51SdS;
	Thu, 30 Apr 2026 16:25:53 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 63U8Pi5x028825;
	Thu, 30 Apr 2026 16:25:44 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 30 Apr 2026 16:25:47 +0800 (CST)
X-Zmail-TransId: 2afa69f3120b3f9-e662e
X-Mailer: Zmail v1.0
Message-ID: <20260430162547059Z-TF70sIkLfTkkfnWeGjJ@zte.com.cn>
In-Reply-To: <4sw3gj2ugc4v5ek3jv4h3da2r5lnrsio44kcpqf5cw7ncjeofu@wqyp5tavlq3w>
References: 202604301428.e2b8d3dd-lkp@intel.com,4sw3gj2ugc4v5ek3jv4h3da2r5lnrsio44kcpqf5cw7ncjeofu@wqyp5tavlq3w
Date: Thu, 30 Apr 2026 16:25:47 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <oliver.sang@intel.com>, <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        <vbabka@kernel.org>, <hao.li@linux.dev>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?UmU6IFtsaW51eC1uZXh0Om1hc3Rlcl0gW21tL3NsdWJdICA4OTUyNzI4NjQxOiBCVUdfa21lbV9jYWNoZTpGcmVlcG9pbnRlcl9jb3JydXB0?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 63U8Pi5x028825
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 30 Apr 2026 16:25:53 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F31211.000/4g5nLT07pxz51SdS
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2456114000C
X-Stat-Signature: j57n457n5ygbh7qz3rgfijjcowokz9eb
X-Rspam-User: 
X-HE-Tag: 1777537559-698260
X-HE-Meta: U2FsdGVkX1+UlLUvmno7IBP4BlD5AZBpnrjQY+bZHuoi10y943vRMk6JfLa+J+uAuEqyVHTeR7faQZ95E1c67Lh1QPX/No8NH0zZ1dRJ4IjsE85xOcS8dwCOLUvpa6kREHxk9YXth4D/OFTOfwGJNLFFeP7ABiNWzhWhNN+3W3iG6OF+A0dfP7oW0Q5Wpfedfv4ppH0GQbhvCeixoKJkSeuhMC1zQll9lC4mMghjE3tiVPyGo+7tYQ4adFjRTiZynSbovOIDTs0Z9rUc0l0dJiKkDEs6IGpFl9Vj6EO3EHqH4g8omXY7+765rbK6kWOzN5tSDv4jEaKKDPhjNZ6lXcQq3iIBxuif2M/+an7bz1/ZcCMDl8rEWONV8oNG+8gmvud6f8GCdSt9diPcaGPELpCBENq62qyxsKEDXlsm4xYBPRcp4wQxZ2uR0NsF67s8RscZBOYJiUH+qUEhNcXcHojewsmVYjwYASPQpbTQdY+j9a2Gp/+IupaJIBarvH0JCOH4emqFwK7OExgU4a23ibdrGjC/PztIkjv0PKYtLANAETQwQoojaYY+T0EMnzXS2r+vtsu8f0+ABlHrn0d5/slEv+AjCc44BHRoAOSJOI8F/VmPIHgtYG5Og7IxdsvFw8TVqsL4qkS3OUT31qoRRUYhDhifGg88kfMvICt/t6z61Y4t85UC09IICARujD5KMIEPiHrY9rmEl93QxaaX1TaTEHnzwbhrxPq9TvHp0t5aynN6cgj6QBjaoGgC16ntf+2AIhpXkTRzC9hLpt/f0XSIuu1GGZoM2w9Yk5pHTUQmag1aMdvvWdB0RrkVX4zBCpexXWNl8YceTY+SU5JlHehBy17z5xIgfG19uy0GNcylIN9dwKYIF6UR2Rg7u14gQj/QAFd/Z0rtCk47jb9nUtzxqNABctEk/WNtLlP6ikd+7Fj73sO90fsJRvU1qt6hmX54lllk+61FZD9sbsl
 BhTAMDpm
 DvT/w/exAhpiDREEUGDA8vTQEUOU1C6w9ElJXtERWd5t3E8LV9mGhoP8OTHnoQVm/Wfygx5KIAa1LjDnUI1q7AfQ6N3OyJ7qXqH9Av3yZaSMbvDlYBjbrBsKzyZ2RF+0DGMgwhJugruao6fbd8fbDf/hSi0KkyzwENGM9a2aHuJE7UdqMIqMF8jo+r8hjJA6GTI4+0g/FUZdNfmrYgqEmYUBt0Et3I8pqJkPOxO2Y2yipTnnWhS2eSNejd7bDXgd7gDMSKF9jgXOxssQZy79BBlqneBW4B7TmKGWrzVJLVVDjbbfE3Y5SuAraQPJl3V4M9gvJ2ClMh9rikOFdOjvaZjLb6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> Taking a quick look...
>
> On Thu, Apr 30, 2026 at 02:16:37PM +0800, kernel test robot wrote:
> >
> >
> > Hello,
> >
> > kernel test robot noticed "BUG_kmem_cache:Freepointer_corrupt" on:
> >
> > commit: 8952728641305ebcd03e80f79b8d31bb41d6d95f ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> >
> > [test failed on linux-next/master 9974969c14031a097d6b45bcb7a06bb4aa525c40]
> >
> > in testcase: boot
> >
> > config: x86_64-randconfig-001-20251114
> > compiler: gcc-14
> > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> >
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
>
> [...]
>
> > [   53.929047][    T0] =============================================================================
> > [   53.931786][    T0] BUG kmem_cache (Tainted: G                T  ): Freepointer corrupt
> > [   53.934858][    T0] -----------------------------------------------------------------------------
> > [   53.934858][    T0]
> > [   53.934858][    T0] -----------------------------------------------------------------------------
> > [   53.934858][    T0]
> > [   53.939608][    T0] Slab 0xffffea0004001040 objects=9 used=1 fp=0xffff888100041200 flags=0x4000000000000000(zone=2)
> > [   53.944008][    T0] Object 0xffff888100041040 @offset=64 fp=0x64ae22a70baa83ae
> > [   53.944008][    T0]
> > [   53.944008][    T0] Object 0xffff888100041040 @offset=64 fp=0x64ae22a70baa83ae
> > [   53.944008][    T0]
> > [   53.950913][    T0] Redzone  ffff888100041000: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> > [   53.954703][    T0] Redzone  ffff888100041010: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> > [   53.957662][    T0] Redzone  ffff888100041020: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> > [   53.960527][    T0] Redzone  ffff888100041030: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> > [   53.963607][    T0] Object   ffff888100041040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.966785][    T0] Object   ffff888100041050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.969753][    T0] Object   ffff888100041060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.972621][    T0] Object   ffff888100041070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.975559][    T0] Object   ffff888100041080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.978756][    T0] Object   ffff888100041090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.981898][    T0] Object   ffff8881000410a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.985140][    T0] Object   ffff8881000410b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.988289][    T0] Object   ffff8881000410c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.991279][    T0] Object   ffff8881000410d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.993987][    T0] Object   ffff8881000410e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.996539][    T0] Object   ffff8881000410f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   53.999493][    T0] Object   ffff888100041100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > [   54.002253][    T0] Object   ffff888100041110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> > [   54.005170][    T0] Redzone  ffff888100041120: bb bb bb bb bb bb bb bb                          ........
> > [   54.007879][    T0] Padding  ffff888100041180: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> > [   54.010661][    T0] Padding  ffff888100041190: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> > [   54.013403][    T0] Padding  ffff8881000411a0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> > [   54.016151][    T0] Padding  ffff8881000411b0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
>
> the object content has 0x6b (POISON_FREE) and there is no free pointer
> because we skipped it when allocating objects from a new slab.
>

Hi Harry,
Many thanks for the quick review and catching this!

> > [   54.019282][    T0] Disabling lock debugging due to kernel taint
> > [   54.021208][    T0] ------------[ cut here ]------------
> > [   54.022797][    T0] WARNING: mm/slub.c:1231 at object_err+0x6c/0x7f, CPU#0: swapper/0
> > [   54.077963][    T0]  <TASK>
> > [   54.079139][    T0]  check_object.cold+0x4b/0x50
> > [   54.080583][    T0]  alloc_debug_processing+0x9b/0x180
>
> But alloc_debug_processing() always expect a valid free pointer (within
> the slab or NULL.
>
> I think it can be fixed by initializing the free pointer in
> before calling alloc_debug_processing() in alloc_single_from_new_slab().
> (with a comment explaining why)
>
> Could you respin the patch with the issue addressed, Shengming?
>

I have just finished creating the patch and running the tests. I was about to send the patch
with the fix you suggested.I’ll include the change where the free pointer is initialized before
calling alloc_debug_processing() in alloc_single_from_new_slab(), along with a comment
explaining why it's necessary.

> > [   54.082495][    T0]  alloc_single_from_new_slab+0x82/0x200
> > [   54.084323][    T0]  ? alloc_slab_obj_exts_early+0x5/0x2c0
> > [   54.086455][    T0]  ? allocate_slab+0x11b/0x380
> > [   54.087892][    T0]  ___slab_alloc+0x1ad/0x340
> > [   54.089129][    T0]  ? bootstrap+0x20/0xb0
> > [   54.090520][    T0]  kmem_cache_alloc_noprof+0x30b/0x540
> > [   54.092010][    T0]  ? bootstrap+0x20/0xb0
> > [   54.093328][    T0]  bootstrap+0x20/0xb0
> > [   54.094484][    T0]  kmem_cache_init+0xbb/0x330
> > [   54.095786][    T0]  ? preallocate_vmalloc_pages+0x1a4/0x2b0
> > [   54.097485][    T0]  mm_core_init+0x12b/0x170
> > [   54.098935][    T0]  start_kernel+0x173/0x370
> > [   54.100291][    T0]  x86_64_start_reservations+0x28/0x30
> > [   54.101912][    T0]  x86_64_start_kernel+0x131/0x140
> > [   54.103325][    T0]  common_startup_64+0xbd/0xc8
> > [   54.131853][    T0] FIX kmem_cache: Marking all objects used
>
> --
> Cheers,
> Harry / Hyeonggon

--
With Best Regards,
Shengming

