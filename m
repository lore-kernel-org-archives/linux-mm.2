Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D104BD4A616
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C396B0088; Fri, 16 Jan 2026 04:21:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9CA6B0089; Fri, 16 Jan 2026 04:21:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B3D6B008A; Fri, 16 Jan 2026 04:21:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0957B6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:21:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F7B713B40B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:21:20 +0000 (UTC)
X-FDA: 84337283520.29.8BB498E
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 150C8A0007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:21:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EQvt5dKU;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768555278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUd3/WmA+J5BNqqwVB9Fpj2XCO58RHNi4/wu2oPQXwE=;
	b=YmSUbF5fiBlfvVh2g+7txqlYF6Ta+2MC2xK6vb+yNZl+T9Bshiq1IUuC9UYsGGKnaj+ixT
	nWa6rCHbibbLUHRISbKmBL5ao2NlOislN8hsE61O3JDDcp0bTIq6q9Ai+Ww5BmJaacBzVm
	A18kk9uEzylv7KcwLtPlfg2+9G82mIc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EQvt5dKU;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768555278; a=rsa-sha256;
	cv=none;
	b=SOFG3ZYDRKuKyNdNN9WTy8/SLGr/HS9948MtwrDUAOySQOg2yEkFEe2DiLiyF2xOR/ZXbO
	L/1O4QeaY1HmCNGd8U/UCXnGlXyDocANwM24Y9VKCe/YegkLoOvyiJz6fh/VHv1zmhWCat
	IYjm+yjNBE9G2Wc3t4kSsQUjnO5/xFU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768555275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CUd3/WmA+J5BNqqwVB9Fpj2XCO58RHNi4/wu2oPQXwE=;
	b=EQvt5dKUNhmjcAClSgNl2oSdYNzQw3bV5H6zQYo4/3MMJncvtIIxUJ30Z7b4DKnHrjlV9d
	chYH/jrA7vpANEpjHgFEb8PvM5NbPFCr8w1xDumij3rF/aninUxbLe+jU1qpvhC6S2BH7m
	n4Iby+e6+RKZ+CGpLeTECxPeN+DbLLM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v3 23/30] mm: do not open-code lruvec lock
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
Date: Fri, 16 Jan 2026 17:20:14 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <038534F8-F695-4660-A18A-875214C3FE8B@linux.dev>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 59qy8i6ugiod5ofeh15956oepcwmxgzh
X-Rspam-User: 
X-Rspamd-Queue-Id: 150C8A0007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768555276-595167
X-HE-Meta: U2FsdGVkX1/vll4I0zW2MaIkRH0RLH8AJGT9fGv8524FMjrOjQv9KpXD73dYzGZbiMpUbSXV/WoTDlGQhpRiqdtdU2ZeBP8NRk7BPcqSqcig107vsg8i7/P2IR2JVn+ko0cbMwDwwNTTtPoQwUspFnxPKVHE62cgNU+A8WYpDxeZ05QgjjCgJaxPG90+c6hkFRi9bx9MbT5gePuIsS6w6hrUA55vkH/l5cS0puR8O9cAHan6SxLFhREeYI8iwkAI4ThvOhDEhbQsHImJpBX5jVVmHOODpvBhK+c460DuStKmTv5sP4S6mpWqX+Kb03m5bMeVE36i31hiV2vTi/z7xBKeVc4VPP/1BICMDvcspAFlqn72hRDAYBkyZ7FXwordSQq7gpDAkgLFmRaAiVHZeiIao2tKyb9kfMa+qgMUpCA3mvBhyLruT5WjL+MZmqLSaFiVikVyn/vm5YGN/4jJUR4WfWRA6UXzH4+KeoAVWeWasAGxt0Bod1hBzCGgPS9IDnIjRrM/Ui3sRxd/bji06rUuCMxR6BocUYLSoOOYDy8o8G0JM5lrr0xp2gpILJ/y4/eyaTAb/Sc06qfumvQlkJCA2mOo9RP1hOY745NiWTZNxy0ElWMQl1WdC8O9gcsE3Ngb6agFqQvLps4SAPLw5uFCSyKqgdiu6jbabqNRGRIFZhmtXULf1nVsEZbmtyoDBLTflrUvWrCQKdoi1zq8qnTd1M5lMSA23KCRLlfNRvapiI2e67Nxihi4OKHypJgLzDZGclimKtt6VQD9rQn2Lyp89KtIYdFz4m7fJHu/FJ0u1Fj7zY/UzKzJNcuaEr3WCvKrlDx7D37qhdzNSYptLIbs6QnhibgMDrDz9RB2sDfzwnHThUDjqh2lXZ0Sy7lctl5bEhSOYD1ZumKWmWaOQwCV9DFv4XC7j0kKc0x/YL8MnfFovndedFVl9ThlnzxYCq02Fmm+7R/zu8WHQfl
 kGuaA8RL
 0z33qDNYckKJZ/0Dz/GV/Iic9YEE+z/EDIIc7zsSTK0ff/nTpCDceln+TCVaF4148jDUaXBRlTYiq5QzLMxZ/4iGTmkOOagMJkrd8KstfLXz7ZsoH9WPU1ZZWOCreheKNXswOqZoUYa/X9Luk5r6ePx/brEYyC8k10r5lMIzv0yydq90Qmvho6EF2X1K3R/Bd6KenUgmqjRPUVqPtAPz3z3Z8fgGmzQ4GFnr3x8Vhq4TO+GhkvnWyU9AVSan5REEpIQUvH3k2lyBoB1dpRn1FyG8nf5qVSMpll4u0Mb1DdMuT4n4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 14, 2026, at 19:32, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Now we have lruvec_unlock(), lruvec_unlock_irq() and
> lruvec_unlock_irqrestore(), but not the paired lruvec_lock(),
> lruvec_lock_irq() and lruvec_lock_irqsave().
> 
> There is currently no use case for lruvec_lock_irqsave(), so only
> introduce lruvec_lock() and lruvec_lock_irq(), and change all open-code
> places to use these helper function. This looks cleaner and prepares for
> reparenting LRU pages, preventing user from missing RCU lock calls due to
> open-code lruvec lock.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>



