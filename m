Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADFCCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7A790010E; Thu, 14 Aug 2025 04:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8311C900088; Thu, 14 Aug 2025 04:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7213A90010E; Thu, 14 Aug 2025 04:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58B0F900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:29:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 089E6B862E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:29:58 +0000 (UTC)
X-FDA: 83774690076.25.9D8B071
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf15.hostedemail.com (Postfix) with ESMTP id 871B4A0007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:29:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgnI8UJS;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/N87r7AvttBbb+GEtqIoqhSKBVDPnT60mwgsenkkwE=;
	b=2G/L2A7i4CEyUpHo7UkB2pG5wtxPABPcGLy8gNDISGNY/Nl0pxrrIbX8Oq3Fy/g01S3/Lk
	4P3cfXLLZ9yGc0JsmKD+awIRMSrbRheKlh4LRp5I1T0UH62Ez+kS2BsQC+7cEv1Z25zFFA
	l/wPNRRyr8/RVHLuuiG5UYomfIEDQ+o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgnI8UJS;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160196; a=rsa-sha256;
	cv=none;
	b=kDQ4U5mKGCyXp5KvmEounEHKzgQaF6W3FzU40m4DClAmJx3AlhhDFr9yHPWSGxxOo9oynL
	psPqUNQeV6qGr6XTu5fwEi6g4gJCIT5Y5kAKWpPNj6RVA3G7MjzTBTmlL6yk2e443+UXsP
	/hT6NYMcMx3u70mCrq/Cz0tnKw4zvD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 9FBD25C5849;
	Thu, 14 Aug 2025 08:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1718BC4CEF5;
	Thu, 14 Aug 2025 08:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160195;
	bh=KdLgrtVpCnwmqBeEbXly/JQKZu+/Bf7kGD89aJGLLrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LgnI8UJSan+/NDSjk/Hl6AHksZNLCBmMyv7I6ottubTebiQRbsUfEbvIDnPI6gGb7
	 x6rD9peFnW3ZpIMR/9Sw0NCDT/TKaw9GCiZc5Tm55FyMr0EYl45K+764RG3cFz4fI/
	 AYu79A9WpUjtQRiQiYwZLHdOe36W/DJFoXdujFFfoxqO1zQwgTwyMW95wnwzWMRGVr
	 0ubAitkieacSV3z55Tv/q4eaRXLfMTuzFwh8g6rWiKGYF65msy96rF5AvL2JMO4N+f
	 hg4dAgcVfmh7oQtvcI/niV+/kdkNa8Z2tAOU4/svTc/b8E/uoCdmMTFgfc2wSMzcYB
	 qGs/EbpySPCPw==
Date: Thu, 14 Aug 2025 11:29:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 03/10] mm: convert prctl to mm_flags_*() accessors
Message-ID: <aJ2eaB_mguqgpJfb@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <b64f07b94822d02beb88d0d21a6a85f9ee45fc69.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b64f07b94822d02beb88d0d21a6a85f9ee45fc69.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 871B4A0007
X-Stat-Signature: qe1xq3e73cumhitx1pg6rjfqbbmff1py
X-Rspam-User: 
X-HE-Tag: 1755160196-210286
X-HE-Meta: U2FsdGVkX1/kqE1SB/XUvUJyHZOJ3TN3MoYidKGzAOerkL46FEsBjdWluyBl46u/1SIXp6ljg1STD2juTIksQ8zLrGzAXX5VPE0QrS0g7ZYZDWjbC8S0P7m3rq6dwt/LHbFFsgrF/RGcgk9/NDA8df2Kv/WeZoGGGZ532YbYeLotqhScpVk1XHrsTOsu7qUYRXfZeSR5w87g36OlEigDCcgRcOYoCgvM0y53alH2oO0XZW0wT00np/fPHhcB7JNHiGmcMnSj32A2zT0ICsGC9g7Yo/jiOXw8tD7XwdFV7XncrflQEl+byc6XBsElXTLpWMKhX1nVCXvyp+FgjCJnsFhiMdthSRhVrh/Z68/hlfTW5HVy5sEwYwCMJ6U5pDcvBlBLKLUlojXjgjw3ek9p+QlbupG795498lZsM2odhMHenr/8B29/+uId+ymi2mnItQ1AjTpJcM/mpod5juwWyuDvXGXpxcbf2r2wID5N9LLTEpZUKRE0Nn/S5+pZwGL3J5gYSM5bA4gwUjQ73NcOLI2qvDyOCg34iAAJURGXz87AM8LfYy02KL+hatYcuvN5H+JNXF8vwsNaAJ2pttT+pmXY4BsvGSvKrE/1mLVlKWm0WoHXNpEHBWcKJHQKlu9+hnpbQ/fXJv/ZXSRB2xIwOsP5KCa/iZX/DkNLe6KtFYDwP+G1lDxctBRM2Ydh/2z9EndoW6S+JnagXrB9XoQN4o9eNYfY7VSBjAw0Bzxhd6JpRQmp+rQ6WBoUp5j0LiwVUSpBdNLD7tMsX3qSHnlP9hfpMlpm6+LuXU2bGawHn9GlGcEiPj+GcovsOPqZ88clr2tiZ5tOyTJJxL6ISP+hm1mDV+ih77Cs4mmZs3naeU+4PbdOYiuQ7tejr5DRSXu4o8/fXqPkF/fuYPsfyyF1Hc53OwyjBZNrvV2P6Yqtv+Q1mEXoOZrkLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:12PM +0100, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/sys.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 1e28b40053ce..605f7fe9a143 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2392,9 +2392,9 @@ static inline unsigned long get_current_mdwe(void)
>  {
>  	unsigned long ret = 0;
>  
> -	if (test_bit(MMF_HAS_MDWE, &current->mm->flags))
> +	if (mm_flags_test(MMF_HAS_MDWE, current->mm))
>  		ret |= PR_MDWE_REFUSE_EXEC_GAIN;
> -	if (test_bit(MMF_HAS_MDWE_NO_INHERIT, &current->mm->flags))
> +	if (mm_flags_test(MMF_HAS_MDWE_NO_INHERIT, current->mm))
>  		ret |= PR_MDWE_NO_INHERIT;
>  
>  	return ret;
> @@ -2427,9 +2427,9 @@ static inline int prctl_set_mdwe(unsigned long bits, unsigned long arg3,
>  		return -EPERM; /* Cannot unset the flags */
>  
>  	if (bits & PR_MDWE_NO_INHERIT)
> -		set_bit(MMF_HAS_MDWE_NO_INHERIT, &current->mm->flags);
> +		mm_flags_set(MMF_HAS_MDWE_NO_INHERIT, current->mm);
>  	if (bits & PR_MDWE_REFUSE_EXEC_GAIN)
> -		set_bit(MMF_HAS_MDWE, &current->mm->flags);
> +		mm_flags_set(MMF_HAS_MDWE, current->mm);
>  
>  	return 0;
>  }
> @@ -2627,7 +2627,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  	case PR_GET_THP_DISABLE:
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
> -		error = !!test_bit(MMF_DISABLE_THP, &me->mm->flags);
> +		error = !!mm_flags_test(MMF_DISABLE_THP, me->mm);
>  		break;
>  	case PR_SET_THP_DISABLE:
>  		if (arg3 || arg4 || arg5)
> @@ -2635,9 +2635,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (mmap_write_lock_killable(me->mm))
>  			return -EINTR;
>  		if (arg2)
> -			set_bit(MMF_DISABLE_THP, &me->mm->flags);
> +			mm_flags_set(MMF_DISABLE_THP, me->mm);
>  		else
> -			clear_bit(MMF_DISABLE_THP, &me->mm->flags);
> +			mm_flags_clear(MMF_DISABLE_THP, me->mm);
>  		mmap_write_unlock(me->mm);
>  		break;
>  	case PR_MPX_ENABLE_MANAGEMENT:
> @@ -2770,7 +2770,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  
> -		error = !!test_bit(MMF_VM_MERGE_ANY, &me->mm->flags);
> +		error = !!mm_flags_test(MMF_VM_MERGE_ANY, me->mm);
>  		break;
>  #endif
>  	case PR_RISCV_V_SET_CONTROL:
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

