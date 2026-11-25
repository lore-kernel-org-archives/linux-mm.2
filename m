Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EF6606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 04:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kYHU+Iby
Received: by kanga.kvack.org (Postfix)
	id B924C6B08EA; Tue, 24 Nov 2026 23:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B435E6B08EC; Tue, 24 Nov 2026 23:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59196B08ED; Tue, 24 Nov 2026 23:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8700C6B08EA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:39:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B601C0DE2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:39:26 +0000 (UTC)
X-FDA: 85472387532.10.D677556
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DED84100002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:39:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kYHU+Iby;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795581564;
	b=mDSYpT6SUOaky0ZaLi1/PlZNoGsiGQv8EZpWsweVV3yFQhKmL0qcTAMjTfiWkON5ujFgef
	Jio4krVZl/wOqkT39fH3H7BpaE7ikozdiHcXV2uZPKRdPsaSDKH/eP61QG/ym/C8jyRf8+
	7HyCBnUAuQc13eyoWTobCnLHw55rrhY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795581564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4paBOgYx27DZmRcbvuALFBC4wVNAVCoHi4RjA3nmpuo=;
	b=ErSh/HRQnFKPZdiV3phzakpj7rCF8YATTlXz50NduLlkBVBCsyHt8saxQqIlTY0mboA07B
	nduHxIhjPKI1Jxg7FQ8KM1Yl17/UklH7pR+1eV2djhif9ZK3XIyQxoxyjSW3cmEQwYA2jI
	AbgFwnW3aviCgUo189XOblWRpYYgLm8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kYHU+Iby;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40112497;
	Tue, 24 Nov 2026 20:39:20 -0800 (PST)
Received: from [10.164.148.57] (MacBook-Pro-3.blr.arm.com [10.164.148.57])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9E493F86C;
	Tue, 24 Nov 2026 20:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795581563; bh=bPe3sFsYfNROy6gyJFtx6tzGV7xIPoOUpStkbpZlk+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kYHU+Iby6aCEs4wKdgoKR0jcqWkA+U+g6PECJyKdZmiExw/X7CI5aB5C95PfBZSn7
	 w0Lm9qxJ6J7U47ScHUZ1KNWd89strQ/IhSp1h/c1XlRpUPGGyAAR35scyvvCFdVcLT
	 c6wMP6e5T22encFbjhDe6otSmBiZHriaEH2cSWqE=
Message-ID: <0e23a777-03bb-4363-80c4-e2b90ebf49e5@arm.com>
Date: Wed, 25 Nov 2026 10:09:13 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] Optimize anonymous swapbacked large folio
 unmapping
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20261123053543.295467-1-dev.jain@arm.com>
 <20261122224612.8e7f1bafa2b712521a95ed79@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261122224612.8e7f1bafa2b712521a95ed79@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: s8h1yyupidzbq7k81dmjfddfaxbaj1bh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DED84100002
X-Rspam-User:
X-HE-Tag: 1795581563-448296
X-HE-Meta: U2FsdGVkX1+s5wZb+l7YoSbP7bfyjVYoHSCPXtdncj2NygWqOp3iPDm9ODtCDS0QUmJNBo5n5oVIz2H/1623ncRVeCQgfMsBos+wlFIKTXro601S7lDUgrbqlDnU8I+vuqL6b9XC+ly+PAqm31o89cs0TypQrjiGAB9ra3IIjpOge/lhU1V0y2YHv2c13olzgv0TXctj54/hoqxTTXHNoZydAkPUo0J/lhfPfJOqAIOqa2QVFcODrLs03WportugpQI1txih4rACR9cYwRRjah9FTSIwOpIt2ug2jPp/LLvnfGG8kS8lCh/TaNtkheHDf3OzG1161YjNoUFjyeKPZ+15b3WwAsi5UKMXnL9rte5QLhvNwIopElndpQVRPp4Ce2Xp2uUqesQaIJnDeqVDbUc18/ZmRZ6TChTVrP81Diylgf4wT2T9AgBqy4wbAVo56rfW3GLsvjFClvs+dn4/TD2X2n3W3vHt5iJMvPwLiMVZ1CD0e4VC2W3PYs6kb4WiPueU6wwXUB0mhATCuS+ligOD6VshVlY3jOHUr5moqtbXK77vYaN6St/tU8fm5V5qnjYcm+AHkZbyGacYxn5EWqKBqQTJPMKli2LIzhXkw7fmGwlFOdMJ4vQbjIed+xh+6/Yw09/GAXXP57ILuMZEiA2y716bYKtTi00Yz5KqwJbnXIZmMCWt8iKlfvpWZRQF9yuCAcDoS4n58A7ho60UjcZk09k6Ja0+GVJF8VihwZ70i07TcuhK+xFmWSbmpi4MFx9SmBCSKVkLskZ9yqGvqyDs55KUqW/vvDMgry7w0hCUWaGbiK37dg2E+b944G8xCoSVnbIcPMaE4U9mzgoHltno8Y8FF8cobPLkJzJN5O08JrHK1gRbJC+Ch0e4L9G7aeQ25Km8OUnPjP9hGSHesX2OBuGxe/hK9q7dUHzLN1dBfYzcZUpp1b97OT5n3XwEZfmQUcc3Tveoh5tgtI3
 0RZiu4ca
 TCJV+spS7yv7xIzLWyiJ735SfPJ1cWQdHZ0AGHeguqVIhUIkQ3p1ILy/rctetgbH1OdrplwAZzmvr4nekQAqSNNLXEdBbBnAPWMpvAiisJEGmskm3nvzq+jCizJzuM062+JSLirnjCb9YbV+gZBCe0AXm2vcGt4mG7wwL2sPQ/SSXSCDwNW6fKYZ9ItrKw96SeNKQHf5C5ktDDDZEC/6oenTZn4M75eHlJsPflqVnN2mG3+Kh2LcGW9kezZ1WydFNDbCw2ymW+z2TcN3ztBiy1/70fSeLljfdwEDN/Rk0WjHRm7jPAGz2Bfb+zpUL24GPK2eU5bysvved3uhirkqXwAENKCSzYm5YP+srj8tqkf0scgWbZEGyFD1gDORggov5xoLKECIHgwD+r11Cg6TvTYwcwdwhZGCud+2t3PY7mC1EeIHrdUIfTz2CGm9WEi3stupL02OB6FeajekzsjBlHgXmL8JzCQJnWo8QTaTQC6n1i/DoPn3WInouc1n0FsgAQesNqLVdl3SlRhYKYhs2rCcwoYFnv0bvdlGV/MwffiKUiYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 23/11/26 12:16 pm, Andrew Morton wrote:
> On Mon, 23 Nov 2026 05:35:34 +0000 Dev Jain <dev.jain@arm.com> wrote:
> 
>> Speed up unmapping of anonymous swapbacked large folios by clearing
>> the ptes, and setting swap ptes, in one go.
>>
>> The following benchmark (stolen from Barry) is used to measure the
>> time taken to swapout 256M worth of memory backed by 64K large folios:
> 
> Curious.
> 
>>
>> ...
>>
>> Performance as measured on a Linux VM on Apple M3 (arm64):
>>
>> Vanilla - Mean: 37401913 ns, std dev: 12%
>> Patched - Mean: 17420282 ns, std dev: 11%
>>
>> resulting in more than 2x speedup.
> 
> Big.
> 
>> No regression observed on 4K folios.
>>
>> Performance as measured on bare metal x86:
>>
>> Vanilla - mean: 54986286 ns, std dev: 1.5%
>> Patched - mean: 51930795 ns, std dev: 3%
> 
> Small.
> 
> Why the large discrepancy?  Host-side caching?  Was any IO actually
> involved, or is this all CPU burn?

Swapping out to a swapfile.

> 
> Maybe arm64 stuff such as pte-batching or TLB invalidation avoidance?
> 
> I mean, that's a huuuuuuuuge discrepancy.  What's up with that?
> 
> 
> 
> Also, Barry's
> 
> 	memset(addr, 0, SIZE_BYTES);
> 
> will trigger swap_writeout()'s is_folio_zero_filled() optimization
> won't it?  That may affect things a lot.  Did you try writing non-zero?

Thanks for informing about this. This means that I have tested CPU burn
essentially.

Unlike my other optimizations like mremap/mprotect batching, here the
try_to_unmap_one path is (in comparison) a small part of the
MADV_PAGEOUT operation.

I looked at the cover letter of the mprotect one:
https://lore.kernel.org/all/20250718090244.21092-1-dev.jain@arm.com/

Even there the x86 diff is very small. But note that here I do not
introduce the vm_normal_folio() lookup call so we are definitely
not losing anything :)

So yes, the main benefit is for arm64 due to batching TLB invalidations
and avoiding redundant pte scans in ptep_get() for arm64.



