Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC010C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7459C6B00AD; Fri, 10 Jul 2026 11:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB7B6B00B1; Fri, 10 Jul 2026 11:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5FA6B00B2; Fri, 10 Jul 2026 11:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38BF96B00AD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:16:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEB928EDAC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:16:12 +0000 (UTC)
X-FDA: 84973217784.18.D845B9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 15E9FC000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:16:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHGTVQQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783696571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4r0Cc9l2aAmZyRZIk2/aSrghpeZfvwxavhupSZVEeMs=;
	b=OMd6GyQFAPza7AckU8xTFuGEAOQ8Q5ECezyu1yHS2OhE3lHjoMRjeGfJzyEpWOoXvLY+Iy
	RaY1Fukdxpj/EiujLLq8fQJzI52sFr+beHqz/UPwEKS7d+wRZj+LZwA12qD2dEA2ftj8uY
	9HSDFFZ1DDDaQSzLMUiHov5LAFsaaF8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHGTVQQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783696571;
	b=uHFaXxuwVXQlQzt0CknZbJ2HChcToVCIBBapbZ8UJgMh2QFQxkrOa6KLTTlXIcexnXv5lJ
	s4QbQc5UlLUVzp3c9hmrdqZddB2kxTZRw05ts0HAwkAPU7u8ysPsijiTd9TJv1qYrrk+PC
	GKzhKU9EbqZuCiPtSuIFLt9Ey3ZJRUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CBF340A4C;
	Fri, 10 Jul 2026 15:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39A61F000E9;
	Fri, 10 Jul 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783696570;
	bh=4r0Cc9l2aAmZyRZIk2/aSrghpeZfvwxavhupSZVEeMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DHGTVQQhWaTrPzJXRhL+eOlPh3mjgM3TYm3BACmuvjIRndZXufi/DOhVvVPUUmShz
	 pMaTajqPd2DgQBSgWuLiUyl1vIFajO3tcup29tN2rA+oZElUGBQ1IGgnnzXislM27I
	 7CvnkGOpI5896VQOz3W8Gmxeu3uzmNGoxn7r0l7pBdQ0sONYuYGXeAzxoC3tQ9/wUH
	 UEFxz/qEn3hiXt8kPfwHLqlEerVkyRZiznIxE9j6rS+w6Jb2/IyIAdhgUn87BZzWbP
	 pGVPtXCokUhc0BUp8Nl0bg7ctkDVndBAE1whxwQffv6MbiL/O4PIdb6JwCyyrjCy4K
	 eJhH8u+Rek3lQ==
Date: Fri, 10 Jul 2026 16:15:46 +0100
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
Message-ID: <alEMciQmyQA7wdua@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
 <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
 <alEHy1raICek7imv@lucifer>
 <alELDgm258nhjk3b@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alELDgm258nhjk3b@gourry-fedora-PF4VCD3F>
X-Stat-Signature: dy6bfafi3hh678s94jarruo35oh1hcrr
X-Rspamd-Queue-Id: 15E9FC000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783696570-902663
X-HE-Meta: U2FsdGVkX19Q2UwrWn8OS6nDaVuPmFFOgS9n4qEasmdhteCNQoPdlNbxrmJmq+au6Qbbzvfvo7KJzvwr9W7VPzSZr8IWY0tI3EW8JrwWQYPrSFzE+zS/5ypqPvAa3+9zOIzygDCfic0JjTqWhGiB3oGWpCYacYXFZu9xdymRLaq0J9ntNP6W7XXVf+07GhWVgBrZxiIOz7bpStQbydy1sEs6r4qWFE8ndfYk4s0ZwIl37T1pwdgvIX8CNQBPU2RkO1t1+gCcQC3GEAN/Td5XPC2rX5n6u6T3Xk92rOKy2O7FkfbP/K6M7Q8Yo9N9y2BG/mMo5/sxOau2zYgnz705R4hbIlFhMw08+heQnvQBUramLmjSUqOEq8uW2kYj8lt1xY5hsp8pMFXZS8gWSJFp+guxKh5hCLFFohecCuN33Vwr/NgHVRTutgB4ZKqdaNAFouySf0XIAlycuIUEFGVcaT2M9q6bhmnBFODck88rqPOdvcGARp9/L7RrnmKS1QIAYg6B/8XLKP6f4M6FLw0wJDtYc+jgtmfFPmyrJ2aIap0iKTJc6Icfg2btY80/3PIMga20kFf/EtZ4TvimoBVAeqpnJ9JkjdwoywuJ0cs5wyfA+PYVV+Lc7GYAvbE62CiH2INw2h0H/a918E8GpDN979CX0Gk7nmRZGirR7SrH0GiDXlpmUbADXEbuN2OB36GdbWhgQJQNSv+4WP55myaJIIHfZlIUb3cg+CpLdzlVFWRpqPlocrlCJbaiaZYXohOwSUYUuDLF5d/Wj0OhaU6FD87HJTrymS0+pULtUySNGpEeV062W5q6x/Lph2LyLn7ObPmx7d5yOuMPX6j3fFSGWImxcgqGgnp4OLNSPV5oRCQbmAe5LXrIBPAy91igYBaDeWK7if2YQwSEa5/ptOF2oFskkHZ+RkQbrr7++oVTzREqYZX3+uPTEkY/VzBRjBSU2rm92tIB4Y/gVI36WCj
 wVeXYzwx
 uZxM31Enf0rE1m95RtZL3yAbAwpqigR2+xNxHthMuYeFRFDJldYFT0N5evjubNyeWheQzfvavB88NnsBVA5hiISCu7sVNdBU+Fl8yT/uJhzGQ3PZCDSAzc/mhlrnGfdCjAwp9ztf4dPYn0fEyuyN6SSvG4CBacjnX1bTKFUE787h7YGjRZT1ysAPvSaX1s3IwfYnvhjfldkE+36D4P/RetcBlWOX+5ivawHtyHhKzS7FsiKBeCmkP/5008krAT3OVb3aGPXajN/eWcntyih06qhx0Vxg8SJq0ZTtzcZk67/U/MmidLwe0wTG9dIz8HIUkqmTnJMddHvMu+3wuaYaurK4Qo4fvuOuIoo+sVWhw14kbtF6HoXn2v/6lQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:09:02AM -0400, Gregory Price wrote:
> On Fri, Jul 10, 2026 at 03:56:33PM +0100, Lorenzo Stoakes wrote:
> > On Thu, Jul 09, 2026 at 11:49:18AM -0400, Gregory Price wrote:
> > >
> > > Silly question:
> >
> > There's no such thing :)
> >
>
> All my questions are silly.  That's my secret :]

Mine too ;)

>
> > >
> > >    What's the purpose of retaining tags in a non-address value?
> >
> > Well if you want to reconstitute an address from it later then that'd be the
> > intent, but I'm being hand wavey here for sure.
> >
> > Main thing is to retain stuff under the page mask
> >
>
> Right, which ...
>
> vvvvvv
> > > That sounds like there's fragility just waiting to be broken.
>
> If that's an actual issue, then our relationship with tags is painful :[

Yeah, I'm just not sure tbh.

But all that is stuf for future masochism^Wfun anyway ;) focusing on the 'respin
the monster series' fun^Wmasochism atm...

>
> ~Gregory

Cheers, Lorenzo

