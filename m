Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC49FCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3121E6B00B8; Mon, 24 Nov 2025 14:33:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2C56B00BA; Mon, 24 Nov 2025 14:33:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2066B00BB; Mon, 24 Nov 2025 14:33:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0101A6B00B8
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:33:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A43881A052F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:33:06 +0000 (UTC)
X-FDA: 84146498772.17.C29DAE2
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5565A18001B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:33:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fPf9svgl;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764012784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsMhFDvKNXWpM7LYd4pBI2Bvu1L+GYJfurU1oXkgcDc=;
	b=DeyFSCy5wBRnMloFBMzbbiKlQQ2DByl8TxAEPCn09x5LnQXVlAfyX1fzW7blmziwCnD0W4
	SAo3evhcBxcSODE5Jun69l1OCQHOvk7UmbfUOAx4auy1XqldQ1T3aXAKrCIbleDbAE8kFE
	2nZ9D/cga9ymM90BwuaeowD+BrMHsF0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fPf9svgl;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764012784; a=rsa-sha256;
	cv=none;
	b=FgxMbeLgw611l2W87TM5MHgWX2SybtSzCcZ+aCI7gzlaQz253+ilp6UyJunJAh7D4uiWx8
	PY2OSOVIG4ekaiQzsF3gqSgAmYc7vqALQM43z0z+peQKaSjWblblweOzxBpfZbmqNMtXfR
	6QF8OyO2QpJBgrx4MnM4QuPK0hRGnF0=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-880570bdef8so56036356d6.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764012783; x=1764617583; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gsMhFDvKNXWpM7LYd4pBI2Bvu1L+GYJfurU1oXkgcDc=;
        b=fPf9svglGiN47+wiYBTIXbXqcpr6DBHcojNoDuPfbyq+dour74KgvntwrVy/Y+nZWS
         NXeD8dvhzVYuP3LnzkZVR7coL+I+oz8Po+YF7zA/4laXY9tkhsb8Y54BJ07fVkPsBB7/
         xSgg8PCMueHiiJXLkFW9ZXhyuvgiPvoMRdV80Bnq6UPFh0mhIEyEfQa1DwfFLLngkU4G
         b0kvaaimhhhUZhpOlq9zwlj9hkFifh859M7zGITFbr/+Iplmb2/xQb+5HrcByHqM9BFu
         TjPWd2BqIjZ9UzaDvvpUyP+8mV0KUEtSNp9n+PbsBv5USG+VqG5L3Hqxd6YuGfxd1qQr
         8v+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764012783; x=1764617583;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gsMhFDvKNXWpM7LYd4pBI2Bvu1L+GYJfurU1oXkgcDc=;
        b=RITQ6Vi9zTS5bbcRFqpWgg7Or/7BKh2FKukDRS2REQ/hUrr7frjyrCT7cp9J05EQLj
         lt91BIb/8dl5EImTNzjsjpTJBn3KYl0hACcjBlKv8IG/5Ve1Up5PGrmBgizWrvU3zgHG
         xIHXk6aesnKOs3sXN4V8UIpvoWBf9sQpkVoaH16rspYQMfPMn7eQDLHz6Q7DcruMYk5W
         O/i6AfH7pP2jctq4Yi9xVFMPe0im4HLaX4WQfW+opx2DBASyUWMlET1j/mts59TQdGci
         7H1hMAZbQuwuMog25kD55IPd5UDjffaiqZytDHKgp2bq9xDJEgirHZ3czJINPqum2kub
         YC+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWzI4WmL/cTb/mu/mqisHz/whQsuqIVbR3FpGPLlmPGLML3qQqthUDtp8VraVyVAe5QCbtuRRfe3w==@kvack.org
X-Gm-Message-State: AOJu0Yz0M5gOAWTtBr3HURqFIq7Ly+Eo5amjemIip5we4x2KGSxRgOk3
	E0qnmiHbqU2O7064Cy6Kw46+En/nmo09o+ger0gAvzoYtwhmKGrQljQrbax2Nu871z0=
X-Gm-Gg: ASbGnctyh62GvqxBv5SaFpQ+F1k45c/GkQfiY+wLpUQAYfPXHUN3Z1qvigfsA9/17Tn
	WCaZ+UZEKPpOlfwSYiOTkNuJcVeGzmdp3BiymdjRaEWRBhA4yjTbvmSCzuMQDkOAr/CgjlUchjC
	LnrlfjpBekt7ETtFoBM1UMEb888a8mEM/gHORQ4rtsmgaao+8sg4/2RAcfkhmdgewZfZaRxkdSN
	sJ2afJfCdsxKizXCecd/FmWOq/GMp2MHFIBLvJoM/YicVQoutA3+/O5oIMIFjaP9N6n9p9Oc1Y7
	d7PqLxyH8iBUTSnp/N7iKDddVHJlLv7n0Ohz/SxITUfOqH7OxjElbJIkxT2ZojVU1RrRGPePmX7
	KlYStKz/aRvZLRc1Md0Op5K//672/twR2LdTMQ/vWS/MB/dP/Ylm21Lc3FGLmJr4QppZqBinoqH
	/imYdGpLfb7JHuoTtU0w8w
X-Google-Smtp-Source: AGHT+IGDlV7TeJ3rSOfQeqMqm+uAJsOndBpeBaxnYTwlv3dFlHP9QgivOyk0xR0KJb1NqyhU3n/p9g==
X-Received: by 2002:a05:6214:3118:b0:70f:a4b0:1eb8 with SMTP id 6a1803df08f44-8863ae58273mr2050396d6.13.1764012783160;
        Mon, 24 Nov 2025 11:33:03 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:e601:6a28:ae2e:9b22])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e47161esm107276746d6.20.2025.11.24.11.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:33:02 -0800 (PST)
Date: Mon, 24 Nov 2025 14:32:58 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <20251124193258.GB476776@cmpxchg.org>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org>
 <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
X-Rspamd-Queue-Id: 5565A18001B
X-Stat-Signature: 8r7b57ytw496zxrakr499meqbpqh5pum
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764012784-448448
X-HE-Meta: U2FsdGVkX19O9n+Y8/k7/pXhLjNWrrDLJkc3pATz7MWk8+8hcoAAgJWbVChwSY6JnsIGEQ5Qeecd6HTLdkFQ8yJHMPBSk6kOIONl3u6Q4etu7s6+8VULvZCTp3n9a1QltkGibOHraiZ20OM7vtFefxQZf1oIaEB5In4Uc2GcYcYhkjO00t8NrmvBED9k0T9JuHTO8H6P6lcE6xu/qoDHxI3XweXwTNQ1qcRczfnsqK5CVv9wSUjDF5Tpuzn/U+p4hnqlFJw1DmOatmVHO5crEzJTD0rK3siXaa9q2iA4PJ9acY/GEp/a+GeZq0UlePxM0kshGu7qdxlJIaBRRvchX2ubULXHJJ+HW2hKeL0Rsr246KjfgkG0QLuUSK8Z++4z9TXL5UVW3h0dzoZSArgoMFgPddjlRVj1sUntBn2J/UIfvGROZQ2ChzhiEJOd5bRmY+oLiH9Cc0QITjBaPIEwmh9NzzZ3lWz2tDMhe3bg5QdQl88f3wZ3yDLCLs63QCWnSo5PmGhoD3l+PNCen5DON+Fiq8GQGCkZBExMr0o7Bfu7Z1z6syeRCOPNRSBbZqp8IsjYJSk7HG7InVHVzXsSsI/neyULmk0W21xzL84a8G3olsRFswPZ2LCo0+iV/8vORTeXsYTwoiysBy8L91s+YTievmSF8ze/tKgwtipukAl5rsZ56+O9ahvLQhLlLfLIC+vtEhOHqoZQlNeBNhq0dQ/DqoLu+rPiGJ8Wkrw730p4axzpIqna0FYkRpxLo/8xLSGQAeR4xUuzIlKymsokEh2YILO5LLsrXyV+BOTc+WkbSu9YCVM8Y3kmFW6W+WGvW2F0aaQKTXpMxHHdyJZSGhEkWtekph56DCGBIKFj2s0KGZ2HfeoCyi/Hap4Uhx5/ra8b5NrgylF8FSU0/mCGe+B67TP1dToHCsvlIRyOiRCBuhBimR8CM1f/Md1De8NNWdJKEbUTi0JdIIPJkjs
 jbhzVDaC
 9XiLZcSVdr4gYx9x5cRUQ0yxfXeKys1W4Pe2dE0TmCq3SXoMBSfxHIESpUi/Y37cMobUvH6cVnRmzXqXgodQwLGnsSLitSUPqRRYwGpwUSVxPsLCgv9I4WddOsREVRUwRqky1Z4Jl8UHghYL054F96cSTEA5Jn00EN1eUtDJc4J51ADR9CdRJ8qsGssH4WnPKFaLe7ZMfpu0Rx6WsysrSwXq2BudZ4zeuwSq3yLExQnmz5x9MsJ+IulrwyBad+VGM3thPNUD5VL93fINLj5QRJ/S2ZcIaKVdbm8ALz3H7ivct6Trr/LnD/sIGUG+eAEnjMzwWEQ5V831FInEb2jGzY6g7SGBh+FcNeZzHOsDzYRpgJmM0etvLESbStDeScNKm5vP0tRmdcAyhRo/9pvlKk01n8AILZrasAFvkRZ3/6Ul6OVhJugobQqDzvIW7GUotk6VuMBwIA4RZthle4f2R9hUOmhyxzGRBXYObixEkuERAEXwyJoe14s8zeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 09:24:18PM +0300, Chris Li wrote:
> On Mon, Nov 24, 2025 at 8:27 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Fri, Nov 21, 2025 at 05:52:09PM -0800, Chris Li wrote:
> > > On Fri, Nov 21, 2025 at 3:40 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > >
> > > > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > > > The current zswap requires a backing swapfile. The swap slot used
> > > > > by zswap is not able to be used by the swapfile. That waste swapfile
> > > > > space.
> > > > >
> > > > > The ghost swapfile is a swapfile that only contains the swapfile header
> > > > > for zswap. The swapfile header indicate the size of the swapfile. There
> > > > > is no swap data section in the ghost swapfile, therefore, no waste of
> > > > > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > > > > prevents accidental read or write of ghost swapfile, bdev of
> > > > > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > > > > flag because there is no rotation disk access when using zswap.
> > > >
> > > > Zswap is primarily a compressed cache for real swap on secondary
> > > > storage. It's indeed quite important that entries currently in zswap
> > > > don't occupy disk slots; but for a solution to this to be acceptable,
> > > > it has to work with the primary usecase and support disk writeback.
> > >
> > > Well, my plan is to support the writeback via swap.tiers.
> >
> > Do you have a link to that proposal?
> 
> My 2024 LSF swap pony talk already has a mechanism to redirect page
> cache swap entries to different physical locations.
> That can also work for redirecting swap entries in different swapfiles.
> 
> https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5kFOV8jKoEJwig@mail.gmail.com/

I looked through your slides and the LWN article, but it's very hard
for me to find answers to my questions in there.

In your proposal, let's say you have a swp_entry_t in the page
table. What does it describe, and what are the data structures to get
from this key to user data in the following scenarios:

- Data is in a swapfile
- Data is in zswap
- Data is in being written from zswap to a swapfile
- Data is back in memory due to a fault from another page table

> > My understanding of swap tiers was about grouping different swapfiles
> > and assigning them to cgroups. The issue with writeback is relocating
> > the data that a swp_entry_t page table refers to - without having to
> > find and update all the possible page tables. I'm not sure how
> > swap.tiers solve this problem.
> 
> swap.tiers is part of the picture. You are right the LPC topic mostly
> covers the per cgroup portion. The VFS swap ops are my two slides of
> the LPC 2023. You read from one swap file and write to another swap
> file with a new swap entry allocated.

Ok, and from what you wrote below, presumably at this point you would
put a redirection pointer in the old location to point to the new one.

This way you only have the indirection IF such a relocation actually
happened, correct?

But how do you store new data in the freed up old slot?

> > As to your specific points - we use xarray lookups in the page cache
> > fast path. It's a bold claim to say this would be too much overhead
> > during swapins.
> 
> Yes, we just get rid of xarray in swap cache lookup and get some
> performance gain from it.
> You are saying one extra xarray is no problem, can your team demo some
> performance number of impact of the extra xarray lookup in VS? Just
> run some swap benchmarks and share the result.

Average and worst-case for all common usecases matter. There is no
code on your side for the writeback case. (And it's exceedingly
difficult to even get a mental model of how it would work from your
responses and the slides you have linked).

> > Two, it's not clear to me how you want to make writeback efficient
> > *without* any sort of swap entry redirection. Walking all relevant
> > page tables is expensive; and you have to be able to find them first.
> 
> Swap cache can have a physical location redirection, see my 2024 LPC
> slides. I have considered that way before the VS discussion.
> https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5kFOV8jKoEJwig@mail.gmail.com/

There are no matches for "redir" in either the email or the slides.

