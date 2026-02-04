Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F876EA7942
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B046B0092; Wed,  4 Feb 2026 14:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C786B0093; Wed,  4 Feb 2026 14:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711ED6B0096; Wed,  4 Feb 2026 14:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 614286B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:18:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE5621402D0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:18:21 +0000 (UTC)
X-FDA: 84407735202.11.A3A3BB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26096C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:18:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sb130OWg;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770232700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVyqJw3Fj/lcw1lj1Ye2/0n090T7uDlr5zElM/14luQ=;
	b=pt5yw7OogI0ORYAHoBI4iO4CZwMExNt9raY/j/dLfU6oQHYO6RVg8yGA6Ak3K4ztnGensM
	MJJL9dJK6/i06k+8bYLFTGzH5IE0hUl0d7oND0UU7Ob5JIA49KzqCUUYVKgROhuWdfxUJY
	P2BpWM7D26zEGufWzlejx79k95Dt4js=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sb130OWg;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770232700; a=rsa-sha256;
	cv=none;
	b=jw98hxZjX/UXXTy8UTUbiduAsC3gjDHgS8M2cpkddD+e7gi0lPyIG7s1uligZoiIt2/NH3
	pJWee4LkZQUB0Sc6ODa6CG0AIPs9oDZ4FnJOR7AbpDMbdHAWyA9C9K2WgDkYbLltDz+qoj
	wtcye10SDHTiLoHndehke60c9PUM1mk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 290DF4044D;
	Wed,  4 Feb 2026 19:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212D3C4CEF7;
	Wed,  4 Feb 2026 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770232699;
	bh=avzQCaqFUqyIXFQfYFCxUvMl0Dj3mQFAIfQxWIjWZ3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Sb130OWgpLFTr086vbrLVXDhGiRA2dFSsHxqYeZBWauuRNcSjrFQrGGAtw5EDC35W
	 Ak5kGmct0g6a7aLxgxxFzmcA5klESXyRsveDz02QnGkV/ivzRCLyULq5U7eh7qjmSp
	 0A0tGP+WpQ5RopLOLvHQrZoMHPGQ+2Ca1vMNfLQxeKhw89KSR4Xy7e+lo2fC9XEh4+
	 4G9zU13ZEDYzRHTJaolR730wl1UjowNWpni0qSvubT3UrCLo0zD5Iq7P0UKP+TAv8Q
	 nMHrIOOL/cCP3jYgh4equZva18wEsxoivNzug1cqropFjNpfOPDYX2lUH3KVhJX9W9
	 +//n0WlqHinqg==
Message-ID: <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
Date: Wed, 4 Feb 2026 20:18:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26096C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: cxad9s35umx6kwyn6dqtf59ok3f35r3q
X-HE-Tag: 1770232699-77729
X-HE-Meta: U2FsdGVkX1+E+dvE9SxsELOpmGzsCJCDY0Ni2JDEqd7+KnGJFPtsHVOH8ORjJLAy7hDnD6NLTwlosX6WX7eEUgmQbxrAxyfRX+tFssYuf3fkD5eeYZO6XKLKuidT6rUx7iGZ8SUNnkJns9XgFek0ch7kIGTzamXv9kIMpw9vXKx4NqMkT1FQ1qTWsghpPsphpsLx5GZ8bqFhbRTnfrgJLu4ohU7glSUdssSuol7WhXbHC3ffHs5aml5E2Y6+PAtrGZxoZ6OSfgXOE2HalIRwvi3HrL4P1h4IbhyY2BavnQUBjYhPGVXXHbjQmqGUZlKrV5sA7n9ux7z6y0ns84QOQapiuYxrWSSA5jHDG2gjR8r3Oi99og4dE4jZmD2Lkyvij/CZZ2iwA65P5VxFYF2pbtkxtoOiemdNqcekJ2IJ1q1XUfay6anr/uiL9dbC40hzO7vYPQsjgQ0q9Qk0aAq2mOrW9bJwPstYHk8MgzijTb9gZ0Dt+b3EuOhYV/ou5g6oj5L7rpWBlpgRGi3Eh5HVRazObJB+5WJWJgg+goq/ZhuPvQSXwOcWQ2S8fMI+2S8ScJBHpolO9wsE30Kx/X6SwB39XOndyaNCFYAv2HYf4KpHHanoM2x0DQNOY8YutRGWf+RPKBskNKieLEN4+nDjFVDh8oaOQQrqtarBZAGWzTE/jPpr2e4VvBwqSdgTvX1bbMcWLcZ3CgsH8NvarspvpGbif9bXcxEAjLXUDd4JckKdQvfhANBkNcMFLyMfgDQE9z0RHpHTNzhGMFOYL2pWNVyLhqnqiW+jU6eDSCe9KxSZ8BUeUiHYbyGZqTG0Z1LK7pXQagtJKOq5VOdEJqTAy3wci/OK9sfdwJVi5lI6s9bbnC+H1lfNZ8hsRguv4muXS9U1AczHNgjq8rDjUGKXjpZ0x1/uhtAgNIbYE+ZOtkicocekRoJplLbfPAr9wXsf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 18:41, Zi Yan wrote:
> On 4 Feb 2026, at 12:34, Zi Yan wrote:
> 
>> On 4 Feb 2026, at 12:23, Zi Yan wrote:
>>
>>>
>>>
>>>  From the C repro above, syzbot opened a dev "/dev/sg#" and did mmap on it.
>>> Is it a device driver issue?
>>
>> OK, it is CONFIG_CHR_DEV_SG. And the driver allocates a compound page at[1].
>> Since we initialize folio fields in prep_compound_page(), it becomes a folio
>> when it is inserted into a VMA.
> 
> More details:
> later at sg_vma_fault(), the driver just handles a page fault by supplying
> a subpage from a pre-allocated compound page[3]. We then get a large folio
> without !CONFIG_TRANSPARENT_HUGEPAGE.

We can identify such non-folio (but compound) things by looking at 
PG_large_rmappable IIRC.

-- 
Cheers,

David

