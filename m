Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5A2CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719E06B02D4; Fri,  8 May 2026 20:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1416B02D5; Fri,  8 May 2026 20:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E1A6B02D6; Fri,  8 May 2026 20:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 500DD6B02D4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:52:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 017711C0FEA
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:52:03 +0000 (UTC)
X-FDA: 84746054568.01.CDACFC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62E9320007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:52:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YlAkkgNc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778287922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiyySYj4Qwa58vltkl3CodZeE1H93QW+OkjaWlH2w6k=;
	b=b6rhB3mlSZcCWpbOBj83QIBSPe6+pzJ1Fu99K2F3khG03rKsZK8jX/GP7LYFB8owoJSQEp
	At9NIWaoB4onNA68D/227CIV5ggQ7oXNrl8LOUQBnwfuJCCDOz3Yt5ySB0dYcXglbrfOcJ
	l13i1j7bGyi+OSTPhD5NxgOzmJjgM48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778287922; a=rsa-sha256;
	cv=none;
	b=uAwF5gOiFjCwNKxQckd1qAnEmX1TN6Ke376HOMUP18AcuUnp2l3yOEdJVEeGF8gOb/HQjX
	hhceEaBEF6LDGqWmnhwLhrO/ML3utz4gHpJXP1JLZaD+Ej8sYNxnVdcJ7Jh5TqHcN7mRec
	Bet8P9vjJLM9KfYRA+zhLRGhcZjoe0U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YlAkkgNc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACEB76024D;
	Sat,  9 May 2026 00:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BCCC2BCB0;
	Sat,  9 May 2026 00:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778287921;
	bh=e3ztE0rnQikB8fImgVEXrEibQFzHZ2MyHHIVueiiZC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlAkkgNckl58MV7JlE6tfdttqzxk21kwdqCFEaZ/QxhlkX1wL4B0XstEM4e2PRgUI
	 h47flzc5WNIYJbRgiZcxseMjY/RdnXxefVMAU2V/eUkuISAyJ8CmwtmXy5W0oiJby1
	 c3bArAOoFddqb4RzxbEKUWHhzEovycd+6uygAzf8pfedZgoujQBfLlqAD7gKKRyNMp
	 Fxnp6gXmX0edRdjAnxo6TYk5XwmIB65ElrT27dXfsOurRaF8Sfcvql3kC9Jq6ZAbbD
	 rZLu+xxwJOY4Vqg+K2b6pfqhSC2UVowomGWKTw9HngsE1upvsSqfKjJMabdG/0lDVN
	 6gWs1ezKOfpIQ==
From: SeongJae Park <sj@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mm/page_owner: document page_owner filter features
Date: Fri,  8 May 2026 17:51:53 -0700
Message-ID: <20260509005153.84410-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507064643.179187-4-zhen.ni@easystack.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62E9320007
X-Rspamd-Server: rspam04
X-Stat-Signature: a1xxrffb39xrp7bthx5f7xuuz4wq4tz8
X-HE-Tag: 1778287922-56780
X-HE-Meta: U2FsdGVkX1+cr61dM79tPwzOXAo4xcQbLFqcaxhrDF5Uvo7kpE9rCwb3VzYfMpZTRVmOyZGD5IHe6hxW8tsQci9lEMjhneS111nqJvwNiVhu426Da7FDd6l07W99b2j3rGOMACALpjlGUXos1ql54n1TW/Xk2+XGcM+2WGDcEWM72UGaZHh8toQPJ0uBPTyqLHxnuEARk/XY+FpBfZh0+CEIFptZkiyn/Xwgex4ld8Yyltc3cj4pZ3QzOtwMf7JufnTv7UvbbueCexGvNSDlYdmtsXV3t2tMdC/WZ8fufUATyVW+pKdSz6gAKExzZwVKvDGSbot0p5oRun0jSH63HcoQPbCJsomleBbAt06tT13lPL547nzHUE8lBj8lSgomnr03/ldyEy5e5QIzBhbLYUAfwYcKyPOu+x5YziaBTTrHhpCiaDr/paAV0ejAWGa2YAxSE9VHbR5GWuOA+aYUiwjty3FaO6nnb+LhlELVe6TzJ3Ca2zSyeGl+LUEsxf6oljmVXbSOH25NWaf9TohJOCN3Y2acUNUz2OzEkqbRMrua99cNPG5SqXqrjJ11aQVLwWhH2FbZNAR7z3EW8/JDw3cCxp8phy4821/RdUrNX+ghG8hpaHlrRSzlXpv2TgF9EFkSKARjeCJ0z2xTmdDAe8iyD2RyBJhb+qRNsd3ESNzSQyaDM08bwSzXwvvuTPGDe6tJrkBZ6BYzgyRtxnq+xOpABhqD/h31N61c/vsacq6UGyn6uJet4507hPDHAMKfl7F0vHe7/Gg6ZfZHqupPFUaooV3W4KrmahpG8M865oS5l0VCDmTVv6RuLpXdUfcB+rlBuyazwOh0lxdO0ETM+mx+DZozOc2bOqspLKs8s9wS4KnqzTPRcnx91rv7GPm3nkIuUtyX8wqvVrqfmFaLQZUwNFggOsMm++s/BC0/aKSWA0W6XPw+LjmPVB9ltvz5ow9knrfzMnR0etrKETc
 iAafOiq1
 pA5m2YWrkRQjMRHKKiAzSIeCO5RERJxCkCR5k0eLuT+j8D/TOY2A+QYumECXp5Y9nm8GNf6AJ3pGwmsPGi78i9wxglSQaag0bN1XfTdNStNOt8KprGW2O3K57ZsI1/xFbPpOE2GZM1roMtEiT2EbDSkVwL+mcX48y7LMR+w3caAV6cUd9748f3gVknV6zhYgqsI09DEcPSxeOfqr/4xUrtNw4Go7DKyUzjT3oiuFDP4QeGZDtlaZFt9seNBBxfH3eb1OuKLwZcpzlHovfV0hHMS4Rp4QgEl4hJj5Otp8LVyiQ0f8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  7 May 2026 14:46:43 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add documentation for the page_owner filter functionality, including:
> - Print mode filter (full stack vs stack handle)
> - NUMA node filter (single node, multiple nodes, ranges)
> - Usage examples for both filters
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> 
> Changes in v5:
> - No code changes
> 
> Changes in v4:
> - Update print_mode documentation to reflect string-based interface
>   * Change from "0/1" to "full_stack"/"stack_handle"
>   * Add bracket notation example: "[full_stack] stack_handle"
> - Update NUMA filter documentation
>   * Remove "-1" example
>   * Add empty string as clear method
> - Fix indentation: use tabs instead of spaces in code examples
> 
> Changes in v3:
> - New patch to document filter features as requested by Andrew Morton

Adding links to preivious revisions would be nice.


Thanks,
SJ

[...]

