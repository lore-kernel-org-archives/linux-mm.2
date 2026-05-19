Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2441CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 23:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC22D6B0005; Tue, 19 May 2026 19:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23F36B0088; Tue, 19 May 2026 19:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDFB6B008A; Tue, 19 May 2026 19:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6A646B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:39:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D728120CA6
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:39:44 +0000 (UTC)
X-FDA: 84785789088.05.6A78163
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 73553C0008
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:39:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9tundKL;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779233982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+hzOVex1jUoqLwARlZfBASNO++sjiPZWujjsCNbAmU=;
	b=D8aQvM+DKW4ZtJjFI76hT/NTdcSpRVTEeBloMdqsVQR7k6nKL6KrKG9OnQ+PctVa7IAx5k
	rZt7B+E5HfWziXMu7NZkR0mL/5ktk7eMTkSk4vMdtt/RlPrh8Mqbav7NKaatLNW3lJpvOi
	K13PGFSOEfwpaFdqq0ZyqghpMdJuJwc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9tundKL;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779233982; a=rsa-sha256;
	cv=none;
	b=VEXBd9c/HYPjgDOMP+tLxocaNagSa1UBdtsaY1qLsxwaFaRzONTJK6GMr+2THoPyW6lRKA
	8fWjomA2gU38r86UOsjsfiHn1k9ZwMOnqrdQvfTOP/dnxySHs+f9ssrK1u3Z+Fjezbs8qg
	tcYMh8y6lvZ5inVQp+GQfM5svPQDH9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA14A60216;
	Tue, 19 May 2026 23:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF82E1F000E9;
	Tue, 19 May 2026 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779233981;
	bh=r+hzOVex1jUoqLwARlZfBASNO++sjiPZWujjsCNbAmU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y9tundKLUw86gpRjIBHp1wp1J2W9uDzKuOrkdcHVp2AznvGUbD7MDggJA1MoxmdYz
	 Rhx7MYZnokxMeigJ8L6oAbCqr0j1NwqRDAjpxz0pm9u1zFJL92jdQGu23TB7WuhhP+
	 JpeP5ntASjuJUSpQ8C6Dd2GW+ndAfWC1qHwUtPhG4hUfcF7LQEsUYzLCXs4W7AQO+1
	 VUJOxYgnyYUmgxPtDVcUJ785BW9w+0MMNdfPRcTFEgES2EjGW6dU1QtbdKKaZafU2B
	 zODBSgY60ipNCcgugEtb04WZtWZq6HBBc10ce22GX0R0JJWo5g+XEFDxoo4kQ6aPde
	 MZaBwMyy/FgCg==
Message-ID: <1ca41e22-aff1-4068-b080-067885b44f69@kernel.org>
Date: Wed, 20 May 2026 08:39:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
 <4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
 <agxszIIN6FtK0fEb@linux.dev>
 <ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
 <agynzVVBb4CYJTYG@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <agynzVVBb4CYJTYG@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 73553C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: 47ey3ae59i8ctgdosaa46cmtnqusaf3p
X-HE-Tag: 1779233982-780366
X-HE-Meta: U2FsdGVkX19fDVUVckonxqpdf0AIw/47h46ezezg/2Fxy62esAYq2h/40FBSsU2eEx1tElAyG4PLE9fZwAOgdrjN8Xv5urM+xL6Vuri8ZXoZJKz14iDiWuc2q528XeyCIkcottJXa9OrbbMk/EMjGaX0dRSf19DIk6WT9TGH7DkeHBRLEklco1bMkHkOkRTbzM13s7kZIy6pHjhg6vBJXb3zfDZonfQD8fSmTrmvWkDTEtkho7EY9ZY8sBMTMn8Ils8Mh62ZnFWdT1wndAAOQGLtD/Df9/+qHsDxkbk+8rMlF/9s8E8kG5N995wuGa/phv0v8pHPty166roaF1Nsl9AmT6ZHEzFp37uHQgfh5jaMiQhrW42FvHS6FGqdYesWRRRJbBKK+NKRp8cMLmTmjvH19ec1m7hjLfJQg2qjlM5VYlUi05rsCM1F5dE7Hnc7LOXrn/dLxYECoSP2Nf+JA2GgeZZtUpzpsCHtxmG19VZFyPI5TifgjaG+H4I6LdVq9UhKJTjLMrjkVdv+0exZ7dASA9Sxq1apLqfnHO10L2LKE5cx2qq9Q+GPDtJnbqoDBNaRpeGUmNqkBKf5FKVldqY2U7bh68mJj5kGL53EpUpVXsquFFrskWgJDv4wY0wo1rfs+PE26Bui+gQjnN37wuKQBBq02d4DZX/CNDAgCrW1vej1tjU9+2ybsm2VyURjpm3MfHSVHfwmYxxcAh5pRSkfOMFEOtYaGSa/IqBbVNK9RePXaBFQyqS9xLiDigbMIAlDMykzqNqu/bg2v9s3jyYyhW6uL1I+8Gea/qVklI6ceOtpWlIPHP2C2S4Q5zLj3yMiBzqFhhYllRR+cWLXnwCWWMY8i92eZoW71Whi/qV6THL8rl2sYgT/p7TKN2/VBnEGLvKrUmdk/H4IwZwmBA6MZ5bW5S8VK+jOfZC7utZuVhUvWZwyRcBcaFf5B1w5HTBpDH9TI38h6+51pur
 lCei6vqf
 UeqSi4uOf0DeLRb4Wu0VDg3X6I7C8EeNDTWLJOUAukzBJ1bHA9YnzmS7W9lQZvDmxj9QU6yDdwiEolHWc62tD1pKu1wWXbS1/PmfPqwDTQUoVWzfULjIjWpCFxxL28mLwNuahYcVBWdMyXSoRx6AocjFOs12OD+CbyUCJa+5wWWqA6nqbAJQwnJqZ0UclfiD/svFz+7GS62JUp62RNUfT5hoaAEQRgrbS/xSSt424Q+PKtW/3BV0WMAVERVerGKZpDFpMBxL7S9uxeoDzRNf1J8f+2AueQj6B9I6iAu1jjg+oulE+1MelF7DU+XmMmNeGerBU5mETd5rEn5Pqjq8IpGus922bRKExFq8I6cTqu+GENDZ7mydPVqu/adt3Ve195xBm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 5:11 AM, Shakeel Butt wrote:
> On Wed, May 20, 2026 at 12:00:16AM +0900, Harry Yoo wrote:
>>
>>
> [...]
>>>
>>> The full clean solution might take one more cycle and I think we can not just
>>> ignore 67% regression on 7.1.
>>
>> That is valid point, unfortunately.
>>
>> One more thing I have to ask... for v7.1, wouldn't it be a safer option to
>> revert the per-node object change and re-introduce it once we have a cleaner
>> solution?
> 
> The issue with that revert is that we reintroduce all node lru locking in the
> objcg reparenting path.

I'm not sure the problems with all-node locking are serious enough to 
rule it out as an option for 7.1.

It is not ideal, but given that the critical section for reparenting is 
independent of folio count, would this actually be a significant problem 
in practice? (even large servers rarely go beyond 8 NUMA nodes...)

>> This change was introduced in v5, but the implementation before v4 had been
>> exposed in -next for a while, and I think we don't have enough justification
>> to keep the per-node objcgs change, at least for v7.1, given that we have an
>> unexpected last-minute regression and
>> correctness concerns (albeit slight).
> 
> I am waiting for Oliver to test the multi-objcg patch I sent. If that also
> resolves the regression then we have one more option i.e. backport that to 7.1
> to fix the regression.

Yeah, If per-node objcg is required in future kernels anyway, this 
option would be more ideal (if available).

> So to summarize, for future kernels we will be having multi-objcg in some form.
> For 7.1, we have to decide between (1) do nothing (2) this patch or (3) backport
> the multi-objcg path to 7.1.

Ack.

Thanks!

-- 
Cheers,
Harry / Hyeonggon


