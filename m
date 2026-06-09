Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37699CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945116B0088; Tue,  9 Jun 2026 10:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D026B00A0; Tue,  9 Jun 2026 10:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832B76B00A5; Tue,  9 Jun 2026 10:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 747496B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:39:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11084A05F9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:39:30 +0000 (UTC)
X-FDA: 84860632500.02.18EF144
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F7E5160002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:39:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="icR/oS44";
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9YFjxCDbSbDN2uR6oPNBA7yFa0nwiCUOct4EeQonTo=;
	b=W8RAzvzZvkknTGJoS4p4GODrbLjJrsBxL7UtGlXbnZVcpO18ycl8sFqWUxxjvzOk73kvPu
	XY2pb/9e6NP9x3rlUojqi1Vza8sBd3EuGcNP+McyuyLjbdjTsKu6Og+ZvHtKgxo+1mFlRE
	qSWXigTOc1w+Cre94TAkxctrttRpnPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015968;
	b=y1/z9O6eqh9e5R7Wo+2e20xfOVrlruvdcXX7qR7jmHGCZTRHKSEnTGc5SaR7xyoCHZYHvw
	r9/Vj/l+LKvIkiLTwRYvwFkCgqtizN5Uaa5lBZC0F09Hugax5kQyZAUQUAK8k6MQRn3oEL
	lJ7oIdCEBZhZHk4QnuVY1d37+vNNE+Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="icR/oS44";
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36bc065c298so525744a91.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 07:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781015967; x=1781620767; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9YFjxCDbSbDN2uR6oPNBA7yFa0nwiCUOct4EeQonTo=;
        b=icR/oS449zCX/K0YU73sQaT7mYoP0xXt4wgiO4VPncrS3Yj2EF5/N/LTjU0D6yygS0
         9vl7hJSgWKrDToqfiqwBfJRqWKQrePSwXapeflmkbBPfKE9MLe7DfoWfA9h2SzE5LWiR
         zD4tXDViqhC4mX+3UAD8GKP8Tg8nvpyo7x+4UMJcKG3SRvKTlpYIbbyDkIok8xkIAsE7
         H9ya++yTCCoogw29GDGHgi1B8BZ4CQ+Q9a74VCRKov9ZUpvj1A/2c3tceeO0QETPHp8w
         +6O42hIxRVG6YqYw0G6EIWR4Q8WLqDg4RuOuVk8om8BL6D+RMd1w7fMAG989iE+Nul8f
         trqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781015967; x=1781620767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f9YFjxCDbSbDN2uR6oPNBA7yFa0nwiCUOct4EeQonTo=;
        b=BotS4HooC2kmRLdQj0MPmQMVi+I717VsaLDX76gIfEdPO3JdZqThwWmhJhLeGn2Kke
         r8G1a7og346l/A/ej0AqXtCDfbjAhXvdN6uPnrz8BxxArxuxLgMvd4iHLbLlTesGTFd0
         S3u4yHBLOWrPOMzK0S8weGqxFfCarYTTiybQz3e5bwo5JTmJrNQbTSImhRlfREaBdK2p
         ZHhl3GYzOoSEeU1g/fYndi3EWIhUbDArqwFYvThcafG6yagI2/4K2RM6pBmtES9kJbzw
         1to/OHtMAULQLOES5yTXMHE6ysY4DQpVnKAhC7PvOgAo9z0KHsT/CbbAFNfK86Q73Woi
         QMmw==
X-Forwarded-Encrypted: i=1; AFNElJ8+z/oSc4XVf/AEfOoyUZk8gQG9/hqFkN6DUq58ayxI9SKm6wa3sQW76FYnufJAeoZlWC8HxKyTeg==@kvack.org
X-Gm-Message-State: AOJu0YxiD36eDMNwsY/bgEV3aQlmiUk/YOPkcpRw7bS5UeL54odJVfom
	3PrAvVzj+fNc/UT5F7Y3kzhgxQE7G6o1NrKjoWPwkD6OSqlJ51bBIfoj
X-Gm-Gg: Acq92OFuYaJKRKhoyxW14rduRLvG3r3/NvDsVaaSTR7az55oMsRRo1DwFUtbpHpXAk9
	zUtosMYtFQg2Zw9rF+2vsFv6v90qlCQ7t411xFZJFQY1eEJvWW4J1L6iDyhp+Rh/XyRsOZ1V504
	v7Xtp9wwFOoE+PZ8Xwyo5VMFg2WgNkVWGIX29qIPlbJD6JbcknsmPoL+Mc5fUopDCmNhuwatJAR
	rMpyWEnCjy7/bvRksoD0qh8l2XJpbxKwrQy9JXdTGYbd2VGdmiq+V8iexmH/5Vdblcz7LrpEHPJ
	QqBKuzeme6/vV1zp6AKi2ARvcGo/OtxPVEAiJpIVfsGone0pQEgoB4Hz2p6JK1robcM3kF809vH
	l+NAF8zZN3wm5Xdo1LN5VhT8UX1ld2PvmZkdbvesnJBAulS1S9O8iwUPE39MEwgSor7DO7JpQEc
	uVYac2EPyPZCtEE2gIiNw0+QOwUG00nux/XsYDEIW42Y/Z/BxpK5xfUGsGFd3tqFNipDdU2sbLO
	NiGWzKAFaIkmfWb/YRx3KbF
X-Received: by 2002:a17:90a:4ca6:b0:375:c3da:c8bc with SMTP id 98e67ed59e1d1-375c3daca40mr361336a91.0.1781015966548;
        Tue, 09 Jun 2026 07:39:26 -0700 (PDT)
Received: from o6.lan ([188.253.112.242])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0b315esm17939677a12.26.2026.06.09.07.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 07:39:25 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v2 2/3] arm64/mm: make pages read-only in the linear map
Date: Tue,  9 Jun 2026 22:38:00 +0800
Message-ID: <20260609143801.7917-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
References: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F7E5160002
X-Rspam-User: 
X-Stat-Signature: t994uoweqa6ksdjxgsfe39fq8w1bczxy
X-Rspamd-Server: rspam08
X-HE-Tag: 1781015968-169394
X-HE-Meta: U2FsdGVkX1/QKdrzEYj8n7zKw/M7vg573AIeOlwhgBECz4bVlgM2+O2kP/l+l0zeKhLidhDT1plviOqtWLsxWejHALkYdaLpDk35YfpmzS3pAAFyNIiO0ha7RmLPbRS7Fp/z1XWm3tEwixal4OoShzF6j6G1TLAbK3DYe2nMRUN3pF3BVJbaP1BCJQ6zBqDF2u9H3gWlzVJvf5qhh6rMbkHPEOmg0BXF6GHYAbnESsTwdfVjWfCppo6efPdezjWC9vkSlsdvAaO0o9S1qCCoZcGLPjrUJ0HS1TxYUZS3gGiMTxtuKBV9EUC8mhLlXJQU62bXYpMF4/MVnUy5H12UOxghjnjQznsH15pasKxoL69T+KYz3V9vsozFCOQj/2tAt/yMU5lqcatOk1n39mryCHyGfKtrZBDvRDnYvw/CFeBUnJs3XN1ARThQGUao1BNLBDB4/eegDoqhtu9NUjtMknuCBgd6jvrTZCdjinpjK2AG9B/8VVd7PutjOMYm6qrB2NOvdI86wdjbdnmMmxjD/cUUDbj5BvO1D6OjX55GFOXxCXsvs/qhB4gV8uv451pJ6C9Fr+I8fylmR1r8hUfIBNweZ/NorSMzhI3vS/sDv3kOaLId6z9tJHyj9lkCg2HvhuA+4stNsyzyWBwW8wHIzl2EFK8Q7gJmqn/M/oqK4yL0FmA+2jXobJdCN08pdRRM7xEFFrNrGbxt670Y+SF6cVvYNX2bA9gWAej+XsGwQedqVsH3DzeuxZhf6nxr0rf+0TpILb+SzvWQZ+11RP3gWQkhSyVKeZLfHBqtm94QykI5gaSLj2nfh1u8ws7OIw6UWGTgWDL74JKrCHT2sre4GaWWi9vPpJRQ14P8mITpo0nX28vySjts1nIKRMergjUjjQXAZ43r4Dc71yk6dPi9h/o3ZdpRIjKtjZlk++bCrOG2146lib0rIeSx+nGYrmPp52ZPX3yjo428lR2+Sdc
 8fv1wf8e
 oRMqUeQO4wZZjNaxLnWDj5q3ostBVazERRtj5FUTTBOsMtxpEL6xFqJwnXP2lf07im9gte+qY/EDwQPC+yalLOmXinx/crd2OLJ+ShNpfzXgE4DU0L6Js8exE4ODzsjjoiNh55EGwZWqOI44/CNJvHZv18diVgei+7cCZGgM2LJ1kupt8IW1SaRK5Z3NagYV2vJWIfPk4n8citM9rIsom1vCzhcWZd1I03qn1meeptEzWvSMEmLV/3twnXfztX2taKRgjlWXf9pImsQzAnHM0YLs4gOVLjkrH3UwYzVs4XC2ZTfEEUKiDWYbVuyT6GsdI6ORMgam6FJP4C6mSw4hAGpLleNC/olW+l/U8kzQE6K2CsBzXR+1U7Sn48Zld06vmqvtEM9vqGktNSIJSGyEbLc//e67zvHe/dX/F647k6gnssyzO/aRB7uNNNfux6UypVV3pECfExysW08NnSVrhGDR1JOmVvb9kLP+g4YE4VlmJIOfdimzpt5X1ff18xIiVA5bhpBgtHlE4G+C6Y1Z39DFCvQ9YAvO5z7I8aVMiKUaANFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement arch_make_pages_readonly() for arm64. Make the corresponding
linear-map range read-only so unexpected writes fault instead of
corrupting shared contents.

Respect can_set_direct_map() before touching the linear map. If arm64
cannot safely update the linear map at page granularity, leave the mapping
unchanged.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/mm/pageattr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ce035e1b4eaf..da97ec7d5195 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  */
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mem_encrypt.h>
@@ -147,6 +148,18 @@ static int __change_memory_common(unsigned long start, unsigned long size,
 	return ret;
 }
 
+bool arch_make_pages_readonly(struct page *page, int nr_pages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+
+	if (!can_set_direct_map())
+		return false;
+
+	return !__change_memory_common(addr, PAGE_SIZE * nr_pages,
+				       __pgprot(PTE_RDONLY),
+				       __pgprot(PTE_WRITE));
+}
+
 static int change_memory_common(unsigned long addr, int numpages,
 				pgprot_t set_mask, pgprot_t clear_mask)
 {
-- 
2.47.3


