Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81BF3109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F306B0420; Thu, 19 Mar 2026 22:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFE86B0421; Thu, 19 Mar 2026 22:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C9D6B0422; Thu, 19 Mar 2026 22:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A258B6B0420
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:29:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45B751B86C2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:29:07 +0000 (UTC)
X-FDA: 84564859134.24.5FE8046
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 940594000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:29:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aGF5eAg5;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773973745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/ouKt1SGR9EHv3qk24ktyb5YILtNf61TkwXSal0gYw=;
	b=wjo8dKxG9s3fepiR6N4Psq0x8GXcrU+wyk0QGbzdCZPxe1gSdVis/CQzCZ4BBSbNw6JH71
	yDbNC683f7PrquUeD+9ZBjyOeayWOax+LF29worKC9RhZWuf6Yi7edircYn6vttJO6xzda
	ZpBSgUTvJqEx1+xgrC+a/8H4kQS2p8I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aGF5eAg5;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773973745; a=rsa-sha256;
	cv=none;
	b=q5eb7Uc/5eEjDTQB7UoWuXGlL3EEhiS515+Wa2/AGXk9TtjaNHqbNzE1+c6EMC+k+nqlPY
	wvPoSXLR6cuvfbnGmrVmeFBNapsaUtQsqIhG8uEiESklImQRnQvUaMSrK0SiRzoD8ZckbM
	X5hM4bvHPmaBgNm6gS6gIFTcQ2d9DGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FB3941957;
	Fri, 20 Mar 2026 02:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4827AC19424;
	Fri, 20 Mar 2026 02:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773973744;
	bh=tpGT9HIxfVro2qvhVyVnekgS2KunpsS2ClCk/o5mBAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGF5eAg51gxaSCwv03t28Y1RWmgpy1R7a0mHkHkusJwftawbe4qhBII3q10sQsiUd
	 8jad/EPLHnZ3WYpHCx5YMmSUaaVewlWiEbKsDPaw511sEWCvKXjl6LsZUsEJwmPHYg
	 FJqAzlT4pI+ZRNGR4sJWlymKvqwLrWAbq6E+81Ej/U7B5P3gOyYfZ/iwqGxJGYcZHe
	 rX161w6PBiLmOErh5qR97eFiN845YdWWfp1fT1sMpgtZ2TMTj+jXV18QwAymwRm++t
	 iDaTYA6AXcgaU4fDbif9fQ0F2V57SjwCzGn6u4iCLlviHL0QDxmol7bhJWQy11Mo5r
	 BWVvtXuXtVNRw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/reclaim: reject non-power-of-2 addr_unit
Date: Thu, 19 Mar 2026 19:29:01 -0700
Message-ID: <20260320022902.1415-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319161620.189392-2-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 940594000A
X-Stat-Signature: qx9684uzdsoy7jiau7eiri5bmpjpkjb3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773973745-695515
X-HE-Meta: U2FsdGVkX18+pR9nXk4OnTsoJSkhVjLs486IzWqJspxUcmbA2t+oiPWR60OsiaRM3OK4LWPo/PFSAvicDZXSMGWmxYw/yNzHOQqSRbrrvjcAeZOriWQ9zHK3f7QADpMe5/mntFBUAL9jbyw0st8Fm6s2+WoY62G2ijI6zmQbXPu4hkxIO9NaTzmqZsNVJAhpIT8PoA7qbF5NAWya2Uu3FDf/13OE4OAzoNvk77fle1z1RcvyKud/faGRbQ3Tj5BrtHEYSIdQFHBb1QasUyqtiixeXLY2SdnxKqcdX0LzbjyetXISTKDAUC0ouDmjZcHOX70r+lHVcX1RB6yanzGtPPnr0igR5wYFMWnvP83EdJ6PCm85QORJxtFDFz53VlREs+sk1ju6/r6ZVnUNQsRZyv7dEiNUgtLVlvZDQq6n0f4jYkkvTgrP7SE7vtNtgUGzhEP282JOC0ltjjb6vQ9TYRa2WxYYicKOhuAUWnSXsNvFaJtlpAK2RWBqSrRRp2cbUGLy/zxSuaX+dr4jqrlhrfL84ncS/HByeV6aKQoBXnI6uUHpbRhgNbPX1R8GMyN0xpsVuUszexOx0LOOo2+5/KKsFAcDTBWaCmJRmfThcBASFujcNGVCqwGkYLksY63T0ORTJkizrFXUCdH1Z0SpxOeVXfYKRBjINRTB5gqG6RP1EJNUET3ALYksv/jr6BkjFraRhx6Fu/gVHp5iGvtet6OzzsqXfKpgdqBoU2ApaTvbkgiKi63A4kdhg4oEI3KF2wc8LwKAVPDF2Jigcy8g+iAjQVAQky35OX1D1IN8YAH3vQpLULpn46lStlMYqr8eriCzNiKSBBFqsXmtcwpWDacF/DKO3ne+gd0YzWjyRVeeiegp0m0pUeQq9/m99UTnEfuxqGJT/3gG/GZqwhkFSSrr7VOF3ic4svNfwJEKr03jvQ8g8V+OT9qj0ZaXfPLDncc8URGGwSCDyFoW1U3
 eQUr81/G
 ZiVGkqmyUZVa6HdPtL9td8NLJkz7n7NxeMUKQwGApuU2M0uIP3NDSc9lr8f+YTGrHi8w3pV86T2dljr+/ZWdGqCBJ7QIGOJoFIglWe5Sb5ttVqtahIwelV2yAL37AI9Muj73YYvc0MB5gg9lXEHkv1OcC6FDGZWxLlydwUCemYC/KR5rhmPo/aM5sIqHa3ay3oxCuYpvsQzRbKD3Y8W7Um4/jKVIC0khL1orcn4DZOiFreWr9Rco1k+646p3YmvPH/HgI32Z1NFxwp44Wfcw2JMmAg75V3syMpXS0PQddxx/vWUxJ2fKkahRAgEvV3MAQ6IYyXetBWKpWSR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 16:16:19 +0000 Josh Law <objecting@objecting.org> wrote:

> DAMON_MIN_REGION_SZ / addr_unit is used as min_region_sz, which is
> passed to ALIGN() and ALIGN_DOWN() in core.c. These macros require
> power-of-2 alignment. When addr_unit is not a power of 2 (e.g., 3),
> the division produces a non-power-of-2 min_region_sz, causing silent
> undefined behavior in ALIGN before damon_commit_ctx() gets a chance
> to reject it.

But the non-power-of-2 min_region_sz makes no effect or be used anywhere unless
damon_commit_ctx() is completed without the rejection.  So this is not a real
issue?  Am I missing something?

> 
> Validate that addr_unit is a power of 2 in the store function so the
> user gets immediate -EINVAL feedback instead of a silent failure.
> 
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  mm/damon/reclaim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

And, I'm adding Sashiko comment with my comments in line.

# review url: https://sashiko.dev/#/patchset/20260319161620.189392-2-objecting@objecting.org

> 
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 43d76f5bed44..9b55df304e51 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -321,7 +321,7 @@ static int damon_reclaim_addr_unit_store(const char *val,
>  
>  	if (err)
>  		return err;
> -	if (!input_addr_unit)
> +	if (!input_addr_unit || !is_power_of_2(input_addr_unit))
>  		return -EINVAL;

: This isn't a bug, but should <linux/log2.h> be explicitly included for the
: is_power_of_2() macro to avoid relying on implicit transitive includes?

Unless it causes a build error, I'd say no.

: 
: Does this same undefined behavior still exist in other DAMON interfaces?
: Looking at damon_lru_sort_addr_unit_store() in mm/damon/lru_sort.c and
: addr_unit_store() in mm/damon/sysfs.c, they appear to still only check
: (!input_addr_unit). Could a user writing a non-power-of-2 value to the
: lru_sort module parameters or sysfs interfaces successfully bypass validation
: and produce a malformed min_region_sz?

Josh already mentioned similar fix may needed on DAMON_LRU_SORT.  I am doubting
if this is a real issue, though, as mentioned above.

>  
>  	addr_unit = input_addr_unit;

: Since addr_unit is a global variable updated here without locks, could there
: be a race condition when it is read during parameter application?
: 
: For instance, in damon_reclaim_apply_parameters() and
: damon_lru_sort_apply_parameters(), addr_unit is read twice sequentially:
: 
:     param_ctx->addr_unit = addr_unit;
:     param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
: 
: If a concurrent write updates addr_unit between these two loads (e.g., from 2
: to 4096), could the context's addr_unit get 2 while min_region_sz gets 1,
: creating a mismatched configuration state? Should READ_ONCE() be used to
: securely cache the global state into a local variable?

Agree.  Nonetheless, orthogonal to this patch.  I will work on this.


Thanks,
SJ

[...]

