Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF32C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 23:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23FD6B007B; Mon, 20 Jul 2026 19:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4E96B008A; Mon, 20 Jul 2026 19:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3C36B008C; Mon, 20 Jul 2026 19:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADB536B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:17:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D60C1C04C4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:17:32 +0000 (UTC)
X-FDA: 85010718744.23.EAAC49C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E1A841C0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:17:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S+BwUH11;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784589450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aotx7CDCkUtl8x9Zahbu5Sa7ywaL9nXIt4JyawppYZA=;
	b=ohZrHLr/NdzYnHznVYeN+u0kn+lm6pOCXXTSVP8uXMX0KF2rct+pIWIS8+Xmy3a1w7YgHu
	62yJB9ldcX+jCymR2R3UzVlACwm+8IltSFyufChTBtNDA6Ia/vmDvFxOY56IxELk+lTnnG
	ha4jzrzf9iv9eTKrn+Pr2LJbCFGsBH0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S+BwUH11;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784589450;
	b=gna2bOqjrhPGEjx9sBvcRZo5HJUC/wuKjnNSssFDgybyY37NLrL+Ruo/ITva5j62TBlSYv
	wfGIolOWpsqK60AVcBqhps0uSJiItuRTBIcPjPnYCrrQl5YHOXc9XM2wEpgY31c65V/yUE
	oSSfsHW+eEH3Dpmq7L3C3UPd5570vTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B707260A7A;
	Mon, 20 Jul 2026 23:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95891F000E9;
	Mon, 20 Jul 2026 23:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784589449;
	bh=aotx7CDCkUtl8x9Zahbu5Sa7ywaL9nXIt4JyawppYZA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=S+BwUH11cJ7WP3D9vhBbPMHL8VmXP9nKLdUPtKCfQa2yicomXxmiUZKXil6a5cI2f
	 e17rHxMkHQuJnl4WORjQA94fksL6U30vAJQ7OFTOMW0fQs7bCnyBNmt12/axam+MwW
	 v4M7vbe0o/QxefPU8RaWNGPD3ax0f9I0GFb4gmxA=
Date: Mon, 20 Jul 2026 16:17:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>, David Hildenbrand
 <david@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Kiryl
 Shutsemau <kas@kernel.org>, iommu@lists.linux.dev, Kevin Tian
 <kevin.tian@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-Id: <20260720161728.1e5e5d848bcb53bc8757ede5@linux-foundation.org>
In-Reply-To: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E1A841C0002
X-Rspam-User: 
X-Stat-Signature: 7qhounoy13i36bzxjaonx5puas3bq1ex
X-Rspamd-Server: rspam04
X-HE-Tag: 1784589450-188322
X-HE-Meta: U2FsdGVkX1/dRG7zh5FvcOAM2HhdAyr5OI8qebb1Yx9lMdnrWHvEZeweHWt7o93gg9tTMcjcWfOZuh4eKiJg0dK0O1HYXoyqYrbmVk1VIvPvv2Ip/2zP6sK/sqvGkMWnbIz1wMdOuJdwt5ns7oyc0XywcnZ5e2heT2wMQiNEkY7FU++fwKQ7PmlzYUfgtIEXpo6WfqUwu+FBvy7xMe573U2knF2roBPqg+nVSIL+7oFuT/8L3LAZGn+bidg0sc/kzuUqTfG+uu/Fw5tTRcAZWtKEonB7e5zHds53rmaFDsv9w9b9mu8kbrWuV6n7+SR+q4nTpI52iqPFmRpGYEZN9PXX9311R8p4KeRbi4EVkPES48yHh9TayWwaiQPfTzn7GS0hAjH6fxoiIBxuzNR4s2+cLTWx1C88u10L2rxabboi2ggEixa2XSFhWunNlAIFSyA5gBxaKOqiTve5mCdoot7G8NgTpou6p7cVl/12ZPNSIv5gmBpTZJzp4qckoR1ss7RXhHf4mV+pnEIRUpD+sB27cbaC9HzDgcnKt37CiPwAdQAotpP1et1bkGajeQR1u9i/KjZzsQCGC6fJe1ZxD4nbuP+r/pTGB793mG4jw9w9waB3Q5Tg3He9J4VrDkSjtGistjza5A4Dn10MJ/8LMWBi7Fy/T4ePTp7IJ+ec3r1uleaG+TFmhqoDi1Tf1L1/tUz+fy4ybHtA+Y7l//oGbvYFRqU7NP/2sij39OJqZXUD8UBlS9efhH20ugPuG9pgNJhxYAb29PeP0w0IORcuYW65wbNsPDeJWLjV2ScScPtJf2mbYnTXNRMl6JsZgrSz+J8tXBPhdBaJCRfglQ/5/fkTX7JwKfGSx7MCA+F40p71gs2y5FG+RoyURRKc6jWLeUjByijhE6VO+8BfRVPJNp/hzr8DIOBDoIeXx8L3d97G/D2H+1wwcCKYLE2YZ77T+qrsEHkgSoaeNoJoT79
 wqcoXMJF
 TQvWOA5b5bWURiptkki/EWorDdd7PsSVJwR+jrTBNBb5ps/03KOgqnxKZF10wHiOZVdj+GBGCfh9RgMqKeFmZPEUpgxokob2EgTF/s+DP4Y/3JxA8zrc5ItTSgH/4jromB0UkWJpUzRL/M+ZP+8Mfprmw5JJ9HDCdfTOYIuLCyf7qSamntj1rHCN42HMuPgTVVUoqPjp/keiUJyvwtnaWpEkVvPS1qf2xL9rEmT7DydqBcZMdAAQrfUV90KPTUeyBpc+x2HmaDZNcCgmPP5+rmgbvnm5eU67cHJG0RUqdM7QInpIwMx8EvSR52NjGsn6AQUHGI/SZ9bW2cvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 10:27:29 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> When splitting a large page in CPA in __split_large_page() we allocate a
> PTE directly without going through the standard page table allocation
> routines such as pte_alloc_one_kernel().
> 
> This means the page table constructor is never called nor is the page table
> marked as a kernel page table.

Thanks, I'll await x86 review on this (Dave?).  Also, Sashiko might
have found a pre-existing thing:

	https://sashiko.dev/#/patchset/20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org

