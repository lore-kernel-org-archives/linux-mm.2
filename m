Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04E5C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DD396B0088; Fri, 18 Sep 2026 17:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776026B008A; Fri, 18 Sep 2026 17:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3436B008C; Fri, 18 Sep 2026 17:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC186B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:35:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3962C1A07B6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:35:06 +0000 (UTC)
X-FDA: 85228188612.06.EB3F5AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 72948100007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:35:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YaJzyj12;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789767304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzrOWb7USfc3PFDPqWSCCytYQOmFmHMArNmcS4CbPM4=;
	b=yrobJveJUz2xfNsuhS8x1765C3f/oaCpTLRkHpVJwljUAmJM2axbEnp57AWQG4d/wcoqRM
	FxPs/fjcbEFCvvK1xgi/OCebilnxZbys5uTsSDxQsEiH/eOLtSuMJ9kOO5AV6nLLRC4tUA
	xgj5VTWlRhVC/HTzG8RCXB/ruXDe+aI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789767304;
	b=f8D3xId+WGms/HjYDAD+sSOBqKHTvFB/F4juKQmvWk8MknRtzRSKgqShVwKLNXdCVIcR9+
	dldY5qyT50gBUnRql0Vj9RWWChqsWdHQp7ZRHNzL6GEFLqyAdY3eZVGZvUugVx+PUNzd/i
	k9CJ7K0c7C6CyPQoeI1vfu52paTWna8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YaJzyj12;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85937408ED;
	Fri, 18 Sep 2026 21:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE40B1F000FF;
	Fri, 18 Sep 2026 21:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789767303;
	bh=LzrOWb7USfc3PFDPqWSCCytYQOmFmHMArNmcS4CbPM4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YaJzyj12zdYNf/Sp38pmFEguIVwlNkjfuCugKp+g1uMkq72x92tnb3Et0wjp9U07l
	 DUbSRVJH/CR+z0Ecq4e/rcWN+XMiqAWAEyRnYEN/5gbxIlIEAGgaMT3Zii8mPQdvlb
	 g6kBbv+wBsEiBEwDI5r0bdsPAAJ3zEJj47RpGvAY=
Date: Fri, 18 Sep 2026 14:35:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, hannes@cmpxchg.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260918143502.b4fb3587b64e260e14485348@linux-foundation.org>
In-Reply-To: <23676471-d90c-40cd-a357-e71b3d426425@kernel.org>
References: <aqlvnm8AKp5f_UhG@cmpxchg.org>
	<20260918063203.2802342-1-dipiets@amazon.it>
	<23676471-d90c-40cd-a357-e71b3d426425@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jatft71b1z1esqe5e8tppxjahpjojhm1
X-Rspam-User: 
X-Rspamd-Queue-Id: 72948100007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789767304-443739
X-HE-Meta: U2FsdGVkX18wctNha1pGJ3gZg391XtQ1gi7ABh+MfQPDbzBSZCBnp/743P8Ee8TSxVej9VcAXSD/iA+VnN0gxQpgJvaN9mZqigVtUaLWjfLfNkSjjXeeiy9HUmnNwhL1ShA9kFztoTJ4GJ8UbFj5sqCmbpNKz6huK6638UvWZJ6VzitG2ExIWaeSKqfEIqvxjN4YEWEmGB+3udlqvIiRpN1ZmAiJHhdRINc8HkuEx78jHpG64I7bfs1m12aCxvaCRgggKlGJWmh7khzKLwAV+yqZCfsEoHpDAFPAuHnmVOkAwI85dTkOBjW1p0EPJ1S2JBA55JrWC7qA+ehkdXg/pqjPJKcnwUNRFK7nBGkQ0VB3l8C44the3xm37khIAMRLDFMo7oxpXpC+tNa+TKMPJMPt8sGDWEEk7gch8HIRqS8fZi+3J4bPhsbHXUQtBLCaIOoMvr9QRUJ0prVzIfeZ3MH+GebefRs0RAE/F5cGTApNicRQnGn0+sVZv4xsjV1ONRQ2VBYaWyQSvBz5hA01GuRE8LeCJVto7XFviyYqWLGymhRZyI4OLB7DyIqMsRgSHE9ToD/SR8TfVRX99JWEfZo97PPh61gmhpzqgi8ZH3FlXurbdCqsSjkiW5Dwc8cGRrcEhiGhYyJJUYV2eFpXaUNxfBjj9PYyZGI71VDGe7vr0WTwEwRTbf13YSy4NWeRs8bw7nFJXGEklYRIsj94medIXvTtNMjy4mgDnyInBWmNMXN6IMVJbsVNvvmBM8smVYLP8no7jVdaE7m8eDJvM9ajjTb6d+SIdehoaUt8MdCpCkZKvEbUF4gtKw4TvExoHjTdOf0TiH+6czuKKn0QX1l3n6yE0GVmycZ4wZS/GdkhGdy+4CC5KpDkdkE/kMe+vYvV/xz9ENeyVcc9XXmL2aFDZVvFRET+eSRYb5/sayrJ1/rWweuQqPzOcPuLItQOeI5sLqLPaaM4Mwe96+z
 NYq0LxtO
 KMjY1UgbpaUBMZD66IQLSC+W1RsTcSG++9M5m0EFGon+DnS3aFYu24SAj876+2ASlhvu2nha8dRUx+TgXPF4ETZ4xPEcmJDeTQJmTijzfcwUos+K38hpluSrcNBQHT9OQbERSU8vrjLPFACvGMpq5EvOobRZCvTNlT3UCarJC1SpP3Oi5TyVPmZzRwKTvKSBjxav9bTH3Cc9CdvqpDQdWLqh4Q7roCnj+kot9nID/AhOCqyim6+bp3ZK7u3gfSN2AdMqnB9j+SO1RwlNwhwi8mqINZCA6zTPfWUG1kYr5CYwMKryLIZe7AmV6McqkJLajOVhR43N1ZtYoFM/scc+YYBd8YKtZTkH8ymmuJxL3l2yIhoFGd6qliVQTYT0Tca+HVn/7Bek7N+7c+dI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 08:40:05 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 9/18/26 08:32, Salvatore Dipietro wrote:
> > 
> > On Tue, Sep 15, 2026 at 04:17:00PM +0000, Johannes Weiner wrote:
> >> It would be possible to remove the costly_order gate here and just
> >> bail on __GFP_NORETRY. But no strong feelings.
> > 
> > Will do, I'll drop the costly_order gate and bail on __GFP_NORETRY.
> > 
> > Andrew, since you dropped v5 and restored v4 in mm-unstable, I'll send a
> > v6 (v4 plus the above change) unless you'd rather have an incremental
> > patch on top of v4. Let me know if anything else is needed on my side.
> 
> v4 is in mm-hotfixes-stable now, so an incremental fix will be easier now I
> think.
> 

I just demoted it into mm-hotfixes-unstable.

So a clean v6 would be best now, please.

