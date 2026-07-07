Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C43EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECCF6B009F; Tue,  7 Jul 2026 12:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4736B00A0; Tue,  7 Jul 2026 12:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDAEC6B00A1; Tue,  7 Jul 2026 12:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD62F6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:26:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AA9114045F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:26:54 +0000 (UTC)
X-FDA: 84962509548.02.8112BFE
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4A55D1C0008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:26:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cuIScwCM;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783441612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pPJvCom7n6xLJkZnxYC/ipfbqNHo6N+N3CeZviAw0k=;
	b=a9z4mylFQXb/T8aQQYJsz42fZ+gFJsFUX0QD12+fkS/OCDofAAWvTDJJESvpb/AeH5pOrB
	G+Ef6G1tAqHzihGqbjVRwHlS9n2xuOfh/ZMWxPFfSKiPYAzz4RB1V9Dmv88pXRVap+kYpz
	AKlfwRjIFVAEmChqQerfFwfBZXlwJ0s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cuIScwCM;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783441612;
	b=3tHnKuhwuNbQJVUWgn08w2Z4jCIxXxU9H9pKFd55VWL/xJVv+Du+Dvx3OCEEUUbmIR1Tu8
	x5lFoW+TxbY9zOrPYtSRirfE3KbaAfkXa7VOXjHvNycAsoT/BzcEPLlw0B3TVJLK0Tzl3v
	DMsyxA7ao6nZvOfv3bYIEgW3hviPvp0=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e5c9211d2so350003985a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783441611; x=1784046411; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3pPJvCom7n6xLJkZnxYC/ipfbqNHo6N+N3CeZviAw0k=;
        b=cuIScwCMjD/VzioOWzuus7DpEIOKf01fxGGQQrmuXQCeo2GRWFqatGETvlf4LO8qS3
         HtcK8yf54hzPMbQRgBaix1gLdZZniU28bR5YOGTuhk6eesaJuWOey2VY86JLLsz6qDJO
         qbXiljK5HoYwJ29ngd5STNWPBd3mHwZImeuaYazPcH/zKbHKtrlklsOMvNOcYhPv8sn4
         aLO+2AkdYmw3zdJOsqzYNKzxIkPRrlXq+mQMtauS7sWcWI4KpmoRZV8p8BFSH77fNBaJ
         q8qIT9HYl2BUuq45CCh9aYHhOfFvI9/zi1tCUJIS4t2mwqe1854bnsJn2BU3+pyZ/ZDj
         n/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783441611; x=1784046411;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3pPJvCom7n6xLJkZnxYC/ipfbqNHo6N+N3CeZviAw0k=;
        b=nbMVIHRp7c57OTKhY+XyyqW68Ratuy0u/naUXPiu1fT8M3A91YBT8s1d8hCFWyIUM6
         dNTjvQyE4oNOXJyjFAiDOKAEIMI7l9PqBgVta46+pgk2TrQ3cmzfpTxbP/g/8WLASZeY
         xHwd9oDWwXe5SgQcsjObh0r4AzgTUoNPA2IlKAot1o1/bS7BHpxhjWrPppZ4KDwQQUub
         CvhBam6zxbaIEaDyI/VTvitKBY86fHvu3WegWXY7eAkMCRl69xx02saut8vjffkCvQM2
         eR0t57gYRfq2RPVGhHjXKvCY/QFgHC9Dt4wzl2FPSAJp0QCTCQPPkzYKY2U0NU/uzN/a
         yjsw==
X-Forwarded-Encrypted: i=1; AHgh+RpZOq5tt99S+N482/jf0yTgNB8DTztxNXzJz1c+vv/hrtl+WN49IKIQ2IhT/SQAyex+aBzBr+PieQ==@kvack.org
X-Gm-Message-State: AOJu0Yyiuh2V9L6aw1XhwivmIFO99gCisRk1rLhwP5MflQB5kqisOc1X
	Jarz+FtTfPXgcK3eH46giQAXqHCq36MhSCNPZaCNzMDdEIP6NWtsu43iPlsJh/rBsfE=
X-Gm-Gg: AfdE7ck89uPX16n4QMZOFSYxUhRlaR8hMRQGZLhBOC07D4rnGFk7P+gL55AerstCVgd
	KH0Fx+tXjPpsshOhqf/W4bk52AC1s790AIxF2QHWdqrWDFr1qDZnp0kZ7nBfH7weIuU46GXUA0d
	rQUYM26JhNHaaVfgh6JH+jk9HEJUdvTfpBUk84WRVGXwRZQlQbTtaZ9avVfmnS8Zj2FsB5g4Wos
	qEiQk6mTYwhMuugtjJuZgdZhPTcD1reN3w3YAN89uSM2JOxf8xF3FQkxdunuo0RFF6oBd3zjSfH
	knVGbi2IPpfInGR3foMdN4IgtWowZ11KReTxwMtJjr98CplIorNq7TmtqwuFUEj3gqCrcSHia3I
	x45vuG+YZWeXpfyKGzfTuE2efx7jxk0XO9UPufx5evc3fdwHTXqvvSGBPig3f0pChl6eq1ybnq+
	uLc+9TbRNOUUhGE+WAFnYC6l7mInJlDBycYeOhZmizxJIKv3zImhqHViBUKsKXWDvIYc93B7F6L
	VosUZE=
X-Received: by 2002:a05:620a:a807:b0:92e:c118:18b9 with SMTP id af79cd13be357-92ec1181fa1mr324497185a.88.1783441610850;
        Tue, 07 Jul 2026 09:26:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90ba41fesm1231337385a.17.2026.07.07.09.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:26:49 -0700 (PDT)
Date: Tue, 7 Jul 2026 12:26:43 -0400
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
Subject: Re: [PATCH 12/30] mm/vma: clean up anon_vma_compatible()
Message-ID: <ak0owyNkHX6mw4pe@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A55D1C0008
X-Stat-Signature: cxu74fwt45ib3kho8a4urcydswp7b7h5
X-HE-Tag: 1783441612-369558
X-HE-Meta: U2FsdGVkX1+y17sQMMypL814QYQmQgoRSXzY06ww89IF+4TAk67JaVwaE+YOETmPtOKjxLuOm0gC1nul24VA5TohgsQ2Dsf1wWRdXuzduG9iLU6pgXyaLMH1dJXCSJ7Z835BAR0s7iNExveF1xqBL+DV99BXKqThje51vQdA2BzQ534QJDRu0oSGSRdA3P5ywRnlRoE1hENr786id/8IbQqObqoFAoB1IZ89+9cwMeAHVfZt4YEMBJLhkWE2jfCNTEyiT936YYwzwz8OcxtAohWro0NAKxvflYusquifH8Qd8S3KGyzOVYDnd2qG+TnHP5pmdMUAaYA26W1cSz4meICTjjit5hdJtIdZ/eTc3ko5S0XTXe31ACM8FIIr/hvy9kIWioURWITthqVbePGj9UrUR7NRGQA5u83GHDWlNI4+wodE6GrzWDl6sCQHvYzIYcrwzSQperKAed/qyrrDvOcFCVPW3f4z4hq7Uklwp+TDBk2vUfUtAq0oR6BrVFaV4cJYcHHuQRFhwWjNu/1BIcKeh6RUxS6m48/nfLLQUYQvp0IiQ3+Y+TduqINux1aHMMEA41/fRn6+CxyFzgcdMZYlfgTmi/HjpeNW37CO4ZLb8QaqvADbsW77yQYe8uRx/uUgik3ZryAFlohvuSxL/pZG2CE4yj9Vwg6eKY8/ayVcdW34sxVSUtU4Mj3V+TfrUA4L6BCFpB13/k6mcIf1UC5BYSJCLPRMIQNNCj6OUEye6iXc11MFcW04zJmM3fVq+4PutDrNEXoNgObsbmHVM+gaZ+7jOnSMYjseBXeASnkwLcP6OM/DaDJng1OpSQ02utPSC9BndrrCivutumTWOIzOhu0k9/3hCfyiMn7W4lKmoxXbaOnrutXSafE9J74A+30C54L7YhSrVQ1yBv6co2fwOVYLSHjjObo1WazNS6I+3XLDlFJPJES3Z0FSLaZeUaKXvDXxov/x7cT8taA
 9AHso0x7
 GUCbM2BJO4euJXW5W2+6abGVgJRFcxnh9orW+T1BKjDtqIQox0usSwsUtiEC/U14K4j6nEjZdE/aIcKeNj6cXwt0WeGNLnKg8Fh9vsqCYV4Afcl11x/ggSkELyyhmDR+6//7fdKBRlxBRT/uBLeVzyiRTGO65wBfDMd6/3lkJBvBrjkk/lYmbjz/Zk2Hx5mQ3NMe7++Qrg2csPwS6YWZ3nSb9vQ2UFK/UTe5cn6urRz2+psZgcwqmwpNvHk1PjU2mnrrMx/k4KhfKk4FMIaaBxPA6lX95FH9BUNtcK9V3qdrOQGN2e2MRc6geIJsyZB3HO8JOdGY2bpLXviv3OA+PC0XayRxsbPSJWXaQDkuo85Jj3VZEgzxxV4yTIcWyISOvpkh7qUcXJPUyR0iE6w77CNkOp80zxohg8Gx2XAS+RbEEyucztDyK8bfGYiKsX6kwptYsX9I0HVZ8JPwbVAadHlVuRgAHKxRZn1mOpNvmKMtmsXT6BX1HylcbXj3H/m+CDy1HaxGuVZXIOZ2wSVVl+Lf/gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:23PM +0100, Lorenzo Stoakes wrote:
> Break up the existing very large conditional, add comments and use
> vma_[start/end]_pgoff() to make clearer what we're doing here.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

