Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE80C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 21:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA8C9000D5; Wed, 13 Aug 2025 17:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB3B900088; Wed, 13 Aug 2025 17:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCC59000D5; Wed, 13 Aug 2025 17:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D87F8900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:25:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6396B1DCAF3
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:25:58 +0000 (UTC)
X-FDA: 83773016796.07.14EC6E5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7BCB7A000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:25:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=iBz4Rpi9;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FkoYUBMO;
	spf=pass (imf15.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755120356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPsZZeB7DGQldN6iG3Vx6k5qI8fxoARth9f1NUHSsSI=;
	b=VG4XQYucZSl6N9waP4zNNUIVFUw6HUtldO7wkhPSknH1186GTWsPu8Zjo9TnEjVx2wv/vr
	7ACRvwwwmUe67r7KTXTJR9BOTCQofkh+ecyV5stFtZ9WSbfToZzB2WrlUc5qprYfuOGhov
	vKZsINr2d00hsSrG1r7wUN+J2wZXEgA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755120356; a=rsa-sha256;
	cv=none;
	b=7xyhxeKPzsf3z8pyzrjsdd3ufOeFZIMX4ysviIXP26vhszzGaQx/PbENFnrG47T548yA6e
	hHHAivfAvXflKLTsnh53trtpftswqAG46ryoIiLd2+4zpmC+UvSvqOpPmZyj47PFUBEC3T
	8wCh561LNu1W/kv7x/jwMsHsbHza27I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=iBz4Rpi9;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FkoYUBMO;
	spf=pass (imf15.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755120353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sPsZZeB7DGQldN6iG3Vx6k5qI8fxoARth9f1NUHSsSI=;
	b=iBz4Rpi9WxTcQAgz21mRaJiXzGL0/voS7kE5lCyKIjSMewsaO/3ERnZxXIW82FckHBL1U/
	6bwe3ZiWDSa4u4KShETl99Jo2mhrHLHIPz1d8IOUGULcW009YpmeVAHe51C40XxRm+0Y8e
	p61sz3v271nRvXg8vD0GHdS/nun0rXYTev7bM/iyi3BbBqCK7LtQLntxgx4gNj8tTaiib3
	Y8cbNxj1XEmYmjulAd9klpfoZPjo8M7HJTudFf96eFNPTFIIQyMe8LJkwABeJ2OE3lSSH8
	xxHzXvSRhRt731NLqmY2sOK5/SyeeqkyHf3wxqyOlQ0z5LVAG2lOP6OjJQAMyw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755120353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sPsZZeB7DGQldN6iG3Vx6k5qI8fxoARth9f1NUHSsSI=;
	b=FkoYUBMOpck4thkYzrkH4Wn7bCKCkLVeeTC4Jc07kZMkjCMQCzbH85q3pzneGDLR2PhfLq
	Mig88eUXbmL7fsBg==
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Optimize exit to user space
In-Reply-To: <hzvjjgzf4cdvj56zeysosb7otkvplbbozzcpij2yeka4a4kakl@4l26obz3karf>
References: <87tt2b6zgs.ffs@tglx>
 <hzvjjgzf4cdvj56zeysosb7otkvplbbozzcpij2yeka4a4kakl@4l26obz3karf>
Date: Wed, 13 Aug 2025 23:25:52 +0200
Message-ID: <87h5ya7w2n.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7BCB7A000E
X-Stat-Signature: 3bt9836qfgygdwbcmszgtofxm3bkj6mn
X-HE-Tag: 1755120356-336272
X-HE-Meta: U2FsdGVkX1+einirezQ0iLqVnCNRRzxDoz/uI3/t3ZXWtgXVHJVzVgx74FxKekspaDPJhk023vDhiud26LFijB73S/bH2zuPF2CaFbGPBBxqAgyy3xfAHwT+fcA/1Bmz704qyTaMsHd8vcpwyuL33rOCZb6YqhO9vLkRT6wvMUI6Dxnoj3Y7GfYek4c12FRYvUCP6gLKgXCG+IN9SVRf6G6zsRr+zZ/ZgcPjoFZExe5ze9yLbh5lNhv7ecYQR10HSJ3ypaXgn+KfqKrNiNiJEYx+vogrEP7UvWpK7nsgvjRG0JGxFGawWdHLRe1yR9xdT9Wv/zYGIsWM64KnjlJELBbiOIF3Pdb1ljXq6lbKCQSdM6B2wjs7sQw1BgKp9x9YIt3a1IwX7+UyOwMrS8WmNotJHI/mFh8RrXoVq4v6BqgDlpEKQzaA2qPQXTYzWrNI8AUw6VR759Bb5x6ZrbsVt/lVNc/xpFXqHwJdg+iaWy5xxfj7W3vpjFaqfBwFsRhYzVDvSjfc7AKYdweHra2lS/T6P2wXEZGxZw0+X/vmluGa/kUlWbQK8O+W6Swlvjgo6+IvgzlU3h7p+fWdqspen5HPuzvxi+yY0VzOqK++clsa7hhUNrZ9GQGsRTG2kc0MVewTwSZPP2zBxmdvJenEl/VF20FxtMHlFsxOZQEz1D7vha2+wILWzysO/EQlkzC1XouV0J04no+iAYjni/RxB3akbNyayqhBi6ZemUh/klXxTq9cceTLox7wavjaajvOkzj1CrF8bWbDXuZWW9P0wR8+U4XTsGuPd8VVf3LrJ5Adr55KhzhgtBYFFZFFOiqJoweTbCUPh9wmGZX8JlrtsdYYqkgaxibDPvs6FoBzw+vRKx8SRBJo5qcDiRS3f7+mhXwuJbEZsNeXZqvOKHgXiIW2qbwTIZaC6DM4zabPBZnGJXUv8Io3hJSpj6MNnYOVxOmTPTPwiaOWEt+MADh
 Rvq6KxEu
 w0mfT3vW+/Zgopi5gU+YvDorT+OKOBNjI8FMrz+SJRfcqh/qVOAn5gPlq8Ak5P6fORfbzUCE88WfTWU29ilICTr3ernuzVQ/PoRwNOOADgdGLDOEkkv4ZaUhvUIzGYs/NSHHYHVKNLD8FwsJkRbbHVKe3zH47HzYy4xeeEUKbjcS83ZGvzPzLb/1tn7J9qcO1tEbpVyt1KZoerrxodrdTomaXu3C/sMdhGcHf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13 2025 at 10:19, Shakeel Butt wrote:
> On Wed, Aug 13, 2025 at 04:57:55PM +0200, Thomas Gleixner wrote:
> Since this is seen in profiling data and it is simple enough, I think it
> is worth backporting to stable trees as well.

Your call.

> In the followup cleanup, we can remove the (!nr_pages) check inside
> __mem_cgroup_handle_over_high() as well.

Yes. I did not want to do that in one go, but that's an obvious follow
up.

Thanks,

        tglx

