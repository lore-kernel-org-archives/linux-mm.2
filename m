Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EDAD0D14D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7BC96B0088; Wed,  7 Jan 2026 12:40:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF386B0092; Wed,  7 Jan 2026 12:40:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01416B0093; Wed,  7 Jan 2026 12:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1DA26B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:40:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C95613AFBF
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:40:01 +0000 (UTC)
X-FDA: 84305881002.13.05D18FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A91C0180005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:39:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2f1K5OSJ;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767807599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmIr4dzHC61lbm35kXh773bkeEbUlDp2phWyDKwKJR4=;
	b=UHmlv5eLSDaUkfFJRrEicAKSkF6G1d/eNLV4jNjLT/gkDZPOZORB/DDQ22eQy2MnpThNeQ
	yIUaVgN2bDNQgUs7hzMZW5CGiWjp1r+NIY4tO+uikeY7JLGcq9hpTujemLNN8ZBNqE1REu
	5gIkLs1rjzTFcziXycp75Qo2Qxi0f88=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2f1K5OSJ;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767807599; a=rsa-sha256;
	cv=none;
	b=PiYeuLl6AypTHdN7jFGcisqoUZJ22QUNJfv023J1WMWpmTcFN9bFyVUt+9oG6MVVT37d/h
	vEC4k5y7gopksghv9onXBLRSYAV0KSyaS8aPX5uUmU4mdOgMQShOGLtjRdmhYV+lgS3GKt
	qFqaKHz/Opp6tk9Cyt0T7OqGVy8gz0Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50F2E41B05;
	Wed,  7 Jan 2026 17:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69E4C4CEF1;
	Wed,  7 Jan 2026 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767807598;
	bh=KfZfyEEKCtvxRu8W+wSUsbS3mWH7oGtOON/vMZdQN8E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2f1K5OSJ8sn6yhAq/jUikcdALozL58hSRuhKS6YhXnZxESpg5BnmOITledFhtNxLi
	 jhhZEzXiXcqusBfoa8EwPYZ+3tE3b18u8sqltR9sGn2DvJA4ltXogkIpYgEGBhGUst
	 YSzZJ601r0oWZgSSJmuRTZ9Cff2p1C/bg9lihCrU=
Date: Wed, 7 Jan 2026 09:39:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/vmscan: optimize preferred target demotion
 node selection
Message-Id: <20260107093957.12f7417670241f270783e2d1@linux-foundation.org>
In-Reply-To: <20260107072814.2324646-1-bingjiao@google.com>
References: <20260107072814.2324646-1-bingjiao@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A91C0180005
X-Stat-Signature: 6car8tyziyxabkpfei4mmz8npoto4ouf
X-Rspam-User: 
X-HE-Tag: 1767807599-544998
X-HE-Meta: U2FsdGVkX1/LkSJRdZyuf8zBqNMQih9WMxDY2OmAcp2v4hFFD2jX2GjyaxtC6UfuFZxOJqgf7pySp/OmEhiNjXlpgu8Ff/YeKR61Q52nQLKR73dlE7KFQv95opfp5yH0Cjou4WZmXdXFtYOt4+eoGu9WPEoDCe3FxmUuE51lM7BPmmemqCyV1NitX5KRRzQVsqbCxFEAd+C+yen4BYaoLLsDzDC6Cd0GqPIuqbJhp8Y3UTGdi+LotEQZ9rqNs+KI/CFwXN7kalV0eCVyjd0d4ZXRD4ZsEl6U15Uol6Pda50fvKMJKNVWVCimgFjB12GB4bRuMVg5Icxwlz6pqg7RM20b8KBA2IcpV0uGBxhntOporaxRnEQWZ44GtrMb5ZCl2+SN5wHiS4DtvXN1tFjw0rAeaLtovW17BH+VD9m4kWbyYJgAwJP4Hd4OgoiLIoqWPBOnbjfHUZVjmHHYVTmYWALhtCpKEmLL4iOay0FolaND1rVLLA+CscCecrhU3wwkGtyd+woAiNwDi2J+1OPHUseHWD48sf8ywdPQ86UeO/QsQ8nGiDAqT/eGJKzpXOkCuiucckMVuaJbZ69zkTheg0AmDF9Hu64oVc9HB21Jk9wubQVBZSPgaqxAt/zUnSntLQDiVywf6yBl4juTAjCgLqVccZ+LxDqOjvQxHx0qnCrqBghMEZcVSJLDwtGje/q44CUj8+WbqI3Wq562b+w8vLsK5Oe6hAh6ErK0p4nt2G+w5CngBoCLJ71A6d0wL1oAyJIxuQpnzZ1E6lEXLJacVXHur+xjdVUmZD40TE3kZDYW9kL8Eu3TLRoa2+hARRwwDEk5TQOs0BYT0akbh5v6WtcEvfBZa+r/+xGGd2bw30WSHTcLEaS/LDBjCmunbvH195YWplWS/l2iJEE4KR7Jw5WSQ96PiO4utz1FS6fuUqfVZAJawPOlyp9JtY0nSdK8jOdHhC214T2LOFn0CF0
 RTY7wBQx
 CmG6+Bn8qSSJOHK3XcNB3nCvuiEyyCKtx8BbN4HCohCdfyAHVu0vnqgSoquJZbaRlhPJnJg/GPrQ2DNUZUa0Ofu0ZYHrZM/oU9jyL6RdLDyyj1uEWn1EgQ1gKQESIcHEgOiFdLMd94WuUnr1JJSecU6Vc7sdvZ9dRDOQwCX8uFZbIRk4fgVtw3aUfGpgyLUQuuUf1FhIy3PRUxcT9we3DmP3XE8N0+qwDG06MDMlsBF6Fo+oZHSpjLMWbUN9F+xarkpwepoIuhS6yeOwtUNoEikLjug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 07:28:12 +0000 Bing Jiao <bingjiao@google.com> wrote:

> In tiered memory systems, the demotion aims to move cold folios to the
> far-tier nodes. To maintain system performance, the demotion target
> should ideally be the node with the shortest NUMA distance from the
> source node.
> 
> However, the current implementation has two suboptimal behaviors:
> 
> 1. Unbalanced Fallback: When the primary preferred demotion node is full,
>    the allocator falls back to other nodes in a way that often skews
>    toward zones that closer to the primary preferred node rather than
>    distributing the load evenly across fallback nodes.
> 
> 2. Suboptimal Target Selection: demote_folio_list() randomly select
>    a preferred node from the allowed mask, potentially selecting
>    a very distant node.
> 
> This series optimizes the selection logic while ensuring balanced
> allocation across fallback nodes.
> 
> Patch 1/2 introduces a randomized fallback mechanism in
> alloc_demote_folio() to prevent allocation hotspots when the preferred
> node is under memory pressure.
> 
> Patch 2/2 updates demote_folio_list() to traverse the demotion targets
> hierarchically, ensuring the perferred target is always the closest
> available node.

Yes, those things sound rather suboptimal.  Do you have any data which
will help us understand the performance benefit of these changes?

(2/2 has a typo in the subject and in the comment.  perferred->preferred)

