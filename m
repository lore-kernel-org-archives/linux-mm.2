Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B32CC103E168
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C204A6B01B1; Wed, 18 Mar 2026 08:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8316B01B3; Wed, 18 Mar 2026 08:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE71A6B01F0; Wed, 18 Mar 2026 08:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2316B01B1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:41:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F2F9140710
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:41:23 +0000 (UTC)
X-FDA: 84559144446.02.ED35902
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 849E0120012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:41:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OYbuI4Mi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773837681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUAfpbi8ucwJ7nv+02Y87VuJJX3elyEORN3U4dh2TVA=;
	b=B6eyygOAweRIG2rb2+wZeBW9T5BFpSOg07GmcN5SOwp++Q70njMRAq3aXdWgOrd5JaU1NW
	/TTRyqTB3OaapLfnRgyhWm0gJOPQwkwjCh9NtiEGyDBm2BA6KbEguB8wYfAdEZXK4HPxpy
	FyPyXipzupWDiHCkoZOQPZs+3Zj04Es=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OYbuI4Mi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773837681; a=rsa-sha256;
	cv=none;
	b=PhqUcCleBE5RtV7k/aUXGUsrN8cv8ZmCxaQazSkKPymXhgYsVYMo7gSah4s7HmOGqdX75h
	Sl81jVed22qTlyjXPgbsmcIpxAbo//TG9z3fkYFOyTJlAKp8/uf0NFw2gm3ofaD+7WURbc
	60PyOAOfDgsJd8dIWvqK3FlKSzuYfYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B366060132;
	Wed, 18 Mar 2026 12:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E1CC19421;
	Wed, 18 Mar 2026 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773837680;
	bh=3cVeNY+pQvT7y9XfiCK6KuJy6FGGhon85ayumpItLTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OYbuI4Mi7c5qsUy/G/ZYGrvOHFCTW/szfFBZDvDH5aP8kIIRGZbUSLe3/qhHSrc/Y
	 41rmRqo4gXjwtcd2pIfDtDknzJR/xDeA+GOJXyeDS1IBuazpueGcf+FqLyyKCVAiGH
	 FA6ikYq18iYHNxP26mEdGY87syEk0AhR9k3CgUR/3F7Njsz+gc+bdyfihYE2u5XssX
	 vgV7L7EjIhROfN0YidaQoPfiknxjUtXy9WkAZUlfT9zyCwW254gDon8u0nSJV4vCLz
	 b2Um5Mc5dec1zf/Povf0u+Gh4REpE7RGbho1tXzu40Rz4eU5kxTb8mNQnrx8/CruWb
	 24sGJW49WJBXQ==
Message-ID: <b0f969c8-b227-40e9-946f-89748145a220@kernel.org>
Date: Wed, 18 Mar 2026 13:41:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K
 pages
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, ryan.roberts@arm.com
Cc: ajd@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, jack@suse.cz, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, rmclure@linux.ibm.com,
 Al Viro <viro@zeniv.linux.org.uk>, will@kernel.org, willy@infradead.org,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com, WANG Rui <r@hev.cc>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
 <608c87ce-10d9-4012-b6e9-298d5a356801@kernel.org>
 <9e9edebb-3953-4bcd-80e2-614dcec5b402@linux.dev>
 <be65e710-997c-413c-8455-2d687fc51fc6@kernel.org>
 <562fb349-c2d2-4fbe-83f9-75c26cc4b7ae@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <562fb349-c2d2-4fbe-83f9-75c26cc4b7ae@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 849E0120012
X-Stat-Signature: 18eh7bxqfupixuw3yyndjax7q5xzzh51
X-Rspam-User: 
X-HE-Tag: 1773837681-113723
X-HE-Meta: U2FsdGVkX18k2/b1/dJuwqyOrULkPC6UHMpUzH+Fmyp4ZeNn09kduZodZV6WtbpCncKxOoxrJ22zb0nGPgV06o7rOdYEuy2pBU4wMbkvbnNJt0dCdv1w4/KukxafTA4GTUWV3cA4V2ccK8v3jND8GTkMHj9yVpRv1ayZtY6uCXTBVxCKOaLT4af0JfY5/MfnH8XbhOqVZZZL18+dXenD/meWYfT6BEIYnd5PRuGYEcBxjwtlQ1kDzYwY3uantZtvqOgSES56RgrjP+mIRTMHKt8g0xa2SbLVlm4x1Wlwrk4CflxmyVmUYLYOPwl7BLvDROhtW2CYh+qnXtX6aKb3Jt6Hyes7Jdx+F2QweC11rRMYor9yn++YZjqKeDzK97uSMO60DJM8tybqYN5k2mTcpKjORk0p5ObT+WYIETSU0N4UXDa3Ay4wiMl1Jur7T0Pea3riouJNQcSXUbQHbtfOdi8Tpe+cb7SbMBhXRj64lwtcY6IeA3cxrTfHSB3+iEraivfUOig/Pl7nl83ptEF8vmgCGVufZe+SPSDH9tuC2l2/n1A7heR3z+NxnfcFlJvgC7/4hbsJBAARHRsOoOy9N5PhCz1HP4q7yq1dHNr+q7ViJDmD0A0xiYOdB/DSJ6a4rOPfchS/EBMYzZhE5IT+11DNuwgpRM4dtIBb9wgtxo8tI9b246SX/mRA7ZueinzoKOccEbjdjqKzwLThAeSDnhXpJVSSWgsaf+URVH7SjWM874wpqIlB1+5t33XmWH1YM8nY3mxCs2GWweEmJ6X/tZpoOJciiyRG9ELNsZsE2v6yizF2BkQEmxFfCz0LnNav56OJQQKFPkk/ddMpKVV4Q+4Dj9nrcQXmolqzCwisdrqrbpwi/4f+RWbbyBP4Ai6kT9ZrRD6wUl1FdDxYk4CDflvr6mudRYl1XhS54VTPP6yK4wR3nzAzvNGnDK7Hn3OEtsuXknUAst7vii4t97d
 3QhoDWN4
 JJYt34lPNOCdtuXwpwa4PdZaKFVFAlwFzr/pFE5oR8BlyXrWQ4nFW72PBqaKeR70n8yUYouWN+RlejzjuByg05bUVZDERdmcxR1p6B70CufyYXBDHmazA1aHtMfux1bVOb31AsppsPSRCSHDwrbeQm6k9O3fF8QVowgGtadmqsohB1+NcN00byXqN711HQHQaih0GP8C6qQqiK6bR55YBhzMOlCVPEr56SsjNOuU+Y6qPF1z5Gt2uONV/RqU9HjPf7SJP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 11:41, Usama Arif wrote:
> 
> 
> On 16/03/2026 19:06, David Hildenbrand (Arm) wrote:
>> On 3/13/26 20:59, Usama Arif wrote:
>>>
>>>
>>>
>>> So I see 2 benefits from this. Page fault and iTLB coverage. IMHO page
>>> faults are not that big of a deal? If the text section is hot, it wont
>>> get flushed after faulting in. So the real benefit comes from improved
>>> iTLB coverage.
>>>
>>> For a 128M mapping, 2M alignment gives 64 contpte entries. Aligning
>>> to something larger (say 128M) wouldn't give any additional TLB
>>> coalescing, each 2M-aligned region independently qualifies for contpte.
>>>
>>> Mappings smaller than 2M can't benefit from contpte regardless of
>>> alignment, so falling back to PAGE_SIZE would be the optimal behaviour.
>>> Adding intermediate sizes (e.g. 512K, 128K) wouldn't map to any
>>> hardware boundary and adds complexity without TLB benefit?
>>
>> I might be wrong, but I think you are mixing two things here:
>>
>> (1) "Minimum" folio size (exec_folio_order())
>>
>> (2) VMA alignment.
>>
>>
>> (2) should certainly be as large as (1), but assume we can get a 2M
>> folio on arm64 4k, why shouldn't we align it to 2M if the region is
>> reasonably sized, and use a PMD?
>>
>>
> 
> So this series is tackling both (1) and (2). When I started making changes
> to the code, what I wanted was 2M folios at fault with 64K base page size
> to reduce iTLB misses. This is what patch 1 (and 2) will achieve.
> 
> Yes, completely agree, (2) should be as large as (1). I didn't think about
> PMD size on 4K which you pointed out. do_sync_mmap_readahead can give
> that with force_thp_readahead, so this should be supported.

In particular, imagine if hw starts optimizing transparently on other
granularity, then the "smallest granularity" (exec_folio_order())
decision will soon be wrong.

> 
> But we shouldn't align to PMD size for all base page sizes. As Rui pointed
> out, increasing alignment size reduces ASLR entropy [1]. Should we max alignement
> to 2M?

That's why I said that likely, as an input, we'd want to use the mapping
size or other heuristics.

We wouldn't want to align a 4k mapping to either 64k or 2M.

Long story short: the change in thp_get_unmapped_area_vmflags() needs
some thought IMHO.

-- 
Cheers,

David

