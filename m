Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD50C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0156B00D5; Mon,  6 Jul 2026 04:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7E86B00DA; Mon,  6 Jul 2026 04:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD796B00DB; Mon,  6 Jul 2026 04:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5D066B00D5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:37:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DE14C1B3D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:37:37 +0000 (UTC)
X-FDA: 84957698154.15.BC4039A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8D95AC0004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:37:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7oHsUXz;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327055;
	b=FaHTGGo8T0wsBf/lRXj24T8S/OffKpKuyfKQ1KfTmjengAphY21McJzXry1g1U+ds9nCtd
	Fe+71iadf4WVPps2DB9c0FGcW5g4ieuWo61wmpHKZyPRgpSpzohaF+TzUAr/uOrGJg+r4G
	clIY8+T9AW6yN9cqBlTE5g+mpKYg5q0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7oHsUXz;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMcL1MBdVCvnx8Hy+bCvCz7qDrwotWXEZCOsItQUjCY=;
	b=D1tySLjAS1V7ERmJSynR/eGOq4X8LapPjVOgnD/wKyumySLc58DFCK1vQJqKW+dsfwsTd6
	BIHWUOUaCdnLMTrw9baZ87eGLVRitx1gXL203Q4ZJl11rBKjFkq9d7RQpoKEpsUNNyCCws
	pu9WOp5c4+V5Mm2ez1PfOBpKnLjaZD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC089418A0;
	Mon,  6 Jul 2026 08:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF02B1F000E9;
	Mon,  6 Jul 2026 08:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327054;
	bh=AMcL1MBdVCvnx8Hy+bCvCz7qDrwotWXEZCOsItQUjCY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V7oHsUXz6pTL/1uRlbjM1Tucw+X3ZMItcqFjPAprrw3l+fWPIv85z1yCWGv/NYAkC
	 vHzlkqDcVCE6nkF5ivrb1Lzw30wNOkaF/PRUoKl7yACqxZBgc+SRefigFORNf/ZcZX
	 y+E0Fwi0w4FeWbW/2T2MVWOZQAT2VBV4X77l6KZ1nCqPmY4wodnsn0Mr3UFLLPD0LW
	 K8HgPTfNESZwta3mCtt2l4axckC0osYElf1u0s/BIaKKkPeTkMDs+0RL7TcNz9uYEQ
	 B12BKfZykfuoFHCzNpO4++kw9g+HvHrW87s98SDLN2qaq72ymQpCA2dh7OJa2RUdGC
	 72DZ0tx95bDiA==
Message-ID: <1bd9a8c7-aa7e-4784-99f9-ba2c5cdc3a68@kernel.org>
Date: Mon, 6 Jul 2026 10:37:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/percpu-km: clear page->private before free them
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-1-2970fe777dd6@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-1-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8D95AC0004
X-Stat-Signature: 4hczeiw6eq34481bxugct93zxpi5hss6
X-HE-Tag: 1783327055-696968
X-HE-Meta: U2FsdGVkX18k4HlGi/GrckPHdRWiekcNEUwmvw72a/f3ooFnMLAkJbWSf1eB9ILBEPElRtLVBkqPrdda+If2mNfwTeNKQI7hrJ1pmocmfP5J+lwHdI4EKVZSj/bSdayYkhvsjJ7szuG8JyI64TTFk0FOa+YwJySQJGGMo/w7amkX9JCma7Rb4rzahLNXETs/t/vQp67HgpWZKxrVQqQN2y1Np3CclRwdkP6zO9bpn6OoNLEEPO3lT7E9uk6tkeHVToDkWgHfHZ6odDobTm04EXsEYc8actvpm0zXB3Dud+JmrIn0H4PKEp1ma0+RROOUjZ+mamqKFex3msbUiZtvvufFo6HTUIWQQDRx0eZlx/1ZUqprDhy0sx4FVroTKDyE1paL6+K3MWM7SwD4Z92vVSfcH+e1C8X16Cq86dfZxQlc8aWOi/yyXam5XyDVEnRSrOAiVYZzylH/iKQw0HvfVVANKlQbjPUc69ZEDl39VpAQACFW6nnsud3WpLOCFg1OPVLlnwpsZJBSLNf06fmb9uz5eEjiLTYF8PBaPx5NkLIL2IICGg07UmjUazeaMmmX7b9yjSqSIZN+H6nsLuvHXORgM9jF7kmsNR03VuwtAXO9Bz2TOw5LlA+wfdY9L12BCeq+0+HoAurhSpTkw+YX3pBkAfibpCts7pGnvkeaR9MJC0I86J5tf7XnhOZOBDUvOq+tqS2NFDedkzZmUUh0pyMyqKVDvNccXuKo2CJVlFOYFIijf24CFwqFvJ63j5psZ2QiivYm7h0sEtqQ3klUCvPqq3tHHPJ1XBLSzgbEsCp/SD9i6VMxUNrFn3xT1/blf5HTtmCvGjioF7VQ1hoIFmWVAQ1G6S8y0b8k+z9KlDUNY7//BWgD7g+a3bpG8UFU7Z83YNf6oyg88t25YdcF9R9fxoYOWvHtfHiY0eS2MtkrUoNMm+obBAINAlXi3lJsgHnYmZcT9XNFkIboYPN
 zwSzl7qT
 ZR7bKrmbYTcwA+dALKF9yNMuwniOOpEhHnX9fsOCLZYkDXkELSqIWvzpALxRKrWL6eVjU8Im7M+9fQscmkVvG75mz+bStbr1C2f+K80YolgVcFRQI1InEMlOc/VYbehQbnBPKgAtH6AaIKizuU9cS170RyyUk8/aROH+qUFrlKdcZEDw7+73KLW0i8JtazJ6ViMeNVnvyU2B6HPgjzqJU3qlu8Utv1fFEliuILdKP0wXjWH48OfXX0aLDl50xUcqSyGsoNP/gA5Xsy65QHEx7lhWa8OkBineSM2R+IzJyYI2d4ILdcx6neUGtRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 15:47, Zi Yan wrote:
> page->private is cleared in free page path. In a subsequent commit,
> tail_page->private will be checked and ensured to be zero. Clearing
> percpu-km allocated pages' ->private to prevent triggering warnings later.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/percpu-km.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/percpu-km.c b/mm/percpu-km.c
> index 4efa74a495cb6..7ffe84adadb9d 100644
> --- a/mm/percpu-km.c
> +++ b/mm/percpu-km.c
> @@ -94,8 +94,15 @@ static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
>  	pcpu_stats_chunk_dealloc();
>  	trace_percpu_destroy_chunk(chunk->base_addr);
>  
> -	if (chunk->data)
> +	if (chunk->data) {
> +		struct page *pages = (struct page *)chunk->data;
> +		int i;
> +
> +		/* clear chunk info from each page before free them */
> +		for (i = 0; i < nr_pages; i++)
> +			pcpu_set_page_chunk(pages + i, NULL);
>  		__free_pages(chunk->data, order_base_2(nr_pages));
> +	}
>  	pcpu_free_chunk(chunk);
>  }
>  
> 

Un-doing what we did in pcpu_create_chunk.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

