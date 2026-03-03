Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECD3EDA693
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6408B6B00AE; Tue,  3 Mar 2026 11:14:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3A06B00B0; Tue,  3 Mar 2026 11:14:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9256B00B1; Tue,  3 Mar 2026 11:14:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9266B00AE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:14:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7B38C0A39
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:14:51 +0000 (UTC)
X-FDA: 84505250382.09.F2CEC64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53A02C0011
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:14:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jRQ2XIu2;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772554490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrZggvRGGcrcBDlOQ+gO0tmy61jEc+N/Z9NHTG77c78=;
	b=SeQEYA+oDv7KajcVef/LviZOXSrXVToaZ4K9FpfhkjVsOUyR7hhUDtBLaGYearkRekEnDV
	VPVeWqxS0M2+1CiRelRbETzO9aZQe8e7PbUOATykRJMvm2ptPXwoOJ3vXspgO0ZpWk2+7Q
	cDvJHNo+5QDcvYrKefhfq9Jrsbok24k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772554490; a=rsa-sha256;
	cv=none;
	b=4QqDsLxLs9D3OZ3MDHYaykN7YjidoK2CVcHt55wnijmufQxmnt7crD7lXgwSyMn9HT5ZI2
	FY9jCpestrs2XuClC+5TsFmfjD5h3q0Z6Bd8VPdqSR6nknWjUMtT/jS2Hlo9mVLvyNPS0t
	nQDmtFutUAKgTuQ7x6MZcH9iaPOUXZY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jRQ2XIu2;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A825E600AE;
	Tue,  3 Mar 2026 16:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625C3C116C6;
	Tue,  3 Mar 2026 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772554489;
	bh=HM/Zes1va830AGhZ9BQ4Z6bkRAGx4WmyxVltQZwxE+8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jRQ2XIu2l7qEdW/I7/ya5R4ds+9PhUcTpgzxc12HxefTBRiSk7+sjeAETpF725Nh1
	 2xJPkrnB4TLmzDx568/s1XOhHPCEzwyaGo9nwGA1c8zN30bCSfAvTdxmKJN3HWiRoy
	 O1YHVu/9UOb+6WtbEhnM30VAn2OzrTVd/3wq11UGmOvXR+zqqXvsCBLoD+M+gEyfg/
	 q6Z5y4VpZHxnSQ5TVA350o/m1Y/3BYNucKMnyMBSvoQ2tMVfRHE8Ync0+4k31uDfci
	 EY8AYP8hPhvgJPFIlGc1kYmR6k2zT3L3IOQyUXYlUE5Q+mYPj0nCX5h3cLI7l8dRek
	 cAwegQJDDkHDA==
Message-ID: <3fb43e7e-8e00-4cd7-84e0-da4c88231b08@kernel.org>
Date: Tue, 3 Mar 2026 17:14:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org> <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org> <aaX2B9Efh0dBed6c@tassilo>
 <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org> <aacGi1DEZoc00Sv7@tassilo>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aacGi1DEZoc00Sv7@tassilo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ur7xmibgyk1iwgxn4fodjcnegs78en9s
X-Rspamd-Queue-Id: 53A02C0011
X-Rspamd-Server: rspam03
X-HE-Tag: 1772554490-786761
X-HE-Meta: U2FsdGVkX1/zRgVAkhmpOZGsc+sVY2Mep5ZHznhODxOPQGM7IP9l1iWoSQyFvBKpS24jnanesbbmvSimvamrCJkmJfKhAp+P5C3TSUPsm0Um4IkgyRBkORE/2sI51U+7aTWjqB7DNLPNroUME34oQp4Nzr4OZMRU0xFPcuDVPttHHh9odgC6kUZ+SDrynm2Dpl7sm0cmN4RkAIH4s8JnA9rsErUczPslhXqACfxDRlbbBbtYLHn7/awLwRnmdquRPfFO8k7RWZzF7hkjBzQlLtN3oZUx2POH8xwHtARRy1/PToFHlp84M0j5P0Ha+f7F7x3e/8nsHRtPt7xHMuBZVj8HVGQ7uY41lpUnv9LM+K65FWHavlUQj6cNYMvA6XOUZI/TSjTOqhKEPp7m3QMa3KyscHVyRAsKXQ6jiOvDTWOXcY6HBzPmRtzRktdn/RUtJJK0m5iKyPMUrXz52+M9rVPKoBZ9OBVUJJHivXQgAdEsKwUWdt+nYCDogidhmg4uqQ0Dqv/BDI1SyDo2Gz3N3QXsa3rcl4DSyDKNdaOP0pp4DEe+bwRHy8Vsr7Pezyhldry5VtcjKpFGu/BW+d6kMLZzAKd61hY4VhkhRtpNGCHslmVc/tVePQLPMPUMtqsu5dfzVyshoZBhZlHsAhrjgI7maF0WUODLMHqlHigUVuCsZ3b/LryQc4MvFzMeWRl/YG+ZrXK9AbHLR4ZuWGDKn5U3VnoMHNx2rj2fNncXS3sN4LpL1ieLCVTu+fsf+Ns6EF8YUKVKDA99NBNIO31X4vuLBxmQ3MrihVqgqs1DKlxMzYiDmH5TDYWiyTwLTPJAbazFtK3NsMjiMSvVQkDuJ6xHKCCNj2KVZyPMPyQYfAtQbrQM6nKQPIFq5COtgBH9y/cEDd03V0PbNbbv8tMglr++lbi1RBmHOOrwIv+2cFuAJWr1wokIyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 17:04, Andi Kleen wrote:
> 
> BTW your comment earlier about partially mapped compound pages made 
> me reconsider the code and unless I'm missing something the accounting
> is all wrong for this case anyways in the current code.
> 
> The code currently calls smaps_account for every PTE, which will happily
> account the complete compound page

I suggest you re-read the code and realize how the misleading "compound"
parameter is used.

-- 
Cheers,

David

