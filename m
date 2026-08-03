Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66FEC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DCD6B00DE; Mon,  3 Aug 2026 09:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE246B00DF; Mon,  3 Aug 2026 09:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD876B00E0; Mon,  3 Aug 2026 09:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC3F6B00DE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:39:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BB66A1654
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:11:58 +0000 (UTC)
X-FDA: 85059693516.13.D5345F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E82040006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:11:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VYy7zN9D;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755516;
	b=XqsCKZtxlNLPRACUozriUoELICBsQBAgh8VbQMjiyaa2PokO8FEx5gsM5Qmzo6ICRWj6RG
	qyX2e25DZ4M7X+sCFpc/nioRvxTaGKYzAcArKPgjZ9cjhgVu21Vz/8T3cCiYvj1dZkpbRU
	Y9gy8Q49eJdYs9Jy1pVr5q3qWztnY7U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VYy7zN9D;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJjA9p12tFsV6zkH5AhowSQn8yCnJRFh98dmbQ7S74A=;
	b=OLhBt6hK8ESDPG/ZYxZIVD390QgfmW8nJXU94icO+mU6TWaTBSneqYrF00+B2SOgC829hu
	IHBbYn76gGQde4vp1tgXyTYIEGhoYlzXqTA5JTEMCDV6QMmz9xGQYdUk3Wt24fqcIFY3iM
	LhM0dUsft9nrmKyvuGc0JzptQv1VFKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 832B6408AA;
	Mon,  3 Aug 2026 11:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E51F000E9;
	Mon,  3 Aug 2026 11:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755515;
	bh=WJjA9p12tFsV6zkH5AhowSQn8yCnJRFh98dmbQ7S74A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VYy7zN9DQKeubwiuG+IrgbF+ryVDfowZogKwDDz4NWIOW5URub+pUL/pVNmMh24YZ
	 tpQUlAF7BYw18DWmWlNETeMUjNpu9opaVkR9p1HpuWg0MN4zG9782rUewY1BG+7cyO
	 Xo0jlKsFEPT4Ar0HfyxhRJtEy1IurhpiRKDK+IOiu2qFXH9JxL9D2eMsfRjz9lK/+f
	 RPVTiqwaX4ty51kutN6Q8ZKy9cpufqJH56nA5zFp0w3wfg0QYMnNu4WDpiSA5qcAvs
	 H+jL4E4WW4PpVHOgclHuw5ywFycKD25HzsTuONfE0U55xDuEy+13soDMv86Kv8S27G
	 ZImetKrLspSxQ==
Date: Mon, 3 Aug 2026 12:11:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anB3XVHI2nVgz_T8@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-3-surenb@google.com>
 <anBj40CVAhcGMnQ4@google.com>
 <anByayBh6Ed2bXox@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anByayBh6Ed2bXox@lucifer>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5E82040006
X-Stat-Signature: x5m4muhfascapujgorrrg78sy8h4utf9
X-Rspam-User: 
X-HE-Tag: 1785755516-304075
X-HE-Meta: U2FsdGVkX19VjII13lu85gnP5+Wv9oCNiBXnL2poawxXvjmkkg/yfwvmaUIlPkL/t2W9Vb73y69bovXevOGLpcj1YBbG3ki/GklXn040wDetqe4bQI/tTf7plOG+HS9+7BSc0ThJ4N4j01EB17CpQl79rrLnHJW0+UcVGN7lZwu+g/ff3wKt9XH5g3sYY6XjmEPSSMvt3ooT/aGkzY/hOR8plS2fbHCIePHb6dDtvrZKjkCcsdANM71UtUPJ6Aa3xhc+keVAQzoNv5uwuyM14FvnNZUAcfFBFnDynfj/1GF/WcqTwe0zPxTnnCDHaSgmhSils504bgdo6vTqUs0nePSy9ut7BW2Vr3i5TKUzKQ0q86PBvPeJwcwLM2TgBGD/xvzr38GWRLfMf9xxH7FaFwCM2dpZs3w/0i9HBqPt1Cv4DjnGTpa3wNh2CVez/5qRD8ZTxPNKs0FsHo7/Rr9TU8HnC7Od7MISXVpD1eunDp4JqhgtJnuk0Fhel+O9i0tpiLYZ1WpswIw8bNxIcqXPuAqCF0FH73E1LeMR6IGkcv2kItEL7pnz2isT6p8MFpa3Wf/plzSHl6kdPnEoYYFcaEe432PGvXCgCnpjwcl3YQIUqjKNq4ABpjoAexsczhrkUxqQen88JvwYx5CeeYWyASbMzcJwJwYob0B5n35AnMIKdFYL+SNV1U0bAOHncDJJVonY5mSFfGGG3elaLtW5XoYRVRsJFvC8Z8ZpkV4/DMB1SQj3TsuoSRLmsM/hBriTxNjsFBT+h/XU7gYL6Hw+ILmfb6AVcQQuHyDeXqGZMGiuUmk3s+tT4OrTiPl13kzThz+MRyCZv6Mm1P8HMzufubZ78eoVgTu5UCk67wN5ZCuRlP2m9B0pLo7gLiFLg/5aImC/V8rXDi5ie85VA88XqwZD0grT7MBwWTSTQvIRCRi6MBT0t/XMzeOL9RqFRrimBUfyHpPD0FJQWNNsm+U
 px0oBCbR
 7nQY2ur2LWu/Bdi+VB169bskB8ONMlbM4J6XLAS/+BCSO3JCrM2hM3lRjUcp1vWbwzB880LsRnK6VjmgPysZ8huU9mvuXZI+AlKzK+vf6gPNp+Bf6Gfz8U3HAkwEIl9frCKrmJ8CF345cEzo/rsAhrCqtOqm0/urQlq4sLjuSxg5oDUUyF1WoKlOXFAbEC+fBJzxfSZ+QZOeDs7HY8sVErU+dzpF7zSaFxFUjsUiBizsTjEbXFNa2fjMgjfTNuPuT5c8qt4tQebMrvMXlhjxM6NdR8RNui02635eI8k4Ptii6fdvBo3bRvKhxs4LiSam5OcyTuRsSTQFGGQK3XyUKaOTUfTZ309mGPcmmZKrt8BwxO6emxvwd2vxmKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:50:41AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 09:48:19AM +0000, Alice Ryhl wrote:
> > On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
> > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > >
> > > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > > it and mmap_read_trylock().
> > >
> > > Long Version:
> > >
> > > == Background ==
> > >
> > > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > > support for the per-VMA lock, but left mmap_read_trylock() as a
> > > fallback.
> > >
> > > This was presumably because the per-VMA locking can fail for several
> > > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > > to mmap_read_trylock().
> > >
> > > == Problem ==
> > >
> > > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > > essentially already a non-blocking trylock. The main reason it fails
> > > is also the reason mmap_read_trylock() fails: something is holding
> > > mmap_write_lock().
> > >
> > > The only remedy for a collision with mmap_write_lock() is to wait,
> > > which this code can not do. So the "fallback" after
> > > lock_vma_under_rcu() failure is not really a fallback: it is really
> > > likely to just be retrying in vain. That retry in an of itself isn't
> > > horrible. But it adds complexity.
> > >
> > > == Solution ==
> > >
> > > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > > will not persistently fail. Rely on it alone and simplify the code.
> > >
> > > Full disclosure: I originally tried to do this with
> > > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > > trylock semantics. Claude caught this in a review and suggested the
> > > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > > I guess.
> > >
> > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
> Is there anything on the rust side that needs to be changed also?

Ah ok addressed in 4/5, disregard :)

>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

