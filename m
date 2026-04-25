Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A12FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 21:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9566B0088; Sat, 25 Apr 2026 17:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A9C6B008A; Sat, 25 Apr 2026 17:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FBB6B008C; Sat, 25 Apr 2026 17:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E820C6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 17:04:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B7BCC19FC
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 21:04:49 +0000 (UTC)
X-FDA: 84698307498.17.296D9FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E6FF21A0010
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 21:04:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DNOwtKwo;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777151087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ve6CgzqBQQMz4Ha6RMOg8/H5yEbwriSnmgV728dVJs4=;
	b=Pt4IC+7C94R9MHVmiQCZRUFholznKvYKl3FkdF4CwN428MVaN3cCerTcQCcWgxyOiNtr18
	XOb/y8Ha8lk4Cl0+9uSPDFAakWtDg5brtFaRaeAegWiiA8PVOhOIKEZGM7id+JdH2MIe+K
	oSp0oVxG/VZy2j3P1mjm+nGeDFDjXv8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DNOwtKwo;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777151087; a=rsa-sha256;
	cv=none;
	b=Fv/nAwLhwQYJRVYE7PW/2/QOKVw77ffnpQeK6i5SXAZa8Cv8KaaKlIVgp6BUkM5lMeG8mK
	TExQztglEhO6Hszpdo5pzdYLbGmo2DGFz8Bqc8J2/LOxOS+bdariuxXjKlDP6HBS5hXAgM
	GJq7Jm9//bZndXgBKoyWZfmHVf5rr78=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 368D860055;
	Sat, 25 Apr 2026 21:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618BDC2BCB0;
	Sat, 25 Apr 2026 21:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777151086;
	bh=ve6CgzqBQQMz4Ha6RMOg8/H5yEbwriSnmgV728dVJs4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DNOwtKwo1mgKh8MR3NGdt8e8NmcYb5J4s16oMWSUwpVyuPahMZjwXmB3E8gLyURqB
	 34AaOktg9xvjfInuQdgQuFDUEFvxLW6XvNjJBK1HTxtlw588T8+m7WUWV9dg9m8yDf
	 BkWmZDdNnswtxrDYkyG2O+RTyD5qO3kg161Zn8Ec=
Date: Sat, 25 Apr 2026 14:04:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Haifeng Xu <haifeng.xu@shopee.com>
Cc: david@fromorbit.com, roman.gushchin@linux.dev, hannes@cmpxchg.org,
 mhocko@kernel.org, shakeel.butt@linux.dev, zhengqi.arch@bytedance.com,
 muchun.song@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/4] record non-slab shrinkers for non-root memcgs
 when kmem is disabled
Message-Id: <20260425140445.14ab61224955c88d359dd6f7@linux-foundation.org>
In-Reply-To: <20260311030235.240953-1-haifeng.xu@shopee.com>
References: <20260311030235.240953-1-haifeng.xu@shopee.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6FF21A0010
X-Stat-Signature: wikdjypnwx3gt4wqzisfzarpaj4zwhik
X-HE-Tag: 1777151087-580325
X-HE-Meta: U2FsdGVkX18oEOcm5MgN8y2bE2us20bHvV3wfrX9RPAbCbtCyfEDvPVRN5EpNBmntZNpGy0hz/tbbq4xwEHsft8T6+SJSdJ+6jsrmB0m25PSkIeji+w5GWWeEVRqf4TLLS65pu0xAuB0ebASXm5MVM6AW0PNcsuo9e2Mg36zZLpjLR361iIeVlpHbXmUdjBR3TXIT7DxhSFjxDptdGxBuKo2oLIq3XlbJEsAWPhpS5ByeXN7VqUPIN9P3dJ3AbfDbbr6p6rLaaN1STRCvMzJbDUbXyQNJ402e8rZvk+2trj1cu60ktjvrxTaQA5bfZisiPIOhDV7Fllk+am1EEefWB3373o6OgiNdS8nD1KJ0iFJE9svODFNhtSZ6D440/fPqUBKX8r524IPDuczIpwV1gSYCyADrJOHL2ei4ZsRgwILT48Sf0Sk4FxoPihawCSEn4Xxo9VVqfSR1mUxHY0CGFuRdGjXcPO2xsoGMZ7y56Ni+J1w0WsAXsFZVmWvmTgFpMqlDgye3N/BAXEU36pL1G4MAM9FxtGuf9hN7PRJEisEMhlip0WlfuVBrosJOOY+deldA6UOSTwNN9oJwU+T0vmdFzhoQOfu7ErGVPOZYYh0CcupxIzOeJlYpTky3qLg0/qmhJyYCbymmH1byDYm1jkOq9BFQsQPTHifG2aNSvllgChl9u52qJC76OLRfsO0vUB7TVo3BVGMk1OrT+X/r/swvebtLhY+3XvbOEOh447Rlw3MbGyosx4h+Hw8dZLanwLPMQZ4tt5LQ3nOiVkLxW0sFGHyg+lU0ml96NwxQUXSmq58H9kN5dJDTNKG//PC92yD5a1NQ7rqx9QPUn3LVI1zwT+UoD9ICAPsUsOuA4EKMhNYgi3gUtZcAYuzejPR02cALg5yQC/NnavZtpmwpe6FBMH0VmM1FgA8/REANnO4hcWgeXA3SsK7051HYtCsZo4PlpGjHtd3uVl7sZa
 2J3Z9cUy
 XZbw3Ju1G6Lx6pz6/2Y13PXQ+Me5YwCuIavXnHjXy1sjzRxaNTB80m9xpZ0A3S62fUBeOiH1OMUtqGE9woaJmwLHlyVlNlPC+nl56/2aAjwdjOSIl05UzZ5LE4vIAK7JRApzpoDEEhLn84mgIR8+Cpokzy1EU4e50gOPbjW6hgl3DnBGeM9ymumTNIwIm5Gff1poohEbkgs++K+qc7x5rsjAqbmzWTNqC+2ScatymYNViuAqdQfKNHjv1dKJRov0PGS5VmuvDHKySJz3iuWGzqIZvYEUKwT8dLi8sJuRSfNQCUF235shb0rYVXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 11:02:31 +0800 Haifeng Xu <haifeng.xu@shopee.com> wrote:

> When registering new shrinkers, all memcgs need to expand shrinker info
> if new allocated id exceeds shrinker_nr_max. But if kmem is disabled,
> only non-slab shrinkers is useful in memcg slab shrink. So in this case,
> it is enough to allocate non-slab shrinker info for non-root memcg. This
> can save a bit of memory and reduce the holding time of shrinker lock.

Are you able to estimate how much memory it will save?

> With this optimization, the finish time of pod creation in our internal
> test is reduced from 150 seconds to 69 seconds. We test it based on
> stable kernel 6.6.102.

Is that internal test some crazy thing or is it representative of a
real-world workload?

IOW, what I'd like to see in your [0/N] is some indication of how much
time and memory we can expect real-world Linux users to see in
real-world workloads.

So please have a think about that, add some words then resend the
patchset.

Thanks.

