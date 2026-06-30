Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E90C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E9D6B00AE; Mon, 29 Jun 2026 21:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEA06B00B1; Mon, 29 Jun 2026 21:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3A56B00B2; Mon, 29 Jun 2026 21:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83A5C6B00AE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:00:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F6E9A033A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:00:44 +0000 (UTC)
X-FDA: 84934774008.26.4A83075
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17ABCA000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:00:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMjCj8vm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782781243;
	b=FwRHsPs2DU+sVHpZXe+JAWpTxg38KShaUBFpMz1IsjWh12/U6cxsAS7Rjo5gVWwjYweezB
	bCZF4ebC7depjnCUl/5+ymxKfmLGUf7iQm9lcqy7SrgmctY4AOGIyKQZr7z2+XJC7C52/7
	Lf2ZTafNSo5a23B3BAyR7brcdu1EcPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782781243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scNnJr0jcGc+I8Ey89cgibghmaTHBbkbZ3uJtZ4Ysls=;
	b=fiov/kC2Cqeb+T9Fh8wXzgq4D78KJTlDFrgZAPeNH3eYEpR6WJXJBK0DXoMoSF7dddRe+W
	V2B5gPo32bGY4kk7G8Mnbiv87B4CQQ+0wIwshStvgZrM6dUZZ4Hd8eoIGrTmwS66IWUrnY
	9mQ79HZsjQ9jf0XqtGAuhFTcbG46olA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMjCj8vm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30E9241424;
	Tue, 30 Jun 2026 01:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC49D1F000E9;
	Tue, 30 Jun 2026 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781242;
	bh=scNnJr0jcGc+I8Ey89cgibghmaTHBbkbZ3uJtZ4Ysls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMjCj8vmTGMiEd6DlOjN+Y2aaH5NimELhZqNChgYdwJgOvY4OgK/i2XMjYRetaipF
	 KmaJxhyyoZkkwBFBkYY0ymUjP6vUhPz5qEswXUI60vZzOMWPrzejeHotR5Sdi2NSm/
	 d7rmm5r8VhuBAjnXlfani90BT28mhqSDRRV6r7Y2puL53IYxDLo0fJ8iRzErtg4NCq
	 XyT+0pONtW8Iww5Gph6rKCE/+/QFk8xb12BhA9ITQcy55IUxTUlNkoMYYn0AYeclgb
	 27T2nK7TDHwrVjC1ORiWKmOWGESYOyKeHiM3nE3Yc/6pRMIJand7SRPhG5nFcuCYw/
	 xxFQ2FJ8uBIxg==
From: SJ Park <sj@kernel.org>
To: IgorpetinDev <igorpetindev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/vaddr: remove redundant RCU lock
Date: Mon, 29 Jun 2026 18:00:32 -0700
Message-ID: <20260630010032.141941-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629165349.4260-1-igorpetindev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17ABCA000D
X-Rspam-User: 
X-Stat-Signature: gjsxkk7wjdxrmfx3wsf8xr4yijatbcbw
X-HE-Tag: 1782781242-915301
X-HE-Meta: U2FsdGVkX1+ojx8Pz7sxGhr1+zij8a3o4GMrhU0zFlRyx7vsvdq6NsrVGvNdi1UeP7oGGBBSjSLCoejnBoEH66ZxQZ1xT6fo0m4NwWOhsiIAToWpQtjGMcqayW/g5f61jYPf6DU2wcfPLdufpf2bmpr6lHStgS3Q2JX7OkaUChYycirou0xhlWZuNEXmO0lr/vp9f/ovtD2nrGLKB3WfK05x9qtBrVLrFfqeXTIupA85OGVte298UfcVgEMcQXuKq9DlVv8XFdv1UBmQ1KxLD1MFEzhq0NzObrFPguOsUkj0XO+wO+CJrmu/Khaxtfmecv/DUj3DRzMSSTmmxYnzfRWGHtxEZyZTky/xL90x17zl3uWoOnUixW05I11X8HHhFKxp+lFk0QuHwasMIQtXqWwgtfX74pFKScm4US+licQgcm87os+zmaaV4GF39i1m2rVG8gi/G1Cp+qEOnYXn/bvD2CkMRjVTdIo7p2sdl9IqfPfLPPshhKcBW4xRVDw2lSYtwR/z2CdBsd8If/5eXFSaQ6g76krL1V76X5+OkKPffaqEJf9+G3zOCub/fDyxAErmDEx1IH6gq2A15Zdo/7tm4L/Z6tJs9JAsX8I5BBdNMieo6ikUY3VgDlGf8nZvFwBWF8XXdCmBbbbrSrE53Ot/mH8KeqnIDgpiOJ0Z6GnoBDsVdiWGLrW8wX1hczUFCfAUbqZGIIuwGPsL1EWXSuR4lze/OmH/GzrTAfCRwopuDaPXNwQQ6rQ5yuARStxZB41QL4cQZ2tObUnu40iW+q8tQvE+iQumBK3d8r9siotGQHDZNQz+RR6fwfDEHNA/JQqep2qgbF41y8QG6wPB6FykoucytZ1ayoz01f3+4FV2vFQ3wPI4wDHUutty0cNRXO6BkCvc9sUrl4Iskoj6MjBtlNRjAruN5gGPY6DfnO8TdjI1McjBaT2q/xPfvtGYgz0b1Mr1AaIs+ZSD37w
 k2R+YndM
 7LffejNNZq2Q5p69WRX+dNApD1muVny2gqpEoHiqjGCRrCNldbEoauNuovb18fn+5uWatgloLFNAcBl7UGte89I1ZgeCK5zdMsRHhwrLKMQgXQPOuz/3F4IW9M8pZfTF1zJRqfG6C8sFcZyHFYebO9doo/fGP7ePFudW424rF2uk069PcA973IWoWXjjm5i+fbI17VNz0W2hCnO5lezTnDyG0/6Yvvj4TAqY+TBf+Sy2fJc52dtqN56U7X5z3Jh3KkrlN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 19:53:49 +0300 IgorpetinDev <igorpetindev@gmail.com> wrote:

> __damon_va_three_regions() is called only by damon_va_three_regions(),
> which already holds mmap_read_lock(). Since mmap_read_lock() is held,
> the maple tree and VMA list are protected from concurrent changes.
> Remove the unnecessary rcu_read_lock() and rcu_read_unlock() calls.
> 
> Signed-off-by: IgorpetinDev <igorpetindev@gmail.com>

We prefer using a real name.  I show you used 'Igor Putko' as your name before.
Any reason to change the name?

> ---
>  mm/damon/vaddr.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index d27147603..345b89b5d 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -84,7 +84,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
>  	 * If this is too slow, it can be optimised to examine the maple
>  	 * tree gaps.
>  	 */
> -	rcu_read_lock();
>  	for_each_vma(vmi, vma) {
>  		unsigned long gap;
>  
> @@ -105,7 +104,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
>  next:
>  		prev = vma;
>  	}
> -	rcu_read_unlock();

As Sashiko also commented, this may cause lockdep warning.  Actually this was
added to fix it.  Refer to the previous discussions [1] for more details.

How about moving rcu_read_[un]lock() to the caller test code?

[1] https://lore.kernel.org/20240904004534.1189-1-sj@kernel.org


Thanks,
SJ

[...]

