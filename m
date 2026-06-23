Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630ABCD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473F16B0092; Tue, 23 Jun 2026 09:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424556B0093; Tue, 23 Jun 2026 09:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 310D06B0095; Tue, 23 Jun 2026 09:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 025286B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:56:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73EEC120515
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:56:45 +0000 (UTC)
X-FDA: 84911327970.24.11543DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9BC15100002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:56:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdwRFdFu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782223003;
	b=J8hDau+gAdrLXj8qqM0tjq8sd5Bp4sP/DeQDERXGYLhAqxbZI/UgBhjjSITkF2qWJhyTFG
	uKffDkqrUSoIcj2ZFk7mqB4rA6GhkefFC5Vs55mo2T7fwH3YHPX4xUmZtlpz2M1GK91Glb
	u8NyG2jbamBQZrUgYXJPuGmov2zQCyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782223003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=348wMgSmJD01cYVZxG1MpLEasY34QPQjsp7UvlWSoHM=;
	b=SfuCqA54TCUDY6z0L0flRu4xEb/SgXZKOtOHqPgP1VXw4m69lWxyqP+Tmr5yFLwtqUhh0y
	oXLE0yudWP+dP9qcTnXmp9aUETZe8DdCKEpNeu1pLFf7qhv78rQ/DaOm8gmwHSngaLg269
	rFpcG14SBHSoOpFb6X277fpScsV1fzc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdwRFdFu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4A3D43665;
	Tue, 23 Jun 2026 13:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392C21F000E9;
	Tue, 23 Jun 2026 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782223002;
	bh=348wMgSmJD01cYVZxG1MpLEasY34QPQjsp7UvlWSoHM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SdwRFdFuyyOdJKp2E5R2ASbFHDCeDhbyx7aQLMOJmOXAUMpYidzxhd5oxrcf9Xb2G
	 VR4HmXQjMb2hSufVqn+hcub0gtcoSPtpVdX9+xyq4I9odV6hPEgoNZ3AAMJU6LF9V5
	 pXWrv9/v6vAj76YIbf/F+UR4m8cWXFEB9rqBFQHIS+wKaoFTSrtZzsioTpGgGCr7O0
	 XJ0WDp4jr6t7FHibGjI6KodQskf+NkunhFLKraUWJVFSsbEUG018JxFjUPkq593VuM
	 QizhLFasYQdsEcPTbPEIx4C/2uQYxmU94nf8IHlHzWUrmzcCZLI316Bm6qctr0w8JE
	 t2UPTMSpBW2AA==
Message-ID: <1cbdb3a3-b8db-4ae2-aa66-9042c1033745@kernel.org>
Date: Tue, 23 Jun 2026 15:56:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>,
 Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
 <d421c081-8686-4d46-8452-e543401b0503@kernel.org>
 <87wlvpct0b.fsf@trenco.lwn.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87wlvpct0b.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BC15100002
X-Stat-Signature: wqesjp1n56yx7jczh9nh9uf4z4p4a1nx
X-HE-Tag: 1782223003-784551
X-HE-Meta: U2FsdGVkX19FDE7It+8CnOxpEtk1D6ygAocvKHp8fTM1AfLWFHW9l+GsHx3moDweJ1xjv/vO8ddUjK0y+FWuewMDmP9prCTOiKScXfSEIDLu+nfTkg0EWm/swJnR81AJQIkAz9ffHJ/vxzckUoZ/lAMiK9hvYYnB+ThFx+o8KKatA8okxECFJSXVs4m1Us/IfG5rXAobppJb/80ycWl2OHaM9KXst1jd1VcFyy+2/jeFbdkE0j29tPqLyzbWKCNHs0UmKXReub5F3u9DzYmu2C8mUeFzPXeVlLMO7JzW3ANsqLnDm5ot+Q8B3zCLRe5mq6lTdBSMmRP/KJl3+9HJgP0vQ5jXrPkSXCSWLYJuDUGZ2rdjCZZTm5gQI9w2X+S64qzM70MrRm7rJwoyM2cMXAs0kF+VUI2gLLr8x9Ysi2hSDI85HCdd87Zqhb+fvsUY+64CcoUfebvu6/xhsmkUGR1wR1hPsuvfbk5IAZtIVqdFoy712d8S1FPxsIdMkajognBYXs5kM9X+eg8uZQolcInE4s97soUtzc4uQwkje9JBMO/9Al/q0Layq1J5jHeVnFRuXDgrhkskVvRxRlGWbKifenuWad0+C3/xEDCdVerwWOF/exCFsOwb2gov9BziUhCP5aQzVygSNqizUUgCzW4FIhju8aMaUCVmw8cEmT0iJFpP0f/cizmQTNyrSmZPUnMetYpU/hbrLNITGhQzwCkTl3jDR/wBCcjWizuKT6Ag4DO2Vx7DvwriUGAKno8OPz8oY19SBbGzEx6cy8bDiB5Gl4MOxWE5qq/XsCRLBf1Id1qiVMFLETHP3imlIETFdQi7E64upmAXCFvaXtg3G3dYN1y5JTf4hz0nc8aZ5zHP3bLezeQveFX9iq2Ixm+k45JQWK9TrQsDXamAwqFx45yqw+zLBgM52ed3M3onbFo1U8UxG1R8MX91Lh9WMA8ZqsZjXnleQSW7zyHRdia
 hPV9KLus
 iH2RWWnE/VYIgGit0fLJ7nQAgE3J77kzFUvNvqeCIZyYfuX3lZ21XTdFK4Cg0gDEVPmZh8q6h0zqaiWbJM4ZG52VLZD+1Yf8Gto9hCsyoftVzuQX8dapcqB+W2/euh/eF7CHhIz9Ynyhq8Me5E71Rro6Odh94Ovn3Gb6+Nm9mkUsUcYolDupA1K2BmP2a1P+wabmKnFkms3/aGlylSAr51EH68ildVCzAnZJBQNTStsJvhNM/L7R0Ux7g/4ctvJjqGseyctradwSM7O9XKj1rHEtNSlitiZrnu7wVH6iFA8jfVYxSzOhvKc/tqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 14:59, Jonathan Corbet wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 4/20/26 23:03, David Hildenbrand (Arm) wrote:
>>> Let's make it clear that we are not looking for LLM generated content
>>> from contributors not familiar with the details of MM, as it shifts the
>>> real work onto reviewers.
>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  Documentation/mm/index.rst | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
>>> index 7aa2a8886908..13a79f5d092c 100644
>>> --- a/Documentation/mm/index.rst
>>> +++ b/Documentation/mm/index.rst
>>> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>>>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>>>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>>>  
>>> +.. note::
>>> +
>>> +  Unfortunately, parts of this guide are still incomplete or missing.
>>> +  While we appreciate contributions, documentation in this area is hard
>>> +  to get right and requires a lot of attention to detail.  New contributors
>>> +  should reach out to the relevant maintainers early.
>>> +
>>> +  This guide is expected to reflect reality, which requires contributors
>>> +  to have a detailed understanding.  Documentation generated with LLMs
>>> +  by contributors unfamiliar with these details shifts the real work onto
>>> +  reviewers, which is why such contributions will be rejected without
>>> +  further comment.
>>> +
>>>  .. toctree::
>>>     :maxdepth: 1
>>>  
>>>
>>> ---
>>> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
>>> change-id: 20260420-llmdoc-21bf5fadbd6f
>>>
>>> Best regards,
>>
>> I assume this was not picked up yet? (via documentation or mm tree?)
> 
> I had figured Andrew would grab it; I can certainly do so if you'd like.

yes please. I guess I'll soon start grabbing stuff myself. Stay tuned. :)

-- 
Cheers,

David

