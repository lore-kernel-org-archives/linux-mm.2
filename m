Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B515CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480AE6B008C; Sun,  3 May 2026 12:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458446B0092; Sun,  3 May 2026 12:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DAE6B0093; Sun,  3 May 2026 12:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2411D6B008C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:51:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA0BE140702
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:02 +0000 (UTC)
X-FDA: 84726698364.16.40A96D3
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1CF9940007
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:51:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hxtFE+Gu;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQGcz1ZaEzbqgScDrowVXARi09LONkb6J25l1BcDqBA=;
	b=Cfabm7OIrs91VYPhFTI6sMobQtIQMyKpmHoa+iKOCITnu8h0rQESYfwwhlhG3caNZP7Sm/
	PKJZBRCvnj2wIlI5BDtxpun8f90YkTHGDaSg+rB6Pcg1YK4yeRYmScA2kkAV4z+raNgwiF
	WVjEg77qoqh0+Vvo430YWpfsUwg00fQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hxtFE+Gu;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827061; a=rsa-sha256;
	cv=none;
	b=i+B4rS7VoOvqabSCSXfvu+IOqRFf37rnXCFAYLXhwmjE54akb47n+MOwOQRFnoF5Fmy2/L
	r9OcxcsNNZEYkwtgXTvN2crikw7ZvjUJYzXKZnf3K1K9mFRrPZC8kvkwUMaUpXTYuGB95i
	Jwyw5EVYTylJn0k68GXmGVMXFIPADO4=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c7ffe8eeaf2so626006a12.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777827060; x=1778431860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQGcz1ZaEzbqgScDrowVXARi09LONkb6J25l1BcDqBA=;
        b=hxtFE+GuAV1KpeGVLbprA8/rIimAALbUQ0TULixS+WvrdEJwoiovTZSqz0I6F52RtW
         EGLRo20xyWZEI2lVgm1jgufAavP5X9k/50wBq1DoW7zfzTKpLOS/tTuFB2e8IZQ4jeWK
         iz36lFDsMWqsG2i6h2zgrnH/VeAJYjDsjaIeeiTRq6YfoVRPwTRj5MrJGBPayKvyCRYJ
         GEJQfiHPBuyCZ9sN1CGRRYHq4ds8G/5qqqdoEqAuX9inXp16PuMR1NLstrtariTCHN0v
         RDGNSZ0Q9/e8day+fxXN5vuwxbL/v4PGCdWtjNFqMA6cTe2JwQojg12Dm3+Qy05IGBpH
         pmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777827060; x=1778431860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZQGcz1ZaEzbqgScDrowVXARi09LONkb6J25l1BcDqBA=;
        b=mwvtVDn5q9VOxbLQNM3Wp0G17XUxOQnk/KUHcDri14NJKRZDALdhHGHcrtnxFb2uGx
         4SOkqz7F/1B440t7DZkyFlynPmTgwev3vat3Ht9m/C8QmUSRZxutVXzT3/DM4ElAP0rE
         +3Nlk9tz2mCseSptyBzVKH21h/1qO5jNIi8aUBpej87fl/KByqat1AM6v8v2aVx4hAbM
         KnMSKoTTM+ogDAdlXXLUszM1m/AA/7cF8mkzcAdXGe/aaTW7HKlJWo/gYA63F5IjzYG2
         fwNGu6qZBBAHC9K4aOrErU/zad/hKZb1zi64tV5J1fiKx/MfOV4pRBnrAR+hKsQ4xQz8
         ZiNg==
X-Forwarded-Encrypted: i=1; AFNElJ9lYIlUB+3NAnnx/8ahe63XwpUonav9Qt8DUAsFXRaAO7cqjD8Bmgs3a2JVTDi2jBQKwtuppNRH/A==@kvack.org
X-Gm-Message-State: AOJu0YxJ0SvS3hcrAjr4NpZu8pQf9bFm48q6q5Rmzeji4pa6q4bxtEw1
	xyZkUQWcNlYyC1Y9jvX+nnBuyaWuYdF9siREI58rbHRF1nw2d0ZpeJ44
X-Gm-Gg: AeBDieuAIcE9VQOOpblGcIKjvd70xv7Ee7TXvjkpeACQfQHV8EI7I+ZmtFz2nVRgCqD
	1Q1wkSBjMlYR9B9+efD8Yz2JZkmbHhga7VuOx5MZHR4S+QTgwQUC8Q2uWbcmWBVQ6COF6m+riOO
	PTClMSvGiAHE/X3L+zfy5BjtVZZ2m+Qs8gkEv0FOL+ThJYGh2e6+hVlVxRo+LcsslfbkQWgdJmV
	HUn0AP2EnKlOe2Oq+dy2Mr4UD4P61fGtG8IXv8RR2K5PtfyDoF3lgbWKJyNV9GzPzfY1/SUvSWt
	2GXlC193aiA0KRGaR1hMp3Gn2lH0VnUm6HmN4iaIJhvb6PvzwMBsPziywAGZ2Ey03BqVuEIg2zE
	LVVjBwH9VxfOai9y9iXq0se2TMyYscvTRBKVjukJaTNIDsyu3Cb5usrECtjiQAbHx4oHKBz3HxQ
	j+MszahTtlxV1gIcB1FPW5weDezBilZ8NfRihlzqUJarBIsCI=
X-Received: by 2002:a05:6a21:3384:b0:398:a659:eb0 with SMTP id adf61e73a8af0-3a7f1bc4ba4mr6919770637.34.1777827059924;
        Sun, 03 May 2026 09:50:59 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83707fab756sm1494277b3a.44.2026.05.03.09.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 09:50:59 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	roman.gushchin@linux.dev,
	inwardvessel@gmail.com,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	daniel@iogearbox.net,
	surenb@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 1/4] psi: add psi_group_flush_stats() function
Date: Mon,  4 May 2026 00:50:21 +0800
Message-ID: <20260503165024.1526680-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503165024.1526680-1-vernon2gm@gmail.com>
References: <20260503165024.1526680-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CF9940007
X-Stat-Signature: fmoc9mjsarnc6d9ku7icowjbycmpnp1u
X-HE-Tag: 1777827060-530337
X-HE-Meta: U2FsdGVkX18dC2A8Kc7Uq4JN6MWttF6PESAL5wYox9PQdl8Vh401qCPoQ5OmLUh4qF3+K7zdiRmCMoyQSRgyNe1a7AjOXNpE5ClYIN4h1LQ4s8Nor8W9RLNBYj+xQwnSrELuv16GigbpBZrM2MAQt45E0T/VixQeJInqJnBe53FTIaB3on6bWXq2um/2Is4R3fhzYshdGTMeYa3bd6RFNAYRxJcfk0pcKiPKHBZQTHIRsgDf7+g/7rPtrZEzlBK0v0puu4mi7gJ7pX4QNL9s05Lcb7o8l9tkIs4QPQiXNqa/ogZzwgHhC7eFFAhWyR7ruWg0HXt9Akr6iHhL15S8zr+ZsenTg/+7jB2iKs5wuVkvPcmprExmGBDSAQswuvKEnZcxnhUU99rNAJL5e/vYRrigzaOy8Tbqq8I0zPxuzbB7hGlOdb16LjQ0v9Zldj/GDPBU/H+vwY2u2rNvv1px1eVqTYwNpizDlhK0CNH4haiNYbPteEokrFcOylbHNZL9lN/TKhEaPe5esw7Qhm/jWbmbHCDlfHNb1NtTMi9A/8wU/rtXcj0zzxmSSXi4XqwHvCW4hGHDPtS8vmwAwoPjgu3TCBkc7OmM8yP591IQSSSzhnniPAM5kaWaRGPZq9ACN8WktVFlJqy2o/lc1wEYEzhCbpmGpDag7knnjlSFwARJ3CsH8vcuIzL9npw25xJlxgDPM1P/yL3nCpwUWNp0mfNDiOawscZYY+kXAClulNQFK9wRk8mVLqnx/JIxqWZ3aaG+SlXhfB6ONGJSP4lbGYLHGMFk8uX83CNEepToI7UJkcqg5ujn49ULqs1LFg/uTLrb4rwLTp9AOJBGQzJjppsXGmVX9Oq1alJprdm45ROVLkSQqT1dgDNiVYnYMjyCeBifCuHqvA4N8gzWayZE6bb8WtFa3MliQBtDqFIQGeeHiIP9YfpJk6yQIZecFFlDAE+XioHZt4CC9bRNz89
 Wjk7ZxdX
 vpzGWvylPVnXs2GEcgDS6jzYrug97HPYMxd3FSGKNWxId3TkzSjCdwxd+VYT00rFvRZmRGcz//PwsdjDlYM5OBsTLTPcVuvJ/h0OjbLLQH6K0JLtbqbI3rOIHXNr7K8gi30SWjX5u7taEHovXGvPwTBvdqLche5lKhevJXROd01qc6hR1pEKBeypYIiigppwtbiIyyzVWtBV3JW0uKR81VUQsUkuPtsJNe4JbZNb+l/YWWRnkRfTRitp8R299WkiHKEwDPdgPCzWu6yPtFDA5k8PmiCVb9zh0jadBs+lBYlE2DDqJkdc90Gkcglj8kd8jF6+MflWwiv/5CrpIQH/6UDfEQLS0gnjgSF2udmAjH/AOUIf9OlcKPdNhNKxWipMtdp2A0eSfPHfyv0IApazLex6lLy9EWKeZONi3vSOYlJZxqk8hrlgQdILliIIbnJcpimlLNspDuPyva3ACXvKp5SfhQQ0CNqTpwBMS599WQ2lZ948TDqwYzPbbU2c6WLTig3a+usk0q+ADhZoZVfP7WhWWYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add psi_group_flush_stats() function to prepare for the subsequent
mthp_ext ebpf program.

no function changes.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/linux/psi.h |  1 +
 kernel/sched/psi.c  | 34 ++++++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index e0745873e3f2..7b4fd8190810 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -22,6 +22,7 @@ void psi_init(void);
 void psi_memstall_enter(unsigned long *flags);
 void psi_memstall_leave(unsigned long *flags);
 
+void psi_group_flush_stats(struct psi_group *group);
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
 struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 				       enum psi_res res, struct file *file,
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index d9c9d9480a45..76ffad90b0b5 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1242,11 +1242,35 @@ void psi_cgroup_restart(struct psi_group *group)
 }
 #endif /* CONFIG_CGROUPS */
 
+/*
+ * __psi_group_flush_stats - flush the total stall time of a psi group
+ * @group: psi group to flush
+ */
+static void __psi_group_flush_stats(struct psi_group *group)
+{
+	u64 now;
+
+	/* Update averages before reporting them */
+	mutex_lock(&group->avgs_lock);
+	now = sched_clock();
+	collect_percpu_times(group, PSI_AVGS, NULL);
+	if (now >= group->avg_next_update)
+		group->avg_next_update = update_averages(group, now);
+	mutex_unlock(&group->avgs_lock);
+}
+
+void psi_group_flush_stats(struct psi_group *group)
+{
+	if (static_branch_likely(&psi_disabled))
+		return;
+
+	__psi_group_flush_stats(group);
+}
+
 int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 {
 	bool only_full = false;
 	int full;
-	u64 now;
 
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
@@ -1256,13 +1280,7 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
 		return -EOPNOTSUPP;
 #endif
 
-	/* Update averages before reporting them */
-	mutex_lock(&group->avgs_lock);
-	now = sched_clock();
-	collect_percpu_times(group, PSI_AVGS, NULL);
-	if (now >= group->avg_next_update)
-		group->avg_next_update = update_averages(group, now);
-	mutex_unlock(&group->avgs_lock);
+	__psi_group_flush_stats(group);
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	only_full = res == PSI_IRQ;
-- 
2.53.0


