Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF32ECD6E49
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED8A6B00D8; Wed, 27 May 2026 10:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677AD6B00D9; Wed, 27 May 2026 10:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5A56B00DA; Wed, 27 May 2026 10:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE976B00D8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 160D7405F0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:26 +0000 (UTC)
X-FDA: 84813369732.30.ED937C5
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D01A1A000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B5IUtF3D;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+w3iXXiIbm9QTHlEZJbBBJGqtECrTHGYD283Ga9Jpbg=;
	b=gKjRUZwZe7Kt9h4iFpidAnJjMnKSG6llfPBX6y+Q4iHayNfbOTxzO+ieBY5UahaEoTDEUM
	/LPStC8s6cmFmxl4GNiK32Bm4jSwlSeQNRHGWQ/jPe9uGsr8S+y3X+TSRy0eboCH0MHpqW
	z9Abq+fAwHu7/EqkEgnQDp82BVxTulQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890664; a=rsa-sha256;
	cv=none;
	b=6KEDMNsZDW19JkpqpteztcYsW/Vizn2jWyowan/oK1w9j5xAcHbyB0ZB71TyadDWfn1HQl
	YEq+9LmoDpoeSRxALnj95x6P3O0pKPzwFBpg+t7MBJg26LPeobjhsU7j5Hpranl5HajPMQ
	HpLcYdj5ZMsWHx2BoHefT/gEIQ6J9vQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B5IUtF3D;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bd2e8931915so2353476066b.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890663; x=1780495463; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+w3iXXiIbm9QTHlEZJbBBJGqtECrTHGYD283Ga9Jpbg=;
        b=B5IUtF3DnKqPPVa4L4ufT5tvZ3G9L1/JAgTDBMy1hnpZ7p0k0/Tj8nkMPzi6gfV0Z/
         MN9yU0fDVfpgYQYyS0dgSYWd5jHzkaDHaJJHOwflYsay1QuPQyNzqNeV6OLHP1UwFtiY
         nTtc/nf24uzmF6GFcPJH+rDz6gwVmqk/2anzO55Ab9ZUcgpb8e25d/1024zjFTU9uo8n
         LN64dMmx9Lj2xgMX2HsggdVdTyhz7PI6sVaPrkaOXOBoFl1y2Zuiv+w4ltXQQYlnsGHz
         zLloXM43ZeKKksmbIOAz6yimHufEDdMaKdKIPXt6BFKGCKl2ZUdat8O/Lr7rK3zb5YcM
         SemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890663; x=1780495463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+w3iXXiIbm9QTHlEZJbBBJGqtECrTHGYD283Ga9Jpbg=;
        b=IMiW9e2Edu1x3D8gxDW/6t6DhBOQmqOlvA8cU8/VrhPpcxvgG58fQslQM/M+dQWmxy
         b7fhwBlrPMj4hSDQ5o+2irXIprQp7dNwqAKY7aLR/fSfobEBViY7itxFIPYi+ApRSNis
         10VA8XbKyTlPWv4HqmzEhS1+MSlLCjDOMBWprf46+0ck50yiwBtaVDkQsIXxd/Vg1ink
         qTik/OgKIpvUwaOZoCSlDvDa/rbIFa2eD2ZYzu+5Um/b11MUHuLzsa1m5qcowOcrMCVZ
         TIttYfy1THIzzwhJFGCtsfeunEaYH/C5LOlx1NRoZ+BLWwGi5/vAiN7k6aTQao8SKKG+
         EcLg==
X-Forwarded-Encrypted: i=1; AFNElJ+V16ZspmUQH8btAjxo1pM63oslQFFCiZ0Oq08acVSV/0YMT06uTj6cxkhyuqMBCANIymkcgB6bMQ==@kvack.org
X-Gm-Message-State: AOJu0YyKKZj94pA08oKalyenwXwYv7heSyQVaktGUAcHg/lzcBHKvoQH
	b6ZNbNRO7/s/XMJ2eQaXZ06quRLibnJzrEvd0Ru6Fjp7lmnCrnuBGzir
X-Gm-Gg: Acq92OFbP7/3gKcHMsyhfGCkJiEpXlQJLa9zkEWlMtYH+1qZBHjc8yS1SuFm+4FnmOV
	Wg3CoCcsbmepolgsHSICb1JS+dbM6+OjZ/UVl7dlLNisLiN9pgI2wXbjrhNX1LSWGSf/wuRlwyf
	oNVJq5Txb5gKn73/sPs7I3A7AkvFQg5n/SISsNErnIMOlb6JzVsALxOKXCBZmKJmmOHL2LJSYwO
	4sMxGlrZqtTwJES4iN/xqueqWHMHyASw92Cfs3gTLzTOS6VDT8T+9U38Ze2KTij1L95TMj+2xps
	W7P+xCztk6wSeu2Hr75/srgIINk8JXrZJzQjOmvhkvpuY87ZI5My0cGABiYt2D4xF3jccDvOyIS
	yOVDviTyC0y668ZX1rNHgTR13qVVtfD8N0cs/J5dsjnM+4U7V/oR1JzC2spg+ut4jlDCdNioiLP
	oGqaYIm9A/JmtViQSmSzk9Q8myq9nfsvYF4QD1JOUtdTZXMSHl5xqDzgPMdVYOAJoFZ+Om20N6Y
	WieH+Qdqdf6ra4qvsXE3zzXKaTWuErWJfNIBdNeYyf3
X-Received: by 2002:a17:907:970e:b0:bd8:f7f0:d740 with SMTP id a640c23a62f3a-bdbfcbcc4efmr1446753266b.0.1779890662461;
        Wed, 27 May 2026 07:04:22 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:21 -0700 (PDT)
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
Subject: [PATCH 9/9] x86/xen: Convert xen_mm_unpin_all() to ptdescs
Date: Wed, 27 May 2026 15:03:16 +0100
Message-ID: <20260527140316.294621-10-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D01A1A000B
X-Stat-Signature: 4hnba7gxdgtpuopxnx6w8yhc31z8kr6t
X-Rspamd-Server: rspam06
X-HE-Tag: 1779890663-804202
X-HE-Meta: U2FsdGVkX18i4CTnXIySptEuqJK37qufroxuzoafUCFD3OpvqWQkY3vGql2GaObDmzKJ0kmXZd2t13BEN4c7TPydxWKKhNzkZ44k2KxwGTzLI1i0pqe8vF5m8Mf0tn68SnP8dfQ3vxSReoin/ClM8HzzX9TdzSPsmORtj+R6tDL1LKzoCpihH5Nxgv5FOAzxFEmejz3jv1c7sPf5V19x6xbFr0ZUKYy1XjuxNgWKsIDbNdW/kHLqI3RZXuMFYsbTgW13ParGNYlTiPobrwuxe1oxI9Udcmzr9KDBfQUFYCNKf8xhYt34mZ910srv+kh8j3bmPGGt/uxnR8rEdwZZkSxIMyLXRVs3lrPPAluRFZRxEvOXh0LYTbknwc/hN+RwBpzEfBB4swXDnVfY36oO8zbkPREte/aw2uLd0A4wHl0XZcIQCH/IeRELC4+eoEIJ43zhnWlykws6okrB5bFVEeJv3bgn0bErMMqtj/lLf8hEv2hmL39GrFpN7OefP4d7Ukqr51ZiKlACMxReWjRmpYuzYmB5VsszlYQR4jHznkpY7BAUZFjkj31OM3WCltZks+VlZs+FK9DPBpC4+iLEU4aOBI581KwsQMvmb1mJGnix5bRcG9PrRrgZu4xP4OcZYK+KjCWepFJvDyOzldX1G4+Sbi/q0oeXKl9P0neM+wxwqM16NN1LzoaGC1xYRDP786kAOegZUu54QLicmanHghS8p5m0lfh66k35UnAhaZZpqyXYRa7KQTwStlhwsv4TCSEI2IG+lNfYMzhoqy3ImsMK/whqzv2fFWSahLQS0Czmd24uOriTPRFgXxY4ZB04M3NHOkWJka22fEQem/dAgpoCc8Ca573egBgj4yT7XXonw9U8+LYjV2LEmIyIHOz6VCj7rdS3vz2Ri23rlY2uyPtbqF2q/fmJskYyGuDSS/VlGtysDV86FlTjkun1eCo1g92azX1wodBl00WQ78N
 ilcTj+Es
 oCeYRvzKcYPWWIX0P6ceTAjEvRmkgS/Rlvt9LL+qXVijPbgao4cS1ath7ZlkiFPmsO6r+2qQEu+A2PkoGVV54auEn8uL6igIbZfZcMS0t7PRYRJ80REme8eIfy7VLsy4NN/KGCKl3EplThAC4vMTQbSWN/G4DlBIaRTZ5Jvxif63ZPcKrHRVwItMgv6DlZC3lUcFCwYNofaahjCnLLxvwGx5nRMVVegm1BsNSgQwGggcQjc2Es1KTRWTuHjG1uA9Ep2nowTSvOh9w9+KfSuRa72BLmt/Joo9qZwxOKr01PFtJ9gTKGUaelc5ygkOJLdlBf37nRGsmwaVV1iYrpfp+645Rmzvs3EZ9wFCIa8BK7lmtqWqav7r15GdyqDPhg3x4J+qH9SRVCc5B2USsTro6huoNUD63R4fAyRKhlpztaADsEoY3K3Afs44ljb7bkN0SxEl5tCfswElif21wzxihI3Gh0r+qtW2XL3xDN6FepEj+XfQJL9TgqqnK130+ZGKwDtOJA9rrd+BbAcICX43/EKPKSkJcyGI3VFakiC4R8B5xqgZcdWVBR6CBjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert xen_mm_unpin_all() to ptdescs in preparation for the eventual
splitting of ptdescs from struct page. Continue checking PagePinned
through the underlying page as we do not have a per-memdesc api yet.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/xen/mmu_pv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index b2f6e7b7c545..c4731c1e842d 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -939,16 +939,16 @@ static void xen_pgd_unpin(struct mm_struct *mm)
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


