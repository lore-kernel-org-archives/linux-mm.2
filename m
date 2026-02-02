Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17753E7DF16
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6966B00C8; Mon,  2 Feb 2026 12:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73CAB6B00CB; Mon,  2 Feb 2026 12:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEB86B00CC; Mon,  2 Feb 2026 12:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDF06B00C8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:20:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AF45139FF8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:26 +0000 (UTC)
X-FDA: 84400180452.10.301471E
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9800C140008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a7ZT0qH0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770052824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utHr5Hk4Pmw7AlX0/QS7v9ZBDUDXlcYDE/CS8IUJBFk=;
	b=PpcvWdQTAW95prhZCs9CRJQXMHTi16jsdOmPbaxgWcoemBFY5seIiteAdfljtBOaSxb9Q3
	/d4GDuY7AW9fxvVTLaIzeUXcn4QiRE5/uu8+Lb5hbcHM7ZBZ1P0u3E8SanhUNtU/pidh9m
	KWyDfqRjxjf09w21qh++LUwre4VP39g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770052824; a=rsa-sha256;
	cv=none;
	b=7HY8/SjcBHMuoJ0TOkvrgQMbOFpPai6r2kl07FECK5Xz5tVJ8m5iK4PC3YxPOzlNLQVzHK
	bJX/lP6NfXJKfwJ49jka1Kg4DccWmoQPWgdwACz6AZYeEPnB3eCYv8xcDOcdDcyP6jAMrI
	XlLcTl4F6mwStAgJ8z7XLXQMF7pFGYw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a7ZT0qH0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12460a7caa2so7204766c88.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770052823; x=1770657623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=utHr5Hk4Pmw7AlX0/QS7v9ZBDUDXlcYDE/CS8IUJBFk=;
        b=a7ZT0qH0Pf7mqNQrrDNSFCseRMjNK8JmZ6YQ02Xx+KCctsoLRiO3Jrh/Q1vBAewqL7
         AomzZ6i7wRFoxHGehCyFZpu53XJOJbfqyhG7Ammm2pzSToFTWfK5szmf5akuJhTud2SJ
         JA0S5gZCyz2vebb+UxfXxf634zCCHAll8t2Lew8CtV24znHF52rrkhXdPWshrZW3mIkC
         +Y/qG/ZTNiBYkfwvRz8Ko3jPk2BlZU1RLM82MTj785q2loiX9dMHBw3eRYRwjIz/1+q7
         SZW0BIWs6CdBY3sGLjBuPk03nU0Tlt6tSt0EMeGoSk3s1cIsziPmen0FinxH/4lqRE5B
         qRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770052823; x=1770657623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=utHr5Hk4Pmw7AlX0/QS7v9ZBDUDXlcYDE/CS8IUJBFk=;
        b=g4YEZwCvZ3BddwUjREHVm7+KijQxqSXmYBT/24Pc/A/NojCrCt0f/BN/96MBZlFZ8W
         EqyH+cnkg0EuYtuNiDZ8mb5zKNiEdCM3x/VdPPSEqzchxAi/bYEjSDJqYLgOP+0nsvZl
         iiqcZrnEeCmJeUPp9xAaZhh/+vMBYrq/MmjEbICL/C6mhmELNToMgK5jHM1cujs0OSUu
         lHFzosUhmnAjVF/rkhZYD2teBhx1tvnk5+MLDb/SKt+vh6JKHHCT7D5jPi4tLW09LuDB
         G0hO0C8C0SDJwJtIwlr6zhh/17ukcfBpER3xAC/PmvScbb3iRr4bJdvDKfaB6ABLkcRC
         +RGg==
X-Forwarded-Encrypted: i=1; AJvYcCUSr6F0PnkQkcIi0gpseto/3a9aZ7QUmfpA01BglSSzo6PZGjywRMhJ/+K2JzeXaWW0B/Nzk1qeKA==@kvack.org
X-Gm-Message-State: AOJu0Yz9Lq48oEGMLKlXp1dCrQRPHibLyDC/a9WweGUJwshqcwysvHED
	0F/5PeE8i++VnHOIx6C7ecpIwTAe9usz+er01V5eBdnijIAmmg+pK74O
X-Gm-Gg: AZuq6aKw9Mdba2hp+xpDIOegcLUpW2rL+VdUJ+DMrPOwo03+WqWjR7cZs0CQiLTaiz+
	Wq9NMbDvMuUk+/N0nlRYNu00WvVmsWW/Ymmeqf1mvnmQM+tPHOuEO7UQykCCBFSu3YxNhNII5z4
	ZR6Mg986bd+abr6Chf9mBcO6ZAPvo6FlVtlNkmqHTxYCAVXzHwI/6IeoXDaEKQl/dRsFV0F/KM6
	ssHbwkD+ygH258Vx/YWUUOdhxeC6drbOUHDgXJFY9SdjrmYkV7lEWeB49H/ts4Maw2JVqcRz0aF
	bcQiaGL8E91mEUFJf10BiaEAXd6T8lWzzGL6Tx6Lgq02pWLdafgb9lO+l/1S7iyrC2WygMBtOcs
	xdvqJfcRS/x4gC95Jg/Z6tOjJZxCJ1gkUArsg2LU2V2BKXYdKT3hJQwz9uto9JWMdpoUmDlj5Wl
	irp3YQlnNOYBsvU1kld8fdz53tkSAvFNiY5yM98mHgza8obwn0UX1WcxuQu5w=
X-Received: by 2002:a05:7300:d51b:b0:2a4:3593:c7ca with SMTP id 5a478bee46e88-2b7c864e335mr4588938eec.10.1770052823241;
        Mon, 02 Feb 2026 09:20:23 -0800 (PST)
Received: from fedora (104-57-70-139.lightspeed.sntcca.sbcglobal.net. [104.57.70.139])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1adef97sm20129902eec.29.2026.02.02.09.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:20:22 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 3/3] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Mon,  2 Feb 2026 09:20:05 -0800
Message-ID: <20260202172005.683870-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202172005.683870-1-vishal.moola@gmail.com>
References: <20260202172005.683870-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9800C140008
X-Stat-Signature: tmkq7qqkbxquxwp3h5i1o6crjmeasscn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770052824-528514
X-HE-Meta: U2FsdGVkX1/TtjPzK+tp7iFYJCfJyLYdS/uojkueFxYUhCo86Ae7JpRa1/OX4gP0y9Ni5RGRZnsqCp6uzMU3phLDSgNE5MXGgT3HtCQ1HFXZYlL6LD2KQSRx+C8q5/ly3egKLlzF4t2LUbK7EbM2nPC8Dx0bvimUfYMpF1yO2WtmJbArx9LK6en2F7ip68CO4v1yUgsQWMD0MymX+rAwn4QesvKr8qr4RPqa7xcdwmzaQ8uf+yTZ9HJD/HtBVP9jXzCpRWHUNN88pzkbj2PEAqOBS9DoZiYXJOw+RybFxtf6dlcatEQ1wr4gmUGu0WdI7GVucRTB9TtoZzQWc8tY/HYnMTdp4zLkmb3qvC2NP1K8FMe0jlJsH16u68oRXTkgTCZrWsrWBt//p2vMlRPHQg6DbAJXnrMdP8cIC/vz7hmUPsimsOt2dtxpFr/E8UlrtJ+T3gjhWvU99oBJVEc5OV01XZf8IPPYIgbdEAigVgQgiVWXe7CE/MRa5wC2x4jozTg/uni78x4/H+BdmDw/lsh8lwMe4PC2SkRDaN7o+yc4b8+eLMPgjmAn6TF7DCTa441HXhp0dML58D6I+IdDa8YVsQ9+PF31fJ7EJ78gJslWOK8JXufkNDk9r4L/Y07o6MWU0xhdbK1w9RTvwTFz0E/XV9TisGYl/hMry6+JsqIhAGB6m6YFLQATZr0hR4S0wqjGaJWHXMn7qo+hTFvAUy7KAW7RouXqUem7O9gSq2GmUFoJWZBAMCn81ktj8784qrnq9HkQr0gI/wN2529o3FeKVBVNc1cX0ZPCUzsbjSi722aewGGrQNREpojjIOXgmm3OaCPMXf0nE/9g0lxYbsqX5+S8UkDFUFhH4koDglrFs+/Z6Ec2+511odEGLlrfFNRYimdNK4zOBHCzF2aQckjRV/+kASWn233YAFz6PHrE6oe483ctt4r3+JtaM4ehohur4dmOppBzCF2HrCa
 l4Zv0M4e
 lIPBsM/sZfn6pY6nGEusLxNst4RuC0yEIn02OP8Zf/YnnbmBL7s8f5O/k2GCVCb/IRDUo2kC74ps7nJu1r+Evla2Pi+aH+Zb7/fXhLUB3NQps6FG7jNWk5TV7GQJb3t/zbaEJv6Q9OTW+wYhNoIpNm+YkSVzgfgyvCWjLzFgzk6/MtuhR9TcQulcz3Y/x9ac7tahIgt6BuHoy0h7I5iwTfNNR/TDVIA58uqkJJXe0WEpqrnipKrHCiTYNu7MToOrRANUA6UkMItmGM/x0Issjr4dKpEQWqrfUYN/PA8ZT7EdcdyxGTgt5Z41V6YxP0fT9rAd8KRYu8YUYFI/aMTc2yNV3WzXDSOnehZ7J0co2kNUQtzhS5riGbzXLoCqqueKNp7GzynhJisMKf/giKyO22vyWa56WfGu+jqB1gmf0lsP/DiPeVm0yMyTzh65nnOh7+BGFjxSRKHhfN05gXm4sgksXfLczGIs84AY3sJ17g/t0RV76RJasQ+aB6w1ci92s1vtGWj41CWQcyzFnc1JLi+/NO3C8/urwS/b3/TfJFkSf+Uwx+NRl7I9FsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions.

split_large_page() allocates a page to be used as a page table. This
should be allocating a ptdesc, so convert it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 9f531c87531b..52226679d079 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1119,9 +1119,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct page *base)
+		   struct ptdesc *ptdesc)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
@@ -1226,18 +1227,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct page *base;
+	struct ptdesc *ptdesc;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!base)
+	if (!ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+	if (__split_large_page(cpa, kpte, address, ptdesc))
+		pagetable_free(ptdesc);
 
 	return 0;
 }
-- 
2.52.0


