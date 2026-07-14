Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C842BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB9D6B00AE; Tue, 14 Jul 2026 08:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB32C6B00B0; Tue, 14 Jul 2026 08:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4B26B00B2; Tue, 14 Jul 2026 08:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 776256B00AE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:34:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE9C01A0368
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:34:43 +0000 (UTC)
X-FDA: 84987326046.18.0BDE05C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 203A24000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:34:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5y+Y5m8;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784032482;
	b=Dya1BotYw+CzgdDnX2srfpzVVk3tJve/0fNHHIkOrTNfepY/SYUzyTC9BjMRfkDdVMKub4
	CEV4jo3acD5X2mGrYwxL8XyhFN2vRQleqqg0I71zYY0GmtPabDi2udE6eowyKqDAf2a444
	psl9VPofYxFmWAqb64WzeyTv9my24J4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5y+Y5m8;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784032482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVytudVAAcqH1Z8T6UeJAlMy3Z7xi4X8Sx5JR/ITQnM=;
	b=KZsdZN018c285f3VudsCSnpCPglhH8Y9AkLALjIaClqRnXGcOZDnUGLqmWbaY7na+93yKu
	wQWiTFay1F4t35jINH/h7LKRwihTFrRZ/C+hK2UaFjY3/rULZANa2UCBfGi81avGJ5S8e8
	3gC+AaHD+VmLKnghqXqx9+CxsIMAA5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F145740BDF;
	Tue, 14 Jul 2026 12:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC841F00A3D;
	Tue, 14 Jul 2026 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784032480;
	bh=uVytudVAAcqH1Z8T6UeJAlMy3Z7xi4X8Sx5JR/ITQnM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m5y+Y5m8x2Q09OuM6TSOdPfuimhJQPHbp3cXrXsx0i7ySC+ttDKKeVA7SrYLOVCpm
	 FBnLvkILmQGhDl8glfx6icSWfsEtIyLwkESdbmsjr0+Lb/SrMtgw8N6kXPcwq4/wD4
	 5ulcjRMt8dQ6GInb/jGqLjdI+aSi0Aiv9F5Ktica9Vcc4sr8vWynMBrjFu0KfJsPbv
	 FdcOX7ImV5LDJPC0Dfrz/V1xmJGz6e904cW0U3NQFkgpxex1fmL+nYceVkivNSERvD
	 MQdTabyks0ofwHIgatcyAKriO3SlH3ehbnElyL1niTx5dAUfv/Fms4CNz+cbG4GSjO
	 eB+Q0QngQfNBg==
Message-ID: <be0ada61-9a44-4493-aff6-eab4a5049e90@kernel.org>
Date: Tue, 14 Jul 2026 14:34:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Zi Yan <ziy@nvidia.com>, Hao Zhang <hao_zhang_kdev@163.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org
References: <20260710071344.GA106129@zh-pc> <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215> <alEg6ZPc-ao7s6o6@thinkstation>
 <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com> <alYNlDNMQy0Fl2VB@thinkstation>
 <1fc81157-824c-4296-ac5f-e8965f64597e@kernel.org>
 <alYoARy80Vb-X_nj@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <alYoARy80Vb-X_nj@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 203A24000B
X-Stat-Signature: ta93m43jo5ucawt1gra8bxiweqii3767
X-HE-Tag: 1784032481-439344
X-HE-Meta: U2FsdGVkX18Osaq8OQjdzHHql7ck87DPOfVD9++cYuyuofNpuRDI7fAhT8kNfC6RkoDvlMNx8FGPnXgNQa64k0vjcZxCf5wOKPcph5p1J/raA+guiTzZ7MiXhvFRqDyqs1Gu1Ot0CTMFDE7vGckztXkkIghb258IVIlFUsNLYQC0uIZ6eC14a8vNC+Sr3QFfQ03dgFd8Os/JCE16pxyFLVgJC1/IIFX2uKSVuvUh6FWYL0+EKpNDaaci2Buw7jficyHC0/hTYzq92INNXzZf+nQABLFDXMwVoLpErKn4TPiNOxCISwQA/ZW9kLeR9HZkjrV/DWOSQydx6P3VXlq2Xv6vR/4KpmuiNQfgQ6h7ZSydkEYx7HJ92lXQt++HCELCr3hqoPrKw1WwAWArAst7vQbS/IHNzJijOHVXWgfmCUMATfEBvfUvZuqe341tupuW0yt/QuIOLm+DlqlulkD9bD8FfnBvOyNLWenQkHJo5jrKcVKByLWN8TEH40mLk8K3EdMXmgSEOwAwx3RGYly/dH0S2pCasYN7HQ+JE1D9ThH+dB04+mMukzbDFTY64MrxsB2dF/ilgwxYsuJyxXcJ3BjHVyHLRDqM6L2QjBj8m3xetC+12P3y1lS7SxLlBsXcP8sQJ7aTdN5UuedTlW/QCuA+8Br8MbHivzORM6DRdgR7oXfZCOsw8WBfCoSLG/gGXaEbyHWGGMF4hf3OYTfZ4RKZdUIYSQez9dxuwagP8nf1y9BtoGjSW8Ad9uVDytEBcTX7lrp2O5q3GIsV2taQPPxWpfIkCWtiKL7aoYrzUw8e3qTE+6T+H9gdILWtrn2GoIvu7THVYUNT68vKcWOFA5vVcAaa53ywCi++bgA0RwD48MwEsGG6LQm2h+cpYSAqH5eDNYMfmwee7OTgNG7eOZuDIIHkH0Na5rcuM1LmVjqF+RopxmevwVBkhks5x0r1kCGAixlYRFg+XYxdkF7
 F5PgTVbO
 NBI8VZ3bn3OmHxtQ3+9E+nPF20AAKuxiV7BH+rtn0S5anIHemTIsPsJNfscDoqorUwpiCnqNe6BxPbWtH2+AdfsgaFU75/pXVcVRuIzJSuXrPRNjl6R3L8B4I1em7LrithmENjZzp3wcieGrdLrFjIhd9kzJdowZ+peOAN0C7/X/lh3ybrNq+0k+bn3M8C73OhrkWQCk/NsdLYPg39rN+1Y7X5A7sOgvZyk4gV4nRzNcRC8WHeFkxTmnHUep/zLT43XJRqhmgDTQh1a8mCiiuWfiGNu3mi07HxQlSoHM2CLId4XXu2Nxln9q8jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 14:17, Kiryl Shutsemau wrote:
> On Tue, Jul 14, 2026 at 01:29:56PM +0200, David Hildenbrand (Arm) wrote:
>>> Any opinions?
>>
>> I guess a deferred iput through some workqueue is not an option?
> 
> Hm. This feels like a dirty hack to me.
> 
>> I'd prefer if we could keep folio splitting working even when the passed page is
>> EOF.
> 
> Can you think of legitimate use-case?
> 
> I will get rid of hwpoison case. It has no good reason to lock tail page
> in the first place.

If we can get that out of the way, fine with me.

-- 
Cheers,

David

