Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E663DCD5BC8
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 09:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193946B0005; Mon, 25 May 2026 05:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144A36B0088; Mon, 25 May 2026 05:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061AB6B008A; Mon, 25 May 2026 05:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8B486B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:36:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 472EF1C010D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:36:05 +0000 (UTC)
X-FDA: 84805435890.24.55533FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D9ADA000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:36:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DsJeKhU5;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779701763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSlRGc4vedzf5rp11u6syntPvQ3XBzKQAqEIKtTm7KY=;
	b=mKgV3chPDAasvGFl+rNiR9NXm6pGDCcDr5omVMZChAGsOENYZUgCQvFqmZivoBWjAfXcMK
	XfFqMV/2GnPTLeIB45LnPnUe/N3UKiZggaFDchc/Jq/UJKdRwmghe3SIL+JgYlSfQCLx66
	axkWsXP+iZsoGsSb9dSiJrRx2bF+enw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779701763; a=rsa-sha256;
	cv=none;
	b=49L7Ni9dBZ8Ux5b/NOU4GK9vHS1IuZ0naSrJJ4GGmNft6K2HhzE2BgcYNKadR+5gIwcBhL
	HmEgRUogZySGc+HAuS5KyxmI4YeqkppOrdbUS/jAxQHX9XVs64+PpXd44Gq58dbDVLk1YY
	4lH1lVZJAdfrW5aTmJoRrqdbvkEzseE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DsJeKhU5;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9576418C7;
	Mon, 25 May 2026 09:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DBF1F000E9;
	Mon, 25 May 2026 09:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779701762;
	bh=TSlRGc4vedzf5rp11u6syntPvQ3XBzKQAqEIKtTm7KY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DsJeKhU5epa1AZ8TvhGDHxmb6Hif2L/HdyGp5o6jZV7CL8cUkSEJmw3OIM5zgOCn3
	 egTDTF8ykaFtiJaGET3FmAGqTDxzljNfTRUEHLuBugdRmNL2Wv/hxEeznH/d+LxUxh
	 9ViWgqGSjLoMg7qlS/6GRV+NnU3tMgPgEmJLj2AB3wefYypbTo/XcAUWMh7LyUh+9+
	 p0Vdv/BNubvCfV7rOehbgxw/iaIgA/LE6KBesxADsQLVST9cXN6rGBmt+LKF3GowJF
	 A541T1WqqC9+w3HFkOIwvULrppFTgH2dBXUxZlu1OOVCw8p+KLqEsipD6CWlgI6JFW
	 6KLOmxGNmmdfA==
Date: Mon, 25 May 2026 12:35:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Message-ID: <ahQX_JCgS9JWIhY-@kernel.org>
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org>
 <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahP3R2nH8-bHMVf0@infradead.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: s3s977xdxjo9y9399bdbno4dznrw5gik
X-Rspamd-Queue-Id: 8D9ADA000F
X-Rspam-User: 
X-HE-Tag: 1779701763-669307
X-HE-Meta: U2FsdGVkX1/1Vh6rVLZ8X36iKGXJhcslg7Vw3v5Tu8HxHqYuepn9IYkvWOvX5uQN3jxNl42QvGqx5EMMbcV6/Efot7YXqq31Jz8hAdOCMoafTpPoTmRhUiYrPp6vwy1hkS9miOXyrsClp8kbsYujMMf7Uhbz66/Fv9H2HiQbct1EPRaS4ZWFSiCyCKObWZbKhwWlRLFT3ux5B8g3FlwcdFXezJEEjj5MmayjRlf/NVdyjPYob3IyB1yJ5K2EsWcqrS+6TL6FKuagkwZ1T1RNOgerJn/iH0bQ+RRk/8sOkHT/ooGdGXQva7G+nF3/+FFP+Ysm0vt1PndnSNE+faNm75ugMo3aFSnKd9b1r425k8gnY9/+IERTS0zNv8uW1hpW6lzvyDQiznd1oWgM3VQjEpQwTIvCBjJOEQQdSHxyDtH0lGVPWAn89td9xHcOwC1LhQhlA1qWQNHLH5djMcCe4ZSVzRIPfJKOz8iBbeCRjUgvrIhujHZ47E1G46KN7ueLbBEoYoDnWpQ+jDtqsCvAfulzOkMiM+CuZg3j9T5MlmZnotqCJ0anNCDVKn6Utz1gjHeHMuUISkZqUwGuK+Dl4WJwoKXk3MP5cNeIksx3YO7jveJFwFI39entxM/0eIPIs/ltMN4Ba+Uy1CElxvN4V9pnz/WdEWSdQqLgND61cu7sBKtVKFQwI5fe29nsSeC4UDCRjINppRPmShLO37n4psu3eKN3te/arLtHAFDlxeiey6ouvrlD0tbO/vcKrohQaCgfdoYO5ho3q29+6MQd2eUJTDJhrWninmd9JzM2Fs+gkCIyF4PjmwsYDNYnQpmGwKHcdn/xuABLtRBOsccTjZetp99ezD6x0U7OTP/eWB3OHL5JjjeHW0D1Qfnm4eyYOtkyW8LEMN+6NAkI2DyLIuDEOCW9B4SEcH17bCKhcpvFUJYX1XhzCdw//11GZA+lqFLuffFmCoQQVpbivP4
 vmL3mwbp
 1U3g6RVVQYcSf8EThRlPhcP26EDWR/VL8qhQ9B9px7aKDEjxe/MzdW8YIbM0FdVGxVm8rqlPPoUhjhRvRSttz0vyoj0IYLNp6BXtK5MgtabZ1tU/DwuyywQchMNNjKk+NCoB/l5iSzrnuq5zdF3oCcZjSGMLhg0jBNzvON+AK4nICNyQ+i/+XNjzQ7zbz44+z2pscZJ+3/qtj68HjC/bZG/RsKZmYhxQo270gwJMiBDXnKh+WmvTakaDCUpBLRIfXn+xfekxygRPhW9mIn9Nr0CWb6RZi0TJB1Dr2072xRfjHzpxEyvG1mrWr2C8kBZP59EqC72CidehKh6kXElvQ30+bEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:16:23AM -0700, Christoph Hellwig wrote:
> On Mon, May 25, 2026 at 09:52:09AM +0300, Mike Rapoport wrote:
> > On Sun, May 24, 2026 at 11:08:31PM -0700, Christoph Hellwig wrote:
> > > On Wed, May 20, 2026 at 11:15:52AM +0300, Mike Rapoport (Microsoft) wrote:
> > > > check_partition() allocates a buffer to use as backing buffer for
> > > > seq_buf.
> > > > 
> > > > This buffer can be allocated with kmalloc() as there's nothing special
> > > > about it to go directly to the page allocator.
> > > > 
> > > > Replace use of __get_free_page() with kmalloc() and free_page() with
> > > > kfree().
> > > 
> > > So I heard various vague references that we should replace
> > > __get_free_page with kmalloc, but nothing definitive.  Can you please
> > > point to a good resource for that?
> > 
> > There was quite recent discussion when I posted patches that change
> > __get_free_page to return void *:
> > 
> > https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> 
> This doesn't tell much more.
> 
> > And an old thread when Al posted similar patches:
> > 
> > https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/T/#u<S-Del>
> 
> This does, but it still fails to explain why kmalloc performs just as
> well as __get_free_page(s) these days.

I don't think that in this case - a single allocation on the cold path -
the performance difference is even measurable.

Nevertheless allocations from slab caches are way faster than
__get_free_page() (i.e.  alloc_pages()) as it's essentially lockless
cmpxchg. Allocations that need to refill the cache do alloc_pages() with a
little of slab bookkeeping overhead.

-- 
Sincerely yours,
Mike.

