Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A7F606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 12:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X+sSyWJd
Received: by kanga.kvack.org (Postfix)
	id 283A06B00EF; Wed, 18 Nov 2026 07:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AB76B05B0; Wed, 18 Nov 2026 07:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198AC6B05B4; Wed, 18 Nov 2026 07:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E83E16B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:15:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55E55C06E4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:15:20 +0000 (UTC)
X-FDA: 85448134800.21.1F335C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A8B4440004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:15:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+sSyWJd;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795004118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZT8OsyWtlECLblK22MqWE/7zRD3o2ixQEVKNmjYjq0=;
	b=WKd0Itx7az1EjWWiaAT0Gf6VHHJLvDtNhsfTIV68cT4gUOz0jNAGHHDkjOBeOTFgxaxBof
	VMGAqtY3jf3BC3Sdg05DoPTVMFKFYpN3xRPI9vKcVqAz2wXN60btxXAhkkLkXNPS2mKJbJ
	zioyg65C16m9SI/N0ZUtp3Hx8PjNvUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795004118;
	b=7E2St+kV5gp9lwlgc0tlEXw2RO08ijVMAaK/MEGPVSMcIHYsKsCCIixaQlHPtGO7zk+Doh
	exDt1MKWbanxrx48YqRV3GyK1pICioSCXPb0GdZ5g5eJkIz7/hRFxDSL/9cZ5ScStsUOJB
	3n0dygJu/zZ7thUZ425a83tXBDkZaJw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+sSyWJd;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C9B362164;
	Wed, 18 Nov 2026 12:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713881F000C4;
	Wed, 18 Nov 2026 12:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795004117;
	bh=MZT8OsyWtlECLblK22MqWE/7zRD3o2ixQEVKNmjYjq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X+sSyWJdLT9spChVvpuBa/0po6wyQQR26ogbloXmNyDH3KPO6MeTYi/gK0EqUgTJU
	 b5/l+qAPxlaQOwo8H68jwEK85JLP67GJkNUUi0Im/2AQKPfSrIs5MxBUXvN4pwZywT
	 384dXtqN+qjKbtzC5mMhSgr1rXhElmUjvj2iLzkvRjjQBiRd79U0IoqDPGQ4g7TzcR
	 USNe0XIGCgk6jravjfM6vxf0F+h1HmG/BEOVJOXU6BN8iB3MbauPgG3mRRtO4mg+81
	 hjp3PWIGIUyue99a8Kll9MqXxzZyeSZhXRTmLRQUzn06AK1rFwc3mYAr83iLmd5nen
	 oNYa7bC7nqamw==
Date: Wed, 18 Nov 2026 12:15:11 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Luiz Capitulino <luizcap@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
Message-ID: <av2WmHeZlw0b6lOs@gremlin>
References: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8B4440004
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: gzbhqmksmx9zzr1bwfm4indta9saax6y
X-HE-Tag: 1795004118-960583
X-HE-Meta: U2FsdGVkX19q8yVpxI0dXf6luXztRQf1U8QyPBGl+1EKATRXswugBOCfkfdvyYvuusz5FBt3FUHrwBDjZUd0ZvqpTluyBT+D1E/GFfknkb2iYfRQ6YA5YZvHJ61ly0C4E4CK17sFCifUj9xmHxVbVhnLbP4VIJZidtmvpmYnTNKPhpGidCY6txWj5/vn4nUlPW1h81+/ziS73hfjhZEfAj/+rRCn6fZqbRHuKO+wPgCnhXcJgOE36TTc1BPOgOARAX7xhTq2X5S03AC9c95aZG8op9CdnyHDHrb1pDyXZBIcuaSKf7ihgsRuP5+gld3WKli49KQXdYuNktuiaVw1i87/ivFw8xYualNQ8UEv0FfuOxAd4xbExjPnlU2FMhgwhxw5CUgALtUKfnKzyewo5jZtIoM5P8mB12AmoTbhJP9sIvr3yiALnNSLltd3Lw/TriaJ6xJjtprf6jqjEInqIOctYK5/9PcSTMvltt+S9nwK1VWtrcf3ZAle9tFbr/NaeP+SahiKyhVZ5dfNM6tTjZTI4S30gOgIJisAaxs3Rodp+VFY0WQcEMAAVeU1TGu6G42r0p0YlmqWPSTI0AElDfMes79r5+sefschk6uV8UzeLeZf+3ZHQtuahS98hqZlZh+QUS166//h0ASEbF4YNqM4sAFntyT2FqBJOdjzTht/o5OTY3AZYAMe3IJkvLJmIXwJL20fYBtPWkQe0lM1onMZ/dzqGJG3BHdGPJ78enWuhyX6FIqGPjmvbQ6UIfNM+K08Ta7oRTOb7UJjrTKLAJocvTrTBnFqewhKAg4fLLMyGvzXcTuO928EqSLRLgMRD0+iP/SePgdyP8fnf+dGLQTU9ku1xlTyqZrD/fYY7cre1+ku+50GffkHLi24K9Rh2d6s9rrwwi0o9Dv+rEKcZ9GRXnVfB7UkL44PSqhxu0cpAKvqsmqRzVOdP6minQwpkRmjNnGsWJLeRDkRb4i
 FLE2Tr9B
 2nmr7qEh4l8gt+GIYCjuv/mQP1T7SkUf0G2Gf+j4PAHJ4W4TPtiEHR37SvSXM6rx45VlA5H0w2bTYnPMBKt8gmZ1rlqqsZr9nY/cRK2DJU28y3UC+l5wf8+LNYebEakV5WwREZPtp0pwqruZg4aWruR1xdupq52binTzob4cG82gA2Emj3ThDcQZ8iIquGOkZSppQlcDanq2y+B+bnOcEsp4aoCW+zAKGTB/mX5tMNlX2MPWx3WIJgU0wpqjiChFYNSq82RM46rCEq5HZx7n/WNuiorW/9Z4Vz2kSRAV6dLQiN2bUYgqN8eoqh9ozayc0Sh//YUtyUIncvIkW4BrTFWhRFiQnBbRYx/xQ6LZ2P5qBefyJ2R8oYnykkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 04:26:18PM +0000, Shivank Garg wrote:
> It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration API
> for page extensions") but has never had a caller.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

(with MAINTAINERS change included) LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> I found this with the kunused scripts [1], which I wrote with LLM's
> help. The v1 cover letter [2] has more details on the scripts and
> how LLM was used.
>
> Changes in v2:
> - Split out of v1 [1], as David suggested, and based on
>   page_alloc/for-next. No changes to the patch itself.
>
> [1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
> [2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com
> ---
>  include/linux/page_ext.h | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index 79c53ec45dfa..52a8b70c525a 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -167,17 +167,6 @@ static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
>  	return iter->page_ext;
>  }
>
> -/**
> - * page_ext_iter_get() - Get current page extension
> - * @iter: page extension iterator.
> - *
> - * Return: NULL if no page_ext exists for this iterator.
> - */
> -static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *iter)
> -{
> -	return iter->page_ext;
> -}
> -
>  /**
>   * for_each_page_ext(): iterate through page_ext objects.
>   * @__page: the page we're interested in
>
> ---
> base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
> change-id: 20261109-unused-sym-page-ext-3fb8316ac777
>
> Best regards,
> --
> Shivank Garg <shivankg@amd.com>
>

--
Cheers, Lorenzo

