Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF38CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC00B8E0013; Fri, 10 Oct 2025 04:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70258E0002; Fri, 10 Oct 2025 04:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37A58E0013; Fri, 10 Oct 2025 04:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6DE8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:16:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35818855C9
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:16:13 +0000 (UTC)
X-FDA: 83981497026.20.5FA65D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id A8600C0006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:16:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zrrrj04U;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760084170; a=rsa-sha256;
	cv=none;
	b=j9DtOSDrMFz8lz6ZytlL2yUvbFRXjk2ADqDkwkxYvc/j9uuf8YHpAySw2/SO2cmhnKSTMx
	WoD5jMxdh+m5ODYfXLxU0tVOfH3mGO0VOrft+qj2BwltTo/UjaFiQ17oFQ+PLQlKH0pj/R
	gWvKwtK7yv0Ija2qzGlbYb1ejZX9zfc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zrrrj04U;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760084170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53xZ5SArHYuTCDROMaQ5xZHxK4BghnPi+QrjXe7ILDQ=;
	b=b11AIrsUeL2S1+WUivoGgvBhbXbfJNIzIkAzZuvZKY/uowD0YulDipOvtinryRoZ5y8wii
	W9wtjJnl5GI8u3S4OG7NUwVkx+onaEU+k+TckXPPeGlP7gBCdCf7WRP6r18XHr8g+OxJZi
	VuH0tdMhrSZlKFnP2uBXebdv9zoS8TM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760084170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=53xZ5SArHYuTCDROMaQ5xZHxK4BghnPi+QrjXe7ILDQ=;
	b=Zrrrj04UjofKFol4zE3LasFSOPxGOldrEt9fbCbAjmMMq1PunsR6oT5TqI8tMTsDX5TfNs
	L+mFlYAZEJmHCvlu3qpSRQpKWPLnEVLanygSXXITXVz+2DdRGwz6tEPjZbUUYRfOcuJ9o6
	1S2QhupKOB+Lvptg9far4NX0vpASFfg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-RiyJS4NxMOeDuDyEV0jmMA-1; Fri, 10 Oct 2025 04:16:08 -0400
X-MC-Unique: RiyJS4NxMOeDuDyEV0jmMA-1
X-Mimecast-MFC-AGG-ID: RiyJS4NxMOeDuDyEV0jmMA_1760084167
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ef9218daf5so1652560f8f.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:16:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760084167; x=1760688967;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=53xZ5SArHYuTCDROMaQ5xZHxK4BghnPi+QrjXe7ILDQ=;
        b=NGz5THWsnd/JIbQFAq7kpIZaOepCu+10eJ0p30V3EZhVjb+R0kTwouxrMWKhdnFc+l
         HZ7TF+2RPoRdK+02g3hvOAtY9AGAe9uLe1boD+yYZCKkr3wWNHrJ5tZiCnD+tSj8Z+T0
         r/f+YgGS6RNVc1BRrTKnfL5YIYKtLsRpD00bWXfs2w3tzA92CKWpFcEe/rBAqnHlK6ux
         qD4XMvgWUbOFVYBEYhiaTuuj9u1/GAOojF/MpLSB0hrDbGDN/UZhPgySFdpEEKrx72GR
         fFJzIyfCzGzWBu0iB+3zXm/9n7+he2Q4eY3C6FIWk8hTWheMN98etxUURSw9Vu6mfueV
         i1+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUCnVuPBDRg/5Ph21R7qw7MwNayhaAKTQGFi8M/MHzaoLbjjFWZ+kWuSAadNXPULU7Hoou8p/zjww==@kvack.org
X-Gm-Message-State: AOJu0YzkdrrPaYp7NYUi/MXCUrg0XttHw8GnQAI4BrGGB5+vFgwvj5mA
	3dC/7bRY0jLnXNMmEQz40qzEgeYc7a6g/fDHvwwp61iZcBtliK91INroGV8ztJoc4/GVOVKIgTE
	2qGj/DBBteH3UBNlZ7LKbqMqCn/Z+1UerX4eB/Mve6icn32Nc/Z6Z
X-Gm-Gg: ASbGncuaOesxD28KFXfhJ786wLtNG4A5dKmt23nmZRSmAL78uuNObQ8nntp8kGHXdrM
	WyTG9gcQh2wLeitBfsPft+fxR8LUqPWaqlL/c/ZENbDMguLDMvEfEbC0HGYrLysaTSRib2yFD+7
	Y7XHNdBL9Rt3GUVAu8VAhF2OlDZj37yWXRJpQsbMoLiZgw248rh6N7etXaLQw2NleV8ehJCNXFK
	GQoGEc/oodc013ZVxuznF8UZA3PkixuV4meOG9O9ex2DbHIEbnhuuyXWWgmGlyKBZfEIhr8HCjD
	JSmwQCV0uU53ixfOrUIKrBItKi2acElmQj1/BogQ6sL1PZ51x+9qmGCr2kcIv/aoZLGWFDNps5A
	hacI=
X-Received: by 2002:a05:6000:2001:b0:3ec:ce37:3a6d with SMTP id ffacd0b85a97d-4266e8d8edfmr7245543f8f.47.1760084167070;
        Fri, 10 Oct 2025 01:16:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZ368MGuvWw1VsKC/pQLX3ZFh6T+mRMjmDTV41EqO6zVdB5WKORFNY6kUvdlLjMLs3z4adWg==
X-Received: by 2002:a05:6000:2001:b0:3ec:ce37:3a6d with SMTP id ffacd0b85a97d-4266e8d8edfmr7245519f8f.47.1760084166637;
        Fri, 10 Oct 2025 01:16:06 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e83e1sm2959842f8f.51.2025.10.10.01.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 01:16:06 -0700 (PDT)
Message-ID: <08baaace-3141-4ef0-869e-c80e216c55ca@redhat.com>
Date: Fri, 10 Oct 2025 10:16:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] s390/sclp: Add support for dynamic
 (de)configuration of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
 <20251009131839.3739108-3-sumanthk@linux.ibm.com>
 <ed7db8b9-e828-420d-a8b2-3e1b8aa8c95c@redhat.com>
 <aOi_PL68QaY2YIAg@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOi_PL68QaY2YIAg@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1trmM6woCoEi2eWl8v69SCSqifcyMdPWA0KLrwzxWQ4_1760084167
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8600C0006
X-Stat-Signature: 8tfqy5sjfaytqhgc6su16sygw84egx1p
X-HE-Tag: 1760084170-335487
X-HE-Meta: U2FsdGVkX19do03UeZ47u7IdF3pkSreN6pmMpYl5GFu9m4W8avseQ06HLa3PGoIy2QZFsaf3G3cEMxK/gDm08g3wCQGeGr0l4D2PJ2LKLqeMe84vYF2fR/gWb5Ng3+YYyqAuM3+Dh/Afe7AwOqGXL9RbGnpEcxxgv3+hpF8ChzYNxfjIigywpErbpN11TsZNyLbWUXq2DAwpZWE+oFAkWMa/irW0iIG3LAU8ANnCMPCWr0WxSVSIYE9Y5zQF+KtZzxfYfePQf4sR8SWPUAXA6MsQXSvldBecinT0ocajUVOaEQjTZNybJsZe8D1wUKeE4K+wuOK40CmVX2kfzNSPDfhHFyKU+OhMMTP48AFiJE66E7vAqPpQgmIiM1R712C3YoTKp+QfSd87pMSiJJXiNL8m/jbp+Lp3u3kkdYbLbPFwHDFp0t4bMdeDG1K3KacuIIr60QULOOQSeaAAxPFFvw1NSHfM276wGXYwE3CI1uMopA34b5PLOPU8adO7losHf+uwCjQXEU4DVT9qCNG2Hy1kWZPFUm1Fn5uALNOruDOTqA+psjskhD447wYCr04FjNA7L7f9/tbIj+5jZjQl4kuhbP3PrE3zF8qG0eSG1LRTjRm4y/zv/qGbdqep6yHUMr+va7aoCqZgtaMeCSWsl2/8t3WvhNuewhg84rru0h0GB4wB2/yTMqaQZSVij3Hvj/EJp547QDtwEw7CcKT0ZtF/jYJ7E84n+xEMNVkXVCn3HmErUflBqDtjrhJXERoXrOG63R0lxKYb6ySGKIWSASjgjhOzVFVsv8jJkU55eB5KOSyq6oGLrNE2ZmzwYDGp/syc/+pAijgbQcavXcpGxd4BORlclrXt4k+6tujpjJsQfjy8jTo36Q93nsO/JlkfBNmnHH2ahgb3v4MQHgTma5Gw5ZahBGMvX1Q2xyZ4KL99ghpmZRQt1sFRSEqoPamS/82VxbwoQV2KOHPgB6H
 swzDvrje
 ATz7kT1ntdListUR0RZzvd8+7kN1E4YoRRajr59cisrnlBw4mOfZDMm6z9JgFaB9Okd5ZJTQMl/0V+Pc54NXW0gxLPW8jF258fIEy6MEjeuWvLT6i+zT3WCjMEzQQera2c8w6n2AJm2F4hImjI7Gbon/J/4ozB4/wbWGb7VsigtOKVTiqLuxDdX4vA822BPOgVljDqVmIYQAsaCy2aHOkAnYepUz7KH0y0C6IkfhwF8W3ukswOct6+S/ai5ruZvUOhPEbWh9gMfTk15gGoTWNyZPt2au3mJ/ks/aftu4DFMlNcOwyAOUL7uYAVfe3cWfR877ZSMMNb4jFbNA6HplWdWJehWsEVJgNYG7HzVwZru1/MQCGT9SUiuZ0RvGH1+1qIzMBya7mmhdDLq4MlGsY8WT7ngzt/P+sEw19TPIC2y71HYtVgfq/oYS5AE68f9n4xQEiYecCFvqvzmBjSClAGqrOO1hCfxRm71XWiFC9MJHRTikx1zwzklzmer40Lbg49jZxIQPY87Cz4AclWe7vskE11zyZ3oLwp4oyWsOPSx8QpcvKPs/KoN1kgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.10.25 10:09, Sumanth Korikkar wrote:
>>> +struct sclp_mem {
>>> +	struct kobject kobj;
>>> +	unsigned int id;
>>> +	unsigned int memmap_on_memory;
>>> +	unsigned int config;
>>> +};
>>> +
>>> +struct sclp_mem_arg {
>>> +	struct sclp_mem *sclp_mems;
>>> +	struct kset *kset;
>>> +};
>>
>> Just one thought: if you keep either as global variable you wouldn't need
>> this. (I would just keep both as globals, but whatever you prefer)
>>
>> Whatever you prefer.
> 

Feel free to add my

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


