Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811CCC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E71A6B00A4; Mon, 20 Jul 2026 11:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696626B00A6; Mon, 20 Jul 2026 11:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586206B00A9; Mon, 20 Jul 2026 11:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2044B6B00A4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:39:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2ACF40208
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:39:20 +0000 (UTC)
X-FDA: 85009564080.16.0648276
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6E34100006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:39:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fk5FRTXh;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5bH/9377EtYx8zqYNxrB7m5M0kzmX6G4jQdu82VE5U=;
	b=Lh6M9g6dqakoeoUPDAdVatbMJmwqdCvIZOks4s1UVMgdRJoYzMsoC3xkVfk495Mz3PU5Lv
	aNlvJKuryHOq5VyUBNyUm6XsX6FlRZW2Dib7XymjckEMTRcD/DTUyOTYO3wsoOj0dAn6ns
	Zzn686GZW3TURAQldWI2RIY2dsutsG0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fk5FRTXh;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784561958;
	b=p+jt9CFqZtpUeHLOA9L0veCJTySqH4dVrNe3kNHY4ijIvhWYWnJE3cNYrash4XYsTlPUVo
	KOvGxuRNOKh7SQqkjH1QRKping6vGYz1noRhVUcYudJpoCMfw1kRlzJWZyw+c52cPolBiu
	bFE8ARyjAZXGg2upOdoOjS9CQlhioTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1705442ADC;
	Mon, 20 Jul 2026 15:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5B51F000E9;
	Mon, 20 Jul 2026 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784561958;
	bh=n5bH/9377EtYx8zqYNxrB7m5M0kzmX6G4jQdu82VE5U=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Fk5FRTXh2raEm1DxfQaisaV2AfW0qy/1+a6EkAH9LRKes74TNqxHU7F/sizyjq4Yo
	 d6OZZsykJJzNjhUiS3yq0oC5nIp9lmtsj6EtwS3FtMvauMRWSXbBkUiLC6/1pastad
	 9L5LnHmNeb16NKhKcmRokRvKs/TKyhkkjbQ0ugXmpJb2SrinwOLuNVQ3yoFBAYATRA
	 tfIa15D4wgoNjycvXYUbDGLbJXi3sWVbd3e/C+2nSfLHzilVkKY0j+sinCifgoXOdu
	 tTCNt28SUq6KuUn3hfNrQZ6jLCYawXwNZroiJMnbgPKy3+6Rz4QTStvUYrb3rJ+TJ3
	 HpUo2Jy66nVjw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] mm/khugepaged: separate out windy folio logic from
 collapse_file
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260720142913.846902-2-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <20260720142913.846902-2-pfalcato@suse.de>
Date: Mon, 20 Jul 2026 16:38:55 +0100
Message-Id: <178456193510.466529.13761189910586879195.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4209; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LBY3Lq4B7/dhbrD+6OYFIVX9N1R+BzafiQtXgVQ2Ur4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLiHEX6/h1Ktl9w85vO7wZuOcVDOR3Oj97tOpEQ13dP/
 qlJ2MuqjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExE4Q7D/3yDHenWb1/PtSk5
 XLDh+9wAblbLGZbSVikX2WbcuSnxLoThn5nonsyT090/vbC4Mbf78wL1J3d5JQ3PSLWdPMk4aW3
 GGkYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: C6E34100006
X-Rspam-User: 
X-Stat-Signature: 1sb6hcc3fpnmyarz466mfkg4m6n6w1hc
X-Rspamd-Server: rspam04
X-HE-Tag: 1784561958-115171
X-HE-Meta: U2FsdGVkX1/kz4xgAS2z9U05R2LIaBws+Dms3oW/wB7sn/h8NKZxqw4xF3S0RRf2NmZO06U2ynpjVwRUTagwe7T3DvyAODE6WKys5PCLwf7aUa9AIYziTcnigXSrVkli00n0iExT14WCnz+EvvprYj/8RXw1pRgjTCUEdHtiLhHXko2uS/Eoq1/7RseU2/7eZiZDEG/qpeHBSkfGMBhQDjGVgxUdEatBos6KU/RggbAADslFl1w8yF11aYQRqnqTR7F5DwWFinKp5MkliiYy95prTfjFNl386P6t+24cbBpd+lp9cJxPURVYh/v16RE91scKR2YZmrmiD/E5Mu3gPZCOhuo3zmL33i2+Kq57N+sF5k8Lx0iNMvUgPk21WP2LfigJdXD8DlogepTPtK7ZlvsakbtpTazH6GqjbwZaUO2R0lJFn3vtR4Ns3QHZi8KKdUbcXeCHNwpIvTUI5X/B4aeHt7YYRBOlpksAEqufpIO7pZJ5Wo3QDfyCb5Z6836uSA8PLPrD/4pbDK75YTj9hrhhK3vRJ8d084/0SI8b+mek3mwRRgB4FV/E8IwfeEJA2L+p6IAB1h3CThuzmgE+CxNWLH5mh61AFts1w4GZ/hqR4s7z7F/+CgEnUfGiezO+z6+h8sfP/uQG6Y+Mn3MJFLgxu7OOGL5moNdhGCAmcEI7vG2QleXeZQo7/v5YIHQKNS6zsOoS+ai5ef45toimSQO9KkHI+WY3WeWS9ypLhVqlNipxbBwom5sse2QIgw9IqUO7f1XEAi1Yr71F5iKGOsAWVuSPw1yCWYEqg0WXgAr868+Rs/ahRuxC0dA7Wi4i9QW8AmLgb+9j/lrclZH85yA1VI/4E0dRX4NVcJE9azIw/qDqytsXI6dotGAtsnlElOHlCgjKNnP5io9Yj0fea/CknYENy8pzZ/nVGtEnGvcx/wNvzkHy9Aumjk/RDGl8D1oi687z0nEAonLOyPh
 oxNNEIoa
 ii+vfakRBCqpcbGsxwxtQly4StZlFjkJksoqoLo3y/6ysnAigVbY8Mzind6AVK4VQJQo59UPPPCPjhW9MOVmghihxiIDCnGkXbOm5Bg8RTiIGmZcodJvgoNzgBLq6IbDk+FRPjjrd1D1lcJ6eSjt9N+fvySjHYOm1tuYpWCoIzeCXyjxHn5u02uzO9ZH/s2SYKIzshWe9k+qtY47vVMm79kdT01Buk2oXeSK068AW6Lo7t0uc9eT4AaEikV8p96CDqlR72LeWCUikb1V+A73O0XIXC5Is1NI2bSZG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 15:29:06 +0100, Pedro Falcato <pfalcato@suse.de> wrote:
> Separate out complex folio-related logic from the main collapse_file()
> loop, and introduce a new helper struct to help marshal arguments back
> and forth.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

THANK YOU for doing this :) even looking into this bit of code is horrifying so
I can see you're putting yourself through it to make these changes... :)

I checked carefully and the logic looks to be identical, just various nits
etc. below.

>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 27e8f3077e80..d4de507ac001 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2218,6 +2218,92 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  	i_mmap_unlock_read(mapping);
>  }
>  
> +struct collapse_file_state {

You had me at helper struct ;)

> +	/* in-out parameter */

I think we can drop this comment, though hm it is useful to know this is updated
and the 'product' of the operation.

Maybe something like:

struct collapse_file_state {
	/* Inputs */
	struct file *file;
	struct address_space *mapping;
	struct xa_state *xas;
	const pgoff_t pgoff_start, pgoff_end;

	struct folio *folio;
};

Renaming index -> pgoff_start and end -> pgoff_end and keeping them both in the
struct rather than passing the index as a separate parameter implies the folio
is separate?

(Though any such renames should be a separate patch...)

> +	struct folio *folio;
> +	/* in parameters */
> +	struct address_space *mapping;
> +	struct file *file;
> +	struct xa_state *xas;

Can we just make these input fields const + have the code tell you they're input
only? Though perhaps callers expect non-const (esp. the pointers, ugh.

> +	/* collapse end index */

This feels a little superfluous? Feels odd not to have a start too but I guess
not necessary.

> +	pgoff_t end;
> +	unsigned int is_shmem : 1;
> +};
> +
> +static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)

NIT - this is 101 chars :)

Either:

static enum scan_result
prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)

OR:

static enum scan_result prepare_collapse_file_folio(pgoff_t index,
		struct collapse_file_state *state)

Resolves this :)

Also - why are we passing index and not just putting that in the helper struct?

> [ ... skip 54 lines ... ]
> +		} else if (folio_test_writeback(folio)) {
> +			xas_unlock_irq(state->xas);
> +			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +			goto xa_unlocked;
> +		} else if (folio_trylock(folio)) {
> +			folio_get(folio);

I see you drop the xas_unlock_irq(&xas) here because xa_locked has you covered
below, slight inconsistency in terms of the mechnical change but I think
unavoidable.

> +		} else {
> +			result = SCAN_PAGE_LOCK;
> +			goto xa_locked;

I wonder if we could do away with this goto? That makes it match the
removed code less but you are already having to do that as above.

> +		}
> +	}
> +
> +xa_locked:
> +	xas_unlock_irq(state->xas);
> +xa_unlocked:
> +	state->folio = folio;
> +	return result;
> +}

I'm guessing this will get some more cleanup in subsequent patches? As a little
long as-is.

But obviously makes sense to separate out into broadly mechanical moves first.

> @@ -2298,87 +2391,29 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> [ ... skip 95 lines ... ]
>  		}
>  
> +		/* At this point folio can be NULL, or a value. */
> +		state.folio = folio;
> +		result = prepare_collapse_file_folio(index, &state);
> +		folio = state.folio;

This is a little ugly, but I think probably necessarily at this point in the
operation!

> +		if (result != SCAN_SUCCEED)
> +			goto xa_unlocked;
>  		/*
>  		 * The folio must be locked, so we can drop the i_pages lock
>  		 * without racing with truncate.

I looked through the rest of the logic and it all seems to be correct!

Cheers, Lorenzo

NIT: This is 101 chars,

NIT: This is 101 chars,

-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

