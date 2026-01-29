Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252BDD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F1C6B00B1; Thu, 29 Jan 2026 16:58:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491CC6B00B3; Thu, 29 Jan 2026 16:58:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF3B6B00B4; Thu, 29 Jan 2026 16:58:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25E566B00B1
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:58:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA9C61604B4
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:23 +0000 (UTC)
X-FDA: 84386365686.23.16B0C50
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A3EAC0011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EX6Bsy16;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769723902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuNybkTlqvH+9m8T0FgwqGQF2N52zzKrzPQ6MtpsUMY=;
	b=QkmaDl+AVD7FMiFXMecaVHlzN5+/3O71k+DaEajSmP12FaizyY8m/1MRXNKBS5FmGaZf+x
	WNwolAiXRMfl7xRvytE758HD4rPrWAu7c5RfCQGtnNg+ZJkZRV+OOw+r489El8sU5SuFEc
	lhlhOvzZlQZM1AN5mCnbXTKfJTxFqok=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EX6Bsy16;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769723902; a=rsa-sha256;
	cv=none;
	b=xSR0DEcHqQS7GVZUXO0ObVdBZxMULs7pBJGlTCIVt1uxM0hzIiiSdABkh+KbEEELk9H4P5
	G1LrFrTMtosjeYnw9lmxPdvamt43nmmQEopAno2SelINul5JXx2AGvf5SvkJQjJHYENGBF
	Qmsxasb2rrd771VeMx/x7umSspZLmAM=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b720e4dcb4so1884364eec.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769723901; x=1770328701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuNybkTlqvH+9m8T0FgwqGQF2N52zzKrzPQ6MtpsUMY=;
        b=EX6Bsy16+wasPQaoni7RR6KAijoPf59pvTvgMc+CnRZKmZrLafefnBm091blPL2yqh
         Z166+TrfUxhrZExGiaY07wXmazjRDJHslcbz3l8IpJCMSYKiuF9tdQ9XDcdPbqvJEbj1
         kdmebUX8EO/Y5/uPa4fe+2CFBerDb4FgT33gKXOgAiSoJvtPEqNYBk7fXPxvRJDEc7pS
         +Po4ATFeSVDp7jWVKLzKIRMWD3GMict/NXnDs7HVBdKQyh/m6S0r339+Bqr35hQi6EEX
         4Q5ZMyj4DreSv47wQYU5p6gnLrPICGLnE968zzeI/t5iHCM+zJe01mRxVCc7rRa/HlLJ
         bIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769723901; x=1770328701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JuNybkTlqvH+9m8T0FgwqGQF2N52zzKrzPQ6MtpsUMY=;
        b=MHKaooiMsKOWqQCAXyZnJctsBNsV9jOgK1Ld5HlgMxOtUWoItqth7zzWvu8GnPncRD
         5XA+ktIV/po1fKkACsGyb7grsIHZ+2xeGaIS5WAIOOx8OHBozKvd6GNMZ8NJAqDtQJQk
         5jyeWNxXboEimuNiGyC7psZHe66r2RZLIvRj5vcZ46H8rsEJcz1GeDkg73f/0W8T2cqa
         A22odZMd27VBdxWIf5fIbZCf+iKfl94acFbkgE1iJhsJyDvk9p512N0BxdqB19gdxBZb
         gz+Dr1qP/p7lgfQGrL5tI5gOfbntg7LIdm+Yrt/L5HPj1CzYNP1z/s6ZZn1bEKCG5SyB
         ikKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxlZEEmaH1bkSK2f1Y9TNzwRsfFEAIxYUl7jlVJeNgjoQlgrYbL2pL0LBQemvr3AqOLyQWyktb1w==@kvack.org
X-Gm-Message-State: AOJu0YxOAv+tWjouI2eMmLKIZrdNaBfSI3RPkpDAiRwQuiTnTthuSAU5
	ijMptlx9ELJb+W7Al+bdnqLFoxkkd+Y3yJDG6/tc+9TV/rHo58rWFo8=
X-Gm-Gg: AZuq6aJ54/JKas487eIwERMYY8JVpJf7d32LMWN3dMqfvC0uHuWaPr8xBe9y9UjsCuo
	3Kl8f46rx+FCDYs4F7MqXOyqcgOgTuJGm1Eg/N9B+ABm47Hmx+kHhD/UVz8WeWoJzyhYLlClrt1
	InDt1S3hQ703NNEZHQRMCgp8ASAITeazWS97VOkimXmPc2+xZaDmRo5ajwYhPun6UtxcvlWkAOe
	lxo2//tvmv87AVmvGmr/1Szqgv3S+ewSBarhXjEX18SNeTsiTytElywGA+0JRK9OHpCqJJrqaQ7
	E0CshwmiEpYnTOdbRr0+PxBoyViZkMI2V3sToMDne99SaQHiCddY1TmA0kzssOgCN/GTNtAEUjW
	Bo+xKRPQ5Xt2S2YoT0SisyUmKPX96m5ounFzUP194tY2iZZ9WFFYvY4/avI5NOl/pgawSa591St
	y9sSSXa3bf6w==
X-Received: by 2002:a05:7300:6404:b0:2b0:4c12:d74d with SMTP id 5a478bee46e88-2b7c865541fmr553751eec.15.1769723900641;
        Thu, 29 Jan 2026 13:58:20 -0800 (PST)
Received: from localhost ([137.201.204.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16cf8d6sm8585570eec.3.2026.01.29.13.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:58:20 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
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
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [PATCH 1/3] mm/damon/core: add DAMOS_QUOTA_NODE_TARGET_MEM_BP metric
Date: Thu, 29 Jan 2026 13:58:12 -0800
Message-ID: <20260129215814.1618-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129215814.1618-1-ravis.opensrc@gmail.com>
References: <20260129215814.1618-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A3EAC0011
X-Stat-Signature: 5hyf4wii46nic6rwctnzzxwsq3abdupx
X-Rspam-User: 
X-HE-Tag: 1769723901-933513
X-HE-Meta: U2FsdGVkX192Mnl7EbqFrTHYdQeYDOOK4J+Imip0EVXwPNVG0m2bJZM4e8NS8a5RSO4Qjz/0HsKLLfWiLvZix1ZeQNux9lAyyL0d+Bs0a86wllq2TnW7JR3yVbVa4OB9oe9LpaveS76OovhdAf/1U/+GFpKpKBrjJNGPv10JTfAnbKE1Ci3b6Z+zD6IpZwjOWVe75/b+q8fMRo0yzVGXDi1M0g5psDhTU4Zc2F31DHXl7YElYF0Mb1AH1ZUBVqh48va65Q504u3Ws2dJD+W6zGHraTStuCKRr3A6tDSivv/bbCtMuWK5FKadi19zHMEyq9Jv9ZV4IXs8PXcjP3Xh6OVUTuDPgfvAcFpYyk1gZRb8bTNzYSIUVOEPpbyvHn4pSJCZ8qspbSBqTN3R6mnlCUHC4ucKzw+2N1CKaUWpM9E0JZkNiwaAfnu1C9A18GdkthLk/rWHx5+kJdscnQ+VCgdMx1Y5H/Xrj64AB5OLt8Sffh5enHfA7uSQP7m9Z6vlCc3+xpTos/Mn6Hn7XNL/XhVcs4viu867lZif2G8zQVA2toNAcRWP9o1xjfkzs+wp1PW1WX0BMnvL/4HRRfxphPSS+5zpgZaJaLXmvQPDm1Iwy4PoZ92uHSOPDSKyKlatHRxw6Eb2TSkIg5212F7AqB7jtXY1Mgb9ZWOFWFMxZzFE3bkXmu1ekGYR3Hh1S4e0ktXMnIhx3yxTByka2cUQdhIgQQPN5sXs2KKQb/KfhAhCxv/mmzByPhpiuBK5asCjrDNTn67Ex46rtWvCCywaIdvCDWY7T+GOpv/RRBESB9aAr1xVVoFxsNCy1FvMdIzp7hG4hypUQ1Qg0JoQ46fMWhKqiwPpwqpLxIw1XspQGFLF27FkuBM0yTTxoJUbWahg0SiiWJchEyHtJJeFJmIVrhJ0i1fCLotBCbU87+LBcpj3zGYkaBNP+9QSoCmPrzb/0NFyPguf010tWlCtLjM
 ttXjaT5n
 uL/+uyuDQmeAUOKDuQocT/48v7use0WGNAIx4QAMwHNLQYLz8mVYYaWm3fxZnnhtBT1kEjazJEmIa6zdv7SCsyLBS7+N+SrNi+OSccwXgWR1dCnfI0+L74e78wGcwY2lDukZX7MPk/SxH0dpAZNKEukyjiMBsG7sDvbJtQYCmv1F4s411cktjiPSOvqkFjzM47OJaJ0qBO1vxsq3SMsBTPnUEDP+ZcLm0cnSZphPnkIsdjFECPYCocStJ3XRSqqNSmu25KBav0Oy7PYD2oDSOKrAsxizYjJmi+mQYLE4OoXJbOIUwtDdI488xnIhOW0wNQzZgRyXrH/KGz3yAbn/QcvsZ/5Az3hzOa33cyVVC0gZdAVTe611P92qcihH0jx1byWpoJXQhVY/awGYEkURRCWLc04FdgDcrLlH/mVxN+LS9WJ5T8d3Jk+zMzmZqta0S9rKjhc4TA39VxOpWZIwznlkaGP7rutqOUgG9MAxqPNrQduDqsSg0xFNTuzaoWhz5Rgqmm+eQSkDuxInja9HqBLQ3y2TICq7Yv3SFxqTcbf/HTpHuaVrdNnxym1tdrFIyrSZ28mE3KR23qZianVubOuh8hgu7CxFl90s5XbRXSsWZ2tR/+81W3N/wSZga12weoyARN0U4sZC1ir+gUBjQdSdqIWvXDIAeqtK+cVOrmMHezvHLl1nHnwjtNb+8Z3x1Wz4d62s5Q85XuWl0ayXpxFDi8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new quota goal metric DAMOS_QUOTA_NODE_TARGET_MEM_BP for
physical address space-based DAMON operation schemes. This metric
represents the ratio of scheme-eligible memory on a specific NUMA node
to that node's total capacity, expressed in basis points (1/10000).

The metric enables auto-tuning of DAMOS quotas based on how much
memory on a node matches the scheme's access pattern criteria, which
is essential for controlling memory migration in heterogeneous memory
systems (e.g., DRAM and CXL memory tiering).

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3813373a9200..5eebb8aaab85 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -155,6 +155,7 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_NODE_TARGET_MEM_BP:	Scheme-eligible memory ratio of a node.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -166,6 +167,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+	DAMOS_QUOTA_NODE_TARGET_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -193,6 +195,9 @@ enum damos_quota_goal_metric {
  *
  * If @metric is DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP, @nid and @memcg_id
  * represents the node id and the cgroup to account the used memory for.
+ *
+ * If @metric is DAMOS_QUOTA_NODE_TARGET_MEM_BP, @nid represents the node
+ * to measure scheme-eligible memory ratio against its capacity.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
-- 
2.43.0


