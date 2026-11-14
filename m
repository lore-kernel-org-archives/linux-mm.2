Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE43606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FLD2lkG8
Received: by kanga.kvack.org (Postfix)
	id 78F406B05B3; Sat, 14 Nov 2026 07:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718FC6B05B4; Sat, 14 Nov 2026 07:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2AD6B05B5; Sat, 14 Nov 2026 07:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37F916B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:46:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB31B14035C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:46:10 +0000 (UTC)
X-FDA: 85433697300.17.5C0AD85
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id D445B40005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:46:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FLD2lkG8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794660368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULKrDX82PMQTKcgYYqf1zY84iCTLqlXPJmOCgLPPGgw=;
	b=7p9qBpypShYF0J1k0E6pqegwpG5e1bMmV2xbo42kbfTT8RaoXQF7rwH0oIoAp6GLNiEvar
	sts/MKduIs4KWPVL0+McwYTdHtYUt9ProZMU9ZXQKTXZjbKMIU77iKPpDIT3Nua6bzFuDu
	alCzYlUOXIhZJhEtXxhFsGiHBvl9IDM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FLD2lkG8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794660368;
	b=JPitCfLJ+iakL5/LCKLwNKQqeqXySj82tAwWZqogRk4mAn51gfLZB7Px/ChJ21rccHeh1C
	Xmyp0UBZK8g9UiR5XHr//+1Nb3/sbA3oYUKXVxZarHp14FQkyHS1xgE+VVoNhPyEZtzlsp
	EHs4qHufTRh3sz+tQ/seHNX+n+HRwI0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so8464245e9.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 04:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794660367; x=1795265167; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ULKrDX82PMQTKcgYYqf1zY84iCTLqlXPJmOCgLPPGgw=;
        b=FLD2lkG8z9CkykJxzcOTd31UTSsEEPc4BY72mPEJgLW2nCcJsYNanTNN3ijJzqL3Qa
         1eAVsog85UDbGpxG3OkRl6LMxi3kdD+2rTQ+ZgXn2yfgm4Hn03iQz8MsAPHmQ3GRZGAt
         ggeaOkd67y5MtBHqHLvBXB8WB2wranHrJ2xq4X8ZfNAZ48h/LyIqJ3JMwKpaep4jFFuo
         1PX5SlePKlyRu7O8l93Fuu/CWhE4zKFL7nhCapC2wY87RBjnTkd/BiP1ZbXV292axRvM
         QpWodtsZYLjnTNRCe3ry4uzxmrqTME7ek2E4QvXpYU4gsDd2CqiF21vAG5QJgD1aPIkn
         mmGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794660367; x=1795265167;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ULKrDX82PMQTKcgYYqf1zY84iCTLqlXPJmOCgLPPGgw=;
        b=m8JtiiZdSEomf6ZdfIndhwPgR9Ylk7NREqKdiKORYAmLtXdiSB7msmZiEeSGMOLvhl
         ZLhEmG0y98pNICzn88ZppRTInsItGxi0kE1CEkG4PTKu65PCJPNYMN8hcyb7qnIiZvvf
         nmJFWojbAjxGa4f/6lqi15whDwKXlb6lbKT0tX23GavQ6Ix0hbCUuB7xy9hZwQRDV9Il
         G9UFr0mxVQR6s97Y77hu48ggwyD8AZ+2P/eHaTj1YW1D9BcLWpxPDI2AZAmDEyFFJUJS
         pBM3R/Xz2Rg8Qp/cyoKtyqo7QPyzw821+eliLUHbQljuyFlH1S+pNQu7jEmg5ylYBOMB
         HRrw==
X-Forwarded-Encrypted: i=1; AL+hErGaenDOXlvcBzlzARqxHvHxqPSkRaEvRbkpdhfbn95jcw5aoQ6Cm8piRGMQ9Cfhzf9b/LC59daQXA==@kvack.org
X-Gm-Message-State: APuU4Z/+sVyImUr+OoifJHQCmdacgfsxPbjH5KmCWVS4HwQ+DjghvAf3
	Db/RJM/vjS4FiFIRfsNiZuoUaxMg3eXkpC512GnbQ6Tw+rolS4kys66j
X-Gm-Gg: AYBFou1By+V0xugQ9zEYivAvjoeKHj+3rbbzXNNhp46vTNeGQO7/3zi8y01IMIo3yDD
	WWApDUCCfDGIBghjM+1+UIRDyaDO5GqgJkBX/gJC3bPY6VvbuqHriT2VM58DTWhSQ5C095zodPD
	gb65yd62IrhZVVVHvpo2AaVP9PTSvpz6IzoHnj2mfkXIW//84NwAajGa9UPYjUfCbFTgC96enXI
	2JC7ukZw9jhSkQfwUxQQClLNzzqcbY0hQExyBg9+u7OGQ3eMNgcSkCDb97QNbmlDjo3lVLzXXM8
	0kJsmfngmB0Jk/IOs/e5YPZJH8DYhTLBSAya/FrIWppnegP4jHmT7AbwO2zqHrpNPGYydtj6S/q
	YmsqI8ik4j1UTsaBdWlupW3QQiVYuwEZwSgqqMP6Gh7wFoMFlLc4p7nydJow/8EXjE4kcOGT0xx
	O4LqLkqrmwzt6lDwfWp7IRvoDYkrqt2Mxm1EvrjNR2QJaNiPjLfuBYtAZCe2Ae9PdGC9IoEhkIW
	D+gf6rU1w0SAozmi69szwwC+dV3zrHhNj0wDMbQs9xeXx0+/tTjsNVQcBdaHDPWyTroI/obfx6+
	vXWnqKSVb3IUSAcO0OyTWizU
X-Received: by 2002:a05:600c:4e44:b0:4a2:180a:3417 with SMTP id 5b1f17b1804b1-4bb55c5f5admr108580805e9.1.1794660367022;
        Sat, 14 Nov 2026 04:46:07 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56f8d054sm89043665e9.3.2026.11.14.04.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 04:46:06 -0800 (PST)
Message-ID: <5ff13e10-d8a6-43ed-a718-8b34ee08d4e4@gmail.com>
Date: Sat, 14 Nov 2026 13:46:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm/huge_memory: find partially mapped shared
 folios with NO_PAGE_MAPCOUNT
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20261111113535.330078-1-azpijr@gmail.com>
 <4411389c-2246-4af6-9b34-10d3f259aeb4@kernel.org>
 <e9033159-ffd5-4c84-b355-964687b75226@gmail.com>
 <3744f956-8179-45f3-9d87-c99c82b2f8db@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <3744f956-8179-45f3-9d87-c99c82b2f8db@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D445B40005
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: aefsgaf1tx4mt6ag1bkxqhz3ykkh8jc9
X-HE-Tag: 1794660368-362855
X-HE-Meta: U2FsdGVkX18ZcBrxkhn8sQ74RnfDNPPg40N9skLNTi6udvhyQuOxvv/oY3R2JDP4+8XppUCuIwsnBC+akwiVOrl1srI3+Ou/KS2FifjPUWjwHsEbweVbh2Ykt1mtCTDHq1ywv/NlUQSkpdYrDPfyf+ajhY239QZP/uLMhFKr+d5bZAQQDjMqnR632pC3vrIoXxSQNmu1i4L+CaQZMmsTh9WfhrJv63GLIBBVmljIAR79KzFVUslyMJL53YlAFiKOZm4CsL56ArtQMEk8z3w32oR5qvdTxB5vDstY6P1QGVnvuSXq+XNsRNeC4H1xyML7fwpMeeEAweFugBD+Emj7oBxpYjiO3N0zXuuKncr2kVwAgz42Gy034hXORk+TcNuvEQ9MTGqJDcoUPJ4xdTX4mfL62Dlh2nGco+M7p/eG9UaibOeeLBh681RB8iHpnyF4G9aBLcECEXKtOQSstjR/CgKwRcvj0FDqG4QkD9mA/DXeRRazya+vSKIsq0kaIgUSxDNhKarUbR7mFYrenIy8wtD2Wd2Mav6sOHSP6DW1mSM4l8soj+bvBv3iK8prEnzfadAiImrqX7ANR+M49xPJKzpaIHlE7WiNWcjEmffk4R/oqvmLY5aLoUaJci9QZq0hVYA+x5EaI9/xTUuMb1eqGoQqYRQtYs5/L1H9O2/g4m6ApBn4egpZ/4QY+vKMpDDQqAM9JcgWkPO1tJIPWSvYFjrZLlsJNu0+ReN9fi24dgWq0B4yjuIDuN1McO25049uY8kVHeJAZl4D9z9ACTn8doLLr9aIsyrS4EQYw0vYsQXFtL+MOu8GkgbJapbrTSVEDr7TIsLxHlkBNYe0lwVYDodWnYlsOk0V5FRRdcCkncBeQiN61al2y6bgRtW6OpFDcEZW4JmCauVWEqwhvSZeJQyih0NDda0tVoSJLFQxBrC8tta2gNEFvFT0yOywRjuGsTTtwywgI3qg3fPV0O8
 4kHBRpJp
 DDj3srld/rLL+k5spqEGJmfArtwn6DzMHL6VIf62+G3Fgr0qrVevxX8jyvXF9qqO6qQjHiM/jeRvL7E+/AWRDwAmea0oKyLbGBNZrGkMmPC5hmL13gIup6JwEI3axGr5BjKur52oPCD6HePGuMeQuqUIB4pYpnKergCWuVKYBTO8X/e8aYXbaYDeWkZQ1l9JL61enDQyBjPoM4uuc0jzrbg9N8ez2ctKcRt0nL66W9y1TvX2A2B3SoZQu72tDFBAetgdKjqylZbi+43wDRrXRMfPOygTSHezsdH97qPCllZsZTdzYIdm/kETvO4+awVI6122znVkKNjCKmIiRX4cv7zRHl2LQgETi7XbSGGe1suZ/LUfZESx5LFqGhkt4gL4oHOrPs1blIy7ttuHVr0dvz8U8IqVDW1aivIdmNS28FqJf7Bc692fRl25SgLGpE1HRVUGEEIzW30IbwqKJRTB+b3iGgLVI6FROnCg/fU2JuUrHwVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 9:16 PM, David Hildenbrand (Arm) wrote:
>>> (b) What is the overhead from having way too many folios in the deferred split list.
>>>
>>
>> I don't know yet. I only measured the walk in a TCG guest, nothing on
>> how long the list gets
> 
> That would be really interesting. I assume there are some cases where a simple
> fork+exec would already add pages to the deferred split list even thought they
> are briefly after fully mapped by the parent.
> 

I tested and, yes, it does. bash doing 200 fork+exec with 64K always
queued 2 folios in total.

[snip]

>>> Maybe one could track it a bit broader? "any page in this set of 16 pages is
>>> present". Reclaiming a single 4k page from a 2M folios is barely worth it.
>>>
>>
>> yes, that works. maybe with the group size scaled to the folio, so the
>> map is one long on the stack and 64K folio still gets one bit per page?
>>
> 
> As an alternative, could we also just look for the next page incrementally?
> 
> Like, start with offset 0. When we see that, move to offset 1, when we see that,
> move to offset 2 ... and once we saw all pages that way, stop the walk.
> 
> I'd assume that, as long as VMAs don't get remapped, that should likely work in
> most cases, right?
> 

I tried it. if the parent keeps the second half and the child the first,
a fully mapped folio looks partially mapped. maybe the one long map is
better here?

>> however, maybe if I don't have real evidence, better drop it?
> 
> I'd be very interested in an efficient way to test if a folio is partially
> mapped, and where the holes are.
> 
> Knowing about the holes could guide a targeted buddy-like folio split.
> 
> There was also the idea of letting folio_referenced() for that purpose, when we
> area already doing an rmap walk.
> 

okay, I could try that. would you rather have it without the shrinker
walk? with no swap, reclaim wouldn't check those folios.

-- 
cheers,
jose a. p-a

