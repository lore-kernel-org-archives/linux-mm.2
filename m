Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C833AE63F1C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1553D6B0093; Sun, 15 Feb 2026 18:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124FD6B0098; Sun, 15 Feb 2026 18:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026B06B0099; Sun, 15 Feb 2026 18:40:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D87186B0093
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:40:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38B2F160719
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:47 +0000 (UTC)
X-FDA: 84448313334.23.BA4C72D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A94218000C
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxYPJCgE;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1P2llR/K69jVR8fsIU2PoAt9fPVBjct1oz+d35uMjTw=;
	b=tPsG+aZUxQIc9ajduewkRigs8f1x5cDvYwzItEgORGzvHlHu+WlYMze9tQ3UIB9epQa2cC
	nK8/E/U+zzjZ9E52V4NovrktQZmtjty5YFnTJ6w5cn0F9EZ8vZonryM9nwSZAIH3ZqB9ua
	dxRDOb1Uc7jHSQTF6GljPImdCRA1/ug=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxYPJCgE;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198845; a=rsa-sha256;
	cv=none;
	b=pm74YN4BrECcj7TEpu6w/QMzAecvPE6IMJA+RI40AiMQMPncjmuootF915SPGcs61PCDAY
	klms+0QpFLMyCagiY5GTfzpjvi/jZlo7vOf0kPcnYpPfPnAK91Nzg1Bwt9EzBUJOSI3CVL
	Z2AG2PI/BT1wmT9cHP7on5Z5yhYe0jA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3ED843231;
	Sun, 15 Feb 2026 23:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9EFC19422;
	Sun, 15 Feb 2026 23:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198844;
	bh=PBK7Gy6yOqD93xMD0GKqkyb3it4yG8n9UJvvL1G85v8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bxYPJCgEsjiQG6SWt0NwbCdeEoOChcdXDWKWzk9Mn2vlrkVXazcE5sp7XZlRI0B+b
	 XFUCbLfrM1ezrptYH6/psaBuY5loKyUoDtPhVhEcZYwmwBOpDFBDM+2MRNidILppl+
	 VC0fzKYIgwkljNSdqfAANE0yJ7gp21HICWx0CyJ935vdIsnaotWa7Y/QWoJRRAnNak
	 MY1WeZB7BC106AvJ9+k+xdWrgLkY5n/SEpZP7eCkBgeLXoOk/6qabZpbbkVcJobqHe
	 2OVFXI6fggXgf6r/bu5p0h0XvgE49CVjosL3Vk/zdP2SzGGKHeAE88IKaLo9Js5QFZ
	 BOk3xbq/GpUtQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:47 +0100
Subject: [PATCH 60/79] block: fix arg type in `blk_mq_update_nr_hw_queues`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-60-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2537; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=PBK7Gy6yOqD93xMD0GKqkyb3it4yG8n9UJvvL1G85v8=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhRRzjj9sFhsnUHE/Tx66LCHKC5qeomJHUCk
 Y8jvU2yfAaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYUQAKCRDhuBo+eShj
 d+GwEAC1KHf1/pmHLdJDHxI3cCCTlLqWwGumPnUyTFqd3m6XeHO7h86kF21vSosdJrHHb+XDNaz
 VTv4YxAvrpHaqaNHyZD4vArVYlOcsIJI5Hu284JnIPunXfuqMsSXAhbeDvJgSMxKktW5RlzCyOg
 yCnx2WhbeRjnv+hjKFH387A0ITVqtytkpT59eXNgagoyGLIa+k01l7K/1/S0+VZ3AM5cQ12qdMY
 skynG2WSw9hB+Kl+9yFm50dU7Kt/Ab4DtXV6mdjcCq4DkOwWiqJkYbMxu3/FaZrE/jCaBQ09ntV
 W4mSDcYWA55/eFd/dhWENhnOfGNaBsoRalvJswIVwvZheC1O1AqJeys/Q77bY8PEdaoZEZT7sfA
 YvVZP6KPs2F43KdFZuM/U4kylbcAlxalbKppHJ+srUQ2MJmk+9tr4Vdw/5H6kO5XZtBvx9cEQAT
 96rGiwnga8pPV97JTptFnTZIZmMjUwYUJyZVj/qhZzVMGec6oQjmkKUScUuEOTYFhK5UN173Jn1
 msXa41+56KcRX/sDcAIXBzWbmukOeZcVCI+Oh30dbAo5YQYNVUBXSs2wTB+AHqFSFxUajjkDtdf
 M8fJcZDtfK2c51lYwwrmcyqSRPcuqhYSBF/CkbBh59EXiJr9vL++/DTL/9ffjf7ZxF3HFPzHP9P
 OQyxV8MpPWhLDmA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A94218000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 5rxn998f53eke9u44ytmd4jr14ogzi6z
X-HE-Tag: 1771198845-740494
X-HE-Meta: U2FsdGVkX18LgDMB/G3FyjkxYYVj45Cna++/GJCOi8MSFNkegVfx7ybq6i8y2mkvlVBs1rZYYxt3ilpamvKCGlS1EPJhyhhZ4IZvuSULJ17RtC02hg8jdK8zcytPWz8vkZdz1TBERPw9Wn75D5e+0fWCMZ5dvz5fuLJdVdvNtPtBzdymFXPf0CjqdqL8myp9zh3xUbb4FxBy/5jaK2iSiMx+CTVOyL8zXJ2kQci9bjdYpk/gslzEjDBYMt59xPTq/G3RDGcM9YDz1xUsUgekcwI+Ib/MY6VPZLQ3SxN78DEpNmr9+G08NT0gkuAif0TR3SOhRfxdoQj6CpEbdqd/F1EiDD5I6pGsUESfU5/Q/0vJfJgmU5MPndfD55FzEc4DsRGILBlXcLHaEZKChdJGMiVUg6Au/muvzFTXYzlDZ/iV7bHiX2Dip3TR3DbhFZv+0H1nOwiz5Cf/oy7hVnmIHcWRQpL6b1xPNTmGuPWIxdUh+gN8/OjppI4UzFojBrMwJvM3L0xf8hX4fQtCF8sIdIPLOIfp2YpGwsLMDsI+oypJIryVd0jytNEEz7/zE3ZMfx6YsHbsrejAVQhNRl8hIDG0o2MP91FwKzgzkW0ZdQyyfWXGko/y8btvvcZXaVgu7yorNX/GHIaubU2KTT1ZKiSBBPROQppkjKSVlnEEbWrrIAjqeO2ClDz+WgPbhkMSTNo/GgWCbiAlYDCRLVick92hecfU0tuONimhJs9LuFekPz5TWw+sWEylvjV5SUMmy79b2p6MOt+ObvC0GpKjC6L0H/JH6q3MZt7Y4LOiTC/UbbDJaC0yn2SoAHpPXDGVO39AdtRS6hD3Wmra633uMfodk0/agV1afWuCjYVHGLwegEkqKmuiUtCFZrzrd5eLJJniCAuZXfj0vaRnRnsdx9h0WBFCSG8zyDed8w08yoS+a0qwNuNKQdxXfKOgAJV8RAY+XnTb3+B3ljueW03
 dgUWgA77
 hNdPQS4dWz2QW8cYaauimIQq2xCZImJhrwIBQVnp+qVF2pss=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The type of the argument `nr_hw_queues` in the function
`blk_mq_update_nr_hw_queues` is a signed integer. This is wrong,
considering the field `nr_hw_queues` of `struct blk_mq_tag_set` is
unsigned. Thus, change the type of the parameter to unsigned.

Cascade the change to downstream functions.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 block/blk-mq.c         | 13 +++++++------
 include/linux/blk-mq.h |  2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a29d8ac9d3e35..6a44ebb6aac43 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4779,10 +4779,10 @@ static void blk_mq_update_queue_map(struct blk_mq_tag_set *set)
 }
 
 static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
-				       int new_nr_hw_queues)
+				       unsigned int new_nr_hw_queues)
 {
 	struct blk_mq_tags **new_tags;
-	int i;
+	unsigned int i;
 
 	if (set->nr_hw_queues >= new_nr_hw_queues)
 		goto done;
@@ -5086,12 +5086,12 @@ static int blk_mq_elv_switch_none(struct request_queue *q,
 }
 
 static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
-							int nr_hw_queues)
+					 unsigned int nr_hw_queues)
 {
 	struct request_queue *q;
-	int prev_nr_hw_queues = set->nr_hw_queues;
+	unsigned int prev_nr_hw_queues = set->nr_hw_queues;
 	unsigned int memflags;
-	int i;
+	unsigned int i;
 	struct xarray elv_tbl;
 	bool queues_frozen = false;
 
@@ -5178,7 +5178,8 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		__blk_mq_free_map_and_rqs(set, i);
 }
 
-void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
+void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
+				unsigned int nr_hw_queues)
 {
 	down_write(&set->update_nr_hwq_lock);
 	mutex_lock(&set->tag_list_lock);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index cae9e857aea42..171521e716e49 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -972,7 +972,7 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
 void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset);
-void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
+void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, unsigned int nr_hw_queues);
 
 void blk_mq_quiesce_queue_nowait(struct request_queue *q);
 

-- 
2.51.2



