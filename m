Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45DBFCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 12:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863A58E0160; Fri, 31 Oct 2025 08:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED608E0042; Fri, 31 Oct 2025 08:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBCD8E0160; Fri, 31 Oct 2025 08:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 584F38E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:10:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28D26B96F3
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 12:10:16 +0000 (UTC)
X-FDA: 84058291632.15.F5C4079
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E25A180002
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 12:10:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761912614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=t0WbfK5vwuoBUWDeRvrXFDT7iz9UNmzAdlRjdob6MPo=;
	b=OuhmLGAxW7XU/woSMVJC1DKiTnpsxfTBRMmWDjno9yHCAlr3yWy2jxr6/FG+9T4RR8mPMm
	SiPenJRwCSoWbB6vOHRhx+nlYyWvklAbKwritLB3vG17Jma5Fpg0h4mQdKxH/Wzre9H1hk
	m6E1p+OoJt5+su8lzo2O/h0nWBSAxXw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761912614; a=rsa-sha256;
	cv=none;
	b=mc7xtdNRONmAfBIXgrfdfb3adTJa8bFo8gI9j2fzpdFLF4Nlzm3gwjb8QeztN9Mk+s7MvK
	cwg7nNysya243OrP2tduGnDzEXkt4I/rX3ZVC7DcbsjyCoTkPjt92kzjQhF11XvXAlwSnB
	i8d82uc5rGZRE4uPrVuolS9gA40tVag=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6cea3f34ebso1661114a12.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761912613; x=1762517413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t0WbfK5vwuoBUWDeRvrXFDT7iz9UNmzAdlRjdob6MPo=;
        b=Q5MEsjhlfhYTF+nbJDh+KyJRwaiOE1EHjA9O1NirATVX95FhHzZApqeHs4R3VT6fok
         J/NyQZ9l25lB4hUa2wYn1DPy0rEIWtCbCJyjZmRBLyEal3plZFbTRrJEaFKRl511yJDH
         CHHTiyFkV6V5qWG/a0P8/OG8zNNXb/P+OC8u8TrNJhQaECjSpkh2ovAKYVz2jouGrCDZ
         XUwNf1tulxpb1l6+vwN4Aanhh7cN/GEjuuGNfoBXmFkt+orLNYu7K/qD9+giAYIBk/w4
         ExZJs0ja/hG/uqWwkeah/ZelU82I7xPoveo2ko52EibLwuGByU0IUHvpGMoZq0frqQQl
         X6Iw==
X-Forwarded-Encrypted: i=1; AJvYcCW+4pnVQ8IngS1PNiJXT4uZE7gAN9GImiIuTYKXEYOf7qtEd3uoXVNgNSVeADEGNNoRQqXmuzCRkQ==@kvack.org
X-Gm-Message-State: AOJu0YybES6+kojJ65KxuU8zxEjhpZbGmsRuj90M+X34T9ObJO4H+iBH
	3oB8NTQqWN0SQ2vibFTZNQOpnzzuABPIHIW7o2/kkQcwW+7iMPGDVxCn4+0Teg==
X-Gm-Gg: ASbGncsR0wTJ8deVcSqGoPuSH3QH4HGrhJp2rWZwS8BS0yfGKHuzzO4RFdGSqqBooVN
	zBhb+3bpp4v/OcuzfBpfy7WuIJ36M4+GLe73lzlemgVvfinJtgqEAddSM2SjuXptNLPpWDqCiQN
	JtgIbgebRccs6XcMB6IJvnXauXc5lQrY5M4tr/fmmK+a3WnBIF0x6kJ5Z9QJl3v6eogvVnMC61b
	5S8qVxMVi3sVNbunAq9Arf+jQLcrZONBuMTIvfsPOLbfXTZ1cm+iVOyDDK2KhRxJSXMH0Fs5Vgz
	SbjQaEYyuCQYMgyyeulEiVcfBRWr+XqsliiBlxOwouUArJPykOR4Kc/gPkisS3bKPek5ZYuTt7k
	p632A4uxKv8psYWpV2joD4d0tozFsw8kMNI/qajF/KW98MeXMvYh58V+1OZCNr4I5SRmaZK1AJM
	07FQIuCjjycVOtIVeZO6zrLFPwbw==
X-Google-Smtp-Source: AGHT+IFkZYYrPO9da+1rqdpxHxQzVGAbYeTTm9iNmfhwPCVX2eqm9vtdFUdqrf7DEDE/y6nY5qWI1A==
X-Received: by 2002:a17:902:8ec9:b0:269:8059:83ab with SMTP id d9443c01a7336-2951a50e59amr30879555ad.51.1761912612853;
        Fri, 31 Oct 2025 05:10:12 -0700 (PDT)
Received: from localhost.localdomain ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295269b95bdsm21683055ad.93.2025.10.31.05.10.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Oct 2025 05:10:12 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	rppt@kernel.org,
	willy@infradead.org,
	david@redhat.com,
	ioworker0@gmail.com,
	big-sleep-vuln-reports@google.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 1/1] mm/secretmem: fix use-after-free race in fault handler
Date: Fri, 31 Oct 2025 20:09:55 +0800
Message-ID: <20251031120955.92116-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E25A180002
X-Stat-Signature: py8fmqskosidseo3x7ciyh67uiaj4n9b
X-Rspam-User: 
X-HE-Tag: 1761912614-686659
X-HE-Meta: U2FsdGVkX1/KYWkue32ErreErPVtiXTYXTS2hupFTt0IiFPT7B/cvGEzbyBKVnUGI+bwXQoijgVGjy7sgTtrDRwRBZJfeKNI6ph5xr1MP0GJOPjfiNwvdQnMk/EDJKgmfMJh718z7C9glcaOQ1Nu/UqrkczsT75aQy27VuxtIO//yGAPEuG50yZJ5QHbKwlFTv8OgcxarB8iaJVspbdxrSkU+V8mGQMVPOxdVUSsdw8jM1IVdq6JPuJWoCAHRe8qKXTng09SSLF0G/vGsdhKmISbV0b23tZxZHgX62TX7RyF02+6BvgGBnU1CpgEDTXXqiF8xzA8MZn61JN8YCpltrOyZo6uA+dcdALrB5N+LpmyDSv+gTUjBu6UT6ijzk7yCC4fllkjGfeZhMkzGjlJsAacbFmxsDHIh3C2y0zWvSRr71RIaN4CMgRfwiRPIGwlL6YIz4/yx9IkkZ2GaYR67E3k7y+rT3orrQNE4ifMJo19CPz9KpeDs924dKDgtnEL2oaWWun2lvqf8zvSQIvTqRBjHtC7CHqViP+XiAQ+NAQRBBgC3paIEMw7rumcm3fwibFkr7EP01sYSDzJi/yDuLVYrBN6cPFzc0y8ObMhvBX/UxL+4IcaSD7Z/kXJptNk+wXfIq6bHNKQ9ydk1ZR2qJxDuuxLOHTfUQ/rq/fM9dInx2BeZCYxWjVkF5YH4j3FlJv1At+BxhTY/4awHbqLpGy+7ogf/mSSYzhT5tnwPbe3nF3EisMAN44T84yuCD2XT87rMD8OMCkZBbfiWB7yf1tj+VpFYhxJHhKhL4Efvgyeasu5FIdi3t+42BPfsfaeIN4H0d3GwchRi7bvFTVCYfc5C/j+9TolgM1iEaTMRZIn8NpEIUIPDBEkZPChNFaCx8b1dAEK3fxyuyVrXdJCoVHJ3QS9pgvEL/MFlGMtzGkYy3J58my61EV+T/WKdnRXCcG2YhysFbd9wwIpb8g
 z6pFcczL
 Li/vKu8cqyejBW62rSVVEaxkBT03UWw5+mam7HvS32+NBcaA2L+Qmd33Oocpd/6fdtIZcZDKmTEXgBfJtMke+sMfKN9WXjo3FYHuObyeGMwuGe8wUz6ILSZgPDrqei83vxJZhEDnl4j853cwMaEUQds0yrqMSEpzR5QnWuo//sufkHZQqBoeT9Uc4RhYtlOMLXpmKIoVspuCYAYhbtVBLH+yowiBR8Ao2d/WI2v0xGJMuDiRMCKIp0gZh7O3pf49CmD5zg8FbSaI6UIEtIsEpLh0Dx7E25+yIBdHZLHk4c3bNg7kEgPcT2qY9ooX42XsIOGv8IjvCYRph8dtLN5zUc2kjIA4dE+Ye3kaOTeDjdD54PBm+b+5lXboX5aVn5+uf/oYXhQI6HypfYW3p7Iqgh7Bwe/2MkbxiG6DkUqCuqURQpiQRwvi+dr270++Ps0mtS96JyLtqoGrfZGuMtDWgJUyZQt6cZwgnzlji
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When a page fault occurs in a secret memory file created with
`memfd_secret(2)`, the kernel will allocate a new folio for it, mark the
underlying page as not-present in the direct map, and add it to the file
mapping.

If two tasks cause a fault in the same page concurrently, both could end
up allocating a folio and removing the page from the direct map, but only
one would succeed in adding the folio to the file mapping. The task that
failed undoes the effects of its attempt by (a) freeing the folio again
and (b) putting the page back into the direct map. However, by doing
these two operations in this order, the page becomes available to the
allocator again before it is placed back in the direct mapping.

If another task attempts to allocate the page between (a) and (b), and
the kernel tries to access it via the direct map, it would result in a
supervisor not-present page fault.

Fix the ordering to restore the direct map before the folio is freed.

Cc: <stable@vger.kernel.org>
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Collect Reviewed-by from Mike and Lorenzo - thanks!
 - Collect Acked-by from David - thanks!
 - Update the changelog as Mike suggested
 - https://lore.kernel.org/linux-mm/aQSIdCpf-2pJLwAF@kernel.org/

 mm/secretmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index c1bd9a4b663d..37f6d1097853 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -82,13 +82,13 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 		__folio_mark_uptodate(folio);
 		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
-			folio_put(folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
 			set_direct_map_default_noflush(folio_page(folio, 0));
+			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
 
-- 
2.49.0


