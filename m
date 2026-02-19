Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D517AE9A02C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC506B0092; Wed, 18 Feb 2026 21:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5539B6B0093; Wed, 18 Feb 2026 21:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441BB6B0095; Wed, 18 Feb 2026 21:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 274046B0092
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:04:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12CA1C2CF
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:18 +0000 (UTC)
X-FDA: 84459561396.05.51CE4D4
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id F01A6180004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gVpys3HM;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771466657; a=rsa-sha256;
	cv=none;
	b=bdHgxqFBQQc37CRMJgObvUoWzjMyf2GN4AkA2lShD0QNO8bATai5AkaKcgnoxDFtazdNCr
	ZsVNixw/Y7sTtMIftEIVBEqa9/i/dGz5c67o8wbLYZ/fI+vMc/DcddHpgoXTcHbobHWJrz
	jNph/53fhKSpnuZjkEAeuiwWym7VZFk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gVpys3HM;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771466657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKXZaR9Z7QBgOp0G8H5rTH0s4LUebUliiAlBrVmUCHQ=;
	b=C1R7aM4d4+A4JrMUgkgkKlZrwGzLjZ9/1NVnKw4m4hCYAse/ljxpUHIqQs5EXW6O2CbGJ/
	s/J14wumoLZnLx+icy7zlQv9RprFU6ecpYyqcw8wHVmRe0RLeAJ78LeBMFW5YSRWz7gDNX
	L5XcMgWwQmw5Eh++6MqAytA6QI+cR+s=
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-676c6082381so211673eaf.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771466656; x=1772071456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKXZaR9Z7QBgOp0G8H5rTH0s4LUebUliiAlBrVmUCHQ=;
        b=gVpys3HMr42nQLspCLzjLyybYzavpG8LTi/6dQp9h33ALpTyPlshZqlU82YPMvfHrE
         yyKL7p2JAReAybk0Z/df8Wm88XyPoRRTjVmXMm4dNU2aWQcwX22J5xIVqytiiDO3LnJz
         KaRkqH0ssLTUM68RCtwIv7I5QXWQio+fu5GS32j72RTYKcflU5GDcqCcCMf+DgFAeI7Z
         cPxnNWQFXeMG5MiXfjxlKTumJ2nW6zM5VR6veiSYi0RaGHmQ2ELPcchmDgWeoUDw3xHB
         Wo95QyTgvuZ2N1zLiCvGv0gPCW9Q71Fe6MTzrWC5pvFs6168vVwPVnm1GfUNB05+YreW
         kSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771466656; x=1772071456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EKXZaR9Z7QBgOp0G8H5rTH0s4LUebUliiAlBrVmUCHQ=;
        b=meMNp0Nphm/9kektGwALlgXVwCqGMFFUh/hA5VBIEoS7hw8ZwMIneyItzt5AewTo3d
         9XnDpDVmRrb4LE3ymCGDIj0nfBG2n9Q0Tt3tqSibonbVWVER/sYwQMe8BKXFCzjF0OK2
         b+/zVNcohp85DsqBT1vaoKc6TtaHTcIIoZoN9Q2E59kMZ02to4vGvlzgSa3ho2MUCc7Z
         IL+w7fSk4Fz08QKvfcjjt7E1g3D3irVVWJDBbVRTXu0NJDlHU1iAeq7+7dZZd2tZn8+1
         913IoXgOmiiUDlkue2pr8n1SuvaQQ/kqMufUC70id7GadXvhhNktLb/6dgM2M8OVezfQ
         fYWA==
X-Forwarded-Encrypted: i=1; AJvYcCUcyTQ7EgC4a4eyu/MyyIUwZ1Fa6zwJdb/8xGuoYb8Ek0lD16PXjUXe3UIhnpY2w19hLeqmN/lzOA==@kvack.org
X-Gm-Message-State: AOJu0Yzs0yhq8SZYy7RDwl7G2ATlTwD89MjZCr4tgl6RJDuhcQd+sDj2
	niLTfj5VOTx4nm7awMt0V+Ycrd7+Z5lalaQ/lvnlypZOcJqWs6XArz/9
X-Gm-Gg: AZuq6aLA9diPNTa9Tr8AV3c5fLWJJloFZxAdfeAcdEWh+Bhz93rCMWutzUMjqmr587h
	sBuNxkuCAJlarpSSIY19Ffb/SvEuILBXzRAHA7oQtqV7ph8SpmTnUw98ZCvGFz2bAVkMlVq4dQg
	EX7IhVmz49FD+vjS66L8Fr3Sl8vPc4u/+ppfLQ4h9PCjjaf+bzy3XkWLIIiyznx5QUh2Trj8mJI
	XxK4ozgvadKAMhCWCazeifetp1YgrjZxk0jk48jw9GCieVFn0krn3iFyrcngTWSXZLCfFTgCIVc
	JUkcFzzSriezn2YeIqS+MqU9r5t3pc4MlMPBbZjnN2NqOZN+I9TJYl+t+EVQRTYsIFZ3vernUUK
	LKDwgV+UdM70LXhk4Q5sff3SMLTr0kQk5rrqNOw100RKJSZxIDc/zuWeSCzskfgCZHzVw9f7m0q
	FVEhcMlrf74oNz6mAAw6COLeVRd7KPL9tAhRX3JQuEeArMAq6q+nxKUcd7Q1v/d10wr2mjpjH1M
	0ZbZ1aVrvB84PYOK6apwrhD78rNeGo0yq9prpA=
X-Received: by 2002:a05:6820:480f:b0:661:13eb:6ce4 with SMTP id 006d021491bc7-6785989d6ebmr7546695eaf.21.1771466656047;
        Wed, 18 Feb 2026 18:04:16 -0800 (PST)
Received: from syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com ([2603:8080:10f0:ab80::1382])
        by smtp.googlemail.com with ESMTPSA id 006d021491bc7-676e3b52902sm12187297eaf.11.2026.02.18.18.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 18:04:15 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Dave Hansen" <dave.hansen@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v6 4/4] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Wed, 18 Feb 2026 18:03:54 -0800
Message-ID: <20260219020354.321088-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260219020354.321088-1-vishal.moola@gmail.com>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F01A6180004
X-Stat-Signature: 9983w6yjobon4i8asot3ffr619hukd9e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771466656-889087
X-HE-Meta: U2FsdGVkX1/pmsTZiIE2NT5TEpTMv7NGcGyHt/9fUsJT+uMe5RpuclNBwl3+e/VqJkZUufC5/jqMQ3XF2j6BLds5KkbMUGx2Bp0jy4i8cqvhV8Nib2xxuPnM9CwFmdFvuHbVymlogRHF9KkLkAEoHgE8lLxSQ/QC5wdghT2+lmY73ZoX4PzPGDxIZvSyn+QTkec1LOa3K+wj0jEe1Fl8XQn141wBe4vQSRUgibUleq6LwBDWLzeB6+NzvuStgr3G/EaUOmZb4Uq+jICyI3gL2sdXyP71DZBGP5GC3WpHedFvnx8bXS7qPj1Z2hSnJyhmfcD5K0gLeJ1UOXXnQGlsWa+RWFDo+Hh66HE3tMggjzV+V0iKX7Px7sdsc6Uu864BQLM+F7gj8KK0ti3tLRXLnmPTFZjlJelE/k9GE+suVFjZl7ouvyxArsFF1u8W8rHM1uwNgf8RW5cmHvjucmfroN5rH4/xNgFH8bVGOcCfbB5xplri44NccChRsHZYwvhSiM84m/dzDu6ldLz0U4Pg9rJ8QvvTch7axrGRDR+LesmEksx4mZhq0elIXicCrQzNGW46ubacx5jmJEWVKx5Q5S0cD0bUQA6uh/l1qNXJUnjrw8mC2ntUgFjCJSMjHpWryIoeWgoi42OPws7rBApVvosoTo2Sw5TjfJxp6ULwS2UDz/5mLof4XhZsiYZQExyefQv5jk726uZ/dgCf7//9UdFS+x7ZlRqK9qed/rWP70do9p+8raUkYJpU6Xl9doZnYpjZUU7S3UbceLWvdc3FVdcvfW3/YBy1hZ6WOxRoE/Q8UODUkXXIpUZBqzU/rHC0Amx57JiBax5ju6G5D3iT5OubDankSt8nZx0ki+4Fndcui8YKeqJUU/EUz1MWQRYhxhYIWlj0UfOfp71wc7q9o1lcocrhqxYhUqGaxMII5gA4MW+wnxlSlAlWAcCp7v48UU54JbupVqGNVNBLpAQ
 gDEeZHJp
 +fHVSoipUk/vOZksdN0nvTc7L0/ggA+USY2hLrfDfPMolgaUDN+MqTpnTuT0rwoCpat3PPqjXkVrv3gPvj0/aRxuam1e2OJ9rKDjEBIQxFUC1HTIDC3TvuiEI9mamuA9iY88xgzZSf/pvOk++tQP6rUuT3aYDL0mdMM1BM4C1UDWxR1S4RoeosDjURXGtMj/lFByi87fHkyV22XDQDRkJ6bIZNA72UpQS8JWhKzEVn8BnrfuWj7KjBlrT9wWl27upmdJ83AUOkJpLrnUySGcdjibyF/PvsDSyx3GBMKOrtNAmKM1aGEqwEB/nSQQLw01lwrRKG4dc02vTFAK9I0ZgZLgEVoZj0i5AyTrXv0TfTKdfxchUz7ixak831f99d2LJi7al+PRTXTrz/lnDi4oKZd1S1AnLuGyNj5NHciEdK5PaEWFMiHFZxANS99pgRnMsBVqtOQVevTxfwox2gKRTFz/bM8bXEWakG/jFHM58W4IkSZ5UBOxBoQP+iydPek+FTFwjN33jTnslwU+RTF2tbeBh4RAdXUzXzvrGB1BN49Ychz4LAczoon3ACC0fIyk+3TqIHg3aJ16o5VYTjv35w/LvDCl+QUpnYqzla4Q6aMbDLrnoEivydTdSkCuxgJrBxb9cXg5M8ik+L6YU+H3fHCXhfCyj+EodWhY8tT9WSbq3IodI/Rd/Jg9/rw==
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 8f74d4bfd591..e26535f3b8bd 100644
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
2.53.0


