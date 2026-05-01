Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C80F5CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3786B008C; Fri,  1 May 2026 15:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374636B0092; Fri,  1 May 2026 15:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262126B0095; Fri,  1 May 2026 15:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1962E6B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D04A41C051E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:13 +0000 (UTC)
X-FDA: 84719816706.26.01EA314
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id F01D01C000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hrRXUrnC;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EauujQ6AF4QZsCC6h7PNtICr/KSSJa0IrR5B8rHLzgA=;
	b=LOXuw4BTz92uhM/HtvdbaSqlCud5YMk/LsIYJPv0bmcetpk1FuM98/MZ2WPS4BdNoD41gL
	0ybNu5g9+gi5piYDfM5MwA6z4wNMOae8ujHaB7wKpzhKD16G47S9c7Svd93cA8YJUYstmK
	wDqDcKkpu+kK8DK6P9AICaGd7L81e4U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hrRXUrnC;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663212; a=rsa-sha256;
	cv=none;
	b=RooduemW0fL+B1mLbXZ+SJTZnWuTJViMr8p2RoGE4LBNneE55BLuti/ahxtNJUa/xFUhYz
	QGthDbH3ty9uXopbbB0r1lZWDDxg4fWPuyxcs7Eys3iIww/nu75NAv0q6BlHKdcljpYz3U
	QTyKfbKznInwf9rT3/g4yex7WWKUHy8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EauujQ6AF4QZsCC6h7PNtICr/KSSJa0IrR5B8rHLzgA=;
	b=hrRXUrnC438sBBUy39PXRwk8VAJ6TLhEG7DMzYf9PxQf5oq0S8KeiFgNDFyJdj9QHnvuxd
	KMoCBrnVQ2JD1trl25eKH7L52UvRkIi2Uq+UmF2cLO5Eu/Y8vDFwLV7yHJSpTtHq120KL8
	rD0JvFEbyh9iMeijEOAY471K7I1DziI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-ww1WItWvPve97Gvphk8GoA-1; Fri,
 01 May 2026 15:20:09 -0400
X-MC-Unique: ww1WItWvPve97Gvphk8GoA-1
X-Mimecast-MFC-AGG-ID: ww1WItWvPve97Gvphk8GoA_1777663207
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E2651956089;
	Fri,  1 May 2026 19:20:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC7D41800480;
	Fri,  1 May 2026 19:20:03 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 3/9] drivers: dax: use pgtable_has_pmd_leaves()
Date: Fri,  1 May 2026 15:18:45 -0400
Message-ID: <cb854ba26a4b8036706c6da5f6844f10f386087f.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: QMvWU6zD0DaQGjG59V9TaYocbXYK7BnbsjHtuFE0JlU_1777663207
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: t49tz1xsjna1ijd3jk1xigkdzaotdzzr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F01D01C000E
X-Rspam-User: 
X-HE-Tag: 1777663211-665036
X-HE-Meta: U2FsdGVkX1/7vgdezV3fgJLjGgkzSaJMSjuFJdS2P8lNuLSaqZEEzpHPwBjwevvYiZhZm7EXmzVvUlftiWwqnpLmGNEY7QMXAJ9g3NGvjOrcdh9VZOPk2ayjCdFCPhF+KQfTgcnBa3f10hKYskxWq3c/ulAW8+h3Hc89R8EhPzf3rb2uTjczORO2Yh0mS90q1JWqYt2lI8tuMe3NKV/VaofPnfH19MdUsYUCXQj4wgBZIuaght/Oa8OH6MCrg/YzDZpP86J93tEJ1GI+qU4tP/xJ3SId2R1TC4vqdmAD/R5ommP5sr3NqIBaqWmSXPQR1STF652O2l7Y1c1ViXQRlUx2sf1V+C/EFx9DQrfShXhDj6SZ3rtaXrhuFwUA50YMt8/VfeSS33xvbF40iEprM5NpKZCPiyg1Fj0gzNoNYq5btqiM0qq8gg6g26aCGFRPA+bedi3t0xlKzaCIP+C7Bk4fg75+npQ0gqVyWdq+NoddCc7kb1bUr9aXhGlP06iLxvccT0+0TFCJooxddCKwU8r7eQNOQA5kIW6nvCPAlbIqflZsiYddzdcgLjwGKhIDuKKFhU5qDfweManBMCbGdQXOv8xeGcHqi/ZHnBCvktLP/u5/W4e3dMUgvBJEiMTsdw77gR612I/+A7aejkqc/WE1UdHHuaU2BQr39mpjum1NFM3dJC00EgVG0mUCIgaX87R6ea68VyPrXl1wt4tzCwIdR/86v1HdVDADaRalM3W31cmF/MvcPrWWzZxCm77bL9VdqdWUbC3ZUU2UYPAQMpIJ8qW5xdNOhGFOl8kGCBUY6S+8EnU7DQx7XAO5n1/quH/7iGcz6UKTwSbU0quZypqksoTaDrdXigyUc/NEDJa866W3zkOtE1r1MW4+m30Y0JOZaMoVYW2fnbaizQB1TBf4R1GKPz/ce5nOpBZZA7rT2uLz1KNGbC2EQSfyMjqhJDfdXbiWMPNBwVLU7+p
 h7uRwi3h
 py+34wGflyo2gPuJsiAFGrHXgTPDvP8G/7ShH+q/ILmsq+NfyzIvNNjVigmbuU4CCTrIRjO+RZ+YePcVEWrESOLCZmNI+stygQbv66XRNCsjB2S61gmp+jCXINPFcj+KuE6sVffXtgOQh4am23ZvyHJ2MjxNVAFfq1vYUsVgpOJICnLMCp/WzRpoEBzr8A3WVKBx76g9L/xSTU9FwnsQ0jwM1yhQkI6X5k5jkEpHb88UQWT0N8lzMiVWyo+pXFKiOTej7LJdkfBVo7KUE4I56ZjYO/KE89xlbYxUA/xHCOndAj9/ZZdZ86yXbbhIsAwunaZNWrVGU2d754gIJn+J1FP4PjFz8znbNHDXhlxnxqXTrgamFg0kywSCGYayS15aPcL16UI/5AzDf4ZfTj5pYTMjyiZimtFiq/WEg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
pages are supported, use pgtable_has_pmd_leaves() instead.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/dax/dax-private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 81e4af49e39c..35744ff6592a 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -123,7 +123,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.53.0


