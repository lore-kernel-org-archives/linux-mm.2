Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48D1C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69446B009D; Wed,  5 Aug 2026 12:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40AD6B009E; Wed,  5 Aug 2026 12:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56AE6B009F; Wed,  5 Aug 2026 12:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C47A6B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:29:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E248A12050D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:29:14 +0000 (UTC)
X-FDA: 85067750628.09.6533D1A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88400C0002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:29:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F947xCQh;
	spf=pass (imf10.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785947352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ekaj1w74e/IlHxyDhw3APH1qT4hJfeKb9Oncbh24AZs=;
	b=D8B30j0Hh/TvYkDjs0fC9Z28QtcBH8HPl1hk7Y8cr85ul32d/bIa33YXwlLMvJ/c35sZoU
	mRhKjCXN3kMy8iDokMcbW8kzpGxKFEReYHWWKWtufsi2Bw2Fa0zDFP3uW2XMnkqDVFy6/6
	vnsT7tk1cVBKEgGuDvJ6K8CrrxGtous=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785947352;
	b=8d6cBaXC3XNR5esM8+BAm/kaqttXGVuiFXy12k3SeLnzjzok48UUXK/Wv7xI+8IUR19dmD
	K1n6l3ihDvMHWQApokqWOEbdvlprXnEwhNFuX44YQjeMszHFHUJP4Db7s5Po4+XoBib54S
	DeLQZbmh7mphtklcy1KzWwwFhLv7Pxk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F947xCQh;
	spf=pass (imf10.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785947352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ekaj1w74e/IlHxyDhw3APH1qT4hJfeKb9Oncbh24AZs=;
	b=F947xCQhBntI96dOyWrhBoBg8RmSJiARCcsTmF8Bticgy4Gx/giAYODE0hVBF8KV3ukC4c
	CiNBXpRLI3Q1H06MCNFFSnP50MYbXNvUdmWpc8I9X5vIcZtkDATuebgZwrFAmOGloV2PWu
	fidt3Z3m3oeRS2ou0w3B2MkMPqH5h8E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-fJdEDxqnOQ2GahqjssY8KQ-1; Wed, 05 Aug 2026 12:29:10 -0400
X-MC-Unique: fJdEDxqnOQ2GahqjssY8KQ-1
X-Mimecast-MFC-AGG-ID: fJdEDxqnOQ2GahqjssY8KQ_1785947349
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495474a5fbcso10817365e9.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 09:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785947349; x=1786552149;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ekaj1w74e/IlHxyDhw3APH1qT4hJfeKb9Oncbh24AZs=;
        b=PgE/iVIAP2ihgWhIsuObPkQfP6/QsDcjQaiWyRuH7DAv//gsxXOqae+5fqLXmlJvc/
         PgLeObuYml/AB9dUUZf6KWl/bZyi2jLY1CGd1EiNYy16DYaODXkwkqWL0A56NYIbVpRT
         gUswKSws6oySKeQJAJ+Er21znC86iyFFDkC3Kke20gG2dOK6Dpuu3mXb8hZu0ORV2IJv
         zGVDHbic5ruQeSw7jWTSqgTQJ/9r0TWWLKS6bdTBogL0p3BSvLmXanhNMoe0x8PSlOZd
         9NVwIjj6ptcjPHjdOqniHl6R/fZAxnhRsE02s/IHBd2EYR/4wz5pglA8zGUWcWFby5eX
         VSMg==
X-Forwarded-Encrypted: i=1; AHgh+Rr419jlRJAiZSvgEWx7AnR3NG1vmRBEQMKUQfQbr13jIzL6fsjkhOuIjmfUiF04lp9mDBOEN5nsOg==@kvack.org
X-Gm-Message-State: AOJu0Yw4EVGynZyH7JW0nH2d3mJTcy2Lih8BsPQb79oeIXj3333FSA6b
	aJmkAynMdhk9YKHX35BhJHf8FlMeS7qqLcxIwqicN1F7WO40AcuNTGedVeJRlMlrv5bpeRecLVb
	VDZe0b8h12wQy8K7jmLa/G+qKzBgUap5RYvdGj/I9DJwiMeTqq9lV
X-Gm-Gg: AR+sD13xizkTybn89nDN2HMRETjAtC4tr5ZyUy0w9KHc6Dzyn8lw5dALWxJTwqe+nfN
	mJ3Ghtu+x3Mbdl42uxLZtSHRspNzczII6E5ffJZN4+xeBf8+mx1IZfYCcFIoxWNwYtaan9ieb34
	VXFiGIDFvhH3cUig7Q8qOpH2dGDdz148Fj2E8E7gKX/DEpWuFc5XWe49hoXuRm60P5kqQ7NRovm
	fkGpxvw9PMGI/Gnaquh4KPJUkYN4B+rG7X/sCa9xHSGBQcAxbJvdjMZUp2hHnqaX9g2kkFvi0V9
	1u28WUwAuAR7nEt/MOM6A8HqdUNOM4k8EkNYqElgvuEriz4cNyi62RpnOTORY1Pqf4u5C1LF3go
	lMpimUtXZ5sUMzJV1H4/ks+5WIRA7cWp/Zo1Q5WU=
X-Received: by 2002:a05:600c:1992:b0:496:c378:6420 with SMTP id 5b1f17b1804b1-4994e71a1c9mr95297905e9.8.1785947349382;
        Wed, 05 Aug 2026 09:29:09 -0700 (PDT)
X-Received: by 2002:a05:600c:1992:b0:496:c378:6420 with SMTP id 5b1f17b1804b1-4994e71a1c9mr95297075e9.8.1785947348923;
        Wed, 05 Aug 2026 09:29:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e980559sm63248655e9.2.2026.08.05.09.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 09:29:07 -0700 (PDT)
Message-ID: <f275f77f-2773-41fa-b4c1-ed3b5123ab41@redhat.com>
Date: Wed, 5 Aug 2026 18:29:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, David Hildenbrand <david@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <anL-NZkNMSSxN0YN@lucifer> <4ddc95f2-8868-4be3-9839-e2d14cf35fef@redhat.com>
 <anNjdDxP5-Oq5eXk@lucifer>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <anNjdDxP5-Oq5eXk@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yb6WsoAghTboBHkyB3Av5AGpWu5IuT-Ugc0MvJT9HPA_1785947349
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bq954zxbj9fxpftbh8rx5yodeaaxbeed
X-Rspamd-Queue-Id: 88400C0002
X-HE-Tag: 1785947352-183033
X-HE-Meta: U2FsdGVkX1+gI1QY07MgFZWbzydbDQUiDN1P10+FrTEJbmqoqvJ/94SrqbjEfjMfdrwbjkX7vTIjAwciwMV93gNhjLfvS68uMD8FHuL2MmdcAtzGn8BYl/BSZuTsJY6Gq0Zz3qAxiludKVsCH3dLv1PdfsDGiRhSiE35F27EtEGH+OLeN+STXFaLzXk5qiFItZfbh4lu6HoB79cO9zvUmrNpzfPg8VrlBzrO3D4DkOfK52Vh+/45UKEAOQlRkun82pe+PW2RmiJTcx7eIazJ/16i4mMtLMXgKXhkAjl7TY0YmP1PoK9C51hgLytljV4ojYenbYAMlVWZ5yKgMsLTZhSV0rhDADwFh5y3SzcdeIgkUepSLB4Jh+nJDzMje188y9ZADk++g/jdRovDxkH95KiyS9tBYt02MJVpZ7FB27uavDnsHVH/kkDN2KU0me6HnW2UYw2MQGwnGk+O0Nd0W11WmTH61lCgKcEzWTyECaXlzHIqKgYD1gZ99DLC6FegRwsNbxuKMjdmupcs90VKwSHj9FtTApy8gFvAHUuVphTjBGE1mVym4QG/HJm5T7NK7Oj93FfBu2Ew0C+DDCTwkFBMsO8WnMPlKW1nyH7x9XEBKCYzWkDh2ExeIiAEpg/yOY2hKXd9kXOzGo8jBac0UorqSMYcYGu4Pk5aaXTJcMtHH4/18vYT4cgO9teRaRyaaN+lxROQsJ0aJFrakDVH+XZJ37sPvMBDd5OrZkAs3pdiZi0CD5yg7xf3RoP7vzf+5WwpjomP/Y/Sxnhuc0Fqx/tAxRTQlFNiIVVxOj3FrbdHKj58lDOpYKC6dDXBg38e4eQv9nwvWiUMhg3puhq15fWJ/8HmZSbdPJ7ZNWzR7gndjzppISsn2k6hdQZNh9EmfA1wNQ9sn7p20L7PR/01ffh9FeKGFp8aGWkr8RVWUJqllNTOud4tHuuptcGUMdoZf0N3bq6AFYXMIa+Mr/Y
 h4nHfhaE
 gLLlFGG7SoAouixi36UqHaGf/dlWDhYJkRpg2lu+tWH7r0aPmUzcF0X9J+nAN3l0VmFxXD7fYfiTJ3nk7bpgyGTn2yc6M9va1XlqBRgcAXBS+FkD8ZcET7rQJaIaT+MYypyHLjFMpKCaErWhrWYYWgzGju5npCxq888+eiTvaSmcafy0V52cEkQ29qGNk0d9IL4UvuGH/W9DACnVJGSYr7E2EkflcqxAjSE+N4ZV+h2WZ70ivOIL8vi7OKjJDs6cdp+vyUCXd0Y5M/WOfH+RHishX5NlE19dqKTVkTJTszy/YsWvmoFmV7B8+dK7AcV9UCKhiZ9V4kPtPVU2nPbJH9NWr/r07ykeMkhW4uIpvxIz02ss27p2zvzoVlOXQkCsed04Tafr15tkSMB2dp9eeHEAOGjI/HYxH/4vkbeoJZ0tAx0Djb3dursJJNzIRLL0OQIebMsRBxcCHFyn0lOReENLmv3PUtgQc9GiJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 18:26, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 05, 2026 at 06:21:30PM +0200, Cédric Le Goater wrote:
>> Thanks for the quick feedback Lorenzo !
>>> So I think it should be something more like the attached.
>>>
>>> That way all the handling remains the same and the override is applied in
>>> the right place plus smaps keeps working.
>>
>> LGTM, do you want me to respin a v2 with what's below ? or you'd rather
>> send it yourself.
> 
> Thanks, I think as it's somewhat divergent maybe better if I send it with
> Reported-by/Closes if that makes sense to you?

Of course,
  
> I'd like to get David's input on it first however!

Yep.

Thanks,

C.


