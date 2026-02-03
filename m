Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F53FE8B37E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 23:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB716B0005; Tue,  3 Feb 2026 18:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6889B6B0088; Tue,  3 Feb 2026 18:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587356B0089; Tue,  3 Feb 2026 18:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 429A66B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:01:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6122B160602
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:01:29 +0000 (UTC)
X-FDA: 84404668698.18.529A5E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C9FD64001E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:01:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L5yZ+41L;
	spf=pass (imf01.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770159687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kte147V4yHmLnX7PSerPack63O9JN9FG1nzBfVGN0QU=;
	b=RCDx0JJ3OxxXBuM91CjixyK3DAtXWY/4urtgOEmuNWNjP0Csfi3i1/sGId/g3LDoD6jnUF
	TLlAhuNKQ41o0E16F8hrpYm12xHHLgBkf1M5duhkjSIf2BwmHtV+TIiR6NoEmqKl/JR3DB
	hMt1QjHfW9eT0td3e8d1Z2/7RGfplTQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L5yZ+41L;
	spf=pass (imf01.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770159687; a=rsa-sha256;
	cv=none;
	b=ippQ1Brh1Xw0egUCB4sCilDOGjfhaAde2qpMJdpEGN6kWzJe0teGbpaL+ehTpl9I/obYEp
	vlQ1wVUe+OIhpjZIOJV4pMfFy1YLeL5KCY+tkoYKJq/tgtm5IyJAreSKvPEBh5ZeNkZ8/V
	1Vms2nGCG65se7Pes6wQ/f1hOLoajTo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E81176012A;
	Tue,  3 Feb 2026 23:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03C7C2BC86;
	Tue,  3 Feb 2026 23:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770159686;
	bh=6+OC8xqFJ8Ra/JiM0dVaFvJDlj+ZOH9NPyD2sp5CHvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L5yZ+41Lkhu4k67GeeWfmbzf7Bese7xS9DR+H7NtUWfk91m1eJVADLP2RVyzrG+Ct
	 rgh1e0VvKFsqLRGyjoYNtTZFT7YqajHJ0wSLMJcfhM5ZPrSHdzGFxnyc4B0PaU6kW9
	 rJy05Vubc9PFZSKul5Xp55uXRpbD2FSJXhZEnL2RCcqWCSURqndssF/HGVX2B1XJmf
	 8U17Twn+xWoR4ftCuLkx+aEvjAjfWHNPaYD6hPOXSpPwVfs+QwPXjiwrxEHVhfHe1Y
	 kaG1r7vgEzvrEjWXW1Lm8XwAsdwwRTcPpbQMVWvxRWMYfQFuHmjXOpJjPj9wpxjX/l
	 EMOw47C5+xn5Q==
Date: Tue, 3 Feb 2026 23:01:24 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Harry Yoo <harry.yoo@oracle.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	=?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
	syzkaller@googlegroups.com, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	"Theodore Y. Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Message-ID: <20260203230124.GA1161785@google.com>
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
 <aYHFZ5OxfL4j-_ze@hyeyoo>
 <aYIh1wPm7BrId9dk@infradead.org>
 <6f5881df-0e0b-4278-808b-7c0cffa12a30@suse.cz>
 <aYIpVq-jTKyTQE8G@infradead.org>
 <d9dc2ee1-283d-4467-ad36-a6a4aa557589@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9dc2ee1-283d-4467-ad36-a6a4aa557589@suse.cz>
X-Rspamd-Server: rspam11
X-Stat-Signature: nnbzeydtt89d3ascsuz86uk347sjtyfe
X-Rspam-User: 
X-Rspamd-Queue-Id: C9FD64001E
X-HE-Tag: 1770159687-341115
X-HE-Meta: U2FsdGVkX19SCtuZH5CFxSIopqt19SgfMsKE0WYxQVlJhrmucHNOXxj5jTztB+khy/5Vj0dla2UGkvLyph4L3sYcqs+c9j76wV8IW3QXmLADqgCRJ561bQEMy7YUUnA3AQ8hxd2bTFs35bUPGEqhrR2YVbCZUEfn2Ob52p8MN7n6R40MUjmqBLxU30aPsfzq2GPd2v2HOR6FuRya43uUgkYXqHRp7YCegK1qjRqS6KgODClKex0lSpTxXAJwc4jDOZMkSvzUxrm4rU1KDL4b8H3ijiwTMABmMuNtUtMbu50G/VLXDDfJBMS9SIq7kqHWIGaJfewgD6UX9pRe4DFCu/VM4LLN53M1klLi9PY1dvyU1ArQcbF+StGNzpwVlauhtqI6NOcHRIxIWG7F3Sj6nZCY9Tc9PDmNZkBdMsdY1T/SMq6mqAXfHOxwRWODSdj/NquAL/z4pKcMiMbLrMZrWZBHikRJw+a8dMJOVTgOGIKXCXAYIhiYKZaj4B8AUNnJwzNYWBRRdBkXrNQ3OzxYkWmqowVMAyaT0CPzncCAdsk4jhTBWOLxz7KmASvDUkoqPIhkzj2N1Sf5LNqNaqW0hrzzT4Qcq6eQlumHpJx3eerExJF1xwM8sFlUO8ZrYi4qXwGrjeNPjcZgOyIpTKf+krsYgqYBc/sFg7bPFrQbnlxz11AehOjPz1Y6PBaYNNlDKITD5vPlAeaP3BqRpbmuBFJ3YsanvbLdlT3BBsA2J8QP11r8WLSKlSl1D9rBxeCfmXIAeMxyVCq5LHphWKLvd6qOvBeKpVL/xWTDIvFNzwI3ynQyCEhHfJgn0n9bR2sDpUDBoP8wKELdb1+58c2RWa/7WN4PHgMRq16xY4lndTDw7tjgVuGSivMCTqcb/S5oiZSwKUBglGiXOuCzBVAPiMOut8mkDVT9dsu/A3S4AeMuUq0XDw4JbQA7NOf3eRg3EwddsoE58QPkS60RMmT
 P0vi0XIA
 xi80KEYAhegTw+Gd4YbGRcinSFY/hE+sYVU5GhaeUPohS7JOhr6tOMVC3R+NXRGUEV4FT5Z1F9zDQSfIA8RVtARj8BfyrO1N30NKRW23Deq7k0FKmcWKjDqC6pPOP/NlV65MHmi+lGsf3RcuEFtR221vSkXsVGWHyQhfzsygcrdttCMUkOlpoMFDdSnwiyznCtiyS7qJJoqYIUTEIiPEPafCfqSFCJeI/3IOIbPm2tNisJ7gUX20SvftL7WqhIn/W/Z7yan4/ajNgjlTcqtb/fYLWIA8kNh1s6azBQjxFC2F73iROdX0NkQPQuptmiNcJPMzYJE7f9l9kuys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 07:30:07PM +0100, Vlastimil Babka wrote:
> On 2/3/26 17:59, Christoph Hellwig wrote:
> > On Tue, Feb 03, 2026 at 05:55:27PM +0100, Vlastimil Babka wrote:
> >> On 2/3/26 17:27, Christoph Hellwig wrote:
> >> > On Tue, Feb 03, 2026 at 06:52:39PM +0900, Harry Yoo wrote:
> >> >> Maybe the changelog could be rephrased a bit,
> >> >> but overall LGTM, thanks!
> >> > 
> >> > 
> >> > No, that does not make sense.  If mempool is used with __GFP_RECLAIM in
> >> > the flags it won't fail, and if it isn't, GFP_NOFAIL can't work.
> >> 
> >> So that means as long as there's __GFP_RECLAIM, __GFP_NOFAIL isn't wrong,
> >> just redundant.
> > 
> > Given how picky the rest of the mm is about __GFP_NOFAIL, silently
> > accepting it where it has no (or a weird and unexpected) effect
> > seems like a disservice to the users.
> 
> OK then. But I don't think we need to add checks to the mempool hot paths.
> If somebody uses __GFP_NOFAIL, eventually it will trickle to the existing
> warning that triggered here. If it's using slab then eventually that will
> reach the page allocator too. Maybe not with some custom alloc functions,
> but meh.
> 
> This f2fs_encrypt_one_page() case is weird though (and the relevant parts
> seem to be identical in current mainline).
> It uses GFP_NOFS, so __GFP_RECLAIM is there. It only adds __GFP_NOFAIL in
> case fscrypt_encrypt_pagecache_blocks() already failed with -ENOMEM.
> 
> That means fscrypt_alloc_bounce_page() returns NULL, which is either the
> WARN_ON_ONCE(!fscrypt_bounce_page_pool) case (but the report doesn't include
> such a warning), or mempool_alloc() failed - but that shouldn't happen with
> GFP_NOFS?
> 
> (Also the !fscrypt_bounce_page_pool is therefore an infinite retry loop,
> isn't it? Which would be truly a bug, unless I'm missing something.)
> 
> Ah but fscrypt_encrypt_pagecache_blocks() can also return -ENOMEM due to
> fscrypt_crypt_data_unit() returning it.
> 
> And there theoretically in v6.12.11 skcipher_request_alloc() could return
> -ENOMEM. In practice I assume this report was achieved by fault injection.
> But that possibility is gone with mainline commit 52e7e0d88933 ("fscrypt:
> Switch to sync_skcipher and on-stack requests") anyway.
> 
> I think the whole "goto retry_encrypt;" loop in f2fs_encrypt_one_page()
> should just be removed.

Indeed, fscrypt_encrypt_pagecache_blocks() (or the older code it was
derived from) used to do multiple memory allocations.  Now it only
allocates the bounce page itself.

Also, the intended usage is what ext4 does: use GFP_NOFS for the first
page in the bio for a guaranteed allocation from the mempool, then
GFP_NOWAIT for any subsequent pages.  If any of the subsequent
allocations fails, ext4 submits the bio early and starts a new one.

f2fs does it differently and just always uses GFP_NOFS.  Yes, that
doesn't make sense.  I guess ideally it would be changed to properly do
opportunistic allocations in the same way as ext4.  But until then, just
removing the retry loop sounds good.

- Eric

