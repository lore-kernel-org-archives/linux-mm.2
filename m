Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FF8CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 12:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E55A6B008A; Thu,  8 Oct 2026 08:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F1C6B008C; Thu,  8 Oct 2026 08:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735956B0092; Thu,  8 Oct 2026 08:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49FB16B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:30:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3D8614021D
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:30:21 +0000 (UTC)
X-FDA: 85299391842.08.493A680
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1380618000F
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:30:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=FC15QhiT;
	spf=pass (imf24.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791462619;
	b=mYPCHFp+/KnBHpEfURC++/cVEKHwA+qsEBFPWV7wWKUqJsP9Hyt+nLu0BNblP3i/0sm68S
	2/rb/itbTruf+Pg93Bi4gITZ2qcTVJb5W86Eu24U9maps8F7Mka5yJsc8K/a+OKuZc52V7
	K5aZ/JYluPV7jCUp60uQRlMcVKRxXrU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=FC15QhiT;
	spf=pass (imf24.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791462619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdbWfEGYkd7dRs/V/AoDBqeID1vWCkDNRjwVWb9XZtg=;
	b=QD5rvQBttaKNBjPALWkHewJ4dSEzIz2eSh8x/Swq2je1oCeuB7FS8oCI9nInUQmhXmDD7q
	9e4Himf61Nfinf7RjyKT2IG6I9SeLqSl6UqM+AlH5Xb+rJb1VpRFWzv9qe3dkhsOwAxBdX
	VcklQUFzjVktYzsm30E5qa5nMpPho6o=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 698CTfHD350746
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 8 Oct 2026 14:29:42 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 698CTfHD350746
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791462583;
	bh=HdbWfEGYkd7dRs/V/AoDBqeID1vWCkDNRjwVWb9XZtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FC15QhiT31lJ/LFYpaI8sS/THMIoEEK5R3RSoYr1p4wuBS0lfTGHJnrwryzVB/lmz
	 +I/wEhZO0ELNSOgOyedfm+abhzMKXtOSv74/WML9KoNMrZX7anu+ZxYt+m/jbuDJGT
	 ztprifx/9Buaj8AhK/3Cui7prVWofns0PJa3AqWw=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 698CTfr3034615
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 8 Oct 2026 14:29:41 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 698CTa6U2521035
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 14:29:38 +0200
Date: Thu, 8 Oct 2026 14:29:36 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: David Laight <david.laight.linux@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Borislav Petkov <bp@alien8.de>, Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
References: <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1380618000F
X-Stat-Signature: n964zjqojac5p4bpdwo4ugf1sdn1tnhw
X-HE-Tag: 1791462618-769295
X-HE-Meta: U2FsdGVkX1+f6SWEM0ZHu5Ghl/6WDgn3TyghUaudJOWQ5v+allZRPcW2OyyVYsW8U5vGIPLfJ6D8H1RapesPtcFT61rrHNlFphtgAoJXk3Vc9uldnGa5eA9HnpBNMhf3hxYugtQwpeqnO8FhZqBZXu8jbeQx3rblN+Qg4Y9SB/JMExFjXcWM1BiPa+qaUHVKKaM0VZ3vWqpitHDDJZH5BHJxcBQ6GXbjgjfp///979JoAuy2w9iQ+wGB1meO6q9CAHyZ7CR7lXkQORprUZbBaRaznm2sSnhf6dgn269eRZt9JP+IajPx419rD8HJGh4p2EZvzAThagTSmo2sFe9ChIrri2+gSuCeVi0qKr1YSyanW4/77/Feq0uo/UWQtUvhfJLCAuI64agT+SSjmrCRo2+VvS+huPz8nv1dl5WxZzJfVe5ZpoEdb8I7BpVdsgPCDO7s5ZDTivkQeisXCjLQLXpaf1DfLxGB1YEEBsSUIRXShMtuPz26VMcOeQif7NLZHMYVbjb10HyRE5s+BLCbbyGTUxJhuEj6hKMYoyedAb16u1cuY1sEbe6J4TjZcEg+sWm/Xy2Ai9YSNLnW1yx2eP1FCVkGIXEDGt4fiUEgKZ++lHbU878laE8UvxVLq85GMcPd4yZtylPtGuVOWDndd+9IeaqHpbDI3ZK08FbX597ERnQRIGaPf10i9N6tw2YdbE2Gk23T8KejUSLr67V1VStL1Yo/i9fBSq7LiNPGTRoMdiT0wVA7Gkav3D6Q4l/tkYAr5W95qbYuGuLqsIpYgStKI/uzJNsWPa+ap+0A/18CRCHwTYOwRKqWeM0pz8PKN7XCMHDNlFqfWN1gDiomW/lkZ5FG/cMHBQKzbt7tYlRJq1sH6uc2PYwcuhQRyVQCwSqB02Dn0WqPYY9aRlFqN5DTBWilYVBudepKzrrLAXuiOStk5KLXS6qqMk8iMEzw+HauLWmpiygtbpbxho3
 S+5wQ57d
 tz7CX4DHWJ564f/2+d6FmCRb6EHAf/gqa3Xx4oWWv7zmtX6yERL7m7pRP+yhItl6/OSTdFvSDKaMz3hTaJLLd38uFArZH9WdaHBXiOXQUzAs/PveogKb3Jf0OPZZCSu4vy1fQC53OCAzjzE/Yho/r7F3bUeAkTZ0FEstCqhEYBb/QxCNDDfnUy8RaHMyYJgNHNcAUL2dhwdB8IIfc/ygDPl6WV/LZ8e7SMZvXvH1nghNzzmqTXNdvQmY9syc5AVi7Q2xjtGTMUKYPFQA8IutWcZ0QkJPjzvGCp4YMFj7A4W/g5s9aVTonCoXnV/cQ83wgfWp2TVNgnc1QZT6GNalbSazRa0fTH3TTZVvrXeeTNhenD4B815E2pK6ACOyFy8xMDkrI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

we've just had two more crashes. I think second one is very important.

first:

Oct  6 21:24:25 10.4.0.10 [ 3526.201578] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
Oct  6 21:24:25 10.4.0.10 [ 3526.217983] CPU: 22 UID: 0 PID: 79544 Comm: servercare-moni Kdump: loaded Tainted: G        W   E       6.18.20lb9.03 #1 PREEMPT(voluntary)
Oct  6 21:24:25 10.4.0.10 [ 3526.217988] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE
Oct  6 21:24:25 10.4.0.10 [ 3526.245603] Hardware name: ASUSTeK COMPUTER INC. RS720A-E11-RS12 VR22020733/KMPP-D32 Series, BIOS 2101 04/15/2025
Oct  6 21:24:25 10.4.0.10 [ 3526.263617] RIP: 0010:__d_lookup+0x43/0xb0
Oct  6 21:24:25 10.4.0.10 [ 3526.271794] Code: 00 00 a0 00 00 c9 ff ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 10 1f d2 ff 48 8b 1b 48 83 e3 fe 75 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3
Oct  6 21:24:25 10.4.0.10 [ 3526.303509] RSP: 0018:ffffc90068637d70 EFLAGS: 00010202
Oct  6 21:24:25 10.4.0.10 [ 3526.303512] RAX: 0000000000000001 RBX: 0fffffff0c930020 RCX: ffffc90068637e4e
Oct  6 21:24:25 10.4.0.10 [ 3526.303513] RDX: ffff89b5971ad780 RSI: ffffc90068637dd0 RDI: ffff89e80921b800
Oct  6 21:24:25 10.4.0.10 [ 3526.303515] RBP: 0000000015804546 R08: b5971ad780ff0032 R09: ffff89b5971ad780
Oct  6 21:24:25 10.4.0.10 [ 3526.303516] R10: 0000000000000000 R11: 0000000000000004 R12: 000000000001019e
Oct  6 21:24:25 10.4.0.10 [ 3526.303517] R13: ffff89e80921b800 R14: ffffc90068637dd0 R15: ffffc90068637ec0
Oct  6 21:24:25 10.4.0.10 [ 3526.303518] FS:  00007f5ee43b4640(0000) GS:ffff89fe7c807000(0000) knlGS:0000000000000000
Oct  6 21:24:25 10.4.0.10 [ 3526.303520] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  6 21:24:25 10.4.0.10 [ 3526.303521] CR2: 00007f5ee46540e2 CR3: 00000179787e0002 CR4: 0000000000770ef0
Oct  6 21:24:25 10.4.0.10 [ 3526.303522] PKRU: 55555554
Oct  6 21:24:25 10.4.0.10 [ 3526.303523] Call Trace:
Oct  6 21:24:25 10.4.0.10 [ 3526.303526]  <TASK>
Oct  6 21:24:25 10.4.0.10 [ 3526.428693]  d_lookup+0x27/0x50
Oct  6 21:24:25 10.4.0.10 [ 3526.428696]  ? __pfx_proc_fd_instantiate+0x10/0x10
Oct  6 21:24:25 10.4.0.10 [ 3526.428703]  proc_fill_cache+0x59/0x160
Oct  6 21:24:26 10.4.0.10 [ 3526.455645]  ? __pfx_proc_fd_instantiate+0x10/0x10
Oct  6 21:24:26 10.4.0.10 [ 3526.455647]  ? __pfx_filldir64+0x10/0x10
Oct  6 21:24:26 10.4.0.10 [ 3526.455651]  proc_readfd_common+0xa5/0x1e0
Oct  6 21:24:26 10.4.0.10 [ 3526.484385]  iterate_dir+0xa2/0x240
Oct  6 21:24:26 10.4.0.10 [ 3526.484391]  __x64_sys_getdents64+0x78/0x110
Oct  6 21:24:26 10.4.0.10 [ 3526.502867]  ? __pfx_filldir64+0x10/0x10
Oct  6 21:24:26 10.4.0.10 [ 3526.502871]  do_syscall_64+0x61/0x980
Oct  6 21:24:26 10.4.0.10 [ 3526.521428]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Oct  6 21:24:26 10.4.0.10 [ 3526.521433] RIP: 0033:0x7f5ee6f08b8d
Oct  6 21:24:26 10.4.0.10 [ 3526.541410] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
Oct  6 21:24:26 10.4.0.10 [ 3526.578054] RSP: 002b:00007f5ee43b28f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
Oct  6 21:24:26 10.4.0.10 [ 3526.578057] RAX: ffffffffffffffda RBX: 00007f5ee43b45e0 RCX: 00007f5ee6f08b8d
Oct  6 21:24:26 10.4.0.10 [ 3526.578058] RDX: 0000000000000118 RSI: 00007f5ee43b2930 RDI: 000000000000000d
Oct  6 21:24:26 10.4.0.10 [ 3526.578059] RBP: 0000000000000010 R08: 0000000000000000 R09: 0000000000000002
Oct  6 21:24:26 10.4.0.10 [ 3526.578061] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5ee4402280
Oct  6 21:24:26 10.4.0.10 [ 3526.578062] R13: 00007f5ee43b2930 R14: 000000000000000d R15: 0000000000000001
Oct  6 21:24:26 10.4.0.10 [ 3526.578068]  </TASK>

different release, different hardware. same address. I don't have kdump unfortunately, only this netconsole
log.

second is more important:

[11402.940943] BUG: unable to handle page fault for address: ffffffff0c93001c
[11402.942273] #PF: supervisor read access in kernel mode
[11402.943629] #PF: error_code(0x0000) - not-present page
[11402.945025] PGD 6d6f83a067 P4D 6d6f83b067 PUD 0
[11402.946469] Oops: Oops: 0000 [#1] SMP NOPTI
[11402.947950] CPU: 23 UID: 0 PID: 704950 Comm: servercare-moni Kdump: loaded Tainted: G            E       6.18.55lb9.01 #1 PREEMPT(voluntary)
[11402.951254] Tainted: [E]=UNSIGNED_MODULE
[11402.952913] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 1201 08/25/2023
[11402.956569] RIP: 0010:__d_lookup_rcu+0x4d/0xe0
[11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08
[11402.964498] RSP: 0018:ff3eefdafcacfc40 EFLAGS: 00010292
[11402.966642] RAX: ffffffff0c930020 RBX: 000000061356452c RCX: 0000000000000006
[11402.968884] RDX: ffffffff0c930020 RSI: ff3eefdafcacfd70 RDI: ff2d1acd00409140
[11402.971167] RBP: ff3eefdafcacfda4 R08: 8080808080808080 R09: fefefefefefefeff
[11402.973512] R10: 0000303539343037 R11: 0000000000000004 R12: ff2d1acd8cb0b7e0
[11402.975915] R13: ff3eefdafcacfd70 R14: 0000000000000000 R15: 0000000000000000
[11402.978356] FS:  00007f757eaed640(0000) GS:ff2d1b89b5a42000(0000) knlGS:0000000000000000
[11402.980842] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11402.983374] CR2: ffffffff0c93001c CR3: 00000004ba18e002 CR4: 0000000000771ef0
[11402.986004] PKRU: 55555554
[11402.988640] Call Trace:
[11402.991231]  <TASK>
[11402.993831]  lookup_fast+0x2b/0x100
[11402.996468]  walk_component+0x1f/0x150
[11402.999080]  link_path_walk+0x105/0x2a0
[11403.001714]  path_openat+0x99/0x2b0
[11403.004319]  ? srso_alias_return_thunk+0x5/0xfbef5
[11403.006983]  ? up_read+0x5a/0x90
[11403.009610]  ? srso_alias_return_thunk+0x5/0xfbef5
[11403.012250]  ? do_user_addr_fault+0x190/0x6a0
[11403.014927]  do_filp_open+0xd3/0x180
[11403.017635]  ? __pfx_kfree_link+0x10/0x10
[11403.020383]  ? srso_alias_return_thunk+0x5/0xfbef5
[11403.023097]  do_sys_openat2+0x8a/0xe0
[11403.025765]  __x64_sys_openat+0x69/0xa0
[11403.028424]  do_syscall_64+0x64/0xba0
[11403.031066]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[11403.033733] RIP: 0033:0x7f75816ff1e4
[11403.036336] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 26 8c f8 ff 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 34 44 89 c7 89 44 24
[11403.044367] RSP: 002b:00007f757eaeb870 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[11403.047072] RAX: ffffffffffffffda RBX: 00007f757eaed5e0 RCX: 00007f75816ff1e4
[11403.049795] RDX: 0000000000080000 RSI: 00007f757edd90e2 RDI: 00000000ffffff9c
[11403.052470] RBP: 00007f757edd90e2 R08: 0000000000000000 R09: 0000000000000000
[11403.055070] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000080000
[11403.057594] R13: 00007f758187fe50 R14: 00007f75818e5040 R15: 0000000000000001
[11403.060096]  </TASK>
[11403.062521] Modules linked in: vhost_net(E) vhost(E) vhost_iotlb(E) tap(E) tun(E) ceph(E) libceph(E) cts(E) krb5enc(E) authenc(E) camellia_aesni_avx2(E) camellia_aesni_avx_x86_64(E) camel
[11403.062611]  scsi_transport_sas(E) i40e(E) nvme_keyring(E) libie(E) nvme_auth(E) xhci_hcd(E) sp5100_tco(E) libie_adminq(E) hkdf(E) dm_mod(E) dax(E) aesni_intel(E)
[11403.100478] CR2: ffffffff0c93001c

6.18.55 with Lorenzo's 0001-KVM-SVM-flush_tlb_gva-full-asid-flush-6.18.y.patch
applied.

so we now know this didn't fixed it. however I didn't have tlbi=ipi set, so I'll
now try this.

of course since the backtrace is a bit different (but quite close?), I'm not 100%
sure this is the same problem, hopefully it is..

unfortunately, for some reason I yet have to investigate, kdump produced only
vmcore-dmesg.txt, no vmcore..

any ideas on this new info?

BR

nik






On Mon, Oct 05, 2026 at 09:25:56PM +0200, Nikola Ciprich wrote:
> 
> 
> > > > 10371fa400: fffffff0c930020
> > > > 10371fa420: fffffff0c930020
> > > > 10371fa430: fffffff0c930020
> > > > 10371fa450: fffffff0c930020  
> > > 
> > > These are not random offsets in the page, either.
> > > 
> > > These all seem to be at offsets 0, 0x20, 0x30, 0x40, or 0x50 into the page.
> > > 
> > > If you look at the other addresses, are there any that are not at one of these
> > > offsets?
> > 
> > If you hexdump the start of each page do they look 'similar' and are there
> > any valid addresses that might point to other data and could help identify
> > the what the memory was used for.
> 
> (again, I used AI to answer that, hopefully it does make sense...)
> 
> Yes to both. Results below.
> 
> Valid pointers in the crash frame (0x103360000):
> Only two of the non-zero words in that page are valid kernel pointers; the
> rest (e.g. 0xfffff86eb0c30000) are not in the direct-map or vmemmap ranges
> (page_offset_base=0xffff985a80000000, vmemmap_base=0xfffff27140000000), so
> they're data, not pointers. The two valid ones both resolve to the dentry
> slab cache:
> 
> 0xffff985caf209d48 -> dentry cache, object [ffff985caf209d40]
> 0xffff998c79483448 -> dentry cache, object [ffff998c79483440]
> 
> (Both slab pages show flags ...01 "locked".) So the dcache is in the blast
> radius, same cache as the crashing __d_lookup.
> 
> The other value-bearing frames are NOT junk — they're a repeated structure:
> Dumping the start of three of the frames the bad value appears in
> (0x1ae234000, 0x24f0e2000, 0x342c40000), they are near-identical, a
> fixed-format record. Field-by-field for the first 0x80 bytes:
> 
> off 1ae234000 24f0e2000 342c40000
> +0x00 00ff00ff00100010 (same) (same) const
> +0x08 bdcc802700060042 (same) (same) const
> +0x10 0000000000006e43 (same) (same) const
> +0x38 0bb8008000000000 (same) (same) const
> +0x40 0000000117bc0000 (same) (same) const
> +0x48 00000026813e0000 0000000fbb9be000 0000001b56718000 varies
> +0x50 fffffc0ea76249a0 fffffc0ea76258c0 0007bb3a5e4ed461 varies
> +0x58 0000000000001070 0000000000000906 0000000000000903 varies
> +0x60 0000000003000200 (same) (same) const
> +0x70 0000000000000078 (same) (same) const
> +0xd0 ccccc30014894100 / 48cccccccccccccc (0xcc padding) const-ish
> 
> So: a constant header, a few varying fields at +0x48/+0x50/+0x58 (look like
> a length/cookie/handle), and 0xcc padding. The same template appears in
> physically-unrelated frames.
> 
> The corrupt value 0x0fffffff0c930020 appears deeper in this same structure
> (page offsets 0x400/0x420/0x430/0x440/0x450), i.e. it is being written into
> specific slots within this record format, not scattered randomly. That lines
> up with the "written into one of ~6 slots" pattern: relative to a 0x400
> base, occurrences are at +0x00 (x9), +0x20 (x9), +0x30 (x9), +0x40 (x2),
> +0x50 (x11); none at +0x10.
> 
> Question: does anyone recognise this structure from its header? The constant
> signature is:
> 
> +0x00: 0x00ff00ff00100010
> +0x08: 0xbdcc802700060042
> +0x10: 0x0000000000006e43
> +0x38: 0x0bb8008000000000
> +0x60: 0x0000000003000200
> +0x70: 0x0000000000000078
> 
> I haven't positively identified the owning subsystem. Given the earlier
> observation that these frames carry stale page_pool metadata in their struct
> page (pp_magic set, pp_ref_count=0), a network/driver descriptor or buffer
> origin is my guess, but that's only a guess — the header bytes should be
> recognisable to someone who knows the relevant format.
> 
> Happy to dump more of any of these frames, or struct page for them, if
> useful.
> 
> 
> Field decode of the constant header (little-endian sub-fields), in case the
> layout helps identify it:
> 
> +0x00 u16: 0x0010, 0x0010, 0x00ff, 0x00ff (counts/markers?)
> +0x08 u16: 0x0042, 0x0006, 0x8027, 0xbdcc
> +0x10 0x6e43 (bytes 'C','n') (signature?)
> +0x38 0x0080=128, 0x0bb8=3000 (size/timeout?)
> +0x58 small, varies: 0x1070 / 0x906 / 0x903 (length/seq?)
> +0x60 0x0200=512, 0x0300=768
> +0x70 0x78=120 (sub-struct size?)
> +0x48 varies: looks like a 64-bit addr/DMA handle
> +0x50 varies: 0xfffffc0e........ (two frames) (per-cpu/fixmap/IOVA-shaped,
> not a direct-map/vmemmap ptr)
> +0xd0 0xcc padding (record built in 0xcc-poisoned buffer)
> 
> I can't identify the owning struct from this. If anyone wants to grep: the
> first two u64s (0x00ff00ff00100010, 0xbdcc802700060042) are a distinctive
> constant signature across all affected frames.
> 
> BR
> 
> nik
> 
> 
> 
> > 
> > David
> >  
> > > 
> > > If this is a case of "system writes fffffff0c930020 into one of 6 slots",
> > > there could be some at offset 0x10 too.
> > > 
> > > I'm having AI comb the kernel now for places where we could conceivably
> > > construct this value, and write it into one out of 6 slots.
> > > 
> > > >   
> > 
> > 
> 
> -- 
> Ing. Nikola CIPRICH
> technický ředitel
> 
> +420 591 166 214
> +420 777 093 799
> nikola.ciprich@linuxbox.cz
> 
> www.linuxbox.cz
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

