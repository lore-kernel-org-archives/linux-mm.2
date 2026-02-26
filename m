Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5C2FD8FD8
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0750A6B016D; Thu, 26 Feb 2026 11:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040876B016E; Thu, 26 Feb 2026 11:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B196B016F; Thu, 26 Feb 2026 11:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBCD46B016D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:51:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A4A31602BE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:51:56 +0000 (UTC)
X-FDA: 84487199832.10.87285A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A72784000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:51:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CLOrJ99V;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772124714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r90HVI/wwUazioN2Yu0JkfzkWyGIX9p00ArKGCIDkQA=;
	b=aka16BVHEoy8H2kn7/oWILThV3gBz09c9K9VudjMGKjgZ9xl9h75TjasuMR2hf6etRRJh8
	VgA5YYcv6OFl+Vp3/qQg1Hjjd5uFe5Vo0idA5MAGCCimQolaosATRBmFR6ehGr3GrwX0Gl
	vUaPOpgd0SSG61pkiFkG13ai3qd5gzs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CLOrJ99V;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772124714; a=rsa-sha256;
	cv=none;
	b=UhTe+xnj1QJuNUCJlrV8dQNvkj13jda4bV9zarPGixk7rfHRgrUhQb7++f0w9Sq4WP37Dt
	fyWK54QCSYXbl4DMkvhKOrQKMwUtY8oAoph5nHAuXBnxPNuRZ/YTvu8HYO8pStPcig5wR3
	q5m1k5L07tnxS2kDvIvHw++aXX5uipw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AD8E44062;
	Thu, 26 Feb 2026 16:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B6CC19423;
	Thu, 26 Feb 2026 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772124713;
	bh=IPewdWEuDJPN1wrrJn7zkJ6m649oxY82U1YH4vSWFDY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CLOrJ99VdWcDT0IbDuGEAeDxxsMm4VIEQzVddev32PfavjRnLGG21VaqAg7wNDcfh
	 C4KA+DPKtjPjxYTVPZS/jGHoI4PT5N8sClpu7c0rKw1pLceTzXePotMi+uedf/wNKS
	 cOAmyKQn/HKWcBJZNNIpqHwqTXGu6+wj9UQlGvgo=
Date: Thu, 26 Feb 2026 08:51:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Yu Zhao
 <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Mateusz
 Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Aboorva Devarajan
 <aboorvad@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-s390@vger.kernel.org
Subject: Re: [PATCH v17 0/3] Improve proc RSS accuracy
Message-Id: <20260226085151.d1a7e7048d8f60a173d613ae@linux-foundation.org>
In-Reply-To: <20260226120422.8101Cc2-hca@linux.ibm.com>
References: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
	<20260226120422.8101Cc2-hca@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A72784000A
X-Stat-Signature: m4y7x8zki4g33y6q1drco9ug71t43get
X-HE-Tag: 1772124714-708440
X-HE-Meta: U2FsdGVkX19Ki6BwFHQgtpsvaLdm6AVClfjItX7vR49o/+WR6XlILuIrOHoX1to7yRBv1irpHRLEaiHr+P5ErRK2hax+78GdT43L+Yytsg88dd8mkcquHq9rs3PhI5byV9XOwlrDxzdAC7j8IoWbLt4LesbueadOYKykXvLcpzi9tvMbit2IJJZx5Tf6PLLW1afpglPiiTQV+zQrJbDTb341G7YR0mhMynyTjrlFM76OE525/7G7VVvciToFP0wZ3iyE3FCXH8qklUgKZsytSc/hjWtZ02zvEkwWhzBHR9Nlro20EqNxMeHg5DHZd0x78UJT1o4eJl+3b40VbvgLWQTLDkdCsHkuPOX3hz/LFYPdmu9U9CzxoGywsIYDvSoA/77YFGsUsqRXw3WbepghKC668oW75Xa990cwaCPmA6E0w21jBp0NeO63UmTYFhiVdmOXSn1L2JxFh7y0TVoYQks0eeyqa8pUOwRBk26VQSVykg9kjt8HTWMttBw3CaU1CiZhuR4B4awIyjIEIXAYz1dYqAmyh5+D2X+H7XeMTaQXXIY1vvPW4n+wMI82/iONYuPxpojJOtikfYB1LhwoJpbhBskcKwEq5rLk4xiT1iI5zNM0UPagBdJl6joYkBclMx5Fza+l1g6Qv1R/2XypWO5toBRMcj43CLb6gRWGcAbzAFLRY5MuT6nJ36ShzQL/b9t/MrLBbg4qV8oac14dZUvDghEU5Fc/mX/TLMP5SIEvSNz2gBzxm9CQcrzwh2GtLqPePPSNKaErsm3RTRKBj18SMkUPlcCu/mWhnfCBF0ifH1/olhIbk9WjW8yEx67JJzCPG4r01O7KP16rBbeycPYpvgnO5MVdds3+OZ0GuPzhHa8zdkt2yJMdsDuoAKwpbYYUbKli5HfJ3KSmImhXawk3XQWMHkvUp1gqM8p5paVPtVCxyNZxWPCl6RK/AiWi5JU+Go6VZb+MTi7Df4F
 8Sl5QwMJ
 StROxo61zsocP8KwXKVJGf3W1QTpq12mdcZKEhVbLMj6sUsPw5bkTwzi4mKMe8hO1UUIwDuocHPIdj2p4eWftA6MvlvUxgoMbvMp5GRUGtkJeLbQEluFmVuqehP4Ay4mHi24BOWfOHhippWu9s0BWWdBOSm6Mc/Ln/VZTVqzqH13P7EhF+BPBuHpqEX4UmfPZX5kKf9gp1Q9ETKXJD4TfzEqOfp0CDNMM5haWOHEG/eCNAJC5ghbmwADD8fgKShqJlmigrzUSn2fYsfQMc30ZE1zzf1diaiCt+JUSsY6v7Ep2cnbTA/oS1VIjZpJ2Uzd9EimCt1Y1g/ekhkHqgb59Ax/LWPJaeHaRiPLlK/L9xrfxyGSIS6JdPmD73+Y2UFv127IVtObtVfP07ldJKlgAV+u25CsaxsMVmS9/B389AIVWz2WZRiV9HtXYgsAYgJjC2iuSxJ+HEOOLM1gVB3+5lN89qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 13:04:22 +0100 Heiko Carstens <hca@linux.ibm.com> wrote:

> This seems to cause crashes with linux-next on s390, at least I could bisect
> it to the last patch of this series. Reverting the last one, makes the crashes
> go away:
> 
> 0acac6604c1cfd7a1762901f0a4abe87cf3a8619 is the first bad commit
> commit 0acac6604c1cfd7a1762901f0a4abe87cf3a8619 (HEAD)
> Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> AuthorDate: Tue Feb 17 11:10:06 2026 -0500
> Commit:     Andrew Morton <akpm@linux-foundation.org>
> CommitDate: Tue Feb 24 11:15:15 2026 -0800
> 
>     mm: improve RSS counter approximation accuracy for proc interfaces

Thanks, I'll remove this series from linux-next for now.

