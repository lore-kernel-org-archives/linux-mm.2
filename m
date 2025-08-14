Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B04CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5048F9000F5; Thu, 14 Aug 2025 02:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B53E900088; Thu, 14 Aug 2025 02:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CCA9000F5; Thu, 14 Aug 2025 02:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2318C900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:47:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCE1B83103
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:47:51 +0000 (UTC)
X-FDA: 83774432742.19.5FEC843
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id E362440002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:47:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JP8lMAr5;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jr5/c0ih2aPBl1Sup9MkhjI5We69n+SvmshTmYr92Lo=;
	b=nCrzRu1EqHFOV9KnRQYbrvij2TloPKrW+bXKkY1oADbj/qw+TNSlTquRMRCpyGWLyPAPzT
	/JNZGf7gg+A5QwgcWYYo5AI6oa5fYGc/1kS3clEQrPqlfcbm58pvI6jP0ImWCJmJKdQ09+
	iw6mubiSeOTJvBxFVJ1q7pPxVj7YazI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JP8lMAr5;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755154070; a=rsa-sha256;
	cv=none;
	b=XmZxL2zfki/S8pE5CmfhoJvhLx8tYusNbh+zsjsy1zBT2LNwSWlMDAclBgyHdyZlCPQhMN
	E8S2vJUW9oSKCdooAC38LIYr3JW4TX/26GmwSwnGgPVk+W06b+EzjNOFuiRxJEX0zOU/wZ
	g90BwGXTfBXeLt0PS6K+AflvowAwmcI=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24456ce0b96so8173135ad.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154069; x=1755758869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jr5/c0ih2aPBl1Sup9MkhjI5We69n+SvmshTmYr92Lo=;
        b=JP8lMAr5Dysb8ndu6fqvsOQNLidaSPOlHqIvSz44eQTGkt/cb3cj7K/6uFGcS4qIo3
         QdioinPv9AX3l9pJm574ciRjzjk3Rd7r06ma4SuYycq6oQ8oh6AfP85u7kQy/m5KGkhY
         aQXbtql8dBgCaaKfyaDqeqg/jET/I/QNJvge16el7qj9/a7NwC0Xoa0x1uGo8tO/skkk
         8+WDMpiYZ+jocvc4TwYMlh4jkb/DCMB5waBws0EYP+5RV7eWIDLi4v/fjY66S+8Gnetl
         yXI0KxGXA8r8JjhYuoc8XzrPv5uyomU+/VQ55UlGp73y0JTANAwI4LplZHSWK67BpkSO
         uiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154069; x=1755758869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jr5/c0ih2aPBl1Sup9MkhjI5We69n+SvmshTmYr92Lo=;
        b=Rx0ks5i4/4BDBMSzDXzoRpphZzIEbFRzxL4gpOq7dPLhFZi7Mqr0HAZMKlzO9dUiFK
         RQsA39RMgoBJfqcvKM8yVaKmKcsID+LffIJt06bn1en9ku+ByoxMFp0tu3klei7rOmL5
         0sveNyg+C7s4/aCt6b3OIAHfnV35F7OC1qw+Fu3CG6UxwcjMLUXWvTuPd6yxIgpmB7Tf
         YYb+8sLMDHg0shgjjwUKPCCLlS+tYmOOA4LRXBtNDcQrqFJN0xR06ZlhfQrCFSQoKG0b
         TvdbyKFt19QKo9cc/GlcesnQNu6VsJ67BlOfTesQCcqVBH5aIqLHZuJ48AV+14wrLIok
         Lm4w==
X-Forwarded-Encrypted: i=1; AJvYcCUBPC8xPgnXEe5wlW72z+7F1COF0xgNVfBwkCfWKCzCJXtlFQV6eVcxrzOiC1Fng3Gub0IsBVKp0A==@kvack.org
X-Gm-Message-State: AOJu0Yx40+6wWyK2iapkxrGgMM+M+onfi6iUJlhNe7PW7heHyb6AZ1dr
	mCqVgAlfEG4k9DR0N0sC7NaKn9aDi7c+Sh5vHV/6+JnFLMQOMxP5OoSxn6xtz6ZC81w=
X-Gm-Gg: ASbGncvNt1k5OvtWi3wGqDbzlyOFpRW6lPhCUhhIjzb8vyXIiCY95AUFC/0qnALEka2
	eTY0aUkUvE7hQqu+8BkbnLR/KlEHh4EAH0ns7K1mqIOSVW28oJ+WhMZEZW0Lxg3OCBItb5lXjSG
	gAurYxB/qopN7U0cNbU5t4KDo8Q57HmKJW3Ltfw0RIHY6qLF5+QSK1YUPjctbSwaqnvrbDkQwgx
	MYd5oah/9eSyXaS77mygBjcjk+ctjl80MBidDlSTwJKdSkE+1FpaeFdZ/kjAX5zucmvNK3Lgq8y
	ou8iAth81tgCJqz2yU0i70gvg50e6IfHrAZex8uwu9U70CBQomj+PbY0zGcf8Fr42mueNFctpJe
	sJkmioSt7uMIlG40yhPDRC9Z+Z8cd9+wUkgNfRjCmN4ZI98Le9A==
X-Google-Smtp-Source: AGHT+IFcMJ7Qsm2ilcv/Nmo7NkFkz9T5H1au+m2D6Cn5ycnQi6y/Vpy+QFsu7gjfy7KrvvvRuX3J0Q==
X-Received: by 2002:a17:902:cf11:b0:240:86fa:a058 with SMTP id d9443c01a7336-244594c7a56mr25154165ad.7.1755154068655;
        Wed, 13 Aug 2025 23:47:48 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:48 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Thu, 14 Aug 2025 14:47:10 +0800
Message-ID: <20250814064714.56485-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E362440002
X-Stat-Signature: rsoco5zcrdd33awsuzfafboh4qz8nk91
X-Rspam-User: 
X-HE-Tag: 1755154069-629992
X-HE-Meta: U2FsdGVkX199QjzWCErouKtbnWqWFDDtltqitwm/OTSP1mSor4SWEmxqYxqq19j21p9jO+IA6R2vxSte6D1/wxMFtITQEbgkTkUIdo7G0fnP3/E6jhb9Jsj1vH0rK1O6T0+bVgpn0d6o4Yo8Cqb5M9eHUs6+vvRAN0CC/jFEgc27C6fXS2UyBZJBUcxPa/lR8x3C7V/DIh1VQAy7/OYrS6uSZmcwuXGr2p3+PCWzok1NtH216xypVlqFh9/F48BsXpaoyOOn1e3PgrV4gq4ltzGKpfRG5+frHMSxEDOyAeKT0CZKonSJQb2almzpn9GhPxhwICfKccdmnAE+1R3odbEmP8xS5yNqUKEY07h4LtM1bJhACXdkxijOiWkYAWJwH+0P/RmRdhHTqrNjzljWCjL+DWp/ve2IDQNuyW0RGNWzV6R57RUjjyHA0T1SXKAZyURAz/qq73iwKNj72OmAQ+uX62IC10XNpqkvw8zuqWZAHCbjSLM9l3PthTIlTAShYaOzZv/15+VNNKTr1TFdwlhip+GWg9ydf1ghd/ZVdhCvoC9eURJNAfzkYqFsyJ4kNZq2kvtP6e2lKFkwjOPCt9M4eZkyY16hDQ3bS+NtA/A2t87VPF89G3JTpCnAVYoEbDmA16jD/NIZQtmJCrqo4no8sFEn+hjqFpYolNvNAXX3OYG38VA2O8c1s+FR5O8j987690IooxFw8/82iIH1puonq94crr7kCZ7fujGuw4Eg7/Nz0OBEgpNxMUGfd+tabMZH0LObzQmOSGJCfwthaJdRnOmlCCNCKIaFhZHK8Tqjjcl7mfEFJztan7XHwHyPMjCU3ru0eC78u97Dy3iwqkaMlRM93b8Iu9IfGt2YnGWgysd9qjqSpwPIIvDmvMNdae0Lw2voREWJfHgKqd0FJgrHhQxlXpX4N19sq1fQsd3d9mD7pKZPl+hVMqtsXlk5LwdUTXpOVU+Bo11nEp0
 FayiY0cC
 807r7boSImM1bijWPb9CNpc+4VwyEF74iCVF/yPUUMnPJY1eCUMn8CMLjc9kvwGHqzNkwz7ccAazf466O9AQzV/DixmLsFawcJ5dxt5MdQ75PxOH8bYsg8OiwWtCVGzTVUPoOxBpu5MI6xNXReycO1vuZcHgg7A+EUOzp6DEOeFl2Mp7yaN0wPymScMDQyFkU2mmuhQ3VQU2LdVGLeTmjj3OvE06aCN+IzdCSaaawzpyIDybaH0FBIH4vIZ65kd50zu9wisAyXOMDHbdDeN/TwiRX41H2U1bY46Sq34sd3NUba3YONzzu2vRX9AdzwjrSCUdXv2bJjyQAYmFvgc+Zi/PKr9Co7EddJciOrvZXSZOmKzhIatjeE3KdiWFFkSWQdTwz6l+DwnjqhQxXPefuBD/aZU+19zhSUBn6hwY8cRLbjqg1alZv472+XdpIgV3l+Iy55g5YRycdodsiRRouiwQqMwcgXRlH0J97fiEe4r3VFd/fY2IFn7qIklCJSzDE5dedioBh/KDzuxyt+99OeLj9qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

Let's add a simple helper for determining the number of contiguous pages
that represent contiguous PFNs.

In an ideal world, this helper would be simpler or not even required.
Unfortunately, on some configs we still have to maintain (SPARSEMEM
without VMEMMAP), the memmap is allocated per memory section, and we might
run into weird corner cases of false positives when blindly testing for
contiguous pages only.

One example of such false positives would be a memory section-sized hole
that does not have a memmap. The surrounding memory sections might get
"struct pages" that are contiguous, but the PFNs are actually not.

This helper will, for example, be useful for determining contiguous PFNs
in a GUP result, to batch further operations across returned "struct
page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
process.

Implementation based on Linus' suggestions to avoid new usage of
nth_page() where avoidable.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h        |  7 ++++++-
 include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..ead6724972cf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
 {
 	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
-#endif
+#else /* !SECTION_IN_PAGE_FLAGS */
+static inline unsigned long page_to_section(const struct page *page)
+{
+	return 0;
+}
+#endif /* SECTION_IN_PAGE_FLAGS */
 
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 89b518ff097e..5ea23891fe4c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
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
+ * In kernel configs where contiguous pages might not imply contiguous PFNs
+ * over memory section boundaries, this function will stop at the memory
+ * section boundary.
+ *
+ * Returns the number of contiguous pages.
+ */
+static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
+{
+	struct page *cur_page = pages[0];
+	unsigned long section = page_to_section(cur_page);
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (++cur_page != pages[i])
+			break;
+		/*
+		 * In unproblematic kernel configs, page_to_section() == 0 and
+		 * the whole check will get optimized out.
+		 */
+		if (page_to_section(cur_page) != section)
+			break;
+	}
+
+	return i;
+}
+
 #endif
-- 
2.20.1


