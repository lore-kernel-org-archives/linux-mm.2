Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F2CCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319FF6B0114; Fri, 26 Jun 2026 06:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1276B0116; Fri, 26 Jun 2026 06:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208396B0117; Fri, 26 Jun 2026 06:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C59676B0114
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:34:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 203DB1A03E2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:34:58 +0000 (UTC)
X-FDA: 84921705876.10.911C6B1
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B17E120007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:34:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=BROBLdNi;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dpYP+2v3;
	spf=pass (imf29.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782470095;
	b=OoiYOM3dxo76hwShgBvs39Anr5IeoL5hQVUEpZ2zpbsTi7lDVKutgY0qTYKd7b9AQQwweO
	svdrv+C774BGXnBVvix/dS/WLbmSKlYEPn6n2ISsyDu/DH3wx1sLpgBpLiWWT7UM9negJE
	8ruoBRi+LHXtmM/YWcrP77Gg5BaWVGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782470095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n28v+zrgL+6691cycJAuIiEzsIce2TWx4xB2oYyWdls=;
	b=Ii25yMuxZUmdFlhpVcAY1QXCTEDhh8XlbdWNatSJ0yzsNm+G6RM3I+PiyKAbg3EAMt9/sA
	d+gALCMDvCGCrmiHe6Bqof6NwJEAGkLEvNdX0+54aHQieIT7uUGl4QlAGb1Z5eUSKQk7DL
	fKZD0kGhxf3NS81hQSy6uUkjBRQC9n4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=BROBLdNi;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dpYP+2v3;
	spf=pass (imf29.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65QA06Hl795008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	n28v+zrgL+6691cycJAuIiEzsIce2TWx4xB2oYyWdls=; b=BROBLdNiS4D19cMs
	ZLc9IRdFDh2RxDcd1yPiiAWEB925wrxTZFRO3sOODQbiMvfrzpSrBl1EqgZHwsBa
	YrTWmTW2Dj1280YLKXhJu3v5FiXPyRrfOMm0UNiJCOxotnmdsklDQXNVz02g6xuv
	exX80+deKqNxk2BbqderGhRQerqR4fra8972xZT6n/3r/dIofrJDRpAkz2c/aMs9
	/HIkcaL5/Ph2hw707kIU+DwdgymKSKNbNqoTA4wfVnntJmTq/p76nH4HMOVl0QcP
	oapD3kEtr99gPqyZVC6ZXJTqz/FBh3zLAIhSsC0wHmER2bUr6zbdyqMD4dePNKOs
	9NyqXQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f1eeqa9sk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:34:54 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c9bd8b9c7so755932eec.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782470094; x=1783074894; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n28v+zrgL+6691cycJAuIiEzsIce2TWx4xB2oYyWdls=;
        b=dpYP+2v3abZZEuuwCZO2opXQYBYEFzsxE3B9N9bRe+MaEtf3tOHUjvrAo5ldy/ByFF
         5XvbV8Ft7VKq1Ef61abU5ysZHjU1Om6uW7H6iw72RqbsNpZRs02+syLhm7eJt0Ctcyyl
         N9cKTs0G3H62fahVeCCFbwh7bMvD+TUot3G6sWHeL3iJ2ftJulVT7J30+/N4mSTiNs2n
         /p578B7ZpQHmNzSsyWOZjJTnNySKtlXaVk495WEfU81bRPMbIgctyirDLu0EEYt0k8Ap
         gdT2aX4yRXOa4ygTjF0uu74ECcHznJ7fnPVzwnL+hagsrBXJ41TUDDkwApYQrjH3nNuT
         frcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782470094; x=1783074894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n28v+zrgL+6691cycJAuIiEzsIce2TWx4xB2oYyWdls=;
        b=Ub0bOcYTenVt2UPq94bjboWBCYkw6ksk30A5o1JPSXhbqgZf1WbOEDSxOLBpp9ja66
         NiDDRRvdbmDBQVKc5NydrNtkjtf+fWRHqx5jJKNrXgT9it+CEQVgpwNnCHodsfx6Nq+F
         cSEoL2p7WcGmpqqCX66THZgEVUrSTzSvTY21g0T7ULER2ExaXqWonL9gugwngpZuERlO
         LRecXEZcZY/kDepM4ZUumgdrcAZAG4SvB7WwonihK8K5SxWtn5yI4mF0otpYtJXvYSqm
         DrdAt6dqSJ8r0x71xImJZ5O/lDR8UJ73qo1gF/Eo1AyDRY/AUIYoiQWrqsKD2ayQQ+yN
         Or2g==
X-Forwarded-Encrypted: i=1; AHgh+Rrzz86GMb38GpC3SYm7Gc1OVqi29NSU8b5Jx5ZT2iReiJOmy/JHySwGweI+AlMXbDwHkiuPGX98Tg==@kvack.org
X-Gm-Message-State: AOJu0YxDlbTtFbGk+TWeXsiu6VqjMdfyya0e8EZqUAfItOlUPOr3GgQv
	KAV+GP+iL+QEt+lZd4bL7xCemaLS97uOXTekxhSYfZApHFYdfCbQZSgIRcjGeNF9okopCqPF8Nz
	9uFm1SVweMqgc6bBEjXlyfRUrzhlyZctXkfs5xXIMJlDEHXNg+JCeXQ==
X-Gm-Gg: AfdE7cl+HmlSCr0f/nNh/bjD5GghVk8zgTAQ6FuGnKguaVZU7iMdEbvmQRDL7+UkbJM
	nsOnPBKSVAOhL7NOofV5q72WKtkJCKpU3ptiU6yXRoPrQz3y1YZET+FNr8sD3zL2L2ASYBGOqyX
	80Ex2csXzeQlqX/HzkU2/hiaEjyP1e/ADf9jAHjx25KgfL4b6Qy90TVYMBJjzWgFauKoc0QnmSN
	NPqVF7g7OTTj27KbY+iOyYXm7fhXXEtX2o9rPm9AyDtwoVPihISxyX/T1wBubTlSnILdK9quE4M
	LXgYw6xior2XgDLd1zgLR+2zFnQI2v52SxdrHoHpEuI0lUlhPk56pxz1yHbilUIouoCvMYjKDzw
	bZ2kaYqpdK6WHQRFxvnva6Z2MAq9mAbtb3qBy971N
X-Received: by 2002:a05:7300:2144:b0:304:13f3:e461 with SMTP id 5a478bee46e88-30c84d0ed61mr6718912eec.3.1782470093527;
        Fri, 26 Jun 2026 03:34:53 -0700 (PDT)
X-Received: by 2002:a05:7300:2144:b0:304:13f3:e461 with SMTP id 5a478bee46e88-30c84d0ed61mr6718867eec.3.1782470092953;
        Fri, 26 Jun 2026 03:34:52 -0700 (PDT)
Received: from [10.218.25.225] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c944999adsm9482228eec.24.2026.06.26.03.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 03:34:52 -0700 (PDT)
Message-ID: <4b00ec54-6fbb-485a-af9f-a2bd145ddeb6@oss.qualcomm.com>
Date: Fri, 26 Jun 2026 16:04:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org> <ai_LVreyRWx-RDEd@pc636>
 <ajGQ_WPT3Ra2kPCQ@casper.infradead.org>
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
In-Reply-To: <ajGQ_WPT3Ra2kPCQ@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI2MDA4NSBTYWx0ZWRfXxQfXei2X4cRW
 RwzUm6zjAnGr+0VOaClrkDhJGaRk3AH3rmq9qa631DcRIAaFIaGvC+YxUL8hTWb/9gtqDJfgZht
 9g4CCcagvSKauB1rUSUixp8IkSYZmxivdXQ6JwmyRtj5C7+92WmcI4brtRsZdlhwa8ZR9+8EWmY
 zIMVSEuPgEZGKeutgWzwwtWeC0zbAjGKkz4lCPkWSHp6QwyY3NGr+svy3J9gUw6PkVedAbUX9C7
 nodEyjHJ2I1IT81V+zCwIjddtFQGRN8/GHAbG3sCn3zdqDEs0rxICHPiCpqI1CXTO8XnybW/R7M
 PlxgLlMGaQ9DxP55rx/+PvNiAcmJsy5hNJ1+zlyCJsal53zoutbGOZDA2CqylC3siddxQPqsOih
 dBVJfYfbecOe0bp+LTMDrnacFl5uwjMyig4di9565WDdA34/nNicfjxAvb4t+qKvdoi1d6udGFt
 ORFwTvI7ibtZpiWDwnA==
X-Proofpoint-ORIG-GUID: XM_oL4HdVRr6wC_aux6pkPqiw5ES_bTS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI2MDA4NSBTYWx0ZWRfX6Yz59y33eG2b
 hiaT8hPkYNPeYoJIkOEI9yP7t6bUptysUTBOBv6k436R2g8xjEMJSuqdUNTQ2LXWwsdtoWtls3G
 6sGNUQUkS/bhHHDADeiJi+fGJ3VqF5s=
X-Proofpoint-GUID: XM_oL4HdVRr6wC_aux6pkPqiw5ES_bTS
X-Authority-Analysis: v=2.4 cv=MLpQXsZl c=1 sm=1 tr=0 ts=6a3e55ce cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=qSOC8k_MCT-xwaH91gwA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-26_03,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 spamscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606260085
X-Rspamd-Queue-Id: 9B17E120007
X-Stat-Signature: uuicwsi35m7obdenj9ra4wcp1snbn5uo
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782470095-719349
X-HE-Meta: U2FsdGVkX1/TaOblPXWf7ZVSaxMakEcstFH4a/vhPFXM5ThA7m4AZXXj+u+4h+PAHrsnLigm/aiNcE2j2cqJAjyKO/nN02nVbjRDd9ok9c+gsAW75okZ4E0Bm5V7yY1TrxAMvvWUq5A04RUKCvfNTWBJGV1e7WWgfcFFtIw/yWD3xztfp4RYGUY/GolZ+VC7Hlt4KIz4ZFdTy0WFIDMjp+XHw7F+eob+wzUVhuSI45Pw+ng59nI9sGUASqvXecc/OB3CaZB/22L3lenrKqK83woIdd6WQHRTK1CyviJ83qHrKWEc7uV1lorfQWEAK/5mhwtrgFCIBBILeUwJ1oIk/J1Xsbr/lsK2aCP2cvas8mSXUl8IdnMBL+Qy2/CPYr1XAHpcVzNNxVCRy/iSci9C619eaJExAsdZ7jFIvEX60mvl9jO+3WYZC/l4lah9YwCZEC4g87ckVLt5fZv/UCQFpW/lGpkP5W9vSUCGCmJJbGEZUsHCpAekbCnUANsIq9m6QdFHth92k10I5DSYUezeplnua8q5zJSTRm8eKWMHAZ06aAm33j7MHLrq+spR0xHMxAwBlqchRmfsD6D1HOOMk+QjVKVUTL/F8RxRNtd/2byZZLB4f+rofOUL+G9BVG3jIhEuYBW8/UEU/jvftMsynkD3L9ihJmS907UYtwSwJuL1XMPV4DFMUZffLq9HLK2XVdgJ2bELKwmLa/y13L7irVebR7khRqCdZhCJ+e+PJuZzpJ5YOPXFxMb/BM5e2zGQPydkgabWNoTk/IRzHzaEGaTR8mmT2k/mL89c/T/J/8weunNsHhVc9vFXtmllbEGZDnGX0yNOx6GS3RYV+SNHVhlsWgGPLc46TyMGlyz8MpwQewsXe3TxEmi12lLtO2LRugmWjn/aqlWe9/odDd7h+eZdecIhHgYhIANpeKpt4RA4yTPwGyY+ULTy77Ojsh4OpVLGy9pYKtNJT9o8AyI
 XNIuG6jq
 NtYeCgOBW4xzhLomL/HFQHX/ex1iOTJgaabklixKlGd+TmBg9of3UgTK9DEL0xcJk+X7k9a2KRFEWbQ73SHgIYy8yprDt/4N5Wko34jmdadO3v/9oMBC3PWIjFMfRU+n0qkQuNIfQjk4uB3cUBca0UCKbfmt7P/4+7B9zlScn70rugOZsNYYcr80M51kMJmp3WpPgt23BERujwToXWAsYsp6OLQDl7LN0Fcr+hYdzZrq4DG3B6xpES0hm7Gkine4BaG+csBsr2llXG+T6v/tdRxXaQKjx/VX6sRWh58NELj6GP8WdVqwiYdhT4MM4vgjTOjuNDp3evXYjUkJf32lNrpoHzrYt8Tqehso5tZxN8ghlcZl/di9nS68ah6xx/8nnAiNIYrHaND7lvDpBTVveLAUQtd6igYn8cjW6dOkYrBaWkQVrN9O/PhSNGW+K7zdZSLJWi9snFjRABsHBzTTNwrp7pzsWMZx3NTIKbDFr/ys/7ZPu0vtHlWe7OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/16/2026 11:37 PM, Matthew Wilcox wrote:
> On Mon, Jun 15, 2026 at 11:52:22AM +0200, Uladzislau Rezki wrote:
>> On Sun, Jun 14, 2026 at 12:15:28AM +0100, Matthew Wilcox wrote:
>>> What I don't understand is why you maintain a separate "free" tree.
>>> It should not be necessary any more, but maybe you tried removing it
>>> already and found a performance problem?
>>
>> We maintain it in order to split several entities. That prevents
>> interfering between allocated data and vmap-free-space manager.
>> So in that case one context can easily access allocated data, for
>> example vread iterator, etc., whereas another can do an allocation.
>>
>> So by splitting parts i minimize lock-contention.
> 
> Sure, but there are many ways to reduce lock contention.  One is to not
> take locks at all; the maple tree is RCU-safe, so you can read the tree
> holding only the RCU read lock, as long as you obey the RCU rules.
> 
> Specifically:
>  - Write side has to RCU-free the objects that are stored in the tree
>  - Read side has to trylock the objects it finds (and retry the walk
>    if the trylock fails)
>  - Read side can see a mixture of objects if the tree is changed while
>    it is reading, but for any given index in the tree it is guaranteed
>    to see one of the objects which has been referred to by that index.
>    That is, if the write side overwrites an index that referred to
>    object A with object B, the reader will see either object A or B.
>    It will not see NULL and it will not see any other object.
>  - If the write side stores both object C and object D in the tree,
>    the read side may see neither, both, only C or only D.

Acknowledged & I'll implement this approach for find_vmap_area():

Write side:
  Every vmap_area that was previously freed with kmem_cache_free() will
  now be freed via call_rcu(&va->rcu, vmap_area_free_rcu).

Read side:
  find_vmap_area() will walk vn->busy.mt under rcu_read_lock()
  using mas_walk() (RCU safe tree traversal) & will then validate
  the found object using READ_ONCE before returning it.

The maple tree guarantees that for any single index the reader will see
either the old or the new object, not NULL. To ensure this, I'll set
MT_FLAGS_USE_RCU on vn->busy.mt in the mt_init_flags() call.

With these changes, find_vmap_area() which is called on every vfree(),
vmalloc_to_page(), vmalloc_to_pfn() will no longer acquire any
spinlock on the lookup path.

Does it sound like a good plan ?

BR,
Pranjal

