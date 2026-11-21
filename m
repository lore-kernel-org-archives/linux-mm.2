Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81BEF606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieWaSR+K
Received: by kanga.kvack.org (Postfix)
	id EA5A56B05C3; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08486B05C1; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6E76B05C2; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 976E66B05BE
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F6F9405AB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
X-FDA: 85460344536.23.1A0EBE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 950611A0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieWaSR+K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294826;
	b=WoGp18alTliOzapLf1Em0Hj+aewhXNOvgWTerOaXAoz5Nd9R5Fhb+tr9TFveRUZ1GhKpLV
	A/o1JzHuCXkwPMe7eOzObjAfx88yVL/7KYTMEHwBPc1FF23kcgZaBGgjLS9pb6X26uQuIs
	XWqDS1tcdVHsF4w94MNViMGKf9CBdJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kDNeq0YIzH6aqgKl3Y8N9odneRfo3uo0UcuJ/hi1Pw=;
	b=Ooxs/LHf2A+fE0DJkn1BhLjU51A1UqGyqCXAOYITqaN+Gfiv1AUnycuD89Houof+nrqywV
	NbAjiWMVwmOb2wHqMocf/Z8L0pNwcohEj/foRTur/GoD4Z/gkqRxrXwTCN/5ijOq0X3rxJ
	pn4eU/Ez6LoY7ubn3ytjV3wF3mE0mrY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieWaSR+K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68DD761CE5;
	Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1605C1F000CA;
	Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294826;
	bh=5kDNeq0YIzH6aqgKl3Y8N9odneRfo3uo0UcuJ/hi1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieWaSR+KB+cLfLHY/BAz1IhrxOa3wh+QTKWe6Wc2SkpNv1dQLGT2DMwSniw3NFpg5
	 W5Qn5ejsIWIn9psGhsoTSylG7tOKJOk8CDiyyXUxUAuUDcFwDgaUp4Mpw1i3whUigV
	 HWmnL4O4wDE7WaucZxVRkq7Tgb2Emw7Aza1rdfRnk0j6vvhoH7mmWE6pNWs0z2vCpO
	 90EPeOjMXlteJZI2gDpQkWrfrr81TCiEjXpqzpCvGZB5tR+KOva1NIpuyfLO0SKfcu
	 vFy108Yl5eXgykWOSq6jqeNr5O6iBgBwLAEIds+45vY/xT59+5NU9iH/Yc6W1+M8XV
	 6F4oVCw2Azg3g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 15/27] mm/damon/sysfs: add filter_report_type file under probe filter directory
Date: Sat, 21 Nov 2026 12:59:59 -0800
Message-ID: <20261121210013.130397-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 950611A0008
X-Rspam-User:
X-Stat-Signature: k17s19zhg4z4zsqaywz64edt1w1om9zc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795294826-293246
X-HE-Meta: U2FsdGVkX18YuYbzdzOF7TWzfz0mBmkPUIDhFHWI+Vy3S1eIbX1hDGmvziNm6fjR1/gsbDdHOhLnYjEtl5kACOxqs05MkPxLrGQNB+usU/zdbS2A26kOEthUwgcxZDE6TjwVGQrNswkwlDTUsDirn+ZBB4KMvhV7hqu/tCIt6k+n9msS5JPQ4FjAq3KAkDXo6W7JvsuySDl2YtrrENDPQGsRtNLErxjgl697gfKciHGrx28lHIKA+aM2m+k40grYv2TulVYs89wHKa1Q4MB9Y+dAGeRlGFLHfahnhfgQPXcVQL6ZaSYrFP+S2HwtC/cLfmSdc3QxAm2v8XE/3A9arssq6rKaDhL9pNNhYrYRcUmCrNwFFqQJCyCa+qTvIrDlDA82EfVUU9FEMGJWKoxwUj4FgBbWsT//IxPCJPIlgKZ6RXAlWVG0enZdCZyhQcxeKncI8gmfsXFnEfdZb8TOjfSAxyhKXf4B+EXoO+AThNGSr/Ts6nWWW0DObNZb8JlAXnESbakuGlOdlnbqOnDKodNqrLpdZTTdj7Lo9AfzO4QiDM+7AFVFQr9dTubh9Bt/07IcyzrBfcxGeNZ728kL2TQVyJIEiVZ4jdHCp8kUykBJlRHtuWm6Gx0CPU5I8DBlXnVLChp1rx2ITQG3uKuUn2lKfrFudll7QIY6PrV0SdH1XVZYrb5PWIrpOMdUg+MdOdsy+tI4Pr5H07ALVo26YUqlingL3xT0+tUHC5SV0wXk2CqkGuO7SaUtIFnkvPESxBm8pwqeEzoQmZAYYvjSP+OErAo3tH1F8iZ74DjKMBQPCrk2hNxH9rw+yoZjDeAKCPeaCgYTA7CuvxO+tcLbm58Ypiuf0W8meJsfIpouSkGuols9cJVFyym5NULYF1DqAtZwGJBPmRDgkqAOg06ubc3RbpEQd7y2NPCZ2RoGLQ/jz8eeMGZ5ilkhnp9UfS+tkbBExzHZyLWEkgCIEMq
 +5QPo8Z1
 zpIeEYbrF3aOt7behGRlNeELGFi6mJOHkU28n6g3hKqXLdQu9Q6R8sM0pZKL6CNAYL6/G8AmNxArx7AUi7UitjZO9Cwj2Gr9SkcmD/4hCR7f9AMI5BdmmLbHO/RhGcvHt/FqexXbimQqMnw489Jqvb+RpB9XeXkRBMP4raDn6oAbCnCDnTboWBRxpZo59th4vzkEawNcrRrEgCbIkQl5ctTeaMFMcGYLTgiVwCUbNn2FiY4uZpwSGAlBY/Tb6nxwNoS6VP/+GXNOYUiaMqRl5+nlBTKqeAoQqzoITcUHgh6dnySmZUo35JVxCQD06GpnpbFq083QIPT6g7zprO5k6KMVU1SnDH87Qgo8wFizxtRz8lkz6cRDMnLNbppHMhofxsm/oczjx5roVZiWDo0KAQ8BBsdLVjOfKyggFX9BhwQigtbiMBmR3MAw239gj0LGT0MYg4eCtgLUBGtOeOr8ZanpWz3HI7G38j1cThShx0g+BIhbbaRdmi6KqlncGHL3OZKpw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a sysfs file, filter_report_type, under probe filter directory.  It
receives damon_report_type from the user.  Reuse
damon_sysfs_report_type_name struct for user keyword matching.  Move the
definition instead of forward declaration, as the code change is small
enough at this stage.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 61 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7cdbe2fedf7d8..ca971cf1dcf6d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -977,6 +977,7 @@ struct damon_sysfs_filter {
 	char *path;
 	unsigned long range_min;
 	unsigned long range_max;
+	enum damon_report_type report_type;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -1175,6 +1176,53 @@ static ssize_t max_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+struct damon_sysfs_report_type_name {
+	enum damon_report_type type;
+	char *name;
+};
+
+static const struct damon_sysfs_report_type_name
+damon_sysfs_report_type_names[] = {
+};
+
+static ssize_t filter_report_type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (type_name->type == filter->report_type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t filter_report_type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			filter->report_type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -1202,6 +1250,9 @@ static struct kobj_attribute damon_sysfs_filter_min_attr =
 static struct kobj_attribute damon_sysfs_filter_max_attr =
 		__ATTR_RW_MODE(max, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_filter_report_type_attr =
+		__ATTR_RW_MODE(filter_report_type, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
@@ -1209,6 +1260,7 @@ static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_path_attr.attr,
 	&damon_sysfs_filter_min_attr.attr,
 	&damon_sysfs_filter_max_attr.attr,
+	&damon_sysfs_filter_filter_report_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
@@ -2992,15 +3044,6 @@ static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_producer);
 }
 
-struct damon_sysfs_report_type_name {
-	enum damon_report_type type;
-	char *name;
-};
-
-static const struct damon_sysfs_report_type_name
-damon_sysfs_report_type_names[] = {
-};
-
 static ssize_t report_type_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-- 
2.47.3

