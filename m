Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DE5606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=I3IrP8vj
Received: by kanga.kvack.org (Postfix)
	id C97796B05B2; Mon, 16 Nov 2026 03:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45E86B05B3; Mon, 16 Nov 2026 03:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B586B05B4; Mon, 16 Nov 2026 03:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 824776B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:14:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06E5640907
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:18 +0000 (UTC)
X-FDA: 85440269796.25.7465194
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6EDA40006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=I3IrP8vj;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hykglC9qjGoSXJNJVYRVj2488doF0rYVIjiEwYqGfzk=;
	b=rWQJPzQUbYHNBF/KVeotOGwPh1WjY5lODy/tpmE9k2E8pmnilxuWAytxZFwTbrKA2iCKZH
	bWWAhBPqq3rNKaryP9U4usoDxdBYQ0W+wQTl/ylSfzEsFyBvEcKONs9VCkNiIqrUtvNlDF
	TaAENvJp9dZNIw+o2iOJjQTlVEN6/io=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=I3IrP8vj;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794816856;
	b=HZroE0cwrZjDs7esN2eR0t1EoIZrJEo8dHMHI7clXGz5+xmvb7JyXZsOBzqMeEfW0jE1vJ
	dpkFmBaQk9+dFJI1RgO+hLykygNpt0+OQmgRFfov1NIh+OPVzi013FdJIkjiW6jIphQn4m
	K5NNO8DpuYIHapLGh2iRTAyEG+QNPZs=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49d05d51553so16576465e9.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794816854; x=1795421654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hykglC9qjGoSXJNJVYRVj2488doF0rYVIjiEwYqGfzk=;
        b=I3IrP8vjo0aYe174D06w/bUqzjhV/hmJlYnGBmHdQZSJFYoFt3N8OmXqB70CmAdbG7
         F0WAPfG+QfuL4FSyCO3yXoQ41UamlHOFTs4XFpQ2+Y3dFldkF0JCynT9/fMmrpva8gME
         Y7W91bJIiX/cmzV1VNvO0FbP04UrzBfqqcnMPUs1VmGLCS0qyVe1sfGG8aLvLSOgAC9p
         5V53/DfkmxzjnSJdY1zYt7Jaw/3yo3sKQv9f8ok32LKZE5E51+g6/To6WlF2GzhcIhFm
         QaZyZvwu4LbbtRNqiNPs33Thz+uezzsvhZ26qOVdNtoeNfkf1OGNXBsL+T/syTjDilPM
         QdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816854; x=1795421654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hykglC9qjGoSXJNJVYRVj2488doF0rYVIjiEwYqGfzk=;
        b=iz/sg6ujKfGEviy4BcMpnktfMiysSsmqmZQiPllK8QFLFXHmBOthgcelrsUdYbDxkx
         ZVoKrg1NQDG1vxkzmtj5DFUpcyQP/mRl7UTHD6YwhMATkQB4Hcx2+cWGQvPRg9iac+Ec
         8d2N+K9+E7O8wxO3hga9eTDMmEIqQyOqh4SN+o77dY2vAWhQO6OURSj7naw6YVkRY7Zo
         8jlQ/wGb/VUzuyVLnWLpMG8XNUeMSiTkf3EfR/eVZQn4peQfRm0Qa2fOS7Z7vRUl+hB/
         8aUuTMLafZfp29tVaFMRMXiBn/7H+6ZfqVlrQD4G5PSPF4UXQmucDvpf8G4E05deEeB+
         Psug==
X-Forwarded-Encrypted: i=1; AL+hErEaFFXKD8eCnVntnkE/hfoSKe/KfHEEteQxpXH07XFYnWcz+81xnJoPb/O2PVqqP3gxdMKRfzVYXg==@kvack.org
X-Gm-Message-State: APuU4Z+OzFZ1aVgkrxhO+1WtgNngyAIsULzvxxLZJHKSbR8Rzz59y2Xn
	PucPcYEhCURsV2qJlm7426W7skJKjbRDeRpqc+tvHAIWoe6PQUFK2kTYfmQs0KPqNTM=
X-Gm-Gg: AYBFou0KQRxaSNgFkM1LNDxHP1Tr8hintlgfl9QZCDWfqz0iybNADaif++vGJCwgCbo
	AkpuBueaxRb53hC+O+sc1+Bw0xq615kPRxOV6SgnCDC5p439ekqFcnTS72c76hsKjebvgKEuz2Z
	QYrs3V26+6s6CbWzEH7qux/5GQLNCooZcMDG+ju1HBCLqZTV/wr7yJ41pVj2lMNKFsjrp5wEnv9
	7Z9fdOmimaCpgXknF+ODnvr1AvD1XfPwpT7G4yijHbyE4Q372NjN2/e7gbNW+sq6XKmdF+lhRAk
	DA1TZL3vGRIHJWYm7PDqZu2AUQItI7+Nn8hhlCM6rv5jigSZsn1OdwFxV45GXPfjaPa79RGViA8
	T4qgQhQrNPiRwp777t1zCqZ9fsGI910rdWptfaPZzv5Kb8nob7bWCdEJAp1aACX60xqwUPU2ePT
	Xl+7StRP0hlhngHJpvz/yaOcNxfB94MJ1fGHOgGI6nzJuUcrCQA+qH935KyyQD7fvv2j1y8NXQe
	uSl2BeF2dSly5d4QJghwkwDNFrbQT0b6nr5md6Hf2RIWaPri4VdaBCvYf1zpntKMVG3OHSTpRoE
	DjRLCEpJrm3MNrHlfdSC4gXhr6UNgP1HCrAtYR6N5RzGb13f0JximYZP1ZguxtEUvUIZKX7LP/l
	4mmOXEnQvFIH61vMezLWPemsMrU2g
X-Received: by 2002:a05:600c:3487:b0:4a2:526b:d410 with SMTP id 5b1f17b1804b1-4bb55a4f1b4mr208646975e9.13.1794816854509;
        Mon, 16 Nov 2026 00:14:14 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm22902289f8f.11.2026.11.16.00.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 00:14:14 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 1/5] include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
Date: Mon, 16 Nov 2026 09:13:59 +0100
Message-ID: <20261116081403.216452-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116081403.216452-1-max.kellermann@ionos.com>
References: <20261116081403.216452-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: otx77cntpo9nij8k5gn7pd1gwcggcr3w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D6EDA40006
X-HE-Tag: 1794816855-518659
X-HE-Meta: U2FsdGVkX1/0sDqiy5PsnXwm5dMwp2LW3cdWapyJtAOdG+SVYy+Ii38Zhnnfg2lA3vpBJZLQXDbxvw7DjwTohWmQr7x0CJlrPCCPtRTHP8JbYEkUG5T8Ca1CQDEnTfD1cr5Pr/Gs8tye08sMG/NFYtvmQdH+05o36bhik5dYDEIYwJHTq2bSx6/HDRYnzjdcjsarYLV6lEegJCc6TaFX9CiRENlMrMt2UuDvJJn/09kixtRuKjHlo49+nTQ2RgC1balJ0GwGVBKeI1TYuA29bqsmcPHz0U5HCwLEs6yUjcTex/8SlHTCuHrL2HElCL6F25pWDa2/2I4ev22dIuoFcwWSISN10WD+r8KxNg5ccq1doIEeEHmh+4Y9vS2DbwoaFTW86JgjjtzN4X8eHHppMT3xQvlTkAAnAw25hZHykn2OkNFCJ3og45E3zrnh9JtxUHDLuhUr9fLwOCXKaeuXeEaPw6TrEldQOq3nBwrXgJYtykVCk0CMdti2VlhKSHehPo5qAIg7jTZg3LlwVva52fOFpMcBLZCPUgAvKgT4pMaoLbn51YEZ9A2ngpnuU/yifk9eIhxAvGpi3gwMI0iKZ8kyXToU0oFZnIS4O7QTB7baKF/JUvFC5pblnyl+8dvMgjqrA8ZKSF35C6NI4t+pVgoxY1yMlnFAmg9zfZumqS4Dk0SwDTizuQ1AV3m0oAJbog0vTKpld0CNc/MYlEXPipC0qVj+Jxgmmq4Qmlq0UeFiY06aI8TQzs38NdGSP+3eay2vEU112cjK1EaugHnpPQ7ls3GfXpHyYRZI2qUy9Hirjz/YUm2rWmNWElNqbyRVBr5jKmyRLeYErQrY9JGs+JaY830GTiH4iA9r4+yxbZyYxllDfD7Is24yPez3jDa327/PsSwDdntpFdl7oWAh+gZuWvKh2TDDKFcp6Lq3fu8m3Pd/DqKd6V2pyHevWmub5bMc1ero6KS7xg6BWkR
 WAhlG3VP
 R2fXuY+L55rfUAtgw5U0HYhoJmeupQ2pGQthFRjcIlQ6NzOlgdkr0htJgh7Q6Otsnfnq99vEWXvz+nbeHGWOViCffF9g+tp5EDdvDPu636qfqw9oyCot1X+LQfQrJL2crLcLFEBv5EcYd8W78toe68AEa0qfD5ELYP8eiYP54aLVVP0KRA1l5haESfZmunn0GE3Pi5KLy9dVXQJgoPSSzig0E7CgpxcoNuL0ceww83RQ6St1A8LIsofPZU3f8+Le29CE5J7dil7K3nD3hKhVPusnxubRHRbbSbdzm85+D7ukMP3dZzyuL6cSNDHY+YUo0LJP7dMwYPGJrAN8MZXfZ8ryHmKkc5Qi7utNjQGqCERn/JHGDjLxvoK2BCqZDYUzzpsQE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move some code from hlist_nulls_add_tail_rcu() to the new function
hlist_nulls_add_behind_rcu() for callers that already know the last
node of an `hlist_nulls` list, to allow constant-time appends.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/rculist_nulls.h | 36 +++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index a97c3bcb1656..ffbf5ed4ff19 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -115,6 +115,33 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 		WRITE_ONCE(first->pprev, &n->next);
 }
 
+/**
+ * hlist_nulls_add_behind_last_rcu - append after the last list entry
+ * @n: the new element to add to the hash list.
+ * @last: the last element in the list.
+ *
+ * Adds the specified element after @last while permitting racing RCU
+ * traversals.  @last must be the last list entry, with its next
+ * pointer holding the terminating nulls marker.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_nulls_add_head_rcu()
+ * or hlist_nulls_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_nulls_add_behind_last_rcu(struct hlist_nulls_node *n,
+						   struct hlist_nulls_node *last)
+{
+	WRITE_ONCE(n->next, last->next);
+	WRITE_ONCE(n->pprev, &last->next);
+	rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
+}
+
 /**
  * hlist_nulls_add_tail_rcu
  * @n: the element to add to the hash list.
@@ -143,13 +170,10 @@ static inline void hlist_nulls_add_tail_rcu(struct hlist_nulls_node *n,
 	for (i = h->first; !is_a_nulls(i); i = i->next)
 		last = i;
 
-	if (last) {
-		WRITE_ONCE(n->next, last->next);
-		WRITE_ONCE(n->pprev, &last->next);
-		rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
-	} else {
+	if (last)
+		hlist_nulls_add_behind_last_rcu(n, last);
+	else
 		hlist_nulls_add_head_rcu(n, h);
-	}
 }
 
 /* after that hlist_nulls_del will work */
-- 
2.53.0


