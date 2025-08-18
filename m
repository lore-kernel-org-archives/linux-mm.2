Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EDECA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2886B00D2; Mon, 18 Aug 2025 01:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C646B00D3; Mon, 18 Aug 2025 01:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E576B00D4; Mon, 18 Aug 2025 01:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB2E6B00D2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:55:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB34B138F8D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:47 +0000 (UTC)
X-FDA: 83788816734.01.BF28605
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id E60C28000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gdnu+w7r;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WchRBPasEr6Tpz+n97umBRoFJbuD1ZXf104QzBiW28U=;
	b=Tm+/NdI131NOsjgiMFW+gV8qctf9J/RTYCGDEui3G1yebSA90hCUCkrv2hBI4Ie2Bu5hzp
	KYJR0nrbOzT1AItzIH4uI3tqAzPAYH+jmHG8fKMIj5JLOTZb3S/vmpOBRr0XZrGEGvihQM
	Kqhzk/xYPuzqK3yFJDZ66f2thEiTd+8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gdnu+w7r;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755496546; a=rsa-sha256;
	cv=none;
	b=HyMY8wM9f3VL5NJouX8eGlcoSV/6xocG5eEmPa8E1YiSNYgu4xKP2K2BlISBFFjiL/YP3K
	O0dGmqeQpS0QLRHWDPiuy+6RKY6BBjcb1WFk0e1ajHQaSW//3u0WzfTIzlK5+yNAvtU4Ix
	i5wpFrcyVQ41bs+41fMSym+relCnMfE=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-32326e8005bso3774629a91.3
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755496545; x=1756101345; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WchRBPasEr6Tpz+n97umBRoFJbuD1ZXf104QzBiW28U=;
        b=Gdnu+w7r06MwBBiykI34K/IBqSRxYbfR/fTMAX02TATAUmoFGiG3UfmMELWb0RbwD0
         0PRT73Riw/7LcqeehUrCOxNNVYOg5A7/bj2KAo4ZjIqTr2GaQb50WGfoq0O8lBjjiTxT
         xI3L1iuIeq8Gzqiou28nHvoSLG6DKlP3lizfgxABTFeaeu6ZW0GxMqmYKTw5RSklZmXZ
         vlu4AOsTxqmyaFbJNq4iCMiE3tXlxZv94upAb9ewU4LhsXAILb7uZCkDrk7SMwWbsW6s
         0Vgkflbe+tQCtzsnurpxWXPBbhzRqc1Edz53W3MJap9sLRFh49BPuudjaKEedwh7L4bu
         F48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755496545; x=1756101345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WchRBPasEr6Tpz+n97umBRoFJbuD1ZXf104QzBiW28U=;
        b=CnnpFjZywgEQYiHKpF855kKF3LB2hTj4NeaHvdf8QKJFCS627IcLl28fhd/UAbDoL2
         2TbBEwIH1Zo8DiaIKKWyFsrWnXr90Wvt5men5BsRLDX8IBM7R2YSICKiEQqKw/tg2bUK
         cU6iZX6y/217QvqAfRYfSNu4jHAlmXGa7ze1QNy/0I9UW7pDxg1YmD8e1DjWR6OiDRZ/
         MLGS0FXsQg0nkz/XFqIMQwctj3nlrkuR0jMvy7AwqD8L0XVCJ2xaEGtLUHRVd/nZefeF
         yS9M+eTl9Hg8DR6VmPsegtNksQ6wPQ5u52r01MYIzajErxRBOtIV+Gf+h0lHPhwIvVRO
         yGCw==
X-Forwarded-Encrypted: i=1; AJvYcCVt/y6f3IA8bVwMHDg0li84wbXDgWsx7nS390jxGsMIvWDYONOsxho1OY8NBzUsFj/SOADzAr+egw==@kvack.org
X-Gm-Message-State: AOJu0YzsbCoLaR8R0/akwveC3fkk4X9rgMj6CpACSsPMGgNilgGwaOcw
	uUjhhztbPEhWKFSNIAlD0dU98xeL0XLdP26kBYxTVuTJ0Tqdo8HwhvLY
X-Gm-Gg: ASbGncsmvcU3H7FuLPcYS1mMCzTeOb2a01QV0wslZ3cBJdxS/2OIRZOtdiTlJwg00rM
	a+vho5LS9klPqAq9S02rwOihtoHPPFZfMB2aY5HMCzmufqNHXozzmAU6ftPq1u5UMfRGMmXqrOi
	0BJ0J0MOB9tkqeAxVNYmuDk3qJIV4BYbB0E9ttCVPATPkR19WFjfZpDzlMXqs47xNT7dpGQwtpj
	aL8ea4EwL88IxxlgVz5eMG+f4y6OIbMQIbc6zZR/6ZzsYDO6c9gkVMcOM1xQPSeloN1BcwfiaBx
	JedYl0suywahtOAuc9VdyGKQjAMoMbwfhCumc74aytZcW88Os9pTFZXAI2LLqF67gt98sWNND9b
	WPk2FbAc/RMV0qo4XXZJV0jrx7JFvxWaJW7i30JWRk1RI2Q==
X-Google-Smtp-Source: AGHT+IHxTn47ZmNwjEV+vkqmS7ZRcV1WEWwI3wyh0lkTmxGBypoYQR3vwEeiItFXX/ucwnse5ZBTuQ==
X-Received: by 2002:a17:90b:2748:b0:312:e279:9ccf with SMTP id 98e67ed59e1d1-32341e9bf9bmr15906029a91.5.1755496544751;
        Sun, 17 Aug 2025 22:55:44 -0700 (PDT)
Received: from localhost.localdomain ([39.144.105.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323439961c9sm7003413a91.13.2025.08.17.22.55.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 17 Aug 2025 22:55:44 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v5 mm-new 3/5] mm: thp: add a new kfunc bpf_mm_get_task()
Date: Mon, 18 Aug 2025 13:55:08 +0800
Message-Id: <20250818055510.968-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250818055510.968-1-laoar.shao@gmail.com>
References: <20250818055510.968-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u39f9unta6sz469gcz611ia6djjm6eww
X-Rspam-User: 
X-Rspamd-Queue-Id: E60C28000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1755496545-555396
X-HE-Meta: U2FsdGVkX1/KDqu+EwKplUdaNdc318+sWvZuJBdc5Y64wJKx9l1sBShK14i9slYptowwoSISHVC2t5NrCGgrSI/BT/ZSPpL9Lkqf79XiDR1xm1kjXmC9EulTwdLidBNCCsi0eA57toUEfhbAGbxw6RKqThyAKTTGK8eLNGkYLasGYZyAj7NTLs7B8kBaA+q/DE4i/dVaGc8qRX5FaHyx7yhYvoPbsrz6LhcXS+4sBStivmg3Z5nV2c445JTWQV7bFIXHqnpjUjIb9Yxz9OLhi35Wa8vFOlYvCmY9+LnNC93ch9j7i0Qp/dXT71DZ1BJGkwMyjEbYO5Wlc3rF1PM2XFWgrJzET+wT18zZKHTLsh0c2VmWdSfNlwoo3z5NwCtfprt4vfIi1/qoSXqK1Qe+yPm7HemoxKQTEtaS22FtT0nok58hObTvc2e5+quBWwMPxsyg7wFglnb0XphzbOmsvJ+irqYd++sVO+csagrVSkMJkxTNTD8Rs63KdMK6dwbWOGuUdIuZyBl3IiQYFXmf+mzSljGX3h95qAonOXqjGTW747OKhH6NouoB6S9parkG3AMhlKCNBWDJG0RMGoIBrGAsimVmsQOPND5RCdnb6OfSYfBt5620L5x5XQhmrS1RgiJQvsuZ/OWufUaKVRGeMpcrccnrl1d862bNoszel+SMaoGDuPbKi8phmGLCBdAlABkEJfyZp14zUFHsejWg7WMIbZUJ3vOzj1/mTllSN6kt48RSh8ECzjcszbOk0iPuZpCZpkoJjKtxnw98Q9CMs70ZkCFqp59gKgeH7TfJqVz4luqxI+CS8DxvVlzzR8tPo2tURdNnpsy3ssqe1N4ow4YyaexlRBWuf7LkRTxOOTAEI+cFUnEbmIy2NVu8kyOzCMfUOAKZRukTJtyAe221g+bYkdyFAneyOzNTuS0vzyc+7dfxI45rBS/sjuLulWz8A1PtAWlQoYteGq9H8aA
 0uKKaDj1
 gtgOi6nmeVNyUYl8dYDvdWKKASYqkcSdwGZlwd8UvhIkQ6GrpW2lnIH9PfX6EhzD5Fjv1LCRU2xS3mC55QrvfjmJJZYV7C+tWbSx2pd4mRry+omnBH6QPkY+Rd+3JR3cZio3119MrQht1ae1E8kNnamxzMoczFyRQoB9Za4d4QMJlFOZ1x3SPUW/IBGKF7Bh08TWu92kD+V8U/i6GUZttqNqZMkIeA7eLS6Erfk55Nx/tDQX9u+UdCoZwlafgNGjVR0/Eh6wbaKPTvm5USDcCe4t4iniUlS5TuGcv0TX7LZUTDgjWSy+Zinc57hIPgLZSXN7v3KNyErIJFEBw5LISdz2vx2kjXUQELHSncQumUVe5wWaGQgsJMjU8u0BjKOicVEHRgyoy+ORrxNcp69RmKao9fd2iKirhwhdgW16mbhb0gsFZK2Z5lnPz7Re4kU0/5XvDn7ndMoXa/bnn8DP2nekHYoyNk8HASBcJLh9UVosahA27ygfR8Ij93AlbCFGS1D8StzX5JYZDXY8Aj/J3m9M91xbkFscoAMq9GMfPWim8xzBzYdnJi10eFQ4maL+NK1EbQioN4r3zgqZ89Xqj34BfOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will utilize this new kfunc bpf_mm_get_task() to retrieve the
associated task_struct from the given @mm. The obtained task_struct must
be released by calling bpf_task_release() as a paired operation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 mm/bpf_thp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
index bdcf6f6af99b..8ed1bf0d7f4d 100644
--- a/mm/bpf_thp.c
+++ b/mm/bpf_thp.c
@@ -205,11 +205,45 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 #endif
 }
 
+/**
+ * bpf_mm_get_task - Get the task struct associated with a mm_struct.
+ * @mm: The mm_struct to query
+ *
+ * The obtained task_struct must be released by calling bpf_task_release().
+ *
+ * Return: The associated task_struct on success, or NULL on failure. Note that
+ * this function depends on CONFIG_MEMCG being enabled - it will always return
+ * NULL if CONFIG_MEMCG is not configured.
+ */
+__bpf_kfunc struct task_struct *bpf_mm_get_task(struct mm_struct *mm)
+{
+#ifdef CONFIG_MEMCG
+	struct task_struct *task;
+
+	if (!mm)
+		return NULL;
+	rcu_read_lock();
+	task = rcu_dereference(mm->owner);
+	if (!task)
+		goto out;
+	if (!refcount_inc_not_zero(&task->rcu_users))
+		goto out;
+
+	rcu_read_unlock();
+	return task;
+
+out:
+	rcu_read_unlock();
+#endif
+	return NULL;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_thp_ids)
 BTF_ID_FLAGS(func, bpf_mm_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_mm_get_task, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
 BTF_KFUNCS_END(bpf_thp_ids)
 
 static const struct btf_kfunc_id_set bpf_thp_set = {
-- 
2.47.3


