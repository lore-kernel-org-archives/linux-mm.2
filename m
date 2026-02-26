Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43730FCE087
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9360B6B00AC; Thu, 26 Feb 2026 09:17:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFD26B00AD; Thu, 26 Feb 2026 09:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8060E6B00AE; Thu, 26 Feb 2026 09:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 663026B00AC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:17:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10A87140183
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:17:00 +0000 (UTC)
X-FDA: 84486809400.19.26C8085
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34DC31C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:16:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=AR9laR90;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772115418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jNAD0DboxzMSBQ7MXxoHQ/ZEV45aIr2CHYOKdSDYsjc=;
	b=kN8pwnSpFj/JxnOA8zsRlmQwq7VL/Qr4+9hKVxOJodgsBRPfILvMeBO0/1E3nmIQoksnSD
	Jm6PMmyr1cIDtWrFwtDdGuyEwVPKWz7L/aSGIV1hUwlDY38FnCU1/w4oUxYJLujQd6B5XZ
	05sBAP4yntA3Q2PbWSCme8XJDxF+l1c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=AR9laR90;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772115418; a=rsa-sha256;
	cv=none;
	b=4SN62/+Ukwdla6HXAQWBYLaCNeqGnDtiUSYCCDzTpLlsZgr1yBQvINj2mDjX/wovJ1Ysqy
	Tj0ksIyVqt0UESiSOdyOUH8t4vn3v9yEO/bpnNSr/6GQFeu10YcUvAaGa+ZNWoHOeFwYSB
	D2/UlM7zEXsmOxNhow6uqf7+cYe+5Xs=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-827270d50d4so984773b3a.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772115417; x=1772720217; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNAD0DboxzMSBQ7MXxoHQ/ZEV45aIr2CHYOKdSDYsjc=;
        b=AR9laR90uRjKjdbQw69GoQ69JItcCDray5Ly2Fro8Vv/B7Fj8AWq2YGZ8HuZ7KTYFc
         kAjaPy5MxpDVGF0njqrjIhCkz9PDkh/5QcBMqWw3ZGC+NDujf9SQJBGCYuf2OtkfF0Ke
         HKEFbSQhra+LJlg5feFcj3tciRLthD+mUiDmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772115417; x=1772720217;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNAD0DboxzMSBQ7MXxoHQ/ZEV45aIr2CHYOKdSDYsjc=;
        b=ehUnOkXixW7I94OuM21nIPfp+7ez7jTrfpdjhdFcKVxEL4fW4RL3e12d4eD7YT4WVV
         0Dh/WWgRgfQeYGnqTWGwuCddtCTkemNxUwjfPzL6PFgvoHcvPExaNGXxsVs+8TvgLCJW
         HJqbs2+EjbM9jSW5V0wjuAuYHJarRWjkjhBmUz+TSf/jfC6SKyb4WslXUjeQhw7XaWoW
         VvHDMrM7r3H6wpykMxxlVkaibE2qwB5o29Pqjjnk1QjHH60nzBWOBlIaqwOL3TI4vlg8
         GRqHZ/xkZNHALGAffGWhbTTm31VPzQ/h2hs24/S3QDz/LsgXpFrJd64qfbZH7CVXv3LS
         +G7A==
X-Forwarded-Encrypted: i=1; AJvYcCXpMaxPdgTw9AVvzQxFjGRwQYH8uC/gDjHTpKkcjhNnkVlzL9SCcN9ZF7IRBO0rnDE+kEbo7lkCcA==@kvack.org
X-Gm-Message-State: AOJu0YzfSIn01r9xV7DtqdUc5Lkgrw0ml+JyKuuhxepnNLyzVu0AzDI2
	Qzc9iPSPaMFf3MLarnwLencTrfeG85f4VCHozjFUJdCYrNc6fsSvxiQMceO3JA/PWqE=
X-Gm-Gg: ATEYQzzRltMKziR81zg89ndDo7m10kdDkIvcTl3kEIXkquelCk7kfNlM1lyqkOO0eK1
	CK15Meb8JiyMRf6yPrO7Fa0w2EcJBMKByChqZi0Ac8TdI/gjd0j7ybSo2Txk7k8ezUgs0lTCbUk
	ffJobsPVTg9VtTOabcgSim9WrafHB9YoS9s7gwunl3+PuEbMwa+PD/7MdoYbfVFTsHNljAuAVSu
	Pj1eYplL+SodwjWg77NaHeN8mpocEFGUuHizQ192Fj9rlQ6rdFFm7Uq4JEo43omJ0H7pnRml64h
	sN7WDetmwqnEunpkHtIYz2WLwrDMQEe+G2YwRqFs/epPi3myFFrSyR06HdqLOKP+H7+I408Cjxp
	4RWiUykVx6JnhSWzOlf3/A/q1qukA6Fl64SffDy/WH/AW+OQozWT6E4ncVq83p8uSqxo2Crgj5D
	D57YBEDPVj+ZAtnEsjIFfuup6TZ3MH
X-Received: by 2002:a05:6a00:4503:b0:823:1212:8e87 with SMTP id d2e1a72fcca58-8273bfa1f7bmr1954788b3a.32.1772115417192;
        Thu, 26 Feb 2026 06:16:57 -0800 (PST)
Received: from localhost ([154.47.23.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ba6275sm3012040b3a.0.2026.02.26.06.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 06:16:56 -0800 (PST)
Date: Thu, 26 Feb 2026 22:16:47 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm/huge_memory: Prevent huge zeropage refcount
 corruption in PMD move
Message-ID: <aaBVz7eb6-VBCvaz@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34DC31C000A
X-Stat-Signature: xadi3yfr9gt6fqod6rp44714jgjuxoaw
X-Rspam-User: 
X-HE-Tag: 1772115418-903936
X-HE-Meta: U2FsdGVkX1+qe8Pqv7YxelGm5g9+9aFNFY4mD6Jb2O/jK+czVYMPv2If7hfjMowKhQX8ObQtk+Sc34N7Afj1rkqRTmcYEw8502M9UcLfLadFDe2umkaYxEvnys8Kt5r9RK8/TIuTDJlFo3wVa0iovXBON6pPiO0J/9EIuU9p7qqgRZRC9sJ5CjVkSQm4VeQ45ncE4HxaftvmX9AN0r3eVzQR907F5rBv9NftBvfvmYHybg8UjEypN5yaFSlrLrKbPSDMWNrvArbiGBrHFJTZMnBnetMDH+EfS156HCrLCwEiwVXihTTedAchACvPZLEPNYsNaSvEjv8Wnq7UI9pbe7G7/s5CCZFEUkM1d4ynf4gWcRMecf5YJBjnzWyBYAwvinjhDGGWJY5+vTGbMbsXuihEUfAA7bTz4QzuOo+oU/hacjxpN1d46rREZ2eJnw1GMcm+p0oe5L8ezKYcGaZhDrgY4SIu1c3HW7dsgoMzwBpo/vwZ0c2fuLYSsi03oqnxVk4BZBlc7L3CNAnWXOdRReI8Q8xT0qnIk8yl5tQr9+Y7AEOQXQQuqfuonhlsvRMcQZV64FmWZjKPWCQci+lrrPvt5wo5a/UWSrtq4cWNz6FY7o/W/V8yf+cs5/HLMRirjQItIXrK2VmDXCAFnvWOGzdvQjv02jcav7Lrv6PpP+lhFyCrjob6RZdYHzsj5gFqSncA3NYlzijJUOwtuJEx49Hwe3U52/Mc9ew6/ZTYuKGjZgmnqZdY7fPEMNyNKv9kHCDi98CFju1LMCbPhFJvgmT5lEoe2RcicG3L8YDUwsufuFLtxoUyADvyiVZYFDPEOFqBjuoDyy/w3pgL88KDClqcDPA9gRjFUX9yDLUUxQUMXx6qgCQNH9aa3mKoX2afVuXLcb+5jK3hejDRLOC5lrdybbbGFsniooeHYXZsp2AtZ2sWpqs+Aa+vDYj13MaMI7sXo4uJ1hzw0Y2gmjf
 IhXdZYdE
 2JCKhRb17F3htTz7RUew6qPiwSFmWwVmRAaXZq3HSSbAs2XnQ40b2PqNqY3/2BcmBq/pYnGCkCoLy7pwiEZ4rjgxbV2Z6wiFWp/yT7EqMA8xllMrUoOun2PhnjOcQ1ljIhCOAo8rx76Q2mM/0Eyy9s4Keh1PezFQ1GCwP+ZtsCD9/TzDAIogMKNbrucRfRkZ/trxYlj5/eb08gTtsb5XQq2Lc7y2ShaKXGRxfgsXpfJLZUIFNl/8Ut0yW5BN7JzyfsDCUCEfYpvqZEBVqLLWVnRSUuHO6pETvlsES9WFYLwtXyxIY+EdKzCT5UV5BJpAU420qGd9BzDzvjmSFbWNlSU24lQQ6K33VFr/qj6LzMFmePpliZ/1/yyxJzNfiaYe6U1DLenAuml+ziS2DETeGpqxzuUVeAnBzSK6E9QiSKof803vgEXdiK7wB5SGV2X8rTtFQxM/1Dd+SKjIGdsIA+tASOv1sQ7LJPdwTYNlrafUd8cqeTDzbgV1CYwZ4QxdmGy6oGFhaPSXzwpAGuuufEJoUm2Z87DG0hnLgvy3GbD/5laxoz4b4MG1PoaLbX/YEWIHrlVFm5f85ijK69qLxfCVI033rFRr4nZz+ZbPJox0sBEWB+FABMD4OWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the
huge zero folio special"), moved huge zero PMDs must remain special so
vm_normal_page_pmd() continues to treat them as special mappings.

move_pages_huge_pmd() currently reconstructs the destination PMD in the
huge zero page branch, which drops PMD state such as pmd_special() on
architectures with CONFIG_ARCH_HAS_PTE_SPECIAL. As a result,
vm_normal_page_pmd() can treat the moved huge zero PMD as a normal page
and corrupt its refcount.

Instead of reconstructing the PMD from the folio, derive the destination
entry from src_pmdval after pmdp_huge_clear_flush(), then handle the PMD
metadata the same way move_huge_pmd() does for moved entries by marking
it soft-dirty and clearing uffd-wp.

Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fed57951a7cd..8166b5e871ad 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2794,7 +2794,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
+		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
-- 
2.51.2


