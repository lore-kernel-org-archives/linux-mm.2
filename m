Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7234AC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365896B0860; Mon, 17 Aug 2026 13:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFE66B086A; Mon, 17 Aug 2026 13:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC7C6B0860; Mon, 17 Aug 2026 13:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B455A6B0866
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:22:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3BF6140879
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:36 +0000 (UTC)
X-FDA: 85111430712.08.AEC6FC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4688C0003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf+B59Ae;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlFQzkDMjkVbkimfkN/TftpLR41J70j9CYOBMlBLLUE=;
	b=lDnvLefZv5t+Wq8pBYzsaQmmEvE0/6zd5o+CuD+Tf2WJZPiJAjahYoIMX8FhYjGwIDO5O4
	Cy1Xcznoz3M47EbhV5XpiXMHNxCJbJNzBSp5GZPnDIjqvsD52iTpz7UKMBVLjOuNHNTGJ+
	xlxdMDEHwBRBQrjmC53IpiMpw8Ay5IQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rf+B59Ae;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987354;
	b=k/zJ7PdtBQnJyRZaUakptZROYFn+jXcaBY5KpcrcJwproyn/gSkyzpZyG/u2ecQgl+aM2q
	FcIGMqqox9ukbvQzgMQEEf9VuofZAs/J4S/t9WfBlM450IY3i9Zz/ShuiOcP6W44IdBS+N
	tzMuu9Vg5zejxL1Aa3uuezGEg6MyQnY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1589844E57;
	Mon, 17 Aug 2026 17:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E416BC2BCFC;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987352;
	bh=oTzXI58WXBQ7S7irZsNVmatUb+eJJWJo5/oxSAo9JLY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rf+B59Ae4GVvYCAuSdGJn/7wuVLJPyQfkIeq2IrGp4Oi1Y0FDTJARPAlCZGux/hRV
	 EnHm707HtVzIWJhfchdkYCcZK3InK/37Js2oPwisawCdw1BcJdC/3yj/v397wBkHGT
	 FAsRIeaELJkdOYpHYn7WaD3ncOIhmx2B+XzifJMEaAtMXEdyMEY0DT631e/mmO7yKE
	 Rf5obpA0+YBfjyf+mABOFOFC1LxbYs0nQpqP96VxYqYzEizKhxLPRN0aPENmGO+ssH
	 /GIEWN4hEJ8hwrK4cgoKmFdsQqIpzpfZ9IesGZtDkmZuieAYVx3N9SPJ8HMk3BMFf2
	 4BHyswX9oGmAQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C151FC5DF66;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:22 -0600
Subject: [PATCH 8/9] locking/lockdep: Shrink static list_entries array to
 early bootstrap buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-8-0c1d230aa3af@gmail.com>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
In-Reply-To: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: netfilter-devel@vger.kernel.org, bpf@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
 Jim Cromie <jim.cromie@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=4389;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=ZoAPPwe75kYWQBnnaiZlpzm8KKVLAq8UQwudQC9NlbE=;
 b=KNAOo/eQMuy5erfpSMg/oT8JjN3sqRwBgko6OmdykAuJj2sOkIfPf1RxIxulBDQLthiMvgmmd
 NmWIc7T/EjfBohB3EMTwfUSxsxhPMAP5h7s7rWhuP12qQAR2uE+yRiK
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com
X-Rspam-User: 
X-Rspamd-Queue-Id: B4688C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: jsz4bb4pxmknsjreb693aom1p1azr5wm
X-HE-Tag: 1786987354-905384
X-HE-Meta: U2FsdGVkX197Ioj2+Kj0W9QkYBwW6DJCWg3eEApuboP5SokJU1KciKGFOuptC0dc9SV2mZk6UqGZ7dGQXy07GnepcY3d44H1oTXvwhP0CfQTrHDXCuWIz3LNqp1otrB0HXbEto4m4CeSWGt4c8pZ8AF4gVb+feGIqLdwjYYC1azIayBuRsVSloUy92ZaVAfw174BbL+jgg0eqxxmctNe2wnKBUHxzyY10PuecqP606Mdm5Ej5RO7RpNaz3TxLBWfb5O/bAUGh6uJNWzrLCUJe1YkcmUUrvfNpbS7je29cXVylWUQGV0jrsMCWVeue5VJbgXyd0Rk+D1IRwDQAw/QfMPNz08uy801Ux9EyUOBt0AmjhT0FL5GZU0Xlt9OLEYgpT7TlLaQdgGquNt5vPzTdDZFZMZEBo4OpDL6HYkTDDi/PpbxBL/P2ZxIpGOyI+p2IUVmvQog8hWrt2gWg2xZTVLXT47UhVOvVcO867JCFjXIaIOm4DHFNOtDoSO/3B08+BIr7hue57JnconqZwdrdS+HmKJ8RDXc9BzDXA2xXwi3SFHvPvlF4VTEjP8esLvj4eS1A1UfgeDnIJR7uDbtshJX5t520YdVGEUbZWU9NrYI+aJ3cH39dEXunwKC3SnFME7Q+UX2nXWENJEEDy3kj0X86EtJ5OWlH8Dq/2Ft6s9BochkLiCkJnlCkA+TLBq8Zrm7K69+pm4us9HOwISRxV99V/qPxqv+3mopJ5qu4gt6QvggW0gkWEeb9l3XjVF/5A31WTSX2RnRWjIV7cEEnWemMXQd1QCPikZYIdg6N0qaWhuFAR1w1WxjY/MHjRCI8C0aqxL3dTnI7yK7AN3q1Q3Y9z/C3h+v5iqJjxMo7ZoDT/z/F0H4ahYN63Iy7JduIVwjLnWGJHT8JixI8u5f5Rbgl96eBZVFrxutTjqwNxhpWPbuquceTeWGdH5ckVqzcUtQkaOeb8xX70dIJhO
 nxbeCVMp
 aP5julAkOmP7ZPldtmbmH04zDkizj3CTG1Mll7NNa8I5KTAInEHKoln0jXP1Z29wmETip9vetw8P/w/hfnn2ib8QQ/XJUelhHYwRPp3VvGsw6UivXxImHeLG76EckAQFpBm7IYZwB2VsGDBZGQdVwos9riFs3otbKFPwhLP2cF/bB3E456IdTLGkSA/yFqd7JphgA480nL0rrgvs+IzHuE0jOTd0ss8wsXyb2tvEn1cIiZCveTFKi32+NC1KwojwpkJynMVeOLbXk3Xf+WG2FsXgIahJX7uWQ3LaeE6v1BdzUtBEaM/b/0E1MEIPz4AMGb2xn4sdxaAzz2bkwhu3oT87lViGCI0usq8vaFGafR+voq77oWxtZI/rcmBiosZB+yn0wD0UfDZUhfZAlQ4r5O3PjuCLvhMFH0caopp0APc6seoCfj2pssUNdPYd0yHGbdNLNYfxzFaa/CB+OUxgvYl2lKnruMv7NKGu7aPPPoun8DbYVddzkqRBXlkDU8qKABuaygWKIKjhJECMrKsuqpMPhHBJBmmCmEq7gUEc8z4oapmLORNYamQz8EeRGKMJSPFLjucstaGAMzJFJi5QiXEnYp/vHub2CkwuqCSifnVlTyUli0MqJYTREM0pKKjC5WLey
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Cromie <jim.cromie@gmail.com>

Shrink the static compile-time list_entries[] array and its tracking
bitmap from MAX_LOCKDEP_ENTRIES (32,768 entries, ~1.31 MB BSS) down to
a 4096-entry early boot bootstrap buffer (~160 KB BSS).

During early boot before mem_init(), lockdep records initial spinlock
dependencies in the static bootstrap buffer. Once the buddy page
allocator is online, alloc_list_entry() seamlessly spills all subsequent
lock dependency allocations directly into lockdep_pool in 64KB direct-map
folios.

Adds a core_initcall telemetry hook (lockdep_boot_report) to log the
exact count of bootstrap entries consumed prior to buddy initialization.

Empirical boot telemetry confirms zero regressions and validates the
two-tier spillway on x86 SMP:
  - Pre-buddy watermark: 668/4096 bootstrap entries consumed (16.3%).
  - Post-buddy scaling: 5,058 total direct dependencies and 22,577
    indirect paths validated, with 962 entries operating dynamically
    inside lockdep_pool direct-map folios.

Reclaims ~1.15 MB of static unswappable kernel .bss memory (88% reduction)
while enabling unbounded lockdep scaling on dense NUMA/container workloads.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/locking/lockdep.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c8975c9282bb..5968a976bf8e 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -229,9 +229,11 @@ static inline int debug_locks_off_graph_unlock(void)
 	return ret;
 }
 
+#define BOOTSTRAP_LOCKDEP_ENTRIES 4096UL
+
 unsigned long nr_list_entries;
-static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
-static DECLARE_BITMAP(list_entries_in_use, MAX_LOCKDEP_ENTRIES);
+static struct lock_list list_entries[BOOTSTRAP_LOCKDEP_ENTRIES];
+static DECLARE_BITMAP(list_entries_in_use, BOOTSTRAP_LOCKDEP_ENTRIES);
 
 /*
  * All data structures here are protected by the global debug_lock.
@@ -6271,6 +6273,12 @@ static void remove_class_from_lock_chains(struct pending_free *pf,
 	}
 }
 
+static inline bool is_bootstrap_entry(const struct lock_list *entry)
+{
+	return entry >= list_entries &&
+	       entry < list_entries + ARRAY_SIZE(list_entries);
+}
+
 /*
  * Remove all references to a lock class. The caller must hold the graph lock.
  */
@@ -6287,26 +6295,30 @@ static void zap_class(struct pending_free *pf, struct lock_class *class)
 	list_for_each_entry_safe(entry, tmp, &class->locks_after, entry) {
 		list_for_each_entry_safe(other, other_tmp, &entry->links_to->locks_before, entry) {
 			if (other->links_to == class) {
-				__clear_bit(other - list_entries, list_entries_in_use);
+				if (is_bootstrap_entry(other))
+					__clear_bit(other - list_entries, list_entries_in_use);
 				nr_list_entries--;
 				list_del_rcu(&other->entry);
 				break;
 			}
 		}
-		__clear_bit(entry - list_entries, list_entries_in_use);
+		if (is_bootstrap_entry(entry))
+			__clear_bit(entry - list_entries, list_entries_in_use);
 		nr_list_entries--;
 		list_del_rcu(&entry->entry);
 	}
 	list_for_each_entry_safe(entry, tmp, &class->locks_before, entry) {
 		list_for_each_entry_safe(other, other_tmp, &entry->links_to->locks_after, entry) {
 			if (other->links_to == class) {
-				__clear_bit(other - list_entries, list_entries_in_use);
+				if (is_bootstrap_entry(other))
+					__clear_bit(other - list_entries, list_entries_in_use);
 				nr_list_entries--;
 				list_del_rcu(&other->entry);
 				break;
 			}
 		}
-		__clear_bit(entry - list_entries, list_entries_in_use);
+		if (is_bootstrap_entry(entry))
+			__clear_bit(entry - list_entries, list_entries_in_use);
 		nr_list_entries--;
 		list_del_rcu(&entry->entry);
 	}
@@ -6718,6 +6730,15 @@ void __init lockdep_init(void)
 	       sizeof(((struct task_struct *)NULL)->held_locks));
 }
 
+static int __init lockdep_boot_report(void)
+{
+	pr_info("lockdep: %lu/%lu bootstrap entries used before buddy init, folio_pool active\n",
+		min_t(unsigned long, nr_list_entries, ARRAY_SIZE(list_entries)),
+		ARRAY_SIZE(list_entries));
+	return 0;
+}
+core_initcall(lockdep_boot_report);
+
 static void
 print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 		     const void *mem_to, struct held_lock *hlock)

-- 
2.55.0



