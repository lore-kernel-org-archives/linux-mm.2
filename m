Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4A4606A336
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XS7FdRjt
Received: by kanga.kvack.org (Postfix)
	id 5EAA36B06C2; Tue, 27 Oct 2026 07:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B4F6B06C3; Tue, 27 Oct 2026 07:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2546B06C4; Tue, 27 Oct 2026 07:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 271C86B06C2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:38:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A632409AC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:38:29 +0000 (UTC)
X-FDA: 85368208338.27.844F9F8
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id BEF45100005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:38:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XS7FdRjt;
	spf=pass (imf14.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1D2kUawMq1dXWdSc2yAkzGxoxbmuMLiDkZI38kTQA1c=;
	b=g4hQvhqx3nj/dTvUjA2TCRrB0XJDHqc5PjyABANWTH5xIIrsNBH92BkdZXSX4VFJP6cgjQ
	UaEFiyFVTewu2vpXtmKgf4zjAJ9MA6ptUe+MuDwnlnhaUicWwzemPMo/O4tMD5ULv+iG8S
	BmEk6yb5nxojVcr+yWYayTOzDP8NWRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793101107;
	b=Fs3iucXdh2y1qEMrROuxzhykVv8RXP+zqtXXbSc7c6uqVfzfmDpQ/R08iL5tvM2t1VqAK7
	QR1hLQrTeXEWgsBYUDFZqfb1xUPbYgB0JekN7TpYkJer69ZxlkNricHZEZxS4PUtdR63oJ
	ogiGrwwEr9qxEI9WC3UuKJ5Rtct6t80=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XS7FdRjt;
	spf=pass (imf14.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7cc365db987so2706127137.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793101107; x=1793705907; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1D2kUawMq1dXWdSc2yAkzGxoxbmuMLiDkZI38kTQA1c=;
        b=XS7FdRjtzPE/Vw9o5qKibKebpNDUBRoEKNWZH7YHR6knPLfHmFVHEdoLc8+YXfUQuO
         B6TiO46SpLpfThi5lowb6xOKdfUym6oHvYw408qbx3LGt6Nm+bQ54bcbqF1CJ8WqMww9
         KBcg8QXU0n6+rZeePtdjDjc8gg4ZBWa9LmNjIOrIV9dOnEleSRrBDqHqDUNGKHTaEVJI
         BQuoZ9b0E6db0xUz2yuLOdY6eVURWbrUMocQ1wiASUubXgPUjx0PyUSkR4lrnmKykfWE
         fNruvKu8givh2soALhFVBN85jxBR6jtoy9ahJHBnyQ/UZW4MKcNM7ueR0glLCDpM8By9
         Srzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101107; x=1793705907;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1D2kUawMq1dXWdSc2yAkzGxoxbmuMLiDkZI38kTQA1c=;
        b=K3CnTinH7vJcfBw4mITIBBPbdQJI1l88kYQZTlyMeG2F+K6dbFvLbPGq0ZDzab9O5t
         rsCWwEAxIA0v2F8kSd0X/abpz4FZcB4iJ04r8ytRci2uKiQegGs8hIf84MCiW77RIbat
         UdU1DcciaSBG6vZV6G/3QDm1+LQDFbOnZeYT9EzrHxaywZDCLPekWdoIcSc632+7aS2k
         ufQlUiNuvn2x8fVIkNBYUnbsyr/z5g7mf7RFD6PymHOWBahwBsHOJPQPUiCeShCZriEf
         3C+LGBPsBvsxNP/F+B+LWMwdIfUAj/hCqferjDHz9/oK84ToAw3aqPhEb0PM6qr9grfb
         hNJg==
X-Gm-Message-State: AFq9FYKS6hr2u+zFHhNUWOXI44Ek7OCNs+4Wc/6/9PydDVziSW7tlInP
	IIcgX/5wEu2NmV8bTc+567v1FkUSzb0fNyvDKorBm6W1i8o5npKjz2Up
X-Gm-Gg: AYBFou1NtPIMVqHgoldNJpiq+VLKWe10I9hZ71AZe6Pb+mMW+vdT6CuHT5+4q5r8mqu
	8e3Fv3YgZP+g/UlJc97nzq6qXXy/dxNTDAYqgmerPYSQ8oQo2GxXyr2V7ZSZ6LIlWgaQC/VSxGq
	fFcoLVVamQdTmvVrgjjgjgnKyZCLi+Zji3udh72hTa9s6W/O/Tt8rqXfFk8vMm+cZP5EreXg6r7
	XOuweR2RTTxWqs5mmNOSjGPIo5IkFsgUinsqrPsz/8pxdBxr0jk6h8UfvutzT8Ch4tk0wpyu9Pj
	d7wGEYZJJiGXm6KZBK0lpUOHHVyPI7JQZbqnvY8q3TTXkQvsJZiUzZRogG0yV/H62t1axUFhq7u
	0MGu93XECre44Inrr+NCC7K2ZvuKAuVYlD7ow8hANAjoYkplJKtOGJKL2O+aamoluTE8VHUA9dX
	6kPuARQu907Z7fGUqyds3XPU62gA+nt8D4BXcRwiwEilRvW01nEnf4VUp2eflxOxq2Y3WIGW4jq
	w+aauE+Z9UhWLDDuqJ6a6dd4Z/LcUPC7qickbwJn3l7/XOC2fx7mZEdMQuJ5CREplhvUMhkpqh7
	NsPAG9yG01KqfgZqkyyGNsb1D0B5UwuadQ==
X-Received: by 2002:a05:6102:689b:b0:7cc:21cd:9b68 with SMTP id ada2fe7eead31-7ce5cd17515mr3402829137.15.1793101106726;
        Tue, 27 Oct 2026 04:38:26 -0700 (PDT)
Received: from fedora ([187.120.134.44])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cea367d328sm2234678137.0.2026.10.27.04.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:38:26 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: [PATCH] mm: clear pmd in pmdp_invalidate()
Date: Tue, 27 Oct 2026 08:38:13 -0300
Message-ID: <20261027113813.1332096-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEF45100005
X-Stat-Signature: nyzkcei5989t6sh7osc5wwuhedw6cs9x
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793101107-724745
X-HE-Meta: U2FsdGVkX1/NPfNEXfdrH0F0A+MYthwMaV0vfMuX7FCREOm9fwtTh+ddLi3l9Iwfkrr6LFRXhic730VQ/tzJp0bhlNs8CGF6z8QDKoEDDVgbnhlvdYEeC3rZNuKxhayMBQlcRerBpUuduu2ig8Lm+AzWGe0NyWE+dz0UY1T0zPrr+UA8pbLIvp94dxiTDQ9+8nbMpuT/peiCKIpTWiAwFmJ1JxCMcNkgtCDY8RM7QFGNw7oYozk+7gdS5JH64BYQtftW22iSQNYwSJiyDwcTorrFueKOJPZmq827rwitlGbdi69iGFdJjJj8vBviGrvcyFS9K4q0umk+5LIypzq69tyUbZylMoBjbbZEOow7sRqQc5Dzt48+dRpdicH+NIBXQQtTe4Svh1OTasZcsE+8viVXO2P5Iq1u7UVGiQzrbBn65KTj8/Bic6ybpU3RkUZGYHXPgHOxzv5mWQff34vSGyDAGQlXPg7LX4Ed3YkHpJqJXlPHvYHhpzga8aRWzzlzV7CuaWrOjC+/S6wodXTWHlt5gy/0JdPOfD3Lt4r52j3L/+A6iVThXo77/eVtSVoHxhpQ23uvtws8Q32q8o/BJgl53VqSc56zGyjr1byuT8AB7RRvq3FK6VIAL3CGlaegmolCjaaXPB+mwB5tdkgFP9i6qN1UkzcHkg52XWBWtIUk+Mk9MhoZkdlYVYaa0FT9Wct0skuQaUd+JkxM8PpeylHN+WNyPanjXgytkdfuuh0kYfA8IxJSbvV4/afrXQqRu2RTH6FIfLtXBiyMloH+NvvdW6DviWZpIWO1IvrV1BQTso3oHvtWgNkTQE8OHJobhR0W9HigpbYJKtEcHl+Rfst59zTow5VCJ8ecTJZWWROIxozSTAuUqxTd9bUfpgLLewJD8nduPNuVCdP0aIHVxHtgAMgX/1fmmmEJtzCJnk9eAlLyY528/UyGerjbHswx9YdUajgNwu/rIi/6ccZ
 vTD+VxtN
 UNMs/ycAaZTz2i6d8okwWwZpvx5qbsV4WO9+XcseSj4ARHt1UO6RG3HNH5rGyr4fQgV5wKGiCpoQ26E+Fxw4MtyKy641TCQljigxxS/B115FAeQB/G4X/7k7399sYQSt6AJlu3rAMvLs15NOU+sYdeozQq2nSJpnyQdEfJ2k6DqDQBQOYMTKn+RzGczaTA2NH/D+eUcu5KrklbERlye0FHARTw+UZS8OSxiSzWJNpgbsUbPd+KuzXv7e3dW7G1iztTlXLqbHcq9/Jb9kKFNU9lbHsI09azhkBM34BUiqEBMDnW2D8vWYHVLgG15Fzpbg3s0ViIFDnA1ZhJAEKKsUspXPsCgXPXjcHf9IFg3pltiCrGDVB/KWZZSzxzF+nMDwG/ZkGZIQR+qxVPQsddxi/5X909K+7/Uf65EV4mnfKkm3rgy84nRVRGn+1Rkys+3OfaeN2hXH4YWAD9sc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

when attempt to do a madvise in a chunk of memory allocated by mmap, the
folio_split is called to split a portion of memory, and despite the path
leads to pmd_mkinvalid() they do not clear the pmd and clearer wording,
leading to a BUG_ON inside page_table_check_set() because the map count
is more than 1.

Call the page_table_check_pmd_clear() inside pmdp_invalidate() generic
function to ensure that the pmd will have they map count decrement.

Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
---
 mm/pgtable-generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..7fa5351c75a0 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -203,6 +203,7 @@ pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 {
 	VM_WARN_ON_ONCE(!pmd_present(*pmdp));
 	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mkinvalid(*pmdp));
+	page_table_check_pmd_clear(vma->vm_mm, address, old);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return old;
 }
-- 
2.52.0


