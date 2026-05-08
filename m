Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75784CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1C2C6B016D; Fri,  8 May 2026 11:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3016B016F; Fri,  8 May 2026 11:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2C56B0170; Fri,  8 May 2026 11:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACCA56B016D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:01:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EF801C007A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:18 +0000 (UTC)
X-FDA: 84744565836.28.142C06B
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55F7B120003
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8lslcEP;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778252476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQGcz1ZaEzbqgScDrowVXARi09LONkb6J25l1BcDqBA=;
	b=uqNQbx19FNvSR/iPjrZnKQZSeU75jtNNr9rQjyc/FdDsGXjYtMPctRejd18V0BsL8dNaen
	g5nwfiLaMMt7Npr1DSpZ5GYZttWoE9EC49tmRyzLR1JATvLAPk8t3y87oXmtSGjy39ffxa
	PaE3JJCa90PZzMFE55XdAp5xMC49lsE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8lslcEP;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778252476; a=rsa-sha256;
	cv=none;
	b=TKciabNFvoyHQV2aQLflNWd4aNfiLfaFeQpolxWY6gJWfZ+kU23vfopCyVtxOVCUfrW8Wo
	jBlnwFzi+XG0X+divhvPe/xlXTYYv+n0mn04RuyUsf8KKW00ez/mjW95tkmTftTW5Eurds
	NbbuvOH8tOPwabSMDQtWBnglII+Iz1I=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-83659d38e38so989766b3a.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 08:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778252475; x=1778857275; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQGcz1ZaEzbqgScDrowVXARi09LONkb6J25l1BcDqBA=;
        b=Y8lslcEPdPhN+G3UllFuOx2qu9rV4DZhKnAoeHJ8fKo2LpJFqJkyE5gaWTSIeBw2uk
         G1x9y0AEvJyGjiFh2t8Fq/7kCpVVmQwpUnP2udVBowBTKiI1/VXry7n4I/JwOhjDtMqc
         xq2NMhY77EckT4OXv3fFKZf5AWAZEIZQBKBCTlPmOwHLInSwOt6niun4AhHtkGyI0Jip
         EBBUFbthltgGknVT5ct5zuOkFXvIbVLg+w9TlnhCK03nf7PjvRV1w6T+1Avc89aMwT4k
         QsQ78YJgX3SwPKfrQHN5Y1C9pGdQptOjLCtoiOcImfe1JI8akJsgGJZMBydcZZv4t/Gh
         h0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778252475; x=1778857275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZQGcz1ZaEzbqgScDrowVXARi09LONkb6J25l1BcDqBA=;
        b=K/cUGsTCqow5cTbVXZWumkh+CzCuHmn/+t5gGyDRZkXQRK/3JxKrjVMsvHbOmJaf0a
         CSk/+X36+auAu6ecYOqmeDVmxc1J8ufapvqFAa64ZmAtCQCWETpKbdtOIsESvnFQRhl/
         EgOn43Ejdm+Pndq1IpQJl5ujaXXPS0Om8gzZESX3BCuVci+KSJ6tl8KBYopEMIorv8/H
         sN0nD9GnMxmRqCzh1+ii5gPncqaJzY2JrcvxJIb7wOdXXMIQ/P41GtM/B/kEmN0OjkCL
         LwfpzFN63GzIbkGK0kS0eQow1nBtj6adfTrtt8EEC2Th55gBpCxzp8oeuBrvpJFbdaCW
         0YUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/77CLBgXukZwJSO+wVvgb2vugYBwXOjY0CBafRZRq/a5lx6X7ClGMEv38abGWQ/rCoq/sG7xKCSg==@kvack.org
X-Gm-Message-State: AOJu0YxzpEUzHr3kHtf/crfmlGrq3WLYP/e3ebc6PS0y+GZKqYuUkKfA
	6NHE18Qiy+2+6bvXWG3BsTPD+MP59dfF50Begj5gl2mkpR7kUoVhLRR9
X-Gm-Gg: Acq92OEJVpprEnKSpDox/F6k2D9aG8zMw2N6TYTQbtznIAS0pAU3Y6iBSbGb990gDuH
	AHFlis/+tTBMICr/RYaO3nENWJt4d+WikFE27WLnwwTXGxNFPwVQOmy8tC7ASJfbByF+qcL8y4u
	qfp685V+5Rs+LVobntjFAOHq4bZ8F8GfcB0vzFc+DZKb6QYu+97HgBm/+vZubmjWnKmo31wnJ2v
	Nc0SuNBf4W8NXTZ4RLAfTs51XVF3sXueHOZ6oUQX6B7MjEQiVg2n+sQgO7Pzl+Jm9o4hh0joj18
	EqbxXmX2k/nDBaz/rOEcnnmrCvTFV6tKZIZJO7gikTx3vy/ltMIP4dMJZsiu1BXWvp68LukK1vN
	rXwDbR2dcgt2ZiAPjbvT4C3zG8RNyFkpUWbAJZHAbEx+i/bPUXN7J70ZNbfxEjr++tnYxai3noF
	ZTJBtuRxgcUgZkD4HqCa8qDLcTSY9wUOMj/TU/KpBG87sQfIg=
X-Received: by 2002:a05:6a00:4191:b0:82f:abc8:ae0 with SMTP id d2e1a72fcca58-83a5b9dcbe5mr11724552b3a.17.1778252474804;
        Fri, 08 May 2026 08:01:14 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965945c1bsm13110064b3a.15.2026.05.08.08.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 08:01:14 -0700 (PDT)
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
Cc: tz2294@columbia.edu,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	laoar.shao@gmail.com,
	gutierrez.asier@huawei-partners.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 1/4] psi: add psi_group_flush_stats() function
Date: Fri,  8 May 2026 23:00:52 +0800
Message-ID: <20260508150055.680136-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260508150055.680136-1-vernon2gm@gmail.com>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55F7B120003
X-Stat-Signature: whqj1h6gfbutwmjbtcoi84e4te6x5cns
X-HE-Tag: 1778252476-811405
X-HE-Meta: U2FsdGVkX18TjepH6L2pcmIefzXZe3f8xqC5MN4Vfe+T1Ox9BD/opyK60RVmw2hPPCPb+1Ub+h8ynXwBDQ10XoZPWzO8S/y81AtTW7kBaeNBAyWZmtJFVJFRqH/ipDqMyihgBpJZ5lBP5/JrGOs9TaO41bbeyhJddo4j4IvXr2PRt2f5MjtyucBiJ7IVvYJ6yPlxeQ01eg9wQFoDKybeqqmd43beCIx0iXinQ+TeTx+geOznedkQMIhcZ+PYuy6qUf7mSUTsmSDQRZvevtQxE3X3E2QwJviw1+E+XfjrDWl/dLeuvaPP1K11ZMSFG5jqHfpVXWUYVzPPNWraoeK6RJXtadkV76CoWsNPoyn5RXooyHYyChHHLagFymr23R4rLgCPkpeb859pA66MsHkYfjVim5N2uv1D+nPGvK1CuY56qQu98CDlcSrWIP7HC7qKolzZ0cju/XdDNowl2ZSthmEI8wccQtm7+nw+TtffOFbkyJVXIr6WyfcgTe/XjIBsPvCRYFRXsEpnjKatERgMP/OgaSHQtHuApxc1TAjwmbkVoctmG8lPoGZ2DGFswUwDY7ckjKnv1k4ozOrsJjXB+imbTG92TKdziWmTVawuip49T5ac5ha5NzHzImhtPCrunJ2tOA08PHopsm0FnWcJOyD0IejFgQab0P53bICHgmuuOEmF7C/6vux3GORZFyQDLbMxb0BhZEqMJEKdljDlL4ysk2Jx/ZXlW+L6S6q1E/d4kyABPIYpIwCSzPp1Kr9TY7mEuIMqKv8dnTPeSOxpGG05curGMRjT3I6LEsh0i9vmQJDzMOWbAFHX+MFkrUpDNgUb0rNLiQnmBkT3z8XKPznD9qWEOKHUgFoOmYldJ3Hfg8q2A/aSxSvkTPr+XNOhNQfuy4Skq1jlAahz37c6hOeC4tTiQsobRHz66QitNPZlex1UcmgjuGDfzG282+gjEEeRJ3sJFH8tUBBaogI
 8TUXlJcR
 OCVt13FkfpN3N1uhbkBYeeNObOQBqiGQUNQ+UCXUwV9vC7PUra0nfJkK2+OaJzhpwCKEaf1ZS3GDxZeqP5Dm3YnuYS/ayV4B9GXs2XPEHyyQ76IpPLTkwRF/eKfpTTTcxdZ9zSjSoC3ZU6fEArLU5rl780SYbfBUlfjo1BoJYnYOaBDP21UflU2c82OMjvZ/F9k/EUssbKu+RpI2sbiShJPolXSdY43ljJxAKFjiC0bsfIRDfIDK09lxtKvmxEy9P4Ct2RF8TYus7LdMj7qcTFXKwlJd5HbP8ZLgxBKHmed/LUaS/R8+5LZmr+CHp0/EtqQfFpevylInmJEHwa9UyY2k6xmThYtD4ZugI8eTvNRCfr7goyaDMxlA2I9PsSsnm4f8RcHcZoHzmFbCs7zMB2l8bHtkIzMo2js4kh2N9YHqlIWDZOMSXn3wQyZN4GbOK5IQz40MwojeHKIw2YTrQiqsJlLK+Tkq/q2UQ4QTC+n7eCa4HkukmsgytmZVbQK7DNvwE
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


