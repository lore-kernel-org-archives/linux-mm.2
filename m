Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BBF4606A332
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FZOy+twc
Received: by kanga.kvack.org (Postfix)
	id 2F5E26B00EF; Fri, 13 Nov 2026 21:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279646B05B1; Fri, 13 Nov 2026 21:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13ECC6B05B4; Fri, 13 Nov 2026 21:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E365F6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:10:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73760160319
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:29 +0000 (UTC)
X-FDA: 85432095378.04.938505F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8655140006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FZOy+twc;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794622227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSXUmoTueZUEvp7VgPWfl7EqYA8mQIeXBc1RFV+0lh4=;
	b=ewQ3hkmqKjAKRiIQhQSXg4tj/q/BDuozcl3hVN+JGm7TeO6oSPjDfjyMgb8rCOIZtuBZEq
	bD3o4dUug9h+TkXvT9a4Bdg9CKU6l9+uCJDyMR+PIy4+5UwLRSIBDmQ77hZpPMkyxilzk6
	xRjH22GJ3MEyoUF1BYfEJub/jKmNF/Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FZOy+twc;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794622227;
	b=XSg126yuPZ/UPMfGpg0FePqWuLsOH18MNPgIkFRn4p4oAx28eltNaBicI27WAiFX9OMWUE
	pauZhFMN443BDMELsXaCTRZOcV+LSQN6cLEem++BieXFMYttwCFOYVtrhcglSP5fUCw1Dg
	N6SclghsJhy9h/UeUDJy9RkCGQIYWTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E626F60E80;
	Sat, 14 Nov 2026 02:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C761F000C4;
	Sat, 14 Nov 2026 02:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794622226;
	bh=HSXUmoTueZUEvp7VgPWfl7EqYA8mQIeXBc1RFV+0lh4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FZOy+twcnZdsp/2EYUVyITPvhBid7djzTEf6WgS5LYzQKEOteWGy4HePPqY1U7vKf
	 5HZ3yUtdC8/0f+7WVBBTQ7muLcyCwFBlIhgCfyxNHz5nY402zWm/TJunHyONNDjanR
	 KUed1YSuY1/MyfntRmJ5o+tzH0P3AZgDw89dT3dM=
Date: Fri, 13 Nov 2026 18:10:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org,
 david@kernel.org, kas@kernel.org, dave.hansen@linux.intel.com,
 bp@alien8.de, rppt@kernel.org, stable@vger.kernel.org,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
Message-Id: <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
In-Reply-To: <20261114002027.GE3706007@nvidia.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
	<20261113200303.GA395967@nvidia.com>
	<179460249376.482102.14669935557901467762.b4-reply@b4>
	<20261114002027.GE3706007@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8655140006
X-Stat-Signature: tzx5nnaodqzrrnjfmofny3k6bybfg6o9
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794622227-909765
X-HE-Meta: U2FsdGVkX184AJ149HM2cQjWtXcozxs6tfSluhZ5SRHkrcfLN9NHshy5W8pvapSVa9+vx1Oxph3vlGUA836lTFAb9m7siKuCuCrg5tOJC1oWg3FXVAp468WM8K8NMfha/fmyF0SpH0B1OgDO/5jZhejuP6l96nfoyhTvtnQbhgS4tIfWVbgK5bBjhGuIWpJ+5PL0ofSGpHFAlVZsoBfRZtIbhNoShMB2mS2OGu4APk6WW32dyOVVfOj7E9ePLiYTE87q/wrfIUXptXAVFdQRcimYhN+VI0bOSp108J6wEj3J/BddqsRf/tGCYSs7pC5LDVyo+gNzPa+P6pBpbRwwJKgCAdnKvrybni9JfaOTItIc+YBIIxYjmM2NRAvckF7wBsb/JpksHvUGv1UloH0cZKgYrIRdq7v7Yy7HIa2+N4iWFOdat+6UM0gd8Pa4tYhN9tUX1tkN5UFKXF8DOVVugvQpJUx6E1Vz+/0SssD26yjVdq4TmvJlRxZFcyIBj16iawF5kD/0FPgudQWxg0Y0pRxgXGUNJCK+7LkU/0ftDHg6oeCpBgREqobtG+YsABXy27yLg14LWngYo/Ok0nHPabNOCVZubnXUvn/T5n9ASX7BW5No65dgbZMdu79ZONXQTvUyTmRdJ2oWTyqZMYNfz+hbn5MpRsTsXGIUYwwlyUg+GyTe1mMRWYH/WiZQi82KORVAR0Kh5I0Ys5MM+cyWKtjznGkGTEkzXv+geftipBHaeEbD1+VCx9/KxT92FvCisvD1ggLdcNnhQ0E2P0hyH9uic+bpZfsYs//gEwEP1gGHcGzopY7nza3nFRKmbhZ/U7BNyURHvVOkEvnIKosIEjREx17L4zcNs3cvkChFn3TFcyy/UZcxF3ioFgEjthwuH4Q+iLBw3GARa+Z4OVVPpjdN0vz51wTGaOerQe24RfZx57PwLUgC+XcpJtbxUZ+GjqVZTSvnAZqdxlygDX7
 YScz9n0n
 jh9AMZ910TgM0yGv0kRyjtrwO3z9j2Z9Klkuc7hCKxv9eBOBfIP7m/wL4DGpfuKO6XSK/TUn0lKuYoRbslV/A42O9hbiaxGT6tUOs4Vq1zOfaWC3iZuNvenKsHW0VUXWqkB+zh68L8/9BHZ6MJ5eXP3+vAk+eNw7q3dEBdzNfADAoqtena0WytGZoMczcUHe0ngQ98uSqjUz5Fo7TFHmDpA6xJaIZppc3UsIgxbHuqwmIRSkBGma/R/SfjOpKmJeKYArlVms+l1kGAm/8vrXfJGZG5oKiHfgMDtcyKTAZJOPmi0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 20:20:27 -0400 Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Nov 13, 2026 at 03:41:33PM -0500, Gregory Price (Meta) wrote:
> > On 2026-11-13 16:03 -0400, Jason Gunthorpe wrote:
> > > On Fri, Nov 13, 2026 at 02:55:36PM -0500, Gregory Price (Meta) wrote:
> > > > HMM can grant ordinary device write access to a userspace shadow stack.
> > > > On x86, pte_write() is true for a shadow-stack PTE, so a populated page
> > > > can be returned with HMM_PFN_WRITE without taking a CPU write fault.
> > > 
> > > I'm not sure I understand this? The pte is writable but you don't want
> > > only DMA to write to it?
> > >
> > > Is there something special on x86 that makes the shadow stack pte
> > > non-writable by the CPU?
> > >
> > 
> > Some of the context is here:
> > https://lore.kernel.org/all/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/
> > 
> > We had a similar issue with migration, but this should handle the DMA
> > case as well.
> > 
> > It's "technically writable" but the kernel is supposed to prevent that.
> 
> Bah, it's not writable at all. The CPU PTE has write disabled and
> someone thought it was a good idea to make pte_write() return true
> because the CPU allows writes through a special instruction on this
> special PTE? So now all the places like this think its writable, when
> it really isn't.
> 
> You could also fix this by having something like pte_real_write() or
> whatever that doesn't lie about the write bit in the PTE :|
> 
> The patch is still fine, in that it matches what everything else does,
> but I'd include these details someplace..

How does this look for an altered changelog?

: On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
: rejects ordinary stores to it, but pte_write() reports it writable because
: shadow-stack instructions can write it.  HMM consequently sets
: HMM_PFN_WRITE, which Nouveau turns into ordinary GPU write permission.  A
: process with GPU access can then overwrite its own shadow stack,
: potentially corrupting return addresses or bypassing that protection.
: 
: Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.  A
: requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.

