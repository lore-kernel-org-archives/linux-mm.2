Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC1AC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 11:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3DF6B0092; Mon,  4 Aug 2025 07:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BE66B0093; Mon,  4 Aug 2025 07:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1A16B0095; Mon,  4 Aug 2025 07:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F11EF6B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:06:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4266C12F6
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:06:17 +0000 (UTC)
X-FDA: 83738795994.11.B7362AB
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8B0F41C000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:06:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=x3FfH9aa;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.68 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754305575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbCL33p6FgXvGTA+R2ME1gzKoUWjtIJjxxkRY3HfTrM=;
	b=Px7gzgzaPaB7/cjPG6gXNnRzAq+cqG4Tqz+6UVLJyZ6cHvCKn37BjDx4CcCsRYapLMu3Ez
	AA/CeMZp8wuuU5yZ5PkVlawoWdmIXr4nGanb+Gs1S/8lzVxZd1mD88Nhs55J4eoOC+OJVx
	Jqg6K5K0esTdH6QpvIf8AARhZshQgjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754305575; a=rsa-sha256;
	cv=none;
	b=cqbQPwi0KiIc80xh1fnZuHfIyywJ53yQwx99yLDmPBwyOUAmMkS3AxwZ9jzO5Y9KfxdTPD
	jPShFbiWNnYUDGBIeyE5s0wY4gU/b48ZAAFC4mi/w2MyW7iX/zam22NPwlVf+fuqqhsc14
	6srnwCONM/tImUMSf2lB1aZkpYzImFw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=x3FfH9aa;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.68 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-61589705b08so9268064a12.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 04:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754305574; x=1754910374; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AbCL33p6FgXvGTA+R2ME1gzKoUWjtIJjxxkRY3HfTrM=;
        b=x3FfH9aa4i2lJqSL0bcCc1OFv/EGoLLhOuk3ClhXy15+wqibu2tqEmT/lwE2Sx4kn2
         86c14SAWVEhwBPfjt2Ipxg1ZBjhOMo/811AJqW9WRujwbWvuvEXimRR19wvnNFaRpUXF
         yylg9tgRSFw3gzkDdiyXzllxZVr8nuXDbHLgGzhLubMbO8mppvtloOmWl+vLOGPafsej
         PNhk1fY8XyHkxO1ofL4SKlI9lguqt7wjgMS4BvZUtg/Wuhm72KnLrplX5BSbf7cW4CVS
         rd9l3cFBudAFQvnf9OfaaHSa4//lg160Vu9aDVnwTlgKkey+OY8ndTVcv3A1GLftXO2G
         tBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754305574; x=1754910374;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AbCL33p6FgXvGTA+R2ME1gzKoUWjtIJjxxkRY3HfTrM=;
        b=Q5Uoa7L3ybhc9mHTAh2AwmZ5WCjrf4HvDA7irU16MJWc1cIXjhTpp8rd4czibhjcWm
         hUCVoVMARaMrHH75YQOMpBifLoyNZYeZOA6zBlvbFj2W3cOZ/cAjmugX9yPjX9G8q61g
         poF4c7uU3EwYtn3R9yJq9hNoImbgeDowr4pRrZvZQ2siylo38ffqvL4myEZUU0YL7FDx
         F1GTkjS/XaQj7XoOFfBjLvC161zw5oZz381t+Ij0t99xOp6Ua0VP4Ce0ZROHtAEleGa/
         Gc4UT1X5y2kl3E8hc7hypkl+Fxt4tJYdiIidk3Lew7rpSFBV2KY0WlWuymSW9cZZTUKF
         4TsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVECPD03PWGBilI1C695KQayY+LboIEuWWZR7TTRNLGZAmA+U3ci/0hS+MHz5x81/1pTfG26Tl2Tg==@kvack.org
X-Gm-Message-State: AOJu0YwUTB9KOrxNklTdksZwifOs98iSWyiEKxw6w3IF/yz3BHiFi7xR
	jAafQDXQ8/eQXomWF4mQSK3kz8f327KQyVzinDJrDODjrSjSs6DeYumD7CUG6N8pz+8=
X-Gm-Gg: ASbGncuEu6i0knCB1//WONAdOlb6TfAnn7V9aw2/H1E3C5Jm1GoqdZHTnK+GC6RZX+k
	DiZ6IVU4Ah/IK0WPKK5sqBPvLIUbZmp946P7CxphLc8umEXhP9w/DyTjiHMNZHFqBFC9I+moYyC
	yuvcjG5bxA8pSAEPm/iTKvQ7ctdBBR/iuOU2ZKiT8hskfUyPnpGUSTNBXIVmFOVmP32aviHLKjL
	2W/z9H1NinSfsi3HiAIBf4XPfNATetRvXpCC4uC/WT2sdE2kVGSFsMgq8b4CWaorqsnjLPNdseP
	u5ZUkex3zFm+C+bZ7AIU6UxNpPWAkM6Oc7AFo3ToH/ZCkSPZ+rwzsqlbm2Z4ltxZYBkXNUOGm2b
	a8KFyfGC+CIcCAqeePMIHuwb7f5uoKw==
X-Google-Smtp-Source: AGHT+IE4XPeXZCbPPTnUeGFh37dBHmQZ35wpgsW3hiGwLGtsXzKowOSWjqCke7T73Fj9hT1fEebjmg==
X-Received: by 2002:a17:907:3f2a:b0:ae3:8c9b:bd61 with SMTP id a640c23a62f3a-af93ffa2d63mr907152566b.12.1754305573593;
        Mon, 04 Aug 2025 04:06:13 -0700 (PDT)
Received: from [192.168.0.33] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a076409sm721053666b.12.2025.08.04.04.06.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 04:06:13 -0700 (PDT)
Message-ID: <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
Date: Mon, 4 Aug 2025 14:06:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <aJCRgXYIjbJ01RsK@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: juodi3gguxj13sisq8c9fymz45ddkbeg
X-Rspamd-Queue-Id: 8B0F41C000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754305575-803426
X-HE-Meta: U2FsdGVkX1/sa9s0VKejK+Ru0Kc2Ep0ojr3/5WsymPKotrWari6IbzBZLgb9xCR3Tuakp8Y2FR5o7+51FHu91+9PZPfSQyosDPUiA+PBrbFSxCFp3/um3HqTt0zpZC1QFwi8eMUa81we5pN2zPRiOW87Vzlobh4NRquNkG2fEjVPjhrU4t9ymdijyHm43TnBlVCOdjq1MqIjV2MGRmMyc2bKuMBNQ+jqkkKspdcruuNypG0JFY3KNcmBx91w5ReHtuDcxUZ3iKF1HHfFKSTu+M9rnsAo8gDuK2v9oIGSY/uApoZT+j1OiegUkNaycJrGDUGlJ1l0wAvJJh6B26Qjstx89mB6isPhN3+etfz6ua5CsiOzZ15w6B/xT3KpOoRO+CnaLmtIy4BriVPaxi/4yrEnhNelpOeZwxzB0f0QZXuuj4KefKIGqffHTFmciAVmYbSw9UJ4HWAJJo2/znHThhIDyxzU0HQk+mrNztnTT58T/42MQdv/SN1Nazhoc3B48clnQ4S4uXlmGFQJ/n62M8gRoKaikY608msBa1vMYJerWuL+mDc8tJw0pVQkXJrleRutUwe+IxxPdwHp3VOScdrIflpwFf+0i/Ezb+U3oijuL9WFndOpPdqdYWPud82POL4zfe3MNwRQl+Prww4FYZILwOcvpvl+/5XeZcwxf6PrYjzlN6QjZjiqvKKVjyt04fuf0NHcovQ6osztUTYo0t4fWkzn4gh3jw+H9BNxz9GFDNE0gzakTinbxvOiWWHMqkOc7whkBHjwKSJ54mHOO4yWWu4AmoaTDmhJJjegoAedFDRdgIZ52jSK6D6tGmNcIM2ppymzL+W/szQl3nKhKFcfmfIU+AoIHsl+swR4R4C2tUJ8hI7Ke/8BEjxbv36rZhIuyuRnU38A28beGGyvGv6NrK6sJZEe0ZZZbcni2cA5VKSScsym2E51pd0aZmaVbxbBBzClKusVuyEOqUD
 A9f5CoyG
 I9GzAFo80Go39G2x5tQmYZesKWMRNQqTbl7JR9jtqSlHsep8CJaeWichyEAgxyIVgThzjoXXXXOT5vWh2iiZZmvA6MDMaTJAl+ToHr0FXqgUaW3FUnYm5x9IgIailZgkW9/y6p/T1QiiYomLHTx3pSdBaJYig5mBOR6WoB3Nj+rn9kmcrW6VXaRCGluob7lCYG+yAV33CwgRiUKr0sXZCBNQar10uNTOggVU1elE1GCdq2+erPK8Eo4L4VpFFqf8PVJhwkSm+teQC+ZJOHpqwTVkxonGAH7AG4LRZUM03yx3kBAOUTgYRKeRhrOrhvMP2qcNneV7ZeY7cSvPOaoMq2rVpKNojQkCJAO7gzgKqcbUoETNqD2yuLEF4LVjkanQGM8T2i9Ns863BRo0FQxpAlOIBabmtsB6rzLWv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/25 13:54, Michal Hocko wrote:
> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>> On 30.07.25 15:57, Eugen Hristev wrote:
> [...]
>>> Yes, registering after is also an option. Initially this is how I
>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>> here:
>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>> Do you think we can continue that discussion , or maybe start it here ?
>>
>> Yeah, I don't like that, but I can see how we ended up here.
>>
>> I also don't quite like the idea that we must encode here what to include in
>> a dump and what not ...
>>
>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>> where we e.g., have
>>
>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>
>> Could we similar have some place where we construct what to dump similarly,
>> just not using the current values, but the memory ranges?
> 
> All those symbols are part of kallsyms, right? Can we just use kallsyms
> infrastructure and a list of symbols to get what we need from there?
> 
> In other words the list of symbols to be completely external to the code
> that is defining them?

Some static symbols are indeed part of kallsyms. But some symbols are
not exported, for example patch 20/29, where printk related symbols are
not to be exported. Another example is with static variables, like in
patch 17/29 , not exported as symbols, but required for the dump.
Dynamic memory regions are not have to also be considered, have a look
for example at patch 23/29 , where dynamically allocated memory needs to
be registered.

Do you think that I should move all kallsyms related symbols annotation
into a separate place and keep it for the static/dynamic regions in place ?

Thanks for looking into my patch,
Eugen

