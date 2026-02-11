Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FC4ECD6EE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 21:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15CE6B0005; Wed, 11 Feb 2026 16:55:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0586B0088; Wed, 11 Feb 2026 16:55:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6556B0089; Wed, 11 Feb 2026 16:55:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5AC6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:55:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4542B8BFE9
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:55:55 +0000 (UTC)
X-FDA: 84433533870.03.8B21E80
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5C01140006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:55:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QHBu58CM;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770846953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rb+VtnPgyX+Ra6gHU58goRwQsnZt12jPG+cuPbuWzX4=;
	b=eBlCD2LqSNX+5JndJf9moblP+q0EmTIwp8R8PrhVJHB3aM3TSsrIGco+fqZoT684jiKOkE
	CNChV159aKFZC7INMsSU71sSygweRr+0NdafJ0SL/uG79ydFbSdOOAHRem7eAQ237VkJ1M
	vmriQJEMYevMvVa/cLRsikzdcSbrMbU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QHBu58CM;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770846953; a=rsa-sha256;
	cv=none;
	b=EdIW2Pzz+z198Vb4VF7Z8DBG/0gydh36Q8yUtz07TLYabHVUcXY7cdg2WU7G0N5BkL5gYX
	/JDMvAIMQK81Skg+9XpTu6+KLt1xhySH5vyBhtJ0vioZldLIFzEAi0pjPyrRyLfNgPOmgL
	W62Y6ohC9nYEN20OKyh2zJufpHN8Jn4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rb+VtnPgyX+Ra6gHU58goRwQsnZt12jPG+cuPbuWzX4=; b=QHBu58CMP9tNGFBXLo00CWoUgJ
	Y/e1K+fN7H/+BYMDo2p5sXu6oExAbkm/rRjpXDBw4gyADeIDwOjmQ9k6EyiQCb6XNfWoAsSqZbv8t
	FVfVIyuSh3VYYVI21zYKqxUXNWOVTtveWh+zOr2kHqkJCvmE3/Lz59W/DKjaYy0AYNbpUEowi/nD1
	jQYecxJnZ2/bBD8/YMVbHSrMeYDI0KZdhoP4VJjq3PZd308Ad6jJz3Gyo8AsSiF5IimVC9rnA2y9B
	RT9ZIkfgJ/bG8NrFzhWWDSh06riVgmoJWiurCvG4imqWb/T7ceHZQUh4Suy/e6weCQZYY1RO1K7rz
	Be37hsVg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqIBc-0000000DFI8-0UIM;
	Wed, 11 Feb 2026 21:55:52 +0000
Date: Wed, 11 Feb 2026 21:55:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 2/4] x86/mm/pat: Convert pte code to use ptdescs
Message-ID: <aYz65w4TP37_t97o@casper.infradead.org>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-3-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211195233.368497-3-vishal.moola@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A5C01140006
X-Stat-Signature: na1fne8gyjequr36w57zr7aw9e6ci454
X-Rspam-User: 
X-HE-Tag: 1770846953-452892
X-HE-Meta: U2FsdGVkX1+KqQaec+vMIM65sj7MBzdLTF4OEtwqCBCA8Hqq5NMIMb/4GwelmS4WPX8/Ov1AQFG0Jf3n9tnWumS1LHhkgRXGbEb21cScMe49AGWLaWMaRJBWp8ghHgfHCA5s0HxmbT5wNQzsuMC0k+1UFDRTD4FHvtfXQgLhKfxptzQkuEkP1Reuww6ZZ5oAxANi8kNumTrb8x57e/gu23QUNQ72dxfet9iGh6964GAzDNMepw7vRumeTLxD4s8CQFGarkmLMHbKCYfjzr1cNHoJUEzMl1DpxmprSsfY48z1D7MfJrZqFClraH/pXvzh9Ypl/oIPATs41md7FbzKSbEUpJB12u2RJIF86c6+TL7tJxrK1RLmRoWUbMmBeRPB2J08bpgNDviouQiA0ZlOMLgb34UTeQTRhpYC96NHTfBuzucssYgXqsX3JlDsKAF1FH7DSY5DpPXZyR2wgCHRaoIXVrZKe/lUDa3fStHM2aYGVfNIRJ6ZPMawg1+T35pQXUfqgEatWObmY1rY1Z43RcSMaDqunU/4W37lgbpGnY6nQuyF4lIZpJsE7SxbekGdg4rRZRKXBm6hhhC9GPAlv89jpCFit56H5o+1nQFkXxaZ266d+PpjNEk/wRcgrraKXKr1FjOj914jtG5bom0mnUro/XEbFtjHbd0dnyX3uS46L76OZCMxlan+hhEjdPxBVGDBjJaqolNK4P40AUmAOvH5s2/dfGuBrLtV4dLX/Y89CYtMZlNcBPa1W+2h2Cf4bU+wcjEO3qzo09ghtwB7iXhDxIK6sZ4EN8Z/4+SZv6C0y/AzsF3khTrJBqiM88wyQjm2e1dmvxzjEKJq4Fv+jHzmyFYVL16g0dIn7SAJ+mCClQlKvwf5tig2s4ioQLoQ8TTQDMeN3ifaMaA4BbOiyqfcVbkqfmYSax8CTRqzsoAJIgmGAyVgF0r314pQ9mG0MPI1pOOTMLFeaT4Dfc7
 F53LjLdf
 ca5sOjMyhz0JS3YHoNFAEaabAiUMbDbHRP85sS9koRiNmmLt8ivuFKF1cV0BcWcAwb6Q/wCINSdGheMeUi3CVuWdXUXITSnVXoC3021/WbWfY42qmvcidZlf9OT22auuYJUw/wVev7bjoevu3ahi3W+o1qN0DQ1y4g7PjoVov96aDMBEfkuAbBmbGYyIUNqYMqCAu24lDK5n4ITp5WND3Bl/GkMLvfEehjOMlz1KWx7ULo6RugF0kcrF0oiCbFXSOtl5q2BSDTSe2RY7jLN6K632M7pRyeUfFmGpXeiFQxh+9mI93LbiCskD1K+5NEBg/bwVJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 11:52:31AM -0800, Vishal Moola (Oracle) wrote:
> -static bool try_to_free_pte_page(pte_t *pte)
> +static bool try_to_free_pte(pte_t *pte)

I don't like this name though.  You're not freeing a single PTE,
you're freeing a level of page tables.  How about
try_to_free_pte_table()?


