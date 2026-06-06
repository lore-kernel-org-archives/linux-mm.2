Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2929CD8C8E
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 15:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726A16B0005; Sat,  6 Jun 2026 11:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D74A6B008A; Sat,  6 Jun 2026 11:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE216B008C; Sat,  6 Jun 2026 11:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBF76B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:12:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBF4FC1D96
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 15:12:35 +0000 (UTC)
X-FDA: 84849829470.08.0AE37E1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3F770140010
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 15:12:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BHf1OPBz;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780758754;
	b=KsmEcr6PppKlUkRoHvAxZD06LmVb/t27G37Pv5ojpTm0W7u/ZnWznomDIJxdJKxo/IsvfV
	7wsUn+Lh5Nhu0oxnSRL0qvc33SwF/ctNXzrIOhN0mYwNCnVtHH31kdvIOe9d1rLw3HHLxI
	gwzCbfNYgIc3Pdyd12K+pLYh9baDsik=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BHf1OPBz;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780758754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kh2Amh5Qay0XKB1cF3zgLks8hgM3+6prnNJyIAjsgQk=;
	b=yMcZM9ExKh/AobRZWrepsGyG+NW2NS0PePKcWfSmtgDIGofwFtBtsMnwXXsrtsXv4huZ/3
	GViGpssNZvH2iRMHYTIkXvzhmgY1dDqp0YTgBzEv4x37vw9F/PuT3liL1GcoWxW15Pdea+
	vFEICNAbfpR311vb9ufzK9dycZNcl/Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kh2Amh5Qay0XKB1cF3zgLks8hgM3+6prnNJyIAjsgQk=; b=BHf1OPBzEpjmzYRIhX6tfPXpc5
	QY4v90oZTN0TLXCHivFKP9lBNjssFq1xSOyFhh6FcUAEAgyYZMc49K3IZB8q61rLzn5Jy8WmoU7n/
	URSsbpd6n3SIUgWNQu/444RB51IdxBTG9nCcisWQD8y7P+SG+zt9TzHbjcEfOQI91lM/Pu3pNvlpD
	X2a2D36LuB/6yH+Qnrf8krzypgOe95Br3wwOTFmYR0gIUMRKRSaI5AP98JvzhL/ygW2c5wsuIDtGL
	dORFU6Bt5t5dY/W7W08oQ7aqHeqi1EQz9CvwtBv5a4vvr027/oRoqPAslruYRUyB83XAI8M1hP92C
	LrgmsWjw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVshJ-0000000AVDu-3r2l;
	Sat, 06 Jun 2026 15:12:29 +0000
Date: Sat, 6 Jun 2026 16:12:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dirty One <crossedwrenches2x2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re:
Message-ID: <aiQ43RsfZVKiTWrm@casper.infradead.org>
References: <CADuGuZSD2ccZO7FcZ2Edtpm+FX+8713BM=kLsUa4=mEz54_AoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADuGuZSD2ccZO7FcZ2Edtpm+FX+8713BM=kLsUa4=mEz54_AoA@mail.gmail.com>
X-Rspamd-Queue-Id: 3F770140010
X-Stat-Signature: oud8nos7yt9f1j9ojrt3pnksscgz44ee
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780758753-58385
X-HE-Meta: U2FsdGVkX1+zGl0+BKg78hTI7JpiTES5bfeW2dCqK3tUXRyrZfO3/ireA4v3orZSUnkENc9w3vgXyHN1m34fjKRaqJqinlgFmEstNKX63b2aXcgQMsXwNJXK4VmVBrsB9rTMJ7q1Tlk2fikQVJaLlxx3svx83gEFOQ85hbYPJhthfdzB8IkjXbJw0zEYdV69Jhugv6kmzAgxy6acTxhRdcwu0l3GjoWZCNwRj6MRd4niFpC94waM8Up40i+VOjHAwx3luB5VX3rVv5EmkR6qrgnD/GNyel7hWyWQY9pShLjeMTQtCMu9ZVP42lxwT7ODI6w/mffVIwp1Wq2jztqULR/Mi5S6Funyub5fV/nrxugsB8XkGyHTSiby+5ZhFDiLMRLJavptBvdhgP9pbempFx2aZF47rB4DJCkYJuwgzPHRoVftAj9Pmu63gbY/CTpT215fhVLYcte7bXf1iNji7YSgQh3Efxyuu0szRPnhCK03KBeTOYMbS2oKfWEx1pX0qNMB83rOXe9/+z32ysS6QbvTMmlFmPc82voUaveEqrpBmcRY8j7Dr8P/iXaxh71VxoU7mcEWby9k0nf1hqifYuZxuoRwSvMbnPKcJ/+nHA+FdigAiMjLa3FKkV+FGV1lVFnTvdc66c04cVuVZlpepZ+CEii6bSqeNtxZDwiWR3lmwDX4410FcGyyVLsMk5iWNuZ132U+PoB0ipLO76fbhWUJnaTW+DT+GoL81BsXdTkpGFx0jq1t2kJP/2IltwDNGQlRab5yeqWGnwKPgjGmo2EW/OOAoY7iHIeK5YT8tUj+OzraiUAiKQuMDNH8VB5IbTI+rYLxPRDaZJpzJ7g2Rnr3seT1y9rkAB5bfbomcSWWzAwSi2XcAleSR4GzAsZoicNcPwDhDpuOEs96HbYTjVkIxG9zz9fhxkxVy+9AnwSEo5PI3kxqI8x1jwUCpti6kQEAPWWQgN8b7Die/1u
 KGzEnr7i
 Bh/LoMrbj6E3Uh1T5ZfhYxuYL/12XiATerXaa9hZTf46mWTTQsiRdgBWstV1nv+7pbfBNvkmiyXDmbF0a/wu9vx+zLHaa3MUaYOQsahQhcrhwWwKwlxiLcNCzail0yjfOkMDEl6Yf5kqxCmS12F0jIdgSPvDE/l4hjkg7sfqKy0rSocGWsw92I+bcZd9sTtw/CSVLN99mJ7PGMBZIxoHf4Nyh71oWp1tLiX7ZKNWhxvv/idaOGLucm20w7dOhkEOBFQwUtGsEAoDxdjwipRPyo+c92VcmaFQzEPeklmbC1mAsZINXgIPSRHozCkEqY5f8pSqlh0LC5lVI9TQNthM8PNIgRUHqiyyzMw59
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 06, 2026 at 04:01:19AM -0700, Dirty One wrote:
> Panic Report
> 
> To report this crash to Debian, run:
> 
> reportbug linux-image-6.19.14+kali-amd64

You really should be reporting this to Debian like the message says ;-)
(but see below)

> and include the following log:
> 
> [ 394.356988] iwlwifi 0000:02:00.0: PCI dev 0082/1321, rev=0xb0,
> rfid=0xd55555d5
> [ 394.356993] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
> Advanced-N 6205 AGN
> [ 394.361391] iwlwifi 0000:02:00.0: loaded firmware version 18.168.6.1
> 6000g2a-6.ucode op_mode iwldvm
> [ 394.361415] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [ 394.361417] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> [ 394.361419] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
> [ 394.361421] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
> Advanced-N 6205 AGN, REV=0xB0
> [ 394.613606] ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
> [ 394.618941] BUG: kernel NULL pointer dereference, address:
> 0000000000000008

Somebody dereferenced a NULL pointer.  Unfortunately, this log cuts off
before the important lines which would help someone understand which
part of the kernel did that.  Can you get any more information out of
your system?

> [ 394.618950] #PF: supervisor read access in kernel mode
> [ 394.618954] #PF: error_code(0x0000) - not-present page
> [ 394.618957] PGD 0 P4D 0
> [ 394.618963] Oops: Oops: 0000 [#2] SMP PTI
> [ 394.618970] CPU: 2 UID: 0 PID: 1 Comm: systemd Tainted: G D W
> 6.19.14+kali-amd64 0000001 <https://bugs.kali.org/view.php?id=1>
> PREEMPT(lazy) Kali 6.19.14-1+kali1
> [ 394.618978] Tainted: [D]=DIE, [W]=WARN
> [ 394.618981] Hardware name: Dell Inc. Latitude E6420/0K0DNP, BIOS A25
> 03/06/2018
> [ 394.618985] RIP: 0010:
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> *rb_insert_augmented+0x29/0x200 [ 394.618996] Code: 90 f3 0f 1e fa 48 89 f8
> 48 8b 3f 48 85 ff 0f 84 db 01 00 00 48 8b 0f 49 89 f1 49 89 d0 f6 c1 01 0f
> 85 c4 01 00 00 48 83 ec 20 <48> 8b 51 08 48 39 fa 74 64 48 85 d2 74 09 f6
> 02 01 0f 84 a4 00 00 [ 394.619002] RSP: 0018:ffffd318c002bb38 EFLAGS:
> 00010282 [ 394.619007] RAX: ffff8ba9b89bbc88 RBX: ffff8ba9a5dd6540 RCX:
> 0000000000000000 [ 394.619012] RDX: ffffffff9048fc90 RSI: ffff8ba98fb1d338
> RDI: ffff8ba9a596bc88 [ 394.619015] RBP: ffff8ba9bdab4600 R08:
> ffffffff9048fc90 R09: ffff8ba98fb1d338 [ 394.619019] R10: 0000000000000001
> R11: 000000000000000e R12: ffff8ba9a5a67700 [ 394.619023] R13:
> ffff8ba98fb1d380 R14: ffffd318c002bb78 R15: ffff8ba9b89bbc00 [ 394.619026]
> FS: 00007feca0ebec80(0000) GS:ffff8bab132a6000(0000) knlGS:0000000000000000
> [ 394.619031] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> 394.619035] CR2: 0000000000000008 CR3: 0000000101f98006 CR4:
> 00000000000606f0 [ 394.619039] Call Trace: [ 394.619044] <TASK> [
> 394.619050] dup_mmap+0x32d/0x750 [ 394.619058] copy_process+0x1207/0x1d00 [
> 394.619069] kernel_clone+0xbc/0x4a0 [ 394.619074] ? do_sys_gettid+0x1a/0x30
> [ 394.619081] do_sys_clone+0x65/0x90 [ 394.619088] do_syscall_64+0x81/0x5e0
> [ 394.619093] ? do_epoll_wait+0x198/0x500 [ 394.619102] ?
> count_memcg_events+0xd6/0x210 [ 394.619110] ? handle_mm_fault+0x1d6/0x2d0 [
> 394.619116] ? do_user_addr_fault+0x2b4/0x7b0 [ 394.619124] ?
> irqentry_exit+0x6e/0x570 [ 394.619131] ? exc_page_fault+0x7e/0x1a0 [
> 394.619136] entry_SYSCALL_64_after_hwframe+0x76/0x7e [ 394.619142] RIP:
> 0033:0x7feca051cc22 [ 394.619163] Code: 85 ff 74 3e 48 83 e6 f0 74 38 48 89
> 4e f8 48 83 ee 10 48 89 3e 48 89 d7 4c 89 c2 4d 89 c8 4c 8b 54 24 08 b8 38
> 00 00 00 0f 05 <48> 85 c0 7c 13 74 01 c3 31 ed 58 5f ff d0 48 89 c7 b8 3c
> 00 00 00 [ 394.619167] RSP: 002b:00007ffc302ddb18 EFLAGS: 00000206
> ORIG_RAX: 0000000000000038 [ 394.619173] RAX: ffffffffffffffda RBX:
> 0000000000000093 RCX: 00007feca051cc22 [ 394.619177] RDX: 00005586db46bf60
> RSI: 00007ffc302deff0 RDI: 0000000000000411 [ 394.619181] RBP:
> 00007ffc302e0b60 R08: 00007feca05f1ac0 R09: 00007feca05f1ac0 [ 394.619184]
> R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000000411 [
> 394.619187] R13: 000000000000000b R14: 00007feca0d94cf4 R15:
> 00007feca0d92278 [ 394.619194] </TASK> [ 394.619197] Modules linked in:
> snd_seq_dummy snd_hrtimer snd_seq snd_seq_device ccm tun qrtr squashfs loop
> sunrpc nls_ascii nls_cp437 vfat fat intel_rapl_msr intel_rapl_common
> x86_pkg_temp_thermal uvcvideo intel_powerclamp coretemp videobuf2_vmalloc
> snd_hda_codec_intelhdmi uvc snd_hda_codec_hdmi kvm_intel videobuf2_memops
> videobuf2_v4l2 videodev snd_hda_codec_idt kvm snd_hda_codec_generic
> rtl8188ee videobuf2_common snd_hda_intel mei_pxp mei_hdcp irqbypass
> snd_hda_codec mc rtl_pci iwldvm rapl intel_cstate snd_hda_core mei_wdt
> btusb rtlwifi intel_uncore btmtk snd_intel_dspcfg btrtl btbcm btintel
> snd_intel_sdw_acpi mac80211 platform_profile snd_hwdep bluetooth dell_rbtn
> iwlwifi dell_laptop snd_pcm dell_smm_hwmon ppdev cfg80211 ecdh_generic
> dell_wmi mei_me dell_smbios at24 dcdbas wmi_bmof snd_timer snd pcspkr
> libarc4 dell_wmi_descriptor mei sparse_keymap soundcore rfkill parport_pc
> joydev evdev dell_lis3lv02d sg ac parport dell_smo8800 binfmt_misc tls
> efi_pstore configfs nfnetlink efivarfs autofs4 ext4 crc16 mbcache jbd2 [
> 394.619325] crc32c_cryptoapi i915 sr_mod drm_buddy ttm cdrom sd_mod
> i2c_algo_bit drm_display_helper cec iTCO_wdt psmouse rc_core ahci
> intel_pmc_bxt sdhci_pci iTCO_vendor_support drm_client_lib watchdog libahci
> ghash_clmulni_intel sdhci_uhs2 drm_kms_helper sdhci libata ehci_pci
> serio_raw ehci_hcd aesni_intel drm cqhci usbcore mmc_core e1000e scsi_mod
> i2c_i801 button battery video i2c_smbus lpc_ich usb_common scsi_common wmi
> [ 394.619392] CR2: 0000000000000008 [ 394.619397] ---[ end trace
> 0000000000000000 ]--- [ 394.956549] RIP: 0010:*
> rb_insert_augmented+0x29/0x200
> [ 394.956563] Code: 90 f3 0f 1e fa 48 89 f8 48 8b 3f 48 85 ff 0f 84 db 01
> 00 00 48 8b 0f 49 89 f1 49 89 d0 f6 c1 01 0f 85 c4 01 00 00 48 83 ec 20
> <48> 8b 51 08 48 39 fa 74 64 48 85 d2 74 09 f6 02 01 0f 84 a4 00 00
> [ 394.956568] RSP: 0018:ffffd318cde6f728 EFLAGS: 00010286
> [ 394.956574] RAX: ffff8baa34623d48 RBX: ffff8baa34623cc0 RCX:
> 0000000000000000
> [ 394.956578] RDX: ffffffff9048fc90 RSI: ffff8ba98fb1e0a0 RDI:
> ffff8ba9a596bec8
> [ 394.956582] RBP: 00007f2f95c25000 R08: ffffffff9048fc90 R09:
> ffff8ba98fb1e0a0
> [ 394.956585] R10: ffff8ba98fb1e0a0 R11: ffff8ba9a5c2b208 R12:
> 0000000000000001
> [ 394.956588] R13: ffff8ba98fb1e0e8 R14: 0000000000000000 R15:
> ffff8ba98fb1e058
> [ 394.956592] FS: 00007feca0ebec80(0000) GS:ffff8bab132a6000(0000)
> knlGS:0000000000000000
> [ 394.956597] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 394.956600] CR2: 0000000000000008 CR3: 0000000101f98006 CR4:
> 00000000000606f0
> [ 394.956608] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000009
> [ 394.956625] Kernel Offset: 0xee00000 from 0xffffffff81000000 (relocation
> range: 0xffffffff80000000-0xffffffffbfffffff)

