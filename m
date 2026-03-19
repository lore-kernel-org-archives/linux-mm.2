Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F76109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 22:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674076B04BE; Thu, 19 Mar 2026 18:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E556B04C1; Thu, 19 Mar 2026 18:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5333A6B04C2; Thu, 19 Mar 2026 18:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41B8D6B04BE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:51:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC34F1A0737
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:51:04 +0000 (UTC)
X-FDA: 84564309648.17.A8F92B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 195CD4000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:51:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=etPC9qcP;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773960663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5so3PZY2n887JNAefu0ds7YrtNbvr1RQ1WI871Nx2WA=;
	b=BeYYkjY6K5ypYtBj9GNSEwABGiM8NQ1M/pZHkFSooxLHyahXLCAQbfy0QTN1lZtSvPtaN/
	ghATSgggYWW4X3ZjwZuH2gF52+lyu2VaaXZo8cO+uwH/es0f5t7U917NGFjarmCCX1rwzx
	tv6ABP5nDJj5sIixXazpdpMsvwMElXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773960663; a=rsa-sha256;
	cv=none;
	b=Bdr3Vdy0+KD7avF33Gsv0JYINARl4a6QTVjhk5GnUgero8V2TmJUHUeLK36Uy9opg0msFH
	Si2mcEQ2+GqHsCYgC2jlc2YKGTXZlyTqwYN9qLfAbM47mxdGk+P/Bu+PXbCFuyvQRD63Vg
	GCElCejQv1iNcXwy8hFzLMrdeD1hrDI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=etPC9qcP;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4863E60053;
	Thu, 19 Mar 2026 22:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE01C19424;
	Thu, 19 Mar 2026 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773960662;
	bh=vUXZ1t6L+AQena7M0H5qvtE/6leptmDNi4JCNpcaRzc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=etPC9qcPo0xzTaPrefZs4FtAfsWFLYEFfb33sEdiB8r8IK6klCxkkny4j6twe0L/S
	 GP9L+j2Ug2Tm9djr0BGDk4rY5PVicBAB+HtI0ekwF6vDUdlmfzG0trUDbX3Abd9QVr
	 FebV6Mt/HOJmeqgXjcRIev0zTSvLSj+4OHPAnspI=
Date: Thu, 19 Mar 2026 15:51:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
 <Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <baohua@kernel.org>,
 <ryan.roberts@arm.com>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
 <sunnanyong@huawei.com>
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
Message-Id: <20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
In-Reply-To: <20260319012541.4158561-1-tujinjiang@huawei.com>
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 195CD4000A
X-Stat-Signature: fdbz4t4xm49dqigaqdhux9dn5j4o3rmp
X-Rspam-User: 
X-HE-Tag: 1773960662-774901
X-HE-Meta: U2FsdGVkX18ox6bMVz21g6FKhJZA2eiNswTihPrrWQjaqpNt3pB0pXQ3K+PWaJX+u5oq1r127jZGnfH8EjVb7eeUMD9q/udYCfj00SOr9Djs3TTxQHYcHHWRCMamf0QcFEDGuiZdpktBS88HgnHEdjmJ1e6TkcjByF5jjZyfqRgum7VurrVT/Mg8H8gHFsB9VUF+yT9X7o7aoeg1afknmekUYfkb0fW3WVsDaKNY+HjgLYDtYSjCwYJtEsfGuHQbxRuCodL4pV2CIO33lbJaeJBq41Zdn/PVmITIuhfEid30BHXcnodKMTBVI4jgMYMDgmLU5tn3s01Rlq+o5d0K708SntvjfkBzDF3rcAEaA8uPle9pSBwVA+HHe5uYueJxhRj52V+snd6zPBp98EUpb7qHiK/WeRrHXh29Rae+rgQrqXLUEx0StbmmKmYDA2pRqDs+4kmy267ia0b/O40sMlMdss6VCSh618KIT781nNOB5XyIZjI011NMQbkXiMW1Q7aZYosAwKRt41oVNIqk4WdAMXAf5rSNKVi1LcnEOjpPeqTCUTbkL69laZssCgR6sqtlh08rlqX/7eqKEaA19l0LoBkQRSi0QAVQ9icuRYCZEho+sbXA1rGjtzx5MHC7c7HarsO1Qpvz3un4fzEmdHTesSQqZfHFZuXLDhKeXAR013VoiozRMJYqFdI49ehSiIso4oqqz3B5GpxwZJqKr8WesNPNmS27ofN3VO7TwUoVb1zZrqQkunv57twByowMWAc0JkfEwMFsD9Z+dg7hct3SKJWFVZ3yUxufKQtZ28WK1RtJD4tleb6brcP9Cy022MBDhdvsxBzY7+rt34YsSQP4VNzBTs8HEtz9seuspI6mGCbTRPolkx2YAhi/3ezrDofc6m2waT4Tf4Q/oGqXNB0Ro6KmMzYq3onewhphdA6rH6sYa6+eu1x0OdtcHFbe4RR4K/43rwKrEf3mv5L
 kgD7UMnf
 CLYXIcIw8v0+3SGyezYPXtdrkhT57dUPK1A3UAkN8YXSbFyS4sq5xHohbpdrkfSAH44Vq85dyXvY3XAgWZZ5OdIlmZAdzO0omBaPI3Yc+mfpknIlJrRmjbgTZOuexcpTj1nXMhJKlV0ZJKTvlir/VKnGDjyIk0OlMehK3T1IlTYDR9ty4LnCRFBcc6CjyqM0Kgx6oFmvLZ4R3yM5Xjgr6Dk7Z0uRg+i0mA9rkwkHSatDj4Wzkjwgo+ob9Clx3vrsIcK5l3XEt4gWn6mj702M9FzMVrzbuJX9hP1Gdd5Hh0XRj2YkjOhe9vLdUV/htN16/0MPh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 09:25:41 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> On arm64 server, we found folio that get from migration entry isn't locked
> in softleaf_to_folio(). This issue triggers when mTHP splitting and
> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
> in softleaf_to_folio(). The race is as follows:
> 
> 	CPU0                                             CPU1
> 
> deferred_split_scan()                              zap_nonpresent_ptes()
>   lock folio
>   split_folio()
>     unmap_folio()
>       change ptes to migration entries
>     __split_folio_to_order()                         softleaf_to_folio()
>       set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>       smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>       prep_compound_page() for tail pages
> 
> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> are visible before the tail page becomes non-compound. smp_wmb() should
> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> result, if zap_nonpresent_ptes() accesses migration entry that stores
> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> page before page->flags.

Please describe the userspace-visible runtime effects of this bug.

> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
> in softleaf_to_folio() and softleaf_to_page().
> 
> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")

So we know whether a -stable backport is needed.  Thanks.


