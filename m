Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B134EC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8264E6B00A5; Mon, 21 Sep 2026 22:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7A16B00A9; Mon, 21 Sep 2026 22:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED946B00AA; Mon, 21 Sep 2026 22:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3366B00A5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:28:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD1BDC0292
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:28:10 +0000 (UTC)
X-FDA: 85239813540.29.6425307
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4AF751A0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:28:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=id2tYbxI;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790044088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dC1HGCVeeXJiJ+z6p6zQL7OjunNDThCeLu334KPWnrg=;
	b=DQ2tEtQyGIKXVscWvuiFn5edXcV2Dfy5qjIsNvfpQFFAncPbvrTNVaWDPbh9tqJJl4Cecs
	ezVWeukX3ipOQy9Z+Pdbubh7iOwQ3SJQ8MCbu/8mR/1rGj4AXycM8meleyBoc4FjwnbUuM
	6XIZvpGJYvvUNw1yiOyqXX16HaJdFx4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=id2tYbxI;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790044088;
	b=YDGatihAHDhi2vbjZTPOowwIR+bDFviuPBQfn0Rz+f0tgBhTsiuWdpmf9BsE5+1gV5iDbW
	K/0ZmyhJ0YThCXM2OEPep/ybDSf3TO+O/K85xkraEbdCJEopkSOixqv454oeLeII/O1JKG
	1tKJtQ2y1bYE/hPATJUvRg/yRD3Yz6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790044087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dC1HGCVeeXJiJ+z6p6zQL7OjunNDThCeLu334KPWnrg=;
	b=id2tYbxIxr88ODqZ9zhi0QlX2rwAkYha+Cd2n7VBMKRk43QxTjceNxNJQiCEPZJAp/0y7J
	In66y3BPxSHqZsZ859o8Zz6I2IcupmRrtXr5e6tsYzDckUGcseSmMAaCGRikU+q+WW+q+z
	iUMnHFQCNEqMs9wNwI5ZBJ9YuLkpkWw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-pJyir_JSOLCmsu_fPeOVgw-1; Mon, 21 Sep 2026 22:28:06 -0400
X-MC-Unique: pJyir_JSOLCmsu_fPeOVgw-1
X-Mimecast-MFC-AGG-ID: pJyir_JSOLCmsu_fPeOVgw_1790044086
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93bfb2da664so543330485a.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790044086; x=1790648886;
        h=content-transfer-encoding:content-type:subject:cc:to:from
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dC1HGCVeeXJiJ+z6p6zQL7OjunNDThCeLu334KPWnrg=;
        b=TK1YgcXUfniQbKacxtLmuXRpS8qrImIwOjI2/lwtGkplAhfdnkPMKrRZnjDXGPz2BR
         FEGN3UZrVWxpwfQYmEudBZ8yBIzdrA5aroTC6NVG5LY9tIIk4w3Cf4GpF+0/1HoS1MPT
         7btkGWmDRnqWOgN8Oxk1DwQMk8RyLUwqzD9ThHv02C2CRbMUMHWHJsc97otVvgwSIrrt
         U+YOlXLQYlidWGZRVag9np3fGwAKNvQxSUaUhNJs97NzmreB0XGHPGmb7zWaZzprlzaa
         DEkMuN0IEJWsMb8IB72D3B5Nq5DPW+XQjldsE3M30m039V+YNyjRfkhdhhzeruK6yzS2
         rPAw==
X-Forwarded-Encrypted: i=1; AKwUvByNr8XdYFJUQcK+Lcq+TzQtqtZtLzosFbZgdHD1baFQNGU69myLkFLc+NI1QIERW8zY9WSrdmak8Q==@kvack.org
X-Gm-Message-State: AFuF++m2lFggwJgIhqOAP64k8fP3nylW81/EamyFTosy62zXu8nY5QRY
	0a/rWlkD1qXt7YNRU/ctUj9VqdwzkOYzd+YokxdmVs7lIyBLDtojpQ6X1AK+IWTxAMTEV9+YiVQ
	v/v3R1vJd74TdG8TWvpIgQikkCODsCipuyCyMXUzXNAL+yJSp3fE7ssGqnTdHtBM=
X-Gm-Gg: AYBFou33F09An9CkHBElARjC7/QY4rUi0rKIdBNpI8Qe8412JjiZO1n9faa0ikq43pP
	DCbbHxwAfK5ngPHI1zevOxX++HvReQ13Dzm73tP/EjOca2TkIFl+vrTontFeKzsZTz3g3iUoOK7
	16jCBVA6pUKMi/2QAfIEnhQvSbUvuDL30r+PIw9OnaWitd5guEhwVoODELXUJm7c0WgJZRONDhc
	Uz4cU3nV5bs8PDPAefNPKy3HvgBnoi5a4y0VhDmcu2SclPGe6doK+p6azHrj3WwMABEFVLZVLr1
	FXzeRqHnSltDUucQSKnpzy4g8UabP7tUhJMtaGcZ66RsEMaklXnoyYdeqcKArHo1pyp4DAWcz/l
	edLU=
X-Received: by 2002:a05:620a:a414:20b0:93b:d7a1:ba0e with SMTP id af79cd13be357-93c166802c5mr232573885a.57.1790044085576;
        Mon, 21 Sep 2026 19:28:05 -0700 (PDT)
X-Received: by 2002:a05:620a:a414:20b0:93b:d7a1:ba0e with SMTP id af79cd13be357-93c166802c5mr232572085a.57.1790044085050;
        Mon, 21 Sep 2026 19:28:05 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1d17afc0sm21716985a.18.2026.09.21.19.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 19:28:04 -0700 (PDT)
Message-ID: <8b77688e-3219-4133-af0f-395e342acb25@redhat.com>
Date: Mon, 21 Sep 2026 22:28:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-usb@vger.kernel.org
Cc: akpm@linux-foundation.org, mathias.nyman@intel.com
Subject: [USB] WARNING: mm/page_alloc.c:5345 at
 __alloc_frozen_pages_noprof+0x39a/0x3d0, CPU#41: swapper/0/1
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rFq1MJ6lXOsTs2vUjkUDPVJXOlbHFouCIqiJEG01ti4_1790044086
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: upqtef1s6kymqs8nb4imegnkgj4ob3w6
X-Rspamd-Queue-Id: 4AF751A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1790044088-637453
X-HE-Meta: U2FsdGVkX18a88iYQgEqykVTRsu9fq77q0lEuuqZjwGdupy4iJ+zoROMS53QCY6ebDads7JtEmnocMB8OeDvXJkAQByI4jhrOdGwoV5Daw8c+Uo5nlXu7SFmC53hkxAxWzf/irFbGKKcjrGto2fceL5tF1LYCXT1GqBr8mwznDOfsRUy3ZUi4tMn+b+u3kc9rkOOPHA5+dGZbF4P8/RFOG2ua8/TCHdwxmLmrqPGyf/yEyYF1XhniYbbjT0BealPi3/UXgnz9v899z31pXL7XWh0iQosmylex6GARuc5Ntc0fqdRXTBA94dNfvcDtsvqXj3X5b8oxnHzF1FToRLoqbJxnC/xNQhn7CRci4ItV4tpXyMqDpRYC8eLh0z+hBQPu7kmNi+tBlwWh/JZlV1HbBP7xHDxSlXn6Q3V4qTTUpHp/yUBKSGyRE9ErNGEGRKytx4fkF/O0Iy58MwWKnIrbDPXGHSFnuNF0gyceBWdmEvNy9TfejYIir//kMw3CIkS2Gx+b5kUTZbNBwEwZqOi8T5c50cjcwi4cNzzVE25GfWJcaw4R8dzKtJ91YTUv64hKoswDRhVLAVnKKMaEKaBkttEj5xQOQyD+ixmAM6gYLXjNogIR/6wxze3K8gDdyqXya18GHOs8SKDTEK5SXqtoZP7t8FciSncLwN0Kqr6MBP2JMNd06qMPp80SiFpftcAxG9ScaFs/fHljoAncJGmuCWJ9KzCSy+Wv6qOUHd5b7/QUBYutlcXTzGC6B0fnY9/o2Kuyh06VU3VDxBxFgFD3I5bTR+GloZr9TCj7CX1r4bEohkOS7BnQ0qDxFf626c/Cr9Mefa+NjqBDIa2ZmEqxXpjsKuydJYzPEO9NY2o2nzBSimm5yDcHgHENn1pdmHSHn00FBZ3kz4pfsHb7r53M8Clvwv+9sWMoOdQIRUTIXT27yDTSyWlbkrDcusTiWfqwugIhQBjU1yqaWW/U2B
 rZSGig33
 OVtRXkUNynge+WyMAJY/3xAEDc1zvmTFiIU74Rje9og8U1cMIsBIlVBfXvq6FzcCsSPy4vtc0f+Ot2fx8jwBOh+75urvy5QXfh+vMa7AFZiqXQSLiBo/i5Eaun2m7BBK/MbdxKruHw9r3YzrQnXpSbvxZl/t9Wok0PoB9pbecSzGVs/wWwuwgo6+035ZPOitsqiFvIKR+R5x+jFG26VL3A5NXEsy2+3MkCODB8+F4NFu6wZxCndbNdQKUYFtPVfBiaKqiSOXXcvgY8wx+1QOUOdGOeN4w973hZlMAsJp40GLSvMBExvbZUvcv/GDamW9WqKRYyQfnCQAc8023j/vHSD3dJF+A1dpmFescPYkmxnJO9hY8nrAjj7INB463Ugd3Hw29NusKvRHh7u9iEvm1ZE0uQOx+YIkZ1FTtxyAaTTrtWQleouDohTGxj8scTR01u1XvErLVfEidb7MSlVfOVxEWug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

When booting the latest Andrew Morton's mm-new tree[1] commit 498ee28e5ec4
("mm/swap, PM: hibernate: atomically replace hibernation pin") on a KVM guest,
I'm getting the following MM warning being triggered:

"""
[    1.667197] [      T1] WARNING: mm/page_alloc.c:5345 at __alloc_frozen_pages_noprof+0x39a/0x3d0, CPU#41: swapper/0/1
[    1.691217] [      T1] CPU: 41 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           7.3.0-rc1+ #12 PREEMPT(full)
[    1.692073] [      T1] Tainted: [W]=WARN
[    1.692378] [      T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20260812-8.fc44 08/12/2026
[    1.693158] [      T1] RIP: 0010:__alloc_frozen_pages_noprof+0x39a/0x3d0
[    1.693685] [      T1] Code: e2 04 e8 49 85 ff ff 45 31 c9 e9 14 fe ff ff 0f 0b e9 e7 fe ff ff 80 3d 6d 3a f2 05 00 0f 85 2b fe ff ff c6 05 60 3a f2 05 01 <0f> 0b e9 1d fe ff ff 48 89 5c 24 40 48 89 6c 24 48 4c 89 64 24 50
[    1.695238] [      T1] RSP: 0000:ff46f50b801538d8 EFLAGS: 00010246
[    1.695723] [      T1] RAX: 0000000000000000 RBX: 0000000000000cc0 RCX: 0000000000000000
[    1.696356] [      T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc0
[    1.696981] [      T1] RBP: 0000000000000034 R08: 0000000000000000 R09: 0000000000000cc0
[    1.697605] [      T1] R10: 0000000000000034 R11: 0000000000000100 R12: 0000000000000034
[    1.698231] [      T1] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.698872] [      T1] FS:  0000000000000000(0000) GS:ff2b932745209000(0000) knlGS:0000000000000000
[    1.699592] [      T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.700119] [      T1] CR2: 0000000000000000 CR3: 00000006ede4a001 CR4: 0000000000773ef0
[    1.700745] [      T1] PKRU: 55555554
[    1.701023] [      T1] Call Trace:
[    1.701283] [      T1]  <TASK>
[    1.701512] [      T1]  alloc_pages_node_noprof+0x4c/0xc0
[    1.701919] [      T1]  __dma_direct_alloc_pages.isra.0+0x164/0x1f0
[    1.702402] [      T1]  dma_direct_alloc+0x19f/0x2b0
[    1.702767] [      T1]  dma_alloc_attrs+0x8d/0x200
[    1.703133] [      T1]  xhci_alloc_interrupter+0xc9/0x190
[    1.703543] [      T1]  xhci_mem_init+0x283/0x340
[    1.703902] [      T1]  ? __pfx_xhci_pci_quirks+0x10/0x10
[    1.704317] [      T1]  xhci_gen_setup+0x35e/0x4f0
[    1.704684] [      T1]  xhci_pci_setup+0x52/0x1c0
[    1.705038] [      T1]  usb_add_hcd.cold+0x241/0x5d8
[    1.705413] [      T1]  usb_hcd_pci_probe+0x188/0x480
[    1.705803] [      T1]  xhci_pci_common_probe+0x6b/0x2f0
[    1.706218] [      T1]  local_pci_probe+0x4a/0x90
[    1.706582] [      T1]  ? cpu_hotplug_disable+0x15/0x30
[    1.706986] [      T1]  pci_call_probe+0x55/0x150
[    1.707357] [      T1]  pci_device_probe+0xae/0x150
[    1.707734] [      T1]  ? kernfs_create_link+0x61/0xb0
[    1.708139] [      T1]  ? sysfs_do_create_link_sd+0x81/0xf0
[    1.708562] [      T1]  call_driver_probe+0x23/0x100
[    1.708949] [      T1]  ? driver_sysfs_add+0x55/0xc0
[    1.709334] [      T1]  really_probe+0xd7/0x2d0
[    1.709681] [      T1]  ? _raw_spin_unlock_irq+0xe/0x30
[    1.710098] [      T1]  __driver_probe_device+0x9c/0x1b0
[    1.710503] [      T1]  driver_probe_device+0x1f/0x80
[    1.710892] [      T1]  ? __pfx___driver_attach+0x10/0x10
[    1.711323] [      T1]  __driver_attach+0x10a/0x210
[    1.711706] [      T1]  ? __pfx___driver_attach+0x10/0x10
[    1.712125] [      T1]  bus_for_each_dev+0x86/0xf0
[    1.712488] [      T1]  bus_add_driver+0x13e/0x230
[    1.712858] [      T1]  ? __pfx_xhci_pci_init+0x10/0x10
[    1.713273] [      T1]  ? __pfx_xhci_pci_init+0x10/0x10
[    1.713681] [      T1]  driver_register+0x75/0xe0
[    1.714049] [      T1]  do_one_initcall+0x7a/0x1c0
[    1.714429] [      T1]  do_initcalls+0xe1/0x100
[    1.714780] [      T1]  kernel_init_freeable+0x152/0x1c0
[    1.715199] [      T1]  ? __pfx_kernel_init+0x10/0x10
[    1.715592] [      T1]  kernel_init+0x1f/0x140
[    1.715928] [      T1]  ret_from_fork+0x19e/0x270
[    1.716296] [      T1]  ? __pfx_kernel_init+0x10/0x10
[    1.716680] [      T1]  ? __pfx_kernel_init+0x10/0x10
[    1.717071] [      T1]  ret_from_fork_asm+0x1a/0x30
[    1.717438] [      T1]  </TASK>
[    1.717663] [      T1] ---[ end trace 0000000000000000 ]---
"""

This does not happen with latest Linus tree 40288c9206c1 ("Merge tag
'drm-fixes-2026-09-19' of https://gitlab.freedesktop.org/drm/kernel").

What I could determine is:

- In xhci_alloc_interrupter() max_segs=0, which leds to seg=0

- This eventually leads to passing size=0 to get_order() in
   __dma_direct_alloc_pages() (call sequenece below). Passing size=0 to
   get_order() is undefined and returns order=52 on my guest, whch leads
   to the warning since 52 > MAX_PAGE_ORDER

     xhci_alloc_erst()
       dma_alloc_coherent()
         dma_alloc_attrs()
           dma_direct_alloc()
             __dma_direct_alloc_pages()
             get_order()
             alloc_pages_node()

[1] git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm origin/mm-new


