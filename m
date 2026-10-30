Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11775606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=o3I+rOOh
Received: by kanga.kvack.org (Postfix)
	id 1422D6B05C9; Fri, 30 Oct 2026 12:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC816B05CA; Fri, 30 Oct 2026 12:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6706B05CB; Fri, 30 Oct 2026 12:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C10AD6B05C9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:12:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9ACF1A07BD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:12:15 +0000 (UTC)
X-FDA: 85379784630.17.85F7702
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9D0A1C000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:12:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o3I+rOOh;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.167.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eNGYBiGMglhPQnZEli3lO3EUz21PsnQzOy3maSp1K8E=;
	b=jg4NtQWgOKRLiQCNxVYFxWrhtR3KXhjFY6GJ9DZun6h+Ut2uUMBVJNiypjUQo9AjEgfwYB
	eMLj4Q+Fog2fueZCoAGct3YFkhF6m3YZbw2FlP39qYkf8StWjvfgjg2VRrCdJCM6O2hTVZ
	Tt/nrSMrCWfx+oqP7OkIssyIX4RzMNs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o3I+rOOh;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.167.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376734;
	b=EE85evu8FDpCmurxA1AadE7kN6sRRg1+ai4i0PPSmLilAf9P2n6fempbPL0bbaiu0u+X6+
	EKbiSna5QVxUx77ZVqHUHz9H2xR7t45AmJ3DDwHtei2KT8JZX+ZfnbrWMCCoEr8xcHqD85
	66D1z45Ipv5/C51LARPoTMbfoZ5TNyE=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba3ec92031so1247838e87.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793376732; x=1793981532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eNGYBiGMglhPQnZEli3lO3EUz21PsnQzOy3maSp1K8E=;
        b=o3I+rOOhedP6KEmzZRvW9ZzU01wqEf6rAKCd6lNYKC/h5zTYbSSfvc1sxqRYN46+eY
         1B20X8kEuH7evVhDRSnV6VuHsF00X1bK8Zdl3vjZYytjOAuN0VNhpW7RS/kg4eEuZegJ
         KnKtVTyBFjmRmpQFg3u2fR44uqyMLOaCU/fVmVH/bGjEc0YgmrqiBd2ZPOQPoMMd8Xyj
         IBaFFAmOwzjAs/aWcXz/spqai8xqiYSvYDIrW/ChvSYVkX+ap3QdHCvkBeGj6RD/mFDG
         SUqHbyjWqeG+bmI6BbH11Zfy/qzQTPuon4jfNsoiPyi7iTg94YT2VDsdqn6HcfqmUOTS
         Udbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793376732; x=1793981532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eNGYBiGMglhPQnZEli3lO3EUz21PsnQzOy3maSp1K8E=;
        b=crRaPS5gr2BERE3irlAOQJm4tDvEiNRnNfSqrCvDy/nZPFIU+OXoEWJ+keE+OkOhZt
         q+TN9rmxcUktYkdYcFEl6xI4TNDUp9VoVDpANz/Bvz45zRkBCjOEo+LbebBhKV8B4dgc
         /G26H2jwzULcYagbEPb+Y24CwKmU3d6Z9JOpJyRW+730Sn2wCE9CDxhhAwvvRi45Cl8A
         fzEwTNDg2IQp6JefgLYxdT4mPqo8pQln4l7PvbfaJdHLArhBDklQNduK3BQDzdDw/bds
         PNnAA9MpXMk3B8WjXaezv3XwIGM0sohgQ5aJxuM3SDc4dV3EpkKnVWfqte4OKvVjYUo1
         +maQ==
X-Gm-Message-State: AFq9FYIbb960RzrevE12sFNUPL0uR45MU1QkTmfOK+tlHZ72NWzTy/xA
	EouXSxOlNO/VKjuBabtptzOZfZQYbca5EEXpOxE+U2QhtQZe5SHmzBle3uG1/JRdM5N0Jl3SRzr
	Z/iaW
X-Gm-Gg: AYBFou23x23uJ1M8Aw+UhALowKssranZPncR0YOc85N6XSKq5OFhQ5BM1yYZRK1ALMC
	ffAdp8d5xGp+ztH90FKKtSz0nxS5sxFyVc+VVu0/UMRNZZ8SymOwdeLLCJ2HetSUn8ehqO75tlz
	JTxe+HFr4qLYi/dcKynNu8D+2Ai1NCV9yauZRr5pqoGJisezXUhGW6oQ1AgGHqs0smb7ISvnshr
	CbPylHN7TBzPuEXDLg6ABwe3B3mVtE2rLHYPS73ORs1FYhsE9IkBa0QFwnm+hFQbfZiZo/5rRsd
	sSp3Zu3LQw4yB+PRIzl2u6u+Y04EdQpmmTHMIMLJz0efFjRzRs1fMtZKQxbZFEv07GIleYQF/Gb
	4SKcWVvOPvu0rfpd9eoiC3eXO/L07tsKkYf+fgY/kvu2rO3Q7UtC2ToWoWpEjVbzLxdrOq5NH5q
	PPKGTHDDyoWOgjzbxjMgUeevPbJeM582XJZ5nm2Et+MqN4aCzLaa+v2TvDMt3ldjehwriug1bn1
	AatCHIFl/QHIPGOGsX80NyshxVuj5QCxyeiSSopdctyiRNeIEgEWD6+oE2MOH9Gkt6dHBmFaecs
	xm85E3zQFkJz2CnayQFo8qQV3hG4lb9X8o/JWr2O2GxdiZHzqq2AGCTgs7RPdcJhqDuZGCFctpv
	kBIyIVQ8P4j8m+Ts=
X-Received: by 2002:a05:6512:1392:b0:5bf:c9c7:eae2 with SMTP id 2adb3069b0e04-5bfd9596876mr1035390e87.66.1793376731947;
        Fri, 30 Oct 2026 09:12:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acbbc07f98sm3944031fa.2.2026.10.30.09.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 09:12:11 -0700 (PDT)
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
Subject: [PATCH] mm/mempolicy: use one node set for interleave weights
Date: Fri, 30 Oct 2026 12:10:46 -0400
Message-ID: <20261030161046.1497894-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E9D0A1C000C
X-Stat-Signature: 7rsr71g7stmeq19t6hrycyp5u7e183tq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793376733-423191
X-HE-Meta: U2FsdGVkX19pYjaC4Dbsos3Hy6CyGpHK4BolaWEfWT2NZ/20WT+TiPMPzcj6koL1PJkyws6t+PNSxccOQIyTZbwz7o/tO5Xa8azatiGJ+q4qlJIk/PEKUpY9vznW/lULn6elyNZLRIYhQOovsw2ydjahHNEk4HuxDGhBTg96ceWRcqS28SFtBzlU9b57AtttyqH0yt2xYwlTBHWEkzXi6E9PWc2GEj69cwCoSRt6+/anST+e5DSaFoYZtVr7Cq6KIypD5AZmX/WuDVI0ohr5WaoTmqIWgyEPtCGHlpkAtAhVGvOoVdv7V5Foga+KbjdAA7XXejSgjoCwWu2BoirI8P+t9a1eWRSW7VO+pxcUEzo93xieqIjGRTdjXoLdjtx4q+el/5Jg824MuxMMqSmNJ/tQM7jwOp6WkYmCekp4dS2zezxRQYdUrGDP4w8DdSdNzpIKBf2U5/n18kJZ401A+4sAchvPe50lykRTK6kMgJOkXHkjUn8Hmeg10LPobZh2bM9THZ7yG1cgTMNrjjbJt/l4DShc7vhG0VbmXPZ5amAn8Pln7gFPuAI0q+i41IswTEekkzrnD/e6RiU4bs7LWf63qtvbz1qgrungrJ3VEhqLu7B+POvoXFo/U83mFoSNsEUxK8J4UFqZv7cNTAdT24B3P4Vww9uwBXIDhLi3QsRCMwfbVzUbAyYxIpG5hKhcz2qL67uZnxk42B7Om7wdr82rXOsfOh9STv+ynLSyekjTB5CSRULDDyB01SbjLdKySAnNvhMRu0wpvR6HHhilLVn4dRE004AMBmzgVJB4K1+f/vIs1AkQAvgPcBUJlbTeIqoqdAbRHX5WOMYYK00Lr8PMO5PQOxBLSW6HKxB9IHYnkQC68Lu4HuYr/HCIfLIaimLnDJiYf1qusFzaSht66seSFCIFvbTzNEX8If2JHYaXn18BAiEgAUvM9Rx3MhD9+qccYKSiin7ii2zBsvd
 KUW6pRXz
 FGa+bWfOr0mz4+o88OP5uJp8llts0B/S+TYYP08R+e2dqaAahKAcRVhy8w6h2b+l8ChanynUHyjnQ1XyDaFyeEiKMX3AyOropebMj7b4pdlEU42UD53TLvzKzR1noWz9dBis14LU61LjJp7MmGUIlqTKYIVtGy8NtPremiznDp2aTB3vL8ojMGuOMvQBN2x/944VvQJELz5HHKF2ZTO2W8+sOjEZDfAiQ3xisp3CaMHWJHLPp6JPw7ZDSnd+QVun92yBJcW2gogCqD86MHYQ4piRM0fwEMzQIzDZIwzjG+hFRoj/Q7xn6rcPHdxgaBakwLfAMZA+mBVctf+KTr4AWlnHNoq3d7QQAKJoY+fjb/ZHmKE2tBipCgpGfsHUnEsktXBj3c0VHU/dQSZaycFVjtRaGrOVPPnK/2pgQvNuhoB2OR0OyrKplrFKorXIJrcnmdkJ0yum/m5o6WNmD3xW3Dan4PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Andrew Morton <akpm@linux-foundation.org>

From: Andrew Morton <akpm@linux-foundation.org>

Switching weighted interleave back to automatic mode while memory is
being onlined can cause a kernel divide error on x86, and a panic if
panic_on_oops is set.

reduce_interleave_weights() scans N_MEMORY three times, but hotplug
can cause N_MEMORY to change at runtime - and torn reads on that
nodemask can cause a total sum of zero bandwidth.  A node that
was hot-unplugged and then hotplugged back can then cause this
loop to generate a div/0.

Record the nodes visited while summing their bandwidth, then use
that same set when scaling and reducing the weights.  This gives
us a consistent state even if N_MEMORY changes.

Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

 [gregory: recieved off-list, separately validated and tested)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6f92621e9135..26a1a21be65d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -207,15 +207,22 @@ static u8 get_il_weight(int node)
  */
 static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 {
+	nodemask_t nodes = NODE_MASK_NONE;
 	u64 sum_bw = 0;
 	unsigned int cast_sum_bw, scaling_factor = 1, iw_gcd = 0;
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	/*
+	 * N_MEMORY can change while wi_state_lock is held. Remember the
+	 * nodes contributing to sum_bw so all passes use the same set.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
+		node_set(nid, nodes);
 		sum_bw += bw[nid];
+	}
 
 	/* Scale bandwidths to whole numbers in the range [1, weightiness] */
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_mask(nid, nodes) {
 		/*
 		 * Try not to perform 64-bit division.
 		 * If sum_bw < scaling_factor, then sum_bw < U32_MAX.
@@ -234,7 +241,7 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 	}
 
 	/* 1:2 is strictly better than 16:32. Reduce by the weights' GCD. */
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_mask(nid, nodes)
 		new_iw[nid] /= iw_gcd;
 }
 
-- 
2.56.0


