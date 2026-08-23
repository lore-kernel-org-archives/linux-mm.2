Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 501EEC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 07:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3196B0095; Sun, 23 Aug 2026 03:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093EE6B009B; Sun, 23 Aug 2026 03:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12796B009D; Sun, 23 Aug 2026 03:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1B1A6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:39:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35441140277
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:39:32 +0000 (UTC)
X-FDA: 85131734184.17.09444AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 94D3920002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:39:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L6f2iutO;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787470770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rB1jsGUuojkYKJwh0qxzHjSNA7rq8zyf57JSD5x6cWw=;
	b=e/fpSjXOCYv/RvwS9eMcO9UWQNiz2pHqNX8roXvYKwRrQWKpcnhoZdxIDiN6aJYkqEifSR
	UsbEpfzf/30+/zuiu1K7/bd0G9nlPQay4ep4Liyxlz82UaMfhPti94Gyc1OzrbbcLaMICf
	xKFkGohIHNmZKdlJ3ULrhaDx1H13vpU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L6f2iutO;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787470770;
	b=7myOGjINARPx1fzU+9OkkE37F7lrD4ZvqqUueDjxi+6opv1aXepVVgZSfSrEWZ3JkVxcKL
	tiUeNVc9AvL3ABf+D29wTbNMuLa6rw2LpNDyNmjVMGAbUwR3hwMK8x+e5hq8FPQIcrj83z
	IqFBJvohAIQz7xzFPyp04D3fgr7vnbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C05AE411A6;
	Sun, 23 Aug 2026 07:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D153B1F000E9;
	Sun, 23 Aug 2026 07:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787470769;
	bh=rB1jsGUuojkYKJwh0qxzHjSNA7rq8zyf57JSD5x6cWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L6f2iutOGFtzKX/8ZblKNBsANqnd1qU3V5YpH2wDSEsWH5BqFLyO4B8k8BAPvGqPQ
	 iz3MvD3068uGj13pWR7sry2GGrz/XslSwWhNA0xjWe9tZL5ta6M7PPKc9UUafjzeZx
	 MYvufbZV6GWEnzPctWCfg7Rxd3uhn3umK77Z1mWhyMzFCYVr3eY8pDOlOpPWwNX7Do
	 yc37a6mDloeb5J/1GfpBy764i4o255JbtM8Utnd2WQUsb7fK71vCQpc9S+mTC/lL6Z
	 9VkOkWdXLPlfXGp2LRywoFyd14TpU5OvO5fL1/1ndIji5etYlabWI9jqQ1R52+Obtc
	 IUitXeXLRcZ5Q==
Date: Sun, 23 Aug 2026 10:39:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: LongWei27 <longwei27@huawei.com>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	hewenliang4@huawei.com
Subject: Re: [PATCH] kho: Convert error handling to immediate return pattern
Message-ID: <aoqjq4kLCCSJtdP8@kernel.org>
References: <20260822064127.498411-1-longwei27@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822064127.498411-1-longwei27@huawei.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94D3920002
X-Stat-Signature: rsp98u7ggtxt1tqzeube9b5eef8fncxa
X-Rspam-User: 
X-HE-Tag: 1787470770-781157
X-HE-Meta: U2FsdGVkX18AGkO3pXdsqH2/DYNhAD1ZXtycURlOG6M46KBZzn6WqzSCBwaiSHoUzqrgV3rpW4XHFJ++8vDZF2tGYVnmNnlpTkOWCQHxiAX1SymTQVfAVQS6ztmPzK9ihJZLti2FkI6B3L2yP0XrtGycSrS6zXnrYp9WoNW18yoXek5rEa00LhSKrGQ9sCSpxSrb+9dA4w2Ov+LH0UJOnKN8AyUUGzQdeE4fhlo7ju8jjDRbbr82u96OXVQ4tzZRENUINnoaYDvzjB0tZqpaWiJUICpsRzpgcCSbl0GKgyKvlb07NS40OUx595m8rXPqWMtKu8bKEtwXxMzgd8HEqBalT6pwYWI5ngNgtwYtUIPF/cyTOyCvX4KGu+B2CChszqDA+b18zRgYlobxtyQ5t1NIF97+NuXh975xRzZwl4x2Et93k/o2GaV1xXftvv40TM983+2+pSd/NMCwZYLgX/SrUHapP0lCtS7kiydR9e/chExaafFvLCcxXQqmyMujhTx1i8fDXMqHKaem5IhFsII+kuv1AuEFPejbKmdMXnBc/vWXohRJji8WOzC9pDUKVDw9ArXqavkhVcI8rHHypQm1zgnfCtFdXID+Iv8ldNlbj4PgfM/ODPwqHrNTmGZRbu9GK75j6/IxhoKnoUeQGKjqVGuWniVLFwhnzoen/Zx1fcxdsP0E3DWGYBKGaQSNEPRa0MfX34ymQXB81GUk0HRbHYdlRyrdizrETR/ZoUoSzoyO9J1CGk0RlYQNj3B5jtUL4+nugkCgwTgMcFoK9HGtjzbIMztEOqH+1RQuqlspbPU0NUAHopJQ6rkzP1abLcN35uclNGO00/7mr6eWC1q0qRD8l0IT69YPZJ9D8kw05X1kuKXKNt6M1MmN7AshjmJOP/qLNxah84QOlHwKncnrRosJSCZGj5yr1bLQJVJGMG7xhMtVjymXdJmSWpmoqDnJUO7Tl1bt9eVaKgC
 /KdwO9Ny
 PvQ0y4bcP/sx8/h7GwAxEeHEMMzFoAI7zQ+lJdqICuAsYJBQ/5i3beQlcwHt7MS/ARntOrvSgJkHSbejcQodxElj79SzFoOXLS6siYSdMrZNBQI8M9SGMeMoOyiZ9z8CnUikZudXATjGF0rSBSWdcnNSaDfhtJayJndUla8eDmmmYgx4Qw801kotIdFQg2Lk8t8TKQF7WZIN6p4WM0pApBLjJCEk5dIvtVjACivCeIjBME9ubGP6XUhWI5w//uJLMhdsWUs3u0u5cUk8lXxPhHVQ8dgcvDEN9XcYU6BglpHILtV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Aug 22, 2026 at 02:41:27PM +0800, LongWei27 wrote:
> From: Long Wei <longwei27@huawei.com>
> 
> Replace the chained error accumulation (err |= func()) with immediate
> per-step error checking and early return in kho_out_fdt_setup().

You didn't explain *why* are you doing it.
 
> Signed-off-by: Long Wei <longwei27@huawei.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 32 +++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)

-- 
Sincerely yours,
Mike.

