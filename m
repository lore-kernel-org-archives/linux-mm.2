Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78B6C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ECAB6B00D4; Wed,  2 Sep 2026 15:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4A36B00D5; Wed,  2 Sep 2026 15:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B27E6B00D6; Wed,  2 Sep 2026 15:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 668136B00D4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:29:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF89CC0370
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:29:36 +0000 (UTC)
X-FDA: 85169811552.06.19539A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 17B5420004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:29:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WxZkI0zR;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377375;
	b=DSl9ryB3Sq5sCGqq8I1tAYdcmOlgyVsUyKP+MAkZEHXFcfpoSoke9ixikucj/XIbqKzoBk
	pZ8qgwTdxYs3C1YK2HJcl1ZdBEEdoYCiPHCWhNpdJPk/Xaj94BOQaSEQe4gdml3koN8+os
	rkbGuTdPsBGSqIrEWzWJN7s0wQN/rG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnKjt2Q7cQQXIMvbkPpCr4kNY4+s/kx6ua0E2A+Cb5M=;
	b=H6R88FNE9rYpqK80OmCCz6Wi9VrcvJeWaEyisWbtudlaD8GYe/xP1Cob1IVtvmNAKrGZPI
	k6HisQ4LW8fuWzpRbaSA+U4e7k3P7Q/dMzMiP9eDEZzv2DTyNr35bBQYdjYQKgj9lsS8dt
	pxa4KyLpFd5QuYSL836yuoSEzp/pUnw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WxZkI0zR;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 538D0601DB;
	Wed,  2 Sep 2026 19:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7267E1F000E9;
	Wed,  2 Sep 2026 19:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788377373;
	bh=hnKjt2Q7cQQXIMvbkPpCr4kNY4+s/kx6ua0E2A+Cb5M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WxZkI0zRNhLOcHhVhBmHsDoraOl7I2tPiez8q2Cj4cBsg4GmNkMb+csAfULTkqgEz
	 1uolqi0vN0C7oBz7biWffMcOilzJTq9LbhFx/ujI82iRdq+YFCjAmaiSk/nivxnEeP
	 vJPnW/A3HIKKsyxH3za7fWoW0edkg/3razfBrGYQ=
Date: Wed, 2 Sep 2026 12:29:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-Id: <20260902122932.7a1b82de7a80dbd5897b65f0@linux-foundation.org>
In-Reply-To: <20260902175611.1241118-1-yeoreum.yun@arm.com>
References: <20260902175611.1241118-1-yeoreum.yun@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 17B5420004
X-Stat-Signature: t5t1j4y7mrsji3cwascdm9rx87r5tote
X-HE-Tag: 1788377374-539374
X-HE-Meta: U2FsdGVkX1+rb65YZbIFMp67rtS6BI+pXOHZIQ+JxGV5Sao+mm0oZyCCfJ6iFDlOPQdjQ4VKPSI+bYRhObG5FNOq/8C3VNbhA38ksVudad3P0YHLpANcUYpopp6Vqm+B1JrRyL2Pdns2T6LywGnBA7DoZUT+xbgheC0ckE6JNBbPxnyh5kBX99DadqjbZB0YVdzH36MtehitqvGbCo/LhwL/60ITbflgiTmocYunySTAaCUrkT75rwU/a7xsHzdLx5UaTvacLaTNHF+C8bmoYjCIw3nlV+/YMY012N4WYb5JDjqDq5iqv0wsUrPHu7ECEFlHy6xP64pBtEZX0mjFe3hKOcstOUN0YvsM/uVlWHW1LKZRQ1nLS4l6JwKM9EZhECAqWKCpnmcCVNybUDQu7URfE5id5VCzAByx2rMPDbTbtFA476ep9uDn4tfjzugpLRN8M95NmuBYDe8VPtroUUbJMxSmfYj1LkT2UL11K7nMo8bPs/7H3zi9gN4T5PnAj4fkL7JjNvUXI9oHZfOJ0IxPyHNHF0poAgmon1GW/DExy6JKcO7j/MEQATfb22cX6H3zYvtiaQRJwMIPKxKagZ6cLba/dv4s4JRSxKFAJCs5hfrSNh7QkpwxI5cYjpq8w9PKj3RE3RsB7hJqGM37b+D8BJPAG2tTqGwcFDr0yTA1W42a8g85/ooj4OX0BrDgq7Z6CHRt41pIxqmofJLdxKH6puoAT/S9CPMhJPQM0rZw4+plnmo7bvc8ULY6edX2SYR6X13a6Sd0DE9do3AXrFhT19X3rv9oulFuy1DOuw8bL8YNQ04+0pV7X151GqojgJ5awEhfB17IeLaO3CZra0GIKfYxmGj0G29w6twcUQjtAzfnlWAdQp/wAYpZfvjS1evNk5+wp+N4bwqdFfHBeqvmtw0vC8zoYsyPJB0nWkcWK9qgdD00Xyi1QbFFu/BNgNOa3NitTbmeQS27Mw7
 r9Rg38DJ
 LNdvV+yMv0JSNdteWsNkt1sB9znFkZaLXFnl9ASi4vs1nRXbI/RboovZNjC77lmr1Xpef0qNMKuCgHW+cbSfdJTxNcmHqj/q3tgWZLZH7nXPfhW5MEktTebI7o9+4eDE/Ku/2LMQiTmafdzZwxHvLerKxbrh6IkLedhgLcVeY9Lg+1mfL6jS1iHAkUpaAOchmVyTSAV6K+EcOd165eRvYca+ovcBBXAmM8wgvQzPyDaO6jxdoR8Jlzf3MbsyuSfMKOzdoVQdTGCkqR2ilQmJ9N0YalaFvfIBBApdELu/Ec14QIij3kBMbqdgdJd/qoECZhDJ3yqq10AxXWmtbXH59scnBqeKr5xyZN8BfVC3mrfd2Vky/vtmkPxPg1tO9cv5WvPthDcQ0eQz3KeEFaUSy8UEycgAGostis20i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 18:56:11 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:

> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more than 4KB.
> 
> Here is example with transhuge-stress test with 16KB PAGE_SIZE:
> 
> ...
>
>   ok 1 Completed
> 
> Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
> helper, read_pmd_pagesize().
> 
> Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
> is the LCD pmd_size among 4KB, 16KB and 64KB page_size.
> 
> After this patch, output of transhuge-stress:
> 
> ...
>
>   ok 1 Completed

Thanks.  Sashiko made claims.  The first looks legit, although minor:
	https://sashiko.dev/#/patchset/20260902175611.1241118-1-yeoreum.yun@arm.com

