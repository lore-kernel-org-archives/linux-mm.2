Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5643606A329
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 08:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YA6aPPt7
Received: by kanga.kvack.org (Postfix)
	id E15B86B05B2; Fri, 30 Oct 2026 04:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECF96B05B3; Fri, 30 Oct 2026 04:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC766B05B4; Fri, 30 Oct 2026 04:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A57376B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:29:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14381A80F1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:29:32 +0000 (UTC)
X-FDA: 85378618584.12.EE6B19A
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE04F180003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:29:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YA6aPPt7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793348970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUOdiWftstkdjD3ldYV9jARRTLumRPJOziIdFVy1jPA=;
	b=HBckUfA/PC6p7LIZPYXljeewiO8nFOsYsSme4hiR7FtcdZlQ1CZvKFCQQ22fH+f6Zy8TUu
	o5Ow/iMyT66FKw7aF6eCo3KxkQoOcTL7dHJ0k42LyerTwZWfSWWj59ctSBCKf0yTB/4YW5
	VNMxPl/hYeqLWWZgu+yR0lXsRI3xnc0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YA6aPPt7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793348970;
	b=NDSBxJ3KpXnZBAwrFZ1CQ36YZvNZQE58Ok9UFECnoBdUySGSHL1wx3uIaRYwlYkJgNqOyG
	aAis7kG6Msjj9yxcEhrDQ7DaZxego39TJ/1HiXwbYUnO4n+nvx3yESvSS3jtYm66RskwOR
	k+2aa5SydwC3sqf3p78DMLJkVp8VOoM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VKj6jsUT5uPNz0z5oNidKhqpMpX0J7TlgAePRZwWgdE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793348968; v=1; x=1793953768;
 b=YA6aPPt7LtovrU18QgqV7xGHJk6K9H0SltSh002moYODrpQoEL8TNCs4i4dbvdJNImXMl54H
 HjwnwmAF/qqZx97o/LpsChk5J7YeTFJgNws6m2RROWSCppIQzlJeO9IS096Juo/2umb10Oqp4to
 G3o1a5LfZQuIe38jO5uS5Y+M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f6353d09bda43725;
	Fri, 30 Oct 2026 08:29:27 +0000
X-Mizu-Trace-ID: f6353d09bda43725
X-Migadu-Flow: FLOW_OUT
Message-ID: <5452d555-82f9-45a6-b443-ee732b1874ba@linux.dev>
Date: Fri, 30 Oct 2026 16:30:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] mm/vmalloc: clamp an unaligned range in
 vunmap_pte_range()
To: Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
References: <20261026080329.140244-1-hao.ge@linux.dev>
 <20261026080329.140244-4-hao.ge@linux.dev>
 <99f529e8-06f7-4a20-a60b-0330c5d3d91c@arm.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <99f529e8-06f7-4a20-a60b-0330c5d3d91c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE04F180003
X-Stat-Signature: xe9z98k6uytiiimqo54965hi4dq1ijah
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793348969-513304
X-HE-Meta: U2FsdGVkX1+xhCmCppxPFniTomh17ThwXBeNWmaNDELG2QzJAjbRukJjBCchEV1j9RKPaAMXE8X2a22KIyvY+Zf1jsTEyMYGRV8QrKF8oQktjxVffHnL8MTfiXl7biw2PA7DY5K5ke8NgO9LJ5vEbOZBaoAz8o49Po6uAkVclyTnVyQOJLif/ob0+kxYAjvEJeBFX/BAV0VLVxxkmqdDk5Hh2WX/VbtNFMBI1tNwIiMp2hfTBLYH2KHfFJlRddv5JtcE0J6K1UcbtxF/noybaNufBAe73ZSB9zyNRU6hex6jS5HEWiTSXRvwrTcsZhZy2c/wsP1NWYqeFgynVnigOEmqCE6NpLgwfXa6A+Z/HzZRr5I08Ta9u5o9e8faIR4O/ajqFeiiVWs8/9f68q16cftV7gbcEmku5E3c0qKMk3GPS7dLLrcVURRfLgL9pOke3saZ1op9RQO3Yy3nfriPr8mgAiyH2nFD65oU5jdoYkx7XegCGs6eSyN+wXucd5wo42j3EOCaSbNBXEVGryo3tb9EVCwSH17N6/ViRnu5BjHPDyVvJVUS423FkCJ0/Oe3miu1UrzCEcoVwxc3XkolgtNVFh3mzGIA3awFTyrI9qRFGwLG3YsN6z+yiZM/v8H7PdfHMOKuoq29dTTtCLz8XfTffKKZ3mFVTuX7iza68+gtOTaZCZV6f3H9m3cceLFaXj1Z2oProOxOYJdJuAcroHIUgaecC4+sHaDwrp1cD+wRnfeUHbSjmNu983DhX3CsV2HzCSGDydrHhtSSHsmwvqGDZCwvp5QVX6YDHorqmmxWK0+8S67YgxZ2FVsML1OQ69hUnhtn5gX1S4YUY2Qoqcg+OENq38ZfppMDNGXWU5aQNXzXV1rJfljJI0GHDfL7HHCkwGlejVt1Wv7ZOhDXEGxjBBcdeM6AHTfmg5AIawTr3ELy0T7/WrhxwRCSKv15OUJ9WzYRahRUGvg5S46
 K3sw03uz
 e+LGsLF/PJv60xzxfh1cZnOGKL8dyD3KiwEc9lrskbUtb12FecwUirvV5mkWOOmg8SpSgw+dfTqsKVG1EcK+dnOLN+WpUFvAPB3bUh0M9TXsZLTRYmeConprKUZDOtXetLLvOFKv8qMBdJ2LRfb5M8+5b5gRkg1hUFpRoxj0h5Dq4yVdsiWjkfmnp+Bf+c1qdq1/VZlJcbNb1LfUACIHN0rpih/N88Fd2tXWxfzr0iGQkvERig+7uJwS97YMgdOGd2rb9N6EvMj3S5pdWFm7lQX8ECDZwVlJOBCTGR2gOKRHYBhGZFuP5fbZuVEneHEjueWH2Z7HHOusy2CK5rbdrudQd5lO4limUttGNo3GdeTEcF5qYfIvinpvMdeA1E1cffknxjxX/8FGzaYsquFUhbOoHDRLE/aJCIIo16f/rbPd8Gqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dev

Thanks for your review.

On 2026/10/30 15:14, Dev Jain wrote:
> 
> 
> On 26/10/26 1:33 pm, Hao Ge wrote:
>> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
>> PAGE_SIZE aligned") made vmap_pte_range() warn and bail out when the
>> size is not a multiple of PAGE_SIZE. That loop steps in page
> 
> Why are we checking the alignment so late into vmap_pte_range? Why not
> simply do
> 
> if (!IS_ALIGNED(addr, PAGE_SIZE) || !IS_ALIGNED(end, PAGE_SIZE))
> 	return; (or return -EINVAL);
> 
> at the start of vmap_range_noflush and vunmap_range_noflush?

I think adding that check at the entry of vunmap_range_noflush()
goes against its design intent. Its job is to tear down the mappings
of the given VA range, so even when the caller passes a size that is
not page-aligned, we still have to unmap whatever is mapped within
that range.

So the patch clamps end down to the last full page and keeps
clearing. A buggy caller still gets its mapping torn down as far as
it goes, and nothing is left behind. The check here is just for
protection. 

This is just my preliminary understanding; I may be mistaken.

Thanks
Best Regards
Hao


But that's just my understanding, happy to be corrected.


> 
> 
>> multiples and stops only at addr == end; with an unaligned size addr
>> never lands on end, so the loop cannot terminate and walks off the
>> end of the page table.
>>
>> vunmap_pte_range() has the same loop without any guard, so an
>> unaligned range would clear PTEs past end without ever stopping,
>> walking off the end of the page table.
>>
>> Add the check there too. The range is clamped down to the last full
>> page rather than dropped, and the loop is skipped when nothing is
>> left, so a buggy caller still gets its PTEs cleared as far as they
>> go.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/vmalloc.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 44e0eb32708f..7131f60d1a8e 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -393,6 +393,11 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  	pte_t ptent;
>>  	unsigned long size = PAGE_SIZE;
>>  
>> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>> +		end = addr + PAGE_ALIGN_DOWN(end - addr);
>> +	if (end == addr)
>> +		return;
>> +
>>  	pte = pte_offset_kernel(pmd, addr);
>>  	lazy_mmu_mode_enable();
>>  
> 

