Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6096C87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 22:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8616B007B; Tue, 29 Jul 2025 18:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA91E6B0089; Tue, 29 Jul 2025 18:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97916B008A; Tue, 29 Jul 2025 18:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B982D6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:13:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CB5014026F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:13:56 +0000 (UTC)
X-FDA: 83718705672.15.BE3065C
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 62ABB8000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:13:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjnndyAY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753827234; a=rsa-sha256;
	cv=none;
	b=fXT17PluW2yUobS2Pi21PQCjYd9vuN1uRUmJVFbl7J1TyKal73TlyPueOYFp1AryVKsIF8
	iVqaaIgCKiouOihbgrapiIdAFAIxPHvZdzulhpJgLVoEAXcYDWHHAThiYNHYWt4t9+l1Sm
	gJayVAC0WnlxsInjCDyklSi7vpAqs8A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjnndyAY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753827234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4TdMm0dqbyPQgLDNL4WQ//dsNOz2sMfofhnU8OFQgg=;
	b=onyI2lvtgpIw+wc+r2Vp7N1p5zVJ0BrTfF0KVsloKv+5apz7gPs3/RKwgjOlSgrt6ZX7mB
	4ErQQLrxip6RqCyXjhiBwfAUem7fK8KoV2JWXiOXKpIShE5MddZd3Py3k5E49B6CBZ6UFA
	UFvWPKEWJwMLSB3RjFzOUlnnSewfC/I=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45610582d07so39406855e9.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753827233; x=1754432033; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k4TdMm0dqbyPQgLDNL4WQ//dsNOz2sMfofhnU8OFQgg=;
        b=AjnndyAYfotMw+JFfp4bsT903PkBKQWcQ6ccsgkz1XjyZqIrK3CZazlnuJy4lC+K6t
         hXcX6gj8IMrmeSpweos2lsF5QDEpcekctHSmpQYBs0jiE0Srnsm02IiOEPv4wzVMXb7I
         az8nOZ5drv86JJM4TpLZ06X2vJWfD+efQsVnAyez6avIciE07DM9H4hJxPzNCg085gfR
         9EhtAKkDUF5v/vNhmB7aU5vgE2ayYkTszszYapq9ZfQAXYgJirHjEq1DdSPB+dRPBmP5
         kKf8/eu4x5ycqaFDcedOuBz0xKGYh6lldi9ZRrZz5mhReR8gNaHiOqFwjZEjhZyYAxWI
         Y2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753827233; x=1754432033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k4TdMm0dqbyPQgLDNL4WQ//dsNOz2sMfofhnU8OFQgg=;
        b=msg1OiAeXU9a97Y6jUV6dGBa+GpQ2UzLaeehcfgJcP3o+UODL9tjTGe3Kyywb5jhDn
         ISRlFxdLXiXP8m9inHhSvtBEXTs4G6XhY0zYN6ef2VJXaN0BLt40tNeuFmTEn2ewd0yg
         hj46QV+YWAFm2sx60/jebbyLPsEb6SQMZjdFd8EFOZ6ULG+l2H/LLVg2iIW5a/ZbMcw/
         +KsRqxACm+ZEowbRE7Bvglp/cgu+VUhRf44N7yW1pp6wzC63LjsUWQL7rWoEAuT3nOIE
         uwWHsXEmuIwPlf4Rgl8AsK2PQNzPbKiNwDXNra1hdr3uGAd2tH3lHufjkYWg2gUELQkE
         kJMA==
X-Forwarded-Encrypted: i=1; AJvYcCX7TYgDKW5qiPLeVuwYOgH0T12B/Oe/H+54baZeGg7WFhfbTCspyOncSCvq2p/Ve913dmva4BcXPQ==@kvack.org
X-Gm-Message-State: AOJu0Yyy7tfhky4ac7m99WjQq34GOJYLDV/lseROyHiM6eG1xoQ9gMZf
	jNlndK6MahNO+EAYjpnJ9D0+bHt5VNlETqY9Y+8vuSXxelRNVVHqh3nN
X-Gm-Gg: ASbGncvNnxtvcdJX7RGkQaBTX7X/m+xtURncgJaDn5rfL3FF4ekIRBIlnEJdncRS44n
	eLiqHDgIy/zSkZWNiJxsVtPbSnuQybIhfYN5IzdRKrdouqw3zmoTZ9hC+3TraJmdvC8DxjdzPrN
	t9OTXKLNXWe91Re35FXzvSRIHwhj42+5060SZbEs6YWWvmylg0QPRYsxf0D3xu3iCWhnlPxFpIX
	83jQcxAJbWD9dQQTJ29ql3IX3PLW0kG0OwwGviN3VOZDDqBfJTL8yQvsPJ+fi23G7YdHuVpTGm4
	3QLhpjxGD3cc0IjoKKL21rPuwEXsKCj4HU2o4f5fsi7sRzfE9yhQUvL964+8iybQauqcbf7PwVw
	zNsofid+AqHB32p4pUWkYGl6Q9fF/mH9zJDnf0eZvHOfT+ppTGkrK1EhJ0oMVKkWnEG/HSWo5UL
	rmEPcb2ffId8kShePpIPUC
X-Google-Smtp-Source: AGHT+IEeWIQxoNPjyhb0qgajHm83bwS2o4UYVKQz54yvj8B5BNWBgnOWxAGCs5O9lSHAl/LE7QHulA==
X-Received: by 2002:a05:600c:1d22:b0:453:23fe:ca86 with SMTP id 5b1f17b1804b1-45892b95320mr11780725e9.4.1753827232385;
        Tue, 29 Jul 2025 15:13:52 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953778c9sm2629375e9.14.2025.07.29.15.13.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 15:13:51 -0700 (PDT)
Message-ID: <4dc95e54-e0ef-4919-973a-748845897ef9@gmail.com>
Date: Tue, 29 Jul 2025 23:13:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] selftests: prctl: introduce tests for disabling THPs
 completely
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
 <20250725162258.1043176-5-usamaarif642@gmail.com>
 <b9c72ab9-9687-4953-adfe-0a588a6dd0f7@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <b9c72ab9-9687-4953-adfe-0a588a6dd0f7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62ABB8000B
X-Stat-Signature: 9q3y7ffhxdsskpz7y9xu8pnm1qkk9w8n
X-Rspam-User: 
X-HE-Tag: 1753827234-197476
X-HE-Meta: U2FsdGVkX189Bo0PZY9Eadh76N5ojJt5S7uX4yVIq72IW52EEM3KRG0xF/HxTv0I7MZNt20LVv6L+0WcYE1LMoIyinod101gXKNYu+dyoRcAPYVK460rCQg334UA350Dp3aCzjNXQYeqJZStiZQWL6aidEr2VJC/cpMJ11A6aL2rBslhU0hBRoIogT2Z62lI9O0d3ah58a/GqQ12Wk/EhECDlpaZR3TUGwbeIP1kMhLhlzdF+8CNUX7ToBrjWqE7kSqHlgDWqNPC+4ggPy5ihNBsRmSjSUu9o5UABysjLjfMu+T5DjSpM5UuMNEkDfg99V7ewOgvb1mZLPBAdqifAs53GeTs0Dwx50Pw+xBa8/c6a78SJDjZ1H/U5iepTq3Oct9NyjqlQG6HtboUeMj2XY0S2QEiQF3AB/G+o8T/PZ3X3miLqTN7kOY7zG+s6+rMnR1A8jZWHWUGeWSsAuCfJ55t+3YIC3uYlHxn9DAe25sMbAUaLrY5zV8TiCjm8MXesTYA+IT/BtYw5CiJcX4KFwX5g2kAvzcsvCP6YzFDqY8rsATDpEyluPG4AOxH7U72+8EFurY62TnlyHa03UqCyzRLnhWxm/W1kR1dEnyOsOL+KRFBA0TvjbrBC/JLQDsdjtyZ4NFrBmhXGqmDgIa/0ciy94yKVFnKNIz3SpqxbqbyxWMT0QpDuxe/2SOUdmL1w9gG88TB5j6V28PvLMupCrNNUkb+oZwuy+Uj76j2IVjNBGwKYzxG9WAYyNGqXYzNj1TsMaGDAi9V3lW2KRmmwiFg0JlwVROuJMhuBaUgEHGF3FG5RzjQRrEQvNmxluVXY2g/z4AX5dQF/pdXGwd7CH4uEELCK/WGbZAyTxDzr1B6aGkb9+raPgOYb1mVgZsmd/vFunG8cC9Li7W2btttyf7y57W5dH4DNAC+HbWy+57QO5xuIy9bPSJUfc7AJsbwBpWsOClHouWlNjrrLvd
 Vrx20yil
 0bA+g9N8kyPP/3/biViAKaZuD2iH5ZQjG/3Ks+wwQVVaVR8RzmVuCnCYw03r9I6WkF+kvpHzPPE6HMEoOxCzQ7UEOrA3qPGPDICKBRE9GbVrcC4aPGxmwfdDv0GRI+w1+pUKa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +
>> +    self->pmdsize = read_pmd_pagesize();
>> +    if (!self->pmdsize)
>> +        SKIP(return, "Unable to read PMD size\n");
>> +
>> +    thp_read_settings(&self->settings);
>> +    self->settings.thp_enabled = THP_MADVISE;
>> +    self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
>> +    thp_save_settings();
>> +    thp_push_settings(&self->settings);
> 
> push without pop, should that be alarming? :)
> 
> Can we just use thp_write_settings()? (not sure why that push/pop is required ... is it?)
> 

Thanks for the reviews!
Ack on the previous comments, I have fixed them and will include in next revision.
Yes, I think we can replace thp_push_settings with thp_write_settings.

For this, I actually just copied what cow.c and uffd-wp-mremap.c are doing :)

You can see in these 2 files that we do [1]
- thp_read_settings / thp_save_settings
- thp_push_settings

Than we run the experiment

and at the end we do [2]
- thp_restore_settings

i.e. there is no pop.

I think we can change the thp_push_settings to thp_write_settings in [3] and [4] as well?
I can fix and test it if it makes sense. It should prevent people like me from making a
similar mistake when they just copy from it :)

[1] https://elixir.bootlin.com/linux/v6.16/source/tools/testing/selftests/mm/cow.c#L1884
[2] https://elixir.bootlin.com/linux/v6.16/source/tools/testing/selftests/mm/cow.c#L1911 
[3] https://elixir.bootlin.com/linux/v6.16/source/tools/testing/selftests/mm/cow.c#L1886
[4] https://elixir.bootlin.com/linux/v6.16/source/tools/testing/selftests/mm/uffd-wp-mremap.c#L355


>> +}
>> +
>> +FIXTURE_TEARDOWN(prctl_thp_disable_completely)
>> +{> +    thp_restore_settings();
>> +}
>> +
>> +/* prctl_thp_disable_except_madvise fixture sets system THP setting to madvise */
>> +static void prctl_thp_disable_completely(struct __test_metadata *const _metadata,
>> +                     size_t pmdsize)
>> +{
>> +    int res = 0;
>> +
>> +    res = prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL);
>> +    ASSERT_EQ(res, 1);
>> +
>> +    /* global = madvise, process = never, we shouldn't get HPs even with madvise */
> 
> s/HPs/THPs/
> 
>> +    res = test_mmap_thp(NONE, pmdsize);
>> +    ASSERT_EQ(res, 0);
>> +
>> +    res = test_mmap_thp(HUGE, pmdsize);
>> +    ASSERT_EQ(res, 0);
>> +
>> +    res = test_mmap_thp(COLLAPSE, pmdsize);
>> +    ASSERT_EQ(res, 0);
>> +
>> +    /* Reset to system policy */
>> +    res =  prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL);
>> +    ASSERT_EQ(res, 0);
>> +
>> +    /* global = madvise */
>> +    res = test_mmap_thp(NONE, pmdsize);
>> +    ASSERT_EQ(res, 0);
>> +
>> +    res = test_mmap_thp(HUGE, pmdsize);
>> +    ASSERT_EQ(res, 1);
>> +
>> +    res = test_mmap_thp(COLLAPSE, pmdsize);
>> +    ASSERT_EQ(res, 1);
> 
> 
> Makes me wonder: should we test for global=always and global=always?

Do you mean global=madvise and global=always?> 
> (or simply for all possible values, including global=never if easily possible?)
> 
> At least testing with global=always should exercise more possible paths
> than global=always (esp., test_mmap_thp(NONE, pmdsize) which would
> never apply in madvise mode).
> 

lol I think over here as well you meant madvise in the 2nd instance.

I was just looking at other selftests and I saw FIXTURE_VARIANT_ADD, I think we can
use that to do it without replicating too much code. Let me see if I
can use that and do it for never, madvise and always. If it doesnt help
there might be some code replication, but that should be ok.

Thanks!





