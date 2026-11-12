Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C95B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/9czcKj
Received: by kanga.kvack.org (Postfix)
	id 2DAA46B05BA; Thu, 12 Nov 2026 11:50:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264936B05BB; Thu, 12 Nov 2026 11:50:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1061B6B05BE; Thu, 12 Nov 2026 11:50:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF2F06B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:50:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FF6514039F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:50:08 +0000 (UTC)
X-FDA: 85427054496.15.3DBFACA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C647E80005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:50:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/9czcKj";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794502207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcN09gsgAs2Ff3t7W84Nu6Qih9q/psMVcrup6/u4Mb8=;
	b=sMA2FJTxHKvizsOo0uR6gLO8YQRtiTl1CuwiCAvaAN7IHbmARRxWJ/v7O/HWOOf54Q2WCK
	j8KdjUp8QqU+HaT/dAjHMYTqQqIMEUzGeXLJOSbVv3mdnLfha9hsO0hEp2EkOiGbIK8W+b
	aVjkBC7/KwJtvG7113PWSE7GmSFx0k8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/9czcKj";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794502207;
	b=nDYrboF1bRM8wpULnx8kEPHIghZi30x0Hsy16xzOhGppJHZUJbx8LqpQRD/fltiPHXDkbT
	m4rzIcqyY8gJJe4WIzB4CbT4KEaN4YXExnVtKwsVzGuskwXFHUxGhZmoju+5pnVEBawmyQ
	sC43c6JkrMbFciMo+A6JuipMb56QOEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D2CD40060;
	Thu, 12 Nov 2026 16:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1661F000C4;
	Thu, 12 Nov 2026 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794502205;
	bh=AcN09gsgAs2Ff3t7W84Nu6Qih9q/psMVcrup6/u4Mb8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=W/9czcKjc212sPdhIyrx1NDyBKYyPPRS27FVKM/1YECl6e+INBhZ8lwiXJw/0PD0C
	 yvm9HXsHdRjXkX9jxfHpSGpkQLE4ZHcUSVMisCsBBtrAhip7HSmlWRU6SkJk1tZauH
	 vckQ8/eh3RZyd3mD9o9PbLleTigE7S33mitpROx+eYBbjeK6o+wS/OJ/Ap2ypHXB3Z
	 fCaDj4oC4JFFSUy6kIY4loUbWtVDYSgPXYyWsB18EaNkcc43JJQDp5dVi1NCaPnlWW
	 ycuPRKf6HDqbrcEyvmAiJ09mRF1hLuZcy5Tko/7PNAiAyhZORNcHT7iJ5+PVmKaIBB
	 kubrpP4ayRa6Q==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	media-ci@linuxtv.org
Subject: Re: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
In-Reply-To: <sashiko-outbox-199539@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-2-aneesh.kumar@kernel.org>
 <sashiko-outbox-199539@kernel.org>
Date: Thu, 12 Nov 2026 22:19:41 +0530
Message-ID: <yq5ay0aygfkq.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C647E80005
X-Stat-Signature: qf4iqk1apdygatcu7croiczeu8kaffzq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794502206-406629
X-HE-Meta: U2FsdGVkX19n8aNmjQDkryeo0VSBpozk0uAwjX4s2Ayeo6Zk2BGNFIwSXSj0HR31gHyGlzX2xLz6SoEZnx24W7CxnVDsGidjzzOZS9efis20CJG2MCl9Hew3P5x9zj93Y6G0gmUuZH7mLNiysFoSWz0aG39QSKBNDrsCE5AY+u35O+KWbdblQA2b3Ns+vm5MGJBoQxPrzIghPX5SpV9YBXWz7ARj4gmh5/b1Pdyq8n0FBMxcUTctGx3NilX73bFGf4A0wgBB0Dz7KVap98ycQ4SdaiN37w/Slur7kj9u1GPqAJclh4nijAy+wlikC3yF2NpYaKCXzpiSRsHIJWW8jF3DD07qlsxB2Frl8XSe/FpsGSlqrr0Z6STOGSuB73+WWh/4xMzY8eV2oJk6ncXwshdDgifFJ4gYOboxf4MVOwCG27WhDg25wyPJhY+uKxOjWSU+/QTHVOzyPZl/+okK0gQ3eLOCXbGXGD1nRXbfqRM0xe/gkI9q3YbNMkhnfVBaMG37GXDn09xx40nG7xbxsOE3OkBnBJkJavIbDlFravQHu5AzEaa52ViC8RVKcVhUQAxui6misgJtB2t7nLXSBk4hWacXAp9axR52ngHusxZ7l+Lxo9vAko/4gSPIfpe2JzxpZDhl3cA+yR9oUDnCqxS+2eAbQBe793/goppsgV7Cjf/QUpSWKJVbiZgKSPa6NFTEZ+kUceelxrlwpvbw7xu724cclcOJ5mk81/ZMlPuEYm0rv32ZudY1BDKQxoqomad61TlEL9b0R7Pvpkkylrv47gGGC1vi4cBR8LSd4UpvINbf3qmawJK99GlS/iZFFiWpBx11aUrIaGcbE/dRcpuYTWNhyfPiDqi5THu7oeMtge/WkJ5saOFgpIRGC5CDtQzOE48fMAUBF8VB+0UfOJFaEIpKFk4ySXCKiOEIZpsXHTB7lPICFNWmeKfR3/MEqf4GK+eqcWRTFuf8PoM
 BWesBafr
 akxn3v+3hgYnObyxV2HEk2Clv0F+Gs+YdM0TX9uJM6gJLeu5Z8NLJijBPShmKU7iOlMR3bIWztZpUNVwJr6BQ8qM/kRnoNwVMIn3TICADA0xhJtnJQgYuStr3Lr5AOFOb22wOpRIX4aknpA0PWokKxvmTyccCqi/oAI1I+fsEHlcTr6XrUtYYr3KX5Vjs9B+iUknShuRC4UVbFm+8r187dXsXSb0LD6CgIfjYTZq4vWfK4Epehg6TDASzZA+5aBNwSLGcUXTTlpoH/rimAB0vvW8b9N/zTIkoQCYOaKs8Z7F/EtTijhZzcupkhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm: invalid cc_make_private() call on cc_make_shared() failure
> --
>
> commit 8a434c0ee7399613dbf060530383d80bbc1ab7af
> Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>
> mm: Add an allocator for CoCo shared memory
>
> This commit introduces a common allocator and transition helpers for
> confidential-computing shared memory, including alloc_cc_shared_pages(),
> alloc_cc_shared_pages_node(), and free_cc_shared_pages().
>
>> diff --git a/mm/cc_shared.c b/mm/cc_shared.c
>> new file mode 100644
>> index 0000000000000..5c4c971cfb7b2
>> --- /dev/null
>> +++ b/mm/cc_shared.c
>> @@ -0,0 +1,233 @@
>
> [ ... ]
>
>> +static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
>> +					size_t requested,
>> +					struct cc_shared_pages *mem)
>> +{
>> +	struct cc_shared_layout layout;
>> +	struct page *page;
>> +	unsigned int order;
>> +	bool zero = gfp & __GFP_ZERO;
>> +	int ret;
>> +
>> +	ret = cc_shared_calc_layout(requested, &layout);
>> +	if (ret)
>> +		return ret;
>> +
>> +	order = get_order(layout.shared_size);
>> +	if (order > MAX_PAGE_ORDER)
>> +		return -EINVAL;
>> +	/*
>> +	 * State transitions require a linear-map address and may modify memory.
>> +	 * Allocate from low memory and defer requested zeroing until afterwards.
>> +	 * Shared allocations have no migration support, so they must not
>> +	 * be allocated with __GFP_MOVABLE.
>> +	 */
>> +	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO | __GFP_MOVABLE);
>> +	if (nid == NUMA_NO_NODE)
>> +		page = alloc_pages(gfp, order);
>> +	else
>> +		page = alloc_pages_node(nid, gfp, order);
>> +	if (!page)
>> +		return -ENOMEM;
>> +
>> +	ret = cc_make_shared(page_address(page), layout.shared_size);
>> +	if (ret) {
>> +		if (!cc_make_private(page_address(page), layout.shared_size))
>> +			__free_pages(page, order);
>> +		else
>> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
>> +					    layout.shared_size);
>> +		return ret;
>> +	}
>
> [Severity: High]
> Is it safe to call cc_make_private() across the entire layout.shared_size
> range when cc_make_shared() fails in __alloc_cc_shared_pages_node()?
>
> When cc_make_shared() fails via set_memory_decrypted(), the pages in the
> range may not have been transitioned to shared state at all, or only a prefix
> of the range may have been transitioned.
>
> For example, on x86 TDX in arch/x86/mm/pat/set_memory.c and
> arch/x86/coco/tdx/tdx.c:
>
> __set_memory_enc_pgtable() {
> 	ret = x86_platform.guest.enc_status_change_prepare(addr, numpages, enc);
> 	if (ret)
> 		goto vmm_fail;
>
> 	ret = __change_page_attr_set_clr(&cpa, 1);
> 	...
> 	if (ret)
> 		return ret;
>
> 	ret = x86_platform.guest.enc_status_change_finish(addr, numpages, enc);
> 	if (ret)
> 		goto vmm_fail;
> }
>
> tdx_enc_status_change_finish() {
> 	if (!enc && !tdx_enc_status_changed(vaddr, numpages, enc))
> 		return -EIO;
>
> 	if (enc)
> 		atomic_long_sub(numpages, &nr_shared);
> 	else
> 		atomic_long_add(numpages, &nr_shared);
>
> 	return 0;
> }
>
> If set_memory_decrypted() (enc = false) fails with -EBUSY on mem_enc_lock or
> with -ENOMEM in __change_page_attr_set_clr() before
> tdx_enc_status_change_finish() is reached, the pages remain private and
> accepted in the TDX module, and nr_shared is not incremented. Calling
> cc_make_private() (set_memory_encrypted(), enc = true) then invokes
> tdx_enc_status_change_prepare() -> tdx_accept_memory() -> try_accept_one() on
> already-accepted private memory, which fails and jumps to vmm_fail in
> __set_memory_enc_pgtable(), triggering a spurious WARN_ONCE and leaking memory
> that was never shared.
>
> Conversely, if tdx_enc_status_change_finish() fails during cc_make_shared()
> before atomic_long_add(numpages, &nr_shared), and the subsequent
> cc_make_private() call succeeds, tdx_enc_status_change_finish() will execute
> atomic_long_sub(numpages, &nr_shared), underflowing nr_shared and corrupting
> the accounting checked in tdx_kexec_finish().
>
> Similarly, on arm64 pKVM in drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c,
> pkvm_set_memory_decrypted() shares pages one by one and stops at the first
> failing page, leaving the remaining pages private. Calling cc_make_private()
> across the full range then invokes KVM_MEM_UNSHARE on private pages, which
> fails with -EPERM.
>
> Other callers in the kernel (such as dma_direct_alloc_pages(),
> atomic_pool_expand(), and swiotlb_init_late()) do not call
> set_memory_encrypted() when set_memory_decrypted() fails, and instead leak the
> pages directly because the transition state of the range is unknown. Should
> __alloc_cc_shared_pages_node() do the same here instead of calling
> cc_make_private()?
>

Yes, I agree that we should do this. Something like:

modified   kernel/dma/swiotlb.c
@@ -748,14 +748,9 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 
 	vaddr = phys_to_virt(paddr);
 	if (cc_shared && cc_make_shared(vaddr, bytes))
-		goto error;
+		/* leak pages on error */
+		return NULL;
 	return page;
-
-error:
-	/* Intentional leak if pages cannot be encrypted again. */
-	if (cc_shared && !cc_make_private(vaddr, bytes))
-		__free_pages(page, order);
-	return NULL;
 }
 
 /**
modified   mm/cc_shared.c
@@ -133,11 +133,16 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 
 	ret = cc_make_shared(page_address(page), layout.shared_size);
 	if (ret) {
-		if (!cc_make_private(page_address(page), layout.shared_size))
-			__free_pages(page, order);
-		else
-			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
-					    layout.shared_size);
+		/*
+		 * A failed transition may leave the range partially
+		 * shared, with no indication of which pages changed state.
+		 * Converting the whole range back to private is not safe
+		 * on architectures that cannot handle pages which are
+		 * already private. Leak the allocation rather than return
+		 * pages with uncertain state to the allocator.
+		 */
+		pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
+				    layout.shared_size);
 		return ret;
 	}
 

