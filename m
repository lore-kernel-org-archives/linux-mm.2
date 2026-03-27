Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DFA10ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E40D6B0095; Fri, 27 Mar 2026 09:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6945B6B0096; Fri, 27 Mar 2026 09:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1A76B0098; Fri, 27 Mar 2026 09:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F78A6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:59:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E14EA161131
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:59:43 +0000 (UTC)
X-FDA: 84592001046.11.0023428
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2459C20003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:59:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qecqNptH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774619982; a=rsa-sha256;
	cv=none;
	b=kbGvtOrOpOnOQeTUsX9R3MZupJZOrmtzJaMxgKd8znEkkY93VWI9fzze2PIexu3lwHppf/
	t+byNtgdU/8wsaJtlUHTLcJMPcdPL8mCefzV32coakayuJubcbAwptheJlMUthL0oPBs6j
	tukKufSnccXM5A3x5SkhsB3dbC5787s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qecqNptH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774619982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXwSUf05fSFIYQWLl0uVx+m+GmdAuQFrxW4iFJoKiTc=;
	b=jghM65nP4K0u/rwdcDgOErGggW1yBpXMtylVZURPRM/h4UAefZkIzzLXB1bOGXDCbVfbDN
	YvpylR1Rfq43eTtsVHwLLQUy6yGzytOwty61qHZMmAaE987YlFAEwkZVjT0fkAHP20t+/o
	AZK6KrrQea1dm/3xmeSHeabufXge4LE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B0F041AB2;
	Fri, 27 Mar 2026 13:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D686AC19423;
	Fri, 27 Mar 2026 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774619981;
	bh=tgyKdpWmngsTLaAQMyDyCS7Kz3ujztVy3cpSjk1XSlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qecqNptHMtRlwI6Q23NBhTSoSqWmvJUhM1iwbAU9rT0a7PDjS6DiszunK1elfMT8+
	 eKYpNOg2Gzw14Xr0Nxs295tyYPKBUhMjnAsvMR209NgkI16WfJ0QRlFlyToIOHOlOO
	 rLLyCxRC1i+OAmfRaeFU5+M/lLSNNRKWqXY1LaAl8p4gMKxOhkDHIK5F2pyn3Gp0zB
	 iFRb3aFnwJ3n4jbggG9gTtXUls5FBNDc0eLJ3PLZbHVIoZ0w6Sg6MT2oamtaG1F5Eg
	 Re7/AVvpCgmX9ZpzHDDj1suyyNbvwqVfIoAEbf9JPuJKrU/K8YneLJFs3Bug+ly7dc
	 vpULjqGpH123A==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v6] mm/damon: add synchronous commit for commit_inputs
Date: Fri, 27 Mar 2026 06:59:38 -0700
Message-ID: <20260327135939.4085-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327062558.66392-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2459C20003
X-Stat-Signature: 5tnbyc3pp875fu5i9tqqxwgzos8r6jqa
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774619981-57581
X-HE-Meta: U2FsdGVkX19mF6pBAvjUYIlfB6lXRWc0CrU6mVxbbGeKUTIxw2xJwue+k+QSKOOJYSna43nD3cuws6qfONCg7lHZk9TcmRRtmyIfeUpzDcNGccogWMShj63/g0fHQnJMR5AVlC1JB1uOMZdlQtkL39JQYy/DD1N+xCP9udWB/Shn8OyUQdN1BYbdzm/oHcD/XgViUV+4gN8qr3iCh8qd3g2uUcdd/8zGqyC3EEumt9Wh59GRqDqixeK7f9drhMGBylMVbq09OKmS57hU15yzS5DZztkGxFHkHAc2G8IAz3gQBpz1GVdqUDMRrfR+1VQyufSanvbDCRXNIhD0/A8dCzMkQIij2E/6geTqAPTUMASqoYeVE2EzlNdJ6P+QPdCewZgA9h8rtf9TPvKMxLJxlGbBi9nEM3lwt58pxAQhF9kEmZfC7nt3+u08BxTNRKZQ4PZyBKD2aHhrI57G+vqPgoXhBkpndmToOX2gJJM4jQ5ySnvRPNJ/AxwbdDduOumFxXyxJYUv8LP3j11TvWfupm8Niu9PIzy3kYKFI6/axtP/d+/3xAIsU69iyW80whEMMuMdeM07XGzTrz3zRGRjaRclF8kon7nxWlHYBtmCvCJFUgVO0t59M/GH/A1YYrR2gsdP3AOQN4rB7UwBp5lqpKlmPK4zHXmqSmOzpxH6WfhI9LGKBMiChidU2gBsDatibeojwl3WdkLxnLslq0jklZUxkfu6bK/bTIaY4IBJdHjxTU0lgBcfJtU1wXmMmEaomyvXeXMCKOIq/rqnOaFzqR7TCGa8qcASHQQC9A/jumgVFihnQsScK/nfvyx/9hjWAUdyu7fi0b6ChmwI5Sfy66qDu6LcJb2WQxOpxk3UKGnZQKv4H2jPgAFDRlmSe1NGnbWzIyRL79YDQ/xgwd5a4O4vhQqb9KVCRtghSujOnzi2pvrkraZpAmxJH3ohGEHg8FK9X75XNGAwjb3DyQ5
 3RlS0ks/
 5NE17R3h7e09D8cpYBZEoTyEstNGwBxXGc72M/zVJFvzgrEqkw0RxpSLMPeaZKpaAnAdfd8td2UdJ0EAXw7Ms26NctxmR0082Uj4yiaS/Iq3V/7C6GNxIErFsBalOtsNlGxvAzfFPC2Xagke0+tbqhTJvGR/IBcFaulEUepw37N6lZvrmqflIvW0OknQxHX8cDWxHGXqzLCKNVT1m2wPK2URaJpFIN9+fD6CHpaNYFgN2eQAGx9bVc452QcZoH+E64jx60UsCcBIsCtFH96zojrBhaiaSPl52qaesGgnkbRw5zMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

On Fri, 27 Mar 2026 14:25:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
> silently (no error returned to shell), because the validation happens
> asynchronously in the kdamond.
> 
> Solution
> ========
> To fix this, the commit_inputs_store() callback now uses damon_call() to
> synchronously commit parameters in the kdamond thread's safe context.
> This ensures that validation errors are returned immediately to
> userspace, following the pattern used by DAMON_SYSFS.
> 
> Changes
> =======
> 1. Added commit_inputs_store() and commit_inputs_fn() to commit
>    synchronously.
> 2. Removed handle_commit_inputs().
> 
> This change is motivated from another discussion [1].
> 
> [1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> Changes from RFC-v5:
> - Removed unnecessary assignment in commit_inputs_store().
> - Return -EINVAL instead of -EBUSY when 'commit_inputs' is triggered
>   while kdamond is not running.
> - Link to RFC-v5: https://lore.kernel.org/20260325013939.18167-1-aethernet65535@gmail.com
> 
> Changes from RFC-v4:
> - Rename the 'yes' variable in commit_inputs_store() to the more
>   understandable 'commit_inputs_request'.
> - Return -EBUSY instead of -EINVAL when 'commit_inputs' is triggered 
>   while kdamond is not running.
> - Link to RFC-v4: https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com
> 
> Changes from RFC-v3:
> - Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
>   pointer dereference during early boot. (Found by Sashiko.dev)
> - Removed handle_commit_inputs() and its associated polling logic as
>   they have become dead code after moving to the synchronous damon_call()
>   approach.
> - Ensure the 'commit_inputs' is properly updated.
> Link to RFC-v3: https://lore.kernel.org/20260322231522.32700-1-aethernet65535@gmail.com
> 
> Changes from RFC-v2:
> - Removed damon_validate_attrs(), now using damon_commit_ctx() for
>   synchronous validation in the kdamond context.
> - Following DAMON_SYSFS pattern for synchronous commit via damon_call().
> - Link to RFC-v2: https://lore.kernel.org/20260321140926.22163-1-aethernet65535@gmail.com
> 
> Changes from RFC-v1:
> - Remove question from commit message area.
> - Added synchronous validation for DAMON_RECLAIM.
> - Rename damon_valid_attrs() -> damon_validate_attrs().
> - Exported a new function damon_validate_attrs() and declared it in
>   damon.h.
> - Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com
> 
>  mm/damon/lru_sort.c | 42 +++++++++++++++++++++++++++++++++++-------
>  mm/damon/reclaim.c  | 42 +++++++++++++++++++++++++++++++++++-------
>  2 files changed, 70 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..453033f3cb3e 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -39,7 +39,6 @@ static bool enabled __read_mostly;
>   * the re-reading, DAMON_LRU_SORT will be disabled.
>   */
>  static bool commit_inputs __read_mostly;
> -module_param(commit_inputs, bool, 0600);
>  
>  /*
>   * Desired active to [in]active memory ratio in bp (1/10,000).
> @@ -349,18 +348,47 @@ static int damon_lru_sort_apply_parameters(void)
>  	return err;
>  }
>  
> -static int damon_lru_sort_handle_commit_inputs(void)
> +static int damon_lru_sort_commit_inputs_fn(void *arg)
>  {
> +	return damon_lru_sort_apply_parameters();
> +}
> +
> +static int damon_lru_sort_commit_inputs_store(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	bool commit_inputs_request;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_lru_sort_commit_inputs_fn,
> +		.repeat = false,

Undeclared fields are initialized to zero.  I don't think we need to explicitly
set repeat here.

> +	};
>  
> -	if (!commit_inputs)
> +	err = kstrtobool(val, &commit_inputs_request);
> +	if (err)
> +		return err;
> +
> +	if (!commit_inputs_request)
>  		return 0;
>  
> -	err = damon_lru_sort_apply_parameters();
> -	commit_inputs = false;
> -	return err;
> +	/*
> +	 * Skip damon_call() during early boot or when kdamond is
> +	 * not running to avoid NULL pointer dereference.
> +	 */
> +	if (!ctx)
> +		return -EINVAL;
> +
> +	err = damon_call(ctx, &control);
> +
> +	return control.return_code;

Shouldn't we return err if it is not zero?

[...]
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c

Same comments can be applied to changes for this file.


Thanks,
SJ

[...]

