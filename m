Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 826F4CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99678E0003; Tue, 16 Sep 2025 16:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C495A8E0001; Tue, 16 Sep 2025 16:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37FD8E0003; Tue, 16 Sep 2025 16:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDC78E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:20:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47DBF1DD9D1
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:20:10 +0000 (UTC)
X-FDA: 83896230180.13.3AC29A5
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3328C20008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:20:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="ETu/EElK";
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758054008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+HzBTD2N3JCRvAB6oxwbdGwQ+4oKdqc9xdspcyNKo4=;
	b=A27cf/l9sfHga9Um8eNRWQDLGnSnVhfuV8v1uI8aIa60n/mT5I9VXwm0vrA1xGvr0FaEuA
	KVBqFQj3mjdoHA3MIzVYUbWZNHyCdfxBHyRw+lDJMOwlvigOwTgGkhM8vrrT9xkRiLpowY
	TkoA+oiDaWsmPRUjoU8eUDx+qLWZGvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758054008; a=rsa-sha256;
	cv=none;
	b=kdq7THESg33mwT/hZQWcgx4kFLyDIse1gSHmB8zYdlPF5vELI6t6rWHUUmekNiNE/e8XYB
	Im5bazSScFAnNbEWrHIN8c41WcL3EJbSyjL2wpH0nm4xzn2MJFcJaTfJGMhM5XdX74tf0I
	IM1Vu8EBttAd4tb0MgvIzodfPqy2eUU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="ETu/EElK";
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45f2f7ae386so19695655e9.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758054006; x=1758658806; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N+HzBTD2N3JCRvAB6oxwbdGwQ+4oKdqc9xdspcyNKo4=;
        b=ETu/EElKw6o4l1xZvKJNFfcUf9wXp8/JlomlPFmvA7kMFrMa5JVv0fB0Yt/cTHP53I
         Qf+3BuvbFNrmWf0C9tftwYsx4jMughbkKdoNvPymH5eOChDm2zRBRbIGoFzLJswfo6iD
         RYK+qGl8cjn0rFLEuvfkFxXzphbJ/cH5acUIwzBod4qjQ1RMVAy2M/7EVMG/whW9vYMb
         AmW+27nClRK+cddihG3YR9aBnunGdGvakdoMjAayZhuWe6avTf0vJ92zBozAhxsm867L
         suEaTVzV5uAk7la2mb7ZPj3T316ivkz8JSDVrRKCT234uu5/4p8oYgmtPrfxY7m8lpmp
         NB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758054006; x=1758658806;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+HzBTD2N3JCRvAB6oxwbdGwQ+4oKdqc9xdspcyNKo4=;
        b=uxBw6qP82KbgqE1FXJP/WZZXaRKlW/t5NoDXJikBTkjJDCkDf7dN5RwgOE3fparwES
         gPwr3/Z1XiVFfSaCyu01DlDq7BUTbaFiSfrtosMPO+3Z4L4XqQXXekpEjEhFl5Q1eNV3
         BBXmhHI7KsycTNOcoJRuVZa6ZFtAsnk+8GXw2F8/okO/rfXvliTir4HvWoEb3wCYqqQj
         gjRfF0+n1IA8cD+BNBCuENCQaR7VynpYIN/aG17QpZjEoF/OVivNNPmmdBulGbEDLIg1
         WRxBzUMVhlMHtEDzOgEU/VU9qT1yuwGRvkC+h/Wcqg3ZGAaMcY85PJGO6j27cuVqJq/b
         aEew==
X-Forwarded-Encrypted: i=1; AJvYcCXYVl+9arUso8CiIgq638p73eFMMw4dQgspW3855E7GOTVoTKFkysmFe5kqMHYtBkU4wu3JDiEsfw==@kvack.org
X-Gm-Message-State: AOJu0YwXTt793VoDhCYw73yAgRgIkq//k6gp55Gg/hnA1dj3qvieMzXA
	/dNXCPa/Sfh9pAQwarL8nDMnQyUG1LOM/u5IZvZp+nFkUqjYkCz8JgfwscLrAcUyfbY=
X-Gm-Gg: ASbGnctTSF7DhOpViE8S6MqM/zSpZy+KNNG+yqEADtv57hdy7UlYmldXbFgTIInxzZF
	cgsE3xluZEqFvL4MUCqIA6eJ5pstqhqGYngd2nmCsHqohJNeo9GmNIfOyaKDnsRDmrL2l2JnCUT
	HcIexJALbsZDF+SDwLcugpDHHqS4INUGBcveM20yMKtUAnYi0T3QKyWrkkcXpO3LBRQ37GFiF9L
	sF/NAVT3voteUUvk4B9bLISDuTIA7TYJl1cr5JXLo3lyMWfWwIjLTjqxq/FMBNbSmH3fHeD/cFp
	SjlL3EG7fHX49dR6gGHTk32YaW24mWFBSTaZICzPADvWq+GQlEMRcX/oDYSg6a/UNYF6KgQ4sDq
	qi5m9dXl38S+2SQwcsjTqzmAGIYnzaQ==
X-Google-Smtp-Source: AGHT+IGcnQ6MGxag1NEEIYuYJVLpZTLnzAxoZ0Qb6L436YEus+DLZOYlhdl12Vu/LiBk6DmaVXtczA==
X-Received: by 2002:a05:600c:3154:b0:45b:83fe:9cf7 with SMTP id 5b1f17b1804b1-45f211c9c63mr186776255e9.6.1758054006410;
        Tue, 16 Sep 2025 13:20:06 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm1345667f8f.46.2025.09.16.13.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 13:20:05 -0700 (PDT)
Message-ID: <e6d8d227-3a5f-41b5-adea-0107b9c490bb@linaro.org>
Date: Tue, 16 Sep 2025 23:20:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
To: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Amit Shah <amit@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
 Christoph Lameter <cl@linux.com>, Dave Hansen <dave.hansen@intel.com>,
 David Hildenbrand <david@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>,
 Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <mike.rapoport@gmail.com>, Peter Xu <peterx@redhat.com>,
 Raghavendra K T <rkodsara@amd.com>, "Rao, Bharata Bhasker"
 <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, rdunlap@infradead.org,
 Shakeel Butt <shakeel.butt@linux.dev>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
 <aMhgoUvziLPNt_vI@casper.infradead.org>
 <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org>
 <aMlS9Kb6_x3fqsLG@casper.infradead.org>
 <50b566d6-aeda-48cc-bd67-362cb29b214a@linaro.org>
 <nglllfwopxgz3fye3grko3hmbvpmfhewj36qg6lbh3b66bjpvz@foxfjulayqst>
 <08c0b550-0a78-0b25-308d-18b143999599@google.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <08c0b550-0a78-0b25-308d-18b143999599@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zjz46xec6cbrbkd57pg8syihb65ynfbs
X-Rspamd-Queue-Id: 3328C20008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758054007-662502
X-HE-Meta: U2FsdGVkX1+71DXMMUCvN4SDRRfW+udwQFafakULJYZECPO89Kye1w8DD8slU/AUXIJxryvaNbfFaOmFuq9Mb92kqFRK/WjnNVV8u5guSNklo38pDqUs3/zgJBa+2T20oYOC4e4n0bwNrd87UUhWOYIfzFCgKEiEBKozREGVibUrjNVd+ZSWG/9+lPUV5uUf9JnzVphMWzp9C1yZrQwx4ix7USsdLFg9xSMAECSHAJVeewSP7ZsSxgs0BC5fyhOsogSph5kg3P4DqMnwtnftTtefGk0I7NsAjlPMksqZmXulmuGgT230AwmPo3QjvnH/MSy4sN5C6Ug3CC5rr9d7pHp9BmKMvUwUd4GcyRbqpKn5YGJw7A7ROo4i3gd38pAQsfvLyZkb2ntp91o1z83FWuwDJKXKJ5jSDYG9jr181okvtQa6du0/jaRkhSbkpHcSXSUo+zmtO3kUByjc8yGbt+hVloL4OR81tRfOoIVY8j96YqOPYzDd5SXeDX/qSn86jSlWLA4K5klbsa1ukTtC10pSVJOnGRRgQEOpF7YIPz87HOy2fe4ujCLd8SHoBGzZWNeloSKoMf2fEWRBv0jHLdMNkd6Xk/114k2a4eRLZZ3iEcCdKZEYMwk8fH9RaO9LKgRHwqvakQHZfEsiC6LbN7yJPbYlDf7Wbza3qDUBOdS2bJNK7GBZ86aP09Ey7ImhduI03inNTZ6mzmUPc8iRInd6Gm7pzDLCCfjsorqP7R3NzJBRMBxsACgQ2qV53cydB1tlrbBPmoeDx56rO+4RMpTnUDZ8m9dpfWkpcoNqrZmkO457TYIYQKvdVu0DfTlggEa/CC9hs4QgxLVkpvJDNV7WI2p5oxfIFQUayRcuDdQrFMexr0L+D5K702qQ7qFzuQrdz706QNAQGTDPCFMLG7LAjS8BG9F8nD4jlY3dUC/hW5cVM7Vq/PXPjltbApI75f0KSLYLu+z8MvGKHjs
 xhlCv7pg
 U+Pvbyf+Jx4m1dbpVNop83JuhBRTjWL8wvKSp6Huzpw5WR7hDvYSoiUZ2EVylcJANyGnr+aKaXgja6D/uvu7UCguCWPmbSxWiggf2OPsvftYt24eaI/gV3qiTWoW49Ybbs9FSd09UfGUyR6ddG69EP+VhPwnfBBSWjKwSsIDJDTK9k/+ec3/okV1x8xoqNPfnvoRdzgJFJCYim84xV7VwW1GDZVYNPBNhhGXpoMGdUej6TbFyBNutucj6dyOig2otB7jZeELegQU9STMlrJpwsXkggjBlYEmrCGkd89w9LzmjoQbPfQMXch5GPFlFTOn3vrcDbfsrXSyd0hRkef1K9efT2UmCcraG/VuGh3m/6iIhN75vZqkntAjUhmff8naF2a2oJKuud0P2WWoX30WuErzj53nMsso88vnkjz7mYxcUsc8IvxISFO7Az9Mcfy3b7ZGV9c9N7Xxcc6Cft8v7NoeIdaP9ELXTBAfjN+RWsdRJZ87Nfd9xbx/crI8F4w2cST71v8E7gQ8azQcowJCioYjtE6XMXiLjYVA8Wb8DJMGxG1J8zmymtB41G9PEN2rkQBpNXz9PLyL3dP/UDGm3yNEUv5d0mZTBipFLlOjmWD7OupANX+uRXU+6DKm20n/vwq2zBit9vb+X3QHuKTBzWJggBydu3TvZL5nWMHK8F8tBrqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/25 22:27, David Rientjes wrote:
> On Tue, 16 Sep 2025, Shakeel Butt wrote:
> 
>>>>>>> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
>>>>>>> proposal at https://lwn.net/Articles/1031319/.
>>>>>>
>>>>>> I don't understand what this has to do with mm, to be honest.
>>>>>> It looks like a debugging aid.
>>>>>
>>>>> It was suggested to move it to mm/ :
>>>>>
>>>>> https://lore.kernel.org/all/0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org/
>>>>
>>>> I feel like you should be able to explain this rather better than
>>>> "somebody else told me to move it".  As of this moment, I still don't
>>>> know what kmemdump even is.
>>>>
>>>>>>
>>>>>> https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/
>>>>>>
>>>>>> is a great example of how to write a lot of documentation that doesn't
>>>>>> actually tell the reader what anything is.
>>>>>>
>>>>>>
>>>>>
>>>>> Here is a link to the v3 where I changed it a little bit :
>>>>>
>>>>> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
>>>>>
>>>>> I am eager to improve the documentation to make more sense out of it, I
>>>>> am happy with suggestions.
>>>>
>>>> Start by telling me what it is.
>>>
>>> A way to select memory areas from the kernel that can be used to debug
>>> the kernel, instead of saving the whole memory dump which is mostly not
>>> of interest and takes a lot of space.
>>> Anyone can register a pointer and a size, these are placed into a list,
>>> and a dedicated firmware can parse it and save it in case of a crash.
>>> Does this make sense ?
>>
>> Is it only for kernel or is available for userspace as well? And the
>> crashes here, we are talking about kernel crashes or includes process
>> crashes as well?
>>
> 
> Yeah, I think understanding the scope of this work, both in the current 
> RFC as well as the long term vision, is going to be useful.
> 
> In this case of kmemdump, which I agree is not core mm, it's likely best 
> to use this alignment session to first describe the problem statement: 
> what are we trying to solve?  The reference to dedicated firmware above 
> piques at least my curiosity.
> 
> I see some interaction on the latest RFC, asking questions, and deciding 
> the interaction with pstore, I think the goal of this session would be to 
> determine if (1) the problem is worth solving, (2) if there are existing 
> mechanisms that can already get us there, and (3) if the current approach 
> makes sense long term or if any pivots are needed.
> 
> Hopefully an interactive discussion will save time in the long term by 
> ensuring alignment in this area even if the feedback turns out to be "no, 
> we're not doing this."  That would likely best be done by first 
> describing, thoroughly, the problem statement before jumping into 
> implementation specifics.

Thank you David for getting everyone's expectations more aligned. I am
happy to present everything tomorrow and get feedback on how to find the
best way to get this moving forward with the community.

Eugen


