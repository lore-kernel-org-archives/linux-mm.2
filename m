Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC709CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056A180061; Mon, 27 Oct 2025 11:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006B98000A; Mon, 27 Oct 2025 11:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E863E80061; Mon, 27 Oct 2025 11:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46F38000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:43:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 849DC140199
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:43:10 +0000 (UTC)
X-FDA: 84044312940.13.1F768A7
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFD784000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:43:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1CPTaco3;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761579789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwPY6ZXZKL3VNgA3NbvC0pR/piPoLDOJ+dzUsiJ94H4=;
	b=sNfpvI5qnlvgEYbLp/PJIWFY5HL3cA5HH3qQylUhzuBCAOnZ/dO7M/rodG7rcbujlBL7La
	5rmWZ7F5ln+4n5QIjjkMk80d7rGp8RAvMR8zL/aOUO5OBxHoZ+V6Gy9hyjpUDA+jBPGzCh
	1e5E+jz+GbpHbyvdjr7rkLl4Tpcwfqk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1CPTaco3;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761579789; a=rsa-sha256;
	cv=none;
	b=IQX/N3zv15Q3qOu/LoNcIFiG+Tto0Vq+UuWUmOgyCr47YiH997JlW51idJPmie7lDuQtRg
	IqBR9WSjLi+7qf75Mp06+nL+zoBp0TMXRqzJtJRTJlLC3QPAH9B8GWVeyWO+FAr/C/ASmV
	14MMw8Gw+Tu/Xkfy6gnTmbnNqexPwJI=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 594569AFD8;
	Mon, 27 Oct 2025 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1761579787;
	bh=XwPY6ZXZKL3VNgA3NbvC0pR/piPoLDOJ+dzUsiJ94H4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1CPTaco3cX+Rn62YylucmDopC3dUJ60e9F6CRHLlmvWvXysgLnkKnH+xTPj7pplwi
	 9q/fl+tPhlzXg9UWsegiLAurqfiUYBRiEmJHVeuIrRoJbRqf3b8+lNjpVx6pm1v5Xq
	 zKsOlcHOBGhGDXoDtQdlFvmDLhKdOPTf3J34T+7U=
Date: Mon, 27 Oct 2025 15:43:06 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aP-TCvzsUS32X9-d@shell.ilvokhin.com>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
 <aPstDXRerYqi1O2X@tiehlicka>
 <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
 <CALOAHbDneRGZFGcTM0YuObcK0Ugctb+6Hsxvkcy=76xDmgYapg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDneRGZFGcTM0YuObcK0Ugctb+6Hsxvkcy=76xDmgYapg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFD784000A
X-Stat-Signature: rpnj4d1cdjqygqok17p9wx3x5ixsxp38
X-Rspam-User: 
X-HE-Tag: 1761579788-370412
X-HE-Meta: U2FsdGVkX19SI3Rxy4GBtPC9eXfnElgxJm3clFOTzabvDJC5nrneOk5deYCU9w0bGxr5+g/cnpVZYhebfJhGoUEo1ypsHqPDoGmWxMkPGqjYJ10d1C+DnmiObfkmfZxkDLS93T29dr37SJcY7wW6A7gAwBLdswMU1cSeExt+jyy0TL4af8hqHwS4SBrn2FJHNkn0EA6Ye/Fb7PBwbdtPydMjslz0aj4Dvnmckk45IH5KcxfLMheAvssyiJO5lhdGk2IkgkaUDlzo6lUjY53Ljq9Nw88HiiP1nV01EBQcbXIPiT5kwPkdoep80LEl4lS9xvQkO6wNe7RUCZDrTsRkrrqCdFxeMFT22yD/vBIOdujwPkXo3GNYK7MeWd3Z5K9aEDhjzD5Dk9GYiT0qWq7tdZltL0T9q0IrqwZfPVKYO97YXd5ONnNRpJdJpDLxFxqSG5FI/uLDfDIPT9J1qQn/l0BYWXLoUOfzgheLo22lWKDZA9blVSAR4DFhb0tLCuIID6srfOko4crZbYqb1w51q7aD4ANDruSFpfzS/RxQ7ggnjiUCmiEbdrOS8fHqIpJdsBeOsd13rv+r2nD7F+FFzWB2jmyKGusTsEtS4bJ1BkWE6KXrl9yEaSw6I2jW8Mg14In4MVJ8RpKki6s9F7FBTzqSCG9zJSw9mxpd8fKbzP1q+8YuSZzc1ZXj4S1XpXlyxf9b5WHdWe+cbiuC5uI4GDP3Mll4uEDX+nGptb4KDuENBwroLinWqn+cB4pyfdEjirLnFW73ChSNp4I0cXmdQhchPcOm3gl6UR1B9Ug2tiOji+JfrfJbx1s7nlu+KiRl40VQmNEl62HsDeHB99nyAVhdOFemRDh7kKc2hI1mDbA/cXFfy5ApF+FgZrZtOqUTI13p0c4QGexcGqAIZsRFLcAmT5SixBSSVQlLj2hReuu1Z7rBoRxnY8FfG/65UgXDq44zwNYx6VsNrPMwS4C
 tlcm//FP
 IS7Ymao+k0aXka1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 08:12:27PM +0800, Yafang Shao wrote:
> On Fri, Oct 24, 2025 at 7:23 PM Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >
> > On Fri, Oct 24, 2025 at 09:38:53AM +0200, Michal Hocko wrote:
> > > On Thu 23-10-25 18:12:02, Dmitry Ilvokhin wrote:
> > > > Allow to override defaults for shemem and tmpfs at config time. This is
> > > > consistent with how transparent hugepages can be configured.
> > > >
> > > > Same results can be achieved with the existing
> > > > 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> > > > in the kernel command line, but it is more convenient to define basic
> > > > settings at config time instead of changing kernel command line later.
> > >
> > > Being consistent is usually nice but you are not telling us _who_ is
> > > going to benefit from this. Increasing the config space is not really
> > > free. So please focus on Why do we need it rather than it is consistent
> > > argument.
> >
> > Thanks for the feedback, Michal, totally make sense to me, I should have
> > expand on this point in the initial commit message.
> >
> > Primary motivation for adding config option is to enable policy
> > enforcement at build time. In large-scale production environments
> > (Meta's for example), the kernel configuration is often maintained
> > centrally close to the kernel code itself and owned by the kernel
> > engineers, while boot parameters are managed independently (e.g. by
> > provisioning systems). In such setups, the kernel build defines the
> > supported and expected behavior in a single place, but there is no
> > reliable or uniform control over the kernel command line options.
> >
> > A build-time default allows kernel integrators to enforce a predictable
> > hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
> > behavior and avoiding configuration drift caused by possible boot-time
> > differences.
> 
> I'd like to better understand your kernel deployment strategy. Are you
> maintaining separate kernel images for different environments in your
> fleet? We've found that this approach can introduce significant
> maintenance complexity in the build system.

Thanks for the feedback, Yafang. To clarify, our goal isn't to maintain
separate kernel images for different environments, as we also prefer to
standardize on a single kernel binary wherever possible.

What we'd like to achieve with this change is a consistent baseline
policy for shmem/tmpfs at the lowest possible layer. In particular, we’d
like shmem/tmpfs hugepage usage to be an opt-out rather than an opt-in
behavior. That is, the kernel would default (likely madvise or
within_size, not to always) to using hugepages for shmem/tmpfs unless
explicitly disabled. This ensures desired behavior out of the box, while
still allowing overrides through boot parameters if needed for specific
environments.

> 
> In our practice, we standardize on a single kernel image across all
> environments and handle variations through dynamic boot parameters.
> This approach is quite straightforward to implement. If you're
> concerned about uncontrolled environments, you could set default
> values like shmem_enabled and tmpfs_enabled to 'never', then
> explicitly enable them only in approved environments.
> 
> >
> > In short, primary benefit is mostly operational: it provides a way to
> > codify preferred policy in the kernel configuration, which is versioned,
> > reviewed, and tested as part of the kernel build process, rather than
> > depending on potentially variable boot parameters.
> >
> > I hope possible operational benefits outweigh downsides from increasing
> > the config space. Please, let me know if this argument sounds
> > reasonable to you, I'll rephrase commit message for v2 to include this
> > reasoning.
> >
> 
> -- 
> Regards
> Yafang

