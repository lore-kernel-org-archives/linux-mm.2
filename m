Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDAAD19511
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 00:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC5C6B0088; Mon, 26 Jan 2026 19:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4246B0096; Mon, 26 Jan 2026 19:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32C16B0098; Mon, 26 Jan 2026 19:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E5EB06B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:54:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A604D1A0995
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:54:54 +0000 (UTC)
X-FDA: 84375924108.18.A40C119
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E809E40006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:54:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="MYvDOf/r";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769475293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbK2OQJ0l6oR7RZVyKDtIEV+dHH/jWTPqXar8cCxs40=;
	b=drD54w0wHVMUDd7NxaMu2N/88rxH7twipxxggCDmB/fLEbElruBcYZZyzR/bzoyS5XAhRR
	1oKZifcC4hridGvx7VWqInL87J1hbRwb6vA2K4Gkk0YOV7WPIXwe1yqmxJwdGN+CUCbxMk
	wMXQxg1CTrWQZ8fkp4lGXxitbk6iSuw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769475293; a=rsa-sha256;
	cv=none;
	b=dBHbm9Z3ngChlmurzojtXh4WQc1Q274OmGQGlYq45o6on/FuQXH7Gn1du2MBXZEhRYHkTj
	QKv74tz0Imo4L0l7Pk8C8VfgEiQnh9WE0SukBDyiD4ppuxOfq1aQGc1sCB9aORm55Pq0t/
	Pjb4kVAKUdOj8lXxPBUZmFd5NCYh4PA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="MYvDOf/r";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B356640177;
	Tue, 27 Jan 2026 00:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B346C116C6;
	Tue, 27 Jan 2026 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769475291;
	bh=LZPriA/jHuid6pYIukx5fnT/307wVTdTm8js7QxCA5g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MYvDOf/rpiicmFao9wc13j0PnuLuUnOdgbThX6PnZwFE3Udy9CnMozPLoyNRY/YEs
	 zsI9niOa1x+AL35JS5pb1DAelpX7aPke/S70VA3baJMA0q9jbYB1qATNfAcZqA3FZ4
	 FcF7AuHIhcVKIgc1cFmtrXOUoZA5AnrMQIzrvcD8=
Date: Mon, 26 Jan 2026 16:54:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/cma: Replace snprintf with strscpy in cma_new_area
Message-Id: <20260126165450.f83b1895deeda8e4332a57d3@linux-foundation.org>
In-Reply-To: <20260127004723.74422-1-sj@kernel.org>
References: <20260126174516.236968-1-thorsten.blum@linux.dev>
	<20260127004723.74422-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E809E40006
X-Stat-Signature: saxkakxi9746q3qbnyo79zwpiuog3ghg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769475292-115520
X-HE-Meta: U2FsdGVkX19Fv25wOY3TT5BuxzeXW7wtRdMhgsILXq5fBdLg9QzPD3cnTR6Wb4QuFq04H9AarJDWbnDwsgLDpDmgVHWt2OGKtHhp+xoVNPIXc3HbRpQJfZaBnlQsz5jNIhjSL0QHm7Z96sFuQI/taKCEeGqRRZaL0TgM+RyORMJ9FEoy7b7TB7wkPeZ7QhF4XkoImMp+kY2pJ1tvMC2gmiNaAhLOpXL5gz7WatbQdZfWrBbNsocIKZd3XOn+S2fOUxcmFn5+M9Dkf7DRV730zHGuV2G8E1L4FVweQwpy04CPDmXdy2Hz8mvxHEgx62rDgS6D64GcZCGcxQZtt4ANuNTY4HMcgWi5QGRJP1n4P2uFn6gn1sr8AtM+XynKltD9z2umpEVmIUN1UyvPaxEFrey5U44HqSGyY28wtsvMSI4IDO3IYDf77uTtQGmi4bs/S6Td28cly7pkMJRO262jBSaUVhJE4EQibmxkMgiMJhuKhU+qJwMttG3/YE2vNqTZng0d5sLpUAptPAt8Wi1jp0IF3P+MUO5KXi4ZsFQxNtvSN29M0r4KClRMyqL+42AV8wHQN+jCkyS6XvS7/3QxOL2q2xGHH4dGa1nFgvbffzB7AD1pwPqHT5b0PdJDzWm1cMw3jqmefqvC5xWJ9o6TqlzbMxg6qqGUT6R38K8lX4LBZYyvum+b6CYKiPKI8C3nrLweqSAUgM8GZXKDdgHoGB0AK5iX2uqThP1+A72I3iHh5AT0VLU3p71C00kU3NKIQXSFw5MjuLJvcymS7HmEQafe0HLfpusiYN3IW44cJI4DKXdn+ihkiPr2tqvpss8IhJS4GeyIoE45yf9QiPVUKzSXSwcVmEgyXDB0MyulWkCkXYiKHpK5INBPRkUpPCXgJSGTaZUJAyt2sYGtpAcq+G+xoDrsakmmaEuhOsls/MxYkH44/yf5Ygar+//IN8uSrERrjz9gaSlo67z+sAt
 0ChFKntP
 JUv3ZbjU0YX1NgNd7V2SpLic/Rxnu96wB3fbdeC8+TrIk890Ru8k2EsLZ+nV/avWHjpeCPSXBJmeXFD43C0ltvGORIeCBg1C28DSNoTDlpwJVSdBSHwoWDxzpnYJrUJfFaUG3rwEruCajSqfxXlPUrWyFNSZNWozPvsvp+rCXnLoZjQKNS8vDfZpXaZC3PwyHNeTKVjOyRQtaGuoKyM+T96tjV1rJmyO9vSVVrPxkyzX42NhZIpZ8C9YJxE/uKzUq6Fsn6HeZRfLE46efSl6OIykTl96H8sIDTc+pRWHYFW7V16jAo5Crkmr+JSukfyH3+X9/mV3uAgwxPyj6W2eSsn+vV3DerXEJ0souJhWGYAoFhIeIsJv+nb5Xvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 16:47:22 -0800 SeongJae Park <sj@kernel.org> wrote:

> > @@ -233,7 +234,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
> >  	cma_area_count++;
> >  
> >  	if (name)
> > -		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
> > +		strscpy(cma->name, name);
> 
> Any reason to drop CMA_MAX_NAME protection?  You can pass the size of
> destination buffer as the third argument of strscpy().

strscpy() will now use sizeof(cma->name):

	char name[CMA_MAX_NAME];


