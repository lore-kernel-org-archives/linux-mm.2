Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6765606A337
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DjIu6X6t
Received: by kanga.kvack.org (Postfix)
	id 7052A6B05C6; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6AD6B05C8; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9FB6B05C9; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 308956B05C6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A44CB1205BC
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
X-FDA: 85460344620.14.E87E9FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12CB5140007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DjIu6X6t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294829;
	b=B53E22rch9N+5U0wCknSepHQW0PasFYBGlC8PXMcrZO7YGAbEZiFuEgy3omAxHyzcUSjU8
	nXJw4APGVN7nx/SH/NqYFVSfkKroBFISShRRmCAkgbRjUYVG5DyOsV2QmToO8lG6En76qc
	H2OG4iMz+4I02YE3P528TkRnZ1PX/7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDurKzhLIi0mIdGpL4ZrXZs3NcRPuPDRtfbfQ8ZOhNQ=;
	b=cHIKsAi6I163lJ9uh3uIHpatK6geD4bn+AFpL7b1SIhCu4G0jrXCrR9rZ9Z4PcmFMph4mP
	GfGAaUhz9Md6OJoxojT8AEo9nzknmx/pt/WOdM2e02nNitWiXlKiJ1QVozU709Uq/LDKzL
	c237GKATKRwGR4u2tPwPkz5jRBzgs94=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DjIu6X6t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0CB561C79;
	Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923881F000C4;
	Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294828;
	bh=YDurKzhLIi0mIdGpL4ZrXZs3NcRPuPDRtfbfQ8ZOhNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjIu6X6tFNdglQB+DuO58AM+e4OKZcZnkzRxSiBlta8fwg5EwcheTW6LQrK5FrBIL
	 JORooxV/dPj5pJLYz4VxpnxMirmM3JRRwtrbRjTmRPQXt3t8iiLFpq0OAkjcTh1VHG
	 9OnNTcet9x93aWCwboNfXxUjOElylzvpfB6WEo7MKtYMw3NjSMb0igHiHwzCZAVlQP
	 3PIaV0vTf1josb/TVh+XG87wuEyjweLYlaHP5IyJRc9KvxZb7xYw+NPEC+oLB2I0XE
	 xVmRLFiDk1HKNN3hk0RG+UxaFup5xQbbzokxbsFZSPFZDu3htFaXf7S5HMKKj7wZQY
	 pk6SXynPeuisw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 22/27] mm/damon/sysfs: implement report producer addr_{start,end} files
Date: Sat, 21 Nov 2026 13:00:06 -0800
Message-ID: <20261121210013.130397-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 12CB5140007
X-Stat-Signature: iozqrd4rce5awd9sfsqq4t57qjayzb96
X-HE-Tag: 1795294828-43957
X-HE-Meta: U2FsdGVkX1+4w/HQqU1yyUdARhx6DlUv4cU5Tl0QZckabxCEGKvwcQMQBz4Bbo98CYAgIfG+34LLMCTjQvxmPzMPC5P4Hs3uhpQl3MzkpLn9/Vge29jhv9Id9Su0ZpzLt1oY4ja9B7tv2y7GC8trE81FKm8zoVRwGNClZLziISW7myRwhTP6lqAXmYA9kn7ERnChmgQCcuNzH2ETlkfiKADGQlUL7iYitXj7DBt44FoGo7lGdOkGKo4tvZzn5drypL+DNlJ8g78lr5n7IvoNFzS7Z0YMhtF+nQdAMqeiaqAQAIiFCExvsP5Td8ry0wD+GV2lr0bUtCvuj4gviVlTQ/ONBswoXnmEFFgc+FHnICwwY31IaEQWh6f20By/mZVoFizEoIdBHPdvGf8ha+WYpX7quFScNeCl/BviwK10A6BdXgU6ewmL4MhWqDX6bUKRNMCh2ZDKmzhamD1Jg2LlvMUhyLRu/oBaBrs/SgPqpeQxlir6P2+0xUfAIPUuvXE8bxg0YhYPzgkD+HPcxAbVOdtpaOcX0dqqpiNInTF4Xif4yinv8l8SgadgHVK2/qfq255RWvX7/TO7cbmGEdJ47p9dPMTqGJKvAkc3C/Le+cw1ujLsjTJvdP1BDpqXF//Hn+nReZK9dutRacdnCgvKUgQKTtHFs1Z6Q6Cvrxxx7lhVrU8W3A8a8lybLQRBAywmmhYo3nQDVVx3RqXueo2Y5jxRd7+KppMRKpg9qTuwZVNm2U2vzeexw3UVRqEoO3Q3kUqGYpMc3n80TDtP0pUctNPWnmb9yjK39UNdSHHYm8XdVqVkMit67wx+9IbUDBDGf622JQldEX1U7mW4WN4UBd3eaRWzyX/ZlG0aQLRSJmcoCsSh1qxf6X0czJG+/fKJf7Aj0eamqTBrATWWr9gsz4BUB6CF28dIDSwRHWxL5ldqfHa2xAeFiYD5qKTHFLoO9I+Z+dGuNiK3hpnI+Tc
 2nWzMIxO
 ZdA5V62s5oQJ0wX+CUvruz2wlPhHSBfwn80w/iB+qHXd0xyxtP+GWw/O9xcbF56eWhkKPjqIsrRbMNh0U+g2GGvW8sxqNIQ4W166JCvPfS9ePThTZg+xTveKrA2foWVvyxGTmIxvHlGApFMYgb9opNc4iNXIXlZXtgUirEdpp9iRJQxj4GT3ZM++XzSuDFZIE9N1jrKi7yd4wBT5U9eJH41nEqvFuJ7G3SE+r+lq3t/jdFhuHtjEol/cI06+n+ztmNEF3TtQ9kA6SjqCtIURe/LdrmyUpzBjNvJ0vr4YV4gNH7X04OHF7NfOoNC1kKEHNWMf/mc5q1rXpBL/ubFasw9MnseD/6Uh/1jxLRFS7yqxVL4w69Tq9IU5gUR7pvTbvFNtMhFxU9k38RyXJ2e9oSI7yUpiWHfb5vlE8pBpamDy6Sn9fDsbkZx1xQd7Z5WEPC13MqX8labCiAVBhyIvB7EWPJPtHQetguM0t727By2qWvkxByn5ba4W63CUSg0chB2AH
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

