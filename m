Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98CB6CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C076B0005; Thu, 28 May 2026 03:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A445D6B0088; Thu, 28 May 2026 03:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A326B008A; Thu, 28 May 2026 03:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 804BE6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:26:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 386C7120242
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:26:19 +0000 (UTC)
X-FDA: 84815995278.01.A3BA8A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C5B52000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:26:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIRv59Ei;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779953177; a=rsa-sha256;
	cv=none;
	b=shNAVX1Uq7U/7OK6FOr3TZRvUOb+u6eJCQiaQuW9mlgB1xKQ9Mc2UypNzEhny0wUaypYm7
	CqULh+ZQP3qfKCaNWG5HXDsHf3FLKDvc708jFtXrPk/fmk2Ghfs3jX6y6rBfv0THXSY+78
	h/T+m0F9tW3/HknrdEZiKeJnmLuazgk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIRv59Ei;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779953177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpIXayEEnCYbKVNRKoSQmDaY/1iplluWjMjEmB3ZBdo=;
	b=vqOxCbhLWoybO+6rc3xBZ05ZqNggfuuL+u2BUuvjaX67KJwYwOwY1Y3YjGfrBvlixOq55p
	D+qWrrbzqIFbbcalaEqzmr8+JWyVdDrtwYVjhXnqSohdgkNkWRSQu9J7zySoW3LvSR/KnY
	lxEV3jlTUaew4hi7mjDth0grRlaU+kk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F49540763;
	Thu, 28 May 2026 07:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB211F000E9;
	Thu, 28 May 2026 07:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953176;
	bh=DpIXayEEnCYbKVNRKoSQmDaY/1iplluWjMjEmB3ZBdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZIRv59Ein6LfaRCNIS9eZRglbpA89knsGFBp+GnEIwosaFypVVQQ2WzLcHicB/sTi
	 7lTEJTsr+kD1WnsCHWl1Mph3kUW/GxpCleUcw4VHIbcV74BuE2otCZe2z0y76h+f8q
	 GIVppho07XsCNCplmnQCZKV+s3U/PD1La7ggSEtV1eoXAezWYUmebvdzZXBwTG929v
	 g5ActMPukCdQ20+IUuouPaz9xrjuk7nsy5leR7Dmnk848MjfXJCrQeJVyuBXKJPcGU
	 kudbwBIIqTBE8BCigNW79mOEPc9andUQjc3ikK2/+U/cO7TkZI6BQz05hhmaMLLQ9i
	 jlrxP5E0yOPVA==
Message-ID: <8d65937a-f2c1-498e-9272-d80ae6649285@kernel.org>
Date: Thu, 28 May 2026 09:26:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/slub: use empty sheaf helpers for oversized sheaves
Content-Language: en-US
To: hu.shengming@zte.com.cn
Cc: surenb@google.com, harry@kernel.org, akpm@linux-foundation.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260528143733563XhbDWw9ZGOiFU9KHd72Xu@zte.com.cn>
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
In-Reply-To: <20260528143733563XhbDWw9ZGOiFU9KHd72Xu@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C5B52000B
X-Stat-Signature: sz7tqi1qan78pe54pwupgo5fq8a5u1q8
X-HE-Tag: 1779953177-195393
X-HE-Meta: U2FsdGVkX1/+KxnVjOGI3ZeoOFYA/i7pc+Fhc6neuzb6MvF/uzHuuupqB14u6KZ0PB+khIba5r9feqPzU1XbXI1z0Ul+CSAvqyRxJLxHaZwl5NXlM/YjeNygaqT2Tn2VFhQX0w4ylLJQKow0mjOTwYZ/462nkMVEAfN+/4RnDrVpLsyJPIBhf5cYJKoT552bgiBAYjddPUeDH+KQ2mraxne5U/rAapj4v5+xuGjjek0NJOtjZaSPALYmIPgLGFf2LSCUz9FZVwKMusgjJu5aY9Ni9HmFHTDtgG7nxmvhKtEj8IJBeG8hVMoVK69npE7lQIiW6RXI+XPwdWmNEdRMz/t0A9sxrpdFD8ODadTIA6yNRKAgPzWkdgE9G4msuTiE7ADNPEBWjZhmylLOs5WfMuKvffYcr2PrNETUq2dG2Dl6feG03bucarizb0LmdQdROoUKpA11CQbWRJX/gYn/yyN3k/blK+Smj8PeA/gxUiFnFFC3BW6bh6rdSGkmlz1PcZ5EZr/Qko7Z9xty//NFSTtWko7lwXkuw3g1tzDyHQAC+yHwvjBwNMhXDjmYJDSjXQ+tfBRZforjfQzONGiI1m7hm4pm28uc5lFY2msH+Kiyw27ocW/zrvPfN8M68BpKVOxyInF9gjf7V5D38oAamm3iUnanPsTcQBYeXJhgco1L+5oWm7eRncauTXBt3u5RhYeCTi/pUJLJXqpDIodljjuK6b/Ta1x7/7JxP9vzl+jzwcl8DvILr/pct0KL7g0jgo89L2uqFKd0X4x9OJAGCopjOnfW8LJq91xlbWFWS6zb9Ljojpe2Pb8TEFmXo2QiNJkWn4eE4VaiHZA7a0Z6hhtpXkdZVpv3cH3w2Ev+mYqs1iNZwrp1lOjJkes4lqVCJ+FS16iQfPkm1U3lZOSavQdmeoymi6t3lbUHs/sYuIzuupaxgzJV2VtY16/QL5maZ134W98Ec5VJlH6rqaU
 0CJAM3Ln
 uTMQnJO/HxIFoKP3WDN7k44e5pcL7R9bxbPYDmRYVGDUoy/7hMIF7SOu96Fxe2QZ2ybsNBJuVUIwGCOo0LIKUYQppkcchb4mzynTR6/iS9mlwBxGJf2w/yQpw85lXgF+GkZTzVY2t+Ik5NcBwgPdgRMt+fe8notRHDV/7Jw/dvsUBPR6taT965VzaC/kLPYLMxvL9rKTA33zd3WZSZk/dPgGyUlAwdQP1C8XILm2YQJPKiGjzILvRZqpotn3oJsGnmRPLnx3620LgCDHtjadEf6tzha+GjtMaoLg6aSnSu0GcLIevU6GQFsXqLLCiVcYjUI49e2exe7CVeLVFcdWUerNrXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 08:37, hu.shengming@zte.com.cn wrote:
> VlastimilBabka(SUSE)<vbabka@kernel.org> wrote:
>>On 5/27/26 15:48, hu.shengming@zte.com.cn wrote:
>>
>> I see, thanks. Could we perhaps move the mark_obj_codetag_empty() code to
>> alloc_empty_sheaf()? If not, then do as you suggest?
>>
> 
> I looked at moving mark_obj_codetag_empty() to alloc_empty_sheaf(), but I
> don't think it is equivalent to doing it on the free path.
> 
> mark_obj_codetag_empty() only marks an entry if the slab already has
> slabobj_exts. For sheaf metadata allocated with __GFP_NO_OBJ_EXT, the
> allocation hook will not create the object extension. So if the slab has
> no obj_exts at allocation time, an allocation-time mark would be a no-op.
> A slabobj_ext can still be created later for the same kmalloc slab by
> another allocation, and then freeing the sheaf without marking it on the
> free path can still leave the sheaf entry with a NULL tag.

Ah right, makes sense.

> So I think the marking should stay in free_empty_sheaf(). I can still
> move the caller-GFP filtering out of __alloc_empty_sheaf(). That includes
> both clearing OBJCGS_CLEAR_MASK and handling the early rejection of
> caller-supplied __GFP_NO_OBJ_EXT:
> 
> 	if (gfp & __GFP_NO_OBJ_EXT)
> 		return NULL;
> 
> Moving this filtering to the caller would let the oversized prefill path
> avoid losing __GFP_NOFAIL.But I would keep the SLAB_KMALLOC-specific
> __GFP_NO_OBJ_EXT allocation and the matching free-time mark together.

Sounds good! Thanks!

> Please let me know if you have a better suggestion.
> 
> --
> With Best Regards,
> Shengming


