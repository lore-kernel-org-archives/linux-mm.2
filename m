Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5767FCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B369A8E0002; Wed, 17 Sep 2025 13:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6DE280002; Wed, 17 Sep 2025 13:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D61B8E0068; Wed, 17 Sep 2025 13:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFDD8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:40:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A26C5A080
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:47 +0000 (UTC)
X-FDA: 83899457334.30.1860A74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B8B2A0010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="imKc2B/G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758130845; a=rsa-sha256;
	cv=none;
	b=iC7NAMoNXsCufd+e5X472Neik2ZoCH8RYBmQDEkUHMP6lV/tq3VpmakinyGsoybaWFjliw
	wBCtlum3zaK++uE/kaSRIpm7GFW5CNOuWzIcwz/a2Jva0eOqA8WbapE4NnzzB3nFUO/QOx
	s/UjcRh/S2IzsqwDx0LJ3iYfDfnPkxA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="imKc2B/G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758130845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCoLRximDJC7CAzkSmIC7qmkF1kfGQUDayy2Gj1yZaQ=;
	b=EEovTj+N3+UON2TG4ncVExh1U7ZievVzk6ugqePz84/UuA1ZZ84XipaTT2VjzEePkq3OHO
	7ozXRdUMRRxifIWoYq4YH1IYm6Vr/A19YBMdfJbyY9e2HosTbw5J5DP26A5f1RehnX7TT9
	B/79W8aqU+8NnDRTnBouhTTUlME7IdQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CAB386024C;
	Wed, 17 Sep 2025 17:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56019C4CEE7;
	Wed, 17 Sep 2025 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758130844;
	bh=8S8e7n6CmQnQKabzKFlVH8Uaq/Xv4oQU9mDtf6delh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imKc2B/Go7tqGnVzKJxq26RWe2jdsBf9Ed5PIKotck8RwFHLfGS0BBPjt8DjrQzwQ
	 PoZq1MNENH7vxNPLowth8cqCBY6VFfgrh/wMPvNHtXoc1QdyvzGZ8KBajL+RtHpAKH
	 BIqzDAu8/OgWWkBn++4a8QixTRL1Z/m4JEbIaMfM7i121nzr00gzHlLgQwfikkq8ZO
	 /7V0AUJnUyLyc32HBkNk+A9WDN+0OI8eYdqYYVDkT5cugq5KiRquwEcou1kuW/iU7K
	 1NOiI35NaZo02txKyCoqSbdnRtMfhvXTf4yEpXQS4PPwgGf9N6kV+jGCJhpSJ0ABX5
	 huHkkfAT7XbvA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] kho: check if kho is finalized in __kho_preserve_order()
Date: Wed, 17 Sep 2025 20:40:30 +0300
Message-ID: <20250917174033.3810435-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250917174033.3810435-1-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B8B2A0010
X-Stat-Signature: mr9hoxsomfoc4cyz4x8d7hsk9jhoifpq
X-Rspam-User: 
X-HE-Tag: 1758130845-621654
X-HE-Meta: U2FsdGVkX199k8q+RjIJV9/j6GMnTLpVJaVeJ9YvDF73pvVUYot1mbJCEsdSjj070KrcHnWaA3quxwAGJQiGHNYSdIqeHwqfMAcUm5dwj62xff4kgxdXPwlWAxt0849Apa2tUa5v49/2J0fh8PKvRV5uJIF1OjATX1Qk+ILMlbMl4lp6S7cNaCXLh3wd5jQVoXrjZ98HduqoPEtdVsRuAgui2RnNm7FASh2CaN7iqMW/wyf6bZX/qhlEq6W8mVD4xCTynTHiTqRnMoXmlQDugQcKu9sBtck3p7AuMcDGSbiVZGsdI3kkE7Tng3yBPtHZDpJaA0APRC7HNKcaLf2CCRLokcqPd/eKhD5AmIoSHAChV95AmoFx3UyRA0GDe87qiXjcXoSRtu/TK3v1VBvo0HriaUJOUDeDSsty4LDG1Je4X1xgUBvMzZoNyHOzzDC9ZQfbaj2qQdNRdgTVP51vKC5ndP8J4fGQuzKaUZ4R1Lg2vxZdJgYXT/jXT4QwgXz0PgbXB9rz73RBLrvcmNrBdz0xUtjydC/aendaNax/UoFV5F3juGM8hq44KLOYSqY6pKIwcGkggWvsF7+LiSzX/BQL9gKzY+zZEySFtJyXHFJntY+HKG6rev0rC2EgwFVtroHI5uYtXTzs95/UOtVfJS4uxqQkkiJq4gfzPqVajL9IzTOvzP+YaGGQ4nUiSrMKv/srw7/i843ETjssKswjwKCTL+HewImD7wnF42UxTqq34YVhJP/OJUTU4PKjtGb7YEgH7wSj9a2F7U9V9ykqJzN4ryxOelUmvv8qnu0tW0PY+ix9GbuJ3ZOQoJ2lNnhIb7mviawJZjeSHr1XJedVXnWFzK+Boxj/iJ2Zzbw3ZqsAEyJdqJCGH4LzVojCmNuljn0R01CZXIBqX8PH3NfUi9Cs3MS6HXEuvUQSHSRXJzXiPQ+CqXwrWOFSkr5NXoHaYbC6uigVqnrRLiEE6O2
 SIMAPiGI
 P3fvxCgCgtwVDhsTUgv9KqGFWxpbObKEdz0dtJCTW+Gcfw9wmSSm1zkZlvXV2FaNL/7DKbJA4otFubWmlPT/Nwrl+VaLEEh4KW1ZLLAwShHetqbicDJtmFsFXRO8WhmkSemmgGGsTAS+iO9AzYmK6mr3Vg6sJU59ZZE5wR9+v7YxGRjcU6YbfGsy/pXMLjtB4F5VyJ2BkjgnBQz2+orFzeLdjMsthAHIlArGCIfabCp695On7G1eBFtBBsPfgpjVCQ3r5csPueGKceHmmFBIS4C4WkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Instead of checking if kho is finalized in each caller of
__kho_preserve_order(), do it in the core function itself.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/kexec_handover.c | 55 +++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 8079fc4b9189..f421acc58c1f 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -91,6 +91,29 @@ struct kho_serialization {
 	struct khoser_mem_chunk *preserved_mem_map;
 };
 
+struct kho_out {
+	struct blocking_notifier_head chain_head;
+
+	struct dentry *dir;
+
+	struct mutex lock; /* protects KHO FDT finalization */
+
+	struct kho_serialization ser;
+	bool finalized;
+};
+
+static struct kho_out kho_out = {
+	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
+	.lock = __MUTEX_INITIALIZER(kho_out.lock),
+	.ser = {
+		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
+		.track = {
+			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
+		},
+	},
+	.finalized = false,
+};
+
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 {
 	void *elm, *res;
@@ -149,6 +172,9 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 
 	might_sleep();
 
+	if (kho_out.finalized)
+		return -EBUSY;
+
 	physxa = xa_load(&track->orders, order);
 	if (!physxa) {
 		int err;
@@ -640,29 +666,6 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-struct kho_out {
-	struct blocking_notifier_head chain_head;
-
-	struct dentry *dir;
-
-	struct mutex lock; /* protects KHO FDT finalization */
-
-	struct kho_serialization ser;
-	bool finalized;
-};
-
-static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
-	},
-	.finalized = false,
-};
-
 int register_kho_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
@@ -690,9 +693,6 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -716,9 +716,6 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 	int err = 0;
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-- 
2.50.1


