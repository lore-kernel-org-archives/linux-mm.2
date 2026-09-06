Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CCCC624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 00:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5413C6B00A3; Sat,  5 Sep 2026 20:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F10F6B00A9; Sat,  5 Sep 2026 20:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0596B00B3; Sat,  5 Sep 2026 20:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 131736B00A3
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:18:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D5F2160455
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:18:01 +0000 (UTC)
X-FDA: 85181424762.13.251E630
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66BA614000D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:17:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xn7FIJdb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788653879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG4SsHwh6w3Rir3+3LpKzSaA094DGkWi0CEdHNVDXeg=;
	b=KdGyc2h7dLzwWItCSYZdzjxoA0E8aFkg1xwp0shBVyhxeilWTVN0juwDkBX9xiSKdGAcja
	3aiBtsqAY/mcv0oVHeyWW6oGQjNe3coCel3jRDlH1lgoAF5A6NA/QXgwQTaDu2JWaEW47u
	ux+kXtjcoMeUWxKATKtpPyjByONwWlU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xn7FIJdb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788653879;
	b=mq0d9PKB6l7fDS0hnaxtnvfcYwcOCoeqsO6ol2sCVGivzUC+o0ty0qHVzQ+2W97yQVEv/f
	822FY/nYEWSkP8JDgf31UKt19YRDJ4fBqZJUILdlbrCysRX9dcahTi5RhQqN41iZlTzfOA
	QbeIx0npUifF5rTKnvJLYeHvwMw0RuU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F36A43A44;
	Sun,  6 Sep 2026 00:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBEA1F00A3A;
	Sun,  6 Sep 2026 00:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788653878;
	bh=uG4SsHwh6w3Rir3+3LpKzSaA094DGkWi0CEdHNVDXeg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xn7FIJdbJUhPVjtDuTGi7m7q+xc0z298VETMk3ZCL0hWWPESP/xnw9CCf4Bzz9UQP
	 thhaoiSzXvurIIxh9Smo8ir7JuZsJLSXffTPsnI2dCcOVI4bnYWuCKbtt6Mw96Bxug
	 GiXBhazIZeTeigzUEwpsXO3zvlyNgzWXzvlReWzY=
Date: Sat, 5 Sep 2026 17:17:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett"
 <liam@infradead.org>, David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>,
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Message-Id: <20260905171757.ba8b0f8f0f18ebd04418bfeb@linux-foundation.org>
In-Reply-To: <aprjOxDy3JCPb2oa@gremlin>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
	<apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
	<aprjOxDy3JCPb2oa@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66BA614000D
X-Stat-Signature: ck5e7og41q94bq76ks57cbsciogoa6yk
X-Rspam-User: 
X-HE-Tag: 1788653879-543120
X-HE-Meta: U2FsdGVkX1/n3ZfIFRwevWheCi0aHtgvz4omj1jZN4nCGOBkFuikoXf18KcYQFkxIVvPaIlQjAvNl/JHsEX2uFQgY37FoL79FP8O+DPK2el1/kRmTjbWhN9CnT/ojbjDk4XktskeQQf9w0SCwLZQdYr9kYUYvsGncMV7uD+oYgwCvjfe/h/R4d8bbjFBavUwgxl5mLcexA/sASe3fvdRT00CquvTqHtVIBEptFAIMef63r2QEi3k0WwU/rD98v3Tp3V2FIfMF1/RdsILtcZL/2ju8pSovPf1VMZzdK2RwYxBJWbwazR1FnOfGZXYtsLL/pUxhQ6lFpBxpYv+5e44mhBjuc5IOg+QfFMuNY6Ew5sAroic4Eh0y8Y8EzfOlRWwZ2kkEtsPJEpBAnApgDliqW1xna8l/59sTfUT4cj1UvhLzn5L5TTlxp8FyEtDQdrFf5MQaAU2zuzRTYcWmMeXAeTWxrwZRJS44asR98rtJ/rAAjaZfYlIzJsZ/iDNuGsuAfDg4emcZMzAjFnbPDoCDHDJoR9eCQ4m9byoMdgu4fR5rACTGkFYs4HJFh/1JmqwEiMBwZCX9NT2LrU1e6D08VsXLxQnDN5bDssvYiFMAHi40ZwNCHxWdqOccfjQnKk1uc2JSIvEsTw9SZ31/5UUI0jHQZD6lkYCEGap8SUj9qIOBmWuTzt9PlYY4osbIs+dzmKdczmV9M7LJ6EMGMJ9A/Mj8/ZCATDEv60CPgl18bhHSgjJ94qpucYOzafZMW+oaENWCDo2V1hY1LrZjXuKLNtTW+OKgDlgj1C/9y+fDb/sURyOn3YeBsIBmWBfoirO6qJG/BmZHdn5/DeD1BbCzAL79PyKiQEDJjFqXMR2J4sSrO0fCE2h3rgkaeL0d218nLPfxZ+snfiS0Q3T/m3lC7sYTkDt1sAlnDG9cqyBXTdkJMpPLLTPShm2j8GQwzNzlpCqSNstYaeRymtPM1n
 oDY4Xhpc
 3cdCyBhnzN72TeDJkdwn0ApuO5zqu60xsSeBm5AUkI53emV68MVEnSF2lyme3//yp9O1o7O4+UhD5O3Gn9ZkF+Cpj+Zuw8i3jFTek5wcLRI5g9wSSRHlp0nueQVYhekbXbLRSMEZn688ztzH7xrQYLz2w8vyYTVwZjLh49vjhWtsTN+jYcEHz0kpnQbvdDlmY74kHQ4V6xAMJoJu1PB11N2eMGEWpbi/UMhYu5esHDE/nmkreWktk0qx1WKGwtPk7xtVhAQTrdJ7waKwRkg2YtPizmsBd51aeL7zGtFeQ9IVb3Io+NLYKWCbpgIPD3uSC2pst94zZp+LB7K9epaBFDNkUWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 4 Sep 2026 17:01:37 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Andrew - could you swap the patch out in-place with below? Thanks!
> 

np.

> Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> for the former and a tree walk and swap in to swap cache for the latter.
> 
> MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> as if they were purely file-backed, meaning any swapped out private pages
> remain swapped out.
> 
> Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> mappings and performing both walks in this case.
> 
> Since the logic checks for vma->anon_vma this means un-CoW'd
> MAP_PRIVATE-file backed mappings retain only the single file walk.
> 
> Reported-by: Mike Kaplinskiy <mike@recall.ai>
> Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

The failure mode looks pretty obscure, so I'm thinking that no backport
is needed.

