Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82B8EC531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6C06B008C; Sun, 26 Jul 2026 13:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570236B0093; Sun, 26 Jul 2026 13:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485DF6B0095; Sun, 26 Jul 2026 13:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17BA56B008C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77C5612056F
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
X-FDA: 85031640414.25.FA1DB18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5C85C0003
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i4CXw4WC;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAfIlLPcU4sckuDrbS7eOEg3BQtpmGkcQ7Y936FLtiA=;
	b=s4s24cJqzbxr0uSh9wfN4QkhP3yhUFyZQYbLewkXn4BiDLVxXu0Xt6laPdISD48V756cey
	7y4cI8HPrnN3SQkVv3uAiUKQTywE9W1FIMKFB8d1KKQ0O8pK70bTv6sZLWPPzf7JwSUXKE
	25dacFBD6YaFBR+R8gjvYcwCQyMA1f0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087586;
	b=qepAuVG9qUx5NTHYy8YND0K+JXISLj3vnrpAxbpdcYAz5lc/ztQ3GN5UlJWSlmu0vNWyMf
	MDoN3PHAvAMnGibt0GmEgIYLofHmzwj2ScgMk4747x3IvGzZfWrEf8sQu9x4HhzbX0ckQk
	X+cz+2g+3o/oSgPqTzBrJDYClSNXmHU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i4CXw4WC;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A96740221;
	Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B8A1F00A3E;
	Sun, 26 Jul 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087585;
	bh=cAfIlLPcU4sckuDrbS7eOEg3BQtpmGkcQ7Y936FLtiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4CXw4WCW3mBgPGYLEXYsHKGA6SOd5AWjotEtTI8prTvmoLIRK8+K1m/Bcdzb2I8e
	 pLwV/wDUt1VaSa/QfRAolYHlli/CLfdF0oiKi5pemLJtNFbt4OfxzYW/jcWDWDkC7a
	 WaEu0s0Va3TufnxXofGwAqZVQLw0rwR3xraP7ZAZVXgNfeBXJ/7Lb30enAhgd5ogHb
	 kwnK5KcrVNi1vhpuDRg6FgmjZ1UYe+ZfgnV5Ko1kYtLQf8osVZ4zJ5k1EKCV54R0TC
	 FK8Hs0ErxeczEhbq+MaujwIEeHlGfqXc8SRrIdrOpIzA8/drv+EOoCyJ9tRQ+xACqc
	 f0fYsc7dPNEOg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/17] mm/damon/sysfs: support pgidle_unset probe filter type
Date: Sun, 26 Jul 2026 10:39:19 -0700
Message-ID: <20260726173935.94046-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5C85C0003
X-Stat-Signature: ojrtx7en9wcrzptym8876goyptmspz1g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785087585-871738
X-HE-Meta: U2FsdGVkX1/MLmurKahOuI0wLjkWj4boOLvqTWH7Dft/ROVAeerLs/utL5Hfp9yr5PdFy5Ccjaa/eRRk7AaaVAYpwPM/CXD9OU5au1md/86GZCzgNYgS5D+5RckxPY4K898kqah3JoMP8REKZuyUqnU04cgOH6JTpjgM21XoBJzPDN3fBrfS84AUpaX3uXztmKT0sTf4I4pz1tOhmFsxE9bdJNSoR+fWNz2aEjkCI3WGBs0fQKbpYsB+/gdhw7gIK5RrOD/zVLtE/prAGC0LR6+gES20GUeYfIdtTLb3TlOpMVFDeBPMJwmbNizyI6CXh7LzsmGtSwnXRKXR4se7PBfRExxrTVVIBKfikp76Sgt69WODq2AWWSQpS9XJSwpHOHbYhTmfLhAOs3I1uFvuZueFcwuExEXMfSwFbuTgA5kWxWo6OcbtS/eGlMX61wzW/Wmi9Ue5kYN52iuz3Z4cB9jRabNMUu+y/GkJIorzfVZvA5cCRB+qal/fN6Q7LUPluwvW+izXLzywKX8SkGzt38IL2MVtvFK76nyVLrkAb1SyeP22UfJD05O+53sD0tahky06rHl9udpTb++UP3Fr3SFNCE23pwLrooKIbxkd2typoZLrh+5v5lyUnFJiVemYi0BK/3Mz/5e8CVkyRb4NJjX+kq6zvYaDGL36KhEmnxcnV/ZngDfDit5LRVDL6o3mY34JLzIdV2ZCGNjnTkN4CmmbR+C6r5cyRCLByDgAfhUitXVokxH3GqeHvHiIxnuzD8LhosuTSrijA3QQilVCGhMiyg0n74oxBO2PsH9u8hCkq2+3z6INKs9EbFuhMpS997Umn4rU0ByBU9mEt5uuFdE4WqIMwLNOY1dz3a8CJO4NC3o+Q8AHCe8rmfi7hRV9td1rLBh3WnmA81waZhEEgkfd4UqTwOCmT0lMPV26rLTd5zJIR+s6QIdG/MOIb7XXEu9nq1ee0Da8U8ukswZ
 Pvbqz1s2
 rRR9xE8a4/rG5svS1IHk+o3DRsMf//okhafp9DvAmhDahkjr/l9yZUx4gv4q8iRhYfc8w3gJKsGF+BGtb/5jA4ilf35NE7qcogk9HwojFPQG13MPoPcKRH/1blV6hHlP39DaUADuO2IwYd0cJzADZ+cS9C3kpCck0wzsZP4QUDBnQnarSXDU6jB08tAXcIPWNHDtbZf2J3szF9LybXDe7V3G6hGB82RzsFgMVrr3GE7Zmw3TKeTLbxQ0BEtIZH8/jbMFoEKYqUPDD2JI7frAmucYH1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to allow users to set
DAMON_FILTER_TYPE_PGIDLE_UNSET by writing 'pgidle_unset' to the probe
filter type file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 053ba2e53b969..376c6ecbd4bf3 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -782,6 +782,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_MEMCG,
 		.name = "memcg",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
+		.name = "pgidle_unset",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

