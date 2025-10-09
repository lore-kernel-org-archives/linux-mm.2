Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 295F5CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4715C8E009E; Thu,  9 Oct 2025 17:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422D48E0002; Thu,  9 Oct 2025 17:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF8B8E009E; Thu,  9 Oct 2025 17:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE168E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:20:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D15CABD03A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:51 +0000 (UTC)
X-FDA: 83979845502.29.2BD318F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3E13140004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jL5dvLdK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avq2ZCPz0QTF79YgdjifhQw/lgHuBafkjJNmbXoiACg=;
	b=o2urRQh6UPuOQDXgqFXLNLK4vZK9eweJteWW5lpG6XUyRLk7lJaGYgcoXGXR+RtGn0QtP8
	zmfbY+p88qyAFbrrz6AoZBp5dwvcD08u37dp+f3cpvZV7YrhIFPFx+NL5J1uK1LrHyomwS
	PBgUAy2VjClvgGDgnMhCLrpliHFXGzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044850; a=rsa-sha256;
	cv=none;
	b=W16oXRo8w77q+FK0cWJcWkBegyJyzDafsMKM4DIt+aD8ol/IgHL2l1EbnGr7pfN37fJ46r
	X2sTxYQffdhJ+HKUzrYyDXgiskiIGiaZ14jn4PVBkQl3Lz7AAu4ZpK2qkeA+aKGSoM76Jy
	niGxIpRMs3A5b1vLvATkx2JJf9o0EWk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jL5dvLdK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A71B862427;
	Thu,  9 Oct 2025 21:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA3AC4CEFE;
	Thu,  9 Oct 2025 21:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044849;
	bh=1CIUK+8rJXZdcUGVSAXbpo+NPkJ8Yup2LU3ew0CDXuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jL5dvLdKsBzT9ZGTax9IUxnfFckwub2guE+Nbf6VOC/LsoUruROAkfDj+3MR8hL5m
	 hZ2Py91uHheq/rMel/lyVBEHxt1xtyAXm8I8Eqt2ADnbaDJRAWQ5EYC2GVM6htOu7D
	 +a9gqXt2p8XoeUw8z1HRe5SX/ty/2+QhCDHM0KXYd52CSMR2bhMqKhcYeH1imoxcxJ
	 MSvIarMhK7E2FXdGpm9dODpZNuOWu9RtIH/BHmZ0VqVjHU6ctsQnDsaT/EsONx9Obu
	 nbhjh7DLcyxfqPOvw6HxFZaa8MZ3R4fGLG14NLHd9YfyuoLV9S4tMPV5H9aZf0+hIu
	 msjumprO4kjUA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/10] mm/damon: add DAMOS quota goal type for per-memcg per-node memory usage
Date: Thu,  9 Oct 2025 14:20:34 -0700
Message-Id: <20251009212042.60084-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ca55cwifcwdbknrf9cnico4iuuinbp13
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E13140004
X-HE-Tag: 1760044850-905744
X-HE-Meta: U2FsdGVkX1/TbGsmYqnvAMBBLvrDzZ4U0TUilmRcQBDVrGJpTjOgE0BIm15gElHF2/LlgKdG3FjiivAUvspaoNZKZUtkvi37HZjviWxHe34gebbwScWWevU91sMNaHbAedC3DnaC0ZaXP3FYAF+KC3R+FsIpeNMNJV7XiAbVTG+ZFYl6qtsXJp2rvSC637DeOpcMDklPZNicP4hyOyy8RnF7CWEp0olRc9iaXLKOtEBVAtq4xMDXOp0lRfpX9W9HLoqd8+z2FcNpSMKPIYdazqzyEdIkn9qbSQhaPTVIGiQtAGHjA30yokpIut+tQefT4xWnti5Y5iAcjOn1+LD8UdaH6B+698yNxxskq32pt6nr1dscLa+X93Fs30X73D18T1z98TtKO4YD3k8D2bV4Ohlg0sn/gFX+hco2eQvuxpNiNUiunpaHOYo5jP9m2p4uV10i4A+fSoGF8g6ulQcUbDxghJmK2Ifausx29CCXoZpbFVZvlT7Dnu1tF61h1du4lzLeF77OtBN6byE84bGUeAGCXmC8fkvR7vvShqcqAXVmu531vrbVDv53JwrIgbIyyk65Tjjlrn2uvTuB47Qit3t2YP2Yg0MD8ym9JMIZINxnA3wDtzQmdGEnbL3Y18GQEAYvY16jNW/4YB8fr1vGczeapNhRYJ1bPGGzQyQ3ADsrSyLECpaph9grjo5IBh6F87CQsAWKSEd9FIXw+xN2v8ljjNkh6dOKoYvuTTmKnD/W/PyXZMa6lgAHKlcxPpQOYfPAdQ9mMkfwOOWbYP7hVBCfwt+H4NSUo5rgA32T0C4+CTfKQ+FCOCo6G3n8JY8V6zvMU2Ab3MH1Oi7b4t7yDJ7fhD5FSKg6zM7OrryJp1DMU3b2fVp3SQPuYE+t9eIUarmHzqjIpxetFUZuOa0a5BN1k5lfN8CPBe7ONY6XUyVvj0vg1e92vaTRqozP7EBdfRgmx6yhajGk2374nhP
 oLMLvoPs
 1X8vBHk1UUJqvQWtvelTRQL0AyHQf4nkgUHF/yZDEThbyVFGz0IuNeuQqti0iRek9RKhnpmmEXS98fkRWzV20QTwXIQ9RG4OWu64om3FxoPFXHPVzu6mbGYSCIpn1/4BnYhw054QWgsMYnhsiEc5T3dK3TUuBF9aQQbBEfbV3j7lueN2pIACQkiiqOcFUwIzTW/2xTs4cpUx8y1vKznO2UwJPLTLnMkDREPSzkqNVluQPGzLyOcJYA4cMzBfR8O5INUkJO9Emd9hAypE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define a new DAMOS quota auto-tuning target metric for per-cgroup
per-node memory usage.  For specifying the cgroup of the interest, add a
field, namely memcg_id, to damos_quota_goal struct.

Note that this commit is only implementing the interface.  The handling
of the interface (the metric value calculation) will be implemented in
the following commit.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index dc9c310e0e75..0d63ceb7e6ef 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -147,6 +147,7 @@ enum damos_action {
  * @DAMOS_QUOTA_SOME_MEM_PSI_US:	System level some memory PSI in us.
  * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
+ * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -156,6 +157,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_SOME_MEM_PSI_US,
 	DAMOS_QUOTA_NODE_MEM_USED_BP,
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
+	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -166,6 +168,7 @@ enum damos_quota_goal_metric {
  * @current_value:	Current value of @metric.
  * @last_psi_total:	Last measured total PSI
  * @nid:		Node id.
+ * @memcg_id:		Memcg id.
  * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
@@ -179,6 +182,9 @@ enum damos_quota_goal_metric {
  *
  * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
  * id of the target node to account the used/free memory.
+ *
+ * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
+ * the node id and the cgroup to account the used memory for.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
@@ -187,7 +193,10 @@ struct damos_quota_goal {
 	/* metric-dependent fields */
 	union {
 		u64 last_psi_total;
-		int nid;
+		struct {
+			int nid;
+			unsigned short memcg_id;
+		};
 	};
 	struct list_head list;
 };
-- 
2.39.5

