Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1270CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 03:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE148E0002; Sun, 31 Aug 2025 23:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AEE28E0001; Sun, 31 Aug 2025 23:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D988E0002; Sun, 31 Aug 2025 23:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11C958E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:25:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99EE8119D23
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:25:44 +0000 (UTC)
X-FDA: 83839241808.04.93F6752
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 225434000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:25:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X2OJ21wi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756697142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdbJEMSI35G/FS955a1XJ0xytM4aPwGPHfG0Feot3XM=;
	b=pJATW9hTi3S79x85TjGW5kPVOy99KJBydAY/NRbqNFaekI1kNxKFeKkU/lBL30uqg8Raen
	fQofVFx5pl4DGPXc582kjscBVnfbnLLOtC+LFFv3Qhw3kUF1fvK8B24bSUTRzPNdjxGMI6
	vfh7srICMOw7J4s+MRHzH9p3ExXBzZg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X2OJ21wi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756697142; a=rsa-sha256;
	cv=none;
	b=DR9EP9AFQC6bbnEXUWDZhCPfeggUtQwiwAljosDKVdoZLCpmC+qctqFFvzE7lbccX77Bzx
	b5DD50z2iywlIsTpA01qKPejAoUUgKrijF54zUDynRo63/Ar4BKt4wRBTQHqoEtrQs42RH
	UwaWM9SER3w7P5+AXKIRje+OIp762SM=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-249036375a1so25041995ad.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756697141; x=1757301941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdbJEMSI35G/FS955a1XJ0xytM4aPwGPHfG0Feot3XM=;
        b=X2OJ21wiLBxZiNw+8VyebDnVqll7Qmmz3BfIuuqnMBty9eVDtii7ULZDfwfSm3HuKN
         p7kABLIJ5uVGTqNQOAmvPBZh5ZLVlGrP716KpkeVfzDxK/pcvCRDXRsFbX4fKkOLv8Uf
         LoJhyj+yD/eLOCRXvCkdY1BEc723e77IqXx5nAQtBjllxrE/7DS5VK81ML/Au8BvQe/f
         BzVDlgrg/ZhswR8d9LKe2/UUkPEoHvKYF8cz+NlPztjYHlC7xt26O2Jl5jh+qsDsQ9El
         0MDzLaSeiMJlPNYc2Z59T2XqeQWZbDAKyAGrKT7BCNaBXGjCs3yCOW+6lN9T7+CdWCLN
         TgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756697141; x=1757301941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdbJEMSI35G/FS955a1XJ0xytM4aPwGPHfG0Feot3XM=;
        b=l6uhHcu/sLg2mcCDwOTAkiSLbGsyXk3kwANW3GaSzG1Dg8BA0RiUbYbNj7n6LH/3hU
         6cp0pUByTDPWEoKlkeeS0qvXw6y1syNj4duucTaLe7wYonoDUiFSMepvFqqhsVF1Pr7N
         9nyyiSWeAa2ArURXdQybpDAZwPHS4Ty8382vmXPJRIWREIczUwY8XpAMUP1wOUlHysl8
         sn46c0R2WwBhPcBMSNkRyBVcFw/M55u3vyHMUy+KqgX/GqQbe75rdl3Xnvp7xOk/7P9p
         sRWUizj3DsRxuAmKilltRYn6Bb9Vmms21eOqfe7LNUHE2/sVJBrWEZ1U6DAr5yvw6ZJi
         mZ4g==
X-Forwarded-Encrypted: i=1; AJvYcCVLZkuCnsbBTTImXrL8Oz7OwuYlLtM2pYLAFA4y0kogjuAn0MjJ/KKUxMhWcMEbcQGQHPoyA3ol5A==@kvack.org
X-Gm-Message-State: AOJu0Yyvzc/loBGwougz1YyNKXfh25jnUoTNks6fMGI2dRyN43LJ5dAj
	GAaYxyRrKW2tZloN4AO9wLPIk+WVYyqMMJLHC9+2cHFL2uRPZnfSFnmuYlRWpNvdV2Q=
X-Gm-Gg: ASbGnct9MEoPpn5XGnsUxICDDSDWg6VqREL2Or3YTLJrvC2RwafYlSYv7Cpbj0WWFxD
	9D4yWF21pF9SrrpazxKqlXFkgiOEU0+RIfC/Wng5SpDfJ1kmjTn/pn6jIe2nOWks01uS9lCbNVE
	1srbqYXHfj2+Fmq1E5+5PTfn+Nn1zxil95Ho07EfvxE1MlBD9TEi48v49SKPAif5ilij2zvUVCT
	c/qNHX+B6apLBywea0ivYFqPq7xfRDupZ/96dTeu+4tyquzh2mHAUUBzOET9W7obpF+C/NCmnk4
	KAmj91HDHrBMyh/eQsLFKHYPi1gdUYw3MjaQoL/aVOekU5vwXRvTcX+9pDVoVysekytTpOTLqYz
	LOb/daDe2gflXlRBHRLq3emYjDcabZNEg9Z50r8ZlG3c2kxtwQaF+AOA=
X-Google-Smtp-Source: AGHT+IGBhrAz87yzolI5FAkwrsomrC2UXs7e16pnJjcARJWPI5VwmAVxP6v/krxP2r2wuBusOxthhA==
X-Received: by 2002:a17:903:32c3:b0:249:c76:76db with SMTP id d9443c01a7336-24944a64ae0mr87780325ad.21.1756697140498;
        Sun, 31 Aug 2025 20:25:40 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903702729sm89862055ad.25.2025.08.31.20.25.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 31 Aug 2025 20:25:40 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org,
	willy@infradead.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Mon,  1 Sep 2025 11:25:32 +0800
Message-ID: <20250901032532.67154-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250827121055.548e1584.alex.williamson@redhat.com>
References: <20250827121055.548e1584.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 225434000D
X-Stat-Signature: wjskkbqazih98ha4fjbxjuyhr56k6xg9
X-Rspam-User: 
X-HE-Tag: 1756697141-972826
X-HE-Meta: U2FsdGVkX1+tPXPxDBQ83oVO/nFqYxF8tWgNeEqTd9TsuE+Nvl+PdhQ0tXVXmfVFOdpHRoif2TIx0Fi5ZcB4DdrWUrRwHz4lNXH34rHnpgYMRhCK3/qUSz5ADU2lZTxuG1LU4wMPPXIzBUCSExksZe8yy//wyRxVGDuaI530B3wyJrbkE6O3c1Ho5IMuWZraeKfDyEyJDq33HuUIYaCrLXk8+taM6JZPHjRifgY66XrGV1CAi1mgA/h03Yc4ydrKFTjc0UADvmhqnFtt9m4EyBjmjntQkLOIzBEOod6/K545h8reSLpXT6Q7EtJgbdFqg9Ht53GwntGUHyq5lJvqbYeaY24+zamElwuHxOzr+MutHBWZnQRPGxlRFaf/VSL75xoRIVCkfVZgpqCzZYoey+phNjY2OqboALQDXzyFTZ7i7RRWg/tmWyPjP3Sw2eBMtHsPOxUfhmYtQ+qEHUXgmNPWucQx5jawFcgKcS5XJkwby1UMpuRL6c6Wv4OE9YyahFoBJl6Zu16kUuE94KTsEmJhm/6lWZ+ENP4CpQUyQrBczaAj/KeIPzgdikwnHeA7Eshy946zgiM7+aIH9/cUkgXYdIxb6jivWfWyXGDuUrfitBNA9xZA/yrlPCRN+mYY/cN8V8byajEjmd6RmVsi8b0q2or75Tmm2VCrBuafpOlT5QiwNVyeE4Jeu44NorcmdjIXPikJZcsWvdKYJJiQc1UZq72eG10aIy2wc527lJLAZbju7MfxfrnxhAmOfhSV1LHVrRnf2aHtLpC20uH4OzC7ULQ/br4heIg17gR2xurGQjU/O2+SX2JnW021Vd7mucTFQMFoeRiQ5l0rmK7GbCFSDxhfuq/WcDhoaf47/LbFjJPsbu/zmbvTIZPeKUtxQ+Fq1sCrRRt/hJVsYPRlt6tp0FWmxN2P0rbRUkmjpqjBV3UcFKc0o27pJUTA+euIDfs0nv0uizBJ5Hjq9Kc
 8gwjUoGd
 P4VDo0rpIAd0+4of9oCDOM2kIISYO/oM4jfuDKA8vsce32mK4OwtNW9wA0VR8iYZ6jVnWgVykIlTK1ewqzXOFxV0ndKfMSaiDvV0QN2PevfBQhqMWzuu6SXc0ueI42+ep6gCTjHcQBA9Z9RCI00i7D62w4TuIaWkmy6JY9lY7LdEad2mmeSCjigJE/Uslruz1b1qEUHynV3l7wdcvpGzmq9pvla/2hQDFpaBYtXfs4j5FeCUPKTVALyEkqke34zwellQ8IhHWygA4rkXweasvInTuKcOh8BwnznPlA9GEuKxf4615uaZPMXf2794+xxu+phdpZTNQLoG9FfxaQ/FuljUAQSNAg1Rk56aMdWOv55YKoi18nd93DSPElJZcnObj7HfG6jevmCLXAER79mSZbM55fBa8xfmcSDK5yQyOBkxIxRW5AR/1C8kfezoRWj/FYGyTqwRN87+Q9spMjf9r+Z/6sTqQt3fpk57VSX56yb74EYtzyna0piR8MpyxPDn/IXs5A3Qs2HJk1CqfSXkcOO/AqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 12:10:55 -0600, alex.williamson@redhat.com wrote:

> On Thu, 14 Aug 2025 14:47:10 +0800
> lizhe.67@bytedance.com wrote:
> 
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > Let's add a simple helper for determining the number of contiguous pages
> > that represent contiguous PFNs.
> > 
> > In an ideal world, this helper would be simpler or not even required.
> > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > without VMEMMAP), the memmap is allocated per memory section, and we might
> > run into weird corner cases of false positives when blindly testing for
> > contiguous pages only.
> > 
> > One example of such false positives would be a memory section-sized hole
> > that does not have a memmap. The surrounding memory sections might get
> > "struct pages" that are contiguous, but the PFNs are actually not.
> > 
> > This helper will, for example, be useful for determining contiguous PFNs
> > in a GUP result, to batch further operations across returned "struct
> > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > process.
> > 
> > Implementation based on Linus' suggestions to avoid new usage of
> > nth_page() where avoidable.
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >  include/linux/mm.h        |  7 ++++++-
> >  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> 
> Does this need any re-evaluation after Willy's series?[1]  Patch 2/
> changes page_to_section() to memdesc_section() which takes a new
> memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
> mm has many subtleties.
> 
> Ideally we could also avoid merge-time fixups for linux-next and
> mainline.

Thank you for your reminder.

In my view, if Willy's series is integrated, this patch will need to
be revised as follows. Please correct me if I'm wrong.

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ab4d979f4eec..bad0373099ad 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1763,7 +1763,12 @@ static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
-#endif
+#else /* !SECTION_IN_PAGE_FLAGS */
+static inline unsigned long memdesc_section(memdesc_flags_t mdf)
+{
+	return 0;
+}
+#endif /* SECTION_IN_PAGE_FLAGS */
 
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 150302b4a905..bb23496d465b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -616,4 +616,40 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
 	return true;
 }
 
+/**
+ * num_pages_contiguous() - determine the number of contiguous pages
+ *			    that represent contiguous PFNs
+ * @pages: an array of page pointers
+ * @nr_pages: length of the array, at least 1
+ *
+ * Determine the number of contiguous pages that represent contiguous PFNs
+ * in @pages, starting from the first page.
+ *
+ * In some kernel configs contiguous PFNs will not have contiguous struct
+ * pages. In these configurations num_pages_contiguous() will return a num
+ * smaller than ideal number. The caller should continue to check for pfn
+ * contiguity after each call to num_pages_contiguous().
+ *
+ * Returns the number of contiguous pages.
+ */
+static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
+{
+	struct page *cur_page = pages[0];
+	unsigned long section = memdesc_section(cur_page->flags);
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (++cur_page != pages[i])
+			break;
+		/*
+		 * In unproblematic kernel configs, page_to_section() == 0 and
+		 * the whole check will get optimized out.
+		 */
+		if (memdesc_section(cur_page->flags) != section)
+			break;
+	}
+
+	return i;
+}
+
 #endif
---

Thanks,
Zhe

