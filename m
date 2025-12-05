Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53506D3749B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8DB6B02DF; Fri,  5 Dec 2025 15:18:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88AA6B02E1; Fri,  5 Dec 2025 15:18:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E036B02E2; Fri,  5 Dec 2025 15:18:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88AA36B02DF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:18:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EAC2B8112
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:18:26 +0000 (UTC)
X-FDA: 84186529812.29.4E8C19F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8415D40004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:18:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GzuH+956;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764965904; a=rsa-sha256;
	cv=none;
	b=qMxxsuLewoFf9Q/0sq2HzeVLPjb6y4R6n/FQeZN8vh9gxepZINRoRyja9mU3c4cDmOKfvs
	1sIwQ/YrWci+kfl4H3WLkJKGBRxfMsrj7U6/n/FN5ZnUZiUlry9Q+Qm/iiwLq+gHiIlkya
	NamN+TmhN5J6sbPBBkr0uXJ4rlZgF9s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764965904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipnhun9JCYpSoxIgvOa6fJKBnTUvOlFwPhsQMnHoalk=;
	b=IccIlqXqLYIMuWKY5G8qaBdl0w6Ucias99DO1NBjftFVDSzoUKckrpIEnwOJ9mfwsyT4N/
	aCzfuvh0Ljvnk6xT/w79lH/ZtZdweCJwD2kQYKXtnV7zJsNg4B6q4pFedDzqe4zz/UuirU
	spA3FXJmn6lJtx5uAaUehHcaZicudyc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GzuH+956;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F28C360138;
	Fri,  5 Dec 2025 20:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2623C4CEF1;
	Fri,  5 Dec 2025 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764965903;
	bh=HQuk+LoAt1ilJ9+l61gCZEqNMa+zVqm+64YEoeQNKEs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GzuH+9567mOPIpXag3z4woawi3CLBh4zMhzSRFmboSOtbW7UriLFohM5GrBEMfzOF
	 Pr7GUS4SVmWspQ6MMaXW5tV4l8Twf+SG7qIs73eT9lhKZLu8Evh5Gm+UCp73zHLvMo
	 IuACR/G6fW+Elvl3OuTY6/wlYIBx3xFTEbk0LKMPHULzroa4DmVuppLhVhFB2gb+KQ
	 0yv0eWOiHFA4wyn3xOX17J3lMR/1jl7Ii37Zm14qDtcglmJOHdAw38h7NDuC2iDVEv
	 x+EKiklJUNGuEmYfQaF6KOylBc+xRrkEhpUxB5X86PwQRIU3XEjnvf2ZHdIZsp2N5l
	 GAQGxE/VtL64Q==
Message-ID: <dcaba52e-7af0-4a36-b2f9-dfc2f83a4e10@kernel.org>
Date: Fri, 5 Dec 2025 21:18:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
To: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 oliver.sang@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205121501.bf47efd78d0a1a8f0370645c@linux-foundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251205121501.bf47efd78d0a1a8f0370645c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8415D40004
X-Stat-Signature: mbn77ydaf45wcu68k4tjhmtard5ffeu8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764965904-389201
X-HE-Meta: U2FsdGVkX1/CL5bBNEDFkyJhd111yvT/sZ5DG0Ajd3fo1JQXELGdR04Q3muC5vmT5HRFI3hFgXX20+3dccsLZQHOWU/A6p7vNjeqkVoLWRnQn64ffnZk0AcoTsjRal1f3fTCWTIH770mfW8niZ5oVlzI/kEA+EqW4NqkT7QJkWebECyKVTNgs6dym/lbRLgtP1IWFwkjM8NaYmKRHSvRnBHXCKwYB9z+Jne0C2bTjI6HVCzpzWH/npFeidrpErIHjfY9E3zhAwSjs1CXaFTCyrFMNmH4QW8g+MwRd1O9S9nd1guPLy5cFmQWLmRfFH96OjXBjN92Zxs7q3haCgnjyciFIKMC92ppc+c9kPMNv6Hnub0PNztXF0U13aq38FVamOmgaJMwQY5MNxN2BFWn06BHIygzUyYnp2xLwx+Tz4ApEBZhwoekrcIxlEtpT7TJBCiUNdN3bYA9RTF3hga6YWpjwnCN31lJ2qsdM4marYBGEtwpL2AGXIrAHzV21MmrTVP6TtVnYkfLQJmUmp3qMlGvFDeUq6lZEaDdMcqatrOkLhXX2v06ihbVRpauy+uVfdwY2xyCDeWWOpG+l1XZrvrWoPAXOMJELLRUQDXkgGtkqfOBd/pVMKUutq71HGVfAllJk1fZ58bNINA8xchPncfPoGyHjspMpPvWiRFXqy7cISJYRZd6fCDKyPxv05RDZOKarUXHyRZNW7Bwus456/bxHl235oXYwHLOck9oRGcwhJUyp5WoUW5u6xHA3gfcb/ohdkWqUv/5caAuKEGQwLXJS25oIJGp45tjUs88ViVWT0fdEotxzqN8RA759GQ94r07j2hTlTqhcNh8joCljJYf3Azu8hFfeWHEGyz6P0e18AWOiUQPVqA6gJ5uh8In6FZetulnUXJAXc2BtYvyP4hvEpFdhew/gCpnWHfobPLcqmHe5K+4sYb+BAy6W3IicGoOQsir8P64JC4qz9M
 23p3j4Ro
 4MaMjFiCMUfre/+6u91aOC7lY15oRV749Wks/u0XZIAdtTPOMFml6BJVisQZ8mlxAR9HYBKnvSkg/F+ZHTUJ89NvY1Q2gIkRvaOpqlAyORFG2nT8UCL51E1MkySpgCW0waeMOFe1aPwBDt2i52wnXFIXbCNUmQIsguS1CmDF0nIwmGfHGbz+r1jBEBf2B96KBK4lQZNLVbML9J2f1XEwxX9U5ud9niMocclQCmcGg2EKStmbZRPb8EcIZ8xkNi5XAnbVdeRfH/6qPcl7HtGvcam5aoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 21:15, Andrew Morton wrote:
> On Fri,  5 Dec 2025 17:50:37 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
>> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
>>
>> ...
>>
>> Andrew - note I've referenced the linux-next commit number above, could you
>> replace with the upstream commit hash once your PR is taken? Thanks!
> 
> That's in mm-stable so the hash shouldn't be changing.
> 
> 
> I'm not really sure what's the best way to determine this.  I use
> 
> hp2:/usr/src/mm> git tag --contains 2b6a3f061f11
> mm-everything-2025-11-29-19-43
> mm-everything-2025-12-01-19-02
> mm-everything-2025-12-03-23-49
> mm-everything-2025-12-05-00-55
> mm-stable-2025-12-03-21-26

I asked myself the same question a couple of times.

Maybe this?

  $ git branch -r --contains 2b6a3f061f11
   mm/mm-everything
   mm/mm-new
   mm/mm-stable


-- 
Cheers

David

