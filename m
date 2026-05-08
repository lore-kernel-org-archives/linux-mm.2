Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B909CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28356B0130; Fri,  8 May 2026 05:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF8E6B0132; Fri,  8 May 2026 05:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFE46B0133; Fri,  8 May 2026 05:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79C376B0130
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:38:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 366561C0657
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:38:06 +0000 (UTC)
X-FDA: 84743751372.17.312D263
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5B0A918000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:38:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ls5mt47E;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778233084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVmWtel1GE1iKvN2l02mYj1S7RzvwFm/grrXZu+UkrQ=;
	b=o9UqY7kCnGuafpyoXrehzX94D/Eqd/vkJXGp7466ig/jFs6N/BjEvuvamNu6Qhxk5Q2VEa
	Elk9fNLM7dZp3YyiNgZB68GhmxkBRryW4hIcDAQ5kfkApoqXz+tD71QhHbQjHBXz26HLyV
	pcUW7xvHjp8Opa//f9PQqYl1w2XmxB0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ls5mt47E;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778233084; a=rsa-sha256;
	cv=none;
	b=aeL6JUMZrOEaKoTk+UhbJB7jCgrVcPDIXelS1TGyMF7VMji4EoW5Tl2hk0FrFeag9jxv2a
	g7Ma3G66nDKwZAQysSsVCW/3+HhVmMZs6bvRdW8yuw38t2Bg4SRAhgpkmqasyF0rvrfHsM
	nVq7YykEYBEIZRVEtu1OnkRsjm280OU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E5D144234;
	Fri,  8 May 2026 09:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB1FC2BCB0;
	Fri,  8 May 2026 09:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778233083;
	bh=HfbiLgcGfquDjWk6zgYkK07QVIqSLIkOtjspYPhDwt4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ls5mt47E7yssxsKYJHNTLMd5oX69CZaOIIpWFxq9CF+nfHGsf4wWlwUVvJ4cNEnQG
	 NjsmEZfeQxQV9spOJPLTMMK4AwfC3GPaRoc+QlHMTFZkXw1yAxpnNmL1s+6iWStpI9
	 9vfZiT9CGf3oWTCT0asgow0UJ3XEVZxq6+R12BaPh/gX46Qn+MvLmCeOqOoGgUfwTV
	 lWSTfQcrQ/IwBz3YCNDzHl4NRLXQqU7H/OCJOD830IAuGqNSALGlUbzclfVyQht0px
	 GrhrfSislNrICkfEk4skd+VEl0FlbP9HiN0aevCsneKSay8R+4lxdIZpeAwCiD9FFg
	 3EjcRTKCbfi1g==
Message-ID: <2c5a3077-78e0-4f8f-9aa9-a5a561e12dcc@kernel.org>
Date: Fri, 8 May 2026 11:37:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mseal: use min/max in mseal_apply
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260503115915.18680-3-thorsten.blum@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260503115915.18680-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7j9m88dh5ano33qx6s6ct876j8hj45h3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B0A918000B
X-Rspam-User: 
X-HE-Tag: 1778233084-842277
X-HE-Meta: U2FsdGVkX1/UsTEe0L/DIyXQwgBEfUuxjS0aPtgfYlhjlEB/roaA2owFkcJus2PvsV+qGIfcfa5goPadcelFIsDiB4WFWd3vLLjIl8wGEDaOuw4C3H/2tDhC1V3Jh1hs8bUXb4L9S6GvL+47HQss9pCEXsAXW3c7IJpKRdq7pYeyum/q1il1iZqMrkc0K8QdVuEndPUC8BY1Q6Csd4igwtqiSS/WfI8vM0KcqDjUEjux8J4Myjznu9jSVE6x+/+SlwQ95tJsbbFqIe+lhS/rUymXXCFM05XcW0tgQWj7EgM7wWXoFa4DA2JzHMN+9rVJ058MnVesw/T20QrLIFcAN13kARYmUIfoZj55UE3LEpy3XhGlifChZnjK3Oevta3/jJZRtOxFGOlSrV9qKtPV/Al/3ToWzH92dhVCI+RZXXba6QnTEtfWhnZGK1f+qaZ7TeXgFSPgz110S9b+IEwu32u0ejHuvwzMQIgCcy0VWldqdcKK4O8gnxtKwVA0wbCuAmdBXBrPAdKKyFihTwOIvFa59/TCzzikuEmArM9alKVyvju28yqDxRZ1QHA/4pN5td5OgQNNlJ3LxJadXqkhMJq2MkQdSo/I+3PtKMN/NLDKDDCwvToKgmDX/Yk2znnef/7kVUVSf9+95zt3L4PAcfoD0V2YlOkS32BRFIdfbzyM3Y2tAITAPWtv8agzhkrKrhdFqQWtSjInI8tOPZuipMo+LX1MbzFRJ5G7Km0wyMVAkLYKLN8fGw6JHDrLTOEcDWGtq0CcjD1p2XpVbOz9tsGce4I5AQlQHQEyxXnEYB+Vp7ak/Sds6HDu05iyuUFeqQRVGuR8XYbyXiQ/C7g6TI0e7N39mrElDC8OPZdqHln2Qo8V/npilmuTkJWWX0dDASFLZclAduR2R8MumeijmByXGuszUrKH0CtlK/RDTki1785OqhXIo0TfwlW+taV5DCPtiK881hYSSp3qDmy
 eIzPq+r4
 x/YmGoXkW/kl/SSpTuoIspwxYt2LvQcdSD5b7xV7hhf/tkLkhNS71/wWdXyDke16nTOSeJycrBT89B3WShGgC40YqLYYBzQY7Vk0F7JFpNCAxzgLHICEXP8+elqKfCzrZKPvJ/4kNJ16aRkm+PWNqiofwTD3C5rdJefrl3I/ZVnU/3N5/EMEih+AnmCevvYRclcjeWST3TAGRm8GXwa7BCexEKSesEJX7eu7D0rv07BZEl0lnrwJghwFgy3J6Yw2e2OR92PaPeyiE5BUVwl1L/i1E5rUyavDohD80
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 13:59, Thorsten Blum wrote:
> Use the type-checked min()/max() macros instead of MIN()/MAX(), which
> are supposed to be used "for obvious constants only".
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

