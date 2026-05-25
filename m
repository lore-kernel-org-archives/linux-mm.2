Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832E1CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 13:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2C06B008A; Mon, 25 May 2026 09:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62626B008C; Mon, 25 May 2026 09:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51A16B0093; Mon, 25 May 2026 09:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4896B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:53:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C952897DD
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:53:27 +0000 (UTC)
X-FDA: 84806084454.26.4BC024D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B8524C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:53:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZofNUtFm;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779717205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qi46Rt48Kr9CUNAuhE8+AogLbpV9sC1dRJVHiMwYPc=;
	b=x+gqkqLFOh0MvODXtTUenH25e2pnwjiCh2Ixtwz1a+QsZVSjWEkJVglf749gnMv5H97ta1
	4qMlE5vFnOCwXuQ1szH/rAjc12VdRg1PqprhpE7EkxD4pltMP48D1roHPGfk3i6Qth3E/j
	sn4FyMY56pQBu29pQOYsbRwmqsA9WsU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZofNUtFm;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779717205; a=rsa-sha256;
	cv=none;
	b=RQOAzvmdjMyvOgQ5GrQHzUdtAGa4eSDEqHZEgRk+roKvTd2JH/sD0AJjQO6Eb0zuEbnhuo
	o4nqatWnYjw5iZKJ/6w7FNCGYOJQoU5M3VJv994X8FVN0581Ce8Gw9vRVMDuChhPUxYXHn
	GAHjJWtgYe1WgnVgp6G6ln6kiGd1Ld4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C8D2600C3;
	Mon, 25 May 2026 13:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24481F00A3A;
	Mon, 25 May 2026 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779717204;
	bh=0qi46Rt48Kr9CUNAuhE8+AogLbpV9sC1dRJVHiMwYPc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZofNUtFm5U/XV4i9kVPHrrDIXF9313RyDI8LJtiwZSy9/VhGCaigGL6511xRPjTtS
	 VbsCFniamG+JHdoMqb3VHy0QF9svac365gfi3bRU804rnpYgUIsCe1aksCmXhsp55X
	 2ArU1lADUxPY8Ysx16tJ0PzesohFt8ilBMjWcKzs0rHbwZjfHSAtzs5gajQ48yQ9P1
	 6f836RPtX0W1yiiLlo57ydsr01vaaRXFZHLiFY4+2OyosenF5uFoOswutUbPxqw+vT
	 wDq0yb4p90aVyNabCjOeX0ezVG3PI0np44ocTc6tGPJvCdX+p5El8uP89EkNlzyzcS
	 wkWPXq4ZXBzGQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0ECC380AA60;
	Mon, 25 May 2026 13:53:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] cgroup/rstat: validate cpu before css_rstat_cpu()
 access
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177971721165.2579362.15091579325825161865.git-patchwork-notify@kernel.org>
Date: Mon, 25 May 2026 13:53:31 +0000
References: <20260516070849.106141-1-a0yami@mailbox.org>
In-Reply-To: <20260516070849.106141-1-a0yami@mailbox.org>
To: Qing Ming <a0yami@mailbox.org>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, hannes@cmpxchg.org,
 mkoutny@suse.com, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org,
 ast@kernel.org, haoluo@google.com, yosry@kernel.org, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8524C0007
X-Stat-Signature: 56fd6m6mc3eewy4ot1w5mq95krwbpgph
X-HE-Tag: 1779717205-887653
X-HE-Meta: U2FsdGVkX18lGafONqXgx9UA0PAmalnFk1AH7mQodSRrHUzfMOmwr8pGHlpS0DtEdkKJpCkvKjtq4nB80lAhr5ZEJPmo0diIOB2OLLZkicqRzLfyX8qb0hdF5Y/FbkQPMOuB7w64DrH0WkPiVx2wjtsrAR8ANfklmWp2LB6BZIFEjFaOvYrsxmcrm+jr5WHkjKpRxH2zYg0nH8CCwDXdQJFWoevZjcShFpdTA83fQv6WxrNhdS7yWr0OBrzyJNZ3Rnf1fiJuCoO+8JILAq4mUmV4W6KXmtpMo8Pp46g+8TmcnDYyICdSWb+8P99Rv3yYA2A7jAgYqRXNyLPx6wNP9g3nHunjw6/I5GR2toTNGxJDrHfbouQNsxjQVMSnk0WY4ySqwwcy9gy3+ovdRjhJG/EDrHGVeqv4u+Dq8CM582yKsUOXCHDwCAyK6OmHi0hFh1gTQu5f9RxRlEqXbkleQVBrYGe+MC+LR5xgN+CoxZ/4YOXTpUtM2nq8yZqfHHRnd9FBrc9Iay4Niu3Xs4TNNusiLJFlVL8r2o4+7L+48GyILFZh6kXQ7Xy1CLFJFmDC7IQdJ4X6k7wkbeYccG6ayksLXxZuvPCcu/sw9tPKsRT08oCRx45wFSSe4dYnyHKBZ4NVUv9dtmzD0cY06XA4FYoxAfAzssL6Azt8go9MCUSsde1uNIByK8PGZidKVAwjMTZykxdmcnRk4kRrxC03iafcxR+t2VZwCIH1Bh4fpnCnU7oCyLWArz826100ulA5xtV+4X4NKLKhRHACdEc0GjC3SiriCr7Pg5U0ILs85DnpnGAOuLgCN6uwQKAxp9GUkXQ5MNKlX11CpHODPyS2Yg+VbKRIJ0CTlXaJLzZK66YM9BcHzVp02hyvYTbi6uZ52V1nzcOVFN6AW7m1bNV2B7ezITpdCRyxAx++cqsrcPZ3tL7Qsej1FaHR+QXtXWMuNvLAxI7kcKOuiyF1hm4
 Qobkvszx
 CdJuxVy17NDJGGmU5WxxJsRZMIsqw+IlUtJBlDVP0/2N54u6g6nvuhpPsoRMDgb+tM9Klm1ycWNINykSnuqJF5SEYxBgDIEjyxASH0u4QAsblmFxSfI3s+UPn3Xw0kwwqZH7V5Ub/EtUvV5rbnSOCiZMk38ufqVcho7av9HiUOb0mbcDB2KXKaQ+AtvSANb9GzqUlzGx7lri9HaUaPtLW2CPZx57UNoilOrk9mINPHLs87cw047lzaSXRi0ow3uWFvNuBHeJGBkdiohZ2R9Lsz3vMjDRr5MeZtA/IAqdFyfOzSXlr8J3Ed1tAQcsSHj8sWQjgAZdAM4VCHDy4xWoU1yLcJxfQC8Zd28Sf4ILjsy1dNV4f3b3MJ5JfynmQfdC9UdQx0vyIUBUGCdyNNz3EAm0PTyCsCXK0lTUgz9p2tF2YMiIKtJbHeQNSyvZJpW32fgAxMp2rPuUYywwZl7EEAMIc/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf.git (master)
by Tejun Heo <tj@kernel.org>:

On Sat, 16 May 2026 15:08:49 +0800 you wrote:
> css_rstat_updated() is exposed as a BPF kfunc and accepts a
> caller-provided cpu argument. The function uses cpu for per-cpu rstat
> lookups without checking whether it refers to a valid possible CPU.
> 
> A BPF iter/cgroup program with CAP_BPF and CAP_PERFMON can pass an
> invalid cpu value. On an unfixed UBSCAN_BOUNDS test kernel, cpu ==
> 0x7fffffff triggers:
> 
> [...]

Here is the summary with links:
  - [v2] cgroup/rstat: validate cpu before css_rstat_cpu() access
    https://git.kernel.org/bpf/bpf/c/8817005efbdf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



