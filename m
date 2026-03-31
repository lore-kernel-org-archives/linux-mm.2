Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADFB10F92EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA846B0096; Tue, 31 Mar 2026 15:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D28D6B0098; Tue, 31 Mar 2026 15:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F666B0099; Tue, 31 Mar 2026 15:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 421D36B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:09:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C414A588B9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:09:06 +0000 (UTC)
X-FDA: 84607295892.09.CD2921F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11F6516000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:09:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oTf3JL2g;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774984145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xHLvqL41jJczvGqWyFy4o2I+NK46QJqQS9pQpsIhvI=;
	b=fKLeEo4ibFN8y6fTlTYGSysy3ltFtSjTv1RNL8pS1MGjVlJABJdy9KwXQzlGrT9kXfDTX0
	Cm90ZU/PqCiZs9Jr2IjiIvx9NseOKHZhrpjOvkd3BqiMY0fUGiaiEznr0DYElNFKyIcKGO
	sqW5zqvQvibvfqNEX5oSA04ciNq4z1w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oTf3JL2g;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774984145; a=rsa-sha256;
	cv=none;
	b=Y8INfUS/Ec8WQZImaVPWdTzB9On/zGQxHLMU06mOaVQntOldDFC9FcBGF15kpWFtvd7Was
	qc+6WDA0Pgi+Q8TJp5otd2SSiZqpAzTcjJbWK3cibUu8xlAf9z8zagNuC7LyfI21de0s6i
	RlfOB3R69/SmyuAB2yYSwPbk4zMf+K4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F41C740A3F;
	Tue, 31 Mar 2026 19:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F22C19423;
	Tue, 31 Mar 2026 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774984143;
	bh=aT8JOgjONmZzx/QF2zU+F5/Wk2NTNA6XO+QVlZpW9tU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oTf3JL2gOmrpgvBrkSy9Ej7UnUGGFlem6O+TaHXIwUEjpLU+SnTU2k4MMdPF6Kynk
	 ohedPz218fy+rP/fkvO2pbG8TU+keO0V0x/xEQQp4OAIOp9uIhCP/ACFCMm9VcLi4x
	 EHGARYmtUET/In5hbe9QP157321/mx680mor8jtk=
Date: Tue, 31 Mar 2026 12:09:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-Id: <20260331120902.4612d93efb89f71a0d79bb5b@linux-foundation.org>
In-Reply-To: <acuijiUs81Z7qYSL@gmail.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
	<20260330151503.670415-5-chuhu@redhat.com>
	<acuijiUs81Z7qYSL@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11F6516000A
X-Stat-Signature: 6pqec3agut65xssubtnxmbxhhqd6eeb3
X-Rspam-User: 
X-HE-Tag: 1774984144-231745
X-HE-Meta: U2FsdGVkX1+NrVHgYEY2nd0W78Vh/aYFxxutFe01a/ofMtjSt+FMslkmIdyAEralg8W+asYVXBrF8wzRFLlbQTf+8zPisBmhDT2lvjgS4y16Yh6MtpkwEM1akaz7mzLCLD+V5yZo2hHoK8Tbte01BZANYGBQ4ffBFPUD7QbNkIel+WW4lUp4a42o2FwOQfOicOdZg8VCVvb7bDJS7s5gxspZjnMma4GXYwfPGrJb75yc/efZUf5Odn88nD9LmC+DpdQzA0GI78Gc4iI1YNNYN24v/eg8KvLbVk9H32pso7UDWiU9Peo83ggZfgHvYT5qXNWVNjaoa8evrC1dL38TwpWAdF+XgCUQHKjmqhmzOO202qxG8wfSVklHXbDVS7jv9UPU3l9pZUyLLrWxbTT7w6XMCIPAsZHE7OziRCnd74Fl2NuHtK5mfHZkN1VtLRI7pEDlq/7cHbXJKN/SPdXYtvDpqUqRL+9ws70tcgeNbOsL8JwJmwXu1YlS5Hdw8Lr6aS5HrEbboGufyDS0b6zBxejwL4bC3P+xCU1oClRHRNupCacxgnMpqHw3r91X7WA9tXNgoNcs2jVuwkOaBpaZdIaBVvLlsJhC+l1jUwIU/kcLLM+p3wOacJo+c6TmOHsBOQfYv0VtS1bUYIexoaBY/CIKs9R/KucQrqiZdJFjRIHzocLBlqhyUZEXtsIl/bFRrCxDg4uJzaY6G0vsWk0GUQQsb1wiNVsob7jBKyu9qmenBHX692XUGacV1t+H4FE9LcEMFRYg7k2q0vR29UWlwUhwSJb8UY9/jc8uf8FDp+MrBs0aGvDhyIU9V5OLNLLSJFTEiMdiX99CtX8qnHiiDUFqaEhN4w4Lb4h2VGzChwVore/bHjwhBtuZQPWPXQh0+fmdagfsW8K4f86d+ZhuPFCyaqJxtUatP0cpW4RPtO222+U/8tcavev014mzSznu+tyTwCBJKgvjl3YRk5K
 WhkJVxPI
 BSZms
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 18:31:42 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> > -	ksft_exit_fail_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
> > +	va_list args;
> > +	char *buf = NULL;
> > +	int saved_errno = errno;
> > +
> > +	va_start(args, msg);
> > +	if (vasprintf(&buf, msg, args) == -1) {
> 
> kernel test robot reported compile error on this, as the vasprintf
> required _GNU_SOURCE. Looks like it's not appropriate to be used
> in the common header. Looks like it can be replaced with a buf and
> vsnprintf instead.

I like vasprintf()!

"#define _GNU_SOURCE" occurs 402 times in selftests/, so perhaps we can
find a way to keep it?

(err, *why* 402 times?  Can't it be just once?)

