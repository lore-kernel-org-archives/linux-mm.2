Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB74CA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 13:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADA98E0005; Sun, 14 Sep 2025 09:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985BA8E0001; Sun, 14 Sep 2025 09:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C29E8E0005; Sun, 14 Sep 2025 09:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDA68E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 09:53:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FFD0160322
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:53:23 +0000 (UTC)
X-FDA: 83887997886.16.160B1F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47C15120003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:53:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hm3bsaZn;
	spf=pass (imf29.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757858001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UT3BD6f28q3caqcvv9tNqfI2EwehMhyKTfYqk9PWNbc=;
	b=6sPIxD/JghSmuaHNnv23CpKDQNiOSGpAinfJA7PWVOod9K7FAsVIisx8ZfyRM9YucRFgSF
	j1cbiZSfU/DzcZhsEqpV1EoaQ3r7Eynr44x36fbvYHbDNNOnqCUmdYB1rYCCmq+lTmyP1r
	oa3A7SYxbjgjEHUaww7iaMruqQcCIB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757858001; a=rsa-sha256;
	cv=none;
	b=C2DHlIvfltwIK7ESPSzQvcdhsP4H8IC7U9fSH9rV85q/ptZBtB/9GLDqoyPkUbP4XNwxOR
	H4PtP9hvkiYTqx5tm7lRxv+VCLiC7A4aEEYwe+ST+Fa0cj0ZrRyDAzn807VAUlTxyExv1o
	erb9SwOzt1oxx93ZkB0GMBNVyY57ebc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hm3bsaZn;
	spf=pass (imf29.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43C26404B0;
	Sun, 14 Sep 2025 13:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F0FC4CEF0;
	Sun, 14 Sep 2025 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757858000;
	bh=Up9Xu/CJoHEjUcchIJsyeiW2UaO4s1K1qCNgKItusWg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Hm3bsaZn2JvvJqxIY9S3ulwLpYVfges3Vprs9UKDgleuWKeb0EAYJrz6RKDtsItTD
	 2awMaKPZ+wOkswbhdv1+Wwe5OwP87TII+h6gIlFDrCBOG8/KpDgNBNgrqurUJrGwwj
	 1s28FU0H0CT4SdxvYS/av7lUhVE5zGQfFumGB0hGhZkHAtQeoLqiQd510v1PnFXFiK
	 YqZukWPqiKIe+x6kKKokwvL0KeD8SzvtJl5oA+wult90ARlAMp2b1Z2jJJd07f11YD
	 Vpe354oAqwdIWbmOkSkRqziYY5oO5Sho7Uc6n4G6FGbr0zo7SEsStdW68E/vgiMwDF
	 FdRnhA7K5BHNA==
Date: Sun, 14 Sep 2025 22:53:06 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>, Alexander
 Potapenko <glider@google.com>, Jonathan Corbet <corbet@lwn.net>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Sami Tolvanen <samitolvanen@google.com>, Miguel
 Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, Rong Xu
 <xur@google.com>, Naveen N Rao <naveen@kernel.org>, David Kaplan
 <david.kaplan@amd.com>, Andrii Nakryiko <andrii@kernel.org>, Jinjie Ruan
 <ruanjinjie@huawei.com>, Nam Cao <namcao@linutronix.de>,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-mm@kvack.org, llvm@lists.linux.dev, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry
 Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 kasan-dev@googlegroups.com, "David S. Miller" <davem@davemloft.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/21] x86/hw_breakpoint: Add
 arch_reinstall_hw_breakpoint
Message-Id: <20250914225306.2185b79065e32f60a40ef54c@kernel.org>
In-Reply-To: <20250912101145.465708-3-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
	<20250912101145.465708-3-wangjinchao600@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47C15120003
X-Stat-Signature: ebf5bddemarkk8ycug9foh59atx6t7rb
X-Rspam-User: 
X-HE-Tag: 1757858001-369496
X-HE-Meta: U2FsdGVkX1+cnSNSNAFnD9Gtnww14RB3HVsoBiW4ZydkVsgCN6d0XmF1wSNqHxTU5FST0D1j7tW8V0XUo/U2SWfEuAC2k+fR1SlJKQl6X6Synb1CkzS8KYuWhA5o6wGFWEC8zSa34kCgHxdRP8sJLaNMWzqyqCGaJGTYQX7z0pezbX+hHu91xUkh4yGJrw6lZ9Jq8Xvq4rR0RhzFVdRVZN98eaCvB6dnGS/0PRO1CLWMZ18ZFWnUryx+/DgpqfJJUhkn2Jiygzs6xJToT9/iffCF7LMyfLM9Y19h4cQEg4jkmbVJDocwBqn2blh44tKFTWKSNuIGHk9SZB0iI4nkcSOYCr7hEW7kXepgS79Y4TLMzRTHyxbCPIQnBNDK5Y9RnOa6B4Hyr5lwVe62HtWh/rSk9CDmLvCbGufS5B6v+E4BoX/ReUUrz3fXVufuSEIYj5xzDvNc2jDnhQiSv0HhwQwRbCgk1kfM3rMCCTKVtv3uoHMK3UhjazNBCnCecGGn2HGi4ws+xLKmpOvtai0713sDIXclThsKAwNNzYAWIipB8Dvgd4M0lcXYu62XFX0K8edVdmkxz5gGbVim2yiI6tpuAUDkgpR8GM4EbDJuPw45OL78i5XiweaSGwK/e69rk4CrAK66/liRy9+W6pI7R+A1cK+PyHt3wEtg+smRq6twt5cfIimJB9SYbxn2hjUdUX7J4ouotf5/cfddSiefU/tEoOsFtXK6fRO7vx2lkcnNv6aqgkw4lcMbgyjbJ2DMElI6Yacm3MrC9jgAOLKnCgRmOc8Vr9arS+YD/l54TNRjVzJkOIQe23sRTPEk21mRFfd2b1rf0SVuHfj3tB4XNlQa8saD8/RfAZz7eSJBDU5fl5gxOWtOSlOy+RFpYiJcT9f6OLyWflPgEse+7QUybyy4+HzbICORQfeFCZG9MQJYZwjzaNxmU1shj0OrgTFjUyqnAO/iZbOvWghpCI1
 oDulvVsc
 HNrYeoEXyYcM1ggLTF46Y2eux9C/8Sopq+2rScC2K5s72a9VVwtVAcYhDBDa137E9hPeq+5KHPg5aR6zTqaYNF5tXYijc1nQcD5XCCynMRdIX20VS9YSxD5yGXxn4Z8rx5eEWGpOwbcdzc25aKCBjkk/9/rjpkWBMwLXQgRjgFj5xU/eyDBSKFISWjn8hLEO1hWQ4V20g25iksFRjFyX2TGWnbaWFeZF6KScBT0GSGB8Jvu9DeUE5xQlRuPmWtln/8Rjk33ekkm8sF82HOJOxi46ZdT5Ig7iJQbG7aaKBPN2wI40zoDlscZ7gHn1MJcRY6Elmno5YBE1tUm0Pmywp7o32HwBy3NNpwuyR3W7RW28bEAVU6CZKr+Xnb7ANRwv8NeJBoj9RG35Grdj8k7Du+JfYSrPkQ+3vItQO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Sep 2025 18:11:12 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> The new arch_reinstall_hw_breakpoint() function can be used in an
> atomic context, unlike the more expensive free and re-allocation path.
> This allows callers to efficiently re-establish an existing breakpoint.
> 

Looks good to me.

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks!

> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  arch/x86/include/asm/hw_breakpoint.h | 2 ++
>  arch/x86/kernel/hw_breakpoint.c      | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
> index aa6adac6c3a2..c22cc4e87fc5 100644
> --- a/arch/x86/include/asm/hw_breakpoint.h
> +++ b/arch/x86/include/asm/hw_breakpoint.h
> @@ -21,6 +21,7 @@ struct arch_hw_breakpoint {
>  
>  enum bp_slot_action {
>  	BP_SLOT_ACTION_INSTALL,
> +	BP_SLOT_ACTION_REINSTALL,
>  	BP_SLOT_ACTION_UNINSTALL,
>  };
>  
> @@ -65,6 +66,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
>  
>  
>  int arch_install_hw_breakpoint(struct perf_event *bp);
> +int arch_reinstall_hw_breakpoint(struct perf_event *bp);
>  void arch_uninstall_hw_breakpoint(struct perf_event *bp);
>  void hw_breakpoint_pmu_read(struct perf_event *bp);
>  void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index 3658ace4bd8d..29c9369264d4 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -99,6 +99,10 @@ static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
>  		old_bp = NULL;
>  		new_bp = bp;
>  		break;
> +	case BP_SLOT_ACTION_REINSTALL:
> +		old_bp = bp;
> +		new_bp = bp;
> +		break;
>  	case BP_SLOT_ACTION_UNINSTALL:
>  		old_bp = bp;
>  		new_bp = NULL;
> @@ -187,6 +191,11 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>  	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
>  }
>  
> +int arch_reinstall_hw_breakpoint(struct perf_event *bp)
> +{
> +	return arch_manage_bp(bp, BP_SLOT_ACTION_REINSTALL);
> +}
> +
>  void arch_uninstall_hw_breakpoint(struct perf_event *bp)
>  {
>  	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
> -- 
> 2.43.0
> 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

