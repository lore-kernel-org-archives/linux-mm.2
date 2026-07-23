Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C667C44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE686B00A6; Wed, 22 Jul 2026 22:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E666B00A7; Wed, 22 Jul 2026 22:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB45C6B00A9; Wed, 22 Jul 2026 22:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A33756B00A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:00:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08675A038B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:00:26 +0000 (UTC)
X-FDA: 85018386852.22.557991F
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED9731C000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:00:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1upDwdl;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784772024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtZKpBojyVkCJ2vB47fWFj5D6zB1GFGL23zh19aZDtI=;
	b=SE2tNx+R6iw/HNtNlbiX+wAPX3eZGVhrTJGDr8IWAsxoVMooCEqwSqkTSPX6wP8mCFNOCj
	KsZpuJHXJfZsZ3hBy1EHsCPyAmiXqddPsWDJAiNqmPedgyFZx1cZZY5BRzI+4jU+cv/RLg
	luhZd/PQz3jTgWlZxeWlf61U7Xxi/e4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784772024;
	b=Hwtk0fAvKwsJnDSy8/SMEsxPwry8tfekRNoLFbxYoK5PL8fPDIb8iM0LZCD5wjrOtJwAaA
	B3KW9VxEdOnXWqRDQQjqTMVbmlnBrBFdsoCusXPmY7qKCtopbqXWiVAo0shnmf7Y0ct+gD
	fQ5+IweeFdPQBjvy7jmTb18uKXWu9UQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1upDwdl;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <52f41904-d6fb-46b9-9e89-296cda0a988b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784772021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RtZKpBojyVkCJ2vB47fWFj5D6zB1GFGL23zh19aZDtI=;
	b=q1upDwdl6/ue9tdjrtLUVw1GKKwC4/LsLsDDk6KE1XA8HH6XMP/OzA9p3xxQCCjCwNM16b
	YPHcz9dPzMvOGxemOyQ1W3O3bs330krkWM9lVB+G8w7zRGxz2ZqiExz6GFuTIzNVRZZppM
	qS+5PQwg0tNCQP/7l2YQWcK8J7LakqE=
Date: Thu, 23 Jul 2026 09:59:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 ljs@kernel.org, kasong@tencent.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hezhongkun.hzk@bytedance.com,
 muchun.song@linux.dev, dave@stgolabs.net, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
 <20260718095251.82937-2-ridong.chen@linux.dev>
 <CAGsJ_4yYEaoiTY0vFtqJK5fsXZW2PTkMu-qZ=X7=cqmMVa3YCg@mail.gmail.com>
 <bcace78f-987f-4908-9e65-bf0b9a52855c@linux.dev>
 <CAGsJ_4wbLAky6B9gPGmyLkZPaqrbC4eSMXXK1n4bLfnzs5+-sQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wbLAky6B9gPGmyLkZPaqrbC4eSMXXK1n4bLfnzs5+-sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED9731C000A
X-Stat-Signature: b4wh87n5zmyyq83z35ak3e45occxonqh
X-Rspam-User: 
X-HE-Tag: 1784772023-549763
X-HE-Meta: U2FsdGVkX1/c/8rZ4tJ8Gdev7t9EZdsSTgcEn/fY0FGYancq+FmzBpf0+Q/H9/cKLOI20YpgEnY5bYjWblEsNGdiDw3l/slLfujCCguXKLuLI77Rs0AxMmlPFfHnLumWW9QpUG3zvVpGipXH8HRhf/mV1NVviPYN6tDOA0iKv87A9N+WcEeDTtoPp53N46h6fKQN0HVKmHxWitx08BXI7ksj6injPLuJvevWwcgWgbwca036NJE1Gy4D0MzxSomzQCCbHRAgYBD1IB9ZL7+SxChdhlLB9EChGwV731shvUwXYwsy2FtGp24Ne4Xk5iENwLLDF5d/iciYBvhtzv7qd2GZnc+5tGoHcJEUmUdB675LG4pJCn/HVYH7BW4BUGux8Z1FJX/DxhEB7j7OY/tFm84H4ZP6+oSO9Ybb7Q7fcsxkOsFbjvm3QTjkhOa2HnRrfhCIHsgD80mueLbgYcLoNGxT42PrzU6udnLnD1zNuLL95QJJvjjpRAkoIyKLLROKhvSdC3aF7kXazdzezEZzScStXR7JF1jqIqA9sFZVChT9z5jP0SalkbCf5KJShRAZVDy36MdoatAomeVndiNAQlpxUPklp1XLtFQ7WHf7IQBIfmhn8fKLkZMGt3uMAn2BsW2AttmOgGfa3IfX8F/fhtpyYEeyIQyG6f4bm5jG9PfLcJxdQrp4gCJJnIpMIot6GwZSqxZPdnf8a/Y6vsgSpHi/zgXNpaBET91bbwhp3cUvLCQLjPNxhuKvlE8ZHuYfvwbcS5oZg4XGb8dN3HhNomujmBn0X9etVzY1LYFdAwCshYtvxgYM1yECv7+Hp7FYP2kt+dq2uCy+5qgABv8STXbIVOSR7U0EFHw0+VT/S4CX6hYDsg6P+OJyKfxYS8EVmagvMCKr3J7iDmJ1ZXQjlOn4PSiV9KC5QpEHFj0N6Mkd0Up/FvxPEOy8WSwSPHKig0/kXt0Ak+yLmdOov4H
 89+XgdGa
 Q8umdM9T0bBg1VrGFzwpPNAXL+2wnvv5QrKDWu/25Qp61jDZQBiqM5GYcamHStRSCacu4Qo25T1wfjy/nEZlRVGngzL8VgT0GQb/ESI2bkTJfd6FBpyccWW8jCnJvf0+7YK3MV1xJbDeVrLsxy7w3UcV0UxqSo/+LN52Z3uh0CAf+rR8snSozTCWP6xVzG4rEmBTw7+lgCF4Vof230zXJdyIaCubCKcD1okJJCqrzJODKtM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/21/2026 3:45 PM, Barry Song wrote:
> On Mon, Jul 20, 2026 at 12:43 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> [...]
> 
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -2501,6 +2501,17 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>>>>           enum scan_balance scan_balance;
>>>>           enum lru_list lru;
>>>>
>>>> +       /* Proactive reclaim initiated by userspace for anonymous memory only */
>>>> +       if (swappiness == SWAPPINESS_ANON_ONLY) {
>>>> +               WARN_ON_ONCE(!sc->proactive);
>>>
>>> I feel it's a bit odd that the WARN_ON_ONCE() is placed here. Maybe
>>> adding a short comment would make the intent clearer. For example:
>>> "SWAPPINESS_ANON_ONLY is only allowed for proactive reclaim."
>>
>> Hi Barry,
>>
>> I didn't change the original logic in this patch. I agree that adding a
>> comment would help clarify the intent.
>>
>> I'll include that in the next version.
>>
>>> I'm not sure whether it would be better to issue this warning earlier,
>>> for example in try_to_free_mem_cgroup_pages(). That said, I don't
>>> feel strongly about this.
>>
>> Since patch 4 will address the MGLRU issue and could also include this
>> warning, I think that triggering the warning earlier makes sense and
>> would be more general. Would it be acceptable to add a separate patch
>> (e.g., patch 5) for moving the warning? That way, each patch stays
>> focused on a single logical change.
> 
> I'm not quite sure where the best place would be to move it earlier. We
> already have two places that perform proactive reclaim:
> try_to_free_mem_cgroup_pages() and __node_reclaim(). There are also
> other reclaim paths that are not proactive. Since they all eventually call
> shrink_node(), would it make more sense to handle it there?
> 
> If we can't find a suitable common path, I guess simply adding some comments
> to the current patches would be good enough.
> 
Eh, shrink_node handles MGLRU global reclaim via a special branch, so we'd have 
to add the warning at the beginning of shrink_node, but that feels a bit 
jarring. Let's just go with adding some comments instead.

-- 
Best regards
Ridong


