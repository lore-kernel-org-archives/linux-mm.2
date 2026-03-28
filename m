Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5D410BA45E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F836B0095; Fri, 27 Mar 2026 20:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07CC6B0096; Fri, 27 Mar 2026 20:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44216B0098; Fri, 27 Mar 2026 20:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A42DB6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:43:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 519061B9B2F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:43:11 +0000 (UTC)
X-FDA: 84593622582.14.1678160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9F2BA000E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:43:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLYPPoIe;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774658589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsY3kCd3bXx1UhOFDmdQ5RWJs7ytTtC3FBjYfUyZfxY=;
	b=qzeAuKcSeY6Rymt5yC7H6OvIDOpRhqMvUkKdSOR82JUlDisu0kU/DEWmHe7Gp4jvL87Y3e
	z7k2k5Lc3Yl/+Svjr7NDGh2W8FsHtez7xQ+leNlai653iXcse2ohTgouo23rjD7r9HgCst
	xQTjjB32b8f8lz9W3Q4VW29hHHA37xM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774658589; a=rsa-sha256;
	cv=none;
	b=QoqXG5xsl1d7iOqHXm5bTQYggw4JqypaLjHgyVM5GU7VtSKkzcOqeuAs3bf/4ImmlGrpRK
	ScIS8KPCbyc8ADRolDO2ry3Fk6AgrehUoQ9VOY+yr+AVymUxNGCGKivqa9CNDp37KC4ibk
	UgSsYDrGGdD91aWZLMU90+kUhgWi/q0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLYPPoIe;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22E2C600AC;
	Sat, 28 Mar 2026 00:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9CBC19423;
	Sat, 28 Mar 2026 00:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774658588;
	bh=nszuYzVHtkEaRbvCa++z4lm9bFd2Xz8ppbdZso7gZrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLYPPoIezvNwSALO0PIzYbCv4mwhLrtfU0ZcLs8RbBmI8tWh6oEtjv4j5kFBf5SrE
	 xa9F3Cyek2TDOAkIboUzoKAd3NiVKa15fTmGBbXt7B87GLF7RvcHElhrv4FGyxvkHz
	 Wa8ZKx7450KkNvLuUL058AI6Xi5SI3+3LTaMiqAgwNsLZmYqd5+ZBQeTrrs80ipvTo
	 /URNfowSO7WqvCHiML4pewTZga6P+vart/Lam8IIfiAuwmF5WsxP7gDB4ojWrLDh2a
	 lC2w9HTRK+k1QJyv2PfX5U/VmJ4cc/HSa2rYJQiG7HKm4e09liGXDnQ1RZT/E4M+x8
	 2jXqHqxKClLxg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 1/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race
Date: Fri, 27 Mar 2026 17:43:06 -0700
Message-ID: <20260328004307.7244-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327233319.3528-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9F2BA000E
X-Stat-Signature: tduw4yqsu53swaus4t4y3788yswyjy68
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774658589-799211
X-HE-Meta: U2FsdGVkX1/cZfky9yS4bgdvZ1AE6LNmlCE+naMiXZZS5UTwweOF1C6cCs5gcErtXxIQwbaKvV7FAuf365bDuOPBBJLVrXgohZHBFVzX0MTfIdzUQb9u9Ly9vCvlc8CUbn23Q+j9Cx38vvAZVw1w+IJEAMPABkpnpQP3xfsLcVzZBHt8qGOwr+zDlcPLCvX8O/4bA8ss2zke88Duqj2a+VEpGTGpaF76j27fByxI8olv2KsIrleSYTbTSAlCDX3JMx3JxN3ezpq32QINoZ90hjK2f/Xm+EOKxCIrB/NToN6ssF6UnoJxRo2uiJpU7DmZkmuPS8Pa+cSl8S9JHqsZoY/cYUS/xI7vRVOW/YwlaVjDmJi0xd/yWOmC20NA+BRNelu6tEZB7MGsZccNoUEYZW94BQ14fMl/lZ+sxMyDLsXwJ+zIRZG8x0ntLX5OoV12ef47hRzSMnScYASDaismnRr9D5JlEsBq5Fiy5CfkUJ2UlYzESi1RfANXkI72hfdxmgdpWAwDOWL0wQuTR+OlOvYUuY7xDQtHt9Uu8wjD+0Z+9nPNOKFFTqWBspj6zHzCJMoSRC/n2WJTmEeIvQ0iU4yL3QdpZvpT/WiR54R2yWeHm4lY0gR79sIXolEQjHCFBdrSbzEpzrd29mjcL04fu9o+xF5ZdRKaPne+To6+dqL6gGdIEAvOmHfpLNAPLE1fh8kLUL9t7bh3EIvcAP/70rSKvDJKRaHG6NT0ORy6Mk8COT3P9/LVcGSFLpW/F1vrqWnvbK1qB0779K+JHj1IQCpzAsybBR/QKJpdng7kqOTlfyiPAewl7oHrrFr5w1oNEnUzfkkSIBocpxy60690AP5I/gcNbJtBYh9qkFTEmZveB7b/iH6v1uWiPL3dFkmMLIZDrV9RShjGfF339Jc3tornKicsiH+1VrRNbCx9JLrswGZ75DTowZzf4pb4yZ6oMem5LgQQgkOZszxA4q2
 /eWeSSbl
 skiOtiFEW8923XEtUM8QVENw10QWAR5nKJNe+Y0t1l0udKP4pDI81xTRRWBguk+TlwjRqajh2uKTqKE2H1jh09LtaGYfma/EKY6ZGwgluPONpzF/svLHAIg2rhc3iemxdSK0Hf0rgNSVLWAnQpC9Mc9HTMdxRWm1eUrTwulaIS8ubnrZjsUsN2oECIU4fH4vEb2/0JGI1MTuRRH6MXckX7KvvzT4ytk9kVlLuCsh53ZEQXowudbvpl8exMZeBRWC5D9fmz4Bh9+Twa0Qn84vCk8jr9nasRJhG/kWRheMxKLrgoJVtJvoWdU22je+wQZTEw0qUEgzEmhZssoVPyu9xFLNvNQeVJZPmRDpU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260327233319.3528-2-sj@kernel.org
# start of sashiko.dev inline review
commit 9cf54c95f0c4bda07c5dbaf4019d0d731f6c58fd
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: fix damon_call() vs kdamond_fn() exit race

This commit introduces a new call_controls_obsolete flag to prevent
damon_call() from adding requests to a terminating kdamond context.
It removes the after-registration DAMON context termination check.

Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..9bcda2765ac9 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1629,10 +1604,12 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
>  	INIT_LIST_HEAD(&control->list);
>  
>  	mutex_lock(&ctx->call_controls_lock);
> +	if (ctx->call_controls_obsolete) {
> +		mutex_unlock(&ctx->call_controls_lock);
> +		return -ECANCELED;
> +	}
>  	list_add_tail(&control->list, &ctx->call_controls);
>  	mutex_unlock(&ctx->call_controls_lock);
> -	if (!damon_is_running(ctx))
> -		return damon_call_handle_inactive_ctx(ctx, control);
>  	if (control->repeat)
>  		return 0;
>  	wait_for_completion(&control->completion);

Can this code trigger a use-after-free on control?

This appears to be a pre-existing issue that remains unfixed. If
kdamond_fn() is terminating, it executes kdamond_call(ctx, true). This
function removes the request, sets it as canceled, and calls kfree(control)
if control->dealloc_on_cancel is true.

Since ctx->call_controls_lock is dropped right before the control->repeat
check:

CPU1 (kdamond_fn)
kdamond_call(ctx, true)
    list_del(&control->list);
    kfree(control);

CPU2 (damon_call)
    mutex_unlock(&ctx->call_controls_lock);
    if (control->repeat)

Could kdamond_call() free control before damon_call() evaluates
control->repeat?

Furthermore, if memory poisoning causes the freed memory to evaluate
control->repeat as false, would this proceed to call wait_for_completion()
on the freed memory and cause wait queue corruption?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260327233319.3528-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260327233319.3528-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

