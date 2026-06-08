Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B901CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883A96B0005; Mon,  8 Jun 2026 12:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B426B0088; Mon,  8 Jun 2026 12:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771866B008A; Mon,  8 Jun 2026 12:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67DC06B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:39:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18B04120211
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:39:22 +0000 (UTC)
X-FDA: 84857305764.16.E15194E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4C347A0016
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:39:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f4Lx+W5c;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780936760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kD4kOdeXpGWg7+OvwOcT8DNucWcPPZk1o0oeWyhgB9E=;
	b=P0CeEvEAKfBSfDWZo97tC+dubRpQdznR6FpY8732XZ3+On2YyYzegi83h7IYCAxawJf8C6
	QGpDf0ZIp3Iso7AvUQZN00SO+/mnUouKnaqGHQ0uhZ6iaBlZUMMenhyQmitYlVvOdTpFN3
	p3duCDJK1vlKjVtTVml2lwr9e1jMPM0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f4Lx+W5c;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780936760;
	b=2K49AMOva8iE9mQDjg5pOEfNh9IxHFNRztF92JNh3U0R4ZFN725NWTcm2kXSn1S84BhzyB
	gMOu/50JkHCKvhTCOlRz4ns8XrdG/bCYIQi/jOFkDRetgERsRxvHaZwKrBSaG0XFkFTOvl
	kvjMXcXHRRXyI7CTpSIkQcyA2toEe5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C0AE416F5;
	Mon,  8 Jun 2026 16:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4751F00893;
	Mon,  8 Jun 2026 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780936758;
	bh=kD4kOdeXpGWg7+OvwOcT8DNucWcPPZk1o0oeWyhgB9E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f4Lx+W5c54dWT8s3MY3WYPtTSVdMDthJE0CLsW0n/ylTWV/exmlYu1OeWUwvlsnsN
	 avvCbIN2bTVjS9nfsjEkgcnGJHSuOkYmvAFKX2t+R4FmBuxaRuBg9oK6LRSpacDSHL
	 DqjhGqr8rPycNJSAjGkQDJsTISwJJWymWTXFUNo8=
Date: Mon, 8 Jun 2026 09:39:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, David Carlier <devnexen@gmail.com>,
 David Hildenbrand <david@kernel.org>, Heechan Kang <gganji11@naver.com>,
 "Liam R. Howlett" <liam@infradead.org>, Michael Bommarito
 <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH v2 1/3] userfaultfd: verify VMA state across UFFDIO_COPY
 retry
Message-Id: <20260608093918.68ce9d7d5694380e3055e293@linux-foundation.org>
In-Reply-To: <aia8nKXtShnhQpVY@lucifer>
References: <20260527184751.4147364-1-rppt@kernel.org>
	<20260527184751.4147364-2-rppt@kernel.org>
	<ahhAHNSZOeW49ms2@lucifer>
	<ahhUM0A8-q0UqFv1@kernel.org>
	<aia8nKXtShnhQpVY@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: iakyi9rtwr3c7qhmuuqu96f35q7h3rkd
X-Rspamd-Queue-Id: 4C347A0016
X-HE-Tag: 1780936760-169873
X-HE-Meta: U2FsdGVkX1+UjJJE1Q/jlcy4mKwxy4xgP4o6MKcZjp9zWeemo0wAGC23V+zbRn+ZNzQDsaIijI+QNtKMMpkAqA8mf1u8hL30azKI0PxbqSVNz9shCbc7t+Gd7/FouoCCnGgwOF7W6eQ7xEg5dYxX0Pb9RN5apH9JO8icFX0KFof3jFLU1TQ3VXSzxDpSh+1UJ1CD+oB5vy5HiOqo7o2Yy0g9p1zY+LIV0txnuZ0yF/KPxOFofNURmsn9CNH98voeZZhoSUdE4jl3Ww8992qGpfG+nGzzsXQQWRsFehF/PL5rFoBPCW0tDwuIjTRa97gyRQ1jsHtTqewK6fF3H4iF+Ynxf2fmvVlXVaeSZhA6wS2MsiMnCWcEpMGZpRuuh/oTqmhUVNmAyEhpCENUUYS8VvWWstt5Xnup7+0Euit+0n7x7n1XFkReglXhw0DtpjLMTRwtHt7wr4tJIFeZju3SkpEp28zYUP8esuagid0hb3M7+HIUfFZ6uDmsgHuccDyN8CSyMKvuNvBNoE7yQNe93f+6+XME0L3nl6YrL3aEIjVdIOdqGzQ86ljCbIXZDBeiITKO5fj+B2TsS+HCSlrgj8TBB6+8rKs8WmCrNzXUeLOf9zGuihD1UoYCcdHmefNfDcDlqReurSlgF/GOZ3LcAix9hugUD7tkHL7pLAS8NQSvnaYGuRUT+UWw2nVkas+FD5wPQKl+b1CqpWz9mLsK0nqxGXNvrwtcDcYXqcmxK1q7y7sGGl2Q5o4lU2yEV6/B/mKVoph93DffUah34k1e9sxysKtsqX1qln//56V/hEmE+ZZqEHGdegMJf1h7Y6E1PmK8d5Izi58/WIfmnDoNZv1zhdGq+v3tgXo4D5JzI26lQ7ug0/RaXuLEG9iNQyvoZxlRaE03yxms6WJOE83TfE41VjoVPyg2em3lsTMjzLq5tFqBCQ0frDh18x3Oc2yzp0Ev+DW6Txb4Dldi4qh
 dILEM7Ox
 kewudJzppWBSRyiRIRZntiPuY9DFnuN0oJlbvuTOJFguHaVcFYpHgywMQE5X2laHPkGP+M9wWcwyI11JFhqOC911bEGQ/Fc/eMaNQVT71QNkrCYZxqs6/XmYksQJNd//oeqOHJS+70AKpcx+tEdtdPfPwf9xm9rrhYR5Q/61glp0WVWe9W0g6pkudAFvh/sJ19mOkqvrGDXg02KjpNKeO++lvjREfPmeklACN/xTTaBo0of0HNUJt5Rv2g2Li1438xu7lWZO3U0D1XnF7B7IVo5vQfHTeVt4fahoOAk6scB7VfZGEEq/sQ/L4HYfsyS0alZcgr5VjQMEXbZynRnlXOiSEqIwpswCk2fi3YTVrLMS+6e075IzmZh5M0d5HJfiXJ2qLCZNqkOo8uc4MF9Yxq7TuKU3QLDoDnF1gNStD13XVCvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Jun 2026 14:03:11 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> > > > Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> > > > Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> > >
> > > Did we want a Cc: Stable?
> >
> > Andrew adds it when applying.
> 
> Hmm, I didn't think this always happened by default? :)

Nope, adding cc:stable is manual, case-by-case and the -stable
maintainers have been asked not to automatically backport MM patches
which contain Fixes:.

So this one snuck into mainline without the cc:stable tag.

Thanks for noticing.  Greg, Sasha: can we please add mainline's
85668fda932a ("userfaultfd: verify VMA state across UFFDIO_COPY retry")
to the backporting pile?

