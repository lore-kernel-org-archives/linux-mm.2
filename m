Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA18CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2006B00BF; Mon, 11 May 2026 14:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B466B00C0; Mon, 11 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3137B6B00C2; Mon, 11 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC4E6B00BF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:17:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D01458AECA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:17:48 +0000 (UTC)
X-FDA: 84755947416.16.884E2B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 338AD140008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:17:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wa4DQ1gx;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778523467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8z01zQnY5RSgiyrql55n+yMYC2DmI20ElaLua99WNk=;
	b=BYP6JdoV9QIwwR9trfl+GwlyG0RvPTgfEwxVxS4xQyZt7mQ8qUSFU6zzZH51FjYXVjP0yn
	hCXBMJqbqLNOCMFxR6Pi73pyUK0YsxigcGB60bvmmOKKqPulVAzZm+W1TsM5Ooz4U5vbj0
	HuMnKV2GtourQr/5j4i86hsYfZ+vnIc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wa4DQ1gx;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778523467; a=rsa-sha256;
	cv=none;
	b=zZ0NkZWvcYYr1lKM4L6wC/r28NnG6qm9tRvnCi1ic4hAY0xew5og2tYKwBDrDS60gKmwfJ
	IwtQvlkpFbtD822lvJzYeHgwSBCZXmRmBL2nNsi5+tGmsNBgSdkvXKxnpgUh75VlzNmIpJ
	kmrZjsr0Fmved3VtFeoCkHbJ1sDwyo4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94F4460121;
	Mon, 11 May 2026 18:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE1DC2BCC9;
	Mon, 11 May 2026 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778523466;
	bh=N8z01zQnY5RSgiyrql55n+yMYC2DmI20ElaLua99WNk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wa4DQ1gxnpsUnpQs73yDxj3xAm1Hf1la7aC9Oz0Cs8iKEY77k6/tD+XoKyTGd6bUL
	 NLL2RF3t18OMA2HPU5oS54u9tXlzeePSVlsZ1rohnPAtbQPGKtkR2D1WhZyY14LriF
	 J/O4Ll86+kca3WAqiWNO479TTRNG4uI8ytQjsr/Y5qIk1gka8sE8TkQFbR5idefFmf
	 DhZG0P+mp03pTHjbkUZe0R0FKDp+lEI0uNWjI13LR+vOmrPtrotpC/3mm8WofpDTCp
	 1E2evNtJ3xfZULFNilTzkn0y+Blzm6ulYRx6E9AwcuNXmTF8n9vqi5o3mWvL/4KB7t
	 ewJnFUL0OAFaA==
Message-ID: <5b2efe47-bce9-4786-9088-a727e9d193c8@kernel.org>
Date: Mon, 11 May 2026 20:17:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/22] mm: introduce freetype_t
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 338AD140008
X-Rspam-User: 
X-Stat-Signature: pc5s6wyp4eg5t5kgrm6apditm4uq8fiy
X-HE-Tag: 1778523467-432533
X-HE-Meta: U2FsdGVkX1/HA10e1L8y02BpYXkMiswHu6ujWbla3FV5sxTenyhMwFe/0KnNXimNFDjQqZLi99++6FEncdkcM2FR1ggBBuvjPsV1qSepcfcwLxujhyxPdLbQv0BqKTilmAnbSFMCz6CYivCyAChVn3ArfexHCmMrIrqpubqnz2A70quv+YNYdRVfuX2oV8lIXjMMkdZSr6Zbzod1QgOtDPQgi3+C+ofGjr855KUS/hffh8oKgY8EBK7+ZljByaGzrciYWv8iZ1VPUTLN7OOY1PnyACeIdrruqqLyoyWL+jHIMrrd/8eKLu62KD6CwZGuMxBCvJybYNHoAQ+w3eEbQ5BAiMHivAMG0ycbF7UXGI+u5huNDR20zJktfyZ9tNAvk8Y75axy8tFf+n+4ghcJe2uFgHpCaeyspq3KqsAKuczUrU/FUgdaPcScYjSFpZBSFVDnRp8u5wqraXPeQzv2YpIUeCT46FR8ek2N1LPm+WZC04vv+DRuRIHIWlzDTPUiYpc8YG29pEkWDPIBBgez9rWhA4/HA2xQnMy/oR8Y1V39Qt3QkMYLk/6SusGGc7k/kneHHP7XOUzG1TSroPQ95mhQYYz2bmSqFI/D3t0ElAOmrYenUHJsaUE3e9ei1VWXDfX1FVN4mhjBfp8+vSzZqSTQ2e6H6fFJ3qU5B0cO/auhj0DdR2sMXrRXNV8k6KEOALLlIu0MwJltmZIno1GqcNSjYLDsrm4Do7qb9b+yurX1U+7ur9cWEVtPtk8nO8eWhHcchYt2XTDF4baH8aCF8rvK+sOmfW89DlxwVmERPpQ827xNyx9ceUmlUVnJAsp4ftegs8/09gVG9+ITLV+upTmC8ESp1cSNBt+RcV+i/a2HjeylS8iGXpWqvNmdUxg2SePTj7kssVzT3d9+/kITo3sCsl86Rv0zXI7U6EZGy0pzTopKo47LGmLMs7kkyYwEvmc+N/DG9tGnB9DDf+g
 QIak5UAK
 ZaCguiQaThBTV/24h7KCXIz7ws3hHOYg2Jr6sErFIVEKocnJ6Yl0eXIBboDhIXi0M2Wi3kdYjFKLTEOjogRZ2a1kYEIC7gdcEd2iEW3gcU3RS1X/JRVJnH8RG7hzMQCs6934Q4wLco6hx0WS34Co1pCVISY+Gd3lcpp/HLc6xg3gOaxtSnNO/adskelGmdB+SU4WEL58olvIhddFbZ5n2TtI8XqjveyA67xNxg7+YfoFbMyF4C4h0PyWW5ux3rPkWpEpkq0Dq5VuIrlJd4spPMSMAdAPeNC+2b+MacYG3i1ZJQ+ogRWR5FRltoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> +/**
> + * get_pfnblock_migratetype - Return the freetype of a pageblock

Also just noticed the wrong name here

> + * @page: The page within the block of interest
> + * @pfn: The target page frame number
> + *
> + * Return: The freetype of the pageblock
> + */
> +__always_inline freetype_t
> +get_pfnblock_freetype(const struct page *page, unsigned long pfn)
> +{
> + return __get_pfnblock_freetype(page, pfn, 0);
> +}


