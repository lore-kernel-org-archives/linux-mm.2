Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7537DCD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 16:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7F86B008A; Thu,  4 Jun 2026 12:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF9E6B008C; Thu,  4 Jun 2026 12:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5816B0092; Thu,  4 Jun 2026 12:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0B256B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:50:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 696E58C343
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:50:14 +0000 (UTC)
X-FDA: 84842817948.15.47E2A69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9B7DC0017
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:50:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aJAG3WSg;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780591812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQM2oAwH9sOdxU7ZJ6Wbzc8gk7FiaryNTF5Gp9vtO2k=;
	b=GA5DtGF1bKu77IXMJvCUJ5etJAxB5iK3cKJzaqiVTwKX8zlEGCqsy2sVjDxjQ7aULr7Jq1
	Wi1Ic8g8kEmcsV2M8JlpscYoAEkmgiqxAo8gMBFDM+wE6MZPu0Rp5Y/acSlIdxFbnY0KOl
	iIZOzgfIhNFhUMQ5P3chmCmbyrP1O2c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780591812;
	b=jVtkxsTDE/050Q6Kj4NtCVXSuZKJ6ECwC/nv+2MxzhDykq37btSZSATachyXgQMc/RfV2I
	Ro2Siosbv364HmYVVIZlhHfpBZY4GxO8hltmN6YmU6plcJ49covizo4TfM2aBUzuXtgA/u
	sLTB/T8i+sg0suHL6l+yXguPKCqmMsc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aJAG3WSg;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E218600FF;
	Thu,  4 Jun 2026 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91791F00893;
	Thu,  4 Jun 2026 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780591811;
	bh=jQM2oAwH9sOdxU7ZJ6Wbzc8gk7FiaryNTF5Gp9vtO2k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=aJAG3WSgvGrImZ5mo9o/LnFScifnNkL4CEKMr9GhNlTwR2MwGOsP/lxBKEPsVQvfp
	 E5cftbTAzq7KUS3dqb1RM5EFJcpXnlc7I0JlQcktF3k/p64cWmdBtrmxE9ZjejP+AR
	 p2fMI2vuMmrMZXWPak1G/CQ0Drs0Pou6XLT91HXDjUCeDKmJcRdU4x0gtVOunW1DOf
	 N/caZGcmMFEG/HYtbMYjk3BNAK3cdZ099Oz66D7OmDwvuEZOkfG9FMHG4fPyFuMEg+
	 W4aKUIe4YhGMPYxSay3P3aIzMVrlVlE7J+z2mCJSt8LW/U7Bytccwp7Np6IlljjXYv
	 NfaYcXe0f3ftA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09C73930A0F;
	Thu,  4 Jun 2026 16:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Take mmap_lock in zap_pages()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178059181241.2942053.15264975706579133260.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jun 2026 16:50:12 +0000
References: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 memxor@gmail.com, eddyz87@gmail.com, david@kernel.org, tj@kernel.org,
 linux-mm@kvack.org
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9B7DC0017
X-Stat-Signature: dexe753nf4k1mou3fxoc84qigyoj5feo
X-HE-Tag: 1780591812-217166
X-HE-Meta: U2FsdGVkX1/gLBX19dS5zv3Yg4pkCo/FfEQSLVm0b0nlRNur7uBpHve+tMUEkzibubwWsf2U6OBkU10dsyD4jnx8TJAcRRzoNrX7tIddF0gZipjUdteF6nGIEarxgfWRafk6x5I+e0mWYxI5u5JazrYM99AK2FLaVcMhd/MFxYa/v47isKg33pbuQDBNKcwX+3ElSj0HBscALsNQkkrSG6Kse5wnFcSg/EeFXSt7JkHcHOPhce5jNFAug4wyX7kZ8fKYFrX/rommaO2qw5J0KpN0tIsKOGDP4SymKXAoSrQiRP1aBaqV991FNl39EEKrp2tn041LvjdoyN6v1SyLiwlj3GEf+b09U0evjstcYQCyb+tJDhM0DDV5dLbXZTvEvyv6NZHdlk+dS+ENgQypyzwfYcu3TN0rTRySMqwF3jtw6ZPT9fVpL/MFF62/FoEQszFPk5zIk/Fhc0SZrgOwBjB28dPfQVSDunlgscQS+IzVPk9WUyXr7xaJ4Fga2+u5CML7G4xI7Cceby/h2QCaGBNBDEFDZyjt6HN1IP7HiY32xiR7dwJJmy27yPpGZ6c1BReaBvQCgA9KSvQyxg1c8TTCNH7kyO3sGUGoV3x9n38V1TzGSFABWh9iBDPjCpSm+fq8DSkYwZ+tEe+mYNHsC3GJN2zjylDRnDRaiHhsbCZLcUG/pKsQOkfXC6gHfztC5D7llF0tdIE4+5mgwMkiLqTwxp/jhPevhKFZfnvN4z8PIwDGJb2a1GTLSMpThBHJgzIL7abqqtHEjyfOTqrJcalSX+AhZqplSS9YB8vhwUfVYhnf3kPfz7TNkkbM+bA5J85agGPTRX8V8YiKpTqDtR5SMCB+uZr9TjQGxj5RT0gJ0OQk38FDTodcid+6/Pesa32yZ8cl7opFeyOMH2m/aQgSDsYtJCDhuw8pHhDFSMRaVglsCLn6NBxP3I7SeuQIvi2utdrf0ng6ew4ZDp9
 1eh9DfaC
 zD06J7hT8TukVQqLIkWYovDvFuRmqPY16kKNV34opFAkOFdn8Rd/deaELwY4mZwGlJQNoDvgFyJbiJmofusKfs9Hq78HIsKv1CRGaTH51vft7JuhCG9rsYcNGSEsfSWKrVW8qNGJdfo2fh48exur+2o7ngdMQYXxjgoSDUI4ILOQGgKadBRKbMsEPb2H1+vHacBlIxqNOPIX5g/QMHSVa5PPCiSoPWdrpjWhdGqMkQso9UNx89lZShadCBE9CtriidoMjwx/qUB94C9pcqji/qTjIqHc1/83xZgQuUR1z92AVA99rWRyRIPzJqxEL9LLHUoIAUuAZXGobmUZ3zap0G1OS8wsFor1MG74DG3IOi7At2onJ0VvpTpih/RYabXfhtFUXICs9x2XV8khHS8ySo031Tw/yJeQZ7SR1vpwsZ5bJNedsiQ7D38/+/RIpRcTTeMhH9KpHJIcQfjyfTGIp2mE9FSOIDrrwXwgtLfwk/b+6wA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 28 May 2026 15:20:14 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> zap_vma_range() requires the owning mm's mmap_lock to be held.
> 
> Taking mmap_read_lock under arena->lock would AB-BA against
> arena_vm_close() and arena_map_mmap(), both of which run with
> mmap_write_lock held and then acquire arena->lock. Instead drop
> arena->lock, mmget_not_zero() the vma's mm, take mmap_read_lock, and
> re-resolve the vma via find_vma() since it may have been unmapped or
> replaced while waiting.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Take mmap_lock in zap_pages()
    https://git.kernel.org/bpf/bpf-next/c/80b89d0226a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



