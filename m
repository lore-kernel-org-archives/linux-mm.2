Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7613FCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0266B008C; Wed,  6 May 2026 10:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C977C6B0092; Wed,  6 May 2026 10:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86C56B0093; Wed,  6 May 2026 10:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A99126B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:43:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B0291A0270
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:43:53 +0000 (UTC)
X-FDA: 84737264346.18.9C2CB58
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4642F100016
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:43:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FfUiClos;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778078631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yrKfSuIFibBSjAR8E2oWzOhR6JQ9Zhv+MqRJc3mpQs=;
	b=57Pzz1FY6Vg06jStLr+fCHRRdqYDQ14HkiEk86EeZn689UeV/xMW7ENTMDOOnJg0LM8v/j
	KA1oNqngHFT36cltXvQ3YqzrbOAU2T/OpnJb9pWl20hPgFCIf/GDv8RMQHBhrJ+oChAqQB
	94dilhZNDBCZOk/3C77tJXRD9fHhzqk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FfUiClos;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778078631; a=rsa-sha256;
	cv=none;
	b=LF9C5WfMO0L63UTToK08JikxBOiNQrMXtM+OoJ9eURnskduC+RgbhbnBcRUiZbRCzjS41O
	J33xVWh8Tg23YTZyJ9pvUnX9Kzhdc/vIReo6S98z34cmQYWp3yYzSgX3Hl59JYtSKM62KX
	yOyohS71kCrbNqh5C04CE2u9ZRHciJc=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-44b052142e1so2824389f8f.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 07:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778078629; x=1778683429; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0yrKfSuIFibBSjAR8E2oWzOhR6JQ9Zhv+MqRJc3mpQs=;
        b=FfUiClosHCTJ9PxgJ4owMVlZArec0vM8JoFnfTCQVFL6i1Q2TPzVFRwHZ88hRrEStb
         h/zX+iW1ncA6i32/BkMrzVfOES6dr8KxuLkmgOTNmDx8OLo+XYmCtBcpslPaAViPuNZR
         lL3s75gGloUGoHlTso7bzDEKEkM0/zI9FqaKIUDFT/J1zz+sBtJSdNzAQVlCAoSZkD5D
         XDnvVhmAWRZaFw6BgOWFu4OHbtW5NRO+5OFyyPJm1DXUL5FYpCJE7SR/TWDIYLf8By8V
         UwnmDOzsE5KXtaEYvkLSfDwjF39Gg0WZ5ZoozDrQJ0XBlXMVkIqkQ78b/SqYxkJRQVSw
         TGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778078629; x=1778683429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yrKfSuIFibBSjAR8E2oWzOhR6JQ9Zhv+MqRJc3mpQs=;
        b=rV9w76ENdKABl6FofvR/mB6y1C6neJaKxd/b06nNs4/pICYEZIL/W7uIjAV1vl1HVA
         29upu7nxq1XQRmAfUQem2FCFGthlgU1CWIdfKcjUqiET/RdmWDEEAbJEHzu227nxDprG
         +eWXpDMcmG1rF23hKqiJrq2kYroZKwx+sLzZnQQLmC8AHaELOKTdQJ3fyyShcPdbGopZ
         6qqsBxd312tXG3+Pa60MbCb5JsY2+XW1N64uxIEYISzn5gnYgDPB8tZr1hxRNMebsizs
         fWTejX1dg7YEkJjKreTATh95mbRoUIz9vI+1Q1yCoCs09I9gAH7Aqi1TdR9c0ab3ep09
         GTsw==
X-Forwarded-Encrypted: i=1; AFNElJ9h/6fbbSLRON+Hq6Jr8YhCVHAew+nGT8W8QzqfZFX82Z1b9HcYL+kCccPTHl4urTjPgLF1npAgWA==@kvack.org
X-Gm-Message-State: AOJu0YwIQ/VqsJzrZYqlTXWbnrmPeEQntAMIVwaR98H8t4luYqh2dUeY
	Ka7oJDdD3eOZkRZRRYjXd2Lb34lVP2OKGCrZNbLnDv6/N8a3inLeJL6BJNNEJ4540Yw=
X-Gm-Gg: AeBDiesWz5A+YCmEIlDsbSX687f9aA5QQoPjHNSU9dHR6fIc2/t4yO/yIEHRvCYC6sf
	tknnko3fxRUJ47p7Li7wFZL1BBIAAacM6zYyhPj7a1Jc+q3wf7IV/DbFqls9Jj5Ycir/2Ht5NfT
	glhQcSnfIZb9PWhGKslhpZ2Kg8yzUqmKxEsjnsyEmCFEsq1hUV+25/c15w9vROh1iApTyI/QBrv
	PH0o50OfKaYplP02nRtR6wgmzUEEGoT2xfZjBaw7UXOk4hBbFlbtF6kvTn1x3xp9mrCHgCgWco2
	TSp0hh3wnnqwnFUYxdK7wFYiwaG7xGaVpmAzW3i6HvTdTfLxtkq84OTMg723m5mJbMgYiwxm1uh
	Dzuvivs4uoYyWsJHPqE7GW59X+gejLFGUc+KVMNgjeqoMyeZm/Pnz5i3LQ0masAssuQHnLFeORj
	H3Zc0kHKP/rbrsSH+Z7DXcsv8cWUEA2Vc0qaXfjGmbMeKSaQ==
X-Received: by 2002:a05:6000:3106:b0:43d:300b:2285 with SMTP id ffacd0b85a97d-4515b524457mr6633850f8f.11.1778078628705;
        Wed, 06 May 2026 07:43:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([185.194.185.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45055960fd6sm13732451f8f.31.2026.05.06.07.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 07:43:47 -0700 (PDT)
Date: Wed, 6 May 2026 15:43:35 +0100
From: Gregory Price <gourry@gourry.net>
To: Alejandro Lucero Palau <alucerop@amd.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aftTlyHYNr0B9yL3@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <b704b05e-3e65-4a73-84c0-21557b0cc38f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b704b05e-3e65-4a73-84c0-21557b0cc38f@amd.com>
X-Stat-Signature: mjrssnoefaat7rwkukn7dffbpkjztzze
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4642F100016
X-Rspam-User: 
X-HE-Tag: 1778078630-595209
X-HE-Meta: U2FsdGVkX1/qnRUpxcibPhOWh3BPJDqJN2i5UNFUILld8liq1XzNlhap02+7tx2rOO7bzadKu8She1igykzqIF8A7+cmE4wnSvkvqcZYVbvFahqLXj+NvpNLYAIMJ1GOGoUd742vPxs9del+8laeuGifezbFChfzdKmojTYWzxc2D8ovSiuLzuzIaGN9bhfLSVpuRhaSs9T7FJFwof9Zpwee2Eh6qkQhVpEEKXBeeIuRNJqIIyxPznC62KMywoADxKXb2CSAbnmj6D2CpURLtAMnDAc1ylRuRjjt3hobZbUcbV+pbA/w/dGgB/oIq1lzrup9TdN3X5xcIcER1zmEg2esIsKCG64CeRM99rcyY/+H4xy3r4rVrV12Sr4Lvy8JEhc0qtk7hNHuaJ1dEO1EjVnqcBxTSciL1fQby4YdAvWVdUV+CdcaOYmEPgKgFQI83TawqQab1koT/oE+WAMHKULEUsB6U0T0fvUlwIFEptH3DAW9ohlZzMk6E44EulFQNyYWk6gl/N5SMHNAaeQWq9mVu/dBw2E/PGiTe7QcvZl4pvJ7CN/+EnZVSYfJkmoKi5Q+aWSkJtBEbXVqLotoO8ygdNT0Jx71uMtIdGwyxqZQ1w24Onx4r6dzGDb8ghjeQxfa8DpXO7kesN8x24KXf54mhQYhEhpw/bDQnFDUTMdKReheMdmoVpMxeXOrgh3Yq7Rw0q3fjYWKmZabgRMhg1YjtYEbBZwHTghgg7nvuk0NMW4dLUmqRr11S8/VcqWyv9kOEL18WkeDIZ0RVm0A6hXVlk647+PU5Js4nyuhwxN9OXEa6CLC2lvxpfFjFJUyUv/QnivjQsAzfo6fqpawSFzKGa4wvmLTG65fKkuZQlxydjyYjhATaVLDRHJ40tkCXLQaK1uks9pRy7ZDh/Lq+pTBpynY7JPqakjMGAwNWMV5PbtDH/PtBYfJldiXZoyu88Yz+oMwGXB8bas3eC6
 vc2+h5ib
 nHCmAUnU3m5JjAoOU2HIO0T+4nxrf73w9IkmhcLU9+Qrv1o3ekjh3kieteCfhQbEieLWRdyDoqF5dN4zqAs63MDrCUAfEDwc26soZGxwk5Bvu4/RoxhtHkORAPbRS+2TiBzSnxUJYP0pK/m1o2po+94Z09jgCxTshb0ZgggjdWiaLW/5Uv1csHeMbMFOf/NjbQ5zPcZJwrovYYP81wg1S2YlMRrQZPNmlGfdybVzvQPTMu3tm/L4olxZxhPdRzOaaBXk/LcMrC8VdkhonFvKAOQgf+DZqh2EuugRpCq5mmF8cXtWA/soVYQBg5+mJ4jCMKo/u9fFd3YAf5M+P5AE96MfqUKFu9uiHGuUHVlr/mOaPk0Ev7W39d54/2z0mTN6AVf5NpWKYckCucy1tYKVt0agb6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 12:40:09PM +0000, Alejandro Lucero Palau wrote:
> 
> I can see the nid param is just a "preferred nid" with alloc pages. Using
> __GFP_PRIVATE will restrict the allocation to private nodes but I think the
> idea here is:
> 
> 
> 1) I own this node
> 
> 2) Do not give me memory from another private node but from mine.
> 
> 

I mildly mis-read this question, apologies.

Multiple private nodes in the nodemask are ignored, because the nodemask
is a filter function for the fallback lists - and private nodes never
show up in the fallback lists (except for their own).

So for example

Nodes:  Normal(A,B), Private(C,D)

Fallback lists:
   A:   [A,B]
   B:   [B,A]
   C:   [C,A,B]
   D:   [D,B,A]

            combination                       |  possible result
----------------------------------------------------------------
__GFP_PRIVATE + pref_node(C) + nodemask(NULL) = (C or A or B)
__GFP_PRIVATE + pref_node(C) + nodemask(C,D)  = C
GFP_PRIVATE + pref_node(C) + nodemask(ALL)    = C

Basically private nodes are completely ignored in the nodemask, so you
cannot do fallback allocations to other private nodes.

There is no good abstraction (that I have found) to communicate
multi-private-node allocations simply because this would imply needing
private nodes to be in the fallback lists for other nodes.

Maybe there is a possibility of modifying fallback lists explicitly, but
I think that is out of scope for the first implementation.

~Gregory

