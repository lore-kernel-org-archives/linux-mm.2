Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102AA606A330
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mgpMkxzh
Received: by kanga.kvack.org (Postfix)
	id C987E6B0A29; Wed, 25 Nov 2026 09:15:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49716B0A2B; Wed, 25 Nov 2026 09:15:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F536B0A2C; Wed, 25 Nov 2026 09:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDF46B0A29
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:15:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1601D1C44B0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:15:11 +0000 (UTC)
X-FDA: 85473838422.27.55E684D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 23B3616000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:15:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mgpMkxzh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795616109;
	b=wotdky4r/erK5RxeMuph4Ptk2NvSQFlmXnXkuVdFD/f7AhjSmi/SzbpwwkZqPVs9nKpXuO
	Y4aaEI+K3+PoDPSfQ5Ak6M3FYSGa0k3+xzT4fSnOT1xYYmCN0d1145NC3bsrCQm7E/eJV7
	mOQwde0zS0FQhW2yTF16n40LdNMSDOo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795616109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/+qYvyLZHeG1kOykHPXzeEZDLRzhRfnNwJtUaDjUd4=;
	b=1YKwH9V3ytJqSt5ocFmTl6mRKzTJkEmX/6VN1in2+n+DRwhvxLecWg9GK/iCWXjJ5xUVZz
	Sjy8KiNq/0hiB8V26T++jZ72iJKd+LTphTHvbaHYBbO/jCn0M660GPdklVx9NhJuZvDtaj
	CGqPkAcqtnSh6HtbosdcmUq/s1vORV0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mgpMkxzh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 213FB339;
	Wed, 25 Nov 2026 06:15:04 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 150F23F763;
	Wed, 25 Nov 2026 06:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795616106; bh=bW3E4SbeYQhH2zRyHlW+z0xxKv0+xWnfrGDaIYNZ9II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mgpMkxzhZM1KtRa0AA6hXuxobdOzkN0nHaqk3xtbg2XuiZUU6TszYdViptBjz1Wqn
	 5L8+m00c5+r2Zxd3X+FB+f1zGxRUtVudw2fBrvZqnI9Iqmvo4NnNCdJDztOObwioJk
	 3dDIyGxa18ywS6pLGCjd5en3pKT+ICHWU83IFkrw=
Date: Wed, 25 Nov 2026 14:15:02 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>, linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private
 migration
Message-ID: <awbtZjtII9h1oJ5R@raptor>
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 23B3616000F
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u775tdidp3mm5ncdzxn1dro8adwsh9e6
X-HE-Tag: 1795616108-520962
X-HE-Meta: U2FsdGVkX1+DtuQnJmlnOCMKGxs0zMZ2DI3bYwcXCfDVGBCwULT2b2DbtOM76E+kH7aLpM/8FMgzE8zTQiGtso9Aml1u5VvjSP7TdclGJbFddGPg7D9N43KgkJX45R+3T/Y6bgBj7JnrBb6zrmQ/s6s+H7Sf0w7zOPW+y7lslL7Ae312WDpBKzKQ3MI5MY3+lp4h/4vj8m7ELvLCudQSAvnWCLFG5gqF0o0HGOdmuV0BRaqe8V97hZxechjQgmTpLugFdJYMtA75A0+YEMaFJDd+0F/Ptz55qCpz3Sr1PdTuD5345UN9tvCUDXe9umtcfTqQHpSkzBkGFnMMMpRBfRVcMafC2eaACvG/wQCeHavzj4DUdcmG0mp7zVMnaUNrIayHgS5wEAG2ZeN0UskKm9tv3DJbjvXSTGTa/5OmyBC2GIqqqKANRRVKY3RFEXPxGP1/jihFKGODDFTN++qjRXomcRPhdxQ9/rq8ce1l6bO392ITsR5NqHf2p1bUhFuzDGteACQSjmQuUIJeAC7k7lI9c3BE1DVYKQ66//ad8myHYN5ComaE/zi4BQ0hW0sm5+2xl/sW6KrPRG92eGN+gxVJzxzydK5uSy4EbwAGHnXdd2WUjHQoJIwjcW7o5bNnjx8HwwXUUf8S3eCd3uaUvc66j0x0mYbklzx4KFqk1Z7gkVj8EF3fk75ZJ7hIKcmIeuYotP7L3oi7Uce2941t8Ue93XDXuQnwk7wMmYtE7Hrayyj/r+I6GYHanwYJXJeQruRM8sjRhyDYteBA0Uknp44/QSiXc9PLM4h9gLIND9YlIXkRphrJyKRpwAaXsgEnm1OewbyeQgQiBB1B6u7/OB6LjqWhN7PtSjYM65B2I3KDdb6JJ0Wq2f/sBBkGaMLfjCFqgj3xtQIApw+JTmtqVCO/u0JP2LJzPQu+JMHoxjglqpTtEhPdWl/Mktok4PieolSA8DWBmvsxn6hCmwV
 lu1b5qal
 HgFcStKOIl/6zZVvfEUPczanrFbwm3u+KKvRnoRZw7OsG2ZfIPvPuaZL8cfUHK/J95dgI/BX5Q0k7MMEBW/aKbTosBuUAPU+v2PBcmwDXPhVzomKQjk7sUmgI/zPjX0F/QQIMywvHh4O1SgvjxToTwVz9bMusu/TsEob3LEwAUc3qjN5xeEkoqAzsGoCUNoM8PpIq54Z2DRv5byfOTZAInvj4DgcQyiJF2htUV/hRETEukgOZeH5eWIlX/tsWPDrRQoRF7tUQFBusE6C3Rpt4pWXIi4TlTygV6SXa5T/wBU58vLPOxeIhpQPqIrKg2z9RmxEjlaXcAfpiyEYvpv+yvhiv4p93pbdtU5+jxfpIUKBtoBSx3immSbFAPTcb8Ze2ZaM8UN4TGth+rvb3klzkwMAuWj3GEEGm2OR1gUwJSPj4tG5z/MRzKpP/o9HDUfs8qDbmFnbGG02aXHX445PCjr3n6bdLPdHEfM0leE1u5Aynnho/Z/tdTMdP9DpWfzMrr4sXCMFXbIciqcv9uCnf1RYJnnp6NNbCcO3FIyrcHC5u1FkeaC/8k98cz2PhieGlGXVLNPArD2ILHmJhjGJ33Ys1qSz3mB94/64khv0RojIEP6lZiah2XbFYB41lxq6blPxSrma7MxeH9b09PapQT1DQwv5sl6OWqlcSlOz2d5ccT2Cfk4+SWa6f5NootjsQRuBj1B8aUKFrMTEl3W7lzzF4JJQYRsKRK1+QCMI+AmNMezcMBBVRgb1fWaknH9Kul12OhN784hZtUSckTdFIN6FC4R7xrBGUoyLm2I4oELsLrRbTpP91fFrDVvyDfza/BMKkESGZo+7LPwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

I tried to test this patch, applied on top of v7.4-rc4.

With the changes to the migrate_anon_huge_fault test, but with no changes to
lib/test_hmm.c, to see if the test fails without the fix to the kernel, I get a
kernel fault:

[   95.571212] Unable to handle kernel paging request at virtual address ffff7fffdfe00000
[   95.571221] Mem abort info:
[   95.571223]   ESR = 0x0000000096000004
[   95.571225]   EC = 0x25: DABT (current EL), IL = 32 bits
[   95.571228]   SET = 0, FnV = 0
[   95.571230]   EA = 0, S1PTW = 0
[   95.571231]   FSC = 0x04: level 0 translation fault
[   95.571234] Data abort info:
[   95.571235]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[   95.571237]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[   95.571239]   GCS = 0, Overlay = 0, DirtyBit = 0
[   95.571242] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001cc71d000
[   95.571245] [ffff7fffdfe00000] pgd=0000000000000000, p4d=0000000000000000
[..]
[   95.692002] pc : __pi_memcpy_generic+0x110/0x230
[   95.696623] lr : dmirror_do_read+0x7c/0xf0
[..]

decode_stacktrace.sh says that happens in lib/test_hmm.c:503.

This looks more serious that the use-after-free that KASAN reported.

With the changes to the test and to the kernel, I get this error when running
the test:

$ sudo tools/testing/selftests/mm/hmm-tests -r hmm.hmm_device_private.migrate_anon_huge_fault
# [INFO] detected hugetlb page size: 2048 KiB
# [INFO] detected hugetlb page size: 32768 KiB
# [INFO] detected hugetlb page size: 64 KiB
# [INFO] detected hugetlb page size: 1048576 KiB
TAP version 13
1..1
# Starting 1 tests from 1 test cases.
#  RUN           hmm.hmm_device_private.migrate_anon_huge_fault ...
# hmm-tests.c:2156:migrate_anon_huge_fault:Expected *(int *)buffer->mirror (0) == (npages - 1) * self->page_size / sizeof(int) (523264)
# migrate_anon_huge_fault: Test terminated by assertion
#          FAIL  hmm.hmm_device_private.migrate_anon_huge_fault
not ok 1 hmm.hmm_device_private.migrate_anon_huge_fault
# FAILED: 0 / 1 tests passed.
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0

Might be something on my side? I'll investigate further, but I'm not very
familiar with the code.

Thanks,
Alex

On Tue, Nov 24, 2026 at 10:53:38PM -0800, Andrew Morton wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib/test_hmm: invalidate all mirrors on device-private migration
> Date: Sun, 22 Nov 2026 08:53:12 -0800
> 
> When one open of the fake HMM device migrates a folio to device-private
> memory, a second open can fault the same address into its mirror page
> table. The second mirror then stores the inaccessible device page, which
> can oops the kernel when dmirror_do_read() copies from it. Store the
> corresponding RAM backing subpage instead.
> 
> That conversion also makes the backing page's lifetime significant to
> the second mirror. migrate_vma_setup() notifies all mirrors before CPU
> faultback, but dmirror_interval_invalidate() skips the notification for
> every open on the same device. The faulting open clears only its own
> XArray entry. The other open can read or write the backing page after
> migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
> and stale data through the second open.
> 
> Handle migration invalidation for every mirror under its mutex. This
> clears pointers before faultback can free the backing pages and waits
> for an active mirror read or write. During system-to-device migration,
> the migrating open installs new entries after migration; other opens
> refault on their next access. Remove the now redundant XArray erase
> from the faultback copy loop.
> 
> Extend the PMD migration selftest to read its last device-private
> subpage through a second open, then fault it back to RAM, change it,
> and read the new value through that open. The trigger is available to
> a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
> enabled; it does not depend on physical GPU hardware.
> 
> [akpm@linux-foundation.org: fix device-private backing subpage selection]
> Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org
> Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-reply@b4
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Aveline Noir <jm5905938@gmail.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Mika Penttil?? <mpenttil@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
> 
>  lib/test_hmm.c                         |   20 +++++++-----------
>  tools/testing/selftests/mm/hmm-tests.c |   25 +++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 12 deletions(-)
> 
> --- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
> +++ a/lib/test_hmm.c
> @@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
>  		page = hmm_pfn_to_page(*pfns);
>  		WARN_ON(!page);
>  
> +		if (is_device_private_page(page)) {
> +			struct folio *folio = page_folio(page);
> +			struct page *backing = BACKING_PAGE(&folio->page);
> +
> +			page = backing + folio_page_idx(folio, page);
> +		}
>  		entry = page;
>  		if (*pfns & HMM_PFN_WRITE)
>  			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
> @@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
>  {
>  	struct dmirror *dmirror = container_of(mni, struct dmirror, notifier);
>  
> -	/*
> -	 * Ignore invalidation callbacks for device private pages since
> -	 * the invalidation is handled as part of the migration process.
> -	 */
> -	if (range->event == MMU_NOTIFY_MIGRATE &&
> -	    range->owner == dmirror->mdevice)
> -		return true;
> -
>  	if (mmu_notifier_range_blockable(range))
>  		mutex_lock(&dmirror->mutex);
>  	else if (!mutex_trylock(&dmirror->mutex))
> @@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
>  
>  			src_page = pfn_to_page(page_to_pfn(spage) + i);
>  
> -			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
>  			addr += PAGE_SIZE;
>  			copy_highpage(dst_page, src_page);
>  		}
> @@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
>  	}
>  	migrate_vma_pages(&args);
>  	/*
> -	 * No device finalize step is needed since
> -	 * dmirror_devmem_fault_alloc_and_copy() will have already
> -	 * invalidated the device page table.
> +	 * The migration notifier has invalidated all mirror page tables
> +	 * before the backing pages can be freed.
>  	 */
>  	migrate_vma_finalize(&args);
>  err:
> --- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
> +++ a/tools/testing/selftests/mm/hmm-tests.c
> @@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	void *old_ptr;
>  	void *map;
>  	int pagemap_fd;
> +	int fd2 = -1;
>  	int *ptr;
>  	int ret;
>  
> @@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  		}
>  
>  		close(pagemap_fd);
> +
> +		/* Read a device-private subpage through another open. */
> +		fd2 = hmm_open(variant->device_number);
> +		ASSERT_GE(fd2, 0);
> +		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
> +		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> +		buffer->ptr = map;
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, 1);
> +		ASSERT_EQ(*(int *)buffer->mirror,
> +			  (npages - 1) * self->page_size / sizeof(int));
>  	}
>  
>  	/* Fault pages back to system memory and check them. */
>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
>  
> +	if (fd2 >= 0) {
> +		/* This open must not retain the freed device backing page. */
> +		ptr[(npages - 1) * self->page_size / sizeof(*ptr)] = -1;
> +		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
> +		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> +		buffer->ptr = map;
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, 1);
> +		ASSERT_EQ(buffer->faults, 1);
> +		ASSERT_EQ(*(int *)buffer->mirror, -1);
> +		ASSERT_EQ(close(fd2), 0);
> +	}
> +
>  	buffer->ptr = old_ptr;
>  	hmm_buffer_free(buffer);
>  }
> _
> 

