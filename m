Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B770E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Dk9MxigL
Received: by kanga.kvack.org (Postfix)
	id D4ABC6B05B4; Fri,  6 Nov 2026 15:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB976B05B5; Fri,  6 Nov 2026 15:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA076B05B6; Fri,  6 Nov 2026 15:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF236B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:43:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37D8D160188
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:43:15 +0000 (UTC)
X-FDA: 85405869150.05.096F855
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DAF6180003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:43:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Dk9MxigL;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793997793;
	b=SieEwyRUrjf/GhuoR3s6H5dBV5PBxc1jFDp6cKhY21KKG8P0ztMPKzpuDhBR1NaO/p3H3/
	8semXTTRXyJnYE9XB6Sd0NLGhoI/AyImsCsoJ0XpeRFfrJ3wlMOm0Uqj5TwAm+YziGQgN8
	1gIAZZZwsXYylFKuptN6Kfvf8bkgnmA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Dk9MxigL;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793997793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ws2V6VbViJ6cnrlfEDvDEs6KCs0YOuB35XjyLfjvYOA=;
	b=Z8u122RHUps7Fl5Ur3AXhVRSGg0K2MJMa+2sEb2JBBY9KNBQ8s3nAvyjRz3BhPM3PWEjFR
	nO/RDDuFJf25ahp9tTLNm1TXS2rcRPYbgp4iYqQRtNZJ17NEAmYSZx0bKTEluHILqd5q/o
	Q+caFnmqpMfT5wBBz7UvfiY4mRAfsFg=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91e9309f171so10529506d6.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 12:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793997792; x=1794602592; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ws2V6VbViJ6cnrlfEDvDEs6KCs0YOuB35XjyLfjvYOA=;
        b=Dk9MxigLSEjspY6QbzG1726B39o+E5ZzN+oO9XjJUuZMl3LkXEpw3d+Jto3VhqA0bU
         UaU6TSOJ1gKl7HGCaunSix8a5ORZSVb58Ogd9SeyRIE1Zztz0KrE2WPgZoosPWVF89kh
         Zk7EZshNQ7U238fyOUdDcKXi7WaP3IK3vqAv1Zlq2O8KCLevgQf9jMvMOy6ErYJcIc1d
         x4O4USPGgEvl86naK32qvTHFbnrPczI909IQMcA4YH8TptP8GYuiHGt81+rbUI4dlVBY
         NLskw6xcCquOQazTcr5ov1ItzJcg0OzZrcrErIKMSymhb9sCwQb8DN79SCvAiBjppLhL
         0NBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793997792; x=1794602592;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ws2V6VbViJ6cnrlfEDvDEs6KCs0YOuB35XjyLfjvYOA=;
        b=Z0uxU2c1VTYTjnbcUW74OLUjsTLSmwmJdeaNPdCIcdLnlXIXs/C9wv1nPxahOg6q9Q
         4cMIBBISxmqLQh4Vby5dPUlwpkz7tRXK5arSKGuT4MFPSgcofddEud+P0W1uk2kR00Vv
         VzOjgd9MUELxHQy7CAb2SzmZOABKM5OEbRT0soYCcQFUkgi3vinslYD22dd1aI9uAmIs
         gXbV9tsFcxA3VUJsetrh+3Zg1QfjxHjNrjs/HqkBYnC5UbYX2DbAwx/pK42do+pEJhcb
         mlAGcfW3hC0wmj9X9bSWwjAC6PcD6GZ3iMe3NC6L0Eait2Cx7JU6rcMvkbNjzIkKSnt9
         Q+rA==
X-Forwarded-Encrypted: i=1; AL+hErG69JTyaonLlatY+5yie5Xc1wbMHESNyp9h6Ywg0YWhc7FsSNbSQ+/I1uY305c2jqADqIf9w7FBqA==@kvack.org
X-Gm-Message-State: APuU4Z97i2rcyMvMVtXlf4jgPDTds6kXHI8KLF+pwlhPz40N+VyhCFs3
	BfpRXOnBa5b/bVJFwI1Ygz2tywruOFnIWcU2tqHZqXqfUqw9UHcU6S5j7ZnltJjxjkE=
X-Gm-Gg: AYBFou3G7j1ahx6J73RdjNi9kMaaAlQj4GFLU4KAmSvAiRaoxzy6kh6/5ZqoTxuVT6v
	bRipbQtAUpN9vyYungVM+nRjXFhLNnc2KQ47lQhOx0UoOv4AuYaLv/CDM8/gwU92wpPHZH4uyiJ
	iLxl/XsPonaESl5n6ryis5V3l1s6OyUAeE3UQP4q4YxDQzxwNZ/eqn4ZRjlvQ6XRb7UTypNcg+d
	zsfXDVCijW2OqMRTGeU/iiW1XMU+DCJXREuZ5b7wes+VWHbIbbU0tDbvR50QZ2pVQc0LcVS8IZQ
	gIrrO+lYt+kc5SUq/nLQFZEGkG3kOrf8xRkmZW/F7GOQgGQdzuh5Y+YaxqaHAQWKk1VKRJyX3iu
	Rm0AUIrMjdoJ+Jg2B8YCaBpfVeyZrQDzLAafHJeEtVB9PpPeQ9iS04cvV/iBiYEKtB1vverrUGw
	brPGArRiTnV2+txoyKhAR0NIaFD9pmGnOF2E7NnaF2alpAieJ4IMsFSItEfSBPgbYlm6NxymA3T
	EGk54j/Ba+0eyJMLF2GmL6RNEAB8CALP01FRTMUrOCeI4CNJVzs8aH/oOWWs9W2RXHb9qwxi4PD
	0wAuxIIP+XagWoKRYeqV16xVIGE10kpRorgI1/a5c0YYYYJ8Zn1mGtW2FpSlXtwaHhFBlHckYOA
	URx6FJRS+ww==
X-Received: by 2002:ad4:4ee5:0:b0:91e:a5c2:37f7 with SMTP id 6a1803df08f44-91ea97a22b7mr53003846d6.42.1793997792129;
        Fri, 06 Nov 2026 12:43:12 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ea6a2c742sm29232026d6.11.2026.11.06.12.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 12:43:11 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xPQmE-00000007ent-3ktJ;
	Fri, 06 Nov 2026 16:43:10 -0400
Date: Fri, 6 Nov 2026 16:43:10 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
	Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Kevin Tian <kevin.tian@intel.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, iommu@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
Message-ID: <20261106204310.GK663069@ziepe.ca>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
 <n3l2cnx6d25jovloqyoxiz566mh62janclmiewjvumtmqfezo7@zmsmco5vvssn>
 <23f947e2-ff06-426d-adb7-396871304736@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23f947e2-ff06-426d-adb7-396871304736@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4DAF6180003
X-Stat-Signature: ihyc9b3di7oppt6a7muhpzi4bkrzazue
X-Rspam-User: 
X-HE-Tag: 1793997793-343647
X-HE-Meta: U2FsdGVkX1+PlQky+W0XvvC+edufkTGUGh+94YDdMlM8jlB8UaumyYfl2+MS9h89qyX/PM8NpMT6JTp3m551K4Mb2cpVZla5L8FdeSuFTthRlqOO0Gg9Lq+bHtaj2P/nbMdsjIt7vdDuSxumcrylrNhNyNfO/Y3XpLQRo1/9pkoAmXwLPMHFCVMtJe0BlnmfaI6Y6QZ1hm8T71Wwh+b9DOx8Rm7OouyHM2Ns+5/gNtOaSslrOCwuSHKMDLtKIZBklSEq76zC22843ypb6x9KX9G0RmtUpHv2GVc4/zgRaqZvIOcb0KNY9n1asQ75l3A3RVSaeQ75HSlNwpyly/Pmtewl55+Z/MCNH7RN47C6u1+G3rXULJ+0XrBgWh/S1YNv1Smxp+sOLmLP8lQ+uoq3QrGjIY3v4OXOzGhlwD/YeqfxJPPEtbLBpOhMXoQYKAfUs/bc9s9nG5NlrD4lWoG7MqjZKlotWGsgWrc1JbC3lmLIvYKZO31f+wclFzAxnh6zZYT4YpJWjEobnlcFqlXIH2skuTa8/HpqJPo3xX+TYP62vWTBBh6EnMjGJBgqFcPg6v8rG1VZPN7GOnxbPsIP6GZi/SxW+3uaOCCs8xzhr7Of/kPRS+JLK1sHdWnk1HhlAv/kx+KsHa3CAyU28GS9rPtR6xwf02g9Qo/w1jIlGg7+yGvLR0cFzakepK/CuoEU96GmKbbn9kDKyWEG9q3RwMEGzohyYM3eirbbZtbPzh5C6L8BW/x0Y1HHeH0a7V7AAD1REfoWnpW7949pzBblimrvoU3i83KBLnvureukozBvTIgYHQziYmDkTIFRfqUMdhVoZIBA1egh2TV0K6c/d6+qLDzoKCz66XrEaLICTAGTY/MhjKR3LPADxWJwuMm1TniZWDAGlfDKVX0Ry/yB7ukbxrN7hAdxNTp39mW+M8Yx614YiK+wqhaZFcXudkiNZNQA6mWrpVFkmGFTF+t
 B+lyGPz3
 ReS5HgyIumok2J8VrQ70yP+6sosmT6XJ/RVyeFJVICbo4O65iXVsGvn8gYgJAyvu43ActoJbxFpVag58Gw8y2Y/D6X2YOAzzJafT34vq0jo6c5KSFMq8DgY6TD8y8AFUHn8KVwuaLNdRSC7kkW6daYRGIkfGkzksLXH9JXGNNw1OJ4dt1vcx3Iivs9u7bHqjvLSKdbMxupSQdcr/uRgrNCduihxDsgWiv4X0xzox0mP3w1lVtjLoqDMNnjrc3YTJKbduOn6EOixkkrjRAjeFawncFnSNZQmQ5w/tinCbG/si/3RbJAwEUPX6PmsWSK7oGHY/6vrsNsB8kbPx7Vz77qv3tJ6y679Cy5HuBpZQ4+x8cRFSdQMYzaZy8voVdX5v0Lje6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:09:10PM +0100, David Hildenbrand (Arm) wrote:
> On 11/6/26 18:58, Josef Bacik wrote:
> > On Thu, Nov 05, 2026 at 02:10:11PM +0100, David Hildenbrand (Arm) wrote:
> >> Similar to mapping pagecache folios into page tables, let's reject splicing
> >> folios into a pipe if the refcount is at it's limit, similar to how we
> >> handle it during GUP.
> >>
> >> This will prevent more cases of possible folio refcount overflows with
> >> large pagecache folios.
> >>
> >> Let's keep it simple and check in the two callers of
> >> splice_folio_into_pipe().
> >>
> >> Also check in try_get_page() to cover pipe-buffer duplication by tee()
> >> and partial pipe-to-pipe splicing.
> >>
> >> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> >> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> >> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >> ---
> >>  include/linux/mm.h | 9 ++++++---
> >>  mm/filemap.c       | 4 ++++
> >>  mm/shmem.c         | 4 ++++
> >>  3 files changed, 14 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> index 79ae8fc0d6bb4..a82cfbce18215 100644
> >> --- a/include/linux/mm.h
> >> +++ b/include/linux/mm.h
> >> @@ -2287,10 +2287,13 @@ static inline void get_page(struct page *page)
> >>  
> >>  static inline __must_check bool try_get_page(struct page *page)
> >>  {
> >> -	page = compound_head(page);
> >> -	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
> >> +	struct folio *folio = page_folio(page);
> >> +
> >> +	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
> > 
> > Since you're here anyway can you change this to something other than
> > WARN_ON_ONCE, since that results in an OOPS with panic_on_warn set?
> > Thanks,
> 
> If it actually turns negative (or 0) with out changes, we had an overflow and
> for sure want to know about it :)

Yeah, didn't you get Docs merged to clarify WARN_ON is fine if
userspace can't trigger it?

If you use panic_on_warn you *WANT* your system to stop if it detects
corruption, that's the whole point. Removing corruption detection so
panic doesn't trigger is pure 100% nonsense.

This keeps coming up and it's frustrating to go over again and again.

Jason

