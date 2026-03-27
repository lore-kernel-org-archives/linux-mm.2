Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35ED510A62E8
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC866B0099; Fri, 27 Mar 2026 10:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899956B009B; Fri, 27 Mar 2026 10:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783076B009D; Fri, 27 Mar 2026 10:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 619066B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:02:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAAC4C6C99
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:02:30 +0000 (UTC)
X-FDA: 84592008060.21.D7FA6BD
Received: from mout.web.de (mout.web.de [212.227.15.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id D8E591C000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:02:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=F3N7aG1u;
	spf=pass (imf20.hostedemail.com: domain of spasswolf@web.de designates 212.227.15.14 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774620149; a=rsa-sha256;
	cv=none;
	b=B4EQnDSt1L2xVnnGI0G57oYpNwIu8pKSdXpCaO5Sh+9ZzX+NFOuXTdZAu8jdh0RUw86q/R
	9THzsJ03ex+RBnnVe/sJ3ix1uEhlo/Wjub03eg5k5w/PKRssU6vzFYw4/dqn96Oi1ObNvp
	lOH+S8qMXOUewBEvFrAuAsYAcSs1azI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774620149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5WNyX5o+g15xOHk9Vvq0Jm9HTCv4IG83yFDt6da/xw=;
	b=xqk8ajBu0R56nnCJn4KZEn9IOPvgr1vzbFyMsudpKh7oM7aTgztroJiwT+dZXmSC8U+ni5
	Okndf/R2rMX/Y//xmXgh0oVX7dgTW8P4MD31HYZZJoHAEDybhq/gZmvGwLTspQ35B3MInC
	wn2YYCLgyw7SEMBj9DLoa+9baepXu6Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=F3N7aG1u;
	spf=pass (imf20.hostedemail.com: domain of spasswolf@web.de designates 212.227.15.14 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1774620076; x=1775224876; i=spasswolf@web.de;
	bh=b5WNyX5o+g15xOHk9Vvq0Jm9HTCv4IG83yFDt6da/xw=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=F3N7aG1uEdfN/GlCkl+MfA8Re5JxMOUE+SE5UxG3QN3kst4g7HE+4G65Uk4n3lOb
	 LEktcfB2PZbd1upgdIoqYtK4sDD7tS/h7z6m/SAdGcUt6ATd6ERBAsbi6Mfc1Wfyg
	 /lReru+FT3JPEfFj4UVbAIzuvrwdrOYXob8/IY3yOxomp9wAi4QmzbTW9dEcnrGjx
	 Z2sScXyT5bc2fKeEhDctS8PyeVjUjwXUNdfLa8bwQE1fM4e2J1HDlwSDSZkXJ1GDn
	 O7273i4leldfgb4S8y8WhLmr/jwRfKuXWDcVAFGrd+z4swQEwPCRtE+v8RP9/P7Ab
	 pD9WelTQ4fR816zY5w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MIL0C-1wIGpE1PSG-000jY3; Fri, 27
 Mar 2026 15:01:16 +0100
From: Bert Karwatzki <spasswolf@web.de>
To: Mike Rapoport <rppt@kernel.org>
Cc: Bert Karwatzki <spasswolf@web.de>,
	linux-kernel@vger.kernel.org,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	andreas@gaisler.com,
	ardb@kernel.org,
	bp@alien8.de,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	chleroy@kernel.org,
	dave.hansen@linux.intel.com,
	davem@davemloft.net,
	david@kernel.org,
	devicetree@vger.kernel.org,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	hannes@cmpxchg.org,
	hpa@zytor.com,
	ilias.apalodimas@linaro.org,
	iommu@lists.linux.dev,
	jack@suse.cz,
	jackmanb@google.com,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	lorenzo.stoakes@oracle.com,
	m.szyprowski@samsung.com,
	maddy@linux.ibm.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	robh@kernel.org,
	robin.murphy@arm.com,
	saravanak@kernel.org,
	sparclinux@vger.kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk,
	will@kernel.org,
	x86@kernel.org,
	ziy@nvidia.com
Subject: Warning from free_reserved_area() in next-20260325+
Date: Fri, 27 Mar 2026 15:01:08 +0100
Message-ID: <20260327140109.7561-1-spasswolf@web.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323074836.3653702-10-rppt@kernel.org> 
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jwEpGLTFv6lxOcQdrUyNC0xH05pvVO5X2lpgj2DKPAX3uJursNt
 rMMU5c9UYBeudcXm3uROLBUlLd91P7V68GG4LyDXEcXT6VaLDh0LZ1YG+XCaPdVoYoOLcoM
 6ALUn81ZBMWLAA1p/4bNmu+esn5JDVrdhOgeNUENyKINGIMiDu1TfLAFkxXs79H5JA1EM2S
 zXdMZt1RvAhW2Infl9yLg==
UI-OutboundReport: notjunk:1;M01:P0:a2oYlASDxJ0=;7fSVqPm/9Ziq6pTJ1ad0sJjua3w
 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
 z9TgiHwdLkEsHl1aKyb16FxJWyRVtIT/A==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8E591C000E
X-Stat-Signature: y1sw1txydijaxm81mrzgr8g3576oas8x
X-HE-Tag: 1774620148-766289
X-HE-Meta: U2FsdGVkX18s8jpypSOCqzGIdB254/+cOeibKUh2a7oRSEp8LQnUZjUavAy044DfC8amfeUwl4eu/0sYxcu7RofGxkfaDDu27UCJ+wlGyBVs8yk+NGe4uBhzxFzMk4c5w9PheT1MpCUVORrlvJmVJoa2Xe4/3VXbV3p3ywuPnUc87zTkqvGPig1s3769HeTPp6LCHsNIMDYwAXMMas4JTF8ScfI2L21JWMzxJ6KnYpEOidb+/X9QfVYpsGFDAXE85B0FIaBdn+cd7Ea/Xc0TLoPb0PXzv9TBkacbXmdVqEko0O0hXTSD6e0ZWVI58eUDqInls/DfUC4GXbxIpQRl4iTUvfWk7cWU46I22BIPhtbA+ZkZusxHaSxPTk2Rh9KK7AM1jDryO4FmSugHUeP10VgRRv7ZKiqZBsWooRRepQ0jSzgbAHXR2Js0hPH5sMPZ9H55qALxCiGh3hsNEhlTuepgRle/CIdog3VRzhy96lLxNEk2v41GBOJUqmFzDI1Yloe7RbFNfLS9BkQHdVvdOXp27tYbpFWonSWjNiwnNEKtjYOtT4kjLnG9UNQiOKozV2BB6mvYUn026NkOWYOLO8Ga/xH7poOtJRVj/4YYdjcwYRBD5K/sk6DU6Gfj5mx3fK9lZV1BMqCcF7EbqsZUU7TJXikhYxyHaFsil628c7sFB3/Uu2rzC7NdDurv/axS4Bcmc9bZMVY8FTfqgIUNAd6lfb2KIRJBMSZZBYfV6VnRZrdk2mxYrgYq2uuFlVH+6/nw7F21pkMHdUriUBoGmA6RE1jgAlO3h69c0F81xJoYHPYpocwLNzqKQ/VQ4mxdLe3fsECcMdwPFVIVzIsaupC236wuzjdwOtKpkIEJndF7WjEZ21OfOQrCt37jvQaeTk9oftnUETwDOQSsgnpGUlovp/K5xUONRR7ISQNlzBgvvOU0KgzUaddz4Qn3RtVU7fNJ8O4sGqGXeAZfwUp
 lI8vCEfx
 JT+ruN793k9mAKuNwtnSQwPWKmPocIn81CsyJvz21x2y9fPfMjeoD1BpYjst+XJyRg/ENTKJwcrM761a/YtrEcFdFmqi4wOVbbwBdfewWpfVSMzPqZXpSP3T1jiTG/1D8UjxZ1TEE+faN/8VF7dlZQAOpzYwqt5RB1rOM4+sBm0xQojakdkfUywhnv00LksSLOoG8hBOWOX6QYeuRjdUjE3ys1qUsFHM9HqHlntYq4d5tTHLdxMAoBvzpcaYuUlAH6zjKF0Etna7cRRRfTJHkkWETO45hnFTgrff0fpmK50KST77SIViUamysbXqERQtKnPRMBdl5bQbQIHuFx6qMUckwFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Starting with linux next-20260325 I see the following warning early in the
boot process of a machine running debian stable (trixie) (except for the ke=
rnel):

[    0.027118] [      T0] ------------[ cut here ]------------
[    0.027118] [      T0] Cannot free reserved memory because of deferred i=
nitialization of the memory map
[    0.027119] [      T0] WARNING: mm/memblock.c:904 at __free_reserved_are=
a+0xa9/0xc0, CPU#0: swapper/0/0
[    0.027122] [      T0] Modules linked in:
[    0.027123] [      T0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted =
7.0.0-rc5-next-20260326-master #385 PREEMPT_RT=20
[    0.027125] [      T0] Hardware name: ASUS System Product Name/ROG STRIX=
 B850-F GAMING WIFI, BIOS 1627 02/05/2026
[    0.027125] [      T0] RIP: 0010:__free_reserved_area+0xa9/0xc0
[    0.027126] [      T0] Code: 48 89 df 48 89 ee e8 06 fe ff ff 48 89 c3 4=
8 39 e8 72 a0 5b 4c 89 e8 5d 41 5c 41 5d 41 5e c3 cc cc cc cc 48 8d 3d 97 c=
2 c6 00 <67> 48 0f b9 3a 45 31 ed eb df 66 66 2e 0f 1f 84 00 00 00 00 00 66
[    0.027127] [      T0] RSP: 0000:ffffffff9b203e98 EFLAGS: 00010202
[    0.027128] [      T0] RAX: 0000000e91c00001 RBX: ffffffff9b100c0f RCX: =
0000000080000001
[    0.027128] [      T0] RDX: 00000000000000cc RSI: 0000000e2d42d000 RDI: =
ffffffff9b32ef60
[    0.027128] [      T0] RBP: ffff9eeafdd6fbc0 R08: 0000000000000000 R09: =
0000000000000001
[    0.027129] [      T0] R10: 0000000000001000 R11: 8000000000000163 R12: =
000000000000006f
[    0.027129] [      T0] R13: 0000000000000000 R14: 0000000000000045 R15: =
000000005c8a1000
[    0.027129] [      T0] FS:  0000000000000000(0000) GS:ffff9eeb21c05000(0=
000) knlGS:0000000000000000
[    0.027130] [      T0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.027130] [      T0] CR2: ffff9ee8ad801000 CR3: 0000000e2ce1e000 CR4: =
0000000000f50ef0
[    0.027131] [      T0] PKRU: 55555554
[    0.027131] [      T0] Call Trace:
[    0.027132] [      T0]  <TASK>
[    0.027132] [      T0]  free_reserved_area+0x89/0xd0
[    0.027133] [      T0]  alternative_instructions+0xee/0x110
[    0.027136] [      T0]  arch_cpu_finalize_init+0x10f/0x160
[    0.027138] [      T0]  start_kernel+0x686/0x710
[    0.027140] [      T0]  x86_64_start_reservations+0x24/0x30
[    0.027141] [      T0]  x86_64_start_kernel+0xd4/0xe0
[    0.027142] [      T0]  common_startup_64+0x13e/0x141
[    0.027143] [      T0]  </TASK>
[    0.027144] [      T0] ---[ end trace 0000000000000000 ]---

The Hardware used is this:

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 26
model		: 68
model name	: AMD Ryzen 9 9950X 16-Core Processor
stepping	: 0
microcode	: 0xb404035
cpu MHz		: 3607.683
cache size	: 1024 KB
physical id	: 0
siblings	: 32
core id		: 0
cpu cores	: 16
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 16
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtsc=
p lm constant_tsc rep_good amd_lbr_v2 nopl xtopology nonstop_tsc cpuid extd=
_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 =
movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_l=
egacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext p=
erfctr_core perfctr_nb bpext perfctr_llc mwaitx cpuid_fault cpb cat_l3 cdp_=
l3 hw_pstate ssbd mba perfmon_v2 ibrs ibpb stibp ibrs_enhanced vmmcall fsgs=
base tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a avx512f avx512dq=
 rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512=
vl xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_m=
bm_local user_shstk avx_vnni avx512_bf16 clzero irperf xsaveerptr rdpru wbn=
oinvd cppc arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasi=
d decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif x2avic v_=
spec_ctrl vnmi avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq =
avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid bus_lock_detect movdiri mo=
vdir64b overflow_recov succor smca fsrm avx512_vp2intersect flush_l1d amd_l=
br_pmc_freeze
bugs		: sysret_ss_attrs spectre_v1 spectre_v2 spec_store_bypass srso spectr=
e_v2_user vmscape
bogomips	: 8599.98
TLB size	: 192 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate cpb eff_freq_ro [13] [14]

$ lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Root Complex
00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge IOM=
MU
00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e GPP Bridge
00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e GPP Bridge
00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:02.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e GPP Bridge
00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e Internal GPP Bridge to Bus [C:A]
00:08.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e Internal GPP Bridge to Bus [C:A]
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev=
 71)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev =
51)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 0
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 5
00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 6
00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 7
01:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Upstr=
eam Port of PCI Express Switch (rev 25)
02:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Downs=
tream Port of PCI Express Switch (rev 25)
03:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] N=
avi 44 [RX 9060 XT] (rev c0)
03:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Navi 48 HDMI/D=
P Audio Controller
04:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD=
 9100 PRO [PM9E1]
05:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Upstream Port (rev 01)
06:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:08.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:0c.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
08:00.0 Ethernet controller: Intel Corporation Ethernet Controller I226-V (=
rev 06)
09:00.0 Network controller: MEDIATEK Corp. Device 7925
0b:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] 800 Series Chips=
et USB 3.x XHCI Controller (rev 01)
0c:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD] 600 Series Chip=
set SATA Controller (rev 01)
0d:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. =
[AMD] Raphael/Granite Ridge PCIe Dummy Function (rev c1)
0d:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 19=
h PSP/CCP
0d:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Raphael/Granite =
Ridge USB 3.1 xHCI
0d:00.4 USB controller: Advanced Micro Devices, Inc. [AMD] Raphael/Granite =
Ridge USB 3.1 xHCI
0e:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] Raphael/Granite =
Ridge USB 2.0 xHCI

Memory used is 64G:
$ LANG=3DC free
               total        used        free      shared  buff/cache   avai=
lable
Mem:        65500068     3584080    56709424       70916     5912256    619=
15988
Swap:       78125052           0    78125052


Bert Karwatzki

