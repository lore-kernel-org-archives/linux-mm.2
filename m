Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053C4C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5246B0005; Fri, 10 Jul 2026 20:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F156B0088; Fri, 10 Jul 2026 20:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D546B008A; Fri, 10 Jul 2026 20:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 929F66B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:43:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C89E40592
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:43:44 +0000 (UTC)
X-FDA: 84974647968.15.202CEDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 51420C0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:43:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Bt0/BvUx";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783730622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LbfHUrmsdfE/Gd8GJrnmyAOP3YNcTodQ3L23/iC5b0=;
	b=zg3oRAufi53ndyNGdAZwb5DaFSmGba1Dlf+LlfkYPMdMyNSKj8vJi6kMT0q4U29z+Y3ejh
	bEFVGjNfahC736hK2dwQn/w1P8sU3zAJovJzhHCFcYvRCDFYTjOOvvG2DdM9a0T4Zt/BjM
	55vb5uTJYp7MqQwFfCuyD3kNzyqfGG4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Bt0/BvUx";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783730622;
	b=tbc+UQn8SuRd0dPTY0KsGh/QSLz4R7OdJButhIqulUNJIhYQwH4dDxOgtKQ+B9lkycgelj
	Q1wtkypCuaWL+jh6G9NPZfwHCX/qXW2hLJiKMRiF0l3JBsNAhwytMdL/IcRZPBcC+RXpkj
	6VOG+fSW1vrEOF/GS3uYclAcBI/OxOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80A76408A2;
	Sat, 11 Jul 2026 00:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F9A1F000E9;
	Sat, 11 Jul 2026 00:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783730621;
	bh=/LbfHUrmsdfE/Gd8GJrnmyAOP3YNcTodQ3L23/iC5b0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Bt0/BvUxbtZOGR9BnfwlJwap/0GQ8fHT1MZ9VGpIu0afakcvrOaFjGwt5JLkDhW/7
	 2Euz7Z3ngnsUmpKO5aSIs4xOgtemWJ6hb2Znyblf06uxfAJ2en3cY2WQbAwWjFhsyQ
	 Q1Z2slFaS8g8rOHPuXuXa9DGrhQyJ/yrbicPHS1o=
Date: Fri, 10 Jul 2026 17:43:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, geert@linux-m68k.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: free unused resources when mremap shrinks
 the vma
Message-Id: <20260710174340.9f3b420629769b556f44640f@linux-foundation.org>
In-Reply-To: <20260710021028.892645-1-thehajime@gmail.com>
References: <20260710021028.892645-1-thehajime@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e3dxbk6qem3riozdwsffsb88iqfxr73u
X-Rspamd-Queue-Id: 51420C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783730622-246916
X-HE-Meta: U2FsdGVkX1/G/9Z5h9NraIgu5lznevNIksZaNJXBAT2PqqxvUxbCXW9x9p+qGjSIonu7OKOyegWT5WGxEfA02/on/4YqztJY1tRqSdbPxihqexIBjsOpyc0sLr/UbqCNiqnc8FYtHqxBmG4A8r+UNVg82BEroS7IslbXglg8SsXC2m+SLg6Pq5uT5Hx5DboiphjWmc+YCzJxMV+3xzVoXd505ucP/X1hOeq54Ge/9L4PA2uNocGDMCH9WKTHPGQ9f1/5i9eqjLp40odJOzXZX27hSi3wtVmjGxACnImhQrbjoC48u0tt2uq+IYcYKmSPrCCKcOdiHJ1CDmyNmUHxki4wlK+izjjNibhsBKflVYObLV7CygkjtsOp9L+Cc5Vs048El7/qAc3QanF5epBCGUsjPPMBtuEf9HQlIkFMlWA7yiD+QLy6ZxZWIz0CRV/6zahQNoZQnQEs5Z7rpb7NG8wnwMryclwcAqoYnADg2UAMGdUeEmNyPIIUq2N2a7qtX+/N3CamUD8NC6uVG0u3vO0HxQDrkodyvA89cxmkgNuPPAqIJCWKE02Ufddg23OM28DyrHE2POxBnJv1QX774e0hJqxjx/yThLd+Bac3hro053RuRbwy7D7SOXU3Ra7oKliA/0y6W9RDmYS6vop3EI4jrOjSrDiqTLDLxRhVz5vZP9uy812wUT8Tn47SXuN6Nk1+ek37XcGq7JjySk3v1Iup3i5FgDWbZI1T0IRPhjB3AOZ23aFZQLU7CGV2Kx7w0JZy6sXD4k8jLqE8qGEeJpqxq1D7hLJrKQGnxSoJ+XyLEoE20PTOVFb4uF6wdTeTWbBy4KyMKoRofesNxVqCMaWk2roIzhiL3JIMqIJnvEKjvf+4q5Nr0loWST9GteTEYv5CVwPj+cm6e6N+cEbFOS99XvawSAD4ViNV6k9JeL5AieAl/Vie70tiRmDoDOR5LpeR39CGe0aNCuKtTOk
 N00n4OpI
 b+yLethJ6qgp2IiLpgTqxXX1xDX0l485Ojhyc0CEwBM211oXRpUIraqrxupMhdT9n5WIOoESh49xKc8YjVRoILGs+NKnaCimvV6iBBn98SIdldRkkpFsnM/GbXec+dlgqbk28QcTxbz68dPZP9BR/+DwcaX4DmVzj1Om7JCeVIBeuc8zZc2BlSXNDPl3xz01yKgJo0b0TcZNo6OhoICFKccS1LQdACBZ65MssZhX8EVZF4O/yaIiW3hqFcQq+29pTzrNsiNWrc4jbDrG+kshnpNzk8/WHS2h6Ns7knNkQsmJ7kY+YsqlMrLGWDPFKEaX025iXHlIWWwOj+0vwQS0wtVBptJjGmS0LWANCOrJ+MapHCdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 11:10:28 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:

> When shrinking a VMA via mremap, the bounds are modified directly:
> mm/nommu.c:do_mremap() {
>     ...
>     vma->vm_end = vma->vm_start + new_len;
>     ...
> }
> This shrink the VMA without updating its bounds in the maple tree.
> If the maple tree (mm->mm_mt) still contains the old bounds, a user
> process could access the freed portion. The stale maple tree would
> incorrectly return the shrunk VMA for an address past its new vm_end.
> 
> This commit fixes this issue by calling vmi_shrink_vma() when shrink
> happens.

Thanks again for helping with NOMMU.  I'd like to give you a medal, but
you'll have to settle for an overstuffed inbox.

Sashiko is up to its usual tricks:
	https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime@gmail.com

I assume that ENOMEM is more likely on NOMMU, and that we should hence be
more defensive about handling it.  Seems we have not been.

