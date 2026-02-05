Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81EFEC1EAD
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1848B6B0089; Thu,  5 Feb 2026 07:28:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162606B0092; Thu,  5 Feb 2026 07:28:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081FE6B0093; Thu,  5 Feb 2026 07:28:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E92696B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:28:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97D8257356
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:28:32 +0000 (UTC)
X-FDA: 84410331264.20.E8D3E3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C9B9540006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:28:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUY5ujnZ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770294510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BdYbxmgG9OgZ9rBxJwi2dbHbIELghPPO79WkQWZcZe8=;
	b=srVSxhjlmTHmSHfmPNGQ7fRudx4GjaO8E7zlZGY5bC18utedLDrO0isneY/dNnmdH+e25Y
	kS2Y4ZJO5H6tGkT8dz01wGk5wgK0MzSz13HbgcySoK5Is9RRzb+08HL0wmotbjQ9nHvRB9
	pUxDXwZup+Wji8wT8iVo6AOU+4CgAXo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUY5ujnZ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770294510; a=rsa-sha256;
	cv=none;
	b=RM44uyWoIewKmv2Y+U6Zd005MRYNcR2WLo81ojZB8rnkH80476rpv/l+nt9sBV4nl/yRlv
	P6X9qzDOhZQqeVpJwUxJBZAU90KseGS4x4SqZAmtVn53PL6+ICsO2//YiWAAz8cl1/cLlz
	4w5VNQiF22QSVkyXE1gD1KwacBTdYBU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FC3760122;
	Thu,  5 Feb 2026 12:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A15C4CEF7;
	Thu,  5 Feb 2026 12:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770294509;
	bh=JLjHuaflZfzUh9nlPVIutHCb9gfPWwFA1h4yi6Z5VtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OUY5ujnZ950mNiCDLhuXt4HvGmvKuaTLlJKxOsUgUo6/iVrpV6jGLVQdwkQuc3ktJ
	 /zcfQl5k8nFERPVdLCn3u4EuBfxkaWeOtkzAqvucf9Ihvay0CkKCZp2lMu0zgElREX
	 XENza4jkXjXdF2YHc7XNJeCtYVtEtaxNPUxDk60reTMZrw0lj+Sbjt02rY4zfVFPHa
	 nJTI8XWBlztd/b/2eiEHKfXdS3pQ3GupqjLvQ1Ld9gLEQvOOznLMBYRNsT1c7JyGou
	 TG/Zoueg0XJx6b0WeVk0V8ioiDfz+uVca8uZB8MLI8EKeYRa6aPIA1QNtn2thmmFCg
	 DmXWqe0kNtF9Q==
Message-ID: <93ec17e6-e39a-4575-a592-0a1d6c47b30a@kernel.org>
Date: Thu, 5 Feb 2026 13:28:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>, Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <4f719bed-89bf-44f3-a1cc-39ddc7c66824@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4f719bed-89bf-44f3-a1cc-39ddc7c66824@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xrejcrreqn8sf9y3o4ndfqsmefiku8dh
X-Rspamd-Queue-Id: C9B9540006
X-Rspam-User: 
X-HE-Tag: 1770294510-309407
X-HE-Meta: U2FsdGVkX1+CAWBnwMD6cF5Jkt37yktjqRlrm6lBux59eVvrspS3AQZ4bs7SjHPS4dnnRsLpLY7k9ZmsIwsdZUYhiIdfex7E3K3+DoLj61KvjHVD5KuUqgTPIF8ldDZT/deScv1S5H+ukJT8lDRbVOfyHAmPcf1Rle0m9thk92Nd0DX8EZEfvlW28avWlGR7cUwKIpbnFFx8gjfifL4Cznwo/stpll2PbBaAp0PcKu/nWtzzZ7uQUZWN1ks9ATh0R963Nh1NBTThzk+jBk6+umHrhvYEeJeLPc5T+DNyMn5R99wOeRgcwfQAH3I+SnETPWADMfcRkvS8zKecqNHEpzeVEsrDZDgoG2vNqk/u4t0rSvP5EQ9ER3AthUme8eBLEdHGTlzQBbH5HIh4ZFrDbP2XZuMDtollBf/1Xe0laiT6O6gTkMEh/T7SYTa33TTSL9SJVO0odIXfWrLHOrgd9huoGJDcJOUqX0C8wtEgVafryRg+LH0N2KxzMkzb6ayJkYv4Nj2qERDT18bkAJZom6iZnWVa/FsiAK+OgWkgyfJpbS0cV7hviRYVGUInYasgwV6/12H30kywNf68lw9Tsjnz/FlWQ7x4m1hoUWdFQobos2otHexl27DA8gqoAmY2Pr6K1u1unJjxmavZDSUCCIc3MwZEJpQ+viiNO22UNESlDuFYWmzZ4G0d6rUczJu5OCua0zSI6nY6zcNp30yehjghXF/BslT5vd8lERwwo9y6MhTZAfrKvSZ0vSlLCIu8UT6/EmNf/EPzJFD9GkrX6tbiHElmFWZkCmVPCwxXueXlGWNbAuQqSLIwNNEYTDMu6oFq6Ya8p5Jhmti7rU4+Q0K2OLbudlNXQSV5t7A00YKj3Qfa3hPC/GmgcCeChq9RUHiYfoTOGfUvtjtf9hdCvGXLNT6i1P8y/jOWCcDARTAS1fOvBRqAh2piWpJdrxKg1hdJxWAN5hXsVqE3FdF
 7Y+UYHMI
 4NdKfLERRGs5JlE0ud3ljRM5flNN8xYcXfqL5T5FCv6NrKFmqpbMznVmsbiNXniIurxfk6gw7qql5PwNeSzlqHN5ZmwHnFkHAMhKhfiaC9FYrIehJdGW+M6P2J7D+ZNusQD+vmBes4bkuOOKWJO8VeDcZ56Zi4nBx+BkEXG7wEDTnoz5Pgg/nNYTO5UHB1/Myb62lORNH3I6skhCrd2V7CWxTdSnCWHqlzgQhb4kC2OhvLmuxDpLtL6bZBkcvnn+hRem16nYiNNNk+DVraLTFL5P1dJq6DA1v5q8gc7GE8iHkxZDZF3LLyHKzLWnhWxjhIxycb4PqU0v0/4I6wMp3gtuaWD/WefDsskEDZ3NPzZoTNfk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 13:07, Dev Jain wrote:
> 
> On 05/02/26 11:38 am, Vernon Yang wrote:
>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm) <david@kernel.org> wrote:
>>> [...]
>>>
>>> *cur_progress = max(_pte - pte + 1, HPAGE_PMD_NR);
>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>>
>>> ?
>>>
>>> It's still a bit nasty, though.
>>>
>>> Can't we just add one at the beginning of the loop and let the compiler
>>> optimize that? ;)
>> I'm also worried that the compiler can't optimize this since the body of
>> the loop is complex, as with Dev's opinion [1].
>>
>> [1] https://lore.kernel.org/linux-mm/7c4b5933-7bbd-4ad7-baef-830304a09485@arm.com
>>
>> If you have a strong recommendation for this, please let me know, Thanks!
> 
> I haven't explicitly checked with assembly, but I am fairly sure this won't get optimized.
> There are two cases where it could have been optimized:
> 
> 1) Had the compiler inlined hpage_collapse_scan_pmd

Yeah, there are two callers so that likely does not happen.

> 2) Had the compiler done something like
>     if (p) -> foo(), where foo() contains the complete for loop, with the increment
>     else -> bar(), where bar() contains the complete for loop, without the increment
> 
> Both of which are highly unlikely because of the complexity of the function.

Not sure if the compiler would be to optimize this out also in 
non-inlined cases. In any case, I wonder if this must be optimized at 
all ...

-- 
Cheers,

David

