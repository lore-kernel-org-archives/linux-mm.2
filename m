Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AA3D72355
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0339C6B0462; Fri, 23 Jan 2026 03:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20226B0464; Fri, 23 Jan 2026 03:55:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50A36B0465; Fri, 23 Jan 2026 03:55:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D212E6B0462
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:55:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97A7F58CA2
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:55:44 +0000 (UTC)
X-FDA: 84362620608.28.FD9FF33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02ABD100003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:55:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WoJ0nypq;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPHstnKyauJbBsO6lryFaPd+v/fRclj9G8DTiqOAAcM=;
	b=KCwUArB9GXHKs4ss/QmKlrhl7YE5w80VxBXbF80w1MvjrbS2+Wiw5i26dMa+z7D86/Y+dL
	pmvT8x4EHu8BEVWUi+v65XjUzO7nmSFp/iKfMaLtfsbJx54XkcqZDK849amAB0gQstCrpS
	NeMCx8U+XhSObBMRMD4gcVQGrmPPyL8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WoJ0nypq;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158543; a=rsa-sha256;
	cv=none;
	b=XV9tYvAD4IQkeiZYNY28y8Qw83m222K4+CmVhwGYUbwsoJq+k+h97X5vUoxdBkY/8fY2vN
	SYQSgJIWR6kADrZsgqbzCER5XvxaWWcolY0YQRwNe0IiqTpOJNQ/SmzHQnAqw2Rc6y9rJJ
	JerLPeSOWitTsg615JmKC/dhSgpPB+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7542A600C3;
	Fri, 23 Jan 2026 08:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51951C4CEF1;
	Fri, 23 Jan 2026 08:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158542;
	bh=qipa/leqAcHIoHoVIyTRuSK7iSLnI0bYyPtkyQuKOwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WoJ0nypqalaeViN45nqZS61DwLJvLaxS6Va7RYXhmCPffYKzA4qdEjCMvwy+oegw3
	 aKfV7IBM1CmTPICv1FsvAfImMRMKEOCG5X7MpI/dePfmYI/JByz/LZYC0ZjrjP55Ao
	 1SLnMSBL0Ke+sW43iPtgeIe6b9D4ydUSHzhKWjeaNBWdI0tlqCKYh3EUSBhdXc6j4g
	 Syov6+OE4ubSQiSv1TfW/S9MSNsX9kLpZ7rHBdyf0+q1aYZRzbIOAAPe6UFwRdniIj
	 QulhEZGmEzx4jlQmft7zPoZK+lQp6gZSh8Julc8gkPGTBfQXKSy2OVFVJHkJx/uMUy
	 Jy70fsy4UJnYQ==
Date: Fri, 23 Jan 2026 10:55:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: ranxiaokai627@163.com
Cc: pratyush@kernel.org, surenb@google.com, akpm@linux-foundation.org,
	pasha.tatashin@soleen.com, kent.overstreet@linux.dev,
	graf@amazon.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, ran.xiaokai@zte.com.cn,
	stable@vger.kernel.org
Subject: Re: [PATCH RESEND v3] kho: init alloc tags when restoring pages from
 reserved memory
Message-ID: <aXM3hgqsCaleOh8p@kernel.org>
References: <20260122132740.176468-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122132740.176468-1-ranxiaokai627@163.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02ABD100003
X-Stat-Signature: 5416jsef3e8d7zxichz7nid5fsrd1c58
X-Rspam-User: 
X-HE-Tag: 1769158542-518986
X-HE-Meta: U2FsdGVkX18R5c4fFMjOqBhNMfLoZg3r/85rxva5v3jLxsoCDFsUMyoruvMJLZSyQ/AV+z1oG8ksL3PMlx7sZUJWUXx1648VO3Tj1uyZNHx374SQYJzxNwFIAkXJk1WDlSt+9zOG46uINn1YL/RmDRwikCRY7vZjobMigpToObNniLD+2Y9hMDnlScaJZXu1lbxT2Azkx+gNIXi1kAbfhf0qivWpldRl17fz9NNbfVVNIF+T/fDD3/I2BuFOPl8YU387Z2LYnO/2w7EnpLFiUnZ/R+pzKqKW9iUVez7HetWZh0sJ4MuuaiRyPG7SkMlc/PDd7Nv4KsjGrFVT+9mxpuKRBhvNMMRKVuxQaa43KSjWTwoaWj1s4J3ltkv68ke6qFEjc+MQj/YTc4oDm1ReFvEBbT8sHDxE+0kHE5w7LeiUCt7AECIj16VpKUmwLz3qkbojtfGvaORte36QPnjpH3fIBONNRYKJk1T9yv8pihF88CIt0DfbuQCRmby8IA/EWonRABGvd37bqx+K9yfb4JCXlCoieQuzaRpuTYuIt16P3j/LvR3Imp2Al8sYG9FUSqOtAteFdeUQdvOjk2YpF6bXLnN/C0O6b/2Q59TTUWlElj+h7r/aCHMIMMgmgBp3hTiUgmV6YXcUyN71jffg067oeQV6JcVHnxJjAn0qVTXIy9LuleNbJ3KcIxQsOeyqg7dqfzBIVjeo00dcS95PrNgq3NLrifcW49g953R6rxo0MDxV0dCkDW9GshiHWbfF7ahe6aPHldi1APV3YKYv+jB+SOfk0/qb4xF/8p9CyOmP1VbdQh1As9Gc+F75n/qHQmzapb79wNPKBDRLCk9JQ1uPw1ZTdmZJdPVNCeO3y1Y9QN8PGLW0C29uw2Yg5sKlT3XFOLDGokFklP0BE93+7znWfDk7OxgC3THs0laCso1MOGAisiExBr3XlJEdD6cdH8RhVWs6Rm7Pgo24KGr
 2Am5Guu2
 1z3qARfu6irm98ayEo30nO8rfbteUrhpYa4Q8H5zNu/o/qO8JSR3nx3sIK1bz6LgwAC82yy+r1i/Smcel4PZMi/PAHODeIzVs1KX7ZU2EXHGoIufExp1QAGauwAeB3ldQNEq2CfI2ZuHWgVpFiztkzKCxdW4hgSVPAd1EpM0ZeO5jS358tzRQ84JfvzjwOc3vtrEfQjl5pguUyHEWuk8lPPZu4ggpgoRsH4j3C5U7VxVOeOPFFy7HJr2PbA+GHGrz1QYsTIfbuRgc+ZJOeF35XqhDXnub+xYz4YS6bg7DYWISz5a8ULKuDqnIpQOuPNLQqox6feSoAbZae5nHEpGJ17WIuuoOJiQ7vGZ4vB++9vy+f5I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 01:27:40PM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator. When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and below warning message:
> 
> alloc_tag was not set
> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
> RIP: 0010:___free_pages+0xb8/0x260
>  kho_restore_vmalloc+0x187/0x2e0
>  kho_test_init+0x3c4/0xa30
>  do_one_initcall+0x62/0x2b0
>  kernel_init_freeable+0x25b/0x480
>  kernel_init+0x1a/0x1c0
>  ret_from_fork+0x2d1/0x360
> 
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.
> 
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> v2 -> v3: 
>  - also call clear_page_tag_ref() for non-compound order-0 tail pages
> 
>  kernel/liveupdate/kexec_handover.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index d4482b6e3cae..96767b106cac 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -255,6 +255,14 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  	if (is_folio && info.order)
>  		prep_compound_page(page, info.order);
>  
> +	/* Always mark headpage's codetag as empty to avoid accounting mismatch */
> +	clear_page_tag_ref(page);
> +	if (!is_folio) {
> +		/* Also do that for the non-compound tail pages */
> +		for (unsigned int i = 1; i < nr_pages; i++)
> +			clear_page_tag_ref(page + i);
> +	}
> +
>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
>  }
> -- 
> 2.25.1
> 
> 

-- 
Sincerely yours,
Mike.

