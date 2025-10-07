Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A1ACCD184
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 07:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D098E000D; Tue,  7 Oct 2025 03:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E341D8E0005; Tue,  7 Oct 2025 03:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A168E000D; Tue,  7 Oct 2025 03:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C43718E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:46:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46C27BB58E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:46:05 +0000 (UTC)
X-FDA: 83970534690.04.F22E0BB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id D72721A0012
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:46:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UFS4Oqbj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z2rttC4u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UFS4Oqbj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z2rttC4u;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759823163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFKCIgUl7ny7NZbOmqDCKDRokf+SkrVDYtNtQSOjYB4=;
	b=Un2TPVBFrK3vHKQ/fQWZ4EL4fZVJn9uSpUmd8ljtfgloKWuH72PAcJeP3jmR+U0QpnN/m6
	BUX4gg+G38YTMM5dmLlu3fdl5x1ROAlbfULsNLTU8Ohf5flgCVWK5tzOuSOSgZ+4BhceDW
	MXvJMdTq9ymslJGN22pAvdiz30JBOCU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UFS4Oqbj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z2rttC4u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UFS4Oqbj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z2rttC4u;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759823163; a=rsa-sha256;
	cv=none;
	b=mtAbI7dtVr0Zq615AXdaIdpC489W/FWbnFhehjspehwBE6kQKTP01SfdYqx27gHjYcs3zi
	Kk1SWvc5CO/hmI5KNeW9goY73TX2Yo6GYr1qFlrxZ/nvt320MEv5QCwmWmPg8jjplqpt6S
	LPO/xQCIBmZIsSlhAjC5tKZ/jEDOlns=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0042F1F7A8;
	Tue,  7 Oct 2025 07:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759823161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uFKCIgUl7ny7NZbOmqDCKDRokf+SkrVDYtNtQSOjYB4=;
	b=UFS4OqbjDC4jIU1amgwbIihY80eOJHcdxKYEpDbIuTVtEKs/dU+Rrsld3w/cMBaMf+xKrL
	nT14H1C+Mmj5HHcT6cE5GgqEI+b5Uyt97bd94fPsnNysudlWfgPCNOHBKOhf+yugnM6IfX
	1jAPme7vOyLNrkd4nLvAbesipHEHwZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759823161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uFKCIgUl7ny7NZbOmqDCKDRokf+SkrVDYtNtQSOjYB4=;
	b=z2rttC4uAlavgDF7YDWXHqpH2LNKTkN1ghkKVzPvALbaBvd5ZUNLBqXfvnObvYn49ko9Zx
	gTM7dAmKKT2YrqBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759823161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uFKCIgUl7ny7NZbOmqDCKDRokf+SkrVDYtNtQSOjYB4=;
	b=UFS4OqbjDC4jIU1amgwbIihY80eOJHcdxKYEpDbIuTVtEKs/dU+Rrsld3w/cMBaMf+xKrL
	nT14H1C+Mmj5HHcT6cE5GgqEI+b5Uyt97bd94fPsnNysudlWfgPCNOHBKOhf+yugnM6IfX
	1jAPme7vOyLNrkd4nLvAbesipHEHwZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759823161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uFKCIgUl7ny7NZbOmqDCKDRokf+SkrVDYtNtQSOjYB4=;
	b=z2rttC4uAlavgDF7YDWXHqpH2LNKTkN1ghkKVzPvALbaBvd5ZUNLBqXfvnObvYn49ko9Zx
	gTM7dAmKKT2YrqBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E01E613693;
	Tue,  7 Oct 2025 07:46:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W0tnNjjF5GjbLQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 07 Oct 2025 07:46:00 +0000
Message-ID: <10d6dec4-665d-493f-97a9-2982dfbc1afe@suse.cz>
Date: Tue, 7 Oct 2025 09:46:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: Don't call lockdep_unregister_key() for immature
 kmem_cache.
Content-Language: en-US
To: Kuniyuki Iwashima <kuniyu@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 linux-mm@kvack.org, syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
References: <20251007052534.2776661-1-kuniyu@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251007052534.2776661-1-kuniyu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D72721A0012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: b9oyw6hr8xhgehszuia65tm7xxwfsg8o
X-HE-Tag: 1759823162-545166
X-HE-Meta: U2FsdGVkX1/mYYJZ9KtH/pAdQjbsmLZxkc5Zsytzcfb6+YwQZBD3TnZmi60mWrme6U8MXDHjhgWKEmzpx/hCPpKTUs3p7MP3wyRUny84NZHIJ9FSrFqLun5wKq2H3PijVEV/6m2vMwX9EAM7dvkoV04N99iV/FNfuAVV31iW4hXb8TxGVbPu5rBbnw1dHrb3pZxQ6bNCic+VbL5FHbGgemEahb+Iu2sKfMziqtX0ALa2+U/sxLCfSrH3lBqEAAit9A/APad96FgjmIyHsuTOey4wwZtQ3c225BdxN8TlIFzWkaCpMm+kweynNw3xmn6pgPKc8vJZRxGbbgodUn6M7d83VJGcqfbnOwytywnhW+yrm2YvDYgNHAaP2qdfUMgA5oFWjivFpkFq0JzT5I52KOBBsi+q2u3hTl3g+IkVHJpYtCIU8T41EtwrXhB1Bn9Jdd6RSqWcqr6y2Gu8a9zlbEzE8vPKD0MFt0S9w40f42gMpSVGosYGTKmhXIiMPTf4WfGEHIxzthC8JEukQBY7+dHkRG4X3Vsd+lgq+YokS6dD6fr6i39/ShDWmkTFOhwT013eGrDbY5i57XPhby7pbARtRN97BUYdsQyX5ogY4Uh3qUAQZiq0tP66dg+0GOVsXEppCuNoxjtEelLVfF4LqS9o4e+hgq7B+yn9RGtnaHbch+a3A7GA3FjUFuaK0ZXFHp9xagXlHbyQCXBdWUEz4GKH4VKm/Y1T7hxJ4JfQ1xe/HGOFDtj8+ZLW/25zs1vq3zJFLLhxyqZ9G5bLqX3553gTGCbBEU//hw+Y1l3leROka9+QoYj1h1iD8Fk5eLqq/wmQh++sVjNzF2vKDZR1B1xQNyigUD0HC110zQ1FsnnieRlrW7Y6jaFJSk03ojEW069oHjUCYjqi/MZBwjzC4e1KspQpAwMAQN4nOl+5neAwVt+93Aw6G5D2lMWp7jeSP2E6+A3D5LeR44Fv21y
 czpZeUJ6
 Zz3737H1vX/RhoO20ru3L3Tx/3cvwzZEwvvvQEjAOuLJ1x4Rz9Xx75J9mOEPAHBeyZWiF8OM7lKwUpJUbS8mgQLQ1rJ1LEKfD2R6xpRTFq/W99H+tqj+sexl7uIzyQcWpZomT6FIPSxKXsNekPfHcOlv3EuA0caf4mv1Viq1CViPh7EoeOBGzaPXp1IahUh7ANJY+LIZDwnTZKQM+tGRIwgDVkr0a/Uhd0aN6n6r1LYOfsAuKebDA8shPh0ryfGvsbLvK9N5A1wiZG+7APNPWUKf3Jd2QqpjoUgt0TpjrV4NAVqA6iQ+7VUjnfoN7QjTmyuNJBDBD53wC1xlp3RcKJuGghlbKN7B5lUhBrxLRJHDbIWYDPCJApIC9CG+TfGWwTboV05uRUf7ooO1Sp5b4HdkF3R5RKfmD2tLynqww8th6zqyx8Ll7lMqRBCeWiSXA+GmYM2bYI6SflX/7hthshIIqhpeHlbG4B88OvSTnr+uJVIWh6RROLFiT6SY2b/peA82fzchtJIdevLxTwVklHCOHFIXaZjAbPAvr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/7/25 07:25, Kuniyuki Iwashima wrote:
> syzbot reported the lockdep splat below in __kmem_cache_release(). [0]
> 
> The problem is that __kmem_cache_release() could be called from
> do_kmem_cache_create() before init_kmem_cache_cpus() registers
> the lockdep key.
> 
> Let's move lockdep_unregister_key() from __kmem_cache_release()
> to slab_kmem_cache_release() and do_kmem_cache_create().
> 
> [0]:
> WARNING: CPU: 1 PID: 6128 at kernel/locking/lockdep.c:6606 lockdep_unregister_key+0x2ca/0x310 kernel/locking/lockdep.c:6606
> Modules linked in:
> CPU: 1 UID: 0 PID: 6128 Comm: syz.4.21 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
> RIP: 0010:lockdep_unregister_key+0x2ca/0x310 kernel/locking/lockdep.c:6606
> Code: 50 e4 0f 48 3b 44 24 10 0f 84 26 fe ff ff e8 bd cd 17 09 e8 e8 ce 17 09 41 f7 c7 00 02 00 00 74 bd fb 40 84 ed 75 bc eb cd 90 <0f> 0b 90 e9 19 ff ff ff 90 0f 0b 90 e9 2a ff ff ff 48 c7 c7 d0 ac
> RSP: 0018:ffffc90003e870d0 EFLAGS: 00010002
> RAX: eb1525397f5bdf00 RBX: ffff88803c121148 RCX: 1ffff920007d0dfc
> RDX: 0000000000000000 RSI: ffffffff8acb1500 RDI: ffffffff8b1dd0e0
> RBP: 00000000ffffffea R08: ffffffff8eb5aa37 R09: 1ffffffff1d6b546
> R10: dffffc0000000000 R11: fffffbfff1d6b547 R12: 0000000000000000
> R13: ffff88814d1b8900 R14: 0000000000000000 R15: 0000000000000203
> FS:  00007f773f75e6c0(0000) GS:ffff88812712f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffdaea3af52 CR3: 000000003a5ca000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  __kmem_cache_release+0xe3/0x1e0 mm/slub.c:7696
>  do_kmem_cache_create+0x74e/0x790 mm/slub.c:8575
>  create_cache mm/slab_common.c:242 [inline]
>  __kmem_cache_create_args+0x1ce/0x330 mm/slab_common.c:340
>  nfsd_file_cache_init+0x1d6/0x530 fs/nfsd/filecache.c:816
>  nfsd_startup_generic fs/nfsd/nfssvc.c:282 [inline]
>  nfsd_startup_net fs/nfsd/nfssvc.c:377 [inline]
>  nfsd_svc+0x393/0x900 fs/nfsd/nfssvc.c:786
>  nfsd_nl_threads_set_doit+0x84a/0x960 fs/nfsd/nfsctl.c:1639
>  genl_family_rcv_msg_doit+0x212/0x300 net/netlink/genetlink.c:1115
>  genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
>  genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
>  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x846/0xa10 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x219/0x270 net/socket.c:742
>  ____sys_sendmsg+0x508/0x820 net/socket.c:2630
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
>  __sys_sendmsg net/socket.c:2716 [inline]
>  __do_sys_sendmsg net/socket.c:2721 [inline]
>  __se_sys_sendmsg net/socket.c:2719 [inline]
>  __x64_sys_sendmsg+0x1a1/0x260 net/socket.c:2719
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f77400eeec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f773f75e038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f7740345fa0 RCX: 00007f77400eeec9
> RDX: 0000000000008004 RSI: 0000200000000180 RDI: 0000000000000006
> RBP: 00007f7740171f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7740346038 R14: 00007f7740345fa0 R15: 00007ffce616f8d8
>  </TASK>
> 
> Fixes: 83382af9ddc3 ("slab: Make slub local_(try)lock more precise for LOCKDEP")
> Reported-by: syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68e4a3d1.a00a0220.298cc0.0471.GAE@google.com/
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Thanks, added to slab/for-next-fixes


