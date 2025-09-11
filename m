Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB5B7CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 20:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332B48E000B; Thu, 11 Sep 2025 16:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC4F8E0001; Thu, 11 Sep 2025 16:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8FE8E000B; Thu, 11 Sep 2025 16:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1928E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:01:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC7CFBA25B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:01:30 +0000 (UTC)
X-FDA: 83878039140.18.473C1AC
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF862100012
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:01:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eqkfWOnW;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757620889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tO27DlleKvDpEy0vh0IUHnG6TXTGPEvg43VFxXxxfA=;
	b=TzWL+nr5JvDnjwm+W0Gc+s2wNsX22sMIOKfkvRxstkyTDcklo6KDvz3McbOrO8rWbZlbjA
	HAGbWlLwY7Zjl8/FzmQF7HYj3UHZNYTr/6YsBB2RuuVKeE3+7+jbAt5CujokglElH3RD/i
	sv2aMHp55T1i8JASNxsMKSF0Us1ZBww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757620889; a=rsa-sha256;
	cv=none;
	b=7th5+OaXA/dO45mySEdXUsIKj1HkCegeXcZxyGN7LcYVoLmBIxo7oDRnc3YNuHFb6yfUpZ
	3x50knM07sRtutdHIeco1vg7Oyq9otpS5YTygiFptIIrsSANEpF5WUvWzdcWd7L7t2E+PA
	TpOextsX++Mecms48ZHdjNpvzHM/OoY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eqkfWOnW;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 11 Sep 2025 13:01:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757620886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tO27DlleKvDpEy0vh0IUHnG6TXTGPEvg43VFxXxxfA=;
	b=eqkfWOnWBt11D/7ixqsJHWm4D0QwESMmg0yfjPVTIPNMvNvU0pTy+02ughBeOz9BMg3Ti0
	DLJJeRbSD8D5eNy7v6c3RTjFERoBQtSLZc6lDsdxuRkXOQ4WlEwfwWwqGIqtBpWfTMLq3r
	SgsdWMfZb54CoVt8iLZgpv30b3rnYA0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] alloc_tag: avoid warnings when freeing non-compound
 "tail" pages
Message-ID: <zxbgiqf4d3nlww2xxoea7rud3q4oj2osk657xnhu6r7du4lf3p@es7mqt7joo7b>
References: <20250909233409.1013367-1-surenb@google.com>
 <20250909233409.1013367-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909233409.1013367-4-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zqhr96a76o7dgy4kxsjpgpxkcewfmyoo
X-Rspam-User: 
X-Rspamd-Queue-Id: BF862100012
X-Rspamd-Server: rspam10
X-HE-Tag: 1757620888-283340
X-HE-Meta: U2FsdGVkX190CBjBeUbXAv2q9SThQgLpDmbGgo/Z85h3zTSG3oLLxEMMoj8LBQ2PyeZzLhzaHgWcJmSdFROfb6fu9vbmn9LAMN6XiYDJTw2z7+dAVpeFCZkr1vadPgkc79SuTbvKFPEbT9ZwaDYPtkhMrrOPcOpI0wZy1A++YKQYc7WXIyyzXxuWKsQ2UOKymMPSTAhpq4a5gFuQXzW3GbLosxwBVRUUvm4lG/dy3cydUsKcpDYjggvM86Dh95WE7a1anCL7PciuWnbwo4mAANhmq/4fVTsfQCmaeLBPSnrMgBqxzKYosIBlZ0tleNgrjG+AqHtflheljjXli4MPJrQNKTHtfsEQswDBCx+gNtOCm2Fkkdz07PcPTxHfm4o94mpvE9tWoYwavxmHP1XotSuEYkWQw0pknyd7mLsrmP4B1oYzDV4D+EUABZtgZltBK27edfYBPB2EMbdi6+R6gx11FY30rGK8QejHj1sP7SmhnmAOSwAw0fNIoyP+n7WrWny3CEC46hoc6h1H5X4AlE3KD0nQw+JZAKEbcoENMlxPY+r24OQt4WOn/W91ntKPTbA4TAa3cr995iv1UUcydPg5iGV+kinXFMJyvytE85g/bFNqpaBKbdo9pzrIdaBHyhKnLUksDtBg8fsMFNskhLDjZnyoC5Mux0OQaKVU3r9K5eUs7QSdxpZwsWIUuqmiJy9zuaOxapHoAV911hvbeKlpi3mFOLQ/4dolYa1TcPNagfB6iTxINxzJBNAbStPGVb1W/0+9yTOoGwXLLV45fQf0N+GY9LIiMj0HzSK4UX/8yQYBIpd7GEIBMAUKoIgjKz5ju8/RDMDjJMEjh+tylMnaft7thUhGxvJalgqfJaufTvIRI47YGJcuGRGHcX5Udj7sJOeiLaEw7g8eglOy1bhazAM796mW/wY3RqwTDfvhcKHhiQKUPkkN9x1knm/w0A1/7s4y+sP09RdPDZ5
 0V84Lp4O
 MZw77iffN2jfwCSFELdrkI+XexoQ+GXhiknmnYeKXHfOimUK38bZRtA0n41cdhOc43HMQ7X+w2E01Wo2Km/luaNvJYkv+pE/Qd5R/QWSSHcdzCH8v0wg+fMxJa2zCbRcmArgtRqpnEDdaxUPVeWfWUb6CExemxkWynlwu9weYjk7pxK6/vWezz8MSjyRZGTm68LDgjQwctEHkUbyv07E912LAWdZMdbuhR8Ew8xbGn7QcwMfvQE14CIjmrEQBDLiDP8qoMOr/83kLBnD+eGYrl9cOQXakjXr8pItBS0KqPnO7pP7s3JvPoDUEzgJYi0aKplu7UmmZhyEXl1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:34:09PM -0700, Suren Baghdasaryan wrote:
> When freeing "tail" pages of a non-compount high-order page, we properly
> subtract the allocation tag counters, however later when these pages are
> released, alloc_tag_sub() will issue warnings because tags for these pages
> are NULL.
> This issue was originally anticipated by Vlastimil in his review [1] and
> then recently reported by David.
> Prevent warnings by marking the tags empty.
> 
> [1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/
> 
> Suggested-by: David Wang <00107082@163.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/page_alloc.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1760346bbd24..d21a411e807e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *page, unsigned int order,
>  		__free_frozen_pages(page, order, fpi_flags);
>  	else if (!head) {
>  		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
> -		while (order-- > 0)
> +		while (order-- > 0) {
> +			/*
> +			 * The "tail" pages of this non-compound high-order
> +			 * page will have no code tags, so to avoid warnings
> +			 * mark them as empty.
> +			 */
> +			clear_page_tag_ref(page + (1 << order));

Do we need something similar for the release_pages() code path or is it
happening already?

>  			__free_frozen_pages(page + (1 << order), order,
>  					    fpi_flags);
> +		}
>  	}
>  }
>  
> -- 
> 2.51.0.384.g4c02a37b29-goog
> 

