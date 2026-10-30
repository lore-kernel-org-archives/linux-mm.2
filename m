Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8DE606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=jhKqdd2s
Received: by kanga.kvack.org (Postfix)
	id 1DFE66B05CB; Fri, 30 Oct 2026 12:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168E76B05CC; Fri, 30 Oct 2026 12:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059026B05CD; Fri, 30 Oct 2026 12:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC7CD6B05CB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:12:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B3E3803F8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:12:42 +0000 (UTC)
X-FDA: 85379785764.22.C94D104
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD437A0007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:12:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jhKqdd2s;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uBqGgi319yANUlDreD4lJdCrP+kc/0b2EBnj4SdcGgA=;
	b=Gcinj/m9jdTcG0CsPrlGNC4kbqgv1L/IbqVh3xa9fmfA4nvvMV/TPOReTmh84Ts1h5vYca
	Up9UZNifa3ohNeAtbvgBdJa7/TNY01UsdXsLNpUTammkf747JoR3iZ0c9rbbpOAtIN8jTm
	M+JHszf2egzy14MWOvRt4zBfin8ZnCE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jhKqdd2s;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376760;
	b=uv1BxrfS/s8gOLFniXU6aaO57WDqQI2NjdvzPZfYcA+tiJ/Znw4Bbi+wGrVGGnlKEq0Ap+
	gB7zfySazYR3oSoIMsj/H622FA2Uuw2nAl2wDzV75gdKXW1n04cbi+DwabUcrYgrb97uct
	jLNNTtMix837yGfJ22gZNv5RFxHfIPg=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91c719669a8so9504316d6.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793376760; x=1793981560; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uBqGgi319yANUlDreD4lJdCrP+kc/0b2EBnj4SdcGgA=;
        b=jhKqdd2sshOuif2RDzq7AqfFVZqaMUuj2k6RyXJyEKscPtn7Br53SlzwEa5+t0+bsq
         YZhnTNQ+qAHh8bWWLvBeWpQO46c0ID7p0ZggXraU8fY3UG2vZ7L32fso10r0pIZutIRF
         Bnu5c62C0bOOCQpKyhRznqhmPBJdpjjTs8JbFP0NX7glB4M8+uOfu8dULb/5/m0YOEX2
         hUshmjx2LDV1eG/AwaDyPO6sEAOWOHf3Zp6Rmcqdjt3ydgptfUodGb1ch3eOHMV8XrGz
         qL2HSfBwF43LLyOfqOkeKr7GFNOLbtsP7QxhK77TAJVvwcJSg3TBArYt8KX8GfR5Wnhj
         9IZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793376760; x=1793981560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uBqGgi319yANUlDreD4lJdCrP+kc/0b2EBnj4SdcGgA=;
        b=uMw9MBVt7DJs5T6Tx9TC0ixHDV9ZL/ehl0nxCVYFIQhw8976Ug5wPz0VwYMzIpTMbc
         04SBfrhdLSc6jQY6EccNy0QMOZyGMb/KgkPay2sWJQEuhKZy3yy6ExneXTVJ6T0jwT2n
         YZfEbL1PSvJqRnREFj2797yf9K0tkV0st3DS9a3gMMKuQ5K2A2st2dRoF7KGslFJL364
         ia99oMNy4mVDZ68cYd9vT5sXntdF/jcUBrYdkdAY+Gp+7/NwEJecaC4ZUOzAuueMSd2l
         O2blaER0qUQjEfQCJrgg1/i9ChUDe07VJspsQMo1ghRJLL3wrTb177SpFn7Zs1TwExRr
         m+Aw==
X-Gm-Message-State: AFq9FYLhBgJMHZGesAGOteGA4BAk22nANJZKSbAeuGX81xG/0tFDgYE8
	oVilgD0RqLBVjhH2PHzGL3UhRf6EluOcjg3JXSEGFkQFByBWS2EJnedkgRL1g7EGeVItTLfvYhE
	ecYH6
X-Gm-Gg: AYBFou2TJkaSXF7OVySCSxYEtLpto6Ty7ZC5rojY1zbacY/NYpR1Fk3lwNcTkv/5+SR
	DOi4jCfaSHjI1XGfGX08JJUjS3HSNEJsfrPYCI6R2UHksEOaSq/WAJbxGI98a35N9794gXnU+Vu
	351F60a5q/faOMtMMKGg2P9LPHOoyTWL4ITD/DCFaBoNUhT+7MQliIt1JG0sg3bGuFkXBXbg1uS
	re3ZrLCvGcQTeuit6acQAYA+YixU/gUVYX8az30kIUolr2LCVyPj39CetkOKt27hvmtiLuY8cO1
	FnoBMm/q8eMA50c/vl3KcQq6nnqnMKbbQHnb3QkaHaRMUpAExB2KWKX9SPiKzS0mrarL0IEb/xj
	5mlAVeLW82RDdBMCXkxEBkRleYqdDI0/d8KRcF9pHzkvgaSzgPYnjMt9SCVs4bwj4cq85p5m2c7
	f8gr/A/zrvIzEhCAW+zJcJR9E8LH+XUAe0R8xSjkiA0fgZZGP3qkNne4yklVBQbtbUU4nEpU4+q
	vNyMj33OqV1TKpLMRNCql/oPIzdmEkgXbjRa2UGy4c1453WyHpx33+nUo2yHFBK2pabqzFp1imo
	SsNY1Vsc1PoGrNa+3dDgitxlzkEhQ1p0/SU90yBmku791Df4yb1DQoGXmuZD1ks4lxsaP4l0eYl
	p6z+uXG60ix+z20A=
X-Received: by 2002:a05:6214:248f:b0:91c:7460:6eb5 with SMTP id 6a1803df08f44-91ca4ad4cc9mr40967836d6.15.1793376759518;
        Fri, 30 Oct 2026 09:12:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca8082914sm18501396d6.42.2026.10.30.09.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 09:12:39 -0700 (PDT)
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
	harry@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/mempolicy: recompute automatic interleave weights on memory hotplug
Date: Fri, 30 Oct 2026 12:12:34 -0400
Message-ID: <20261030161234.1505367-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD437A0007
X-Stat-Signature: zcfweua5um7dzxoz8xpkxp3ywn76uyq9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793376760-793727
X-HE-Meta: U2FsdGVkX198wy6ItNNPhrnCzy2i6XRIZcHFNvmdE7oV+mu5xszX62tQ7lpo74Cu3Z5hK47agoImsrBpYq21XxUoz02hS1UbwZIw2ws4b2IE8e8h5lLcAYXqklE8m179EAvCtTKY7HS6W6CuHgu6VZcBxDIuMkMAEp6R7sO9bXZsgm1vXW/9iQBkpvOHrwoZZhdVpnrRDHfmiKfNEsEp4Uvjce1X2+DkMRKwh3GEsEGKEdV0d6zvBOEKnot8CM/IH3fSuo7qy7Q1LR/AIkoArkvhHmjZZUJG7fG0N3NNWzOfQkYttUXId0k6Sm9LvYxRDn5TmsTqw2DhUUWf0WE3siJcoYwqIU9uptTFPl/shtTlNMgAIEuKtUCH0b8VJHErQWhD5X2H1ykVwfp1FQu8Ws5cOJx/cnLZBpUYT7ceGJ55XNnaRGbv89xg1bYL5r3g2n12ulYg/HeyJXd49n3L7NNVtfWYyZHrOvJDJq25oFvanT/6UR5stqZ/I83uscf+J6YfJlnyq/XKQyojVklEtNo9/5rQIKa5fqYaP6uDThug5ZFITsxJVyejbR6+GQurGaG5056vFk033nXrCMZhu6cFXvtjU12TWALKCLoKoFb1iEeNEZPb+vlY8+OWDvbVuPap/z+vvcbbuwRuPRlHM+Mqaa/GQqIOKK5aDqHR5l6DknfxajC6NN/92uJ5cT+GDRyl1rNeNj9eSwWIeZPZwJURVdEfNrmh3MHfMWQhTqasf1voaNASUjVn7tidfV5j/RRlfz3sso1DiZiUwSkHYHQTelCq1aov5Cy5ThKeR1r80Be16RMPrvA2YSwov7QduMQmHfzEGDKlKYPm+LkV+YJNN68MCIAKf/YiBaUc8GouMyY5Es2rAFCMkbrgF8AdM4xNQoomV8TPQaSpXPsTOyVkl63bsOEItOcGAf64dKNyCIeis9qf7kZu6Q9LXJ63ldFLf6AKRi/SmYK+FMS
 o3jcJnXn
 Zj8/YQHCILGWoPwIwh4GANDSylka7IdVha/0SOH2hqdhFn6XPyCXpLk3Z8tZTQIP4IpuKaXHVuKNU3g0GcluTA+M0/ORIiQzoYv5mr0zDB9+f9saZ8d0PUIbBOFYKAgGDXVOL3Ulvv+toJ8Qtkj2ctpIStevpIDfRPxo9gZd86vevPkqcvKt+Hj07kK0fVi808rEFRkvu41AU0OEke1HDrn5bUgzwtKIvKuI354DuofNB+4k9xS19f0q5E6NeyE4yWjE3uodY8BsXW6IzNJ9PqpW3A1H9xzqTZ8hCIluEEWYxJPBZZYz7/BWESRaQ8krujSdSy2nCu9NekOArJuCx4LL+c4+6+Rqhmno2dOhZhJ87dzFAiO535niYfbaEJBmyM1mLsm4EQCIK6oiS0NX9y6F7+w==
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

This can result in a major skew in distribution and overload tiers
with more data than their respective bandwidth can support, resulting
in a performance regression.

With HMAT bandwidths of 100G for nodes 0-3, and 50G and 25G for kmem
nodes 4 and 5, weighted_interleave/nodeN reads:

  event             node 0-3   node 4   node 5
  node 4 online         7         3        -
  node 4 removed        7         -        -
  node 5 online         7         -        1
  node 4 back           7         1        1
  Expected:             6         3        1

Toggling auto off and on generates the correct result, but we should
detect this and fix it during hotplug. Recompute the weights from the
recorded bandwidth whenever a node gains/loses its first/last memory.

The notifier cannot fail the hotplug, which has already happened, so
warn once if the new weights cannot be allocated. The next recompute
starts from the full bandwidth table and corrects them.

mempolicy_set_node_perf() now only records the bandwidth and calls the
same helper, so the bandwidth is kept even if allocating the new weights
fails. wi_state_lock is dropped between the two steps, which should be
safe because racing writer simply causes it to run with newer state.

Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 84 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 27 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..6f92621e9135 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -238,27 +238,49 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
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
+	/*
+	 * Hotplug events can arrive before any node reported its bandwidth,
+	 * leaving nothing to compute weights from. NULL wi_state assumes
+	 * auto=true.
+	 */
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
@@ -271,25 +293,32 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 		memcpy(new_bw, old_bw, nr_node_ids * sizeof(*old_bw));
 	new_bw[node] = bw_val;
 	node_bw_table = new_bw;
+	mutex_unlock(&wi_state_lock);
 
-	old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-	if (old_wi_state && !old_wi_state->mode_auto) {
-		/* Manual mode; skip reducing weights and updating wi_state */
-		mutex_unlock(&wi_state_lock);
-		kfree(new_wi_state);
-		goto out;
-	}
+	kfree(old_bw);
+	return wi_state_refresh();
+}
 
-	/* NULL wi_state assumes auto=true; reduce weights and update wi_state*/
-	reduce_interleave_weights(new_bw, new_wi_state->iw_table);
-	rcu_assign_pointer(wi_state, new_wi_state);
+/*
+ * HMAT and CXL report a node's bandwidth only when it first gains memory, so
+ * recompute the weights whenever N_MEMORY changes.
+ */
+static int wi_state_node_notifier(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct node_notify *nn = data;
+	int err;
 
-	mutex_unlock(&wi_state_lock);
-	wi_state_retire(old_wi_state);
-out:
-	kfree(old_bw);
-	return 0;
+	if (action != NODE_ADDED_FIRST_MEMORY &&
+	    action != NODE_REMOVED_LAST_MEMORY)
+		return NOTIFY_OK;
+
+	/* The hotplug is done, failing the notification would not undo it */
+	err = wi_state_refresh();
+	if (err)
+		pr_warn_once("failed to recompute weighted interleave weights for node%d: %d\n",
+			     nn->nid, err);
+	return NOTIFY_OK;
 }
 
 /**
@@ -3414,6 +3443,7 @@ void __init numa_policy_init(void)
 	if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
 		pr_err("%s: interleaving failed\n", __func__);
 
+	hotplug_node_notifier(wi_state_node_notifier, DEFAULT_CALLBACK_PRI);
 	check_numabalancing_enable();
 }
 
-- 
2.56.0


