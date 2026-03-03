Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED0FEDEBEB
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A284B6B0098; Tue,  3 Mar 2026 14:48:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13096B0099; Tue,  3 Mar 2026 14:48:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A18A6B009E; Tue,  3 Mar 2026 14:48:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1896B0098
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:48:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E27414018A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:52 +0000 (UTC)
X-FDA: 84505789704.10.85B7043
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5466A180004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L7wEmocz;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772567330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ija5cl5iw/lXAYwYtLBqZs6EcpnK3FanNYd7fnqfYMs=;
	b=NgX8VOVxYhOt7xEjFMcnCZj9zjDJPul5AtwZ7L7fOaj8XXTvjABKBaZhRKjfTLJjiW/kF6
	NRb5nCphk5Kwx0J0mUDt+ySgqNAxamSypNFEcIh70Fp3mE0Y1NuM5SAxy3FzL6pY8Du0w6
	TbFzxO7yt0PNrKpZ8hEFWu3zKUkW6xw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L7wEmocz;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772567330; a=rsa-sha256;
	cv=none;
	b=Yj+IZ2T2sdc37qL0wZ877xhn/huexIxHuvXNXTiZnE0Yw1DStJ/Cu9uY6iT7LzfQktQaUt
	H+fPXNJDPrvKYnwwtkK29yE+mNCBDgDwOag0rG4xbTIzX1tAGVUmqNVnIvvctILiXldZfU
	C18faDcunoTgGtHp2Ay4dTsBI+iRHsk=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-124a635476fso7082562c88.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772567329; x=1773172129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ija5cl5iw/lXAYwYtLBqZs6EcpnK3FanNYd7fnqfYMs=;
        b=L7wEmocz+kdtIRicKX7vWXHaRqFLcJ+kLHAJUKQxyb3gRZr1bjlEgpHQ86wmGGmMK6
         SwtLIeSzmFLgPsnM+V+ImJRjbPCWDlMyMteXfP2E9OX8F1stlvVB2eL7kdDNd0En2t1n
         F1VgXGPdtT5YRly5HrL0gNoAWhSg0Dn7FPaMq1WxasvoDB3bnbP6GP0jM87WspHTzJ+e
         pUHXYjPc+3cwpXCSc6OPG5AqmR+rT4AU3SjwU+7yWMmn2j4RzXehRXioR6NHWHOnXLdf
         7ZCoZQrRZtTCm38P7FLcucoPxFo7qpopusydbeElTHEky0cj/7TZZKJdY0pOS59NwMR4
         TTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567329; x=1773172129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ija5cl5iw/lXAYwYtLBqZs6EcpnK3FanNYd7fnqfYMs=;
        b=XvZi9wAsY9YAi+pPVyiqHz3AiTSHEDjxI/lU5hEqtrdr4gSzSDP+uNt+e6NYIT1kyI
         ALOUuXrJsh5TdIr1dyiWeWnr136FSjXmkTmLYVNzqzu8QOsJay8HzqB1n/U0iemQAUjg
         oraKBk8BVqCY2Dg+SGK8Mp4Ht75KbMJEiEJ44DPMMc4Il2cTzymIgsZdytg/PIUnBHgd
         Pfna18R7fTrgHEhi15jDl+QGlzgwXBpksjlYSYEu1f2BgG3P2fNwRV0IXjipWxnou2Ly
         wAPrtgn6/AeCgtargnYbBYydQKawENddT8qkZ24gtbKmKyPoSPiLxZDRaxRJMgyXv3cA
         J7Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWG/qst1iYIyLxbG98G+I4Y9UcKbK9rXXygkgGVnHMKu/kRza4bHTYZlRQhjy9g24Ifke1P7dCQcQ==@kvack.org
X-Gm-Message-State: AOJu0YxEZjwms3nVAK+DhONVyDCAUc0BsNg8LVEAQI6K6hBidvRJS5rs
	LnRGI+DgFi/nNL3Pn8AJM52TP9d482tVq+ul7zV7syuxkjCBgbry/3PM
X-Gm-Gg: ATEYQzy2P8/r1FTGi/QSnLZhox3ZFLziU1yUjCY1ag70/QOO+Bky/S1Ikc+O4/npUcJ
	O8yVoTZRQNXr6HLAnu3+YmbMw0mTUMHtqKK67OiXqvhd+eHctiDDs9ENDTeqT95gXdzXAS7qwb/
	/32ZuJZeEj8lHO4U6tF/eztkom4C/EoTMm8GqsuuLuw3KK1aHIwgutMRxUlhEX75OKCZCmfihiM
	m8bzN4OFbDNVWmEKPjEO+AFf3wCVRfWP8EQfHCTv8OnPzF4Lz6hPkM95nb2UCdIBTFE51Sq+Hon
	QoXAVdV9WEIkSXUvGzrcOCTMYgbGEM17G7TYxIw+0tlb4hmWiFt0g4RGeihS7hz/feer8Sw33q1
	daFb/AEjVy1gAzIbI8DzP81STfpYJhjwJwroNxwZ+IpDUuwZeiVxxv9gDLrSgJThZcH9QqASnRt
	OrkNhDGzU4zDzxeVAsl/M1gdO6Nh6bPkSyEgTJ3PRIWfWkww3i4lsT3x2FPGiKNeQuBcpBzhCpd
	NeB7+o04eUeqGc=
X-Received: by 2002:a05:7022:4381:b0:11e:528:4185 with SMTP id a92af1059eb24-1278fc568a2mr6393252c88.38.1772567329064;
        Tue, 03 Mar 2026 11:48:49 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1279e9950cesm9258748c88.7.2026.03.03.11.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:48:48 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RESEND PATCH v7 3/4] x86/mm/pat: Convert populate_pgd() to use page table apis
Date: Tue,  3 Mar 2026 11:48:26 -0800
Message-ID: <20260303194828.1406905-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303194828.1406905-1-vishal.moola@gmail.com>
References: <20260303194828.1406905-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5466A180004
X-Rspamd-Server: rspam07
X-Stat-Signature: ntx7sfpsk336nfx7uii3s4fqr7a41j1i
X-Rspam-User: 
X-HE-Tag: 1772567330-458553
X-HE-Meta: U2FsdGVkX1+l+80/cwnpyM42M+kENM0ge/daDMWpnIjg9mA6OT3o51cBh+g3FsPajx8U+g+vDBVM31pQ0KchGga5MV+Z6F5XsN0KelyCzm9eVmkbUPXL9csKLPfclQHiIQD9GbC1a3dw5As91hKzSx6SaX2jRapnN1vW1e7IqYVVHkL+GBFg6eNb8WvWq/z2McEN4j1UrafBECqL+pMH/KRfdi4pufkJc8hn6aD0VOapN/lHOvPD1iN7cofjFDeQmkDihKoANFyJ790mOhA67vWZi33DxHckIehGW82re6gCSZsx8oDNX3AhGyQMbKDh9diS2ueONhX5mBj2gECUfl/RCKyTWZ8MpYyVgA9jww6a8Thkn3/9m51XdNHXI5EJSNQgTJBmFbbVKETlxSEQzmXu4g+6UPSAuq6gABFDJe6GE8bhT5pW+gawxV4NuBC6QBNxEFdfbWCpd4vzkzkUF2pveL6duaiaUBnd9Fczh/0uwDP6U+e3E8xe6zKto3lLdD996UxKBRd4VXMATmjSgH5MLfkDth5bYQIY4H0zxZc43kZJq3wuGPzG7xaJxWiWZZeL6olVL3X5wS00FFIXRVQrj42N2iHlKwAyMDPWsOw/vrW9SpLnv4mfiLzU+LmTRbfrJdtZBvs13Xfuf6YRrx0KB7Qa/rEvTQ0UFrsb6Mt68vyZbZSFFD/gi5ML1Dh/FLZsn8yRRSj0i2rc95nsPccT9JzXxfukNjnix0tukzSmgOS5cOqlMDD4/gc4cCrtbcWlCPXtjGkU84DDhL+170MeXBUSe3aR35Sa0a2v4+GrzFYLyDZ7LIaWsnFrDEwS+CGBfM9sd8QfpfGRWhmyW9ZDBbFLuTZaFad7fnA3ZAqPZYe54QHUkOdt1+7QeLb/L85vc7y4BkeNLS7s+IMkAukC6ZLfgBBfsC/kYEO9OyaElOidfl4L1hHSUforovF9lEALa+YQBCm0WElxeX3
 9pKtB49d
 B8aW1EzTsu30RXV6/90IegUHdFaax1I/y4kGrzwwHE8HtdSGm4dksqDG9ONpa2tvucfGczf8AT7d5G90UbpepmWorkfz8Q3X1EmIXd9ugZrg56Iolxd/07WEC1pc4WgWEcgXtOKlzEbb/EAMKOwy19qIZPgsjHwaBhI2MUNlw+coN3TtUV+z6KGfmgXXiWEpvH98Pyx6Te6nuQPhKHE5w/EVoWLXePUgyDL5sAMFektbykAc1DitoWMfxIBB6+nE+lXEJYX+WvrMKZrkKRszRL81XUoIGSdmDvcd7sk659cW6Q1hFmoLjuo7mMVFN7UtPzK5Ompxag3wPO49Qhc7kz92KDFQs5DuTjryw7/g9e9E7v1GJk+Yi4LbcsBOPpMeREwjyqlLbSZizzfSnBhDAP+p2VUKP1rU0GwkQq6qlys2xkjPQeNz3jfpOX+cd0Jez8ZIGrRjewU3EweNuyIwQ6QpOKlTEowGcMny/b5H5QvqcVNtvyAghgsXcUWPzlmPQGut4mTZaTDzxcJL3YWxd8PRxKu/1o04A+Hw4+8u8pkJv7CSnZiK7WDfuhI+9YVtmxTTL0sCLQ2e47dQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to allow
their separate allocation from struct page in the future. Convert the
remaining get_zeroed_page() calls to the generic page table APIs, as they
already use ptdescs.

Pass through init_mm since these are kernel page tables, as
both functions require it to identify kernel page tables. Because the
generic implementations do not use the second argument, pass a
placeholder to avoid reimplementing them or risking breakage on other
architectures.

It is not obvious whether these pages are freed. Regardless, convert the
remaining free paths as needed, noting that the only other possible free
paths have already been converted and that a frozen page table test
kernel has not reported any issues.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 72a260007996..17c1c28e3491 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1747,7 +1747,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
+		/*
+		 * Pass 0 as a placeholder for the second argument, since the
+		 * generic implementation of p4d_alloc_one() does not use it.
+		 */
+		p4d = p4d_alloc_one(&init_mm, 0);
 		if (!p4d)
 			return -1;
 
@@ -1759,7 +1763,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		/*
+		 * Pass 0 as a placeholder for the second argument, since the
+		 * generic implementation of pud_alloc_one() does not use it.
+		 */
+		pud = pud_alloc_one(&init_mm, 0);
 		if (!pud)
 			return -1;
 
-- 
2.53.0


