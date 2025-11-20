Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11A2CF64BB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194966B0028; Thu, 20 Nov 2025 02:21:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C626B002A; Thu, 20 Nov 2025 02:21:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082626B002B; Thu, 20 Nov 2025 02:21:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC02B6B0028
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:21:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A33D213BA4A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:21:14 +0000 (UTC)
X-FDA: 84130139268.13.23171DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5BB9140004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:21:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nb6ActO4;
	spf=pass (imf26.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763623272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czJcuQ5Urf4DvTYKbPcWrAcA0kCkCZn4V2PGpIonnik=;
	b=G+Qk+fLhi8ha3qMCBFTFvzy838oxP2TRkJqEh5iYoRIImZijLSFVEIujzcW8118L0OhqUF
	9V/+fXVm8K/y68GJB02OXaRi0NGVvekTA5crqQ6NP5p/iFYlF9CCBYlmTZaXgv4UVvM3e+
	0a3EAfMnm6otuC3A8r5noUoP7WlN1cc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763623272; a=rsa-sha256;
	cv=none;
	b=CPiJk3aT68Rtyq8Zn+L69FPK+N4cBJbBSx7eZ1DhN6Fyi7AgKE2k+Exp5wWsIyzSXUNiG4
	Xse4FSCrCKvVcrt0YH3WPYZe9Zk7d3Y/BnJtK6QrTGKic03BElljcL0BXc+7cKhCYsLKYV
	BIoc13fvQxMG9sffgfIrJWZ4+7iChkc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nb6ActO4;
	spf=pass (imf26.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37259600C4;
	Thu, 20 Nov 2025 07:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED68C4CEF1;
	Thu, 20 Nov 2025 07:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763623271;
	bh=Q9x7pfr68ABlQkeGDOQXfTv4u0y1Q9ao0HbtlLeZBks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nb6ActO4kn5WR22MgZjBWnEhix29+SAXSkzvBaTiYlthZrhPeDL2UyotiI4/dFl3G
	 CifRWjVgR+IJPR1LDUCi/XQzpU3AP2TnzTk7P0jgZwbG7vNm8sQquNWtMFl+/om2Tb
	 LxYHzl8vQQELTJQb7NnXh80mV/vTTRhBUBxXHc7+lcavP0TtPpsXyKrQtj3bBODjAx
	 +HgdU2zRDeqKOoI5hiFt9a9mKAt9tZ58Lp83ZEibBiIP16VJNgbSspvaUazIqEQESj
	 87GBtLVfJZnjF+CR/0M18mx8sy7KXThc3JEI/6owWCwr6ZgohZQpRMi9pI15uksJ2M
	 NQSikIjacL0WA==
Message-ID: <c503061b-00cc-4d04-8380-3a0fe0a2c788@kernel.org>
Date: Thu, 20 Nov 2025 08:21:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, rdunlap@infradead.org,
 corbet@lwn.net, david@redhat.com, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-26-eugen.hristev@linaro.org>
 <e73bdb23-c27b-4a18-b7e3-942f2d40b726@kernel.org>
 <060e7412-8f1f-4d31-af39-79213c560e85@linaro.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <060e7412-8f1f-4d31-af39-79213c560e85@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4kfgcspqz64fx3rmqpoxmnsp33ue8iqn
X-Rspam-User: 
X-Rspamd-Queue-Id: E5BB9140004
X-Rspamd-Server: rspam01
X-HE-Tag: 1763623272-579455
X-HE-Meta: U2FsdGVkX1+7PEheBFAuSVPfPzPXGjXXo26dVdeJFeOhR+iNb9UdaHfzjCXfrAEfaLbVX8mlbUt+MHr7xTzYjxcYqs8d8h5+YJ91g9drqMZGAGDv6XD0pjVp8jLKSOwejgSC2M2K2ixFrFtGJSG19MjJG0wqjVSTu3dfBk6aAzbGzTj2T6GJ+Zy/BYrw1U8dcN+cvS7yMk+XNG2RZNU82x7WWKKivTk2Mn0GlhVXA1BCN9EtA2aUhQC/1SDGv4EVF4Lqr/O4w0Gz7wPaQQ8hWgSxFXJLViZc3IH45WTF6kNu3L83eLy60Z1Fgfxn54FBo2AcnNnPmn2lQNYSssvpTd/hFGIAKAz1SL9nzW76taHt78LUeWNWWTgRVcY3WggAaXLraBmOx3OlV+e3fRj6Ddi7i3OfAb44jtPjOlf7oSFwIGu39vAa4VrPlRf6Ew33dABySDNm5k6MMls03uTW05vdvJAnos8LkU7FCDktXus2MciyGLcmoIRYUFaWDhW7s/rFnkgX63c2rdgQn9zxEAeSQRmWDbSi/X2kWj2cAe8+1/M6esiRqsmwJtquTs6uIweDpqC1wsyRtchJ7dqgG+qgW/mdob8DwtTPokgT5qX/Kgcc0+GzBy+qzJx6vYvxClgsQAB8jfjxCdHQdZswiHkMHRwQs6KLfqWR4fOxeE9XoTd9AgG+UZ0WOmviT44pzsSY4lHYiQzzEwi0Pj3iDvE7+ORa9T1u3ruNQbzSbeN38EweUw7cmzAanq/mt1cDU3gexY7nO8cSoN5kBOcH5QKUIUYcdX3KnO7ZjeP1mi0wYqsBE0msXsm158Ilt8w5xYOTasG+77u/WrHy6j4ka/NyR/Zy4E7rsGJgBVx9ql15Y/RhsyheHvzg25Rr/qheOalOBMmkgFHPZzoIxDxcV8kJvJQQT0C3AEdXEaXTm/GvIJiUY06X7EJ5LvS5VunXxHttW6dAVD1voh3tPpj
 L+ZU9Hsa
 MIIAtRssybUJWgAfCN5TSfHHRz4eHZLrF0d2+CwxoHROcb60RAg87/uBmHevCsTvU9TJP3OQdl4XV2tEyLvNbuHkMrIc9m2BAjA+FyJtXgsyXpiVT+zP1WEL2m786upr+UV0St2KMeL4CPdvRpWqBEw1zRdyf5JRspmgOytzr9M3ObLId5YO11cL7NzAldZfSjww1L60k8Ja62RC7UCk2Gf8oyzN32nd+X4JE2aVnwp7Lf7BdH59zj6JLTGkMVPbzPhfaiX8jEfkE0tV4BCuOcpDFzOsM3R1CO9aLy2022Z01xcRquNm08uW/5FmTVosDT2zoD671QhUKeyrhJPjs2ZQ1JmijJCL/aLqCHcMfv+F9Vqoi74sLAlrK+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/11/2025 17:19, Eugen Hristev wrote:
> 
> 
> On 11/19/25 18:02, Krzysztof Kozlowski wrote:
>> On 19/11/2025 16:44, Eugen Hristev wrote:
>>> Add documentation for Google Kinfo Pixel reserved memory area.
>>
>> Above and commit msg describe something completely else than binding. In
>> the binding you described kinfo Linux driver, above you suggest this is
>> some sort of reserved memory.
>>
>>>
>>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>>> ---
>>>  .../reserved-memory/google,kinfo.yaml         | 49 +++++++++++++++++++
>>>  MAINTAINERS                                   |  5 ++
>>>  2 files changed, 54 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
>>> new file mode 100644
>>> index 000000000000..12d0b2815c02
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
>>> @@ -0,0 +1,49 @@
>>> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/reserved-memory/google,kinfo.yaml#
>>
>> Filename based on the compatible.
>>
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Google Pixel Kinfo reserved memory
>>> +
>>> +maintainers:
>>> +  - Eugen Hristev <eugen.hristev@linaro.org>
>>> +
>>> +description:
>>> +  This binding describes the Google Pixel Kinfo reserved memory, a region
>>
>> Don't use "This binding", but please describe here hardware.
>>
>>> +  of reserved-memory used to store data for firmware/bootloader on the Pixel
>>> +  platform. The data stored is debugging information on the running kernel.
>>> +
>>> +properties:
>>> +  compatible:
>>> +    items:
>>> +      - const: google,kinfo
>>> +
>>> +  memory-region:
>>> +    maxItems: 1
>>> +    description: Reference to the reserved-memory for the data
>>
>> This does not match description. Unfortunately it looks like you added a
>> node just to instantiate Linux driver and this is not allowed.
>>
>> If this was some special reserved memory region, then it would be part
>> of reserved memory bindings - see reserved-memory directory.
> 
> I sent this patch for reserved-memory directory, where all the
> reserved-memory bindings reside. Or maybe I do not understand your
> comment ?>

There is no ref to reserved memory here. Please look first how reserved
memory bindings are written,

>> Compatible suggests that it is purely Linux driver, so another hint.
> 
> This reserved memory area is used by both Linux and firmware. Linux
> stores some information into this reserved memory to be used by the
> firmware/bootloader in some specific scenarios (e.g. crash or recovery
> situations)
> As the firmware reserves this memory for this specific purpose, it is
> natural to inform Linux that the memory should not be used by another
> purpose, but by the purpose it was reserved for.

But you did not write bindings for it. You wrote bindings for Linux
device driver, I already explained that last time.

> Which would be the best way to have Linux understand where is this
> memory area so it could be handled?


> 
> 
>>
>> Looks like this is a SoC specific thing, so maybe this should be folded
>> in some of the soc drivers.
>>
> Not really soc specific. Any soc who implements this at firmware level
> can use it. The firmware can reserve some memory for this specific
> purpose and then pass it to Linux, so Linux can fill it up.
> It just happens that the Pixel phone has this implemented right now, but
> it is not constrained to Pixel only.
> 
> Instantiating this driver with a call like platform_device_register_data
> would make the driver unaware of where exactly the firmware looks for
> the data. This is right now passed through the DT node. Do you have a
> better suggestion on how to pass it ?

I do not see how this question is relevant here. I don't care how you
pass it to the driver, because we discuss bindings. You created bindings
for Linux driver and that's a no. If you wanted that, I suggests that it
could be instantiated by some other driver, but sure - we don't have to
go that way, that was just an idea how to solve the problem bindings
like this cannot be accepted.

Best regards,
Krzysztof

