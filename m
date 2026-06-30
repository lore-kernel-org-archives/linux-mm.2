Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E44EC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65BC26B00A8; Tue, 30 Jun 2026 15:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEB16B00A9; Tue, 30 Jun 2026 15:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410FB6B00AB; Tue, 30 Jun 2026 15:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 156D66B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:08:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 995561C2D7F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:50 +0000 (UTC)
X-FDA: 84937516020.02.B4260FE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCBFA180009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YLT4Ss0p;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846529;
	b=vm7aIlsP11ZqyYIj/f4JadF0lLcu7ZeQM6+DVvUHYE20uSS65/4RQuQH7iTYgW+ZXy6Vu1
	ZxoRnyFFgkK1dqeVIXjPcAJtrDxw+QZpRhGRG48805hrEZ7F+g2aES7sp6U8vRB/m3xMhX
	CXSQOS/RuJF2xqSH0sAOrj2F2qYEpYQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3Usv1a7UlC0UMRDH/4S8zuxtDCAIrN3ySuhsA7pX0Y=;
	b=BerFdu8rE36jOZpImNH2L7Vzat1WCh4Jxr2PfCT3l5lvtY4ybunpqE2Cm1R4FRyrWTwGRd
	S7KnbhurJ3CWAxG1IHyDN6X3IxuGk2Jfl0A/qw8Gf2xnk+/9pqUKsIg15OYpef2irQH8Eg
	i/cf7Ab4KWsIJVAdTumXcS7v8rrsy2w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YLT4Ss0p;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O3Usv1a7UlC0UMRDH/4S8zuxtDCAIrN3ySuhsA7pX0Y=; b=YLT4Ss0pvR4nptQ+945//yLP/O
	nZpALdmiXRAzx+OzxFNfiHAuO13r20++q4qrcOn/L97itCXdSFLdXf8J5ZW4plKARXr1XGOvzrZRd
	tCw3BAuMZ2qInVEcF2PWfIROZE1kRr/+k1UA7vOr4V1Dt8hKBZO9EF9ifMv6M9MWTOXYaWDc9N6x7
	NQDFiNj/R50h77FBPRp6LwrUiSnAWAp8J7g0kcWEAgjocNkvTVxvggl0j3fBR5qeUR5Sjn+sdPL6B
	WxG1A8rqHar3LyRWgI92Y4ZUg+E0DlJTiXrpQn67zHuXj337+rN5mzDJL8yycy7+wtbvEmztcGwZv
	KKsw9srA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedp9-000000005nh-3FXU;
	Tue, 30 Jun 2026 19:08:47 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 01/19] maple_tree: Add rcu locking check when LOCKDEP is enabled
Date: Tue, 30 Jun 2026 15:08:25 -0400
Message-ID: <20260630190843.3563858-2-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CCBFA180009
X-Stat-Signature: jjd9hiox8ij5mytfgjy85k65wqemzgog
X-HE-Tag: 1782846528-685985
X-HE-Meta: U2FsdGVkX190UYOngzb7GrFI2RutEWO/FKI/D2rWxsp6XWcHzSfU0IwW0vaJK9pPCaY3KcMueQCaNA6T89Fnb4CCAauMEXe0akL2qYBeiYeYAdy2CKU/XKGhcSffVYojWTNs9ceIOzgo8vFRph/Duna01okjSKYoekeVZK0YlJ/3Nj1tLzTNgg/w7TlGLaG8RAYW1OP8eAKVZB6wwLG5FB0fCP9TnPYPh3BhWH4EAUT2W5cTDUcwnLRtCnm+zffi6KcySObuR+UAzt9BthQwMySZccc0k9+nCogwn6q0j5Z0CyBewgAo0cc6WJL6fFXjd+IqwYnVVBXB2xSZJVNZCiE0kpdNdbOFkC6wfg2IPUzs8I3OXLBgvsTsqJ3Wa8QHPAwhOdNRi41M6dn2eDSp215MIFszqm+cy074cnC83wxg6g4Y+Il/TJJiijaFHAq+FV9OonlMNw/awfggbmcso8ylKrUeXDJ30wkX/vosPt1/CZDcDtj0jRH/CmOPR+Po7roPAL185/A0YppbhOiZDvNuQu2ejYssjx0D0sLmp4cgB5wsswTjRJsMXg2cLCgSpQijDH803IBM5v2PB6c2o3nnWpQRrDPXH/YlGt5yfauMwgu3ALOvxaalvjoq7KH5GZ/fMLB4vZ/tUqCZgiLdaUXuO5NCR41bjnS3QWiz8sUtot9+7zehkX4PiF7rYYgUsxD3PJUQd/jagBcktOXiAabXNbH4JfVT0aEACiK7gvuUnQ6Hewxu//x17q8LsInevWbjZQpCXnUfG9qXAZ9znMiS3OQY7No9Ovos5A8mSPMoCpNrfKP4NYW35cMag/nCZ6TlkoHHP303HsSZuLSVDWkiRsAPjb9RVFqYTlxeqxMazA/bRv8ayyjpNhtNNhJr03ywt3BuY3PLL1NxFMIStsjI6SJYe7k+tM1xaXQNg1gHhLyIJm06cQHs5E6cAfqK/EKhTcnFvt0aEfZQFp1
 2NxMQ27X
 rjZNKR3SmlhQ4CO2Bt/FZ8zfUDcqDTfl4jhrRrtlAGkF6cY++8ZwCucZYcDxWbeX9HOR3g3yKOnwkKwEQpn7KSNTuCrh0babRrfV7mpVyQGLP4XEImxv/KhkEycxRVGkvLPJRuY0DL7dCrDnBnIOpgQxSbsFPdERe+fWdXRlrhZrV3fVaX6dH7rb8cV6LhicU4Agz4NpbZ5PJXcwEA3HRUIGaW5G5ATAijdRoDpKujkYE4UKt4BssQqSPNQjJEwwf5ScnossD0BsH1KTa9E3piXNIdFPgD+Ecf8lqnAs9jLiuP4trprCny2Ur9/tuMWB/2Dx2s452yxZiXkDJ6nOEl96z5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_LOCKDEP and CONFIG_RCU_STRICT_GRACE_PERIOD is enabled, check
for rcu locking issues by recording the grace period in the maple state
and checking the rcu window is still valid whenever the maple state is
reused with a state that is not MA_START or MA_PAUSED.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h |  3 +++
 lib/maple_tree.c           | 50 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 4a5631906affb..11a16c3508dc0 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -485,6 +485,9 @@ struct ma_state {
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
 	enum store_type store_type;	/* The type of store needed for this operation */
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	unsigned long rcu_gp;
+#endif
 };
 
 struct ma_wr_state {
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e52876435b77f..3dff0435c13a7 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1153,6 +1153,42 @@ static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
 	ma_free_rcu(mte_to_node(used));
 }
 
+void mas_lock_check(struct ma_state *mas)
+{
+
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (!mas_is_active(mas))
+		return;
+
+	if (!mt_locked(mas->tree)) {
+		if (mt_in_rcu(mas->tree))
+			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
+	}
+#endif
+
+}
+
+void mas_init_lock_check(struct ma_state *mas)
+{
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (!mt_locked(mas->tree)) {
+		if (mt_in_rcu(mas->tree))
+			mas->rcu_gp = get_state_synchronize_rcu();
+	}
+#endif
+
+}
+
+static void mas_may_init_lock_check(struct ma_state *mas)
+{
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (mas_is_start(mas) || mas_is_paused(mas))
+		mas_init_lock_check(mas);
+	else
+		mas_lock_check(mas);
+#endif
+}
+
 /*
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
@@ -1171,6 +1207,7 @@ static inline struct maple_enode *mas_start(struct ma_state *mas)
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
+		mas_init_lock_check(mas);
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 
@@ -4360,6 +4397,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
+	mas_may_init_lock_check(mas);
 	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
@@ -4997,6 +5035,7 @@ static void mas_may_activate(struct ma_state *mas)
 		mas->status = ma_start;
 	} else {
 		mas->status = ma_active;
+		mas_lock_check(mas);
 	}
 }
 
@@ -5074,6 +5113,7 @@ void *mas_next(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5097,6 +5137,7 @@ void *mas_next_range(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5205,6 +5246,7 @@ void *mas_prev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5228,6 +5270,7 @@ void *mas_prev_range(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5274,6 +5317,7 @@ EXPORT_SYMBOL_GPL(mt_prev);
  */
 void mas_pause(struct ma_state *mas)
 {
+	mas_lock_check(mas);
 	mas->status = ma_pause;
 	mas->node = NULL;
 }
@@ -5382,6 +5426,7 @@ void *mas_find(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5409,6 +5454,7 @@ void *mas_find_range(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5521,6 +5567,7 @@ void *mas_find_rev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5547,6 +5594,7 @@ void *mas_find_range_rev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5623,7 +5671,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
-	mas->status = ma_start;
+	mas_reset(mas);
 	return true;
 }
 
-- 
2.47.3


