Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72005C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 00:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473136B0088; Tue, 25 Aug 2026 20:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4253A6B008A; Tue, 25 Aug 2026 20:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B536B008C; Tue, 25 Aug 2026 20:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 143556B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:23:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 792D712012C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:23:21 +0000 (UTC)
X-FDA: 85141521402.16.3820E37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D982318000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:23:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EuAyhuPF;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787703799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgWwbnB1tbcT7QJFwjzuHzhW6jP4Q/k/RcKQYtR/3Lc=;
	b=IsWp+Om/dSq9SsV9MavCD63hQwkDGpeVO0Dgsy9tSFK9KJh9XdPUzZD66b1yJkk8AIjsLn
	Aw89E0yD88l0DaS7J7gJ7P/C45AtsONPpISwtXUtI26/MBrbLpGSVuOam2HcJNAtaz6yak
	HDc30ieCSQ3BNAT+8SkUNy7CywHDVgI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787703799;
	b=tGTstNb/unw8ZfVuCBDROf+sYC4IGTSzhuLlTXxnL4jiKx2RTLy5bzFefwjsGuhA11BUkP
	xXJ/SEdQkuZdMut2JxnAEnPkMvLReNglGo4INSClAtXwj8aW9W34ecC9G4YoLf7P4o7W+X
	HwCrt6xTMFMkSZl7IwAVWPEeoO95xAQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EuAyhuPF;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9289400D0;
	Wed, 26 Aug 2026 00:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8711F000E9;
	Wed, 26 Aug 2026 00:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787703798;
	bh=lgWwbnB1tbcT7QJFwjzuHzhW6jP4Q/k/RcKQYtR/3Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuAyhuPFJ1MeUnV6Ra557VZNexUICiXt40eRNhw+W6jzwQxYRI4ivcpcVzw1LsEJT
	 +N8CUkMxtghi3z2aU1mAbfYqfC7RAc7hGXreIrfY5Vdk/eHb6V4Wnpgd8S4JyCWD+P
	 yNF6xzNaXhQm3ht8+jpNeWB3kkBqZ15IdtGNqx0Hx+FYWDC6VE7yxdr3ea7bmc+Ro9
	 avZYsrM9Io7GmP2aKpu7AEbWQSvi6Evkm2ydCcQuU8gCnjPTuBJ56nAnR3N2gPqWjT
	 B2uKw9nbg2agz2Qq64oXdN9qWSfF1eUGkUJH6GnHYXwd2FyQW/9jUKDvg16ndrFPO1
	 ZENYUIzDVvhFg==
From: SJ Park <sj@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	ljs@kernel.org,
	yury.khrustalev@arm.com,
	kevin.brodsky@arm.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Tue, 25 Aug 2026 17:23:09 -0700
Message-ID: <20260826002310.64811-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260825161715.2807297-1-hemanth.selam@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h9kngptush5c4xb4u4yswfwatexfn8hy
X-Rspamd-Queue-Id: D982318000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787703799-809749
X-HE-Meta: U2FsdGVkX19kJpME+svCBvUgGf/TyzCTfuzNxUVgbGBc5aJ77iVyFHaoff0rTkGDkZjpdnnnMFL2aBIOGUvGEN2L9c4eaQpzng9+I81OcWbkv/M3VVnnuFKp1ocV2lFBjlkBj02DkrJGt05ltLIgjR3sLxxo7XRUKI217vtLGkYcKfBXQ7wEOUD8Oyl4Uyxy4oiVIgY1xM0OcjhKIHR7SKmQD1z/w/1iuAC8DXLsRbewVIcUAFbnqxvpW4KWamfSyXIvdF6Yd9K3p6TyeRWFYL9f6kv+gYRc05jrlZ2xfxiJszEoxXn/jwvU0sHy7RZjF13/faMVzq0J22OdrTm7kl2LkC5xxisKbY5pRyCWy/B5AbvfN3RMR3y9MbSDGqPiQTeaIS/U988OOxg2hKRPLaUmUs+cnFtreTWevr4qwBtAxjsjGSiv5U8ARCM6sIHj/oXh+gUf+zZit5dY9HnaqyMUWGqnSVn25/WksQeWHXdTVvgxkzNVzQJL5+WXJtD8gsZ41gezpXuTuGbixx3F7aiH1B8RlOGPeF7TiUa23vR6pm1o8tqHMx3UGqyAxy0eg84diszeOJyPv23Mk4fz19eXAVf01mrRX166+Rxql4uKrIlaMyXAAaf9QjuZdwTZcdFAZQvb1tNyji50yZiqP5+nVQ/HtV+HjyYAAYX8SV2guHjt6MHATs1GoPBr6F055SCWJl3aZ3hslUmmVgTPz7zP85MWYZ/FysVOz7uSS3oPHpuMQHh5OUPQ4xygm+McAZDms6gXZO0R/ldqeOUBhFTA4tqtfc9x3aRoObjb2hU1ASGyAXmGVcS60Urr3xbgERl1ffMizch6WKSpbqef4Fg3ZY+IYFN5ebPMr+T1lwtY3o/agyYHvfucksmk/wbH1otSWISz7a3WwFkzWv0dcE7TOgH6mXKzSy+JWBVuLAlfk4woQegHUyAItJMrKr0N562Tuuld7vQooyQ5fMi
 wvh722A/
 69jL4lNv4/+bXT1FlpK4Di/3yeyyGFkENG65bGgTyWkeT1Rp6l3NHTb6gNCcCNR91xnidp8AHxA3rIqvhemd2ZrdgBIXwBXEvds/udoKK/AFxv4xLFe8EvOfKuSwB9tFPzjrSdrfQ1UTnjDtgFp+THK1WSzxe7KpFv43fhco7WHX9W5dEDnm6OPqDa9kjmcTIloULClyAOuGRhNW2TXiO3H7f+mlq+Rs9mr7q7Y1HSg5gjxj7P8yyCRatHfDmN6ueRIkr3BTvHR/dAhHoVqzRV9oo0ffScr8A2GD9hXsZBFweOizpMFPSrUojB5rJqf6+6KgWfdNSEcWEfW4CYtUtHM+gzSNqe2lPpqEf5u96wH+2hcC4N5fhp/bPiOMzn5oL7daB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 21:47:15 +0530 Hemanth Selam <hemanth.selam@gmail.com> wrote:

> pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
> already known, a stopgap from when the generic definition was still
> under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
> Add PKEY_UNRESTRICTED macro"), so the guard is never taken and the FIXME
> can be honoured.
> 
> The definition comes from tools/include/uapi/asm-generic/mman-common.h
> via TOOLS_INCLUDES, which commit e076eaca5906 ("selftests: break the
> dependency upon local header files") added so that the mm selftests
> build without "make headers".  It is reached through the
> <asm-generic/mman.h> that the system <asm/mman.h> includes.  Building
> the pkey tests with KHDR_INCLUDES pointing at an empty directory
> confirms that; emptying TOOLS_INCLUDES as well is what makes the macro
> go missing.
> 
> No functional change intended.

Makes sense to me.

> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

