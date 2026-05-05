Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B33FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 14:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6F56B0005; Tue,  5 May 2026 10:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E582C6B0088; Tue,  5 May 2026 10:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6DE86B008A; Tue,  5 May 2026 10:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7E196B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:36:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E8BF14044A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:36:27 +0000 (UTC)
X-FDA: 84733616814.20.2BC40C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 367AB14000A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:36:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uJeDBL1z;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777991785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHynoYRmFpaPuPJMTFZ0gSzGpDmQrsCkN8rg9hBwUFM=;
	b=LIAr7IVZ9Y2Shig4+ENASzlCliloXBfnfLioyeBSWTtehoP67/hc/J54WKDmOllUO2Ah6A
	fvZ4nxs/31BNqWQ1ncvy3XHfcQLIb3rrCsyi6Fi8ec6/s8nBIhstiDbHUXgk6QPS/Jtd+r
	0PSdDfGEcpfVODUii0p48KutwRr/2Mc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uJeDBL1z;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777991785; a=rsa-sha256;
	cv=none;
	b=IOi18rty2IMoY4yZpbprSsoM7K1PNiVLjUjJzvWzDi33+Gv02mIcK222Eof3cc6DL2e+Lo
	ZD360FdwhDwyorpZya1Y5pDo/eo74gaGWuWOQ6u4S4ghsnuVFwBntELEkpthaiplDI5GS4
	2z8E869ZbnqDM9Dt/Fe+Cc+sjsbGfB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CD3A60181;
	Tue,  5 May 2026 14:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B04C2BCB4;
	Tue,  5 May 2026 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777991784;
	bh=2xkFDwlC+IWShtzQAzAENKkMGOymk2EBq3bAoKPy4cU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uJeDBL1zW32sSfsU0EVvh1C3ZGL40T5v2yDdUeNG3e8x9eO1kMKrvMD2iL05ugjWu
	 B50XkO3ErkTP4AWKoQewbmkQN0OApsrjuUFuuPfM/lbtFjxjDTMb8R3zxsTzf4FATH
	 NnzY4R71l+EJeUQMfWfN4n6MLqliCseQramhmQaaA99D9oNOp0LGP1EzxtSlNGQuPA
	 QDI+OENhxysSav5PsHElzc3zaEZSThF4rNPwuFLE1MrpvPxWUw10z4IbyR0KqZcD9g
	 PbFcC0GXnnimo0GY7+6eV9JpB1U1SjTRPl9pnumLw9Vfbus2mfRe0cFgCGJ50s5zAH
	 qDvDoX3YrbjtQ==
Message-ID: <31e04da5-89ff-4efe-9bbc-6845e4ffc45e@kernel.org>
Date: Tue, 5 May 2026 16:36:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix __vm_normal_page() to handle missing support for
 pmd_special()/pud_special()
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>,
 Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Bibo Mao <maobibo@loongson.cn>, stable@vger.kernel.org
References: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
 <afnffbs-5cy7KGua@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afnffbs-5cy7KGua@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 367AB14000A
X-Stat-Signature: dfy5qfpj98udmngeyd5gxx5ncodjzszd
X-HE-Tag: 1777991785-800387
X-HE-Meta: U2FsdGVkX18BdtiQXrHYwxgf787vWZWqQqQliw4YrmxH5jGVSxDufdCx0xaO8KoMpI9yJUqAh7sOWOdSX0qoA8FK1YOPCc7mqe1ePYIc99WJaFO/RCqjw+LV0kGsxd3VZ09WYvqduPpXdAP2S1qh4YkxAE/wXgTf4jD5th6pV3Vb2yygTGghlxBMqvBhWWkiOHppVq2415+tvYqRfmbS7Pg0fSFMM0BAjnIiJ3e9CBty1XG3gf3tR4RgQORrUB+/ib9ZY5zNdvTmmHmVvlOgWEvmqrFkbjf31QGksixp4fGOl2BSjT4UgCtSugvsCEAdgu5owEOdNiL/QIjPEzRoLeUmonl5BEQTZGYghn7fVvlu6TY3MvGCfghpTrftBXDR8NzQzPaghlL5LqajxpbSFI2fv+CKwHf2ypdDbkHvdG9/GPCoDGgfQNWovIEyeMXqfvc+nj08iScig7p412yy32jy5ISx1TxC05vbsEK0UPn18r+qwPlnhCHPUtsgulxG8R3Ztjp3K+a+ek1Mov+7+n7IzYYZYeOvg1F3PlCkKf4xHn1hTFmt5LnLpCcgy5/4SB0Af05/RYnmmO0G4Pz8WBIdGTeLcQSrTW/sjNmjNI7jBmldPt7K5mKymEkjDTYbk7g8Qhf/q1DGjFcbEqXgln6on2jYy3rVtq3D685DgF/xdL2W7IBipe8BHiRWJDojG+PrNpLN3XezsCzvNxha1OJbX6YwVnaeNZZaT+Gsl0CnmsOuh1FIQFXtXwXSzT4mmrYwiR6MHwyuSRI94ZYPyUTYEIUlbwOcqwwm/ptXSSg65DtgbTrz/ea0gVzPmgnpd3UmzqeT1Ag2tEFPkUUrOk9NzJv3Zx4s1rc4Q9TKkZ3YaUeihocREhjkJQySo2bv8HT3oXzQ96x3xE13m1Q6zCPHDmZrfX1twcFe4WFvEgMB3mZlltLDwy0fRbAaNaRD+g00LmLRiEhLSe5mQkT
 saO182C7
 d3zq0V6ljoHMHSckYj9NP9/MlO6mRwQgSD1Lsw4knEXZolX3VDhXf7tHAGCU4XhvbhZmjye2WulS+ZRdz/jwPc5YGjYCeJX76/IJ7G6yWampaNnqxbBSgi2Owh6QemvXHL+ZWzfmaS/k167T9cVTzYRLprs0rfLQ4fMrPc42Jo5A9p20yIwTTXBZFGiBPKnXX0cE9MThJeEEy8U13IXBRQETyR5YSjjRd4iz6eLEAHryp7BH8VhFSMFcTgQ85Vp9eYf1B3Sb4JgjOPYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/26 14:20, Lorenzo Stoakes wrote:
> On Thu, Apr 30, 2026 at 01:31:22PM +0200, David Hildenbrand (Arm) wrote:
>> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
>> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
>> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
>> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
>> when reclaim gets to call shrink_huge_zero_folio_scan().
>>
>> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
>> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
>> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
>> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
>> on any 32-bit architecture.
> 
> Ah damn. I wonder if it's really a combination of 'supports THP' and 'has a
> spare software defined bit free in PTE'?
> 

I think it's mostly "we have a spare bit (pte_special() implemented), but we
didn't wire up pmd_special()"

Thanks!

-- 
Cheers,

David

