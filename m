Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779ADC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505016B0088; Fri, 10 Jul 2026 17:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5C76B008A; Fri, 10 Jul 2026 17:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3576F6B00B2; Fri, 10 Jul 2026 17:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F15AE6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:10:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EC7CC3C6E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:10:03 +0000 (UTC)
X-FDA: 84974109486.04.20CF2D4
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91D3BC0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:10:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="CZF/Ndfk";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783717801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FM5wmgcpnXqQ2LPOtHbLfNIfX5IHSF2YMfcySjsQd8k=;
	b=zVZ7DmbVc7r0huvVBiDtw7WffHRJVn6IUYJyH5umxwPsVrM2VQa8FUVp4hIXKpqjAgOxAX
	gQkcmADtosYYn+vX3ep5AC+5R56QhEv1CdTWq0oY3lHuSbU1SD649LE03tiBQa514rRQo+
	pWmbYldBKdO1cm3bzivpfUPx19OOtgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783717801;
	b=vKpkWSkQswVQETWW3VlS0mumt0uuBRWBvyL5ffd6CLAHOdl6D5dt9FfjHoiE+Q0QhuPQ/8
	nHs2c7+CPwz5qKJ7Ag4JMM1WF7Fs7RMw3bzpey4ekAirAtmY69jSH5MBMNRbQfCfXi52Nl
	bSw9yeTx/TWsomISP0mSjCb1bSNuju8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="CZF/Ndfk";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8efec2c28f8so10841276d6.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783717801; x=1784322601; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FM5wmgcpnXqQ2LPOtHbLfNIfX5IHSF2YMfcySjsQd8k=;
        b=CZF/NdfkqxU0mHAok79bxOjidy9ivjLn4bGTyjjp+Ng2OWDvN1ghm1rJkh5Aljg/hT
         rgZUk6wxejOwO4Pf/jW/V4sQCOYjVikFyL+VhzaKFfMNw/BbFMniqPVnnyWSGqtQIMoU
         6vQWLtjk/3ypnWVhbfVTnduHjFubpvZSHkenoHlbW5tJo7ff44R0TOBhdtgrqVeGc6fV
         13ALurIW448IwATmSoSm6P2pOo2M8QxJk8TipFflqbIoqhiy0HLRiQTo/TlIBKT5DZmC
         cDvQNOx9jf9j6//GRIUvHgIUOndb6E9ePycTsUSpa73sXsRLID0ZqyuyLoNRy8ik9T6u
         okLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783717801; x=1784322601;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FM5wmgcpnXqQ2LPOtHbLfNIfX5IHSF2YMfcySjsQd8k=;
        b=JkRs6nWdOxdLlMgCjeinUMh/cfny7kgVN/CrhxVp0gHmacGWDXp8soueusJngtT+xI
         Y2gSgUG0SwnGhRuID0EopPimr32NO85p3oW/7nW4OUmDhkIxwBJji8toRMzMOlSEXq40
         VbXsLo83dEm0EcbsZF5kOmgrSYBlfbuKi2BGemJcLLV4r4wjw7qdxml5uQMfg5rOfLYv
         H6Vbgtc36DR/xksyj0nP+2PIEYdkhLjU0Ry720ayp4ohlB5VzRFCrFLsiuleb317gVIe
         14HB+udr7pMGiP806b5RM8snc5UtZYnQJqzEfA8kg8/fYCK7GZbHHsiNtgreNOxdU5vR
         6D9w==
X-Forwarded-Encrypted: i=1; AHgh+Rq3aY5hUzzHGgPfFfGezw5grpqBD2JlcJbVPJBI/q4sY03b+jSXqAqu8KrEXOQJfCOjbbj41y0S+w==@kvack.org
X-Gm-Message-State: AOJu0Yy+8WfPsVG655JBfsVa00xhcqlGjWXhM7LSqZOD3fGlJtoI141G
	lu2V5uYP3AVjgmTdmm9WK7tcfhMWV7d+8OSxkHTIyIYf5ududeVXN1Q1MTn/FER1bcQ=
X-Gm-Gg: AfdE7cm6xWlckpY9BgqC1AxaRDxA3TIWnxA5rG3hsJ1wRJBstExFMnL9UBbv5S+HYa5
	GGJiS1H+vdTp2XEibZybm64ulBEkFdlZhcTQGyIqAN5+4Xb2jmqIiVGYCL+ehx6oUZpEZGcyDRt
	PXR2L4PBJIYfKgoPnKRntbMbKVWYMJfj+vonJUZcphqolHvdDVj3qTgf16+buQmn1ZtC1qhQtph
	rmzB9edP99RzmfxUNfaRdzpYqL1J7ZmBgngEC2fH7c9Jv20gm71yGIrz1dEWV3JHsqflZBlDWQJ
	F+AWY3hm3bwVFnQrZdfb2evJMiTJ8auZG42I2wTnH58ED4r/ax0JAc087QqqTdF0KGI4rBRS9zu
	JkdkeAhAKW+0nA7bphsAFZ0EZOtDmKjdon1aueDdhPNaPqHko8XW7f2iqYOFmOh0U7dcZWjeauU
	TkgUeDOSi/zlpv73wX4bQFHTfI6S31Bn3U2vupkeESKUA2v/KDQe8hQQnsUuOw3wvOGOp6
X-Received: by 2002:a05:6214:31a1:b0:8d1:d1e1:8360 with SMTP id 6a1803df08f44-90400b7f3e1mr9010646d6.39.1783717800595;
        Fri, 10 Jul 2026 14:10:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c8d4csm52955776d6.44.2026.07.10.14.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:09:59 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:09:54 -0400
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
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org,
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 33/33] tools/testing/vma: output compared expression
 on ASSERT_[EQ, NE]()
Message-ID: <alFfopehgN0dkMzM@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91D3BC0003
X-Stat-Signature: at9wkur5i7a56ejf7wyrjajb1qzpkhza
X-HE-Tag: 1783717801-189252
X-HE-Meta: U2FsdGVkX18WpRJvuSrMHVQx0YC++yqyPUzxEFrbl1Qt04e01EvvWn3au23E1TOKOQM44p5O5ZcuoqZaC88TOACmjfZIfZQb7ANkxy/qWIgBq5QzJo/B7mkA66VMGsB7vgFFlH6BzqQyyWHdJjPdqFip3RUXJID6s6ifnmdzMS3nmRrlzCj5DRqmo0F47zlkV95WaGyU6+O5vIOjgb1I82gc8CPWOyjlQEPAV8d7Z1duyolNZElomS+QFOQCs+sXGWEl8wXnzprE511ISfGNGw7dvPlLcF94LP3cT5Hd6zMT3sPVGtT+Xc+JxxM2V2YoC7ZjrsSLHiiUl+onNomy08CmmrYbAMNUDfqRGljxugEDtNfLhAMUUVdXZO/HvH6dxtxfsuCEfbdr7LXczePRTsW+K64A092qItZoMHZct18v5JfT8yFQPwb8kJU8sNKPUyRIb18HZKEnQwhuUbxYNDddSGHtCifh78MrDxeBuJx3a78pCRg+S1KFWpDxBAvLNRX2YUfp6h1ErXqEVYvrG93JI0MKOkBcBHMwlQQHZVRRuCAQDjk4r0mxCCqP4QwypYty/vTtZWrQpXcoT5NpGYyDfWtpIMmMumPh27p9Q8yo4iEL58U/ZOcOH+80ZEpmu3tMwUT+nD3Zn4tT2Bdsl03E6xHcccKO2PIbkc/djjzpVK7gd6eKdN6Qn52paaikKtcDe93HQOyvOzXzUiTtFL0OnFB1E3gQyDYnH9lkCowO7gdLV+JdazWRE/nbz4Wkt7TnYbUHrzvrDrdbQk7Em1eCSRO1MFXlGQy0r5f+8CJhdaI0BGADXnR0+FbOEMO0Hv7fVH9kvyd+a8AWNmMPFi3yki2j7dbPzcLJy49G1UOTp8uIU7xDFYmhEopj8HIbonWMIF3/dURoU66AtBxKwtb88+ssH8pSQlwd7muMJ8Q8Ybo3pwpX93KNJUxjVrxgd6YSXsfbjrZpPoNaA2/
 ZFp1grMs
 xRS8j9sNsTHlRBnBGY+Y6vgMQodjkEQ+9o/JXMJwx74gEmC2NBw/bcSE5nPeByKOmTRi1kY7GbTpw3IW7o5rgnu4HYiNM8aavwRZnGcQ++MqqptlrBTpbwkhK2dCgOZDGwKo0HrZngFaET4DeVbW0kGZVnINzyeZAFkO5xNbfek0Xox39H2Kwrg6AeNkKsqD2hNKMc8sT9PNwlCj1hm3LRUtcrShcLP+DPXincLqBlZrs/Rqw0L4X0a+nNfOBFTmlTR1i6Clri6iQiHu4IR6vWfSf52j21+gmfe7HGymh5jhl+/Uofv9VDkkb9F8SFg+ki2g1/KhcOlWY1g7E6PKdwmwZltjgEsG1mZfSZMilZA7Mk/VMUPxROH68gl4eznxbJOo+BYMux5xIirKVrnSdEDTva1QPm+H0c6F3EWmwUGRxAsp0rIZtBmnhwiJ/1BPh8ifFKeCjSgfMuNOrIOyr7NSsTEB7GEdCCO+Fc6ejNmwNUcWGn3Gcz1oZX2UR1ztDDnrNXe8IkZLSvZPIDp/gbXYxn21brd/nugqDLkvIadi17IDQVSNEKKkT/Nv7+6n0L/l5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:17:14PM +0100, Lorenzo Stoakes wrote:
> Update the macros to output the compared values at hex for easier debugging
> when test asserts fail.
> 
> We have to be careful not to re-evaluate expressions as they may have
> side-effects. So update the code to take local copies and use these for
> both the test and the debug output.

Aw you found it before i reported it :]

> 
> Also remove unused IS_SET() macro.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>


Reviewed-by: Gregory Price <gourry@gourry.net>


