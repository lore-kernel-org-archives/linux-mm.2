Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3304606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ls9FgKCT
Received: by kanga.kvack.org (Postfix)
	id E3A096B05B3; Wed, 18 Nov 2026 02:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9E76B05B6; Wed, 18 Nov 2026 02:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9256B05BA; Wed, 18 Nov 2026 02:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADB816B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:07:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD429C0341
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:07:15 +0000 (UTC)
X-FDA: 85447358430.03.3EDA361
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4953E160007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:07:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ls9FgKCT;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794985634;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CcM0u+kdHIdRABw47Myf64IAL3Q6zTLi9Sss9NI8MA=;
	b=ARAntwroKWBvNobcC3tHjHPzVzveyURMY23ns/0msruXFgAZKovhiPmIGrrQDy5e2nybxQ
	wE0KiFfCdGSXtE/431AGSu2VX0jRTaGYUQ2/R0H23XblMHrVgpKTr44bUu+jdsFx3Chv45
	en1X8+HB0ChHIDYg4pTSxTE2Hopv/eM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794985634;
	b=W9aDh3eJjgNxlYbUndWJHWmuetz6uO+b6AX+K9DCS8/Orz68Q8cVzHh5JVzkGzDTDS7FId
	LqacSUbz9EIkKulYSfok/cdSRSmqgHtzNtLTUh6/WZ6TBwKU/TYH9j+IRSTc4BwIo6ffxA
	0EFqwPcCqcM1xkC3oCK2fHd+apvQjZU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ls9FgKCT;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 885BC61F4D;
	Wed, 18 Nov 2026 07:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC061F000C4;
	Wed, 18 Nov 2026 07:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794985633;
	bh=7CcM0u+kdHIdRABw47Myf64IAL3Q6zTLi9Sss9NI8MA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ls9FgKCTNX1O3IFRWsiUNSGBni/V0Own8PdF1E4fblZSh/cqAwj+l+sFT9Lir8987
	 7bpmaziTRCO6WaaUUUc+x1lLIOqpnuA4VS2go6R0YNob8HXYw7sIX61IivyQsfeAHC
	 z/EmNgGWLjTC9KoBurk6+PNsKxXet8aCrCksbaY7nEo46EBMGS3rgFat2lZNAFs+ak
	 xElt+CVEXPDXN2HU/guouTGtgJmuERZJNRJUjZcLw+lMD9dM08Vnf+sVq+FSoLL8PS
	 wlqac/kt4hVOZnXbzkzbDmDJRlcNiOjfkiCVuEvkkmOS0HjPrURh7gT8doyz6I9Mo7
	 VldRPjulosWNQ==
Message-ID: <sashiko-outbox-220290@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] selftests/mm: handle implicit read permissions in
 madv_populate
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xionggui Chen" <evers_chen@163.com>, akpm@linux-foundation.org
Cc: david@kernel.org, shuah@kernel.org, ljs@kernel.org, linux-mm@kvack.org, "Xionggui
 Chen" <chenxionggui@lanxincomputing.com>
In-Reply-To: <20261117070606.3752-1-evers_chen@163.com>
References: <20261112031811.56500-1-evers_chen@163.com>
 <20261117070606.3752-1-evers_chen@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 07:07:12 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4953E160007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 371xm18g11a4nsijpjtxkmoeqs1a8zak
X-HE-Tag: 1794985634-362065
X-HE-Meta: U2FsdGVkX19ZtKwgc80CxafFzj25IVYwABxUYd24t7OChu4kpe+KXbjPvwcfpToW0T1C2dfO3+AOVISXqQwbIBJ7i8cyqh1zNCVg0wUTPWKkDjROnslRtn+sJiXpvmvrnMZAG4mR6+7G3/1sib4yUKP80Lpn5yWM5EQOhwCjogjclgkPaJT9cE/1Sj1Kk6IYAIP1kVEQ4WPDu6jeDRtUgCGKMgjywGVTP2REK1sPWCzE8PsGsnEFF6bWAms7xgvm4c1wqwRH05/N68LyrY/Dq95hhY7JdhyG9rJf6bbLSI3yl+90qMBEKVpju84f5JcNUB1jbcb9DzkWQaqAL5b/k5c/IjS8tko06+IUs+ca96E8JCMTf1CMFV/oIzHeYTwL89nSmvZeniAIffgUpUDIytxhqXO4kogrlEqPuLZaw8qBchVPezrQdYHHbisO6dPIU55XgqFQF/XrESnIADPZnaBImtoq6vbnoz016Tx4u/0KyovudFrLzpKLNmTep6E2QUVRcs14E/3h3T9hdFjlA769Q0VCgDfBueEeuQhHpPmWcW7xSGCQ/695ZlY5LoLAJpTAw/B8s+jcR7p/2M19m6eA5scYvreeDPYxxmBwHI5/QH27odgf3NnTVoJa43rx85QjrjjMTs9aoJT/T6bysZZDZ7fBv/6JhVtjI7DfSFyZ+A68Ae2Fn62CtjV+vK7SoPwzrY1bMBQeHRUKLMFSMHVOhVg0zvxtDef+didvAJRZjQUiogFkiNx5T65oMhksGTtWvlFuXMvCKvtYTixNkKgsiQ4QQ8vbH64z9QEDiVJQdtXeXAIvx/fOoXrElyAseca26EUbVgEZSjbS7icAHD19ziMypf50U5I/lb5RI6LHYQhw+o228LxRy43dUm9lzO/61Hc3yvbNL3gVfQ2HMhw/btFz/AJjgT0SGBwLgmr66Rosg1V42oYZ+pYE1xb7ct8m39VblBzTowEoV/3
 vRkn0lQn
 Xdb/auimudMzV5JepL/7pxmtryEpVDkS4dqpTeLHqHcnuFPLdeck37RulrzE4mwHL+6BXhpPpN2ezsL2oj+YfBgWpJSpwt7Az0tDmaPgNPKOHFOCFZl9wwqxjmU1eAN/1KApTO3Zg1tjAYOoKHfaeOyfYN0WRcGlQgu8SP7PxX5GRLaPkyV753tKl1u3kWGgLN6gZ2oUR7CQfnNKPv95ywJFLBnaZBC5ZjipJeyc6ZOwLIuVnBDO9WfgoOD5O4FYLKwalxsban+/5hIRYx2Tpfd8X6VZ8V+4i5fOb2GMkKlMZ5zTn8B3Jz2vy2Rd2dc4mpzn+IdcChgzVo/k0RiFlpOOXV8ETm9XsUsBSqaKy63ydio0W33Lpva31oVVccfY3ruPrw28wOtGj6jZ+FG2GKhIZI6GB76dpDyYQPwhGT7rM+c+Z1h1QI4LIb3yoK/aJZZpfNjFo4G6kcx4BfaMURe43BkRSWiJJljo8M5S+PiSccGPmjvTAKXUg5yGsirc+ra/SwYxlyMwCnCbUx57M89enl2mYU1Bw2oLZ81cNdiSXrrcc06GHHGcnnDxFj90BfMMjsS+LHX0zhX7mNmIwTmyz5EQkf22UhP2s+aTdHPOwpH4xpMrnqqfvf+v8UPZIbreI/rjjs4YnhgJXZF+pvmj6w353agwmdWKd/kz4pk6LY7pR+eMgu3hX5O5nbRIt/n9wdTWowd8dF7OSQ3M32iLCZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/mm: wrong Fixes trailer in madv_populate
  test_prot_write()
--

commit a72c4c7dc3b5c0ebca1f3529ca19931b9c980959
Author: Xionggui Chen <chenxionggui@lanxincomputing.com>

> selftests/mm: handle implicit read permissions in madv_populate
>
> The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
> without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.
>
> On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
> VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
> with PROT_WRITE. MADV_POPULATE_READ checks this VMA permission, so it
> succeeds and the test fails incorrectly.
>
> Adjust the expected result for RISC-V using an architecture-specific
> conditional, while preserving the existing behavior on other
> architectures.
>
> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
> while the updated test passes all 16 tests.
>
> Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
> Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRIT=
E)")
> Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>

[Severity: Low]
Should the Fixes: tag point to 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE
leads to VM_READ | VM_WRITE") instead?

When e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
added test_prot_write(), mmap(PROT_WRITE) on RISC-V did not set VM_READ and
MADV_POPULATE_READ returned -EINVAL as expected.  Backporting this change to
stable trees older than 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
VM_READ | VM_WRITE") will cause test_prot_write() to fail on RISC-V.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117070606.3752=
-1-evers_chen@163.com?part=3D1

