Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D34C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 03:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A335C6B008A; Tue, 22 Jul 2025 23:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4106B0093; Tue, 22 Jul 2025 23:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA466B0095; Tue, 22 Jul 2025 23:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8064D6B008A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:50:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01E201A0588
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:50:55 +0000 (UTC)
X-FDA: 83694153312.30.9666818
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 60F4A1A000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:50:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z0qBjRGc;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753242654; a=rsa-sha256;
	cv=none;
	b=rc0Sqta73uhQ++IDfhxJLhF1B0pQhUz7d3ELwKa2qwidS7vcqbLpnH28wtaDL5s/hf1nUU
	hVN7Lf4GLIMCdbreJ2KsIyzFx9zwieFgHf3nsKTR/3wuaU6h4CMNi3fCR6rQ9SZ+9QJfgS
	cqqRRdO78RFuKQQbSdwXIDS0KrXaZ+A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z0qBjRGc;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753242654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+/Pfkit5PFVN0tLEWVs8x9+kRNuxE006f52H9Fa07w=;
	b=izCUGjk8k08jQyxxNcoDbvnIiw/tBNfH7F1mHTeBRP4Qa6/aqjsplUwGYGqVi2yrDjgHMi
	E3q+Ad/t7VtYknQj6FrHV6Ldiz6HqE0AinWECnnsyygnjSpVVfTJw5cm8oz1ukduu6Q1/z
	NZ1+YXH3ihnNimYJ9NCR+IEmV6926V0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-234b440afa7so57886995ad.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753242651; x=1753847451; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+/Pfkit5PFVN0tLEWVs8x9+kRNuxE006f52H9Fa07w=;
        b=Z0qBjRGc5MalpXiLW+6P9IA/VO8yw5fftHwcrOulXWC1VkuoLHtCRqrhH1sgrBchhk
         OZtHBxmB9Jjfy9oiyduHPSs1VeuEnvm9huYVPdQwlzPCPWkXmmYLAxc/XQJVq6fC5gRU
         qQSwewSUh7PJGevYw6fHLHCmOcofblDCVJ76NO4sGIQfEyXTmqQJ/78EQn70ga1e9oj7
         XqpijJNc5Hm1p5vugwMnirAmtLiplnwZFzh3RlQ4Ll/7EomLjjgpxNEsZE9Qu1kbjDPV
         6epU51/Etzo5ah3f9FyH9Xj4ukG2UrTrRNZJE/C8ELKm1XyRMjcWBvrpjbzLqMMoIA9j
         hB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753242651; x=1753847451;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t+/Pfkit5PFVN0tLEWVs8x9+kRNuxE006f52H9Fa07w=;
        b=pw4+uSR7dkPPvASKc23YKqmkaTVfWh7b8ouZiM1BlfIiUFo9bLo9ktNOPXOojpx8nJ
         bLFR0IuRLWC3OSNGE4uRtwdaYwiVsyqhhTsPoUZWoYXO/tsVNF2LR2Epcp2bqWNJ6Ggd
         0seDkGltyGwi0dXZpGR97IWm3mgAJ719Ion5iJN1g4VmsCWNoszLQoRTwl8mYTpBF9wb
         T57Lz+vJ2xoIgLojzh0rxRMXBNjxavNFs9rWJ+r7Svd/JOKmRCUo2r+3V9IoWxFgaOBH
         5dy0ZcSBtNQIJctQUDF0ujhdsJ+o7kwQreKDTsNHZRWRBCQPlJ941dlnpXi9btutlo0z
         l4KQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrTtMPgquofsorjlygL/OcHESza4+L5rtJar0/Wixvq3N0kYCJwMhZXHu2pnPq1yUBP8j5F8vynA==@kvack.org
X-Gm-Message-State: AOJu0Yzj7+91rb8GjXdGeISfh/uIn0dxnesaWn6UPyjZKy1RusjEwoDI
	Os2TZKOYJ4/OwsRzW1QJphU2KkxI3474Pq80eJGqOEiznXYVa6PzPwwYnuRcS7ddi9Y=
X-Gm-Gg: ASbGncspwZVtWwbCoaO2yMh+xZKdQH0ujXmGijQoYcztXIJUDIC5eYlBkM2v2ODgUL8
	TozZf/wscZNMkzAyAPN6FBL+dFoEOA4TEGs8Se/0nPJjyrNvWzz5rZBYGFo4hLhuV/lxsNvb9WF
	NrVw+YnOKrbSJtXwLlNOwpjYILaUQNnrBBkWbeyn5qiM/6n4c0Ih11tmYyvjqVST5J6NU7O9ZkP
	QGMRIdgVMfmla+spNuSCvEnspok6zPyAJH/HpFhLWNrDDeDAHBhQzOsRMMdWbG7YSy+PgiUXRST
	tymGRv1Hfj3N6HoRzdca2nbHzKjbKpxTUdraGjfe2AyI6AFmie83+Z6VHHGanBvUFzbEHOXO/9Z
	bFXHpl1aOD/wpUG+9r5A0zHpIIKW3VqAbKq7QRCIMgUFfE1iKLg==
X-Google-Smtp-Source: AGHT+IGG5xeTiPp46N1+ubIJYLYiw4X+bPRHHusEDQs77QPZ7xG+Gmpi3gyEPNcDXHORzHZYckNp5A==
X-Received: by 2002:a17:903:f84:b0:234:c5c1:9b84 with SMTP id d9443c01a7336-23f981b4011mr19536245ad.37.1753242651119;
        Tue, 22 Jul 2025 20:50:51 -0700 (PDT)
Received: from [10.254.226.168] ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b70868csm86297515ad.229.2025.07.22.20.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 20:50:50 -0700 (PDT)
Message-ID: <6a292069-708e-4f6b-8b0e-95398a9f729c@bytedance.com>
Date: Wed, 23 Jul 2025 11:50:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing mm_slot.h file THP section
To: Nico Pache <npache@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
 <CAA1CXcBY4rFLkNqJM2Dj-EajPw9TMTHNcYapw9P=U0bo=QNqkw@mail.gmail.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <CAA1CXcBY4rFLkNqJM2Dj-EajPw9TMTHNcYapw9P=U0bo=QNqkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ksww8s5wnmninz6mma7iqcfy99y3obgu
X-Rspam-User: 
X-Rspamd-Queue-Id: 60F4A1A000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1753242652-672723
X-HE-Meta: U2FsdGVkX1+o8QN6EdetCj42TT15+FpCiKAzYckrnbtwefziUZOFDop17DICo7anxlHkKlsQgPQ/EAHHRcI7JWtgdtzua4imlgmQdQ8Y6hT3fU/A01iNTyJsVYYGFUmftSso0GjUVF2uM1IXFsf6RTH3tDBZvrtkkzD4fkARuklvhycDgWXYXyhpqsgAJPBBSNLOC8y9dKnloNVbEPF+xGRNTvad366wzUl39CoNus5BA11xHXAH/E1oR/C4Bpt2b8Nif+ASEXQ7T/ccBE+F/wiW/lfdQnQaplSJe9lY+F+Zp0/PRcACxLMwsgFYsYINLxUP6d0Sw2QziC6BoMs1m2JVleZMh90xm6nEFPUjqeNyh7N5etDGGq3HXLfx1rMHdmKWl92ZD5Ho/XUSnrK2LzAVtJpbbb3r6FsgU9Gt0kKWhlQrMq+qpvHky6RRxq77GpHyws+qU0WOsATk8TsY8qZFSR7UfwsHy8LTu+8DIBhDriZwssQVVMS59s0/phqLrUtK3oLpBYouI4t5YRZnDDihejffKLZnFHY1NMHDBxiCThBmuLge+LOhHsYqnbRFjx/uenCAzxfSbZRpQ+FAfnpys539ffO4ejU4x/5+UY5agdBDqDBLr84snKknL/VflcYiLi8w1AGhxruYnA3d0+mk31tGNw+oKIE7MZSaUuRjtGKBon9WcyxC11szy4TVHnwvvrAUFnA73XS6WSWQKL4IjSZdsi7wFrYthIqMlaGkQk1Eg8Ll9YE0SuQ/3LvPdpy+7gWQEL1occ/lLhmjayIhT4hKfUn1SU4La2UnUExiJC9+S7MGMHVzRC204d0Pfqt14qS7H3zwO1YtlnLr1FQbR060hBRIqkR149+luPlRFqWpoCbPfEdKO+EbggobXjfop2hoRv0MWvwcMoJiGHwDUHpThguXjmAjk3bX+L9lemzm4jkO1SbU4z4apeXZZ1bCqXreQcwjGUO6nM9
 S8tpKqiZ
 N4W5uNLcsL+pMG13y4v9SfUQfuiFJ5/HDdzSsFjCOqvxoeVxoQ8EclqNj86a51rS5HDmqZvL7HSqeeALC3kKEeN+nJe4cDBXVbFgrj6BGhiuJ94wEuhXUsR/bl4wqDSjAOPeb8urBoGqlejADtIXHj9u+ztZy3t9fqgOAQaF3cviUmEAQrHxOzVB3Z22OzIlHebkuVZWuv9WsoWkZU2rdzJ38tNsGOpD9JwpVbXZ/OPSCkqqqq4ntcKBUvRCeoW39QsQksNpIAlPT5w7W4sNOCubuD9JiabISP+lB1BLboV/U918AQ//CxZXajJNm05yS8R1lZXG9dZR+m88Zgt+uxq9UJBfXUSUy6hSwAzvTEtu8JwCU/vB1F2BaMaehT6+bLWqE2vLdxI/zGyMryMKFgK2ND6Cqs2vXVI2krR7ynTDLlyPB6NMdR9xM7hDbJfzWKQVpe95LDqi+7JMVE1DCugc3jfhSk2nqdaotS9jLJQGXt4s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/23/25 1:43 AM, Nico Pache wrote:
> On Tue, Jul 22, 2025 at 11:19 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> This seems to be the most appropriate place for this file.
>>
>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> ---
>>   MAINTAINERS | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 837bc5cd6166..3f83fb317f51 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15966,6 +15966,7 @@ F:      include/linux/khugepaged.h
>>   F:     include/trace/events/huge_memory.h
>>   F:     mm/huge_memory.c
>>   F:     mm/khugepaged.c
>> +F:     mm/mm_slot.h
>>   F:     tools/testing/selftests/mm/khugepaged.c
>>   F:     tools/testing/selftests/mm/split_huge_page_test.c
>>   F:     tools/testing/selftests/mm/transhuge-stress.c
>> --
>> 2.50.1
> It might also be worth adding it to the KSM section since both of them
> utilize it.
> 

Agree, mm_slot is originally a common part extracted from THP and KSM,
and it is hoped that it can be reused by other modules in the future.

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>

Thanks.

> 


