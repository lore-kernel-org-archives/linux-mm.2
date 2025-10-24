Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D99CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 11:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA078E007F; Fri, 24 Oct 2025 07:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A918E0042; Fri, 24 Oct 2025 07:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89478E007F; Fri, 24 Oct 2025 07:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A545E8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:57:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E48A13C429
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:57:53 +0000 (UTC)
X-FDA: 84032858826.08.BD497EE
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 203938000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:57:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pj6ViT3P;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761307071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAbdJ50faFATYVUU4QEMwOR1mWtVgSTW8fiGw4tcaIU=;
	b=heElXkAFO1BPgYzyZtN2OTR+dzb5PfBkAne5L1+tk9f2P5ScsVdQuJDd1njKSCF71q4NPI
	Xkn2JTrHJ/RQT9vraLF3SWsJ7Ki44lFGiSsEHaO5Zsc2XaYZ2sdQZhEa1/Hkp8t5US5IQX
	FFFFEFUP/sYpLpTp3lqr6LPBM8bvIPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761307071; a=rsa-sha256;
	cv=none;
	b=PQDTp8QIBU9EmV5ZCP02Z25OStgt4jSdehlfUzYV7hAQdd5seklLV3qtOwEMxiGjZrK7R5
	82R9GwCBQOTnb0IWfuJGX8LYjt6vGbg5fl2YffjVYQYgGhHNfLMML7OZQGh7HDK3zGAMf/
	u96Yzwf7O3xEq/NfZfCCuh+nfx+nHjY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pj6ViT3P;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42966ce6dbdso1319571f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761307069; x=1761911869; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SAbdJ50faFATYVUU4QEMwOR1mWtVgSTW8fiGw4tcaIU=;
        b=Pj6ViT3P3YKY1ZaVKnGJaykM747gFiFdL3UPgeGOCy2ESLkgH4PUWCNsIQzIU5kebY
         NRYCB7WFO+L37OFeZlDDmzgsLgP4Bg88sCAqaClH9BZ8ub9sB2iZTTPoY0yveFZX+Yky
         O3djMWpFdvghnhPScCtLMyzC+xiLMY0xVEXa96PXm4mDYPGor+Jw8F/xHxmgx+gNYTAe
         ZMyu0epVZeoyO+W5MMk0ASf9VEqsz7kGMDKX53MIwxJe9ok2bo4DlkEUs5Cy88tJZdgy
         7QUUB0KlV220LryP43KP2URwlgigPQkK6jUCa4PubdLxNJc8LsC4TCkGQGkw9hGjDD37
         FsoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761307069; x=1761911869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAbdJ50faFATYVUU4QEMwOR1mWtVgSTW8fiGw4tcaIU=;
        b=GzSlCyd5/0ZIYRpbLYnHkobFPMCl0oS7n1u3lCXy6DwQBJ0jDwNvOHVJkznDHZuK9x
         nDW9LlpdfSK5U90HDWl9LngnnYOkTxK1vj/uoykAZgN5LH/YMfLV9k3DJNpSupJosUsi
         488FygUZvLjVEkQZh5DwJo5D7F7filrRZaWhRnh1U2qppVKZ9QfKC8914MPqmRJeQDcq
         Pzw2IEzdQt493uoO6TWVCG7TzncbFMZ8d5VHFPoitvvuGXnn9l586mf5msX2ZelFk6SZ
         +7lYgl/f71zdaVMM2yd8YJQWtz2diJF6Ndr/figy4tJKL1ma9PjkfPXm9kOuVZUwiq0c
         K38A==
X-Forwarded-Encrypted: i=1; AJvYcCWwKIEBxIiF8xz+3k+7JH8TFt73uGvZIhOdMFVY5TXG6xTGMhwe0roajGtUOF/3xdSQSR79faontw==@kvack.org
X-Gm-Message-State: AOJu0YzNCRSJE40NY3yr5r54/YeCrlTWw/stI4RhtqVCvfga7Ud4KUAj
	NkhA/mSsVsBvOotzC3+xbp/nuTE8SoPG/d5JaiE3rbCgHLfLNSBBu9lOtmUBW4lT+FA=
X-Gm-Gg: ASbGnctIrKXGr9eGxeBhMVXc8q5z/dvRJcYn0X6jNSXZklYP7XFAnl8GK8wSUI45MDu
	2WHmxmx5tYwlzN7xc6SerYyUAPE890aLZMY2DyUGCLRIlLv6gQ/L3KnLyej8sB1DyhoDN2dAlTU
	C5sE6xG4R6XC3LHdV5o9D29RhlPKNRY9VEIWdXBsYcB3d0ld5+uQOBoadVHuzIXrMFDAXtqrGLS
	mGqDpwJsfRlC1zAj8SVV9gKr58+ANvjOEw+s8u4PMLruuvC0pTQuqonfsz9TmANPlFfWVgAHFH3
	fX6u2bRD63479oMmDCsHi966gvzJYtc6Up8k1tTszCjb9/qsstJUbdYHh00BpW96TVk9r6rH0vR
	5aIFqm4el8Zqtd09a1/ndKTfFM6FuY5sWSYiq1wJnIEbN9ykFWPO0raf9fboGc4o5sW4OPUiFfK
	0tRGFHMSpcSLM=
X-Google-Smtp-Source: AGHT+IHkn/lvpCpu0B0ADmiosRvhDFk6JrpJ0ihTHj80p4hmIReVPZhkYJ83NCv6hwHIUkGZp+NwmA==
X-Received: by 2002:a05:6000:2503:b0:3eb:dcf:bfad with SMTP id ffacd0b85a97d-42704da9b9bmr17875433f8f.34.1761307069433;
        Fri, 24 Oct 2025 04:57:49 -0700 (PDT)
Received: from localhost (109-81-19-73.rct.o2.cz. [109.81.19.73])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897ff3f5sm9132325f8f.22.2025.10.24.04.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 04:57:49 -0700 (PDT)
Date: Fri, 24 Oct 2025 13:57:43 +0200
From: Michal Hocko <mhocko@suse.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aPtpt4hYMuJnwnOO@tiehlicka>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
 <aPstDXRerYqi1O2X@tiehlicka>
 <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 203938000E
X-Rspamd-Server: rspam02
X-Stat-Signature: jei117tcbzxkdq3fap4mjixs1fjcju3b
X-HE-Tag: 1761307070-526504
X-HE-Meta: U2FsdGVkX18R1CYpbRiX4ejD8ZZ6PAX2+pAj+MKVkkWFe1R6RW04vFBmc2vGDridVEHH0mH7G7Ei0TWtWrwYka2uEeToSsAQLYv2kE8u/u3on7zo1Kj79EePv3YsILX6J7SQ1wCG927OYqQmgcROt//gr2ljif66OOEVvqFs8QQ5jmPgSGQqY5KsctAk6A5dmt+O7WqHdfJ/gsdBxFUXmAefqnaAJssRPSM/jEIc4gsSAhudfyvBHIHx4PE+v+J3Gvt/awyiV3s11oN8spYnch9ECmFNqz0I7bfMYS/ZQfznrbI+WmsczpQkWdt8Nvb2lr79PptzZ1T6EnXfuUF5p5tK4wo1fpyRaBf7uytJYEEy+FryEVW17klC92qEg/idj0LKQpOT1ydVSa73C2K+Z7g7WV7846dH/u3OpWeyMv9dsos4fRy4HVHyMHEkrlGWK9rSWZN+SsakbIzCCbcXtE6Dm9ajGwTsmmjdT5dE4TCAe62ZdCbGhsEDLi5TEZSyLZx7szmHJE4ohX5fY6KNEtCtNmffUVgTh5YXlGLM8NaHk3w30wTenrzDlmAtccxHgeQG6zD9esYe3qOi3MKp3gGbxYEuiPF5m7zYEdQQ1s30jxqkREBBM6d+N7+ZOJuIvLBUpGZY61GSBV+63N7eOT0o4rIFdUyL5IDknf3fOZVC+CA57Ip/cDfI1rw9zFPbSs9v4dWJ94awRjaciP+58niQ5Sc9FSA2trM+eJb/M+jSAT1cHViiypSLv5GTcZtCTcsuHOUIbsl+uEcI6JKurwbR/JrSFj26XrKn8DtrEZ79UJxkaHkNRVhuxHayow3Xv0UUF2pCNBtFmVSaH1y67+tMxWBoSOb68qUXcW96iPcPdNz1AsnjM+NRhssTG3pNCsavEBBF4QIt34f5d8JHtJL6RJeywuuW3lnDUBQgzTtw6d8IEJbV/15bjZDhWAk8SEwRlFDI7AgAPitMyX/
 T+a+KShf
 PyaQYhv+xzN0dBSY9R8kMwIh7faNn19beso3QEbJDv9id6M4ylpHMdko9K/2HQ27M4q0kqoqX+OHVbunuY75tvl/qjZ8jspeWu6+Jqp/zT+z8vkPiwVXckLyotHN7Cc+c808u6fogSReUEgM0s2n5EbetvSqWbeIIhuVWCxGTcpEkDG8DFaSre312swQJb42smqvpk+ILsTCQCd9bTvoNOSSm39etjAjrY2XzLvEjEXbV46/ELDbobChPrPkdAlKW7fY787kWZ5pDqW9tdrjv5wmqeIGEsDhJ4vIY4DJLs5aZiaO9qURZT/i45AZuopnfVJlF1Omyu8pEWq6u47N8er4gOOoMhapGk98Bb9FGUWmrj8Vfk5D2DGsr41ZOlImU4kk+lrG4MzF/L0ZIX4RK0Cpw0E/1+37yOPnq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-10-25 11:19:50, Dmitry Ilvokhin wrote:
> On Fri, Oct 24, 2025 at 09:38:53AM +0200, Michal Hocko wrote:
> > On Thu 23-10-25 18:12:02, Dmitry Ilvokhin wrote:
> > > Allow to override defaults for shemem and tmpfs at config time. This is
> > > consistent with how transparent hugepages can be configured.
> > > 
> > > Same results can be achieved with the existing
> > > 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> > > in the kernel command line, but it is more convenient to define basic
> > > settings at config time instead of changing kernel command line later.
> > 
> > Being consistent is usually nice but you are not telling us _who_ is
> > going to benefit from this. Increasing the config space is not really
> > free. So please focus on Why do we need it rather than it is consistent
> > argument.
> 
> Thanks for the feedback, Michal, totally make sense to me, I should have
> expand on this point in the initial commit message.
> 
> Primary motivation for adding config option is to enable policy
> enforcement at build time. In large-scale production environments
> (Meta's for example), the kernel configuration is often maintained
> centrally close to the kernel code itself and owned by the kernel
> engineers, while boot parameters are managed independently (e.g. by
> provisioning systems). In such setups, the kernel build defines the
> supported and expected behavior in a single place, but there is no
> reliable or uniform control over the kernel command line options.
> 
> A build-time default allows kernel integrators to enforce a predictable
> hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
> behavior and avoiding configuration drift caused by possible boot-time
> differences.
> 
> In short, primary benefit is mostly operational: it provides a way to
> codify preferred policy in the kernel configuration, which is versioned,
> reviewed, and tested as part of the kernel build process, rather than
> depending on potentially variable boot parameters.

Please expand the changelog with this explanation. Thanks!

> I hope possible operational benefits outweigh downsides from increasing
> the config space. Please, let me know if this argument sounds
> reasonable to you, I'll rephrase commit message for v2 to include this
> reasoning.

Yes, this is exactly what I was looking for. Thank you.

With this information added, feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs

