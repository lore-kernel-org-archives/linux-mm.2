Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF7EEA853C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 18:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095966B0089; Sun,  8 Mar 2026 14:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069856B008A; Sun,  8 Mar 2026 14:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC366B008C; Sun,  8 Mar 2026 14:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DDBD06B0089
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 14:03:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D9B51B8E31
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:03:19 +0000 (UTC)
X-FDA: 84523667718.12.64DEF86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D697D4000C
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:03:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aH4mGr9U;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772992998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6AgNkwhYMIUW1FXNBAGnbRgsWIyXJgoZTSCJFudMehc=;
	b=e0+VdlCGsZMvZYSK4srN4stHxe+9mzUxRIKXUU9TOxpH/MIph/VFfhqQ3DNceIQUO8l5oD
	REWVw0shDEyrdNVwKXNjClenH8Qzh0R2pAxBvhCLFLRrXKGl+OF6wsKqky6l+EeYkhKBHE
	9HeVzzbUMbWm+E3SSvUPg4j98l58Xww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772992998; a=rsa-sha256;
	cv=none;
	b=P3IlBBAVuic6EiK0t2NmiyVI24W9mL+DaH8UUcn+S0+C+VC6KxlcbVucfL6EWSOoQJd1I/
	kSq8PW5sODtyZA1+4fnYiNmFtyoSesvEs8t5NrQLyGaDVXLtxBVElqtuzq9Oep/YNvTigz
	26wcQfYabNqqMIN8pNxmNnzkKn6JBiU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aH4mGr9U;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A60C443E0;
	Sun,  8 Mar 2026 18:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EB4C116C6;
	Sun,  8 Mar 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772992996;
	bh=rmJMdlEXDjwGvBgpvp1qb6ZGImcvRLTk9sD7zdDDS1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aH4mGr9UYO5eiH6AIYXjfCmgDRp3A7ggtu+GzfHkqbKy+0vL0gxX2TlSiTUU68lSO
	 mZwlZNtMkKgE7gZt2SaP+89cW14wfxz5VTb7zjO3U4Qc/MZDUTTQBF4rKQUNfW8Pzz
	 vLgqbwOYuL5pL7ApHNUav/WPPEIhafkLtcKq52vRCG6/UUXjJs4DEVZPEDwZkiLhHO
	 QnLEE3cbrLBK76mO0kYVn73zwcIvs4ZkXYBBvuljg5cqfZHlHXs4VGEcqlLzNnMQCG
	 9QDmJGzlL2xsps7prrX2KVszEA31X9jT224ZwKGHyHVQMy/T94Bf9iriN3gqEz4pBA
	 1qPa6++O6An9w==
Date: Sun, 8 Mar 2026 20:03:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Xie Yuanbin <qq570070308@gmail.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, david@kernel.org,
	justinstitt@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, llvm@lists.linux.dev,
	mhocko@suse.com, morbo@google.com, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: optimize once judgment with clang
Message-ID: <aa2523KDNwWXHbDD@kernel.org>
References: <aavd4hoAO1DFLuJP@kernel.org>
 <20260307144135.380683-1-qq570070308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307144135.380683-1-qq570070308@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D697D4000C
X-Stat-Signature: aep9xhueptecu6go6noa1qry6ieoef5w
X-HE-Tag: 1772992997-340158
X-HE-Meta: U2FsdGVkX1/RIOm3aIDni22EMGqb3teEzVjAkdIMZHa5/VQC/BHvx850gnhTl25uJ99Js5Qt0yM/EWOCjiemO2LOSRiFVJrKjZLxBrNwRiuoKH5uGiq3itJT/aJLTaCrTO7qf5OxXXI+Kwksk3P6RSa0geh8aoQwS6BMuU0umsCFkHwRn7auYow45qO4DcsNkJVSToig0cmCn4G61RC8ppuP7SVd76zh6PEjJwOHxGCvNfQfofqZlEPrSrlTWF5LkUqGX1TK9cxxsC65GpFX38dAVal54PhzD2P7VJ6OM9izOr8tguEmAq3+wN8dJ0/F4h1T8e1t/rJsgORCQw6ka3uM+EGpESrUpBSfV4IuwZwTocqRHctg/XWj3LDpmzMjg/KJAMWu1buULSOFnG3DzOBwPGLBY9jXq31NHCefzSgjjFPjbI/lNC2V5orox4GXfEmxTaW92ZuHkFSB3kY5Dgi8g51FL/lx7ne7RO0tddW9Q2NhbHsEVQCJVQipcRBFLAIqmUSI9Zp9PnSk8DnzE/jV3g1HvLpnvs6Ofe/fG+zY6NzUyTrEuCqtW5MBAuJKZ6deXGh/xdshPnXdEeiIqLX7QABkaxL7gpeMgzxR4ek1TDrdh0fBoyhnbUI6mS+BV2+5KRXDKk7BoOdyFdoZ8NPLYQ1xoZk9CfTFa94vtR/KBmW6dGA9gNYZdiMh2SZfnyRHU49QQe5t1f0RZVrarrDTMxyv+4F+RYC+ETT+D88BbRsJhLpa7kCEeJVzNZVUZQtS2tua9xjEOCKLgEmItMM0XsEKYd4XWU9/TkZmqqFDXaZMHyKKZjXfPKNLD7XUK2scz8TLj5PduetFzCR+oduQvEx8oIit5Mnbv8fMNIO8i03yg83jtG06fTpW62a461hyJEjDXc4rfWtmKC4u7kM1Ky0QqcrluMe9qGZpU5+3sBwcDsnviz9wp57HUZOjn+DwLM9+2QCd0QbZVTn
 Ioa237+i
 0pae2QUjG1qVGa0e7QVRShAOjrtCMBzLQfAJY5kyiEiLZUXaHWhjyc7jlzBr5DD4VLwZBnSrqHXrkhR88ZUJRtRZdkqFsaUHPrbIQF91PuHznZD9EVVuBuzty+/E9Xwxg7Tet4c/EQbbZZkXGUSStTIUTmtK4V4tojCR5c7hr6TnqzFmYHCyMP/Kp2px6f9bpWZaSZWUkycAwnsp6IAuD1PKD/29lFX390gW4Ek4I9cc4mLo/L/iHck2SG7lR5UkH0CE5BJZ80PEjzda4F8lCTpm7/AtBawsQwWieHOEFhxwacZKIVxOU0I+4cMw8A8/QyUr9/4vBMc5NqiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 07, 2026 at 10:41:35PM +0800, Xie Yuanbin wrote:
> On Sat, 7 Mar 2026 10:12:18 +0200, Mike Rapoport wrote:
> > On Sat, Mar 07, 2026 at 02:54:04PM +0800, Xie Yuanbin wrote:
> >> commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
> >> WARN_ONCE with clang") helps optimize performance and size under the
> >> clang compiler, but the modification is not complete.
> >
> > How much does it actually optimize for size?
> 
> Basing on commit a0ae2a256046c0c5d377 ("Add linux-next specific
> files for 20260306"), compiler "Debian clang version 21.1.8 (5)",
> arm64 default defconfig, and setting CONFIG_CC_OPTIMIZE_FOR_SIZE=y,
> the size result is:
> |                                    | size     |
> |                                   -|         -|
> | Image.gz                           | 14256146 |
> | size of ".text" section in vmlinex | 17035264 |
> 
> Basing on above, revert the commit 242b872239f6a7deacbc
> ("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
> and build again:
> |                                    | size            |
> |                                   -|	              -|
> | Image.gz                           | 14258152(+2006) |
> | size of ".text" section in vmlinex | 17039360(+4096) |

It would be nice to see where the difference is with scripts/bloat-o-meter.

And while commit 242b872239f6a7deacbc is a oneliner that essentially
updates most of the _ONCE constructs, I'm not convinced that the churn in
the patch that updates include/linux/mmdebug.h worth it.
Do you have the numbers for this patch as well?

> > Note that performance is really not critical here because we are already
> > dealing with slow path of debug code.
> 
> It seems that WARN_ON_ONCE_GFP() is not affected by in CONFIG_DEBUG_VM,
> and it is used in __alloc_frozen_pages_noprof(), which seems to be a hot
> path.

What might be useful there is to change the order of conditions so that
__ret_warn_once will be evaluated first.

-- 
Sincerely yours,
Mike.

