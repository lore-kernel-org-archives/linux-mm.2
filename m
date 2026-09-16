Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B23C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 20:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10586B0092; Wed, 16 Sep 2026 16:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B166B0093; Wed, 16 Sep 2026 16:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62C56B0095; Wed, 16 Sep 2026 16:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 885516B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:52:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 992E180143
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:52:16 +0000 (UTC)
X-FDA: 85220823072.09.A071719
Received: from mail-oo2-f41.google.com (mail-oo2-f41.google.com [74.125.231.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC85C16000E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:52:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pe1XjvuV;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789591934;
	b=MdKeuq0jCzbqtlvDx4LGSuv88oSbStK24mVS0sW69znlQr8vtty+ds/L97RDK+HLouRCvW
	aldo3HF4BG9sujEZk3FdVdc+Uw/H3u9WzDThL+pPJfF89U7XPXlDeAXNOdVzAeZxZ6Eu1K
	UJ9SyJGjsBoFQP1/33Onfpf68gBMOlM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pe1XjvuV;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789591934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFxqhaToXcLhZx57rZOKyfb/5RQhEkCVEVgt0s8vR2I=;
	b=XQqgcCYphn34U3meXynBcDZemJ9aTVXzBmwbdvWO0gynTpY9WLyd7sIbQjnQ3uH+P8Z4Ez
	bfMgDMd9OW1cP+81zQ3VDoTxLjydjhc9paaZZr6zBxut72+5uNAtWSeuH+hd/q7//rRxhV
	V+f9z9895QIUmiFVe4fEX0yNCZrV2wI=
Received: by mail-oo2-f41.google.com with SMTP id 006d021491bc7-6bff4d6504cso35977eaf.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789591934; x=1790196734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KFxqhaToXcLhZx57rZOKyfb/5RQhEkCVEVgt0s8vR2I=;
        b=pe1XjvuVmzI1g2C2boPwD/LKhG604SzxuQHbMGpEknGisSB1quAIPijeO/IoXUfLDP
         w7/PflLK9VGGo3MZ/TBx8cCwPk+KgYQPllB4Vwb6i6aMfl5FTuLed2sDgJFIydKwFdYE
         kI7x2oiQT6bGhluFiFnxjFu2t6rhCFlI7JJk61VRS6evCpXViL/VOEnNEzZ1weNR0NAe
         LsbvywTbPgrMxBThjYndwtyDTalnQ1AJJ827rokro48riF3F4NfIXL9W1KxGN1fGguKM
         Yv1mcMyyjhmZNCfzWz3o12oHE2oqWPpxod8rYJul1zr8/xyqS1jAiX7c55FHoiMCtN/u
         yKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789591934; x=1790196734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KFxqhaToXcLhZx57rZOKyfb/5RQhEkCVEVgt0s8vR2I=;
        b=ORNrekKhUJlfKFRsScMuTRvSkfW4goyVhQM7Ea8gENhs0/+tPsSbtce1pHwH0doOrt
         IAAqQ3Q6EpyOIRTPbCSSmIvnOdtqnTvSTp2mHySH/D6iXdWwmwSugktBe2mhL3KJlJmx
         NLb7WHIQrHVtOzcQ9LWepb9oaZ3sFTKb541UAsiewlFsS70QglCOg/1qcbnwDnhTSW1q
         qD82erlNRf8jlbigRSRvrubJK9y6AqdClEOaSdXkNPSkA/QXYyx/+pYylIQ0XT96B37S
         HOXosDBB+oF17M3lPFjF68sSG3vv64GE62UOoh2cBAPWXS5bg0mdivhBeRMTH1zuQQaW
         l06A==
X-Forwarded-Encrypted: i=1; AKwUvBxf1IfYkp2W0Fki7tG6QCuQE4VWA06k7XI28UOkcpJ/yyiMezcLYu7I3Ptlfsd4T9KZ9EKJKh/6TQ==@kvack.org
X-Gm-Message-State: AFuF++lNfL1AXUr7DIZbkN6tOBU+bBYIK8oLi0I4fs/j9u43R4jzeAP+
	T2BtzYz5E9nJ5dCvWtQyOYceOaqzCjyCrPaxvxhm+CTGoT9ncjHkHXjw
X-Gm-Gg: AYBFou2BoLIGENZ9NoWjxnAo096a5Av2keLhK0mpF+MMDzSCppg0dgLRV4K6YxBkhKl
	XIsoEY05ZjcCUrL+whiv8A06EZp1NwqouyyzDdxCrelPASYNhvB2FMhKGbn2VMgn4KvD+n1bKQm
	tGdiUXBPxjnc86KESQYN+S9q2WADq+fm34UegqhyM8X673PN+81n1xaR0pQec0R9264eOgdOayU
	tjWxGQXSbC2sh2VqqvBgCqftgFL3EcnkSjBaciTo6r6otWfFKK3Nwabo6plYUqkUp6RDZcgDiPz
	n7hnnmsXunRtvlOcSB+NLxw7JPhdthfzW45xdqw7r4eSY5hEpxt6sPAC9kkYF7XeVT93SeCeOGX
	vb/kyX44Kla12BOWYNefxVbPhVRrcv8rnfyPKw5By6MZMeiHwbgDIkqOJ2KRafiuuvzxZ+Q3hTe
	xDR/wBWlOv9Nj8/YA9o4UzkSGwBSP1D6wLKzLnyMO3tULjZ77kDjBSq6/CiXGB2+ZVv4aP+LyeR
	EpMA/AKDm8XuVPrIxp7R7zKk/wSJQ==
X-Received: by 2002:a05:6820:2226:b0:6c2:1018:3f7 with SMTP id 006d021491bc7-6c7d41e1e4emr7017724eaf.23.1789591933607;
        Wed, 16 Sep 2026 13:52:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4842a23e310sm3312526fac.12.2026.09.16.13.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 13:52:12 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	sj@kernel.org,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	dave@stgolabs.net,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	byungchul@sk.com,
	kinseyho@google.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Wed, 16 Sep 2026 13:52:10 -0700
Message-ID: <20260916205211.267720-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f871efd2-06b4-493f-87cc-919b6e0945c0@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC85C16000E
X-Stat-Signature: f3gp8mc7wcjxfp8ju3w797kctstkfcwp
X-Rspam-User: 
X-HE-Tag: 1789591934-205981
X-HE-Meta: U2FsdGVkX1+c/OieTcdo+z4veSKMZE5UxO76EN7IVVsm7o4FWLDe8SPbadd6oRfWylZOuJTIfThUMNLaLRGcCCvHx5RBypfAlTG98Q9n0eV1EjEcpPzAwb1IJ18lwhksDyitxJULEIjmVx5JP32OHuC0XqK2i+0RjNJe/o+lnct392UokbHQJkrzjIz1rINraQl1niR4NKOGUn7l4nlHI0Izn4J8FLgjeDuzpOIOzgJO73aHhyUcrNAv9RUCwwzORaCPfD1OB+Jks2Fnky28eJWmmcXPggNHzeveP3rDP933NQa5bORtsSacITf8MX9v7gc5ujnp4Zo+nazD1qSI5yA1GOwPtVlzxa/MDPZovFThqWDXEBe+qFaBT/oXtsX0V6RB8A/5PIDkGu/NTETr6V+arEKQIzqj4AyMtLHENQlg6W97rWy638083wDfeRCKsZ/nI/tMk+xxDvEP5/jY/5IFEmytT2xV0Qq7VIQI7/tq3s7yud71spFhdxJtx/osLl3gVlTbjsxZaA+s+Ti3z6bXHEYJMYijbWP1wJd8QMh1dunSDyN01chnMioeQY6YAQcHZsdCTYtEHLlb1qJAnMrrePaUMqbdnGU06IL0RN+gHKKNNpy71dNQ8ROELBxacIlhuskmBsmxHj3DF06EI5LOQuh/LqId/YocWOX2uChCEcBHTkHFLbz7a7Hc/XL/Kdn0/JxQnQCRHEs7ahF5VTi9IXDnco7m0qa4+Uim1JDr4t5jXCZnxoQUNwjjweSW58jTz5L7m6cwUEL/dkisijr/P8+i02Kg8Bp4/UZrKtPUhVn7UMyfW5L4ptMD7al01pH9t8kOhqujGlT6EbDu+dz5WMEED1n6TTO8OM9b+6tQQw0jSEpGeyVxAoAmcKJ+YEtYZiDA2rwDhbQfmKCp4pQ6xQtuXV1TaOKO20c19Sq4HsrmKm/bIbrUz8WOSy1naS9coAjIwh1r98+cJx+
 OPu2HEhB
 U/wrWOzW+OfUnAS+nN1Tsd0/3slYd2OoXQOZc8UmZ9ycspJcnPYHGnKhwM2hm3umsC6b+oq8mXJJBB7Lt46mfIDu5S19pebSnVq9bUnMGUKy6wNJg8L2mj6PlJd299G7pjUjcTurRT2gS+nPFtPr1a4RqgwJpsJrLDNIgs+/WoxfhLhU5DeQr7dUwD92Wg1ZltGzYjOkbDkoShjoeit6oV0QA9U6WAg3zIgKSqqIUcm0WP0TdxRnDA3eBgfTnTy9vt72Fr/jnssvBatxpZoE+w19xL/+X3yjZroEtDrN9RNFlCmkT+RVE1eiHijT4gfeoHv+c055sSZU0XbwzKC1RGtTD7c5021TJK8TBhaqNuXogR0MPK5mEb3479YS1HzwCX9a+IvQW5Ou4JBTBxURtCnTSjikzrU2sYrxyPiPMy4+mj3P5K5v4chlM03uWIqXBg2pUYJ2g1RYYaerF1QUpm7D5yWym3Xdit8TObpUiEin377wCLSW6TeBerXID7+5NXnWurZ0tpyBvsvzQTKC2dywBu9IUQwNcq4zr3KR4wjv6Zah0joaNbp8OtjJe89rbtnsLftIMxj3NWEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 08:38:17 +0530 Bharata B Rao <bharata@amd.com> wrote:

> On 12-Sep-26 2:38 AM, Joshua Hahn wrote:
> > Hi Bharata,
> > 
> > We've been testing pghot in a Meta kernel with worklaods to try and see
> > what the performance characteristics look like. I wanted to report
> > some of the findings that we've found in our testing. Note that these
> > results are from a modified kernel that has my tiered memcg series [1]
> > backported, as well as Gregory's numa balancing scanning fixes [2]
> > as well. 
> 
> Hi Joshua,
> 
> Thanks for testing pghot with your workload!
> 
> > 
> > - Without tuning and using the default tunables that pghot comes with,
> >   we've found around a slight performance regression against raw NUMAB2.
> >   This was being run on a host with 750G DRAM and 250G CXL.
> 
> pghot promotes on 2nd access by default since pghot_freq_threshold is 2
> by default. This will result in slower promotions compared to NUMAB2
> which promotes on 1st access. Could you please try with setting
> pghot_freq_threshold to 1? I think I should make the default as 1 going
> forward.

Gotcha. Out of curiosity, I'm wondering why you decided to make this a
tunable. Specifically, I'm wondering if there are any workloads that
benefit from making it require a second access. To me keeping it at
first access makes a lot of sense. Obviously you could say that
scanning workloads would want to use 2 accesses, but there should be
other ways to prevent that from happening rather than counting the
number of accesses before promotion. Just my 2c.

> In any case, will it be possible to provide more information on what your
> workloads are, and the exact performance metrics? Any representative workload
> that can be substituted to reproduce this behaviour can also help.
> 
> And when you say slight perf regression, how much is it exactly?

I'm seeing that average latency is about 20% higher and p99 latency
is about 5% higher.

> > - However, we've found lower pgscan_direct, pgpromote, and pgdemote
> >   rates as well.
> > - We've seen PSI dramatically drop on the host as well as the promotion
> >   happens asynchronously. 
> 
> That's good to see.
> 
> > - I also found a bug where the kmigrated thread isn't created for nodes
> >   that are onlined later after boot, like CXL nodes that get onlined
> >   with memory later on. I've been using a small hack commit in
> >   pghot_memhp_callback that just checks for the MEM_ONLINE case and
> >   spawns a kmigrated thread.
> 
> I will take care of this scenario (CXL node online after boot) in my next posting.

Thanks, it will make it easier for us to use on our end as well.

> > Finally, we've seen some issues with pghot causing userspace crashes,
> > which leads us to believe that there might be some bugs that manifest
> > in userspace as well (we have not been able to find out where in pghot
> > these bugs are introduced).
> 
> That's something I have never seen till now with any of the benchmarks that I
> have run. Any kernel messages attributing the failure to pghot? Anything
> attributable to access reporting or  kmigrated threads?

We're doing A/B testing with NUMAB2 only and pghot, and we are seeing
the userspace crashes in the pghot host only. It seems like there
are some segfaults trying to reference ip 000... and a warning that
references "Too many tries to read user space".

I don't have anything in particular that would direct us right to pghot,
but this crash has repeatedly come up, only on pghot (across reboots)
and not on our NUMAB2 worklods. 

> Any clues from coredump or gdb debug of userspace crash?
> 
> Were you running your workloads as part of a non-root memcg?

They were part of a non-root memcg.

> Do you see these failures without [1] and/or [2] ?

Yup, I think these are unrelated to those changes.

Thanks again Bharata!
Joshua

