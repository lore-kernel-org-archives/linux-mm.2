Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007A4CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0298C6B008C; Wed, 14 Oct 2026 07:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D4E6B0092; Wed, 14 Oct 2026 07:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B4D6B0095; Wed, 14 Oct 2026 07:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B58F66B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:05:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 569131C3CAA
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:05:59 +0000 (UTC)
X-FDA: 85320952038.14.1DB49E1
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5799A140005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:05:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mT3GgBKq;
	spf=pass (imf09.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791975957;
	b=1pMM/02E10/m3pEyEI8rx+OQ9kipYnf3Mtz1p33i71LihaGXH3SkfZtLbYkmXi/bVKVTQs
	QB/6Dn/W9EQSWTiGE2708JEA86YAAinwMQIxpILx+yIa1r1W79H4U/u0yMOdcR9QR4T7pN
	4je/MpArXlyzE/eCj3BJ3N9LL0fjGEE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mT3GgBKq;
	spf=pass (imf09.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791975957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKg3O/9qWwL0S/n8isR5H6f1yss4N5Cz6zPMHFWqGP4=;
	b=cSE82HSo8wo8kNm3k0fOmEoRlhRl3cpXqGTxnKb9CZwiKQlsb6fWugGP664k9Tp0c20YmV
	GnOsTKFUUKJaj7OKxoOrHxTG4DRIcsg+3WBzmebItleI3oWIFAyWazsKkvKec3PbZFX7UD
	lMkhqk7v7RHyxVYg7A0VHN+g7Oi2Ao8=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so196755ad.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:05:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791975956; cv=none;
        d=google.com; s=arc-20260327;
        b=T0BcbGlWIGvnCHuPB+vOmaeerdlMBhHH+5qCjqfN6R4TKiil/tScP1ZFmbuO579e7c
         8m61lWDYt1NMXEK4Kwg4ushjlmJJVu0n/az+zVvuMzDz9bpPDHO1dmFTQfEZVd4b9QY1
         BHh5ZCNDySCyjEBi9dBuCT5opKfqVznLO5uyeaBRKi2p87v3zwX83x/ueyAjoBgwpbFn
         CalGekL7eIElVF2MnOBtjCckk1jQ2b7UPKGrfC2SDPizINjpoKfIgmv2s8XUtSdisrbM
         Qu24qJZqHcuKvUz8dDCA7IYBbnU6PwyWaqNUgtJ70H2lESsCqKitGGVV8Ua21ARs46Z3
         iplg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oKg3O/9qWwL0S/n8isR5H6f1yss4N5Cz6zPMHFWqGP4=;
        fh=nhrMfwz3hPzbbniHteNkTVKFkK72N+W7LHTijG4PeoU=;
        b=lgkPN9nb+dd1kT4LLeUlA+D+V5rXIIcyqT/7nutDmqSHhWBfjgsWyVhZ2xNiiKmlGl
         r5oYmeAwfrCRIZFxtq+viuXkfYHPFU2tPsF89gZj6azQRdDhu1uYp7Zsk0h7QILuvqcd
         jVnwwvHB5MI1d2/UhTDmq6OCyST8aAZCtabuEsRYmlCpw2bTRo5uPxiw3Mx2ZMwI4aP6
         1HTht/YlIpjnB14QPLswvojjkL0U7ksA+fBeTljndGT+2RgtYkyMAAsSIhRfpFxeOluG
         NtwriHQvzhATSiurD53X2zZ+PjHoDJuUYHyrDrX2p7CiJrkJsiik5doafbRf8IsGHeY1
         pLcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791975956; x=1792580756; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oKg3O/9qWwL0S/n8isR5H6f1yss4N5Cz6zPMHFWqGP4=;
        b=mT3GgBKq4XrWQwAIAuvJ53PluHzmLVjuds/R79gWekgocCJcaB/D/SnaJMnY7MZF1D
         xDjkgmHBOpgpmT05pflmYNH0/t472i3oGkZbS2Qma/2Q7Syf8rNsAeAZ3DH7rYouzF3M
         cZQ8b40rwBWEGp+8r6eKuq1E2gkyS+mxE9/3NnTTS36p5XOLL7mvTFv8O3rvB7XNBmP7
         dGeVV9rqF6Ap50Zl/ZdqtluE8mwtvfmgOx+2M8Q/oUsXvjxmgTi5IpGlmvReLB/8LbS0
         ljGPXmZXAfXhdMZR4OcD7sZUuUKxYWeDtwxMJL/ooZ6gQg6hYz1B7Uy33zY6kEikXo48
         mrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791975956; x=1792580756;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oKg3O/9qWwL0S/n8isR5H6f1yss4N5Cz6zPMHFWqGP4=;
        b=eK9aJrMlxVxeJ0e22+aowzKmlYVbcZpiRXfuX6Yok3kFC0mQhyhL48OE2rrydYJ83t
         cfZS0UiA/IrtSRXwyznNihj9PncP1lFuMUj0g9hNI9Bx0SnEvML2Q34z7aMObBLRSUL9
         BMoPcnBXI4YFXnaEsG9fEnh9gEJKE3TiY6aO7ZYjPBaii7c8t2LT49r2h20jjBtKc13R
         tT60UVLK9TkptXvnaCF6TRoOkZ1PpGBgwevADhkvu6pBGWAegS06/jj0GiAfjdlzJvK6
         YJlLBqTasklXXIMEAgq0pV4cd0NoyB39QiY7uT1F4rOic9O69UvCtSWEFlaOZctU4AKi
         Lw1g==
X-Forwarded-Encrypted: i=1; AKwUvBx3X9c2MQPmdoJppS2ZqRf943jgKOn0EhUYpD9iYCthBd9jQDHf5VISxzSxB51tDV8KnthpSUHvMQ==@kvack.org
X-Gm-Message-State: AFq9FYKgLkHQ767X0RIaEzMfzLYNgz1w17CqkDpWkjEQvZIpFNES7w1+
	ftLpXWVT2KzjA5W8+mPcJBrGa/6GQQqfYLloWjQIpElyET/n+978D58qZfjT520qY5Z5gs+k7xM
	PRNjWe9FJ1IHhGiq5h/GwQb2Y4GL6CnWiPW9vtUPf
X-Gm-Gg: AYBFou3hNzcUzn4168iVusajgSC+waLnLtSWk3KIdwbt8+xvWDnqqqeyKEt6dO6JxyG
	Xv/cFqUTGyuFovDKG3LLm2RognqwpXA/gcmo/hn2VoarYIZMi5bQ4z5Ii4hITfSZxvzl9W6JOQq
	uJk8nzGvUu5gxaGNVebSNckmK43AYsS1lqCNYq83PKoKaB8n0uKqV1aqcn+SWrrpWeBFZq8IkH6
	SfY4+RXQfmk+7qS7EiNAR6ttDCoZmH0wrycMoBn3bR0v7no3yXDCG2WD0o5pWY7lGaPV7oDuE3N
	JFnYWOsh8kt0c9yaho4p3lxENE5BLJzvccTMOLML9WQ8vXbuQAsXulwr
X-Received: by 2002:a17:903:1a2b:b0:2c6:99be:9dd with SMTP id
 d9443c01a7336-2e939d0f5c2mr3033515ad.12.1791975955291; Wed, 14 Oct 2026
 04:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <4fda41ed-741b-4c5f-ae83-e3ea5a447441@arm.com>
 <75c229ef-ae41-4072-9c90-98d4779c52bf@kernel.org>
In-Reply-To: <75c229ef-ae41-4072-9c90-98d4779c52bf@kernel.org>
From: Luigi Rizzo <lrizzo@google.com>
Date: Wed, 14 Oct 2026 13:05:18 +0200
X-Gm-Features: AclHuK8XP34mfrE8lQUslMQMNc1nPr8ujKpQNMaoAI_u53qDQl4REr9J8L8QdAk
Message-ID: <CAMOZA0L6hWd=PYLF2PkYwMG11JCson6Wp4Fy9B3k3VC0Vt2R0w@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5799A140005
X-Rspam-User: 
X-Stat-Signature: hjtzqijg36i366x5jww91phrzufw3ahe
X-HE-Tag: 1791975957-500992
X-HE-Meta: U2FsdGVkX1+ejBI7EncKwMqNqXw0TwMhoOP8IAVC6t4sXsqEWla3txtE5rlVKCNBS7hM9WTC4cBv3dZb8K6jR+iLmEwXWb3hUyrkfr/AzgT1UoFNlj7LJ1VunIJrSYCSOkTlXgKFEHbFxkPva+Vbm9I7BlD9voLC/4diRFpL0o58A1xAx6B0rGVhAA3/Xl5qZlfSsFgwU+TYksXDVX2yoWgFpQtXqEM3I6GvC14HSY9F08vifyo0TMzPvc/S9rmH7dPvadv3V07paDnRtA4s0OBO6RSV1VVf5/wFjcrh8vaqJQqW95MVVgIjiPYKKIZE41N/QfHd8K2MXS/ViltwThYInPM4tIY39SwtV9YEixK2peO6ThsLCbJU3zJB+b26X5aTP5M9xwBJDsMWSM8WMWvKVL4Ir0Qcp5ZXfxt69uBwAsXiGt/YhUNwDPEh2xIABh6SDPie8HdCtUiJIL0WkWbrRTbkXz/v++7A/QjLWxH6uk+1G3FVS0HCBYwcLG9xyQ2YDhEp1nO7J0ULSoQI4C0kqVSshrQMjqERMW/NuuE0QG6OnSfvWEaItX+JUCSbNtnYGLhiLH8k9g52ct7mS796n7qt6um7zGdsZi/370TpqrOERHUKA2B7A1bw5zukLB8/noBs1c7XzsUmrGFlbUz0ZZLRjmaTRC2YIaybjN88COd/0FM2zmuXkhaEhJaibgujlW5xjlvkuYpg/B/lf1GHBu2YnBiTDgLwlMN1Fq5xqCYrllr0KqOS9sKvcwt39UlBKKd9qjWFZnFFIB/SuyPMhPlqw8JU6jZbEvnoGJMyFThVrxhQCaY+F9NLxYi0zOkRUsr9Tvsoi5EbiCEbMVa8ZkeeF6Ozt+ZFGtmKISQr8A1mPrAo7TppSiUqTOaiYTEIZfXMw4wacNWCINxwf/Tnq85LBEe2UoM0EAPnLOadQYJb0RMgsDsluwxUnVPAakKl7A6AOmUB+/05QnK
 wK+hqd2m
 z+Hygku3S2fLESydZeGS80agyN8+Na4goTsvvMGeG3ZNrEvaewRverxIV7P6qrV+AtHxU66ikjKEZjVzF8bZ3dRpmPePe1WclCqdIUPTubjs/S7NrOFmrBrSr6oCgdxA4m8e19He9qFtpZohrxYLYXVPxAPSIXkQhln1dY9R004H643C31qElOgq7UunJacU4ZYZfBkQXZPhA0w3zfmmuz61ebn+nv/gtpllnPcznx6uU4jhuMY693OuJEhBgmejkJWpMjf5sF8Rsx/gBXBSViZTHfxH89t0NZnlj6D8Obj/Dnidm2C26SXuZI7mZiFR9Trm1nWj9U9mHScTIORPUo7kPXrz1IKIRhpYrXHEdJ2Yw6lnHQFdpRSM8ksYDjeq8yk87
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 12:48=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/13/26 12:42, Robin Murphy wrote:
> > On 12/10/2026 8:43 pm, David Hildenbrand (Arm) wrote:
> >> On 10/12/26 16:45, Luigi Rizzo wrote:
> >>> On Mon, Oct 12, 2026 at 3:51=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> I had to call it something... an earlier prototype used the name IOMM=
U_2M,
> >>> but I didn't want to suggest that the design was limited to 2M (it is=
 not).
> >>>
> >>> Aside from the name, the _current_ prototype restricts to 2M allocati=
ons,
> >>> exactly because too large units are expensive and wasteful.
> >>>
> >>> In the code, decoupling the allocation size from the PMD size is triv=
ial.
> >>
> >> Yeah, we should do that.
> >>
> >> We should probably just find a way to describe that this is a POOL tha=
t focuses
> >> on physical contiguity in some configured granularity.
> > And since it's intended for DMA we could call it dma_pool and oh look i=
t already
> > exists...
>
> Heh, I did have "DMA_POOL" in mind when writing my reply.

which confirms that naming is one of the hardest problems in CS...
Let's try to figure out a good name before renaming everything.


> > Sure the current implementation is capped at PAGE_SIZE for allocation (=
and thus
> > mapping too), but I don't see why that couldn't just be made more flexi=
ble.
>
> That intuitively sounds like the right direction.

Point taken, I will decouple the allocaiton size from PMD_SIZE this in
the next iteration.

I have also followed up on most of Pranjal's feedback (stricter error check=
ing,
compact IOVA ranges, opt-in per destination on the tx path...) .

I am also looking at reducing some inefficiencies (e.g. pagepool already ca=
ches,
and allocations of new pages are relatively rare, so there is not much
of a point
of having a dma_pmd_pool per queue; and on the tx side, something similar t=
o the
percpu page cache to reduce locking costs when a page is allocated on one C=
PU
and freed on a different one)

cheers
luigi

