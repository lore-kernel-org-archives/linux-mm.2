Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6345D6CFBB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193606B03A2; Thu, 22 Jan 2026 23:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171346B03A4; Thu, 22 Jan 2026 23:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E316B03A5; Thu, 22 Jan 2026 23:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC40E6B03A2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:32:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35DFCC0592
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:14:26 +0000 (UTC)
X-FDA: 84361760532.05.3245BE0
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id 49BF31A0009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:14:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="Glub+WC/";
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769138064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeK+G0hPOFdh2yEuTyh3ucyQ2F9JnTmRYxCciu+ySd0=;
	b=3J+cIShYIhVpNl2rFyxuY/AQuCit31SbESRoqNzC4Ut1agIZ8qC/fnaPnFh7u13WNLloQx
	o9VwORPN5o6sPFsbymjfu9/cNuwSvwUOxV79VlghV67OwAzPGj846a7lp17nJAZr5XYROA
	87k1LdUSiZzm1iJH18mPQ8JlUb9xUvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769138064; a=rsa-sha256;
	cv=none;
	b=ptgNjPJHy+ev+598Oq91c+ptqeYEnCnpQM26Zi9uHX7AbEzKpkvWrQx2oNPXTh/tkTX5ji
	WQ0mhIPL15lk66L14CrWLHHSbKk94UE1WMPZx6SCqXjrHYnNfsYY7+hoy8JhzVeokIV2na
	ymY5ynRv1oPwcmk9dnNkPTR6NvRyJRs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="Glub+WC/";
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1769138055; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=IeK+G0hPOFdh2yEuTyh3ucyQ2F9JnTmRYxCciu+ySd0=;
 b=Glub+WC/TQQbKoxk/ZjzJV2PEN1tn4eGYs1eqpVtYTsL+jXgQMhPY1n6wqdA8uzQ9zba7b
 GD6gm+OpzqKFljawBSa+D9LQCON2WUjJV+ijephiHbS5gj8rrAD8cZvrPRgUsK2mGvZy3M
 Jjucu7+rdvI4V1q2kykDTtSNxe/KvPiEpT6tpJ4ffiZOB5EVR4LgVvAFVFTGhKqzp5n0Xn
 CrOu2D/F07n4b/YrW714IMsndfJS4CsBTb2R3Nx9ey7YUu2f2N/wZblMuU72iFaOZjD/gk
 meYMQpamH2aj+CPGjwyTClDIc0pZCiT7rX+KSQq9yQGm/GLreyW9DlkIQm0c4w==
References: <20260122141900.3eb028abe20f6c31808f9b5d@linux-foundation.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>
Subject: Re: [PATCH] hugetlb: increase hugepage reservations when using node-specific "hugepages=" cmdline
X-Lms-Return-Path: <lba+26972e785+163151+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Message-Id: <20260123031400.37480-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: <david@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
Date: Fri, 23 Jan 2026 11:14:00 +0800
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260122141900.3eb028abe20f6c31808f9b5d@linux-foundation.org>
X-Rspamd-Queue-Id: 49BF31A0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: jjsq3tbsr6b5isef766cfpyaiyx89q1z
X-HE-Tag: 1769138062-703513
X-HE-Meta: U2FsdGVkX18dZEgCSE111TIdrWAkFoQLjo2/i+Phnl7PrSBmD2q0CssLy0E7FNE/HVWmwTmREvj0M55SbsJHO9jPAY+PyC0MorCvddDg6kl4/rVXUt2Qj3dzWedNitlvk9hTRIrLgsYXJQ8jah6fNpJ731a3jeWBg3fRjJ4q9BS0Us5p7PLx1AFfxl232HWh3KxOM7xFzMrFllQ2dGdAMC94rMb0Rh/7ID6nuqWUs31He764ywJf/uzllI3v1AMBiuSCXM5WA/G6EyiNpdk1XuXGlj42GCWoWIs8DSJ6jtsXtNarzujyNa4ZPFwnhJGzFM/Hj+CqjUlqcRks6/mOyZKR+mmrtOh8j2IxnuOq1doeYa6DnNUDR4sNeFskvcCT1n65iksTMDKoTqzOIl79XJGTturwtncE+7Ly6Kw7E8mS5y2J1aP5ZP/L9d6oDWUEyu5z8fUjurIv7OLKQG6tcRs8sBsXGrf6Z5t0vr6SY7AcW8g+/np3bmPgTYLIs2dZmmNerjZFM8MVJvamJQIyIVyZgjlcMPaLtZJrbiMjALvAfv55MTKiGfeUvKRcqj2jXMnOBGqolrtjR5/DU+Qr0XXqxq0YxDaXb9r+j0OPl/sgS8ODvto4AS8taX2HZZ7NHbokGuZfW/JCTRSQQ6g0kEK8j2kxzzZvy2N1+hItiNmmms8m9imkloQEYvLn5S486jsdYpqym2hnvUYJ177Z/bMY8fAR14YJa5/3J7774cnuNfAi8nMb46/OouFwpTda7bLmGKB1zAJq4P6rRyxo0UOgRbim8T16NHWqJgAxYzIiMbZ3iDiMIgUcoxgYTapY24qNgqOwlBaOfj/sF5Y3dfnUU+Bz1nZisrxVTIAMjCvLq33+vWz+9sNevwND9A194T7AjAK4eJp5pvejOnmf65DOoc3cGuWAuiyixOqy5sThAYWW/FTJB/j3pKQB5mAd3dLT1nghut3Gtonfs1/
 EEXzTczT
 3XIXJ0AzUf6y2+LXBneS+JSzXDAF2Y3S/U/rapjnuiNcSnjQeQZuwCUc2FSzuQtUX2rYObosRLBrqox9dIfaPNq1JE3IAeV5u99CYbgnolOHyLlpMurNhvCusvvMUOawL0HnjW8hx6N/uZKQKhjJZXpko9RYSgy/BKU/hjCiX+7NL4g9LbhOnxYyKeF+S0nRKMDdRZoe3DzJCgG1Mqu+snM7QuBF08F8zc/mcqGaAjAxoRtAUxp35Sd7rOdTQR+PFpBlH2pMjYOKLwygAc5LQgMxP28REBNqqlgYuyCXseC+g0nxg47U+XvLV/paw+lUPYQmE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 14:19:00 -0800, akpm@linux-foundation.org wrote:

> On Thu, 22 Jan 2026 11:50:02 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
> 
> > Commit 3dfd02c90037 ("hugetlb: increase number of reserving hugepages
> > via cmdline") raised the number of hugepages that can be reserved
> > through the boot-time "hugepages=" parameter for the non-node-specific
> > case, but left the node-specific form of the same parameter unchanged.
> > 
> > This patch extends the same optimization to node-specific reservations.
> > When HugeTLB vmemmap optimization (HVO) is enabled and a node cannot
> > satisfy the requested hugepages, the code first releases ordinary
> > struct-page memory of hugepages obtained from the buddy allocator,
> > allowing their struct-page memory to be reclaimed and reused for
> > additional hugepage reservations on that node.
> > 
> > This is particularly beneficial for configurations that require
> > identical, large per-node hugepage reservations. On a four-node, 384 GB
> > x86 VM, the patch raises the attainable 2 MiB hugepage reservation from
> > under 374 GB to more than 379 GB.
> > 
> 
> Thanks.
> 
> I *think* the hugepages= documentation in
> Documentation/admin-guide/mm/hugetlbpage.rst is still up to date and
> complete, but can you please check it, see if there's somethig we should
> do?

After carefully re-reading the documentation on the "hugepages="
parameter, I did not see any points that could or should be optimized
regarding the number of reserved huge pages.

Thanks,
Zhe

