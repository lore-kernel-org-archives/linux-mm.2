Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642C6606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZRYmaiq/
Received: by kanga.kvack.org (Postfix)
	id 64FCF6B05B0; Fri,  6 Nov 2026 10:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6273F6B05B6; Fri,  6 Nov 2026 10:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D226B05B9; Fri,  6 Nov 2026 10:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38E386B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:30:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5A2180D13
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:30:24 +0000 (UTC)
X-FDA: 85405080768.05.4BA0D23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E73A5C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:30:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZRYmaiq/";
	spf=pass (imf22.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793979023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ajX4lfiph+VivXIsw2riYK43KZT3Do0cgXxc26s8IY=;
	b=5x7YybpkEIYfGhcmxcJrkeiXotOsKycblNxYOwA+WQMS5ALi172Zl1XuiZNRBJdtqeakfE
	HfYsgqDBvjoAx6x6tsYCVopOBVpg8pHHuoJbJm5uQV+p7WZ3uBe8b0C0qNto7Q7QhleQKP
	3geTwCNwOvGm/oJ5v2s5zmsa93RWzNU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793979023;
	b=g1eNAWcsijyAivM1wR3UKN5/pU8iRmds+XeiB/bzEMaTzBy9ae0aEEB7Ocsv1OBvGPrRjg
	U6ZxDgIcYvkwTmdEDhgQNIo0Ykuf/VdazgcLczNha99UOJVwr/kXkIUzuE9IgCQs1nwbOa
	4In4p9vfgyp2UN+dN5M0Q97SsVEC0tQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZRYmaiq/";
	spf=pass (imf22.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D825E411C6;
	Fri,  6 Nov 2026 15:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E4D1F0089F;
	Fri,  6 Nov 2026 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793979021;
	bh=6ajX4lfiph+VivXIsw2riYK43KZT3Do0cgXxc26s8IY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZRYmaiq/u/SQjBF4ufiS7XCsUtIWBR8hL8WYwn3u9em1LPif/YCL7ChpmRJhgOyIX
	 7IC3EXVPCAkmKpLit8fAZGhbU6zO4Vo41xdkh0y1FE4VLwuE7EJ30uktOPNCEggpHD
	 MbD1RX7dmUIkjT1awTBDV15avM4RN85WC1q1el5mr5tbkabk3V6dhoZUlfF40LSpgk
	 KGlR22lgb9rXJhGOGQUNnGEHkpSn3m9hgHzxauJLxhjdxnvoN5U5o3aZh72JhgeHUT
	 8BdOqsA5VITYBbXwdbZ6w5prD5p1MVjT+3jhhqFtkmeHdpWI1SXbbXixdwYl6O4EkL
	 ecOySiCRp0UYA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-coco@lists.linux.dev
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
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
In-Reply-To: <2e448ac1-7b4f-4d45-90db-dfe9dc5ad329@arm.com>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-2-aneesh.kumar@kernel.org>
 <2e448ac1-7b4f-4d45-90db-dfe9dc5ad329@arm.com>
Date: Fri, 06 Nov 2026 21:00:01 +0530
Message-ID: <yq5ald76ou4m.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: erfaqxktg5btjg8sgipnjt7ct96nhw6r
X-Rspamd-Queue-Id: E73A5C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793979022-921043
X-HE-Meta: U2FsdGVkX1+ipAyDwL8w57xX0Mdv7TD81nrtvROdXwOIbcOuIow7DVn5AFdwrYxALxPvFB3SAJIazEnEmCMdFn3rY14Ig4d92XV7EiBK7YeYGABmF0cDkVavalFjzrjXJFyiVdvEzjJJvojUgZbauySOMIesPb4AIq/FovO+XseIUKSvU03FjIeZy6l/KCmYLrSvtak/fSebfzYXQXYFOcGhIp83Lh6ZaOe3bBvwcsAIaLPW7+A/MNO1Li3CteHAHWjCkuzWxHBt+Uv2YZx8MaFc79gdSxx4eeWl1NUpPWOlEXw24e6B93Ib+MxpXjtKhL/k0qDWWrf+2tK1nYctdRg8JmtMre0pOEvau+5fUXexiTQiUnYgdQWdK1tBX6gGX2pInTjTEvmbjHkZ4E5q+T2Y4VmS0PgwcciWQzmTeobonmzVtsFOCD1NZ0VstxuTYBpuKQGshS0bB+9Ob8UkEh940bS/xZwSWbcv3RUG7DItWy7BEAuZNGLoU8kere5nBbs1UvS1cCdn2IctzNbcBBxgMY7Vdy/e9FWMufAhjIIQq+ZHYxsmWSyHxK8afnmxLClJ96UwcAIk+i5CMB3a8gLFouPLdjj1MrBdFmm32FCYZ6pYUIjOAlbrT9yWELqQrbb8ZDcjAbBW5dwgljOGz2SmpaosKMERXEdI6q3BRRY4rK+OB9wihTAkH5IfuSA9F01mhaECu5O7aeOdcBPWq2XnmklfJUK81k57gNEg0f5Y2exWFSeola86UyBO0dX4hx5JBMLHGB0KV0KIOdeS+CNBadpTTN4lAx+wRHqfCq+Ygru8a1/EMVgnSIQviTXjUp7rwG3ztxlSN+LA1yCppjPx1O5JcFEg5H9eofBNHRFx2nGoftFgtK0SfXVD6CnP/oqaqYH8TCehGdEieO/aucEy5FiKPxZ9kF0sqrWLbs+s0Mj8ioo6nKBMkjz3CO66suzvKOvHHg3c1eUc8em
 BYSU5ynP
 +Lmso3qI+yXf3EFwNQTIpVfqRr3K7FmPpsZ282n92IrlB7fRqNskOZktPbWdbabGeZ23NF7HgwufNifse5QrWmUEV/HqzdDjL4xT/H2LG7JFrEg3La242f7Z1a3/4JtC7ABbF7yykW7Hy6cQcRAd+QtGffW3eDgl+PQDze1hzYl41vEUlEOeZ7hvIZuYqc/iPVh650MzpEtEIiTOsreQv85I6EbMv6MDuKYrEzLaTPcZmNmHcNKFSgQo9EQ9Vc824ypixt/WPA0MSeN3W8PmmuKn7eztq7SJkzdFt8gLqqhwpgGzVdhiEk3eZae9hAvAE6t+ixb+1AH8d+B9S+RSyyaiyZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 04/11/2026 16:45, Aneesh Kumar K.V (Arm) wrote:
>> Confidential-computing guests may require memory shared with the host to
>> be aligned and transitioned in units larger than PAGE_SIZE. Several DMA
>> users need struct page-backed allocations satisfying these requirements.
>> Provide a common allocator instead of requiring each user to open-code
>> this sequence.
>> 
>> Add alloc_cc_shared_pages() and its node-aware variant. The allocator
>> rounds the requested size to the architecture's shared granule,
>> allocates suitably aligned contiguous pages and transitions the
>> complete range to shared state. It also preserves the caller's GFP
>> policy.
>> 
>> A private-to-shared transition may alter memory contents. Mask
>> __GFP_ZERO from the underlying allocation and when requested, clear the
>> complete transitioned range after cc_make_shared() succeeds.
>
> This is not true for pKVM though. It is the other way around. i.e,
> pages must be cleared before transition (e.g., from private to shared)
> to make sure the contents don't leak into the host.
>
> Do we need to handle such cases with a pre_conversion and 
> post_conversion hook ?
>

Patch 2 does something similar.

-aneesh

