Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DB5CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 18:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FD66B00A7; Fri, 22 May 2026 14:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646646B00A8; Fri, 22 May 2026 14:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583556B00AD; Fri, 22 May 2026 14:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44E436B00A7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:07:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE07C161492
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:07:30 +0000 (UTC)
X-FDA: 84795838260.09.82FA9F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 285B340006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:07:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g7KuppTl;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779473249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfqssdTExwNi19k/q2C4lKcmVNXXxclF0xnpgbu1sI8=;
	b=Rv+NwFwDQ9valrTAzCEmmCgqfnxUh2L6nYctJZ6urUh4Bj+BsWZGe7tTY+Ic66M7V37b+N
	ctwsrwc5mEE8JGLnZ5r7OyPvJEkiCNNtfZUaNsblbUlm5IH0+RPc0NOLujItMzbYI5V5lc
	QV6zIsdplMTGGHiWNwgbHe0Ee2SAu1I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g7KuppTl;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779473249; a=rsa-sha256;
	cv=none;
	b=0s15B+0D7so+q66+Mk5q0JMyLXaQVexTdXPXxit5pXwhz3nnQTYSk3PB8BWYE2st7VzvPl
	CmTGWQl/l/Zn6bb1GFvD878Bl9GdPz5C2hJJRz7RHhQMQ2YCo1WLBkoRhe1qzNfO47IFlb
	yvSN6hRtAF6wEHtQCzNnctxXvIhkEC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8973860138;
	Fri, 22 May 2026 18:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FA11F000E9;
	Fri, 22 May 2026 18:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779473248;
	bh=rfqssdTExwNi19k/q2C4lKcmVNXXxclF0xnpgbu1sI8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=g7KuppTlUAXBkJgzjaAIrd2lMe7/5uZWzecyhb+as7t4kuS5A7WF49qwpIhU9/BXs
	 MuFMVA0RBo9GTyZn9jP4UMDhZkm1+ABU0Xxwq+kFsCGiWtDkeZRx/nG5e9+xMcFSfq
	 VvNoEogbZ0o3LrWIvsNNsT14oCPuH1o0mNVziD9c=
Date: Fri, 22 May 2026 11:07:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
 baohua@kernel.org, Xueyuan.chen21@gmail.com, dev.jain@arm.com,
 rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 jiangwen6@xiaomi.com
Subject: Re: [PATCH v3 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-Id: <20260522110727.fc7dccf90bc8513abd1fdbf1@linux-foundation.org>
In-Reply-To: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 285B340006
X-Stat-Signature: 4aae9w5nii37atyy6mwpb3g8uyybnrsg
X-HE-Tag: 1779473249-558175
X-HE-Meta: U2FsdGVkX18lRvL7Axs11qaNnIq5Z/vakSyXzRSVRp0nOR9aA1jnUwtyto3qy2Sp2lEH/EI+1RwtBToXMGFn24cYxadP7SlfaJ/jf84Q55UjokkITLe7lX7Vdaqtrq80Zp30cdK4Z55OXBe9qyHxJmcqndDDo2FZE5w3U8YLaajxTxpr0EZ459EkEEl4qGTYJIfYpaykbbrTbq4y2/NvXgTrubCHf9ixdXfgERsd7OSm8xp9STMguOX8b/vAYEXV/IYdooL+OhxNQ3N02Lcy+uRjhfhI68zkvRXf6b5Lke0503qbd/ho2b4uqphOkSpxUw2yHKsv9SJqlKcFpdNapowVcoGvLoip5V1lK8ulpw4Efk0d3fcL13qKH3+t3duAMSAzTRu2ghxw0jncqw80dtz3oGkGlCRuBmJXceZQf500/yR0knHX3LYJNe9rOtB/Bx4L1a6mwcyIFIgK1w8S0n8LGXDaElXmE1yJl+IGvmXn6h2qH5EIrZfzhBHOpHlFCNOgLy89X8gAI/Wmz6CZmsPNQvYLgnpX1CLNDUv4m/cKWnsvhbcph3fOsiJ9dW+AgCpQEKaocI44AXQJg4zJqxTMfTajDTmZ2vgUrc4sFl/TFesJVdBcQjHRa5PKw0ez99bNCLs51a+8dhChTWVpmgoI8bMKru7U6EF958tWrfBGEAxy9Z+iaEkjOBlkkPRHfOmBL4f1og9InaPlPVM19B/0XFj2iJMEoftwpBB5ghaXrh0cmL705rcrXqUYQz0RuYfr3nqfLCN91uaZqEopDP/apszNpGRnDgYSAPlMHx9ao3oWvhFx5GgvhXg3/XIIlNURjyGLLTQacaBJONciFh18MLuuWWBKrpGu2y5UDjBTwO5Emm34/fJwl7ZpZfSXt0/UkjUPhs21F6u27IU3MzOAxhFKbeTBG6hu36kLb7IdT7RGSrvmU9mOuUqyWeDQlp1d8q+cFHy7HGqyC1I
 J2Em57GD
 H3Sbd1moJkruiul/pKGvvYEId8VCOFEer82Hgf5H0y0iJz+ojPUqmN9wU11SUYECEoKQu2xOscsZL6lYvdPzNNa+r0paU6HXGLBiaLrT8fghiJmExazTJvuAowUaFczAVxrMrDLXK5Us3xjLIWLv44lnZlOk4nZNhTCVewrJU1abmEyT6rvUVbvumOCJLRaqvd39SF1jB1nAMvjPx+vMF4cAoYGvMNpn9uKEDPqSIdQqffYi9iQcdV0uQnSx3B0JvvbM8GrgPfMcWdkPIMvnnKLl7yLc9F16OesJ8FU3z6asBXHbAm5e8+ju7cTg9h9Nk8X2MFLaRIGQEJmq6a0DXKXhC3xM8UKfcI/2IJjdH5xvGzAMbMRRhcqCQkLdx9qUOsLnzswgIvGix6+fS8rkiKNRIBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 13:31:40 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous.

Thanks.  AI review asked a few things and might have found an existing
32-bit bug in vmap():

	https://sashiko.dev/#/patchset/20260522053146.83209-1-jiangwenxiaomi@gmail.com

