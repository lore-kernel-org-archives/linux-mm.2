Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F360CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543C26B008A; Fri, 29 May 2026 04:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4086B008C; Fri, 29 May 2026 04:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A166B0092; Fri, 29 May 2026 04:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3392F6B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:43:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7134140A80
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:43:29 +0000 (UTC)
X-FDA: 84819818538.28.07A7C57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4329D40011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:43:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IF1RvRg2;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780044208; a=rsa-sha256;
	cv=none;
	b=c5opRHYoCicHka1eYp3/lQD/qbaiFTQ7z8Qdf7Md1HXhipJZN1GYn9zb27XPYdMX9lVwnU
	CBtR3SGZ7/B0FifMQjdeOWE5enAKHrXFNk0UCSmxI9o/WYBPrazTOC43OeSTsAWHkYKCe2
	co4KypJZk/Moo+Ng8M9ZDuAwTIPrxZE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IF1RvRg2;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780044208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXnHakRi/0adsncYDlGuWfuJsPpVHFQFEDTYwyaoHko=;
	b=11aub7fd1+2Q2d8HkpwV21AnLeriZyoBL5EMgVlwkIi8LX59FJkXKIOAH25FzM7W2WXJpl
	e6YLL7EIDLWZVz/uW/eUvYpHwQlkxlEJydFFY/Tz71jR5nkv9/wIK4x7CJqTu7sFTqAoem
	YIZVblckBFK6aEb4J9CZTqLLNL22TRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AA11400E9;
	Fri, 29 May 2026 08:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8CC1F00893;
	Fri, 29 May 2026 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780044207;
	bh=uXnHakRi/0adsncYDlGuWfuJsPpVHFQFEDTYwyaoHko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IF1RvRg2pqYFk8NBtwRTwuopel/5dnd3b9bmYsdrorGgzJYCUjEmH5vXdoHYgvAQv
	 Gd83x3+CXAElPdCTr7cEUBIQ+mr2PD08s5dd1jIL+st1XcT2J5R76cL/KZhEgx3DHv
	 0VsueIUciBpy4Q6sIH5KeXGYTxUcxDZyQwOMIIRFXareZ8pq0FRTH0FnP3n4+0jfds
	 amahNhyZC6CXJ3+AcmXpc5UBWNC7/TlHrSGCvxsi5xA5oIQ1pSfBLEN+Cw4yngDFGB
	 VuCEdaRspi2q++1DGriDtiy0ThJtopoJhCWzH/zJfYfwNcJrzyv+1q6ad4zF/pS5zb
	 YQhR3ccnxxu0w==
Date: Fri, 29 May 2026 11:43:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: serial: men_z135_uart: replace
 __get_free_page() with kmalloc()
Message-ID: <ahlRqd3e94ojSfWE@kernel.org>
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
 <20260528-b4-tty-v1-3-9da9f7aec5f2@kernel.org>
 <18bb4a45-c26b-4a89-b598-a844d3aadafa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18bb4a45-c26b-4a89-b598-a844d3aadafa@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4329D40011
X-Rspamd-Server: rspam03
X-Stat-Signature: asjqknwn4xtn4amjw4uezaa5s75myow4
X-HE-Tag: 1780044208-643843
X-HE-Meta: U2FsdGVkX1+9OOrCiC02D/QXE/xaCz8s5SikAGrBXgErhRrWuglzAQ0Z2wST9oNdXuxyl4sOaOk0G7qV1cdlmNt94xvUEfwXojI/h1GCJdXkrd6OIIqR7kAQfQtUiV0hmH8IasXP88hSI0oF9EcHS2PhXaDRAB7KjX8Zx2zvPhfAFd1EpLAcEtaOrTMjUYyBkCaRnurD8I71s1AHLmkDCwttz3/lXUXyWLTUBR1UNs5JsSagQZNHrTl9jCbPSGrx1b/pkKjh17QJkKz2mZBBBwjF/tVqG4zY4XgfwhMqaaoVjgIvtZtbGp2tBtWI8jqlX/hvcUJPP6eZK5okT/a7xA4xWM+8TQfyxycAyC5rnJhU5R5BhhiCgzbFfjxNQDUf56tfD3G+SMfEz1FbifMSoSyta2gPHWsMcBSk+LbeAPrRtMqMaw5PeHT4IACh5NBT0QB63my6feaay3VMFozwVhQ1Hi72I3iqVouEWLNmENFYnzIO3dx1YaL2F3KHakZUJy0URUXP17TPZSdz3YAVdtyJ1SruPEeg1p+YFIstTzEQGBd80b2hNDZScqV06+n0vwggD/3Am+T5YpiqDBxrIBXGRjP20syCKo7v9KeBjgms870OuGcTfeLmL6+Gf7YvnXmvAQUmegzagq3TmLxC6zCNTc3cMFd5kF1z9v7AW8l2hENJeFc3BllxyFZL3Eu06mx+6V2Ct3WzsTVlDDCLjL+8WTNYOa7q1dEzSc5LfFxRi+Vh+DeO67FaB1cdwhBEv4CFrEyGaSM2dUfMrVrV4C16pBweOTaXqW5v9K4E3OQyUzwFa9+QK71se1dizxfqHmdzKUWWnvB5oP2HedAoaaj9v2tjAVfDQJwYlu79sn7E++SIDCx+lTMjfR4emNs9FXVMt8MoQMJQCXW/9Ojlh15/3XDAPy95G8lCgXTb6lj9959Fu8A/2OwmCmWllN2vDd6xxpH0oxcDRA1AB1N
 NYeuwuKf
 kngfJsTh/JAVAvIfy6Q5fE8qm/p2Uj7GDgRs/iuIuQ5H4VEf20qOKMRHMsUoklVW4uoJ7q31R1sc+GEYXR/3X/ImliRACLXmbQSpb07sfA/FDAeAiGs7r+d2jG4cP0n5Ofm6MLRCFu7XKLPl3ArNp7IyXzCQyZi7whAwRtUUn/Mwd6ewcCFJa47BjgedBlIAs6o5bhmBhjqoiU3bhrIsh7M4EX0djzTpQlpLHnSqO2TypkFr93Qqy5JAiEt2SO8M38bzwdr33CMu9b8VQtHkNzQA/MAa81cOjFI3ThkUEnGMJVf2QsuCON9CvRPRxSeNY4lmkA4b9QBhSQYeLoCBpQYzEOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 09:47:33AM +0200, Jiri Slaby wrote:
> On 28. 05. 26, 12:24, Mike Rapoport (Microsoft) wrote:
> > men_z135_probe() allocates a receive staging buffer filled by the
> > CPU via memcpy_fromio() from the device MMIO region.
> > 
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Replace use of __get_free_page() with kmalloc() and free_page() with
> > kfree().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   drivers/tty/serial/men_z135_uart.c | 7 ++++---
> >   1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
> > index 6fad57fee912..9c32b01edc9e 100644
> > --- a/drivers/tty/serial/men_z135_uart.c
> > +++ b/drivers/tty/serial/men_z135_uart.c
> > @@ -17,6 +17,7 @@
> >   #include <linux/bitops.h>
> >   #include <linux/mcb.h>
> > +#include <linux/slab.h>
> >   #define MEN_Z135_MAX_PORTS		12
> 
> This one is misplaced.

Do you mean an empty line is missing? Or there's particular order of
includes here?
 
> thanks,
> -- 
> js
> suse labs

-- 
Sincerely yours,
Mike.

