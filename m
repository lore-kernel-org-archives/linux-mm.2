Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4751CC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5446B007B; Mon, 10 Aug 2026 23:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84EE16B008A; Mon, 10 Aug 2026 23:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73CDE6B008C; Mon, 10 Aug 2026 23:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4748A6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:36:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCAE91C08A4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:36:55 +0000 (UTC)
X-FDA: 85087577190.09.427C461
Received: from out-173.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0530E40006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:36:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QADIpN8J;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786419414;
	b=lAAgLLPfoLm7FqnJuySNwHvwIQ86YfskGLGMdJZrr9qLnhocc+jOeESYk8Qd5dwrOxK4aV
	HzvPWatjGVqeEupKIg1yRFDT26co5DWauzjkSnzUO0f4WMXOn5WQBSABuqnIA+eBfb9Loj
	kG6PV532iAKhNlPu4OTzkRIxBB2zIIQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QADIpN8J;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786419414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3rmW+tHa6kovhH6yy177yV/pA5fI2DQqyj8ArGhMWDg=;
	b=zdDiDyy4MpyR/iPHeUVlw8GpmH3bYUcpvNwlkUqTqjg05EGfka/80CFfbI28o2ENeMPO76
	Iw+5Jnhe4iikuSMJYIi/qNbaDNfbvBRL68t9fHPSAH/dIduEPpR74E+2WFCe4SJd8qf0KM
	F7G5vSoyZJ0VfYelfusZtTHGOr8qzEw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786419411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3rmW+tHa6kovhH6yy177yV/pA5fI2DQqyj8ArGhMWDg=;
	b=QADIpN8JxDQrtlOR105KV7dV83Aqxk9jlF9GvAE5AtX+AS2UoxLPzvTKnQMtlHXBVlbizm
	5ZTTh3MFXu/2TgDR9L9wR+/KVcSEw0IOBFyiv7NdDxmIIciougrn3hd/De1N0MJIC6xFk1
	2Z4b9HStb+7CT7beqHooD/ItS1O8oO0=
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/oom_kill, proc: replace magic number 1000 with OOM_SCORE_ADJ_MAX
Date: Tue, 11 Aug 2026 11:36:08 +0800
Message-Id: <20260811033609.3992348-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0530E40006
X-Stat-Signature: fmuxowwuokb55t19uwsfndpboc677rmp
X-Rspam-User: 
X-HE-Tag: 1786419413-145342
X-HE-Meta: U2FsdGVkX1+LAU2fbgOUl+1cOmQcb7C15MZBM9Xd5onpCSC+QI3mJ32jWsBMtkjxYaOSYsSq3WawBFJ2+1hs30ZKpuc1ilYpwwHMntKlPt5DAUu7kd+BHuA9lnVmmwdPKV1xbn2bSkv5mnhzuMCWg0OGF/vuAxrfbsHfHlMNN3fhE8VZdmhWpl3kGE8/ROdSKe1jQ0virIOUMlp4wTDS9IbNPsUPDhwH2h3xE8xY7eO34zfff27DfJv51SkFL9B68yYAHtv8sazcwPqF0Iw5ZDsiNSksp2PETg4P01s3LfDltPoenC+4nNRowXQYtdxAQXhTcGrJ8WtrqBhTzd4tVKhC36nNJwgB52awuKuK5retYDJ/hiwjt9B0XrvQEqkCM5da+4kyvr7NynoSJ2eLtvedBB8+iKWfxONNf+taX+ZPkVwSC4KiqRF3SyruTPv2GohxmpsBfe1gdLq2yGXMhnA8xXFWv2foFWNlRTxmMQwuWjIqV8+Fb1SpDT0G7ZEATd5WM1/m7lUwB83vX+U52zrp5l+t2skMkQTz68BAtCuEPNP9A7xcecZ9gcOn8S5LnNTXl3GSGEYho4ZR9TO3exQjgQETAtewDYIEZUyr3aJEHLcWghHw+KAbEvD8RsTTXZbbMElIXMVi2/EIyoR+QOtrDLNvuzqKOiBoLTso0C+bCjwVB98Ja1XPIeoBAGGGhoflm+Epzbw1UWc7aa7lUsz6hOknZOxJLKk8U14WM8LVw8mBlXEClloM41vMAxCnIyjOvIXLpT86+ePU9LbwuqkHTOnW4pejP0yKWtEdGecF8Bb5JgJEHdXOoYtMGDSWK9XEC67Jf5oEbZWELjq314VUJeVMg0B7TTzZsjKwLUEia0VkqEtr/X50n+kDw3pnp7Tby0zD0cjvPkSGonmb2LT65zg5iMNdYkNsOjlwSovsVuPTnrNm8c5uOJi3DC38QcRO+Kg364IKHm0AFoZ
 1kHawkUD
 buFFYRJNd+dlkHJ7MHXcZp9AbdWqiTNn4f7oyWSnyvol3Pnxi1lgp18op+/Y1qivrpIveXf4JxLQlwY72+GKZ5oHlQ0rEMQgnJpXjIgTJrAdsVd/zP7ypDwSGT+v8ydSeSMNEboG7i2kc3Cjli1KRSd2rPseFU4VAsn1eysTjwHclPkc5keDhUaolcPLTxL/47dRcJ6+EpbiRN+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

In oom_badness() and proc_oom_score(), the oom_score_adj normalization
uses a hardcoded 1000, which is the value of OOM_SCORE_ADJ_MAX defined
in include/uapi/linux/oom.h.  Other code in the kernel (e.g.
fs/proc/base.c oom_adj handling) already uses OOM_SCORE_ADJ_MAX for
the same purpose.

Replace the magic number with the macro for consistency and
readability.  No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 fs/proc/base.c | 3 ++-
 mm/oom_kill.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a39de424f62..58be38942460 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -594,7 +594,8 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
 	 * exporting for a long time so userspace might depend on it.
 	 */
 	if (badness != LONG_MIN)
-		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
+		points = (OOM_SCORE_ADJ_MAX +
+			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
 
 	seq_printf(m, "%lu\n", points);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..08bff7a55db8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
 	task_unlock(p);
 
 	/* Normalize to oom_score_adj units */
-	adj *= totalpages / 1000;
+	adj *= totalpages / OOM_SCORE_ADJ_MAX;
 	points += adj;
 
 	return points;
-- 
2.25.1


