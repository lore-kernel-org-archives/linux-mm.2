Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B71AC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB616B00A0; Tue, 14 Jul 2026 23:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089176B00A1; Tue, 14 Jul 2026 23:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB576B00A3; Tue, 14 Jul 2026 23:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9D7F6B00A0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:49:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F2FDA0458
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:49:22 +0000 (UTC)
X-FDA: 84989630964.23.6F39126
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A1E3180009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:49:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UBpdshwL;
	spf=pass (imf24.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784087360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3OMFFoZ6HDUY42qAv/zrklkuo0r18cHkV8oRHqawaN0=;
	b=yZ2d3EGZpqsyz+j1pDE9oiAeUE33l7ZoCBFSs7c37PIDn0nNv1yxiOFfSa/yyv+ctEYeu5
	1USQ11w0h/ryrtHJslifQcRMfGWXvlHDVADZtV5mfDoWjVNX8Yt27iYlLkth7vXppKBO55
	SV0E8qABfzzwyDakwJ+2V3Qq8IejoL0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UBpdshwL;
	spf=pass (imf24.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784087360;
	b=L4iBuhvvpn0Izx0wuF4Blh6wKS52dedBiZTO6Kyz9DikbncML+gGQM9RLYm5UAf/e8zKar
	OnOhE7BcKAK3Zp7QbH+2le6UWwExAh8sh+3TpoeyQL0nwKnut4VyRB1AxkSyi9aPgZMx3m
	hADpqFcWtCoNLgBkrzPe5Jvf6uUjWp8=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4960a66d36dso1652383b6e.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784087359; x=1784692159; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3OMFFoZ6HDUY42qAv/zrklkuo0r18cHkV8oRHqawaN0=;
        b=UBpdshwLzPLmTV4GxpOTYY11CxvXNmPXRk8u3CvpUQ/dFIlRx9rnt3hTchsjIw9fV4
         0+bMS06af/2GeY1R8itPJp7b/kF2v9VfvRwfF3HLsWWhvH3luCWs9ZfUSyTjetWUDzxE
         18qHu7i1Xcn4KjbTOuSrel/g5KkjP24iOYoRZECdJXrT5Rsg41RJ50TtfftmNHDr1itk
         0pmAbXBF9OH9VIfrxAwualk+CvZjY2jsZEv1erUNHXESdkFwFqs7IzffIeNLk5BfREPN
         RQCStPsEya3UoCVh02H9Z50QqIwYIfSf3vxw2ZHFke1aFA7d/V2nsnXwBROYMs++Bzz1
         c13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784087359; x=1784692159;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3OMFFoZ6HDUY42qAv/zrklkuo0r18cHkV8oRHqawaN0=;
        b=Uua/orK1K15c19ezid0xDBVFBjxMu0YJ2ZKSob0YZUB9jqcuIXWFgN1W0MMTgsyT7b
         /CLvsavQ+30KzycLA1DvEfkWLGFTLOXyFzZ2nl7YUEGp99PY76rDmmpxhBo3Ibkgvtxz
         HZv1XfTL6emeMajaZFcjh1A0WP8mTu3nBJuYnW70DrZKrRMsF53rZlHXZFEL7XrD3THO
         Oj0pZCHcHMuslNumghJ2hHuOFHlPv7dbJX+jM/xiPAlGVjauS9/YuD+TLIabup5vDqFu
         2Wdv2GQV+LrtEnDSNmSvLgs1ri7o3/y9A4w18utwbnPesN+dYBIyYKIru8Ornz2OoTae
         xJLA==
X-Forwarded-Encrypted: i=1; AHgh+Rq6HPU16MASiHjg8ZdeTvfKp6fHlQFruuiswoIGraUAMhmKctd3RAwF6XD+twInreWk7S97iyV8zA==@kvack.org
X-Gm-Message-State: AOJu0YwZVUwA9TpAtTsfs8q0ikGyI34AYMF2KuIDfbV6nschJYE1MbFr
	nUgciqk1YRaOUbRcmRAxc609pCp3ectPXeYmCDYPrUhHwYfCReWAT0RV
X-Gm-Gg: AfdE7clCRIcJym22rCvM5RYm+tZfQqgArEaCcIrqd+bOqJPm8/OPENNMX9hydgvpN4y
	zDwqsg4mkylZcZED0Ng2W5fKfeNGN/oYm47mCEWPGPBDY0PY9sTnUsPPzMTzGG58JrgiJxfC0kY
	B5QBQ8gXkuQ+FLeoHHDxWskgJwNLWNrWyoHroYcOuoMsBI4o4UGwanwiZB8EKH6SlIO87ib2SBv
	GA0pFf4hLQo9iqexM1H7Vvk7zyr8L9/63n31l2pBaMKUxLUckhIGuj+EZa4RcpbueybBp2q3pJU
	HtJktDaztXOFY6uCMPoxzvZXJ6//0cpL30Xx1dUoTHQRVgAprUPj2iJHf7RQwduv37wzMwSn44M
	fbIaLpjECF5yFO0TbWZkdlHfp+4idczl4/hIuJ0Tjma76kI8Em61MT6PJjqBQLnbevCQrD9cPSQ
	TPmwRhkyPJgDLcJQuynU4pd1TlAMakxD49CfyKuUy6
X-Received: by 2002:a05:6830:4110:b0:7eb:c7ac:29ef with SMTP id 46e09a7af769-7ec09625379mr6812059a34.2.1784087359278;
        Tue, 14 Jul 2026 20:49:19 -0700 (PDT)
Received: from localhost ([172.59.75.218])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcafda2ffsm16467241a34.12.2026.07.14.20.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 20:49:18 -0700 (PDT)
Date: Tue, 14 Jul 2026 23:49:12 -0400
From: Aaron Rainbolt <arraybolt3@gmail.com>
To: xen-devel@lists.xenproject.org
Cc: jgross@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 marmarek@invisiblethingslab.com, adrelanos@whonix.org
Subject: Intermittent kernel WARN in mm.h get_page() when forcefully
 removing a xen_netfront interface from xenstore
Message-ID: <20260714234912.7a75536b@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/eDubLtio8OFLSEEx0zCmBLW";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A1E3180009
X-Stat-Signature: h6d8usspj5gkkws3i881pzu9pobfr88p
X-HE-Tag: 1784087360-30534
X-HE-Meta: U2FsdGVkX18cT4gBWzqA9P7bubi/yQna5G+cQqC4CzXdWEgpDPjPlNxAzgVmYXVVtAWRnkDdX3XwNGN6ofkB+BmI0urCSmBJcYcuYN8RmIaY0yia28my/Pl5jbs9AEhfRet1aFemmUlsY8BoyB3vTHAAFccBMxaDNcUshox2XsccIk3rDpo02H+guh0H5xWca7p/Aq1QgQgjKJ4sRZdu6eomRSUXHHrYdyDqWfstrsh8HdbD+qTlbL995e6sZAFtA2116g2b/WJsHVf37P+4mwmcaMHl2xPSZJGUS6lub35EvCjsdYfUw1m9Z57U77G0hFLOEG2q5nYA5pRelTXhm2OQwjkhaaWkKCVLmtq7kF2Pru/0ImMf8GPC4lV6dn7OXwXLibM5wY4I7kXZo6TrpDlSb8rGnBS6jVxZGp57h1cxGJVk0g4SLfSVJ7he//U6WOjo8NrU9V5ZyRYhViEkWlkB1/dlVuCzXykPAFMnpF9MxH77Y7kcbgzgtL71hsONOuphQcO7b08Wq2KzGQ0BJmwd4wzIsWys8TCCG4nYIfcw/zkiEv0YLfsFP2tftTABTk1U/DwwYSQ4Z0wpTTPeG16PcsXrOz6FxWPonzw9EkCkcyfOJoGqCUaR7zM5oPR3JuP7za8SelGp5LeCwFw9C0mK1ZjicDxKDSYT9pZmq3KLoVreh03S5fVOAIAINUA9nn5E7RTT7iIK+vmooE5OPkpuG9w57Ekr/xsgf25XLmzVPvouInklrZgK8N4aTmtRdpfHHDwBnjKL1k1WXBUSdkoithaIbM4E0p0xYg1MC0z0tAYHgSGjwL08P2TVgnxsttPqlGU0MubS3WcTQQTjliFyWT7yf6jHpe/pnFpXUKbTD8lH9MM6rnIW2fbhCuq6HdnY4aBoxgeEmPw+PkUR6Lin4SpkeOBD6UEtpxhogT8ccfOHXmQCClqAXJWoL9ViHXXD0km3R22rUFPDuXh
 mvafuwH5
 UtpWxcv48Lm0XQYTnD/dYU2Ro3b6oTMczn0gDyA1QwkbVia38LZQd2j2fBFN9cHSw2Ddm384dNqw9myrE8c5/UQSGseg5ZcWfslJcGgk8LOMdi3/TVF0twwqfJHcze6lLDsgAWHkXPF9BQWVd/YL1SXhhw4RWhD7rgDzBwgOD0FfGUGfiBgpjr6sAhpLGy/J/H1SKdhFqCcNh2/ndsLJmBzlygWRQUWgFy5OpPlI97nU0AlIut9yij83wuU15gOkZ5/XjrVwPPzjDp4sRRufD06EVkd8jEq1MPl09XaEA2hR+0OEfJRw/30uJ7OAkgdfDMbaP1fpJUeI5wzKyPYhpnUX0J9WXC/WiTy1vMk7yfa9tp4Y7n6YAaPoEeYlpwmg0OpN/7JEnq35BNVjqPoIDN18tSDZGuD1ZMDuz2wqV1DGhnV/PB+RB45l4Wt3hQFLNvfUeumVXmTOn+o04FvviiReVVjxzAeAAPBXpxEYuOXOp0zhTrlNFABo5/enx4vmO6FhxLuyCSLXDzflM+UkGHkP10Ia/X5LKO+mSqQAlkmEtCDN8e8fjY8exUDX4zllrFWq1DZZEuMtsOXEk7TOxwfs3V5Ql870h8317rTGYrbx8jqbNISA1tMuYBjQKEzPBXO5reOu8V+TcK/U6kvRCFvylEbnniPf/dgQOil72liV4xc3sq8yM6mISi1GhblTC8bXHHrjG22rpLJ6JIXdpIoawvPfFwoNAoRMn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_/eDubLtio8OFLSEEx0zCmBLW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

A user in the Qubes OS issue tracker reported that they could cause
kernel WARNs in some of their AppVMs when forcibly terminating a NetVM
that those AppVMs were connected to. [1] Typically, a message such as
`vif vif-0: xenbus: device forcefully removed from xenstore` appears,
then a "WARNING" appears immediately thereafter indicating an issue in
`xennet_disconnect_backend`, with the line of code throwing the warning
being somewhere in `include/linux/mm.h`. Originally it was thought that
the warning was simply normal behavior when a device is forcefully
removed, but it seemed very weird that memory management code would be
in charge of triggering that warning. Furthermore, I cannot reproduce
the issue reliably; for some users, it happens immediately after
shutting down the NetVM, whereas for me, I had to use multiple tricks
including pausing and unpausing a VM to trigger it. After some
fiddling, I was able to reproduce the issue using the latest stable
7.1.3 kernel:

1. On a Whonix-Workstation 18 AppVM (such as anon-whonix), build kernel
   7.1.3 using the steps from
   https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.htm=
l#s-common-size,
   ensuring that debug info is enabled. Use Debian's kernel config from
   the linux-base-7.1.3+deb14-amd64_7.1.3-1_amd64.deb package as the
   starting kernel config.
2. Install the new kernel into a cloned Whonix-Workstation 18 template.
3. Install pvgrub in dom0: `sudo qubes-dom0-update --action=3Dinstall
   grub2-xen-pvh`
4. Create a new AppVM named `anon-whonix-kerntest` based on this
   template.
5. Set the kernel for `anon-whonix-kerntest` to `pvgrub2-pvh`.
6. Start `anon-whonix-kerntest`.
7. Run `uname -r` in `anon-whonix-kerntest`, ensure that the kernel
   version displayed is 7.1.3.
8. Open a root QTerminal window in `anon-whonix-kerntest` by running
   the following in dom0: `qvm-run -u root anon-whonix-kerntest
   qterminal`.
9. In the root QTerminal window, run `sysctl kernel.warn_limit=3D5` to
   prevent an immediate kernel panic when the kernel warn occurs.
10. Open Tor Browser in `anon-whonix-kerntest`, and attempt to navigate
    to a fairly resource-intensive web page like Reddit's front page.
11. While the page is still loading, run `qvm-pause
    anon-whonix-kerntest` in dom0 to freeze the AppVM.
12. In dom0, run `qvm-kill sys-whonix`.
13. Wait a few seconds, then run `qvm-unpause anon-whonix-kerntest` to
    unfreeze the AppVM.
14. In the root QTerminal window of `anon-whonix-kerntest`, run `dmesg
    -w` to watch for kernel messages.
15. Wait a few seconds, then start `sys-whonix`. Qubes OS will reattach
    the network when this is done (there is the equivalent of `xl
    network-attach` done by the Qubes code automatically). The following
    messages should appear in dmesg:

    [  426.609004] vif vif-0: xenbus: device forcefully removed from xensto=
re
    [  426.609242] ------------[ cut here ]------------
    [  426.609254] WARNING: ./include/linux/mm.h:2097 at xennet_disconnect_=
backend+0x1c7/0x520 [xen_netfront], CPU#0: xenwatch/64
    [  426.609269] Modules linked in: snd_seq_dummy(E) snd_hrtimer(E) snd_s=
eq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) cfg80211(E) nls_as=
cii(E) nls_cp437(E) vfat(E) fat(E) rfkill(E) xenfs(E) nft_reject_inet(E) nf=
_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nf_conntrack(E) n=
f_defrag_ipv6(E) nf_defrag_ipv4(E) nf_tables(E) binfmt_misc(E) intel_rapl_m=
sr(E) intel_rapl_common(E) intel_uncore_frequency_common(E) intel_pmc_ssram=
_telemetry(E) intel_vsec(E) aesni_intel(E) gf128mul(E) xen_netfront(E) xen_=
privcmd(E) xen_gntdev(E) xen_gntalloc(E) xen_blkback(E) drm(E) xen_evtchn(E=
) jitterentropy_rng(E) libsha3(E) loop(E) configfs(E) efi_pstore(E) nfnetli=
nk(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc16(E) mbcache(E) jbd2(=
E) dm_snapshot(E) dm_bufio(E) dm_mod(E) xen_blkfront(E)   =20
    [  426.609334] CPU: 0 UID: 0 PID: 64 Comm: xenwatch Tainted: G         =
   E       7.1.3 #5 PREEMPT(lazy)
    [  426.609340] Tainted: [E]=3DUNSIGNED_MODULE
    [  426.609343] RIP: 0010:xennet_disconnect_backend+0x1c7/0x520 [xen_net=
front]
    [  426.609349] Code: 94 dd a0 10 00 00 48 8b 4a 08 48 89 ce 83 e6 01 48=
 83 ee 01 48 09 f1 48 21 ca 0f b6 4a 33 81 f9 f5 00 00 00 0f 85 ea fe ff ff=
 <0f> 0b 49 81 ff 00 01 00 00 0f 82 f8 fe ff ff 4c 89 fe 48 c7 c7 e0   =20
    [  426.609352] RSP: 0018:ffffce3d810c3c98 EFLAGS: 00010246
    [  426.609356] RAX: 0000000000000010 RBX: 0000000000000000 RCX: 0000000=
0000000f5
    [  426.609358] RDX: fffffb0d80ca9800 RSI: 0000000000000000 RDI: fffffff=
f88c8a8a0
    [  426.609360] RBP: ffff8dec51df0000 R08: ffff8debf4dd5a80 R09: ffff8de=
bf4dd5a80
    [  426.609362] R10: 0000000000000020 R11: 00000000000000bf R12: 0000000=
000000000
    [  426.609364] R13: ffff8dec8ef30b80 R14: ffff8dec197fcac0 R15: 0000000=
000000000
    [  426.609366] FS:  0000000000000000(0000) GS:ffff8ded2d129000(0000) kn=
lGS:0000000000000000
    [  426.609369] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  426.609370] CR2: 00005faa1a7d3737 CR3: 00000000b420a003 CR4: 0000000=
000770ef0
    [  426.609377] PKRU: 55555554
    [  426.609379] Call Trace:
    [  426.609384]  <TASK>
    [  426.609395]  xennet_remove+0x9f/0x380 [xen_netfront]
    [  426.609399]  ? kfree+0x26e/0x3d0
    [  426.609407]  xenbus_dev_remove+0x71/0x100
    [  426.609414]  device_release_driver_internal+0x19c/0x200
    [  426.609419]  bus_remove_device+0xe8/0x1c0
    [  426.609425]  ? device_remove_attrs+0xa1/0x100
    [  426.609430]  device_del+0x160/0x3e0
    [  426.609433]  ? __pfx_xenwatch_thread+0x10/0x10
    [  426.609436]  device_unregister+0x17/0x70
    [  426.609439]  xenbus_dev_changed.cold+0x3e/0x5b
    [  426.609445]  ? __pfx_xenwatch_thread+0x10/0x10
    [  426.609447]  xenwatch_thread+0x92/0x1c0
    [  426.609451]  ? __pfx_autoremove_wake_function+0x10/0x10
    [  426.609466]  kthread+0xe3/0x120
    [  426.609470]  ? __pfx_kthread+0x10/0x10
    [  426.609473]  ret_from_fork+0x2ba/0x340
    [  426.609478]  ? __pfx_kthread+0x10/0x10
    [  426.609480]  ret_from_fork_asm+0x1a/0x30
    [  426.609491]  </TASK>
    [  426.609493] ---[ end trace 0000000000000000 ]---

(Note that I have not been able to reproduce the issue reliably; these
steps worked for me once, but they may not work every time.)

`./include/linux/mm.h:2097` looks like this:

```
static inline void get_page(struct page *page)
{
	struct folio *folio =3D page_folio(page);
	if (WARN_ON_ONCE(folio_test_slab(folio))) /* <-- 2097 */
		return;
	if (WARN_ON_ONCE(folio_test_large_kmalloc(folio)))
		return;
	folio_get(folio);
}
```

Following the stack trace, all of these line numbers should be accurate
if working with an unmodified 7.1.3 kernel tree:

    $ scripts/faddr2line ./drivers/net/xen-netfront.ko xennet_disconnect_ba=
ckend+0x1c7/0x520
    xennet_disconnect_backend+0x1c7/0x520:
    get_page at /home/user/linux-7.1.3/./include/linux/mm.h:2097 (discrimin=
ator 1)
    (inlined by) xennet_release_tx_bufs at /home/user/linux-7.1.3/drivers/n=
et/xen-netfront.c:1435 (discriminator 1)
    (inlined by) xennet_disconnect_backend at /home/user/linux-7.1.3/driver=
s/net/xen-netfront.c:1839 (discriminator 1)

    $ scripts/faddr2line ./drivers/net/xen-netfront.ko xennet_remove+0x9f/0=
x380=20
    xennet_remove+0x9f/0x380:
    xennet_remove at /home/user/linux-7.1.3/drivers/net/xen-netfront.c:2664

    $ scripts/faddr2line ./vmlinux kfree+0x26e/0x3d0                       =
    =20
    kfree+0x26e/0x3d0:
    stat at mm/slub.c:383
    (inlined by) slab_free at mm/slub.c:6258
    (inlined by) kfree at mm/slub.c:6566

    $ scripts/faddr2line ./vmlinux xenbus_dev_remove+0x71/0x100
    xenbus_dev_remove+0x71/0x100:
    xenbus_dev_remove at drivers/xen/xenbus/xenbus_probe.c:353

    $ scripts/faddr2line ./vmlinux device_release_driver_internal+0x19c/0x2=
00
    device_release_driver_internal+0x19c/0x200:
    __device_release_driver at drivers/base/dd.c:1354
    (inlined by) device_release_driver_internal at drivers/base/dd.c:1375

    $ scripts/faddr2line ./vmlinux bus_remove_device+0xe8/0x1c0         =20
    bus_remove_device+0xe8/0x1c0:
    kset_put at include/linux/kobject.h:193
    (inlined by) subsys_put at drivers/base/base.h:74
    (inlined by) bus_remove_device at drivers/base/bus.c:671

    $ scripts/faddr2line ./vmlinux device_remove_attrs+0xa1/0x100       =20
    device_remove_attrs+0xa1/0x100:
    device_remove_attrs at drivers/base/core.c:2976

    $ scripts/faddr2line ./vmlinux device_del+0x160/0x3e0   =20
    device_del+0x160/0x3e0:
    device_del at drivers/base/core.c:3896

    $ scripts/faddr2line ./vmlinux __pfx_xenwatch_thread+0x10/0x10         =
        =20
    __pfx_xenwatch_thread+0x10/0x10:
    xenwatch_thread at drivers/xen/xenbus/xenbus_xs.c:844

    $ scripts/faddr2line ./vmlinux device_unregister+0x17/0x70             =
             =20
    device_unregister+0x17/0x70:
    put_device at drivers/base/core.c:3813
    (inlined by) device_unregister at drivers/base/core.c:3937

    $ scripts/faddr2line ./vmlinux xenbus_dev_changed.cold+0x3e/0x5b       =
               =20
    xenbus_dev_changed.cold+0x3e/0x5b:
    xenbus_cleanup_devices at drivers/xen/xenbus/xenbus_probe.c:451
    (inlined by) xenbus_dev_changed at drivers/xen/xenbus/xenbus_probe.c:648

    $ scripts/faddr2line ./vmlinux __pfx_xenwatch_thread+0x10/0x10         =
                  =20
    __pfx_xenwatch_thread+0x10/0x10:
    xenwatch_thread at drivers/xen/xenbus/xenbus_xs.c:844

    $ scripts/faddr2line ./vmlinux xenwatch_thread+0x92/0x1c0              =
            =20
    xenwatch_thread+0x92/0x1c0:
    xenwatch_thread at drivers/xen/xenbus/xenbus_xs.c:870

    $ scripts/faddr2line ./vmlinux __pfx_autoremove_wake_function+0x10/0x10=
                     =20
    __pfx_autoremove_wake_function+0x10/0x10:
    autoremove_wake_function at kernel/sched/wait.c:402

    $ scripts/faddr2line ./vmlinux kthread+0xe3/0x120                      =
     =20
    kthread+0xe3/0x120:
    kthread at kernel/kthread.c:436

    $ scripts/faddr2line ./vmlinux __pfx_kthread+0x10/0x10             =20
    __pfx_kthread+0x10/0x10:
    kthread at kernel/kthread.c:381

    $ scripts/faddr2line ./vmlinux ret_from_fork+0x2ba/0x340               =
   =20
    ret_from_fork+0x2ba/0x340:
    ret_from_fork at arch/x86/kernel/process.c:164

    $ scripts/faddr2line ./vmlinux __pfx_kthread+0x10/0x10
    __pfx_kthread+0x10/0x10:
    kthread at kernel/kthread.c:381

    $ scripts/faddr2line ./vmlinux ret_from_fork_asm+0x1a/0x30             =
     =20
    ret_from_fork_asm+0x1a/0x30:
    ret_from_fork_asm at arch/x86/entry/entry_64.S:255

--
Aaron

[1] https://github.com/QubesOS/qubes-issues/issues/10969

--Sig_/eDubLtio8OFLSEEx0zCmBLW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQS8QsiCjFi4DcDBX+Q5rdye4jrrCAUCalcDOQAKCRA5rdye4jrr
CMvxAQDPbjrAr0/2zidW3Udib5xaWE5wrTiGhNC4gvLPIuf2XQD/RRqzBpm2bO3r
Qis6x/MIdh4Xg98rK/09LgZ7/hkpAwM=
=hgKf
-----END PGP SIGNATURE-----

--Sig_/eDubLtio8OFLSEEx0zCmBLW--

