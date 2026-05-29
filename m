Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B085CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AE46B00A5; Fri, 29 May 2026 10:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32BE6B00A6; Fri, 29 May 2026 10:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6FD06B00A7; Fri, 29 May 2026 10:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA1B36B00A5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80F2A401A2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:46 +0000 (UTC)
X-FDA: 84820759212.06.1429DFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 94A71C0014
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XnKT5McK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MK7MFe5dAlHTLuWlpT7Jrdmvnp9TlYHXT4S4yW2269A=;
	b=6s9iQI97RXVEoYJ2jfYmBUHKCRTw7yLVZ60zL3/8zEOCQk/+DeLBPloQMhOgCT/p8NWikA
	2Y8Bl2xmXmOH9gomP/4hyGpsANAHLJ0l4bm6+RsbD0UHWQFvGTSXVEfgXbGZtzjusaZui8
	DnWK7MhF62FJ0CWFIMNmpPvNjEYjKfo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XnKT5McK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066604; a=rsa-sha256;
	cv=none;
	b=fAnKXnx3xc8bkhdsaplnYQZH3bN6aqu1Ul1/0YfuWQzG3WBTkRBj9WAF+dSjEUwSAvt65j
	JgwIPFjpg30a5BdTuq/noNTiq9pMvLBFAR1IKtOJn3b5bwzb1o6B97NF1Eao2anYL5WgT+
	MVtiQsaV/YuewTV9IS2/HmFNH0xARaE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MK7MFe5dAlHTLuWlpT7Jrdmvnp9TlYHXT4S4yW2269A=;
	b=XnKT5McKOV4qkOQOhI3xugIEafCg/TySzTrrI38Bzw+WpN46I5d88olVdQIwsQ/xUV78ud
	0xu4YyGhCC9UPvHfDrvSDQyDkyobPZd1z9Ep7P2CDXm+XrASMdj/db/872sUgYwKtBMngw
	q7PgS99WiWS7ZwUynp1ZO/6/JeCuV2M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-NKalSqyxOomZVsK2R4F6ug-1; Fri,
 29 May 2026 10:56:39 -0400
X-MC-Unique: NKalSqyxOomZVsK2R4F6ug-1
X-Mimecast-MFC-AGG-ID: NKalSqyxOomZVsK2R4F6ug_1780066596
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E6931800611;
	Fri, 29 May 2026 14:56:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC65C30001BB;
	Fri, 29 May 2026 14:56:32 +0000 (UTC)
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
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: [PATCH v5 08/14] s390: move has_transparent_hugepage() out of THP guard
Date: Fri, 29 May 2026 10:55:26 -0400
Message-ID: <dd3450176722023d777929e9541cf92f9fa0f999.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: X4cxIsdwMwCzOgyGHWnb8qG0U4MNBm4VzT-4FVyTXz8_1780066596
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94A71C0014
X-Stat-Signature: rhutehd9qfemrnnncwxuepnt4aqwjo8i
X-Rspam-User: 
X-HE-Tag: 1780066604-891839
X-HE-Meta: U2FsdGVkX1/nNo2L4jgmofRuU1M9edeo6IYJf/10coGXQUH58rYvboSW0ydV7BEdWChfzZ8w4xKkCtghqYgUnbgyF1J+ASyRBRkoqHPKFuWQBEyHK6rqflhwWpPoDTQFWnzuSWym+IU+d5oq68cPwozAKZjZBgEobOHml0YXqow1J0v0GHtfMXfW7hXxkpeSAXV4CVtqm4dAsFVdDIO7g1ZxPKspM71Z42UjqbUkKRJqCtVagLPbPbCANryCtpOBdHg6ur7qZcilNulzhK6S7X5kyCTpOyCKCBk+GYUYK9jg/LtE+nkK67TZNGT/X8tmE/THbyzcB7hpsBntAa2kFUxRJLJbaXrKUREiBGidUoEoq/hBmRoB5vNo3Ao8xdax9eFAI0tm+qfWacFs5apB9kJ2HK8CtHsB1Z0bOlbLPpLku8Q/vgWx6tmUY4L/RBvN63K/r9M0avBeYiUPbR6WLgh+3QmPhOBfo1FwV3gNdGINsog8pf86Wu/UE/wq2Fi6GF2sGD66OvonPBiV6dTsI8XxfvUF3qIu5KPQOMTZuel42aE/1N+Y0YILCItqmn/YVMuqIRbgdqC5Lff/jqZ3XSqysyTQH0O9QQjxMuVcJNzH5aOJobN5vrlMnhBxFTIxCWEh2ytIBlVUsmN1vKfKRroJA1Qt+RQNmErbLbmYTkr7FxiQ/N8Lmtpk5TC5YrC8yubQqQj081Idz30zhr1E/7cvIoXNT0kHNgBi0NGY32WULbBKS/uPD6y8rdmMNruluVunx04UEhqbBwaFFjTWZS4+N6rlkAlU51QH8WGWFlQzFogi8AC6IONTFE4Kj+HIJOT8ReOyc0olMXgIoj6rEpIIqaQF2k9iowMgYPMPtA2A4IBsQsDosz3JO2xWbvdQIjJtIKE+hPe2yOC5s0vqiGX3cFmANHv8I2tCnHOBL7PzyGTGFMo84GDoruDZme4PuCGKNeFHmJ1UzXbQfQv
 2qAtP2zL
 0f4eiA0eNRts2vQQNxa8OousTCXsn7A0WHgfg7ArTW7B/D89Yh8wjb9FPoNtxn7aR+HA+jFpxd8IuO88QLYaGGGRLpqUP2AZ/fX6alvkWVC7K4fnLdZ9qqIR/Rne93mn5/2bhppUcjMjFxoyCAxU8uPcq1yAwFvqKqUPdmF8BshF1XYCsi9Plox7ufaVjr0xxdTyTWTa15KWbRn+CcuIqPEkAInhpvtRYxgHdOKdKACXgPAgddD2dQsu00xN3EkmdIjB8zBWE0kOpjQXJzABOA7vgh8/R0H9o5eo3yZKyQblLP/jn3SuYlEAQIYvSNW64UZG60sIU1QJ88gWV41P5zQKKzCo7y8cdgPHnnt7zALyfGVcNlDeRTRkSSBL450JkuTjvUaByNI5rcbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

has_transparent_hugepage() definition is guarded by
CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
CONFIG_TRANSPARENT_HUGEPAGE=n. Move the definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/s390/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2c6cee8241e0..5ed14221cc0e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1798,13 +1798,13 @@ static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return pmd_leaf(pmd);
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define has_transparent_hugepage has_transparent_hugepage
 static inline int has_transparent_hugepage(void)
 {
 	return cpu_has_edat1() ? 1 : 0;
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(struct mm_struct *mm, unsigned long addr, pte_t pte)
-- 
2.54.0


