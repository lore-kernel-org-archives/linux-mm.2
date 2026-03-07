Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CB3F55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 16:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67926B0089; Sat,  7 Mar 2026 11:08:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28546B008A; Sat,  7 Mar 2026 11:08:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37A26B008C; Sat,  7 Mar 2026 11:08:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2D7E6B0089
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 11:08:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CC99140449
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:08:58 +0000 (UTC)
X-FDA: 84519750756.28.06DB5AB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 858DCA0009
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:08:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RpL+LiTn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772899736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmDCySQR75AVk0G7ci1h/kEC5miQyqWVJmvwkT82m+0=;
	b=r0ROVKtdlwbYcUOe3jrSVBju1listtDbgPOh6DsAce5SCy5bLeJg06/2mzaGQtjqOaTu1h
	r2MKtseOAb2qiP053rbAZ5mBsoXyv0htGoZ7JK7dOoVqyLLrxhMjcXhVq6AWEcJeD2l9/N
	lae1aIij8rFjnCRtGSzUfsdCPe/hyT4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RpL+LiTn;
	spf=none (imf15.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772899736; a=rsa-sha256;
	cv=none;
	b=Onawtr7qkCsKtNFZYyj2me3MdNM1ywbGmTv3jQP87Qg7HzwTsPN9RAmy47cETDQX0ASSCw
	f9zH2R1h/LzETQbL5n+mDuaoCLc2fZyL7yT2h7Wza7dawghKUgKLuYC7IxXZPNsjw5YCs2
	KjiL/csM9TzFZGQvzK4FJ7bpgRNXVzw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=MmDCySQR75AVk0G7ci1h/kEC5miQyqWVJmvwkT82m+0=; b=RpL+LiTnoiDsgV78/8WS8ttgTb
	ZsmBF9ssOwmpVcJlDEZKbeS+gtSQZVlX/sp9Pzaexm/PQ8bCXwBe+PKAEb7Y7DOHBcFOt3NgySK4Y
	KGRiZrzGYmZXWS/bxOGeAZ8ccEsZgULBWbwBe/xBU//J9kaSj6HuZDZI6cfUpGHFfIr1NykXCh9f2
	6WzeeUg56bBtiDLxStoKQKwoqNsWmoARKN6Drn7Y02tgeg6BwFS4kLI7HMOinhnBTNDcfj46943ge
	8GnG+13pfC2Yx+w5U8CdMATDHxlux0G8agRf9xawP/UA62J9YZMKFSIXEhUC5LOuAydsbV8XJBYXP
	6SUJ0KSw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyuCp-000nEg-CY; Sat, 07 Mar 2026 16:08:43 +0000
From: Breno Leitao <leitao@debian.org>
Date: Sat, 07 Mar 2026 08:08:06 -0800
Subject: [PATCH v3 2/4] mm: huge_memory: refactor anon_enabled_store() with
 change_anon_orders()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260307-thp_logs-v3-2-a45d2c8f3685@debian.org>
References: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
In-Reply-To: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4393; i=leitao@debian.org;
 h=from:subject:message-id; bh=/1eLIdHPUDcvIpxBXzEH0x3IBBqIpnLjC8GGQWUs0vI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprE14ggv8eqItj5fMOtP7NI8WiFHHpkVrd8wfU
 TZwIe4ToJ+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaaxNeAAKCRA1o5Of/Hh3
 bYzMD/92I3HOSF/fOgXxnBNEfHeYuzs1HW42exZ5kHHQkpteZS92Ko3J5hADsYJlPZNUV+taKBj
 Vx3SmbJLfn34uCfU7hposW1qqhrmGAVZKZv9VL88hNtFpjv0ryqTU4HPpADkCvTg375TCzQyIy5
 YaqOkGj2mTacqGZk+9QrfwcfziakMA4GJ52pihbWktcxd9Z2IywFp08P8NF1MJ8GF2nlGEfTRqi
 TkXaKCEvD5EU/DfpyLbKTLvPMX0LNgrH7iFcVYL0hdREE8p8lCefYnr1AKjynzCt1KmAqZCPr0h
 TNCQsQXmDzbACkSxJpoX192zsKtCWhyK9Dv666ky3tbvFp7rRzhvexjEcry0lPiWRaOPtFQwomX
 tOqmLA0cKVqmrxniyd6gN14LHULh9mRuCBUDFpj7hCRuqFRe1ce8ayLIekLrqCLFbAaW0iALa5u
 EKgHNOUL00Gn8LXYEIe62shrQHs1Us6XMoUTJzFxm4Sdb5AFv2f1yvWn+XTs1qy3Pf170XZEiZw
 SmPDHR8cUGNTMkuxv2T0fWbZFb+q7USUs2iZKdg8y9vJFArx+UBHJhNWqWUIwHqS4oEQqIPyBmn
 5yzXQuxR/WyudBuWUGebEGk6HyvQXQZwTy2Rpjn5Sj87G1BI2GggFqGyJ9NlzLJqsJkXdGeXUY9
 GGeXafGfOTgHzKw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: kqiss9pfk91fxbn6m4yh6hpeq5wybg1q
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 858DCA0009
X-HE-Tag: 1772899736-992482
X-HE-Meta: U2FsdGVkX1/rBN6rO/oQKzeCcahjhA96z2eQhI+jLhRpQ1WUUSSYp8u+8GJ+jRqyKpuMGZQJ8HSN1ysgRSmZjki91QSXtf4PaK4Zoz/tcYSGgR7nEf0OGUK/lrLZ/HNhjkDIWdbzCvjJtu6Dd3e6gNbojkFWRmZ5nXItBKD/2FNzC4zg8+3t9t1M53Ms8f/YpBMFQJm30EftqCuFXBKzKTC9Macijfu2QLYk85RUDbnt0ThC+qwdKjuC4N5BhZEFmWXoRb6ZabE97NC7FbShQtQa1I4PJMPqtIgo3/cpQhr/x+E897dUSaDVqUsR6R4bukZSzHb81M+5qaNc/s2rENn9cTiNkduwt49Bk1oIt63MvVGp3+GdtmTjNumjX99uA/MAj3ssBP04k8psYUS0pMH20cnekWpssCjT14w3X8V0hrVxzVw8GVPWVBX/Mdm8MGy+m3yv+002Y8rrByKm3MhrLJqZBIBFGHMEFNj3PKZFsMpozMpRw3YyLci1dXiUIry99/PslPXdu6s5S5bFIz+U4wqg4AiHXcE10uoxQyVUyGJl2c8EN431nwcJNgcNsxe5NR4UVQW+J4KlJYwXV8F61/6o0M3KCAyTAKmKEcXz4/o22W/+P9K8W5Bdv/LzkxNWK2EXbUjr3A1crU9DU+inJRToCMXm8i4c6qp0q4sBfb72mXdmHAigU6Gi3O37uq3DBWZj/ho2VsCz2VfwVt34Bs4gBjTguPXuiFA5uTwyP1MCAA5wwuGSVzxkYlGvWwl4+OPIpMsbfQnDTLRWz+SAu5RkjHmY7/+v+0m3LetLXv3bhmI9GOv8ZI7fC2r9zlw8RZkBQ48wfWZUwnzsSLfSDleK4AR81Vhu9YzfZy/AfngqMfGh+ssABzrlggr1XImLg+wgbLtr32JxDeL/LDvABpQ44HwkQ0YEZRqrJ+9Ier3U7GIeprLJ3qG9IydcrCf6ZoFC3vzYFG9pQH3
 dTjmXNR/
 QgqaDYtdR96e5cNJBhjALkAF6TEpxH5eHHxZI4X+Hy/49XaKj24s2tyrpbZQpY2fdA8IOwxO1lioFrxuInmtD7+poRnzd0psJeSKbFbT6iEqy0x1lfQ043jmVF76871lq4cbHwvGwpLXfKZ1tq8LyvbX3WD8FofRvL0f+XFse8cPoLwYhGZN8SVdQ/akK5d+PkN7tDzLe4k+Ym82M/qcIXC4EgGmDoiqkdoZV
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
index 8e2746ea74adf..17ce6a16702bf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+enum anon_enabled_mode {
+	ANON_ENABLED_ALWAYS,
+	ANON_ENABLED_MADVISE,
+	ANON_ENABLED_INHERIT,
+	ANON_ENABLED_NEVER,
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
+	bool changed = false;
+	int i;
+
+	spin_lock(&huge_anon_orders_lock);
+	for (i = 0; i < ARRAY_SIZE(orders); i++) {
+		if (i == mode)
+			changed |= !test_and_set_bit(order, orders[i]);
+		else
+			changed |= test_and_clear_bit(order, orders[i]);
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


