Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D31C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D758F6B0092; Thu,  9 Jul 2026 11:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C166B0093; Thu,  9 Jul 2026 11:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3BC26B0096; Thu,  9 Jul 2026 11:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99C4C6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:57:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A8B41A01F1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:57:18 +0000 (UTC)
X-FDA: 84969692556.30.DBC32EC
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 651E5A000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:57:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VjAFRoaM;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783612636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5BtG8ZZnILhla7gs7f63UlRSUpFIkMkPS04TXxov0k=;
	b=TiEFFmhmOhgaNWxDY65MUbulsOGqE3dafFsVp65PYIPzndcJQuzblo8MmwnXFTtvDD/eqC
	HYRb8T7g23NCAjk2XtNZUvO5q5MNRQ+0/w07ZNRf/GjO682QsYcYp/zoI9BmN57FtbTNAB
	gmkAWkn8n7kYpR4OhOrLX2r14nCbs/Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VjAFRoaM;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783612636;
	b=EhDYWgxyZfSNPf0shE2mwX6x6Mh67DRubN3t4K9V3WfDRoouIBlV2Kv2odhEyTbGmyPof/
	UT17gTGDmt3/uejIlLl3szM7pvtu6h7F4LlwvPRmPqBhBqssZdaPItqZcHyoqdzkAImAkn
	+TrHPU4qii5UHhUe7PCcrtKN2JgvQ+Y=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8eefd4a8057so1011886d6.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612635; x=1784217435; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T5BtG8ZZnILhla7gs7f63UlRSUpFIkMkPS04TXxov0k=;
        b=VjAFRoaM/7QdyUSnzR9k2MgbKNYAvNmy2FMuj0xhWP/sKDCtpnpbwZEA40/d6s6jvS
         k3Gwyi5/A0mdvEAik5N3PzuLpx0DDv/BUdAoX0fnCBU+yImCw1Gs8sPT76pQQxuFzT65
         Al5dB5oqVgMJ9MTe9c3cO6AwYcIRbYBkecDiHHBT3GzXmyH55D9MjZ1m0ThPDO1UdOe0
         D300yhCNugvwppIeGt/ndXazd3PbZkawcqPx0ZmKqtG941fXmeF0PSaqaCdklR5bCSBo
         zEtJQbFB0Z4c+xy/iSAlXDjYve7U0a7vXcPgYdEpyK44Xk2DcfI9n8gYC5b4oOK2h5bT
         RBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612635; x=1784217435;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T5BtG8ZZnILhla7gs7f63UlRSUpFIkMkPS04TXxov0k=;
        b=j5Yj0coVP7N9iyEQ/m7GwBP1yS+crV2+Yu5wyhgLMgcUyIyoW/4E8ja5BeZTorTApp
         JcurlmhGTSoZX6jh84LhXbBsqfOkPB4D4q8xYAxZhf2AiFTh+51iHAI15neLJPPh4f9r
         XXkyJV+Y+VM1X7iAD7bUKNCOzc55XQLUPezGb3W2oWIx6BJUyC7Nqqz/6HVO5/j0iqlj
         D4/ThIe4vuWDgBCfL4ejvB+uw4ftKGmomICjjqxkOgfqLhng4mTWHX5CLzs+PAnPPkEL
         HborA37ZRauJWQ4gempZQ3q8cQrleP6kI9LT0m2TN4iC56X3HjRam/8KQgrnul7GC2Jc
         OgJw==
X-Forwarded-Encrypted: i=1; AHgh+RoN5yZCIjPjM2qN+IKiW1JSlgMCBI3qKeT0JzQck7vwPjepMp2PSVXT8N/D0RO/wjPOrFuCfTXF6A==@kvack.org
X-Gm-Message-State: AOJu0YxY2Gwlzwwe/v9oIYUlIZoG3sW4uRDHdlmcaFMhNbBeNM8IqdJB
	p9MYDucyKWHsFGB3vbuoN+DgsiZj5clkAQN/CFiyEEebxs91dHXFCgX0Xd0FUQz9Llc=
X-Gm-Gg: AfdE7ck77KuVo4BO90/Q7YsiuBDf1tLA3TSQSH5py5w01OQyPUQ+IgAOYBzgckdq1dh
	n4V2cPaKrvAfjz2EPPvyJyGVIyS9ZtMPrComr5KU8FiOjfaF0jgNiSHxH0dRHEXJAmcc7Duu7aH
	Wz/dfWN5lypp7mp8HfYCDRfRiAsYG2ocftul4XsYyzqYMUdAIu9u7/d09jTHFvITbIdc/hrwKp+
	02m57HUmHSUIh9tIziZE4SJ28qfNYnVzN1l/Mk87yWOamPX+HsVk+ZZF2aCdsQyXU3fEmU2yLqH
	Uo7UzabXNO8fTjop6AXBJYqW5kOb+jAUAgZuf92yWNAWO5Pd8RQMfbkf8VvNdHU/2XIPN5RHoiH
	NpgDAz0sKAO2cmV4NH9A2O9UPW09MEB48BwhCAl0fVx3X1RYwtUUrlAsHw6F2ZB5lH1kHGeUka8
	p24WqPMHcpqaFp7eYUkIgA33vtWMZjYOSZHRQkFnzuEdGTCmzi4AKq1qqaNMY5equnSSZwNWieY
	uyNq3g=
X-Received: by 2002:a05:6214:2aa6:b0:8f3:e0ce:6119 with SMTP id 6a1803df08f44-8fec0ead52amr91789316d6.21.1783612635560;
        Thu, 09 Jul 2026 08:57:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd86d43e2sm20317526d6.43.2026.07.09.08.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:57:15 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:57:09 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 19/30] mm: use linear_page_[index, delta]() consistently
Message-ID: <ak_E1Y-D2Twykusr@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
 <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 651E5A000D
X-Stat-Signature: isb96rbtb4f8s3utsxgtexq9nnygpf4i
X-HE-Tag: 1783612636-893258
X-HE-Meta: U2FsdGVkX1+ea55FyjpMS3igAbF6ipPrnqnZcoWgWmbYfJKJ3MErPYaswETjga8EM2bwe7NPzbZZ97NPKo42IWXnttXiAMsGDrfHXF/9JQuO+FMWd6BO0TmUejEJKLgsuQ7HflD5ClzBeSS+xRQACU9YRDQ8O9EB4tDHK8+1+FrkclJzc0haB7rcpe6KZw2pdf6BpOtigJ6xCQKaa7AkR/hUEd7f8b0c/uilJgQqtq9OInII1BEuGpwZVeg2sPxzT/y5KYPRYASMYc/0nKe3DT9iqJOTz6XH2Z+LzJl93EpCqZkbCNOzZLMN/7g7KE5OqSV9b4v1jdKB+TWuIKZWl/xJ62Gs7QCyzbfpsMTwE/Z5FU1PK/nvFF33yeT9y7D+unQcSASxuFaQEQHGYGaNW7ECri9tEVNHMlP1iMwgOoFYdkdpnWMCDsk5B+wKUdNKViVkBNe7G6R4lAUgboemUyyO5xMPiHksCA4yy3FtKiyvnUl8l9tE9w018f4tkbv/cOtvD5ntwr8Ssoxnw+2l5w9my/hF1HyW6lNWtJNbDjqqlYmGX9baYJG8LVzcB3k/UcqlXbTrP8dlsBuGAc5+AlaFJ3aNIYaWKR8VQGi0hiawJEeYbqqkXYUy8EfQ/u6zttJMXsdW5+zJT9bAL7MlRuiwz1YK3dRKkkPc3a6C+TClzj6sllsuIrl4OsTsmNioaZQquaQp2iBMNurW9wTHvUm7jtNhc7Gyo0v6fHUtq3wCX2lTzKahUSrPZqkOkIqZ22D03idJlXg7R6sDGdUGL43LoBGSWrhfG7G1c83EEpLk0dxB8FFsg1gknmcMyRTv1y8Qdui90dgHQFM3nGSi222HCmsp2fZLbCjHZleXOrhVDOz0OgvStIlcLVZucQ6QredCPTmZ3nQVVCd/eRLDua8OK804qphUznIPZBaDctMTxq+C8njwcOkr2zl9s8bEtZ6xGGRYbKdcOeQO7hE
 pwAT+F+/
 eKcBR6FOs5Z0qFpTnp2OLRPXrdg1olWoNxY/ly7B1c9fmByBT3fI1Ud+9dGLjD0V7ny001kRnlC/sBxRaCeHDunEbG+kW9BWsYBWdojuy3j+90yvBwqNBXa0nFXlptCbGpU1LgWxx/y1xbUh3iKtQyzM79v2v5q60vADmp+Y3oc0MQgkK+N8rWlq0Lu7lek2MAxsls9XoeAUXW48b8DI5/zFGP2Jt0M93fPayhGWLduJixYdt9dDiX1uIn1mLSJ9hkavvVP//Ou4wnO1klB6QJJ8PyWL13+oZTxN7uFwspRGryr0BiH7H/SbXl7Rt0ZeHebka8jZauWUu7iG9OxRN69aCpD6J/UwpTjSXgTmZg+lPAm87jPSCUELrUHoQpygihbYgyyyMlnpTpozdrCuLERzHZVqyVXd+u3OH3JOeUlJ8QjebjhhCIznrvzBnU97aNKjy6MfsWISxFLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 11:55:54AM -0400, Gregory Price wrote:
> > @@ -2462,7 +2463,7 @@ static int comedi_vm_access(struct vm_area_struct *vma, unsigned long addr,
> >  {
> >  	struct comedi_buf_map *bm = vma->vm_private_data;
> >  	unsigned long offset =
> > -	    addr - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> > +	    addr - vma->vm_start + (vma_start_pgoff(vma) << PAGE_SHIFT);
> >  
> 
> Obviously correct, but was this intended for a different patch?
> 
> ~Gregory

bleh already caught, sorry for the noise :]

