Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4AA4E88D8B
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 12:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290906B0092; Sat,  4 Apr 2026 08:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2675B6B0093; Sat,  4 Apr 2026 08:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4886B0095; Sat,  4 Apr 2026 08:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1636B0092
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:21:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8987F5AAF1
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:37 +0000 (UTC)
X-FDA: 84620784234.19.323F08B
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3EC8A000D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TstD9U7N;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775305295; a=rsa-sha256;
	cv=none;
	b=gTEwiQLs+emQg9RbwmrqWRsuZ5Ypdo1L4Bbw0vtn9H2CbFqPRLmqsAZjqboPlMzb7k9a7p
	LRC7Ymi6OB4/WhdZZ4VxWTsRQur/lhNMSletcRhg4IzJUZrPXTq1YqWSwubLukmoGWZe7O
	mspRUoTwZ75lOIR6PVoNBnu08anhOX0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TstD9U7N;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775305295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxbGgf4+lSuSxIXzDbxhYHMBptayAf1Wj0PvoCJF+ME=;
	b=4oAlkSCmzKlqDN+arr7KPIfxbp8FVUXyxuKBN+ZmEvj4Myob+EnqWQ3f1nT+RcDoXNvHCd
	Cc8peuSvLNJTdXWEy4r68Hqab9UWoA0ek+sLsSLoLlYwXwKce0tcRfr2Vh2j+eF/efyWXF
	e3l6w6qSrUlA5rgTR5sMDD122MjNNuA=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c6dd5b01e14so901361a12.0
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 05:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775305294; x=1775910094; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxbGgf4+lSuSxIXzDbxhYHMBptayAf1Wj0PvoCJF+ME=;
        b=TstD9U7N9Pgyza0y2XJsFcyj2+c/ucL84sHrxy6lk/Vokmq9U5qK3Wf4NYJslMew/F
         OBV7cNfuXhlYOgj04cAsbtvuQbr+NxyAA/dWrAn+DATuIi4Db7X+zJVrKqX8T0+oT8Fg
         mbO+bJFmYTDuES3nDRzjNk7rQxBEzYo9V9Ui7Q+mOrLOIIv1GB1MufBFOGmf1CcF9/Oo
         5P24qpiBhWS6VWVaBUUgpfsRnd70wVnNbxGUmcvJ0DCFYrIbSIQxamfFK6tlhq8jSKX4
         2O99vhsbRtuXQPpIJeG+TkR8XULFoHgNs861mi7zj+Ksenjm1Un/A+XFabkDJNn1br0n
         copA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775305294; x=1775910094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qxbGgf4+lSuSxIXzDbxhYHMBptayAf1Wj0PvoCJF+ME=;
        b=U0WRF7tgZwhorcnes2HfBgXf5w0m/W7+YNfXLm7mW5lB3irwIMwEcf2Os3Zf1X8+Fg
         7th0KnsCROEan+Jvi+5b6q98vabwL4xc3RieGvvZd+rudPdfItmOynhb7WsKXDP/T9iR
         xxxfB8RGkdKY+usM23c2m2n1+PnKAHBNwr7wBJF5k1bZ33EYfJNYz3MV8eQUQXwU6JPb
         OR2MWU+Na6O/xBGj+KwvGtuTVi9KaOwUDpO4c5X4aDmCmCcaS75t1tLORX2FzzNT/XOu
         WaXjzF/CD2Ljk2BAXZzF6GwKHSGcVNg/8EF00xNfJgvlkIBYzJpGSICrgOwGo4RWtB6m
         6wUg==
X-Gm-Message-State: AOJu0YzdWtECk7TyQorplVvQhxBzbpyBHzU0VRzty4KgwLxLKFP7lMbH
	pQrrAE9S1ezazVxoDwEAv9LYkVgLsev3Xeb7YoLCp0aQQj7IBDC1xKjCDILtcaRfTE0=
X-Gm-Gg: AeBDievxzzzil+qmde8oE7IjoGZL2H7py/bwUoDo8JEIsH6WeVv9XmV8JiIbtBRsf6Q
	z/fAcViWSMtedi1Vj2WPGkPrZlwSjivslu1/oeEfWVgKTSSgwgYsSPB5ywSWT2JJ6coAXj25Bct
	2gljeVJyEGq7NVkAVyCMOcqYa8MUIcGVIaggJrUdZcwy1OiIc52ULX/Xrhhxnl6Y68QNoMVqyC7
	cWSvLw/z+vx1PFbvFTS94LHx9DUMlqKihQE71goqrgHg1oKbVTYASFV0vn6SLDIRkdblMStggwC
	5Azd8bK7i/pxj3P4pGhXMSYWpNZ44dsGfJYWrW80ZbjLzBCWn4JZ0GRMCeoZGWL3rdSQpQR3cqd
	rLlIvXL/onybzq7lDHLkrOt1SMvRdyo1Wwh4xxOPGiIfMaLGhDDNYK7KLb+Zr6Kyocj7SfyV0z1
	c42RB9KHf78UQQH1m7Kde7+0oBEW43vanSprJIDPsTjAA=
X-Received: by 2002:a05:6a20:430a:b0:39f:2dd0:65d5 with SMTP id adf61e73a8af0-39f2f07e2fcmr6795719637.39.1775305294226;
        Sat, 04 Apr 2026 05:21:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cfebe5b23sm8327063b3a.59.2026.04.04.05.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 05:21:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Austin Kim <austin.kim@lge.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] riscv/mm: drop vmemmap_pmd helpers and use generic code
Date: Sat,  4 Apr 2026 20:20:56 +0800
Message-Id: <20260404122105.3989557-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260404122105.3989557-1-songmuchun@bytedance.com>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yjd6gakwo4wkkyd5kkehegedirfkmc1b
X-Rspamd-Queue-Id: B3EC8A000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775305295-924739
X-HE-Meta: U2FsdGVkX18/BVNChN900/SSJHd+Vitr8XQF7JsUefmpefaffG4T7sKvj41Lgp7vN4ch8sLxdRJa0rI6mxU4etD2JljDCqm78jlkybUCmweyWM2+17gIJ2ba4Z0AXXgXIigmdBP8gUlqS84qGh3dnWzu+MdJKEYdSGb82HtBiEl2UY1v4bL520tMjuzHQhR9Gh6kCEpqqp8PIGoAro6msbbGYu8Tlk76yQnhsV2YcgGCa1P0NmGZPaGnWtTNHuGt+yCyy2VzAHGAmLWlSR1RfrbH9JeqEarxQZiGDDjsgDAU76MIm2DdiA3amJq4TA6CCyQH97Wx8p1PmwP+3zPdrnXY6+FUu0zSqQ8MgS9Fjt8/HBw46L8DJlO5qAikvlBipW/UoEjrVsdD8VhQmGqlR1hfaG6bD6OAUUP6Ikx4Mju8q3a4Fv1HzVEaXFOUWbyo6riaAupwx+Lhgrn/2KarvelDpUA3qgh7lvqf70Grp02rFPU0d4c0S6lgIP4MqPsA4KduRGne2YSm+7Pq9eNBlZZ9Kmi0dcsAUh7I6mkE13o5C5sq8CNjKlTH/Wi42qz4IHZGLxyg3/y+q7zlQdEI2o4nvcL6iJI7XZdah1kQ6lnXXRpNhlSt6H1n6pXZhFTApgdG7QlFFuR7lEj4Uf+CycBur2O5z+RTJZ/BeFa9Zxbc8ihspplw7vrEki27XEMGm6ZgkVFFkGQnzGhM5QLXF7kemrDO/e4UQAAZ0WWlXbA5igjr8p47KEmgY8TDxtjkn0sVcXRAM2LvI8y96Q6S1NyGdWq1WFOOdOE5JN0EWSkvgfsuDC7fIW4FLL7VjRUhNh71ePLbAeedBz38mj9sAC1WkLwDDmBHsxYCxJxnOeB5bM/8YeuMriKU2rsy5mzlaTuoUDNJaRDcS8r3CrU+FndVbER1eHYPl44Tmv7mwh49bRmXiTvVjs2BcxSDAM+X6NDpPMTDvckEsxNu6Oh
 8dJpXqaf
 2DeWpEBTONlVRduqcpdx1hf+rswQs7ihVjZy9A/1kH8n0BAQPWBnHq2ooukep1myYIQdHw1e2vC76+IR5GQY1vlGEw5C/8ar8gwz1rHrBv/eTIVurirKcmZv2vLa3Dbh+mKRbDxQ7NuQVAnqqHSKoisqch9tfOA32tyjCMNsWgUdnhxjkWN4TgpnmLKhqJR2IgwGUJ53o+o85/0NTrlX/iB3C4tipEhnqEwR7pdhk6W1kkwUXAXFpktx4zjqkBwQq7ESpc0CQVhz3FtJdPVY+FD+2tqijoPTWjvcuFmobksjqCx4WreAR2U0r5VtvoyN2BUsYbE/5VA87OFoiXznv+sZbdyY7bsUYl0XQIgADv0i6yYQnwymvAY2RQz01xYr0bMAUHw0F+3zjEv5oFg0WTUajJKHXj1oljaVuevBlZZVxesgSe1q7gPkjktO8JQyNb+3tHq9eFdBR0U/vuuCqawTD6QMdt2J7RE2JdC+TTrkNS5VNM0/3aNetN4sICdfqoSvtDT4LSG8k7/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the riscv copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/riscv/mm/init.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5142ca80be6f..f7e7d7c2e97f 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1429,19 +1429,6 @@ void __init misc_mem_init(void)
 }
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
-			       unsigned long addr, unsigned long next)
-{
-	pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL);
-}
-
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	vmemmap_verify((pte_t *)pmdp, node, addr, next);
-	return 1;
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 			       struct vmem_altmap *altmap)
 {
-- 
2.20.1


