Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3B7606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bqxXwkW/
Received: by kanga.kvack.org (Postfix)
	id 8A8DC6B076A; Tue, 27 Oct 2026 10:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8591B6B076B; Tue, 27 Oct 2026 10:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9AF6B076C; Tue, 27 Oct 2026 10:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 438566B076A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:00:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4F1BC0A13
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:00:20 +0000 (UTC)
X-FDA: 85368565800.07.FB71F91
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id C6E554000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:00:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="bqxXwkW/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3ca7gagYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3ca7gagYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAMT5ErMlUqsPBFer4Lu1BUk2YLaErYsWfjiGygyJKk=;
	b=aWaFa67sSr1gxBMNYlTOYV4Rni91M1xRLhqHz93+X4moPPhlwe7XVI82tl22S6kWcodOjo
	+OoHxU55gqvvthhmMvBMvOtijQeuOWQYK3+vUcqihYsLMUyBVreiLS1fynYmSAUPvTdFhM
	Z4+mUpAMdMNjtNFYl+J81a/l9ElpDxo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="bqxXwkW/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3ca7gagYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3ca7gagYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109618;
	b=1eAyOM4Nsmlop3T1ZscDhUPeUF/n3a1CBeQegD83d+JhJHDPsQoAIGRAKeUmtpXfMY5fUh
	4wzXiLDV7R0Ww6oFCzUkE+DxWAIZeCj0gQUxlp2gRY9VLyCRDhRPBxeZmgrUa2dRkYDQbW
	mFCzoEiv2YgY03MSoH4S33icYu6UICA=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2eaf3f829b3so3431055ad.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793109618; x=1793714418; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iAMT5ErMlUqsPBFer4Lu1BUk2YLaErYsWfjiGygyJKk=;
        b=bqxXwkW/lETEEq/vJVrkGrBR8IPHsajpbxm/zi0CSNI7wsf1h4WbFvhYPA/frNQG7x
         8qlVcjSWVD7jDd7L1QriSodGCodl0Bm9ebBExT2iB4M2ooPByiYFU9S4OvgOZMAwS7a1
         E9xXio16THvrMMCfTmSGJ3bTOGvLmqqT1/PQHAMZZH5OJQGJbRmGjHw6Dx5UMDh51uKO
         uAwIlpEssEvhcbKKYm4d85SLfsq4nxJXmeZ39CdobOBQF3rKSvHexRHOoiVv2EZ01LMY
         kV8Ch4TKcsD+MYqb0BXHB81Bixy4ABwdnepGUmtS7fdUtyOY0ZQL4BBng93Uohbm5gne
         2Cdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109618; x=1793714418;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iAMT5ErMlUqsPBFer4Lu1BUk2YLaErYsWfjiGygyJKk=;
        b=gbLhG9iRx0nKgdkUUXpk/IxKPRyRRjzyiH1PpwIXQNK4xB74SeZ+e3vnu+0+ZMaCEy
         YLyqFTLvGzgbGX62twyR2pkd0LcGDQR3XZYvWtVi4bcfVkObN3QB9A51cQtdha+NRruc
         3OZLY3SdJAXvBMbrke1tpRTSkARfuApgVgtKEe5a4QRxfJnB1hEI6daBxCgApUnFxgJh
         orZWLYK+Y4SiLmLDW03myqDHz6uTj6MnpN+QB1U3FoiZve8PTaH/vVgxMbdP/KVebbN9
         4G+BX+Lhg/JlqpUvpcRkkchBRjiyfq9+A+Vlb5KCV08GqolUVUpg7j68CmOtvF248kKU
         ENaQ==
X-Forwarded-Encrypted: i=1; AKwUvBxegpp++d6ffhhenRVgB5mjilpvYt3WH/sf5Wgp44/KJGxoVsw/n1mUOdn3cJYnKVpLS5wJmhzpkg==@kvack.org
X-Gm-Message-State: AFq9FYJzgR4f3+3VOJT4dGJgRdK/vHs4oKh2IzVl0dVId+YnvtzXTYWJ
	Nclv3eMod3wFD9EpZml9uOO+OQTpvCUu70QCJRtzwWv+CkCns5JfBJUtJWKxnuBjCmX624NK6bW
	RNxb9Ag==
X-Received: from plvx8.prod.google.com ([2002:a17:902:9a48:b0:2e8:410e:b193])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc9:b0:2e6:c39:b25b
 with SMTP id d9443c01a7336-2ea9c6c835cmr77726895ad.14.1793109617334; Tue, 27
 Oct 2026 07:00:17 -0700 (PDT)
Date: Tue, 27 Oct 2026 07:00:16 -0700
In-Reply-To: <20261026224305.1254-1-hdanton@sina.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <6adf2939.67317f00.38c4bc.00ae.GAE@google.com> <20261026224305.1254-1-hdanton@sina.com>
Message-ID: <auCucDdZb8mig7UZ@google.com>
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in __refill_objects_node
From: Sean Christopherson <seanjc@google.com>
To: Hillf Danton <hdanton@sina.com>
Cc: Boqun Feng <boqun@kernel.org>, 
	syzbot <syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6E554000C
X-Stat-Signature: r1ehww8fbatokgawigcnqku3jss3mdqt
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793109618-240740
X-HE-Meta: U2FsdGVkX1/sUaQ9fsnzERsypggjfwycsHPhzswGstnTICo0b4OW2nDkRkSUrF492A1LY3a/ZirQYFqesr1tFD2ONyM2wg5IxncfqZYJ11AxZ7Z4nNLdG1IK/qj1fiNX4nDc6e5ZsWsRH/TQ5UGTRg2TUru2hECFP6+Rt8/hoGv7XFYYLA8cDB4rfO494R2y2/Ch/p7PIYREwg3cAvGTyZy4eAdzS2Omh3xS8Yg7O/m+BTn/3xX14ylx7E/fE+ahDLUgmw4d4E70dNlz671dUGH66KTKnwg1op/hPXIzXB7Wr2mkL2efGZOKYQi++qmlRk7E87mczviHept1aq9ucoRPYHG6Q4qyTEcDX/M82Un9qrJ+UTplLNlpYJYr2KnBF0kEb5zEHtu6UTV1tq7OcPd40pX0MO30Rq/job1C02rETP0n4wqAskfWpxr/m+Xvr9+OSn4hmBTjBi+DaBxEVEUGvQDOXk4c18y1qo+k09KHsf2f3ECRSULsDA3EAtTe7omtJq54MQADfMsu19wUEuI0aoD9ld9+KOxupUAk3o3HB6d/THQ+Mc6JTQOHsrGnlGt1dY+Rzu+iH1f2xjrDgbZazDoSY+oZBvCJRSMM7yaVSh6SH0fwrbZWBksFrtzkJOuGDxFiHCgxK7SnFw9MzD9JtWUE2ePoIvakKPEH3DOW/grQ65KzAMInv0fBbUFhpAn0GBdxN3vxKiafbRdsdkYG+ZBiXdBXIJOyeWsgLszfk5ZJxWB1Tf+B33bkYT/Goyz5k8InKxZLVFjYjifukRtuL4qIVk5TrHuBvQZ/7e8Q83UvxPPrPfLGGr0Zz5L+1Ngdx+7bUjHDFKJRE9ziGvWujgJzBtoujd15dPRgsAjm6B6LzFzVWmBmjZ4ptSWhT2Nb4bRXB/gH3ekVvqgCQ9AN4uuezm4i4+GYVCwHt5lZlN19EQHqF+bq+u0qfCHKDx75yBCpcX1sZ9Es6xT
 37sz8knQ
 Aqf6Y5yfR09GdP9lc7Ih2fD+G6yrpIAFq61ChBWL0iopt7Cgo//45WygMKgiXjiBlqsrkEQcpHvvZUM8oIWoZAbfJgVg6qL7StKFwyul3U45IBaQAC0IQNYBTP+C1hf74kK6io/+fzcrXEo9sTU1xshhNBVrD87q/sr0RZtyMwdvyoug6jL0P3Tj6gZHBMvkhf3C3lvbJjxEDBe57NjIYEYOQZsv7U6h9SfyyYWHVXB2BKQ6oUKiWAG36ko+V4ZaaQqXeBt6ypsiKqCRILLm3RJjBVVEBoUempCHjMxjeHarSaFgJNLZr/7VHFXDLP39vV3eyJbk7dR6JUHDd6bM3MZqoA7bFFd999OWOJnwFa2WsyqtjcYMqGkEw4Cknar/6t2YqezNIGRX+EQnr/woqVnkemKYe+qqD+7tZ9nRWw8BNRGUyGn28BCdH1MikyP5q8ayvPK6370YQchSCnJmKinRNw3Zi+9PJsJ+OVGGC/YQDtb+zFKQ+WPoOiXmi8SmotwEmBHwZB7zUwKtgZgk4gYtHnVxOVg6U1TgLDwWeBlGATRt3bfa4tK6VvdgEsQHstbcvKMIrqvY+SHUt0E7/ibJpsQaz5nwoHE4ZxVUlt1ut2xKqolMhkC2rix/e3V1YcImrCypPhlsgMJRfA4tMCSF0HzCnAJgyruX9qytqVW6bJ2MznglEJk8i7/wBcqpMDcvrlOCDDFOi4PFDmSZpxaHj+hwp4GWa4ubZFONWnLmkCyFyGsvEUW+IzEcSAde7Vv8OHj+EsdpsLk0TaJJGt4BzmJgXqCi5K61JWgo6PZm2hl2fGtqIUQYh0albqiHOhibAO71kMulCJjKn5F8LlvjwIaLwEsF0sYxxLV32RJTDHkX8qSzeZuiEKUNlEkVa8z4yceHIs5aJWz6Vaeudxx5mlj3UzfHc71JrwjHRB798lWSw9hPbQfJk5DYwSU92TONZ1BjqNZQkfOHRLDADt+utRf+N
 gO5xpp/O
 3XK9oLlw3sqAtbu4kfM3qkZiQkk5ulHOoV4lMYi0CpkW4jlA2ifwjZkb3oWD1lyd2GEQF9a2UYk1MZGHACELxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+slub folks

On Tue, Oct 27, 2026, Hillf Danton wrote:
> Ask the locking people to shed light on the warning.

get_partial_node_bulk() is waiting on a non-raw spinlock while in hard IRQ context,
and it looks like __refill_objects_node() would do the same later on.  On PREEMPT_RT,
those spinlocks become sleepable locks, which is what triggers the splat.

The alloction coming from KVM-as-a-guest code is GFP_ATOMIC, so I think that wonky
code is fine.

> > Date: Mon, 26 Oct 2026 03:19:37 -0700	[thread overview]
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    c03c1a14507d Linux 7.3
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > console output: https://syzkaller.appspot.com/x/log.txt?x=128d8ca5580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=129d675874dbf896
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f11512d1e5878ba5e60e
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168d8ca5580000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com
> > 
> > =============================
> > [ BUG: Invalid wait context ]
> > syzkaller #0 Tainted: G S                 
> > -----------------------------
> > syz-executor177/6041 is trying to lock:
> > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: get_partial_node_bulk mm/slub.c:3831 [inline]
> > ffff88801d040618 (&n->list_lock){-.-.}-{3:3}, at: __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> > other info that might help us debug this:
> > context-{2:2}
> > locks held by syz-executor177/6041: 1, last CPU#1:
> >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:198 [inline]
> >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:305 [inline]
> >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_read_lock security/tomoyo/common.h:1112 [inline]
> >  #0: ffffffff9090b438 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_check_open_permission+0x169/0x3c0 security/tomoyo/file.c:772
> > stack backtrace:
> > CPU: 1 UID: 0 PID: 6041 Comm: syz-executor177 Tainted: G S                  syzkaller #0 PREEMPT(full) 
> > Tainted: [S]=CPU_OUT_OF_SPEC
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> >  print_lock_invalid_wait_context kernel/locking/lockdep.c:4874 [inline]
> >  check_wait_context kernel/locking/lockdep.c:4946 [inline]
> >  __lock_acquire+0xfcc/0x1f40 kernel/locking/lockdep.c:5238
> >  lock_acquire kernel/locking/lockdep.c:5942 [inline]
> >  lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
> >  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:155 [inline]
> >  _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:181
> >  get_partial_node_bulk mm/slub.c:3831 [inline]
> >  __refill_objects_node+0x104/0xab0 mm/slub.c:7279
> >  refill_objects+0x58/0x410 mm/slub.c:7405
> >  refill_sheaf mm/slub.c:2885 [inline]
> >  __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
> >  alloc_from_pcs mm/slub.c:4850 [inline]
> >  slab_alloc_node mm/slub.c:4984 [inline]
> >  __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
> >  _kmalloc_noprof include/linux/slab.h:991 [inline]
> >  _kzalloc_noprof include/linux/slab.h:1312 [inline]
> >  kvm_async_pf_task_wake arch/x86/kernel/kvm.c:224 [inline]
> >  __sysvec_kvm_asyncpf_interrupt+0x334/0x610 arch/x86/kernel/kvm.c:338
> >  instr_sysvec_kvm_asyncpf_interrupt arch/x86/kernel/kvm.c:327 [inline]
> >  sysvec_kvm_asyncpf_interrupt+0x9e/0xc0 arch/x86/kernel/kvm.c:327
> >  </IRQ>
> >  <TASK>
> >  asm_sysvec_kvm_asyncpf_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:753
> > RIP: 0010:memcmp+0x156/0x1d0 lib/string.c:665
> > Code: 0f 86 fb fe ff ff 48 89 d8 48 89 de 48 c1 e8 03 83 e6 07 42 0f b6 14 28 48 8d 43 07 48 89 c1 48 c1 e9 03 40 38 f2 40 0f 9e c6 <84> d2 42 0f b6 0c 29 0f 95 c2 40 84 d6 0f 84 45 ff ff ff be 08 00
> > RSP: 0018:ffffc90003ab7538 EFLAGS: 00000297
> > RAX: ffff8880220be413 RBX: ffff8880220be40c RCX: 1ffff11004417c82
> > RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8880220be40c
> > RBP: ffffffff8c58a940 R08: 0000000000000001 R09: 0000000000000066
> > R10: 0000000000000066 R11: 0000000000000001 R12: 0000000000000012
> > R13: dffffc0000000000 R14: dffffc0000000000 R15: 0000000000000000
> >  strstr+0x109/0x170 lib/string.c:743
> >  tomoyo_add_entry security/tomoyo/common.c:2157 [inline]
> >  tomoyo_supervisor+0xf47/0x1340 security/tomoyo/common.c:2238
> >  tomoyo_audit_path_log security/tomoyo/file.c:169 [inline]
> >  tomoyo_path_permission security/tomoyo/file.c:592 [inline]
> >  tomoyo_path_permission+0x270/0x3b0 security/tomoyo/file.c:577
> >  tomoyo_check_open_permission+0x37f/0x3c0 security/tomoyo/file.c:782
> >  tomoyo_file_open+0x6b/0x90 security/tomoyo/tomoyo.c:334
> >  security_file_open+0xb5/0x1e0 security/security.c:2739
> >  do_dentry_open+0x588/0x14d0 fs/open.c:973
> >  vfs_open+0x82/0x3f0 fs/open.c:1101
> >  do_open fs/namei.c:4836 [inline]
> >  path_openat+0x1a23/0x2450 fs/namei.c:4999
> >  do_file_open+0x20e/0x430 fs/namei.c:5028
> >  do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
> >  do_sys_open fs/open.c:1423 [inline]
> >  __do_sys_openat fs/open.c:1439 [inline]
> >  __se_sys_openat fs/open.c:1434 [inline]
> >  __x64_sys_openat+0x12d/0x210 fs/open.c:1434
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
> >  do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 

