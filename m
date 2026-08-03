Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C756AC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91556B0099; Mon,  3 Aug 2026 11:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68F86B009B; Mon,  3 Aug 2026 11:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A589D6B009D; Mon,  3 Aug 2026 11:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72B286B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:12:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B5F8A1F60
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:12:34 +0000 (UTC)
X-FDA: 85060299828.05.A3D8F9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4CDD318000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:12:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMv4MQn1;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769952;
	b=3xetAN+k/3ecdas2BztSL2kFOHs81j16XjQufC01vkq9wdIT+KYDPRlIftVvTInsFuEFLf
	3lee0hAef9ryjuUhd+x2kRc/WjQ+ARntmqPUoQyHCtxzv0ok0B51bSc3LyT6eWbOV1iKFP
	Kn0/pxX6vEaFwBenXAp9Gfc0qsKaDbQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMv4MQn1;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsYnSY7vyOvbrcwkcxBPIWl17p0R0T5Q719oyY34OHk=;
	b=CqEZ/NEwGavoe8qlqORwArDuD5lzRmPyXGMnP/5bmbHjyd+w0hE33/Jy+z/SL3/hgqTJmv
	o7bG5+bTTLuVAJTTeB8lVVqNii0tusWUV2aNm/AkwCCOEs16V+O0+jIx5mavykpyt+/h/q
	gEI9R8EPXlhoP3dumaPV8xC7k3/KYPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C029460AA6;
	Mon,  3 Aug 2026 15:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F76F1F000E9;
	Mon,  3 Aug 2026 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785769951;
	bh=HsYnSY7vyOvbrcwkcxBPIWl17p0R0T5Q719oyY34OHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UMv4MQn148Y9ly+5uk5SVNaUY/Dedy+gXUByfpQVRvsb+A+3Y3ehG+AguSawLowjP
	 IaQ6z+ETXRlVqmYwxotNZb9wP04aqE5JLsAEJ7qYhB+feK0bJE0Dgc2t0/qSe10QJM
	 o4ntgi3A6PxGLQ685mXr6PGAuHJ5hzFATLljCNnJn3CVMJlzN6KxF6KQq24GHxm5FT
	 ftlOQw2deT/bER4kqFGByz8TWGJ896w81gNdF9CWErWrZKA9/2x9ZF6Va04oBftsuQ
	 sGIS8oWMdJaqCrKyVG4hVtb2xOBChFyX/S6vQmbPXtxvdN0cFYy7ijALO/8kIe33CV
	 yeZF4LNjgeIWQ==
Message-ID: <99037993-ee13-4160-8c87-b6642faea554@kernel.org>
Date: Mon, 3 Aug 2026 17:12:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 "hughd@google.com" <hughd@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
 <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
 <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org>
 <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org>
 <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
 <anCtzQrUkFSSq8De@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anCtzQrUkFSSq8De@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9f3zfjci9ohxr8yqyia8mg4n8fyre5qx
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4CDD318000E
X-Rspam-User: 
X-HE-Tag: 1785769952-203570
X-HE-Meta: U2FsdGVkX1/ozQsTMqAr7l5GxvamsW/avhXZOYH+TvbKGmfTsLfF5nQMXpmQtxk79VYu7letTyqqQBZoMRcJk1tkYDAAwcGrdI/YEkNIbDq6bRoOSC4xIVzr6LHEEDf49xx0en0cZBgYPFFi3RkSQjgKt99JPkoTxV+tlfPRVB+pndeiXbBT61p0m4bDEsz7LsBvu6ZxnFIaR3t3shTOCjP4bwBNTPOMEe0QGmxxZy5GVa8yWQ8qqJ+2uvpXCD4h062dcjdnrVMeKPJZ59Hgl6onjRbIZHmglgR09immXx1oXT6ckq7DFZMSdmipuaWWwiW36JtmDVvAJ/jI8ePqXZ3O2YTI9a1YpoXyKXf+46YnMwbwigvvzQN2dqhbIOIVB2O0RnWhXQpgW1tJN3h+2au8VNAhdOXfhtKHBOtDTWAMkYWtrFLI3jmk//TifRtE1fySdFmGA3ke09Ux5qZ1sbX2EAU+f+vwSLX7RBBllF7+oAheKPIRG+299u/QVOD9ESBWNgEEySywpYPq+F61I4P0XfCYBIO+a0myvmAq/kxPfG7mSEO5hbVg73z5Gm3zUWpipYI4BmX0Qc1Soq6Gar4hYqE87VTBi0kcPrlPm9PFF8mMW7iHN6RNIbtXJZPqO06Kbu9h8TKrNIrwhQE1JFe5mWm+NHXLrMlCB80Z1xInrf4gRAnR53BgA6Ew7zGN/AkFcnxeSRMMi7Ja15O2ZIepmNnodHmB4p2LiBGgWfKPmBKRVilli59gkdzI+528W26KU4ZEUuu7+sHY/XTpGdts3eybf139zUMqV6XUD2owTxANX0X2ZN1f2LqPiQe8qKz9bOvDnEhRttpLWaR0LslSBv/FgG5JML9DeH1ad0+KX0tLY6jy+BwL1vY6+3UEWC3bVnjl1FSb0o36kH0xXuN8/wbfUhuIskMqZQzl4OpClxnEmGJMT26ztHuZTdVvp2h2i+GuCQbiabp7zre
 VjH91b9I
 wXuOm2/57Mi4PQ+7g8dw91noXvO3hiDne5cNUEPe3Ji/hZmi1WRl5uab48VtBCSV/UoPPhRV0c/mYIM/S4kilaW5+kDtUBWBcHmJA+QrUukX06T45X0AklbYwzVpvcZNTwRrK65KEliTZS6Sw4Jock1rNL6VGvlb+GsgZL9ixdNHWtp0BsOhoAwiwjwN+1wnSHeWZHazcnaemeo6PrDwzUXoR+oHxgbYDwK/HO5LWYHOAVVucvFgqEVmh8f/W7Chy1L2v3mbH/MQBzcyhG3ZYDNWsZ+lWC1L/ys/t8eC4j5cWK4X29pWtb70l9OpqJ8jLnkQiLjzRVMs+1plx9E7ST9AmWnB894B7Z/T2dPZjefHC8f4dzeRDHZTXjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 17:03, Sean Christopherson wrote:
> On Fri, Jul 31, 2026, David Hildenbrand (Arm) wrote:
>> I sent a fix for the GUP code that always makes us drain right now:
>>
>> https://lore.kernel.org/r/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org
>>
>> Would the following (agains mm-unstable + fix) work for you?
>>
>>
>> I assume that you'd have to call it as
>>
>> 	lru_cache_drain_for_folio(folio, 0, NULL);
>>
>> But maybe there are indeed extra references that are not reflected in
>> folio_expected_ref_count() that you would have to consider? I doubt it, but please check if
>> there would be a problem.
>>
>> There is a small problem for merging:
>>
>> (1) The patch depends on the fix.
>>
>> (2) mm/swap.c was moved to mm/folio.c in the mm tree.
>>
>> We could write what I have below against Linus' tree and have the conflict be
>> resolved when merging. Topic branches are unfortunately not yet a thing in MM
>> land.
> 
> Are you expecting the aforementioned fix to land in 7.2, 7.3, or 7.4?  If it's

Andrew wants to give it some more time in -next, so I'm expecting it to land for 7.3.

> 7.2 or 7.3, then I would strongly prefer to base v10 on linux-next (where the fix
> will presumably land soonish), and target 7.4 for in-place conversion. Then v10> can be applied against an early 7.3-rcN and we don't need to juggle branches
> (assuming Andrew is ok taking the proposed patch through the KVM tree).

Agreed. We'd also have to get the actual preparation patch into 7.3. I can send it out
and coordinate with Andrew.

-- 
Cheers,

David

