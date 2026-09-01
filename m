Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D4AC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDE76B00CC; Mon, 31 Aug 2026 23:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FD76B00CE; Mon, 31 Aug 2026 23:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0636B00CF; Mon, 31 Aug 2026 23:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3FC86B00CC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42EA21C1C88
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:24 +0000 (UTC)
X-FDA: 85163722728.15.BD1D86A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53DE7160006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f86/x37Y";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTc935LDNPx7nXKta8GUS/LwnjuaroaKOzKm4nVuj4M=;
	b=6lxIgUYMbiDxfTSty61iT/aY/nifX9KX+d7MFeOsUGl4k5oUibvVIMiMy7fCtaG3Q/bJVw
	BN2eAITtS4uko+L8pHWNkF/5n9sQEqMTCN36naJEMsNyI0WiifEEPJNBonDo13069NUzOO
	osT4c1Omf/h+gPSwI6J9hGy5rRMr7zU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232402;
	b=ajjixybi+NJvDm/5CsEPYmYeshmeUvER8h3bfooFQx8mmhADr33GXBzurabeMU6Da7ctxl
	qv25XrsqloDa55CAsRW4z+I9uhKyFm1EJ1QCEFukjQfY+2HoHJmq73Tef2KjN0YUpUeUrJ
	bO17HDt7VAOGdk0tgKooD+29+drvdd0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f86/x37Y";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QTc935LDNPx7nXKta8GUS/LwnjuaroaKOzKm4nVuj4M=;
	b=f86/x37Y/asf9TFrE6Q8UIr8X2D1HdfJ9P4bjBkjAkz74fqnSByXSKPICla40SFhVtmYAT
	SgWufo4iv71R2x1MkDz+g39wNoVML8CbA9wFRfTyuC6IcMyO54PuUvbRuli1P30GIpQETs
	IYSsvQiR51MaDcV5UeGQnJwqL1V83r0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-OThTEAxzMc6Qm6uhOHF8eA-1; Mon,
 31 Aug 2026 23:13:17 -0400
X-MC-Unique: OThTEAxzMc6Qm6uhOHF8eA-1
X-Mimecast-MFC-AGG-ID: OThTEAxzMc6Qm6uhOHF8eA_1788232394
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2265D1944CC3;
	Tue,  1 Sep 2026 03:13:14 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 52AC618005BC;
	Tue,  1 Sep 2026 03:13:10 +0000 (UTC)
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
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v7 08/14] s390: move has_transparent_hugepage() out of THP guard
Date: Mon, 31 Aug 2026 23:12:12 -0400
Message-ID: <dc0b0e69402619ac23d7271d64b0d84a77a5379a.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: ZpvXWB9idQLYLdHCZZwpX_R9gwVm0TvFCX1tdFt3WuM_1788232394
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: zhfsjohearhg7emfqskkgko3m98yn5ha
X-Rspamd-Queue-Id: 53DE7160006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788232402-667016
X-HE-Meta: U2FsdGVkX1/stSVkWOawVsjyBGgwnaE6g6KjQGwA7UUq5IwIRa9SPkbk/AQ6t3AouJEI0A+fzc7Bx88ckQmxULSUrFKWSEhpuaNbjanmrP28+Yvce2zm73yYEzTkHJK6oEjC+4h20zFnSY86eCC1TN+EZ8h3fN+Z3NslomMbeTfd+V7o7U3Etji+Qm6AP18k1NMAB9ZYDdsTHPwcufQZ+K9mxk7k5wN2rgMweEh5bhxE/w9EPT0br2fDBcTjG6MkHhWV/WxIc9KgALXommA2ZGjPea0REIogxckeEnsxg2zuxkAKlOM1er9Vm3B6LG9o2MqjtcAlKSxOMvCSFXiBGZGA5ZnBeWEkzvCueZavMda+HAnkV4fPvmEgsQkmFhrFW1H2GIRnPxhGEKyC1q4aHTKw+JFpKx9VBXScby31tE4aBtBryfQOEqVbhAA2qozBX7oz3qxrskmyoPV/zRobT23N6lsldLoVJOjykKisruRg0JBhd12l9hdPUniDVw1sv2ktjGqDQSfF+4hfU/hLSdcbv+xR51MvItX6K0RVXRA6BB8igtWqVeCV546tS7SyD/fv/jhIUQ7fgRUI6p5NrjDYDeoAQ8V/PY676HU1RsfacqvC+63q9zaUHspg5DDysK3OSJy85CeecbAMSDICX3O04IG1OMnUL1ylUwMT7tKWLmTRW25b0/8ZEvr7rVR8y9kSpySoyOMAnXxutUilHs57iLmdxjEy/JXerutNLIAZqal0TLBHU4f2dcOvyUrQj3k/xTN9RbNGU160TLwvyhoPCW/ntXYuOdnS6ja+K0JL3S2YClo9DBlgg4ub5h5M2kxZoH+Iu9Z/8F5ygD+eYsPZJyjEDirdJuo0prmcraVbDbtP38JGIOW4d32zmcC6qJj+mqRkHIb4RYsfebDRB8t3xuta6vlSrbeP6d3MEkZvUvhqRtnKrezMz7tZKvLGEZ8jU9nE4pfLD7S718Q
 fcqmZMjI
 zItq4LYgllNGdiQIS55SZcLTYblBw1Y5uTnCOUqBSIo1OU/meQvNFhTo52zwUwpa3ACrGdRIoR3VkVFPFZKIKdjLBI64cBLQL9KnIbNmk6i/lVDA75qHb4aQCwPEKWoGx80XOMFiWstfyVzQgIm+mIpz9CpCXyydI88GinpgxJfnwXVyKCTKLpFbH/YataNTt/AM8Upw85qr2QtUgj3s2yTOyDyqAym9w0U3OzGvxHEIUk5S3q00ZSlTPszPnD/5OmTLJw+oLL5fzeTTlAcXkEhZJ08j7adh13itpXEdMcC3A/dsFK1MJc1P8dxgV9rKM3+fd6gXjfAqEjs6KNvr1kQDJpf2myOQn9b3Pot0ieOrY8yuNt/yfnqPmg4wpuLUeao1tVmy23cVjWOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future commit will introduce a kernel API to allow for checking if the
CPU supports PMD-sized pages. This API will be based on the
has_transparent_hugepage() implementation but will be orthogonal to THP
and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

Move its definition out of the THP guard.

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


