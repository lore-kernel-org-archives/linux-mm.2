Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89EE7C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA706B00A2; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273D36B00A3; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B7F6B00A4; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD2CA6B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D4051C056E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:58 +0000 (UTC)
X-FDA: 85036864836.12.C4FAB3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DEB2B80006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MMlE1Tsi;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211976;
	b=yJkcJN8RLA236vqOWZUReD+cQTRSz8QOlWrFQJ8TS1EfsNDVPe4kryjuLR89g+AAySuZf/
	+PknorXU229pRGzhu52XOf8nh/J3W1ECwNTOvz1GiDoaLvDUWCScHEo3JG3Gbry0bvVygG
	ebOqLbHg19unl0ozE6qbNRK4mLhVTWc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MMlE1Tsi;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5V8MjQrwRuDjd8BtOPEo73pYkdzDFHDiZ1CxZWMyKg=;
	b=IvMdOMrMXM5i0KFrQjqq8tRIrchArTpvUmrEONUdKFE9BXXUiNNWkjd7mNrD1Z12Kbi13j
	RgHj/6jE+u5JFcPKa8nA4owxkaHHGtsvJoSbCz5XIutVEPP1rKs+bOtaWMejIkYJY6U0Wh
	xgM97dsqWAPPXiNL3+/B0IuKGZbCrls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8018160A75;
	Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099361F000E9;
	Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211976;
	bh=T5V8MjQrwRuDjd8BtOPEo73pYkdzDFHDiZ1CxZWMyKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMlE1TsiVFs3PvMr4gCgcOJWrIA9UUOf7HMF/b4Mk6yEXreOkh7n1/Rw7VhpccWQj
	 KBN3ddQa4fQ176XoVxggxlqRC6IQmG281F8Ulg0vBL+gCKu3B5CXcAMi+AL3Iezo4U
	 MJJx4AGXsI7kkRJ5PK/ytG8JRhx0VT1JbomuT/YsAD+mTy+qWgAVenh9FPFZBR86IG
	 W/1e9AS1osWwDnrc2cb8jZJarkdCAxfd2wU/bUGPr7nOSXqbpJicd/oAMymsiNJ03l
	 fzRr5fM5gGXFV1ERz0avaoKO+lcKRBlTUH/DrJ0yvYOz8bRt/5G4BCu4tBfHaD/QIy
	 6U5TkzfC3j9cA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 12/17] mm/damon/sysfs: implement prep_action file
Date: Mon, 27 Jul 2026 21:12:33 -0700
Message-ID: <20260728041242.187380-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ozg8ig6t6hzknrpi96d846gi6d349wt
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DEB2B80006
X-Rspam-User: 
X-HE-Tag: 1785211976-313009
X-HE-Meta: U2FsdGVkX19WtrLgqK3EwwU2R6m+GeM+2JSDEs/T6DQuhi6V82II8kkAzZoiCJMEvCJ+cshpc5NsG4tXEtV80wgzAX0x0gNK/+YNbcoVktfiRKEMcvOjmfwwvDPB3ZOtL8V4lK3JIDCeUqnuCwLujCZVZt6xzXMqBFiu8oVsvPJTxlqXXCp2oZeY7eU8/VvS1Se4wkn+WOEbZkMJhawcc63AcKpqASFoYKHVk0Vg5xUCDAEImUw1kgAqBk1KXGQB4HFEFU2SRkRJ5KqceBWFlyMyT7bsmnJOpIHdbZjxBrbKf5FrfFUZJ9QS8SGdFeEjERyHpfjSBq97x4orctoEg7W5XBX1NwQr1psodTKvR7bqHJoot4egdgjvd0edjLM+nsWHh6ljIkdo7w9/BlaYMXkgfKZYaVxm8dDtK1odr6mBXqqmSEQ7u6m7kuoxWUwajjD5i+p2zAf9ExYtMLaP4UNluTD6qAXi/mj104IXufJAz4HWnu3PPla9vZ6N1zpo881wc3bjimvIkuir+k8utdFZjVzSqED8LZ+B8+iKq6mz5AkdE8Tx7FD1/+CmIwCIjzQS3kS0EGo3Nd4c87ltb+/uKFWBykJTSUBrLQOAGtBH30nr8Z5uzkt8j8DT2Ih8+HRexNBDO7zd8qR3d91imAnM6fY1v1R9XWtAe1FcEPpchgFSKyNt5ImSsPUDYseYxgOiMR6Pw5AG4F2/S3WwcZZ1gB+fI2Ks23rzOD7lG8nLq2egF6E+hOOBY3Ggj44969wVgUa9SlKGGG/3WWCRprdualx/U2H77H6dxftUob9JalG8H722KYvB5RaaQ3jjI9PxQStLRCKdFSV5QbWTFp9+NxSWSvHQOHRcCpdVkIozjVr2K4Sd/RLhBJMfQPhJpJoyFf4uSM1eXQZPFx+H8nfEost5Jl/gdpxs/2BQDccmn1pC1+UJZheHlMiUMM4LJHRjKmTfXw+aFCTuC+v
 yn6KouiF
 fk1kZQUxMLTZiYiI19cywdSpd+TlekHAVlZECJ39TUawT6Ory6731nmZ40phjkyh/Y/vaRCD/mPfzh2vJhlf6JlIlS9hTAmj3cs3lItS62ruVLgxlYHgE6+6FP2EAC51zJO+FS2XA48mK0RcsE+TaexP9neeqVg+AyY285OYiJ442okzW6KaOYFyCMcugVPW501ARhAA2GDpPHX4bejo5s/N1NzOhcWoH8c4gcwtHg6H3NOQ0S6RsMgI+CnWiJ2JBDCX297EZHjaDXAaoOOK1wVW/2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a file named prep_action under the prep directory.  It represents
the corresponding probe preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index afd39659d6b84..c0130843223d7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_prep {
 	struct kobject kobj;
+	enum damon_prep_action action;
 };
 
 static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
@@ -765,9 +766,61 @@ static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
 	prep = kzalloc_obj(struct damon_sysfs_prep);
 	if (!prep)
 		return prep;
+	prep->action = DAMON_PREP_SET_PGIDLE;
 	return prep;
 }
 
+struct damon_sysfs_prep_action_name {
+	const enum damon_prep_action action;
+	const char *name;
+};
+
+static const struct damon_sysfs_prep_action_name
+damon_sysfs_prep_action_names[] = {
+	{
+		.action = DAMON_PREP_SET_PGIDLE,
+		.name = "set_pgidle",
+	},
+};
+
+static ssize_t prep_action_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (action_name->action == prep->action)
+			return sysfs_emit(buf, "%s\n", action_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t prep_action_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (sysfs_streq(buf, action_name->name)) {
+			prep->action = action_name->action;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
 static void damon_sysfs_prep_release(struct kobject *kobj)
 {
 	struct damon_sysfs_prep *prep = container_of(kobj,
@@ -776,7 +829,11 @@ static void damon_sysfs_prep_release(struct kobject *kobj)
 	kfree(prep);
 }
 
+static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
+		__ATTR_RW_MODE(prep_action, 0600);
+
 static struct attribute *damon_sysfs_prep_attrs[] = {
+	&damon_sysfs_prep_prep_action_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_prep);
-- 
2.47.3

