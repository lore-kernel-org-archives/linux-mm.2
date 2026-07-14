Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7073AC4450B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE686B00CB; Tue, 14 Jul 2026 10:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686286B00CD; Tue, 14 Jul 2026 10:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576776B00CE; Tue, 14 Jul 2026 10:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30CB96B00CB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB2A540412
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:08 +0000 (UTC)
X-FDA: 84987558936.15.282D177
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8137180016
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CCHuQj4b;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2eT5LgtVDR1PdMidQbZQUNMVcJjW/kv+exPqkO9uaE=;
	b=1omO/zllGmIn32r6DZ1wHQJlZ3pyal6OshnhXjhDcAcdRAf9hA01u65FkswtjphT3Z450M
	u5cNLZ/y1RC1pbog/07VjI5MpyPC/mPsZJEVAh73zRGzk4r6q/9uWpaRMF05jfQ4k/Oh9M
	ide1PK8dLJOJmYVaYgHT2sXn9e30eEQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CCHuQj4b;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038027;
	b=ZYwWrnsDG/bMPHJ48+KsNFlhYd2xGEIdXXvPnTDJ96ZTYpSk+5jpvkzUNwhU8noGbdtnxB
	4bP9r/egX3l8u3dI1H4HuUlsfoJ0KBu0mbL5DgbHqFTEAfBZbRderC0bti5kqWW60s1+Ui
	hjs9pTQbNAHoSzhhCBP7KTX7eDzuK0s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE41D1576;
	Tue, 14 Jul 2026 07:07:01 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6BF83F7B4;
	Tue, 14 Jul 2026 07:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038026; bh=wRRvDY7vvj6o45l8yT2Q7WPIKaOL0Wfu1AKN4gUTBNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CCHuQj4boJkfZHO19ek7AVQhcn2j5x9Inj92YhvCDOQNMYxw1wJHqVP3lNtmrXDor
	 z8dfztuTF5HxmmtkzWEn0bGB/ntiIdARdTp3OUTIiy6d1Pv6qDLGuwuR1khXjO+Vzy
	 5ViCvZtIVrztie1QTQbSWYbDcViyYQGhZmv5eaSk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:04 +0100
Subject: [PATCH 15/22] mm: only initialise pt_share_count for user pgtables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-15-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1093;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=wRRvDY7vvj6o45l8yT2Q7WPIKaOL0Wfu1AKN4gUTBNM=;
 b=Ly1CUGmQU4MNOAvYijXTm6a0Oy5bg25WoXD9BoAv+N4SapepeLDfsykLmzz2cpJ5XS9tuoOVI
 p8vbo57maMnDOD6whiBPPJLuCq0Skgv9I5RprwD5SM3O65zdB1a2N0T
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: wxd6f4zqps4jad97nafqnbxwpzik6qc3
X-Rspamd-Queue-Id: D8137180016
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784038026-582317
X-HE-Meta: U2FsdGVkX18MI5PYX+Gn/LNHEFWQRb2JPeKXEj92lN0HJwOeaTPt5GqXtAWMpYBlwYi47w2vmuLi4Gih6GRLmqW6HhWWg/JpYRe0kn5ZN242hzT43UWxw3LHokniIanUsECAWeY3DNE4XezPlhbdW0w/wZGfhe0xNd0F5lGqqvuoO/8C2VWEKHkjI5Da0k1ttCsyjhKoT7oUuSEPqGGbbty7DjNNnMZWbK4sKH750qFLYOCB9siX1Fi341KkiIjOIpMVPkF+ezQ87slCvMa9m6KtXmIqSYiIzZ9sQ+qUVMl7c9BJymy4FZu75G836QP6TShAi/kajJQkpvs6LjKyH1IMYyzCL2KXibSuhvhapwE9IrCG6/HpRgEj79S9cOPrsaAlYKCsqf/c+j88Z71ksPLFhIGFVJ5Yx9PQgKlGOXiuR4uiCtk6vGJYkn8CDVpRd6+8BwgjUuItqBfKy544b//SgXrAah0DGnJ86PmwQQUO5i8Rl+bRFZP1JRCC6naq8KS7ODMdQs2hrKlmPeDXV8S6OXoUuGohm8q4EQAqzhhUrkA7ENr3QhFY6hxzIwd8tqyDxRpgpRuvLPfFWROWc4igYGfuhw7QDlmmUDodk0Cyw6zyhzfk2FfSNv8VIEaGceYjoRRMv+eAdnu6Jn7feZxG5bKO4OI/BEOVBXE3mhWOQlgj36JGsmb4WTbB75IVgO0bRJFX9H28R//tIwhnH3FTWUJMV4yjyGWGQPknBISM/puk7Au02elbM+QKWWENjyf8X2NbMr8P/FHA7cTE2O2Bz7GUCsKb4OqlCluBHTDxs+k5/4ZvSqUNogIQREQBzHPnbslepK2c9AT8VUmvR3lu1P/HOVxCoseij5qKI5CmC+V4rjxosMh6IxveQwKmze9A++fRqXD+oRBSgkHDKUdaI8/XNKphFCv6/J84/7Sy/mv17i/Iilx5Wd1HLbC39QDI1sssYCQffXR4lok
 2e2Tf3Y6
 AKRbK7GZgcYqldLR6ZuN1ij7rkrdfvtV8MfNW3EcMGop5/n2YGOLQFmAUPO5Ww9COm3pJb5TwktzP+oQkf9lbrKgqGJg93I1Wqp1Ai95WkV12tfD8tVt98j96XNXASFVeU+vxx3aNXmAqU5nX4t/PaKDijqKH0JD/LX1qoIfF3F4/KgrZ/0RQbm6Qw5EqsykFDB3gTbsO14q4d3Rel7G0l8n17q7RsXkBhagERBpAPtzCOD3t9Ebk1sR8O399rtL9tl2xSswYoeqerPXkFjYgL8VMtHNQNBv1bI9fuCH7aznLgNDuk5SkljZdD5Ixq/ldvRpaEqd+RcO7PYp6Y82hC6QRHRKFd0NW7HUWFeixlUoZJpxc2jvHRkLDlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptdesc_pmd_pts_init() initialises the pt_share_count ptdesc field.
That field is only used for hugetlb tracking purposes, so there is
no need to initialise it for kernel page tables. Skip the call for
kernel page tables, like pmd_ptlock_init().

From now on pagetable_*_ctor() and pagetable_dtor() do nothing for
kernel page tables.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 94f0fb1c662a..b217ccbed5a3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3905,9 +3905,12 @@ static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
 static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
-	if (!mm_is_kernel(mm) && !pmd_ptlock_init(ptdesc))
-		return false;
-	ptdesc_pmd_pts_init(ptdesc);
+	if (!mm_is_kernel(mm)) {
+		if (!pmd_ptlock_init(ptdesc))
+			return false;
+		ptdesc_pmd_pts_init(ptdesc);
+	}
+
 	return true;
 }
 

-- 
2.51.2


