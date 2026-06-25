Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76BE9CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440FC6B0092; Wed, 24 Jun 2026 21:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417A96B0093; Wed, 24 Jun 2026 21:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330406B0095; Wed, 24 Jun 2026 21:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DAA66B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:22:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 832BD1A03EB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:22:40 +0000 (UTC)
X-FDA: 84916685280.01.B9D5DE5
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id D313320002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:22:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="S1X4v/+f";
	spf=pass (imf03.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782350558;
	b=R0wSoBCRWfbZ6CdBjBKkhixnhMJ3oVKIE4rB6HBt6FnIOzFXA3MgMK7/u+bjmJBo7CJ275
	h34tzA8QRMrZtD9EBgO8PZH024XMwzNK4poRu29Uf2P9EFe1dwJa6tPOw6wgG1FupxxfXQ
	Pcr9zYYIDA+zb8JI7OrkVDhD3nlEeN8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782350558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYYnMUQS29C/XibFN0kgT1Bwe4Fc7UQjMHHtpQrnQPk=;
	b=DVinH72TwMoiezUNRHjqTBgJHi4a6qIE/e9xljcBtuPj/X3drZfFVZlYSvPQiFfRQJ3E47
	5QOWVqLxENsZBvCIZ+qMAeK1YJHfsJ0zk0TyxpxzTw/ZkSpxDHxpjtcCt7+fznY4z8AGQv
	Gxg5oU17MzUXSejGMakLpDI75iBJfpc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="S1X4v/+f";
	spf=pass (imf03.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1152)
	id 6815420B7166; Wed, 24 Jun 2026 18:22:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6815420B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1782350553;
	bh=jYYnMUQS29C/XibFN0kgT1Bwe4Fc7UQjMHHtpQrnQPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S1X4v/+fVYOGbTDyJ0YPMq+6sEY6vHTPj9JpmuoICtNDuPY/5ySdOdRyoJrL9mtv5
	 sjuOyynW9CZ+VueHzJXoJTIGw5oq4Uzy9rCgwkXNXhUmvR6kKihXmqJeU8aDWebncY
	 qy7WmJ9UDayIdl8MWEBgJSrCzi49OIft575EEmUs=
Date: Wed, 24 Jun 2026 18:22:33 -0700
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	tgopinath@linux.microsoft.com, bboscaccy@linux.microsoft.com,
	kees@kernel.org, tony.luck@intel.com, gpiccoli@igalia.com,
	bp@alien8.de, rdunlap@infradead.org, peterz@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, enelsonmoore@gmail.com, kuba@kernel.org,
	lirongqing@baidu.com, ebiggers@kernel.org
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <ajyC2eX9MKSU84Z8@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
 <aje-nY6QbwZP9XLG@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aje-nY6QbwZP9XLG@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D313320002
X-Stat-Signature: 48cx6655dg5kwheere4bmqkamgcx9fo4
X-HE-Tag: 1782350558-192179
X-HE-Meta: U2FsdGVkX1/ePKkIHK4R1HiwMpTi3hoQhsCqN77gaXGY2jHQD9tHAMAVLh0uNkcGs6KgjfF5PDgVy+EQaMRIgck4frkSXXnrcp7eOLNUo+mj5Dp7T4eIplhgcHrRJiECXbTt3fgveA+JPbeikrZbOnI1F7xzOjEGhG5spQLQioaHcUsGuZVVh+HhgyNWqx8Z0Bel81YKRzADQpV91eolM9FtZqr7puZ/7rStJ136/y4geCHADcDZrbMp2SLSgYDV847584ULAVfJDd+2ErRvrv2qGVpPiewlTD2cP2JMBHBZ5KGeCRFA6RHT/7WWAEvY6L3GtZLUwHgxgJH6Q+D6UEoA+PO7BxaCtfWobcrF+XfI/M5KQowEoaWtLXWFqLzj5FkB0zoafude6UkfnK8TYXiJx6MC/oQ7ovvhfxYsqzDuLdqJryblB29LlytjaL7JWYBIlVwz4SWl882QfLTupm0swNM0noZg4ci11O6ti6wyigSsAudmoCfVLKAq4ZtCeu/Vss2QmCkynEr93LXkhOG4yRJVNAx6k9RMY5OFlAJCFvtOBt7vYTD6UaJRWnDVhRUgaAiBLRB2pktxY/4PUaYw4Yt2k4X8kFLsfPxaSgUtPMn61OxLP3cz7l9tYJ/OUS56D31L8LZaGuW5LG/jv4S2BW2yrTP93EoKqjQYRPX2CzkIAyrXq8DrE9/+XFuLKowKyBa8MOVe3K+tBq9n6cEpgoKifWoNo4xVGS47pd6u8YCpx0sD6QY/egk1mmxln3h7jyoUfh9qG4PedjTNrm4oJgcqj1z6xbbY4dRyMMwaVXAr3ykQC6ykCxSBD4Jf6d3DMh0Vlh0aWWVGDdggmW/ogZcrP1vpBX/i6Z/iNJIB9013DZDjR2P/PqJ7T2EF3tYlvxU/y2AQqpZNJ74l6//E3ZkN/Yb04m57oVRQbn8IDv9haafe/aCoqwXYnNs8Gko80fmVtgmR1/VJ9Ob
 F/oe2zib
 Ia/IRtuuenDNIG/V81B1Eu2jVWYxN+QN57z7XKCbpEehZOTGhvWt8bC4tBXSpmYBPVJ92oJlOFfzAftxF/C8RdGobVjgdAuPkKrjE8ZsrLtckOD0eF/rbbalZuqtqKI7DnpkStUgKktNfsL9p3q4XFahb/jFY74E/5lmUijFyWs5Uu42kdO/PIwewpFIP9CFgpxai0UwHzF6qDwOKpIG81QZZoY3rqDTA3K+DjtJ2socqbv+zF8Gox/yHpJuyJrHqhPcjHoLmCyn2jxrWb12pnYqSppKZa6t6IfIAU+57JtO2M7BiUu9I4CnaM8ScXwh8j3eC1MgQRGrYr0YnRS6fl9CqUg0bg2XuSXT0X5+p8ZQiF686rYHIfN/Shyf7ysy8vQrP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On 21 Jun 2026 13:36, Mike Rapoport wrote:
> On Thu, Jun 18, 2026 at 11:23:31PM -0700, Shyam Saini wrote:
> > reserve_mem relies on dynamic memory allocation, this limits the
> > usecase where memory is required to be preserved across the boots.
> > Eg: ramoops memory reservation on ACPI platforms
> >
> > So add support to pass a pre-determined static address and reserve
> > memory at a specified location. This enables use case like ramoops
> > on ACPI platforms to reliably access ramoops region with previous
> > boot logs.
> > 
> > Also skip the parsing of <align> when static address is passed.
> > 
> > Example syntax for static address
> >  reserve_mem=4M@0x1E0000000:oops
> 
> reserve_mem is best effort by design because such hacks as well as memmap=
> cannot guarantee this memory is actually free.
> 
> If you want to preserve ramoops reliably, use KHO with reserve_mem.
> The first kernel will allocate memory, this memory will be preserved by KHO
> and could be picked up by the second kernel.

ok, On ARM64 DTS systems, we can reserve ramoops memory in the device tree during
the warm reboot.
For an equivalent ARM64 ACPI platform, what is the recommended way to reserve
and preserve that memory across the boots? 

> > Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
> > ---
> > v1: https://lore.kernel.org/lkml/0eaf3be2-5121-48b7-aeed-196405c0a480@infradead.org/
> > v2: Fix code logic and incorporate Randy's suggestion
> > ---
> >  .../admin-guide/kernel-parameters.txt         | 15 ++++++
> >  mm/memblock.c                                 | 47 +++++++++++++------
> >  2 files changed, 47 insertions(+), 15 deletions(-)
> 
> -- 
> Sincerely yours,
> Mike.

Thanks,
Shyam

