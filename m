Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACCECCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 18:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4678E000E; Mon, 20 Oct 2025 14:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195B28E0002; Mon, 20 Oct 2025 14:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0357D8E000E; Mon, 20 Oct 2025 14:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2B2A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:15:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA23957CED
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:15:13 +0000 (UTC)
X-FDA: 84019294506.17.CD8825D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 29D8B20006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:15:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMv8sddk;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760984111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFbIY9KfSl1aaYeBiu8nSJ69xUVXrqjagrwKc2qCZAo=;
	b=tAb4+LHZ04ZqkJ4caxzo9lqYB5c45FzeM+90FQ1kfq+0SyE3dp3uaBaDGtYSKUbKJzFK0P
	JdD3h6VPsJ9TiJAURbGj+XDRN0BL/Qv+yMoLBvTxVVIUDMpyP3rcknUHs/jASofCnCr36T
	cy3b5/v6Aks0zSjhkhRm276mY4qOvPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760984111; a=rsa-sha256;
	cv=none;
	b=3G5PmKmT+ryaRNsBHxLUMNynbR+DDYfK6Gp6nA1ia9qfkns4sMRMg/2Hr652bIiCeJaLIU
	ySurTOe4atzhaN74CL6wnXgF23NyPEAAxQ2OJFxUX6/LXdC0rfx2DEwaeAVmtyd0ZoeHxm
	kEDFPKdWHP2malYgUk2TQPIA9PT1RT4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMv8sddk;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760984110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yFbIY9KfSl1aaYeBiu8nSJ69xUVXrqjagrwKc2qCZAo=;
	b=cMv8sddku0WKGtiyC9HCGs8ZRTpfRw/an/hR9E73lLKIbNqsH1PTMdmQrUkLZ2VvKPwEOg
	5ev9iBa82NNoArytWXySrK9qEc9xQaIdkOfi73jX0ZICpJiWe+SurpH/vEA/Bb5hRv06d2
	jh2YagnSILbDXplvt0x41PN3YndszJo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-eUTxhsV7M9aqoL9ERSjiqQ-1; Mon, 20 Oct 2025 14:15:09 -0400
X-MC-Unique: eUTxhsV7M9aqoL9ERSjiqQ-1
X-Mimecast-MFC-AGG-ID: eUTxhsV7M9aqoL9ERSjiqQ_1760984108
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471144baa6bso27567665e9.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760984108; x=1761588908;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yFbIY9KfSl1aaYeBiu8nSJ69xUVXrqjagrwKc2qCZAo=;
        b=F5+7uDwvasQqBDltBhJctiSL8h1eMDKXzHmx8dlMRgYN3KutbXMh2QfGaw8ZAZXzhs
         dB3jwiuzEeMVYeUdrZzTDVeIMmRnYSB7nXslct0XcrNgb24wyxKZuKIep9LsLWsOtmUb
         HSX/bggYJL7qCmzDoQiNChruJJjvx1LRwKpe9G8nMyzPeOyHRogIVNPE/C96txAwcFz/
         ne7A1Q9yZHymFKapQeWkluwgd4kgiPyzjC9awaiWAIAeGSsPHIyzwR/1g3QeG1f8nBaN
         V62Yp8kZCdMmEl7YGSaOgOhWKeBBQl0wpYf6EalPPLiT9PA5HAWzdJG/Pk34fGxN5asg
         JjwQ==
X-Gm-Message-State: AOJu0YzhAzYwUic9uub9JT5v3W7eF0TTdYE9eMHYXKQIrwT+lW57OfzQ
	hZPP5Axdsw4HU+16RUkUAdrNHadves9oUCGLJetmVpKJhXz4JsP1PuGa/bxyWS4rqOx2+ywBvjN
	HaJDHLa/R+ThIB+b6e49Av+N+/Svn/V/3oDYo6Tw/Hx5JlXnt+cyn
X-Gm-Gg: ASbGncsXxJRcfjK3FV3+yVaIiWlote9+EqP88YMD962C7eLcRJJ7rfsEo9/4KM8uXLc
	BHnMRlCCpGS72HyyTU7QUYkTCByIhdoC6uVeSEI/l7SAq/ixWtBctcQvnofgpxVBla/1NZ7u6Vn
	WhBWNba2UA67d2FkKOGIvx5XE64qABuQU9SbDEtFE9/8EmJSdM/hiReSswszdZ+oNYXe0BN1xoA
	xz3C/JorPEAo/YomPelN+CXBQBQ6dPcnrXQGtisgRhp6T2Fv2kML+gJnIICU8RUuHkaWFb8UTZQ
	ZnKtxL1EhkZu07SWXwhdyRp2Gk4IAwYrPn8pWXNbNzaHs5P5SCRYhlJAmWmxEwN4mP4fUYBBpsj
	g5Li+UoXNBdU+W+SfGG+gEtonYdkCDRQGC+pc3iQvk1YpiLFTJEIsfT2Z2CXkA3dH5iWT8ZrvME
	27JQgP1By9n4A0S2Iw7BXDM3wKHdI=
X-Received: by 2002:a05:600c:870b:b0:471:9da:5252 with SMTP id 5b1f17b1804b1-47117919c1cmr109211595e9.29.1760984107903;
        Mon, 20 Oct 2025 11:15:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI5NLM98OQsw1KE57HcLloTm5u9UUcInx88xRDDU5JgrtG6ezDCPBSxrNpLVxH6YIVkVgtWg==
X-Received: by 2002:a05:600c:870b:b0:471:9da:5252 with SMTP id 5b1f17b1804b1-47117919c1cmr109211415e9.29.1760984107543;
        Mon, 20 Oct 2025 11:15:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494aa079csm1455205e9.3.2025.10.20.11.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 11:15:07 -0700 (PDT)
Message-ID: <c3175394-7fc3-43fd-9fad-4d3790837e3e@redhat.com>
Date: Mon, 20 Oct 2025 20:15:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] hugetlb.h: flatten logic in
 arch_hugetlb_migration_supported
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 linux-kernel@vger.kernel.org
References: <20251008212614.86495-1-gourry@gourry.net>
 <def56e60-42ae-4848-b0a0-91bd1c95d8d7@redhat.com>
 <aPZf1aOyhVHVedok@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aPZf1aOyhVHVedok@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u5GQELpDvZvsv4yuX0-Qcin7bzcORwrD9I5Fz4svmEU_1760984108
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: zj5gexgyyggysy37cunsweehbb79ihis
X-Rspam-User: 
X-Rspamd-Queue-Id: 29D8B20006
X-HE-Tag: 1760984111-795297
X-HE-Meta: U2FsdGVkX1+EdihYIvriwkPa6Dt/DNd06K3av9j6UPvjwxdxTV2As9xCB3nskhwq7Rvmr109SVs71yle5eBHinyl2f29F7AEE0wejJtMIJCsT/TmgKgug30KeAgP8LmfLJP8gAOTEkm0VCCJjIwl1o8N6ZT9YpTndAljJSnGg+advbD57/PvBd9jPCwe9yI6YfavXnypzA9/kjB8yoPyj0R4nC5nw0vd8vUzatsOnJIBGmIz+0+0VnfRgxVshZzDw0iUQChnHUtN0AkCWsQQHl+El9McM+FZOtZtxsyuJ+n4lvUvRRXWmNv/xDTNrtdw8RzURG2yla6Nifu4Lcts9SwQ9gas+7zLhHTAYM9OW1SGqJx4uCJWp0XiYJYJRhj6+QVFotUbjb0/tcCFh35PaxYcmSNgZl0uElYixgbsxenYcTu8+vOit7zeDP3PTGN8YB4ywEBiin0PsCQwxHCrlDr3/7ND0aSo0wfT9qD1GNm7LSXRceJOxZYbNc68By7RLUMOPIif9+4wMnS25gSx9dvCV+jSa2nUjbkhwHjKBHDua2vfXKxArPC92WqhFN8jc7ArxCCfm2SFr5fEsWvLsZfmBGhkHLHXZI/d2vlIS8jPX44svFqR1Jia8yH5xfdXk91yvINt7n0CFjc4if+IvwVVfEgFmyS+fYimRF8EHFjW5KzfkWDmx64DMmlphtTTt1DsIj/4EiHR7+40ihACEzwjbend7+z4NToq22CJmRZQo3BVyPVWoUZKICwVR7CXlnbyGmU3nJo9PSIVRMrZwOFAgG3efVHKhbj83khNF6Kd313KwVr+9fpFf6ggoZeEp2W/xUy3sYzpWv1bzN97zaC7c9VNfMbQyQuUNYOzX8OHtUdf0Iy15AC8m18pR5oSQ+m9YG5qH9PhVvtq8Gclr7juFkxJq6ZrAPuy9m4oIKiqfnrvk1BFcVowC7nOrWrdT83YipCf70zNecCExWN
 SJlIwVAR
 6MCAFGd8yG+eOoP4Y7phg+hrOTqeg97oghcg7aD60lv49JpT5e7M8LT9yMqQIofjBwiti+PwKWnHbC6rOY7zSTTJucXCysrY/r6HDpGt3KKwUOxtOdx0rfqXpkFj1CgA/SHkQH+RS7WV0DZ9GE6CHWOkF8RTM9wUmVNJdVIL2+hcBTE/ziI1gg7uc3WjVHoHJiCkxtFNHdOPvxpfXDNXHP+Jtu6KkJsg3+Qw3o6Yo7UgRcxsdSVAacrnIJ1QKiDfqVvrpMULd0JCkUUbUwis33K1Kk5ZpYxwcvsr5T3sOXp6t68pzStB5t7xmXbTf14zeJC82FQWzlioN9p3MeB7ktryP8Hj9B/vHx6/ad78hv8mndhbdunyEwR8WVvuq7EvKxDdd1YOVTVwGuAzNYNdp906U3FY2699I9/PO6wRwpuhXyEiMMSsJorQcpzy1/qYSQu2Ig6PjWKDfRkwXhUAnAo2tUkb3tYr054UuoJo66RQHHHj5jhpIbwBQ6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 18:14, Gregory Price wrote:
> On Mon, Oct 13, 2025 at 10:10:05AM +0200, David Hildenbrand wrote:
>> On 08.10.25 23:26, Gregory Price wrote:
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index 526d27e88b3b..b030850975ef 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -876,12 +876,9 @@ static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
>>>    #ifndef arch_hugetlb_migration_supported
>>>    static inline bool arch_hugetlb_migration_supported(struct hstate *h)
>>>    {
>>> -	if ((huge_page_shift(h) == PMD_SHIFT) ||
>>> +	return ((huge_page_shift(h) == PMD_SHIFT) ||
>>>    		(huge_page_shift(h) == PUD_SHIFT) ||
>>> -			(huge_page_shift(h) == PGDIR_SHIFT))
>>> -		return true;
>>> -	else
>>> -		return false;
>>> +		(huge_page_shift(h) == PGDIR_SHIFT));
>>
>> switch (huge_page_shift(h)) {
>> case PMD_SHIFT:
>> case PUD_SHIFT:
>> case PGDIR_SHIFT:
> 
> PGDIR_SHIFT is not a constant on x86.

Ah, probably because of 4 vs. 5 level page tables. On x86 the check 
doesn't even make any sense as we don't support PGD-sized pages.

If we could rule that out at compile time, it would be nice. But I don't 
think we have a way to test that support at compile time.

But anyhow, nothing against what we have in this patch here

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


