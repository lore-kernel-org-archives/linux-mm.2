Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BA7CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1FF8E003B; Mon,  1 Sep 2025 08:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914988E0013; Mon,  1 Sep 2025 08:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D4A8E003B; Mon,  1 Sep 2025 08:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58F698E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 117C51DED9D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:44 +0000 (UTC)
X-FDA: 83840615208.18.3F50161
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 400A2120007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Zu6tUfp+;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbWUBNes5mrbySu+U4Jj7Tp5fvMH1UIkvlFNU4FTVkY=;
	b=BJa1glNiHMk2nPSZIbNtcbCl8w6IzftxvPB6JI+xznC9eRrus8p55WAuwLRHSmJbsqmkU4
	MWHPzhFX+BsTqrAugGEULvjtuh4i/wmo/yYvML4llWDwpI9N4eNMigzTFz6RXBDzocn+vC
	OSzv1tTuyVmTcxNHLIVacVUBY2Ckb1A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Zu6tUfp+;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729842; a=rsa-sha256;
	cv=none;
	b=mBDu2ICDeE2yckl9+dn2E81jWdrSjRGbeIgoIzw6/dZN5ezKTV2a/SuGmyyzSAKs0Q77l+
	w3fRrQhdh61DXYKsMnSqELV25PqX6d43C0HpAgkVZ7FSZnfyC61TwF2LpYzJGwi4UUXwqt
	rvxuNP11FOwWSmaJg0++AoLyuucj03Y=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61cf429f4c2so7230000a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729841; x=1757334641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zbWUBNes5mrbySu+U4Jj7Tp5fvMH1UIkvlFNU4FTVkY=;
        b=Zu6tUfp+Yqyq7ioMxf6PZQzWEBGTssE8yM7SiMJOCI7G0OImVLUBuOhaSsXfa0g8Qm
         hBlgxGAX2NYSA1FjCLrpkUjiEsRmW3du0gNIny7/HG5wQRcFD+30bcyxIDN6a3bbL1eK
         wHxAjUR1sHekYayMhW6gCOQVsErUxpOE77lQgpAxCyeWFDetmtQh4MNWhVyKATF5boYv
         y525V9moxsmaWwe/J+7yW/vFVgk+Jaa5xvjSqldfupbMKpUNgbQp5RR8KYTO6wC4cpjI
         d5um5uGXzDxfGqz2p1pUJ6hDKp0loovS20vvWBHN5YIsVqQ9wMGC4CVOYDOTy7jyNmzE
         8cNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729841; x=1757334641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zbWUBNes5mrbySu+U4Jj7Tp5fvMH1UIkvlFNU4FTVkY=;
        b=KScppPFa57oYvuvECeX000l2Dx/RJ/PdbiA6fFSMWAqTV2CwawjXdGgpR/DjVCtLbS
         Srl9j1YlQpvQtZI9pLwFMBspECINP59oHwev9qfQpwZB94IY8xpOVsmCbrBiYSgFOuQw
         I6U0rGO3YFehr3q45P4lCtjK67Vd1MvUeskwiL3NzF3Tuk1ZROcvCz9EtvUFRQuPklOW
         9Xk40buMAM3wYpzwwe077kJHADVRwuF82uB5RTfCDioQoEe4uOMw6hxRAyHDrR4pjyU7
         LC491YFWgElsTpB/4xkBHfQfYDMG29uiBt6zDBhEqPg7+PbjTX3sn1J4KjTrpcHJWQnd
         afew==
X-Forwarded-Encrypted: i=1; AJvYcCUCUmxSxAkV2N4SqSG2sdAkaESAhT0NaTAVVWjsPh226myF5ziMlxe+Brs9D/EQkcXiEGlQ/f/u/g==@kvack.org
X-Gm-Message-State: AOJu0YwM1WBNcqSTzIcokikmvH9ztsgf/h2fwkvubgHASuQXsTA7DxMm
	hHwQs3pmbO2UvmlpN2PFfjvfQJvysgTMMI0P0W16pwXxI49QL6ZeN505ikuITJhsH04=
X-Gm-Gg: ASbGnctzj/g3rgLxfBJNm1PpIoxBCWc0m9quhXH+1ONKefMAzyW2YxS6lTxBwFIJsb4
	4WPuQMGAwUrp5IwIwLFhJvtn+IY/BnV7wsEFSPH1rMGxkVVejB7jmr+9SE6qbTveBqZJhr2WS1D
	D6UhfeZ4yCTqza16fC16990IWAKiUyL0BBSOU8N3RuWU/P300UcylFnWMcw3VPrbx9X3RTezJR3
	dUng22SeosKyMQOULtxWjRZKIDZwO38pmQWDH8LkvxXDb1V5O47rSml8uHC/hORKGR2wWshM4ir
	LeXNXjYsAaBeY2PRwtWRKAgIqN5UkuhoYbCUAlW1Lu+9h6Lb10aupDrLvJEDZLzXAHNAqCD16bp
	RRo+l0fU1lQQX2I36BAUdM4XTLKZu50Vrcr8WkyuIDYt4Evea8SObclbCeCclJM1VkYOT8zuPPC
	Vo6s4xwsR0XN91TdDYYCLB596vB0uoX0H1
X-Google-Smtp-Source: AGHT+IGRe72s+UHTnGokGr7x1pyG7G81cHBjYzB5waC3bIIZTDAVVMuEn5lgB7KxjuKhIwvrTnRPsQ==
X-Received: by 2002:a05:6402:2554:b0:61e:ae59:5f04 with SMTP id 4fb4d7f45d1cf-61eae597256mr563365a12.27.1756729840654;
        Mon, 01 Sep 2025 05:30:40 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:40 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 04/12] fs: constify mapping related test functions for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:20 +0200
Message-ID: <20250901123028.3383461-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ph1bwzo5j5x8k5m4o1mes9qeomapak5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 400A2120007
X-Rspamd-Server: rspam05
X-HE-Tag: 1756729842-937637
X-HE-Meta: U2FsdGVkX1+y7Yy1Fy1q1yhjBKbBjBi5Sk4lG/cFhSHd6WpEv/zyZQ+SAyAAMA38aFEtCW7vO3XLDYypZRxg6MMziKs76C1uj9yuM54GnwJSwXJPqdHji0rqguB84KwEII7bYuvRnmOP8DeXlDtXp0bK55Ze57IeYsHhaLgsdk1E6pZdNPJyCe6v3p2tpYZyLv/lmC12a3muNzFbDIs8U1811UhiqkC8lnGyTBACkTOP4wxCeAt3Ar3aUNILMy1VvaUlSA4D6R6v0dYzwRRxGmJLUf0Iaa+GfT776OWIGvawk7S3BL8GDonOQ1aG/8o4ruKdj0F5POFIhA4TE1xjVusAx5p9jzdiIymHvmT444PIHSncyyvhMHlKjTDbK9JgMg+7AySE3V/c2yNwWTu/9aARq4lXMHIi/nUMWZUvQy9M2TXPPcd9g/hduB49bVhNe2ObQoKOxKz7V/rKWy65ElMerhQdKkMzq28Fn0MdyP9Ygjx+k6e2zvnqF4S3biXRrSqfgWWfoIgNInGqLA70ZV4b6tzM6GmIVwbzyCGAm1I3EpEHZBIJQ47fZaOHycAT5lstLmVmfmZHbCqqAv+Qvgth3rnaCkWVM5+ZSW6f7BcV9BumMiNMCVYY00OKlkw+QOaOPzhQjAvSB9pqs3IwzS3VBt/jR53kz8dWc+lTWvP7k73JRE2L9+QfBp1P5Rv2WcSQnioZ3vMTsaICg1GoIjUvK0iFitnMJ9afufooJpg2P7z8P6aBc2Du/ZbH1LRLO6/fStlUv/7PsrWd8gsDK/Ctl3vDdvJH/czjFw+zd9bkQQ/an8j+aP3PZ//iRBJa8c0GmaAJcqMAVkBLyuc95OVlQIa/Muc4WgaPoq/mCIb6N5zXhaRjoUEttKHT5c8gZdEPZtjf2NcnZVqKF8r4EW/clz7tf5yPBAEiq4qZxI/U6mZ13lnK5fEbTsct04pKgiWZmfS+vQqCRlR34eM
 D86u4bRg
 L0UMu5574nu0orc/hV1Mw2uWQmAKG+K18ReFdq+UnsNW879i8vwFXKmwvvP9FGAmYfpIxam+Wmt6F27AuEy8C6NY33eGMJnBgdJ1fNctt48flG5ofa8tjN/1nAkVuxyVxE9bhy/j0xi/VezNLO+shz1QWsLLHCmijpmthq0wVgbTVmy7nSSyNOgBPUQ6uhq7B3SvhfNyo8a8/w0GUJ+Su0hkZeStLmmb1he7Va86xMGwm/fdp6pH6iV7+ebEBiwqGiDQ421RP0k7f0GB3fiWKuN2JBPxOMtHB1RbEby6fCCdRKgILHmDY5Kz+xL96EnVxHbwH72kH6uWcOtdzSga90bdjvfhq+Rf8cJ9DwHUZiK/YRTKij6mUKIETIj04423ZL+ZJ4e24D8KDRNDr2Xo17RfHQbslkwcMZ0XDg2VOBVPRGHfP6TiWlW7Y+CU/pDyy6Bdnyvj46IUBqdI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/fs.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b9f54446db0..8dc46337467d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -537,7 +537,8 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *const mapping,
+				  const xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +586,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *const mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +600,7 @@ static inline int mapping_mapped(struct address_space *mapping)
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *const mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
-- 
2.47.2


