Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68EB1099B3C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5CA6B019E; Fri, 20 Mar 2026 15:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FDC6B01A0; Fri, 20 Mar 2026 15:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E98A6B01A1; Fri, 20 Mar 2026 15:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1AC6B019E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F376C1931
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:29 +0000 (UTC)
X-FDA: 84567455658.29.A1AF4CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00CC8120013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ay83qi0b;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cI9Y9GgutepLQEZl8ALMqhpyGAXWPC9ArZDyxeVQSs4=;
	b=fDFhtqict+hHmg7OsfotnwWmGr5snPxRfXgJcwc2uqw+Gb/VUG1vWLWbZ4E9f/q9JxwBRi
	1nrwOjK+OJuoZMtjvbsa5gAMiauOExitHAl7z76bhwX45+gcWfV9c1Brzmeiaj6ipWL+8/
	N7KSB/BPyalFecXqfhfN9SfMIkLN8DM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035568; a=rsa-sha256;
	cv=none;
	b=7uC41KbM30ffKqmV18D5jy1F2133se3McTsswsuqzMC9qTPvxBbVl8j1+3kl8Uc0g4mKTK
	7pwnd59Z36nKDP0Yhfpujfn04NFjjL6+WUmQgv0bjn8qv/03AOOym2c1olPnTCP/z7h8uk
	Zf1hdbz8c/iWmNahXNTPLFFrSddMXT8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ay83qi0b;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60D2E6013A;
	Fri, 20 Mar 2026 19:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94142C4CEF7;
	Fri, 20 Mar 2026 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035567;
	bh=UwiidGQnDEVQ8vkeQmlD3Qb1LOw2iHu4gKAdi96R4uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ay83qi0bUDNJubRNCtGdCag2MZp1VdZcVDX88uveI5vH3YBeynKSFGvbVw6HcC8G5
	 Ag5jPMlD0FTyBKhEl7xk/OMYMR/K+2fBwvjUlzvtKFl9ES4mmJHTCGufZjMSsOI5cK
	 w8y33ujyb/dS+ZKFfn7xubcd4FkkII7TCrplTQbv+8m32z7j/fMQVOs3r6H1D9YC/s
	 bPth11ex8x1x9P69dYldsHW2PRUNy4ka4FL1FJ3f4X0NP0LBNblgn3uRg7E05ZsEkX
	 xtCGASDrer8icPwllao1gCsO2rEMQn25Xu0rnWUvxf1BvSMVXmw/64FyyRXjriGnVV
	 sTHUuDLJErSTg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v4 18/25] mm: update vma_supports_mlock() to use new VMA flags
Date: Fri, 20 Mar 2026 19:38:35 +0000
Message-ID: <49cc166dbafe0a81abc4581a9f5c84630b02fcb8.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ud7trie1h59nmbkztpfihoqt3dd4qx4t
X-Rspam-User: 
X-Rspamd-Queue-Id: 00CC8120013
X-Rspamd-Server: rspam12
X-HE-Tag: 1774035567-295025
X-HE-Meta: U2FsdGVkX1+IZKvSYduzI83F5cIUOGZn4urMy/Esfz0FnRtnPDOvhwaXr4VZvZyFusNrvyJ8hUyr8u5iu3QaoXzj4pJQTHFNL59er9A1BZEIDxDVuzHDW8dlLyy6XB4y9LYy7AzT9yryB+8LtjKYN6VEUBoKJyEXVxlSA+ujguDMdKrLvNx1TkAfvLXDhk9P8jQCQ54Ev8wlw1ec1kLNyj4Fqr71cWNaSYyTHY7x9ealr4CbCxkBI8O4LYGZlJW4reSZju5yBmEVC1R52My7oaz93HJH9zFIbUrcOU1gHNFF3Tj3t2CdqRZ09gjLDPJvAGIlEJ0rFVZkzwIhDKkyMISSQJynw0nP8aPVhi+tyhcBqRx47BXHXzqi30H2QzyH0MZs70KorZ7+GDIOkXaU0q4A0sSvIsC8WD/EU5qLoSb6J5EL/wLpSyZJbwW5SEi33bQUlwNyXwWQWHaxe1Rl93xK9KU00xMnYAFePFUbVNHb1DJAnB+QtIYL5y+p07ibsxCvIgM1z9YN7RaY+G/HNrMwRR/dBkaGUmaMK6NraOiq0+XV1ZUK6U5XXYBrEVtmhacKQ/lTy6GtAIWf+a+y2uQieGiMuYUrgc9YD0TcSyPaIFrMhB6FJvEA1oG3kXRKXK0sV1+m8Wr0eVGvXMIHUOnM5E5NhyYORt74JG2ZxnfMQ6x5wGWQkiyeOo6SIVeY0/6q5AZLCAJDqS/R8gef+nqCouTAwqeM+52qKe3cahygEshMEHEGhFHSR80azbknuLNqyeGAfTrBEnlZuWCaIZ3Tl3U1nM1MDCEQsgBdFo3t5vbdmjH6v9Nn50AZ8YfLl1+4yuoO8Oi1caZh4ByylzBtIBbe8GyrlHxrCeVTmusD/TDH4d8kEmOqEpanj6kwJn+NkSxrrXooq8+vIH3OyfDtC9cSgpF/iv1sFRwgj0n+/odW1L6j33kdD+cAq2hZgT1rz8BxfiYDzOwqhBL
 CGmYneE8
 C7LAozen+PYzeVYtQGBtS2XcP+NzG30fHbzXVSAxBllSDBT90b6DPPBkbJfz5PSNyrz9okNzVWjzVbhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now have the ability to test all of this using the new vma_flags_t
approach, so let's do so.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/internal.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 80d8651441a7..708d240b4198 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1252,7 +1252,9 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
+	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
+		return false;
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		return false;
 	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
 		return false;
-- 
2.53.0


