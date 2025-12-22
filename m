Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3CBE67810
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 19:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BEE66B0088; Mon, 22 Dec 2025 14:08:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CE66B0089; Mon, 22 Dec 2025 14:08:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EE16B008A; Mon, 22 Dec 2025 14:08:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59AA76B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:08:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08D691A036D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:08:18 +0000 (UTC)
X-FDA: 84248042676.05.333BB1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27A5216000E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:08:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EKF5GeOi;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766430496; a=rsa-sha256;
	cv=none;
	b=Xi+OvWNAapiRUEsglFJGwrVutoWj3SvAedmY4uASIJ5xUpm+V+vk6O1g8VoCMMVViawh1n
	8rDZAwqaapOhOGBjACaEcGJKM4mM1mFtSZLxLN4hRUoUCFD3uZhjqSExlU+AG+CgKiTKTD
	B7XnUo+pSDUNHa/7AyTl18E9TEfYsIk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EKF5GeOi;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766430496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJOaEz/o3yvfzAc2gn3cjkik0dBBtnrFlxwATeRuDAE=;
	b=EbHFDsov1q0pLehS9CY2+/eRHvWWNR36NsVKLZLgjhZouAMpkCaN+1N4PdwHihecFfzGze
	gEDkw8LdH213LupJc9BTV8yRw9tBG++bYXxOfKN5Cfll4VVeLy+/3gL9aIZYbSA6PxJMvI
	AzDIPAIe3+Kn7IYmsJegEziRnRTB7GQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D52A440904;
	Mon, 22 Dec 2025 19:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7175BC116D0;
	Mon, 22 Dec 2025 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766430494;
	bh=Gb3RFjZQ8t7BxcEou9Uz2XwHSIj5SHa5Q1InugjLUv0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EKF5GeOipp3kX1ozPFWa/ZETbsBmwbuwImUk8D5rw/92gNYdOt4YBhUQYWUr28bkf
	 92VCN8JLfCUAJ91oeio9y0OZ1zeFAPzZrmGDMd+5IeHEL06aC+LQ10gN2hcGFlIgUD
	 8ch3Q5tHsypgAmEIW1DGN5mecl40tPIQ1Re+k0bM=
Date: Mon, 22 Dec 2025 11:08:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Li Wang <liwang@redhat.com>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long
 <longman@redhat.com>
Subject: Re: [PATCH v3 2/3] selftests/mm/charge_reserved_hugetlb: drop mount
 size for hugetlbfs
Message-Id: <20251222110813.3d353b8c49b628e4997263e4@linux-foundation.org>
In-Reply-To: <53e302a7-1c78-4b76-87e8-1cc10c76535d@kernel.org>
References: <20251221122639.3168038-1-liwang@redhat.com>
	<20251221122639.3168038-3-liwang@redhat.com>
	<53e302a7-1c78-4b76-87e8-1cc10c76535d@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27A5216000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 3s8aynxnaqgefom8f66euh36sggidstc
X-Rspam-User: 
X-HE-Tag: 1766430495-44875
X-HE-Meta: U2FsdGVkX19U/f3Klg9f7dIgOrBV+qdVN77fVW6uLMQTiapcDrkxp6IDsgylaGZYy4qTA1Iui5TTRuIeH8vjXmCz1X2jtkBB7TKGewHmKeBQIRRGLlsiVrBWq3SpxYgxERBQXTwPZKuEbovhSla3oJnUC/3nfHpXJP5eWMQLGH6WboNis1DAcbQbkYWElD2SKLZT2yesSpH/ungrdzRf2QcshcqyDiJadMHooasoPTMeOCXraa2grEpFyCNMVWYfs2hTK0BqxMiRKqFc+NV9dYRCM9IZzqTxailsezUPAp1KXRS2aftp3fmCOHfY8FBFaX4gMDUJSicJ9rd6q/Y69qyz0zquRmDkkBeihoH+rOzTGPfoG6R1c/tU45ZbpOj+pkAzoGC3+wTLw1b7qMAIkuZzVNkE6IRwHeZ0mnnnkM95f9tio2zhGWDkhyUGNUE/W4QRm6SbrY32NFsLSwcfvyEFlCqBUek6dIa464FoU8gP9bNu6yk5LJxmZyfe/Z730Iow79C86BGCaF1poNHQvwdFxp/LC6e4Hs5KAhHnHiGg7dVBCaKC8xxTrg7F/kMtutXySfgwfAn9592KDG2SaJjNVf1lJPUt2BCeJAZo4CO0ayEMYSDBb0IbyRCgS4xJUEfK33G/JMPoIrazSza25nroa9MS4qZjPeGLRF+M5t2B2dgxnEC6mMGAtVZAgfW+WW+2yLY7t2khaSQzU5KFPr8pCTmxE0Tw9iBoQbvc6a9/BjZBsc4cSTwL5I7t4itwCqMxe729HrBie22fQmCe9caVpnX5JYXxhKT4zmM0Au+AWdGw9YDun3HeaDPmZu1tpf1sAp31qRkQzI5ovqxuXJ9oz0GnZ6083xo+0EGVE3hsq7H3VSP69eR8ig1EmDIqnxCeCBmmFo4/Z8vSA4WsG8HJRbxmhoqQ1vAk15geudjA7k6I8yTkz6NSecs6GZY9zONf3qCh4UYzl2ZyzcB
 rr1W8/p8
 p87IFAvafav2HPWhhFy3cPSBhCaaI9oeuBRIsvm8LlBq3XZFYrU4wZjZ5qD0OjtCqy/F0pEOHSTYWaAXeUU1QfWl5R7CCu7XMMndqHsYSvqdH4uyqqfjfw8j72m0HWj2JdkDkYW5KYZ8n+hK4va0ba979zDf1a5TjMFoHzQcuDPgCI4zfhGERe60eUDldL1HjRoirDeWHa0+AMkomWqwdxYGPKMyBAvV6TZCTZEGPFfMWPSO8yJ99AQtetCSUyArQXkRNDFcIv2NPbtoUtRoUZzZFKzfXlk99GoLqEoQ/FkLiq5cUl5J3+nwmUaZPVJ5GrP0VAdbfQ8cfcESsjWEVEO76JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 11:01:17 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> > Fixes: 29750f71a9 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
> 
> Likely Andrew should add a CC of stable
> 

yep, thanks.

