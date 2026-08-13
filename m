Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2956C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26DD6B025A; Thu, 13 Aug 2026 08:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7436B025B; Thu, 13 Aug 2026 08:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEF76B025D; Thu, 13 Aug 2026 08:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7F86B025A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:08:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B84E080126
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:08:12 +0000 (UTC)
X-FDA: 85096123224.10.86442E0
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 236ACC0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:08:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Y6nFriUl;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786622890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1IaZrga3tw+zONAd1nRt5CILnuvdDUAsSC4l66metY=;
	b=fytUrOSh4VfvNOOBGNvxrQ+g87og0YjMpHkLe3wf39ANiNK28XuacjDts/SnZfUeurOvqV
	5Kl5D5eml/guOAAhppEnCOWgtyc+Er/h8hsBsZQKYkjhrAzTK3B0n18QQ9WW0dvYCdSJ8W
	xoMyH2WpR18WHYMt7AZavYlzEWmpi88=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Y6nFriUl;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786622890;
	b=ArWSrr/9Us/uXsMlPdwI5IuqjvBXkLX5ornLkv8U5umfOZuNxhyOtgS0WZezaQdBQzcB+l
	4nZU7sdQaLyfY0YTLS17uPq8t7OdKpNoAkctVFz09f+zdx0ys1fog2LGPYSrCUo1WB+AIp
	K15I36aWTUazZYCAtj06iWlXRC8pcOU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=p1IaZrga3tw+zONAd1nRt5CILnuvdDUAsSC4l66metY=;
	b=Y6nFriUl7iEGi1LAFfjTAi2eUReE2M7/qodq2/k1YBqphUx+JMJ4DlhFiM9BMn+6WJfx6rX7N
	Bep3szryKzEhE9r6v83MExjQxeWQs3CXa/ne1tYK+hvudbwT5DZFTseB8vDVdLqPhJRktZhYV/b
	6j3BiGtSIxOmFRlbX83fSzc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hLP4Y5tqbzcb0T;
	Thu, 13 Aug 2026 19:57:49 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 1830340561;
	Thu, 13 Aug 2026 20:07:59 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Aug 2026 20:07:58 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Aug 2026 20:07:57 +0800
Subject: Re: [PATCH v3] tools/mm: add hwpoison-panic tool
To: Breno Leitao <leitao@debian.org>
CC: SJ Park <sj@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>,
	<kernel-team@meta.com>, Andrew Morton <akpm@linux-foundation.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, Paul Walmsley <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, <david@kernel.org>
References: <20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <2641f4d4-c08b-e9b2-1e8a-c91ce1f41d58@huawei.com>
Date: Thu, 13 Aug 2026 20:07:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: 8szegmkqmnpkb345rp71qub44rh6g83b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 236ACC0003
X-HE-Tag: 1786622887-441492
X-HE-Meta: U2FsdGVkX1/R4Z2xPKcchLd9e2pJ8W6e3H92XJu+5GtWT8sQmRnKZtkhitYJnJSMs4VqONxslolQP9BUDi2hW/JxmiVLWwkAyMTznkr+j9Bx2BMN9V2mtanSbYF9vkcQIttVCjT7nRujdNHFyAazaOnrsx0y00T9Ap0clx127ICqI+sat65c8UOqihysLyp1WAsFJ2tGeHAnGhowj3OF2XWKk8LuS3vD+aSwqt45RyPRdxQpWnuj38rR7hUpYiAukxM82Qf2iBPKXuIaI5T2yVvDK0RvdS4jgMl6bKXUFjaJEXORK4eLqCYHkxPZRkxlEhRW/LHXvQHdEkOk02k39OZ78DUcV3AMQzrjBFn8t7bQJFMQ51PVBsklCYnmOAEC7QsNG2voofKtaf8MFb2GY9aHW/KiOQKY8V71URCruk8zfdIUbMPyn5tpCLJJsUBqw9+B5AY8vYiVhETC1AlVvbbRZxov6E8VTGTpwh4maaWKW+QsSx1Dq2mQpFqIdgfkCH1E6btcNnShoAEJjoOagYiXcrj4cT488ofrnsxyNCMvSdcmQEblfw2pANCf4tH5Saptp2pYEUG0ha/48DVrgtpoSk1k//7taYrD1hcnTacdg82qPG5Jjji1RpEsqDat/UVGGkzBhvIubnuzgTWJ1MqRYVqssv7Gi7OWYmmA//+ljJqxy6FwKvqOqY6aC9AC6L7RbQ1CEIXdk5keXk881NNJf6Ft0EQkXJPwLxoIxGEUXsYlCColluM4NC43EvvaR4GDutcl1Rmo1rk3eKyl2a+2ZjXbBSF4iYCPz3jz8AEMp0UbN7dkyY1AedE9ca6EWL2D3HwTl9gUPcBwU/sJy8PBw29c39j4Ode6AB3cOVxtUkYoNcOgdm7BngrWpTCnew4L8Jv/HTCE5GH3z2COKEuOfJdwO8vELRhOjhd7Ilc4vFYB10mwe7uoC8QrPyGlnKtsG+hDGzs1cj2xvB0
 e1Ib0cLb
 kI1VYetMi4WSLOLAPzCdla+QE/cn7XeUWzuhnfdTB0VLl6t7YiYhcmhblo2O8lL08dAl7M+EZQBWjhBCLXzQ4nb/5f/WYlXAkBWBrlcVTOVuHCDfC9crwG3avj6llCxm07uHod9MjLyfU7D7QAZPDzkjOHqChUv/upKh7UCGlhBjdOjNGCDMh51o8PPpz1oFmPyJELzpBLn3VuGnCTA0FyJ4MuZahi5b+zEM1HZsOi4uPx82fbjnbEp9dm+h3On+9Tvme+wQhmiQKCs8/OAhZ9pdjANh2ssejpK3cxEG3LREGUiws5434+dAPiB2uWo430jWp5KTZ5LPSo0F9otdlbzLczaYy9cF8HDP+xRwg5ty0haun/Oc+gTCdx0jC6lMM+kOkE1wrRJmTvu2RDj+esRLNng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/13 19:45, Breno Leitao wrote:
> Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
> sysctl, picks a kernel-owned PFN and writes its physical address to
> hard_offline_page.  Three page kinds are selectable with -k: rodata
> (default), slab or pgtable. In all cases the host should panic.
> 
> Example:
> 
>         # ./hwpoison-panic -k slab --yes-panic-my-kernel
>         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
>         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
> 
> In dmesg, you will see:
> 
>         Memory failure: 0x100032: unhandlable page.
>         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
>         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
> 
> This lives in tools/mm rather than selftests/mm because every successful
> run crashes the machine, which is not something to run from CI.
> 
> The --yes-panic-my-kernel argument is required so an accidental
> invocation does not take the box down.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Thanks for your update. LGTM.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

