Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F170C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083016B008C; Mon, 14 Sep 2026 03:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E736B0093; Mon, 14 Sep 2026 03:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18DC6B0095; Mon, 14 Sep 2026 03:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFAAE6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:38:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD1B7A11FF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:38:08 +0000 (UTC)
X-FDA: 85211564256.15.EA8C608
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04283120009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:38:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AF1F78tT;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYeier6a0sYH1m4ZQPsRiy+kEyAThBjcd7upAQ2zUUs=;
	b=XB0HhrxrAl0PpDSMJH5JeYen1OxFF8ssKV1SOdn+ZT8T8EskqPsDWRBpehT5VsYq2AgWhB
	7RP9ZZSBen1MEHyp+JgCBHEnBTcIvgiHAZtwxftRZjLCEbUAiOHFlqbpZtyF6KL5UmKOT3
	VpmwIJEZKcQN2H2Li1cRZTfk2JBUGV8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AF1F78tT;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371487;
	b=xhx193Y8D7iZ+xMmfB5InFTTDBdXIAeXpHAg9XK4WF65EiQzbga0EJsFpN1l2VRWl9fg7G
	6Mw9OyOjyIbNpVPM4/Aa047T1JCoT511X5JD4+RLnqZ4lg7iAXp5E2JxBoPhobeGyR5szD
	9ZbN10yaSLtOBU0fB2j2/Hvmk5DcpR0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789371482; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AYeier6a0sYH1m4ZQPsRiy+kEyAThBjcd7upAQ2zUUs=;
	b=AF1F78tTCf4lS23GrXf6j7yTmJbaqjpicTOiGpELz7hK0czRy3wXhB3up/lja//fupO6GBI1UNfHpRC/ZfAvKd1HWRN9wbOqRiQh7am1xetXf/PMYNPW8pZ5kTSscko7R6X+5Fh/RJQppUQdYfs0wvF8CvvOea8OXFFSlfco02c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAsfnHs_1789371480;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAsfnHs_1789371480 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 15:38:01 +0800
Message-ID: <8e3147dd-0ef5-486c-b635-a34bd29b25e3@linux.alibaba.com>
Date: Mon, 14 Sep 2026 15:38:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/mglru: add tracepoint for inc_max_seq()
To: Ridong Chen <ridong.chen@linux.dev>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-4-ridong.chen@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260911102939.2485750-4-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04283120009
X-Stat-Signature: 4dq1ckgnsx94y4eug1drpdwug8qqxwxj
X-Rspam-User: 
X-HE-Tag: 1789371485-664414
X-HE-Meta: U2FsdGVkX18S1v7RBecW7OCMBydcXSnPHVbqS/BabTI9TGztzhRRH2JG2/8Sp/tGfCGNkgJc2J0H2vqTizGL+nrcx9v1qPNOZOqUkidU1KA6HU780JE6gRB4cpsWFMkkWoYJT/Bf3/PV3LmBofTSrrgVCE3WIw8idTkDjQ8T2G8xqCF8FJnUT6syDL3tPyM+mgE//hZMJICBzcUb/El++S/QcDq8hEJWmC2/UtpiIP+sNF3+Ou1u/inqBCBzuXzstYlNzFifqnjlxvMy/ahKM1SIUiEO9K0RRMU3NOEdtne487wP/xu74e1D2yuhGXBWsza7t9PK6xPDaS6iBjfla80Bx8yhI1H3/PWj5mdLP7jOsSnXp2HAgx3gpJQA3uZ2iNTGxZQCA43gvGuhaP9C2AF8d3JdG20CgO9y5SzMEAsd19VcU8g+cFNT/XIgDfTETPFpn+h4d74WBo3tXDWzk6Dg1rtew7BbZTaly35z7wfd+rembwx9UF5La/5t7bfqeTSlzCa3EUmkJagOPlnE9vJa7CPFh5a+lRKVMRCT8e69K831k45cTovEi1QSsn7UCh2j67SaO2nKEg46AtazcLtTo5Td9xldQW2wpaPmB0pFuQJXUhKaSR+VG5xL2LhVkXWqXfH/g/CHKn7SnQ9Xz7JNHDzerE8LXN8eEB4BZat+GLwmSLInm5D4wXLkT3S53UmQYln92hg9zoUyJYUIFmmfp5xzY88rh71+aqXD36UphzmrNbQTJLfR5yxgPPqtHmkGEy5xUdbNpGxFnIaF/4mcOWKug+CPkXrH9/LlSBTWwlVjMLyop1U/A6xQUYKDrwUyD1hIU3ToXur1TWsTZjnceyMLuavBAKWSnmgQeQ4xRoeh43ZuKgCZjyn0BUAuVbFFpO5QIx8rNw9PdbdRKHwh9qI/V4mECXH/GnbtzMnN7Ypp/FJMesfnkOFql2HnOoWGqTGDr8nJnknRdpb
 yvyJQGhZ
 b02HCHRT/aRmT0kJmumiCsO9Ea6MbDtxPtjQpOrGBDA7YDBK6LVriG+iM9HTQagyuWXtAfH1VjSH1wd+7hjIRD4LRiQDVRvxVBrmUncVJ6O34DnxY0KvTJalf3b5zfshKKgZCrnZGX59rNMrlTnSwktI7wTxSDnkwCjdIKS+rdOM1Yd6w5WDDJGg+KGAMXyFvRQOB7F8iX73BBJxQSy3aZrSBsDStpNJx+pMXWRdO3vHOFlFqQSFGHeNYyt6ckZQqIBzG+bkxpc4JcD3Uh3ep50Tqsyt4uGttFRZ09FISaCSjzVOIswFF5RWgV7JMNouwPq31JoioCQekGvgZ4N0LqbL43/FT9Hq6C2Tppshb6c8lX4Ttwxo2+1tDPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/26 6:29 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> youngest generation. There is currently no tracepoint on this path, so
> the moment a new generation is created, and how the min_seq of each type
> trails behind it, cannot be observed as it happens.
> 
> Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped, with
> the memcg id, the new max_seq, the anon and file min_seq, and the number
> of pages in each generation for both types, summed over zones the same
> way the debugfs lru_gen file reports them. The nr_anon/nr_file arrays are
> indexed by generation slot, so the emitted max_seq/min_seq say which slot
> holds which seq. They are printed with __print_array(), so the output is
> hex and its length follows MAX_NR_GENS automatically. Paired with the
> mm_mglru_scan_folios tracepoint it makes the full aging-to-eviction
> window observable per memcg.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

