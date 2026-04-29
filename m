Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C45FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61ADF6B0088; Wed, 29 Apr 2026 08:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBA66B008A; Wed, 29 Apr 2026 08:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA156B008C; Wed, 29 Apr 2026 08:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3871E6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:47:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FCC340149
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:47:09 +0000 (UTC)
X-FDA: 84711568578.26.55EB528
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C102A000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:47:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=baylibre-com.20251104.gappssmtp.com header.s=20251104 header.b=hWl6uIH9;
	spf=pass (imf25.hostedemail.com: domain of aarsenovic@baylibre.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=aarsenovic@baylibre.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777466827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGKOO4lpFnOw96SqYoA6Gz/B51JtRhqSbM4Rk15rzpM=;
	b=SVeTPiebMFW5vz8BjEj8mOTMYQ2nrGbyRVlWlUmnUNaU4XPoAWG+7KJ6rPNLr9zi2us2NF
	EPhDSP7jg0OUsI4trYCjRNUAXKMQvy/gdswx7b8Aaoa239dp02R8r62t0ooBq37jwJDvrf
	HzkOuCyC7UXiWvYy3DoegxUVb802cKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777466827; a=rsa-sha256;
	cv=none;
	b=zbSRfGuZXOvXjshNPfM0heRTe5pZHLrrqfcjjbmsnuBskCl0c/22YF6Q5FvD5zb+2QZG7L
	WLPUYNrPGEXMi12ORAOLF/Kmp5gS2z8C3qv3ELHSjZBwFuCDbgXHpIXOUBXnIQq4yzq87J
	HITvKHn8wMoPxtOvUN2XyRV9/Mlm+Jc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=baylibre-com.20251104.gappssmtp.com header.s=20251104 header.b=hWl6uIH9;
	spf=pass (imf25.hostedemail.com: domain of aarsenovic@baylibre.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=aarsenovic@baylibre.com;
	dmarc=none
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4891cd41959so109087295e9.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777466826; x=1778071626; darn=kvack.org;
        h=mime-version:message-id:date:user-agent:references:organization
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LGKOO4lpFnOw96SqYoA6Gz/B51JtRhqSbM4Rk15rzpM=;
        b=hWl6uIH9peD5s2CMpbwN5Fz3E9dsrsqwyY9F/a09yC5siggpUeP0Q2eCTqYaSj1onJ
         YFByb7+/JHrl/2xpqU9Q2flmIxLd7bj2FmaI0K9DFhx93EC1lDvfAjmnpiYNxSrWq5MW
         Ly0qf6nzTEoonGfsWTptKFYmGnkSahejuLdX+1+ixS9CzOeLZ1NaQxhVVamedu70Nw6L
         XcWvUWt+FcRPA9s+7wsSRG2gfI0LXmJmoBwYcuBEO6AhQ2ZjfT0Dtvu7hDM0NFVxyztx
         OSFG+TG+bx9T/HxstngCa1GgX2omBLuLE95OUhMbxRimGZgu9IQEH1YPPvw7yxR3XWbA
         tUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777466826; x=1778071626;
        h=mime-version:message-id:date:user-agent:references:organization
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LGKOO4lpFnOw96SqYoA6Gz/B51JtRhqSbM4Rk15rzpM=;
        b=jPrZlxFUaWqlh5J4DEPywKFvSKwPjv18IR+R7ytQ6h7XycDdE+C5a6U39mqFQwLKHw
         TwwTULVFBtN8gmrQC4KnVlHCZeZ1cXpxVsIdMs9tCrjNk6WjfgGTuDts8QMhne29MFR3
         it08CPMPDnFhHJNxUNKm/LrE4tdsFbTZJSI2cROuTZd35nWZzldLTDx3NF6nk8VsEFsY
         YBkShDAPp009ZTFPkayLULlqq5PhRDQZkJTbPnYYnbFlF64wi5lVC2Ndt5HApZ4QVBN0
         1boCcvacjhVMYi8jmciZkcEQ4SDFttNAp7Ukv/Mkaxce/31QM+ZVZyO8FVJucbsJEvcq
         4vOA==
X-Forwarded-Encrypted: i=1; AFNElJ/091Q8IxGVsA18D5taVxdmaP32JgzZf66yZqZLHrg1rMRZW6/ofJtJkhxSeSaw8oDS3S6xI0yc9Q==@kvack.org
X-Gm-Message-State: AOJu0YwEf60FhYEXwSx4gwTeskx7RMpvjlSzxjtR8fd9shS60xosGhjH
	Ltof5Y67v420orzz12BVyrPGu8A1qGO92Q6moRdeFn4rnwVOqAPu2Qr50KtgscxTYJ8=
X-Gm-Gg: AeBDieuT7NLK9RvCufxXmE/xyTdJnWAVplahLpSxP3NatTPjAPfUYivOU1qa+VC+16F
	8XOuPJc875/eVKEzaRDBTtW3k2bNLGGllfYrhi3rsYtIHJrsjM7dG5A8kWSHs6dnQjPTpua21+c
	9ayfG+IlwJMddIWSUxZLsbwiiMPsLyhZZLLQr8zZerecEpHAAMUl3PMBdwHz/mcZXnmw6iAbZQ4
	WnroXy560/rvj81x/2U08a6Qm1BtOj55CTIe5JFiyUG+ECIReXeJNmNJUc2cD1w21X3t8Yjhq04
	dFwhfDb5cksTRO/mkSLj7iTEb+8jsppNN/U6XbkLadxZjPM3nRVWA6tPH7NsYB7ixp+egxSyFof
	VtzzaMqtemwamHr7dZwqPbx+aN9NDIc6fOk4cfZTVJchQ6taL6jSuz6EhIjaqK+aUVtmZclLe1N
	yxZhiSKYDQirhybco669s5PwsLlmzbADguT/G1iK8=
X-Received: by 2002:a05:600c:630a:b0:487:1fb4:7e1 with SMTP id 5b1f17b1804b1-48a77b0ee3emr144763825e9.22.1777466825067;
        Wed, 29 Apr 2026 05:47:05 -0700 (PDT)
Received: from bstg ([146.70.193.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c32afd4sm18360325e9.36.2026.04.29.05.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:47:04 -0700 (PDT)
From: =?utf-8?Q?Arsen_Arsenovi=C4=87?= <aarsenovic@baylibre.com>
To: amd-gfx@lists.freedesktop.org,  linux-mm@kvack.org
Cc: cs-tech-ext@baylibre.com
Subject: Re: [BUG] Frequent hangs or WARNINGs when using heterogeneous
 memory with an AMD MI210 GPU
In-Reply-To: <86ecjz2hhr.fsf@baylibre.com>
Organization: BayLibre
References: <86ecjz2hhr.fsf@baylibre.com>
User-Agent: mu4e 1.14.0; emacs 31.0.50
Date: Wed, 29 Apr 2026 14:47:02 +0200
Message-ID: <86tssu0w8p.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C102A000C
X-Stat-Signature: u4fymr8ux7jo6k8t5iqmxsnbni88hb9x
X-Rspam-User: 
X-HE-Tag: 1777466827-429746
X-HE-Meta: U2FsdGVkX1/3NbkYTv7g3CSzzJ7At+sN0G3Cc9weGJC8GFl6mGsibhMz3JWt0eoIaE1kubOR2wYH5jYKOFRCKrFN8sioEeL3w4vgObaYPlIJbX4htTGyzLAIS/lronLwV6SlkKEFc28I9EGb9NEiQqTT/Fdpqm+vcNP1llKLw7Rg/RJ0xNoVYWK6oNoL5+NttJDaVUyF+XwzeONHAC7sRlSMXxuzSvxblTaamOLi+qEqO6HCWGXtSXXRY6jb6eTwPMXuvtUtx6Cu020BXRtw93+2usfEagz0u3USewP5VvZDhsP23KnacZRyp+w189kVXsm1MKDlSOSH3GKK5B9DvmQyZKYDr04TnZrT45n6ihgeDGBV9qofvEM6g86dSbYLBu5QBtrDC8Um91Qyn8mOIrnFl2Oui3k9MHBhDPQVKow4slgrgjoZYnVln7rIymTrAjBkCNIsfNYvJu8LBZgidpLY+aqk6RQs4KvYjuCmyi1wCvPY2087/S8q6x81IS2CIK6rA84VZdpXWlBapv6xttnZ+2IR9EWO5U2IZGgA5Jg/izZkSclqYbrKHqQDT38w2Y3YcWNEhVA+MKbZTX8Agd1whZzV+AhWKD5AyGzQe7HZWGznjOWKOU+Y6vi+k6qTsVXUhBs3di6QTc5ehoJUPNKxqK1k12g8L5QTpbzmLJaImIOW7YP2LgY7tylsoM/O9Xqv44WQwDsPj7jupDRqe1mpFMg+MUz+BHz0pn2lHM9dTK1EzcHMq8uPP/zacoBq4KPHirpsx9OboJsBnClIMm8XsdLNjDXgWAuqp0hJlLhQZeZZODt+zC60IuGYmJz6YKKkg+tHY5krRtvqUG0lNtKrp2T5WYaTF/W7QFhzc497INZ24/sYDF0a2nJesfClzluAPkJ6EnZsx9ojOeslbl9cIlGN2hDQsaBaNct/CU56iE6GPFCFOMf5Ks+Vjd+r7Ydnyhj20IiqhqA0hAu
 F6AKMICA
 HPc+VwrmeLbz7E1CCYYtoDK+JAzecZm+Bt+IIbcXsH3i8CD5iTZHVCpWv6qMRzxL7VR7Qeqy2g9zLHhvaRg5z4AGSbIf/VMO2/syIqny69NrZrXOfNhT59Ub5cXPo5ltzAsbCTFTKJH5SEVIxq5qy2tulby6RH+ua66pY+X8B60Lc/CD6cyWyi7ZBW7nD2S1+ywOV0DFKXnIKbuAdpggLUd91SbK60kkaEpoXWaYBzavaU03VQMsR6jst5pfxjbP/05CI26ShV8E1AgjdH+qY9S45qXusWioF7xOqDErnAGBIZxO5+TbveD3jQOeDC76sLkM2O98+bQsh/CfimJwEZrLZgobk4Zc/QLELTtNtyNofgKuDnQphBTiwjQ1+Mstdm3fl2ETgup9I8U2QnC3utratG/0duzc1LWTR+EkFKGRlB/zIEEHdM6PdIyc1eJADc56GnNkV3GvAEOypciOU1i8EqEUIWlkJ45IIcI3y8IYPnEqnzb1otleMXiAWKMq137nnGW+0GZtAjTecfHPtKJbq828P48w2yq2zWwdUPj0QPOY7LJFbkwd3Wj7MUpqaQmfbcfpri4cbRAP9SwDAqshRbtqNvfRTxH8WN5mpJYFKy5PcXOarRBktE2Aor0Bv2bID20e7zICShCHFn+5ILdXIcfDE7SwhaIQH2pObTnMyCpPzKh8Nu+KG03m7eDw25is48FXokGGpnt3f2TYx+GUc9g+EbzeI+QxwTejfTBAtKGGamynSkojPXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Arsen Arsenovi=C4=87 <aarsenovic@baylibre.com> writes:

> We get this by running the following OpenMP program built for offloading
> onto an AMD GPU:
>
>   https://gcc.gnu.org/cgit/gcc/tree/libgomp/testsuite/libgomp.c++/pr11969=
2-1-4.C
>
> ... built by:
>
>   x86_64-none-linux-gnu-g++ pr119692-1-4.C -foffload=3D-march=3Dgfx90a \
>     -Wl,-rpath,/opt/rocm/lib -fopenmp -O2 \
>     -DDEFAULT=3D'defaultmap(firstprivate)' \
>     -lm -o ./pr119692-1-4.exe
>
> ... using trunk GCC configured for amdgcn-amdhsa offloading[1] and
> executed as:
>
>   timeout --verbose 10s env HSA_XNACK=3D1 LD_LIBRARY_PATH=3D. ./pr119692-=
1-4.exe
>
> ... when the timeout happens (i.e. the program gets stuck for 10 seconds
> and then, when 10 seconds pass, timeout sends a SIGTERM to a.out, and
> results in the crash above).

I've now confirmed that it is possible to reproduce this specific issue
also on bare metal, also with kernel 7.0.2 and ROCm 7.2.2 (using the
rocm/dev-ubuntu-22.04:7.2.2 Docker image):

  [ 1171.959571] ------------[ cut here ]------------
  [ 1171.959577] WARNING: mm/memory.c:1753 at unmap_page_range+0x10d5/0x1bc=
0, CPU#247: pr119692-1-4.ex/143761
  [ 1171.959613] Modules linked in: xt_iprange xt_LOG nf_log_syslog xt_comm=
ent amdgpu amdxcp drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks gp=
u_sched drm_suballoc_helper video drm_buddy drm_display_helper cec rc_core =
iptable_nat iptable_filter vhost_vsock vmw_vsock_virtio_transport_common vs=
ock vhost vhost_iotlb nf_conntrack_netlink xt_nat veth vxlan ip6_udp_tunnel=
 udp_tunnel xt_policy xt_mark xt_bpf xt_tcpudp br_netfilter xt_conntrack xt=
_MASQUERADE xfrm_user xfrm_algo xt_set ip_set nft_chain_nat nf_nat nf_connt=
rack nf_defrag_ipv6 nf_defrag_ipv4 xt_addrtype nft_compat nfsv3 nfs netfs o=
verlay 8021q garp mrp bridge stp llc bonding tls nf_tables nfnetlink binfmt=
_misc nls_iso8859_1 intel_rapl_msr intel_rapl_common amd64_edac edac_mce_am=
d kvm_amd ipmi_ssif kvm irqbypass rapl wmi_bmof pcspkr ccp input_leds joyde=
v mac_hid acpi_ipmi ptdma ipmi_si k10temp ipmi_devintf ipmi_msghandler nfsd=
 auth_rpcgss nfs_acl lockd sch_fq_codel dm_multipath grace scsi_dh_rdac scs=
i_dh_emc scsi_dh_alua sunrpc msr efi_pstore ip_tables x_tables
  [ 1171.959847]  autofs4 btrfs libblake2b raid10 raid456 async_raid6_recov=
 async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 hid_gene=
ric usbmouse igb bnxt_en ghash_clmulni_intel usbhid ast rndis_host ahci cdc=
_ether libahci dca usbnet hid i2c_algo_bit mii i2c_piix4 i2c_smbus wmi aesn=
i_intel
  [ 1171.959939] CPU: 247 UID: 0 PID: 143761 Comm: pr119692-1-4.ex Not tain=
ted 7.0.2-instinct-arsen #3 PREEMPT(lazy)
  [ 1171.959947] Hardware name: Supermicro AS -4124GS-TNR/H12DSG-O-CPU, BIO=
S 2.8 01/26/2024
  [ 1171.959951] RIP: 0010:unmap_page_range+0x10d5/0x1bc0
  [ 1171.959959] Code: 2e 2e 2e 31 c0 4c 39 b5 50 ff ff ff 0f 85 72 f2 ff f=
f e9 b1 fd ff ff 48 8b 45 90 48 8b 53 18 48 83 78 48 00 0f 84 28 f9 ff ff <=
0f> 0b e9 21 f9 ff ff a9 ff 0f 00 00 0f 85 cb fb ff ff 48 8b 10 83
  [ 1171.959964] RSP: 0018:ffffce40ffc87920 EFLAGS: 00010286
  [ 1171.959969] RAX: ffff8e18cb2ee900 RBX: fffff3333ffb6a00 RCX: 000000000=
0000000
  [ 1171.959973] RDX: ffff8e18de1b18c9 RSI: 0000000000000005 RDI: 000000000=
0000000
  [ 1171.959976] RBP: ffffce40ffc87a30 R08: 0000000000000000 R09: 000000000=
0000000
  [ 1171.959979] R10: 0000000000000000 R11: 0000000000000000 R12: ffffce40f=
fc87b90
  [ 1171.959983] R13: fffff3333ffb6a00 R14: 0000000000000001 R15: ffff8e18b=
a912018
  [ 1171.959986] FS:  0000000000000000(0000) GS:ffff8e57ac3da000(0000) knlG=
S:0000000000000000
  [ 1171.959990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 1171.959994] CR2: 000070d717bfe920 CR3: 0000004169a48002 CR4: 000000000=
0f70ef0
  [ 1171.960000] PKRU: 55555554
  [ 1171.960004] Call Trace:
  [ 1171.960008]  <TASK>
  [ 1171.960022]  unmap_single_vma+0x96/0x110
  [ 1171.960031]  unmap_vmas+0xa5/0x180
  [ 1171.960041]  exit_mmap+0x13b/0x400
  [ 1171.960060]  __mmput+0x45/0x170
  [ 1171.960068]  mmput+0x31/0x40
  [ 1171.960074]  do_exit+0x285/0xad0
  [ 1171.960083]  do_group_exit+0x2d/0xb0
  [ 1171.960090]  get_signal+0x86a/0x930
  [ 1171.960099]  ? kfd_ioctl+0x4ad/0x5c0 [amdgpu]
  [ 1171.960563]  ? srso_alias_return_thunk+0x5/0xfbef5
  [ 1171.960570]  ? __x64_sys_ioctl+0xbd/0x100
  [ 1171.960580]  arch_do_signal_or_restart+0x3a/0x250
  [ 1171.960608]  exit_to_user_mode_loop+0x8f/0x500
  [ 1171.960618]  do_syscall_64+0x2cd/0x14b0
  [ 1171.960626]  ? srso_alias_return_thunk+0x5/0xfbef5
  [ 1171.960631]  ? handle_mm_fault+0x1e8/0x2f0
  [ 1171.960640]  ? srso_alias_return_thunk+0x5/0xfbef5
  [ 1171.960646]  ? do_user_addr_fault+0x2ee/0x830
  [ 1171.960655]  ? srso_alias_return_thunk+0x5/0xfbef5
  [ 1171.960660]  ? irqentry_exit+0xa5/0x600
  [ 1171.960670]  ? srso_alias_return_thunk+0x5/0xfbef5
  [ 1171.960676]  ? exc_page_fault+0x94/0x1e0
  [ 1171.960682]  ? ret_from_fork+0x1b2/0x3a0
  [ 1171.960691]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [ 1171.960697] RIP: 0033:0x70d718dab9cf
  [ 1171.960704] Code: Unable to access opcode bytes at 0x70d718dab9a5.
  [ 1171.960708] RSP: 002b:000070d717bfda90 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
  [ 1171.960716] RAX: fffffffffffffffc RBX: 0000000000000003 RCX: 000070d71=
8dab9cf
  [ 1171.960720] RDX: 000070d717bfdb60 RSI: 00000000c0184b0c RDI: 000000000=
0000003
  [ 1171.960725] RBP: 00000000c0184b0c R08: 0000000040000001 R09: 000070d70=
8000dd0
  [ 1171.960728] R10: 000070d71902bc68 R11: 0000000000000246 R12: 000070d71=
7bfdc10
  [ 1171.960732] R13: 000070d717bfdb60 R14: 0000000031050b60 R15: 000070d70=
8000dd0
  [ 1171.960741]  </TASK>
  [ 1171.960746] ---[ end trace 0000000000000000 ]---

I'll try the other testcase we had (omptests t-unified-* all running in
parallel) later also.
=2D-=20
Arsen Arsenovi=C4=87

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEKBAEWCgCyFiEE/uKz0RP8AKMWLWBhUsKUMB6ixJMFAmnx/cYbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25z
Lm9wZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRGRUUyQjNEMTEzRkMwMEEzMTYyRDYw
NjE1MkMyOTQzMDFFQTJDNDkzGBxhYXJzZW5vdmljQGJheWxpYnJlLmNvbQAKCRBS
wpQwHqLEk4E4AQC5CgSws6LLnLmtU3wZ14OFUYn4xKYxLH2yciVFrXqTowEApQLv
P1UbHsAtGhQ/xBW489cM7DN7aHXnRS4wSij/ag8=
=mtuB
-----END PGP SIGNATURE-----
--=-=-=--

