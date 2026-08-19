Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718BEC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF7A6B009B; Wed, 19 Aug 2026 11:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A73C6B009D; Wed, 19 Aug 2026 11:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD256B009E; Wed, 19 Aug 2026 11:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4911E6B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:32:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C916A12035E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:32:30 +0000 (UTC)
X-FDA: 85118410860.09.C51C757
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 245AE80009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:32:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksX2KKDB;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787153549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewKOz5SEkfcTwwQGB2UX2B+VSVTOT4ozicerKMh6CdA=;
	b=27iXxHQrnviS22tQaHuUbe0zgQ7u/itgKznRXeygTApd+iA5YFggtmd9Uy0n13sllzsnJe
	59M7y0wrpPzGX2ez9U8zA8hPb+GTvrBlmBhnBKwZo6h3ESmqnMAbB7ztug1HE+7+fRj7Du
	7gLO2sefSgPk0Rlo22aFNarh1Bl06DQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksX2KKDB;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787153549;
	b=uGpaPdZrrNsK8IVKt3oZHhdcIaoxKPKjzqxnVmEMnngeDOCgsaRaX1pIvR5MtE+FoMM7lZ
	3vw8r+NJSEEu6gmG3q8leAt5ufvtoFLD6mFn9GjQPvO6OnfVqEBqRas3yt7j+xO+5tmTRt
	UPH3HrND6rgmaabb4dn+skD7OuwqxeA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9722840678;
	Wed, 19 Aug 2026 15:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF391F000E9;
	Wed, 19 Aug 2026 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787153547;
	bh=ewKOz5SEkfcTwwQGB2UX2B+VSVTOT4ozicerKMh6CdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ksX2KKDBevRjIArd5K+oDP+xXE64NaOZcoDHn57mmXP6WWGdCPv9ZRXJmeO4nWm/5
	 Fv3YZgHej98bbOnqAEM1erRVyXF1CMKhUENRKBeVorw1GSi229KF8G8Xt6xqFk5ybN
	 zsGwJV/5M7o38gYcyhmE9zLMSyTd2lSMPLQ5k5hGOWlw0Zt9yBMwitWRlTs5tspTUP
	 8HxBGvCO+QZoUgpsD624bDILD0ZnkbT9Wc+RHmQRBud5OxmGaMCWtLFoVR6F3sObW8
	 +czo1pROU9p06c+Hzrm+axPJdMHCf3ZkayAKH9Qm8ORxcyYXKq0Y5uBjIoErIJpXjQ
	 P3ewdnP4eCn9Q==
Date: Wed, 19 Aug 2026 16:32:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm: include swap.h in swapops.h
Message-ID: <aoXMc9bbZ21qfVSP@gremlin>
References: <20260818115026.656406-1-kirill@shutemov.name>
 <CAGsJ_4z_+Z_VppY3ravJxTgguK=m_pcYcbrogoOR2BdC6D-o7Q@mail.gmail.com>
 <aoXB5vZf_vwB-FOT@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aoXB5vZf_vwB-FOT@thinkstation>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 245AE80009
X-Stat-Signature: 86gusf47rdiwg6ng7f4343kr78674b8t
X-Rspam-User: 
X-HE-Tag: 1787153548-764128
X-HE-Meta: U2FsdGVkX1/C/JKoXa3LgKmaAjoIg+JHiJhcda93433cc/dPHby3KIKA06PrIHkfxfCf7FUvLvbkmbN7F3uL4QtMMOSB4jdKkB2/N2JO4U8XaKvvxtw1iR4Ic2k0qNR0u3H29OjtsbdwAT/QbzuRIj0L+7/pBRkmyQBfPDQcJ6BuksEckCUcSr+0tDeem4c8N3c3lUKlGMbmff8XKhriJ0clJhYVhGCxBWKipZWUgjr4ovaIQseW+AGxBQb67pcjEjqqvvLNyF563+upQfgE0ZpQ4dqsMuAdYGJQVqAzSuy2KhLg1ByldWrIHluooZC3ThWP/T3QU9MY5C0HreDO3AS2ovDx6zBjW8mOa0K15cxA4fWAgBvIr1SALTP1KCIChMcfZ4xcbVz2YdbgBkN9PmSfMB1ztGUJy17+5mPEs0brmIjok4dpjdeDe6mGrxYMtU+KY2ILRn3wH97DiGcjMyhQ7FlV2+WLrafA7LHOTdrra+v1dPt5ur31Mfk2pEWMREPMBY24ppjhoGMUHUDqjKTRXwNuwwWiP4MeHJ3SLpWwi1RTDHFdU/NhcJ/g/7Hq4x9pp1mbpZw9HesGl5C3/B8qazgyggBg4un3J24WEgH/IuTX5mAxs1Z4S1wGH1+2ON2XieScDa947NXncbUQVlncbAmUCzBo6m1+kTrdH9HAU4JF0F4sOeu6MqB2L3uaCfBCUrzsKFlic1s6QzFO0FAyNQT0Vnx9Y/khXZnnBfoaYZvil5ktXUomTDD/8rgfplOkN4vazuB2xHEjfKJ3IwEcqGQEzLyoSsEPmNOvJOyJpB7pkK5nbGJLzbSaqfMZkMHZ04/FilzqrWOwHSmXsVxhndSDYhkl+tlKpM/kfVxrGaWr38PqNz1TXdYfcDpJ8I3fSuYrVKp1oMjTZlMpL8v4OaaLQCnlebMD7Dq/a+b+aPkodJirczibEIIrSF/v/eaiFJEV3PVZSC31VwA
 jhYXlM0p
 HmSrg7ISecoA1bYTMjPyVkdLt2QJ89Po2znbu+bSt/yfLdbA5XSn4GCiutxfJoX11dK8ib4eAdEQw0rkizDOvVfIbtvAN6wFxODkfFkeBP2OxbFwF5F3jZnAwIR2KIkd6cexcfA31EL2ektPX4wvWY3axIOR6WXsGlTGVDJqitqV/poNSHmrk+HIWkSrE0LSKoN/J9VN2/02Fdbw7s+wqUVPzBAYBAWaJR5BqISZEI1hrT1CCGv3ch2+5xJ6hkI17JBgIj8Ki1Gxj74ilijLIDvOOwkaDh58NIG2qcN4nGjO8Rps2gFAp83itwu4LCD3ItLeA3YE4zXU5Edc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 03:47:33PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 19, 2026 at 01:26:07PM +0800, Barry Song wrote:
> > On Tue, Aug 18, 2026 at 7:50 PM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > >
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > >
> > > swapops.h uses MAX_SWAPFILES_SHIFT, SWP_MIGRATION_READ and SWP_PTE_MARKER,
> > > all of which swap.h defines, but does not include swap.h.  It compiles only
> > > where the translation unit pulled swap.h in first.  leafops.h includes
> > > swapops.h on the line above swap.h, so a file whose include list reaches
> > > leafops.h before swap.h gets:
> > >
> > >     In file included from include/linux/leafops.h:11:
> > >     include/linux/swapops.h:88:21: error: use of undeclared
> > >     identifier 'MAX_SWAPFILES_SHIFT'
> > >
> > > A header that uses a definition has to include the header that provides it.
> > >
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202608181757.mza9RRj7-lkp@intel.com/
> > > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > > ---
> >
> > Basically, is this preparing for the patchset below?
> >
> > https://lore.kernel.org/linux-mm/20260816224609.308019-1-kirill@shutemov.name/
>
> My patchset just triggered inert bug.
>
> > Reviewed-by: Barry Song <baohua@kernel.org>
>
> Thanks!
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Yeah, see my reply, but this is more like 'Lorenzo's unfinished work and a
mistake in his includes' :)

--
Cheers, Lorenzo

