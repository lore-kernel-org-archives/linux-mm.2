Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E749A606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NM4BnXuz
Received: by kanga.kvack.org (Postfix)
	id D8E096B05EC; Wed, 18 Nov 2026 16:36:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6AF06B05ED; Wed, 18 Nov 2026 16:36:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CF36B05EE; Wed, 18 Nov 2026 16:36:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855F06B05EC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:36:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0966D808BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:36:55 +0000 (UTC)
X-FDA: 85449549990.23.64418EF
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3CC16A000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:36:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NM4BnXuz;
	spf=pass (imf25.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037812;
	b=vMsv2G42/JP3c685+pc7xj8VIvGlYbtCRNSD8uqLepPfkJwjr4/l/RqjP9BMGLXJ/f1dxS
	zxBuSGZXZ1B1H65Jw/DJR5d9+SZ5MXTBMKNaE+UJvcw/EI5ZnTLZFP8zvzfu1Fax52G/pd
	TJwVaBV1q03WKiyPWxSQxzty4ZHfXAA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQf5dJ6mZzVBJljDb9w+mCIuacjIbr/Xh81Uvdlgp6U=;
	b=YLIjmiOwjSKHh07cBpYLhiTwihzn3B4yOcP52q69E4p77RzUIuU2G5RfBzj/hfNsf1frTC
	r63Moan8CGy1n3ggV8c/QzYS83Zfl7VdH827yoq093XjWtNm78kzGNbUaIO+cCdhIkRT3o
	nmeOoPlrBqiRPd7khdUss4gg/cDft2Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NM4BnXuz;
	spf=pass (imf25.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b4d86f5328so10996297b3.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795037812; x=1795642612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oQf5dJ6mZzVBJljDb9w+mCIuacjIbr/Xh81Uvdlgp6U=;
        b=NM4BnXuz73io+Ni6YrcaiVoNiG4EwV6Yg1q2I93/gonOVE4f2v0uAHOS1eTfZ3O0DH
         PCXkIQ+KV/BPpIsw//u22czmhH1myvJrqVjyBGnenmNUC/TY57Kkd/KWz5lM7ozsoOKV
         xcJmbJXay54upoU3nOfPbBQljpYiLUbM71XY5ljpoOMRBcekSnhmlKwqPOgp5z7QMbTH
         nZnJf0ERhiS7pLYDHcQcXfSJKFVaxRrbM7UXP6VIJfsyT5uaulmOOqIhNAeQKymua3i1
         ILZsTxl1CeHLwUYRYESGKXRoWM71HVhzTMoiz5FHsEfFb3hCfb719/IUF4lbRvK+Ehaf
         qqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037812; x=1795642612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oQf5dJ6mZzVBJljDb9w+mCIuacjIbr/Xh81Uvdlgp6U=;
        b=rlHzR0GV0wcrP5PciOecDNEzKD5D2mMxlzs6Tolnb5Z411Ba4umskKuYOYpvCBFQfK
         0EhfyNB3GDnbJfZcWVgvvunAhnwnpFFS2lgVbAscRZO2YaM4KKRfcUsXd1cKnr2okJYS
         +44UIEF5FYI47F2sOOcbQxg3mBDTTqd/sbw1r50loN/bHG5UhfEUkk4VVX1bGskx6FoF
         JyJe8Zf42urFYXUEUBVLDEjMchH9A28gJhBLuhA++zOjAqZeVhU+grjtiZJ7bo4qIR/l
         rZHitmNxu9r5DTwn25+xPbGEBze26Z30rRZ++gEP4WPVA/IBO/MAyVd/uBSztI5J86yd
         xNIA==
X-Gm-Message-State: APuU4Z+TvZHQpph6gsiiwso8C//GL4D/EGJu27uuA9d5Dc0RIibYmrYw
	JTqxVkwKB9oYRxhFI9J6bgXyFWufsBRqCCje2K8LSn55jLIWWpNj5Aix
X-Gm-Gg: AZFdTZe3oxSiilHDDCEQvSwbDBei0cGCWthDYOaQM1ilzG10HAhusPWFs5AOl1OotxG
	N9ZWgaPk7t8cXz3re8kFIfmuWMeG1CQp+Baw+CGUIBf2OfDdJsExJzeBgiPoh2PNj7B4E4YJnLe
	+MP1JJAmhhZ/bVCVqh6CLBLREtwYV7tDdWM9ZDSoCocNO2VTFuOnOTlwXAvNdyex0PuHXW2DT2A
	Lo2WIbcHwcLjngCAEizpFdanE88K/wFb15k4i8p6E++34YoXqUECiFdw7xGeAL902sG4inI/nHa
	gk9lmjvA0iyXk2UsXdSor7v4wKwXTKDIrJeBh5Cw/W6huDncLMhGHKpuvY7dAYiYjWOEZ5WvEqk
	RPdtv/A/2xb0czHqizfFJiPxC2g8ADku9PSRJFDGUDEY4lav7pzSWBOH9e7Ht3nuM4O9duPalBy
	Z/cRONcHtAMYWbdJAkzbo4hoIetenVwU2hLiXSKyOYhhlcRY7nrASgNInLo9v6Y7nh2xeua4HAE
	XwYXq2EtSSSSS1SoVW1pAkHhirB8mQlLF9sxerKESx1XhLuNWn9LQ/f9ambwZDJdkChE6k58jXo
	7IVepxZpf/P6WheaS+0GCulLKGf2plTgFCsPaZ6MWNWHfG6d2eHS+AY=
X-Received: by 2002:a05:690c:3181:b0:8b3:5eaf:2a01 with SMTP id 00721157ae682-8b4fed111e5mr16245357b3.10.1795037812257;
        Wed, 18 Nov 2026 13:36:52 -0800 (PST)
Received: from 5163NRD-SPrabh2.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe030be2sm24565697b3.10.2026.11.18.13.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:36:51 -0800 (PST)
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	viro@zeniv.linux.org.uk
Cc: linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	riel@surriel.com,
	yeoreum.yun@arm.com,
	hch@lst.de,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [PATCH 1/5] mm/gup: add struct gup_out output descriptor
Date: Wed, 18 Nov 2026 13:34:54 -0800
Message-ID: <20261118213458.377258-2-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118213458.377258-1-sw.prabhu6@gmail.com>
References: <20261118213458.377258-1-sw.prabhu6@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: ij641zkizzbg83szbzsei8qtxnidxx4q
X-Rspamd-Queue-Id: 3CC16A000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795037813-148729
X-HE-Meta: U2FsdGVkX1/UAnqaG50QzXho08rypICMXnOjMAP34bHvBFwkTrb9XzYrOidOt/hNdoj60+LOGh5f5DNL0MSM/KuB+qFDe6nd+7RsxA3wRb+k+WO2+ijJBKaYV2cFijn4OYwUOPn2ON7mwRYCHnmFJAl8HS895yz60+8Yxx8tZQiGxVHXhXZqj0iKhPsmTZh5ifia0nOA6asUbf1hsAN98pYK/vBvf4ghhDwrbw/nEe8CJjO7aUiMgDAar9sCCgAhpn+r9ZFHENpC8lcBase0la8XglUNztrPvLJl1cV2UpDpHVR25twFuPU6FTQb6DvqQ/9BmH/zSuYm2TQ518TP7CytfPj24PwF5j8gy1GxhRgQaoOig9qJEtvruh3GvjCACbVaNFOPb1TtNaRQ+2kFAqmDvIPMSxcit0DC/H8sJJ52g7Wy+B77yl1rSaLh87DMB+okx4X/w5zxaf4Btbx7LxJpXFropbJIg2j/iEc54FTnlHQuBHu3tSwH48zYinC1SajpUDTkmk8StRmyjoOBHzN7no7o+ZkSsJYbrix4nu5aNQeI7qTiSwmZYfc/g4dUhttf8z0J6OF2AM7VnP9CbHHifDWv9Kpl30NLtV4dJv5c6h2nAX4bfNwDakHVz8FerDJmuO9ipQ7BEX7yaQe7fL9CuCggeDcCym2DtXwr8Y7RXWj6j8ra0vVcGmRYYmVyEE+ZhRtyOXgr//4EnasVRsSUZpT2kSepWgnyTJjznrcgmssyNyve5/wcwvztG4xVhg9OB//+fujaLfSE/pjIZeK9CZ7Q/ErgrYpD0G+iE4MdvcB1z2wqleSJjuCTrrwHOvfdhFeyqU0vNcQgEIq9vTpKT6RJZKZAuAxE2x+tMmd10oLt/NCJLwNMAETNaH7HQRdmcHji/WmETwLZM+sjoP9NTzM3wS7oL7nxJFYyD0EplTKqaHCGiHmAHHHgbuUhnJPh2HB79QqiqZ2MHTX
 nET3KqaL
 SRb/7x48qWdDYaU7u0ZeTmXnpE56jUbCoLEL9xAcEZHLpT1Q6nd7qucRmSe8NvfHGbdfec0MNSuc7Q+Mz7+rsFu+cHeWq/idQMwjfn2mRpkM1wmsdMABpBMvbhaHkleBcdLmxeUq4b9feE1Ev1/ffsXMOHBq4XondeC6oPTqa0VYRwBFkC5GS5MVJzYZgTSOkNZPm8K/JXhDnLxNUZHUdADHBHRSECf7Er0Jag+CHor32Cq19kXRENmZjA55D7zSS8MTlDD/5UJ+euYaw0muscevzvYEINWo0BsH+F7xGO/BqORP0OgpMBE6qnYR3mN8UWN53rlVyVBcUTgOvCc6iqG6emAyRvD76SPuId1uBf68o39Cizy/XU6uKCQPXTEH3sDb/oZ8KF2fjgbjaUp8kUzR6353V30Y+ds6FX9DBiG6wqULGOs/8aZ65Te4ilYgelFuX9aRoOcGv/gcUr2jTLci4R7yaWmBUo8vgZ4E/JKiWZvUNuBFIsx2cekiw8YBq+uhHzoiFQb0jWUBrfbJWV8EJ4iUkcFJPMx+gcv7MW9GzlWlHPb2S1KXSHPlHnWzsDOaJLqXbitQjpJ+iWiJZwWk8ORzxy3BfCjDuvgzmYeDaXdE5wthAAkQhu6/HgzlidZCDQnYam2/+8Nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Swarna Prabhu <s.prabhu@samsung.com>

The GUP page table walkers hand the pages they grabbed back through a
pages[] pointer that every level bumps on its own, which ties them to
reporting memory as an array of pages.

Add 'struct gup_out', a descriptor the walkers can append to instead,
along with 'gup_out_add_range()' to record consecutive pages of a single
folio. The descriptor keeps count of the pages recorded so far, so a
walker no longer has to care where in the array it is, no matter how
often it is called for a single GUP request.

The @folio argument of 'gup_out_add_range()' is not used yet, it is
there for describing memory by its folio later in the series.

No functional change.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 mm/gup.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 3b3888578a7e..0433579ed618 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -482,6 +482,45 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
 		mm_flags_set(MMF_HAS_PINNED, mm);
 }
 
+/*
+ * Output descriptor of the GUP page table walkers.
+ *
+ * GUP hands the memory it grabbed back to the caller as an array of pages
+ * (@pages).
+ *
+ * @nr_pages is the number of pages recorded so far: the walkers simply keep
+ * appending to the descriptor, no matter how often they are called for a
+ * single GUP request.
+ */
+struct gup_out {
+	struct page **pages;
+	unsigned long nr_pages;
+};
+
+#define GUP_OUT_PAGES(_pages)		((struct gup_out){ .pages = (_pages) })
+
+/**
+ * gup_out_add_range() - record consecutive pages of a single folio
+ * @out: the output descriptor
+ * @folio: the folio @page belongs to
+ * @page: the first page to record
+ * @nr_pages: the number of consecutive pages to record
+ *
+ * The caller must hold a reference (FOLL_GET) or pin (FOLL_PIN) for each of
+ * the @nr_pages pages.
+ */
+static inline void gup_out_add_range(struct gup_out *out, struct folio *folio,
+			      struct page *page, unsigned long nr_pages)
+{
+	struct page **pages = out->pages + out->nr_pages;
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++)
+		pages[i] = page + i;
+
+	out->nr_pages += nr_pages;
+}
+
 #ifdef CONFIG_MMU
 
 #ifdef CONFIG_HAVE_GUP_FAST
-- 
2.53.0


