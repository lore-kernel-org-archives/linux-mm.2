Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC6ECD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 10:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F666B008A; Fri,  1 May 2026 06:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D427E6B008C; Fri,  1 May 2026 06:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EC86B0092; Fri,  1 May 2026 06:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0D546B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:41:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D7D8A0222
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:41:42 +0000 (UTC)
X-FDA: 84718510044.19.F68BE1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1DA8B140004
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:41:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnB+pKBT;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777632100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dG8+plN076bfrFQ3LMDIi2t3iZQqA/V7+ElzA5hhE9o=;
	b=sREnEW881eHu6xepLNOGVKPjbMg9iuVXBl3mA+tMC/3EvNtGdhvioHQjOfBcXTWU6pvR0U
	EcadNFJqTet5fDinCLCdtI3F595HHHMRzvEUMnJ+j3L1J8vAOOjssdoc5av4JHb4W8ZOfu
	7xb2KN5h4+ouCtKnQEOC3SsM/VgaTas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777632100; a=rsa-sha256;
	cv=none;
	b=AF6ae/tPR9ftSQ/yMjsL9XycWPjawESr9Dk95CxUJLj9ALF4/bzkTIjAODPaIpLCR79bsI
	KoOl6TeJuI95THgcoE0Sru8RXEuGmLaLE8YBqZSV77IFy5aw1QW49vhOBHFMMeXls67d5K
	t/IRbqOBP6gBt0mPJ3Ss6vdy1fmg3O8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnB+pKBT;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BE8243471;
	Fri,  1 May 2026 10:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835CFC4AF0B;
	Fri,  1 May 2026 10:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777632099;
	bh=zG0cdIpqGrSUk2e0Yn+pCtQM9mDMXSK9RTMePPjgQUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fnB+pKBTokhVGJuDJN9IgXLZgBgg09jlvv+bsR8hb6uaLf76tr1KzLGxF+/GCSjer
	 2D29vaBf9nQwROhDNX09xqsVTwnY38mZWOBahE6sDiR1q1InE2UBpe/bJ0qI8QrWUi
	 41KOmOihS6O8kPOKwaDpPLDgE9fGMbPVIHg6C9MxxkiGD9PsWJEL9Mynz66m10hsli
	 Da9EFM9UpZt99E+QDYiGt+TI2FDKwEOt+O4By6AqpRzfafAxV3jo16bjoH+4keL715
	 1R3PEuepwz08c5hRNIkpZ1jo/FALM44qjuIK6cvqKUcfciKbO3xD9zUa9VoWdPcK0O
	 MgrWMIx1lrlqQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7C44BF40068;
	Fri,  1 May 2026 06:41:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 01 May 2026 06:41:37 -0400
X-ME-Sender: <xms:YYP0aZN06RmVqMUSnMjk7NRoE7xJNkvoT7DHftyfyVzRQ5vc7zcfVA>
    <xme:YYP0aZk_XNWfWQrpYD8zDV4kSMkoFuykiICxx3sdSflnWtTyGL9dCF4becjLPW69h
    g3ot1Z0qmhp8T0w1d4S0G5oxfzqD7ixkSXaFDDmS1Z0tbPSO0ZAdjs>
X-ME-Received: <xmr:YYP0ad1P7V8V5tSdLF7sI6CDaKilTeyvZidMwGpgYy-DrwFh2zPHB-Ju9b9bdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekleellecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgv
    lhdrohhrgheqnecuggftrfgrthhtvghrnhepgeetuedtjefhkeeuiefgudduvdfgvdeiue
    eigeehheehudetuedtkeelhfeihedunecuffhomhgrihhnpehsrghshhhikhhordguvghv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:YYP0aZWiZApYblD-N6cQEHz6QtqrsEqvEOw2unL5khPHcR3R_53ctQ>
    <xmx:YYP0aQhnkxK9GE-6qcefPj6VSn2jPsN6XkBEDVzgR1KvO6IY3-Lctw>
    <xmx:YYP0aagqewTE3OQZ9zFGq1-wp4dXwGODRGx6helK13TyuhnSYzuPew>
    <xmx:YYP0aQuovEgr2tAjxRgxYFOgURqX6Gnvhm80YLa-0SD51FJpInh4fQ>
    <xmx:YYP0aTSByjDZzE51VF-0XGGywziZbAzVBNk7pTuSOdNzpDuXYM2Gxc5j>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 May 2026 06:41:35 -0400 (EDT)
Date: Fri, 1 May 2026 11:41:30 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 10/14] mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Message-ID: <afSC1NHWzrtA-vmA@thinkstation>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-11-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114607.4068647-11-kas@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DA8B140004
X-Stat-Signature: bz41939f1nnxi3xt3z1b3pbhxijrkceo
X-Rspam-User: 
X-HE-Tag: 1777632099-877518
X-HE-Meta: U2FsdGVkX1+yRBoe8LoHOrJ05gDb4/K+WhnDr22UYu7Rbgx/F9KW1Bz7jGJGqgyCoqUwVnrHCFd8/cHFOpjmG8AaCQPm1y75ZoxLC0XxC3Jg0uPaLnvKyyNeD2KNOhyw2BqbJMMZiJVSzV+CUXd6ebSVuitUnPwf4xatxtoNnNO/c0zzkxiq1gsgG3k1zj+hYzLzrNoalStp80V9snjNksK/HopLbLTDGVTtMvmtjMP0wuUYoLm4a42+6jg/hBScgunEaLCc8wf3Nc0s3Afezf31W+nfJIjF6lCjCKYodF81x9iSeV7UTqnlmFbV8Id7oHwKo7VSpSJPaxWNE8Prs0Yd8mZTUMVPtLJmG26qB7K2EGNnZ0GKFhEg5lHPezAU3E0HBhVGOwrpB13BbhupRktFZu6VXDqDzXg7xIpwEXh+eP1eASI15EonNcYcN33c5NC9oRJeliJtQUhnzwRjREmRjs39cw2SwX6gZmaYxpVEn346A3o9T/1Cm92OKsAl0pukY7QrqiynJXLr42i6FejoV+lVLgPCfOn+hau/mPu9uWBtBk0+SqdghOM7LlVbFdb33Exh+l0PBH5r8QND3Rso7odYsptK3BkILQQsg9z7pzw6KRyICGpEBlfLNVg13Cgue6XYc3YdTNtOC29t07OXUQx5l0CS50xDcvyxjfZ2PxroSqW96CY4OktAaY2p4TkIQEprapo0g3Mfmyc60KfUBqVznXM9gBiOPTaWS0z9LCWtdovE2wA4k8QJa4WIDN9dvzZ7wliabxerU2yDZMehLTs7Qxo6FxvMiITu014+GbILE46satMy4BY04zL42+VajS303ClIMLChxrmZcPJWsQ6C4s4c/ZlWc4rjIzYmmQtMGA2qR2cV7p8ZJYihSl3NF+ARZLH5kmCkClY1ivUVcXSgKSdc+SXPzZrngYJFPUPQEaOAAIb8JeucvZH9BAUjaqRYWSjz9sZrtN5
 QY0bE8xz
 8N3Uz3100kfvaAF31nvmpI1vdd90SbiX+vB7tTQTdyjsA557LtMvvw1jhCZI+om+wtQYJujRLXWCA/jMP+wOMPko7ZIxyveeNuVjKEKGMprGFtWVaQZvsJoaoHguW5pueDnhf+TQprDJssVDpuG7RGInGqf95pK0/kcanZmwAaANrfGbZ65Tf/ngMVyv51tCq7UyhIT6pv4SPvYQ50torb8h6arAUu5zFVs9GK1wJOGZaOdt1d7D+2z2BILO5P0S5oaAQVpbdrqzascwpS+igYQpcN5w3BtYV+gcIBeEabqupne2F9zj84cT7vQnHQJf61bco1+cq1XfBTRdwBBZbZiwX4XnD8YVlxztARr4lxiSuTUD2Eg0WXG8rWhwlUl9+mXcRcVmxeqf79JUTgP15ofVSf76KTZbv9o0M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko.dev -- https://sashiko.dev/#/patchset/20260427114607.4068647-1-kas@kernel.org -- wrote:
> commit 6d6b8f986b2959f8ae0932deccc5afa4ec485813
> Author: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Subject: mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
[ ... ]
> Does this new PAGE_IS_ACCESSED tracking correctly support the atomic
> read-and-reset workflow (PM_SCAN_WP_MATCHING) for RWP VMAs?
[ ... ]
> Since WP and RWP are mutually exclusive per VMA, userfaultfd_wp_async() and
> userfaultfd_wp_use_markers() will return false for RWP VMAs, causing
> pagemap_scan_test_walk() to return 1 and skip the VMA.
[ ... ]
> Because these loops hardcode a check against PAGE_IS_WRITTEN, and RWP VMAs
> now populate PAGE_IS_ACCESSED instead, this check will always evaluate to
> true for RWP. As a result, it looks like make_uffd_wp_pte() and
> make_uffd_wp_pmd() will be silently skipped, preventing the atomic
> reset of the tracking bits.
> Would it make sense to update both the wp_allowed check and the hardcoded
> PAGE_IS_WRITTEN checks to accommodate PAGE_IS_ACCESSED for RWP VMAs?

PM_SCAN_WP_MATCHING is the atomic read-and-reset flavour and is
implemented for the WP marker only.

The silent-skip on PM_SCAN_WP_MATCHING + RWP VMA is not intended
Will fold this fixup

        if (userfaultfd_rwp(vma) && (p->arg.flags & PM_SCAN_WP_MATCHING))
                return -EINVAL;

We can add similar operation for RWP later if there's a use-case.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

