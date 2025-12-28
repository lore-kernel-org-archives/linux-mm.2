Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BBB4E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 18:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3CE6B0089; Sun, 28 Dec 2025 13:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2656B008A; Sun, 28 Dec 2025 13:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5286B008C; Sun, 28 Dec 2025 13:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B84C46B0089
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 13:32:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 627F5D8F68
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 18:32:00 +0000 (UTC)
X-FDA: 84269724000.04.9947532
Received: from mail-139-mta230.mxyeet.net (mail-139-mta230.mxyeet.net [23.172.139.230])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91DB9A000B
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 18:31:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bbaa.fun header.s=av8DE3008F7488933 header.b=qG5fQABQ;
	dmarc=pass (policy=quarantine) header.from=bbaa.fun;
	spf=pass (imf15.hostedemail.com: domain of bbaa@bbaa.fun designates 23.172.139.230 as permitted sender) smtp.mailfrom=bbaa@bbaa.fun
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766946718; a=rsa-sha256;
	cv=none;
	b=rDw3pTdeAXYQ27BjTDMgqi3PJtlW+4hhP6czv4pRMR4ibvvlVshfTEUxCpxsFIYispNIzd
	WnLZ4Mta6CMdbN8K2A77a/CERaK7KmPajd54DvOUmfofxjfI4nIhXJPtpgWUurLIMbT8Tx
	/KegNKUBNvV55NzwmrbeMvF5JJixCqI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bbaa.fun header.s=av8DE3008F7488933 header.b=qG5fQABQ;
	dmarc=pass (policy=quarantine) header.from=bbaa.fun;
	spf=pass (imf15.hostedemail.com: domain of bbaa@bbaa.fun designates 23.172.139.230 as permitted sender) smtp.mailfrom=bbaa@bbaa.fun
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766946718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rKRx15FD2P/QOgmgNHJNUluLSu+ZDBdt6FLosJXwNHo=;
	b=vj1HTBzzXBSuRpgs0odG6yWvKurwwsOjoiJIg8ijBlMGaC0o3CezIVL4w0rmUrRVurThK0
	qwU0H/qp60flmjA1CVkuA3ljNwqPITCHu/rupmp8TLvaxUqw6Gn4VSBetIkyWeZoH6Wpqz
	N1X+6uZw4HtmFnoQo/AJd9c5BP2jvjc=
Received: from us1.workspace.org ([162.244.93.81])
	by mx1.mxfilter.net with esmtpa (Exim 4.94.2)
	(envelope-from <bbaa@bbaa.fun>)
	id 1vZvcO-001MVJ-S8; Sun, 28 Dec 2025 10:31:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; d=bbaa.fun; s=av8DE3008F7488933;
	c=relaxed/relaxed; t=1766946700;
	h=from:to:cc:subject:date:message-id:x-mailer:mime-version;
	bh=rKRx15FD2P/QOgmgNHJNUluLSu+ZDBdt6FLosJXwNHo=;
	b=qG5fQABQDLPwVYspu7sokridPGdCarHaVk/YsP/jmy1/JVs5GmCSrcoqC7BiUgQ6pTAAXGG86nA
	1c7br95I7cFSV981UethC6YacFYIf6cO2g5KXKZti2LhtBlZeLUrn07kYJJFo86aIFD/rdqxZ+kWi
	j4JCo+1tVwzTEMeKBpM4TkcBz5IzKu81UpAOP2bQXebUupQiqMsBQN8i33quvcdgPt7On7R5pZt0K
	a492IswbBUWNYmYbkheONjaJ+npZPw2CQexJeQwcgjXejniZ5M5qWtZRBzpfj5Jd0AaDgDZm1SKW1
	/6AriuH2KmXAKZ/A536qlWVJQwaPyUEdcE6Q==
From: Ban ZuoXiang <bbaa@bbaa.fun>
To: aliceryhl@google.com, gregkh@linuxfoundation.org
Cc: ojeda@kernel.org, alex.gaynor@gmail.com, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [BUG] soft lockup in kswapd0 caused by Rust binder
Date: Mon, 29 Dec 2025 02:31:24 +0800
Message-ID: <20251228183129.17193-1-bbaa@bbaa.fun>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: 162.244.93.81
X-SpamExperts-Domain: mxyeet.net
X-SpamExperts-Username: smartermail
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: SB/global_tokens (5.7092575112e-10)
X-Recommended-Action: accept
X-Filter-ID: 9kzQTOBWQUFZTohSKvQbgI7ZDo5ubYELi59AwcWUnuUt70AhH2huZ0hssZU6iaDLChjzQ3JIZVFF
 8HV60IETFiu2SmbhJN1U9FKs8X3+Nt0FOl+ASFczY3noAPKuEEJhQHJfqQ64nI8OXcHHUR+UmMUI
 LYktuu3IV7f0/T27Pqkk4Ndu06h2Q8QP5GQeNUYf+DoI5ero3AmhIYfztx7bKQZmnW/XN+tohdLu
 D74c7RLm7rJaFabHdhRB1M5CpEevg8CBO1Snvm6qXHQp7O9kdY+UD7VHHpDYs+rEjiTXe4WKt+mB
 C7rFaes5rZKd35vJLDnQGgRgHjioU8fpt7xeC6lpK5rmsikWQyHoo01Us4Z1thv0hd9gZGlVL/SE
 DgzCG0XIswT4JTPNkebrIx8pyA5U9t4xcCUOm4tiv78RtCq8Ng3mYqtflZjDsBc5em/VPnrhyYEC
 sIe6J6jqDToibXfgD3PWF0irxjKk3/vWv1cHLUesOFho5kJn+h8T97+juMI5o/7ag+7fAeZ/0D/o
 aBtPVai8IsFJldnpxNC5oFbU9F4QK/47LgCAS8YT+zZ/XG4tO8kCg1cp84iMSAkGFeL+EuOJL/c5
 tJIVZhWv3apX07NPEMssOkqNyDaeeBep7MoHOmPp3YnNtmvPmSihMlNiLZt/QXQnOBRD+jq1HsIc
 b3vTWnDYyVC7/iU3LFoRU2Itm39BdCc4FEP6OrUewhMp7l2H6L1j3xQGrt05tlcy8V5TAE2MyU4x
 O6WjOUIW31/E3ahF5MMcDI7KdpjQKR1rRW2/Ber2PqroG23nxx1rW6geRibv9v24o8pyO+wfXw0w
 ikvZkulDqcrpWCoB+LaiUF9sHh1/NzLB7qIs483Nybl56sya0T9xEzVY363yx78pxU3yUjGNzx/G
 kJD0Lh/LIV1YxiRB+4L7xN5erWmQp6iQOcylg4zeIfjQL4cweUvsRehKMiBHeoTRkEMdtEl4PpOg
 bCAYLr2RF7WRTTfrce/yja8lj1X9smfLvXyMwCcp22CVjbX1GnCNi2ASYKPEJRIe0r/ece53u7ka
 x2AppUMd0V4zQuQzp0OBP9wD9B1rqsxWtMmzF3PUhbYHSFFfEoXm0/FPF8PR0w363lmTwJvcF16P
 8f5DknwNiAeqQWy02jken2lZ8tkIY+F6Z1bs1b+lPl6frsX3AK4aOFP5fYhnc+Ng6LSN+h+4QfaY
 Fuupjn2+p/TJWBvLviE0/0eN5gq2WsqFjibD3Odqt6z+KvZJ30NG3C5Vc/q0wxSGAk9jZlOhtXWT
 K6eQfdZUmg==
X-Report-Abuse-To: spam@mx1.mxfilter.net
X-Complaints-To: abuse@mx1.mxfilter.net
X-Rspamd-Queue-Id: 91DB9A000B
X-Stat-Signature: b6qz5dc3m6x3r9461w7z96m3mmojb3u7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766946718-367383
X-HE-Meta: U2FsdGVkX18cANJ2WCYr4wHvTWPr/eHOjRCR7ZZtdGMIf76dqx51/yCx52RD6iVKUugXc/Ne6bKO6NMazy0ZFdGniQEPYo+x7ZFR/ngtauod2K06pi4G1TPowcTU6LqpavU9j22eqUcqteuC9vQqfujhOKGsLA2dTkAaAsPBHgekbrL6PPR1BXRFm9/9pqjUsdiscR8bTIYXezdV0bVoW1p29o02/HZeKgjFmdWlNi4utsf9lT4KdDhbhbrYlHWr7z3vkG8ql9DjyYPEL3miN7Lc/79K6s0SNX1K+WwzqjbzEx3LRjemqjryvqX0Fx68qBIeAwAN9msW/HKkmnXvXN7dPGdt5cmXvY0NA41tbQKOtPx0QJFEegKGwS1+dn86CT/+TQpVP83hwpBRvWfI2fa4+jDILZT3V6rA53mZkOWKUPwnMTa/FTFrEH2zVi8vRKRuJ41c5DT3aKL+g9C2P8eafnvz3eAuaDxKu5fL7YJhPm7r8DvIrAg1A/ba0fGvTDQUfRuteLBecPTXdpBnzOPneIQY/r3NsK+O0ffs8lOHxIu4269oBEikRj4q7s1d5LBWumR4tDecslev/oNmH1XTBLzfmi+Ay9szklgCPA4MJAfQItMKt8P3UrP55EvX+5lUEhJpzANPR6n6UfoEEA3LFKgX/YvNQYSF4aiPxbouMJge12FECqyqLrl6LTaqhF/tDp2vS1WuGA/+GkCHhTEO/9+Nxg3GlR8MoT9mxex3MR74n/qZ5tAFd2VdjePxezrFOn6e7NJdwb9D8iUCsDOYc+mrzNwnwxRXZnoNkHq91VTj1Gk1hmSL8VhtOB7dgGQZGXnJtyVxarOYoYmN94NECjXlREXjIat6WgLrlC0HCG11Yrhn6zd7NrlNr9PU7aygkyRSqSpvrvdZSd39woRT/9Z4+AsXVHoU+p1iql38GoJeDCgB7gvHJ+ci+44bZC7osgI0hS6GwCCxZHv
 6kUSbV+8
 nBcBLt+TrhN2kJ4FqSGgQZ1iS4F316m6CKlWJNWBjCAAEXLUdgGr/I0wEQ58hoxqficrJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,=20
Many users [1][2][3] have reported a kernel soft lockup in the
kswapd0 task when running Waydroid (an Android container solution) on
kernels with the new Rust Binder driver.

The issue manifests as a soft lockup where CPU utilization is pegged at
100% system time, stuck in the list_lru_walk path triggered by the Rust
binder's shrinker.

Kernel Log:
12 25 01:23:57 arch-laptop kernel: watchdog: BUG: soft lockup - CPU#0 stuck=
 for 22s! [kswapd0:142]
12 25 01:23:57 arch-laptop kernel: CPU#0 Utilization every 4000ms during lo=
ckup:
12 25 01:23:57 arch-laptop kernel:         #1: 100% system,          0% sof=
tirq,          1% hardirq,          0% idle
12 25 01:23:57 arch-laptop kernel:         #2: 100% system,          0% sof=
tirq,          1% hardirq,          0% idle
12 25 01:23:57 arch-laptop kernel:         #3: 100% system,          0% sof=
tirq,          1% hardirq,          0% idle
12 25 01:23:57 arch-laptop kernel:         #4: 100% system,          0% sof=
tirq,          1% hardirq,          0% idle
12 25 01:23:57 arch-laptop kernel:         #5: 100% system,          0% sof=
tirq,          1% hardirq,          0% idle
12 25 01:23:57 arch-laptop kernel: Modules linked in: sch_ingress af_key tc=
p_diag udp_diag inet_diag nfnetlink_log xfrm_user xfrm_algo xfrm_interface =
xfrm6_tunnel tunnel4 tunnel6 vsock_loopback vmw_vsock_virtio_transport_comm=
on vmw_vsock_vmci_transport vsock vmw_vmci veth overlay loop nft_masq nft_c=
hain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc n=
f_tables tun rfcomm snd_seq_dummy snd_hrtimer snd_seq cmac algif_hash algif=
_skcipher af_alg bnep vfat fat iwlmvm intel_rapl_msr amd_atl amdgpu intel_r=
apl_common mac80211 ptp pps_core libarc4 amdxcp snd_hda_codec_nvhdmi drm_pa=
nel_backlight_quirks snd_hda_codec_hdmi gpu_sched snd_usb_audio drm_buddy i=
wlwifi kvm_amd drm_exec uvcvideo drm_suballoc_helper snd_hda_intel drm_ttm_=
helper btusb kvm videobuf2_vmalloc spd5118 r8169 snd_hda_codec snd_usbmidi_=
lib ttm ucsi_acpi btmtk uvc snd_hda_core cfg80211 realtek btrtl irqbypass i=
2c_algo_bit snd_ump videobuf2_memops asus_nb_wmi typec_ucsi snd_intel_dspcf=
g sp5100_tco mdio_devres polyval_clmulni videobuf2_v4l2 btbcm amd_pmf
12 25 01:23:57 arch-laptop kernel:  ghash_clmulni_intel snd_rawmidi drm_dis=
play_helper snd_intel_sdw_acpi asus_wmi libphy typec videobuf2_common i2c_p=
iix4 btintel aesni_intel snd_hwdep snd_seq_device amdtee hid_multitouch blu=
etooth videodev cec wmi_bmof sparse_keymap rapl pcspkr roles ccp k10temp rf=
kill video i2c_smbus mdio_bus amd_sfh snd_pcm thunderbolt i2c_hid_acpi plat=
form_profile snd_timer wmi i2c_hid tee snd amd_pmc soundcore mc mousedev jo=
ydev mac_hid tcp_bbr sch_fq_pie sch_pie i2c_dev pkcs8_key_parser ntsync cry=
pto_user nfnetlink hid_logitech_hidpp hid_logitech_dj nvme nvme_core nvme_k=
eyring nvme_auth hkdf serio_raw
12 25 01:23:57 arch-laptop kernel: CPU: 0 UID: 0 PID: 142 Comm: kswapd0 Not=
 tainted 6.18.2-zen2-1-zen #1 PREEMPT(full)  817688afc19ca15a22737742591535=
351aba70f8
12 25 01:23:57 arch-laptop kernel: Hardware name: ASUSTeK COMPUTER INC. ASU=
S TUF Gaming A15 FA507RM_FA507RM/FA507RM, BIOS FA507RM.315 11/30/2022
12 25 01:23:57 arch-laptop kernel: RIP: 0010:native_queued_spin_lock_slowpa=
th+0x67/0x2e0
12 25 01:23:57 arch-laptop kernel: Code: 0f 92 c2 8b 01 0f b6 d2 c1 e2 08 3=
0 e4 09 d0 3d ff 00 00 00 0f 87 1e 02 00 00 85 c0 74 10 0f b6 01 84 c0 74 0=
9 f3 90 0f b6 01 <84> c0 75 f7 b8 01 00 00 00 66 89 01 65 48 ff 05 ad af ed=
 01 c3 cc
12 25 01:23:57 arch-laptop kernel: RSP: 0018:ffffd4c4c06e3a30 EFLAGS: 00000=
202
12 25 01:23:57 arch-laptop kernel: RAX: 0000000000000001 RBX: ffffd4c4c06e3=
b10 RCX: ffff8d69446aa698
12 25 01:23:57 arch-laptop kernel: RDX: 0000000000000000 RSI: 0000000000000=
001 RDI: ffff8d69446aa698
12 25 01:23:57 arch-laptop kernel: RBP: ffffffff94118f38 R08: 0000000000000=
000 R09: 0000000000000000
12 25 01:23:57 arch-laptop kernel: R10: ffff8d6fa1e38340 R11: ffff8d6fbe2d6=
000 R12: ffff8d6c5aaf8000
12 25 01:23:57 arch-laptop kernel: R13: ffffffff91d15410 R14: ffff8d69446aa=
680 R15: ffff8d69446aa680
12 25 01:23:57 arch-laptop kernel: FS:  0000000000000000(0000) GS:ffff8d700=
deaf000(0000) knlGS:0000000000000000
12 25 01:23:57 arch-laptop kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000=
080050033
12 25 01:23:57 arch-laptop kernel: CR2: 00000000100af568 CR3: 000000020da24=
000 CR4: 0000000000f50ef0
12 25 01:23:57 arch-laptop kernel: PKRU: 55555554
12 25 01:23:57 arch-laptop kernel: Call Trace:
12 25 01:23:57 arch-laptop kernel:  <TASK>
12 25 01:23:57 arch-laptop kernel:  _raw_spin_lock+0x29/0x30
12 25 01:23:57 arch-laptop kernel:  __list_lru_walk_one.constprop.0+0x94/0x=
1d0
12 25 01:23:57 arch-laptop kernel:  ? __pfx_rust_shrink_free_page_wrap+0x10=
/0x10
12 25 01:23:57 arch-laptop kernel:  ? __pfx_rust_shrink_free_page_wrap+0x10=
/0x10
12 25 01:23:57 arch-laptop kernel:  list_lru_walk_node+0x46/0x1f0
12 25 01:23:57 arch-laptop kernel:  ? __pfx_rust_shrink_free_page_wrap+0x10=
/0x10
12 25 01:23:57 arch-laptop kernel:  rust_helper_list_lru_walk+0x9d/0xe0
12 25 01:23:57 arch-laptop kernel:  do_shrink_slab+0x140/0x350
12 25 01:23:57 arch-laptop kernel:  shrink_slab+0xd7/0x3e0
12 25 01:23:57 arch-laptop kernel:  shrink_one+0xfe/0x1d0
12 25 01:23:57 arch-laptop kernel:  shrink_node+0xb4a/0xd60
12 25 01:23:57 arch-laptop kernel:  ? pgdat_balanced+0x83/0x140
12 25 01:23:57 arch-laptop kernel:  kswapd+0x870/0x1100
12 25 01:23:57 arch-laptop kernel:  ? __switch_to+0x103/0x3f0
12 25 01:23:57 arch-laptop kernel:  ? __pfx_kswapd+0x10/0x10
12 25 01:23:57 arch-laptop kernel:  kthread+0xfc/0x240
12 25 01:23:57 arch-laptop kernel:  ? __pfx_kthread+0x10/0x10
12 25 01:23:57 arch-laptop kernel:  ret_from_fork+0x1c2/0x1f0
12 25 01:23:57 arch-laptop kernel:  ? __pfx_kthread+0x10/0x10
12 25 01:23:57 arch-laptop kernel:  ret_from_fork_asm+0x1a/0x30
12 25 01:23:57 arch-laptop kernel:  </TASK>

rust/helpers/binder.c=EF=BC=9A
unsigned long rust_helper_list_lru_walk(struct list_lru *lru,
                                        list_lru_walk_cb isolate, void *cb_=
arg,
                                        unsigned long nr_to_walk)
{
        return list_lru_walk(lru, isolate, cb_arg, nr_to_walk);
}

It appears that there exists a patch addressing this issue:=20
'rust: binder: stop spinning in shrinker' [4]=20

I have tested this patch, and it appears to resolve the soft lockup
issue.=20

Could this patch be picked up to fix the regression?

[1] https://github.com/waydroid/waydroid/issues/2163
[2] https://bbs.archlinux.org/viewtopic.php?id=3D311223
[3] https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issue=
s/174
[4] https://lore.kernel.org/all/20251202-binder-shrink-unspin-v1-1-263efb9a=
d625@google.com/

regards,
Ban ZuoXiang


