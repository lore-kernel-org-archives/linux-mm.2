Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7AEC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEC656B00A7; Mon,  7 Sep 2026 08:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CAA6B00A9; Mon,  7 Sep 2026 08:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B276B00AA; Mon,  7 Sep 2026 08:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 780536B00A7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:27:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17CD6140157
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:27:50 +0000 (UTC)
X-FDA: 85186892700.07.22F17F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7381318000D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:27:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRC2+2eu;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784068;
	b=sAVLC9KaWaaTgygGEZ/5zAXjjeHTF7elCnrLQWd524FmhiSOJSmWqpRThJgkbRDQFwZXz1
	fZ+DdXnnOF9ptZUnunO/cTmkDNfS2V2u4IK+j28gEpXnbVyMJVPETIGQ2YlvgKa5yq2K85
	KRNBl8ex91ExthGGvpNWdzjilHOfXig=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRC2+2eu;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlAfg5iXl7FPl5nf6qTFBdMw/OruKYjbvrYea3+Uz98=;
	b=qpWKF5hxy1i2CkSOVvOK/903SZVyP7rWSvn/AfHlu59BUaFUJ3KmZpPK+So/RcZByxOrxe
	98+PKz8a5kq/l/quEwLJDmaTJkMNQDFgN1THumWLAHsdm0fUUQaqOMPdMGOzgYlVju3hk/
	SgldrEQzw8Vqzkh9Gb9MF8XMfQjLrC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 698F44042E;
	Mon,  7 Sep 2026 12:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18D71F00A3A;
	Mon,  7 Sep 2026 12:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784067;
	bh=WlAfg5iXl7FPl5nf6qTFBdMw/OruKYjbvrYea3+Uz98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XRC2+2eun6nn01MuOy3pLsHfxu9LlV+nJ/7enwoG457a25DF4U95wpahgGNE/Mkpl
	 rLWt1ASQbCeSG/i9QLz1ZnPcaCy6u4EsPOMutcqfGQwolvE3pFYvj3CLi0gH/jHIaP
	 VSX9+ZExqzazlzJ/gYokn6P0ZUcZVcJyNCXQ1YbNatoMUV8yAdvk5jDDyWamOxAvv3
	 +7aUUDC5HzU5NJnVD+GkGmgbm6fa2/R9eIMCLeZ3Ns7wFIlGEhWI+Y0nIqbVg2rjid
	 pJOLNmP3BAjh+U1aeOA7DovmGfdTvNbJn34KVmWPthoAFJm0y6LO+cDAw3Iwnhc/n6
	 Nx/Wwb0dP0rPg==
Date: Mon, 7 Sep 2026 13:27:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>, 
	Michal Hocko <mhocko@suse.com>, peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, 
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, 
	tglx@kernel.org, david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	rafael@kernel.org, gnoack3000@gmail.com, sj@kernel.org, rientjes@google.com, 
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, 
	boqun@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org, 
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 7/8] lib: convert process iterator to
 for_each_process_rculock
Message-ID: <ap6tri8GwiFVEjmo@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-8-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-8-ye.liu@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7381318000D
X-Stat-Signature: g66anpzunugmu33jqsdr5obfz7uktmhu
X-Rspam-User: 
X-HE-Tag: 1788784068-138275
X-HE-Meta: U2FsdGVkX1+qkiK53KX69t8yKuixJ4exLaXVvhC2tImWdgBGsD8RIWgT8mNqnzkoUpQOZycbJpbcVKXlCEdR0jf12NOkolPfbzu5xkTvadeJuCcK14rG0tYxBFPiMbUalgujtx1ri2bHqScusp/0MYOGsHjpM/FlhRMfUXfRAXuZxx70wRem/salNknHJUQ7IdcnkeFpIs2WjOFNsrIGWESEUDejxY6FW9jvT483WmSuHm9yYzUUl0b2eq2J9sAlSMXwNwXIdSTvYRf00M1BKdGEKz17Flh86OPKWrSDuqWNpdCPvjmpdxBPkq/gxwZdnUJQukP/sLBoJICluKfuPp1OeCL/8wKPx8chq2UMPkl4IFgQTpLDg+UN23M5S2p9vgBJPMYZ45ef3cF/yjg6IrYnwtfTLcUyk1/CIKMVfD7uRD+u42YcrJOp+X6oW4PeWUUBfXoWuBRK0lVOe8WXoeOfdRbdU/xetv4hsHu+TBeagpmOVlaJoejbMbWdQlu4gdih1OZkmziv7TpLu7AZE0etgBqRBhxIDiomz0xnR3RiGmvmRNBf1HG0CJWSA3l6FwlCF9HABdocjZYjE8tWHzr/Z4Ogf6gvwAi4Xnkygo71yq23mDNEusHiYXoEVwbYh1VLEd5mCQMtFVbIB9GsNHFhiM3QvbtOsnkoa6aDpxNceen1fFDVBQkF1hK6ovkPJljQm4tric8D/aPa4SlMyxHlNSBDEjvB5lcvIrdpQMTxgtdg2XGc5gigLCdQE14Xl5JAVPrr0mnAhm7Xp0L8uJm9pZaI1R7U6IvQmuN40EdW2YeGedoy3mdArT26DJi6BlDUElppjJIl47O3yQZ9Isxkp7rgAHFuWVpId7iSNpC19Qp6Ury6ekMX8Ks5Xqzvg9asaocGH/tmi8rTRcF8siVkE1ZyuTqVQYss51zHt5TFkqEP0BDwoNMuNFQSYKowumRxWWmdjCbu8OquvWe
 1Zc9OZF/
 hSjCupxhbTJb4LxflHg/SVvQhlM6UEfoPSbvSAM+7DmJ2YZHoooGqaZWDLD97Ls3acJ6y6mD75He0oZQ8YPrLPjdKjn6Pj/5ilXrVaG+zYScM94gz5b0yri77WNH89PDErdkIylLdE8xCN7Rt6s1viOhTEagSS9fRb2ULhsGNki1ed2yGtdqxkuFQAAmPJ9Lp1y/VFDSsTAocKWzw0TVMnm9ckTIpvVVIBBMsSBJs7KpQxEG7A3yuCudCMTwiItmCbH3L9e6YGMLiTwmS+c81pJTL+SK2h4Zhebrdho6P1jhaq3YYtZ3dCsYL4ufPwNxYkVY4iBHhreaG5KD6Ans2c+MnZaUczkwiWdL5BcIMeXlSUQ7hx4Fsxj9QoSbXblp0OySjyN4RQyB8EGWt74V2u/PyuAGUgOvLxgL1WWfYZS/Ki7AIiuCKdTa9cBA26LRA9brH9YpWPdMUqbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:33PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in lib/ with for_each_process_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>  lib/is_single_threaded.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
> index 8c98b20bfc41..4e7fe85454ab 100644
> --- a/lib/is_single_threaded.c
> +++ b/lib/is_single_threaded.c
> @@ -26,8 +26,7 @@ bool current_is_single_threaded(void)
>  		return true;
>
>  	ret = false;
> -	rcu_read_lock();
> -	for_each_process(p) {
> +	for_each_process_rculock(p) {
>  		if (unlikely(p->flags & PF_KTHREAD))
>  			continue;
>  		if (unlikely(p == task->group_leader))
> @@ -48,7 +47,5 @@ bool current_is_single_threaded(void)
>  	}
>  	ret = true;
>  found:
> -	rcu_read_unlock();
> -
>  	return ret;
>  }
> --
> 2.25.1
>

--
Cheers, Lorenzo

