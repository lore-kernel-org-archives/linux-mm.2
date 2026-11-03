Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1FB606D80B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WKoyMglv
Received: by kanga.kvack.org (Postfix)
	id 460DD6B05BF; Tue,  3 Nov 2026 06:52:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438926B05C0; Tue,  3 Nov 2026 06:52:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376D16B05C1; Tue,  3 Nov 2026 06:52:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1747F6B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:52:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24E5B14039A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:52:32 +0000 (UTC)
X-FDA: 85393645344.20.4688941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D244180004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:52:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKoyMglv;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706750;
	b=BmWVi/zQcknVKkp0OduCC9+0waOe+uAKwUpmy5PmGg1LGJH4YzRP41VBEpB2dokQDM6fgQ
	weBBI+2PbvYV8CH2Cg64AFVHU1s2W8XS3+FhMtPeoeJkT/iDMH+k3JjZ+g612jNMpc4+2l
	NOLgmygSs2J4/3eia1+vzKRUTii72yQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWyW+bGyGveMgmXtKW3uGBlbS+JH67BydEPcZUH8PVc=;
	b=lt2VxWGHmF5kWJkB0r/xPHY+BrlZRylTRjP2vro1aoP2FAlnOejDPQZGclSrtZYyjt9VfM
	JvgT7vYZY+Ji1jmuDo3O6OqaiE9rmZ1pQzuE2bdGPdwHMtf9+J3RQBYJ91W5MloPplzsU5
	FwrkNAg8GyxdGsfTnykIp9HBZdkCnU4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKoyMglv;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93B5841892;
	Tue,  3 Nov 2026 11:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D621F000C1;
	Tue,  3 Nov 2026 11:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793706749;
	bh=iWyW+bGyGveMgmXtKW3uGBlbS+JH67BydEPcZUH8PVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WKoyMglvOchDD2D5K5t6zuBBSTJeqjwBhmAjJHtuQuQrIMQn4TyLXg7poNkpL3+ur
	 ANeQ6Oy1q5X7Z9Hax5cjkJLaLfVpFFW0seUViNrnZaNMjX+4SdA1y+aM0NpktUIJVD
	 mdMxecqUxS3yjrc0yPHtRX2wlQV1cWukiFNUFHuKlPCXDKdj9TamuRJRpNAq0AcRjd
	 89/+N2XmDgCzG6Vay9XiZ5vM5yI4hftxzxHh0I5h9obnt8hFx1cEo17X3xdgt5WGjZ
	 7un3053U62ewJJuIWhJjsN1Or2XFE525Spv39c3D2y9uDWvxOmFvzl/AMlNW+67b8L
	 j4JURwckfmKTA==
Date: Tue, 3 Nov 2026 11:52:24 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] maple_tree: Update internal warning and bug_on
 code
Message-ID: <aunI9hG6Qw8IQ1Uk@gremlin>
References: <20261103020724.2614498-1-liam@infradead.org>
 <20261103020724.2614498-4-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103020724.2614498-4-liam@infradead.org>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: csxzcqic5p5xwc7n8ugff551i5kmc1wq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6D244180004
X-HE-Tag: 1793706750-531442
X-HE-Meta: U2FsdGVkX18hJlFVyiXQlMtTOEVlSK+wdxSO4CAJW5ixma+kvRpz4/hC1VjpaAbBJZUKl/DPXcSZFF0ByBeCOX+nJD9KmNHrif/nImSFKL26ELcNXUf89dq7y/3w/vDfnw86OMNAiIgptrvGhj+Z/gzS3euu38jU8W+IOp1YxU5h2tT9EIaSkwMWJURn90VkRTjDsKvf5SOI4lC4Pzu9nOTRQ3ZbaamMm5BUOZMQgxQ54VARR3auuiyfKXt0nC6Cw5dapvDGjLbZu7W0KjenCBx2OAn5BjLTXSPNKVs8CYZ5hr97IEhSlsK/6x6CcEobKco3NtcIdH7Y8/9xoD0HRCv20R27C7SvZC6PXcc5kLf0N6ksHCv/FjhLWCGCtFElCgjvfDp01frmVFCfXrey8Cv3EH0u5x2HOQYJVYGtusDFv85UVOdGbgVklwokWxQJtNTJkbNhK027SiFwqqoPqiHJPHLoFXQ6ZgwnEwsKdT1+pfnKiGN3Lcn4fyOrkJu/mTpSxwWWppYR/Vszj4obDN0zUm0WRml3pwne6i1FNvRP4eyfatoimGKtjzENXeChcZD1+OHk9uAVm0uy9wLASSP2rWMiigwclQQmidnQ9MK8iMsskZbRRVaRe/vDQvsB5aXjk2VpBfwrWuuKs3++tQcM77CmMrdpf8jHefsT7bgmncRNyMKGkirlrE9JYq+TNiHvtfT2juXUDVRG02EG2TDKGQpGq7zYGuF0IMy2EFQ/vl+nruFrTHF4Z/q0Xwo35pMssyKWJej/dLK8GpO/yljEz9XoHq9xXzGbCS/RPpVfaMKjc1bVug8t4H3rKQORfk46ckCz0H3fG+qu9vTRzdUyEOEvXFOxsBv11V0obLZWPUaygsWTC7BmdW2IvSB795vCu8+qhfezIH+Z+eg36x7ccKEMhmw/sHJxhV/yDwK+LpQOkEIYWuMaftiQybR3YSQB3ezuJrRVr5D5Dok
 eVZRw2E3
 Dm7IZLEwjTtsvjqPpaYIoN/KhMB5zDiCzHSd4IIb+qwHDCnYLqL1mv5j9pSVC6wJqMwqE1G9rrSWaFFoE9m0onbjQFrFE68mCJ0WJl8mEEDL2vNXiPlKrqsmERApAW8zEa7/MZMJ9qjP/JP5nuz0MjiI8WdUjxDocJBRkLeeCYyvms09sCMo/Tg+43Qb7HTBUP6GIDQt8XlrCIH+PvqJIKTc3cOHkpDq/sQj/CV9ipMX/61U5p0kAuQwaebM9e1UjE3AssVOCpesegjy9FMQVlT+DjM520b4r32AGMmufHlaRgPsCGUtaUFTJcrDCm14I6CzT15KHEy3TKq5dnzbkMxSS3qKBy3GCZ4GV2pyN+RMpZathyScUzsJ5TPSOK8je448EMkziAfwxhkK8yBUVJTu4PoJ2+DT6DHbVx6gjchPRHXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 09:07:24PM -0500, Liam R. Howlett (Google) wrote:
> When CONFIG_DEBUG_MAPLE_TREE is set, call WARN_ON() once per site after
> the custom information is dumped about the tree.  Without using the
> kernel's WARN_ON calls, syzbot will not catch issues detected by this
> code.  The BUG_ON variants now stop instead of dumping and continuing.
>
> Update the non-debug code to call WARN_ON_ONCE() as well.
>
> The userspace tests asserted on dump_stack() but only print on
> WARN_ON(), so make WARN() fatal in maple-shared.h and have the maple
> test exit with the result of maple_tree_seed().
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Lorenzo Stoakes <ljs@kernel.org>
> Fixes: f0a1f866aba1 ("maple_tree: add debug BUG_ON and WARN_ON variants")
> Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>

Thanks for doing this! This covers off my concerns with the userland testing
changes so all LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/maple_tree.h          | 48 ++++++++++++++---------------
>  tools/testing/radix-tree/maple.c    | 13 +++++---
>  tools/testing/shared/maple-shared.h | 33 ++++++++++++++++++++
>  3 files changed, 66 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index e30e57f5f3df9..3a9751c6689fc 100644
> --- a/include/linux/maple_tree.h
> +++ b/include/linux/maple_tree.h
> @@ -680,7 +680,7 @@ void mt_cache_shrink(void);
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> +		BUG_ON(1);						\
>  	} else {							\
>  		atomic_inc(&maple_tree_tests_passed);			\
>  	}								\
> @@ -696,7 +696,7 @@ void mt_cache_shrink(void);
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> +		BUG_ON(1);						\
>  	} else {							\
>  		atomic_inc(&maple_tree_tests_passed);			\
>  	}								\
> @@ -713,7 +713,7 @@ void mt_cache_shrink(void);
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> +		BUG_ON(1);						\
>  	} else {							\
>  		atomic_inc(&maple_tree_tests_passed);			\
>  	}								\
> @@ -722,16 +722,16 @@ void mt_cache_shrink(void);
>  #define MT_WARN_ON(__tree, __x)  ({					\
>  	int ret = !!(__x);						\
>  	atomic_inc(&maple_tree_tests_run);				\
> -	if (ret) {							\
> -		pr_info("WARN at %s:%d (%u)\n",				\
> -		__func__, __LINE__, __x);				\
> +	if (!ret) {							\
> +		atomic_inc(&maple_tree_tests_passed);			\
> +	} else if (__ONCE_LITE_IF(ret)) {				\
> +		pr_info("WARN at %s:%d\n",				\
> +		__func__, __LINE__);					\
>  		mt_dump(__tree, mt_dump_hex);				\
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> -	} else {							\
> -		atomic_inc(&maple_tree_tests_passed);			\
> +		WARN_ON(1);						\
>  	}								\
>  	unlikely(ret);							\
>  })
> @@ -739,17 +739,17 @@ void mt_cache_shrink(void);
>  #define MAS_WARN_ON(__mas, __x) ({					\
>  	int ret = !!(__x);						\
>  	atomic_inc(&maple_tree_tests_run);				\
> -	if (ret) {							\
> -		pr_info("WARN at %s:%d (%u)\n",				\
> -		__func__, __LINE__, __x);				\
> +	if (!ret) {							\
> +		atomic_inc(&maple_tree_tests_passed);			\
> +	} else if (__ONCE_LITE_IF(ret)) {				\
> +		pr_info("WARN at %s:%d\n",				\
> +		__func__, __LINE__);					\
>  		mas_dump(__mas);					\
>  		mt_dump((__mas)->tree, mt_dump_hex);			\
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> -	} else {							\
> -		atomic_inc(&maple_tree_tests_passed);			\
> +		WARN_ON(1);						\
>  	}								\
>  	unlikely(ret);							\
>  })
> @@ -757,18 +757,18 @@ void mt_cache_shrink(void);
>  #define MAS_WR_WARN_ON(__wrmas, __x) ({					\
>  	int ret = !!(__x);						\
>  	atomic_inc(&maple_tree_tests_run);				\
> -	if (ret) {							\
> -		pr_info("WARN at %s:%d (%u)\n",				\
> -		__func__, __LINE__, __x);				\
> +	if (!ret) {							\
> +		atomic_inc(&maple_tree_tests_passed);			\
> +	} else if (__ONCE_LITE_IF(ret)) {				\
> +		pr_info("WARN at %s:%d\n",				\
> +		__func__, __LINE__);					\
>  		mas_wr_dump(__wrmas);					\
>  		mas_dump((__wrmas)->mas);				\
>  		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> -	} else {							\
> -		atomic_inc(&maple_tree_tests_passed);			\
> +		WARN_ON(1);						\
>  	}								\
>  	unlikely(ret);							\
>  })
> @@ -776,9 +776,9 @@ void mt_cache_shrink(void);
>  #define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
>  #define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
>  #define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
> -#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
> -#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
> -#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
> +#define MT_WARN_ON(__tree, __x)		WARN_ON_ONCE(__x)
> +#define MAS_WARN_ON(__mas, __x)		WARN_ON_ONCE(__x)
> +#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON_ONCE(__x)
>  #endif /* CONFIG_DEBUG_MAPLE_TREE */
>
>  /**
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
> index bfe4b8626c429..846c67e20e82a 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -36502,22 +36502,27 @@ static void regression_tests(void)
>  	test_spanning_store_regression();
>  }
>
> -void maple_tree_tests(void)
> +int maple_tree_tests(void)
>  {
> +	int ret;
> +
>  #if !defined(BENCH)
>  	regression_tests();
>  	farmer_tests();
>  #endif
> -	maple_tree_seed();
> +	ret = maple_tree_seed();
>  	maple_tree_harvest();
> +	return ret;
>  }
>
>  int __weak main(void)
>  {
> +	int ret;
> +
>  	maple_tree_init();
> -	maple_tree_tests();
> +	ret = maple_tree_tests();
>  	rcu_barrier();
>  	if (nr_allocated)
>  		printf("nr_allocated = %d\n", nr_allocated);
> -	return 0;
> +	return ret ? EXIT_FAILURE : EXIT_SUCCESS;
>  }
> diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
> index 2a1e9a8594a28..5f827709773a0 100644
> --- a/tools/testing/shared/maple-shared.h
> +++ b/tools/testing/shared/maple-shared.h
> @@ -8,6 +8,7 @@
>  #include "shared.h"
>  #include <stdlib.h>
>  #include <time.h>
> +#include <assert.h>
>  #include "linux/init.h"
>
>  void maple_rcu_cb(struct rcu_head *head);
> @@ -20,5 +21,37 @@ do {                                            \
>      call_rcu(&((_p_struct)->_memb), rcu_cb);    \
>  } while(0);
>
> +/* Make WARN() fatal */
> +#undef WARN
> +#undef WARN_ON
> +#undef WARN_ONCE
> +#undef WARN_ON_ONCE
> +#define WARN(condition, format...) ({				\
> +	int __ret_warn_on = !!(condition);			\
> +	if (unlikely(__ret_warn_on)) {				\
> +		__WARN_printf(format);				\
> +		assert(0);					\
> +	}							\
> +	unlikely(__ret_warn_on);				\
> +})
> +#define WARN_ON(condition)					\
> +	WARN(condition, "assertion failed at %s:%d\n", __FILE__, __LINE__)
> +#define WARN_ONCE(condition, format...)	WARN(condition, format)
> +#define WARN_ON_ONCE(condition)		WARN_ON(condition)
> +
> +/* Once state for the debug macros */
> +#ifndef __ONCE_LITE_IF
> +#define __ONCE_LITE_IF(condition)				\
> +	({							\
> +		static bool __already_done;			\
> +		bool __ret_once = false;			\
> +								\
> +		if ((condition) && !__already_done) {		\
> +			__already_done = true;			\
> +			__ret_once = true;			\
> +		}						\
> +		__ret_once;					\
> +	})
> +#endif
>
>  #endif /* __MAPLE_SHARED_H__ */
> --
> 2.47.3
>

--
Cheers, Lorenzo

