Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 099F1C44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 06:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25CB6B0005; Sat, 11 Jul 2026 02:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6BD6B0088; Sat, 11 Jul 2026 02:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC456B008A; Sat, 11 Jul 2026 02:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79C916B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:22:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CDD361C3CA0
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:22:10 +0000 (UTC)
X-FDA: 84975500820.10.0C4C7AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 454A6C0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:22:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=coo0niBU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783750929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbIgITf+aHGNMFdZM2hnYV5tmAqGANAREaGRZ4MOOuY=;
	b=w46ES8wm4gBVB88yPY2Zmq9vuvZ2yVKDof9pe9vNweopr/BQbp+DIsGsJBh1+vc0cN9Rvt
	xAxFf6jGDAqokm4UbrpzLlijCsx4wuKtefqK59zPaoguFlfeLR8uPsh/zrOssoQZo04IWC
	sLfC3OKyTUows6FdtffbQ/3dmiRd0bA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=coo0niBU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783750929;
	b=m0WW8ZzVuO8lSZEXO7Klxp+GOHvvyYaPQT4sOpgei2P8GfZgmRzx7vjkw572zD1vp3GVOD
	cX+U4T+Xvkz06/qDEWbtTkbMQjifipx5CTp3C3fedSehAdsOJfEvd9P4hl6PbJK9eca/Hs
	//PuDRQygvTF9LVt3Gwa0wDmF1077bA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96469600C3;
	Sat, 11 Jul 2026 06:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88FC1F00A3A;
	Sat, 11 Jul 2026 06:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783750928;
	bh=WbIgITf+aHGNMFdZM2hnYV5tmAqGANAREaGRZ4MOOuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=coo0niBUkp/gUkbRSatT5EJ6NfiQ7ezfzQNFFEka9gd//4UjxtBzc7RBi4OLd8CJp
	 zhITxjhwTqPhMy21VbSNO5jlWP62czybhR05pJZTJTb3iv0IdJ+TlpfkpIyIm/4CeK
	 +n6PGnXcW/v4qnadjp5ztDaRzxkkltVfID9+KdWba4BSS6I4vpCR+8z1NGu7pVTOYK
	 3SWYJRt3520w13mZ0szu/3x63YnNWVCUI7AtJTClfOv5gpw/pdE0wkv/FwletvuCgz
	 VSb31m3ojblPokIyzlMhDyaw755+CWsZBp7wZoYS2xjQCz/QLSkvrDwTE0v7OEpi+A
	 fef8MnSSiqRUg==
Date: Sat, 11 Jul 2026 07:21:43 +0100
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <alHgvYH3F9FkObri@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
 <alFJUfaGHVnKd-Nb@lucifer>
 <alFePgFUR52GgBS7@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFePgFUR52GgBS7@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 454A6C0004
X-Stat-Signature: i35oxqdxb8hqe6bqtsa9da1q5ee8afzs
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783750929-88859
X-HE-Meta: U2FsdGVkX1/JBXWIkONl6RvO5vkftWh6ZOrCJJ+fd20Nrj96AXlzoIHJaNLyJyuxsVCpDZhRkPxUCm7373VV/f2FtjSX6+erxMcCvlDlxlxIoJlq2Moo0FwHS+eUn0ChQgiiZ/Bt+7jEceXEPoAji4xljzTcWK8dHEXlyaE4vxKoggx2MmkneMyX2TfDUi0GZOt7OLBckFiikJynt4ehWKCpvcrWHCaA5obwOeIlxSWWeHWZ0IQ/J2/ZT9pKFfG/JLtIsDyuVbN51E1lJf3VD4XnCCxdL9+4O7OksBzqhrX9FHKfzgMdHWokSevfq6sUMF7VLy6WW8pIvTxpV30Oq+PyAswOmGJWeyIghrhxC/UepCxa7r/g8orMN1ZWFPU4MvfP+YkAtFPWR507iLVFnUNse2hYkT3IVLD2+FgUSDc/Goa8OpwxggvwWhhU0nT3cxsHqRHVo5iR/U9Gh4b2NqDnKqIeXJS+uGpn8sKnizFUmkGZ3U6F2gMhESwu7E1GVwrPYcVxzMYmS3u1nyQCDTrXJII6VSz8m4YnNye9FnWR40xiIUFgD4Mlht+FkxoeL7uSi/EGH2QILBvg0eVcNUU2mpiTxmVB1BBZxV6Fd9dTXKjs63y7Als2v9ILHWmFr18TSg5Sqof3rrIpOBsAn31dvLI7KMpDwQjqXansIfDAHVFsJyaToTWh2urXwO0Q/t+3NAoKQ70+4fiCwQixArzw/8bzpdnivNS5X7xvVGsWiTmzXbCbJpMWV6xsZ8c3Tju4HgNTRdU7EDMiF/UkTNfET1EodTbp/e4dCX2V6hbykTD9ssiwV8ea9ziCPYIDnurQzOxPvCQjvffGQPLng234gqeBkM+J509SPllvXeiF6AOtgYRpEN2pkXp5ctRa9usO6jIMpRF4/bsAFzrkaC1cWeDN/HzAAKbzHhJe87bbpjtgzN7FpN+MESpmWSx7LhdKjoT/b1GzBnJ/Cyh
 hZk0hrWp
 9zRuoXkgzb+hcgtF8pTtnJrggfYf4f080bpwOlmmmq0dBGNq4crLp+LfYiLShcyfea8jTqK2kX1qTtlggcWnwN3vM9/renYgAIBqnu+9gq63Gn7F9Gdwc30qg3Uf902aTYq8zyXdl3RwIK6BAq06ZRwPIP0HIR4sWP8ItxubFEJFYSyDmCUpdmIXXYYtD6ULzeblXTHa1o2++XtUiR5aidxfPbJaPErK641rSa0vVQu3ICwmRXYr1pd+ls5nb9hCQbXBJoLD3WCMU3j+1AAXuonISxjl1crYbCEE5zvIfwLx7PMf/rK5AtP+NKmpwgbr5Fg9hk0t+LTaSw0kuz/o2l/xWgGbPmlI2Fdv2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 05:03:58PM -0400, Gregory Price wrote:
> On Fri, Jul 10, 2026 at 08:35:43PM +0100, Lorenzo Stoakes wrote:
> > >
> > > Do you actually need 3 copies of this comment or just one copy in
> > > vma_internal.h?
> >
> > I'd rather have it at a glance, it's a bit silly but C headers are silly :P
> >
> > BTW you're kinda racing against time here as I'm on the verge of sending v2
> > :P
>
> :[ i don't refresh my inbox when i get hyperfocused and now i am sad

Oh no! But that hyperfocus sounds familiar ;)

Apologies for that, I did hold off some hours. But you can at least see that I
did all you asked in v1 :)

Cheers, Lorenzo

