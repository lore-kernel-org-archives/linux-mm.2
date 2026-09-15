Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4802BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2246B0098; Tue, 15 Sep 2026 09:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494BB6B0099; Tue, 15 Sep 2026 09:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2B46B009B; Tue, 15 Sep 2026 09:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4F66B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:39:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 447CEC042B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:39:41 +0000 (UTC)
X-FDA: 85216104162.03.942A4F3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D70180004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:39:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BANf+DRv;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789479579;
	b=DjtWDrOaQYOfcFme08nMW+bWrYOTIvf2Wdixm7OIC0akrfhWv84GafnCzEQqqiDgowmtuT
	PJ1vG2bqXolhR/rFGD5PoBNyLcbjzsR6wo6q4w0/OdsA1XMw/LNvNMehq36VQafHyH2hop
	ZijHLP7MobdTH/5TgqbYZnR6Pblvl+o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BANf+DRv;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789479579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZSU09jDCsIk/tpoX25HEUkW1egfskgNv1nvZG1Ds40=;
	b=oOQG2p44PnFfNbk9LuNgCDvGQU4w9FjmuBIhhwCOBsxRHUFcQvnjx605+TIDVgfYMK173S
	R08nTBIerOO+BqvwYAiWl4F5pK1goiGPqAtljIKGQME9WKS6ao/KR7hj+dXMUyRV05+QEp
	vlU+Ly1WPzuTSA1LIQT88J6KlHX/QyU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=tZSU09jDCsIk/tpoX25HEUkW1egfskgNv1nvZG1Ds40=; b=BANf+DRv0G7ET6nd+Q02kEYT2c
	vD0Mdmy0esC2oiO1N8yesVKAZLUPkTsnz8o42k+YjQG4Z+8iuYgTcrL0MNA6PbeaKganDKnzH1Y6o
	dz1s24SikbwO6UvoBwIl5MOsySvfek4zhd34ghQRFqhlMs76eRAiXy7gCoWV3PKofIQOYDmDdmZ+z
	8umNKp9aZ7sYSbOGScmRPisgvY7fTzJF4LhfQfgaYtHzp+aE8umHMErYILFzLYv+cC6N8zV0soirE
	MzgEa0+BS6oIJQ04ge7Wt0Df7pee81AIR4q7tocqaLjyrupAkjIJjTRtDxCT86XCyk5TrACr2je2b
	QoiL60yw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6TN9-004QnQ-0c;
	Tue, 15 Sep 2026 13:38:55 +0000
Date: Tue, 15 Sep 2026 06:38:47 -0700
From: Breno Leitao <leitao@debian.org>
To: Harry Yoo <harry@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqlI264D-PxJzPWb@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
 <aqkyT0Ui9h5KWuzn@thinkstation>
 <aqk4NUnq92ftuUuJ@gmail.com>
 <aqlFnuIIECOyaweo@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqlFnuIIECOyaweo@thinkstation>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D70180004
X-Stat-Signature: cbasgfek5c1qsiyhx93i6d4yci4ayoeq
X-Rspam-User: 
X-HE-Tag: 1789479579-328640
X-HE-Meta: U2FsdGVkX18ip4Ua2E9m45K22ICHAEHQtJHIAINuN/L2hoxB4M6bEvcV9Eh+ob1ofnCRrYy4rJHO03yZmqzujzaDDwoQKyFoL1C19QQmb4WBAVedmDtOSmSi/UTLqsW5yz61gVe6OdXxHcl1FXl2FsfhX5HWH3dEDBsAPpJuzwwRL1CPy0+We2LqqSDvuTjVMCGEqFne9LM+LpuqGYq86EAxE7leyghrSlaSNuGiQL/frGcTu3UDBVaRFK24TGH7hYlVVFNRdquK0eck+996WEe3m0Tc08gm+lW5zEdwSxsnZUYMZnd7Lk1xml3acbPcrS5m4v8W79WA22jvMnzIFUDukVWsJ6YwzSvuyzsR0aNuinPp90qlLLfNpyaQMLr3q9ygBJ2+cCrPa0w5xMjVL9/wh+BMnR/uRQYGrXMBsOMHq3k/sSKAckAwe2VNlKS9Vz1qPpbHC4S+WIHCimLAEgX905M/CxHScfRIZ6N97y4ivXdsZP1xwfHaWrrieGtLOu+FB0070Bu4s5ggwCYSxTZvqy6x0yGHR2k2dGUkRrjBoDQvrnT89FG7FUHINBR3y6EX1DlSrOU5YpvjCHhf9DBEetWeh5qHOA4CqB/gIsjbwIfDKfxV89E7c2ze8h4xISJ/ldI3ZadvSXPTSOgD0SkFeuzG17edhqMqD/ZkUy/xzxjSlp+6Bo+8KZS/Yds3ja3q9Sf1Xe5+cK1yY5Ss1vQfnKayEYBPJiPW4nRpAqKjLA3t+eIRx1cBoJQgZEconV7gOoVStJyoeuwTqxY2+ivQ4kZ0oOsEESmK5Fw1VQ/I62vs12g9y8EX3amFwIhQMJUsrKJvHuTJGfDluV7t/avCgkWAvtzQ5jXejqdB5qr6yHf7WChr6oQNx3dOI/9pi4QdQu22sJvJKxyLsxSR9JJGnBavhGAz0Nbk1vbpWCxmxP5i/tFIJuwGydaKPXOW1vTDQQvOldHvafZGj1i
 gMOVq3hG
 akiSEJglbSIbFYZi9zLfAzWDOSF/IrWYR+QAI9AR2MUmSX9630Y7jLi1hrgNw6Yc/7WlTCZ8448Rhx0jp5nQ4x4uk9dRilfzjxPwhN9jnZwCdusrSH0S5vhxr+YedhPyxrOlsy7+61zkwiCODrgfL9RTKtXfPP+tiUOytuSCibCV8QRMQRkE7DDIoUc5pp5F/4PMwxJ9Vp0E/bqIA1ylS2f//EMU+cvTV0N2ozCgV+BLLfbyIWV5qpV2r2WqI/SWajRNN+vJsaPaJF1cDBUV3IsRA/mAyhko6LnHcK52tNmmBWIzj7cODhtv6+ZC/WJqsdASzE8S4psIBuMQVeJzWn/d/vwNGq3Mu02Fa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 02:31:38PM +0100, Harry Yoo wrote:
> On Tue, Sep 15, 2026 at 05:39:44AM -0700, Breno Leitao wrote:
> > > Also, I wonder if some architectures have a scattered set of pfn
> > > ranges so that the span from the start pfn to the end pfn being much
> > > larger than the actual physical memory size.
> > >
> > > If so it might make more sense to have a bitmap for each pfn range.
> >
> > Agreed, having a ->next in linux_efi_poisoned_memory is a good idea that
> > we can lean on depending on whatever problem comes up down the road.
> >
> > Very good point — let's keep this linux_efi_poisoned_memory chain idea in
> > mind for whenever we need to expand it.
>
> You mean 1) keeping the structure as-is for now (and expand later with
> new EFI table version) or 2) adjusting the structure in the future
> revision of this patchset?

I'd say option (1): keep the structure as it is for now, and only adjust
it once/if we actually decide to implement the hot-add use case.

That's exactly why I added the "u32 version" field to
struct linux_efi_poisoned_memory, so, it can be expanded later.

Version 1 (this patchset) covers the common, basic approach. If down the
road someone sees value in extending it to other use cases (such as
hot-plug), we can bump it to v2 and add a ->next field then.

What do you think?

Thanks for the review,
--breno

