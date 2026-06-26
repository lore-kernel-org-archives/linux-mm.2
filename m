Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2BA1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D9A6B00C0; Fri, 26 Jun 2026 11:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5556B00C2; Fri, 26 Jun 2026 11:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BDB6B00C3; Fri, 26 Jun 2026 11:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69D616B00C0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:10:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F17BD8DA70
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:10:52 +0000 (UTC)
X-FDA: 84922401144.19.45F748B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 434D91C0012
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:10:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fn6BvH9P;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782486651;
	b=HyDMeoLFePqGkiqE+fvavvkh2VYUWZEfOINtuwDKPDTt5+QPNtv6z8RcLw9g8Y+MrwzRRk
	hjfQiXAv1J2tR3Rkz6IG4u8zSMtNU5Wa9b4nt1i/9XgKkjYiqbBZ97dvb9sduDyhFB6lWw
	IvL2e0vsUHrhuaraqF5AP+GhzJd/eMc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782486651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtWnpf7hj8I8WT1UaADbK6tvBqc/0QhWuwqC36DIcsU=;
	b=BH3t1g4pZr0179wGOy2uYzeij+iklF8foPVghMDT9szpk2ryb4WCt36DCNJ/AbahV8W+YT
	cZwvEyJtvn2WnOPttkej6APJCBkOnrXWRZSDiZ5Rvh1ChJgSTkFUYx2j6FREGV3fui/rZ3
	bnPF6v0jeELbVSHCAZJXXno0fLxS+G8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fn6BvH9P;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0B65600C8;
	Fri, 26 Jun 2026 15:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2F01F000E9;
	Fri, 26 Jun 2026 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782486650;
	bh=TtWnpf7hj8I8WT1UaADbK6tvBqc/0QhWuwqC36DIcsU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fn6BvH9PC56Fkep2ZfxrCOrOSsSoS/9jX03WT3tDFdAyYq3G6BaQACmCVJUqjgedd
	 oDclPR3vd8xsB4Rz0/eJADqJZhBYytRv1zZT7sc6I54pNX4M7m3kicgwiJ3Hk4seRC
	 TTMUOhgObGR5wB6ASOaFOeo4CWQOx7vpDcEz/8MHaPy7i2d7ehwH9l+g3VamxG0+6J
	 LNZjKPdU3gLEl2Tcc45FZDY3gsJVFYv3lMcMxJNETTHQaQOGbAt0mcaolOlOiN4fIj
	 IjNST7uCObRGwWNk/ZPSo0bh5Y6KBM9RFsUtuBcj+BlOzy6q0krysGxq7Vjv88k/s0
	 Cfln0S4M9dNTw==
Message-ID: <1816e94b-87e0-4276-8ff7-1fb651326ab3@kernel.org>
Date: Fri, 26 Jun 2026 17:10:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <be9556d1-7eba-4472-a932-bf56db6285e1@kernel.org>
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
In-Reply-To: <be9556d1-7eba-4472-a932-bf56db6285e1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7nzb1gejokfb7cai4bfgyt5xbkyqzsnp
X-Rspamd-Queue-Id: 434D91C0012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782486651-118080
X-HE-Meta: U2FsdGVkX18UNE+NJwXu1O9CGWdGfS47qZPS8X0KCjbAyo0VC9iCaGY9xP4kHIAugXz8qmXwulNmS6bqp1UH2qQ+5j9Te5t9F4i/As2tch96byNF2sznMY2ep1B1hlpNlKRZaimxjCAV80D+hSui0B/EN9qHbNabeOGSrf89w6D4KL3C4ig/GwDiJdv18xfpLzeNAR7tTb75GxP0JBpdXRRLO/WCBNzJcSixBV4lY2f52KDXehRAPS62dF7CFN8g8Gxa3ujq7bpM+QC3NuRcQP+gL8FjAzFo2ZmlpO3GB0/El7ZqqgA+/aK8PLBKjgRUKbTGSDITb7zKaJbxR71HM+vha2h7/sfzkj/8upbcctth5aZ3F4dHpGR8H/f7OQIXq7i/f02I7/TLk6pb1qJ4soqzLLhtEEQqCzHOIC1spyLN7c1wbViYDG9HOjVXu+9wCxq3I+/266Vyyd2vGh9hz1reHvq9E6z5aWNmQP64Ot+7eiC7hIyKBFuTpZ+R/VpI7aBtuvZDlVwgAxoAQW3HyOuUFmZiBWnL+OrxmLFJH8XG7/54KPIXggWq8DsMsi7BI0h9YJxvwKrtakUs1ENprx/7+Vp+iZzvlRnCdxdA3br+bqdfdIdu10WFbjjxEF7J4LDRF10sMP3VoRAD7GT/Oc95d936KNC7JFnRtDxEwLw/MLOMQ09Q5lQWAY0foSpI242/NBEcRIXJCM3jDuUDNxeb4t31XE6gULLTMIxfRJx+7v0LQ0laitQxBjKiSvI60xL6NpBbyz9cDSvMG7L12wFq5aoeMN9Dyl/e8ETJ24FAdEhoGUfyoCoqYitq+4AwqiOyvLm4ZTLYN1QnDU7kjP0kTAEvGqIt9y8VDHb7re80pC+y/4c7bR3znJoFy+AVmJHC9mL58harLOs1m5NZowYYHqBT8D80hEQOVUCN2L7oqBUaE2w0uPidkqnBf72MBptn/O5C9SouZsrnLGW
 6Ge4zVuQ
 30nrkLDG+6NVP60rck8Hw0kdV/yknD/tSt7/sPi2OvWGm4mP/fUdL0pK9pjtt3QGzguGU9wJX087qpb755yn/bHYywxRmGyI3BzPEkefbHMW75RYAknfZSuz4yehxWTTHTzPumT0KiVwDjah5e9eVLskFhEZxoEtg1YquGjI/jFSPq4TBju1eG2evpfEFOUzRdhCopvVw+2n13Hwa7HQviYIvOvZg/wF5C+LzgdQM57iAeC8wXmsGxT2g+NFQ1wwKsXR1UAOBi13gSdCs3hhG6TfmUcm3t0m3+CVhY4CAmZIINZM9Ua6CB+IOnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 08:04, Harry Yoo wrote:
> 
> 
> On 6/24/26 10:11 PM, Harry Yoo (Oracle) wrote:
>> Apologies for posting another series during the merge window.
>> But these are bug fixes and there are other features that need to be
>> rebased on top, so...
> 
> Okay, given that this needs a bit of discussion with the memcg folks and
> this has been there for a year and nobody noticed, I'd suggest we be bit
> less hurried and not delay other new features going on because of this.

Seems so, it would be hard to backport anyway.

> But I still think they should eventually be fixed.

Ack.



