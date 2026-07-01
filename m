Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B928C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243AB6B00A6; Wed,  1 Jul 2026 03:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5B26B00A8; Wed,  1 Jul 2026 03:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3D06B00A9; Wed,  1 Jul 2026 03:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE7866B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:48:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D51DA0272
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:48:43 +0000 (UTC)
X-FDA: 84939430926.03.E08A826
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7EDB9100007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:48:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Nftf9ryp;
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892121;
	b=WES60/D0xElqkxgokE7ANdi7gJXLWG3Dqz17Vy9uh90GvzlkX7eqT3Qbs6rn2cVipjU//Q
	B6s7UYLcq0Mq+EFvLZUdDpn/p3F7VCylfKhcTNQ4R8oIRu2MNC7+f1Rg9LfYJ04L8RZe05
	VTacUSBKf9ryjqgofDmDS062C9eDr7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFqD1yFrJpRU/qiUB0Dl/TygipY0PABdXOWIH6V4FzI=;
	b=VyNO0N2RqYNQ83zRIfSuvpnPrTP9Bm/W+R7gBzKYzqF0h7Bby2Rp8vXY805ohPBX6meAQB
	fuN81J9q9WqlTPvRXr1CTFavNes27pIA2jaPsPUONdd/mEpmZ0Qe8jCtbNS7ujYIOaLeEy
	DSPFMCuWtQpP/BuhykJF1DjaDtPVYY4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Nftf9ryp;
	spf=pass (imf14.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fFqD1yFrJpRU/qiUB0Dl/TygipY0PABdXOWIH6V4FzI=; b=Nftf9rypiRDLiFj26fic/t2RLo
	7mI8iXJIbf6HKEdECtW6gsKZ/5rVZ3m0tJFpeFsRBbLL/MOhXqt/SxeiyGixqnjMQ5pE+M+iJEwFh
	Q/wLcZpN1MdXNrRE5rV07JLScCAMDtVuSMYlTfLILP6qfjcL/P1JILbUXZ8FVsXrhvXpgDun6VQyP
	wKySgBEzT3JeBqvIj+m0vnKwMA5RMWVbCVvhTIi4wVvSqGpvVpUAY3XAJnqVwIhssb6MnZt8xodEn
	65CuXwpXrIqIc+D0WJtvBT4ylp40Q8L45IMpP9kwGdEAUum0STvOBycwfAj2IqsH/UYhWffoMbaGD
	cKkQ+chQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wepgR-00000006FQY-0uqR;
	Wed, 01 Jul 2026 07:48:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DFE0330035C; Wed, 01 Jul 2026 09:48:34 +0200 (CEST)
Date: Wed, 1 Jul 2026 09:48:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Xiang Mei <xmei5@asu.edu>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-hardening@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <20260701074834.GI49529@noisy.programming.kicks-ass.net>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <20260701072747.GN48970@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701072747.GN48970@noisy.programming.kicks-ass.net>
X-Stat-Signature: 88cq4c8unftp6k9z3bb1se975zbo4ojy
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EDB9100007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782892121-133473
X-HE-Meta: U2FsdGVkX1+22roP68I/qtll8nmzYSCfkEb52RKhjcEcTT/7Rwp80V9z1ofRQtIojblzv2moT2jiQGPUGMnNAYsjzdz4TXIQnNucB6DJf+zehCjueAjxcXQeYeW24vkS1V2wADYflqmnHXE9OJCLN6w0DXj45c2me3B09UUbhng5PryH8clxDcEhXbOFpf8DK7125olRLWGOeJnxINk7SD8sIOthcTVvCMRE8KlIhy1pDbfOwy/6ujDek/SZSBtXnY48GHM3vVssw3mfoD3zMDdf0HPUhQCuTAjaRXz7/C4DolhJfu9WWWf+MPxQaEozZ+Z+besINOm99wzMGLMfj6l7YkE9kgF0ABId69RGsKTxOBGLxDpMH5XhzBr68BF4oVf1bXBoEdNb1cVtvSh1OfndmqwiRItTEj84axvPpT8is/FYZ4cAYOe3nnbC8GMFefX9a4aWPjsdbQvqtR2oDuhsBk3uoxcM88q4jfaay57YpVWTn0PFbgn2gWzfoFGRLGcOo2u56+Nv7tKEstAPjHL4rZLl8An7tPhpHp8oxplIxB8EhbBPqcBNSuGSePaTKfbD7Sk5auXhMh2E0nptfkuDojmg0FdPy80JkeRvBCjhuT2q2oUlMymEq0OGbMekMt5L5DxdCCe1dXg3Pqd5vGfIUM9OIo/vX2jGF1Bj9FLXo7NeoRpjy6p4aEM/vPUD+HsFjFjRAJYT1kEatVhsEP7JhwNrvgashHBVd+OGMWK6WDj0lEv0492uM5C2zT/aR/LIAmjtLf3FDzVGGvdqLwJFpm5lUFoMXOVS/auYJqU24iVkD+NKwNR6BcKdH0ty4jR7Ex190TiAciddJAQUSAjLUD1kivxDyqRsdOF8MZF/9xHBYikpHGPUphTU+xCf3QWon3KPW5G+TIZXIQaN6yHLYxt7UfKjAPqzJpy5GOaIcq2vcfbwYTLned8eZyddDy6Q9pod42XUSJUbvt1
 kpevCB83
 H8/jHDKe1nBPIz6qYlqhE6V90nOSfaUgZnJQbYesDX0edDIgNr8frq3hrrpfxU6lndv61vV1VMjlBsJoU0htXT9fKdbTipgHPAOYKxfRCs2L7s9LmpiBA6pIVFAtIrth3Ashi73Z8u2r6wLP3nPyjGqiHQxshJN0xXEzhxTnisc1DM1lmtUz/bquwTqhDQX6UFP9RHD6EysvCx1Mzl8ZXoKX/ro2QfrVWXWEDKSKfSzS9gNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 09:27:47AM +0200, Peter Zijlstra wrote:
> On Mon, Jun 29, 2026 at 03:29:50PM -0700, Dave Hansen wrote:
> 
> > But, really, if ENTER is so evil and nobody uses it, shouldn't we just
> > have an MSR bit somewhere to tell the CPU to #UD for it rather than
> > playing these stack games?
> 
> For supervisor mode only, I suppose. We can't ever get rid of userspace
> ENTER because legacy I suppose. But we can make sure the kernel is
> clean.
> 
> So yeah, having a knob to make supervisor-ENTER trap would be useful I
> suppose.

x86_64-defconfig builds clean with the below :-)


diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 1b387d5a195b..9e53db863203 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -642,6 +642,10 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 
 		break;
 
+	case 0xc8:
+		WARN("ENTER instruction at %s:%lx", sec->name, offset);
+		break;
+
 	case 0xc9:
 		/*
 		 * leave

