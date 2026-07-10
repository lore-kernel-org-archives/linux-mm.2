Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC16C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4EF6B00DC; Fri, 10 Jul 2026 17:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E896B00DE; Fri, 10 Jul 2026 17:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412DF6B00E0; Fri, 10 Jul 2026 17:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E65A06B00DC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:39:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55048A058E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:39:30 +0000 (UTC)
X-FDA: 84974183700.26.9494231
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84D56180006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:39:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uUC+LR+A;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783719568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wb1LcvJKID9cCXN+ue8juptbLrwaSleub1+yDxtfpnU=;
	b=qHktOLM1LkQLTXzeva7922ZvTAUavg8TXWkRD/ucLl6fhcnmzhI+MDFUqWuseVzwiT220P
	pNkKfPzEkrQ2QDmrttXx0abMVYv/DGXj6EF0+sC2Qo/fvneyAW7lQmtOkwe+ZnG7FdR2Va
	8SOy1KZq9QbRWdOa5kJVjk1f4FjoUQ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uUC+LR+A;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783719568;
	b=bLhH2U5Y0YL6GEdSd47G4trVaxerowxXMdidcx8OWYgc0jCcZqSJHhBZkxOccXyi9gRPGp
	/oDEEOUNjm5jCx8zOXOh1Dto9fErKRrj80E1yUTzqSWFcTjh5RmRbnV8TmRLs11gmo22Rb
	MCgPeq6oQY39QZNJ3BbDA32LTuxut6c=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ff20870ac7so10344246d6.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783719568; x=1784324368; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wb1LcvJKID9cCXN+ue8juptbLrwaSleub1+yDxtfpnU=;
        b=uUC+LR+AZp6RoDSIErrYi3No9lQyjy8VTLhCr9ctqraGLo5lE+nwGWYZ8LjQkpkkWO
         eK7748krB2DVnUJew4eF2UsX1p5E4N7RJ8tl0iDuh8yJqYYEVvlcIBRGxVjaLFjlvOG6
         u3BD8FKuAOM+btU6YJF4eRz9+tOINQuHuVj0dUKvUm3GVrm+DgtkuVSr4gxnsoTqidHn
         HNyeEuMxp07pce8G6T6Ird+0LPZf00IOAyWN+YK6D90gudaWdSlrGkLkqNj2mfiEq4AF
         UzdXAuJGK0ziz04zVrWaKIwJtrTN8CE/aw1TvEn47fxbDSNb5LbBAJf2cMhDleADOKZW
         rNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783719568; x=1784324368;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wb1LcvJKID9cCXN+ue8juptbLrwaSleub1+yDxtfpnU=;
        b=byUw4FIHdypRiDvBLqw9zwAxnCBqgBhf/2id9GJtH6LmVxJOVF7lPgvXRJp4B9NS9R
         P3Mb7RIV1MuSO+O/k0p5+KTupMo0R6+V8R7xFEXje7ClPRs/F78rCD6QtjHvFMl5e04Y
         +uB39qes163DDilvH6dCFCc9Kdu6JjfTutqLKJ3aa7LclyGyRM82UpXxBPk5OlxMk/BX
         Fi7uDz8Xqt3DN6IELGp1YDu7TMfDn0AbmGg1zkBdRGBiWns4JUh8OkB/cTuCD3tlZA13
         oscrCUBNXpMv/fpP2g38aQTfC9VvRd4bPnIHFmk6m+UIHw+zHgH19gZvjvA5V1P83wgQ
         E3rg==
X-Forwarded-Encrypted: i=1; AHgh+RpKMVl8uR+ZR+3PfJFeio5BoHkbNh1KW0gvl7ZSMkN+BFsE/tw0G/YB9hPtnrRXr7yrTlFtqHXaSg==@kvack.org
X-Gm-Message-State: AOJu0YwenSs3Pa8yFhRx9cNDuYfUEHDopuiTYbH3NH0CW2dN19AklJ1e
	jvRsWTskayVpuwq02fDTM1e4cQRSILiH5WqEAl81OvJ2ZUpJuYqPAISj1weQvP/Sn1o=
X-Gm-Gg: AfdE7cm1zxDWoKMngZytFhL0ulFdW7T60sMlUHvSngYSqh9VFRtUjCvtk6Am3HEBKya
	11+j4sqbhGFsKBtTZfFRbXj7n0ANR37e9cXGRqrakIxQm2O1X2pcWnwnAyZxBugnMyzmvc4U4Kj
	tpPalTrQ+uq0mQckE/fFrExD0tLBgwB6kGRHxyLAs+UiVlYl1/9NYkW0h2II9EjZHlTg3jZTlRK
	vy7AIjl2eowbGQAun+eLif6IokC2rdaU2GIReOyhmeFT/YOhsExnYSdnjarCZJHc1h3/VKVmAre
	AW+4Io0qLq0opwkGynEAAKPKTHn30xgC820CTZBl1vGdN+m2FWQYzCGPnWkB35XO1oKjgwlN6cz
	m6lW4ezMXfCvNtbfAgqNNkffBS8h8+l0m7U4YdKC4ygvSKat+oUPWGuX5W7sCEvMO7izP1m+vyL
	NQauRkjgoCTrLLjzLAdHgUuVH3YmjwHFVG8mw5jg4lL42f23pLcyEKluTDLkcpaEpsbXPK
X-Received: by 2002:a05:6214:5904:b0:8ce:9cbd:b0ce with SMTP id 6a1803df08f44-90400c8fae9mr11445886d6.34.1783719567574;
        Fri, 10 Jul 2026 14:39:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e081dsm50984276d6.9.2026.07.10.14.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:39:25 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:39:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>, Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 28/33] mm/vma: slightly rework the anonymous check in
 __mmap_new_vma()
Message-ID: <alFmh0sm1are2VIq@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-28-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-28-2a5aa403d977@kernel.org>
X-Stat-Signature: 7an6jgbhpkdk9odtr3atiqasaamj9bwh
X-Rspamd-Queue-Id: 84D56180006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783719568-113279
X-HE-Meta: U2FsdGVkX18T7QgA9lROvN2GtyoJa4rFDsabQoivsSXEwb1QLaiwerfQJxmJeDFhFNbAL2Os8maTSQtoKR01vvQF0BzIG2mhvL5FV7rLlPLDaVbcmnZHxZKrL9vRylH/tfC9PEr4szQmRD2DpOkQ8ixhRYaEcFsICkhmFwe7xmh0+KKWwNUCXQrNELcBj938sTbd8XfDFW2eRB5FBe6lpMWbjQtjMNoSxT/RD0UZGKtjEI2eRwMXw7C6r3u5TCpk7LhPeLRu4a01KYRbbjq0VhamNxa8VGgtOBGZV0I6xao3cObhmBuHkWVJTExjPt6i+HTInVsk0KcPEJ48eipcMlZAAKsw9mL3wqZigJ6TsE5cFyXHlZ55TtRKiqzgBof8w6yiGnM2jSrxyHYmh4aCEcgWu3uSJzJj76qAwy9Z/5wwpZLU/3MDojHIYXtu324E0V58mI8+D2NhEu48IOzpg66zSG41tMfz6U+kyVQ5540VJMsLnof4X4dDGgdiERSfTlgFPPISAPb9zBT0MMRAdufBBRb70SBWfjZ+K8yrdIxQY0fOHK2b4nEeuOYTTgwym0tg0mzbe1dsK2TrR5YlKk1/TRGp0n+gAF6J5GLfD2DBjdfcDMQCFVplz4fefpa/d2Fzc56SWxf5OaRnExILgOeivdmr8T7SoeGAx4npIniMgu+kuCc3BccN2H3P+Z1mv6jPFjz2twheVh5BBZadw59RcGBcj89FPpso3ZHm8SNMyTcjtF0JX4CLdh3ua0vk4JBAPzrIp/xr0+QruXh1ku3AaVMlGCxn8SzdSqc5yw+zTdlX/IC8A7hdgKJzgjl5bqN9oK5aSL0AS1Q4wjKugjgT858ne/jvbUNg6O3p5liiEBDvQ10cb4lEOcxKbaWSanTKqQMtG8t9XCwpY5ypGqrc6+UJe6gUlG4feNMXMg96wkihBkVkyW9g+Cauid/KqQbWkgMRKnOi/El3k1m
 4eLHWv1k
 cQlS2dlXbOw0BYuo1aOY7w3jELmWAU/z5yB+rgrxqKZNV+iW5lN1aWk85u2vTR+jLSrh2oGLd/o9VWkQ1ridkxAATDMRxwlktNnyjxJX+izIyYwTfkz/Bsd12O+x3XvV2ChrOeMeToIYFFpb9BY16Fuu5GrmnlyN5h/u9Vg4elaKMWBH7/aNnQxtnO5VzN2xGewfeHvHBj/+HfKVjofqefNwHXgQEMcUzZtEYpNtC8/T97tGBZE3/Exph/zoOZVBdQBLcd40q3bZU4ayqAVkjFnQxjzGeI1DqpL1C13RpptPPh3GQ1+trkZvv30t5lCHW2Hj67Wsv4trZA3zbki78k61FiH+pe8LDeVhY8KuL4wY/A4tAaJzx6uIo/sTXMdbirDFdE3Hm86pZsc3ByTYts5ZvqL0grITfb/COo6CAKlKnaG2asHuexE37PuVOQuFY2HkMARaeOf7omAWpnvAL6B12FkXvEX5mh+FEDFuYgmDHj60Euu74SHv48uw0OcId1Tcl+JMbzOnP4X0wXCbJmnBNs2jLprGFq0xdOGAp7ORf5yZ8qRWgeuVEQs4LeMsg04bl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:17:09PM +0100, Lorenzo Stoakes wrote:
> Determine if the VMA is anonymous early on, so we separate the logic which
> invokes callbacks from the rest of the logic.
> 
> This is in order that a subsequent commit which asserts correct virtual
> page offset for anonymous mappings correctly asserts this for new anonymous
> mappings.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


