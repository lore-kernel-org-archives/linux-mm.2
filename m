Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5C7106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBABD6B00BB; Thu, 12 Mar 2026 17:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68666B00C0; Thu, 12 Mar 2026 17:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B404F6B00C1; Thu, 12 Mar 2026 17:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A22746B00BB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:22:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D69C1C4A8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:22:38 +0000 (UTC)
X-FDA: 84538685196.10.5E7366E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9B65940008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:22:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mro02dO+;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773350556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcvt3vTqaYpb8zOMMJjOAabgH69xQpu814FDAheHjpA=;
	b=F7SaTGNi12QtRfN2y59vjg4WuQeibdawtTiRegFyVmDcR7qaeBrD5xzpFWUNUm+bwUovI4
	OuOw0zMXpWWr6BrYzrpieHIKIPszcAqJ6viwzdwcdy6aMFVt4WrPpxSdoZmdpZd0tmyH8M
	JAgJkJVrItYFuiXLkIYSwL/Qz2WFgD4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mro02dO+;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773350556; a=rsa-sha256;
	cv=none;
	b=KS/ve+YT5D1xF8dpQHm8z1ss3+7kv7o5CNpb5Psyqu9rvuIl4GRX6XgUzBLOtiSw2FvRkh
	K5syJzfW56RDe/QmWz2WV4mZaplIqkKcJLGFYPDVaiCpkrUc7XsstmUBAHxXx4y0hw52Cz
	ZTBdjL1LXqGxtDSHKnXzR4i5Tz05gTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D243560142;
	Thu, 12 Mar 2026 21:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0807C4CEF7;
	Thu, 12 Mar 2026 21:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773350555;
	bh=vXrfk40UtZbX0SqCHHqsOdP16LoMR78nLHdRm76+ZlE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mro02dO+YyFgDnaGXuPbgLN5GgvpSjomBgjxPOEDX8QhxT0RJ7M5QeY7EQTFblHwn
	 +jQLoHj3heOq50guPlmWTSueQqnadlOF0cjmjDAJAeoZ0IwvheYmgnDA9AfZMPvK8A
	 kLLNXq/lTRvjded7buEA4WfHzkiiksMRkdp37DEyve9lxrJtWc3YQ4GBaczagMg79u
	 UJI21S55B02VO2qlDVdoypuBc7vsHK4YIZjDjvtmovRH2N1Ex3nEjvR7ZlKeEUXoiG
	 OWeMTrLJKxZIWdaij9GFkwu0sovQMmaDh8ICqasn3ISfKMJqzY2KHFpZiUgxabqhXI
	 vwvPREQtBRXOQ==
Message-ID: <b001eb8e-3e12-4713-aff5-8cfcfea792e6@kernel.org>
Date: Thu, 12 Mar 2026 22:22:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 12/13] mm/khugepaged: run khugepaged for
 all orders
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032650.234386-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032650.234386-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9B65940008
X-Stat-Signature: p5nxye46yayj8keaybkxwuo6pntuqq93
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773350556-547780
X-HE-Meta: U2FsdGVkX1/lGucNL3Ii2j3TbNfEkdyCtwjqIltPcZaQzckf5murjNPJP5mHNvF0PnlCHHFvAouR6nJ0RIFVANisj4Ef6/NAVxPgPcV+ijGH2mR0HOFPobSh3WKeSfzVT2A/eaK/uhfyCI+n/XBAMwqpQlVm/TfQMBwFeBxqJKkbj2m1+GIDXcDYBZQHqCMbShtxNaeAAX9secacMDNHOZAiIq+jlf7BLtmWZRFuxFdtI/FHEmdutbVPxBhb5JD0LGLM833baWH+UrPbfZB77sXIGisqPMqkSq/IB0f/oTZwE1swakFVu6hGWzgwRVrOZgl8xdanuopaqS2Nz5xPQ+GfP+MZzpuAErGy6OSQNyqOZ4htGzdx3zJSIPP6cQBLYCI+riB5BMxeAvZUlJNaoOREYEZqBClJC2OrpasOD59f4oStHFJCfZMdLQChKnpoV6PBiBNbCGKjBpAcm9FDs31CBSpSbmxEHaE+eyM7Bj2Dz5nv08tpzargfjYV6/jlSCa8BpKU65GUHIEDRjfsaovPwsiS3tOEEid69EXWRqanlV73QlUWPEQ1D7bHdsIOzSVEF5hWL1LtxLtgWH5fD43wOncV7vEruqdrrenN4C5qzAHSAfkxPmz58SOqSHafcp2hChwvPNV9iS7ciNPq8WKYKFLixxX+IAziU+xJ/vu6qtqo9dYfgxDpXAYrGymFuEoFGPapWO+IvW0vGTodJiXPCesNxyHFYsl3mm0JlhHgIH4zhZFlqA0p1fxcWXpCdtQhVen7aTHLX0oKJloS2xyQx6I3YBTn6hJIZUwi55TX4GLEg172as6nVyA7IdIHRWWeAgt2Q2ZhGSpywZCbuWNdHi6fZeIaEbei1B6T7JKcEmE8TZoEeCNp2MyolOa2DmY8JYcoSQh72SbKERoMIggjM4/bGhi2D4b65iAO4SKN5OI8bYLqyfHWKPyM5hkvB8xMRXBzVfKX31JSML/
 0/pAkLZN
 NAgx0v36M7ntDjMY9FnUbfCcGIVeQbP4lotGqHsbek7WXKW29qEmVgTNVH/BJ3gdts87cXBFN9tnqtjdtW1hmaTygITJ6lGE/oboApEFLwbdy/Hc6LV/IgOaexZ6B6h9PLh3hWahCoG2x85a8yryFEHHTRBfNhQEJQ+DMnyJNXidwdYlIDqfz5Qf+EiCdMbk3a6DfDOGMZ6QxhvfGaNelDCP/JauJgL0f4ityBGef7WDiDHenpZBb93s4B/A78RP+GZJvhFBNLxaZ54irQ9AggMT2IQntUCYI3Vw5ECu583xxtIxPj29rr3xoxa+N7kLsEW3Bgk+7yUWIQgmNfylrHz5X4o2LDpgp1CFs96aRauEPOlg/l9DqFbDkTIj7tJuggM5HCkI3basJVo+xkCCg5UfG5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:26, Nico Pache wrote:
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> If any order (m)THP is enabled we should allow running khugepaged to
> attempt scanning and collapsing mTHPs. In order for khugepaged to operate
> when only mTHP sizes are specified in sysfs, we must modify the predicate
> function that determines whether it ought to run to do so.
> 
> This function is currently called hugepage_pmd_enabled(), this patch
> renames it to hugepage_enabled() and updates the logic to check to
> determine whether any valid orders may exist which would justify
> khugepaged running.
> 
> We must also update collapse_allowable_orders() to check all orders if
> the vma is anonymous and the collapse is khugepaged.
> 
> After this patch khugepaged mTHP collapse is fully enabled.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Nothing jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

