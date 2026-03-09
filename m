Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A0FAEFCD9A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40346B008A; Mon,  9 Mar 2026 07:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6B66B008C; Mon,  9 Mar 2026 07:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE33B6B0092; Mon,  9 Mar 2026 07:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDA1D6B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:08:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7077A4B579
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:15 +0000 (UTC)
X-FDA: 84526250550.14.FC792B9
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7F8071C0004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=aJzk43P5
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773054493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDF64xxZzJ7cjs3+cnvijW6JKtdwRCzUCIJnt/1dnjg=;
	b=eyxZJVQfRUEZUCVQ/Aoqzt66s3pUD89AvWbE2WG0Zzrbo7F08nxAqCr8l8AFRJPNhFrfXS
	vkMHdSBH49gi7hrk86jaMf1OzPR7Gh7O2rHuh8MPZe94FAOKQ1vNwzj87KHKm5FU9LRtbA
	QOnz8GvTp63QHqUANQ98OuzHxWLX9fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773054493; a=rsa-sha256;
	cv=none;
	b=dwyALuvLWrMGlh+eHXmWJ270/v+NtA/7cDSTPyk4V8bhTQSSV9dXp/4n4wgY7EHlyZr5b8
	pW015FvFInCxuMpH4uPf7bbIB0ktDkX3ZodYbky7n1R2lfs7s1e065saoOP7SQX2BnOV8E
	Czhge5jOsFUaD9j+w2MeYvNiZfDyoOc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=aJzk43P5;
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=vDF64xxZzJ7cjs3+cnvijW6JKtdwRCzUCIJnt/1dnjg=; b=aJzk43P5l/5qDBrMnOPgN+KrlX
	AQBPF2JgaxiMCcO3LXDwmIXQWXLfGBdxeOIiQ1ZZvd/DmkXKZKg096kmoDB8HlBzwdnViag37651c
	cF7wY4nfX66lPUKnHytO3Qn/mu0fWkMxy4ZAi3xKLVqrvvi7OW99YObl8ACPV6qhWHYxcL5PB1qYb
	QW6LBwvhbag0pqw5WplP9emxj1krIjNhIb1fVkb38paf/iuFkLMYl4sp/2YgQukIOkw+9fEQfq5pj
	LHmf2UuIoEijkYDFdOisUKq1cF9fXQmUbr9PKzu8KfAvVX22CGMIFom3NXIaXfIb+0CBwU4jbilrR
	/pOKJnPQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzYSw-002AwY-Kj; Mon, 09 Mar 2026 11:08:03 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 04:07:31 -0700
Subject: [PATCH v4 2/4] mm: huge_memory: refactor anon_enabled_store() with
 change_anon_orders()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-thp_logs-v4-2-926b9840083e@debian.org>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
In-Reply-To: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=4428; i=leitao@debian.org;
 h=from:subject:message-id; bh=0o3mclXhx2QxfkKcINCvef62gv9C6nChRQktfQw550o=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprqn+AeoIXBGWkxLKEcTZncPU7aYGAQAdEASX2
 BOq9g76TpuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa6p/gAKCRA1o5Of/Hh3
 bR9iEACr0Gx5HEv/nW2mooEN34Yye3riL+2G1zLa7DFoqSg3g0ghDMjnXKNf/jm6074lXwEqFp1
 mSFCL4U17ZCIyasG73+lRhzDl8RvYlOM9f50Wvt0o/9zkrjvxGAsblskzElCdsSRokqsgGCpqJ1
 R2lR+CyErBfvMz0A05PNRxkjjA+DiwulGVh5SJs0eXFJcGfqTpDGHuboRHq8qMpBEFiCoSCVIoQ
 WtdO8GdzMfZaKPD6it2vV6BLt6pCaWGO8bbonSGekSevOqTpXu8TGJ68jGcy6F5RdhgsuJdlavj
 Q7L6BZDNDQyRRCmVuD0CS1fEu4HluJufR/w0Wv4dA40v9e+YYgUnhY7+6zcOI1D1T+d7tPWpLQ+
 4QztZzAAoNjek1IDON//L4DMVHDfyRKA453v1NnRIFlBt5rvlBff365DWbhSuL41kFh46v9lnZH
 A03UOPjHUenBllemwNnde0kR0aTsuKXkRWJyoXvT88JinUkuIEfG8qhlpFSw05wOxgWwIo5PmlL
 Ugcy/Rj8HkwBteRwLIipr9tGoEWfD5Oo3UBTJbxePWEOwy8Ef/sSCuSr4XQzMk33Am2ixKwUCae
 AF5VYC5n6YIsWUyem4CSaD3ZuYSC7/LWemzEcx7wDSNzfLjvAgGnS/RhxvWmDbRmoEjG6nVefz4
 skxojNfuFFwZhUQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F8071C0004
X-Stat-Signature: smx45wdigzr3idsourpuxiskqqzyj9rp
X-Rspam-User: 
X-HE-Tag: 1773054493-887690
X-HE-Meta: U2FsdGVkX19McV2U3VrCh96MX7aGX6NpZadqdLxux3ll56PRZSrssoK/nslv23ZHJiBcoOI73fO1Lsk12TjDyFQSsdwVQAy5TkMcwSuNACEYDULinfOcdnfDx9YNLiHS60X4bfIZpS0rn60hrFPtMxTn6SN2iSySpYV/hczvploQ0YJ73BtkFHIbJC9NJ3gw3q9coGPAfpDOKI/tICMTxdSc0DoJfV5gIv3Wf5Vu/XHwTRLJHYwqtrP04NY+IMokYLBuRZcPYHjQurKPN6P0dZmHEu2a7nW0OrmRBEzzoR9InCHcM97kLTvyVZwFV46VjimgD4ArMQmpr76Jnawh29g63m3gZgzZ99B+PmqKb7fbMYmJE5yVyvzbPJQTzPF1Nouys3PkFE7xo5Nl/M4KiD5rtscFYygzeCNc/inkeiQHeriVtYEXlqtkj6AD2/stP6n411bkj/4WVMqDTPR++7Z3fxSne1Qy32wJ8qUbJebtBGALPi4cj83/x4V5MbCUwWUx1GbCcn9nDDG/5EjP8c6TheNHl3xYR2bEbzV/OSBk7D/TDkWkHanoE8WrSGRxCy2TsvNn7B9Ar40ixk+nUJu0js5P8rs5ns75+GFKsVuHhl57opOlj+91FUkm7Q4oVvB6Sib8v4mGVbwl0ewPM9ewom1/RIgoxVkH3J/k/3BQCYHoYUG4GQZ4+Rs2u+DdFxDRZi726ycaH6cQtlNg/q8T/1XZwmtEBQl7LTAiwc1JXEFAJjRCr0SfW2WBmSF1LvTqyuK2Y4c/lqdQvFOwvskcLKFZS/OZx3dbso10mJ/iwZH0c5XJ/hTnPfJuqqiwlLjV2E4nu9WkKuWImDaUizbH5r8f6clpisG9EmPJPeJ1SukRBn1w+NJrtjq/M27Yvvwx/P/d0whrrFym4lz5ZGW3bX0ZL+FIiDKt38OePSuFAS2y/v5TA7c/EAAdjbQs8pLQQRpHrhBKO+/jA2t
 S/p68S3A
 M3stIASsycuO+lzdnDRxMyqJGcmcWpZ0ePkK5yCtYhXQdasGTDrqbL5RbAhzfoX7TI4WOLhl3sLkL/c/z2gRdDVA3g9mWywcKqYU/XSw2B4JGG3VZGvucZ6K12IOKQ7j+wf9DoN81Nr93h594Jm8t+XFfU8l/hIxSjxIni+7t8OvgqKsK0HkeM3MUMkEBrMYaBxVQ4hiAVrfqSXyuIZ4MEDBIRBWECt/8bgo+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
anon_enabled_store() into a new change_anon_orders() helper that
loops over an orders[] array, setting the bit for the selected mode
and clearing the others.

Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
for the per-order anon THP setting.

Use sysfs_match_string() with the anon_enabled_mode_strings[] table
to replace the if/else chain of sysfs_streq() calls.

The helper uses test_and_set_bit()/test_and_clear_bit() to track
whether the state actually changed, so start_stop_khugepaged() is
only called when needed. When the mode is unchanged,
set_recommended_min_free_kbytes() is called directly to preserve
the watermark recalculation behavior of the original code.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..2d5b05a416dab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+enum anon_enabled_mode {
+	ANON_ENABLED_ALWAYS	= 0,
+	ANON_ENABLED_MADVISE	= 1,
+	ANON_ENABLED_INHERIT	= 2,
+	ANON_ENABLED_NEVER	= 3,
+};
+
+static const char * const anon_enabled_mode_strings[] = {
+	[ANON_ENABLED_ALWAYS]	= "always",
+	[ANON_ENABLED_MADVISE]	= "madvise",
+	[ANON_ENABLED_INHERIT]	= "inherit",
+	[ANON_ENABLED_NEVER]	= "never",
+};
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
@@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+static bool change_anon_orders(int order, enum anon_enabled_mode mode)
+{
+	static unsigned long *orders[] = {
+		&huge_anon_orders_always,
+		&huge_anon_orders_madvise,
+		&huge_anon_orders_inherit,
+	};
+	enum anon_enabled_mode m;
+	bool changed = false;
+
+	spin_lock(&huge_anon_orders_lock);
+	for (m = 0; m < ARRAY_SIZE(orders); m++) {
+		if (m == mode)
+			changed |= !test_and_set_bit(order, orders[m]);
+		else
+			changed |= test_and_clear_bit(order, orders[m]);
+	}
+	spin_unlock(&huge_anon_orders_lock);
+
+	return changed;
+}
+
 static ssize_t anon_enabled_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_always);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "inherit")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_inherit);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "madvise")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		set_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "never")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(anon_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
-		int err;
+	if (change_anon_orders(order, mode)) {
+		int err = start_stop_khugepaged();
 
-		err = start_stop_khugepaged();
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+
+	return count;
 }
 
 static struct kobj_attribute anon_enabled_attr =

-- 
2.47.3


