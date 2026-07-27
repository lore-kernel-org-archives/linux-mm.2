Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EA2C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1EE6B0093; Mon, 27 Jul 2026 16:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9636B0095; Mon, 27 Jul 2026 16:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6AF6B0096; Mon, 27 Jul 2026 16:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36BDA6B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:49:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA018A01D7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:49:54 +0000 (UTC)
X-FDA: 85035748308.27.88633A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90DB2C0002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:49:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linux-foundation.org header.s=korg header.b=Km6SraPs;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785185393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8ZyLA2+YAMy4f4zS6g/hgbT7acodmQWiHyLJaVSdcc=;
	b=sdNEZ1cGbOZdEux4DjXb7A4+QGyilpyPqFKEuCXnQqmy6x5ZLHNX/nn+o2HkfX2cdBuCKC
	5dVG8JFNLQiK06oteuIdEUWfANsG1JTKqQklCTMEOuGKkTEc36KaWy2pztJcoBlQLoj99H
	fEfjzDI0X0nv+1qTuYqS6rApeAD151Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linux-foundation.org header.s=korg header.b=Km6SraPs;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785185393;
	b=Cs5o7nZXm1DG5sFiDQRdVG3i3VgwRRW61wyjQarLoapmE4h/X/lLnakvzsSt6gynw4oUpI
	m3mZVLTFPpMkfaoNpHyjGfWOyYcar5KXkPIJRXgUZGBQXeH9mj+l7AF9Wx6RynZjraOkUF
	xgEXWo63QI1Oh2PXVM74x8yCKuFc32c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A501E60A85;
	Mon, 27 Jul 2026 20:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70ED1F000E9;
	Mon, 27 Jul 2026 20:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785185391;
	bh=fggn7tx/E/h6j/YgcVlmy7J3VJhfZLSKiSzgGEbZLCM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Km6SraPsRfrDyw3Tupf/G1B+Rq9uKup57Mq7c1UEyR2qDg2EhTvX8CcADk9i6AIjR
	 p02VPtt5X7SGe6OmcWFjJ67nZ03Q+eMPzr8n9E7IzWDMgIy3YwiETmc4cKbzBhsBO6
	 AQ1rpKVKwyKuoByJBoYU/JOcfV2JrYqTNZWeo3E4=
Date: Mon, 27 Jul 2026 13:49:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, paulmck@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate: report RCU-tasks quiescent states in
 migrate_pages_batch()
Message-Id: <20260727134950.2d091094dbb9bb3ecb7a3eb6@linux-foundation.org>
In-Reply-To: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
References: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 90DB2C0002
X-Rspamd-Server: rspam01
X-Stat-Signature: y9rsh41bgjgey3g73ratr46gcay5f78a
X-HE-Tag: 1785185392-585488
X-HE-Meta: U2FsdGVkX1/pgxk0bD5vIZ5l8kBUX1Jhnh3Fy/aCxhnUBNbf4/bDnsR2uKjncMyULEqKCsOLRr9owulq4v4lXQ8QUETTN/Z2q8oTlpl9GZAwA9GRfRre9v4T/Nemu823+lwkBf+hWU61n5/Qg470Hsam1Jrc2Jbu0wY5qkcL1Kw+NYdhuncuPB6Ye9Yr75oawjqDQVb6mjKRl6qfLe4gbdmeLlRfzgQlIXVc3koexvXF2/M3jTgY8GQDM9+7CHF/r+QoeWZvOEaULqqBjbFDiJw2Yf7Gkf4tDNHgvWoVJyJrrKapcVJJAufcPJi+OjL3Eq177PmCwZ2v6ST7EzLdsa2Wl/cHYoAcLEHeXfZhpaa7uNiYNEPJ9xYzRMZqGNVW3g4AVt8kRRInw2bc4f1lKOFyXgNT+flGfcn4lboXgrrGwqO13qrulLgK1cpQY1QI4upyYs3LSDxM8EjwgLnqpaM4RdbDddtGyCVMon0MxOZZJ2hRt/7TpQMQk/yhAH191rJQ238wDFCg9VB/fnLGq3cNePyTicc6PdQ7gIEHU3M1efGmTCmuEvpKudZEFWbpHXx4FwMBCDlpkByOy4y8zOO4zwF1zPsF1Dqty40aYjBLsoMr5ORFAmoyct3eGeIhKzi3hciqGAbN+VoNikP75YH/7hwX1tfsK4lV2BWtjdQy24yLA4I5XtEr/VMeCZhnG5ixALewXrCVu1HeIPN7F3EUdihtwS32LvMmeWevC7ff9+XxQsUdIOuw/3WCmytypdCviwD3OhmPpBzb041GN7rdBAtkT3pZIi5GBoIWYHUdNDEteEiK/enzTcyvmDSO1MVa4nmAYVL+8k36AtzQVnIbaD/x4Ll+6hwKHs1qd7IbWu2lmYmtm/mNHs3MQv8jJFv2/TCBf6lSpQpKzMJ6xUxAxrJR+opYwGaBVhwLOzPHi0WtJxoNRe+cbXIaXbWjc0WpnzXXYQW4jlMCmpq
 +i6GeBx5
 /mni9/HzaC3cQWheY1tpKBMDJMQYFmmhoHBApOyx0ouTJU6A/bsYzVSOw8lNdICCfJLMjCXoDEqkvY9YgGu/C4ebnpfu6iSBoaKDKxCq8MhKplKxkjPiJ1TAfSvz/I/jYrloYbFxH+7wIKC8L7r5NsbScZuxSU8p3gVFwEn4WO7IFhgHHk4OSjxqe3gaW7b5TS7Keanl5yhcwRphd5rC0TDVnneVtpRmvkb4gGPk7po3kNoD9nNjePTmodo5jIz2QJKqTpUjVzozSIAp79IDRxAiA8vK+6CIzS8j8fofvjDXnBhpuKRWUvZSjxyIR0WmiFZtSkuyhIoynZj9rwUK2h9Ki83ibdW1TDv2hCfmjVBLQZKKGFzMJjZ86Y2y/2XR5rcqhmJj4jTMIHG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 06:50:19 -0700 Breno Leitao <leitao@debian.org> wrote:

> migrate_pages_batch() unmaps each folio before moving it, and every
> unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
> try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
> tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch keeps
> the CPU busy for a long time.
> 
> The loop already calls cond_resched(), but on PREEMPTION kernels that is
> a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.
> 
> A long batch therefore never reports a quiescent state, and the
> migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling the
> Tasks-RCU grace period for minutes, which is common at Meta fleet:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>   0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/56 task:kcompactd0      state:R  running task
>   Call Trace:
>    tdp_mmu_zap_leafs
>    tdp_mmu_next_root
>    gfn_to_pfn_cache_invalidate_start
>    kvm_mmu_notifier_invalidate_range_start
>    __mmu_notifier_invalidate_range_start
>    try_to_migrate_one
>    try_to_migrate
>    migrate_pages_batch
>    migrate_pages
>    compact_zone
>    compact_node
>    kcompactd
>    kthread

Well I doubt if users of 7.1 kernels and earlier want to see this.  So
a Fixes: and a cc:stable are needed.  The affected code is quite old
and might even predate the addition of cond_resched_tasks_rcu_qs().  So
I can't begin to suggest a Fixes: target.  Maybe omit it and let the
-stable team figure it out ;)

> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1843,7 +1843,7 @@ static int migrate_pages_batch(struct list_head *from,
>  			is_thp = folio_test_pmd_mappable(folio);
>  			nr_pages = folio_nr_pages(folio);
>  
> -			cond_resched();
> +			cond_resched_tasks_rcu_qs();
>  

Totally off-topic but why the heck was that implemented as a macro. 
Which invokes another macro and another and another and turtles all the
way down.  End result:

   do { do { if (!((false)) && ({ do { __attribute__((__noreturn__)) extern void __compiletime_assert_606(void) __attribute__((__error__("Unsupported access size for {READ,WRITE}_ONCE()."))); if (!((sizeof(((current))->rcu_tasks_holdout) == sizeof(char) || sizeof(((current))->rcu_tasks_holdout) == sizeof(short) || sizeof(((current))->rcu_tasks_holdout) == sizeof(int) || sizeof(((current))->rcu_tasks_holdout) == sizeof(long)) || sizeof(((current))->rcu_tasks_holdout) == sizeof(long long))) __compiletime_assert_606(); } while (0); (*(const volatile __typeof_unqual__(((current))->rcu_tasks_holdout) *)&(((current))->rcu_tasks_holdout)); })) do { do { __attribute__((__noreturn__)) extern void __compiletime_assert_607(void) __attribute__((__error__("Unsupported access size for {READ,WRITE}_ONCE()."))); if (!((sizeof(((current))->rcu_tasks_holdout) == sizeof(char) || sizeof(((current))->rcu_tasks_holdout) == sizeof(short) || sizeof(((current))->rcu_tasks_holdout) == sizeof(int) || s
 izeof(((
 current))->rcu_tasks_holdout) == sizeof(long)) || sizeof(((current))->rcu_tasks_holdout) == sizeof(long long))) __compiletime_assert_607(); } while (0); do { *(volatile typeof(((current))->rcu_tasks_holdout) *)&(((current))->rcu_tasks_holdout) = (false); } while (0); } while (0); } while (0); ({ __might_resched("mm/migrate.c", 1846, 0); _cond_resched(); }); } while (0);


How much nicer would it be to have

static inline void cond_resched_tasks_rcu_qs(void)
{
	if (some brief and efficient test)
		some_slow_uninlined_thing();
}


