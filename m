Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F14C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716346B00AC; Wed,  1 Jul 2026 04:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6106B00AD; Wed,  1 Jul 2026 04:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC466B00AE; Wed,  1 Jul 2026 04:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 381806B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:31:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2460A0290
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:31:15 +0000 (UTC)
X-FDA: 84939538110.13.5C82D16
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98250120005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:31:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JHAM2Cel;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894674;
	b=4G/+S8z+ZQc0V/dcRkfbTlez9GrdHG6uJAeAnSW0eDkUpq7UrxnPAJXB+0VzjyFzW94Fbp
	gbglA7kNKEeotjLOCALc3TFO0uBCQ87jnpv96LCzLwE5g3lPuXQmyJKvLi7lnnsjI4XA9S
	AJZVQvhxTVzGwbtUGfH0Zx8O2nKSbyw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RSAu5b3wdv4pEaqgx2siyAq2Ny91YmHLZ3XWjOa1s7E=;
	b=292ppf2JrFekB3/NcGRnO9KKjLLZMotcIi75e++1puHJEhBizIlICJ8yPgv/MYugFWNNwU
	fj+u6jKXogRUZxyoTR8+31PFTjMN/Z7pTm8HDjqvaQqiBFe7N+W70E3ivqQcVarNXx3KnI
	2fYUAyqMYuFz5Y8uCl877iycDucGBPM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JHAM2Cel;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RSAu5b3wdv4pEaqgx2siyAq2Ny91YmHLZ3XWjOa1s7E=; b=JHAM2CelxbHmDB56NFjTzk4T+W
	DEpFJEGBLrSt4TUVDIHWmJKMS8DMgLVJphE/eJrHrOBfNbjIbYWC3Ekb0XmyboMFfaW39avBBkrg1
	xeVda5iUxiSiYgzJkFlFr+G4vQDCj75TcM6xJLj2DUOouYPFFAPHux0uW4fIcdVHtA+PnofOc+BZq
	I/WOrhosWFgSo/P4ClObHxWkPw4fSvgyJcot2V8G28jShQT+3+TvxDxlWj3B+d5rmWkMzopnx+R7q
	FzM2WbuMPkPSQMYFRCqMivX+Nx5JTFhr9fKFrw55ClO4QlDhXd63PB28E4PEqK3J6ByUxKdYf+/eY
	eOw2CsEA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1weqLd-00000002VjW-3Dqd;
	Wed, 01 Jul 2026 08:31:10 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7C23F30035C; Wed, 01 Jul 2026 10:31:08 +0200 (CEST)
Date: Wed, 1 Jul 2026 10:31:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Xiang Mei <xmei5@asu.edu>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-hardening@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <20260701083108.GD751831@noisy.programming.kicks-ass.net>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <20260701072747.GN48970@noisy.programming.kicks-ass.net>
 <20260701074834.GI49529@noisy.programming.kicks-ass.net>
 <8730D74D-6395-4FF4-B9F9-06AFABBF8CDE@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8730D74D-6395-4FF4-B9F9-06AFABBF8CDE@zytor.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 98250120005
X-Rspam-User: 
X-Stat-Signature: baur9y7j1o9j39gqcrpbq6117s4x8ipe
X-HE-Tag: 1782894673-876535
X-HE-Meta: U2FsdGVkX18usFGPPUB2N/Vk47uik/DKRWYbohjykNbIzDAl9pTQZt2Xp8VhANKNg0V6bVVcTpxnzTLETgWED42ozXJB6oOmk973MpsQXXj2oOP/VpJWTvM83EddGmqe2xdJBfi2U4RICK+tg0giHdDiH/J83auTsKJECOf+Rj45b52/XxRt+yGrC1aGDvUdv8YrdOpqsB8f9qoPWmv4WYN6Dh8UDiCz02tORwUlEoQvPfG0M6DjuuiRkzo+3Ha/Vm5sNU+cLUO4hG4Ktgq33GDdpEOEUtMctrvqqMTCwax0fANurQh87BskVWkO5+qMyBNM81PwnbSZtyeAn/QYtKiA27E+A980H5sDU7ta+FjahEfU/UgEh5ADCdAAaSRwUesb9KsQZDIva0LiyCIuks+eaDbQ5C2ucsETxtDW6N4pYyE6pQqLFAtFLja6PP6mHD/eOSxw+HKUbbp/HpuE9upEd4zgMqz/yohtBBtuVvY1ZEdjL3YZACWzyTMcA36AxFFtJ5hRDcwOIjojBg94ai/b8sjy8n7f0PgMkWbDPk6uWdMNNXBHsNyB5+M6K5rfJKcgCcZTf5UFeuwzIH38pt27x1pYyYR35x3lXYhSIu2iKvo59kN72sDT4okdwGJBKhafO/Q5XYdSIE171x+izsAjsATnfEhZi1GUOwZMqOpTy/8+0PEiuR8JHlZILZVjD0Fk6nwu6s+qz+vio0eYv6Vj0FwK4t7G5aeil/iFede1htcDZNBcVsc7CiOBsD3+QAZTu/xxRrgLEImnynwdqoanx8dCWy76wEz8ODaTTqxbAqdhqVBif8k7VMLOLwaWYphJ3MzJL9K8coH4yuytmxwXQFr95xXqYEBiHxn5vBWFZO96CKX6F8XHOoeD2JySNkk5l0CmWAy6D9ixKmkOMFgTpTJIcn6BUaeJre6bkbC+CklZwohfvmj2f9a65U6a/wfNTwlhjuNfx3IhPcW
 3E8wx5JX
 fYESWW54HXd2hPTwVEZAcQ0r4o1TLBIG4lnTsKpfdCJwd7S0M/jZlOhf5I4Ese2LuNbZgvcPak5tvYDm37Oc/6kRH1G43UBs5sLz0KIsbAkiNWZLGT8hlIyvzU9LZMPFOE2T1U7ORGLlU0LxoS8Z8QrTDrZAFTAAGsIfHyHXuYkHbC62Kww0Fa2kdvSHiIUe5VKOzOTg93qcovkXfh00ltZNnOvMn176ij167L9b6R6CwviOCTwLH5KnFLtT+luwhIt15XLADxA6MZLgCe7Vbf3XjuksDwDflBfrD6ohPDF0beno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 12:58:12AM -0700, H. Peter Anvin wrote:
> On July 1, 2026 12:48:34 AM PDT, Peter Zijlstra <peterz@infradead.org> wrote:
> >On Wed, Jul 01, 2026 at 09:27:47AM +0200, Peter Zijlstra wrote:
> >> On Mon, Jun 29, 2026 at 03:29:50PM -0700, Dave Hansen wrote:
> >> 
> >> > But, really, if ENTER is so evil and nobody uses it, shouldn't we just
> >> > have an MSR bit somewhere to tell the CPU to #UD for it rather than
> >> > playing these stack games?
> >> 
> >> For supervisor mode only, I suppose. We can't ever get rid of userspace
> >> ENTER because legacy I suppose. But we can make sure the kernel is
> >> clean.
> >> 
> >> So yeah, having a knob to make supervisor-ENTER trap would be useful I
> >> suppose.
> >
> >x86_64-defconfig builds clean with the below :-)
> >
> >
> >diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
> >index 1b387d5a195b..9e53db863203 100644
> >--- a/tools/objtool/arch/x86/decode.c
> >+++ b/tools/objtool/arch/x86/decode.c
> >@@ -642,6 +642,10 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
> > 
> > 		break;
> > 
> >+	case 0xc8:
> >+		WARN("ENTER instruction at %s:%lx", sec->name, offset);
> >+		break;
> >+
> > 	case 0xc9:
> > 		/*
> > 		 * leave
> 
> The problem is that it being a single byte long it can appear in the middle of another instruction. 

I understand; this was in response to Dave's suggestion to make
(supervisor) ENTER #UD, in which case we'd have to ensure no legit
ENTERs exist.

