Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF85C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905F16B00B8; Mon, 13 Jul 2026 12:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD176B00B9; Mon, 13 Jul 2026 12:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F39A6B00BA; Mon, 13 Jul 2026 12:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53B896B00B8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:16:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AECE8B48E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:46:36 +0000 (UTC)
X-FDA: 84983878392.19.BD3D121
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2485D1C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:46:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWU2dUHD;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783950394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gi6by9W+BjPxJGcAVM4qqNGrl90WcOjeaplWb2jNiTU=;
	b=lBvC8K30lO6rXds1IF0FNle9f1lGD0vQCJBO3T0WL8UiLDWWLFPj+tx1YmbWfg9F6fGY6F
	5GJzE/pij+fpn/h0cXecO9ZusDfODp6dickx83lv9MdO8ua3O80iSoxumPQ403nLaEMiCk
	f51YjLHZ7Vqcfjdy1LjO6G6kU+8IRpY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWU2dUHD;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783950394;
	b=hyzk7zJXUY1ZXU5A+g9NsWoXLAnNtleLz1tcbBWdW+1nWsuQnZ+VthU7gSI+NwAY3ZET+l
	xRCmoqZnFEIXxUlWEJ13bO5Ufxo2A2dWCdgRYA67WFvb7ugpxXgh14ctUiWl/4NoheOeem
	FX7GhNZIcMi/HwurOgxGwfM3gFg/beY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 232CC40F85;
	Mon, 13 Jul 2026 13:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26AE1F00A3A;
	Mon, 13 Jul 2026 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783950393;
	bh=Gi6by9W+BjPxJGcAVM4qqNGrl90WcOjeaplWb2jNiTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nWU2dUHDFQhtPiZcUpj4K3kON8LNMpuUuYf3GuPCLmsacqNTh7DugEoMASdOiPiCc
	 kdKeodHz6LIf1Nrqnb612Lp0FaQ5Ljhm+Dv3A51cpHz9Md0HfaYPedbTGWMP6bcV3+
	 FEFawoH2hC8LuS34i0Ejqw+gtjtozKaBv14C7rg2KijUp00Bih50f2Oo4bs029hbkt
	 s1qmwYKFutquVqz1ytbvChfYhzmg7WOw7alYseS6HU8IzelNIldBuKhTgQuaySnWav
	 0zeLjTTdIcvq75cushlAYOR/t8tcV8Q8mpoXGvCRtbHqHX586HNX7aiPUZJDdrq8OY
	 sL3AU6JQjp8HA==
Message-ID: <0e178f49-dcd9-41fe-9a03-7d8214bf8548@kernel.org>
Date: Mon, 13 Jul 2026 15:46:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
Content-Language: en-US
To: Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-2-affb5fe5ed00@google.com>
 <0048210a-e186-49c7-9897-32c9b66336c6@kernel.org>
 <DJUYCPR6Z66E.LC3RMX9CEX29@nvidia.com> <DJXHAPFS6JMW.13QLTQP4D5YZT@linux.dev>
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
In-Reply-To: <DJXHAPFS6JMW.13QLTQP4D5YZT@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2485D1C0002
X-Stat-Signature: 5apx35qp1tfq7bopogx7bawfixkq55pa
X-HE-Tag: 1783950394-567082
X-HE-Meta: U2FsdGVkX19hUON71S06WaNytRHfseNgPrn1BwT8mmc3DzLA9/e0I4h+I3sJ9dzyikCV2XIMg7S6DLZUBne4nvLaelG3AdkzbODCwlM1ARWYI9ygOaRk29e8ajN+jzj/VKkiCam9DFkso4fwiHhvtgtMY0bUqHouyiVYVslRAEw+TCWBNMcCJin/zyCeXZG3LXiwQoE/fWtB0SQPf9Pr7BcL60GEovWzVrYspDwHUUMCrIPOpIexWsDV0jS30QPXU+e9Crpx3uskXPF3fE4fj1xlE6Xei/I+kHGJnw2UzhTbSzQKWUNVYuTuVm5uxi0B5GJABGhpfU3SX+pAVICLf2uaD+bOALU78drk9HwQLTJxLTPJTFEHMX/PFhCdfRtZb0jJ6ZlyYmJ5md5uVTEqj6xIqWjSPc7XUrMqvY4WiGBci/XFLNWuQSNUE7+mw7uq1kkrwyU+KpqbPJwzbPAcvlBzwpvus1dkwZevnSNyRwwuqfvPGZHG6MxZ/GAvo5AnDHiqhli+tybFqaKpOSmaMAMqlFuC2HoXAig08F9231yNfJrkYbHpsP2yvpWWbwLl425rf4GU0Ya3e7mfTm6D7bC1p0cSoOtCymIBNbPShs/N6xoxSq9cx9EL84P9vjoF6rvZJbVSIUFV004/gzSruUWrL3AGysgEpKfSTWqFbwVJ2B75VAPoqbKdUOO931aQEGdHBntDzpRGQDa0WAtJh+dpD5ZUnvmPXtA4wOqXCHn0Zym7BkIQZk5SvBMB61t7HvSj9HOnEhOA55r9EQeOugnS3NdflFjnVwvd32Bv/p7Qjiiudn9VrBmcdKqUSrWmvCVXPox3dlYJ31Fv0bRSxC7wgQc8jQw3odVV3UP4MZCZNSIWM6JrpYL/DdOxgxiONLJDBamXz9YTyyGDrC3mD6LxGdktC5zEW3ebnVjCAAT5SqLwyUTJA8M39Z9nHcJ7ivgmaK6LHg7rPSQFIgL
 U8L718+u
 jEIxI7NqH+oA+eH10S4LJqv2BQEZ+dFiZjc4JvU84XoaQE4GYETEywqePJzg2UFZb8lebEI06Ctg/w7Aih7cj9ktzZwacYpQU223Jao7arc6HQLHWL54Zeprwp8BIcaGRm09xUgp0zlEF1EYB9+TGhJOPASGEZFaWhJ1+hrhsxXX7bYbn0+zBZs0Ll+JTRa7E8rtGNy1R426AQ/+/3Tm8x7TGAFSGhTI8ONG5JBo6Fk2i5Wkx6Ee+22/8IAND2gdsi9mkPzNIwynL4aqJ3rN1aDlnMcAlbaWTvb9Hj9nAELBbqXGV9ABaeOnOm37gJ9iNXe0TIY/uLlg3UdE4HXo4fyiBxjFrSQB5L16lpPlvUxA2M8gssx2J8/mC/XmOLMb381Iu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 15:30, Brendan Jackman wrote:
> On Fri Jul 10, 2026 at 2:14 PM UTC, Zi Yan wrote:
>> On Fri Jul 10, 2026 at 8:40 AM EDT, Vlastimil Babka (SUSE) wrote:
>>> On 7/10/26 12:42, Brendan Jackman wrote:
>>>> As discussed in the linked patch, the there is some inconsistency between
>>>> "trylock" and "nolock" nomenclature, let's align it. Since "nolock" is
>>>> used in the public API it seems to have more mindshare so do that.
>>>> 
>>>> The linked patch did this for the ALLOC_ flag but forgot about FPI_.
>>>> 
>>>> Link: https://lore.kernel.org/all/20260703-alloc-trylock-v5-1-c87b714e19d3@google.com/
>>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>>
>>> Naming things is hard. Maybe it should have all been called "nospin". I
>>> don't know anymore :)
>>> _nolock() functions and ALLOC_NOLOCK are part of API, FPI_ is internal so
>>> it's not that urgent. Furthermore:
>>
>> I had a similar concern when reading ALLOC_TRYLOCK -> ALLOC_NOLOCK[1],
>> since the name is _NOLOCK, but the comment says spin_trylock.
> 
> Yeah I do actually think "nolock" is a bad name here, it takes a lock.
> But I never cared very much about the _bad_ ame. On the other hand
> _inconsistent_ naming is a concrete problem IMO.
> 
>> I agree that "nospin" is better and less confusing. But whether we want
>> to churn it again, TBD. :)
>>
>> [1] https://lore.kernel.org/all/DJOZN5H048UX.1ZVSFD48QZN05@nvidia.com/
> 
> Yeah I also dunno what's best here. I guess this is a decision for Vlastimil?

Let's keep the FPI_NOLOCK rename then, but separately from the fix.

> 
> IMO can_spin_trylock() is matched with spin_trlock() while FPI_NOLOCK is
> matched with ALLOC_NOLOCK which is matched with alloc_pages_nolock().
> 
> If you like, we could just drop the ALLOC_ and FPI_ renames and just

ALLOC_NOLOCK is better to me than ALLOC_TRYLOCK.

> rename alloc_pages_nolock(). I steered away from that because "the
> latter is public API", but... it's not like it would be a huge treewide
> patch, it only has one user.


