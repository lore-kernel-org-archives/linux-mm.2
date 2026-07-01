Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B438CC43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1A06B00A9; Wed,  1 Jul 2026 05:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8D66B00AB; Wed,  1 Jul 2026 05:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF316B00AC; Wed,  1 Jul 2026 05:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 396706B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:56:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 950D0A02A2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:56:10 +0000 (UTC)
X-FDA: 84939752100.19.C3FEEB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1062C0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:56:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hn05lo+y;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782899769;
	b=k0hqg7YGhZzAdu76kb58tAA+eOVZXiFWHLvangK+/HnuvsOW/BGA4gt8gdukwASMvOQRDb
	U2zfTQMD5o0kFfAOZ6efKo5jh4+1RMNIzi1YmCXznRHbc3nJzhXmDdOWyS+ayqQm3Jfbm6
	gQpK6Mc+v0aPBpkf8LXbTiHlZZA/aJY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782899769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFnqjfO2nGnpQRfkiFUM7kAq9hpq2gQ/a+iAbNQdyDY=;
	b=8RJ2HDtY3Ln+7IGRFgQoQsjuZvN5BUXIa73711f7oLEK0PgVcIg+fVdgfrqTmWSSEZWpmM
	qY0boZdrDpaz9mtmdjqYCPilMJqjVHz5usY9MQDhAp2498i+/HEhjNKaFbb6rSfJF1fpju
	tILk2nXl0T681ABUCtki9/bAV+k7OZk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hn05lo+y;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 253FB411B6;
	Wed,  1 Jul 2026 09:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEB71F000E9;
	Wed,  1 Jul 2026 09:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782899768;
	bh=uFnqjfO2nGnpQRfkiFUM7kAq9hpq2gQ/a+iAbNQdyDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hn05lo+yqTo162vzSSvmLgoHkc8sZFXTO73a3zpugE032j41FtZRAcgR5cC/mIsWC
	 oqb+WxZyigte/GQZKBkZXaiYmAep0fVWbliyTXXxFOHdLIA7ZB+tMSio0XPY3sBbJD
	 xp1cndGs6No9+YfwSniB6tXQcpWnVEn7s0jLOOyrTHsS3hH1QGk++EdC7x7glsCzx2
	 ooQPJops5d+rLUK2ebXz4gbnEltEwqB5O9z9G9A+zLJBaWmKUz/FSVMRs5+u0CJBcF
	 9YJUExToRs6x/TXjrPjHcKoRJgS2PsOr32tKYv6tYSwkl+1flbn88u/WCVI5PjKVif
	 CCXDS3L8jpcpw==
Date: Wed, 1 Jul 2026 10:55:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
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
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akThthi2yrXY1meF@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
 <akPrTU96BwQJoygw@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPrTU96BwQJoygw@pedro-suse.lan>
X-Rspamd-Queue-Id: F1062C0009
X-Stat-Signature: qx3kfb3b5qqdreh3inybmg3wdnan6ycy
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782899768-289674
X-HE-Meta: U2FsdGVkX18vkmcP/L/aeO0mtYy04JCeYG6SVXxbLtWgrMEHbW2SpAmXEngXVwCOI8PDyjo65+JumUru2DfKL4WDjYycJquFurnfmtmkQMUwSB6Qs5EjDsd/dmHIsXLFPzhSqP3RhMTDF9c48FB8tXkk5xRzB/NjpMA2rEI/8Bs2GBv1ZouMZvau+9wW85v29jvzEFoK3dbQX0rXLSDTlp8kW46tBe8fReQ4sMeR5TAAQeQ4A9eJPTMyb8cYMH7CgjVv7HUWFXmpxEVp+SPrMEVuEttdrUgThHpAWKe6xoLP3wGyweFYLouuP+HAP7sGb+5EJ1vj0nPkjokPHIbPR3heAw/vClPkTQEZfVizjpDD8MGIP5t3RZhHeM7HSl0FoFs6aDaa179NwxQj+XBD5skGY9KCtw7bfUT/C+wlrSxIwxLiCZIQPXu5YZ5uXNEsutRgSyzhTToUbu1kp2EuRNwnK7U9eDg86Lu3faKhJm56OQFfcMiwk/UXgaA/7HIeSCQ2NeIQqqClxmdZxVHsjBBLLutnmr3pEAkJD3RloVF56V6KP+ZIdtfk3cfw1b+ijbc7XB+eWl71Z7adc+rPLsEmEzWL3gcb41XZTdDS9v8qj4P3WX5urYagIPMQ/mqRiedBRilqXViia/C9f3r4ibnUvfZDzDW/iXrOU+LEbR1r/hffk4cXj4wEUY2r1sYr67UM/kaKwIyvLBe7lOzKzltkA6OPEx0cs2JLRLorM0cp1/imBEzc5RSIh7TLeqQFmCRd5OpD2mA3cjp4ELSe3iksT/+0OHkwKjRL4YqtUIiGzqXMw7POJljPLONzcmg/fWVZhahlID7q65HchjSBVjebBMyAlfDCAynKKubTNeYL4j2rj3Okqcs1FtFwvIYff1Tszd6WlSnBeHrTH+pjh41IZWbGBd47PxGFHNifIM203XmhGAfw+9nXNpMFHaqVhTpqQHaVqudBTnbf3OC
 gIbCMjjS
 I67iMcg6n+z/0QZ76wZIPNTxdovXtv5FpcYiissvlieRUuT3RSN2kBZayrbXHCCJAvKWiqS9oq1u1FtjTC7WDNkRJBGeCTMGQuXE+G394xfymIoJKOWRz02qpq4W7PUq3BlY0Z1oOixZkpIB+ba19KRqXCP9edWazAB4ht5KTIutq88AkPGJVqU9kV6YpiIQLF5KOQQMMbpJfHwSm08yEtl8JaQ+uZ56gQCC0i351ctzClxo9nW85JC+w4YdTPfsAFvkJC/Y0sYFxK+exxoM4olV7znZUcRKLIZnPuTBp//kc9tRpTiujrkQZS8HeSVYnNDKp5tSb6ciGmDJtOYD/tr5Fm5Qj6E+W16Pp2UBe8eBLNzgfvjcGIQpIjn1DlCkE3h9BrswB6jul4XgRXLR8drp/zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 05:16:51PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> > Update the file comment to clarify that both file-backed and anonymous
> > interval trees are provided, referencing the relevant data types for
> > clarity.
> >
> > Also add comments to indicate which parts of the file apply to each.
> >
> > While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> This is fine for now, but I'm wondering if it doesn't make sense to, in the
> long term, have:
>
> mm/rmap.c - common rmap mechanisms
> mm/anon_rmap.c - anon rmap gunk
> mm/file_rmap.c - file rmap gunk
>
> or even something like mm/rmap/{core,anon,file,ksm??}.c
>
> While working on my file rmap patches I noticed there's so much stuff just
> splurged all over rmap.c - interval_tree.c - fs.h - fs/inode.c.
> It's a little silly.

Well, Wei had something like this idea a way back, but I'd rather avoid it.

Firstly, with scalable cow coming, I'd rather us not make anon_vma a special
citizen in any way, and I'm going to be heavily modifying all this anyway.

On the interval tree side, I'm simply going to get rid of the anon side of it
altogether with scalable CoW also so that can live as it is now for the time
being.

In general we try to have generalised rmap walk logic for file vs. anon with
rmap_walk -> rmap_walk_[anon, file]() for one obviously.

But obviously there's separate rmap walker logic for file vs. anon.

I used to harbour a belief that we could make anon like file-backed but now I'm
kind of thinking that's not possible :)

So I guess the real answer is - yeah, but let's revisit it after scalable CoW
(and anyway I'm likely to do sensible architectural breakouts as part of that
work anyway).

>
> --
> Pedro

Cheers, Lorenzo

