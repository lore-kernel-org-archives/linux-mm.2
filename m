Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD23CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52B98E0012; Fri, 22 Aug 2025 15:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03578E000D; Fri, 22 Aug 2025 15:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1E78E0012; Fri, 22 Aug 2025 15:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4CF8E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:57:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08CF91602EC
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:57:30 +0000 (UTC)
X-FDA: 83805453060.23.2027026
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A25340008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:57:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ODGNrnMN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=martin.lau@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755892648; a=rsa-sha256;
	cv=none;
	b=oKK99rHxS93qIADcsvWKKQB9ZuI8CGXezrsV3LMXkwSbkSPZNnQnBN2+Mj6G6Po6S9gF5U
	wjmKGIt/q+QZgjSkudeOohgluAZCDXN4r73BnIMQKtIeOrqRBSHqpfZlpCpSLcprPRpxzH
	mFmGDtMTX8l/nyO4k9wREl2AkS2uP54=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ODGNrnMN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=martin.lau@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755892648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgGQNbQpaeQ098wkm4u8zP/FPMO3eRXDhj7ceqGRxdw=;
	b=mYtIyRObm1p1p7aN6XAiD0i0VcoBZMwdyqBM9SoD41q1DOOaKrEsIfhoc+KfSXbcUwlzcx
	+Cz/1HCiZ7ix6GSA7pW+9LSn1YyRCh/QO5SZHhuBdCxBKupojRj6vxoZDpiknEWdPfcHyl
	iCMWPdVC9lpyIlbHwTA22TF9AoGn+/8=
Message-ID: <c1b71664-91c0-439c-9cae-7407fa5b0358@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755892646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OgGQNbQpaeQ098wkm4u8zP/FPMO3eRXDhj7ceqGRxdw=;
	b=ODGNrnMNHi2fujrx4+KsmthVVSn9u3cTP6nkLxG0DlNYp+LN3E/HrXxHfWYO2BT+CZD9Nc
	jaZvG8zngg+a56REPHlpd6ksHZV60H2jnm6PZ/7//7JEIiNMSwAZUrbNUKJI6VYu0IyGlR
	MDJSRYPVSI5eZbQnVtoTEGn4UhgGcjE=
Date: Fri, 22 Aug 2025 12:57:20 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 13/14] sched: psi: implement bpf_psi_create_trigger()
 kfunc
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, linux-mm@kvack.org,
 bpf@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-14-roman.gushchin@linux.dev>
 <CAEf4BzaSLWB1xpCjX35oxg2ySvvgRvEmQ01PtXv+xEz-Zkz07w@mail.gmail.com>
 <87ect5lde2.fsf@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87ect5lde2.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1A25340008
X-Stat-Signature: i6np68brx87uusr15ie9qcrb1t8gr1xw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755892647-632406
X-HE-Meta: U2FsdGVkX18tNZ8z/ptZzdJ+T6mhnwt866aNphM55xXup/pR5K8VwKE8sQDsMC76Hpw+QAw45oLqSIBmw4D50o33rEOvy4pPFQPU2NfXna+MEYdjgHUUCMut+2sBZdKS4wuYavk5MqijzIu+h+/yk77emktLDKCMpJ4AYbtkbPBHPalLMee4HCmPQABUO8nYoLuZWdhld4naGXglo5Al77qVAbv4EL7tgNr3wRibDGTt4sGIkNNDI9qMU6BTstPqSGleNsMvCMZToSEsOLSGZmedoST2LMXYxmdZMt1j2DKvzqTNczL7Zg4cMxSCZlFvI4e/lG4Niwl1gXfHkkCOKr0RSRaZ1JyjhemsIRXPVvpiuMvAz2fIxrTRXs/jMEOMvP+01AAjrHRJj0F9m2iq6eEroONct/6gxSNUmLqePKbxOzdf0b6DB40wu1nEn84qbGP1OYo+mQLTHRGkDGqYHOE2vuFfes1iFKbeUee+P0FngiXbjBc6cWwQ5a7kOYrYIoz+/wqZ2ScrZqV4dC5oDpHSiELAseHQH6z5y3MgkJSz5EIZvod79nWDON7wddsTY9H77k9hjxfv3bdxagqg67XUvBWg2pkiO/hHagp2K8Fe33lARvoW+Qog0NFW8VI9OsL2BV1PRpl9wJOCAHPEabV3uPZJMN3NC1JXhvHZo9v9sWS+bwFM4XrV/6eMFEBi5q5/XVI0DkMBlsndFQHm5LQVszmZVVnQcd0IJfD5JEYMDLD83kO3Mzn9aOb7QPU0AWr0uUB1qEDgjNp9pif++opVunb9krbQBQxK96XYRDqizrVTfMbA//0uCj/cBNh852pt3nJBYbj4bL2z4PXolWyE0k5Mz+KluNu+497BUQrmkqBeVTFJSwzzqXOBJBT4Big6LqjBmFzU8nTXPwURdjZIuDKJsW1M/zS0+wOQ7MiKQnPNNB7YCZrgx2pqDKNa4M6tLjkmzGu7eEStO5s
 bQEWDqmx
 DYH/dy3BvAYGFMfCFIhEw8EvxbTpgl4hRxoY4XB1MUaSZtPBIc8vU339LAzwEr21+kPw2Tz9axOuwjMpwkA0hSxxBJyKXNYPwEfLyj0hoppDgFvcm8FRPfRHR+J4xH6+4giS5qt0gUoBN90ICiFBwxwYH7pCtSV0whrlsOwtijeS6Wz8dszGbFHa0bDquyPMMCB+5TA8j8tTxs2KLYsm3SNsiwQL/kVw4pnK37b4sckRUZXY42qm37m9qpr4YgrmKgYmM4DGJfH2yu3pP7mZkx8h2UbWy/ro8SzM24p8DjWhn1HEQbL6xbHcLvl4jfjjr/OSF1ClRf0dSYTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/25 5:36 PM, Roman Gushchin wrote:
> It will. Idk how big of a problem it is, given that the caller needs
> a trusted reference to bpf_psi. Also, is there a simple way to constrain
> it? Wdyt?

The bpf qdisc has the kfunc filtering. Take a look at the bpf_qdisc_kfunc_filter 
in bpf_qdisc.c.

