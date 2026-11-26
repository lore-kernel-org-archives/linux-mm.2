Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8287A606A331
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EqS38396
Received: by kanga.kvack.org (Postfix)
	id A7C076B05B5; Thu, 26 Nov 2026 13:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53756B05B6; Thu, 26 Nov 2026 13:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990BB6B05B7; Thu, 26 Nov 2026 13:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73B536B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:04:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFBD11A01B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:04:58 +0000 (UTC)
X-FDA: 85478046276.28.6A880AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4AAC340008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:04:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqS38396;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795716297;
	b=ZnECvIa9PLKFFs0vE0lCSmRAKIDwuzNtI2YuKOn4ArNzqGPppxphROy/bnkWXni8loGRFP
	9e2x1DbBL5NC+kT7a2qEcCd0zH8D8WrX2V0a4GdPx0ob+QU2qoVR9Xlb4cVxcKkXmT3VFz
	ys9hCXtmVQTkxu8nNFx2AFEppXcryfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795716297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyeadx8A+qjGGKflAd6kjiHqlv7VopvbXaimXP38c3g=;
	b=ZcPZva3ou/RZ7+Y58MMX+2z2vwcZkISFuH+zp2KwPsTzMDtK4oWDCn2HY7t1PbCXn4RiKz
	lXlfN/KfenbCKv6tB5qp6286Hq7vzxEqzJE5mIvQ6yt7HMAV7ujesyQ34attulRTtA2gSN
	vTtGL6Gz8a6YRxWyOuceHvxIvqWv+3s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqS38396;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75E6160E2D;
	Thu, 26 Nov 2026 18:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1B81F000CA;
	Thu, 26 Nov 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795716296;
	bh=wyeadx8A+qjGGKflAd6kjiHqlv7VopvbXaimXP38c3g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=EqS38396Z/iq27cU9pt1bZvkBZNs2vlZLiamVFn+y25C+t9ZVrIAPHvMUWzhklPNP
	 HFlsyNtm+f8t96tCn/siJCDZuV1XtDvPYjdJqVqKSpH7VFHyCh9f6uOi3Z9ejseiY4
	 yiA4CVErYDCkwKKlJKqm8i2Sa7AcFoY130mUzRzuiM+gnKIaLLWvpo800U8dbryzmU
	 Ie6ee1bcLsBZPAJVP+PhrLXv/FwN2eXOmuWWDguEbpYP1xOXMR4fwmkl6C5BmqrEfu
	 d4UA9FhkCeKKlVEZWBE+E/unDJ3VkCOcP+G9AxHsM5x6LxQMUSfXvO2ckf9/IBGfFo
	 /Y/pUt7+dSRtg==
From: Pratyush Yadav <pratyush@kernel.org>
To: tarunsahu@google.com
Cc: David Matlack <dmatlack@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,
  robin.murphy@arm.com,  maz@kernel.org,  will@kernel.org,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 08/19] kho: block: Add the feature header to blocks
In-Reply-To: <9huzse13pxhq.fsf@tarunix.c.googlers.com> (tarunsahu@google.com's
	message of "Sat, 14 Nov 2026 09:34:41 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-9-tarunsahu@google.com>
	<DMRP21FATCC0.ARAURXWV85JP@google.com>
	<9huzse13pxhq.fsf@tarunix.c.googlers.com>
Date: Thu, 26 Nov 2026 18:04:48 +0000
Message-ID: <2vxzcxrrwjsv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4AAC340008
X-Stat-Signature: dmqza611oweatoxen5roawh3kno8k47r
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795716297-265584
X-HE-Meta: U2FsdGVkX1+AySkc5uBeXGOkfwabe8BIkRkRGgZXw1JuHAB0TIDkqgu7FDGhpLFAG0mMEfj7+7cX7gAtlpm+GFH/TeBrpGMGUzPDqBcEXfIxnU3Z3fomWhoTb9f0z5JGo4NJq8Hf15eirinpONxJGvI6lOZWpbzul9YuVXsfRclWk3DWNRMtkEM0Njl/OUdljG2PC9vEpIqjDmYyBMbsctydztJDqV9peCVunlbIKcd5U5DukOp+Sey92czQW6nuX8N+aL3ufZgkkvIGgguhy547jwgEhPtHjfRufJTvrQghzmPcGHwyM/CdAhfJIj6UfAVY2UWEmVsOwd6rkdhchaDbZy0+dhQfzoXIFjD8Y2fWBrbW9/vOmWLdnOY0xgkASNPOX42e3gUiNtWuu7LERYHw+l0DyrACjbrmtI2yqIX3Q9Ox4oJK0BfmXpm9Su7eIzA/NZYfTExWbfDSWkM0gsH3xZx5eyYH5L5YGlK/XaXo5GVQ5+70UphF1/mX8ifGYtSEnR/SFC/1GMS0nOShE00x+I6z8mrcM5up2jiDpZIHghErHBwdbNNI7lD7Nwz9cKjvNQnN1CBcCeHNaDTWMEZZ+YNFVhtb6ofqQDz1NwxIA5Zd5Uv6w7M2WSIuqSANII7X0lVlNfAhqLyaFcPp0ls7j3HeLfIELWLyDvgKmwAsj1UhrehjDajBcLl+rmQ98pGEzv+o8xJ0LWIVcHfHZJpZjwNJSu9rjBut4qD00xjHs8CLtK4vH66YcB5wThMju/aRE3hgO3BkKiv6JBYHcIyDng6xE7aiSTiRzjSRWW1Kwy/8ZAgvVU0h82GhRI590k+VInjNEc/IJkF8Qm6NJ3E0yVVg7bwkZ9+MbIZM8sHiwROIohBxy6FT8r9bZEG1aLgrmojFO8hwFjDo+ajyhjZu+eLKrzSdONQ+tOEQ8AjTe2lg4qgiy4/soM2fn2bdIYqz6i9PLBM+WsTaTak
 QrSpptrW
 cuo/oZSdwM+VtXcRm9bCtqKPY+YoF3KcbHz6seZbuE7g9/JUXZ3O3Pld7ZhkMwRSrZ8H3ybep5EdF1EXG3cSNx7dWk1L79/efL1bRSjw6UUWaOWbmvG+lfdAhYqrwR+NP+k1PS/bPAq+iB9/FbqAR5zvfwtsmerorprS50GGlPISHW9wqHpGqxPMTKutS3TiSiWOUMqUbhTr+ra0HpD+/sUZ65BVUdiCQZF3l5tQOuxKBeGXYc2yqpqSNIFLG3TWLhOKGC5AehkrV3pvEY+lGiMbbsSdTNDpHv/lwCoENx/7S4kXL8anQ3J7HiAO+eUqRyql1BGxkVBt0r1Y2j/p2cBzux8l5I36c3oZoWWcYF5PWIko4sfONGpsOwLd+eij2Bzag4lOAet7ySOaAEIHKB3XrJV0A4UPVGUSlyMagGLaPrcmPBGFCHj3HTcC1j7fiqhjr1hkw52A3mA1n1WhMQ8U0bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14 2026, tarunsahu@google.com wrote:

> "David Matlack" <dmatlack@google.com> writes:
>
>> On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
>>> Precede struct kho_block_header_ser with struct kho_ser_hdr using
>>> DECLARE_KHO_SER. Each block in a block set starts with struct
>>> kho_ser_hdr followed by struct kho_block_header_ser. Serialized entries
>>> start immediately after the header payload at offset fhdr->size.
>>
>> This adds a feature header to every block in the set, but the layout it
>> describes is a property of the whole set: all blocks are written by the
>> same kernel with the same header.
>>
>> Blocks are only ever added and removed at the tail, so the head block
>> is stable for the lifetime of the set. I'd put a single set-wide
>> header in the first block only, e.g. a struct kho_block_set_ser with
>> its own feature header, and keep the per-block header to next and
>> count.
>>
>> entry_size (added in patch 2) is another set-wide property that belongs
>> there. All blocks in a set have the same entry size, so recording it in
>> every block is redundant, and restore has to check that the copies
>> agree.
>>
>
> Yes, adding a ser_hdr to each block_header is unnecessary and also cause
> 8 bytes to get added to every block. This can be solved like you said by
> adding it only to the first block. But this will make number of entries
> in block[0] to be less than blocks 1..N. I am not sure if that is
> acceptable but if it can be then we can avoid adding ser_hdr to each
> block. Same for entry_size which can be moved to the first block only
> like you suggested part of struct kho_block_set_ser.

I think it is simpler to do as kho_vmalloc does and just have a separate
out-of-band structure to hold all the metadata.

[...]

-- 
Regards,
Pratyush Yadav

