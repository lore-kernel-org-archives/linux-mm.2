Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D94D74960
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 07:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028466B0088; Fri, 19 Dec 2025 02:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE2A6B0089; Fri, 19 Dec 2025 02:04:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC146B008A; Fri, 19 Dec 2025 02:04:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C90F26B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:04:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C10E13B0A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:04:46 +0000 (UTC)
X-FDA: 84235332972.23.4631122
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 90A1516000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:04:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TOr918U1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766127884; a=rsa-sha256;
	cv=none;
	b=XQTHA7R8sA1/GzADU4eU/N1b38lm/0/4j3i82vUrmZp7N/Cbtwlyzx9gFTHsUeS5eErgkX
	iCwl2DXfzJKx709lJkEcNclJ/xLHwQQpRn0Lp1UqAaRs5+CUzzXFJV8RoBiwMXmnAsgd2X
	6aFET7zzll+DMUUpJdImjaTt2jFKX84=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TOr918U1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766127884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8pIRHj989/yP044y8FmVi5laJrkIYribs4FwH/K2J0=;
	b=csB0H0lKa1Tx2DCMk+X9h1F6NK2AjuURFd5zX2WCMWBqPzyS4g3ihladYPh6cIVmC1xrgv
	oDvaSpaTZkcwGsukQMabNz7maDnQZS74SnHS49pMfTph+8bgwJDbCXmpzZZZY97w7mN20V
	40tQzNQt0rmJMsTgLQdsHlJahqxlN/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B61243589;
	Fri, 19 Dec 2025 07:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AD3C4CEF1;
	Fri, 19 Dec 2025 07:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766127883;
	bh=7pM3pg1E+9Zhsdy3FeEbki6cuZHG9Wz4UgMWqEJpnNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TOr918U1kBoZTAW5Zj1HzhhsHwDFWVt795xvXCPwfM6E+PyiG9LY60zL1vfEb0RGX
	 BOaVX40lZQaLWgAaghTz47Y8D2PAj338vLnd3yeAWHOH1xeiMIUP+VwqxG8iazyZRz
	 DllbqGBkxwWKORxC/b4IqP0Y1gLEm0VHXomya3cgfHlvpuNMFSMTpj319w01wgL7d9
	 TZ+J64XgCH7cmGJphFXXy8eAQN/cSbo6xtLpsWrXG+LJM6bJT27gvIBlX8jvjwsfcv
	 jJDcoFzBbJyhf2ayhVy9BIG7iR4VmxYCQXn1zbDN7yxY3Qelg8xMTnKCpHtQsgPeh/
	 sHhI61OJzC5sg==
Date: Fri, 19 Dec 2025 09:04:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
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
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fork: Replace simple_strtoul with kstrtoul in
 coredump_filter_setup
Message-ID: <aUT5AsR_0G4GaGAf@kernel.org>
References: <20251215142152.4082-2-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215142152.4082-2-thorsten.blum@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90A1516000E
X-Stat-Signature: gcoubgkisncg1yrn7ffdx84yhhguy8qo
X-HE-Tag: 1766127884-565752
X-HE-Meta: U2FsdGVkX196c9HkbUmZCOI3E5kcT4gK9LihoulcU3LWVUXGJViefsoX5UqiQfbe8sXNMTCHUXgpkH1rp60X2jXC4ZVXpZd1dGZH9NBDwmgK3yFeB8I+aofs8CuHfnZYzDm9qyPsE0JBB18GOLHvdcGe4I996Ge9Af3KPYEjBhCNG5yGw7R9eCC0bJET43FHBv+4tmu9TER0m62WcHH1IiiepNm1nvv7JlfzFA4LVmL4gMNyYHXM0Aszn7JgWwozHQrBgUTwMzyYiPYcR4hv1xQiBxCKmkPco9AKCFtl3BY0oZ3vmXsgb+onmYFgqBI3UqeHvxyn0d3a8/+ej0K118IdEHjwwNmLxLN/uX7WiC+qZ+Pp0jha8ZJPG/pBHQ6ZL6yspIhJ5aCW4DSjG42/piPnL4VBwLC3ES9Tfox/5FmyMbZY309+NHcwU4pA13VGwaHdxmtgxYKbE/lFcvWgUV9lmvNCLUT+PwxVaTMcN6EUoGMgm64CMgAKd9WyzqIsjN6gKemhyE1hL+AzEeFRJ1vf2gtDz3zD3EdRXkNM8qid7oa31oPQmfwW5luuzXbk4sRXBru0cCAJCqOq+uvfp5XkF0KeDkK1DI9KXbYl0U6aVkUJO+anT7NW6BbXuARtupiVYX5Iab2Fj219PEbK+9OUor6IArXY0FULzWIESf2URXKaztro+hv9fl6lUT0xTp6D59WexQ6267+2AaED4959GOWfawCkW76qPZhJx2IB6VCRA1ppNZopFH1Hn7mhwvvbdoICfpB8wA62ZVhq7MOXqGUyw5aCdP2VDAvqwrCrzDwbW6ljx5BtmhTjLAWW52nLsso+O6p3CzQLQ6Li7UKlYsLy75VAqMFLdNfjbqW7ZNaRQFvSARr9ylQW+dMfZMBSRqWjWLMp1kS2aKEPKnmPH2LIdmI7cuRl2vbNJVWJ6O4tLzb7A7gSlkjdlgyjBFn5+iLA2mtjBVmR3fq
 nQDm66dw
 KmGtBf/z65nzi8nnMMZgtpADy4vBHuwMKdzH/HHc18oDLWJDCip1smCbyPT6ZnM7nrasyrUlOtt4k/OrCgAL1jUeacLbA/6a0EI85z20J1cD9gys/HAKR5zw/sp6LrlOBMYD7kaX1egm0P754IvZLf3oUA9FAHc026Sx/38m2OCCkTpy9dqOwQrKH5tKEvspAf/YnzvSX+BHTk+8OeSe9BVhNSk0Z9sF3Ui6YPHDleQBlj3Mz5Bjd4hnqByaTTwnibJVv1UAZNu5VqSfvySHV+PzanJn7WuKOsSmlSt9aNuqCnRVQ39jVxpNL/M74eMUlhTGpU6QJtolV0aw9gVvkThDWUNAFlbtOd3dGe8osQAzaLec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 03:21:52PM +0100, Thorsten Blum wrote:
> Replace simple_strtoul() with the recommended kstrtoul() for parsing the
> 'coredump_filter=' boot parameter.
> 
> Check the return value of kstrtoul() and reject invalid values. This
> adds error handling while preserving behavior for existing values, and
> removes use of the deprecated simple_strtoul() helper. The current code
> silently sets 'default_dump_filter = 0' if parsing fails, instead of
> leaving the default value (MMF_DUMP_FILTER_DEFAULT) unchanged.
> 
> Rename the static variable 'default_dump_filter' to 'coredump_filter'
> since it does not necessarily contain the default value and the current
> name can be misleading.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/fork.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b1f3915d5f8e..f33ee7fe53ad 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1012,13 +1012,14 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>  
>  __cacheline_aligned_in_smp DEFINE_SPINLOCK(mmlist_lock);
>  
> -static unsigned long default_dump_filter = MMF_DUMP_FILTER_DEFAULT;
> +static unsigned long coredump_filter = MMF_DUMP_FILTER_DEFAULT;
>  
>  static int __init coredump_filter_setup(char *s)
>  {
> -	default_dump_filter =
> -		(simple_strtoul(s, NULL, 0) << MMF_DUMP_FILTER_SHIFT) &
> -		MMF_DUMP_FILTER_MASK;
> +	if (kstrtoul(s, 0, &coredump_filter))
> +		return 0;
> +	coredump_filter <<= MMF_DUMP_FILTER_SHIFT;
> +	coredump_filter &= MMF_DUMP_FILTER_MASK;
>  	return 1;
>  }
>  
> @@ -1104,7 +1105,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>  		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
>  		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
>  	} else {
> -		__mm_flags_overwrite_word(mm, default_dump_filter);
> +		__mm_flags_overwrite_word(mm, coredump_filter);
>  		mm->def_flags = 0;
>  	}
>  
> -- 
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
> 

-- 
Sincerely yours,
Mike.

