Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A647EC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65716B008C; Tue, 15 Sep 2026 02:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15CD6B0096; Tue, 15 Sep 2026 02:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D936B0098; Tue, 15 Sep 2026 02:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81A056B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:11:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC7D2160317
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:11:21 +0000 (UTC)
X-FDA: 85214974362.22.3EE7F78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2DFDF20008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:11:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yUydxAS4;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789452680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCk5bN9SaRWwllaiJGSLIbTGPxtbvtj0ZCgGZJ1Msns=;
	b=GAgCLK71Bu2BgbLab7f9VwUdPFfWCOun2N3LBPlc/5ggC9VMoJPbY1QZ64iMU9hL1GyL+b
	nWN2mhW8pXXhvvQdZvqJqnTktESlFhIXG5AAdQoaH4dkEhkCm/vlOT+m7mXqT06X0MppU5
	OerLXrxcFWANgqeH+aW39M/2RJbUV0k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yUydxAS4;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789452680;
	b=4CJA8s63EPrPeYDxj06dD5EEjv2J8KFnaWTUG2ATPa2f00fjGg+wjwPW+0iYPKjyBOrniv
	4cQwudqWULMJGX0UGn5d3za5ymbg4qYXFSUmKt9js/Z/b/rpdfmGM9d6LOHGDk0210tyB1
	5s1MmASl+8sLlJJVfB8SeYVP1qxMn8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18B1940050;
	Tue, 15 Sep 2026 06:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEB11F000FF;
	Tue, 15 Sep 2026 06:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789452679;
	bh=xCk5bN9SaRWwllaiJGSLIbTGPxtbvtj0ZCgGZJ1Msns=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yUydxAS4vHPqlkHac9gwWXo4taASQ50/J9468zWaAbLsONKUVHdztIvnzYOPtAmF9
	 O6spzgv9H5BW8L8d2rCRVaZzuFds6hvGdRP2Ct3QPBpWELIu1r6ss8/scHsd87tvr1
	 d56QkOORK0havknyiEvujnExWzU0m6e2ggNB9JCY=
Date: Mon, 14 Sep 2026 23:11:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 peterx@redhat.com, jgg@ziepe.ca, david@kernel.org, sashiko-bot
 <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] proc/task_mmu: handle special PMDs in clear_refs and
 pagemap
Message-Id: <20260914231118.ac170fb8c2c105412adfedd3@linux-foundation.org>
In-Reply-To: <aqjS0xWes7fhhI9A@gourry-fedora-PF4VCD3F>
References: <20260912122822.3348978-1-gourry@gourry.net>
	<20260914214910.a22cfcdc250bfbb6b14edaf8@linux-foundation.org>
	<aqjS0xWes7fhhI9A@gourry-fedora-PF4VCD3F>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2DFDF20008
X-Stat-Signature: z9bfeqcrr1bnezj4ufcth17sjyd5er5f
X-Rspam-User: 
X-HE-Tag: 1789452680-290724
X-HE-Meta: U2FsdGVkX18X14Q70Esj7u3vT+WN6hxurSrnbqVKDerSe9COBCNICG9h8CuZdmzcLPh27dZ70QsV7L/0LjzX8r9ZZGxsk0JqbtZ7dNSSQNdCElaDWd/PrJJbikxGywETSFMGFBtPZkBThYseVwY+Yymgf5T/bYSzwPuT/88wOt82qFnkgQ5lYUxd1f5xybfxJogC+K66VTJib7R+s0rHwvTNnMu5lsS1xt02zrbl9xU5t7TqtqdtaT74y+0VSl+/Eq335eZncB1HtqRxGD7Z9dvtIwTDaX8FauOwqZFlebIahGgYiIvG0mleyHzj+FN9p+TCFLMz+rNe9JuYRGb0Qb/ALPCAGWZq/I3OeB5mnaEIXZkQOruyA8FN/nxaKU/veGCq4efbPRJoh0mRiVfKZxjZ9DK2eXEt8E1jZByM3LbFQa5nldTvhUepcjgctZ3PSvxl/Hr3YG5Tqjmi0zfgCGzvWTS/TDwxBfzth8B/mk03xulZaKfWUQHHq1tsZHs/EbiYSvdzcPhSm91WohkhBTkQuVJ9fJq3TClqezl0KezmcG8Z1e2fzMrXlxvfsIF0Oe2VMbWb1P+0AVZj/hA1rIcPR3A6l6VONzznEWkEicH0eKcQHRbu/BluMRZwxLSZzrZTaY6tI9ArU6aq8lY10ZzZDkkGJP5NHEhgJFu96LpPE9YGf1Al+ypdz9d3iAEqa1QgQIXgrYNRiKXnX7Dk1i0Yel1zDCGo/uvWJIs1xHCcjOi7xgWr5XGV3ni2/A9r8ZGjqR7uFti6mUVHLG6jzM7rGUWQK0UgJniASYf3VVPpVLhrix6WaPSbgcnQ6USrdPoJ++a7okP8JucI+R7jfaHXs6JbQ9V/53GrBTX0wiXY6gvi5lQYDvr4P3Oo128hex0Yx5XN6oYK4pLUwPosQ2V0WOBlwkJXn5pb74hV+ig62LvsNkyZZXVEQ7hhRI6EbQvg1aflfMPlJsCu4hZ
 uu8lv0pB
 5gwsg79nNQF0dVoCkfwU1tSJuUPwGBC1jRgXqobLuh3EvWTWBC9QeDoV0PjbDawcuqzUpuCTjGk8YWchqfjUnhRUChKDoVqufSNmcIEMafI2tcKusMLUU16F7pSD9Y8BnzyeLeuBe58XPwkLemewZAq5QVQ/9SCeDxvCUk3iJgFiiBEK2q5vwH0leZmhg5QhRqZVwJdDktkUSbSipbWhuqubkQl5pOhn1LVDhPPw9XJWMS1imMUmrlEIyk0qyKBOy08oi8hr+hKq7TXP85rOv7pp6cWeeq/qmfCIZcH8PJNVUC0rxLCnnd6dJ7PiIqJsNKjTfcQz7jgFCcx/JzBdmTYBMtIVZKx/ZnMbzs8ND383X4XKR585YooTOBRNDnUczqSXN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 01:19:50 -0400 Gregory Price <gourry@gourry.net> wrote:

> > > Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> > > Cc: <stable@vger.kernel.org> # v6.19+
> > 
> > Why cc:stable?  Is a crafted test driver the only way of hitting this?
> > 
> 
> Technically reachable via mshv_vtl_low, so i tagged it stable.

I have no idea what this means, but I pasted it in ;)

> It's hard to make a judgment call on some of these - so I err on the
> side of backporting.  Feel free to drop stable if you think it's not
> worth it.

I retained the cc:stable.  It's disturbing to leave known bugs in there
because we *think* nobody can reach them.  What if we're wrong about that?

