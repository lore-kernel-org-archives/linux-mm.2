Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5AD606A337
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WdP1Lc4s
Received: by kanga.kvack.org (Postfix)
	id 5E2816B05BD; Sat,  7 Nov 2026 08:51:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9386B05BE; Sat,  7 Nov 2026 08:51:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A95E6B05BF; Sat,  7 Nov 2026 08:51:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 239CC6B05BD
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:51:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6EC34039B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:56 +0000 (UTC)
X-FDA: 85408458912.26.5BD3BA0
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id C5DCA40003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WdP1Lc4s;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gOi0SI6UE3i3Ok6KJpgZYZu7b8c3dBRXUCOezx+hkA=;
	b=dgOlEVyCbiygToap2srNf+t7l4jBcr8dyyNTwWBh9bHKsrX2vjgIk98aRDsRCp9icPO23V
	9eQkanyihgZiw8b8c7wc2jNonyWquzanj/uDnkKTn62eFkuJloIgt4GhOUU7iPf+DxH70f
	ubhgoSz/01RFGOrUqEUFkIQDuld94eg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059454;
	b=W9DbdBUq8oouyQa4MaeOjpgSV8rbYuiQQx+SIyVY1SO2VnsQxWPZdJBEXFjFfVISJK46uq
	NqCGP0LwvaTbfc+FToFuDoVbV1K4V7ffYSQVtSNYxhJWlGJxa5tOI2p+VpQ3Fu7PfY8bT6
	UCePbol25yUbK2X51OOIhkPsDnpJWa0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WdP1Lc4s;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-37000e7234bso2608400eec.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059454; x=1794664254; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3gOi0SI6UE3i3Ok6KJpgZYZu7b8c3dBRXUCOezx+hkA=;
        b=WdP1Lc4sh7c+wDJO/8nl+B76yJx+hK1pB7PBKeT6c9ISsQ9p4aL7ajvhEWeCdtUgj/
         mm4EwvxMuqT086PQfsCQ503HTkspxqT2ND045rI36i6o3ElZz+YL36TJtXBOAmKp2oRl
         JBFTdkQ852lC3z9+upSgBB76lhGYCuEYMkOet7en6ufcbWzNKiak0XBRD5nKxiCeEvZP
         xJmrKccpO6DwRyEwhuCvnihR1z9CquSK7EX9fQl62+EjaWyg2HdF8nm/VGYexg0bYQXY
         K6Bg2DzHHEdNmblLr/d9FifwTE0EFvY7DU/BdgSOWo9rS2f1hW9neyRjGLG+x5l8KPl6
         WiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059454; x=1794664254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3gOi0SI6UE3i3Ok6KJpgZYZu7b8c3dBRXUCOezx+hkA=;
        b=ZNB72hw2HSolAr7vgmK9X3NQoR3VCcaXKFiY3nr74jewboZXHL4qpJN6FaAjjp84Hl
         BW3GCN9hmi/EahLG2Vhwe87GH8btorIRaGjXQJMZI7V31Zt8s6HM4GRorX6glsEDv0oE
         rYzamD4Lq+JBIWRQY5kCQczeHZkvl+ZYPSIxSgkN1z3fXTPlNBoDjpvCapuVfCJI7oN4
         ZDJqfGrp0tHeGRMRrj03ncuyn53cJpgdlwc0bQs8XG9CgCH0lxeS9YJTds8IQwQN2xe2
         3u1YOTc/9tlIgCzzpUkSUEZcl4j8zxRWqKAhBarXvbiAbYmoFRlENPgzTQap2/E67acs
         M3Sg==
X-Forwarded-Encrypted: i=1; AKwUvByDT7CEXE7NopZQ7xSlao0Re9fgA+J01zxUymrJimRI1RUHsdX/NaAUM3gbOOtcUoDvwUOGRUfDKA==@kvack.org
X-Gm-Message-State: APuU4Z+y7AVbEvcJv57pZNSiIjmPY2Q88zZrUbUtbIKghP35U+X8s/yw
	jAYrVDffgD9EOezzkJIs8e1VnZS+noN+dI/ptX27Myte66HyfV1yrsVS
X-Gm-Gg: AYBFou2GgBRFDbcirZQ+ngeFKu9U6EoEFCSN1Jq1RcR4Mw+GJVkAKhp7MMhVg5VWeZO
	Yh0QnNvlDOT4/wSLVujr25bLdiNMcBqEGnSdY9Nv3VKow42B+sXjj3pWQXa/2fmNDzu/INGCAgZ
	c8n0MJ4Hy6pywVF0dsXdVeSJCjnLtNZzbtCSShghXar7tONtm1endobXL/JWOGUR0LOjDHAWb9B
	2UsX2fR//i7YbY4B9mmg2itA6JzUeZOTlnyek67UKyAVTFtkm0v1GDDa6XMIJgOeMkRGkcVCv0m
	LNOY6p12fl3eIzkeqm1+Q8CDZ+NAuY11iTQuYmASZm7fR7jZv6mu1bAshp8/Lg6RQf5sEdgZu/j
	ZI1G77KHdC0HGSaFwK1X1/LVr5aOuPUtkMWBft1CKwbnMMH85RyQzKrfE9dMSUvJ+kHjq+zuJUc
	Xozqo9lWi3ohN3L+wYLfvTnt6/JcnJJCnmGZ1kWAlIteJg+nlZDfHuxq0cUHIe4F6Md8F2MAvJn
	J5Cj5NZloo1NjabCvnLhx/3JX16msvEtY2MNYYxQagi0vkbxIPu1AUlk+rlI1wuZmK6KRQ9hft2
	a5sM2TYh835dThAWtk8dCg5bRGedUxPb73QaTFNjksvkxLvZEkgU3Yo8/Q==
X-Received: by 2002:a05:693c:8843:b0:351:207d:bff4 with SMTP id 5a478bee46e88-36f72cc18dcmr8373352eec.4.1794059453503;
        Sat, 07 Nov 2026 05:50:53 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:53 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 08/10] mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Sat,  7 Nov 2026 21:49:51 +0800
Message-Id: <20261107134953.748622-9-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6ntct54y7ycijkf6b8h47n6fj83uzk1u
X-Rspamd-Queue-Id: C5DCA40003
X-Rspam-User: 
X-HE-Tag: 1794059454-206397
X-HE-Meta: U2FsdGVkX18kzABcQ8EVUfKJ+bYg1cev52O6JxKQl+scLEjEAlnVovV3ncakxwkcShd1xN9DfxLymucHz/yBagABiA/hXnoZPAcb36L1nrVOkTxRa9mh9w3ObfYnPmf6sJCkx6TVac1hZfKSZs1SwfU/hs+tuZ24jYphd0mA6NBg3bshE8Zn1yFmbt4aFjm5v+NIHMKblypG6r78UEuxBK/cMLLGB2bzujwneCCQAaG6hmQRg7RtevzpE46l1nIPrtds8sN9YQvZalhbqPCGxyFMigxX9mz6/NBJ2kdTZOs6v9eYHIzcQv+drq7l+0WBAAwPgl5xzh4vQgkl5ZMfpQDbyqFi2d6qJs0tZFHMvV1LnyA4FFzeiUt3pKDgXuLRhAuo9x1fu2uEif6nK9SL08U3xd+AhhkW/3WyEt2TLbGhpKUVBaubFeenKi2TcSWYklv/M+4MEGwYqS8wJ7eFHVEH8bGLy9ZqEKT5ujpsTZKbO0Af0Fh8+A3M8wc+oTvG2fPQZ9RA+FP8BCKzfFybbZm0ZCDlZF6tYIVrCVQmr/B1uTH1Q8HNlofb6qkwd04JwhsEoAQu+3fyMzsmu+7w7N//d7MQIxSk4lrrz+U3M4KABLb/j3dbZaUZ2P8Cj9Oh6ZZ4rRJnCai+/YIbac01GXHPOphFXYTaTGOv8fW31r2+FBwF8McGgEBfIIehOkjTsG/jQvjFHb8Qz2ieH7uqyfii2Ab7d7dWuJdDU20nje26m5feVIcHNjfCMeMF19sxAGx7kQGSI8UvOr706LbMHH6oJZFVqVkac6fK2CNav7SCnyx4QIrKrIMd45KnvKa+upuiNu3+neWCcEka1+ErdzDaBle074YOtyY82BdgG1Vl7lpagMLSEAa3OaoHGfTqjvb/94H4FE3zoX03ZvGmcwlpI2siKf8RrfugSM8+hso1jk8Sr3cl7Zxo5CYoLMvKA5ZZLtd0LWPucFC0nJe
 PkQNZmx2
 vSKZ8p98J0K3zoNpP72ZAvrXKERf4LZ2TllsDyX+WvHk8h4GPnkkU6JK4ej9fN5pOARi0lLlO0oYAh82z4mkCj5eK8OK3sN67hHwjiXKV4gfy6USTjcxDePHwWLJ3gJXfgXNN8sgB762OvUXbjucN3KuppfL3c/Rv56ENIhga4Hk+x0nlhgx/VUlNoJzYggQ/7KonEk1iLD00LqG337cVkUgu1kVLd/q9/KTeywLABXcyMwyTlR0J8eFKuEuJ2fNOVLhKksCz+/12SFtH2LZGC2xC38Cgm0vbDkuytFhcdZkm9eGSQNatKUlA9Btw7BfIOl5fMYMHVktWTSQrsFgKa1LFQecD8OCT6QK/iXShz+XkptyLTOKAQKZvLt+VQdqpc5r1ugPBFsv7CnFxGrpNq9JFLndfVNBoYYatOjWMEjRpdTkrmkAgZDQgmgAJN7LVAs6CKWb3WgZJ10y+UNloQiXDIIUF61aTzOgO7kzw5+Kl8o//b89Bp9/xQTPr23P7v9PD2ABhxqfjsMN47D1UsOw1c0U9vyHsAsXCP97I71hyAur69IJLpd3dgLE5OfvC42V6zxtAuS1D8RTFMei7AxYHY4sY6IpQRbqLpZtRoIqOBhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f2dd9bef4de0f..884e178405171 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3609,6 +3609,14 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -4128,11 +4136,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		 * supporting them.
 		 */
 
-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}
 
-- 
2.34.1


