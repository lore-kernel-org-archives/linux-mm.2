Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8036FC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890936B00A4; Mon,  7 Sep 2026 06:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867D76B00A5; Mon,  7 Sep 2026 06:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F4A6B00A6; Mon,  7 Sep 2026 06:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB786B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:54:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1B431A0113
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:54:35 +0000 (UTC)
X-FDA: 85186657710.20.DC1BDE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33D7F180006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:54:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHbFXHXN;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778474;
	b=ZrqkBgJPL2w+zh/YDe7kApLhe/gRY4MDreZoJSmADpNlfrd+zdVDfGjvjzc9SCK9QRX/WV
	Se8Kj2OBAmSLJlMtOAkmtSxhBcdE+5D3DsZWLILh02UWcGJ6QqafErC+p+t/tN1676mkFm
	mFCnbOVfIvwZ4f8c9jUkGukng1Xtc7E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHbFXHXN;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3C3uRSlXJAvrU8CA+JkknXP4ShUi36cTXYIJp4O8Nc=;
	b=Y1saxoWGIXvXFsXliLk+Jnr1MxbqOLKmjyDAF7gJt+rALQaHRTCB1j2kszMD+exDlr/u+X
	AYSRz67gEd1R780GiBD1sygvOxpKyJdkrw62oM+YDmwkJOgi3jiOlQqKptZcfTT7c9byUa
	B2YhCUYccXa8kAo4CSBvd+iSvc1DkRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8628541476;
	Mon,  7 Sep 2026 10:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B031F00A3A;
	Mon,  7 Sep 2026 10:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788778473;
	bh=V3C3uRSlXJAvrU8CA+JkknXP4ShUi36cTXYIJp4O8Nc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZHbFXHXNQiOKEVicWGF68AIi3xG2x4I+cHsg8VqPlCzvv+nZFOAz8sbazJ8oBLnFB
	 ML9MVBegMDsk51RXbXu3JMCcuJZb/ohTBVMqsW0habWrf9MSzwxJjEk/IISSR3SM5+
	 wERS3KXe9I+Qam1+E7DPID9Er5aiyYuvlBxrpSI+Zcn1xmDosCkHdzrLvOXN6De63G
	 qPtKHZuyqCKKa8ls2pYhHzjwY+lSjpLLKfwushmouce8WscmOiCFbQECE/0utjH1dc
	 kk45mPSMKCcteX8yeA4ZmqvmVj241Gezp5GV3cX2trb7b17udLgCy++itmSvBAvbLI
	 BI9MJeJODNKhw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC v9 11/25] mm: kpkeys: Introduce
 kpkeys_hardened_pgtables feature
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
In-Reply-To: <20260818-kpkeys-v9-11-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-11-743ad31b2c8f@arm.com>
Date: Mon, 07 Sep 2026 13:54:14 +0300
Message-Id: <178877845406.3691569.11239630051799000768.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: gecssyrxhq63jrsopd68wnbdzaxr5naz
X-Rspamd-Queue-Id: 33D7F180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788778474-525350
X-HE-Meta: U2FsdGVkX18TUacPwWVv446eDTxrzX/sL8/rB8mSrn0tUanFPYyppZFr1ncZTi2aZyRCZSK6sfpRjiBh8mMKjYIX/fJjCKFyZPjCcYaiLMlom/mHN7CEOGLzpagKR/trNGSls8jOc8fzh2HScrHfP4IOHbpCe5/ToDl+/GXSCo2mtXlVeSRNQSPuaefh21u2yPkZNPr+A7Q5HUv0IgP7FpneBX5WSWfFo/3bu7vjrd4HOck2Tcyl0e3xRGw4BwnBzgjNnWucyQKw6zDu1t+8cvs2+NETYknZRdcEajhtMLmRTi8YGrIreTq+P4AlmJMfKuONf2tWfUDZbfxaQIAiof9P80IfiDIPjNJpoPdiwcOOrwVbtWXaB0DwnVn7+Z/0yAIcmByFLkS9lBzS19fWzQKZvZT9YBNakDBNI/ousti8AnBiJkL/V8yA9fD/lbFbJKRtyD/RLUutQUEKlgPC3QY3+nEDfK6vtE/rN+grmVPl6TsC09ZD+E0ft66hlpPqGWX+EQBUh6jAa47ksPce5GKlp7MnXRIux+gB6w3UY+VM/U+yj7kT76TByqjau28zAYHheA3zrlM82GV0cPXbDdzStO9pR/slH9FfN0tAiI4hKHRjcl1i6tm79eYqZIjb0i7xh72ymE2BqyuA+FiZiaxlSN7gMYaNMz4fias6gPZiNsGvqjsIMc6Q6BrmzuNkAt9xHRx+30/+MYr8Swb+IVufPo79MHKuvdEATQfvYQKRymP/9DpikwfvWz6Zqr1l8dYTrp0daFCT5819E2+0k4NB8FmTeomcQFOV0l6Ni/gq/ZcsNCTiNJAB3MnQETkWO4Sd6ykQ0R1ME4+YrC1x5ZxljWGWiKN0HoKFpyRvAaKRAmIO5cr4hQ1u/eiH+7um3tyL9hTNEQ7vL/74e5BzOHQfCPGrn2xYrbl8hus/j0tCLCJHYYABXG4KnSQZMQ1tWUUAt8ikDHnzUR3s1kX
 ePOlrmgQ
 PBNMXbyJO9MXnkw4kyAP2tOs7Q3fGBLIRB7sxq+XfpMTGih9uBoorXeL7Q+cVi9fQIbJYqDKYwhfKxigLLMTc7L1o8ynoUg7RH3A/wDkVg4vnU0f4wfB6GFr1unuZ64EG9ihrts/Y62vtqDxqn/qgpnOCKCD17TaVvxRoS3Clj+HGU/Yplknay2xPdiBUugwdlD7FNkXZfNM0GY92s/kqPRZKOWRMb2DUVFYckBodwiMuR+U3YPrThCt1nQUFqfNw5NkLvtQyW32MUR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

> kpkeys_hardened_pgtables is a hardening feature based on kpkeys. It
> aims to prevent the corruption of page tables by: 1. mapping all
> page table pages, both kernel and user, with a privileged pkey
> (KPKEYS_PKEY_PGTABLES), and 2. granting write access to that pkey
> only when running at in a privileged kpkeys context
> (KPKEYS_CTX_PGTABLES). This patch introduces basic infrastructure;
> the implementation of both aspects will follow.
> 
> The feature is exposed as CONFIG_KPKEYS_HARDENED_PGTABLES; it
> requires explicit architecture opt-in by selecting
> ARCH_HAS_KPKEYS_HARDENED_PGTABLES, since much of the page table
> handling is arch-specific.
> 
> Because this feature relies on kpkeys being supported and modifies
> attributes of the linear map, it must be inactive on boot.
> kpkeys_hardened_pgtables_init() enables it by toggling a static key;
> this function must be called by supported architectures in
> mem_init(), before any call to pagetable_alloc() is made.

Presuming other architecures will use kpkeys framework it's better to
call kpkeys_hardened_pgtables_init() from mm_core_init() rather than
stick into each arch's mem_init().

-- 
Sincerely yours,
Mike.


