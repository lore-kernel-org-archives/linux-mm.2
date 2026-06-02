Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D673CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8D76B03BA; Tue,  2 Jun 2026 09:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99ECA6B03BC; Tue,  2 Jun 2026 09:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8882B6B03BD; Tue,  2 Jun 2026 09:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74CF06B03BA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:08:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11EC34085C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:08:07 +0000 (UTC)
X-FDA: 84835000614.01.5BA4B0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 327F3140003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:08:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YjD8qWvl;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gdrxNrVLvwfZgr57YR0p9t9xmjz+xT3wRBbVrlHhXY=;
	b=SjJv0v/SbkD+KoOJBRosa2ymsSttnkL0BHU3snBfbvg+50N88d3Z/XmMJY5ZrRc7ySjR6z
	oDGMLBYA1lC1Tm8mT7lbwfsDK9Pfdx9Dau/CHh9cn8msYXXEwMawUbQ3BU27E34DLae482
	VtlEOMHTepFas4Jqbpfy1J1vpEAq6UQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YjD8qWvl;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405685;
	b=zhjrLO+MPNhxxcDs0rUG79YR7Dr31z/WOaUm+yd2bBJh8Yla7D886SLbwIZjza0SRsM5AX
	7EtA8IwndDnwUrWwOnDTU3iGvhO3eq++R+jlsDryrgGdkT8wcpJZlzLhDv70NH+ihI64JJ
	n5E5r25SgN18hrpZz4+a+xjVxlzo3uw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67E4F438CE;
	Tue,  2 Jun 2026 13:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305981F00893;
	Tue,  2 Jun 2026 13:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780405684;
	bh=7gdrxNrVLvwfZgr57YR0p9t9xmjz+xT3wRBbVrlHhXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YjD8qWvlk/+0QU52fW24gxJKnVOPSh0k2RXfhE48vNcIA9k++3mfDd64kSZho3Ey4
	 Um2JUR/Fbh6sLYZfpAI9ZoQ4aSGeN70ARBhB1/lmAEm+v0qANoXrtrWtMqiflrzbq8
	 vaPknQr5KMEkE9ZXQipUs5zJTRF0tSEoWRnAbPh2RYPpTy/AGEr1H4qAEeSYygZ/XP
	 yMn2buf+ZEaztue+Aqx1ZA8DllKtJMcnlj7Gcb7XO5AH0C2BkGNFjgVb81nGXq63uU
	 +HIawJK7SRk+DzXdwDYPT42SqeEeRFU3Zp9x2M8D0bc9uz0+Lh7DT7h5efHuV3kNbK
	 ZrOGLEkXJe2Kg==
Message-ID: <589d3c4b-77af-40a3-8506-5b00a5194aff@kernel.org>
Date: Tue, 2 Jun 2026 15:08:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <bfaa33d4-d156-4b11-8735-57a5d1b65ece@kernel.org>
 <a09bb52c-2e28-49f7-a32b-e2743abff756@kernel.org>
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
In-Reply-To: <a09bb52c-2e28-49f7-a32b-e2743abff756@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 327F3140003
X-Stat-Signature: mb4tutosmihc3g41qan7jp36b4759o1u
X-Rspam-User: 
X-HE-Tag: 1780405685-684545
X-HE-Meta: U2FsdGVkX18Ji5pYtWdrPwyGh2NtgEr3F7H0ogzjuHYxMe8oidCMyrAnaP4x7G4UiMbFnn0aBc4pzpwzEHTuKvvzku9i6zqfTSuppAQKAKgNs1UX8HkgXvYBWn9vM0WXnWouIJE7TnQw8EB39CLJK6ycI250KzQfbGA4aEBPdewtdIkwZfi/YX4zCggQxB9h+JHag1Oev1bAjIfqktIKL7zo+qYfqe56bdFalre8UBo7Gj9v6Uze7VOHbTJGuNQG20KtpZq2ZsX1HrvFWbZy88M8a7Uamfl1gEdDDIoDqZdmXor4UvPIMHiKIOUpuejruwOsgJNbU41H/qcQb8cO2cQiK7etDRPmqUIIWci744sJmYqvFtTkLeRy3PlR4euBM7LZ/3LLtTITn9t/N/OeoMTAC9CeDCdh5J4NAPRiVbw31hEFy/Luw+YM5XiKSvaLi8zJKZHTrrpQlh0NyPRMet2obuBG5wwDz4czkKznbxo6pUoDBbow+NmbgxH7HE+X5ZN4D1QcVUzY8Q7+Ks7dbA5l1m8+AALBytUEkBfzgVKkwXMW2LF9h0MPxG5tJxJCmnTGl89VnWFq7YyKZaOOl+OQyyirEnOP2EKXyUEFfcgVjHYfO4po/RBXuCcE7voZCSMWlp5FJKI7IO4SFq9bQsM4/EYTfs5ENgi742DlcqxltJd1uD74AnBf032v6lFxteLaZnYNsQ7BqCDHp74z0UKqvWp628nwYn8BPcT56p94bNMcTsYdlpd0ZQe1VJhIyiKDquWZBGEkvSVuwcgFb/Mhp7waMNC+DixZk1qNsctHv6r4lit1Hpzy5rxQ3dhdRyACRIUMfGEBCjEMyzsF7VUGxUNXPDS5pUSAZlHENHgGJ727nkFtxyJD5Bj/09gkUGqCGO1gi5Uw1imklNjHTHYUvoOw724lkXKlq5+rub3oTvoEA11c/5UG03wpNrU0CijF0P0LmLKBiqlniPp
 ApojgtdA
 hUqg6BRTBUduzAkmaRKkhC8zige4Hfifg9aTN0gDaiUwpNzjc50rz0Gb55leybRz6UIPOFScPDyGlQNhhxLLSp4+vl2I+YXcDe0KHaZYaZdMTBw807X0TcdfyRSL4PFpby9zGqAGf8vcEWbYg4uxa2lnA4IuHQCeEOGYWhbuym247JbKclWQAQkpVESop0BhbtqbtF2o71vYR1wS5kVoObbzzTVyGsITBStROLexqNabK2Os644MFAj0CoYDxhKUa1bNX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 14:58, David Hildenbrand (Arm) wrote:
> On 6/2/26 14:47, Vlastimil Babka (SUSE) wrote:
>> On 6/2/26 13:20, David Hildenbrand (Arm) wrote:
>>> On 6/1/26 18:16, Lorenzo Stoakes wrote:
>>>>
>>>> Err what? The 'random' tree is the MAINTAINERS entry you are targeting, it's
>>>> based on the mm-next stable branch and only diverges in the work that's been
>>>> done specific to the subtree, what's crazy exactly?
>>>
>>> We'll still have plenty of patch sets that touch files cross trees.
>>>
>>> I don't see the problem of sending stuff against the integration tree from where
>>> it can just be cleanly picked up by sub-maintainers (after all, that's where all
>>> the subtrees were integrated against)? Or what exactly is the problem with that?
>> 
>> The problem is that the patches would not be applied on top of the
>> integration tree, so it doesn't make sense to base them on it in the first
>> place. Unless they target the next cycle, where the integration tree would
>> first become part of rc1, which would be the new base for all the
>> submaintainer trees.
> Why does that matter?

Well, as longs as there are no conflicts, it probably doesn't.

> For example, the slab-next tree gets merged into the mm-next tree. Submitter
> will send against mm-next.
> 
> The slab maintainer will cherry-pick the patches on top of slab-next. From where
> they end up in mm-next.

Note slab-next itself might be a collection of topic branches and it might
be more flexible to create another topic branch (based on rc1) and merge it,
than apply stuff on top of a product of merging.

(I think extreme case if vfs where almost everything is topic branch and
even the PRs to Linus are many separate branches?)

> In the rare event of conflicts, the base-commit ID is there and known. If it's
> too much of a mess, we could ask to resend against the slab-next tree.

Alright, I guess some conflicts might be harder to resolve when based on
mm-next and then tried to rebase on slab-next only. And others harder to
resolve when based on rc1 and then integrated to slab-next.

> Again, TIP allows that. For example, I never based any x86/mm patch on x86/mm
> and ... was fine? :)
> 


