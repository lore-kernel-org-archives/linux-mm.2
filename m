Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF93CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 18:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4B68E0003; Tue, 21 Oct 2025 14:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6188E0002; Tue, 21 Oct 2025 14:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8942E8E0003; Tue, 21 Oct 2025 14:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78D118E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:43:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BAF287A65
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:43:17 +0000 (UTC)
X-FDA: 84022994034.15.33D9667
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 92C0280007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:43:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QFUiTydi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761072194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/1n5Qmv6fUzICSy7SJ2nfo+Y+QoRpq1dX3+wvV2FX4=;
	b=K2AirtTCTwjHtBk+5a5hBgOc1+Je2bSSTuRtJErSNaGtzIhgrSRaMGCocSCtKQFuQi2x24
	if522uA+gkLG83JipU25SnkyoHfEhkwDFV8Vz7GNnGKwYbQByJkRwUuY3Lt2pRMN/23Qaj
	nNcjMVzG45uQWyo0wW/x2yTKNUN5cIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761072194; a=rsa-sha256;
	cv=none;
	b=D4NJM1PB7+0plJLEutWL/hK0s4zd2dS9PPVdYHjS9qWPlvdV9az042Yf/Oywl2b0TY3+cp
	M3kjbYrLpMr4NR4goueczwGlUnWMNoVGp/nXcXHtPPEh09E3BnwFOfchDcTZCBJ21EDK5p
	k+OWUzx01QphpHOqejIcYns2g4a3PRU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QFUiTydi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761072193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4/1n5Qmv6fUzICSy7SJ2nfo+Y+QoRpq1dX3+wvV2FX4=;
	b=QFUiTydi2xdwvKtLBbSkPXPfhxVqOg/ww4e8Bf9GK4C98yOF9txblKnAPjDWa6RMaODw3p
	mVNceFutpVGp7crQWv4sAEAK3aEEpP8e9/F98n87UjJYHHRDtnvf1gJBCj16ZmfTDI+dws
	bxixijqyevKI2Vbfj9nf1//EYuKxTbk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-dGtSSOn4NPaeFQcjgkpYow-1; Tue, 21 Oct 2025 14:43:12 -0400
X-MC-Unique: dGtSSOn4NPaeFQcjgkpYow-1
X-Mimecast-MFC-AGG-ID: dGtSSOn4NPaeFQcjgkpYow_1761072191
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47114018621so30189985e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761072191; x=1761676991;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/1n5Qmv6fUzICSy7SJ2nfo+Y+QoRpq1dX3+wvV2FX4=;
        b=lcp228gE9Y26HS8Z5oKHHcBc6U9Pa/wO7fawsfmmeuNys3tTe/1FQIF3djmYQ83kuP
         2g3CvRRaHCqYmFBCN+hFKrjY6EHQOKMpRS80f1SeYcutTQoQJJUIc7+GsEDu7Ha/UD1e
         XqHdz3ct7Kzr+fGQQnbv2o8aQU5OUgQKyYEUEysUHn1aGBvzPpm/ElIQSuS8zP2IOkoC
         A/q5YWD13zJV008H+TcZeR9O1lgd6pIDh4OSlI+5Em8Y2h33kWaeRJjwY0M2wUvilo5h
         jtvLRA2J+VonU8z40bX39XMYUoIVcBdIqAgiwAksfJmwewPFzk7xysV1ofxuHekjcZWV
         ogvg==
X-Gm-Message-State: AOJu0YyJZBsaKfVIfwy/06nhH19UW8hehon3BoBURv1PKyslAla0KKx0
	O/drfJkBNlYtmCaZuCIUtx9rpo0elk190Xp7iCOvjkoPrSIazlpdRnnQty52GBGvXjgzPTQtV2w
	cO/Cvg7EXVNX+fkOtyEBvIS8hdEOiHv8aJBegnWoHoV0/SjzDrXTh
X-Gm-Gg: ASbGncsrWc8n+poduSJhH3MM07wmT4lt9Z4PV6yJOIVfKteZhG8iF9UBa1LXsW4AYAd
	4cu0lhgGS0Luk+moxAsOwL97AShUbQums+LwmW6vWqixVykgpmsTlxlty+Rynb+u6uoKkYcKk9P
	RRBJcx3TFlAfbcm3r7WQnGKsglOkPvLRn4e3Jdqzk16+s54JU8dmBR4at3oLpr8LppOgk8I0SCi
	wvwITwl+AYbkIIQ99VEgOqSm5JPRcKIicSTdO+nM1ncJ9mv2oPv+ny6YdbByD5vuVei6kWz1atD
	OHvPeWEr+gbaoDf6BmXCFwfk0jJ1Qj63nMnzleuI8CE+cLfLUKwkOBUmy0s2kO29BmYjWsFQyuY
	O8hpL9lymf+4J9wrzxbo3qGNDbzML7ABHnFoKMX22yvtGuApc2dEdy7v8GK4PqSYZKldkji4maU
	1ljPSDR6MdQRMPUBV9esJi+fi9afc=
X-Received: by 2002:a05:600c:444d:b0:471:15bb:ad7f with SMTP id 5b1f17b1804b1-471178b04cfmr118237565e9.17.1761072191194;
        Tue, 21 Oct 2025 11:43:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGF48PaGIZJJ8yDfzibDZrtRJ8BYf6TIUYzgr5nqD6RJbRA6dQ/xlt74jqHg+pveBdy6E8oUw==
X-Received: by 2002:a05:600c:444d:b0:471:15bb:ad7f with SMTP id 5b1f17b1804b1-471178b04cfmr118237325e9.17.1761072190791;
        Tue, 21 Oct 2025 11:43:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c438caeesm4880295e9.18.2025.10.21.11.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 11:43:10 -0700 (PDT)
Message-ID: <5e35a398-af4e-4c54-9285-4202da08f456@redhat.com>
Date: Tue, 21 Oct 2025 20:43:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 20/23] mm/kconfig: make BALLOON_COMPACTION depend on
 MIGRATION
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021150040.498160-1-david@redhat.com>
 <20251021150040.498160-4-david@redhat.com>
 <3ba11b0c-818f-41d5-8885-038c7e0133f5@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3ba11b0c-818f-41d5-8885-038c7e0133f5@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VoxpJF2kYrpZcp1-113s0Yb2b-y4J54E4eZ5wVJgPIQ_1761072191
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: cmboibsue55mi7po1hhdpmz6dam6ano4
X-Rspam-User: 
X-Rspamd-Queue-Id: 92C0280007
X-HE-Tag: 1761072194-905248
X-HE-Meta: U2FsdGVkX1+DmtDqr9/S0CCqwOGNdBasI+66U76eS+B+kHzPuoBsSW86tRB3rKR4QxEbm3ZBG0OtgxUQ+/Hn+XtQuYYGgquXYI+4o1xvf0bJa6mJMcQ97spG0xjSHSd+dCluEY0VyAi14WswG0tLhP2B5wEuqQiSewv0LvqUV2Hovwfr3WvCf4xhLj3nHnMs+wrskYPtak2+HKHUGcCCjLJl+D8JR4Yg2b3T3iq2154SoifEMLiOlXFcuyv8s2ulLm4nEaEYCnuMIDyRjvgfTM/MzJtmp2yudC2bnzy0AQ9vnfT426VCZ2nXyuiD69ssl1wMGdgYxY9jwfR+Fu+p0q8qwUmRpxuGvDwD8UGM05C0fqzUMJpiuGCMJo+W/qBmFJfkwHSjdLP+Sut1PAA+KQwTTd0mOx0YdNi8yvu3B6jgPYwoOri2BIe66POX+9GFfM3N8fVatUhRkT2ouV0kU5s53GyGAIFZD64OCzPRmvRg97j63FxCGLXi2dVC2Kr2Omx0tGvsPjQI9mQugZ7NnetbUql/Bd/QlNoB6TT6CEIdWArmUaVUmUWJ2vKhYj4XtAX9QJnEoZKyGtCKxuHaEQpA2eUqhFzvIix5tVYgGDT7wFCZjkjIuvgxKFegtuCTygA4y1BRFyfTfqpr98a5UNTXjlQbwJ7GvkYR4sMQi89Ad6dbLpcH7px7rD8whk4E7Z8395gq7Beuw7kkDys+ZSJ8HqAu0vAIh/X5QMD3v3D2jEEf6BxjOJeJ99sHF+bQRrUR+Ggxo3DrZO0evMdbXDtLkY0b2UlgHhadO3SGf9edF7zfe3O4KEnvt5tBem7qx0nj467llaSV6Mj5YP5iaQ8OtZH4OPIfIAAdnu4L//pGbPqyajRA+b3FAWn8gd8+Gy6YJ9rWHP7Wl6MySESdjCHxmX2YTvXTecRqZAMS37sANNWcUFYp/9o3U5cpb4P/ktMtxH7VBwVo6aI1aSL
 XR6aS/J/
 4SU+PtA3BojgjGCL9jVBDJroC5dbctO7QC7HuIWz6vG2JXm2a6rj7z2JR79F52Qwyx/1pexl3Ac9c/z5N85LyHj0T78/m2tduWQV0hhFlA7Yin6UlHedZz0mY3lXEl0/fM+9wKN67JA5lVNXSeIiE1+23BTBp03KPUy+r9pjC+5WomPlnWdDplZyS4kCQNZfegXtBFxppWaFkJTlb0Rp+gI63wCyw3+EvzjecqSaJmECrXRB6IBm7vU7u0FhxcgtW95enhfKAVe4tCpg9AbzPuJx16kTyE51DL9O20bF9dgKcYhzL5H0KxFawrzveaUsMucgDVD5O4mfJtplbkY/1NwRPTBbMBRqJbAp4naJ1lsyYLAKIV+bqVj+FBvISyXrOIhxi/NVoKElkznGFswOIyfWzDrcMAKvikUCHjwAjGKDmoi2/9S9+0qYpAPsxAvp8JuPsySdmyjaQHxVhEbffT/7tx1BHbCStD1CFuAwOADfAP0RPmjhyxEi01sykAhMd4wfxiovHTSsf5Esy4RNegt0fpikaqllqPgikCwfu/fXZTPIh2k6syd8lEirxV0jh66KKSSysqCFfWJb7D5GXTiiuzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 19:13, Randy Dunlap wrote:
> 
> 
> On 10/21/25 8:00 AM, David Hildenbrand wrote:
>> Migration support for balloon memory depends on MIGRATION not
>> COMPACTION. Compaction is simply another user of page migration.
>>
>> The last dependency on compaction.c was effectively removed with
>> commit 3d388584d599 ("mm: convert "movable" flag in page->mapping to a
>> page flag"). Ever since, everything for handling movable_ops page
>> migration resides in core migration code.
>>
>> So let's change the dependency and adjust the description +
>> help text.
>>
>> We'll rename BALLOON_COMPACTION separately next.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/Kconfig | 17 +++++++----------
>>   1 file changed, 7 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index e47321051d765..3aff4d05a2d8c 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -599,17 +599,14 @@ config MEMORY_BALLOON
>>   #
>>   # support for memory balloon compaction
>>   config BALLOON_COMPACTION
>> -	bool "Allow for balloon memory compaction/migration"
>> +	bool "Allow for balloon memory migration"
>>   	default y
>> -	depends on COMPACTION && MEMORY_BALLOON
>> -	help
>> -	  Memory fragmentation introduced by ballooning might reduce
>> -	  significantly the number of 2MB contiguous memory blocks that can be
>> -	  used within a guest, thus imposing performance penalties associated
>> -	  with the reduced number of transparent huge pages that could be used
>> -	  by the guest workload. Allowing the compaction & migration for memory
>> -	  pages enlisted as being part of memory balloon devices avoids the
>> -	  scenario aforementioned and helps improving memory defragmentation.
>> +	depends on MIGRATION && MEMORY_BALLOON
>> +	help
>> +	  Allow for migration of pages inflated in a memory balloon such that
>> +	  they can be allocated from memory areas only available for movable
>> +	  allocations (e.g., ZONE_MOVABLE, CMA) and such that they can get
> 
> nit:
> s/get/be/

Thanks!

-- 
Cheers

David / dhildenb


