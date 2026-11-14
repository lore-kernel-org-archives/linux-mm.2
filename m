Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6E3606A88C
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+aUZtMR
Received: by kanga.kvack.org (Postfix)
	id 517066B00EF; Sat, 14 Nov 2026 10:30:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7E16B05B0; Sat, 14 Nov 2026 10:30:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390836B05B1; Sat, 14 Nov 2026 10:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04D3A6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:30:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6ABF9C045F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:30:16 +0000 (UTC)
X-FDA: 85434110832.30.FF80A12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 941D1160005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:30:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+aUZtMR;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794670214;
	b=IkKJVNZ4Tn+lwZrC17YqwEwQy7FKLzY7PboF9+44sysErnm3AHy4fBCUo6nKW83zYLn9hL
	wqs4VQ1FeHH/+g4EsXnRrAvAY54mbGV1WjTChiQ4tqGcFHc+28b25u4MMLhis+gqDNQmWp
	64oc1gSLSstExcmgXu2X2zHRs2hoB1s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+aUZtMR;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794670214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CaF/dW7GT+ZrmvxDzq7Ic0oGysgXTuvqm7cExj2OFs=;
	b=ggmPtvc/VHL5WgSIzHGOulH0UNHJrNpcrBpc9eVF70GZQExG1Wn29wuIU5alYSyx8ntWHu
	uQeankI/5D8cjfmXtP9eY7EtkUWDRlMh6P87TGaIR9FFmiYdc8JurX+2GA7h093yz/neW2
	ZQ0TkfvPRoC1fPXCZTumlxYHjgHrP5Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DFA8623B6;
	Sat, 14 Nov 2026 15:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3C61F000C4;
	Sat, 14 Nov 2026 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794670213;
	bh=/CaF/dW7GT+ZrmvxDzq7Ic0oGysgXTuvqm7cExj2OFs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i+aUZtMRmMOBNXRqSIDbEiKG4TPzDUf9FBBuOfX1hLk+/UMOfEspx76/idXZdkTRQ
	 cEHGiWZAV8Fhautj1kgxTSscEygG9RYcPg4k4yHtuDiRp6JMWil1CGIqq0yKLnObVB
	 tc0qomhVBwL+MCFLGYPWZWqjxEQqi/id7QDNMwE/DHzAfases6bt60v5kldjFoGxgd
	 tMu6mjX4k/eXmE0mIDULY47ZSmE6SWtk6xMjdLxUP9uG3WJjBa/3oP70L5vu1sBxLE
	 u3or5uDPmHABtKwFnb8LIKXvJ00fMDmvGBlnPGRJ7WKGoyur84qvsKn+3zuurFXR6n
	 QuD3RXY0HMZEw==
Message-ID: <2e6b3b24-a901-4147-a01b-a8da0e7c5ebb@kernel.org>
Date: Sat, 14 Nov 2026 16:29:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] mm: limit pagecache folio refcount when mapping
 pages
To: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, netdev@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>
References: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
 <20261112-refcount_overflow_stable-v4-1-ad3deef0bd23@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112-refcount_overflow_stable-v4-1-ad3deef0bd23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yuytt4ht1xdcg4cqswi63ywwqdietc95
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 941D1160005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794670214-555249
X-HE-Meta: U2FsdGVkX197bkEd6WxY2Ubx0GPnRELEiytGn2hCPJyWZ05qjjaWSLnZ3nRutB6SfUbf9/vXqxbKU9msyj0XH1EcnKfXn/FziMylOotruPL6jk47qwu4gwV6Oa+Iak1TWji2GEZq93Ty1CFuRX9+SYPP2RyiuK1nDpKkqfrUWlhgbpOo/WpDfj9VZ5UpVug1x47UIMFI29XiJVnOhCDwSiX32CtpXS9g5a2dKRncKvb5XdaXExWs0tKvZC3C0OeMFw257eJSyimPOUTIEy0rv2hwXxjzn2+AFwMqqKwV1u+/E95rMHsz7xDpdH3fhN3EmKSuNpiyQ/DWlneFPyG5wE1+raFRrjEsiMAnDTAblhUwNROIYfij7kxL2MdVeDcdmsaBan0yemlCLlp84wkVRsDItooSY6yPSYHgINXY990d3wPlz9cfxq7IiBJjeI1bDJkhPRPwERtP5GDVVnKav2ptLbnJ5hOL8NqdPJ9k0d80drfNB2R/z7xEDXdAG1BBRmRYdsObCLgyQ/sBcVZtkSX6BJpcnik5Pw41n5mIx23PBfRGq2VUpIFKsY+hqy8rzRyDI6ER/SWOE14cfUAVFNozoTATIWrknpnnP3ai31As1fL2RNzwtzxgmzSrKZok5+KN61wbpo6cLnLVhE/kOe58UteqoFCTIPY58E9pnysv3Bxp8y3FwQ0tTgIS/roT2VyDqsUq4oK/7RbFvHVp8J6bd95DYIexPFDnkBbSxUjH1UbVqcbtQLL0NTUdR0+WcypOKrW+cybr5X7EGaaZy2PtV66chTbNARJFK5Rt/IYmVAsFueldN3T0CCNjp9wsGiNo57c8atrxU3Z7o1tKSUu2VNxjdSR0GTXB10c7JUktonJAgCVYjsSDDIZPjTtiLvZKKhZTjQjwea3KKKcavPxX7sFuK7dySFJJMTB8n4dPmqDPazdV8gw1XCtXTiXxC4ed5cuJGTPdhlm0LFW
 hwijCS/q
 xqytjz2BmhdgSiqOdtU2rrBZ6VYt7wXpeC1fnxGVa6aerA8+BohMqXCbGYQ++N8UrsnfNyJhzwwvjDYRNPaysvvMS+HL8FOklIFv9hPFe7IUdIeL4bDqb8hDDHqYG230nwZl2JoB4DPvGIMESp0E7pQQyXi5VhrbfQbobZIk3wpHQSmQCsElsjEGiIVmnDzPPIbtXnn+5tFcFjSumxn/Ym4/q2QThrq5or+UuNoGnyoozQ63x6lwc12/enNCyjg7hd4UppH37lR2tiR6JsepVyMVrZo4N6c8zz2B1ptzpVPXYddjHO0b8lzGwUco49mEhn4hSYW8G/WWMfHejVCGACkqBD5CDbEFkamEwlfOMyQQotmqY18vXIirT4aM8aVHJufST4IXmj6TKMY1w2yRBtMQahw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 23:53, David Hildenbrand (Arm) wrote:
> With large file folios, overflowing the folio mapcount and refcount
> became possible more easily. For anon folios it is currently not really
> an issue: each large anon folio can only be mapped once into a process; on
> 4k kernels it would be more processes than usually allowed on a system,
> and on 16k or 64k kernels the processes alone would consume hundreds of
> GiB. Something to be sorted out at some point, but it's not as urgent.
> 
> Being able to overflow the refcount is not really big news, but it's about
> time that we do something about it because some modern technology might
> find ways to abuse it :)
> 
> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
> refcounting"), however, file thp support was added later.
> 
> File folios can be mapped multiple times into the same process, allowing
> for processes to hold many references to the same folio.
> 
> As a short-term solution, let's introduce two folio refcount limits:
> one for ordinary consumers and one for admins. Leave some headroom
> before the refcount goes negative, which we really don't want (having
> the mapcount go negative is also not expected).
> 
> Start reporting SIGBUS and a ratelimited warning if we run into limits.
> When restoring mappings from migration entries, instead zap the pte/pmd
> entry. We allow for slightly exceeding the limit to keep things simpler.
> 
> During fork(), prefer not copying page table entries over failing fork.
> For fault-around, check in next_uptodate_folio() before trying to lock
> the folio.
> 
> Export folio_ref_count_over_limit_slowpath() using EXPORT_SYMBOL_GPL
> right away so modules can use it through try_get_page(), where we will
> use it next.
> 
> Use has_capability_noaudit(current, CAP_SYS_RESOURCE),
> so filesystem credential overrides do not affect access to the admin
> reserve, and to not generate auditing messages simply because we access
> optional reserves.
> 
> Don't grant access to the admin reserve from kernel threads, from
> interrupt context, where "current" is just the interrupted task, or with
> IRQs disabled, as even unaudited capability checks can take locks.
> 
> This is far from ideal, but better than all easy alternatives we can
> backport comfortably. For now it fixes the big problem: letting
> the refcount (+mapcount) go negative and cause trouble.
> 
> This is only a temporary fix. Keep the mapping checks explicit and
> separate from reference acquisition: most are expected to disappear when
> we rework the underlying refcounting.
> 
> Check order 0 folios as well for consistency: each
> folio_add_file_rmap*() and folio_dup_file_rmap*() needs a prior check.
> 
> Adjust the check in folio_get() to just check for invalid refcounts and
> drop folio_ref_zero_or_close_to_overflow(): we really don't want
> negative refcounts or negative mapcounts. Convert to VM_WARN_ON_FOLIO as
> we touch it.
> 
> Also, just document -EHWPOISON for copy_present_ptes() while at it.
> 
> Note: When zapping file migration entries, uffd-wp is preserved using PTE
> markers, but uffd-rwp protection is lost because there is no corresponding
> marker. try_to_unmap() already has the same problem when unmapping file
> folios, so we'll happily ignore it.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

I'll squash the following into the applied patch.

I will not print the PFN for now; it's something that can be
forced by a user so exposing the PFN makes me a bit uneasy. If we
are ever sure that exposing the PFN is ok we can easily add it.

As I replied, for these stable fixes I will leave the refcount
handling as it is right now. We don't expect negative refcounts 
r mapcount (folio_mapped() is a prime example). I especially don't
want that in stable kernels where we might have older code that
dependes on that.

That part will be reworked and optimized as I'll change the refcount
handling for page table mappings; then we'll be able to drop the
admin reserve and the limits, and just cap+warn once the refcount goes
negative.

From 423c4226789587ee4aa3e0e34760dab9a52e2947 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 14 Nov 2026 16:27:17 +0100
Subject: [PATCH] fixup

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/folio.c | 26 ++++++++++++++++++++++++++
 mm/util.c  | 26 --------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index dc2c796a4ea74..1cafa45a6a834 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -151,6 +151,32 @@ void __folio_put(struct folio *folio)
 }
 EXPORT_SYMBOL(__folio_put);
 
+bool folio_ref_count_over_limit_slowpath(const struct folio *folio,
+		unsigned int ref_count)
+{
+	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
+		goto over_limit;
+	/* Background threads must not consume admin reserves. */
+	if (current->flags & PF_KTHREAD)
+		goto over_limit;
+	/* Neither must interrupt contexts on behalf of the interrupted task. */
+	if (!in_task())
+		goto over_limit;
+	/* Capability checks are not safe with IRQs disabled. */
+	if (irqs_disabled())
+		goto over_limit;
+	/* Use the task's credentials, which filesystem overrides cannot change. */
+	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
+		return false;
+
+over_limit:
+	pr_warn_ratelimited("folio:%p refcount:%d mapcount:%d mapping:%p index:%#lx reached refcount limit\n",
+			    folio, (int)ref_count, folio_mapcount(folio),
+			    folio_mapping(folio), folio->index);
+	return true;
+}
+EXPORT_SYMBOL_GPL(folio_ref_count_over_limit_slowpath);
+
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
 /*
diff --git a/mm/util.c b/mm/util.c
index c9c3dc4b490fa..80f6c714844f2 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -791,32 +791,6 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
-bool folio_ref_count_over_limit_slowpath(const struct folio *folio,
-		unsigned int ref_count)
-{
-	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
-		goto over_limit;
-	/* Background threads must not consume admin reserves. */
-	if (current->flags & PF_KTHREAD)
-		goto over_limit;
-	/* Neither must interrupt contexts on behalf of the interrupted task. */
-	if (!in_task())
-		goto over_limit;
-	/* Capability checks are not safe with IRQs disabled. */
-	if (irqs_disabled())
-		goto over_limit;
-	/* Use the task's credentials, which filesystem overrides cannot change. */
-	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
-		return false;
-
-over_limit:
-	pr_warn_ratelimited("folio:%p refcount:%d mapcount:%d mapping:%p reached refcount limit\n",
-			    folio, (int)ref_count, folio_mapcount(folio),
-			    folio_mapping(folio));
-	return true;
-}
-EXPORT_SYMBOL_GPL(folio_ref_count_over_limit_slowpath);
-
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-- 
2.56.0


-- 
Cheers,

David

