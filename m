Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6447EEA4FB1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C617A6B0089; Mon, 23 Feb 2026 06:28:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B906B008A; Mon, 23 Feb 2026 06:28:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B459C6B008C; Mon, 23 Feb 2026 06:28:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1CD26B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:28:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C48831CBC3
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:28:22 +0000 (UTC)
X-FDA: 84475498044.15.8223D75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3401440004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:28:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glp3ybLc;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771846101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9hL7aEbrF0zMIhwoLG2NMCtTgK/IN768MTVSzplHBs=;
	b=p8XhHvXNWsNFc8dBK53pemdoIASYQNSl+tRpON/uez5BAOTF+VsSohD5mooZi5rB+TnkYS
	gJHDXdZz+KKbJrwuUkGfzBQpYF9JEGEQytbu9XTBQSQUiqYSPNx85Tx50xPdskPKMgWtUo
	zfyYOk3HGDJBQXFC6fUWhF+qpAxQWNQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glp3ybLc;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771846101; a=rsa-sha256;
	cv=none;
	b=UN8qB8YuY1dWYgk+f1F6jn54fs6oq4Z0CdQUKfLxhix5YntEswffJGILTxUVVvB0Rz+W0L
	HoU4Kpt/WDHc9x5ERsCkyJODqO7mQGceRPu4wYCPZVshPM27Ln+a2mTrVEZUaicrRcNE5K
	7i1rFhVH+wHvZRta4GmqBH4f8Vo4SHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CB6C60053;
	Mon, 23 Feb 2026 11:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC328C116C6;
	Mon, 23 Feb 2026 11:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771846100;
	bh=FlPT/7GGS+XIajjjQrmT/D1mHnYUeSClTHVFCrrM3/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=glp3ybLcWrNVVpiXP6omArESTxpT0GsOck5RiZ4fv2H2sieTa4HyqKPDAebPrKW3T
	 EXi9cg8luEqQXlxMJv0D7dVcg7cYG4kUC6I6XFks0PzSdd2HVdY47/O5uWd/ZLxk6I
	 2Xtd7x1CkUGPbWDX48XIC1KJvdcVXUKYqaOoprINBCpQxKQl3xlYocyPSW2oMIVrzC
	 Eo/wLVFo8xFI90f45Hd7NkgzHyI4zX8xAMo6++0Xf06t0bdT5FyN+iaARkFH/S4gH4
	 Ruo4kkUWu6LmIj8k8zVUFGzaUtxK5MNnkflrXygGhW0pqJIsAoZJhuFHxJeehw7k9U
	 BoMwBKmk/Ss/w==
Date: Mon, 23 Feb 2026 13:28:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] A pagetable library for the kernel?
Message-ID: <aZw5z5Ti-gH3bDUL@kernel.org>
References: <20260219175113.618562-1-jackmanb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260219175113.618562-1-jackmanb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3401440004
X-Stat-Signature: mf4g46488xmih4h9b5pyi87hb8ejunjg
X-HE-Tag: 1771846101-916565
X-HE-Meta: U2FsdGVkX1+KRrgQ83AkdfHD4vtNnX/MfcE0GmlUWRTqsHoCnyHF6VdBMS5u72Jsa1TzBKQf+NKJFR9fsLQllzugx9Q5DlHemBpve2v6q0+TXt1j3eEbPK44iIS1d3ACPZ7aIaxBKFxvB1KhbbE0pOG4XjrY03DlK+mcMvSbCpLVs2XyPLemWhUhwDCdhrnQWKQicfSBFxqFFpvQKTuHLeC36wQq7Keh9WP+zOV+l/h/ctlYTIxD92b3yTs5pcqiN1yD01SqB92Y2HcmVVeBb2n7qQyElNc0kfHJ6DeQMcoXSa/tmuKiYRcxvXqPSwxRHvVlFhO34bEXS4tprxtBTQyaGSiSdhEmXlFeTTGEVztg7Owh6JbJv8POfC3B9xJbjRFni3cCCeJswYeFE805o9OIWWdEJMghPkTSQG7xMPBV3mH09q0xh4E51HqICCl4mBVO2ITgDtB8dIt0G/PEDPT+uAvYkGfbDRuwOT77b0dmPkVtJuFO8xBCWWdkHTYHVEIiswjVokTQ755aZRRVpk19rN3I2EBeejMsYtpDgX0NYaUKKMq/zvvP5FHHeUcewXdRYBAPqYWftA0hULiZ6HOLFcwgG1lyrHciu657a0HlqY0HLB62LFZRyeAGlysIxJAGH0bZqEqXHD8ydBh37C0Em5EIfrja42XoWDKfcyCS0phHUD2Av9plNLfTEJMZ95R3C3z0sF5dlSBSHAPHvYNWraruWuzV8BPU7b/0RO8Ay/Wbsf3HUBziwZpUQnNRlwupNkudA5mWgLmaeU7ZpPi4u7VRmU/Ed3x0r5mJvHIotjNr4qF8oL42AuyWRL9yCOJ8hTdnLc0ia6oF5BcenU/vDxyBcsf/3yrMadHUUEjRR3tTU9CH9x7I+DvRNCvDl1VCOJyphWTcrwEnx7wl1rWzqd7I7lvV8jH6Iuj6yqEHC0cQSZFBRLQ1NREr6IJ509GsyZuY88MvaKEU2Tg
 utXSa+Xp
 4POHZujS++5Px+qpc46HdVSoxqAyCHSv7JHPZtgAqMuBpUoxz9lcPujRKsjevhn7gxl5l0U1bF+dTo8Z3YTZyH1E9dVYulR5N4s/aFjtPgwzYJ4+j/NH9UIPevQtw0Gj2HYq2QRgeP9UrOWT6/wU0gA1oCB54AWL/pZqfIMWpjR3s5XDfK2tWrqRgvSRHJahs8qJ4f/MenR71VhQdG/lavqUQA4DtREPfdeS/C4rP8GmMjmA+g7CROKDkmQsQxqMcyoH9vckTNICmn6dkr8nzgQdt+/zHTlPbkT9gS3C6zpXzqgX1FaJDmm2Vzxcxg1EcmDcn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 05:51:09PM +0000, Brendan Jackman wrote:
> As work on Address Space Isolation [0] trudges slowly along (next series coming
> soon™... I promise... some details of the plan are in [0]) I've been running
> into a common issue whenever I try to do new stuff with the kernel address
> space: We have too many sets of pagetable manipulation routines, and yet we
> don't have one that suits ASI's needs.
> 
> Similarly, I'm currently working on support for efficiently unmapping
> guest_memfd pages from the physmap (an extension to [1]) - in this case I've run
> into very much the same issues as with ASI.
> 
> Here are some areas of the kernel that manipulate pagetables:
> 
> 1. The collection of APIs that are specific to userspace pagetables: mmu_gather,
>    mm/pagewalk.c, some vm_fault logic, all that good stuff.
> 
> 2. The set_memory_* and set_direct_map_* APIs. (Which are implemented per-arch).
> 
> 3. Some non-userspace-specific APIs in mm/memory.c, such as
>    apply_to_page_range().
> 
> 4. mm/vmalloc.c
> 
> 5. Highmem logic such as kmap_local_*
> 
> 6. Boot and memory-hotplug support code (your architecture's version of
>    arch/x86/mm/init_64.c).
> 
> 7. x86's KPTI
> 
> 8. x86's LDT logic
> 
> (At LPC I started enumerating these off the top of my head and multiple people
> spoke out with more examples I hadn't thought of - please join in if you can see
> more!)
> 
> By and large, these components are designed completely independently from one
> another. This is made possible by the smart design of the low-level helper API
> (pte_present() and friends), and it does lead to nice explicit coding style.

By and large, lots of functionality that deals with kernel page tables was
added ad-hoc, like e.g. adopting set_memory() designed for DEBUG_PAGE_ALLOC
for protecting kernel and modules code.

I think it's a good idea to have a generic abstraction that can deal with
kernel page tables, like the one we have for the userspace page tables.

-- 
Sincerely yours,
Mike.

