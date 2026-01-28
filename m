Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29927D35690
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944446B0096; Wed, 28 Jan 2026 04:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB4E6B0098; Wed, 28 Jan 2026 04:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE306B0099; Wed, 28 Jan 2026 04:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 728F76B0096
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:31:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4454D1A0533
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:00 +0000 (UTC)
X-FDA: 84380853480.07.761A70E
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 489982000C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VJrqCbGv;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FByi9ivqPJyIjI850sU//sSIfdwjIzLDbOJYWWeWKFE=;
	b=E/pCIJvjM6LyvjdCColQGDJXTPDa1IKCLijq5GvDfw9OHMPYNHOJ0a1+cjBO+EO7DkC3GO
	kDedkhT+3iOWxVFwPEo9L41q6KSQX6OVxS6/VrusETIk5+JBo9tEoasquBX5uLdGtREAGW
	AYAFHNW6giCfJXMw/fUuI0aQOOe/mvk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VJrqCbGv;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592658; a=rsa-sha256;
	cv=none;
	b=k5bBqhbdqc2CJKbfk3E4lOlsScoTpwQoejfZ9PBA3YNZQUZ2Pqu48DSHeAmnaeOggpEHbV
	EQh2H2muCf0r6p/m79mrGcIWE1Ad227vp/u9mcZacQ3mvIupavcb6BsLRXb+7ot9NC7k5A
	fKHUxybhvL2cVgsg6K4Ns/KkUR8k210=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c626bd75628so2330942a12.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592657; x=1770197457; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FByi9ivqPJyIjI850sU//sSIfdwjIzLDbOJYWWeWKFE=;
        b=VJrqCbGvFu+OSEvAbRqzBOY7aOst6LJ9tlKiKkmlRtGMm+3/ViStx/eZIrVAV5l4Vy
         HHqHGTVgIpml9JARzBmYUl4S/RlNfSHoodn/0ixaGacFMKbUdyUSk/AhBo8CcVfZpLia
         WUxJM9wLiEx/1Rnaia2jhmlCEXrwma5dvYgR6SV9W1CgfCHXVeeVhWYm6jGWfSlV6Z56
         /GQfz01riVKerZwIbPYfcs//8z8sXeQufmBdH9pk15M5S2R7QX1byJICwJnIw4zHi5DJ
         ndBU6TXPPkntQEf2DY0ojqlzyfsrNDJx+Aw4XevsOMmXaOD9IO3sN9Sh/6YgWVqlPN2N
         RFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592657; x=1770197457;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FByi9ivqPJyIjI850sU//sSIfdwjIzLDbOJYWWeWKFE=;
        b=P49tAzVMJ9O1We6KjpNybjN+fDfeE7vHWj+kEUaim3mscg1o2j2o0qJ1RQa5e0ffS4
         0eiimvMGUGNWCDhmQDBnw701mLl8J1j/W1DjLQUN3Pi34cgQiUynTPoCBc1jmRC0xTQS
         fc2GCD5QUlSbnOFl3FAK/+OtK+o0fxhm+6E4OzdT0gMXFhxaRTpc+jV4KmrlUfJfkhBZ
         IYI/OtshygrQkG4MoSq1DnMCIEmVgfoNY3+gdlYQiM1+cWiva2ccdv4YKQYkzRvi52kL
         IFSGl2hCArGp8shzMKBPD/FZylivNrXnUvNKcXfkNW9Yu0MHWi9lGiXF6SW9MFDyu1EU
         NJ1A==
X-Gm-Message-State: AOJu0Yz3eQVN8Mqb6hnmX/RyoQfb8Fuq0BAVw7BIPKow9ToFF25cpw8m
	Ial0K2PPt9KxVOZHFLCRqnUo9T1bvzhB5vakZ3yUhdhQHxRhRbcxmCeB
X-Gm-Gg: AZuq6aJgXgVFov2ffiJauStt1XL7EMM33lVXHdHY7rqdfBDDBcRboQkRy4qw1VBTm4Y
	9/0XglrmyoozQ6rIHqXUS1YDLt6uocD3S6ycRiV45K7lsl8Ps0oATJsJDZMBHVy/37JZ6jgCJf7
	H7uVLjWEtzXSacWh5JjrzP2TpsDi6tRL+wvIn8EzDbfHFWr7tGTr/tKYWiMuh9UH9oGjXh+H4Ql
	cTK0dTZ6O02roD6v/blZk/Ge7gmhD5cGkaCOZ30Pa1oNK3fcILz6OtnfF1clKNlc2VB6B5m46Rm
	tLhQTfQvVUxxOSMvQlEsTWEpa2DhwnO9KcSB8/leKRViG8Yl9ms/gLjH1G7dllM7l/X7B6P5OEe
	5TZ8W7OOVQBHo+f/4j5V5a/VYRSVosfMk/UhMYwT18HIeUlWxfMwiBlV4CFx8Vk64aKNTBbsIxi
	ceEXHj2ICA6vSrmlhhrxXujnz6H9k95GD4sjznd/B+Bat/UMAxvwtTeo+VAA==
X-Received: by 2002:a17:90b:2c86:b0:32e:7340:a7f7 with SMTP id 98e67ed59e1d1-353feccb368mr3822825a91.2.1769592656953;
        Wed, 28 Jan 2026 01:30:56 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:56 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:31 +0800
Subject: [PATCH v2 07/12] mm, swap: mark bad slots in swap table directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-7-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=4470;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8m9COjsQHMkFcnP8SRLKraCOnV7wwqbxj9agW6bIMxQ=;
 b=PJ+2tKOVSzN+igBqvPYB4aflWKuvIjXVLzoOy7Sa6fTN51lteTQv078zHknrSO4i0Gbrf5zBc
 Y8yCq/5qPiBDOWGFjReAYZwOOSw8UlyCNYO2ncZR5mduSyDsLBD916v
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 489982000C
X-Stat-Signature: nphyyuggtoqfwuhgm3y8d63k5syqs7sh
X-Rspam-User: 
X-HE-Tag: 1769592658-721800
X-HE-Meta: U2FsdGVkX18HBG53PnySGwGQEh0rP+wJMFdQejj1QXExgLmlM2dGLOeCp/o2Mzn2/xe/4vTxBCIpunhJUJf6bhAPEJtXxo3STFfMl8xjPaaAJN1ymwKN2ZV+RLzIj2kk4ygv8C0VQX/OPVhlBMhZhqNKqxAExp13OH4h5nTLSK1DCCUIb4qYe0EHsu/LhdeB9YbxxJcfdhRMfx9pcRmfGUIk7Qyj1MNX++y7/MKqfT1kCOKEL+m/yvJwPgTFwUaC5QwhNTTTO31PvCFo1zeT91ZtnLodl7amGwb2HhNIYqs/ZneyXDu3Q0+nSDH+/v4qZGLeeKDr95lN0Gf4BeY01JazngzWJrS0g4WxRmGGqCl8b8JqwkYkVYfL/On5qgySAPE1cNlqqZiIUkkH3cRhJqMqg6oSMJ+e8Ukf3+ZZttyp3HhbVF52s7moj1VBqJPfaQLlZMPiA8tcvYmWzbH4iAuRm6PlEsMdHtaNyoSwPEaZM1wb/dg+0KtHVMaas5KfjArgX1WILfKF5KfL34+iL6wwX6AHnxiBHDALtn2ECMQGHXqK/qNqS0R3tFjj/7k1Pia+c/pyqIJSwOEnwiR6vRgj+tnOKDKzaY/sTIEP1oDdfydAGH5cNVY8lyOJLVCVUJpKh6rQc4oWMVjr3A7sSTa6L0lbZkwmDoVsvt9HfENZRXC7RTaa0X2yWSe9POcEGyXrJTMTNDnGVCkZGI/4ZJcCurIdKpAWqLL3h6Se1UasHOMSKo2HjnHclsKtj8jG1zNr6yXE49NyDY/XQhsws7f+nZcgVm0NyPWJp6hCBGW5lg6OUxhEk6YRd4IQ3SvcP+QBFnbLW0kaBaX8Q9EHFZJKERZq6Gs+XAqmW2k/gImyRQfYT95xmkTbYW1KsCdKcQG7g/QvzWzE3qArhRxdiVsVBLroHYKXYx0o05JA6dQlJLji4wsA0zz7h7LwtitCv9MLQyeFOveYzv28hqP
 RwCJuOlX
 6T0Fs6+OAsyx3mfuIpamGBbQQ4Kxt5qejq/iyI4+muCkLX0ndwaU5mS2dg5NRsCu275hQ+PlOMg0cafSxaol18sQ7jNdqVfzgJ7UaoyGXaNB8TVre8s9CKA5DKIcFWLqVgxjPr0gdB0IgmaryrvMVdmlummMQMU4lqcSRpELDVPWIzlL8Ks/Di/cqZV5SKabpSZewX/JCgH/fZs+37zClKxmIa9jZwyJo8wl8XP3qVNu1FnwBq+V8Dmca/euLeQU87WNubupiuZrh8Bq4l/PlzHj7Voa32Ji9cNIsRiWlVThJAHcGA0MmIKoxW1k9KEzJ2ucbyStIOD69Cu7Upw1g8uMJoTyjc1iMaI/u/9V3ss61ygkJCUIbyQqIJvzm9rw6eqniSc6h8I39/C5PP3PmU17ubhqbQnc8IXJTuOnXNNc8OP6G8Gz6wjAYKF35EV8yQ4/G1wVB9vdZhDX6aVCc3BPJGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparing the deprecating swap_map, mark bad slots in the swap table
too when setting SWAP_MAP_BAD in swap_map. Also, refine the swap table
sanity check on freeing to adapt to the bad slots change. For swapoff,
the bad slots count must match the cluster usage count, as nothing
should touch them, and they contribute to the cluster usage count on
swapon. For ordinary swap table freeing, the swap table of clusters with
bad slots should never be freed since the cluster usage count never
reaches zero.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 56 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index df8b13eecab1..bdce2abd9135 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -454,16 +454,37 @@ static void swap_table_free(struct swap_table *table)
 		 swap_table_free_folio_rcu_cb);
 }
 
+/*
+ * Sanity check to ensure nothing leaked, and the specified range is empty.
+ * One special case is that bad slots can't be freed, so check the number of
+ * bad slots for swapoff, and non-swapoff path must never free bad slots.
+ */
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+{
+	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned long swp_tb;
+	int bad_slots = 0;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && !swapoff)
+		return;
+
+	do {
+		swp_tb = __swap_table_get(ci, ci_off);
+		if (swp_tb_is_bad(swp_tb))
+			bad_slots++;
+		else
+			WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
+	} while (++ci_off < ci_end);
+
+	WARN_ON_ONCE(bad_slots != (swapoff ? ci->count : 0));
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
-	unsigned int ci_off;
 	struct swap_table *table;
 
 	/* Only empty cluster's table is allow to be freed  */
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
-	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
-		VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_off)));
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
@@ -567,6 +588,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
+	swap_cluster_assert_empty(ci, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -747,9 +769,11 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 				       struct swap_cluster_info *cluster_info,
 				       unsigned int offset, bool mask)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
-	struct swap_table *table;
 	struct swap_cluster_info *ci;
+	struct swap_table *table;
+	int ret = 0;
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
@@ -767,13 +791,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 		pr_warn("Empty swap-file\n");
 		return -EINVAL;
 	}
-	/* Check for duplicated bad swap slots. */
-	if (si->swap_map[offset]) {
-		pr_warn("Duplicated bad slot offset %d\n", offset);
-		return -EINVAL;
-	}
 
-	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -781,13 +799,21 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
 	}
-
-	ci->count++;
+	spin_lock(&ci->lock);
+	/* Check for duplicated bad swap slots. */
+	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		ret = -EINVAL;
+	} else {
+		si->swap_map[offset] = SWAP_MAP_BAD;
+		ci->count++;
+	}
+	spin_unlock(&ci->lock);
 
 	WARN_ON(ci->count > SWAPFILE_CLUSTER);
 	WARN_ON(ci->flags);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -2743,7 +2769,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			ci->count = 0;
+			swap_cluster_assert_empty(ci, true);
 			swap_cluster_free_table(ci);
 		}
 		spin_unlock(&ci->lock);

-- 
2.52.0


