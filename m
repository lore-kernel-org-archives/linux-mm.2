Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C6E606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ed1AArhV
Received: by kanga.kvack.org (Postfix)
	id C658A6B079A; Tue, 27 Oct 2026 10:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C160B6B079B; Tue, 27 Oct 2026 10:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE5B6B079C; Tue, 27 Oct 2026 10:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9014D6B079A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:51:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 046811C4445
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:51:54 +0000 (UTC)
X-FDA: 85368695790.25.36F7824
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 19C5B4000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:51:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ed1AArhV;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793112713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoOqvyAj0+Jgjt+c2q64ZVpxp84DiEqBDr/qWbcE/6Q=;
	b=JYFLlraL/OLTmmT7onBYIWUz4O+1c2k55d2vEb6Hd8ttvmgR2G7CNHBAswDM5Ksc436r/1
	mSasK2LhmlAdWuYeXJEHI3twzRvfXJl2XVfpSNNfllfUnaCdd9Z359OtIyMIZvdKUXSgwJ
	WYOxOZHSc25+HUW64rYSyteP0zf9wC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793112713;
	b=vNAMygyT2XTMtsugzwgSj5e1/mSzgNDOXcf5f5hDBpX8AnvyX22vExii+ZzwAV9IS4xxdy
	14y8MTNTjHiq1yFnHaXS64EEhzzf+UueYspKo/xfcvBzEEYsBJWTMN8Ghi6dHRe4GTas0b
	hzB0WuE+Bm4sFjChCz99rGBJneMMWVg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ed1AArhV;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A75646021C;
	Tue, 27 Oct 2026 14:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94C61F031E4;
	Tue, 27 Oct 2026 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793112712;
	bh=JoOqvyAj0+Jgjt+c2q64ZVpxp84DiEqBDr/qWbcE/6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ed1AArhVbeUlRbieRogEq16Tc9QCqIZSVTH064+m36Q4VT261rTmozO5K8nEvCkmq
	 dWGW2Ewc91FnxFgZrQlGO7DsJTPWUBuuKpMFYk5PB5SnqrtyzdYta/rrt9N5S8VZm6
	 Y44/La2njGFGVC4t9zam3WRChOsRM1fFS1bhbX6m6sGSsuH+9Itltw/nDpANPUw0Jk
	 S2b0DTmKpYCUKLtLZ/6Fq8Dn3gscIF/3s1I7H+h9Ov9H/jNbnMg3Qg3ve55KzxabTv
	 PDjNZpnaSYLkKtuFscIy3vPPHHBxXwUperQxUc65bVpo2SUO2TFpmMR8MkE6VdNXdO
	 dI711cyyUdnOw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5D75A198004A;
	Tue, 27 Oct 2026 10:51:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 27 Oct 2026 10:51:49 -0400
X-ME-Sender: <xms:gLrgavLAlgkrAhj-6GVk5yLjUj1kyaDiq3PHRAuB8g5hZtL3adnBMA>
    <xme:gLrgahq9Ns9x_c8FHLAL2iQ29lp-hr92Bw2cw2gpp6xFzPUbsAt_MgBkpxcEL9Qso
    VTCqJC2qCdFPNYFJk1IFe7oQ3ugipZgsgosd87cO1r_YL9q7BICvRYm>
X-ME-Received: <xmr:gLrgaigHnEu2DOyJCpY49eTeuHuI1p8TjWFQcr3g-i1UMc-y-AQAr1B7orc>
X-ME-Proxy-Cause: dmFkZTGhb5CCIEhi8YRVlZWXxywwjLDCiGKJTqYq3TGxohkiie2e7b08prnm6qm3Mgq/Xv
    f8mSL32tsLRpmgHaz6MZN+ZLdDrreydc6PdATZZoDlZZ4l4PoJjiJdhSudk3RV1jcJLsWl
    oGA9pKowkapDelRVuYlxCWlLeI7Z9/5iCynDokopMlVbGp8TOM3/RjSN/h13nNEROePlRY
    T35FzV8bgHo+mgJ1f+5oYNw35uJOWghFaZlb9xVnbDVCacqulVDS82UMGOBzg1yx5ECtZJ
    FuUQ2k/l29twYFlZP1ht6lfqh9RlJqn8qcxxQSBg1/mtGcYkOI8JiYt70URezpQ7kmjRmV
    J0aWJh/2p99Q5+2naRg9TcLhY7jPBYo2JWuKgkFL8E4JXBF2S0D8yAS+GGxhVRrDOgc9BC
    sMOKD8Wl7RYrMPEiZQOpn9PekBFgU7capm2o7nIlInu72F6Xp1aDS5bdkZpG9R5GaJJCR3
    56gL0cSDcpTgU9GBjEaKbu1mje0wR7SzmSZEBZumtk18Yekozk9oGPdB9y5v/ze1OYIaSX
    tF8S/frgaX2ZSwZSJSxf4Jsr8L8G6idJw06leYWdZ26CGTfqBOijN+PT0bh+d3bnyy3g2n
    92jz6sAl2//Fv0Kppx7hFvHhS12BccSJOh2PGA7gOFwihsIfKg8mLHvpsSFg
X-ME-Proxy: <xmx:gLrgaumHM46mCUBbbnYEqXur4opZmpmG4YXo5V15tjjpYM-Mc85uPg>
    <xmx:gLrgah49HVzBmPghZOLcaa4hCoPYdU3q6YoMMqHVA-Q7u2TyKQg52A>
    <xmx:gLrgaim0om9HQc7lD6Tc-7i8r87HAvGK3UN41DOa8xgFZ_UxpPTy2Q>
    <xmx:gLrgajiZQVCrpJT1ZH2Qks2KtrpGxe2s57jSA7H7IlInRy3VksMJAQ>
    <xmx:gLrganlsr6aI5eIKIEcQYttuzXZA1Q_Yq5sz8KY9RTMvBvSmQ70WtJOR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 10:51:44 -0400 (EDT)
Date: Tue, 27 Oct 2026 14:51:43 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	kvm@vger.kernel.org, =?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
Message-ID: <auC4eUEN52PJF1bM@thinkstation>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-4-66f00b7a564c@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-4-66f00b7a564c@virtuozzo.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 19C5B4000A
X-Stat-Signature: t9s1oesdeus5m1fnoqqoxmnxwixakeqm
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793112712-55252
X-HE-Meta: U2FsdGVkX18BZdUVTdqP1GIwNeG8oAJq8TR2Q1XZlf+gXUrai8aUwMyiUyRF4gjm3Ck9B90wHSyhPgAgUiTT1+SbFESnRSJwl2rAISMPdMM+JJdkVrZu+eAt/whVW/1iFLTmdYbekwtLLWtejOS1QDccxJgtRE+E+If+16gdvQ/WsYuafLsWKMr8fcP9VlJRGnSC1jvw1R039m9YrUTzBxPK5x4Ws8S/hfwfNJSnfeN9EKnSez/3Ex+QyG9K0gxDTaQpU0jMyeLHWRNLotlN7/AgdA6zFOfcK12w6pxyyFYKH5BqZxG+cC5Qsna1GrEeoXT2GzoDeoiLeb13Lwgbu7FGsxwrimNMmiYs60faLDq99YeRVsZQma6felmCvjUHWcTdIF52HWm+FyiX8EbXiuMDUIVWiV44Sf9DSpxVyfV00Gn3WILvBWvzwm7NKhd1FgVseIjb7Tw1vU2g6boCFbpXvbFnpNzsdTm0QymFw6JDFn1Jzot0j0RKOkT+nwwXrlUFkrIscxRuqjK2TKfc+7Scja50bfqowPIU7zwUDzY9KjDLI6jCXLCO0MguFQkKbjvHlXlCEBoI/hwvsxZWFUQu8w2ClUt7gsMwKGAwoufSW4IqlfaBJn+pPIk22rF+Rh08nFmKuPR1s8FZgZHpkGnWjyy0Zo2NUNnDln/QbST2fYPSUo1BD7ObJoA9ExvJ2p3SxOSikqUzHcXPqdDEnn3UPm/QCwMJZmXcQWO/eCznUHk5tLm8csfsMMamSeqFPOYugqfrgT2jbIaNyyLEPtxIHSm3waXvwuQU7ixik3AtzHCELw+BTNEv2fClzAFtEE4VhN2ZDtqF/8BLzghKKgweWL60d3eb0kRsWKYjILkmsqvRKQytUrdTL4IFtkQc+gTy7m28OdYLvO7vNwfhOCb6kQR4g57vn7onoeB2X+fKgGxtacB9ZYHg4oONER/T64ZjIVpnuIbHJ1F6t5G
 sUlNCyDK
 +WJCNoxLorZLxLN1IQ4KmZ8F/9EAjVMe1mZc6iHTd5DdLFfar/5sxUAKM/G4t72Pzgp9y4p3CKp822AudEjoIKwxqbFXm5Z0QZCni0/EjsaPtYB0NRoVUpZCa+EkUZafK2TrsQ5RPcV08bMsqVkQvE6WTHydilD4MEu2m22uBItE2E0O5tf5kDtZZjvF4hZDXEyuBRig+F5dLiJDyg4KBf2nzId/mUpTzd1DW+EGC6g3TQSJx926c6Tzg+r8yy5MSpM8v3KbUjIBo8JP6CIeg8SgjDcG0llNvvUGDfcdf857dfgf3a4Vij9mx92OUxExdSCsDwmqV/euaRrBY0rE9qK8+BJPRAGjcfpUk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:36:03PM +0200, Konstantin Khorenko wrote:
> +	/* The child's exit took the parent's share off the counter. */
> +	if (*after < own || *before - *after >= own)
> +		return FAIL_COUNTER;
> +	if (*after != *before)
> +		return CHANGED;
> +	if (mem[pmdsize] != (shared ? 'c' : 2) || !data_ok(mem, size, pmdsize) ||
> +	    !check_huge_shmem(mem, size - pmdsize, NR_PMDS - 1, pmdsize))
> +		return FAIL_PARENT;

ShmemPmdMapped is system-wide. A drop of 'own' or more from another
process between the two reads fails the test instead of being retried
as CHANGED.

The parent's THPs can also lose their PMDs during the test: reclaim can
swap one out, and NUMA balancing can migrate one, which leaves the
counter low while the migration entry is in place. That gives
FAIL_COUNTER, or FAIL_PARENT from the exact count in check_huge_shmem().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

