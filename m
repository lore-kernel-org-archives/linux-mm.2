Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE770CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801936B00AA; Wed, 20 Aug 2025 01:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1D36B00AC; Wed, 20 Aug 2025 01:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7886B00AD; Wed, 20 Aug 2025 01:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6056B00AA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:36:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 260D114033B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:42 +0000 (UTC)
X-FDA: 83796026244.28.06B118A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5D3B480005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gPdTm5lz;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAEMFQ7UJQsp/YRWJnDzAESQXUNpKqSpnHshmUmLX+c=;
	b=ZMdQyQHku2hG52pMc0YfytFFLsJyMGalGd79E0Pq8lznwBGqotWrpi0iWWXPgOWMIC06vg
	u0GeOFCtXByg6R+erDpfyJFq38xEfadEgXqteZxV3v454xwiddBAfSksODfoVlQwlPdIn0
	AXu37xNluBruVZdM+Rmr5MNtZ+AWjgU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gPdTm5lz;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668200; a=rsa-sha256;
	cv=none;
	b=LH645wvTKgOCaoa7sFV1Z8n5bOKqZHcYFhvGXLwFTT07Osch/JBMJSBYfkgTZo8qigKhBg
	6vPCR3/9EuriqCQtUnz1JBnuSWfS5oz2s2PUZzlfpjnmwXk/QbCIS9sn6T/yrX05qXcIA+
	wl8cAjFRkjce1LgZqxkVwFgFrhnJC6Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iAEMFQ7UJQsp/YRWJnDzAESQXUNpKqSpnHshmUmLX+c=;
	b=gPdTm5lzBAQ5uEAk45iYhvkef2Z1amasqGVDVuPASqY1lveeNxSjIyvlQ8XMqdpsZA4m7G
	ZzThMf3YkWO9J4kVx4HX4B21qJor4l6K/9nfUVwwYBz8Yqo9XyxSSCUJ/x/LYH/hz+mtUf
	mA8rO9Bf9CsAhs7KfxNzkjOqLZjbmik=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-ua7zccu4OLWU2rQ3gWmgQw-1; Wed,
 20 Aug 2025 01:36:36 -0400
X-MC-Unique: ua7zccu4OLWU2rQ3gWmgQw-1
X-Mimecast-MFC-AGG-ID: ua7zccu4OLWU2rQ3gWmgQw_1755668194
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7C12180034B;
	Wed, 20 Aug 2025 05:36:33 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 712EF19560B0;
	Wed, 20 Aug 2025 05:36:25 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>,
	x86@kernel.org
Subject: [PATCH v3 09/12] arch/x86: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:56 +0800
Message-ID: <20250820053459.164825-10-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: xnijcgyn54kiog3yssjypmjc14asucz6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D3B480005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755668200-137963
X-HE-Meta: U2FsdGVkX1/xEjN1rCzu71ArLnJStup0d18zSIp+68a63FUypOXCuWdEy86QU6yST/eBFunGl9JhxKmj4MsV5HmZNJLInwLcMKZIB9GLK6ukLZrmTjmbzAgaGn9u0f1bAi+mw623r/+NeEwT5de5CD3ol43+VbyH2A76eb89+nY3BGMyyUhKhMpoOg2v8SpHbpFxBmS/JjAyXbqcmjkC2LkrcLXKgAy6o/42KpN16tF3OzY1aWzYpJjlo5HcVEAYHSKLqHmgiMhnhQyMId0wXPwld4aVnEJb6p14MDW1xrxTF3jHuu8ol2wSp+Gt4/A5HtvIK9ZLfI+CUDvTKoOjHRCOjM7OjrpqWC3nwuosNPHvE5I3sUeAGiTQ/LvKRm5KD2dzdLTz1VO5ZaLnvrYQTAJCAisHkGrPb/CP1AGr5HzvKS8uCQqAaATrhS37mGhnKJ+nEkAJhWczoxQOTNtK/t44mSbO26EillZIzLJp4FU1GXpI/Mw6Jkg47FMdGq9Cre/HrjNZQ6nsfsyA+p42yIYA7LUPaZbN39Mko+7bgCGi9nd6nGWP1F5WFaJXx/vEWKiG4gqpMVDKLY6cUO86NKsjABxG4jhbr7BXwCBRZbNmCpuEgjtfnhwHrSD001sUDLS59WfDNZnvBkBQ+3+2Erl1IeS8qOfRd8ScaUEm17tMWOsO1lcvDuXO9Q3ssOwM9NIQQaRwvy1AdVO4vyOUxUzhEsP/FMhQCSElNuN1wLQ94eIVPvDY62Slxt/lACZVKzv+NDSrNbzSqlLUoNoKQ9hgjM+wkrDVd2B+c2DQY6A9fPNyhLmWaKT1Ifb5Tew5hY18lPow6jBzkG4IGGCLm3h8I5J+5+teBopi0PD2c7Z466Xrb77OjwovsSfyJxelTjki9hMbmSkMuVfsfMLIE6aDYnnxqHcQTmHBKUkSgwtGihtrP7kUX22lsmiXAH5joIjBxKcrT/WrfpQDeP+
 vPRpJqRR
 E8k/u0keGBGFud+JhlI33HipmJWMCZNlbkX2VdKoTV5GbyPKbSWlr4/j5v3ZNfKDS0GaUV7mPXHR49armSMGEJ8K7KQh/faVL7U2F4JdabJeJ/7l+wVOQf3SK5iTimBE3UT3E6/SUZfaB9UMiHVNXl/VITWRDka9aZqXh6g3K5QfjWHYzfz8M5lbtJpcRr1RagW+P7WilvH+jXl5RwGJ1D76JoAReDEtJP5hbB5PlChPU9sl3lv5+S6uEKKTozZL38qnsBPtTxxnVaSn80kj1sgpMRndSd8Yd5hdFb0RbtI8rYA02nqIBKqcOAauektOSlC98t8DMNyO7te1Xjxi+ApHXZrK/J1gPYiyjB4pQzstnj/xG+Y9s+xIr8Kitr5um+hvcLL5PYOmPcOEsnAmSEjmfSxFsuwaPZmfj03bfGvrLWuI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/mm/kasan_init_64.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0539efd0d216..0f2f9311e9df 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -343,6 +343,9 @@ void __init kasan_init(void)
 	unsigned long shadow_cea_begin, shadow_cea_per_cpu_begin, shadow_cea_end;
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	memcpy(early_top_pgt, init_top_pgt, sizeof(early_top_pgt));
 
 	/*
@@ -450,6 +453,9 @@ void __init kasan_init(void)
 	/* Flush TLBs again to be sure that write protection applied. */
 	__flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized\n");
 }
-- 
2.41.0


