Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26376C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFA76B0092; Fri,  7 Aug 2026 11:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E902B6B0095; Fri,  7 Aug 2026 11:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57AD6B0096; Fri,  7 Aug 2026 11:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A15A06B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:39:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20CEF12040D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:39:08 +0000 (UTC)
X-FDA: 85074881976.08.DB01834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 640C940010
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:39:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyVWYnmZ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786117146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAheNQzZrUL8VkT48h9rxz80c6O8mgo9DdVWeFvBsyc=;
	b=8jgWQ05RlOm8cTiXoBZirnckxI8OzqpHW7pul1dY9uanC1ti/11PMjxbgHnA1rG1NoY+ED
	82DweUlG+fO6kvIk70G599wSLLTcGNl5sY3SNREW1D5z47fb4HmTxYqFFHZxG3/DObxG58
	G6CpoANDxLzPTOYfCnCEh1LuK0vxXVA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyVWYnmZ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786117146;
	b=uRvpSVrZXyTVh4Io+rC3mf4KjNyPPrRqSKnAKPpdMioSiOikqUcf+5W16oianoUFBLfdX0
	iX/P6QRg1dHNkcSb9rcne/K7YK0G5TUCElLA6g3mEH4Tu6GIHGwxTMwJjRJYGaGK81B2/e
	6jXFUrnj4fzuOxTHmNQc4qttrh9I0Sw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E145F600B0;
	Fri,  7 Aug 2026 15:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36AB1F000E9;
	Fri,  7 Aug 2026 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786117145;
	bh=NAheNQzZrUL8VkT48h9rxz80c6O8mgo9DdVWeFvBsyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eyVWYnmZHpLCJKZPvOBM6jCVsS4y+LNltnyxjOuPsCFwzFoD3nuyLapTIz7+L9xXv
	 +OO6+9pa6W/m2cXcIFi5O0tKeNXdPr5xZzL6hxYqldJJUNU1Pmjw5Aa3hO7WMFg8aw
	 +/pOcQI8jgDpGTPX/H1MmebbqtpmHDcfIRTEpn9GB6Fc+msemNn7ZE6qHrBQt7PqOK
	 pVA1kfntwF0hMRHyCHUsZnLvjQukofINMLYWhlYxhDfXr1FOz9Y5NX6ZWiXZ9JQcEB
	 bnLLUJv9lJHMghYTbw+ZD9a4khlY7sCMG4cZ1jTOwlly6ktEKz8L60Meg7koDpKXTi
	 U2DwLovoY7j4Q==
Message-ID: <de2bacba-c3d6-496b-86cb-0c0a98163a8d@kernel.org>
Date: Fri, 7 Aug 2026 17:39:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits for
 writers
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org,
 david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev,
 jannh@google.com, aliceryhl@google.com, arve@android.com,
 cmllamas@google.com, christian@brauner.io, tkjos@android.com,
 dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-4-surenb@google.com>
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
In-Reply-To: <20260806200548.3124802-4-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 640C940010
X-Stat-Signature: 3qqxzzytys98hipypde6o54ac3xnnrq3
X-HE-Tag: 1786117146-248442
X-HE-Meta: U2FsdGVkX1/h4noMYlj2XLfnas42SpGt6QDOxrQs28jDAhW2B46cqBCsJXu5MpHCvp5C54x9wG0s5UrL/zGNawGP3uhZlbwzjA/bplapNRM4TN4QfypnwQ4SuQ7lX7tCr+prHRFCSX40j1SSjHLSkw/6GqCN74/Uvl//zcGn2EtVqd4dcnuzhpOztFiTazoB4ZhXp8HIyrtH2eNOA+3A0+igBnJHiZDYo6H0a0ZWwZdAcAqnN9Xn+mEch7hTcwenjZJGXuUXUSQgtccFWcSqmQtIAYHAVjVQtDp8CYoyuus2NiHhuEC4GveINP5bUQmQx4QaHrknnbkHs0O5ucCxRCtZQHYgVvK4TcWRrpHR3lfjlbpDqa5w9BD7C75sGWNhV/B7SkBQkEQCZNdrkAxq/KBmsgMaFufOVXoghOijS+kothQsN4eTs9p3IA2AzuK37ngBuItxIdfJHQ3lzhtomgM71QbckEBgCsGb0uO5C1aDjYJP8hdI1VxSuFswvpxus9giF6iECdSrxvG4a9EryqGcWaMnVdlzxAHxjaV+YU9MZELnW99Aq9kaZyY49dDuZJNaQ/MxontDWURiZM0a1zklgd3DDOWlOJLfU8OLIm16fEk7jW4ezSsOLZIJsCOkMyOkb8XYUIGoqDJj8GJkk8aqCCpNJ4XSwTKdvo7wweRKDNrPB1BQGgxuJpomnPDWjk66Z4XTlphoAL8BPue9h9ooOIyoaTvOl9NZLkpNey4Inq92eY7ja0eqh7s05D2Zv4KMc1agQLNcuJaBdt2jedczue4GDRwbAcAcE35mpWANxM8f+P21YKZEqOsnzLI49tc6bAGfu34x+cIB0g+nw5yYn0Z1dsuy+JA8soGgJiEtpmpsX7bq2guGcQbIJiva0VOsmKz6eTudRRK3Ja6jOgTQ371w8WuRKQV2fGQYaO0GNax+bH3kImE7TkljTTFavhVLC0oRo3c2arWFUob
 sGJvosTi
 vXpQG5R4JHERWlpZzOgKAacTPKqATS7Gd0utlyIK2lxgzJi1gV6IfyFF0SrRjEJ9nSmEkgNPvxgpHLrUXvuzQZXQTXsFL4lPc3Kgk1/lNYW0v2ODPU1P7lR7YoE/lu1aD25uDOqXyt4iZ8TKvjbZ+xOQ6/GlkpcYib/XcVAN/MsZITDVh5jiipGpHVMvZszxjPbjiDeurOONwXpFyufwmt0SrJe6Q6VHUYfNA9mSsS8EAE1mTw7RI4e4yYnHg1vNr2sYwhvEB4cH5iGBrBubJeK91ScDeI9Z1ibxRHYtUUORLFKgXuolW2x/GB0MB0Cn0S90x1nVYuBJxh6iOjGwKbmch+vP1zz4RfWqvWZ+bxVcBGZPCG1krxAAo+P1ePd/5OmaWMB1GQLRLHx9NsiaG13HjSxowkXZ/HfHHnJWdplZpEXA4d3WpL0QpOCz9CbTZJJVQMTGsdE8NbkPCxOV2IZgRXFQyiMtxuVgTekPipAGUhBHypCqvyGadlQqjo8xqbvip7ulVVc1wchmBnTqfRx4dpK5+wfRcNIoyNnAEumrRY50AjKmpb/HyUrf+HhBZB+yUkB3zCCy92WigOiSAqAzsbUyKYp8Nse4Dz3ZszU6gLu6vBfTqgLsWwhZFrZT6bsHov69FTkK934k+MgHXz+g5gAebyQeli3rhO6/xV26YLOOTBxI/GYKzfRNCF1KIOIiKSh0Yql/mo4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 22:05, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> == Background ==
> 
> There are basically two parallel ways to look up a VMA: the
> traditional way, which is protected by mmap_read_lock, and the RCU-based
> per-VMA lock way which is based on RCU and refcounts.
> 
> == Problem ==
> 
> The mmap_lock one is more straightforward to use but it has a big
> disadvantage in that it can not be mixed with page faults since those
> can take mmap_lock for read, which can deadlock when mixed with nested
> page faults and parallel writers.
> For example:
> 
> 	mmap_read_lock(mm);
> 	// Another thread does mmap_write_lock().
> 	// New mmap_lock readers are blocked.
> 	vma = vma_lookup(mm, address);
> 	// This deadlocks on mmap_read_lock() if it faults:
> 	copy_from_user(address);
> 	mmap_read_unlock(mm);
> 
> The per-VMA lock can be mixed with faults, but they can fail and need to
> be able to fall back to the traditional way.
> 
> == Solution ==
> 
> Add vma_start_read_unlocked() - a variant of the RCU-based lookup that
> waits for writers. This is basically the same as the existing RCU-based
> lookup, but on a failure to lock it temporarily takes mmap_lock for read
> and waits for writers to finish before locking the VMA, dropping the
> mmap_lock and returning the locked VMA. This has some advantages:
> 
>  1. Callers do not need to have a fallback path for when they
>     collide with writers.
>  2. It can be used in contexts where page faults can happen because
>     it can take the mmap_lock for read but never *holds* it.
>  3. Its fast path does not require taking mmap_lock for read.
> 
> Basically, when applied correctly, this approach results in faster
> *and* simpler code.
> 
> While at it, fix the comments for vma_start_read_locked(),
> vma_start_read_locked_nested(), and uffd_lock_vma().
> 
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


