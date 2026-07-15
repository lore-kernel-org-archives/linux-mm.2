Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7352C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554F76B00C6; Wed, 15 Jul 2026 09:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506526B00C7; Wed, 15 Jul 2026 09:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B416B00C8; Wed, 15 Jul 2026 09:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06B3C6B00C6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:32:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40DC31A0197
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:16:37 +0000 (UTC)
X-FDA: 84991060434.02.2F7F705
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5D2B8C000E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:16:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ok3JXN6g;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/blMt7c0/x/SOLABbbNCJG/CCPLnSKvmx9YqzzFQVA=;
	b=mgPloh+5eWTRepMR91eKoabTMJ6/LzuOJNVDqJDJx/yYZ8xjQ8x7q1g2R1BpN4IupWwFyO
	8NPqdDrUzxq7FVuMPa53zDTTDz/rouOgsZ5O0vCQP++SOeBqaxWSPurcZeneC3jOVxeWD3
	8FI7UEChTyHH98z7+bMdARUfp0WyQrY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ok3JXN6g;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121395;
	b=yUvSwIWQ22VxHJhl5dWmKpRM+KTGsm5PZv61WzR1NTKjlgvu4BKgXEtWJufslvQU1JPlZm
	Cdj0gNiulitxeiZHsQBiPkc1+/MnJVnJozQ8iGKxlfdmSKrxsidGIPwfK8IUv7q2tcRikQ
	INVQu/6aCK6Wo2BxdZEBOlORFehc2XM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB7F06001A;
	Wed, 15 Jul 2026 13:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5106F1F000E9;
	Wed, 15 Jul 2026 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784121394;
	bh=L/blMt7c0/x/SOLABbbNCJG/CCPLnSKvmx9YqzzFQVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ok3JXN6gpujiV3WYE7zP0r0lt52trOjQDdcE9kNKvTHziuUZHP3P4fzdSoFmnaqQS
	 jOkSXWvZPIfENSuklm7MShw6mNUQEosX9cteCzZKvFlab6DjYc27FmT16HaVRcN3e6
	 wHrPVvSQNCVRKXbzh7NMwRN++gjPwOKO6MAYrTCqX4rdLA6l3cVycxT3rz4RizFbbM
	 RKxa0OFzfReAQ7iRnxMCkjz5JR3QYN+cShFG0hjbYv38Hk/NG6lMMijhaWC09xwgDz
	 Yf4iZ3zlV7bW8eEYbUpy3ye+L1QxYG86m6QfismhI/EWkC9MoZ0rT/ysFdQ5Osu0I6
	 DRMUAcWKev7Vw==
Message-ID: <ad397b95-bb3b-4f8f-b1e0-cbe204530721@kernel.org>
Date: Wed, 15 Jul 2026 15:16:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the page
 allocator
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
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
In-Reply-To: <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D2B8C000E
X-Stat-Signature: an467npzs4zqmzruy4bt7u6agjd38czk
X-HE-Tag: 1784121395-634967
X-HE-Meta: U2FsdGVkX1+0mtXQND3+1YUDafakOZuxNJjRXh5AoPClByKQg9a8JZqsGkyfkv1gCPNj0lLCFbTzlPr9boJbEm1xa51zUk2nIDhX7Cbt9h7FuSeGZK3vuBjrK6Hqq8dE5ZxPb0a05V/4RWhYBNGz2uamaugilaGu7MPH9U+86jMQm2Xcf29z7df7Heowa9kJG3sAMFq1rfOx5HXaKGLzQ7Vzi404FH561Cxhy+47/Kh9+rTFh9wtzs6r8qz8thhSFoy4piqeDb56v3Q2caI47J95qit7ZhaguOKoV/94MUmnx+U8Gtco2YXgfIW7k1To907DjY3EoaSucDdJDE4L5qtXfXSYQvwVVOYwZjeiUGOJ+Jl+Zcuk0Yr9NEg4mq4kWTDEOlWVg6Z8LLU6ulwPo5rVAmCP3ajSsdwCfcNOxsX4BjVfxq0axvxL0RBQzYbRll3krDOh3LXYG7aawht6aTBqvO41WllMTDHTci5sNcUDSG4DQ2FtYEV59ZFkUth1tYf3uR73yMq6SLtssuQAbq9goghflK2bTMBddXhfyksNfwSD8Cn6hzo+6brvNBiaJDi61Ev+3v0RnPopBcud85DblT4yNaL1WhjjMmqpZEzkSsDBV/qaToJrjJomyDvZWsFOrCD81nFsHVTPZZTygu7EqSEr3m7G8EUO63AAHxMPEmX5VRBBoaxQBUgOir36hfnItRcXyse13wjRyz99tO3sMKGY/3S3iQKaBy791Dx69dxOl6OTADYyGtQCAObq/ZVvUTcCoblJP2ItEoGyP95UIPo+bCT3rfKLKhLk7oZoODe3ckzzMflWT1X0RxUlwPxQg4aVOPtIszAUv9oSw7CnUYT3HrdXPw2qcErRwdW6GUFD+oyJcgabqKJsoNhlFyn26KCQBrgh2ZEj1uCCGaf6ZV8aVbDDFgRTs41AJbxFi66UTqxywhJ7tM8YYWPs8zuG/cN3eZL9uPiBVB5
 1gMFfELA
 +UAWa3yfl9Twg8asRmV6jnJzGBtZd8SnvLcLsKivhpXz3YisfNu8B0/f6p851TsiQU+8Q2McNGu0cv0XeaMCtFsSbXkvvCUdM0oqg1ukoC6S9bW6fwofOHBDTCWUr3j5+PgUxDoqWeGdDUHWn3Uah2bs42IOAhLAXfq57JOcOEDLlKPKN9oyT4BHuxjHDpTuFDe8zVsPhGO54fFPsGXblDj0yo/MS1iSHVtEzlKoga7442aW5kH/JjlE86rdqwq95XA4u++ltXZOFpRyjNn/MrNHe15++Mc/i8Nk0uwd325HoixAGKp2P1paJJY9MpmyNqmzGn421+yRxuAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 13:03, Brendan Jackman wrote:
> These comments describing the page allocator are out of date:
> 
> - __alloc_pages() is no longer a public API and has no business being
>   described outside of mm/.
> 
> - The `wait` variable is gone.
> 
> It may be out of date for other reasons too but this patch is just
> fixing the issues that stood out.
> 
> To fix it:
> 
> - Instead of referring to a specific function, instead to "the page
>   allocator"
> 
> - Completely drop out-of-date details of that function's internal
>   behaviour, since they were irrelevant anyway.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Link: https://lore.kernel.org/all/DJP11T5V7BDW.2FZZZ8R6LOY4I@nvidia.com/
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  kernel/cgroup/cpuset.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 24ea2d09cdbdb..dfd0f827e3b92 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4193,7 +4193,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
>   * nearest enclosing hardwalled ancestor cpuset.
>   *
>   * Scanning up parent cpusets requires callback_lock.  The
> - * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
> + * page allocator only calls here with __GFP_HARDWALL bit
>   * _not_ set if it's a GFP_KERNEL allocation, and all nodes in the
>   * current tasks mems_allowed came up empty on the first pass over
>   * the zonelist.  So only GFP_KERNEL allocations, if all nodes in the
> @@ -4206,11 +4206,8 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
>   * come before the __GFP_HARDWALL check, otherwise a dying task
>   * would be blocked on the fast path.
>   *
> - * The second pass through get_page_from_freelist() doesn't even call
> - * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
> - * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
> - * in alloc_flags.  That logic and the checks below have the combined
> - * affect that:
> + * The second pass through get_page_from_freelist() doesn't even call here for
> + * GFP_ATOMIC calls.  That, and the checks below have the combined affect that:
>   *	in_interrupt - any node ok (current task context irrelevant)
>   *	GFP_ATOMIC   - any node ok
>   *	tsk_is_oom_victim   - any node ok
> @@ -4327,8 +4324,8 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
>   * should not be possible for the following code to return an
>   * offline node.  But if it did, that would be ok, as this routine
>   * is not returning the node where the allocation must be, only
> - * the node where the search should start.  The zonelist passed to
> - * __alloc_pages() will include all nodes.  If the slab allocator
> + * the node where the search should start.  The zonelist used by
> + * the allocator will include all nodes.  If the slab allocator
>   * is passed an offline node, it will fall back to the local node.
>   * See kmem_cache_alloc_node().
>   */
> 


