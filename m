Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1148BC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 03:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03B26B009B; Sun, 30 Aug 2026 23:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4B66B009D; Sun, 30 Aug 2026 23:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA26A6B009E; Sun, 30 Aug 2026 23:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1416B009B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 23:03:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB02EC03CC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:03:00 +0000 (UTC)
X-FDA: 85160067720.13.B306D54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 125CEA0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:02:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EMx2BUw/";
	spf=pass (imf25.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788145379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETs+4Tl68muzBumLt5I6HKBvhH1PKmH1PnMlTtXNCJI=;
	b=J2fVtRMwx2Blt1U64cCI90YJo6F1q1G/Lwftk6RUvY/Q+4+seFdu9WbbWCrDSWe3lT7pmw
	l5JU5cnHNIPyaF8SSgIfGdH3k3d8uSc7ovXuIrb17cDPL9cFiX99NTiZ9X2B2lejw8dFbZ
	kAhcGsOICec1zzPC4lQasjPFCvD8DsM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788145379;
	b=Il6WZH8ZbuRnjSHghpUZINA7d6F1vQAw/SEbZjxllQ6bqcI2zR+stouob4/+SPl5sUO0Gq
	WOmbOg/VGA/bV+zeCrb9qxmVM2n+JviDY+YBSLzuc37nxA6E/S8t+e95kT0o2njxN6Lh9H
	LCfMMVqi2fR5Y7+gUUHx9BEpAoGGTHc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EMx2BUw/";
	spf=pass (imf25.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 257F441398;
	Mon, 31 Aug 2026 03:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061B31F000E9;
	Mon, 31 Aug 2026 03:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788145378;
	bh=ETs+4Tl68muzBumLt5I6HKBvhH1PKmH1PnMlTtXNCJI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EMx2BUw/mk9z5LR2kM5oqWedT160RYUpYEAIINZtWONcWcjqPg7BbXE56Qy6PEFam
	 er/CkcI7E6VOBemyixM11nwUvcQ1XKBMiAncHZP91YpvllIrSPf8H/cLAQ/lpp332A
	 Qtv+93+m9pamvx79iyt3kcinjJoV6MKxvr/VP/QOi3kTzsHgyO8811a6f7qByR/fyG
	 knhMjDWoSOMdbwmEIkwrIlJXT6qKJJW/UOrunSUKjSy1TeTUI/iVnJy+lLsWabJA8k
	 4LxhuCGGnn23LXaza2y8FWpdBKPmMJzpXXJQ92qg6AOGPRlXY5F6M+6B332VUPtaom
	 2qZ+OGzzcdjTw==
Message-ID: <602bdc5f-e9fa-4ed5-a009-03af860d31a6@kernel.org>
Date: Mon, 31 Aug 2026 05:02:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] serial: core: replace get_zeroed_page() with
 kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-serial@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-tty-v1-0-0cbe6170649b@kernel.org>
 <20260830-tty-v1-2-0cbe6170649b@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260830-tty-v1-2-0cbe6170649b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 125CEA0008
X-Stat-Signature: k76eifdsg3arkjpa9nrjb4a8d93cz777
X-HE-Tag: 1788145378-516598
X-HE-Meta: U2FsdGVkX19wRXZsSbrbbhCadPiRrElgMwcHjSUK2TAdCdgw36XAIBjFoHFvhdR4t3+wgWW9acabaEmpCtagBuXbfbawSXNRPfEIkqhiQoqcARGovJK8dGOcPQdDG7QXtvIDGY9Ws65vVhSeW4qQ+QMD2j+vvl8YrBy1WqDYDsNnl8A5mVWwz6v5yxnRT9io0ZVXwREGUilZXOYPvYaAjUubNFU+qfmOF74oNiHv0+U639jf35XixqvF/kA71kI9Ml4Q4M8jl5FrORIIMQ1U5mRF11HzJIKrx9zSoxTxg41tm+5VCsG4/hxgRTBBGE0J3M0QwyRxAYYhqq9cUmEugzPq4v31+EAZZxg8szZgG86yT6nl7G9XJntuW+eC/LmCRpRAIwvBckvQ8m/rdwcY8u4IoZgX+baASJbTJFBlEYk6beZkKXlex0AeYMrZiTgs66c5yG6aR6X9RxieYolPkoz9lgoAcNmxyXxl3tcyX7kNp5Zc1G7NqfBYcdIRtP8YSjj/OhoNZ9ggaL5/JgZt0rFyDB7QlDbiE3Z5Y/VtRpr7/tU37ZJbzE70CREPU3Qa7OcpzsbBaUymdeVF1JTtgzFiI44USwM6p5kNMqikclyOR+F9dNRHzStNcZ+ndFrGAzD2NWti/bgE2lUhY3LkisezpUjORsyY3bIC5WcJH3UVRPsIqLc82DIlMHuq8POuEnZ6JyJCpwULW3XqR+sdh76yloeGXbdPIPMfUB/9FbteTa1e3z9OeQLpv6m1VkcJ+LjO+Jw8HZgSZ1R3gzaORUAJE3I5Zt97a9oOIBwucJspLBUJxnpQVmufGPJ9dvnepbwUEbyi/kzA+Mpm6tVuwy3Ofcf8khYdqstNVfXhi2hOyzMt5HhL42UQ2HIcBUw9UK74HyxmFh1TM5RD3ThjWZIh4ONfSbP/9jsticZ6TKQc/w/0PybuYgjaZv95N4jQbkrog126G0xyIGQShiz
 vqSF3CqW
 Lv9wWLcwRYS2xm7HGrbhLpnwFPjPWPZmd3fuQz5UT6JBGg8jteftzpIu2WDS+HyPRnpnAavUusArz+dQLDVn+wl6qpdONYldwnqFd7/xkYs1kbfDjd/N4MvpUC0hajA2D5xn8Sn5YsqcwnZbJSP6m8WrnpD9SxnFxrRWc1jTjQCrdhSeY8U2Z1qZoxH/zMah32c8uAwgtGogmpQYYwnksvktXK/hU/krSEtAyQfEuokXyXkBu5KTKuRRycJ5YbwFR+yJX9w1SVLSXi6fR5byJqBh0K1iGL/nD0UNCmBesRxKEZwppcVGLCIXNzioHnl5SYSSRH7xHEDEeELdqdu+279nFGWcFNuNQrvnk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30. 08. 26, 9:49, Mike Rapoport (Microsoft) wrote:
> uart_alloc_xmit_buf() allocates the transmit buffer of a serial port. The
> buffer only backs the port's kfifo, the data being sent is copied in and
> out of it.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> While on it, make the local variable holding the buffer a pointer to get
> rid of the casts.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Assisted-by: copilot:claude-opus
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/tty/serial/serial_core.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 95774b0f1484..f12ce7d190fe 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -247,29 +247,29 @@ static int uart_alloc_xmit_buf(struct tty_port *port)
>   	struct uart_state *state = container_of(port, struct uart_state, port);
>   	struct uart_port *uport;
>   	unsigned long flags;
> -	unsigned long page;

1:

> +	unsigned char *buf;
>   
>   	/*
>   	 * Initialise and allocate the transmit and temporary
>   	 * buffer.
>   	 */
> -	page = get_zeroed_page(GFP_KERNEL);
> -	if (!page)
> +	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!buf)
>   		return -ENOMEM;
>   
>   	uport = uart_port_ref_lock(state, &flags);
>   	if (!state->port.xmit_buf) {
> -		state->port.xmit_buf = (unsigned char *)page;
> +		state->port.xmit_buf = buf;

xmit_buf is u8 *. This uchar was omitted when I was changing the type 
back then. Could you use the right type at 1b now?

thanks,
-- 
js
suse labs

