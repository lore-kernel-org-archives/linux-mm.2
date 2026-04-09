Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF08E9DE6E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60B76B0005; Thu,  9 Apr 2026 05:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38296B008A; Thu,  9 Apr 2026 05:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76306B008C; Thu,  9 Apr 2026 05:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C89EB6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:18:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77839140566
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:18:14 +0000 (UTC)
X-FDA: 84638466108.12.BD64B5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E009340014
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:18:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dn/tfxHF";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775726292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCRSXwVlT1XOjdVpuf40T2VPLXl7Op8wM7eSXQHx2t0=;
	b=q+sfYGAw8TNAU3Xz7hpazE4nXp/DrUZIJIYcBMxCYXYJN5pySl0mRRbQ92hm30OVAQsBc3
	IWyAlB0VAwqW6mYvQWDlg3p+HYPd2o2FIMzyyDa82scHMQjRVbncsVWsP3fGM71OrfP2U9
	TfwOsHKp+P9OIbJ6EImi5m+Z2K0SGYc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dn/tfxHF";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775726292; a=rsa-sha256;
	cv=none;
	b=cOKL+Mt6NSbAAI1Jr/1yS+fSTXb0c/H8AaTpfyRTDhoZu1DApl2Ymg57rh7/h/oC80jXUi
	eRXcVD6juOycDE0FDLpkTpuR+gSr3lO9tqkxOrFn2F1avbUTdcnD1Zf4/7kO1EHh6Dx++T
	qbZZFWICfC0SEb/WdP3V8iQ6OEhyz9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C05860121;
	Thu,  9 Apr 2026 09:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A6BC19424;
	Thu,  9 Apr 2026 09:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775726292;
	bh=l4DQ125b/7uRFDTo0CRMQOSUlthuAZ0rRzbKGkw3cEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dn/tfxHFLwuOjXDZkAstNVEUjr98q2XVZSrqaAXDbkjYV+nyB76PREwXcJ8bAObzP
	 QevxZFTHLxmqQjNlhNZcfK+Zgxk1MrpHuFRBHdXoHbBKkXCUUOxEcaUxet5IFYD0g5
	 7Ge2j+178bd6e5npbCPC+Ynma9khbpv7gy18NVb1fcp9dh6k5Z9JT9pff44F8pgFgv
	 bqFkvhLAHrkDuQuUXGR2IhbYBgAOXDrKrY71108UaJbRaS94xdbWo2UHRB9mBU5BX4
	 r6vPMehdZTRH3CrLcAahl7JpstxKj962Tu3wmcnm+CA+1afgqT+ZeTCza42r8qy9n7
	 3q/TYDrJ+5zfw==
Date: Thu, 9 Apr 2026 10:18:07 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <addoN3ur7GtiKOFf@lucifer>
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer>
 <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E009340014
X-Stat-Signature: cdzdwpirpcp44hcy7esydowj16tzzsn9
X-Rspam-User: 
X-HE-Tag: 1775726292-379047
X-HE-Meta: U2FsdGVkX1/lqQOEFtibYR9fDm4AQoNC+7bjBTzLDPxaNuVuDWlZnxXYAycwnNGaCm6Ul7sk8YlD/qINrIVfSkbhDc5QhqlWkPMsTsCEysXaBanFt6+7HHfRoF+cQsorh2nJpOGj+X525/mlC+xH0baOgI1NFf4mgMMszobHtOnq4AZRPTQVDfaoqO5YB2aM5p+K/MMmyIrkTM/Roayf8UXIrGsSieXyVvgvm+tkV5Qkpq69xUF7P4uFcUbT7X3HUWr6b2+GvD//1Uu4Jvx4RSyMap01fS2XCOdiHJPTUDjdAAd+HUNJ1N6YTQNJJRv1MnhF2CHhtvdH+NwsnCtfv+V/7nTtBV0OJVOT9qUuOkvcMmtRKIDPspRUfGtjZdxSggwfcressLyTTe8KROYKF5e0thr0/+6Tt4GHc6jOZRKcrwmVwylLfN3iR9mQsEe40hK9VmcGrCeadrFkgIQ8xMFW22hXVg7hMq4I2wJV4YrLLJpwNocbKAm8iEozbPslsuqsm/Ixep+LONzLSILjZOvzUTvDJLjzQKV/EdC7mfpQhW+600u0+gyKqTkO/FztAkBrWIXRjIZODR5+YaxwAKu0y1MQU8HpQRsDedIkvnhNlZkJLtF+h2wObfthSyZOrO0aCz/0E4K+wixtJMspaR84l/+sY91z/jjLQHlXxSQ7+w555BMyFMd9dAbpiV3mqjA/PW1bxrplvjGe7CvEBJ/mVz+nLrtsYafbPW697edK0WG4yZXa7c0BMV7gf4RbppG7En4AjEu838O9VzTGWqRsZhfdlIDlKLTSstS3Me4eIUD7yLF16BiGFdcxJaaQi0rd8BviEhFFF3WAscu1e+qKaZAOAGKu+5+KyujdcjeLsd0Y0rOqCE8AEQNhcS/HpF7yCf39/RtLGqUV2bwuWIUx0kdPjWYJqPbRsjdUiZPwOpOp3BSa6VSVxev2rnhx7b+jRXmvvpRG5Z7gtoi
 5weCbF1R
 TXEn3561wTvZJAc4CIzfpbMY4b8X+nH6jBIhHGTU9LH6i7krnnXO97SaP1FbsungemzMmwsADQRJ/0iGDXRhAKkdXJ2J1V50dmuVgDvzWoOnLo31B+BGPQRGzfNoAbOpFhmclxljwmCwup7ydVehrNubLELUBQ2yralhnffXhwjg/tOgOlwsqR/Rq1VtUhqxpz2bTmStU7nyFF+hvVzabHimOLGqFjHKQWDw5TsHCjdJcBkvrdrtwovgDD1GvSn3mKznR5WwHVR5A25v1rXkFy7MM/G2bdEut9OuTvN4yBprXCFt2SRFmmb2u3ukRJ7gB2t9rVyCCy0ut3/tkQID5jqO+bH9bnTnKjbhC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 02:57:10PM +0200, David Hildenbrand (Arm) wrote:
> On 4/7/26 11:36, Lorenzo Stoakes (Oracle) wrote:
> > On Tue, Apr 07, 2026 at 02:21:41PM +0800, xu.xin16@zte.com.cn wrote:
> >>>
> >>> I'd completely forgotten that patch by now!  But it's dealing with a
> >>> different issue; and note how it's intentionally leaving MADV_MERGEABLE
> >>> on the vma itself, just using MADV_UNMERGEABLE (with &dummy) as an
> >>> interface to CoW the KSM pages at that time, letting them be remerged after.
> >
> > Hmm yeah, we mark them unmergeable but don't update the VMA flags (since using
> > &dummy), so they can just be merged later right?
> >
> > And then the:
> >
> > void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> > {
> > 	...
> > 		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
> > 		...
> > 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> > 					       pgoff, pgoff) {
> > 			...
> > 		}
> > 	...
> > }
> >
> > Would _assume_ that folio->pgoff == addr >> PAGE_SHIFT, which will no longer be
> > the case here?
>
> I'm wondering whether we could figure the pgoff out, somehow, so we
> wouldn't have to store it elsewhere.
>
> What we need is essentially what __folio_set_anon() would have done for
> the original folio we replaced.
>
> 	folio->index = linear_page_index(vma, address);
>
> Could we obtain that from the anon_vma assigned to our rmap_item?
>
> pgoff_t pgoff;
>
> pgoff = (rmap_item->address - anon_vma->vma->vm_start) >> PAGE_SHIFT;
> pgoff += anon_vma->vma->vm_pgoff;

anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
'related' VMAs.

And we're already looking at what might be covered by the anon_vma by
invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
ULONG_MAX).

>
> It would be the same adjustment everywhere we look in child processes,
> because the moment they would mremap() would be where we would have
> unshared.
>
> Just a thought after reading avc_start_pgoff ...

One interesting thing here is in the anon_vma_interval_tree_foreach() loop
we check:

if (addr < vma->vm_start || addr >= vma->vm_end)
	continue;

Which is the same as saying 'hey we are ignoring remaps'.

But... if _we_ got remapped previously (the unsharing is only temporary),
then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
and would still not be able to figure out the correct pgoff after sharing.

I wonder if we could just store the pgoff in the rmap_item though?

Because we unshare on remap, so we'd expect a new share after remapping, at
which point we could account for the remapping by just setting
rmap_item->pgoff = vma->vm_pgoff I think?

Then we're back in business.

Another way around this issue is to do the rmap_walk_ksm() loop for (addr
>> PAGE_SHIFT) _first_, but that'd only be useful for walkers that can exit
early once they find the mapping they care about, and I worry about 'some
how' missing remapped cases, so probably not actually all that useful.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

