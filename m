Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E4AC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424856B0092; Wed, 19 Aug 2026 02:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6D56B0093; Wed, 19 Aug 2026 02:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295B26B0095; Wed, 19 Aug 2026 02:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 009D16B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:46:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 549858044C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:46:55 +0000 (UTC)
X-FDA: 85117086390.05.025AC3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 97DA02000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:46:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iq3RJ4x3;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122013;
	b=xABDA/PRR5OXQgj2OVfkZ4Jib+C/delHVpxgKQR2qESGZ6Mhizii09jRBLd07mlAw1TY2w
	7nYUFmNja0Q572S4Ya/L3rgEAmYohGyEyuelqlIqL2WmVfaHnpLR3nIyshj/YoyATtLxvo
	70Evh7E/jglnHevlPqb3TuF31S5BclQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iq3RJ4x3;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6amBd88qdRH+SsKUpHOPbhpfzj9SJOQZq0zj/mskebs=;
	b=CmCSuIU+Nv1rk8YyKEWpJqvftZ2dqPZ5APay5qHRGJeSpW/6a7cY6fqHMvSY/6Oxha1eFN
	yibOD/kkxbXRqlZcLBXKmkDCw2n9s3RDsXHduMxYGzhsIm7pl5r0GuagpCleGIPYhNudRq
	bRaO0H9xOUqFpuiA2phcpugF8pFbo/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B8A6413E2;
	Wed, 19 Aug 2026 06:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09511F000E9;
	Wed, 19 Aug 2026 06:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787122012;
	bh=6amBd88qdRH+SsKUpHOPbhpfzj9SJOQZq0zj/mskebs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iq3RJ4x3BESaSt3EwMg8lKDJ9TzWuDwmDxda23HclYZYpF7G4+gFvA6QE31C+6TFg
	 uubaWKu6DbJ6bZqY1aXLYdMt70Y3lfU+8QROfGMQw+00kNoCw+kjFpBvFvjUpJft5i
	 8IEoltZRyUpM20kYv39rlYw6tUUZLcpR+FWzXlQl5J64o8IkcDv632u9V9TsJeZ59D
	 kNXYGIsSVhK94ikA/Q92KQuOwY5Ol8iJdzVczOWCEPUJvk7lf7nKVdgL0myCAx1sfF
	 jE/NJf6IKd+MOKBeKSz0tjWNVDFbN7qj6jRrxuMaYwhR7o9hH8C/j9MzJGZ9v20WMa
	 WnK102uHjrDqw==
Date: Wed, 19 Aug 2026 09:46:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Foxie Flakey <foxieflakey@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-ID: <aoVRVglumjOhDKKX@kernel.org>
References: <e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com>
X-Rspamd-Queue-Id: 97DA02000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1fjkjzem6nsajt1brmm914eepoyc18fe
X-HE-Tag: 1787122013-38400
X-HE-Meta: U2FsdGVkX1/3FWEoQtpv4n5kFcPm8dZlRV16d4Sm/7juPjhN7SVLfWjSQyZLq4iiucXtu5W53dCuoeCKtn64EaiG2T2uklD38yn60Tjnom8Pn4QMdyAlRycZt9ViuoC6JecW1v9NuYkd7xvirULWWklQSowYI7U/G6YN/NQWhmHBR27J6d3KcN7u3q8Wk9ZF/LQ3HjLOggfWCOwb+g2gdSP0zzPqg10MFr/skWgUcA9t/gq7HnqKd0cUxd3XjfeW6W+5v0DxKCfd9oX/rybPWTf1WJo0G7WdZCS7a1xQczl8Xg18AuXprQcz8H0eFshkKMu7msZGLmji/1Ai7UzHCuyNwi+7S5dLcErcR3G0c2iEvBJ81nO9JibJLHl0qwpIt9h/Ay0NmUNvCiW8KCrTf6JElrXC6se3HnqrVgMpdkf3OfxJWzRNVBZokMv7/j4cOVTAvotLf0MQzpmJC8spq3cp83gz3ULdr24bQnJeZDpsPhjvbK9UirL7MW2uPkOK+D2trixYsi0ane/pHHcOtw1a8TYlbdlDShdFGgAcojYciJiYeppWztRzjvmBouILOYwVDkbCtBpkoNWMsw0xwZR+YT6hAVj1+YDRWb7ysOFcNF3Y4XNLtpWJNUtV641hFac6dz7k9Y887Xz/BUcmMtHRPn0hSRs/TKSgOem2ZPHNCUbVx0Gh9gZ7Y8iEMMkRQ0BmqSrW68w3EMxS8NOSOCWl79AN57WzRX3tXMrJj9flYMH+HLWhlfupae76xXBQrAJUS53lgipcfbIlF/XR1AOXS/nVZ3XO7NFyhK6M2ck/ccs0DootP22PVfChMhMGUaQhhpG3E1+Ic0c7pGP0eUplFSBGxVw8Sk00BQiiALN+2EzC+Bz0LUUIHIfXCDgh/pmFnUvgMFp0mLN9fupcXzdj6aG5MRjsdtThhpOJ1Glf+6QIUYW3xfWrckIvHRUusJ9OVO29R/fPdXjOHIk
 23EnXp5S
 yMolveuVgC5p93XgOtERQCqrlYyXqjXT8GFB9+hX3gONPVNL/Np3/ic2EuN51BkpairTRkOFyHukug5IMyD3GsWyYYM+2r9Q8SlXwZ9lp2g6R2peEzp8aLOY9g6cpbgy/ztu5s9L7QXdR4S5dEO8AwHqTrHFQls3BbzWiW+eFAFblsATTSGKIg+aQcuqUqhSNI0G4biRjWeUC4cPiZu7iJl1UyfRRO2NV/xuXqIlNJV+M7GzKWaXL3C3VI3VSiIMR8Fg5yF1io+m+ZzMaCYOv8rmZ5TxAcQ+fpaHwm1Mr1do3rtZmyDkSo8AUtxJ+FgJO6zvcvxj7apF8CELNb3ZQlIZu6y7oJ+zYerzcY5y1zPB0Jm9tTT7O8CIBjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Foxie,

On Wed, Aug 19, 2026 at 10:08:24AM +0700, Foxie Flakey wrote:
> 
> During move_pages() operation, when move_pages_ptes() returns EAGAIN,
> the error code is not cleared even after we processed it. This leads
> to a successful retry but then the same pages are retried again due to
> the stale error code. This time move fails because pages are already
> moved, loop is terminated and move_pages() reports a failure.
> Clear the error code once we processes EAGAIN.
> 
> Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> Assisted-by: ChatGPT:GPT-5.6-Luna
> Signed-off-by: Bryan Lim <foxieflakey@gmail.com>

With the authorship changes that Andrew requested

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in v3:
> - Updated to use proper sign off.
> 
> Changes in v2:
> - Updated on description to be easier to understood
> - Reset err before retrying, instead of fixing right at the move_pages_ptes
>   branch.
> - Added Assisted-by, received an answer few days ago from linux-newbies IRC
>   that even I just used AI/LLM as "fast path" of git bisect. I still need
>   to add it following
>   https://docs.kernel.org/process/coding-assistants.html doc.
> 
> ---
>  mm/userfaultfd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index c3adedaaf7d5..ec5d511bd179 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  		}
> 
>  		if (err) {
> -			if (err == -EAGAIN)
> +			if (err == -EAGAIN) {
> +				err = 0;
>  				continue;
> +			}
>  			break;
>  		}
> 
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

