Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39490FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73066B008C; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE2D6B0096; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C7E6B0093; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F57A6B0092
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D5DF14058B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
X-FDA: 84701905596.12.280D034
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9241FC0008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4ybWyt1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236756; a=rsa-sha256;
	cv=none;
	b=orvs0BbSMcXGZR9ImD908hRwwAHeuYM+vwsaRMD9jbn4fHEUf3FgWsJ8U5fKgxFEsU4oM9
	0R+tE6++UzpSoUBe6mcVXE0JMmsG0W4X/wTuNI0TpsF2VKFsplCZrjeP/Sli3mSy4MFsbd
	pY0QclkvpKsAvidAnABBFbDZ6Sir9tw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4ybWyt1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aj4qsqAQpwxBHM0vwDDJPjl1lnZ2EvHd6O9Vk99hePw=;
	b=CrPRHEcGNXzPn+97IVIduiMdwKemg8oqGNoku6g0tJ3uubEpRi7UAPRowgKVnpZNt18V04
	ZqYULMk9sBdzaYcoJaHD0Cxlmi15XrC9/x5yM5XCP5iYd/ZG8v0PX/gVBL85FeVu6BLZum
	HfNUwxeJ+5oUAWVcIn5GM2btq7Fx7JQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E544760580;
	Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9E8C2BCB4;
	Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236755;
	bh=ssUx+oZtCnXAftQFdGVKJ2duGR6qwdo9mJW3FrliT4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4ybWyt1ndP5z/2On8DxGztXhJNX5X+YtMrrJCoV2D4wzTwKcgbCmbHnDx6tHubF6
	 uviyhSgXNMgpPEcU37xIktpHGf3dwx2oR/QyVDZ2MAH1K183q5RLhDKRFyP/b2NAgF
	 7enksJBYZa6xHYFvU1AI3nUJ+bQ0nqqKqFT6DpRScAoqdBtzMWySbxWJ4txqFwLTdO
	 3GT0ZWG7VTao4tyPEnIvMHng5vPlAFYZYY3wKI34tYfiK7ZEZeO1575hK5DpGTcMpx
	 MmYSC+iwrmE2RFYcB+IZl66VFLU6CfxJz/7EIvE+4NdaPM1HXfg5KlSpzCju8REm1V
	 J3s3GgfW0fPAA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/19] mm/damon/core: introduce damon_filter
Date: Sun, 26 Apr 2026 13:52:04 -0700
Message-ID: <20260426205222.93895-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s9wppcy3wx3aoax6sx716a9go7m8ejey
X-Rspam-User: 
X-Rspamd-Queue-Id: 9241FC0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777236756-758893
X-HE-Meta: U2FsdGVkX1+Lc+zTXLk9nYcxItdO5bVhZt0l05QMUhrCCTn1ngv7vUF8mVxoTfb6ehgn2Rh7sxzzKi1BeSslmvaoFfl/PTvfXoNVXoIBtdbLnNRjUADKd9Ft6UGREq0nOqJeMawyc7g5Ks3Ma1LgO4/IKoFZ8JqR4lqVwMIepG/Be1+i3jlu4gR08Z7KIva9GF1QHVmB4mCfmZXiTRdxWTjeedvbZvc2PNDj2srrZM1FbiGleQYUfmJ6nvE6SIYtVy94b3OjRnXfjIoz3m86cyfP3go/PfopVQlfAyk5SjqtUqrknoo950CgRtLNPLA34HYgJdaKwdJDP9tT+aZ7G5qd1rmpYBc/XQUsxVDF6CYhI4S9RiKTSv/euc6hzCmzgDUPjGl7PF3NEYJULjAYgPXmxMI6RmM4zMKp2cIR7wRMsics7KjVhlRJinvBiMRBaeiaMykbmlPKUkVl+163qorst2G7c+sQ+ULS3vHGzNBkKRtukUe6pSo0Eq4QIsyUVDUOl35n3Th4YmqejYi3X5VFZJG/SQPwD5xnW954aqoJpaixVi3UEv2YZiZNn4/NHnyykLbWmMpFgDNzFL4FGVT4URF1A2Cos3r7NJngDJVEc3sj9P+QS903Ql8OlBkrKqc1ECGf9evVBtuf6g8LF7sgwrpS8woBNK82V2s8zktZsE4bnwu1b6Hkm209VC2M+0HS9EcThwr0V0WkN89qEJiIhwB8rLazghWPW0k8qqy+zuK39JZhd3VsyvCsBPr7p3YhOtfDmk60ky4fVqET419dwRXZA8VGPXJHa3Dw2uXdHfrNP3K27YPBQCHH+BaKFMk3MQD27vlWvBnopt6vkdmBTM88QouvEB+b1pXSW9iZfCGtZIetfgstCO4Y2EgLEyhzkccwOYRZdntToLqEtfGotPIvEs1vfUqAUInOKgjiVWcvQKSWXgmiMYmUam67iI3g1glsI5X07qwvubG
 n6ZaCsYD
 IIoG3RCKaJO2dWb7SUgSryz/wr80aCs5U13Xjj+OBkf9b50o5FYulT5AuLY9LkwC7vezm+LlgEJFoAnj1HMAbNYRyGmqzAqVkxxTx65Em8/tLkb4/j+RG1zWab3Np9C8YtgRXO4g4lcvLN9lx8H7JBsj09hfdz4Vi06AOgAu5MwuHujdGso1DaitPOlj3oeV3R4hB2gnwWrQTdrfBfLLpIijbHRpdtM15HP4JNNdL184f9klIdgKc0MGIqlOt2quSNc55MLzVTNK9MMKWtXPwa9t9cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define a data structure for constructing damon_probe's attributes check,
namely damon_filter.  It is very similar to damos_filter but works only
for monitoring purposes.  Also embed that into damon_probe, implement
essential handling of the link, with fundamental helpers.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/damon/core.c       | 30 ++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 65d7ee0a70ac0..3290792eab547 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -732,12 +732,38 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * enum damon_filter_type - Type of &struct damon_filter
+ *
+ * @DAMON_TEST_TYPE_ANON:	Anonymous pages.
+ */
+enum damon_filter_type {
+	DAMON_TEST_TYPE_ANON,
+};
+
+/**
+ * struct damon_filter - DAMON region filter for &struct damon_probe.
+ *
+ * @type:	Type of the region.
+ * @matcing:	Whether this filter is for the type-matching ones.
+ * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @list:	Siblings list.
+ */
+struct damon_filter {
+	enum damon_filter_type type;
+	bool matching;
+	bool allow;
+	struct list_head list;
+};
+
 /**
  * struct damon_probe - Data region attribute probe.
  *
+ * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	struct list_head filters;
 	struct list_head list;
 };
 
@@ -893,6 +919,12 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_filter(f, p) \
+	list_for_each_entry(f, &p->filters, list)
+
+#define damon_for_each_filter_safe(f, next, p) \
+	list_for_each_entry_safe(f, next, &p->filters, list)
+
 #define damon_for_each_probe(p, ctx) \
 	list_for_each_entry(p, &ctx->probes, list)
 
@@ -940,6 +972,10 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow);
+void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 861ab977d1edf..170abba8fdf2a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -109,6 +109,31 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow)
+{
+	struct damon_filter *filter;
+
+	filter = kmalloc_obj(*filter);
+	if (!filter)
+		return NULL;
+	filter->type = type;
+	filter->matching = matching;
+	filter->allow = allow;
+	INIT_LIST_HEAD(&filter->list);
+	return filter;
+}
+
+void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
+{
+	list_add_tail(&f->list, &p->filters);
+}
+
+static void damon_free_filter(struct damon_filter *f)
+{
+	kfree(f);
+}
+
 struct damon_probe *damon_new_probe(void)
 {
 	struct damon_probe *p;
@@ -116,6 +141,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
 }
@@ -132,6 +158,10 @@ static void damon_del_probe(struct damon_probe *p)
 
 static void damon_free_probe(struct damon_probe *p)
 {
+	struct damon_filter *f, *next;
+
+	damon_for_each_filter_safe(f, next, p)
+		damon_free_filter(f);
 	kfree(p);
 }
 
-- 
2.47.3

