Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CABB606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ohy/Uv2X
Received: by kanga.kvack.org (Postfix)
	id 4C3796B05B0; Fri,  6 Nov 2026 08:41:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4737A6B05B2; Fri,  6 Nov 2026 08:41:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3895D6B05B3; Fri,  6 Nov 2026 08:41:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 132566B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:41:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4084CA8B39
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:41:19 +0000 (UTC)
X-FDA: 85404805878.29.444D87B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A16F1C000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:41:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ohy/Uv2X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793972477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHFIxXCaPKga6nPstJLsXOx0R+aPE2/7Ghw2d3Thvuw=;
	b=f58iWJlJzqfey1cOrW59NAZhadgUh3pS4DIqxYIXRTDQ65KPhSZZ02KMQC7IkFTZUZEKYe
	bkwEAYqZicY2I4pbnOyg2p120rVHiZnzj+MPIFaCMe5+y0Dkj6TvTrK8vA7j/0rZ88H/Sj
	Q2+p/HvzhQYAzkxup6cpUT8CtVrM6hI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ohy/Uv2X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793972477;
	b=yMzd/2eHErd6qw7HIp+kliU40+HVVhciKoarAs+WDN8XIc5quM+4AAe+khnWF1tI8lUVdu
	gufO5QUPJwwBh7+m5JFbhsnXiNKtznZQ3VVpwtfQkaLyAaILOUtAf35PclEpNQFrTo/60Q
	3ZlvxKju6t20M3Em7nYAd1Lzax7EZ5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 643A441AF8;
	Fri,  6 Nov 2026 13:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554D11F008A1;
	Fri,  6 Nov 2026 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793972476;
	bh=HHFIxXCaPKga6nPstJLsXOx0R+aPE2/7Ghw2d3Thvuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ohy/Uv2Xn6cZr1BQO04HDnuf9F9hXH4bbG13mgGK+uEaX99pzL+8LGjEaZK9xonc6
	 dcj6+HU/7U83GKlsug5UpdM+5OOaBLHZMAKDa5G/iKf2ikGdT0sFZ/OgD5vhaCGJUq
	 ZJMbJ1buuTF886+naEextcTxGecsTV2+AMbInBtm21McjG0qvbkEfMKxts1eRXDriP
	 LzRUV28F+kSdxYqNQWqJG8boUDQEVVvO6pK9RPfxaYUBw4koy1WRXhBI+Bc1qA24aS
	 K4QiG3QEHfNqcfrXDqWfbPg+1h6nWV2e3gKrWUn9RClP6IE/UUKgkxOctvbSSdMCN8
	 5FIXRFLz596Ng==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0C615198003A;
	Fri,  6 Nov 2026 08:41:10 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 06 Nov 2026 08:41:13 -0500
X-ME-Sender: <xms:9tjtahZPGgf_7Mahm6dyFWAiSzOyaPpJy0CJdd2KQR4SLi-gJSQr2Q>
    <xme:9tjtak3xGIlKg3ClGZx_nuLlEK-8f8vHVnOEbsvt6_mjfnUWH0YRMeNNfa2AIwbH_
    exb4qCSdi362NzQOfR2Eo3Qw0qqwd1JZfRou4W8qissDxgyEyCAuFeEJg>
X-ME-Received: <xmr:9tjtarM2RAzkloEnmJErFCGFZPTJdgRBXz20R1fjUAsMiOKwgdL64BcDjpo>
X-ME-Proxy-Cause: dmFkZTFVFaqrxdMA0Rdrdmsp+IP9B9mG/dxHIufxIo+xMkIcBSnN5hVLhkUBVzyjEV4JdK
    Bq8Vi7aogF17ZTGXov2XvAZgFCDHIzZ1XEMCali6ZPDPHgz81JW+gZfwpkmHRh84E617rC
    ahx81ZCaxhS+gJdFDJHUghjaitiOxaZlDtB9yoTdxdwNZEwU7fgFbA0LirO/asuE/CuRCW
    9U41q6izoAvPbSw1lF0KFBqKm4Q8PzBRTNxmqm/BVcpVogZmMFoTujTVS4zbZTjDyjc3bw
    v61ycqyrVpQGPm8Q1YhBM79/LSXec2moRI22lkXKfGd03YJNu+S+2c7N0OvVF6uO48jTrM
    fFIL9grvdTdMUrD2C4QZUqgAWZCtyLtK9B2jZ4goPrhuzTNJUFDDE7ZcFLlTg1mNZAPs1p
    +X7thflt3GXGXPKYGweuPvUhOtUGHOvsnPFXPnl/LS6whsO77murx4EIu/9cMeqg7JG6+c
    of/qkUbAzxKd9XHYtpZHF6l4M2cYrAc9bnBsEqk6PCiT7YfcFvCeMW0+BXLs7LJV7sMh3z
    5UMEQit26OJygfOSJtXIOVP78gP7LsNPGlN9dvAeB7IwvncyiDGYLJLYjuqqaqVYRdUocr
    sTna/nVF3l+i7zzPA3K75Sl+8L9syB21FOm4TZNdzoYe5KTaE8phGK5MIqEQ
X-ME-Proxy: <xmx:9tjtamI4ieZk2t1h2e7TrdxSr8WRa0nkLNU6y9HkZOc4xn6p54IiOw>
    <xmx:9tjtas5yULsRxxSgzHZEkdMMZNXYy6NCoZQYeZQAQSbgmhCIou9o7Q>
    <xmx:9tjtarTszdhzO2TYo4wyeMrDKRgx39K026_RI1D6gGbKDq5bU0pcUA>
    <xmx:9tjtand1KXXf_qlaCXE5vPXegDRYcgMQ20CkK2kpRZTN8SVwogP7sQ>
    <xmx:9tjtak1wrj_BF14J7-J0wDrZQD_zvCfvlmvdV9QWVsVih_sWxdRgb013>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 08:41:10 -0500 (EST)
Date: Fri, 6 Nov 2026 13:41:09 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
Message-ID: <au3YD92l6BwCQIPJ@thinkstation>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
 <au3C8lNElGg4LnR1@thinkstation>
 <254c6f0a-9353-4806-a5ab-a071cd59c64f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254c6f0a-9353-4806-a5ab-a071cd59c64f@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A16F1C000C
X-Stat-Signature: xncsh5acspfprf1skzqm6z1p3j3jeo7z
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793972477-700628
X-HE-Meta: U2FsdGVkX18iwLUIVLSW4HKGUbRYqvN2qERRpEL9MjdTMmHKnmKA6/3zA1qbEM+HBlfzr5g7Sc1iS7BYT1deIJwdHUNM9j6PqBD42/CZ0siIDnQLdrOgaZhB2iovqz+Jna9/1tWg7zCm59s6/IkEh+cbbWL/wPechtK+BOkpsXGh7S3UFhPv3q6mPlu0t7GAwzXbUjT3QVOVKAs4lxbJyVn3y9bQ1QfkuqE9R/kYeGf0oNNx1D27n1O4YGMT6KT8IUeDQIs1xY29RfS75K2vGdZ8gTWBn1KZy111SizTQ2i3vIrj7HeOjuZKuhSleP5FnlT+8WW9/PpGMcuwFm7HJySXczDWCwGkVCZITXCgpDNcw8MS49jO38h+hUASIBETJX2io7/+K+Hw6c53+dtW4r2bZHtfNCuZOLIXkF6T63+8hQpco4LZi5PUBtdfrypzlNZR51jmTV6ytN2NjjuROfWpSY6kMsyUaHGceOrIHDfeuHEV/o+nkENJXNExYO3jHt9yjarJrTE1sxKt2QF3IthzaO75BlCT7+3DpJCtGAL/L3VI+KxzVfNtXsV0oxXqdwUeHA5w94aFH3j2FwtUM3zg8IGVNy3tFyXr3Bz/ml0Gf+51idmMfNuSS+Cvakev6YM5rMXQbaL5u7DP7TOCKrBmuEUDYZlxLOxeKlDbHw94dxRL+/b+AnO6yyqvBT0Wxr0xjmdisU4vWSQY/lP3mkqNFwG1n6Zb2KRYV3W/cZvMUJ/8ln2wFgPhvw14Cel1Ut7BocvInwYaf1wb9dRIlJKcp30jGcn2zLU1CJaJYrn+UoCZo1xS4ZmgsCs1yDGBcWVvIHDLE8AIKRVau8Yf8gS8mxEh2BjFz+WTt7HhABXsJ9NHajy0qI8H694RP91C5Gy2hl6GZ4aU+DJUyDxO+TNGHWHFDcUM88ptvSHOOrvNQdNpjLEjuJw8lNc/xxg8ci7jX2tvzRVwuktI32t
 I8cshMiK
 j/TcND6E+UbNd+r0BCLytYi+Mu4bxfJzWHlXZ9TWmJ5DZ4dHpW9w1XpB9u26EK7Dq52AJSgqlTiysE1TBpZo2thieiQWxdHLwV1aSSaGqz/IDEOXwUx7Q8OG7sLliLPa9+Rzsbp8tuM26OAlI7U9IjO5w8fFQ14hII1tj5FvSO45la3PPKWFTDpgrkvl+1Wylyr7+OdXfAiIpyL6zeocx9vsp8cg2kvZ9V0rUG56pzRhya6Kg+INc5hKVrmMMLbny8Oaltpulzd80LQlvz1sRIX59ZGDqxlNqDnxWiGDBogxEwOw6l2DgpFwuFXyYvMrCa1XEwTtS0tTeqjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 01:29:31PM +0100, David Hildenbrand (Arm) wrote:
> > Separately from this fix: nothing on the mapping side catches this.
> > Every caller checks uptodate on its own (next_uptodate_folio(),
> > filemap_fault(), shmem_get_folio()), and khugepaged was the one that
> > went straight from filemap_lock_folio() to do_set_pmd().
> > 
> > Should do_set_pmd() and set_pte_range() assert it? Something like
> > 
> >         VM_WARN_ON_ONCE_FOLIO(folio->mapping && !folio_test_anon(folio) &&
> >                               !folio_test_uptodate(folio), folio);
> 
> I think so. But looking at these hard-to-trigger but in the end very nasty
> problems, should we actually reject the operation and do a pr_warn_once() or
> something?

Yes, rejecting sounds better.

Not in set_pte_range() as I suggested, though. Fault-around only gets
there with folios that next_uptodate_folio() checked under the folio
lock, and for CoW it maps the new anon folio after do_cow_fault() has
already copied from the page cache one.

Checking the folio ->fault() returned in finish_fault() covers PTE, PMD
and CoW; do_set_pmd() covers khugepaged. Both return VM_FAULT_SIGBUS.

Something like this, only compile-tested:

diff --git a/mm/memory.c b/mm/memory.c
index 6fe0b7dab927..ff2f2deff761 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5674,6 +5674,22 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
        return ret;
 }

+/*
+ * A page cache folio that is not uptodate holds data that was never read in
+ * or cleared, and mapping it leaks stale memory to userspace. The callers are
+ * expected to check, so treat a hit as a kernel bug and refuse the mapping.
+ */
+static bool file_folio_not_uptodate(struct folio *folio)
+{
+       if (likely(folio_test_uptodate(folio)))
+               return false;
+       /* Driver pages from ->fault() never get PG_uptodate */
+       if (folio_test_anon(folio) || !folio->mapping)
+               return false;
+       WARN_ONCE(1, "refusing to map a page cache folio that is not uptodate\n");
+       return true;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void deposit_prealloc_pte(struct vm_fault *vmf)
 {
@@ -5714,6 +5730,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
                return ret;
        page = &folio->page;

+       if (file_folio_not_uptodate(folio))
+               return VM_FAULT_SIGBUS;
+
        /*
         * Just backoff if any subpage of a THP is corrupted otherwise
         * the corrupted page may mapped by PMD silently to escape the
@@ -5849,6 +5868,16 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
        unsigned long addr;
        bool needs_fallback = false;

+       /*
+        * Check the folio ->fault() returned. For CoW that is the source of the
+        * copy; DAX CoW has none.
+        */
+       if (vmf->page) {
+               folio = page_folio(vmf->page);
+               if (file_folio_not_uptodate(folio))
+                       return VM_FAULT_SIGBUS;
+       }
+
 fallback:
        addr = vmf->address;
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

