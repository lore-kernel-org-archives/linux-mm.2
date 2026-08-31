Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC88C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6671D6B008A; Mon, 31 Aug 2026 02:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617926B008C; Mon, 31 Aug 2026 02:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DD26B0092; Mon, 31 Aug 2026 02:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2BC6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:09:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1C11A3F22
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:09:01 +0000 (UTC)
X-FDA: 85160536482.16.2C34E09
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D86DC0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:08:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=Zo5ah6JU;
	spf=pass (imf10.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788156540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qoFo7+PxqjttbtK92O/ZZGktuuQcYVg2E/w5Dp6VQ88=;
	b=5T5P6AWC87ERyIHPDxlIZLusfaMHHuTuXfzNVmQ3TUPaB+96YlO5CcXmLFiYxGj/oR4DSp
	sPJxDPs1TCNxgNO0XIXbW8yMUyjYbBGJC8qmDwpcs1bK5Gi1SAxRs21ZtQQP9etLtE2YJv
	mISMqBF5DDvP0OaK3bGRiAd5w50KaFU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788156540;
	b=QDpUC29/nHIgLo0ZktYHOm0jQC59A7eF2i0nIqumEijIVhxqEoHVkSifzJIfLl6x0+OISs
	JB0c8UJD6xiOwvc51iLCfdJkLf9dEAvbZMT7u374yyhXubdoDmMGl33bX8AlqIeNYYBIlc
	L2VorFm3RCM7cgUKRakpa3eEEC3rKYI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=Zo5ah6JU;
	spf=pass (imf10.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=qoFo7+PxqjttbtK92O/ZZGktuuQcYVg2E/w5Dp6VQ88=; t=1788156539;
	x=1788761339; b=Zo5ah6JUu0ZlAUM2pvycc0KkDyMzfSziJZfTRutDjyK5pIbDak5hLLOE5CAya
	tuKMDoJm8h1Fl1rZh+OI29oMuuj79Ijdkm+5q16jSb0gZfCaRG3B96FS0xLey+hmquKljl/CYXbW2
	UdF2SkQXCUlMp37CqLnn7hX5FgggXVg5ajqtIjspHxVGRd5/MXmShfxyP4me9/hJhsKMyABuLilH4
	WEdn0dxbplJPK7N0I/tDH5VDYU1qme1Bg5oK7Dn9eZQ6QWOLqVHVpEB7k8dO3Vzj2aE6Hg0zZK0jB
	5ltPu1pBDahrpUwQccsKGWcTEz9b1ok/7DVvs1tscEr5IBFA/w==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1x0vCP-00000003S29-3Hzv; Mon, 31 Aug 2026 08:08:53 +0200
Received: from dynamic-002-242-195-014.2.242.pool.telefonica.de ([2.242.195.14] helo=[192.168.178.50])
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1x0vCP-00000000yAZ-2A6t; Mon, 31 Aug 2026 08:08:53 +0200
Message-ID: <d766413f91cd778912f6af372d3d5429bac7765f.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 0/8] mm: Drop pxd_ERROR()
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: samuel.holland@sifive.com, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes	 <ljs@kernel.org>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker	 <dalias@libc.org>, "James E.J.
 Bottomley"	 <James.Bottomley@HansenPartnership.com>, Helge Deller
 <deller@gmx.de>,  Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 31 Aug 2026 08:08:52 +0200
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 2.242.195.14
X-ZEDAT-Hint: PO
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D86DC0003
X-Stat-Signature: req63uj5qj1ryszky3fezts9dyqkjusn
X-HE-Tag: 1788156539-921977
X-HE-Meta: U2FsdGVkX19cCGc5TMHYHF8K8cv/fUv0rCqBKiuPVxiWBgbeDz0b9ZUL9ptDPBrfvyefw8kDDTU8iPfooDfr+FcvtuifsvP+NHFut5gXl0n2MsAFnyPHlo4TD8fMGU1O7kH/hcQ8sVD75oAunpiGQVqKX5YnS6L5qQVK8oBI6XmMfMrhrM3ej+T0s0G52KLvBoeSyRK1GAYB12jN74hHNbsP0jjZoVkp8vqtqERShfvKfvK4tO20Jc7DI6qEWBs3IM+iPqY9W/7BhOkg8+8qnkhywiSCsqLAYbLh1zZ3+cmYYbST2t5y6OpGomvjG2H38Cp9uYnVXPgrd0FyzhksgR/Njamqx64Pf18ZlxaWQAK/Lc16/mn3LMZUNvwM8wq6kDXUdGfVF/IXF1xig3YlnoRMWFLM3iBK5G+JvnQPZHyugqVO88UmiH4tRh0Fui+tHre24D8ZQnK8NMYbhuJKzPd1twYVaETTHvfkv/0cSlKr2J8fPH9qJ5Z5+TcruLuGA3WQxTpWxf54/KwOSa9qzlOgICNpKRqVvXX1U5ThDEr7QIUmHuIwb6eVFhfwQtlKVpXHqocVDfqkdYZVMdOXw4X04R6oaxtJRwQeLVInc6dkYot2ObxVX7uvJB3dyDd5nHexEdFRs4VzmAg6oZfBneA11FkstxsaeCeYAVv6alBdkyT6K/VSZsUd5Sw3yeIRYvIeHSPXmtXutQcy3SWJL2CbJlCt9YvYEhTt30MZB0BZGITKgXNoAKW3MuHKiVE1+ZG53Dt9oZs+Qx88m4NmdN9/QgGLWvK9bqis7EObuOyLm/fWxLugNBp76LDdNz7Ti4lpKlk11eJSafoEzR4BrToryYi1F/EOTVylKP6rOgp62fPU9/8sN8hR6SaeaF/WcPtJDJ4HS72Gr6iEP8maIPial6MzcDQ7lK4cIwXiWkfXCRq1t+Juvvu6O8QYVgLMN1H4On1tZqzlsM0cQpq
 +prvv90W
 Gg0VXKhLnqVc5ibjahd39RvayOnNLVz38C3DDTfjL7r3zSd2FfpoEp53tu19/8XmIaOnwuD6Cm8z/qGxZNHXNFdJmb/isT1B23W9XSeVAnO/zm4c3wmq/eu/BOsiUjdPw3fmXZa+6PYWpPN+j5HUVfkWqMNcnL5PtM4091f34xh4hTlSqUke0Yh4FYsIVNrRIZeCPpwvZPqYM72rhondje0+7/ZnempvbIk6QjgaHS8zFaFCMhM9x2l1C5zoae75pF+2EYTvoAIeRMftjSMbURA1jbYZca6uSD6nlsQ/4QJXshLP+03PG8DenuPintH51SLsoZo30+UYBrs5dvBo36deN1JwFGmIRiIkiYPM/N4A9alyFsC07NBabRYCHybElaPCuefsJU2ZgybDqGAb80117YcYhOCjSqJH8WqXjJtH+Q94Lb30QcXBPCnQ0Z0PYTYnSQD1Gx3gmvrtLGgiTWORpwDLXge7Gg4LkhwIECCaSyDTrS1qO6DxuEdLbi24+qZOi69f8Ysmryl0Kz7ii9O2hQOIuKetc0+wN/9HAUKlT14jVH0bZ8FFMTcxiDfM0aNecYx8kIgUCz13dO/Ji/blebmmW7Ar12BNmigCEAT0EUa6KTG6uVUy+1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anshuman,

On Mon, 2026-08-31 at 11:13 +0530, Anshuman Khandual wrote:
> pxd_ERROR() macros have been provided by all platforms, which are very mu=
ch
> identical and can be dropped off completely if these pgtable printing cou=
ld
> be moved to callers in generic MM aka all pxd_clear_bad().

If pxd_ERROR() macros are really all identical, why not provide a common de=
finiton
of that macro? I'm always a bit concerned about such changes as there is al=
ways
a risk to oversee arch-specific peculiarities.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

