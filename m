Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B5B0D31A29
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0CB56B0088; Wed, 14 Jan 2026 04:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE126B0089; Wed, 14 Jan 2026 04:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4816B008C; Wed, 14 Jan 2026 04:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6536B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:34:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A8881B850
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:34:30 +0000 (UTC)
X-FDA: 84330059100.02.27A2939
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9BC2A1C0007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:34:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCAcobZU;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768383268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiDCyIt20CzxUvCCc7yr/C6hAGxEwAzu+F3NvxFHJzk=;
	b=eCAWCob52Ihc0y7Y8gotyF1D+Sap2awRNFfuIto1R29nKoPth17WNfT0PZ+QITmoXcDFKe
	1qRtUMvrLJBLzodYKduVqyrIbT24dhTZ6jka+zp/qsa5dS3UnpIuDX60XMEY0NHWtUUeSC
	ej6+NADqpgFUU1+3cZnGVQ8xJFRnlwE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCAcobZU;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768383268; a=rsa-sha256;
	cv=none;
	b=eEh3j8CSUAJZ/6BY2Oj5DR47+StZuNY+7wjrlz2IDdz6OBEbxL/YzsxnQK+pnoGklBKHN+
	b66w2kmxawPIJVschaLmH5jJ/a2J52rq1vn4plE7+OtE7LwCKt03+mt+lRA3mkm+pNs6wk
	CLnjj4BDW95/sIE4qtoaSCplAcKLwfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA5FE60051;
	Wed, 14 Jan 2026 09:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6688DC16AAE;
	Wed, 14 Jan 2026 09:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768383267;
	bh=QCqYpWqKWHECS6LyWQkRM/br5oR6fqyVbwR9TGBPsQQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dCAcobZU3its6pMbxAKLPlKnf/wW0ogAAk03gUzk3dw8FRsPXZFpmmIy7+o9BGUqD
	 J+ceWtm4YMlCe/qaxRhCRyHBnnAOmA/7+Gl3a8m2JY+a7jlbNtc2RTGbZEB74eJTUM
	 vrGuVLxUsxv/M7iH+cN8YOBwrGC+QdMGu/P5PKHt2QpgIIMlY/lFfHwECZWtY5xdO4
	 lKXaDrfvePUhs9pDAT4K54pWT3LSyfER9DAAzq2k9hZaymAZODYzMq3VJCwcOltetO
	 A1nX0qkMR5rZ7cTmg/kDcKnkJmYZuHNfJLLzTPQ8Z2oqNbAGs7nmoNYu1+xLpTSnO2
	 Y74paLEWIYJFQ==
Message-ID: <b6c39059-faed-41a8-80b2-addaa229c143@kernel.org>
Date: Wed, 14 Jan 2026 10:34:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 00/12] Support page table check on PowerPC
To: Andrew Donnellan <ajd@linux.ibm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>,
 Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org,
 Nicholas Miehlbradt <nicholas@linux.ibm.com>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 Srish Srinivasan <ssrish@linux.ibm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
 <CA+CK2bBjoQmheEstv1MacGev_srdx=m5v=hwxdyfAKogbpG3FA@mail.gmail.com>
 <bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BC2A1C0007
X-Stat-Signature: b1mecfy5d1iyezfyiygeboppxbx7g5wp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768383268-227451
X-HE-Meta: U2FsdGVkX1+c9dMBuIb5Uh/btsZJo5pl7McmyGts1T9BZN3dqAol8SCt/DS29EJ3af0ZpgUVHnt+TfFgqecTFoT5aTRlNoN7h+hHd9mQKIm54JD4AdIKrhex7LYIc3BoWcC9vzRgqrdHPxSCn40xCrf1T9uRArTqxkmWoz/tMKLnnH9PjDL/kWcpecc78plOTZPaijLQtYNAKL3ELwkK2iptwh/D4zZYlra33arCibrQm7UmKcSv060EE/+SuJcQbwfjDr2TqU8VgaiLRa5DDACTnacJDjk49l8UR2lYvQww4crGQUwjRUPEvUhg+X2ELn+0DPWJBJPHJSryFmR4Y/bHWr7BKGjHURN/wtXhaMpa0Fm/Sk3UqFFC7+068J+xT4LlOcGLZ6ogQ+rRUGXYlHT4fpbskOhVMNLyU+BfNTchGx/HPqsknj2fQhdYQnSG4RilzGD0qdc0mCsG5YGeduYtSsyq1LBP9nBkvrIFvAyL3lCIt6GBwi3rGkThDc+G+meG/+WwpSo/ufu456rqHfcg0Er9u4XKaAMm7o+gUXv1bv4GMwfR7XTl5v1ZDwfQiX/QcB2rcv9SgrkFRVL2v7AvetSHEFzggphZHTElByCSV7Yq2bPDk2f6QGMNYYk2k+M0RtDboDnwO3azFs7FblkC3OkCu8SGUWgI09Xpx448RHAdYYtqmy+6F7qn5FM9eGrquXUpfPJChSFa+5oBbpUGi7lgvrz3X4k6k6bTE+v2K7OPqmlVkwJ/XvltorGJ0ZcKL5bSfu4+hAd3lZgHH19lG6Fx6wcn8a4kqx85ZMKsLjr1U0IHRgcfO7Al50yNRI4Qw9ezTb9KVcHK+5HfYpirV8smjic2wA9cZAswof9axpN30thVjq97G92FotT9/FIVt4y2pJC3BsJQ5XHG2lTDccqUWzO73PSFEIRE+1eBQde6Bwex+oqkOWvYb9Xj1DIrhAOAxcV06NhYYj1
 6XwW43Wm
 sYE83BC15VyMv2rYgbgYkiBo6V9ug5wLbc26rKfq9/rq+LoEmxqX5gDUTQKXWNsbvWcDR3b3zmxr2HjWZg91BHqz8YlOhpVx8tpUgoKQTDtStlol5eMYNfaWw4JkorYTAPtsPY/bxa40rGV1sFFw29W2GbF5TjqhrIRc+yB85PIVNx2c5FqUR4fCFwo8SWvsR56fdbM/qpdjc1AeYZNo8FFxrfCplpnYn8iLXfIWsZLdYsUfPXb+BF8wrjbmxiKqWauUqa6xE+5mnrbDeV6ybZf2Ovgo1COOSMMIEmcSpnQ/GRtLLBJk9Ssh0Og9suJjPaTYU7NOTYLY02OP2RqeFt2whoohaMUcvbOtGqb4c2FyU/vu6/oouCn1oLqBOhSniB4ox3vgBn/k1ak6bAmVQ051dMvmUHjNS+7oc337sMU5FRCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 14/01/2026 à 06:00, Andrew Donnellan a écrit :
> On Thu, 2025-12-18 at 12:55 -0500, Pasha Tatashin wrote:
>> Thank you. This series looks good to me.
> 
> Thanks for the review!
> 
> Maddy, Christophe: any further comments from the PPC side?

No further comments from my side.

> 
> Do we think we can get this in in the current cycle? My last day at IBM is this
> Friday, if a further respin is needed then Srish will need to handle it as I
> don't have any access to powerpc hardware outside of work (happy to provide what
> help I can from the outside though).
> 

What is the merge plan ? I see all powerpc commits are acked by Maddy, 
will the series be merged by Andrew into the mm tree ?

By the way it doesn't apply on top of powerpc/merge branch:

$ b4 shazam bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com
Grabbing thread from 
lore.kernel.org/all/bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com/t.mbox.gz
Checking for newer revisions
Grabbing search results from lore.kernel.org
Analyzing 17 messages in the thread
Looking for additional code-review trailers on lore.kernel.org
Analyzing 86 code-review messages
Checking attestation on all messages, may take a moment...
---
   ✓ [PATCH v18 1/12] arm64/mm: Add addr parameter to __set_ptes_anysz()
     + Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> (✗ 
DKIM/soleen.com)
   ✓ [PATCH v18 2/12] arm64/mm: Add addr parameter to 
__ptep_get_and_clear_anysz()
     + Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> (✗ 
DKIM/soleen.com)
   ✓ [PATCH v18 3/12] mm/page_table_check: Reinstate address parameter 
in [__]page_table_check_pud[s]_set()
   ✓ [PATCH v18 4/12] mm/page_table_check: Reinstate address parameter 
in [__]page_table_check_pmd[s]_set()
   ✓ [PATCH v18 5/12] mm/page_table_check: Provide addr parameter to 
page_table_check_ptes_set()
   ✓ [PATCH v18 6/12] mm/page_table_check: Reinstate address parameter 
in [__]page_table_check_pud_clear()
   ✓ [PATCH v18 7/12] mm/page_table_check: Reinstate address parameter 
in [__]page_table_check_pmd_clear()
   ✓ [PATCH v18 8/12] mm/page_table_check: Reinstate address parameter 
in [__]page_table_check_pte_clear()
   ✓ [PATCH v18 9/12] mm: Provide address parameter to 
p{te,md,ud}_user_accessible_page()
   ✓ [PATCH v18 10/12] powerpc/mm: Implement *_user_accessible_page() 
for ptes
   ✓ [PATCH v18 11/12] powerpc/mm: Use set_pte_at_unchecked() for 
internal usages
   ✓ [PATCH v18 12/12] powerpc/mm: Support page table check
   ---
   ✓ Signed: DKIM/ibm.com (From: ajd@linux.ibm.com)
---
Total patches: 12
---
  Base: base-commit c224625ec6f8a0476ffffc09807f4d717ba9cc93 not known, 
ignoring
Application de  arm64/mm: Add addr parameter to __set_ptes_anysz()
Application de  arm64/mm: Add addr parameter to __ptep_get_and_clear_anysz()
Application de  mm/page_table_check: Reinstate address parameter in 
[__]page_table_check_pud[s]_set()
Application de  mm/page_table_check: Reinstate address parameter in 
[__]page_table_check_pmd[s]_set()
Application de  mm/page_table_check: Provide addr parameter to 
page_table_check_ptes_set()
Application de  mm/page_table_check: Reinstate address parameter in 
[__]page_table_check_pud_clear()
Application de  mm/page_table_check: Reinstate address parameter in 
[__]page_table_check_pmd_clear()
l'application de la rustine a échoué à 0007 mm/page_table_check: 
Reinstate address parameter in [__]page_table_check_pmd_clear()
erreur : l'application de la rustine a échoué : 
arch/riscv/include/asm/pgtable.h:999
erreur : arch/riscv/include/asm/pgtable.h : la rustine ne s'applique pas
astuce : Utilisez 'git am --show-current-patch=diff' pour visualiser la 
rustine en échec
astuce : Quand vous avez résolu ce problème, lancez "git am --continue".
astuce : Si vous préférez plutôt sauter cette rustine, lancez "git am 
--skip".
astuce : Pour restaurer la branche originale et arrêter d'appliquer des 
rustines, lancez "git am --abort".
astuce : Disable this message with "git config set advice.mergeConflict 
false"

Christophe

