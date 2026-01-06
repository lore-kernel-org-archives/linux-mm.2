Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631D0CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64DC6B008A; Tue,  6 Jan 2026 13:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C8A6B0092; Tue,  6 Jan 2026 13:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49936B0093; Tue,  6 Jan 2026 13:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A553F6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:48:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A9DEC2B23
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:48:04 +0000 (UTC)
X-FDA: 84302423688.07.66C2FDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62673120011
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:48:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBZfi93e;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GrnLq8hdyVOF3w1aHshNG4tM1TjxxmghCj5zoNifMI=;
	b=g9v6i1WrOeUq48C/dslHpdMOa/VTlkLlutW2nXf3OdkdOWexD/0iPo9FoGPLj7s4I8XDeJ
	SFWPEpwFruJm2UypdQ4q3cF3Z0vv0rVQQJKKZ2TbUU/bSBhZuF0t7PimfGmn6h9Y6tv1gc
	7LwHOWKA7e19X+6JnrRcIoBCqiLmIVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767725282; a=rsa-sha256;
	cv=none;
	b=IM0bkHdDqeQKzGlIIjI7TWWJntsCvmqrTeeQwAqmztise+AK4JXC+bzoIGrEo9J2GZmtwg
	QhXmrSbVMEwfav/kWNnOeuDHX9foWzkSB1nEuG+e7CKvtukQxRWrWv5QnIUBN1Q4K5B3bS
	TdGgER677AmW9dRPtW0f9MZuxuL49/U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBZfi93e;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FE7843E6E;
	Tue,  6 Jan 2026 18:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45F2C116C6;
	Tue,  6 Jan 2026 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767725281;
	bh=1xLw4PGhhepqTmOWiFNHJxsYbSya5iTaPTtK335HWco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RBZfi93e3zJ4ckLzdlnY6RSFqBPL9eEv6o1YyJsTO8y2D4QGjEjb1xlwH+XkscKhk
	 fe1hZSD5vXy07mB4Gr+M/VK+62cxLv/RRvZsQw4XNvkyhkncKUGIibXhSCymMaS9pG
	 wSe8NvtdO7Xu3HElPpcn+YYBLD2uKhEnUI/BSMvBVLU8soi3YenhfYL+12pt/GnW4m
	 9VjtQ1ob8nNLXvtRLmXIW4cdSIyKPy/nMFJ3ouO5ad0+tURt5dzckgb0JQFtHykPA9
	 tWjWrP9KMxHd1JEGZ84hzWthw8m1uW5ukUGlmuPlEyukNifl4vvq5dKQ7FOpemOIad
	 G9/QFNMAG2feA==
Message-ID: <6e17dab8-cc85-4d68-a7b0-c187754572df@kernel.org>
Date: Tue, 6 Jan 2026 19:47:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 5.15.y 0/2] Fix bad pmd due to race between
 change_prot_numa() and THP migration
To: Harry Yoo <harry.yoo@oracle.com>
Cc: stable@vger.kernel.org, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com,
 kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de,
 ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com
References: <20260106115036.86042-1-harry.yoo@oracle.com>
 <3c1000ae-6c4b-4b03-a458-e74edf64db8f@kernel.org> <aV0ixeDusgafhonV@hyeyoo>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aV0ixeDusgafhonV@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fb5ynugwq3tssmpjy7hey41kniigy6iy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62673120011
X-Rspam-User: 
X-HE-Tag: 1767725282-715368
X-HE-Meta: U2FsdGVkX18r+3Umyqz0tXMMzTJSIHdCTLL8jAYbaDmF/vPRIFhzsXKp9bXjwhieQycO4fRW5G5G4b/D25iBo8R+8uoZL4IvXechbAifRG4JWoJyYLSPBg8hFWEQ8L6hOlKlTWRqTF/hlh7drPtuVt65+U4itMWkRzal0btIMpo6RtcsB+BuzuEsvV3Nfr4Y74F0zDuicU2r4gWvXIm7HeI8/fxsFxmqV0afy5KiFl1v08PfzvljM5os6hQ679H2UkCPz1Hj5zN5xU/WhqHjT77pMwwn9mfIOzyFm2+m07JTnrXQV69KqsxEUi26m++lV3iZoSQlq71f1AqnxBBh1rEbZXF0KzIKtcJDMqKNoUy+2R5/Lbej7mINKNfr8kppPk67dmS983NhuUu3nSMtuR9aaU8rPdp7mmODE8Nb+dHF7Mo23ivlNLUSmIF9OCXpsAHJ98PLNxsIG9c81vzTlug+1nSh9rUXRYv/hooPqq9eIocAlH1jWFDIBlOV62CuZ1hnumNxqH7yevIiA4CtFY6iekOTAiACU1P+T7HYd6YSb8Tr6EPrOMkjq8yxLTJ0jSSzmKYz+SmeFCo9TW1R73E0gcDqn3xJq0cJEkmCGeGwA+fccTJsPPqSmtboP9BI9fLzBOMgc7GvcreWX7vmazdSB8I32QcZOjWJ7+Cj7FcdCEd36YvvTuSgFUi01nl4TtPoglv/BUdJqcmpY5aZe2fkb3K3fJG2ioF1PXf0qPfe+4BKPNbwAyEBLKiNTawecTHkgbG5t6YYzyKjRWhYzlnB2rPjGeY1fL2UzlbJkywwUgGadPQQPWTbQQXMYscoueG3418a5Bvfgq/oAG7vjYLkGC0tBq7ZUgLFrr25MIKFyN/n/MPOjwtI6b0zuzKqRHgiRTXz/pRb6tGVDT+WJkh+z6V+luCzF1bjrR7lDRathGTPzbLUpznv4OVR0ZdTK4ErHMSJ4Qfkr1EGq/O
 gLm5Hz/I
 jA1fbpIq2b3Vf2HHms/1/OLzx7ncTKUuXo0eYRsxdv4Lo5huMwkPxxRcAe5yjwM/93K4Acp5OHgFmPp//MRKFKgSF0YUUKzKUtr9EMiaRdFNm+c2hAbZ9SJFbqR6uNIV4p/EnprZYIwCcb8bXAt4cwrFj9lLMJFOnpiBmVccPQca8YJQ5OItJtEg6pAFMQ8oHwpO1xOPxkGphX7GYxuAL7lUd/dOQ/Know9j/rllAaG2G3gkBNTYkeGzIEbWF0tNDTP024ir4gK36Q50iQIjYeiqjh/iaoJHsymdw3tDXj9ZrCegTB9Id7dfvtNNLQrSwr/557PujfjiEs1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 15:57, Harry Yoo wrote:
> On Tue, Jan 06, 2026 at 03:35:32PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 12:50, Harry Yoo wrote:
>>> V1 -> V2:
>>>     - Because `pmd_val` variable broke ppc builds due to its name,
>>>       renamed it to `_pmd`. see [1].
>>>       [1] https://lore.kernel.org/stable/aS7lPZPYuChOTdXU@hyeyoo
>>>
>>
>> Ouch.
> 
> Haha, it was really unexpected :)
> 
>>>     - Added David Hildenbrand's Acked-by [2], thanks a lot!
>>>       [2] https://lore.kernel.org/linux-mm/ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org/
>>
>> LGTM
> 
> Thanks!
> 
> Perhaps I should have clarified if your Acked-by:
> applies only to 6.1.y or ealier versions as well (5.15.y, 5.10.y, 5.4.y).
> 
> What do you think?
> (planning to send 5.10.y and 5.4.y versions tomorrow)

I don't expect there to be a lot of difference, so feel free to slap 
them on all, and I'll briefly scan the patches when you send them around.

-- 
Cheers

David

