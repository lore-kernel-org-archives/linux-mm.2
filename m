Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE4ACAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF1E8E0006; Tue,  9 Sep 2025 04:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F568E0001; Tue,  9 Sep 2025 04:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DDF8E0006; Tue,  9 Sep 2025 04:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 230C08E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:59:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C89821DE210
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:59:50 +0000 (UTC)
X-FDA: 83869114140.27.3914A26
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id DAC0F180004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:59:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oOIvQ+nC;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nodJfdwVRCZvCTwxlV8y8NKQX/2+OTsfIaKMeqB1pag=;
	b=7KkHClFVT05lIDgNMtiBKEzLMGAbyZOfV+7JQw8oRPT/NcboQ05ItnKzvkYwQKkYPSJE1B
	CQegEx1wZanp5cKXLQ71cXkDonTQWonvvz0M/RReOFp8SSRtwL8Ydc8eQkRLgGMek074S2
	4gk0exM8OkfyWqEqzH+ryh2h+Uckn/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408389; a=rsa-sha256;
	cv=none;
	b=ZfgHmK0U8o7WWxQ2DE+tT207NvrGef4edVpti0N6xba/YU4DuRZrheTNcHx1a4IiXlhpNk
	HcTg0vkH1WmkbP8qYZglEhCXcugcS9mxr/hjE8uU3ao/pzIWdBFTOjdFyBO0m2fr8W2IAc
	1arC8TO5vscveQjzYecdqW+rrT0//3s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oOIvQ+nC;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e058c588-2fa3-4763-bcc2-06b6fb6eddab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757408386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nodJfdwVRCZvCTwxlV8y8NKQX/2+OTsfIaKMeqB1pag=;
	b=oOIvQ+nCSC2x2F2pS7Jyg0ZIIfLl6aCYpvEkCgZ+duQWJmTwWbXejf/fkr7OuqoNm9Hyk4
	XDMMp/A0pbZVBi4EW7bGZyoQMBsTqRc0gG69MRXIRgmtBM2fClA1F2Q2GNVSwFKoHiaNpP
	nFfIU64TyJK29E6p6s3yn8eBCuShoE8=
Date: Tue, 9 Sep 2025 16:59:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/slub: Use folio_nr_pages() in __free_slab()
To: Dev Jain <dev.jain@arm.com>, Hu Song <husong@kylinos.cn>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909074812.599030-1-husong@kylinos.cn>
 <c880df01-3041-4af0-b4d1-167193e8e6af@arm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <c880df01-3041-4af0-b4d1-167193e8e6af@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5cbhg9skeon1tdfcgxw3oj64fzybwnzk
X-Rspam-User: 
X-Rspamd-Queue-Id: DAC0F180004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757408388-2407
X-HE-Meta: U2FsdGVkX1+sQdqruz+ujnuXW5qTYpzSnJ3wu1habCF6zFjAsQMd0epQWRu7bznHNHKA9LZoebhmT6CMR+/nMwD/Q7Q0EM/hJvt6jmJ7KNnmgksJlYo/oQVs7iluR/auMt+CA5fAuzhS8704AfFjHAzaTyOM0TuyruVCTiQUupLoOahP3toL9kmtTEDoo3naH++GDTb5Bp0Fcl8UDWFMo52kbVoyaLJpBd90Lfkr/VTKxkL7mKYLAdzTKOfi1+sZCLQ2TysRsfWct3ekGzvSmU2Sgo2pt0Tbla4fIqP0yeH3eB++wm1C0NxjXoLoTl0Vcr/3hNH8XG6zLOrR8ISXS1z9Aa7lT/teXQT2dk5h4ntoNtACtuB2lqxzeVMDCY+11s7/BU70gmbuASlJIYtaRHo+XjuklW4uiD0Encc6DsUUOoRgPE/zb47IjoU84PWoyJKIQFmpLXPFLWMt5yOzR9db3bFNPy1PMhJCj2qBeRzB5SB+TZzdzCmiuUNFIjWg5pyMRQTE1AZdRZl/a8XP47jiJZ5DgEetdp0MV3BXFt2BOU+1oR5Ws8tmmVN6olsVgpPM6n+fV+QdGygmaBX8MtxFVzXhFAxbPcC6onTgfpn1y4opZGObL4dYsvpqmyybSJ9uWSa+aPu5VzSaZ5i1MMOnM/qamWL7HLbB0Q9oBhWnhD1Av1A5690g41tlWhdkv/+QpotfFzrZ3xdXNYxBivGeDkP2ZzceSwYhSKD+WlfR7LJYdU6NjBqGIyPBtFDpbDL1K3pkLvGllfw3MiZtWb6oUCqT5LkBFraA6+ywLeR88HmA++dN24AnyOL7E+MizyV0dTOIDEc50ozEZhWmqfPQWXkkmgKUSJlJG/OuIN5cg1BFHnXv0Ktx2ovER3Wlnfepx8m9Kl2cmZR/WItJaADurL4xu1G/p6RD2Mf8Gl0i/Bc3rVhdiatge3bwxjmVc9XbqSj/LM5GXhQZCU7
 MgFwojuk
 4eKE65zx94PedITtY0hX2MU9SOXVN8/KzKIXv85N+BeM90bqPJxyq02MLTdTQv9UBCsEUN+09K28txmzPvJ9itdkLh/KNBzuroIi8Bu3vxhoPPAQSYBlh91RMSLHlpPJhwlJTf3ufQ6DtwuPABas+lz9Mmw5IFt85sdWqEAQb90HQFtcVneRM+bflyTSnLpNkQ9OIweklExpk0Vrvle689ejgN29JC+WOWWS6yqhYGjVviTzSl96DrcisfAHSbZcvmhM2FpGKifxGODWaHsc5HysG/42zSBH2EoQsJzxe7reuhxb07hRC2oEpuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/9/9 16:46, Dev Jain 写道:
>
> On 09/09/25 1:18 pm, Hu Song wrote:
>> Use folio_nr_pages() helper instead of manual calculation (1 << order)
>> for better code readability and maintainability.
>>
>> Signed-off-by: Hu Song <husong@kylinos.cn>
>> ---
>>   mm/slub.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d257141896c9..eba25461641a 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2719,7 +2719,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
>>   {
>>       struct folio *folio = slab_folio(slab);
>>       int order = folio_order(folio);
>> -    int pages = 1 << order;
>> +    int pages = folio_nr_pages(folio);
>>         __slab_clear_pfmemalloc(slab);
>>       folio->mapping = NULL;
>
> I don't know, the current version is more readable to me. We literally
> compute the order before, so we do a simple 1 << order. I'll leave it
> to the rest.
>
>
Is the reason for calculating 'order' first because it's needed later.
I suggest using folio_nr_pages to replace the calculation of pages,
unifying the retrieval of pages in the folio and also highlighting
the significance of folio_nr_pages.                                   

-- 
Thanks,
Ye Liu


