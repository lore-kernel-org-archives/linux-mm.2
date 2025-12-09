Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36509D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 07:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140576B0005; Tue,  9 Dec 2025 02:21:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1856B0007; Tue,  9 Dec 2025 02:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006D56B0008; Tue,  9 Dec 2025 02:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E60DB6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:21:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 649A1140416
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:21:54 +0000 (UTC)
X-FDA: 84199088148.19.7518802
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A3D131C0004
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:21:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uNDULjqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765264912; a=rsa-sha256;
	cv=none;
	b=ZRfCqsnmP+dDPpcmH5z/9QIUNekA6Hh6iUHutmDp4xZ3oJ7Iz5Tp2FCY5r/WT56jD/3AlT
	rE6Ayr+SLuV2t7PsJMl2iPMbg2XUQ0tPQsvA/ArV0vw7NvMJpl3mDo/M56aDNJgsi13Gr+
	u24mexHO3DCdW/xQDblBXA9hSrgbFao=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uNDULjqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765264912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaz7ChT4qKnjkK7Iu1ZHnQeBlb+LWs4ghUNTWn+BX8Y=;
	b=Yx3UFlfVIbnlk5QwBmQeYvwr5ZZoWtMsJJK41bu5w2x8awLO7ql1zEiYJReEQU3kagRRg7
	qByDDWmsIMnJGTOgQyia48Gec9+2QXUEAbEqxquFuqjqVjwoJ534wSNJHdqZuy2sjHybp0
	BlMfNicAYMClEuQfSeNvhqmkMAUDoFg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F33340067;
	Tue,  9 Dec 2025 07:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A8AC4CEF5;
	Tue,  9 Dec 2025 07:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765264911;
	bh=YFsjm86FdvkgcY6Jiigg9An1/lmF5ic/ii6TJuTDmGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNDULjqHUgaW7V6B+JgMTxVCIdhI5LwAO4x9mGGF2NAzKCSz8cfG/YlWW7dScHzx5
	 SYhrMuK5bePqInXB/WmVJuw+j4Cq9i7ni3uV9XICTDN+PP9OwXtQJmlPvnpVKnlU2S
	 M9BPCmrTFKbQwmFQWya1JVIKxB21FKTZHi8WIzBdT/Eczdt3G58U2l/t1E3Gt1JUc2
	 FwFU0TEkaHOr02EdA0CQbGtTP4A1v3G7HQX1COy1C/Ev7payIQJrtojta8o4fAS7nP
	 gMfp1MPNHDpwI11VIQgnMZwAZyHYSzTM9vnVukJdBahtkEkT03SnqWqafmZiaD6JoU
	 9aqy7F1xb0f5Q==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/core: delete damon_target when detected invalid
Date: Mon,  8 Dec 2025 23:21:45 -0800
Message-ID: <20251209072146.42315-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251209055713.270737-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rzszjas9wskdugmu99swd47rsgnuhmft
X-Rspam-User: 
X-Rspamd-Queue-Id: A3D131C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1765264912-465497
X-HE-Meta: U2FsdGVkX1+kvLyAYMQwyqQSed+LQ/fYFId6D+mJIODRtED+N6BKWMbZc2x92aR6LlDrqRxAJCWi/3VA/yiWWfrgCn13KoCSfJii19c3FoFmc7GDICFwA4QaTM4gTrlLjLEOT5qLBFpd6X4OMjoB0Y5zvjil8cHMkN4DeBqYisv43eshq2Qo/LvMDUfqkVXdmV2hKqrgVCGEWuhjICnYX1yuS9JKlOH3MgDJ7qZ2I5DFBjaMwAuHMwpZL1T6Et1FE0V8GxjmDRVbMn3/33e/77VazSbU7cyinYTfQ066nK61tK05ck5MuFP6P5xHtfr1AjoAW+LfZGonL4W1XC6bWMYfotFdJJsH5Gzenl430CDrJ2kWLSpNySRJCFjKD7CN72Ac+pHB6yiJBiSNZ6Gp6ysIewJBvDuYv5SW1oXBmBQYy0ARNMZlWE7YuFCb2NYdoJjAkHoZRdWWgzl+D1WecUhmHIP3ohm68GhzK1v5AgeLi+6oUXi3nmUH+8WVXs8y7Q3UfOiIh0DdzgR3Rx636KG/5TOzdqXplKHRCkcmNB73J+tge3Aa6t6tv4X+j2ESbdKRfqnuYKVaX+Wg5R/xaH4IQaes+qS+tQx7FuSxfzkYc2XCfN/PII8dEP6CfaYH6ABOKHICBejVKo8zJCwZwXNfp+bOawRF38wt+FhQAE3fscGfy/3xLFhLdJBzRq3tulwt+U2T6I18u5axKlRXH+iS0DSYSDmfPUqnfQo0eqSR6hTG3lvHuE9laz8hLABHzXCdb+Wv25EOum+lXacMPCGXoolF1M6LCk1U4NM4xPw539+b0suWjW0bVNKuyz/vHvqfb4wX78qQovr+U50I3NC3UhOoxr2YdR5PQkMpLmUBoXrScxAEbF163xoi4gbawlQPKUrjPP9aMScgfCxeI/1TX4hMW8Tmk+4qPrQjT9K9pCokwceoo1djq3uCom0qKPt+eyHGRsg2gZV+2rA
 HcC9c8s+
 BiRMuVtXXUlKyps5h5SuYJhJL2GqsmQf74FXdJ2plkiCF+nVQZZ2VP1+BWaUP49tYZAS4y2X+Uj7q7FWFCvlLfzUeAQiVJyTonly7V8oGIR3NakoYBFW/o6f6IIyik4Sa4fJ+VBuMl5bsdsGnDHO/4wS/yJbNuh7OwABxYtYLpZB6ZYnGuqStMYhuSQMEnnuM275gqXruppzZZ5kUYjjvhHlLkVIXtug23kx0se8ORLkyjGS6tihMzwweaYrmKZrcDTGP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  9 Dec 2025 13:57:13 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Currently, DAMON does not proactively clean up invalid monitoring
> targets during its runtime.  When some monitored targets exit, DAMON
> still makes the following unnecessary function calls,
> 
>   --damon_for_each_target--
>   --damon_for_each_region--
>       damon_do_apply_schemes
>         damos_apply_scheme
>           damon_va_apply_scheme
>             damos_madvise
>               damon_get_mm
> 
> and it is only in the damon_get_mm() that it may finally discover that
> the monitoring target no longer exists.

Thank you for finding this inefficiency, Enze!

> 
> To avoid wasting CPU resources, this patch modifies the
> kdamond_need_stop() logic to proactively clean up monitoring targets
> when they are found to be invalid.

However, this could introduce an unexpected behavior change to DAMON sysfs
users.  Let's consider a DAMON context having three target processes (a, b, c)
is running.  The second process is terminated.  And the user updates the target
with two existing processes and a new process (a, d, c) using the online commit
feature.

Before this change, 'a' and 'c' targets keep running with the old monitoring
results.  The target for 'b' is replaced for 'd'.  After this change, the
target for 'b' is removed from the list, and 'c' becomes the second target of
the list.  Because the online commit feature works based on the indices of
targets on the list, target for 'c' is updated for 'b', lose previous
monitoring results.

Please let me know if I'm missing something.

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  mm/damon/core.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index f9fc0375890a..eb5612bfd6bf 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2462,7 +2462,8 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
>   */
>  static bool kdamond_need_stop(struct damon_ctx *ctx)
>  {
> -	struct damon_target *t;
> +	struct damon_target *t, *next;
> +	bool valid_target_exist = false;
>  
>  	if (kthread_should_stop())
>  		return true;
> @@ -2470,11 +2471,16 @@ static bool kdamond_need_stop(struct damon_ctx *ctx)
>  	if (!ctx->ops.target_valid)
>  		return false;
>  
> -	damon_for_each_target(t, ctx) {
> +	damon_for_each_target_safe(t, next, ctx) {
>  		if (ctx->ops.target_valid(t))
> -			return false;
> +			valid_target_exist = true;
> +		else
> +			damon_destroy_target(t, ctx);
>  	}
>  
> +	if (valid_target_exist)
> +		return false;
> +
>  	return true;
>  }

So, from the beginning part of the patch description, I understand your concern
is the unnecessary function calls in kdamond_apply_schemes().  What about
checking the target validness using ctx->ops.target_valid() and avoid going
deeper if it is invalid?  Seems the damon_for_each_target() loop is a good
point to do this.

What do you think?


Thanks,
SJ

[...]

