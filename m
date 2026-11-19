Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2F9606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z+JKqeSH
Received: by kanga.kvack.org (Postfix)
	id 59D086B05F8; Thu, 19 Nov 2026 04:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E1D6B05F9; Thu, 19 Nov 2026 04:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464846B05FA; Thu, 19 Nov 2026 04:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9D36B05F8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:43:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9445714094E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:43:39 +0000 (UTC)
X-FDA: 85451381358.08.409EEE0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81E3EA0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:43:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z+JKqeSH;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795081418;
	b=DlpV7fHdCEpmYEjQ8s1esVOowMHB9cAJuteCotlCYZCgVNoHVQdh7D1bjJWzmlZxPkIFPO
	46RBiBk2PjFk3hBuauftoXB6eVKStgnjvG/yxtRSLmV0uqhg8g5AyS2b0EtgtdDNSmlsFE
	fC7ApE3SbmPtjyNxx2Crj9Z8IERsJDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795081418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Ftv5ohlhONZ/yV4mvsRDwnVdXpNIjyErplRrdF7F4s=;
	b=24ffuK3s4yLH/KvIek3my0QVCyV5X0F6m8II2EOhISEP0jH1X303fgbuxWaJP0kU4/rxxT
	KgZjLM3EV+gQDXhNZWpP8f4AwWOUvfHrSdvjkFfOo/If731oQYvNkpbamJpabzUpyDgYPL
	sWxEwA+uWtCbhvcDJdol5AMjY/rLpNY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z+JKqeSH;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8611B1575;
	Thu, 19 Nov 2026 01:43:33 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 019EE3F882;
	Thu, 19 Nov 2026 01:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795081416; bh=sSQ2QhhUSs69+oHeCq7tqoe+5F8pEeWToCcaQfTg/Bw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+JKqeSH7mlb/yir8Memf0lOOD1DP5+CGVbkXwtHuiXgfIezHWEuwjY4iypaGvt49
	 3XwCieSPiNCi9PzFQQgdvIfUJXJPOzNDHEEdh5RsY+rrFOa0/C886+Wfa5lnZjkHTt
	 8y6mWryJ6LKvgsg918NaCBLgfmR/QV4ctgzWe44E=
Date: Thu, 19 Nov 2026 09:43:31 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: harrison@crosse.dev, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/gup: make mlock() and MAP_POPULATE handle
 VM_FAULT_RETRY properly
Message-ID: <av7EwyB0V8DFqPzG@e129823.arm.com>
References: <20261118-mmpop-populate-v1-0-9c561d178d11@crosse.dev>
 <20261118-mmpop-populate-v1-1-9c561d178d11@crosse.dev>
 <e32482de-295a-4e26-b6ae-5b8b58f8b98c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e32482de-295a-4e26-b6ae-5b8b58f8b98c@kernel.org>
X-Stat-Signature: grjr7f36bodiw7iqco1ya9tqfjhhifa1
X-Rspamd-Queue-Id: 81E3EA0005
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795081417-748853
X-HE-Meta: U2FsdGVkX195Qt5DTZ0FAkp/ktPUqRWApx7x/k6MN96qS8KPehVgafmveTH9IqfoyeJsUn4Nxmft1i9WJOYtyhDkl5zzRvt4Zpb9NG7tjGC1edzPj8ZMYLNSQXx8QGPt2Tr2+atvBTaBuMVFt3ZlzuY8vUAjZPfr5t5q+FBrlqk3bf+OQDSN6bAQvP7YB0Gj1dNpUsmLDUlZHX54kfl1/v5V2fajIq7SEI1n8Ze8jdw5gw8XHQSpJmUT6OVeb3RkEfg3q3U5E1TzNsaYfZSmF7ZpJaEijk//QAZe9r4jrYJ75Ym2YM3GHSwsnOo9TW9TjEBGdhmlDRVQPT755m1f/FoLDO2ER+Vmq1PXrKpuajoA4E+ZJCuG5GJqstOwn61o1NDRIRcUkwUJkOeAEosRebdYLPmBeOgCAGDijTI3EFYRA/c8XRKnUQTm4812NOS6UMAWAztGPPMxTHUSS+nY7RXRYDz2/pEu6s/36sNnEQwS5h2xcjo6RbknrDTNmbNkm1XMrpYbpPaLssJ4Mft7KRbA+rZIH20X1wPQ0oeMtZ5Og79NRRyChEjSCRWyVp7uV42RRiqAZaAHTGILV8SwY3Aj2NrPCyNIfAfbjF5NiC9ETWwferC8lnW0pY2pVHycvl20ZOj7Hsbtw2VwSr8oO0SsyhegrKXGOvRsqiPmHMaOlY18564xi0a+TiOm0zSV0fMXMtQbANe5CsWonVxjfZcbNapsxZRE08uEIOM6ZgMS5RGpAecC9o7AWie1BLH8hRvFD//vKTjaDePcMaXhqCJ21hSzS9+b1WgXTL8O7abN/beApSRP9mXViVapTR5fuFgXMvRMD35KGCNsRNxSo8Uv4yw2mMhCk/Jf30nyBBgu4cUkCIjrwLlDPQGN9utVk94FwTdbUIfvjrTeuUEyDo7dHGPNI++obMRgrq+ONfzS2NW5BXVNTzY2iBT1DMEoF4P7qw2IKgIxvX4lAgP
 av+XFlg7
 +f2LB9Z7jxDzSyt6GjeWh4sZeEHeabC1DR3ksFxF09Y4EoYAlMaD46048tpJ5vzLz0cIp9S/Y4xGhk+NTVGcXdGh37tZxFJt01LDdbT/Gxdz/+pesUvHh9Sv5ubGglurGVReM6CE3a7gMIEAV1oHpedXoC8R7Qr4pGTCvwuiwwA13SRtvM2Ou3zRYYCXXBAaLlhL8dCQQPwh2MmefjJ+FkIpXxyW/LgfH1vVKjJkpBG3JQHDwWArpc352WKA1/51T4fy2X6gNO2MRIYx9/h5LlTPR3j8gNWipZ2+OFhRhtBvhq3wXbc3ZmEahrZTNUzfHAAA2M7UUSwvRoSAjqdlArYIlwlVOukhgSirns07BRRcNe8lqomKokDFtyxJv8iWmkQXC+D5k8+YVi2SL+cByM/nH7LsoygK86VwzrjaRJmb4x54NlMD2+mYD1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 12:25:31AM +0100, David Hildenbrand (Arm) wrote:
> On 11/18/26 22:56, Harrison Crosse via B4 Relay wrote:
> > From: Harrison Crosse <harrison@crosse.dev>
> > 
> > If every read of a page of a file mapping fails, mmap(MAP_POPULATE)
> > and mlock() of that mapping do not return: the task spins in
> > __mm_populate(), submitting a new read of the page on each iteration,
> > until it gets a fatal signal. Touching the same page gets SIGBUS, and
> > madvise(MADV_POPULATE_READ) fails with -EFAULT.
> > 
> > The first fault on the page reaches filemap_fault() with
> > FAULT_FLAG_ALLOW_RETRY and without FAULT_FLAG_TRIED. filemap_fault()
> > releases the mmap_lock to read the page and, because it released the
> > lock, returns VM_FAULT_RETRY before it looks at the result of the read.
> > It cannot report the error then: a fault that has released the lock
> > returns VM_FAULT_RETRY or VM_FAULT_COMPLETED, and neither carries an
> > error. faultin_page() turns VM_FAULT_RETRY into -EBUSY, so
> > __get_user_pages() stops at that page without an error, and
> > __mm_populate() calls populate_vma_page_range() again at that address,
> > again without FOLL_TRIED. The page fault handlers and
> > __get_user_pages_locked() retry with FAULT_FLAG_TRIED instead, and on
> > that attempt filemap_fault() reads the page with the lock held and
> > returns VM_FAULT_SIGBUS if the read fails.
> > 
> > Commit 631426ba1d45 ("mm/madvise: make MADV_POPULATE_(READ|WRITE) handle
> > VM_FAULT_RETRY properly") fixed the same loop for MADV_POPULATE_* by
> > calling __get_user_pages_locked(). That does not fit here:
> > __get_user_pages_locked() retakes the mmap_lock itself and carries on
> > with the GUP flags it was given, while populate_vma_page_range()
> > derives those flags from the VMA that __mm_populate() looks up again,
> > and may skip, after each unlock. Retrying with a NULL locked instead
> > would drop FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_KILLABLE, so a
> > userfaultfd range would fail rather than wait, and folio lock waits
> > would not be killable.
> > 
> > Instead, have __mm_populate() remember the address of the page whose
> > fault released the mmap_lock. When the next iteration starts at that
> > address, fault in that page alone with FOLL_TRIED, as
> > __get_user_pages_locked() does, then continue with the rest of the
> > range as before. The retry reads the page with the mmap_lock held, as
> > filemap_fault() did for a page that was not uptodate before v5.1, and
> > as the other GUP retries do. With a persistent read error the retry
> > fails with -EFAULT: mlock() returns -ENOMEM
> > (__mlock_posix_error_return() maps -EFAULT to it), and MAP_POPULATE,
> > which ignores populate errors, returns the mapping. A fatal signal
> > still ends the loop, with -EINTR from __get_user_pages() or, if it
> > interrupts the FOLL_TRIED read, with -EFAULT. The other callers of
> > populate_vma_page_range() pass a NULL locked, so they cannot get
> > VM_FAULT_RETRY and are unchanged.
> > 
> > Reproduced with ext4 on dm-linear over a loop device, with the eight
> > sectors of one page of a file mapped to the dm "error" target, on arm64
> > (Debian's 6.12.116 and v7.4-rc3) and x86_64 (v7.4-rc3): mmap(MAP_POPULATE)
> > and mlock() of the file were still running in the kernel after 5 seconds
> > and ended when sent SIGKILL. On 6.12.116, the block layer tracepoints
> > showed about 280,000 bios a second being submitted and failed.
> > 
> > The analysis, the patch and this changelog were prepared with the help
> > of an AI coding assistant (Claude).
> 
> Yes, that's rather obvious from looking at it, thanks for documenting that :)
> 
> Thanks for the report!
> 
> [...]
> 
> > +		 *
> > +		 * filemap_fault() reports a read error only when
> > +		 * FAULT_FLAG_TRIED is set: on a first attempt it releases the
> > +		 * mmap_lock for the read and returns VM_FAULT_RETRY whatever
> > +		 * the result. So when the last call released the lock at
> > +		 * nstart, retry that page with FOLL_TRIED, and only that page,
> > +		 * so that later pages still get a first attempt that releases
> > +		 * the lock for the read. Compare the address because nstart
> > +		 * moves past that page if it is no longer mapped, or its VMA
> > +		 * is skipped, when the lock is retaken.
> >  		 */
> > -		ret = populate_vma_page_range(vma, nstart, nend, &locked);
> > +		tried = retry && nstart == retry_addr;
> > +		ret = __populate_vma_page_range(vma, nstart,
> > +						tried ? nstart + PAGE_SIZE : nend,
> > +						&locked, tried);
> 
> Yeah, that's quite the ugly code. Let me take care of this (or find someone more
> familiar with that code that can help).
> 
> @Yeoreum, do you have some spare cycles?

Yeap. I'll take a look soon!

-- 
Sincerely,
Yeoreum Yun

