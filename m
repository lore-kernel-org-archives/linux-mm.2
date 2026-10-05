Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7BFCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54CBD6B0088; Mon,  5 Oct 2026 10:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE226B008C; Mon,  5 Oct 2026 10:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F02A6B0092; Mon,  5 Oct 2026 10:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1839B6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:36:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99486402BC
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:36:49 +0000 (UTC)
X-FDA: 85288824138.10.338D60A
Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 64909140008
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:36:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r8Y3d/2t";
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791211007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCBe9saYe0Nio9C8kGF02mh7T0pHDgXwovVQ9Y/D7c0=;
	b=bGDGz+vcqyVMPtq8JtXbnl5DlPsp2YM/tzsgz0Jmp7Z7PB9X1hkHgtxX9fsc8bCTqE4fJi
	ZAPGUkza0ow3kmrQaxkL85w2djuUffLcKMt1LBlloIdVUxBPM754gMhFL7U1Ve9QVetEdn
	+B2N6r/v3HlnuRsicFx6bL1G5UXUIUU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791211007;
	b=z3nVsdGNa7+zftcj/iVjjkAmhMwQyIati+9fwVMNBI4aB7/DX5dmiNtaoYOx+Jn0YOdwLm
	XKdhRJyiBH33Nfh+D5zeUoXXDfmNCOizRRxajMr+tkvzMajTz7r4hQ9zntsHVJ2PWwkdiR
	lqC15X2skwJ3xmv7fmS7czOvgEH0YlU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r8Y3d/2t";
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F9by0ha0YQK0T/c0DHTwYvhzhlGXnVnEdgz0tUOz0JM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791211006; v=1; x=1791815806;
 b=r8Y3d/2tMptWxAOP35SYvkYzFgJtbLlxH9J+ZqwvEuWk8cRnrzsQ8zrqILyhOjE/qZn7VyAp
 b2y4Q/MgYEU2N/t1TMxgei6oaYMZWXcIFAhtUT0qMB8xQx4GkPYfljqAuYJN+mhuRJA18QUAf0k
 MiGcocgfBrYxJtFe1jit0fzk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 16f5694261043640;
	Mon, 05 Oct 2026 14:36:45 +0000
X-Mizu-Trace-ID: 16f5694261043640
X-Migadu-Flow: FLOW_OUT
Message-ID: <de41b083-6368-429e-9928-90aa5440f750@linux.dev>
Date: Mon, 5 Oct 2026 22:36:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
 Pedro Falcato <pfalcato@suse.de>, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com,
 x86@kernel.org, hpa@zytor.com, riel@surriel.com,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, nadav.amit@gmail.com,
 thomas.lendacky@amd.com, kernel-team@meta.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, brendan.jackman@linux.dev, jannh@google.com,
 mhklinux@outlook.com, Manali.Shukla@amd.com, mingo@kernel.org,
 stable@vger.kernel.org, toshi.kani@hpe.com, david@kernel.org,
 mikhail.v.gavrilov@gmail.com
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
 <38541ec6-d796-4f35-a700-75ab097b6df5@linux.dev>
 <7ad90e94-d04d-453a-ba22-9640a5024d8c@citrix.com>
 <6801221a-6307-407a-85fc-46906f95d22e@linux.dev>
 <20261005142216.GAasOymJHYnmn6wD5m@fat_crate.local>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261005142216.GAasOymJHYnmn6wD5m@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64909140008
X-Rspam-User: 
X-Stat-Signature: e7w93zi3qm6dn6q8h9b9qzgmqsgxs6e4
X-HE-Tag: 1791211007-550089
X-HE-Meta: U2FsdGVkX19Tjcs12juXUeUKBRYA08G2uPlkzlWrx+t6+2Z/DmS9wE0wI3equpRli9vWv2YSaev38ZPyw0SnacRhkOvuhfpmJ7sTtRBZDRbhZ2nsPcF5uOEzgzsMmtMVGUZ5ti5dQqURWn8gcY6W/kN1koKtShr2fI7grMd/rbdxWAgycCpzW2sJvqipZ6lO5gQtvkIEtgClQZionhBOhE5UH4/ENNXy0tsvNTzlsl9HzDO/m6E9oJPmPXCP4Ar9w1tf6h98jQHGckjVLCebyfTN2hWp9LhfofB01dcL5D8+mh4mR5SYFMnT0pzb6kVHXYBlliMLbkzRpTyKeReNoplZ/0ZgVnksslRxFGPJntapzqhXuGpLUQIUMEPqDlTTeg+nJgYibEESH0mh6V6f54wW6UqI4oMusHq5tiiwaADv2CtjmrAn5pospSO3xHm2rSJ29L+VxXA8tbX+N70Gbv9kzPQPlh685XeMkM4WrNQ1vy76Xo2pAHeD4GwS09hLv/MnAhmrcBMQsL5RdOdfB6u3Yz7K6msWG3cKcvVbV9e292ZRrMHg3JaLzX2R8JSvchR90aqiFFGcXQEQuuOrrRbhSiBom6z7WnFFB3ecx5J0OnZv/BFbe84NGxzzHW6HQsZLU/O8AFPMMAZpdQDnH2OExRhylMR44o0O54J6U81elDEufWg9qatG7S95ZSpSsfQVjaRabCU8/EIQb2ZmIgArlaHsN3l7iq9+1+vn4cbvPuv24sQu7ClCqnEdPCyth09TBj7wdKz7/gSiXcrbhGgT2MlKCD4uewHVVXsmg668uH24sjcoJc4E1w8lvmBb5dcjHrRCdCPMyxWSONHjP5TddgG9veW9MBnSCk5E/o7uo6jRU1ROS+Vt1PTqu69cIOP7Xfk28CStarxhAiPUsuraiSC8oHOxzK30i6rW49CCl740lb4QkXYilY8kaj50QCCb3mr+4o3a4Ldvdbl
 MB3gt/rS
 vKt0TdX/Fusdn5YcghdyZqYiLkzDCe8jniay0zr4Wa0nI3rR7abd41Jet8wPCxIVODwZJHD+oQS2husPIfP5bF2FPayjs2bg9j0goCjYGtt3qNce6VFqGulKbRi0iIRMtx1RNfBJXpu12ESBXntW+66SubvwzRiQ8+yogudVaRiVsjaM4KSUnvkXa2nvjSqh0H/WqDR02gjjlFh1gKWQWE2H2His1z993OHtbkX8lTNF1j2Hmqf0hFlvpnpVZJWeoOO7bfpNs3QeIgEmiofPrMmRnajvYf7Qd428IuJdODs+8YMiq+3KHsUiTz7mguDQ5Ao4OyW4dVtcZDUmTYT0sJT4aBVttDO9nqqIz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 22:22, Borislav Petkov wrote:
> On Mon, Oct 05, 2026 at 06:12:45PM +0800, Lance Yang wrote:
>> Which CPU? None so far. As I said, I don't have a reproducer. I'm trying
>> to make sense of what the manual says and what the code does ...
> 
> So you're sending a patch for which you have absolutely no justification? And
> CCing it to stable too?
> 
> And that patch hasn't been tested to actually address anything?
> 
> Just a wild hunch?
> 
> I wouldn't do that in the future if I were you.
> 
> HTH.

I don't have an AMD machine to test this on. I spotted something
that looked wrong in the code and sent it out to see what others
think.

Maybe I'm reading the manual wrong, but is raising a concern
based on the code and the manual really just "a wild hunch"?

