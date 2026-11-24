Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4783B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W5Ih45qE
Received: by kanga.kvack.org (Postfix)
	id 21AAA6B05B0; Mon, 23 Nov 2026 20:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8936B05B1; Mon, 23 Nov 2026 20:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0586B05B2; Mon, 23 Nov 2026 20:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2D736B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:48:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14EE7120A40
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:48:24 +0000 (UTC)
X-FDA: 85468327728.16.EAC2A43
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	by imf03.hostedemail.com (Postfix) with ESMTP id C425720007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:48:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W5Ih45qE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795484902;
	b=f+lYuiO7Dxb/IthwQ8ZEprnNyaAqI2NoRKIsMCTJ9jUGshZ0Zmvqb/Y0s5lMcs7FphvIpp
	i+38WwG8vOexj5UFNFOsLslQA9QAgvuSf0xhVHeYl4Z2puKdmkHaGEn7vMz4MdnHOiWUhZ
	Rv3Wwv+0W0VFAotRP9I5RPIafJlLynM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795484902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYeXey0LZKAr9y93bLmI3WREdqmVh7UF8M2AGa4D72Y=;
	b=naGsW24BSGNjcrjlNV3HIpqbrYhU4tPGwBkqMOpa9bYJ32YJpJjSUXvGyZCPMUtzNOruaV
	TrOgPywlXQX91V134wNTYbOO7pDBPadQwvz5WBDge5vRUW4JZtFrM81l9vUtR7+HQros5U
	EnMQds0C3A5rCMs6agGFmr1PSSS+HDU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W5Ih45qE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/UvUK+iq3spW3Gwp986cH52nWz7i0x59jVwtnJPzO3U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795484900; v=1; x=1796089700;
 b=W5Ih45qEodCg6FlSfZL3E1tlrklfohUSek3pR0AQiMLi4pYXQR6iwjT6Ryo8SVJsSJ4ih5yd
 /jDBCClbI2Uxv/DaLbVwTDYCWX7bg3XkwpeDbyNO5hXmS71BFkpbjy4ALccaplZw88a4xXr22MU
 oRcUrxDt0pqUumdfMe8YM+ps=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a9aa70375487e8b4;
	Tue, 24 Nov 2026 01:48:20 +0000
X-Mizu-Trace-ID: a9aa70375487e8b4
X-Migadu-Flow: FLOW_OUT
Message-ID: <76ab403d-2e4c-4aa3-a638-830971c13669@linux.dev>
Date: Tue, 24 Nov 2026 09:48:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, David Hildenbrand <david@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Yu Zhao <yuzhao@google.com>,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261119134740.514632-1-ridong.chen@linux.dev>
 <20261119134740.514632-2-ridong.chen@linux.dev>
 <CAGsJ_4yiSji++3BPgFUWDp0SGJkFj13qjEfkjNZu7ak1JNozSw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4yiSji++3BPgFUWDp0SGJkFj13qjEfkjNZu7ak1JNozSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: e7bjz3gpxrx75cwsyep84iz7fjokxmy1
X-Rspamd-Queue-Id: C425720007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795484901-934049
X-HE-Meta: U2FsdGVkX1/SZ8dL/v2wFw3/Ws8HNTfvIS1nQTSosmpJKxqJGRZ/J75NDQnF/zs7nI84Z9EURgYhL68VKyjhGDFmijDEteEX54nB2NRjc45uv5rKFSJ15PTnH4gdBLJ3lLBmuIM+tGu9CnBQOKN2K5WWPkOr+bn/pmzQMSnG6d2X4NM2EE31+s8nQUxO9AnCxa4yVqqnrm0AyROpAvxwDuAQwak/SrOMviUrhrYDSQhTyLYqyMBTnYQWIpAOHvpg0U/kLJq+RjRhmuSTzbgs6eiCvbWiM+q6oHHO+Ed0z5ZUbWZSrV/zYZdWhTCzyFA0Ev4ojx909L+3FPZFIpUrc3WoAcJsx94Th6RDOpli12J04RG5/Tyo4w21bsyfobe7YoZa77LAJDTNsZYMKVp3jwBi3Jk0tsDsatfXmqfy0P/lDs7iuTE+BBMly5UkYmQDRxHvh66/14+jplGxHuBjqG3zFBMnXPwupgn9AhBa5dyBm90Mlk2RsmYFEDIcnAlF5akwdSOUl5xDZLW3pU/4rVRm3k74plGCmfbkHp30opGq6Il4yGyI3xrG+2VoAKp5ihxPvMG2etKc3+M3/JXKexPA054BkvbmiRrWH3bggvZjI7zyRyy/7uBAqen0fQRABqvL5LzDJ6acS6SNRanZSW18ycHm31CdAMACVy0hSoiLkY2MVgWkVvmoxDtmwFkq3vEITASWb7tgANNJQ9izYWXhFB1wQNV6e/Sx4bB4ACZ/2h4w3BgHVo36mq5Th+i1Kcwe7BQs997PMfHK9p5mBkkvYi8sNzaZm7fiF1Fwv61CUiKwakfo+5bpoATmgSwR/qBy0ywALu622ngReMQtx1e3hserh2u3s+/Fuz+OSBwbKGKZD66NF51B8HlYTlq63YeKwAotkdL0ymcgdFq9rIqHASHtowCoEWuF3xbQ3mrStQSsOFpMDBKZFRikyzw3kL2W/vCtkJbmnIK1dSZ
 LUfnALeE
 /opBsl0so5p7EifqGxy+P3aC1KGlNG5+EdCqe6eOjdZiV+Nad+sy5Cpgp4um/9KcA9BaDAkqmbmt9NV38twfYtFHMIJ1b6hOxmLDTDMKQ5JVz85l4OhTBEEO/jVYvKZQ9GNjyUIy/enuHPXFiy7H3HZw+Tgrl4b3BNtOw9tF2r8BWYwREwK1cySKSF3UfZsHdgUzghFmpsFuT8xrwqAlJt+Sd7iNwCwsxGBW5sraK5JuHwwtEZeLFpUq8vvVXGwsWyVBPpyBY0xbq5xJSNzlMO+BxuEStNs5RkDA+9IceSvubrDjlETK7B1GYBOgDPhNQvXktZyMB2ETQF+s/f4BbIuqxC9ILiu89OF2adGPoEN+D3+CYaiDRVRKJaVxnb4lOzYTvYqQdPFVic3woKXbM+COFYKP+jInuL7rFaYUJ6KUhWTCoVSzA3tYo4UB3oIOOmVK1VV4tjj8PYJxO+34Zt4eh/FQsab+hi5Sy6I29HcLWgI43atsyb4zFWoIKn01q30atGExdHTrfFa4vDV+5t0sf/UpDr4aR43CNphDdD/qnpL3kNhg1CrHsAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/24/2026 8:43 AM, Barry Song wrote:
> On Thu, Nov 19, 2026 at 9:48 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> [...]
>> -                       /*
>> -                        * Borrow reclaiming=true to place inactive folios in
>> -                        * the older gens.
>> -                        */
>> -                       success = lru_gen_add_folio(lruvec, folio, !active);
>> +                       success = lru_gen_add_folio(lruvec, folio, -1UL, -1UL, !active);
> 
> 
> I'm still struggling to understand what the two `-1UL` arguments mean
> when used together. Could we use meaningful macros to make the code
> easier to read?
> 
> For example:
> 
> #define MIN_SEQ_UNBOUNDED ULONG_MAX
> #define MAX_SEQ_UNBOUNDED ULONG_MAX
> 
> Then the call becomes:
> 
> lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
>                    MAX_SEQ_UNBOUNDED, !active);
> 
> for other places, they are:
> 
> lru_gen_add_folio(lruvec, folio, seq + 1, MAX_SEQ_UNBOUNDED, false);
> 
> lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
> lruvec->lrugen.min_seq[type], false);
> 
Good point, thanks. I'll add the macros in v3, with one change: I'd
like to define MIN_SEQ_UNBOUNDED as 0 instead of ULONG_MAX:

#define MIN_SEQ_UNBOUNDED       0UL
#define MAX_SEQ_UNBOUNDED       ULONG_MAX

Both are then identity bounds. max(seq, 0) and min(seq, ULONG_MAX)
leave seq unchanged, so lru_gen_add_folio() can drop the two
"!= -1UL" checks and cap unconditionally:

	  seq = max(seq, min(min_seq, lrugen->max_seq));
	  seq = min(seq, max_seq);

It also reads more naturally: "no lower bound" is 0, rather than a
lower bound of ULONG_MAX that has to be special-cased.

The callers then become what you listed:

	  lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
				MAX_SEQ_UNBOUNDED, !active);
	  lru_gen_add_folio(lruvec, folio, seq + 1, MAX_SEQ_UNBOUNDED, false);
	  lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
				lruvec->lrugen.min_seq[type], false);

Does that look OK to you?

-- 
Best regards
Ridong


