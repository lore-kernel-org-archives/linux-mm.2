Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012E8606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fB5S3V/L
Received: by kanga.kvack.org (Postfix)
	id EA6EE6B0B9F; Fri, 23 Oct 2026 12:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50D86B0BA0; Fri, 23 Oct 2026 12:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D400C6B0BA1; Fri, 23 Oct 2026 12:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B50866B0B9F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:37:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13A5CA6FBA
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:37:40 +0000 (UTC)
X-FDA: 85354447080.25.6A712F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6577914000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:37:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fB5S3V/L";
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792773458;
	b=cKFMIxlMt+OWENyaqZ9foFuzmLCaur7K7biBBmi/w/PO6jUwOu4xue7tgaYWKmaDSxluRd
	r4OLmflPZcX7RqUjTX7F/45LQMYOxV2rc1CYU2hVNgtFcdz6aPS7kuhu0XSeaXClve8mKq
	fENpB42zjBUiphwXatYMUCLx2YP6Ies=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fB5S3V/L";
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792773458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6quEbk1wjADIYDnbmI8RxySF7eMLqCwXbNeK/3QTbQ=;
	b=CGslWojRfdawyF1OqJ6Fg7+psJszf82j0neJeOigxEmToKxM7ldvxmLML02o88tuujskaF
	RT2g9U9mAL6dHtRLvYXD5HLptOvQuOwgzAM5HsFAA4pWdEMH+yhNA1k0FDvJRmLq+C61oF
	P3vDjMMBu6jMCqnfyOUi3x5mH5mSCfc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4674940F63;
	Fri, 23 Oct 2026 16:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458281F01825;
	Fri, 23 Oct 2026 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792773457;
	bh=Q6quEbk1wjADIYDnbmI8RxySF7eMLqCwXbNeK/3QTbQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fB5S3V/LaS0CaeNTSAaiAwX6QQaGxO+OqMWheFNTKPAvbenke7l17ptFB0A7vQjb2
	 JHvJGb6q3DIEyS/cw6/UVetwp0iUl8hd5HXKpVWv9ECNJNlcHsBYVnzI6Gd4ZtPYE8
	 oOlobM1tBmOifszaS3w7PmFzmoUXQeWZBv+GoYyzSU3L9tu8HGfXFF1u4zlQ/X1QFI
	 /pul3GxhWLCswfRS3qeRhzKZZaau5Vpf6R+DkpWAyaT2Q1yXLZsqVJ16O4jIO33YnM
	 N4xKOh5r1qKFveuMPJoE7khOS1YZ7HWmA4gBGV344J3/484dRvoqbOlF1M6el/vCzv
	 Cz6tzE5ePpetw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Evangelos Petrongonas <epetron@amazon.de>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: check fdt_phys in is_kho_boot()
In-Reply-To: <20261023054518.3258350-1-gthelen@google.com> (Greg Thelen's
	message of "Thu, 22 Oct 2026 22:45:18 -0700")
References: <20261023054518.3258350-1-gthelen@google.com>
Date: Fri, 23 Oct 2026 18:37:33 +0200
Message-ID: <2vxzmrs4fk4y.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 6577914000A
X-Stat-Signature: roaj9sfreayawqqcxhynrotkzjas5czm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792773458-747359
X-HE-Meta: U2FsdGVkX1+XRNPl7rsszUo5khSLd4TbKkLVOd8LVbSahiS6QwpXURbBdQIYylMs1BsGbzGi3qATiLbsIjTEQwU2aFT/wKe/0Q70QM72I1l8x7XADT9SXXRuFeraa4NLhsfyQDRnFBd0dWOKVcqBNwdMTCbboWL+t/+l/lHA/busAnJxCdcAdrYDAKFyMoxBIx+B8Ww8UJCOFVVQIxDKP+f00QS+1ENANXezMmY48QZyv+S/49shr1dg/oM6e1DfKOBlywz/mMU6XnbEEH4WFy2abCfjiWHVWsoOTCrJY774xte4e3YXm4eGOkBaO9D/+vukzH2r6saqFt1V22FcjMxU4Ad4GRgvLp9/LhdpMwHHDsKMGRGxesrkyhdc7bXysMkENzOnabP1PJPEXb+5TnK8TIfw9j/ui5eyr8hZF7QOxEyuL0l6/H52WoqhECB7hwxlyLcoqKE+/Px9IYZWbFaQ2ePneKTUB5YsiGPG6IfBYTneclwA2RQcObVpSGUA/0voQP0RUNCoDKjRHqh7Ce81uUAYuzYx5XJA/xHtr6USLhsdf/nhUCMGKaMrQPeKEZ0RRrcJBYITV2qAWUQ186ceqcAsEu/0Ub4hRzyblmMEI9+xz7OIXyGaLHBfmRZ0KRPLfH+DN1ZTs3y9cBWyqULldjnffP1Mz30LcTYDynEbRicnkT4GgjAUg7zg13Aa37wq4ru/MFTDigNAU44W1w5OdOYnUyQZfrhRu3SNgnRovB3WtZumeZ7BoAmEhDKj6oop3MdhSqMceNHfmZGTJ1uT/mftauFtvo73JMNZqRoIe/5I515RBKTnUvp4vJXTJoTzvNUJWOQnrv3g4pSqt3k1bh323tXLoVoPr9QY/KMEonqiwgokleiv1okuzTlRW08AodN8gZxyZiQ27Exvm0Mn0nhy5uR8/bSEAKE/5Bbc6JQd4YSs+Qmwy5ABy8gSMell9WIHzjImQFGon5w
 LJ6ypjin
 K7aMGOIqhOLcXgyblGqGo6e2B12vg5DnGj0iStitK4yc3NvFDe18sytPzySYxsKO3cB/pp1e124fjNRSYQIQZqwQKtCnz0LRDc/2SWcC2OmKSiHWsGXHFNHvs8ZnfH2qHormYSAx3vA+KyRQrvpuO9wnWGDuZmNAFuUNUt7nDvOzr6T0pMVD1tNt8MTHL/osiYxgG/t4BDvYvKDl9iUAnUI1wJP7YwGNLUE668S2zBRhbV+AgUNzcZpdk2fUmEub5etSYNamqnuybpso4ppdjosJfynaWAkfelc5iN1R3t+lrBc6S3Df/2J6vgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22 2026, Greg Thelen wrote:

> During arm64 setup_arch(), efi_init() -> reserve_regions() calls
> is_kho_boot() before arm64_memblock_init() initializes memstart_addr.
> At this point memstart_addr still holds its initial sentinel value (-1).
>
> When booting via kexec with KHO enabled, kho_populate() sets
> kho_in.fdt_phys from the /chosen FDT node. Calling is_kho_boot() ->
> kho_get_fdt() invokes phys_to_virt(kho_in.fdt_phys), which evaluates
> PHYS_OFFSET and triggers VM_BUG_ON(memstart_addr & 1) on arm64 kernels
> built with CONFIG_DEBUG_VM=y:
>
>   kernel BUG at ./arch/arm64/include/asm/memory.h:377!
>   Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
>   Call trace:
>    is_kho_boot+0x2c/0x38 (P)
>    efi_init+0x94/0xf8
>    setup_arch+0xf0/0x240
>    start_kernel+0x84/0x490
>    __primary_switched+0x88/0x98
>
> Check kho_in.fdt_phys directly in is_kho_boot() instead of calling
> kho_get_fdt() so that early boot callers do not invoke phys_to_virt()
> before the linear map offset is initialized.
>
> Fixes: d6d511639185 ("kexec: introduce is_kho_boot()")
> Assisted-by: Gemini:gemini-3.8-flash
> Signed-off-by: Greg Thelen <gthelen@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

