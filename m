Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF491CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5616B0088; Thu, 15 Oct 2026 22:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F2F6B008A; Thu, 15 Oct 2026 22:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74716B008C; Thu, 15 Oct 2026 22:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6CD6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:56:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05461A0205
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:56:46 +0000 (UTC)
X-FDA: 85326976812.30.D56DB8B
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32311C0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:56:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b="cuiSy/zN";
	spf=pass (imf10.hostedemail.com: domain of kylebot@openai.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792119404;
	b=zAMO/J0SFS8opIUtLhdbnWNO7Z+5cgcS5XeelGIKL7Dltwpg058GZRIDcw5r//j62Nv6aT
	kbkGKPbS2p2Qp9S2+sfW1eHqxqjWqPu0haHfG/G1/UvMVTC95FJESrdLStTIeQ1siKSr7S
	sFtm93SdXanDbENAthlzLhDbJd4zEv0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b="cuiSy/zN";
	spf=pass (imf10.hostedemail.com: domain of kylebot@openai.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792119404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KoU7NlRc2WHo1VRPn8/Lg64nT3xPfPjPfg5kvwFTx1I=;
	b=Cq2C7X1o9yWx/aZVmyCDxmKDFFlz0eENTklRaiFI+dGlHyy5cHOgc8Zp6x17+/HPlIG/N3
	wlnlgIjU7LC7FlvzChx0UXYQlxKrfovE7L8J7xQNY64PNkgicsCjri6eYjNT/MqCxWxZq3
	gFrWR4ywE52BaHsMM+QxB6dR8J61Z9A=
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4932b13c4ccso1326180fac.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1792119403; x=1792724203; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KoU7NlRc2WHo1VRPn8/Lg64nT3xPfPjPfg5kvwFTx1I=;
        b=cuiSy/zN8WU3+IOFnCExBnSh3shSKYapefFNP47Q3gkrxTqAeWGls4hW0syAPj5cOp
         HckiK7rYxyWahtHEHVnlJi5S4FDIzkW3/uIvxGZFvKhDvX4QqCUF//UuU411ngUBKtv9
         y35kmNrYMcn7giJe1Rb4Dwbuq5mj+Wxa4D2Hw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792119403; x=1792724203;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KoU7NlRc2WHo1VRPn8/Lg64nT3xPfPjPfg5kvwFTx1I=;
        b=GJXmZUlycSnuglaO2q9pDvVe5FR3VBejYqmQZ8bBpYY8EPseqSpOxJgpsi1HMy5bhL
         T/3iYLogDKrYKHmLzIgf5weBFbVW/n3Gcc0soiTZ5NbcNuQYlyTp6w4pQLzxUenerMVy
         968u4OTqBRcHaDBUEXoAYRLuyNu1b/Kuy/t65zKEk0q1N1QobATbc6Bnt0u9uGo0Kxqf
         v1zSybFodj3klfwn8NSY6AoON6Ce2bDCMgttjN/GWPyunX4sK3sfJ3T4LS7Spl+nbXeb
         STrJHBXAjZVweTe1bsBrT9RzrD4Y7IURBNMJO9D6pr5MQA4yApDnQcU5YixGzyda/Dv+
         lb5w==
X-Gm-Message-State: AFq9FYKOGtZZb9GA4PyIg0U687Ch3Hb9hft31w4I7c/2dcE6SLzRBkE5
	MYNPqowvvFxueV5OXLeB9X9FxJvzaTGBssVDZ08TFsMrIfLIoov8DTcbAGrSKobY0uk=
X-Gm-Gg: AYBFou1/7ICPxDR4Ge6MfaI4lM5WZrRW6KynIAQS4+WdvMuZcE5844aLoCSViOWYZsG
	EB43kS3xt500RhvgxHb+6+6h9y/j2hsLUBKcUC8jlrHrXKc2CNu2nRpLN4mfXDtz9aSNlYfHzHJ
	0+mnPFLO9vJsGr0JUo36j5bpPsoSuSY8h9CTErlQQfiW48HgnpXCQoMjnhjdflnoOoSX+mD5Nsm
	rJeNohZ76p54e9nJhTxmzEK+tifDm6Lo0Nc5hI0WGpgLJyF5vYOjKdFKo8hnnacWYVRjmZ3zrL2
	qH46BkbFn4c7lSVi1Hr+TWy1D93JoN7Y7LWst/GC8iDwyq4cCr6j6cOhv91fKIPfqde+ZMdwuFb
	Y6NhTYep/PB3FFLwa9TTN2roeYrTfGvLXEOQ84QpL6KPUyUOYIUPT+rp/PPf9Wzg+yEI5p0K3CM
	Q1A4Ja+SL80akD1rkxy5J1WUIrtaTXapBMY9gD35JYiXHwO2dVhQ+x/YUfgzUZJeXdAn5DHWUm+
	KfxLuTvqijw+BIUzKE61epz1hOUQ39VrkTjr6URAcM/9t5XUkxK58GIAk1N1MgbjtyVvQzrZ3+Q
	zgqwsAMQDlYSzGaCMzJQud69zyC4wJ6hUh1XQo/R62c1J6aW93WvbdjS
X-Received: by 2002:a05:6808:4f24:b0:4bc:be93:3506 with SMTP id 5614622812f47-50c415e0b76mr18984605b6e.3.1792119402912;
        Thu, 15 Oct 2026 19:56:42 -0700 (PDT)
Received: from com-75606 ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5388c16d862sm537575b6e.9.2026.10.15.19.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 19:56:42 -0700 (PDT)
Date: Thu, 15 Oct 2026 19:56:38 -0700
From: Kyle Zeng <kylebot@openai.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: continue past nonmatching huge PMDs
Message-ID: <atGSZkBHtsnJ4k1A@com-75606>
References: <20261016011549.61146-1-kylebot@openai.com>
 <20261015192020.5336a49bc516219e8254dfdf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015192020.5336a49bc516219e8254dfdf@linux-foundation.org>
X-Stat-Signature: ertycjn5gxjstfgc9jqzsgyybky1pcc3
X-Rspamd-Queue-Id: 32311C0003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792119404-781647
X-HE-Meta: U2FsdGVkX19YeC4ioBtJ4IszSDdVLquxII5og/oCNDcWAD8IO8aEzWBhuNv/Vv0cQWvHho5ZbcgTaybrJYlVR/jDL2HsHWFS4vcyY1or7iKDWEuAORVS+fbC5idOHIIUyfW1rsNlXub1APtpq0q53A+UPW+W0bbIEQe8BPy6rsbz2nsKrMQNqXNQHWZJpbf4pIo/Rw+3YMWXUfL9oGwGH9+b7yayFWbU1D1UUVYm9IqLBejIkkcM8Yb4UQKAMENhxcXcJXO0VRaMCJncmjbEVNwHkX+s8ioR7l/Tjs6qwkuQJYXztyMv0QXLnPF9g9M0b1mphhBRQvkJwDupvvmUAPm9Kz5SNEvONqH/G1owSmXhCCR5OxVuXrHqXBVWSX+EXbGL2z0cnPYyAErdotv3EAmCrhf62jWTfIYnjAXeqVcJTUt3iubsKSwIGYLq7LNGeLQJqaP6Oc3NvdGIS+cAgJv4odPC7gpMLPnrw+jaR0gIwFm4ifSZFfOfl/kCT5+VO0ChdtlkbeXeJdlaN8fgN4tOXxlMfWVhTPAlQAuUZcat5gZ7x4JjAtdUwTYV9PspBA+5P1+/Z5N94sR02A68HIn0gsCkXc4SMOYBZPL03Oo4Mq71D8xDP6ZpFZ09bTyP04ADnveeyYWCL/dob8SQiFlAd+yhYcBp+8M1SUbu7IiAYEtlErQyljpLw+HU4/pNoGyciTnr04QN1KcKvgz2eo6w8WSOrt76uBLHoCpcgh1GHMp7o5G5NXekNffG1nKZONhjlBM5FTXSO7oy+LJUvlrTBFdxMj7GTvLPNtHv+P8tlRqg/tDP45tGYnnIjrhQs1v8mNqSsP5+e3mMm+HSnwYEs2im+RbhBIhcebP8+LAcPvVyRJgV7UWPEAuuuiAUbRyuKSMkCKSRpfAnq+XkHkPH0JcdmJeOjyEkKe9XbBNEfctVwwgJJUfs1l2CIKQ6cFbbGC9mczM2n/r4c2U
 srdQc6ey
 4fJx2Y8njHjtRSj+BWYAfWzyfwgeR4Wj49kfamalJbgEYuoAHA7ovJUEUpJXT33sreZciVWWTzDHWq0DdXLhVcklAoAr0QGQzkTYWHAO6hMmmmXJ9LmM43qJKA+6MxsITiYFAy47pt/UkFZDbA0xTbcosbWg21Bu9in8d4IAOlSMWJKHDmUB0asxCW7Xmrw1JNTlYvt/25l0QxypXX9fqIfyvfvXHAuBRNkJ78Ljxdz2q2wogBuNZuabljorEubCCBFnmOva0OsDgidtvcPRyiItIYxbIS9sUJ+QKbh/P3aJOlidSH42cyqEeEpjNy0kSmmefnt3ISNgbd8TDV03rikwJ1/ltyp2z4W/+rV/37+DasesV7XCGUDQyw8Dv2QmDt33H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 07:20:20PM -0700, Andrew Morton wrote:
> On Thu, 15 Oct 2026 18:15:49 -0700 Kyle Zeng <kylebot@openai.com> wrote:
> 
> > A PTE-mapped large folio can straddle PMD boundaries after an unaligned
> > mremap().  If the first part is discarded and replaced with an unrelated
> > huge PMD, page_vma_mapped_walk() stops instead of looking for the rest
> > of the folio in subsequent PMDs.
> > 
> > This also affects migration entries.  A walk that stops at an unrelated
> > huge PMD can leave migration PTEs behind when migration or an anonymous
> > folio split restores the mappings.  Those entries do not hold mapping
> > references and can outlive the source folio.
> > 
> > Skip the current PMD rather than ending the walk on a flag or PFN
> > mismatch.  Do the same if the PMD became nonpresent before the locked
> > recheck.  Release the PMD lock, clear the per-PMD state and advance with
> > step_forward(), so the existing range limit controls termination.
> > This covers present, migration and device-private huge PMDs while
> > preserving the matching-PMD and split-to-PTE paths.
> 
> As always, when fixing a bug please describe the worst-case
> userspace-visible effects of the bug.
> 
> I asked $LLM and was told
> 
> : The worst credible effects are permanent application hangs, kernel
> : crashes, and potentially system-wide denial of service.  Stale
> : migration entries can refer to freed and reused physical pages, causing
> : page faults to access unrelated folio metadata.  Memory corruption is
> : possible but unproven; cross-process information disclosure has not
> : been established.
> 
> But you have an LLM too!  So please never again send a bugfix without
> this info.
> 
> Also please explain whether there's a reproducer and if so, at least
> describe it and confirm the before-and-after results.
> 
> Thanks.
> 

Hi Andrew,

This issue can lead to memory corruption and I have a reproducer for it.
I can update the description and send in a v2 if you think it is proper.

Best,
Kyle

