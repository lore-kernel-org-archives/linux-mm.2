Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990BAD3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0446B002D; Mon,  8 Dec 2025 01:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8696C6B002E; Mon,  8 Dec 2025 01:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5F56B002F; Mon,  8 Dec 2025 01:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66E986B002D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3425B8B147
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:23 +0000 (UTC)
X-FDA: 84195329526.24.940DC27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8790840004
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VmWOxnCr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175421; a=rsa-sha256;
	cv=none;
	b=Jntj7vh6O+skbQVo7B4SBq+4OYloKVeQISYmjb8huQQSdVNN/hAyVPu0VbftgpdDI8RUuM
	GANku6aLzHIh7+jdv0yc1p7a+oBabn4ryYxs0nuZdnX1ErmfWvQCjF8zFFEfuismAxZLwC
	icbFa0BZB3C3CAIqv3McAtPc/YHY01M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VmWOxnCr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=argtDeKBIVOCKsTnjfLYRVsIQxg2HWbgDGAORRI244g=;
	b=aB96QPiRhZJrc26k6vURfJO5ER89JOJwpKd2cDOENgBe2lgwTz2EBM4LmsHGwmS4QUb6VN
	XAgc1MbGsKG1YFKP+T2cpjIsQkI/b47fg9Qjl5SLbyZyUUsrQQSi/FUmbUd5EUUKQoOjvF
	7nA5IQL3BwPGLAniVd8vCeD0GZsdBYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94F7B40571;
	Mon,  8 Dec 2025 06:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79218C4CEF1;
	Mon,  8 Dec 2025 06:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175420;
	bh=XR7TB9uLErl/OwhdiQ9KeniuUlLpDcU/pwQSdNEDmO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmWOxnCrqPZaZ0CQ3C+sAg9ZamAn3Pm5iZ8i2KGLyn4XeXa68XpbbzfhW3bCM8mMJ
	 Ug4LgYGuooQouVyQ1sGTUaX4wjszQi0q9r9w4UjIKuVBcx994Al7dov0KBTeUwnLl4
	 LxIvF60thKzawCoVYOQvmoFycP9F6E74Zp2JBE7jF+v4CiFm8L0p/DKgH38Z3/2AHp
	 fu1hJFMw+ziHHa2n9/vG/Eg+fQhRUQQrTma6+YK7lPntuRFeW/kyFxldT6aAhBH1cG
	 e7Lb6m9G1PkcJgi8VGQuviQhGUvSUyMzgtN2zrPF9ZRrDVPes/GnZ5c0FjCqR26mD8
	 xgJjjcw2rE9Pw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 21/37] mm/damon/sysfs: implement type, matching, allow files under sample filter dir
Date: Sun,  7 Dec 2025 22:29:25 -0800
Message-ID: <20251208062943.68824-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8790840004
X-Stat-Signature: m3robxr51ndthdbkdw3qu6x4zni83t8j
X-Rspam-User: 
X-HE-Tag: 1765175421-990875
X-HE-Meta: U2FsdGVkX1/AzW7oK8a/gEtIVgI4zsxhrlxfxKiJmm+rbDellF6rJ/FiI++g72hguARvESFRJaOLqOwonfZcVWTN2MMVj84T+DHivs+jdEAE0V5h71rW0hWuAvy+VtcY89/Z7URJsCM/FMq10eu+h4olqJie9YSOdQKj5yc+Yo0RPUfk4so13Czoz1HX6sI9JZjnV2pb5lmGb/W8O5IYFF4GcjGceLAXD5drRK/lQaodji1rgpSJP3GwrZ8tQsZhIaHu8BIDbdReMvWnW0JUGlsOGAIUwzWW6k8adfkRpcnZFpoqGljnB2KXx6H8h9iAnxgTyc3SA6Q432nEult4QRcZW76uzQ02AU632CfoWgvMjjQ5+KsGfFBJ3sya/apGlzzzR7if1AoMsrqGhLbtUxEu6oyGhznUJZJzLoAUgZctvGB7A9/BIhhMfHxWig6pZ2bx2gvxeAD3qTO9TwMfTHmk2VaZA9cg7fccMiTBLHDk2YyYuQvxjgtjA759YpCqlnRenBEhwr88JmEHaGonMk8lPqkSgfIlt0q0HdKxmEv+kOvwRGzsHDFLFvPJha90qhqmhyXlQjXx2UCujuE8LebIdHHNvL/aKDvVM5bSwWxtPfSomO2s8JJuTnnuriEVoymFN6adL69IAuElyg7OsonnyE5I9OTdLDCheqPBtj6elXUZ0bFcgGQNwSk9VSskpYhbUEn9qeMBSUtEzeINizWIkELqI/HY6F8PjnXhqBOp6OVm2vuunaqN3kyejishgMPdpI2ktuP4EoCjPPfL7LCMea3JytBXIVybL71oQo/8quA6LGmCDjDgc6Ew+uE/sLXUKhSd3DIoaJKQPpj+XJn5qQ6N4WVs3Y8miJVR6kXo4d9DMiHeqq6A+j48sCg/XpsOAi7SqJfkAdPA2pmHB07JNaqzor5Ml0Jzk2tP3fxuzOJqPJCm/UrpPsZ/WAuW3lgRaXnfpUcYL74oB6S
 Dt+WHVk4
 vz9PEKK3/23FPx2t8npskKHzbrlCPxoLbIjOMik7qAmW5rSn4bDAK4DwK2vxATApMy++3gNUtCP3Ns1TZZtVULE5pGP20u8OPDgOgwRVa5BA/+pgyf17ilbIHKNqsuLow9U1soaYSenAsckXL4Kqv8+WXhosBw5HmBjrhTon9PJICQpv/fkZ10ylxqZUkN+DrRR2vwZuJLT5pNbaIO/LBHAG818OpRE3SJesWFDidByM8zBA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sample filter directory is not really having the file to set up for
the properties of the representing DAMON sample filter.  Implement files
for setting the properties.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ba0c76c1300c..74594e6e461c 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -755,6 +755,9 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_sample_filter {
 	struct kobject kobj;
+	enum damon_sample_filter_type type;
+	bool matching;
+	bool allow;
 };
 
 static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
@@ -762,6 +765,92 @@ static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
 	return kzalloc(sizeof(struct damon_sysfs_sample_filter), GFP_KERNEL);
 }
 
+static ssize_t type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+	int i = 0;
+
+	for (; i < ARRAY_SIZE(damon_sysfs_sample_filter_type_names); i++) {
+		const struct damon_sysfs_sample_filter_type_name *type_name;
+
+		type_name = &damon_sysfs_sample_filter_type_names[i];
+		if (type_name->type == filter->type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+	ssize_t ret = -EINVAL;
+	int i = 0;
+
+	for (; i < ARRAY_SIZE(damon_sysfs_sample_filter_type_names); i++) {
+		const struct damon_sysfs_sample_filter_type_name *type_name;
+
+		type_name = &damon_sysfs_sample_filter_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			filter->type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static ssize_t matching_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->matching ? 'Y' : 'N');
+}
+
+static ssize_t matching_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+	bool matching;
+	int err = kstrtobool(buf, &matching);
+
+	if (err)
+		return err;
+
+	filter->matching = matching;
+	return count;
+}
+
+static ssize_t allow_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->allow ? 'Y' : 'N');
+}
+
+static ssize_t allow_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_sample_filter *filter = container_of(kobj,
+			struct damon_sysfs_sample_filter, kobj);
+	bool allow;
+	int err = kstrtobool(buf, &allow);
+
+	if (err)
+		return err;
+
+	filter->allow = allow;
+	return count;
+}
+
 static void damon_sysfs_sample_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_sample_filter *filter = container_of(kobj,
@@ -770,7 +859,19 @@ static void damon_sysfs_sample_filter_release(struct kobject *kobj)
 	kfree(filter);
 }
 
+static struct kobj_attribute damon_sysfs_sample_filter_type_attr =
+		__ATTR_RW_MODE(type, 0600);
+
+static struct kobj_attribute damon_sysfs_sample_filter_matching_attr =
+		__ATTR_RW_MODE(matching, 0600);
+
+static struct kobj_attribute damon_sysfs_sample_filter_allow_attr =
+		__ATTR_RW_MODE(allow, 0600);
+
 static struct attribute *damon_sysfs_sample_filter_attrs[] = {
+	&damon_sysfs_sample_filter_type_attr.attr,
+	&damon_sysfs_sample_filter_matching_attr.attr,
+	&damon_sysfs_sample_filter_allow_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_sample_filter);
-- 
2.47.3

