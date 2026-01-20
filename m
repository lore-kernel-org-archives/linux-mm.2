Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412FAD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 08:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8605C6B0383; Tue, 20 Jan 2026 03:36:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E0C6B0384; Tue, 20 Jan 2026 03:36:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741796B0385; Tue, 20 Jan 2026 03:36:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63D8B6B0383
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 03:36:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A7078BA46
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:36:31 +0000 (UTC)
X-FDA: 84351685782.17.F958C28
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id B3AFE40009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:36:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J9zB9Dhh;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768898189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1lkVn59AgzHG41rfxCcQcwV1gp3xTqlToekIxDgd/Iw=;
	b=R3zxeK6za3Qa1COfpWufEnjgN7cDyNVhBDPCNyRBsoD4R4sv9ZO1162MroxCE70lOAUV1X
	4ilfpPiMRmjbXiikE6KwD99SKDRLDhUm+CErCPR+7fPOtNmhhgh+MicssF+HQcb2vyXz+X
	aR51zEkVIuGUH2zH1KdWLhPsRaihZEA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J9zB9Dhh;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768898189; a=rsa-sha256;
	cv=none;
	b=6G6WF4F0+8XhbToDiMaoy3XRU5dUtraPszIQkajcbVEgx2j7kXovQ7CBHnIY0qBlCj9CPZ
	L3vPjqbUui+wmm717i8yaTRl4PiqcQCMflVnUyS74QBxLKUAZgjw0oyusdHrUpm+UrZvFq
	s+qHe7dtx4m6S7Oj2ak08+5OJ4/pXQM=
Date: Tue, 20 Jan 2026 16:36:15 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768898185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1lkVn59AgzHG41rfxCcQcwV1gp3xTqlToekIxDgd/Iw=;
	b=J9zB9DhhUzdt+lyzMLvszXOIyc2O+nJbkjXAPF+9kplfQRYb3b0AdG2zwqsIa9Tc7oedl/
	xly2q2eVVCxZp+KuiRa91VtU8un+owcrglfFW355Jdu0yaA62lQp3MTqpXT17iRik49aTf
	rhZuKzl/oUxYHs0h0XBPgo7dHwjgKuE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 10/21] slab: remove cpu (partial) slabs usage from
 allocation paths
Message-ID: <g73gai6ztmaxrigoqwvstyeatdsb6wjunli6gbbhvy7fxqomzv@la3452pj5na4>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-10-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-10-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B3AFE40009
X-Stat-Signature: w6xrqsn8gj19kuwmjsrh63ju1nf49uoq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768898187-851663
X-HE-Meta: U2FsdGVkX188zZLXbtrYS+bCpTWVo0/5gbIojggT7CGCf47OICYD9LndP/krVYgT90H1PjHOUyo2LRbx0ugrcarbAx4y+UpAcklbpqJru63MGATDwUoxmNYrsQ6Yk+MzwKtcdCW1H1RNW4e8/8CRGondNYTz5EyVzPSrzOf6brozc+rXVDH2saA3A6Bps2nRMoubMSwreZ30G1DxTKy56DlHNTE1Kc67SSujn4uTqqEOp5X40xXQbhep/5zFM/NFhnGZRsvZUNG8yy1kSFRego4x779atIY/YMOXS1C36B41eyIlWMqLiib78JOHkCRcrBqmlyAviDgGmxOIuF+Tm+A0sjnOHz/BH1jIOyGtd8ebYvFx/1hDsWGQcz2Xqbur5ANj54zjoRyM5J+03MINPrQrvmY2tJT6t0LiStmPjg3M/Wlzxvmy0kfGStzEJ8sT/4fVsAsJzrw0E6VY3BWcbh4bT2Lv360LeI9d8ifQ+l7AOJbiTyjg5APWUX55Vy85EQujr8Syii2awcZhssOU3Z2hEceJLr3ZA/8T5d2BuB8m8vxD5tzBECpXdHeEQgwaQQyfby8qspSSlfntR4flY3qKXKOo8iiudxWuz3gZwtijLHyEnadxF18oYoy8k4nh92dMULJ+JS0U6t4S8DBI9e2tcXHHxdio/n4rsOv1MJcEaSB0tVFXNKKpxyv80EvLszKF+nRsbvLQ6xRA0ziNeDPpw5EhYK4RVp1H/JcY/Y9R3gVglwSl3iKewwSoYoYjvw7VkbMTn5kJ13Wd1vMQaQvARtUfD83BfRhuALtlHsspDTs49uvCVDshe0WaLJPckBqwnkdxBmdyJMuDD4XNDOsb68sH6m8eT6VVTPRP3XwWM4OCi5IEGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:30PM +0100, Vlastimil Babka wrote:
> We now rely on sheaves as the percpu caching layer and can refill them
> directly from partial or newly allocated slabs. Start removing the cpu
> (partial) slabs code, first from allocation paths.
> 
> This means that any allocation not satisfied from percpu sheaves will
> end up in ___slab_alloc(), where we remove the usage of cpu (partial)
> slabs, so it will only perform get_partial() or new_slab(). In the
> latter case we reuse alloc_from_new_slab() (when we don't use
> the debug/tiny alloc_single_from_new_slab() variant).
> 
> In get_partial_node() we used to return a slab for freezing as the cpu
> slab and to refill the partial slab. Now we only want to return a single
> object and leave the slab on the list (unless it became full). We can't
> simply reuse alloc_single_from_partial() as that assumes freeing uses
> free_to_partial_list(). Instead we need to use __slab_update_freelist()
> to work properly against a racing __slab_free().
> 
> The rest of the changes is removing functions that no longer have any
> callers.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 612 ++++++++------------------------------------------------------
>  1 file changed, 79 insertions(+), 533 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

