Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1944606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P0mqb1ti
Received: by kanga.kvack.org (Postfix)
	id AD0E16B05B0; Thu, 26 Nov 2026 15:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AE66B05B1; Thu, 26 Nov 2026 15:27:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922406B05B4; Thu, 26 Nov 2026 15:27:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBFF6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:27:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D52331403FC
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:27:12 +0000 (UTC)
X-FDA: 85478404704.18.5C5A318
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id EF42740009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:27:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P0mqb1ti;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795724831;
	b=JQp2/mpybrOcvKzu07zsGAQTOAhAh+9JUhYrDz+AXkmBoio77k05TjEV/L8tB6B88oc+qh
	FwJyqcpEnX4iufq5ERrBRs7IAl0LBytZK/0cotFSnnd3KZUFCLsYGdWGtVEXpZLKTMIwOm
	kFDn67r3mVz0QDDZ5AhqB5RdKbxr1OM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795724831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPIUXK+tyYI9lmjrCipc96I5GvVnkf1nt74AkZOGWME=;
	b=MI6VG2pO6WHV49cSyZk5kpYnXFNFj4qjWjecwqrh4QziA+gKqA98+6WKEozulvP1XsU85Y
	O9lAfXd9oLM9QWnCyqS9agxaEpR6V5aMREVWUnrRadKhXxG6aK4bQW59i7T+BTy78JUqma
	o3W8J2EIRcdKpPqi9mcGHrOuNuYB8ik=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P0mqb1ti;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-492f0a1b685so5254986f8f.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795724830; x=1796329630; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mPIUXK+tyYI9lmjrCipc96I5GvVnkf1nt74AkZOGWME=;
        b=P0mqb1tisj+LhyYvbtAmr41oumgQkikuFPFI3Qdg9lybZzTkUGBmUWZj5t/hOUzV5i
         lVf2VPpG42mLHypaMcIEPGxqUFmnL2cWiJLFh3owOeb52dkropOpzLJ5qQPGIkkuIJvi
         FWy5mR1EoFngZ20cNlrFL61w3fNDX5Zae1SfDcv8Z6Jnjef80mYnZPgW/+0Wos0xTZcH
         UsktcftxfMbYmw6TQhozZ8zVD92RBLxihfEUUbtdqUABQY09sS4ikWD2yUVv9TrE4J5t
         ejE2YP+IaVMpNxghWxovy5sAfMWZ9XjDLf73Ge39iLCePVPFabwiyAOWBATCpcUmbaT4
         vp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795724830; x=1796329630;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mPIUXK+tyYI9lmjrCipc96I5GvVnkf1nt74AkZOGWME=;
        b=SP11DIMTmojE7KfKHxMjtLCau+vuUA/XrKw6KWztyvBhWwMX89BySxEje9SxSQNxHh
         X03re9C9V8yGum5Svumr5Mw8FMF4fH+tIPBxFE74p4tYi/JQDoSeySxW0H5vCUUGGppI
         XbX3syYmXEo7RLSg5okh4XosGl6i+oezPQBUBiuBpINIKbjzkBnMLgILInl1VIw1gClD
         fhIArxjBGlkB/hswnzuBRHrwAUCC0cBS/P8twX4e6uuIMOfymeVNMqRPDQqLb70PyUiX
         t/8r0PH63qWrcydxCF7PM1S0mbhHinsozz7n7X/Z/hQILqZJkNDHtbydqnwQJUu7dgkp
         yqzw==
X-Forwarded-Encrypted: i=1; AL+hErGteI5g+erzcM28JDxzkuH8wYyMPmC/gQ8w+ubFdAXT/axEdFYeeP40W0DY6OAMcF84uUpqERHovg==@kvack.org
X-Gm-Message-State: APuU4Z/UzBvZ+Nh1w7tDyiC6VUDcraoR04HaTTMJn/RiS5yJYyFKLT9p
	cTvft7EJeRgJW9yNNWBH15UPojRuWIG30BX4VZhV86kLsLxFa/HQCga2
X-Gm-Gg: AZFdTZdBl/mp3Ip0XfDs2zYx7V/phM4WrFiXS3Ds20xtqlhXAcrd88dMQjnhVhKwqGj
	NAxJTdCcCXK14QR2h3Z45sX3nMSFLKGnoBAhjIa0qbuT677m7CQ18QcsIARM1Qk7fUdy4zSj141
	jKw5As7UQok/rPT/cj9sowD3XLQy8qy5Do3JZBkpx4cpLIY/t399yKvobvI+k1I41C+F/BySNED
	bd1uErRwFnTSrZpYs/YzYH1lLd3tu0Cff09+uPPlEurlLCocC7kBzv97qkuBJxJK4vss4p9zOj6
	h6XweohrfszbsbC3reesuZ4Uu9ftA1UbA+Ibaba8ghM2w1TIAhJ7RgYZxeVwwvKH6LMzYeceAXf
	Pt1dp6bct2Zakwe/C+fJRUqNxKWRmNsanJ2dRIkGWiPFZB0SkLJcPxLIEQYMD0aZ+KXfgQ3TDDy
	ckZ6DDyeQbRc6i8E6Mpfbk5uEwISJsj2mQuw48gFZEWck5wwYP2KyNy0wM3w7440u1MvDzVwZMP
	0ksfTXUO3kQdATYdDjKKkx3Hz5jSYAsTsofjzR9irbHI5Lowkrv4JRro5r8+oed0sevHHsVFLJL
	CUbmfmuRSJR5oEBPcP5rc6Zt
X-Received: by 2002:a05:6000:310c:b0:487:27f9:844 with SMTP id ffacd0b85a97d-4abb627ed47mr53600472f8f.57.1795724829363;
        Thu, 26 Nov 2026 12:27:09 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b10b1ebsm44007075f8f.33.2026.11.26.12.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 12:27:08 -0800 (PST)
Message-ID: <03ab430b-83a2-48c5-883a-70b20c4bcffe@gmail.com>
Date: Thu, 26 Nov 2026 21:27:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/memory: don't allocate in finish_fault() with the
 folio locked
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Zach O'Keefe <zokeefe@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-3-azpijr@gmail.com>
 <9d506473-4844-4ed2-ac58-e72cd72b5c9e@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <9d506473-4844-4ed2-ac58-e72cd72b5c9e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EF42740009
X-Stat-Signature: madk4pn8de899fe9ru3k8n4a9xk3qm3h
X-Rspam-User:
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795724830-509096
X-HE-Meta: U2FsdGVkX1+77o7e10I+ighdnMF3MrBINSlmY+hlM8d8PZZD3AGcBFcTdZz6Y4o9VTDUm3JT2SivzTofG0N3QTkobYQ/dNP/nVR158IZEzPpURTcCm7j4rggkW1EEU1Nh1a7mngni1NU7nao568wXhdAPBF8vC4iYshZyWHs3i08jPjfxiN8BM7PIVpvqwVNe2Hc0Oxsw/1bIxr3ZIPoBrTKWa4s2SQ/SrjXzgDSTRNlFNOHW1NQt2b5o1FVms34ow803yt34b5lMZEwl930yaPLVxqca9IP4GP2WVHfwRxFFBha0gQ4dA/ImXKPfH90npMU33p7z06hQfCv+K6aDYgf+7cCb4QIFuEIb9QURT8QlVzgz4/TWL7Qm30gB7eIzz8M5OYzpa5zs3P0hDJy377v2/sd+cMbEB7ToODsSYdO+dnayfgPJYyN7bLDdVKwYDEXRFx9r6AS97wTU+zq7zmigfhe4g3w7rNyeqiaUFy3DnJzf6L0B1JUFlIxP1zpO9WRcQlYpCmbN0IC5KonnDwA8bly+tyrdN1jgUAqf7hZSmf2Zpqg2mFqIyMPKTLjiy0P7PEnabF8fRw/pCwa9M59jg1qn0rYriPRlXAxa6e1St20kz09Xkfwr4nnUK83DxcyanySgc9+EBWdoSlHi2tV0obv81PskCR2sPKbJoXwtreK4o92kzuo2BkOMgXzZ17t/zZq4JnmFQhrw8xZtQgd/2ytCT/UcJf0IO49oAko8xw/nGDCBfimOFS8b0DRt8tefswjGq7RwClUADJuAyyVLZq+n19j5e7HjhIy51AYjLaSnba7ahOY3sBHfv9M5k5hzj84eN3KWbfRyoDcsQagfJ8QAPb+YGeO5SBt2l0b8Sd4RVgUWoKXjfqomyPUjeIatdcJB0n+8y38VxuFoxAOz07NQNLR4OpHNSRt+m+jTTr75ACfxvID6ub93y2A0sQcPXOUY1FPmB7eQJy
 MJMs5P0+
 YymB6czc8DBYcCWYj0R39mlq5UUcGgvQQt4m39NOZLeGQc3sXIx2cEQCKRdqJFW2pJ2GGaF8OsOcaGMu6Wus0TmouAyQeomKZdtshSouIH2XUac1hBQyp+M3FRWeuvsnbbmpaEKy6OPCuO6DzgosKW/uVJi4Nzn/W7mKaT5c74GzVXEpKbrOcieYjttI66D/zlC4G2/pyB+4oiI+gXT/TOMNeyzByTkGdLXb7xaiWKiCorhYXS0jqv0SnoZIhpQUeNhFWTKyE9Um5dqM4IrfA521HHfx0zXyFswb8otZe1NA/nFX0m5GYdGuxIAi+Jz00mRNuObX+wVft9r1L5HZoHnnaSYt3nrf2fywHTXeTh2nnFBcDDxC9I89vuO2PG2hXXlD3ftdDtzbDhF1Nb4FyjTYXcsQTUL9ZGp8DO0tS4EgW5On+5fhDJVcVqiXkLXmhrzqXw3JoV/4nyEYAb3SADQbeXTevjiLHygOAeHNd3f0Y1H7/oCm2RyGAetpCXbx0Mm8KypALcO3pOYNxv6v9/AsfgrSBjtmwuWh290EFrIYuV9MQRGWAtcDjNoTilPVcydoMgKtvgOJ+HCWpi6FBDwIp6jO3SF0HIZJkdjxY6mYQAI1HMCQ3GOiXbZKEpeWpQgpkD29aiZ4JXHmfljgoQjtsYG1Srd044Ej3J82TzyzL/GoBNDAMnzdxGtCO5oiJNP7eU2ScHtK209gVq4QSFcNMjhFq0wyp5GUbL1tthR40PlrBCnSxrT6QzxnNBAX0RqHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 5:29 PM, David Hildenbrand (Arm) wrote:
> On 11/25/26 10:59, Jose A. Perez de Azpillaga wrote:
>> __do_fault() preallocates a page table only when the PMD is empty, so
>> that finish_fault() does not have to allocate one with the folio locked.
>>
>> Since retract_page_tables() no longer takes the mmap and VMA locks, the
>> page table can be removed while the fault waits in ->fault().
>> finish_fault() then finds an empty PMD without a preallocated table, and
>> calls pte_alloc() with the folio locked. On ppc64 with the hash MMU,
>> do_set_pmd() allocates the page table to deposit in the same case.
>>
>> Allocating with __GFP_FS while holding a folio lock can deadlock in
>> reclaim, for example the memcg reclaim deadlock on cgroup v1 described
>> in commit 63f3655f9501 ("mm, memcg: fix reclaim deadlock with
>> writeback").
>>
>> Return VM_FAULT_NOPAGE instead, as we already do when
>> pte_offset_map_lock() fails. The retried fault preallocates the page
>> table before locking the folio.
>>
>> Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>>  mm/memory.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 11cc4039b853..b7e53d7cf6e5 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5986,16 +5986,21 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>>  	}
>>  
>>  	if (pmd_none(*vmf->pmd)) {
>> +		/*
>> +		 * The page table was removed after __do_fault() found it, so
>> +		 * nothing was preallocated. Allocating with the folio locked
>> +		 * can deadlock in reclaim, so retry the fault instead.
>> +		 */
>> +		if (!vmf->prealloc_pte)
>> +			return VM_FAULT_NOPAGE;
> 
> Hm, but do_set_pmd() really only needs one for ppc64. Assuming we allocate it as
> NOFS in there for that corner cases ...
> 

yes, I'll allocate it with NOFS in do_set_pmd() instead of 3/4.

>> +
>>  		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
>>  			ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ true);
>>  			if (ret != VM_FAULT_FALLBACK)
>>  				return ret;
>>  		}
>>  
>> -		if (vmf->prealloc_pte)
>> -			pmd_install(vma->vm_mm, vmf->pmd, &vmf->prealloc_pte);
>> -		else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd)))
>> -			return VM_FAULT_OOM;
> Could we instead fallback here, after we tried to install the PMD ?
> 

sure, I'll return VM_FAULT_NOPAGE there when nothing was preallocated :)

-- 
cheers,
jose a. p-a

