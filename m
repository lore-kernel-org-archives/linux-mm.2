Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942FECA0EE9
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 08:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231628E0036; Sun, 17 Aug 2025 04:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0808E0035; Sun, 17 Aug 2025 04:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFAC8E0036; Sun, 17 Aug 2025 04:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB3C78E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:11:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 172888040F
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:05:06 +0000 (UTC)
X-FDA: 83785513812.24.9C06B94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF6F2140008
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:05:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PJyDdzl5;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755417903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiISDgpsB+3V2GnY80rZDNzM1k3Hmwc7yt5I/jAodoI=;
	b=V/Iw8NKYYhoNSS8jt3x7QuNV4wNZLqa79G9oP3iGfEIQ9VSBiNwSpKYxoVOtvnOhrH2Qxf
	4OtpSO1m9fbHVqKdkOjGjs1iuKUqcvPVIxq56dHB1+m+pAU9sHHQoHdyYhxdK8VTce2Gqh
	GiZvH74yLyl9bOt8SImTnjM5ZQVhAcI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PJyDdzl5;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755417903; a=rsa-sha256;
	cv=none;
	b=ZzYbpkp88MnqtVyzFa/SZxx1IEis2YBTl5F3ZzPRZaAkt0AnQa0JXuaboe6ei5tghnq+iF
	3GlKdxN0C4CBlfToMlM1l7dunazNA91pyviLdWjY5W9wlYBxm23s7G0fgUYXz4XoYf+Nre
	5igrWU+Bu2Pjl4ivMbdaorrIoewGP7Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755417903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OiISDgpsB+3V2GnY80rZDNzM1k3Hmwc7yt5I/jAodoI=;
	b=PJyDdzl5vzppF9iSDVX8ZJW84WXPlsz9zMJd8gFV04ljq5fdy+cDYIUKASgHeVrHv0qS0D
	FNZwC2lGpbQvmUYUoWSZH1teaNKL4DEthSb+OxtwNrqVBOvhGl/SNSR5tdNCnBnacpcmdD
	ZfI4BnWmt8DXi9cQX8KnKJghmpKl/KA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122--zysdveIOY6qj8Z04blaoA-1; Sun, 17 Aug 2025 04:04:59 -0400
X-MC-Unique: -zysdveIOY6qj8Z04blaoA-1
X-Mimecast-MFC-AGG-ID: -zysdveIOY6qj8Z04blaoA_1755417898
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc5c2c7dso1864731f8f.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755417898; x=1756022698;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OiISDgpsB+3V2GnY80rZDNzM1k3Hmwc7yt5I/jAodoI=;
        b=RsjeGMX3gp3MNrtb/GPbrNW60Fn7w2dxieYxEPW3x0OifxgT4phWHfpDhAf04t9YJ9
         wvKY1HNr2yfetCZ1ThvizC4qpE6/WpLHkS1SNhMB1JnMSrI7Ks92DCmD9liwfS9E/fDM
         SydttIPw4xALDbPHG1NIXq+3FyaisAcnZ2apP+jeuKWC7VgV9jz3PEZBptEZs2XkyEwa
         XmOs03pMmTOOih8QOnBtCG9iRlGecd+zx4reKtZFgwEMYIDvkaFPTsqGzAIb9cAvUn+G
         8D2baDopp2nEg7u5rsWHHxTtLozbNSUBlUyRiZrnk/WxFX7ktND/UL2gj3EMfJXKFQ1O
         FcJA==
X-Forwarded-Encrypted: i=1; AJvYcCXDy8hZ4dTcGjcDpZEdOkoCfUwyjWrYl+k1TuB2ZdkLS6YPyyP07F6M7dmkKWlPE44Q9Po9x7yC3g==@kvack.org
X-Gm-Message-State: AOJu0YwoQwbJNezV0IZFGTlA8rA5HywtR4A//wmVimgF1UHPJsmhkXM1
	uXEgCMji5FNEd18Ww0jCqudp4asg13BuuLsB9/0gA9yY2iIOqdidBGLWu2gz1GV6NgN9q8qLpwD
	7sK/DW4EqDgDEHK3Fx/jPSLVzPQyCFyQ7vFOMgv+dWats0MsQdAzK
X-Gm-Gg: ASbGncsDW8ZALY0fzPByEjT3YnvE6DxZWmxfvLHy3dK70WOER0SgYVp4FxslO+aR6XQ
	nRFFVF/Iu+BitZV+9pjNfNCNIh+Cq0zHxn/z12Vazn9/jxj0XRRGPUX38PKOpeC4EV4V28566OL
	1BPEELXjzgrPPN8Ytn5Li+igwlIjMa8pkgpUdhtfZgVuNK+uUhkAy/HQrny41AjNaKk7edqu5aA
	+Bcwr6L0Dox7NWVx7FeDCHxQ2I/GQPG+n3bL3jLDVaYX98ApYwRjcUSRydotfhnuQzGf9263xNF
	QdENAi2HXFRO7jF7Kuyv7+tpUGlWqvz4qQ7CVX1qgmlg7N1EpBoWZttDoWhTIn6/tflk6Q9SN3a
	pc5AW0b5HnL4DaWcw+Y9qXIsCkWtvrRZ+sYo72xiqpCIuvx77PR909uXqLta4HJazD4Q=
X-Received: by 2002:a5d:5d87:0:b0:3b7:8146:4640 with SMTP id ffacd0b85a97d-3bb69699d3dmr6661015f8f.56.1755417897990;
        Sun, 17 Aug 2025 01:04:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBEkv1Ybz20WGc1N/fA5RmGzB0ximuuE/rkQhy0zNUcOEcJynqa4kRlx8wDf0604Y/DKALSg==
X-Received: by 2002:a5d:5d87:0:b0:3b7:8146:4640 with SMTP id ffacd0b85a97d-3bb69699d3dmr6660975f8f.56.1755417897495;
        Sun, 17 Aug 2025 01:04:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0b:a400:87b2:80d2:3e99:1b85? (p200300d82f0ba40087b280d23e991b85.dip0.t-ipconnect.de. [2003:d8:2f0b:a400:87b2:80d2:3e99:1b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64664133sm8525771f8f.12.2025.08.17.01.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 01:04:56 -0700 (PDT)
Message-ID: <3871f0b0-db94-4358-877b-fd5ddb4337dd@redhat.com>
Date: Sun, 17 Aug 2025 10:04:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Huacai Chen
 <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
 <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
 <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
 <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com>
 <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
 <aKCwjCJTEhX4Q6wW@casper.infradead.org>
 <e06f23d9-adcf-4d0a-8ba1-bda6d4b483b1@redhat.com>
 <CAAhV-H6csiOVDco=pocC72WSPiafDJV+1+R7P0KvB15dxOjtow@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAhV-H6csiOVDco=pocC72WSPiafDJV+1+R7P0KvB15dxOjtow@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5DLAWQk9EmyNNUxpfcebIy7Lf43UCoc85SpJOQPDwuE_1755417898
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF6F2140008
X-Rspam-User: 
X-Stat-Signature: 16jxwgofqrnqswphsth1q8h4mynnedz4
X-Rspamd-Server: rspam09
X-HE-Tag: 1755417903-950401
X-HE-Meta: U2FsdGVkX1/Oet0dHMpMR+GFYNFdU9gBedG7Nmb73rVFVMvlqc1X3qsvp29PXHvNTY9QBnAtedX+p7C7AcQdG9n9saDlAAudSLylub8ovshVEUku1dhatCQ1imV4UMTZmI/UNfcnp00a5oyO9uqItzTBLrS1I03ymxlw1loSynYwKk7SyKED3rqjDWyFkGRGHPf6mG+G9i4voI/0VPS0+Qb/SPFkbxAh5qhn6pVitPMidhjEsj00VuRDpGyUucHoVjyY0MNH2TfcCt4z5mqYQ49kFF0IxFyFRO/VjRACI7vdaBfJCj3p4INlpQ4Ol2fAAwThdSh43iYPMF1RreikCCGuWy8qxOLLDuT8QsVvuj69J0T5FwGHuxMjhG/hUaOPXDkRBiCv74tiyhHgRIgwt2X/ufAD0LRyuS9OURsFndi07Ez8CshMe7DGWP+O38DU6yYnE2YUqBezi5mMB4Jb/l9zhs5Y4T3ODN4wgf0HhKGNpb+eBaogjTXvAxt/mYdUStJXIep0kHW5vspDNGaJy19U8+yzwBGfQK4A4lNVTjyocE06yuat0jqutloWUl5fn14QcpA1g2yma6LRUL8l3XQugR2X/PAze8I+tUYFCJZPyhkNh3JdnLlhoTyL0jFrMFCGoT7EBpoDEJD3FQs6HWgBLicoLrG2MIKcDEF4yEUHoMFwuB4sqbhuvpW5/4jwumt+wW8c64uFmx+MsGWBqyv0sgBqwURKvB8qW4dO2JLMx8DEAhX7pFX0AVCXdRWcrlGiJR3foIm3qRSUInzplp252r8ZZ92zGApPIeh+lyXGpGn+pGw4rTK5d46c9ApkZ6d9HeVqxnvwjbHnSWnA1SH8bSqlX64DpZKmlB0r76WwurnRLOxcVY2v+2i9OAhFnDMrWzHRPEt5XPCK+/mjKLPMP9GubJ9a6hEJfn48UVeEUCF7wcFWa5W2YD/DWVHTV5rYco/PF/oV/ufN1JN
 yENkKUge
 3xjwIgGvBvWO5vY5Y5vcoZbMBmGpjimzyE6E2+bC2PKXGTg02WOxsheefQ0f4IDV/rY1OykU5P1H71ZbmttcaiEHyOCCaGR2qy9sVZLI1LjMMJQL7zBItp5e4UyqlyXzXDQDF5PYogtGxvHz3Pz91kduFuPcQCvsEdLnwbjyd9cQbtBiiypF4pop14A0cFrHwLx0DCtL/quue2tUSLwo3BFIBLRWy2J8pHEk7pCE49h28yC3GTVUHa6SWmmq807/5lQk3Z399MPMl2Yz84HQZJZ5plkmUCr66rFFYI1+dveeGQQTCUiVkAn9eteDJC+MY3VlK05G5twS6wmoaLKGiR6YmZe7HhMofKng/+Li77EsaL3j2ueVzJYa/724+M+NPgLaHoGd7i23XQghyiwNGoEzZuO37MR0023pD22LXTcPQmZIGRWVVASsv0BJ0MjseGLNYb9PFD7O/3hLrfLaa6H+fhM3WM4H5ngGnBP6Sutf5jcc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.08.25 03:37, Huacai Chen wrote:
> On Sun, Aug 17, 2025 at 1:02 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 16.08.25 18:23, Matthew Wilcox wrote:
>>> On Sat, Aug 16, 2025 at 12:54:52PM +0200, David Hildenbrand wrote:
>>>> +++ b/mm/balloon_compaction.c
>>>> @@ -256,8 +256,10 @@ const struct movable_operations balloon_mops = {
>>>>    static int __init balloon_init(void)
>>>>    {
>>>> -    movable_ops[MOVABLE_BALLOON] = &balloon_mops;
>>>> -    return 0;
>>>> +    int rc;
>>>> +
>>>> +    rc = register_movable_ops(&balloon_mops, PGTY_offline);
>>>> +    return rc;
>>>
>>> Using 'rc' as the name of this variable is an anti-pattern.  All it
>>> tells you is "this is the return value".  Calling it 'err' is far
>>> better because now we know it's an error number (or zero for success,
>>> of course).
>>
>> I know, we all have our things to complain about. Some about Cc: above
>> --, others about the name of error variables :P
>>
>> $ git grep "int rc" | wc -l
>> 12730
>> $ git grep "int ret" | wc -l
>> 80386
>> $ git grep "int error" | wc -l
>> 4349
>> $ git grep "int err " | wc -l
>> 6117
>>
>>>
>>> It seems to be a particularly IBM derived antipattern ;-)
>>
>> Careful miser :D
>>
>>> Some internal style guide, perhaps?
>>
>> Kernel-internal style guide maybe ;)
>>
>>>
>>>> +void unregister_movable_ops(const struct movable_operations *ops, enum pagetype type)
>>>> +{
>>>> +    switch (type) {
>>>> +    case PGTY_offline:
>>>> +            WARN_ON_ONCE(offline_movable_ops != ops);
>>>> +            offline_movable_ops = NULL;
>>>> +            break;
>>>> +    case PGTY_zsmalloc:
>>>> +            WARN_ON_ONCE(zsmalloc_movable_ops != ops);
>>>> +            zsmalloc_movable_ops = NULL;
>>>> +            break;
>>>
>>> This might be a bit excessive ... just passing the pagetype and not
>>> having the sanity checks should be enough for the tiny number of users
>>> this interface will have.
>>
>> Yeah, no strong opinion, this was a 3 minute hack.
> I have tested your code, everything works well. But if the checking is
> too excessive, can I use a set_movalbe_ops() to replace both
> register_movable_ops() and unregister_movable_ops()? 

Makes sense, given that I don't expect us to have multiple handlers for 
the same type in the near future.

Please do keep a sanity check for replacing valid pointers

if (old_ops && new_ops)
	return -EBUSY;

Thanks!

-- 
Cheers

David / dhildenb


