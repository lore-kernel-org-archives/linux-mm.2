Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D398CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25E16B0098; Wed, 29 Apr 2026 10:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6916B0099; Wed, 29 Apr 2026 10:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC986B009B; Wed, 29 Apr 2026 10:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1C916B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:09:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B6C51201AB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:09:13 +0000 (UTC)
X-FDA: 84711775386.18.3D19ED4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B80810000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:09:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GvkrbslP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777471751; a=rsa-sha256;
	cv=none;
	b=zRcQwu4TCpdRfMCmKGUTwu/Lji46/sTdtxbHDQaRYI1w141AWy9hZi+3AGrvCpN1Bxf+y3
	q6kwo5htHH2zfRdsQJBjVlyV3zky2hC62xcQaM0xxiDDlRbJNPZxDPiSIhpyu/uw5ySWq+
	RaoWHChNmN0L9yns5v/1M8kgn5i/Z8k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GvkrbslP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777471751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teX1RfIUw+W1+NoFC7Q+/kP3AclaoiM1mcX9824uRhQ=;
	b=pKdUoRPZsj7Xgcdm3EzaqEq43aCTl3RVfqZBj7loMibIaEel71SgW/SJvdPgMZOb+hC6BM
	992ufXl4kh7XiuyMBz0qMjywnQKIJnXHYJ1rla/o3BKYdRc5+NJG53fXhGXujR7FfBLvRl
	3RJMK7Pjt5KKjMHYAL3Y/+6y3vFYxMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A331C60138;
	Wed, 29 Apr 2026 14:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D44C4AF09;
	Wed, 29 Apr 2026 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777471750;
	bh=MyPkCw4jiFzhBkwRoZCQ5vZDCBPFzZNsYDO5Ul8+pDM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=GvkrbslP/xhdKJvHpqOyen0INL8SLOmZNu6E4wYpQdza02dOyBb3PBmTle1kQ/33p
	 Vt919aGM/B+6kb26JcRM2kKyMjjzaZFtJB7fenpPCNK05hEmwhgWo6pw9S8DL+tBxl
	 ngFCz4B7AcO53hXHQ+qdsSRdjCJiu676D5OUIT8yZ3BvOGyDn/k/8VOic8a+Oas+Ck
	 9a6DqRZa/yUvikwYhd6028WYPsOTF5VX0OkNvv01rLSUp0mu0yv5mZdR+g9yYYNYAu
	 fmofb4WU6OVnLbR3kjAClZ/ej+ePosGPDdQbalAovib3P7c3axIb31T+05CW0Ko1OU
	 QrNulooYd/eRg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C7AF0F40072;
	Wed, 29 Apr 2026 10:09:08 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 10:09:08 -0400
X-ME-Sender: <xms:BBHyaegzIbsF-36lyYjViSyRSbWG03AfdMOlRVyxm2zRLO_jWi6maA>
    <xme:BBHyaZ1dNGfn8xUgJn5iF7rJDtBrPWiw-FGV1Vdgd4VBs3SKgQDr7rZPNFVuuzD_z
    g1AY688QHCx20U-NPxM_c4SC9ZI7n_LKFh-K2QL4WUTZl6CDT6vaRc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgeeigecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrnhhshhhumhgrnhdrkhhhrghnughurghlsegrrhhmrdgtohhmpdhrtghpthhtoh
    eptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehkvghv
    ihhnrdgsrhhoughskhihsegrrhhmrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhruhhtlh
    grnhgusegrrhhmrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhm
    rdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehlihiiphhruhgtkhgrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehsvght
    hhhjvghnkhhinhhssehgohhoghhlvgdrtghomhdprhgtphhtthhopegurghvihgusehkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:BBHyaRjbJpfo3Sp2bx_kbAgIBsznqF-7o2l8YvD3KVKbNBxsKgDoMw>
    <xmx:BBHyaSWjBLyZpyeGWlwyvH7noyRiDot0fPUFzM4D8_UA7Hm1H4OshA>
    <xmx:BBHyaStXnm6Tst5HguJgmDEkVJO6WSz_MgFXe3fHquwDnJ6GJCHxtQ>
    <xmx:BBHyaTZ-pErfCj9Z36BHMOK4XbgWHcaHgvtLC0GhgQMZfK5Wtgxvzg>
    <xmx:BBHyaT7dF4IIVlcesDLk5ihBXcH9ZhuVpxtkNa4meQGsB6_8ezuitEWf>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A10BF700069; Wed, 29 Apr 2026 10:09:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 29 Apr 2026 16:08:48 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <5e0a87ad-50d5-420b-ad5a-c2882a619b35@app.fastmail.com>
In-Reply-To: <21a547ae-7121-4cd1-b203-4d8182eb7cc9@arm.com>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-32-ardb+git@google.com>
 <21a547ae-7121-4cd1-b203-4d8182eb7cc9@arm.com>
Subject: Re: [PATCH v4 15/15] arm64: mm: Remap linear aliases of the fixmap page tables
 read-only
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pbhd9ja1cmuuxfosas4cfxjo15zw6saq
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B80810000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777471751-108782
X-HE-Meta: U2FsdGVkX18MjkWREvnf4htxxOFG19DYMcKAS2fCUWcP+UllTnVzsooJ/UoylKdKQpPa8lznMitPnjCse/U3mtshX+CH+QttsF1CJ9A1BtteuXAhB+aHji46Z3Yg2LrQGKPiZlSngxgzfYqwxUrhZE2qY/uNy+dE4A3fMi9bYhhReYI8SG7IhIeXYK4Ua/BTEHBENz6a6RdQds06XTY3SvpHG1TnnN29C+MfiVVvd9jlzYsyLvsMP0pqsy9qqra9/xCu2YMAZ4TXCpB0ManuK7IE8DnmmyYRyN+YzOKjRl2FthpD6GExe/LKd9lVlGw8VSG9TxsJBk8WA0rON9GTc0X5X1QuyoVW6I9RZAVL0d+4DwNaGwkHeZniiHa+OWhMdTuVRKFDTg9uAbpoW937Hyl9IQ0w5JiSZ2IlG2x5+PpJersWMEiflC4lCYjU6jUC99BeUSvCwFKqwYHZ81ygUKVVD4k++hEQ3UHPpCoRl2Ue12nWK5E0oTTaN78tNKtzffzVWOHRcpJeQUht74TyGCQpr0GlDp5qANsv94vngmQgh1QeQ49uOTMAD9nXojlVmKtgYWQ0R3q01NRYS+qEdjkOfad1g7ya7q+OQZdrBRrp0cHFsYl/hp0skAr2umuaztD5dr/r3SJglZsWAbGvbqEDGx2DkD1zilrhAfucqWQQ4wt128eW+i1w6M0F0ejDXzxKcvCFOGwCuU1F2xO+Fepy0jAtqa+RCeyXfsNBcaTTEtm+TnK+i7bhG0Eru20FlpKyQbYQ9NDethIKyrdxsv9uWUqJVYZ98JLVO7X4Lj6jwWsQgYw/uEFAg3SahOm5s93l58Iu6W9tF3uIa0AvWuuCuEwVdV9RTRdQIFyZoYNpUvPP6603vrVwFVsAI+PlM4H/be0DcCl0XwaiClVCH25HP2pSB1sD/HKZnb8ZKigvYA6DJ1rFatt0N9uAUKbj1X5C9icLuQFv/D2Jjqr
 AQcnAD+j
 fBpDQQCVl9AboDNUuTtmJ0MFMCtDwiqwcDeUBibml34yynk6SJd+EGTF/NMbe25xWEHIYaQ8PqHqBpeWlfG2yqQtfYWwPt9YL1npsPgCPJQWeW89fX8Y1IaUFy+qulWrkpAVeWwWY25DklTOcgirR4CVNKxOTDFxyr0CDxmEjCdYzSIZ2WUfrm7LDVC7cfxyplC/S6p7kRonYjPoEnQIwnfVroTGhzjY9hiqn3HXWalFPqHTBOA7cevvoMdtSWupMnTzqOyAJV7p8OgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ard,

On Wed, 29 Apr 2026, at 15:57, Kevin Brodsky wrote:
> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>> [...]
>>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 84d81bae07a7..e76fe5b0c5fe 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1076,6 +1076,11 @@ void __init mark_linear_text_alias_ro(void)
>>  			    (unsigned long)__init_begin - (unsigned long)_text,
>>  			    pgprot_tagged(PAGE_KERNEL_RO));
>>  
>> +	/* Map the fixmap PTE table at __fixmap_pgdir_start R/O in linear map too */
>> +	update_mapping_prot(__pa_symbol(__fixmap_pgdir_start),
>> +			    (unsigned long)lm_alias(__fixmap_pgdir_start),
>> +			    PAGE_SIZE, pgprot_tagged(PAGE_KERNEL_RO));
>
> Is that definitely just one page?
>

No it most definitely is not - thanks for spotting that :-)

