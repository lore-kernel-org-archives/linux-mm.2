Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69108FCD0A1
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 03:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB5E6B00DC; Tue, 17 Mar 2026 23:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C526B00DD; Tue, 17 Mar 2026 23:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792166B00DE; Tue, 17 Mar 2026 23:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A19E6B00DC
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:41:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99D9F1C328
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:41:51 +0000 (UTC)
X-FDA: 84557784822.15.807542E
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2B41C0003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:41:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bTqwJPaz;
	spf=pass (imf22.hostedemail.com: domain of lenohou@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773805309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMRQlUwh7SoN2vG3dg8bnvwroHZhAIcNOCrjAUVtcpI=;
	b=s2bG2fHSMF0qpBJZcDuYTUErsjWrYcMDcfUXA/ykc9/3epJNQYvF5YPz0HloepZSeCjCkd
	k/E/jgDSy0NrSDN9ahSKhhUOt0H0aVhp4ehDiV05ER6cemcIMd+2dQdMiiEq9KNd3AMfQB
	sPIzIjIcdYSuBtH7gyd6Xyoh0ShGtlQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bTqwJPaz;
	spf=pass (imf22.hostedemail.com: domain of lenohou@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773805309; a=rsa-sha256;
	cv=none;
	b=hiUO9EuR4WeC/Nv2s86/3zgBC778Zt0C0tIbv2+3XJrzQLyC36yQwH6GEXKOUC/bzDKIu9
	lkoIX0Y+TZ5CtMpshB1PPUth1aFPsfz2rzZPujK72ht9fBnEaYug18GYTcMM5Cqje1F0EP
	+TdcWkH8iqfQJ8vcUBznLffcftIOxDE=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2aecefc7503so31059135ad.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773805308; x=1774410108; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vMRQlUwh7SoN2vG3dg8bnvwroHZhAIcNOCrjAUVtcpI=;
        b=bTqwJPazrk9EZBFdyTNCVvKgqjc30Dbke9MEzEvWUNEGN7MCuRHHz0pIazpM2f9hoL
         J70WEQQhSqxlCwFVsr7cK6GCJCPyn3BRwfVz6HzqdwSReubcVu7jSb845s6s1IdXGUer
         /LsGfT5UDaTbJQ6xiCeKfSRkTg6AvF+hShXmVAiKciT0GV19XLO1WK2SP9sbLbnr+zA+
         JCpMFtkqUM6Bk71OAWWSfImWpbqbW7y576x2Xo5D5Mtpijrlcwxap5CX2uo9BD73jdq1
         yvm/vRb23tymVg1J3Pb1O3+OXXCKykdrbeKgzIp1xcOt+rvX5agdWn+0DDddBljVTjOC
         Jttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773805308; x=1774410108;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMRQlUwh7SoN2vG3dg8bnvwroHZhAIcNOCrjAUVtcpI=;
        b=dPVUtH1WFtDEj98XOFu6zeZjBghUdsmXLufyz725Oi++Iw917TuaIyQsx7+1YpcyuT
         sGguClDZxCccDf3iisKR+APUy9XUPK5iDUwbSuFr+QHuXzcPPlu/KdvoCH50D4nYBnDL
         zXv0CDel48Y+5G01viZjMJGDJ8VMnw4IZK4yYZ6P2XF6OTYc5eK5Jkb11Dg5HI9doD8E
         lck5GrNPdk7mXNeiDUM9yk9/RP0dI8dFD5fCHbgTba3oHNHcnPhHkiMnr8Y49EUbAkOz
         lziNInCfWVEnlRAy6qw8vJDKFrV0oaYYkHI4tbhnMIVBpoMY45FR+KuhhBs1LedeLI8D
         Snrw==
X-Forwarded-Encrypted: i=1; AJvYcCVOBUDenDQmtljLsPZScho5HXTiFaWv3RZ2EM4IS1DZj+5xnqG7tO4V+1YqeqqZ0jloG9ZBDZ4Zrw==@kvack.org
X-Gm-Message-State: AOJu0YxyyjSloY9/7OGnO23gHEBShH8r2gx3bdMowmUYHEa7TtU9HW02
	WRVyIRKnhEjcEIQBrBnJR9a4WELnMWH7puUYxDb3rAhcCA7YeZmYrId6
X-Gm-Gg: ATEYQzxmElhJtGTplYXhL3GmTEh3Rh5qwAHGW3fPY2OEHMkzatV7vJwTX8N1t6FO9Mu
	uKaopd6I1csOJVECbUXADfGt8OMoKjBiuSNXIq/suh1xB/efzLTyndPWBzrDDLjDbRixuVSlB4T
	5UXKIj3AfiJOump+Ac+7LmZCFjIJPyOBlp3fD/uUpS7jhbW8K0UAPmb9xyjd7QY9f92gWuLIWLA
	uC8gXQdHtTw6SgniHXDHHuyUUfkCLev7orZWJq/a2KsbxfJxcZZJyA4ywYwJynutWMUirllbT05
	a8AZ1chNEQVB/xtfusLRKz/NXqPGJmUJeWN1sAA6Mo/SGsUTQuzocZSjbzEOhJb1mJqjh7LVgh7
	XA94oO1InQxUC71NdJW8uSEIS0rfraWeBFJcLQJAM4xjaD+hv9CtHAKwod0f6hu2u5yTjpxdZ5W
	1rWq5XRmnqqctpXlCEQEdiHzo+jaBeS2ldpxgK40ignD9kUhNBtoQSNj+MnhDoc/E1Z9UN2StcX
	rUyzH5vd9UtKUVPfn3Rsm434QaC86YVU6E4ZedkrvyCZPTD9Wa8PcZIiw==
X-Received: by 2002:a17:902:e5d2:b0:2ae:5629:ac55 with SMTP id d9443c01a7336-2b06e385ab9mr17099755ad.21.1773805308125;
        Tue, 17 Mar 2026 20:41:48 -0700 (PDT)
Received: from ?IPV6:2408:84e2:440:5e9c:c1cd:90c:afa8:9d55? ([2408:84e2:440:5e9c:c1cd:90c:afa8:9d55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e454a8fsm9978305ad.37.2026.03.17.20.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 20:41:47 -0700 (PDT)
Message-ID: <a02ce4c3-c443-4165-9dc3-3ad4d9816dfa@gmail.com>
Date: Wed, 18 Mar 2026 11:41:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/mglru: maintain workingset refault context
 across state transitions
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jialing Wang <wjl.linux@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Bingfang Guo <bfguo@icloud.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321@gmail.com>
 <20260316-b4-switch-mglru-v2-v3-2-c846ce9a2321@gmail.com>
 <CAMgjq7ACdzXbte3ESz4MDAnBExop_zFvCi4PXwQXRPD8dvnmtQ@mail.gmail.com>
Content-Language: en-US
From: Leno Hou <lenohou@gmail.com>
In-Reply-To: <CAMgjq7ACdzXbte3ESz4MDAnBExop_zFvCi4PXwQXRPD8dvnmtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D2B41C0003
X-Stat-Signature: 91i1zrftj16gi3195chq9zs4ictmf8a5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773805309-116851
X-HE-Meta: U2FsdGVkX19OJWxds8FZ5ulVE8yA8Z0JvY4X+FFfnOZ9JkeTQVi3X+/2IwzTp8VHOOzcFXiEWIvBUJpD2M8QD8wu3cjy+q5ic7RzVqlCwnJj675bBGA2IQxT+1EFVUESH/vggwLedmSeyZcA+rYYbbt3PxbDtw7dnkWRfQnxM/+fB/XU7f0nrkOG+GFfbeUkyJV+sf4lBeFwa+AskKqFqhSI0X11Icx6s7rsAnL/FnHGmrmAT7PMHdUyVl9J9FeZ/JsOoipR6gJYZ8ZfmtqLmciXDA3M9pCaHxLRaop3SHorWQfnTQfceqobq7P/G+Ns985Tzg0cRzN1nqftIUNZZcOguJMIkOi2wWtxiS2JcGXCZ4Lmr1dDDZAIY0rUxa6wPa1u8EeycEQftQ4E8jQJwd6R2h/v1QOQQNrF4FHnpX69u9mKe1Na+GhJBKQvltZulGSkGKkyalIYhK9dFS+30WJqyalLaiOhgl+gUzeBQilHCz1tLwmr7joOJ2UMS+yKfAmwcYKHq4SUwbRugiyDbJc0kyR2G7ZXodAWgvSnrbj+L+QIk5o9ZjqJwFOaWVMV15SVYQmoNwsx2BgPTtl4FA0JxQ/WWmb56gyUESX2F+iyDF2QT94mcU9iEyv1hN9Vg58gogwgehP/IZIO6kDk5dkQtj7p5LJBdmlC0QcqCj+ENdsrj20XySt1k81YfPycc2YzIFnsauVca92i+R2fTmmjWMyi+7JKwR8Z0wsQqrpyMV00tTyfQ43a4oEajYNGzxyOfNYknSzfVTcseaGpxlt8QJp+K4jVslxwjETPEAbWJiE4wuMh2RRwYpC85vklciwiPopJ+bWrdYafScT1Ig7wiebA4lUrirLZ6C5g4/1jGDMABzGMMUgq1gIpDeqvQUe0pVHC56RtcdR8RwHoL+XxoLfu7SSNcJQOKnUOvs+RBcadOpSecLNW0klqvQiIYOeMrPAtXi+dSwuGMxO
 VPmeKjxc
 MDplauu/bscmN8zT1QBO4V2VqmlD8576ktLi/CF31AXXpPfPNw2/PhQB0MTkN3IjwNSNzBqX6FclQNB5pQtA4CurZuQGTYjCozLj1JlNWf/OkXscTgvEmZMy1oNgIZdu4+hKp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 11:30 AM, Kairui Song wrote:
> On Mon, Mar 16, 2026 at 1:56 PM Leno Hou via B4 Relay
> <devnull+lenohou.gmail.com@kernel.org> wrote:
>>
>> From: Leno Hou <lenohou@gmail.com>
>>
>> When MGLRU state is toggled dynamically, existing shadow entries (eviction
>> tokens) lose their context. Traditional LRU and MGLRU handle workingset
>> refaults using different logic. Without context, shadow entries
>> re-activated by the "wrong" reclaim logic trigger excessive page
>> activations (pgactivate) and system thrashing, as the kernel cannot
>> correctly distinguish if a refaulted page was originally managed by
>> MGLRU or the traditional LRU.
>>
>> This patch introduces shadow entry context tracking:
>>
>> - Encode MGLRU origin: Introduce WORKINGSET_MGLRU_SHIFT into the shadow
>>    entry (eviction token) encoding. This adds an 'is_mglru' bit to shadow
>>    entries, allowing the kernel to correctly identify the originating
>>    reclaim logic for a page even after the global MGLRU state has been
>>    toggled.
> 
> Hi Leno,
> 
> I really don't think it's a good idea to waste one bit there just for
> the transition state which is rarely used. And if you switched between
> MGLRU / non-MGLRU then the refault distance check is already kind of
> meaning less unless we unify their logic of reactivation.
> 
> BTW I tried that sometime ago: https://lwn.net/Articles/945266/
> 
>>
>> - Refault logic dispatch: Use this 'is_mglru' bit in workingset_refault()
>>    and workingset_test_recent() to dispatch refault events to the correct
>>    handler (lru_gen_refault vs. traditional workingset refault).
> 
> Hmm, restoring the folio ref count in MGLRU is not the same thing as
> reactivation or restoring the workingset flag in non-MGLRU case, and
> not really comparable. Not sure this will be helpful.
> 
> Maybe for now we just igore this part, shadow is just a hint after
> all, switch the LRU at runtime is already a huge performance impact
> factor and not recommend, that the shadow part is trivial compared to
> that.

Hi Kairui,


Thank you for the insightful feedback. I completely agree with your 
assessment: the workingset refault context is indeed just a hint, and 
trying to align or convert these tokens between MGLRU and non-MGLRU 
states is overly complex and likely unnecessary, especially given that 
runtime switching is an extreme and infrequent operation.

I have decided to take your advice and completely remove the patches 
related to workingset refault context tracking and folio_lru_gen state 
checking.

My revised patch will focus solely on the lru_drain_core state machine, 
which is the minimal and robust approach to address the primary issue: 
preventing cgroup OOMs caused by the race condition during state 
transitions. This should significantly reduce the complexity and risk of 
the patch series.

I've sent a simplified v4 patch series that focuses strictly on the 
lru_drain_core logic, removing all the disputed context-tracking code.
And this patch was tested on latest 7.0.0-rc1 with 1000 iterations
toggle on/off and no OOM.


Thank you for helping me sharpen the focus of this fix.


Best regards,
Leno Hou



