Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B168606A883
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dWOGVOub
Received: by kanga.kvack.org (Postfix)
	id CC80D6B066D; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E7C6B0678; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E6A6B0675; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC0E6B066D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E30CA1A07A5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:22 +0000 (UTC)
X-FDA: 85428937524.06.37C6A60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6325040007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWOGVOub;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794547041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEvMyrDAXRSzNt1aAK2qvgfoj7RJAzXbHjO64hkCzVk=;
	b=MQe7Dt/ViIKy9CIzV2Lg2vXG9sjWI3Nvs2PV6FIp3XZ4ZUklq1YhzmKu0X26a43N3zk9wT
	q2TPue3po9D5EoWCN2osOqfkQfEeM8SnboM19ZZAv9uzw2aXCeIvhxvyCsH2kC1x5t65hY
	6l7Pobig+sO/eq/1SjextdRMK/7EL90=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWOGVOub;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794547041;
	b=H68kTzfMcjdvIUxJwKSw6AWfHCt/neaVsRYAZuWo0AUSQeQ5M1wFn5oOq+WlIS1gaOSBYT
	8pI3BYPC9VhMs/tM/0r1mb9gZlyR98Hzz+SsoCgYSSeE9w8EcQtGrL6b4llwH3NE0KLT99
	poBsY5BcR77L+vZNplsQ1or3zJ9RYt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3789438CD;
	Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C2B1F000C6;
	Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794547040;
	bh=HEvMyrDAXRSzNt1aAK2qvgfoj7RJAzXbHjO64hkCzVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWOGVOubQmYgYdR8aCldbmFLhmQ08Gh1b0R0l21HrmWv9XzbUVfELJAKkZOJMPv8K
	 WDtTZkH7Bg7kjkBoPZHw7iUO8DCJ4kVhsT7U3ZI4DxMdJoXHixj0vaF7ZERLCvrdBV
	 dEs5fNKnfHyI5zQSXNppadSq1zgr/jGmYbZDlgFN7tUfRDhieaAYsJF/EK4aj9P1g5
	 xoQKRV81NdW3OoGCUPbqyL8M9wLI/bFo2APYa9Klm007GVSsfzEag76GYDiEzUev0m
	 2CTXe9hFU5BlL+1rB2439VlUpsSb1uGYzwisi8w+I5egUqKlvfNIVSgYbKv/kaV1fW
	 ZT3uHeB23RTMQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] mm/damon/sysfs: support LRU-activeness based DAMON filter setup
Date: Thu, 12 Nov 2026 21:17:09 -0800
Message-ID: <20261113051711.89274-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113051711.89274-1-sj@kernel.org>
References: <20261113051711.89274-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6325040007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 55y8qcixrg85s3tbwrbarysyzygmfwdq
X-HE-Tag: 1794547041-8964
X-HE-Meta: U2FsdGVkX1+TyFYWq9Hey4iBGovUh22zyCnsrTNQ0sKoEf6S+HNpQg1FNs6rHYnPgiwGlAzqik+VHKB4xzu8BgssQhd7L7tkOs36xvInl7eb97XVoaa5i4Rioh5xCZb6pVgxF9Iba+7PgxJ4TPYzVP3X04qkF6cjOszK4GadJNbs4MpOQq8mWNf9co9dD7pvINFmdL2YS7B+kbRiPpVO+pbLg2NaSfOVeor6Dq3552B0HHEPo/CQLvW+3zGLKuRCl+S78Ob0D+0G3cSpiz0ltTPsI/0+N+lErSgt8SwwmZV/4g77JrmIYem4vTS5vGeyKU6ohz5WkVkS7BCikKKKsk2E+cRDReAiF7y7zWrk1W9nStOhSMQz1+qgL/fdCVzXKl0btrSKiUqDDwUbT8XmuFG3Grbn+5i9Akoya3F/Yg1/q2i3Ao9ttZg8N9nR0rzeuJikrlAO14Pok088/QdxjdmYdTAs3qtU/Dmdh1T/MtR9JboCZxMQBf5dUNbLZfc/rOF6xQxTkFauOKu62/9KiVG6w9rwI/TXuS+1RzKYVBTN5haLSMa//TlidfxeURMoPZzIBQwW67KKpkOv8c8tKi9PBACu1MTnYgjspaKRruTpvUOYgkNgV1nhy+mN03CL8ACbdGMf7ykw8YcZA43WP8uwTS70onMfXmOIQXiY8rQxlQfvTBvH/WRVwNrEHpJ4sks0Fl115iYMRyX/2m4BKRy+hvxM8mNl2C9PHCkZo0WGIfhGEVtqSvA28jM+R39PszQVx7PmxBRjO2b8bn7v7xEyzRw2SpatmjriXRAYm+CLbTYWY1eNQjg5OE5B7Vmjzbt/TYT12G7kvro8f/NPctFCN/haAIIB7km7RTiMlDA8I79U8w4jFEwwK4+70OIEYYW1qV0nano6we96AmIwf8W7no5jjYDc6OWEBSFs0Fp0vFUjXk+2p+0ayvfuOu8AZZk2NurNTgDWWtZLnsZ
 XE3AlkjZ
 W9ztgK8sa/++fYRpw/52E7FiU41Gg6hv8DaznlG9sVAx80B1Ljue2tAY19lCF1tJ57Q6sDC9D4Z5nkooQhme/KWjbgQnhxNBgDMUMcd0R410D6zdeK/7QQDHtVKMoryty04NaxFEXrjh5+ClH/akX3xodcxwLqLa7xF1KJZqIYpe0knNGEGCPVQTqtzsMkfFR/eq+jGoUaD3qnhIAn5CI+fL8qqDKGOEftRJddEVd/0v7VRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support DAMON sysfs interface based setup of DAMON_FILTER_TYPE_ACTIVE
type DAMON filters.  For that, wire the type with a new user keyword,
"active".  Users can set up the new type of filter using the existing
DAMON filter setup interface with the new keyword.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 70a4b64fb8ea9..779c98205a94b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1011,6 +1011,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 		.name = "hugepage_size",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_ACTIVE,
+		.name = "active",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

