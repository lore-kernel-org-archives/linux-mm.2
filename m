Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83B8C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2D6A6B00E9; Thu, 23 Jul 2026 04:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB71B6B00EA; Thu, 23 Jul 2026 04:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A80C6B00EB; Thu, 23 Jul 2026 04:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6775B6B00E9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:59:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E425614014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:59:15 +0000 (UTC)
X-FDA: 85019442270.20.A27E397
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2FF6220005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:59:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784797154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHE5UyZOJcyUR8Q6h9uYcY3GT9DHQw0RTgTmhzj+Oww=;
	b=LdO5gePU7DfeGreXiJ7ah3RfLUM6Fwx09KB4Qe3W+Hhm0uhiHqOInuYEtRidaDUBH9kgRK
	bFOPip1sCAJx/GNkCyaeEtua0meKPgkgjLPZuZ08K0CU5rZy5RaneL5ejSFqyWfM7fYZBF
	DYLjqzJ9E6KZQzn0WjQPpZZp10+u5r8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784797154;
	b=0yufawtHS+2OKfmSQqv1ijqek4qT5BIwx3RJvovInIbcuJtM+3fBVo8rVMoxavp4tgCBDA
	jzPXUqyzEjVPGJfpcO5r/1WrTJNlH4pfvvi4gtpuOKf/0/NuZQByMg98Q5uELRbT39bn40
	1nm6T6VALdh6pdqbYJPUSShHGRlOGVM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FC024373F;
	Thu, 23 Jul 2026 08:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950951F000E9;
	Thu, 23 Jul 2026 08:59:10 +0000 (UTC)
Message-ID: <d5eed495-1544-4783-813d-e879004603cb@kernel.org>
Date: Thu, 23 Jul 2026 10:59:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] tools/mm/page_owner_sort: fix --sort, add module
 filter, improve usage
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260722023726.600200-1-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
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
In-Reply-To: <20260722023726.600200-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2FF6220005
X-Stat-Signature: ri1hg3t7gd7acux5s6o18afzfmf8jjt5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784797154-45902
X-HE-Meta: U2FsdGVkX1+J1TrpgG3Z6TMsnK5LFzuWiRh4kHrEaGWgBBKL5DdS6qUJejlstfuJ93a1T9J7cdO8/u1ALqg/YWOrcR445PhDnn3sLjBfxkNivULJQAVgFZrk+Z0yGJL2G0EJ0PnoMSAJPRmLY319ePHDftwyi3Syv69o4Y1hpJkwX6z1zyhp7aQyYS2v8TGgrOZEannkpFEry6+EUDYrSDekpYTzEfGJ+LUwK81IXk8Ru+TR3vp4f6+NG+iOGUj8b3D0fIhJsMNrorhoeKz9YrgpV24tg9kSOjNfOM9zxR/ftJLzHUVCYq6UhFN7IFi3/tmH4NWHMWDIjkOJ4m9JlynMgEvoBINM1vWRcheV9N6lnT0Nrs4VPAmNhajqShC3ltSGDnO0gj53V8tN4BmVWFQdJv36ZEDZkq2EfvlUVNBkc4yMx1QwzlpQ6DWg0305rbHM+bELY+4eaTXDcddV2wWVyU8LwOmfPLm3R8eMzsHk/djlLmqIinzLz3hLVs2YG59qRD0VcXwB4DsLbQjcJtkk4nyy5yIJczOsOWWBuPjkjYaIkc+Gk+6y87GpiQ394/sLc5MPw1gS2Jtu7eKFFjHUI1nJM8pQ45BFadH5VjrN5Ns15sPAAzIdGC1o+O1PLOH16v/sV6fr5rQLxAlUx1DIC4EdjdMdLT2YNUYFMI+1C/oWf/B6af+CPOKCv//ULl8QwKXpNqQdFRNmKoSDe63lbofN7uyGy/5m82GqmtHFs7Nl83x1xWPMUIpq/proRU8wWhxGPPDjxNv78gOErhXsDWEjm1TUUJFsu62pnrgwa+Vh4mH9erNk/A47TixSpitLNesxQ4+36ElgNuMkDKurDsOuDUea0z5vxLefCym+UuyqOqw0ZA8G/awflYI8Fteox/gEGfZFcPjL3ZuOiDS903c17vgdeU0aiUeoFwtAKkkNc5eewTZsoNTM01e8NmyjrEadGxhPw3ei1/i
 Oy3VCNv8
 rsXUJ1zrOEiXHGsN8rGj9dUaoIWJBdfIdwEq6SRGH0BCBnvJ6cz25sLTwpdL+fNQmvA8U5rWWOmQ7sh2G0Ff13HYFZbVJhUgBnu/+ZAk+4yvGqRfbdLTnsq8YdZw+ki3J5tIFTDajQIKcseee0Mdj4UeaPf9PrLjTMKxsAsr6KoPYemHZpzPwOl9q7BYUMBMVCNf23Wa+0sjDQJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 04:37, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> This series improves the page_owner_sort tool with a bug fix, a new
> module-name feature, and better usage text.

For some reason, patches 1 and 3 have very limited recipient list compared
to 0 and 2, please fix when sending a v2.

> Patch 1 fixes a long-standing bug where --sort was silently ignored
> when used without a short option (-a, -m, -p, etc.).  The COMP_NO_FLAG
> case fell through to COMP_NUM and overwrote the sort conditions
> configured by parse_sort_args().
> 
> Patch 2 adds kernel module name support for sort, cull, and filter
> operations.  Page owner stack traces already contain module names in
> the [module] format produced by %pS, but page_owner_sort had no way
> to use them.  Records without module frames are assigned "vmlinux".
> 
>   # Aggregate page usage per module
>   ./page_owner_sort input.txt output.txt --cull=mod
> 
>   # Filter to records from xfs module only
>   ./page_owner_sort input.txt output.txt --module xfs
> 
>   # Sort by module name, then by pid descending
>   ./page_owner_sort input.txt output.txt --sort=mod,-pid
> 
> Patch 3 lists all available sort keys with abbreviations and examples
> directly in the --sort help section so users no longer need to read
> the source to discover valid keys.
> 
> Ye Liu (3):
>   tools/mm/page_owner_sort: fix --sort option being silently ignored
>   tools/mm/page_owner_sort: add module name sort/cull/filter support
>   tools/mm/page_owner_sort: show available sort keys in usage text
> 
>  Documentation/mm/page_owner.rst |   8 +-
>  tools/mm/page_owner_sort.c      | 125 +++++++++++++++++++++++++++-----
>  2 files changed, 113 insertions(+), 20 deletions(-)
> 


