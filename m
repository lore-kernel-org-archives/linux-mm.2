Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2220ECD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1556B00D2; Wed, 27 May 2026 10:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89936B00D4; Wed, 27 May 2026 10:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81EA6B00D5; Wed, 27 May 2026 10:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAD2D6B00D2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DB7240600
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:21 +0000 (UTC)
X-FDA: 84813369522.12.1C1D518
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54E58A0017
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CCRHTIcX;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2LXP0rk0yvbCFBliNg/BHdi3EXRn2M/q6qufOUbEAs=;
	b=z3yj8wsx3hlwDMbd3Z4VOShzgytR5Udd0VzMkYzlcsC+RJ3n46uyD5pGD1OQ7BPzoMu1jE
	vv7k6IAV3FI+OjkP71/qWGfMBtpi7BuJgh+jNNoCRLiaCe5ew/kPqpaavVA7LKmhCUxqUa
	AK21lxqjGkOidon8qHQOl8H5lTZ8tAM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CCRHTIcX;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890659; a=rsa-sha256;
	cv=none;
	b=cBkFwKwQ5M/5FjFTADPz0xWg9FLRU7Ki34j1xH4qIURZvOK2w9gz/eUCf3QrvEJVzRani5
	+vLzCJIKARUueRAjPM+hEP47ruPRvRP4RHfePnEdwIae77weH3zYDsv8AbtQfP2EAx7soZ
	CqxqWzq334enrmoLyBVVNE5qfvHHOJ4=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49050bfe053so22221835e9.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890658; x=1780495458; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2LXP0rk0yvbCFBliNg/BHdi3EXRn2M/q6qufOUbEAs=;
        b=CCRHTIcXLNVpxGbzCHReqcju4+ldD3663UFd+yNLQSYs+nrc9jH2xa+cZNhRMk/c8T
         AjeQJas33fotlrdswMoLHXDf007K5rMq/wNi261YkS5VvzfSqRdlCMLxnpyQyRyD6p1s
         zuU7P1dw9Fp+Cb6wsXJEhVgD1/zaHIvj4TD6QFws8pZ7amtrOfhRJaFvhDX7nlOI6RuX
         80WoyTPKuoYdyrAmGFnhm6DgC/6OLzrFziWyY9BycFaVfTNkvLU3Ehz+169R7Gw5u6qM
         +1EFfWi3aX8MeQMM3W7ZpIBMpx75zSaQad7tDlCA7qtM6gDPNamD61kikmtH+8R4V9Na
         ECAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890658; x=1780495458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c2LXP0rk0yvbCFBliNg/BHdi3EXRn2M/q6qufOUbEAs=;
        b=Or71DX+LBTAirIn5jqgF+mTnMoRKcOkP39oU8WjtJXt5NYafaffUxoAURm/fULsjuz
         p5YVK1yGHQEz9f69/0MIy9v+D65mBbOktZWBD4GUnZRuJSFLud90pcvFQroIQIqbFgde
         rLEE381zIDxdh+OpyfR0aaJDIsFkzjDlHtiodEagBucq3or/sPq5Q1m31uDdnX1zFtMX
         kpbF1javyCbfuxIEo+waO+1b62VH8L88OYZuQv+jOkX0m4Lddyvoc/Q5oZkqv+ruBS34
         h++S74DNMj1jDynm6GYjrsXcjIa8SyE0LxJKwZlEPCqCXI8RtSpYoRSLSns/+gwD++rV
         xsog==
X-Forwarded-Encrypted: i=1; AFNElJ98jeFbkywc3C2vc9olLQ2CYhJv+IlUBMUDcBGa5hUiR8F0cO+7ZRJYjjm0IfN0NEHT0LDNUoySbg==@kvack.org
X-Gm-Message-State: AOJu0YzZ3RkXlB7T7XD4MxGrN6A1+9+0TXv8/BRLoVftOh+Or416ozD5
	272QZ9JLxm+8fdfIJV2YPsvdeyEqmcAox7/mciV7DfrKys9JSbJy/zWw
X-Gm-Gg: Acq92OFdDNw1tNko42Aw5eoWMe7x+zdid6i2PGmmkt2bvDCO+Q4cnHCg/VdBwk9ezwR
	6XI4NUNMdN5ZbRw7lv01crsPXjuvmG9Cq+V349Pmp9pmSlVfE1aSke+W1k+mA4ykeqhYttE79ON
	R8h5+UYMmiAyG1Btd5ti2Ul1sB8TEmg9B1FeD4mYkTz/I/Fz0DaxI9GY7VmnfDNCPeTH3xW+bPv
	kwvrWMwrLJKc3drma1s5buWWF/E9VlEPszlfl7ZAD8UI04yH0Kj4bCVBXJmICAi4daoSsMkRsLs
	G8FKNzKH4swGO6C5vYjmLNWWGu3E1D9YRicDLpbDbmBhN82ju5F/SRILNRcja4XYrcK9tj1mTqX
	rstXpxboUmCg1cgujgfrJ/VXHg2LKdHBmtZQD6hI3GC91YTNMSYqxtgXJ12m9wpEr7IpIHZke33
	FA+STxsycIu5ru2j0vWiV/w5Cm/EpK04PaQuxoFvQFRD3gvL/6CS2rI1qQfQgi5C7sSufo3UtAr
	ZTV/+P8kgRf780h6f+SzgHlSvpx6mSyYO+1cdM1H9Lg
X-Received: by 2002:a05:600c:1553:b0:490:53b0:9e53 with SMTP id 5b1f17b1804b1-49053b0a086mr320397125e9.1.1779890657764;
        Wed, 27 May 2026 07:04:17 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:17 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 6/9] x86/mm: Convert sync_global_pgds_l4() to ptdescs
Date: Wed, 27 May 2026 15:03:13 +0100
Message-ID: <20260527140316.294621-7-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: tf9pcpg1he3temisx1dr43i1x4y8dpxo
X-Rspam-User: 
X-Rspamd-Queue-Id: 54E58A0017
X-HE-Tag: 1779890659-687168
X-HE-Meta: U2FsdGVkX19gi6cD8pzuedg83MucEHI0a+oShURRtHa6TpVzuO/FRvZQLNWcYCKhM1+YSMPR+g3A0f0l9CpgBTxgudR9AU99PqTWl1UpO8RCXTuaPxo++Rz483Kp5vJSzZA67jIaol0b5OARHJ5qabFqTNhKweheaiIQCvfGonvLZs9RhulmxKYV2rW/zDgRM46NzpD32DNAAgcKo1KSix6N5ZVb3HM0DtLquHGnMZBP1QsJei46FuLG/v6zZqYIEicMwh/yPfUgvQCLCnm6I2TowUnhGZse5U33zHOG5s2HHFX8oZfL60lsupksvwYvGQiHuNjQqQrC9pQPJAmzqBur+a6AZenoPgbsc/IpJDL2ResJmNzZF1ZG+iB7CbfswEL9mXyjOBJPwx1uEH8iT83Fan77PuUe7YnKkMDH/F86ZuEfGc+RIZs/iIys7QzI9B/0weTTBu2ip9wenBcuid6r2uRC8SoErQ5uoEbXrx4OCzvEnA2TvdpIJTBKAKkWaZz6paYTYlyjH6VSMejszeKCzlZoBFMLpVCS35yRTtV5tJkH3u3XYW5++kCotDeYdS/KulLrSNx6FNN19rfVErl4OvIN4brJ/2odEUBMhaHm+1vryzFqZlNx0UJ0OJBB2nnfHasJtkAjyWPdVzHVLtdk2rErcUVkHMLia5a4sXbP7Twmz0VH75wIi1gDDGTWMl8k2fSfvQYbI2wYT36l70a63ozARSgrZ6iUtyEXC/huk2ZL6wOLDje/boPsR6KZXy06xFUrU9+B0PxUm8rEKUIGIKwBG2voDVejyYLtepVbqwJLSypYXRsjmt5H0z1GXCcDJcH1+P0LXYA/GnUciXcPTsLV9sm0KyNWSA23hKQnaHYW0vVdabKZiziF5WJNrCZjIJz874QpLfOX2pqcHqg6RXrKspjAy2U0vDhPEGcvns23agRYnSDp94A0TOLj3Wg/asTpErMAZ6h7bkk
 bEsP6x3s
 nHesuFSbHv3veW5R8Mn/KeueCwekL6NLYSYbNztfoeyA/DHBlZxj5u5vGRLOf8+CqqulGAjd42nZt6LIIUO0i7Yvbj4mbYE5tcwusH908+VNOVW3Fa9SVFQoZmTbLLYStr5suz5Wj+XSSosbFjWXByeTKGXMMBZQpoFZOpqE1Z58GVqo0AwoAaijuhb1LbU25zGZAAA4Vd8AgO4ArK67iEmVneKBug6gObwrB4cUY9+UF7KqPZhRhJA7SbmG1efZmcYwkRPdp1azZFOYkcqebtbm4sRGtF88OwSbyymqJ1ndNCXubLAP3Vf7PQNdnr15TeY/cgJjlx7wIkK88dQsXqpzT/yTBsZY+1UjM42PbZV5WVWcFY4Qyr8UROEOBz5id3D5YIvfnVVoOry9auDHN/8JyaZmdqAFj7Kl8RbgKXmFdZQWgEYRTV9TLOYgNGsrvMbYeuIr6m3BfBldpQwDQh+6JlOdo2X+Od/dTFZFFAFa9xJttRfdC8bGipGfrpWaIMLslJySOkEtU/2LZJetUBirKVXIqWyN01wg6f6w5DtnLtCbjPmr2azlxVPED0TEAwjDeRJbnXwNxFgL6qfVk/FLjEihemaSx7/5SX0fuInIdgTww3taeVMKSfAdRFfRmOinqwbBKEOQxUXLoQ8MR7iFpqUdigBpnp4VDrzbs+pCLJU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert sync_global_pgds_l4() to ptdescs in preparation for the
eventual splitting of ptdescs from struct page.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/init_64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e89b51aea2cf..a6ccb83f2d26 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -174,7 +174,7 @@ static void sync_global_pgds_l4(unsigned long start, unsigned long end)
 	for (addr = start; addr <= end; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
 		pgd_t *pgd_ref = pgd_offset_k(addr);
 		const p4d_t *p4d_ref;
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		/*
 		 * With folded p4d, pgd_none() is always false, we need to
@@ -187,15 +187,15 @@ static void sync_global_pgds_l4(unsigned long start, unsigned long end)
 			continue;
 
 		spin_lock(&pgd_lock);
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			pgd_t *pgd;
 			p4d_t *p4d;
 			spinlock_t *pgt_lock;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(addr);
+			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			p4d = p4d_offset(pgd, addr);
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
 			spin_lock(pgt_lock);
 
 			if (!p4d_none(*p4d_ref) && !p4d_none(*p4d))
-- 
2.54.0


