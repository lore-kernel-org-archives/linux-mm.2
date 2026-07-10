Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C14C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95146B00A3; Fri, 10 Jul 2026 10:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C736B00AB; Fri, 10 Jul 2026 10:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D837C6B00AD; Fri, 10 Jul 2026 10:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B38206B00A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:57:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A5A2A0483
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:57:00 +0000 (UTC)
X-FDA: 84973169400.07.37D6B15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A0710180009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:56:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/Asc/zn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783695418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzEYD7QM/y9ve2znyck6ty1wQQ+sVrAjeiBdSV3oSsY=;
	b=NmKqjmAZDEvg7/eNBtJPqy0DLHAPtG3yGtNQx0Uzv8a9xO+zeTcKUkCkCu88BL2IEh37uM
	5cRM407F7XdzVZhB7DA7ZN8MZfyhwFL75s5V8b/wrMJrnWFhVv8Vkfh7ZcHnNOYVZffbpj
	unN8ffOMAKwSbbpULasKLr4TlxWiZ/E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/Asc/zn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783695418;
	b=kgwVHwnk3I+XP8QP7iiCLG9/RUZA10Ge92kERwc56F2iSylvBJkF/92LCEZHCLrTbLzqmo
	zHEiFbttHbwvnWLo7lG89XtqrN4pR8YOwhXPIQ+/YeYieeuRzCrdYKlMN3kOfELNfpquIf
	+CnDhYaSKQCB5AYVGaInlZL/m8AiAJs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEBCD40703;
	Fri, 10 Jul 2026 14:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88B01F000E9;
	Fri, 10 Jul 2026 14:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783695417;
	bh=LzEYD7QM/y9ve2znyck6ty1wQQ+sVrAjeiBdSV3oSsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I/Asc/znkA4zkIG/CtKbirdLbixdlI7zHONQqtAnqomgCl94CK7klg8Aopt3EfGU+
	 dMEeXtqj0XTqIWyq318sb/fU7GEP1IWZMgBdlOECFGroHSrMpdIDe5bE1xpdJWXtnQ
	 IAH7HMIzD67eDd/PrzAukc1+PgjQyOnCGrKGn0ugKUhlMpDSJDrjb/szPVAOqQ752j
	 371AZKbsCU/eRQjnnemCH0AkcDXRb7rMEYNNODfJKBNQsio3stx+mPxn5lC/NFt07t
	 E5qncsXTbt2O5NPYJzsolU12GWt/V388X8DsBSsxeuJTsRtDoEASS8ysPDuiAjQ4h1
	 ugJldN6Kxi5Mw==
Date: Fri, 10 Jul 2026 15:56:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
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
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
Message-ID: <alEHy1raICek7imv@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
 <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 3u9pr5mcmfgaqak4w7bu94idacniuobu
X-Rspamd-Queue-Id: A0710180009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783695418-817344
X-HE-Meta: U2FsdGVkX18SkzmqM1e2D9xxBP2gOExwGPzrOlWJF9egWYoNOC8ZU4J9TYIx8tdWY58RQ0azv19coNDheJ8ISnMxzV3qdLD3+tlX6RrubRdnJiQD/fscV7O/UjLq9Eyl5xAfhXcgZbXCn7hMRShOBU1iwsWo/w+UZjH5uhB3aRFNd+4/hSAfSiBdI5qTJ+9VRz3gW/7pqRzJomJ1IqBF330s3VatXO6AHUl3+lu7IITlXRfuKWiHScB5AtwGoBrmP+cUdV0eLXJ657OXUYUoS9nPjd+jxG7FEGetONL9DjKkVsXtICLnvJU6PHhglBLSH8AvpgUP0EMPx5bw3KhFCusfIPjHm0xBpJPaRxnsdBmEoSsS1I/jqTGEdqZMXX8JSusg8DiCDG1BroaARq9R1GZOAggtGFVw27t7nqT/+T37iHrxeMxVaaBuAIKOcJ8TofNDiqpfMuYiq+IBFIfuwrTRadLFcUdNojFctpONj2Tic6rQ+783FR/HQgg+qvo5u1KQH9YREkXvCD6F5TRwYr0TRf54fcPjb7s/ZA04mYN7NemQSg/9bIDhpyfmWdWSaot03ejajVLRGddHNsxVUaylATSQ96G3Ri1vw8dFW3KApgVQ0jUWE0SpW8g8nzoLp8VPV0YixLPfFKCH4QplSu47mylKJxWYF00qsh7nbOaHtOnMyoBUtxNAeWKX7ZuqqK2P6yJW6DjyGGN71ARBPCcgrXWbua9Y10G9L5ySFUVDEf2/Io+1EozOcqS2hIURg6+ax43qhv5zlq1XQ0J8pwqvcWp4uQ+DrY0MRsnZVZmq5YvcVx7N1qqYFXcvTyXpZ5vFJIh4EPCh2z9sq3VknR/YgEFwrN65fL2qss1UNrWVfQ16x9VUxc/vjtWnFq4fw6PqoN64ArSKAJ+0URnOZkFAwI9bEoIv8R8dmAZCS3YT3JEzY5G42SRMURJLIPsdx+L654ouNBqMdDjf+oO
 EEgTZxAK
 Ufjc6Vq2RrerPm0KGlFty5ENmmy5GXrhWEKx4G7y0cqviq9bC7d3hTx/yN5L+FMsuFswS//M8gxZPj0Kj366XNqZ5VmmWK67YxBVhFb7hHBNWtSEwkr+Ha82LYUCDuoaGl6s4I/Cxc0GtXEvvK7ZhzIRpqIHzmRJ1gpo9xLJCXvgAAMWYrwGmvz6QolN7eiLTXRGrObHG1vaVSioYQl+8YI6kcfvLpNPyBxJNlrpzqkQhOdlmcQZr1afPCj4Cpco7+tOAIdbNF/KL06XZxnWItNNiQYlZrq9amm4Zc/pu0++RTOO0WNvL2Ynn50W/r49Wg1vZrrwaRmojOPWTRQpNekzbvCfKXTwc2x81JMMh8fX2MveeeMXM+33vVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 11:49:18AM -0400, Gregory Price wrote:
> On Thu, Jul 02, 2026 at 12:30:59PM +0100, Lorenzo Stoakes wrote:
> >
> ...
> > static inline unsigned long vma_offset(const struct vm_area_struct *vma,
> > 				       const unsigned long address)
> > {
> > 	/* Retains page offset and tags. */
> > 	return address - vma->vm_start;
> > }
> >
> ...
> > And I'm not sure it's really all that useful. Perhaps retaining vma_offset()
> > would be though.
> >
>
> Silly question:

There's no such thing :)

>
>    What's the purpose of retaining tags in a non-address value?

Well if you want to reconstitute an address from it later then that'd be the
intent, but I'm being hand wavey here for sure.

Main thing is to retain stuff under the page mask

>
> That sounds like there's fragility just waiting to be broken.
>
> (I presume you are talking about things like ARM MTE and such, right?)
>
> > This is one that I think makes more sense.
> >
> > But in general, I'd rather hold off from yet more churn here.
> >
> > I'm making these changes to establish a basis for virtual page offsets
> > introduced in [0], rather than just cleaning up in general.
> >
>
> I agree with this.  If the refactors here suddenly have to think about
> corner cases on things like tags, that's better resolved separately.

Yeah this series is huge enough as it is :P

>
> ~Gregory

Cheers, Lorenzo

