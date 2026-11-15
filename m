Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10AE0606A331
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F15rwd+e
Received: by kanga.kvack.org (Postfix)
	id 85D826B05BE; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E566B05BF; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6885C6B05C1; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3146D6B05BE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F7A6C0740
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
X-FDA: 85438492734.02.5315417
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E11171C0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F15rwd+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHhnYqoQe1EhM4f5cyc2l4mme4lRuHhy4MnQ2nEOlUo=;
	b=EWbZuvWeNXAvxYp6eICHPG9gLw8vK7jm4O8XPEiJz4/pF+UciwdMJbjRZ6MDVLUs7EsACs
	w6wosDQl96Mm8Cz0ysk3nlaDuffZZxduO0LEYrlQnHlrOy2L9UYrhyTURl+/fMt83S+aUT
	k3zHp6tWIuFpBw/GlPHGfrYlhUJ4bcw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F15rwd+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774546;
	b=DVcfmu0plfOhVg99E1rvyG6Ukz0l1Mx0IP4bq/KaOwm+c1m26v0Qchb25UdznfrASLX+zn
	McRDZW2nafzz4trnt5D67XsM53r5i37Pa2SntjzufsxlYN5W0FztG5p7gw+xGL0ZNJkqf6
	2OuiEXmNX74jo50/41LK+HBGSq92tRE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 370C444CF6;
	Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64D91F000C5;
	Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774545;
	bh=kHhnYqoQe1EhM4f5cyc2l4mme4lRuHhy4MnQ2nEOlUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F15rwd+eNBmEdxKDvcq79WoITIDzqtjdcCDeOwCKWxl2vA+qUQRLN2PyoBkxx2Ew/
	 kxUdqtSObKxnO2ciG89vsMy4ZqqUDl4fEET9UBKjUHmwBKnCQXrsqtoqYuloliNqtf
	 lFqKOqRGOgvktbb1nxnyg6mypGimnQZ44268AzS7tweaGlifbWVWxh9a2a51VgxoCX
	 QHbB9rydPYKIulC388SnyrTBwC9lRqEbCxnIRBq8vhPAG+qnT0zjbrRmsBfnwUaYtH
	 +b4jSYU60s1yp0XY+SVhr/GIrESqU8HGBryAdZKVz7nGQFvYqtRkz70l3jqDN+TMzm
	 NrmqOJbo8VdWA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/27] mm/damon/sysfs: implement report producer type and state files
Date: Sun, 15 Nov 2026 12:28:26 -0800
Message-ID: <20261115202849.99134-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E11171C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p49cy3iod8cb4wym1je6gba771o7yjhf
X-HE-Tag: 1794774545-40143
X-HE-Meta: U2FsdGVkX19FiU5Mijf8+SITLFOORYYDu9CDe5iIUx9e8AP7Jydlzx97/unuGNljarPKM61ykUTC42AWj1EqJRwQ2xf8DOSiclrJkPIaLpNNITFjtyktIlpWbOatP9zqzaQy24vDIn4CyYyBYMe59NA+vObxH8Z6QsX5ZdQ49ASE1wkZzYJ7B47OgAEahhmZHacI7aZjCrT3rR6/6WsA0OoNAO6S13TpRzn4P/BZg4KiP8N5XcZbtAXIIL+n16b/Nx8bDDW9/btjoYMbphh5to2aIoWD6HM79s0v9xqOPIdh2uwJvIMmV+PCWTXhR5WWZRydBV6mkMzKXS69fA9oE+QBDZ5T/crTGvSEjjMJNZ6bnsU0EuPWTnAXAH4cxtmm9CFe95cRjcZfrb/zQyxEYV4KXoQr8IdOQLKJMWIrJz1YZi83Ttnr3+P8FNNIvFLqqysdA+Zvx6Ijg27r+2lRTiknV3RI0beOlzABzfrfJj6AmiXgPWF2Ohqen5x+kL/aSE97i5Q0Iy1GMTaftmGMRK4/SePwiw1AGEp/sNelaiHpd9ydoL2XYHhRTgk49CKlYuXpxrsTOu1+h715H0KRYuIN97JWnJTgoNeT5JHfjYdHf77l/l2uMbGKV661oNq/6OexNlauuMpWGE4bKqwPBZvOj8IDYqM+AdEvAgeAHbvrXjMxIoKmWNIruhHV4Q+OYaTA5KYFJMlRZDbIaa4lLvsX3zQTZyPCfAnQWTHgAIssxdjN8yad5JE10YNwTVLP6M+ftdl/86jW7pSUzifbf1QTb6YnyKW829kKTogKAUTwgzhOe2bUTCQfn8wnns1rkijMtpETpBPDvDlc/biu+hytTMESz1VsOLFXmruhv2dwOTOSMYhAQG05vDb4h1jO2BS4J0mHb/ZD77wmTQj0EoWUYIyGnY6+8vT/3b8V7r2ascVQZfTDju7ylUoza+xj47U6j5IupHqWxzhGgcO
 Ql65TnkD
 Oio6j6QCyZ/30fIpeW5rJGdUlDTNIIB/4i6GniywCc7F2O2RRNuaZsaoQjw/kd3wOqDHPLo3Ir83dyv4wX9kicppv74LMiNzPu/aCctmP5m8/OfDe6qrbt1xSlBiAyFr5qtBEHEoaSaX/uF+PG8ljZmXFwoAVEjCigCkCy9DX5Q0dJVrHCzfGmjrjmnTiUVggnqiHhJ2Fc0R1Bnuc0WRbmxPT2YP7AgP/2ekdtzUjDlxjNcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement report_type and producer_state files under the report producer
directory.  The type file receives the type of the reports that the
producer will generate and submit to DAMON.  The producer_state file
enables and disables the producer.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7c6bc30c12125..7cdbe2fedf7d8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2983,6 +2983,8 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 
 struct damon_sysfs_producer {
 	struct kobject kobj;
+	enum damon_report_type report_type;
+	bool enabled;
 };
 
 static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
@@ -2990,6 +2992,77 @@ static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_producer);
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
+static ssize_t report_type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (type_name->type == producer->report_type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t report_type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_report_type_names); i++) {
+		const struct damon_sysfs_report_type_name *type_name;
+
+		type_name = &damon_sysfs_report_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
+			producer->report_type = type_name->type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static ssize_t producer_state_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%s\n", producer->enabled ? "on" : "off");
+}
+
+static ssize_t producer_state_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	if (sysfs_streq(buf, "on"))
+		producer->enabled = true;
+	else if (sysfs_streq(buf, "off"))
+		producer->enabled = false;
+	else
+		return -EINVAL;
+	return count;
+}
+
 static void damon_sysfs_producer_release(struct kobject *kobj)
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
@@ -2997,7 +3070,14 @@ static void damon_sysfs_producer_release(struct kobject *kobj)
 	kfree(producer);
 }
 
+static struct kobj_attribute damon_sysfs_producer_report_type_attr =
+		__ATTR_RW_MODE(report_type, 0600);
+static struct kobj_attribute damon_sysfs_producer_producer_state_type_attr =
+		__ATTR_RW_MODE(producer_state, 0600);
+
 static struct attribute *damon_sysfs_producer_attrs[] = {
+	&damon_sysfs_producer_report_type_attr.attr,
+	&damon_sysfs_producer_producer_state_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_producer);
-- 
2.47.3

