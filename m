Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC9881090233
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2492C6B04E2; Thu, 19 Mar 2026 10:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2213F6B04E4; Thu, 19 Mar 2026 10:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DEC6B04E5; Thu, 19 Mar 2026 10:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07ADB6B04E2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:31:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EC45140610
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:31:26 +0000 (UTC)
X-FDA: 84563050572.09.62765B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54D65A0024
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:31:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cbkoqjlB;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773930684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTblAWTUi4HcbqLpRLVN4IrPvGhgnxFqV1nUkVTuy6c=;
	b=KGBLLTXSFWJsj+YyYKCnxmq7Nb/S23p1bjuecCEY9s+uUL+8hu+YZDweQkUZnyi1oUqZth
	R5BCF8Dq4IHd7u/8hbNzSK77cs1DpDUT77AUdPpQtjLangxIpB1cXHghAWSMvzfLVRsORZ
	zFSGCE4qg/mvAOzUoNjOzQQCqMUBC1M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cbkoqjlB;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773930684; a=rsa-sha256;
	cv=none;
	b=p0djlwEU8W7vw0CyT6g6QDKInm5mZAJ7USVQsz8vNOjubvjHUIX949yTxKpwTXc+Y4jTCT
	G0v3ZivTOYp2Jf5uWu2iTTLya9jOp9X8Pm7tMJc2cBJGJT+dyeC9noeUdh+01eLOVILlaP
	JGO8cH/VREZC/LOgdOMDMMGANbU1sy4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3484542DDC;
	Thu, 19 Mar 2026 14:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13EEC19424;
	Thu, 19 Mar 2026 14:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773930683;
	bh=h5Aa5pRSR7eKNJFLVE6Af15Uj6701Id7RhmHu3jhLXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbkoqjlBACSHhUzBH9DGqtKAeX+2K/xHxxe01kPTQVUJNF2ik9tbfXUyaRlZAqmWc
	 j4qgcpRUnYEAprDTsczHdpo2OxjRjywi1UIzoAlk3NmS0oggdV0O8EDLV8LyVtSSdU
	 m/3xmLXWUzHjX0sP2GXpyviT9wA/M5NlIWnYyljQNK+Mxt5mc4neynaNv1cXpJlMzH
	 y5MsTQkMkGlAe3fDO5eG9xYLXGKjpl4AN6ubRLFlg1IaU2Qy3/BnRlf6aL2jQ0HcYx
	 sWC0kv8D2LThrvuoQfPpFs/dmAcfNBIeG0GIr6C3Hq7+3iEUOHxl+768Fd1E36HI/z
	 XC3ciJEzo+hlA==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: document damos_commit_dests() failure semantics
Date: Thu, 19 Mar 2026 07:31:14 -0700
Message-ID: <20260319143116.82849-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319071332.114595-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54D65A0024
X-Stat-Signature: ur6oiqb58emnqqgk76ykedse9cdn6hby
X-Rspam-User: 
X-HE-Tag: 1773930684-972143
X-HE-Meta: U2FsdGVkX19GhiIEJ/5XNDT6syOOxIhnzBTH5OumjkXn3+YIid4adPlxumCrMvdtHlWrQtlEDBzmVfzUTD8/tF59pG6MjEUG0ZlC53c670MxofnnNP5Fl46XVO2sI2fHang+8zLDse+GASbdK5QSThx9Ttn29DF7zaKehfPMTiLWod9QMtDnBmZytJfCLpYXSlnpIRYPuccSu1ungJ0Q6a23qBRjI+KYZsB62B7leac061OOn0y/m8W+DoQyiyCCRwULVi502d2/ynuxwmJpaPq3kSRUWZqG6b1F1T0H3tWZco0vq94cfOVRQBbUgTRmznYeuAoRpgA5k+cSSWaLZ7JmmeSPFA7YwVFmVubP18tPX/5JP6ahaeM375PsUPmIXafJAv4YfrZBm60MXQlCH+uBLetUoUVk121I4nX0k6iR3jf2d5cuu20d1LfaiybH/0UJK3EZop9LWgRyHN7DkXfKZA2L2HUUO3caxBfZR0/qTaR96dxQl9uNp/rFnhG9ARHjLeeouP0KGc3Dfq3AZ9Vqvxslk8qzj4JSaR/roxd9pHiMOsKGabARZAwdPAZ4jyhvHVyBUsNm0PaAoUZYMqRjKKmo/CXbcypHJr/U257WrKTrCkMdOPqoUCTjgvM5h9umGBZDTGGi6MnzmSxhkWeUhzJQhcCywvULz2W8RMXbp2vVnXxHs2awqvGUaLxmkpdAqEyzICkA7Hox27IZJNbRjg/McES/xDqbGWLcdwXS+rUqBMQBv4N1XFej0OEmR780q+ai1Pbl3Blcxg1S+AXSANsxkqNEa71+AEwSlRcKHQ3MtEvNyb9JMNZ/2cMU/U0tyIlnxp7JNJOuqdJmU6ymHsIeshRQVtdO3Lg1c2FoFilyZhwz11gfWH7I0Ky3i3kSJuQyiHH9HVlEgQ13+KsRlzOKP8cTpvRO2qbbLY+HyEjhjw0GI79ovyWGOvTgOoJZvhHLmAe6UE6i5V3
 Iy6CeC79
 tJ0cYaWhchIRhNZwxC1i1Bf3LoJlVXmTdGGpwOGmSsAGiI/fZcKIhSFb4flY4Ni3f5SHnD/zObu9Gfwsrd6RO3FcLU2+EPPUjw/YI97edqOdU8mBynsM79Nb1U88OY3GdF84UNthayzDgcaUhCHbLb2j+KNvCuUmNN1QSX5KGozDdNKKF6hivjTF+JIyVEDiyN0mC1Ncf7aF7Gpf2+KqZgLkm8fu9ERSjhnc8Ep8psUudnHKcIkr5SL1T6VOz0HtGzB2gMgUS6jPe79+NtUNT4E+lfAdf57CDb1JxrkpjxAKI6DGisM5InZB+lke6YZlITNTlRNMbJyzCSQxy7whiLGTJRijHNMKrhY3Od11TDwWGCVHAqalzi7g+OcNby7TD5DV1WPIceWk+lUCwezAK55aOLMXSGdlhfi6goUMntIGrSr29eI4V6NLkiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Josh,

On Thu, 19 Mar 2026 07:13:32 +0000 Josh Law <objecting@objecting.org> wrote:

> Add a kernel-doc comment to damos_commit_dests() documenting its
> allocation failure contract: on -ENOMEM, the destination structure is
> left in a partially torn-down state that is safe to deallocate via
> damon_destroy_scheme(), but must not be reused for further commits.

Nice patch.  We intentionally do not use kernel-doc comment for static
functions, to not encourage API document readers use the non-public functions.
We still use kernel-doc like comment for static functions, to help developers.
That is, starting the comment with '/*' instead of '/**'.  Maybe 'damon_call()'
is an example.

> 
> This was unclear from the code alone and led to a separate patch
> attempting to reset nr_dests on failure.

Good point.  Adding a link [1] would be nice.

> Make the intended usage
> explicit so future readers do not repeat the confusion.
> 
> Signed-off-by: Josh Law <objecting@objecting.org>

Other than the above trivial things,

Reviewed-by: SeongJae Park <sj@kernel.org>

I added this patch to my tree, after addressing my above comments.  If you
don't mind, I will post it tomorrow as a v2, for mm.git inclusion.  If you have
different opinions to my comments or you prefer to post v2 on your own, please
feel free to do so :)

> ---
>  mm/damon/core.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index e233eb84a2d5..c884bb31c9b8 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1054,6 +1054,23 @@ static void damos_set_filters_default_reject(struct damos *s)
>  		damos_filters_default_reject(&s->ops_filters);
>  }
>  
> +/**
> + * damos_commit_dests() - Copy migration destinations from @src to @dst.
> + * @dst:	Destination structure to update.
> + * @src:	Source structure to copy from.
> + *
> + * If the number of destinations has changed, the old arrays in @dst are freed
> + * and new ones are allocated.  On success, @dst contains a full copy of
> + * @src's arrays and count.
> + *
> + * On allocation failure, @dst is left in a partially torn-down state: its
> + * arrays may be NULL and @nr_dests may not reflect the actual allocation
> + * sizes.  The structure remains safe to deallocate via damon_destroy_scheme(),
> + * but callers must not reuse @dst for further commits — it should be
> + * discarded.
> + *
> + * Return: 0 on success, -ENOMEM on allocation failure.
> + */
>  static int damos_commit_dests(struct damos_migrate_dests *dst,
>  		struct damos_migrate_dests *src)
>  {
> -- 
> 2.34.1

And Sashiko comment [2].  TL; DR: Good finding.  We aware the issue and working
on the fix.  Nonetheless, that's out of the scope of this patch.

: Does leaving dst in a torn-down state cause a NULL pointer dereference in
: the background kdamond thread?
: 
: If damon_commit_ctx() fails during damos_commit_dests(), the sysfs update
: aborts. However, the broken scheme remains active in kdamond->damon_ctx
: because damon_commit_schemes() does not remove or destroy dst_scheme on
: error.
: 
: When the background thread calls kdamond_apply_schemes() and invokes
: damos_va_migrate_dests_add(), it iterates based on the unmodified nr_dests:
: 
:     for (i = 0; i < dests->nr_dests; i++)
:         weight_total += dests->weight_arr[i];
: 
: Since weight_arr is NULL but nr_dests retains its old non-zero value, will
: this unconditionally dereference the NULL pointer? It appears the previous
: patch attempting to reset nr_dests on failure might be necessary to prevent
: this crash.


Nice catch.  We actually figured out [3] this issue from the discussion on
Josh's previous patch that motivated this one.  And I'm working on it.  Because
the issue is arguably orthogonal to this patch, I think this patch is good to
go.

[1] https://lore.kernel.org/20260318214939.36100-1-objecting@objecting.org
[2] review url: https://sashiko.dev/#/patchset/20260319071332.114595-1-objecting@objecting.org
[3] https://lore.kernel.org/20260319043309.97966-1-sj@kernel.org


Thanks,
SJ

[...]

