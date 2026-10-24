Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E3C606A323
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HM2cc33Q
Received: by kanga.kvack.org (Postfix)
	id BF8A56B05B0; Sat, 24 Oct 2026 13:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB586B05B1; Sat, 24 Oct 2026 13:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70926B05B2; Sat, 24 Oct 2026 13:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 638A86B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 13:04:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E85361C3B62
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 17:04:24 +0000 (UTC)
X-FDA: 85358143248.07.EB574AF
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 323D440002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 17:04:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HM2cc33Q;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792861463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=liL9s3OOZysVhjqCpf+L1Cp9m5KqZk+Ut2WGL7E2egU=;
	b=KaKTtxSyqpZ/2lcshOF8yhj4NZ2CzeMG0M1TT3hq+fZTQzVkBqqS1Xb/Wtcf+gjtIi9aUY
	pbpqIWy2rB1Lwk9awQlUXLyOFYDC6L0swjQsI6cZiVatxC4au1FXRqIT9bKMlYd4dezslG
	uEgvjKq6ktXHmftwP8TbrRqqwiAwXgY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HM2cc33Q;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792861463;
	b=BM892h4sVUgSFr+VIG9ZmZLuL1DxghNhirhVaU055Xj/8iH/JIlfXYHRQ/y/Umc0qIK5Yz
	0Fofpov2sBolYcwWESV06xfiWSGw931V8yHXwTqgBhWAb2G+EOE//6skWGJb4FkkwQvq+k
	F8Zxiwm93AyWTmJUX6VJDGKjCz3S7Nk=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-536c8f958d7so10002151cf.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792861462; x=1793466262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=liL9s3OOZysVhjqCpf+L1Cp9m5KqZk+Ut2WGL7E2egU=;
        b=HM2cc33QbSxyEImvQxlvsAkfjgKcfAmFKbcFdz1pJ6WMRe83UrREvqCLk3pC8uj5+y
         FkcJfLdp713HCocgoleSA22S6csZxedLJw4ylRcLiGxzjtwptN3sssfo4DecbYj5msYy
         2AW+tWOvJ8LLvcp4GRRSHcC/KgGQhJLuT/i1dwROpUUAFfuTa1Zx9rPV4NJNv5i5Yl92
         3hbB9Sf4CtAvfdcrEnYdhT8fZrbm+0GU6wy5IE34826MJ5k9/4jmRaqwtrm1gRecmkVs
         4zDJUICwM+93N5BkAqdpQyWPxVFhexxf3vmhcVmEaiSQmjYjd0Gy8qJZ2N+xf8x+MZYm
         tebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792861462; x=1793466262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=liL9s3OOZysVhjqCpf+L1Cp9m5KqZk+Ut2WGL7E2egU=;
        b=aj+NexK4zvC749TYk2jHJiLnPtTS6Im8raO5e67bn2nV0iYYwWkAMPLfYTjzT1yOmp
         gxgAn59545ZfyXGhx3vSwE0cBa2E1ip3kuWY03A2VeN0D/5e1bKICeb32kIij1GcipPu
         +h+BRNVlltXTQxB4T278XcUwdWwX5MqBp8NGSE4NJaTXlecq0arKIOfcpBTYra4wPEPs
         vWpS4binJbAX2bVK5gMuDToasxjmybEvuZH9T11wU/ZbU5pE/kaI5ucLw4z39ZSfSisR
         JDextqn+QMl/YOTYsQ8S/28mbxtWHHwTrywS4cg9P8y3FbCBE8Nu169KUtyjR5Xab/95
         5XWQ==
X-Gm-Message-State: AFq9FYIBf4/Wy0iUKdLBlSxpKNgNyH230irkn1rcCuiGR+xdxpHzZbPS
	M4GpzGKUO72MK7G69gNsnBlqCwvvntD6PFxa6OybfwXKq8ihqBPvyrdih5p6iWnqusYD+6XFm2e
	HLM6I
X-Gm-Gg: AYBFou2FUiMUSEKfndMwLtihD7szrrRI8t/X8qG90MdNHhuM+0TfUqfTmK2xKRObR68
	1nF25KMqyAV6qX5BTcpQIR/sEsmRrbRA7/z2RH2ZdPTAo1PrRP17keevYwz7kliZ6b1e7NiiWd1
	ZkG+NR6d48ZsOkHDupqG/9r5ak9r6F+ZUQUgMUKUn41pSpNi5jMGZDtGAF28vWLAADyK19mFYIP
	osFJLflxYzZfAmIwIIX/dD8mb6tX7mS+cfRpV5P+oyfIiuRnKrJq3JDVnlDcBCceVuKBpz59XYt
	JN58cQ32u19br0Qk2cUMyVvx82gZFNc28JBP0DUYLiC04Ikw+OmnO59k/02S1iXslV9i1z9Zm1+
	bdgeQJsjIqjQB+WzN+ws3zBooV6V7kDTsBTpNfEQzfWsoR869bkZYJ9UDdZKWqkAhkvMj1v/bRL
	xdJbXF5dNjqQi1dL1LEy3Z4Uddc9Jg+o8PpMsO3Cmo9kT5uPYY0EtYlEPA/QvLekKnX2PQoGmVd
	oUJ7OQn1VrE17FsqYy6FQBxaKRHCKOJqYtg13W8tc2TQ4kOxxtbu/Sc4su6l4IbpkuKdqC+iX/P
	7PyzdljeGhatkaFWdaSvW5GHJQxjwykZ5qSd9JTZZQ==
X-Received: by 2002:a05:622a:5291:b0:536:119e:1767 with SMTP id d75a77b69052e-5383b605700mr29740511cf.65.1792861462021;
        Sat, 24 Oct 2026 10:04:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c5273sm19020701cf.9.2026.10.24.10.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 10:04:21 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	honggyu.kim@sk.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/mempolicy: recompute automatic interleave weights on memory hotplug
Date: Sat, 24 Oct 2026 13:04:15 -0400
Message-ID: <20261024170415.4121901-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 323D440002
X-Stat-Signature: a3t7w6pjskzshuu6x4wfp4pipjbiaf1r
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792861463-186500
X-HE-Meta: U2FsdGVkX1+79HiyPpEyMXaRVJovPf333gqowCf0Vqid/oVvqd7akVV78sI48q9XDsIpmephSDfrTp+Nnt6Mu5cwIeIf/ImCztCF0SCo42NxVWQlZuQyOCCfWwY/4pTgjRJkTd6Nt8hBWHvZD2ZLKpPSpTfyvbtBpEXiqQra6gf3B65DVRXRl4qfn43eLKbdfm+SEp/1P1qlx7a/FdZFmscT8ltG94oKwW1aI2Sa2dBvm15KQCb/KcC0FA++PG8zQXuNk7sBu5Oi/1d/3Lg0gULhHA/zUKjymo0Tbc7yDMWLH/5hoRY+OpqrxRgANgwfcPI40s6vZ2h9og+t63VxFMfqGnTD9kjgW6dGLhjAbaXOiMUhH3oVxq8Jt3la1y5LgAQBDF9CA9ZvbnUgrVgidCfQclIR9yHq6Jauxq5g7EPPdWsBdvFFgknSSjX/amNjgAAtD930Lvd7L6plR/UTCEEABw67YkOy5/2b83U5DUDAjHvkJ1XBOtZTfwjWfLC8i7RMF7OcinPtLdg8Un+LmOLUag3ASU4W3jlfWRz1IWYKjxu0tI/QIDC3h3Dg6hAkEHaz1Spvvy6P0pOdugSgvGvPMAYnIjtDRLSBYX5vSC/O13xoaBBzSyGib8+j/L148hWkCUml7GWgOwkMuzbXOU2cWIcWUTEL1RoRq8/1gAO1+FmB1Ie7KHIUKSPFfs1jOoXO6+bVTRNMxVxHfST66WsreRx52b6mQ8M47sHQJbWbdeuAFxLvswbVgwzekQJ+TDgC5+RMeuxwoC+cAx7dfdXel4SkSu5ipyLkclDDcq/bOPgZagYf1o65/9EfUrA1fdDzOi68UrBMLhRwKpbZ0oGqhKXkqovPyNQ6HwTItE37dAiiy+9yImJZ5Qkpothoc+umAAfa6QvUS3t53rDxui7Cg8//rZWPeaUVWzAU2zomnDKgV4in8G6pjhoriJ7I78vUs7sXQTg0BeSYR6f
 K7QUcEaH
 GYI+ilyZqZmc6Ezk+5ArLdEnIVm7wKTGDIBUkbrnxPBfVpnV/aLkls57O69JS0TgLBqx8ViTcxQI6r0SQbGWB2vBtKXWohl4S2MMr6shHMbpPwfVkgopWixX2NAVB4cwzYa5FasXkg5AA5l80aMlu7qCJSd2/9oMPHR+nMzclOvRrcHtiILMymP1pDkoXjXfeMQ1qXALa/WMLEt44lcdPtPO+eBFKUm7wZYivN+v78V+kunXLIHbFayJbbFXCHcB0FLhdw+q8WnL5Ptdy5h+cybvjSSMcEJI3a0bQ6q3sIFQrT7LrmePhy037QM3+L9s6fN3vb1XGEJbMADG8zr/YhRw1LV3W7/MRQv8dRT5oImC9XEJcTuJ/1hoyN4iuEfJNPHfm6BZJ+ziCLdzbKz9XeVg1lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In auto mode, weighted interleave derives each node's weight from its
bandwidth, reduced over the nodes in N_MEMORY. HMAT and CXL report a
node's bandwidth once, when the node first gains memory, and nothing
else on the hotplug path recomputes the weights.

When a node loses its memory, the other nodes keep weights computed
with its bandwidth until another node reports. If one does while the
node is away, the reduction skips the node and resets its weight to 1,
which it keeps once its memory returns.

With HMAT bandwidths of 100G for nodes 0-3, and 50G and 25G for kmem
nodes 4 and 5, weighted_interleave/nodeN reads:

  event             node 0-3   node 4   node 5
  node 4 online         7         3        -
  node 4 removed        7         -        -
  node 5 online         7         -        1
  node 4 back           7         1        1

Toggling weighted_interleave/auto to 0 and back to 1 gives the correct
6, 3 and 1.

Recompute the weights from the recorded bandwidth whenever a node gains
its first memory or loses its last.

mempolicy_set_node_perf() now only records the bandwidth and calls the
same helper, so the bandwidth is kept even if allocating the new weights
fails. wi_state_lock is dropped between the two steps, which should be
safe because the helper reads node_bw_table and the mode under the lock,
so a racing writer only makes it work from newer state.

With this patch, weighted_interleave/nodeN reads 6, 3 and 1 as soon as
node 4 is back.

Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 66 +++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..ffb293a4cc56 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -238,27 +238,45 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 		new_iw[nid] /= iw_gcd;
 }
 
+/* Recompute the weights from node_bw_table, unless they were set manually */
+static int wi_state_refresh(void)
+{
+	struct weighted_interleave_state *new_wi_state, *old_wi_state;
+	int i;
+
+	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	if (!new_wi_state)
+		return -ENOMEM;
+	new_wi_state->mode_auto = true;
+	for (i = 0; i < nr_node_ids; i++)
+		new_wi_state->iw_table[i] = 1;
+
+	mutex_lock(&wi_state_lock);
+	old_wi_state = rcu_dereference_protected(wi_state,
+					lockdep_is_held(&wi_state_lock));
+	/* NULL wi_state assumes auto=true */
+	if (!node_bw_table || (old_wi_state && !old_wi_state->mode_auto)) {
+		mutex_unlock(&wi_state_lock);
+		kfree(new_wi_state);
+		return 0;
+	}
+	reduce_interleave_weights(node_bw_table, new_wi_state->iw_table);
+	rcu_assign_pointer(wi_state, new_wi_state);
+	mutex_unlock(&wi_state_lock);
+	wi_state_retire(old_wi_state);
+	return 0;
+}
+
 int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 {
-	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	unsigned int *old_bw, *new_bw;
 	unsigned int bw_val;
-	int i;
 
 	bw_val = min(coords->read_bandwidth, coords->write_bandwidth);
 	new_bw = kcalloc(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
 	if (!new_bw)
 		return -ENOMEM;
 
-	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
-	if (!new_wi_state) {
-		kfree(new_bw);
-		return -ENOMEM;
-	}
-	new_wi_state->mode_auto = true;
-	for (i = 0; i < nr_node_ids; i++)
-		new_wi_state->iw_table[i] = 1;
-
 	/*
 	 * Update bandwidth info, even in manual mode. That way, when switching
 	 * to auto mode in the future, iw_table can be overwritten using
@@ -271,25 +289,10 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 		memcpy(new_bw, old_bw, nr_node_ids * sizeof(*old_bw));
 	new_bw[node] = bw_val;
 	node_bw_table = new_bw;
-
-	old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-	if (old_wi_state && !old_wi_state->mode_auto) {
-		/* Manual mode; skip reducing weights and updating wi_state */
-		mutex_unlock(&wi_state_lock);
-		kfree(new_wi_state);
-		goto out;
-	}
-
-	/* NULL wi_state assumes auto=true; reduce weights and update wi_state*/
-	reduce_interleave_weights(new_bw, new_wi_state->iw_table);
-	rcu_assign_pointer(wi_state, new_wi_state);
-
 	mutex_unlock(&wi_state_lock);
-	wi_state_retire(old_wi_state);
-out:
+
 	kfree(old_bw);
-	return 0;
+	return wi_state_refresh();
 }
 
 /**
@@ -3900,8 +3903,15 @@ static int wi_node_notifier(struct notifier_block *nb,
 	case NODE_REMOVED_LAST_MEMORY:
 		sysfs_wi_node_delete(nid);
 		break;
+	default:
+		return NOTIFY_OK;
 	}
 
+	/*
+	 * HMAT and CXL report a node's bandwidth only when it first gains
+	 * memory, so recompute the weights whenever N_MEMORY changes.
+	 */
+	wi_state_refresh();
 	return NOTIFY_OK;
 }
 
-- 
2.56.0


