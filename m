Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75262C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9446B009B; Thu, 23 Jul 2026 21:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499FA6B009D; Thu, 23 Jul 2026 21:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361B46B009E; Thu, 23 Jul 2026 21:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0110D6B009B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4300A40263
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:19 +0000 (UTC)
X-FDA: 85021952358.24.851CC64
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A7D520003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/Rt/qSQ";
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3fN+U6OLu9RcmoUGqbKd31qZxKwWcR6lqChPGtz0M4=;
	b=CfL9iJbayVD/k0MVw+m1453YFy5GmLLHCwVqCzWrzh8KT3pF0eKnvuzqczocNTkr2lY/QP
	JEhuvaarxoBHIAp0TsLzLJDc5XvV0ZtACuoMv6UnE+WhKKsKZ0cWyz+zvuI9WOMhqxsQvI
	L69i6yZZq/tRYa+cVgI+lBVlXV+I+Nk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/Rt/qSQ";
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856916;
	b=A29caYpuJs4fu9MNSI7DFbbwnmOBCwSeGev+YFqW0OPkVpui8LrzUpP9PrWRBiC6TGmCYL
	0v6bYk57uNsixSqgIN1on1qsLva5r1v6GefRysCv7Ax7xUztmsppvMMgz85mGIdJZj+Gpo
	Vd67u0kOi5Rld/cDwnU/IKoFiDnuCGc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M3fN+U6OLu9RcmoUGqbKd31qZxKwWcR6lqChPGtz0M4=;
	b=g/Rt/qSQa98Q1/a+6pIHXCA2gShcEfEqrEA9d/1Zw4OQ2fIxVKhfHk3NAiDPlCDxXRUVuM
	vksWLoepOqsdTpEwu8I/IuafvXS7ulnfPD4eVrjc/3k3zw7n8+H6kp/GSDP94BxhKT+aDl
	quvbnjj47l5rVo8izOfrJJsYE2ypurw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-wqESUF_APxif9TVu7ateZQ-1; Thu,
 23 Jul 2026 21:35:14 -0400
X-MC-Unique: wqESUF_APxif9TVu7ateZQ-1
X-Mimecast-MFC-AGG-ID: wqESUF_APxif9TVu7ateZQ_1784856911
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3694518007ED;
	Fri, 24 Jul 2026 01:35:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6DF09180059A;
	Fri, 24 Jul 2026 01:35:07 +0000 (UTC)
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
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 08/14] s390: move has_transparent_hugepage() out of THP guard
Date: Thu, 23 Jul 2026 21:34:12 -0400
Message-ID: <3ab69c6a9210d2764f714a093eff731dcb55ed14.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: qzSZ0sC1a2uTl-FcyR67UjljwHqohIcqF7-xl_nR7GU_1784856911
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A7D520003
X-Rspamd-Server: rspam01
X-Stat-Signature: 8tzrdexwyr1zj3agq6baz7womxm7h69t
X-HE-Tag: 1784856916-708395
X-HE-Meta: U2FsdGVkX1/ADtquJJPrCVDZMDYJyVemY1wjJaqSBdm0qL3lUGgoCaqiXcnbgUdfWFbz6N+Pw1pwkfQJdOsaKqmKHroG5HcKM6LQOcVqq4kBOfU2JcCRFdkLxJ+5f1B3YNhCZJ2+lsTvfkBmQ0YAwEPWzFUh0q6IIDeic7jr5b2C1lFV/lbp8XmQNb7Hfwvvh3+F7AGldDE1bcSuiGX/x5pYX0AV4RFYIULbJKoH+wo2r2oT3su/Ua87NntOoKJeb0w5idlzir1tkwEjjhdl1F5zCLFwwN6nJSTtilhUeZvjVlaCIPOXrEB4N5JNRixN681cUKKyo0y77wu7xdjpm5viX1baAKzvluilK9KBivoJRN1rovc5DpfAHINFvc7TJoKEzk4ZQLWTRrL7CTtVMJZuV0RlkGu4VKDSZPW/CDE5YSjbOf1EYHeLvjOV0uBZEPWL5cYypaG3CaYSTjaU7NN1EUfdRCtQPlEV/ejitQHh51fp7sVONAA64VPWWkPBGdvcCuniQ71gd5XtAM4bz6Pr4Fy9QjZS3x/cZykTQ5eWGBTppCvC6jP1rA1Q+bl4TjAV/y/CnMm0wZyH0zqxC33SBgPlKKzquI36pDkvNPiilKr2OWOvGn4vv+xdsTiQ/0WxyXMwr3MaPV+rxxYMoP5E2XzrJQ8NWDhEu6btBvTaxuwcamTb6bvrebC+MxdwbY36ssFUy7TrR1w/VpN6VAi9P/Zfqbmmfw18+RvUeIryD/kuFwpcMp/cCPDR6Bhxhd+xZSK8O0lZY0SEA5x5Go10No0C7f1P1WqZ8bEeYQ1eBlzOd/Cc6NXkurILZp3PWmOFqe53EwkrHd5/VqOHFMR5Fqc1BiM8/z5wGduoiLVqvl9TZfzAXhcE0QeFHHGOcj1bMPz0A0aeC2kV571zv3Z4NlbzKdga2we/824GFFUGztEGlqAyZDZWV5oPXmcO9pmIryPzIwG/2i6HkaX
 s2kMUY4x
 t07l1t6P+W86PmcvnZG529VpG9P/n0a+sQ1eYmEavOgjp6nTTEUmkeWtxNu96nPMY8Nb85+yjWKegzLh8tuXuGs0OXd4971NpTCpNrThv1aOWoKNXMSUJNb/e5wXMOUGT2DcPd5+jbcrJZm7YpViVkdNG9uPGqo+pJsMhzLzmkN2Rys5nMLKU4rfamKNd6DARmwnjGH4wFE5ach/MWNF6JKzm337n4dDEju2im5unz7F+givTjpERdLG5lvMsPp4MTzkN4NwehZmXfXFmmSM3K5eFT1nxGLPDxMBP5oLi44j4sz4gxQimKXZ9bAAP/jnKc0/MveWRaU+q3zUFuN/lqmilMT56p4EychbDcP7Y8wc8KnZdwODp0INHqcd5Hay0yvxQU2rcMX4CAnI=
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
index e882663a58e7..5aa8f621df04 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1825,13 +1825,13 @@ static inline int pmd_trans_huge(pmd_t pmd)
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
2.55.0


