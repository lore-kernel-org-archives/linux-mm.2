Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A744C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120A76B007B; Wed,  5 Aug 2026 10:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1E86B0098; Wed,  5 Aug 2026 10:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A266B0099; Wed,  5 Aug 2026 10:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF53C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:48:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49EDD1404ED
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:48:26 +0000 (UTC)
X-FDA: 85067496612.17.AE0F91A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 438761A000F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:48:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j5AFHTTL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785941304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRTmOAk6cTcHgi88kwVfB7nsud2FRmsRmiePcO6JUf0=;
	b=zxkz+weIYHq/ZxkZ+AIphlgfyDfBrObhLiZM6OrqLLT1G7177f8Q84nuxNWebcXRyxv7bC
	MN3XLQMwZXOIkgIlAh4Hy+6vDIarU4/34BP7CidNJ8j3ssdznYFLUV5oBMahB70tX0SsM8
	xSgG0A5XrNl0ALOBSm90KN+zuPUlwvw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j5AFHTTL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785941304;
	b=CHCYl+7E5fAUW9zwuv3/fIauanJJ9gdxhCGAyHLbRfy4XRxmzeJ7higI9Xv8gPeapCx3Df
	4GkBir9bKZslr1/Mk6tWJd7P0KVvIFAf8VOrIn9/M2XCVBhZ0X5odgsjZdtK6A1Ar8JcE5
	eMEwh6bVbfl8NscE3k0Xutlmg1CnX3o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3589B153B;
	Wed,  5 Aug 2026 07:48:19 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F34F3F632;
	Wed,  5 Aug 2026 07:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785941303; bh=TNWZy6YCwk1Jg/670Yw8+8Dm+5ppwdOabUkzC+QBhQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j5AFHTTLzxiQjtqEvFZsht+b9/H6BjM/x3RwHls947twbgJc0VGaenS9OuNnNIJOT
	 mEjbZ+iR1nCYefAMDmIk62GyEXF0p+Wocz/2eB8/qm06XSy16S6U1PRVbyU662kBAt
	 jLhd7uZexScAhraTfyFOENpLJ/diDU8f6Yc/ZhcY=
Date: Wed, 5 Aug 2026 15:48:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org,
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anNNLv3pHQwfcZOu@J2N7QTR9R3>
References: <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer>
 <69f4cd9c-bd6c-4e5d-b8d1-a7be8408a57a@os.amperecomputing.com>
 <94c7988a-3ecf-4b26-b0a8-011bdc76283b@kernel.org>
 <29edec61-8f11-b9b1-3df9-2a51815ee771@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29edec61-8f11-b9b1-3df9-2a51815ee771@gentwo.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: d75ecim785wkg4z16nq4q3ztfxeojokm
X-Rspamd-Queue-Id: 438761A000F
X-HE-Tag: 1785941304-159821
X-HE-Meta: U2FsdGVkX1+ASbK+6fTnLqZfLGiPV+aWoVg4C4e0POzFnwgKVllfi/KEMqybB/vPjzYun5ORgnq40I3VbKJo41Aqa23zndvb5bAg+5646C/kdY9L0DsygjBOh2bW9rlVsLkSlcW7W5bCICS15fRTpyXrK6IIlRkamAgcGFdDRf1oEX4Kn+1K4ZoCHIQdD0ef/utVILIP+fII6lY7YyoE6G0GqQAsxpKePGmWRnw2DrprPiO0ixqoW4gw5wKqDIJ/m9wAL+a1iF06O+gEgjoCAtIK4t0VbXROAzHHvbPMufYp0eq/QB3fcM6lYVzDI7WRwlcTpVMFObzME+K5JKdFdncJR1TYKkL/yh/cQSvSKnx9J4qd2BUZK1ATZFCvqxuRW1fEoFTr2pm8dLryt1IyLRDA0Kno4CW3CI1taDHoWSz+ULdgdsURCN8vUzXEibnPj4AZa2p30e71PJhKmvYuC7oczjZHmr82PxF/kMTjfcB1OXDQ1zNTz4KJGPnbpMn7dtdd9/goeI1IVA2jkXrTY7J8chlbZ/9/58qA5pRQJlFO6TG8HIFoiLtwzMnlYv4RcZqssFhs6o3sVwypojT46ZpOdYpEqTbGuXtuWmYAKzTDjcCWNs5Hg/lwFUq12X6JvXElZj+oFodzgNPqIs/c7vLaAfIC/svYGxZeLrUFX18MmXqvW8/Nhnxo/ovls/UDzg+mDm7Rc0GPGXlRTmwkgMWV3nwj/+gKjHysVjwqI7hxnGDSgOiMdS8gTCTL6O5arebwquCGa5H1/Y4Zg12UrSgLuzDtQdu4cmGGu2wYhtqJ8JXg6vRXPVV8sx4pnp81u9WMUMuunWSxwidEucpeBMVDH+mDiSoGG1FzUGLvxdIfcDMBOutjgKdxWoYU4fZ7FEkK6Y6+KMIR1opzLMXlxuXxPBZXvQV3CvLZvyLibJUYX0pTUBwuj7bu0pJBrWAsVNpDw2VCLaecGHIcgum
 mkf/qThy
 e2x7qReVmVXh9dkyqiY1vDTIZMokDUvecPibZfY7zQVUtVMdIVRFqAlyZv/tgsZDtu9YwwgdpnDVBTil/6l3Erm4RCSTPgGEMZKxAzzOV3b0IdfSNpj3EN8wRmkuaWg68IZmho5CKiiRQ68FHo6DKPYnJUmFVXaj6NBi6ZeI2VUDv87WKSF2LJj6ZrhVrKMI4+pD3udflGJhCSv98onyhoJEcSji1L5Kjux8ZvlzOrJSDwXSoj0TI/iYRwH5snUWzE0+rLTXsXHzoyKN8G6VRut/JPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:35:22PM -0700, Christoph Lameter (Ampere) wrote:
> 
> > That's really all we are asking for. If there is a measurable performance
> > difference, great. Share the results or point us at them if we missed them.
> 
> Scanning over the patchset: It seems that you are using a special
> instruction that is unfamiliar to me. Which processors support that?

Which patch and which instruction are you referring to? There is no
information to go on here.

Asking on that specific patch would be helpful.

Mark.

