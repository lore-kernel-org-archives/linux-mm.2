Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B44C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80596B009F; Mon,  4 Aug 2025 12:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30DD6B00AB; Mon,  4 Aug 2025 12:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FAF6B00AA; Mon,  4 Aug 2025 12:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0B206B009F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:50:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56C671404FE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:50:11 +0000 (UTC)
X-FDA: 83739662622.27.4DDBF0F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id E81201C000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:50:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+ghLUCQ;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754326210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g77K/k2ZlzwMBJ9sIwqXFz7QpaClNeq+jAIUfwAsqr0=;
	b=SelifgaydfIX2cNkM0Ke8pLG4ZyPxJYfznVRPSg9UWmN/6uHVO8cqrkbCGA8Dhz8OaW2UJ
	YGE1YciLxWfD3J5eSnwaHWpxiUdNTi4luYxlAf2SzdnRBOGaeTn1z4hJCJktpBDI3S2316
	N1PE8xYRFuGcGOLQTxLjis9fN4T9nuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754326210; a=rsa-sha256;
	cv=none;
	b=oWwJVSsv1YhKatXT+k4Af1pNpne2YzpBYqfvxy8aZifh/JB9Tw6ahc3iLfbTPYLNR47xTH
	t3hjxJpA997Fe09fp0/Vi07/hA09BAsQh3Oe+YLSEuMB9osRP4cspdQnh9VltVjsNXm2XP
	umrq3PYhhvGH31OdsYUqtK9t7La/iy0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+ghLUCQ;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 0BC735C617E;
	Mon,  4 Aug 2025 16:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC2EC4CEF0;
	Mon,  4 Aug 2025 16:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754326208;
	bh=sg0wfArUiS/J2z/NCTuR83ouoFn/ZziZYXoh92TMywU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+ghLUCQ+qJwZ4D5IndILpYS01N4bUrHZzAjpzxyZE2JN2iF50lUI2vCvgbzu0M5y
	 tA6dQ/3h34P0BzgjGG4v+bM0zUnBXI/XRFyN4qpD9Ul3ofu9NwiIGIeInbJVOt6ay9
	 W7cmqWOqiIn0aos99FWXRCkrmeJUUq1ZxsW+xgJtTmT0vINFOD04QJc+UD7QWB3Czx
	 eBg9a/gWT7PoI0wC0/ayoNkTU1PvKfo/4QjCte5Pcz1GFGHaHjoBdYcZ6EaneruqEH
	 FnRcql5Gl8VQ0BdNr5lACOkvZwg0RDHdRmP8Eo9hj2m/sEvRSVSS1I5tF7K/uYJtcU
	 KKm7VE3nlUC4g==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: update expired description of damos_action
Date: Mon,  4 Aug 2025 09:50:05 -0700
Message-Id: <20250804165005.55515-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804143816.29654-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E81201C000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: u1nsk8g8qyc4tuwej3nqyb18o9nikm1e
X-HE-Tag: 1754326209-263151
X-HE-Meta: U2FsdGVkX19YpFx+O0NgsbFUwfJnkwHCfFnTP1MIPjUWWXGRA7PS4fCYDpT0xFN9hXKn09Q3dT2Td6UVr2i08SY9SiusIfFI7AD7PXsivTGxx3BqpMTT7tByBNnT/+D9/+tkUflBHZaTnKkhy3UjuoCXid024NpqYhqrM80pZTwjPGi/SfDk03Pp/wvtVnI5jUuvymTCUUM9t3fG0WuRCUnm+g1qa8lBDwdUyK0F5PC7aaavRYmEJMsi4UPuTpkDMH7aAH+W/4jeAn0Ro/Fhk6sm0p5KRbF/uZKNS6AaYfGeQebjgT3TTFwRewpxEe39fUphD21OFVjoFd/ujrv56w+A0ONClaanX+vzfNNNvJg4Rmy3aiHXbSQPFELXQDIujxl6sqTcRTqcgozCq0houwWzAdbCEWCWsh5yjjmfx9a2NdJFGGh1ErnxnSiUKIV2kEcbUsAg45rTGmQyvm6cLiUxIP1EEKstkOzHmO20igKReXcOD9jzcRw7mUNKR0uzwekiu4VzCrHtlT6K7ReoUf9IRGfidV7SWNGCnB/6b2jVlUvUd3I+EmPJzYJbAcPxGfgi6BP2C4EFROCXem1zPQPr4L+CI0uwCISOxNwyv6VJHuLMTkZakCFdHrgWBhw5DGz16MrL4SijuzsGpMFTyIaq5plEY5tfhkw6rU9qAbN23wcNtpAqnBxY850dK04Osa9KMlZNoFd6GXob3Zm0R1NmnizPLzdbWoeMRvGunjATZSy3SoekNz2uA9FswtrkS7VPbApP4IjnIJeEDgJf7fe2ZTg5rzE9DFKzjWrKmosZErhwpDjQkMMl1ZMFzJIFC/gEJceUYG8R8DcZx51VuoGCsaRSIQjpfrIgHwDHu5W/oXr80QgMrLi7Uqf3qGU3Cun4i++3MCojCJtf4eGDNuyak2SJO6QTrMNxGGIoxA0MpKSluVoom80oFIj+WopfQKckDFVSW9M90bAAHqi
 1ayexDCw
 faj1g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sang-Heon,

On Mon,  4 Aug 2025 23:38:16 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Nowadays, damos operation actions support more various operation set.
> But comments(also, generated documentation) doesn't updated.
> So, fix the comments with current support status.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> Changes from v1 [1]:
> 1. change baseline from damon/next to mm/mm-new
> 2. Add note about DAMOS_PAGEOUT and demotion.

Thank you for making this revision!

> 
> [1] https://lore.kernel.org/all/20250731132230.80046-1-ekffu200098@gmail.com/
> 
> ---
> I also watch your comment from [1]. Thank you for not forgetting :)
> 
> [1] https://lore.kernel.org/damon/20250801233942.1614-1-sj@kernel.org/
> 
> ---
>  include/linux/damon.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index f13664c62ddd..d4b3ffd6144d 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -110,7 +110,7 @@ struct damon_target {
>   *
>   * @DAMOS_WILLNEED:	Call ``madvise()`` for the region with MADV_WILLNEED.
>   * @DAMOS_COLD:		Call ``madvise()`` for the region with MADV_COLD.
> - * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
> + * @DAMOS_PAGEOUT:	Reclaim the region.
>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
> @@ -123,8 +123,10 @@ struct damon_target {
>   * The support of each action is up to running &struct damon_operations.
>   * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
>   * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
> - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
> - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
> + * supports all actions except &enum DAMOS_WILLNEED, &enum DAMOS_COLD,
> + * &enum DAMOS_HUGEPAGE, &enum DAMOS_NOHUGEPAGE.

I think we agreed[1] to add a reference to the design doc, instead of keeping
this duplicated.  Am I missing something?

> + *
> + * Note that DAMOS_PAGEOUT doesn't trigger demotions.
>   */
>  enum damos_action {
>  	DAMOS_WILLNEED,
> -- 
> 2.43.0

[1] https://lore.kernel.org/CABFDxMGh7-vDgNzepJKtrhdOF40_U7=NT6Jvm85qtdwGpBZawg@mail.gmail.com


Thanks,
SJ

