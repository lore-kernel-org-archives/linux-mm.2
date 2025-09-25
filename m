Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279CECAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5201D8E0007; Thu, 25 Sep 2025 04:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D25D8E0001; Thu, 25 Sep 2025 04:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC418E0007; Thu, 25 Sep 2025 04:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3250F8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:03:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7E1CC038F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:03:21 +0000 (UTC)
X-FDA: 83927032602.29.A5A3ACB
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf13.hostedemail.com (Postfix) with ESMTP id E5E9B20009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:03:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758787400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKbER6ieJlXzrQTxGrMtNlrwb4DEDj5K8tvKUXMerZM=;
	b=jc19lrsWrBh9qucvwG3eQvzt9Wn54iOLoJH2GKm2+OGyvC604Qdrwrfym6nrN7M2Sq4muP
	kk6AFMfPQeKjG4uaFZy5sX8jXIT9C9Z8rftTf+s0zDxVY/wWlEEQJu340oTBzreKtP0kHS
	lNUny+fr9RREvEUTw1lFQzOuOt+JYaQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758787400; a=rsa-sha256;
	cv=none;
	b=w3tVCUcA4n2QeaV3yCSqz4BvZCybthQrKGkKrR5EWByQcV8EiXSFh9kx5YuUAzbtRqP376
	9ZfTO2S9Dvca4HaCEe6EP+OHqtAftz14aamgXTRiFEuj76nMudx9LFOoa+iFnpvwBSc041
	PIafrOD1EeFGA+2tvUjTJSBnZqvpJDU=
From: Fushuai Wang <wangfushuai@baidu.com>
To: <willy@infradead.org>
CC: <akpm@linux-foundation.org>, <cuigaosheng1@huawei.com>,
	<david@redhat.com>, <linux-mm@kvack.org>, <wangweiyang2@huawei.com>
Subject: Re: [PATCH] ksm: Fix potential NULL pointer dereference
Date: Thu, 25 Sep 2025 16:02:51 +0800
Message-ID: <20250925080251.2057-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <Zzdrnod2zcTeI-Nt@casper.infradead.org>
References: <Zzdrnod2zcTeI-Nt@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.127.72.14]
X-ClientProxiedBy: bjhj-exc8.internal.baidu.com (172.31.3.18) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Queue-Id: E5E9B20009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4tffx9nb3oswu59j6zrgmmjn5huxg48c
X-HE-Tag: 1758787398-641129
X-HE-Meta: U2FsdGVkX18FjZfVoktUFPZiATwABEeVGmOCdZbAHDA1DYwRn0SnCnZLQPu58q75YmP0Uww/Na7+yFvNvUR1bTSdQL3GRAbSGDJQtSaInbTdPGTgJcqn5YXNIx1MQrDVnKxRMIRFBLzdv0yjp8OM6VIPlGJb7HdecUtaMPzUioiZVI+ZTOeTPq0j7OoyLsZRswGcJ9p4onoVF2GvKKfyjIsE1teWxrIuGFJmE2CzYvDTLshnaFaQ+aKQHrQJtgiibqUi7oJuFtkQLMpfguiK1YTiEJU4dfLzM0Lmxy61VfEEstUy98alGSPp7nfwnz4XeQbD2Wta7b34ypnMXnqWPD1vsLG/I3e5dgKiMtpZAGfCrfyDPceYYmUXHk2siX5+8AD8FgjgxEs5edMKD2vF6mmvgilobAKc3i/07WSwvBJSaJVRlFbxyImtEW4wysiZNQ6v2QMKH52c1dO8h+Kay7pzj/B1VgEisRxcicZ4678koTypY6fgmjKnf/RGzm7tKD6cggcp8rHUHFulKj/l/1zS83Put1a7QuA9zFhxyex/TvAsCMNKicEbvUejlwWxCoSYQKs/tbsR5fZKGV+q7254DvCto1VB6fi2Zw/TIny3SqU13QrarX0OGvyEGN2rEoRlBR4/nE0zmh3DcMs7HtWeFjup5KUxpYcqoo2wohV24BqMzzpPx2TAsxa1xRBRSLsyQ/fb9rcsg5Zy2HLLkgayIV6zR5MZ87WhJ0t+qWCUqPgTZVVJuN2WAVwC9PbT3/m3J6BJXZ1e0zwpJjhagmXaHODhrH1TY7nd8jDzA+emdbI1u36pEjSxlUZaOCGBwvGHetzz4UHXpwMlb8FjfOdSlmB+60FvuSW/Fkaqjys69v+jMHRwJ80w/v2VVAxoMCe/F+W77jFQnBjHPT4TRq9ROXecskYseLRSYYTa28qQjadYY6xr/ZI6zS058F4nQ8ZJikPYihmkjUuKQKE
 y1g/HZBT
 35vr8QWG/Ep0A8nX96eeNSI9iLkPYNMp4Zo2JnyVynwAyIaAfpb2RWAnEVtnfxlegICRvfZp35wKJ4qkYhEPnDWH9LPrXKB+elgecbQ2Epl8zwMEKau2gaIPRE1B2BxoCBHxoVn8BJrqKKLaKiOVRO11JIn2DmzY8DHyJjnEatBKhHpcCuA88rRRMYPpPfDWz6cb/PBTd1tcHNZQsf+GM2Ll3YxBKHI/1KfEmbQqbjYhRSys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>  The stable_tree_search() function may return an error pointer
>>  (NULL or ERR_PTR(...)). The current code does not check for
>>  these cases before dereferencing the returned value.
> 
> We discussed this in [1] where Willy clarified that there is no 
> de-referencing happening [2].
> 
> So no, this is not required.
> 
> Consider "&kfolio->page" currently being a "(struct page *) kfolio", 
> which is just a pointer cast and no de-referencing.
> 
> [1] 
> https://lore.kernel.org/linux-mm/20241024032300.2501949-1-cuigaosheng1@huawei.com/
> [2] https://lore.kernel.org/linux-mm/Zzdrnod2zcTeI-Nt@casper.infradead.org/

Thanks!

Pease ignore this.
I'll be more careful in next time.

Regards,
Wang.

