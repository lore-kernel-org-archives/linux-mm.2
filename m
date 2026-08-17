Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 112AAC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959CD6B086A; Mon, 17 Aug 2026 13:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932006B0870; Mon, 17 Aug 2026 13:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844206B086A; Mon, 17 Aug 2026 13:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 378706B086A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:22:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 279921408B5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:37 +0000 (UTC)
X-FDA: 85111430754.29.ED860E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA88B160009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEe1Rgng;
	spf=pass (imf08.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyF93ZnyTUdekTmzKqPE1omSkz1iyLb7A9KhDZnAcHo=;
	b=ihr3hShjI9zsie5B7x/CdMR1/k/p28fe8Bapf9O9B+ZLr5L9xhcpGI4VX+HfSo+lWanlzb
	5oKL7HhDJgDR3vBHR6EOZ3fTz6+DAsroXV2D9C6q9TNu/IRzQUnVpFb/w8xb+4ecU0tF6Q
	41fjr29D8zxz+HLWqo1+bbkYzsDeBSc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEe1Rgng;
	spf=pass (imf08.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987354;
	b=qJ1xCamjRsZbpOSyddLpZFyN4v6/dnmH4YJ9JkwJuWgFDwOhCNlS1mE0+JjKaapS//5b9q
	f1WUTZYOFLdBslueTG5Gx6o56ZtBxPUeU4bEeoXMGGMucJ97myWk1ecz0Vq6o7oQ/dlpoO
	tdhGutHf06uWNxt4ZkIXf+lawfZ/Efk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D456A4402E;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B05C7C2BCB3;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=fhESJZkT3dt+FWfSd+5ODq+pnQHRM69JmKzx1lJIoGI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nEe1RgngU7hWi6QzG3SRyBWsrwPY+60K2wmtzNihcpvUPASEmjmSLi3gi7hayFCCk
	 IUXJxlZBJpfMvCu0ix6nT0WmIHv8ywF+YEJJeLN9WoltOLIa/xMo2QEQyC7T0RvHMU
	 1t236Sl7V865qlcaHHGP8OUlqYhB4atHWZFKlht/4hjOTfZgupGJYBuRS9eFTN7E0f
	 jR+Pja7ixj40k1SB7C/L2IsWJHMbeo3G+JLMkCwCsU6eVi5a2roTVR6BgVmk3CTMWh
	 hDqmnl+RwffQwdmbzG9iqgz6JfOu1Z0N8UgSaJMrBiYE2Y66FT+e3y5rs3T5xcylVD
	 u2w5eaHQesd0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870AAC5DF7A;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:21 -0600
Subject: [PATCH 7/9] locking/lockdep: Traverse adjacency lists directly in
 zap_class()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-7-0c1d230aa3af@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=2976;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=hMKyeAzj/0W3e7KdVMK4R3bJ4a3wyr0GUNnn4brlNlA=;
 b=cVjWa7I7YRjvCbMAMfBdBJT9zR8GIbatJK/6HvfTX7JD0l04eiM+7EquE8bXjJ92ce34JZutn
 a7J6heYfMsLD2cIK/pUbgoI3R654HF7l7BScqyxe7goKAXWygZzkVHY
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA88B160009
X-Stat-Signature: f16k4q4k3r3irkohdfwux3pnr3g35xhr
X-Rspam-User: 
X-HE-Tag: 1786987354-568914
X-HE-Meta: U2FsdGVkX1/akEa+CdnOxbtCMAYdvWZbd4sjtAuBS7zlHd/eddeDcCsS79PfK2NA9u67W1zpaouysDNkynEDMC7hCxUmPIxjeqNM3AKAXL9mCAPQAV9QffioF3w9bquxPJrszBd7l9cogwbCxyyB7WGaK4drm6X6zRhP0imMZ5fl420hB/RsMWWlVsqav5W5J6hOjSvhsLtKIIweXNfzXWj7pyLFvoM/U5uhMxYkocXDefZYZzM/VBWVJ0Q0RVwdlMxJqoJYdgjbfyCKnXxRiuSAlJ1lhnW1IqS/5Vn3As7WkTmoCq/8ZKnrVP1VfDTPpxeKNrnBjlCfRG+f1dsYxt6gNzxYMeOMCZ1kDMRw3RhqE5ELffmlS+aHWbVK3rf5omLoimrCV3Z/YuWY0udE1eLCw7j261uU512o8AGcmQWiMIGeriF7oTHx1sljzHor7NvqAVlRq3G/fae8+w56AIUE+TUATRQW2AWEUfdW8Su999AcLKX0Vt3TZMA28KdrjlimuXZrffJJnsHJgqq0M3WqtOTQ9Sjv50Y/HFAMtiUfrPeT9LbU1ImOykviwda2q0JR1vfMqzIxQ3asB3JcqV6pgCwmpb2CWH5jEJtBGJiKBJvS+SNKW5NNmWcls5XRHNLoDaRddTzhx8qeTo47IsjQNwoIrS0bH18DHQaAUWIG+oeKzfhFVi8vvxQhyM/XMWyEI3p3M9/PE+5tcrAO5SZgGKxurge4a/xjIrvrhRNS09e5ZVBEYx0CVT6xODcsSvEXJW5fJgdwPuRs/FwxEQnLb+RvPVxT4RGWg0ca/Lv0s17A2jocJI1cIEfHegMVnAFQu06Kh7IcJi/mPFPHF134Kor9A0fcE3EB1JAJh594IqoakvyBeCGsxSIFVtpwwwyB+5BQNv5PnHq0JbvsTQEA1w2GeS8HFQCt2QD/d+KdWDOvuR6hTSSAYfdl2e4WxvsrkqvUX/N/oE0dz4i
 WDEcQuNo
 JNH5zegchYw9o1lCLs0PlcCrSbTmVY0vtGz5b5Es8t/vgp//dLPYWCXbXR8zwFvz8eQvI32Q/Kv2lq6+CNoXOY0yXYfFnvjtQtv+gFCL+t3Z1MVYzi7OkCaCCbjEPFu1JuM0eemgS/vlnPryZ62TwW4vnz02gESNmSnSVXDe8Q6odcv4z0qqLwoRPvy0GMPyuBeydDJVoJqHBQddI7mzBd0+8QkusfYvz/Ucym5yKGRajfFqh6mecOyP0rJUD3iU/0dHjKmW1gIc9iJaCvMupSfkEzcSZmCMXI4X4Kifr2YHC8QIyavHtZtG0nAPtdReFrqtEFWYq1qVcqhEP2rzgsN5rFrAuIsubIBQMOa8iQLeVVwmivi5pSYgzSkbc3koTZaW4A8k8OiIu+nPzyQWy+00oeTcpgkF+0FrdiwQbt8TWpVisoK95zWjQgC9qO5XG44GvHi5d+3Xf74S0k3e+vrzvIf1W5rBJOJygUJYFe0Vc4n3JPlq29zVlNCV4WnA4CRAxRL0IaKNXjKSX+ywiGm9kwa+Ac128lXoDXkNjkCjmSZTdAo9xWo2OfEPxvsO2XDkjVMsOCjSWp/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Cromie <jim.cromie@gmail.com>

By definition, every dependency involving a lock class resides in either
its locks_after (forward) or locks_before (backward) list.

During module unload (rmmod) cleanup, zap_class() historically took a
shortcut: it scanned the global list_entries_in_use allocator bitmap,
testing every allocated dependency across the entire kernel against a
fixed static array.

That shortcut worked only because all dependencies were confined to a
single compile-time array. It conflates graph topology with allocator
storage layout, and breaks down the moment lockdep needs to scale beyond
static allocations.

Rework zap_class() to traverse class->locks_after and class->locks_before
directly, unlinking each edge and its matching counterpart on the
connected lock class via RCU while clearing the respective allocation
slot bits.

This restores the canonical graph deletion flow, touches only the edges
connected to the zapped class, and allows lockdep to safely support
dynamic allocators.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/locking/lockdep.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index f0f58db090ff..c8975c9282bb 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6276,8 +6276,7 @@ static void remove_class_from_lock_chains(struct pending_free *pf,
  */
 static void zap_class(struct pending_free *pf, struct lock_class *class)
 {
-	struct lock_list *entry;
-	int i;
+	struct lock_list *entry, *tmp, *other, *other_tmp;
 
 	WARN_ON_ONCE(!class->key);
 
@@ -6285,11 +6284,29 @@ static void zap_class(struct pending_free *pf, struct lock_class *class)
 	 * Remove all dependencies this lock is
 	 * involved in:
 	 */
-	for_each_set_bit(i, list_entries_in_use, ARRAY_SIZE(list_entries)) {
-		entry = list_entries + i;
-		if (entry->class != class && entry->links_to != class)
-			continue;
-		__clear_bit(i, list_entries_in_use);
+	list_for_each_entry_safe(entry, tmp, &class->locks_after, entry) {
+		list_for_each_entry_safe(other, other_tmp, &entry->links_to->locks_before, entry) {
+			if (other->links_to == class) {
+				__clear_bit(other - list_entries, list_entries_in_use);
+				nr_list_entries--;
+				list_del_rcu(&other->entry);
+				break;
+			}
+		}
+		__clear_bit(entry - list_entries, list_entries_in_use);
+		nr_list_entries--;
+		list_del_rcu(&entry->entry);
+	}
+	list_for_each_entry_safe(entry, tmp, &class->locks_before, entry) {
+		list_for_each_entry_safe(other, other_tmp, &entry->links_to->locks_after, entry) {
+			if (other->links_to == class) {
+				__clear_bit(other - list_entries, list_entries_in_use);
+				nr_list_entries--;
+				list_del_rcu(&other->entry);
+				break;
+			}
+		}
+		__clear_bit(entry - list_entries, list_entries_in_use);
 		nr_list_entries--;
 		list_del_rcu(&entry->entry);
 	}

-- 
2.55.0



