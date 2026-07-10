Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB34FC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB536B008A; Fri, 10 Jul 2026 10:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8921E6B008C; Fri, 10 Jul 2026 10:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D11E6B009B; Fri, 10 Jul 2026 10:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 585546B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:51:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A21C0A0460
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:51:11 +0000 (UTC)
X-FDA: 84973154742.08.226FA81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B33F12000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:51:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV0G1PCd;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783695070;
	b=l6k80g8vcQtpuhyapDAobj53708BfW1whvIkPaCTMFGmiRYJaEVM0LaO0jkB1+5J6GtB5F
	ItJWH9rqq6H9yEL9ixdiZD1j3v8DEm4k4ihJP+8zmsqeWRXr2bubFLDevTNHMOUz0WaCBS
	/x6X0OITjsZMKF+F7y30Ig7fP0EJ+Gs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV0G1PCd;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783695070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/adl28F1RG11+xFCTzjhiMT3/quSA/55SrYHe5Xl+as=;
	b=GTIQIfgrkbbm5EdbJSa9ozsG5Lo6/N5+stVJMe0bnggELxJi/3JUQGi5aQ74lR5yGaBwIq
	vw/6KKDjRWp5M35GBT8hCEimd0F+5GzDQXae9DZ9xWy4crox4gbQuL4tZ/XFm2R/eAyn+l
	bxrswj3RVRVGa3QJ33bzlhYAsnCpSzQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67B6960051;
	Fri, 10 Jul 2026 14:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13DE1F00A3A;
	Fri, 10 Jul 2026 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783695069;
	bh=/adl28F1RG11+xFCTzjhiMT3/quSA/55SrYHe5Xl+as=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GV0G1PCdVWL/17cPDVZfz86GmBO0VpAcpElRSgqzkFaZnFKsDK6rIw+lxzMvM7oyM
	 gOb7BmlLZV+r7XfvVToV0An5vS3DWoiRNZEtakP1kgKdd/pwAzK/AhJrUnpZlFH/ma
	 IDgVC6vlNuOfwFAEke1UlfCP3mMcmRNqv1rAQF1Ta5n8CDc7P/kP23VMlYUdFRkbMx
	 btXD63gJA5fhI4bndbOxrinkAQhHaNvBor7RN1UECzz5h5BotHDkxdGHR0ZdFn1Wle
	 sxRRlN3kLf8W7g8Lmmkim9s7ySe4W1NlivrC5VU8viOWzvoYYPKNt7/4lb6lTsMCz8
	 i1PWPp9WBYC/w==
Date: Fri, 10 Jul 2026 15:50:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
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
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
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
Subject: Re: [PATCH 13/30] mm/vma: refactor vmg_adjust_set_range() for clarity
Message-ID: <alEGqHY5GPhT30Ty@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
 <ak-70CHGujkI5jJI@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-70CHGujkI5jJI@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B33F12000E
X-Stat-Signature: zhnpdcgps4o57urai5nzcrbb89sqr6db
X-HE-Tag: 1783695069-839255
X-HE-Meta: U2FsdGVkX19LnCNymQh6f9IFH8Ndjfu7Z1qpqclzF7QZGNEzc/CgtisfSlag2TNF/lRFZnEAeWQozftjfSq/hQsuaujdUq1+ooFvXtOILuCvOqJnbCompUJnmtCYWP+3/UDiJupBExdtQpaCp8mTmhTpnz8182x8VGK9del4ZDPCI7Rt2Az7P5WwnnWY1ZvvyhxzMQK/UUUyg12bfYrTufELPIr0xNpwQolKE4YVxoYPymOXDFp7KrMG4TzApG1Vl9SAtwMV40jmx3BAr+NWnb7N9QGnIZTXFp2qv6RzCJ94ace3hekLJhI/qDfrptyTaF24frnQ91LJpTLfZFj9i/qBdCt2GXsXdPPLoCHJyFW5ISyQ6O2R+LWhIKPMXYKf4o8Ia9RoaifVNO97N+N13NBm6mRmwnH7C+TM5Me1EraTVPYkTZObm4QD4xLlu47Kfxz/cjZbj9rpGrw55YVzQiG5A/jZTzTQr0fbrA5f5gxi4ep7BEbec0PHZkGsFooWqzXqkRKUrDg0H44ZrBXXT6pOVrBiT1MaLcL2VPlOL4bWUItmARWTuti7NxR87psjJjc2nwuaFQ6FZ63fPuYPxl8KVl5nCy6k98Qv7ov3u87fdSjCALt6NufDASOVhMOeOG0Agg6h0C2/RlO+GfL1mkmvelOwQLXp+kdCwTTQfO3oU4W+5NcXpgQQG0XxoiMrAMuMdSXRIxuex47BaqgHKVINErNXT75fgJr1XfzAuVYQnjA1YoCflb96XZO9lD9Ukz+ueK7uEUGfg77MbfG1JHZiXqA/Hpf5R0SaoPnsaaIxCgIUhATjR2toAjqzVb1obxiQ0RVQRwrknz10O+aFqG6y8IiEkBxCjU1bFfOF1cFge279Yr2h9UzvsaxzGE/G4WbR0VpajLRmlyHNd8H0fi9w0BkKlx7sYjvs5ag/m+XipLjg7uuKf5JAcIx7Gttct6pmYiv60LOeYp34XXo
 nHZfC31/
 jedMrSJCXIs3poNO5eEt5Z+97bFHsSyWyQ1QARr2oPBqdRyBMYI5nSktAxs0AOucY2tUdQh9frvEU4Ot496r8auk8q+aXhWbbJFjbQYxwM56IQcKrBdXmU1+xSuBWPtJW65Yc04ZDtQbWTogdszSlZf2ZikYmSMyqLGGHcu7wAm9jwnJeUt8Yzh2gw5HOU+xZESBuPEDQmcvM+23sSjEXcZ3OwrrF5QK6X20UOCkhq2rvSscdqEHS7zQy8ClMkOsNJzDHGS6hSYPg/DRofQ1J2WWSDmA1BsVdDLXzBMYAevSAWxQREczhYoyRHOnNE/Vp+PcInWZWZrvy3r79XbC7J+fPTQWicE6CYXrMabFS9wDcCYfLsTA9Kw/iaqutS9YCqYCO+8RiYSsvM+SYm88nf0ABPKzeHxb7L4leXAYDMSTnuma7107fPAIe6DIYeLFalftLqMAQ9Epffdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 11:18:40AM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:24PM +0100, Lorenzo Stoakes wrote:
> > Add comments with ASCII diagrams to describe what we're doing, avoid
> > dubious use of PHYS_PFN(), and use vma_start_pgoff().
> >
> > The most complicated scenario represented here is vmg->__adjust_next_start
> > - when this is set, vmg->[start, end] actually indicate the range to be
> > retained, so take special care to describe this accurately.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>
> > +		/*
> > +		 * vmg->start    vmg->end
> > +		 * |             |
> > +		 * v    merge    v
> > +		 * <------------->
> > +		 *         delta
> > +		 *        <------>
> > +		 * |------|----------------|
> > +		 * | prev |    middle      |
> > +		 * |------|----------------|
> > +		 *        ^
> > +		 *        |
> > +		 *        middle->vm_start
> > +		 */
>
> Even with these diagrams, it's a bit difficult to understand what the
> actual intent/result of this chunk is (but that may be a limitation of
> me not spending enough time reading the surrounding code, not a comment
> of your work here).

Yeah I know, I do hope to refactor all this at some point to make it simpler,
but for the time being tried to make the confusing thing at least _slightly_
less confusing :)

>
> ~Gregory

Cheers, Lorenzo

>
> > +		/*
> > +		 *                Originally:
> > +		 *
> > +		 *            vmg->start   vmg->end
> > +		 *            |            |
> > +		 *            v    merge   v
> > +		 *            <------------>
> > +		 *            .            .
> > +		 * merge_existing_range() updates to:
> > +		 *            .            .
> > +		 * vmg->start vmg->end     .
> > +		 * |          |            .
> > +		 * v  retain  v            .
> > +		 * <---------->            .
> > +		 *             delta       .
> > +		 *            <----->      .
> > +		 * |----------------|------|
> > +		 * |    middle      | next |
> > +		 * |----------------|------|
> > +		 *                  ^
> > +		 *                  |
> > +		 *                  next->vm_start
> > +		 */

