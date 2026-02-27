Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C83541039894
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3789E6B00D8; Fri, 27 Feb 2026 15:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CDC6B00E8; Fri, 27 Feb 2026 15:11:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238586B00E9; Fri, 27 Feb 2026 15:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8B06B00E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:11:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C711C1A0297
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:56 +0000 (UTC)
X-FDA: 84491332632.06.C0EF4B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CEBF20003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mqTK4ziI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V07slyxq3arKEFSTLk3cL4jebUrSDREMfZ8omvVNUpo=;
	b=KHRIIYhgRjgr9LJDKVddK3RbNIe6A5zgTZ7+d8Z1UTXI/5CSLVRuQPxoz8P7ax+TWR8SEo
	TtX7lTSv3Z+u0FrOesSSwl4KHk/zKgnjxf5bNbGwxJXmENTuy1KKJ6VIbImitK517AnqdH
	GY0xr5OFElKiK3j+A7+hnKucRciWPWY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mqTK4ziI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223115; a=rsa-sha256;
	cv=none;
	b=eWiOvHx8am5S0iM9apk/mz5FNNqj2ZUP0pUMOahUydAycXwvPhj6YpcG7BCciSfymUej4W
	HVhOXulJ/3LDsOSTwY+ovvKM4AtAxPNIJxSbGGuP+KSoOMt7Lps9c8ccVU511UIq993694
	67tM8AImsIWdowh3ZUvWI3GvMKbYdrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52B7241843;
	Fri, 27 Feb 2026 20:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F1FC116C6;
	Fri, 27 Feb 2026 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223114;
	bh=I5k8d/7BhjTgSAWiS/rU+NWa+WlmbxH2nIHZouG4qQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqTK4ziIkeceLpOMlpc9Z3pxLBxf+uElw1bxcxQsf50OwHmsXyG8JxCnQBvafY8L8
	 CBoR0oUKd8BfbexVek1eSk440DDZw8CZg1d3pBVVBhMAofC8lV7GSd4wOs8ZGvwQc6
	 gG2H8vqWX8ELemznuQXqyAwHtagW9ERzcgDt+oTFrkOj6Hnrd+KZQbWXQcmnthmek8
	 +vBEQhzvxIXjGxGImAh3NyciAlusUwXZudtLW9IZnKynhZJO4tb/IuLubzDUsLdgNg
	 2YWaQinZZpstMXww2VbVV42oOagkVcy4IAHbH1UPy7e8FZkiElL1SY+N80lOyHpM+g
	 OaaWmRapbAJgA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 10/16] mm/memory: use __zap_vma_range() in zap_vma_for_reaping()
Date: Fri, 27 Feb 2026 21:08:41 +0100
Message-ID: <20260227200848.114019-11-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CEBF20003
X-Rspamd-Server: rspam08
X-Stat-Signature: cb7icu9bdggdwp8qryqciufsaieqanco
X-HE-Tag: 1772223114-789975
X-HE-Meta: U2FsdGVkX1+sU5fdrEEalniKfSonOB5Pa92v22aD4ZNWTfJF04uDiLjxhKIF0vHSc10lH3Pa9gt3Xc5CoWDlBwfL5kPx7CJoFHGYZADZP3FMp+SCZtuiMlQ6l1aF9XZLaWLZzR/AMwrCxLhQsgbejT1x6RpS8DthSwi6uDlk756ob4zZLKrPNsWEbcrsWfJ76AoROOn1/tHCEDQNerJJxV8vV1q0XKQODuIPcHdjPrYEJErv5l1O8AXsB+1n7DlA2+4+bVrQgTB9EdMb7+CiSnIBnXmxDRotgtFYTVTahJr1S3jRWOVznGSUUtkpN957uEVEtJPShkh7i/VIFh80unS8aSyGNub9jT/M8KulssLuVnMSi+cAQe80vTTFcfWERO5wFcfI3rxlxrW7ZTMuwS0hBfQfB9Hk9Fn8hdY/WhI67wT6n7McIhx2iwAoor33a9sp+nT6za7nM5wewUnSpln7OHBy1w/WwPG65wPLNXP8daznj/Zwt4Rllxd7V4X6JzSzK4jh0lJ6TO+pIRV++sADfEfT2c2z1Wsk20svcPhcZsGBxVr50c5GBCGc/1hwkVpu41jJs7Jwz/5ItWmqZQOWJ9Zp+n6dOstvrwJesdLnhthPrroiY7pJcWg1N0TUIEbl1NR79Z5pCKMuKvC3bvpT8QqjuuUkL8AmtbNMuwEfoZdxOq9uknAUOz4Grd9pOU4LsY37YsB1UQfSBDiGBr7Fbi6gFAgnVVZsBLDMXdtqXm42ICpQgPT9phpadm8taJLi0sQMhM9v5MUCXGyVQFTZCQw+w775UZjLrpJd+dyyiwBmByGZnmt3ipnF6XNEkjUBLBCyal177KjNjPKJlNr3p132IVBcZd+MqVzwdwGwWkmj9Sun6QRw3GjLdP9lO+XtRzQ/pMxmmZzCN4lXBqgLjbSrzGfZ3BGdaQ/73acViqEjyOvluDaGNJNxWTqJzYzu4IT6DB0tsfJghYQ
 2Tcve0ej
 pHl1M6GKRJKFs7WLR12pamslzR1IPIraYOLdbCr4kbnPs/uCXj/y4ZVsLp5Edi7dYMxQI8bFCetxcJYjQ2DsuDkNUiKmCuWBhodRED9qdgYqGXW2YfLID50km0F5XmyavesooCW6HaDLlcE9u6rnX5VeZlhO9whadZH7lmtDj6RDGiAc1XnNL/rk2IwmW8erjG32sQQJg6sLjzV66RK7lLAdzLNBDH+RKh9t3QVLuueT1zkpRG3rMsLm2zSq4M3S6dNdQV92L0qu+iqY53JeFCAnPOEXpsA75PDC21euM4YQoLM0MsMHC4mzwjYD7YFKWb5Oc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's call __zap_vma_range() instead of unmap_page_range() to prepare
for further cleanups.

To keep the existing behavior, whereby we do not call uprobe_munmap()
which could block, add a new "reaping" member to zap_details and use it.

Likely we should handle the possible blocking in uprobe_munmap()
differently, but for now keep it unchanged.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h |  1 +
 mm/memory.c        | 13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21b67c203e62..4710f7c7495a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2800,6 +2800,7 @@ struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
 	bool skip_cows;			/* Do not zap COWed private pages */
 	bool reclaim_pt;		/* Need reclaim page tables? */
+	bool reaping;			/* Reaping, do not block. */
 	zap_flags_t zap_flags;		/* Extra flags for zapping */
 };
 
diff --git a/mm/memory.c b/mm/memory.c
index 7d7c24c6917c..394b2e931974 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2079,14 +2079,18 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		struct zap_details *details)
 {
+	const bool reaping = details && details->reaping;
+
 	VM_WARN_ON_ONCE(start >= end || !range_in_vma(vma, start, end));
 
-	if (vma->vm_file)
+	/* uprobe_munmap() might sleep, so skip it when reaping. */
+	if (vma->vm_file && !reaping)
 		uprobe_munmap(vma, start, end);
 
 	if (unlikely(is_vm_hugetlb_page(vma))) {
 		zap_flags_t zap_flags = details ? details->zap_flags : 0;
 
+		VM_WARN_ON_ONCE(reaping);
 		/*
 		 * vm_file will be NULL when we fail early while instantiating
 		 * a new mapping. In this case, no pages were mapped yet and
@@ -2111,11 +2115,12 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
  */
 int zap_vma_for_reaping(struct vm_area_struct *vma)
 {
+	struct zap_details details = {
+		.reaping = true,
+	};
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
-	VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
-
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				vma->vm_start, vma->vm_end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
@@ -2123,7 +2128,7 @@ int zap_vma_for_reaping(struct vm_area_struct *vma)
 		tlb_finish_mmu(&tlb);
 		return -EBUSY;
 	}
-	unmap_page_range(&tlb, vma, range.start, range.end, NULL);
+	__zap_vma_range(&tlb, vma, range.start, range.end, &details);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 	return 0;
-- 
2.43.0


