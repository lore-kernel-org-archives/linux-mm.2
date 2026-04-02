Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 698D8D3942C
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CFA36B0088; Thu,  2 Apr 2026 09:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8804C6B0089; Thu,  2 Apr 2026 09:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7963C6B008A; Thu,  2 Apr 2026 09:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1756B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:54:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEB378C377
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:54:44 +0000 (UTC)
X-FDA: 84613761288.24.9C23A43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FEC51C000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:54:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZVhN5Kl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775138083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ay4X9snrGVCLWTt8S00mKJF82OGzsWfXAgwhomAhao=;
	b=0jXgI5jwVm8KFZ3N4Sum0LxPEFhIOyVlPKJpZ1veuisoM+GUku0Ohsk3hglBOsU3UN98Aj
	ORFwtDMge5pBFiXfvNCBk76jY7pS/PihJvqmleTDLcVZjV0jw4YSv3a/e/oKDHbEcjsQO/
	X82juMGPjJ/bBAvQ4NYXIh+61W5zJ+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775138083; a=rsa-sha256;
	cv=none;
	b=7rciZ/AlmxIdKl9f4GD1a5j/agkGtNFHVj+54Yhi51FLrQDpih+URGMyCh8hxB8gYfwOTT
	ARmY34unpKxy9NxVu1I9NYKVr7ZoKJPWEOvtwzUfqLFO+8vEHipWOGMkfNquqlnoKjJcsv
	kVYRW8jJKqOAw/MOHQhuPRCNMDsVXDc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZVhN5Kl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52C2360008;
	Thu,  2 Apr 2026 13:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71BAC116C6;
	Thu,  2 Apr 2026 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775138082;
	bh=jit+uHKm3XCP/g5cWvTSmT120u1mtEgOpbGBxwaH+XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZVhN5KlL11K88wefykFNw4z0BUVVaYN+y7IX2XX1QMgigoA+xMSnAjA61UnQT+rd
	 vemx26JRp2EEMsXbJDnOVg4t0JlQxKF86RJ84qZJuRigcnmixLwXajrPFQp2ARiekJ
	 kBL2aAHsuryGKnwU1ozP++iK8aK4els6QMxWiq6YkcECh2oLlH93urvXwe/yH15IIb
	 tBTnl8yZlXbNQeV0cxiI4IUS8/jcPqwj0WNdaZ1KMkT/9kCZuV1NwbZWHdfM0QRb6f
	 wnyFkUWB3uaDe4OJqv202bnVbc2P+fVGfPNtI6Q5ro4FO+XjydWdbxCip3rGi7wwsp
	 y6O85Rk62cy0A==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Thu,  2 Apr 2026 06:54:39 -0700
Message-ID: <20260402135440.74339-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402053458.26524-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3FEC51C000A
X-Stat-Signature: x6r99xb5aw3frzmd6r17demh3b79nnac
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775138083-423394
X-HE-Meta: U2FsdGVkX1+0VRHuCRp2lpsQB9CGq/9Lmc/LXMp9Gb79oicVslkjvqiJscuguTyb43A5lwLaqEtUhx1uiEvPwYCEtcf1wRUGc00qVUxl6FSXiAKt+KEk1tMzyPVShtQ+kOxGrB2F3S20GKrs26fS7dhRLiwPTaTnHQbarQ/S2sAmCdH6Lyn7qPaJ2CmjxwSMyR6ebYRHL1BHeGvDqYpjxPUPVw7Tts8h22pDE1BLcO7IGGD8Iy7aPDBNUi+rxzqB3tvutmQgzkLfhqcJukjTaFdpF5rzp0jR7HMBsm1jyZb97WfeW+fCNU00scVhYSo7sWyal4PanqYtX6E6rInp7y6DInsubXrECIkkiksJk0QAvvo6ma2A8aZZG1uzXlyBaRuWWZL8+ob7uhRaayq+inITjNuC7JGF/nfH42fWOAhaRvR1hBX2zidY9iYa60EvavAMMAou83BCpoVQ9OtWA1dkhGIKFIRDiFaKN7iqx3JxVX9HztQcUn+kwZiV2FY3IX1+uDZDO6IXLIVpYc65hxcXsk/jouYbEpURQBNiYc6HJzwu2ND/QyXsGx0gg70AHm2lT9INCKYHlUrSf5fG20k/H1MB83JgHHPZaidHGftS+lK9qne89Nw6L/kgqjw+ttgF98BC1RCv8+ROzUCBHnelHrklOgP66/3CQhAh+VK3zY3PDGC4voX28/rnjPY7QyA2S8WznmINy0MuWoDgWLRcUdT4x5DKwx3mtmAfJqLfpYShgfMPl4qUqZbCecJJM8RxIGwVkxa0fbsVtgER94g9sxd1ua1eVPpukJY53mj5ctmoGexFisOdFKTAEFZls4trUvdvHcGkNk7MJrSdAk5mwOziufPruB7jT2zEYUn5o3GMvU3NATHvImnoj0LmFqxi4ziYyhXW1NNv8HWqVksDoq16uz/yXAsxxKPVpH0eBg/i+9qp1RUhbtVK3PQ+vhZ1XNU6Mhbdw0K0Ff4
 ws//0qFf
 8V9EO3MHGZK2wUtPeU/7Te8wec3pkMier+CofhqMaMKlvThIQoWKu+NH9p2LQ4lL22vpKeUf46uAnjQ2lFhyZPe045OjuvlaMA1MFkddkb0Ck2M84Qt4X/S6cDh3eBH36Enk8MZcPMNKJSmEm70M4iSLMpods2xRkp/Xq8jPPzPEnsnJSKYv7MU8fDTk1lgXxnso0Bsvz2V8OmBLiw0MjSDgbnmEZZVvpycij0WgZ3N7GSJzmY+cU5lJZct6YIWArP7Kz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 13:34:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Wed,  1 Apr 2026 08:41:18 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > [...]
> > What about checking if damon_call() and damon_commit_ctx() failures via therir
> > return value?  It seems damon_call() fails only when kdamond goes to the
> > termination path.  damon_commit_ctx() failure always causes the kdamond be
> > terminated.  So if I didn't miss something that could be a path forward.  What
> > do you think?
> 
> Thank you for the suggestion. I looked into the code and I think
> focusing on damon_commit_ctx() failures makes sense.
> 
> Specifically, damon_call() is only used in the damon_{lru_sort, reclaim}
> _enabled_store() path, which doesn't trigger unexpected termination. The
> main risk comes from 'commit_inputs', which calls damon_{lru_sort,
> reclaim}_apply_parameters() . When damon_commit_ctx() fails there, it
> reliably indicates that kdamond is terminating.
> 
> My plan is to add the error check directly in apply_parameters(), right
> after damon_commit_ctx():
> 
>     err = damon_commit_ctx(ctx, param_ctx);
>     if (err) {
>         enabled = false;
>         kdamond_pid = -1;
>     }
> 
> This covers the reproducible case (addr_unit=3 + commit_inputs=Y).
> 
> For truly unexpected termination (e.g., memory allocation failure inside
> kdamond), I'm considering a fallback mechanism in enabled_store():
> 
> - When the user writes 'N' to 'enabled', if damon_stop() fails but
>   kdamond is actually terminated, we reset enabled and kdamond_pid.

Sounds good.

> 
> - When the user writes 'Y' to 'enabled', if enabled is already 'Y' but
>   kdamond is terminated, we treat this as a restart request.

This sounds bit odd to me.  User shows enabled=Y and kdamond_pid!=-1.  Why they
would write 'Y' again?  Yes, they would notice kdamond is terminated in real,
using 'ps' like tool.  But even in the case, I'd imagine users would write N to
enabled first, and then write Y to enabled.  In other words, this could improve
the user experience, but seems not really necessary to me, at least as a
hotfix.  What do you think?

> 
> This way, even if kdamond terminates unexpectedly, the next user
> interaction will recover the state automatically.
> 
> Does this approach sound reasonable?

Yes, the plan for the next version sounds good to me.


Thanks,
SJ

[...]

