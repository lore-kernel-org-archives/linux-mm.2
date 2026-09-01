Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2917C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0930F6B020B; Tue,  1 Sep 2026 10:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043FA6B020C; Tue,  1 Sep 2026 10:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74FD6B020D; Tue,  1 Sep 2026 10:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD31C6B020B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:14:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14D44120407
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:14:56 +0000 (UTC)
X-FDA: 85165389792.10.E839B0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 619001A0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:14:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hg2YUaCA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788272094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gb3WPV9LaelPCjepC04UpYbhG+UktuLZ6/ZSgNr05M=;
	b=LPhwKqLY7NeUJ8H/Nf1QOoJsMWPsTR8t9pLfeV1PPtUkzzT5tj/SZl1VhdU2yL7BemtHUn
	4d4zBpljiQLYwlGG2QUCTN+qvN/BsF13rOEWlhwxEKayB4vCuADlel1aVYLoQ9yjTNCN74
	RBiw6uX+xMwjZnT2Qw+ws5proJwRYbc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hg2YUaCA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788272094;
	b=irrSIdkjxo29n8ZjZdqVkcwr7zHZ9aL5sUn65MGXlVC+/m0iseZMVvhx2OII8kcXpAt0qB
	pob3nAcpJXh5NPYtvcYlnEIEajjTIOQIMf9uiLkXzim3EAf/8ATZ4sYfoV3h9FXuSRhtpK
	pevQJD22ZzRNDWXEXECXIibei8mx5CA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C87596020B;
	Tue,  1 Sep 2026 14:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB54A1F000E9;
	Tue,  1 Sep 2026 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788272093;
	bh=4Gb3WPV9LaelPCjepC04UpYbhG+UktuLZ6/ZSgNr05M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hg2YUaCA1Q0xDASG4x9lRNt+MsEywtRuU0O5mM/znE982OmDNT9hp6IdPFQ0OHe1b
	 J+F+xmDHSV6O55BRVyhfe7iG9H4u+fSr9inrD/j1FTwRRRJ1Cod5cnpHT6Z2PRMWRo
	 WZA56ZlYvlRa0ro4tcRCBIObhZVSYa4+TLBzV6GygyXWd2ZbZZ/9H/h5sN/5VaTuuQ
	 2av5PO5yUHg6Iz2yVbzr0CD7E5N68MTW35+722SM7OjpYDPaXnFHUMT22byEEzeSlq
	 dPOBFldXrH5/WUnTWB84WM1op9zUBb8YUxaEURqZEelADzI55X0Vtcpun7GoHofMKz
	 30LmAfCwNFFig==
Message-ID: <de71308a-52a9-4e3f-be35-3e1951e34a99@kernel.org>
Date: Tue, 1 Sep 2026 16:14:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmpressure: remove window size TODO
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260831-remove-vmpressure-todo-v1-1-498515e59cdf@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260831-remove-vmpressure-todo-v1-1-498515e59cdf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9ojjf1raqh6jsku789s6nhyxwfwydejn
X-Rspamd-Queue-Id: 619001A0008
X-HE-Tag: 1788272094-823982
X-HE-Meta: U2FsdGVkX1/j/0pfXU40ykvlzNL0Gtn6d45B4xjjw9tuyARjYmaSL+9i0y7SWyDcIrXG/F4YEiytah+UzSwvYR0wnCc3/bigJDQMPrapLIT1f1B53/kTvmB+0bRmZcn41IT4Zbt6RXFfj67d3yjGyWmlVb7ALmLoK90k7F1fDJ1ZUAmbYrmyyJs6lJmKcDGOVldmFU2e0rd97O11hTkyRqIXmPH82i/5ktR/1Vr+lrcoM/1KOKxUVEl9NtxSHcH9ourkOAlMu8UzMkL3S0Zo/IOEbROYFFcuRJyL6nguBMlWaToxLqSDL6aJ1jQmG3UBRC/QYKLdLuDIMBtRJgBDwg0l8ed59zMkf7SUrq/dsdTQMU0HaSEpc5dGUW24umF1n0YD394gqtiPdVgPEhA8kyvy17yKx8MwtzBd1/SgPGPsyoTbhHA+sMIRB1FCwICTaY0iT1oGF3yG666GYRwZaKN+ACMmmrCdslHOkDEOiGGsC5Chl+oe2g4dIKbziilx3wnTpPwbW1ccFPLbQUFpOC+lz1O1U0zrkFLW3AcQfSk0fEEFo9RgrgBra5H//26qI8I+/I7uYaST5LuEECknLKTtX/SJA7SE2Kq42rJCgty/aNRePT24avzr0HZr6sc5tM9uJd8w5hqYY35D8ptHArQZvNZR/tv57dabTU/4llXvnf+jGeefLUud0TRMqNnAcncfK8GWhsZoRDUBwTPRsIdISl93dQ9Qf5arLUw9L9sdI65PcJGR1bMSHC6v/SUI+731uJ9Ioc+gYrPHXFH/iq6hpBxilGZKu8GXYXykvtGtyocSe3+Xv6ssVRmg7k9GVDIjOEa7ESIlV89xipwWJIOpLtBboTTXGSXGLwQ1wXF9qiitg+NyvXEPRyOF+TVBdh/Zg/VD6wckh+RTwoct9nGW39KBKJ5PnfgnNyLqq0U1ww90rBMzuDTp/ayVbt9tdxKgy8HzE0DyLJDCbpy
 iQpS7Q3c
 qouVIETnwJXjiIY1JlCwW2MSGL9V8HnvPJ98c9JKHUNNKPbLSyb87ZJYjy71SpnAfIH0E62/CW6d+0r/1rztSWGGICujqVi6RaqS//YwJa8wf1W8scKQB3Q8ELaX6x+9gAd/751iNyz+APJn7AWkD6Zm6PfeCamMOBoIG/XCcV5ehk5iNOFbs5DH2/As20OJmlFzjXPwTRpTElKxpM6dEFS0R/aJertjfcGP5tKZR1sV0KvqQDoOuTZPGrZJNfEHkoa1geyNP9jzXbcMB3LvSAXeOUNHQT9L/jliGuGbpuaONB6dhmUXHLbA8yEWXuGYIZ+Op1Tw2u/CW9v+nXZG8R+bDniu8LmOF/7Z1/Vx46214Js4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 15:42, Lorenzo Stoakes (ARM) wrote:
> There has been a steady stream of patches that have been submitted by
> newcomers to core mm 'fixing' this TODO, with all but the original having
> very likely been generated by LLMs.
> 
> It appears that TODOs to LLMs are like red rags to a bull.
> 
> In addition, TODOs in code often bitrot and are distracting - those who
> understand the code know what could be improved in future.
> 
> Therefore remove the TODO.
> 
> The work required to actually fix this TODO requires somebody who both has
> understanding of the code and significant real-world data to back their
> changes.
> 
> Such a person doesn't require a TODO prompt to implement this change, so
> nothing of value is being lost here.
> 
> Link: https://lore.kernel.org/all/20260831130316.448-1-tahasezer.is@gmail.com/
> Link: https://lore.kernel.org/linux-mm/20260724054305.516126-1-cui.tao@linux.dev/
> Link: https://lore.kernel.org/linux-mm/20260715143646.15828-1-gaikwad.dcg@gmail.com/
> Link: https://lore.kernel.org/all/20260227221555.29969-1-mcq@disroot.org/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vmpressure.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index 9629240d77ad..3de99fef3928 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -30,9 +30,6 @@
>   *
>   * As the vmscan reclaimer logic works with chunks which are multiple of
>   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
> - *
> - * TODO: Make the window size depend on machine size, as we do for vmstat
> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
>   */
>  const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
>  
> 
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260831-remove-vmpressure-todo-2d764f42059a
> 
> Cheers,


