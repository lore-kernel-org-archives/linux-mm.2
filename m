Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB9EC56207
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83936B008A; Thu,  6 Aug 2026 10:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B1F6B0093; Thu,  6 Aug 2026 10:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B656B0096; Thu,  6 Aug 2026 10:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1CF6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:53:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 245C88076B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:53:17 +0000 (UTC)
X-FDA: 85071137634.23.9B88CCA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 88B901A0004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:53:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tq2A2VLS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786027994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX9Lc9HnIcANYvTu7RwrLXcqyyBe53wJ1JQ3SHKRvnU=;
	b=C7eR4Fk8y1fuy5/Ph8w4zy8NpYmDhDByprKr29NYP5NenRCMFL+ZybpCAc9+IB2Uuh+UtF
	an3rFnRrMqdmyYbtYz3gv2dppMGe9LQ//ePVgybvRV3FxhlpHLElf9F0qizPK5IwMQgEM0
	SfhgVN04VmgSJUkiOwkSpXGeJu5e3rg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tq2A2VLS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786027994;
	b=iywsbR3q/nEFoJK26JVPK1aSnEV8Nh3dfGQaA9bdBah/O/RXhnentFtSZZ78RX4rgCv/jA
	jU4RHVQvCZ+YHg+cuFu98Pqbu+4vLGHVsFU0HPbSyg+h7hFKDz/8i2w9OcEMoIBPyclRtj
	TYfJp+SSSmPC150W2x5XZMkcDW9ECSA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786027993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZX9Lc9HnIcANYvTu7RwrLXcqyyBe53wJ1JQ3SHKRvnU=;
	b=Tq2A2VLSpJgrqj9tPskyidyY6PQURhY+p16d9flewCpRBAQj22Ia6/flgLN1NM1l+j4Do2
	T/P/h8/IxBMk2KW2cnTy3THq42XrAL6I6G2frEuixlscHJireyVtJMpw8iL0wIYxBbFSTq
	OaM2dW8NyqeT08WKCMuwQ0m3bCeh0pc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-rDQuwiVtMNiqglxwb9NrAQ-1; Thu, 06 Aug 2026 10:53:12 -0400
X-MC-Unique: rDQuwiVtMNiqglxwb9NrAQ-1
X-Mimecast-MFC-AGG-ID: rDQuwiVtMNiqglxwb9NrAQ_1786027991
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4957287363bso13614915e9.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 07:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027991; x=1786632791;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZX9Lc9HnIcANYvTu7RwrLXcqyyBe53wJ1JQ3SHKRvnU=;
        b=WuftdgU+aBkzZFy4GydyEPq44d88HW2Izu1KHYJRr0AFsLft+3g4zSQLlne+bKO1H6
         dyNbPEagBmDPhk7csLBazz4cTEqRtj2ct9A9SlujAFxqsAp9TqWC2LqWUjeEf6UHnIVR
         XIy5xxGKEfAgl72qfyY8YnCxAXr7QHvFJPW5GWavJ6RBuXENPBQ2nggLLlkDLm/ntq5H
         UpjjwHWCu15BOhSJqXGuAKY0G92CHnwC/yRCvE30WPIlabqCNZCoi7xSOcnRCOiHh2q4
         vGOH3R/Oy0VfXuV1RFUuBQLMhGDgCi8TJUvCH/3mLwHw8GPrgkP3MSKiUON4NyAOLHBw
         EQ6A==
X-Forwarded-Encrypted: i=1; AHgh+RosGvek/jtbGW6e9HYAcgQpARf40qRNuemyZ3C43am7RHBL59NjoeEAXdzL6gQ4nbCUaEOY3lnjfg==@kvack.org
X-Gm-Message-State: AOJu0YwIbPkhb8afYZkUXHoyIgoWYZWX1F6tf41RZYx+A1OxsUdsTvks
	vFX7vinXHGbYSSLiD2z6mUjUCD0j1NVYVNYLVrmS/WdKxHwJBzJZ6d+/ZsWMfV0Jg1DxER2HtUa
	XtCgL85p9ijHs5ugOQ5OHN6cOrqtovZ40tWD4hZdV62110ytS4PIwJ9ToUoL+
X-Gm-Gg: AR+sD13bF4J5EkjyKD5PHBGj9viWXS29Z2HcS7zG6aK2dathinllohi+dU5hI3njgX1
	WhNYD/BlMx7NBrZiLwRA+7/nnkKEqyjYC03kJLOnsLrDfFsbDprRItuaCEJRYyfw8scgZUT6maA
	Y0V+m1dD+stADnwYFLDXkWTobGusNQYBmYdQh019oUnwS5kegrS9xAUT5pA/luFc8+/wI/0AaW7
	e+PGFtAUpQxgxm8hWbfUpO3EWnLarLPC0efETHkQJPu/Ay4Sk/yTVW7Q3q434EFXkZ8PbcpAAZM
	dgAX8EvL/UMdsUXGbaG/hkgYze//vltXbn4RCVXL+utNP1VpbyzPkUHA8Sc/eXzdihJ/6vLdavf
	ptFAail7xPN/3xaVsLnKNGn8T+KcJ53gkyIf4/yM=
X-Received: by 2002:a05:600c:1f8c:b0:493:f5bf:4dc6 with SMTP id 5b1f17b1804b1-4994e7a820dmr189774205e9.7.1786027991497;
        Thu, 06 Aug 2026 07:53:11 -0700 (PDT)
X-Received: by 2002:a05:600c:1f8c:b0:493:f5bf:4dc6 with SMTP id 5b1f17b1804b1-4994e7a820dmr189773475e9.7.1786027990960;
        Thu, 06 Aug 2026 07:53:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e4b1904sm142424745e9.0.2026.08.06.07.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 07:53:10 -0700 (PDT)
Message-ID: <363d24da-7324-4ea6-addc-453ef468f1bb@redhat.com>
Date: Thu, 6 Aug 2026 16:53:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org> <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4E23JPYjChCnaCNs2uiojKg7FppD7jlY5wu6CfCo0SQ_1786027991
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88B901A0004
X-Stat-Signature: 8bukehtg4tstwkfxbw7883h3t9i3wfkc
X-Rspam-User: 
X-HE-Tag: 1786027994-217150
X-HE-Meta: U2FsdGVkX19k7EXYpLQjBUWf3Af7wx5ctdKrDpe1a1vY7GYikOp+Vb2znyeQ3ynHXheL9L7yuQNPWU52KNEj6fvMcqU/MXy8Sxl+As9UhPRUABA8vAH//yFg9lW1uAu17AxHXCNgREGu1ECfdowIg9MMrBKXZfSQIXIYlX2Ln2nrxGSIdAOEUwyhaOAYq81HtMHvjMaxnnP4kkzE5o6EPVmplzrVuKl67QtJYeraz4HLFBhmZVHUTiyVYjzJeikJ228kAFxhOmNl45OKgrGnw/2jRTY7KSNEHlehDWBAvS+V9Q7SJ68J8V3Ob1O5e6KOj9wVrph9GhS0at9e7PBtFB2rOUjFmQHAxfnw3DX6HkWI6YpYGVdUXGT6SwMxzzbxn9zaUXRbiCCp7jGiYfAfFZsS935ru39tHFzA71nHymVczEz7yA5/Fi8Gd07EvKAefZJtCYcQIevQq8tdQkVbMYmf636diyCBiZ7MQ9gMkibDFN7MBFEUsRTvn4q7qxhMw2Q4ffuCdWZnfIYEiomSxKqQV9YvF+0/hmq9zNH/g2EI54vA2XKu1CN7jCs8N6cd6KH7505K1TTrjT6I7aYlTdUE5WkU+X6xYZG401Yfk6fIujqxbMVwcWqsb2XoW260vFulrGpV1Ge0tkwPk7ow4tspyl7o+kx0SUoJ/CB03bttxDVcMrIki4R8Lmp1C+KRq+DskZ6XxwrAcskvO7LR9GbB3yON3X6nD0N+56vDX6+5nEL+dbDnj0iTwPSe+PJ5jGFaL7vOMHkuh5DzF+UJhQ7UCyiqXgtplpupZ++atA9KNRkhWG7HICm65F778pysoX3uRZuBCcJg7t2Tv4kuBWI/eLC5IIVZHhHJwIl0qdLY46qKWeB2aqEZ6wAjNr7FJHd3itpOUadAv4kuSUP95HXhAXlfvWrep1/JD4lp0aJE5qqAlPEmoMCzNoUYRSE8Y44+jYR3ebc2Mv6GKZ3
 5f0yC22y
 hCKi0Qs9orXaNnHUIKPeXqL1GeIvO9mtoTDLCYm8vo2vomG9bIdbEMSqPJct3aVU6/bLgxm9jgW76qLLM4TaWm2m9v8UGy7ptTACYnB1SUgXauNj4qQgXrANCUhwiTcb9nseXKuGRf2bnt5Er2V+mhJtWtPhQWqKvbh/8k6vX0bzV5L5smAynu8Gi/EzG7iaMRWCvt3KKIo+RzO+mXp8uOgK1tSyeqDM+YwH7sERK27alD0Q1Q2CDdXPSpQCkqyngbvN35dUsj1hapE+H2V0jDZbolkvJAtmF0SrjisrYd9dRHcAgA9FDnGruMzfgBXvz/RqJwgR9eJi3ZSMIHOxk4A0PfAESr4SqqGXOx1LGoozCo2+QoKH04KPffaCryZv7tFoqcL47NDYELhGYtkyZGNseQzMRGFPOIgUVk+sDf1n5NbllpLtjjiw6jhBCNF988MWQgvplWh0YLUVJUqnN7qz7pa84e38RrWXE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 16:47, David Hildenbrand (Arm) wrote:
> On 8/6/26 16:42, Cédric Le Goater wrote:
>> On 8/6/26 16:28, Lorenzo Stoakes (ARM) wrote:
>>> On Thu, Aug 06, 2026 at 04:26:20PM +0200, David Hildenbrand (Arm) wrote:
>>>>
>>>> emdash in a code comment?
>>
>> There are quite a few of these in the code in fact.
>>
>>>> Then I spot
>>>>
>>>>      Assisted-by: Claude:claude-opus-4
>>>>
>>>> and really have to shake my head.
>>
>> It's a one liner. Good enough to raise the discussion no ?
> 
> Just to be clear: Unchecked AI slop in any form is making my life worse every day.
> 

Point taken. This is not the case here. There is quite a lot of work
behind this from several people on the analysis. Lorenzo is taking over
to address it cleanly.

Thanks,

C.


