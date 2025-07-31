Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68641C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 17:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20336B008A; Thu, 31 Jul 2025 13:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD11E6B008C; Thu, 31 Jul 2025 13:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6006B0092; Thu, 31 Jul 2025 13:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C17506B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:58:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EA9D1609E7
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:58:34 +0000 (UTC)
X-FDA: 83725319748.28.537DEA9
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id BCB144000D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:58:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t1xK/czb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753984712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbCAFN9BJB3ZOi4JNeNZED8yVCL7XwQBMtX7VxroTCY=;
	b=f7s+nBUqJ9KHU3LgS+kxdNTN1vBma8rlcNZClqFWLeeQUGEdLs68cjF7MrGmONgwjJTCdI
	MH7Q7Fk7QwwPK+zzbHgKI0lQe9ej2RuR4jTiJO3zQejV9dQYohcb3pKzYfaYL0fzlezFPY
	k2lDKYL26FKwTv1G97Nl1Yd9O4Kg23Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753984712; a=rsa-sha256;
	cv=none;
	b=i97/EvMx+4u7n714JeQSnuDcbZ29lz8s5yBp0f3dOhJem6bYBOqfoZ1sNv9SQhOrqbKcmu
	3pyoUpQBcgKTYG4Kvpk5stE4c3wg43aHNgR6uW2J1h1NUOr6tibFWQ6kishgXQRBisYYuV
	452hCfar47m6b8Vlfpt6C0aIugisITw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t1xK/czb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id AF8115C62AD;
	Thu, 31 Jul 2025 17:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8C0C4CEEF;
	Thu, 31 Jul 2025 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753984711;
	bh=3Md3e/uSIQs0aF7CCYWxANDDnjRBzUvnUohCGN3vc4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1xK/czb/C4PFt3IF1V0vOT65+aZYuahcyp+0/buONZPYGyIZ5ROEQzIWjRtHfzko
	 HJ27jmAEDquL78HdnaGa7HtlRrDzuxywd4EAxm+4J3UvnSoTrDgUUHr/G9Y53sCPxR
	 UIdR7Uknw61s1xFywlHr0weNZIeDMakB6PYS+PhZ5Ac0pJKY6wIX14POYgyYZEUTBs
	 YkiWlL8/PGM9HnRu0QdSg1Fp7d9Gej++fvVgMVrMGfzxVMakvCzNJJagocHCqIl/sc
	 Lz8P91FvrnqjAX/jC6gpQUQZ2R7OnTeomvpnVt6tl2n85hyrCxKe1nbICyjAgMy9mY
	 ne9nPoj7x/Fcw==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Date: Thu, 31 Jul 2025 10:58:27 -0700
Message-Id: <20250731175827.16060-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731132230.80046-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCB144000D
X-Stat-Signature: qpas14x8dth4knmiycok7x1b1h6tyzse
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753984712-253381
X-HE-Meta: U2FsdGVkX18SEdn/c03qmkVbhxOP8QUEjTqHISMBQZtoVGPiq6Ced0MvGa7TtdOl9yY3iQNxIkyMuLaJbKYNwEXgTxmrE1NxdlezWTezwfTxj4dSSf/FLnxrkbgZFXOyrqCTqe+MEO1nGw8sfdJsO+YSqRs7YMqYEn7ZG79jstN+A8/0lNHAkaPmRiyqhmPQzk//iUN1ScO7ao1NA3oKZHlJDyBtFrIvq+FU/f0HYjTBTWAgWPsLemP4SCs4C0yNRJh3UFdlr7Tf3Yn83BpeXHt8rUjGAu4BXgyp5Kd/E7CArn7u0swBDd/jePHqbSXdZRBnV+8ajhHnAZ2Y5j1mYmbzWEB6uY5vkfKHANet4qv3pllkk54gV6aDOPUsJIglbEi8pgXcxSLNR3efKFhi7WKwQWEYmUp1LFaX7wQUt6fFSMjTh1pxo+b9XM3oyyyroTgfYxnZuv41C9VUiMsfnuTdoDeTFe4dzXn6B1LVRLI9A7ewxpSwHhNDJfRTYgEnKwwBClVx0MI9wgqQXa7EoOrAAmjI6fuqACzRa3Wyz/LyoT6wxvxeUD+TqkJg5bdIBfQbM1IKL260+O7nJt6KzyIkbHSPMkUwodnju/Iq3LRArSlxRg+hNmWEChURr48HiQMGPuXjkYBNej+gGlaZxhHgMZdJzrln8GC8sEjP+2fY5SDKvM35jfpTn2B5FL6Ubw7+/kthK4ZxFVd7glYBZOCPUOdGeBh0XJqTT0UI+eXIzbTkh5IFE3I2Mgr1dh+5gGl5R/TQItnKSYlA6k7r/5mPUV6MuoGdw+Xau3DICxx2InoE/W/TIhJxxQcskiGxy0wDtGqfnOIIHRYOhYZsS7oNvnep1kyi/R652M6p3a23YpxQYA4djS7nKTc6K6ZmlgkOh1jDizkGmUBpTgVCwJlpkAr6OW2yoDU208Gc8HkRfje7BJi6Lm6/N5qaAl4bCs/m2/LEwW1fkwpADEk
 dozf+zgX
 VzI+3jYXQuOm6Xg3Hi0w7EXG56EdKAdnkpqfE4kalrXmy7M9kOMZ9WxooUc5+oA4xxwCep2edV0fiVFK2j/8Z2NQ/mEiJhVc3stHaxFEoq4PeHIjrKkM66edoPUFm3ninuRnTEwUuM28CSVKM+kgEv0CD+ma8a8ZzJlGusx3fM4vs8eeNM5IZTxQtIAtqkgqhvCBLoISfqcu0P4fYSFrH6+nOnnQGH92iKb1pLpcjzQE7xSDf3ErQDkoqNeA5f1dQ/IWnQ8Kxq9kLmA66v9cSch3kITEJdgV5BoChA7OuPKdD8oGzcElrrJn+3HH4D9CuiGxnzFsQZPQzQ4K0tKYrOa08wwAkTdkT5hqJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sang-Heon,

On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Nowadays, damos operation actions support more various operation set.
> But comments(also, generated documentation) doesn't updated.
> So, fix the comments with current support status.

Thank you for catching this and fixing!

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> I also found below patch(https://lore.kernel.org/damon/20250730200239.60984-1-sj@kernel.org/T/#t)
> So, Is it means that DAMOS_STAT is only supported by paddr now?

No.  'vaddr' supports DAMOS_STAT.  The patch is not adding DAMOS_STAT support
on vaddr, but extending the support for DAMOS filters.

Thank you for checking the thread and asking this question, though.  I see this
as an important signal of another rooms to improve on the documentation.

> If my understanding is correct, then we need to fix Design documentation
> and comments both.
> 
> However, since it will be fixed soon. Keeping current status is also
> affordable. So could you check this point as well? 
> 
> ---
> 
>  include/linux/damon.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index cddf82eaac4e..0870e9f48b0f 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -128,7 +128,7 @@ struct damon_access_report {

Seems you are using damon/next as your baseline.  If there is no real
dependencies to damon/next, please use mm-new as your baseline.  For more
contexts about that, please refer to the DAMON maintainer-profile[1].

>   *
>   * @DAMOS_WILLNEED:	Call ``madvise()`` for the region with MADV_WILLNEED.
>   * @DAMOS_COLD:		Call ``madvise()`` for the region with MADV_COLD.
> - * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
> + * @DAMOS_PAGEOUT:	Reclaim the region.

Nice!

>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
> @@ -146,8 +146,8 @@ struct damon_access_report {
>   * The support of each action is up to running &struct damon_operations.
>   * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
>   * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
> - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
> - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
> + * supports all actions except &enum DAMOS_WILLNEED, &enum DAMOS_COLD,
> + * &enum DAMOS_HUGEPAGE, &enum DAMOS_NOHUGEPAGE.

Thank you for updating this!

But, now I find this place is having outdated information that partially
duplicated with the DAMON design document[2].  I think the design document is
better to maintain this kind of details.  What about keeping the high level
information but giving a reference to the documentation for details, for
example, like below?

    @@ -143,11 +143,9 @@ struct damon_access_report {
      * @DAMOS_STAT:                Do nothing but count the stat.
      * @NR_DAMOS_ACTIONS:  Total number of DAMOS actions
      *
    - * The support of each action is up to running &struct damon_operations.
    - * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
    - * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
    - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
    - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
    + * The support of each action is up to running &struct damon_operations.  Refer
    + * to 'Operation Action' section of Documentation/mm/damon/design.rst for
    + * status of the supports.
      */

Thanks,
SJ


[1] https://origin.kernel.org/doc/html/next/mm/damon/maintainer-profile.html#scm-trees
[2] https://origin.kernel.org/doc/html/next/mm/damon/design.html#operation-action

