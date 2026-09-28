Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD1EC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4FD06B0088; Mon, 28 Sep 2026 06:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00786B008A; Mon, 28 Sep 2026 06:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15F86B00AC; Mon, 28 Sep 2026 06:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9BF6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:12:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8811AA438D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:12:47 +0000 (UTC)
X-FDA: 85262757174.17.37217A0
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6FCA180008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:12:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uTOWcWNU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590365;
	b=pbZiVCEwOe3Hp4EjmohRrU3kiS4q4H1A38myLA664PbucyIRUG9uUku4232AxkusZFayFb
	SGKnMBACcjyRW103EffdC3rYTcgqRkPRX0MyziNEYTZaK9Kov/e1LeGVOIVtLxTlOTZMiH
	SiZx87kq0K4dCNQh249qeNZPmv+McuI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uTOWcWNU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBAqlyCCzFTRMIjxXizxbOK6QJvH7vJde4Sks5y4Itw=;
	b=cxhDyKuuT9I48+HFayEDIVPGYbH4gtuUmJ6UYExpwEg/Lfcp5SBGZkHMC4K3SFDvjPlM4e
	uhnSB+gzs2YC+qiUP9SGSTc9/UP8jvBQnSJcjZntsokQ9VANVoGWGx0JPqestfPR2FSYkv
	He28XIh9cHXdw2IFX+nfU9Gi9AHRwnQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q4xAGKPGxcoFFfuM4LGsU2g/MmZVXW7rF2LcsOPAOn4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790590363; v=1; x=1791195163;
 b=uTOWcWNU/r1xelFwtq/YWm6xSxMGbfsSwD3fgLITgq2bGgadfDfDIGXD7O90FBnlCGGORbCa
 xaIz1KcG97g39CoLb/WNYG0LvPmszE2uY2Tqsv8az4ZeVr+UHqmYIyfXIMzfG5m9c2IXegHeheV
 tnxNkwUgWzrp1j6Ccr7goPXc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 52ca14a05b391034;
	Mon, 28 Sep 2026 10:12:33 +0000
X-Mizu-Trace-ID: 52ca14a05b391034
X-Migadu-Flow: FLOW_OUT
Date: Mon, 28 Sep 2026 18:12:30 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Dave Young <ruirui.yang@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
Message-ID: <aro9jg5VN_CRBK7N@MiWiFi-R3L-srv>
References: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
 <arovLO37djQderTB@MiWiFi-R3L-srv>
 <21abd60c-e71b-40ed-9506-853d4485cf4b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21abd60c-e71b-40ed-9506-853d4485cf4b@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: ab7caddtr5bcieji67m47dnoe3b5ga1g
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FCA180008
X-HE-Tag: 1790590365-595110
X-HE-Meta: U2FsdGVkX18CR/jPrTNwQOhYLf201IpY3YWcmQ6c/71CJ+9xmX/EjkoQNLUpqFpZYKtOp/JxtJPLW4VwAYHmeM+Q0CZEIFsbcBRhJnee/hbS0r4Ijk05q4R5eY4KfC0O0r4kxiE1pv3XfxdMPxKUwtQtX3mWe4jkczELBn1FYE0mNzA3nwmukN4iQbU5MBo36SUmJzper/x10tva/avmg4gJ6jZBiweYxKyPHixmL/aFH3Snkz81TVNorOVqtsuiZ+/MPDRYgCCTd97m/c0u4FkWt0b3sP09WRFnghI+BnsyFgW4H1D4VYViFUrqQGcECr6xnIoDoEpVeA8jNMF5Ico5C2KeNyGhRi3QVzwOGdPtD7xOC56/CnOjhi9PLNdhprm1PF5Jhgq2Dg/iJzRrTTkyL1UBMaF91mHQyZdCT04PIqZVhreIRSXCWfF41hXhBJne7+JPiStY//wEeWL7AU1SMEZamyZ5U78zWXqBivyCjiBn/N972grVrrrqzsu+vcNIv7fGJvsrbtIRJ1iyasPBdwr4c88lcMLi0uhiji/BMcqVuTqGzXoxszA0wtK5RlbNJByJ4I3R4rfTS5+7Ue59TxrN8IpDGAjiS/1hnaih6DLIEZYcOdqKAJ3TmkeSf6s+HHXPH8mlJnGFXtidcL780+8UEqFml9bqDWf8b9hmv92qsWQ5TTsnmv2n9vQRiOxl0H/3aIWq2HdPpnCSqemRoAhj7/rCS8ehhLHY31OpFCzMIyoZaN2WBZh1it5nh2VM+7xrKS2EcSWIi/9XMOQsFgqOOaV9U5gk26Glk72rhhIJ8a21+Pm+9UApoGOLboutdS/6WDO3N40znvixI363wGYjm7JEH6nCsGMIfqm4EzyeulKmxsz+pv8TDyhSVW6G+0Mw1pMy1QQoT0J8lx7u56WTRj8gBVu+A09dzDq+r+EPZnEv6I7D9AY/W4+mDZRD4CweDc9Hty3lygd
 SRFkAOYn
 +jGG/B+s3/r5LVkps9yLYCXDCMXi05G1261i5ad7MT57tWpQlscdtR/fglPgWDj2vBu4TMiO5E/SokNeg1CvrwZCHkl5sY7HGKBC+4jSQeH0/PdWwDVtrLrabeaFjPy+fQ5atcH5mftscxw2/jFEDm3xaRevBzdkC8TsVPLRRXL3HNtcDkU3mX6u0Mci+esUPGmAaYFSaFLAzYY3Oki2p1qzsx3ZHw3qgI80QsZNu3e5j5aQMsRc9vB+CzRM3k6/ZOSClSreDQoXe9tDev1iQHxo4eL5JKCPulzmhmOusuq8WYmlLZk02/rMnJJ4PizAfktf8+rBcBXt/cHDsgGpcd/uriZgMCAmzGwQ3n/e1s3aSsL2b9/x7FJdxuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/28/26 at 11:14am, David Hildenbrand (Arm) wrote:
> On 9/28/26 11:11, Baoquan He wrote:
> > On 09/28/26 at 10:48am, David Hildenbrand (Arm) wrote:
> >> The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
> >> needs similar information (although still relying on
> >> SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).
> >>
> >> Let's just export the value instead, so tools that work on vmcoreinfo
> >> will not have to guess.
> >>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >> ---
> >> Result of the discussion in reply to "[PATCH v2 00/13] mm/sparse: remove
> >> SECTION_MARKED_PRESENT and further cleanups" [1]
> >>
> >> This patch can go in independently. It would be preferable if both
> >> go into the same kernel release ;)
> >>
> >> [1] https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org 
> >> ---
> >>  kernel/vmcore_info.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
> >> index 5a417f8a922a..7833a36064a8 100644
> >> --- a/kernel/vmcore_info.c
> >> +++ b/kernel/vmcore_info.c
> >> @@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_init(void)
> >>  	VMCOREINFO_STRUCT_SIZE(mem_section);
> >>  	VMCOREINFO_OFFSET(mem_section, section_mem_map);
> >>  	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
> >> +	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
> >>  	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
> >>  #endif
> >>  	VMCOREINFO_STRUCT_SIZE(page);
> > 
> > It would be good to add one section in
> > Documentation/admin-guide/kdump/vmcoreinfo.rst, e.g
> > 
> > SECTION_HAS_MEM_MAP
> > -------------------
> > 
> > Indicates a memory section has struct page array (mem_map). User-space
> > tools should read this value but not hardcode it since the bit position
> > could change between kernel versions.
> 
> I'm not particularly happy about having core-kernel defines documented in
> kdump/vmcoreinfo.rst, though?
> 
> If it would be something vmcoreinfo special, sure. But not for basic defines.
> 
> "See the kernel source code" is really what anybody using this should be doing?

I can't remember who suggested adding this document. The benefit is
users can read document to understand how it works, no need to look
at the code. I don't have strong preference on this.

So I am fine with both. Or we can add it if anyone really complains.

For the patch itself,

Acked-by: Baoquan He <baoquan.he@linux.dev>

Thanks
Baoquan


