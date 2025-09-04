Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F77FCA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 22:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9278B8E0002; Thu,  4 Sep 2025 18:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D92A8E0001; Thu,  4 Sep 2025 18:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED268E0002; Thu,  4 Sep 2025 18:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF358E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:51:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E571117CBD
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:51:50 +0000 (UTC)
X-FDA: 83853066780.05.16C460D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C364100002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:51:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="KAptc5/o";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757026308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=po807VyJ+I2SghnbXOMhpzu3Exhqbu4QOZ0IdFdAurU=;
	b=jVMkdymN/rqieiGFayQnk9g5XvMQjK6Zlz8T/m91+Kh74SrPdE1yZB6Pot+CRcxXLs5iW1
	L/iIcIWW/1d3UtiNXzOAPrw57wT/qF3FRUh5nntsx5nhRJPYBi/P5mKsmO6ikOCul5mIW/
	cYABBt+9OzMP2W3XCAaHJscur6uEchA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="KAptc5/o";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757026308; a=rsa-sha256;
	cv=none;
	b=1Z5wBYPJakI/Bu8eYIDix7rqye1Bnoqc1HlAl+6kmMXtK9bJ7eQDdHRZU6TLFJf4OtsADB
	GFS2ne24OCmcqDJdA/gHDR6Dvk5tAA8PB8fI+f5tOkFYeixjh4tlwGkg8iE6G6NdBh8Fe6
	08KOusMNqHF//wVN6XBN0h2NF941wyI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1085641B09;
	Thu,  4 Sep 2025 22:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A57C4CEF0;
	Thu,  4 Sep 2025 22:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757026306;
	bh=GxIJv0HU0N/IVXtBR2Tafcha04gFmN62hz41Xaz3ebA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KAptc5/ow0L8NZ/HhSobu/rOexgQf5jdu6+4K2GUnvKtK13PJCOIOiMgKsgvPNJxm
	 qD3hM99Dt7XvDO3oX5Gn8zuXHPkS6i68ADKoU8mrq94J7u6wXd780pJMvo2V4HfaHR
	 LVmWOYkF9rxAyGavOlcTMCodISo6Tsvy770RmT9o=
Date: Thu, 4 Sep 2025 15:51:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-mm@kvack.org, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Subject: Re: [PATCH] mm/percpu: Add a simple double-free check for per-CPU
 memory
Message-Id: <20250904155146.485ab7def1b89ed7317b76ad@linux-foundation.org>
In-Reply-To: <20250904143514.Yk6Ap-jy@linutronix.de>
References: <20250904143514.Yk6Ap-jy@linutronix.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C364100002
X-Stat-Signature: qwperb3dnumf753beztawoupndgwohi4
X-Rspam-User: 
X-HE-Tag: 1757026308-171154
X-HE-Meta: U2FsdGVkX1/2Uu/KxdelHGAockpWHEnO2dmIpMzTxXtU+Po4bgK4RKFWAm4mepATpUJrULtDpLjhYAD92ejJbuOahugnTGgIOWDNWkyyBbtpqZh12QDTC46xeE3inMFlBOh8bY+fzIH0Mc7L8E+mklfVEQxvq8i8pQCu5T/NxIQArv+UvEsZsI/407w1s3XtQPTBYy1f9DStcs55acRxTFB87fCOck81eBJjHiIqYNn3DyKwSgh4DNsz/B+PAnl3oEs/ZhKxapRINe4fqhLMTXcGQgo+P7yqiQdQa/H4nN5ZIKzNvY1SGRNCUm7WogMmkE2aSKS1FGt8rYKbRr2mhWZ5+uIFtHu9O996AELLp16wsy7CUHdHjPtEADa/HZdyUd1kWaywzx3ikdNtY1GZsbp0YkkoYHF2hOrX6MGI4ruIikUd/21L79dFGfA2sb9MPgLEZctdoG02Eol6Gja4WYnvx/WITqxB3yFcoHwPYV3c9kkfsWnEI68Y3S2bTPuDX/dSx9fkoJbJpwkRk2nUFrgVJDjMbMBYEbVobh8aQNNYRf2zpDqxa0N05oAGgRJkzvFEcbLGnQuAgH+xwMvt2AX0g0GnGmexq0UhpHBc1eTjzLB1bTvjyT4dPG1hoVp4UXGI/LpeuPIVJfauh9S7VAE6xY5kqauxtWpuXL6Yjxt8qn7IAbjtLuHQ6aEnIk2pFS7p4Yqk2LwCw7HtQVQFL3TxFt1vo2ne8M3nXBl14FRz4EJYsJvjc60lugIdmMThLEN/FG0Y8o+zbQlclv0drlPNqudnteiLkmqYdkolrsIR49IZbAfW+sEgzUNjiX9FC01LkIHHvnACfry/IiqHyNgENAqa7wUlA2H4bT2ofFUMZmH2HrOHyNmjHzogonhnsYuX7PsDw7BmHmfPhRKwOSr5R7vVM9Rb/fowKOaC7qMMM20yTntQKLL5wVZSFBRh+QDr1K8sSC68p+rajQw
 3Gyyq3F8
 CFSDge/NeBOzGISkLSuiOIJ7qusxil4M1o0X1lTAlUTXlwOHfeGcwCaZ24LRQs6SQcm9UWsNiFERYI/dSLsAEH17HB80WrKv+LFrua7CIipY1EpNKwXIQ/vccFmIjPBIDqwwBWJt+HjACdw2a40zM050ka+GtETly06Yn88gcoQJmCPMUxMDMRBbkM0B0xPQr3th+dpgZQNJz8AkRbQVk/UHBnPH7060bWgbEjB01HM03D8JqYndkLOhaGtYqpt2lr9fsXD/Te01U5YNikS8s4ZFXwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Sep 2025 16:35:14 +0200 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> The free path clears the allocation bits in pcpu_chunk::alloc_map. A
> simple double free check would be to check if the bits, which are about
> to be cleared, are already cleared.
> 

Nice idea.  It's hardly a fast path!

