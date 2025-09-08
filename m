Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D30CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17BB98E0009; Mon,  8 Sep 2025 03:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153848E0001; Mon,  8 Sep 2025 03:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042308E0009; Mon,  8 Sep 2025 03:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E21B18E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:50:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97EA11A0A02
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:50:26 +0000 (UTC)
X-FDA: 83865310452.04.E65B67A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4C8B9A0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:50:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/MuO7fq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZD8/wuGm9XG1Urt0ycTnYUjN1LoUePeKC3enAI6Lrk=;
	b=VJSfIklB/inmMmXv2sl7XODiLxRBu9z7eqFcTiRQfil/cmnO14vlGDCv9EyBxBCXivzOPd
	D/oSbCiOd8mqdKn/hrGD+Chh/43Y098VJOzGLtqleY2rzQsofwUamiZNMB9nHs2VBT7ylw
	eQxNij2OvzjI7Vam6Vw+cQdV1nqUunQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/MuO7fq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317824; a=rsa-sha256;
	cv=none;
	b=D16FbwZZeKfUxUwQBcjQSc1h30BPGwk2FRFqb7by/6Lj8lelKsWBVAWRPFm3WY1EQ3nAzq
	BkCHNrVyR9RoDp+6PJCcUxokclpNkLvj5z6S/c14dsyAM9LOusO9n8NWj4aHknrZb+rn7H
	yIFMoN84e9hiHneVQ2pSR+0exbxrZIM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757317823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AZD8/wuGm9XG1Urt0ycTnYUjN1LoUePeKC3enAI6Lrk=;
	b=N/MuO7fq5+fqcvShVgzoSaGMLbmCGoM6JuyzyzmjYFWDL73v9jJbVe4q5SG1GS2RRjgYJg
	fRwKDlNcSb0WhfbqcMlOw8vF544tM5+yrghoLkP3mHGuG9PHpboHlJ1khwh5rJPfTfdw+5
	G+4a0kuQ4KcZKh8eMGJS9KWCwzt89NE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-I1029eJgOkWYKmH5FyBkwQ-1; Mon, 08 Sep 2025 03:50:20 -0400
X-MC-Unique: I1029eJgOkWYKmH5FyBkwQ-1
X-Mimecast-MFC-AGG-ID: I1029eJgOkWYKmH5FyBkwQ_1757317819
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e1260394dcso2056058f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 00:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757317819; x=1757922619;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZD8/wuGm9XG1Urt0ycTnYUjN1LoUePeKC3enAI6Lrk=;
        b=FSmfND1sowS8lSTdrB4SaWwaVgqs+eFh2TIYR23r8cCJdoIvKjXCaaox/SXKq0c70X
         hS69y9zmwnMbcxnJ7Nk+ez0YYXcilJhNaFuMDw1p9UtHnCGn9UaCbJLQCHrhEStXYD27
         7TpFLVhYidooO7XkiF7fc/4hwpfLbigH1tZFfM5wZ0kv2eS6B21QkFdutaEi2BecdqfW
         Auob8+xuCSoD+b5yIb0KYoF1dWXzvLFaY9nv2kqyqS0JDZ0zzy9xoQXM0adPEQH8kbPN
         +YxmL8Y0jZAE1G0WnRNWdzevONoG7cQmzSsqF4WNn5Pmpt7f0kR7U6qa1YokTgha+2Z7
         RUUw==
X-Forwarded-Encrypted: i=1; AJvYcCVVVIefqfsaegvYR54z6TbWwXxsRfiIZAJtNXH5PgHfnrFzhxLaSoexs+q0Mgt3OJvTMVqVbsk3XA==@kvack.org
X-Gm-Message-State: AOJu0YzvevHZJ0Pzwkp/aDApzKufsS3ie2PZXcL2Yua9ynX6/7SDFI9c
	2LhDTrN8CR7XlTl0tK/QSAdJaG5guBbajYLw0tAx7GPIM4E5UkS4PQkwref9Gx18bBsodeEUOiu
	LNRdMla66wb0wDD0CXGnTKAqeT+N4oMIY+EfMOQ/WYfqUJsTkucVx
X-Gm-Gg: ASbGnct7wKhZzWTxyOBxkGJ7iyXJbQbaExF/bgABRh8Qb5NcXKJSqZq1MHNM1MnUHmD
	+/qMUHT6crM6ko+e6yvjrYYrHvWJyzQbW1bf8e3GCviygLT+03eiKJQzw8Z8xG1LU+MpFQgaYga
	F1E6zQGkQcaGV6vswncEv8VF8jzkDhEX+h6Zygr7ciGcJGR5o/05YFozitR1SnE2xrbrIftWjhx
	pPbNQkeAk7O9urFwq5S7n+OFwYN7ShwbZ1+4yVBn8WvgURoNJMU/UJVpdMWFAFYrb+4ZqNcA/Jt
	znnrZtFnKm2KzQSq7wVtpayvIp4IFw0NXSnkakkRSBNKxXA5YZMOCcCPwbBFkL6eexS2e54=
X-Received: by 2002:a05:6000:25c8:b0:3c0:7e30:a95f with SMTP id ffacd0b85a97d-3e64d03f69amr4884801f8f.60.1757317819249;
        Mon, 08 Sep 2025 00:50:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJJpf0hLvyMnC/1apTkfYuZCGUqk5imgApBnQGbsy42kyqnWMrWKf5Iu1ENNCtg3bijRxiVA==
X-Received: by 2002:a05:6000:25c8:b0:3c0:7e30:a95f with SMTP id ffacd0b85a97d-3e64d03f69amr4884787f8f.60.1757317818834;
        Mon, 08 Sep 2025 00:50:18 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ae98.dip0.t-ipconnect.de. [87.161.174.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8ab14esm466857795e9.21.2025.09.08.00.50.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 00:50:18 -0700 (PDT)
Message-ID: <e5c51313-c16d-4aff-a858-7a5fdc91a9ab@redhat.com>
Date: Mon, 8 Sep 2025 09:50:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: prevent the risk of division by 0
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, rakie.kim@sk.com,
 byungchul@sk.com, apopple@nvidia.com, linux-mm@kvack.org
References: <20250907235332.931050-1-joshua.hahnjy@gmail.com>
 <87ldmpwqmz.fsf@DESKTOP-5N7EMDA>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87ldmpwqmz.fsf@DESKTOP-5N7EMDA>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S6iYU42p9Pcjo399er540yS14jEI6kFO2vuGuAE7Z2U_1757317819
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C8B9A0005
X-Stat-Signature: ismejbecp4s11tekbi68eg3r5ixdsah3
X-Rspam-User: 
X-HE-Tag: 1757317824-278263
X-HE-Meta: U2FsdGVkX1+x53u1W8tgUQOTSTy1qkoZn2FmCjJhAALXfm6jjDfvbskh9WnX6W8RfglIGdrvmtJ0oAiPivFvhKX13Wn5gbUGAKz1XkBxUkVYiqUA8M+3TFVa5cLHUFtXCmEPgFT2I8SmMYIemt6uWuuY/0TnpQQrpwmRx+H+RAN5g1QHtL1m2PLiIk2ptH9cUHxin/oE9Zm2Y9l8SkbCUcA1FshS5DuHqRwx7dQivdeQyEqqxSjQgeD5Uk4FGa2l1dgVEj+cDiaOMTmRRT+6l7fJ4UY92l1eokQ3ULy6y9LOgqzOTlGiSUkOvz+bmSQRLoqSyo6qJrCRLfnMeJ/QdYxUY+IGVueR40P5+gXemouMM5JpWvHz02RyMXxkLfOgeVeqNNTaqVSuxhVHWEzrN7/+zqoA+P+PBqcyFogiLjkWDbffSUhTS8KvNzylgAmidTpX9kX3JmsIZ7zorhK/ESDBdZ5iX1seaRxu8HvGRanweMSBbNb/MeeQms+68ntr37Yh7SydSwWk9c6grFXjWCYo/iIa4j1v4gdaFpGPeMPRS49PKx3fXTXVKdW6oCTSLgGHHUuKzNus7RTXaV8Cx0PQWSgjrdPNsNfcopatOID3rP/zt0DUjSC3PYX8UaKK5wY65bHYiz5z9LVwnidjpOtiUbwhCSFyE3YFm382gIlP34rAze7lzePN2GOthYx9OYdMwH6615VcGhv0pR3z25FVH9zwo4emELnEcPn9iOSBT6y1OgMYAWEu5zqe8gqfThoBxj5krC2R0cz9uaUC99q7BOjWnbyj04la4U0qr2QOeRltOuslIGeQhw1QdQid2FzQpJY8vutDlkLDjgsVRiVg3XSA9KxSFaFpQENtCJmhGHY2FCXyMIRDOjuAFx/gUUnIFGDo19yLAIwZEFhvNVVLFU8icVaIlAmlSezqYkxzl/wuv1gQKxAy1kEV0IJpuIecFr6hZkYFssL93lE
 dR+bASLV
 LyulBD83/3O29R01MjBsU2unIi3XYFrVfwpfiOryW/VOd1lCc1oPxTXMW6ETD/21Hr4K2tyByB2ENifHVDqujJRBC2c/+9Q+pvj+RNy4tupKK9w8tOltQfzkhXmPza8g+8DLcjzln7vsm1tyG/PErJ7VIpBkgoFCDf3dUIDQfhUyevIFW0SR7stUMBFvAX2FTq3Jzi6w4pl/3wzEgmFnmcQLL2iTW8TSE29KSeYDy3XtkYRFuY6huxvHOzVgQ0VTKSZ6HGj1uTRG95OauUiPFpJFYgooC4gWpIWFjXJbEjlF0kF7K1UcIwBh9jWEtBMnb/ii5UC88J9xyeoifS1uxnA0rLIhv2qkv3OPhJZTtIcByZst8/GE2tmpOMsVqY71GUhTBZqrtehIsA1SDWzDaxtLd+twIBesnR1XeEJtnxW56LflLMynFQWsrIwd8t1VvQtTseu7qVVGdRyFbKx9kVhC8hKpJChXeJGrN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 05:48, Huang, Ying wrote:
> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
>> On Sun,  7 Sep 2025 09:08:29 -0700 Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:
>>
>>> If no bits are set in the policy's node mask, then nodes will be 0.
>>> This patch adds a check if nodes == 0 before dividing.
>>
>> Hello Chelsy,
>>
>> Thank you for the patch! I will start off by saying that it probably does not
>> hurt to add a check like this. With that said, I think it's best if we clarify:
>>
>> (1) Have we seen this happen before?
>> (2) Should we add a Fixes tag?
>> (3) Do we expect to hit the nodes == 0 case, or is this just to be safe?
>> (4) If so, should we do more than just return 0 (i.e. WARN_ON?)
>>
>>  From what I can tell, I think it should not be possible for the policy to be
>> interleave, and the nodes to be null. If we look at mpol_new, there is an
>> explicit call to nodes_empty that checks if the nodes are empty, and returns
>> an error if that is the case (of course, excluding MPOL_DEFAULT, which actually
>> throws an error if the nodes are not empty).
>>
>> After all, it doesn't really make semantic sense to allow interleaving across
>> 0 nodes ; -)
>>
>> But as always, it is very possible that I am missing something that you are
>> seeing : -) Please feel free to correct me if you believe that is the case.
>>
>> With all of this said, I do agree that it's a bit scary to do a div0, even if
>> I am confident that the value shouldn't be zero. I don't have any strong
>> feelings about adding redundant checks, so I will let other mempolicy reviewers
>> chime in with thier opinions. One thing I do feel strongly though, is that if
>> we are to move forward in the patch, some explicit clarification that we
>> have/have not seen it happen before, and a WARN_ON would make sense.
> 
> IIUC, the patch is to catch the bug during kernel development.  And, if
> an exception can be generated for dividing by 0, it can be used to catch
> the bug already.  If so, IMHO, the patch appears unnecessary.

We don't want to add runtime checks for things that are supposed to be 
caught early during testing. Usually we use VM_WARN_* for sanity 
checking such things, but the div0 would also already trigger early 
during testing, no?


-- 
Cheers

David / dhildenb


