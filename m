Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A831C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB406B00A1; Mon, 31 Aug 2026 04:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A22D6B00A2; Mon, 31 Aug 2026 04:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8E06B00A3; Mon, 31 Aug 2026 04:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22B4F6B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:28:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9690140436
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:28:58 +0000 (UTC)
X-FDA: 85160889156.12.CDD2FAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E79040006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:28:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4ZAcMaG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQpc8lTOdX3xSHi8EiRB4f2hLx8t85VdxKOuNWE2LD0=;
	b=xQvDUbmTol0d5wcjudSbmGbIWP8ZJy7DKgMZslY6IHuQennLUKgAhq9tFPXS7W8YpuOEx3
	Oe3wkbmg0bQIGnOqWo+BAICMy88YMaitnLIxuU60G6JF0+EeknhIewB7iLPGNCL12IXhhK
	UoQPDku/bctsezxdrmNvgLEUBFlf1/g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4ZAcMaG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164937;
	b=RDOyaYb+YuBniiIzkJitZGg9Pi+z0WWcJNUJsWTKU5VeJGj0SFLjIoRSfyG3s+YAbPVOQ5
	Nn9ZNdg5B/WV+6cxJ8e+U0GBM78VOZD9BtuPyGleK7K0WXrQ3FPL/VHz3MdChtX6PItuO6
	439hiaKpAE6fRMbkkFK8eBwzCY5w2TU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EE5B4383A;
	Mon, 31 Aug 2026 08:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F240B1F000E9;
	Mon, 31 Aug 2026 08:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788164936;
	bh=VQpc8lTOdX3xSHi8EiRB4f2hLx8t85VdxKOuNWE2LD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d4ZAcMaGmhWkbt0Rh1OPbj1YlvacnstiEn1h6FFml6IuFq+3UCfM+lcx8aLY2H5Sb
	 aTcviB67lh56jpthcbuARnaiLX4X0zEJ5iPxkrisAndSC28M/yhEdVLGlUkt0diRxO
	 9bduFdfWk+hI7CWNkelr83aVU9pAyG0ntG7S56uds6uH8gbohovzZGzBTSkSIocm39
	 gnGlVJEZbg6CRfoOomrsStasSuqGXnXNNxknZttY9AdVDI4XPTmJ93LIezloeltrna
	 rqfo0Swu4IbyUCEIkpSb0iea7aqu2MJDVQwQFkcSN19DRtkiVxfkbBz7lauGqWknXo
	 5oualX6cx/Q9g==
Date: Mon, 31 Aug 2026 11:28:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-serial@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/3] serial: core: replace get_zeroed_page() with
 kzalloc()
Message-ID: <apU7QSOV22VJL3ay@kernel.org>
References: <20260830-tty-v1-0-0cbe6170649b@kernel.org>
 <20260830-tty-v1-2-0cbe6170649b@kernel.org>
 <602bdc5f-e9fa-4ed5-a009-03af860d31a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602bdc5f-e9fa-4ed5-a009-03af860d31a6@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: aa7r16jkr7gh94hjbnjfxwfr1ycteeax
X-Rspamd-Queue-Id: 1E79040006
X-HE-Tag: 1788164936-734467
X-HE-Meta: U2FsdGVkX19ZBVGENa73zYcwWQRDYzU1gDlWAYs+bmqnv2GSDums9RZJeSHL/CFtvbDdowuelLSpxmFv0kC70zaIrsgGx4ZKd+sHARKVQ6UbX4+8KxHLLuciytKj1QaNe/azspiDzn5m5rbxRMu1Ik+mzbGZ6BxuFeceT/zxqFSVnwwupEs0B0rRoTPdFYbzNUS/3gIudjadFmo1Urer4hlUiIN9UMQEUeIOiXjTs3npsGW27Dj72q5w/eBuTXbiHXq1ledpLgfSCQA9b/EoGvf9hGsc3NKlgXm6GFMZ5Jr4QDOD2xz7s9MwWc7Euy9HUR34g5Li5dosO/A+Bmogkt0v4RYfJB5rBfj8Sv+QocsLJylNOrfKtO8nJTivnu9YL3vxgE4mDmsrsZRCHfuIp3aYryLp5vrRctzvTzMSi1toCDi9P8IEj0+naii3D2Nd1UHdfJ0Z3hAH7S0WTx3GETRTgy+oxbBFDQ7LpIuKTizCnlVZ0H+RCrSR4clGjvidBl9pulRdr3vv76vicmHQTtiNd7OmQVe0ukppbNY+yN1yqDTiTczAvRtVkbCYsTJtSyMz289oIY+lfJQFALvJZw8JTcVwDArMSVTWMxTeAl9mSeh2qzi9bK/LF9R/P9YlioJ84vJYkfkRrpui5y94o7sS8o1ciPvH84C8ja2hBQOrI6p4HZwIRRnicAKB6rNScpAPohlGDmj5IS90xKdKdssM6WmHIZ1FZ6CNO4G98uPGreGWL+4f/QY6nGGQqfS1bmkRnxPPartoAN7FlHZcVQj0cWmw5kKTFo1Gklb6wCpDdUmwHgnbgBiadsL5YRRhZTBTQUU69N+GGe+5nkgckDujGwCaOjbPADKTKtOAsRQA/bt33mg1MQeDRqMRw2lGTiP6/GN8xZ84L/uyWFMJMKCyA3EknQfM19TK7ohbGvqs2lOh5EmkUHeCuCM6wlkSAiuREkv5XaNYRNooDiE
 X0NQNoTk
 ovpnm1b7An5s5DaVagSilg/ebbAzrC/t8WSEd7D0VYCvIyhJ+ML2rRFarTBlSwjZizNkMLxnpTlFWWgMPxZIrNjHUw5OlZPUW1R8E1SlhN3L8LOsXBWC0s2u9EhUH2Ve9uQOMG8kVSEoOF1BesUxCrbg7d8keqbrA80l1f1jTyFb43U5lU2dZABk8D5f2xGK/rwof78c2pmQB+eD4QGL4soImbYEDCflTEaktPfejTcUOM+s5+x0PtT3W86hAQa1cUrGRxlxGZUTeGrcjUrbLHoZI94NBD4/+Ah/oIdFueehL34nZ6FToC7D8dwOpKV5Q+9aJ83qwFEMewSGaAv6SyvG+SGwjpsDxFPRB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 05:02:54AM +0200, Jiri Slaby wrote:
> On 30. 08. 26, 9:49, Mike Rapoport (Microsoft) wrote:
> > uart_alloc_xmit_buf() allocates the transmit buffer of a serial port. The
> > buffer only backs the port's kfifo, the data being sent is copied in and
> > out of it.
> > 
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Performance difference between kmalloc() and __get_free_pages() is not
> > measurable as both allocators take an object/page from a per-CPU list for
> > fast path allocations.
> > 
> > For the slow path the performance is anyway determined by the amount of
> > reclaim involved rather than by what allocator is used.
> > 
> > While on it, make the local variable holding the buffer a pointer to get
> > rid of the casts.
> > 
> > Replace use of get_zeroed_page() with kzalloc() and free_page() with
> > kfree().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Assisted-by: copilot:claude-opus
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   drivers/tty/serial/serial_core.c | 16 ++++++++--------
> >   1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> > index 95774b0f1484..f12ce7d190fe 100644
> > --- a/drivers/tty/serial/serial_core.c
> > +++ b/drivers/tty/serial/serial_core.c
> > @@ -247,29 +247,29 @@ static int uart_alloc_xmit_buf(struct tty_port *port)
> >   	struct uart_state *state = container_of(port, struct uart_state, port);
> >   	struct uart_port *uport;
> >   	unsigned long flags;
> > -	unsigned long page;
> 
> 1:
> 
> > +	unsigned char *buf;
> >   	/*
> >   	 * Initialise and allocate the transmit and temporary
> >   	 * buffer.
> >   	 */
> > -	page = get_zeroed_page(GFP_KERNEL);
> > -	if (!page)
> > +	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +	if (!buf)
> >   		return -ENOMEM;
> >   	uport = uart_port_ref_lock(state, &flags);
> >   	if (!state->port.xmit_buf) {
> > -		state->port.xmit_buf = (unsigned char *)page;
> > +		state->port.xmit_buf = buf;
> 
> xmit_buf is u8 *. This uchar was omitted when I was changing the type back
> then. Could you use the right type at 1b now?

Sure, I also made this change in uart_free_xmit_buf().
 
> thanks,
> -- 
> js
> suse labs

-- 
Sincerely yours,
Mike.

