Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD166FED9EA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B023E6B008A; Tue, 17 Mar 2026 12:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADAD76B008C; Tue, 17 Mar 2026 12:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8A46B0092; Tue, 17 Mar 2026 12:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8673A6B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:11:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BBB71A02BE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:11:02 +0000 (UTC)
X-FDA: 84556043964.22.A7E711E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54369180007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:11:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CtSe43tP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773763860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FFhVCvaiK4sCPHtuUiD0P0I+e7xIUEsukRzL1BWPx8=;
	b=r0wr7CnkuUWqODX9E6f+G/zIAqRG5CagX/uOFLJvQikyMIENIQPmbPdAB48LyCpr/fNYOr
	V/HuPJKWtYjLEeWSPblDa/gocD1+QQ4lYiKCrNTqrg44bCh9M7Q7HfqDPMQmJX9vders2J
	ayUEFt8Xa+uOqiBJPIeFnTW0rQmR2lQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CtSe43tP;
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773763860; a=rsa-sha256;
	cv=none;
	b=cyN/2GjhZQuEsdY7K0jMo8zFd4jOv1zuHXrGv63KKbrCfD6RqUBsq9k0FVWTmsZMsWqyO1
	YMyMJz5IcF37MtMu9t5On5V53f1kllOVoN0Be7PgOCqE1zXaD5C79pIo177Uv88wIJGFWH
	tCWmzWf2sDng9hCQrYoOlpHh4w7qyHc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=0FFhVCvaiK4sCPHtuUiD0P0I+e7xIUEsukRzL1BWPx8=; b=CtSe43tPytaRWUYVmPZ3ImM0bd
	jctNcyYVgObxGlyQdHxG/Jk1Afsl8kk9gTvJnGMq3vHRYQRHICN1DMF/bFBRnomPhAwpeZmKl0FQI
	fL6qPvGnwVtBvwPtGNpcjzenlDNwzCVX7R4Gk5lxcEfhP1/fkjtzZgDQf6HUFYlOnTAvPJuEwbbh5
	KeTbQzTPtQpZMUaLljjvh6HFyiuQpkP92uduNo/TJ0CtFR81alBmOAJkMa29ddkD4BX9cZQyNrGw4
	P0sz/jszwNtpaQ7P2WFfLY6WyQVsG6RXqjouO5YpRFm54x6TH3ock6KjXxw4b1ZzC6PTOvYAPWkGZ
	TYcTyzHg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2X0B-0030Co-9e; Tue, 17 Mar 2026 16:10:38 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 17 Mar 2026 08:33:57 -0700
Subject: [PATCH v7 2/4] mm: huge_memory: refactor anon_enabled_store() with
 set_anon_enabled_mode()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-thp_logs-v7-2-31eb98fa5a8b@debian.org>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
In-Reply-To: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4477; i=leitao@debian.org;
 h=from:subject:message-id; bh=uVMygvKt3H9/z7XcvkSzsG4Gn2PVtGxvuzCVVJiXtVM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpuXzqHmsvblOOL0RHrdyBTRoL1xrQNiU5cacMj
 qU3CerKM3CJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabl86gAKCRA1o5Of/Hh3
 bfHHD/418gZu10Ilig+OwpDl3ktYXmF0E6sx4ody6Jz+y5mfGOLHu9xplhIyoBrx7N+KdRcBBZ/
 f4fOyBpf6eKsapIiR4wI39KiOpZ3MMU8Val+gr1Oepj03YGGgld77RaZNhs7jddK3OfiN3mXn7q
 uOOpOsN4BWxRaCpXWtAufAA9FvUDLNJPHfswzqDLKoj9G8EggkyMp3cLPVh28u1gXwYkGFAOU/V
 JRoccNZ0IPhbygTmx9aeKSpbXMPfLLkwsuwezNHCJ7dcaUFysMKQsYjMvtdxWkGJvYT7sD+O9DS
 k8cHbV67LLSTLqXF54KuH9yzdRseb9WwuNB89a3FAqX0Y3BkYZ2kgcK+p08ZJ952Tm7XRo9WGnx
 UwjqY0bZhvP1qJ/elndvioRaDwFAbhgKbacL5VGjiDRog5miAB2qhrTPTJwUVWYs21+NH0MoV6P
 ahv1/phBBTWlfK3MnJT7xD69IYKRbuQSFtrAfcJJZ+C0sXrSWd9vOKaN8hx5ozQbt3AGLoqMoJA
 AAus2c7H6D7LrMKQmt1iZ8VCO36BNJ/O+Uh+6wV4jfU0pog6Jd/UUd9HUuzwjtiuK+d1NNn3V+k
 SKaHEaPkSPgUnTybPtWZTCtAI1qlqbvHwqv4cl3/achR7oGN74p2NMJzpA2+2CPnH2cfwJU3agC
 PFT3JdJeocGfiPw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: 19pgmqu7uhytaz3cxe9ywjn4tdme88ph
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 54369180007
X-HE-Tag: 1773763860-676359
X-HE-Meta: U2FsdGVkX19m5P+HZfnJaNS6PhkyCgM9sB2bXu/5eevlLcCHCW1THL8gG/iccZEMbWzXv2hON2C0VqoGBl6/gMz0ZpZxlezk1gS3s+1M7kSwuNKrV3I00UY00QFj6ryiwFq8QEZ0WTwBbzkYmVf1c12LmbQgAPlykjSrk+4spOGXNStZmzI5lEx9ogbgINSVEXYpXfzw1+mrrFtS+ms28lPSXJwhOmUFR9S8w1MyD5C5mqlB1sXQUTBYnDQ6jnjRJmevZM5ytNDsupirHBmWcQJduOUDyEUot0/HPWXKhP48UEFy+lgLcl/QFuU36754SM4PXFuhWZC1yXMILd292SEUj501esHz3u2NaNpTf5sIYH11vjlwfbM5Kh48dd2xbpmmsBXKGzaE2JWPZg+JMjM5KBcX25R6VO7MZ69F3lgz+7hDM7hGNzkt2DPRsXOGe/lniS0sv2B1aCwqgZpkmPuy48eUnjA0JbwCNZmh/7YU81m/pDfGspfu4yPj5cYNj6NuML07rzd89UyYkYl4E9ufdDcbCmctj8j4PVL/aw3HRawq/QR3BdXi04aD8C/ZiYB6jSt4KL5EJSAKTNsHPF9lqJQVrTineMalUZp1dljLV8z6OK0fA9qMyO7+2kmkLIpTBf8EMP9hlkDuVZ26WVpFgr6INX5cQzbRIz6YwDJln6yRJxXfn9S7lzNtppSGliNcqJFCag64gMxe01RNf8WyIhcvWYu/7vswk1r54XbdVeGM8aOq6u/YJfjB7gXRyWYNsOg2qv3xprGd167jaxamHXPk8ZSJCB+9rZcA4HXoos7qKkzEO/FUFZppaFsDnxgLcu/D1YZBLeDzMmEcijvEYkj7qZ7HlJoRTfRRFyO8gpYrIhNWeuS7HLx3ArZtDPwubhrT+45gd+Ada4Hqyu+o1LWzj4D00R22pMa8LyLH1dSRMe4nHwwA0NixMBPT84aVlMTTC5iy98kWtDG
 2hzY8KSe
 T2CvmCwqCB5O3129JXHdgN14qfaE8sONdQJAKY3wvZhYcmipTFAjUo5ERSjoEDLuSmrLPx8kdMj0ghakQ0BUBhDcbZ0LxcixUk+gLmKj/vGEEXXAH5h4d0iKVCpR/4Ln/PpZIFEHwQct2H5r7jzBnj0YQvzUWTMuOMIaxrigAKzT5ow5c2m+JUK8fzRV1eeww/AbLKMTihlHRrlhfuPgkVgrowPelz9nyB863
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
anon_enabled_store() into a new set_anon_enabled_mode() helper that
loops over an orders[] array, setting the bit for the selected mode
and clearing the others.

Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
for the per-order anon THP setting.

Use sysfs_match_string() with the anon_enabled_mode_strings[] table
to replace the if/else chain of sysfs_streq() calls.

The helper uses __test_and_set_bit()/__test_and_clear_bit() to track
whether the state actually changed, so start_stop_khugepaged() is only
called when needed. When the mode is unchanged,
set_recommended_min_free_kbytes() is called directly to preserve the
watermark recalculation behavior of the original code.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..f6af90e6cf05d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+enum anon_enabled_mode {
+	ANON_ENABLED_ALWAYS	= 0,
+	ANON_ENABLED_INHERIT	= 1,
+	ANON_ENABLED_MADVISE	= 2,
+	ANON_ENABLED_NEVER	= 3,
+};
+
+static const char * const anon_enabled_mode_strings[] = {
+	[ANON_ENABLED_ALWAYS]	= "always",
+	[ANON_ENABLED_INHERIT]	= "inherit",
+	[ANON_ENABLED_MADVISE]	= "madvise",
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
+		&huge_anon_orders_inherit,
+		&huge_anon_orders_madvise,
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


