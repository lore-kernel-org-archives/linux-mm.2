Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA2D1039895
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCB16B00E8; Fri, 27 Feb 2026 15:42:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1A76B00E9; Fri, 27 Feb 2026 15:42:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596606B00EA; Fri, 27 Feb 2026 15:42:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 48D586B00E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:42:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFD4FBC02E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:42:23 +0000 (UTC)
X-FDA: 84491409366.03.01BE2A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D869C0004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:42:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EqFMTeCp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772224942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzMaCCTu2BeDSrqOuo7E7DuXYBR5vbaB1fzg3WOxQps=;
	b=fvr7BnGvI5RRT55l6I8A/qND6PGzCzGtMtS0aQ7t6SuHHBv9odmPiI/MggrWxastpLNljI
	vNUJ5LGct3Kr8H9rG/ZNrcdCY5LY9yxSFfQk1pWtx/2HRV+aA13KaRFUbYTm3vaqc3Yiss
	QhY8rMliAGiDTstl3dOinOPMKB+rrcQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EqFMTeCp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772224942; a=rsa-sha256;
	cv=none;
	b=1DX5oa9X+zxqRFC/qXMRhlReqOnGdMPTqJKF3T+N8Vv3cgoXeIQ0KzHw8At1WaLZUA48IM
	naWOr5L2R5dD8hajoH8pXIq7SYPY7JPNxVzDop3iqbOoLXO2lWWRgqxJUHgbjnHBeg65bq
	V+vmvdijUbRWigdFFqln0yPCVEXHme8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0444542B7F;
	Fri, 27 Feb 2026 20:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DDFC116C6;
	Fri, 27 Feb 2026 20:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772224940;
	bh=tF4I9uEanrrL49/IrO6k2ajtwrnArvy+ifACjY+WOKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EqFMTeCpdccKnHFagxHFbfSZQ7k83CljVOzyZNeUfdyD5/mWD7u8MvVh7fCUgkah6
	 H5XXuZNBOtuHNKlEiJIXFCilFFUA00P+ElZDSCxcO4Jp176slvu996zA0Y+0qpgWP4
	 HID/JnTAICa2VPlzJykgPb/KYcRWluRLNPQxRJqB6x5hfiqaQ3DrSRF7nBuIRXkX+u
	 FkRUS2xrbs9z3+dTD1Armjnrkb5xWJX/bqRAl9/naIpHU1EOr7WOCI/BmmMoSMDMus
	 q9/iMX+dbLeLlP7ucuiOXbvdtsm1SWAlgb66xTsm1Ty/tVUzd5QQr73g6DGTTIu6/8
	 QfpgILk9fYYUA==
Message-ID: <cea5eb0a-6f8d-44e8-b60b-ecd1f7ee059a@kernel.org>
Date: Fri, 27 Feb 2026 21:42:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm: cma: Export dev_get_cma_area()
To: Maxime Ripard <mripard@kernel.org>, Sumit Semwal
 <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
 <20260227-dma-buf-heaps-as-modules-v2-4-454aee7e06cc@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-4-454aee7e06cc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1D869C0004
X-Stat-Signature: m8njehxusjzb5o8wi1eh5g1q9i1m7mou
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772224941-956273
X-HE-Meta: U2FsdGVkX1/plb4Z+ehhS5hCqbJC69hD3Q/ZYROobu6E4gl+nAQdxUnWAupugKaJOQFGjwf91LPeHfUAB4ybe4hD2zMaUEH18u779jupsXqTWW7Du7kqyZDBxK7wKtNmjcYr10zfvRghmjsyHwThW+e3+bfX2gIXQziLnJHj25XsYsLK0hkhHy7qayP+qtTxSNYQcgejIHeHkrSVgkz+FhY345bXzdwjHBuNr3LD7vDbiCJragWiEnmiF12j2yV5NGYfL+sjaOrGKz31gpEZBiNj+iZB/pP6qcyafqw0IMu36hNbEnapT7wQylP5zAgiz8vPFbmsZo6/ixY+YSquXs6bgY7CV2rwJn49f+sXaIHyomej9Q6iSGJfj7kkrpwPgSXBoYLk2inzLroHglIEBL1W2rVBZsc0+d93iPI+wUZlT+1woGsyQoHm3G57TbxJvQ3loDUwIsXP3gf1XONfgSdHr3s5mQ531KhrGn8F1SK6vH45PhKraF0wZQ6xpqoJStiMUHnLklMbOaOZ8XzytLUnSeErgDtISzmg8O867mntROzq5L3gRAAKn36SFrCjXV9g6DjkpV6JgytuVVgWe/CE3xJ22mxSUCv5aJ9hPpnjuiy9+EAYc4bsmlRDV3560tXO2Yum6yqNu5aruYM+inaWHpWdMgOAUi0DA882DSYw9kQGWVf3DMVRpy+o0dPH6rCU3woSyInHMwD9KoGgovDXFQSFeP9cmAejAmNRNmo3UrGkpuU/HWHCd4vG39HhLqZZ/nRdWVi4fbJBVrjn64E/49KRKn5ik09UL2xELcfpyaMFfCvLPdeIN/fg6QHVSBPukwN/0o4Ddj4NW5s0w9Z2Z0gkKmVsrSFwDEi87xvdCBuFI8WJh79F6H0gGnBe5Iw0X0blvwAs+H71+aQgBlDm3Ka209RLu/qgqlKZJ9LnnvqE66Re5m4+pFWFON57pQH92pLbe7CZCMtofMt
 xuNrjE84
 zhcm2h6A2FQses3my+zFR0vyWDlZK15Y4yWZPVno68jGDhfxzyrvH+NIYjxNz64XmXjCm181Ui6Hdj7lmoyA6TDrZSybM6uSFiyL+dhnCV97hDjnSFDoKVcHBodsKh3hwZj7614gfRE7HI5PGdTXTf5Qs7+onTWaUZo+a628IgDX4kidO/hXKp33KkRHU2QTZjVZ3plY6rx6MZ15d8Oh/SuYVQXbFB3QdkAt68Kqm/0VteyqVWql1mfxeBcF8E4CUxKj1D1U2kvTIxUIdmT9akBHsRItUtCC+0FrBRa+MUmcFRxKIkFL8eX8T9LhyaCxZDGD9Pg9us7WHqEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 14:15, Maxime Ripard wrote:
> The CMA dma-buf heap uses the dev_get_cma_area() function to retrieve
> the default contiguous area.
> 
> Now that this function is no longer inlined, and since we want to turn
> the CMA heap into a module, let's export it.
> 
> Signed-off-by: Maxime Ripard <mripard@kernel.org>
> ---
>  kernel/dma/contiguous.c | 1 +

The prefix of the patch should likely not be "mm: cma: " :)

-- 
Cheers,

David

