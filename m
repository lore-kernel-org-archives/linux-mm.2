Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C65CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A45E8E000C; Mon, 20 Oct 2025 10:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CBF8E0002; Mon, 20 Oct 2025 10:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB8D8E000C; Mon, 20 Oct 2025 10:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFC4D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:55:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B7961397E9
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:55:15 +0000 (UTC)
X-FDA: 84018790590.13.CDFBB49
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 20C991C0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:55:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p8Wprkh2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sp3U+8HhX66tVo1WEyU+Xcdj7duMXF6U3RpoRC4a8WQ=;
	b=fFbj5ynXO0fcJv/ryE+r/J13VvssC5BE0qWkvmi4TEe6qDa4Y/2ouCyAb/hqLNu3awL5BK
	kkhI9lyPHBYiGRAZuWEqubqAlYGidhyXkRJMuLLoEEw1wRaV5io8NgzrdfmBONE4rSmiWw
	2AnADkVIcjaqsAxm1xjQb5Gz/10lX6Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p8Wprkh2;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972114; a=rsa-sha256;
	cv=none;
	b=0mU6wq0ZC+YHbd2syj0yfDwThbamBNpgumwzYV8ECjhicfk2uYrNrnAd0pQyeu87tsPEL4
	vHJvD9ZRIkaBlAO81/0gTE71m7LfsIVvbFhX+uht0j82T5MXdlE1qui7Wl4CN/3K6dvUpj
	zpuOfQbaxHr+BWM5vUhMRODO3u3jD1w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Sp3U+8HhX66tVo1WEyU+Xcdj7duMXF6U3RpoRC4a8WQ=; b=p8Wprkh2dVq9SZFDPkia166rcb
	jyDGLg0XwBQvbe4SYn4XdxfdByoB/p054AHhPXAe2gNjvHifQ1DYT5gKigxXOMMrsWftb0ZcpurYL
	3VEdCyrKrib4CtlKsEmpK6yE6TY/WUHs1+hUo25Cx5/jMX6y3c8LLPUIALxFJBOzFJ9Kcxjkoh/Hq
	wNNAxeCvGWH4bVhPbpN3g+Oi3bjIMngVDwAYfqinSFXk1RxB87BFM7/D0pGyqnlNr5bxSFacA2tr3
	mXDXP1CAune12Vw0UJDnl0arWmmqTch6W6P+/BmB5a6+/nI8plVrccA9X8tU+CH4aZtEiAdnYW1ds
	9ijAzTIA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vArHn-0000000AQUT-1Gls;
	Mon, 20 Oct 2025 14:54:59 +0000
Date: Mon, 20 Oct 2025 15:54:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm, vc_screen: move __free() handler that frees a page
 to a common header
Message-ID: <aPZNQ0s8n-QOPhp2@casper.infradead.org>
References: <20251020143055.407696-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020143055.407696-1-rppt@kernel.org>
X-Rspamd-Queue-Id: 20C991C0005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9o87ie6zesmx47bsmfgt7dk5rn13rbrx
X-HE-Tag: 1760972111-476063
X-HE-Meta: U2FsdGVkX18J/aYcMYQJqFzlyVQk57VX0trhnHngHm2f75xZl++qKcEofHslD2aqrfIFzcV2S+hAihTDDjDSkjF8x2coypdLedy0LRs6CMAZMK9E80UQAMKjCAB+GWax8PnD/ZsOqQ3HiUkObNkTH0Umt3q47C1e8sDcbWRu2rFXmyK8seQViSNVV6K8/w55TLRaBO9a1vThtzoHb463zGKt1DTLNp6HQRKnhdMtPQa24WvYK6owVeOUn/rN+eZu95aUlV6Efzw6r1umuNlZGPwUVyMkeBThVqT9SuZcIheT+eTn+cbwP3fifSGk4HSh62/va+UB+OA/OT1fJBIOLMPxEHM/XjTzVpGLc+SDmX1q+3VIqHcLCkulUh6xuU+9Ywe1aJQ7FGNmH2IpB9ULgI2PxhTBcv6ipzFANCeraBjm4mq1KyOHrktz+8BWtHx6AmCBCJ6EhH9mYElHFuXduw8cgO5zimMlE4iXfmNGy+VzpcIHE3Dbp1Bzwj+XImxmKUXO+GlE0cC4GhNtzA+zgkCubrUiDGSEKm7vzr0XVO/jR0N2ZD8QDvHR9MsUS4RHi5fYLipz3gx/Aq1HK9qfJmngXIBhr3hJIjx9lN/H0K4Ifrb+0sN2T8EzahdLNkeiD3Y8GCmu7TJO4DTtCPwpDJxCIt24Z/+wv5DNTyTBpDI+9zswdxEOmIR82UUqzdOF7EansyeqUcqsA/wdnozGGGOW2gyFV9tXysKv7gJERZ5Q1AaqBkwU0L6iFennBTGca91ymUYE+bjmT0Bqy7aJ2/yveJIRdregzUtZ22brjuJr5TlTERoOjPc1nluKxl4/JEA2DJtvml2pEh3IBiHdYv4E6z+kJ/aCXmOn2inG0mBfXz0NunCUs17VLIcwemOYvrN/kdUVS5S9Y3KGjp7I3/3B/mI7S/CQJCpSSsoFJJKtprxhyQM38pIdt8ksW5NFfi5qOOsYJSEGNraroUx
 3ddF8YCi
 YegEb0gWLBYGxG09s+udaxrogbA3JmhoFxbx7tE96hZERK9JpRnMwf6uaHNpDRiNyfOMI0G9qnLrfdfsFsyBmUCQhJW0XTl75q0+NTOBODocPpV6hD3TOa6JyydgB/PWE7deMEvtpoSpsKJWeILHKvVfBXh5J0K0HGOy2D/wJOj4ES+6TJRwuA3ZxLl5q2WXh1zOAhNxHqggWbYRkWt90Ajr4n10lPkfYW53joB/OV5yw5A9w84F96byFcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 05:30:55PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> vc_screen defines __free() handler that frees a page using free_page().
> Move that definition to include/linux/gfp.h next to free_page() and
> rename it from free_page_ptr to free_page.

I don't think this is a good idea.  This is a bad interface and we
should be moving people away from it, not making it easier to use.

