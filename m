Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6134ECAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82B18E0016; Mon, 15 Sep 2025 06:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58558E0001; Mon, 15 Sep 2025 06:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947D38E0016; Mon, 15 Sep 2025 06:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84D898E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:37:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30E38160591
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:37:40 +0000 (UTC)
X-FDA: 83891133480.22.41D8895
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 413931C0004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:37:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VTYItZUz;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757932657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AE1mZo5dM28REMNEPIlpmNiMCj/YW4kRPZdnAEmZK3w=;
	b=X3KBzThWr+tqsYtX2ymzmtcxn1YwHnGgan8K2XM0/fZsosCqV/qA/vT/9MknfXbFCGEiuJ
	RrPrRYrdEPOFEMe5kXsEeCkOO7QeRwGOHDaxyQGJZ6GymaS26443FSGNEQbLK2FsdL1yMo
	8POEwqdPeLEgFZ+KoMAoaam+pwFEdVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757932657; a=rsa-sha256;
	cv=none;
	b=Y2RVB8SgM9P7bDnsAZiYsA6uaW4KCs9AmOIhjiisxOYHkOCt/xwbUpxLTlgi5uYRpdZ0jF
	wOR+rVDLazwvPaJ/UpboPiMi4AiMCp4uKzl5mCSzdwNc2vxo144xywdsN8Ukb1TJznHCNV
	IwHNReqmiRpkfbtsBMn7MPgmfjgDR6U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VTYItZUz;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757932655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AE1mZo5dM28REMNEPIlpmNiMCj/YW4kRPZdnAEmZK3w=;
	b=VTYItZUzyQBFJPrxG2BJk1Dafs3gZI6Zdw03pJup/lMG6zVaMTqM3K1w07xCKFv9NSEmpt
	oHfeM6s0hzG3j5Xmv79zlpzmyL51ybn0rgc5xunot3vqJx1JdVu807DJfpZ4vlEmxRfw/x
	HKjFpBpgvaGouv1pZxJUUq8AtXplekM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-NOULgBa3PhG78pZJ6PRQwQ-1; Mon, 15 Sep 2025 06:37:34 -0400
X-MC-Unique: NOULgBa3PhG78pZJ6PRQwQ-1
X-Mimecast-MFC-AGG-ID: NOULgBa3PhG78pZJ6PRQwQ_1757932653
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so29324345e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757932653; x=1758537453;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AE1mZo5dM28REMNEPIlpmNiMCj/YW4kRPZdnAEmZK3w=;
        b=GGtD6frfXWcteEat5EZk4p4821PrNSXnBpdT3S4RIKdXsqiHhbygGUWzXyCSytEhJo
         5r4iWJO81v6Xe27ARefuXHdVyYy41q4ketmuBq9NkABXhnleNe8i0I9ZxJ5aFhoghbmt
         XOwDWQJT1HYkBF+2TU1EUSZf8Cd1Lh+HaaWIkjo0350i6VAPZpHTW/IMHOYv5oszykl/
         GszLjlihF1gJ1xnVrgrup1UkmAmsCxloq2MvH1GBmfZs+qzHQFcUI0mvtDi3NpoVLXYi
         vCIPDELD+X2FFMktjCMSP/gUdk3ZepgwD9LPK8wEHUxAlvosfeOXGUrORjeNaFSSh9yZ
         oy7A==
X-Forwarded-Encrypted: i=1; AJvYcCXJRi5QrFEbcLp7Mo/x6onMlCbaLklNc6HcQgq8q1U3Wka21bOQ9rvEImYi0PwIC7RQyjWmBX0WxQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5rck+MWaT+K2D/SuJojxrG/GMY9KIEfsofff0wY5OPCtt0Esl
	zpZe94Ae31zXBk0l7bPNBlkILCndXQnBcG/qT6j7O89HIEYrZmSHRx1CdyLvxCRX4U0V3Cnqlzm
	//R3cCl9LzhlzxpxI1UbVCvmdEWJPtW+rwJ3yViYD8QddOzyNwius
X-Gm-Gg: ASbGnctgScCLJgTJuEdQ1vakF743UuZmLFXTZpwxFnRLSdly9aEecSoH2N9Ni8USl4i
	A8vNQzBpFTnIy8tiON5ZTPRrQ835AQWRFwWrrb1SD5iqDblYl9v1iRkQxQhhzvVvXTdvo0mcrgR
	xr5R+cJBTEUN/f3SVCKUDHkYOvtZMEBKpnht9B+mViL7mmCAalpjmWnd6xqh4aN8fJcQh3wr5Ca
	GgkWNSToMrxBidxlTSS/RA74GYW91jHra8dhYgc2AIuadSIWorsJYhs4bDwsCEpZZKZ5noyBrFH
	g6vwGf5Y3Su/xYsQntrehTthNEIrkukwcyPfc3SczAvh1u5lQ8B3hoW4Ci+IK2QxtVM82X/Ujuu
	gQ0ldTZE2lLcrFf4wfZ8SfO/G8Fm/2DWfaeI3VMxn4FA5Y/Ol2d1LJS1FysUYi1uvCzM=
X-Received: by 2002:a05:600c:3414:b0:45d:f680:3140 with SMTP id 5b1f17b1804b1-45dfd5ab209mr99450615e9.2.1757932653211;
        Mon, 15 Sep 2025 03:37:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKqPx+HEJeLSB1hCo0z7zZzUc9au6zeGG4k2n2MG+k85CvLdXKo6KoDdaStSnTH9xLtijK0g==
X-Received: by 2002:a05:600c:3414:b0:45d:f680:3140 with SMTP id 5b1f17b1804b1-45dfd5ab209mr99450255e9.2.1757932652781;
        Mon, 15 Sep 2025 03:37:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e41b6dbdbsm158366625e9.22.2025.09.15.03.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 03:37:32 -0700 (PDT)
Message-ID: <f1d36416-bb96-4ed1-bf0a-5e1445fbbdd6@redhat.com>
Date: Mon, 15 Sep 2025 12:37:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
 <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
 <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
 <78d75263-e0ab-4dcd-ae97-5c5c9bb10193@redhat.com>
 <85aa2020-5b5e-4bfc-aade-581d20aeff87@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85aa2020-5b5e-4bfc-aade-581d20aeff87@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 481-Z24iPkGB0UWXFg9y8Nb3rvNO-rsM4D-svqF7Wo4_1757932653
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: om1pkpbiiu3jcrj3cyx38uda99kwfb7n
X-Rspamd-Queue-Id: 413931C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757932656-307960
X-HE-Meta: U2FsdGVkX1/+flwo71u2s48FC7LVJ3dvcRMCcMxZnFL+e6pDVpQ86LKMncobeMjX3/LyqiPObWfLoOCFVYGo/ctu4hwdo3T1kDzkJmOsb6EmORFfmMOOG47LnyrFuZtdEvPq0/lP6H15lRG6GUHoUUAX8PlMTMcuGfBa1L2EyhmmxBw7jsmor5Nekl1+L6HspjlorpwRoZmHhPeL51zMwNM19fBFQh4GzaZNXH/w/QPKzmk0s/mE1OusbKpjjQ50dR2ER7vDONd2XgK7r/U4Dmd1IT3eZKqaOClj5xMbOrgXfJIcUMR+338jrdK0wwvjUTYnE3VTlCGvL1ZFWagU1LY5XuBfhhJ9k103M/XhWTUvStolJYZam6BBTEQrDDgYl78B4NZh1nGTXtOW8YAoTG1MlsEtRVy/z1LedbzYfBDuoEekazn2Sn2c5zSJeRkRCCHqkvuVd7zG/cQg34CQqGcB07PqyqJGWaAvVPPzu1H8KRkwX6rbGxIjtZQaRg5SDie0SkrlHR1U0gFTSD5uTcKAJS35IklNdZQSrm/7SQErnzClUN9IXpsMcyOVWp2zfkDRQOMLbJE24fZRznXyq/EZr6qw2Gsl6j4r7360wH1sUipfweas5rgHUbKD3tDS6jjglfjSrk436kiiUg+UAV4jxXcLZOaNDFl+YvOwcNdG0h3cBQNrx64yYVuvc4P24/jfBxrkodTm9KMlyPp5jG44zBsfB9XxlivtEIU6DqyI6qe9eBYsjAIWM9HpmIdboDRf+Un4WBb2HX1yq8LNvnuzNNcDVES9936iTPQyTLoxqWv22q2/aVK+KFNpgJrs7UNHlkXl4F1XSY3PehAzEX86j/ZDLdx+zQnn68S8S7cXttmEg3xMpDwyXrvdFXYv2suKZVmj1r7B/MDQtZX+4yoidqGpEnv5kjlOXb9c0n/xG3ZkWqym11C4dnDg42vV30RSCMubvelA0Crohbg
 SMEZqduB
 Cp28CKbnWRsEUzJttdJoPtl196o/FRZju8HZ2C1G0GwHd9f6KXRw0ZF5gf4uvPxShFCDk5MZTOoucnedd5l4DYPbTdjfqH7XDsPmtQU5loJJDvzY6RBaTARmxxsvaqpktWdj+9O1Pz+Ngb5nv/Do3FagVBfvao424i+Sr0Ut9aqrHa11SYB5T75T9XZwMkILmXQgOIpMBxU6LLXu/v+S7sH5MFFuRyw5YIEvHbZaylpd8Ifx0z6LmMXVtK32E2of66HZaeaEYqXzSf+cNFgZKF3pazvtS0YUgzFYKSNNsiJGrJ13aFqNZ+lyBox/XmnUn9W2s0S/5/9XT4ts9/KxsJGOt5q2jfmlD80gVFlZvxcMsZLayGi+xScKgMZ0RKUOSciS3WHaL0Jze6L0SocP+uCmdUiATO+KV+8Og+awAT7z91RfhvS3WFsSZKiSnAwOqvXU5IF8FQ0qsd0DEuSzFz+n6xr5j/AVxfnJp8lq72OZEBZJyvyn6wYSMYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 12:32, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 12:25:54PM +0200, David Hildenbrand wrote:
>>>>
>>>> I would just say "The kernel might decide to use a more conservative approach
>>>> when collapsing smaller THPs" etc.
>>>>
>>>>
>>>> Thoughts?
>>>
>>> Well I've sort of reviewed oppositely there :) well at least that it needs to be
>>> a hell of a lot clearer (I find that comment really compressed and I just don't
>>> really understand it).
>>
>> Right. I think these are just details we should hide from the user. And in
>> particular, not over-document it so we can more easily change semantics
>> later.
> 
> And when we change semantics we can't change comments?
> 
> I mean maybe we're talking across purposes here, I'm talking about code
> comments, not the documentation.
> 
> I agree the documentation should not mention any of this.

Yes, I was talking about patch #15 ("It's just when it comes to 
documenting all that stuff in patch #15").

Comments we can adjust as we please of course :)

-- 
Cheers

David / dhildenb


