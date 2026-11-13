Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EA2606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBTNmNHO
Received: by kanga.kvack.org (Postfix)
	id 6D08B6B0642; Thu, 12 Nov 2026 22:12:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8746B0644; Thu, 12 Nov 2026 22:12:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596BB6B064E; Thu, 12 Nov 2026 22:12:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDB96B0642
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:12:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24AFCA8CFC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:12:36 +0000 (UTC)
X-FDA: 85428623112.14.3E31BB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 76ED580002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:12:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBTNmNHO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794539554;
	b=NzBaQ6oAbDDyrzkCjNDOgEScuBOEEbFC5UGWcjwR1UHgx52FcuE7vs+icXOTL5R5BMrhDq
	rEHBEMZTGth3IIa71pJrCm3hURBRQy3HLBg8TPDO/RnKZ8IltqdNKtUsfEBmfo53RzIEep
	A691EGK6/zhmXNnid8w5moaToYboLsc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794539554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsTrCOvBFWxn4axo5RZn2nb5R4o7XckDXTyC7dJ8tr4=;
	b=40XqFSrYmsJ9mwwIdE8HIqoVTvdeB5PUKyvCB4eHZepj0dMsVnGwS86NbyHqBoQnm2CGbL
	TBHva22L0hvpr4Kq4jWZ1Msh6nj62tMCMG7y3snE55l3zGugH9KisTqSvP0j8MRBEim1Bg
	9lnoVms5rHH5n+UhxKOsyH2Rm/XFJBI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBTNmNHO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ECA9402DD;
	Fri, 13 Nov 2026 03:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EA21F000C4;
	Fri, 13 Nov 2026 03:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794539553;
	bh=OsTrCOvBFWxn4axo5RZn2nb5R4o7XckDXTyC7dJ8tr4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VBTNmNHOV2NCySGEhL4lt7Zm/2MSpOfxDQE/jEAxoMxO7N6+ovffiyo7YxD3k03W1
	 /VOXAv8B0lHM/gdfXd5cPnbE5LuHWQbFdU4WzMKVCjThec8hmkOetbyDIpqnB5CEpC
	 FE7FznFYkMgrXZqiTrod+75QWnHgld0efwHFQnUawpERdtj2MYdzLFzXsW1sDS3QBf
	 cAvwrKaSDd+MVXcH4YxcT5YLy5Faon8BI1A2BJ8QZU0F3n9NPjQ8kJ+V54TcgFW490
	 RLFqWodLIe4mEXN61GnNjX8mvC0Lq1d51IpDU+k2S3eJ9kAFDvRpJwUf6ySLDfL28E
	 hCW+/9Cz85YNA==
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
Subject: Re: [PATCH v9 06/14] dma-pool: Allocate CoCo atomic pools using
 CoCo shared memory allocator
In-Reply-To: <sashiko-outbox-199544@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-7-aneesh.kumar@kernel.org>
 <sashiko-outbox-199544@kernel.org>
Date: Fri, 13 Nov 2026 08:42:10 +0530
Message-ID: <yq5amrrdmnlh.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 76ED580002
X-Rspamd-Server: rspam12
X-Stat-Signature: ig1o6dx7qgd8ujyj4y9qjtxk6w8nnoiz
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794539554-18023
X-HE-Meta: U2FsdGVkX1/5yiM1Qv6xlJw6bdJhkePuNKo5mP55shYISMBxDaO29/V4/ncwzvq+spKpwGBbTKGvQxudx7e9SkhSawcXrvkqGy6B/QqTsmM2FFCo1NsJ4FODljPyU7tSLqzf1s+CwfvvGEkKVdUNYPW1NYTYpDZV+8XjIsfLvEo4Zqv27KQSTCcxXCMjbHD9lF+085qzHeuAB0gzpOfPqCMYMvtpdG0V3+WnBRm9EltDUd7NgsM8QvmUP5HOER64U+D4Kd6NQjgd0AuxNW0zPeP3ocOcgjejGe4rGqFblvyT0wQe8ydGx39QBLmiHZ/ssia6QKE5ilBVyUB9osWua4UJc+U8VTpygnteUKwyHaXyRJXs8Gft/Iaev0/Q4xXNEhgmxP59DKq1FjcgL0h+72Xq92H9I1rrNUzfAZ3QfGSKDmOnV4UNbUTcp5rmsSwVEcEFZplAhEaK2IkKJzngPnYovUfJ6zXo9EhOt74o7S0iNZ9Z7qr0I9WkXNVZUbNgq24ZsSlTgD3+hPjsM2Gq0Ux/F0NOcsDlVK42VV3AU4oSnX56DVWgtwEO+PYzbALNoYDe/V8ulct7UmJQzsPFYAz+7eHpwaSATLNCrVExfJM7D8J7b90HYqqwajBOMlntV1KeCvUVkdcsgfkZ5XvpAFjo0yu583NX2qYYNIH0P4C/rdD8W2kWOMVCaqGN5L6FhangQO3yExzZcL0zHpHaC0t7j8TchkWV6MyGCBGMAP/BFwHLcf55LYSvea/nRXTPHb3Ybcjm5cB47khpLUVi0n+a5lHrU+l/VOnk2XRJuyY/2H0fvU8ejOXr7b0OIRyKrFESDMXaf/RHrRUBoykOgwsqEV9psEu+Ybl87eYx3GtkTdiCfMFvL6CkRrxoFPbtNwzDxkUkEJmlw6dsTxNHopHuG7hBF8ZonkPJZtdbjryPpLFc/lqWvdWmb45BqL0MaFVoKi4jtqN9UH7wJp1
 08Oo1iXX
 55js2ZSL1IgPHN4SufsqN+uTY2px/jELcPNugJKHhdDCDqmLDsPcj8CI/fTRNNE9Qq3zQE1IiveGIYcxPKAlvsW9F9PppGazKhQ7RKXbyeBe1y+kSIx1Faj+XAXcbR7phwKnSZEkA34xhagI+389IT7+HLnAE9Mn/YcBBBXC7em9bTfuz/2tp/S2ZejdAWe1qfjl2LPVp02ALOjOkkE6+5/ON3wbw38GTvEry7CNYUIj+oa25ZXMIgfs6UFa5SguVoFULOR2oEVfZG90yy0DH5eToSP5d1LqiDegQMktie4V/9ve39Z4+9SXdyPbQOZBTbN2ijoTgDdpOQg5alyF2+pKkXfOG1ZoKS0fGQUBFX6b56JlScpO9oIZ0GnKCZ62pRx5Gn+p07X3wfCKmZb7DQLtsG92JHnQRRp3U6EtprcO3s/4p/r319mCJo0wuR9w9yvEb5JqhSYkfHSJOYg9+WdFrweHU0VmmlWmPLx86r+XuE4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] dma-pool: cc_make_shared() runs after arch_dma_prep_coherent()
> --
>
> commit daae4fcc15a00bc83c4081ef4b27786a7f224537
> Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>
> dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator
>
> This commit updates atomic_pool_expand() to allocate confidential computing
> shared atomic DMA pools using the cc_shared layout and transition helpers
> (cc_shared_calc_layout(), cc_make_shared(), and cc_make_private()), enforcing
> shared granule size alignment and minimum allocation order.
>
>> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
>> index 70b7f64b17ab5..da487c3f9dc61 100644
>> --- a/kernel/dma/pool.c
>> +++ b/kernel/dma/pool.c
>
> [ ... ]
>
>> @@ -126,8 +142,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
>>  	 * shrink so no re-encryption occurs in dma_direct_free().
>>  	 */
>>  	if (dma_pool->cc_shared) {
>> -		ret = set_memory_decrypted((unsigned long)page_to_virt(page),
>> -					   1 << order);
>> +		ret = cc_make_shared(page_to_virt(page), pool_size);
>
> [Severity: High]
> Does calling cc_make_shared(page_to_virt(page), pool_size) after
> arch_dma_prep_coherent() and dma_common_contiguous_remap() leave dirty cache
> lines on the cacheable linear mapping alias when CONFIG_DMA_DIRECT_REMAP is
> enabled?
>

This is getting fixed by 

https://lore.kernel.org/all/20261109230830.1707975-1-m.szyprowski@samsung.com

-aneesh

