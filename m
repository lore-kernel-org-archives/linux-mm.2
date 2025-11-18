Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCD1CEE350
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 20:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DF46B0062; Tue, 18 Nov 2025 15:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446136B007B; Tue, 18 Nov 2025 15:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C4C6B0089; Tue, 18 Nov 2025 15:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23E8F6B0062
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:18:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEA2D1601E8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:18:33 +0000 (UTC)
X-FDA: 84124840506.16.A4C77AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 566A6A0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:18:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CzkuG0mN;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763497112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLmsq2NfaIKl1VBZU65/oJ5aA4deK7TKcI+7lhULTzg=;
	b=P01dAaS5SZ0Nps7uYqCNFucqx1tO4NQs4qL42TDkdZZh5EpXLSGUDFQK48gJELURP+vhYb
	YcQF1LbcSIzPN1qfeE51qGJzvv4AJ8jPqJrsT9WXKNseGwUpfbQs+8HSoGR2W1WaB8tqJA
	qO2WQPhTc6Vom7leTiDZ4pwwFdG+Tas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763497112; a=rsa-sha256;
	cv=none;
	b=dxxpy8Yfr1iHK+WHg6MexKx7w47U4mMlHqbWGS/PyJm1MMQfTzcf9QLaB+zgk79Wz89jIY
	1VBZVKLPqNjSio5YZI9vT8yfiZc/xPhAz/Ulk1AF0ZFBWPbnQbNy2Pc1T9R8ps8h74tC39
	YKAdd254MssCKm/mPtGYo8iHCoEb7RE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CzkuG0mN;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92589601B9;
	Tue, 18 Nov 2025 20:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39B5C2BC87;
	Tue, 18 Nov 2025 20:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763497111;
	bh=KdE+M0lVIS0HGmtD8Ko2F3jFdIzWzLb9S0ujof4OTvs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CzkuG0mNeQpbD3Hy+tj4eX/rn/+E3hFsBaVnbuNLfyC/t2+TLwKI8d549T7QP8eW8
	 sQisDVOZD0G/5KwwegU4hVX5/hojgUlgx3ADXDvOu07qrfjr2KHDTZ0gFdWN8ssswZ
	 7ETlZ7miEGm+0CO0XPnoARSKuW6XAKd4KL1K8g8jDQbVaFvTIC+vFyIo2f75DpI24l
	 qeR6dM0weLyxEj3kGSYAmHUkmoFYHnYo+ecYAeor+kZbc2wfhJLOlVOSyRxP7mwcou
	 +y47JzdCggFaeknWxJA3dsNmvBpaw5REHP4Fm0FuBfRI4Rxskb7TP1LsTX07tEPXGa
	 BgHC+IGmVtNAw==
Message-ID: <249625c7-eb2a-41f0-94cd-4551e5a38f73@kernel.org>
Date: Tue, 18 Nov 2025 21:18:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251114012228.2634882-1-balbirs@nvidia.com>
 <5b481d76-638d-46d4-ad98-5508fc8b715e@kernel.org>
 <4daec24f-c97e-4c26-819b-e7762b301036@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4daec24f-c97e-4c26-819b-e7762b301036@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 566A6A0003
X-Stat-Signature: 7te1ige3bmk87azw6hifhwg1iam95rxe
X-Rspam-User: 
X-HE-Tag: 1763497112-319510
X-HE-Meta: U2FsdGVkX19ahgVvwe5AHCLPdHNZzGY/3h0oDL34OheyJMXP7wVwzk86OV+dCMDtqmHzQ6pZS6rSQQZHh67wqkJHzkWoSPng8AhB83oZA8yZeFwUOxADfPJngjb6XohbCPDGjxfsx7ApREiPPjbc2VLWuEKklrVLAGQcZxAcQJ+50vAUaBKHXR9eZfkuuOCzjLsKnKVsDT9Ud9yWSQXp2JD/sMuNx03z3n8vJepaUgUs/nrnNp5vAzDBq4A19gu444ichLXpO9NHMJQdYOC+RoRBrzj2bVxERvDOzuUOZz+j+kOGPiJXtHWoZWs65n518HT6fXYLXadGRdX/mBmBDZitt0XTMXJ803mCLW+R6ZbY34VYdz9SWfkg6KOu7TZmlRG1peAwm2OCrzQkozqgHR1q16zbbYMV6x8XslWlQPzQ/uqDwiBfPuURea16gZ18LeRxVJ65vdONGjkM6fzbBf1GrHeE/wgy1aq6MFmJsbUD4PPzTJEQsAFJcCaD3pNMr+8cut2U/BtmAQtwOQEfBAc9LqCyEh6j7qhQQ43ddhsnqvTSIrYN1ZJ2f5VCOPSebVKS/DH/MsEqVfow7o5sAx5DPnkQNlD5JXDkT7v52URiwevGy8IzLoZNdbafjlyOenDG4viKcFvMHKwceKqY6uusrrP4puQ2iTYH55Tsv+FYpYWkilCpsTbWKCKcyDLfRpIoPZey8PnMNtTGNbsla6WxNyZnyikpP1AvWLG94g4afF7d/d6p3SEl+k9gRV55NbPaUR4/zGht3mJzJgzJbEyCPxUcxZsPnWMJxhJ0+p0Jhe8ZdvlqNbRK0Wo7bRPyFEA5I/5XPdClI+WM+qkM5lZOtpRIlTqBFc+Z2rwLDu4UobnjLHtGiQNcz2dIjJ8LUxq9snM/2p6N0sLSyw1QylqrcEY9D3k7HVoYeICKhKBJC7STmdg5TkpzVu9V2jlSGg7iGKVs1/JZJbxlZRc
 53JSFGOj
 zpU7LbeXfdhGE9DEGW7xjQyK2gYfexo92MzuADtJkdnhknXSQIPMX66YNQBqXp1Wna6bd1ILCEuN8B4BJl16SfUqp/WHBDZKKs44AIDWWSEi5pjoswtVK44feldPh3/Koel965Tc+Z4bOXEn2KV+2ar6nqm7AUPCIYixZUt8pPbJc88jnXt2Plpv9dWBfywCaHQtZ73RJogNLqI4kyjDkmrkPi8Ke3HmhkfPu/iuBhfGbQ0DGLCguDlWFOA33lD3eW/hxsn6Bc2yoVq2K02emW8PbhiV/2tN4ePNK15gzGte8CweIJDGh3/wml+tdO1jT8pUv3nz1aeOw6Z7Qg6nOqjMA7dRh8xQVC8tYFVD5pceP4VVA3oY01Jyi0mAb69oGmp1vel/0eo0fyo01ORzHdRggMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 10:10, Balbir Singh wrote:
> On 11/14/25 19:36, David Hildenbrand (Red Hat) wrote:
>> On 14.11.25 02:22, Balbir Singh wrote:
>>> Unmapped was added as a parameter to __folio_split() and related
>>> call sites to support splitting of folios already in the midst
>>> of a migration. This special case arose for device private folio
>>> migration since during migration there could be a disconnect between
>>> source and destination on the folio size.
>>
>> Didn't I already comment that the subject should start with "mm/huge_memory: introduce ..." ?
>>
> 
> Yeah.. the .c in the prefix is not desirable, I missed that in the subject line
> 
>> Yes I did: https://lore.kernel.org/all/048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org/
>>
>> You know, I'm a busy man, can you *please*
>>
>> * take better care of addressing all previous comments?
>> * wait more than 12 h after asking a question before you resend?
>>
> 
> I think addressed most of it, I missed the subject line, but in general addressed
> 
> 1. Using folio_split_ as the prefix to split functions, the main function is called folio_split_unmapped and the helper name was suggested by Zi to be __folio_freeze_and_split_unmapped() and it sounded better than what I had __folio_split_unmapped() or even __folio_split_freeze_unmapped()
> 2. Got rid of _to_order() as the function suffix
> 
> Do you have any more outstanding comments that I missed?

I'll take a look at v2 now given that I was distracted for 2 days :(

-- 
Cheers

David

