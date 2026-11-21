Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83848606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F89/6U0/
Received: by kanga.kvack.org (Postfix)
	id EF4B36B05B7; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCBE6B05B9; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8366B05BB; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7486B05B7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15551A8195
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
X-FDA: 85460344452.18.D4E4B8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 747E01A0010
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F89/6U0/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294824;
	b=ZYE4u/Y6Q0sMDLu4tVAzWHnhmWhyVEe07SeFUQ1i5gIFn4ZzAIxaQ5aRoHjO2LhpuL4dXh
	S1rsiag7lU9u6GlFHFE42+oBiSflStNnBaEPaUzrudSVprgLQZonLVmtN9EHiJOBcw5oZA
	dSppWIG+qOrVbeab1jNV3CtaE7vAtTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHhnYqoQe1EhM4f5cyc2l4mme4lRuHhy4MnQ2nEOlUo=;
	b=HnqymVvuDZ2KOqvJeI7hflip2g2OubrU8VqsiitdjU51+kByJN7U/8b08FUZ9O6IKNf3dm
	EMaLDFGtJEcsUbnDzOKKKGvjCUfZc3gHKUQvKj7Mzus/BOHkSwROeZyu2QX2QZl8y5Vbzg
	O6fv3DqZWjGNdchXLw3d71PXQYwk/ro=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F89/6U0/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1859A6185C;
	Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D051F000C4;
	Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294823;
	bh=kHhnYqoQe1EhM4f5cyc2l4mme4lRuHhy4MnQ2nEOlUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F89/6U0/VXKOgjZVDRORViF9mRu7k4n3LTqm+jm83sP0pwQbo7BZ2/vz13FIvx3O5
	 oJoNJtg4A2Zs2cgg6KXQdGCHRklDqXHMWAH577gTqGMF9hMEwI0hoZUplMvVcllvPo
	 3XAQ+j2ihDn0vrrQ+mrXeR1aDU4gN3J26ct3Qy1vz9WtKdvQGlPxAZhbleUnJOuck7
	 zmXvgqRERANYcpuaYEjyNPpNWhwrBkyws/LTXRg76g2T0iJrbWfQzdwvKQVb4LGECt
	 3PRSOeIwY+Gzso1Ax+biQNFkVObQf9XuQaMIfSu9TMrZZ7ERNbAtWhUOlopfMF7ugq
	 qlnZDhiVaGKzQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 08/27] mm/damon/sysfs: implement report producer type and state files
Date: Sat, 21 Nov 2026 12:59:52 -0800
Message-ID: <20261121210013.130397-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 747E01A0010
X-Rspam-User:
X-Stat-Signature: t8ujze4wnzndx9qmgpnzsqi5wusgx1um
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795294824-105485
X-HE-Meta: U2FsdGVkX19eRB2ln8RM7Ys1mCVdsLlXZ3sV7WuJG8x911lRlhd9UIPf98RGFAypADYPRr/Qk74KF/8Rb48paF2IpC2nVtrSvBuerA8jPPVRaAyAV6wY83HnfpRyQKODGY5nzi6IQHaFs53PSyUcbzF4KYzynEencXRX/vzOWCk0mOF9HlbtzTKq4JA6un9Y+6+Oq6Q3BmyZy1709QMbl679OL2mIL6h74Ek3mtMaHJP5LuiGn/r8uWr2mNVg72bdRS/8r86kRGju8qtQ7zghlOX39JFbw+aATCD4AGovPntbLlJM8xDpB5FbngocU+ZC7CXdjYHVrdacCkZobI0mb5mes2iVgJhfepVGpuz7K1yfX09bmVivXBAQOwYZ53dvItGPEUj0+VeRgSf0nqNlo3A7D8tKYTrbwS+Pe1x32QydD8SaIjRgZ6e+suSkuCGWQN/RPvr80BtAgMU6Mg7XhukQw3dh7hnco8tISiUPYgn3+2J4sRgDsRZ0oOs5Ep6eqHoKmEAHAb0eGhYCheMPEk5UqxoDJKeqFxEDOZ5c1HbKLWb6+n1OlQvW8/XzyHHwu8cZ6NrF/h2kfvoStIA8sJWPSwlJLClya5Yl22Ni/AH2190ZQGyLr3QtBior5i3TbOPrIuDhxIg9rDxCOQJ8SnvaA30ts5s39sqxbecFBcjw0bJpDyiwIV7oRCLg5qzttn31Df9yEnx+6G85Al0e8Ucpb1rJdYroOavcA71psQ0p2SygJMsx22FRxsHUFF5VTR5qZEiCuQcEGRMUfLiMKiH25AbHKHbHG+5Bg2n4rr6+KCbQUCKbTDG178kX47XhSpO8Y2cm/l+eqWjYiybaz6jod4EZaDFg8bke5G4TroaCbSh2UZWYqTzpGmS0Fyw+L7VSmfiI3It9GgyUQyX4fSLYivyg/9lvCsDSfx8pAZMN9O+GgiTYpPlw+PlAgOCRRukR8TC0uLI5I3jeVe
 E/YrjI/i
 fCKBzvG8U2mbxeHiu+hQSJGvRScYkEYRthFRmLSEg6MtlhrTkvmkYQmGyocpN8ZhVM7rN2eRYaXVlG8x+gJoRMh8+iD0wKtE+zz70bXx912FT8ecx/XIdO/c4Gixwm6lgUIvRXABRMs58s6pc6nJyGhb+eL73uxDHSr7HcI+EWBM1UPyJU/LpbASLLC5nzq9xv8xL3uTcjDj4p+awr6/jZnhespVhcJtwKjqpQcmCTicJ9s92S2HRVMDv6g3j6B/23tKBa3QiHlS/1y/ltqZAhnNFKopCfXlm5XEtaa71c9lfyOETc0Rk5ZOdLobh6J6k7AlbFB68T0lekLGcSbvTkkRiReIAW6IcG0iXE/CQ/4rN/xlmbpyu/KOJTvJExSExCr1Tkz17ZKa8zrbappGVh13Jc5bMVyeo8yk9KgFeWnnwLY2QeBF/bg9AdPCGpXxNKVZH4GiDFrmJhNw=
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

