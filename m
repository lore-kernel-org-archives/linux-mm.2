Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF8A2C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688606B0095; Wed, 19 Aug 2026 11:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F1A6B0098; Wed, 19 Aug 2026 11:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5749A6B009B; Wed, 19 Aug 2026 11:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3550C6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:46:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 588DDA30F9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:46:16 +0000 (UTC)
X-FDA: 85118445552.03.E6B0FA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 45C7340008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:46:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TWFdlP3C;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787154374;
	b=sBDl0cdLC/ev32FbV5mcudeXTDuOeLMnFnNAmsuF3DwH2B9IZZFJ6Vtdsvv9a753iPkZdx
	yHCvLqSUOrd0Wr6fKV8z4DJhqK8fQFuqrbnKMYJPxgxtBnpK/vmMxUQXiq0c1MmwilfHnS
	NJ+SPDxTmyDDUYi+KXJ1VyQIOQT2KV0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TWFdlP3C;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787154374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FF4elongAZg7/M4cE7UQIpRWN92NIlJQ0JhAOJdFdWo=;
	b=DbhefllJGQCc4Z/9hy9yOpmkE9HlYoNMlE6pAChHerCaNLVwj2U6q15kJdMWYNouza2DPK
	8a4xMIc4X+dhQzmIOle+3qyAzkBUbNPAR6HBquXzg98vEhzTZMxgo9gSyloSV0n8sMxHkb
	VSahn2b4hYfXJoqyZmzBKSncyatsIrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B5B543C6F;
	Wed, 19 Aug 2026 15:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB5C1F000E9;
	Wed, 19 Aug 2026 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787154373;
	bh=FF4elongAZg7/M4cE7UQIpRWN92NIlJQ0JhAOJdFdWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TWFdlP3C/pUSFUyS4z0RosyUzwRkBJ7n3YSwFwIspeM6G/dODiGy9Fl743wq4vWTg
	 hWGfXFxMwQ6kmZuYua5g5r7n2e4gUxONQY3uNTZeXoQXYTCpyw+B2cOTefJjfnlEU7
	 dxGIlqVnMFMq5UJFtUyvH58joiDQxTU4P59ubz7coxHbyIscx82nO33iAAvfmWz2pc
	 xORtnV3dSj5nIhU5BAx2z6dbYwBbjOCPjFmxW8W+FCI8F6aHJHEaF2XvGowk6cPwns
	 0Q8+D+Fy3ctbJao7MpQVVZPw+IeUcGjLI28eWBcx3RGINGClFg8WZY079Dx6TBYVs8
	 OMmeq6YU1QOPQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id A7CC11980075;
	Wed, 19 Aug 2026 11:46:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 19 Aug 2026 11:46:10 -0400
X-ME-Sender: <xms:vc-Falh56FLkDh3Mo--mQabb8Afh9sK9pellib-FS6fek1NN-bbejw>
    <xme:vc-FagylgBShoX3Sa_Q-ysYAqxFBaqXoxWZ62gHj2oa8ZAG4V4Tb58ZVo2wl6hdPZ
    jwR4Ti7WT1dY3q6r8dVMbH-iA6S6WH3QS1UHx9PRwc-azyKp9BITN0>
X-ME-Received: <xmr:vc-FatMC0cNRul-zookULN9hbKKPKGvWcJtURu7tUomJcLjBc6US9Nt0Oc8>
X-ME-Proxy-Cause: dmFkZTFbQc/DxeUvuB0ahiyLxyyzwA7xvHem8nISRpZYhrkBn90a3JvF73UYxxLmxqP6gl
    HAD13bvVkUVYopLRFEOet4GfhE73tEpKnye8r+on/mQ2oQQ+M7IVk2wJUbxzISfh8HmLr8
    ahbajLBp9qphjB2cSdNgglL7+2My4LcMn6kBE2LUDggd692MQSAE3K1URYroIcKnEegv41
    javIZkHHFTEOx/alKV/4o+HgJgprEyz6hYOWI/vwwUWTNVTUBg+cM0wfOAhH6r03rR6cNx
    MGdC9xzMsa/69UOJgaYjdxb9+/s6rLmig4carmArzqPZKWvhju0iHPG4dUHViA8GYSEYY9
    JUxg8/ABPgb3SMJZvYAycam3gpIJLA2cJmr5tssdDzRoaIjnMRqrafkG93Ta74eq0bASIR
    a5ky8gbmDFEnx4GAJw+laGz2qmrkp1rpRF0P/2Mkm8fNxtVhamxAjhnmWDCLPWgNJF/hoa
    2NsDZz27A5VHlr9lZKZeaMStg5cgqTSyh+14cwQsEH+cWBnf/LXMnrv9AwSOeu8Dj8sTIT
    o/Kwtipfs7cc4rg0QVYOK5r5Iid7oCt58naSjMN4bYfNgJxYc8FSzOe3pJOnPn+RiVZaGs
    htoUGWSlG2RucRmSAAFVbcpVLQoNZYjl1xfBbyUxB3Y6455NAT/VzUDJYM+A
X-ME-Proxy: <xmx:vc-FarHrhyMLPaVk7d80SJ3h0SpXvJdPJmEUWLXZdOCQQO99QLW86Q>
    <xmx:vc-Fahp7Vi5ArGd84ii5Ed7qVGe5T73InDTJAbdmPOxYCxU9QpJjVQ>
    <xmx:vc-FapiFqXWA--vRgIBr-sAbqW4msvFuWBThsRvqSflCsIhxPmTRFw>
    <xmx:vc-FagqSHPs4fuUr6lVz_CZG8Oc7XtNWwyodrVGoJJXT-w1MCE0IyA>
    <xmx:vc-FauDv6xyFNjwEck4sgsY0jQk6CEpu2j-PIojcGSgMhEvkwcJyvY7A>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 11:46:04 -0400 (EDT)
Date: Wed, 19 Aug 2026 16:46:03 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 04/12] mm: handle PMD swap entries in fork path
Message-ID: <aoXNs-v5SQ4Nx4WU@thinkstation>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-5-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818131202.494754-5-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45C7340008
X-Stat-Signature: mp6sxwrg88orpqoh1tt8ehou68rj7de7
X-HE-Tag: 1787154374-657067
X-HE-Meta: U2FsdGVkX1+aaXPZiZnb5qzCseOjysIv4wnI9Y45hsE0ZRtMKWVUu0ZnR4ir7WZB6pMDK2HxK0IpXVFnUWkki2VAZWxWPShoCr7kpPfQvWX5yj2+/ZfCUPk8ywetU7/QZsaGb0irrpFkRM/r926lWGIjjRk5vhbgaOinwjLZQLIwTPombUAsYCmg8lJ07WD1InVA9C/qD4D1aDnr2iaOSYbl7sdL7vDS3/NN/z8iv8QM4lLzBWUVTNnrgvixeSoLmQucjGmHbj7JfPZm2SR+N+m2lEAflkLMU1Ezr3FqpnvwNaxLEZk7bsKzqarbtvgqUQftTay8e6/rdNyyY5Hw6mLGGX64Hs2ZG0w5Ch270J8SklT465Cv5FyxpFKtOBKQqmKeToHgJeM6mWHZudES9zRWqN1rRA0S8fdOWS/HoibXr4yJy5n0wyq1Hq7nYRLOGxbQSlDCck7sVtR+d2XWFDdxtwktGnWGWvO9OjZMTtGaPIc5eYHLctknjj5YH0iXwawyea1NJmft6/bRon6sFpYeY95raNUoH/DKcS2C9l97XE4RbBGm/7sFAsS9EI4G/2lEzOS5wBMRAkE2OnWOPjp33LmoMXe7Zkhei8OQKcnIS7/FsullmZU1rnZuJvepD0ilqrdf9QI25bdbbF3SlbVMydHC+61D8DPInSCjtZAsF8BBpsSxxhSMxt2OCyLEicd6omd7cqrCm8RPojWgsxyuq/kc6vMYMTV8sFXXnAdkUbmiByKm/0RipXfdwQnnU1R8p2y5Jkn53+W9CvD+WsxNT36ybm3cbtEYkHtDGNcSK95kOExH/+kn6UsnLeHZyNxWdrRBCk/AumcOFKieSyefp86HMShJkAlO3I5HD0FKojHFK/9dpwYm2omPeN3YxHhcqZNEuJ0G3tJuG3xLQT+OdSYpgxyClP2ICoCH+geCxcFV51jWRj8tGFB5ND6fM8uspK+jmG9T35ym7LM
 Q5A0LRtG
 zwG3zAmZn9Aoo000B5L5zVntiVikZAqybBYa3ATU79Q4U/Yd4cbQxc2Xh4zOq/n7C4uAsmzRDdNfWEsMNBnS70cJYzCRnTcYLK3ZfH2pUmIEIN895BWheoZcJnx+3i6KGRMsvlyNhjsTKykxp44BiyOr3/ryypkqgXPyOvH9zSvINWLI7oPa5ovagILykN+8njX10Pci2EnJw3gi5ZnE6uiNGIxdl9kZ7eAm6vVw2NfOEqzjNknOhi06TpbOJtBEVwegFPJYPa9O2/mxh7seNf77ydw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 06:09:45AM -0700, Usama Arif wrote:
> Teach copy_huge_pmd()/copy_huge_non_present_pmd() about swap entries,
> mirroring copy_nonpresent_pte().
> 
> swap_dup_entry_direct() gains a nr parameter (and is renamed to
> swap_dup_entries_direct()) so it can duplicate a contiguous range of
> swap slots in one call, matching the existing
> swap_put_entries_direct(entry, nr) API.  Existing callers pass 1.

...

> @@ -3955,7 +3967,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
>  	 */
>  	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
>  
> -	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
> +	return swap_dup_entries_cluster(si, swp_offset(entry), nr);
>  }

swap_put_entries_direct() bounds end_offset against si->max and walks the
range cluster by cluster. Here nr goes straight into the cluster helper,
which does ci_end = offset % SWAPFILE_CLUSTER + nr and indexes up to
ci_end - 1. __swap_table_get() VM_WARN_ON_ONCE()s on off >=
SWAPFILE_CLUSTER, but still reads table[off].

So is the range required to sit inside one cluster? I assume it works out
because a PMD swap entry is cluster-aligned and SWAPFILE_CLUSTER ==
HPAGE_PMD_NR, but I don't see it stated anywhere.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

