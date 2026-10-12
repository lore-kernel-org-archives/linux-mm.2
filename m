Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1FF0CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C326B008A; Mon, 12 Oct 2026 11:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC846B008C; Mon, 12 Oct 2026 11:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD27F6B0092; Mon, 12 Oct 2026 11:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A337E6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:36:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EC17A0F66
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:35:59 +0000 (UTC)
X-FDA: 85314374838.27.9602ECD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C1AF140008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:35:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDeKJRIQ;
	spf=pass (imf17.hostedemail.com: domain of bjorn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bjorn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791819357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NlCppqlh9IN+OUBU1U01H7S97jTJiDfAUXtzFgU1ic=;
	b=FUwMbXeTyTzD74ebZt+hKqizx3oY3nC4dwyEp6IDyovKZhE8T+tLCx8xKKfGcxux1Kwz0H
	bZPP6AbOcHvsKllTaudIelRQsKbQODYmW6XhJjnLFlkwuCAmm/p5wtWZylKJpqUIxOXCAS
	/HpnIOZwGjCNeS2ANep8W6rBLj0C8rY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791819357;
	b=EstOWNcWZXAJyPPX5GS8cVvftJG36aU86Lux7R/CaH87R1/bCkgzjnfBXVf1Zd3Tt3RHT/
	+R+WnKCqrBvqNtvrLmptpocVTZ3aV4O8t6/lJdeiJyDisB7ITMJS0Stt3Sz932ExSBpclW
	zFCjz6jd0W0YYD/7YoA3DV0bBi2t5FU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDeKJRIQ;
	spf=pass (imf17.hostedemail.com: domain of bjorn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bjorn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28D0B6020F;
	Mon, 12 Oct 2026 15:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4809D1F0089B;
	Mon, 12 Oct 2026 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791819356;
	bh=3NlCppqlh9IN+OUBU1U01H7S97jTJiDfAUXtzFgU1ic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fDeKJRIQoUWqxjV7n4Ky9J09n+IIRHAAi7VsV3lDRQxJgy0ajNzavSe2IJZmQo8C+
	 RFQGyiEnACBiv5JFmeVZTOsdi3v30Gj4yk94TzBtLIIO8a3K+zzt3e2kYb/MpOqpsN
	 S/+jNKrosp68mtox8Fy1xkpF6qC5OhaodQPuyRKoiXo40wqvP6dkzgXSUl3tGh6DUW
	 fnVEzWB+2DotZlfr0oTJcLRUG8dNtWoNaCE2loO2fTGN+IDvS2QOpYPUOxhhMsPF3O
	 bMByXt7/Tkqi/81h6Ol/avfWmWeC0EoLgSqd26mtPqr6YaHXb00BhQkpkPtrGZfDyn
	 ba5o9eQotuKzg==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Dave Hansen <dave.hansen@intel.com>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, =?utf-8?B?Qmo=?=
 =?utf-8?B?w7ZybiBUw7ZwZWw=?=
 <bjorn@rivosinc.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>, Muchun Song
 <songmuchun@bytedance.com>
Subject: Re: [PATCH v2 3/4] riscv/mm: fix missing destructor for hotplug PUD
 tables
In-Reply-To: <20261010112457.49485-4-songmuchun@bytedance.com>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-4-songmuchun@bytedance.com>
Date: Mon, 12 Oct 2026 17:35:53 +0200
Message-ID: <87a4ojaq3q.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1AF140008
X-Rspam-User: 
X-Stat-Signature: bwze5x1ygcuppdykhu5x9r8433zkgq7w
X-HE-Tag: 1791819357-780108
X-HE-Meta: U2FsdGVkX18Dw4MGLhqfwsP8n4fLF3WOoDtMPFC/AoTt1Jc81+HXeZFW4FzPEPAq68XOEQx67nu9E/3eCdnuTiI8H0kEvNq10JoYQIQvu2KlTP6hBeCaSRnSefExS+GHOzOr4W7H3qL1HIClncaghUjrzG4OpqVvlOr+zVq5Lm6LJRvZhWLza6SSCIU45/ZIYcxdDmnqc/zZOK+X+Cg+qCNkA7FITGxfj13HECawszGlW6ez0o1uTVn4w218/F1Y6PFtSHMAjM6YB9dViRJVd3PS/ri9D2Cv4TtoLpX7r7C/m0mdm7HQQUWJYrrBAHKs0bCuNTmxqduN2ZgL+9m/wvAXIm+H9EanrGbqN1T7XUXCdrOGhUprLxo4IVf0+7sBTQ4kkya7Z1/SX7HhIXLewP5jeKTIfY+GDBimEZ5mOC+/aVOg+cut7hBb2c0spfVF3DCrBmnj4GNj+c/dQrkqKEhLTLx4nAJfblzl8bKumkZTJZdGR9AQcZfwvc20qhnyK0yScYKtwYnoDHqcQC2ZHo0xXu64HCmc/qPB5t6p9purAoxppMJqGqwVEz3CAgb6gDWaV3OA64QvYJapqB3Ti2/LPTzajpwE5OOJL/TPljbx2R0J0ZFES672lW5E2B0RLjQeEhnANf6/QtI4GuwWWtFFTmuT8pIJK75GHCcoa8jQWDoFvucmZ9hQKmeVxymvHnMATFNITKBTt/0SVquCKXTvn5EeNA8JWgy/BIbAbWXvwa5ExI90QGWNKCDr+VAlebbcMBSZ7Y8EhxUKLPxJJ2a3m+sag70zerCSY06b/lVireMeGYVq1X49IZg0i6PHyb2YNJyag3wzNMtRkMcuGroT0bRBCS5kwdgQ4XAvBkUcniV26bray/QwTs6JEyqjfDjAIP6App94fO5j3O3RhdTh6R2LV8JyfQD22pBZPuCwKIvH2rnqE9ORRBkyKttB/shTt9ZaNXGCWM5tysk
 wVAp6uND
 YuisPRCMYeosuR+zBYeHj/5xAWtQLjaeLZiWDxHPx4C4hlrEZ25KC4a91BSCqxNDAuFT5vbWSZszrQLNojT3GVG6wiWiXZIV+zmbFj3oUbk5WsWrAoAHlCUSGwuGfr/bf+ZESSLcaRWJl1svnDMSMNgCpT3/h86XS1gnyLCQpk5vub7tiEG2nsUqlEXBzTueRkMRW2egumAq4lI3B4w6evHUqsXQBSi3lRqoh9RWFO/nCNtGTh7szqtZMDhUrBsfMbih9uJneSF/QjsIcE+z2B1HtUAwgzMwE+2NZTmGFYxQj8AZxjiCgzfTi8ZRpXhoV7j9/Bh+zPbJD/no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <songmuchun@bytedance.com> writes:

> Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
> pgtable alloc") made alloc_pud_late() run the PUD page-table constructor.
> However, free_pud_table() still frees non-reserved PUD tables directly
> without decrementing NR_PAGETABLE.
>
> Free PUD tables through the common free_pgtable_page() helper so that
> constructor-backed tables run the matching destructor before being
> freed.
>
> Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel pgta=
ble alloc")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

