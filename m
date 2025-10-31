Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E30FCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 02:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D4E8E007C; Thu, 30 Oct 2025 22:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD058E006B; Thu, 30 Oct 2025 22:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6149F8E007C; Thu, 30 Oct 2025 22:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1118E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:32:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB3F849866
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:32:09 +0000 (UTC)
X-FDA: 84056834778.23.738F76E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E1E62000A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:32:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yCu1hRkP;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761877928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGaPq+ah2mEuBxT4HpF5mZo82K4cJT9BDNoAKEDrEAQ=;
	b=F+jFLgrmvsaopI7MsTlL5VEvMn8QV9P0OqnIJlURTPdoOIMHwuhhPxO073SyXmqaHKMGaW
	o9ULIVaLkeZpG41Qc+IOWn4z8ztlkZdN3TvRRmkee/j/KmXOnR7e0D4BNdiGnvt3lKNb/1
	2pGXDTWRsJ5mI8OStHkV/ZclSv6rrWs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yCu1hRkP;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761877928; a=rsa-sha256;
	cv=none;
	b=DtuKbsJwuHgPCYJu/hQ+6TQxdzzp5iw+z7Pj9p0gyKo5W3sOBtv7oH5lK6VnuX/e1hn3i1
	Q8r1QGezKm1t0nVGHnlyTnFv6StaIZajsXLenys9yi2bkcrBPJsl13oxOJzxlYZra6uUze
	TdORhhjipneegdDwjhM7JkoXrtIiqV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54BF86128E;
	Fri, 31 Oct 2025 02:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6300C4CEF1;
	Fri, 31 Oct 2025 02:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761877927;
	bh=knTtuIJ12DWZ+DPvQSS+x8bkA+2vUEOhQGD7Z/ID6oY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yCu1hRkP3JtWkPgt2scPlN2ZhLjGgcfcAutGpiOSiR9xd4P1N5JqgFRbE9lkpoxDX
	 VinSziniIAeVnXZYm/Jok02aeziTi0SZIU7LZ5YRT/bOCWBhFvH35gyn0zdVOq4jUY
	 0dWRAAH2wtWhTRTy0iyuSCdzgJn1OcfGxYXp9P7U=
Date: Thu, 30 Oct 2025 19:32:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Kaiser <martin@kaiser.cx>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: fix tracepoint string pointers
Message-Id: <20251030193206.22bb773e697b6cc385d5aa67@linux-foundation.org>
In-Reply-To: <20251030155537.87972-1-martin@kaiser.cx>
References: <20251030155537.87972-1-martin@kaiser.cx>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E1E62000A
X-Rspamd-Server: rspam03
X-Stat-Signature: zod88kkaq3yroh3gsmctmy4s38crzhke
X-HE-Tag: 1761877928-228203
X-HE-Meta: U2FsdGVkX1+va4cKTBLe+f9qsb0z9Ep8xyruAhmgCUGpdwBO0uKkld1XWwSnyP9a7nmScrCVE4OjRhMzb5FXbHt6ant/Lb+R0rzd/ru8uEAyHejPxZu0PH+dOTTorKMif13S63hVgGIohoKu2ChST3/LwJhaz1UKOA7c7VrA01ogCIgnOSYprkMIthR8vKhTBYcltzArU0/PG9eXJByoWxzKhj+31N6M+UzU0R6DdYbCnA7Rz2FXLxZ+7Q+YmaxJ8Jhc5XW3zI84ZPQut/0E+MJUzgsRVdf/f+COa46PrCHYIgXs5DFJYU2go2fnHRRWxSEzgnOuNMp4uhHxisdBQQio8d/CSqSPXL1qP89kVkBlbV25pgF02K5J+OH37+AZicJeRe+m5z1n3jVaWE5Rqb2vyoYggZwY64P2RB+AtUH0vS1IxQWhQ75Xh/vbRP84fzEi84k534HR0nabWPK4w3ZwrGitxArPSpl26E7r02BiIZB1c+A+k7aN9pqgNx7vXZn5kFLovhWiVA9RJjCkOVUNv/S7wu0fgSJPu+QnCMYhARoEUBY0cFk5zpRI8L4si4txNxyi3diB3dOs69zX8C+7UFSwEJqMRCipbBOH3vQmCyv8gSP+q4PVrWYb5wLCMHxQAj8sPBlqzBPQUGkCzH3/76dfmhpHepmfdJEACmwWlhVEtAzZvVU5vymKIf56MAvI80n+rqzx5vwhYfxKrHnVYEQD+X4cRqa1Vk8lKPkTxv7WmGQ1FP4qeYLuPpimWVZgi8d03Q2KINHFLEoQVQyeaRpsw8Q83TVjfO5mjobe3rzSOfNH6zk+V/ZBNtpfUFq0ShR7yE/RWyaHSxeTqqSGhyhdl5u/4diQ7f4W5vwhq54R52oE6njxGB/2wKztV7e1cfP9N1lYNv0XLS+pDFeK5LHl4e4ZCYfMItA0vlK5iNBPLUjmBrsQdms4zEOT9fHHssp2Uxax5k0LHTI
 XSB25xYt
 omZeh20nYLNO3qtevqjZwEaWPrIeidD0RmerjBsTYle9fEz55B3dg1oGqZDnjRCW11q43B1Pc9Ac6iC9zfyfXqU6q5TIHW1GR4qBJBRpRT9eDwCsBq0fIx0icSgV+MRi2098AhwFDODNWIxqSKJ/gzLb/lJt1jSgfUWnWavnINaDhrnDUep82qs+eyw6/ke4tR3G3ClXYPZR3/KLb/ktfl+ngrBt/LuQb7Ex9wsRzMHAUZkr31cFRSCO3uvxqVnw5+ht/G03eQVwZwiGbI3hPJ7gtkc/9iz113BN+lMG1k97c/Ek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Oct 2025 16:55:05 +0100 Martin Kaiser <martin@kaiser.cx> wrote:

> maple_tree tracepoints contain pointers to function names. Such a pointer
> is saved when a tracepoint logs an event. There's no guarantee that it's
> still valid when the event is parsed later and the pointer is dereferenced.

Oh.

> The kernel warns about these unsafe pointers.
> 
> 	event 'ma_read' has unsafe pointer field 'fn'
> 	WARNING: kernel/trace/trace.c:3779 at ignore_event+0x1da/0x1e4
> 
> Mark the function names as tracepoint_string() to fix the events.
> 
> ...
>  
> -	trace_ma_op(__func__, mas);
> +	trace_ma_op(TP_FCT, mas);
>

What could cause the storage for __func__ to disappear as you suggest?


