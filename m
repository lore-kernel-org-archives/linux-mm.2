Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628C2CA9EDE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394B86B0088; Mon, 12 Oct 2026 23:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344B86B0098; Mon, 12 Oct 2026 23:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B5A6B009F; Mon, 12 Oct 2026 23:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2C756B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:25:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8037F1A0B17
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:25:36 +0000 (UTC)
X-FDA: 85316163072.29.7D9CE15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AEC9540002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:25:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NyRm1VrF;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJssChfaw/WlnaVysEqwe4Z1tfuZOFEKdXZG/EwVI3I=;
	b=wp+pUlliCYvMTrGRe9DwFgTDVfhVDPchVNuFhw6MyAYatpPKQTDntAEjrKweJHV95WmyWY
	B1YJNJyZtkYmNec6kVUD4vTivaYpXFU3735MTB0GK1Arp6GBeonJLSL9XWM8UzKOsLhI7i
	nYuR3aM8u/Ee8s2ccULSmcyT3kn87w8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791861934;
	b=W+0Fq7igGW2IzKrhpjR7kmvXBHCL84Q81yIjihFHxtBq1XTo50R5fDdukolPyjQrMIlw0j
	yGttA1wyYItQ2/SUj36/wmqL+FVtDsRkojRulfxfcWykIneERfd2xFLAAWE3Y979D3z/LN
	ScvBYeuOjY1XaNH6l1hNcd8Y3Ax3Do4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NyRm1VrF;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB138435B6;
	Tue, 13 Oct 2026 03:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167851F00893;
	Tue, 13 Oct 2026 03:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791861933;
	bh=pJssChfaw/WlnaVysEqwe4Z1tfuZOFEKdXZG/EwVI3I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NyRm1VrFt9ZFJC62cb/GZbpmwcM4V21aTV9sKGdVMrIs2z9WqCR99Zm3HyOqUlF7S
	 ENwjeRfGAaG1XErBHECIiyNgzJtP5yvlDy8GfISuPQkn8Wu67qs4UUCq0v+VtVgB5o
	 H0cAA5rwHjdJTzV8Yor6vR8GbpG7w74vqDpKdWrs=
Date: Mon, 12 Oct 2026 20:25:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Muchun Song
 <songmuchun@bytedance.com>, David Hildenbrand <david@kernel.org>, Oscar
 Salvador <osalvador@suse.de>, Dave Hansen <dave.hansen@intel.com>, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
Message-Id: <20261012202532.f059fd5ab947510a21d34cd1@linux-foundation.org>
In-Reply-To: <200A83B9-233C-44C7-B4AF-0900BA1E09DF@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
	<20261010112457.49485-2-songmuchun@bytedance.com>
	<asy-b7_C3SjnmSaS@gmail.com>
	<145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
	<20261012193114.77147e0a43affa8ee1ae896c@linux-foundation.org>
	<200A83B9-233C-44C7-B4AF-0900BA1E09DF@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AEC9540002
X-Stat-Signature: 9mmhzqa595mposgmdzwxhn4s4ufcx5xj
X-HE-Tag: 1791861934-689882
X-HE-Meta: U2FsdGVkX1+gmzpldsbZEoY+3764RNZMZS22TafkbSABrM6m47OmPwe2MYefn0xNEp9AX5b26aD0AtzSlpxQk+Au4ZRSsvnux41riiGIAE/hgZu5SFH3gCJezAsSqi8wPC7w04iRCNOy/8D3mrjs5UOeDgA7f7RNtQLg1Qhd3nLEYtR4KWZNsOpdHGCkjF5/MS2UA5JoR3BByQ5tkXwn2WpVpEioVAmRkCDUgq0k1mPSQNG+kVJ0FM/XWFXhSLlKtpYlzlbeLviREvQD9nVO4wwda/p0vmoFSjR12uldSFOQM38KODDzDvNbR2GvkaydN+2YZY7yIyO0cOcSoXvv5KWAUFh2ea2fa/LDjqy2uQsw36wl1hUHhOox1V7pk8W4yA3fSLrvfVrz0x+KX3TPehyIwKaQQqIXd7kDa/U86zN73rgTNTFwBwj6ODIcTp44QVGisJRdT3BG/sHq4cVkEhYP+fxYkKScyBzyrV6Ot9XvzKRhG5RbE2KnwDKeDEt8CnCQGrj94pwHrFpU1rcSriLWMH22s60Per3MQnQNhXx0XLH2rvHL8PSGK6P6Fmbs6um5OFCfbnFqUJzJLwx5dfsQEdFxJ6+TRqZ/DIdfZl/KclXRkuLbOF7loIzfy87yZrXToHDUkQlX7wYmn8EAoz0ma0nqH7jFYzswXJwYWQj3jB1VPY76CuQhO3nE+rEur4w22K0QlFrPfNjy4BT97IkmELG8wJJfGhQ5E/Lkho1ENSumvAynrJ1s8F+E4lK7oSeNhBHkZQ3zLBPD411Q6ccC7H1VFvvHtknXjzDPAhT8T6yV7esVTSwpHCGGkMKEsmPhBrOH+PUPIaPraWOYSqt4y4om8kBw3J4gXAj9OP0/GQMkLMFberYN3tlKW/gjzLNcvJp/12fDHWN/bIyRm5nhu8mzrIchl99uLNwhu9T5drRfE0aI/lwg/0QvKs85llqlnmNHLUL+a0mF7VX
 7Y2849ca
 /FN7wjh6G9P0MR8IJ+qqbtUlXkkcapPWdsTskiA0EIN1up7bDDGu4nLm/16eToMIZnKKhJ+QErj8wDEvqhL3BYLMmKiKNKbA/LevMB5w0sZf7OlE1Xj74Fx4WINjGBgP+hjf7teyKYCI3eV05WhFEBNbtokVP4PeUXsdK8gFYVhfHQ21UFZMaAHNSjVeI2kJNbE/LeRJMRa4LU+x62exJ50CilNU2JbEuzYjvjtAUF5jdZA4VvscYKpFtvVX9tfEmQYuRfwHdMs6R/fs0MHVCTIvTMpv7aKEwG752N6vgukSU5/g9rwtwGtHrQKt0qRrAyS5WlxExkipkbMAfPnpj4sBABOhVIcjzbzATs3TjtLI7WvTXol9T6dbSe3H+eim05iRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 10:50:21 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> >> The correct trailer is:
> >> 
> >> Cc: <stable@vger.kernel.org> # 6.16-6.18: bf9e4e30f353: x86/mm: use pagetable_free()
> >> 
> >> Andrew, would you be able to update the trailer in the patch when you
> >> pick it up? If there are further review comments that require code
> >> changes, I'll fix this trailer as part of the v3 respin. Thanks a lot!
> > 
> > I don't know if/how the -stable maintainers handle a comment like that.
> > I expect it's more reliable to do this via Fixes:.  Possible?
> > 
> 
> Thanks. I used this format because it is explicitly documented by the
> stable kernel rules.
> 
> The shell-style comment is the format documented in
> Documentation/process/stable-kernel-rules.rst for specifying additional
> patch prerequisites:
> 
>   Cc: <stable@vger.kernel.org> # 3.3.x: <commit>: <subject>
>   Cc: <stable@vger.kernel.org> # 3.3.x
> 
> See:
> 
>   https://docs.kernel.org/process/stable-kernel-rules.html#option-1

Oh.  Consider me educated.  Edited.

> A Fixes tag alone cannot express this dependency. It does not specify
> an additional commit that must be cherry-picked first. The documented
> Cc comment provides both the prerequisite and the required cherry-pick
> order.
> 
> Would this be sufficient for the stable team to pick up the prerequisite?

Hopefully.  I suggest you double-check when you get the emails as these
are applied to the various stable trees.

