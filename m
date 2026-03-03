Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97871EDEBF5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 22:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0DF6B0088; Tue,  3 Mar 2026 17:22:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078A36B0089; Tue,  3 Mar 2026 17:22:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65236B008A; Tue,  3 Mar 2026 17:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C992F6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:22:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 629CD14010D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:22:16 +0000 (UTC)
X-FDA: 84506176272.04.E488DB2
Received: from mout.web.de (mout.web.de [212.227.17.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49AD4A000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:22:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=jFS5C0li;
	spf=pass (imf15.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772576534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+6G+MQUKtYPhG3K+G866Bdqx4lJIxdjmI6q7crVXP/o=;
	b=vl9KDA6sLfQUXrBF6eereVKX/3kvSI7JGYn4oBb/OcWpY2AAAG2tg3fojxMpzHoe3hKqLa
	RaYnDi3bziOS3u18izYuZ5Tv23aGHXZzduZhvVMdvmPFqrZAMRkxcHTorPqMPyjuiFY9a7
	cCf+Zst+hu/3hs0UM+MTwQhCDEAEerY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=jFS5C0li;
	spf=pass (imf15.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772576534; a=rsa-sha256;
	cv=none;
	b=BwYahdSCjFzKw+IIt7ifMJLmEtv5DvlVepwm+9avrPRtEPb1x6P9BfgYm3nS9n4NOBFVfZ
	V+5Sm0oKDTzrsmREJDJXVmP9A6NDD0Tl9WZY+JguHI6E3t+aZY92wocw3qSfVH+/6oso1e
	UW1SfssJNSvEvTCCj69kCWZR70KbbBU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1772576491; x=1773181291; i=spasswolf@web.de;
	bh=+6G+MQUKtYPhG3K+G866Bdqx4lJIxdjmI6q7crVXP/o=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=jFS5C0liZdPbFJ0lbD21twxBJLZa0k4ydilP0o1S7FZm0KeilBHSdwkDHH8kVgT3
	 n+tvfs5hAzB+53r9pGVac2U9k9gi1RDsfvtdbmjK8KIKUl2oosXoV2bVzHiKHxFlF
	 Gp5jiybrUljHzdKrGTBnK7rQUkfFAhPyKLyFr9E4nxd5cERWuRQ8JiycwvxrK+V7P
	 QfGu2Q5/POh0Ygg4I8IgraOOWPRooHSXwJiUixrOzXHE4WFy5dilU9/m5rImbgCPI
	 pgePXnBYm4AsMDLTsxefaMQbCmSDrWArYOJ4Udhtet/DwIeTsAX9QxF6Hkf8FGaoF
	 bKlHrdc7kXbqRgY0Xw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N79N8-1vcisJ0A7Y-013Ih3; Tue, 03
 Mar 2026 23:21:31 +0100
From: Bert Karwatzki <spasswolf@web.de>
To: linux-kernel@vger.kernel.org
Cc: Bert Karwatzki <spasswolf@web.de>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: rtmutex deadlock and memory corruption when running gcc testsuite in next-20260303
Date: Tue,  3 Mar 2026 23:21:25 +0100
Message-ID: <20260303222127.2992-1-spasswolf@web.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ypZhqN/WJdII7+eQSbYGcbASPHu+OtVpFTDE2irGwI/sHC/Qksu
 cA4ix2BbUJv90yYBaPN7H5kVhDJyW9ZmCyHv+kxJKDgmlsWwxO3Gs2bf1CUeRN9n6Gi5X2R
 MaX1YNwRuQB9czwfohwnuHrGoMrRCb19094pI3yG5l6Ftoyoy0wf/qvHhIzxS3YhnV+/CbE
 TQ5+8YrFEBtJmz7uASsHw==
UI-OutboundReport: notjunk:1;M01:P0:DJnxGkG41KM=;TQ9vb6YIRWVW7oHos0cfzk9cDWk
 +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
X-Rspamd-Queue-Id: 49AD4A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 9oopzonzdqn9uemmtp3id61orgebpgr7
X-Rspam-User: 
X-HE-Tag: 1772576534-118241
X-HE-Meta: U2FsdGVkX1/3ynpnDDU837lFmMQ5bgW2QWr7iRO96jFDojD5O111+GKzuog3++thwcra4anZ6DaVoXorgTGGBsoV5ri6ZKXaad+R1mm3BFfqKmJ+8/GTqa6q9TZpXBBW4Wrw6ISab+ZP1y6rzkSFe8TSh0lAJZDDCEMMj1iBTsJPAV2I+2GsJyERa9Muk+OqhOGXiHNzY1naBsQpZrYzRB8TpzwyzabFjqua3G5ZcwZwWd1koTmKwX2uMa48AF7WYDtSr7+y91KloJnNLMjBvebTbI9FBL172GBsk/4sr5j7NHhMoLk8i/9wfBgQ0yqUr+u1spl1MTNDjZuOhv3OJb0VnHeI/q8gNomIOniNJBbmg0DFCc/MuMxxyPCdkDQAzBM8VjgeZYXXpoWYmF4x9wW6xG160lX6V4xi1nQlEL2ViMqd5S1U59mZ+PrUMqeXIxtIDqEdeVGJ1YmEgybqtAUgpNVHIG4dJUDDwBhgGoPMWdIYXzN25CWrLW2cYBX8shlzFvD+AdeZ335wf1Z/oNkPLMM9wyt51EDKeCJW+cIBUudTZSpDGbi4RsqFXMKamIZDvro8vOs8HJS0D75YkxiMERE7WSmQU/hA6n2g070nSL4JbXwrYD3lOYARR7G9XEpQyraKYBldaoT9bg4pLWbwH8TEiJu2DtFw2AwnaV/zsuU0kl6e017xICN/4irLH6o1oULuNzPxLJr3ByvoQmn+vrpllqHw+ZX0Mxbh+wcIAjQitQoj8yl+vQjNQLd6je6zTVHyjIHTIay5C/i27SqvhbjyoztMMdXsRH0Q/OexTJCyRQY61oYheA0e8cUMkvrdHxC0n+1Niag/YveO0BMCNzcmaTW0QnCfSK5T14s7I5/H1j7uuQLehF7MbnkWA6AQN658Df58XYAVjis9wHlzloVTCcsNR5yBmklAZ+Fz6lGzK0Ncjzjy/WbcRXgS4GXQaHhpqeIF/AbCFIG
 xJUZYTQ8
 T5uuU9K09izz1b5c+6wrWPVlh5KPZP1L2v79/L4TBKsFgXR09l5LYM07JQTK2UPNm/r07I3BUkG8pf/HlXmR/hNJRiqxrE7CXaImNDH8Y2+Qs/d/+iES6ZMvay+QNy4FCxmGxERoLEIqsr/41rXqnr9gQt6pNVFxwjD+JdTaCcZmEFvk+P28qClS9ddo4jYOu67hj2+GE7oNW9TGy1ZkF4Iy6W0hpdSQUUjj6OKes31ix3Pc8wPdld5+4QMzz1Gd8o5TiVdfckCXD+CM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I tried building gcc-14 from the debian repositories (fetched via apt-get=20
source gcc-14) on my new and shiny zen5 machine (Cpu: "AMD Ryzen 9 9950X=20
16-Core Processor) running debian stable/trixie and linux-next-20260303=20
(PREEMPT_RT=3Dy) with the following command:

$ time dpkg-buildpackage --no-sign -B -nc

after about ~1.45h, during the testsuite, the following error happens:

[ 6506.666031] [T3176177] Oops: general protection fault, maybe for address=
 0x7ffe00b6ff00: 0000 [#1] SMP NOPTI
[ 6506.666036] [T3176177] CPU: 29 UID: 1000 PID: 3176177 Comm: sh Not taint=
ed 7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6506.666039] [T3176177] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6506.666040] [T3176177] RIP: 0010:memset+0xf/0x20
[ 6506.666046] [T3176177] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6506.666048] [T3176177] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6506.666050] [T3176177] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6506.666050] [T3176177] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6506.666051] [T3176177] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6506.666052] [T3176177] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6506.666052] [T3176177] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6506.666053] [T3176177] FS:  0000000000000000(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6506.666054] [T3176177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6506.666055] [T3176177] CR2: 00007ff936904dd0 CR3: 00000001bee4f000 CR4: =
0000000000f50ef0
[ 6506.666055] [T3176177] PKRU: 55555554
[ 6506.666056] [T3176177] Call Trace:
[ 6506.666058] [T3176177]  <TASK>
[ 6506.666059] [T3176177]  mas_wr_node_store+0x9a/0x3f0
[ 6506.666063] [T3176177]  ? rt_spin_lock+0x38/0x110
[ 6506.666065] [T3176177]  ? rt_mutex_slowunlock+0x74/0x290
[ 6506.666066] [T3176177]  ? __pcs_replace_empty_main+0x2cf/0x410
[ 6506.666070] [T3176177]  ? kmem_cache_alloc_noprof+0xd4/0x330
[ 6506.666072] [T3176177]  mas_store_prealloc+0x19d/0x3d0
[ 6506.666074] [T3176177]  __mmap_region+0x928/0xf80
[ 6506.666082] [T3176177]  do_mmap+0x478/0x660
[ 6506.666084] [T3176177]  vm_mmap_pgoff+0x104/0x190
[ 6506.666087] [T3176177]  elf_load+0xa3/0x230
[ 6506.666089] [T3176177]  load_elf_binary+0xb80/0x1880
[ 6506.666091] [T3176177]  ? __kernel_read+0x1a1/0x2a0
[ 6506.666093] [T3176177]  ? rt_read_lock+0x40/0x130
[ 6506.666094] [T3176177]  bprm_execve+0x27c/0x4a0
[ 6506.666096] [T3176177]  do_execveat_common.isra.0+0x157/0x170
[ 6506.666098] [T3176177]  __x64_sys_execve+0x38/0x50
[ 6506.666099] [T3176177]  do_syscall_64+0x11b/0x8c0
[ 6506.666101] [T3176177]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6506.666103] [T3176177] RIP: 0033:0x7fc90e432dd7
[ 6506.666106] [T3176177] Code: Unable to access opcode bytes at 0x7fc90e43=
2dad.
[ 6506.666107] [T3176177] RSP: 002b:00007fc90e772e68 EFLAGS: 00000202 ORIG_=
RAX: 000000000000003b
[ 6506.666108] [T3176177] RAX: ffffffffffffffda RBX: 00007ffec5e8ad00 RCX: =
00007fc90e432dd7
[ 6506.666109] [T3176177] RDX: 000055966c9f03c0 RSI: 00007ffec5e8ab30 RDI: =
00007fc90e4fbea4
[ 6506.666109] [T3176177] RBP: 00007fc90e772ff0 R08: 0000000000000000 R09: =
0000000000000000
[ 6506.666110] [T3176177] R10: 0000000000000008 R11: 0000000000000202 R12: =
00007ffec5e8a8b0
[ 6506.666111] [T3176177] R13: 0000000000000040 R14: 0000000000000001 R15: =
00007fc90e772f20
[ 6506.666112] [T3176177]  </TASK>
[ 6506.666112] [T3176177] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6506.666150] [T3176177]  gpio_generic
[ 6506.666153] [T3176177] ---[ end trace 0000000000000000 ]---
[ 6506.745203] [T3176178] Oops: general protection fault, maybe for address=
 0xffff9264a17f9200: 0000 [#2] SMP NOPTI
[ 6506.745208] [T3176178] CPU: 29 UID: 1000 PID: 3176178 Comm: xg++ Tainted=
: G      D             7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6506.745210] [T3176178] Tainted: [D]=3DDIE
[ 6506.745211] [T3176178] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6506.745212] [T3176178] RIP: 0010:memset+0xf/0x20
[ 6506.745218] [T3176178] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6506.745219] [T3176178] RSP: 0018:ffffb18ba6ff3998 EFLAGS: 00010246
[ 6506.745221] [T3176178] RAX: ffff9264a17f9200 RBX: ffffb18ba6ff3a38 RCX: =
0000000000000100
[ 6506.745222] [T3176178] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
692f7273752f2068
[ 6506.745223] [T3176178] RBP: ffff9268062a6a80 R08: 0000000000000001 R09: =
692f7273752f2068
[ 6506.745223] [T3176178] R10: 0000000000000002 R11: 0000000000000006 R12: =
0000000000000000
[ 6506.745224] [T3176178] R13: ffffb18ba6ff3a38 R14: 0000000000118173 R15: =
ffff9264a17f9430
[ 6506.745225] [T3176178] FS:  00007ff936825bc0(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6506.745225] [T3176178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6506.745226] [T3176178] CR2: 00007fc90e432dad CR3: 0000000148959000 CR4: =
0000000000f50ef0
[ 6506.745227] [T3176178] PKRU: 55555554
[ 6506.745228] [T3176178] Call Trace:
[ 6506.745230] [T3176178]  <TASK>
[ 6506.745230] [T3176178]  mas_root_expand+0x35/0x160
[ 6506.745235] [T3176178]  mas_store_prealloc+0x19d/0x3d0
[ 6506.745237] [T3176178]  vma_link+0x11a/0x180
[ 6506.745241] [T3176178]  insert_vm_struct+0x41/0xa0
[ 6506.745243] [T3176178]  create_init_stack_vma+0xbb/0x1c0
[ 6506.745245] [T3176178]  alloc_bprm+0x134/0x200
[ 6506.745247] [T3176178]  do_execveat_common.isra.0+0x79/0x170
[ 6506.745249] [T3176178]  __x64_sys_execve+0x38/0x50
[ 6506.745250] [T3176178]  do_syscall_64+0x11b/0x8c0
[ 6506.745252] [T3176178]  ? rt_spin_unlock+0x5a/0xa0
[ 6506.745253] [T3176178]  ? __x64_sys_rt_sigprocmask+0xc9/0x140
[ 6506.745256] [T3176178]  ? do_syscall_64+0x11b/0x8c0
[ 6506.745257] [T3176178]  ? rt_spin_lock+0x38/0x110
[ 6506.745258] [T3176178]  ? set_pte_range+0xb5/0x300
[ 6506.745261] [T3176178]  ? next_uptodate_folio+0x82/0x290
[ 6506.745263] [T3176178]  ? rt_spin_unlock+0x5a/0xa0
[ 6506.745264] [T3176178]  ? filemap_map_pages+0x597/0x660
[ 6506.745266] [T3176178]  ? do_fault+0x37e/0x640
[ 6506.745268] [T3176178]  ? __handle_mm_fault+0x2c6/0x3a0
[ 6506.745269] [T3176178]  ? count_memcg_events+0x5e/0xf0
[ 6506.745272] [T3176178]  ? handle_mm_fault+0x1b9/0x2c0
[ 6506.745273] [T3176178]  ? do_user_addr_fault+0x203/0x640
[ 6506.745275] [T3176178]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6506.745278] [T3176178] RIP: 0033:0x7ff936904dd7
[ 6506.745280] [T3176178] Code: af e8 ed ed 03 00 66 2e 0f 1f 84 00 00 00 0=
0 00 0f 1f 00 48 8b 05 f1 81 10 00 48 8b 10 e9 01 00 00 00 90 b8 3b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 80 10 00 f7 d8 64 89 01 48
[ 6506.745280] [T3176178] RSP: 002b:00007ff936a43e68 EFLAGS: 00000246 ORIG_=
RAX: 000000000000003b
[ 6506.745282] [T3176178] RAX: ffffffffffffffda RBX: 00007ffd9b54cc70 RCX: =
00007ff936904dd7
[ 6506.745282] [T3176178] RDX: 0000000017701150 RSI: 0000000017703fe8 RDI: =
00000000176fd290
[ 6506.745283] [T3176178] RBP: 00007ff936a43ff0 R08: 00007ffd9b54c9d0 R09: =
0000000000000000
[ 6506.745283] [T3176178] R10: 0000000000000008 R11: 0000000000000246 R12: =
00007ffd9b54c9d0
[ 6506.745284] [T3176178] R13: 0000000000000040 R14: 0000000000000001 R15: =
00007ff936a43f20
[ 6506.745285] [T3176178]  </TASK>
[ 6506.745285] [T3176178] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6506.745321] [T3176178]  gpio_generic
[ 6506.745324] [T3176178] ---[ end trace 0000000000000000 ]---
[ 6506.745857] [T3176177] RIP: 0010:memset+0xf/0x20
[ 6506.745862] [T3176177] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6506.745863] [T3176177] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6506.745865] [T3176177] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6506.745866] [T3176177] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6506.745866] [T3176177] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6506.745867] [T3176177] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6506.745867] [T3176177] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6506.745868] [T3176177] FS:  0000000000000000(0000) GS:ffff9273933e1000(0=
000) knlGS:0000000000000000
[ 6506.745869] [T3176177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6506.745870] [T3176177] CR2: 00007fc75f94f0f0 CR3: 00000001bee4f000 CR4: =
0000000000f50ef0
[ 6506.745870] [T3176177] PKRU: 55555554
[ 6506.745873] [T3176177] ------------[ cut here ]------------
[ 6506.745874] [T3176177] rtmutex deadlock detected
[ 6506.745874] [T3176177] WARNING: kernel/locking/rtmutex.c:1674 at __rt_mu=
tex_slowlock_locked.constprop.0+0x835/0x9b0, CPU#12: sh/3176177
[ 6506.745878] [T3176177] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6506.745900] [T3176177]  gpio_generic
[ 6506.745902] [T3176177] CPU: 12 UID: 1000 PID: 3176177 Comm: sh Tainted: =
G      D             7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6506.745904] [T3176177] Tainted: [D]=3DDIE
[ 6506.745905] [T3176177] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6506.745906] [T3176177] RIP: 0010:__rt_mutex_slowlock_locked.constprop.0+=
0x835/0x9b0
[ 6506.745907] [T3176177] Code: 00 48 89 ef e8 fc 67 87 00 c7 44 24 14 fc f=
f ff ff 41 83 ff dd 0f 85 87 fd ff ff 48 89 ef e8 b2 66 87 00 48 8d 3d 2b 5=
8 f2 00 <67> 48 0f b9 3a bd 01 00 00 00 89 e8 87 43 18 e8 e7 6a fd ff eb f4
[ 6506.745908] [T3176177] RSP: 0018:ffffb18ba9963d18 EFLAGS: 00010286
[ 6506.745910] [T3176177] RAX: 0000000000000000 RBX: ffff926654c10000 RCX: =
ffff926654c10001
[ 6506.745910] [T3176177] RDX: 0000000000000001 RSI: ffff926654c10000 RDI: =
ffffffffa9e36620
[ 6506.745911] [T3176177] RBP: ffff9267bad04bb8 R08: 0000000000000000 R09: =
ffff92737dcf6f90
[ 6506.745911] [T3176177] R10: ffff92737dd26fe8 R11: 0000000000000003 R12: =
ffffb18ba9963d40
[ 6506.745912] [T3176177] R13: ffff926654c10001 R14: ffff926654c10c40 R15: =
00000000ffffffdd
[ 6506.745913] [T3176177] FS:  0000000000000000(0000) GS:ffff9273933e1000(0=
000) knlGS:0000000000000000
[ 6506.745913] [T3176177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6506.745914] [T3176177] CR2: 00007fc75f94f0f0 CR3: 00000001bee4f000 CR4: =
0000000000f50ef0
[ 6506.745915] [T3176177] PKRU: 55555554
[ 6506.745915] [T3176177] Call Trace:
[ 6506.745917] [T3176177]  <TASK>
[ 6506.745919] [T3176177]  ? load_elf_binary+0xb80/0x1880
[ 6506.745922] [T3176177]  ? __kernel_read+0x1a1/0x2a0
[ 6506.745924] [T3176177]  __rwbase_read_lock+0x4a/0xd0
[ 6506.745927] [T3176177]  acct_collect+0x157/0x1c0
[ 6506.745931] [T3176177]  do_exit+0x1c2/0xa30
[ 6506.745933] [T3176177]  make_task_dead+0x94/0xa0
[ 6506.745934] [T3176177]  rewind_stack_and_make_dead+0x16/0x20
[ 6506.745937] [T3176177] RIP: 0033:0x7fc90e432dd7
[ 6506.745941] [T3176177] Code: Unable to access opcode bytes at 0x7fc90e43=
2dad.
[ 6506.745942] [T3176177] RSP: 002b:00007fc90e772e68 EFLAGS: 00000202 ORIG_=
RAX: 000000000000003b
[ 6506.745943] [T3176177] RAX: ffffffffffffffda RBX: 00007ffec5e8ad00 RCX: =
00007fc90e432dd7
[ 6506.745944] [T3176177] RDX: 000055966c9f03c0 RSI: 00007ffec5e8ab30 RDI: =
00007fc90e4fbea4
[ 6506.745944] [T3176177] RBP: 00007fc90e772ff0 R08: 0000000000000000 R09: =
0000000000000000
[ 6506.745945] [T3176177] R10: 0000000000000008 R11: 0000000000000202 R12: =
00007ffec5e8a8b0
[ 6506.745945] [T3176177] R13: 0000000000000040 R14: 0000000000000001 R15: =
00007fc90e772f20
[ 6506.745947] [T3176177]  </TASK>
[ 6506.745948] [T3176177] ---[ end trace 0000000000000000 ]---
[ 6507.131426] [T3176178] RIP: 0010:memset+0xf/0x20
[ 6507.131432] [T3176178] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.131434] [T3176178] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6507.131435] [T3176178] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6507.131436] [T3176178] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6507.131437] [T3176178] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6507.131438] [T3176178] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6507.131438] [T3176178] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6507.131439] [T3176178] FS:  00007ff936825bc0(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.131440] [T3176178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.131440] [T3176178] CR2: 00007fc90e432dad CR3: 0000000148959000 CR4: =
0000000000f50ef0
[ 6507.131441] [T3176178] PKRU: 55555554
[ 6507.245062] [T3176633] Oops: general protection fault, maybe for address=
 0xffff9264a17fca00: 0000 [#3] SMP NOPTI
[ 6507.245068] [T3176633] CPU: 29 UID: 1000 PID: 3176633 Comm: expect Taint=
ed: G      D W           7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6507.245071] [T3176633] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.245072] [T3176633] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.245072] [T3176633] RIP: 0010:memset+0xf/0x20
[ 6507.245079] [T3176633] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.245080] [T3176633] RSP: 0018:ffffb18ba3babc78 EFLAGS: 00010246
[ 6507.245082] [T3176633] RAX: ffff9264a17fca00 RBX: ffffb18ba3babd18 RCX: =
0000000000000100
[ 6507.245083] [T3176633] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
2e7367616c667469
[ 6507.245083] [T3176633] RBP: ffff92643593a180 R08: 0000000000000000 R09: =
2e7367616c667469
[ 6507.245084] [T3176633] R10: 0000000000000002 R11: ffffffffa98728dc R12: =
0000000000000000
[ 6507.245084] [T3176633] R13: ffffb18ba3babd18 R14: 0000000000118173 R15: =
ffff9264a17fcbb0
[ 6507.245085] [T3176633] FS:  00007fa2b4453780(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.245086] [T3176633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.245087] [T3176633] CR2: 00007faa5bfb7000 CR3: 00000002bbfbd000 CR4: =
0000000000f50ef0
[ 6507.245088] [T3176633] PKRU: 55555554
[ 6507.245088] [T3176633] Call Trace:
[ 6507.245091] [T3176633]  <TASK>
[ 6507.245091] [T3176633]  mas_root_expand+0x35/0x160
[ 6507.245096] [T3176633]  mas_store_prealloc+0x19d/0x3d0
[ 6507.245098] [T3176633]  vma_link+0x11a/0x180
[ 6507.245103] [T3176633]  insert_vm_struct+0x41/0xa0
[ 6507.245104] [T3176633]  create_init_stack_vma+0xbb/0x1c0
[ 6507.245106] [T3176633]  alloc_bprm+0x134/0x200
[ 6507.245109] [T3176633]  do_execveat_common.isra.0+0x79/0x170
[ 6507.245110] [T3176633]  __x64_sys_execve+0x38/0x50
[ 6507.245112] [T3176633]  do_syscall_64+0x11b/0x8c0
[ 6507.245113] [T3176633]  ? do_syscall_64+0x11b/0x8c0
[ 6507.245114] [T3176633]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.245116] [T3176633]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6507.245118] [T3176633] RIP: 0033:0x7fa2b4645dd7
[ 6507.245120] [T3176633] Code: af e8 ed ed 03 00 66 2e 0f 1f 84 00 00 00 0=
0 00 0f 1f 00 48 8b 05 f1 81 10 00 48 8b 10 e9 01 00 00 00 90 b8 3b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 80 10 00 f7 d8 64 89 01 48
[ 6507.245121] [T3176633] RSP: 002b:00007ffdcd40ee68 EFLAGS: 00000202 ORIG_=
RAX: 000000000000003b
[ 6507.245123] [T3176633] RAX: ffffffffffffffda RBX: 000055c674bb61f0 RCX: =
00007fa2b4645dd7
[ 6507.245123] [T3176633] RDX: 000055c6751f5840 RSI: 000055c674bb62c0 RDI: =
00007ffdcd40ee70
[ 6507.245124] [T3176633] RBP: 00007ffdcd40ef70 R08: 00007ffdcd413dac R09: =
0000000000000000
[ 6507.245124] [T3176633] R10: 0000000000000008 R11: 0000000000000202 R12: =
000055c674bb62c0
[ 6507.245125] [T3176633] R13: 000055c6751f5840 R14: 0000000000000001 R15: =
00007ffdcd413da4
[ 6507.245126] [T3176633]  </TASK>
[ 6507.245127] [T3176633] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.245167] [T3176633]  gpio_generic
[ 6507.245170] [T3176633] ---[ end trace 0000000000000000 ]---
[ 6507.320427] [T3176633] RIP: 0010:memset+0xf/0x20
[ 6507.320436] [T3176633] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.320437] [T3176633] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6507.320439] [T3176633] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6507.320440] [T3176633] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6507.320441] [T3176633] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6507.320442] [T3176633] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6507.320443] [T3176633] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6507.320443] [T3176633] FS:  00007fa2b4453780(0000) GS:ffff9273937a1000(0=
000) knlGS:0000000000000000
[ 6507.320445] [T3176633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.320445] [T3176633] CR2: 00005598e5df92c8 CR3: 00000002bbfbd000 CR4: =
0000000000f50ef0
[ 6507.320446] [T3176633] PKRU: 55555554
[ 6507.322085] [T3176693] Oops: general protection fault, maybe for address=
 0xffff926418e28000: 0000 [#4] SMP NOPTI
[ 6507.322090] [T3176693] CPU: 29 UID: 1000 PID: 3176693 Comm: xgcc Tainted=
: G      D W           7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6507.322093] [T3176693] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.322094] [T3176693] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.322095] [T3176693] RIP: 0010:memset+0xf/0x20
[ 6507.322100] [T3176693] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.322101] [T3176693] RSP: 0018:ffffb18bb46f7928 EFLAGS: 00010246
[ 6507.322103] [T3176693] RAX: ffff926418e28000 RBX: ffffb18bb46f79c8 RCX: =
0000000000000100
[ 6507.322103] [T3176693] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
61772f737469622f
[ 6507.322104] [T3176693] RBP: ffff926913d315c0 R08: 0000000000000000 R09: =
61772f737469622f
[ 6507.322105] [T3176693] R10: 0000000000000002 R11: ffffffffa98728dc R12: =
0000000000000000
[ 6507.322105] [T3176693] R13: ffffb18bb46f79c8 R14: 0000000000118173 R15: =
ffff926418e281b0
[ 6507.322106] [T3176693] FS:  00007fcc03058780(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.322107] [T3176693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.322107] [T3176693] CR2: 00007fcc03275ff8 CR3: 0000000173f28000 CR4: =
0000000000f50ef0
[ 6507.322108] [T3176693] PKRU: 55555554
[ 6507.322108] [T3176693] Call Trace:
[ 6507.322110] [T3176693]  <TASK>
[ 6507.322111] [T3176693]  mas_root_expand+0x35/0x160
[ 6507.322116] [T3176693]  mas_store_prealloc+0x19d/0x3d0
[ 6507.322118] [T3176693]  vma_link+0x11a/0x180
[ 6507.322123] [T3176693]  insert_vm_struct+0x41/0xa0
[ 6507.322124] [T3176693]  create_init_stack_vma+0xbb/0x1c0
[ 6507.322126] [T3176693]  alloc_bprm+0x134/0x200
[ 6507.322128] [T3176693]  do_execveat_common.isra.0+0x79/0x170
[ 6507.322130] [T3176693]  __x64_sys_execve+0x38/0x50
[ 6507.322131] [T3176693]  do_syscall_64+0x11b/0x8c0
[ 6507.322133] [T3176693]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.322135] [T3176693]  ? get_page_from_freelist+0x13cc/0x1560
[ 6507.322137] [T3176693]  ? __x64_sys_rt_sigprocmask+0xde/0x140
[ 6507.322139] [T3176693]  ? do_syscall_64+0x11b/0x8c0
[ 6507.322140] [T3176693]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.322141] [T3176693]  ? try_charge_memcg+0x139/0x6d0
[ 6507.322143] [T3176693]  ? rt_spin_lock+0x38/0x110
[ 6507.322144] [T3176693]  ? rt_spin_lock+0x38/0x110
[ 6507.322144] [T3176693]  ? rt_spin_lock+0x38/0x110
[ 6507.322145] [T3176693]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.322146] [T3176693]  ? __x64_sys_rt_sigprocmask+0xc9/0x140
[ 6507.322147] [T3176693]  ? do_syscall_64+0x11b/0x8c0
[ 6507.322147] [T3176693]  ? __handle_mm_fault+0x357/0x3a0
[ 6507.322150] [T3176693]  ? count_memcg_events+0x5e/0xf0
[ 6507.322152] [T3176693]  ? handle_mm_fault+0x1b9/0x2c0
[ 6507.322154] [T3176693]  ? do_user_addr_fault+0x203/0x640
[ 6507.322156] [T3176693]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6507.322158] [T3176693] RIP: 0033:0x7fcc03138dd7
[ 6507.322160] [T3176693] Code: af e8 ed ed 03 00 66 2e 0f 1f 84 00 00 00 0=
0 00 0f 1f 00 48 8b 05 f1 81 10 00 48 8b 10 e9 01 00 00 00 90 b8 3b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 80 10 00 f7 d8 64 89 01 48
[ 6507.322161] [T3176693] RSP: 002b:00007fcc03275e68 EFLAGS: 00000246 ORIG_=
RAX: 000000000000003b
[ 6507.322162] [T3176693] RAX: ffffffffffffffda RBX: 00007ffec83675f0 RCX: =
00007fcc03138dd7
[ 6507.322163] [T3176693] RDX: 00007ffec8367b80 RSI: 0000000001850f58 RDI: =
000000000184d0d0
[ 6507.322163] [T3176693] RBP: 00007fcc03275ff0 R08: 00007ffec8367350 R09: =
0000000000000000
[ 6507.322164] [T3176693] R10: 0000000000000008 R11: 0000000000000246 R12: =
00007ffec8367350
[ 6507.322164] [T3176693] R13: 0000000000000040 R14: 0000000000000001 R15: =
00007fcc03275f20
[ 6507.322165] [T3176693]  </TASK>
[ 6507.322166] [T3176693] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.322203] [T3176693]  gpio_generic
[ 6507.322206] [T3176693] ---[ end trace 0000000000000000 ]---
[ 6507.396864] [T3176693] RIP: 0010:memset+0xf/0x20
[ 6507.396871] [T3176693] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.396872] [T3176693] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6507.396874] [T3176693] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6507.396875] [T3176693] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6507.396876] [T3176693] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6507.396876] [T3176693] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6507.396877] [T3176693] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6507.396877] [T3176693] FS:  00007fcc03058780(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.396878] [T3176693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.396879] [T3176693] CR2: 00007f5e14032318 CR3: 0000000173f28000 CR4: =
0000000000f50ef0
[ 6507.396879] [T3176693] PKRU: 55555554
[ 6507.397201] [T3176752] Oops: general protection fault, maybe for address=
 0xffff926654e0b700: 0000 [#5] SMP NOPTI
[ 6507.397205] [T3176752] CPU: 29 UID: 1000 PID: 3176752 Comm: expect Taint=
ed: G      D W           7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6507.397208] [T3176752] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.397209] [T3176752] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.397210] [T3176752] RIP: 0010:memset+0xf/0x20
[ 6507.397213] [T3176752] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.397214] [T3176752] RSP: 0018:ffffb18ba76ffc98 EFLAGS: 00010246
[ 6507.397216] [T3176752] RAX: ffff926654e0b700 RBX: ffffb18ba76ffd38 RCX: =
0000000000000100
[ 6507.397217] [T3176752] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
6564756c636e692f
[ 6507.397217] [T3176752] RBP: ffff926784582f00 R08: 0000000000000000 R09: =
6564756c636e692f
[ 6507.397218] [T3176752] R10: 0000000000000002 R11: ffffffffa98728dc R12: =
0000000000000000
[ 6507.397219] [T3176752] R13: ffffb18ba76ffd38 R14: 0000000000118173 R15: =
ffff926654e0b930
[ 6507.397219] [T3176752] FS:  00007fa2b4453780(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.397220] [T3176752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.397221] [T3176752] CR2: 00007fa2b4985ff8 CR3: 0000000316fa7000 CR4: =
0000000000f50ef0
[ 6507.397221] [T3176752] PKRU: 55555554
[ 6507.397222] [T3176752] Call Trace:
[ 6507.397224] [T3176752]  <TASK>
[ 6507.397224] [T3176752]  mas_root_expand+0x35/0x160
[ 6507.397229] [T3176752]  mas_store_prealloc+0x19d/0x3d0
[ 6507.397232] [T3176752]  vma_link+0x11a/0x180
[ 6507.397236] [T3176752]  insert_vm_struct+0x41/0xa0
[ 6507.397238] [T3176752]  create_init_stack_vma+0xbb/0x1c0
[ 6507.397239] [T3176752]  alloc_bprm+0x134/0x200
[ 6507.397242] [T3176752]  do_execveat_common.isra.0+0x79/0x170
[ 6507.397244] [T3176752]  __x64_sys_execve+0x38/0x50
[ 6507.397245] [T3176752]  do_syscall_64+0x11b/0x8c0
[ 6507.397247] [T3176752]  ? do_user_addr_fault+0x203/0x640
[ 6507.397250] [T3176752]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6507.397252] [T3176752] RIP: 0033:0x7fa2b4645dd7
[ 6507.397254] [T3176752] Code: af e8 ed ed 03 00 66 2e 0f 1f 84 00 00 00 0=
0 00 0f 1f 00 48 8b 05 f1 81 10 00 48 8b 10 e9 01 00 00 00 90 b8 3b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 80 10 00 f7 d8 64 89 01 48
[ 6507.397255] [T3176752] RSP: 002b:00007fa2b4985e68 EFLAGS: 00000202 ORIG_=
RAX: 000000000000003b
[ 6507.397257] [T3176752] RAX: ffffffffffffffda RBX: 00007ffdcd40c720 RCX: =
00007fa2b4645dd7
[ 6507.397257] [T3176752] RDX: 000055c6751f5840 RSI: 00007ffdcd40c550 RDI: =
00007fa2b470eea4
[ 6507.397258] [T3176752] RBP: 00007fa2b4985ff0 R08: 0000000000000000 R09: =
0000000000000000
[ 6507.397259] [T3176752] R10: 0000000000000008 R11: 0000000000000202 R12: =
00007ffdcd40c2d0
[ 6507.397259] [T3176752] R13: 0000000000000040 R14: 0000000000000001 R15: =
00007fa2b4985f20
[ 6507.397261] [T3176752]  </TASK>
[ 6507.397261] [T3176752] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.397304] [T3176752]  gpio_generic
[ 6507.397307] [T3176752] ---[ end trace 0000000000000000 ]---
[ 6507.457878] [T3176752] pstore: backend (efi_pstore) writing error (-28)
[ 6507.457881] [T3176752] RIP: 0010:memset+0xf/0x20
[ 6507.457887] [T3176752] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.457888] [T3176752] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6507.457890] [T3176752] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6507.457890] [T3176752] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6507.457891] [T3176752] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6507.457892] [T3176752] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6507.457892] [T3176752] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6507.457893] [T3176752] FS:  00007fa2b4453780(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.457893] [T3176752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.457894] [T3176752] CR2: 00007fd06dbb26e0 CR3: 0000000316fa7000 CR4: =
0000000000f50ef0
[ 6507.457895] [T3176752] PKRU: 55555554
[ 6507.458130] [T3176799] Oops: general protection fault, maybe for address=
 0xffff926500be9200: 0000 [#6] SMP NOPTI
[ 6507.458134] [T3176799] CPU: 29 UID: 1000 PID: 3176799 Comm: xg++ Tainted=
: G      D W           7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6507.458136] [T3176799] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.458137] [T3176799] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.458138] [T3176799] RIP: 0010:memset+0xf/0x20
[ 6507.458140] [T3176799] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.458141] [T3176799] RSP: 0018:ffffb18bb7fbbc18 EFLAGS: 00010246
[ 6507.458142] [T3176799] RAX: ffff926500be9200 RBX: ffffb18bb7fbbcb8 RCX: =
0000000000000100
[ 6507.458143] [T3176799] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
7273752f200a5c20
[ 6507.458143] [T3176799] RBP: ffff92640fe5bb00 R08: 0000000000000000 R09: =
7273752f200a5c20
[ 6507.458144] [T3176799] R10: 0000000000000002 R11: ffffffffa98728dc R12: =
0000000000000000
[ 6507.458144] [T3176799] R13: ffffb18bb7fbbcb8 R14: 0000000000118173 R15: =
ffff926500be9430
[ 6507.458144] [T3176799] FS:  00007f518bce7c80(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.458145] [T3176799] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.458146] [T3176799] CR2: 00007fd0702d7db8 CR3: 000000016ac67000 CR4: =
0000000000f50ef0
[ 6507.458146] [T3176799] PKRU: 55555554
[ 6507.458146] [T3176799] Call Trace:
[ 6507.458148] [T3176799]  <TASK>
[ 6507.458149] [T3176799]  mas_root_expand+0x35/0x160
[ 6507.458153] [T3176799]  mas_store_prealloc+0x19d/0x3d0
[ 6507.458155] [T3176799]  vma_link+0x11a/0x180
[ 6507.458158] [T3176799]  insert_vm_struct+0x41/0xa0
[ 6507.458160] [T3176799]  create_init_stack_vma+0xbb/0x1c0
[ 6507.458161] [T3176799]  alloc_bprm+0x134/0x200
[ 6507.458163] [T3176799]  do_execveat_common.isra.0+0x79/0x170
[ 6507.458165] [T3176799]  __x64_sys_execve+0x38/0x50
[ 6507.458166] [T3176799]  do_syscall_64+0x11b/0x8c0
[ 6507.458167] [T3176799]  ? count_memcg_events+0x5e/0xf0
[ 6507.458169] [T3176799]  ? handle_mm_fault+0x1b9/0x2c0
[ 6507.458172] [T3176799]  ? do_user_addr_fault+0x203/0x640
[ 6507.458174] [T3176799]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6507.458177] [T3176799] RIP: 0033:0x7f518bdc6dd7
[ 6507.458178] [T3176799] Code: af e8 ed ed 03 00 66 2e 0f 1f 84 00 00 00 0=
0 00 0f 1f 00 48 8b 05 f1 81 10 00 48 8b 10 e9 01 00 00 00 90 b8 3b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 80 10 00 f7 d8 64 89 01 48
[ 6507.458179] [T3176799] RSP: 002b:00007f518bf03e68 EFLAGS: 00000246 ORIG_=
RAX: 000000000000003b
[ 6507.458180] [T3176799] RAX: ffffffffffffffda RBX: 00007ffe39827340 RCX: =
00007f518bdc6dd7
[ 6507.458180] [T3176799] RDX: 000000003adf5fb0 RSI: 000000003ae01fa8 RDI: =
000000003ae0ee10
[ 6507.458181] [T3176799] RBP: 00007f518bf03ff0 R08: 00007ffe398270a0 R09: =
0000000000000000
[ 6507.458181] [T3176799] R10: 0000000000000008 R11: 0000000000000246 R12: =
00007ffe398270a0
[ 6507.458182] [T3176799] R13: 0000000000000040 R14: 0000000000000001 R15: =
00007f518bf03f20
[ 6507.458183] [T3176799]  </TASK>
[ 6507.458183] [T3176799] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.458216] [T3176799]  gpio_generic
[ 6507.458218] [T3176799] ---[ end trace 0000000000000000 ]---
[ 6507.478622] [T3176799] RIP: 0010:memset+0xf/0x20
[ 6507.478628] [T3176799] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.478630] [T3176799] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6507.478632] [T3176799] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6507.478633] [T3176799] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6507.478633] [T3176799] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6507.478634] [T3176799] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6507.478635] [T3176799] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6507.478635] [T3176799] FS:  00007f518bce7c80(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.478636] [T3176799] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.478637] [T3176799] CR2: 00007fd0702bd160 CR3: 000000016ac67000 CR4: =
0000000000f50ef0
[ 6507.478638] [T3176799] PKRU: 55555554
[ 6507.478662] [T3174912] Oops: general protection fault, maybe for address=
 0x7f518bf04f00: 0000 [#7] SMP NOPTI
[ 6507.478665] [T3174912] CPU: 29 UID: 1000 PID: 3174912 Comm: xg++ Tainted=
: G      D W           7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6507.478668] [T3174912] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.478669] [T3174912] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.478670] [T3174912] RIP: 0010:memset+0xf/0x20
[ 6507.478671] [T3174912] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.478672] [T3174912] RSP: 0018:ffffb18bb246b640 EFLAGS: 00010246
[ 6507.478673] [T3174912] RAX: 00007f518bf04f00 RBX: ffffb18bb246baa0 RCX: =
0000000000000100
[ 6507.478674] [T3174912] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
682e62696c647473
[ 6507.478674] [T3174912] RBP: 00007f518bf04fff R08: 0000000000000003 R09: =
682e62696c647473
[ 6507.478675] [T3174912] R10: 0000000000000008 R11: 0000000000000000 R12: =
0000000000000008
[ 6507.478675] [T3174912] R13: 0000000000000002 R14: 682e62696c647473 R15: =
ffffb18bb246b7a0
[ 6507.478676] [T3174912] FS:  00007f518bce7c80(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.478676] [T3174912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.478677] [T3174912] CR2: 00007fd0702bd160 CR3: 000000016ac67000 CR4: =
0000000000f50ef0
[ 6507.478677] [T3174912] PKRU: 55555554
[ 6507.478678] [T3174912] Call Trace:
[ 6507.478680] [T3174912]  <TASK>
[ 6507.478680] [T3174912]  mas_wr_node_store+0x9a/0x3f0
[ 6507.478685] [T3174912]  ? update_cfs_rq_load_avg+0x29/0x220
[ 6507.478687] [T3174912]  ? psi_group_change+0x11c/0x2f0
[ 6507.478689] [T3174912]  ? update_curr+0x2a/0x160
[ 6507.478691] [T3174912]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.478692] [T3174912]  ? obj_cgroup_charge_account+0xf2/0x290
[ 6507.478694] [T3174912]  mas_store_prealloc+0x19d/0x3d0
[ 6507.478697] [T3174912]  vma_complete+0x217/0x2c0
[ 6507.478698] [T3174912]  __split_vma+0x248/0x2b0
[ 6507.478700] [T3174912]  vms_gather_munmap_vmas+0x128/0x340
[ 6507.478701] [T3174912]  do_vmi_align_munmap+0x152/0x240
[ 6507.478702] [T3174912]  ? __schedule+0x487/0xed0
[ 6507.478705] [T3174912]  do_vmi_munmap+0xcb/0x160
[ 6507.478706] [T3174912]  __vm_munmap+0xa5/0x110
[ 6507.478708] [T3174912]  __x64_sys_munmap+0x16/0x20
[ 6507.478710] [T3174912]  do_syscall_64+0x11b/0x8c0
[ 6507.478711] [T3174912]  ? switch_fpu_return+0x42/0x70
[ 6507.478713] [T3174912]  ? do_syscall_64+0x2b4/0x8c0
[ 6507.478714] [T3174912]  ? do_faccessat+0x20d/0x2f0
[ 6507.478716] [T3174912]  ? __x64_sys_access+0x17/0x20
[ 6507.478718] [T3174912]  ? do_syscall_64+0x11b/0x8c0
[ 6507.478719] [T3174912]  ? do_syscall_64+0x11b/0x8c0
[ 6507.478720] [T3174912]  ? vfs_statx+0x67/0x140
[ 6507.478722] [T3174912]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.478722] [T3174912]  ? kmem_cache_free+0x1d2/0x350
[ 6507.478725] [T3174912]  ? vfs_fstatat+0x4f/0x80
[ 6507.478725] [T3174912]  ? __do_sys_newfstatat+0x24/0x60
[ 6507.478726] [T3174912]  ? kmem_cache_free+0x1d2/0x350
[ 6507.478728] [T3174912]  ? do_faccessat+0x20d/0x2f0
[ 6507.478729] [T3174912]  ? __x64_sys_access+0x17/0x20
[ 6507.478731] [T3174912]  ? do_syscall_64+0x11b/0x8c0
[ 6507.478731] [T3174912]  ? __x64_sys_access+0x17/0x20
[ 6507.478733] [T3174912]  ? do_syscall_64+0x11b/0x8c0
[ 6507.478733] [T3174912]  ? rt_spin_lock+0x38/0x110
[ 6507.478734] [T3174912]  ? do_syscall_64+0x11b/0x8c0
[ 6507.478735] [T3174912]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.478736] [T3174912]  ? __x64_sys_rt_sigprocmask+0xde/0x140
[ 6507.478738] [T3174912]  ? do_syscall_64+0x11b/0x8c0
[ 6507.478738] [T3174912]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6507.478740] [T3174912] RIP: 0033:0x7f518bdf66d7
[ 6507.478742] [T3174912] Code: 73 01 c3 48 8b 0d 39 87 0d 00 f7 d8 64 89 0=
1 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 87 0d 00 f7 d8 64 89 01 48
[ 6507.478742] [T3174912] RSP: 002b:00007ffe39826ff8 EFLAGS: 00000202 ORIG_=
RAX: 000000000000000b
[ 6507.478743] [T3174912] RAX: ffffffffffffffda RBX: 0000000000009000 RCX: =
00007f518bdf66d7
[ 6507.478744] [T3174912] RDX: 00007f518bde2950 RSI: 0000000000009000 RDI: =
00007f518befb000
[ 6507.478745] [T3174912] RBP: 00007f518befb000 R08: 000000000030795f R09: =
0000000000000000
[ 6507.478745] [T3174912] R10: 0000000000000008 R11: 0000000000000202 R12: =
00007ffe398270a0
[ 6507.478745] [T3174912] R13: 0000000000000000 R14: 0000000000007001 R15: =
0000000000000000
[ 6507.478747] [T3174912]  </TASK>
[ 6507.478747] [T3174912] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.478779] [T3174912]  gpio_generic
[ 6507.478781] [T3174912] ---[ end trace 0000000000000000 ]---
[ 6507.499766] [T3174912] RIP: 0010:memset+0xf/0x20
[ 6507.499772] [T3174912] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.499774] [T3174912] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6507.499775] [T3174912] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6507.499776] [T3174912] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6507.499777] [T3174912] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6507.499778] [T3174912] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6507.499779] [T3174912] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6507.499780] [T3174912] FS:  00007f518bce7c80(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.499781] [T3174912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.499782] [T3174912] CR2: 00007fd0702bd160 CR3: 000000016ac67000 CR4: =
0000000000f50ef0
[ 6507.499783] [T3174912] PKRU: 55555554
[ 6507.499786] [T3174912] ------------[ cut here ]------------
[ 6507.499787] [T3174912] rtmutex deadlock detected
[ 6507.499787] [T3174912] WARNING: kernel/locking/rtmutex.c:1674 at __rt_mu=
tex_slowlock_locked.constprop.0+0x835/0x9b0, CPU#29: xg++/3174912
[ 6507.499793] [T3174912] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.499824] [T3174912]  gpio_generic
[ 6507.499826] [T3174912] CPU: 29 UID: 1000 PID: 3174912 Comm: xg++ Tainted=
: G      D W           7.0.0-rc2-next-20260303-master #367 PREEMPT_RT=20
[ 6507.499830] [T3174912] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.499830] [T3174912] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.499832] [T3174912] RIP: 0010:__rt_mutex_slowlock_locked.constprop.0+=
0x835/0x9b0
[ 6507.499833] [T3174912] Code: 00 48 89 ef e8 fc 67 87 00 c7 44 24 14 fc f=
f ff ff 41 83 ff dd 0f 85 87 fd ff ff 48 89 ef e8 b2 66 87 00 48 8d 3d 2b 5=
8 f2 00 <67> 48 0f b9 3a bd 01 00 00 00 89 e8 87 43 18 e8 e7 6a fd ff eb f4
[ 6507.499834] [T3174912] RSP: 0018:ffffb18bb246bd18 EFLAGS: 00010286
[ 6507.499835] [T3174912] RAX: 0000000000000000 RBX: ffff926430cbdb80 RCX: =
ffff926430cbdb81
[ 6507.499835] [T3174912] RDX: 0000000000000001 RSI: ffff926430cbdb80 RDI: =
ffffffffa9e36620
[ 6507.499836] [T3174912] RBP: ffff92640699a6b8 R08: 0000000000000000 R09: =
0000000000000000
[ 6507.499837] [T3174912] R10: 0000000000000000 R11: 0000000000000003 R12: =
ffffb18bb246bd40
[ 6507.499837] [T3174912] R13: ffff926430cbdb81 R14: ffff926430cbe7c0 R15: =
00000000ffffffdd
[ 6507.499838] [T3174912] FS:  00007f518bce7c80(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.499839] [T3174912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.499839] [T3174912] CR2: 00007fd0702bd160 CR3: 000000016ac67000 CR4: =
0000000000f50ef0
[ 6507.499840] [T3174912] PKRU: 55555554
[ 6507.499840] [T3174912] Call Trace:
[ 6507.499843] [T3174912]  <TASK>
[ 6507.499845] [T3174912]  ? vfs_statx+0x67/0x140
[ 6507.499849] [T3174912]  ? kmem_cache_free+0x1d2/0x350
[ 6507.499852] [T3174912]  __rwbase_read_lock+0x4a/0xd0
[ 6507.499855] [T3174912]  acct_collect+0x157/0x1c0
[ 6507.499858] [T3174912]  do_exit+0x1c2/0xa30
[ 6507.499861] [T3174912]  make_task_dead+0x94/0xa0
[ 6507.499862] [T3174912]  rewind_stack_and_make_dead+0x16/0x20
[ 6507.499865] [T3174912] RIP: 0033:0x7f518bdf66d7
[ 6507.499868] [T3174912] Code: 73 01 c3 48 8b 0d 39 87 0d 00 f7 d8 64 89 0=
1 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 09 87 0d 00 f7 d8 64 89 01 48
[ 6507.499869] [T3174912] RSP: 002b:00007ffe39826ff8 EFLAGS: 00000202 ORIG_=
RAX: 000000000000000b
[ 6507.499870] [T3174912] RAX: ffffffffffffffda RBX: 0000000000009000 RCX: =
00007f518bdf66d7
[ 6507.499871] [T3174912] RDX: 00007f518bde2950 RSI: 0000000000009000 RDI: =
00007f518befb000
[ 6507.499872] [T3174912] RBP: 00007f518befb000 R08: 000000000030795f R09: =
0000000000000000
[ 6507.499872] [T3174912] R10: 0000000000000008 R11: 0000000000000202 R12: =
00007ffe398270a0
[ 6507.499873] [T3174912] R13: 0000000000000000 R14: 0000000000007001 R15: =
0000000000000000
[ 6507.499875] [T3174912]  </TASK>
[ 6507.499876] [T3174912] ---[ end trace 0000000000000000 ]---
[ 6507.500728] [T3176923] Oops: general protection fault, probably for non-=
canonical address 0x2f6564756c636e00: 0000 [#8] SMP NOPTI
[ 6507.500732] [T3176923] CPU: 29 UID: 1000 PID: 3176923 Comm: x86_64-linux=
-gn Tainted: G      D W           7.0.0-rc2-next-20260303-master #367 PREEM=
PT_RT=20
[ 6507.500735] [T3176923] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.500735] [T3176923] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.500736] [T3176923] RIP: 0010:memset+0xf/0x20
[ 6507.500739] [T3176923] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.500740] [T3176923] RSP: 0018:ffffb18baf3fb758 EFLAGS: 00010246
[ 6507.500742] [T3176923] RAX: 2f6564756c636e00 RBX: ffffb18baf3fb878 RCX: =
0000000000000100
[ 6507.500742] [T3176923] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
2f6564756c636e69
[ 6507.500743] [T3176923] RBP: ffffb18baf3fba30 R08: ffffffffffffffff R09: =
2f6564756c636e69
[ 6507.500743] [T3176923] R10: 0000000000000001 R11: 0000000000000010 R12: =
0000000000000001
[ 6507.500744] [T3176923] R13: ffffb18baf3fb878 R14: 0000000000000000 R15: =
00007fd51250f000
[ 6507.500745] [T3176923] FS:  0000000000000000(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.500746] [T3176923] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.500746] [T3176923] CR2: 00007fd512549b4c CR3: 0000000269a79000 CR4: =
0000000000f50ef0
[ 6507.500747] [T3176923] PKRU: 55555554
[ 6507.500747] [T3176923] Call Trace:
[ 6507.500749] [T3176923]  <TASK>
[ 6507.500749] [T3176923]  dst_setup+0x9d/0x250
[ 6507.500753] [T3176923]  mas_wr_split+0x192/0x1080
[ 6507.500755] [T3176923]  ? rt_spin_lock+0x38/0x110
[ 6507.500757] [T3176923]  ? mas_wr_node_store+0x231/0x3f0
[ 6507.500758] [T3176923]  ? mas_store_gfp+0x1fc/0x480
[ 6507.500760] [T3176923]  mas_store_prealloc+0x19d/0x3d0
[ 6507.500763] [T3176923]  vma_link+0x11a/0x180
[ 6507.500765] [T3176923]  insert_vm_struct+0x41/0xa0
[ 6507.500766] [T3176923]  _install_special_mapping+0x7d/0x140
[ 6507.500769] [T3176923]  map_vdso+0xaa/0x190
[ 6507.500770] [T3176923]  load_elf_binary+0xdb4/0x1880
[ 6507.500773] [T3176923]  ? __kernel_read+0x1a1/0x2a0
[ 6507.500775] [T3176923]  ? rt_read_lock+0x40/0x130
[ 6507.500777] [T3176923]  bprm_execve+0x27c/0x4a0
[ 6507.500778] [T3176923]  do_execveat_common.isra.0+0x157/0x170
[ 6507.500780] [T3176923]  __x64_sys_execve+0x38/0x50
[ 6507.500781] [T3176923]  do_syscall_64+0x11b/0x8c0
[ 6507.500783] [T3176923]  ? rt_spin_lock+0x38/0x110
[ 6507.500783] [T3176923]  ? rt_spin_lock+0x38/0x110
[ 6507.500784] [T3176923]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.500785] [T3176923]  ? __folio_batch_add_and_move+0x1ad/0x220
[ 6507.500787] [T3176923]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.500788] [T3176923]  ? do_anonymous_page+0x1a5/0x570
[ 6507.500790] [T3176923]  ? __handle_mm_fault+0x357/0x3a0
[ 6507.500792] [T3176923]  ? count_memcg_events+0x5e/0xf0
[ 6507.500794] [T3176923]  ? handle_mm_fault+0x1b9/0x2c0
[ 6507.500795] [T3176923]  ? do_user_addr_fault+0x203/0x640
[ 6507.500797] [T3176923]  entry_SYSCALL_64_after_hwframe+0x55/0x5d
[ 6507.500798] [T3176923] RIP: 0033:0x7fe983bdddd7
[ 6507.500800] [T3176923] Code: Unable to access opcode bytes at 0x7fe983bd=
ddad.
[ 6507.500801] [T3176923] RSP: 002b:00007ffe39e37e78 EFLAGS: 00000202 ORIG_=
RAX: 000000000000003b
[ 6507.500801] [T3176923] RAX: ffffffffffffffda RBX: 000056160290bab0 RCX: =
00007fe983bdddd7
[ 6507.500802] [T3176923] RDX: 000056160290c308 RSI: 000056160290c148 RDI: =
000056160290bab0
[ 6507.500802] [T3176923] RBP: 000056160290c148 R08: 00000000000007e0 R09: =
00007fe983ce6ac0
[ 6507.500802] [T3176923] R10: 0000000000000001 R11: 0000000000000202 R12: =
000056160228a102
[ 6507.500803] [T3176923] R13: 0000000000000000 R14: 0000000000000001 R15: =
000056160290c308
[ 6507.500803] [T3176923]  </TASK>
[ 6507.500804] [T3176923] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.500819] [T3176923]  gpio_generic
[ 6507.500821] [T3176923] ---[ end trace 0000000000000000 ]---
[ 6507.519123] [T3176923] RIP: 0010:memset+0xf/0x20
[ 6507.519130] [T3176923] Code: 44 89 54 17 fe eb 0c 48 83 fa 01 72 06 44 8=
a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f 1e fa 66 90 49 89 f9 40 88 f0 4=
8 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 fa 40 0f
[ 6507.519131] [T3176923] RSP: 0018:ffffb18ba99636f0 EFLAGS: 00010246
[ 6507.519133] [T3176923] RAX: 00007ffe00b6ff00 RBX: ffffb18ba99638e0 RCX: =
0000000000000100
[ 6507.519134] [T3176923] RDX: 0000000000000100 RSI: 0000000000000000 RDI: =
622f6564756c636e
[ 6507.519135] [T3176923] RBP: 00007ffe00b6ffff R08: 0000000000000008 R09: =
622f6564756c636e
[ 6507.519136] [T3176923] R10: 0000000000000008 R11: 0000000000000000 R12: =
000000000000000b
[ 6507.519136] [T3176923] R13: 0000000000000002 R14: 622f6564756c636e R15: =
ffffb18ba9963850
[ 6507.519137] [T3176923] FS:  0000000000000000(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.519138] [T3176923] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.519139] [T3176923] CR2: 00007fe983bdddad CR3: 0000000269a79000 CR4: =
0000000000f50ef0
[ 6507.519140] [T3176923] PKRU: 55555554
[ 6507.519143] [T3176923] ------------[ cut here ]------------
[ 6507.519144] [T3176923] rtmutex deadlock detected
[ 6507.519144] [T3176923] WARNING: kernel/locking/rtmutex.c:1674 at __rt_mu=
tex_slowlock_locked.constprop.0+0x835/0x9b0, CPU#29: x86_64-linux-gn/3176923
[ 6507.519150] [T3176923] Modules linked in: ccm rfcomm bnep snd_seq_dummy =
snd_hrtimer snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm =
btmtk bluetooth snd_usb_audio ecdh_generic ecc mt7925e mt7925_common snd_us=
bmidi_lib mt792x_lib snd_ump mt76_connac_lib snd_rawmidi snd_hda_codec_atih=
dmi joydev intel_rapl_msr snd_hda_codec_hdmi snd_seq_device mt76 mac80211 s=
nd_hda_intel snd_hda_codec intel_rapl_common rapl wmi_bmof pcspkr snd_hda_c=
ore snd_intel_dspcfg snd_hwdep snd_pcm libarc4 snd_timer snd soundcore cfg8=
0211 spd5118 regmap_i2c ccp rfkill k10temp evdev nct6775 nct6775_core hwmon=
_vid efi_pstore configfs efivarfs autofs4 ext4 mbcache jbd2 hid_generic usb=
hid hid amdgpu drm_client_lib i2c_algo_bit drm_buddy drm_ttm_helper ttm drm=
_exec drm_suballoc_helper mfd_core drm_panel_backlight_quirks gpu_sched amd=
xcp drm_display_helper xhci_pci xhci_hcd drm_kms_helper ahci libahci drm li=
bata nvme usbcore nvme_core scsi_mod igc i2c_piix4 nvme_keyring cec i2c_smb=
us nvme_auth usb_common scsi_common video crc16 hkdf wmi gpio_amdpt
[ 6507.519187] [T3176923]  gpio_generic
[ 6507.519190] [T3176923] CPU: 29 UID: 1000 PID: 3176923 Comm: x86_64-linux=
-gn Tainted: G      D W           7.0.0-rc2-next-20260303-master #367 PREEM=
PT_RT=20
[ 6507.519192] [T3176923] Tainted: [D]=3DDIE, [W]=3DWARN
[ 6507.519193] [T3176923] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[ 6507.519194] [T3176923] RIP: 0010:__rt_mutex_slowlock_locked.constprop.0+=
0x835/0x9b0
[ 6507.519196] [T3176923] Code: 00 48 89 ef e8 fc 67 87 00 c7 44 24 14 fc f=
f ff ff 41 83 ff dd 0f 85 87 fd ff ff 48 89 ef e8 b2 66 87 00 48 8d 3d 2b 5=
8 f2 00 <67> 48 0f b9 3a bd 01 00 00 00 89 e8 87 43 18 e8 e7 6a fd ff eb f4
[ 6507.519197] [T3176923] RSP: 0018:ffffb18baf3fbd18 EFLAGS: 00010286
[ 6507.519198] [T3176923] RAX: 0000000000000000 RBX: ffff9264014cbd00 RCX: =
ffff9264014cbd01
[ 6507.519198] [T3176923] RDX: 0000000000000001 RSI: ffff9264014cbd00 RDI: =
ffffffffa9e36620
[ 6507.519199] [T3176923] RBP: ffff92677de99438 R08: 0000000000000000 R09: =
ffff92737dcf6f90
[ 6507.519199] [T3176923] R10: ffff92737dd26fe8 R11: 0000000000000003 R12: =
ffffb18baf3fbd40
[ 6507.519200] [T3176923] R13: ffff9264014cbd01 R14: ffff9264014cc940 R15: =
00000000ffffffdd
[ 6507.519200] [T3176923] FS:  0000000000000000(0000) GS:ffff927393821000(0=
000) knlGS:0000000000000000
[ 6507.519201] [T3176923] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6507.519201] [T3176923] CR2: 00007fe983bdddad CR3: 0000000269a79000 CR4: =
0000000000f50ef0
[ 6507.519202] [T3176923] PKRU: 55555554
[ 6507.519203] [T3176923] Call Trace:
[ 6507.519205] [T3176923]  <TASK>
[ 6507.519208] [T3176923]  ? __folio_batch_add_and_move+0x1ad/0x220
[ 6507.519212] [T3176923]  ? rt_spin_unlock+0x5a/0xa0
[ 6507.519214] [T3176923]  __rwbase_read_lock+0x4a/0xd0
[ 6507.519217] [T3176923]  acct_collect+0x157/0x1c0
[ 6507.519221] [T3176923]  do_exit+0x1c2/0xa30
[ 6507.519224] [T3176923]  ? do_user_addr_fault+0x203/0x640
[ 6507.519226] [T3176923]  make_task_dead+0x94/0xa0
[ 6507.519228] [T3176923]  rewind_stack_and_make_dead+0x16/0x20
[ 6507.519231] [T3176923] RIP: 0033:0x7fe983bdddd7
[ 6507.519235] [T3176923] Code: Unable to access opcode bytes at 0x7fe983bd=
ddad.
[ 6507.519235] [T3176923] RSP: 002b:00007ffe39e37e78 EFLAGS: 00000202 ORIG_=
RAX: 000000000000003b
[ 6507.519237] [T3176923] RAX: ffffffffffffffda RBX: 000056160290bab0 RCX: =
00007fe983bdddd7
[ 6507.519237] [T3176923] RDX: 000056160290c308 RSI: 000056160290c148 RDI: =
000056160290bab0
[ 6507.519238] [T3176923] RBP: 000056160290c148 R08: 00000000000007e0 R09: =
00007fe983ce6ac0
[ 6507.519238] [T3176923] R10: 0000000000000001 R11: 0000000000000202 R12: =
000056160228a102
[ 6507.519239] [T3176923] R13: 0000000000000000 R14: 0000000000000001 R15: =
000056160290c308
[ 6507.519241] [T3176923]  </TASK>
[ 6507.519241] [T3176923] ---[ end trace 0000000000000000 ]---


After this error the system does not work properly anymore (htop and ps
don't work anymore, xfce still works, evolution refuses to start and shutti=
ng down also hangs)=20

I recently successfully compiled gcc-14 from debian on linux-6.18.13, so I'=
m going to bisect this.
Depending on wether I can single out the offending test this could take a w=
hile so I'm
reporting this before the bisection is finished.

Bert Karwatztki







