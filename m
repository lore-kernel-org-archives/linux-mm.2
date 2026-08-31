Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9818C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D666B008A; Mon, 31 Aug 2026 10:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEA66B008C; Mon, 31 Aug 2026 10:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E41B6B0092; Mon, 31 Aug 2026 10:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73E626B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:25:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 148C81C07A9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:25:00 +0000 (UTC)
X-FDA: 85161786360.20.289D0EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7FD104000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:24:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LITTDiu0;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN8VVuJjyCRIfJGd2CWhuOieF+fTB+JhsXqBxWFw1xw=;
	b=s/IlUS4rlaBFmuuxMG1XAom5k/4ItPLFlENYIacKuWz98+STENoCgWgrDF5HfXAJ/MoauA
	zHKg0Njg8XG+6eD0nuYuOSIeRmXRj3aRemrAxvPojuSWQmkZgEXZgx9ysTEzHRRhbJ5/Qo
	YyiQ47n+g88YmLXTUu2JnfBQe65vQk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186298;
	b=Zt0/pawI0XQR8s8Xy1lsPjr6Z5BNAn+wpNaLmKB6Vkvaa76euU4uR8wDXqWpXh5QydlpLz
	tzvLf9XrvGbOg4UY/C/SY3yRLmSEMPw2sqSQS3E2CD31+Sb4ctIjftxtgphuggfAxz1lrl
	l3JY++/2vRwMwEkMhA6t4gZwjay/WKE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LITTDiu0;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE9D660200;
	Mon, 31 Aug 2026 14:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5201F000E9;
	Mon, 31 Aug 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186297;
	bh=kN8VVuJjyCRIfJGd2CWhuOieF+fTB+JhsXqBxWFw1xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LITTDiu0TuhGMwuKMF4EXuPsKnjGbNXD03w0qkxXneBOu0Oe10rqqshgvKt1bkagg
	 2SiU7E2iSn5d158K4qcu8jAYR0b8GxPGeomms8nTm6p6TfxBBi9jTogLrej/XhKnmI
	 xHkGwjNTm3O8d5s/si0eRHDbveXkajHPlfcNAoe5eJqljzEKT5Q9YTIFrI7cKG9Kqn
	 C4EZc9ZL6Y82v89T5/YbMiIJozMIJ7w0J+7FJh0WxKknNBj8JaAFY5YbCUtJ01ZTA4
	 6JKoQy1jNjb1P4pVGo1xRiZ79kkLnWFuWz8qIMxy2UM6TLllD8pXB/29evc3afAq0X
	 CpFwtqwBDWCkg==
Date: Mon, 31 Aug 2026 17:24:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Oliver Neukum <oneukum@suse.com>
Cc: Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johan Hovold <johan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	accessrunner-general@lists.sourceforge.net,
	linux-atm-general@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] USB: usbfs: replace __get_free_page() with kmalloc()
Message-ID: <apWOslh5BF-ISQ6f@kernel.org>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
 <20260830-usb-v1-1-aa349c302246@kernel.org>
 <ea165ff8-cda2-4fed-9354-1d14ac2d87ca@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea165ff8-cda2-4fed-9354-1d14ac2d87ca@suse.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7FD104000A
X-Stat-Signature: xgxp7s9sciugjgu7zzp1dnrjmzk4oo3w
X-HE-Tag: 1788186298-275008
X-HE-Meta: U2FsdGVkX1+5T3rWXjzNZjKh4OWGGbCoFQ3YedRNAN8Ajl/WGx0fNv5s6uN0QSkPr8zJu9zKPJRBwkrjYeLKl7lyYU3JGDJsh7xSDn0pQc7raWticfEkoUoh/FyHUAF0duv7mix/LHqM+aNZ/Gt0PfS/iKStV4zbNUwsDoZ6sXMaEY0VHyh/yPrRnN+4AycNIkUtXiyBdmYRw7nnWbIbqoqyHJEITB33FFPsXJkCaFk0Xm/Tpn58Cbqur3rlmKo5R/5eODXLtrx3UliizRyg+JJqiUeF31QUOa2wmj0yDXt0jHd5baRytTgnnaFqSaWIaBimYHEFRJj5/MM1AlDOqY0W8Qy5c9vUsoTmXt0PoVge7+Epg0qSTIDjXvO3125K5IoC9NEEdTJgEhghaWr8VcskaJGI4kaSqf0UaJiCTTEsH5GhLnOXRDGdVisea0ynYV++pD+uPRmbTApHPFMtuAqY1qJ99FbSGp/OnZPlpXExDdxvsUIGpT5OuTNwpUGeuhE2zm5YSWFo4VxOGyei8fzkMLvc7/FR5vUEKMgAGujRixg7Cm8j6shpcMhUBCyGwMvfHHy7SIpLnlw3NsDxymkAJU7jOuA6Zu1eXf4xrfD7pB9eQFXFtscreGSj/p5RCDJyikTUk+KIj/nz8kaMrSSOdkcaV5PWK7NBkpbyAID7zdeABr7KYJrjXzaO25v8tC+mwNFs5lXrnMx/XBrzF4qUZu8rN9hK4Zxwf726O+QcXWQfXK3+UFvy+Q5IXOqHsakpFvZ31NoJd621pe48ohKm9EEHnHwHxgBoUUwUuPJdvBIUzCRwA0wKgEUgAUHYlKfWFOM//BqkdTT8Cq10jS6LVSFn1flTR1NnP8WEyTdOQI5/JWmHuKvkZezOg3sS4d11iI3UKBg04K6OtPF72mXxmhP5b5h8hBY8QDo5RCDvbJEbgMxcgrQhFx6+kkWOSlpcL8r5+1r0sZgCkIl
 UKBe34pR
 IeKVL4nE1fhowu+SdxBGaOZ0RySeI8uqqmMui2qfPQteObbg+6uw0A5ln4bniuIbNORdVzYRLwZQ/ySl3ehMEPiTlpZYv/oiziCgjv6sbctEUHQdwMl58adqlEmKaFaj7MxzcuXfw0wrmfa3B3ANlwusyqEIqT6mnuxNCxJlXQjgwKQWxXpSaaDow1CTLYOeBSUqdUX7WUFwaKgRAeW5dGTNm5tQ9apWJiQgiw3iTpmwsMPi09KksIzBDMCuRKpjCCmlQZ70XmeWEzZUquJsZt6hu9GEKo5LhjQaVBH7IinoE1a35t0FVOjOTDYgH5WW0RuJuhJ735QfUqBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:27:07PM +0200, Oliver Neukum wrote:
> On 30.08.26 10:10, Mike Rapoport (Microsoft) wrote:
> > do_proc_control() allocates a temporary buffer for the data stage of a
> > control transfer issued from userspace.
> > 
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> 
> You are breaking the calculation. A page has a size of exactly
> PAGE_SIZE. A kmalloced object of PAGE_SIZE is larger. That is
> a bad idea.

What calculation does it break and why do you say that kmalloc(PAGE_SIZE)
gives you an object larger than PAGE_SIZE?
 
> 	Regards
> 		Oliver
> 

-- 
Sincerely yours,
Mike.

