Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FABCD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 22:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF416B0005; Tue, 19 May 2026 18:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6BB6B0088; Tue, 19 May 2026 18:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCC26B008A; Tue, 19 May 2026 18:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D39C6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:41:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C5191C0A85
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:41:17 +0000 (UTC)
X-FDA: 84785641794.11.309E027
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3699F1C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:41:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rrKh4fo1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779230475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc7IUMGtW/r1T1j9OaU9cZaiuWsQdebfgPPEltdLKlk=;
	b=RaL95JpYcHZwDVCIuc7p7GCJ/RJf3juY6zQdo/DoHCmXw6ZdjxI3Oxxl/7q8H56zJalnXK
	RX3Xs1xVcbjC8tNZhmXAroNBHuw+WDkTYTZKySANasuW6r8zibBKwP4Um9mnWRH84X8mbt
	7NZtdeaE349UJK85b8jnsIWXTn7bqPg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779230475; a=rsa-sha256;
	cv=pass;
	b=IstVJczuUs+79r0QoJkAQZqG/CeFoMKnmFhbDHxfMrOA3Y2nUwVq4iJQcxbiuxQaDefknN
	ygu8R7XS7mrbHux/D3LHMaeep+EYIFjicH/3KVmICJXO9M8DpB2IcFCUuixrI+uu/wRhYU
	I+JZEB+ruk8FRuur2GmQphOcQExnDNA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rrKh4fo1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-43a2ad7bcc4so1791693fac.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 15:41:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779230474; cv=none;
        d=google.com; s=arc-20240605;
        b=JIJ7l3rlf9tbJ7Hp4idOzgtrYW1x7Ac1WLg66VJ2n5K/uWhqeh1wYlQU91C52xjwSQ
         bPccM2a1I46LbsHxrQanVoxfhdz4muguEVQ5RM5+IQxx+S+ZYvinqE9asqug+a/Hv8p2
         Rm2uV9Pfbm995FLwhfK0k0QF8XwuLHb67VbyumpMXJheRmmACJ610fIgsJQNstzWTZqK
         by4kH6H56Cow6GT93lsO4ORORopDWccvJzHMTNBRXbx/FPGYYC7H0qVLhczG+9RHUCu1
         fp25fICL8i39E8XiOsqHhFBUG86MTexehoYJJG8B8DVoDtQpA8LR8d94b/kQCF0Bpo6Q
         mdWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Oc7IUMGtW/r1T1j9OaU9cZaiuWsQdebfgPPEltdLKlk=;
        fh=pRNu+vHZ0N5rivZ2ULcOjqWoVXhqPhUQK0hiSvYq5nE=;
        b=LldvJTWCurFu8bDDt7pwa3mcOc/1oZTkfAV+uy8aHVID2wdltVu3rSWdLxxUUKZp/u
         eGwGeGcn+UCJ5M3kKRQCq4uwOJExU/YjVvqqLlbVrzCVGSFaxZWMBvgzos4ZJlQ5FRXf
         DcAV9R3czi+v2Bj35dS1kqBjJkYQoKDXJbAIXaZ6c4TW3EBb7wPDIPNgx0x+Cp8SMKtt
         gpgT/HSCDcu37nKyhOT6aGGbqwLLTgR5hGZWVaThSfZA2wvtinujxOIBBRFeYDYTTlnG
         bq1b1sX3MpANbhtEKNQ+3z1JVbVFCANKIO3DBKF3c+97NW47SCLeUEe7rLKEm4ksYj3h
         tweg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779230474; x=1779835274; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Oc7IUMGtW/r1T1j9OaU9cZaiuWsQdebfgPPEltdLKlk=;
        b=rrKh4fo1hvIk8YOE4WFPpZFcQlxTdFwaBYiBSBx0/SlUMfdaRTm9MOSpDa/SH4NrEj
         D/1L4G6urC5zFIJtDCc4IqlQsQaAUBdqet5CZSkTO7zZG4X7igWWsM8RCov9RKdOtla+
         sHF2INl5M0VhgxJZQ3HEC9SwnXZ6bFPyPff1jAK3Zh2F/mj5bNBk1TnzBPQpHpQ19CN/
         ZJ2U0EB8Dx3c/AAX/HnwEZ8UAZ6D/ixcfe51/DoXSkNCG1VnX1Mib75mkahgksIGbc4c
         LdlLldvu24uwsxrnEmV/lbgk1sRgJf/W1c6eKtyspuVMpM9Qh6PyLvAIR8BK9n7UQy2L
         9Ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779230474; x=1779835274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oc7IUMGtW/r1T1j9OaU9cZaiuWsQdebfgPPEltdLKlk=;
        b=e3LA2rVpps9TZLwjkKGzc2cwaA1Tguv2kKKB8Kvg6+asfGJC57zM+L+barI26+CWwI
         Ins/C2EV05cd//F7LLrkJGl0FRwMeFWvJ6zdYJCoX4o+LcTLGv0kN1rA/KVNDY6sAxWy
         n+w1klc3Dgy/pUNGS+jvtYCc/zv3zSaIqlETlbL8wEg0CrbO1OTONq+2OmaZfjkArdbs
         3sj1NFnQRdvnM8qDgNwHT9E4C/U6+asWSNYg+7pJnGkieMQMheTaqzl3F+elFn+Z27EG
         r9U2DpdDMZuDlJcEXTKnwE4DRqDvHbnc+17WGfI8BfQtV9LFh6ci9tPeAgXpYdGwIO7Y
         7LbA==
X-Forwarded-Encrypted: i=1; AFNElJ/Zqnk+VAFNa5Z/008dFE6nFhf/r2DcSv4+FXH+qSmXE1DsqGF45r5Uxr8mTjYCJDst6VxWVQfdjg==@kvack.org
X-Gm-Message-State: AOJu0YzqhtToUf2LiZyBrBG8sJC5fGnNCpz29lwLrmSLfAxajz6+stW1
	y8lUx4Ro5mCCDdLBIl8InzAG8vnpeq4G9HsL4zl/hHxWM5ipd3Ers8cYgEAtCeV64Pp4uyFFahv
	tSi9Fn6R3Vtn4Gkj990o+9ceuXZcY8jA=
X-Gm-Gg: Acq92OFkaNV0azirVHFrQXsp/dNAj5yOCrVQST55ph4MpKit+5qfMAYDdLZUpeGNnCc
	TWUPgg1/2YsVDIEhDQ9AbWusalvFWTmT1oBeaWpcSIIiUevYycCqL9T/t/urfXyZANSDFLywqMU
	J2x18UOtfVhl/oqTwgSwEw0nXQZO4T7UGdId5H7fZ+4UvCc1Ufp/eF4dNJtKcQWFfdq8YuOGgCW
	Rs3TeXVxtA3ZHFzWTmCXCA8sziWBSodEhVGoP7p4/tM/c4t5pOJ5raeUsQa182swVSfg3yWJHsN
	vxyoBj6HgnhKO3M1YvT/IK2KOc389XUvEMGBdD9y9ehcgcmi
X-Received: by 2002:a05:6820:2203:b0:696:233b:20ef with SMTP id
 006d021491bc7-69c943309afmr13061081eaf.1.1779230474075; Tue, 19 May 2026
 15:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260322052120.14021-1-devnexen@gmail.com> <EE9ACFDB-E601-4C1D-87D1-F5DAC2767CE2@linux.dev>
 <20260519145215.ef37484626f23a82fc7ef992@linux-foundation.org>
In-Reply-To: <20260519145215.ef37484626f23a82fc7ef992@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Tue, 19 May 2026 23:41:03 +0100
X-Gm-Features: AVHnY4KpwUKI-oNYMLKNHdR25CFG2kd_rkQY2_D5LU7bDSFUMRfHw1eYs8vgCgY
Message-ID: <CA+XhMqxzen7g3H5=tENdPKxq0MqGHxpDsYdPFkPsWG_Xuk5Fvw@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: restore reservation on error in
 hugetlb_mfill_atomic_pte() resubmission path
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, YueHaibing <yuehaibing@huawei.com>, 
	Mina Almasry <almasrymina@google.com>, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3699F1C0007
X-Stat-Signature: ws1e9ia1w3n8d57nbes9db5d68w3ad4b
X-Rspam-User: 
X-HE-Tag: 1779230475-168482
X-HE-Meta: U2FsdGVkX18gPBWPmdY2zDJR9RA0/8TG5P46dFXW2awBfdlESrQ0WqrD3YRUTt8bcgPWj2oDQHSEMBRJ8yZY39jzgt38qZY1k0SDocsBRk91DLvFVFT6CaLwI0tWkgnU/8LYUPs8tzNtCVyZkYp0L15x1R5LV/sqbnbU0oIBpXEkhN7gM3eCyntgmdVN2KQzZrCaRUYCEBOr6Uyss1fRc2YeyDioWxvdD7UM1siq0mj7bAtL7aml/hDCQwYw4fnc5zI6tG+3Km3GfMl/WLE329pjLnmbRkMOh2EpoTL6o1It5lck8yVJcxGg01h+Xeaezs/Bql4nO2VWCj6JPHssePkie3eOYAoq0SiQf5RIPxsWEtwCdNxHFUFL7e1BRGWHzMZBk/slV2Dck0/WCxqGrGWHyd9BvOJxIkPr09zW2AO9F5Xg85NGOuCcF7H3BPcC4dQ98lY5uPFfqoRrNb0jLIKdez71jUzgYlR5qavSPMvE7hwqqCSKT531zY0Vr6xRBXS6PJCHUeTy+uxKiNiSJnvzrIPnFKcvEUIQ/DoWsE5OL6JkxheJBZrQzQGMvMzuDoNrO9F+uPuTAGllLAg8H46a/vvf6lAQoXpfZA8oAmLODRnHGat1WRkZ8b2HXv8PCzCW2ev1rEgWmfEiHXfexxh+DShQSCW1JOa2HG0VOZeH+oK0gl0OW06YsCIxyWOAnGb7ZyPMfE8M+Inp7zawU2umwC892DXS2T8Hc/MCJOC/wxB2WJHQZUdWYKL3bL7qkmhwM62ZOIeGruZa2Z3/2k0sKQiFTXWbZe37UHfzxGb12b4UKBR47ffSPcXdl7QvAC/BiO1uO4JKslNJcn6LQ4WcjHfiTq+jQLnBBpFDejivY29Px5tWSPs5uxecN7WQyBQ7H5e/6RaCzrkLMQx8EUd58i9poVKHJq9QQkmLDvPjKoepC3ZXkRnekITL/Yz+V1jdgs3mFAfLpMA7quF
 Sbv6gWDg
 lCUvP7DOiN5K1cbHnDbLEiduFHBjCBesm/2VGv0IstYLgkRsNBJhXdAwxPcg1eEQj98al0z/sfGlRw1pFfoLK0aozDE/7lPwfZFF9sItXVwKI0+yTNqMmonFXSB4ASOr1vALJrpxe8qHefXXVEFrNHIoDOTBPMPog+Fm8xy4Fin/0Jg8FXFJbdRl6QJe/ic/l8nbaZXgBA96FqFS2PO5DmwjwSDbnTiw2g7b5LHOF3OAr75CRHNmew7fPK38KsJXWYT487CLpasUp6BeDGSESGzbtXcNWgauMUfmXu3ZFEh9bBkW/gxq/cbi/+d6BNI6M81dX4KzXspKnqaFqiZEs3r3zm5k6/oLKd+pcP04k2OH2vrRKaQfppm0FQlqHeQQrSnSG5xJ7SbAUxDuJsG+ku0ObB55fHcmamyS014ybGdy11x3RSYA5mXvdx6xLQJhjeafbR/5xg9SWxBiKgcnDoNpN+mKKKCzZaVeSBrlNtdAIaxuQfclQUkU+Gm5nvkR4lu9R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 On Tue, 19 May 2026 14:52:15 -0700 Andrew Morton
<akpm@linux-foundation.org> wrote:
  > David, your patch had cc:stable but I'm not seeing a description of the
  > userspace-visible effects of the bug.  Can you please describe?

  When UFFDIO_COPY's resubmission copy_user_large_folio() fails (e.g.
  -EHWPOISON on a hwpoisoned source page), the per-VMA reservation map
  entry for dst_addr stays marked consumed while free_huge_folio() puts
  h->resv_huge_pages back.  A later fault at the same address then takes
  the no-reservation path and, under pool pressure, SIGBUSes the task at
  an address it had already reserved.  Each hit leaks one map entry for
  the lifetime of the mapping.

  On Sat, 4 Apr 2026 20:59:11 +0800 Muchun Song <muchun.song@linux.dev> wrote:
  > Should the Fixes tag perhaps point to 1cb9dc4b475c instead?

  Yes.  copy_user_large_folio() was void at 8cc5fcbb5be8, so the failing
  arm didn't exist yet; 1cb9dc4b475c is what made it int-returning and
  added the `if (ret) { folio_put(folio); goto out; }` without
  restore_reserve_on_error().  Will fix in v2.

  > Does this imply we might have similar reservation leaks in other error
  > paths touched by 1cb9dc4b475c?

  copy_hugetlb_page_range()'s hugetlb_try_dup_anon_rmap() fallback has
  the same shape and new_folio comes from alloc_hugetlb_folio(dst_vma,
  addr, false), so it leaks the same way.  hugetlb_wp() is fine -- it
  goes through out_release_all which already calls
  restore_reserve_on_error().  I'll send the copy_hugetlb_page_range()
  fix as a separate patch.

Cheers.

