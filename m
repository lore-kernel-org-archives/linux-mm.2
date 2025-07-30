Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B264AC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4286B0092; Wed, 30 Jul 2025 07:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389FF6B0095; Wed, 30 Jul 2025 07:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278E96B0096; Wed, 30 Jul 2025 07:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16C9F6B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:39:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C62D41DAD6A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:39:48 +0000 (UTC)
X-FDA: 83720736456.06.B9C36F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A5B02000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:39:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jLpMLgSl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753875586; a=rsa-sha256;
	cv=none;
	b=GH7pWm5JAkPD1hTWRBb16ih661sHkYMcj+l0yhw2EuuOawW94tt28iw8AQjjZ6v9u1vn8G
	oYkTTJ7uQtQJETlJbFPaO18rwFHJXV8hLNopnk8syIkJZKRoJHRLZUVTFiJq4tBfmk/PWS
	Kudxg+bd6iLKFby1yPdMZeqVWKlI3xE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jLpMLgSl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753875586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgmT/4MxmdvSfKxUoKQscuXLpLll1+wxv5DeTi8iqhY=;
	b=IKzyC1P2AS0ngl/iHOfdGmrIYjJjlCCY79Rxu34lZQINKqRPH9LgcdzXmTr25SQFrfhvQq
	Yg2JOcltk0aFhahiebiuqXPqFI1DbeykkGieo124dx3CPPEGoxLEGZffqN75pDM4vbF7tS
	6In8BC5PD03phanqeMMHdyLoS/RfZAY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753875585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DgmT/4MxmdvSfKxUoKQscuXLpLll1+wxv5DeTi8iqhY=;
	b=jLpMLgSlmHopqfjhqqo1onbw1aa7tFTqJVVqcBeZTQAYPAYISKU+AFCKTHVt2LENNYGclk
	ujFn7UvEEeyajyjSb7lx165coXYDdJQqzokLUT/htpwH7EazpvnhLxCgCgwaqCE8cepgFU
	b3r8nDu95Ywn1/lZgjRINBbYjP5IuAo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674--MMmGifDOW6vOxKt5JW3Vw-1; Wed, 30 Jul 2025 07:39:42 -0400
X-MC-Unique: -MMmGifDOW6vOxKt5JW3Vw-1
X-Mimecast-MFC-AGG-ID: -MMmGifDOW6vOxKt5JW3Vw_1753875581
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-455e918d690so4270335e9.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753875581; x=1754480381;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DgmT/4MxmdvSfKxUoKQscuXLpLll1+wxv5DeTi8iqhY=;
        b=iEgEEuozE4BeEzrLYdDXL47YxO7v0Bszva8L8jMmaJnF4mH4GweW7SE0M+ZRfB7htE
         pOJ4qGpOW1Vz9iD14GlC9BH0Psmt7TqYtxX1t3v3gsArt7JlSeKk8+f0/1N3MttbMqvi
         KRRtN/94B5pa0PAho6XjiXJAfa3ZHjuiJuXKD4usVwYZR91uXM3ngNSLSJV7sjuCfe6j
         ndV/UcJSo03sNZRvjFjxkhziBQ9+1TmBouRq/P0y7/jLTwcGw9qMeEhMmG+RmjpPDsKG
         w6UptFYBYfRPHyTWl2WAsWFHFbeUe2UJ0v1y++cWKwjhU69O81Z9pY027aiR8Oghf7Iq
         3GAA==
X-Forwarded-Encrypted: i=1; AJvYcCViea7egN1jXJoEjb1qMSaz0xWStCb3nqPIDfn6l2WNE8i5UXBX0+wIz7PMleIiMfwm5hHBv4Uwhw==@kvack.org
X-Gm-Message-State: AOJu0YwOmtJj5/LH9iLwmQTY8TLph0NyTEg4RbCRRAzUc4Ohr6wwoD/r
	QfnmU6cgdPNbDiHZdSru1zN5/CVxzrRgGtlOBjyn38K5/txPWPqYGbujLxQXhD1BkJc9k4ktk2X
	EbeJKJQvKfDfTE78+0MpWhxIAf3D+EG0zvsluQ0gNfZxq05IEZxa93W/OoqbjzeBLiQ==
X-Gm-Gg: ASbGncvXIYtsu9s8eSVLgtv5jXQ/t4tvQURHAUAfxANEYmYINavnoQ4mos2DZKbCLCt
	NPdGG+1Dt4BFrmwEruWPm/uBWt5JLOOpGANVMFug96BGgzDJOdwLwdhslP9rxRnrAl1WPiw/zOd
	peBkQ6NMKPpXbaNzSIZfCKu9kcFmO5CJjs2rqJu8rBr0U5fDDvwRlktrzE8fHlCFRxvS+t89ucp
	z4OJjXtGC9xTG49SLRiHovY6xPM3GB8tT6W3kfYUSgjEAMF4jgP45PL/gwe0onmP465+9TgUfSs
	ODGe1eA0NV7w9E5T/RVROm02kykgvQs5GZjTsw9yo03KYHTdNRL5caeHdglPgA==
X-Received: by 2002:a05:600c:8b52:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-4589303fe49mr26932065e9.0.1753875581216;
        Wed, 30 Jul 2025 04:39:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFDob6ua++AEhRi3Gfd/2+HGGi2uT+wVMMUC/mjnay5/mOVTl3fCjXOJlvvVcYCQBEH1aDGg==
X-Received: by 2002:a05:600c:8b52:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-4589303fe49mr26931565e9.0.1753875580676;
        Wed, 30 Jul 2025 04:39:40 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589539e491sm24168925e9.26.2025.07.30.04.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 04:39:40 -0700 (PDT)
Message-ID: <aed4c988-7389-44b6-bbdd-eca64304ee10@redhat.com>
Date: Wed, 30 Jul 2025 13:39:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] selftests: prctl: introduce tests for disabling THPs
 completely
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 ryan.roberts@arm.com
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
 <20250725162258.1043176-5-usamaarif642@gmail.com>
 <b9c72ab9-9687-4953-adfe-0a588a6dd0f7@redhat.com>
 <4dc95e54-e0ef-4919-973a-748845897ef9@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <4dc95e54-e0ef-4919-973a-748845897ef9@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SBv-EBI8-1byOCkqHZfGo7EflXiK2N-VKURRl155MMU_1753875581
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A5B02000C
X-Stat-Signature: twz3fonb5nzus8eyuim5j91qcq91cmfc
X-HE-Tag: 1753875586-891902
X-HE-Meta: U2FsdGVkX18ISeBB/FS+YzR8aLQAvIrGGkJUSBwrvVHow8gF7gbrG2HQQKvzDdExO5BUbW5VGkS4m+alfLPwDB0h/uuNvfE6OElFjejA+0DY0Je0MUMN6n18OKHixsFznp5i+8US1zRVyEU7i0ehQB36CqemqkS9iQ2sXIQ4b8kaN/1f076S20idefTYbQdE4pbJlHn7srRAPP+VvkUoOc/XHoXcGpLFq7KCwFSsRtbVQzKG6TSezEqg4u8V+KGFCNHJS4Aoa2af1HRZqovHQ36LS9IvijJE/SaBXtFzFrFPOy2h77pFIw7hXb4qbgjpJywzQPhKK3DRh8yYb/tulvGH5bL9Q1vdDgasp7knUiHR7YHHLRemuEy0AWBbh8ncFta9APuR1aODwi43K84Uq0hbOvLVfvRdkfEnlFavsjQJrCVNYXPmOXiWT78lMS6vpHfXjwWCRZA3PpBhXs3mS5TqYvA2mQHyWJ6yWtGKUuMvguoKCScMcZRKJl5sFzhJI6y4w2OalVwVtl+Li3aaYS3IlDMWbJCGhwqRxzp0hSCKvZi22RANpXESIfKGK9Ut6vuAFhZVcrX1JJyzh549bm8W32A4TT0N7qzP2AGKfDjtGNAXh/RZEjMa2GPwxYDclqfhdt+Q173jhsyqvtks+TqZeMtHGWtUDgPN8ElmisqbM0oMLcx/eYd0Re0R0cOc8xwqr8fc4SazjMyDSx1G2/w3pS65X+TvB8WpHitNl9r5zRwpbR8FXB/OAUe/cjF5z9RD9NNtoyhWLC0RmIIFZLUAmsiOQWoBAyOeuZmYSyswWW4bv8DlQ08eExCh40UMfOQN20C+9pt3/qS8+J9xxiCjHDooGInJqKMfa5ssoL2lwYmrudGi2QDvFv4B23ZaQVTrg0RgmSweryUWKu1li/sIClZ7vxV9TzoZttpscwJPyzROEs9NvWLf1/QBOZJw7JUUHcf6tajVorwLmiy
 k+sAFWcI
 Wd93roeIbvrFIXz7jc8Dh0Uvn9JTEC5ynYt6aXKAQ/e7k8fbPGQQBfgXPIeRVZzRELePKUJP1aTzoZM2mctGupu3K99rxEP+QbzxGVT7VEekhDLEvKEJjlQijc/kGq9HCI8YxGwNsxhFUvxKc7ffzuETFDijRee9bRt8abG0rgRFh64SdDeajsKG/7PdpqUKH6iPFIxlpxR147xAEy/R4dZfXK7c4XLj1WZQXph18gnAiM3dDqK+tfaxnlRmK7F0sV20oRisxeErgHZd8uea7WEPHNNFVgG3L/YsEIsK3Afe5ldjuTLGVUguXsYNTQoa8RmT2PyBqMrsIDyqX0KW+IH1YLNeHA+KN2sZ8iUYHHtofMZzkhVIl2/c9SzlTiI+GMIHmmXbuAdPr8N7yEqJYow2he9g+bOUJakgA0XboxOr1yadA0VuPkEL7KRnFxuId965JQjYI3Y8E+VRYBSlRGJW4gVH65iI9ZVMra6f+vBtCuW+n9h1QMuP3jxuQssoQYEtGGYTnn4/r0sU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.25 00:13, Usama Arif wrote:
>>> +
>>> +    self->pmdsize = read_pmd_pagesize();
>>> +    if (!self->pmdsize)
>>> +        SKIP(return, "Unable to read PMD size\n");
>>> +
>>> +    thp_read_settings(&self->settings);
>>> +    self->settings.thp_enabled = THP_MADVISE;
>>> +    self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
>>> +    thp_save_settings();
>>> +    thp_push_settings(&self->settings);
>>
>> push without pop, should that be alarming? :)
>>
>> Can we just use thp_write_settings()? (not sure why that push/pop is required ... is it?)
>>
> 
> Thanks for the reviews!
> Ack on the previous comments, I have fixed them and will include in next revision.
> Yes, I think we can replace thp_push_settings with thp_write_settings.
> 
> For this, I actually just copied what cow.c and uffd-wp-mremap.c are doing :)

Right, I see push vs. pop in run_anon_test_case(), but push vs. restore 
from main(). At least cow.c applies a configuration on top of another 
one, so it needs the push+pop semantics.

In your case, we really only perform a single configuration. So 
write+restore should be good enough I guess.

> 
> You can see in these 2 files that we do [1]
> - thp_read_settings / thp_save_settings
> - thp_push_settings
> 
> Than we run the experiment
> 
> and at the end we do [2]
> - thp_restore_settings
> 
> i.e. there is no pop.
> 
> I think we can change the thp_push_settings to thp_write_settings in [3] and [4] as well?

I think we have to push there, so the following push+pop will do the 
right thing (I think that was the whole idea of push+pop).

An alternative would have been to just have write+restore, whereby write 
always returns the old state you save in a local variable.

I wonder if a final pop could be used instead of the restore somehow.

Anyhow, probably best to leave the other test cases alone for now, 
unless you want to clean it up properly :)

[...]

>>> +}
>>> +
>>> +FIXTURE_TEARDOWN(prctl_thp_disable_completely)
>>> +{> +    thp_restore_settings();
>>> +}
>>> +
>>> +/* prctl_thp_disable_except_madvise fixture sets system THP setting to madvise */
>>> +static void prctl_thp_disable_completely(struct __test_metadata *const _metadata,
>>> +                     size_t pmdsize)
>>> +{
>>> +    int res = 0;
>>> +
>>> +    res = prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL);
>>> +    ASSERT_EQ(res, 1);
>>> +
>>> +    /* global = madvise, process = never, we shouldn't get HPs even with madvise */
>>
>> s/HPs/THPs/
>>
>>> +    res = test_mmap_thp(NONE, pmdsize);
>>> +    ASSERT_EQ(res, 0);
>>> +
>>> +    res = test_mmap_thp(HUGE, pmdsize);
>>> +    ASSERT_EQ(res, 0);
>>> +
>>> +    res = test_mmap_thp(COLLAPSE, pmdsize);
>>> +    ASSERT_EQ(res, 0);
>>> +
>>> +    /* Reset to system policy */
>>> +    res =  prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL);
>>> +    ASSERT_EQ(res, 0);
>>> +
>>> +    /* global = madvise */
>>> +    res = test_mmap_thp(NONE, pmdsize);
>>> +    ASSERT_EQ(res, 0);
>>> +
>>> +    res = test_mmap_thp(HUGE, pmdsize);
>>> +    ASSERT_EQ(res, 1);
>>> +
>>> +    res = test_mmap_thp(COLLAPSE, pmdsize);
>>> +    ASSERT_EQ(res, 1);
>>
>>
>> Makes me wonder: should we test for global=always and global=always?
> 
> Do you mean global=madvise and global=always?>

Yeah, rewrote it 3 times and then messed it up.

>> (or simply for all possible values, including global=never if easily possible?)
>>
>> At least testing with global=always should exercise more possible paths
>> than global=always (esp., test_mmap_thp(NONE, pmdsize) which would
>> never apply in madvise mode).
>>
> 
> lol I think over here as well you meant madvise in the 2nd instance.

Yeah :)

> 
> I was just looking at other selftests and I saw FIXTURE_VARIANT_ADD, I think we can
> use that to do it without replicating too much code. Let me see if I
> can use that and do it for never, madvise and always. If it doesnt help
> there might be some code replication, but that should be ok.

Yeah, some easy way without replicating would be very nice.

-- 
Cheers,

David / dhildenb


