Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AAD1F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43686B00A0; Tue, 21 Apr 2026 18:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD196B00A1; Tue, 21 Apr 2026 18:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D976B00A2; Tue, 21 Apr 2026 18:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A25136B00A0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B8A814135B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:52 +0000 (UTC)
X-FDA: 84683936064.02.70D3654
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09FFC180018
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T3Ku1jm7;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVwG8S2po1iduREwk8io7PMDE8wG9YqvUAWHOi+D4qs=;
	b=wvCI8/OiAhFUQrvlDAeUvP3EDgRL8shoJUEwa2/+MSTOSPK8XnO5LKisJJTAO/EGng2zO6
	8EozNeIQCl1Gxz0jctydOujXo7pnfvy94b4vNOj4yO4g/Wf9GFPeXHBMB1ZssybXsAU9HL
	EI/offYO4fw/ryEY4qDvtEfHEA01zt4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T3Ku1jm7;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808910; a=rsa-sha256;
	cv=none;
	b=4lTgpRJeYKrN8WXaCTtRbwNch+x06Y4l66L9c1BEKnKAP4yoZu+2p9+92liYAzNjPNah4X
	tJk8bCCFpCa0zHH5z94rIeZxYC3rm0ZNGulbH1oKMJsUO14AJGwljEDxX/PDY6MAUHPUTx
	FdeHfze3iOMPTAa3Pk2ofUKq7I8QR5g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JVwG8S2po1iduREwk8io7PMDE8wG9YqvUAWHOi+D4qs=;
	b=T3Ku1jm733ofpBp4NFCYlA7i+sj69T7vm948aMKzIgVWKE19VZbZLcPzkpCOq7ZEZTqkCk
	FmGRTwtbid+xyNunPg9WXAhw1JyaPBDcHFzsvFnXCyJd5Jn4WwbieAg3ykVahIYkKz+9gu
	nplNJoI+1mGjOv1V71IS639F8qvMlg4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-EWnRIQCrN6y_0ho5hRQlSA-1; Tue, 21 Apr 2026 18:01:48 -0400
X-MC-Unique: EWnRIQCrN6y_0ho5hRQlSA-1
X-Mimecast-MFC-AGG-ID: EWnRIQCrN6y_0ho5hRQlSA_1776808907
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488d1b5bca0so25894765e9.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808907; x=1777413707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JVwG8S2po1iduREwk8io7PMDE8wG9YqvUAWHOi+D4qs=;
        b=ZcTf+tTZHQqyjdmGUdBbP7HuDZKUrVjkcSy6QR+yiYLBWxLFKY9h+j1xduTvsQlWpj
         j85SwZP10hF19Fwe62alXNdLqV16LR94Pv4DDi8B+HXtCYK50UYhITbB2uqahlI5bxoT
         cefns74oXDo4L1nujZ3x+2DT/wU6b1zZJVPo2jVcr5nICuyRVKKm9ljHndTL2edYKjd7
         CWv2JZiO5J7UtwMlaCm5JOC18616JUfmy4ixPnkcGbnk136G/q+cOOaCUWBR51rDNnDf
         6HXNNxec9rT4RiIwdFydBF85aj0PFD8WW3WsAHdB8Y6hYDDzEbHuPyDQMhdBoSHkWaTz
         Q5Cw==
X-Forwarded-Encrypted: i=1; AFNElJ82urUIIJQMqYcFpo+X5MgOMUpyawIBzSF/9l2ukSDGPvS8cy4IRSm+z9qQrhhTyRXRDV5uh9SPKw==@kvack.org
X-Gm-Message-State: AOJu0YwrKOh7LgFD3/yBKkx/ZEcgWxpfxe7HbzBaj/37fBBPfKSaspGb
	TeHxBKBU4o9KnDGoRI5/SnOk3tZzLNCO5Rh8RHMn3QmmqxmocRIks7d+DFkBZymnMZC8rFL6uJ5
	+ez2Fq3+8uVXYFbKuOI8ehAuHHcPr+m0q4HIjpsQyb8Cj5hAruewo
X-Gm-Gg: AeBDiesy1al/6SYF6e1dkLd8+JPxqSXKbZy0Xdq81U3t76EkL3SpjpuC69yn4jhiBSs
	peKu4ND49D7PaaD3+IvrE6X8qp4PQm/n3bDILVA/u8pQhT6H0k0u+4QVDywGMUK4khEU2UYiJAk
	v2k9I77bv09uvE0j/48mMhFxp4MTrBbddbt3QeRvMD0fZMm3nueN/A5lsP7ZBOGhVWKSGxqT/w1
	S+bse5Fvd2X+Ei1KOl4xXzXNfo3wYF4LxO5jBxxpPwuK2kzvd18mfxWVcIhzFVwLonHqH6aQMpu
	TRUn7khgtQCEBD9qLmeiOrJiMmPcjouZas3PmKo3ly4JhtA6XdwynZA/sgYjeWf2PeOg6EMxMBb
	3rKxNHjFBxwHHbXXtvgMuqx3OWS3L7x/hKMrB3f09NkGKws9Dt8253w==
X-Received: by 2002:a05:600c:5294:b0:48a:563c:c8d6 with SMTP id 5b1f17b1804b1-48a563cd0eemr57316055e9.7.1776808906904;
        Tue, 21 Apr 2026 15:01:46 -0700 (PDT)
X-Received: by 2002:a05:600c:5294:b0:48a:563c:c8d6 with SMTP id 5b1f17b1804b1-48a563cd0eemr57315565e9.7.1776808906442;
        Tue, 21 Apr 2026 15:01:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f8193sm361473545e9.1.2026.04.21.15.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:45 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-s390@vger.kernel.org
Subject: [PATCH RFC v3 10/19] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <006f9142e591ba8c340c3b354aee76aec5c285b9.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SCtE_LeZgFN872lJwZ0nSfiur1GGSBA9ivqf1yMQbd4_1776808907
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: wzyish3tzr5a8wbf5rhxift9ner38a3n
X-Rspamd-Queue-Id: 09FFC180018
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776808909-328224
X-HE-Meta: U2FsdGVkX1+3umf+Q/yvgkhYg4sfUBW2/3TnsXCW0wYeo6/eCAUXyd7p214X00d0dyyPrztbo6dP+T+bNjTHnNe7oK7QBXhRbEiVAHvIKhgtmI81Zj7RbgmzOuu/bFbR2HXZx7iMApLEz2FrlLqEdFKUmfQ7arbWrFBfzyjuPVnO3KssKhSvk8g1AIHnu/avZgDjjwjKQCOuAfZoqiwJg/oahYt+XHIiluDKKg0JaBqeJVcQ2OoGsPN6B9xsMBgx8iP51pcK/QoMPVhZlyM2kgSmBsaQ6KkhvS+q6kOTVHXyKWX6Z+XWeiIkXX2JABaK1o0QYfoxeqRl1VaRQdEsNrfPo3Z4RBELK1M5ULLYLViKfPH8+tnIZYe4I7j23g0hiQumkNOE8Il0uNuyJceo27i2evIsr21y5vB6sj2SIQ9/lDCkAercm8XLCDKHWeWTlxVFAWWVyaP6UZDfYTzASvvqtEFldkIeVsXQJiURYer0zU8i2i3GMQv2Wvzb/KixuZx4t9r37B8M8cG6QCYmj+ktbygfqwxduhmhq8QBoYFBKxK1q6Xa1rzGal8c9hjKMhN9M6hALARqCWhXWb5D4K6FwHeQAUJwLKHSmCDUW8GAdVRerwRWx1gSX3mI8o+Y5dGPZFF8Qa1809j6E4AxhJcNUzj6uQqdlZsmlSrANe9J5p8wfY7zVKaX/cKfg7dA+S8D0VBxV1BMjwdPLCKL8ERhzZZ2iql+MvBD4OxxXfKEjW27uI18t7z5tV0k9zI2+1bD5gEKXCmy/wS7DXtF6NXBlM0e9ChudsC2/sMs5mnsDiAORYmD4cqqz0lubmQuSAuaxPh9kQ7oZP5KrLH0laKd6N91sv+gn6EGYZbhuckMdlcwT+ILqC9usrJ1PDfz3FsZZlG7tfumeVnYAMDDr4f1FeoovYivPhpM4EXouxOufhmVhwA7Dwu/6DmDEFTRAQZAF9Aq36VbsDyt2xX
 epikF7hH
 YpITlIK/iT6RpRV1xYWOFgFHVPG/5SYEyV2+a6xS5AUCFHh7UU9//QAwLF3DzoTaGlju5FXcsPoEZw56LYcHQBQr1OHzikpy+pb2L4K8i91Shy9bd0su6VPhx5IW5fcJP474hDSltK+bRE4/6k5muHESYBmNFJ7G4Fq6QGmJNk3PkQm2dWzwO5puaBudM35X8F2g/UYjqBYd8FjkeEOx9u8MhUjSNd23SJLtkmuwM7anYeFhlCMVT2z1sIvwhanVfSuqQYFiYVcEYELQJHfOYXYt+fPsI4awzdQJD+BZNyHNHbepxtcLq187ZM+OnCVZq6kO1TAYmXdc/PnuniSziXLMl1uE4MFflFvVhj6vSfeJld6s4DqdTCTKIArA0zYw6pTe6qfcYstIWJPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the generic vma_alloc_zeroed_movable_folio() uses
__GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
x86 that did the same thing are redundant.  Remove them.

arm64 is not affected: it has a real function override that
handles MTE tag zeroing, not just __GFP_ZERO.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/alpha/include/asm/page.h   | 3 ---
 arch/m68k/include/asm/page_no.h | 3 ---
 arch/s390/include/asm/page.h    | 3 ---
 arch/x86/include/asm/page.h     | 3 ---
 4 files changed, 12 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index 59d01f9b77f6..4327029cd660 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -12,9 +12,6 @@
 
 extern void clear_page(void *page);
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 extern void copy_page(void * _to, void * _from);
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index d2532bc407ef..f511b763a235 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -12,9 +12,6 @@ extern unsigned long memory_end;
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #define __pa(vaddr)		((unsigned long)(vaddr))
 #define __va(paddr)		((void *)((unsigned long)(paddr)))
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index f339258135f7..04020a19a5cf 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -67,9 +67,6 @@ static inline void copy_page(void *to, void *from)
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifdef CONFIG_STRICT_MM_TYPECHECKS
 #define STRICT_MM_TYPECHECKS
 #endif
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 416dc88e35c1..92fa975b46f3 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -28,9 +28,6 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 	copy_page(to, from);
 }
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifndef __pa
 #define __pa(x)		__phys_addr((unsigned long)(x))
 #endif
-- 
MST


