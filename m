Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F1CDCED24E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5D16B009B; Tue, 18 Nov 2025 05:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586356B009D; Tue, 18 Nov 2025 05:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474BC6B009E; Tue, 18 Nov 2025 05:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300AA6B009B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:30:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63F4E1604E8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:30:52 +0000 (UTC)
X-FDA: 84123359544.07.6687D99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B88A920017
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:30:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iqk7n7eZ;
	spf=pass (imf13.hostedemail.com: domain of legion@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=legion@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763461850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwtZ/nmkGWWLeDdi3KrWPq/yLS3gE/7l0xRHraPOwnU=;
	b=NFA7czLg3s7UinPdzxF+5HH3hkN4A3ik/+gTY1B/ZWxWf1Y2N3v6tygUx5oq3avQaWMEDl
	WbkkFLvCZO/c1u6D0zqpe2rxN/HUe98cI3H/xEVeG14cKqr0RafJe4ebSEvluaY7UZP4k3
	b+KRPJE1bhNCgtxoGmxPggsLM/3Bh9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763461850; a=rsa-sha256;
	cv=none;
	b=mJ7dSYYhS9Pc+1l8wy9L/B77wA/pRjFy8EyIuVuNxTIMF+KPtSk2OmMcFEoaiYle2bsezK
	JMjuNiwNZu/vVjZpul7zLq58QEUKk7JWYZt+Xm/mP49p+uvmf4yr2+GmCg0cGecbWJTxfZ
	iw6DT8TI75WEn//EYbqQr5TnbawaIN0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iqk7n7eZ;
	spf=pass (imf13.hostedemail.com: domain of legion@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=legion@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE7241993;
	Tue, 18 Nov 2025 10:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AAEC2BCC7;
	Tue, 18 Nov 2025 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763461849;
	bh=97rveo2IXOkr8UnydUJWTQGyrsAxOU77Y7PsYTPIAL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iqk7n7eZ8ANWuGK4G/j8wdCO+hGb0dXf7hZP6q3I8b/IKwfWr8ldB3KHDJajm/J+o
	 nVEGXH3pyv3oDwdWfOCs0qVkYM6OwY3nYnCxnoOujFs4ioWSMyHrdk+xtGf3R710ut
	 eHEkBXw2MZzCgFQSlybQDpo/xshHEzz56G/zGL9XIa39y9cM4N/ly0EbVbWUuGKbz9
	 kKZlhGoNzjhc9lSSdjtt1GcyMFSG6x+RtSpfEpxU6Qcf6emCDPNFeNQ3zPM/dJiMu3
	 pfjbBit3vCPDO3jQv01R9VLxcfK3zw5G7O/62m1WVFMuatKDe3jea4VgoxkAVgyr8t
	 ADkxOpDYe3lSw==
Date: Tue, 18 Nov 2025 11:30:38 +0100
From: Alexey Gladkov <legion@kernel.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] unshare: Fix nsproxy leak on set_cred_ucounts() error
 path
Message-ID: <aRxKzrX5np4YpS19@example.org>
References: <20251118064552.936962-1-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118064552.936962-1-ptikhomirov@virtuozzo.com>
X-Stat-Signature: 4gwgaecmikku3qbbmboteydsjhcun3o7
X-Rspam-User: 
X-Rspamd-Queue-Id: B88A920017
X-Rspamd-Server: rspam01
X-HE-Tag: 1763461850-420421
X-HE-Meta: U2FsdGVkX180yYrGoDqgOU1h1tsI3k68hZc3vzA9V1xWtMWrRSZzKBhqiNWezT49mQF4pmURjAtFtQElBXzg5bIFopBLh0QElLOmv4d+0t+uDdZazvAIgOm++xWikfJSbEjTACa7HtTUGWSCoMR+/fgZHnEfU1xeNhJTc0+muyE026drKUkE0PF8/e63DYIBQOU+PpZ5eLlkxtF7OXzeBiYgf4QdY4hwXTwbCRoihUBsThPen+Cx4Ri/OjD58BftLflLBpxtUIbhUFpnagpbMd5qPIteO6S6QD8b7CYvFPMP1xRRPZaF7GD3CE81/jMypnxocfIwFf4QuMwUm4kTMj84ckXs6EPel6fE/YHcD3dt429G3siQe10j1fz5vwjEj/tCFghjBIW9O0YZZC0oVLg5dwjO3JPRKL++MGG7aJGBrW54GzQlqSAfV/9YV7EbvOim/fXLH1wmvkdud2kxHVoRp4nnMhOhBoU32WHa3d9tyRHUOjwbOgWucPUN79MHgJPMh53yxiXaDeHPqqFVXlWmqj7gPrdsyWVnSAKrQXGBIXx9j15B/DKHvGydxJ4+R/hQ5zq1UkMijk5tMd7dI11X5BArABooXV5dRWcn6yWUwpF9+WFiEpJ9bwHPrFx6+y009OiTfTwxGASfiP7hCEHvCQukx5quQ8IK4yc8RwpC25mOm3jnHvXzlnQXCHINQNzUF6a64vzvGPBPzi7s83x2KAUTQZ2gUoZFLuH7nQAWU/qvcwot1AAWoc8ZyqPANkh0h8QXCs7tX7279HbJb+yWiUWEt7fOGizwLSJON0Si1jlnMI5myvQSMpYCCHRb4oSxdm9bR1ZwJpZCNPfTrASEMWzqjPgFxXJKiTNdQu7c6AP8xxnF8xZmBcxDbbSq3hkeqtzKuP00wlb2DzbGLb2jmTqC4kkXRHiL3nCMrlSdT6JIHDkfHYfWfdzOwr8OSBbXIFvaIYVdSwxTDKC
 gj9YASga
 pMo1GjRiQ6g+j7bKHMDlqPWSStiSjCFWYIqLyTBWfNWsincbIyMz1YtklYT5+7LqmS7vZOcUIBlnu/CUq53MnoEFpnYFB+1tJdjAKyXC98PvBRbc9RQG7Et5Zt7KLnfNhfzhLzzft72+Wi+PiTvMJNrvuKWyBvEAGxYex12oqKvorJldUC4nXtucrObZhW8gVpkB82Bw/u7tJ+tzMJ562gZBlmJPueTqC69lZUTbCacAjcHaU2v/qw2Sxq3MEEl/BmHK+9gCHoCEO8qvUQ/9rRxWvCPLpFOm2YuroX5TYWLnsV52iEx9D+HCiog27RWiCLqDtDcQdRAu++F/ag1LMWL/GhIIMTPRictGwZk1JQh08Xhdk6YQIURFoktzE7vRdRo1Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 02:45:50PM +0800, Pavel Tikhomirov wrote:
> If unshare_nsproxy_namespaces() successfully creates the new_nsproxy,
> but then set_cred_ucounts() fails, on its error path there is no cleanup
> for new_nsproxy, so it is leaked. Let's fix that by freeing new_nsproxy
> if it's not NULL on this error path.
> 
> Fixes: 905ae01c4ae2a ("Add a reference to ucounts for each cred")
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Cc: stable@vger.kernel.org 
Acked-by: Alexey Gladkov <legion@kernel.org>

> ---
>  kernel/fork.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3da0f08615a95..6f7332e3e0c8c 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -3133,8 +3133,11 @@ int ksys_unshare(unsigned long unshare_flags)
>  
>  	if (new_cred) {
>  		err = set_cred_ucounts(new_cred);
> -		if (err)
> +		if (err) {
> +			if (new_nsproxy)
> +				free_nsproxy(new_nsproxy);
>  			goto bad_unshare_cleanup_cred;
> +		}
>  	}
>  
>  	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
> -- 
> 2.51.1
> 

-- 
Rgrds, legion


