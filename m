Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D985E668AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5EBB6B0088; Fri, 19 Dec 2025 20:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12D96B0089; Fri, 19 Dec 2025 20:05:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE3B6B008A; Fri, 19 Dec 2025 20:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8496B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:05:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B00A1371C6
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:05:54 +0000 (UTC)
X-FDA: 84238057428.05.96398B5
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 45F86120012
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:05:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qe1wjWu2;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766192752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfLNkGCAF0+g8Lnr0ESMOHhXlA4+J+E6HZL9gx3I48E=;
	b=JX5ZnsjZN4m+Q0cbmyod1aLk0Dd9/YINA66FRqb7a4rKSIw+oZAJTkWzL8lidI91KzvIUx
	0SyQm0+wT8gdNESXEbErmvs+lpQNAZFADMEKcK1RJ0A3koCqQ+y9APwbKgHNCI1hi+7XX5
	ADpLLM9vxTK0uvcnNAP4m/6UXHauCqs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qe1wjWu2;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766192752; a=rsa-sha256;
	cv=none;
	b=HVwfyEDZwenyDnTbdHn3QF5Hhlb/fmd44pRFzlq3JLKAxBBwSJrxyPwfCl5p2gqotFrIEc
	s/KOUkmGi8jfcWvfr7iTgr0KkR4NtxBhc2tl9OQLaivc4W2am/61JkLhGteHwZk5eHCAb0
	R0eujakQaX923Z2oNJoavyO6XQ1l2/Y=
Date: Fri, 19 Dec 2025 17:05:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766192735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SfLNkGCAF0+g8Lnr0ESMOHhXlA4+J+E6HZL9gx3I48E=;
	b=qe1wjWu2ZXycHOf1GXkHnl23q0KLg38QouBXIGvd0M4pC0ZD1tOXAcRAy/uCkYXh7k+F6S
	jzTMdMkhcwzirSsBRSGQdDpXSmVum6lYJpYCGuCq9VBSVJWi82V1pnaHZ9LJf9neFzCR30
	dSW6yj6SFyHQQ9w18Pu8Ntm+7hwh0gQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 15/28] mm: memcontrol: prevent memory cgroup release
 in mem_cgroup_swap_full()
Message-ID: <hvta76slujbvyb4av4cgipcevd7jctjrq2tmyw2pwpynfpjytg@ihr3aqp2brzq>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4dd1fb48ef4367e0932dbe7265d876bd95880808.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dd1fb48ef4367e0932dbe7265d876bd95880808.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gmj5ewn48pagykpp6wti6quuodohfpsc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 45F86120012
X-HE-Tag: 1766192752-833765
X-HE-Meta: U2FsdGVkX19k5DTbZAFXd/TBc5uI++3w0W2hN3tbC3qxk5RnARenoVMvxgNfhGJOfpR2D7YVaUvLGOH9L19e9Djwa91qGGoIR9beZ7tCPCFsddIbR5INBnPUJw0mpx80BHNK8dztkzi07lZC4BR1Olfh99/IkzMdY4zh22zZvI68IQEk/oUkAeoBmNaNDjngqaEVhi5U67BSiy00CBbDM91I7dcrXBpHDOG4r/c08KfB/eX+7p3vzPLIT82HMlsG0PXrbbjguXsBIn/430cTU+v93z4kyl3fM0YreYE3lQeIt7wfS948wqiV3nEhzDwuSNEyqWLi1GR14Lx1Yd1RRW4Ux1Kw+0I6i5gbuzCRJcTxzetOddypo3rZFXHp9uXNLtj5CNpCRQjqAi1rpiamqkiWpx+9/YNT5xRaoKiLBIyow0K4Yh43f0N5E9Nx3CzUaVFaNvVzpvJyGasQHrsjEGmypGF5Ws1Ann1rUdx1eHF9zQHA4L5F7Gt2VdhVS1u5NbzHzUKvoy4nNYr92AOPxoey9lUxH4/BO6oJDUR0vK6JboGCHbetpCEPqR3pXA3vAKoPCiCQO3iwbmEF9fLcAC1cp2MJZp2AwyYbHCQCwtwMxPe2xiSzO0cRdEqiLFq2zsgMVlEjW9C51AtMvSOW2dZ9bWmQ8Dvy8ieyZHj9q8x9g1SLbdgMru+LKf3pwgWxpEqJatWu9wYLVldfm0eUZDD9zJVNhy13efRCk0FmeHhiHdhG/kdUIRmzrE/4nExN2iMz4523SWprpMkvnJfkcHRzpsFZLbDwCppL3zw652YDXaPaRF9xjeMY2bV+Ir4o+VK1BsjcXizUB+pJ42u/kjVGdbbCBJtALbr088GjlhbA7WX+VMuHdFaXvwPjrwAUDfUg+G9SDp4W81/b74kaMoMc5zbjfji/SvRY5dgV6IFZy5KOndf5eCpdaVbyIzVdpFxNrPPEeCsKJXqd03v
 vQG1fb6Z
 79kLykMLjePuacSjP4gnsh7t1TNmX3HbQaAq/iS+rN5ghikFS7BZw2ri1LvOmchUOAQ0Gur2smQByqbyP2+Mk3E2uFC6+hdA3sre+35uufttlptCuP/lN0ucEw03wUCpUvk4HsJpsaTWQAp30+91GJbaFwWNEtpn2mfjK2PCWDI/bwGvGRbYPmSgbeJ36teOkaOEf5vgRC3/lGpvoteCqoz8ZEF5TTYHuCzv0sWV/ZEOsOWyL1XD81sJyHt3LblBDOYqq6SVJsppsSOQ91L93bGXVvg21Madk/zDDXA7KtBy+4L4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:39PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in mem_cgroup_swap_full().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/memcontrol.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 131f940c03fa0..f2c891c1f49d5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5267,17 +5267,21 @@ bool mem_cgroup_swap_full(struct folio *folio)
>  	if (do_memsw_account())
>  		return false;
>  
> -	memcg = folio_memcg(folio);
> -	if (!memcg)
> +	if (!folio_memcg_charged(folio))
>  		return false;
>  
> +	rcu_read_lock();
> +	memcg = folio_memcg(folio);
>  	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
>  		unsigned long usage = page_counter_read(&memcg->swap);
>  
>  		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
> -		    usage * 2 >= READ_ONCE(memcg->swap.max))
> +		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
> +			rcu_read_unlock();
>  			return true;
> +		}
>  	}
> +	rcu_read_unlock();
>  
>  	return false;
>  }

How about the following?


 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
+	bool ret = false;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (vm_swap_full())
 		return true;
-	if (do_memsw_account())
-		return false;
 
-	if (!folio_memcg_charged(folio))
-		return false;
+	if (do_memsw_account() || !folio_memcg_charged(folio))
+		return ret;
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
@@ -5277,13 +5276,13 @@ bool mem_cgroup_swap_full(struct folio *folio)
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
 		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
-			rcu_read_unlock();
-			return true;
+			ret = true;
+			break;
 		}
 	}
 	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 

Anyways LGTM.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

