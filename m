Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A74606A883
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ooFZpzeq
Received: by kanga.kvack.org (Postfix)
	id 117476B05B2; Mon, 16 Nov 2026 12:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C89D6B05B3; Mon, 16 Nov 2026 12:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF92A6B05B4; Mon, 16 Nov 2026 12:10:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAA666B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:10:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB2C91A01B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:10:41 +0000 (UTC)
X-FDA: 85441621482.16.86AF382
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4284D1C000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:10:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooFZpzeq;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794849040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbHsekUSMb7nu0RIE/MWB5d+upWpW4eGrN8+h/t43/A=;
	b=MQUYuFKJiOgiMzyq0ArDbCIgavBDhKCK2jkbL3BeDxrFmdOUH2nn3vsHZmE9Ct/4Rvbuls
	nTKr3d/HbZjD1xPo7nZ8tIDoKaxXdLCF/nRMOz+A+hkP2Cq99ANKTESvvC5k/A03E2FIfG
	yidIRPlXZ5LPMCFZJetDv26umAExDpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794849040;
	b=7CnfqP/uHfBGq/9aR8ANBZO9u0P2anu14phV2OSzTWuykDBI4PocCEfUHW+EUItzqpPl8F
	9ctmb3di7nIjrKH71jFEN8y18fO/RBdVV4QHx2c6zQtx8fLg2JquUyKCWSv9mWGmAy0d+L
	59+ZwhjeJCyVAuDh9AUalx0Ok2YBbns=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooFZpzeq;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0EA4612C3;
	Mon, 16 Nov 2026 17:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B8C1F000C4;
	Mon, 16 Nov 2026 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794849039;
	bh=tbHsekUSMb7nu0RIE/MWB5d+upWpW4eGrN8+h/t43/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ooFZpzeqTPFuyP7Lh15EzI5bg9INBkCaKSSB/Wn0ybABoCZOdwGmkd4AWhLRWChoS
	 o7czW1XViUOfgC5gEd/vymO+F8VD50VxRYJOgFJQy9ICLGhFxoRZpdRIpi6ZpvQr05
	 fnZbT7fZfg4/ICiky6eLv0i5apWEUf4USsayEPrUhjfpDnLXZdPvUlzx4UIEHFACVd
	 KUhYexqFCsA9zVXZbqV8R432S7E/l+lw/ot1ce2rTthHGn3HfbTl/8wnseBBvNA0On
	 0y0yW0dcxaBc+UJ5qrSthAvIaAZgPZ0wCBPcLN0twIduD1KfTFeiY4XEsiq8G8SYRs
	 M4raFmCI52cng==
Date: Mon, 16 Nov 2026 17:10:29 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
Message-ID: <avs1rOJQ1gV33z8w@gremlin>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
 <dccf94b3-b901-4311-a233-488c87195dc5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dccf94b3-b901-4311-a233-488c87195dc5@kernel.org>
X-Rspamd-Queue-Id: 4284D1C000A
X-Stat-Signature: mfcc6kbs5xmcexc83rac3itdzcxy6f7m
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794849040-841649
X-HE-Meta: U2FsdGVkX1+z7ulINpuCOEGATeOsCjLYfkDMjKkb2Pso4MwbrcK7aS00B11AT+p0yfZn5lHiJ6302DXoPE9De+BxpWsPm//08RkpjwOOtxs/ucWdEd+vCrAU7yiU7IAzP8Q43mHfBLW5choylfMJIY2tEe6y8ddVpL+V4g+SdjgDl9zrAZRzc5UNjhr0hA1BaaQAC8mWPxH7kbqkHG/lA/gmo6XRYtV1rW4G6fWABgbJmgUaIghKVX6LgCo8v2Ya0bVOMt6w1KTQ55A38V7oK/xcyRNJiaDYexJEcQUvcl13J5D5xgNKb3/iWqPFGxGu/Q0WNDLXG0C6D/LDrH7BKjK43miJGIFuuMNdfB2C8wBbQAPUmUgY4QMP9fx3dmFSfXWogftUL3AzrY7sjXMiGgY97phkFGJDQv8ML6nMfpP6H78YV7OPZndNXli4IPRdJU2sp0fnRXvAfoKLPi7KhdZBnnlQT4L7sRhJ53lj5vk7wesWmZ1Eh6Kzol4EquUNYArlw3XXrv3/mwPtKmqG3JIeISQMy/cFD/N210aDpXrlFxDRx/CK8uy0L3IlzoOXL47yMSTzgecRnnCwKEzdc89qTRIpXEfoqS7qOOWiLP3IOCnWvm0ABFpyuH9Cacgs4x77clqPpi2nYRhaUY4BAWw+Xj9L7WeHoOSrk+sKLsxCUZT5M8Otg6QH4P5yCHxJ5PCIExkhERq8FdLgN7ePc4elCGXmkZn1ypFuH57NWsuW4TuVw7Rc99Pq0tOhBZMc3rlQgsilZwTV0fnYdBb0ekAjwtWweHyhzFnhiaLlT2vZWSdzu9JGtAy5kNaxbG+7850fCGtbvlK1EkJIUCsCYMP8jJmlaLrR1jyTgcTw6T1OEQAbR88lcjHLBKWTHmd9Pbu10FctgD/ESmly1/+9QbxSI16yc06YEFF/9wbfaFa/tggRBItw61zBafZiLmfTyte0wx0iEQ2cG+qh8rG
 SPd41RcV
 DV1MI6lwjgyBD5mhPWmS7hCZ1cSLe066YmLEdsBdZ+bt/9+blgT80CxF7nSEeGRwXpnV1ELHIrCci6U4QgYdd+I9t0WQOM7qM49+1ivyNowQEs1TB4xlaX4B8RCWzkCKq0/3z1bHNa2LZMHNFya12hNuB88r3Hept91jqSmstr92QDiiEvRbJQIC9MieeYGlzv4+aguQMlKx46/GD9IbvULGeOXh1OuA8sENAvH0fsMvF1nUh2nopCXDKMFhricux9tRwamEYX3daY6aReLin96McJ4djmAh63heGh/2ypp10SegiIvLrz+oX06iXCAsntlqProotQsxGuJn5yI9dfYtt9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:56:25PM +0100, David Hildenbrand (Arm) wrote:
> On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
> > From: Eliav Farber <farbere@amazon.com>
> >
> > walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> > so without holding the PMD lock, so the assertion is only valid if nothing
> > can concurrently install a huge PMD entry in the range.
> >
> > This is not the case for a VMA whose driver implements both ->fault and
> > ->huge_fault and which invokes vmf_insert_pfn() from the former.
> >
> > The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
> > takes the mmap write lock and faults taken under the VMA lock are
> > unaffected by this.
> >
> > This can result in two concurrent threads faulting the same thing
> > disagreeing as to whether to attempt a huge fault and thus ->fault and
> > ->huge_fault running at the same time and triggering this assertion.
> >
> > So just remove the assert.
> >
> > Target the commit which introduced the first driver able to do this for the
> > fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> > them using its own mapping entry lock.
> >
> > Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
> > Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eliav Farber <farbere@amazon.com>
> > [ ljs: rewrote commit message ]
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/memory.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 3a20d64fd276..e03110906aa8 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2384,7 +2384,6 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
> >  	if (!pmd)
> >  		return NULL;
> >
> > -	VM_BUG_ON(pmd_trans_huge(*pmd));
> >  	return pmd;
> >  }
> >
> >
>
> Could this also stumble over a huge PUD somehow? Should we just prepare it for
> any leaves and bail out if we find some?

No, walk_to_pmd() can only come from the order-0 path right now and
__handle_mm_fault() makes sure that can't happen in the fault path:

	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
	if (!vmf.pmd)
		return VM_FAULT_OOM;

	/* Huge pud page fault raced with pmd_alloc? */
	if (pud_trans_unstable(vmf.pud))
		goto retry_pud;

So by the time any ->fault path runs, the PUD is stable.

We don't have to worry about the mmap paths as at that point nothing has
faulted in and it's all fresh.

So it's all safe as things stand.

But could update for future-proofing like:

	/* PUD leaf might have been installed. */
	if (pud_trans_unstable(pud))
		return NULL;

?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

