Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2034FCC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DC56B0088; Thu, 15 Oct 2026 05:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9A26B008A; Thu, 15 Oct 2026 05:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29096B008C; Thu, 15 Oct 2026 05:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDF856B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:28:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B64E1C4355
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:28:37 +0000 (UTC)
X-FDA: 85324335474.11.E28E7EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BABA5C0006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:28:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kV54ySjb;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792056515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4bnAyKruZyfcLpOq+/+Nlq2GiAzNK9/Dr2IjL42/ao=;
	b=Q0pXWopGRaI57D8zRvA9a7bRjJ2PInqQuriIz4+uECaEFeYy76Ywza7kpCsnAPx+8HDnB7
	dUL7Krq5Pr1H66/dfDXuNAP6F/URE8LeFXBIsGGnKFslnrGPMh/y5BRCitL1JNwFWaw93S
	U1PUn/JjVE2hcIwOXA8gjJ7KMRPa5+E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792056515;
	b=Q7od+sqrr/1FBGgMNazSObsElTwHrqSm9JHtW/xuTBuqYQVmCJlJN6rzDy4baeB2TAgUt9
	9tIdsXUDCslAvSWB2QBxVeXmUvD1FfOeqyPxiakNDH3328+YqhcKrSS/Inm4Ytfwij7Gvy
	em+MX0YblGOaWe+BfhjzCzS23Cnl8WI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kV54ySjb;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2822B6020C;
	Thu, 15 Oct 2026 09:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4101F000C4;
	Thu, 15 Oct 2026 09:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792056514;
	bh=B4bnAyKruZyfcLpOq+/+Nlq2GiAzNK9/Dr2IjL42/ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kV54ySjb0NVVvu7gv5hdE/Ka3InX24MpQaJUHDJppUNvCxrFdSeRQR/Qiq3/mLIjK
	 QwiRRHD/X1obNDaX/DLb/AHQkdei5MsS3SUXFYfClOWP2w55mCl/65AGTFY15JZxat
	 0QTcLoUQjtenGXF1PnCo60Qgu7mxduL7YkcHFURv4NOMn+BVi0g56MWCjDkuLK33q2
	 Ue/rmIAd0HTK7fdluR7JUevThqzxnF3sKQPmOWHoUoBZpxLaiabXsvs+U5KdMCvaoN
	 BxiP8GOD4pIwxalgQfLE3hKkIN+1FMgg7AbNRZ8g3P71X8nAIXVBE7wVExAdbtzdXl
	 BIy6UN4/1nsPA==
Date: Thu, 15 Oct 2026 12:28:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
	Roman Gushchin <roman.gushchin@linux.dev>, ackerleytng@google.com,
	akpm@linux-foundation.org, chriscli@google.com, hannes@cmpxchg.org,
	harry@kernel.org, jack@suse.cz, liam@infradead.org,
	muchun.song@linux.dev, shakeelb@meta.com, sj@kernel.org,
	ziy@nvidia.com, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Message-ID: <atCcufJWwalKmxyL@kernel.org>
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
X-Rspamd-Queue-Id: BABA5C0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: g7smn4pmz78f3pgiuqrkg3x3zqfe7eue
X-HE-Tag: 1792056515-867928
X-HE-Meta: U2FsdGVkX1+pKX4JyX8i6GLnsaWX2/ZQFxBWqbK+hBlQMSodv7yGdRo6YVgczgNIqRGwnNCg6GsuUAHju+XIdSomZ3fEtMOWe3jWVX2otPwoojKskYMaW3a1LBeGhRFJRmqYA6zZQO1vt8pQLXKUVMlSeVz9kwBcywCM5mOv6roK9Qn/FuPInsz5r4wXlJyZDh95R/3IH3c5PCd8lvNJb6yWHR4A5aSszHPrXU7wJbHdi0+8yy8Klu46fCToJMiB4qr9gukyg+EPy43EXLKjAjqXOAe7XeP1HegRBnmih1xDyXwpVtok/rBg4JwRCK8oXyIbG0SghYsMVweBAfGQcUoPNQYSLHxahrSgi4GsR9AATmLrzXp4QF6L3KSsqiVyLOFr8mbugThgAi8ZLem5uJG/fINWGvTq9VnNvhgu7nPQ9egO5UTPvHJHQKqKBYnpV7BNFjYpIEauQ9YHewRc7nd/yV+j19SDst8PiPgpXH0EF/zdFTRlbl6m9eyO3I5VuZHBw1sVtjmP1I5gNxgS3H3zh6IDt5uHstlH+Uyhhn/gleBrkmU4K0Ym4SVT0eTgbuURxru6e0HUbUIWtUUYBhg92Y9wNdapWJqgQ3p+GDnpAsO8DEC9new5e1f023sv6zhud8PbGYGUo0D8mbsnQz0ra98qSQyWjLemsqfeSY26S5+Yux4d1a1EhLi6N+xTumKYQNkDtYMhQ1lBnlA61v2bV2s/3l5FTFX7OLl2avG76hEdnhyI91rD0ywqLRQV/DgxWz+TXUmLl2rcnKfHjuvtMCWOmbepdc1Z/vCQxMYyIVsV2WVlXhOjP6PaFdSVYfL95wT+E5wu3KeNWCG+BrQwQUK4mV12SlcC0q/9AfHkHK49h7D0Yhwl/4TOeflZQYSa4JY/WJBygUJFJFtWLKw2zyoc8W2zxpylhSlrRvzx5OQpYBAG4GFM8zKdU6x6hfdbe69B3Zvpearyg83
 R2db5vG3
 sTiKniEcOPMXcZ+IEnvCHhVXz4vD2XhVarLuFsHkLysJbWXJ2zZUFiYYWjR8nbQHQ8XX4EQsXMqm3KAKR5+DjPzJ55EwpomV8me5vSkfTlHgMDbNRcMAbVSkHWa9y+wXUisHmnNiNV33rsZdUPnW05F7XbpxuMC4jCBjaH2WWL5eCBEWrI6/QajES1MB2JbBqUgFGc25PfSgv2y33hr3SsLxnzM2Q5x0Z0JoJjoV9Zy95nt9bx3616HnaVNnK+ESoctWKZMBzRiLG4gBFyFA8zQ3xio16nmfwA6062OLneQxwwlnq3HDaHqv7jir7okG+fnqmneniyHyIx04sXCmciO/elkiBNHkyZMAdHmMqC4h6HqvW5Qb+tUj1bvEYnIQqnQLXOhrMyZMgi5z/vjPC3EeHaJFk4YFvB5FU8nS0I1lairUfAawPO4GCDC6mi4iD7gmHzA4ZGTJC2PssimDrmjQpStnCnsdmG2Cdti5ZJpwSbIVEmZKGANOkUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 10:38:14AM +0200, David Hildenbrand (Arm) wrote:
> (CCing all people attending the mm-next call)
> 
> Hi,
> 
> After talking to Roman at MS, he just informed me that sashiko now has a new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately
> 
> That solves the key issue I had with sashiko: people/agents re-spinning stuff
> too fast before a human at least had the chance to jump in first.
> 
> I suggest the following sashiko change for linux-mm:
> 
> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
> index a9198de..ba123da 100644
> --- a/projects/linux/mailing_lists.toml
> +++ b/projects/linux/mailing_lists.toml
> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
>  ["linux-integrity@vger.kernel.org"]
>  ["linux-kernel@vger.kernel.org"]
>  ["linux-kselftest@vger.kernel.org"]
> -["linux-mm@kvack.org"]
>  ["linux-nvme@lists.infradead.org"]
>  ["linux-omap@vger.kernel.org"]
>  ["linux-pm@vger.kernel.org"]
> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
> 
>  ["fsverity@lists.linux.dev"]
>  reply_to = ["author", "list", "recipients"]
> +
> +["linux-mm@kvack.org"]
> +reply_to = ["author", "list", "recipients"]
> +embargo_hours = 24
> 
> 
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
> 
> I'd say we start with 24h and see how it goes.

Sounds good!
 
> Thoughts?
> 
> -- 
> Cheers,
> 
> David
> 

-- 
Sincerely yours,
Mike.

