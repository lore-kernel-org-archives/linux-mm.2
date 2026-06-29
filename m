Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5155C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE036B00F5; Mon, 29 Jun 2026 14:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F066B00F8; Mon, 29 Jun 2026 14:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430776B00FA; Mon, 29 Jun 2026 14:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 113DF6B00F5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BC83120247
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:10 +0000 (UTC)
X-FDA: 84933862860.28.7CC73A6
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD11C40011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gHoLWkvD;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759548;
	b=Tfiul03O05NIcW90azVEQetbq9ixdRB5v3dE/lHzIRsPmGGb5iDL1gjCcrE1CxR5rrYyWU
	lpw7At2mwBNGLMdF4S0o4Y8h2SzXzK8Hn8MobHEXOHiF9gd99N50HT6r+mxLjQdEXMdAi2
	jTfMRF3eF6SEYiDmhn9N2IHOJ64VIH0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqbRLQXqHRkpiVjsMMKe6YOb40PaFb2scBTkKxGJIlw=;
	b=59rJLBFV0rX36osVKagLBXdtbFOCcsX+88Ta7ioP3q7+b3dG5MC8gBlyy0v4KsEEDYFq9h
	Yr0XSGsBDL1sXQjMXu+XoM9t/Q3HF//BmrJAyZyEi1Mpk1y8+mU6HMO7MKfVv7ixY18P9F
	n+RTocqqg5qkpfA9sNT+PqviS/kQ2ZA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gHoLWkvD;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8423f236418so1857686b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759547; x=1783364347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CqbRLQXqHRkpiVjsMMKe6YOb40PaFb2scBTkKxGJIlw=;
        b=gHoLWkvDKFlFe/lV1htiRxUJbulLt9QpSOCar61oCzBLwe/aos3b5wyPS9DCzfR4Xy
         DNDObPF6c8znE3IVH1x79aK/9ArmdoAgt5+01Av0kBEpCZEWrmLq2cPpgKB0ebCFXRXY
         IJytgRn3mW58AJXWfSsgn14baVzgkoUzDBtpq/aR5X3ck/xH700MaVN70dE5u9DXz140
         a5Q59p2SwnrVVZ8yJ9e3qDZTLtNyO+Z54nQ8iiOT91a6k5fBFedoB/gg3/gcfeLgFFDA
         rkV9nw0OirX7U8SAD20ITZ114MHcSQBMO2ok4AkXiWnlk0tg92ZjTt90+yMT6m23fysG
         bHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759547; x=1783364347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CqbRLQXqHRkpiVjsMMKe6YOb40PaFb2scBTkKxGJIlw=;
        b=m4XFm1PqfhpOBIwZfuhf+CgYPfj/b8bXV8o3eb219xPDRbHo0uD4XQpo4ZHZnsU4nK
         V24gXp5dcd61s25ge32pOPD4DVpwTC/3tddmfE3nsLx1SlcJDGKORhaVeAdf48EqhZzE
         4FWwNOTd52mxEAU5jLzLnovqEPg40cEzk9fygPXYoydDWl8sth4sGee25Sl2q0WQLtaP
         NAaKVlYNhvp/YYwXkCi+DFJN8fOLRejpQxp8kC4tkwSdHX6Uz08glxHc46LmXEMC2AAQ
         vnWDe9Xd+kFBlFO1sJG/3aGVL9wHxBs3RbG1xEPynslbveJy+yqrb05sPxhGW3R+7w6A
         MzTA==
X-Forwarded-Encrypted: i=1; AHgh+RpclXyTbHJAMR1+RzGf9VQDKR3RW/xU8BGT7M57nHc8q79LSsqQoC+P7YA1i7iLiYvjCgTL1fsq/A==@kvack.org
X-Gm-Message-State: AOJu0YxIF0x/tzZd8zy7Q1GMO+SzQr02bcNbgI5pGVZWRdYb5ElkHOZA
	j/c9hNC9aBqgGsFELL6kuf58dLt0gJhW3VWxCNynjVlomXhUaJ/Hu98o
X-Gm-Gg: AfdE7cnoddycnw0Pppg0A+8cCMch8aENE1cWEYazdgSKQObVOmyTkFjwvc6A5AVS31c
	1l7rd6kBeSTtpyhBV3MD/z0/TrePFaEOGlNK5czSDLerJdCqXubiMVRVSdg4/vthxHO8ZAP9665
	94uYlFKlZSOo4K90EMFbHIrq6/BJbRYVYA5dSEOPcRss76qOdvT3KK1DU4rFHt7yRYRErS7TVoq
	GB1b4BrPLTL3kqgJZluJvX1H4gNgoISSiLxCNXZz2j/kvEptx95atX4NfpoWgualCRylSbzIExS
	3ba/kVecL3cD7LZg6Ozsucd+vwqKKgH2WrKkGcFDJBWlwViCFg3V2zDqTnHtz3ZQ7IFHV4bRoqY
	p8qNvnLLKHXQqHsSoq9EagPDzRTWiOxS1Wa/y8hvs6MsnDQdef3WRsTzMNluJPHHQARw1kGKvGP
	b3H7kYeWZSDSIvQewOUMqhLqZKNK8FjQ8gtLtB1vCDjkHU6tb2c0Bacykc3uPsLkVFOoF4x4Q=
X-Received: by 2002:a05:6a00:2913:b0:845:d729:4477 with SMTP id d2e1a72fcca58-8479f146866mr478498b3a.27.1782759547578;
        Mon, 29 Jun 2026 11:59:07 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:59:06 -0700 (PDT)
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
	Vishal Moola <vishal.moola@gmail.com>,
	William Kucharski <william.kucharski@linux.dev>
Subject: [PATCH v2 8/9] x86/xen: Convert xen_mm_pin_all() to ptdescs
Date: Mon, 29 Jun 2026 11:57:41 -0700
Message-ID: <20260629185742.126987-9-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD11C40011
X-Rspam-User: 
X-Stat-Signature: dqkky8d48aqzisym8knp864jq8mgc5bt
X-HE-Tag: 1782759548-789640
X-HE-Meta: U2FsdGVkX1+RroZRspMn06UueLdizv94TIe9cMv3wbalJKZ6RzhK4VqjKhokd+G05xspsHfu1dxkeJm8fLlbpRNDPum5xKiUPCm6EhZK0rnfEBSLr91bjkp+N6IC716m844FASAnlGPr67qFuvL0oyFvKewKCROenWJIfbbB3TNX+07073dlbqBoy98K/dxkTNhDv4YfYv+RNyRu8Ad3Sio+Y6D+dd91G9X/IqxH6827xnG7VRWowJFSkGkZnL7Y8uKJy0/l+iOQVC987Am9MLT1Zyjy2LvS1yK6EMs/+A5GZe/evPoVeQwtoQa5JU74iLuqWBG3SFY98jVG5n1Gf8ZwSFJwzFboajWYeH0cczcEGBBl8tGDVSJ0+SwIlls2+Y9NJj4MUWX32K1tgTgyOlmyZPFpS7HNzfSRwWCa0LBX9ngj/KNth8+K3HZYzPlqEA+TtZfW+yXrWEBJgMyXolKEVte7tEZGZCmse/WTXkxhbByF/hsbmPC3AgnzY2Nsu5Oh0z2M/exOhCHmgsBUBgQM/vOpvIkBnXxiOU7AMA6yd0ds2jZIIT+egu9jqRY3q4kc5qf/ZRiuUehAiReLSkHcfvQlKMBMs61G+Bk5FnYHZhXJcTqNCsxdedkzLdfSeLkQjj4+Xa46Qi7NePd9p3xXJCWIrTjctiaBLd8IFYbO7d2cX60eLmqfFqxp8OkZtGdjZJlxat8+IFHjW0fYIN455VCNUmFy8U0+fs22OxodgNmtZED8wSXTmiwBWxTe0WziYjR9p7U8lQ0k3Ccd0svXsXWWM63gEf30v2E2I5bMkfSv5TZf7F7P1+tMPPwBD6IWzu8JsByeCZbVh/Wvdm7QXjnY5QjMBIBYNIOMLS+aywKS72OU974m4b3yJ3gafWIp0g6EaxkejNSbCv9laGl2+wgi7hf5wtgPrWaH9qDAAjMlyCNUILXHI3qXfmlbMLekZd2o+q3GOhUEmV8
 0NthUbTM
 b4idHKG6dMH6CAQBDBL0T+4oHgmUE0Gqoq/me20N2OmLo4NCbZnX+g7untLt3Q3L1zbwBUogctWlDwA6BtYkCcylJ7OZX0AihJB+vDlfLDwkghTWYNjE77Mx9eUFpQPPaxKOoe7CNvu+j5rker3kPAr73AK8GqozJ9kMz8Fn2NoHltWLKaeComd0m8kTPUnpnRnLYhSyLb+El+CdFs4vvsJHfLRto1WOquLJowipu7vPkJ25OBRyeLZfAO/RcEjQIF9i/XQ6YGL/d8x/etcwkTeFL2jymGsLqH3x2qLr6qmkTP0beeO57Vqv7Y2hvbn37V2d+1oKdEIWSvgCqAg/3JuDvDN5iaO0dHr+8t/xfFFcb5VmC20xFmpMGoPdPdjjhZR0R4+jDVwj5XGfrucSSfB3hwcualnAarnqXYSTC2XzUeMr/pZOLcmR8lms5dAxENJGcEl7AIr93j6pIPGbn0tDPqEeyynNRLmkOM1MGvYz+Hzb8IZ2cr7vgba6YAqyZfWXZDscp8x/T/1E3QsSv/1jvX/o7f9fX4a+vWcF0kqYA56ZohzwJETyxFVpzt/QwHLdzOLANiqnSwZl/58xj1Obr0fohRzwQQA/P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert xen_mm_pin_all() to ptdescs in preparation for the eventual
splitting of ptdescs from struct page. Continue checking PagePinned
through the underlying page as we do not have a per-memdesc api for
page flags yet.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/xen/mmu_pv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index aab5f70d407c..7b23a34db8ff 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -836,15 +836,15 @@ static void xen_pgd_pin(struct mm_struct *mm)
  */
 void xen_mm_pin_all(void)
 {
-	struct page *page;
+	struct ptdesc *ptdesc;
 
 	spin_lock(&init_mm.page_table_lock);
 	spin_lock(&pgd_lock);
 
-	list_for_each_entry(page, &pgd_list, lru) {
-		if (!PagePinned(page)) {
-			__xen_pgd_pin(&init_mm, (pgd_t *)page_address(page));
-			SetPageSavePinned(page);
+	list_for_each_entry(ptdesc, &pgd_list, pt_list) {
+		if (!PagePinned(ptdesc_page(ptdesc))) {
+			__xen_pgd_pin(&init_mm, (pgd_t *)ptdesc_address(ptdesc));
+			SetPageSavePinned(ptdesc_page(ptdesc));
 		}
 	}
 
-- 
2.54.0


