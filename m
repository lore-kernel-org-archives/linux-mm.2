Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F970C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE8E6B008A; Thu, 17 Sep 2026 00:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70C26B00A5; Thu, 17 Sep 2026 00:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CA36B00A6; Thu, 17 Sep 2026 00:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA486B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:09:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89ED2A021F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:09:00 +0000 (UTC)
X-FDA: 85221923640.07.1FAC461
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 98AA540004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:08:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Fw9noaA1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=yXDQ7jTW;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789618138;
	b=RSPy5QWkoqWPGYQpQeV2qwRH1fqrGcg8LWxxnYrf49Ta7VvXyRcZzWwCxeLMuoz3XIrqSe
	TCxrDyI3q4XszVSbY48muDv6xqlY+FwVeAQNI7UZ0rtYJFxaxyId70jRbMGg6VLFQsPzJR
	2NO7fwvcoJvgX8yhV3uT47xhSoyIA38=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Fw9noaA1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=yXDQ7jTW;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789618138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4MsUG70Wxa0eAr2SAA/0CgdYUX3vDnkmNZ7zeQKTXH4=;
	b=fdYDSZlzidApuw8qn/+KLkLjTsm+Q0sycxC4EqDxnbAwuMHQse3XMJdxSUd51oagf6atdy
	XJ0jQvpiAxZ2p1IEeFCGVROovHx3frhBgEQPstW82VSmN1oSRsfok9lfor0VGnYHabNFS/
	AyYUCvvNjXmXAFM3pdFU+vldW3Od7CI=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YHMh202947
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=4MsU
	G70Wxa0eAr2SAA/0CgdYUX3vDnkmNZ7zeQKTXH4=; b=Fw9noaA1FqS+6l/o3z9T
	84pZlR5APSrMrHKrJE/h0+J/6xSiUOm2+7iRX1mXOKGEHYw53tUbgkoJgrKD+Isl
	M3twCkSJbl1SAWEgj4Yh9EMNmnbsx1lMChS+Xi/NR2pT5hrSrhfEhbYSIb6TNqWA
	DvLWozlsidXH9G87qjEYEwue/rf9A4N1VGpJU9IvQAjjbMblo+KqYpv8ish0k3fp
	hkj0itOozslY979hiF1+f4N8n+kb4SOi/0s99Dn8t5mb7+4T3+N7OZqyu2GIYdT6
	VNo0wOrx9JKQgEYqTCMun/mKsus/yXPsaO3yHbxCKrQ2NuFU5qUPoGyNlWaLt5xK
	vQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr1x6aep1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:08:56 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-530f9b8cd29so6234141cf.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789618135; x=1790222935; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4MsUG70Wxa0eAr2SAA/0CgdYUX3vDnkmNZ7zeQKTXH4=;
        b=yXDQ7jTWoEI6OlVZ3YtG+hGP33qDVmS1p/Vr124WzzWgLksdReroLvsYJEgQIrZwcg
         znQShGwc2HBxRz2j2SYcsQiZYeKas4CwUwmXNC2z0sqO4Lw2cZ73Vt1fSikBLWTiDSj7
         hHaWJJTThCEUyjAMHM5ouXqclVVTnzlba0CB5Y74gz504iQWLF85kTRrK+HwZAlS6pvw
         Prc6Fr0umGwp36Qu2SH9cVmm8cWcm6TLEqPXhToTl+5gHHYl4TMMEfotVW8vL9bLzNSN
         YsGRm8MKKoPb3/iEJdYvKZlR81rrXcLdoUhUs9cCkHzJhwGQsYIA8/ZDc29AmtRnKrWE
         y8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789618135; x=1790222935;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4MsUG70Wxa0eAr2SAA/0CgdYUX3vDnkmNZ7zeQKTXH4=;
        b=ifMcw687NGSY2J0wrzeojOvWIX93iQt8J1TNNrh3ZKn4b9+rAyaPzhBYK+XOuUtBQB
         qAOHZRL5N3NvNMqdSfidqpTVLsm7mrxcaSvhlf0QXmCwtYuyukivOkpm3GGYmETxJnMn
         A6ttZU/8qHCF6FXiJb84OV8RNNN4350WPqst8+iWvkrBrJDYR1tbZDjfVpI/ihvZQcQV
         RgvHIuML9/rpA8UzP9ViMSo873ytgg0xpJYQvqINtgyS0YwIrlt01JixpMatMv2TJbmM
         A18z4ofeEM5KNKjvflAX6PRMdE3E14fqdT6x+tT7k0Q57O7KZR1FwEpX1xfDsfIjAhWn
         rGsA==
X-Forwarded-Encrypted: i=1; AKwUvBxADVzB7C3rMsAdG+BYzButB+2T2vy5Wbm1xOHx4i+D7PleNZmo8IP2vmFdITOe4Kw/k1mU7f0oSg==@kvack.org
X-Gm-Message-State: AFuF++ks5a5J4dbclpyDhTWzLhgfZH/CgKAMjG/uJmbMiQxd+jtaHV/m
	AiedTZRJhrK7qnwO1Q5chugpjgIaayjWZPSjfHSNZm5fslm5NhDxzNS9y4Wa2oLo5LwRlvOlgb/
	+qthr4E3ZekUEUmOUWOkgRvGldSb0WIjWfRBSwbD7kzyTo7NN
X-Gm-Gg: AYBFou12CWRStELwc5p9vAUqHmlIuUHLoYY1MgY01rEB+Ym7I+egfpXuYc2niwAixrD
	TZS9AJCHk4i99TR2ZftGsd5jNeytmAd8GF+IwFpvQBaRFNIYOksBL2hbUEv8Z26LuNkahS7IiMl
	69SrMA5zXsGTBOpp8P9eJ6MSYQz9PpxLm1OvewIZcT0C+rZfgxsgiMON13W9+8zRYazWPqvcXJv
	Vqz5n5roT0QDPG4KQ5XJhWDXAq5IQrVcAikgVHMlNFFT1HoeZZ7M136w2n9VJA9p+Imv1fnpSXi
	PJxEReC9K+lCG9kzfncYT8bKFQefVy5wctgX+b6wBzaoKIuK9jU6S/qh0WmKxEizoPRF9/TcvH+
	rtWsF3NB95VPKxj2+tuPPpRGS4GSAjrhBkNHHU88X617+juj8tg==
X-Received: by 2002:ac8:7e86:0:b0:530:430e:8126 with SMTP id d75a77b69052e-5327ef48422mr75468551cf.47.1789618135156;
        Wed, 16 Sep 2026 21:08:55 -0700 (PDT)
X-Received: by 2002:ac8:7e86:0:b0:530:430e:8126 with SMTP id d75a77b69052e-5327ef48422mr75468181cf.47.1789618134691;
        Wed, 16 Sep 2026 21:08:54 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm39536581cf.28.2026.09.16.21.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 21:08:54 -0700 (PDT)
Message-ID: <af7d1ac8-7ef2-4227-949b-21c3a9097158@columbia.edu>
Date: Thu, 17 Sep 2026 00:08:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett"
 <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260916035222.GA19557@shakeel.butt@linux.dev> <aqrRewVuKfPk7y1U@lucifer>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <aqrRewVuKfPk7y1U@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0OCBTYWx0ZWRfX686i6kC5zYDe
 OegZ/QhP6QbGV85P4zOPZSsNlLxZ/c+FKGu702xiIfbagRebjUDQ4mM1WQo9FYjtDCeiAAVlf4J
 yIcIGHbCtN/Q/scg1ZOcY2nQ1xm7wDq5AdE05LMXPHGzPzpr/oNt
X-Proofpoint-ORIG-GUID: m_-BqQ7VNJyt9ss8QG0pMZtFkFKmtAUo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0OCBTYWx0ZWRfX8tMVbl2mKUH5
 p1a+k96EnWpwkJCh3ExHycAWSlcMoFlXxl5r73N3ayJjJ6FVPbBFm65o5yesDk+FRqnXsF0TOFo
 hc7L1KHf4ZyyUArrMJdNeay/Jcr0XfHVMWuzDfCM9rJ/zjf7QF86WawhulUBcUCY0aalXCWHk10
 2KguFVs0Ajj33V2wydrGrlAxYOrqo/eAd5zEZMfrSJc4jTas7xmWuJoHOWpcfui+7MN4LouQAh0
 1BT6r2oybBgI3gk3uXneIuv170WCXWNMxaTt4EmXAnCv688emwjqj5NFdjsKRPbiRJrK0uLoBT2
 YTinzRxWNV33qLFdZUAnzEU3gYBCnvWyiIH88rg7JJWCTxs46Vwsdd8PfamU9RtEIz7L07Y+dfN
 3GJmum4KZFcyfpQnBu5/vuX5rUiO1XvzH8SU3eyJbTJ/3bISRBusmKajCBl8HaNwNWslKIQxHnn
 9Aokwu4l+mvMmX0ZAXQ==
X-Proofpoint-GUID: m_-BqQ7VNJyt9ss8QG0pMZtFkFKmtAUo
X-Authority-Analysis: v=2.4 cv=CLS/zhrD c=1 sm=1 tr=0 ts=6aab67d8 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=65z7is_U1JLoJa5uI7QA:9 a=QEXdDO2ut3YA:10 a=QtEvL3ry9E0A:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 impostorscore=10 spamscore=0 suspectscore=0
 lowpriorityscore=10 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170048
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98AA540004
X-Stat-Signature: 99xgqrktpycz4rfe4wsg3b3ya7cxnjnw
X-Rspam-User: 
X-HE-Tag: 1789618137-428398
X-HE-Meta: U2FsdGVkX18/sWNtsrgY5+mlM3iCdor77YWtPFxjUea7jE/gC5DTdU1yqUdFka1V+d1kQIzhi35D7ZuPaIygNWicMDxaSPd9BZKHyFKQaqT5n4ExA300OALpMH5v04rSaq/D9N9JwwrI8AEFhoAA7vhtB18XJmcvT4FcnbhPPL3ZFoK5keMOyQpTZ/SwpkIfED/sEIu8a3U3TbwsYzG4LotzJv+uklxtCYR2Op2xPbkeg1GhWBaVC7J0x9UfudFo7L26wK7ohNtAVCgLv8Qge94ZDp2aCbm3aAqBLQNnN4rdjOyzUB2YzY1K+8hgLqOEiGdkvOyeVuFynlkeWnEQI/+zdtOBot5FfPu/P9T/JVbhdauEzkgehMcaIx2Zk2M7kOYi3+ls784YQQ4CJ29U9LhnowNdzBjkW+IscJVfWxYSWXa5H+ZwjlvRGtfF481oWYMU+CcwTwT23ttDeRXggeq/Bcaz3rZMxq98FbJVucACLQRedXs95M+Si8IdewoFDBXuPYdC2WP27jHIKiiEz1jhBKkWsaSqH6KZjV8C/Zv5rElD59xmouSuSDclcEIxEjRFL6F8EysDX2+wusneH8ElDjH0SYnW22lQ/NKScaGd8WtaQaN3fBpRrdqRJJqiE3+esIYJ9li4kEksdd60eSsLU4q1SnME06bWh0s1n+qpIYFpu7v3eQyEOW4MG78xw/klZrgKaSNP3xHzl8suHy9OMA3QDcqREx0p0NtUZVrAnFyQpn3O5Vc1F/JY73iqgbPgVBmB0vd6brawDrRkl/9kAfPg5WyR1DFpEktGX5ySd9TC9Yxdp92KC+nBFF/Q4uW1NXZZuwMXQdd3paXPshvPi9Kc2sY4eEIFJqFeTh9u8WX9x1tKEOQNKHr+raoA3YMZZ/TJ4j49NF1kRxZgplfFrjezG9vl+kAKgnVt3mLnYPGDo0pFsVzb/5M2Nz4toojXxJRp7mY+yTXI0on
 N0XJzw5u
 /bhygQQEhLC5NZfGJiEgPKAZDJPbdbjvckDzSvpecQ3ul4q4llNAYromoKrHhN5S0AhQ7kFwlEpVtUB0P3NPaOgfnY56u7rUTzhpYayFlAD0+FeQMZxGdrbH7m8Lrwceq/n31bcpW3VgMNG18BNi3fbIm8PaByVeL/T+F+G8ANLYuIx3LmSvo5f01KlSK1l0YcI9mlpFumakxiZ+zRiraj7gB3ZGqHvwvvXafDcPbyoQHV1vuUfG3XkeEbrjDfyHx/fudXQozeSNpaxR6z0HWstAMaPGYFJD447hRPegWYTUG0FBjFuYqF/mAPK+8simN1zG+C8aJQRcwXTg0U5ya8xGT6JiTeO/UhveilKC6cO4GIECpRPX3bLBWo5c4HMCTDlOvDpA7C3jVHtQa7at5kLB6SlMnpsj2S+fIjyyrBAFqffnlpal30/yDtLzhgr7XWMG4xJXD6vQzTpsA8m/6ity5Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 1:28 PM, Lorenzo Stoakes (ARM) wrote:
> but obviously, equally so for v3 :) thanks for doing this!
> 
> For whole series:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

Thanks Lorenzo, Shakeel, and Muchun for the reviews!


