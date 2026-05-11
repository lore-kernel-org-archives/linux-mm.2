Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2F5CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B302E6B008A; Mon, 11 May 2026 07:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08846B0093; Mon, 11 May 2026 07:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D466B0095; Mon, 11 May 2026 07:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 913B06B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:20:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E43F8D1D4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:20:10 +0000 (UTC)
X-FDA: 84754894980.03.F80EB85
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4594B20014
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:20:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q6tx2CBO;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778498408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcuEfmKzpANWPxZKVVmyF91NQ+lO12DPxpVfBF6zcDI=;
	b=qlUAHiCbt3D1jR1rlvsBE7VQeO/h2UTknADnsEXuIu770g1AYBluxwCGk9KztRcZLlGXtd
	DTw0Kb3biIj14bu5Ctoe/5mnzZI8sBMSqtg2jrowxzn4IonbhLeul1c2ZId5v4gNX4PP5l
	A3R9hK0e5wseVNlMRbZRi9mnMANHOcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778498408; a=rsa-sha256;
	cv=none;
	b=C3c+qR+YESoOR69v09EjlhMQXIXVKOqXBasejkA7V/cjKY/1EiFcqyczzCZw5qsB9yTf89
	9985a5GiE8n44j3JclwBvOL8B1rsOYueN/bo/g+HsawjYn305jKg0azrbUcdgV9ReFdFXD
	rP6fPw8se91/2KqJ9ZhPgjP9n2HCKgQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q6tx2CBO;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=tcuEfmKzpANWPxZKVVmyF91NQ+lO12DPxpVfBF6zcDI=; b=Q6tx2CBOyF19Sw3lyvD2aX4CWJ
	e3JE12ONheF4CnuwKM8P53FA5teqEK5vWFf1FS2/PaI388PcAsoyev3kQxsWnSabDljA81y4pyW6K
	rzo23OmFgRtVRWqUg+xcARoebJMD6vEGaH5sqJk2Q1S8DStbeQOErBDy9LSoDqIxTwoMbb05aEJJK
	gLEnUpYhJLoJhQHlOlDCWnlNDylYW47c8rx8+fW2AfOZad4N/pE7M+Ena/IO+SpqYQuhnUqu/sDnM
	yNdvsagec1ydHUKS8W0jVbPDoolpL6fvLiGWszUCKsHhCAKyrR0XIttYbIyd9rUemhd3jkjLdGnx9
	hOqxrP+Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMOg0-001YwC-0h;
	Mon, 11 May 2026 11:19:56 +0000
Date: Mon, 11 May 2026 04:19:50 -0700
From: Breno Leitao <leitao@debian.org>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 09/12] mm, swap: use the swap table to track the swap
 count
Message-ID: <agG6Dp0umhs6O1SY@gmail.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
 <20260218-swap-table-p3-v3-9-f4e34be021a7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260218-swap-table-p3-v3-9-f4e34be021a7@tencent.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4594B20014
X-Rspam-User: 
X-Stat-Signature: 3dkaxnztfzb875ia9m7xbzwf3pb618uy
X-HE-Tag: 1778498407-694927
X-HE-Meta: U2FsdGVkX190V7SKUbajE3KOpogTRtUPce38MxerVaj6vaJsWRtie5c7aaWfi46hrbR4DSIXhtNMvaX7w6AlYU0mluUHIsTyAGbvgfFG7VnrfuqQClo/mXczc/sEib8LhVycrzyxf/eQ66EosQLxxo2QTWcswrJKpbOo/Ak1gNSjflJa8PRsFMwHQO64vcAnuvJcPA4mW/ibDcMP95TtLQFKYqM2Q68QM4grt70zAW3tbb63pW9SUDLi9rjslLv8TxATcjVumGXzrhIuBKhdU4zNbxmFvn4TgjFUPP3MuJxIdJJrvMSlM4sKtJMwjzs1odj2Pfpm1RH6EKq1kXDxBXamXvUf5HJeuCGB9AOQj6Lb9TGgpPrWOCaZ6TfJHNrvDg/08Nybx7/f4iOP35fk6WD55zVALzeoYgcrF90QaMZDlrfmGnw75p1/z4YfKdjzx44OD0+H8Gm2xE5kJY58HRGORuLFI4JnzpdfowcmeBbu1iJT19vGLjL6T9gPqUH6j5FHycVmLbCQMpm4J1G3/QnC7dHc1WzZ4WwxDmlQf6XM32BOnqOETtT+X4qrZ0a7UA0pTZNzxVgq5n8WT+afMvgQOx+7y5HdAZd0F1OYBzaXOHuQQtlnlIOtfHPIYH16+CMqUBckSTNbKtnHLxgIb66FI2ZroMAZPoUV5qLLj8/ZduDsD+KyejY6gpi+TXLbaej3nptxxWreB8ZfVcbGRP/9mQdqL7DQVA2tre/XoASdvetKnVzgSWXyPZy7f2bRmShQcPwPVhiKEMTgzAilRCUM9ir5UBfP7gzueE05VuqKdgjo8HdxvmLgnBIvKh+cdTiRxYp3fyszdusHrH+B3U6anP0vPlmVcosSmWk+ZNqIrzXEJBfEeE+4Og75JzSPQ5438b+CifRS5ViJJ8N+5N3kijUbfESK42oSZfymncUNnB+Ly/ymOjmAoG99whswEp95jizWkEC7ieZdYhK
 QpkeK+v9
 2qPaQqhfzXzAle7r9pHnago6MDYRQYTHqM5MaZcVXBl4OZjlk12kCXEvmSksg1jJwcFdsx5gukYdEb8SBgxsEcsZya+WQ6SVEbboDNX2CutDlJEaxv0TuuPrmDmUO4PzHsb5xCzSXf4ZDc0EQfYF+3TdcbmW4bVKNwrx+o3E5D472+Fpx1xUL+dXE05jfZtYMd1AeJwY06ames67F1xEUta7UTp23sasSLd3xEeQqB89uiaYUeVdUmgJ81XO5ounWBynTaww0Z0xoxgAK4TDIlL7igw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kairui,

On Wed, Feb 18, 2026 at 04:06:34AM +0800, Kairui Song wrote:
> @@ -479,6 +469,7 @@ static void swap_cluster_assert_empty(struct swap_clu=
ster_info *ci,
>  	} while (++ci_off < ci_end);
> =20
>  	WARN_ON_ONCE(bad_slots !=3D (swapoff ? ci->count : 0));
> +	WARN_ON_ONCE(nr =3D=3D SWAPFILE_CLUSTER && ci->extend_table);

On my automatic tests with 7.1 kernel I am seeing the following warning.

The test was running on commit 74fe02ce122a6103f20 ("Merge tag
'wq-for-7.1-rc2-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/=
wq").

This happened only once so far.

   WARNING: mm/swapfile.c:471 at swap_cluster_assert_empty+0x1b6/0x1d0, CPU=
#2: swapoff/1265108  =1B[36m[warn]=1B[0m
   Modules linked in: sunrpc(E) squashfs(E) sch_fq(E) act_gact(E) tcp_diag(=
E) inet_diag(E) cls_bpf(E) intel_uncore_frequency(E) intel_uncore_frequency=
_common(E) skx_edac(E) skx_edac_common(E) nfit(E) x86_pkg_temp_thermal(E) i=
ntel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) evdev(E) iTCO_wdt(E) ipm=
i_si(E) irqbypass(E) ipmi_devintf(E) xhci_pci(E) acpi_cpufreq(E) wmi(E) ipm=
i_msghandler(E) button(E) i2c_i801(E) xhci_hcd(E) i2c_smbus(E) sch_fq_codel=
(E) ip_tables(E) ip6_tables(E) vhost_net(E) tun(E) vhost(E) vhost_iotlb(E) =
tap(E) tls(E) mpls_gso(E) bpf_preload(E) mpls_iptunnel(E) mpls_router(E) fo=
u(E) drm(E) loop(E) backlight(E) drm_panel_orientation_quirks(E) autofs4(E)=
 raid0(E) efivarfs(E) dm_crypt(E)
   CPU: 2 UID: 0 PID: 1265108 Comm: swapoff Tainted: G S          E       7=
=2E1.0-0_fbk701_debugnightly_rc0_upstream_76_g74fe02ce122a #1 PREEMPTLAZY=
=20
   Tainted: [S]=3DCPU_OUT_OF_SPEC, [E]=3DUNSIGNED_MODULE
   Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09M3A09=
 07/03/2023
   RIP: 0010:swap_cluster_assert_empty+0x1b6/0x1d0
   Code: e8 03 48 b9 00 00 00 00 00 fc ff df 0f b6 04 08 84 c0 75 1a 41 0f =
b7 07 39 c3 74 99 0f 0b 81 7c 24 08 00 02 00 00 74 97 eb be <0f> 0b eb ba 4=
4 89 f9 80 e1 07 fe c1 38 c1 7c da 4c 89 ff e8 12 46
   RSP: 0018:ffff8882a2257a48 EFLAGS: 00010286
   RAX: 1ffff1106956192d RBX: 0000000000000000 RCX: dffffc0000000000
   RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8884dbeeaff8
   RBP: ffff8884dbeeaff8 R08: ffff8884dbeeafff R09: 1ffff1109b7dd5ff
   R10: dffffc0000000000 R11: ffffed109b7dd600 R12: ffff88834ab0c960
   R13: 0000000000000200 R14: ffff88834ab0c968 R15: 0000000000000200
   FS:  00007fab994cf800(0000) GS:ffff88909c8c0000(0000) knlGS:000000000000=
0000
   CR2: 00007f789da9b110 CR3: 00000004bdc63001 CR4: 00000000007726f0
   PKRU: 55555554
   Call Trace:
    <TASK>
    __free_cluster+0x2f/0x180
    swap_cache_del_folio+0x120/0x240
    folio_free_swap+0x51b/0x630
    ? folio_free_swap+0x2e6/0x630
    try_to_unuse+0x216d/0x2470
    ? try_to_unuse+0xbc9/0x2470
    __se_sys_swapoff+0x3fb/0x8e0
    do_syscall_64+0xfa/0x990
    ? irqentry_exit+0x102/0x770
    ? trace_irq_disable+0x64/0x1c0
    ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
    entry_SYSCALL_64_after_hwframe+0x4b/0x53
   RIP: 0033:0x7fab996ac08b
   Code: 0f 1e fa 48 83 fe 01 48 8b 15 89 ad 0c 00 19 c0 83 e0 f0 83 c0 26 =
64 89 02 b8 ff ff ff ff c3 f3 0f 1e fa b8 a8 00 00 00 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 8b 0d 5d ad 0c 00 f7 d8 64 89 01 48
   RSP: 002b:00007fff9cde2488 EFLAGS: 00000202 ORIG_RAX: 00000000000000a8
   RAX: ffffffffffffffda RBX: 00007fff9cde3e98 RCX: 00007fab996ac08b
   RDX: 0000000000000001 RSI: 0000000000000c00 RDI: 000055bfaf2199b0
   RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
   R10: 00000000000000bf R11: 0000000000000202 R12: 0000000000000000
   R13: 000055bfaf211479 R14: 000055bfaf212b00 R15: 000055bfaf212ad8
    </TASK>
   irq event stamp: 0
   hardirqs last  enabled at (0): [<0000000000000000>] 0x0
   hardirqs last disabled at (0): [<ffffffff81441ab3>] copy_process+0x833/0=
x32b0
   softirqs last  enabled at (0): [<ffffffff81441ab3>] copy_process+0x833/0=
x32b0
   softirqs last disabled at (0): [<0000000000000000>] 0x0


Decodeding the stack, I see the following file:lines (against the same
commit as above (74fe02ce122a6103f20))

  swap_cluster_assert_empty+0x1b6   mm/swapfile.c:471   WARN: nr =3D=3D SWA=
PFILE_CLUSTER && ci->extend_table
  __free_cluster+0x2f               mm/swapfile.c:585   (return from swap_c=
luster_assert_empty)
                                        then swap_cluster_free_table at lin=
e 586
  swap_cache_del_folio+0x120        mm/swap_state.c:298 __swap_cache_del_fo=
lio()
                                        (chain __swap_cluster_free_entries =
=E2=86=92 free_cluster =E2=86=92 __free_cluster all inlined)
  folio_free_swap+0x51b             mm/swapfile.c:2037  swap_cache_del_foli=
o(folio)
  folio_free_swap+0x2e6             mm/swapfile.c:2034  if (folio_maybe_swa=
pped(folio))
  try_to_unuse+0x216d               mm/swapfile.c:2628
  try_to_unuse+0xbc9                mm/swapfile.c:2592  unuse_mm() chain
  __se_sys_swapoff+0x3fb            mm/swapfile.c:2903
  do_syscall_64+0xfa                arch/x86/entry/syscall_64.c

Does it ring a bell?
--breno

