Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC10C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ECDE6B00A3; Mon,  7 Sep 2026 04:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D4E6B00A7; Mon,  7 Sep 2026 04:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CA06B00A9; Mon,  7 Sep 2026 04:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBD056B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:36:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74E744069E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:36:25 +0000 (UTC)
X-FDA: 85186309530.14.75B90B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB43F160002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:36:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dt1YvAUg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788770183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSKYKv9+IpmrXK+SaXRNeOF2fLG9l/6KPt7ur+clwx0=;
	b=PVG33EZdk9/t9sF0nPgKOVcq33GNkgp6JyYvaK74GNk3jGAQzjpWu+5uWvtreYRzUtt8se
	OgyZGRiKgLVcBB8Hj7/QPMu+0iQK8+K3G0/x8W8j83vxjz3tBcEd4lLACgjMZICU0uVeld
	pAPOrXaKtJhrqgSt2m2C1z0dpGbauDM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dt1YvAUg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788770183;
	b=UKaJPJ/wt6VypvLCER3+QTS3LxLIxLRro9tjY+5EKzMUl6zIkmoUxJG7C/uOVS0MmmN9j0
	D0Fpqkx5Zkm5sYV0Iw/DNFbtEYZnJrVcApGkHrOAmxjnO4Mv+UCnk2tbXZYANnYamyBSGB
	54X1AP2V2M5cunMd3yNZ7P8WKa4iNy4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6185D60D86;
	Mon,  7 Sep 2026 08:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC8F1F00A3D;
	Mon,  7 Sep 2026 08:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788770183;
	bh=nSKYKv9+IpmrXK+SaXRNeOF2fLG9l/6KPt7ur+clwx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dt1YvAUg6NQDSEDvgG9mbQNggE1DpbwJYzMW4bcdlZql+uP+sMxqkUWIYAXsCyIq5
	 coopp1kNdFyVaxSNXMEYuqQdamxoZARBxr6/t2IIpNcq7WwRE/IdJAYLPCVwlAJaWH
	 tA5XXCdJgaMjyMpblDZk2E8jRfJIlW4C3XdTPPmivDkJqXxdgp1VDXYfAUR4AvdZ/g
	 HNsX23T6/YieZlixieteuyT8T5FyobPtxs21tLst44lvW5pzaO1hrglEyJ5O9AFNG8
	 q/mvBXkYa3rmnye/abn6dOoOlhqDPg3K7lRJlgZIbKtr/PzWNIFK6M9D4REDm265Pf
	 ALtpygYtu6h/Q==
Date: Mon, 7 Sep 2026 09:36:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>, 
	SJ Park <sj@kernel.org>, peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, 
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, 
	tglx@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org, 
	gnoack3000@gmail.com, rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
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
Subject: Re: [PATCH v2 3/8] mm/ksm: convert process iterator to
 for_each_process_rculock
Message-ID: <ap53cJ9c4oN1wQao@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-4-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-4-ye.liu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f36bwnukndnnib1h94g8x33uz7feu6mf
X-Rspamd-Queue-Id: DB43F160002
X-HE-Tag: 1788770183-38217
X-HE-Meta: U2FsdGVkX18Xb5ScDMT3YF53yv7ZFbfaZxZWeyXoK37RFJTd2/o41B08eRknVCiJ06X8EUdAoBVOaP99/EdAGhWw5J5lS+kuRjVNrR8oZUBxLiHrjT9LD+NtimNbhpWFKSH9aFeG7ME3hFcdUhdkJ5DmdbHl4xrOxP93nSfQu5xkx1Z5y1KbcU/DVM6gI8nAsvm25m+wQ73M2aM0bTmnaDNVH6Adoj7iWR30Nn7ipcLvNPb+kjMiKSxyqRNe64K1cqZH2x7k35K2r8DUQOv7c+RexMyufg3UmQ27ADv2Dev6i3u0ptHS2eGtgRNlsoY31DooDMR6ZjwUtM0DiKQrAxa6ch11iLvIrJtxQb3YoqCFoCC8OJcF2OhDcXm8nxzBGs9QSSe6Dl9YzN2j3mwt1GKKx13GwfrjUpgJAlqfezJu8GDeTX2S6dQlICTDhN9ZUtgZyPqY6zTCUJSSegcYTN6rWwp9v048Tag5UTh/l51BMGWcr+APfY+CoFd00onfQcXicL0hjYS2qAyt6YenkDbI54rsuixl9omoWRke2P4AVd7K2QAFt/H+MzJuYULyFmVqS7e/WlrQXUdgXmkHRCnUKDBlU0PPLTiJ4+9K72bCqs6WWuldaA1Ns8XAlQTR6kNtH1dbPecCZ3rmz1Wi2o8y8Q3XpII0k6Ttuyt/N1Zxqx6OjYrZovaEHMPZIIK9C3XYo1LEzg/+HQSfef/vMorH7/fLApEfz8abZPCdW8sc/z8oldvRAMl/VjpJcqx7z6/0hGkTDs1RZKhewISiCQBMC/FkcJ60bzYBaMa96JBOrpD8UFYVfmySbvFcBJBEdHZd+rxucC3cmXYteCUqTYryU0b6JZS2rrAZinNyWrcBUju6AKENV1t7e3r0ZN7VwnwQtC2f2eZrSS2x3RoNxt14qksoQGbVo9mPMjqKObWxLW7sv+jkPrjHg8MtyY7FSB35jDMq8Jis0aMAYu2
 84sz3FbS
 oGTP+SdBPG9iAiVg/WLxwWbj4hibgG8F+OamQp8o43VYwJm4ZPLnyxUwaQxaCVMOGFWQwgheDr9qz6AkiJxE9Ld4x5+GVe5swUyOYihzJcUau6ElHoI8HIDw9/KPwFeY6KFxklnjesmbXBy9268hZ6eHobErzUItCmE9GPT6LoZXOXXsz+pRwuzuSTnBSynlcuRC2znChtmFa3/CtDmj51QSfkUI5Y7BeUzGsqOcV8oZX1D9NzdwcK0jTH6uKUbivv7IX/tCFqcQNG4Cbgq3GIJtf1vnhj/nm2XN2z++9Uy/UCT9lvPUf/pMCt5JsvcI3Liw1ih1WjjxnqCLTSfNbP0Jyg4ytD/a3+yjwFyfkSdCZQ9hoBrVy4WFoJtJ9aIRrS9A1iyLApMNc8vSYUBPIns6pky5aQYF64xOD6EbYmrg7wbO9ypc1wMQ8MMcHuSL0i0fRlLXuwwyJQc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:29PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in mm/ksm.c with for_each_process_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>  mm/ksm.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 49d48d1e0998..69d30e80a090 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3280,8 +3280,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  		struct anon_vma *av = rmap_item->anon_vma;
>
>  		anon_vma_lock_read(av);
> -		rcu_read_lock();
> -		for_each_process(tsk) {
> +		for_each_process_rculock(tsk) {
>  			struct anon_vma_chain *vmac;
>  			const unsigned long addr = rmap_item->address & PAGE_MASK;
>  			const unsigned long index = rmap_item->linear_page_index;
> @@ -3298,7 +3297,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  				}
>  			}
>  		}
> -		rcu_read_unlock();
>  		anon_vma_unlock_read(av);
>  	}
>  }
> --
> 2.25.1
>

--
Cheers, Lorenzo

