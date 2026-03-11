Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9AA112584E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C346B0005; Wed, 11 Mar 2026 12:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909DA6B0089; Wed, 11 Mar 2026 12:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809116B008A; Wed, 11 Mar 2026 12:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58CD46B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:12:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D20E11A0256
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:12:13 +0000 (UTC)
X-FDA: 84534274146.10.B35BB26
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09E864000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:12:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=j62F5tC1;
	spf=pass (imf04.hostedemail.com: domain of tj.iam.tj@proton.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=tj.iam.tj@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773245532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M2SJ/HP/rau99jkUDcUZWMfXlp0BxhTsL5PKAYM5ffQ=;
	b=M2UZhm8zy7I/F7IEZM3OJLNCAOD3XSwYt095S3vpg8u5Hh4nIkCNUF024+AE5gLEcJBdUM
	B8YtOaIha2AYi3auheLide+rJWkl2/DJaQXxRkMBykYhpR/BKDfh9LKxFDqhIMLTMPKXYC
	005dfLn15IXPtX9Zd7VvdCj5gIvW4Fw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=j62F5tC1;
	spf=pass (imf04.hostedemail.com: domain of tj.iam.tj@proton.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=tj.iam.tj@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773245532; a=rsa-sha256;
	cv=none;
	b=6maoqPrHAVKa1ATR/NK8ezphBRY9IIIyE4LibQragZnQLX4gQIo6BQXFsdiVGxZUzuD+ez
	UQtCflhsvjqufQViq4TqkVn2kWDEyJgrRCCkEKBIHgUmJyl+Qz7dGFl6fklvNLyLg+yjuM
	XX6dLFg3PX31kjS8U4I3PxqE9Fm8vcs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1773245529; x=1773504729;
	bh=M2SJ/HP/rau99jkUDcUZWMfXlp0BxhTsL5PKAYM5ffQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=j62F5tC1zJJIVh63mB5Qn3kdtIHn4fkm3yd0NcF7wCXnVN99/h9lKI7RHXuZmfDjo
	 NxgzdhnR7YK34w/221hHK4l00lP45KHubh/84O2Y0PTShG/wke/aHXj3JmAy9baN9L
	 aR86j5dATlHOt8mWdqTZzEN7rDRluwScfU6rp3rFt3YK5Kzzzan9UvFebPj6bID11x
	 PlCUv5KYQng/0kxjyb79tcPn7DArLVroVWYAIaiiaKwi1NAbbJ53554qDC0uJMClTq
	 ybw9Hqtt0dEkK6criiIS5/wqN5kl+8Cg5ZxUmewqsY1Kn3U3S//B2pThk4yo8gipOM
	 YzIrOzcysLxeA==
Date: Wed, 11 Mar 2026 16:12:07 +0000
To: david@kernel.org
From: Tj <tj.iam.tj@proton.me>
Cc: linux-mm@kvack.org
Subject: BUG: Bad page state in process kworker/u32:1
Message-ID: <4df99438-637c-4919-96dd-1fbe6dce70cb@proton.me>
Feedback-ID: 113488376:user:proton
X-Pm-Message-ID: f53130e8a6e4458503759000244b585a4d5d177c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 09E864000C
X-Stat-Signature: wmzjt6eo3ckpeqyddbiiw84ioyyy45hb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773245531-876482
X-HE-Meta: U2FsdGVkX1/ojrXu12r34msGyX7V6VPQM3ifRnNO+e4ssO7RqVrfQo//7mXVr3rB4gVGhFKic48OK5z4NwEU7WIA32EjmrXm4w6dSBM6G4y0thfrEYszISkoqCwVpnqg6DFsmcC1rfG39XXrZvN2T0RtaWzsTCBMjbfU8a6Jg352+iymIh/gQXXHNVCaIM4hguY9AovQdOLh2VQbVUWFmE+gEE+L9GH2dxOK9Vjy4UsBEUShg4Ge3k6N44to45bInlu0TEIJSgqVrs3Onmq1SKyDFoXHv8lhK+wYqeBhke1X8J2UM4rq5sdO4EXCgwKw4Qft5By0cR+fady8RzDU2882a1UxsIkKMLSlRTkIhxtuhQQxnRloJYphRaqM4YxPACXFUr2DxXwGiVmMeFiNIMrf/uAQbWrwED4KbncC+kVSl5+asje99od+Y4zq420dKlROTN6DZQaqt2UbFcg90fMfbhd3UUv1jgoLCVsj1P7OLWZZg8n7+pJRaaxBPNwbR1LtF64WBpYA7tC0Y+5OTqP+JkvfMfO8DNRiOC2ZzDrjRB8n4dKkGelgrHir6HzRBhc//y5whViHt0k36dKkryj2uT7MT/e/iIyFiWdBKQabat07UT1cu+SN976QjtQj0ohQ0TAPPOFw4wXaaKfzaJrXBFqpBApOzlvdaJgjA9OO9/qJr7VLVK5UGOOrqVhArIH5u3FiHUrcqGCrhZwO0gCd7rJLyNtnJ/Ors4X4AYi3OClo0wJObzOqkOJ4xbBorFzKH7y+rSg7tjzhrD5vLhLQpktp+pvcZZfTWZh60q5M3N7GMKcqn6qbjB4GZm4yuUCHCjev1H2t5yOpYqFenO0hvVWj9tkcGLh36ga439HLNlQuw3X7QxG66JwwpngANcM2wSBF14N9AA0zn3gKpi6DiMXoBjpbxewvJS25q9K4IZqAKRa7U+ChsciDGDxp7QDozOIS/q81AdP2PqZ
 eCfXP62/
 p2WS1zTgD117fVFrYjqUX5D+kgH9s18mS8aE+D+tsID9qbWOKCCs9gmArC2bOu2vfUO/34R9PjB5xAAuFjPzxXWwX7Ve6/HLBapwCDmmpZoiahV1aCZMGqdg/7p2LSe+kR9tM7AdVrSZ+CZ1moAro5tz5Q/0WvtDTAojIXj9/iNUqVZh9xe5jrbpW1+LkGbQJVWY+POdkvobuDXpSBAMj/aPyDw0r0pr5LX8o61Qb8UDYW87ueg6729xAyoeSbEEn9GaYX6twm2FpcxQE2CN7i+Isd9EyNCWEVbYFMvAFFl3l5CrAiq/1ve6KJ2WZhpfhiV3pj4NsSMcd5BXuiVQjIOj79g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On arm64, Qualcomm sdm845, an attempt to allocate and release a CMA for=20
DMA fails. It seems to be caused by the recent commit 9bda131c6093e9c4=20
"mm: cma: add cma_alloc_frozen{_compound}()" where cma_alloc() now calls=20
set_page_refcounted() but cma_release() or its callees do not undo it,=20
resulting in:

kernel: BUG: Bad page state in process kworker/u32:1=C2=A0 pfn:f4b00
kernel: page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0=20
pfn:0xf4b00
kernel: flags: 0x1ffe00000000000(node=3D0|zone=3D0|lastcpupid=3D0xfff) CMA
kernel: raw: 01ffe00000000000 fffffdffc1d2c048 ffff800080353608=20
0000000000000000
kernel: raw: 0000000000000000 0000000000000000 00000001ffffffff=20
0000000000000000
kernel: page dumped because: nonzero _refcount

I've enabled pr_debug plus added in my own pr_info()s to track the=20
callers. The following shows, first, my manual dump_stack() in=20
__cma_alloc_frozen() in order to understand the callers, and immediately=20
after the BUG.

The high-level activity is the Qualcomm coprocessor firmware loading=20
that is preparing to set up a DMA buffer to pass data to the coprocessor.

kernel: ipa 1e40000.ipa: ipa_probe()
kernel: ipa 1e40000.ipa: ipa_firmware_loader()
kernel: ipa 1e40000.ipa: channel 4 limited to 256 TREs
kernel: ipa 1e40000.ipa: IPA driver initialized
kernel: ipa 1e40000.ipa: ipa_firmware_load()
kernel: ipa 1e40000.ipa: request_firmware()
kernel: ipa 1e40000.ipa: fw_get_filesystem_firmware()
kernel: ipa 1e40000.ipa: Firmware loaded:=20
qcom/sdm850/samsung/w737/ipa_fws.elf
kernel: ipa 1e40000.ipa: ipa_firmware_load() =3D 0
kernel: ipa 1e40000.ipa: ipa_firmware_load() calling qcom_mdt_load()
kernel: ipa 1e40000.ipa: qcom_mdt_load()
kernel: ipa 1e40000.ipa: __qcom_mdt_pas_init()
kernel: qcom_scm firmware:scm: qcom_scmp_pas_init_image( id=3D15,=20
metadata=3D00000000239bef84, size=3D6812, ctx=3D0000000000000000 )
kernel: cma: __cma_alloc_frozen(cma 000000003df15a7c, name: reserved,=20
count 2, align 1)
kernel: CPU: 1 UID: 0 PID: 56 Comm: kworker/u32:1 Not tainted=20
7.0.0-rc2-sdm845 #78 PREEMPTLAZY
kernel: Hardware name: SAMSUNG ELECTRONICS CO., LTD. Galaxy=20
Book2/SM-W737YZSBTEL, BIOS P02AHG.005.190624.WY.1359 06/24/2019
kernel: Workqueue: events_unbound deferred_probe_work_func
kernel: Call trace:
kernel:=C2=A0 show_stack+0x20/0x38 (C)
kernel:=C2=A0 dump_stack_lvl+0x78/0x90
kernel:=C2=A0 dump_stack+0x18/0x28
kernel:=C2=A0 __cma_alloc_frozen+0x4c/0xa98
kernel:=C2=A0 cma_alloc+0x30/0x98
kernel:=C2=A0 cma_alloc_aligned+0x48/0x78
kernel:=C2=A0 dma_alloc_contiguous+0x38/0x58
kernel:=C2=A0 __dma_direct_alloc_pages.constprop.0+0xd4/0x430
kernel:=C2=A0 dma_direct_alloc+0xdc/0x3d0
kernel:=C2=A0 dma_alloc_attrs+0x98/0x488
kernel:=C2=A0 qcom_scm_pas_init_image+0x148/0x228
kernel:=C2=A0 __qcom_mdt_pas_init+0x138/0x240
kernel:=C2=A0 qcom_mdt_load+0x6c/0xb8
kernel:=C2=A0 ipa_probe+0xe80/0x13c0
kernel:=C2=A0 platform_probe+0x64/0xa8
kernel:=C2=A0 really_probe+0xc8/0x3f0
kernel:=C2=A0 __driver_probe_device+0x88/0x190
kernel:=C2=A0 driver_probe_device+0x44/0x120
kernel:=C2=A0 __device_attach_driver+0xc4/0x178
kernel:=C2=A0 bus_for_each_drv+0x8c/0xf0
kernel:=C2=A0 __device_attach+0xa4/0x1d0
kernel:=C2=A0 device_initial_probe+0x58/0x68
kernel:=C2=A0 bus_probe_device+0x40/0xb8
kernel:=C2=A0 deferred_probe_work_func+0xc0/0x128
kernel:=C2=A0 process_one_work+0x17c/0x4e8
kernel:=C2=A0 worker_thread+0x198/0x330
kernel:=C2=A0 kthread+0x13c/0x150
kernel:=C2=A0 ret_from_fork+0x10/0x20
kernel: cma: __cma_alloc_frozen(): returned 00000000585b858d
kernel: qcom_scm firmware:scm: __qcom_scmp_pas_init_image()
kernel: qcom_scm firmware:scm:=C2=A0 =C2=A0qcom_scm_call) =3D 0
kernel: qcom_scm firmware:scm:=C2=A0 =C2=A0called qcom_scm_bw_disable()
kernel: qcom_scm firmware:scm:=C2=A0 =C2=A0called qcom_scm_clk_disable()
kernel: qcom_scm firmware:scm: __qcom_scmp_pas_init_image() =3D 0
kernel: cma: find_cma_memrange(page 00000000585b858d, count 2)
kernel: cma: __cma_release_frozen(page 00000000585b858d, count 2)
kernel: BUG: Bad page state in process kworker/u32:1=C2=A0 pfn:f4b00
kernel: page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0=20
pfn:0xf4b00
kernel: flags: 0x1ffe00000000000(node=3D0|zone=3D0|lastcpupid=3D0xfff) CMA
kernel: raw: 01ffe00000000000 fffffdffc1d2c048 ffff800080353608=20
0000000000000000
kernel: raw: 0000000000000000 0000000000000000 00000001ffffffff=20
0000000000000000
kernel: page dumped because: nonzero _refcount
kernel: Modules linked in:
kernel: CPU: 4 UID: 0 PID: 56 Comm: kworker/u32:1 Not tainted=20
7.0.0-rc2-sdm845 #78 PREEMPTLAZY
kernel: Hardware name: SAMSUNG ELECTRONICS CO., LTD. Galaxy=20
Book2/SM-W737YZSBTEL, BIOS P02AHG.005.190624.WY.1359 06/24/2019
kernel: Workqueue: events_unbound deferred_probe_work_func
kernel: Call trace:
kernel:=C2=A0 show_stack+0x20/0x38 (C)
kernel:=C2=A0 dump_stack_lvl+0x78/0x90
kernel:=C2=A0 dump_stack+0x18/0x28
kernel:=C2=A0 bad_page+0x8c/0x138
kernel:=C2=A0 __free_frozen_pages+0x4dc/0x778
kernel:=C2=A0 free_contig_frozen_range+0xd8/0x128
kernel:=C2=A0 cma_release+0xf8/0x378
kernel:=C2=A0 dma_free_contiguous+0x34/0x88
kernel:=C2=A0 dma_direct_free+0x100/0x188
kernel:=C2=A0 dma_free_attrs+0x90/0x248
kernel:=C2=A0 qcom_scm_pas_init_image+0x1a4/0x228
kernel:=C2=A0 __qcom_mdt_pas_init+0x138/0x240
kernel:=C2=A0 qcom_mdt_load+0x6c/0xb8
kernel:=C2=A0 ipa_probe+0xe80/0x13c0
kernel:=C2=A0 platform_probe+0x64/0xa8
kernel:=C2=A0 really_probe+0xc8/0x3f0
kernel:=C2=A0 __driver_probe_device+0x88/0x190
kernel:=C2=A0 driver_probe_device+0x44/0x120
kernel:=C2=A0 __device_attach_driver+0xc4/0x178
kernel:=C2=A0 bus_for_each_drv+0x8c/0xf0
kernel:=C2=A0 __device_attach+0xa4/0x1d0
kernel:=C2=A0 device_initial_probe+0x58/0x68
kernel:=C2=A0 bus_probe_device+0x40/0xb8
kernel:=C2=A0 deferred_probe_work_func+0xc0/0x128
kernel:=C2=A0 process_one_work+0x17c/0x4e8
kernel:=C2=A0 worker_thread+0x198/0x330
kernel:=C2=A0 kthread+0x13c/0x150
kernel:=C2=A0 ret_from_fork+0x10/0x20
kernel: Disabling lock debugging due to kernel taint



