Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 177CAFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437346B0005; Tue, 28 Apr 2026 23:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8F26B008A; Tue, 28 Apr 2026 23:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF516B008C; Tue, 28 Apr 2026 23:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FEE26B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:32:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4585A16065F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:32:04 +0000 (UTC)
X-FDA: 84710169768.06.DBE68A0
Received: from smtp186.sjtu.edu.cn (smtp186.sjtu.edu.cn [202.120.2.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 25255180007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:32:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=XmwAK8XQ;
	spf=pass (imf16.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777433522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+sdw592FIeT19LKU5z1fSyh4Xe6Zu/7CnkS/siXefo=;
	b=SxBnuy++scy3oUulP2JSCBTtttwk7JAXhD+lJUaufpeqI81gWNmMi4rhaaOczKeGfKZPLY
	4rx0NP3S0I3T9gLZlT4YU4VUwXwootjPTO/LI21zlIG16mVVJeYQYMSBcdBos8qXjh2KZI
	rEl/o42aM2MhFwZxsA4DsnRQ6KyafUs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=XmwAK8XQ;
	spf=pass (imf16.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777433522; a=rsa-sha256;
	cv=none;
	b=H3E2WmJ9Q8BaR0zvzwpT5WokiZL+VaIMBf5RoiT1pdeufSoZPhcslyMkTK3amMeVPoSf8Y
	siFSjHHrxAV6LjXH4Z9E0wvJGyEMVBbebsbK3AeCX4DpFnDdNzuVFEaMPsYIZaDy6WkBB4
	lKGR0IHYJ4AEpLJ9+IaMvuSQdNW3HIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sjtu.edu.cn;
	s=default; t=1777433515;
	bh=3jHDHOMfGUaLJeNyd8AGnvQsgJYSoBnA0Hacsg+XNBA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=XmwAK8XQSISth0tOijGltJaSz9+ZC9hVRSIMSlRDfRV+D/Jfuzpu3ycfyPx+embyF
	 X0uyror0u5ADZPc+aoOw/GE0sqR2Ce0eflfNthorf2etLEEqMsgIhbm8jHCgCpikt2
	 qoL8XQaDAgzHgkijOqREANnzGVI/MeMQzYbmQbON19fwrevd843kmHiIEvVje/KZGn
	 dh6cFjOQG6I1BUS8mP7QLWFOt18ZJ23PotT0v1wXoboV0eaGc/0B3t4EyWocLlIKeR
	 mSgTzRy+ql3tiFi9uieT7rDAHKgCaR/CBCZiPVH3BsVLJkPuFmqfE6ECMQFDEt1zOx
	 o112qzo0hmzlA==
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
	by smtp186.sjtu.edu.cn (Postfix) with ESMTPS id 23BE72FF4E5;
	Wed, 29 Apr 2026 03:31:55 +0000 (UTC)
Received: from mstore137.sjtu.edu.cn (unknown [10.118.0.137])
	by mta91.sjtu.edu.cn (Postfix) with ESMTP id A3E4037CA5F;
	Wed, 29 Apr 2026 11:31:54 +0800 (CST)
Date: Wed, 29 Apr 2026 11:31:53 +0800 (CST)
From: SUVONOV BUNYOD <b.suvonov@sjtu.edu.cn>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm <akpm@linux-foundation.org>, vbabka <vbabka@kernel.org>, 
	linux-mm <linux-mm@kvack.org>, mhiramat <mhiramat@kernel.org>, 
	mathieu desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	surenb <surenb@google.com>, mhocko <mhocko@suse.com>, 
	jackmanb <jackmanb@google.com>, hannes <hannes@cmpxchg.org>, 
	ziy <ziy@nvidia.com>, david <david@kernel.org>, 
	vishal moola <vishal.moola@gmail.com>, corbet <corbet@lwn.net>, 
	skhan <skhan@linuxfoundation.org>, 
	linux-doc <linux-doc@vger.kernel.org>
Message-ID: <1453063691.2584758.1777433513691.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <20260428142335.3bca0166@gandalf.local.home>
References: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn> <20260427060142.131055-1-b.suvonov@sjtu.edu.cn> <20260428142335.3bca0166@gandalf.local.home>
Subject: Re: [PATCH v2] mm/page_alloc: trace PCP refills and PCP zone lock
 usage
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [116.230.222.59]
X-Mailer: Zimbra 10.0.18_GA_4835 (ZimbraWebClient - FF149 (Linux)/10.0.18_GA_4828)
Thread-Topic: mm/page_alloc: trace PCP refills and PCP zone lock usage
Thread-Index: SvFI4TNgE4VbTb6G/aV24V6dHLhS6w==
X-Rspam-User: 
X-Rspamd-Queue-Id: 25255180007
X-Rspamd-Server: rspam06
X-Stat-Signature: idj88cicijismw7y8mhohsxw74fqo5j1
X-HE-Tag: 1777433520-65072
X-HE-Meta: U2FsdGVkX1/C1NyNb3qfZnx3jO4HuOTabZNHTsaoLgAbRpFqCHNwMwYVdFHEC9WLiE1sTThT3Uxyxeb+qkloN7nVmmSEZwRQRSGZYdV4V4+gCeXrWh5DyFBCfNe1uWrHXjxbSe7G4yEcT6n5EdxyVt205096bJzDkFXPe9qolssKdwM+t/BUZj9skUVWbpmly38Y1aG8Fw6J+cbgQQdc0UX/HD3rUr8Y8lGCfCIty4WqDsR91wAh60nIVUl0wxQcFsj4fJm8ifFFuNUAsKmoVfdnFYfl73Eo9N2XcsL5toLGSij7wHP4BW1BA4clZYGIm/FUzoOL8PlsNG7ZoYoV4seu0SF38+wVX7NlRijvHOHwL+lacqWQPn+t602qWdEOzSIq8wRJkhjugxvqj3mj0tj9VwfKfmrC04iIklNznf7ff48e2bnZFls8jYCWpf9KGuDlcVFzoFXoy+LLy67aaTZxhC9guytHhOQU04n3MxvkJLNPUaU913ACXZETUVAeiyZid9hynxURrr/qRGCixuiTKjcSfPl7NcjLM13UJCHUQ1UHikz+g821RVFik9pbj49XTqa1oSTOVDpReJg2kxSllGrzcR+C3nZZJgrdk1RC1IpQAlkoQrOA2PH9i0snAwLtajnz6LiY/SkoXMtAApEb2uRZ3EkUmN4ADo4woJyFlLAmmGprvB2x0qP5/uPPGu/+h0RKhgxG0ONmRZVgmsxdel2e2vHqor/tM63hFPYNuH9mpcqaKxmLcBq+pi+v9nmrkgYMKsn7Kj8C/0620NEHx7KVpOpIOlpeVI3ncsX+WekLkBL1EPkPjW8lz7gulIjcrbAmdeRNFHEStdkyYq1xTXj/6yGEuYXAcBnmeIkNOfUhhfMR5tPl7XcHH2DaRFoplHktu9iOhqDg6//B9qDx4dIIynZWcOTS23EeHV4367d/CffW8ZpujrGoRHhqDoy8NgFBtQ6bTzL5BIR
 xZeaPucB
 hesINIxGy5/2UXqoHrVO5llHVVNqw3hsRu8FjHo8cHnIscr3g38moIZTLWQXBmbFSu3ED5F8n9M/oaCdGv98sZVwssjjRf3/wJKc7oVsaf5952H2CbPl4FoEzrWxdzjCy5SE5rdjCBj1ltFK6LcJRyvjEEXTO2REvKlnL6B2PT466QnsM5Ju3qDYzOE5v/zcQwG+l4FWWsOqKCDebhqar8tvW2szaYQuNKMJDctBsrT2YW1GL28qicymQ3svRl/IIzVKQODCPaS+ranIdueKtyx40unSs8VLj7N38m1RGMLWcXbbCQ1i1cZGBLWdPc1mKtlfmiP0KAYjfv5TdZVI6IDMwg6ZPcZacip0MJ9tTz1QA4tnXDiawLBaGzdwB5xkKukEt6uy+Ejh0nY6j5ngDsOxlFsKN8lRxMFfGLjwgUiNQZi4dSbzV8rwbAoqbMrs3MulXruD7WksTBxSmp1xqTbwTGnYuUIOaAA62
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for reviewing Steven,

>Why this change? It makes it much harder to understand.
>
>The above is not a normal macro. Ignore any checkpatch warnings about it.
>The proper way to do the TP_STRUCT__entry() is to make it just like a struct:
>
>struct {
>	unsigned long		pfn;
>	unsigned int		order;
>	int			migratetype;
>};
>
>Thus, the macro should be:
>
>	TP_STRUCT__entry(
>		__field(	unsigned long,	pfn		)
>		__field(	unsigned int,	order		)
>		__field(	int,		migratetype	)
>		),


Yeah sorry for the formatting issue, will fix in v3. Any other concerns?
What do you think about the introduction of those tracepoints themselves?

-- Bunyod


