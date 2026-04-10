Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4135F36BAA
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 05:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374DA6B0089; Fri, 10 Apr 2026 01:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C6D6B008A; Fri, 10 Apr 2026 01:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289546B008C; Fri, 10 Apr 2026 01:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD0E6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:30:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A273C8B697
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:30:34 +0000 (UTC)
X-FDA: 84641521188.04.9B64452
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1CD7A000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:30:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pAgcGKUF;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775799033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qXV7UNwHR6rttboRmT/7aSKjzsG69njmQm48zi2xHo=;
	b=r2VSDrYtYkg1xnvbrLSCSwOPlzoMtGAMbjuXCScCQED6NIYx2K30aGEJIUVmB/OTl1iHLT
	99ouuQ1qztJLAPRLNUtD8K2+O8Njvd3o11R1u4uErrbYtEtpg/PFuTXNCExybE4UdcEUQy
	O536FjxpuIfSWgSXYON5G0taz9iJp+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775799033; a=rsa-sha256;
	cv=none;
	b=znkM4Ii7/eyVSgITWQSl8YPu0t1xe13QdVPLrn2JjfqRzvc+0/QlMGyf+gHNwNfVsJ9lNz
	JeI4e7dh7CEl7wYX75t9T9S/hDOUAPkKZDAmL5y9dv/eeZBUHaB/0T8JG5n/Jmztu7sZYx
	zI0esnA9v4ON92BAaxZgCUjav4ItrJI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pAgcGKUF;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D84282008;
	Thu,  9 Apr 2026 22:30:25 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAFD53FAF5;
	Thu,  9 Apr 2026 22:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775799031; bh=G8k+wf8sxRtAbSVAFMjynOWx4nhCOUiQl5JR82uclTA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pAgcGKUFPcmqcSGKzUfH7nLwJKsdSljWyGBHIdKx+8b8fUDXYywKAnnv1cjrSYsiG
	 Ertxa4ZqReOgzsGxkJsZrto/EoLahijks7RmJHy2Ou97NaTkJN7j4K59/bLN7zdhkd
	 6/RmOE3X3nlyjferzBy6Ln/oVRuJLouqFvEzMRto=
Message-ID: <37a7e502-ac1d-4573-a877-23b1bfd07238@arm.com>
Date: Fri, 10 Apr 2026 11:00:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 08/16] arm64/mm: Convert READ_ONCE() as pgdp_get() while
 accessing PGD
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-9-anshuman.khandual@arm.com>
 <e294a87b-392b-4b12-bd12-70c66c793fcd@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <e294a87b-392b-4b12-bd12-70c66c793fcd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 67wi9mze34p6icdbt99h3edpki8hqe63
X-Rspamd-Queue-Id: A1CD7A000B
X-Rspam-User: 
X-HE-Tag: 1775799032-413280
X-HE-Meta: U2FsdGVkX19GmBi9De9yBzzdCnGZLrId+9ZJBxC6jBmXN5SyxSa+J8gDQQ//fe+RxU27Z5jX0pczd8r2zIlH1WplIQTeX8d3XlI4e9mSFidJAVXewNhaGVQnBZqNa08GfMAWL+lNu2WWms/NAVHUg50ZBTwkIcSRquST5ABYXM5R7NP/JpzNfEb1V2p3p78vxLTPbQLhIXCj0KCPOeSTGg3Kv8wuGa5d+FjhKLgmhOC5fKq4b7VCwH71INzl2CND+6p0ENUuJ2s0HgpAUoKzXPJGpt2tZTyF9i3G6jMkPhd0IvcFexHERVyMthTQfgsHCqC0TvOxQd3ZIXDDUxfE3+xdNKi92s5idhvn8j0XH6TbUsHMsW3hTsXDDGhWNQ6kMFo9c/JaVMf061jdfT9nAgWYASP74Fhllc8UbmAW/0C3Aig0h+1p7ghROCrDKUKIBfVI1C7OCyXy3buo2bGUfMY2VY6WQ0u3ZUqxfa5QshHqqWoJksmMs5oW+nuYSUPTthsJvwR/WFJw6t0lL3uR9g27MQkDY2495tLcbOTi2WYR9EWgMw8pLo8EQoO5ilsXqEpqOfOH7ahmcRovP8OuckKQS62r5HDKqEZiDcRp1idz0+nKCP3Y2qgNPx/yrwcLaHAbw4Ye9d07SXsoUmRZMQeaEibrvjaGOPM4QANLHP5rQGyd/qtLCAvNmKZ41POf4xeMUFoGrGTsTy19tny4NzzxxLXe4DNFCdQA2h/sLxU2rzvKhl5x4ZpNpMRxePuvckx4rxct04QkG4gYSMW0H01yAFVY6yd3sAjwhHKYAVCviD980XODaxWoctX0hAfzDdw8AQdvAZRu/87uWFftSeXFctvsuyjRqcQ88FHSyr0o91XiP2oNd/VmkICKBpYAga6r1uqDryxt6AgYU7PMUzXXhE8a8SdG8hUQsrVonAnZ3JrvF/CQElsLSMHgtftwIfoZwLNi+0D7Stwvd0F
 2qN04DWq
 0FlPmmQp7jwZPYRaAZfIiAvQzhPgXtCs7XkurVnqyhTCX/hfIpdhEAjy6aQaGiS2orlmGo2RhmXyJRRs6T2GQd5H7sSuiilV4pXemNdIpmx/RJF7f0CNavgtmk+6dxXZS+AXD3IJ3IrrShBXwFD9V1QnFRWfzAyECS0l4i9+RzjIm4b94H3ErqVhtK9RGyR0qmgT076C8l750Uqf+PuniYipPO7kgif0Vboz9mtRPqI7SRUWOeluOLiNCQWpXH0kc/5M06+5hgwl43m/lNaLryiksp/ohrHPOhqPzHXOIJSRSrQmdxtgHenm1fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 5:49 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
>> Convert all READ_ONCE() based PGD accesses as pgdp_get() instead which will
>> support both D64 and D128 translation regime going forward.
> 
> Please mention here why you move p4d_offset_phys/p4d_offset. (same
> applies to other patches)

Will do that.

> 
> Do we get additional function calls that might degrade some page table
> walkers?

Sorry did not get it. Are you asking if D128 adds new page table
function paths thus increasing memory access latency etc ?

> 
> Same comment regarding BUG_ON.
> 

As mentioned earlier it might be better to have a separate change
converting similar BUG_ON() in various arm64 page table helpers.


