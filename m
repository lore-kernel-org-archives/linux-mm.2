Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB58C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418696B0098; Tue, 22 Sep 2026 08:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C96C6B009F; Tue, 22 Sep 2026 08:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8AC6B00A2; Tue, 22 Sep 2026 08:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F23256B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:39:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7410E1C2973
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:39:33 +0000 (UTC)
X-FDA: 85241354226.22.AA34D4E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id EDFC780008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:39:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EZQY134O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rZHGjrhc0+tlCgX+JeQpKinKuN2xlIHFPD7PX5sonQ=;
	b=FihOfFxZ+fINQKEgkahVgfdaD//xRe6XC9bo0C5V1O4krXEOoc6Kx80QpF6fP9sCHq4kSm
	15XL3b3lPW6SI/BT50bVqtHuIt875UfoNHKvX61+R5VfgT12KlWDRovVZ3j3vo6/D9R/75
	fjM4GEwaLnLLkcj97aNzEs75PPsKQe0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EZQY134O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080771;
	b=eaHYmmNrxGJApSfVWtJD5rBVULwlh25JjB9Gy3GkbPhUGiq6hmSooeQdvG38ZVdkNVpAw3
	l02bph0Fk99lygg6lkj3BJWh1+I+O7b/ZfCOWUnM32XI9nWbAtNmEz35yw7Sacn5ho/pYS
	Nwlh4BT9ooUMhhikXgAJC707rjeIgHA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790080770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7rZHGjrhc0+tlCgX+JeQpKinKuN2xlIHFPD7PX5sonQ=;
	b=EZQY134OoelgxvFsC9Ps5Sb1Evg/PT5AxmKrNskxu3MB4R+SP0n4l72F7aicq5KVbLa3Gs
	cY9qb/XRxFG3Ioek6oT74m2K/isYIN5TjZpcudK2u0RDVl9YepzIW5BDDU74V4QJGT/AIo
	x49cbosfjrtomQQotzxcSC4A+t75fu8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-C95_AjJmOKWYfKUMd-ARNQ-1; Tue, 22 Sep 2026 08:39:29 -0400
X-MC-Unique: C95_AjJmOKWYfKUMd-ARNQ-1
X-Mimecast-MFC-AGG-ID: C95_AjJmOKWYfKUMd-ARNQ_1790080769
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9394ad7f64aso610783685a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790080769; x=1790685569;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7rZHGjrhc0+tlCgX+JeQpKinKuN2xlIHFPD7PX5sonQ=;
        b=JEi3w1aXjwpjayefocwoBstB5J42qw4uBivQCUcEHhrDETLn/8C6cenT5n9XQJBWyX
         veJ2reJ/+Ufmp6GAaEIGaIQKJ7VB9MGikcG/dYhpbtLYE+9Esu0hImqSXZCTea3l+uku
         tvYNGlVbcBCDqHp5rW5xrjjEaN/nwgw30iTKTl/4Tum09acIB73Or8ZvpJDKOav6b9ek
         Wh4RKUsP4acZ7/7rVHIQ2FY6zNV4J20LM8Q5CIqg92ARUdoJdYYOtNfv3xRjcNjh8EvL
         I4IQwj/md3Qde9mgyWF5doy4yfLv3SZdawN+ikt4Em0vwyg2OCbkRl514UPK/nskZ04p
         3ksg==
X-Forwarded-Encrypted: i=1; AKwUvBwQUnBuG54FcTUzOUlqamdgFHue1rcAUtgS3PPz/keUOCOQokRLcrXkP4L98TPSMOX4GElHGNKMNA==@kvack.org
X-Gm-Message-State: AFuF++kNHT3ec6Ti14p98+fW/dzagMmHOgrLCz9DmUKTf+as7kXeAYl2
	ZOKWO50K3COCCLmN9l6Quhs0jKHRX/m3/TSAHLTy2LiffrJZyx7X3PObV20oncbQP5IFm6p8VKP
	q+gZo2mf4dCN0YnXi0rdEbDQGFmDiykSf1qLBx+EaE8jigsodqphUYPNocK9NpIc=
X-Gm-Gg: AYBFou0GSjV/i1U/WNlsC3sATCNs1/f6iWgsus5RCj/Gd/cG7Ok9ic3nskKN8t4HYjg
	qahPPwbf5wvcNGUaQ4EqG8Hzsafx+gqiaNcvGFoRBbhWvcqefQCsIFg5af0hxCY/jbdroYkDj9w
	LBVuacPDfnZTtGIJcGIlLSOPw44uWrQHqxVoMsyo1WZJDrY3Ay0PbTbkg3VFj/5y3S6s5ZCCMOU
	onu9gpXJtMG/3VOcx+eqCC8UKC6LTGeOK5+g/h1AAUk5zbVMwWLWMt8a32WjxND2WJ9xjnavsTz
	ftGMJuEwdfWYRw0u2RZLuj2kjeEcxKDOOmUthmUSfrIGum2Sz+m36rbL5xYmtvkqDGJXd/pSDjK
	NyPY=
X-Received: by 2002:a05:620a:45a5:b0:93b:b4e0:1c89 with SMTP id af79cd13be357-93c15eed479mr514960785a.40.1790080768694;
        Tue, 22 Sep 2026 05:39:28 -0700 (PDT)
X-Received: by 2002:a05:620a:45a5:b0:93b:b4e0:1c89 with SMTP id af79cd13be357-93c15eed479mr514957085a.40.1790080768165;
        Tue, 22 Sep 2026 05:39:28 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1d249f9bsm133721685a.44.2026.09.22.05.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 05:39:27 -0700 (PDT)
Message-ID: <0a7789b4-f77f-4522-bcf0-3e7b532f2340@redhat.com>
Date: Tue, 22 Sep 2026 08:39:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [USB] WARNING: mm/page_alloc.c:5345 at
 __alloc_frozen_pages_noprof+0x39a/0x3d0, CPU#41: swapper/0/1
To: Hao Ge <hao.ge@linux.dev>
Cc: akpm@linux-foundation.org, mathias.nyman@intel.com,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-mm@kvack.org
References: <8b77688e-3219-4133-af0f-395e342acb25@redhat.com>
 <f151fb61-6e9d-4f42-8a3e-89cf5f4fcaea@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <f151fb61-6e9d-4f42-8a3e-89cf5f4fcaea@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wkQei4cqvMz-yTxhlyepqNl2mDCB-X63mdXmO7Ir5ug_1790080769
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EDFC780008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bx1j3uu6ozqdtz5r9cq5y5yh4agjqrqn
X-HE-Tag: 1790080770-95912
X-HE-Meta: U2FsdGVkX185iEzdZNdKbbjxcHWYe1r6l0YbM4i1GiuQaycPwOVhGgWXwh/ELORr4ePCs3XSoc7SyI1J1X5hzBZslqv+wgoOLCZ3WBayE/SGpVEqyx53nJ+nqW15UgQD1emldO3JHoHaNcMqHY69utMB/Tt4bNnHJjmLd4iRgcu7vLYpCgIhT9fRywto6OsJxKZ24kDOpEJFw+YFLJkubB/OSZ2MRlFE11uosz8aapkmOAMWo6MhSXdx16j8kjMN+M3PerapfjYWS4UyEhPTw11e2+wlnotEBnCP0algKYsdcYXvLIYI/3Ykzs939vSm6PidT+SQdn3+8PRYFZoCncH2l6BUqCncGshpkzQEaPtpc65kGvE0+PGG2/87Danxm+VI7UoOSf9GbFZQHTzvhGYB68zA9T5HfQGiIkN+5FUTPpUVqKxydh34WbGiZQvC5Z8/cHk/wkIxm/F7GDrQUiZkBG7Wg8Uc+t/LROEUIqsDspMq1aOMfGxXS1WFPkC1ruIs74zaKyp7lGOulGBr2Xpyey5TUxjWWQ4sDsS38OtER3Eg3vG/BsofBu7ZHghYL/XonnwhuVfQ2UTKEI/97vXs/3Du3skFdRf9qYlDDiwY58bsAWhMiZ0nyFejViXvWZuU+lWXeLsJ+32LBUosAyDdC9l20xpgPonCRim3xCfLLgZAjiyY9Rgwub5IXoP7zsIt9ArwD4hI2ouJVNTvHeGItScKhVWFELBrgr7BEB0U2L9JBEJoqSKrexh503YVm1Y9U6rGZ1dXn6qDUDo5CcmRMrFZdbk4Q6tKK/EHMqOFxDEtHXjLpDO1ie8cQXY76cXwXhv9y0NzMIy7pw65UVBP9SXZf3QGglq/Jd/J10uecbxaJq7O9fKfzGIehV1ePDtgb3NkTC8QYHlBDJZVABZaRYdL4QkDoNBBKUrkgF1emT8wL4Al2/SkoqW5kC77a5aOCGuhVmD0jIuD8mT
 oIuoQSnk
 6KC/aUgH0e/Z/EosLrCG94bbds3lbuZZ/n5xydms9+LPQo7yBUoh8XcL/feWPfNVV2JrD7gvfR8Zbq1icPtB9q/z53bR2jEYNIaFXaP67V0LnVV2npXUnklzuMzanQNRhE97S8UOYlk4L4pi2tMiJE21ZTfxJecQdS3Dy6jezTvfwgIDQw3FghznFJKb/mcm48RXRq8EmwvfYx9mxA4omCMHP3AV+ckrK1Oe3q4l845yZKWoXCG16+gP4lK3olOCA6BTTGCzMKpTXs7HiAO/DV4Tzs2P9F+dVb1frZxuY/4fmQmg6gpFFjHMOuDGa1ltGhTHoUFJ+Ub0rwE68qeoX35Iv2sX7N8AFD/G8PON9BflvkIeaHeXdD7tg6SGZfNzPoTsKakpe9Po0gMLvBcMh2hARS7UmTU1N/N70gEX0qKIQ/xKvjNFgoTrIIUWeEE5h15i4UI4idIOfvmIEJ3LgPvKBiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 11:13 PM, Hao Ge wrote:
> Hi Luiz
> 
> On 2026/9/22 10:28, Luiz Capitulino wrote:
>> Hello,
>>
>> When booting the latest Andrew Morton's mm-new tree[1] commit 498ee28e5ec4
>> ("mm/swap, PM: hibernate: atomically replace hibernation pin") on a KVM guest,
>> I'm getting the following MM warning being triggered:
>>
>> """
>> [    1.667197] [      T1] WARNING: mm/page_alloc.c:5345 at __alloc_frozen_pages_noprof+0x39a/0x3d0, CPU#41: swapper/0/1
>> [    1.691217] [      T1] CPU: 41 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           7.3.0-rc1+ #12 PREEMPT(full)
>> [    1.692073] [      T1] Tainted: [W]=WARN
>> [    1.692378] [      T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20260812-8.fc44 08/12/2026
>> [    1.693158] [      T1] RIP: 0010:__alloc_frozen_pages_noprof+0x39a/0x3d0
>> [    1.693685] [      T1] Code: e2 04 e8 49 85 ff ff 45 31 c9 e9 14 fe ff ff 0f 0b e9 e7 fe ff ff 80 3d 6d 3a f2 05 00 0f 85 2b fe ff ff c6 05 60 3a f2 05 01 <0f> 0b e9 1d fe ff ff 48 89 5c 24 40 48 89 6c 24 48 4c 89 64 24 50
>> [    1.695238] [      T1] RSP: 0000:ff46f50b801538d8 EFLAGS: 00010246
>> [    1.695723] [      T1] RAX: 0000000000000000 RBX: 0000000000000cc0 RCX: 0000000000000000
>> [    1.696356] [      T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc0
>> [    1.696981] [      T1] RBP: 0000000000000034 R08: 0000000000000000 R09: 0000000000000cc0
>> [    1.697605] [      T1] R10: 0000000000000034 R11: 0000000000000100 R12: 0000000000000034
>> [    1.698231] [      T1] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>> [    1.698872] [      T1] FS:  0000000000000000(0000) GS:ff2b932745209000(0000) knlGS:0000000000000000
>> [    1.699592] [      T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [    1.700119] [      T1] CR2: 0000000000000000 CR3: 00000006ede4a001 CR4: 0000000000773ef0
>> [    1.700745] [      T1] PKRU: 55555554
>> [    1.701023] [      T1] Call Trace:
>> [    1.701283] [      T1]  <TASK>
>> [    1.701512] [      T1]  alloc_pages_node_noprof+0x4c/0xc0
>> [    1.701919] [      T1]  __dma_direct_alloc_pages.isra.0+0x164/0x1f0
>> [    1.702402] [      T1]  dma_direct_alloc+0x19f/0x2b0
>> [    1.702767] [      T1]  dma_alloc_attrs+0x8d/0x200
>> [    1.703133] [      T1]  xhci_alloc_interrupter+0xc9/0x190
>> [    1.703543] [      T1]  xhci_mem_init+0x283/0x340
>> [    1.703902] [      T1]  ? __pfx_xhci_pci_quirks+0x10/0x10
>> [    1.704317] [      T1]  xhci_gen_setup+0x35e/0x4f0
>> [    1.704684] [      T1]  xhci_pci_setup+0x52/0x1c0
>> [    1.705038] [      T1]  usb_add_hcd.cold+0x241/0x5d8
>> [    1.705413] [      T1]  usb_hcd_pci_probe+0x188/0x480
>> [    1.705803] [      T1]  xhci_pci_common_probe+0x6b/0x2f0
>> [    1.706218] [      T1]  local_pci_probe+0x4a/0x90
>> [    1.706582] [      T1]  ? cpu_hotplug_disable+0x15/0x30
>> [    1.706986] [      T1]  pci_call_probe+0x55/0x150
>> [    1.707357] [      T1]  pci_device_probe+0xae/0x150
>> [    1.707734] [      T1]  ? kernfs_create_link+0x61/0xb0
>> [    1.708139] [      T1]  ? sysfs_do_create_link_sd+0x81/0xf0
>> [    1.708562] [      T1]  call_driver_probe+0x23/0x100
>> [    1.708949] [      T1]  ? driver_sysfs_add+0x55/0xc0
>> [    1.709334] [      T1]  really_probe+0xd7/0x2d0
>> [    1.709681] [      T1]  ? _raw_spin_unlock_irq+0xe/0x30
>> [    1.710098] [      T1]  __driver_probe_device+0x9c/0x1b0
>> [    1.710503] [      T1]  driver_probe_device+0x1f/0x80
>> [    1.710892] [      T1]  ? __pfx___driver_attach+0x10/0x10
>> [    1.711323] [      T1]  __driver_attach+0x10a/0x210
>> [    1.711706] [      T1]  ? __pfx___driver_attach+0x10/0x10
>> [    1.712125] [      T1]  bus_for_each_dev+0x86/0xf0
>> [    1.712488] [      T1]  bus_add_driver+0x13e/0x230
>> [    1.712858] [      T1]  ? __pfx_xhci_pci_init+0x10/0x10
>> [    1.713273] [      T1]  ? __pfx_xhci_pci_init+0x10/0x10
>> [    1.713681] [      T1]  driver_register+0x75/0xe0
>> [    1.714049] [      T1]  do_one_initcall+0x7a/0x1c0
>> [    1.714429] [      T1]  do_initcalls+0xe1/0x100
>> [    1.714780] [      T1]  kernel_init_freeable+0x152/0x1c0
>> [    1.715199] [      T1]  ? __pfx_kernel_init+0x10/0x10
>> [    1.715592] [      T1]  kernel_init+0x1f/0x140
>> [    1.715928] [      T1]  ret_from_fork+0x19e/0x270
>> [    1.716296] [      T1]  ? __pfx_kernel_init+0x10/0x10
>> [    1.716680] [      T1]  ? __pfx_kernel_init+0x10/0x10
>> [    1.717071] [      T1]  ret_from_fork_asm+0x1a/0x30
>> [    1.717438] [      T1]  </TASK>
>> [    1.717663] [      T1] ---[ end trace 0000000000000000 ]---
>> """
>>
>> This does not happen with latest Linus tree 40288c9206c1 ("Merge tag
>> 'drm-fixes-2026-09-19' of https://gitlab.freedesktop.org/drm/kernel").
>>
>> What I could determine is:
>>
>> - In xhci_alloc_interrupter() max_segs=0, which leds to seg=0
>>
>> - This eventually leads to passing size=0 to get_order() in
>>    __dma_direct_alloc_pages() (call sequenece below). Passing size=0 to
>>    get_order() is undefined and returns order=52 on my guest, whch leads
>>    to the warning since 52 > MAX_PAGE_ORDER
>>
>>      xhci_alloc_erst()
>>        dma_alloc_coherent()
>>          dma_alloc_attrs()
>>            dma_direct_alloc()
>>              __dma_direct_alloc_pages()
>>              get_order()
>>              alloc_pages_node()
>>
>> [1] git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm origin/mm-new
>>
> 
> Thanks for the report. From my understanding, it is already
> fixed in mainline by 045b5bef916d ("usb: xhci: Fix HCS_ERST_MAX conversion").

You're right, cherry picking this into mm-new fixed the issue for me.
Andrew hasn't rebased on top of v7.3-rc2 yet. Thanks for the quick
reply.


