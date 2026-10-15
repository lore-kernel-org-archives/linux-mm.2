Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C48CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6476B0098; Thu, 15 Oct 2026 09:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BDBE6B0099; Thu, 15 Oct 2026 09:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF09A6B009B; Thu, 15 Oct 2026 09:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA68D6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:53:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 543224055D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:53:37 +0000 (UTC)
X-FDA: 85325003274.29.1C2B9CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7DD04A0006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:53:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OnRE3wXa;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792072415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWR4amPQ/GR2zsJ6RMsOHCZNfvKrDpnYYA3vUh4QnfI=;
	b=5WuY60n/yR8N4ToeHIEm5uakRQVmxQI+Ka8twsMTNyVObLF03MEb94r9xZN/hbRPcsjGEY
	0XPVhbbda1URonIPw96PZk8gc5R2M5sAmr4D8Adb3rC/7DkFSgNsI9ZIN0ZhT/mTqkGO4c
	cwQCIvSJ2EdQ94ibycWU+gHZ0RNEQyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792072415;
	b=KBDn8vS0e4xWb3zDNbkpphswe0MLC5mAb2zK9HwaxcJ1Z9dr7ka4lpPVrOG90DjAlii3im
	3XxPzCSJNM4KG5qHtk4+sDCH/kw8eXnYezF1ACtuHT5y71+FSsALC9dgc1x190h5ysXygG
	xSHNuqikmfXkkn2w+Ax3+zKQDHdOHcM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OnRE3wXa;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8CD741493;
	Thu, 15 Oct 2026 13:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E971F000C4;
	Thu, 15 Oct 2026 13:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072414;
	bh=ZWR4amPQ/GR2zsJ6RMsOHCZNfvKrDpnYYA3vUh4QnfI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OnRE3wXa1FnO6WZFf7oUjHX08tQXKfw7ITTK6i8lrDHZ2lmdMKhLKKTpZO3iImMN1
	 1x767ig0nCvDC6P3IVw554C4FAGBeHYGH0jkl7Hv9gTYoPo0CPR8bVMJy6NPkNv01y
	 MSpF8kq0LchCpIXBYhjRmfRsjlJmVFXtR19G5gl1gu75T20iIfZ/bJ6D5pxtTC8M0z
	 +SSVDAYbVnCafngS+6OMWW4bmMCfeOS8btTMZd4hlQsteBxFbmE2AqeSywsSUYtBJd
	 A1ENoQiIFU68hRifyjvd/47Peg1VK8qPK5jZuGgyVfe7QElEZmx/Qt4J2jcc+rfkJL
	 qEH9ShHGTEY6w==
Message-ID: <a809956b-9775-4667-be60-f635b9a72ee6@kernel.org>
Date: Thu, 15 Oct 2026 15:53:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@meta.com
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation> <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <atDMN5MoGrwJNpAj@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7DD04A0006
X-Rspam-User: 
X-Stat-Signature: 5ier9qi9gbp6bwsuze9wdw3gcpd95yth
X-HE-Tag: 1792072415-34915
X-HE-Meta: U2FsdGVkX1/5HfV52FcrP92CcZ3SudeQU7e9HxaeUVe9BLD4qunBWp3GRLYZhJZQ6Bi8nlyNmww5WpsJ92vxUOa6hQ5+hKS+XjfvRbirUIIoObSZl6VeuKGBaUbMAQzL4i5YQSokn50qyqUMa9iNG0augpYO/o2kfp50Ry7FEsrjUOR56jrNhGYgQgOSTO01eAorT0xZz3byVIJoGlRO3JGNHNqsicuEJ2Xv3A3q9VU0WtSITA2Xu8y/kJ+l+ipxPy8XTR4D+CItvbgJxlUbwDOv/f2538OmO3Dmbn0n5u1HUGrDLdhTaSAsA6m1ypS1kwGugMEWq+RkP2mRl0439yYQPW7eZud6JrRZa0ImkCzOdZjrY3bjDvv8YWsfDl4NcCmrCjVzP6nH23SevCFw8QzCWtXXwWEuAR9tLxF3xyjNS4ksyxESz+RyRQsR+MdVIS+RIeEx4Z7MT/b2m8aeCH1f1jdN9qPcFoKGy+DKiDwo+ZVRASNOBgb7HNOhcQEKhBt42OWhY2xTapPzKMPR15yFyfdT+lckwEkbXRFZDedmqMU/KatVSxqTtmF0zOVCtvgL3dXv34/2e6ZW9IMENEkgFGK3FDRGaJqP5/veGa1IjzpCGhByhSMC6Ct0aiucdPh5gvRdGRd0pZQNdAGE/LeVyfL0JeZTdFFd8uJ+xNyCEX0+57yb4v6CfCwvRJoNmx3q2vLsw7v493aYroHcuJwSsxLKX9TSNtdSVUS9Fpky0SDYqyJHPp98qAW8/YIIoBQGoa+Uh5UwsVJA8YohQJi0P4JQ6F2r3hFzwpI2O8aituPK/JKH7eCcqg1eL10kTW9se8MseWjvvwYLSYdNkHia/CTO4f0xDArb+/f5GTJMpDw9YeaAX5oWn3AE5QZfgwCto+Le6O+NSSGa16IwsgbALb6qtvKkhUKk/spnclsX6EnJFPxEs969ZWsyz2sFzb+xK+B0dAongl2KgCA
 DGFMH7uT
 L2viWV8cxng48oa2i4vBF4MA/agS0IZ7BysEonIjFFhuS/VXDj+uBVu9TrMglMi/2mIOcBb0LyasZLxkLW3lnCVHpleP1qjhbPsb2PzukkCA8OuRfQFoWh9zQuVSisTlaiPNOQxRfLIsw7He/LQsbFbeAMb0V5nJ0pPTlyaD2SwdJYndgTYt4dwuGZvYmKUa6i1Q/lZBBgAuSsry0iEihpD1oOKTiv4gZvQtvuK1OVOSHPNYktFBkNxE5VVI5D8nWpZ0xn2G6uf8D1pXDnRGSk/114S/pGpdlyDYOCdNZZzFEH0C+D3J2ass8Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 14:55, Kiryl Shutsemau wrote:
> On Thu, Oct 15, 2026 at 09:16:36AM +0200, Vlastimil Babka (SUSE) wrote:
>> > And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
>> > but Meta is using the feature right now.
>> 
>> I thought it was there for a long time but it was only added in 2025 :) At
>> least the enterprise world is slow to adopt things, AFAICS.
> 
> I was thinking to propose a patch after merge window to make defrag_mode
> default. Do you think it is too early? I don't think it is ever going
> to be truly stabilized without wider exposure.

We can try it, but preferably with arguments (and best, numbers).

> We also discussed with Johannes to make a stricter (defrag_mode=2?) mode
> that will not give up on fragmentation ever, but OOM instead.

Would you use that mode at Meta? That however most likely wouldn't be
general purpose enough to become default.

