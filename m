Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C27CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 18:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD746B0088; Mon,  5 Oct 2026 14:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48EA86B008C; Mon,  5 Oct 2026 14:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CDD6B0092; Mon,  5 Oct 2026 14:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD196B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:06:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 936F4A7065
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 18:06:05 +0000 (UTC)
X-FDA: 85289351490.10.6D5E5F6
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0758118000D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 18:06:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=q9zuw28R;
	spf=pass (imf24.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791223563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foeOtoGysb0MIpvLcbX94T3pLf1XsthWrnLQfmgltG4=;
	b=L1J9JsY/LYQRD3A3Wm+7r1mDFUGI+V33Qy0KiCid5U8ycZuOnu3O4eOZgIcjxBRkRe8kZm
	bOPy8UYCTc93Rw8FYO5jPR2/BEWFYg/ovHUEIar9Hq0fgWSaSjdlmB6RZRCPCz6nJ8mI43
	wSc/Jy+RJ/U8trYGz+MvWkAAaHuO3PU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=q9zuw28R;
	spf=pass (imf24.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791223563;
	b=zgL6600/lzOQWsBMzdVVtanKks5Hs8ZNzO0XZlb8V98GplqJ4zL4IzzXgSzddYaalSnL/G
	BkZk+dj3AJcS+fvXroF8XrczTfBlMHakXbmhhdBg9bhmUiCvUgLdqWEjGRMEVtprReO45m
	dauJO3gih01CUZlfdhDHAtuu4MQNB8s=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 695I5rhw4185375
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 20:05:53 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 695I5rhw4185375
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791223554;
	bh=foeOtoGysb0MIpvLcbX94T3pLf1XsthWrnLQfmgltG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q9zuw28RxOjWqGk1sXjyhJF6+HxvQDMHBmEEsxn93YqtjPg377cCa4fYO6F9J3Fcw
	 CiZECIJSJ4n4UyT+lhx8JPdKFJXWJ7xX4syhL2UbcTw1CG6vzMLAUIyifIjVcAI1s4
	 givVIwvJsBkbGvoFaU45yYBadWRFbTjrzeXNGLX0=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 695I5qFD038052
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 20:05:52 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 695I5osr2385358
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 20:05:52 +0200
Date: Mon, 5 Oct 2026 20:05:50 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Rik van Riel <riel@surriel.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <asPm/lpvmbG0SOdl@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <6047f10bc230a7d34628c0021373e407279bf3dd.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6047f10bc230a7d34628c0021373e407279bf3dd.camel@surriel.com>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0758118000D
X-Rspam-User: 
X-Stat-Signature: z5suan6qdkxgeknwpjun3eeuak5i4cff
X-HE-Tag: 1791223562-556017
X-HE-Meta: U2FsdGVkX19WP9lkAiHePzWvoRUW4/dqczP+X5qz2DD9TNmUxq3b36werXbPnLyWxW9PikG8qP8+y4Tb7f0/8B5lmnbdk/2FhUeP3mdi5aAEoXYptJRvOoZtOHtMshK/TaMjbYy2bZfldP0FYpTR05tFfo8MQJgNqexFqPC1ZLVEIfwPyjKvzu7TtQ9jMTN8QOx9yjrgu5VhRWJmFM5vncrgDyLOyyk+Ynqg0wjGaEJ20kz1oTYulDi5pua002rZZQSXiMMtqqVVwePf4bLyIR4DbbmjaUAivhj8g9OyRhA9Snhgx/m8VWhaLIaBCigRnXjAKDLGon8oFkagQkW1oCHQMfidWbvb7Jv3Sh4N1MJnKUDUG0M9o9UZGxLZ37mEexs+mluEO1DW45bnqvlAjpdIZf1SmLAkqg9llBut+8y8joc4N5GQ/eZ68hWL599Z4y6I97Y2YmlHII/Ci78n/eyOlscwdXjuBB/O7szfKHlMe/VVFRaibZz3+pZ0bXXUGjiPAP7arbL8EWdhQliPNrKNfCI2GrjgXLFBXa5/Gybz8OcaYt13I73EE004E+uFjNUbu0nSbxSYoWNb7tQ1RWVo2SBi6UyGqETG82IEMhsS/6yZhgcRwSv9xsdbwDz28RiKdq7NdIrGbpxQeb8GH50Nd+ivqOXit6snPSZvciCLJSmR/41xIMWifz8p8HNCG3hfcPvLYlygmU2GMq+QYOUwtSrXMkDABaqC2nVt9RtDTP6lLK0OcwMgtsh/74kYEF9e4bldLCe331xO+RlRNeESWmvYaVH+Qrz9qC0bfc3JvzZ2h6+OBkfRt+3E9DYQgq3B+ftDEVzZQOJnJbN33sqtNVwQ7jG7hMY/JaASWCoXOeQ8CSixuDwBjijp9i6a8MzhfnqxFboQF+bCXOakPbk0n6m24KUq/TtbZ6zFSwfTu8QHFb+oNCRcQJDUu9AdaLUFqiCJTT3sxrOOo9J
 xdUixbG4
 /BHv18GqMqreiTOpIC5/PgbPTL8ays7Mv4s4tYNG+k0cDKCagmeaJ2C+URUJ/9EZ/OFbTD9yARFhRymedYgBLqGouV/0VkAgEvYiB8ApM9RsIHn+ugvYNrQDgq9j/24NS9QZue3Q92VQFXriYxWLlSA9ffombQdzu+3ckkx/4n2YoomnlKXZ0j9gIpZISYXewLC6QYJCtGmHzMM//lPjRwB6zKthwUu6towDS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Oct 05, 2026 at 06:58:13AM -0400, Rik van Riel wrote:
> On Thu, 2026-10-01 at 21:40 +0200, Nikola Ciprich wrote:
> > 
> > Oops:
> > general protection fault, probably for non-canonical address
> > 0xfffffff0c930038
> > RIP: __d_lookup+0x4a/0xc0
> > Comm: systemd PID: 1274600 CPU: 23
> > Call trace:
> > __d_lookup
> > lookup_fast
> > walk_component
> > link_path_walk
> > path_openat
> 
> That is the exact same memory address as the
> crash in your original report.
> 
> Do you capture any crashes with other memory
> addresses, or do they always crash with this
> same address?
> 
> If it's always the same address, we may not
> be looking at random corruption at all, but
> instead at some bug that results in the same
> bad address every time.
> 
> That might narrow the problem space a little.

so far, I have kdumps of two same crashes on two different
hosts with slightly different kernel releases. addresses match
exactly:

[378185.135721] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
[378185.148870] CPU: 23 UID: 0 PID: 1274600 Comm: systemd Kdump: loaded Tainted: G            E       6.18.53lb9.02 #1 PREEMPT(voluntary)
[378185.166172] Tainted: [E]=UNSIGNED_MODULE
[378185.172827] Hardware name: Supermicro AS -2024US-TRT/H12DSU-iN, BIOS 3.5 09/22/2025
[378185.183364] RIP: 0010:__d_lookup+0x4a/0xc0
[378185.190380] Code: ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 30 6b d1 ff 48 8b 03 48 89 c3 48 83 e3 fe 48 83 f8 01 77 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3 4c 8d 63 78 4c 89 e7 e8 d
5 38 7d 00 4c 39 6b 10 74
[378185.215346] RSP: 0018:ffffb18962823c28 EFLAGS: 00010212
[378185.223709] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 000000000000000b
[378185.234087] RDX: ffff985ffd223600 RSI: ffffb18962823d70 RDI: ffff989ddf09b5c0
[378185.244431] RBP: 000000005560450b R08: 000000007fffffff R09: fefefefefefefeff
[378185.254732] R10: 0000000000000000 R11: 93c3d2eb02a31dda R12: ffff989ddf09b5c0
[378185.264980] R13: ffff989ddf09b5c0 R14: ffffb18962823d70 R15: 0000000000000000
[378185.275298] FS:  00007f63cba1ab40(0000) GS:ffff99d8de442000(0000) knlGS:0000000000000000
[378185.286668] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[378185.295750] CR2: 00007f23dc057de1 CR3: 0000010d88d86001 CR4: 0000000000770ef0
[378185.306316] PKRU: 55555554
[378185.312467] Call Trace:
[378185.318393]  <TASK>
[378185.323955]  lookup_fast+0x5e/0x100
[378185.330947]  walk_component+0x1f/0x150
[378185.338231]  link_path_walk+0x141/0x2a0
[378185.345633]  path_openat+0x99/0x2b0
[378185.352705]  do_filp_open+0xd3/0x180
[378185.359805]  ? srso_alias_return_thunk+0x5/0xfbef5
[378185.368178]  do_sys_openat2+0x8a/0xe0
[378185.375459]  __x64_sys_openat+0x69/0xa0
[378185.382936]  do_syscall_64+0x64/0xba0
[378185.390270]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[378185.399056] RIP: 0033:0x7f63cb8ff16b
[378185.406397] Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 91 00 00 00 48 8
b 54 24 28 64 48 2b 14 25
[378185.433112] RSP: 002b:00007ffc81349bb0 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[378185.444704] RAX: ffffffffffffffda RBX: 0000557015c3cb00 RCX: 00007f63cb8ff16b
[378185.455938] RDX: 0000000000080000 RSI: 0000557015ba2140 RDI: 00000000ffffff9c
[378185.467229] RBP: 0000557015ba2140 R08: 0000000000000008 R09: 0000000000000001
[378185.478566] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000080000
[378185.489776] R13: 0000557015c3cb00 R14: 0000000000000001 R15: 00007f63cc12b650
[378185.500884]  </TASK>
[378185.506899] Modules linked in: rbd(E) vhost_net(E) vhost(E) vhost_iotlb(E) tap(E) tun(E) ceph(E) libceph(E) cts(E) krb5enc(E) authenc(E) camellia_aesni_avx2(E) camellia_aesni_avx_x86_64(
E) camellia_x86_64(E) camellia_generic(E) cmac(E) krb5(E) dns_resolver(E) netfs(E) tcp_diag(E) udp_diag(E) inet_diag(E) netconsole(E) sctp(E) ip6_udp_tunnel(E) udp_tunnel(E) rfkill(E) nfnetl
ink_cttimeout(E) openvswitch(E) nf_conncount(E) nsh(E) nfnetlink_log(E) nft_log(E) nft_ct(E) nf_tables(E) nfnetlink(E) nf_nat_ftp(E) nf_nat(E) nf_conntrack_ftp(E) nf_conntrack(E) nf_defrag_i
pv6(E) nf_defrag_ipv4(E) sunrpc(E) kvm_amd(E) vfat(E) fat(E) kvm(E) amd_atl(E) irqbypass(E) acpi_ipmi(E) wmi_bmof(E) amd64_edac(E) edac_mce_amd(E) ipmi_si(E) pcspkr(E) acpi_cpufreq(E) ipmi_s
sif(E) i2c_piix4(E) i2c_smbus(E) k10temp(E) ipmi_devintf(E) wmi(E) ipmi_msghandler(E) i2c_core(E) sch_fq_codel(E) fuse(E) ext4(E) crc16(E) mbcache(E) jbd2(E) raid1(E) sd_mod(E) sg(E) nvme(E)
 ahci(E) libahci(E) nvme_core(E) ice(E) mpt3sas(E) nvme_keyring(E) libie_fwlog(E)
[378185.507010]  xhci_pci(E) raid_class(E) i40e(E) nvme_auth(E) libeth_xdp(E) ghash_clmulni_intel(E) hkdf(E) libata(E) libie(E) libeth(E) scsi_transport_sas(E) libie_adminq(E) xhci_hcd(E) sp
5100_tco(E) dm_mod(E) dax(E) aesni_intel(E)




[1924553.414736] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
[1924553.434800] CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr Kdump: loaded Tainted: G            E       6.18.44lb9.01 #1 PREEMPT(voluntary)
[1924553.456934] Tainted: [E]=UNSIGNED_MODULE
[1924553.465551] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 2305 11/21/2025
[1924553.484152] RIP: 0010:__d_lookup+0x4a/0xc0
[1924553.492878] Code: ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 60 8f d1 ff 48 8b 03 48 89 c3 48 83 e3 fe 48 83 f8 01 77 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3 4c 8d 63 78 4c 89 e7 e8
d5 e1 7c 00 4c 39 6b 10 74
[1924553.525191] RSP: 0018:ff7532a13699fda0 EFLAGS: 00010212
[1924553.534986] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
[1924553.546679] RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
[1924553.558367] RBP: 000000000b654440 R08: 0000000000002403 R09: 0000000000000179
[1924553.570026] R10: 000000000000000d R11: 0000000000000000 R12: 0000000001876e5c
[1924553.581601] R13: ff2e6d1e4e630d80 R14: ff7532a13699fe60 R15: 0000000000000000
[1924553.593115] FS:  00007ff8743aaa80(0000) GS:ff2e6e5e94c45000(0000) knlGS:0000000000000000
[1924553.605576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1924553.615611] CR2: 00007ffcd63a5000 CR3: 00000003ee840001 CR4: 0000000000771ef0
[1924553.627022] PKRU: 55555554
[1924553.633869] Call Trace:
[1924553.640353]  <TASK>
[1924553.646369]  d_lookup+0x27/0x50
[1924553.653366]  lookup_dcache+0x1f/0x80
[1924553.660713]  lookup_one_qstr_excl+0x1e/0xe0
[1924553.668589]  ? preempt_schedule_common+0x2c/0x70
[1924553.676837]  filename_create+0xc4/0x160
[1924553.684209]  do_mkdirat+0x5a/0x190
[1924553.691050]  __x64_sys_mkdir+0x42/0x60
[1924553.698163]  do_syscall_64+0x64/0xbf0
[1924553.705145]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[1924553.713533] RIP: 0033:0x7ff8754ff08b
[1924553.720358] Code: 8b 05 91 bd 0f 00 41 bc ff ff ff ff 64 c7 00 16 00 00 00 e9 4f ff ff ff e8 12 f7 01 00 66 90 f3 0f 1e fa b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d
bd 0f 00 f7 d8 64 89 01 48
[1924553.748552] RSP: 002b:00007ffc05e5c148 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
[1924553.759401] RAX: ffffffffffffffda RBX: 00005623cc0bd513 RCX: 00007ff8754ff08b
[1924553.769760] RDX: 000000000fde421b RSI: 00000000000001c0 RDI: 00005623cc0bd4f4
[1924553.780083] RBP: f49998db0aa753ff R08: 0000000000000004 R09: 0000000000000001
[1924553.790348] R10: 00007ff87587d000 R11: 0000000000000246 R12: 8421084210842109
[1924553.800604] R13: 00005623cc0bd513 R14: 00007ff8755bd740 R15: 000000000fde421b
[1924553.810819]  </TASK>
[1924553.815936] Modules linked in: binfmt_misc(E) ceph(E) libceph(E) dns_resolver(E) netfs(E) tcp_diag(E) udp_diag(E) inet_diag(E) sctp(E) ip6_udp_tunnel(E) udp_tunnel(E) netconsole(E) rfki
ll(E) nfnetlink_cttimeout(E) openvswitch(E) nf_conncount(E) nsh(E) nfnetlink_log(E) nft_log(E) nft_ct(E) sunrpc(E) nf_tables(E) nfnetlink(E) nf_nat_ftp(E) nf_nat(E) nf_conntrack_ftp(E) nf_co
nntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) vfat(E) fat(E) mlx5_ib(E) amd_atl(E) wmi_bmof(E) acpi_ipmi(E) ib_uverbs(E) cdc_ether(E) amd64_edac(E) usbnet(E) edac_mce_amd(E) ipmi_si(E) acpi
_cpufreq(E) pcspkr(E) mii(E) i2c_piix4(E) ib_core(E) ipmi_ssif(E) k10temp(E) i2c_smbus(E) ipmi_devintf(E) wmi(E) ipmi_msghandler(E) i2c_designware_platform(E) i2c_designware_core(E) i2c_core
(E) sch_fq_codel(E) vhost_net(E) tun(E) vhost(E) vhost_iotlb(E) tap(E) fuse(E) kvm_amd(E) kvm(E) irqbypass(E) ext4(E) crc16(E) mbcache(E) jbd2(E) raid1(E) sd_mod(E) usb_storage(E) sg(E) ahci
(E) libahci(E) mpt3sas(E) mlx5_core(E) xhci_pci(E) raid_class(E) mlxfw(E)
[1924553.816028]  ghash_clmulni_intel(E) scsi_transport_sas(E) libata(E) pci_hyperv_intf(E) i40e(E) xhci_hcd(E) libie(E) sp5100_tco(E) libie_adminq(E) dm_mod(E) dax(E) aesni_intel(E)


BR
nik

