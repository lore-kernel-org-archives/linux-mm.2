Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B949108B8EE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B2D6B0088; Fri, 20 Mar 2026 07:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BC86B0089; Fri, 20 Mar 2026 07:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BA36B008A; Fri, 20 Mar 2026 07:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 801216B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:02:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4AC92135D5F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:02:25 +0000 (UTC)
X-FDA: 84566152650.22.8EB4469
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 70D8840018
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:02:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MCH5HHFr;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774004543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mRbU5D9sCt/Q3Wq0ahJl/cSS8u5A6Q8bPsIRrDxeI0=;
	b=TGY+vWt8jlcvNFpejeXGZBakSa52iqmewBSmROs/yLUiJJ5Cm2L31V439t5GXnvj1rRTS7
	RAmR9QUfilUwqiOZ5kQUmMRovL1oMjU3N5j5izF27PS+9Lo77rLVatYj9xZkeTzZ+nG1ZU
	TLXgtkJP+xf7g9dZMr8rbmq1bW4i5hg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MCH5HHFr;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774004543; a=rsa-sha256;
	cv=none;
	b=itPWROREG7rZ9m94QA8X5Z0OJezXDCmd+Eu584J9zWYq+2aGZWzPihOuVfEmkwwfSdA/1U
	o2YIKG96PNiQtRA/z467z5Tg8WodMCpP3LiJkV7KUjG6jMW2BcuMFVtIpLIPBSt5hIbNlS
	0KfNfbw6Ao04Y+0Lm/1SXu5fMH3OR4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88F7043D69;
	Fri, 20 Mar 2026 11:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDA2C4CEF7;
	Fri, 20 Mar 2026 11:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774004542;
	bh=XpLec52ItJ0+gRJkeZWPIY35ZXQoan83ep8refy/6XA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MCH5HHFreYLZP9q/UZVa+yTPwO7SCnwKkdPvCoPvQthhg2jXVgZm99SlpcROp4nb7
	 V3LH271yUrM/+rY8B8rPYiPh2s6QKsrDno0p3T10pOBXKh6AAzxu7WT9c6fzDWSkDI
	 r0KLHjCpmcEA+wSyB72VBmSw9lZnxDcf0imNLM9+Bi0PxRvPn7EhiQ4B3LZmtIbDlr
	 LCRmsS+01mhNTuSMC1OMd0ICBwLfcXgiVnKvdzhftF50nZXzmFS/GigNkGyl01J98u
	 qTWV9XZKbPRlb2wfPDXVXMPo4YD1SZNgfCkrGW2sL14eIHqyKytstAIEXlIdBuFXqV
	 6WZyEfK1p4MpQ==
Message-ID: <076b36f7-1ed3-49ce-a892-eefd189870df@kernel.org>
Date: Fri, 20 Mar 2026 12:02:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
To: Pedro Falcato <pfalcato@suse.de>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
 <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
 <tv6pcikk456ynfx7lz3lrql3yafg4njuy3bzi4v6yi5hpe27gi@hakvdy2jmewu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tv6pcikk456ynfx7lz3lrql3yafg4njuy3bzi4v6yi5hpe27gi@hakvdy2jmewu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 70D8840018
X-Stat-Signature: jai7e7atca3mbx3rh6u35oms1x6e14oz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774004543-906337
X-HE-Meta: U2FsdGVkX1/EPeuf0YvIKmsmltByPMout+eznMHODTAVupyTP/kZlOoPH6XZfOAeF8H/bifxdut86wLdiyQEjM0SWB8bpIVTQFECYIf4t1EZCRe3FCr1OKElYdxeOb8cjAvqM5DFv23Ul93m8fjTYBoHOxpPeSMkaybzI2s0tc3Yhq7Sskxh5ojxKkd51wuSeKOo2m3gIT895K+uR9PctklrwOuvQTulhhQzK3Ny08lmaR/c5oZ7nawRAWlc9jh6UZjSIr0lblD1u5QAaGI/6ncpIDCtiymrlbgfiyjGONJhqVGxfEpABNo8JZgl/E9KU2tP/EAPyDjMprsJnVrJRhpyU5HLODAMxfnEsjVUmXXcweBk0LuMUyyXHA9ZHZ5xueE9n9RvyWMcJ1DkBrXzwA0jHAStySugxpd3bn0SOvEPrjyP/G3aXBICYmheN0H3mqQ8mnTuw0+MpSHyUE8bKBZ6m7lKQrjKcRGgCoadJwp/rjN8tVntaQYFzFy19fthJlT4R3z75Dw4VpsKbbDbf631M8DWBswJuwN3taNbDZotQe7/V5L7a6dWFGl5/X1c255qeIaNeUcgGOoU6I9R9ZtbrYgKKpuCQX5TGuUmmQJwlIz11Pd+r27QWAiJSbbYLoVtTza9+yqlHho5ek0DtAhP84ABKnikB/5y8YZUqKdYVQIu76WLEwyVLQ2Cxaf3P2n3ZMiH7WudqMx5kAcuZb3MosMSn7HOu7QAQL+iZSeXj8eLnMSIL7lSzAIKD2/10LjIHcS0ORWAuJeuv8LwieY/wyfQKr17lm6NvRqUdxYZ0MpJawVH/XxqZtQhiFTDA589B7PlBBulRzBuU9d6oX5l+q02Rb2b4irwzPfPFHb+vxxuYHr97XHEI+R8BKbsjocmG51II7A9mtL11GN1t3GnkUHIOM84MlhkNE8fnMAi+JQ48jU6lt18oBGkJxmkfNrSN5UUVZwVbab+VGA
 4jl/XlAU
 3o480Q/xBPoFOPNhR45r2AillKvjbts+41sp+sjpVcV+sOQlLoJUsDW79o+55HtqJbkIiSsUMqOtmrHn5Sx2R/cMJQNzVd4Bi3JupvMTGFJTB93FMC/2Kg5oZTqeqUbtYVwkEpT0RbF2TdYoFJ1vfLiAAMBgltcBDMaVOJnekqUPiDcfM1YI1Up3+WgMvQOGlxfeKv+VEUT31o0r+WR7S6TMBG4D4diSjOYJX6+9GHJR2/GEqpWjg2AY4L3/H1wDRtoQRXlzLa3ePcwyl0FBORX9EGv9FKIavclhGE9BYQD30UwXjvi1iqXFxeINZ3glBtPIGZJaLtyAbsv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> which the compiler FWIW tries to inline it all into one function, but then
> does a poor job at figuring things out. And the CPU gets confused too. It
> was frankly shocking how much performance I could squeeze out of a
> 
> if (nr_ptes == 1) {
> 	/* don't bother with the loops and the funny logic */
> }

Yes, same experience with fork/munmap.

-- 
Cheers,

David

