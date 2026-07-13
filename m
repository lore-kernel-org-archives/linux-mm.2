Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5289FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 20:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E726B0005; Mon, 13 Jul 2026 16:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F1F6B0088; Mon, 13 Jul 2026 16:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B886B008A; Mon, 13 Jul 2026 16:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFDCA6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:13:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C3C41C0104
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:13:10 +0000 (UTC)
X-FDA: 84984852540.15.A86FD50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA3DF20002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:13:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d5pRZ+Fa;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783973588;
	b=6/RvLtfbzCmaNfO//To3Hok7QQGLH2t2Y5yNi7Q0I/GJIuFcq2L4ai4P7hupqN0Ttn1O40
	zNZgvoiZsuD+OFDP8nZe/CblxYyqiGdO6uPCneu2DgmoXQ9bke1ZUZ6K+eS+DzNY1Rr3RW
	0o4d3h091CtN1IWjYE75zk609C0zvTQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d5pRZ+Fa;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783973588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNMcQg/QQOMJnm4JfpFNABwF8Ya+JEdt/5e9nl4z720=;
	b=z52az5K7wxrPT/p4fIiwkjp21jb1TS3t5fWoW1VBQp4dNofzcJaPNo34xgxU0M+ZEXRM2A
	wSJ6vuKOKWjiKsIchAhs4sKt8xlAZkxIhlLQLwwU23ceoTenpF23eaVtGirTfAzgbdyHoS
	yzaV5qqDJJd4AH5Z1uM3t6vQ1u7FNKY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF47242ADE;
	Mon, 13 Jul 2026 20:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272691F00A3A;
	Mon, 13 Jul 2026 20:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973586;
	bh=zNMcQg/QQOMJnm4JfpFNABwF8Ya+JEdt/5e9nl4z720=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d5pRZ+Fa6/vyblirCa4HDcE3KQZPSBlFG0a4tb9CcEMh3wtxj9zwmybCNeAcPiuWq
	 UVntrVU/RQVfo1Q+BKmpnsbZP3DqxpEwvyY5coxuuEFxUsYlb+YdDTdDegsF1dRWum
	 ddmIci1/2NuA8DbOVeFmjMMG6BI+o5M3kmEWgh+U=
Date: Mon, 13 Jul 2026 13:13:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, chrisl@kernel.org, usama.arif@linux.dev,
 kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 youngjun.park@lge.com, linux-mm@kvack.org, Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Christian Koenig
 <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew Auld
 <matthew.auld@intel.com>, Matthew Brost <matthew.brost@intel.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: better block swap batching and a different take on swap_ops v5
Message-Id: <20260713131305.3efec91d077d224a3a8d1aad@linux-foundation.org>
In-Reply-To: <20260713093350.2154226-1-hch@lst.de>
References: <20260713093350.2154226-1-hch@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BA3DF20002
X-Rspam-User: 
X-Stat-Signature: u34igde7b6wkd5uy93hujbwgwjc3zewa
X-Rspamd-Server: rspam03
X-HE-Tag: 1783973587-415225
X-HE-Meta: U2FsdGVkX182oGNf+KXptclTeMMLhHQA82dQWhIFXWSzYEXB8/1JgOGxTrkmqhAZfXoUsXG+MFpsuJxSK4MWcDRwrNUtA2Uvc+AovZj6hcIEn6W+MSNtCYApe8CsGWHPWLYg0Y7MVd3Y0em8CG9a1ExXO7D+5pEhDpDh6p79LJXI8stito71IUjSFSaBtIQs9kfj2Ak0AUkngvuNT497XNbeB3Olc3zk9+YceGgng//ue0fUzjRXK1Tq5veRc97wP4EQqS6nQQdVxjmgs4TTodWcWzXniEflIRVlrq9H6r2cBZhXQzBxjiiQfUbUYOCD3ATKdwRiGNJJekqU1nIeWRscd3TkjTF+AGZfQXtvCRh7SXkNj0GCV8ZgCk8hbVQeCuOsosBWR6qirgqWxfVRFqQXrXQlvtVxtp9+uj/YMIjHbEJrwdkVHqm4r0PSkPgOjO+6q7J+H0vv4crdWcFYBHHx0Lvct71tox9LDlfQaOYT9yqqRtVVlTTrUVfRe4Nz6ZwC3Jz+rOj5gmduNfd6JBs41s+cgGixz6KplcC4zDoeE/XRbBd67Y8/XwtBtbtNVXZ7RdShZZzRWsIPtrI7nvfi139brimQmhnHIQ0yBKi+PPDomWhDX7hJY6ToQ14PshlJ+IENPevfO3JqRm3QJNEH9Jf2pEwtD9sb+YpmI25aNe5QmSBtWeHHT9DxR5dQHZIQPl8dRkNBKXL1SIgIUisDSwR6xv+7GocjefXlD6Sq81ymPVU0B5kk/mNemc6nnpEOPZxsSTYfj9uhY5ZtzVIEZIvKs1A2zlKdHAahL0hbK3thrro0GxafcPMLP1FyK2eF//BUsTvoZe47eeHhYCmdzCFGV2RqXAIcRCcSSJoVP9wCN8r5Q9L8IgwTMwDpCsjg+IlOJs++vA3fbmHHu7A2wk4AQxa4cuyGm983xSvD8ZIEyNauJSKSynMJWtKtpcrfzSW+BUqeV1O35IQ
 sktZek1T
 58eL+udduA+zLtodrYoQh9W/v5Z/7r34bBvJpgObTM1amaccTbkxAQzg87I3Hiqhx5fdq36zRslXmzCsaNmJAfKchEs1yUoQwSwAY2Puc1i81wLNN/ygQk46z9s+X1kkBWpcBYzH38GSKh89HAn31whqyMXzdUZ/ckU7LP0z1Iaz+ws/D91nrDXzqjqj8D3mEhMGZBBFKcY9af9L8uPMjgol403j+5DWy/LKpc1MyarWgOjWrNJDRvnWCO8fFi8ggjt2QL6j59udPBUb5Qr3PGHDvMmvd+ptwCL7Z7sZtzNoHGZJD/i5rRQIf0Zfqh8ufz6pV7qUwYZ/QBI7yGA8vQo4S3KEZ7dLSQT0MblbNSuuPycuIClfRh5PTEo4mm5kndVU5qRcwgtOqh24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 11:33:37 +0200 Christoph Hellwig <hch@lst.de> wrote:

> this series makes use of the swap_iocb for block as well so that it
> doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
> Baoquan on top of the now very different method structure.
> 
> When running doing kernels builds, which is a workload that doesn't
> really do much THP anonymous memory it still gets 2x clustering for
> writeout and 1.2x for reading back swap in.  The overall times do
> not actually change, though.

Thanks.  Sashiko review might have found a couple of deadly issues in 

	drivers/gpu/drm/i915/gem/i915_gem_shmem.c
	drivers/gpu/drm/ttm/ttm_backup.c

so let me add a zillions cc's.

	https://sashiko.dev/#/patchset/20260713093350.2154226-1-hch@lst.de

