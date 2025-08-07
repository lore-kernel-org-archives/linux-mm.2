Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E58C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 08:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E108E0005; Thu,  7 Aug 2025 04:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775988E0002; Thu,  7 Aug 2025 04:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691C88E0005; Thu,  7 Aug 2025 04:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1518E0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:45:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2E041344F1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:45:06 +0000 (UTC)
X-FDA: 83749326612.26.9E08918
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id E137A8000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:45:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HYFQgzkH;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754556305;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdrjfj4JqRdH5AZX6QJcIeMShUQkrtbEA3mxu4yqktk=;
	b=XWap942B+1m3xi56mUTLVGrS22648qH7BaSStWrFmiJvJA2sXoklk6x+G9j3vPPU/xjSUJ
	sO6Iy+1rVvAxqG+OQd2wkq5EwBDWbnUjk3K/+HHYRnq246d3YwfzwcXYCAwe/ktwZ/Eq0o
	uyXnAu6VY8c9rD7YDVZScRol4g2u7S4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754556305; a=rsa-sha256;
	cv=none;
	b=bCPErZZhEgvJHkZMUvjFk+/Dv7hnfN+s4aMTubIazbwMqLv65tamsb3dfoYNmqqEp8U88E
	2cOghf/IkRK2XEJQxbuQzSzknB7f+rYhcn5JiK7jzXFpk93k0dhhgf1WrRQxp4TUoxd1Nb
	Ox2rA5qzg//rGg1X4L2sRBYnkxmOaHY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HYFQgzkH;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-617c40825c9so678114a12.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 01:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754556303; x=1755161103; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdrjfj4JqRdH5AZX6QJcIeMShUQkrtbEA3mxu4yqktk=;
        b=HYFQgzkHTUEdSSFcO7PgpgI1SrO1AbZgYiVugwx3snHFpu0TOMpCo3lFlLZu2Lp8Yk
         FB3DReavCPYBQZ/ueW1Hhv4og+8W+Ofy3fwM1VSB4TvIHWAMQBQFqBfoRzce9sWQr/i9
         l4dX4SVqb6xkXAJonPVGHpGmHHVUNlxm0PUfA28crt7aJm6siG2vkL60Pm0eqd7bw6JA
         yZwc8+nJ9UeaedsWESdfbB5yLd2/NGkMLg6+/z5PN0vKmg9y83b4QEveu9Jsioi6DuWS
         1a899a07+fH24rBiBwR3IQlc5UIyZJDAg/up6O6DEhDTv4GgoxEuFW/Xc4ZVVmsp47bT
         hmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754556303; x=1755161103;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kdrjfj4JqRdH5AZX6QJcIeMShUQkrtbEA3mxu4yqktk=;
        b=fl/TjMBVEREBFqS/XE3gr2nSCPF5fDfJzqk6Sf9+J1yf39xkL9fUPMxd1y/DgCiaTf
         meYZu0TQpNdXvJhXu50qs6waroONSDmdMM27QLReaoLClQ+nH6raa1/mX3sXN1cZTYJg
         z/HqFSeUnBm9c0WMoNKvGJREhwjhWJdLL2C9RwpduhPxI7+aPm/bIVGaWFbR2ACh6Fkf
         qKwEzSmpwZOeUynD9ybW4WXFDfxNWLZsegjV4lDkFMuFCZJmZr1IOhVXgyfvSUg0Nudn
         qq7CXLqyHRwAbUM96G755LtsjdlSsBUjtmz0eK4gJwKnwML2dJKMjPouieOxX/yKGldZ
         imAA==
X-Forwarded-Encrypted: i=1; AJvYcCXxPlsqyA9VB3XCGRU2qU/2hsuLYbqlAn4Wrd/g0qhVWP2zCW84NsM45QqegXjc/0d89b1uTrrjyQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7Ox30u5Y0g5TZjpjuqkc1r5pvTqvQKSQMUaAmfmdXYBa6pdwX
	aBe8EeYAgaauhDvOF7TxoE5M64dpg3O8MMLortScoZC31bjmCtSinfym
X-Gm-Gg: ASbGncuxo7JDzdNoGAhxJAvR1yGEjb57xwLDYnLd8ZgjiAa6Ms3VcpgWKdoGzSNbZ9y
	j8ST/oOp0wlBBg7JguBzoIfVDG6aVYL01Qbe0l/2HN+6tKDBqGZrlqgOtgz7ljHSKMvayi5dHXS
	HijacDb7MohlDkRsPl8mr6UBX4fLY8reBWeRkZcFiUcaeb6cunbahLrOfhbxiMuEBuSP89k0sCJ
	44YwVtjRxMJZjXqbeE4Nb5+ZG/f6RwWjecoReQAVXJDdAGcmVgPBFeFuXYqpk9ycme1lwzIKewM
	VfrZg1PSPZk8fTRLsSIoWVLmP0NgXXkJtowAROfeLzFa/XrkJR8jKlZNbn3loGuZNutm/daUGqL
	LUJGx/I/yVZYeIsLW2uOEpg==
X-Google-Smtp-Source: AGHT+IHTRmKHwL7DD9CYouIIyx4NxN+nypgCzWZu23Usy+u/PAYeINh0DZM18YqUo2k9n8jjDpRnUg==
X-Received: by 2002:a17:907:60d2:b0:ae0:ded9:7f31 with SMTP id a640c23a62f3a-af992aa9796mr468147766b.20.1754556302936;
        Thu, 07 Aug 2025 01:45:02 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a240645sm1258413466b.125.2025.08.07.01.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Aug 2025 01:45:02 -0700 (PDT)
Date: Thu, 7 Aug 2025 08:45:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: move to next folio after
 folio_split() succeeds.
Message-ID: <20250807084502.vizmxfum7knsr257@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806022045.342824-3-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E137A8000E
X-Stat-Signature: qb3nu3ws41tcskosgndfzmgw3ae6aa8a
X-Rspam-User: 
X-HE-Tag: 1754556304-115181
X-HE-Meta: U2FsdGVkX1/4DKkPb6vDpY02n97n5C3inQvGgfMUhNG3Zg1gXpMNg3XkhS3nGJsj6B6SEtYVYzEWqYC3AkgrkRQsD+gmt4jEBXV0TuUYOqAwt3yrMiRuiw6gaw+orQxsjJElugYA9i1q9znp5qlxXHQRrX6ajDZGYzyEo59u8gKkyMD7hHdKq3RAOUSDKkE1dXhLG+Vje8CZ24tqoNHCY0IqvGj+4rFfvpIwsCzBdx97GrxKP2JEzVfmUUqOft6yWfh5QTwLRTiJ57+fZ4ROQ66J2bPsP5yPnGuvgGL4yGbkoBG3GtgDoFL8hpW4yJlCsLC35sPnwJfKQcxjrhQhGyeGLQV6oZK9sp/CY9rmiCWxpFt2YfvTPc21cI65wR9XMlOplH6cXbayaTdJYJtgpBS3DhcRsd3QhKrECqSkj6/J1yk9/j7K5e4ZZRdaN49chmioIDqiEQkfjCxZ0CgPq6Kgetr2VUWBQzDrSfA8LxTQ3JY6SL7OV5OmhFWC2kZ4AH7n5G0WGLQsSy3DJWAnPW69aqR3sLQdAkq6HGZ2Lli8EyN6gFGP98yaVvJMh3sXRGoYq9Rnx2Ea0nLNjLF2af0/3E09CYfmTSkKj+qJwDLsG3CdjOyz/n0+dEv2tHrl6gLkmaQBpaUs9PVz/QD0dcbX7tzMKfy2f/NgPP1yU/GbwYylQonokx4mVteQxiqtjHIZGhtndjM9fOWDqELkBn/hLXzAOWOiuWeg7+2XDc0omj45v/9KKEyqAqpu9XDWO7HlCEr/2qNgLp9PodBV9uZTODDpGZ19h7q6rrAZNRjxH0QYB6oavdqrKAkDq2lvSnjD/oHdxEOrjnxe9UmvBr4VurPNV4IuTM54uvxDa/Olu1fvJ3zTLhYCohnU2yAhfTO0A3gl3b6RXvG4m63p0AXcwRKiyAOT8DypIeh12nJO4GcX1v+ZGTPUBDIP182dfQftBNcR4g8IKyxjDct
 uC6PcoaQ
 Bv5/AU72I2y28Qm7BPDj8hqdTXBhQBY7fVNePFfDcgszAYHCltE36wSvRScPzBKPklTqe8yNA5JsSizyu+VY+G908JflrGAk/o06enzBiUwx0GEIkXMb46xGfBSXKlggaX6/gCgejmUmPxAh4CyVciCia3DBgpBe0D2RT7oDutlSNYsU4gY2ytIn/zramprms59yH17OHhc297dDBBJ1fksj7lqoarR9LcjlmeH1mDfB/qeVpBgwBybVDv3Iqdp8GkDdrI0q1OtHjNn9k707dqXZdmCb2YNiK/tP8OeSdc8qWYdgVeU17FHZY2biNf5eO488jEmqPMn7HVj6bFQ7VKS26ywiyTmsxJZBvCBEWnzUVBNRC383NFuEB35WcAG9aGJ1XwG3iz9pBKzBVvvQO1kdCIJoGpbx5DOdtX6UoH1+5fiIdMIZ7RHBTiKLKjcX+3CQ360uz4PaI6d/tTPWb09Pn9eXjbOxzCuKP+hfaBsDq5WKm9pjUT6AERykCX/TT2+L0BpWHVnkXDm2D461B8ojDFkSSdlAtX62/3gg/8WoIscYQmK4YZ8hm573+Cm0ziEPQaKDtwGEHzeuF/kFFZVdcBMuJpgtjHdhfJAmu73dY5KuhQgJjOZ+OjQxUmFdr8omNaWlTEXxkwisawuvWxCISX6J9M3vnHL6NUK2VMldwcBuDSg0jZVrmX5CGkHaH4eZtmNkiJ0tRBKo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 10:20:43PM -0400, Zi Yan wrote:
>Current behavior is to move to next PAGE_SIZE and split, but that makes it
>hard to check after-split folio orders. This is a preparation patch to
>allow more precise split_huge_page_test check in an upcoming commit.
>
>split_folio_to_order() part is not changed, since split_pte_mapped_thp test
>relies on its current behavior.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/huge_memory.c | 18 +++++++++++-------
> 1 file changed, 11 insertions(+), 7 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 8a11c2d402d4..b2ce8ac0c5a9 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -4341,6 +4341,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
> 		struct folio *folio;
> 		struct address_space *mapping;
> 		unsigned int target_order = new_order;
>+		long nr_pages;
> 
> 		if (!vma)
> 			break;
>@@ -4358,6 +4359,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
> 		if (!is_transparent_hugepage(folio))
> 			goto next;
> 
>+		nr_pages = folio_nr_pages(folio);
>+

Could be folio_large_nr_pages()?

> 		if (!folio_test_anon(folio)) {
> 			mapping = folio->mapping;
> 			target_order = max(new_order,
>@@ -4385,15 +4388,16 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
> 		if (!folio_test_anon(folio) && folio->mapping != mapping)
> 			goto unlock;
> 
>-		if (in_folio_offset < 0 ||
>-		    in_folio_offset >= folio_nr_pages(folio)) {
>+		if (in_folio_offset < 0 || in_folio_offset >= nr_pages) {
> 			if (!split_folio_to_order(folio, target_order))
> 				split++;
> 		} else {
>-			struct page *split_at = folio_page(folio,
>-							   in_folio_offset);
>-			if (!folio_split(folio, target_order, split_at, NULL))
>+			struct page *split_at =
>+				folio_page(folio, in_folio_offset);
>+			if (!folio_split(folio, target_order, split_at, NULL)) {
> 				split++;
>+				addr += PAGE_SIZE * nr_pages;
>+			}
> 		}
> 
> unlock:
>@@ -4438,8 +4442,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
> 	if (IS_ERR(candidate))
> 		goto out;
> 
>-	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
>-		 file_path, off_start, off_end);
>+	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order %u in_folio_offset %ld\n",
>+		 file_path, off_start, off_end, new_order, in_folio_offset);
> 

How about move this part into patch 1?

> 	mapping = candidate->f_mapping;
> 	min_order = mapping_min_folio_order(mapping);
>-- 
>2.47.2
>

-- 
Wei Yang
Help you, Help me

