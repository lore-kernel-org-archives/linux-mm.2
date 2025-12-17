Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43F6D65549
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA9C6B0005; Wed, 17 Dec 2025 06:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C985A6B0089; Wed, 17 Dec 2025 06:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1056B008A; Wed, 17 Dec 2025 06:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7F406B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:02:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54353C09C2
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:02:40 +0000 (UTC)
X-FDA: 84228674880.26.73A532C
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A1DDC0016
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:02:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBXbwAnL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765969358; a=rsa-sha256;
	cv=none;
	b=fuqVl7xIiUbXVz0BD7e0hXlekyQ1Vy5fmEaLSIBidjhNthXJ35gKWldjvXxhDn18QsG5Dw
	LX8GxFfNOZIe96QJkL0tFeI/0I+zYz3n+3IJzmQywCZsulVyQPKt8rybnk0RIVZ8XnJV3k
	6zJcQsCPHz6Fx3u/b5s4xIooUwqM6QU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBXbwAnL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765969358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ONjuWOHsXmlkvlW3RDBd2vPB9+75EpOLXx0cs86qt8k=;
	b=YTFywaq0f6wkF2GBvHKdPpW+XNmQQB+/AovDWVIWF2itcean45bWHoj4TvxpCkuDqjtpfe
	hwIzUoO+TZ4XuBw9p9J/Spanx0o9UgajL5W1OX2G24sO25OhgSJ2nN+nzWxVz22ixk6tTL
	CircLybxYWXz/We77q1DVinBM2ZNGC4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765969351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ONjuWOHsXmlkvlW3RDBd2vPB9+75EpOLXx0cs86qt8k=;
	b=EBXbwAnLc2PPFeFic5WMslNkC7WpjI2H7ovsoeM0Ry2nDQVgK4dxdr0MQzkybJhW/KKXdx
	NBCLwnp2WlzFW8hJoZCaJIv+mRCcSmDQ7vsEDBG8bYHhpvZ1xZW5NSbFLiqN4vBYA4qfsl
	thFK0v6chablEY8GXNZ2OjSY8N9vNHE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mm_init: Replace simple_strtoul with kstrtobool in set_hashdist
Date: Wed, 17 Dec 2025 12:02:13 +0100
Message-ID: <20251217110214.50807-1-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A1DDC0016
X-Rspamd-Server: rspam10
X-Stat-Signature: qix3ztgsiedzfzqhj4ii4pswewnza15c
X-HE-Tag: 1765969358-520366
X-HE-Meta: U2FsdGVkX1808zb9C3VMY+tLFOur/W/Obfe8NOyj3kreyL7SwBFcZiblfOv3BrE5UsvEzWa0tvaN35yUaWHN2E1LUIzWl4A8doMBkwiB/kunKIQO85kgIaxCSnZOOCVKn5LDTKuqeHBXS8NSOiho3GQckdLGvGbSNIr7KoNXBZL/4KRCTZB0BqD/G0LBjs+FV/ZlGfGSsk+XdAUTrhKBHbb+8TxRm8c4aAIBIgE8zQ5rjuEWD8ghE88PWIdZM2sgrf9hEM+uW4yCl9gs2IrTu5b70lYoBpCysagYs2p/Q1hUUOimJWNmX2HPvvfRNasBPcWt/Zz8af018Rdckp6WExHzPEWPmegmzy77S9v3GJgEaWOrsuwOIVXsuhUgRS6e/zkhieRTlWxpT5cLAoWTdoRdZNnKoKMZhwftL+zoXRamfgACzmGQ1eNyEoCyXae0ck6vMqq2FaBuBIGm70MofUgmJN7rThpUY7ZO9ZsCerSh6/dkesIZp6dON4qgA99TTFpPXX7FrgjvKiRSqypLP8FBckCx7GiWiYBiYBQioNOTCs4I8W7CQlRZFIGjxN8dA5pSdeab83z8l/RPYShoGziGUexWLvNSRwzKrLnxjjQ0DVy+H92aOxoH3u4ID7IVVHvcO35/w2W7pIUoJ8XM8ESSwZ8jfGHCyhPd6HvoqfSVr74gMsBwTBPmbiOQs4nN69vALbi4qcZiTjWc1+TRjojqDpKDx1Mr8pdbStnEee6oH79Q19peOepNESiAFk4sE3Qt0PIPlFVkIEGZkfoicfaFpAOTkKmudcxkdpQFpdsUTM7VJE+LU5vwtFJmEoHuCusOjmlakPqDvPzTKsOTwJxuhWZkKe/uaxSjIHMyjGKeQTbyO5Sjr+EEZozYTPL/t4MXKyWvBEQqRUdOrUruCdYacgvPAJQqb3Ezvsjzy24az2KjZUsXzLBgnedYQp26a1Q84G6UPTUZsu+uW49
 ypL0Pz9/
 vgtCfS9WxSYL0BmYDYRpjGwFlbPTBUXzykjOatkzNDhHHFHoEzGA8FdmtVReikGwCeepZsEK/F+aqnWWzttyjl4K/6EpaOSNwY/2Hb8OQx4WepJlYhkZoaIAzCG4PcRJpj8+qSPAnx2JW/V2nLFPVdatYLNcBP5XwyjG1kFWXpa3MxwOhhnyASOKX+is9nyT1OI3xa1Zp4pP/l6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use bool for 'hashdist' and replace simple_strtoul() with kstrtobool()
for parsing the 'hashdist=' boot parameter. Unlike simple_strtoul(),
which returns an unsigned long, kstrtobool() converts the string
directly to bool and avoids implicit casting.

Check the return value of kstrtobool() and reject invalid values. This
adds error handling while preserving behavior for existing values, and
removes use of the deprecated simple_strtoul() helper. The current code
silently sets 'hashdist = 0' if parsing fails, instead of leaving the
default value (HASHDIST_DEFAULT) unchanged.

Additionally, kstrtobool() accepts common boolean strings such as "on"
and "off".

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/linux/memblock.h | 4 ++--
 mm/mm_init.c             | 9 +++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 221118b5a16e..6ec5e9ac0699 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -598,9 +598,9 @@ extern void *alloc_large_system_hash(const char *tablename,
  */
 #ifdef CONFIG_NUMA
 #define HASHDIST_DEFAULT IS_ENABLED(CONFIG_64BIT)
-extern int hashdist;		/* Distribute hashes across NUMA nodes? */
+extern bool hashdist;		/* Distribute hashes across NUMA nodes? */
 #else
-#define hashdist (0)
+#define hashdist (false)
 #endif
 
 #ifdef CONFIG_MEMTEST
diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f..d86248566a56 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -646,21 +646,18 @@ int __meminit early_pfn_to_nid(unsigned long pfn)
 	return nid;
 }
 
-int hashdist = HASHDIST_DEFAULT;
+bool hashdist = HASHDIST_DEFAULT;
 
 static int __init set_hashdist(char *str)
 {
-	if (!str)
-		return 0;
-	hashdist = simple_strtoul(str, &str, 0);
-	return 1;
+	return kstrtobool(str, &hashdist) == 0;
 }
 __setup("hashdist=", set_hashdist);
 
 static inline void fixup_hashdist(void)
 {
 	if (num_node_state(N_MEMORY) == 1)
-		hashdist = 0;
+		hashdist = false;
 }
 #else
 static inline void fixup_hashdist(void) {}
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4


