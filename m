Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04DEF53D6F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FC06B0306; Mon, 16 Mar 2026 12:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040106B0308; Mon, 16 Mar 2026 12:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF536B0309; Mon, 16 Mar 2026 12:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4B8D6B0306
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:19:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8758C160323
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:19:50 +0000 (UTC)
X-FDA: 84552437340.23.7970202
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AD9D680010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:19:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DSIiU+fH;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8xlB7sichZuUCMp7QTCmaDNb+twUuYU3BGiUNHLeAo=;
	b=h+YfkGYJ2JoxV6I1hfpSMLF1LYQkeyc+Z8bfbunJDZb9eiAoeAJyIJbdMf8M7MVCPZEC6I
	1pYI1Nc2be5xFvMlNVjAFeES+hPoie+a7A3oyM1DGV1a18ZzaaXXrWm4BI0vVcUy3HcQCI
	iwbn8rhnUHejQgS9+OdngAgdsWa5p4A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DSIiU+fH;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677988; a=rsa-sha256;
	cv=none;
	b=uNZiWYpS+0swbQ3fEqug/hHNtcpYfjicSw7eyQBMfmno+IV8L/XYYxpAB7P+8nxbyyMNtY
	6ZoEHdaGIEA+Rr+9Ia0Xodx1itPioiIus8Nvy5najLsXyJmOyS6T1pHPEzFZDeqIvWaDjk
	PtYMpqMn5UI1yv9J4+ExsIIJztYZyKA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD2CF43270;
	Mon, 16 Mar 2026 16:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D161EC19421;
	Mon, 16 Mar 2026 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677987;
	bh=OkmtNnOzPdtE0Ofj3xzJwcmVrMrtLWm1U83jw7E9K38=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DSIiU+fHtk9ZRbCLUJJUI2Bm4P5vlwaJpKFoGdeqORxHC8c9BF2qOm6gaRjD4iM3W
	 LKQwIcPuE74LmLJT457pm4ISCpjmnXJa8pPZjaFI7Z0vH3ZdMsfkJJNTNtaOGuCiIv
	 LWQsO5qRx3M3/+/cAkkJ6Zy7aC0IdGJqtPLHwLFNA7Lp2r5ahsVYX4Wx7qMqPD9uYm
	 cGSfg3AVPkgq+nylubvLjz5fJK8NIvaQ1L+pKn80iyW4Mpu9fiKdHC0QCtPkAaw0yZ
	 QO+I5ieXpSmqGAvm0+M0js2JkYAisR4iRxxK75TMqCC9mGmw1Gbnj5Tf5mD7u5Pusl
	 zmhru03M4EY3Q==
Message-ID: <fde63978-d632-4196-b032-4cc20041fd90@kernel.org>
Date: Mon, 16 Mar 2026 17:19:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Ryan.Roberts@arm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-2-usama.anjum@arm.com>
 <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
 <703BB8CD-23D9-4012-8333-366837D7E95A@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <703BB8CD-23D9-4012-8333-366837D7E95A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AD9D680010
X-Rspamd-Server: rspam08
X-Stat-Signature: 7ddjyqkg9re8y8r9a75mshuscgreinit
X-HE-Tag: 1773677988-581487
X-HE-Meta: U2FsdGVkX18YYliqqx3/jwMh1wUfc4MLFsb27x6BneoOmdCHIf4Piul47eeP6Ek+0pzCaj4aA2G5svk9L8TmOKErNPAzw0U4AsHkwKrqx36Zcq4I2cgl74Ef1N/0IQ+M+1YI/1lXHTQV5pShDDmhcKGWM9EZKDZI8fiN+aCXfmrTqpcQJiOcxXOJDtVNxlxwBEGY0VBEITtOONQ7Ja7k19q7ZcPF205YO+uW3A3BFTlm1f3rd504Trb1LrTdH6XjS30/oOjBhN+cxFJpokyMsX0f0Si6jFZ17cfPbu4d2aYEJdk38o6vx8fKG+E7cI7AdRhecCyG34xIhm1+fta14O9f5O61PgATi1ui9D5BewautFCOKUEyaZocUi3rLxyzlDGQEmkT1zcxmGYPpFO3cYykfz2eLCy55r8tqBpMC/+4bd570WQd81VdtGDxgAEFfUFEvYQ5Oeg2Hyuq2ApuoF95oeFLclenFns1O5m3cvSccZyJgl7A5vsr74vY8tAiewZ+ah9iGkC+4jbO8hPH5W/IkFRC5F10pOVwyveT5F2bB2Cva9OLWMGpYmZOOxkplPw9LygmcgHO/QtoMROD3N8SNGLjAnhfD6hhPhnrNZO/7uq3pCH4BBmd+9NOblpscWohpnMdbvUzGODuoEvdsfcQ9ta53RYBA/zOm1EDzv0z/Y28mosM7AZgtAISF3NMCR9q6vz4AEua60N2gi2gDxqDRcSPgx81qrT7nnZSzpnhejug41/pEfcpfm+0keRC9FlYAuGfoLiHMWw7rTAthWDp1KSrZtMJOVCy6fSVLs16mcFmgzZ+AIPwl8mGotQb/k0HPon7VWv/0YAwjhBe1agmbX8kK2FKFFKTcosKiXBe8FGOk3O4CHHmdvAtffLFc2nfoS4tIper7ltEoWiuZ373/73N/3kWtImP+D1eBkyDIqZaYGyEukMrxd8G3+81CpF34DsODb3O55KYxq0
 K3YB+/Nb
 UmIVm2QCCdQLn9A7z2taDN+OTtg6us9dBgMtVY9aYuXExQf21vbDcwMPfcBg9GOZpXm2rOr1ZO56wiAfb56klDIkepX1yVxSgVUZYiLcq68yDnIoJnQqyV1rxqyEKoQSWBDUV78UX7zhA/ZRKBtLEby+U+TO/iRcfNCW944qM24RW86trb5t9lqp7Ep1WUo9l2vjcaHxdwWg0SFuUKA4eHuaJ92UizwYLqOqk8EyqiURrufyofv1I/nBXNjlOy8K0kkq3a0gEsog3k0h6L1KEPQZpJtd8ExWCIo3uXHnbSatI0WyWENcfth6QxxmsLRrk1xelYEEmzd8UvCnbHJkvtwcJI1AuwLpH91iemPJfxCnv8BhrarwpKb/GVyCDnARvhrAN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 17:02, Zi Yan wrote:
> On 16 Mar 2026, at 11:21, Vlastimil Babka wrote:
> 
>>> +/*
>>> + * free_pages_prepare() has already been called for page(s) being freed.
>>> + * TODO: Perform per-subpage free_pages_prepare() checks for order > 0 pages
>>> + * (HWPoison, PageNetpp, bad free page).
>>> + */
>>
>> I'm confused, and reading the v1 thread didn't help either. Where would the
>> subpages to check come from? AFAICS we start from order-0 pages always.
>> __free_contig_range calls free_pages_prepare on every page with order 0
>> unconditionally, so we check every page as an order-0 page. If we then free
>> the bunch of individually checked pages as a high-order page, there's no
>> reason to check those subpages again, no? Am I missing something?
> 
> There are two kinds of order > 0 pages, compound and not compound.
> free_pages_prepare() checks all tail pages of a compound order > 0 pages too.
> For non compound ones, free_pages_prepare() only has free_page_is_bad()
> check on tail ones.
> 
> So my guess is that the TODO is to check all subpages on a non compound
> order > 0 one in the same manner. This is based on the assumption that

OK but:

1) Why put that TODO specifically on FPI_PREPARED definition, which is for
the case we skip the prepare/check?
2) Why add it in this series which AFAICS doesn't handle non-compound
order>0 anywhere.
3) We'd better work on eliminating the non-compound order>0 usages
altogether, rather than work on support them better.

> all non compound order > 0 page users use split_page() after the allocation,
> treat each page individually, and free them back altogether. But I am not
> sure if this is true for all users allocating non compound order > 0 pages.

Maybe as part of the elimination (point 3 above) we should combine the
allocation+split so it's never the first without the second anymore.

> And free_pages_prepare_bulk() might be a better name for such functions.
> 
> The above confusion is also a reason I asked Ryan to try adding a unsplit_page()
> function to fuse back non compound order > 0 pages and free the fused one
> as we are currently doing. But that looks like a pain to implment. Maybe an

Yeah not sure it's worth it either.

> alternative to this FPI_PREPARED is to add FPI_FREE_BULK and loop through all
> subpages if FPI_FREE_BULK is set with
> __free_pages_prepare(page + i, 0, fpi_flags & ~FPI_FREE_BULK) in
> __free_pages_ok().

Hmm, maybe...

> 
> Best Regards,
> Yan, Zi


