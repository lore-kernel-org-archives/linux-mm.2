Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41509FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59116B00D4; Fri, 27 Feb 2026 15:11:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DCD6B00E8; Fri, 27 Feb 2026 15:11:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943386B00E9; Fri, 27 Feb 2026 15:11:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 803D96B00D4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:11:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F266BC2E88
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:41 +0000 (UTC)
X-FDA: 84491332002.05.B01C0E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 13A751C0007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+uZFzLt;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0BZCGgJGIAsZxqzfZNtvPWaUpxZNAqdTK0WGsJmQPg=;
	b=dm3U3BnKny9Ikkz5gKM5BreJiZkmkkKWjt08XyCm0szqVWWNOKFMZ031xk/mWdCIrBkOB6
	kLNo460XAQneKBXBI9KZ3grPRWQyrn/dPHz7NVBquon3mHuRyOiC5Kz9dSBaRbns5nDfDP
	WCQSwRCAJCt88A+4qIQsQZfFVTaB98w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223099; a=rsa-sha256;
	cv=none;
	b=B/hetBC/GP3Hn68hj0+QdxqIo3FPqjG5jTAdz+JYptGPHI7e/o0QuUnZQgyfS4wcpiS5oe
	Kdoulm/SvaBJ2Kx0XfW7IpVE88yl45l+BXbXnTC8eRd4nSnojzR7NGuSelec4CHCoJaBOW
	adPgQPsT6iVBkBazKbA3p9rXEZ0be1Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+uZFzLt;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D4BA41843;
	Fri, 27 Feb 2026 20:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83C0C2BC86;
	Fri, 27 Feb 2026 20:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223098;
	bh=KcfCcPy+dBQFq2iZWWRAzMkc9iA3mhQIqe4VKvKm/84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+uZFzLtdrG65b8hmVxNKYNlrS/AesJe5C0CdRLLG0CXN4yBdaUTdPL6zW++yDFfV
	 d9morv+7a1pkXjkKZLGhg42leomEsG3yOY/LUvmeI7p74dvImpIdlZ+hVxW2bRPJa1
	 EnR+f8uCtq2nwqb4bowrT5fporOqCSIT2OWtiwOHYZKKevZ2sqcl0dhKRiXN/W1VTf
	 T3JnjgarvGwRpiC+6sbx7CJfmMTNXMJbxZ+2eZvxX9FSc8qEYjP7BB1HwU+r3h1AXj
	 QaDl1DJbAtFutxlyg3qP2d0PNjBvS5b6oUjoQZ0i0yJpmByBkdKGovCyF8vwNHNDEe
	 YwpOXuN0+M/Ig==
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
Subject: [PATCH v1 09/16] mm/memory: convert details->even_cows into details->skip_cows
Date: Fri, 27 Feb 2026 21:08:40 +0100
Message-ID: <20260227200848.114019-10-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13A751C0007
X-Stat-Signature: xzqsybbwoto41atfrse15srzaqn69tw9
X-HE-Tag: 1772223098-981448
X-HE-Meta: U2FsdGVkX1/QWCdauwAkii7hXL0y1yp86i7ogCuDAeLHUJnXsxEjrwoREDjywURtMa/6uQ1QTTSc2Vn8bye9+zSjZjLABfe3F8fIJMruz/R93CT7+48+LI9a4tNcFynZrEvkT4mhEg7tHToxAJk2rd5a/OHyvD/85zHgN/HjwC92XzqGwQRTj2OFQDBO12ry1LR5Br0zYn60CUkzwG21TtgNX5X19qe2rb1V+NYusJBwvIXWTaNOdiJ87jiz7jfrkiV/Z1eyKji4AUXGx8VnXRKuohvvh22nAfL08qQ2zcogitFwWS8fnx1hvAgWc7AlOmhWbegb1I9qV8yvArFeMK3nUUgFFtak8cycpqO47AJDhDJDU8dnqvs2oP8IOztX5UsQuOnvtJv27aanhr7hKpy+smksC0ZsRhDGteV+1KrN4XOsdpkQGj0/MTkPcatwbrQTOujhApLiQ7o02aaLbVRKApc79QnPtmZB9fY8ev9CnrSITpabdQkUzrjmW7Aru/71mUemvV8kl8E6lUdwqXL27ItVBZrSTXL0Ad1kiqxkU1s7tZFBXffiEG/62ssoHZV/+x3ycw6y3bYR9SsHEtsK+D+o8zgPYhyYurNaMHDjrSsALy32sPEdnSUMMI2h2oTS1vWeL5ozDweb71fBKcFwgQYJuIgCXAcWxkioS5qXjFlyFJoHQQKfbjyGVKWWRYwY4H7AAo3CsP7dLl3IRgRGsx1s4HFFao0YVqUl2MSMpZDh0iXxUTp6AKDxdXRuZJsmzlYxSrvA7LMkz3vrxaE9+OIzphzSEpk47XQtP0wDgEl/alXbL8/5GBwZTEYkiDYBGZrBoojOnnJrLakMDGzy2ro5H0fHsdo/ua36WBGnqwTBE7KLqpJ5gRP4zeE9fI2jCGueR6wjDOiD5oltNSXcDrMr63yzZt18CYrJwK07BoPa29ihLQDHMGoyZGYYcXy1LqGuz+iip+HWGpe
 IuC5CUKp
 zKo5eqfOEGmX53puHc5RM0C5Oz/oTRyXGmYMOt4HjmOGPUHnjZuhPBNhL5Mloiflq5Th386Y252fBucqEIQ/miQZNJNbGSX+llojXgRLX02GMro/Pzit4HuHpX7vTy0KYavy0X72JWJg441LO9J7x2K6ibJO+mXcd4geqJ5BO12KqHoaej9+AGhr3nRU5MdYxydYuQStUED2jUzoAVZekmaoCkcEow2MdGauWbs5qXCCuSOnfWlszPPuqbmxhRH1wmkRve3qt4Z/KILuC6a7iU1zrOKf1GNejTeKf6z7GybmPnej3qT5sewllxhA+bJVcDv0q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current semantics are confusing: simply because someone specifies an
empty zap_detail struct suddenly makes should_zap_cows() behave
differently. The default should be to also zap CoW'ed anonymous pages.

Really only unmap_mapping_pages() and friends want to skip zapping of
these anon folios.

So let's invert the meaning; turn the confusing "reclaim_pt" check that
overrides other properties in should_zap_cows() into a safety check.

Note that the only caller that sets reclaim_pt=true is
madvise_dontneed_single_vma(), which wants to zap any pages.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h |  2 +-
 mm/madvise.c       |  1 -
 mm/memory.c        | 12 ++++++------
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d3ef586ee1c0..21b67c203e62 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2798,7 +2798,7 @@ extern void pagefault_out_of_memory(void);
  */
 struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
-	bool even_cows;			/* Zap COWed private pages too? */
+	bool skip_cows;			/* Do not zap COWed private pages */
 	bool reclaim_pt;		/* Need reclaim page tables? */
 	zap_flags_t zap_flags;		/* Extra flags for zapping */
 };
diff --git a/mm/madvise.c b/mm/madvise.c
index 557a360f7919..b51f216934f3 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -853,7 +853,6 @@ static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	struct zap_details details = {
 		.reclaim_pt = true,
-		.even_cows = true,
 	};
 
 	zap_page_range_single_batched(
diff --git a/mm/memory.c b/mm/memory.c
index fdcd2abf29c2..7d7c24c6917c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1554,11 +1554,13 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 static inline bool should_zap_cows(struct zap_details *details)
 {
 	/* By default, zap all pages */
-	if (!details || details->reclaim_pt)
+	if (!details)
 		return true;
 
+	VM_WARN_ON_ONCE(details->skip_cows && details->reclaim_pt);
+
 	/* Or, we zap COWed pages only if the caller wants to */
-	return details->even_cows;
+	return !details->skip_cows;
 }
 
 /* Decides whether we should zap this folio with the folio pointer specified */
@@ -2149,8 +2151,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 	struct mmu_notifier_range range;
 	struct zap_details details = {
 		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
-		/* Careful - we need to zap private pages too! */
-		.even_cows = true,
 	};
 
 	vma = unmap->first;
@@ -4282,7 +4282,7 @@ void unmap_mapping_folio(struct folio *folio)
 	first_index = folio->index;
 	last_index = folio_next_index(folio) - 1;
 
-	details.even_cows = false;
+	details.skip_cows = true;
 	details.single_folio = folio;
 	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
@@ -4312,7 +4312,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 	pgoff_t	first_index = start;
 	pgoff_t	last_index = start + nr - 1;
 
-	details.even_cows = even_cows;
+	details.skip_cows = !even_cows;
 	if (last_index < first_index)
 		last_index = ULONG_MAX;
 
-- 
2.43.0


