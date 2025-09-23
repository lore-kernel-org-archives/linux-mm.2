Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D59CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E89B8E0006; Tue, 23 Sep 2025 12:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199858E0001; Tue, 23 Sep 2025 12:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061478E0006; Tue, 23 Sep 2025 12:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E4F938E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:40:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 981F9C020C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:40:18 +0000 (UTC)
X-FDA: 83921077716.11.B8BF670
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28C25C0002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:40:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ezK7pops;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758645616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1QkzrTGCwMnovMp2G8JNLttd8EAbqBA5tlzUuHhOxE=;
	b=YQCyMJN4M1hpC1ATbeOPcxesBsHBpwLu7vIFWFgz1rBDm7QJUDN9cTnpvNxTiXTGlHGIuV
	TEwVva9hkIgr3ItqRNToXYvhsu29UOjIzcmOa/EpozkZpL5Q8kilJ79sfQz1jCK02IlFV3
	/fhQAbup7q2zcxDsrNnGBmWjgUZZDCI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758645616; a=rsa-sha256;
	cv=none;
	b=zokfbhtiiVQunYenQrpv2jpqR5SSCdOuhAmr1wO9n1wKeftZXfXv+MyQkA4rpaVviUU/uA
	fGkw11sGzishO1+JDK6qvvOPAUnb4Q6B+BrRG4ZQnGw2vawzPZE1xHBvB3gBBcwj9KMq9R
	lCL8mhlWAp37bE4wOF1upmQ9wo+j1xU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ezK7pops;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758645615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L1QkzrTGCwMnovMp2G8JNLttd8EAbqBA5tlzUuHhOxE=;
	b=ezK7popsJ7QgMq3FZPlcHKIY1sML2qu7zTdCPi0xvHj5n2aqJbSBfv61dXVyypJxUJmjZd
	86YPuluLyDQ7gto+o+Q5bRoi4H1toj9rZb3I5cAFrSl6lBRiQuHI6gYoZdadr7LTGVYSSk
	Lmoy7k8hEY+zF9sU9gmLjCM7zxYEExA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-gM3bHDFBPLqFHESitasnyw-1; Tue, 23 Sep 2025 12:40:11 -0400
X-MC-Unique: gM3bHDFBPLqFHESitasnyw-1
X-Mimecast-MFC-AGG-ID: gM3bHDFBPLqFHESitasnyw_1758645610
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ed9557f976so4993722f8f.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758645610; x=1759250410;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L1QkzrTGCwMnovMp2G8JNLttd8EAbqBA5tlzUuHhOxE=;
        b=azc9x91LbFYKMdeWrqA6rObnRLOXZ9dR3myfVLbYClGc/0hAtCNKm3OmzcGs6rGmf1
         8/NDygV0hvNqZpQ89xKHIw6TQ1PqnzD4HccmdTUQCx/mU42r/psRoSOY8hmnJ0p9ukuh
         rx+t6OpaI/d4jpASQDbj2tWMwfX6cbs7SZrYJSJQuIv4C4z5O2UUl3v+ZYB9PMBU8Uig
         mVJ1xFSPh2Wvl70fVSDewf+VOoBRK393jVZqJuUfUC+XCH6At2wLtpz0Rp5YyonMvWtZ
         lU3gdLegYnyYfFJI5BK0AeOwD6NaIqdeTRCQc9OhuVAoxtTZ9W2jnHipNTd38kNfkys2
         vAIg==
X-Forwarded-Encrypted: i=1; AJvYcCWULGKiZxfct3QXbo6bNfw4tXPcyBvlrkirNKRVp+ehLrqAit+MGNtfuGvr7If1d8bUoNvZv+6QGg==@kvack.org
X-Gm-Message-State: AOJu0YyjlNvzrY7RgpdGERGUx93h7HzYkvXkpfPTo8+H8t+g7wFNjW35
	ZAsEnXT/rPlXzwNGeXfG1mdB8DHqunGQ+vhsjt/Omf39RzccH98fJoHcuvi+UZZ/gj7vrVZh8M1
	5Hgvq/b2yw/sKtLo5D+XrJ06Y8cskJ9HuVZ+0KTew2kyvAanBNzG8
X-Gm-Gg: ASbGncvdmsgiUIr18a/6GDNPk9SB+vKwJDaOJh9YRH3kSr8RpMJNjxkwZxBigHTWb4u
	kQPdFmyG0kGdrEnnBA1+1XO7RfTW4ORfcXyqtnNHJQYZMoGt8exXuXLVlZJx90qsfpe29CNsZAB
	UWm+VFPjXndFPfywwxOOJOaoz7PTwY0AovwKSbq7VUbTYl9NCRPts1I/l31Ex5uflMGOz61zGpa
	Ojokdis9EeJp6CqsxbcfKsyX8QWOIBYss/SmNQF02o8vHa6gSGTsjVmmPWJIiLgC6CRYWAIeQ/A
	DsIUG+iz5VJKHQmvXrVqpzVJJoXPQi78M4A/qKoYzAWpUrg5eAXQp2iOI2O+31RhTirdz5mI8Jo
	qxMCLLNt5X1LWzKjAFPfP/98+0AKtXe1bHqJUP7ZYSPezTMJWmq+x0TMOSZybbEQy7g==
X-Received: by 2002:a05:6000:607:b0:3e3:e7a0:1fec with SMTP id ffacd0b85a97d-405c6c1be66mr2624127f8f.16.1758645610488;
        Tue, 23 Sep 2025 09:40:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlBeAzcC62U49+wQ4+N2FLeq7Mpxq7qWokF6XhNbNHyY0QVTf/R3ihiA3HW6AmAgoSQoynKg==
X-Received: by 2002:a05:6000:607:b0:3e3:e7a0:1fec with SMTP id ffacd0b85a97d-405c6c1be66mr2624093f8f.16.1758645609976;
        Tue, 23 Sep 2025 09:40:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3fcb01a9049sm9757269f8f.61.2025.09.23.09.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 09:40:09 -0700 (PDT)
Message-ID: <45a7aa69-16df-4809-8ccd-c08c404d55cb@redhat.com>
Date: Tue, 23 Sep 2025 18:40:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, usamaarif642@gmail.com, yuzhao@google.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 voidice@gmail.com, Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com,
 hannes@cmpxchg.org, kaleshsingh@google.com, npache@redhat.com,
 riel@surriel.com, roman.gushchin@linux.dev, rppt@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, hughd@google.com,
 willy@infradead.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, qun-wei.lin@mediatek.com,
 Andrew.Yang@mediatek.com, casper.li@mediatek.com,
 chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com> <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com> <aNLHexcNI53HQ46A@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNLHexcNI53HQ46A@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z_z2gsc4ixrM_VFf44rs_nwCesecTn75ifuVLSnwJpY_1758645610
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28C25C0002
X-Stat-Signature: 9htpp8bzzpmuxzn5wz4i3jybjxmnkfjk
X-Rspam-User: 
X-HE-Tag: 1758645615-488714
X-HE-Meta: U2FsdGVkX18gy2u+Xkoa61sK90RVrTOK3dxfN2VNkGkc5+RPPjASo+iw4oae7bjpWj3ArbdUgu04ipneuDAW2vRJvq2z81WgTF129C4hLUL7GmEpMErDde5GmIVn909WopCQ/XN7/ykm2XTtkyje88MAo3L4RGxw9jFnhhkg9vwR/HxjBULHV02yzK8i3Sh//ECompzDrNS82oIUxAm2X38IzhrwDJ6ZqFsHo1rTSttsHLfiJk2v301ZtexbFJBzyLecmElr729bhMt0TsowpzZMO+/vkZUASJXqmvoA+rob89n203QmnF6DYmpDUbs/YPFONcvYQEATSUVCSDfv7dIOMGx0paewb6nBtSPX6Lj/FQZ5n6uPnv39K2gIkab/ipMhajUAO+kTBLGaygjPuVxE+H7QC5Juu9Pj9ARIX682i+xW8wigsLA355T2hhrsgJyLTmrnT9nd7lgJK5I2hj97WDceQ0z80Do1C/EP3xhXgGBxNnfAq/hXlPHRMNj7J7yBdDBJVfY+I1IojGqrlHDMwiV9tNaRI939lbpXZM7QXrmO6hKwDlrT3SvREa7zzq/yQx9eciT4MTD0ywzJTfYusAiwDM/yxy8skr8YJkCHFMqYiP3h86ZfUk+pVKHGcJbNk2iQc1OlK3a8fHpGbHn+eeSFf5die0QhrH6sUFvPVNxuWXgLBJ+Xxc1RubF3foRIB2XwkchMDVMke7JpeZ5xRtMrJPEeOspIRv3WVK/ntN5+CSEovy1r8QTvOxhdU69f41ToBN1a1nwH3N/AYOPajrsibAWRPgv+ZuPkcegMbGhQcDyR67e8+Ijc+OEQ4HUHR+j8wMw3hq++d4cFzmgT7UlJSKONTmSKBKWgg77VpIpuXZZNIScLefbrdMvZZieYBy44y3HMfhAeerjwxjw2zt2ihVK536Arz8VgEfS/vhN/6zam9SSrYxuhQs4aM0QmxnXN91XH4txwhJv
 rejNaQU1
 JSGzFsJ3MeZgx2lCa/qS9mvG2yEWlbRYml+Wgg0FRq2r/1j59f/rmThKbc0CzP7YxaV1ukanbY0aXH8FTPYws7Smd9Y3X8Sw+VIEgF9LdzqyDsB8eIfaKoIAG7R108X3hUpGSRGm/rNyEYTaYmLB1Ss66G81xuqpz3iMnhidFW6Dm6AQLW2JG8Qj+5xs3RxoOffN4ic2ojjDA/cyPaUK+OjB/7KddhQyIS5RuwMtfPYmggszEK6IZJWdwWcrkAB63vDKpoKqCGgofVrDWS0+Ljm+5QfBI/D0ALieuxLL4JqNMVzN0DN5hUVP0zlKgRXTBOuQ2Fda+cBjtKAkyN5YJPAafgKlh6HcmCzD9yfSA1jHwLowXGi0fneLOWoe7go2W1pieVgTbhbBWS7i1SP8Uxrl0iXFnv7AaG9yPpfcXALYPx2nPmX2b4dNRgFsRhSiHkENEiPswsZ1+T/K/Ec4b0a5qE4Bkot+KumqYiWb13QlY61abVkqKRoAzqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 18:14, Catalin Marinas wrote:
> On Tue, Sep 23, 2025 at 12:52:06PM +0100, Catalin Marinas wrote:
>> I just realised that on arm64 with MTE we won't get any merging with the
>> zero page even if the user page isn't mapped with PROT_MTE. In
>> cpu_enable_mte() we zero the tags in the zero page and set
>> PG_mte_tagged. The reason is that we want to use the zero page with
>> PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
>> memcmp_pages() messed up KSM merging with the zero page even before this
>> patch.
> [...]
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index e5e773844889..72a1dfc54659 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page *page2)
>>   {
>>   	char *addr1, *addr2;
>>   	int ret;
>> +	bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
>> +	bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
>>   
>>   	addr1 = page_address(page1);
>>   	addr2 = page_address(page2);
>> @@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page *page2)
>>   
>>   	/*
>>   	 * If the page content is identical but at least one of the pages is
>> -	 * tagged, return non-zero to avoid KSM merging. If only one of the
>> -	 * pages is tagged, __set_ptes() may zero or change the tags of the
>> -	 * other page via mte_sync_tags().
>> +	 * tagged, return non-zero to avoid KSM merging. Ignore the zero page
>> +	 * since it is always tagged with the tags cleared.
>>   	 */
>> -	if (page_mte_tagged(page1) || page_mte_tagged(page2))
>> +	if (page1_tagged || page2_tagged)
>>   		return addr1 != addr2;
>>   
>>   	return ret;
> 
> Unrelated to this discussion, I got an internal report that Linux hangs
> during boot with CONFIG_DEFERRED_STRUCT_PAGE_INIT because
> try_page_mte_tagging() locks up on uninitialised page flags.
> 
> Since we (always?) map the zero page as pte_special(), set_pte_at()

Yes. (if pte_special is implemented by the arch of course)

> won't check if the tags have to be initialised, so we can skip the
> PG_mte_tagged altogether. We actually had this code for some time until
> we introduced the pte_special() check in set_pte_at().
> 
> So alternative patch that also fixes the deferred struct page init (on
> the assumptions that the zero page is always mapped as pte_special():
> 

LGTM!

-- 
Cheers

David / dhildenb


