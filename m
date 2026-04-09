Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95AC1E98FD2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1346B0005; Thu,  9 Apr 2026 05:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98956B0088; Thu,  9 Apr 2026 05:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5416B008A; Thu,  9 Apr 2026 05:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB5A96B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:53:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62BD85952C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:53:58 +0000 (UTC)
X-FDA: 84638556156.01.2EA468D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8FDA7140004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:53:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bTMdzfSB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775728436; a=rsa-sha256;
	cv=none;
	b=SDihBCf0rJOP8aB0LDIdTPFrUZyMqIt95E8tiCVicWDl7o3nwX1YGadNiCZmk2+RlAEVfp
	Na9bXAiHj2h+BwDntkKMxbpqMlp2dpGUjq7ygHXJzHDXJQTd1ZMMbx2HJc0NGRf1psMUGP
	WFrN3i8QhKO27jbBj9U571wJF54Ps6A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bTMdzfSB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775728436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzDQ5KMBnxs1G8MNDDupe0Rojr2+4O8EdgztzAMeJIs=;
	b=WmrevfjmlxYzNfJbgBctV8gkWMxNYpscrvB6wV6DOUoo+JfQuzPr7OGalYH2dwGo4E8767
	9XX/cb07TsjU7PsvDw0IJuSSSnx3uZlftPhL20z9MiA/7mIQBBFcBQSwovFKvdKTZhzrLE
	wx2Chd5tw2da/NU4vJsDXOXCfCAWBJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4325843CE9;
	Thu,  9 Apr 2026 09:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA044C19424;
	Thu,  9 Apr 2026 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775728435;
	bh=7I0MXF+l8nyjZuATbUmKGm0GIf+FqeD/ZIqKF9lA6sU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTMdzfSB/UkQKZksXO3wU9KqnVN6BbkOWqhv8s2eX/ynWdibrAMAZaToNN9MXVRrH
	 yHR4iR1EtLGrIka0F02Okxgwy5xmS7Vm2eZ8e0jCVgaV1kCidZy468rtia507gLsnb
	 9H9fQa11DQmsjSXt084PvLirULuXw7u0OLDw7JQRdk0AEAEU/xgE1+g6S9ijiKNS7M
	 USMnYBd7HvEGSUATMngXbLKeNVevlr+TtRS/FZ3DUVfUtggH2iOc+oTWnNOvwpEBk+
	 7LU3NerSxO1brRPvIe6vevkEyAaSAArGsJOTuUlNr8TbXCCv6vjPLAXr/O22/OAHxV
	 RIjOCDxBYU51g==
Date: Thu, 9 Apr 2026 10:53:50 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <add2XbcdFpCaT5tK@lucifer>
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer>
 <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
 <addoN3ur7GtiKOFf@lucifer>
 <015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org>
 <d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org>
X-Stat-Signature: uibci6egtw18fidesrwg5skpduwbfnrh
X-Rspamd-Queue-Id: 8FDA7140004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775728436-545546
X-HE-Meta: U2FsdGVkX18Ioa6d6REdoO3T1ptu+Oyky80R6VvjBkFP/dscXqdm4zSx9et8tQM3hofMa/iJoMJKHqt/BvIT+PiLJzDbK4YMjEUFZvFEjiWURysfeMbOiS/got3VR+S4qou/skxKbzYU5KNo0/IcETn5TpLSndJu8QivF0HwFHxnE3Zx6HbMlzB+l0mWnGr5N98iRV+AbIGFNdN+WqnlbXL/WUXwuKgGb1HLNWUEXHElyr1Sui0AGJccJYI/IAmdy6Vy0BxrpR6sOzXGXaOLt14x6Apx9XbP97rGLDmbvV+k3rvPVHWQB4Ep+0dNuSPZhA9FZQl/NoIbB/12Tey2NDSQDweD7P0vEhcVbKNVE2z9wq22JhhEeRypAxB80QP25sQakfAo/Un4rhMcvrE05J1lgMoye2DoTTcgCchqHUDTAJmN98ztyHLKdWwiCnUdt4OREzYJcNLL1gNnU8p0H2xL4qy1WOJ6PSdkc2+QDQEWxOrr4mleOSOU7Q7kEWSS9I1JcLnQkHyt6WWNrpDE6ItUMGhmjZN2UKGNl/LwOt1H87yE4VdNZHaFfCPrgAHSAZXoJSCGvt2cceBL2yOaV5sI+Aqnw+nKwaiXZAe2kj9koA46KawGdLRQfaWdQyL63PWMgX8DaFGge5g/AcqO4kNKKFOMtp/rW7HRlbV5HNr+8dvjNHBhZEDggUntcdRTI+WOezAaNTnZ5X/jHesjRqECBClFZGtifdmJwYvJsaCQsu+g5sAZaaIVs0g4PHAlqkyqvopt2Ke+ui8g8RKmNIyiaVMVuTJ05w2cQb2v/UIe4FuYkFalXwda1+UdNMicSaLe35XD7O4UzrmOnTudZENZ2mT5Sr1ryEzXjKxVMoZf01dBUJeiyhTKGY/e8ZjChGX8CUZ5H8rOKSDQ/2OFN098R7PKL04TrKX6Nt4CPFnuNqdNGf61yooyC63m9HPsxK7+TkazbPC/EbqQ4FT
 OYkj24sH
 Uv+MX1HXZZC0OCJL3P/6fwaPYKXsen000ToIJQj79l0hsEd+8bmj2kBqYY5XNOht+hPBXLqWbal0sBDIMhTcw2D2zjFXg6yQZ4vKL1v65Rqc03Phv1GQZbnL7VeLKF5RFqoF3sg2Zbmar1wjPOvUZ2zoYEUDLJg/rVCMBMye93BAGBo0Umyx9z/zFRMOqkwau9OusTEJ1Jlpeh1jDhntiYjRM2/SLa8RmSoA7hzqVmQH6Tjwp4lO4kM335qsGgeRG8FjM4G0uXgVw5nUA765jYZfmhzIQIOBGwKYIky6H7SaYjc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:41:46AM +0200, David Hildenbrand (Arm) wrote:
> On 4/9/26 11:37, David Hildenbrand (Arm) wrote:
> > On 4/9/26 11:18, Lorenzo Stoakes wrote:
> >> On Wed, Apr 08, 2026 at 02:57:10PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> I'm wondering whether we could figure the pgoff out, somehow, so we
> >>> wouldn't have to store it elsewhere.
> >>>
> >>> What we need is essentially what __folio_set_anon() would have done for
> >>> the original folio we replaced.
> >>>
> >>> 	folio->index = linear_page_index(vma, address);
> >>>
> >>> Could we obtain that from the anon_vma assigned to our rmap_item?
> >>>
> >>> pgoff_t pgoff;
> >>>
> >>> pgoff = (rmap_item->address - anon_vma->vma->vm_start) >> PAGE_SHIFT;
> >>> pgoff += anon_vma->vma->vm_pgoff;
> >>
> >> anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
> >> 'related' VMAs.
> >
> > Right, anon_vma_chain has. Dammit.
> >
> >>
> >> And we're already looking at what might be covered by the anon_vma by
> >> invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
> >> ULONG_MAX).
> >>
> >>>
> >>> It would be the same adjustment everywhere we look in child processes,
> >>> because the moment they would mremap() would be where we would have
> >>> unshared.
> >>>
> >>> Just a thought after reading avc_start_pgoff ...
> >>
> >> One interesting thing here is in the anon_vma_interval_tree_foreach() loop
> >> we check:
> >>
> >> if (addr < vma->vm_start || addr >= vma->vm_end)
> >> 	continue;
> >>
> >> Which is the same as saying 'hey we are ignoring remaps'.
> >>
> >> But... if _we_ got remapped previously (the unsharing is only temporary),
> >> then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
> >> and would still not be able to figure out the correct pgoff after sharing.
> >>
> >> I wonder if we could just store the pgoff in the rmap_item though?
> >
> > That's what I said elsewhere and what I was trying to avoid here.
> >
> > It's 64bytes, and adding a new item will increase it to 96 bytes IIUC.
>
> As we're using a dedicate kmem cache it might "only" add 8 bytes, not
> sure. Still an undesired increase given that we need that for each entry
> in the stable/unstable tree.

Hm, random idea, but I wonder if we could cram a bit somewhere that
indicates whether a remap has in fact taken place?

rmap_item->some_field |= !!(vma->vm_start >> PAGE_SHIFT != vma->vm_pgoff);

(yeah obviously _not implemented like that_ but you get the point)

Since remap case should be rare, then if that bit is clear, do the cheap
path, otherwise do expensive?

Longer term, my anon_vma rework should fix this more broadly :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

