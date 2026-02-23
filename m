Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53CA8EC111E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7794C6B0005; Mon, 23 Feb 2026 13:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F716B0089; Mon, 23 Feb 2026 13:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1836B008A; Mon, 23 Feb 2026 13:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44F026B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:34:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6F2B1A02BC
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:34:58 +0000 (UTC)
X-FDA: 84476573076.06.F548495
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id E4A8E20005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:34:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JVhfurLB;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771871697; a=rsa-sha256;
	cv=pass;
	b=GaMzwHG1FgPX+f9geqcKJlrS97hGVf2pJsvLvRrCESNdNeabPXdBap6BM0rrvOD1TFq+YB
	o2YZl1zgCPQN4yhmvuurWR/dluuBe4l5ezF36SfzuhaRArvJhpRHzjoxk/FAlDiSRi8u+X
	i//QVIFu49xiZ04ttB11N/2fGLqH81Y=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JVhfurLB;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771871697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lz0oK+ychdaoRtxzg+00l8Xp5WJQauixHHGm6VHBlk=;
	b=5/xmF+xd3vjPF9Vcegd7dEEoCzx9JfEc4vsFNSiQ46mjzovfkLA51/sLGgRV/6Rxvyekl9
	YE6plarvMZvzyzVh6It2gWkCSd4WEAAj6lccV4nz8e+Fs9Mp/DPWe7R9EUzrXYl0/9kgTF
	KlqninXKxNsXTbuP7Rq7KaJPGrPku1E=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5033b64256dso43751cf.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:34:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771871696; cv=none;
        d=google.com; s=arc-20240605;
        b=Cn1aikfibu8YonLTXfhIYQZhFV75BrX0Y00t7m8REI2kvIYFIxmH43E+zKQLSnlXBX
         DhXsl5bueKrQo2R+a11k3K40WZQkXSKJLdDO80wijpj/bXNPEeU6qzIOQ3CyGg4fcAcR
         yJy+lREohtWDa3JotxGHjsPTFiZKanYnnX3uKV97xUar3bRR6n7SLjJrf9zl7Loxzg6W
         lUpys5+wYHQBSUu1FAMyvaz4oayG+v+SdO8+ql733AMWxqw/+nH9MFnjeLb1/BMNF20F
         mkF4uqa6aUyJRtcvJrgP17bAyiAmVHpKnxA9zHzFdf5p/DdMR2W5lTKyB1KFJFaAsNHd
         BdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9lz0oK+ychdaoRtxzg+00l8Xp5WJQauixHHGm6VHBlk=;
        fh=/sHXG0PhHD2PPHWJPpH9s3Bzrhc+8D50KMuZIZGD8Hg=;
        b=HDLSlluOjOwCTQQoMYk7VGeHwKjo4w1m3iQuYTrsCcwsqCd3iowH4M8A5LEQVWueJo
         TH/vQvf7EhZdte1jh4ZhoMe4oOZQVYgOVWWeTkpa4G58vBWKbn1LNuhAzOw/FV88O5mM
         1nF1iOfBtKYC8nyFeHHnEyBIQMN7Ann68PPZQD4x0u3PNoC86xkTOlP3B/zCPjgMeSaK
         vWWPuDgRRMjyjOPSUSZzz/dhjVZ0Xk2gXKbSto6fCly5S0uPNrQtRr9ocr766VRNmtqy
         LpPfFldleIUJdT3CrpoJxDAGQBMbAjL/EVkilqHIXAGMtDpVT2fA3c2/wLC4oFeeL9Ef
         j6fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771871696; x=1772476496; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lz0oK+ychdaoRtxzg+00l8Xp5WJQauixHHGm6VHBlk=;
        b=JVhfurLBm7cUDJPfIpSBY0Iz8RV5EptZiqM5kzdA3zKxivjtzOJ68loF64cMsHCE6v
         DA6ty3pXzFaXmH0g4/5RxUblmb5p+z5lGvmf3HCI0e5RaJ0SYvKGChm1A+u0Hiyrvyey
         bN8JCwqKi2uryxOJvjlKhFVIX/z6XzSwI9yqkLnEf55iKpgLf/054nXdZAF4GGcIDR7X
         1uzqAD/hRgYjRTXWLrLNlBc4NXOoo/DOxXiah7U+4i1RKB9Zge3yEcASqHFSqcfVES8I
         Q7JsZEMzC8l3l6yNRLJN83kudf/B4KBpqWMstPg5pcRparPjWkFfFn2FnT0mFWZ4pFKm
         OY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771871696; x=1772476496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9lz0oK+ychdaoRtxzg+00l8Xp5WJQauixHHGm6VHBlk=;
        b=wOawcnxrIsaUChZST6eEzfroETOY+sVI8ntRVw+ZOIRzjQb12FYyGO/xs/5XX2l1Eb
         IKadni+iVqVOQZ8/z5prDrKz+lFHsoFFTDjqQd7Gb0myZGxWcu9veAP/0u0i1a+Fx/8Z
         +6GC3dfLtnlrn6COtUYylr9ObawBgrfqv5gLPptwVQBc17XA7eS2HXcYGOcxKlf/D5u6
         2gIxxzWGNAkwHj6+0mxed0GAFFHDqBD9ERfvviJpG0D8NKHqBJoESnzFPqz7XzkPbBoj
         O+yo1DXt08oOx5rSHDtUwWZ44vP/XL+M2/pdzio/5viAm7m0vGrN7UeIJKnHyKCJUl1W
         dKKw==
X-Forwarded-Encrypted: i=1; AJvYcCUrhKPKB34zgPsTILnVY0QtUYQM8R3ksvlz0xLLtdeloCrMJkd2rZ6QbKNGRjoMYvNeRASnIclbVw==@kvack.org
X-Gm-Message-State: AOJu0YzHT4KNGAx0q3LPNGVNDWMffrqZIJnE3qBL3VxP8yIppJY/5+Sk
	Ht49IjyjJyiytVuOZ1YnXaQh9Z2IO2WOxPrTP7WbkArf0/kWNVY8XX2t/1UeQuXj7W02G9E/QKj
	B/32fw+5mr2Oo5Y2BoPgrgfSCyk+fxvYYac3RZLk/
X-Gm-Gg: AZuq6aKvG2Ht+uhEqCxQjXGQG+7HsMmhilTapfkO2r0Jw/vPGr1V29RmfcUXcJICnqI
	v+2KAjXKqrL1lC4FIr7cDommjiR+k21iPCIiCGf+Q1NrYjzeP2XA2MLCaIL1Xe5IGtXn4nUsO5q
	eXTlEz/VRIsTHoyCMyUq8i+x6TxMzS5YH+VaHki0rKWzP+qdd1uy3beQOJ1AJBzadR4ehVq9dkx
	JcVRVEUPvyxbpD5J7etVkvhrtyJBjWjvzAXBEfB6v3WSbu4Ghsnfe94k6ljQXkjowzbDUL1rlUn
	nc9F0w==
X-Received: by 2002:a05:622a:11d6:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-5072c9f4d39mr323241cf.8.1771871695469; Mon, 23 Feb 2026
 10:34:55 -0800 (PST)
MIME-Version: 1.0
References: <20260223155128.3849-1-00107082@163.com> <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
In-Reply-To: <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Feb 2026 10:34:42 -0800
X-Gm-Features: AaiRm53fmpm6v_smjKE7BKMzhbuUvY6HlBQw3FyGS4ECJIIm7SZMCx69mqPbH00
Message-ID: <CAJuCfpEhaT+6MRzQJA0mDCW6sqXJF4VBagpHZx7Zut+xjvccmg@mail.gmail.com>
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during boot
To: Vlastimil Babka <vbabka@suse.com>
Cc: David Wang <00107082@163.com>, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E4A8E20005
X-Stat-Signature: jjiub9pn6z45w78w7sybojkn9ctikek1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771871696-253790
X-HE-Meta: U2FsdGVkX1+LD6wN291HPa+KDXDsxiNyJt1woOOeqGNj7n6MqHth5R7jKOdoqQxu/6pJg12E2cymxFitFvqEHMjMZd5mTqxp6/h2cTRnd9VLji603Yep8Fm6GP3kAtY6Q6h0n9XdgiU/fhrakr+3CcxRxJty/qNMBUmsyQFoEdTxyBlajvsq4yHuiS/A+1WZPHJwMGPWnRcoV0jzd+Y2mAmlbT9X/KdxgxOJE3MTyiwfWkkGgLdC0GVDmuKcsbuJgpIAouSQxlaSPl7zTTYTfTO2e75MdDIXK2R/My0DCO2L7fNLKCEIIjMvvisWgyPFevhO/o1WBxm8czxPrHClUdUX1TWjddj1UmIOkD5mIF/KLW328FEwB4YpNkaFZosLU0kUyXgN41IiUWDkKfLRIpoghRXHsyhbL0pGcVyDlcrh0XNo1onvd868t2EmJtDPS9B0QdiGfRf+Fjj5R/MOgoo8Dars7DPOdQPcrdIN+FTOMau6vNCM8MS239GGyNobv+ZGe8lOV1zw/VcNuqaCBHizMiIlnqn7FK94SOu8AMQ74cuZxqb1L60xB9Z47Ao75dO3s3UJJPaVc9AUjcyidsBRqqdL936qYXJiGvFerUv+Wp/Ng+kOxmaw0jGQ4c5YRhN0w2y1KU+p5xyDreKAcQmBpUiYjUSL5QfsgOmh0y+6nMN9/jSRY3+KzOHVK1DaBTU55l2beydT6c28tAeNu8r6FzZHGdZGDJQbvLF36KHtWZPTxT3C5ROnJIB9/iWLvgSieoSVrn2tgzuK/eoMejKwZQTvwqhXiIshYT5unlYOtrGSM6qvSOPB9PBpJ7zYuUYfv7XfZjsVTMoyL5AmOtE0USIc3A6W8ojlc7cdtx8bF4xfJCVIbdF/hKzIksVpdWmR3O7ZLxFn7AwWujLfIvc6jPXjnMHp2AIW7ZT4RuP9vh34kAlv/78kWdwOb9O2rPzlcJEg1S5iNiPPU+N
 cMt2y8xR
 k+miAe2LerzxaMJIAGkBeAV4cf1mJXenX9HcAn87OswbkSFKpzwkg9w49JpuX6any3zWGWfISLwcZ9fbYFQVKVIKJrzS2cjGidUAagFqayb4FVFDzspsL95l0pNDcGqdblX7e4He+MHHVQ4yKVRlAHm7wX1/aPTQsz11pbx9gdE4W2q099e6m+o6sakbHypwQfMJChUE68XbrQs0LrcWax80JlEWujtLRoWoZQl8FkUrIW4sTZY3IGiSYjAD4ek65KefFhlfs/WOkBPWfS9MHHQCnF1uyTzGbwQ8CBFQ+KQOGtXeyOTPKPFHbcidKnfbq9v+pSLrVv41nKQsAdx0LC4OCBcu/mDqRheyhqggHiyz4+f0v3f6O5AMJr/RV+atB7KfHR3bkrS0q2iDKj22or+8r1OIKowQG5VMn8Y4VfrbxjfJ2lWaRpx7pFPEV+rofmPy5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 9:18=E2=80=AFAM Vlastimil Babka <vbabka@suse.com> w=
rote:
>
> On 2/23/26 16:51, David Wang wrote:
> > Hi,
> >
> > When upgrade to 7.0.0-rc1, caught a kernel WARN during boot:
>
> Would this possibly help? (it probably shouldn't but let's see)
> https://lore.kernel.org/all/20260223075809.19265-1-harry.yoo@oracle.com/

Hi David,
Could you please send us your kernel config? I just tried v7.0-rc1
(Linus` ToT) with CONFIG_MEM_ALLOC_PROFILING_DEBUG enabled and did not
see any warnings. Something must be different on your end.
Thanks,
Suren.

>
> >        ------------[ cut here ]------------
> >        alloc_tag was not set
> >        WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab=
_free_hook+0xe6/0x120, CPU#4: (udev-worker)/145
> >        Modules linked in: xhci_pci(E+) ahci(E) libahci(E) xhci_hcd(E) n=
vme(E) sp5100_tco(E) libata(E) r8169(E) realtek(E) usbcore(E) nvme_core(E) =
scsi_mod(E) scsi_common(E) usb_common(E) i2c_piix4(E) i2c_smbus(E) wmi(E) f=
jes(E-) gpio_amdpt(E) gpio_generic(E) button(E) efivarfs(E)
> >        CPU: 4 UID: 0 PID: 145 Comm: (udev-worker) Tainted: G           =
 E       7.0.0-rc1-linan-0 #802 PREEMPT(full)
> >        Tainted: [E]=3DUNSIGNED_MODULE
> >        Hardware name: Micro-Star International Co., Ltd. MS-7B89/B450M =
MORTAR MAX (MS-7B89), BIOS 2.L0 07/18/2024
> >        RIP: 0010:__alloc_tagging_slab_free_hook+0xe6/0x120
> >        Code: 2c d3 e8 0f af c2 4c 01 f0 48 89 c3 74 9e 48 8b 00 41 8b 5=
4 24 18 48 85 c0 0f 85 6c ff ff ff 89 54 24 04 48 8d 3d da 4e 44 01 <67> 48=
 0f b9 3a 48 8b 03 8b 54 24 04 48 85 c0 0f 85 4c ff ff ff 48
> >        RSP: 0018:ffffd28e40278e80 EFLAGS: 00010246
> >        RAX: 0000000000000000 RBX: ffff8c36422d82c0 RCX: 000000000000000=
8
> >        RDX: 0000000000000200 RSI: fffff352840bb800 RDI: ffffffffadc4aee=
0
> >        RBP: ffffd28e40278ec8 R08: 0000000000000014 R09: ffffffffac80e09=
c
> >        R10: ffff8c3640042200 R11: ffff8c364dca2480 R12: ffff8c3640042a0=
0
> >        R13: fffff352840bb800 R14: ffff8c36422d8200 R15: ffffd28e40278ed=
0
> >        FS:  00007fa2ca8be980(0000) GS:ffff8c39c0c1a000(0000) knlGS:0000=
000000000000
> >        CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >        CR2: 00007fa2c9b727a5 CR3: 00000001158cc000 CR4: 0000000000350ef=
0
> >        Call Trace:
> >         <IRQ>
> >         ? rcu_core+0x451/0x750
> >         kfree+0xab/0x370
> >         rcu_core+0x451/0x750
> >         ? rcu_core+0x3eb/0x750
> >         ? srso_return_thunk+0x5/0x5f
> >         handle_softirqs+0x100/0x2e0
> >         __irq_exit_rcu+0xb1/0x100
> >         sysvec_apic_timer_interrupt+0x9d/0xc0
> >         </IRQ>
> >         <TASK>
> >         asm_sysvec_apic_timer_interrupt+0x16/0x20
> >        RIP: 0010:xhci_handshake+0x56/0xc0 [xhci_hcd]
> >        Code: fa 8b 07 89 f1 49 89 fe 41 89 f5 21 c1 41 39 cc 75 22 eb 3=
c f3 90 48 81 eb e9 03 00 00 48 89 da 48 c1 ea 3f 44 21 fa 41 8b 06 <44> 89=
 e9 21 c1 44 39 e1 74 1c 83 f8 ff 74 2d 84 d2 75 3d bf c7 10
> >        RSP: 0018:ffffd28e4045f9d0 EFLAGS: 00000246
> >        RAX: 0000000000000002 RBX: 000000025354e082 RCX: 000000000000000=
4
> >        RDX: 0000000000000000 RSI: 0000000000000df4 RDI: 00000014243ef47=
0
> >        RBP: 0000000000989680 R08: ffffffffc0741fbe R09: 00000000fffffff=
f
> >        R10: 0000000000000004 R11: 0000000000000001 R12: 000000000000000=
0
> >        R13: 0000000000000002 R14: ffffd28e40cc8020 R15: ffff8c3655ac180=
1
> >         ? __pfx_xhci_pci_quirks+0x10/0x10 [xhci_pci]
> >         xhci_reset+0x6a/0x110 [xhci_hcd]
> >         xhci_gen_setup+0x201/0x450 [xhci_hcd]
> >         xhci_pci_setup+0x50/0x1c0 [xhci_pci]
> >         usb_add_hcd.cold+0x265/0x5d5 [usbcore]
> >         usb_hcd_pci_probe+0x16f/0x420 [usbcore]
> >         xhci_pci_common_probe+0x39/0x2c0 [xhci_pci]
> >         ? srso_return_thunk+0x5/0x5f
> >         local_pci_probe+0x41/0x90
> >         pci_device_probe+0xd0/0x250
> >         ? srso_return_thunk+0x5/0x5f
> >         ? sysfs_do_create_link_sd+0x6e/0xe0
> >         really_probe+0xde/0x380
> >         ? pm_runtime_barrier+0x56/0x90
> >         __driver_probe_device+0x78/0x120
> >         driver_probe_device+0x1f/0xa0
> >         __driver_attach+0xf6/0x230
> >         ? __pfx___driver_attach+0x10/0x10
> >         bus_for_each_dev+0x79/0xd0
> >         bus_add_driver+0xeb/0x270
> >         driver_register+0x6e/0xc0
> >         ? __pfx_xhci_pci_init+0x10/0x10 [xhci_pci]
> >         do_one_initcall+0x43/0x310
> >         ? srso_return_thunk+0x5/0x5f
> >         ? __kmalloc_cache_noprof+0x143/0x3f0
> >         ? do_init_module+0x3f/0x280
> >         do_init_module+0x91/0x280
> >         init_module_from_file+0xc8/0xe0
> >         idempotent_init_module+0xfe/0x2f0
> >         __x64_sys_finit_module+0x6d/0xe0
> >         do_syscall_64+0xf4/0xf20
> >         entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >        RIP: 0033:0x7fa2cb41a779
> >        Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f=
8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d=
 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48
> >        RSP: 002b:00007ffe556d6b18 EFLAGS: 00000246 ORIG_RAX: 0000000000=
000139
> >        RAX: ffffffffffffffda RBX: 000055b03b330950 RCX: 00007fa2cb41a77=
9
> >        RDX: 0000000000000000 RSI: 00007fa2c9b9e44d RDI: 000000000000001=
f
> >        RBP: 0000000000000000 R08: 0000000000000000 R09: 000055b03b2fed3=
0
> >        R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa2c9b9e44=
d
> >        R13: 0000000000020000 R14: 000055b03b3242e0 R15: 000000000000000=
0
> >         </TASK>
> >        ---[ end trace 0000000000000000 ]---
> >
> > The second time I boot my system, I got the same warning but different =
call stacks:
> >        ------------[ cut here ]------------
> >        alloc_tag was not set
> >        WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab=
_free_hook+0xe6/0x120, CPU#0: ksoftirqd/0/14
> >        Modules linked in: xhci_pci(E+) ahci(E+) r8169(E+) nvme(E) libah=
ci(E) xhci_hcd(E) realtek(E) libata(E) i2c_piix4(E) nvme_core(E) i2c_smbus(=
E) usbcore(E) scsi_mod(E) usb_common(E) scsi_common(E) wmi(E) fjes(E-) gpio=
_amdpt(E) gpio_generic(E) button(E) efivarfs(E)
> >        CPU: 0 UID: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G            E =
      7.0.0-rc1-linan-0 #802 PREEMPT(full)
> >        Tainted: [E]=3DUNSIGNED_MODULE
> >        Hardware name: Micro-Star International Co., Ltd. MS-7B89/B450M =
MORTAR MAX (MS-7B89), BIOS 2.L0 07/18/2024
> >        RIP: 0010:__alloc_tagging_slab_free_hook+0xe6/0x120
> >        Code: 2c d3 e8 0f af c2 4c 01 f0 48 89 c3 74 9e 48 8b 00 41 8b 5=
4 24 18 48 85 c0 0f 85 6c ff ff ff 89 54 24 04 48 8d 3d da 4e 44 01 <67> 48=
 0f b9 3a 48 8b 03 8b 54 24 04 48 85 c0 0f 85 4c ff ff ff 48
> >        RSP: 0018:ffffd362c0137d48 EFLAGS: 00010246
> >        RAX: 0000000000000000 RBX: ffff8b718006c610 RCX: 000000000000000=
8
> >        RDX: 0000000000000200 RSI: fffffa5884001900 RDI: ffffffffa184aee=
0
> >        RBP: ffffd362c0137d90 R08: 0000000000000001 R09: ffffffffa040e09=
c
> >        R10: ffff8b7180042700 R11: ffff8b7183b47440 R12: ffff8b7180042a0=
0
> >        R13: fffffa5884001900 R14: ffff8b718006c600 R15: ffffd362c0137d9=
8
> >        FS:  0000000000000000(0000) GS:ffff8b750ce1a000(0000) knlGS:0000=
000000000000
> >        CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >        CR2: 0000560882dbc058 CR3: 0000000107e6f000 CR4: 0000000000350ef=
0
> >        Call Trace:
> >         <TASK>
> >         ? rcu_core+0x451/0x750
> >         kfree+0xab/0x370
> >         rcu_core+0x451/0x750
> >         ? rcu_core+0x3eb/0x750
> >         ? srso_return_thunk+0x5/0x5f
> >         ? try_to_wake_up+0xaf/0x740
> >         handle_softirqs+0x100/0x2e0
> >         run_ksoftirqd+0x37/0x50
> >         smpboot_thread_fn+0x114/0x2a0
> >         ? __pfx_smpboot_thread_fn+0x10/0x10
> >         kthread+0x114/0x150
> >         ? __pfx_kthread+0x10/0x10
> >         ret_from_fork+0x238/0x330
> >         ? __pfx_kthread+0x10/0x10
> >         ret_from_fork_asm+0x1a/0x30
> >         </TASK>
> >        ---[ end trace 0000000000000000 ]---
> >
> > Bisect narrows it down to 913ffd3a1b(slab: handle kmalloc sheaves boots=
trap)
> >
> >       $ git bisect log
> >       git bisect start
> >       # status: waiting for both good and bad commits
> >       # good: [05f7e89ab9731565d8a62e3b5d1ec206485eeb0b] Linux 6.19
> >       git bisect good 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> >       # status: waiting for bad commit, 1 good commit known
> >       # bad: [6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f] Linux 7.0-rc1
> >       git bisect bad 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> >       # bad: [6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f] Linux 7.0-rc1
> >       git bisect bad 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> >       # good: [939faf71cf7ca9ab3d1bd2912ac0e203d4d7156a] Merge tag 'drm=
-next-2026-02-11' of https://gitlab.freedesktop.org/drm/kernel
> >       git bisect good 939faf71cf7ca9ab3d1bd2912ac0e203d4d7156a
> >       # bad: [c87c79345ea8ff917354e9223d44034e4aef2690] Merge tag 'uml-=
for-7.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/uml/linux
> >       git bisect bad c87c79345ea8ff917354e9223d44034e4aef2690
> >       # good: [83310d613382f74070fc8b402f3f6c2af8439ead] Merge git://gi=
t.kernel.org/pub/scm/linux/kernel/git/netdev/net
> >       git bisect good 83310d613382f74070fc8b402f3f6c2af8439ead
> >       # bad: [541c43310e85dbf35368b43b720c6724bc8ad8ec] Merge tag 'fs_f=
or_v6.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-f=
s
> >       git bisect bad 541c43310e85dbf35368b43b720c6724bc8ad8ec
> >       # bad: [1c2b4a4c2bcb950f182eeeb33d94b565607608cf] Merge tag 'pci-=
v7.0-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci
> >       git bisect bad 1c2b4a4c2bcb950f182eeeb33d94b565607608cf
> >       # bad: [61e629596fabd7f60cc3748a603703c5d9b58428] Merge tag 'for-=
7.0/dm-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-map=
per/linux-dm
> >       git bisect bad 61e629596fabd7f60cc3748a603703c5d9b58428
> >       # bad: [148f95f75c513936d466bcc7e6bf73298da2212b] Merge tag 'slab=
-for-7.0' of git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab
> >       git bisect bad 148f95f75c513936d466bcc7e6bf73298da2212b
> >       # good: [41f1a08645abb5ef7d2a3ed8835c747334878774] Merge tag 'kbu=
ild-7.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux
> >       git bisect good 41f1a08645abb5ef7d2a3ed8835c747334878774
> >       # bad: [6c2f307f30edbe2b18a35584f01854a27e375927] slab: remove un=
used PREEMPT_RT specific macros
> >       git bisect bad 6c2f307f30edbe2b18a35584f01854a27e375927
> >       # good: [f3421f8d154cc0906da145299c72f4a7f046ffde] slab: introduc=
e percpu sheaves bootstrap
> >       git bisect good f3421f8d154cc0906da145299c72f4a7f046ffde
> >       # bad: [e323b52cf00ffc3f5ac79420af7ab340b4576a5c] slab: remove SL=
UB_CPU_PARTIAL
> >       git bisect bad e323b52cf00ffc3f5ac79420af7ab340b4576a5c
> >       # bad: [913ffd3a1bf5d154995c6cfab44994b07b3c103f] slab: handle km=
alloc sheaves bootstrap
> >       git bisect bad 913ffd3a1bf5d154995c6cfab44994b07b3c103f
> >       # good: [f1427a1d64156bb88d84f364855c364af6f67a3b] slab: make per=
cpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
> >       git bisect good f1427a1d64156bb88d84f364855c364af6f67a3b
> >       # first bad commit: [913ffd3a1bf5d154995c6cfab44994b07b3c103f] sl=
ab: handle kmalloc sheaves bootstrap
> >
> >
> >
> > FYI
> > David
> >
>

