Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E90CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9892C8E0024; Wed, 20 Aug 2025 01:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9392E8E0011; Wed, 20 Aug 2025 01:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8284F8E0024; Wed, 20 Aug 2025 01:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8C78E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:37:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 309141382B8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:37:11 +0000 (UTC)
X-FDA: 83796027462.25.C470546
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DBCB1A0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:37:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sm5nir1T;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2YWNQ1R3q2yuyqJw9ejU5xCE0/f1sakMXwMmNRUMe4=;
	b=Gsf0jSYBtrJAOO8m6r2RAfrgDiABY5Fxwz5dJAKmZK6Lp1VKsJj5Ly62ehSaLlHv7Ji8MI
	MO76UEeByxW2oVeN50Qw+fP7R1+7fQEFTsGkc2g6h4LBo6q2cIh/ZxapnRii5vMozSCZfj
	G+6BxM+ufm61LjzgHhV6PfOnjLjR7Ls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668229; a=rsa-sha256;
	cv=none;
	b=wPpVGk2zHDqs1tEaK9Igon6J3BBgQsFWmhn8sbVPSbXXF3KaM0EOz7nZjChdpt6ZD50xdQ
	hu5X5f6Ptg77KkolQity9mPYyn8znbbiCh5CNKN8s8BJAsfyPdDWvJ/cHOY9EIo9iYW1dP
	IrMPbMWRoRQ1/bhezk2zIMi6WttqomE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sm5nir1T;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n2YWNQ1R3q2yuyqJw9ejU5xCE0/f1sakMXwMmNRUMe4=;
	b=Sm5nir1T/ujZc6uuPgEtOtk9Ch6R7WrsZ/CMjDacOb5FMpRVRx90L8raCa/9sXKYAB3RKK
	a3ZDze1AD3VkgxaovQPZYmCXHAMP86NESheytU6dw6INm/gsUcAB4k7NvkdxE+cmTIarv1
	Of6CWJWl32KTppDTmUCtEURAGUPuJYA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-SD3MvwL6PoWLgsvGYJ6o_w-1; Wed,
 20 Aug 2025 01:37:05 -0400
X-MC-Unique: SD3MvwL6PoWLgsvGYJ6o_w-1
X-Mimecast-MFC-AGG-ID: SD3MvwL6PoWLgsvGYJ6o_w_1755668223
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54F0C1956079;
	Wed, 20 Aug 2025 05:37:03 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2ED4819560B0;
	Wed, 20 Aug 2025 05:36:54 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 12/12] mm/kasan: make kasan=on|off take effect for all three modes
Date: Wed, 20 Aug 2025 13:34:59 +0800
Message-ID: <20250820053459.164825-13-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DBCB1A0003
X-Stat-Signature: 4qjugrxonet6uwb71q9t4iybmeofpskh
X-HE-Tag: 1755668229-985967
X-HE-Meta: U2FsdGVkX1+ciqwikdFSy5Imv/Z6bTqmInRnGYhS4uc5KTvetrmQeGCBKVURGGhJtuOunz/mj+UgcLrG6EE9+P0l2rx8AGc6mbin9F37YvZMqF1dNO3bJdRN/ior/wjBqJKZl/Ty73OlOYEu8N8ex4XNJiu7Mio1AcHcwargJ7V6ZWRDNCdXUKA4/0BNwVuRJszuJ4fe7DHYfZbSo+//rA5d26kq+y0imwXOMpkANE/HVipzIJh/8KWXOqag2gTR8eoXTlOmvP6WiKlBeKP98t8OKO5Ub43noB6SjYZMXzkWpLcqJIiaIyRTr/nbwlu0U32dCBOu06XTQBDgOcbs9MRsqRoQjWLpAwwUp1o4qC0pI/Rj76fOpZH38Y0xIMyM59gl5Vl1FIPRZmFM0FeqrVFKVxlKSKRpC7ZcA9aGBTRj4IAZ56HodFDP/zxqSYEt7baKtmQv5J4JxEmJlzckFTK0Goi5JHleBvRso/Zjptb76uAK7U7YrqzMS5FFHDbPhk98UHPFHy6uobdNPkn1iczYdcn+pCm0Alw/BJjGwdvNd52G2nICLsECtaE8+j7W6cAT0rSfhAEH/grMQaYwslhHBi8CalO1dZWsuJS6Ynyk7wkwFqdxb9gLsW35iyzKhZqnSV8K6j1lh38m78bmdJr+7Q1ChLz3SWDKikO84XpPdTaNTo97QdmuUBnsJS9VU2PyuIqAdvwjnzxbC557IibVNGdv2IkoCzFC507GC3IvwUC8hA5OHnMASiI89PwKhdayXp0RJbo6zK9gogubS0CQJAZyHp2NbiSNrE9xYDTx2jQOdM+3upq7VdVJ7vZOGDq1E/0F55urNrjzXAZ4ED+bvYnrScPypjcWsTTDlnU+ZG98u/JuscRzmHe62UZnvSy15oYvbZvdxTtjLOracUF5cqQaFaipptwimcftxOy7/sYN+tb/lxVpw0/7mHJiovxeIjB8oPrcAFf6ZCh
 RlRgEwcq
 MaWDjw/w9cDwHNdtMq77kgNIdeCLg5vxX9MDQJm1XJopURYjxt17ImKOBOr5PJ/KBHmhNOJzOExhfYTPgjv/TZM3uhQHaSn/TT3kz4kKPIyLLC34HHspyZ8AbTDoz8XzM/ju8xY2osUUM120gKbOGkID0Nk8BT5tRZYx8JeheuhCgZcuC/GxxSKZ7L7YmoLur+Q0H0N3OSPuGE+rCJMYfxVhKl33fxRy7ZPf12qHV3nMiMNuia7zXo+Gi5xrjQhZKrwLo+bRnsJ8BiipN2zYe5QWno2X5wrRcpX5R5Q+6v9u9UebTrSuBaylEI/CKdVKfn4kFDNGf76C8Ds10PfSuzdvNxYi62ahyMebTsEeZlVtq5f5bSRONhW/Q9/mKtP9qtV6MkfoAUNRksGoYwTaDXj7Kbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now everything is ready, set kasan=off can disable kasan for all
three modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kasan-enabled.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 32f2d19f599f..21b6233f829c 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -4,34 +4,32 @@
 
 #include <linux/static_key.h>
 
+#ifdef CONFIG_KASAN
 extern bool kasan_arg_disabled;
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
-#ifdef CONFIG_KASAN_HW_TAGS
-
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
+#else /* CONFIG_KASAN */
+static inline bool kasan_enabled(void)
+{
+	return false;
+}
+#endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return kasan_enabled();
 }
-
 #else /* CONFIG_KASAN_HW_TAGS */
-
-static inline bool kasan_enabled(void)
-{
-	return IS_ENABLED(CONFIG_KASAN);
-}
-
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return false;
 }
-
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 #endif /* LINUX_KASAN_ENABLED_H */
-- 
2.41.0


