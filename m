Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA87EFC617E
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 18:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7B16B008A; Sat,  3 Jan 2026 13:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75676B008C; Sat,  3 Jan 2026 13:32:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9817F6B0092; Sat,  3 Jan 2026 13:32:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84F9E6B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 13:32:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D688BA4F5
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 18:32:51 +0000 (UTC)
X-FDA: 84291498942.26.2ECFA22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 68AA040006
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 18:32:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="H/ze6AGO";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767465169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLepqkCGGcxCkG9pO1WE8NzpPMLGDUWjEtRJyK6vti8=;
	b=xWww/1d9NqGAC/SLr9HsG5XXX08WguEcQEAPiyQspxsMEduwW1VtqQ0kf3jx+Ws+Qvy4cW
	BnwlqY3+jjAyQFgQhABHlGS1kkDL3vssWzSwK5gNrGyIujyBL/EtDDowpow2jBwjthM6Of
	LuSWW7P7DIGLPDF+3SNrxX/zdXLXK+8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="H/ze6AGO";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767465169; a=rsa-sha256;
	cv=none;
	b=buhYM8n+v+AGk4PmkExPwRPtx0rZD5KhHwZwtq9fYl+3897Q2H6p/6qfXzv7Y//KMQK6aE
	KloPUaJYdu8Svd1zN3ixgzjWI2M9FjHRaEnSNN+JwRJmsZS0uN1dXFj1NC1Kjk6RP1vb3d
	P9VOhgo3ktilLstBIAt0RUXPtXFIi4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EC8E60017;
	Sat,  3 Jan 2026 18:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E24C113D0;
	Sat,  3 Jan 2026 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767465168;
	bh=POEHkpqzM2Kgm3O+hKTFaWkCDbY6suH1seQWUDCuBvg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H/ze6AGOHL2UKpgvWQ/ttEcMNhy8xDpH4nEjyXFSro+iW2tpN/qnPR/YWXuEOmAXu
	 6L4GquYtEkuscArkUslWJd8GVVl1Yo1H46Iynb0yUvq8ywiuFzxQ3HDrlFrmXO0VEy
	 vuGtiYXFOsmia3yqvZAVjiEZgEjQxhUOEYal4JN8=
Date: Sat, 3 Jan 2026 10:32:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>,
 maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Message-Id: <20260103103247.9140cb2556280927b09f59d3@linux-foundation.org>
In-Reply-To: <20260103165758.74094-1-boudewijn@delta-utec.com>
References: <20260103165758.74094-1-boudewijn@delta-utec.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rhz1qqfj4ayg54tbu6na5c5jgdjcfa9n
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 68AA040006
X-HE-Tag: 1767465169-568894
X-HE-Meta: U2FsdGVkX1/9nLpPRTCS0ZW4QdFt0v/IZU+g5Y9hp/O3dlTM1ea695aPPnmmZoQITdFL5YoKGBo5XOYHWeVRrBd7KBSyXkXFDpaHg/+y8yMHyd79e5acN0tFKxYuW57t3Ej8DkjP8W2pMBgS9ZHOKLZMQnd7C8IRWhE7eQE+Pqg9vxs29sOE2oMEWM4Y3D0ZqYbUjwf7HMA6U/QOqMGD7odKDFmEX2byGpfQKjdHZdv3ST/x4f9kItF2sDJPVdZUwH5cNJeShJUOiDD2MoQfNnqM1AfIuvokr0YM6RX+19j8KtrvtbB8Ty2f0RmZpH9B8SFecgfhp/9ZEqztbhKoC+ovvi+zVgepLHjyU9DpVwm6c7H5k/QpQBuWebABKnmocUEZYvz0kuYNrHDrYSIpvBh8Wpu6ALu4eg0AiUf09cX9hMhyfw1AmN2BELrnfZEiWUgGigSiJqyjEfTWIogQ/z/gmndvc8e3WxHdVe50x59pe4KCYwz2F7977KNn7m+mIN4/72GSpUaXPICQP5/jU5d0G5WY3gy2vEUZfRvt0K+MM1fd/4lSHU/z85WsnKqDGC8LSdpiYjwtKfPXAhDuu/HJ+fBtvn+661vaA5c6chGJyNCkYRPnADLaQcdw1w3nXj+74Gdb+GL8EkYd5RS20kAUgtGSqoYnYzLAGG9Li5pmsN3TfFhTPhdq7MU/IdYItJOH5nelRHcmq08xPBJJ8aze7T60JVyfB4eO40/uELhsw+SRtdWacbm1pA6/+Jn+qlzSsMlZYHJCv/fwxN20JBcaRrevXWxhvJH5swis9vEDoSOUg5XAqL7WTDiTLxktOIv9eXX458WG2FEr8PeKtaojb/DPLuf18fftXyhpLsQkHgi8D1rBpiqB18bqGcEuDm2d8zPqy/g1zLbMH6zOlza4S9+b0fXRHq2LJK/DPULYCSbtIDOxjmtAgnKC8jmDbSML7qES/QH+Tlx+6U0
 ZpajL7gx
 LpID4JPB7FEubPw2CFPNlaMYAOWQ1am1NfpsOpoIXOagYPBbgS5NGwc2ffZpvGQr6IER7cfOU2006FgvnTro/nuMt5rGEL2BcxhBtHsdj+4RhjfHhxzeWuPc/CQWCvJ2zNRDgRnThLrEAZ+zWT3lYOniA0Sr0f7pXYSj1bcPAD6m/PLVDqhN8/5vpMgW5Sl/gDc/foo1X5G+aW+IBblXtHI3G6raRms1GXJ2XOOZY6MzBP5HZYD6Vj8gge3Uqe95Bk1yw8Lu4u+ZfVA+FVqGGWsWZy4PPruEKMcQD/IgZj4FL2QObpmMC34HeKq7oQ8niohwaXL6sn7P5Kml8wbxOz9SKngg9AIQuiHEvXUYYDxEK+QZ0h7kUzFcTMOjyv0q94aOI68SNgG3IqyLSfpf6HZxAUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Jan 2026 17:57:58 +0100 Boudewijn van der Heide <boudewijn@delta-utec.com> wrote:

> The __mt_dup() function is exported and can be called without internal
> locking, relying on the caller to provide appropriate synchronization.
> If a caller fails to hold proper locks, the source tree may be modified
> concurrently, potentially resulting in dead nodes during traversal.
> 
> The call stack is:
>   __mt_dup()
>     → mas_dup_build()
>       → mas_dup_alloc()  [accesses node->slot[]]
> 
> The mas_dup_alloc() function may access node slots without first
> verifying that the node is still alive. If a dead node is encountered,
> its memory layout may have been switched to the RCU union member, making
> slot array access undefined behavior as we would be reading from the
> rcu_head structure instead.
> 
> Add an explicit dead node check to detect concurrent modification during
> duplication. When a dead node is detected, return -EBUSY to indicate that
> the tree is undergoing concurrent modification.
> 
> Signed-off-by: Boudewijn van der Heide <boudewijn@delta-utec.com>
> 
> ---
> 
> Build-tested and boot-tested with QEMU with Buildroot on x86_64. The
> kernel booted and basic commandline operations work correctly. The race
> condition this patch addresses is difficult to reproduce in testing, as
> it requires concurrent tree modifications without proper locking.

Thanks.

What are the worst-case userspace-visible runtime effects when this
happens?

If they're bad then presumably we'll want to backport this fix into
earlier kernels with a Cc: <stable@vger.kernel.org> and, very
preferably a Fixes: line.

