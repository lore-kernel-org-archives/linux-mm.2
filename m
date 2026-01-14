Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE0E0D29FFE
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F446B0005; Wed, 14 Jan 2026 07:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1EC6B0088; Wed, 14 Jan 2026 07:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1056B6B0098; Wed, 14 Jan 2026 07:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 038396B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:35:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC22E13B041
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:35:12 +0000 (UTC)
X-FDA: 84330514464.15.CBF0C1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E41B240009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:35:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAfDNxFS;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768394111; a=rsa-sha256;
	cv=none;
	b=tvlDcTWCecqIuqeuRJQST+FQ9Hb+f942FgQRdjcVY1nWSRPBy0jGuaEdHqK78l6IOaVVnU
	nTd5bEqNEEX0DjtAiaMdrgIvCEg9hqB8QuQbjwqKbP/yw4lA8vm/72wMAQe4uURXuueneZ
	zW77n0kAahLKmfoqAHhSb5WPQaJx+6o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAfDNxFS;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768394111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llj2dkqvkc1XJCZtSI9kTU5e+oETf00KSuTbXHQEWH4=;
	b=MZZfnEamw6K71f7gAk/yRfHlYiKtsDrtIwfp8cBggNgRbKp4THVMH4Mh6k6eFbEtwMqACx
	5umG9NWy1OHrazDHvO+5O4r6y6EogHdsuZCwMpUHfC7Np1NQjp1pOjJZMRIU1EIMyO9UWa
	Flk122dv97Dp5WrcdrBb7ClTXXnNYCk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F26E643699;
	Wed, 14 Jan 2026 12:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516ADC4CEF7;
	Wed, 14 Jan 2026 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768394109;
	bh=y7ks6oY9d9Q4DYkcqLMxQYtbLOi6piXmD3mlg2qqFYE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mAfDNxFSv20EHeiytc8Wgrn7dY5F/8OaJhCIg1rqU8Jdwp3DIYNtpZ/dGQgZJPgBw
	 98CnJHQgnuXpp+neaDVlVCbapWy69yJOtPQZhL5+1rEgbOoRTReEfpY03vV4Btp/bN
	 N6br+ZZQ6INYvN+s3q+R7CAfK41b/tZFuupMozFGaoIKekaGUAFcrHGFdb/0Yk9bDH
	 e0glnOPEhe7b9eoVK7svCE6W/EOirGLpPMxUcsnLgEuwF7HZzFkeoSPVFgJFRGymrd
	 7MNKMmmH1ffH7dgCaIX+g/MTrllS9kVDsB3PQ4GV8tHYl51C2zswUcpWGt7FxO4C4v
	 UhAdeOTq6E47w==
Message-ID: <fdcf51d1-9aa8-463b-82e6-97d6efe3750d@kernel.org>
Date: Wed, 14 Jan 2026 13:35:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm: remove unnecessary and incorrect mmap
 lock assert
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 SeongJae Park <sj@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>
References: <20260114115619.1087466-1-lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114115619.1087466-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E41B240009
X-Stat-Signature: o981y6t7y88uu5qjyy8h1r3waersjwtu
X-Rspam-User: 
X-HE-Tag: 1768394110-458721
X-HE-Meta: U2FsdGVkX1+JmvG2rgfT8WVU9eBBuACLRNpz/MxBHU6aaR/NxvhUvBRQoshaQIXwgxdmYEmI/Ca7Ha3jJOWZnvNReDYS8n4SO3O/vgA+y5KALA3rCJHO1gFYPF1G68DKjo3utzc/Hmrxoz7bt90roYOSyHh33EMTKFGgm1WstYdcqp9QDKv28VM8/JPIl49VvW4bZ2nB2WWxaSOsDXnUymJ6kIoEP23wHKtIJhjysG0p/ug7jcf7j7V3YSEY19I5fF7eDRpHDn+DvxPGWkqe6CfNhQnM4rfEDeqfo0AWl8viTjTofubdMUTEwPB7nzm9HOk3YTRpug29WVqDoNJqUpvXIQRk6GOgR2uqb18w+7UwblYbc5BWU0XBd7/MUIAwO8zgofrPfUvO512+Bg7ZKFB6VRmBteFsqe9f/YiM7NdoZzLXyBxufNTJmZPXnCGjZDlvdqfT+UrCP3cj104YacwQkyHHcCeq7DrErlpMMP5i60eYD7+2gP+B4MKNNl27xHobdLnQfWHiHyCGwi0DVyUU4b0QCvt0D0SemgDmjKBb3y2V1HYoqMFpobi5tD92mA+o1Wnw9mTv+k+GruwiH3iPgvvKsfvzjQu1oElLEVV0qyq53NIyLdx+066fr63S/j82L45old8OjhjbUP6ay8hZ0Q+ZKT/A0YujB00o9/J/Nknp7xJ7gKhfSHhuY0TH1PhkoU3Wgk9Nz8ZPlsp8VfqleyiMvV3k8ekZ5KM/6dv0ushIyA77mkqexm+tvbGdQoy20PHVGEr+Z13HbElLWm/jz2R4dJtxrI+JQNt622TQPkouPAzMbKlSSkC4fvGWWafar9UmGRPsLPLgG8tjS/dw3A0AcTxE6NWfopiVhuOoGnPDya4gVmg0B0B1opvdeSkcU9oLjz7Rw/q9urGxt3XipVNmAvn/+mRKjF4nKPGU379emgK38bgqnwLP60Dg8Cibl2+xmVKMN3SM6qR
 l2g5nzqE
 J/PSlrDRUN/wuC5CnOjKp/PWQ7TZPXJ8AVGxZ9CnbpLSW+SkD2HeKrUwBFO+PhQjlo+ExfodUxJ5q4xw0kHvteSyOpABte5FcrF+Dj7s70tVlbnfn0eQEM2jcuBLY8IDGoXcbSRosxpO0A2C5yj99GTQNzv4YwaLyB2gN/mUwKA+2WkqtNV+LLVq9kAttjSk33kHDnUYjJ+NoVZgeRAGjtv4bgjZ+q48BFhRwHYr+oM3PMFA5yD1ngkqTSL9NTYOgtgatitnAdEmNtLv2arWpjaLkOzUcISvYYwtGL+cIFc9sHsLHwHiU5sJFPcwWEWOpYeZPJqSehmMigYbvmm5OYmASBUxHkEdvk1FOs3swJ2pubV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 12:56, Lorenzo Stoakes wrote:
> This check was introduced by commit 42fc541404f2 ("mmap locking API: add
> mmap_assert_locked() and mmap_assert_write_locked()") which replaced a
> VM_BUG_ON_VMA() over rwsem_is_locked from commit a00cc7d9dd93 ("mm, x86:
> add support for PUD-sized transparent hugepages"), i.e. the commit that
> introduced PUD THPs.
> 
> These seem to be careful asserts introduced to ensure that locks are held
> in general, however for a zap we require that VMAs are kept stable, and
> this is a requirement that has held perfectly well for a long time.
> 
> These were long before VMA locks and thus there appears to be no reason to
> think this is assert is there for anything other than 'stabilised VMA'.
> 
> Asserting that the VMA under examination is stable only in the case of a
> THP PUD is strange and unnecessary. If we wish to be careful and assert
> such things, we should do so at the zap level.
> 
> However in any case the current situation is already simply incorrect - a
> VMA lock suffices here.
> 
> Remove the assert for now as it is unnecessarily, incorrect and unhelpful,
> subsequent work can introduce an assert in general for zapping if required.
> 
> Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113220856.2358195-1-clm@meta.com/
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Makes sense to me

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

