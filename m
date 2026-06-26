Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB21CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416FE6B011C; Fri, 26 Jun 2026 07:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEDB6B011E; Fri, 26 Jun 2026 07:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7236B011F; Fri, 26 Jun 2026 07:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6F6A6B011C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:00:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4665312041D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:00:35 +0000 (UTC)
X-FDA: 84921770430.19.0ABCA1B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49FF618001E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:00:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bZpl3Ilh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Im2KaEE5;
	spf=pass (imf16.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782471632;
	b=Rknvdbd5vVr9nt2Pth6K1xkwEKaUnFh3KnRPFA5Qwkcn+SQR5u2jCsgFsfzLBqrkm4afMG
	p7fqDLlAOsGnfSLf6+LNNs001uwYcit9HhWxaUAPu5ZalxPI0JmY5ESVJ2TdK/SOBtdNyw
	S7uk2CmJeRLr5pwKc1M1fPCdGxsw+RA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782471632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYzNiSMeKJI0bOmvTIa/+3LvwOG3pcLxhBaIBfRNE1w=;
	b=o9licG8gLnlwdh6wp9ZvBCABaa7qWzrtVdXHJC9BlggmCycqPVjqveM472nAemS+DdvKhU
	2soVQLh6fd5Sr0kcljDpx/CN2uLqTvtA3EX3Omzc6xWthL3VmLuONGqQgmoDrDr3nHP69p
	1FbbHCdCG7HPjmpXT6+DfpadhFsE7UI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bZpl3Ilh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Im2KaEE5;
	spf=pass (imf16.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65QAco6e3384292
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vYzNiSMeKJI0bOmvTIa/+3LvwOG3pcLxhBaIBfRNE1w=; b=bZpl3IlhJVnkffi/
	Ss0jLiOnQV3fQhZo160eJ5JucHQ8BIAa6jOVahy6KpBHNROceVU2BPzZr9pTsWIG
	D85me64tK6wOMed2fvPTMk+FfAPSpm+OjmYYoGTZSKTWrdpBQuuBQ9IUy/HL8DxD
	N9v8pOR7KP2br1YUmEwbbTdpnbUs9xwFS64Fb6+OAoisan5RNqhtoqKxYWBy3ujf
	E5S1XbXLk6uczq79U1Uz0lIPBPSJYu6Fz3KeV0wHB3tQfMYrKTRlzHC3xiONmTyO
	PsnwKbImF5re78+Nk6S66T1rHcTw2aJyApn4UZw978nX8Y/nhnRfFnszatDIOA4U
	cTZt5Q==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f19m3ucdc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:00:30 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1370417c0bfso981865c88.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782471630; x=1783076430; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vYzNiSMeKJI0bOmvTIa/+3LvwOG3pcLxhBaIBfRNE1w=;
        b=Im2KaEE5DOU5CY7uWbYvYasd2jTTGvj+x5OP4HEdksgT3CMEJvrRZp4fGD/QzYQfKx
         Hltz35sqNJS+9xPfaX2PCH6QVWqUOREnJ5NcUwu6v4ft+2WTmmPxDqSaVfv6OKxAs3Gl
         jJr4kzbQuimE0V5v/q/ec7gO16FZP2YLEbNfwvbRI5A0cfSrzMiJZhgiVApI9yvlpvcx
         ufp39i9kQIW5ZbPYKDy3AriDnful6q5Io/GTtEkEWhGvAQNOfEI3YzPae2KttorzCLdS
         0bHOoaUCU3+5xuHTy1GE/OBOTvuJMj4UjEByTsuAS0LmeiqKMCBgfC0reXMQcXaAo13G
         zJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782471630; x=1783076430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYzNiSMeKJI0bOmvTIa/+3LvwOG3pcLxhBaIBfRNE1w=;
        b=SDONpXMvWFDIDW0sVpn/DWDJcfYNuLXXwznWvDZp+/7j7pm2eZI/ImbSLSAeracYao
         Eo4VqmlKXw1+EtZQvGQ4/ROWIcNreO0ukx4weDqBaZz0cRcDLDNmmb87BF0RLKtvHzjt
         U919HbQpwdzD/vmFuUQdVK8Fb8s3HD0dxuaRevNabroF/kvjgyjvgWxCpttYTqh3GtC0
         hlxVV0eyDbcMY2kcAo8mAqysG5kiT+Pc7GoCgXxWdo/XZ8rQF0cgP7IRScG4Cm4vqWOM
         zNjTwuFA3WhdsD9FLh6piHQuxlRx07v37DRs5MkoLGozZgWiSc7IBeS/F6Gu+U9+24qc
         eohg==
X-Forwarded-Encrypted: i=1; AFNElJ93UTKtGQax2UcIDaTgMPEr8WeCoN23VWH8o+h/jZ5NlmzEzuvFPbdGblwHlF5u2GbMm5C3vYJnww==@kvack.org
X-Gm-Message-State: AOJu0YzjsBJHuuQcOfaCWsULh37Eh7OyqbQfybfYZh6tgw0u8RZjbQOt
	Yp1miABauISSW+iXtNDnpWImxaqd9Y/k88NteQUSfY1w+9r8AYqPOYmWqltwB2GWT1cY6tuESIG
	6AZXjCrUhozwRrMC7b3htGnEhdCaeP/3oLymt39lB0TDgbvMJwHdJlA==
X-Gm-Gg: AfdE7cnCqVqEeBYfs0rMsGV8AU3r7QV2Kq9VsUsfUF7thRQDkN34H64HeC9GR/Fyqlx
	/M+2+Q99arthAvqazxpGh1Fty2vUyxBew9qxyAfzkwkkcXBsHGcu6gZAzl4J1CpI+4Cs+s1yImU
	Ihb2LSDVmWsuCgohSLYP1d+xsw3Jtz6VXHp0wPlzKitxlD7s9GJt4PDXZP40SxFrMTKOBYqEPFJ
	HuMitHgnAjmnjjJ/SCtRw+WR6AuLyN/QnuxzSHMnbVAqEck8QFeJOd/4ENXU/bSVR4nxH7w5Ivx
	7rz4tU+TpYlvRVCLnonJaa56W9wfIwQILEE+EjuIupluIcPe8dKeRNGyhcVDZT13JzW73cOc+Dx
	05cVvZkI/C21C8e/a0Vf6FOoRxcUML+l2Bzko1QOM
X-Received: by 2002:a05:7022:61e:b0:138:59d:e1 with SMTP id a92af1059eb24-139c3d145c3mr13138247c88.24.1782471628959;
        Fri, 26 Jun 2026 04:00:28 -0700 (PDT)
X-Received: by 2002:a05:7022:61e:b0:138:59d:e1 with SMTP id a92af1059eb24-139c3d145c3mr13138183c88.24.1782471628041;
        Fri, 26 Jun 2026 04:00:28 -0700 (PDT)
Received: from [10.218.25.225] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c199561sm19913958eec.0.2026.06.26.04.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:00:27 -0700 (PDT)
Message-ID: <403ad230-36ac-4837-8c08-8fad8c79000d@oss.qualcomm.com>
Date: Fri, 26 Jun 2026 16:30:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>
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
 <ai5RL6QNKJJMo6Fl@pc636>
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
In-Reply-To: <ai5RL6QNKJJMo6Fl@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI2MDA4OSBTYWx0ZWRfX1prZ8kseinth
 fsvAXz2Zaj6qz4y/IZZVcawKwqD8PeGO/vkPPUCQiUVdH97KppAdgxV61MvLPsHsDDgcnNdjG7h
 26G/4q0xHfTPCJsk7JoujbBXTjc3KbI=
X-Proofpoint-GUID: 4MDS8euWI1ojKaT6DPJVUQc160o--pwv
X-Proofpoint-ORIG-GUID: 4MDS8euWI1ojKaT6DPJVUQc160o--pwv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI2MDA4OSBTYWx0ZWRfX9BM/ABZVX/xo
 JYn4MwD3uR+WBHdhEE9/UuR+UPAZkqTHqFO+u6PR1GpgEC9o4QK1tHeruXcWKsIco9YIkEddpn1
 HSbnLW2qNyx/TBXjRtjkk5BBxjwuyr7r+gu1Qa7you6THNCF5Lz3nOsRe/E4VsXEn9OCXmsxpXU
 yeHqX8/9dguSNg2W7tHW0jvT3aIXKNLCtdJb1XXkdkKDz/jboh0EzZ79kmfTnrFoOcJcqsyWcXR
 JAMbc0D0IAY2WbKciE7PCLRmubhTz8E/FtxnpBIWFTUkvJu/cHvVYL0FlQwkjnIm331ypaJOsmz
 QH5JWaL+F+MhMA6K6xI8TU3VxQH/KN5AWBzyP7mjJDeyK29ri1Cxw2kEVPi/TAxL9LjL7HvGp6S
 6G2kkgiHiu0/BRzceOm6/5SkPu77agxFq20qcLZfNRRsKnk1P2oZqBfIICSACGQ8yQ7ZCurGWWc
 exMLIjnm0ECaVmW2r/w==
X-Authority-Analysis: v=2.4 cv=Vv0Txe2n c=1 sm=1 tr=0 ts=6a3e5bce cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=5nLMZ4Yhui6UKd6mHGMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-26_03,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606260089
X-Stat-Signature: fnt1zs8ssbhxurto3ru1s9nefw7buiuo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49FF618001E
X-HE-Tag: 1782471631-61756
X-HE-Meta: U2FsdGVkX18PzXXhn6ua5AU90sSTNr1p46nqQaoRuh9DzGN+AWTGBq9Y9CYdiXEYXKmv0bQHNqvkL617dqxZIF5VNZHFqZAzmFfOmG6vsN2sOOi6k4Aitg7Noe0w0bGjWmqWYqeecn1envNXGIhU3viSz8XC5DW/3pmgAtrAHVkP/w6SokqqRLbRRn/8kKRMPqhd0K3upxDOUr/Rx3GqNULjRLED9Cy/pr1z653qIpjrDdohvdM6vegrwFveh2L6K0+3uvah1Ce9JCuc1Ic5fSJ/bEP5mdpYJFXK7DPHvhfA0OPFdqV17aQhAY9FTEQNDLzMC9e1Mt61bRl7jFlzQeQxrpbuLH+dYSiinE0YVN55FmaWwIkOl1fFZT4CQb8zlvWfOWm0kTGjlHVIv6G6pv1MntqRUwFejkeNKmezel65i4R9MvntP5L9zggCMzwf0ItjrwLXJmGs30Vixr2GufS9oYjEJlNgx28R55n97GywIHFj91fI1kgQvqRUTresXHQSGD7yLu9KHGHwrCoVUCytcYeqYMcZPDcsengyHXNSOPySaon8dlFrwb9Qf/h4CjAP88aDas6dWEgHRHNR0do1Pt8cLTMqMaMBMGoWHZBIB44DQBRtZh31GIx34YuoBwTHKXECXvgJRWF4Q5kPPSQiusG0krb+rgRbOxSzfFRZYpjHrVFFFVlopsbgR22bnLfV2InixHSvuTwEKcMFtHAyjHuyIkWoH82oeYfN7IRzD1UAahXM5lVw1KKngfS38UXTodwyuT8PWNIS1wfTffhwEfURzmIGCboJP9he/vGZmaJO+IzC8379nYCCD9g4I0r3uAxJAqAramUTPTBP4QudkaXO3IlogXNe9JKxqb8j5SvQT0jn5HSeo9I3wU+lExHCmR0g2vRY/7UpfHgXA9c1HdxwRwdZonN8Ndxn/yy0h2Jj3Mhq2vL06QUJ3VXvYlIom2ZqTBM6V/UPHQD
 qfjU3U91
 kAcmBrNTsBLSxAUk4OCZ6nfPYof3s7XBCEPubzAMIPpuJt/EH/D16b0nEmhhQowFgzDOCa+0VggcS+GUjxQxOin+K8jWAsTmwUZF6SQ1/NgbGA8L/+saPIKQWrarWPbZOCh1p7v3tMEQK5pUVfsz866JZfN8t2Tp+5dS0y1XovO5zurQKKY40D3vEMuQ7LGfGdbs5HzpHvMnn4P0empWegwfZe9CETGxVsQ1Nw1uK+dAzDL33a6P9Me9shsrH9qJUTsy7irrV/ZPt0xWe1EW6V+QidVNbtwfN/sQyqWxjhl5G8W2EaoECfa2uP3pZUm95s0Pw1i1Eq6HTdrqueTZA1bQ5OVrVfokOyu7u7OAZ63grMmtGOc92DmF0k5+PQeIyo2aaMBWWTDfOBu1wI4RiEqcDZ9A6UI8ahQc6riUSc+06fPARDfsdqGrnxAebH3aiU4hAVaUXHPCax7cE4j0kTvp57Tm24LpCD9JYYRwnCsyVaYx2aWMD0TwMubNAU7vQlhTjLfHttpfQETIzjOJhacI0sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/14/2026 12:28 PM, Uladzislau Rezki wrote:
> On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
>> vmalloc's free/busy/lazy area tracking is one of the last remaining
>> augmented-rb_tree consumers in the core mm allocators. The rest of
>> mm/ has been gradually consolidating range-keyed indexing around
>> maple_tree (notably the per-process VMA tree in mm/mmap.c), and
>> the underlying reason is a structural mismatch between rb_tree and
>> range tracking:
>>
>> - rb_tree is a binary tree with a single entry per node. A lookup
>>   walks log2(N) nodes via a pointer chase that touches log2(N)
>>   cache lines, with one comparison per node. Range queries are not
>>   native to rb_tree; vmalloc has historically maintained them by
>>   augmenting every node with a subtree_max_size field whose value
>>   has to be recomputed on every insert, erase, and rotation via a
>>   custom callback. That callback machinery is vmalloc-specific
>>   code that exists only to coax range semantics out of a
>>   binary-keyed tree.
>> - maple_tree stores up to 16 ranges per node (fanout f=16), so a
>>   lookup walks ~log16(N) nodes in tightly-packed pivot/slot arrays
>>   that are far more cache-friendly. Range queries are first-class
>>   (mas_empty_area, mas_find, mas_erase), with no augmentation
>>   callback to maintain. RCU traversal and sentinel range storage
>>   (XA_ZERO_ENTRY) are part of the data structure's contract, not
>>   bolted on by the consumer.
>>
>> For the vmalloc allocator's hot paths this means shallower walks
>> under the same N, fewer cache lines touched per lookup, and no
>> custom augmented-callback machinery to maintain. Aligning vmalloc
>> with the same range-tree direction the rest of mm/ has taken
>> collapses the augmented gap walker to a single mas_empty_area()
>> descent, retires the augmented rb_node from struct vmap_area
>> (-24 bytes per object on 64-bit), and exposes the range,
>> sentinel, and RCU primitives needed for a per-CPU range cache
>> that the augmented rb_tree could not host cleanly.
>>
>> This series completes the vmalloc internal migration from rb-tree
>> indexed tracking to maple-tree indexed tracking for free, busy, and
>> lazy vmap_area range management.
>>
>> The series removes vmalloc's internal rb-tree dependencies and moves
>> address indexing and range lookups/scans to maple-tree-backed paths,
>> while keeping ordered list neighbour traversal where coalescing
>> semantics require stable predecessor/successor behaviour.
>>
>> In addition to the direct rb -> maple migration, the series includes
>> robustness and scalability refinements in the same code path:
>>
>> - deferred/lazy maple bring-up to avoid early-boot allocator hazards
>> - maple-assisted ordered-list insertion for busy/lazy tracking
>> - mas_preallocate / mas_store_prealloc fast path for common-case
>>   publish work, with a non-indexed retry queue that absorbs the
>>   rare publish-under-pressure case without leaking or panicking
>> - single mas_store(NULL, ...) sub-range trim in va_clip() in place
>>   of an erase-and-restore pair when narrowing a free-area entry
>> - single mas_erase() for the busy-tree find-then-unlink pair on the
>>   free path
>> - consolidation of in-use ranges as a single authoritative index on
>>   the steady-state allocation hot path
>> - list_head representation of the lazy-purge queue, since that queue
>>   is bulk-drained and has no address-keyed query
>> - per-CPU bump-allocator overlay layered on top of the migrated
>>   indices for short-lived, page-aligned, common-case allocations
>>   (design and chunk-size derivation in the 0010-0012 commit
>>   messages)
>> - explicit lock/serialisation behaviour preserved (no lock removed)
>>
>> Primary advantages
>> ==================
>>
>> - struct vmap_area shrinks by 24 bytes on 64-bit layouts (72 -> 48),
>>   removing the embedded augmented rb_node and the subtree_max_size
>>   field that the rb-tree gap walk depended on. Verified with pahole
>>   on arm64.
>> - maple_tree's per-node fanout (multiple pivots/slots per node)
>>   replaces a binary rb-tree descent for indexed lookups, giving a
>>   shallower walk for the same allocation count.
>> - alloc-side gap finding moves from a recursive augmented-rb walk to
>>   mas_empty_area() over the in-use range index, returning the lowest
>>   matching gap in a single descent.
>> - vfree of a chunk-resident allocation through the per-CPU overlay
>>   resolves addr -> vmap_area in O(1) via the chunk's back-pointer
>>   array, with a bounded fast-reject for addresses outside any
>>   reserved chunk; the maple-tree busy lookup remains the fallback.
>> - correctness behaviour preserved: ordered list neighbour traversal
>>   for coalescing remains; the locking/serialisation model is
>>   unchanged; lockdep is silent across the test_vmalloc subtest sweep.
>> - robustness in bring-up and high churn: deferred/lazy maple
>>   initialisation avoids early-boot allocator hazards; the retry
>>   queue keeps publish failures under GFP_NOWAIT pressure correct
>>   without leaking or panicking.
>>
>> Real-silicon validation
>> =======================
>>
>> The series was tested on Qualcomm Snapdragon X1E80100.
>> The patched kernel was booted on the device against an RB baseline
>> image of the same kernel revision, and exercised through:
>>
>> - GFXBench, run for several hours of sustained graphics workload;
>>   the patched kernel ran clean throughout, with throughput matching
>>   the RB baseline within run-to-run noise.
>> - boot-time module loading via the finit_module / kernel_read_file
>>   path that exercises the bump-allocator's indexed write loop;
>>   this path drove the patch 0012 hardening, and the patched kernel
>>   is UBSAN-clean here.
>> - repeated insmod / rmmod cycles to soak the chunk install / drain
>>   paths under live workload.
>>
>> No kernel WARN, BUG, or UBSAN report was observed across the
>> multi-hour soak.
>>
> I tried to do some testing using this series. See below the kernel
> splat. I use test_vmalloc.sh to test/stress it.
> 
> <snip>
> [   50.661082] ------------[ cut here ]------------
> [   50.662455] WARNING: mm/vmalloc.c:545 at vmap_small_pages_range_noflush+0x569/0x6c0, CPU#12: vmalloc_test/41/646
> [   50.664685] Modules linked in:
> [   50.665454] CPU: 12 UID: 0 PID: 646 Comm: vmalloc_test/41 Tainted: G        W           7.1.0-rc7+ #347 PREEMPT(full)
> [   50.667765] Tainted: [W]=WARN
> [   50.668492] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   50.670639] RIP: 0010:vmap_small_pages_range_noflush+0x569/0x6c0
> [   50.671974] Code: e9 2d 01 00 00 b8 01 00 00 00 48 85 c2 0f 84 2d 01 00 00 4c 89 e6 4c 89 f7 e8 d3 80 c3 ff e9 1d 01 00 00 89 c3 e9 dc fe ff ff <0f> 0b 65 66 f7 05 fc 3e 14 02 ff ff 75 b2 65 48 8b 15 d9 3e 14 02
> [   50.676003] RSP: 0018:ffffcd36cc22bbe0 EFLAGS: 00010286
> [   50.677198] RAX: 8000000938940163 RBX: 0000000000000000 RCX: ffff8a7e9dd36000
> [   50.678752] RDX: fffffcb13b3a8000 RSI: ffff8a6fc919e800 RDI: 0000000000000000
> [   50.680313] RBP: ffffcd36cc22bc90 R08: ffffce6240000000 R09: ffffce622c064000
> [   50.681895] R10: 0000000000000024 R11: 000000000000000a R12: ffff8a7e9dd36000
> [   50.683459] R13: ffffce622c000000 R14: ffffce622c000000 R15: ffff8a776700db00
> [   50.685059] FS:  0000000000000000(0000) GS:ffff8a7f1a012000(0000) knlGS:0000000000000000
> [   50.686881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   50.688165] CR2: 0000000000000000 CR3: 0000000839c3c000 CR4: 00000000000006f0
> [   50.689773] Call Trace:
> [   50.690419]  <TASK>
> [   50.690994]  __vmap_pages_range_noflush+0xda/0x100
> [   50.692100]  __vmalloc_node_range_noprof+0x3e2/0x980
> [   50.693269]  ? long_busy_list_alloc_test+0x68/0xf0
> [   50.694375]  __vmalloc_node_noprof+0x52/0x70
> [   50.695366]  ? long_busy_list_alloc_test+0x68/0xf0
> [   50.696470]  vmalloc_noprof+0x25/0x30
> [   50.697389]  long_busy_list_alloc_test+0x68/0xf0
> [   50.698436]  ? __pfx_long_busy_list_alloc_test+0x10/0x10
> [   50.699626]  test_func+0x112/0x230
> [   50.700442]  ? __pfx_test_func+0x10/0x10
> [   50.701373]  kthread+0x10d/0x140
> [   50.702153]  ? __pfx_kthread+0x10/0x10
> [   50.703039]  ret_from_fork+0x3a1/0x430
> [   50.703925]  ? __pfx_kthread+0x10/0x10
> [   50.704821]  ret_from_fork_asm+0x1a/0x30
> [   50.705736]  </TASK>
> [   50.706322] irq event stamp: 1124795
> [   50.707157] hardirqs last  enabled at (1124805): [<ffffffffa1fe09b8>] __up_console_sem+0x68/0x80
> [   50.709082] hardirqs last disabled at (1124816): [<ffffffffa1fe099d>] __up_console_sem+0x4d/0x80
> [   50.711031] softirqs last  enabled at (0): [<ffffffffa1f1ba57>] copy_process+0xd67/0x2570
> [   50.712874] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [   50.714247] ---[ end trace 0000000000000000 ]---
> [   50.715336] warn_alloc: 15 callbacks suppressed
> [   50.715339] vmalloc_test/41: vmalloc error: size 409600, failed to map pages, mode:0xcc2(GFP_KERNEL|__GFP_HIGHMEM), nodemask=(null),cpuset=/,mems_allowed=0
> [   50.719421] CPU: 12 UID: 0 PID: 646 Comm: vmalloc_test/41 Tainted: G        W           7.1.0-rc7+ #347 PREEMPT(full)
> [   50.719424] Tainted: [W]=WARN
> [   50.719425] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   50.719426] Call Trace:
> [   50.719427]  <TASK>
> [   50.719428]  dump_stack_lvl+0x72/0xa0
> [   50.719433]  dump_stack+0x14/0x1a
> [   50.719435]  warn_alloc+0x137/0x160
> [   50.719445]  __vmalloc_node_range_noprof+0x8cd/0x980
> [   50.719450]  ? long_busy_list_alloc_test+0x68/0xf0
> [   50.719457]  __vmalloc_node_noprof+0x52/0x70
> [   50.719460]  ? long_busy_list_alloc_test+0x68/0xf0
> [   50.719461]  vmalloc_noprof+0x25/0x30
> [   50.719463]  long_busy_list_alloc_test+0x68/0xf0
> [   50.719465]  ? __pfx_long_busy_list_alloc_test+0x10/0x10
> [   50.719467]  test_func+0x112/0x230
> [   50.719472]  ? __pfx_test_func+0x10/0x10
> [   50.719474]  kthread+0x10d/0x140
> [   50.719476]  ? __pfx_kthread+0x10/0x10
> [   50.719479]  ret_from_fork+0x3a1/0x430
> [   50.719482]  ? __pfx_kthread+0x10/0x10
> [   50.719484]  ret_from_fork_asm+0x1a/0x30
> [   50.719493]  </TASK>
> [   50.719494] Mem-Info:
> [   50.743128] active_anon:0 inactive_anon:0 isolated_anon:0
> [   50.743128]  active_file:0 inactive_file:0 isolated_file:0
> [   50.743128]  unevictable:0 dirty:0 writeback:0
> [   50.743128]  slab_reclaimable:928 slab_unreclaimable:1820126
> [   50.743128]  mapped:0 shmem:0 pagetables:610948
> [   50.743128]  sec_pagetables:0 bounce:0
> [   50.743128]  kernel_misc_reclaimable:0
> [   50.743128]  free:12765547 free_pcp:26676 free_cma:0
> [   50.751177] Node 0 active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:0kB dirty:0kB writeback:0kB shmem:0kB shmem_thp:0kB shmem_pmdmapped:0kB anon_thp:0kB kernel_stack:15136kB pagetables:2444312kB sec_pagetables:0kB all_unreclaimable? no Balloon:0kB gpu_active:0kB gpu_reclaim:0kB
> [   50.757522] Node 0 DMA free:11264kB boost:0kB min:12kB low:24kB high:36kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:0kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   50.763396] lowmem_reserve[]: 0 2991 64259 64259 64259
> [   50.764526] Node 0 DMA32 free:346136kB boost:0kB min:3144kB low:6204kB high:9264kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:0kB present:3129216kB managed:3063680kB mlocked:0kB bounce:0kB free_pcp:54788kB local_pcp:760kB free_cma:0kB
> [   50.770714] lowmem_reserve[]: 0 0 61267 61267 61267
> [   50.771803] Node 0 Normal free:50727200kB boost:2048kB min:66468kB low:129204kB high:191940kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:0kB present:63963136kB managed:62737744kB mlocked:0kB bounce:0kB free_pcp:51984kB local_pcp:520kB free_cma:0kB
> [   50.778200] lowmem_reserve[]: 0 0 0 0 0
> [   50.779086] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (M) 2*4096kB (M) = 11264kB
> [   50.781534] Node 0 DMA32: 31*4kB (U) 28*8kB (U) 34*16kB (U) 38*32kB (U) 41*64kB (U) 48*128kB (UM) 366*256kB (UM) 15*512kB (UM) 1*1024kB (M) 3*2048kB (UM) 55*4096kB (M) = 344700kB
> [   50.788250] Node 0 Normal: 1282565*4kB (UM) 889838*8kB (UM) 149191*16kB (UME) 301234*32kB (UME) 240946*64kB (UME) 84458*128kB (UME) 775*256kB (UE) 32*512kB (U) 1*1024kB (U) 1*2048kB (U) 0*4096kB = 50724532kB
> [   50.792662] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> [   50.794471] 0 total pagecache pages
> [   50.795273] 0 pages in swap cache
> [   50.796063] Free swap  = 0kB
> [   50.796759] Total swap = 0kB
> [   50.797457] 16777086 pages RAM
> [   50.798184] 0 pages HighMem/MovableOnly
> [   50.799061] 322890 pages reserved
> [   50.799851] 0 pages hwpoisoned
> [   50.800578] Memory cgroup min protection 0kB -- low protection 0kB
> [   51.818069] BUG: TASK stack guard page was hit at ffffcd36cc25fff8 (stack is ffffcd36cc260000..ffffcd36cc264000)
> [   51.818078] Oops: stack guard page: 0000 [#1] SMP NOPTI
> [   51.818084] CPU: 31 UID: 0 PID: 653 Comm: vmalloc_test/48 Tainted: G        W           7.1.0-rc7+ #347 PREEMPT(full)
> [   51.818088] Tainted: [W]=WARN
> [   51.818090] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   51.818091] RIP: 0010:__lock_acquire+0x8/0x21d0
> [   51.818098] Code: c7 c6 78 9f 40 a3 67 48 0f b9 3a e9 4e ff ff ff 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 41 57 41 56 <41> 55 41 54 53 48 83 ec 48 48 8b 45 10 8b 1d b9 ac f6 01 48 89 45
> [   51.818100] RSP: 0018:ffffcd36cc260000 EFLAGS: 00010002
> [   51.818103] RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000002
> [   51.818104] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa3e065c8
> [   51.818105] RBP: ffffcd36cc260010 R08: 0000000000000001 R09: 0000000000000001
> [   51.818106] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000002
> [   51.818107] R13: 0000000000000001 R14: ffffffffa3e065c8 R15: 0000000000000000
> [   51.818110] FS:  0000000000000000(0000) GS:ffff8a7f1a992000(0000) knlGS:0000000000000000
> [   51.818111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   51.818112] CR2: ffffcd36cc25fff8 CR3: 0000000839c3c000 CR4: 00000000000006f0
> [   51.818116] Call Trace:
> [   51.818117]  <TASK>
> [   51.818119]  lock_acquire+0xc9/0x2e0
> [   51.818122]  ? __alloc_pages_slowpath.constprop.0+0xca/0x14e0
> [   51.818129]  seqcount_lockdep_reader_access+0x7a/0xa0
> [   51.818131]  ? __alloc_pages_slowpath.constprop.0+0xca/0x14e0
> [   51.818133]  __alloc_pages_slowpath.constprop.0+0xca/0x14e0
> [   51.818139]  __alloc_frozen_pages_noprof+0x361/0x3b0
> [   51.818144]  alloc_pages_mpol+0xa8/0x170
> [   51.818147]  alloc_frozen_pages_noprof+0x54/0x90
> [   51.818148]  ___kmalloc_large_node+0xc2/0xe0
> [   51.818151]  __kmalloc_large_node_noprof+0x2e/0x130
> [   51.818154]  __kvmalloc_node_noprof+0x5c0/0x9a0
> [   51.818157]  ? vmap_bump_refill+0x44/0x1100
> [   51.818162]  vmap_bump_refill+0x44/0x1100
> [   51.818164]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818166]  ? lock_release+0xd1/0x2b0
> [   51.818169]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818171]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818173]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818176]  alloc_vmap_area+0x1780/0x20b0
> [   51.818178]  ? __lock_acquire+0x46d/0x21d0
> [   51.818181]  ? lock_acquire+0xc9/0x2e0
> [   51.818182]  ? find_held_lock+0x31/0x90
> [   51.818185]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818189]  ? lock_release+0xd1/0x2b0
> [   51.818191]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818205]  __get_vm_area_node+0xd1/0x130
> [   51.818209]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818210]  ? vmap_bump_refill+0x44/0x1100
> [   51.818214]  ? vmap_bump_refill+0x44/0x1100
> [   51.818217]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818220]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818222]  ? vmap_bump_refill+0x44/0x1100
> [   51.818225]  ? vmap_bump_refill+0x44/0x1100
> [   51.818228]  vmap_bump_refill+0x44/0x1100
> [   51.818230]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818232]  ? lock_release+0xd1/0x2b0
> [   51.818234]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818236]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818238]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818242]  alloc_vmap_area+0x1780/0x20b0
> [   51.818243]  ? __lock_acquire+0x46d/0x21d0
> [   51.818246]  ? lock_acquire+0xc9/0x2e0
> [   51.818247]  ? find_held_lock+0x31/0x90
> [   51.818249]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818252]  ? lock_release+0xd1/0x2b0
> [   51.818254]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818258]  __get_vm_area_node+0xd1/0x130
> [   51.818260]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818262]  ? vmap_bump_refill+0x44/0x1100
> [   51.818265]  ? vmap_bump_refill+0x44/0x1100
> [   51.818268]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818271]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818273]  ? vmap_bump_refill+0x44/0x1100
> [   51.818276]  ? vmap_bump_refill+0x44/0x1100
> [   51.818279]  vmap_bump_refill+0x44/0x1100
> [   51.818281]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818283]  ? lock_release+0xd1/0x2b0
> [   51.818285]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818287]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818289]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818293]  alloc_vmap_area+0x1780/0x20b0
> [   51.818294]  ? __lock_acquire+0x46d/0x21d0
> [   51.818297]  ? lock_acquire+0xc9/0x2e0
> [   51.818298]  ? find_held_lock+0x31/0x90
> [   51.818300]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818303]  ? lock_release+0xd1/0x2b0
> [   51.818305]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818308]  __get_vm_area_node+0xd1/0x130
> [   51.818311]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818312]  ? vmap_bump_refill+0x44/0x1100
> [   51.818315]  ? vmap_bump_refill+0x44/0x1100
> [   51.818318]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818321]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818323]  ? vmap_bump_refill+0x44/0x1100
> [   51.818325]  ? vmap_bump_refill+0x44/0x1100
> [   51.818329]  vmap_bump_refill+0x44/0x1100
> [   51.818331]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818333]  ? lock_release+0xd1/0x2b0
> [   51.818335]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818338]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818340]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818344]  alloc_vmap_area+0x1780/0x20b0
> [   51.818345]  ? __lock_acquire+0x46d/0x21d0
> [   51.818348]  ? lock_acquire+0xc9/0x2e0
> [   51.818350]  ? find_held_lock+0x31/0x90
> [   51.818352]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818354]  ? lock_release+0xd1/0x2b0
> [   51.818357]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818360]  __get_vm_area_node+0xd1/0x130
> [   51.818362]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818364]  ? vmap_bump_refill+0x44/0x1100
> [   51.818367]  ? vmap_bump_refill+0x44/0x1100
> [   51.818370]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818373]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818375]  ? vmap_bump_refill+0x44/0x1100
> [   51.818377]  ? vmap_bump_refill+0x44/0x1100
> [   51.818380]  vmap_bump_refill+0x44/0x1100
> [   51.818382]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818385]  ? lock_release+0xd1/0x2b0
> [   51.818386]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818389]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818390]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818394]  alloc_vmap_area+0x1780/0x20b0
> [   51.818395]  ? __lock_acquire+0x46d/0x21d0
> [   51.818398]  ? lock_acquire+0xc9/0x2e0
> [   51.818400]  ? find_held_lock+0x31/0x90
> [   51.818402]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818404]  ? lock_release+0xd1/0x2b0
> [   51.818407]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818410]  __get_vm_area_node+0xd1/0x130
> [   51.818412]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818414]  ? vmap_bump_refill+0x44/0x1100
> [   51.818417]  ? vmap_bump_refill+0x44/0x1100
> [   51.818420]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818423]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818425]  ? vmap_bump_refill+0x44/0x1100
> [   51.818427]  ? vmap_bump_refill+0x44/0x1100
> [   51.818430]  vmap_bump_refill+0x44/0x1100
> [   51.818433]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818435]  ? lock_release+0xd1/0x2b0
> [   51.818437]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818439]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818441]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818444]  alloc_vmap_area+0x1780/0x20b0
> [   51.818445]  ? __lock_acquire+0x46d/0x21d0
> [   51.818448]  ? lock_acquire+0xc9/0x2e0
> [   51.818450]  ? find_held_lock+0x31/0x90
> [   51.818452]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818454]  ? lock_release+0xd1/0x2b0
> [   51.818456]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818459]  __get_vm_area_node+0xd1/0x130
> [   51.818462]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818464]  ? vmap_bump_refill+0x44/0x1100
> [   51.818467]  ? vmap_bump_refill+0x44/0x1100
> [   51.818469]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818472]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818474]  ? vmap_bump_refill+0x44/0x1100
> [   51.818477]  ? vmap_bump_refill+0x44/0x1100
> [   51.818480]  vmap_bump_refill+0x44/0x1100
> [   51.818482]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818484]  ? lock_release+0xd1/0x2b0
> [   51.818486]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818488]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818490]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818493]  alloc_vmap_area+0x1780/0x20b0
> [   51.818495]  ? __lock_acquire+0x46d/0x21d0
> [   51.818497]  ? lock_acquire+0xc9/0x2e0
> [   51.818499]  ? find_held_lock+0x31/0x90
> [   51.818501]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818503]  ? lock_release+0xd1/0x2b0
> [   51.818506]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818509]  __get_vm_area_node+0xd1/0x130
> [   51.818511]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818513]  ? vmap_bump_refill+0x44/0x1100
> [   51.818516]  ? vmap_bump_refill+0x44/0x1100
> [   51.818519]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818521]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818524]  ? vmap_bump_refill+0x44/0x1100
> [   51.818526]  ? vmap_bump_refill+0x44/0x1100
> [   51.818529]  vmap_bump_refill+0x44/0x1100
> [   51.818531]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818533]  ? lock_release+0xd1/0x2b0
> [   51.818535]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818537]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818539]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818543]  alloc_vmap_area+0x1780/0x20b0
> [   51.818544]  ? __lock_acquire+0x46d/0x21d0
> [   51.818547]  ? lock_acquire+0xc9/0x2e0
> [   51.818549]  ? find_held_lock+0x31/0x90
> [   51.818550]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818553]  ? lock_release+0xd1/0x2b0
> [   51.818555]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818558]  __get_vm_area_node+0xd1/0x130
> [   51.818561]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818562]  ? vmap_bump_refill+0x44/0x1100
> [   51.818565]  ? vmap_bump_refill+0x44/0x1100
> [   51.818568]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818571]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818573]  ? vmap_bump_refill+0x44/0x1100
> [   51.818575]  ? vmap_bump_refill+0x44/0x1100
> [   51.818578]  vmap_bump_refill+0x44/0x1100
> [   51.818581]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818583]  ? lock_release+0xd1/0x2b0
> [   51.818585]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818587]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818589]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818592]  alloc_vmap_area+0x1780/0x20b0
> [   51.818594]  ? __lock_acquire+0x46d/0x21d0
> [   51.818596]  ? lock_acquire+0xc9/0x2e0
> [   51.818598]  ? find_held_lock+0x31/0x90
> [   51.818600]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818602]  ? lock_release+0xd1/0x2b0
> [   51.818605]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818608]  __get_vm_area_node+0xd1/0x130
> [   51.818610]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818612]  ? vmap_bump_refill+0x44/0x1100
> [   51.818615]  ? vmap_bump_refill+0x44/0x1100
> [   51.818618]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818620]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818623]  ? vmap_bump_refill+0x44/0x1100
> [   51.818625]  ? vmap_bump_refill+0x44/0x1100
> [   51.818628]  vmap_bump_refill+0x44/0x1100
> [   51.818630]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818633]  ? lock_release+0xd1/0x2b0
> [   51.818634]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818637]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818638]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818642]  alloc_vmap_area+0x1780/0x20b0
> [   51.818643]  ? __lock_acquire+0x46d/0x21d0
> [   51.818646]  ? lock_acquire+0xc9/0x2e0
> [   51.818647]  ? find_held_lock+0x31/0x90
> [   51.818649]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818652]  ? lock_release+0xd1/0x2b0
> [   51.818654]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818657]  __get_vm_area_node+0xd1/0x130
> [   51.818660]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818661]  ? vmap_bump_refill+0x44/0x1100
> [   51.818664]  ? vmap_bump_refill+0x44/0x1100
> [   51.818667]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818670]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818672]  ? vmap_bump_refill+0x44/0x1100
> [   51.818674]  ? vmap_bump_refill+0x44/0x1100
> [   51.818677]  vmap_bump_refill+0x44/0x1100
> [   51.818679]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818682]  ? lock_release+0xd1/0x2b0
> [   51.818684]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818686]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818688]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818691]  alloc_vmap_area+0x1780/0x20b0
> [   51.818692]  ? __lock_acquire+0x46d/0x21d0
> [   51.818695]  ? lock_acquire+0xc9/0x2e0
> [   51.818697]  ? find_held_lock+0x31/0x90
> [   51.818698]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818701]  ? lock_release+0xd1/0x2b0
> [   51.818703]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818706]  __get_vm_area_node+0xd1/0x130
> [   51.818709]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818710]  ? vmap_bump_refill+0x44/0x1100
> [   51.818714]  ? vmap_bump_refill+0x44/0x1100
> [   51.818717]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818720]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818722]  ? vmap_bump_refill+0x44/0x1100
> [   51.818725]  ? vmap_bump_refill+0x44/0x1100
> [   51.818728]  vmap_bump_refill+0x44/0x1100
> [   51.818730]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818732]  ? lock_release+0xd1/0x2b0
> [   51.818734]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818737]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818738]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818742]  alloc_vmap_area+0x1780/0x20b0
> [   51.818743]  ? __lock_acquire+0x46d/0x21d0
> [   51.818746]  ? lock_acquire+0xc9/0x2e0
> [   51.818748]  ? find_held_lock+0x31/0x90
> [   51.818750]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818753]  ? lock_release+0xd1/0x2b0
> [   51.818755]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818758]  __get_vm_area_node+0xd1/0x130
> [   51.818761]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818763]  ? vmap_bump_refill+0x44/0x1100
> [   51.818766]  ? vmap_bump_refill+0x44/0x1100
> [   51.818768]  ? alloc_frozen_pages_noprof+0x54/0x90
> [   51.818771]  __kvmalloc_node_noprof+0x2fd/0x9a0
> [   51.818774]  ? vmap_bump_refill+0x44/0x1100
> [   51.818776]  ? vmap_bump_refill+0x44/0x1100
> [   51.818779]  vmap_bump_refill+0x44/0x1100
> [   51.818781]  ? kmem_cache_free+0x2d3/0x4e0
> [   51.818784]  ? lock_release+0xd1/0x2b0
> [   51.818786]  ? vmap_bump_alloc+0x1ae/0x1e0
> [   51.818788]  ? kmem_cache_free+0x2d8/0x4e0
> [   51.818790]  ? vmap_bump_alloc+0x81/0x1e0
> [   51.818793]  alloc_vmap_area+0x1780/0x20b0
> [   51.818795]  ? __lock_acquire+0x46d/0x21d0
> [   51.818798]  ? lock_acquire+0xc9/0x2e0
> [   51.818800]  ? find_held_lock+0x31/0x90
> [   51.818802]  ? __kmalloc_cache_node_noprof+0x18d/0x6e0
> [   51.818805]  ? lock_release+0xd1/0x2b0
> [   51.818807]  ? __kmalloc_cache_node_noprof+0x41a/0x6e0
> [   51.818810]  __get_vm_area_node+0xd1/0x130
> [   51.818813]  __vmalloc_node_range_noprof+0x145/0x980
> [   51.818814]  ? long_busy_list_alloc_test+0x68/0xf0
> [   51.818818]  ? kfree+0x32f/0x4a0
> [   51.818820]  ? long_busy_list_alloc_test+0x68/0xf0
> [   51.818822]  ? vfree+0xf6/0x2b0
> [   51.818825]  __vmalloc_node_noprof+0x52/0x70
> [   51.818827]  ? long_busy_list_alloc_test+0x68/0xf0
> [   51.818828]  vmalloc_noprof+0x25/0x30
> [   51.818829]  long_busy_list_alloc_test+0x68/0xf0
> [   51.818831]  ? __pfx_long_busy_list_alloc_test+0x10/0x10
> [   51.818832]  test_func+0x112/0x230
> [   51.818835]  ? __pfx_test_func+0x10/0x10
> [   51.818836]  kthread+0x10d/0x140
> [   51.818839]  ? __pfx_kthread+0x10/0x10
> [   51.818842]  ret_from_fork+0x3a1/0x430
> [   51.818845]  ? __pfx_kthread+0x10/0x10
> [   51.818847]  ret_from_fork_asm+0x1a/0x30
> [   51.818853]  </TASK>
> [   51.818853] Modules linked in:
> [   51.818857] ---[ end trace 0000000000000000 ]---
> [   51.818859] RIP: 0010:__lock_acquire+0x8/0x21d0
> [   51.818860] Code: c7 c6 78 9f 40 a3 67 48 0f b9 3a e9 4e ff ff ff 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 41 57 41 56 <41> 55 41 54 53 48 83 ec 48 48 8b 45 10 8b 1d b9 ac f6 01 48 89 45
> [   51.818861] RSP: 0018:ffffcd36cc260000 EFLAGS: 00010002
> [   51.818862] RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000002
> [   51.818863] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa3e065c8
> [   51.818864] RBP: ffffcd36cc260010 R08: 0000000000000001 R09: 0000000000000001
> [   51.818865] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000002
> [   51.818865] R13: 0000000000000001 R14: ffffffffa3e065c8 R15: 0000000000000000
> [   51.818868] FS:  0000000000000000(0000) GS:ffff8a7f1a992000(0000) knlGS:0000000000000000
> [   51.818869] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   51.818869] CR2: ffffcd36cc25fff8 CR3: 0000000839c3c000 CR4: 00000000000006f0
> [   51.818873] Kernel panic - not syncing: Fatal exception in interrupt
> [   51.819725] Kernel Offset: 0x20c00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> <snip>
> 

Thanks for testing in extreme conditions. I'll fix these in the next patchset.

> I have not looked through the patches yet. See below some questions.
> 
> Do you solve any real issue by this series? Can we split this series
> to several sections? I mean swap busy-tree then lazy-tree and latest
> free-tree. This is for better code review reason and performance
> evaluation one.
> 

Yes, on three axes:

Memory: struct vmap_area shrinks by 24 bytes per object (72 → 48 bytes,
verified with pahole on arm64).  The saving scales with the number of
concurrent live vmap_areas on a server with ~16K live VAs that is
~384 KB saved.  The 24 byte saving comes from retiring the embedded
struct rb_node (the augmented node carrying subtree_max_size), the
removal of which is enabled precisely by switching from the rb_tree
whose gap-walking algorithm required it.

Performance: Substantial improvements are observed across different
scenarios on both x86 and ARM platforms.

Code quality: The augmented rb_tree callbacks (subtree_max_size propagation,
find_vmap_lowest_match, the augmented gap walker) are deleted.  The maple
tree provides native gap finding (mas_empty_area), erase, and range storage as
features with no consumer side augmentation callbacks. This is a net simplification
in the allocator side making design cleaner and scalable.

> I am not sure we need to switch free-tree(it is not fragmented data structure)
> whereas lazy and busy sounds good to me as those contain more objects. 

Could you describe which part of the current structure
is most difficult to review?  That would help target any restructuring
effort most effectively.

In upcoming patchset, the occupied tree's gap space will be a complete
and accurate representation of all free address ranges. A separate free
range index will redundant by the occupied tree.

The concern about fragmentation is addressed by mas_empty_area(). The
maple tree's gap walk is O(log16 N) and touches tight node structures,
so performance on the alloc path is getting improved rather than being
regressed by using the occupied tree directly. The benchmarks runs also
above confirm this.

> 
> --
> Uladzislau Rezki

BR,
Pranjal

