Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8507FD6ACE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC5C6B0089; Thu, 18 Dec 2025 06:15:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A5F6B008A; Thu, 18 Dec 2025 06:15:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC14E6B008C; Thu, 18 Dec 2025 06:15:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B930F6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:15:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73FEE13C337
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:15:00 +0000 (UTC)
X-FDA: 84232334760.20.4A16F93
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id ACD5D16000D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:14:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766056498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+//PyAcvxFEdjiuSTcAjtzMvdUDnD2LBNnUYEFrdrE=;
	b=LdBD9SiW7K39wYy60csXtcnNExQDfrnG3f+YtAYzc3yiVXgkpHOKve4qxX6XTsM0t47mqi
	5KHynQMYPKqYGygBNoPH76CKHFs3nvFAEQRHj/Jt0Tjr0T8mgsQc5xgQcuFyTSvCaGQ0S4
	qNnQKOioTlPyTLRRUwKrpq8Aom4XXto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766056498; a=rsa-sha256;
	cv=none;
	b=xxjSsoo2EvGlKPwDNZ9NY8nE1DxwXC+fIjZKikwTt6TcV6Ldh53+TmF611QU95Ii9FV7Lt
	Xgv2pufQGLTx96PvOUWD4hu11lTyeX9OoI0Cee4DC+8CPOn3ZUGcoETfL2/AERIW3f5l6b
	sf3sJWWGGuO+OfriJIKzKsLpJ3L0jI0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CC5BFEC;
	Thu, 18 Dec 2025 03:14:50 -0800 (PST)
Received: from [10.1.39.180] (unknown [10.1.39.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB3983F73F;
	Thu, 18 Dec 2025 03:14:56 -0800 (PST)
Message-ID: <026b42f6-2f83-448a-9b45-cc8740dd8d50@arm.com>
Date: Thu, 18 Dec 2025 11:14:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Content-Language: en-GB
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com> <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com> <aUMNyfeoEh_tJHpT@pc636>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aUMNyfeoEh_tJHpT@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 54c9r8gb47ez69nj4waw9hbfengkac4s
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACD5D16000D
X-Rspam-User: 
X-HE-Tag: 1766056498-393151
X-HE-Meta: U2FsdGVkX18Fz+xQKQU2SezWhclRHqs2DqG9vDtC2o5LMvc/c6mdrhOHfs98qZZOQUVwU8ENXJ0+XtWA6SNYlW5e23wusbfZ6TjApa3mUi/7KVN96Ov55eC6suV9lVIYMEmLKnblm/Row4SqnuYxxm+Bk1mLb1br/27QbnjqFbIsBfRXGUk1dh6yrog0bo/E0hGrTYoUmj0kL5TdYNAgGLcwB41tLqpjJV5zoe7/WAaziLZ1oU3mchUi0/q9kfVcjQ49dwPM6F5B63AAOFrH7MQKK0pmnXh5mCA10ILpPtQKuXOxIJTPeMdcFkuPmXIww8Me6L/hENUSPtA9k2BHJ3v5vE7Rw80576HXXmlmAvEviNhGdfcyZ2ZbMYTIhcBJ1EVuoa49zdWdj+xBq3BlatcP9W0uo5/gJw3OTTEpdPKC+6+lNb2Bw8aoCvwLBdnee/uprkZ5FZyyjnS7b494GqgYcdG5IiDFDnJE+xiPF2j0SzSkGbWhJknspadXLRxBhIYeisfYBVR3SMyAIwEPUe5Zt1KzY95ZmpWIUaDKWNHyHQzoi09Mx18WKhix3S5grou/47G6g39mBn+FWUZd2rTIKBKKBZ3fJg5XDQPtvtCNCtOvBy9bEBFm6PbfCo8bobUVf/VJgnbOsOgrE3fp2s79IWqagPwBEbckVDibpJv4KAE9JFYO6iJFF3bgEBIBl9AXorU3UGgXptECJw303PlAwmTahR9Pe6AKBRxtBiY8JLfno9NvSNoMNcAgtyclz6fk2bvmV2ufaDUXFWNLvpQGr5nBs4kmCwllmhLTHBBonxNdr+JLoeinzep49LvxI47s2iWgthNGzNlhE5sNud2v/tJjHBOFJV4s1VmnZ/8Q/ONJkXaAWZn6F0ECACuelns1qrRWzsgg9mCFzq68fuf6xRtrU8TyjqpoW9D3lF2myYqc4zwFeOC3nab6KLHF3Ab5lAS9WqI54LIbW4R
 5vUvZqyl
 P+IUEVE5o7UzVY+6u6gIUDkCAM1w9ezTh5/kJ7mYSJu1auHTmnfSy6yQC3C05NlIU5WlA19Yl0otb2RyCLgIZQD5fFim5trvDFbgWlmbCehxZ8pYUtFfC5QML+Gf3AysyNGTnq1KiVmBbd+snsLH9gJDl0Tf2HYYWPP4bjcBa3OfQdglwOYFGQaq5ebZQu9JI7g0PvNADBlXE6Mu1aBrpHm2xan+Z9rahQ1VsbWbxLfOVqgk/YULAUz3F5zUTN+5C7saN0vAzIzzSkDD7e6aLICxiseZ4k6R8UkgT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 20:08, Uladzislau Rezki wrote:
>>
>> What do you think?
>>
> I think with such big improvement we do not need a configuration knob.
> Your change will fully complete Vishal's work, i.e an idea to allocate
> using high-order pages.

Yes agreed. How do you want to proceed? I'll tidy up my patch and post it
properly if you like? (likely won't be until Tuesday though). Or if you prefer
to work on it, that's fine by me too.

Personally I think we should aim to get the fix into 6.19 to avoid the
performance regression (even if we think the allocation pattern of those
benchmarks is not the common case).

Thanks,
Ryan

> 
> --
> Uladzislau Rezki


