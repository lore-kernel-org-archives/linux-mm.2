Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93AE4CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C658E0008; Thu, 25 Sep 2025 05:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3A48E0001; Thu, 25 Sep 2025 05:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9A28E0008; Thu, 25 Sep 2025 05:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD8D48E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:33:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A38BB1A03E3
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:33:47 +0000 (UTC)
X-FDA: 83927260494.27.C15C7BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2AC3E20007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:33:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ArBjsOVE;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758792825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQxV2N8dYSlRevMplPP+7X68Vqzpbc0LIY+aAribQjo=;
	b=odii42AcXw9OczYLG7Jcyxzjhs3+PRududcD+HKx+/MVAWMWVeUZo9MtHIlrlQx8VEKZP7
	8KoNzW0M0MxDvb/X6rWEvfTm9T1vDDrl5e+EGq1GvHzI+hROLuVzrMH+sdV0aJedohYawJ
	nd0JV5lrqCEoxgRPOJxb7unECfJjG1I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ArBjsOVE;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758792825; a=rsa-sha256;
	cv=none;
	b=edJ5tzi4hO759cjOcACz/IDSS85WZ+mYgulHKY5dH+QFKfjNRNuxS1ECKL/miylOnMfC74
	UxmSLkZXIQr6OBv0Ro385K3yuO1kdW7t1SkUDEjzAwvRH5KWFGVcIgsVp5P0pUgmnERMIL
	wSRCyi+fTrTTbXMpzlgYrlcAu9SFIBU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758792824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UQxV2N8dYSlRevMplPP+7X68Vqzpbc0LIY+aAribQjo=;
	b=ArBjsOVEfL7M7O0+ETjNVFKtOvB9GGcI35VFEvnJGzd07vOL50kQ8+yD2agEdGbK5aN92p
	OXRP824Tz7IumlHT/DkTyydQ0RNkzX+RY49VwDoi0z4kxmriDbLqzon4GU5U/HI3NphtO4
	uIqCyXuLXTSSPrCv8zzR2Fas+ZtSmM4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-NXKHdjzvPNeDZvEOLI4szg-1; Thu, 25 Sep 2025 05:33:42 -0400
X-MC-Unique: NXKHdjzvPNeDZvEOLI4szg-1
X-Mimecast-MFC-AGG-ID: NXKHdjzvPNeDZvEOLI4szg_1758792822
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f384f10762so414866f8f.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758792821; x=1759397621;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQxV2N8dYSlRevMplPP+7X68Vqzpbc0LIY+aAribQjo=;
        b=TF0J3fISH04cgcrySgtRK570JlMvZRohPuoV/1zXq9Ihx3HyDgItv6563B2R2T600D
         SdaNsgL12NO1h4t9CbR67XUI6qXwdVCqFRkAcEeGfmhzXpM0Q8RLaVNgvXHmF36+EZRw
         qVgL5Gw8+WT8FWbbiuAy/ahHlAfj16krnhmQA568zAJ5TrUdavSisd2wCSKrqC1JmpIT
         UEWvXo9qQHVTlk+kWgu/fRojcf7DIcarvJQQkXiprKv4JWwDcDroAz9AlMEXfT0QCv7A
         eOqWyDK7/RtpT/pjBFaARpZv+FcRlT46yKQGRcvfyLlSkn3qZov9brGySBTU1Sel7Kma
         093w==
X-Forwarded-Encrypted: i=1; AJvYcCXIJ2Rip3BZjyvkVMgLHtnMkf1yn9e5915zksByQhrPFQlZb4ZYPHzAhWeDdy8FFrDyWxiq/G/j1Q==@kvack.org
X-Gm-Message-State: AOJu0YyIGuG7K4CW1HZQVyG572Y55dB0u/IVD2BQv4sy1sOnG/7cEbU+
	1okhlqhvIGNQuVQ66KVg6m1tr0L+UY2VB2wBx06tA06JGFlmWY6yxzisasLQqLWSzDX7Lor80/x
	Oz07/23R75QaM/OCjxbpj7eHgyasSBr8K60M/cQtysxqq3fhnmKE9
X-Gm-Gg: ASbGncvCsRXnyipnAah6YImUwI3tdGTMhVFfkdmVdYPjsaPFp/ycyjjPks613RmbUJu
	l4mLvovCb7J4VU587ZxgVwa6iPCKzcvI5JRzhYLohd02AVYFC3IYaC2pa4mrJYgn1KAwDLRy2Ai
	qUStC5tngmfIcZ/MrYR8R+QD34hm1Fz6ntliA7f89Q4F6evqnaz5Y8R/lZd/z8H2YHk5IcyzwK3
	s8O7m8c1kLIumSvICe2HGnFpGMnrrm5g5OBR/hnodQAmrESVTcto0MZznmt5RLJ0BtlX3614kt1
	M2BRyuk6tPkn/ISLl544a9JzWuvjenAnJtXpNEX6HXdRtuNDNTV57FbdNt93H6slB+pO9feIEns
	eCnRAfUk1AR2X0mQe+lkMM44MpfHpA/SDF1KF/G3pThm9rl1LUrgHCEe8LCeqia4cnQDk
X-Received: by 2002:adf:a3c9:0:b0:410:3a4f:12c8 with SMTP id ffacd0b85a97d-4103a4f171dmr1075314f8f.20.1758792821519;
        Thu, 25 Sep 2025 02:33:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZcXl4pYQPZQ0U4/pa9bQrhuaKgjWJziO9jJ5iUdtLGhTCrjOfRbjX4KoPsMAZSVZkv1fopg==
X-Received: by 2002:adf:a3c9:0:b0:410:3a4f:12c8 with SMTP id ffacd0b85a97d-4103a4f171dmr1075287f8f.20.1758792821120;
        Thu, 25 Sep 2025 02:33:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb985e080sm2265662f8f.24.2025.09.25.02.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 02:33:40 -0700 (PDT)
Message-ID: <c24d7fdf-4c4b-4379-a538-ae5847bf57e9@redhat.com>
Date: Thu, 25 Sep 2025 11:33:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: move rmap of mTHP upon CoW reuse
To: Kiryl Shutsemau <kirill@shutemov.name>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250925085429.41607-1-dev.jain@arm.com>
 <427kxhljdcrn7thput727j6vpqvxtalistn6yoq6ykdpbe5435@sn7a4rh7zcdo>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <427kxhljdcrn7thput727j6vpqvxtalistn6yoq6ykdpbe5435@sn7a4rh7zcdo>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i9TG5H0GbUW5kzdk4aiYRAbPqX1IjUbK8iSzLq_-5GQ_1758792822
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2AC3E20007
X-Stat-Signature: 9ujyytskfp58t93dpzahhh9o7rwbtbyj
X-HE-Tag: 1758792824-801069
X-HE-Meta: U2FsdGVkX19KrCoH3Hwj7Eu8XpcWQLvTj538wMaqsoowkhLXSb9q+uskYlwr8DbY0zfPfcGkttKrRpIoVMtprCXoUZGOxZt1a58Wxw+F0Y11qM4f3qJS5kYiYGMYRsfwNKlFuDLiw3hSngZDMbZn8GWbKnacGBK/QrrQMv8uvZJaneaDbU4IrFzae4FoBo4S5dqQoIL0Z9i4auukTGXlta4g8WUOZGKmi1XSIe0ANkt5897fgg3z2tWhCKaaCUh7F060YLuiEs06rCclJtJOr83+e/ICmHpyZX8j/t7ZTo1NaIwjD12Z8SOAMEA0saFNROCCfNS0HtaLqsOP9ruQTLy43Pbml0Kwje6RenkF/qVsCeSD29bB4lyrgua1Ku6AqvWLUxn5rt8VIkv737b8yZCDafXnwE43zZE5kp22Y4B4pE4w2dZU+seULt/L/sTu1wiLX2DxHNv4u19nZ6l9t3HaCj6SEMbM/qm6S7gL7yNUjoQomZKpHnRDPtSY0NMWMZbPZRPXOEJwr1BAZ6NP2hvgzLtZ5pMpQI0CqgQhwYhPZkNg58YiHP3TsWyA4vuxMxEaT1WZcfMrUR+5gYI0tR+0W5VZf4DE6cFiXuTD5PKsDbODmJ2BLldvJECeJnRPAP95/asAd//48u0wbWJMKHkQ6Yk46qmfjbJzDgMDBXm458ImQaqJvYFlVvCva0853Lle71sFAddECOeRe+4hQ9daFE19OPh7ZHB6OoTlItqKEIoiasu1nTwHR9pAtS15R77lMtvmtJZOZdFICn3c7xVa59Ahe8O9qggJWUGrL12FdQGzAvdnELY9zyUP8GNXvWxOeM1XocHyI+oMII/wJnFm3PWD+CR8e/ME3Xca96lgTsz0ge9GVpIFksgwLgWiNadJgRWev0expZdDuc9RKhRTY4TcwXBqbr9+dlztUXSaCMZPVLzEqazO0kGJSBgPY3Th06wufF6Whl7eFF7
 8DWR8XVZ
 krEL0sckHtaprjv9XI7s1Xt/UWmzgmkv0iiCXPTMs+dwSdI8iLJVl6HUWxdp6W7Nzc1vHhNfLGdDyNpDPFdMW0aZKTQmIbzsHISDVLhGB7V/opbV9cnxNKR3e254ELkOMqoBWlsY/Ylw6a1TD4ZE9sTJ5dg7zpE5LLvjegXD+GTBdYYByUc607UAWaNo94SyewOjMztTliJLXnaMvBYR7OWjiyGiSlVDLMehgHOqVi6kBSbcFZTeKGr3li5kmM4+o8tRTB0oQ6ftEps7tUg4a1QcnDNJ/gxEHxbVOc8iRO78/Pw10iAXCCP/CPdnTu8TGGoNrx8rLkB3i/q2RHh7AfDKDmjHIgDifcyzWKEizVv7KmK9E0+T3hbmbz42i8X4/FSt4YC1jEIvuL8cUx79ZfOFLCoIutO+vWnNbDlijMxnl3dIYMhn7oQJOlcx6KZOn7g+wVCYxXRJDrobWkRuqwzB7/vzniQt5giJwWMB4fWTW9UKpwliC1gBm6g566kvgFn1av+llI2AkQeV2M+79UAmD9hylXW8GEyIAS5r2E8+yodJSiKF2bFbLjY+VGZb+pGrTp0qedlpD93g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 11:31, Kiryl Shutsemau wrote:
> On Thu, Sep 25, 2025 at 02:24:29PM +0530, Dev Jain wrote:
>> At wp-fault time, when we find that a folio is exclusively mapped, we move
>> folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
>> reduces. This is currently done for small folios (base pages) and
>> PMD-mapped THPs. Do this for mTHP too.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> mm-selftests pass.
>>
>>   mm/memory.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 7e32eb79ba99..ec04d2cec6b1 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4014,6 +4014,11 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>>   	 * an additional folio reference and never ended up here.
>>   	 */
>>   	exclusive = true;
>> +
>> +	if (folio_trylock(folio)) {
>> +		folio_move_anon_rmap(folio, vma);
>> +		folio_unlock(folio);
>> +	}
> 
> Maybe take the folio lock earlier in wp_can_reuse_anon_folio() to cover
> large folio handling too and avoid trylock here.
> 
> Something like this (untest):
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 812a7d9f6531..d95cf670b6a8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3843,6 +3843,7 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>   	 * an additional folio reference and never ended up here.
>   	 */
>   	exclusive = true;
> +	folio_move_anon_rmap(folio, vma);
>   unlock:
>   	folio_unlock_large_mapcount(folio);
>   	return exclusive;
> @@ -3858,8 +3859,15 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>   static bool wp_can_reuse_anon_folio(struct folio *folio,
>   				    struct vm_area_struct *vma)
>   {
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
> -		return __wp_can_reuse_large_anon_folio(folio, vma);
> +	bool exclusive = false;
> +
> +	if (!folio_trylock(folio))
> +		return false;

No, there is no need for that.

-- 
Cheers

David / dhildenb


