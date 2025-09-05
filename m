Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F365CCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B88C8E0014; Fri,  5 Sep 2025 06:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590708E000A; Fri,  5 Sep 2025 06:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EDC8E0014; Fri,  5 Sep 2025 06:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 337478E000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:33:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCFD55A43F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:33:41 +0000 (UTC)
X-FDA: 83854835442.29.5172B6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6585220013
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:33:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h4LIcST+;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757068418; a=rsa-sha256;
	cv=none;
	b=Q+XWcrZGfRV3VeQDE0pB5tr9vnxi+WXD27FnmhbJNLJjGYKBH3p2n9nlhArvK/LsAmZwrM
	b8u4VFJ3Smhg6OocuZLCwbfBTViJ7DFpzcykkR1ls+BksZ2PhAPCeaKAXM2/GNRwZFgaWG
	SAc+4GyEzJ5jg5qK9V/8FWuqUoQGBuU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h4LIcST+;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQgs/3HrvAUkuZhiM/w117t1HP5n68Ybq25rj7wytOw=;
	b=v+H4kCFmBGBcxBIC8FVq+rPshzOTyqqk5BZ4atXpLlPMSZbOJ1FzBaQ1yl073BkUnxGN5A
	wMT6RBw17pxycgfRHHDsUJattiZarSp/DgTWzyQ5F4Y8BJhU05SAtQBSGhPdIy2VWbc2z1
	jKI9lCQzPv9nIwDTG0E7veyTrZG7Yso=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757068417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gQgs/3HrvAUkuZhiM/w117t1HP5n68Ybq25rj7wytOw=;
	b=h4LIcST+G9ks+6uR3MrxM9UCipDn6jM+0gjn6quOhOgBCyctWzEOZ2IXqJ4Uwkm3OIeBRV
	kuoIOsYsK3gdz3uZtD8JWWN7NuPAilEz/Oj+tcg2Tl1bKYk+8x6jEY4cHv/69N2Kp0Ls96
	exeX39mKIPq9g9Y+0spSnJRJTqy6ivg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-uWyl6q9_PKCZumJTLix61w-1; Fri, 05 Sep 2025 06:33:36 -0400
X-MC-Unique: uWyl6q9_PKCZumJTLix61w-1
X-Mimecast-MFC-AGG-ID: uWyl6q9_PKCZumJTLix61w_1757068415
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b8f4c2f7fso14870555e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 03:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757068415; x=1757673215;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gQgs/3HrvAUkuZhiM/w117t1HP5n68Ybq25rj7wytOw=;
        b=F6pYn7wscM89bfwkM9OsfgTdN8SjLjhffGLMY3e/GfOA/3IHXZ4AOPnwEz0O3pRLI3
         xJ7EdXyvzisxIRAKKyXo+M1DdIdXRJJgxb+HVoVtaB0t1Mqrgjs4tTAtgLQ7TULU6gB4
         WDi5dNXeRTd6rqGW2vR/hUIjf+KLMD4n0MmYbKO9ysDWS6nFag1BETqnYTpZa04wUbae
         Cwf466Eap5vDgQpkmafqvnC4rmRlheYmXceeKGuT9zESaM+8Rg1mPXq3yBuSUSVyUSmy
         Ub41+9yUTwkkBPZcVxXtVcs9klPoZYZhyqBC+pDbS8U0ze5WzDc8K4cSokB+u9ObYFz3
         sA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCU+Sv3FSGaRw88ZC+XAOrG9xrumAdejpzvxtKr6ibR7edosop73ks333hTqW8ezMyoHv+W1j6Xj4A==@kvack.org
X-Gm-Message-State: AOJu0YyqVNlP2z5GUwJ6NWG9rFWSA/B/h3vthC/U7LBdbdpIsk7CqByo
	mkYlWHJIwBgSwoe2sJ/qEScbzbebXYs6ixx1H7wlrdwTHKM6EJ2waxGKAt7kdMgdYvrAlQgS0jn
	JjcURQ624sDTYoHdwHrMnI5DS7nEAVWQJHTlDRNv4Iyu4iGRIyec7
X-Gm-Gg: ASbGnctAnSWxqe/iWfrqwxq0HSHeL6NyYhoTpq/cmZIVjw+dTLa5o5QXR9Q/gZFfuml
	EJxqMJMZG06F4tDKuC3MTkJGFcaRqBpRdWvwRmqO3tPD+vq4HmOlL29x/iPLrBJg4mltmkzv9rC
	wNyXQpd9A0Hum/BM0FVTi/JvcRrs/FOdf1dP6ehJGwK4K6kOw2NUV/xQ8sxh3Oo3zWEOiBL0PhO
	qAZHHSblLhdFRcr366qwWhYjqCmq0+NngOOURCRY2j77lBQLsqyW0bxjFvmlSvcsqkWDHKV7U50
	mA/EOCG/lb7O3haPr7WOe6hkYy9fCHVWjW7xtyxRlA5t8x4OZf3s3JQDGh97k8cTUVkz5IlkkGT
	JfxoA339xGlcKt3j23oEvqdT7Ata9f9d+NGk/4SB3qVUZzfe+CJloOJp0
X-Received: by 2002:a05:600c:458d:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-45cb6fa37f7mr73935275e9.18.1757068415051;
        Fri, 05 Sep 2025 03:33:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEa5WRrGLRX+nHmMkv4q2cQukmMwtqR0R4mvuVufNv0W8Xek4p268RKrGRh7Rgwgou/eV15rA==
X-Received: by 2002:a05:600c:458d:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-45cb6fa37f7mr73934975e9.18.1757068414610;
        Fri, 05 Sep 2025 03:33:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9bcda91dsm154106695e9.6.2025.09.05.03.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 03:33:33 -0700 (PDT)
Message-ID: <15e8b5a2-9b08-4f3b-b174-535eef6dadf1@redhat.com>
Date: Fri, 5 Sep 2025 12:33:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: Add madvise tool
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <b411522c-db48-4793-929e-2b80715e9cce@redhat.com>
 <zmueckzkhbfb2fgienlycsl7niedwvccqurlry3udfsjjw2lmq@6ujjt7oo2hzh>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <zmueckzkhbfb2fgienlycsl7niedwvccqurlry3udfsjjw2lmq@6ujjt7oo2hzh>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8j5ze_utEg14zBJ3pmykNz1-shif_61d9eQ5JamuXgA_1757068415
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6585220013
X-Stat-Signature: ou1csrd6rnu1x5bmithywbc9agyygobc
X-Rspam-User: 
X-HE-Tag: 1757068418-169398
X-HE-Meta: U2FsdGVkX1+AQJb5EC5miQ18rEzM4ZDcelKusBJRNPxVY/zQeb00dG/mIdfADXBeeGWGSyuPWoN0AvR4e1w1akc23vpxpmCAfiNsVhGtL3zKXcppvbXtHeW+lfGHR2u+PBlyiLKePStXF1qf3KnQsZJ78w7OnKpAuc5DVcCsfH9AqHuFq6TtsEJo5ekLgP3qg/qmbmw9q40ReAl9nIRWE7ehDR9adfcb9xr73CcL/jtHsdBwMNCw2OeEBoka0gDwwULbccSF3Ks9jrX/dFbdZeof4Jijj7PM/bxZq2S1STvNb+wGQkGlw2urZRzpityZHBh+9TE/Z/4v66aLA1CJ72gxWr39jtvk4tAFm23559HCo4fyn43oo3AAcxL77AZWjHFJYyAHzjxGgzpTDIvIV37Y3LRWFWIZVCUvfr251NpfX+AVPsIhkllcB48g79I/aHckdfmCtGcFIIp+GKnjtrEDQtx8priEfe9zsgdZZiFu3AWl/SS9vp25Ruqnfwpu97BVv9RkQlTVBZ7YNBYTu6kbGxEpP0IpDy2xASGaJzR5oQa42vbcqD6+cl+KqzBePCnDPQrWuiPS3U92/xdppjYU3JUoUt+K04Y90Kuxgg3uuNos1QCmPq8yaW/0x5rLSgymK7Gku+oZw3wunxfDXeyfa6kngTuIFv6OPWm9EZrbhqKL8Q++bjEojgca7z0UW0ksZ+XE0mEBY+dXRtiMkvtYbii51hkDszre0ucZoc/UAfRrYpRDkHAnRsWIP5/rxFNu2VqWhTdpaaDUKcJd30xtrqvP75MC/nBUiHxHhDdflsaO5LfmH53bM//ZMRJZUOhedFP2UYKejQae2rbv41CQeXzclTxmy9gKkPBdGZqQU/9Ce0qg3Z7QKatSbA1FuTSO4nrvelpd4qkxxfzaQSKAMTuHPkY1zcJe7/RtOujiyF6YAPVReVHbdvgu7uQ95RzrESiW93dRNyuUcHh
 CfGO5Oy4
 V+pusD0FVBnyy2AmstO5LplomaY0hGekGKePZC2zPOh6ImltnSfJpO6wDcD1PeSl4n7v+3q8ux2Q6e0tqZll3n3W6JawXOvddI/ukc3qTc+yjJaAS/p2ensYjwNxYePaRhYbk4HaBxccVnTkH2ZloZgQnYZNxUWrt/aJoZOQwQ9uBreggi1+DJgdrGZCbFhb/XxxR2FwBWgOG24yaLvf/fP7+USpyGKpx7Jujz0ughIUk06mJvtQxTHf4lq9QMFBx5t6spJfDpGUrIMWqjEbpN7sKcGPgAKD4ws1UMWfdaw81MYCQUMNA8D93K+5TwtSV2JMxIxpAiKuJeCoph9P/VI+C2uqMEieuOvbutLk98zhQVM6XK3vNLhwkGeZL450gOZ3V8/QU9y0RuCOxGyK5Y5CxHh7FMrf4DTwtTbDkwhPJWnhFunAn5kPQ9DlXfTyaMe3We+7SgwhctOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 12:24, Kiryl Shutsemau wrote:
> On Fri, Sep 05, 2025 at 12:19:11PM +0200, David Hildenbrand wrote:
>> On 04.09.25 19:57, kirill@shutemov.name wrote:
>>> From: Kiryl Shutsemau <kas@kernel.org>
>>>
>>> Add a simple tool that allows to issue an advice on a process or a file.
>>>
>>> It can be useful to experiment with effects of an advice on a workload
>>> without modifying the workload itself.
>>>
>>> Only supports advices available for process_madvise().
>>>
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>
>>> +	if (pid) {
>>> +		struct iovec vec = {
>>> +			.iov_base = (void *)start,
>>> +			.iov_len = end - start,
>>> +		};
>>> +		ssize_t ret;
>>> +
>>> +		ret = process_madvise(fd, &vec, 1, advice, 0);
>>> +		if (ret < 0)
>>> +			perror("process_madvise"), exit(-1);
>>> +
>>> +		if ((unsigned long)ret != end - start)
>>> +			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);
>>> +	} else {
>>> +		unsigned long addr, hpage_pmd_size;
>>> +		void *p;
>>> +		int ret;
>>> +
>>> +		hpage_pmd_size = read_pmd_pagesize();
>>> +		if (!hpage_pmd_size) {
>>> +			printf("Reading PMD pagesize failed");
>>> +			exit(-1);
>>> +		}
>>> +
>>> +		// Allocate virtual address space to align the target mmap to PMD size
>>> +		// Some advices require this.
>>
>> I assume the kernel coding-style applies to tools/ as well, so
>>
>> /*
>>   * ...
>>   */
> 
> I thought C99 comments are fine now, no? Like slab_common.c uses them.

Was there a recent discussion around that?

Coding style says "The preferred style for long (multi-line) comments is:"

slab_common.c seems to be the mostly the only thing in MM, for some 
weird reason (and it's even being inconsistent).

So please, just default to /* for MM stuff unless there is a pretty good 
reason not to.

-- 
Cheers

David / dhildenb


