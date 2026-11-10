Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63514606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h9xiN3w6
Received: by kanga.kvack.org (Postfix)
	id 6483B6B05B5; Tue, 10 Nov 2026 12:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8716B05BE; Tue, 10 Nov 2026 12:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7CF6B05BF; Tue, 10 Nov 2026 12:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30E3C6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DDAB1C441C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:03:30 +0000 (UTC)
X-FDA: 85419830580.23.EF67E2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 894E31C000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:03:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9xiN3w6;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794330208;
	b=rVHLc42LlmhZjJjcz8h9+h2Avesb+hl7lR1RkujvqvXdz2lgU4p+43bVRA97mzAwdHfzk4
	S0lhW+VbkHWlOOf0JkJU6EdLhJ2lJONEmdWbfY8I9c8UHlfezWps0VjxwDuivAKKyLy0FY
	8FCACk8A8yVYsEPbn72/rbyfV7AmKw8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9xiN3w6;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYBNS/wIwETszXOBgNpLsMvPx95qdQbX+4kEObkSrd4=;
	b=Rl+zxIw8LcMtkt4O6JRJcWnAMLmdqhp/T7uV9oJyh1CiByOUcnFn1aY3Lz0LOTiAsGqx1q
	8YT6WeQtMXbkinxkZvdQeKGn9xW7AalMT8y0tEdVdZAQp6mIdFdxPLlKqIbt/eilNZXlnc
	Eqyd26jwwzoAkwFf1lCt3vrlK/V9QI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B99B34741C;
	Tue, 10 Nov 2026 17:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CD81F008A3;
	Tue, 10 Nov 2026 17:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330207;
	bh=OYBNS/wIwETszXOBgNpLsMvPx95qdQbX+4kEObkSrd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h9xiN3w6tQaZmnlGlFXHoQYdpAhIdrU1SCwWBhN4fRfNjkM+xDQIPj2Pba9imBt8x
	 SrGL0Hayefiwa7HkLpIrlkOPy4h09Ukw3bDyV8IpF+nGgbb9hZNWvmEkP1GbwkYUsl
	 wB5jx8genrtWxC5qMhpd3wEXiP7cpXpn/Cj7Zt3eSdLoqW3fSoHZyJlQ2fEPRvz1gI
	 PVDFENGYdlYYuvtD6FgjB5EscgrFiYvWXUrcpjr1ASmO9dE+/N31CsETmVpuRSraZP
	 8pO4w/TgE2wcEn82+N9jJoSQP9WPVgUBlZmOLJmDPZPHKRlsmuYX4fSfJL8a1NmcfC
	 2rJqxQ61582SA==
Date: Tue, 10 Nov 2026 17:03:25 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 11/11] zsmalloc: populate new zspage outside
 class->lock in zs_store()
Message-ID: <avNOUwojK5x8IkOm@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-12-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110054836.1515030-12-senozhatsky@chromium.org>
X-Stat-Signature: zcfbp3wbdkrt83go9rkrsehg3i7ddt77
X-Rspamd-Queue-Id: 894E31C000F
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794330208-224803
X-HE-Meta: U2FsdGVkX1+8wDO1xQOW8GaLs0XR2qSPGDsqcpsW2yShO4qyr/hJTIs7tGhGihbxyzWKXu+3WiVhdfo5eqWCweAlKVliF7VLY1xYnM8eyMY02CYcei0VWKSmOrrv8pqMg+AAKsExUt5/gUfPh9DnneND9Ex0NcBKq80Xog8FFan05Wxp2uRBaXhZ4/7ATZIzIM71vUrJcd9kTxhSxq7NlGUfqSK+E2fku2ICq1yPWHhj8vegRURD7au0PhDWdzChl/SlRLwHRbybBSVNWunZgGywhbbbc8Dhymm0k92dzTgbe03BoTZCp7hp23VCyayQmxbtZHL/9Ma2bkPdjd53p5QneIURk5HtM+3D90sc3AsHfAG3Hje2+6hKyvRX8fnhYRWpsNMLnySxu6qPb+AK2oSWlEcd1WI7/RnbSY8bAvcjqU3Zv1CpDugMe00OqUzjbSmsmpU+fNU4NpI5a7r5oJ9jR0yWySMQifbN0p/T0lcJdTPcjlnhlfc3JqgtvR7+SuG9esWqfDKCjQMFNaptkmwhTdho+/4gDik96oDURRC1PgWIjFuWPeKmlfAUqIe7Qqhjk/0EO4ASbilDLdotou9TDeMOIs5RMPyBHUJt9B5wnzK/GeIZc0twS+O4hT/XI1hzqHcZRLB4+lzJq6GuyJyODiFKPEL+bPBWxC6MPNJK8NV6lvabQ8giZ/casIAzN5vdJHpp0f4uA1JwHWxpV91xb4bhtYBJEDjvPgXJDAFmduGVG+g6Z1c/QhgxTpnVIcwt9clc7uRo9+Ef3JztI+I7qOg3ltoenLR0H7wEl0c/+aFHIFDk1pFoAgDm3/lAKw5EooK6oSkOaGeNKJmbfehZG8Yyh7gflGBDmLqFQ0UphqtM/L6p1T6kDnVqQp9FWUgV71GkzMxzcDqzVpU9ReCY5eu9BthdTPl2G4lz1dpHRIn5BU5NhdFSWiM8a5/5ThgNNC4P4hroj75Ox/y
 qAEbizgp
 NNaIaxO4X338GvFZ72gO7NWPJqPxvz3kO9nWlKKixaFH731aQAFRdJLaH6zB6LlqYY3cjoDZyPKLbFcL8Y5cwa663OITcf0F1tWTWzaR2zZLGzWiRD4RwQgyG/iBkhAgHtVog7KJ/kdD2IY84KQ8fTzvKo9ExLKaBjxohg7yWqbvHJesp3s5FYz1pCw8hxIwsKD3pvWQLKBsLbUXoUeaqU0rw5Uv4AuEHve+Ry7pZ7A/Daf57BCQ+duG0g/layw096yVvm/69RqSjbSkB/RYyKdKFaiwlT69Oqci6yJNvMTMxzSZ23M8NjpX+bHBDZD0PH4W2XkoQsFaOkPjtSsb7sZ/04Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:48:16PM +0900, Sergey Senozhatsky wrote:
> A new zspage is not on class fullness lists and is not movable until
> zs_store() calls insert_zspage() and SetZsPageMovable(), so neither
> other zs_store() callers nor compaction and page migration can see it.
> Nobody else has the handle yet either.
> 
> So for a new zspage allocate the object and copy the data before we
> take class->lock, and don't take zspage read lock.  This makes
> class->lock critical section shorter and saves a zspage lock/unlock.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

LGTM:

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

