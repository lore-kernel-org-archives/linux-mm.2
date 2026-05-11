Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B44CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6F06B00CC; Mon, 11 May 2026 10:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87ED76B00CD; Mon, 11 May 2026 10:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB146B00CE; Mon, 11 May 2026 10:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68A566B00CC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:06:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECBC51C0110
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:00 +0000 (UTC)
X-FDA: 84755312880.15.ECC8F64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4B8EAC001A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kohAm45R;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoXpkzT0EfRbW4uqwNffzpPOEjrNcXkx1+2e54N79mE=;
	b=Bo1wqTYtJ6rZ6CuqXdDOV8OSMTeen9fAX0L3x35RGSmWvZMWot5rV92+puaO8RnDOtYXU7
	2ohZpUVSNtvAq3x26alldYpZ+iezDE/OWd0k6A3+NR2bLTbns0DwNgIGiYaxHN/xpsMf2c
	lnRxcV2cSTAM++jZqSZzh1wFBHiZbaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508359; a=rsa-sha256;
	cv=none;
	b=oDvQlY27YODZW8nAFAbrxJG0qNbt+IUCjX5MhGp4mLK2KRR6F9JzS4MXOi1O781QmySCMz
	7vBUtHixdBkvUuFBpdi0eZWTjuAqthLk1aNTwaHb4NUokHKd7nuEIorop1LMn9X2rwd/Y/
	dMTzDeVoDFViv06/vYBFBxjdmp4SlJU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kohAm45R;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C4F3260121;
	Mon, 11 May 2026 14:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A68AC2BCB0;
	Mon, 11 May 2026 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508358;
	bh=0Ocue3eCm7kftjDOEvgMIfcEU6dPF7QGnIf4HYzbk1E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kohAm45Rpj0GtsJc339+4HuV+qMJDQGo+OaGrUlsvRENMLfGC7yd+8Am9w+nMsbot
	 lj6c+L4Z1u6qvm6mkjovGEmaHCIyIMXnG7LyJQpkgojs5UXrNFgpWefy6AwbnY5C1z
	 ty2kfu8/5ma/3T+/lZKlKFaDOGpcpGI/QWxfqZjZNw2uJlzHEDnZjf6L6VSMEqPIiI
	 AW+6ECoossl3ODeBCgdyyUGa1ibx5REXX3G95YbmSUcDkQIkm4h6rzaV3iCdE20VEm
	 omnCjbI3KzvVWJnQ8H1EH6BJI5eh2E/YkK6veo2XPHKLx0TNxDaFyDiqrm2Xf0StNx
	 ljcaeng7fr+ig==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:32 +0200
Subject: [PATCH 4/8] mm/bootmem_info: remove call to
 kmemleak_free_part_phys()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B8EAC001A
X-Rspam-User: 
X-Stat-Signature: mfkth85dkeqzb1szxjxop7u4qa7ggetg
X-HE-Tag: 1778508359-36778
X-HE-Meta: U2FsdGVkX1/rAH5QoBE+OC5tknVfxgRsedYWPb3liOSGffhwcczuVIkTLfP3vteTdlNGcptkC/jHTsqNncLJeYXVMSgnMOX3aqzrQxEJ+NY48ZLu2BCtJ+cJmPMa2V/VBJeiESyWupF9To+SJNMwG9t29eAzjWKXj7aPu1oXIgtyZ2v7xN1rc1uaf84uuw7rkCBIkWgn2/4wBcDSICKMu0QoeiqpOPoh7Jg28FZb6JBqNslZlPD9CfrJ7YlmHzOKPsJ2/QHfi8pZR96ksBBRs1LkC+jUoE1f3RErG7b7FiQqr2QbqaYd5AhCbiRa5fmI0wORLrMJIBfYzVSgvyXtS5oPPA0UaBG6W82v6QPoM42EAp+seNftSsHTjgdNlG45Pb0c/0NDBzlxggdtO69fJHqRmRPS/YLJWNtVlNOtq5erT0QOyR+DneopthXF24N7oYJ9MPSviTb4pnq0ppXKOITel/mbcujfeDoow4wCeN9ZQ2R179aGN/Rlgk9q9H7EJevz7vDRjZekPnDe6VxVT+Bwj2ksC8iEpNdP4D6zcxlk+aFoPhS5zbe/D56rt3IiyEaabFjORPA/HuyxPGNY3VHzli7/2dmzIearLf9lP+6THh71SKfmGvJigr/78BoQONupACZ2UqrGz1ZJK4kxwIL66SHWCyVXshym4rSt2VbftpLDXTaGRc7rpy7FqjDIKzgRdPZqMBqR0Lr5/1lgGpQguC013SLyWjCgnuqptao9yJhL/9DFL4L52IdHLBwcoZH/A00qGt3GtA6sFG4uGKGtl1Z0FH/IkMztxukq4vDxQC+5mFTKWAo6ZOj509OWaJ+hpiNKG1/TrQwi2PcJszmzk3JhkA+mFF7jzyRLFyLHTQaASxrw0U/GrSMSXloLKMiThTX0q5lgksX4xGSgQlYnb0DZCULruaZ1XoABRFgmoePP5rgdenWjOlZBLub6L/y+tA+OuxUZLoIQ6Dk
 czJnvsXh
 Pw6J/IsjHvmiTFreDMqRkjVoyrR/NhUuk0/037HXAOzoHguEfIvwomCjnFrvoxhYJCJ4fQuWWn1tYRnBGTZiPTLNFqnxilBQ/HcIUXCnLCzH/5EXrZaD1CgfpurxfigRVASxDM5ThmRi14a3WUHnqWyY9buGGI/5hTW0N/BU5tQNlTeIZfhSss7kXwtHrRwgmGBaoTOUmAOdRHUcZq9BlfX81xQ9lL8JDFMZhVCa8yfgV7hP9DsMpeNunEgV7LrmVmPWtYs3eehUo1H/WQPuuSAeuEKmVAvpg9zWyNqMv9OWeOWsqrwEtf+YO4HB+9iSzhgkw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The call to kmemleak_free_part_phys() was added in 2022 in
commit dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in
put_page_bootmem").

In 2025, commit b2aad24b5333 ("mm/memmap: prevent double scanning of memmap
by kmemleak") started to use MEMBLOCK_ALLOC_NOLEAKTRACE when allocating
the memmap to skip the kmemleak_alloc_phys() in the buddy.

So remove the call to kmemleak_free_part_phys(). If this would still
be required for other purposes, either free_reserved_page() should take
care of it, or selected users.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/bootmem_info.h | 1 -
 mm/bootmem_info.c            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
index 492ceeb1cdf8..f724340755e5 100644
--- a/include/linux/bootmem_info.h
+++ b/include/linux/bootmem_info.h
@@ -82,7 +82,6 @@ static inline void get_page_bootmem(unsigned long info, struct page *page,
 
 static inline void free_bootmem_page(struct page *page)
 {
-	kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 	free_reserved_page(page);
 }
 #endif
diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index 6e2aaab3dca9..74c1116626c8 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -32,7 +32,6 @@ void put_page_bootmem(struct page *page)
 
 	if (page_ref_dec_return(page) == 1) {
 		set_page_private(page, 0);
-		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);
 	}
 }

-- 
2.43.0


