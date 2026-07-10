Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C00C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B716B0005; Fri, 10 Jul 2026 15:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BD36B0088; Fri, 10 Jul 2026 15:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B9F6B008A; Fri, 10 Jul 2026 15:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDB1C6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:13:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74E101A0539
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:13:05 +0000 (UTC)
X-FDA: 84973814730.09.41454AC
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id A5D5D40002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:13:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HsaAXqxX;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783710783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zl1BBUQ1SVF8WlDcAjuqmqY9e/JVxV3t5chHRhyKtnA=;
	b=szm3ExqwE3IlLuMZzQOWsouB2FUwU9AtjSPz4uWhyCgZYvt5s4YTTPX/2BBZAFRA7ZE5N7
	smvRsyXU1YdFflUvQm9V64bOagDrD+yI/rVoQWUuoKB6qBGOfxKMFG6iQx/7BVK9WtsULz
	psu5J8iKG65eHOu5h22DxhLFf/BJnB8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HsaAXqxX;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783710783;
	b=E7ix8Yg2LZNPFpme4v7V4/rNetN5WBLoCDW9OPi+dkuwKWK8G4q88QBAMGxxVEJQptzM/4
	/nje4YzRJzAD4z7EPC2z3GOyE2iCoLpr4F0CS0jgPaTQIi0MImytzyD0ZpjZGTnJ4broHP
	8LNoXQZVoACVU8N9Gt0MGJMkMDEyQDA=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ff5d1b0f91so7633816d6.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783710783; x=1784315583; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zl1BBUQ1SVF8WlDcAjuqmqY9e/JVxV3t5chHRhyKtnA=;
        b=HsaAXqxXKV/87YPM7bAk+5ijmXFBypfCiAKzblxsP/Dm4aXNFHQJDxor5yUiL9uu4Y
         NC6yikBU1IpMLcdIh433eqUB2a9Jcw0tzV8hPaJ5ZhAvbtp5XMltzBD/peUEUY5qy+Sv
         Iwl5yVnWbBycuRzL4D4g00PXTpTGNAobfrJryETxhTAXmv2O0cxrwc7pktJflTc30XGj
         g1Iu8Br+rgTwa71yfpd+s9Gcd2qhs/Jz4JRnJTfaYaXJ91qppI1QP9AgAg58IbdzRork
         7W2ij0+RZX5D+HckugvZONknYNnhr9OoR0D0OnOhXR+RfKTcaqzQDaClBDL7eXalD+iL
         2MbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783710783; x=1784315583;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zl1BBUQ1SVF8WlDcAjuqmqY9e/JVxV3t5chHRhyKtnA=;
        b=EQW6uFQjbfdwYAsxE4JUkjK8NGUiPOv6O9qRirjC4pMUb6cmLbxjIbYS1FJmD85oqK
         wHVW3SZ3xrWA2SFeJME9Qf1WJ6+adAuIdqxbk7i0NEtsb1K2IWRqHCKNROkXUHQ/PJB6
         3P0W/+X8skBjmtx7eYscWe/K1OIcyYnk5j6x875kLxMbBljEkgP8cpBBNaGP3XotDPFW
         pGcC3JY6KJRaCVCIBn8gjfb/XLgEM9DrR2a36VjMuEb0GgSSgL3wyGW7wGmMzygo/Pkj
         B0X2AnoLyldUeqpkqqLj2HeQnOa/mBruH8x2xl83mCj36Plih5NzBH70o1gKRYvE71Bu
         8+Cg==
X-Forwarded-Encrypted: i=1; AHgh+Rq3GNofdsZ2kkpX3fADyYJVjZC2H3W8SVVXGEF6Pwa1TnY6t5+CVz3lLn1n++S2EcR88IaccUW2cQ==@kvack.org
X-Gm-Message-State: AOJu0Yz36gVNeq3VoUSv9pGAEiFsAEzelbScUG2irYAyn5chAiJYoCCY
	72qWf4NbdGotARjZQpy19wtHPsE8g8BbaWJSWDsxOnRo5KBZgUr1TTL8KGwO8F62Ffs=
X-Gm-Gg: AfdE7cnSp9RTOQVhvWo0JAaSf/BJHk0a0RIAPBpU68Y6Yg2c4lsohC/hnDAKBToDD2a
	y1qlDe4nlr2o3RZlxXjr2aRXDZ1s6inmqvOR/7TW2zIyZG90soV8ZTvUNuBCyYjZP7hMeVGKjso
	o9bkxczr9XKZjrrOAFJJ/Rtmx4dQKY1Ipzzx5tTZyMeA7mZpaaydfx/N6wDpM59w11wwKkT9FP2
	UocZsk7+cB2rL83BUt/1zA81nE/h7FlL0HocvfEBBw+HBKgoVVqfHDCCkeAx7yFkuOe5RLz2Qy1
	0THgft1FfjzMhsFlXExfxs2/97ghRogqVE/9Ol9LAVf2cpy+gPNabo7u2Up8FHNQCJfALqYS3/Z
	5KLX/r38FzSFSuRZJACl5J414+TrjMSM79ZPmgG5nsWdoV0hpnu9PLzK20jZPD9U6Q/ARCjawUt
	dsnZqNw6lZw20c2vdaEWDbGKRrk1xsyOGcbEIkIe3DxKKfl9kvwX3vxIuNz63phUxuGhIG
X-Received: by 2002:a05:6214:450c:b0:8f0:9d9c:52c2 with SMTP id 6a1803df08f44-903fe450e5fmr5228126d6.5.1783710782628;
        Fri, 10 Jul 2026 12:13:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c9128sm47321526d6.45.2026.07.10.12.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:13:02 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:12:57 -0400
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
Subject: Re: [PATCH 25/30] mm/vma: update vmg_adjust_set_range() to offset
 pgoff instead
Message-ID: <alFEOTiJw2g--9F1@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <910f7b5be78232304dc7ca01cd57c6f5ca8f3d13.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910f7b5be78232304dc7ca01cd57c6f5ca8f3d13.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5D5D40002
X-Stat-Signature: by3nxzsm1mftdkoqqszxcceh8mf85oce
X-HE-Tag: 1783710783-459982
X-HE-Meta: U2FsdGVkX1+kimGaGxhWh51KRwR7p4WL4NkbMUEBv1QmSe1sJGDejL2/8dtuWYsaQoMptG6jizWyJyfFKvi9hhW5veu7tPuvG2xmADXFghQ1LOaq6LbircYOUOfew4L/CpK+N7w6432+iPR/DP2cQoOeLEVvYIj2DadyhjqxCoxYHF2D7MB/vTT8JDMrXoqdWMQeBffURHorMnPBq0QoeeYwco+Xzm5tUdixiZsD1o40Fsi6ePAvOwlCpsoLLTrZJqr5slLwT/CD+PHE3kW6VUvaxHzHHoM1JD0Ttvz65MDsnWv7OojPKQZf48rsAC0qJL82B1DBFgoGGdtWWLg1dG2GebLrW4s3wvCg/KyR9MwGQn+3WLbLbvHW9BwujKVkeOZAVxe877smOL5+xV+glY5sONuH9IbbqHpjlU1Z0qm9rAStpOwWQD/DQkRR8sET5XLqbGymwd1jHx8Tgh1ILYKFoXcZwoTiFdoDyduc8komH4Z9yuuTLMLq4z0rX9I9PAAo8feiu8VpcCCo/mspOVUTcxARyziaWDGJY5SXjcqyLQnEiWNH5SLAg72Zhx1SVWDm9XtvOHTO8nRh26rnzzaU/ZsLIUAFndq0Ojwz+6RPtSo6uui8ENzCJR0jALmnw3wOblRax3YBxlnVSp3fBz8XlyUbzxLisrgJAUtrdDmx/hdxqxn5+xodHsLUJH1ppI7bhl56pM0VnflfY4ksRLF7unY9G2NbisBszF3i39m9ORJfh0hF+SNEMOwY1ItDRuNknh6u0dEnOXoNFyi16FyYl1ALLNYwG/UaPh5VQBg9CLbWOW+E9CiFFmS7Jeix5aG6Enx0aVJt3mTvqolVoTOJffiHIuYklkONG5lqbW0MG8Dkk1bZB/GvulmbfNX2/4krTIKNiU2KbnorPNA5cM7x9veYdRit0cE57E4nkObmdMB+Kgx8olrclALMTMU41Bz/e4LVD2nEY11TsSq
 Z7UqRZUj
 ZC23Ylc68gcYox1LPVL7VMJ6qHrodWCEIMFqe7kJX+YXAXR9+0ClUuTkTDJXk0qnqDxUMoPQqVkREw8MnkQrx9enWE7+OjaEVIUYDFST7YdtTeweUevvimX2L/JzohR0u2iHkVSWFsiKhvtBPoXp1Kl2DsvjcNtlwofALWJsJmsETd+ujWDofCAao1ZnNwVq1ZkAgwk0Zux39pYauSIN+pY/7SOLEaJzvxFP8ScGh671G4UKmXS3uxW1hROAVUWQQPxYmuYuBMRiCeUP30fLWaQNHKTJnkaKZ/yaPmSRVGC5lGUkVB1oK7+2o2Rm9Xh3h1tkyhP+4BfI4ZZkX0owXc5Dqz+u1rZh+JdEmpJWq6QQQLlp5oebY+olscfevvOPE5dR3lvQSV5I8WpymeVOuCfRMJhACIr1Ln/R57vmoHYqo9hX5GnIVeuonoU4v48dnZVTsZUQyhJw9dGFhs/DOkMJ+6U4LmdP1/k9GP6hgBYm0/VTLgTMVFuud4gs0gGMrZ2ulzLqilKdiQpa1GdMXB0pTtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:36PM +0100, Lorenzo Stoakes wrote:
> We are calculating the pgoff as an offset, since we have vma_add_pgoff()
> and vma_sub_pgoff() available, just offset this value directly and use
> __vma_set_range() for vma->vm_[start, end] values.
> 
> We take care to update the range before offsetting the page offset, so the
> adjusted VMA's vm_start and vm_pgoff are mutually consistent at the point
> the page offset helpers operate - this matters once vma_set_pgoff() comes
> to assert invariants which relate the two.
> 

Given the prior code just did it in 3 lines of code with no special
dance, there's a presumption here that this is done in a critical
section and no external actor can see the inconsistent state?

(i.e. range is updated but offset is not)

Just think about this from a bisection/debugging standpoint.

> Doing so lays the foundation for future work which allows for use of
> virtual page offsets for MAP_PRIVATE-file backed mappings.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

