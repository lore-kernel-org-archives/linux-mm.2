Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04357FF8870
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450486B0093; Mon, 27 Apr 2026 16:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427DA6B0095; Mon, 27 Apr 2026 16:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316EC6B0096; Mon, 27 Apr 2026 16:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9166B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:33:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE64C1A0200
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:33:01 +0000 (UTC)
X-FDA: 84705484962.05.82ABE3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D894B40007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:32:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CPpGeZqU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zilGkucIvAKI2C1BINewP5ngC2cVQqU9MCjENDL+F0=;
	b=RC0Y/Mx1OiSTzFehJX7yM9mcBv4clB8a/1weAJi2J95hVNP4+6HARg7gwgcuufs4plhjdj
	QzaWzUlBZ3psvQk6ZlZF8mdu2XxZ32q6Plg5PQBw8vxgqZGJArdAdpOEkCItcbn+pxTNo3
	bKzZTowjDvIEWte2Mxul0nf0Wa96w1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321980; a=rsa-sha256;
	cv=none;
	b=3QS09aV386hTbaQRFvzivPkqOiQANoNin4DfideeudoiS4eZluvS3M9uUtj7rjgZwucg2b
	T3eWGOlY/Cdn4ZtyEiZ3ZAKu7HHTNxa3zrSEKh9UIp2KsHi4aF8VUFOo4LNybAJPj+dNKZ
	0Lx3WIbgWF4mLml3W1my5ekbBc4Xju0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CPpGeZqU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC5F642B8C;
	Mon, 27 Apr 2026 20:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907F7C19425;
	Mon, 27 Apr 2026 20:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321978;
	bh=AYegFMHP0FdsG4kub/LfFJkX3yPMbTV5RSbToEya7YE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CPpGeZqUUq4NeHLjr8Y6gHhQ05OKQLcZ0ZJVizuxBD/hnh6paiIYrIaKnVuuk0EWe
	 uYc3mVuCWJhlzjC04W4vgsZ2z+vmdwMvbLJyFiFcyeCY/Uqq8FIQ7ITfxECAGUtWnT
	 445TSQd8UPwBSkkeHWgDEd08Z5PuIQaQrtrInshYoGmv/n+R8hYzz6uxvVaiH5hL4n
	 tAUtIiwsnIUACypW2QAIXakl9lt0s90+wFQj1nY9viO0zXAtVev6mYsQGHg8yzH+9V
	 LLCz45rzypGCC1pYmnOEA0N1vkqM7F3g1RBDqMXXhebeC5qq5sDX5noJ6G/U/bdIpd
	 ydqaY9P//sj0g==
Message-ID: <67a655e3-fa23-4d2a-9685-14e6221d5d26@kernel.org>
Date: Mon, 27 Apr 2026 22:32:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND] Re: [PATCH RFC v3 4/4] mm: add PMD-level huge page
 support for remap_pfn_range()
To: Yin Tirui <yintirui@gmail.com>, lorenzo.stoakes@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, willy@infradead.org, jgross@suse.com,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, akpm@linux-foundation.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, anshuman.khandual@arm.com, rmclure@linux.ibm.com,
 kevin.brodsky@arm.com, apopple@nvidia.com, ajd@linux.ibm.com,
 pasha.tatashin@soleen.com, bhe@redhat.com, thuth@redhat.com,
 coxu@redhat.com, dan.j.williams@intel.com, yu-cheng.yu@intel.com,
 baolu.lu@linux.intel.com, conor.dooley@microchip.com,
 Jonathan.Cameron@huawei.com, riel@surriel.com, wangkefeng.wang@huawei.com,
 chenjun102@huawei.com
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-5-yintirui@huawei.com>
 <9886b2c6-5516-4be8-ac31-db3133455af2@kernel.org>
 <39dac497-220c-4e71-9d3e-d9cf32357400@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <39dac497-220c-4e71-9d3e-d9cf32357400@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D894B40007
X-Stat-Signature: d7r4xxmtyampsa48grfrc8qeewsjddub
X-Rspam-User: 
X-HE-Tag: 1777321979-319577
X-HE-Meta: U2FsdGVkX1/4qmN5DDf+0QpWIH2+9Sn3ssHvbdvwzOgyqtxpJac63cu1pz5j1LYHkpOyDeFQfdtIGDXBCDwW59aGGQ/axgIhdSI2DZhFI26xG2dUSG1a/MgLFwTzWomSW+h4//IQX4efM2IXPGsNo7kunAz+1aCGXjo0l/kaRXv9ld6yAky35JszeP+M3VwrG65wrustrmXzhezPkvJDBXrkKa+4fDxfuuJPBRfQBoj46LEiPVl3JviDv3SJ9SZRD1tqJe7wLsJwnPc24SQINYkrhpEZK6tNJeT9Q4JE+Kq5T2zW4mowrdTjrlfUdLWR4FInlXYRTRA9yik3wtc+NbH4q6bGiACyXHDc5hH1ee8aS6oL/exq1YNCYW6TK0Kx0yZvYfVfD396Kwfskur2jNXvhJOqfs3OPPfdEnIw+htsXvuemlXGwkot5YzQQpSNGSZtCVXxcmMbdHv122rh6nbGZVt6rJd8sry6ltk9tgNlJaI4ww5j/WVWR+5gc7XR+kCOMCudj+c7T4Tvq+oNwU30qQnK4nVhd70ahTOT6Q61DicSrgmXYC9PUCbXYotOX87g/PphzqQPBJu6J2mi3Oc1yS19xgoY94X54ni2CkOs/tG2uDHZH2e+DEnPsNXZ6VKHCnS0CjDQkQxu3mZqKEKhuTrqvInGeRsUPMB+qjF2WmXKPJVHVLTtsbEBlySGFal4VJ297O55QhZSWda7bs3WcXrTq2Q6pesImfVSvUYH02CmVXlECUT1w33hbBYu0Xf9VSHqr/Ypwp9U3Nnr9faxaPq3BijwL12MKaGuR1+e5AANSvNf+mvjF6/amAarHNsQRC+v/5Zc6x4tna5oxV6vmZjuPp+syb+4Ti84UOg59du5fAkqEhKOMLhNGHysae4mhe8Tk9ZXrpCHUVnl2TdaarOV06kV5EbYBioNZhnvN50EfVpYO6A/oneXUvHIz+6fo6QMYTO+Mlhy/fo
 w+jvTGL/
 j4U2KlrGpqqBBV7SSF2vOnLgIDBcyVmIpkxpSAM4In4ypasEXq3TmexShaAQS+8LYQqkg4w8k06ZgSo2jfF4QAlWgd3ibee7kkMmntoHDrx3ORrRX48Sz6M2OmrsOQqtTJzKuA7bggYjugmcZPNz5knMIpPorIw61R+1zXit92fDPQWPE/F4oT+nsoA84mr705sM7UFLJmaqNI22YLrxnt1zYw/LPHj9iuePXt2Anon+k8uMNQjXc8IPnWbKuoOhgZLpPvVkne4hivt45UaMoLVgttuvG363nTWMKQvgVtUrSQpiX4LfNU7TE7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +			pte_t entry;
>>> +
>>> +			if (!pmd_special(old_pmd)) {
>>
>> If you are using pmd_special(), you are doing something wrong.
>>
>> Hint: vm_normal_page_pmd() is usually what you want.
> 
> Spot on.
> 
> While looking into applying vm_normal_folio_pmd() here to avoid the
> magical VMA checks, I realized that both __split_huge_pmd_locked() and
> copy_huge_pmd() currently suffer from the same !vma_is_anonymous(vma)
> top-level entanglement.

Yes, that code is an absolute mess.

> I think these functions could benefit from a
> structural refactoring similar to what Lorenzo is currently doing in
> zap_huge_pmd().
> 
> My idea is to flatten both functions into a pmd_present()-driven
> decision tree:

Likely similar to how we handle PTEs.

> 1. Branch strictly on pmd_present().
> 2. For present PMDs, use vm_normal_folio_pmd() as the single source of
> truth.
> 3. If !folio (and not a huge zero page), it cleanly identifies special
> mappings (like PFNMAPs) without relying on vma_is_special_huge(). We can
> handle the split/copy directly and return early.
> 4. Otherwise, proceed with the normal Anon/File THP logic, or handle
> non-present migration entries in the !pmd_present() branch.

Yes, that sounds about right.

> 
> I have drafted two preparation patches demonstrating this approach and
> appended the diffs at the end of this email. Does this direction look
> reasonable to you? If so, I will iron out the implementation details and
> include these refactoring patches in my upcoming v4 series.
> 

Yes, sounds like nice cleanups.

Maybe the code could then benefit from moving the present vs. non-present
handling into separate functions? Just a thought.

-- 
Cheers,

David

