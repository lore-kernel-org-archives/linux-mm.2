Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C560606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 01:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NTqKdH5F
Received: by kanga.kvack.org (Postfix)
	id 23F6D6B00EF; Thu, 29 Oct 2026 21:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA9E6B05B1; Thu, 29 Oct 2026 21:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9E16B05B2; Thu, 29 Oct 2026 21:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D758B6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A9DEC0502
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:26:49 +0000 (UTC)
X-FDA: 85377553338.30.9A49DB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8CF47100008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:26:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NTqKdH5F;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793323607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+7wMeQRfWueUJAeG/KPsvC6BLbhrIuEh3kJTRzJT8U=;
	b=cB+5csUc+pQMp5DOlZSYk1mAmjAjHXEdTLUWDJXjtm03ke+XKO/eWte1sYEeoFwRFZQVTG
	x6koNLM0jaUs5ggtdn97QtR89DaM+weMXiuvqvRz7C8shDiAEb/baInbtQh0AZnzPtV+D5
	rJa0/lVH2bRKihMDTzw7uFks7tcJJVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793323607;
	b=wD68FD7/p42wEzc0EOHO9riprZRd3gWR/H2BDc+zHH2OHSVuM/pw9v6WhDLy02MZaiCsgZ
	y9TbMTWPpBAmFYieylNm+SWu7q8tflOPhnQB6yygcnYSSWwhlGrQoquZSjk/E+jC7gF3wH
	c5l9WaUKcvUeWjucVahYCAv95i545eA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NTqKdH5F;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4401143C8C;
	Fri, 30 Oct 2026 01:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5401F000C1;
	Fri, 30 Oct 2026 01:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793323606;
	bh=R+7wMeQRfWueUJAeG/KPsvC6BLbhrIuEh3kJTRzJT8U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NTqKdH5F/sVmrX83aYf/qMaQtAoYv7RnBq/ETuLKwReNF6mHLjTD4RHExhDGcdlpU
	 NkLlBhUVc4otfWDMO3hSlUhRf0xcxp9ug/R4Tf8gDvHbfBk6FN9wvZFNYve4Z9otpQ
	 gyZPKxp+LIi4u6PCi9oc8aB6gOCiYhy2O0rk5zQg=
Date: Thu, 29 Oct 2026 18:26:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jackie Liu <liu.yun@linux.dev>
Cc: glider@google.com, dvyukov@google.com, elver@google.com, pjw@kernel.org,
 alex@ghiti.fr, aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, muchun.song@linux.dev
Subject: Re: [PATCH v2 0/3] kfence: fix pool allocation failure handling
Message-Id: <20261029182645.d6e7b119a562c973d19cda63@linux-foundation.org>
In-Reply-To: <cover.1793242457.git.liuyun01@kylinos.cn>
References: <cover.1793242457.git.liuyun01@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CF47100008
X-Stat-Signature: mtqo5eh1eiitgqj8csd3mtxygs7kunff
X-Rspam-User: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793323607-122371
X-HE-Meta: U2FsdGVkX18K0dgVpEIRb0O3WUrjso9WPGhXiOaOebzL+ZZQk6kqfdXLNG6dSLVPtEZu304yJdLeHz3tBrur+LHGsw1qgg9pC3H1nEf51CstUb739+rhuFmBSYPyA/qMhxQYc931LE+4ey0Wzorfdo7MlWqGJhR/2LmB0GL1y28pi3uRjmfWwH8Fg42jT10ptDWi6pKujX51dQmcPrkCZWSvD4Wj/KFIAaK8GQQvfbQ/14EacjuBpHWgGvA0jhq+1lgBFyaBMeTRZRFx2Q/eT5GWbnwFJ+tIOQNd7LVGpEialop3ttSJvafKD8EvxIaUNb0lP5ahuFlTMTbhdN1IWFHmPaOwDcR4Do/f8OSRxDIqnOhdbri77O+rfyk+ry6mfU5qmiL84Q+YiJE7p0kEhmxq4QjToGnI2iXFr2X7IPVik8gJwH9tmiJebg99FRD3PZL4KOGLvzcbo4B/l+JnZcwDO+4B7G57XJCRNT1vd2H1+6VwhSAwfAtgC6fxktUhw4OaGrvSjKuM+oZpXZQCdzrbQcZA3kwTulqRdrd0gGpqpoSUIgNdeu8WarHn8s7XGTMhYb4jI9ROFUGVhKaWpOPEBQQmQPcdEZOj/b5/Hfy/U7AiN7CwaugXp/hdWqPLvsY9M19x4X79x7a/co5LcztlObHlsNamd8YIj9peOUsn6qH7ij5I4ZDHkAok3zQPjvsAqJSaAXhWNpOmjvNZLc7jM7uyOvevwibQ98sdXeDiX5ujW3xXVyxgB1Xb2+0ZUxgQ548JtNJGa9P7NuxERZzl1jiaqnzq/FexjHvz4xFcLkmjp/EVQrcVLMOc7gzRvu7yLAsxj7GkpFwiBeYGCffpD4UyWjFk7a1z3nCxMch8LxNx5uRBdaCNa+zOGVNWJNK7RCbTdJz8BqwqCMjFvauG6EQqfAZqLf/PTGHg7I9z7nyPHKgc4EPdmQrDxo4eayINkgtvLjCW0ufNJx4
 o33KAET7
 YlsEfn+EpHNBue3/iCQLzM8Jeq9Y9qS4HzVpf/vPng/EwMkypagHyy4FhujiKfBwNchp40KWoCAmZAlfehW7FBTa9/MEQB9BRuezHdaKdY7NwRNIT/moUUWvh4f7/JNolflw/9OxfrlGsakTjD+ltA0F6072oDNVUR++wQu5WVVtknWRw69qGUm/Qoy4J876PmzMMHG61T6tnOProVZE3TvvR5EbHHWksDaRR80Y2CmMkNYNSu+J41kCwy99Jc6zDXVc1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 10:57:40 +0800 Jackie Liu <liu.yun@linux.dev> wrote:

> Fix the cleanup address and page reuse window in failed late KFENCE
> initialization. Also let RISC-V boot if the early pool reservation fails.
> 
> Patch 2 depends on patch 1. Patch 3 can be applied independently.

Thanks.

We're all horridly busy with bugfixes at present and the first thing
recipients think when presented with yet another is "why should I look
at this".

So it really helps to start out with a succinct and punchy sentence
which explains that thing.

LLM suggested to me

: KFENCE initialization failures can cause kernel crashes or memory
: corruption, while a RISC-V failure can prevent the system from booting.
: These fixes make the failure paths safe and allow systems to continue
: running with KFENCE disabled.

How does that sound?

