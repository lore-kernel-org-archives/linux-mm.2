Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259E7D3E783
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 00:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7912C6B0006; Wed, 10 Dec 2025 19:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769306B0007; Wed, 10 Dec 2025 19:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658976B0008; Wed, 10 Dec 2025 19:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54CD06B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:55:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB542C0530
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:55:39 +0000 (UTC)
X-FDA: 84205372398.28.9AA0D8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 54A7B40005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:55:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kiwoWh4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765414538; a=rsa-sha256;
	cv=none;
	b=hLRiA2vn2QY0M9vKbA3Y6kgwQgiFE2a5RFbaBAkNBDG/U+gjPYz9KceZofCB0b6e2IQ7oA
	lMh8NMxUUF5mNCC9xIosYgpDT6NGb59f5eFc7vd3tWqWoFKyiuH/CBEknuZvrXxc8P6uxU
	QASifDuc3CNoXmdwPdsPUQvXyFkaYxU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kiwoWh4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765414538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhDeDpL+0SCOROOTBZaXvoXQG8qd1ixdSD6GpEFwwk0=;
	b=pouFmu+JXQEsTxkMhmyfHg93NwASgE5S/s/3aQy3FspzZ91mjafu0a12Dmik4V8oCL1xjn
	YD33Ahq1+f0ezOsp8lnwxYWTXF0x4JZLW5L30HuwHJxr6CKRy1upJ5cMOfmccFQSLbAeLE
	yXoH91Dt5+nSQB7dtW3U9lQIlPXZVOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A73860010;
	Thu, 11 Dec 2025 00:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A6C4CEF1;
	Thu, 11 Dec 2025 00:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765414537;
	bh=mmnJHids8+nSkIZq85Pu+urD+05j91c4LH2HRhu2rmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kiwoWh4cp6k9wawe4ePdjIv69qdCmGmNg8BibmXSqvQeFYCUTdpMfqP/lzIQZjOyj
	 XipqZU0q/YY8IES8WnOjX2pppqJfN6OjsvEViMvidylU/6azM7ySr6baLBlD+1Txxf
	 Y4SYh1eE95mjIkL1WRNw17BMrThDZfxGofi0g8mRQp46MTXHhVlwPNu/kk1dNh5MyX
	 TJTuDADHfTuvUhAaAYch1h+r/Zph6YzaZot7SMoG+w8bsvWXn31KjlvoCjgMR0gedV
	 i/9F9qzEtpztZjwywrO4Dg2vDMp/qLkL6VRVr2aK6c7VjSqbvn1KavnNx4RRZQu46w
	 JPI+I6PQtZi/Q==
Message-ID: <83c42274-4c26-4a9e-8199-190336c18d79@kernel.org>
Date: Thu, 11 Dec 2025 01:55:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm/hugetlb] 0e1ad0324a:
 WARNING:at_mm/mmu_gather.c:#tlb_finish_mmu
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Andrew Morton <akpm@linux-foundation.org>, suschako@amazon.de,
 Laurence Oberman <loberman@redhat.com>, aneesh.kumar@kernel.org,
 Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
 Liam Howlett <liam.howlett@oracle.com>, Liu Shixin <liushixin2@huawei.com>,
 Muchun Song <muchun.song@linux.dev>, Nadav Amit <nadav.amit@gmail.com>,
 Nicholas Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-arch@vger.kernel.org, linux-mm@kvack.org
References: <202512102246.ee3d6d07-lkp@intel.com>
 <3966c02a-ec07-43c4-a230-8453f000a8c4@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <3966c02a-ec07-43c4-a230-8453f000a8c4@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54A7B40005
X-Stat-Signature: qfjm8aeg4ra73wzymkaahukjgobaathq
X-Rspam-User: 
X-HE-Tag: 1765414538-749017
X-HE-Meta: U2FsdGVkX18XWbUnNB4F9rSrY2Olu2K3gb/z2VM86MdNUl0b/pOARaeBDLg/0LueyeD4IHhYLWV6pe2i4Kg9nYrM3t3usdHbtm8WJrFKfzsrIdRYuI7yPFqpUFVZ14ejTqN/KwzfOT2fj0OBkQOCU6GpJXclw6NDMHfxgwL0z+Pp8dKpOBnqjXiPKtbGBsqVKrcVu7ok6fMUKJAeeCBh94l79s26iWbBGtCLR1HVdZMGeADRU3FpNhjE5+BMYUUSWsxwQkl279UMGLgt3Refb0/aLdEKRBllyaaJpCU4BN8GYOFlvTY28vtXtpDQuUPY3RTk9WTAWc4WUxr3WZ7EYREF7IiW67kzYlHYHC0MFubt3Xnw08wrS9P2ak82xGfK+LTnYFrD2w5kKs2c4xc22TvB3lv7CeiLgRHwgd6cKvHjRtLuOJd/dZx2jr22BZJOb0YlF6iH2W6rnqirFAJwh3i1U4bPzGe7cbBD+DJsmewYt+B7liA2ERqK3LeIvp+PavsN0t+soKNkSc6JUsOESE6Kmy4BA1YSVHR4Ey2hBxfLB9o4WADG0vP4WZSKXL0s6aVKw8xQbXPPJ2v1LsFOMSvt2QQuC4LRxdpGpAS8bJNo6okYuBR/NYPfBSH/NAd0ckJ3cVrtOTDlmsz4QPJkxWut85y+VGFXOnyKOpHA9qvAjPb64O/9A1807DN9yhbYiEy2xWes+4md3jEXvgM74J52PcYc8P9y/uAKCknE1HVizIjez+AhR56kIcETNZiSHdrPqPjgyysqGaK1Gmu+O2w/gFmms83OMmT+60OJE92ACs8j/i7mTlAN6qOqaoeamLrhsbcsqkXj+m2SSYi+F2EbQg0ydKQTGH8VwTjzei+fi4WBxFUTgIOMvpJL+t3MCIMRBT14SElxPn2RnN5d3KXgEeK+pfkYgYz3HMe97i5FJX/0lfP4xzzBdK2Ovh21OQWxHucXUvb5ASW5Ppk
 07QgLpZI
 XFcj/01kqexg0l36CpSzBZ/JsHOkhB/knZ6w82rVjqLnDTArfns5XN0h2Gk3jpTGPCnGjWD/rLOa7Aq6dsf87H+/sf4jA+4eWc2nXBkbw7JMhUDFUjUTGLNy5ZeS6DSn0/XKtSvnIzC7ZZf+yhGNx4pf9UAS1f01Rk7WDLkBCJuBpck2YrpZQuyOqZ3vqQG1gdxLvyyVUzXKRI1GWMSLwdSq/JNeQH+awHmB8HC/mVtBX0z97V6U1euDjxFkOdQEKll7nPRLlYWv8tzvlPOWuR0053RSWm74Ud4PjQbmgfkzHWigFQLCVNOawv4IZ8pCP3uZVKiqAcwE0h8XXWkpNSlcfb7ulb5eSrDO3SmYRJRqo7l9mGyw8Ku8T9qcOteoMaD65xS4weE1PqG3ZXW9N9pRvZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/10/25 16:02, Lorenzo Stoakes wrote:
> On Wed, Dec 10, 2025 at 10:55:40PM +0800, kernel test robot wrote:
>>
>>
>> Hello,
>>
>> kernel test robot noticed "WARNING:at_mm/mmu_gather.c:#tlb_finish_mmu" on:
>>
>> commit: 0e1ad0324aabb5aef3ef409de9a395cda7ee6098 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> This is the:
> 
> 	VM_WARN_ON_ONCE(tlb->fully_unshared_tables);
> 
> test case, so is likely the issue that Nadav raised where this isn't being
> initialised properly so is just spuriously firing off.
> 

Yes, I assume so. Surprised that this series is in -next already, so I 
didn't send a fixup out yet.

Let me try doing that later today.

-- 
Cheers

David

