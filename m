Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BC3FA374F
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 15:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4012C6B0088; Fri,  2 Jan 2026 10:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF5E6B0089; Fri,  2 Jan 2026 10:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB1D6B008A; Fri,  2 Jan 2026 10:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 15DC86B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 10:31:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A740E8BAD4
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:31:14 +0000 (UTC)
X-FDA: 84287412468.13.0B2E5E3
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E52A4000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:31:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fs6ry2E4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767367872; a=rsa-sha256;
	cv=none;
	b=btYbXPg6Qn8d8CHhHjGAoaqSsTqME0nOiRTO5eDF0jlUmMY6NEgfaJs48hYV6tLkVJPLhS
	ubkIWE5dsPlwPILgxwvEpXQp9/+DuE8YsHQIatEkZXdlkubQ/S0ngg7pbUPurrrPirs0/P
	MXa0MtJZd8KjPYPq+wD+w/pbFmJZyH4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fs6ry2E4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767367872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4uNqY5r0cWL7e4gE2mSIbtSpXgssK+f0V6w+g1HxwU=;
	b=M7/uadjkvNUm0yUCIiKecZPCwTq8lAEy63JhDWJ80zWfwmS4y4rrMet6axvyleDO7Z960n
	VYrlUt249k3p8jpgPGBsCpt8JsP83xddZPbEKt3cLwzsnTb6sxvYoKomSLPHfsz2i5iY1w
	qXviiyP1DOJjkz+qQ0Le0lzkDZKp1zo=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so94949495e9.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 07:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767367871; x=1767972671; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w4uNqY5r0cWL7e4gE2mSIbtSpXgssK+f0V6w+g1HxwU=;
        b=fs6ry2E43QG3dtbOw89SbHsuKSDSwWxhnQO+mEfqRSZKZhadKc41oCWJbS1ZvfLJ1Z
         VCg8NDnAobeqAdEeawXsEyQTutk7VqBB4LT6ug6GAN89xhVrduVpQ2bDIZ+NVo5CrDxv
         RHqAVtc/bKYn7qwokkzJdNGFSb808Mm2A654idj0zW3jj6lYVSjq8kT402v5mJ06x2kO
         urxpuOiG0SV2AIw1xd5hmrNmTuaxRr7dKmABr9OhxvXmwIW5Pmob6KqZ4b9qpnKqzb0C
         aD8GhkTqMSOnBPfZHZLKjcft+yei6Tw9u+loaM2h1aoNSPr8Oyj15grQNhLX/u9nYa9d
         Zwzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767367871; x=1767972671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4uNqY5r0cWL7e4gE2mSIbtSpXgssK+f0V6w+g1HxwU=;
        b=Guc0sWA5aeyieK9qxkdsrmBTocP/8UMkeIqClYsBAK2OhTVl6HbPQgDPFTJoN7Didg
         0e0H8eoFIIddZc+Tx7IY6g4GPK9KuSvqyk3agSwizcqnYqV0kRKscevbIQ4yCPWZxk9G
         kcludW1PkmM/lY2HSiWTaRRMSutiQhV83W1FGTcWd0xWlnu4ar8578JQgZja+VvqUvIn
         UCYh3y4rInhjhwHWXaku2GzqTIIPPmEqJCOVEHDwUxWNzjEP92dzl6sJ05jftt9IeOu7
         HFSeMJCQINox3GvUywvXbaS9GtrB7tn1fFCZtwZhdL6QwrUumRC0a6MjvYfZjEXd0iec
         NkxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGaLmS7NWBtbCmq6uaCJpTD3USsvuGf2mAYLeOEsGTv2am/DzWk/voDodp3UmVAMCGWvRYbvGxJQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1e8khLWkP+hyYJswQPdtBPovv9CurUD/ZcLta+C/Yz69kOkCG
	ElWIiSBhtxj3yyCxDGY8nfcbJypLzAjVmV2577q21mxLQIZAhqC/Kb9o
X-Gm-Gg: AY/fxX7NjtpJ1aeqpalgphZW/IdGPeoCvVtd7c6HI5GFlhlMLebPjNYbbmjZvzkUluu
	f52KIqlqMIbdAfAyeZhDHWYXzD7dLQ6zvFJjUlv+6STPL+sMrTC1Gw60yrkSD3KgrFTxeXRfWBd
	61T9LbVlQty7PVvchDt+KREE1SpIcY1p9IVPfbNqM4soBs09vgM2at3769nDkryAlvansmAIBEn
	VK7radMKtB1WAINAaVLX8uBgdM22bP7gZ11Tctdvi1iLbszl/8+/40ARoVpgN6ikyhuTSpMjAPL
	fuFviqn8crGxGyyJZ/YykW42kJsoPhFR9EFcJcYqNRdlEsrbOxYNRmvumfIpY85ybfefhJ/y1nI
	RmcS7LzCoPe5EYticjW+4ob/D+vpiNo8ksKLe6XfIPQFkxHUarrCZsuRwnx29AkwSAVSMXYqV8t
	5WzLdmAbksaz/pPYKFG6DaEuO55gtNf+0hRNRKyYcopVONX7LxvoCAeFJ8VclP3pZ/OOe6G4/ZI
	oEiYAsowRLI
X-Google-Smtp-Source: AGHT+IHBT9YlOVOXNiWvFipggdEYaegBM5I94nBU4m8bda8nrXYoAOcEMlAFzjbdkmpGlrMqkrvPEg==
X-Received: by 2002:a05:600c:3146:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-47d1959f776mr535335675e9.32.1767367870730;
        Fri, 02 Jan 2026 07:31:10 -0800 (PST)
Received: from ?IPV6:2001:16a2:c8d2:2b00:183a:1350:d3a4:d89? ([2001:16a2:c8d2:2b00:183a:1350:d3a4:d89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6ba40a50sm919985e9.7.2026.01.02.07.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 07:31:10 -0800 (PST)
Message-ID: <2bed4bbf-256a-4918-be53-1d4c6999a46b@gmail.com>
Date: Fri, 2 Jan 2026 18:31:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] kexec: history: track kexec boot counter
Content-Language: en-GB
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, rmikey@meta.com, clm@fb.com,
 riel@surriel.com, kernel-team@meta.com
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
 <fc542a5e-db54-4d7e-b363-42cc253b1a8c@gmail.com>
 <rsygqnm3qahkfoqo6usrz3jhpya3c3rqebz6rotl33dsx3rsbo@2v4yeabi7fda>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <rsygqnm3qahkfoqo6usrz3jhpya3c3rqebz6rotl33dsx3rsbo@2v4yeabi7fda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E52A4000E
X-Stat-Signature: spre36rfiqde1ti7ju5sir8o855nzdsn
X-Rspam-User: 
X-HE-Tag: 1767367872-83844
X-HE-Meta: U2FsdGVkX1/i5iWstXl6ilqp6ZJc1SuHTikVjpIysjRB/g5Pjus/1sV0/XmQrykWnbFqJwn40nhjSpmUyrhsxRhdrTmumMnj9PIQiUGxkBur/kh56J0tsGDB1bm0rGqYHctuE6fj49RFZ+rOSCXNUExroBl1IZYTJyDW4b/YCFz+4Y23o4V4f7cT5tGKS346++Eomduk5Srh7AAremqveKIBf1+rphG7fWg7yDGZiaACxZ9A2uvFp2V4AFOl7HvyAlohInTNY2SGlabxuUkFGoijmqQeYonLHvWgX8K3qg7qQmXpLMMpLTWj6G/DI42XzWRKsmfiVvQMcRefONC/W9opqIPB8Q0bXkkIjJOWCLAXECf1XR5WDBqXa9nc1836PNoLz64bpFNHikAKR21kvXYaAM0TFq0WTnLdlD3HtF1TcxoXvWVAV/lpm5gi9psbYWytlMZGEPPOmplPKVOQPMzM4jotlvOM/L2cBODjNI+tHCKl9Y+Yeaca3PuX4ubrVGOkbWq/ngUaLzEfTi1sWR2ohy+yk66+vKoahlKZUrDOs/EK2TG/QCO34VX1iHkYM4NoyB/3saQ/TRlWqM3HBsFoyHpnxG9dBRJCEukamkASV1PDXwgoNLPINaHJOlFB1llPXDzbN+9UapCNnkwuijo1tQpcwU2Hlkpp9HU2d4ILysbpQH9cYY/m7sgmNspTuPB10St0MYbqJ1OOZqslLkR5UpEfjqG59s7SgEkvLCz+5zUmmYjuYGCw96hEJyFS5VQ5rLcD6S962unPvQQa+yBWj1pKp1rRtLXkaepEmV+4z8H8cNr5fahA/5maq2MzJRhU9X/oIq4w0b+VYCgLvW9PmJnb+341rgASLnQyhCVF7HCTY3RF+LMImqaMoeo1B68hTNW9DV2X/NytmEis8TgfVUXFB3rbbqigvsF6GJkZ7GIgXzk8JNHLN5EM87oNLOv+bAP4B1GOOTFYDaV
 Ae9mDCZz
 8Kp/591acJyHTbbBnPLKt03WRz6uDtkgd/lWFrico+MxXVPfF2WLL3DpNqtPL1aWzf0jZ39FJq1uHUTgpjyUDOCdrmwaT++6JoSyUgasgtpldYJohaxgPmXI6dHVq58wN+/fjjshIcfsRroW866FMXC/BTuose7LUNpVeMQFeeXtFGpsUl6mVYojHrgHy8hY+nTDIF3lyVuqx3fWIQtAXNKdKTxSigfiB7+M9VF/y4kor52lMZghsUMb3ZlwjXv2NU2wuPj0xeA7A/K2ErifAXNm7/QS5RsUrp41K6ULzqamhHW6dfop9Xbm/6D3y5ZBrL8fm5+GT71g2I2FZB/tPAWkYD+wjHat4GI1b+ieC0OiFw/UrYKGq6VuXZ4IhgWQIOb4eWjTEPLtEGWV2i87BRYqg25E9eYo7FO9RD7AdVKdmT0qw/lxNAMwwvvKIPOrd7EmmhWYZ0vyBhJ2DKGuE4vdN12+oLoVldD2balqiZlgH7D3VMaJYA9JIoQp4RebN3QilMlzypHYI5Wa5F7CtDnH/1oMmQya4SWzGmoyzw+SpdMHwGM1DUbwu3S0AjeLRDBfCPCQjg0g+fDOoqYLmtUeTEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/01/2026 18:24, Breno Leitao wrote:
> Hello Usama,
> 
> On Fri, Jan 02, 2026 at 06:09:57PM +0300, Usama Arif wrote:
>>
>> On 02/01/2026 17:53, Breno Leitao wrote:
>>> Track and display the number of kexec boots since the last cold reboot
>>> when CONFIG_KEXEC_HISTORY is enabled.
>>>
>>> This extends the previous kernel release tracking feature by adding
>>> a counter that increments with each kexec boot. The counter provides
>>> visibility into the kexec chain depth, which is useful for understanding
>>> boot history in production environments.
>>>
>>> Add a new property, "kexec-count" in KHO FDT alongside the existing
>>> "previous-release" property. The counter is:
>>>
>>>  - Initialized to 0 when kho_in is instantiated.
>>>  - Incremented by 1 on each subsequent kexec.
>>>  - Printed alongside the previous kernel release version.
>>>
>>> The counter is stored as a 32-bit unsigned integer in FDT format and is
>>> only active when CONFIG_KEXEC_HISTORY is enabled.
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>>> ---
>>>  kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++++++++--
>>>  1 file changed, 23 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>>> index 06d99627bb3c..fe5a2c5c4c86 100644
>>> --- a/kernel/liveupdate/kexec_handover.c
>>> +++ b/kernel/liveupdate/kexec_handover.c
>>> @@ -38,6 +38,7 @@
>>>  #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
>>>  #define PROP_SUB_FDT "fdt"
>>>  #define PROP_PREVIOUS_RELEASE "previous-release"
>>> +#define PROP_KEXEC_COUNT "kexec-count"
>>>  
>>>  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>>>  
>>> @@ -1257,6 +1258,7 @@ struct kho_in {
>>>  	phys_addr_t scratch_phys;
>>>  #ifdef CONFIG_KEXEC_HISTORY
>>>  	char previous_release[__NEW_UTS_LEN + 1];
>>> +	u32 kexec_count;
>>>  #endif
>>>  	struct kho_debugfs dbg;
>>>  };
>>> @@ -1330,6 +1332,9 @@ static __init int kho_out_fdt_setup(void)
>>>  	void *root = kho_out.fdt;
>>>  	u64 empty_mem_map = 0;
>>>  	int err;
>>> +#ifdef CONFIG_KEXEC_HISTORY
>>> +	u32 kexec_count;
>>> +#endif
>>>  
>>>  	err = fdt_create(root, PAGE_SIZE);
>>>  	err |= fdt_finish_reservemap(root);
>>> @@ -1340,6 +1345,10 @@ static __init int kho_out_fdt_setup(void)
>>>  #ifdef CONFIG_KEXEC_HISTORY
>>>  	err |= fdt_property_string(root, PROP_PREVIOUS_RELEASE,
>>>  				   init_uts_ns.name.release);
>>> +	/* kho_in.kexec_count is set to 0 on cold boot */
>>> +	kexec_count = cpu_to_fdt32(kho_in.kexec_count + 1);
>>
>> Should this be kexec_count = cpu_to_fdt32(kho_in.kexec_count) + 1; ?
> 
> I don't think so. Basically we want to increment the counter in native
> endianess and then convert to the Big Endian (FDT/DT are big endian
> AFAIK) and then store (line below) to the DT.
> 
> If we convert to big endian and then sum 1, it will mess with the
> result. 

ack, Thanks for explaining, I didnt think of endianess!

> 
>> +    err |= fdt_property(root, PROP_KEXEC_COUNT, &kexec_count,
>>> +                sizeof(kexec_count));
> 
> Thanks for the review,
> --breno


