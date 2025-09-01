Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F583CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2908E001C; Mon,  1 Sep 2025 04:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992F38E0002; Mon,  1 Sep 2025 04:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AB88E001C; Mon,  1 Sep 2025 04:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1D58E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:32:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1220985972
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:32:42 +0000 (UTC)
X-FDA: 83840015364.10.9C7E75E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id B3A412000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:32:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLguJRX4;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FO75zWx7qwUC6w5oKfEBr0b/vUP3SN++OhAvNFPRXVg=;
	b=CU4alBP9ijLetv121C66LWJVtJG4KI/yaDNJKN8cX0844t8m0WYIPL5a3c7kxST3OXx9yF
	jDOWTXll3Mm2DnTS/vSF0hiAO0OzRKMueDtEs2JymhE9Rik73NYjdfq0OfFoGkOoOx3v3V
	p1iFdot/UTVtDRRwe9v4dYhrAX8suGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715559; a=rsa-sha256;
	cv=none;
	b=SMvzLUAQERvgMzsFI3PJsWX00moeLgHD1h2+ImAShiScQ1GA4+wUNJj6sFkqZK9jU4oTmn
	wZEf2LLUdnyDNLHia4XtGiCndw2ihA2iPFQQXObvtZ/G0LIU0uzN5fXE3j5w0ea4jVDiyq
	0s34R1lkmiSIXInXZ1RxEgR5vxHlcTM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLguJRX4;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756715559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FO75zWx7qwUC6w5oKfEBr0b/vUP3SN++OhAvNFPRXVg=;
	b=SLguJRX4OBYKq24BMhONTbsDRnIBPQxhz9bpj5WOjhDREXdqNQkZ7RtNvqPrlf/Qj89za/
	Tfe+v4x5zWwknye2cTVqOzjmCHysdyeyMEuxGPLJt4QJAZGlL+IAclWofwWdbPQhvoUjo1
	soou7w8YnLXzwNbe+a9Y0qaYiuTRtXQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-eAeMLHNaOemdalY_zD8Q_A-1; Mon, 01 Sep 2025 04:32:37 -0400
X-MC-Unique: eAeMLHNaOemdalY_zD8Q_A-1
X-Mimecast-MFC-AGG-ID: eAeMLHNaOemdalY_zD8Q_A_1756715556
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so38894235e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756715556; x=1757320356;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FO75zWx7qwUC6w5oKfEBr0b/vUP3SN++OhAvNFPRXVg=;
        b=DQIAotyQJxtMXDSSfRb4OaPZk8abTaa3lAPNn31Y8amejPzd1LbJk0fOtJ7E/tmUKY
         qY+z/gmuhELzxgzR/4TaJ4XiPzmjoS2PRTkW5bLMdmg3SWMrpE2YfVEJjW2vqqsgpUjJ
         JubrK+BhUycyZVBBm9XjvfQTN01E+zV49xqbxf6c1uH04zYHvQHl6ASfY7KtQbppBHw3
         UxdtPlVdfpR0WbTQpY2z1XKws6qWUNglyRtzDGuK1n317A8r7EdSkKGRagPPpZ9jku+t
         TGiLaDoO3zsDJq1Lujn5U2gAEvr9iA6dFhL3NNI6A2rDFKwW7D+Tauoi1u1SessSd0q4
         BCQA==
X-Forwarded-Encrypted: i=1; AJvYcCXCh0tY53jT2ReX/LiqhGFbwcOiBqORAx5O8ivW72IJuJx1EKB2gEVZ4zcqi1Gg6z7XFiztYMe4hw==@kvack.org
X-Gm-Message-State: AOJu0YzIXuBRtvkv9gDa6Wg8Kuxdkgaa2FFgt8hzXhvxrmQoAY4frAjT
	zCT++2JCTE/UpIdKZVYCn6joywlj2f/jLV9YC8j05jdWm5IGIb57CGpGc0viRceRfH7Du0HT4H/
	EhTKAH26LprEVAS8vj2th0DLIV173LvffwMXw5fdBgIW9a6wiNvZQ
X-Gm-Gg: ASbGncseI5sRe8+kOI+q13f62MhQVIglKJJuUG4DweLS8HIJPBXDk7AUVp8SIGBW+bZ
	iGuKjRSwpFEiu8JLfs1nUchIQ/Bi+eqcVpMcSnClXmmmlq9CnkPhzUBw4JXrRbYrwxjsvfYGFog
	sdDuorzWFH4GVu9dSDW1fcVF9Z5eQWZe3KlFnZVPFA2+Mcjo1Ye9IMmsR+lMkax4ULVBaNAW8iE
	ZQZuOFEo48miPwn50XYG5pC7PsEJxYqw4dOpECO8BGIj9ksuZamYVX8taT3rMn3vNODzNHV8vV3
	nKEjgB9c2hKKfi3o8TTT1m/mfhtAs4+elknxWVmiqnEGF5Mds6sVIURj4P9Tm05GYHGqG2gQd/V
	9jaDsdhWDnqAQKlxrjGGUCvseKTDbUnbdSNqk7DAF9wKss7Ux9nlFXnBjNzP4XEC6G6M=
X-Received: by 2002:a05:6000:2302:b0:3d0:820:6814 with SMTP id ffacd0b85a97d-3d1dfa15a98mr5911850f8f.30.1756715556209;
        Mon, 01 Sep 2025 01:32:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFP9dL5XSvBxDQAkLE3hXF8+1bSABcszZ1QfxYOQApyHvl8SuiUtTgdOu/OQu7jJCKZ+Am8HQ==
X-Received: by 2002:a05:6000:2302:b0:3d0:820:6814 with SMTP id ffacd0b85a97d-3d1dfa15a98mr5911809f8f.30.1756715555735;
        Mon, 01 Sep 2025 01:32:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d3a7492001sm8035831f8f.42.2025.09.01.01.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:32:35 -0700 (PDT)
Message-ID: <9c3a2ecd-ceae-4e87-a6d7-6a7121ab7a15@redhat.com>
Date: Mon, 1 Sep 2025 10:32:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
To: Kiryl Shutsemau <kas@kernel.org>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, hughd@google.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250901074817.73012-1-dev.jain@arm.com>
 <7towtl2pjubgdil4csn5rg3usbai5xvzz73wqkwj5b5awh2iim@wfvahykzjrlo>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7towtl2pjubgdil4csn5rg3usbai5xvzz73wqkwj5b5awh2iim@wfvahykzjrlo>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OISt6RPa5IQK9LvN3JAIjRRiZ_Pf0yBdZ9MvvJHQlns_1756715556
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3A412000B
X-Stat-Signature: qxcaksrwj9m1xbh8u7g9ncb1196r4sup
X-HE-Tag: 1756715559-737070
X-HE-Meta: U2FsdGVkX1/OlkC/lmdKpdkFH8yAorPl4PKC0VapXNdyZpI3W1VpRhobVlPsdllzqh1u27tFkUyz6+ihtmhCFrkJTQoLa2wq6Z/yTNwrS8yeeOOzwDkQhiTgZnYCNInJ9ksHb7nqljbLO6q3He5VZnb2B+PasBRKzAWRfuEKDoqcBvYQvuups7UYnxclc1MRWAxQKSgyrvaOOg5IvjJlE5qJwrHYvXql39abTY7wU8BrZmA966XRs0OSk3c856VWW8LkmLDy0sOv16vYibSG1CasgTtzh9PcoCsaKWWw3tcctC4hjyGu/L+TA0q0Y4gOZ+0dpaxZhoeSvnRqXg+GStbiSwkmE7Ktqr6Eb+NhehwkDEKiOKLaAyjjw6n3WGAQkLHoA9KYjx2ewEuBhd0PwnEFQ13ZHuGmREW3BqV8ZM/UbYVpAfMCpcFlnWVBcO+9xQiqM1eTK2zMj8xMGlPAD1pSA+Atjj2mJQJb2pFovb2gH6EkmYhmv1vw4o5RNVjp0cK4SJqLPBPxCGP/DvKVpG4EdttwgkFeIifb8Q2+B0GKUnlakp4imPE2FLob2X/zvYmYoDtYQJcAO8tFRD5iRRqa1J7aMFX22dznKKtHOPlkeh9Ac/qgonacQRnNTSTrsCE18JdisHBXlt5q0e2pp2k664qNhiahk8kAHTfmcfplz8qj1ohQS56q9Fm36JyAODiQUgNDYHFZm6qzRpMDHLR0rS6+HUmL9JDRHjwZEr8lIlVv5GiSYduiJtw974gh50Y1Rg0AnOniUGiHb1Mt64fPXEOZlYR2yCpX/RRS+M0AyJMIaRKTtn6h8F7qyXykHpBIHOjVUePtKIe37yUCVSDGda5cZWPzk0lebtUFtWvyeyXkmzODylxiOEo7UJXZAJl0zmyvbcEjRh+2kjm2H9OW6DsfjPrl/nS81C21mqbJgL7MnHtn8gHk8vqJ8WnsNiCdsfXJ4JhHLgQdjQV
 uQnyTcaz
 bubGy2G1k8oHCJj+3P+evWSKEKltkN7x1WGe1KwRfYmY6j8cIb6UEz49q1B5Y4KW+1bHs3N6xZFGoRWeipI+o/GedfMaNcJD0fUAHpbyNQbXIaOf9g19O58htUGBUdJ+lFhwcr/8Ppr1Hz5282g3dnwxjZauIiASIP7wgb2ycMj+qiSUnyraWg3cr3lotg4y+S4McNtomqSu0N53ruGXNhCk3S4UkRrnZ7Ucknp5Rv6qaHx3gB1qx/t8j8lt+ga3ZjmwTx4QQRHHXUlm8/JUyc7Zi+7X6arvz7z0JLIGOuKc0EWNIBiZf+KWSfKn2Mc7PorRXnyb4RH094/UM+y6Y1UTLCXMPPzKZakILI+MWD0Xe0KLRAMvP+y6RoQtg2m5UkYd1Od96OksqfIaqZBvqkK7glysLEmnljz3JB52SNV2322NA5uR8JRig3orNRXZRqSAt09Gpzhm11Atr2Jvkk1Shycy9oMnY6bQfXPoNANXgTOTw0B06eUA5dpuid64doAD1nj1xhtesJfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   			writable = true;
>>   	}
>>   
>> -	if (unlikely(!writable)) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
>> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>>   		result = SCAN_LACK_REFERENCED_PAGE;
>>   	} else {
>>   		result = SCAN_SUCCEED;
>> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   		     mmu_notifier_test_young(vma->vm_mm, _address)))
>>   			referenced++;
>>   	}
>> -	if (!writable) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (cc->is_khugepaged &&
>> +	if (cc->is_khugepaged &&
> 
> The only practical use of the writable is gone. The only other usage is
> tracing which can be dropped to as it is not actionable anymore.
> 
> Could you drop writable? Maybe as a separate commit.

I think we should just do it in the same patch.

-- 
Cheers

David / dhildenb


