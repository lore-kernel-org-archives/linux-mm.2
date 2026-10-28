Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F24606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 00:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUj6Hq/E
Received: by kanga.kvack.org (Postfix)
	id B77706B092C; Tue, 27 Oct 2026 20:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28476B092D; Tue, 27 Oct 2026 20:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E766B092E; Tue, 27 Oct 2026 20:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF726B092C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:19:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F6B7A89A3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:19:26 +0000 (UTC)
X-FDA: 85370125932.15.2E59FC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D3BB31C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:19:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SUj6Hq/E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793146764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Of+Ihfq2JolsP7lQDuT/aMXMnMjzwRQu8EA+8gWaGVg=;
	b=X43p1AUc3kMiJOgxd+u1EKShiH4oLPBVj+GRcGDnJ1NCw9UXy4ZWZ4KFbwFUfDD+5OGzqF
	VxDUchvtwNWA3Gab6uAJsnc4ayXSXdKGYkReDE1KuikP7MOwZ3Ok+Y1E5nnCNWpN6mfu16
	NU8ztOHFZ63o+bgiojdnUkLM+0qrvX4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SUj6Hq/E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793146764;
	b=JwH/10yf9dZn2+oC/Eni5cbMCLlcFj9GZ7ERmAcug1D4fPt20wCi2Y/lC8KgXeIXmz/53a
	LEaBIVogbDwo6nWKKk50Pse6B5G+MLkdGtgjs8ZFtPI4499S2zcj2Z3USTRU/hKAUb3DOw
	t+cM447peym4IbW7VNp5yvPD1PKKksY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C33B600C8;
	Wed, 28 Oct 2026 00:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62C51F01825;
	Wed, 28 Oct 2026 00:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793146764;
	bh=Of+Ihfq2JolsP7lQDuT/aMXMnMjzwRQu8EA+8gWaGVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUj6Hq/E/BbsMuEPgwvTu+j59aaKTVRomAQqlezP6T5LfKJTaXDSIHye46Kac/A3j
	 zhAIed35qXIE1rALmYpMIjVWkPi3TV/Qu5E1tJdkR8j36fIw7yeXUl+PosckFVvipq
	 I3SmzaPG4nSarXEnDWZvJDI5Mzy7ZXolD3alEDUQ/KwZ8fnVjjeD9d9b0wbv8kLZWw
	 U7ZBFjbBT4SbtHAa+2GKllC8fgxCjii9c/xVnELEzTky1JActGEE7AqeblKcDPYcs6
	 Ri+2bWQqoQ1CTFN9sJzMx/xy64IJMKIyXleyk7nkibh4iFg1+o/+/Y0Z945UNCpLYP
	 BE1r0CbrGGQ7Q==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	jm5905938@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/mm/damon/reclaim: rewrite complex parts
Date: Tue, 27 Oct 2026 17:19:15 -0700
Message-ID: <20261028001916.157488-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027212345.2586628-2-manuelebnerli@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D3BB31C0006
X-Stat-Signature: wg8gczzro5udszicfodtrr89hzumhu4a
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793146764-822815
X-HE-Meta: U2FsdGVkX18iO5Px3Uc/yrF78ZspwLPhRhWMl3X8K+HZKYygANQCKXzWdsNg9xWymptcupSuyJTTPlyj0wuY7Sb+S0CoBaVIlwEkaASdiBH8IT4b0+sxxY5BYyioGmj9LzCFPCurNaOvR4ptpIHlvXeOhB2DGi2xBIhXZvPrUZ4Aqn9NR8VUT/V0257hx3qAZC7DgEN1phtImEHFMaM1vUm/GEEd73KSRfXKQIMmDxGY1uyZQt4DAuNu8w+vLzxkgGWutJouHZkOew8W9dYWCmKiXDKbwkU9pPLLm7nj1IcxmreDH/qvaoqG6EV4xMJfu6cT2y/GxWSiaIIguLL6Tn1+lkAkJAcI0U8DWILTZe8CQ9FK3soyd/+hjR8TAbtmXjO29Y248/0w3I55De2p2VhwAoRRaT8OboZUiuEsoGHSATRLaAb3HhdwoNG8C0i+ONAdDwoogMBgrLbjXTvxIlJdwDre87KkfSV0lvqi624KjPEA3zlIVP5fi1wEL2bGxSMzxL/RY36iXH6dqKWHB4Ep6qNUWHeAPtAlEuWtCkEsZmhOAB9fLLT6gxzs60gqyxhF51qrKB/9KmzVAedo82lDJyfW7o8a9LYbukxy7ACFwAAed1ovt9Wxpocybq6ogpREt/uytcJ74YnnS/nqnvXT1iSzZJ9iQEpOkS1H68r17A5VdEfDNIfTMDKadqUxpIYfxJMx6h4mmUODOB94ko6gVEzXmv/n7hVc747hI/w36mJiCH/Krn/HXzlc3y1sMJP9acX1zglsgWCMPNf9TPEfyvoOvWKD9RIGojH0txFS6ruF38CTQOcyR6+5/lBkD6XTEhbFf4EljwAqfhEcMNhTC2U6CrWHO32+jUopXxvH+09bsJa7Rs0lZApDbkAoG4QQ/lJWcSexHZ76OfWBwU9r4D1X9S9bjtTCo0J+WMo92SWJRPD/GHMCDzVOSFglGGJePxdNpuAiVzVg/cj
 SHcZk2dk
 hWmcdPOLT3yKN99ccPfDBLhgmfDAzhnAc+/8OCRVjv5VqXia8Fjf4JkjWZACrUURvPRJnSWOh+D5Pcb+KwzY8Wx1K8LuGIRTR1+DH+5TA+ugu+iqwarO+pkEEqm4/O0Kr+3s46XqVGEtU/q8lv9qUnz5u7+cQ6E0OQFBsIZUyELRD3Rsm2Qwo6vc2ckizqHgANMedO+TgyNHyW9YT+p+6tMDuOnTAk1SR+QTKgXbXwSfo6ZHntTljs/7NrBVftS6V6tEsAEm5IJIPUeAshCPYAfaZtyAoxhbgPQyvSE9L88NIqT7lv1gyWH9iB9XTv4ZngNUx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Manuel,


On Tue, 27 Oct 2026 22:23:46 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Rewrite complex sentences.

Any special reason to keep this as a separated one?  I think it is ok to merge
this into the first patch.

> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> Suggested-by: Aveline Noir <jm5905938@gmail.com>
> ---
> Two more minor changes
> @ 31
> /s/attempts to pages out those/attempts to page out those/
> @ 126
> + 'is' to fix grammar
> 
>  .../admin-guide/mm/damon/reclaim.rst          | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> index 0bab2299ea..033686f410 100644
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> @@ -30,12 +30,13 @@ guests could mitigate this problem.
>  How It Works?
>  =============
>  
> -DAMON_RECLAIM finds memory regions that weren't accessed for specific time
> -duration and page out.  To avoid it consuming too much CPU for the paging out
> -operation, a speed limit can be configured.  Under the speed limit, it pages
> -out memory regions that weren't accessed longer time first.  System
> -administrators can also configure under what situation this scheme should
> -automatically be activated and deactivated with three memory pressure watermarks.
> +DAMON_RECLAIM identifies memory regions that have not been accessed for a
> +specified period and attempts to page out those.  To avoid it consuming
> +too much CPU for the paging out operation, a speed limit can be configured.
> +Within the configured speed limit, it prioritizes regions that have been
> +idle longer for reclamation.  System administrators can also configure under
> +what situation this scheme should automatically be activated and deactivated
> +with three memory pressure watermarks.
>  
>  Interface: Module Parameters
>  ============================
> @@ -125,8 +126,8 @@ quota_reset_interval_ms
>  
>  The time/size quota charge reset interval in milliseconds.
>  
> -The charge reset interval for the quota of time (quota_ms) and size
> -(quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
> +The charge reset interval for the quota of time is quota_ms and for the quota of
> +size is quota_sz.  That is, DAMON_RECLAIM does not try reclamation for more than
>  quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
>  milliseconds.

I think the original sentence was not that confusing.  Also, this changes the
nuance of the sentence?  What the sentence is saying is
"quota_reset_interval_ms is the charge reset interval for ...".  If this was
really confusing, maybe we can add "quota_reset_interval_ms is " part.

But, I start feeling we might trying too much polishing...?

>  
> @@ -137,7 +138,7 @@ quota_mem_pressure_us
>  
>  Desired level of memory pressure-stall time in microseconds.
>  
> -While keeping the caps that are set by other quotas, DAMON_RECLAIM automatically
> +While respecting the limits imposed by other quotas, DAMON_RECLAIM automatically
>  increases and decreases the effective level of the quota aiming this level of
>  memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
>  per quota reset interval (``quota_reset_interval_ms``) is collected and

I'm not sure if the original sentence was really difficult to understand.

I'd prefer dropping this change.


Thanks,
SJ

[...]

