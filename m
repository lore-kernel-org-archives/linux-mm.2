Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE97BCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA8C801A2; Tue, 28 Oct 2025 13:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B4F80199; Tue, 28 Oct 2025 13:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89814801A2; Tue, 28 Oct 2025 13:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7836180199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:59:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30C604978D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:59:40 +0000 (UTC)
X-FDA: 84048285720.13.3AAF020
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5079A40014
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:59:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCWAmEM5;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761674378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7g17JYwPJ5XpNlfo7q1lNoeZclw3CEprpKdF+EeuB18=;
	b=1ROurGpCJEnt5j2WG5YWUdJi8vRcxEPrFGM58TwNf6mz4q29vyM785dz24M+YPs3J1wZdE
	2xQUMuMP9YRiTLCNDdboRLXjnJiiO6G6cFO0pQEeGPE7vSj8MYelLc6QUD5hwYkZYyXaYv
	3Cw8Nn6jSpaZegHZ/5mqhhD657oxsBI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCWAmEM5;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761674378; a=rsa-sha256;
	cv=none;
	b=OnehWN0TrF+mCDwwUpdor/hWNXY9imFJaZMWN0Clk8JZDHlgqycV+6G0rHbU/dm2GZuINm
	6Zpqeon+670S2fy32y4K0iU5e22v/D26kaLELafkcegtLRovLMA6HMU9yUrDr+BiJqms01
	tqsA9MYUHXETJ1OF7YH9/GJ2Ba94jCQ=
Date: Tue, 28 Oct 2025 10:59:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761674374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7g17JYwPJ5XpNlfo7q1lNoeZclw3CEprpKdF+EeuB18=;
	b=DCWAmEM5kMQAoqJKRxfn8sRG5ESoCq0u6n3lclOlIDLfIhkiOVzzyuhgSBwh0MQuOM1q35
	sK6i4zEDeQJPRni1K8QfvayPpdAjp7vKdbrgaVF4IjOUsl3FlO6YkurXoLbIH2eDdwQ6cN
	LajKYnDwHySHdt1HnkA9Xv3ZwOwSy6o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vma: small VMA lock cleanups
Message-ID: <nt2rifeuokz73xtzqycguhrvki3vpi2pb24tuv36h6m2oz5fsv@7g33zih37yqx>
References: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5079A40014
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wkdsw8umm4sk4zq8fexunsmmbp3md97f
X-HE-Tag: 1761674378-964040
X-HE-Meta: U2FsdGVkX1+U3a92G5UtsUh2Z1j/vsspqgqXH6QDcrgQ5MY7nwBXSdyO+v+chlZdtA5MYT+6R5cqhYByTBNNBk89Ry3iYV+NXa94OSC3aurvxoPE/x13x1VM2eGtLA7MEx/O8TQ6I0IANOfHsqNUrn5QYuHTZbZzfPF9bvQjTFLlrlUnW2gxuaBBMkQjX6i1JeGSeV0JEgSkkfcpMTYtUicnDf5vKogOOuQvUuFNoVQDegn7oRv1YIiGmzlGWpdIbvMVngOuI1kAGLgJyXT0PpXVfNurmnjIjWnBYAnha/4BbyS6EG9beG6p8mq2ZBuy53TZSf8JRWkaAr11gNygmGiWioIpMNrUNkia4Fi5qowN4C872G7cHT76sFIM2V9nk07aKOXyUqpDtIWX6ElApwtc75grjjLBPZIhoaEEdqq1rm78lqbAg82RB9FWfg/DFOrGwiMhAa4PlfEbpoe71OBN88s6aLHYpvvw92zxrVajWJzLDQuxQOi0witWIvpd9JPZVWyfJ4BG8EQJwSpgcj690LxyzpwLTTDE/foqQC1UXvGLYHupVQuMSBuRQHoS48msOEcoxgrBAVvX4pi54H55r3U1jLQ1UOsDHdEIDwmfXp3ZjaFeMAsV73xlHuZG4OFyOmM9Muh1RnxLFCQPNqpkb0efhAdE9MbqlQFQ7641OFrESG/v3tbTH16r02J/Ddw4VRFI7nqywO27+ww6+qJNkjUpV9V4FqRF7GHxIwEjZBAZ56o3CSj6AAjrj/8zge5uFrslbwj/+UWb/RK7ilzmtCj0JXMftG7XNsfe87Q1de9kgKdjLrKjIQizUV1hyqtCRbuJWOdMijbl0wuxKG/eUey9OmsSuKBHtV3l+ktxtrY6seOwGQUO99Bv1YXZ8sSO5y+pjiSoOhGPzss1rVlqUiKyn54QMztZvatQpuA7dsXXmbVqyNY1ewNYuYj8hq0AZ5YJyYCt3o0ocrC
 J8iQEA0K
 UiRMD8OZBn7chywsG1ZIoWioBUAnP0Za+LfosTHAljxVQ6D7zfRs9iA8q47popo9xhmWf8JI6+hFy01VxhHCBZMnNyxi5zi3eXyFgByOld6de92VqX1i8x+qPS3Ol733MBZd6brRuCyyfIt9jifgBndlxEm/s5R570sxtCwo92BVlH3eyYlrhmlAigsVZuNJMPXXa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:09:02AM +0100, Lorenzo Stoakes wrote:
> We declare vma_start_read() as a static function in mm/mmap_lock.c, so
> there is no need to provide a stub for !CONFIG_PER_VMA_LOCK.
> 
> __is_vma_write_locked() is declared in a header and should therefore be static
> inline.
> 
> Put parens around (refcnt & VMA_LOCK_OFFSET) in is_vma_writer_only() to make
> precedence clear.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

