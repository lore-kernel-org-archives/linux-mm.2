Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7725610F6FD9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C6F6B0005; Wed,  1 Apr 2026 11:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D186B0088; Wed,  1 Apr 2026 11:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853376B0089; Wed,  1 Apr 2026 11:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77E236B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:41:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13575C9BDE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:41:23 +0000 (UTC)
X-FDA: 84610401246.24.00924A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7776212000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:41:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XM3le0ln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775058081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+p4nmCiQBIo/7aL5VHwQRYAgLPs/WUMdW27dlmb0SE=;
	b=mU6+N2ritcvLzlElei3QxYe0x4R6tbH9WM6PI6rn7eDGtJ2AkD+lPBOelcygQ2R4Ft2kPH
	glpMny4rcpcbUrg7QfHDJ+b3hOFFkHeDsgVXDUya95CGESr/YJqEyD9mfjtQyUOLZ2/kcK
	FCeUbPfqztKDN/GaF293THZhljjyGsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775058081; a=rsa-sha256;
	cv=none;
	b=5G+UJA9kgN7nME+MayA0g1FDOTISO0sKMG9+87caZU/uo8zf1biYlwT7Na31djYfSXaTb1
	uCIeSGjqaadB7BI2AKYkyFDssNN+ji5pwmzP8+TvDokeOkg2WfGRfJZE3WWduJ11vACrHf
	YA9qJrpgB6tdKfzgY/lsoAnFetguGuM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XM3le0ln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B686361340;
	Wed,  1 Apr 2026 15:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0C4C4CEF7;
	Wed,  1 Apr 2026 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775058080;
	bh=S/VWLw2jpuJ809fs69jIdpFQnzH6zWS3RJfJT30T91Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XM3le0lncmNRcKu3J8uKbGR3DbAO1ZzKNuBwjwWrEyd6vSn0+rTTXTY7L4crjGW6K
	 C0axHHwy0u0Pi5ioLEzoa4Yt5sgKUm7w4minEGAKD3C1Htrp3hxEFkNY2VEzf31sh8
	 CnVAgLvb6sGTh+mupDNpczzTLcYMc2tYSHLhHpyTfixpNnp4vxbUeZB9HmG+DARyE5
	 NloFdgmUdeJVzt04G0sfY4On/8dk05wSlIL6CqqElbELv/PsTbt9qcm6FpmQBPQbtm
	 qRHfFInL11IIrcAzdpj+CZ7ZBKiuatmIv7TJ7POpdrEhgikEAiCNvJaSOMM5DMJcgc
	 SElmbA8STxEbA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Wed,  1 Apr 2026 08:41:18 -0700
Message-ID: <20260401154119.67874-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401082439.12612-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7776212000B
X-Stat-Signature: 1i4d7uxmip3shknjs8cbeg7u5au53ic3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775058081-210317
X-HE-Meta: U2FsdGVkX1/to5SaceVW36cLZVPraZpZOnrug1mS+iJtUdTKM/3HdDGyfbuvQtEv/dImShzt+F8kN1bPwkH+3CrXx6H1j9D3dbp87BmHDbJPyb+DmQrGN6MD8tYk3C8RkFjs7Hct4ISFRV+gHqO+/gJ2k8WGzBStKFSciiLEXgBchdEPAyYzmNI+afp9+ieWsEqTS7BvOE2bB5kUk4P6Zp/WW6MTTrNHihoEMAB6dGKoLj5un/3YD/1kg/9N3SZ/9JVwqshrLWjLgl71gCEdZ803KmYVfVv9bAgagcB8vj1C6WV47L43f2uJE0mmZRzJVqYRd5SOclqHM2Ipr7hmv33dqdZVVvXA/xxM3PWMevoAEyTMhB9iV32BO1IdksGtePQvj0R7pPNTZ4wliUQ/dz9uiBkkkwJHfZg+A/6wgHwynSu2URrlbaaPFMPQuj7hNnjLvF9Oq1S7Goiz+Vzje++5Jb3DN0dpxKg8WlOC6jElanAtttEc72KFBWqK3SVdHRhFyMTG7T8RNlNvhWS0f8C5u5MGQIKmUyTIjb3WirxqE0MNwSdmEk4JcxnX4vY5SDVuSe+4vJyJtcUUXjcbrYOmWn7e2hia7pwojXnPuqZJqRbFMTwDV1e6vZc4+2lFVkmPi7WYuwuO69DyiDNT6/dpnpmF+rHMW8LbNbXuqzStlNvttand63xLycVTU2GWXLj5hwermwT/jOj+zAGqZIIEnbVJWP9NnfXmCmXKGHX2nr0xc+Sfpx45OzZLustLo9hvTVu+SZ8hursA2jU+IFLcgu7qjnz6IeNxXlm+uw6bXnZ39BzrUW/wNS+gBAe/skjjMiX/Rmvt7QeNlYaIL6m4IUQOyXODiLdTczV0/U2Yq686K2Fy2PMu9DQp7UF7zTxjO0LGOb9X+yaQ7jWoYyby6HrzJUHGt8trivbg0mocbBCes4Lf/DAE3mANXTSLNUFIC5jtJfPgErv1YM0
 n460G/6r
 ME44htXUpHwWiLcZvnWXgdPGBYr/V4aOPW90WU1FVmYhnqt37+bnKqOyjibzT+SSGjIqpWpdOyu6Xl+rm2oB0/qwUdEvdPWLt0h/iD7jPyOHi3iCOrinnRZz9T3Sw2CuFDVkI7lz1BL2aCgzOc0K7qnDgmkXjxMg31AmIqkJMpXPK1J18DNkiWEKzShQrDfMB6d6y1z1ss6TlstFOQqNOKwCgqsEqEwrElzbTlygYzYbpBsWV8CrUBXZpEccP7PBJyowj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 16:24:39 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Tue, 31 Mar 2026 17:44:00 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Wed,  1 Apr 2026 00:09:56 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > > [...]
> > > > Option 1: Introduce a generic termination callback
> > > > ==================================================
> > > > Add 'void *after_terminate_fn(void*)' and 'void *after_terminate_data'
> > > > to 'struct damon_ctx' or 'struct damon_operations'. While this extends
> > > > the Core API, it provides a clean notification mechanism. When kdamond
> > > > exits for any reason, the module can perform its own cleanup (e.g.,
> > > > resetting 'enabled' and 'kdamond_pid') within its own callback. This
> > > > keeps the core logic decoupled from module parameters.
> > 
> > Maybe this is the right long term direction.  But to my understanding the fix
> > should be backported to stable kernels.  Is that correct?  If so, I'd prefer
> > simple quick fix that can easily backported.
> 
> I agree. While I hadn't initially considered backporting, this bug
> certainly warrants it. A simple and easily backportable fix should be
> our priority for now.

Thank you for generously accepting my concern.

> 
> > > > Option 2: On-demand state correction in the module
> > > > ==================================================
> > > > In damon_{lru_sort, reclaim}_enabled_store(), if damon_stop() fails, we
> > > > check is_kdamond_running(). If the kdamond is found to be terminated, we
> > > > forcibly reset 'enabled' and 'kdamond_pid'.
> > 
> > I think this can work, and simple.
> > 
> > > > 
> > > > My perspective
> > > > --------------
> > > > I personally prefer OPTION-1 because it ensures the sysfs state in
> > > > synchronized actively.
> > > > 
> > > > OPTION-2 is simpler and avoids API changes, but it's a "passive" fix
> > > > that only triggers when user atttempts a write operation. User might
> > > > still see inconsistent value until they try to interact with the module.
> > 
> > I agree your concern.
> > 
> > > > [...]
> > > 
> > > To avoid over-complicating the Core API (Option 1 or current approach),
> > > I've implemented a lightweight, on-demand synchronization mechanism in
> > > the module layer.
> > > 
> > > By overriding the '.get' operator of the 'enabled' parameter, we can
> > > detect if kdamond has terminated and reset the module-level state right
> > > before the user reads them.
> > > 
> > > Since sysfs parameter access is protected by 'kernel_param_lock', this
> > > approach is race-free and keeps the DAMON core decoupling intact.
> > > 
> > > Core Implementation:
> > > 
> > > 	if (enabled && !damon_is_running(ctx)) {
> > > 		enabled = false;
> > > 		kdamond_pid = -1;
> > > 	}
> > > 
> > > 	return param_get_bool(buffer, kp);
> > > 
> > > Test Log:
> > > 
> > >     # cd /sys/module/damon_lru_sort/parameters/
> > >     # echo Y > enabled 
> > >     # echo 3 > addr_unit 
> > >     # echo Y > commit_inputs 
> > >     # cat enabled 
> > >     N
> > >     # cat kdamond_pid 
> > >     -1
> > > 
> > > I think this approach is better than my previous OPTION-1 and OPTION-2.
> > > Does this looks good to you?
> > 
> > Looks not bad.  But, what if we read kdamond_pid before reading enabled?
> 
> You are right. To make this robust, I could apply similar '.get'
> overrides to 'kdamond_pid' as well. This ensures that reading either
> parameter would trigger the state synchronization.
> 
> Would that be too heavy? Or do you think it's unnecessary?

I feel it's bit heavy, or duplication of code that could be avoided in a better
way.

> 
> > Also, what if the user simply try writing N to enabled?  Wouldn't user still
> > see the partial-broken status?  So this doesn't seem gretly superior to the
> > option 2.
> 
> In that case, we could modify the damon_{lru_sort, reclaim}
> _enabled_store(). Before processing the write, we check if kdamond is
> still alive. If it has terminated, we reset the 'enabled' and
> 'kdamond_pid'.

I agree this would work, but again I feel like this is a duplication of code
that could be avoided in a better way.

> 
> > Based on your above reproducer, I understand this issue happens by the
> > damon_commit_ctx() failure.  If it is not wrong, can't we catch the
> > damon_commit_ctx() failure from the calling place and make appropriate updates?
> 
> Yes, we can. We could check 'ctx->maybe_corrupted' right after it
> returns, and reset 'enabled' and 'kdamond_pid' immediately if it's set.
> 
> Do you think this approach is feasible?

I think this is more feasible.  But 'ctx->maybe_corrupted' is a private field
that supposed to be used by only core.c.

What about checking if damon_call() and damon_commit_ctx() failures via therir
return value?  It seems damon_call() fails only when kdamond goes to the
termination path.  damon_commit_ctx() failure always causes the kdamond be
terminated.  So if I didn't miss something that could be a path forward.  What
do you think?


Thanks,
SJ

[...]

