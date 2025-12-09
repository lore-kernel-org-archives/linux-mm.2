Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4296CD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 04:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F856B0005; Mon,  8 Dec 2025 23:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720BD6B0007; Mon,  8 Dec 2025 23:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635CD6B0008; Mon,  8 Dec 2025 23:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 526BB6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 23:56:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFB8D1603C8
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:56:36 +0000 (UTC)
X-FDA: 84198721992.07.C52DAA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 41DC8C0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:56:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pALW8jEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765256195; a=rsa-sha256;
	cv=none;
	b=tt5jyKng+VP8jpYiFKf2IXYQT/168af0oboM6vPqp6yVIaerLcEyLjZL4o2l8RO4opNzgb
	i2jkdoJng8jrzvM4moTkLmTGQ9azkq2XaVYRlpCO64mzAU28VUKOa7VDMW+JBOtn+pi2UY
	IhFWhjQwlRx+OBQxwt5XpF1caYO/dkg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pALW8jEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765256195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cehAZDwnPvm+NWC3VXU5khMPVSi3k7kcCfL7dAVBN04=;
	b=g/2W75e9uCa5j5LGcVqUDhNbENaNYSaddM+GrKUbKxk78AK8/HxVmFHlZB69M1G7j8xPZT
	dtNChwjEbZMXRzRxHtl4av2Ls1LhOoKpKH2H80P2XiUQv8REh3q+eZ5fWtglJxSDN8yY2Y
	MxbFgrG2cJ9nXM/+2OT0ZoUF8KjLJYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 001F743C5A;
	Tue,  9 Dec 2025 04:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83250C4CEFB;
	Tue,  9 Dec 2025 04:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765256193;
	bh=stSlRO98n6+YI+yXsCwpZF58h8JKifRIN8mOv4byAEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pALW8jEqXCx7Hibl6DnGy/22+00pTEx9UJSYHhWTGmuo2QzE4PcQgZMEMkfX6ld6F
	 NmPyIiuT5vJ5cJ3ZdKFp635FbzGnEk1V1/u6hxf0nsK6M+aDYg+WRea9aYter+ws1H
	 lTTBHOXg7QZGYhKaXSwZILBN8FgVX3+Epyr65A2dRZ8jMK2HxJHRUTzkczd+A4c5s5
	 vq0UMSQVyAe/tWdes9uwafY+tjRmVOJET7UpSpsMvQBwIae8s6G8Le1Qo/Bb8X8Eog
	 w67HX1jGTKigc1bJlOab/at1WHqKwMdYyuBfl3/j9Dmnf7yqSHYDviv6A5jgsqhusI
	 Nn/3+IagHv+lg==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	damon@lists.linux.dev
Subject: Re: [RFC PATCH v3 05/37] mm/{mprotect,memory}: (no upstream-aimed hack) implement MM_CP_DAMON
Date: Mon,  8 Dec 2025 20:56:28 -0800
Message-ID: <20251209045629.77914-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3b7ff190-4efe-47d0-82fb-68135a031b0f@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 41DC8C0008
X-Rspamd-Server: rspam10
X-Stat-Signature: kidmo3kxjbta8degjsp5bwhtr3ng77sd
X-HE-Tag: 1765256195-878213
X-HE-Meta: U2FsdGVkX1/HZMiYrpN8BqnsYrrT0+x9vkvVqYuZRBmCWH3kpajeDxyrGx/ObH92BsUYQZ/P5mpGsC9+8/CbujyEAtfehYtmJfIV8k84Rr33uBwZGcGSa8+uPKhRqa+zbwsM1plKvdmM2xxgQ4QzdnnccNJH137JliJcAWjHn4I32I7RQgQXVnoG8+Zcs1wcKB14vCDjTR0m9HSQBbYx28BLZ1Od8KqcVX/jMfCnt9hGsIG7B00Mcv0jX2RUNQuTt2geICBQpxWWaHKnKlldDnsrOU2qFFylgwPaxb11tdzYQnGW44+42S71PizTnCQHGMGmgKI5qxhxCWrmEt0N5iyjCOhVQfCP5rNqMwFajfyCqZG58D167tROPzVLHrgey+HK9SXZHKt4ss+4NuDtbHNMolbboMcOmwsU95XK7LgqsnzY7oJQhgd3W+SyPpO6j+WAfOnGnkGIWmBL+btkK1VWP/xb15JBf7BEVYx3cFalGdxjTwiRgfSE4tSf68eapzIkGGBEClzfrB5x1NbjwZNt1D39CbizHUyeBtBKHZciXgPu5T63Xo+JsDiuPzUAsjWTGpSNtkmlzGDCsGOSjlpA3vJ83UGDtUpchmplkNf3ArTIMIl1LGrNr9j3fAwNk1sG1jLtnduRWeiztj6oZEfFyujfy+hWOYEu8Hxqch9kriZWuOo0pT71leegLiPZEtwYVglnhAWhJeuBYbmbNKh5yabDIz0PeAnnuGYZx0qK3INwPuLhC+hMJt7nGVh81/lXm+zPv+bhALSeDNoN2gL/Wfp1kWXU8M9Hcw7O/V3i8BGCfH28MEw5ELlla8KjOd/+7dXwoc34N9PKiEWo4da3MQhv8hq5zPAm4TvgkjlRWHNclU4DUyye+tZVDDyKSrOU7frp6bvaqKjyJSNoQwbeIAWW+cRv0zyUPQKYgEEzKS5INUj6LMFhwzutC4PnO8l5VNyorVaXd/gdHkk
 S9J6DXxu
 HjB/WZLa7TcceRBFCZauXzCYXkqGmlZTfFM3316f9t5OebrAFL/bACQdHUmClRLD7Ukg5a8j2vu6ZQbzsDzDMR32tNYn/trcTsgloUxsJgnCIRr5ruSMs8zsu9+OOrtIgzD6rqesQvoq1572QX6ETFgr6ukHOdK2anCB9C4wPfh+Tuo15XG/cwYt87GxMoMVdjEXPI4rB6NAU8nmDcAeN54kbaOivOixUXaMlfCKIJGy8DScDL2IQavd/VtlurhtPQvaBlzZLBxhLF91EV7vtFnG8+bRTyqpgbpYJmb8+i7WS5FKZyykgr0j9EWR+Bim0doW3p2ogqz+nLCzghJyHo/PCqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ damon@

On Mon, 8 Dec 2025 12:19:41 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 12/8/25 07:29, SeongJae Park wrote:
> > Note that this is not upstreamable as-is.  This is only for helping
> > discussion of other changes of its series.
> > 
> > DAMON is using Accessed bits of page table entries as the major source
> > of the access information.  It lacks some additional information such as
> > which CPU was making the access.  Page faults could be another source of
> > information for such additional information.
> > 
> > Implement another change_protection() flag for such use cases, namely
> > MM_CP_DAMON.  DAMON will install PAGE_NONE protections using the flag.
> > To avoid interfering with NUMA_BALANCING, which is also using PAGE_NON
> > protection, pass the faults to DAMON only when NUMA_BALANCING is
> > disabled.
> > 
> > Again, this is not upstreamable as-is.  There were comments about this
> > on the previous version, and I was unable to take time on addressing
> > those.  As a result, this version is not addressing any of those
> > previous comments.  I'm sending this, though, to help discussions on
> > patches of its series, except this one.  Please forgive me adding this
> > to your inbox without addressing your comments, and ignore.  I will
> > establish another discussion for this part later.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
[...]
> > @@ -6363,8 +6415,12 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
> >   		return 0;
> >   	}
> >   	if (pmd_trans_huge(vmf.orig_pmd)) {
> > -		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
> > +		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
> > +			if (sysctl_numa_balancing_mode ==
> > +					NUMA_BALANCING_DISABLED)
> > +				return do_damon_page(&vmf, true);
> >   			return do_huge_pmd_numa_page(&vmf);
> > +		}
> 
> I recall that we had a similar discussion already. Ah, it was around 
> some arm MTE tag storage reuse [1].
> 
> The idea was to let do_*_numa_page() handle the restoring so we don't 
> end up with such duplicated code.

Thank you for sharing this, David!  As I mentioned on the commit description, I
will revisit this part for making this more upstreamable, after LPC.  And this
previous conversation will be really useful for me at preparing the next
iteration.  Thank you again!

> 
> [1] 
> https://lore.kernel.org/all/20240125164256.4147-1-alexandru.elisei@arm.com/


Thanks,
SJ

[...]

