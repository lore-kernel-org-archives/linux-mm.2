Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06005C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35376B0092; Thu, 17 Sep 2026 20:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE71D6B0096; Thu, 17 Sep 2026 20:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFBF06B0098; Thu, 17 Sep 2026 20:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B16056B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:28:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 114A5C0413
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:28:38 +0000 (UTC)
X-FDA: 85224997116.23.0703B47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8384C160007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:28:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGLKgzwS;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789691316;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjEB8YoSvr2E8wX9cD7isVumdC5ySqRIBYWNH1Q63aQ=;
	b=WBfocLq+CgWM1ORe9tRKL/UXGY1KW7UP/GS4u1eyVEzLfyZ04VgA4xHg3gPr6k74o9Wnph
	4YMY3jBbHmcwQsaJkoawgj1qBnanTaILyb88EIIJ9Y6691C8ttv9hWtDsLQ4XBzVKHSuCJ
	KvQIoxKDQXtGDvCDUsZ/OaG8mtmgRkI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789691316;
	b=TeUFFEmKsqmgq1MTSUFnyTOfdYXTPIITHNdIPqW//FNZ7T5deXNoDooCT30rH1KPMLONGH
	05TSHrYMimmh22O7IdV8YxRfPqv0Vn1lZsgsuK4DqnjPFiYwX7nhIavqOXUFu4QQWTzzlx
	UAa5a6wlZ4bqk2qbSTQjHwhjXmb+HkU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGLKgzwS;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8FC6601FF;
	Fri, 18 Sep 2026 00:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCF71F00898;
	Fri, 18 Sep 2026 00:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789691315;
	bh=OjEB8YoSvr2E8wX9cD7isVumdC5ySqRIBYWNH1Q63aQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NGLKgzwSwrIvn0iCT+qFyEn8qxZ/uTuu+fXrTh3zKpK5AZt9AvxAH+dw6o5ejPH/z
	 3dMXhPmDyMvjetdJHJhHMHHnx6Ig3uXk5NV9Spo9luo2PJwSGKFuT797OkbSjTAONn
	 C0myLUPUVv/sFeYO8D9VgGhhs0lDiX1KaTGUPGLobwwaoujqlI3tkM5UJWdxKb05gA
	 Mo5eEA2rdlnqSg6wMSMwS+5ZANvMb/kKJ3Nk8krN77jCrFzzV8J8eHjl3azqPgGXEz
	 miQyiBHQZpvDDEvXuZmlRDeO2PPfsWQi9mB8rOT+NxRXNYgaGiWXwfXveYEXUepkf3
	 G4a9Wv70HEZ5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] memblock: drop for_each_memblock_type() and open
 code its users
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, "Mike Rapoport" <rppt@kernel.org>, dmatlack@google.com, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-kernel@vger.kernel.org, dev.jain@arm.com, "Pratyush Yadav" <pratyush@kernel.org>, linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20260918002239.4024231-1-tarunsahu@google.com>
References: <20260918002239.4024231-1-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 00:28:34 +0000
Message-Id: <20260918002835.4BCF71F00898@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yif7qen577n7efqq6qd8wz8zggfrgxae
X-Rspamd-Queue-Id: 8384C160007
X-HE-Tag: 1789691316-591672
X-HE-Meta: U2FsdGVkX19pj7Iodm4k8M/jkZS4B396a6nc8Owraj2CDr/KkvTQUmf7Hl+L9OVxaQmMTH0sYJsizi10JXXfheEHb1JiCPL17OqLQtoZ31w+iQmSd3iQ04+dttmdROIyc7oaUSr9HY2hIrP8lu/C+xejWCgnogvqHaW4NNovKTCQtVUqawOGL+FjnAzInpcfEzRXFObBfbyHKw+fIAmOhn9KJ+MDDvcBRUKXXTRFYmTPRDxHjyfyjvNd/YYsOH4+Lmkxs0sK68pqWG2xDMb1rABbuQay54XWNYHQfn35rz+NulNA6H+ApKRWE95d4sg06hgcb7ROTynUr399ESrFybCP3iRu0SlKf5Wrft7Xg5sNTcN8lqwWrWb3xV5FM5ZM9Deym9SoyBc0yS5udKVtnvmPrxCnsSCfgUpTq+TBRyKQfXSS2DLMS/OhjT2kHlwunHiXPLZKUoGTXWJVAGOAnPEFxhLpP7Ae0zjRGXfZ5Ud3Pn1Qf4unMc3PfCq5IjlzUn+bOQTFEEHOV/ARhRd4ZF8SVxkD6kwrtaTHK1qhIR15fO4PLg7KJbaEK4j/rx6/MXFaqDLJ5xfc9o4Z0ZN9bRVVpN64HO2qVRVdEpOMJUVPabvnO06xfFEhVQGTWt1Lnc1C6d62BGcGpzo48Q7kQHaRdlHAPB2O05TmoRWzXDiFseGXD+cYcfvze7BopyJfLI510MVOhLYy301c0Cm6x0w/ULogung9wqMuFFPOdZNKyN6hVgnpz4xQYwJXMgyvyyqi2tIQlPs9rkO1S/Tn2W8JRD921bEftOkmfMbINH/vmtKlMpyjUy5AFrQQltT6i7U61bF5Nljh61T8Ba4F2wn+Kvyck2a+fBKvasVxA/skW8CCW8YRlbouARV5Fdl76aCvibBTT0Wo1LrrU8nKxgQ6maOIMkgZbUf6uhBG0DyiUrBr+TCT5fku+8fa7Gb6C2tUQn4Fu87GPm04w3y
 05WhsY0t
 NQ0hxlTWiOncBjz17d5DWS83VLo2sTReQqTDKGByhHwY/T4RNaZ1I4nRtwPug+duOvYYG3jJRDBnjPmkD+0FiRQsLBnoxmOAQhJ8tXBl7gtTA8lMnJOH1ImApESVOBZlnfVCN864DGVOAPhimZraTb513KhZnbSDHeWT95aJE64jHHTqhlIyU5ftLRuiYoKN1Wm5HZx9VbBwT/3bjhidaLXOWpdPh2KPY8GA+yEObaxZ9JCpL1TQfyPLH5uADRBjkhdiKHbJRePdH16tb89vVPkXYVkNgk0Kx2hbKshy9hzu0+/jPx7eb45gRa4xFEW2WcQAkaBtXMinlw87fl0Ey3fQD2x3o8s2foXTVGCKBKahNGRDbCZG2uhHRIB3SaYTpXpz2PwjmgxUx3HOfL2Fwuw6+hOosbXCwsH2u8Iq39SFKYAkxxKydhwOsZG8IWOPJBsAZETybPr5x/znLtRM4nLQ13gv6xpgKdtnKrfdT0QmYogAytGlK0/awcL+iEeSvJ8WtYUr6H9bXxjq6KXsq2xkmEJFzUbnpjs5ggxy7Kv9LcFH/fIzCpHyhiOVnHrmYvP7GsRs44m0GN8TxHvVxWsS0P3Oer2rWUasS/ffNW8/Q4b/p4TjJLJnzPsuwrfEVGnzxJqq+c5vxgSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] mm: commit message and implementation mismatch regarding variable s=
cope
--

commit c0dca5a3d7239e89d9dccb549819f0c9f7139656
Author: Tarun Sahu <tarunsahu@google.com>

memblock: drop for_each_memblock_type() and open code its users
   =20
Remove the for_each_memblock_type() macro and open code its users to
allow iterating from an arbitrary index. The three users modified are
memblock_add_range(), memblock_isolate_range(), and memblock_dump().

> Remove the macro and open code its three users: memblock_add_range(),
> memblock_isolate_range() and memblock_dump(). While at it, move the
> region pointer into the loop body scope.

[Severity: Low]
This isn't a bug, but the commit message mentions moving the region pointer
into the loop body scope.

Looking at memblock_add_range(), memblock_isolate_range(), and
memblock_dump() in mm/memblock.c, the declaration for=20
struct memblock_region *rgn remains at the top-level function scope rather
than being moved inside the newly open-coded for loops.

Did this patch miss moving the declaration of the rgn pointer into the
loop blocks as intended?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918002239.4024=
231-1-tarunsahu@google.com?part=3D1

