Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29353C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE696B0109; Mon, 29 Jun 2026 12:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0816C6B010B; Mon, 29 Jun 2026 12:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2296B010F; Mon, 29 Jun 2026 12:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C258B6B0109
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:41:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C524166A01
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:41:41 +0000 (UTC)
X-FDA: 84933516402.13.FEFEA1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B21094000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:41:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hJmAai/5";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751299;
	b=rfCa2f3cyy1cw0wwGJlE3KcGzf2Nz8d/Xwy93/5FYKP7KjN0y42+JAVlHWq5EITDC7+ZcN
	hZXH1N7ySGTABsb3rHm6TSd8To2AX8Yvjbklgi3jHPJBwfTnvpK3GTLd0h2eLFuvIVHfhS
	KDS64AqN8oOmQJrXZbxzaPmSpkQEuXw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ch5CI1toUlORlovajdCC+YMRoe+PpJQnl8a5VV79Qi0=;
	b=2YhbagxWs8fj+YhTEnjhvgjymn8hK8YyXKNKq4IehnV7PVJVY9OGMvIyYn7QDjkrLOVubg
	ccC9V0L1mwcDGRdiuwa6oQjI47hedMmCFPDzPddz7sCiQH/T2M0bBEOcbKCsC8fk9yQ91o
	+wQQ4gFvJ8Vu79POV8pwEv/Ieumll/U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hJmAai/5";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4608F601CA;
	Mon, 29 Jun 2026 16:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027B21F000E9;
	Mon, 29 Jun 2026 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782751299;
	bh=ch5CI1toUlORlovajdCC+YMRoe+PpJQnl8a5VV79Qi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hJmAai/5vkibkmO6VFkWSq/Ll1y5jE3j/DzaeyyPFKyq6xwAWxIjO79R0qGEP4vSC
	 dscAlrX5ctbgTMNUAbj21/JNqvHk3lRwZZOF6r/Ta4FjjCdP3/PBnSN/C4tlpR5j9j
	 HSF7Dlc0aoj7gsDTbePMQtjCP/xBpH87s7MdWxQs9Zuf/RhQ5LBVu/X3uV1WM1uMla
	 uNw5QZ+z1TPY33Q7kIG03f2R4Eax2CqGoQK5L9fO6gf9Y0pff5oJ8krKULZnitJWl+
	 HfINykNpBBlOytN9AKxyPcJqJfMwdZgfi0f/ZXCpWHSG44+9HDMHmBql5baxz3zYvY
	 zey7OMeB60fnA==
Date: Mon, 29 Jun 2026 17:41:16 +0100
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
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akKfAl-wdIAbexNR@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
 <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B21094000C
X-Stat-Signature: 1hmh5dks9obh1fqe77fc4a9xqrte5fwu
X-HE-Tag: 1782751299-443428
X-HE-Meta: U2FsdGVkX18rmQ354xLxuYZ17rvttx0UARvnrUdYKIx5Ay87siVGzJafOxLd0/z0NqFz/iyKyeNa61y8agvijPlnRjezm/TttHK37RXREKAAEIm09fbwj8G/WUd0dIVuWmULZvhCe0eLu4duQuL9KPfsAEcUqiUJ3Ch93ndUAgQ8Wbk9FQWD2AkT1AKV6SBUuDWQ18DtiuGpZU9ONYzFSY+yW2gvHCZj5lv79kwUut8DbFGS/xycOniy8m+ZEwjirXE96KacyPyOsz1U1dBHil7yJ/A7K71xy/+BQztRbuwpY75uhkHA1hhEW9zP/KZyQNs6jdyrgu5Bcpua/H/IYZVg/r4qCWQgfGpajSl5ovIJVTR49EWLbfcQwG3F7NS/ZEm1ZhZui6tBC5lJSHs6MJTPNqZ9D/6HOy5/3iQao02xZJ3+brXamq+IzZ+5eucdlWJclh4xpluzCFjDPrT30JJX2w3Y4tHZbMC2z4ZJh22ub803cyciwqMRpLW3Vacs7g8GGMZxNgc3cBmQq1hXmrj+f/pjZEmPx2+JJgAY7dH90vx2sY+29Xn/EGkA/wnea9PfFpu9o7fhhp3r+pCUbJ00m3G5Ugog6Ic1B8cAHwPLqsG1zqixnMhW9aKmR2/+IRAoUZMYGakNncflj6ut0ormRqa36ID8xrXlkH40K6wqtFxXNzBublJYmuqOu4l1a/6WlPcUv7YRNVATcfdUOC0QceneIr1ajqscJMhsm/hMoONoNHCP1ablMyzJr4KskZsDryT5gwGBx6P+ri2YTURWA+8yyp7zyI+OG66fcBCl1rCxlPTDNAoL8sBAwCamErmlP65n6s2RRnwxnWAz0eZoDduIPHMuy1QH3nd18lyNwwoS2/fTWh0yKCw0vMtIGzzdH7C7OUxg9wK8yQBaHaIzLTy5uupY+J0ayBYUqfimrPCfogCigQKLvdlgmdpTkLtKsLKpkORqtb25zdI
 JRUwOnhv
 DwVXc1CywZQYdsJI5wKrkB1uA2zZ5JIegWp95Bv1ED2H1OYg73Qc/pBObWByldL6Z7CpsXFEbPQ+QIiyqUIYZ/il5Mneb0ZzhP7EVxAVO2kvp3khTlXsQYnHUaWG3j7ZA/5GhjiBDE/Pd+vpb+Sl5+l8RQ7xQIMZcHXFD196/odJaVVldT4nkwCHzPaQ6MV35ME5Tzh2yal5PiK2b/kgR9iVjhZ70vH0VnJ1bdKMU4cjkHp2gB7C9i20jQVQDDXEtwKkwfzVZuvqqCe8/2oTtYp9BrBEm7XPgi+gsU4tQGVDeOxAVjiMtagQo+oYkF0QrAeBn3iY3K8XibM3KdjDq8C0tAIK/Q/UQ1vHSUjjqS39OzQ9LIioKskh65w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 12:01:02PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> > Update the file comment to clarify that both file-backed and anonymous
> > interval trees are provided, referencing the relevant data types for
> > clarity.
> >
>
> Isn't this self-evident by nature of the function definitions?
> (one takes a vm_area_struct, the other takes an anon_vma_chain)

Well you see you're already hitting up on issues there, they both take an
rb_root_cached and the vma_*() ones do not instantly scream 'file-backed' do
they? As VMAs are obviously used for buth anon and file-backed...

But later patches fix this stuff :)

And I feel it's hard visually to see where one set of definitions end and
another begins, which was really the motive for this, as trivial as it is!

>
> > -	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
> > +	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
> >
>
> For my own edification - I know not to add new BUG(), should I be
> converting BUG->WARN/something when i find them in areas i happen to be
> working in?

Yeah pretty much in all cases.

It's very rare that you'd want the kernel to definitely oops, and I can't think
of any circumstance where you'd only what that if CONFIG_DEBUG_VM was set :))

>
> ~Gregory

Cheers, Lorenzo

