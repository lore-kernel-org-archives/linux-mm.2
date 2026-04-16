Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9AF5F433CD
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 00:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9576B0005; Wed, 15 Apr 2026 20:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59F66B0088; Wed, 15 Apr 2026 20:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97826B008A; Wed, 15 Apr 2026 20:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 976CC6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:17:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3D69BA613
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:17:33 +0000 (UTC)
X-FDA: 84662505186.08.117B57C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 45F478000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:17:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP9yMaOP;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776298652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USC/vGXD0UhEAoKmTJOt3HWZoHLAJkt81qZfjEEGP4g=;
	b=w2o1QEa3vt7EPELcsJydjdvMS6KgVso+6lZl1d58yNX2AS7BD3a8IQPUoQPTNmjlLcVZo7
	kWWkt8rcECWFSbqv5ak6JIrbPGoXD4uzctaEAnMV1MekwR9NkQWWoQtrUJAf0uvrVvArqe
	tXPSk8MrJKpGU9ssEPFMxwB3qw5ioZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776298652; a=rsa-sha256;
	cv=none;
	b=Xy3SeGRryzcQYMcIBdQrZ2AyldmHD/7JHrjclBBz3JFTNKbjbgJFERn7/WKZj2Ndd9OKsj
	DJd+xUamQm/0iB1bTvsnjuC5g/tuCAJ825aytrTVSC1sJ8XYZ+Sy10xzsWunlpoXnFyCFk
	q1k7VLS7axG8CKhg8YA+fYtD3WyZWs4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP9yMaOP;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 392764048E;
	Thu, 16 Apr 2026 00:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C54C19424;
	Thu, 16 Apr 2026 00:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776298651;
	bh=lCoebV5QS35oMFku9uLMsRapyWp/sLdsdBGqr5M38nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KP9yMaOPrmVnGg04j/SZiLLodKuEKQn7iWBDdAcnH+2i7RdiXeADwSoSyIBZO5L8L
	 T3MWsy+rZwico6w6iNl9ZySwMUGkT/vaLfboZ0JN0gY8uCGhYXc/K+8uLgBrt574pG
	 lO7z2ozNWNv++AkRqmmg6eGwhWW7GRDH07evzxj6GCM8SbwuOk0F6z7aG22V/DU656
	 r4JP2NcYEFnMq0iFWnhNlV2DnaF+JEOnQciVAfAaow9oe409OBMUWldcMCHM+WhzDt
	 o1AMtMpVvbdAR9uxULISYxE2jJzKAr2saH0mjb03p94HsNawNUcSUf6h+xj9FQiwbZ
	 s1d6iYFRs0QKg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Wed, 15 Apr 2026 17:17:27 -0700
Message-ID: <20260416001727.86548-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260413185249.5921-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qnarda1jirn3fpcgk6qae9h1k79wyrco
X-Rspam-User: 
X-Rspamd-Queue-Id: 45F478000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1776298652-989433
X-HE-Meta: U2FsdGVkX1+wn03amKbGQIQp5Eky73TOYZzLKc95h9o7mTPwTLyoK8RXVCuOvXyftsRqVl5ULehfBZGyTkCGaV3WFdVRq+lW5W1UKQZOU/tWxVXbHziedG60iTG7eDYgpAgyxwkPc/bi6IfJRbcY90XsrsUhwbVWS5K9qofXYBls/Si3MHK/JmK0LcYpptl8W9x9fvovbEsu/xel+SmrQsQYO1I6txrVOwdnwDPSWq7h7SOSY+fzGpTyLfgmEczb4L6CFIQWP+VrXgFrUR6xJuhmly7tErBewSQcA5GwjEK3t2TUBNxyQUIk6HNqYUE8DBUeId8zUk0A27eILS2zLyNiMj838kBWJ8CnYDNBT+0oA1qC0CgVE1FOfRVe4om/R++59dHMN3RJfOR5PWQGCmprw70PRmydBu1jdmQ5up6/wWgUBwE8TstGH6c2p8ZkE/mbexHtEO1LD9kZKPDIGIBY3XjzwE2ws41LziyTr0RdU5gm/Dj89L/1ri3mBYfcKJgw8scIGTBRJfjXhQAwPTQxCg+U2xI3W4ZFxB+oACep9qqsgEROS9R0XhuO52J1RLoQkH2FRhQMSsoHEPptGp9NmuNFUDDyKeHCXthU/FeOunMptZgCFVgBofL1oagtWjlkot2tfjIIsdtL9rv3VPTMLEIIBCU7T1ijvYUy6dezVf0FBxr6Pwc38XPnsvovVIQXH1zDDBVCnNw6bQoK37oWGgBTkihntffMhmitZvYu7l+Rafi2C3M+lDEcpil3xrqEctIzr9wC7LVKFOej3GCeMPwGVZOkxLdUkvehhASAZ1YsPTWCiYmnQy0dkul7DUYYuk4G+qFbsl7QymroG77AjJGeHfakxqXATmx53DWBWE/I04Q2GFRJ58cuRxBHZEK7SV3Zea2GGELF1a6ebX4RxnQ4x3AxaxCCLPeuv3730rxxPBta21HCn0T1kz/ac0VpOesu16C0lRcQkRl
 pBHq4V3L
 L8R2zJ8Fx5lkHsz74i+ZyJlkzmvdmHROXWu0Cs2RuyAJ9xeBTgIVmUCRGNz+2jUlItY5nDbKuNWE/jA2GHlTyT9jNBKOk9b2VzkZ6y/3oX73dkkHoEJxhjwHgjyC6cLBiG8zHkRiEEdjv6rpxV0+lIYYi0LGV16L5+v1ekyeis5zwtWOSazi6JuLWII6DezWkr1FqwSybOC5WLnJEGHi5EaHCoQq2vVPyCxgfsFe9QEwko7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 02:52:47 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> 
>  mm/damon/lru_sort.c | 13 +++++++++++--
>  mm/damon/reclaim.c  | 13 +++++++++++--
>  2 files changed, 22 insertions(+), 4 deletions(-)

One more trivial comment.  Let's use 'mm/damon/reclaim,lru_sort:' for the
series subject prefix.


Thanks,
SJ

[...]

