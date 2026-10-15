Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D44ACC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6966B0088; Thu, 15 Oct 2026 10:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87DA6B008A; Thu, 15 Oct 2026 10:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D770A6B00A2; Thu, 15 Oct 2026 10:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6806B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:01:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAFB7809A1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:01:32 +0000 (UTC)
X-FDA: 85325023224.15.6B07454
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 52FB5100012
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:01:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UT4XHyFt;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792072891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5GxbzSSJJMmmoCWuuAA7PdJJ+sbINi80CfgoWLf4j0=;
	b=F7VS7aW3vlqI+c+SjPI7KSFftA2xTYd/OuYmcMLcj3oIxqj5gM+aj2Ninu31+F6TMm2UMu
	arLW4Du9NpGVJnqSaMni86dXWnEYsp8v56uwOfiULcgFylYvPWFWQJkpjIb34bwYad++2+
	370BeCWQcAdym8UBmy/fiOyud6Rf+yU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792072891;
	b=WGhrTt9BQ3yo17+pG2oLM3kU6oM8UjtbY5B8tHvfl90BXzRsLaHCCnfDqxPI4rDrCD/i8C
	FIrgWBDvip0Z/WMGGlcEaFzpRCjwF40qmXeZpC8t41UFMaaN2D93WjwnI7TUDlGzFnSk6Q
	W6gbmiArvdCopX9VPdQEgmaNe8ol0kU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UT4XHyFt;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2D7D60120;
	Thu, 15 Oct 2026 14:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9621F000C4;
	Thu, 15 Oct 2026 14:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072890;
	bh=F5GxbzSSJJMmmoCWuuAA7PdJJ+sbINi80CfgoWLf4j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UT4XHyFtHBGn1rRrXjn9SLpSN9MVXDIPuD1KNe/4nwRcGEzR+c7aUSdS6GUbecIjC
	 3RATCfSZhqo1tNCBC6m3Xae6tuUpHgG0LxkW3ihof7Q6/CHgT4dKyqTKBKX/XpI5MO
	 JSC7CDgVddkHyBX6/oEO78op/tAsukNv42hSo5OoCdriN/LHd6ZR6HEGUMdztiDySX
	 kzmMwYaEVGCP/NmbEvih3tL+UxjlvkMdDuHnMu81CNA8cjSK5eWbgk9ErXz/rkpNca
	 pp7PpaFKCTTZdsQWS4q7ShOTCailDTbgcaBG5x5DveBb69I+N02abVxnw0g0DOI8qT
	 AkegIM4UEYbZg==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
Date: Thu, 15 Oct 2026 07:01:21 -0700
Message-ID: <20261015140122.87808-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015080623.808458-2-manuelebnerli@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52FB5100012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yzj3arzg1qr66prubsek4as4cswyuq3j
X-HE-Tag: 1792072891-234181
X-HE-Meta: U2FsdGVkX19HzBzmDSRhnJwpPl6iZZwpUpyhIqV9eF/bteTjpoxjG3HtUZ/v9Z1B96w2qsBKigB+0/oxNUKZheZv+S0GVyzuDVDdAvHn0ZwRCLrKw8pqXk8S40+1+NuLPyW0nG5T92j2jnLre6MfNj8jBktSeD5K4tp2SAvjVidhGEOfZl8+eaA0Z69JAJFRoACuKQhrKOdBy1OO7aeVuqyI5ILGZa1jKgFuplx6XHQ/S35TiWDyWb9XlaDzNx6dUJjUbKkiIZ8Nb2scAdYOYfms3aq8vCJwFxOSYy/4u+YHTDHFDYKp9l31hV8C0xFCXYsVp/bU8rj1MCSu0Py930mdOxh8zzVvbzmUqWdGwvTYeBPGhLEAGGdLs/WFETVJNPmUM/5xHM/2TK83gdYb+7g4QbWoWJWNl76rayKaoYjw/KOUpLlYK9RxDeRN2Rt8R+7kclg8+fPZLpGznMxVdze75JayIo0QSZQpD0mLW8feKUCQPJdqW4jLq4P42PD5I88gWDcEEalmL1lsr6+Fus9ZSHuSD59YVBB4y27+3a3OeYdCxnlKmKDU1IiOFqrz/An5TZLSu9zAgJbfe7aU1uFijkL6sxltYSElvdBh11EBEAFGMUdqpK+rso/WGhADIBA3bgOGm6ObQogjh2kdt9PBJgPOYLWxkaIFvWYKUU2GYAHFKaKURNuhKtjAtHmUOBdIpeD89BwNHNgJXyIK285BdGoJ1tiIk2S+n9OczxWJOPJc5gKRzdq8De78pm4lqtCA/LIErDfcFGgnq1GECH2ftUATb3/62Lp7lcLnKV2ZbdU0JM4CFzOZPdgEs8Vxw5pMQMUVYx09X67ixVAybi2ww9lpeFKmTdu3ukhZs85p4bBnq2+yYu9cbHRkxc21CISnv0cVltnwz2/DBLfJv6qUkc+DPAUnPjGF1Hu6INkbV+BvdgHR9u82ljqTnSyfjSkc7sQSaEyLUDNaYr1
 H+ItIVod
 /jdvlNUXEorhzO5Wn7kg10+TCRlOjC83dxN9Nj3WfVL0UEqlZTqVfzbSFYjap99Lh3BYcd9gqFdB2q8eH8tE+NE0T1xUE+8NQkv+/10+ft2fKIxNpRSdMKDE1cTwO829zO4Jt/XtNBGUK+CThOlXVqrWXa/HbMgpvR5REGz7tRxW+MFpfJa10amf2KqOFLy/0Dzs2XaU54puG6EgBke61E2danEh/wbSHJ8GPLv/MH0HVDm7QYkk61RqtouF2mSPhJXa0TnoaqnksLEsrI9nFrMP4a8XADq/1dmQo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 10:06:23 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Fix tenses. Replace 'set as' with 'set to'.
> Rewrite complex sentences.

Let's put two sentences in one line, while breaking it for the 75 column limit.

[...]
> @@ -113,8 +113,8 @@ quota_sz
>  
>  Limit of size of memory for the reclamation in bytes.
>  
> -DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
> -window (quota_reset_interval_ms) and makes no more than this limit is tried.
> +DAMON_RECLAIM recordes the amount of memory which it tried to reclaim within a time

s/recordes/charges/  or s/recordes/records/ ?

I'd prefer charges, but my English is definitely bad, so looking for your
suggestion.

> +window (quota_reset_interval_ms) and stops when this memory limit is reached.

I feel like readers might wonder what is stopped.  How about "stops trying
reclaiming memory when ..." ?

>  This can be used for limiting consumption of CPU and IO.  If this value is
>  zero, the limit is disabled.
>  
> @@ -125,19 +125,19 @@ quota_reset_interval_ms
>  
>  The time/size quota charge reset interval in milliseconds.
>  
> -The charge reset interval for the quota of time (quota_ms) and size
> -(quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
> +The quota reset interval of time is quota_ms and of size is
> +quota_sz.  That is, DAMON_RECLAIM does not try reclamation for more than

I think this change is just wrong?  quota_ms is not quota reset interval of
time.  Which part of the original sentence was difficult to read?

>  quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
>  milliseconds.
>  
> -1 second by default.
> +1000 (1 second) by default.

Isn't this (1 second in milliseconds is 1,000) easy enough to infer for
readers?

>  
>  quota_mem_pressure_us
>  ---------------------
>  
>  Desired level of memory pressure-stall time in microseconds.
>  
> -While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
> +While keeping the caps set by other quotas, DAMON_RECLAIM automatically

How about "caps that are set by ..." ?

>  increases and decreases the effective level of the quota aiming this level of
>  memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
>  per quota reset interval (``quota_reset_interval_ms``) is collected and


Thanks,
SJ

[...]

