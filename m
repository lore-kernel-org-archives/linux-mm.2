Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE8C4C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFFA96B0088; Thu,  6 Aug 2026 09:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6FD6B0092; Thu,  6 Aug 2026 09:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8256B0093; Thu,  6 Aug 2026 09:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA9ED6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:52:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52BF01206B5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:52:02 +0000 (UTC)
X-FDA: 85070983284.21.76E122A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8BE7112000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:52:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iuaa2ASF;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786024320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtOtoJPfPoNQ3lP/qAbd+1hDTx3C/med8KgZHUjbjqU=;
	b=n7rg6nelRyQUoKJrn4713F0jOEyAvGf3s4rRaz6+64ZMjklIvPDA8UKKEjIwiyWKIY7yfh
	DSOnxgzJUc+HpSJgRlqhoiXUEbu0Sgm5tb/EPOz3WXypztmdu7ag/skFXrKNWpFJamnvzj
	/k2sDhYEctvkUfOKNlVO40xeOJX7lvY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iuaa2ASF;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786024320;
	b=WU+vaDeqVA+zrpBgC+w+3WcYT+29Ne52bqRmAooqaVTzdHoUu6gsR4QYU4PqX8yA8Upv5V
	8L/NC70yp7vV5IAfn6I64bcVsydHNZmZrwEMihsFo9l+ryDo2D8PCSqRj5Tgez6oqU69/F
	7Y0YrOPm5dDoje3ZyGG0WOOh3jXh1ko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4C1460A69;
	Thu,  6 Aug 2026 13:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36F51F000E9;
	Thu,  6 Aug 2026 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024319;
	bh=mtOtoJPfPoNQ3lP/qAbd+1hDTx3C/med8KgZHUjbjqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Iuaa2ASFYi8g49KLLXEzA+HefzGQsNEMIPsfpsoiouhzmRqgPB/QEBTXx9j312Y2E
	 WckvlwtBI8SsH47XbWgM/D8zHxJZkBSYaGfjM7A46Hs3r70KUv3YlUJveZXw/Y10Hv
	 xbGjFz/1sm543DrckGD9DHLiFnfZK6ch67XWAwKN1CWZrQoZ6ke4RKT/66f9bzpQD5
	 9d8xXsynjcE0ruWoytE+WdKpGJmFjFrnoT0jjTKAz7IJABW+hKL5bLL49HWkr2hk42
	 +g2/rNL6m41kLbrV2tkNeklAINFjBn/ju/xLaQDdCM7yYFDFRycGvTwV5Uyo/jkmal
	 Pz0io5oi4CfNw==
Message-ID: <1150896f-de20-4672-b498-6c9dd17e4aca@kernel.org>
Date: Thu, 6 Aug 2026 15:51:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 1/4] mm: add page_counter_margin()
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, baolin.wang@linux.alibaba.com, hughd@google.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-2-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730122304.2496440-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BE7112000C
X-Stat-Signature: k1qxgb9quwpjatjudmy3byozcy3mwtj7
X-HE-Tag: 1786024320-24695
X-HE-Meta: U2FsdGVkX18Z3oaoJWPPDQhvvfUs9gHuvbwSctI/BB4BpTInV8InXKMBr8n8G5Ccyh9KzqXa4rrrgdG21hbNQp8RnfVfYC77VdkDWBMtugTA9k6StMnLcULrYkiz4lnGCkfapgy68Y7WDdbSm1eamlhROkfXeUcSux3DjWHK8RSQNDK9O31Pshpl+7Z+EfUhJZwPOzS6wds0MpRrSRvWGwy9+TTdtVrJMjxWlFMA6sNJ8o6YUjShusrn1JpYp0Ionzoxgnorbf7WLUMgdXKY5XfyL+v0akUokBlY+8uw00cG8+4PQhcgAT3irgY2v3Rn9DVUX9bzin3xwXP6GUGHqid/Nc3i3q93dB7vaa/dFjc2HO/grU8BQRg/++Ub3csIWwx2VIaiMNppxI0+vqcCHPMzVlWbtgY4N+8/E90FxZ7tzFNla1Il30khBvXOgSLt6R5mV82drjHsnfuvRlw6eRGLK2XZOobp39VoC9YLMKBBcHTTJ3Lirm3j5D8yoUABotMVf4HiCyDeQvanCzz+DIs94rosnzdDReDwFKAG0whkYZTnFuMxBbeS/SO8+WgjjfyV9WdwOhJ5Qfe29w/KnSyiOmDy6IZnrb8cDpovMwXZ0Es3FdwqFfOi/04Xs7si3BYTvRw/DHt31Y9wKQaNTExWgwvqoEuNa+Lg7C+5W2l5lTtfo3NNJH08csiwGSapysd+GvpEh4q/Z3Bmq0uPUhDt9CCTZK53XzZzoUlzBnnK0hE+F4Ef6pb9Qdpcu5a53LTGNs2S5FWv/mjkxshdbU1fqMqXBTgaQaEH4UuF6nw7f+RX6mQkZgUh3rPtI5X9D7YK9lE9z+kkyBcDQLyJiVvovMmXoNCHzTKH8RzqAVsmgoO61QMlWV7nHoJeAJBEjV0IFnejxuvIhAZYzOafuK6WYWfuavGfEZaVYKb9CR3mnAAtGAqh71MrfiI1r/2zcl/aD6etDf+3+8TxZmv
 peNy1IZ7
 PlOVMfKXINACBe6upvN3Xdze+IpxG3DmcXLBO3GZU2tUu0r33ikxkUlbsJTYV2cmzlSbgDeeVkzmqdyLviDNvrtFlu8//ZbVBqXPWpqukZrlB6jUnDffKMd2nKpHfyqVsqJTeVb0MLrL1Cnx9Nby1UDbsBvpoPOfaN+S/JWeT32vFAxI/qRLzr6P8YVu+Spj0BbH0UQKr2r3jU9kYFAOtwsDrVhvwS03wgrjXEmme7YNuNlEAOoyzdV9YzuJRFDJ8qGy/smeJL1Jk6g4OyUR4fn0xbV1bE78wK8xXhgX2iAb63lw2pNM9TV4x/n3rO+xafncOomI0ioiwSsMq7BScAF/nuSXHbQKb3eipCjgChlwAaHJUgmuOdKddm4ZLGVwHb2uylQ572IvVNCuu7jjObwgXzHnWc22G7Kk5MHIbiscQkLcuv2lUuCBS6+3u7GHZfU7S8hE+Fxkur2rJcH3d0/KXQIHa8ccmRijHLp1RqpeN8nI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 14:23, Xueyuan Chen wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> mem_cgroup_get_nr_swap_pages() open-codes the remaining capacity across
> the memcg swap counter hierarchy.
> 
> Add page_counter_margin() to return the minimum usable space from a page
> counter to the root, and use it in mem_cgroup_get_nr_swap_pages(). This
> is a pure refactoring with no intended behavior change.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

