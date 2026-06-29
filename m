Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4060C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20996B00F8; Mon, 29 Jun 2026 14:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8076B00FC; Mon, 29 Jun 2026 14:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0356B00FD; Mon, 29 Jun 2026 14:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 788B26B00F8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E86CB167631
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:11 +0000 (UTC)
X-FDA: 84933862902.27.BAF4D2C
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2ABD8100008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DFiKzzgV;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759550;
	b=5te1AjI921Weq8tUVJ0IVlGrvuP5/ENNstNnNLA1AT+bcAU4A6XTauwrepx9MNddOZHYWq
	32Qt2ZdHwpLfU0it0oEfRprkX1lITocE500cSSSoOPAbdTS0lXm6GMJ1mFNz8RK8GQuNJb
	CIghQOayJdRRiPnFCHE4t/eP8nMytFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzFzFTeSRsUwmgBU8TSW+xSkFmk/uW2c+RWIXDiDEHM=;
	b=6oZPFPdiXlVDD/uc7IDfYnOeOKPBXNGLBwOdlk+nt5I4Oxv5fwqus9YmaQeGY0Jf6KsOYb
	c1e8+AkfAsFHS1uawbgIKTip34yUtKKUdHfCrqbUtRqEsBsnzqbDsQRqelXI/WR4z4fVGF
	oGOPw6cHPLqx9EwsU1K7S0DVrBXsAFk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DFiKzzgV;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-845b733e82cso2323172b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759549; x=1783364349; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzFzFTeSRsUwmgBU8TSW+xSkFmk/uW2c+RWIXDiDEHM=;
        b=DFiKzzgVQ0NoASISah5sZr2n6cZCgdXuKCnvQHzRDLO0LgEqmAq9uCUNc1/8Rmtjnv
         HGg9vjXNNCCwsVCvzpXD/nLNkGnAqojKt+iA95VBRsERZjChNsQqwL5NOmAZltKvaO05
         BmEabRBgtiNoEp2AWKpHeOuqqvCZghkSmFmhwekArwcu3m92Z6hpDNrlI/bGTw77/eDS
         XL03ajBeOlXGB0Q3SdP01B4XQrTEEBC9YbMGHKmAGKQx/+siXhKR4eBcWg+JwR0HIljc
         4l6mu5OrOBiXqVsuoeh0C/GlUl0WBGmN5jNJM0m/V8K//Ct5AHKWAoPsJ4MhKaNsysrN
         d4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759549; x=1783364349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lzFzFTeSRsUwmgBU8TSW+xSkFmk/uW2c+RWIXDiDEHM=;
        b=g+VGLHGl9IUu1o3is8OeHvRSLEXpNi4z7gbyE4lv0Qe3DG5UEspNnUuTyTFN35lvd4
         vDEDQoBQC8ptjXp+CsMmauYkP4u2+BhQeKCky6P7sNq4vP7h6IwpsQFByXsTkMTZvLBj
         mpMrmQsl3U3vSa2zBUZ48NeLiqhUTs31YRW/qpjgzcCIBmUvBIh/MxwjUC/w97Ayz0F6
         Gfmiy2R6+NV4tW5Z7pQr4BtIR72ANLaLGCuLRYDVLTio4V4MP2AnmJnrcK+bqWcq+RE9
         +TtvBkfcIRXkXlumDSSba3yyZryJf0g4ulGAQl1EhXknXM0VEIyx/bD4Xsjzh8Z9xnga
         NFgg==
X-Forwarded-Encrypted: i=1; AFNElJ9fe7cLHtWv+d3ETOP/XyFsP6AWNGfXKlsHlwSGZtuwYzDWjXpEszPY+kQ+JIVA+rH7+UaEOlNYbw==@kvack.org
X-Gm-Message-State: AOJu0Yz8xIS9HpHK57Bw6BM6KTu8T0jLTAyPZ99LQcskZ77IvpCugU5q
	+6ib2Sz5j89HQntcfxLNSRXQiZhnPF0fzHvCAEw3kvBzTPN1rmXthGPS
X-Gm-Gg: AfdE7ck8/1PAi/fuQeTGvN8krXGqDz1IRYoSvSQRUfTifjL73d4Lyjvv8NDjOQcpvvB
	4NNjrXTkwZzX/mHn0bmLMMXMgh8psjwZKx8qc9QrmFatkma3/9XfZ0BqffWR72M44rdO538+bCB
	CeCRwZ8OZur2bwiuR9tCJmzGUlZ2YNxKl6+65bb+szrmEzhMWsi3ykjJMyCf3wPZ/UKWVKzm22h
	zEV429QB/ioJN1M40bEF0SMOcK3fdIuizPIMtdSLVE9+Oub+ioys2UYjqArEjN4h32wJGZ4Fnul
	tuo/igMPFAMR3QjBpLdokucr1/wZunDvhsXY4hqUz/zKR1mAK1w8HYkMh5nh8PrcSYYhh2+Y51v
	Rj6kDpVSS8hqXttPsWr0ydOEzOnIlwA/xiG3kWxXVWjF5pt/M0TcxGNSQ7lR4Kb2200HMYcWIAA
	1tia1W/j/1LEyz9x19S4u8cBr92zdBYOIxbRFPshlDJqbgWSppYBf3/MbUSUphhl3K8RIeNL8=
X-Received: by 2002:a05:6a00:c8a:b0:842:688f:3089 with SMTP id d2e1a72fcca58-8479f1c5ec7mr506886b3a.30.1782759549114;
        Mon, 29 Jun 2026 11:59:09 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:59:08 -0700 (PDT)
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
Subject: [PATCH v2 9/9] x86/xen: Convert xen_mm_unpin_all() to ptdescs
Date: Mon, 29 Jun 2026 11:57:42 -0700
Message-ID: <20260629185742.126987-10-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ABD8100008
X-Stat-Signature: ui778k3p41c6b3ufufxpxq8wrucs7iq3
X-HE-Tag: 1782759550-347520
X-HE-Meta: U2FsdGVkX1/0EuToER1m4uPTeRsT3TckzkMIji/5hPpSmIDj/vuSu95SsR7mn3/kNGkEY0f5S65FGlBURQnBKN6sm/80S+68nGv+QQzP3g54lLi9DZAFLODKb7Ruf8HZ5R8Zn/C34SRuiTd55rkoaSd4w7F6WaOKqPGBC+OwY76BFsL2VoaOi205x4WLBE0gxELoMF7+NaEHTHc/wj/u4Lbj/tRScMcckFfk03W2ZM10lrGLYu1BEWPgtzMszKxhUpuy2SAuRUzIhUuAy/SX3iXquPrQoxHXRCH8KTsC4RM7/mIpTRjqrvkXP50Iq1WjtbS/YIMoNGI/4f1EQCKDzUug/Yi5eIW//oHlEQVMP0Z/6QZ6RrwcJxddR+zhpbPpRwqpGEf1DULYyUi3YZegfTIt9mvpETYku52HFVy3n95nNvNyn3Fh+xp0noj+c/uZHfYNYV8yW9M3KDDmRrM7FDEeFX80pFDRprLzuUuj/IpveF4/X5mpBbIvnsPRfD1fp1GBxxv+6EBkjsgIxCdcTprFMPgEJouM6+p8GgXOJbzkFWTkvD16IcT2EvBHndJnOi2vRja37Qrpwa9fc65KVryf2nVpKocLIiz9bWLz+uMDZd91Sn25ra5ifMnMxyE/eb3oyGdC5gXAT0XJUwN5R13b5XbbulWztPZkLlR0SRIKnqLEDtD9+xBzNlOPTDrOX5+0uHNlvog3alRKAzCKzt/GAAXthUn5IDNC6TWcoIlQcrv+GYBGyXccMhur6KnGffNVHS5nm0BSVdgIWmuSKn+GtXejpB0e+FN0J3zYaLpSYnEBmcWGc3ITDF3boOt77mrLnd8KS0uO1dOUpG6IEaYtD63kEDCLqHefSmq6LzKMnHVosKzub9SqJoadMgY29RrtSyylJn32vp2aaBYQqlAfjAI6FprWfeghnFMph+q4oqOX7dTBifqXfhEUSuJHUl36uJsv+7qnfwuMsZP
 920ikFDm
 R4lQqgZlcuaW9pTjK3y5pVkQZy89+zFLxUvG5gIEepDq25soCVlEVJd0rRc+E6euV67yP2X+Q+sq/yf/+6vrHyjNc6Z6EAMOYhamcPuaBYdfYfC/T8j3He0vVvtLDNGCiDck3Xrsz+sqh2NXEXQ/IG1Vm9AIHFSmiAoTucqXUv/EV1A8zM8KRr0bPTi9D7fLoqhyJJ8aNUW3QCkVMY39zI/DLnnzmAHzj//DrYtdYWP379ieEzato4wMuPYma4Vt0YCPhB/ePFY+Oap6zv0xMX8Z8PzN5pyMsM6YJBT0y/MR+FhEiDVx/o2qyTWmmUhz7hnlkNIkgyOTbiOBhQFHk4rZ8di6rWGtRWAYl1xtDOL8v0CTEc4ViawsTC8gZgZ83LBeWeDyqML9ZHTdjRV/G61WjL54u1YUSP5BQV3da7g5QkEa7ODkcFYo52FGYAu9nfcz2wM7uhDF0LIMAmkzPslbaiFz0j2xAZv8pjn9344/sFSqTzpP/nyfgSbhg1FTBgleUIPmOcVr/hMQXlYmHwVY4E8xm2M0a8hzDmtw3JZMn0AmptViEQ+HMprYqAkiXUPEOHgu0Fu33BlgQLg0e24pJafQVJOoWuWXl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert xen_mm_unpin_all() to ptdescs in preparation for the eventual
splitting of ptdescs from struct page. Continue checking PagePinned
through the underlying page as we do not have a per-memdesc api yet.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/xen/mmu_pv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 7b23a34db8ff..6ff5a7130e53 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -947,16 +947,16 @@ static void xen_pgd_unpin(struct mm_struct *mm)
  */
 void xen_mm_unpin_all(void)
 {
-	struct page *page;
+	struct ptdesc *ptdesc;
 
 	spin_lock(&init_mm.page_table_lock);
 	spin_lock(&pgd_lock);
 
-	list_for_each_entry(page, &pgd_list, lru) {
-		if (PageSavePinned(page)) {
-			BUG_ON(!PagePinned(page));
-			__xen_pgd_unpin(&init_mm, (pgd_t *)page_address(page));
-			ClearPageSavePinned(page);
+	list_for_each_entry(ptdesc, &pgd_list, pt_list) {
+		if (PageSavePinned(ptdesc_page(ptdesc))) {
+			BUG_ON(!PagePinned(ptdesc_page(ptdesc)));
+			__xen_pgd_unpin(&init_mm, (pgd_t *)ptdesc_address(ptdesc));
+			ClearPageSavePinned(ptdesc_page(ptdesc));
 		}
 	}
 
-- 
2.54.0


