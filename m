Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB98F9EDFC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F716B0088; Wed, 22 Apr 2026 11:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56FE6B008A; Wed, 22 Apr 2026 11:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93926B008C; Wed, 22 Apr 2026 11:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C95BE6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:23:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A36BE3409
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:23:21 +0000 (UTC)
X-FDA: 84686560602.06.31933E6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0F7C100013
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:23:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vxcEGDX9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776871399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2d38+AL4M7Yw85ZULCXmHoMpmyNuNJJ0+LlK7sbOybg=;
	b=k2QxKdYXGr+1JpWlFf3xXPOhsWIWCLwLRWOgaXSAwPJZwGuwO1fm2EC8o2Na80e54rtxMf
	09BifMWlfpvXTMJJHyhxv+2dfctPOagJHv/+XUuyYNME39jDTqSgFzafEXxnlI3oVoqdKe
	yS//LptBPQGnQRAVat18S8+qOFf2OfQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vxcEGDX9;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776871399; a=rsa-sha256;
	cv=none;
	b=iN08OH+AdzqQEt6mkFABNQDbOkH+pS91Z/Z5r7bJAuMEJ1aP4a7WvJ5zvpuNDgJGqNEql7
	eYs2nudQBPTrQ72ukkr9j59iprccaJUxosOvnzn3932HwxkBN8Sh9KZuNA1SDUQWL+VYZc
	EkPKeqlvVPieG+rh/HQByAorSvNzhUU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=2d38+AL4M7Yw85ZULCXmHoMpmyNuNJJ0+LlK7sbOybg=; b=vxcEGDX94dL0ogQnI/K3g9DG2T
	WCdhIwcCdrHhlXKEiXiLQ8Kncy491mxHIfpCglgVNrGCPIlnaTKohTjC+mpA3h0Tbp35yW+UkHV5b
	AGPC3bW4hDP0kdi3Zg2Uthj2vNtGVrHs2D+mdqqD7AvT5v+uAtliF38IyrP4qifMsCaMgzL9Kntgp
	leG+7xPtRnNhFP123fCkfJPLAZ+nWHQY/TbbGZ7R6HOOZC0jIksJOeMM840mVYz/fsz+w9GDmDzQv
	BriTxxfmim57F3os9xXv4aG+0HbR20JMtsF/onkRyX3UOsNKmDObeeeW3Nwaww+Q38JddLxlUVbFk
	i2jP8FSw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wFZQ3-001iIv-2o;
	Wed, 22 Apr 2026 15:23:16 +0000
Date: Wed, 22 Apr 2026 08:23:10 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 3/3] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
Message-ID: <aejnmh3xlHsuKfP3@gmail.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-3-2d0277f8f601@debian.org>
 <7b4a6659-e2e5-5e63-2952-c7a840ffcdec@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a6659-e2e5-5e63-2952-c7a840ffcdec@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0F7C100013
X-Stat-Signature: 5bubnn7htzm94cojsoppgo34ordekg7c
X-Rspam-User: 
X-HE-Tag: 1776871399-367025
X-HE-Meta: U2FsdGVkX18TbszmGd/OIlPM6YztciOwBk24mqo+z1pmIZnjgCDtJkTyL4CV0qCwjRB9zwBd78t/Z/5yyUgYLPHs5UTiuaCDdRzf5UwAjnIo0kW4LF4ke0Otq+8r41RUs/tPJ2k0o/5QlO2dKabPy4h84lKxUM+vLbIYlQwUIRCqy5s0d+a0Z6a5J5skoesOJ4uvA+Ck2hquyZYaCFyIhiw5Izo6r6aagbs9qnAqq2diI/Ljf1KdFI+2Knc3KlV2y6+evFd49ymrDNn198Y/6iw6yc2HzM6AvLz4swNLAJ9qMYbpVntupv3eQR3Jank61uXyrcUpD+yKGP5wSXUf6pOG8r1LS1yyMCJphnmFi76frOs4+ZFJH7CrX/IbdepkjQFmZTDMxtJQktfFeKTvIj7KfQX5SecihwFP62GRXrt83QAAQ1t/yJoXXtueLq4Hy1rLdfUlwVTXFZ80wCESg/noSj9szbEsT2MTB0XoNWVh5zLiPVqoaL4vBxaMjKzs6SLYVRwPV9RniQSekUQ6mu1Bzeyj/k1/k1pIgLwYHrBQNRWTaU+S2+X27ihzDC+Zctp7MEAtp+QRJXveHiTcfwfY4MtfAS7v4XvFkl7ixxbQodOk/SQ6vyMZkGoehOXFBy6RF/55385TvvK9q26IaB2wZTbdwZ0wG1IKy6Gg+4YHf11s5wrJgnO2o/7j5v6D+xHtvAgbgfM8mnAl9KJXF/OGyCUdwOQuIXzUh97uyb3zrSJim8Bp2nn+ATMfGUFDUIrLSJpO1Kb0Il0lwJMDSxMfDGdXf2DNmLYXmjSONu7DOOdhfax1fx0SvL3CfFw+pLJwHeDLmfmQDsSet/sH0pW/zu/NNygV3tYKRfPHZogXhFBIfazXv9wfMZt+UjwYQxPzdHEuiC/442AZo8fuLOYsRWNbWM4JvpikDzo7yAxsfUFzQ+10IvZ8UE7kzZElHREziSBFZ6ghBO/yKli
 babS2wl5
 R3Fm9LCT/gvHBH4Eq0jbUw+o7X8NHbZ55W/Pv1Z8f2ek0d+A/7Q+V6VYaEA+aYFVZ9BUCt2RFmqu1jNETOwH0md3v3NvllE0t9jH5/uqFfmVVMUZpI/m9KbLeyFvz3z3OR9CpcTIPD2mfJEyZB8dBVglYJGI2J4rsYcka88p3LzjhWRA77/FLOxuH+RoNzFTHTWQgQ7+zRXk7hIFD/0VaGx+qAyTe9uGnM0X0i76G4ANwC2djzQMZy7jpcMgP4ECYqIxu5gpU6ACNOQ2AzptudKxvhVWvge7RuSBc78UlzeirNxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 11:43:16AM +0800, Miaohe Lin wrote:
> On 2026/4/15 20:55, Breno Leitao wrote:
> > Add documentation for the new vm.panic_on_unrecoverable_memory_failure
> > sysctl, describing the three categories of failures that trigger a
> > panic and noting which kernel page types are not yet covered.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  Documentation/admin-guide/sysctl/vm.rst | 37 +++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> > 
> > diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> > index 97e12359775c9..592ce9ec38c4b 100644
> > --- a/Documentation/admin-guide/sysctl/vm.rst
> > +++ b/Documentation/admin-guide/sysctl/vm.rst
> > @@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
> >  - page-cluster
> >  - page_lock_unfairness
> >  - panic_on_oom
> > +- panic_on_unrecoverable_memory_failure
> >  - percpu_pagelist_high_fraction
> >  - stat_interval
> >  - stat_refresh
> > @@ -925,6 +926,42 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
> >  why oom happens. You can get snapshot.
> >  
> >  
> > +panic_on_unrecoverable_memory_failure
> > +======================================
> > +
> > +When a hardware memory error (e.g. multi-bit ECC) hits a kernel page
> > +that cannot be recovered by the memory failure handler, the default
> > +behaviour is to ignore the error and continue operation.  This is
> > +dangerous because the corrupted data remains accessible to the kernel,
> > +risking silent data corruption or a delayed crash when the poisoned
> > +memory is next accessed.
> > +
> > +When enabled, this sysctl triggers a panic on three categories of
> > +unrecoverable failures: reserved kernel pages, non-buddy kernel pages
> > +with zero refcount (e.g. tail pages of high-order allocations), and
> > +pages whose state cannot be classified as recoverable.
> > +
> > +Note that some kernel page types — such as slab objects, vmalloc
> > +allocations, kernel stacks, and page tables — share a failure path
> > +with transient refcount races and are not currently covered by this
> > +option. I.e, do not panic when not confident of the page status.
> > +
> > +For many environments it is preferable to panic immediately with a clean
> > +crash dump that captures the original error context, rather than to
> > +continue and face a random crash later whose cause is difficult to
> > +diagnose.
> 
> Should we add some userful cases to show the real-world application scenarios?

Yes, good idea. What about something like:

Use cases
---------

This option is most useful in environments where unattributed crashes
are expensive to debug or where data integrity must take precedence
over availability:

* Large fleets, where multi-bit ECC errors on kernel pages are observed
  regularly and post-mortem analysis of an unrelated downstream crash
  (often seconds to minutes after the original error) consumes
  significant engineering effort.

* Systems configured with kdump, where panicking at the moment of the
  hardware error produces a vmcore that still contains the faulting
  address, the affected page state, and the originating MCE/GHES
  record — context that is typically lost by the time a delayed crash
  occurs.

* High-availability clusters that rely on fast, deterministic node
  failure for failover, and prefer an immediate panic over silent data
  corruption propagating to replicas or persistent storage.

