Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DA8CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B578E000F; Mon, 20 Oct 2025 07:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13038E0002; Mon, 20 Oct 2025 07:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29218E000F; Mon, 20 Oct 2025 07:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B22258E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:03:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F7AC1D8D5E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:03:27 +0000 (UTC)
X-FDA: 84018206454.28.0FAFC8E
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6918DC0013
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:03:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K Q6/Lan";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=B2B4UIf+;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760958205; a=rsa-sha256;
	cv=none;
	b=Q+npT6uuLKNbHl4e3rf2foaaFIitpZMThvXN4PYg6wUJvGKMiHYsk3qFW/atv80Ot45rT7
	+i4JYns2NCIrFT0NEd/l6ok3cON+eWVxut88g33q6XRHBz85C7H48H9UaqzYI/Y8lMF6O/
	7JUcMOW8uDCaJnuJjxUr06VcBeH5C/o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K Q6/Lan";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=B2B4UIf+;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760958205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHnlJgCY+BcwVzCJL3u2NoFmsd7fzUk54TShq+8Hw/Q=;
	b=mvmvufxZM80KJ9obH5o/VjTqmzIyG78d3Nym+TEumOwr0Ckc7Oh8RnTB2+SNhxpEPbJ5/H
	sTSjxMOWh2G5+BoCAEsIAnlOKrsoxofZx6QYiLynjoFzoaBtMUcXG/HlNSRx1wsQaDG0O4
	5pAo2c/gTI3YFkbFQh9q4BA7Ab+Lypw=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B47BC7A0084;
	Mon, 20 Oct 2025 07:03:23 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 20 Oct 2025 07:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1760958203; x=
	1761044603; bh=DHnlJgCY+BcwVzCJL3u2NoFmsd7fzUk54TShq+8Hw/Q=; b=K
	Q6/Lan23VJ6Ce3zU/AHzPubMJ9AftWfrxL38CjvzWS4fyD9wk3Myxw4KOl6W7CtW
	2qInLiXoUzdnMOMwE6BhcKnTeuoQG7xjB6jbXhelhz9U6IjFpfZK5T7KdDmQ3tKS
	vLgv2G2wxJ1qrWgkHY9LKCNWhm5/Sly16j5ABinZdqJ3ZEeMgNajIUkC2NADHH3u
	pTMFE03RxjoKoxw4UJRk7ep3SWu3cPBtYLfI/xBjAOom8JcS4sd9GeN4OgfAdOhg
	SNEVPWz+656SD1Yd3wBEPC5KTJXDVuqxRO/dDAq9Fc+NmIQ4daTKLpG5tWWqS+HW
	CMk0RUUD+VueRMMup7wgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760958203; x=1761044603; bh=DHnlJgCY+BcwVzCJL3u2NoFmsd7fzUk54TS
	hq+8Hw/Q=; b=B2B4UIf+K0dMdDDJJzLUHrIjBZvism2roI2+kQZb6KrkfX1KMf9
	nIBnhx3SKYbgLYOKnI1TAvv2C9o3OH8NFAkqcD56X8ugW38o/zdSZBabvu99CC2M
	2IEA0Fmvv0ncl/F7bse1BRKsevasZgMrAsHtzxNwlnwvwbW5AQMo5mTEXoy4v8vx
	KIY7Poxye4MAm4wKcMj+eyvOXkTMHjxXi+SeInX4c3FckvEJ/JT9W4/DtwDcLqe5
	RP1HRz4NT/UKN+UrWXQ4vvWjZOZN3zd8VlNFxs0SvtIMSf1HSRXYw5vdrrezuTer
	QsSfEOT4HQ6VqpPZEuyXjdOgPLDhN4TTKCg==
X-ME-Sender: <xms:-Rb2aE95kqo0YoMNdxI6MXyxVljMheqWCPsHhOQnlMlSUBuTBLSwjQ>
    <xme:-Rb2aOBRAC71rF7e828MnY_AckmLK9eolwPJz0SD0yVOpTgaTm0V7n3BoWPbLm1pc
    id_y_08nCzMcI_yXVptokqAcYa-mdQb92O1hq2gy7QoS24McSRzqT8>
X-ME-Received: <xmr:-Rb2aOogYTX0NabHDV6FusGbYblXHo_ApMbYyghSlMJgSFSC91POb6S-Qk-cuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeejieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrghlughssehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidq
    fhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphht
    thhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsg
    hrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:-Rb2aHLnYOxc_97YeUZzbMpdb8bwVde-55zUlnGsRXbqN5E2XUxVYw>
    <xmx:-Rb2aAKVcDSSFCwkvuB930eGLtrHF0JDDhfnxO-MAzMQtn9jPi7Rdg>
    <xmx:-Rb2aAkFFK-41lOORdZfp0iHV9ps55ecgDAugO8Dp_vCmrQGbALxJA>
    <xmx:-Rb2aGJ-Fs_ZauAUoHQe2YZCcvi5Ps4C43vZPHeCcOfYukj0HxDeuA>
    <xmx:-xb2aPjFOg5xJRQW4h8_rPIlfbfCMvfKzNXKtqLV0GNdXLAh3kZ-9_DH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Oct 2025 07:03:21 -0400 (EDT)
Date: Mon, 20 Oct 2025 12:03:18 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <xsrbm3qilii5cpfbnya2u5dleigbxej4ewctp2yj7i7avkkkkq@yknrffjv2bju>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <CAHk-=wgijo0ThKoYZeypuZb2YHCL_3vdyzjALnONdQoubRmN3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgijo0ThKoYZeypuZb2YHCL_3vdyzjALnONdQoubRmN3A@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: ckdh311i18qx686t4g7bzwsstxhxsnjm
X-Rspamd-Queue-Id: 6918DC0013
X-Rspamd-Server: rspam09
X-HE-Tag: 1760958205-652112
X-HE-Meta: U2FsdGVkX18GZ9ksqQa0yx4KOJt/2IX82f6S32nMsDoI7/z9ZjL0X1DuofDz+kIbKKW2TxUbW+Nd4/M/lfW+8r07u70BKh69Y7aYKTcbbGg+/0il1SUFpKVLWGFO//Dk5eQ6xWGTzbl+K0nV5GL/LcirPzpIYeDTJF+CXxdsqw59XPo2OAho52rJnG+UyWOuqEiA+uouCvBJT81YmjKscWJzcC3DH7oQwi0mHfkjLRSstR+Twrafwye/52Ekz4pZ0mhMhMzLmBswjKppdR8YKzKXV8KI36lsI9AWSYAlucfkmdzGyhW3Vfi+aNIHDbZrVZDLvbSyLDyAA51Rcqbd5L97iAAzF91SfOjkSPxVaRwFf8y3kX4FhM36DbalWiWERsX+QXq0uOezN4Q4IuvW4yT++PJ2sCormvG6RgQHxGxrK+PNOwXZnRLtbiCiOSJZlQOAf4WhXzHvU/6U2qchihK8RRgt4UaHOeeeh4IV5rJipZ7M+7Kf74T2MFDKBPaSKipeqTQFq6sQIHldikIpGZpPT6V/JylZK7giz6myFL09XZe7IHiUVxN/L9LGCSExOkidjJIw4hFeC6c3NSxCIUv2esoqz4w3jwbXaA55JqUKQ84h2+ICgToRlXvhewLcu5NtkAQQNS2wiXLjRMRnmlEgmyryZCYBbvIcR96StCRZtZ2uPgan6+yLyg50vAUuFpci7FzU3KEtefwznimxnQxeQii7Aul0OJkfugLFD/KNRWGDfGjkV0qgeCFLuWGGboTcCFBGqN+0mF/YJtx7AlgG5jLiA+dUTj7Qs45/DEu3XBlwcJ5lA0k0UpGNGvcw7Pn9cM4+ZU0VX+HaRxII0VP1PwIdx3Ba0MCkZ/DYP1Z+YN69V0osT/LC3zZovHRnBUWB5jmOssuns7pMIl1nkYkMHQfF2cPP58qaGQLXPjC4kBh2/dmJJ7hMIx4SwZKB0cvuLHIdTeUUvS1WTdG
 ENXE2392
 KzAOdYEDjvhZ1hkPZ1OoAOEW0qtUN7yhcx78rgO/wn3ZvA2LrDKTMgsn0Gk6DpI3Uq99S2TkCdsUsf/77Mz3j/dxJKB3E9Bq1yvndLslObWmmLD+Q0di42bkgF24qGz/XkFZ9tx7tF3fjvujX1iagpylVMs8xTg2jXm+5HomThp6ulhV5nebwxGTwIOuHjHkNePm8AS/vEpisj+Iy2CH08eq3OGHoUFSf7jxoVukF8RfkAcVy7f+1yxuve+gKKabJDZ97pmqrCArOIuj0o7nZaHNeyHfBdMsQON8ZBsmR6j0KYas3TjkKMC78NJ3MI0YL5zPiVUVF0tbqMVwx1tqqtvEkLmTESqa7ZrNmfBa+bgObOS/eW/BriRnsxLlA30KbyFCK0L27RaYm0Jx+laKzFo3rmWTdhlzgK54v0v2dFdqw2AJMlbaIgAUM2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 07:56:48AM -1000, Linus Torvalds wrote:
> On Fri, 17 Oct 2025 at 04:15, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > To address this issue, introduce i_pages_delete_seqcnt, which increments
> > each time a folio is deleted from the page cache and implement a modified
> > page cache lookup protocol for short reads:
> 
> So this patch looks good to me, but to avoid the stack size warnings,
> let's just make FAST_READ_BUF_SIZE be 768 bytes or something like
> that, not the full 1k.
> 
> It really shouldn't make much of a difference, and we do have that
> stack size limit check for a reason.

My reasoning is that we are at the leaf of the call chain. Slow path
goes much deeper to I/O.

Reducing the buffer size would invalidate my benchmarking :/
It took time.

What about disabling the warning for the function?

@@ -2750,6 +2750,8 @@ static inline unsigned long filemap_read_fast_rcu(struct address_space *mapping,

 #define FAST_READ_BUF_SIZE 1024

+__diag_push();
+__diag_ignore_all("-Wframe-larger-than=", "Allow on-stack buffer for fast read");
 static noinline bool filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter,
                                       ssize_t *already_read)
 {
@@ -2785,6 +2787,7 @@ static noinline bool filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter

        return !iov_iter_count(iter);
 }
+__diag_pop();

 static noinline ssize_t filemap_read_slow(struct kiocb *iocb,
                                          struct iov_iter *iter,

> 
> And obviously
> 
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > +       seqcount_spinlock_init(&mapping->i_pages_delete_seqcnt,
> > +                              &mapping->i_pages->xa_lock);
> 
> will need to use '&mapping->i_pages.xa_lock', since mapping->i_pages
> is the embedded xarray, not a pointer to it.

Doh!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

