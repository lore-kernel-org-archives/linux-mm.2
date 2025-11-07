Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09914CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 07:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F2A8E0005; Fri,  7 Nov 2025 02:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3673C8E0002; Fri,  7 Nov 2025 02:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D0F8E0005; Fri,  7 Nov 2025 02:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15EBE8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:29:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDD7E16038A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:29:50 +0000 (UTC)
X-FDA: 84082986540.23.D6DB8C6
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9EFA10000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:29:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CfTnoqwd;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762500588;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAjKbycoN4on3/6bE5ZFCdJ3hhwzY76Z7Sh/6P51/hg=;
	b=WaUhPy8sHtPiXH4/m4sF9D80xNyNsy5x5wUIv/Zc1B+4Q7pIl3mlpf/mojLA16qPeHnpr/
	0/nPmYS/8mZbYLxn+vJmqy1C7f7OFgmy4cXSynNCJXQHxmgQAFcNn9UBeFbVbpjBOMmvdk
	Gr4xT3IZQkyfWmxnPP54RDnhJm85xTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762500588; a=rsa-sha256;
	cv=none;
	b=IVFCO9ekNONPqG+BoF1qdxN9ikoBs7hmISj2htz6Bfsgzjbl+89HhETZCe0F1lscGRwpLV
	VRLFPgToGKsNvzvFOW9oYB67VDTRLs/cr7enBx8fYjEGa761WeQRIsLYF6Zcv2mKLotYKU
	yD61ns6T9PXTP9JN34Zmq9ayKkBrdJg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CfTnoqwd;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b70fb7b531cso78149766b.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 23:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762500587; x=1763105387; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAjKbycoN4on3/6bE5ZFCdJ3hhwzY76Z7Sh/6P51/hg=;
        b=CfTnoqwdiwKny6SYUp3IIHcclHC3Hs5hfxmqkZ7Rzp2bibO/wJUJQFSZIYxW493oqo
         dkydVhNe6LLL2duMzV+DJXOZo765HwaCgK+ra8mSCCTs5bajcLgnco2/Iq1QyoBPI0pC
         rNCCIudCAYTLM/HqWqSZQXYP9jJl6FTdP6U6YbefM+7vDTpYFrrjNjEaXkZmGXHzoKjI
         TF7SNZQz5XSdP9QIQoj8N68BMcV3gfUKXtLWkpHXqLmjrNbP2QacFBnx3TGFdWZ+2ksr
         PbBM2mtP09B2/4M+AkjYphTdfvQyFAYK5RS+wX0g7LYgpnxZh33siGfja6joDOVcfEcK
         DZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762500587; x=1763105387;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hAjKbycoN4on3/6bE5ZFCdJ3hhwzY76Z7Sh/6P51/hg=;
        b=tX76K1NLuZ6g6kU7btLBjcHli3o5WNTaXPfWGGgiYie/huyR9ciffrlEJy6vKz2rcl
         HYDMrksXDKZcPNQnhRCDvNDdpuKtJwSaEkOjnMZsuV5qRevEMRBLRGqRdqDfpYbl2aEJ
         1APxWoEPpe0jFWOSqdfSsR8pak8fmPRYlDUWfv+oBDGN66cCOgx3uGamGaXdLTQTFyRU
         KtxvWBQaTPnOmPDPAGWfXZXx9Q93Sf+mo8kFo7PixcsghtN1bKtRFQEQxQ7pyQC56wOq
         UEGCSpHHvI1SUczRNhy0UeMY2BrQNyE4aMCKeEXqkbTsj4yPo93vqud6H5Bcvuf+TF1j
         pIEg==
X-Forwarded-Encrypted: i=1; AJvYcCXU3UOTsVRGGxPFHpXIx1/xWttbMExp5sBDRuVfbMq/lwasKlzdfOnWADqUNJJjWWxD7BItw7NX5Q==@kvack.org
X-Gm-Message-State: AOJu0YwOnJwjlke11c6XYo0C0YMf15Vd+oj5OciqzdjQJV5BXpS44XFR
	3zex13D6wlX6l1RImdTOgOiEVAHgtK0ja81NRaFjA0GwLc3WVGUnCzgE
X-Gm-Gg: ASbGncuR9OgSbQGsd3qj4UAVWpr+cTsqfQ48UcDjHxRS3fuAPpnhj5rt3IKtaASz7Oz
	F09Yga/3s64ZDbxzgJ/wmbJhc+FyQVW0E0CVV7Gs1SGmvQ7XFoPs73FVrTZk6+EjiJWJmuYigyb
	3xcHY1KADdIsxw2BhaRaZtzALxwXzhOGnlRxiyCotdHCcY6J4TCnnKfdhcttb0Li31O3xtVRwy2
	aokEQ0ZN0WDp27N+Uk02ilqyrkokcJt2Fyy1umf3pfKPiwmkOdLM03JKR4SdhtJbengqjADOWml
	iqyWfZZDuXhUV/M6WuSOkSn5l4m3A80sdANUuDhkYHbcAS5Qwo9gIFxeC3rzPfCOrru+sccu56k
	1gWfnNC5Ue2DzWVO/LI7HlboSfE1uRfUvydmSsBmxwSlPvuu+xhCbr8ANfb3H4yYKBdfofJ/+tF
	pi08dRmpF6vA==
X-Google-Smtp-Source: AGHT+IFVxpCymlwNAxVE693ZuWqrCRqosAbH7LPZEOBmLvAyoTtS9VQUWVM7VLWy/8jjDoPG9lEysQ==
X-Received: by 2002:a17:907:9309:b0:b6d:5b75:4533 with SMTP id a640c23a62f3a-b72c0928b7amr230749366b.18.1762500586849;
        Thu, 06 Nov 2025 23:29:46 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97d0ffsm175729066b.46.2025.11.06.23.29.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 23:29:45 -0800 (PST)
Date: Fri, 7 Nov 2025 07:29:44 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251107072944.zvqvr4kyibyofhuw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
 <20251107011721.ez6pile62o3vmjz3@master>
 <136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com>
 <20251107024902.6qu5h6rsmwktzutm@master>
 <9271B00E-FF43-4EA5-B180-7A509E839DEB@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9271B00E-FF43-4EA5-B180-7A509E839DEB@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B9EFA10000B
X-Stat-Signature: zp7bfjycwmokmdfaiq56hyupgj4r8axg
X-Rspam-User: 
X-HE-Tag: 1762500588-111220
X-HE-Meta: U2FsdGVkX1+EMKUVEscJBBD0vzLjOQzJrvUFLRmzEst7XoEEluD6PYmYEG2KirBDiAhD+gLdD6gSWPz/nvgnZ781im540Rc6GTRYdAWx5A58Eh8YMdUq9VlLuJr6a25g9xDL/YouHwjbShU4m4BL4/yXjl1dxpHjYFi86X4CiZsA8+T8NkrU6ciRB6ikqVql4sOGCZVOihl+7vdc8nUmegeA7nWXRGNgZPnX1s8YKAqhzVDe5RfvIEHLOZvSda5FwbIIO9ZnfnAcUocIQUvPnw/XADBtqINaGHA7ZTOurxOuUvq1qD5ADUAHf6IXfRmtsHNaLO5UdvXFbgWuT+IvtPT7vSqhdVumyw/FCE5N/czSe4wcH+j6c+itLvXD2Ix6itIoTMzUUMgBggocSkkjRd4huTMxbuzoiAGgmz26YBZj+R8OkHJXUiMwFq9tjSWYU2F/6iHZotQuO9jwJm3+16Y+ZHm36Vv5FLA4B4G9u/7+EOJrD7VsdofESQR8gCyNL+rP6qW/U9UjoEqZIyx/23DlfgJHtiQGu8a3KSqiJOjTfl3y50SHwnritIFv5eLBMEA+5b5CazIkSthhStirMsVA+SEuAho5RUshA5LgQFFipNHYG8ahQBgqAaH47Ze0zk7fU5iCMa71ZJcginKvO/XgrI2NiXIJLTl8GSK4sa8QtbQ+NMJ1S6b39Gmqc0Rev4ioUaI6n+K7MFEvEG1ndOaO4VHuliDXrMLyswe5s6sRU044faj4dFBN1Azt4fAKpEuH8O5j0gJFEEXWTXurGcmhjcfkW/nk/YJlNB9J9QIzQZDgNzCL0qMHud5giOijdll4Qkp6uZ7DaIoxvZN+mSxq4/DMwSH9muZHadYQRvWnICuTx/jBslyLQthA3+BZOHtKHNYHCfEMdAk1XtMhXtLQSiZj+iiAYOJDtJU5urvac9S2MEY/xws0xWzJYxjRzcB0QxePnD4f9lXzCK+
 UDFaUrAs
 A/UhLSH1mV45/cRilFPJhcTOifT6wqxXieWmvA/mrWIC2wiBdMZLUxfottcQHpZcphW7YfJXCvODWqfEKYMFMgD6ewm8vc2Z2ktauv6V4kucjuMYf3acqJH2Wkw3meB8Faw6amCGYj/BT4UaLNZKiMI1nXgtUOropO2fAqkBGwT/h5Yvg8Rl0uB5rYvnfGO5iLzNNupcMyj7bxT8KmotiJNeZT2nCG8IDwsmjgFxqJHUBBelCWJ/2lgxMva5wRGE4frzKdp70EoVebc+NzNPWOflquGKWsGwifmEaLb/uMZ3gNLuh7rwIHYe0gvlb6Cz18yzqmtZIybE8o7XbhQc7s56sxZpBuhYeIpQZSi1oihi8l/1xF/Z8MMOy5YQxJTuthxlrDCEHd8w3w4N+tylO5+gqbOwCc6Bs63txppQFXlbtSYNAXeL+tbPEz8FXrKIHCT/r0Y0BGALrZI+mr96XJx+nOI3XX6nfAJvEOlZm80hxNh34XStBxPiYaolVF5xgYnFk/YFm5fhMJ7Nqy2fd6S6CD98b8HgQhSzm+2gkO1uSzhfDmMmgFG4RHbMBOSDZm3XXq0JSeJODwIg0dJOUQGaKWzeR25SBVoD7F1PL13erb6q02hOboiiXE9UVQNT6rJGH7aC3Xy/eHzZ5TABsJFauGd7i276leD38FJBo7OltWFv+BIzrfCPfuIsWhx0JL0nJeOwg/zS7CORzNnkE9e4eHxnx3RHKWszC0UPC2pVK2ygi577rL4+JTQyH9vJxw/MxizhdIall/aeyOSUEbQEB/LETnCEkw3fCSc5avbBxH/bLOsbTtRWnBSjc3Jj6h6tU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 10:21:21PM -0500, Zi Yan wrote:
>On 6 Nov 2025, at 21:49, Wei Yang wrote:
>
>> On Thu, Nov 06, 2025 at 09:07:22PM -0500, Zi Yan wrote:
>>> On 6 Nov 2025, at 20:17, Wei Yang wrote:
>>>
>>>> On Thu, Nov 06, 2025 at 07:46:14PM -0500, Zi Yan wrote:
>>>>> On 5 Nov 2025, at 22:41, Wei Yang wrote:
>>>>>
>>>>>> The functions uniform_split_supported() and
>>>>>> non_uniform_split_supported() share significantly similar logic.
>>>>>>
>>>>>> The only functional difference is that uniform_split_supported()
>>>>>> includes an additional check on the requested @new_order.
>>>>>>
>>>>>> The reason for this check comes from the following two aspects:
>>>>>>
>>>>>>   * some file system or swap cache just supports order-0 folio
>>>>>>   * the behavioral difference between uniform/non-uniform split
>>>>>>
>>>>>> The behavioral difference between uniform split and non-uniform:
>>>>>>
>>>>>>   * uniform split splits folio directly to @new_order
>>>>>>   * non-uniform split creates after-split folios with orders from
>>>>>>     folio_order(folio) - 1 to new_order.
>>>>>>
>>>>>> This means for non-uniform split or !new_order split we should check the
>>>>>> file system and swap cache respectively.
>>>>>>
>>>>>> This commit unifies the logic and merge the two functions into a single
>>>>>> combined helper, removing redundant code and simplifying the split
>>>>>> support checking mechanism.
>>>>>>
>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>>
>>>>>> ---
>>>>>> v3:
>>>>>>   * adjust to use split_type
>>>>>>   * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
>>>>>> v2:
>>>>>>   * remove need_check
>>>>>>   * update comment
>>>>>>   * add more explanation in change log
>>>>>> ---
>>>>>>  include/linux/huge_mm.h |  8 ++---
>>>>>>  mm/huge_memory.c        | 71 +++++++++++++++++------------------------
>>>>>>  2 files changed, 33 insertions(+), 46 deletions(-)
>>>>>>
>>>>> LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>>
>>>> Hi, Zi
>>>>
>>>> I am thinking whether it is proper to move the check (new_order < min_order)
>>>> from __folio_split() to folio_split_supported(). So that we could bail out
>>>> early if file system couldn't split to new_order.
>>>>
>>>> Not sure you like it or not.
>>>
>>> It sounds reasonable. My only concern is that that might add another
>>> indentation to the else branch in folio_split_supported().
>>>
>>> You can send a patch, so we can see how it looks.
>>>
>>
>> Here is what come up my mind.
>>
>> If !CONFIG_READ_ONLY_THP_FOR_FS, we directly compare new_order and min_order.
>>
>> If CONFIG_READ_ONLY_THP_FOR_FS, one thing I am not sure is for the khugepaged
>> collapsed THP. If its min_order is 0, it looks we can cover it with following
>> check.
>
>1. mapping_large_folio_support() checks if mapping_max_folio_order() > 0, meaning
>   !mapping_large_folio_support() is mapping_max_folio_order() == 0,
>2. mapping_max_folio_order() >= mapping_min_folio_order(),
>3. combining 1) and 2) means
>   mapping_min_folio_order() <= mapping_max_folio_order() == 0,
>   meaning mapping_min_folio_order() == 0.
>
>so a FS without large folio support always has min_order == 0.
>
>>
>> Look forward your insight.
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index dee416b3f6ed..ef05f246df73 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3704,8 +3704,8 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>  		if (new_order == 1)
>>  			return false;
>>  	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -		    !mapping_large_folio_support(folio->mapping)) {
>> +		unsigned int min_order = mapping_min_folio_order(folio->mapping);
>> +		if (new_order < min_order) {
>
>This check is good for !CONFIG_READ_ONLY_THP_FOR_FS, but
>for CONFIG_READ_ONLY_THP_FOR_FS and !mapping_large_folio_support(),
>min_order is always 0, how can new_order be smaller than min_order
>to trigger the warning below? You will need to check new_order against
>mapping_max_folio_order().
>
>OK, basically the check should be:
>

Thanks for your analysis.

>if (new_order < mapping_min_folio_order() || new_order > mapping_max_folio_order()).
>

This reminds me one thing, we don't check on max_order now.

For example, the supported split order is [3, 5]. But new_order is set to 6.

In current kernel, we don't do this. try_folio_split_or_unmap() pass
min_order. But selftest will split from pmd_order - 1.

>Then, you might want to add a helper function mapping_folio_order_supported()
>instead and change the warning message below to "Cannot split file folio to
>unsupported order [%d, %d]", min_order, max_order (showing min/max order
>is optional since it kinda defeat the purpose of having the helper function).
>Of course, the comment needs to be changed.
>
>Hmm, but still how could the above check to trigger the warning when
>split_type == SPLIT_TYPE_NON_UNIFORM and new_order is 0? It will not
>trigger, since new_order (as 0) is supported by the mapping.
>
>I guess the min_order check code has to be in the else branch along
>with the existing "if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order)".
>

I am trying to think another way.

For uniform split, after-split folio order is new_order.
For non-uniform split, after-split folio order is [new_order, old_order - 1].

So I come up following draft change.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dee416b3f6ed..873680ab4cbb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3703,28 +3703,18 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 				"Cannot split to order-1 folio");
 		if (new_order == 1)
 			return false;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
+	} else {
+		/*
+		 * Some explanation here.
+		 */
+		if (new_order && !mapping_folio_order_supported(new_order)) {
+			VM_WARN_ONCE(warns,
+				"Cannot split file folio to unsupported order: %d", new_order);
+			return false;
+		}
+		if (split_type == SPLIT_TYPE_NON_UNIFORM && !mapping_folio_order_supported(old_order - 1)) {
 			VM_WARN_ONCE(warns,
-				"Cannot split file folio to non-0 order");
+				"Cannot split file folio to unsupported order: %d", old_order - 1);
 			return false;
 		}
 	}
-- 
Wei Yang
Help you, Help me

