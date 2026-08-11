Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D25C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4426B008C; Tue, 11 Aug 2026 01:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C1D6B0092; Tue, 11 Aug 2026 01:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A6E6B0093; Tue, 11 Aug 2026 01:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47B5C6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:16:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C40981A034E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:16:24 +0000 (UTC)
X-FDA: 85087827888.26.5D98E0A
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B66C120007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:16:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=gFSt92Km;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=CGYKzAgk;
	spf=pass (imf29.hostedemail.com: domain of prakash.gupta@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=prakash.gupta@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786425382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z22u4Y6qlTT7YZHZuEf9UIZJTy0sb+lujCBIrKH+O7E=;
	b=gZ2b7ML/1mAelz5Bl0nmUy/xyPR4rUEFb9O2irJ2dnxQS8wdBOfTW20lX/At/8gx+yIwG6
	H41hy3RufD0H4NTDSHiDVPJ/PNlsTkYIY9dj58erETqS8atodAO8s1f6OjV/9sqifX8vzH
	5KNkrDKajX/iCI5FjiblP+c6z/+JZqI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786425382;
	b=WE/TtO98zJgFatDpDpwnzRp6SJm6mHoSgxYOI0rApTmX+QAo4PxKcDjWn4vBCbrfE+8eeS
	Rwn3g2jv8Y9WFti+zUZReuUvFAavLRBFttSVSXk3cVBHCqwnYHv1ORNbRnbK01/sSqyrYW
	5ewFzBoI3IIwjRKTgBEAUjhdVj7k9WQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=gFSt92Km;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=CGYKzAgk;
	spf=pass (imf29.hostedemail.com: domain of prakash.gupta@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=prakash.gupta@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AMq2hs2252929
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Z22u4Y6qlTT7YZHZuEf9UIZJTy0sb+lujCBIrKH+O7E=; b=gFSt92Km6Te2K31E
	lwlexjI58oi6BIF8WTfEF8LYpWSOt5Qj+1mM4OMgeTtMHPByJ53fV5yk32g8e84A
	rbkAbah+k0XMZwiXhgKqMzQ+DaLdLZalQ4p8GxJGJ3VRhkiwLZoYIAsT+diOoxlN
	+9wYaZFsUBqs6teiQKMghj4gv7FsrE7jCzI8CbdL7qU3QA1vqbOu8rIdQ+zMD5zr
	LPwTTpUl3MUMQij0xpj2MDpJkXTsOhrYofZa0nzpRlCTx9AOG3OheTRauguT/SZ1
	xG9Vj51TivUw6MWhIRo3QrTad7mJJdi+lG90rpQiZdREGplTzwrGsucZbpkZvZkC
	7kFYOw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyjk7afx1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:16:20 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc5faecf01so8828295ad.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786425380; x=1787030180; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z22u4Y6qlTT7YZHZuEf9UIZJTy0sb+lujCBIrKH+O7E=;
        b=CGYKzAgk1pM7ZzYms36SN9V47OF4NL0AVB9iDAPKiZBiwXZ5PkFgNWuIztF4ye6pcT
         bFwcROeAEtzMgKiC0pkETGq/zYN4CWrpQRzJ/7pfW1f5IvVdGoz8i0uRkcmidlgDaS0S
         VrXnCUX2IKXsgOn1uGiOtZeILy6A+0DelZf4Tbiv0gkTybbnbzDx/pdOPLBi7OXXZO9v
         06gdBz+NNGVLb60qphxZPKSLyB9v2S0uC7NxLuiEZ7NuGGBR27rXsvyHW0YQ3FX+084W
         mMXcjduYW8qPUmgHuTx0z7tF8UeBEJrsf0vbNOwAj7p7qzCtXdxZ35fekLUA2XW75c2o
         jpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786425380; x=1787030180;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z22u4Y6qlTT7YZHZuEf9UIZJTy0sb+lujCBIrKH+O7E=;
        b=KKxgfiZJHNekEtFmTmncmvC3bQ+rBvDXQdbMELUWPn+DKXP6p3Aa78UZq9Gm3fHp9e
         qH8G4YQZwp1n2WKIRLovqK1soRdZR9ZmExD4lXJUrCkg+2xkyhZEQ5gPDqfcnr+8gkvE
         MXxQeWFFbc+q+c+YGziUDO/K+sCnX0ZhOulqI/tn616JNVdWT/HdTMW9NY4XVH0Mkg4G
         uLf2Tq4xveRdbrY75UQ/qL2ZghI/r3h1o4rtvDxTx9EdehwClfEstYzw+LYHTnZ32VjT
         9/bHwvkk1PbsStVdbxUi1pCd5EQXxkwCoDbUDtippkJ2H94pKe+2eE9rjuFDak+P3IQg
         idGg==
X-Forwarded-Encrypted: i=1; AHgh+RqCUg0PKAkedSdsUlRFaZvPTKccQfT9evYLiM7A98sRYfUof83jm1fBE0Hbx6GhNb+qRTWKoereUQ==@kvack.org
X-Gm-Message-State: AOJu0Yzgr38pScl3fT4jcuEpKfkxPaNjZIDhDMf+AlpvqcTB70G4O6lG
	unTWGHW1ik1ydu768oJVU771b3e8WaE7D/T+hZrJrb+O/0Lu9P69w1oHRNkcQdQzXXQ3D0PPJp2
	BtQgorrR9npZdhHseocVuPgoqeDvWtEAaWzB0PcKTLNGLeUzcyVL52g==
X-Gm-Gg: AR+sD13FXKvFdPqMQ8MeGhNBlm9POjDX4iHYFyIhUHu+PwrwzREh/RXmNkougLRxbLY
	J1y4znYjHsi6h8x6hCP+ekN4WUyPHOasNwxUivKdpcJqRCF+/LfLrINV3umCOrLQ3HlN9tQM61O
	C56mrX9/MAvY+4aCOpKRp4uOR9+8voZ0aBF8HN535dpeTqZKykZmXLQvDHrM5TS6HQAkVrja6K/
	xoVZnaT715Xop1ryu80MFaI4S3MQec52HXGDuE8dKNFt/ZABXZkoIVE+j0PiVJyD4/SdRVWfpgC
	SQKGjCjkb/W8THFndp8lTQXPknFwK+Vhc3Jn0rIp1s1+qrBbpVv9OPluwuxDx1EeOQFOR3xgJIe
	eDKPQkDpHmDA2X9TJtOMoOP/6uJ1qF2Jm
X-Received: by 2002:a17:903:3c4f:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2d3177d6f58mr11612045ad.1.1786425380003;
        Mon, 10 Aug 2026 22:16:20 -0700 (PDT)
X-Received: by 2002:a17:903:3c4f:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2d3177d6f58mr11611395ad.1.1786425379454;
        Mon, 10 Aug 2026 22:16:19 -0700 (PDT)
Received: from [192.168.1.3] ([122.177.240.172])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d31623091dsm1505835ad.77.2026.08.10.22.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 22:16:18 -0700 (PDT)
Message-ID: <53e05300-b84c-4a04-a7b4-5022285bcbdc@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 10:46:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined
 nodes
To: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-arm-msm@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
 <5059A780-9C10-4171-A254-38944464F1AC@linux.dev>
Content-Language: en-US
From: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
In-Reply-To: <5059A780-9C10-4171-A254-38944464F1AC@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Yus/gYYX c=1 sm=1 tr=0 ts=6a7ab024 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=/KRT0UA7ihr0Zk0c0WlnJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=CXD26xkfXwuzw2POT1oA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: AYks7QmJgIgGiKiehYUe7pBNu-61PFt-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA0MSBTYWx0ZWRfX1cxU++cBTW5u
 9er4b8l4qy5UDu6D+ACs1M4/7gSH5mEx+uT4cQKHQ/DuX/ZolgZCKmSwa6zYk8wUd03r0qQpT/m
 2ElfvqMTQoud0hTW8DoTb/JFYSlga6s5y7HxNFPGILETNsqdwzrBlP0V4oErcqpdg9YNGa3rnUR
 5lZsSyqVQAlMTTb8z8GC1LNTBcwYrD5G3AODXkmXgw4QhvFuNn4FJV12ckqBWfFezXBO7G2+FkE
 dSvw9nbzfrt3NLZwNOGowaKMhR90FoWUtgniP/WUmQ42YC78LOf2pFDzNRgQMntM4axN/2aRY0w
 2Zj0eU2bog+CsLHFiRijMdEyexMRn7Em2N7kPBCj/ncbXW1uyk9h+3x5H180z/uWPJmd7lwCkJ9
 IWLmX70pIT+3HspGhl4vuE2Ydhd0wf7ywt8ML2Uhac81gm3l5AQ1vVhp8ny/FR50/ylNcMLC5sk
 JAl9b8dke5Z7Ei/M3rw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA0MSBTYWx0ZWRfX9tFnADEXHzSB
 IsqYekb0iw1zWNfF66+jsc8IRTWJ3q3rlVX94HwvnMaj54nwmHovLZglt88QNSgJVQ8IOFQDAnA
 mPYCEtDCs+OVnqhfUiKeWkpO6w7J1Ds=
X-Proofpoint-GUID: AYks7QmJgIgGiKiehYUe7pBNu-61PFt-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608110041
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B66C120007
X-Rspam-User: 
X-Stat-Signature: xuiqdtmsx4notx6se6rfrwrqm35q646b
X-HE-Tag: 1786425381-261922
X-HE-Meta: U2FsdGVkX18SvzSzOAyToo5J6gm05ZDvNPkok9hzvZjsO7a4Y2Q3fNSD+PWBQobQ7WwFYpFntOdVSEXESzbxhjaIXOd7sLoxO1AJFuQQ1zMLJtYhBy8r0dvNzi1YiRKL3ydnfd/FWlN2jPV/WjZcSq6unkqGLPcwZOEjLL4EIe+nJEDIEzfIAKork/At4uyDPJYN2zzl1poF9xcKqekDaRmopBGsLzAmEGlvJ5NyhkybbgbhwDCLQvLrplCtZ6ZW0+eLmgPWwbsA8buL5/k6dTKAH+E62pJxWd2dYd9LOY5aVh6tWv0XuFR9J1G9FYSJjcPi3+jE8zQRvyE5A3HAxsxBIVVeqanknQNbzQI0q5K4MMflHQfR8v3ZOTQJV/GoTgSWvxJBRT48yfRUCivQYFFZyT3QN2jhbN4+6bUwWpcLjKGWRXnNBHOP4eMGTIw6UVPs0RgHN7vsp1kPnOSpJMJ77I63s4NgIuFUSq2BwVeDGhTXGAqa56IM/++a0KwsY36TEkaDc4P3Q79FWun9movkTyCDB1Qdaib4b3TS7WziGp3DBXmjubG6JoQtq5FyRUhNeyG0vButaBriggK1aPClXNZ7bJGyjpDLrC8TLnIKL8dOFoomgw4Ygpz1QtviTn3VYBHRqXszJ4k/zwXn2+D9FkQDCwIwBLE28sMHAjP+7IOs6wMffyS8j1Vgk+ypWPI3qArkMTf5RZOhbNPTgtoE7gYCrcPCkdiwjyP2yhDuzYjWOcTVdFcSgdFX8PMOWFu/SvyZteYl9fqBH+26HIucAEbscPC4RuAWnz3fi++f2LyTLLQHZq17V+ur1a75mfb4Wq+2EnEymKK/k6Hsj9/zUPet1jet43BnvdXguLfDoBOU+IbALS0fxPN8jy4AqST2PV7cFONzsdCBfxHs1fI440//03dVtF+TUVL1hFrTXIwRbSdDcVbL83wjQwLW2clUrxHeznNKaGQYCy3
 wN7i41mJ
 UNvDeq+fMNzq5uGA9ctRNXEpA+4xcmJn81tv0PBcnusvf6DA3/DX2HXKvtJ5ak91tW9o+wZCsGj/AKQMcxG3YddOvs0ww/g5PAo7qp4wQmii/+fteYc1AWtwDW2mAYYdTDmMMOleWA0rJPGU40nC8MV81NcHlsuC7CODNvGN4ZFC8P7RH+er47YTOjGc1HUMvAXllfDig0DF1AGlqHpQHwWKNS/anINbN916CJpOJCgvVpe+7n6VRuqqYM/Q5Tq+EMdxQJmXp9EJzLRNVbZvZZtxiWlq92PTIv/4Hz0XqKB13H1bQo1qJzu6haw7e0cW7oLoCLPixP9hVhDVSW+TS9VHFtCmO39C7j46Mor753Sd/97Xatmk//QWC/q9hb9dvyJP5IMHSaK1krQYLLBCcq6T0btbLHq3eISoycEy0hNYhR+KU/dThyJfSsm8RJMf8Wh4qjXpfXVGxVTPqBqvoJvb1EwIxrCQNcVArfY+2mAZOXgTsGaVc+p7+2mhIyb/dltDNQYf3u+LOVZsVnY7zOUFyLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/10/2026 1:28 PM, Muchun Song wrote:
> 
> 
>> On Aug 10, 2026, at 13:46, Prakash Gupta <prakash.gupta@oss.qualcomm.com> wrote:
>>
>> memcg->nodeinfo[] entries are allocated only for nodes present at
>> css_alloc time. When a node is onlined after a memcg is created its
>> nodeinfo[] slot remains NULL. Two call sites dereference these slots
>> unconditionally:
> 
> I don't think the premise of this patch is correct.
> 
> memcg->nodeinfo[] is not allocated only for nodes that are present or
> online at css_alloc time. mem_cgroup_alloc() allocates per-node info with
> for_each_node(), and for_each_node() iterates N_POSSIBLE nodes:
> 
>         for_each_node(node)
>                 alloc_mem_cgroup_per_node_info(memcg, node);
> 

You are right. I rechecked and nodeinfo[] is allocated for all possible
nodes at mem_cgroup_alloc() time, not just currently online ones.

> If memcg->nodeinfo[nid] is NULL on your system, that looks like a
> violation of this invariant, or possibly a downstream-specific change,
> bad nid, allocation/lifetime issue, or memory corruption. I don't think
> the generic explanation that "the node was onlined after the memcg was
> created" is sufficient.
> 
Agreed. I will investigate further before resubmitting that part.

>>
>> lruvec_stat_mod_folio() calls mem_cgroup_lruvec() which reads
>> memcg->nodeinfo[pgdat->node_id] without a NULL check. On a system
>> where a node is onlined after the memcg is created, any folio stat
>> update for that node crashes with a NULL pointer dereference:
>>
>>  Unable to handle kernel paging request at virtual address ffffffbebf7e1908
>>  pc : lruvec_stat_mod_folio+0xf0/0x444   [6.18.21-android17-5]
>>  lr : lruvec_stat_mod_folio+0x88/0x444
>>  Call trace:
>>   lruvec_stat_mod_folio+0xf0/0x444
>>   folio_add_new_anon_rmap+0xac/0x2b8
>>   do_wp_page+0x768/0xc80
>>   handle_mm_fault+0x37c/0x8c4
>>   do_page_fault+0x140/0xa1c
>>   do_mem_abort+0x54/0x74
>>   el0_da+0x48/0x8c
>>   el0t_64_sync_handler+0x20/0x130
>>   el0t_64_sync+0x1c4/0x1c8
>>
>> __invalidate_reclaim_iterators() iterates for_each_node() and reads
>> from->nodeinfo[nid]->iter without checking for NULL. for_each_node()
>> visits all possible nodes, so this is reachable whenever a node is
>> onlined after the memcg was created.
>>
>> Fix lruvec_stat_mod_folio() by checking nodeinfo[pgdat->node_id]
>> directly and falling back to mod_node_page_state() when NULL, mirroring
>> the existing !memcg early-return path. The fallback must not go through
>> mod_lruvec_state() since that calls mod_memcg_lruvec_state() which uses
>> container_of() to recover the mem_cgroup_per_node from the lruvec
>> pointer; passing &pgdat->__lruvec there produces a garbage pointer.
>> When nodeinfo[nid] is NULL the memcg has no per-node accounting
>> structure for that node, so node-level accounting is correct.
>>
>> Fix __invalidate_reclaim_iterators() by skipping NULL nodeinfo[] slots.
>>
>> Also switch lruvec_stat_mod_folio() to folio_memcg_check() which uses
>> READ_ONCE() to safely read folio->memcg_data in an unlocked context.
>>
>> Fixes: 6c77b607ee26 ("mm: kill lock|unlock_page_memcg()")
> 
> The Fixes tag also seems odd. 6c77b607ee26 ("mm: kill
> lock|unlock_page_memcg()") only removed/renamed the lock_page_memcg()
> wrappers and does not appear to change nodeinfo[] allocation or memory
> hotplug handling. Could you explain how that commit introduced the NULL
> nodeinfo condition?
> 

It did not. It seems I picked up the commit based on git blame on
function as there were two related bugs reports that I was conflating
into one patch as listed below, will fix that in v2.

Variant A (missed to mentioned in commit msg) — NULL dereference:

    Unable to handle kernel NULL pointer dereference
      at virtual address 0000000000000528
    ESR = 0x0000000096000005 (read fault)
    Workqueue: events delayed_fput
    pc : lruvec_stat_mod_folio+0x5c/0x444  [6.18.21-android17-5]
    lr : lruvec_stat_mod_folio+0x2c/0x444

As you suggested this may need more investigation.

Variant B (the crash included in the patch) — stale pointer:

    Unable to handle kernel paging request
      at virtual address ffffffbebf7e1908
    ESR = 0x0000000096000045 (write fault)
    pc : __lruvec_stat_mod_folio+0xf0/0x444  [6.18.21-android17-5]
    lr : __lruvec_stat_mod_folio+0x88/0x444
    Call trace:
      __lruvec_stat_mod_folio+0xf0/0x444
      folio_add_new_anon_rmap+0xac/0x2b8
      do_wp_page+0x768/0xc80
      handle_mm_fault+0x37c/0x8c4
      do_page_fault+0x140/0xa1c

__lruvec_stat_mod_folio+0xf0 places it after the !memcg NULL check.This
is consistent with folio_memcg() returning a stale memcg pointer that
passes the NULL check.

folio_memcg_check() uses READ_ONCE(folio->memcg_data) which seems the
correct API for unlocked contexts. folio_memcg_check() has been
available since becacb04fdd4 ("mm: memcg: add folio_memcg_check()")
but lruvec_stat_mod_folio() was never updated to use it.

I should also note that this crash is difficult to reproduce in a
controlled environment — the analysis is based on crashdump inspection.
I have not been able to construct a reliable reproducer so far.

let me know your thoughts on this, accordingly I can send a v2 to cover
only Variant B fix as explained above.

>> Cc: stable@vger.kernel.org
>> Assisted-by: pi:claude-sonnet-4-5
> 
> Given the Assisted-by tag, I assume some of the analysis may have been
> tool-assisted. That's fine, but the author still needs to validate the
> reasoning against the actual code before submission.
> 
Agree, I will be more careful in next submission.

> Did you confirm that the relevant allocation and hotplug paths were
> manually checked against the affected tree? In particular, I wonder
> whether this behavior depends on downstream changes around
> mem_cgroup_alloc(), for_each_node(), node_possible_map setup, or memory
> hotplug nid validation.
> 
I checked all four paths against the affected tree
(6.18.21-android17-5). Only difference in
mem_cgroup_alloc() are cosmetic and do not touch the nodeinfo[]
allocation path. The NULL nodeinfo[nid] in Variant A is not explained
by any downstream change — the root cause remain unknown.

Thank you for the review.

Thanks,
Prakash


