Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF7CC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08DFB6B009B; Mon,  3 Aug 2026 09:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0165A6B009E; Mon,  3 Aug 2026 09:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20966B00A0; Mon,  3 Aug 2026 09:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9AC46B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:17:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E07FA0685
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:50:56 +0000 (UTC)
X-FDA: 85059640512.22.DE76E1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E167140003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:50:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFihx0A2;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785754255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHtaBqBR2lA62K2It/9H5iX/mbJ0pDsZ9rva719MFwg=;
	b=ySGZBoLf6MMnEZpzTG1kbnYJNr64kQzqflJEIsIOsJPKDNBscvPT1po39JL4uZfzBxWJSO
	FOwgiDmJpxO14eJnbW4QeHlCJS2DzGdkyRCczjWOIsEgA485mQUDmwVXZkcx4OH4a4PMnf
	NGzDwJ5+SIAnxZh8l2ub2mr/FsLo/yU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFihx0A2;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785754255;
	b=glL5tETXqKP/UgfV7TI/fVrIpvwJl9eawTFKFZBrThKn31szzTTPVdFWr299BvGbTDlu3+
	9/TFdRURL6e7T5RzqWvXyLyIFs6utTAaGjHu89ZeoSkKTqU+oqAFM6Y2qgkWdLE5I8R3tK
	iNpNN6jeODEmV25GnaS1x3NGZ7v8kts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E402343B50;
	Mon,  3 Aug 2026 10:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D6C1F000E9;
	Mon,  3 Aug 2026 10:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785754253;
	bh=sHtaBqBR2lA62K2It/9H5iX/mbJ0pDsZ9rva719MFwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OFihx0A29rg1uTXZbxZdVXkbxfuH1uoLEDwBdbye7f0sAHCXfRGQ/jITtAoWPM3eJ
	 ZsuJp74wywdcIobEK2myhLAhhWwWZvoKzHDR5h1lPEnbTzP2sUO7bnSM3ggmBxba+2
	 lZO41+/qSImEy0rzzE5XpgOwWevgDsQGnW8oGRB1RCjwy8fUx5N8URQjMLO9Vur0M+
	 UI1JIGkTbegPz3rmeA7p1IzNdaD6hqx/bTjP+i7TM/HjiAsNEhPzl9nthLAu5kV09/
	 npRzqSFNOyGb8XK3pNgkuMTziaCBn8opgS757+0tAn0XUviOd5s3q9GE/yNaHeEzqb
	 Y2KKzJIQIu7cw==
Date: Mon, 3 Aug 2026 11:50:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anByayBh6Ed2bXox@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-3-surenb@google.com>
 <anBj40CVAhcGMnQ4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anBj40CVAhcGMnQ4@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E167140003
X-Stat-Signature: wqz7mgsthgshghaekskhuygmtf8ye9cr
X-HE-Tag: 1785754254-299917
X-HE-Meta: U2FsdGVkX1+y6bnrP+BDKQoG9V0F06dc35ycqI38i4z+ehnEASyfhMbwyUE/bkHfk0m5lmbTqma+yb1meHRh7YXwlxr0ljL6mkP+WEmJdLmiNCSXFKnxj5OipTt0O2g8VAp3fNcvF9KVQqySxPJ9g68sc239GIowyKWd0/9UVNG1gnkrk2uA1bqWvmPWoIY0eIDtKVw/NPl8kSLrEK4hMuRx+5I5L9tXaENmxv1T/JezVlROye+EOoLZE9RWjwkMKTrFgvZUJ1U2lz+7zSShUyux/FoMnGTeXpmUt5xzSK4UXzzWaKorxnYciFojbrWNsiPiuUDb3sf2+ZQXGpcoFiI9Z0lAuInLVtJqu0hvORDKO9LEiI8M2a+vwLP/7JQeTsgcCcuOkW3Exk53Do0YiB04iOHNV8cNEcSRhlnA+YKxwIE4XbmSu4p30Q3Z9rKN5HI6gP/D7yb1r784U4URR5KuuNdgLsKSCYb2fvQqNNxYJz+PLxk20fygSbhtfwK5XXR9seHeZHSQ7nDMJSCe7upmEy7EJatU9m6qWk3iJzql59U1bEZcD4zBW+b6TG5MAYtHt3qOkjVTKtSsIDKvoUa97zQudFNeg+73M6yluzVfU4pJBqUclVX7BoljSmk6BhOGrNcTDIZylBSwEurq/7+52PcGBv/l0oarwIn0yTP2kqTLezl0hPY2Yrd8xUFTxA90Ysr1JT81X82wC4DkUQ38jKKMFYnHAf3DZzCaRpYZtZfI0cMdgA/BQ+fpQJQWKV4AXsAwb0wUmZLC/5s1LWbIH6hF78lbN95bu4Gfx92ZbdRy4rfCTp7+Pu3CqFKPBuV6LLHTIeJQOF+S/vhPvEkc1STFiIOHIGT7ZUMJM1PX34igjlki9RLzNf1dnP/yyEA+pESge7juajrLwsRudfok2JTku5m+XCf77E50rpwSiYMpd8HgdmzuGgkhdd5EZfUGKyj3fMKHuA3nlgu
 acx2vma7
 hv+C4+gAQHsSScOCbefTst2JPghIP4LF29DPoWlBwU8LWFSmtKxekKgIHw6S9pjRCIhRLGsQpx/wy0ry1W4EKXE6qMsj/Rq6NE2/xKJ/ec1AxlR+n7jehTeN7DmUYYD/eg8qhBldDiFmSjg8q5wuL791sxHg6knzbKGws5Kdb7oHLz8EI42KX72aQTeR8r8Oa1WM3CeoSA3pPJ2E6JcuLXqDwQH0rVCv1sboRocV0mJG3Woy96MnrCdkTPYt1GPcDbAQfNHao2zz9t0XQ8Dy2EHG4+/Z1F1dPgq0iUEbuGq52dpmrOYWUS74m6PfTKdG0mjPnidMqqytYodvAM8DTQWZ2UAyUX6zoPBCgVrKK8tbOke2VyZciKQHk5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 09:48:19AM +0000, Alice Ryhl wrote:
> On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > it and mmap_read_trylock().
> >
> > Long Version:
> >
> > == Background ==
> >
> > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > support for the per-VMA lock, but left mmap_read_trylock() as a
> > fallback.
> >
> > This was presumably because the per-VMA locking can fail for several
> > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > to mmap_read_trylock().
> >
> > == Problem ==
> >
> > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > essentially already a non-blocking trylock. The main reason it fails
> > is also the reason mmap_read_trylock() fails: something is holding
> > mmap_write_lock().
> >
> > The only remedy for a collision with mmap_write_lock() is to wait,
> > which this code can not do. So the "fallback" after
> > lock_vma_under_rcu() failure is not really a fallback: it is really
> > likely to just be retrying in vain. That retry in an of itself isn't
> > horrible. But it adds complexity.
> >
> > == Solution ==
> >
> > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > will not persistently fail. Rely on it alone and simplify the code.
> >
> > Full disclosure: I originally tried to do this with
> > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > trylock semantics. Claude caught this in a review and suggested the
> > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > I guess.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Is there anything on the rust side that needs to be changed also?

--
Cheers, Lorenzo

