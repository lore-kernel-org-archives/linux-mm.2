Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC2FFD4F0F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B9C6B009D; Tue, 10 Mar 2026 13:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5D16B009E; Tue, 10 Mar 2026 13:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1826B00A0; Tue, 10 Mar 2026 13:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFE6D6B009D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:58:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D70F1602AD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:20 +0000 (UTC)
X-FDA: 84530912760.15.5660FF0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id C00014000B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qHUYXrdG
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuDf6OJ8QUnJ8gfCrD1Pap3z37T2KxqK0+T2vb4JLZk=;
	b=5kzMuNEYveKUbGq2ICRvKYfcLKTdDcCezj/7cqkxqm99bgruy98OiOWLXydsV376IBktkM
	0tXCGtGTjHaTVSSEyDFQ1OQMaYLz/LKQNK8moSni37cgQPZu5tp3DcObEbDB5+RaWG79F6
	tl1t0x6qOJKkS+K+GJVv/CL3nGRRjfE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qHUYXrdG;
	spf=none (imf17.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165498; a=rsa-sha256;
	cv=none;
	b=pUIia1b5nK6mSEWIpcVY7lk3Rk4YJjHMd+x35nUPyeGPVFQ/gwpP+PWUDDJ9KuUg0VSAin
	LbHYJ8xA+CKzA7nhlUCurCXCqZscn0XwlctVHdh0vl2bRpA7SQBtuc10lsxlaDeVMDYKx0
	duE4t5qt7CzE/OIcprouoOGgaFoeoh0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=wuDf6OJ8QUnJ8gfCrD1Pap3z37T2KxqK0+T2vb4JLZk=; b=qHUYXrdGbS8JLo9Z2odggADZmV
	Qh23xRIiiavV7kgPHSRVV6T5NzCiWjqEf7Xalfj+D8A1p6jSuxZPLG9YVwaocYoeOiu9WKIRqgyIC
	61QYgR0vGFjx/i92vfztDJO1hysO+kRAfVY52j+XC39tazR/x1VwbZBYhTZDExCQzOM7RnWKJA3HL
	WKu3gPS+Dhz1mUTtNqIXUEMiEvKCXRF39ODy/QOGSs6XsEMVSzgWVy1OoLZWux/PG/KPhanyZGPfI
	IsvoK3/4vN9gjL5ENAFkAYUGs3GsHz464pNAWi1sERBgCqU+x3VZIZcDfmsIiZT8VPWG9zlJPy8An
	10PyWNGQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w01LK-003AZX-M2; Tue, 10 Mar 2026 17:58:06 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Mar 2026 10:57:08 -0700
Subject: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store() with
 change_anon_orders()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-thp_logs-v5-2-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
In-Reply-To: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4470; i=leitao@debian.org;
 h=from:subject:message-id; bh=W0pmwY7DpMzVDcPqXGmH/VcJ1h6MSXt/labrb03moRc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsFubY8Fq8JCtehLEcWZp56AKZ24T+7XEXQM24
 7Vo9qImBG2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabBbmwAKCRA1o5Of/Hh3
 bd0XEACvvOzGt+2EHXj4MyyuyZzPvTkSZ+Z9cKHtKT6+fOAAsVPpRzLX0pe1j+k7sNoxoMsogkv
 591ZDzPfcUd14WHhuF8RJk6Y0utn5b9WlDNFduTUzaeroOF1oasvUqJ/3tQgJf/vmZR1ivwqDcZ
 gM/J/zabonqKwI4wXwWCzF9sgZhEsXFE+Jty15ip5o6KnOzBFZp1LvwheVLB+pNKP7NDrcKF4Rc
 XbB9Gr6zK0oont2/PRMslOr7aeYJUlFFqn/nqZ1BdFNly83uGKgPg2OISVaKZ24yIyiC4yZdrtA
 qMM9pUbZqkyHVPmSalm0Z/NtdxIxTVk3M2YIcRBG5Vyisqh4NGZWSwc24pz/Hd9zRurAGOKdmUt
 2RugkypRkI6j2ZtzEI5TdvJe9AhXjqsHIZQGv4mlMx/gXAZ11Ihlhdvn4W3xvy7L7/Z5Bvpyqur
 lo2WBj/tl8IwVz5jdca5JxU3ejm1P7zB37Ixvgu9iaaJGodfVklbJiI6XqttzkHvQJWqF26wk1g
 susxa1pX/st3V+K2yaf5ZN+vRysBMIoyWuqTMHO6xqdMYPx/QKE962oapmrfckhthgAr4rVcUmn
 sh7h0YQRwL50dc3WYfYOWGM++hFvnnTFFg0roi+zarn5a6AhAvw7caaQYdmLEU5qdr1JOY+9tS4
 YQQh0wVY5S6BZ6A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: jasqkioam4iopw18nmb5smfrk7femc45
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C00014000B
X-HE-Tag: 1773165498-436715
X-HE-Meta: U2FsdGVkX19VxyAVWquKuBDKpGnTirvSZmgsA4iAwTHIGSRLokCLw3G160SmFh489pd+XPR2B2bwv+1Qe2lxjBPXbSpPYw1BCJFugMmAUYD+x21Ag6RPq++ZZTNtbWzl6/Zl9J5xeCrNdv2pJ+uzN33JtCzrPrllIxHNO11qtwznnU1sTTn6KKh3fZgVEpDP+wL/yJapfoYlVhfrpu0gchIdolwTNglxhzyNg48TtWWa2xEIcqeCFp9cIxzRGfQgc4K7xRZsQi5rojkXBSGJ4XFhJfAZw6Mya+k6K6cpG7B9pT/wIOC/lkJQOEAn4Bzmu/YAF32pzuPwyNKmmr6LlB0AqHlTH/6LrkMZxUeYBXk8UjCloGIjrUe4jzz7RFUShFeFZ2Yht2pJWxmNJGJ8/HL/P+Ot0MzFDdkTB0jb2mQULXrh1tDsKp7XsAOHp9BcW78DE+W+K/mEkViKIO86K+79gjtRozHEsppV7oZpp+vMD7ELYKpfTjHzovlA13Boy6tUcr8Llgz8qCpIQyPAG9EvyUdJ65o+vDxs+CnHUPCY7qKQ9ljL48bkt1cmzXFUGR7Fpiy+kx4/FxRLbkbotFlJU3YQCwx2cqzTPTh5B1dE1r9sE3tN1UlsGFKyX1pO56QuSk/f87GRhIZv7b9ecmbdxTgbbb/VHKR1uMsdChEpspzvyeDY5hJ+ayHm1blLEU1P96IVviv5M5C/v2RlUdC8sULcjZqwdOkf33Lx/e/DHhplpekAIUTNLelSTkHtv6pCmRS0aCSaJ0tcGLX6gLNfBxJATeUMchCb4s8e5MxAdc6IRnkQiu3Xkw2Dgz0VwRrP+141NLYhRfcdyJvi0wnAvVrJf/ooOT/kZZNef/X8YAEp7Bqogj7KDNerZ6x8UfVvRyQgKaEsVRaY24tkZ2X5sBja9GKgbv2MjmWaJttFsYAK1Y+nj9ajm4p0eL2yV+UrGduB0VHZDpc4+T6
 uSy3Umyb
 h3TsxzL9H42dID3mDTnlrM5PCCGaiQQc0XrjWoBukEDuOIbmJij59K+xOBefc3vG/X+hSkd3KPjBjbHDQBejwwG+aYvHRfRMCV2HlgE7WyuJQut3ixUZIOTmKz2gufNEj19HlCprR0aPwFJ3ZbjiDuUWLy4fzglKnRdmWglvZrKJFNw6VwYqh8L/D2h+LLMKq0O5LML5e3JdjArH25ttUbAFYeaFpALaoirX8
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
index 8e2746ea74adf..e19dda5aaf195 100644
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
 
+static bool set_anon_enabled_mode(int order, enum anon_enabled_mode mode)
+{
+	static unsigned long *enabled_orders[] = {
+		&huge_anon_orders_always,
+		&huge_anon_orders_madvise,
+		&huge_anon_orders_inherit,
+	};
+	enum anon_enabled_mode m;
+	bool changed = false;
+
+	spin_lock(&huge_anon_orders_lock);
+	for (m = 0; m < ARRAY_SIZE(enabled_orders); m++) {
+		if (m == mode)
+			changed |= !__test_and_set_bit(order, enabled_orders[m]);
+		else
+			changed |= __test_and_clear_bit(order, enabled_orders[m]);
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
+	if (set_anon_enabled_mode(order, mode)) {
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
2.52.0


