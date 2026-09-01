Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A17BC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F756B00F2; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496AF6B00EF; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226A36B00F3; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE47A6B00EE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A5E51402C0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
X-FDA: 85163927142.15.00F2576
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C44D40002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RINtRsVd;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4M/9i3il9+uoX/0hvXXuMXtTWxZNwDv4ttKnUbtHPw=;
	b=HYJLxdASDpXtj0DVKfg4r8BdiVV2o9mkSmEgzzmrVpvp24kg72+zwnGz7BhyZyHPsY9ngc
	GfPadEV+VWqMt1Q/70IuSXpW3QfrWSKJEJ34JC44ag/nw4AUXVS2ES+SymFhM3xBQJOCkI
	kq72UXnIVA/HhFEBoMuT/hgYnNfgr9I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237269;
	b=qbClsJCcwgNSDszdQva51HhU0GwLiErlZsZB+0QLIks33h/HvJ9YXiGGNWZSoRaR4iDKMN
	zcYCOUmXr8HHCWmNw/u2PdNYDewVCp4AaPRC5QZtnbFX6qdSop9g7ZiCYQ93sX/jhliIow
	JwQE82T/Lm12Ir0zgGGUkNliPjIjPlQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RINtRsVd;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9E7040143;
	Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AAD1F00ADB;
	Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237268;
	bh=x4M/9i3il9+uoX/0hvXXuMXtTWxZNwDv4ttKnUbtHPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RINtRsVd9/foAQbOaBX56tC049v1kog7NgWy4abZ57p/Cz6znuQU9abXl/832moQa
	 zzi2wkXW8FdmHqtfEIg9QwbEvdRYvT1hikUJ+3klq4/koLO8CymNPi8Fb11scqQIUI
	 ffWBwrEFpGYnlWj59twjW3zAXjtCI2sG0HY8cha/S0wZS3yaiQ5v7d+27PfJOnsp1y
	 LAjK8kPYubg2vVOsgPTgeQx/rM5IZuSsNOc0mAN4oyuN1/k4ymAk945Ic3ZXf45PP8
	 PYjDmE3CuRHnExPOT0nGSLr9XVIP/OQtizTOoEY6dmrMZhvB72tSRh3kPu/VFgemRJ
	 rP8m9TB3mL63Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/17] mm/damon/sysfs: implement preps directory
Date: Mon, 31 Aug 2026 21:34:05 -0700
Message-ID: <20260901043417.2165-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: adpk6gtj7atkukdhoowickpd7pjxdhag
X-Rspamd-Queue-Id: 7C44D40002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788237269-804050
X-HE-Meta: U2FsdGVkX19nSLudiC6bebl2LUI+di52WdkWkNNjRxeFPfv+BXhjpwh49h80U4toiPzm5NgVy4TSxgs3UDZdpI398+GPCVkgOq39tCY9NiTiHz64aD8nVXBcSp4VaMZc9u4oLlZgaeqqHDyeRSYVpea56VaqlFlxb+8k3ZT+0i5ZxyQmpRgnrdpaLF4TqhXIywlP/sf4pd5PREWKQpM80KKCet7BAKjWLDWOgTtx2z4f82nuzgeysuMWmfX7doSt5hjPfTCV0M6ysKFlpXJkkZWvCSuzH9wN52Pgdn2y5yg9otE8RhgpaDIOzMyB3L1UG7wLWYsgJnCMPQs3JqDOnpMuUazk6l4olMpkltQbzZs4l/lGwl7CiFppty7QvmJV7pSYepNJZVdfjqPWkbeL/IpwRKM5ZSxBBOgUYONmZ+PSzE+y6tx9aW5lR1bYzR/OPjyaMYUEr1clkYvZxetyTonRcTzQh7G2P44sWqCOL7G4YpZ1SL1EOBqxHlo6AhKfdHI2D22burSmiqZX4P5ZWmBHGCYnczjYU2ECRc8by2WL2FAys1PcfgSKzeXH4gU1UjkC6YUBS+mDCckyE9rq6myfRBPdlMhJ+9StRJIgjCgn0inJyRTqhMEX6ec9ztumrDK2gJEXbapdyj6M/wTsX1wF7Jdn5bSmMXGqyvpZYo18aSCF6E08hgaP0Pm5tl2NXcO5RnddhgKwRBoe6BODpaafbvpQ55i3xQvQaCwwhl7bQInRPhcMdT8Jwb6oArXxshPPOBAJVlPFkJwupNz6eJaHNy0KtI15pknaPRcDKJBriMOwpOU/aaH4MUiRHwLVIcaPviUTGXwpKu1lK9QlrkNdDaxY+bvdoi2NLwj89G2oBHX1jFBK+/w7ShwWpnDz1DI1W4T0tV3m0F9mEQXS/7raVXASvDbUTxed1VkWMxgwjwnTVQKoTt9BpUMouZr5Slmf+1sHiexx2uLUdpV
 rBIEE3gE
 U5YyHj4vfZyHfppj6elVOMagE0JLuMd7yRLU3GxkSGR42aYrOlv51AVpkOJnL7Y1eRC2qJ4IjmRAJkNZrDpn+f5zt8U0a9IOPKhnSfhQOdHrvxAmfJP7G4gMNDhw2lyxi32EZNrlWvW7yhbi13tuiQzxIrMYEYkQPDem96oOEw+HjNf5MUJ7ejW01BkJNLI9rI1liuS0OYMHsPKXrBacfT4TubmpDfmhVkmuahsiHl7LnFpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory named 'preps' under the probe directory.  It
will be evolved to be used for specifying probe preps.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 65 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3593bf9c7b7aa..09641257d3a89 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,6 +749,35 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * preps directory
+ */
+
+struct damon_sysfs_preps {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_preps);
+}
+
+static void damon_sysfs_preps_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
+}
+
+static struct attribute *damon_sysfs_preps_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_preps);
+
+static const struct kobj_type damon_sysfs_preps_ktype = {
+	.release = damon_sysfs_preps_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_preps_groups,
+};
+
 /*
  * filter directory
  */
@@ -1069,6 +1098,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 struct damon_sysfs_probe {
 	struct kobject kobj;
 	unsigned int weight;
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1079,25 +1109,48 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 
 static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 	int err;
 
-	filters = damon_sysfs_filters_alloc();
-	if (!filters)
+	preps = damon_sysfs_preps_alloc();
+	if (!preps)
 		return -ENOMEM;
+	probe->preps = preps;
+
+	err = kobject_init_and_add(&preps->kobj, &damon_sysfs_preps_ktype,
+			&probe->kobj, "preps");
+	if (err)
+		goto put_preps_out;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters) {
+		err = -ENOMEM;
+		goto del_preps_out;
+	}
 	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
 			&probe->kobj, "filters");
-	if (err) {
-		kobject_put(&filters->kobj);
-		probe->filters = NULL;
-	}
+	if (err)
+		goto put_filters_out;
+	return err;
+
+put_filters_out:
+	kobject_put(&filters->kobj);
+	probe->filters = NULL;
+del_preps_out:
+	kobject_del(&preps->kobj);
+put_preps_out:
+	kobject_put(&preps->kobj);
+	probe->preps = NULL;
 	return err;
 }
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
+	if (probe->preps)
+		kobject_put(&probe->preps->kobj);
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

