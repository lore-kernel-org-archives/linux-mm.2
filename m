Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B63CD6E4C
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375016B00CC; Fri, 29 May 2026 12:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327386B00CE; Fri, 29 May 2026 12:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6726B00CF; Fri, 29 May 2026 12:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB7696B00CC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:57:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9271A12023A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:14 +0000 (UTC)
X-FDA: 84821062788.12.62B9E17
Received: from mail-oa1-f67.google.com (mail-oa1-f67.google.com [209.85.160.67])
	by imf21.hostedemail.com (Postfix) with ESMTP id B20691C000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQLTHf3V;
	spf=pass (imf21.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/62Lo7gqlbSGmK7of07r4Hjek/ejMB9r9tyx1CYLkQ=;
	b=H4tHwO1wfdM7uRFGnII/6Y2fadTVTGuqjGBPSvOXoS+cEFRH8xEJ8NHcN34LbwWEmxAGe6
	mHt9IYZ6jq/3N0C7E+ynD7lhL7yH0bPGGgKIDi3Hs9tdGYI19fdTvOjfv/7aaczGB5qC0Q
	8xaq6SwpNkVmPc5j7gyO1S8KqvzplBM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQLTHf3V;
	spf=pass (imf21.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073832; a=rsa-sha256;
	cv=none;
	b=OJWGw9PZ65HgODthRqGVZoPJ38wpUeQc9zLwpLJnubQXrNZy7Y9le5gizKyYUnYVs/ZGyM
	MADill7B0u03T6ViImKCFiNoh5TeVhzxsNdmgDxGOrCujvx1R9pQPXgD82q4kR/ODmxHQ6
	uQF5H+CMTjWD4rL98QIqifUo8b7wSc0=
Received: by mail-oa1-f67.google.com with SMTP id 586e51a60fabf-40ea36b56b7so10496831fac.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 09:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073832; x=1780678632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/62Lo7gqlbSGmK7of07r4Hjek/ejMB9r9tyx1CYLkQ=;
        b=JQLTHf3VfbxFOn6lwSoyasSCEqe/yCN4/0Hf+law0BRSDSsDj9yXCNsN64ZbND9uh3
         lb031sAKq4U3YzunITomJkG3TYYrZ62Z+3CigK5nK9L9FYMvNkOrm0m6sPZOhOI/WSoy
         TlSyYMcmgXXlk0+nX2GeeA8P+dXiUli9bkUuHJwQevo/W7DhdhErpCLcD/ijuP5n33Ca
         9KqgYs6NEyTKxjD67Fth3EJzu5D1e2SZgAdmbRYitmIKiyHXPhqyktomLcNX9LZ4HhJc
         DukwUw7AeM3XSYnhKI5uCckJ+FckQG9+Hn1r0rehzSvQWinLgsPI2+gV26Mkho+75R8l
         ILEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073832; x=1780678632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o/62Lo7gqlbSGmK7of07r4Hjek/ejMB9r9tyx1CYLkQ=;
        b=dpXWPBDKHjlScq04FvDgBmTbLVMs62NZYzvzZPQK7talGgYK4BjL1iIVTXKhdB3cBp
         pXqlzwUkRAcab1EcPjaidE2f1gETee53YG5EooILer8az4g2ARdpiT8qnS3SiSG1Vc1b
         BgDsnUyxpwRU+9J2251U4BpPeZkVNrDhaNipEXQP6jVqPJFBSWiR8p2aW89/n7KpHGmm
         2hNUk602kKKHXSn1bbAW045bJbAaAxvbiZ+KuxUA33dCBWWLhALBXKGhCa5V6xPy+KVE
         8xxb7UxGr+sKvmDsSgmBPZm4CE2yh/IU6YugpGkPQMekYo/9uFCzBdH8fhqY4AdRxClF
         LRrA==
X-Forwarded-Encrypted: i=1; AFNElJ9f0cfvV34hIH8shfoTyeOUbPgBqnU1VOma73vEyGgV6cAIt/28353poz7UBmrVDQtu3n9Rlm4vcQ==@kvack.org
X-Gm-Message-State: AOJu0YxUwDsjYj3IKFTPcIbac9D/fZ/cjkeViTvlxHVTPrSwq7cth31a
	jxdi7eBeFYTxJaWaXipO45zj7avx5Wj5dS9YgccAqAozoF4nYpfHeq0=
X-Gm-Gg: Acq92OETUFxrkCZMYjZXAd1uCsp+NzUpzvcskqqQnFZBdPuWClLs31advD7Aw/BQ2Rh
	KDdXBLN2wJacfgS1aYn0VzHK2OVHH/2PhkggB5jWLlIK7HW8AUJ2ORwV9VCD9KaB45QcpAR8Dvg
	4nRYUmj586162AKaRZ4WO4kfVUqrBKU69yzyfxXuQQFG+6go/ZxfT+luq40HaBnTBbsXbjDDnP9
	pY8xPcHHmKjHC6SqZjszYrcRlCeYV8wRBMdxsQdPD1spqxk2EPWMVPBJScxvpZ2P8Ho2K8M9umS
	tjLuxjdemNdIbwjw4CmpaTsStTMugrZKda+3YlV02RCKB827MnDfJ1C7S+WmVppRyScudlyE33d
	/93e4McPiild1ayKVPlHq0NalizZv60VK//qKro7yIFfsXElXnI+tb+HmmknLjqdQh6P8bYPIXu
	boQOzBJ7Mt4Kq0XoKMrDfcA08KZQtnJG53IqW+a2psZ/BOxQxl7KNmC0wQHeSAI7aLXiDefWe14
	jVdwuNBgpcF
X-Received: by 2002:a05:6871:81e:b0:43b:9922:9ddd with SMTP id 586e51a60fabf-43ca425b65dmr369732fac.27.1780073831692;
        Fri, 29 May 2026 09:57:11 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43c93a2861fsm1392913fac.3.2026.05.29.09.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:57:11 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 6/6] mm/damon: add damos_node_eligible_mem_bp tracepoint
Date: Fri, 29 May 2026 09:56:40 -0700
Message-ID: <20260529165640.820-7-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
References: <20260529165640.820-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B20691C000D
X-Stat-Signature: cnn7aohkgw4on3jzz7fzcmhg9myu3mq8
X-HE-Tag: 1780073832-957763
X-HE-Meta: U2FsdGVkX1+TZ/OCE7HUdmqWrUpKqv3eUB4IYL2fPg3DpbN30jBQF+wdDbf31zeStNNkXlarfculaAPDtKLRBaK5ZhP438gEY/yFPR4sDiS25PSfmC9iYoD3NMzA1wWzojBBjYz3zluT1Ds/D645CXzab04h0khZIIYIWLloo1U7ZD7CrrevnC3P3l9u4l5hq9hbUJSBWx2aVDqjANQiAY8VGupgAggAqppj+te1zRaCXDfpTFnMdf6zxEGBgSxkBADWM+mOmTg9ZoGqXbBmtXuou0KUiJ2Y7e15P4p+SHXWivss8qWftZT3mIV5TMY8wLvdEZTfJhjagkyESWc4xpo+Hp5C7t3W3kvJoi7io9tGkMRJLuW7K8V7e8q+jI9/+DuB1XOefVW2h69YZUugxMUhaEa9DaXp1bUis47rOf8fDqMYuMAkDwYdQf74YV9zTwURpeISEDBdIl8bcYRGRHJbo0Ib2szPA4P+tKJB4vRNi+UBmZJ4X3yNSN4x/OlXsLvjyGwKs9R+yhSLO9riLmc8RYsdCZssg36VZDBWHwp3HXyS3VwghfjSniVQevQspm9BMr15/n9lZSOCamxYByUer3tgUQbzM7nfaAGXI2xfqIpWuMZTDInrInGphrsqJBCnqnrvsDMXXSMFM3uTC2dwcfdHaVylGRNPU9dGB98vlrO9mAObaTeRbtjbUSx8+HsTUoXDFP6/JRHK37g3555HP0tfYrDAIueYAHrCD6bBq0n2RuvbX9xfBKybe+3UtjPtwEvBBaURScESw0vD3wGLk1mmzWtc9x47ReYI3SUJ+QZohwzIT0AItSlhHI/3gwsNDS3wUV99R98EAOYhE/6iWXIhOHpWL4/4HNkagn1LwYjhqDGXTk37eP/TlY90aJ4eS8Z9z0mmgc7DOaLKWqOCp07jMprd0GpaetlKMvz8d6NXBx8S3X+q7+XqXTg90GWqJtVPdEaYHBSB2qp
 Dr8ilVUE
 51RV4dK0J1LUhYBP72XO8WB+ycEqIZjqYxWlfva5GLgk3iJPJjDyhIT3XQuwigRL+ORCtBzY1DVPSserd4UsNz/y9BYGK9GBKXLfdsqb1DFAUkXtbrFcxmnddIBhBUElkSDYYAlUsGRwQ50h4fOkMx9qGXHBG2nmWBdHFnX71t89qyIgCiFa+551rwKEPjcsj+sLhxsfH3h1O2aje7i0QDi+NFRg4FnIt/y8UxW0p08Vl504It5/dzhWIMOkEC93F1RYYwr7VrQ6Nam4hWjP6iPd6TMWmZI3QJJVW+bGTBTr3Mhr2yBf19/YhM1+0kMIdZG4ABuwCYgEyOokwTTzlFbipE1hxlDxg8CqSYpwracBhWoo7ShnNJT2a8Rn+VKsw8Y63Geq+nlfG1aLEC+DoJ5UuBJleBHRuHacOKxEXb5gVLHTr3+QsO3WGkGi1oiBCdKXv45aiZA+5SWk7Tvh5LgvBo/JSTieWKwznw9ETqyE+ZGzdQLPlzqUi9BLI7UszKHVaBEmD2GMwgvwFIYiLtw7EzHb7y06z6+V2d8nYGXHMVZf6VhKy0hQMyf/5dxN23d1oopRA1EiQcBqGZN5WhSfQxLud+xPY98wfX8Q71/E2dctwhw8jP4VBBWtj1j8uzL2laUv+YzhlaWd5j2KVA+vzND1booznnhYK1q2B1HMgifTnUpIB/WKfqPFq4LgSrMPG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fire a tracepoint at every DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP goal
evaluation, exposing (context, scheme, nid, target_value,
current_value).  This gives userspace observability into goal-tracking
without polling sysfs.

The trace_..._enabled() guard avoids the damon_for_each_scheme()
iteration cost when nothing is listening.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/trace/events/damon.h | 32 ++++++++++++++++++++++++++++++++
 mm/damon/core.c              | 20 ++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index e97e70579a8c8..877627c9a1a18 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -91,6 +91,38 @@ TRACE_EVENT(damon_perf_ring_overflow,
 	TP_printk("cpu=%d", __entry->cpu)
 );
 
+/* Per-tick DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP goal evaluation. */
+TRACE_EVENT(damos_node_eligible_mem_bp,
+
+	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
+		int nid,
+		unsigned long target_value, unsigned long current_value),
+
+	TP_ARGS(context_idx, scheme_idx, nid, target_value, current_value),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, context_idx)
+		__field(unsigned int, scheme_idx)
+		__field(int, nid)
+		__field(unsigned long, target_value)
+		__field(unsigned long, current_value)
+	),
+
+	TP_fast_assign(
+		__entry->context_idx = context_idx;
+		__entry->scheme_idx = scheme_idx;
+		__entry->nid = nid;
+		__entry->target_value = target_value;
+		__entry->current_value = current_value;
+	),
+
+	TP_printk("ctx_idx=%u scheme_idx=%u nid=%d "
+			"target_value=%lu current_value=%lu",
+			__entry->context_idx, __entry->scheme_idx,
+			__entry->nid,
+			__entry->target_value, __entry->current_value)
+);
+
 TRACE_EVENT_CONDITION(damos_before_apply,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1e6966e45144f..609d627e2b33e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3203,6 +3203,26 @@ static unsigned long damos_quota_score(struct damon_ctx *c, struct damos *s)
 		highest_score = max(highest_score,
 				mult_frac(goal->current_value, 10000,
 					goal->target_value));
+
+		/*
+		 * Per-tick visibility of NODE_ELIGIBLE_MEM_BP goal evaluation
+		 * for userspace convergence-detection.
+		 */
+		if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP &&
+		    trace_damos_node_eligible_mem_bp_enabled()) {
+			unsigned int cidx = 0, sidx = 0;
+			struct damos *siter;
+
+			damon_for_each_scheme(siter, c) {
+				if (siter == s)
+					break;
+				sidx++;
+			}
+			trace_damos_node_eligible_mem_bp(cidx, sidx,
+					goal->nid,
+					goal->target_value,
+					goal->current_value);
+		}
 	}
 
 	return highest_score;
-- 
2.43.0


