Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B717CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 03:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47A06B0005; Mon,  8 Jun 2026 23:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0F36B0088; Mon,  8 Jun 2026 23:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898AD6B008A; Mon,  8 Jun 2026 23:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 741B46B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 23:18:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E68F11A03B8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:18:42 +0000 (UTC)
X-FDA: 84858916884.07.11ABB83
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1402040004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:18:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J7Lbo461;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780975121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8MhYUiXWRAVVrdhX1Xj1vk/zHhvhBV8KDCeIyuVj2g=;
	b=kGdzRBXEaGUkP6wzVhSGRbDAtpJCLMr1n8HR7blf+Wukw61GxpzmfFAjrMODbYWAAKBeQn
	1pYyrSXwa2NHSVviaoH/taLZPYA6OLo/5B7ree4bKvZTvnciLtiDhczZD5Donup/K0516w
	Wa9WjdmXzsU2aiCg1bFqOfgRIHQCRrA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J7Lbo461;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780975121;
	b=CSB+6fehO6kckT/d8rl5+9ZProgibF2apj6W27e0c0OfCbTYoGc1e7Bau+LOkMBYeM3Ckn
	zTdQlUAqgLxBRV8dkXNCibTR/mgmCWhK9QtxVjFNICC6D7suTkq1c1zjZf2Z7OiUkgZWbd
	9cd0FP/bCCaAlzGJC+XiBoiJtb6B7O4=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-36bdb11bf8bso2913717a91.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 20:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780975120; x=1781579920; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8MhYUiXWRAVVrdhX1Xj1vk/zHhvhBV8KDCeIyuVj2g=;
        b=J7Lbo461wEZYxAq5hDgC31OGEyrmLAG8q9/01ksETAjS3/rxEVDMEOrFn5/mUGmi05
         n++Nj1uSZfuluGI3PU5I69q3IKjrxuJ0wI0jFtXZMxokUOBo97zVIq376n5knxbpvMJ8
         +sgbWIKP+7CAdnFXEXP2EWCa0OKO1gRbo1/t8T0tufeNlItHLjP8f7CoPTjM71toT11O
         lwMQBkW77+VVgRqP8cThDfFbCPkB4dx5OMdJfa5jj5o//DSNQRw+5LVUhzVuU7gJvNt8
         QWj08vBTBeEfLWS1A46SZ8y2JVOyMog8Y+2nOz+vF0nXHuJBRxoXnxZD48cJO0xE2aPD
         8XZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780975120; x=1781579920;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w8MhYUiXWRAVVrdhX1Xj1vk/zHhvhBV8KDCeIyuVj2g=;
        b=LC166urQeaLeHlJR46Ck+13LaV3sE6sto6jMGjLu9oayQ+zwvhuvvstxdjVD216sP0
         J7e8bj88zR5fuPGMcta03Er5ZOY1GmhJqPHN08SgmquriwUmNME3NANAmeA2hPRVSRd8
         J6ctleNzog03hrolu8gR31AGdBuOTCfJRbO3NqH0XcuFvu9XczzrbfUDfO76pijJvLGw
         H9Sbzk9TLsaGJuw5Jqkc7lS71W7v4RN+7NhwCqb1aLSpwzkCwz8/dTxyZvXvz1doMCCG
         039B9T0TfB+Ba+BKuP3/DO+NuPMprx7JqIQwdSSriZ2uJalxXSAUCW7cLuCO9c1JWD9X
         6npg==
X-Forwarded-Encrypted: i=1; AFNElJ/2ZwhKMsb9GpZGzxLcbuTmlzn6/811gBRBZVGrByahG2RZbsjxLbvkxlA0zK9HbD09sroiidTbnA==@kvack.org
X-Gm-Message-State: AOJu0YxMbFfNdfmpL/hxk40FiJ0VPDdLOpHZrHm67m4UfgzQXeRa4uGK
	IL85Eca+1unDVZ7djA4aGp/x8ZFPR/j5Sxql7kyrGRXSN0dLRUovMSic
X-Gm-Gg: Acq92OHOl+CIzSPk2R1WFMBlypkDjV17XFf/wpy3rQpZJsvB64VGiz4ake8m7yBSZo2
	jwzvSouOuU8QRUFjVJlUf0AtgxKpAz09kqouLAN2EWmJC6v9rKUXCYBCSCbadGmfpmZF0XxldFy
	qmdU1icsr4swIrNOnHzTyhyF3Uh2ZfCXDfyTiLDEe+ZFoZH+VMn4f+t22vwKbjb7qJWFTv/2Bas
	hAqrrP2hRzHrV98UnTl4Q21wUV9Xph6yKqWCidB76qLsjRVrLJij4+rb6znGL/3y1a3Qp7/6OOl
	B8RWEjPW8V7lIwNTD4cZfiLRGTEcqNYwhc7uQRhrX5QUCKMkUCwuKFIAegVHv0q9jRryWFrQNbd
	f73JHBroFUrNaUBwVx+51/vsxdeiJv3S28BUPMafXRXnD06f07/FcrrHfCrpugQvh41xDlRwM+3
	d5e6GOIAfLGSJ7LI5rdmeJUtxr+Aew5fMPa8TKSZyIK69+vjX8trLaSw==
X-Received: by 2002:a17:90b:1809:b0:368:6998:b49d with SMTP id 98e67ed59e1d1-370eeff6b37mr20150357a91.10.1780975119848;
        Mon, 08 Jun 2026 20:18:39 -0700 (PDT)
Received: from [10.125.192.72] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f8bc5asm204871655ad.27.2026.06.08.20.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 20:18:39 -0700 (PDT)
Message-ID: <1c25650e-bf98-2863-d505-9b94c385668b@gmail.com>
Date: Tue, 9 Jun 2026 11:18:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
 shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev,
 muchun.song@linux.dev, roman.gushchin@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
 <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com>
 <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
 <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
 <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com>
 <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
 <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
 <CAKEwX=MCFbsh9ndBtR0-bGRr_=v-6bBwTo=muzd9ZSD-LAK1nQ@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=MCFbsh9ndBtR0-bGRr_=v-6bBwTo=muzd9ZSD-LAK1nQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: k7m6tz6hpazshbbzqpxigmkecbjz8qmq
X-Rspamd-Queue-Id: 1402040004
X-HE-Tag: 1780975120-59009
X-HE-Meta: U2FsdGVkX18qiLIyOh/v5wqthRT2A5UyUQhqgL6KarrQw53a55Ozznv+j9unSjhnlocJ4l6xk+uhUio4XF0NOnLzR7Al89coeMo0NG6WXE0UiKB9k1xkI2QWvyjxofAoIoHsqoYShiJ62Owpkb27T0diDlr+FG9zcEHPKeVLlnYKkIkkNGDsAruFoNOjPNwMbb0OFu9f4+lTidH68FNj74iJvSPUo859GYLdB1ihm3vmayHH8sPtDDE2SqrP8yC0xwm9Bo/HtYPDHxtni93pNiuYEQ1bTrA/uTR8D5KCqbzxS4yl1r+ogvLqL9fFZW4nTS/R4FBRbjvnK9G6SOqL16kcJVgMabE3WaNnFrJIEzU+EyMH+wdMVSJdSXyf2TkC+HinYZRmoe+CNFYKo07Y4dSoUJ04EWST4TOJ+FwP9zFR1kdgBQP9Hq6E7MTv8mAavrP/Ep5ds8wx4UPFnOunWPyPEZnn9m1gK29i9ZCkUNueZfaa2EnoKWVI7stsYp627proKU2uIpi4F9LvkAJfqkr6TILEtYoiQ4Qr8vXsA9mdNvqw/Dxybj5t2WJMOCqgUClhk6TMbyRp5x9aiTClothO47cXnIAGqbz8v7m9YqR75Mxl/nIqPfKKQY9mMAsvqm516iSyCJx+7XLKwc9IzptWBQfFJiZ98Wt6FN6w990p5+KcjkyoqNwvWXF2e8dEBLeEzcWOqZnftLvT8oFkRntYLIZ6JlOnWpNg9Zgd6grid0fOrZ5/kRMvfgeDgiAgUnT2wEcY2zn+Ith1mjgOjUbB0Lg+5s8jAExXM4LZ6PANaPbiI4NpSUU6y/k4uO4rnENlcN2XxNxZ3emtzKIurNRlBJnYvz0L3VpkS/n3unjQxCwl5F08BbcXTMM4in/eIHIPgcfOWyuG7//5Z6LpNKUZhUNlftxhritOWlYQecV4+UF0pzOxqPTiAcHnbjbScMcY78UBknWzqduJHMl
 YI6y6qCc
 0J3YivzHHVod2qJa4vnjwTBtF9afshtKss6SWwHE9KXsJweOj4YQYd5ol1VoAxwSmIahCPpXp77q0RhwRTdde5KjrX5Hr0YIUHnj4kYPSSRo1GbLF3oOUNMmhoxLvhqJtHYCIFk7hiUpMbanHDC7Kggan3Ey0ZI0mab5ArV8V0H37mHl/ERTamp7vJViyHhZ3rbA9FC/Bn4dVrJsxmD5BaRTmmXj0qV2ZRzkeE2Cdbg1i5rnA43vlNCg/1IQz4Q6UgTzdn/zC3ld175mM8xMZp8IOp76s/4cJmldc+Lu40hSs2/Me+8Os9U9GbIFmk66h4sEBrtXyTuKY6vBVi0ZlmL2u2tZ1f4+HJFYavN1nj/uh70YfK8pbbODXbMRA0yzGBUmCZk75eWGqee3Z3CkBMIk0453cBmaKHW6tF7Gyg4b3ziAXZFjUBexB6ZMCoibEaRjxl/+Ex8JjTpKECVqnWCwSpCUgBUXyCxq3fcz5q6OBFgCKvJn+vgvW8imaoLw3m/CvHntMCB7iSANdyVBP7a/AeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 02:01, Nhat Pham wrote:
> On Mon, Jun 8, 2026 at 9:48 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>
>>> But OTOH, this does seem like a recipe for inefficient reclaim. We
>>> might exhaust hotter memory of a cgroup while sparing colder memory of
>>> another cgroup... But maybe if they're all cold anyway, then who
>>> cares, and eventually you'll get to the cold stuff of other child?
>>
>> Forgot to respond to this part, the unfairness is limited to the batch
>> size per-invocation, so it should be fine as long as you don't divide
>> the amount over 100 iterations for some reason. Also yes, all memory
>> in zswap is cold, the relative coldness is not that important (e.g.
>> compared to relative coldness during reclaim).
> 
> Ok then yeah, I think we should shelve per-memcg cursor for the next
> version. Down the line, if we have more data that unfairness is an
> issue, we can always fix it. One step at a time :)

Thanks a lot to Yosry, Nhat, and Shakeel for the great suggestions!

Let me summarize what I plan to do in the next version to make sure we 
are on the same page:

  - Drop the per-memcg cursor and keep the root cgroup cursor 
(zswap_next_shrink) logic intact.
  - Stick to using the zswap_writeback_only key, and change the 
proactive writeback size to use the compressed size.
  - Consolidate and reuse the logic between shrink_worker() and 
shrink_memcg(). Enable batch writeback in the shrink_worker() path, 
while keeping the writeback behavior in the zswap_store() path unchanged.

Please let me know if I missed or misunderstood anything. Thanks again 
for clearing things up!

Thanks，
Hao

