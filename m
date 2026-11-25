Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DEB7606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXzoCcjK
Received: by kanga.kvack.org (Postfix)
	id 9F5C16B09A8; Wed, 25 Nov 2026 05:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD006B09A9; Wed, 25 Nov 2026 05:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3A56B09AA; Wed, 25 Nov 2026 05:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6750C6B09A8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:43:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFEF2120D74
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:43:37 +0000 (UTC)
X-FDA: 85473305274.22.97B6DC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18C02180003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:43:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXzoCcjK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795603416;
	b=Sf/PSmHXtod+SMq5n7Kkqo3KS4gTddO1LUACMkkJaMBPxAPr2jkJQeej44JCL2WECQaGpc
	9vlvYAaMzhjJMy0XNP4KVFLSPrUd6wOtWRpPxtBvE0cZOFIA7mnixV1QikPiVIDN8hfo/m
	EFpzpl1SfXms466nFdFN16i8UQLJO2E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795603416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KH9+zjJow/yli6wyFATGYo7xYjjooHEG+gGLfKcGuU4=;
	b=U7whu0XMRPVvzzoAT6/Uy1ex6GewZ6BZw5TZXBBTwei/m5jTjkeXNHpiDxz+kN9AbX3/Hn
	eJOBx7wVfAhpkMlFVn9N+HpMLKf1rcVumLssIlGu3YbsgeRiPZSZpmGoFhR2g1SgQIVpkr
	cxk3F2rp1i40n+JQLcwvZ3iO8hacP3w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXzoCcjK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9074D60A4F;
	Wed, 25 Nov 2026 10:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA781F000CF;
	Wed, 25 Nov 2026 10:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795603415;
	bh=KH9+zjJow/yli6wyFATGYo7xYjjooHEG+gGLfKcGuU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aXzoCcjKcOlcKrapCYndMdQLYxv5Tp74JT8zllPeKQ8mKtH/ImedZz6T6L96yhbrt
	 OSL/b/iUtXsNuUhqYLy3jX330r7xvi0ibQUNw8WlGQ8zm0ArEYU2kAg2VIkfvmLXw7
	 a3I7KJ/J6tz7KcO9GGVMNZizdktYiKIjGf5qfi1H2IppKsmxE6Cn4LsDKyTTDE/OWx
	 9kiGksVOVqSeuGQccfHi5fL//PoxU7rt5H8Mdo8nubPDgKBPYLUbEMRfLKbpnXcifQ
	 72oKPY6A4CWBJGYA0AYs9Nb5A7YxrkCz9Tuosx1hWk0U8Gj345ROpx2bXIcw2TjgNI
	 R4v0BcMAWPzoA==
Message-ID: <b778d066-8310-4e1a-b564-a0eb51d2fd7d@kernel.org>
Date: Wed, 25 Nov 2026 11:43:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12.y v2 0/2] mm/page_alloc: fix iomap buffered write
 regression from 5d8edfb900d5
Content-Language: en-US
To: Salvatore Dipietro <dipiets@amazon.it>, stable@vger.kernel.org
Cc: dipietro.salvatore@gmail.com, Sasha Levin <sashal@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20261113110611.2915381-1-dipiets@amazon.it>
 <20261116112142.3813013-1-dipiets@amazon.it>
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
In-Reply-To: <20261116112142.3813013-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 18C02180003
X-Stat-Signature: 95jmmf3c515mwnz863zac8rwt11izo4w
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795603415-522392
X-HE-Meta: U2FsdGVkX19aGrid1wOag+PBJredhjwTnmTxhBvtM7xoHC/yU4xhFWtNoLeti8RRtd/AjE+vdMoswSTMiF3tSKMQ9o33H8OFtXAngTPpFmM6+xsyjTYVlIe1faQVSn9eYNOAbbekoDFEi4RfIh3vJ6oUngygR7uVQA5cfydbsXxZ2oEo8q0rYu2VqJo7r6QHWmArjT0exdI3Wfsx0tCBIG16wyKFB136XMxJyZxrdNnJacAEhABSLH+xJpKmcYejdz1cwaCp9Ph+veW8kLVtlHEZJ9WgnhIO0kY0w2GYrakzwtfcOtNOfrRTl5pKSx7zcvJq0ISlRvU+AhiJpvTz9M8deJ2ynY4vP6938vltxQe5Zw6uLE9bRsWPwhRYqRtwYwde/bN78gl6wl1a1SiObMdkjPI8Z6J4DDpJ+ndX2H7cPpKKWHNOltQ4gw4knw3KgTGl/t/onDksI9pp3HtU3D2cth43tcn1W+biwBXPGeQ2G3AOt2+PrNnPW7lh/komobBBMrYGtzupIJOGBaAtg+XwDirKcYYKyw2OGDSX+uDPnL46Kay29YaHuYUdf5G+rb2qh5b6EfGm7eMsNc+aluQMq0wIrOMfFHxgQlOWAzHbP2JYbObOAddajOOCE357DUX4YHv5eIMoGHqceYLmw2cahn5xlXLZLbELPFDEacvT4ZpTZaeiEMaB82G9uz5y5U0cCeJRzrmeqM7JwfymNP84bH93E6NzcoOG3RxVWRUZ0IyfXWFIJmF63vtyalZR/0JxlIUhXF4jUMcG01QQcCesYBp6Et3uX4OU3fFO6IiDP3NrEkfuIyXy5vBHcOqK9bG0KVgfB3t3yYMYyNNNQYWzl2+7uDMTK8gGpR+rSgV9+xecRoIuWuz69i16pjHHGjRA4HlOazISJh2rOIu0CnJFsfGDiR8pChkfHBeFEiWotLVP3Gs+DDDw0EiyySw6+yX+s9GM6/RlosHPL6V
 TEbmXx74
 hig1Kyn81+FJfcXrQjPPMqRcvxREyRPhB+QwCIuylNKgDmfCL+X3/Hb1ynDwlDxRcFUWxNEclBA7hrInCJiGYAKL37WDHZ7SX/yCdF5JrH+UkNNJ6wheQZAY/WaWKTK+uNFLwmwhLCyAoDBMLzy69Ie5cRE2fScdO8jM+eyjzRVUPEKe4bEhqMq2YoBUWHbrsiHP+sJzoGa2GiR1WOmmE0sCSwFKvbdVWO1MZkjexBRDRhuU3KIvdbkpKNj5S23fHPEfGWvoaarvrP6XLojknIONpKoGI4u26pC13a8YA1w0dNvfKLAte/7KgMsTxz8ZU69275ethrTUVqofCRuA+YEuOxZuEmZbL+QNDshM6NRbEEeaAGaCuus8g1bPvhW3sui/n01wdd8DknYo4W/p0IVpIL7Q3bDSCAT3wOznizYBe0JjYouaowrPNNyC41dgzXfBB5zyWcLV9Lgx3u9CdtsUqoGkXgbOMhwoY5Ug8ClWNq+jzzotEBbugiaRpCkmT0GvFKBt8NSS55YfEgNlDLoee342h2nehgEXd26wmmern4JL8SmyfeTDeTFP68e30QZvcmOIqfQbKiVxnRGgVtTqwHFFaidA2ydOC2a1Nb1aCw/WE6GeBXcFvbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 12:21, Salvatore Dipietro wrote:
> Backport of 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and
> compaction for costly __GFP_NORETRY allocations") to 6.12.y. It fixes a
> regression from 5d8edfb900d5 ("iomap: Copy larger chunks from userspace",
> v6.6), which slows buffered writes under memory fragmentation.
> Andrew and Vlastimil agreed it should go to stable [1].
> 
> The series applies on top of Sasha's backport of 6ee3d87b9408 ("mm:
> page_alloc: do not give all non-blocking requests reserve access") [2].
> Patch 1 is the other prerequisite, fe21f930d1e6, only moved from
> mm/page_alloc.h to mm/internal.h. Patch 2 is adjusted for this tree, see
> its changelog. Acks from Vlastimil and Johannes on these adjustments
> would be appreciated.
> 
> Patch 2 keeps the mainline behaviour, including the THP defrag=always
> case raised in the Sashiko review of v1 [3].
> 
> Built, booted and tested with pgbench simple-update (PostgreSQL 18.6,
> 1024 clients, 96 threads, 1200s) on m8g.24xlarge (96 vCPU arm64),
> 12x io2 RAID0 XFS, mean of 3 runs:
> 
>   v6.12.117              87,565 TPS
>   v6.12.117 + series    144,458 TPS  (+65.0%)
> 
> Changes in v2:
> - Dropped 6ee3d87b9408, now queued from Sasha's backport [2].
> - Added my Signed-off-by to both patches.
> 
> v1: https://lore.kernel.org/all/20261113110611.2915381-1-dipiets@amazon.it/
> 
> [1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/
> [2] https://lore.kernel.org/all/20261112171856.3309378-1-sashal@kernel.org/
> [3] https://lore.kernel.org/all/sashiko-outbox-214389@kernel.org/
> 
> Johannes Weiner (1):
>   mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
> 
> Salvatore Dipietro (1):
>   mm/page_alloc: avoid direct reclaim and compaction for costly
>     __GFP_NORETRY allocations
> 
>  mm/internal.h   | 11 +++++------
>  mm/page_alloc.c | 12 +++++++++++-
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


