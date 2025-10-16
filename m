Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3852CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20238E000D; Thu, 16 Oct 2025 02:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0358E0002; Thu, 16 Oct 2025 02:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF908E000D; Thu, 16 Oct 2025 02:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C93938E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:30:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7915E1A020D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:30:48 +0000 (UTC)
X-FDA: 84003004176.23.CA8E76C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7E09C000E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:30:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kS8thQE2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gsQG4Jpu;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760596247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6IbjrRyjIzJUEdaRWMx1gg2BH4tKEtdFB7rtOCxaFg=;
	b=fYIdq8I9fCiPArOBHDUJAFjd95IDq16GxaJC5M8zN5mLQtOW2qArkxNo6CSQlXKroSDSVC
	1wfrZVCqo4OWT5EQSLCJiO3w9W8dk6PVMWMw8Neh1p17VHYDicRD6+cdjBAj+iE/LrSuXS
	Bafs+jwg2F2dWULy78Y2Xe7CV/TyXGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760596247; a=rsa-sha256;
	cv=none;
	b=2UctSEvy/a43Jv7wWqaT6145cvo9+4u2WWelTXilAGPf55dXG19H4XvqItrZ09WxP5fVVU
	V0AbK8M474rQOP6ng1L6YOkAJP0zuLSvejcTgqTO4qoIKswS93dWgQ5TX8zEMu6PUlCqYR
	fmkHTDGf/4qX3j+m9RK4tupf0dToMn8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kS8thQE2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gsQG4Jpu;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Thu, 16 Oct 2025 08:30:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1760596244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6IbjrRyjIzJUEdaRWMx1gg2BH4tKEtdFB7rtOCxaFg=;
	b=kS8thQE2Zc4rb0h4PzRI5Lxac0/ZR7EKxYmT53N42hsNkIkcBSl+WW7KNAXlrO+VxxT6+j
	8QNHgR7fTaTA0ks2XVXgJhgzCN9+uZyHTPWwd3fk5QwIa+TgLW/hQ1hQST88IQWJ8WNfLr
	VXKmqLMyLJVwCgXyp/azHrKXtE4asWAIbgEvo+gdfxxWAvOuCDrkCPQISf0jWkP1CabynH
	cegCTyu/WmbEE4ig03rD4M3Z1xFIzFb4yeyMiVKeszyPYmYWdMnjHjtUgN7JlYjEDRgNJ8
	Wx00LSM22OFmSWLHV99+J0jgUm2TDXBNWfXpH3ueCDRDNcZ6eXnXa/zmGx/kVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1760596244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6IbjrRyjIzJUEdaRWMx1gg2BH4tKEtdFB7rtOCxaFg=;
	b=gsQG4JpuEXx2WtyG9BB4RZX6kMF/vuCCYpilNX3xbWHvvlJ6BtMmNjFzmsSPlwRRYJsWEH
	TeuX3dawgh8NP4Cw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] mempool: clarify behavior of mempool_alloc_preallocated()
Message-ID: <20251016063043.AqrS2HeR@linutronix.de>
References: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
 <aO_taH9CKxmJPnhV@fedora>
 <20251015192717.HvwzCChE@linutronix.de>
 <aPAkNZDr_HAA_d75@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aPAkNZDr_HAA_d75@fedora>
X-Rspamd-Server: rspam05
X-Stat-Signature: ukbib6ycwumzgsacu86iia4ssz1g8tin
X-Rspam-User: 
X-Rspamd-Queue-Id: C7E09C000E
X-HE-Tag: 1760596246-323827
X-HE-Meta: U2FsdGVkX1+08rxXnxjvoZarKRBcp0YTqWBkVQf7K6HGV+XmicLuMvIvSFlVknoa0QI8CTTE9Ob9KZ2Vy7iVtNAtswXAo7siVeUa3yFg//cM6Sm3Y1O8rogwbQnUi2d0pa6Ec5GYvkj2MYarQzH8pnMnVaCTtyIZGBke0BfyikvbKamsBPG6+/fB1AwRRFsgqwX0/GNAwhW6f+fEzChePmiq0CUbxMsQ7EES+NTfoUEvL/xkDEGYR+zkUii2GTtLa9FTtvkCeGHteZNxAC+JpYirIbX0LPLzQqvmppOdbf9Pqf8EdmqARtlI2oRZn5idcZrctGYG0U64IEHEYSKXiQSflrW/E8L09lAecfcdQcXQd5H/jYBi2F0DPHCHgfuEoqqg7a92w+xi8aztIB71Xe4/8quu6QqeMEC3HN70xt1ffUEMATn9pkNywUlz99wAj+TmSYJvpu2xxIIMkIsuHvRYzcwfKUc2W/DOLcrc4ZE2w4L+QLCxrUzNDNBsavLON9NZEZraMSklDlbJfozP27nJ11spshVq1b5eINbbyJBbmaB5z5C9UMgmeKxY69iFfIZtMtcL6X1SA2Gk1nkgkEJ16nua3GIcdZ12+sfuH5W81vimPgktx0an8KPRiyq52IqdHJHJYY3EGyLLo8YPAds6mtHZ0o/ZJLW5HM/h7qDHkY1lNB5tkpcmGI22qclJ5fd9Fg1PqNbmmkdB6FLhZk5T7HNtOFl4Oz2Lj8BUDFt4Q3BL0g0tBmW7q1jdGWgw/Gbetc6nxmhXxAX/Vo61nNlHcXM84QNz+Ly+Iz+QyfkmO7PL/YEcPUR/uCToX79dpgIN7OlrbiXafRwCHplxJJBzVBvRAPhsUQiehM06hHm0cApDAt2KUR+ER7kBEEmQ8cBajJaNbsHy5QrL2IlaAksiMs0todFK41CrgthF7WGt4q9U7bF3LULVwqh5ZvxWZMAmm3LOCyhstqFX990
 wQBReAwN
 z4GgvA7YOSvCZX1iiXanDDjABeofLKY+/uwHFhPPuXkxJI0+jPMTz3hxPeSSFrE5SwQG9btCQpABl5ohFSE1/5oOlFe2dPTgDKx9KHAJlTTzmTIVmqzjwDvy97mgDCW4asUBi76P2GAay55rvym6rX0EKwCXwWDLKvUU4M8+vudcF29I9kwlywMawtMh0hzss+tNLyePguWtu1gjyqLwau7PDiUHKhHLuyQjJWt2tNmI6jzexqUiNhkMfsJPycAJoWbscbMO5CmEAngHgOvG0AgwMXaQqMs5z+SFoanvdMg7WPeVlJHaTBKQhuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-15 15:46:13 [-0700], Vishal Moola (Oracle) wrote:
> On Wed, Oct 15, 2025 at 09:27:17PM +0200, Sebastian Andrzej Siewior wrote:
> > On 2025-10-15 11:52:24 [-0700], Vishal Moola (Oracle) wrote:
> > > > --- a/mm/mempool.c
> > > > +++ b/mm/mempool.c
> > > > @@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
> > > >   *             mempool_create().
> > > >   *
> > > >   * This function is similar to mempool_alloc, but it only attempts allocating
> > > > - * an element from the preallocated elements. It does not sleep and immediately
> > > > - * returns if no preallocated elements are available.
> > > > + * an element from the preallocated elements. It only takes a single spinlock_t
> > > 
> > > Might it make more sense to say "It may sleep" instead of "takes a
> > > single spinlock_t"?
> > 
> > May sleep usually refers to something that can not be used in an
> > interrupt handler.
> 
> Gotcha. 
> 
> > > I feel like the fact that we take a spinlock isn't the important part
> > > here (especially because we always drop it before returning).
> > It actually is. A spinlock_t can not be acquired in hardirq context or
> > when interrupts are explicitly disabled via local_irq_disable().
> > Therefore you should use the function in a local_irq_disable() section.
> 
> As someone not too familiar with how the locking intertwines with the
> scheduler contexts, seeing something like that makes much more sense
> to me than seeing "it only takes a single spinlock_t."

I am not too happy about this wording but I don't have a better idea
either. However "may sleep" is too broad. The spinlock_t is at the very
least documented in
	Documentation/locking/locktypes.rst

Sebastian

