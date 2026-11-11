Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D610E606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlG6MDWB
Received: by kanga.kvack.org (Postfix)
	id E04746B05CB; Wed, 11 Nov 2026 06:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB376B05CC; Wed, 11 Nov 2026 06:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1C26B05CD; Wed, 11 Nov 2026 06:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACE716B05CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:18:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2665C12026D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:18:50 +0000 (UTC)
X-FDA: 85422590820.13.398DBB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7B6E11C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:18:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlG6MDWB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGtA8oHwJxBMbpFS71S5aylj40/O50v1rdQBtx/3tAk=;
	b=hXTu2sN1DTszOdc6pSccbg1rXavElZXx4HFEkbnOA13RviHo++SonxBdADuXNViDjuGHdq
	JwrGDWxNH1wQOBbb9q/7ycIIqTGyM+KChhKSf8T4KnIWFWXoJQIsob/IHIfO0jftDKKmVY
	X+VEB1vhycH8ahqAb/VZA0htci5hrIQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlG6MDWB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395928;
	b=1Yk6t0WxtZB9IJJFvKz0Em1XkRwXhQ1iZssnBUewF9FS2hGjdwxzUkKO9MTRo5EZKKv7LQ
	C8KErqv2hIoLPqg00RS38kSpY6DL0RE7SKUhXlUt3pb9vXAI7bz8vEmelfaAVH7NoGSvr9
	vPXqQED98FA/4tvcdrykf42OKrWQ9WA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A177562EC1;
	Wed, 11 Nov 2026 11:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F971F00A07;
	Wed, 11 Nov 2026 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794395927;
	bh=LGtA8oHwJxBMbpFS71S5aylj40/O50v1rdQBtx/3tAk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=hlG6MDWBY3f1BLNyjZYL56zodU/rHV9hZ+npsdSbztWpev2Pr3j7saWo7HrZR9h0g
	 r/F714KjW5XGwjw7RKw9cII9h6AK6haRNUANV5ARKvGJHmqiimNq3j6T9ddmR3V8Hr
	 zVtJJ+FY1hAA7mkWNHYX+EcZEvzkWUGg0rq3wsUcNo5a7gS7CI0wO8o3DXznPVIhil
	 9IvcoeMkIWcxahIopQgSHyi+oklrqZv2T2QU19r4qs9exYAUTwEN+rbLCTpB/pGAeg
	 2RsS9dQGmcstxsPmOv94KVlDlM8arNS0cnTDwJa6FF65R+eIt126qpFl5CaFq98KGc
	 T6HtQw9NEaqQA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 0/6] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
 vipinsh@google.com, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 rdunlap@infradead.org, graf@amazon.com
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
Date: Wed, 11 Nov 2026 13:18:40 +0200
Message-Id: <179439592040.425130.10808690337075841196.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B6E11C0006
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: gec65mz7hf15x1cy8kkcg1d7hrzge5b8
X-HE-Tag: 1794395928-640818
X-HE-Meta: U2FsdGVkX1+8GsJFDspZ2npHgF7xaHmDP4kDvYNd/+xX0dKuWwPKD0Pi/K0yXYoYgthyXmHyN/+yl4t1crNu/1L/vvpLdmQwCCrqi+dgwTkMyLvQxtrWtobI9y+hjab7Ylg0S2ySK10boxTcPTxorNzw04BD5K8RjNoUo/1TNTQ2Qv2u8egfv+9iiqyb/kUXWHedSC6hIVAO4n3hmUt5qu3d7X72ifqIxAgrYn7hNyzd2d1McsUAlD5Sd4qPCUB2LK3E2Rt7JMUMg6ZMCdc/Hu+g7602/N84Nu/msYtZ/odUAk9Qio4V+pIWgAFfebTq/VN5upD4CO1hPCSlUZmzSol1C7u/kaHuOgStZGRGOcBH1plGauXSXw5pB5XnTC4H5Gp0QVsZiLKn1szfAraZRUKpKoqOajsY4WwqYvUpDkLluHkT1hEnrGQXjtmcOppnQBKFH3zOQWO7bFV6YfC4UCW+OO8gLk8vxgX5KGhZohKXpKVyGEpMcmdMXT8eGcZyL0PUOY8nT4guQpBRRofgytVcB4BQAI86y8JR3FTmTgKHRGPONTaMo3mgVenzdshLLJhK9Ouq3GcXcPoSsAtCSQleYFeyvjnmmjzCqENc97WyOtSheDlKSb2izk1qEcjzLp+zfZjSpGhgaV/uxjESEOV8lM1QWr1dYJo6BY7JqxHvqwtvGtvoEJMcwQhE/DgQeF5hkV+zb7fdme/QWjQ+99DbtqbUedmInXCPggCHIYK9bUzw4Xz6/1HeOgSD7Ik1oGg63Zcm/bkgO8T0UN5i84F1j0vvg9xTc3ZV94WLaRarTRmqaR30ymjZqHldBEuk49JZBoMGSKi4LnW6rr4vM8YTjrkcaO3J8rEg0nrIXywZWPPV3UMUvoc8IzMUVdaa9zcDaD4KOrKoD9w369trCAXHDOhDOThq9QwTcAZI1YDwoKR96tj6dFCOJIRyfLkUf7jSgr5nPSEAHjRuLNt
 gsEL4vmq
 mFGw1sLKapAn30JE/mRmPdsBbjDvWN1moBfBBu+mqU1lp2rxJVTALUjBpw1ff4r/uq10vxT5ICknsLJYzbDprvmTT1ErpWISDg7sObVM5UPxBnAysnLPLndZY4kBSWB5adoreaUeR1qWTzbmQTAwYo51V+PZZfs9iRqUgoNDePfXj4QSs+yIWxAn3NpvN8NleBXhgdD4BZJOaY8F4q4jx3DPiu4EQOs0Iv+AMnn7FkMaKQvymbAIBiRdEUvhonVDGVlVXVsv1Gcsbqf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> Currently, LUO freezes outgoing sessions only inside the
> reboot(LINUX_REBOOT_CMD_KEXEC) syscall path, serially under global write
> locks, and binds every outgoing session's lifetime strictly to an open
> session FD until reboot.
> 
> On hosts running many workloads (such as VMs or stateful daemons),
> workloads do not all pause simultaneously inside reboot(): they quiesce
> one by one ahead of the host kexec. Userspace needs an explicit
> per-session freeze point to snapshot final file state (.freeze()) as
> each workload pauses -- concurrently across sessions under per-session
> locks -- along with a way to commit a frozen session into KHO so it
> survives closing the session FD.
> 
> This series introduces LIVEUPDATE_SESSION_FREEZE on session FDs:
> 
> 1. Freeze (flags == 0):
>    Freezes all preserved files in the session under the per-session
>    mutex while keeping session lifetime tied to the session FD. The
>    session stays frozen as long as the FD remains open; closing the
>    session FD before reboot (for example, to abort the session or on
>    process exit/crash) runs .unfreeze() and .unpreserve() and reclaims
>    all resources. At kexec time, already-frozen sessions skip the late
>    auto-freeze step and are published into the outgoing KHO subtree.

Let me bikeshed for a moment :)
I'm not fond of "published" terminology. We just moved serialization
from one place to another, why not keep the naming?

-- 
Sincerely yours,
Mike.


