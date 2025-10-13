Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C58DCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1FD8E001C; Mon, 13 Oct 2025 04:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E828E8E0002; Mon, 13 Oct 2025 04:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71F28E001C; Mon, 13 Oct 2025 04:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0AF58E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:10:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5758AC02CF
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:10:13 +0000 (UTC)
X-FDA: 83992368306.11.CA0E21B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id D554914000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:10:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aPOFmrvB;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760343011; a=rsa-sha256;
	cv=none;
	b=tXWh8hzO/Yk1MjLBgghGdMhufmBsYbdKngdi8ct31/lBeZRID4KB8SSdJ2nca1jk3lurit
	tG+/RfhDbtk3HZP7wRQ43TJDOXfheXpK5B9uoTXODQZulhE+yr8LI/jSf9VbyqPS2e1pG2
	DB4S0iC2gAgUhQOqYv5W+lM3XeOuByc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aPOFmrvB;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760343011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzBMdxq8/SEOuqGoX1j4+iaBZ0Bo8TLDfpyglTErDQc=;
	b=uxBSsuodauFXPuIOWF1gz1xGJhmoLAXAHn1u+siGB1cXsmiaK0H2Arn65kkfzznQFlnll/
	0gQgg2L+4WFTpcpl5XDBnFYqHauFBrl7xW7lX3FZmmXxibWrC1e1wmJFHOXiHIZBxyEr1s
	tE11ETNgSzo4NotKhSFCW2Xv3uwE3Kw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760343010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mzBMdxq8/SEOuqGoX1j4+iaBZ0Bo8TLDfpyglTErDQc=;
	b=aPOFmrvBImnvWZCtjlGCXpaATsIW9J262Eu4jidEMqceMTH7kQQJ52F3Ccil3aErQJv0v1
	i4w+j/2viF606m9j94xbznr9xqYzRVCpJTzqJMAa1suXBQMuWTvp55bR81t8Nw0BVnfy14
	SBeNwbSdZTU0sd9P5VETuDL4fkSm2cg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-Xw_WU5X8MHq8C3C0B6Osqw-1; Mon, 13 Oct 2025 04:10:08 -0400
X-MC-Unique: Xw_WU5X8MHq8C3C0B6Osqw-1
X-Mimecast-MFC-AGG-ID: Xw_WU5X8MHq8C3C0B6Osqw_1760343007
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e31191379so28374615e9.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760343007; x=1760947807;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mzBMdxq8/SEOuqGoX1j4+iaBZ0Bo8TLDfpyglTErDQc=;
        b=Cx2YgvrxWVpoXWtjNEF4DSQlCzCi4qqmA8cGph76e4Z2NCRkP7w3QjeQZW4KvwM/Ik
         1xwFQtVhhljaPjgOPgsWigKVOqu66if8VXi3GEq20BMO3E9UUNFLN+SN/iS0HRwh0HBn
         wYAFRruKGtTd2ARFFE8gVVcTCoJnNA1C0VGSSaYg/ly48go4UMM1moeHPQh8Y62Fv/5J
         yBSZHm+sEBiKLRYo3nNQJlQV2O5mZZjlqi7Kg/btxUopVN1GD27cOtnJz6FAGWLMAE/b
         jLPX1LepW9cs3nb7Kih8/ah8s3lQ2NsZXXNLYhtFu7k29DqQXBRIUSWzeJn+vvP+FZBm
         slBA==
X-Forwarded-Encrypted: i=1; AJvYcCVg2xpWgT4OV+1qzPfDVzChcNwdWotPWQ23RuMCg16YoVb4SXakcI3atPBO11aGWNKEpnfXh0hmVA==@kvack.org
X-Gm-Message-State: AOJu0YwJwq/dvbh6crBWmMsDzHlPo7Cr6JIlg0dhb1RkewzVTEx/7vIK
	2SuWB7WHFySrX2DqtLUVwR32gOyezYGExUB3VsRg3Ximnk9QwfTP0qOED2llIT37dtd3NnLLXfe
	hLsgvRiO+COfhN9GWTEIArZps92MLxE2Y6HqpfSciGJne5DKH9M5n
X-Gm-Gg: ASbGncu0T2nORDwOkumqiHHORzTDuhBj5exuY8W0gr8QTl14RfYz+CrGC2Tb8M/l8ab
	wgDgGtotJU+wYTWiA/Fjdlqzv4HcTMWgkKe4AWLQZ5BlpvgM+9q0FTmOmyz+gdBGxSt3avQndGN
	tALtGDy8B3556X2IbxCLjJpbBa/3jvqDUGKRR6eIKI77DJ7I1uf6t9fCuFZL5CD7d6tbGq45xEY
	8CMfsb3eMjh7/mJ/YgH/m6+z2vkeFyn7/P454I4BPBBJjUm7GKx7jXefwVXtWnsfRtaZLoHfH38
	9oNeOjeQEfyF0JAM9CGlyOBO9kPl0M8qMh5EEqxCaGCrK4jFGIkeZVQKhxFcMb6zGv4CV+bofQA
	Soik=
X-Received: by 2002:a05:600c:8718:b0:46e:731b:db0f with SMTP id 5b1f17b1804b1-46fa9b08f09mr149383505e9.28.1760343007149;
        Mon, 13 Oct 2025 01:10:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIX1+LG4xUS/7ieEOK5X8J3ovtE8PkBs1+dxZ5V3XzlllfRN+mofANp3L+IWlXa9MLkMwa/A==
X-Received: by 2002:a05:600c:8718:b0:46e:731b:db0f with SMTP id 5b1f17b1804b1-46fa9b08f09mr149383265e9.28.1760343006754;
        Mon, 13 Oct 2025 01:10:06 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4983053sm172313925e9.8.2025.10.13.01.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 01:10:06 -0700 (PDT)
Message-ID: <def56e60-42ae-4848-b0a0-91bd1c95d8d7@redhat.com>
Date: Mon, 13 Oct 2025 10:10:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] hugetlb.h: flatten logic in
 arch_hugetlb_migration_supported
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: muchun.song@linux.dev, osalvador@suse.de, linux-kernel@vger.kernel.org
References: <20251008212614.86495-1-gourry@gourry.net>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20251008212614.86495-1-gourry@gourry.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JX2sP9O2eI6ksuwBDhQ-8o4Qs5Bcd-asMobUEG0s6Kw_1760343007
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dzd9o7f3sth5rjtyrihbn9bru3ab9ct5
X-Rspamd-Queue-Id: D554914000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1760343010-646624
X-HE-Meta: U2FsdGVkX1+EZGssDRC4yelEgH2I0OSQZFrmWpfs5fcShwtVWwqC8GEM8xnHlZCO3UXBMDJL+XKDgk3/CjUixnX5D3xpkPRfeNejdAA7jGpcMfKwpjVkngEsvtLSjn5hw6MqDqFODYHCT5JuCqP8P7Kmqh1kfkQkF9voQmAUGwocwAeCuYCY8+0EFeZl87tM9x750YLpNAY8FgaeQVZbOQQrGir2+o7ihZTZtq4sjameaHXBw0C3UCuME2M1mTML8gtGO4cWfr3434ourWyaKT/LZfCcE1yb9N82Oq32DaFqYLhPTJnl1Exp5Niqeq5itzEIRxe3Z1MPhD5N4Pyw/CE4wgMevH82SaYaVLFBG7aadLy2A3kR+D4oalxbD93QKaFojG4BwNlSQ5ytnQz5SRnMAJBMHLKKr5rCj8go7wGxqF3rHSVIX++fAwckN+xa4hye/dliLNMHmyRXlUrPw2LQRas8RO0viece81znPPJ9wyJ2u6/JrDzgfS1ngOY/sDEO4P9TsrcZrCzyzm366AkAX9aZrbyDykUtCDcHsoAanSKYA5fjsEVwBnFNuTs2bXV1puzW14CFR7W/HiBBYiiQBNCC7R116sGF4HztVxkI+t1hcLJEMTktsOcpGTKmvkcfyCpOB5JKDO3SDgrcaualxHwddhlXfCl1X6C+AOWLlP9ZjabzC6q3/KFWYWJ6Acv21T+mG56eFIlwcdiS7L9trv7JhDFAapdPEIN0LG5uY9hLf7sRfVnfKkuzw5CyGqQcWCYoVinOcv5Cp5I970AqRaLQuQp78CDydgaoGhboGdA0Xf2ksYjWp8BXtY45BFj66G3aZ6nh1rjKqM8hPV9FSDRpgDudt49mx90ZjSjdfQY4MrOYy/gbcdLXfqero9XrG0NNdi6zfTXZhgRJuLiL6YqtRMTLzMFMfz8zu6o1rCR3eX3VxoTK85SWOvZUJv/7tW4fP1379hD/MG0
 P4gkSobV
 RINWfhQBhkvc6Ks4SvFCIVHWTeroQ9S2LB/IuLsRSKKhUyfu7zLvUjElMSDvV/xsDOu6CW4Hzli2AWmMX8REwI+sQb1wSdE+PIR5dAye0ihaVDtnM3ANiym2fAa/jRVDhO/5o0JWViTxOgCxNPDB5KWJ8Mo+ZZoKncKQ+D8ZGCsa/aE3wn+F5Z43ACGt994VM1mXuHpPEy5n3ISZv2JNPePmRV2IDrtJeuU/pEN2NwUUwrFyK1Qzy8JLFzVmrq1TAT3bLvdGQLSoeI5lNFceYSw4t/VcUlTLAF46ZgmTxdfor7wnFvPXBbnplQhwr+REUOjELSAvIkAwRZp6KJADjAT4I7qB826giPbLv9A9PPvil6J4Js9sE27+uSZF4CR+VU8OhFFZvgjN/+clbqhTg0cY+mM1tRqPEviiyTf9yjFFr/uT3PvfcHaGWnGX+7aXEhqT23plgDnlqLBPJYoBE+kfORY52tHQ8MNvjxgPVQJ/w5nOeSOOLFcdeSEtRJeiqblu7vPVDuClChwcp96n/eaVxLkughzFaGyZmEATD7IPqBWktVSPp7ypX4vUVF4DcR2qtLZR320YPR257qsQ4De34PSURO/oAQg4ACtXSh5IjU9s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 23:26, Gregory Price wrote:
> Simplify if-true-return-true-else-false logic.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   include/linux/hugetlb.h | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 526d27e88b3b..b030850975ef 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -876,12 +876,9 @@ static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
>   #ifndef arch_hugetlb_migration_supported
>   static inline bool arch_hugetlb_migration_supported(struct hstate *h)
>   {
> -	if ((huge_page_shift(h) == PMD_SHIFT) ||
> +	return ((huge_page_shift(h) == PMD_SHIFT) ||
>   		(huge_page_shift(h) == PUD_SHIFT) ||
> -			(huge_page_shift(h) == PGDIR_SHIFT))
> -		return true;
> -	else
> -		return false;
> +		(huge_page_shift(h) == PGDIR_SHIFT));

switch (huge_page_shift(h)) {
case PMD_SHIFT:
case PUD_SHIFT:
case PGDIR_SHIFT:
	return true;
default:
	return false;
}

-- 
Cheers

David / dhildenb


