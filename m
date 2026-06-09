Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D556CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BD846B0088; Tue,  9 Jun 2026 11:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E456B008A; Tue,  9 Jun 2026 11:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D9F6B0093; Tue,  9 Jun 2026 11:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC28C6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:50:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B6121205CF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:50:10 +0000 (UTC)
X-FDA: 84860810580.13.04D805A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 59B7B2000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:50:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASvn7p88;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781020208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6ca8f6AenMP5/UR7PWnMaRzDw2gdfs9meohUMPYEus=;
	b=JgrwgPnbQrabzfQtQw9ifZBbusqdNT0AS35MbWqyAmfb92+Af+Tnt/gFh03SxdYPjOHiV0
	G1NMaHteecl73WYl9DMhRdhncZLQmMNRCcaY1tisYipAL7QALJF/C2ZltgvXeimLtRAtEr
	mn9cC6TRv2Ic/0TjN2CH71n06XB6I4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781020208;
	b=LIahtQS8VDFebs4sJG1fZdPLLR+KO04NKowBmTAOOOTIadVoWGvxyxKQLz1DMckCI7dpPq
	VbPwp0TsUvrzyR0GUbUCdo5T3Olk0wgbmeXoY0cy0RDQLAVD4m4T7AmakEpNQKsejFibCR
	FQwQMrobODoJ359hoU9bDSCWkCrsDOE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASvn7p88;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C714760200;
	Tue,  9 Jun 2026 15:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A383F1F00893;
	Tue,  9 Jun 2026 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781020207;
	bh=+6ca8f6AenMP5/UR7PWnMaRzDw2gdfs9meohUMPYEus=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ASvn7p88F0WRoejGuta8L9QUPPOQOzGZ2NwmMoYFmN85JAekN35RbRvgdEyuSszvN
	 JzopCrfKdRaraz3L2scLYsMAC0mBiAZMroj97fwml39BA1teMO4yom+XzLDV2tk8FS
	 9Mgps9oUyBwQRZCJtBrBBhl9iHy5PvYMkCwugppYf8PZwKshqmvoVCe/tCxBJPfXvN
	 Pj5Qb5ZymYbQNTFcrl4kK7PHx2XaBtlAIgbPWHR3aFs99UaH4hh8dRJ5mchepwX0gF
	 py0RMYFZTWox9FT1+d9hybA1vBg5p4EyT404g5c8jfXSGT7pyCVlZIjT9klWIRc+Ct
	 nZodw50PYqRUg==
Message-ID: <afbbba31-71df-4dc5-a1db-1e6d2b8a541c@kernel.org>
Date: Tue, 9 Jun 2026 17:49:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
To: Suren Baghdasaryan <surenb@google.com>, wangtao <tao.wangtao@honor.com>
Cc: Barry Song <21cnbao@gmail.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "willy@infradead.org" <willy@infradead.org>, "sj@kernel.org"
 <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
 "luizcap@redhat.com" <luizcap@redhat.com>,
 "zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
 "kas@kernel.org" <kas@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>,
 "jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
 "harry@kernel.org" <harry@kernel.org>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>,
 "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com"
 <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>,
 "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
 <CAGsJ_4zg8+pVDwtsJtxxiC1ahJ9MR56Ue8VXCt_VrQgcXES2uQ@mail.gmail.com>
 <273d02a1af954b8c9f4da7fb74e6b4cb@honor.com>
 <CAGsJ_4xTMsV8fJVfhshDQp4=Ax2f_+b6yR873cEP11bjcEa_5Q@mail.gmail.com>
 <3031859912bb43a7ab16ec63863914ab@honor.com>
 <CAJuCfpG6-PkWpRqr7m5evzTy9s8LyV3nW3TScOyjqWb+maVBkA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpG6-PkWpRqr7m5evzTy9s8LyV3nW3TScOyjqWb+maVBkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59B7B2000F
X-Stat-Signature: fri9dqfsaia6utyb88ttkh5b55sm8fdf
X-HE-Tag: 1781020208-82961
X-HE-Meta: U2FsdGVkX1+w8WoJcEvO+Fp54cvigHJIOtca3CExf1dqy3vvPa0On1ln4RneqqmukVs1SEu6J3c4KLhMUC95LlhO+QwNxtpMDxQMGbQw69tm8GTrWoxzYSkdNT8CQm+/OMiDFI/r6GTNAwgyLPUSJ2IARsfAp/96uovXZ7goh2sEvVirTLgZ3cluVTjEAHHIjup51ePeV95/q8T9tR//KJh2fLDAIEBdQ1FEaxz0Essfo+DZAiTnBgZ6Ak5H2ZzyFRDS3fUrJbyn3pYT/jZXArtaQ5Mda2Xz9axjAdFqb+At8CHGtYfpU9AjSd1GBGyiVSXZllVx1vCi+9pgUgVMYnmthweWL8ASmjQZ/8COQx+ToH7mB2uz1aUP94NYAA5tmGaGKEWLeTzaWEmB3ykaSUAq8Jmj8dTViHm8f39Z69fSe4mn8et58IiFAsHcD4r6NQkW52/bzOi26o69mdQV929bF8ftBQQJ1F+UsFoxisEbNJ+CK/n1PnOFO1hXxokYzAOlysIISWe0z8O9k/B3ApLAvbcFq7AtenkRwYCO07ctyUx7e1zfadwsSqJ9hSzG899m3fWgxyTk6yr5eGrmR8jBJ0vf+BpqUyTGwRFE0HhDZ7U3CXdONtXQWNzGFlVUGii3GE5vzAIFbvqpiU7wZlr/4v9A2FZgyiAu+6IfMhxZiALoqioNqeWm1su+FSfr/P+Z/l11uiO0CB2So7H3ThiDJgvtTbhPE1vLWtmaevufSNene1M6BRMaU5CW7h0rkdcCT2hkXRGCuIG8/HqepvkerXQ3N/vAHM/hUrFcLEG1hCX37YKx3sB/1zktqJzvsEDLkjDQD69aU7vjSHlxntm1YCT3nFTnqXixId93nUqJRqLt8/NlohHUkr99vSOv6BIVKdpehaZJy0eUlaiS1RknfklWP7UlY2/HvVkXlOOsDdxsXTH3brfDpCPEcEhr+tggK5gECtS/csfwmj+
 yVC38NGV
 RsdrPhfJZT9zhxssMsk0EIunFfExO2LODLpkjMBnJTsAYY7S6dRk9fk0TUUzCggVxurhrDPHs8HPeXAOIfSSCro37Q5V1zJ1Z7sf8bhpE+R8hlVxjIutb//saPksKDZUvskOu4RFMGK8F6EenGZwMOzY+VuLwChojfrDrJCsoIHovdFqGuHypy+eTVlCTaacivb2N/JmKGI0xmCMA2D4iVargUBPrB8LNdpSxGUNYYw5Wd2SzoQBo1YouZZwr8eXVr4+tUjk/fleR9AT2AwEapn3CRcc05fnWTuZPuNrM5UbY6xVbSmgmBS8ABGijoGbelbqOKRbiAIsW2hVh3nOVcotUr+pv9WYsLaVwqmrvYClzLpO/Gwmtt9kOJM2rG2McqxEYp+ZwRzR2VHHixdjlKYmhX8JOejyieZovEZ3tfplQDSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On a separate note, it's very encouraging to see more Android partners
> becoming active upstream.

Oh, absolutely, well said Suren!

> For years partners developed optimizations
> in isolation without engaging with the community or sharing their
> ideas. This is a very positive development which I believe will
> benefit both the community and the engaging partners. From my own
> experience, learning to collaborate upstream takes time, but once it's
> done the experience is very rewarding and oftentimes even the biggest
> critics turn into supporters. The key is to listen to the feedback,
> ignore harsh words and realize that people here ultimately have the
> same goals. So, don't be discouraged by this experience. I think the
> biggest mistake here was the lack of prior discussions or RFCs for
> such a big and invasive change.

Agreed with all. If there is some question regarding how to best contribute
upstream (with code or review ;) ) people can always feel free to reach out to
me, and I am sure, to pretty much anybody else that is an active MM contributor!

-- 
Cheers,

David

