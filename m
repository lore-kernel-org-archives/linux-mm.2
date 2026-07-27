Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C377C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202DE6B00D5; Mon, 27 Jul 2026 08:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBBD6B00D7; Mon, 27 Jul 2026 08:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F30C6B00D8; Mon, 27 Jul 2026 08:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD73C6B00D5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:36:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65BCA1606A5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:36:19 +0000 (UTC)
X-FDA: 85034504478.25.04609DB
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47BC240009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:36:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UEO8kjWR;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
	b=mDnvrrnJSKhe4dxYu8SoGay8jMR60IZEnWHrhdBBxyMM0JocEmX0tyuLAd9fb6HuLLjJMx
	Wh8lu8aP+7NqIrVhTbTxDqAaz5kVx83VKet0Cr47kiWWX+r6f5uCnW3BOT7wuFfGksZ20g
	hX5nEiLmQM2deEVoBGTc+4T9A9S1GPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155777;
	b=fDjGFs9C5B+3yczz4GeEjFMheSj4xBH1OC/vGYrYekV1oKOD/6DbKJqpgc0GdNLGQIdhHn
	nCnVsRNlET2aeQqLCVakiOu/YamH37rISB/wi381iplaadZnWmDDZsDGcavKfXYMv4zpBL
	Oe6j8UNieODdn7gSBmjsjVGzCu8fSkM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UEO8kjWR;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155772; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=HX3xWYPWMGyEZ3/iAdp9cHSDCjeSCNmVjV7Tq4qpRvQ=;
 b=UEO8kjWRshpOkK1saMZNmIA6n8jzVhCqRek2R3PybvpOn71uPIDRu3erxf60OgZu9zOrZH
 rIMaTS2n5xTFgU6aqzQSXxJY1aDS04EYjJW09vkhJvzy+6p855N825zGZFk7qrodqH7gPK
 Bz/hu1gvZBYJATmKutGd5Hvz5uemhQKjCe3PP36xIaULAAr3vlUC4vQ9HunzAcq57p39JM
 XBwGoCIc6feXW6eaufVMEb970aWyp3wtIhpe91LrsJ41b+TgxEoIDvFTXlC/lP2EnravlP
 OHlf8fV8tiOUFVOxp7sKMj9kQr8b3ddUeslDthuEm8K2VyzdSSGiPT5q3zl9Ew==
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a6750ba+c5696b+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Subject: [PATCH v8 3/9] mm: add a set_page_section_from_pfn() helper
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
Date: Mon, 27 Jul 2026 20:34:23 +0800
Message-Id: <20260727123429.5673-4-lizhe.67@bytedance.com>
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47BC240009
X-Stat-Signature: 6f6gix41tse3nmdia3bhpsh61stys76x
X-Rspam-User: 
X-HE-Tag: 1785155777-53300
X-HE-Meta: U2FsdGVkX19ebo7IcCq3O0D9HARv13ndfIGOjrUney+GOc+ktqXw4e6BOSAV76OuPZwe+TDlXH4WmV6R2MDdWulrnZAa2coYfoQSSCwxMtdB1YprMJMq8eK2gvJAkpkix2rqa3iqUK5Lt4MQlpvUiFUlzWP+PhHz8+c9YgB5IxkJTJC1e/hyjIE0PfGk25rv7Mz6vBAvhO3Y1P+TVrxIltDDKI9WtmAsJlHQoFY8yZ6brPS1ObBVMhzLsElIsbcgbqOYbW89VJq+8QWAI/oGrSt0KLbNRhhJF8sVn8ynfzcxpQ22aXB6ZQtSdwBXVGUCcUDWRrgq4GdZ1KHz2bvbl1NtwWmKRDTy60FnSsN8TWyPYtSe+47SfseBwsDbuV3HYIj1cUb+cCumgVVVU58HlntAy/6z7Q3BlbLpNEdNSS46jjcNC1TloLdoO+n9xxSt+1ckQwd2vywbGBKrTKObPU1PqhQv13ymgS9CGSn1gMOXwotjYQXADepniaU6qxfS2t+Asb6O2j8KPoGpQTEICi8i3bOnMn/ydb46kSgFZhXjiAF6XpGU0Mbx88xxSGFLsDtuqLoo5vDihC2FdMGb7ZjP5mFOH26xd36oeQzb2FDn5uGAnEqlnkxJKTrFtBrl+MyLVxlg6HeZRIy3eTPzNT9twOl7qNNR0KmQZrvwD0XJWwXpMMbRhKUjUfCw1Vnlf5c9P6L37xz6tWb2POeJ8efYIbRfW2AFS9ntXcocvynNwuhLxfMWadPJvHNZILrRBsJHNOEw3xXacfBzIB5OYaGjsVtpakdEzDK7nbV0JtuuksGG8BEfCvqxJcwNibjS3oNHiA0Wvyho2HQTmsD3I7NyMUQ2ummLSoxOxByAzM4f88+ul7WKGXixKtGvLd677trE5p2Il+yimXtt68dW8sv/6O4sXbrOWZM66QgtCM/vtzk51HNu2E6xYdDQEJ4HbtpfwBilfRvr6qsjP02
 Bgb4K0dN
 UwgJL9A3lrQencBFb/QjDTvViyW0U2bEUqHD5GoQKH+mxmhGK0vmnIQlvTBZSGcROJpEBkosgZoKe6ebQss8vB/KExZiQVeRxZ4Ni6OJfcQmssGBznPw/LJkbAeH7XC9SEJRaqbxDbtXhxUVye6OiqWWX/x48PoaTJ0scYX1nt7IIVCKBK1KptYcBVZR6pYN7ahXVxcGLYbA60/p50WL39dp24XufctRKxXJ++48mkQO7L+T/zF5/pF03IkXG2+EWsJj6CwPxXLmnQQ0wCC2RPGIELeDoCqaUT+Yo2OxxEzvNtmlTSsBjo/GgVzO1YrR/gHsxff/01xwp694P8fgS44e/NAReJouJqVqJ7RXE4C0g6blx8P78AJ3nKa6oqLCQxh2vujN0hPCkuaVL4nWuh56QHNPchqQ4PSR+SPJxH8cP1Td6mpna0NI5vh2mGpD1+g+vWFoyVrXB09zDyif7xI1rPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers that want to update section bits from a PFN currently need to
open-code:

	set_page_section(page, pfn_to_section_nr(pfn));

and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.

Add set_page_section_from_pfn() to wrap that update in one place. When
section bits are stored in page flags, the helper derives the section
number from the PFN and updates the page flags. Otherwise keep it as a
no-op so callers can use one helper without open-coding
SECTION_IN_PAGE_FLAGS.

Convert set_page_links() to use the new helper so later ZONE_DEVICE
fast-path patches can also update section bits without open-coding
SECTION_IN_PAGE_FLAGS at each callsite.

This keeps the PFN-to-section translation local to the configurations
that actually store section bits in struct page flags, and avoids
exposing that detail to generic callers.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/mm.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..43343bfce493 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2541,11 +2541,22 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return 0;
@@ -2768,9 +2779,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
-#ifdef SECTION_IN_PAGE_FLAGS
-	set_page_section(page, pfn_to_section_nr(pfn));
-#endif
+	set_page_section_from_pfn(page, pfn);
 }
 
 /**
-- 
2.20.1

