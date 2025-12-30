Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C305BEE57C2
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187996B0088; Tue, 30 Dec 2025 16:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F536B0089; Tue, 30 Dec 2025 16:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E546B008A; Tue, 30 Dec 2025 16:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E77356B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:59:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7747B58860
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:59:47 +0000 (UTC)
X-FDA: 84277505214.03.DC05CD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 52B6880004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:59:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhJvAejN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767131985; a=rsa-sha256;
	cv=none;
	b=1uzZXyzQXKrawx4dq7j0Q544+Ivu99lP81qbJLjVKIIEI6fKh1VELIurrUKpfIa1B8mJId
	dRAPn7ahtE7tqVl386Lnv1brZjXk+cjuopqygaYY0qEfylKH3B6VsYMHVby1hyuUqYe2hh
	R+3cZc4+GJe7WXLRC13sODmKB3tQApk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhJvAejN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767131985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JWoOLuCTZoNd9Q1C2OQ9XFwTbb8UOHvzsa/yAPINKo=;
	b=vtfflz2grjszKaWs+Jt02+/BZ0ncYIOPYtamUJ0tHuRijPm1wO7ojBQFoprx60uGId2756
	0sppkqRU+quUgluSQHg7f0YTPUw3fxz13jFO5rI6rVQ0DN0aA106Ubw7CrB9QD0UcXRoNM
	/hTCP7xV3HuuaCncgMec4voifrc4IvQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F58860008;
	Tue, 30 Dec 2025 21:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECA2C4CEFB;
	Tue, 30 Dec 2025 21:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767131984;
	bh=GfelE0fYdJif1BRobQUoz+HvvPFp6oiAH1Y1e0bAXDI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mhJvAejNJCYCDHaE0JYN1bwqqVI0Ob9DB8xO+w+dtAkl8np75Tau5elZ22GsVVGon
	 jU3rjEP7VUdjPCX6zuofPWqUgRb1dtGWsOdSfWyp6qcz9JHsBS9MY6/dUbiZt+0fQQ
	 gbj2xpFLHvE1v2RgXtuICYjW6+XliC4OB2g58mwqs67ZnEkfWxD4E+kMrLlnzlHuJQ
	 ZlnISOZ6VA+LWEOPUFkYxDeEfcjAKcsElTDWx6fMyh243m4FSJYLHNAF5pbTBDLTky
	 3xWHWVntY/nxM8VREBmA6TBicfSz8tCgGfQ1lbYzsxFN+YGoKCnfJtp6TnJxGPSw1+
	 WghU801wEetNg==
Message-ID: <4029d13c-3bfc-4ace-8da0-3895dfc001b1@kernel.org>
Date: Tue, 30 Dec 2025 22:59:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled
 codes.
To: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>
Cc: Wale Zhang <wale.zhang.ftd@gmail.com>, chrisl@kernel.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, linux-mm@kvack.org
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
 <cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org>
 <CAGsJ_4w=KuVs5+p+3gZ=L7=rzA3qgnMVQOBJNBEPnMDWx2N+dg@mail.gmail.com>
 <20251230133522.e15135c3a17826428f472a2e@linux-foundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251230133522.e15135c3a17826428f472a2e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52B6880004
X-Rspamd-Server: rspam03
X-Stat-Signature: 461kdaaj86araaxtj37kf9yww6yxqwhf
X-Rspam-User: 
X-HE-Tag: 1767131985-544521
X-HE-Meta: U2FsdGVkX18uqMC7PPBBT82gt/CH7UzV96pQh7xd4rUeFbWAWrmpQf8EVX7kRW7wGiNBPZJiJ0BXLhHJ6Gfx8Y6IsFA/RUdHX2+DNzGLZfIaLTVH8FyfTIUgKirqTCilZ/MFHFjNpXSgrmd703nMXLJpbq2/e/DJvU5vpi+uhZ1cPsY+nojtHrmYrN/JF+k9muj30b7ek4jDR3VPhGydyMFqPFA7rBVCf5Gi3GFSgjNxxh3CClQfPK2ArGa/k1xOFL9wjPxD64X4qsGkFEABfaPv1s9lOwsQv4mm72IfzWraEePHiaGAhVRkqcrKH7AO/Eb1kZ4/Hx8xmhFC+EJpIBEH8gZfEJKbTNH1TnGPidcR2uhE6wTaGJCAGuL3rnlZAaMp/E+cLbMknMhXG0klmwwUPbz2B1JzYIYuR72tl1BurqzAhVVSUztYFgP57ebtsAgMj0vktEQsRi7E57nZFohcYhmryF/YDiUZ16AbJuJfoCfCOpAc6ZuImMxLjnAETkBCeVBkYPJepyS8ANNjrNWW2g8CQC7yLpl+0s+cQmHU3w++aSuIzuZIM5Om+Rk9DM9BGISSDK7RIi4/U2wlLOfpSMbwgG1DuUGQG87BdX5VX3mpOuMva5pc3kRUv1hgVjm+13LeSW52BUeEeP83jw6d9Nz8oaPO4tb/S/Z94mHQj6Mxq1Tv/j4ugHeQe5MkA3cwXI0iQM87BOoXk9zVCz2l87qhwGBMAXujmXFl56nRO7uF3bpF30AMe1EemqoV7HnzNCX+lhobNI4QEaR5tOaZ1Ucay3epYlSCQsYVV6C+JzteIy7ykAs8OCRBItd584nzBmmwdCbEGnTcFGL1kaS5Qb7O1BSIXL3BNeDbmzsNOgKceonQR7n9n/A9xo5uCnYaPEP8o6zHx6MBkrF2PjJbgHhHkyyP9ERrPlY8sVzLXyHzqwoFJ0qjF5d3ma2WfAh4CcBUTUXSNqWFH8W
 Qag+xY6M
 tEdJpVfBetc5bCsLz+B3q1LsLw5Ir/Xq7bz/n80dZeiUIPB4vmAJCp/dJSm70ZT3bNrZc2k+EDFmMW+60w/bzlzPK73ebkvrrST6LLuLZK9bziYvb9eTWXKyJO/MY9EKNeZbx3cldpT3YD5S3Nx4752goxXkf81JeBRKepSDCBoDTb+zSLgd9PkEmLRvF7QgNTkwxBh0Llwh0E5Aeie1UMj9sO5wf3+5xItrt7gbHnAbmR95WEmi5m1uTapRzAvBF8on6QVPWHDXc5EfGclZ2IoNS/GA9I1UZbSvGv/shBUq/39Y3y7TmfmqlOApLZhad8fZlrqYNXLY3WPm0D9N6Qr9f25weszG0l4MKnlZdzIdg/pPhsprpQZhazcN7J8WenyPvbCbaIfM2wjG2B+uRUIHeNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/30/25 22:35, Andrew Morton wrote:
> On Wed, 31 Dec 2025 10:28:25 +1300 Barry Song <21cnbao@gmail.com> wrote:
> 
>> On Wed, Dec 31, 2025 at 8:50 AM David Hildenbrand (Red Hat)
>> <david@kernel.org> wrote:
>>>
>>>
>>>> -                     break;
>>>> +#ifdef CONFIG_NO_PAGE_MAPCOUNT
>>>> +             last = atomic_add_negative(-1, &folio->_entire_mapcount);
>>>> +             if (level == PGTABLE_LEVEL_PMD && last)
>>>> +                     nr_pmdmapped = folio_large_nr_pages(folio);
>>>> +             nr = folio_dec_return_large_mapcount(folio, vma);
>>>> +             if (!nr) {
>>>> +                     /* Now completely unmapped. */
>>>> +                     nr = folio_large_nr_pages(folio);
>>>> +             } else {
>>>> +                     partially_mapped = last &&
>>>> +                             nr < folio_large_nr_pages(folio);
>>>> +                     nr = 0;
>>>
>>> The whole code was written to avoid ifdefs.
>>
>> The #ifdefs are only for -O0 builds, which are never a
>> mainline requirement. However, dropping functions that
>> contain nothing but a BUILD_BUG() seems reasonable?
> 
> Let's not make -O0 an objective, please.  We often make assumptions
> about dead code elimination in order to keep kernel code more pleasing
> to read and to maintain.
> 
>> If those functions were actually required, the compiler
>> would fail anyway. In that case, there doesn’t seem to be
>> much value in keeping wrapper functions whose sole purpose
>> is to contain a single BUILD_BUG().
> 
> I agree with that part of the patch - if the thing only does a
> BUILD_BUG() then let's simply remove it.  If somehow the compiler tries
> to reference the now-not-present function then we'll get an error message
> anyway.
> 

The change

	+#ifdef CONFIG_NO_PAGE_MAPCOUNT
	+#define folio_inc_return_large_mapcount(folio, vma) \
	+	folio_add_return_large_mapcount(folio, 1, vma)
	 #define folio_dec_return_large_mapcount(folio, vma) \
	 	folio_sub_return_large_mapcount(folio, 1, vma)
	+#endif

In the patch is wrong. It must be CONFIG_MM_ID.



So if the following makes compilers happy, fine with me:

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d9..9d782826e8579 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -336,6 +336,11 @@ static __always_inline int folio_sub_return_large_mapcount(struct folio *folio,
         return new_mapcount_val + 1;
  }
  #define folio_sub_large_mapcount folio_sub_return_large_mapcount
+
+#define folio_inc_return_large_mapcount(folio, vma) \
+       folio_add_return_large_mapcount(folio, 1, vma)
+#define folio_dec_return_large_mapcount(folio, vma) \
+       folio_sub_return_large_mapcount(folio, 1, vma)
  #else /* !CONFIG_MM_ID */
  /*
   * See __folio_rmap_sanity_checks(), we might map large folios even without
@@ -354,33 +359,17 @@ static inline void folio_add_large_mapcount(struct folio *folio,
         atomic_add(diff, &folio->_large_mapcount);
  }
  
-static inline int folio_add_return_large_mapcount(struct folio *folio,
-               int diff, struct vm_area_struct *vma)
-{
-       BUILD_BUG();
-}
-
  static inline void folio_sub_large_mapcount(struct folio *folio,
                 int diff, struct vm_area_struct *vma)
  {
         atomic_sub(diff, &folio->_large_mapcount);
  }
-
-static inline int folio_sub_return_large_mapcount(struct folio *folio,
-               int diff, struct vm_area_struct *vma)
-{
-       BUILD_BUG();
-}
  #endif /* CONFIG_MM_ID */
  
  #define folio_inc_large_mapcount(folio, vma) \
         folio_add_large_mapcount(folio, 1, vma)
-#define folio_inc_return_large_mapcount(folio, vma) \
-       folio_add_return_large_mapcount(folio, 1, vma)
  #define folio_dec_large_mapcount(folio, vma) \
         folio_sub_large_mapcount(folio, 1, vma)
-#define folio_dec_return_large_mapcount(folio, vma) \
-       folio_sub_return_large_mapcount(folio, 1, vma)
  
  /* RMAP flags, currently only relevant for some anon rmap operations. */
  typedef int __bitwise rmap_t;



Use a config with !CONFIG_TRANSPARENT_HUGEPAGE:

  $ LANG=C make mm/rmap.o
   CALL    scripts/checksyscalls.sh
   DESCEND objtool
   INSTALL libsubcmd_headers
   DESCEND bpf/resolve_btfids
   INSTALL libsubcmd_headers
   CC      mm/rmap.o
mm/rmap.c: In function '__folio_add_rmap':
mm/rmap.c:1249:30: error: implicit declaration of function 'folio_add_return_large_mapcount'; did you mean 'folio_add_large_mapcount'? [-Wimplicit-function-declaration]
  1249 |                         nr = folio_add_return_large_mapcount(folio, orig_nr_pages, vma);
       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                              folio_add_large_mapcount
mm/rmap.c:1274:30: error: implicit declaration of function 'folio_inc_return_large_mapcount'; did you mean 'folio_inc_large_mapcount'? [-Wimplicit-function-declaration]
  1274 |                         nr = folio_inc_return_large_mapcount(folio, vma);
       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                              folio_inc_large_mapcount
mm/rmap.c: In function '__folio_remove_rmap':
mm/rmap.c:1673:30: error: implicit declaration of function 'folio_sub_return_large_mapcount'; did you mean 'folio_sub_large_mapcount'? [-Wimplicit-function-declaration]
  1673 |                         nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                              folio_sub_large_mapcount
mm/rmap.c:1702:30: error: implicit declaration of function 'folio_dec_return_large_mapcount'; did you mean 'folio_dec_large_mapcount'? [-Wimplicit-function-declaration]
  1702 |                         nr = folio_dec_return_large_mapcount(folio, vma);
       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                              folio_dec_large_mapcount
make[3]: *** [scripts/Makefile.build:287: mm/rmap.o] Error 1
make[2]: *** [scripts/Makefile.build:556: mm] Error 2
make[1]: *** [/home/dhildenb/git/linux/Makefile:2054: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2



-- 
Cheers

David

