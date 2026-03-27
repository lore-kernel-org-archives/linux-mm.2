Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE2D10BA42E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 05:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5496B0095; Fri, 27 Mar 2026 01:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACE96B0096; Fri, 27 Mar 2026 01:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC35E6B0098; Fri, 27 Mar 2026 01:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A616B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:58:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59BEF1A0F2F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:58:58 +0000 (UTC)
X-FDA: 84590789556.25.ED37A98
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 89A1F20007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:58:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sBhOodkE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774591136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kPvwNT2+pm09/nglousARL1BK0XMbSM7sYGP9rdShSQ=;
	b=fSuan5OkzvpZBwxODqxQk9gH0kplpLdDXAvDaAIDIU8IyRurnDUkTM0DbSWkkhFluhGEfn
	IdZPJisV9KLiE2CLfZsuunxahW7JyPA1LHWsmhKrEFg6lqvBQVu5all3RFt/WfVUvbyggf
	xNijfFfCEQNULYgH4AKMvngxz+K4PlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774591136; a=rsa-sha256;
	cv=none;
	b=7Lusd5A+Q/m4smXnURy+cY2r624rt4K43AWLK2DZtSmtBlGiSoxEJ/P46lWpWKhuCCe3Qd
	ElkBMzDzdp2G3+PE0qqcj9skthiHWDuBKyoW10UMGunavl05dPech4DcbKY4VLfyhoDVdI
	9jSEDTVNtiZRakH27g1kfjJg2+TWjac=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sBhOodkE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66b2f6e983bso261993a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774591135; x=1775195935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kPvwNT2+pm09/nglousARL1BK0XMbSM7sYGP9rdShSQ=;
        b=sBhOodkEnXwu/UvbJIWw1nn8EzSeCyqubddUJqXP/GcAAuy3wNdjj8xtu3eo4T0yQ9
         QTxxocLa3aJvjDyjfMEIPN66ITc0yhUd3HoXEa+CJ2WiUzT9/sAhZYGGKGmvKTbMYQLr
         PO/IyXiwbGv3DI8woY7Z5Bp//LYcAViUUta65d7oRACVImwa26KnecUFNXHpqMzkeRiN
         P6ORUI+0D0YliFVEwID6xs6rQCvGN1/8DGjVfE/CiSzDxbm+sMssK8kSxy4N36e9EqEp
         c/rvw/l2eoU9liULl4a0mlX118YrRyhpLa2Bw8NheNnmeUsCahgKWVre2Tdx0YzvX7iV
         lUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774591135; x=1775195935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kPvwNT2+pm09/nglousARL1BK0XMbSM7sYGP9rdShSQ=;
        b=DW1rzy5xiwyzB74HTN1Fht9IRn7nt47jUwacCRUOOBxJpoYPfXGUkEbPlptJfRhc+a
         +q2K+Hs88Pwdk1/mMJQZrGlwo2oApP/G/n07gu2jZYPcoGAKnCVHxbaAHqpY77k44PjF
         xy3nmjSXK4WhurVKb4Qp4gOGwqq4yEoiQ7nGgWgOu3lUTwU0ZmN/XvSopcg3mCoAj8Kc
         paTBxzACv8lIM/HxOA2SJpxsf8zQ03FmnRcAg+2UstUnv8YzXSNAnu3laWkzBbtTjK8v
         ZHQIM3SXTihKNNi0/MPBniphgk8lB17ZwzgqOYsLbQ1Jvre1qm+fu3oOHtG1ctofRv7N
         l3rA==
X-Forwarded-Encrypted: i=1; AJvYcCX3Ndg9hCCyyAqOrXr3M2NOkXufpoLve9zb8XW6kE2n2kYmrohWIgjAVVSAGqo6hIeHlG3tl4uRVA==@kvack.org
X-Gm-Message-State: AOJu0YyRsD4mQs+ps0l8UVC4uE7dt9fCBfK+94zgdFMoetBG0BZKAipx
	lcHarOuXhotJPlr39v7KJZm4c8Pqf1vSVKDZChYyQ6nyjyyBTPQjR5s7
X-Gm-Gg: ATEYQzyQNnQ/eX0BXrdO5mgpVuvwUXtCGBHcuU4GOCR5z8GFYd65WPx5b+XQ788vO1z
	giYlfQfFCoKALxtH7Ej3Fo2t7otyjoq/PUCcVcLfGo2ciHU5KrJJG/eQQJGS7q0VkbY6St7CmEC
	K1mF12QiKBTqeR292XgffuAX21lUgwqHicj0/BX3p/STJvmfvYV0o/ozl9wRSFbxLORJ04LMcAG
	Z3cLMFMAoaMngUjaei9DbNokDy1QXm6eEaLL71XsASio2v+nBlHrWxYlrC9xhqZpdURxIOVhYEl
	DOdjAKaBsmKJO7fXwvDNgc72HXDafrrgLrwOEOS7cvM8u15DESDWgcrhOQMXuTTD/RPQ1oBOJ7H
	HAxTup9NKzxq7Rk5JjKkRWrAfc3fW3+erJmmFrqw5T+N7pNIMrLxjHu93RSNo6hM+uLS94604hc
	/Ev8G4BbbdYSM/dsm9dJAQDXDg8QLV/3h95bKgjhS1KLQ=
X-Received: by 2002:a17:907:944b:b0:b9b:3a4f:ee86 with SMTP id a640c23a62f3a-b9b507a4c11mr61540566b.26.1774591134473;
        Thu, 26 Mar 2026 22:58:54 -0700 (PDT)
Received: from localhost ([178.214.243.78])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9b20265cc0sm208461466b.15.2026.03.26.22.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 22:58:53 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: vbabka@kernel.org,
	harry.yoo@oracle.com,
	akpm@linux-foundation.org
Cc: hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	stern@rowland.harvard.edu,
	linux@roeck-us.net,
	andy.shevchenko@gmail.com,
	hch@lst.de,
	Jeff.kirsher@gmail.com,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH] mm/slab: align kmalloc to cacheline when DMA API debugging is active
Date: Fri, 27 Mar 2026 10:58:46 +0500
Message-ID: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89A1F20007
X-Stat-Signature: 39acp5uxoezy3ab4j115gcgtmw1hns3u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774591136-394536
X-HE-Meta: U2FsdGVkX1+5FRpZFyOc7aYAsRwNC72Wc6WaveJWehZ4szx3mi80lnj3Kg5sxvpWf2+N+yxfZ2rqNz7TTtIt+IoO1BHaUgfq8g4e/JPw80fnjS5ELc8lAnpBN55LAPTX6huDY3E+QMALVaiv8OGDJJUIjx/pyfaBztbpvbmjDzroShsKwD61XmRIUyo5cVH3+IoNeY31S8oSw6J4rZEfXkIwUMaUlwfMDXR1/D6isEkLe5UQsCV1LocMhQ4cNdoIbX1UZ2K7dhEWb/6+2BmyvLyrcno4kAfMo9WI90biF55oi8Q27r4jKJ+ciAXwmE7ObnGw36c65HOifx5gFdhUgpPW4woZyFgiM0yidCZ01okZEvxvFo6YgyaBeHC97kFJMDLJMooW8Fj/6XnEv3/ntzpWOjewZl2TpJCXF34E6yYgwu5DCCcTNG8pgNNaIZJ0QH2DgQjkZeOJfbzJ9uIgeOMnNmH5i1TnXgRH2UPhwP1j5qBWEK0zymyyU4MosvGAVituA+w3/LqUHKYYm1S9nIu8tllXL2PEbW2IGaCw/kWBURp8ESrFckTnRfG/ojkK0yOPyrQgOvPrCQbY+dCZsPR8HdBd3QEev33VSiq0gPZEMQlcEVLulx3cxG2GKdiLAFwTDFNQfER4+BX+pqySObpYl6/2d1QTXFHDuXXnsXSbsMsoJ6yWg+nPihmeDlWFb2W1l1XGJ3vqFzGJwNa7pIyJaZ00fIJ4IU9pglTagflemZN5vEek9EBcPpoIAGj43aI/cZYtx90PHgi6zrJ3JAbhQ8GiZaq5ouFbzMSlxRIRIJcuzGYzccTOeckIW4qixq0WtG0Jpr2v0uWppI/C/Eb8KJJsXfrJ4OxYcR3ALDrhetOkM6NNOXeL1UaXcAXFTJaPVprWNYKQpCXMvZ2wfsh955XPO/5teGi92TA4w+YJueP8f5B+JJC5gjRcvQcgKZ0Csc8jEjYM+yVWOpp
 +HYSoPhL
 yRnXrlqaeLh8cWgZ3nTPU/DEaqWus9BDti5o3IqNhtbgZJ2HjHKO+nARPWrpfLoAExYbK58Gnl8H8Gs0Zyn5DaLtC2/Ag9kTyg2iz18rpZGEozvaS+1Hfki0QlnNtb7gmK47ZAji4mNaVLPbvUvmoD22WBhspTX/RF17c7kp3709RejSJAX7JkjPIcJbvs+ekWs+kxIrB1kUbOkBRpU2rar5+V9vrgFUI8SjMILFOO6argIadxPokgGbZK2+ee8xuaRZQ63252f6nahEsnG9+CqrNG0JJChRu9zKvRh+7PUmcdLyju3w4D4vpwPcu/EGPuNrOAImZBTk4R5nmqdPJK+E4NRkfBMYz0UmAjxaLkIRuEB7by13cbXDsGMzsQOdrd9RHsr53LqhrwoNVSjoqAi0C5bsxz/mpZhcUPT6s5QqsEJsFpgd1tX3Xu3DtHkLStGNkxWoh3w3aQwDmxUZ91K6q6LQitfgrbJCvwEhJbhLwGU2v2p3fR7NINkklzcXlE2Ap1t2NQDDAGhy3qgeHfA5YjW6rKXljGJsf4wQ99dHhCDriKUT+uT7MV0U9vx38LsC94usisvFyfXO0tpb03w85Gd0TumD5TMFRmpt0R3ShEUNVbASaKNnXsHY+xdYwSb3MvtHqHOnaFWuSm9VPuSYIeAE7MIxcrUYtw9r/XNexRY4ra0h0Cicw70ErDeNd9NuvKj2Nk0eNOhL4eL3J5Uhrftpdqdz/S7oQFhN66OEhUAu1TN2M29frEOvZpYNOmFtT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
tracks active mappings per cacheline and warns if two different DMA
mappings share the same cacheline ("cacheline tracking EEXIST,
overlapping mappings aren't supported").

On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
hub driver) frequently land in the same 64-byte cacheline.  When both
are DMA-mapped, this triggers a false positive warning.

This has been reported repeatedly since v5.14 (when the EEXIST check
was added) across various USB host controllers and devices including
xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.

Raise ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES when CONFIG_DMA_API_DEBUG
is enabled, ensuring each kmalloc allocation occupies its own cacheline
and eliminating the false positive.

Verified with a kernel module reproducer that performs two kmalloc(8)
allocations back-to-back and DMA-maps both:

  Before: allocations share a cacheline, EEXIST fires within ~50 pairs
  After:  64 pairs allocated, all in separate cachelines, no warning

Fixes: 2b4bbc6231d7 ("dma-debug: report -EEXIST errors in add_dma_entry")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215740
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Jeff Kirsher <Jeff.kirsher@gmail.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---

Reproducer module that triggers the bug reliably:
  https://bugzilla.kernel.org/attachment.cgi?id=309769

 include/linux/slab.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 15a60b501b95..f044956e17c1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -536,6 +536,19 @@ static inline bool kmem_dump_obj(void *object) { return false; }
 #endif
 #endif
 
+/*
+ * Align memory allocations to cache lines if DMA API debugging is active
+ * to avoid false positive DMA overlapping error messages.
+ */
+#ifdef CONFIG_DMA_API_DEBUG
+#ifndef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
+#elif ARCH_KMALLOC_MINALIGN < L1_CACHE_BYTES
+#undef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
+#endif
+#endif
+
 #ifndef ARCH_KMALLOC_MINALIGN
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 #elif ARCH_KMALLOC_MINALIGN > 8
-- 
2.53.0


