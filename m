Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FCBC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4FB8E0008; Wed,  6 Aug 2025 08:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D749A8E0002; Wed,  6 Aug 2025 08:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D7A8E0008; Wed,  6 Aug 2025 08:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B29C08E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:48:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 628D31605A2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:48:46 +0000 (UTC)
X-FDA: 83746311852.01.A6D0C04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E948014000E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:48:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ikWs6J5d;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484524; a=rsa-sha256;
	cv=none;
	b=F5ZN6mgbyAtD17pOVznm5mMwKTuxxq7inhLPhWfHXvTcIeTV9J49clOdRHQqZ+oX1e/VEk
	LhLuPRjf5mBhDEAf0bGEGO0Q9qRs+g7BTGjDl5tmrcPg83Exuv8sc0gkSE80qmzvUBOTyA
	y48BvsefaC60237PYcCme98g4ekuQew=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ikWs6J5d;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kd9TtjMY9qlGHRoxZCwU+VUHOBngdR5vc0FuqtfK3A0=;
	b=ERL+YwiBYBkyxXMzPsmG8k4KCV/lrMnx1U1eRh93HksYHE6Ho6KdtQQwgfDjU7k/zTcoHQ
	Q0akc4V9Bvhu0SAxRlKgZQ/ZiJX/otiX+ZN1p7ciO3yhrxaxi9bKb0BZ/kQ+s4nskLL4fe
	wrHnbW8etjwyGyiAPNUrFIAPhdvyqAI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754484523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kd9TtjMY9qlGHRoxZCwU+VUHOBngdR5vc0FuqtfK3A0=;
	b=ikWs6J5dlwUdbqWSJA3pMcD04PqQL6jtkBnPOP1qg+XIZ5l3k42FV7oUeIg/t0tSjZFkOl
	MxRFfMuu/Ii+Z5mXk5eoXyRni8sL53lDNaBlRhZEsS07Dzcqph5vvCvjJcsMPgBvnxWcY3
	oZghBCEPW/DECScydcp+KXpARU0G/wk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-FunYa99rNbmqFd-_xigGSA-1; Wed, 06 Aug 2025 08:48:42 -0400
X-MC-Unique: FunYa99rNbmqFd-_xigGSA-1
X-Mimecast-MFC-AGG-ID: FunYa99rNbmqFd-_xigGSA_1754484521
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459e30eeea3so10684175e9.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754484521; x=1755089321;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kd9TtjMY9qlGHRoxZCwU+VUHOBngdR5vc0FuqtfK3A0=;
        b=dZJp+wpN40yhfst//3IQgUUPzaWfQVKEb4cTJiNzyfGHPKojzAhMXX2sSANM6rsWMK
         JL+h0L0RSiant+17ZkVMR7EExTIInc+aV19leaCCtkMaI0Cew3GgQU2QhO1fO58K10pA
         gb9bzfoBWKo+bDUZDbUKiGpneDZxDAGtpk3R+XJmLyOJ/SATbEr5iUab2LvJBBEcceyw
         wACV34bVVuz3lCNicsSoR/2wzCdNFx38uurEFF7l3P7W0IsH8UjYsyKYdbpgtpJuF3bq
         GkUDUIA7TCZ8DTYalx+LDD2PCFiiJSNOxyDZSS2UWb3ujh270Jm3TJsd4aeyytzRsC+u
         7t4g==
X-Forwarded-Encrypted: i=1; AJvYcCUB+RRLme9Z9caKrbPnvmxFxCN5oZV11WLb3rLOeCiYwqhCMlOA8p8gRxbuQy5KJ/EMUYDMxIbU7A==@kvack.org
X-Gm-Message-State: AOJu0Yx2tg/cETAh0ZIuE0QvB0NLRxO55nZHZJFoDQM2FtSdwETgBZgW
	NByA6DkSwHaecSwmn2Pndtmhi77nPHMzfaSJ0mM2U7YIGWPoxYrp5yEM/y0Im4k9b3uuNlpoPEY
	sCG0UmiSveCo9KKHmuyTPjzIbW4rqnJ7qly4IssRqut7PhUJTYDSi
X-Gm-Gg: ASbGncvC/YG1RamQSYHIqMl+CQXFgU6HG37C+wx7A4U9HQak8gtEVhf+hMMtrPR2ztu
	qW9rx5K6J5eQOmSgb6H2aSOdkBSDTC8f3dR6ZfREM5GMVP2d3zVwrJUQf2iGYh22PQfpMq1Wqpg
	mQYwBRE/UC1Qy1+on9CCnNDtAiNCrBI+JrK16TPk9dJdBHG+UsLbW8iLZr6wzwGlgKVbybsrJ/y
	vdscaUPdS5SFfQCFnHCj7o51WpaFjmg/Ccbw2gv1WOXUAPhI6OZCmrFTAWPWLVViT0Fa1B+kvgG
	N/PL8rX1uN3MpXRPVGWHvUJJItnVxc0WxyVVxl3lwWBM4X0ZDRUVsisgclTixvDGQV6JgMBTOle
	m+Y4s/WofuTQ/HiCum1sFbSAmvSVrAY0iLVEfoBp1sWMPcMt7XfNG3ztpm5kw1z4p2F8=
X-Received: by 2002:a05:600c:4f06:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-459eb99cf40mr6834455e9.24.1754484520829;
        Wed, 06 Aug 2025 05:48:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/0rN2yIF2agG/vG81ip1EWBrfms9ZbUi9pJdD+2A9S9B+Yl3xnrI2Tl8AjbH/66V9kuLDCw==
X-Received: by 2002:a05:600c:4f06:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-459eb99cf40mr6833975e9.24.1754484520361;
        Wed, 06 Aug 2025 05:48:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e587ed97sm47763195e9.25.2025.08.06.05.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:48:39 -0700 (PDT)
Message-ID: <76e26491-e91a-49fc-9a5b-eb6d840a066e@redhat.com>
Date: Wed, 6 Aug 2025 14:48:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
 <6ff6fc46-49f1-49b0-b7e4-4cb37ec10a57@lucifer.local>
 <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
 <bmngjssdvffqvnfcoledenlxefdqesvfv7l6os5lfpurmczfw5@mn7jouglo72s>
 <e67479f5-e8ed-43a7-8793-c6bff04ff1f4@redhat.com>
 <iputzuntgitahlu3qu2sg5zbzido43ncykcefqawjpkbnvodtn@22gzzl5t77ct>
 <9a657c84-99fe-41ba-88ca-097acab4b96b@redhat.com>
 <lyfgmdjehtfjb2gmj5ciao6l5lmkvlfe54wtlnlhjjf7ge65sa@2dyo3tb6ka4i>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <lyfgmdjehtfjb2gmj5ciao6l5lmkvlfe54wtlnlhjjf7ge65sa@2dyo3tb6ka4i>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6H1rS4f7o1zP5o_vFxfPgpEIjdP0Y_0oj2JNzMCABSc_1754484521
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E948014000E
X-Stat-Signature: 94up85u9pw6s7zr319cx7m3i5tspb3j6
X-HE-Tag: 1754484523-419582
X-HE-Meta: U2FsdGVkX18HHLkr1eEVNF9z9GhKdaXLBTzEZ286+trInCEbespP/jfQLfCIcvYDbJe6UD5tckERprOZchvVzxGbSlHe5aBULC5hzY3Jzu2ZDePlIPh8zSOL0ks9/znAbC/goHH0t8cFoedcs7fOF96fvyqP8h5dm8M4VSTtS8n/KFH/YNuTgqInQqACdTiE6rS6BUUBS19/+Caf4tMtQsLrrAiv8JfTRVNfok2z1d7ssFVmF3pJL2KxSGI33RTloerrbqelanUkecWYn2PKj6aBc91/LY9/xFTGBJA4FuWA/pWETEdtT8/VMuaQF//CBmPa5SeoW4Y8QoBbDD63bOKEdBIpTnrMf0uB/HAE4u+mJJYKy3y0HFA456noECIBw7GnwmvBvxaFQCx203JJnAuZrFrRyfYFlodbhxymz6MBJNSdRftrCcgbjzJCCDma9x4qFXSVDcCLn/QdVZ0avQtcIJffo7FVH1Bk+o+gHzURIF7tguGjvqy0Mzw3dK9SKGaLVwBE6QcP8a6vFzdpf+5TNIreKh0uA7cuG2NoLWoPzf8pBLfHfd/UzV83P5fql7I+FFTBv4yV+pINIXK2RxA1o1ExETzUw9dQxVKl6d2PJMtqYq1jHQ5tqHhfyojM7BXjpXDgM4q1vSqHS/ZEKKyZ1ihTnG9GvRyRaZCbxqFpixx1BAT8H+7TH+XPfD6GM8IyJ09MkGAa6At5NMe0Fk0OllaefEw4PQXn8vkSUNM59jOLLNxWymwzfLL1G51NQYoWzLRRyWoRxyXW7wqYPxmBXzzpAQ5VYTRyO4muLk2Cxt1Dn9I7iyuEuTT4GdMgX4cMVPDwysp0H1u4eMdLjHS2cIEd+0OeeB0tmUvENiyrz8zHBei3BfKig9lsZbE2necetKeAFM+AFY/smrRPd0p/GALjIlUCGp+kimAt5j0fW/Nq1wiBVi07ofkw12p2ky0XPj+eW4Q5sPjYZSN
 Xj6/EMNW
 UOP/Ey6APEjUBh+NPSvNF4zjzPa595WAbEYGRzvWwi7WGknM7RIoRfPbiHpgezX3p1pnGPwmGj5yACeal/KZe7SYJMlSLZVikxcvz6jB/E3Fxc5Ofb1BBJCqXFZRsLLZiRfUmLAvDknoFFUkk1TcWmDYQF0bE0Tof1OsCOO9F4+iZDu0TbtEEHBMv0HK80u48BEM+BRY0qghxdvm2+cJWOYr+a954jQ942dif402v6F7VDYZW8SMrBPBbc+T6vOYznhlvix+/XQnieQGKS9DPLNE/wj2+dgOsPTjIWBAa0dMs8qV1IeUAG8HYWvFUp5rkeZYjaQfek9PapeIrblhgvgB7tmZLXwDj1bHAaBkMq86Q5pkAdJ41RFz+4BchICScscl98KLWXan0qvl8Z2GR7seAb8CuFX5hrUCs52EgHJrTD7qlN3OkDwxbuIG8hXwPmnfcxp4+ktJlt4e/HmIqeSJtMYI+x/g0hC7axv17q32uOJqie5vywfC9xnfSpBqmSgi0JJNeSpcU8HTSc+kJ2rYQryxir4xd6kUl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 14:43, Pankaj Raghav (Samsung) wrote:
> On Wed, Aug 06, 2025 at 02:36:51PM +0200, David Hildenbrand wrote:
>> On 06.08.25 14:28, Pankaj Raghav (Samsung) wrote:
>>> On Wed, Aug 06, 2025 at 02:24:28PM +0200, David Hildenbrand wrote:
>>>> On 06.08.25 14:18, Pankaj Raghav (Samsung) wrote:
>>>>>> We could go one step further and special case in mm_get_huge_zero_folio() +
>>>>>> mm_put_huge_zero_folio() on CONFIG_STATIC_HUGE_ZERO_FOLIO.
>>>>>>
>>>>>
>>>>> Hmm, but we could have also failed to allocate even though the option
>>>>> was enabled.
>>>>
>>>> Then we return huge_zero_folio, which is NULL?
>>>>
>>>> Or what are you concerned about?
>>>
>>> But don't we want to keep the "dynamic" allocation part be present even
>>> though we failed to allocate it statically in the shrinker_init?
>>>
>>> Mainly so that the existing users of mm_get_huge_zero_folio() are not affected by
>>> these changes.
>>
>> I would just keep it simple and say that if we fail the early allocation
>> (which will be extremely unlikely that early during boot!), just don't ever
>> try to reallocate, even not when we could through mm_get_huge_zero_folio().
>>
>> That sounds as simple as it gets. Again, failing to allocate that early and
>> then succeeding to allocate later is a fairly unlikely scenario.
> 
> Ok. I will also document this as a comment just so that people are aware of
> this behaviour.
> 
> Thanks a lot David for the comments and feedback!

Sure, as always, feel free to object if you think I am talking nonsense :)

-- 
Cheers,

David / dhildenb


