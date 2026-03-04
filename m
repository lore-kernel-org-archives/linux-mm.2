Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147F7EB7EBA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922986B0089; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC0A6B008A; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7979E6B008C; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC256B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B98F14053A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:23:38 +0000 (UTC)
X-FDA: 84507994116.13.ADE9746
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4068740005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:23:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=F7wDwb0N
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772619816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mz14ef9NiersuDV3XBNcZS69uEpO5WM2VO5bpvtQX0I=;
	b=4i3eQo+U6UgF6eM+5y3hzk/cBO5CyKk6EzmAlNDziepQbcGmsXjvEKPR/YWftHZRXUj/Fy
	vquHuR9kCS6BMLxKFpkrGydtSqPXrn4KJEIAG1seN/wIaRHTYYjX99KhqsZdPDEvRJGrcC
	pbiN0+7ocsuJ5k56I+HqG0lEUWu0WFc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772619816; a=rsa-sha256;
	cv=none;
	b=ptP5iJVDjqpf56sHsaT5PHvka9Qgpjax2OXikisv2UqIdmzfWDhb1wQSTXydAz5BhsZR0c
	6JtbkS/3JZnw4DctNfDY43tTqCW+b7sV0ystFgDusax/OR+nbMbvJa5TxgFuHVkg2eg6C0
	9FagcdDbK/F2fyyjnSYNe5ONs2jKqLw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=F7wDwb0N;
	spf=none (imf01.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=mz14ef9NiersuDV3XBNcZS69uEpO5WM2VO5bpvtQX0I=; b=F7wDwb0N79HiBv+8XaGsvNsnIa
	/HRDZswde0xtl4S4JgMYtvFYPqaIAM5sg25KPuqdJuckO2ZGOTjXgFi7cXd7H15wvMuqmobL2YM5K
	m6UjiKuLyOBrO2kW8ZVL4lbnpERHjvIp8WB1xpYtCMZDPsv/CB2GxGm9SMh1PKCC+ozd/49By84OG
	c5fbCk3DfcUiVAbaibxj/MQ0PC68s/NJvbXURtBOQJO8sYW/kvasnHzZzYrKDQHbd+W7qVqAcvPUu
	eUVlXbxFbbYBBsAYGrWX0ps4A223I6ReGObGKqkkq2W4EtYKFcALrErS4lJto6qS5JQtGmdGqGxGF
	oLufxumg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vxjNq-00Ft4F-HS; Wed, 04 Mar 2026 10:23:14 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 04 Mar 2026 02:22:33 -0800
Subject: [PATCH 1/2] mm: thp: avoid calling start_stop_khugepaged() in
 anon_enabled_store()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-thp_logs-v1-1-59038218a253@debian.org>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
In-Reply-To: <20260304-thp_logs-v1-0-59038218a253@debian.org>
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
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=3364; i=leitao@debian.org;
 h=from:subject:message-id; bh=KJ10dV4a/iqSKDAjRDFawsGHr65Ti4HQ6vbLNo+A1ow=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqAgHqsA8llrYYRvJmrXyyG81r3MDvEyYXC0kv
 jtvBgHnXKSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaagIBwAKCRA1o5Of/Hh3
 bfJWEACsT2Lwnd6evuyylGB9MhI0dlfMq/K58pIkwRcQSxpvHJDAFs4poR3Rw7fqCyjveDBJtoP
 XR3q+w4rRL+E/E8bPo06ArayKgzNMK+JogVvHEBI6nPEqd4YS25iUe6GtJnrCJzhMDm5+xxf4s0
 GynqLW9RQl0KqubaE62xIsUxvykH9Y7PQBn1FsLLtPD/KnDvEZrixixIrDAZh/CmjJnUNh+xLZB
 Ws+01IqaH3ri9s3d21DCYNVyYzW/39Kj+kd6NXDT6HQIbXgPIKQxkqIew+qHg6V29uQdZh4d9sn
 pC6UT1qzuGr412z+JBayvZs6ltoPJp8nrpA/l19vrJJz/gLEcR7Xxpf2TzQxck1L2GVT6CPsdVg
 /LHmrS5B8rrE2hBCqgtHCOSVHkabvJCckl3c+PxUoUuySxuPA520O4zgMqJZQEyIGV4+ZCu6Iwj
 jFV7RLCdyZOXPWkq/WBbi2Z3nPT4iVPeiwmTo6iYvDWkEi9lrkhE5Km1cVXpUMit5D+GYrkn4Re
 FAiLH2Sd2rmW9Ks8e7/hD527O6jLiyEJjTPeCH6tLVWemTTdmllxDwpyhV09jyyrmyaIQ/p7a+f
 TlTVTnFwbqQUnWx7khvX/HtIh3zdcpOjbZ+1MozHlRwWYXo2XB67fYTg1dhghJLv+uCwKIrFyjN
 xGgSTKIol6Z6sfg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: 6gbcedwjufpaoederxrxsce4en8aww9f
X-Rspamd-Queue-Id: 4068740005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772619815-438475
X-HE-Meta: U2FsdGVkX1/bthbonsYYo/UDq0fgv/L03SMS7aPQ74McI4P4BIo2nmMZ3RScBuWKluBoJvs+DF+cC9d8r7bWa6Tprh878j14IQ65xDwffqwQe51YyjZjiN5bzDsmIvHoWC37MQJgz+fbu9qXNoy82UQrR3UAagt6SynmJtBMpnlG7+5ySzccHT/8ZY5SmaAczsHf0NpX3FaAdFer2BsMvDv6potzEpynYop/wZoUqM3MLGviqZgofuHd0AzckAylYP7Bjz9lPLJh/TjNV//InlLH+QCJ9JarJ0pWsEqGmmJaERUhn7SBkVILZLBAYQkJWVUqb85K8MqSw/mqYO8ZGK9Psegv0ssBicxR/3O2wNImh4qWvY4/mFIbe5Ei10rCUVmppMEaAxBhXTg4Ac2PgAFhHoXQTRfi5aSogx88dBnnBjxuSrJi1CKVB14n2ckAK9UPT0EfKokhdt2B0zsUQOsCLo8AHhg7hiGbwGU+Ry2G9QY9b5vXh6zy9vVCfMVaLkuDl/fn69SqXqdt8pOcC7+6L0BfxH8CVKYT3QP4BAGs3UqmCGCWwI07NePvYsl1PHjJ8vAt9BaUel2e0XNPW89zcuQ1NZtTN+1HCHYkcUDPJVgQVgU2bT84ePWPgdFZzbPja9MjC9U/ouR0J2C8whNzvaXo2qGkVZWlDbDHGJeV19ZBCGuGX+C+nVp7VMa7rWbRBDJSkjf3Pwmge/j1i3M2w+kYoNbrvwuMsMNZUyxTegv/fXA9uV9lJLvo6pLC+v1KqsNFLvIBn8iqTzuIUiulAaJW7aZ43ckU6A9WpkQ2PIU82dy9Oe+1wDjqo0eAFzmZJ2uqbq04grLI+abhmphA25jFUrE1UpJAFu0L3IKgMbs2ng9zDI6Pp89V8gjhOAnC9JVU9yq+DZD+QTtjEWs80Fpu8dSdFSNGzbcDsgpffnIifwxG/sJ2rzTiJpfuJwC/bBZ6wyNCfa68/iV
 3fBKyV4u
 rhbsMYCBAeYSvgc+ei+RaTCos+CKwtU2ZyWxfOw23LXoSV0izIEEkJde6TipASAFWpmtwDsuBOu1xKI2xvg7gal+rIa7HWPf1TKeC6Gc0pDs+WtN3rvzV3C9H44604qXBwc3/HMj/JqmmBqyssRnAP11r7a24fWWOCFPkgK+4tS2MWyKk3AtBXt+jtnt753ak34r19QeTQTY/a9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing "never" (or any other value) multiple times to
/sys/kernel/mm/transparent_hugepage/hugepages-*/enabled calls
start_stop_khugepaged() each time, even when nothing actually changed.
This causes set_recommended_min_free_kbytes() to run unconditionally,
which is unnecessary and floods the printk buffer with "raising
min_free_kbytes" messages. Example:

  # for i in $(seq 100); do
  #       echo never > /sys/kernel/mm/transparent_hugepage/enabled
  # done

  # dmesg | grep "min_free_kbytes is not updated" | wc -l
  100

Use test_and_set_bit()/test_and_clear_bit() instead of the plain
variants to detect whether any bit actually flipped, and skip the
start_stop_khugepaged() call entirely when the configuration is
unchanged.

With this patch, redoing the same operation becomes a no-op.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..9abfb115e9329 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -520,36 +520,37 @@ static ssize_t anon_enabled_store(struct kobject *kobj,
 				  const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
+	bool changed = false;
 	ssize_t ret = count;
 
 	if (sysfs_streq(buf, "always")) {
 		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_always);
+		changed = test_and_clear_bit(order, &huge_anon_orders_inherit);
+		changed |= test_and_clear_bit(order, &huge_anon_orders_madvise);
+		changed |= !test_and_set_bit(order, &huge_anon_orders_always);
 		spin_unlock(&huge_anon_orders_lock);
 	} else if (sysfs_streq(buf, "inherit")) {
 		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_inherit);
+		changed = test_and_clear_bit(order, &huge_anon_orders_always);
+		changed |= test_and_clear_bit(order, &huge_anon_orders_madvise);
+		changed |= !test_and_set_bit(order, &huge_anon_orders_inherit);
 		spin_unlock(&huge_anon_orders_lock);
 	} else if (sysfs_streq(buf, "madvise")) {
 		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		set_bit(order, &huge_anon_orders_madvise);
+		changed = test_and_clear_bit(order, &huge_anon_orders_always);
+		changed |= test_and_clear_bit(order, &huge_anon_orders_inherit);
+		changed |= !test_and_set_bit(order, &huge_anon_orders_madvise);
 		spin_unlock(&huge_anon_orders_lock);
 	} else if (sysfs_streq(buf, "never")) {
 		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
+		changed = test_and_clear_bit(order, &huge_anon_orders_always);
+		changed |= test_and_clear_bit(order, &huge_anon_orders_inherit);
+		changed |= test_and_clear_bit(order, &huge_anon_orders_madvise);
 		spin_unlock(&huge_anon_orders_lock);
 	} else
 		ret = -EINVAL;
 
-	if (ret > 0) {
+	if (ret > 0 && changed) {
 		int err;
 
 		err = start_stop_khugepaged();

-- 
2.47.3


