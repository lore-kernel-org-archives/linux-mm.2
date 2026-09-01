Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8AB0C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00286B0092; Tue,  1 Sep 2026 03:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0276B0095; Tue,  1 Sep 2026 03:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEF16B009E; Tue,  1 Sep 2026 03:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8986B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:59:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF4B71C1DE3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:59:26 +0000 (UTC)
X-FDA: 85164443532.12.562B0A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6DF0D40002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:59:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P7SEFFP8;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249565;
	b=5SK8XzcUYMyAZogm3rpucNPTiAWJwEFZWU++sX1yKtOHQprCgZl09Obf3fTp1JcgpV9w3H
	wUrR0FhvbLrENO4naAJ8Rv6/EZcUyZiaBHGfTtRqq36WlrMHRnlanbQmbkdCqlfAXC+VjW
	O94q4f22CWgq5msQJh00bES2LHor4EM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P7SEFFP8;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJv/WiakOodAqFIubQ5HTmHL0TDtf9MpNqrzEXUw2fg=;
	b=ELZ90MAR/GJ6bRxU84lfe+TGPCe71fuZu7bP8EUT/eiA29vzYwW/UQXrbJZ8Y1moJ7vZYi
	8dwW8nWRcoKfVRVRm+PCjQ1fDCplgLwIbD8CWB+zhH4BwO9nQEUPS4/y0/9nXwZDK99dc4
	gCXHRaVp0siIE0FAg2envVg54W65gxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0667601DB;
	Tue,  1 Sep 2026 07:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201A81F000E9;
	Tue,  1 Sep 2026 07:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788249564;
	bh=iJv/WiakOodAqFIubQ5HTmHL0TDtf9MpNqrzEXUw2fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P7SEFFP8puwZXZp/YRq5bm12kLhga+lgh99B8rQeYLWPKvjGgDXAgg7amgbvop6gs
	 KnFbcm9PWiLs6fpRX3X9ZFziRD/tbsK3eH/C4U9q+apMvreDXnEx9yuMWrWXaAlfn9
	 RfE+EypR5zdZI4scQXJRBlRBhEahbdQVPKXgYGzRzl4sArWd1u++y7ARbEBAYmsoti
	 qa/YYnJeh63FtQSZKwP6986LY6PCjMAcEQlpM6IXvbI4ROaA1SfUtvjcxi9CnB5UZH
	 Nk9IDitG/j2LUr0suo0oUruy11Tq+byoKby/mpiq0sCo0dpWi4sYmz38BnnJLGVmE9
	 9mRRThkgaqcJA==
Date: Tue, 1 Sep 2026 10:59:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Eli Billauer <eli.billauer@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apaF1HUtJnstuUN4@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831123937.32255a49@pumpkin>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DF0D40002
X-Stat-Signature: 1i15coofeefs8kq7x3dumn8f4hbzjzxi
X-HE-Tag: 1788249565-874435
X-HE-Meta: U2FsdGVkX186EewAyGl6d2vUC2hNilnUo+vaaEok2fuokzCPS/BbQl9tpFrLt6crQ6+dYKmFwz3VRRGCYICQLCy3k6H+cM7nxXfHMh1oWGKye6Wk02wcQhjzPnC0ToeXKEFNWRs6qQM0x9NZlhJwkQgCcbPJflz2IQ0JOJQaUyj8o+EBdvod96pUjEGHcGAPqVKe6wQVBIU9HAQmhIOTK0gCwwNYIfHq477lnlP52YIOSe4YRAlSO+W3B8x7/w5cFrl0xYRfCZ4kdfqndVEmn8RxByITDEiCcDu3az2go861v17gkAHMn5MmeLsYUsIFrTyNSQEufhb806rudZpJakscTfTc1ZffiapaXdlFvcOlOiLIFNYWjvVmVyKTZSD662vQIfft1K8Wy6oSRVhTJ0hdrTiH2vCKsU0vEuWW4cYNR8jOt/+mArXnnaTeO/b30UpRMAT4okHkm5W7SbUWDcKrHcU5R6LLeU46f1JrjGIuNb9ZHbEUtf+P3PAIDVJ/AxkNQcwTX2vdviSxWMl2B9VaaPuQIxFuPka2ec23d344iqndOhXtZxyqnPCJgKjPeEpnD2bCr2tIzBsOvR67J1SJmdlq+Xhm+O6hT+QP4+KpMhJCBelqkiTQLWoOuqbBJ18NFziCAJpWju3BgrnPNgRKXHg4hso5G8lU8EbocjQUrdjUszVJTgYCm6Lx1GzM3NTB3+TAk6XDIrmHLrkjLF8x5gy43TRFLnQtmAIMfdCWlT4ppNqr/ZvIGFsZjaMXwdKdZ+lIPS1Z3BzGGHq6Y7vbzfW/EZDjHd5q36xyVv7VHhLYz5/SmqkrY7gkkHMBP002uCRK54rrFseCmhZr4d6JD7Yw1W0MyHIqtEfbp0NHnSmhCAm8sRYHHaNs/RQc6pp2hZQKW1B/uwp67z3xAEvMWBPPsV8Yl54gRd1fqx4lcYjyQZ2FYKkOFXwPPb/qQF/prMpq+6vN8OUZh9Q
 WAoZyaO7
 CGCkV4CNRVewMUVtvDt/r77NAbpobaywww6+ihuRF0m4g5rx04vIwu8P6spZkYlWnTvMzlgkGUgn8XIwibhO47n1BfBCwnDQ7Hvnsczq57r0iSXASCM4BSsvnR/Q2rftMMJ6RhOHTzgKnQ6vcjwXlcixQMdrCiuSHV9AQlkKV15WVd5040hUAUSHvvLS+CTp+G+WlUutqGgZlM0qKnPDos31NtKjXo+mPpwteh3NZ2nkdu5zclLRXnoQoBsJj86b1db6Oe+DVp7umAXD/280yawpnGtxUQUlZQZNoLcbbco0OIB8JaGBQPx1GsxpbRB4kYEeCU8TuREQHdtbQKK6ep3+36iYYD/NW34O+K0qVFUx4+holDcSdiguhBkYk6V6Au+Lo9aYUAjQiuQw2Cl5Z8IZu5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 12:39:37PM +0100, David Laight wrote:
> On Mon, 31 Aug 2026 12:13:08 +0200
> Eli Billauer <eli.billauer@gmail.com> wrote:
> 
> > On 30/08/2026 9:47, Mike Rapoport (Microsoft) wrote:
> > > fifo_init() allocates the buffers backing the software FIFO and
> > > endpoint_alloc() allocates the transfer buffers of a USB endpoint.
> > > 
> > > These buffers can be allocated with kmalloc() as there's nothing special
> > > about them to go directly to the page allocator.  
> > 
> > Except that they are a bit large.
> > 
> > fifo_init() may be requested to allocate up to 256 MB of buffer memory. 
> > This memory resource is split into an array of buffers (fifo->mem[i]), 
> > each 64 kiB (or less, if there's trouble obtaining segments of this size).
>
> Would it really make sense to allocate the four buffers separately?
> And/or use vmalloc().

My understanding is that the buffers don't need to be physically
contiguous and vmalloc()ing the entire fifo->mem in one go should work.

Eli, what do you think?
 
> David

-- 
Sincerely yours,
Mike.

