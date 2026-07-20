Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A532C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB756B00A0; Mon, 20 Jul 2026 11:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C316B00A2; Mon, 20 Jul 2026 11:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AC96B00A3; Mon, 20 Jul 2026 11:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D705F6B00A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:25:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF97D1601E8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:25:20 +0000 (UTC)
X-FDA: 85009528800.22.AAF3F6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F153A40009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:25:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XJaX/lI9";
	spf=pass (imf17.hostedemail.com: domain of "SRS0=FnXu=FO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=FnXu=FO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6yVyiE63yXcD/fvLI3hqIkx+vFonOcuLVo15lmuJ6Y=;
	b=5/zZAp9V/WHqwLbllzoh52YIv/8AuY416VdD4HDAGwcNy4/B3S5Pq/rxc4Ydqo5Y94ZfFF
	zaMygJDX61tebm1M9fUWuMB98VnIEsC2ltSYZtRs9OdN6fWNkzKvMzwmh8kSxNHKnxJCdE
	STwxq+TWI8B5ihb75DVjyB6kZhA1vnQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784561119;
	b=qGbTCx90v5qm1uGWuWvRJQtkDcNcc/bYLqSyEoIKM9iiUG/mHkGAY8F943k1FNcLThDoYZ
	4DcBNt3Bl9s8laJb8utKsBBUXg/bm/hkSzoOVEG9U+voqd2kaXWq7gwku5mgSePflWoyCv
	Zqow/QncIpJNUnrYn4hgOWbE0WSpjhI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XJaX/lI9";
	spf=pass (imf17.hostedemail.com: domain of "SRS0=FnXu=FO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=FnXu=FO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B169941AC4;
	Mon, 20 Jul 2026 15:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941361F000E9;
	Mon, 20 Jul 2026 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784561117;
	bh=H6yVyiE63yXcD/fvLI3hqIkx+vFonOcuLVo15lmuJ6Y=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=XJaX/lI9ygdRmKcimsELCE6cxoMXHvXYspGuz9eSToSm0RMONx0IL4cHzeJh9nReI
	 ou/0IyMyJj2UEVeaoAQXQJrI8W0iasCg9pU0JCJjcKbadwrXz2VReMwu4L/l1T6rJR
	 ROxC93As7r0qhfIhwhKhvI2K5u2L6ZTk/2A7INZnibdbDVfAsC7mjuPwSx17jXTQFJ
	 eHPVUVB5PxE0YAvAoNRMZii8Z2+RDZyIBdcfW0UNcziqe1MGr2ZM1PtLMg+1XvMNX5
	 XtBf1t8rIdk6qvKbyPClHESk5vKn9jDy5FlDT/wPKMfTpMUHDnhFk0p6kXTYQ8cqdz
	 MQTsCZxp5xJNg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 66ED3CE0C57; Mon, 20 Jul 2026 08:25:17 -0700 (PDT)
Date: Mon, 20 Jul 2026 08:25:17 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>, puranjay@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <8114f54f-b05b-489d-a3f1-7aa02d93cda0@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F153A40009
X-Stat-Signature: 7h9gau4uo7pjee9uhpc3qfmge71rkhd5
X-Rspam-User: 
X-HE-Tag: 1784561118-974782
X-HE-Meta: U2FsdGVkX18X/Ko1KyDyephM+rKWrYh2Qd4megDYWhng1tQTDeAjKp9yEd33VjN4ILoMQaRKk4RCyEDr+cCziyxh/609y0Ur68cCugUfm73GJbrJoIU4Mkja8Rz/uwJ0ylVZvkiADwHLMo7sRdojOqY/H+qZvV6KIOQ48hjCY852P/+Pi0rCGSUrDf9MWnj9zCohPHC9wbLfYz3dWugZDnTUf+8JApGHQlvgHLZO1FVeduLG2VtXx4W/NntQqJQ7osEYlGuPX+pZa6zOtRYHK4yPY+tUNx9R98gtdUYyWQTtzyXgshyCz2RIjSSVkrZjotEah+H9tlusyHn2XI44TctsurmDxBjJxkNWBRauncEJqO7XHsOgZM6a4vJjXHj0QkVaOgLPZraIzAm7Cu6cqXnuyxEndRisWRhATtSCJsUT6eBiAWORZYuxmmwlzj6xDhNyTIth5glryvZ3ORe9t20y+rDpKWjAwlJTn7fmiTa/I0nFNE0HA00VanXx6fhm9INdK8V4spvzGW0CxwtFtOaVgsK9PzIv+RkzEkp6mqPGgf8+knij/V1FWLdmgq/pEU6RzNMLt5Viy/e7FCx9J39rWRTJy5WHoQuYcOwbYZO8tWJQ60KRCR7ytiKHrsNLxinsQLstn/8dBTdxOOeWpUm6aeqC0dRky/eGQuleeTxo1qbMvUFd9YhLtCVD+PL1++OKvlkq6Wj1A4IBSGPWnD6kJujPBHxGnjTBQjeZxJohUu1H771uV3huuMhB/OCOUL7NGbRw0VVtMXLRaU3IEBOT0WOQheUOOEGNU+HiyPnxlv/efpaq8Wwxx6y9AyqqQI9H4oQUEhHCuSF2gRwvdSK6WRxiSvafojbQvJHi7wJgM9VKgNFwGA29KCxuQYzr+nuqPZurNWaWY0SDKlPuUr9i91cOaJNl299x0TVlX0TyBD34sI/sXSPcQ8lDH8g9CqrEh8GME9qE0VVPmaP
 QU0LQlUU
 Bi/cwGj90fIlEJlagvP9fO6aTisdBvC4E1idualxt8JwC0eDbOatUHF1H9EhvQkZPVewtnz/5nA2hY/6JJw3DXGpm68mD/uCp73pjiGsPSOULIh8N+JcGFSCte7/YPfgU1G8TZ6q68Lsb/S8l9UuOH69dLqk2H0VptWWTLTjL3rYKG5fT/wYn+/zzVvkXIA/eotrXvuhLLSIWAVrA/MK4mR9W8gNKIXCxVgAwYrpxTPN//ZywYADHgoj2utW+9ot79muSgKikFTCYs5Qc4e0Yaid203vhSz2sUbTCSW4CGvS3g0QEO60Q1+XmVSuDXMO64BBHh1K0aKrxov/vK4/JkRUD+2AG/LYu4DbQkpjlSvTYUi07GedMOds5mxEpY7/ml8gfifsXEpNn6C461igHEzWn38YK1PGifYaavRBGwu7d7zYsldNDM0g4QxY45wWMHMyj+QzUDz3q3xSCUVO28guptLVnBWNvZYVQzO5dpUnnpznYMh8z40nYayJNDCSba8RoiPxvyL7FFFYy5Qu/bHti/uBVP59sJvpSXZ3t7/KKsImGkG1oF6wJ61RbUNkpl+pJdMNXMRKZui+f2Sra9y7yhqj/v/ALV/AULArPAVvN+DRztGeP0IkeaBGYoMovqyzSxBcsqnyhq4wL1en9mRnFPLFr8qHDNyZ9bnyC55MxChCYZqAnNpjS7b7X75OoQxhWh8T6yk5MKb6CxjT/8ncXig3E1ktDAkpl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 06:23:45AM -0700, Breno Leitao wrote:
> kmemleak_scan() can run for ages on large debug kernels. It was
> causing some soft-lockups which I got fixed with commit
> 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> stacks") with our beloved cond_resched().
> 
> I've got the fix above deployed in the Meta fleet, and now I am seeing:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
>      scan_block
>      scan_gray_list
>      kmemleak_scan
> 
> and, worse, blocks the callers waiting on that grace period. Here a BPF
> struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> call_rcu_tasks), is stuck long enough to also trip the hung task check:
> 
>   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
>      __wait_rcu_gp
>      bpf_struct_ops_map_free
> 
> Then I've learned that cond_resched() is not an RCU-tasks quiescent
> state, so, we need to use stronger primitives.
> 
> Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> reports an RCU-tasks quiescent state as it proceeds.
> 
> Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> quiescent state for task rcu").
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  mm/kmemleak.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 85f18b17e79c4..f63dfacee7ca1 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1586,7 +1586,7 @@ static int scan_large_block(void *start, void *end)
>  		if (scan_block(start, next, NULL))
>  			return 1;
>  		start = next;
> -		cond_resched();
> +		cond_resched_tasks_rcu_qs();
>  	}
>  
>  	return 0;
> @@ -1623,7 +1623,7 @@ static void scan_object(struct kmemleak_object *object)
>  			scan_block(start, end, object);
>  
>  			raw_spin_unlock_irqrestore(&object->lock, flags);
> -			cond_resched();
> +			cond_resched_tasks_rcu_qs();
>  			raw_spin_lock_irqsave(&object->lock, flags);
>  			if (!(object->flags & OBJECT_ALLOCATED))
>  				break;
> @@ -1645,7 +1645,7 @@ static void scan_object(struct kmemleak_object *object)
>  				break;
>  
>  			raw_spin_unlock_irqrestore(&object->lock, flags);
> -			cond_resched();
> +			cond_resched_tasks_rcu_qs();
>  			raw_spin_lock_irqsave(&object->lock, flags);
>  		} while (object->flags & OBJECT_ALLOCATED);
>  	} else {
> @@ -1673,7 +1673,7 @@ static void scan_gray_list(void)
>  	 */
>  	object = list_entry(gray_list.next, typeof(*object), gray_list);
>  	while (&object->gray_list != &gray_list) {
> -		cond_resched();
> +		cond_resched_tasks_rcu_qs();
>  
>  		/* may add new objects to the list */
>  		if (!scan_should_stop())
> @@ -1708,7 +1708,7 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
>  	raw_spin_unlock_irq(&kmemleak_lock);
>  
>  	rcu_read_unlock();
> -	cond_resched();
> +	cond_resched_tasks_rcu_qs();
>  	rcu_read_lock();
>  
>  	raw_spin_lock_irq(&kmemleak_lock);
> @@ -1753,7 +1753,7 @@ static void kmemleak_scan_task_stacks(void)
>  			}
>  			put_task_struct(p);
>  		}
> -		cond_resched();
> +		cond_resched_tasks_rcu_qs();
>  	} while (pid && !stop);
>  }
>  
> @@ -1935,7 +1935,7 @@ static int __kmemleak_scan(bool full)
>  			struct page *page = pfn_to_online_page(pfn);
>  
>  			if (!(pfn & 63))
> -				cond_resched();
> +				cond_resched_tasks_rcu_qs();
>  
>  			if (!page)
>  				continue;
> 
> ---
> base-commit: 0718283ab28bc3907e10b61a6b4be6fefa1cbb2f
> change-id: 20260720-kmemleak_rcu_task-6d3ea111b947
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

