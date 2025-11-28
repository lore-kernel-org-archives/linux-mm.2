Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CDCD116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 16:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E706B002E; Fri, 28 Nov 2025 11:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FE56B002F; Fri, 28 Nov 2025 11:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CB96B0030; Fri, 28 Nov 2025 11:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 576486B002E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:48:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1661E89B1E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:48:02 +0000 (UTC)
X-FDA: 84160598004.06.793D7E8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4391140017
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:48:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764348480; a=rsa-sha256;
	cv=none;
	b=ybIumawzE1VxJE8+X+HLZ+M1EBBMfKWSmg+Dgk06GQnEMP/SiFgZTbG5LEcWly0VCKD5rB
	U6ujg4O8eKCa+wNGlMg/M5AKIAT2ij1mLO3QF/5POpt7VZd/GIT2aItGZ4yxvEBgmI0e+b
	IRcohXeZSOt9zcwcbIh6tja5f1xWJg8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764348480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMbpPIeFpM0Mwo2f6ycsRYrjCB6381qMDUpWWMDVMpk=;
	b=zPKwUk77Q9dCjktjMm7ITIA3UFrVIlYvVkMH5zLgLGrGKp21vxi8Q7bpZVFpW7kFXELYsB
	MIIj8UPxik7mIPTl0Dd/pLlSrrifJSgac29fuFhPl1gM43uo8uLnhFOobOcVXSTe4g4/js
	I13NhDFp7hZbHu71mV8k84eTz50K194=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD438176A;
	Fri, 28 Nov 2025 08:47:51 -0800 (PST)
Received: from [10.57.89.189] (unknown [10.57.89.189])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FBA33F73B;
	Fri, 28 Nov 2025 08:47:55 -0800 (PST)
Message-ID: <c8229530-ab87-4b51-8f2b-6199a01095b3@arm.com>
Date: Fri, 28 Nov 2025 16:47:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
 <12d99a54-e111-4877-b8cd-cb1e58cd6d30@arm.com> <aSmVQDMXqwc8ctDf@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <aSmVQDMXqwc8ctDf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4391140017
X-Stat-Signature: pcjqqp11h8dxui4cyd6eaco1kotn9rte
X-Rspam-User: 
X-HE-Tag: 1764348480-170170
X-HE-Meta: U2FsdGVkX19zK+pcr9MevNx2sXOTmDt2yx6MIat7VTCBL8YFM4fI9SdWrgttkPdyf6Eay8QAzh/TWfq9+0iIpYSm10hjbUnqbPRWL5UhL1IkdtBlynOc/n2nyLYt2ROb6wEDO/gNk0QuHYPoizJN443chtcpYhql6+NNWhPygEaS3rCgi0QbYJ60OxWkMrRrLDHAFBrESTKzj55UMZqKrjnNW8BsgAKeKyK0igcL0n3ykhdbjzZh1yrA+45Y4wkcoYZAQE31sKQXSAJTcgFZehcPcmGdo8OYT6X6oM7us6U3YnY9DS6rsf/a6pKCFTreiSSCpUgyqQjty0oeoOZHvq4fv7JI/Oe4nIUoT4yPqN78/iqr5yv8cn2bwacw+D+Mh2L4BNGd5gW0Vi6kwt2twSgF29tyTYuDyyo8L8x80guLQc9cQsyQ3EnRVxonpCDkArabkO91E04jJ82Qm877ZAahPljEorCu8GHU54mbRb5VDOy5DRX83/oczsZ5CGI219ZKRxetdFY0RmMpAlIQMqOiigC7WGHnMVY41WLSEkdXA+61HN/L/wPkLF29d2mdBh9CX6ZTLIlpDYEloQXRXc9v/oOC7/r0YrMqsny01UyfxyHdnN9BCDKUcGX3gmFN+E+6gUHi2BvYGjnDhbT7Ic/ivpP7Xe9y0ZhNdcdcOI4eNcTnn4LPIu9YzShdc3a5YH0ub20xUPggshcfh/rEFVDXgx8HSlTS4hALfcF65wv6P0ywN6BfAOOVH1XQxAb6xSWQ4uoI2osJo1baY4GL+r7sdcxGti2JE8itsYZnkmO7t90mqMb+Jh556wv1T6toZhZQyJMeTqh0JCabMHZ1hWC8Cc4uSesuxRkYmjC5n3yH9dKKWQrd7WRA0ldDiGpdIZhmPYsBjOIArJFS0lciPg8DpjLYD9daoND5z0M7biJytKiHtdLksxnSETA7gBO+zc83ueIkFkmKr+CBx+o
 JO/L3NGz
 B9GZplqGHDeEZaVvgrdFUAkVzvRkHMdZ5Jvftu6mJ71jIjkhq+UvHx+7osZAhxJNEjsUQ+GV+kuWkZ6qty9Lo4jrCPYlGI7Y7QVTOqL+kQF3Q9lVHUSvgbvNJ7Zpki0oFr9nhDzEvDfomR/HAjCQSnvQj2LHHVvyYkKfntQhSe5hewoR5O7mgkhvMkV7syncznZqXYfzg8p/Rt2IkuwRBzuwrW4nksVCPcegPWSf5mBi5+8SXLZKvTIKxEsnYZITO5gzWhN/zpYAdQfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-28 12:27 pm, Alice Ryhl wrote:
[...]
>>> +    /// Map a physically contiguous range of pages of the same size.
>>> +    ///
>>> +    /// # Safety
>>> +    ///
>>> +    /// * This page table must not contain any mapping that overlaps with the mapping created by
>>> +    ///   this call.
>>
>> As mentioned this isn't necessarily true of io-pgtable itself, but since
>> you've not included QUIRK_NO_WARN in the abstraction then it's fair if this
>> layer wants to be a little stricter toward Rust users.
> 
> Assuming that we don't allow QUICK_NO_WARN, would you say that it's
> precise as-is?

As an assumption of use for the Rust API, like I say it's fine - it's 
still not really "unsafe" if a caller did try an overlapping mapping; 
the call will still fail gracefully and accurately, it's just it will 
also fire a WARN_ON() since ARM_64_LPAE_S1 without 
IO_PGTABLE_QUIRK_NO_WARN considers this indicative of a usage error or 
race in the caller.

If we do end up wanting to support more opportunistic and/or 
userspace-controlled mappings by Rust drivers in future then we can 
relax this expectation as appropriate.

>>> +    /// * If this page table is live, then the caller must ensure that it's okay to access the
>>> +    ///   physical address being mapped for the duration in which it is mapped.
>>> +    #[inline]
>>> +    pub unsafe fn map_pages(
>>> +        &self,
>>> +        iova: usize,
>>> +        paddr: PhysAddr,
>>> +        pgsize: usize,
>>> +        pgcount: usize,
>>> +        prot: u32,
>>> +        flags: alloc::Flags,
>>> +    ) -> Result<usize> {
>>> +        let mut mapped: usize = 0;
>>> +
>>> +        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never null.
>>> +        let map_pages = unsafe { (*self.raw_ops()).map_pages.unwrap_unchecked() };
>>> +
>>> +        // SAFETY: The safety requirements of this method are sufficient to call `map_pages`.
>>> +        to_result(unsafe {
>>> +            (map_pages)(
>>> +                self.raw_ops(),
>>> +                iova,
>>> +                paddr,
>>> +                pgsize,
>>> +                pgcount,
>>> +                prot as i32,
>>> +                flags.as_raw(),
>>> +                &mut mapped,
>>> +            )
>>> +        })?;
>>> +
>>> +        Ok(mapped)
>>
>> Just to double-check since I'm a bit unclear on the Rust semantics, this can
>> correctly reflect all 4 outcomes back to the caller, right? I.e.:
>>
>> - no error, mapped == pgcount * pgsize (success)
>> - no error, mapped < pgcount * pgsize (call again with the remainder)
>> - error, mapped > 0 (probably unmap that bit, unless clever trickery where
>> an error was expected)
>> - error, mapped == 0 (nothing was done, straightforward failure)
>>
>> (the only case not permitted is "no error, mapped == 0" - failure to make
>> any progress must always be an error)
>>
>> Alternatively you might want to consider encapsulating the partial-mapping
>> handling in this layer as well - in the C code that's done at the level of
>> the IOMMU API calls that io-pgtable-using IOMMU drivers are merely passing
>> through, hence why panfrost/panthor have to open-code their own equivalents,
>> but there's no particular reason to follow the *exact* same pattern here.
> 
> Ah, no this signature does not reflect all of those cases. The return
> type is Result<usize>, which corresponds to:
> 
> struct my_return_type {
>      bool success;
>      union {
>          size_t ok;
> 	int err; // an errno
>      }
> };
> 
> We need a different signature if it's possible to have mapped != 0 when
> returning an error.

Aha, thanks for clarifying - indeed this is not the common "value or 
error" case, it is two (almost) orthogonal return values. However if 
we're not permitting callers to try to do anything clever with -EEXIST 
then it might make sense to just embed the inevitable cleanup-on-failure 
boilerplate here anyway (even if we still leave retry-on-partial-success 
to the caller).

Note that it does appear to be the case that io-pgtable-arm in its 
current state won't actually do this, since it happens to handle all its 
error return cases before any leaf PTEs are touched and "mapped" is 
updated, but the abstraction layer shouldn't assume that in general 
since other implementations like io-pgtable-arm-v7s definitely *can* 
fail with a partial mapping.

>>> +    }
>>> +
>>> +    /// Unmap a range of virtually contiguous pages of the same size.
>>> +    ///
>>> +    /// # Safety
>>> +    ///
>>> +    /// This page table must contain a mapping at `iova` that consists of exactly `pgcount` pages
>>> +    /// of size `pgsize`.
>>
>> Again, the underlying requirement here is only that pgsize * pgcount
>> represents the IOVA range of one or more consecutive ranges previously
>> mapped, i.e.:
>>
>> map(0, 4KB * 256);
>> map(1MB, 4KB * 256);
>> unmap(0, 2MB * 1);
>>
>> is legal, since it's generally impractical for callers to know and keep
>> track of the *exact* structure of a given pagetable. In this case there
>> isn't really any good reason to try to be stricter.
> 
> How about this wording?
> 
> This page table must contain one or more consecutive mappings starting
> at `iova` whose total size is `pgcount*pgsize`.

Yes, that's a nice way to put it.

Thanks,
Robin.

