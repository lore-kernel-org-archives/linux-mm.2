Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C62606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=glNjLAFW
Received: by kanga.kvack.org (Postfix)
	id 7035B6B05BF; Fri,  6 Nov 2026 09:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB466B05C0; Fri,  6 Nov 2026 09:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA7C6B05C1; Fri,  6 Nov 2026 09:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38B936B05BF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:19:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC4551A0E26
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:19:17 +0000 (UTC)
X-FDA: 85404901554.20.E75C6CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E2FBD140010
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:19:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glNjLAFW;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mj147cNESXGoHXlvAzbxpGpmr95p6iDfBMnRQY2C7B8=;
	b=dRtRGuMxsbBZEKUme7MarM+xY1ZR7rXZH+D+urZMs+WQs6c+JcQEkiSNvZQFnuDEEzs9nQ
	fA1Dzc2gvcjza6gUOYJFp1jDl40ZyIkgaPF/YFji4FFCWFIrMS5VRoZddS9t2BQbWoN/Vs
	bvCEFXnsE0LwMX2ZFrDx5RsA/dhthlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974756;
	b=Sw1CQCU1apMAUYaZKJO0XRMRpJeFdi7k//mCFzqxVBKcPaw1WSvXnc6XNYQJOfv9rrDGTQ
	KN8sme1AaXodlbRXcZa6man5lNN2alt2glW6c3KVWXLEQ84GYii4rxKrht5Fp7+O386W38
	6XAMJpE3stKF4zw12XU2Z+knjIftd84=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glNjLAFW;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FCFB602D4;
	Fri,  6 Nov 2026 14:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BCE1F0089F;
	Fri,  6 Nov 2026 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974755;
	bh=Mj147cNESXGoHXlvAzbxpGpmr95p6iDfBMnRQY2C7B8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=glNjLAFW1fuGqbZDoB5SwTXJ1klRGdu4dM85avTojgRKe6Nvf+K9w/+QcqV01wJyz
	 nsds+R8YBm9rxSjVpTuMb6gCEO1/qbeh6mEok02DtM14EcX+d/OJIL0T3t+hNhBR83
	 SVDFpU/E9Xe8cejTsae7oMzZht/QMiVKCsnWNuBkiVd6baNt5XXgRd1Up5ZIRZ1YUz
	 11qGRvlzaQWoH1rxR0FlUd5W528hrqReet7m2LPNbU1DMCUl97jInKhlA68OgopVJK
	 zUR/ZHWrpWx1Hc5A2gJ3FP3BrYyaxlGAvyLFJsyXOhm4UDTHVtwBfJXMMfDDFOAy1T
	 3mbwikECpbBUA==
Message-ID: <41b4de46-4f25-46bf-8b34-02577c38ef8f@kernel.org>
Date: Fri, 6 Nov 2026 15:19:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
 <au3C8lNElGg4LnR1@thinkstation>
 <254c6f0a-9353-4806-a5ab-a071cd59c64f@kernel.org>
 <au3bJel0YnSeowCq@pedro-suse.lan>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au3bJel0YnSeowCq@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ii9c7y4ta94qt48i1h5a8ko11fwneok1
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E2FBD140010
X-Rspam-User: 
X-HE-Tag: 1793974755-310599
X-HE-Meta: U2FsdGVkX18k5ilACwfayGi1BpFOVPfKGJiecJBYzINhAFrh/HSdhJ2a7pVEenjMX8Rxe9UtfpQW1/4lMV2OTztCArybkWdSZy8SuqNf8CCV664xZTJZg2VAEY2BuL9sb/HM5VCLN4BeOMLLiQCOti/APG94RVqoblHin2Yvc9TYseyxx2oVbQKpL4tb+iNS6olh7OQmPO7iuY+Ns9YH2S58c+S4El9vhNtVazXTvc4YVRsJzqAl8gMn6ZOlL6YB5sPcFVGxgFlM4691wF67REuwfOCdjdF0P1gssvgpgdz9S0R7E54aQeXlQ7hDO7kYy9f4x1GE/kk7bRsEYmXT0Pp4Ob3PJkX76mq/Wh0M51FOrvVdxPEk5z0V6amm80YTzjopFOq9iXCJ4hhYlCbeUX1nMGKAPfcGYubiGOF7UpU9K/c+QnPL7/Ygc58CPcDZapF+ClDd3NGno+Owzqn9YUGK3F4828bhVKqAQpGaAbBkNWt8I3b+2EgxpI+xEhn5wBIXK/CFnX6bRq2OyR543jU0VOwCObl1DSFoBv7U231N8AtV7YKSkYS2bqAh8CPPgHen28xcojn2BBQX8bcljyg6r4qFACtvWGhFx49oQsthxMJfLAu5mBHU13c5vl8Uj23jGVo5xGRel5vnMLWLa8Xp0XpqO4HoA9kCIK66GTBbyJtco53GC2GwepvYOjFd+iwMuxjOPlsNd6Zcs34S1dg8s+ocBxuGpTLFLk2PcWPSjl5x+aRl7empyKOm0TWJEnwXe9PcSG2MU8XtGMb95krTp1GGB/M1hKjtXQfs2wRSBgxLAT3txdJkzhWaGFRR7srkSBuQngLJkhl5aG57DFPbklPQQZO/SVXCpDGlNvFLr8LN0/DB3IHPXxzDHWBShRaGWtKQUqr14igC51KZFP/EFZVFkvm1zxFU6i5AcvfkhNAXZj0T6cZtthw6IQvOD7H6rphm+K+HRewWIjW
 IDv8uskY
 VhSVj8HUgKdd/RD+4G8Y98PDtTidR4421CNs0qTlRxEwgV7mvR5Pzpjo6zG3RC8T+r7G7bAsmk3A7eLhE9Y1ZRzD3m4e0mQtZGNxbFjRnQRCe06VgeOVDI+E/ynsPTScGzyzCY0Q8WHsMT563C8IC/HjLqd+mf5d32Pa13nxOeMXtFt3edCZjx2sHDqwtVret3qNSD5GXUX098ywbLK4m0ch0eAaTtYOhv9M8SRO59KJpD82dsDIhbN6oduARLUl3AoB/moIcZrbza8xTYUL569Rxu9yHwZSqlTv3280t+vQ1J5mtEwsjzBlVshDfM4P3FdOtA3CkojLN+IU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 15:06, Pedro Falcato wrote:
> On Fri, Nov 06, 2026 at 01:29:31PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/6/26 13:09, Kiryl Shutsemau wrote:
>>>
>>> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>>
>>> Separately from this fix: nothing on the mapping side catches this.
>>> Every caller checks uptodate on its own (next_uptodate_folio(),
>>> filemap_fault(), shmem_get_folio()), and khugepaged was the one that
>>> went straight from filemap_lock_folio() to do_set_pmd().
>>>
>>> Should do_set_pmd() and set_pte_range() assert it? Something like
>>>
>>>         VM_WARN_ON_ONCE_FOLIO(folio->mapping && !folio_test_anon(folio) &&
>>>                               !folio_test_uptodate(folio), folio);
>>
>> I think so. But looking at these hard-to-trigger but in the end very nasty
>> problems, should we actually reject the operation and do a pr_warn_once() or
>> something?
>>
> 
> Yes. FWIW, this is something that's been going through my mind. Our page table
> manipulation APIs (and usage) are way too fragile and allow you to do the
> most insane things without ever realizing it (e.g you can clear a pte, set
> over a PTE, get-and-clear and discard the result, and do all of the above with
> no locks held, set a pte for a folio that's not uptodate, set a pte for a folio
> for which you don't have the lock, etc).
> 
> Some basic assertions (even if there's no easy way to back down from those)
> would be nice, or ideally yes a rejection.
> 
> I would just add that these very much should be VM_WARN_ON_ONCE instead of
> pr_warn_once(). pr_warn_once() will (AIUI) not be caught by fuzzers, at least
> not as easily.

Good point on the fuzzers.

-- 
Cheers,

David

