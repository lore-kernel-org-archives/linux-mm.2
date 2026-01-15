Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A386AD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E506B00B3; Thu, 15 Jan 2026 14:40:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152C06B00BD; Thu, 15 Jan 2026 14:40:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047FA6B00FB; Thu, 15 Jan 2026 14:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E73C76B00BD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:40:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A14D513B027
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:40:23 +0000 (UTC)
X-FDA: 84335214726.18.9B53411
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD38DA0014
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:40:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCULaqSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768506021; a=rsa-sha256;
	cv=none;
	b=C8xN4dtZyxOc7wgnLygdnpNTkO+2MSPOnuxYqASr4sLJ9ikS5EilGdZuRz5X3p/CfRLb5C
	4Nuv00qC24XfLViICA7l44b1Qwp2ra1NRsriaLDKlEyWSLARZCalRznhti6QwuRic+YjIn
	ASLJxqz4kH7+eVriEWPj5f3N3WYbapo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCULaqSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNlN8Fx1T41hagDm9ehN0JVcA6Z1bodiNt/ppoVd2+A=;
	b=qLIo+BErhe0keAZzr4LwY5KSI2s80dLrcFXtxvzJZp+2jvp2d2c5XG9LNvRbXU9oN3ZQah
	gX9vZIxvJAQVGceIuIk6kFu4+4xfzfOaafBm4/l8UPGreZG5IIX40EQohSFuvAO+X4lRqv
	L6o5P2jZjsJtlXH9wlNtXf8ylOQlgdk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 343D26015E;
	Thu, 15 Jan 2026 19:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4296C16AAE;
	Thu, 15 Jan 2026 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768506020;
	bh=nLGaqWdpnH8fEEVBvwXlgYEC0zyBCL56gElb3tVuEgQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JCULaqSiagqhvxYAXnBf6QFqboCKJo9CFWcUgzbmW/KxbKuSq3ws3wJEZqOFjN7i5
	 ZEqFPJ5VJabscSnYwpOK0bwmhOGlZHn7L7ywxQyesZzR7i9yc80uDz+0diYQCK7r8h
	 +ePYH6HLe5Fny+wdLdQpxqxNCBOBQ2AOmors7MInu/5HnaEiatL2cp0gk/qke/tnUn
	 6ilQN8j4ZL+IvYc6LZtddA74UPBzh8jyxE37Pq6NBmi34aVheXNk7oyTxhlDnxPis0
	 IhdpPGmwT8OGdkT7uxj6LqI7rInF8pEJSvXAyhFyiR5Jp5vVAAnyFZC5nwXN9QzxJ+
	 AaZtzAWStrNQA==
Message-ID: <84a00b16-0fd3-4a32-bb7a-f117dcdcf1e2@kernel.org>
Date: Thu, 15 Jan 2026 20:40:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 0/4] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
To: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>
References: <20251223214037.580860-1-david@kernel.org>
 <fa37f15c-e5a8-4502-ba82-c077ee7b8e5f@lucifer.local>
 <20260115100501.2b956d74aabfe142d37aa608@linux-foundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115100501.2b956d74aabfe142d37aa608@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: frkajb4dm5m6mdtizhfndeqkmbbzxc46
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD38DA0014
X-HE-Tag: 1768506021-298167
X-HE-Meta: U2FsdGVkX19Vz/cc0TQZ9F5SKvMhwK7hHBe6s17Nvp8BWb4qd0GFkljWbFMsT6IdoJY7IkEzw9kQH+xhzeTRmonQYY8+EbariXgmI8n3/EFRo4vHYymj4WWGj5nCW9jFIDU0aq7tahr0OhcHBfkC4VSOzG2VjRilaxB7G42/m8+OHN3xlaHNNCGSAf7OmSinlSakBx7F2dM53XOlNXR67jjisENQcHhC+vU00Jq5u++nakateFXF4+BbvlIEn/zELxdTi2etgK4wahH7eb0cGxD2UJVCsocbp+5VbulCPyzItdNKbbUOZtVEmPXFIdFLAQP9ZY/kBxIWLVecvygPsplUPqHeNzoAQxOWieS8mP/0TMGzZtx+JpeapO11SrO6hWZ5tbYUlZROhfGIA75Aw1tJ/GBZrXmLm4Uw+AWjbtRUGF/n16Puerjqea9atNt41QqwqlWtkbSkI67um3BpvtJmooujTB8NM/cgafjXayi+zEKawNy7xWbeMKobIsRzIfGIhz9RcZ2Gs9pkiQAOgjIlgXJ3wCz4CC1bQKqKfbkLOXWh4pOxTFYK2Pag3/eK7XHKPlgI9qN9WjCAk7tWKmRXYtmOg8SfrcoImp6H8gqwKMGq67eo7Jm5COdQrlmDq9wu3cN75Nq3BkozJGjlwT8cXVSCvNRr066LfpLgP/7eoZy8C1I8FC/ZhWiWt/UX5zONRN/J3dohVxSqjpmHiasL8p2IZ31SNABOmUZHp/5VS8rJrXTdtvxclSdui3zYuTDvtE4VFcb95UK7iJTatb8XxheED3h0q5LH2beCwwPyKbDeL6rtC4qQN2RO7hN/StnVZuB5jw1X4qMxbEP5Izxu5tWPyMR2oMwAvwNWIyR63gCi7NaeZZFWB/UWsVHqjwy0s7/aM4+xZjavCRfWtHRiejcpsp4g+zHL6zqhstMNpR+hJII9CGplMUXQxSDp0W3j7qt4QuY8n3FPgKw
 bBEW+Hcl
 YrmxrUXffiw2mDagAZQ77QWJnNPm76kOdcJbYlfQbeyYXNKwDDk/iwSWqw8YDAx+71ZEhFN3/6/kKnqO9R637ON/0hVZKCXnyQb/chE31dDOFFRdc/xMeDpCwEa7hmwqYZvUJIglW2Tt8/81ruI6Qozv5RvPqBAxcXvRSHOCA8/7Z0mDkUCbGZws1lvqRwccWrQCVd8g2TBKZIeTPqOu1kKaiM9pLWezTCfRdOhsjV6F7IDrDKUdvUDu1GgSwRbIuCsN2UZBbzT5hotGoCrfVzI2cflktQZ+Z+K3/dkjgj3vx5f7KOkcKohDBekx9ms4sDaAXzlTHVAmVaktRFOAj2I6fiM2hiEy2mtRavOtGxp97qka1i14gBeUHCdCxAT6sZA2KCneY2WtGX1hmnYLl+urdPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 19:05, Andrew Morton wrote:
> On Thu, 15 Jan 2026 17:22:30 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
>> Any update on this series? It's a hotfix series and I don't see it queued
>> up anywhere in either mm-hotfixes-unstable or mm-hotfixes-stable, this
>> issue is causing ongoing problems for a lot of people, is there any reason
>> it's being delayed?
>>
>> It's received extensive approval and testing, so should be GTG right?
> 
> This has been in mm-unstable for a long time.  As the series had a
> mixture of cc:stable and not-cc:stable patches, I figured we'd merge
> them all into next merge window and let the -stable maintainers figure
> it all out.
> 
> As this is more urgent than I believed, we need to figure out what to
> do.
> 
> a) Pluck out the two cc:stable patches, merge just those into 6.19-rc.
> 
> b) Merge all of them into 6.19-rc, let -stable maintainers figure it out

Right. We can just CC: stable on comment fixes #2 and #3 to make 
back-porting easier.

> 
> c) Stick with my original plan.
> 
> <checks>
> 
> The cc:stable "mm/hugetlb: fix excessive IPI broadcasts when unsharing
> PMD tables using mmu_gather" has dependencies on the preceding two
> non-cc:stable patches.

At least one of them (doc update), yes.

> 
> So I'm thinking I add cc:stable to everything and send the whole series
> into 6.19-rcX.  wdyt?

Works for me.

> 
> 
> Also, David, where do we stand with
> 
> : I'd love to get some generic hugetlb testing on arm64 and powerpc,
> : that do hugetlb TLB flushing stuff a bit more special.
> :
> : I'll try doing some arm64 testing early in the new year myself.
> 
> ?

Not done yet, unfortunately. (I don't (yet) have easy access to decent 
arm64 hardware ;) )

I still hope that Jann could quickly have a look, but it's been a while 
already since I posted v1.

-- 
Cheers

David

