Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DB2CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 04:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93A28E001C; Sat, 11 Oct 2025 00:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D768E000E; Sat, 11 Oct 2025 00:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C038E001C; Sat, 11 Oct 2025 00:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8994D8E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:57:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 347BB5943B
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 04:57:32 +0000 (UTC)
X-FDA: 83984625144.15.489C163
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30BEF20002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 04:57:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fC0ni6EC;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760158650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQMNGa8QSkBPPtRyQbi1jxC3dOPcr4KEhTr+RqOKCs8=;
	b=FfWfwB/fOkEzGUa8rZmLFnQisb+r5kpuwpOE+LDmd+buhzcXIyGX5ryljGA+CR81RMkshD
	Jtc2bPy7OcRWO8ASUxaOuvv2f7MK6VGrnhiM5+RYIiK+HgeTDJpLB05fnjU0/sLWuagMTn
	Nf8c6V3A5BYyqaBQxE6YjPI90UZhD5s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fC0ni6EC;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760158650; a=rsa-sha256;
	cv=none;
	b=WRSTHhLyccFhe3V8EG1vuRgg3kEzij/NVmi76CcLKwx/epi9ye+rlYWG6HFsryoL0l9MOj
	Hed3P8+jWqAi7Iuf69iYWbJ/d4REGG0GdL0AWHYdqRzGgIfRLaYrWnoxyBjqyrnVNmcKSc
	U3XarJ7MLKXRxrWDndF0E7Ydjq8ydY0=
Message-ID: <42c4bd7a-a9f0-47cf-bd1b-ffb6832ac7b7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760158646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQMNGa8QSkBPPtRyQbi1jxC3dOPcr4KEhTr+RqOKCs8=;
	b=fC0ni6ECCLQjADtkByiZ4QwxgJpPuLvtz6EFdI72UKbn6PvxJ8R4FVoYr651JWCPyBQSDl
	NvSUxwJKkOHfSKqNG3SV/wX1qm1GyRTEVc/XFYWp8PcvQzFf7+tOftSdrIdkQT6S/B9bIh
	ePTuyHGqs+FL+9lGZlabTZZ/KX/rqBY=
Date: Sat, 11 Oct 2025 12:57:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: only get folio_order() once during
 __folio_split()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: npache@redhat.com, linux-mm@kvack.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, dev.jain@arm.com, baohua@kernel.org,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, david@redhat.com
References: <20251010141142.1349-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251010141142.1349-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pgua6jqct5n75wxprb1k8yxijkjm3pna
X-Rspamd-Queue-Id: 30BEF20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760158649-142295
X-HE-Meta: U2FsdGVkX18tvNJxV11LVhU3GkN5Iij4KnGKn465JGtZe+5P8jyNzBXTiyQCjLLTx14emkATX0ulHaYWVp2zE2fJE8zTBnR+9HhXfJGjjFNAP4IZ0c6ei5+Wubj25YT5JeeSDo4wabKQ722dCFocGV6dMhwk37t2jzQZrr/tSq3U6RaEtWKSlYYwSLq+awwMZ5eQ0u8013lKYtusRh0aHyNdAgII45Xo6M5u0CQSjpzW6/0+OO7JZHYwWIyxkd33c6/wmwc4t8sXyVeYqoW8xt5IgUA1Yh0N6gh3KUsPxS1oKKwN/kDK1ondq6oeyQK+qnSP9mjfxDrIIBey6to9f/0xCG1JaAmZHyhCEQRuKNyLtRSvbd+NvvZtdWb4WyFOl/PQIuybrqxfIPhtlo1p+khPWjFova3YsOrLuWPetdz54M+Yqnhu0VW5oPG+eCRYz/b/jOrGNXQvS3tvun1pbMavz+EIihzQ/c2lPcvP0i7oy0KnurxNjagbmq/1eaRv10cJ9xzqlL0UK56RjOaznO0DNyDgNSDh4KtRfRBcDwz0xOfXvGwyqjadare+ObNTlVYkGtOwTDa7dZklleV7k2pFRxyIVOGutVJ5dgBzE1rkabrcbdLIwmv/buoV94Jar9MeI3KczPl9MUMb871xL3DLZSqdzoOE8nyKKtNPIQZgykP7RePbYLM88ofWc75J0581rU3XVOOluHYfYfzei3N6tKNQlOV5DJd8YcjMjlrzovhnmGsMOxorRrZNovmdjx9jCB28mnqUyTuz09IzjgeEyHRiZSXNs2k7IY5k1FNf+ta6RuGvmrt1Z+k6ISvTzeVVt7vncVCKxbZEQ1YYp46pTcXJ38FjCR5SwSkXWA6PBp9qAIevZ5pZS5S0svT8BRW3V35c3lQsqMXMSWSAZ/HYbCA7I78qM1ge1OYztvgTRAq9uKiqf4tcVWXgXP7zXD5jTRbWCM91JNYrzzs
 K2NH2zUi
 mxyLKaoBUDTaqIvWD8+REXFqzqMy/BRsy62pCstuWjnJelWk8AJcfZfBBw5gMs9toMEVeyuDn4g3Q5N7LwkFIbWZlJeuvtkugD+L5fnKhgW7XDrozqTsa3vaJOye3UPW+V+pfgpGGsY8M6H1t3V2MkWNoBf8Hr2DgCzjAn43hV4sBc13SNMLQoXZ2bP02AvE1miLqn++gTF+n5vi9H8ul6LPgri5lfHTo64a6qO4VEFwvewacPFeGnwfYRvYK1FiDunv7fbnarqa0YuFK7nYEYlrBugT70XYO/6Y+Qf/8FW6XYiBG04lGeOY6k4G9nTvGbcJDjwh7fpV9DFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/10 22:11, Wei Yang wrote:
> Before splitting folio, its order keeps the same.
> 
> It is only necessary to get folio_order() once.
> 
> Also rename order to old_order to represent the original folio order.

Nice cleanup! I was thinking of doing the same thing :)

Getting the order once at the beginning makes sense to me.

Acked-by: Lance Yang <lance.yang@linux.dev>

