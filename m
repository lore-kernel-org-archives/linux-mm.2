Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251B5EA3F27
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662716B0005; Wed, 11 Feb 2026 04:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616986B0089; Wed, 11 Feb 2026 04:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FCD6B008A; Wed, 11 Feb 2026 04:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FAEF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:29:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3313B7CCA
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:29:49 +0000 (UTC)
X-FDA: 84431653698.17.F947A5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2B1C68000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:29:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMaLRZBS;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770802188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fwc1IZVDl5koKvbhTGOWNT1lDUqHawCcT/+1npsTxQ=;
	b=ArjjntuTzMMlW3jaIz10VBBZSo21e7wExxCMsfa3aZ2GeJw3t27OQW4GlKYla7OzNNuRUj
	PW+l/N0hzbVaWQtStytKZ69MsfdRk1ldbWQHFChdjeSLSBacWRH/lVEYZHf1xo0mWWAZFE
	e+VGO8YTPM1ShovpkUZbkGoOSYI7zf0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BMaLRZBS;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770802188; a=rsa-sha256;
	cv=none;
	b=bpxfYU/J7taya6FS8r1p0ZHjedu1skolW4zUqvaMQ+LIuqWG4SpbvB+P/SUy6HGv9G4s85
	frzpCvfeaFnXTlWt5iB6SMGQ0iEU/z5frAgG7/Le8EqmQQ+W02BWROqLIDsobbWZ+4PTxV
	Yjw51P9YsckRargtN67csdSpHzlINSI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9378F60018;
	Wed, 11 Feb 2026 09:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF60C4CEF7;
	Wed, 11 Feb 2026 09:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770802187;
	bh=3JiC8/bVFvEvx5XbMpJxOW9AXyw3Kn6clSPJCGhCMfg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BMaLRZBSoyJej9h8rFbWett7fI7DOWV01JMoluJ9BEXoEd5AIF4J7k9wct136eI9U
	 zk9Bc6kwY3f0KkRVUwzu5DdBtmEg1chlAnqZYJSHxBQLpnca04PdXtNGANKu8r2eU/
	 hpcipX0X6sYrojfkh3i3oaPQePjYXTmXnKcNv6BeNI1CfHVQlzq5XOGjZ0IvN3MRjz
	 th9ztcw5lWynGDAHr6IlsolYXGVF1pL78gR7EFWjjynsdV44InfyEoyHSs+XfyLtFt
	 GTEVICd9mm7h0JuFjfLSTrlmtRV/QgpT8oA5si0ejdsnJ5txVNRD/54hrc3NLVJu1L
	 qpWP78YC4CEZQ==
Message-ID: <5759bfba-f235-4b2d-bb30-919dcdfe7b2c@kernel.org>
Date: Wed, 11 Feb 2026 10:29:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
 <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xph9f3ya95rkdbsok9w69d5e1smyw3o6
X-Rspamd-Queue-Id: 2B1C68000B
X-Rspam-User: 
X-HE-Tag: 1770802188-81084
X-HE-Meta: U2FsdGVkX1/g5aDJ0GuBMwBVjdfEjSZy3OAxxKCLGiTePNhUa3upLYGmYq79CNe/6u1TAeK9bMwpBEx4iq3SHxBo+L6U4qhUliYMNaccx1C3AgX/i3WyMH5AtNT3seVUC2yUk9o7Wydlr0KTrPTPAr6wLa5oiGTvkeAxGnNFykXvq9Z8XCo+iJb2hWyNn5556ija/2UniaqaEqN61020FknOaShKdyCs5F1ctY8WxYX9BMjwT5FwcUanVbiRCvidSNE1vT1N6DAcmSdtwHHeSVBpEPkkUTcczAuVtIhEfriqLX9Quomy2Zsc7GEUR/IG+6tuCfJRh0SGTTl2bSf7ar/g6L5qRJiPaXF2iTJ0Vc/hucZkp4MQDeFOSMlPOPUg0fKFB1/UNZ7ZOdgiA2ciZN5muDAO9mB4rLEODuHnxLDhtohv0CXAo7ydTSFdcmtLlZD/i/EgLsXdxTqg38mJQeMvNdZ0Vtftg/hKoahqnnRhgwnOlf5m6mTqm3IKBsGt5yleAayocHmwpnoDjkd9y2dzTMoVlieKXTW7VvHnP5yhREqMOlIXnAp2K/gAfoRmnaeY6l6OYaO9RZTP/siF4esp9QC6Ijt2gMu2PKNP4d0Vj0sd4SNoJc/slgJsdlA7V6Av2qWA5gdO78sXEyztRjFNjhpRG4VggwO77DsSUOdL8B1Ur3KKPJbwE70SuwZ0xen9QxUCcyVw+7fotSVvr5YOI2SbgLAIXngF0ZIlZVG/ZA0Ne2uATAUk/VoGuwAJ5j4C/xe2s+1g4kpTWRTRyp0xE2ojmEz/AxZ1YNYMctBR8FD5LhqDRZYn3mjYzgbZpKdaesVQ4eT/diPlDY7a7PumUqRgcst6FlOGL78x8Uf/seWh2SWd4wN56EsNSk/YU98LYRvw4ZYXdaTlk+5M+Otg754Z2nc02OExdvAlvmxCX2UMhgUPX7BIuUnxVskaCKQibybZueaArdt4Atz
 56rd91Va
 CwBuy6bI8JGezBQz+9c/J0ErcqJEwHs0m6UD92l2701k/xTZPwMpJM35TyUn4qa4I4BXs3deDHJRYrEpIIdXJynL1Ioy82S3fSLecAL438e5tAQCLHCI69LOANtyUUfduGml8Mt/IQ+GDIOGl76ggeSAchl295MKX6KtgghaOGv4CRN71HiFUxs4CZR3j1s/wrC30RfVD0cwRGgNUbspBBIXnfHsKr1tZAJuX93NrvGeNrFQZuXaQynMI0wRqug+3BNTew8AWXpr4lhax33Rr6JuJO3Nt6lxAdD8pnQCndA2toHnbGgGqDZqrDR3Q707IwEWXQpW47S/1Sw/G3gmnzViFHGyAbVWmQvWl01OzvwQrbU1qWE98MSa1euzff++VRev9dGqhJlBjDtNKsXeTXgSse3CsxcZE0TFOk974Wt/7sq+gkm/Oy7KbAyQNDO65Ltrg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 01:58, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>
>>>
>>> Yes. If there is no guest_memfd we wouldn't need it.
>>>
>>
>> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
>> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
>> skipped.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/khugepaged.c?h=v5.15.199#n469
>>
> 
> On 6.1.162, secretmem VMAs are skipped since secretmem VMAs are not
> anonymous [2].
> 
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.1.162#n135
> 
> Same for 6.6.123 [3].
> 
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.6.123#n125
> 
> It breaks in 6.12.69 [4].


Do you have a reproducer? If so, which behavior does it trigger?

I would assume that we would suddenly have secretmem pages (THP) that 
have a directmap. Or some page copy would crash the kernel.

-- 
Cheers,

David

