Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E534810ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553206B0096; Fri, 27 Mar 2026 10:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A756B0098; Fri, 27 Mar 2026 10:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4683A6B0099; Fri, 27 Mar 2026 10:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 388326B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:19:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E893316113B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:19:01 +0000 (UTC)
X-FDA: 84592049682.29.2C11D49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3801D8000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:19:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XLrBsEBg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qt1nKzFr9A0RyHyiO7oxObpb84/VovtYmewVoLjoanw=;
	b=j8mhMe5ttVXf05BJb3Zmlaqu00QK9xLRpArbDXPw8Usp7SFkBAupVkD7pASWsyXXigzAnA
	mah8xpCgdnMvDY5HNcDJyMD5kHqIrOQVJtIojHZlHtO4L16XpaqeFXTTLzfIPpv+nYZ+5N
	L96M6RWKJy4QrkHyuqPiTbckSRNeG7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621140; a=rsa-sha256;
	cv=none;
	b=ciMAprDHn8AjCdIxeR7VgxQqcpDOd+KleDRrBaReuVcYsp0Iltq47sH/tJSfsF/mSL4bOO
	9UdN1crdtEb/sKSoYDkkw3BebuoQlJcIJmFhopkvYN58XYpcitKPvX0XVfRSTSY7TNqUwS
	3KfoB2DBfqfaOnzw0mumlH02/SY3DUc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XLrBsEBg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58754433E7;
	Fri, 27 Mar 2026 14:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22163C19423;
	Fri, 27 Mar 2026 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621139;
	bh=WO0V06oBGtjE9ScW+EyWlnGevQJTkxKvoZsa7KCDZ4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLrBsEBg38zlFp7ThZWOUD67yqC7JeCBh0emG5Z9ZDL+O2VQa8hk0dObW+jQaDdnF
	 Up+pmqQP39kCpQe5uxIJacajFB1dBWqXWt7eIRF3AWqaPoFwS4kWnRBXQ9Q2S43nii
	 LabEDo1Lj8hD7/Q0tf6JGktauv1EDLO7imU1ohVtBj45xSq1XPP0vBmETu2P7J++q2
	 DV2eR7ModkjM0KrCx2jKDKVFsHiHV816NqANyd3fmUCe3+q3S1SKE6AzDFxWcv978/
	 sX6nTqfBHDPNi7jmhi6txz3GPF++rOcrqaSKL9WOnp6I8SRiT771Hgu9dkBLd9reyg
	 jD9GwhLSVu9FA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Fri, 27 Mar 2026 07:18:57 -0700
Message-ID: <20260327141857.4484-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327055051.61731-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3801D8000E
X-Stat-Signature: 138eq74opus1348ebyoea41kccjuhio5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774621140-895606
X-HE-Meta: U2FsdGVkX19qZi3xh6iWBY1sol3m5rvKgGSf1j45hGfyJgsH2zJ44TMwC0wkX97QGX6n1XmrCpImqAbCigB7AWls5KEBfoZc/aIV2mjuVimZ+d4f83IMh2A1D1kjWRFs7b4YOMtYa37afIdq9o7oo5YYwtilLjlQ0JaO9dB8sXNRGb14kbO556GNhwph0m40mcNT86y+g265tKAVIp4F2TqUdR/KyxS4/EiYnGKzdEnWOgeLhQF4yE4FkeQdxLxNLyaHFkYjvJ88s0BBVFs+EWHwEz+mlAG4FHolklXhW5wV3COoNz6lyLedh/lABaktxKBu1LInZ+bZYKjIZ9oCsjdyz0BPlqbqwKfwhFbwrPxAqnvX0nj86tYzUwI870J4P2wjWZs3kvBxpWZXO2+g3NF4pSiIRLF2qPWfRCWBxFCgU2Yg7v3kyI7Vo2tJuDSlBHgiccRf5HI773fvTEmHSlxQl/+TubloVPipCiGYrTIICxXJjkocC/flDlui2aaRIhr+hqkd2xSsl/ejZmgFxcgXZfdDY80bex4sWHSz/W3u43b5hRGA679tgrt1Up2UMTyQdc7XVstcsGg6mmJ8MqsCERxTz0tji1sFrSz/kQTFXHOZm57yXiqaLPdUjNiadVhm2lksWSEmjrnoYiBAkIZzkHSLIyDR5tNazGDFTidz3kGLy4SHmC3PsOhTedtUDADpItvnWwPRmWS1qPiJMWMA5dRfbSBK0VTPCKx3TuZcqNzgs3ke9zTnUNbi9lWOd19YCyP6yKgfbwwxVCvD4r4ZfE0xpJk0GBoWyZTZXVZnWtrclbwgZamB0EeJzk34DN5B1Hkxv1nd0R86T0seFbN6Hba9aJZ2AsCxEDFq4L25uWSn/yJSNrjZb8/I/vUwLU86ogMdbpgyDVHil/0t3RfIIamoLLcm9eI2yaF7nqV5ApPt0XahdmNtCDwY78tnwWpF2t8A24Tbor4nU66
 cPu6Z7yo
 uIIom71Z4m3OYBezQbyJTMGnzT2LT+Oa4Fm4IMWeBJvUM/nMtDEaePqqQvFtU10f/11Ws7WKvsU8z35Tc4aJm/0vNDevi+tcx/W3b+TJFzsk/VPqj0jZul5SNkMVqpKw0hN4CDJh4+FkX6J43M2Q1MzrXKMZmjKoeSAN6Vuu6fUZhx4GZ7eHNMMM9IXaAHiq4NlA/sh+LKwLZrCOm/GEuxdXcUXwZ4Qx6VvbDkSToJpTresBxIdTMkP7AeQW6PQKFOOQ21O0R1LGHi/WPl0H3lCEEyxyXizV71BtxsDsG68mFz8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 13:50:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Thu, 26 Mar 2026 22:08:22 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > [...]
> > > > > I will add a patch in v6 to validate 'addr_unit' in addr_unit_store() to
> > > > > reject non-power-of-2 inputs immediately.
> > > > 
> > > > That's because kdamond_fn() has recently changed to exit the loop if
> > > > damon_commit_ctx() fails in the loop for any reason.  Refer to commit
> > > > 26f775a054c3 ("mm/damon/core: avoid use of half-online-committed context") for
> > > > more details.
> > > > 
> > > > Adding the validation in addr_unit_store() would work, but it could be a kind
> > > > of whack-a-mole game.  I'd prefer doing the validation of all inputs in one
> > > > place, just before the last damon_commit_ctx() call.  DAMON_SYSFS is doing so,
> > > > by making a test context and try committing user input to the test context
> > > > before doing that to the running context.  How about doing so here, too?
> > > 
> > > Thank you for the suggestion. I have now added the check
> > > '!src->addr_unit || ! is_power_of_2(src->addr_unit)' to
> > > damon_commit_ctx().
> > 
> > No, what I'm suggesting is not adding more checks, but reusing the existing
> > checks in damon_commit_ctx().
> 
> I just realized my previous reply might have caused a small
> misunderstanding. My intention was not to _add_ a new check, but to
> _move_ the validation to damon_commit_ctx(). So that patch will only
> modify damon_commit_ctx().

I don't really understand what you mean.  I found your patch [1], and still not
clear.  Let's discuss on the new patch.

> 
> > 
> > And, now I think bit differently.  Given the purpose of this patch is making
> > commit_inputs synchronous, I think making more complete validation check is
> > somewhat that can be done separately.  So my suggestion now is just keeping
> > this part just as is.
> 
> Understood. I will keep this series focused on making 'commit_inputs'
> synchronous, and prepare the validation for 'addr_unit' as a separate
> patch later. Thanks for helping me scope this properly.

Yes, let's discuss on the patch.

[1] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com

> 
> > [...]
> > > > So the issue already exists.  But let's ensure the fix is merged before this
> > > > patch, since this patch adds another exploitable path that can consequence in
> > > > whole param_lock deadlock.
> > > 
> > > Should I wait for your fix to be merged into damon/next before I post
> > > the next version?
> > 
> > As long as you agree about the mainline merge order, I think you don't need to
> > wait for my fix.  Please feel free to post next version.
> > 
> > FYI, the latest version of my fix is available [1] on the mailing list.
> > 
> > [1] https://lore.kernel.org/20260327004952.58266-1-sj@kernel.org
> 
> Thank you for your confirmation, and your fix. :>

You're welcome :)


Thanks,
SJ

[...]

