Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A313CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A933F6B008A; Mon, 25 May 2026 10:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44416B008C; Mon, 25 May 2026 10:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A296B0093; Mon, 25 May 2026 10:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884D86B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:43:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 254868B5B1
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:43:44 +0000 (UTC)
X-FDA: 84806211168.14.3838A66
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A13916000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:43:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=QLx4MzY1;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="D xh5/+I";
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779720222; a=rsa-sha256;
	cv=none;
	b=YrSnPaiW3mG9fFRTC59gvhchXQH6Gqk5igS6cCRlwmvkGMYZmz+5dIELQoCdXu2La5yIom
	8rSyBsVEgdZy9oTym+rxPF3/3ud18jbLhYtMKk5pTtTJTSKSuFTnpGUmC9/jmkrFFlrvKB
	UFCMajDtXDPJbQvFvh4BiFnPTpTC1Ck=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=QLx4MzY1;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="D xh5/+I";
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779720222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jX/eef+5e+3NDek/iKSvJbkHZklHUJeTi2/HuriPvfE=;
	b=xVi0+TMPIbnfRMmwl9A1mZMreYKrnUHd51uPrjdqQwOwJMTLUv1j4MKiI1q14bhYq/VShu
	GMUYFS/F5N4gxgqSit1Woj/+FniyOnNTW8zcQBPcdoZagZ9AXpJpkAkHQSz91liDCcfcUr
	rBgidToIHKnvVFXTPDsXcIBtjMYMcyU=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 75713130014D;
	Mon, 25 May 2026 10:43:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 25 May 2026 10:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779720220; x=1779727420; bh=jX/eef+5e+3NDek/iKSvJbkHZklHUJeT
	i2/HuriPvfE=; b=QLx4MzY1ghIsPDK7DvdcQEEj+Hn0ha4L7WsGq2CxwF+IrpbY
	tY6GxCX1zDEUIdt3mL0xh9zU4RdSZbXHTIotgWFMiwrac7XeYRaOxubGbptxqchZ
	ygSE1CAB1jdb9zsF6y3+7CInZNpW9SP4/7AExcZWK3Wya+2chxVSiYmss6MtPbUV
	Nswb7nDKoqxzSyFRvtm/GKbPnEq0Yrvd7HQNjMIu8wMaHSqyG25Ct/m7ZaAMKrBg
	mJJxU1cvAx9Uq7+nK5lOUxgsEQTQDBXbx3IgiA3frgup7Mk+99psl/jq7lXEMpw8
	4IulQpaTLwPb2IEXoYOKIVypScYYvdlyjATNdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779720220; x=
	1779727420; bh=jX/eef+5e+3NDek/iKSvJbkHZklHUJeTi2/HuriPvfE=; b=D
	xh5/+IbJKt0UrVXTG7xh/AKcHWOxDBnngsFU+CMZrME8VM7hL4fHvNHUixJM7Gwm
	GcOXZ5Op1NSDwGrI8ci/ePdalVDPMmAM9IRbOM736xSDJEJKaUlgNyVezcvd3XhY
	ajE7b20lagvNf+qK7FcCbpHB24cLQFdYV7/ASGQInNP+OKFikJastY/Mxh3BStGg
	3iJEXgcQkbHC89RKLdhUi5muROdZa85OZFZsJm1sCzdVMSaDddNqZBiQfHIgbozS
	AnfV4LDtx/Jnch43qkCkAlbzdoCCpb9x4/p0B4biDJZB0kyme7b7zRQoVcA8pxU1
	EM4AxBj9+6df6sQYb7igA==
X-ME-Sender: <xms:G2AUarPuurAybRR1W02bopcZBTYLL8Jl8bubcJDwZ3jmfALv9LrX1A>
    <xme:G2AUauX8bX4thLhh8_JP_mewrlbwi8wvQayqrAOwsPRYqDtqiffZPZy8gTLOdBgG1
    1_3MATGlOVS7xw_uzlB2xKlBfwiI0A-4XImxJd64RDNxVCjskn9cA>
X-ME-Received: <xmr:G2AUakixXQA45ImWqWahhl-JSybTAZfoog1dY9bnXoNHG6Qb7_q3hGWJHr60Hw>
X-ME-Proxy-Cause: dmFkZTGHZHLMjCHc643dxRklLh2oL/Fj1m4IuOELcM7KtVw32eoEW7vO/KG/cKBnN9WuTW
    xcg2IQePNYL331E/+iFrg9l3Q/0DfWc/pfzb7vWOi1Q3A9a5dIAx/Ip8sizV43jID8qi2T
    lPu7yzYYlC4jDwy9+0KEeh9FZYrc3IDuLVpMqBcYmpa2tVNF4MKCjt0kSOcetEMay+qG0j
    wZaWuQuIE2LusEhaCt/KcTuXfzwWNSSA/a6+c4ZC+utd7D9qUqXsnLmKd9bKV8qtvZC2fr
    pc8OG7aEFZFvhoMbEdIROsQzF6nr7BIT6NX92DQHbwsijQVdrSxa73C0r4i4pngBeREvLG
    3IUYQFg2A7oiryRL0Qg9yRjN7sPoqJXEgTAQQW8GtIj+NZaALOuqBBtbIjbbByQVuCOwAl
    yAjhoMTqkzXacKIwL5WT8n63skY7u7qJc5CKpd5O5yD8V+4JcITXhwHDtww4umWoCclqdt
    /BGU1ZySYOzQQglFm1lWlxurT9bxoWiAtzasqvhRc/hSWaaiW0GldL0KLfJX42UagdICtG
    dlWuGo0+6np14viWw3dBgZ2PQd4AXFSXvzaH+0ARf7889aeda3v4orkzR9TKrkqzKscwd0
    unwzLm+7M4+hfY3iGBB7MVG8DfWOMGy9wg/MUa8W1ib7ggHvEHu0EyVKVUkg
X-ME-Proxy: <xmx:G2AUakQ1akuJ6fKSYRRH7I1cr7xRw2ADOhuOaK0bcLS26p4PPM0lVg>
    <xmx:G2AUagxFy3CLUbl5FyBELQ8A1sEn2Zapr_6T7SzNBUlax72GLiD1Gg>
    <xmx:G2AUah8OAV8G6zuRESTPGf9Ikf_YvelhAPuoJAPmR5tPWZa3SoOnXw>
    <xmx:G2AUaqbERbtgJ2nMckXzGoFxqN0PGUu02wow5r717_eb52V_igg2yg>
    <xmx:HGAUao7ZwTazDzOJEN2b8_Qz9hfTC-VqdLvY3yWovvLnIyULEM2jaPuV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 10:43:38 -0400 (EDT)
Date: Mon, 25 May 2026 15:43:32 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 03/14] mm: rename uffd-wp PTE accessors to uffd
Message-ID: <ahRf00RTI4_0Puux@thinkstation>
References: <20260525113737.1942478-4-kas@kernel.org>
 <20260525120513.C51E91F00A3A@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525120513.C51E91F00A3A@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A13916000C
X-Stat-Signature: ghakj5qhkigjbfpgwden3p66kkmttexa
X-HE-Tag: 1779720222-72543
X-HE-Meta: U2FsdGVkX1+1yCK5klPZ1V1P35hDXXdFg8hXVGRQTjq0TS6Fo1xgKgvptgPxmg24VQChcUFDLn+1OyJOnHRlLyQKCSaXJCprrNvNxtuJI+MqmfEYBr/Pk6kBHpjnfQEFCyl6thi60VDAG5AZfqtyfOfCogxtjsxwRXrF7L0BIWs6JY53hiFkfbacuYIkk9aK0WB+BrN7SSx3RKxx3wsDbvu8Na2shOVtWBMRDPr5VtP7axA1q2CvY1dyeSCWYDSfuBeIHcHCfY+O3WYIxWQNjwSge+oYqZdFcTrMNfbohIwYtnSzgjO3z2Wee0fv/vHAOB4vEZubshWVxffG7nJemwx99/k3S68rv1CqokqjU77tCXdVW1q7G/ywO+BTcqvsPvyG2EogynCNdjACFukbhgYrjd1/i+7oQzMHj3wwO1G/tTS5Ha4zZG5iZqpPjZvZS3HY4W9yrWuDfpAMJVBFSJP5DzYJwY4aRtoCTC0CifqY4mxttjc4Z7D10n/QltykHTkRCSzVbfUGAkfA2WUzcPhKWl7zCOUChsjDOJz6uuIEAQag7cQDmpcjuiGrhPOvwI7Dnyf+1YGNvS6mw4Ne9mc1O83w53ElQ5P9QTT1fszVfnxfIHRqjZr2Om4MqXC4puUF0gY4WQ6dZY3o7g9Ys+23/FGykl30DE4aMa0otHdeIZbBbN9ohC4xSrkriWi8k6x5UEBvDrBJFxuZs4kvrgvNGh3uDpFpMf8/QyPgmHFmK9ndzNLGm0Z1xmCj+4oc/wyxhrxbQ7Xh4Qiv4fDlUI3lkzBxmPZ+Mb9I7PJhWkC5hNl/BRFMb1VUfyhag+WVzFygCfYO5aXRPEFssxafXaehvO5aTYOe+EoqyHo7b8LQ0XwhVCAZpx1yudzokhTdtBPwebQ+pxblkEALsD+yezYeNo4u3A9d30ZDATrnNUToxACKYgA3O/WQyuLTD3+BvqripKoNdwttHF5NmC+
 XGdby+/B
 UnG2fB1R1vJEiNO688jllNggyHHdcP/gzsdCKUvV7VmkKVgfoNZmKUymFKGQ4mwzZkP200vDzYzHgo6tO36BM9HHZ4v6WVNP5cEts8Qh86cBdj8NYwCv93FBU5Jhm3tnd7ianSaGsup6aOkimrgSX31RVjqNDlNT7d6qgjHFLFvEma+sLh4mbmbM4Z/d4G5Z++IyBOqaH/Qpc7C5b7fBzq26EG3kmkUSzqd7ljhGe2w51ls+eaVGwCREfI5S0ZPjEwVJkwx69wRZgCbi4SLHDH8oMEO5CrfxRPDSnyOMhnj9ZoHuDGgHEz6ffuuBNH86GtOUDVedkPJSU8evzZyrTY+LJ2ueXLVN0xUC4OGocIeZ5vLIyC1l2QoMU49BW9VbvFQLF1SgK83zhTcY4sXuUFyrheMirCIAfk+L4Rm0rfYGfupev0slYUDe3Nj6BD4rUDYgvmP+9ExpfZYRKvFG2N809MxZC2nG7S8bJ3MGTOpWiPiPW+z/BgM2CFc/WdAlDuoEs5uYxpxAIG01WlcWmXXwCYu/6KJFdtqXN2EKExemjxrE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:05:13PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] make_uffd_wp_huge_pte() modifies a present HugeTLB PTE
> without first using huge_ptep_modify_prot_start() to atomically clear
> it.

Confirmed and pre-existing -- the non-huge sibling make_uffd_wp_pte()
uses ptep_modify_prot_start() correctly. Will address in a separate
patch on top of this series.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=3

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

