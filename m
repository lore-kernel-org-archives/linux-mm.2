Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C82EE83EF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 13:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DC86B00B8; Wed,  4 Feb 2026 08:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BA36B00B9; Wed,  4 Feb 2026 08:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFDB6B00BA; Wed,  4 Feb 2026 08:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFE66B00B8
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:54:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0913E13796B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:54:42 +0000 (UTC)
X-FDA: 84406919604.27.2C6D46A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5FC8D16000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:54:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gNU9RLmF;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770213280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ISqGUnQFSfIzubIcjbsXKszPgBVvuBlocAkcpVEeiY=;
	b=qXYj1SaScOymwoRjzR2Jk0jUvCJITYHf2/0WDX3cGWtzqaOwP0YuquyaY7KYvfiwVb4yVi
	J4c5f3lmSw7dLOw7sMtcLrpE2UtGVrUM03fDUp0kz/qeXO/8fiw75tq2QXK8/IYMcxGxKe
	lLWhMi6ITyNghkzMPXfl0X0q3sxQIj0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gNU9RLmF;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770213280; a=rsa-sha256;
	cv=none;
	b=hdgZDkhD36u35tF+Il+hu0+iyEdXPhF5wxSlFqq2y2n98E4v8hKNz2f63xtQKmVfceh1gd
	CG7koNkTFaPlyEe+Ohy0509qxxMVYvuOc4eESDUbMvGjElTBj4xFw/QDSz501R+sz9yIno
	igc7OTIambGrL0QPN/N4apYef+rQBUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D36166012A;
	Wed,  4 Feb 2026 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AD6C4CEF7;
	Wed,  4 Feb 2026 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770213279;
	bh=Nx3mqv3VEYct46j5DWoW2n7667uX/NJxIPI+yS3dkOk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gNU9RLmFxfnm6eHDaKsUmyEzRm88xgRGG3z8Trre1GxyWc7Fx/DsdvJRZnc+GaKLh
	 kIV422HC993Ly9Zi4BYu9qPfXZ/5mc4XUhxPIglAtKhmp5Ehy+iG6ThT/lvo8AlkpB
	 NP2xWCzTK2KQ8Gy7NqpD5A36R0edc/XwGtHEpDF9B9Z/5zHbZSnd1O606ndNcSfkwr
	 K1wSITGJbN4y/tR1LB3US+oeYoz5vBwwMc1HAVEFTt2uVHjZoUl5CR2Ydc/pcMft6C
	 jTvemJt8nPqu6eiOa6Y0vvQA5a2zaWnyKzA76KK41VbdGzzUxCxwfrTUu1+Bux9/h3
	 vC2/P+qzC4H7w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  SeongJae Park
 <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v6 1/4] kho: add size parameter to kho_add_subtree()
In-Reply-To: <20260127-kho-v6-1-56f9396681c2@debian.org> (Breno Leitao's
	message of "Tue, 27 Jan 2026 06:37:36 -0800")
References: <20260127-kho-v6-0-56f9396681c2@debian.org>
	<20260127-kho-v6-1-56f9396681c2@debian.org>
Date: Wed, 04 Feb 2026 14:54:35 +0100
Message-ID: <2vxzjywszk9w.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FC8D16000D
X-Stat-Signature: miqszw86iqzjdasocdm8d4zekiq8jxx5
X-Rspam-User: 
X-HE-Tag: 1770213280-517840
X-HE-Meta: U2FsdGVkX1/6sLh/OrJDPhTHmNuMrTIa4MUgAtHEmRRYSZHxd4is8Yv5ae0eHUaSrp+E/6R7v7W5YOaoJWqx7VB3/GgfgfU4DoTqyiWoqhlRrO10LiFDkOUXNIgfYrT0PvuzXph8vAYQ8AtvG05BNnAZJE875VznN8toDkTHuahW7/S1JdEGn8ws8sWkv26IH532rh/8t/LYT/gmXvUg10HH2QWnJ0FNcjVeUFTNOcWFyOulAkXliysBQgOgs0+adAnBpfu2VHQkhbfp307/o42jxqP04lfrR1QfkFeks/miC8g+v17kGkEJrcEb8xk3xMXn5EmIJ+Ff5WrCC5t1bmnBH5k6a4QjvqdXOhF6bfpy4lhWmAQa8ttnhSohzYqPMAO1m8JmfrVsKTLkHzaF3rhahV34G9vTCSoXhdYDjRyj+wDpcO9EQLggjxJAbzmAjtaM0X/008NsmGdW4L5qTZ1PXsOXD3OnJQtGx7vVuZHbQQ9eoJ4FkJoSeP+4Bp6juG77+LniljCaI6HfwdpmWb/4Kyn9nuMCVbfYxFmC/6huI0EtWcNDSqy4YX2KYbWz/qouwZZRHpJQqvGwlxadqcAuzUwGqf5GgwBwkdWJi/l4TcgY8kpdIqhI4G/fHtiYsM4ofIm5O72w0xdGwoF03K+qqrbybJYG7XgFQ1O7MQ4LOPDOR7ZVuL3LDS3YZ59/TH6q3oX5aOkP/tIbBGqvNK+//UNtyULFL9GpfYt9yHKSWB3db+sYXGjk8nTvpfvaeUNxfOTnKkfdWYcispMF3RGeMBoYNFEfhXyzzTjcmWIc+E/PcEfeBOljpVCzUz4DDCto883rkuzD9X/VI3fTf2q40xgtbOJiRnDvzfPrYtE8sPLJW2OKarYFBuXOseSsaKaZDFMa2Ijc3r2IfTXeHDzDQPZI/dnFnuxEIUpzDRopr6m280y5Xq/sNUWIp/tdaGZY/YreAFEmPcMvzLd
 SRRjc9Rh
 u5rt1wSfTOvDnMQOJk//JiO1EBRTjdIOGG9RZmkLB4xy1n2SbQEgs/UZMU6M3dlrXMBIASWnqQACTsPa60S4vvUKkpyQDKA0CsX9gIC7PQbjOo1k9S7HdaNIMnD6VpD/qSnYNzhM7sqbjlmKOs6kYH+0R8NJrRFTeR+WfG63EL0vOomGpIHboRPwrdgPioMEjwLvjZRPMK8iEBwlLUUsVDRXIeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Tue, Jan 27 2026, Breno Leitao wrote:

> kho_add_subtree() assumes the fdt argument is always an FDT and calls
> fdt_totalsize() on it in the debugfs code path. This assumption will
> break if a caller passes arbitrary data instead of an FDT.
>
> When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
> calls __kho_debugfs_fdt_add(), which executes:
>
>     f->wrapper.size = fdt_totalsize(fdt);
>
> Fix this by adding an explicit size parameter to kho_add_subtree() so
> callers specify the blob size. This allows subtrees to contain
> arbitrary data formats, not just FDTs. Update all callers:
>
>   - memblock.c: use fdt_totalsize(fdt)
>   - luo_core.c: use fdt_totalsize(fdt_out)
>   - test_kho.c: use fdt_totalsize()
>   - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)
>
> Also update kho_in_debugfs_init() to compute sizes using fdt_totalsize()
> for the root and sub-FDTs it processes, since these are known to be
> actual FDT blobs.

No, this doesn't seem right. The "fdt" field that kho_in_debugfs_init()
uses is the same "fdt" field where we put our non-FDT blobs. So I don't
see how these can be known to be actual FDTs. All this happened to work
because so far all users were FDT, but I bet it will break if you use
your blob here. Perhaps give it a try and see if I am understanding this
correctly?

To be honest, I didn't think of this when I suggested you use the size
parameter. We have lost the size information, and it is hard for
kho_in_debugfs_init() to find out since it has no idea what the
underlying format is.

One option is to have it in the KHO FDT, but I am not sure that is a
good idea. Adding to ABI for debug feature sounds odd (not that I am
completely against it, it just feels off).

Another would be to give users a hook to populate the blobs when they
call kho_retrieve_subtree(), so they can figure out how large the blob
needs to be. This has another benefit: once we move away from FDT, it
makes little sense to dump the blob since userspace won't have a way to
parse it. Even with FDT, userspace still can't parse everything. For
example, say the FDT has a reference to a struct kho_vmalloc. You'd get
a pointer to the head of the list, but you would have no way of knowing
what is inside the vmalloc buffer. This has the downside of not being
able to show anything if the subsystem never calls
kho_retrieve_subtree().

Unfortunately I don't have much time this week to dive deeper into this.
These are only things off the top of my head and I haven't thought too
deeply, so please don't take them as strong suggestions. It would be
great if you can think a bit more about the problem and come up with a
recommendation?

I will try to get back to this series in the next 1-2 weeks and
hopefully find some way to make progress.

I skimmed the rest of the patches and they all LGTM at a high level.

[...]

-- 
Regards,
Pratyush Yadav

