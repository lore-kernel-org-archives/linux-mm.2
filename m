Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1412CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D29B8E0007; Tue, 16 Sep 2025 16:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA238E0001; Tue, 16 Sep 2025 16:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFFD8E0007; Tue, 16 Sep 2025 16:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC068E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:11:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C89FD5872E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:11:21 +0000 (UTC)
X-FDA: 83896207962.19.34043CB
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id AC313140008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:11:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=AkOILW5u;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758053479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRKeNlsim9Z6rGJwyWbEzqX8xW56fUwdLlJdUy4tFkY=;
	b=m0M+7WzDNx4wNb/C8+BK1D6HJw8hCWv3iXAsb/Y4sMzyxMUUoIudLx1uq2d/2Bs1rIwcFo
	gLHjoSJc6u8SG0+l9OhWXTa7dK5Rzw9UefctgiiTLwbRUzTX/9g/MLoIhsGV5/IgkdpVwr
	ld1mAmoXHX5syu5lfDt5+9qNXzGRYas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758053479; a=rsa-sha256;
	cv=none;
	b=14E7bZ3nP+yu43GR20jXZNBAM4cKiWJr61YmdMdVZIF5LmQ4cJ4tRKVMLkLAnEDsgrcqvy
	2TI8MjXPQsYBgnLk94SfGoroqXYaOFrY4YvNPhq0L8bDQ2MOoiScIgIti6ODYFdI3XtmZx
	kafnGF2J2xxRX+vSIzgbveEwAGaOvlA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=AkOILW5u;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b04770a25f2so818852866b.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758053478; x=1758658278; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SRKeNlsim9Z6rGJwyWbEzqX8xW56fUwdLlJdUy4tFkY=;
        b=AkOILW5uOvahkj88Ru4AfBc1To3hkdE11ZDA5GOcmug9UxQ2I3w3SDyb4kz1VgHd2x
         hAVZuAb04O4Kxg/+Se84/2fK5QWi9sTqJ/ivORkEeFv60FPr3bJ/rzR9sFS/dVk1LhsJ
         0UPYWYZjyOg2NEyIIijdSYb1GzwSyxRMKFJQXQaL6iMJXbdSkJ4RKDrY+oDqOR8P632l
         tvADKbTZaUpeBX5ipoW8mWw+f7hwZPIL2x8z4W0FmYP1Q7WH3B77Cg5RYvv2n78Q+Rwy
         pfsZO+MOwEgsjvZHpagd5FK0fT6wUYtXh+FwjrbIzgA7YL2aCFktWIvILRhCLXth8v8b
         R5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758053478; x=1758658278;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRKeNlsim9Z6rGJwyWbEzqX8xW56fUwdLlJdUy4tFkY=;
        b=ZS9yaYZM4iYfQ7gndbEEKfUXyRrUfJyZWDJd5VGQA0VQHL9GH4kz+lfExD0l671M5i
         fj4gayld7I2asVMu2NiJnKAOKMsaYQlAwP3CN+BbyS40ow722sgPDRrowJSu562povav
         NjECcxgGjo9JH+7Km93L2Gl9xo1sd8C1RAQ6hbbtI5JRdIwOacz2nPGhNXU8THRRSLNN
         gyF9XNVssNVtwnWItDbVuI5QhMh5efvH3xkgBe19z/SWPTn6Z7dediywU/pI2eTSjeqr
         RQm7VmvIVwvxtOqnXx/8X/czDRZWsgaUl9gZY3vM1+rx/B1Pxtlg2pJF2rd/X6iLjH2E
         p2wA==
X-Forwarded-Encrypted: i=1; AJvYcCWYCDlE41vPkB5qwT0AmhD8lenVqIo4HuOde7UkqHhgLXvKoBm4eEBmEXUNwaEyg0uJD2GDDlLRew==@kvack.org
X-Gm-Message-State: AOJu0YzsS6d4sEnjB/ETib2zTEFdyyZifhmc0FpYem9Dlld4npa5tGdw
	mpM5mtah5bnKq0KosX9WUshzlYS6aAS1AcfA7lt7g/dr45A+sTRvVkuVNRCfHt7mngY=
X-Gm-Gg: ASbGnct4UMCeGGtdca56z9xTxhe1hABngq8i8lr4YAQpl8XgZWQE1FoHHjVplQhSij6
	Vbsj9kCrYxkOqZgr0MBZh5/aUXxP+HAXqQk7JhObzHFSeNrYabOloXTaTYWzvzqdEUYhVyCg7+g
	z6SfMSSJorcLTXRL2WwpiMq+Xpdy3fLkwG7xvAVjwU4bgZmFHZFi1+Zgii/2Ah0iVw5XkDO9d5B
	s7R48iai73BKsA4EiE5eL6IHXzb/xX0nu5OT6FT+w6gRmXf2LUl2n/7qsEdb9Bj2p6kuw4ut8BP
	ZoKYIM0/yx5LvAplP2JhJRVOzhrTh31h1JjbQ/U4k43GfQVhm3kUaTIa8e3pVhjNXJ98RP7hSpy
	Ykrq0b3jtSAFjXp3WULaGYS+JSv2+wQ==
X-Google-Smtp-Source: AGHT+IGJtmFF5ihRgvgRLYDimOyUVDpM7pv5/NOzJTxGR+6ttSZugPIKsLBI4VyTpOJQdpj0xD2m8A==
X-Received: by 2002:a17:907:6e93:b0:b04:563f:e120 with SMTP id a640c23a62f3a-b07c3a701e3mr1670295766b.53.1758053477792;
        Tue, 16 Sep 2025 13:11:17 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07c59a963bsm1037691966b.42.2025.09.16.13.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 13:11:17 -0700 (PDT)
Message-ID: <defcf2f5-4435-4c72-b8ed-9d076863ff76@linaro.org>
Date: Tue, 16 Sep 2025 23:11:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
To: Shakeel Butt <shakeel.butt@linux.dev>
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
 David Rientjes <rientjes@google.com>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
 <aMhgoUvziLPNt_vI@casper.infradead.org>
 <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org>
 <aMlS9Kb6_x3fqsLG@casper.infradead.org>
 <50b566d6-aeda-48cc-bd67-362cb29b214a@linaro.org>
 <nglllfwopxgz3fye3grko3hmbvpmfhewj36qg6lbh3b66bjpvz@foxfjulayqst>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <nglllfwopxgz3fye3grko3hmbvpmfhewj36qg6lbh3b66bjpvz@foxfjulayqst>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC313140008
X-Stat-Signature: o49k3uekswg134jqo448mfzb3bahx569
X-Rspam-User: 
X-HE-Tag: 1758053479-842827
X-HE-Meta: U2FsdGVkX19TIM53jkgsQT0ZJO5E3RoWKjX1P4EunNlBrnGG9rNccrF8hy7MsCd8fzlv/n3Mqy0pmRlA3j/yIogOta+cYb3n3TpndFXsUqVn0WYh8q3YipwS4HRlBNM2wlzpkzMDao2kkEnKFl3Ti++/svEkzOZUQ9jzFGtgS7Y2PoBShnnQnJF/jvhEg8fmi9mzqyyIUOtmqoAztFBPsVLC2hQrRGNyETmw0YqBa6ZszVog78kVgYpuy5VwDPHkMUuuH23xfq4yErAIW4uVK+YvPa/ChGulUH2bvjeBqxEnRfiNoTqeR8MaxLc/guyrnQgrimYZmxs7/YHh4060/IkpkBL6tqLUICyXmzdR06clUg2+709YS5K5w0mxojVIl1u0cFLUSP9jev8BvntGpfAtQ4FJ7fL2FQaeq/ldK7t5c+QHPor6V/xs1yUnEZuyXg+m3Qq7HV5qa5VRdBkNUV2b/VI21EVYtQ10dnm2liYBlBnqYbAYidLSXgFEa3HKWzq7Gb+VpFARgcO2Bo0yViSupn0iag2cA5nGKMS/gyXFGPrKk6G784nczGnprolcU8Cj80XLcH5r0i+zczcWUFqa4jt/7ijV3AjvyB9fQPVnyQqDPt6xweJqyi8n7IibZYuAZ8ejMekc9kWr216p7K8BydkpiwbhvIHxwfEScDGqRO9fy0+NCOZsuJ2l37iVyj7DWNMYtjkCsMieNMMHP10B+gIqwwoyjkwHdqWwfIdQvw/ntm8BK8SjR6pQc3dMJRdL0VzuNfXrI1BdpjDpZQZ5fukL8C4zBaESKstjUpMDqsNnMvjEQNJWkc+fNmyzx0Dc2eTDu+YUO65xwuurUbinoYIqSdYe6tsa9TvuXaPVJxkHTApOjFo0khEwAvPanOl3zY5uicpW9goOkx1u5wbHdtG2OUwG1ynGN+9tlyd50/M7R68+J1MiBTWn+NNm2Hce5Fni2i7iMgfuwO2
 ids9/OGM
 7cY3bnHmrOivrRUgcufGxaFJHSdCnF0m5cOMprkHUbtM1wZ84Yb5IWOMd0gQEzdIwPtBHe1qqyzFDIFsFjJj11Gfuel8dyox7nB0UIiNt8cSP10IPcShS0/pCelyXTVYSVz60ScUQqtNYS7LYrDq4zviN2rIjLaPCMicaLVsbahJzSfO7Br0buj2you6W7FRicJWyM1ov0zwXtuwdtmXZis0SYO4io79QUVsvwpls2JRsv72XnEmr1nHN7T5dkhTvanPY2yYyzmUE9w/WsdfhOUpGlcol8FNHoHp+oXHovzTv61zkdAHMdd9XWQda7+bmTvUML11+ZiooDQ+IO9o4YjCxyEmCSeQphLJLlaplMt396Q3HkWk/vmc6DGWV7qAIuW525fzmuf3SPY4jJIT90wFkH139vH+S/WsNiucJ33bSYVSW5wkVH9FGkJduTiydqZFsceFb0pmQxs7mW2EaUk7R+AuHmCaCesZR4kEPz8ntZ0YOP7ydkzzaylezSeCBcD93ZS2Z9/8wDpTFjJh9saMBBbUxPoCo+Hl/eTILTdMMCXKK/V523ksAM6Xa53lkuM+cQf0sALdoMu3jHwQhSXDsftREZl6JokHmd/UFQo1ofMI7OxMCIjK+yfjS8murfgTwhmGRfB8560hSOBE6l5a9izQxXwRvXeJc6I0zjPDvyY4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/25 18:36, Shakeel Butt wrote:
> On Tue, Sep 16, 2025 at 03:14:48PM +0300, Eugen Hristev wrote:
>>
>>
>> On 9/16/25 15:07, Matthew Wilcox wrote:
>>> On Tue, Sep 16, 2025 at 11:49:35AM +0300, Eugen Hristev wrote:
>>>> On 9/15/25 21:53, Matthew Wilcox wrote:
>>>>> On Mon, Sep 15, 2025 at 08:58:35AM -0700, David Rientjes wrote:
>>>>>> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
>>>>>> proposal at https://lwn.net/Articles/1031319/.
>>>>>
>>>>> I don't understand what this has to do with mm, to be honest.
>>>>> It looks like a debugging aid.
>>>>
>>>> It was suggested to move it to mm/ :
>>>>
>>>> https://lore.kernel.org/all/0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org/
>>>
>>> I feel like you should be able to explain this rather better than
>>> "somebody else told me to move it".  As of this moment, I still don't
>>> know what kmemdump even is.
>>>
>>>>>
>>>>> https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/
>>>>>
>>>>> is a great example of how to write a lot of documentation that doesn't
>>>>> actually tell the reader what anything is.
>>>>>
>>>>>
>>>>
>>>> Here is a link to the v3 where I changed it a little bit :
>>>>
>>>> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
>>>>
>>>> I am eager to improve the documentation to make more sense out of it, I
>>>> am happy with suggestions.
>>>
>>> Start by telling me what it is.
>>
>> A way to select memory areas from the kernel that can be used to debug
>> the kernel, instead of saving the whole memory dump which is mostly not
>> of interest and takes a lot of space.
>> Anyone can register a pointer and a size, these are placed into a list,
>> and a dedicated firmware can parse it and save it in case of a crash.
>> Does this make sense ?
> 
> Is it only for kernel or is available for userspace as well? And the
> crashes here, we are talking about kernel crashes or includes process
> crashes as well?

Using the crash tool, you can inspect the tasks, current task and other
tasks. You could see the processes and current context.
kmemdump can be used to select also user space regions.
So I suppose you can dump that, but the crash tool would be specifically
used for kernel debugging.
I have not attempted this though. It is interesting to see how it could
work. Maybe kmemdump could create a coredump of a running process, but
it's not attempted as of now.

