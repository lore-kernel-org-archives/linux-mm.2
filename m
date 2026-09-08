Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A468BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DE96B0096; Tue,  8 Sep 2026 08:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835B56B0098; Tue,  8 Sep 2026 08:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724146B009E; Tue,  8 Sep 2026 08:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8BF6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:49:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBB7EA051F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:49:43 +0000 (UTC)
X-FDA: 85190576646.29.A2A0B49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E912B20002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:49:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H21B48+C;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2rC79oE90b2dwI8Wn327CEOLpPVN9D2E6erew3jyVs=;
	b=uRjgv44PkfJa/HWe3CfXbLAKqUYECl+QL5v+UZfPXNkBlXY1hLmaac/C149f7O/my6S266
	jLxYzCHZlVDAtc1mRoq0OzIvAhMTR/F4MW8zKHCTNxRBWiqXJIyRQU4tO6QcrbvI238C9W
	e8sOGZPsbFMR8pbnCiX2XJkb3pG2n88=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H21B48+C;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871781;
	b=hVzogRFDMqj556VoYAva/Jl+0qUHNaS9QdlYDt70OY59hODZANdrVV7rvqjlTtrG1slhoh
	UforVoZYDhxYaNVoO9qIiVsMzrv3XhigOqJ1pSqAz0UfapcObB6WBAWtFGeh1U+MJgRQ9y
	vDKFq15k/JW/z4HOE4xrIs0FswgfSGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63E88601DB;
	Tue,  8 Sep 2026 12:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE8A1F00A3A;
	Tue,  8 Sep 2026 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788871781;
	bh=N2rC79oE90b2dwI8Wn327CEOLpPVN9D2E6erew3jyVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H21B48+CODTED19M4/Omob27b4Id9ZDqXLmNXXJvVvZhlJ6+dBe1fEISd7C+nfkD0
	 c7g3K1vJm5Oy5ezg5YgUGMFQUJKpzPnPVTgED6F3Ym0RVm+OmNAypwfr6bRukltTUM
	 r1783v40mWOCxLs1YZV2HW4Mw7lR7dYq7fLSZsho32UVrp95SB8ONSGM9sQVzk1R7a
	 QTDYn8GO5aZ2hhnPFWIkUkYn5xYhbtgFQMGDxhtEBWgpWijZBkN6KDVEw5VvA79qLD
	 XDeCGhb23RijvvKmvCqBZ3je5AsnxF2SzPzPgvIytMHRf98jXxpokq6T9hjfXnv/RG
	 8HoXeGAoD0x1Q==
Message-ID: <e743b598-9048-440f-9124-72071c696679@kernel.org>
Date: Tue, 8 Sep 2026 14:49:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
 <20260908-map-private-dev-zero-v2-3-acc7b5625305@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-map-private-dev-zero-v2-3-acc7b5625305@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g7h96f7x7ugtyjod4twmcijn3ng9bcjn
X-Rspamd-Queue-Id: E912B20002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788871781-253598
X-HE-Meta: U2FsdGVkX1/j+yCbqWgRsG6yhj6tL/QH7wgICRzXlS1N3uM+AE6hcId4WXGzcO0dB28rgdWH0ViERJ7N9BkK7reNHSJWPLF2kVKPPRiF/lcSgbH6MNeVBETQU46pN7A1haVLEcpoRtYPQX0AHt7o5rXuJGADxWcsSy+9HSaMKemrcGFpngxMgo0fg1UMmpIS/UeMzhUcz+VJ+LX/vn79OfdTUZ5W5ab6cSJDlSxJJdMCL0Xjw2+Dh9m7DEVShs9VQTialUbhpJHQf7GoHopROfwPJsYlPuuDjz3vBJAFGvVoO8dErT4hvDG9dLmRQ1Ivpg9f9bFhw1d4L6xRshcnNjY6eP/Wp46qwJiujVMPYbjae1KuAR59+oy+Qe8ypNR2ZyHzFT3a694GF1RIlpMFchjsobn0wfK/EY6wP2p5Shwi2YG9fNtoDHS8xpZtxV9XRrz7+L4E87TNKBfDGXmba5I69mtgiLJK1AQvbCFSwbFwbbQ2lnHmfzOSCjrI2UlZRee2QwXK/defqJN2NYdz0zdAIoLbfSB5eW4AZdAFxq672toXEcDv9m4ru6oNx6x90aYrtJV/WHHpDmeUuRaRjpGilPnVGjHC8Rm41sdEi6bELzVgfeFthWRr/H6nd/u7DGwOjcxmrAMLNCk/PCPogVklYIBwsnFvwxzL2vnUmS9/0UtN3na+WujZx4mJnNZDjsQpVHs+zVxvGVHnHglYreEZxCC5ZELCcqXDbaHTYMMAyyZRhijxA33b7LMBbZJsSbAV39SB3q/k2GicoD0vrUgpTO+MeVQco5zfsgeDQKVlCcCF8+nf3j66b9dlVxxJIMt/bchsr/PBeDM3Tv51k6uGlwFnYIr5kELslhNeuEsG4/ZKl6advcuxEOXOXfvd6Gwn0sItNrHF2JqmPp8UR/DHb3is4j0utauSNcGOWx98iEK40hDK/Ra/dDmfMr0aEbhfzJg15X1xL8vye5w
 c5nhU8L0
 9fdLH8IfFAbx42hZoWkecwzf6pm6kQpW8ZERHeasZyLo/Dm4/4WycAukF4T+jbg1kftFyOtd1cTvb2NhpIH5itn4loBqOKBvjTOsDzGD151P9xlnHUpkzWNJNk0uGVI9txebBmqvai5kUBtCQzWUv0QYI2QM83mfJ4jzyzAOdYZq3g/B2eiFqlKpIgDHAW9v5eNb4gVnne82GDIruXNhZ38ms/Lqg1m/gflPc5x+087lh4dQVsbAopA5hp0k+C7KUsGH2b/XjvogiDTSsGvC1oe8eqqREMFTzWLp0iJfipsBw9QlQjcu0p+RxQKcAVL9qzByyH3c8zA/S6qGyu2gMBafsqDPXEEKXEhdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
> +	if (is_anon && map->file)
> +		vma_set_anonymous(vma);
> +
>  	if (error)
>  		goto free_iter_vma;
>  
> @@ -2777,6 +2793,10 @@ static int call_mmap_prepare(struct mmap_state *map,
>  	if (err)
>  		return err;
>  
> +	/* Hooks cannot mark themselves anonymous. */

Wasn't this supposed to be reworked? :)

In any case,

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

