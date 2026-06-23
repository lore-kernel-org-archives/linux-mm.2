Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E0D7CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9006B0088; Tue, 23 Jun 2026 07:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79AB6B008A; Tue, 23 Jun 2026 07:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8FE96B008C; Tue, 23 Jun 2026 07:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1866B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:43:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 217041A04C7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:43:40 +0000 (UTC)
X-FDA: 84910992600.13.5E7F754
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5E59B140003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:43:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rw0wY6tX;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782215018;
	b=Wrly05uvbfJUiYYkISmwfjTlxg8DBKM4juiEJGPOO0qoVTQQyWMLDPW395oZy9jiOxq7R3
	7ttgLdfk2Oj3W8neJsF466nb2VXmuJCMgfRNygqFWjQ4C9XaD8FbT4nV0uyTVGcJAe4bQG
	FN0DAtbVouLNvCFRK61RsVOQMp894us=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782215018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIYLLXEdXx7L4o6dYJYDdrb0D5HpwPqotDGYXKoVR5s=;
	b=2g1SGSg3KDwFkCvWLZwN/3R4WXstPr3vwVszZwgey/Zq2wQwWXHm/CLCAWRglCQLawm8om
	17Jn1rPTaLELkL+ypRpti+cK+u1F8dxm3bs796xQF83M88a5KEE2sHWxGReRorBZaarHCk
	YiWSABkcqOy821z/mPjLYgqOJtDal40=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rw0wY6tX;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F99B41722;
	Tue, 23 Jun 2026 11:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99F81F00A3A;
	Tue, 23 Jun 2026 11:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782215017;
	bh=MIYLLXEdXx7L4o6dYJYDdrb0D5HpwPqotDGYXKoVR5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=rw0wY6tXv+5a5BRQ63p93wABtbFhv2RtKPXr5/x5aQ4PYasTgBb/Y9xDHp1xkp4zk
	 N3CLzRvVPAYdvGj6Fv5XbXutveX54MBQsEAJE7CaAEnYDsbdedNny6QTxLdg89ZFPJ
	 JnQ49sQlBZuFEglkXvXApvgS7ZIuKPiTuwtYrb/I=
Date: Tue, 23 Jun 2026 13:42:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Xiaobo Liu <cppcoffee@gmail.com>
Cc: rust-for-linux@vger.kernel.org, ojeda@kernel.org,
	miguel.ojeda.sandonis@gmail.com, akpm@linux-foundation.org,
	david@fromorbit.com, qi.zheng@linux.dev, roman.gushchin@linux.dev,
	muchun.song@linux.dev, boqun@kernel.org, gary@garyguo.net,
	bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org,
	aliceryhl@google.com, tmgross@umich.edu,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] rust: helpers: move list_lru and task_work helpers
 out of binder.c
Message-ID: <2026062302-girdle-entrench-11bb@gregkh>
References: <CANiq72=sSkApehxg6eEpAoNU8zSsRAfqD+RVymM3UQGuvfKyeQ@mail.gmail.com>
 <20260623102431.3577627-1-cppcoffee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623102431.3577627-1-cppcoffee@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E59B140003
X-Rspam-User: 
X-Stat-Signature: oiyp11954gjbjiw7pkfemu9gfa3ciri9
X-HE-Tag: 1782215018-316911
X-HE-Meta: U2FsdGVkX1/9mccu9p3TLEZNTyKaVU6eef6lixkoKpRGSvJ/3oGJbkxnp90xTHNgcEzV/nw4FRyF5AZ99QX/Yqb2HNtXBTvssBZwiTgpF7sG0nuDYjLcZ2WxDiSnbb5Z53k5YbFbSpqxFpBBfrKz2WeCrjUT15oj4eM9ihTCGJFPR1xHGjv7tXKUfOp1YmOPpKCjXlW5249vSvjSwxshkEn+Vi6xwG3WuCYJZnapfTjdI6hKH07atkTQyfEG0qV1vXD1rYNQQwoi5Nec/p7ATzGfgJ1TsAO2C7VbDCDfod/SGirfFjd+i3fzVDRtMFpJT8OOlqA/sWBYqw3McRcRS8GQ9ciQ+B00Bj6SzKQX4IHyc88N1Gql84YMZQ5JxhQ+irTXVUEYm9HeQwfQwTPQYb/q7plOTRYLb4FvzGuKdRSut8W3jDGmG1+EQRzBxoGcT6wAFbqYDVfYZDk49q2VSzeWFKSTN3sN1y01jPmdnvOH9tL/Ww8c8QhbSV0Ashtm9e94ahNanU+/uItPE0DGrLyHR2a60C5I5qQIqX4J3AiS6wCN2HOYmvGtFofrUs+g64fM4eJF9Q5rhRgt3m96BLv+ZmnxTJDNMgHxJL9iWE6FcSKwJxzqejIcoIlY6QRL/J8BNgRzc/QiQM8WSnz6cpoZGeYMwShDy04GfaJn+q4wDyjoQVAY8YdPVMvTfsUjO8gUF8LlEo5mNCeHYkYb4KGqYqBzwZ7ad2PzNYgNmps35htfeAVU62SRvEwvOIWkdn0m3rDscYdkSD+0dcB5WoSy+bXWbuiBYWzjiJdoDRQ1OdRpXIG0Zb4AtYabYYFK81y+nS0jXNLGBJ18+lrwQG6J6WWUp4PrFA3Li2Ok/Diyn5Sd5YAC/s3LYVrhBXrYGJUWMYvj6xvz68KKjicZzobP4zB7eY5x2S1CEV8P8TxXuc93sFL71NHY5dbtjRVg1gnqxu4gsPcju93qvn2
 yCYgsYka
 aUqyUrK/ynOvlDZ+6ve/DrnjmyLQlVchrOOqRBvdmMJscqH1eW8Y5RIRLB4roXP+M55s79akg7z6BgsbM/Ff4WoORYBEpEy0Q7PgwEGrBxim9sIyVBYTIABHzOeMEW50JshoLJfzZlX/y4yyMUEfnEpD/x6IWKXVdpMV15+aLWyVSocmva2pz868b5bMfG1W2k3DQZaLdIYkIQ+u3vie/RKjOnV6UEPd/Ru8/pPXJdD6k6oYGn1NK1/JbkfiVMYs8/Djf1qhGnGFqura5uGaDJs+MpjE2BO1g8b+7cMlKB83uqGUtAWzsZTS6/JHmi/dGnQdyhosRLmjsVpCtMuq4kWTrmgt4f+R3MszbuAIIBv1WDGN+1htHA2o7QR5OkA5vo19xQoSROfwTxkkwsg3b/8+m/wh/0tGbU/WSINr+JywBsjP3N+aMbp2nka5qolpwRWSzmJKdOMtmVIpzAqKmAHwl5YNB7qjVKzLyLOjid3E9TwUhS+mk0yMNPiFdTe5BxIcF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 06:24:31PM +0800, Xiaobo Liu wrote:
> The helpers in binder.c wrap generic list_lru and task_work inline
> functions and have nothing to do with binder. Move each of them to a
> file named after its own C header:
> 
>   - list_lru helpers move to list_lru.c,
>   - init_task_work moves to task_work.c.
> 
> Add the new list_lru.c to the SHRINKER entry in MAINTAINERS, which
> already covers include/linux/list_lru.h.
> 
> Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
> ---
>  MAINTAINERS                           |  1 +
>  rust/helpers/helpers.c                |  3 ++-
>  rust/helpers/{binder.c => list_lru.c} |  7 -------
>  rust/helpers/task_work.c              | 13 +++++++++++++
>  4 files changed, 16 insertions(+), 8 deletions(-)
>  rename rust/helpers/{binder.c => list_lru.c} (72%)
>  create mode 100644 rust/helpers/task_work.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ba45953bb..428992431 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24590,6 +24590,7 @@ S:	Maintained
>  F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
>  F:	include/linux/list_lru.h
>  F:	include/linux/shrinker.h
> +F:	rust/helpers/list_lru.c
>  F:	mm/list_lru.c
>  F:	mm/shrinker.c
>  F:	mm/shrinker_debug.c
> diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
> index 998e31052..ea34101b9 100644
> --- a/rust/helpers/helpers.c
> +++ b/rust/helpers/helpers.c
> @@ -43,7 +43,6 @@
>  #include "atomic_ext.c"
>  #include "auxiliary.c"
>  #include "barrier.c"
> -#include "binder.c"
>  #include "bitmap.c"
>  #include "bitops.c"
>  #include "blk.c"
> @@ -69,6 +68,7 @@
>  #include "jump_label.c"
>  #include "kunit.c"
>  #include "list.c"
> +#include "list_lru.c"
>  #include "maple_tree.c"
>  #include "mm.c"
>  #include "mutex.c"
> @@ -93,6 +93,7 @@
>  #include "string.c"
>  #include "sync.c"
>  #include "task.c"
> +#include "task_work.c"
>  #include "time.c"
>  #include "uaccess.c"
>  #include "usb.c"
> diff --git a/rust/helpers/binder.c b/rust/helpers/list_lru.c
> similarity index 72%
> rename from rust/helpers/binder.c
> rename to rust/helpers/list_lru.c
> index a2327f1b3..3b88d1a96 100644
> --- a/rust/helpers/binder.c
> +++ b/rust/helpers/list_lru.c
> @@ -5,7 +5,6 @@
>   */
>  
>  #include <linux/list_lru.h>
> -#include <linux/task_work.h>
>  
>  __rust_helper unsigned long rust_helper_list_lru_count(struct list_lru *lru)
>  {
> @@ -19,9 +18,3 @@ __rust_helper unsigned long rust_helper_list_lru_walk(struct list_lru *lru,
>  {
>  	return list_lru_walk(lru, isolate, cb_arg, nr_to_walk);
>  }
> -
> -__rust_helper void rust_helper_init_task_work(struct callback_head *twork,
> -					      task_work_func_t func)
> -{
> -	init_task_work(twork, func);
> -}
> diff --git a/rust/helpers/task_work.c b/rust/helpers/task_work.c
> new file mode 100644
> index 000000000..cb961cd22
> --- /dev/null
> +++ b/rust/helpers/task_work.c
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (C) 2025 Google LLC.
> + */
> +
> +#include <linux/task_work.h>
> +
> +__rust_helper void rust_helper_init_task_work(struct callback_head *twork,
> +					      task_work_func_t func)
> +{
> +	init_task_work(twork, func);
> +}
> -- 
> 2.34.1
> 
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot

