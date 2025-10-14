Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18191CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723628E010E; Tue, 14 Oct 2025 08:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3C48E000D; Tue, 14 Oct 2025 08:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C448E010E; Tue, 14 Oct 2025 08:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4652C8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:59:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F05404740B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:59:38 +0000 (UTC)
X-FDA: 83996726436.14.DEB2ED4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9714480010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:59:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fE7WpIla;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760446776; a=rsa-sha256;
	cv=none;
	b=soAmYVYjBKWW1hTLsLSJYLxS/OxveiqY7oL58GsFMpHijmM4FvCmPpdLy5YmvzHWe0fChf
	PZJuh10DS3RANbQSzcIg0ox+CSPTBB2MwYiXqJhnWiz3HeZSj6ITWzZQeJHyb11YPja/UF
	aXKt7AlzaqpJF3dJ/FYhLTSCRY/4Ljw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fE7WpIla;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760446776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iu1mp0L5rze+u9w9cyraP7Gulphe1rkUj/3PhF2TPeI=;
	b=ozR68TXPaVCrAqtywPyESH5XhnQECY9vQKfC7TsWR7n8r3gQMPk2gmS1Gf9w3h7vRSllaE
	rNBnD9uvmAXelvHDupI6Mr1/egAIk+7+DAUkT91CEO9xYxfcWBhLqJC4/uURasQuZIaZF1
	Hp68xVWm0dp7p4uhcw7gAPpr0jXrUk0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760446776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iu1mp0L5rze+u9w9cyraP7Gulphe1rkUj/3PhF2TPeI=;
	b=fE7WpIlakWZwps2+YaDVY+FR1rNRxqJLxOBqbVSE6laOW+vmPFI7csfxfLu640vwMF4/29
	32Vq5R8LLSSc/DZQfcpovRo9NCdMkB5yFginQTwYv14lgJXFu0J0mbMOLyENRD2nj/XjHx
	YqfQ0+/jYc9FjN5UHIXUrG2OF+UgP64=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-bA5NT-LlM_qPJ2Om0TJHpw-1; Tue, 14 Oct 2025 08:59:34 -0400
X-MC-Unique: bA5NT-LlM_qPJ2Om0TJHpw-1
X-Mimecast-MFC-AGG-ID: bA5NT-LlM_qPJ2Om0TJHpw_1760446773
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-63359dd377cso7663075a12.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:59:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446773; x=1761051573;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iu1mp0L5rze+u9w9cyraP7Gulphe1rkUj/3PhF2TPeI=;
        b=PIwqDU9eOVCgBuJs4htRfPoGhSKthKVauD7fHxI5WU6SOXrK1PqOHnToOXQgDG8515
         ovQQyMY4E9rqapvCAG328COUbMV7E+CxyPKz0nRsr2dUqACmaVxyA+fgDXAT+XLUKzVc
         jDnZs05kLdL2g92yx91cozWrNF4EAnjBEJw2uhUKsqBuKwMY+zyhLYkcW/O75/lZ0zIY
         ybT/aeHlvW4StrF5lOzPtMCk25PSN1Xi1HJXTj0mE0bUIl6OWI8XL3VDxxWP2ZyhHt83
         wU0dYXKpFRHg1GXDAoLogGLHyTGyYfwB0DAd1PFLvSLSc4S+ZHwIv0ouOlvZps2L9kKX
         eXcw==
X-Forwarded-Encrypted: i=1; AJvYcCVbMrIhUpAI2548Caz42fLxZg9pX1Y7oAkQoWbHNRNVaVaLP8J6wIvkWLGYKUqHN7ROAjgTjxZ5cw==@kvack.org
X-Gm-Message-State: AOJu0Yyq5cS+fTRIN7JbQcBdUXMIx607M+mGUG+H6GWCN9s7c7+YwYi4
	hdCjKAzRjf1FwuKZH18k0xw61o8ldqWJ9MzOC3H4CHdLLJX6ZR4/j1RevntcgyCGmU7S83UAp0N
	Kvc46k1wjBvCn3OoxSxoUcPzEyUhik7F7geprmJ/a3A30zqBM9GKf
X-Gm-Gg: ASbGncshLUMT7MqRWznx7o5OpkYV0KZVo979J6YIj7i3CEE8L9caBr3oFhETCDKrs5r
	/QPHZrr/k6cGO6ZPw17Wij7kbct/CxtmYWg64VAdiUfFtPcxOMIpNS2TtrRKKwQasJzWcrUH337
	MD+pbuwX3SAgYn37lGeyOZjPwF7bNeeHB0kV4WCsq/A/jI/ivz1tEzrgduiKoAHj86juxg3/JE8
	gAUlJ0ZztVuoIWSKxjBjiup0ZuEwI9xKqzctuMfkIhMitju8l33OnXaWXOFwq3Tpk8wj/XnhNWr
	zRPaENdfXzGCYI+QvPbqXHWSFJqrM26GSGtiDySJTkYQau4ZagCAN6CgQBDa7oXFOOBV2eechQ=
	=
X-Received: by 2002:a17:906:f5a5:b0:b29:c2ae:78f8 with SMTP id a640c23a62f3a-b50ac5d08bamr2706964366b.46.1760446773188;
        Tue, 14 Oct 2025 05:59:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkEiy+cHw9UIH18Z36gnOBTWV4pz/7vpgUvMjb/aSdBKnsv8qXvi1i95BnCc/gOYElOXfN6Q==
X-Received: by 2002:a17:906:f5a5:b0:b29:c2ae:78f8 with SMTP id a640c23a62f3a-b50ac5d08bamr2706957766b.46.1760446772515;
        Tue, 14 Oct 2025 05:59:32 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b58244d17e1sm725071566b.75.2025.10.14.05.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 05:59:31 -0700 (PDT)
Message-ID: <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
Date: Tue, 14 Oct 2025 14:59:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/20] mm: stop maintaining the per-page mapcount of
 large folios (CONFIG_NO_PAGE_MAPCOUNT)
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Tejun Heo <tj@kernel.org>,
 Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Muchun Song <muchun.song@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
References: <20250303163014.1128035-1-david@redhat.com>
 <20250303163014.1128035-21-david@redhat.com>
 <20251014122335.dpyk5advbkioojnm@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014122335.dpyk5advbkioojnm@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DRZh_-gFhU8nmQ8WKw-WATtQwQs2kbTN1-T4lvUyt3Q_1760446773
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gyr87en8m8yo48cqdhc8qjp8w6nqpzwz
X-Rspamd-Queue-Id: 9714480010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760446776-753040
X-HE-Meta: U2FsdGVkX18C2ILO7XW2IEMWGxB1nccvuhJVifJS4dq3XzafXl2mmEwdX58UUpVz/1DuCyJ/P8nvUr7kTPSjIFYmm8D10w77G015lLXLCyM0kzJaCG1P5t9vXltebm/ULf1DqZ8aCTPi1Rxy4sWOw3ekOtC4UItic8OXUyGQkSgEkAHJj5cUsjHOS1rAGu8SyDriskALEICg1Pi7hYlEEIMW5A9DzljxGFSOUdE+KNHQfz43jp8cefRLEnEJSUmW4OsWliL96MVkRR+iMAPGmSYTgWL+73a5PfKmPSWzU/XBlXU5KUTy3Bpidx92tncPIMJO7ylrQTqb9LtJc3d1Y/soOhTCR6YQI1PXtKpRZAj0kqpGI9VSEo1jxpPZ0KKY0CoOsl2sP2dnNOAhSJddLRHOexYrhNueFXqBmm5wfQzUzHVM/C3Dfb9qIJYp8mRS8U1cWxoVLsjktDqhQ1ajiXRYaGBEqttckcTN4RVH1wtY+K6OA4OI9ejMp8VET+i/bxsy5eaPZWsLr27TQoPaI0wQb7O0mZwQ6nQ8f/DnHLLbd7rVygIoZWqZ8SdQntJIC35C05ivN0ZjlgLDQ/rBWddJvMk+TtyyF9OoMjGkvo7aRjYjq5Z0vIrOa5lfWTTZ/khvYxjjKEDhbXG45kVICK7WWZKWVnsB8Wo0PXhWYcx9Ibihtgz44y/sqVgdG3NhvRk1jQ2pZO2LXnsDSr1BMSGxQAqpUpOS4SaoAOYldDwznDK1InUjoUSTz7Wz3sT4++7mfX9ECZhbKhmrNnQvHnLkH2L+fMGzsHXBIQ3uyo3zTlSiwZw5ZVJtnQ8aV6KAx6jWqbix27JIebuF3GuMmbl8tl/aHRyfl3XgwP9AoO1wpfwcl2EmtDFt57B99ZyxMOydq8+lSwPEfPR3C3vyclJ78LMGfXdSe1m9aE911lU4ZO2wUxn3mmflsa62sWQYFWxniy/WT9M2ZoxLCYo
 iXWF8EOG
 wufA45AbUapJbnumLkDWeIsTE3aEQc1aJYpObpvC2HBoaddKpsH+nNoDPDeQNArLUOHu0MuB61Lyzawt7Sf9JjrRUCqfU4XIgVVttnNG2G3HxwX8frYKTym5zYMpdfMMrwLBL09ENr83l9EKP0H+6i2U67t6Eyf+B8PHpCk626Y8M5k6ePhp9VNySosUnJ6Zy6VlPCHjPQk0mxWrNOlWqMu+U7eNjcbgRNK6HxSrPckUaOuXcY4OplSNzUYKg/++jRTDIDAGEPWFtKPw61SdVpEbw9MbyUmtxHD2tuWzdrwyYyGLO7KHaX29NNeJ8b3rWkRHotfgcozpBj9nscPwKZAplEiQQ/cg0zcWJSkUAoSAjOwg/5oXi7fMK3njucWFk0HmjWij7Nwm8VGlIuqmuX5LZAFGvtCjCG7ciMjtSu9mymltSa7kksedrX0ZNSWmkrTQuJsS2TbT6e8y3XcKkCXR9pYIjmJ9T1NTLaU8XEwgtOhJuKT+S8FvEpMv26A1SN2vlkwY5ZyI/kXrZWu5rI5LSv4tXd9RZVrVpGEqEvJoyATnGmsR5Bjy8xppPagjPqFmwsNqlQ9ofCDF2so+uqhhc2r0vrzvXwxAgObFPN0pRlUroanumvJewiR09TF6Hbk0jGDkZEzBOj7nuIU3Zy8H3MbuKkbBUNkNnkvQcJdvDGik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 14:23, Wei Yang wrote:
> On Mon, Mar 03, 2025 at 05:30:13PM +0100, David Hildenbrand wrote:
> [...]
>> @@ -1678,6 +1726,22 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>> 		break;
>> 	case RMAP_LEVEL_PMD:
>> 	case RMAP_LEVEL_PUD:
>> +		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
>> +			last = atomic_add_negative(-1, &folio->_entire_mapcount);
>> +			if (level == RMAP_LEVEL_PMD && last)
>> +				nr_pmdmapped = folio_large_nr_pages(folio);
>> +			nr = folio_dec_return_large_mapcount(folio, vma);
>> +			if (!nr) {
>> +				/* Now completely unmapped. */
>> +				nr = folio_large_nr_pages(folio);
>> +			} else {
>> +				partially_mapped = last &&
>> +						   nr < folio_large_nr_pages(folio);
> 
> Hi, David

Hi!

> 
> Do you think this is better to be?
> 
> 	partially_mapped = last && nr < nr_pmdmapped;

I see what you mean, it would be similar to the CONFIG_PAGE_MAPCOUNT 
case below.

But probably it could then be

	partially_mapped = nr < nr_pmdmapped;

because nr_pmdmapped is only set when "last = true".

I'm not sure if there is a good reason to change it at this point 
though. Smells like a micro-optimization for PUD, which we probably 
shouldn't worry about.

> 
> As commit 349994cf61e6 mentioned, we don't support partially mapped PUD-sized
> folio yet.

We do support partially mapped PUD-sized folios I think, but not 
anonymous PUD-sized folios.

So consequently the partially_mapped variable will never really be used 
later on, because the folio_test_anon() will never hit in the PUD case.

-- 
Cheers

David / dhildenb


