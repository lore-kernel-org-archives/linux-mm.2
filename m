Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4328EC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 12:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9DC6B007B; Thu,  6 Aug 2026 08:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16AED6B0088; Thu,  6 Aug 2026 08:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0593B6B008A; Thu,  6 Aug 2026 08:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDA246B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:54:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3546280738
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:54:13 +0000 (UTC)
X-FDA: 85070837586.18.D04A275
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1BD61C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:54:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="M tkxXCF";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="fJVA/Ocw";
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786020851;
	b=iQgt4rxm7gsTCQCIN3hHKaQpiPI0MlDhCIdRMLeiLxZ2ne614FP+zC91ZYtXSPf3T7Tu7z
	U9OUfYE0OdM2UTc7CFJdnyL6gxkaR3iZ888+wHaiKpVEyuCQeXeEXbQ5byyjYhVbijzVAs
	2oRLGkDdpkxdWD7zvsfMydwvYt+l0Jc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="M tkxXCF";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="fJVA/Ocw";
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786020851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boSk8DCrDRo+nTQeMwIqD9dIYw64wqKC3Hk8QJqHyFI=;
	b=CYB57ZTIz6IVUGK+McvMhLwapsrtN829Q/GLQi2pIbBJS8vlkea2cAcHz0wYxzWCHRCx3b
	Cu1xV4QJEN6YzExfxhZUEITPgFhapc5FA5mDKyFtjTA5H0pl1lYTkust1ynBqC6H4Lb+uK
	Dni1hvX+P+QKi6KXPhndTa5qMP8uTY0=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 1836C1300171;
	Thu,  6 Aug 2026 08:54:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 06 Aug 2026 08:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786020848; x=
	1786028048; bh=boSk8DCrDRo+nTQeMwIqD9dIYw64wqKC3Hk8QJqHyFI=; b=M
	tkxXCF51yBq/Scm0WSZtqD0Yi0ZL+ejGgyLAl2g4xwwu1SWQqNEnXbCjUYqvgrLe
	UG3TEry23ZU2puMb9M768HFFpGSKMvYMSZYSP/RiriT8PCMHiR/RmYUpdHQMNs9w
	gNmT/Pk6+cnRZNoAFMf0/DvlvQHiq93BsXn+F5Aduo+EingsDnO4CX756KMWQRqh
	j94CMBBxlBxH9hONmNZKnG24rlqQZ3hUlAuIOB2RrvWy1l95pUdm7cT0byRJxMeu
	yOwk36v2DONDsjHt07xhlresoIx7ugCRQ4GK30aoSySoufh42yR2ntS8MEY0Gph8
	eNY/6dKucLwMRRGGzB1eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786020848; x=1786028048; bh=boSk8DCrDRo+nTQeMwIqD9dIYw64wqKC3Hk
	8QJqHyFI=; b=fJVA/Ocw0kwI++6qyU3lVJ8XXRZXjjo8OsuhBXopVBL5Gi0SDFF
	SY3sCVzExoBY4TDm63vfRLoP0oHecLFFwCcL5OM1/ek7gcOcGyHe2ImSSvgP5wth
	+qZ3bUBoo/yCwgSkDAXEpd+POD68u/+sDzGhYy7Wtka1f9reOQDIJSRDYoDwgiMN
	RoeY0hdiog6Uo/pBR7JGMblsNCtCbBlRT1z7GF7tdCvUMXZMM+kKPTYqOz1NAbCQ
	R50t7/uE9mMlyfpH6ES6y7Z9IMn+bFGsRkXz586AwunrhOPthAu80rQeptJ0Zbxc
	hnSEmVUxGF9sSWXcmoyOHoxOHQID5mL+nqg==
X-ME-Sender: <xms:74N0asWn0q3v_15_9EDX8klo3SmwQoxQzs5G0RrCbc4m3N_qDsqFQw>
    <xme:74N0asS6C1peaLikjP9aCAzr0Liji4CBpjx-PGQeVk_ZI_nsNzllqhjp4nkh4hOLx
    9mVnO-uZ16N1yzrgdsT8npKEky5ySgeI4injMzRwgjIpFfXBXtyE8Mj>
X-ME-Received: <xmr:74N0akA7tr-IyAyNEeNGEKwMs1sK9lDgMB9hyWiYnva30lyctbUzjKD3OPo>
X-ME-Proxy-Cause: dmFkZTEWPsOtcs8rlbyu+haLTgD87qxVOKeHxO2koB2E72cB+copeN+dnWel8hzi5LJSYt
    C3RYPbMgI3aChVp3MM27BqYAIvooqSQOwfHVTPpCS4SyhZhJNP63H7BJscxaGDWECUYhq7
    Xh5lsxxCL1LweJdqz19k2Khgm5RIYqRjAgaoxBIpGgZXYFLu/fqoL/NIX4IiYqK0UMN2v3
    cuSdIMrx1T3qFnXvpzGz9lMGSEvJVAcogfvPt7CYNGB0UYojKDsvJqyJRNgqSCtyOivHD6
    3Er8znEcn5ixqi7kI8W2bGtsUcz0aUbV9DVi6+mfHaO+PAuE/RbAazV79zXw0Tg31VHfbE
    6ORPkT+j/gU1RSWG30fwJ1akU3di8sPQs8/U2s7JlWeVPJGaU85z/iv04sxDEG70ciT/s8
    ysF/YDwaU10k3d3d3YIftsAHkbd8jzbrAa9qNdh5q+e2GXUA1Pb09p5dCvuVJx4fx/57Td
    SZbMrlu4+2/hHAoPJhuKWkUdeQbIpT7EBe+VtDYg6HTV0I85uaJItvxlo1WglK0CxynGg5
    hm9TZFMSo4NP5hbIGcIy4gVKtNAjm0w5iVvQaxMMQVsAPBAEg4Gb/i1cWB2Ssbupv7PmFL
    y/Vr8XeHRXDKLSXJVNuJhLax88OCAYeD0oR6tR9utRhZd5bBo2moBUQRJ/bQ
X-ME-Proxy: <xmx:74N0armI1GVqgQnbgHL0r2X44Fo7aqVvBCAeIDkyQqOex_bSCtVmcw>
    <xmx:74N0akmyBrIxe-RKsor6sxTZsoyIBpEFptPGPMgsi6g2d79_8ACCBg>
    <xmx:74N0aocggu8UGrLiUGdlRP0DPeOT8rBuRj-1tVrBaqoTvyNAqsatgg>
    <xmx:74N0aqy6pa0hoSWV3cQltZSQ4d9YXGzrbr39k116RLiOe0HA9MFlVQ>
    <xmx:8IN0aspOlZEYh7XxZ0YV7kjew5Q-2YKIm7zR58rwXBROndLgXvFlCFSF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Aug 2026 08:54:06 -0400 (EDT)
Date: Thu, 6 Aug 2026 13:54:05 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Nico Pache <nico.pache@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/16] selftests/mm: skip khugepaged shmem cases without
 a PMD page cache folio
Message-ID: <anSClqrkH2y3pxpm@thinkstation>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-17-kirill@shutemov.name>
 <DKETQDCO9OYH.2FDBR4ZXGHLM@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKETQDCO9OYH.2FDBR4ZXGHLM@nvidia.com>
X-Rspamd-Queue-Id: 1BD61C0002
X-Stat-Signature: fu1hxipemcej9814fdia8wzu9ucttmhi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786020850-173456
X-HE-Meta: U2FsdGVkX18C3vZGorh1LXEGINaoQsoHnx5oSCeVvh/oVSv+3hoX7Sc2yGirfWef/iQMSx4yUCDDPlygShrWoNT4oPjGoeGMS25JQCeBo/zPv6CQDT76QHKYzPr53nItPdSDHn50OYIISOZflWuh+fyMpE+3UUCwxhOkO/kkZxX78gGjeTRYNtS1/sQC9KT/NUn5xtM8u+KSmbqux0L69ixuYGvl9ngjt3OEsUkO/za7B7iMlddC620fwB9jMHZoZ9sdoM4Xbuyf0FXhhgwBsqcEKxTzFrGyOWYsPQ2eqKOCL2puze5WbKgfnLKtLxOdJUKMDWkHvDP7mcBNbUghjFatz1pOsAIhbYw+PbwedfOjNcMh9dRrsWZ0yVVND4BWZyOEObHqesecGJridXauaxapOiLNVmzCuIXzi/nt2Wmhp6PLiS1biuckak9GMEnOE9x3QSJJlN21utUtp+X6UVUNmdIuuadTgGXUeHTuCD0vunZm/qxyv4MK86yrvl43j4QLFisBDoWkbDp/yWUfwSheO1sLcjtoawofjNZsmurUBonE5VMZ/7kBmaaZFXKdPraulXz0j2ba4pMGR3xry4KXzEl2OB/vXPYW8RW1Pp3XU6tzcc1qbO1oifIbGIYkwZ0B66onzm5qJsIgVIQszcsJWXqmAI4fChm8lpMoG4Dxkg+3Vw2+P0auXjin182lmkbgPchki+/IY5QABh6JrQQcwraBMPtLDpz1Dc/1eE3Iqq2hNPxbs5lofpZ9zG7cdcYhG9m9LYi3oem6OyJhQ2Vy+aohrOZZXhfr8ivq4TJKenejcMaPCUj+vwc/m4IIMvY2hK/KtkPejsee7QCt2C18bIisxvR/ZC3ApkzOwA2rqrzfbhsErKSJ5XZvDq3xZtr669VxQdsuYj0zEaY0ELhb4U9Ydd/Ak7+Ks8cDBxpniPcgw0z687G3IRqHuzlio/TsAOQfTH794mfZdkD
 CvG/9NbL
 Uj8q7v9y81TCrRdi+dTSY9p5sJmWlVFxhv/xZAtALtf3Fv7kamdV41m83HY6YCgd4BLZGiXxp6MIGZIgBA1jxEYNYmFZwhzzi1iSFM5p4RE/wymblg1YcVx8uEe7iRoqAyp6mlM/1vLyY+x4Ohtk9FeEelME5RZ4wkENfUTMun1O5wJz0dvQjtHt/2KEZyNT7xRLQcsKpniGAiEKDywOGumG+qNPM1W0TGkUE2Ntd6JjAbeUM913FcvSRp+dPahcqy4ax0DAh4x4NEaWF2hGn+63UfJLH1BbQ21ZFxIT8ova2zqvaU0To/hxkQKjMJRA5WjTRbJ+eugGI31CzybSVzvk/TQ/Bb7XCBwdWP6L20uO9pmQwRMUE3qyodrhd9demdwwulEJRYXhjfBHtYMyUDmwgPVk+bCxBC2rKU/GY7eI8F7wIVNHGAZt04V5gJIahjiiiZcvA5O+CBJsEQ2l2CsJcAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 06:50:36PM -0400, Zi Yan wrote:
> On Sun Aug 2, 2026 at 3:52 PM EDT, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > The page cache caps folio order at MAX_PAGECACHE_ORDER, and
> > xas_split_alloc() puts that cap below the PMD order where a PMD is 512M --
> > arm64 with 64K base pages, as include/linux/pagemap.h says outright.
> > shmem_huge_global_enabled() then offers no PMD order at all, so
> > MADV_COLLAPSE of a shmem range answers -EINVAL and khugepaged passes over
> > it.
> 
> IIRC, after READ_ONLY_THP_FOR_FS is removed, all pagecache folios are
> split using non uniform split, xas_try_split(), so does shmem (except
> shmem in swapcache not splittable). In theory, we can get rid of the
> cap, since xas_try_split() does not split more than one level like
> one can try to make xas_split_alloc() split more than two level (e.g.,
> 512MB to 64KB on arm64 with 64KB base page).

Not really: xas_try_split() is the non-uniform path only.  A uniform split
of a pagecache folio still goes through xas_split_alloc(), in
__folio_split():

	if (split_type == SPLIT_TYPE_UNIFORM) {
		xas_set_order(&xas, folio->index, new_order);
		xas_split_alloc(&xas, folio, old_order, gfp);

and __split_unmapped_folio() keeps the two apart for a reason it states
itself:

	 * uniform split has xas_split_alloc() called before
	 * irq is disabled to allocate enough memory, whereas
	 * non-uniform split can handle ENOMEM.

So MAX_PAGECACHE_ORDER is still the limit.

I do not think non-uniform split can simply take over everywhere either.
There are going to be cases when a folio has to be fully dissolved to
order-0.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

