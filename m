Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCBACA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 15:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5966B0088; Tue,  6 Oct 2026 11:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65DF6B008C; Tue,  6 Oct 2026 11:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B846B0092; Tue,  6 Oct 2026 11:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B603D6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 11:42:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FB1E120239
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 15:42:59 +0000 (UTC)
X-FDA: 85292619678.13.7F2B901
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8E92D4000B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 15:42:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtFXPpLC;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791301377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roU9coQfRxaaeiOH/ZEkXx1JahWrXVJ8XSe6JADNSnA=;
	b=lIzotjux8ylC4CCAIf8VGAloDC7O457bvxbGzQ3n3KwwoAmDmly6pwMiCRz2UOaVDjBO0K
	gNKt5yFkrBo4OC1ovB4gVH9ug6+P6tEed6AcrAIf1ZcwU0CFAw/T85KMdntXoBgIuYn0yo
	em8pByVaoror3vGj55uiSNjdXywbTlc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791301377;
	b=Xy/7Co7wfJeEprxpUF6WXL03hs9sh4xvoye53U/cIfUQQI44o8DIjT1Jk0s8Uwd4qWTGRl
	yzNJQcMmstUiwIP4En/MSc1pJgMPXmgZzPnns4qPri3AV9dcbC1ZRle1TDkl/gC2rlRpyJ
	hpcEzaPXfqU56RqHwqs18nQOGZTgXoo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtFXPpLC;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 055B8407B0;
	Tue,  6 Oct 2026 15:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02CC1F0089D;
	Tue,  6 Oct 2026 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791301375;
	bh=roU9coQfRxaaeiOH/ZEkXx1JahWrXVJ8XSe6JADNSnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dtFXPpLCJewLAk5Ox0npsd0Mgz53kla9loWdf5Eeh2AXLLA9D8I6jICAQRkQT5R/X
	 /wiIowQCQ7f04XKwQWgJTf8+dQJSq/0K/1JWFjklQ4+ThJMfY8OIO0s+TlvpL/q4Pl
	 mTzVROl+C7LzpKFVCGguqBuViszzQYS8Qe28I1g2sd5/eIel/dJjcdTIpAvBelWBMr
	 wRVtPNaFVD0lVvtbWshaLWQF5/Lx03FCGpo6t4pmQT7+CgSklhjuwa3WhOVYdgrVQW
	 O8o2ZaOvKX7SyvUUpkC6tIRc0vc37f2eeWRLdv8klxit8OCFZfInya8svTX5h2U5Z1
	 Wb7ms5cUKZPEg==
Date: Tue, 6 Oct 2026 17:42:48 +0200
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Move default_gfp() into gfp_types.h
Message-ID: <asUW5dkEronQezrU@gremlin>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-1-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914223219.901347-1-kees@kernel.org>
X-Rspamd-Queue-Id: 8E92D4000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: o6fqpw4xguradeje85qyh37ephjeee3u
X-HE-Tag: 1791301377-455899
X-HE-Meta: U2FsdGVkX1+EPCMw9bi4VWviN8n5iN6uGF+/rntuxgS8Y0lStDFheaEaQ3XSK7sYBy/4grpjve604woqG2MBKK47B+O1IS3nMimZKxswEuThdUCpKX3n0JwbQUVeTp3VjrFP7FPCx/rN9lpk4V7Bavn9zPYFBAqAG5JFLxwBwxtMAH6FQErbN5Yafo/ulJxi4jiNl9cPy+ZHhD3rvVoNNGszD68462xcLaTSa+qbDZQ8NvbWdNXeg1lW3PRUN4yz6OctrOFvge+G4ROUwBzF9V12uQiUEWnKyxR4T/C8ZjfcBLR3eR0GTL/Wg0Wd3Xl9my0mhGM7M5uOUvtX3TyxiP62KsDPFNxkaKTn7FnQzxmt2AjF8i5jfefz06hjXiHocuNdpWv56w3Nv64nscLBJ85gZcaxNGFxoaYBTcX3I9vigrDJ0QBJ2gjRVzxiUm9a/fm+qmQIMt60HKffTzJVqfDW0cMXu3nK9zMcojPoyCvV4AmRcGk22wG1CO42B9aIBUJV8eoHjDsAG6Z2ovkdnJrdwBPJB60shVW4a1fWEy6CQLu6CgpJnYPsTvq7trIxjVY+lsj0k3t4DmWcCkt8HXy6mA5M8Zw9QXi3KXssjK7N6rhv34ZwD4QveLJpXz4R1qs8PIgKov51oXs8VNZN4Z0Z/dcpcUcA0c2AdAfoC/zMnCVfaEQRak3goA+1H25ZHtW0bo2PWUkR5xXpiq4omEyvlHtVLln0XznItbTw8b8e6iWMC1KJBho50P5KtjXs5x/M2m1sFRGfXJmu78DjlMC0ZZ0Udn8NYa9qQQrhrxkNIlG6jd1POS7OiHJ+VNk3q2wR3FQ1b/v3fumtogVn8u15YtHosKWYLcRdr0/VSvIEhSbTYvSSjOL9eQ2XX8ZWElm/nkc5UmS6IKGm9yuKzo/PH1lvlB6r/T9zf8gLfYs9KlXePSF/9nMLtkHy5Vnh5AWizpPrZxPZZZvhUB9
 3Ekobg+d
 mbE0zsjtSKzdKaLcnyJGUZ3RDYIEu7u+GMyDpQaPKi7BYxeQL495l5XgOSWBkGTygyyxcp4zyqGgEPYfkrnCR/J2Q1YqEqXhg1VkdBqPcpxg0TCEnXcjXLoKWSyi008bRxmzT2ts+b7HLpUqYsquoWu7wE8dUr2pskjgfZefDqggGYH6bkITK62tkP8FvdotDMdtyoAMGAIL7hxwjU65+H8kRfDcRUK22+/qR5uAfXwf5axZWiS0YwC8KX7xno1cQg3E1pB3IP0REwBFPE5LT3kubnn2gI9BD/gDI5neikmMb7UmfGXjb1ZHpx/88x3wJC3Xf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 03:32:16PM -0700, Kees Cook wrote:
> Using default_gfp() only depends on the GFP_KERNEL value. Move
> default_gfp() into gfp_types.h so that future use in devres.h doesn't
> require pulling in all of gfp.h.
>
> Signed-off-by: Kees Cook <kees@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

