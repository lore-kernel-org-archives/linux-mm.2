Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A25C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 10:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED456B008C; Sun, 13 Sep 2026 06:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E4B6B0092; Sun, 13 Sep 2026 06:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4136B0093; Sun, 13 Sep 2026 06:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A24DF6B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:28:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC3D31A0654
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:28:33 +0000 (UTC)
X-FDA: 85208364906.19.96000B6
Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	by imf19.hostedemail.com (Postfix) with ESMTP id 903571A0004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:28:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RTP+7qa8;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789295312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNFrZR5o2ClNxyWY9ZacqntCBgDAdln+Yk42pMsk8aE=;
	b=Y7rakBkD75PQv8uClMlQbPPV4nfeUzq658zE/cdLNUBlGfCj1hLO2H6YdDjvFhOIQAqeRa
	2+LpEaRr5Zr+otQjwn72CZNekasZhY6RCk85FD10qvr6sX255quAxNu96lJaicMB5kHgic
	9qXP5a4tpWBnW2MRql4vCgw5qwjiGkA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RTP+7qa8;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789295312;
	b=vRXNyaed7MpXkfeC6Hijve7iljRMJQHSC48ZQhNU8NYc6jPBv22DxFZdLbyhbDKBg+es+J
	i3n1raWzOvTU/7asVBHf86EVvTU3l2ab4Mhu2bfoUyxVq3QO3RFaKEPmvtv0WlL29jkpUT
	d7UFVSUSsLkCjrsjbDjsQvA7sdDvj9U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W6quqEuqAVLHu3zsXDdGSvOmeLHolpa6R9zg2wSv4vI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789295310; v=1; x=1789900110;
 b=RTP+7qa8E27RwXEebfZc1ApKGdgGS+WqVnNAJQhC3GxlRxCa4Lj2TIJtF/Vq9upEwpjZpcWo
 r3hCAI5av6nUt8GxGpKzm5yQZbjq23Lk2kbJ9L7BhGua4hl9+IA8bHaiUJWq7ueJTn0hAXtCGi0
 aoYpcCkzfhnKv09WY9r5VDGA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9c13bf885cb93025;
	Sun, 13 Sep 2026 10:28:19 +0000
X-Mizu-Trace-ID: 9c13bf885cb93025
X-Migadu-Flow: FLOW_OUT
Message-ID: <7cf8e45c-51a3-4de3-9417-170eb34e0713@linux.dev>
Date: Sun, 13 Sep 2026 18:28:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/mglru: add tracepoint for inc_max_seq()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911072848.2346073-1-ridong.chen@linux.dev>
 <20260911072848.2346073-4-ridong.chen@linux.dev>
 <20260911101514.1fe0d543@gandalf.local.home>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260911101514.1fe0d543@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wk4pdn9owbxqja6bj8ks57mdgiaut5h8
X-Rspamd-Queue-Id: 903571A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789295311-375628
X-HE-Meta: U2FsdGVkX1/5XEFu3BBNqnTql5Gp6wzWdv+HZJsz4RBBf66ej7YAG9e3OA/AV7G/wMwyoS1yT2OrGcdllfPY7AIOI0lTVv15WcufA0/EFdvFEeHPdL2Ovdh0zbz3uku3lgAtsc4omDqmq/mc7mV970o6q5gxwNJUQ4mekvK2IFmWyXdHVWsctmOgym+Kk7YqcilsxrgREWxYDU5JXjvBEI2vUVH0mLdCcve7one0oH0ZAzkTHA2T+AJuCglvFpfPG4WM8b5W1L4Iu5rFP8eQvYVS8wtKXqTfdCsXksnOwLXC1rfKYJEzZ9DtMwDqc62qk1p0JRcpFzyJl1iKFiutbSk1R1Wj5+zFnDUv/2tj310SO520yjvZk4rlkHikRWz7PsXASzRJbzoy4u6RdifaVO6Nm9Au6bbdac3EsUzECCiS7KvhXsoVZE322GtEpvJ9zScbZDK1MpDG/PjLk9wXcr7BlvLCEDR685S+mDDpQUM8b1dRnuXU907YHOQ0V5vzKVLw0ZfsHKlJG4MwOiQdSV7TiRuonU4otVDlG6/pgb7HwMrCSb+MFBHvwV8jY9nlLT4w0KkUOOHIafnSV/MlWbnvNgQqOAdr+SzeGFgO+9bWWrQOjaMrYjMZE/IH3YlL2AyFTzbmC1toH6WTFT+FCc8O9988GXes8rJ4ivr2ANakDplPBwV2RRPit49YOmKQaAkw7rPGwb3DUGGca7q7mxrk/KuR0BBUu7veW8ZSeUM2T/4r+yEOrLbDP4qLyW77IyVlMkTMgDJIE4V0lHKj7BB7YsZd6Vof5V8bJ3LiPCJC0Q+9fVwp+PyZka3rEqnTKhxDtWVHmx9ZTLJe0hXAXlP1exEQLcFT6qyAbiZmc3BklyYNYD8PmQJWDwrKlm4cdBgpCY3sOsAA/j7h72tlDFYl0jLCYyE9qnuZJ8h57hCIlEE3y6WnaTkU1O1SPaRapf7nJsAnb9f/0mfzMJf
 eljx08XK
 4/MpEC1ryqmznKCI2/9TqZehn/sHcb+RB7/65ZEGmQ9mQTnPv+/Q6cqFzcl1h8zYURwWoNHtKzqJ8BuLoSDW41Hrq2VzgCv9//23raYNGIysSI2E9YQeP7DqDb+2dbLMJZSYDeGcicndOwfqUs1AhNJM/dz75pXjZrjnXWgQb+L5Pn6YWp5Gt1Lzh0QgXanJvSyo5jrHw/CwBZXc1JZ9Tmqtusm8R8YRmUbfB46gQlvnza0kELmSGyjzVcIZUwLkdhL4SYZJzut7oJqzl9BKjwffdZPP/1d46vqODTL5vwOQAsY9fW9MsMY/n5uji/s7fLLOx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/2026 10:15 PM, Steven Rostedt wrote:
> On Fri, 11 Sep 2026 15:28:48 +0800
> Ridong Chen <ridong.chen@linux.dev> wrote:
> 
>> +static void trace_inc_max_seq(struct lruvec *lruvec)
>> +{
>> +	int type, gen;
>> +	unsigned long nr[ANON_AND_FILE][MAX_NR_GENS];
>> +	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>> +
>> +	if (!trace_mm_mglru_inc_max_seq_enabled())
>> +		return;
>> +
>> +	for (type = 0; type < ANON_AND_FILE; type++)
>> +		for (gen = 0; gen < MAX_NR_GENS; gen++)
>> +			nr[type][gen] = lru_gen_seq_nr_pages(lrugen, gen, type);
>> +
>> +	trace_mm_mglru_inc_max_seq(mem_cgroup_id(lruvec_memcg(lruvec)),
>> +				   lrugen->max_seq,
>> +				   lrugen->min_seq[LRU_GEN_ANON],
>> +				   lrugen->min_seq[LRU_GEN_FILE],
>> +				   nr[LRU_GEN_ANON], nr[LRU_GEN_FILE]);
>> +}
> 
> I would always look at trying to move as much logic into the
> TP_fast_assign() and not have it be where the tracepoint is called.
> 
> -- Steve

Thanks. Will update.

-- 
Best regards
Ridong


