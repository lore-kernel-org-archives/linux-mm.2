Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6281CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6F96B008A; Thu, 14 May 2026 05:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF376B008C; Thu, 14 May 2026 05:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C1A6B0092; Thu, 14 May 2026 05:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA1D76B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:41:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 869C41C00E0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:45 +0000 (UTC)
X-FDA: 84765533370.02.0C0E905
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF04D180004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:41:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rOQQGu2h;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRd7Ld3GiaVdtiEOte4Ul5KoBjr/FrRH6YpNK5Is7Rw=;
	b=iP9sIrNYa+KaqXYUe4/0pKIFlA7/x9nQ9KO8BcMHorv74y+94jPOLFA8On+xYom05pG6vH
	CnEpMcJ0GdvtbQmTDbViuT+OlgSUzdOcL4DLCC9Lu6IXJIkl1bdfNYNnzGgCGgRsYDZJ1W
	oHERx+7qzHEQeOgP8+2+QhZu3ZdTyaI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rOQQGu2h;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751703; a=rsa-sha256;
	cv=none;
	b=cR00IZ6WFi6HYmdMHsZzPTmsUrLyNDh6zJmDCzvPgJkmPr74LsSba0Dtx6rV7fK4gY4mz3
	5TBMLz5yMsIAeDuomV/v2esN+bmdfskKW+2ZmAlyybwZ0vFTlYhFkHxGTrGM04/A1qMj50
	pcvywOJyb6FyzD1L0rOAgSH70UCsXyY=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c795f441ff7so5700415a12.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751702; x=1779356502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRd7Ld3GiaVdtiEOte4Ul5KoBjr/FrRH6YpNK5Is7Rw=;
        b=rOQQGu2hBUDR/UAYEQbrgMu8lv06sMHBdTIaYEOJqzcLXOR/Pm7L51ja2CdIUZAKSg
         yXL+8cd6BDIcU/Wbt5/fA8YAwNYgK3/n3o+zqcjyY5Oupq9F1xUZ1HedaESL/vEvRYEJ
         J+TSm/StuiBqQeSJhVbKlSLqwk05ouScauXwnPIH/AnmdKmsWv5Zoh3QHJN33owne5Y/
         +0PywIvwu8kjkV1GNp3MWdE5UVuI859bCBAUpm/RLf50nChuW+W3HeTmWPqNvnl+eIxX
         Bcrwxe9DuAQHbytjDNM9/JuraFLM71Ta58EKdpYg4CEHU5u4wu9ib46q//pU3cdTZVOR
         KUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751702; x=1779356502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gRd7Ld3GiaVdtiEOte4Ul5KoBjr/FrRH6YpNK5Is7Rw=;
        b=EalMLNqFi2AdCfUHIOufirlUvcFSRO1v7CPLTxl7Pthx+8KjV9FCYvN8hvd51zEUlb
         fUpsw7cYkCNVlKGvbbTolF9A7Ie+PSxkyxbrq+pxQQSRvYRV4S2F5UYs3I1bnToPGJpy
         Brj3TL9YvKxfBDSy3evlG0qaSAEhYWM4WrQyegOZwPX3p1M/TWeqE7iNXglqjFRjoLan
         LY8/1erR7YGzlo01XPyW3W/0PuMio7i+fo192G36CZan124DzSV1NcjMGP82UkiyLmr1
         eySiNxw9tqINrRSUa+Hmz6DfdrWagy0CAhhYAM52uGxTmGgy4sJLFQn/+RBWyP5GLVIw
         KzJA==
X-Gm-Message-State: AOJu0YxUVmQiERMjGfuhlrDt4oWtw/VI7NIq1s8HZguRoTmIYm+jUG76
	AGyEvfH48cryCqVgTihdm0G6hT6dN0YFaoVnujSC5JI59TQCH04vX5Y2IOSsvpGaoqk=
X-Gm-Gg: Acq92OHArjfUjVgP4GKCkGnNdtdMIMYS/MYZ28trWOmlnQnQ7bGRecIVZCSJKQQg8NJ
	1dbab86j/6708owdL3a+1tjo9Wa87rN3UR1xLOrEKXkXEdDnA8RYzWhDgZEDvwljXPPVtbyMG+b
	4gRcuT6oR9584iWdKiCebcyUSEsiomyy3ypDch2BmDTLO6bEJHJNYZNoqgsuRMpi01orb5AQ/O+
	SIFfv057FKJbWRVIUlXHMvHuJIWLvrvL0wQqGXSqnB68O9xGOCbrjoEFCaLgFRBprl+t392bsoK
	hHz/j8v8aJnkO/T29bR8flGS8S/hs9Zs9U2/jRM4TnR+R7zix2qDHLMDgx9vY7YthU1gd9GK0NH
	kwOkauySC1pZEviXSCURCYyCEQEQhmn4vfm94kM2z6LIL5SQcTPOZU5Xi8JBm+GpvbhfelvMJ30
	Upl1mmpqTtZJRuIbkIuWK0fySz///U6Ho0DMkb76AOTVvKGM/5qOjfG96E
X-Received: by 2002:a05:6a20:9389:b0:398:a1ca:7a2a with SMTP id adf61e73a8af0-3afb052129cmr7620166637.48.1778751702487;
        Thu, 14 May 2026 02:41:42 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:41:42 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 1/7] arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE setup
Date: Thu, 14 May 2026 17:41:02 +0800
Message-Id: <20260514094108.2016201-2-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7mz3sjnpdipt751ojond56gcpuu5drdt
X-Rspamd-Queue-Id: AF04D180004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778751703-754094
X-HE-Meta: U2FsdGVkX19UawZL+pGlLP5VqNH4FRxdXbcdK1istP6pJ1DeYIbrdkSDge9rWeTCWIB80/LLNJ0KuF4JHhM+S+ds0yEw2aMGGntpKcm/0bYd0RTMF0Hmkt+EqthZ5kqA7wCt0Rn2zjLxlKykBndZBxTv30V28+lEVZwgk+9cJ6FmDmkU27N+u4HQSvzaRrVjLctYvsd3rVvSVzHGbGCCTAJM/nY2lOxfd1AnTkTZqwYanefiC4MV+/sgAgfCHLxiMwogFXypxLuLqVxMduexVAWPxJyjUsXx176y7EzgyRgtpFqt3WQlqqeUtVjAAkmhrLybwYDJLloNlAqG2Y2iCQ/5HC6lCU08XTA31KEUlpr95bjm6QvTsTDOPpmortgO8kIeXVm0W+UFeq8GYP7SXk4eB+x80Xrgua2QD4mjG5SoY1BeCqM2a7EI3vtXRiF5nqUJVpxi1loefB87uSwnZ7amMte+Ku+32JJEcIsQ8uhPgS6WxIipnkGmxVTcSA2KurN6iRm5/Ot4Jxvjfmz5yuAq4ATEjR7e3/r2B6WcMhaQjMJ8Jp5QUUN4pCOX/oDyT14BRAxlsBjAz/jgyfbRqq+TdR+cWCzV1vXxDacQpF739QOeMG+KzKnCyZ6uG5cXBwomHS7jBIrHc0rbXxua0+3x4Kl1gPoc02hfq9JynPmsvvnGemnnKdA7n5UEKmzgCGpK3PDaNnh5FdQbyQPHuh/vWVxUQ5b16/8QS09MY22HkmEdkQW+8Y833rufTgB/xKVBjzrKMhBjL72GQRcYEN6P3qwWW5tOGLACB/AbRmtv+OUf0SfpD3+YrGfSP2Lkk/hYJfWovdPwhOL70LuDIBwFPGnr6vZrNay55n8IvJzmCnfLqRkEw5laL0KG3DD740xGDflKtT26WU2VBapLl/D7sR9QuB+1uwQf6xFHySVsVZT3Lg+Uz4+GMKkwHTcqRvRt3IDPO3mFau/Ctv4
 1nikQliL
 0LKpNbUFfIKHQvhFrQLcktgfja3Rhzz1Z8zvoYHhBiofCbuYuhvVw94M3I/b+aYCVA66K5uUtXZiazwgwPdivl69E6zsNLcPX8Gi9mn0iGCB9UMIUhJbzmj4XbQScyXYjpO8hgGdzuP6Qz7UNG76D0GK7iriqxPE1eVknPWV8hTknGuiM7zp8AIcPEwKS8CtlTnoMsuueitoa//DNJGeRoG4YAxLKnUGk8J22sz3DKmgXbTpFEfQBYeU98R4j2gLBaemBmiE2qFRwk+OpaSJtdqbqm4zKJUMFK9L0eFYobNnr56Q56g7QyurMWl73b6Mb+Sme5LaBm79vYS/UP1hJutOwQ7MpRtzuFKgnnw4b5nYlC4Ptxx5Xi6SChsdJwxtOWcIsaSSGwYfgtU+/fAexQss7Fcjb/BaIawC4lcmZ/pxN87qTKLCv/Kfq92UEwHVmMHFXRTrjIIsZyNLZRQJtkNe5J5P7Omi7VEpFsJmYGmvPUyoQ/NHV/JmVibn+0f9ydE1rX9/l28F5jdg00b0adWMAxR6PpixkvlYvRsCGJ7Lwt0bPUOq+CQCCWe8G6cLGT9WCQok/jfO1Y+BCF+j0Wf7zR+EaDspVQ7r5oXwnjUyt+aI9hoXEyFfs/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
we can batch CONT_PTE settings instead of handling them individually.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 30772a909..d477a9dd1 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 		contig_ptes = CONT_PTES;
 		break;
 	default:
+		if (size > 0 && size < PMD_SIZE &&
+				IS_ALIGNED(size, CONT_PTE_SIZE)) {
+			contig_ptes = size >> PAGE_SHIFT;
+			*pgsize = PAGE_SIZE;
+			break;
+		}
 		WARN_ON(!__hugetlb_valid_size(size));
 	}
 
@@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 	case CONT_PTE_SIZE:
 		return pte_mkcont(entry);
 	default:
+		if (pagesize > 0 && pagesize < PMD_SIZE &&
+				IS_ALIGNED(pagesize, CONT_PTE_SIZE))
+			return pte_mkcont(entry);
+
 		break;
 	}
 	pr_warn("%s: unrecognized huge page size 0x%lx\n",
-- 
2.34.1


