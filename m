Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B53D39422
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75526B0088; Thu,  2 Apr 2026 09:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25BE6B0089; Thu,  2 Apr 2026 09:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B1F6B008A; Thu,  2 Apr 2026 09:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF08F6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:39:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33DA5E17D5
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:39:57 +0000 (UTC)
X-FDA: 84613724034.24.3CE4BD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CF4612000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:39:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJdcTe5n;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775137195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vONgawCnC/Ue0qNiit1jKqnspQ858bYFagJl5j2Q5cQ=;
	b=8Igv97AAnYMCBmSDsAhMKywX/s8UTXIAza2AAvgYvh6D65JYEZBOOY/Bz3nPbX126CTTn5
	sFb3MiWPTVfwimRHqz+pVocWYK0ik+Bdw2G/nKiQ+YjjVyo7YuIR5ULT4KVK/9NdrY+J6m
	ZJ13Sv61OQj7dnDyZuQoGaCmSt+2aWA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJdcTe5n;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775137195; a=rsa-sha256;
	cv=none;
	b=IIvjR9+cyUYRsZqrB2p49DVVyMxaKLuCG4zWPzBtnoXElAOoURMBPeJgwPldgqe7HWj/Nn
	M8EjJSfwsfm7NNj4JLJaAosh3S/v52EjnamMN5XDS68UH4iVLtaDQzJc4tm0He7K1Uhs10
	Brec7AQ8fyu/j00OvKcEoF+fdhba77c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0DC060121;
	Thu,  2 Apr 2026 13:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3BFC19423;
	Thu,  2 Apr 2026 13:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137194;
	bh=/vV7QgRPjd/cFFW6MPTAF/7Og2G5QIqkY8LRGSNz3vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJdcTe5n2tfoDUpcFMISLHnOjaNqUmDlD3CyDUSVPrmeCVH9MkCJDIHQMLwslr1Qp
	 YUU2hP4biPI4Hui74POwe7kKk0bQSrs4R/Mgs6D+Qct/pXPbEn9kTigyRcg5y/iQyW
	 MdiXNZ6rqNJh3QHOfoDuEHnINamel/G0/Mhdp93zoQrT571kVp+ni1cxAYjeJ55Jzz
	 3jJzuuyc/e1dQ1wnNsNx39GCSHUQXLZDsUXYjIi85jXtNKZUv9CcDk6AebBjv/kS0W
	 P2JfTC/jHrvoqm4hxVME1qFKwM0aUrLK/jnfJum55SDN5+EdYQPWRsRNzUIzfjxym2
	 Jjvbz1vMThKbQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Thu,  2 Apr 2026 06:39:51 -0700
Message-ID: <20260402133952.73301-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402045928.71170-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CF4612000A
X-Stat-Signature: is7u1i9oezou9aq3hngsxrycgwa7phje
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775137195-830454
X-HE-Meta: U2FsdGVkX1+GGC4ICpiJfHq+equEHo8rEyIRO5W42QQpI77WQYd3vqA3j3JUfKs+E5WIILSL5bqeO+2dwSU4u7+vh1BBaZ8/D1am8vpcCdJZwxIhkR/VIGw07tXjXWyDzYVqHrWMdAUPe6aCgTf2DQBo7J+GRaKt4fAAgC8+ly5VBOGQUtZz5HYrQvYTh5ZgvnHJE1bUp59OmjQ+SHHqrq/AiuYqF19laKJxaJWxj+G/ByK4zIHW3ZEmc0qa8DC0SP2frq2txSCHcjdhRdXbbuZmGSR7lOB9OBBwGwHARfT4ogyN9icoEqYR2JB5ARrfr7obUlcfh27GhLzlTj4ZVQUwAYnOkdpRmOo3Ie/s1vdHXvn4qtxfoAqaNvCJ+qdptBSNnR57lJ+6k8ybdD46TI00U0TpJdFgteOrc5g4sZwL3QRLhnRZ4U3WFzENEpskx3hrdhtmXXWTySYE2ee19NdbZIKDYNMXtjdREImXHCr13sNUe2B/wRz8tnMDCJkyw2vFf7SFxpbu116u8okeu3HIJl783LXV2yQrTiNOF08blqF9yKqx1wjMt8ROc2kh+it8iECs7yOKE5ns71U0lyfgFa1OMwgHBFMR9y9Xq5HihU2gfqbghixD47G4WLfE3rE0Cqr3heo2BdfVLmzoEO2yNiFQbPpCLMTRSBHyCpJT9J5MNd1wzqfNc0aRsDw+D3pZmjOoRscbq1MurPTD+sAVrnitldhiDcOP24Hl3aH10Pxx/G4nN49pCJBkZ2Ts7qrd85PKFwRCccaqpo/gQ/GXmmEiTsx/tRuNicoeQ7Q3rJtQQs/n/WudUKwb2mIeIv/h8lbyV0/NDMvj1abrtEn8R38HXles85kjtERJqpxBWScCSUW7ZaryT7eg8k3qnUbqE0lqGACJOMrqtIjmywglmzqMiT1B21iO3VABigk+EhDcPJc9pmCWoMMpa4NGwQQ6pAbscVbuhyDajDh
 gZqNOZp1
 6kpPaiZnslcleHN3ZzkHlhCtptOvsSlSM/BzsfjbKU+SNXVigeSoEYklT6bFdSb2b9tyhQpx8AI7qepa7qmGvNcdKj7L2z9Zxt/Li37Gq9e5Jo5X4rkIQaqyhPuyGl3fHSVEdXWSoyjy30SwnfUxuNh5lXUaclXw6uFxZFbRGl5nY+StGHPVPpgVyr7LAO2NHnDmcmqkCAG7Ta850tCzUfh+URI0aSOLhUvZPdLdArXuIsaEnj5/C68rrFtIjEiXPEVUMFZm8UgsyfUQHsJirpqYMVm/bq1W2GlEEztcPaFIl5qwDqbpXUafFveVitzi3XwFDB9INSQ1fqI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko didn't find a real issue here.  I will post non-RFC patch soon.

Forwarding Sashiko review in a usual reply format, with my inline comment for
doing discussions via mails.

> # review url: https://sashiko.dev/#/patchset/20260402045928.71170-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit 8adb3c95d68d8448c8f57865d9874a5277cc1540
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
> 
> This commit attempts to fix a memory leak of the damon_ctx object when
> damon_call() fails, by deferring deallocation to a subsequent start call
> to avoid a use-after-free with the terminating kdamond thread.
> 
> Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org
> 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -245,6 +245,12 @@ static int damon_stat_start(void)
> >  {
> >  	int err;
> >  
> > +	if (damon_stat_context) {
> > +		if (damon_is_running(damon_stat_context))
> > +			return -EAGAIN;
> 
> If the user retries while the background thread is still terminating, this
> will return -EAGAIN. Does this break standard sysfs boolean expectations,
> forcing userspace scripts to implement arbitrary retry loops?

I don't think that's a problem.

> 
> Also, if the user never writes "Y" to the "enabled" sysfs parameter again,
> does the memory remain permanently leaked?

In a sense someone can argue so.  Someone else may also argue it as "cached".
Anyway the total amount of "leaked" or "cached" memory is just single damon_ctx
object.  No problem in my opinion.

> 
> Could this be fixed synchronously by calling damon_stat_stop() in the error
> path of damon_stat_start() instead? Since damon_stop() safely blocks via
> kthread_stop_put() until the thread has fully exited, it seems it would
> allow immediate and safe deallocation without returning -EAGAIN.

damon_stop() was not designed for the purpose.  Calling damon_stop() for
terminating kdamond also feels odd.  For a hotfix, I think the current patch is
good.

> 
> > +		damon_destroy_ctx(damon_stat_context);
> > +	}
> > +
> >  	damon_stat_context = damon_stat_build_ctx();
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260402045928.71170-1-sj@kernel.org


Thanks,
SJ

[...]

