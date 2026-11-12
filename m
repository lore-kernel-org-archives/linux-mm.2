Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7633E606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cav7qt5y
Received: by kanga.kvack.org (Postfix)
	id 810E96B05B7; Thu, 12 Nov 2026 12:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5866B05B9; Thu, 12 Nov 2026 12:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACF06B05B7; Thu, 12 Nov 2026 12:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 369426B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:57:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0DA9A06DE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:23 +0000 (UTC)
X-FDA: 85427223966.09.0FD0987
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 20E5540007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cav7qt5y;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794506242;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXvEHaTdEIH9TwxVu4WPdygadWMcoC2E+yhzm8iEF9k=;
	b=wRN6kViaPpsCfie+LtmPmiJhLIu8+oSi49KbPEQSPTIjpBYxxCzNk2z2KNETkaKaY6J0F9
	a0WIr20LLBTtjxcj4tZucLxawua26Nq8ldlcqhWjjcz4q68gADryIjTMf9o7GbGm2o3wdb
	KnCP4LFM7khM4B23jZcc6t7X8iBPRyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794506242;
	b=FQC8iBoKrOp1i237FXydgLzN6pd7+FrSp+2ZirVPKfxf5ZPpNw0rBVu9plLnaZUVuDDkXg
	at4IFBRKqOAx+tehB0FS3iYo+hfrPjXBXSzUtaARa98CcqcQYBLYRhwqZXLzAw1icuZn9e
	rxG5ramLEfKIMfpaFZI5529yir4J088=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cav7qt5y;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F284623C2;
	Thu, 12 Nov 2026 17:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8145C1F000C4;
	Thu, 12 Nov 2026 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794506241;
	bh=OXvEHaTdEIH9TwxVu4WPdygadWMcoC2E+yhzm8iEF9k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cav7qt5ySikup/RMSU+4AXitB+JZhw+DZbi5si+qKUZjfG61dl8+Db6VDZ81U7ZUx
	 nXLkJIDIPna1T+rtk+ouK+anTuIJCESAY1s7mRj7Jk6REnyDlbrSNMwdIk/fKI/f2k
	 rmcI5noiLHijAYWLP0XmhcjbKRRR/YkEZm6IaIfqL1d0t23F4o9fKSc8LZRADAp3rO
	 0seqv6Kl08Tj38uVQZvdjWcz3QSrInumHwZ/f0gXmPpNZsPRl+mhmkL5vkhfcpc+5D
	 L4Nw+XZ919pI/mWZYiT8llekv/JE7tUJfmZ792TEygeU6GlBcNfuByVU/RhabUkIwc
	 OEa17mddw+Wpw==
Message-ID: <sashiko-outbox-211649@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/12] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>, "Andrew Morton" <akpm@linux-foundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Peter Xu" <peterx@redhat.com>, "James
 Houghton" <jthoughton@google.com>, "Andrea Arcangeli" <aarcange@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Balbir Singh" <balbirs@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?b?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, "Andrei
 Vagin" <avagin@gmail.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muhammad Usama Anjum" <usama.anjum@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Chris
 Down" <chris@chrisdown.name>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, =?utf-8?b?TWlrb8WCYWogTGVuY3pld3NraQ==?= <miko.lenczewski@arm.com>, "Michal
 Hocko" <mhocko@suse.com>, "Mike Kravetz" <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 17:57:18 +0000
X-Stat-Signature: nuoo6n31gmgdzfzt1nsq3at8am5eg9ci
X-Rspamd-Queue-Id: 20E5540007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794506241-4531
X-HE-Meta: U2FsdGVkX1/4vwJas+fp3QOOOtfHpQU+cWhLI0wJU2WRLBJOMswM+uN5GCVSVk41p7EHjQWqqXJTlTNzymOGyf/FDRcScwKrkXU4fwDV3LHJDZQBvZrnuoiHfgGy7cGDFjNd7OJjgH2UBNOMfq3l5Ltdudpfj3acl8/JVNODU+1R1zkNQFapYfzF4KpvyL3y88o9OC2NQXrXZmribR1y5apkTGoRsPcSuUnovpEH6e+inNCfPdYvlMjFNh8qfSn2QjfJ7On7cqeWOhHCfKqxeTwfg1Tl3vnNOvD1l2v5HBGsZrQccSmC5+d17bu6XWKWUuMtaVKUCi4DHd4/soLZ1zlYdpIrmmy7g/Gr5+tB1BEn6EqrC2AolfnbnfWUsEU79TrL0aDSCv7BK/V30EokxlSumSsL6vTlq3Bt2+rAbTXtivy91li9dbfxiB4D/L8z36Y77aVOHWQpyk0+mMBTSr1o30WLGHb6QbupffYdLqdjtDhY3b+xVd65d/FyLtpLquSZy9H0pawACbsJubKjPYIvbd0jC9hD+8U35cqSgAGJPAbbXl8euifimlzhvKJ+MykjQ51xl+BJBXkJ8LN449EhxgR+UHVIFiYhr+CWcCaCpVXqgMYhriO3Xfoq1x/aQ8frlv64IFiIIWdKIH4Fn74+9cpbQTBdE0A8u556Xy3Cif7PZS2b06dBTUQ9lbpmg6pf3PkBL5VxaaP1TmDgmZfgGAf5862O1xXWYKeJnbG87xlBNJcnIt8xLlnYDfLI5ADWxcoNf6RuUxy7+eqObv7tEYibb8+1wB0t71hErX0tOpS61hzhEbo++bxhPL3G4m9hIme9ch1PYiVYWp+E2fJN7ZJsuVnqOAWW9tBU03V7D/QKPTSe5oT/lpg4yjV+RGYwxkMQvLG7OiGEqT+M98AOjp010gxUEMiC6r0gYuFRWpr0UKbFnYBBZMCEDs4REPFzqmUU5xpTzOKbYOK
 nAep0OSz
 Wb8Ni2KLtt6M7dC7wkfsy+jDbYY54UhQ1fuXtpwo6c1eOpYgKSVEUQTu1huWiC86CxwS4dIm7uZZOWct9QY3Ujv3GUMeCL4tQcN35ZOjM5cgBb82ipnKUbSAymQhgSUUYVuv6y+V0QsT0iXZO02bl0f7LCD9a7M4lihIpDg0uXlxgeQuj/OUAluaDotHVKk2My/Cs4ZlgWG6sF8gel5ri1zXPUK7/KHXnnlT7XLIFhfngkzgJJtSb0LRtIQ6mJRkZGK6mhuiXpKcyVVvxLfmN1Yz3oOA5AiERR4uY8+4CsHVm2dc7NVCvHbiBVlJgyglcOkRErqvw7U8J8q2UX3PFJItJ4AeY2mwSd75J9gaYgKR1ivAxzHN3pDJMTl2xlEBHbVjKdHLM8AlXY32C0wLzrw007E7z1eaCzM97M/9CP1u9gYreJE902FdcvpqlpPnHI6efUChBwz/N0bhHflrrFchf/297Ajn4UM0suba8FC0iHBLtmfCe8AvPluGgm3T2Vlg5ofu2K7DDsqxHuoLJaG9e8uDGZg24Ni+lZI42+STxT0t9hS6vKqf/7oF4A4FADqgaX3psoldISEG9YKaGJnn7G/WUK96Um4BmvYJOSsb5QATEJaZXOm0bNamljBUDI9s4SkdzWobljvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] userfaultfd: missing vma_start_write() in
  userfaultfd_clear_vma() [1]
--

commit 4d41e88f9230b819ec9df4cf29791deea1bb44b7
Author: Tal Zussman <tz2294@columbia.edu>

mm/mremap: resolve uffd state when the context is dropped, not during the m=
ove

This commit leaves userfaultfd PTE and PMD state untouched while moving
page table entries during mremap() and instead resolves it via
userfaultfd_clear_ptes() in mremap_userfaultfd_prep() once the move
succeeds.

> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index ad9d243dc64b0..bf42fabb5afd5 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3161,6 +3161,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct =
*vma,
>  		up_write(&ctx->map_changing_lock);
>  	} else {
>  		/* Drop uffd context if remap feature not enabled */
> +		userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
>  		userfaultfd_reset_ctx(vma);
>  	}
>  }

[Severity: High]
This problem wasn't introduced by this patch, but in the existing
unregister and release paths (userfaultfd_clear_vma() and
userfaultfd_release_new()), can calling userfaultfd_clear_ptes() before
vma_start_write() allow a concurrent UFFDIO_COPY, UFFDIO_CONTINUE, or
UFFDIO_MOVE to leave stale uffd PTE bits in the unregistered VMA [1]?

CPU0                                  CPU1
userfaultfd_clear_vma()
  userfaultfd_clear_ptes()
    change_protection()
      // scans past addr
                                      mfill_atomic()
                                        uffd_lock_vma()
                                          lock_vma_under_rcu()
                                        mfill_atomic_install_pte()
                                          // sees VM_UFFD_WP
                                          // installs pte_mkuffd() at addr
                                        uffd_unlock_vma()
  vma_modify_flags_uffd()
  userfaultfd_reset_ctx()
    userfaultfd_set_ctx()
      vma_start_write(vma)
      // clears VM_UFFD_* and ctx

Neither userfaultfd_unregister() nor userfaultfd_release() increments
ctx->mmap_changing, and lock_vma_under_rcu() succeeds until
vma_start_write() is called in userfaultfd_set_ctx() (or inside
vma_modify_flags_uffd() when the VMA is split or merged).  When a later
write fault reuses the exclusive page via wp_page_reuse() and makes the
PTE writable while the uffd bit is still set, page_table_check_pte_flags()
triggers WARN_ON_ONCE(pte_uffd(pte) && pte_write(pte)).

[1] https://sashiko.dev/#/bug/linux-5cddfd13-146a-47fc-97f8-feca4b2339b4

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-uffd-state=
-fixes-v1-0-00713d368976@columbia.edu?part=3D7

