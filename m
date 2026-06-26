Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B07EACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512F76B011F; Fri, 26 Jun 2026 07:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4886B0120; Fri, 26 Jun 2026 07:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B54C6B0121; Fri, 26 Jun 2026 07:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 136756B011F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:08:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86516C1F13
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:08:31 +0000 (UTC)
X-FDA: 84921790422.06.88E11BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BEA65A0004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:08:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/X0ysJg";
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782472109;
	b=hDr38b1D4kYMvVzF4qkUsE9lLGGbcboAeIYWbdXygluCt4O+xXhaS/BVqe2gQ+oyTVuv2S
	wliCadWdC2rZEehQGnc48y+0wl4a92OJEpgZjT/3+LsI0hFdFRae8z0ycN/GZEZ5OPqSPM
	Q2jKX4Noft5z9bA9R9ha89fGI21e+4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782472109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/8Fh1fTgirJ8m8opIm9eSsJmFKsQKLujtcObR+NzUI=;
	b=vLUNUgcvtKLK+hgBnlejTuiO1B9pDeErkfU/9qke4o/9dxRNrK+ixVD8TjNt171ept8Ozm
	9MRw6AOIwJA75B2YJq8saJ2isEs3PnIv9wH/Ig77JO88Tk4u1DNud7C9jtGJjmaFgq0yYv
	ZH130VTF4CqXwPawJ/pAKLJBWY/k+tg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/X0ysJg";
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39B8460098;
	Fri, 26 Jun 2026 11:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DE81F000E9;
	Fri, 26 Jun 2026 11:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782472108;
	bh=l/8Fh1fTgirJ8m8opIm9eSsJmFKsQKLujtcObR+NzUI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n/X0ysJgGorfmYgEiZVy+KEk7r6M/3QuiWxeWtzAVZD/cMvm3TLiBMZpjiN3SleAE
	 Sf1UK4H6N5Omk+0koIpzJafqSrBuQoXqGF+uwumXsvwQ2KvTiLq1Oku4vx+ABRCWR9
	 IGEMLlGxtXnceyBrT0/IbrHs0bMYQCv+aztMpIZ9ybcY6CTguZ7Boz+J3nPiY1qlER
	 R3rFTuFOy0GDjkOh70F32zl9MQJjwz50RLoNeIoDp7HETooyrVeO1FIl+Q0yy0vROw
	 T0RMbGP7PKbeDZZv7Dkf6WOCTo6HGnkOwXwBLO6oHZACzx1mbG0P4ny0p7p1ZV2zUQ
	 mpXtJOrJOoFmA==
Message-ID: <bc85aefa-ad3b-412c-a931-a0b94e77a8fa@kernel.org>
Date: Fri, 26 Jun 2026 13:08:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624100320.430115-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260624100320.430115-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nqwkcewt837fq1oomy13sf7x94iuratk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BEA65A0004
X-HE-Tag: 1782472109-932064
X-HE-Meta: U2FsdGVkX1/uWUQ1KWfneb8s189xy3g53+8JsMinhgRLh+n/B3/dopZyGmMuluqBy8T+KXin3dNvlAHhlZx7MaeeJNwtdWdULyLeyNdxfo7516c18CYvWH0u334rU7T0vzVBeOYZEcfmnLNR861x6xhGjlo/W7aYoj4pnKLUyBhV7fwecOF86ajraxTzhfItHynyJ0qsBs3BdhvgBReo25X5HxcusocihORcu5Ddji1KE+W0Ra5NiaREAWr+nHIH31i0zbCJWK25x33QhzJtYaY8ZPe8Z2Z5Os4smIqw+c9hiYPkB+gw8vNCWv+ZynSC3e5AD16j6ruC5odnu6/2bpCHdMkkiSbrpo/HqahjzTAv6RoYQrOiAYZJ1hkdLHRIsXVtJt/V8TrfphqC1+7YQgO2oHYWl5mWGVJq3yud0JXQEz6dzXr+GqL/6JvAeLm42MIMhYhkCUNVv7JB+jBjK/xrLjvioKOI6DEWStb6tzOpAlI1ge9vTrqEnRg0phlDc80BoWV2eJIY0POoxoCOepCnCpkE2hKScCSqqUUPcx39jcZJtfP/hHTzHr5DpGxJCkBmGsoI5uXWy8fU6ZZ46dRaBDqIfuGujT8DDWxs+lHJ1KGr3NlyHvZY6zfAHr9cJ0ueWXb+xmnRip9FlGbzOAkCZ5x4sgNnCCXAzynxjfRB9pi9xNyOCXXOb/4i/9CxN9O3gL1t+JSFjAH0WXFh8+GcuEgYhTfGPZfBZqwK/r7283qW2Vr8hbRyMKphZALaZSSdsmRixmLOfah5wj8ODafjnCwIMa5xucf6fx5Co8GcchPT6Ohkxhq4uEfcCrdfCT0xDrH6md5rio5Sk4+PJ3RD61GQij9fesV5oySc4EMkEkzuVQ7c6z6aiwu6FcMGsyw1MJNdEbqyv6J0DmMH+aObm157G554g4SrZRpMQl/K7pkcPjJR3uzJpW+W75FUzu6ShH8FTM23OAfCuhK
 jha2VKtp
 6zpRxzl95+UztiFiMRZggwbP1ubteJwTvYMF4xL00oMyddw7DdG3ukAXFf2o8trXxWfwGSyI2kH7WEqo7PoWIqVIJt1N8BrGf/jebT5HsQZvUMpIk8Fu6iBbr4t4bDrSghuVJhSzNdxWPLN9SQLBC2fcgHmsBz1bOqYEf/l7sXwpvw6+sGxui9nK0dUMVjbE+HZBVVItHcvL52yLlgjhbqIkinmItV2Myho6dEU7D/974d3WIe7lbuKd9xVE/v9jK5aIv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 12:00, Hao Li wrote:
> Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
> NUMA policy independently. Since they are called consecutively in paths
> like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
> redundant code snippets.
> 
> Introduce a helper function to resolve the NUMA policy once, eliminating
> the duplicated code and reducing execution overhead.
> 
> Also remove __slab_alloc_node() function because it is almost empty.
> The callers of __slab_alloc_node now call ___slab_alloc() directly.
> 
> Additional notes:
> 
>   Previously, when slab_strict_numa was enabled, alloc_from_pcs() and
>   __slab_alloc_node() could each resolve the task mempolicy, so
>   MPOL_INTERLEAVE or MPOL_WEIGHTED_INTERLEAVE could advance the
>   interleave state twice for a single object allocation attempt.
>   And each retry will also advance the interleave state.
> 
>   With this change, the strict NUMA node is resolved once and reused by
>   both alloc_from_pcs() and ___slab_alloc() in each retry.
> 
>   This is a behavior change, but it better matches the intent of
>   selecting one policy node for one allocation attempt.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>

Cool!
Added to slab/for-7.3/misc, will exponse to -next after 7.2-rc1.


