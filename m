Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7B6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804DE6B0088; Thu,  9 Jul 2026 05:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5426B008A; Thu,  9 Jul 2026 05:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCEB6B008C; Thu,  9 Jul 2026 05:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41E416B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:07:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C588F168E35
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:07:46 +0000 (UTC)
X-FDA: 84968660532.27.AE70220
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2BEFD1C0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:07:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ikoi6Ikv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783588065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gs9lFJzb/kX5ou22oeAzqrJFsvIK7semat8UR13MP5Q=;
	b=IwbeDLqF71K63IGwGLCzBX6meLQT5Hc1zJIgmyY/4l/I/bzkp64zmFtUYJqyus3aCjF2oC
	UvLKx60GrO4gat85XipExyeEjdUzRZeMc8LN5BMxHVhFWHn8QThcNwn2U5DJ/x81MQA9o0
	ZBgEZDjZxlVmoTeqdC3PVMd4AqUydUw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ikoi6Ikv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783588065;
	b=yLEE/I0ff4VkeBNhvTSXBAy96fEbAEL9bGFx/JRmdx4vzNT0aRIfewRdB8172y5Bap9Gtb
	eiK6NIffQeTBaUiF8xSIzT051fn/dQF8QFTOCZVUVAVhM3SYrxBQ5O44di75rVJyeaEftB
	IbD/hTqXKJMSkWLm0bCV6Lu7BaWzqGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A49D060EEF;
	Thu,  9 Jul 2026 09:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2818E1F000E9;
	Thu,  9 Jul 2026 09:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783588064;
	bh=gs9lFJzb/kX5ou22oeAzqrJFsvIK7semat8UR13MP5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ikoi6IkvC8M7DamoYw/4s1S9Hg2dToWzolNtCaGKb72kXyL6VVArUOg5ZC1wmXGxF
	 DE0HXTFHraPd9x1qMtITAHOES2sFO8e+Ftqdn/i+uJVcnP8HeJ5o5Hnk9NF4VEfbuS
	 nYdMlWHZbUMjETXTaxE5+kkZjL0+jOFh6Afx02jy7sUrtEQ13bJjPw70FUPTfN18KF
	 z8Y8zXGZDUV1AciRJZvpxr5g8ouvKcXZFh9jvg+iIrYVKyEquLg7P1PdJ16XWPf27S
	 kZmTbBk1kOBLXAlBqHZUorNQrcMhvjs3kyJsQZbJC1zu3KonJWMS2XZpy6u1Ymq3/T
	 iIT5D97d7qgFw==
Date: Thu, 9 Jul 2026 12:07:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 2/4] tty: amiserial: replace get_zeroed_page() with
 kzalloc()
Message-ID: <ak9k2oRDa-fhPk16@kernel.org>
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
 <20260531-b4-tty-v2-2-f7149947d4ef@kernel.org>
 <CAMuHMdWrLhDOFeeKJ573pvnmf0cNDsPJKEUQ_g+_+sawLEC6AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWrLhDOFeeKJ573pvnmf0cNDsPJKEUQ_g+_+sawLEC6AQ@mail.gmail.com>
X-Stat-Signature: rrsqjprntx55o4q74syiwcboafmg7em1
X-Rspamd-Queue-Id: 2BEFD1C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783588065-66675
X-HE-Meta: U2FsdGVkX1+9OYkdYb4xiMpLOb6AlD8liZgzIf2mK4DYe7SH9Kj+xeY0U4Mi2rwloqR4eaNjfZC6u8sUuq/YY0d/DvJ6H+CedinjonmnlIoIltrI+gwt9PN8YpCxgO4zlaxNJE7LAexo5cQTmpYYR939fSu5MlYVaoXshqp+sTyz+qkVyQ84z0JQAh9mlI0CWzuqv31PrUTySJgeTfn8sRp0mpLIOWZvOvODqFY8sjj6kRIA6oBbPH9SoxnYEke9dmkdDD0Mc7AmL2ui6su8pA9QLbp9fz5y0DTCzxUSxedxlU+BouJGs83UEJ9V39bM7/48tKQzGSWayIxjaLNNh/KAp4KwEfsUmxSQIiFl5sFTg0+mWqVTB2F0MyZp1XDykJDLw68YcG9489AC0fn4PxRx3/nm6F+GmMn1lFTeGu6Y+B8HytcBvgZwczTHm5pvzRNKh4FwFiJ3/WUGF9MymzTn3TxmnCBocyTu87/ebBWKAFpPdgsd4ijWyJy0mUkEAAywHOzPzikTeplTxO6QaKLcbyG6bFiHDcRZtkZubgywIzBLGRUT87w2ouJ+A8q+ejcwf3uLPHtsSZ1zN7+GspSF+8sp8Hhk6Xim6tyNCvXo+pW6dkBetcJ98np1NlJUz3x50jWlu1dO7XhGZlg2owHEaKrZ8mVviGEe0Kr3KMns9YhHcnLAMQODbhn3AOngpBBepaVYFlZNDfjOIw0xJH/4MAj3/+Xyfo6+m1FD2UnwT35AvqSX0pfEFkAeEgs3ged0T7ic8k3DX9tZpenIAE9OCxJO/xI5EkN8K/byph6IYLTUZDMO0A9zZEZjfQ1TM7D+tlPNqOM6bqWKLWGo/DVa6ntkAQQycIP0d2+3M9M+5WTRsWkGRsFTr7NAT11ruVOJa80qd9ZSTuexqkAWA77qDDKwqt+6sFmZxU8cDXxNmDPcPRtLe3rdTJf67ZwMrDophiocRuyMPGW8D9S
 nx4VRNiJ
 gGXzEKrNmlckFZYFvpoiq+3pIebbHwQNv1L/eUvYnZr8j3ewjZm9TSJtUCcgwrVFZ/ZqKkcv6+j0XY/DgJmCvHWt5TYMK2oM4yYIMz28COARbuMcIM1TcRK+2jtNgp/uGEZjHdsHcRkUm3STSUplyRgktmblIUehuc5x+kBeZSa9aw3WHVD1LXwz/gdkUu4xC24xHKxSBAdmv6ukHEarPTm0oeK2ga7dXoXsLWOaIMK+ENaGGyUG8hYP0zqp78KHXONQMpj8nYt+me5erhGGW6Qm3Q4Gd9eK4KiBcdFDbZujxe0+yz7slBws227KYUD62A9FhCffpGRL1v6cctXbAAvLTQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Geert,

On Thu, Jul 09, 2026 at 10:03:53AM +0200, Geert Uytterhoeven wrote:
> Hi Mike,
> 
> On Sun, 31 May 2026 at 09:04, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
> > rs_startup() allocates a transmit ring buffer that is used to buffer reads
> > and writes from/to serial data register.
> >
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> >
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> >
> > Replace use of get_zeroed_page() with kzalloc() and free_page() with
> > kfree().
> >
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks for your patch, which is now commit d26ed502d0c7c05c ("tty:
> amiserial: replace get_zeroed_page() with kzalloc()") in tty/tty-next
> 
> > --- a/drivers/tty/amiserial.c
> > +++ b/drivers/tty/amiserial.c
> > @@ -443,23 +443,23 @@ static int rs_startup(struct tty_struct *tty, struct serial_state *info)
> >         struct tty_port *port = &info->tport;
> >         unsigned long flags;
> >         int     retval=0;
> > -       unsigned long page;
> > +       void *buffer;
> 
> "char *", to match the type of info->xmit.buf?
 
Does it really matter that much to respin? ;-)

-- 
Sincerely yours,
Mike.

