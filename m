Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C15CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 05:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9790C8E000D; Tue,  7 Oct 2025 01:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950DE8E000C; Tue,  7 Oct 2025 01:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866EA8E000D; Tue,  7 Oct 2025 01:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 731B68E000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 01:25:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 010E7C07CA
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 05:25:41 +0000 (UTC)
X-FDA: 83970180924.02.E7E6889
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3DE9C40004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 05:25:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QQ+chVaY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3UqTkaAYKCHsjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UqTkaAYKCHsjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759814740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sVx5drKFwVzqn3eQc5RTDcIwfCUTclS4BShEi1+OXj4=;
	b=GFmE1ThJbI9vDH+MO0MwepKhKh9rak84JuW1AskurEnQjYzHAfI/mFLgIZ64GrEAtuD+T/
	9SrNRnAHM5YfXglqZet863x6URJiHwqCmmDQiguLyroc1lh5Ugd31debRgUL61OlDdkIN/
	YHY9YmDHs/4M6nfj+cepMqMJLaeKdvk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759814740; a=rsa-sha256;
	cv=none;
	b=6VUIxhmJIY7ag9u72r46RzJr41EpsgYdgQamhqXKoyBP6aPVC9xQ8FwIEAMz5+O3iM4z+M
	I9WBaqyDtq8FaFuUSS3uaveO7arjBdogZ8X1bOqbNFyFzmd64/BrObC+5z1oq1LzcO6qYH
	x9LgkmUK10GzklNXZrf2rN35/Ipm348=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QQ+chVaY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3UqTkaAYKCHsjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UqTkaAYKCHsjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3352a336ee1so10541617a91.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 22:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759814739; x=1760419539; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sVx5drKFwVzqn3eQc5RTDcIwfCUTclS4BShEi1+OXj4=;
        b=QQ+chVaYtb3+2raTJTS1G8EslNOP/oqpk9oUkpa6MxWnrCSqiHuCkLmxKxa2F+siWT
         ueWbRIkg3gqT+XO1t0PvEUdKlDUAyrKk2LNyFEd4fACYKdD130uN6GtIBUvnmts2Deju
         JlpxUZAgJo4zx6VLniEiD10+r6t7gGMnLLBC3FZiznShKBz8BUqifeLs9aJwy81Nk5AG
         QgT6MaCnKrWhFRvqhxtjxMUpDj+wgS78aZ7TdpgxF7Me+Tt9cglrr0/BiWWKGunc1u5x
         od/ULT1JjAOw8Fd+o6v9830JoHpwcuxPxxrDEeCOrwnu/qK22vZg4Ac4C37UdH1bQWjy
         hthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759814739; x=1760419539;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sVx5drKFwVzqn3eQc5RTDcIwfCUTclS4BShEi1+OXj4=;
        b=k5wcUyXSoYfu2Dg+EbdMvkBJBQBy8f+VXwsw8PaR7AFx3f8rhO2IdmHADpURclfgzJ
         ZetKrQxsoG+zw3WY7fQnTkEFRjb9cdwwnkNMEoO6OnxIss0ONS38c3mr+kqcKjL48ue1
         DJUWyOGtx9iAjKyVsebbt/aeJTCZ9MhEwLxmvqBXIDDjWEKEUj/RXOpTsGISWIwrMeJQ
         2X0NZWG21AfvEFgBZZPCj9gVXXp3Sl8KfQK2215kRqiqMfeoheZ0BIrgGnd7/tkiwrr9
         cvYWpVBiP++cCQnuYLKnQ6g5zIDclfXDq7SKrbd8JHIBbWTCG0JNS9rmTSSwX+NFEa2W
         GEXA==
X-Forwarded-Encrypted: i=1; AJvYcCWSxWUjWHZW+0eEtK2nLxg6VFFB0ZSGeAVJQ2E5uITCLToj0WgQQIGFGN8deoAwxZYQR0oIL7IxlA==@kvack.org
X-Gm-Message-State: AOJu0Yyw7f+SC/krGlBmBNlBVDHNDJ1FU/7SRvf/koBbSgvj+FW/GKED
	ZoYuVYWPfUP6MWGSLP1gKBBzDTUt+UG5BIamDn2Sp9DFsFCS08r1tjNHYjEu7pIwY8UQ0IjBNGA
	nHejTVQ==
X-Google-Smtp-Source: AGHT+IGXi0rknhk2zmHKR6MVHa39tfbnJ5EhKFTBuo5Pon9Kyi6+kKsEhfSi91RgGcFWi01XN1OhefbV7+Y=
X-Received: from pjbok5.prod.google.com ([2002:a17:90b:1d45:b0:330:49f5:c0a7])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b49:b0:335:2d4:8b3d
 with SMTP id 98e67ed59e1d1-339c27bda3emr17913626a91.31.1759814738878; Mon, 06
 Oct 2025 22:25:38 -0700 (PDT)
Date: Tue,  7 Oct 2025 05:25:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007052534.2776661-1-kuniyu@google.com>
Subject: [PATCH] slub: Don't call lockdep_unregister_key() for immature kmem_cache.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Alexei Starovoitov <ast@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: dkeruyxz4cw1yst684oy8e8cpxoweuau
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DE9C40004
X-HE-Tag: 1759814740-738325
X-HE-Meta: U2FsdGVkX1+prsM98zcCUHu0I0VV5Zr+qdyINNsO3VpBCxsJrx/U1hzLDWbpTpjKSe3HbRcT/qPmze22u0A/pRMVCX2zPfAp3f/Yp9YVDfyc1A+FqNSrUtn3o5knkNVzXwFpxQg/9gKOuCRivtbwjpm/nCBHqKrreHXsKSF49G5dhFXXUhg6u9bXj5c/X0RSDknK7pIQhmHcjXOowdxEiTiDyt7SP9vlUn1kWz5LaWfrkTKnZj9LQNdh6AlU6XBUb/eMmaYflGVYbMAd9DqJLkZk/bvukk1XDruzgJqXvIwYdVjY2MZe6+0syUXn6jj6cNg9u0D3TMx/E+xwiHzNiebQY/5MRyCruCc/qpvZh4O9z2xnBaj5U/n1xYyxi6sxd7adMhzS5clXkvhHgThuFmvdMxOn8VDDsVj/T2XJ/nJPuCAAk3i3rfSyRQLS0CbJk2wBWM5fjdESmwQimZgNRwMpJGZFn/5YcgD0suTPhbmsiTQcPV+hz1sU4O6GVoIBWTYn3qsSpiGB2SPBH64eXn1r2r7U/e545M2G/au9r4akQwcWuVve1V5g5Ayeuhi1YxefLapp+J4C3YjuSyKUhGzZQMe0xgnkEaHUbKxM1EOSbiC7I1m1SODnnIXZQUuRsoB6K36nPgJqnpSWQ5zeDUINI37tnTI+O7R6Pmt3TOXvfabO1EcflstTdd0ZyPUQxmuuuPcCWmfoG6KdaIYreErEVKCDRm27IeB/HX2e8/ZJ0tETRgs9jwuNPZETX7C44EomazCSFXryazLxmF27NzanpJ7+bbZVsP6daGDw0Sw9voRKdaqrKKsr9CV3gUJbwHktBzblmUSqlf0yduHK4NEwwp2CZ/PXLi9PsbFBot6a44ZgL8V4Mjhq3XNupNHnfa0ELHTnthW9FplDA7A1ss84hGgYScCGcGYs3+g2Uj/QgfebcLxft2sB9xOr8rmIpo3vuaId2DGA/5OWya/
 WxeWks0R
 jRKvo2K9/DXxVLRuO2z3+yjvfVfP0ZYUCFFzaQDX8e1A6MmRv3bSgPd8CUoKULXNFZtK8GBlwW5sPboAI6jo5p4dB6UZucNcD1GJNGI1Kt4+/I2gFCLqDoN/Z5oo75Zcs2HLXL5eDHHCPwmL1VBeOxOsQN5S4Z4Mt8YQFr0Lr3SFCs2ld4hciwJcbnYvVxPd8gT/o4MjHBT6Ii08THomtvOJj8tpb/2dO8nnMRtaLe9OzdJtOX3U07ouBEIC889ZYScnBMx5/YAqJKJhrgM7hot7Mk5gbkRD0x58yG3pJWEr0ZmbW3d2PPYp7ofX9hTM8AbQcn+3ahz+ek6wcDcuPZ1CXEhj39hDyM9Yyn3ggdLvN+dhaDBHZse6aKC8UkPyYe2zy3gjtBEoVVxQYQey3MI5v1yacn/hqDTD6PH5wxa2WXPntlZk9++jyBfqJI7e/wB2yw4Yfvnty8/uMhfNZNNtbAbb7l3U//ypjCr2Ky5L+utQ6R8KRJbQj0CTAh/hW51aMnkNBKucNreKlmzAOh7PijhuQvOrwa4nTi2jlde23eLlYVTSyaudDHGcXvzf3UPOP4NATfElggRUzE2uc+0FRMo7tOsz8OTjGgnNBYE9Rx7Qc9xEwjRnRfG8ed+/U2GSPm+3K5KsZWFjKL0XyaSxqyKsF4vo8uJJYCEaosp6gC8vL3yEEfjWBO7FKXikTX4Ll2Ytsmv91WEvctv0Jnr+HEFHfwyk93YEkB+oLJxhDUieI1YIGCo0Km/XwG3QsCN9hRcTuj0+y4QM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported the lockdep splat below in __kmem_cache_release(). [0]

The problem is that __kmem_cache_release() could be called from
do_kmem_cache_create() before init_kmem_cache_cpus() registers
the lockdep key.

Let's move lockdep_unregister_key() from __kmem_cache_release()
to slab_kmem_cache_release() and do_kmem_cache_create().

[0]:
WARNING: CPU: 1 PID: 6128 at kernel/locking/lockdep.c:6606 lockdep_unregister_key+0x2ca/0x310 kernel/locking/lockdep.c:6606
Modules linked in:
CPU: 1 UID: 0 PID: 6128 Comm: syz.4.21 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:lockdep_unregister_key+0x2ca/0x310 kernel/locking/lockdep.c:6606
Code: 50 e4 0f 48 3b 44 24 10 0f 84 26 fe ff ff e8 bd cd 17 09 e8 e8 ce 17 09 41 f7 c7 00 02 00 00 74 bd fb 40 84 ed 75 bc eb cd 90 <0f> 0b 90 e9 19 ff ff ff 90 0f 0b 90 e9 2a ff ff ff 48 c7 c7 d0 ac
RSP: 0018:ffffc90003e870d0 EFLAGS: 00010002
RAX: eb1525397f5bdf00 RBX: ffff88803c121148 RCX: 1ffff920007d0dfc
RDX: 0000000000000000 RSI: ffffffff8acb1500 RDI: ffffffff8b1dd0e0
RBP: 00000000ffffffea R08: ffffffff8eb5aa37 R09: 1ffffffff1d6b546
R10: dffffc0000000000 R11: fffffbfff1d6b547 R12: 0000000000000000
R13: ffff88814d1b8900 R14: 0000000000000000 R15: 0000000000000203
FS:  00007f773f75e6c0(0000) GS:ffff88812712f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdaea3af52 CR3: 000000003a5ca000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __kmem_cache_release+0xe3/0x1e0 mm/slub.c:7696
 do_kmem_cache_create+0x74e/0x790 mm/slub.c:8575
 create_cache mm/slab_common.c:242 [inline]
 __kmem_cache_create_args+0x1ce/0x330 mm/slab_common.c:340
 nfsd_file_cache_init+0x1d6/0x530 fs/nfsd/filecache.c:816
 nfsd_startup_generic fs/nfsd/nfssvc.c:282 [inline]
 nfsd_startup_net fs/nfsd/nfssvc.c:377 [inline]
 nfsd_svc+0x393/0x900 fs/nfsd/nfssvc.c:786
 nfsd_nl_threads_set_doit+0x84a/0x960 fs/nfsd/nfsctl.c:1639
 genl_family_rcv_msg_doit+0x212/0x300 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x846/0xa10 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:742
 ____sys_sendmsg+0x508/0x820 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x1a1/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f77400eeec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f773f75e038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7740345fa0 RCX: 00007f77400eeec9
RDX: 0000000000008004 RSI: 0000200000000180 RDI: 0000000000000006
RBP: 00007f7740171f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7740346038 R14: 00007f7740345fa0 R15: 00007ffce616f8d8
 </TASK>

Fixes: 83382af9ddc3 ("slab: Make slub local_(try)lock more precise for LOCKDEP")
Reported-by: syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68e4a3d1.a00a0220.298cc0.0471.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/slab_common.c |  3 +++
 mm/slub.c        | 11 +++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 932d13ada36c..baa934cad7ac 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -479,6 +479,9 @@ static void kmem_cache_release(struct kmem_cache *s)
 
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
+#if !IS_ENABLED(CONFIG_SLUB_TINY) && IS_ENABLED(CONFIG_PREEMPT_RT)
+	lockdep_unregister_key(&s->lock_key);
+#endif
 	__kmem_cache_release(s);
 	kfree_const(s->name);
 	kmem_cache_free(kmem_cache, s);
diff --git a/mm/slub.c b/mm/slub.c
index 584a5ff1828b..8da20552995a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7692,9 +7692,6 @@ void __kmem_cache_release(struct kmem_cache *s)
 	if (s->cpu_sheaves)
 		pcs_destroy(s);
 #ifndef CONFIG_SLUB_TINY
-#ifdef CONFIG_PREEMPT_RT
-	lockdep_unregister_key(&s->lock_key);
-#endif
 	free_percpu(s->cpu_slab);
 #endif
 	free_kmem_cache_nodes(s);
@@ -8551,7 +8548,7 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	if (s->cpu_sheaves) {
 		err = init_percpu_sheaves(s);
 		if (err)
-			goto out;
+			goto out_unreg_lockdep;
 	}
 
 	err = 0;
@@ -8574,6 +8571,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	if (err)
 		__kmem_cache_release(s);
 	return err;
+
+out_unreg_lockdep:
+#if !IS_ENABLED(CONFIG_SLUB_TINY) && IS_ENABLED(CONFIG_PREEMPT_RT)
+	lockdep_unregister_key(&s->lock_key);
+#endif
+	goto out;
 }
 
 #ifdef SLAB_SUPPORTS_SYSFS
-- 
2.51.0.710.ga91ca5db03-goog


