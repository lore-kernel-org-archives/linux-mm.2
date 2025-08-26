Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA87FCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F1C8E00AE; Tue, 26 Aug 2025 03:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF8F8E00A8; Tue, 26 Aug 2025 03:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305598E00AE; Tue, 26 Aug 2025 03:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 205AF8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:20:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2F60C068B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:45 +0000 (UTC)
X-FDA: 83818061250.03.76D58A3
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB4E310000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JSNm9Y0l;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sviwpOLmfQUsJA0/Zn7lWOZM8N8qF/XZa2OLJ+sIYYU=;
	b=rYJdeSFvg5eBbao4bwJKSik5+UlQTCXuUN6CgGrE0kPdVcV90rcUHhq/v9kQLxQu5jVJ09
	E8jc9Z0tG0GiZChY8aktKYCMermqjYfaVu/WxGlEpTJpDOF/KShnufZly60lTBUqprRmVI
	sbnZFAkk5ukTSdVpLHggGuKmpsVNG8g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JSNm9Y0l;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192843; a=rsa-sha256;
	cv=none;
	b=nnSYoRLDyEAflV4TwB9KWDrfcqEEDNVANZpBFm8ruVYK/IprtfSnXRkummrOYR7lYQuNAY
	0NhCMr0PlFUEYpuvUWUXLnniaMEEIYksptTbBrlJqpxxhHgS/F1kLZOwqQN2NPleulwSbm
	blR340iqOck6t+g6URcqefh8cXel2n0=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-771f69fd6feso761812b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192843; x=1756797643; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sviwpOLmfQUsJA0/Zn7lWOZM8N8qF/XZa2OLJ+sIYYU=;
        b=JSNm9Y0lIQrwLQNhILeJwOJex6txQeGW8iGuxw3dDdXuO1LWbSIYZkJflXDmSmyll6
         nqvZx6dmfZQJ8Qhb1TdS2Bhd3CLrCbvK9wB6Hab5UfZOJVEXHxkqKdjim0wA4SePblUH
         Awa7qv06mv1SyN52aMho6fVvVVcPMN90EF/ibt21NvmvVFrHeHOeMOMb7HZhMtqatdXp
         KQoJa4poi5LqEUbpBpJPPfPheTL4d9rBRyUpwPw9oRKOOXj8RXJfzEjx8V/q883orTXb
         WOr/mQAtHAn1JmulTS6dR97aStyDe6Dd2JWtyMcBKKqCk0gE+sZN9z72aOfGP1sGJbr8
         6Dtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192843; x=1756797643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sviwpOLmfQUsJA0/Zn7lWOZM8N8qF/XZa2OLJ+sIYYU=;
        b=EPmWNqs8J5WkUYFJsjsTDNAd7zBm3zak6rN2tWMxKrJE2YeoC4+HrRnq0gkvovrwhv
         KaIrovSRH0IEXQoaWWnwys1utr12E6KuXXIy8sJXCRPIAWj/D9k6kBf8sGdzekGZdz4L
         6R9TXy3/mxXGhKvDiGwIe/nU5bL/ta5TGZj9TUzkwdqVqYEeznFjL9H6Mz1Qq50/dxI5
         He1JbvpWHacH8cxUyHPgw0kY0/BISyWSf0SdQrfQ5ucT+UUseooSkmvq8BbB6FSl3OjD
         0/yTQL8mj1PpO7Qf5FAYHIf3UrZjI+1jcjXOzt5bgaAh2z1/DdzKBvOnL8FpBRPodst8
         aa3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7EScQeezbfaV/tBJ2WvI5OME2pKQ8mAtt4l76L+CWyn1X/mRHpTM9ELJseayq18DUo1esHVpw0A==@kvack.org
X-Gm-Message-State: AOJu0YwER/EYt+cshxxIiTcvRpTlIJy6o6EGLfHrEmwksU0nh1lMh+Iw
	YQhUWBiphktXK/pSp29gpL7ELQ1Gg5yUgB+XiRLNj7bniwf8+zj+7wv5
X-Gm-Gg: ASbGnctL7WGQLZ4Nir/EI8kdJA95xo3zduDB8vXbyQHT/vZ3HBkhwAWbZQc9Tw27lOb
	HNO9rXXmCYZW/jlDUIPi7Ofu0DlzFP/TdjHe2acCIsAjXPGiXLEFFtfYlu2Sug0hhrSKgn/ma2Z
	sPdVwG4WQyYoC927D1ESXoQh0EkEjXclRacgCL4dbDRtjKvOlOO8mOAvZ7H3d4w5f/sdM5wdif8
	egAdLp2j9Sez8EGu+vYMGb5FV+j6EIBkj7aUa96nrhDE+v0au8jt3o7Y7ZAr/lkyFZw3h3rtkF3
	Fqq6ePSJdLyHXFsuI2QfQbBcQbanDiRHkV9z8ekaLRPdk0FUP/J+Y7aN7TyDVo3XFkYYP6KJy3I
	X2gWqKAsN66racbumchKePG0Mwmyo/F/OEuhJCgO9h6Cdigm19hxoGyZk64XIz5R/BWT7H+lnS7
	qEUSc=
X-Google-Smtp-Source: AGHT+IFc/ProjGMVXcqa10X9CPlhCGT8IYwac5NyD5RvTObGqB9z0r+zsVy5MTfrS6xNwZ7PMnWYPw==
X-Received: by 2002:a05:6a00:a17:b0:771:e8fd:a82a with SMTP id d2e1a72fcca58-771e8fdaaa5mr5802935b3a.23.1756192842605;
        Tue, 26 Aug 2025 00:20:42 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.20.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:20:42 -0700 (PDT)
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
	rientjes@google.com,
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 03/10] mm: thp: add a new kfunc bpf_mm_get_task()
Date: Tue, 26 Aug 2025 15:19:41 +0800
Message-Id: <20250826071948.2618-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB4E310000D
X-Stat-Signature: 16bh4fdsno9d6jneot7dwweofpuqh3bu
X-Rspam-User: 
X-HE-Tag: 1756192843-606728
X-HE-Meta: U2FsdGVkX19OFJNMjfW+ZgzqpyY52Z34JsnV+qeU5zTEEcaTgCLoovfFg8dZqbal61aSrr83lhPjXyJDy0QtnEbSlpkfpG0mSC9ACqLyyJrJmKNrUJvit7RKAejq/27k0dlknm2VZA5J5faNCXD2PFvN+PUQEYA8bmTGcvjamjfjXdHoWEEkF/myPOKi3O6FE2Pbg7wVO4cQpAVPF2/wF0qIfDPK9sb8EIDGCrgUcrZhXzb4CRJgzG0eqFKRGVkhrODYFs+qJ5ScsGQuKc76aRXBAGgt/Mm6jcoHgSBcV+Hpc7O/tqUaFruoLkAVBM7ubhbupIFMJfMK3gT3AJc98J4Emqoimaf+quZ4Wld1aqlQfZWeMo3puHK69IKJqIlAald1s5rHrBF8sXsnhH8ddN1Z+8UTYYtp+09osYmCD+JuzWCZRI89AfACJU7Rwfg4CtGv0kfP8FSWeCS3cVprYKDqBDcYYIWfGm8fgrzPxsyUXcqsP1C/zeDT9XYpZc6blOlbSrYfd4PJmjeea2qIbsRTSUTbdKnPL9bmSim091pAD3tXJYw9eOXAhDw68vVCfNrvMvgP/xE/kgwhT4TChLdwwMX8M7PpbnQgaHAeNibBQu8vSSFx4fUrg7+65qkIwDhrmFeqljYcilbE5VqAxVxRVwX44kpZqwRPWt4mPOK4NTwE9pdK7k/tbRdR3hn/PoPRtkYgLKVf3P2WZL42RrMJgH4sOAUO6LmAvQIQzRKFGmW8PPTLZT0xYto6TaNuAxNJO2T0cHV+N6s2Olxu43coMuHY+Wt52uIi68oL483LtEtLDAb/8wcy7Y1Cejw18yN1eoxHQxMHf+tlIln1lMZiCi/0ebP7ASWLXzw8HlNP8V1Fa9Uen6LxoNIK10z7pKLhDowLYtKhA/SUqDpmKHfK2NO+3ZduyKpCPuaaZGh6kEtX9jBM95B5+fNWALgDBT3RWlFXil1ObAIsgAk
 5sJ+fl8E
 zNkzCV47zUDcyeFj7/riYR0CMuOphmZ/MyDN41dOzxAr35QO3+sGFRicqYz5/qVyK0dRhYwTbYz8xjaW4CZNQa/vYne3g3rxzFgkJaz9Q6iLL9MWwEhktxtIptLJQ0VTk+3oiyiCzOVb8Q0ZBVyStDpFg9XXuwxQ1pIbsKKsLQ9hCBJcLFI/r6AHSsr+WcuV6oUCTIhHZNqWM3v4MMPXAs7nHLLnHurT7+s14fyoKGVbcUX5yfC8AupvKevUj9ukQlDuYBB8kGduEbxdLiejHEtbH+XZfaJMka6oEa8okOHjeMSL5Yf4+O2asyBInbBqO6LNF2tjA7RLbjyn6D5ierf24aYrwO6W5x0++HMPTV14W8GA+Aj97x0eZXOPR6nE+y5f0gNvPj/EXtC45slvtgJoJG1yXZQ0kGbqPJAbOcEDhnlKq9p+t1DpCCP3K9Eh6gR2gU7WoZh/8Z84Em9gGkLmUBK/oI1fFLeutxeQaQwaOF6Cm/IeXtRqCNo8AGHM0j3l6lETqYRGcBLXymGyZ/BMHeV2baSjoAPYDDGb6ewke6TYl5QL+SAKTW8ET5H7b7Aq7JFo+O/0PAYne+SlomkY+xw==
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
index b757e8f425fd..46b3bc96359e 100644
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


