Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D4ECA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141BD8E0005; Fri,  5 Sep 2025 10:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2EE8E0003; Fri,  5 Sep 2025 10:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23808E0005; Fri,  5 Sep 2025 10:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1C448E0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:11:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA08A1A01E2
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:11:46 +0000 (UTC)
X-FDA: 83855385012.30.F5C85C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7A66160013
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:11:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LHA/OtVF";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757081504; a=rsa-sha256;
	cv=none;
	b=n5Tb1pjldd94/BN5ev09KpzJyOL9NEW5N7/FjcDP4uscZwhOKjGhg7HbQRHTtDyMDuciBG
	BAEsLXWtzCi5NDMhO/9c20zABTzqnrzuR9js/DVDleCUTVTZDyXyZPHgVS9CskPcdd3cNw
	eHccSwjeEK1GLQmt6RF5G+TgiQtrzgk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LHA/OtVF";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757081504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GgsRFe2do3K+Eon4rEy4MOebN7y4W7Y0WG9L41KSk7Q=;
	b=2Ca1zWnb9qMuvIhKQ64PEl5r1w91H4gaf6jm1EHjb3/1e32SUxboAqeAtpv8xoIPeFgmdf
	93qKMs64Yad9FBfvbKOBqH+kqEauRkpdESKyEJCukNj0cNUZlf5u7fcKHypnTkXo8EeQTG
	S1e3IEXCFEFR/6cYGAPK3jdMlGLaJI8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757081504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GgsRFe2do3K+Eon4rEy4MOebN7y4W7Y0WG9L41KSk7Q=;
	b=LHA/OtVFlXXDhbQFKAR2waWwJlKXNddxRU/ZD6t63FMytJh6SGZNRF5EsTHqWwcbL7vdRz
	YCiRaliHWn7e4oiE8xcD13eSUr7SRLj4keVVPFXTPD/8SMbfssl+6utx/BbPIb23urdQXu
	y7pPXMX1EMPpuKvcjFbIgX3wajBgTrg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-rpTkVGvuN4eVQKqhIuEj7w-1; Fri, 05 Sep 2025 10:11:40 -0400
X-MC-Unique: rpTkVGvuN4eVQKqhIuEj7w-1
X-Mimecast-MFC-AGG-ID: rpTkVGvuN4eVQKqhIuEj7w_1757081500
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e1e7752208so914288f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757081500; x=1757686300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GgsRFe2do3K+Eon4rEy4MOebN7y4W7Y0WG9L41KSk7Q=;
        b=jXI9NEpDTL0Txtb0OEEf5dR1U21sphElVpA8Ikoqae6Idw5GR0nBRGk+z+ESNuY/aX
         PIyjfHrXZY+N6hPbujtBlFdM6wuOP9FyQzI98LiOsRBxcTavr5lhuSqKOhVGZOOCsN4M
         8jVik+0UfzjcANhIQ7NS1MVRtacbiT89zU/YXVYOUyGEoxZxpXgjX2hk0cBQyhwTC4yp
         9qga7EAS6W38+vSXCr1fAipuV/ru2cQ5gTBdDvLTMD6mFloFQ25oFzv7BPnapKonhoL+
         V5Fy8FKMREqJbhZHBeGKdiAIZjkirgfZDcW/YzcWopzXe80GJk0MVzBUV8HK4lG7MHfe
         5HQw==
X-Gm-Message-State: AOJu0YxHtNWkngqdVjdEAoaA1GQojmY+DQiAkpB94WkYAEIOyaRR4e1H
	wnWvQ/UVDiw2SKNlR3uTfylRBaRK6kvZp+SwOpN7Q4S0Z0dI7fcmgKG6OJ4TWNTxAV40lx9cLW5
	J9YeZyYmmooQhP5Eec/kN2+hozS0O/V+3UShx5PS82H9v4XbJC06v
X-Gm-Gg: ASbGncs+Uv3jSh/JzKYohFeTutQr/3vC//EGcdf/LRa2DrMHIaQXnUPcFnVY4UxECaY
	s/ZwGphDw5dh1sNLxafy5Co98MbEe/WD/qXZyRT+P7XyiKb/FJuXwQ4ORmtHIKGTNao0az0SGKR
	bGupn4laJTxFLOxaZ8z9Mw/RNk715tTCWmRNciE795qGUOKffI3imnGhGRF2k55SOo/Nt/dlIYg
	hnEQUW1CmzdgudnrnBRUQARU6bjKmh6KXriDUWnUu1CH8Fhs6TU2TkjsGHYagcmfZn5HxrkTb/Y
	/0v0P6NC4s09kI3513qjnSPjtghVz58eT26Qb9D3p3mrZjJ81VZdXkTlsw5NBZDMZ7wxPIcn9eE
	QrmRJDPKN4PxFPIw6sic=
X-Received: by 2002:a05:6000:26cf:b0:3da:e7d7:f1eb with SMTP id ffacd0b85a97d-3dae7d7f7a8mr11388552f8f.22.1757081499578;
        Fri, 05 Sep 2025 07:11:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbS3uPY4JafB96Ovf66PFgi6ZGs7+8QsZrgTjUwGTDYPGb2ZrMAPKBqZ7pui9VY1zMR2lTfg==
X-Received: by 2002:a05:6000:26cf:b0:3da:e7d7:f1eb with SMTP id ffacd0b85a97d-3dae7d7f7a8mr11388511f8f.22.1757081499075;
        Fri, 05 Sep 2025 07:11:39 -0700 (PDT)
Received: from localhost (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3deb99d10a0sm10156163f8f.37.2025.09.05.07.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:11:38 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with max_ptes_none default
Date: Fri,  5 Sep 2025 16:11:37 +0200
Message-ID: <20250905141137.3529867-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GDDZMsmwhNuBj10tDYEJnp3Q3q723RZYu90NzeERRdA_1757081500
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B7A66160013
X-Stat-Signature: 3kf34adgjnyhic398pn9khryh9654yxf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757081504-953831
X-HE-Meta: U2FsdGVkX1+zq+IHNSzo7yCnmz10wHA08PynTjFjlE5qo3t1Y69hLttxb6aL0PM7YXAPmIZmLTIhJgKKDNZL5JVF7/ZeU1n4c1thMUQ32CZGYF8tRmBLm8qe1GDK0oLhm2VBDeIFqtbridlXge9flihI1JfPXtn0FVnpoDZr/rxUJoyWfS7F341VUSjrKQ3FS8M00MmWlBKZgEFSDyi+De8MUA9HVs+G4vA+GLZgDk7pUOKB6WcQOyblTLc8psBp6JZ757Ohpuep/zutDwcNRM0qaWdDTwWUFN1+XVpcDw2gsQIYR0aLxZsi7JuKrtCj2hO/aRFC6P2ga9piGW8zW9qKkhH3UISZR1MuUMcNeluI/flxPaRLLM6BzBUDS6nG3u72znXd///4BK9aGM3M7IL9aCZjvgltxI4KKCW/M6hFqhIzLjnb7YmBql4Z+/IXBmcCMP5uKXDImiFhglZuVcrEFoqqiZ4LKIrTSGlOvPwm9WiUTXhQJftk+5fhl+6BmKU8YO/snhNwhu2cbNhEk9WdSPzlKP4STS1gy2s9E2SB0L4W8RpSJDDyyZly01206wGu4hxl5VOObDC2tcddnYU9DiLQpd+QYGiHz31IpGII9RX34nWZgXhlp0U/aYJOhMMwuPPS+W4MrS14d09pCHdUEfadLryOCXAsNgooDJSE3YLJk57OuAixwkCKuSKmR4gmuWSXceTGJXDQISg7EKGcae+E7VFcLlx7EJ+KrxrxdMUq1ADFcOnQXJQs3HY4AqmyXrWSc/Ew1HGsccwvQWF35L7Cs2xxalVGAK0ayKZ3YPUUjabwc7BwF5az4VM8obX86Q+yslPnCSu0sP0rP5kSFgStWNcJ25bdNc7DR/zkh/Yc6yxkWkOhY6Zluih+YyTqKzRScudLZwcC08cl0W3HOgNSm5u/CHO39w9X5JGg6tieJqPs2BUk6ISGSc3ieQX8MKuuPoBTEPFYESn
 p6UsJOg/
 eqz6AyIueFDVVCvPwt1V+VKDqX4v6BNM0l2IWssUUBj32yomL4o6tYGzTYGObn8sfrPhPTV6Vd5SWT1DLnSswUSGKKnjbFwGkU+fC5QeN59znbbreLHakSsTMX1VeO+k0KdLN2/HXyOTSL/A3R9n+yFt9qKLT6rjy7QWAthEZg02l5NyC9OQtxdsv6pXGDMCMYs4g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We added an early exit in thp_underused(), probably to avoid scanning
pages when there is no chance for success.

However, assume we have max_ptes_none = 511 (default).

Nothing should stop us from freeing all pages part of a THP that
is completely zero (512) and khugepaged will for sure not try to
instantiate a THP in that case (512 shared zeropages).

This can just trivially happen if someone writes a single 0 byte into a
PMD area, or of course, when data ends up being zero later.

So let's remove that early exit.

Do we want to CC stable? Hm, not sure. Probably not urgent.

Note that, as default, the THP shrinker is active
(/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
THPs are added to the deferred split lists. However, with the
max_ptes_none default we would never scan them. We would not do that. If
that's not desirable, we should just disable the shrinker as default,
also not adding all THPs to the deferred split lists.

Easy to reproduce:

1) Allocate some THPs filled with 0s

<prog.c>
 #include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>

 const size_t size = 1024*1024*1024;

 int main(void)
 {
         size_t offs;
         char *area;

         area = mmap(0, size, PROT_READ | PROT_WRITE,
                     MAP_ANON | MAP_PRIVATE, -1, 0);
         if (area == MAP_FAILED) {
                 printf("mmap failed\n");
                 exit(-1);
         }
         madvise(area, size, MADV_HUGEPAGE);

         for (offs = 0; offs < size; offs += getpagesize())
                 area[offs] = 0;
         pause();
 }
<\prog.c>

2) Trigger the shrinker

E.g., memory pressure through memhog

3) Observe that THPs are not getting reclaimed

$ cat /proc/`pgrep prog`/smaps_rollup

Would list ~1GiB of AnonHugePages. With this fix, they would get
reclaimed as expected.

Fixes: dafff3f4c850 ("mm: split underused THPs")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 26cedfcd74189..aa3ed7a86435b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
 	void *kaddr;
 	int i;
 
-	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
-		return false;
-
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
 		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
-- 
2.50.1


