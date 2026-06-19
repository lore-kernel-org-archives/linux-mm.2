Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3E3CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 20:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8796B0088; Fri, 19 Jun 2026 16:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C599B6B008A; Fri, 19 Jun 2026 16:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48C36B008C; Fri, 19 Jun 2026 16:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB266B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:31:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E663F1A0569
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:31:15 +0000 (UTC)
X-FDA: 84897806910.29.D58D6A0
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E187180003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:31:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aMQRh5RY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Cuz3goNt;
	spf=pass (imf16.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781901073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BuBwEE2haUohTkvyqi25m3okwfP48tWf/B574SDKJzw=;
	b=yM+aW19lIZKOyG225x50+sz5j56uKbbxnbHLBFOrbkspVP71ncgpecZS75ZNqDEFZiCiPm
	ranGibq+DIvqG3ler0h8XombhSbnMww18f4oL91tGMYl8GBja0bI30M4CXF8xflqRCNnyJ
	R19Wu/BUaoUQi1kJZ7AEnwk98rYnnNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781901073;
	b=kHKkUepIni5CufzlgdXWf0a+ajo8I9EWN9qeLKNeplEzbvBN4dAeZ3i0q4X1e9+t2XW8Kv
	1fTXcGqeDHLz1mGAr71YSXgMKLFZCDEctwcckaQ5LtazkN7rhq/mfE8szu8mf8J06HfW+M
	aapOCRFxM87K3wkeqJiHyR5J/zJJbCg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aMQRh5RY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Cuz3goNt;
	spf=pass (imf16.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65JHSZTH2417933
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BuBwEE2haUohTkvyqi25m3okwfP48tWf/B574SDKJzw=; b=aMQRh5RY+1m4PvyS
	+IZSwd27GAnobChJ98i6dlDOiIG4L0QruKgn3vCYXgo+yfeRvtnebQU4vFMnJLTy
	xShboJ7EKrZ8ooK6ljldp1rRsVACmFLU7vDzFITVrizvBnk4rgYrg8B3yh8QkO7h
	nF/LmyNOFV3gavmUwQCTN3uN0Ag2r+3gM2/JzCv+duxmGfP3kzT4GMe0Yey0CCto
	mRzuhNDN/u+qvPssX83+pKIVYZ3BthKvKMDw3IKYSgYsN53xUNZXrst2gY+nZRQ3
	M0W6EuU08dDy2FTUhO9faCg7Kqj7/WcEI4Zk08JlieVKP0wl2ps519aOWNk/301S
	m999+w==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ew5qs9pdw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:31:11 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c8620ee0971so2492255a12.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781901071; x=1782505871; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BuBwEE2haUohTkvyqi25m3okwfP48tWf/B574SDKJzw=;
        b=Cuz3goNtuHrT9Zj4EQAjZGNAEdsA1pxEQDW+Ihaabddx7LLnHpXixLl0Jmb+E3CBOU
         QgDYbXWBpQgmd0yOq9cVokVJHybCllrChp0pjRl6NcajWBpW0BA7ngfSSOv0cNhU28mt
         MErXeVPsJF5ANdTMTFMjfBGoQK+nyHxMCm1NGLW4O6I/YRcx7PqNt+zn9w9vjFNKz76z
         LjfDF6b0Uf+3Dv/vcWD+Is21v9kERSicC3iGd4H5GhcP1ealagnG/qrmNfKXJv9VlJlX
         SYoyIKE4Ez9wPFgL+i5cXOzRSp1waxdPe3Ajth0tX9I2u41C9T8DcDLW0dpoKe9L6Y1i
         vOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781901071; x=1782505871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BuBwEE2haUohTkvyqi25m3okwfP48tWf/B574SDKJzw=;
        b=aV3+7CyzpzuLbj3pFWVVL+bY55WOFcN2yY/GWTDNQWvhmMoWK8puMRo8w5OqiyGNG0
         Ozz6N9nQYqYnwOGanUzZrH+rY86MiQ6qjHNRx3lmuR7RSqVWe8dOIAXmtPjhMSMgUFbu
         R2GUsY6d8JabTiiqWiciQtx1meQ+ZsukoVCoIxnwdtMkJGcm1EASoGKJhP6UGHqKcgnx
         QU1C1JMTlX0jrLIt3Miegs4h5RaqB0hXs045nsKxrPMuh2nv0O1JL+Tc4suX8qDbEiLw
         Lh0N78OAgUqUquoXK6mqZbUicumqX3YzItMv9cj9gxCWrnL1wyhTLHpGdukdJY45K4xn
         lYDg==
X-Forwarded-Encrypted: i=1; AFNElJ8teJXAa+Imwgl2RZQpT++qVEkMC+lRGBX1HLFOFPcWgCNqsTZoR0at17MzUyDG8oE/odlip8qdMA==@kvack.org
X-Gm-Message-State: AOJu0Yx5R+SpERqzmCONT2hlMf9SpZfp6bc8UWTEKXH8pPplw5F8RAtk
	uxe/y7f5P7y7v2CuEm1lt/TXaAsf//ZVS/YDDnhA5wmjQg2XnCMltHVew59hcDX+7jnjfc2h7qW
	nPCmjrQ9wA25NYDZ+3gpDSCJc+G2FVGNgyoWF2iX9hXcY393wjvo9IQ==
X-Gm-Gg: AfdE7ckLbs1tY093XGhsqJ1KIqsHqaIyRcvyL8Wjx28/SVPHsnoMNNC47xxqWvdttig
	4oo4EqMjdle5eaQbinKT5H87Xkqi6xqWNQLGCWnl0i9Obe1NydM8KlMcpwUeHPNAUM1XDxSk64A
	8K5vyV4ZSdZ1W/jSS5Sd83oouAMdeoYzEbFHZOY2LdbjvQy8PTMcpmV8UI9m4JTFWu9SLIWoSqb
	i97nkAByqiKqr0fuS5GcvMlxWLcKPkYjDWnlJC2fOL5eWqlIMAYzjGIkiibZmtipNs8ku5FEkx1
	ckSDB6+p7x0MeSfStDeKAf81q8Fn+M4ioxbWXxHpiI4eOfC9z76qsTKo/VcdkIrQ+sZlNQeXH3j
	EvSHCg1QeRA4VduHvvN4AWqF4TarmjwTEarW4w4DDqw==
X-Received: by 2002:a05:6a00:cc3:b0:82f:5051:f024 with SMTP id d2e1a72fcca58-84550866614mr5411693b3a.27.1781901070661;
        Fri, 19 Jun 2026 13:31:10 -0700 (PDT)
X-Received: by 2002:a05:6a00:cc3:b0:82f:5051:f024 with SMTP id d2e1a72fcca58-84550866614mr5411649b3a.27.1781901069994;
        Fri, 19 Jun 2026 13:31:09 -0700 (PDT)
Received: from [192.168.0.8] ([49.205.250.131])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564d6c49fsm104395b3a.11.2026.06.19.13.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2026 13:31:09 -0700 (PDT)
Message-ID: <6982a194-fdc3-4cfe-a60f-1c73a083e7e0@oss.qualcomm.com>
Date: Sat, 20 Jun 2026 02:01:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
To: Luiz Capitulino <luizcap@redhat.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
 <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
 <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
Content-Language: en-US
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
In-Reply-To: <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDE5NSBTYWx0ZWRfXx4O/7L7dOm2S
 ZL3GfySQ+mK+vfTGPmUqzNFzUNYW154DhBQiHp7+Z4yXD08PckljvPi0PuQjbELSO8HZmeM0YB8
 +vX9sSs+/dsZb0xSlg6QGm6+2uGgF5/9nhCSsgED/KE2pYnwurnU26dSZDm5DWqHxWzVJFXdBJ5
 qwT8Bvcz3tqTqj03dvcqO34W/9gSICQAxghaGa9XDMdRu8dWp4oAyMSpL3mqevV3/aUvV9gvQ75
 GeT5mIFwGA/Imz1KRFuVaA6TkYALxuNHx/2iJbIOuISx3GOfidZ0YhJ1O7Ripnoh/z97eN+/yu0
 Po7QEeZHSp2vgph71bs2aPp94SbMQ0e4FfRxIQrzQHInHlkUwobBeOhKxaD0/SivY/lSpo6Zpbj
 Z6jzrY0Fqclw/Zy1AeabRpyWpyG7zvMJ2Q8GgQ6jITayc+frfoIPgLkb9J6bT/FIy3JlcDs7Yg4
 5CE70kSfTyaPs3QQtcw==
X-Authority-Analysis: v=2.4 cv=M9R97Sws c=1 sm=1 tr=0 ts=6a35a70f cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=BL6/p84Y3ifFzq3ZkNxHwA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=9QaySs2r4CrtnCsAm2sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: ZchQ1MeSr15c4JzrH2jY35ZQ3dQBfdAS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDE5NSBTYWx0ZWRfXyy1aUwGsM2C+
 /a9ijRqAC6cOmGDtNqm16afJauuuTvOsfI5/KBSo93jemcoJkRRB77sL5uLegS1Rg8+yx3jmxif
 kARflKvy6NCJX7AZmCW0gwnFWapeQE8=
X-Proofpoint-GUID: ZchQ1MeSr15c4JzrH2jY35ZQ3dQBfdAS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_04,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606190195
X-Rspamd-Queue-Id: 1E187180003
X-Stat-Signature: 1fhge9c874iryfnfuj7fjfk14mdhz9we
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781901072-512928
X-HE-Meta: U2FsdGVkX1+uw4STlHi3Q2VSzxcFvNlX9qXNHwKLvUANbcRqz3De/i63pJSD1/wd70Eby+6kVHLch1ZdcEpTPY8magtxJWUYGREHQ76YLJL7d4fsqF1Q/5lx7waGqwsdbmwfYc73rBTexZSWpJOFsE5gZzgYsohrlK8LE13ee9uMP8+uPhZA1MMt4yzPNtfQW22VeKMIqlVTLfNhsFE9oxJ0JGzRL2kl4hUuk3faj0mskiu3aTHr5UMKEJqeu5eSLTYW53uPrRPns5SJnmSk5dwbomoGYV+lgCQ8Iv5Z2PQ9JY5At8HilARtYw2HNu8Jtn8WsQ9zh+AaMEvBw3t2PqFtVhIpsV/FphruCQxbPSQ8hcCVHVixz+W0tCjSZZe+5Ee/dHyKrqmwuoVCxajVK+MXG2Z7Gc4O0SCwO/cCT68cp6mAB3+0XmTxfMvMMGgd46FCXSMFBZU5D5pW5fsEbb/U5LMgQdHbrDhW/6Vbr5hYMc9rOck2hQlVn8c/vB1W6UjfvDUiwgMLtLwANw6ctGlwu9rU5mYC1eT1qfuOK6kjuHBc/939ncuGJXl5tb9tuSUD1K6qiQdZjcII+5UGzsX89wG+XAITm6oHe1BWvxbhqAJ/i7SVsRPfqKqAXSFxlTWOBg1jEQ8Y0rwXS7mbuPEV7t5HtwvUfjoa0o1aBx1/cCncmsPwwDk9opa81vesfGfY6Z7Qxl0H3QSf3U6XlbsySe8GTvvpv6mXfXQzPD89Fb7Aso1Y4VI9H0crPbtXat3N7hQSHh95S+KJ0TQihRsfhTpI8dLx/HPU5sO06mqpD8Pc5nJyuA4HbP7XA/pi+NEvPrZ+LONXjieeM/yjwuoZVWCImDHCayzpUxkzB4FkQv/yrrr1yE5qw529WE2X1wDorPC4xNRRWQjRyb4iU7nuh+U8ubHCXNszYyR3fp01I2/NXe+jXw+MrEwxPzCjoqDHbn6yL+wAzNo6qwE
 hU4e0kQK
 nWfQu/VmqmsNlzD28Fx1gPQGnZOjLaQr9nMWbfa+LnHmBfZ4EZo4CAtlD/tuDVJ7OzPjsp/hChYmhDH9wehlv1qgihWRtVy0wdbVqNeVFWnxseN6N0HYwc6+/m9br3ncMkHlEfBW4fssMSxjIrKPv5z6o1vWhZ89CGICGnYZ/jBZj6Snd+grbdXKI582R3vMRqI/uhJecwSKK9D5b4DmLqtvHITKJbY3P3prrdKoJWQ6LIkSbxNy1zxIgKXsJbME4erNIdESxS53V+hBDzBlhm7+G+Iyqlj7yE/ns5PNveJs3EP73oRxUJAzLgO7wDyHD+8OtxQ/tJeVjsKBvt1SPcKm0lwIWvFRdpH/GVsveinNP3qUzwF6CebmcSmKiqiYxv+WridzGUObU+/iKXgwEOLzD7uGTGtQ7kGj9ANiCe2yKo9VaH12ZD6DmHbXjj3F4INQHzTOrOlv6uVAyIEQLdc1MB6UU1CzIgp9QCrW6qm14yHN1vLb0MDjcjyyQzzH7CUSzyqLcINdQ7XYdNovs9GNVXvSxJT0EDtHGjN/XjXSiXMVDtIYv7lIQ9D6gkonxqLMw22SMZMKcL/e4AuZ9UlfJw9GWRePO6e8AFnISN9Bq1BkT6251Ba0VdOl4BZn8LVKWcLvTc9rRHLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/19/2026 8:08 AM, Luiz Capitulino wrote:
> On 2026-06-18 05:04, David Hildenbrand (Arm) wrote:
>> On 6/17/26 17:09, Ketan wrote:
>>> The page_ext iteration API do not validate if the PFN still
>>> belongs to a valid section while advancing the iterator.
>>>
>>> When dynamically adding memory in hotplug path, it can lead
>>> to a NULL pointer dereference during page_ext_lookup at the
>>> boundary of the last valid section.
>>>
>>> [   14.555124][  T846] Call trace:
>>> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
>>> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
>>> [   14.555129][  T846]   +0x11c/0x260
>>> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
>>> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
>>> [   14.571206][  T846]  generic_online_page+0x14/0x24
>>> [   14.597782][  T846]  online_pages+0x178/0x30c
>>> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
>>> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
>>> [   14.597789][  T846]  device_online+0x88/0xb0
>>> [   14.597791][  T846]  online_memory_block+0x30/0x40
>>> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
>>> [   14.597794][  T846]  add_memory_resource+0x280/0x298
>>> [   14.656161][  T846]  add_memory+0x60/0x98
>>
>> So, we do allocate the page_ext in memory_notify(MEM_GOING_ONLINE) -> ...
>> page_ext_callback() -> online_page_ext().
>>
>> Which makes sure that all page_ext is actually allocated (for the full 
>> section).
>>
>> So when we later end up in generic_online_page(), the page_ext should 
>> be there
>> and the memory section should be valid.
>>
>>
>> How can online_pages(), which onlines memory part of present memory 
>> sections,
>> online (free) memory that suddenly does not belong to a present memory 
>> section?
>>
>> Something doesn't make sense here.
> 
> Ketan, would you please share the full OOPs message and maybe tell us
> how you reproduce this issue?
> 

Sure Luiz, below is the full OOPs with the call stack.
In one of our usecases, we try to add all the movable zone memory 
available to kernel after boot.
At the boundary of last section being added, the iterator 
for_each_page_ext (which in turn calls lookup_page_ext)
inside which the below fetched section is NULL for invalid pfn.
"struct mem_section *section = __pfn_to_section(pfn);
struct page_ext *page_ext = READ_ONCE(section->page_ext);" -> While 
accessing section for invalid PFN
we get the below NULL pointer dereference.

[   13.840511][  T846] Unable to handle kernel NULL pointer dereference 
at virtual address 0000000000000010
[   13.850253][  T846] Mem abort info:
[   13.853859][  T846]   ESR = 0x0000000096000005
[   13.858441][  T846]   EC = 0x25: DABT (current EL), IL = 32 bits
[   13.864642][  T846]   SET = 0, FnV = 0
[   13.868510][  T846]   EA = 0, S1PTW = 0
[   13.872472][  T846]   FSC = 0x05: level 1 translation fault
[   13.878224][  T846] Data abort info:
[   13.881914][  T846]   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
[   13.888283][  T846]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[   13.894211][  T846]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   13.900398][  T846] user pgtable: 4k pages, 39-bit VAs, 
pgdp=000000089ff23000
[   13.907749][  T846] [0000000000000010] pgd=0000000000000000, 
p4d=0000000000000000, pud=0000000000000000
[   13.917687][  T846] Internal error: Oops: 0000000096000005 [#1]  SMP
[   13.924220][  T846] Dumping ftrace buffer:
[   13.928436][  T846]    (ftrace buffer empty)
[   14.452210][  T846] CPU: 7 UID: 0 PID: 846 Comm: modprobe Tainted: G 
           OE       6.18.21-android17-4-maybe-dirty-debug #1 PREEMPT 
  df0e65d5b71bf0ce6ff80187ad4d31404755da65
[   14.468528][  T846] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[   14.484959][  T846] pstate: 43400005 (nZcv daif +PAN -UAO +TCO +DIT 
-SSBS BTYPE=--)
[   14.492820][  T846] pc : lookup_page_ext+0x6c/0x108
[   14.497840][  T846] lr : page_ext_lookup+0x30/0x3c
[   14.502766][  T846] sp : ffffffc08d21b250
[   14.506887][  T846] x29: ffffffc08d21b250 x28: ffffffe2e901f080 x27: 
ffffffe2e9920000
[   14.514927][  T846] x26: 0000000000000400 x25: ffffff882701a380 x24: 
ffffffe2e8f28000
[   14.522972][  T846] x23: 0000000030000000 x22: 0000000000c00000 x21: 
eaf5b162e68bf47c
[   14.531008][  T846] x20: 0000000000000000 x19: 0000000000c00000 x18: 
ffffffe2e8e4c380
[   14.539045][  T846] x17: 00000000c006287d x16: 00000000c006287d x15: 
0000000073cc3b9a
[   14.539047][  T846] x14: 000000007c6d34b7 x13: 00000000d0fa10f2 x12: 
ffffff882701b128
[   14.539048][  T846] x11: ffffffe2e93630a8 x10: 0000000000000011 x9 : 
0000000000000003
[   14.539050][  T846] x8 : 0000000000000000 x7 : 0000000000000000 x6 : 
ffffffe2e68b78e4
[   14.539051][  T846] x5 : 0000000000000000
[   14.555122][  T846]  x4 : 0000000000000000 x3 : 0000000000000002
[   14.555123][  T846] x2 : 0000000000000000 x1 : ffffffe2e7f30cab x0 : 
fffffffeee000000
[   14.555124][  T846] Call trace:
[   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
[   14.555127][  T846]  page_ext_lookup+0x30/0x3c
[   14.555129][  T846]  __reset_page_owner+0x11c/0x260
[   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
[   14.571204][  T846]  __free_pages_core+0x78/0xf0
[   14.571206][  T846]  generic_online_page+0x14/0x24
[   14.597782][  T846]  online_pages+0x178/0x30c
[   14.597784][  T846]  memory_block_change_state+0x284/0x32c
[   14.597787][  T846]  memory_subsys_online+0x4c/0x64
[   14.597789][  T846]  device_online+0x88/0xb0
[   14.597791][  T846]  online_memory_block+0x30/0x40
[   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
[   14.597794][  T846]  add_memory_resource+0x280/0x298
[   14.656161][  T846]  add_memory+0x60/0x98

As David already pointed out over this thread,
"for_each_page_ext() does a "__page_ext = page_ext_iter_next(&__iter)" 
and the end."
page_ext_iter_next tries to access the page_ext for an invalid pfn at 
the end.

Thanks & Regards,
Ketan

>>
>>>
>>> Add a valid-section check before looking up the next page_ext
>>> so the iterator stops cleanly at section boundaries.
>>>
>>> Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
>>
>> If the problem is real, we'd want to CC stable.
>>
>>> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
>>> ---
>>>   mm/page_ext.c | 12 ++++++++++++
>>>   1 file changed, 12 insertions(+)
>>>
>>> diff --git a/mm/page_ext.c b/mm/page_ext.c
>>> index e2e92bd27ebd..74067ea740fe 100644
>>> --- a/mm/page_ext.c
>>> +++ b/mm/page_ext.c
>>> @@ -253,6 +253,18 @@ static struct page_ext *lookup_page_ext(const 
>>> struct page *page)
>>>   {
>>>       unsigned long pfn = page_to_pfn(page);
>>>       struct mem_section *section = __pfn_to_section(pfn);
>>> +
>>> +    /*
>>> +     * section can be NULL when the page_ext iterator's for-loop 
>>> increment
>>> +     * computes a PFN one step beyond the last registered section. This
>>> +     * occurs because pfn_to_page() uses __nr_to_section() which 
>>> succeeds
>>> +     * for unregistered sections that share a root array with 
>>> registered
>>> +     * sections,while __pfn_to_section() returns NULL for them.
>>> +     *
>>> +     */
>>> +    if (!section)
>>> +        return NULL;
>>> +
>>>       struct page_ext *page_ext = READ_ONCE(section->page_ext);
>>
>> In addition to what Zi says, which will end up as:
>>
>>     if (!section)
>>         return NULL;
>>     page_ext = READ_ONCE(section->page_ext);
>>
>>
>> drop that comment, not required. And likely best to just add a 
>> unlikely(),
>> because this doesn't usually happen.
>>
> 


