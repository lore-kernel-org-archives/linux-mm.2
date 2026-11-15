Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB27D606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b3Kdmzc6
Received: by kanga.kvack.org (Postfix)
	id 9465E6B05B1; Sun, 15 Nov 2026 12:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D7D6B05B4; Sun, 15 Nov 2026 12:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AC76B05B5; Sun, 15 Nov 2026 12:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60D056B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:39:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9AF21C3BAF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:39:26 +0000 (UTC)
X-FDA: 85438065132.26.1972301
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5B22418000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:39:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3Kdmzc6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794764365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuvMmI09I/yZkcgOAhuxB6XI4+QcFoSXXJuVeZFzzgs=;
	b=05ivYhR8WtOa+PCewxGF7Xgj5JUhJQqV+ZCvCrlZLHiyLK8f1uqoz2w+3A6o4HS1HpVOkW
	q7K/UXl899jngLV2BOVA9WIhIOYMT49OIp4IaDI0QTImJK6DW2BlJiyKLwrUXUOj93QFpl
	J8/MKHD9UnNgk+dv9n8S9dLJq05uqsE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3Kdmzc6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794764365;
	b=awN372QLZGMfHuE+DqCPtP53NKX5EWvqZtuE+4nLhs27ZPfJcW01Gm7u25lawmHXYQXbxN
	fyCH6BpluubJX+50FakgNOZB3VpzmyDBNH5FmD4SqsnFk3tIBCyNRAo22z9iSynoe34roV
	fQcoT/iypZOXuPYjvyp1HfQfy+vOkno=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA2626117D;
	Sun, 15 Nov 2026 17:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A394A1F000C4;
	Sun, 15 Nov 2026 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794764364;
	bh=LuvMmI09I/yZkcgOAhuxB6XI4+QcFoSXXJuVeZFzzgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b3Kdmzc6zR6q5nTMEJclWpKxjsTP9FwKcjQ6sFBtEe5xoLu9qJ3i50GmOc5B1CkvX
	 c1kMrJw4q0qcpsIl0N/hXXvW+2McnXnOTPE8+W6jQxVPNrGJuONKHN93QErv5/3CJV
	 vISHCxyh/xuGazEgvKNhjg0MST+QnVNVfdZ57rqZAly759IX/47XSXDxl3ylzs023E
	 L8muKtVeMxSKoK5CtHTU2DkEqG6x+hf9wYETsjoxfFCWCcBB4J47qvljIHE+NNoyPq
	 uLcmqgjdOgghfHC5P+qQ4Ye3O2579I1aexcft9YfG4EwaYJPWkQ+rpvDGV1WnYXDhn
	 J35YsOgs06Vgg==
Date: Sun, 15 Nov 2026 19:39:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, robin.murphy@arm.com,
	maz@kernel.org, will@kernel.org,
	David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com,
	pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
Message-ID: <avnuP7SWE2BdBFBL@kernel.org>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-3-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110050202.529473-3-tarunsahu@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B22418000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: hhximy4igi9ca3g795djw9u1tsw11pre
X-HE-Tag: 1794764365-877186
X-HE-Meta: U2FsdGVkX19QjkANYtX5LaV9wCFtRmclNK/Ipw6GftnbepXi4+E+qIImnBbZAOl8lzb7J98XrNBiyn6hjqacnH2ZbANTehmn8prjr3dGkZMb8ZicA9D839BRE2yEAWkP5SkidC+LMbIR+0ee0XkjNi1QloxRaMoSzhOynvjiIQTQ8YenjNfPPoDgQfoBOmPGu3O/sJhEAclrF+21LF86Sa6EmZH7ejri3M6tWyfmPrJiNlr5OG/ka6jqbjT1W6uk/SWNxG+F56TeTlXtnutqpoQjO89KbfB3ILiKVYgCkozDF3rXU2pLG1nZEN6rUGnAKUfIdPtk3pL/EW5s5vu+id5McdvV1aHGJD6BjHvNQBxBzD3VEfM4KJ+iBLzk3l9f3YQHk/aGEPxMyuy5Rkjh57bIdEK/MtHbTKpzdoVLDnDrFHu3JzZjAiDJBHW1Ds5ZUUgNpqbvIiF2ZM/+ll5aLO7U/Zr6+nfxKCZigBD0VRYzdhlYP1RDKD4BrFywkuyTjpvIkbTJ9IQC9JjuqBUs8rJyi4Jk3/ih41A/5eOnv6lpGIBuvLfEtQ5Au3+wBC0BaWMcw+VIy6trtL+h/3RrTcjdTKc5mbaoZiyr2iFP7wVfpgzFu1lF+5aJIWIl0LRhcm1hVAx79TAGuaef5xwiIEImufFRYPytjhHJinwk35VtHlSnGb0eSbRTrvim60WXZz0aEoXVGnY5ph+o74uR6zG2UH04tL8/r6FzM06cVwLz6UpwSWo7q6qFF8TSHkzEIrhyd1D4RrrJYvyi/txI0NBq0Fu/F4LNfqeTtnk5i1xkJsaPQmaxY/d1jig7fRha24TFUiOzwSFfrUREuBqqzbOB3T2nrnGCOuVflzAszOEY2nA7+IvgCvN/jWhJgT0tKoWc5baarQ2bkpBuOSALQQsFcMSa0pCJSS72cN5vxDFPOOGfjPnUtri6xN2RdzWsOEIOK2fPgKywNHl7Wfo
 CYRtDhmV
 TX07raoO2i1AZiUlLuMdBbqpXNt3VuRJs776NMdq5iqK56Qgyl94f63vI4rmJEw6J/o4P77gOcSkVJzrx7EgzHlwy3iyE1RFXi3t865RJVbVxjQZJVMbVoG9jhwbM1LlE8vyKo2AKnizgaNwsm7QsxRUw/wxLFtiMvoWlCzGrI3tUqLE4tkm6AJztSUqiZdq/r98u/N4rC74JBZEORS6r7BZ8EI08fTaxl5rdIBAJGHdpkNeOvM0QcTCTZ6cUmc6CLYAq3Q7P6Vzs9wcC5R1zwlbAn0viyMmkv4l3dS+Fn0Hz3pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 05:01:45AM +0000, Tarun Sahu wrote:
> Subsystems using the KHO Serialization Blocks framework currently do
> not record the serialized entry size in the block header. The entry size
> is only known to individual callers, which must track and store it in an
> owning serialized data structure. If a newer source kernel adds fields
> to an entry, the changed entry size breaks the stride when an older
> target kernel iterates over blocks.
> 
> Add an entry_size field to struct kho_block_header_ser. On the outgoing
> side, record bs->entry_size into every block header during allocation.
> During restoration, derive the entry stride directly from the block
> header instead of relying on caller-supplied dimensions. The
> kho_block_set_init() interface remains unchanged. A zero entry size,
> or one that differs between blocks of a set, is rejected during
> restoration.
> 
> This change modifies the serialized layout of struct kho_block_header_ser

Imperative voice please.

> and shifts the offset of serialized entries within preserved blocks.
> Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
> kernels cleanly reject mismatched handover state during boot. Also
> update the stale compatible string example in the documentation.
> 
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/block.h          | 10 ++++----
>  include/linux/kho/abi/kexec_handover.h |  6 ++---
>  kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
>  3 files changed, 38 insertions(+), 10 deletions(-)
> 
> @@ -264,8 +274,21 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
>  	}
>  
>  	while (next_pa) {
> +		u64 capacity;
> +
>  		ser = phys_to_virt(next_pa);
> -		if (!ser->count || ser->count > bs->count_per_block) {
> +		if (!ser->entry_size || (entry_size && ser->entry_size != entry_size)) {
> +			pr_warn("Block contains invalid entry size: %llu\n",
> +				ser->entry_size);
> +			err = -EINVAL;
> +			goto err_destroy;
> +		}
> +		entry_size = ser->entry_size;
> +		bs->entry_size = entry_size;
> +		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
> +		bs->count_per_block = capacity;

Nit: can't we just initialize bs->count_per_block directly and drop
'capacity' and the change of the following line?

We are not very strict with 80-chars limit in kho/luo anyway.

> +
> +		if (!ser->count || ser->count > capacity) {
>  			pr_warn("Block contains invalid entry count: %llu\n",
>  				ser->count);
>  			err = -EINVAL;

-- 
Sincerely yours,
Mike.

