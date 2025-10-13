Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F13ECCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8328E0019; Mon, 13 Oct 2025 04:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F9E8E0002; Mon, 13 Oct 2025 04:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21308E0019; Mon, 13 Oct 2025 04:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC21C8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:08:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E5771602FB
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:08:53 +0000 (UTC)
X-FDA: 83992364946.27.D12E11A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id EF6C8120009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:08:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ccnX0yhI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342931; a=rsa-sha256;
	cv=none;
	b=H1cPEU/d0l7c4ov6MyMfRTHd81UQoKXnvkulXH+zelJqWlSGAeiMdBcegMrqDN7Cu5bikt
	igcz3jvHhXcqWPR222/BZ4T4a7qZpIW4aSTvNlnNRtMM9MU/2/fCgvr2Pwf4zyjnwZe5N9
	xilfIk+yybg0onlCcrp4linIA1sb1ko=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ccnX0yhI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rGWhIH6coFHE3rQ0DRdJqk5g1C+PTj7t73yGUhElbM=;
	b=ZGeixzrhYAWFnaPr9U7YXq0hO1GSsXawL73kRvsngyB71bnQlUWdusHoFjczxS54D7MvWU
	0H/rIBCu5ZLUvvCjapxHdwFPBvGR1DJJbchiuRrYdmn9n5wuv2JOzT/PF6o4KfZVq8wtV/
	b4+R+55hFbsF+kHYEqpKafuX15ZocRc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760342930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4rGWhIH6coFHE3rQ0DRdJqk5g1C+PTj7t73yGUhElbM=;
	b=ccnX0yhIbRpZ4FZ9ASgUc55/6p1iw/ibM4CmwBqBP+K96dR/zWP5/HeNq9thKe3kNvthuM
	yDMnp8WIcTt7A2ktVHq5hlqLawmNvkmxwhS2Tbrxv6J1H6ZxRDxxCg36vtC+iQRIt8PqIs
	xnFszFkG37SxLU1har/Wpi3FpNQ1hF8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-DB8pI9xoObGx5Ej6-2Y8JA-1; Mon, 13 Oct 2025 04:08:46 -0400
X-MC-Unique: DB8pI9xoObGx5Ej6-2Y8JA-1
X-Mimecast-MFC-AGG-ID: DB8pI9xoObGx5Ej6-2Y8JA_1760342926
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e473e577eso26423045e9.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760342926; x=1760947726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4rGWhIH6coFHE3rQ0DRdJqk5g1C+PTj7t73yGUhElbM=;
        b=mfmwx9APoUCm7uZUdcJK2SKWD9McaoF9F5Nsg7MY+j2H2BLgfgGezmSUyaVHDdWVdd
         fAR9ivhY1xUMrutEulNG9SmGMPweVq8pBlhw9imRmR/9PEgrBcfiuyVvOtXcihTVbdwb
         L6tjEzVXYKOlKD1pdG+6IQjODmPsl7C3YWVY8ZjdmwphK34fgYoCLinQf/6AB9DiFW6b
         nzNIfk2AYBJfN/hKDomY1Ky/MLq76BgMZriUFdwrkoHFPBNfR68bXieffxHWdX5DCToK
         zj/jm0MC9oOd7dzj9H9kzoLR3NWj0pAOr6CMzokJ0/vukjRfe4gogUG7Sy33N1C3JJey
         1xyQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8c//MyWhBlPe1dKM0X1LVq7M+xweWDbNH23QlQXM+iyDY6bIF6F9PMS0Cfm0nRqSe2SGWRzfzHA==@kvack.org
X-Gm-Message-State: AOJu0Yyudi0RoYQLRXBRkb7/oHlm8uI07pMBuXgyFpl/ffiv+m2DnmDr
	EjesmlEhIIZ53ToB5N2H58xOLKIq9X7I59azSfQlL7NYTctB/yW02XIdMgeaq6ZS9m4JoGOV1Rv
	w+NJq1YDTXEX6MEWYYYpjCOrzpzrmF4TMISI9gt2OxdaKf+uF5wbL
X-Gm-Gg: ASbGncv4kYxLIiLEw/qJmf0UoXsjosmWuHci2x33TXZHvkT2ySVd1RKcsg7FKVXtAU4
	Ezy0PbSQKX9MIQiYryAPRWR7uzfW9VuqfVDAAeA+d29r3shLFG796whZmnw451bOTy0MuOAENVp
	Z+7MZjMXVaPTUvsgaiKCqiAM9FXe0ABeC9j5x+MVt7Xc21xTdy34WDXmZBqF5e+9hXGg5ihtWe5
	/NmL2RXqCN7Coc6pY545coJs6JsAik+oInZc5CH0Ax8gko10PZQdbtwA4ALTfLPEC2B/DdosDJ5
	xhhNJvRnJwcNZHqGyFbHiTNqzNYIp9/OJoAHSFfbJgCfoN18hU56iPs27pFJTKBaHNpXF435uzV
	d0y0=
X-Received: by 2002:a05:600c:a02:b0:46e:4499:ba30 with SMTP id 5b1f17b1804b1-46fa9b052f2mr149913715e9.30.1760342925672;
        Mon, 13 Oct 2025 01:08:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKuCmdhxrI4bLVD9WE9l2bFabtqBxMzkFdsNlub69j8Pv4V5ZKLQqIsHuujn6qApLkW7GwzQ==
X-Received: by 2002:a05:600c:a02:b0:46e:4499:ba30 with SMTP id 5b1f17b1804b1-46fa9b052f2mr149913505e9.30.1760342925288;
        Mon, 13 Oct 2025 01:08:45 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3cd658sm126106175e9.1.2025.10.13.01.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 01:08:44 -0700 (PDT)
Message-ID: <bd88ec46-0588-4915-9737-15ddee4678ae@redhat.com>
Date: Mon, 13 Oct 2025 10:08:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
To: Byungchul Park <byungchul@sk.com>
Cc: Yunseong Kim <ysk@kzalloc.com>, Hillf Danton <hdanton@sina.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, Yeoreum Yun <yeoreum.yun@arm.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <20251002220211.8009-1-hdanton@sina.com>
 <20251003004828.GA75385@system.software.com>
 <20251003005230.GB75385@system.software.com>
 <3b66d603-543d-4616-92a5-9e6e32f116be@kzalloc.com>
 <deb6c0a2-e166-4c91-9736-276c9f1741c9@redhat.com>
 <20251013043631.GC6925@system.software.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013043631.GC6925@system.software.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kh00J4MR1i28_Vc57KBLflUzLnj0hltRqTJIjOKbFg0_1760342926
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF6C8120009
X-Stat-Signature: iwnd34fbnu6xfsqtjes55e13mhs9nbmt
X-HE-Tag: 1760342930-956353
X-HE-Meta: U2FsdGVkX18IJvOzE2/vSZzTe1WZGxxc59zWVjqLIykNJ0P+l8CGkasQBwediT84/UtPD+3eFGL0iWAryGwybS/Yuq1j05A+pQIxu2dh6gixD3jXdlwnNDEZVYrBwDImEmV1pQ1QRcaFxBBQfYL0nGiB7nMxuk2L6CS/82fBNAyn1jkjKUhu20+Sx5Tywngsu58F9dGUop6XhD/A5jN6T9hfuyeuCnmVk4hipksBPQHESxj+yK7n1fw5Pi2d+eP2NAZGjt611wtkrEO3Ll1s0PxX6isSFMjOIr7JtMDsICMEoy7uGAWsc6DQMUoQpo1J8y1/4sngO3n3EzMS7aT6tiXSyM3LKAIa7T2nhXzpdLu07ZLThaOZhf1l1oeL6DSzJh7jG0M/eMsteuYjsrK78fXewAEu3ty4vjegS96xr91kmI50jaZDZxQpwVNzPbRvz/VTg0KLeo4fjSkdb0rEgokwByPvoxLJF+7hzv7T9XHtaYHR5CA9ZoLRkj3og2a7fXDEgfFmUpgeR84GXlWc8XXft5eQZrj0muO80Y+KLuQHyfv8A3Ktf4p1nPZp80Nvxysi4cMoae3mYvLLx62vquoTiHk74LTIyC5eOvHPSg1RjVMw5g/hp7Zs7X0od049ZNwBd+YwvrFj7T/3Z2KT/M8wj2g4BLAZG1niDTukq2GDf9sFLhU//f7JSd/qG/qOmV8aGI1+gO4k48oYPjWpLUfugJbL2cPPq8ptKXEaF4+KsrRw3mxi2pH4aGj6VmWSplzOV3ZxTXoVSVP74lHCNBBsnI449EyL2pVevafugE3dvj6aHxMPJkKAlNC2NCwU11K0LTbhkMN6X6poyUIRzCmTn/VGQ5OSxPbbNXcFzg0Dka+7O8X65r4u+oxynssdPHAiJZSqtSfOMqib+yD5UQOGK2NPLZRnbFHidHN3eUc/Sb4vfvFp4gHHAlW7Vd1zsFjIYjUGknLh6jFSvWF
 gpw8GYZ4
 9oAjrxepnphD/nsdd6aTzTrpyKk9SjOSioWOJJP6yIWJJluOCVZKOO7tO0g6DADU/qRyZT1DdHdZEk/SxK4ug0bq4NHJjXDqi6aHYda4ZtVg6FOOiGMqQzUm01yB+NPDHmMTNvefnFjL9NpfoDClgspyWornXX/igBJC5bWXQUrpcPRZt0AB2mvUK9u3ORDfERvJcKZXItbzQQHHRFOjLXXjYZLcGUuJ9sqWysZFKuJwjruYUIU2waSZcGmzvlJA+KgXLCRrnLstK1EyFKCDjlOSDUb7hXFR6qVQiIkzjRuYbvjBq+10Me+IRLHgUr7Hi4VSNEPpsslBbH9uYzZtyOP9N+VwF3hQGjgYPaHKAMDO+vADZOzI1ykbNVTUp2tAhqO39nC85wPylyZWhmNTKFLvISk4u+rXSj4+rSmibT++6zJsqlfZrh5NdP1lAPuUhDr8iEXaZXUifgFOpFu9eCOxmEggkl32dWCfkPT548qRqDqN1s0ADFrewlfM+HLVDTefBN8CH6X9vFxuPweIOWX8NvizWDrYB1pOKskdA5s6U8F2otFRuMiGoUwPFBDtXWmst9jT1qhn1L/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 06:36, Byungchul Park wrote:
> On Tue, Oct 07, 2025 at 09:04:59AM +0200, David Hildenbrand wrote:
>> On 07.10.25 08:32, Yunseong Kim wrote:
>>> Hi Hillf,
>>>
>>> Here are the syzlang and kernel log, and you can also find the gist snippet
>>> in the body of the first RFC mail:
>>>
>>>    https://gist.github.com/kzall0c/a6091bb2fd536865ca9aabfd017a1fc5
>>>
>>> I am reviewing this issue again on the v6.17, The issue is always reproducible,
>>> usually occurring within about 10k attempts with the 8 procs.
>>
>> I can see a DEPT splat and I wonder what happens if DEPT is disabled.
>>
>> Will the machine actually deadlock or is this just DEPT complaining (and
> 
> Of course, it was an actual deadlock, not just DEPT splat.

Okay, so some deadlock was triggered, but not the one described by DEPT, 
thanks.

-- 
Cheers

David / dhildenb


