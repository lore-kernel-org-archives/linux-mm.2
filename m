Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64015CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607EF6B0099; Mon, 28 Sep 2026 13:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8F16B009B; Mon, 28 Sep 2026 13:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4809A6B009D; Mon, 28 Sep 2026 13:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 180186B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:19:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A06DC802C2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:18 +0000 (UTC)
X-FDA: 85263831996.30.7873123
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9BFF4000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=USSes1s6;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d 5SizAx";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790615956;
	b=SGonjaT6p4ZsX5uKU6MsM5Dx/XauPAah+Pz86FP0q1fu/Z0cho7S1w8aBwWeMiaViEu8mo
	LTJRGfXkUt7GwJOMtM/atb6aYjo8hUAWCCBOs3L4yZERxfOs45vgAJQ9kul8E2IQXg5iq1
	QAqvCmta3beZRB8ZTjp9OQA+7P60qa8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=USSes1s6;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d 5SizAx";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790615956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Eqqf0HCSBZT/jI6NYBtGEMXZWPAcZ1W8yz5dAV6pIs=;
	b=q6aVtItSETKRVIQErLojD4ZwBc3fR1HrNR0y2blYGqW4RI7UKy6Qs4rBN0TFuIL3ksJ5Be
	p8bZtpGi/RDIIxrhn3PSwnm1vzdNcQsNz1YTNIHhv3FHND6Yu9AavryvaOXTIF6+z8GkaK
	Rjh1XwwWaqH9tg3EuyywNCEf+dxwR7U=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 379EA13804E3;
	Mon, 28 Sep 2026 13:19:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 13:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790615956;
	 x=1790623156; bh=8Eqqf0HCSBZT/jI6NYBtGEMXZWPAcZ1W8yz5dAV6pIs=; b=
	USSes1s6BJwzq2EyJPOgLyoA42m2Szuaxg4fHYdIVEsM6a+c+5B4jtmOsypYMet2
	cWlRH2UFJwV4SihUHQZepiNd44Wi6vzbuQpsoNBHUgweIIVbH2KC50Lx62NWHvG9
	A23UQGj36gRTv8fA8FSlNzVQ+9dJjkrf1y3a7Sk3dIRc3mzxS8RMECD5zmPP7hLz
	gaohdpUSF76np+amLfmoXxSe3MNXOmAAMbJ/Pg8b1euJLK4+hdUXum3Yc3Gzkd0Y
	HTv081m46OYKMT2VPDuSTdDSqHQQQBTPg2aJraTBGR11T5L0vlEi+CNw2CY6GyVZ
	SDAMWGuGckkeG2peEGKLoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790615956; x=
	1790623156; bh=8Eqqf0HCSBZT/jI6NYBtGEMXZWPAcZ1W8yz5dAV6pIs=; b=d
	5SizAxEG4NEtVBU6Noa1+LIMQWPIToaS6fW+puNNNuq8kJJY88cjAj+Pz2tIlU58
	YTuFRaDvBWy23WXE5etBTx+xq3aFDeAz+wDoYboEk32Dxg4N7elNhP2mmZSoLQ/d
	tcQ/mXessBCQt1vxCegaA5B6TC4Db4tt6myNJwu1OBDXHmvHULTEzxQ0uh6S2evY
	dxmej9z320SVslK7tqi4A8H9CBEKcmfV3xm0A1+JoIPjlRumuBmTjBumCiYNkhen
	SYXV60omyaSV90HrnQWIbEC6aApEO2axgaqMKwrpRN8/+ycwdEJj2iGkqk3ZNTZR
	m12di5ScZTVY1KizjbGgw==
X-ME-Sender: <xms:lKG6anrrKOx5fQu0pRHdyb_8aX7jttAfKxIJo83VFXIL6Xs8FC4Huw>
    <xme:lKG6alE9VWbFN4WInjtakYZ8jaFoM7EXWUUf35w3iWnBKqIjBNr0Cxcug0o-vw7Se
    qmtkn17fAob1cNbqzJLaMVXFkTeIPUH4v3FEInPlDAYv9XCWB1fmWc>
X-ME-Received: <xmr:lKG6age-4IlQC6waNKqVglG8gWemRJrYAaTw0aS9gQyEc6a1pHTj1Alenfwm77Dz>
X-ME-Proxy-Cause: dmFkZTE3Dtw6IjhE/poi/CDPb5VXEYPNUPEe3rZRr1/3vnluvSNGZwYnc7Od0VEEqw6V8C
    kWRAMYAJAJV5aq+CNT4OFQyy1fVW8k3upxKlO9V7Rt5yUqYEIYE/wijeDPsE7H4gglp/5v
    F6D384IbY5FCBCgoXmGheBdMQQxOBU4ICiAnYejBlRLhJ/CKeqEcgPSAZh68CS/pdW/x+j
    oysMrjjAyGFH6oDZSV+ReHQBDpEH3XjCRs+r4WEsyv+LCLa1ZQRyjrSR6cKgS0Pi5Ve0FP
    CSaf3rI2+ul2/rPFwdCO88CC3NXOaOC07b4Jq2/gPXxONS3ydc229KCVcj4zNvzLHbXFTv
    Y87bfWoHF8P/EF1BtBuJNXri5Y3jHaQznC4c8pM9EDVGJlvXB+ULU56B2/xFp63H3ba76F
    ETaiTGM2+CV9ko/CMXbIA9HXJjVdDn9iwfU9WAkbJ/ktRKz+VCLmlAYjeMQn7eBHDTw/ME
    H7h06B41486MeTNdQ9ihuVImVcZBasvjpa1q3RUWa62/9W6wN7P2jLHSxRBDt9MrP/YHXe
    yrbQCcC5uo2HHogi63k5CazEKRjwFJ5SVg0gWg1DAf6rLjz1AVmATi0NJYKMjfy3jLjC7K
    HX9wF3F9j1o+o0BJlm5e/UuJNK9Ajp2fhlMmmNKWUkt8i5EfZhPcrAzoAV5g
X-ME-Proxy: <xmx:lKG6aj7iLMXS2IlkVZUzLevRbPUirNqNRSORUvG3PpJrzNlf5yEDsg>
    <xmx:lKG6ag-uEgxLdKGbT4N_esjjUBU5IE4qYbp-u5jgSkmAi6zYPZIAHQ>
    <xmx:lKG6avlLiKnKM3qjhyvlZyIHz4mXK79aSCnDuBirhZA0GO48uy4aRA>
    <xmx:lKG6avug_EOHI9_lLLqxGtOHFgEkNxUv_BXJRivr3cNdSU27Lwm3BA>
    <xmx:lKG6ar7342olHzHcQDVc978gVOkRg_kTwspjmX12JEl7Udkf-niszRQM>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:19:02 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:17:51 +0200
Subject: [PATCH v3 03/12] mm: Wire up the crash memaction registry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-3-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Stat-Signature: 4p5curbfxpgc3m3kt5pac3ec5xk56rfy
X-Rspam-User: 
X-Rspamd-Queue-Id: A9BFF4000C
X-HE-Tag: 1790615956-502980
X-HE-Meta: U2FsdGVkX19NUE4hdnnlORF0IbUotHh0K3KHolCfO7BmT9i2p/9105oRYP1n1rVcx3itj0nXnhufrCtrMGxwPhAYGcP6qznn/KH9XIXV/ko9CaSpduknBLEYpGiyIhiFzaijr1cyG5gXE6gwT9ryD9XQlcbKOyXMx6Aq0LTihEaRLop6vBDiSnUj3TE2G0X6OMy5qUJEjbWK1BxYmHWgjoFT3oNk9RHufWopQMQLkKW43vDX9cXxPWCHc3Q7E0x2+rlUCY5busF2FcjtEoHOImEChW5XIXXQ5vqcRI6BVPnuuPVd+X2EY3tYxo/aU63WiCjMgkDYjkZGuy+ZYbCghr5PUDtRDPsnndzriVE2juT5TYKCk0qtm3EHK3LeZGFCKjrHcIEPT27U1vUb3QvdAaonx9r8LWG6KVnDExhDxeBj/gXTgz5tY4JGhICD24aPm81wcA1BpbvOOSyz+C1/vmlL29BuwlWwqQVPBE8YBU3lnWYkkuDFXcQyW+wJZ+wQzlt0yHNjT8b8a7rTviWzhsYk7YLHjSX2Gpe0pPirWqPyCP169AH6N+ldsLjU+LfUfZC98ketxBKQY7IyGVOJWAAmg0yVSnYG/S0M5bySQ4OZlSZrHcGr+y5cBk+X/7k/4Vs2ynEzECx+on7kL9KZmxMNKH0y3odxwJEy6QpmqkA9v4urUpBLBRyTTdvJ3wDJKv9x+Nl7oo5oGIdjobY1Lh5sYhATsKThbJc435rNMyQU0fouvnhZsV+aNwRzKKw/5kQZ4HJuIQhIuIYaMHKvf+V6nMkUo+JSUqC4kUnrmmS2f1q31auwJgPAyQ7KfJtD0t3P1xitdPUN3VsELgsnL/F387MI5tsJekWxCrvFV84+9c9JymAAjAr2vPeLVj3mZnmbp/iuFT7lT8p3esMIuwuhoxubGZmAV3Qq6bchQQpWUpXE9FYFIfFCp46jSTr6GjVe9b8xbyxQOETWSXU
 jGS7Xc8N
 iYp3hIbz3GuBXrl3d2JibS4PLPkeIr08owcS4Zw+d4JYUjWh8o2ufHoqSTxvP897Fny2/+uKHlAqjVKNImSDakucgowkriIJhoVCxwRkaO+N3tiTHdHGc5rmYEPrbEulKueAxj9xVaIi+VWr/d6/X9vm+bRAsnScz+nfsTpH861Z2Qzyzvs+urFmnlmi8/JazYnUQJNj3UM5Sw7zsVxslIwJNDbQYuEI9LWz0hspVijcm+QG704r+9fLg4ZSTsJAMjkk3/PWSuPxPtw34z200w/J2TUU3B2pXlNU9IOV4Y8azYSns7X2f+Aau2HKaPUwToegK4AG/+amR4OzX6r8r3RnCtCed3VPRqs+TRdJFuI5epoqnC3w7zp+ECHP8UJwYMqpK0jxRW2xDiMiUBsEyBJMyK/ub5VuCBem3HSRMPkCPpJjON/61W8K9o3trYOQ2VctQzNRWwxePK4pkIwpO+7rmm1XT6aY4UsCM69aI0T2+bnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocate the registry bitmap during boot and sync marked pages to the
bitmap.

The registry bitmap is handed over to the kdump kernel through physical
addresses and thus needs to be a single, physically contiguous range.

A marking lasts past free and until the page frame is handed out again
in post_alloc_hook() to account for stale data left in pages that are
mid-migration or currently being reclaimed. For the same reason the
unmark comes after any init_on_alloc zeroing.

A hugetlb folio coming out of the pool never passes through
post_alloc_hook(), so it drops the marking of its previous life in
dequeue_hugetlb_folio_node_exact() instead. A folio the pool got from
the page allocator was already cleared in post_alloc_hook.

The hooks sit behind a static key patched out unless the kernel was
booted with crash_memaction= to mitigate overhead when not used.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 mm/hugetlb.c    | 4 ++++
 mm/mm_init.c    | 3 +++
 mm/page_alloc.c | 6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da980377d353..36f0c0d8f5f1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -31,6 +31,7 @@
 #include <linux/numa.h>
 #include <linux/llist.h>
 #include <linux/cma.h>
+#include <linux/crash_memaction.h>
 #include <linux/migrate.h>
 #include <linux/nospec.h>
 #include <linux/delayacct.h>
@@ -1281,6 +1282,9 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+
+		crash_memaction_unmark_pfns(folio_pfn(folio),
+					    folio_nr_pages(folio));
 		return folio;
 	}
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9ce6060de06d..2245972b2685 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -27,6 +27,7 @@
 #include <linux/stackdepot.h>
 #include <linux/swap.h>
 #include <linux/cma.h>
+#include <linux/crash_memaction.h>
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
 #include <linux/sizes.h>
@@ -2706,6 +2707,8 @@ void __init mm_core_init(void)
 	 */
 	kho_memory_init();
 
+	crash_memaction_init();
+
 	memblock_free_all();
 	mem_init();
 	kmem_cache_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 759786240af3..ff82f632dc7d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/khugepaged.h>
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
+#include <linux/crash_memaction.h>
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
 #include "internal.h"
@@ -1854,6 +1855,11 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
 	pgalloc_tag_add(page, current, 1 << order, alloc_flags);
+
+	/*
+	 * Release leftover crash_memaction markings from a previous owner of this page.
+	 */
+	crash_memaction_unmark_pfns(page_to_pfn(page), 1UL << order);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,

-- 
2.55.0


