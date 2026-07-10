Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01AA0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3B26B0088; Fri, 10 Jul 2026 09:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E366B008A; Fri, 10 Jul 2026 09:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26076B008C; Fri, 10 Jul 2026 09:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5296B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:39:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20832A045E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:39:25 +0000 (UTC)
X-FDA: 84972973890.19.EE6453B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 679E1180013
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:39:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fydQPaDx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783690763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWe5y0XfVr4QQQGo0kaEF8UGbBWB4HZz8UbrXKM7Z28=;
	b=WdVpfXwpiCbIfbBglRdAckgo/jql3bv+9E41ESlvgv6US+DDxFTpntRgnVBO08otuuZhx1
	3CcEIBTNXDULFnhzNawbF4fper0SBO2j5CEgaUIVRcmpZj5OvDFQS8lLf9PV2rKli6I6uD
	KU+nj6CHS30qJcdmOpKbL0kj4nHDfTs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fydQPaDx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783690763;
	b=cA7Nixd1tE8ARwrR8fLQ548L2rnYuOdNseKDGw+Gw9H6czIeSTT776syxmBkhT5Wa4Fwh2
	dddzcfn1YNMityzNF4VgEvfVr3DbFXVVRyHZ/UawBdO8/12lAUWiCsjvHTrvhyLCiisDZk
	3pVXLjr9Zg4jKjVtA68bFfC24oia0j0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B73443C2D;
	Fri, 10 Jul 2026 13:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F051F000E9;
	Fri, 10 Jul 2026 13:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690762;
	bh=hWe5y0XfVr4QQQGo0kaEF8UGbBWB4HZz8UbrXKM7Z28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fydQPaDxS/hHGLVdvf977qUXBNSF6t19lqQW/RqVTS+Xk5pgKo0deA+cWIFhyYRvv
	 IeSezmg4COMZrohE1QJ6gnvclo/bOnA8j2IrdEmxinGMPa0Cv9pB6NQzVtyWt96x//
	 6dNWU5GX7waS+2jwE8BVZ3WNZw/wsfy0C0SSKxIKb3QlnIRCNzHVm3c5Ps0q8mrTgW
	 zsWArKYrCmnfDcrebwcipzmYNQ0mhqZJQQZSGHykLDKtejNlCDmPcno/dc/3rjzGeu
	 kuxVdLjqHCE3kyZgIMxt9Re36Qo0mzOOVMmO0ZdfPfAx62l26oANlEaaJo1XHJjjzR
	 MdqLjT6QyxJDg==
Date: Fri, 10 Jul 2026 14:38:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Matthew Wilcox <willy@infradead.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, 
	SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Message-ID: <alD1h7kHZdX_0I-0@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
 <03762de9-c695-4cdd-8c25-4fc31335ea15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03762de9-c695-4cdd-8c25-4fc31335ea15@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 679E1180013
X-Stat-Signature: bqwszduncgj8hcmcq3qjjq77xdgdzsst
X-HE-Tag: 1783690763-964805
X-HE-Meta: U2FsdGVkX1+VHNVKgb7VS26lPfT5VJVL9J581idti8q+gsHHufkbz+YzDb3oMmT3QynNX0ktWmWq/Mwd+QuwIuM6V7OyuClcfybos2cS35p7NCwn2noFNJCujZySsrHzevwSMi3/Pv5DDdKQKLcTASIBIcA2lc1mNTo685VekdM6P/X/cWMv4AQ75BFCmYfLCWjJjRyt2KN5IJ1jmFBDfn1/kFwIFVZ1JI6CBNUqAPGGpMFdUTkBYO23sbw9rZcdapsDmRZFM+lJ4DhhHKRCqOr+SQYf/WW9xkkmZqPHN6LFP0H331lq7IuSfI1Ud5Aj13OdncscMRw7GxMT2lRQnGtloqdw8si3duUchtuVc8BWAF5c6H/RjXe0d+PwP1br7HCiPZNv3OThFQQ0M/fy5uMjURjI2PqLXUApsE8C+nfV4x/q+HuCRWs++7EL8RHKK0tFiBfRRvLpnG5XXXpWGE1LQ2/JzYvbHHgLITIXE8Cd9hGXzMjyA/CnMzhWlbOe9+Tzn1VQX7S+F1vFpwpx7/yW+idxvocGHiM7BbsFM5b+JOe9A95yAPgGNc1Fx5+1Ol0TMcGu18lbvhlXr5KbqGg9MQI2idBHau+ZpOmejWh2tSEtzvdBYlEQq0ySJRRU6Pn3sFMN6y0cJH4uBqopKvzFCv/fxqMhUzZTvEQqVcVpGxWKvxSDB7dauYSjhsX6O7D+Ym8YBNLYGPL3BUyRmglqYnSVXDCEKKjiYSp+bA0PI4ZHmsoLFI7FBPcC8y9NdSvb9mnTpBRtd5esK1zui0v1fkX2D3CxfcVzJgBUyRZ2cLwkYKJXVDDyr1UgbIxj+ykqJv8J0iEXXBLIOrHzjVdPNLqRSgGEAuMwy0ulghYMXhppFcAfaS/fbmEd6sATQLWJpPP13HinfNoEkC0zfhrXt0l8WyGvFJEixB5+OlyphBEFBmCZFcODBtza9yqDoVmzrlIala+q+1tu+ZT
 8l3TO4TL
 H+AMBKvq5ljcuNp68iyZszCb4tlfzy5n2XxeJe2uxwUqw2pnYRrA/iUyZ5xbxDNud0aSGDBRGq/28EcyMPMYCQnrtlIz0HVG2ohxVMKJ5rMQd/mNwSZnJp1SGOanQyukhjlqvoXrPYy9+conuqzTNJ6g94gf6oOZt5fJzrMbS+BCKn+QL4YlA31u+a8G8yBfDvgU10T2z6DAtElbFG3ZjkOsqM3KiPCPD+nrgLRA2P/aTG2AXWZNGFcARSQgFsSxhKKsa9VdTXGzCPqLjOBtFH0gfnXbDuYWOkNLgamp5KtEwyO8Qj/DiKi8gYnP6EzSwhObjbjH3uGa02/WeUSa5+1Iw6x+pzO0oBL3V7UIi8LcX74O64TSbqXGATXj8bmD6r1ohJXKI5LCTbJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 04:46:13PM +0200, David Hildenbrand (Arm) wrote:
> On 6/29/26 14:23, Lorenzo Stoakes wrote:
> > Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> > detail.
> >
> > This is in order that we can differentiate this between functions that will
> > be added in a subsequent patch which provide a different page offset.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  include/linux/mm.h | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 059144435729..2f00c75e66bd 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4278,11 +4278,37 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
> >  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> >  }
> >
> > +/**
> > + * vma_start_pgoff() - Get the page offset of the start of @vma
> > + * @vma: The VMA whose page offset is required.
> > + *
> > + * If the VMA is file-backed, this is the page offset into the file.
> > + *
> > + * If the VMA is anonymous, this is the virtual page offset of the start of the
> > + * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
> > + * virtual page offset at the time of first fault.
> > + *
> > + * Note that if @vma is a MAP_PRIVATE file-backed mapping, then this returns the
> > + * file offset.
>
> There is the ugly case of @vma being a MAP_PRIVATE PFNMAP mapping, where it
> returns something different.

Yup, the pfn  I will update doc to mention this abomination too.

The virt pgoff stuff in the RFC fixes this also.

>
> (remap_pfn_range_prepare_vma() -> vma->vm_pgoff set to PFN)
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

