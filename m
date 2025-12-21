Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C536E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 18:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B246B0005; Sun, 21 Dec 2025 13:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012B56B0089; Sun, 21 Dec 2025 13:49:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53E76B008A; Sun, 21 Dec 2025 13:49:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D42CE6B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 13:49:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94D9E8BA04
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:49:11 +0000 (UTC)
X-FDA: 84244365702.02.9731A95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DFC1D40002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:49:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nJr+00XR;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766342949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ka0RVuUzcoyLTnWLXL6FupyMPRC2ai/Qs3l4AmXzsY0=;
	b=ZuTRukKlJIY0OKCFgYg182dDiTEr43TJt3WVcybgp0BQ4E7Qms78N/kIAxGILihiVw9+2T
	a/QJVZRzRZrfiUwLniwJPMEWV3N1eb9pHmox93fYwsx3MYQF44Yhm9DM48cPoEY8UMX8Lw
	Vti7Qn/+qRQypCc7q7NFcvy+15D8V6c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nJr+00XR;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766342949; a=rsa-sha256;
	cv=none;
	b=wsOJCpmEzGgMzXe9sGTwrD8OImzdA5hbZtoBov6KPk7gCaf+V/P9XmOQhBZPuJh6L1G7TE
	5Pc3kcdRZcDsE2nT/T0AsKKXIFS2/dO2lBes8oY1tLLX2P/yrYcqOg0oaFT48IUe90Kb6H
	EvYLUDcg6sf1FRTMPKxY8obWW5dpHhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0B7F6001D;
	Sun, 21 Dec 2025 18:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87ECC4CEFB;
	Sun, 21 Dec 2025 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766342948;
	bh=IJXA+QzQQpGmzrjmRsOKwVn2upf0r1hQr276K/HQbNg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nJr+00XRdPtzlvH9JOjETY8okc5IoS3PxdQmW9oo668Rvqkalq9mXrLUjB0AbsyW/
	 eIKKrW8sm5ef9jKskfyVXa7x3lRrVXMySdJZN2ki5xU01eOomWskWSJRcFhhR668sx
	 3LiGEKDsBGq2NxgVr0zHtc+LHnCm1WTs0bAiuqPg=
Date: Sun, 21 Dec 2025 10:49:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Sourabh Jain
 <sourabhjain@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, Christophe
 Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>,
 Ingo Molnar <mingo@redhat.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
Message-Id: <20251221104907.032abf56c67f3e50c9c94e31@linux-foundation.org>
In-Reply-To: <655cc605-2ce1-4ccb-8cc0-a0a31a9c89fd@kernel.org>
References: <20251221053611.441251-1-sourabhjain@linux.ibm.com>
	<87a4zcml36.ritesh.list@gmail.com>
	<655cc605-2ce1-4ccb-8cc0-a0a31a9c89fd@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ypbzm4daofdab4b6zhp8ofq99jm7t8sg
X-Rspam-User: 
X-Rspamd-Queue-Id: DFC1D40002
X-HE-Tag: 1766342949-200283
X-HE-Meta: U2FsdGVkX1+gkV8Zx0ctlPumBro+rBI5GLvf0MvxicBFYKFlBX9cQpLiN+F9VkQgaCVs3zqcSg8bAc6mFUOQC8LIZOMUbtwyZTqa5qa761JAx67Guzth8rQiGrUWrlLyLy1ERlBB5P737OGALFWUkO/BzLkBN9WoZ2iNVGh3zv0wMjXZNfHii61T3FvtwgcOECtsMp9H23YntXLn0ebrgx6OOWFbInfi6OEnouQvzMa+H658scA/Ms+e4CF4fPZ55Uozn/f9nrREptnSCiRMXmu/3yluUYtDcbdnjjGK75KmlTQWGMfmXwaxStBGJT+ZjLDwJr+D3kwMofGItb2Z+16DlGmP+bFdUWUQAnt98MVokZRCAQilLxAIILCLZCLK2RHeW/t2s2RRpscr0QO1xN8JJzzY8/jxea36k9cry+aDVVh7EgdMt5cpkb7usu3nnJRoEQQIKlSPdh0j8yLL1NC/DivjP/JHIuobyISABDPFSj775vhPGfDyqj1CElf4ypjkAGpBm11lm8sp21T8bEAlhuhr1GC4c1iL2WWrYWEr/s8+ypxqOFRhk91WDG7bE/dxHyVcJWEh1B5bkWzPODrW9Ep8abU65zTfeYMzpTs+88VuaBP6ZI3qCkUiSJP+zWRAGcnXp995TBin7DQm1E/QR2WysKbFTdcE7HVXll64V2Q72fY4CjE4dYKe/XOH5I0Q2gZfx4YicAIQvKmcvsnxSgvMwnsEHWtNml1RxCSh32Plhp3yWiOS9li+F2//ctp1cnl1Dw7/hG8OH2HONHokX5sCNaYZabilS+IBh/MYIiWoI9vp0at2a4ZcZqLM8ufI7vkgcRAUws27K/aZAfCP5UnEWt17gJnw5HjKcdtzrHKmriLNtr6CRJbeRAofnmg4q7/dJk0W9Nlq+yS1U3A/FUvObGPge3QTi/x5RzZhi4Q8hX7gCGNFR6Hz/++KUyWAQMsfjEtYTd66Tg+
 1o3Jt2Ti
 nTifHDX25XTcyTsXolC0fqgM2CjHHSBFcCm0SQg9ukyqSzmmEbxuV8GzYeQX55ue+Y4RVg055lFgbTOLjfQQpvUx514rvPxVtogcUShQWqKQ1I8sOy80qm1DCqQGMAR/PMNTk9OHsE0e+OOOmAXiR56b15xsDJrBkNRFMZafqinmkx8J+Pw4+Clg+2LPn7u/qirkXULHplgqCJBeFWCwIxVsSeL9P/t4cEgW1LlLEMRkYlSX9zETqnlIVLpII7Iv4qN34Ipyj3YkGZkXwOHwKtB75aqsvNdh0nuS+p3I0bAawCmGt4+AMEDiyl3C0zMSG5RFgi81x2jpiRrKlhf1NGwZeVu2DCUtViSlQ/5VnAagSUT72aCmwVrD2T2XeBXlwiBe6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 10:22:44 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> > 
> > My main concern was -
> > A fixes tag means it might get auto backported to stable kernels too,
> 
> Not in the MM world -- IIRC. I think there is the agreement, that we 
> decide what should go into stable and what not.
> 
> Andrew can correct me if my memory is wrong.

Yes, -stable maintainers have been asked to only backport patches where
the MM developers asked for that, with cc:stable.  There may be
slipups, but as far as I know this is working.

I don't actually know how they determine which patches need this
special treatment.  Pathname?  Signed-off-by:akpm?

> But we can always jump in and say that something should not go to stable 
> trees.

Yes, please jump in if there are any thoughts about
ordering/priority/timing.  In fact, please jump in if there are any
thoughts at all ;)


