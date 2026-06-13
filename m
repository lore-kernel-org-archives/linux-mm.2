Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6E1CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 04:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550CE6B0005; Sat, 13 Jun 2026 00:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5016F6B008A; Sat, 13 Jun 2026 00:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418286B008C; Sat, 13 Jun 2026 00:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 337F46B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:17:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D2ABA02C1
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 04:17:50 +0000 (UTC)
X-FDA: 84873581100.02.E4E15F3
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30B5340009
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 04:17:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xJza6x1T;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781324268;
	b=GdMWz/F3k87cX8UNOnymDOuQPDXCo8tzxKjQHuLbrqpaV2qI9Wb/VY0XiPyq2azf5J8/9V
	uejXZS6282P/g4BI3wnKakQnRLLFIT9zkTfi8HkzFEhchnT6xltTFeiKU7RgFsE44phPsU
	a0HN/jd+Af5jL7WPYP+Xiooz3wzlvlM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xJza6x1T;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781324268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcQKZ3Zx433YnbmCCBs9ea4yshxodmQHfHdKd6s7mwY=;
	b=u+yl/CCKPhCHF+N2/ae4BLK25u6LzpaN7p4pNgyW/bqMsul/4V0viyYWF8tt4D+CiRva/V
	hvMTlfYXt/X2AY8zdKuFgyqPxL3sfdnNXYZ4fLQZlf/83V3HFlpz2JjEsYly12PJnfK0PZ
	YmTcJOSSRKy6Vo6PMEZsnT7P3z8ReKg=
Message-ID: <661b47de-af1a-488f-a691-82df7add1f49@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781324266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lcQKZ3Zx433YnbmCCBs9ea4yshxodmQHfHdKd6s7mwY=;
	b=xJza6x1T5OLJx+L4ldxhJ8F/UUA3Cmze9+E8XxRLhbAltPSM7Lg3gqn1gccCAvQ0KTXj6v
	eTvbvyWlk7mXNOH1AA1jhha5L7nIh2ELAYX8PUJ31Nbzume6UXYMTxplNl/YyYkx2htjZD
	rdqoS/ucZjITP2QQHjZvtoZockmzkZM=
Date: Sat, 13 Jun 2026 12:16:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
 <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
 <ainCu2HZTTdP4skd@casper.infradead.org>
 <11cc4dca-7841-4897-8665-e27d7555f246@linux.dev>
 <aizL_QrL4dNWMJ8Y@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aizL_QrL4dNWMJ8Y@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 30B5340009
X-Stat-Signature: gqtcmo8xppgg18zyiu7qxepx9rtmrg1i
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781324268-502493
X-HE-Meta: U2FsdGVkX1/Y5lEqZUR6dQvnPVAmn3QLlWh1Mrf4iuU+z/HoKDWtEUn+ukuw4Qs3TDFetbFwyR4vfgLAzqsRNRqtFFGaMaaJPpGYDI6rKm4IfRKJxRL2UlE1lv6jHZX/OPSx4zNXxdHdLvwuWk7UFNzjEWBtEVlkGLbwc6yCoOcZCeHFO1skHACZyMfdLLDCNmGpYnuv0AGXFG58XJt2Uq2Z4rnpmvIHrgjPeSXukrjL0wqRFHWtrQH87TX2q9ZPD+3lqsMMqOunPO8JX8gX0dvIUuLT6ZNdof6/5BYiGNbJZ1OaHla3p0pjgPf0pixkC6tUlM1LGJSrsqm/utyail6BxxgFZ0yNm/dYbh4bb+rx1Kb49TCm1jqEqG2NsXZXwfODUbbeK3YZGvx+oDnw4lDVTb69c9qaEDKdVwBg9FtgyKpYTEXy44WcGAcdeZ0g+K1gTzwoG9Rcig1ckpCFPQnfZXVarKJIvnPPgeDXA+uB1/Si7Uegqej+wGzb6iV9AasWomZ5UWMt1SzdC29zBA71DN06K6JkvyZ6atAhpj5GPDgYObPTFqgJbuSEWU+GU3oy78duuZgGflruT4CyE+K9s9tqxgztdcwsa6dAeDPiUSGeRInVSZieYTEhWOrKx/dLZjhBBy283A/FX56AjGyq3zMP9We6LLxQta0qhIJmFGVJ57Z8S/GqVQNMxRq+rj/eETE0nGORC0i3GxR5gR6hOFEvsaUxH3pJFFhkVt8gTZrPMSWZj5SLQm8sQ5k/5on7JpcnVU+0acBgjbfQSplHnyU5EdtX6cgg7urIeVT0ktddXcJKY2Ub839BzVCCJ3ec9hAzlX/7U59UvFacf/mKSpDd96EIvSZoE+y+t1GrO5QxtwFOxfYdaQbmzFhztFGAiKr6/b3f9FialItA5ZhGzt/nkd+hAz7fpLcaGnh2+pSReCoCEjTcNGhT/PtrrlxRqYlCFsYMIoR++uu
 KcpLCd+2
 GdFYPWtibt3/fNXK7gZgJ9Ctrx8bUreRijDiC4MWgZUG/CM8a6B0bJFHSATkGF7FgOrha1aq7+X/SLpIuhzYTkOHudJPkeeIcXvQS5jTrdVC+lys13zTk1r7CgDXfU1cy6yqpwRHqr/wQjuMjEfraeiir7GWLUrrwIbXi4iYoA0kdRXJvzOHn59G1oQwp/HJUDrEpY//ncteMWB6FP7Q+FFNujuWb7BM+bsXNOBXCA/S3dv/FcrNwY05px9UMIq1WH3DspVE6sST9lYyI2ErTtNIVPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/13 11:18, Matthew Wilcox 写道:
> On Sat, Jun 13, 2026 at 11:02:06AM +0800, Ye Liu wrote:
>> 在 2026/6/11 04:02, Matthew Wilcox 写道:
>>> Thanks, but could you explain why you don't just call dump_page()?
>>> It's more comprehensive and will continue to be maintained.
>>
>> This script is based on the drgn tool, but the drgn tool does not
>> have a dump_page helper. What kind of method do you mean by      
>> directly calling it?                                             
> 
> void dump_page(const struct page *page, const char *reason)
> 
> in mm/debug.c

I’m aware of this kernel function, but could you please clarify
how to call it from a user program?               
Or how to achieve the direct call you mentioned?

-- 
Thanks,
Ye Liu


