Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5E9CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C238E0036; Tue, 21 Oct 2025 09:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC668E002F; Tue, 21 Oct 2025 09:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F7A8E0036; Tue, 21 Oct 2025 09:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F46A8E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:00:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F38413B01C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:05 +0000 (UTC)
X-FDA: 84022129170.20.6E0DAE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0989B180007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OAgYYcKg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051603; a=rsa-sha256;
	cv=none;
	b=LlVK6NIS3yxyycj3soiTeQQNdMfI4poeUdBoS4//V9K+YCS7ke9ct/qbMYOGtqChViTyuC
	/RPbc0n/kX6zFJLKWdsGTr2N7/3OdoNRCIqmhbXFjBAIs6Hi8IciKuYMmH4nN2+ZfSSAwC
	Y2Yu5nrCMugIRNIH8Yo+8ki4k/QlqpU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OAgYYcKg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dmjAOzzOKe+PWzSzDnov13uhbtuxj7aSoteYm9r0kM=;
	b=YCghfHr0zgcM2SYvZEp+EPNtbOpIfzUjR4FxXa5zqM7eOgEOO2makcTLUoCH33E7fw7o7K
	DkVBQ4ovNdmmeh6iRkMart19K8159vziT/nGtfZRtwZFQxKcuquiQELl2wDJeJPWg3wTd5
	niG3iRdvWNyrq32efiF4rB3F5vmexNc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dmjAOzzOKe+PWzSzDnov13uhbtuxj7aSoteYm9r0kM=;
	b=OAgYYcKgiMDMEm7OAz03vN+Xp12HUwI9RpH0l6PSgUT2GTMs6qSpp7Ipxj5aEy6kg9A5v9
	lLRFLQQiu5a+Y4tQ5k9ZQTWIbrDSSiDxcI0Z5V4rsGjoiBbGIvidpxtwgcfXSo/KX4JEa7
	KsgVa6wJ/+FviMc5yAGhW6OSRTqK5O0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-WvTkPyHIO5CPds6F7tqvxw-1; Tue, 21 Oct 2025 09:00:01 -0400
X-MC-Unique: WvTkPyHIO5CPds6F7tqvxw-1
X-Mimecast-MFC-AGG-ID: WvTkPyHIO5CPds6F7tqvxw_1761051600
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-426ce339084so4908459f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051600; x=1761656400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7dmjAOzzOKe+PWzSzDnov13uhbtuxj7aSoteYm9r0kM=;
        b=eWMjACI+emU9wJsCKe+QQjcf1lfCNR00MI+GW9CM2p088s6R/qtxQyzWJHzvno6xiZ
         5/72xXdXlN9AVIcQlX05BYDWxepW9sSE8p7Z6MyUo5QjxQrct3zwAmZyXXsOsqEY0wmt
         /8kplpWzGMLeZJcNUV7MabkwwGW+gzCVbvkwH7Uk3x+5ALRnz/ezbG0HWpEUtBQk/a8w
         +EwOEEVbs6DG7LbCNMB70M06BghqMYGl9fruT1oR/BTuLnsBE20z+0J2xS9EkDQRLn4G
         A4FjSvPTIxzXSG7dIvvAHQWaRmfHMufy/JKeodA+zWb85D2tV+iko9ILW80+1DPGhYZN
         L1WQ==
X-Gm-Message-State: AOJu0Yw4sGlpfv77320pToVhpu0A/Wp9Tx7pvOGBNUkAfy4nr7L3ZDyU
	uQ51beQrJnL6n+OuGoO++aqiJJBaex5N3aFV+d6FgvLmppaf0LRsJQvwRLVXi3eivJlY7uNn4GA
	mOqFW9n2U1WvNkm/T2BQNFgAajiPBuwRxEk8g0FyXr+xVLPqxFhJNxPlU+dt7
X-Gm-Gg: ASbGncssERYLWDEkDeZleIBDOZ2pMpoMNYOn3pv3KW+yD7VHM/FaHStW3o/Ia04WH6W
	CgnMVfzMwfJmmMg5PrDKUTV3QFrlVR73sY8JzE+gmxObWiFksVzWC9egyx+oVF+HI1ExCsl2IiV
	yaXB+9CohnGx8BgTonK+jPWr4y+3TsK23TbxZRq3GDqa4RK8vvmPPWMJ1Naun5dT8pANETvuJVq
	cfLT8ft+QvJ3ll9PQN26pdcRZ4Dh56BMGJ5PiBGwqukGE8yU8/cpgZYMiLATBbsYQhdYV+SIMv+
	kpoje1KWZjuSjcJvXNuuk2hyPDMmiCu1NGHRINqcTBpXfUVtygX4Z8CLxExNCDTT80bRXahG2Xx
	EL58Y05FjX6tyZaWDak6QU+taQTMvGulPoymQD/oQARN0tbkaozCmtm5WwUyY
X-Received: by 2002:a05:6000:2503:b0:425:825d:2c64 with SMTP id ffacd0b85a97d-42704d6c822mr11791962f8f.17.1761051599771;
        Tue, 21 Oct 2025 05:59:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfxO1MIMIHuEAyS8Hvj/zoSDSKI4v296mvX+6V2esc8bVwH2VAjXdgu+NOffYas4k+6n6n6g==
X-Received: by 2002:a05:6000:2503:b0:425:825d:2c64 with SMTP id ffacd0b85a97d-42704d6c822mr11791940f8f.17.1761051599346;
        Tue, 21 Oct 2025 05:59:59 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f00cdf6csm20134215f8f.43.2025.10.21.05.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:58 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 12/23] mm/balloon_compaction: remove balloon_page_push/pop()
Date: Tue, 21 Oct 2025 14:59:17 +0200
Message-ID: <20251021125929.377194-13-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kgnzLLe6fn4MnO7ZnK9LCGl_rPCH3DgCZK8sa3_4psc_1761051600
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0989B180007
X-Stat-Signature: 335nbbjwfhirdgz9upg78griabp9amky
X-HE-Tag: 1761051602-163642
X-HE-Meta: U2FsdGVkX19ByHVtKVAqonzNv1hW2uQ/5XHc9+LTVIDYTOvzL/l/LBWyuyXd2jRIQ3/VfeK+ypOr26e/RsjvvD89ei/mhNmGuZlRz7PAdBgoF2Q3/66ya3/DGuu4DLQZiwYz8zCP2UzbXTLQwcOrm8No8RteRRmr+fwrqrxbvtai687MHevIDWp/cAScL1KoQ9W5kcSzgtOyjp+fccrFmPDO6/VQnA5Sai1Zfo51HTmoax3KtN5G3GlIR61NAr+FEdBIkjI8Sz+U0eRYJo8ebIw8ml0szaAH51sis69iTFBjzELl21nGWRZkD6aqGkJa2ZxHMG3IMw4okRBAQvhhKGeA4OaOOae9CsJUSJD9/g/gLFwLpkgP1kjPnzX/15O1vlRjRvP3yejjB2aeYpYcwW7WIGcBiAlAnpJ1UoAoWaa9yCUw+W0Lep4cX3ysa563zymRrQy23Rd8M1UcTdOorD54QYQ0L9YhCW3K2rMcwq5bO+fyV43WwsJ38RvbT2ew7vqPqSeb3TYuvozQmGQem/6OXJH+K84xaKzLaOR071m398Je3dI1qxJIwRm849AW8iJFMmtlMoz54wSQzMSWyE3SMQppervXZRa7L2NHH8dWI01BqOiOu6VFnNoEDSh9+N408wXaN1XN8jlQ9KCEv+kZnXoNk6p/9qt9N9FUP8aQ8Wjcjm/5IUheFYEkVDvE9X0HpzZzsbG2bIhqEltSMeSRqULkGEf30mtvRS+oLdF5E/+PwIW13NCRwxKfSCl+gY/hI1D4uKJNs2WoB+IrqkSO9/4P8ngdYrS0ITsTObfrX4UMbXJTFfTU+X0oHB6f/QkTLE0DHvbr6ETlFGx7T8vaRVdiAQpXYBrdoYpb4fJ01WGt/XOrvUWMmHUHqvCbH17nm/qXNREO1m496Cl2BORY4NJ1aclidfqg3dLH+NO6rbnWEyNNmiidXTQ9dP+yj43Rx+VAVwnD1N3TwLS
 MG1s8QGT
 flU2kFFh7GM3qs17EOlmgiIHo8W7HypZE2zfpIeNFFqujVCAB0sLKlI8sJe6hPiN8yJV9YahWx56WKe74v+zxs+seWKmPDdz6F8Fl/+NNLTRRuh34BkDBL3TyOCEMfw/e5vBJ8+gS6otOFAbWuhUM9Du+X8C7550loMsBpppRHRFZw8AYoAAuFoOilx1v7X1bI9Oxk1WG1eTvxpJfHVay3AAjpQL6WO39fKSrc9jEXMrPF1s79FY88jCOwBxMw0ZCfA9YAzfs5KL+zp+fzB4Wr38SUBGIaLGdNwlujElnJiJ5MO27VB/sjLo8eLC25AHQyh3oTMZdMByWce66MfUPZi7m90Wnrw5nx/aZXdi3QIt2CrglSNjZdVdeNvsYUPsFEAYUriRbX7mAecFd26KTEyX0MESwKddheOY9MtvQm3ia0+bAfm/qVqnsdaG/av0TndXIN36Nn4kaOXPOB+Mhto1oUpy8tosdawo96VIwmJnkfCBJMzJFPU4u0QYZznWUmcZCKAwRCNSiNxhP4Ygt2/2NwP/2HYrcNX/cdBpGY524EFl7t15Gcp9JpNvhTDXuzXw9dCGqurV3yeP1o0dZNX9AnVLuL4smnLrulat4TysvlzI37kb1tEUO9vxg6LOC6loa8RhbJ2EDSCTI/4sm38TVWEG0c8vCsQV1GUumYNTAnOa+6s3xG9nSSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's remove these helpers as they are unused now.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h | 30 ------------------------------
 mm/balloon_compaction.c            |  5 ++---
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 1452ea0635245..e5451cf1f6589 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -126,34 +126,4 @@ static inline void balloon_page_finalize(struct page *page)
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
 }
-
-/*
- * balloon_page_push - insert a page into a page list.
- * @head : pointer to list
- * @page : page to be added
- *
- * Caller must ensure the page is private and protect the list.
- */
-static inline void balloon_page_push(struct list_head *pages, struct page *page)
-{
-	list_add(&page->lru, pages);
-}
-
-/*
- * balloon_page_pop - remove a page from a page list.
- * @head : pointer to list
- * @page : page to be added
- *
- * Caller must ensure the page is private and protect the list.
- */
-static inline struct page *balloon_page_pop(struct list_head *pages)
-{
-	struct page *page = list_first_entry_or_null(pages, struct page, lru);
-
-	if (!page)
-		return NULL;
-
-	list_del(&page->lru);
-	return page;
-}
 #endif /* _LINUX_BALLOON_COMPACTION_H */
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index c44e0b62203cc..90b2d61a593b7 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -128,9 +128,8 @@ EXPORT_SYMBOL_GPL(balloon_page_alloc);
  * Drivers must call this function to properly enqueue a new allocated balloon
  * page before definitively removing the page from the guest system.
  *
- * Drivers must not call balloon_page_enqueue on pages that have been pushed to
- * a list with balloon_page_push before removing them with balloon_page_pop. To
- * enqueue a list of pages, use balloon_page_list_enqueue instead.
+ * Drivers must not enqueue pages while page->lru is still in
+ * use, and must not use page->lru until a page was unqueued again.
  */
 void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 			  struct page *page)
-- 
2.51.0


