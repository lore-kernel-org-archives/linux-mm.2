Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E067F33A6B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35F26B0095; Thu,  5 Mar 2026 09:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCA76B0096; Thu,  5 Mar 2026 09:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E7A6B0098; Thu,  5 Mar 2026 09:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 921AB6B0095
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:05:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 445FB16019A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:37 +0000 (UTC)
X-FDA: 84512182314.08.BA0C491
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 52148160009
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nGT27+Xr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772719535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzjxtLVX4aZ9Xn4loaE8IU9XMnkErcOMpEom5jghF4I=;
	b=oRIDblaLrS1IfoVPHkFQvCL3wK78xzpjYMD2WVVi4qYwXvFCmcpKvNpvnunleCag+A6GB/
	RcFlPuts9gJ5hVwcUj3JAmY7J6j1Dhg6Gke1UE0fjc54eH4ScFy8F3OeJo9SD2P2G75jjd
	R4x6ltXHGwMHjMb9oL63ZhqQBGKjTZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772719535; a=rsa-sha256;
	cv=none;
	b=7G2ledhwXY+OC9wAorezL8IK1LzUZlL8knOif/e9vB5Ycu48vEB9CFaHix46LAKuMZInzp
	ONL6/BWSfV9NwVNnriQ0N01Wu/LtJ6rUbW2ZWoUUuqxxEzQPE0ZAfTC/mtS0u7DzCCd3dm
	jZfLHqF72Yyyjs5lwlsmx/zpLGu7Heg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nGT27+Xr;
	spf=none (imf08.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=yzjxtLVX4aZ9Xn4loaE8IU9XMnkErcOMpEom5jghF4I=; b=nGT27+XrEKQ+huhZhpfxS0syN9
	k5VL6LypWaEv5PGfKlW2uvE4ED2Mhw1gbdQ3n1vaokEQNV5VBWkIZOwp1R5V+xab2eHSqSO1OnnLQ
	v5zfEdjzDDxNY0rGueBCN4Fj0DhZoxdTb/GxEHpECxA6y5gUmLNBt8YOKM2qSojGfHOsUYxbMwbqy
	kfYcZxT2DogeWbaTT93Il/oIUV++Jsi64GHhnbjvDjLPQbtvsXUPUFnu7IGdT7lwlMK1Y3IQ5Ysr5
	Mt15Zhkvz1mutWR4rUe74xdd7IRyX5bc9Ds6UGC4y0YGMYIPVgY2K7TyCeFvioEwWJ8OzcoK/007i
	//R5zWWQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vy9KR-00GmPM-Sc; Thu, 05 Mar 2026 14:05:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 05 Mar 2026 06:04:54 -0800
Subject: [PATCH v2 2/3] mm: huge_memory: refactor anon_enabled_store() with
 change_anon_orders()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
In-Reply-To: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=4284; i=leitao@debian.org;
 h=from:subject:message-id; bh=8MvG288THhLWfJJ4mUaYo/3vClGLv+WQIbkWm1MV/5g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqY2VV0LVf2oYQNaI+auUogab27ry65Y9dWDR8
 BU2P6Yfy9qJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaamNlQAKCRA1o5Of/Hh3
 banID/9UReNmdhAtIZuZaJRtVCeXACeRbunZZfigbiFNNDGMGi8v5jiVxQXIk8fxr39QS+miVE9
 bEusC1qDWuse5TWtbybwP3w/AfdKED/W/zVdhzckn12kXlIAG8SYmv77oJ2GvpUDrfX5NKKU7TO
 moK9pJLUF/617hEyjPiTwi65510wL5PE8pEsZke+Gzydr0Lw1OBI6hukmGU6EYc9RytuUezdv+5
 yjpiqOMS9TGQMqsFBZwGZUv6StA7/O5L4v8avBS+u16s5cfVMrtnFL6LKp6T7monXPJO5c1ly1K
 ZAWY/F7rfNtBzjWMwKpAjrGrMKkaoP5y1L1q3CVH+3GiDSb5Hml81XW1pIbCsJ4GWDhUe81PzfZ
 Cr8XGJdVGHY26Dpyqf/wKCz7ECztK/SotG2uLv9/B0whwZoXnD0uRBe6oGYqeC0qZI13BGiskGf
 gH8HmkFZyc+YYC/BWzoSn7sJ75clslKyKFxRzoB6CSuawfyxbXuhFu9RTS8EMIPvOwYFHHYHdgP
 1YhX+2y6NxmQVRTB4hBTzbh5ynQOyLNtXvRhXv24LSi/TbBzvpks1B+19Qdp3qsKu7GDF4Uhea3
 Sbk35K/TwcyAapxYvnn3I/+95hywmneMVM4mmqFujSLr6M75oA7iTMdQsZIAsPXOyhDwpwxBfSi
 0/w+qeowpgy8gTA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52148160009
X-Stat-Signature: cmndqrjqeuyy1wr5y5itnybpuzsac9pe
X-Rspam-User: 
X-HE-Tag: 1772719535-655175
X-HE-Meta: U2FsdGVkX1+gBZjt8x2rGcpkbe3S/sxxDNKilIDtm8o2BWMjGfzVg6/QQmcsIjZ7HGtuhNysaRMdIdLSGb6nRE3lPmkgb8bikyAGP8EJClx2H/PBKWwNohMo6DzI2xL5T1EFJ3l6eKoyieTKnWFveTVn8ZfP/LEvwXMSpWRCAAGKgTvA1Lj8QVQ5/K23ukPdPCXpGERmHYr/k3O+Tli5xepIUU10zniakcvZ7CB1gx9fY9ZckQcye06lWSCpbXQlmfr054tI66xA7eHkLiue62N+xkruD4FW5NyzLNGhWMi5GMPgikHzQB4ZmTmuEFoBKLbJuZXAO5l7IrR5KxOjmctuttoBPe+GKI2gkbana/iOWVKnZao1KBqWzcN33/5Fak1TXk4pt5Sc7Ypdd2EBPcfCTp+tO1aYNq9ByBp8Oh8HUsKk6C2PT3mI7mdtFzgX94oVCoCOqS8/fOFrVH3GKoeutyPCL9blRsqyYh9h0h9yXJnCOE6i6THP01YJ+uFmoSgQsfND2LaVxa2Z7NNWr4yeDrLC4fKtv52pOLqvdrHllTiY2ngbUYKMSlCUtjeq0YzTzjse75osmumrWiJCzT1YhEudOQBjGwv8gAp41wPVK1Y5LyJzPiTHzusBEsEec1Lm1FydH3KGhNo6P+woW90LzRDKaGO3mnr6QRQW8hX6q9WDDdRwXeEpYQxZH2XblIV8Om4cZKfxcKmCaYf1C2HXdv381orK5MoAWIHhJ3lIFTMZe7zBxfsHvIToruMA3NjzU4X2W/T3oSbOPZKNs6ztyJSRAQSHKqrHKWz8FFPqvoHZDJWUQAasFuA+j777rDB1lCv8JK2OI4GNuBcS3vOpLLu2X6UTMHs1Iec3zMbEVGQmA2lNppCXn7jM/xp32OA7XX1MPdlkSKg1Rm/9smai1hAeNEhZrPbj1nhzAqjw4vZtPzAslk6kgthupc+BXsWSxYnSebpo2fC77mJ
 YfCp5Z8B
 BtK5zwMIfFdPFs3sxk9t/yS4uVHQ1zY1dSggd2acwVFr3I1njYyZ4kqXVQEx9kn/HkrtFHJ48LRXtvFT6WIOXpguFh5UV03v15h/UGBQvRUN3w5GB8R3LxDPFeoS0VxBUcAfa+NPavUhNF2N7mWEenxPCKT7132VgN2VPFY8WiC2TgD7bPLBeaNhpT+wRlYMSUk4C/TpL8+MZra8=
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

Introduce enum enabled_mode and enabled_mode_strings[] to be shared
with enabled_store() in a subsequent patch.

Use sysfs_match_string() with the enabled_mode_strings[] table to
replace the if/else chain of sysfs_streq() calls.

The helper uses test_and_set_bit()/test_and_clear_bit() to track
whether the state actually changed, so start_stop_khugepaged() is
only called when needed. When the mode is unchanged,
set_recommended_min_free_kbytes() is called directly to preserve
the watermark recalculation behavior of the original code.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..19619213f54d1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+enum enabled_mode {
+	ENABLED_ALWAYS,
+	ENABLED_MADVISE,
+	ENABLED_INHERIT,
+	ENABLED_NEVER,
+};
+
+static const char * const enabled_mode_strings[] = {
+	[ENABLED_ALWAYS]	= "always",
+	[ENABLED_MADVISE]	= "madvise",
+	[ENABLED_INHERIT]	= "inherit",
+	[ENABLED_NEVER]		= "never",
+};
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
@@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+static bool change_anon_orders(int order, enum enabled_mode mode)
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
+	mode = sysfs_match_string(enabled_mode_strings, buf);
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


