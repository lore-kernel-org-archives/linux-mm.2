Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424AD606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dCuDRSCy
Received: by kanga.kvack.org (Postfix)
	id E6AB76B05D3; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BC06B05D6; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60206B05D3; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8ECE6B05D3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDE53C0625
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
X-FDA: 85446641322.27.2B04E11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6357D100007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dCuDRSCy;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968560;
	b=Igop8WiGMJ0QzDZn9K+S+SxvxrwYHCEEyEVYxfyLw997lc/jOvoAbwy/pFeyeBiVUS7gm+
	IWlTwhNwT7hQSMKC8O0QhLWfT66fL+9ZuTwHKOnuYubMEdPRszmvbctND5OIE6cAGT8nfh
	EtD9kUD3cjc/3aAbl2qlOfJlnxGHviU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dCuDRSCy;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDurKzhLIi0mIdGpL4ZrXZs3NcRPuPDRtfbfQ8ZOhNQ=;
	b=vzxJQISc/kpyyzjP6mxYDl+DFQu5vFLYjR74IQW+L+kZGRZvGsp//W6obp8C2h2wKQtQAh
	YmSD1hIqf5i4xa8AF6dxntswHs0yZBPdXRWZDjftllUrixeKyodbNpOzCo3kwFlo3V7lLF
	F4K2MC8B0jzUkheOFW1MwIonzukPOmU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4110361F3A;
	Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CD01F000D4;
	Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968560;
	bh=YDurKzhLIi0mIdGpL4ZrXZs3NcRPuPDRtfbfQ8ZOhNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCuDRSCy7N8EB8YvlAg1D3EprdCOIKwiS2uReNiI2gn/CaK7oPVrWtV+wUQ52dJjk
	 DaMuxrBZ1DAIl5ZUN8wybKfjVc75esWv+9RFZfaEqxZsfpdeOsAi2r0f8Ub7rqBn5z
	 KpL5bOOwQhOe9Ki6o34TSZXHkH5vspjDqZnVoGTX7GgU2uEPxvS972MRb8/fAj2m3k
	 IO4XgBh+CsMMGPOsinWw+BBDahPryIqXffVa38ERqRsDoNZvfDxTuiNtXy3ULkpi44
	 lVlu7d5/J1NHG4xrLLSt3NEDQdV46jy9XB4ydPnJNKQt97PBh+1WPOtjwPDKWX9W4Q
	 kD7ir3kYdrxbA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 22/27] mm/damon/sysfs: implement report producer addr_{start,end} files
Date: Tue, 17 Nov 2026 18:22:17 -0800
Message-ID: <20261118022225.100659-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6357D100007
X-Stat-Signature: 83pfub3sx39n5dmhtrqjmszkhg4wg639
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968560-671931
X-HE-Meta: U2FsdGVkX1/GxYrEc0hYEfxA5i0vfMOjGJ6itYeoyxrluOSnYpENm7/LsDxaaLYdBmPp+Skwp4FHgkAs2Sh7B7+K+fXYf7i964a2wZT5tJZ3gXMhb9+xx+Wl4pT4J6KAvmmD/g2OoEiAZOZL2bzOpLjRwiP7FrrV+N6FeG9O+MJztdBA4SilZpfzQQ/6MKm8fbvd9xm1xmDH/est3GDbpKSsyTaggB5/IZ66t0HKo86Nd4jb1lMPcaGJwa5Gfg3vFRON8AbV9Hwx+mc8E91EAjTqF2f1j5u5pU3MCvD3tINS0StbvAtk6bPxjOUto14DCxno7At51mmLyW12JrpPQ+7i/OIqwU4yyzjCxcKFniwRHsfiAZfhwz2PS9ChkfmmP71Jf5pAADJk1uQPCYE+Ckp7CBGOatjPQdZmKCwgPh9Qq9P+IHJBRZ05luxvelUhVhB0eZ+RwvcrA+VnEXWKD3mrK1ckvTX33UqiB10nrZHKkrntO6OBwoPXNAdI+XCjbcH+aTEtPJH7ByS1nsLpGu31jcLB6Gtjw2MjY2GbjLekwDqoT+V10vIX9dj4Xa1lqq/gzbQxGwQ1U8GznQM3FrvKrO2RuqvsK6FyrwXrmUke8ozwH2K1uOBNLR552+FlwOcE9837QpYwUoW4L3q9PrM/z5fDMeJ+arq36Le2j9mzrV8kjT2Rr0EVFjdQcMqBsea5VXMMZptmUCe1PvgcNRZA7lfUwQfw/qUvUUVhlbvQJyRwFu+GVqetqQz0OhLMjPwhZIm6nVETgfztdRoXJOi7XQ1KDc9qPkIRyw9t7ywFCBrGwSU4id05HQGFw9jZlK1jg3cn1hOipu09KlJKV/yK32uNOptcv5LajQ5vBv2pgGu0kt0bXpTX0zAN+M9RSVj2ePMFmYpyJSe2Kwk7aUW4kZEAmQ590t9Pl6EdGve7LT9EhfR1FOazQQiQQ0fRlc6HU9gdrvB/53UWGOt
 wYl9LW2F
 1lOFOzg8NaNw1igQdPRzyZDGE2R6vHWvzYiA14/yOO3w4V3DsEQSUDRV/3zozyZJg0CWsBXV+LTGIlgCtyv6yhU+zlPs9URXusdqKwPxNa5AHLmeHaiD4rxF5iJHOsL+W/m/qsxJ43596LuG7Xwguk+VYmj5pGXMmMP4OIX/7gPlvZ3zoSXdfhvXHw9Wr4m+flcyy0vEXYWq/ZeDXhuCYyChmCR75pInTq2nTmVQoLeFLZGiLciqK5Wwu+uPeM7IwLlI4932TQaTQ4bZxPYypFB8KUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement addr_start and addr_end sysfs files under report producer
directory.  Those set and get the address range of the user_report type
data attribute reports.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b4d898ec0c9f7..5f9bb1955dfd5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3047,6 +3047,7 @@ struct damon_sysfs_producer {
 	struct kobject kobj;
 	enum damon_report_type report_type;
 	bool enabled;
+	struct damon_addr_range addr_range;
 };
 
 static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
@@ -3116,6 +3117,44 @@ static ssize_t producer_state_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t addr_start_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%lu\n", producer->addr_range.start);
+}
+
+static ssize_t addr_start_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int err = kstrtoul(buf, 0, &producer->addr_range.start);
+
+	return err ? err : count;
+}
+
+static ssize_t addr_end_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%lu\n", producer->addr_range.end);
+}
+
+static ssize_t addr_end_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int err = kstrtoul(buf, 0, &producer->addr_range.end);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_producer_release(struct kobject *kobj)
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
@@ -3127,10 +3166,16 @@ static struct kobj_attribute damon_sysfs_producer_report_type_attr =
 		__ATTR_RW_MODE(report_type, 0600);
 static struct kobj_attribute damon_sysfs_producer_producer_state_type_attr =
 		__ATTR_RW_MODE(producer_state, 0600);
+static struct kobj_attribute damon_sysfs_producer_addr_start_type_attr =
+		__ATTR_RW_MODE(addr_start, 0600);
+static struct kobj_attribute damon_sysfs_producer_addr_end_type_attr =
+		__ATTR_RW_MODE(addr_end, 0600);
 
 static struct attribute *damon_sysfs_producer_attrs[] = {
 	&damon_sysfs_producer_report_type_attr.attr,
 	&damon_sysfs_producer_producer_state_type_attr.attr,
+	&damon_sysfs_producer_addr_start_type_attr.attr,
+	&damon_sysfs_producer_addr_end_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_producer);
-- 
2.47.3

