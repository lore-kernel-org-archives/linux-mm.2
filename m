Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A31C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F359C6B009B; Mon,  7 Sep 2026 07:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE56B6B00A0; Mon,  7 Sep 2026 07:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4676B00A1; Mon,  7 Sep 2026 07:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9E5C6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:05:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E13C40128
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:05:22 +0000 (UTC)
X-FDA: 85186684884.06.60DF7AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACB9D1C000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:05:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PoyOKEVN;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788779120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJW6MPhOnN8P0SEk/mBUWKuIt9Xcv/RQpni+Df40/kY=;
	b=m0uTfpjmkTy913KRL7MfX7io2soYGz4n1MrmzddmTO1Z4V1Z3BfkTHCv3byiDYs3amXPXG
	dWDl88yST5rmiiFCw/fWUoQzB2MkWiMTdr4U5MOn8zXbw5Y0owMaPuld8oodOXofJasyEr
	tUkSnYkRlm1ekitXEMHOP3cYGFUB7fo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PoyOKEVN;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788779120;
	b=pDvR4C17FVa/2A6nECaB5oK963FEmRlyEuGbDDLYFIymlRvNUCX6tzQDNIT/UFZOTAggpw
	zUG2WUKAqqerkAzjBdRgHQq4oYov4i/0s0J068Cc8V10ag7pSCgimMSfDaLZ3Ove7KjMyc
	6eLjSrKzS6oQyJ1ZjxCQI6IM+ys0ePY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45023601F9;
	Mon,  7 Sep 2026 11:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716671F00A3D;
	Mon,  7 Sep 2026 11:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788779120;
	bh=vJW6MPhOnN8P0SEk/mBUWKuIt9Xcv/RQpni+Df40/kY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PoyOKEVNRy4VXTHA+NBiLBYDZc6Sblto8Kaz7UsiOV0QrOkd+U6KphTUovSDNjhCz
	 q7m+nudOTVg3uWbyUbQ1K/0rmRM9xZxyvl43eHr+m/KaV8/+Bt+iJP1qA+qLRmwqhY
	 kfkrd57WJ4utnJF9Yh+A7rU8ghy9VxqBexyWkFemv+rw9RK9Yx+kL/BjPy8/0iVJlH
	 fxK3oXlu/CBuDfkAR/y75njkvq7DNeDTYUABFhtRrfHzBERdZHQzIwGgUnsJnZN8fb
	 r6NYrwXxiUhaMsRCpUBMelI1o26+9ocIx7No45lfOZwm841rcd19HgskuKzFteika5
	 sC5hUTUEN4gvA==
Date: Mon, 7 Sep 2026 12:05:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>, 
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org, 
	jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, tglx@kernel.org, 
	david@kernel.org, nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com, 
	sj@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, frederic@kernel.org, 
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, tony.luck@intel.com, 
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org, 
	pmladek@suse.com, longman@redhat.com, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, dietmar.eggemann@arm.com, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 4/8] mm/memory-failure: convert process iterator to
 for_each_process_rculock
Message-ID: <ap6aWlC9RoAMILb7@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-5-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-5-ye.liu@linux.dev>
X-Stat-Signature: ghh1kh8ijwk84jqqdgtspbds8ncci1ce
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ACB9D1C000C
X-Rspam-User: 
X-HE-Tag: 1788779120-894910
X-HE-Meta: U2FsdGVkX1/GTbNVfyI9QaoomQAvXEyLirLd4OvEziM3b+w+UMQcbI48mu9Bf6/RTti3NgBR5FmdgXzG588mN4Nc45OxJnNhtMdEEM7yNlPbpyPb2dHlWRk740aNvuDxrmkkl8lwh0mecw9LSP6c1f4GEq1gxOtnrJHxasfVScjaH3Uq676SF8LbSiCqBtzYsGBN129byG2QJ9UpSv+dj/2+GLGm3StFBJwesz2tGmIG3/Tqnedd5BNHoPjMYNu6agvBghyosRrQhJ56+WTlc9h3kQmuPIjaE1qlbZA6NeCmbYHEvkMSVOMnF6y0F9Iw6xEyjfZsbiNdw2Zi2xxvfa7f3Sujhk0lSocZO10kPqVi8KtBnACbjapCY6XG/Tyohup5+u4YfSDb+ZAC7wPDMccR2Fcg3VT5vh+0tSc4ckN5ce7wBHV21Y5Ro9yJ2YQMPSK1xiD1edpE0kjhcO7exOYVItgTethVcxy9xPlTwp052b+RDNqNgI98aZFBK2rUkuyxXcTfiE8iQs0WCYLPhjQFFs9WkJZXkpZaKNdl4Kli+jCMAaxqNT6xtoZnHRD3JFX7n/ELZn8PQhf97MT0loTEQFG3VKrHq75DYM2VecxazxOT813+YoVHGu1kKY3oBGsA+Rrb6ebIFoBK016zKjM54cC5ByAHGwy2fpqudZUQrQJ/eSMPjj/t9L6bKi44FyJy+Q/xCieYwTJvsr4hFNEkYJ6Mq+pjrBjGF2tVTCgSoYGW9MAGHXJsUjk5Y11dfSaAHFG97CnhXsFRKZLI3vPQNMdNcG9hlkIEmOaRnsxJ/VXeh/jH3uATDrY7zClbl+SWzmjGcisoL/QcHtede3eb/tqsScG7lZx6a3W6qLqCpNk0cCT9KQa3SAaBWc7Y5xNj+VVtWhsetFpqNuecFXhHvqPPy9e5Ro0oieaTOe6ESTLDSgeSaQWxzlL3/QfbGC91QUMIH4IZ40CeqFC
 +UmPtPZO
 kjaaNOOlx+6hWLvX+2Ss1wOiA1Xo1ih/pQsiQ6uVIr4PO4O7ywtxfzllfDnXAenl5sUorCq2NGig0srC5PwPdvgHe0Jl+lSkULT/gVQK+BtWGBvH/YhbNva7J8e1+1Z+tWBnUt5T5G5xTFB/WtNDMb1jMvRYSCMPAX/N+hd2FPDzNdZBlc9QxaUs0CbGcbHuVoPmQsnku91eTjYiqZP7jLDwehGuBsuyeF1JpZcPrIBfRC5iZensbTNEokZ6a+qxspot2/pj7KO0Pl5hlfZYNZpyr5Z3FDJ/M3dugwfsJ3n6gd3Bl5XRJRh8uii/Nuk7d6K+Zcr7/3Hlm5Urbse1AVWh07TFYUxW2bHJPbXSVA24g3T1MI3f0L4A18E/jRh3V5Etebwa9WprnSVwmvxkQ+PdxQ/kFhSXN2C+ZN6ILSXuhKyIZw3vkgo5LmJ2Og4LLnkO6RdtJx97SVq23kTKe/Hwv2kZVdpezXHzuieK70KzPhIDRclou1ww0dpAJBfnYnCg7VPQRV0e/wa+Npe0q9lbwKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:30PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() loop in mm/memory-failure.c with
> for_each_process_rculock(), which scopes the RCU read lock to the
> loop body via scoped_guard(rcu).
>
> In collect_procs_file(), the page_pgoff() call now falls outside the
> RCU read-side critical section.  This is safe because page_pgoff()
> only reads folio->index and does not traverse any RCU-protected
> structures.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>   - Clarify page_pgoff() safety outside RCU lock (SJ Park)
>  mm/memory-failure.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba..7d93deb1f7b3 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -555,8 +555,7 @@ static void collect_procs_anon(const struct folio *folio,
>  		return;
>
>  	pgoff = page_pgoff(folio, page);
> -	rcu_read_lock();
> -	for_each_process(tsk) {
> +	for_each_process_rculock(tsk) {
>  		struct vm_area_struct *vma;
>  		struct anon_vma_chain *vmac;
>  		struct task_struct *t = task_early_kill(tsk, force_early);
> @@ -572,7 +571,6 @@ static void collect_procs_anon(const struct folio *folio,
>  			add_to_kill_anon_file(t, page, vma, to_kill, addr);
>  		}
>  	}
> -	rcu_read_unlock();
>  	anon_vma_unlock_read(av);
>  }
>
> @@ -589,9 +587,8 @@ static void collect_procs_file(const struct folio *folio,
>  	pgoff_t pgoff;
>
>  	i_mmap_lock_read(mapping);
> -	rcu_read_lock();
>  	pgoff = page_pgoff(folio, page);
> -	for_each_process(tsk) {
> +	for_each_process_rculock(tsk) {
>  		struct task_struct *t = task_early_kill(tsk, force_early);
>  		unsigned long addr;
>
> @@ -611,7 +608,6 @@ static void collect_procs_file(const struct folio *folio,
>  			add_to_kill_anon_file(t, page, vma, to_kill, addr);
>  		}
>  	}
> -	rcu_read_unlock();
>  	i_mmap_unlock_read(mapping);
>  }
>
> @@ -635,8 +631,7 @@ static void collect_procs_fsdax(const struct page *page,
>  	struct task_struct *tsk;
>
>  	i_mmap_lock_read(mapping);
> -	rcu_read_lock();
> -	for_each_process(tsk) {
> +	for_each_process_rculock(tsk) {
>  		struct task_struct *t = tsk;
>
>  		/*
> @@ -653,7 +648,6 @@ static void collect_procs_fsdax(const struct page *page,
>  				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
>  		}
>  	}
> -	rcu_read_unlock();
>  	i_mmap_unlock_read(mapping);
>  }
>  #endif /* CONFIG_FS_DAX */
> @@ -2288,8 +2282,7 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
>  	struct address_space *mapping = pfn_space->mapping;
>
>  	i_mmap_lock_read(mapping);
> -	rcu_read_lock();
> -	for_each_process(tsk) {
> +	for_each_process_rculock(tsk) {
>  		struct task_struct *t = tsk;
>
>  		t = task_early_kill(tsk, true);
> @@ -2303,7 +2296,6 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
>  				add_to_kill_pgoff(t, vma, to_kill, pgoff);
>  		}
>  	}
> -	rcu_read_unlock();
>  	i_mmap_unlock_read(mapping);
>  }
>
> --
> 2.25.1
>

--
Cheers, Lorenzo

