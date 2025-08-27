Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B700DCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9DB76B0006; Wed, 27 Aug 2025 16:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75846B0007; Wed, 27 Aug 2025 16:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B2A6B0008; Wed, 27 Aug 2025 16:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C89456B0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:01:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F52ABBA62
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:01:53 +0000 (UTC)
X-FDA: 83823608106.25.D6307C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id E6A991A0014
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:01:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dvKctROz;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756324911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYqkjtN1JFfwlUAqfFsvOnMI5dplQR5YXMojjDPr8tU=;
	b=yz/6Czowpb72j/3nB7PiE/jOAjGJo1DSqMrUxXyLNINNaKWbBtq5LgyvJrB9++EqWk/nfP
	mOs8CA5UXj3DQQFJIeTSBkJ9L3b2HQTUwstvHIWAatSiOIR7HK11HP5GN6Ghb6Iz6zX+cZ
	vPqv6bC0EGC/Xqb7KzUFuemdKWaEalM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dvKctROz;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756324911; a=rsa-sha256;
	cv=none;
	b=yEqVs9V0kuqjsmxdaTDiV3JTbucIKWQ0CPY7oM1z0wHKLqw//Z7Mi1vr5n5Gip4OXYGRyd
	IhIt5zSDyVH/Sy5CWkNCNJNhAFEZgirxSH7iLK6vTtJlKbt9ShG50AWn829HH8Bygu66ZC
	nd3aIISUD1yd88cAuJKwB27f2TPoNqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756324910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UYqkjtN1JFfwlUAqfFsvOnMI5dplQR5YXMojjDPr8tU=;
	b=dvKctROzpLbokiIJf92OAAX3ADe9c9xMpvWq+Inz3He/aVSdAUiOjynxFDODtgRP3Vcflz
	YACY061gnvVGCoAfWapVaPmwTkZuQd3IEg750ehq6ptxSxzzAUShtWwWXGggfqgVpvYst3
	3GVnytNtEHcR3OHpopaNtYqp6DXBpAo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-iefEpKLqPYa5mDzkjHh7bw-1; Wed, 27 Aug 2025 16:01:48 -0400
X-MC-Unique: iefEpKLqPYa5mDzkjHh7bw-1
X-Mimecast-MFC-AGG-ID: iefEpKLqPYa5mDzkjHh7bw_1756324908
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0c5366so898175e9.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756324907; x=1756929707;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UYqkjtN1JFfwlUAqfFsvOnMI5dplQR5YXMojjDPr8tU=;
        b=BmJtMv+c1Ab21in9iE+HFuPLxlY7Ev20F4qSqG3h9CriyI89tYcqwSfO4R7CQkpdn4
         fvUAS8PEsK+eMAITuqRchCrCMGyRhmW0V+EtGojLVSe/DWSY8Tr+Rru8Qwy2OfkDhGmu
         soraitut8S7TrmMVJYu+bQ6FOPvzrJ+w6fy0TCWJkmZ56wV4RSuwau5TknadB1qxEcp5
         DR5bPMtCOk7SIaYJ+6B6qg8fD85zaNJmFw4Q/ump2TD8VI2GOf+h67wg+0hDsB0wycQG
         ry9Di3ynXYvzaZze7Z+pd7aBgh/p8+3gNHP7B+i4eVYkJduElQQORHrjwyDngOkp4hqu
         Gz+A==
X-Forwarded-Encrypted: i=1; AJvYcCXX7BToKk9sBJFCiyTNN9DkiVd9mZ3MUvAIsGtNt1Gj2g5u35GyivnH2fACOkr/Ocfvf5rrpSbSbA==@kvack.org
X-Gm-Message-State: AOJu0YxkVQy9A+e/hyH/B0ehQzb+kya4V1sanzdnOLDy3b8+Vrn4NOHi
	XuJpQBKW1uf75KE4kBttizcq6CCLIAywMSl0kFLjiSmpD4qWWFdzSGZ/XPrdfM47EZ1ijRmCpHr
	3f1PYYdrP6wuSV0vO82WPRgaCqpn7DFCY+8P+vBYLM1+gyF6VFTWW
X-Gm-Gg: ASbGncsK7tH89O59jUOKm0JhfLDSZzuqWIW3VsWE1uB/v1h7Dnow4VwPkyZKxuVu4Tp
	103BcX+iVMD4+GHeXFMBOpDQ02tlueXPkKXlCRkljXXm+aWeZTj8jqEqROmC0Xxy6k2stdk3Sq6
	NIHzjLyRYk4vJnJbwFTbNJxNHPuGnXUsz2hLfuQSL9rHyXFZhxn+3pRr2tO9kHr/NVoMyCwdBaC
	YbmFmY/ADICFqCCI2PRLYbyBiUl2CBqvV/nHU8qzjWMjvXja3cHoWYwpRx3QqrBQVO/OMMp1iGv
	RvscQNQ1jX+arCOJO1XHg7kwKGV74PehbGY1aLyFJp/kRpok6phmYlwxCjrHebLs8sz7Xpw=
X-Received: by 2002:a05:600c:1552:b0:459:d3d0:6507 with SMTP id 5b1f17b1804b1-45b517d9eecmr158174865e9.32.1756324907482;
        Wed, 27 Aug 2025 13:01:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEh+BGCBEwRzTA4du6R/9CuTee1WNYaJBMwU4SV32gJ/BEUsY+1Pqx5bTC12AkbEN54umRLQQ==
X-Received: by 2002:a05:600c:1552:b0:459:d3d0:6507 with SMTP id 5b1f17b1804b1-45b517d9eecmr158174675e9.32.1756324907074;
        Wed, 27 Aug 2025 13:01:47 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fc83.dip0.t-ipconnect.de. [79.241.252.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cbf1f5fc1bsm6731329f8f.54.2025.08.27.13.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 13:01:46 -0700 (PDT)
Message-ID: <0de24b30-70ad-498f-9eac-01596c8713df@redhat.com>
Date: Wed, 27 Aug 2025 22:01:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, chrisl@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
 <20250827150330.280399-1-max.kellermann@ionos.com>
 <30f52bf5-ff37-4e22-ac57-7be0b03b1f51@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <30f52bf5-ff37-4e22-ac57-7be0b03b1f51@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YR6x4_1AtuC0bhAwwHqoIFiMe31Iu_bcXogxJoD07QM_1756324908
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E6A991A0014
X-Rspam-User: 
X-Stat-Signature: 3ia4t3eh15hxtsmqfibxrn9w3afo4qn7
X-Rspamd-Server: rspam09
X-HE-Tag: 1756324910-492005
X-HE-Meta: U2FsdGVkX1+UpwrgsLAKTS74buss0ooXrmW/TIIBqr86QibHiAPkUCOQrAX/J8wH/xB+ZmDCLLFVEMdH5Lp/zC+H1goluuzIlN3xQkfi+dKhUmqEfBbuE7qZwBkPqQawjScoeRfaun4Jwi5T8+tvuIK9Y8shHYB4rw5oRaqcBH18Jqhb2ITNPGQjh2DDvnWegfAqgkG6UR70DOwve/YsTcms6oL1Rnr223BJMMz+yUp/6qpWmk4lnes2hkKy+ZJVnNLzgNO6c+tjonnXFbl+tjikUNU/JiV3kBPjo0LgARabhpC48JeLXmcsO7qmIED5IOyjfEhC++QF+ccDs35gnXo7QDcwDoneL6itBtmDzCcnN/4c8ZXnUvdmROzcq/Xz6my5CReh11XKl4R8RyPcVV8HaUwIEVziFs+J5Z/fA+9V0PCp/k1jGpiPjvJGQU/gPOFcOiKkhdlC2aMsst6wkXZV68hDheM/1z8TfNvIOkS2BmRWetyaOj7Mh6MCBfBQ7A8VV57ESR5vI/4XNxTABCEZq1aoQL7c4V3AYM64m4CzhDkelrf5+C0CynwqqH2W+oaaqByltiETB+09gPU8+g2UDwF6QGfrfVznP3XIvWivE0JxbwN4rY27KoHXipL6pHnvSbBIUj5JgCCuZWBjTzezaX4wLx45ZQ9n8FKaS/5ErSKceBorlS9J6C26UGZyZE//byo1d0stwtIkr8xBtZrOfIoGFwnjgx1ffzjhFZN+1GoGNK+6H8bQLmBGbKMtTTy38apl9TxOK9HpCXpT3rSf2yg4eADz71wNVMmgOSRr3TNfWhdKnLM9qtllFO2J21svB6qwBNOjO6JwL7Cowvg752ApveV8VCwHtFBB+ANbYcBFSts2G+ZMiPQ5CzCn/C108kiNFnP+S8Y/tk7m6W3K9X+6K3VndwA7iM0ETvj6PKh+l3wNgFt5O20vtp+nSWQmOjgAq9bunxJemAh
 DNx6EKU3
 7aZLZlqGGy4ajiQgSmh35SX0ghPNRUp2S++3M9vmKQ2dm506xBQmvnby1lmVSH+gUy+9SLecifSiUPuJwqGwlTAugJbP5l8bDmPYaPGWthbv0Yh7GFMmf0T3FjfNTqqlWId8f7lBnHdfdIIQoiwBKGcRgYGlnlS2epPxJWvwKpshRTqMhdt3+g0roxW09cb3CFMair9CDM28uW2O6KhrOj9/YzmpP2diz2jHnw44QPIMVJ+4j8UhgzKTGiD3yZ8QLTm2docSer2kHcxL6tU4urS3+uE+75442SoCdR9tLpee2obXG7wpQOQqjAx/JrjIoAFkcQ9e4tfT6USh7WyCCQDZfj5a1/pwuK1NzRdf6Ok0avX9mMBm1jTPDtxv+gb6p67kSMz390eMiCqiI/ITYJEIsxB8rVCGGcEBHEYjb0NezocVrH+3osGWWerc3ck8cAOkOOlc0lVhiX8q4Tqeawt57L6Pius1MDOXtb6dS1egqQG3a3YjB6gf3O9hU01kbrSdOeSCG0N3HknIVDSYDDMTI0P+i2JKAfWC6HNOkM9TaCXkmCm4eeT1J/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> This seems not so great.
> 
> I really think the VM_WARN_ON_ONCE() should be in folios_put_refs() based
> on what you've said.

No.

Everything in folio_put_refs() will dereference the folio and properly 
crash the machine when doing something stupid.

This function, however, will silently swallow a "NULL" pointer.

> 
>>
>> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
>> ---
>>   include/linux/huge_mm.h | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 7748489fde1b..bc9ca7798f2e 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -2,6 +2,7 @@
>>   #ifndef _LINUX_HUGE_MM_H
>>   #define _LINUX_HUGE_MM_H
>>
>> +#include <linux/mmdebug.h> // for VM_WARN_ON_ONCE()
> 
> Please don't do //.
> 
> This include is suspect though, huge_mm.h is included from mm.h and thus
> this very easily might break some arch that is weird about this stuff,
> because a ton of stuff includes mm.h including things that might absolutely
> baulk at mmdebug.

Jup. Very likely this is not required.

> 
> I've had this kind of thing happen several times before.
> 
>>   #include <linux/mm_types.h>
>>
>>   #include <linux/fs.h> /* only for vma_is_dax() */
>> @@ -479,6 +480,8 @@ extern unsigned long huge_zero_pfn;
>>
>>   static inline bool is_huge_zero_folio(const struct folio *folio)
>>   {
>> +	VM_WARN_ON_ONCE(folio == NULL);
>> +
> 
> Convention is VM_WARN_ON_ONCE(!folio);

Wanted to comment the same thing.

-- 
Cheers

David / dhildenb


