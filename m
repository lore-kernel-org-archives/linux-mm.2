Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89577CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 07:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126B56B0088; Wed, 30 Sep 2026 03:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8646B008A; Wed, 30 Sep 2026 03:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30DB6B008C; Wed, 30 Sep 2026 03:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B95506B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:24:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E8EA160708
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:24:48 +0000 (UTC)
X-FDA: 85269591456.01.740E042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 710611C0007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:24:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULRyPEr4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790753086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgebVyA2f8bKZ8A2l8IyTzYkpOfpYnsZpljHgtWB0X8=;
	b=n0M7dZVYsrzt5YjJP6OJGgvFYflk+Nl+7mWZ3PC4PIbsX5dZQ/PPkKM6s26yofY3r9d7s8
	U+W30TRnC6yJ7V5jl8VOs/OpAlAEJpqxisafi7ijZWN/VZtARmcxQJSrOqxaBQk2oGMJgX
	MfZgcJ+QrtcSFqe6l4qvfMW6FQc0+ls=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULRyPEr4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790753086;
	b=TmRPLY8Vp91N5ElrzFP3haiMA4zdZ1uHywBB7ryTpT38Ntfnog87VYHpepu/GVmIP6oBk8
	F1SLEIQX55oYvTFqcxAj7Acf99OPz1pvxOnTKxu4MOqDAIJHeJYdmOOv4IPY0hXm+sK3Az
	IkIl5KaVxWAssXU7UKEVmX7kpJDz1/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59C3341614;
	Wed, 30 Sep 2026 07:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D021F000FF;
	Wed, 30 Sep 2026 07:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790753085;
	bh=KgebVyA2f8bKZ8A2l8IyTzYkpOfpYnsZpljHgtWB0X8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ULRyPEr4Z7KeKV5X8kL/73Bw64SH3O5BQ0fdHMp9zZssoAuINO2fBRC6Mx8ezHtdi
	 st/YQSKBYBwvV7pNTM5biueFwqbhYF14uMmqDItKJR8EM/g7SJaunGrFBMcGuCNErp
	 W5jXoriHg1IIqnrfaKtfuzIt7kGWykpzcDFH+C031fuVwaBSXE61NxQ28pS85BeT6f
	 EmcWVaAJwy0vEkmHKKUkOygq45gQHO2WNYH2AjJtJRNVaiy3I/zVzuhMxtCyh43IFA
	 vi4ICUYZigtim8IWF6Q2FVOEeH82CtLFbduYp/qc1uyG9gMpYHC3OQKRluRKzB1cNv
	 DJcSR95vOoPVw==
Date: Wed, 30 Sep 2026 09:24:38 +0200
From: Gao Xiang <xiang@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Gao Xiang <xiang@kernel.org>, Jialiang Huang <huang-jl@deepseek.com>,
	lance.yang@linux.dev, baohua@kernel.org, damon@lists.linux.dev,
	david@kernel.org, kunwu.chan@gmail.com, lianux.mm@gmail.com,
	linux-mm@kvack.org, mst@redhat.com, ryncsn@gmail.com, sj@kernel.org,
	virtualization@lists.linux.dev, xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Message-ID: <ary5Nn9le4xG7_-N@MacBookPro>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
 <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
 <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
X-Rspam-User: 
X-Stat-Signature: wroamragibcxs3d3azhoursssdqpxe1c
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 710611C0007
X-HE-Tag: 1790753086-130823
X-HE-Meta: U2FsdGVkX19FQap6tchL9B/IvFLhv2rP2lgNUo42QmUxuWDYLsHEMOJWP8SIcnwiTv5jW8vIsy3DJpJhS8T29Je5SA5BTNPpUqZF1n+kzQAAlcp4PPlBq6iYYmbh2RGa6Hqx+Myssosew1l39GmpPEN/5JgfdtjFdHdvoq/UHQvoMn63oYbXnWuj2r27mG+YV+ZgVuelFKniAOqPZPRpVjTKsuF+GvY58bnwTIb+hXySeQAs75tjjQQ9iz31+5pdkG+GmpFX/Gfsy1BHcqAbwT6zVJw5ZgveNXSMAMrLhXT7YzaCtXpD4qFVqNiooXLsUou1jbWO6dljH7uWgqjwBnEwDayOrKXOy6N1mgMTZPb1sXzGhi6Fia8GpwH0fZjxzhUiw0xpFOFAZj3/o3tpd/0bzpY2P0z65IgocXuER0+aYTMjGhpwapmXHAxm4kfz76rjtvlRvgY538F+g3a1L8yU4n8qCsbGOBPtUah/3WMHK613lQvXNhUSxglLQFnA+9qWyem9CwIdCKkGP1O3Dg1IqTT8zQx9Rumf1KhITAoIC6HZ+M9DLSVuZ2J7ur5cR2AEaGEsshFE1z0EEL9uGz2PDQ9+Uaes3k9/met4t8lNzMDlprIxPZ+cWMaZ2SpTcMkHELCAxc5KisKOl7badFy76kaKsUyyeuxJd2MopqYMIRnrKh5bcsWADwRMw+J44rRJ7F+DU7PiuPdqgDroqGa1NOYPkmjWBm67Q07j8U4nkYoJieJuDZbsmGZ64Z03lJSG0ipvg7tV68rhrcuoVSILMtY2ye9Ba3knXzrtVvqS88D5FiYo63kDVDk5Irvi5dvxL8HUNVHpFMmpWhXqMeTx2sGF76Vv7ltJRq2uDLs/xKcuALyaYw7NjHTouZaAq6GE9i7yn3MTDpo8/NJrduAYsSrOJ7dMJE6ZWg1QEd95IYs6lR6CzbvTi012KczEK4PbX4YOF1lM22Qe2ad
 V50obl0I
 sC4l7tAmRsmwZth44j6zDZXTpxBIsaFMBs1Z1m8TZF038nxlwc/QvtV2HTBvmSjIlRPCLFgsKloFrZHuvAtsduArleAb17VQho28FYHsYgArh6m/6qnP6O9e/v2Ly274rwdEqQnPadpWb8egs7JQGL5zC1Z77sOCJAIfZjTvO3Q/ErlJ0/sYfM7ra6GeuInSs3/3/oJax11iguP2f9ahL89mcm4ED4z78yu0Ej4frPsnVW2Z/NcbuzYFagFOR5ER9oogGDsvSaK40l1Dp1OTHlhG+cb21YHhrzvfLKSiKxby7CuYygqxrJJbmcdWiEOKjkGqllIRb2QCiW5SIsRNjKaVR2QeDniw13jDO8q0wMj10APz3bKIZ5S5sIPMcikl6yXYyprJP4wWKT+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 11:36:23AM +0800, Muchun Song wrote:
> 
> 
> > On Sep 29, 2026, at 20:41, Gao Xiang <xiang@kernel.org> wrote:
> > 
> > On Tue, Sep 29, 2026 at 08:32:41PM +0800, Jialiang Huang wrote:
> >> Hi all,
> >> 
> >> I'm an engineer at DeepSeek. Thanks for the discussion, and thanks
> >> to everyone working on DAMON and virtio-balloon free-page reporting.
> >> They have been very useful for our workloads.
> >> 
> >> Gao Xiang wrote:
> >>> It can cause sync 4K faults on the host in the worst case
> >> 
> >> This is one of our concerns with virtio-pmem as well: moving I/O onto
> >> the page-fault path can introduce performance trade-offs. The other
> >> concern is the substantial struct page overhead for large images.
> >> 
> >> For now, we enable virtio-pmem only for moderately sized, frequently
> >> used read-only images, where there is more opportunity to share the
> >> same host page cache across sandboxes, as Gao pointed out.
> >> 
> >> Muchun's vmemmap work is also interesting to us. My understanding is
> >> that it allocates private backing for struct page metadata on demand,
> >> which could help reduce the upfront memory overhead for large images.
> > 
> > Although I haven't had a chance and time to look into that, the main
> > concern from me is that mmap() access will call
> > "dax_fault_iter->vmemmap_materialize_page()", and malicious sandbox
> > workloads (or not malicious, just valid mmap workloads) can cause guest
> > memory OOMs due to "struct page balloon" for large rootfs in the worst
> > cases and cause the follow-up mmap access failure, because the guest
> > memory size may not even fulfill "struct page" for large rootfs.
> 
> I agree that this is a real issue with v1.
> 
> One detail is that merely establishing the mapping does not materialize
> the metadata. Materialization happens when a fault resolves to an
> allocated DAX extent, before its PFN is inserted into a userspace
> mapping. However, that distinction does not remove the problem.
> 
> In the worst case, a workload can fault enough of the pmem range to
> restore the full vmemmap cost, about 1.56% of the pmem size. Since v1
> does not dematerialize private vmemmap pages, even a one-time scan can
> retain that cost until the device is removed.
> 
> The follow-up mentioned in the cover letter is intended to make the
> optimization reversible. One possible direction would be to invalidate
> clean DAX entries under memory pressure and zap their userspace
> mappings. Once a DAX entry has been removed and the corresponding PFNs
> have no remaining mappings, references, or pins that require private
> metadata, the associated vmemmap backing could be remapped to the
> shared read-only page. A later access would fault and materialize it
> again.

BTW, it's impossible for shared DAX entries (like the current XFS DAX
with reflink and EROFS will support this feature later too for chunk
memory sharing), since you cannot just use mapping and index to get
the VMA like page cache does unless you invent another new mechanism
for this.

Reclaiming page entry mechanism seems it can be used for or overlapped
to another types of memory (in order to save struct page memory in
general): I'm not sure if it needs wider discussion on reclaiming
"struct page" in general first.

Anyway, it'd be better to get some numbers with RL or agent workloads
(especially the host memory is under reasonable pressure) before
landing all these new infras upstream if proceeding in this way.

Thanks,
Gao Xiang

