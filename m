Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C78A8D6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF4C6B0089; Thu, 18 Dec 2025 12:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D146B008C; Thu, 18 Dec 2025 12:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F606B0092; Thu, 18 Dec 2025 12:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15FAE6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:56:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7D44B5C4B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:56:25 +0000 (UTC)
X-FDA: 84233346330.02.330D285
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id CF58B80011
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:56:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GDtRo0OA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080583; a=rsa-sha256;
	cv=none;
	b=dsz5srIeq3j6zRRJR4jEq2QoIPFy5QxufCyBNPGEoWeiImPmZvPCFj2vN0DgtAkoWPeLjM
	+iUn4K1r/U+4DZ/FxsidaEz1xyU/T9vjmwOeWCfZy245GKT7KbrqsOm1Sf8XB9Hxk4mNhW
	DX+/kAGcd6is6k/eRQ+XRHsMEQnbfws=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GDtRo0OA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+6WN6/p1fp60hzkSr+llXdbvd+YBmTxfk1iXBMLJZA=;
	b=rdoFWsixBoJgdASXUTNJbA8ccUED9Mbv7pkX8LOvrueykbQWN+4CSR28RT4Sl6XS1cwBJa
	RnFmNQ02n0NxoYWTqwpR7yAVQOgqj9NsL8QGRUKsdJZwovicCnE9Y5p2HL78nkzsCO02Gp
	uwhZSAr47z9gdv0ub3OiVFVdc48OccA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b81ec3701so615293a12.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766080582; x=1766685382; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+6WN6/p1fp60hzkSr+llXdbvd+YBmTxfk1iXBMLJZA=;
        b=GDtRo0OAG0SySz6ok1bs34S0VTrq5xkfd014kXGbqp59NTbnfDsFDFlzlo8ZqqttoT
         bgF+zKlqUdMbEzH5LQBkPFSJ6tVk0dnqXt5A7tBBkfO82lZbddaKkKdS9EPFjn8WrZ7A
         fPWMyokuLZtDNQIeTmLG9yaI77Qv6bCqHOwOLinHYAKdoJATqXOwNJXpDKf2zrX2fF3x
         VQNN2Wfk5iEHiUdhGLdEzuDHAP2qDNxBdFCKDOaW4DrYlk1qdBN67YE8myxaiMuQQyAP
         GtKNlqwQd+zXdD8RqsxBFxB7JJsJG+EoRUA8ArhP2TFjDUntRXq3yHNc9dNgfT+jn2k+
         AGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080582; x=1766685382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+6WN6/p1fp60hzkSr+llXdbvd+YBmTxfk1iXBMLJZA=;
        b=AH90qgp0Cc8ZRfNMjtKKMfqgbatf0+swn2kyJV0wfAXNg1Dx0w92W/3pRnYZk+kSz/
         9+o6DAUVvKC188A58Mets3P/GYmpGspatLRwZFmF1I9qmT+7rYmv7UD+N+qJh2m7HT3f
         c5xLBSHfV3l4L0C/QP6Ecy3q6bhp8k6jwGfM1A13oQzfLGyv9eOfPcCXhIHixHyCB1vz
         DWwYCx6YFfxItW8MiNIvyNAYzBc6Od5VnXBgDDhoHnqYPY8xd+QcnXo20azrUstvuMCw
         6xEnBl6r2l1q9gvmUn306j62VjCrotl/NiuQ74twh+xjRxMXp3dyPHQqkVAvqUiOsHnZ
         xS2g==
X-Gm-Message-State: AOJu0YwxNogGqHelV8Vflw3fjBlPbMnR8DauaMUJkZiE84eAmSXq++ak
	Ameio6Jwe3EqWtbWW1peX3A2ZJbHu5PwJUFbn7kO73yNCVf7gNumSnsCnabOU6S27elMoMPhHgt
	rAD/9u4RjOuceatZRAJUj6B3ANGBwjjbVx6Pu/tYGIw==
X-Gm-Gg: AY/fxX7e99J0CpspHcnW/4//u8ORj6NhRlZALWLzpTgQ/YbKrYAGjyOzqsZsiJ4Iz8h
	y/ISALCHcGneghsZGI3p6APNssPymrva21cY+g69gUfsespnUEx9wudnS45heq5XtJViEVH1txd
	pdNBsHaDEE0zyLlxbo/6n8CIIK2sH1LK5KYYVnXrs03mH8yuP4xT8xOchDY8ODFAT/B0+cixF8V
	ZS4Y+2n8idG7MWuwsza2/+bSA5z/XDFSmOuS7YKFgXpO2arYPlcWbYGIPwYLIkHigN5iwi+DmAk
	Jwxm1zaFrvsUCzJ6cJWVFNSM
X-Google-Smtp-Source: AGHT+IFq7ELTQKzF/TRk0SfbylhiIq5ob7abkvIiaiZCwA97lZgHawIVNTbXj5kEfVQ3oQIcBivxjmxKv95IDYu+mh0=
X-Received: by 2002:a05:6402:35c1:b0:649:e5be:1b4e with SMTP id
 4fb4d7f45d1cf-64b8e94d187mr222712a12.9.1766080582211; Thu, 18 Dec 2025
 09:56:22 -0800 (PST)
MIME-Version: 1.0
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
In-Reply-To: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 12:55:45 -0500
X-Gm-Features: AQt7F2qjqHZAYpNwxuF-SUIUKVwppChumOkUsgRootjGM8dZ2yshNK1pTfmluNo
Message-ID: <CA+CK2bBjoQmheEstv1MacGev_srdx=m5v=hwxdyfAKogbpG3FA@mail.gmail.com>
Subject: Re: [PATCH v18 00/12] Support page table check on PowerPC
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>, 
	Christophe Leroy <chleroy@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org, 
	Nicholas Miehlbradt <nicholas@linux.ibm.com>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, Srish Srinivasan <ssrish@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CF58B80011
X-Stat-Signature: rd7whnhspimmgapaecoczxtdkggrquro
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766080583-19948
X-HE-Meta: U2FsdGVkX19CR2Z03VLQ0EzjPM5x/OQS9NFm3v4+FDFSwYoxTfDErsnOiiwgA0ovbROyCDeRqrCqTauwgON55m8U1z5ZyST43eYNI+O48x3mC3wU/4upC1nWOR3+8qAaK2VwZKclCOHoxdDZAgOMCdMflRC6hChmOlRWjf5h3sjKtM3tMPloQnvxq+i7TGmKSLvfjxGNVLMM5o9CVy/eYGqLJkbLKDscbETlVpv2EP4dFW2AYAVb3tBPaVy6IPlKjBDmzmZJEohjQVXdhSEuUDwaWlRGCMIWIfxM8dNOrXr2VK61ySIIeDExzXkkE/tW045or4ChuW+i9gX5ctzcC3tUOFifJ2nGQGEcXC9U8rrkhKPCQf0PLggHtBlaisUNAo+VIbC0jCabSumHaYuocOFEo0jXDsJ/h/48GyC7k6Xpd3wbjTtGDnCHu23CVcldEyTNr4/PcHgjp2Nf2l6JVGX/n1emXSUfBHsWG+cmTGXPFtOZxlwyMC4giOgp/OKKywsmk81yi1Josl4KEhzsH70sS55Bd0Z48SeHNonDueTNzGNmTi9oBE3Mnlb3IL2FfKgsi2wbLRIGlmteKEk1fv2GjXuXjrR3Je6In7k4kGS8pAyO44ULbErFWdFTVUfB/L8UlUpPWjKvC8omhYm8U+r11qDjo+cf3EhhS5I7CPqmqcPkWehnHH9ROIhEbQGcNlTcyg9pSOxUyW31SS9ohjOSOEBEoVPJdlAyiBTo9FhM5g8KUTDgqM/3qHOBxgbMqkUvaHQC0FVsXiAMFlRjsklqHT2fwSBXVjLOJlX55gSk1e+I7XfYr7DowmV2qil9UALn2bAIYE2AGbre+n/YIh92u4uwf4Trza6T80bw8wqFn5He1oJIAC55dOZj9iUvwBfMG99JTwbpbbZ1z6Er11H9XPk2KOkBXuqt+dgLD8APWb4AT0E8nIrZZzSRGcl2PEhfCfCJ0JfvFATubJ/
 lQXOAA3b
 9rd8W/yf3fIC3K5UNyk6kphnc0fy6s57icSBX/GDwKvbl1kx1ywMB6luaivJdmfM3wjjd0FKHQ7hKjOq+bZlTrl9xT3NuagdLIh/QdeGIM9Cf49TSPtNrkPTBp4k3YnXGgF6rwEIpAgXVglD3uxXQ4yInWHsr/5/ZKjtR2n7HQUXZBXaq1cpez9lzKe/9p+sJeEr1Z+NeHVLmVqJ9Idl3g5xonaIBGi1hCZ/way4alBx7E2Cs6LZSDR674GRLEtmJqkDGlB8ke2mAehOOHBDm/LIzGtq2IT/hUi5ljTS3VVw4K0c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:10=E2=80=AFPM Andrew Donnellan <ajd@linux.ibm.co=
m> wrote:
>
> [I will be leaving IBM in about a month from now, and will also be on lea=
ve
> for most of that time starting tomorrow. I've cc'd my personal email, whi=
ch
> I am going to use for any kernel development I do after I leave, and also
> Srish Srinivasan, who will be taking over some of my work.]
>
> Support page table check on PowerPC. Page table check tracks the usage of
> of page table entries at each level to ensure that anonymous mappings hav=
e
> at most one writable consumer, and likewise that file-backed mappings are
> not simultaneously also anonymous mappings.
>
> In order to support this infrastructure, a number of helpers or stubs mus=
t be
> defined or updated for all powerpc platforms. Additionally, we separate
> set_pte_at() and set_pte_at_unchecked(), to allow for internal, uninstrum=
ented
> mappings.
>
> On some PowerPC platforms, implementing {pte,pmd,pud}_user_accessible_pag=
e()
> requires the address. We revert previous changes that removed the address
> parameter from various interfaces, and add it to some other interfaces,
> in order to allow this.
>
> For now, we don't allow page table check alongside HUGETLB_PAGE, due to t=
he
> arch-specific complexity of set_huge_page_at(). (I'm sure I could figure
> this out, but I have to get this version on this list before I leave my j=
ob.)
>
> This series was initially written by Rohan McLure, who has left IBM and
> is no longer working on powerpc.
>
> v18:
>  * Rebase on mm-new
>  * Add instrumentation for pudp_invalidate()
>  * Add cleanup patch to use pte_advance_pfn()
>  * Move p{m,u}d_user_accessible_page() to a more sensible place in the co=
de
>  * Disable when HUGETLB_PAGE is enabled

Thank you. This series looks good to me.

Pasha

