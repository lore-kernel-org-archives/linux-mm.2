Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F140606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vx5RaM+k
Received: by kanga.kvack.org (Postfix)
	id 107CC6B05B0; Wed, 28 Oct 2026 01:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B94F6B05B1; Wed, 28 Oct 2026 01:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F116E6B05B2; Wed, 28 Oct 2026 01:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE2276B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:35:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A80FCC0BA1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:35:35 +0000 (UTC)
X-FDA: 85370922630.16.DA0EBDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EDF36180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:35:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vx5RaM+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793165734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCF8kfzyKgaGcmmngoeyp1DL7LEberyF6cj2vg7mrCw=;
	b=2e96iqCIleNlSaL2wRsR3HkBpKqgmHrwUDERc8DGBQP+xVYWgQbjaov4P8oWy+PkZOjuhC
	qEcxXm+CSaz69GVgp7jNUPjfYHz8Jl848Tu0fFomNZ+q3FMhOq7dSexIDUK85w90MSuLJL
	rppZPkpv53Wi4vfAbeUtIbLNgKG1On8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vx5RaM+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793165734;
	b=UYBAIg2K9+SojR178lFuOpPOqkuArJio0JWtu9ZNuSq5GagO87S1ed+O24jrtnGNZOKbsA
	ZdlMFiDxOr3RLEE9biOfZn+yeEVelaC1B8SsEIIqGBKjhuSAsIJmW9RTx51EHsDC4IOuKW
	nWlpTRgfsLZmT7urRn1R9fC6vYLWHiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1140943952;
	Wed, 28 Oct 2026 05:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18281F01825;
	Wed, 28 Oct 2026 05:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793165732;
	bh=oCF8kfzyKgaGcmmngoeyp1DL7LEberyF6cj2vg7mrCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vx5RaM+kkDCqcYpK1TthH4mUUylEW9pvnlM6hLj9wD4ydPVPP79FDITUhr9XcbipY
	 9xGaEUTpZYpgQ9miH23CU1NgqEyRkQZb80TARyylyHKAOdJOhpuqm5yprWDKtFy75b
	 6xxyldCvVpHTDB9UygE0jMu+x5UF1FdfqeD5d9AWFbVW2cTOl4/rclO+W6+FpvoD89
	 ZoAYLpIJB7rZCZdEUcZzYeGBiSbybOQw6wLxYFa6Oy06VxwoqEq6j+ulym67/NwrLm
	 w65uM6fn6G3cPMnY/02Yk6Ij8crJhSIV78SBss9kcKuM4ZJ57rBWCVjPbBIfRisemq
	 D3Sf+ymu+jUsw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks
Date: Tue, 27 Oct 2026 22:35:25 -0700
Message-ID: <20261028053525.155909-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028052425.154616-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EDF36180003
X-Stat-Signature: 891i6u86guwqro8rj5zoiare4rmeui86
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793165733-529828
X-HE-Meta: U2FsdGVkX18kR4dqxF0cNP5yiIv6eOX3qF0LNgLUWokSmqxSXONHFA+KFKszTy7kV1P2cmggN6n2979kPM36HM/QPy5vYrQvV7BKeJJBaJWwXd6SmNZjCS8rlb6EhBCfNhwnV6Zg6bRbgDswW43HtoCqHLVEyvLc7DoE34ONpYt1Qkn/O6b3uMRdHkPfKmsq5A2Mu20ELzqT0/BvMKBOHb/RemASroS4XpFa8a1j7xGp+vIQFMjCxCuvoFbRQNQcUncvFDD84NJoDhjTh52LOYBZJUIJi04DBmktDpHC7wTQWSC0tWXi7/6UzYWJM8ugq7DsOaNxT8u7u66diG5wg95VsdraSL5t4J68k0SJKNYLBLTE/VVII5Y3TzqSXiOMTsV8RBWULuQXUSSDqHF7g+EuwSu433vtuX0BI0ZT+bo8uUsDHk9KSZTkDIf/ph/6GE/B6M3LHgSTHR6DBUR2anwfyIRjpO1T5WNyAKOF7QJNbI7J/hyUKd1azzBBVjbTwRPrJAPOvNWOjJue7JRaWBMVDpKcCqq0ldz/Tn02i3df2DPEBd96QkEeTKpfPltrQo+nQic+2GaT2N+IO31BbSNuNvGEWW7cQ3NoohkLndq5Xu18/Or+gYfEkRYPAHDzfDpi1FcfXBIPq47N+42Del8NzXaSSU6hOvpsbxjbiiJjdXojyWehe+EuDiwhva1AaBxEVC44+YnT1k+zBbbFIzbB30xkI5Er9WDt4OnyKUyGJ1QQHxjCG9Hc0/o7mEPgnB3vRTRD/ePgbDYiaW8UcwfIM81F5hYBmZUeTvkJjRrg8L9zAxIk2H/yDXP4YXyNBPgvdgy2rcWCMWyTobMwLxG5ppKdbpuR6KbkeEve8HDdC5aQBePkcNHPk8SEkgFPEgCIfyutTvAfRVnpDfQ+uzo7C1URD1iIES7TVTW6FodA62OOPj0lhcCzRo1v42RbSDYAc5u6NIIVrtcQ8FI
 an5+og2Z
 Y+aaiRkQuhA/Cd2PwLMclYDwdz1r49OdCT11JpVu2A8KOhcEmiqvdNsTvPDmDyLsQukI4mSLYQKoOcTS8tOAa7h277S7W61FJlDRDVvHqA6LkjfBVGZizWiuzlwieCMnab13eZvbEvA+vEx/Lwwmsf2Hw28V5j4TxVJvByREZAONA+N6xXXI0l9yPbsdGMQfNjriOBKdsvvNVPA84bppYJBJg4jFbHeVR8z4chLc8aPunPRkZXE2uKavawxn9D7slk7tl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 22:24:24 -0700 SJ Park <sj@kernel.org> wrote:

> Hello Jinjie,
> 
> On Wed, 28 Oct 2026 10:36:28 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> 
> > DAMON_RECLAIM runs its scheme only while the free memory rate is
> > between `wmarks_low` and `wmarks_mid`.
> > 
> > But some users want to reclaim cold pages even while the system has
> > plenty of free memory, and it is not obvious that the existing
> > watermarks parameters can already do that. So Document the setup.
> 
> Thank you for this patch!
> 
> > 
> > Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> > ---
> >  Documentation/admin-guide/mm/damon/reclaim.rst | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> > index ec7e3e32b4ac..23fede7d1cdb 100644
> > --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> > +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> > @@ -193,6 +193,13 @@ DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks the
> >  watermarks.  In the case, the system falls back to the LRU-list based page
> >  granularity reclamation logic.
> >  
> > +To keep DAMON_RECLAIM always active regardless of the free memory rate, set
> > +``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
> > +``0``, respectively.  Then the reclamation is limited only by ``min_age`` and
> > +the quotas.  This is useful for reclaiming cold pages even while the system
> > +has plenty of free memory, e.g., right after an idle virtual machine is
> > +paused.
> > +
> 
> I feel like above might be too detailed.  Particularly, the second sentence
> looks too detailed.  In a sense, it is not technically correct because of
> 'skip_anon' parameter.  We might later need to add more such controls, and I
> concern if this kind of detailed documentation will limit such extensions.
> 
> What about keeping only the first sentence and dropping later two sentences?

If you don't mind, I could add this patch to damon/next after dropping the last
two sentences on my own.


Thanks,
SJ

[...]

