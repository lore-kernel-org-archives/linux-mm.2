Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32763C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 10:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A804B6B007B; Tue, 28 Jul 2026 06:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31D96B0088; Tue, 28 Jul 2026 06:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922636B008A; Tue, 28 Jul 2026 06:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 582DD6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:24:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFAC14033F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:24:46 +0000 (UTC)
X-FDA: 85037801772.05.71BA3BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8E6EC000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:24:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwxMssBL;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785234284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4inssPqpsD7BfQ38galVPAMa7N06dym7Nw4RodxwSQ=;
	b=KgXBu5ZhsDs8fbv0nWrqR6GC5Kq+NAYF6meZgroDepZUs9gUGWjJ1Aqsvhyv80mYs8lMjm
	dcfMBZ6HEKzRDzclfBrdUEWP5pPSOitkFSGi+p82J0tMgJj0fq8z7RJEPAM+sFzIyWEoKf
	HKAkl8v45Op8ivit/TyPBoE4mqds3zk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwxMssBL;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785234284;
	b=Oe2YKgjuI489wnwlRXISMV2rpdHqWatlxl5+8mT3crElCfYNw9T72ZNPkANz34HFVOul1N
	yOnB7WyVE30+OZ2T2L1LdTa7uUGfnZ+PG6LO0vdFA1A4sBdTNtt5GRlAgK8H0tHtW67VhY
	reG7OKVidFzpdGSeo5HJrSaHYIY2AQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64DA060A9E;
	Tue, 28 Jul 2026 10:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06421F01559;
	Tue, 28 Jul 2026 10:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785234284;
	bh=s4inssPqpsD7BfQ38galVPAMa7N06dym7Nw4RodxwSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jwxMssBLhOB8rIsSMd8YAnlLthfYIHaV8LSqShCqV6EsTTXlWGfBhgH7l/ZUmNVGN
	 J915WjAr8AC1Ilkz6D2SxsE/6uiq5tJk6TqRbSAG4cwM9LwVAB82D8RbT02E/Zcdrr
	 DUIofSQcqBnDdGB4RLS6OrvgINMvJwvz1wyfLd4uj0GWR9M8mD6Y2glaqnLczDbzvE
	 5vBGJAFwVK+vPnDDtPp6E1tJUufKmC2LMTCXfgqiLd+ylXN83obNIgF0GOV4B6yEcV
	 SaCQNqj/L+aGnIEl6CrmrmGLSP14oH0K/WgSX36ox0vfyheIDlDAi814j24YcGsARe
	 W8kiYITkduYjg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id D486DF4006B;
	Tue, 28 Jul 2026 06:24:42 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 28 Jul 2026 06:24:42 -0400
X-ME-Sender: <xms:aoNoas9G7TBIfPeEHgDvlk5EhbAe7R_soy7Wyydi-8nyyo_3EtVLdw>
    <xme:aoNoalLn5ea_pHQYwa2OqD1z_vIXOWiboFC293hVRkEWKY2T8H_lD7nsXtWJr6QRd
    eO0-J9aqggWOxr9NbxDfUox7W7ugCqW43V5MK176b7kd8vDNJatYA>
X-ME-Received: <xmr:aoNoandtDQ42MXn6wBoWYA1DjCla7_EpsmB_iUDMsOogJKKpumqeKLTqTUKEGg>
X-ME-Proxy-Cause: dmFkZTEyehosGDrX7K3E/QOll5f4laseRKTHb5EXYx6g/CSljkTyK31g3IhRDiB55hhpRD
    +rj6sLLTD0TAT7a1nJudQaenOaU0Q6jK5rqmvXufpwIYH4DKRCeskDfAKHN3gUBRky2CHN
    UhSqI4piK7mkQO2R4Aw7x87pfhDwGI73W92J/c1tXRrQe7AffmrnpfU+uu6DJT5c1/E/dT
    O9lrj1TcFK6FzpMaIbm7xoPsGBMduVWfYzYAgkfOyQ+P9dzAUlUuX0zFB2lZdWSSp8DRmC
    VV7sqWMMjXGNicieXSixPSHMw2e439xTLDc2pNBjzLhPrfNfnnxK0jfyj7sC40E4PJSpJq
    NAWSrXzPUDBSPoYFlO6XEhhyqUSe/vFImDBq2g9YLHDhYpzCT5344zpofLOa9dlJ0vDGHs
    xx5IM/OHQngE6vqpqa3YRLSm2ex7bALcbG3/Lj4eZMr6zIOSM/RQun1RdZJxT7OYb6F9Qy
    8SVHdcD/UstGp8BqAbbHKLD30zXcBED8u2VmrAd21BmkFSmUU1sPjunbH3qhz+Lv8HLEnM
    Q4VggKqr99LxIWHJ79TO1s1Ss2JcDQqCNfXlkRjiUHV63UeUzK5SoorTmND/V6Ezd6kKyE
    8aKLdmRP2gCvWF3faEMPNJ0egFJDc9C5pic5o19aFNP12sAu6e1210B5IryQ
X-ME-Proxy: <xmx:aoNoaqbc_D1ygYkAJW7Obc9xJEIpk_hDtBxAh4jzpaefUF1nxYy4Rg>
    <xmx:aoNoalCPpud04phSjS5k1GV_imkGQKrNIsegsS9Krl14ZbLIlGWH7w>
    <xmx:aoNoalLsNdrmPqQNMOZHfz6akZvAOTsFUcwN-B08lljVrUrtu3tUfQ>
    <xmx:aoNoakowoblts5ut0D0t8TjzCr_mbWriI8OdXUyccoYugpWJy3ECFw>
    <xmx:aoNoamOyTVFj5wfP5SLV9zq_xIPM1VYmIubpFyjM45WMbyuZbRtH8-cx>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Jul 2026 06:24:42 -0400 (EDT)
Date: Tue, 28 Jul 2026 11:24:40 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, Chris Arges <carges@cloudflare.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/filemap: __filemap_add_folio() restore index before
 retrying
Message-ID: <amiC5t0HLWar2NCf@thinkstation>
References: <562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com>
X-Rspamd-Queue-Id: E8E6EC000D
X-Rspam-User: 
X-Stat-Signature: yek14c9pgy7tzxk3zu4a7w5s8wti47z1
X-Rspamd-Server: rspam04
X-HE-Tag: 1785234284-757072
X-HE-Meta: U2FsdGVkX1/54qTEbL7zofjUGpUStqBIf/P857b4Nb9+Y1Gu9ghgbE6sl6KyT2fRsnTDwZMo/oNuQ8t4fZ/M4mIvVp0n2MWjPLA6ANBb47JzRazHU4BLhmo5x9gYCAbTTX0b7MZMwXZRGYUnVZ46ME1+A+SWeZVE6j2iGKHNiEvAwhe1+K7M4cUxS5mLEANHUlHwrhCgKXZapkdLoeDyKncURINqMcxdg+SturRuKEvFnCFEX1LrhRL0TRFb4cpEhPOqjPyDIrjZeT1Fnms0xCkSHXjo/SoPxBCSJSHftpBfSCS6Hd91yFHPMd5QNP5RU3d/gsQLg4MA/xzclrr1ZtSCt7K4PT4P/aVZRNRbh7kdnD6YevzZtMiJDaeK6fhljIN+3pGC5ZhNoptDL2+1zAhwrUmcxaUrEdJlPCub1FnS4zS+5okGjh/Edtf37I8aU4WyKRy7OiGEEj2GsQvNtZQi9HgrcNa4cXeFIe7E91hcRexsnk9QroohPN43oOzINu0mjyGDH/eDolXPYFquNr6RVPQBxsgZnmJo7fnCRyBMcI0XNVuU/xEmum/kVGzsq5QfXDWF+qjKk6vH41m9+3TJPfOU+VbOfQGfseLCil5eXPbNmBBl7HzpCVk1NB73IDyE8kEe2vrEvZSRCPimv1YFND+k/1MMu+57wPmdayL1dP+UZhyN0XqWKzXLKasktjzIrMeSXIBxP70Tpox157sQSub4Z8t8CCNf0xHEVgdI/AtzDqTUKG5US8LwTkJTNHTwgb/Car31ohQS3inGRsWu+mmapq83UJLe10vylMSTUnZJk9s/lodtMfgiPZhRkPpUpW5N3OyUB3LeH8s0ZGsx9L7C97uIotae6D1ZBB4wv0xYr1FMv1RASj3+dSr3wxt9WFQS4tDuIwz1DJIr86KBtS4g3z2IDtEV0w1r7M1CiNfMkjvTnVknkKevMLjObbkC0SSn0y45PEOdeHJ
 vkmDIB6n
 W6WyzhzGKTOkYUIaZ/SBkpAKXQt8N6cQM6kuNLvqGJ/bbSblkcRf3IncA0FpjnVVsXY8f+lJk3aGSDL6OAFK3G+4EevkPWrqHnv7gL+fa1pDFd+K+zqB5PuFdlUAFM9VqIZ9jrP62hecwmJJCeU1gbArejfTqfDauNk9y77iv8lQ6enEOry3t1H9ZfmWf5xCEcctjfz+Hd70QugdkSGufHf+QgnfEVOp3tvOE+uMLh81BZ0ng46VV/Y1Pb4jMJe3tiEBrzcTjhISi25SD2bQrjmtACrtK9358NlWo3LkczTSrhgvrEw4wjQlOIlNHp1Xk+uZjNz7pk+yzABu9x7Lcfz7ID0L1ntI/WCstpFMCJaA9cB/+nbfU8GVKlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 10:24:14PM -0700, Hugh Dickins wrote:
> In __filemap_add_folio()'s split-a-conflict loop, xas_set_order() is
> applied repeatedly: each application modifies xas.xa_index, rounding it
> down according to the split_order attempted at that stage: and if all
> goes as intended, it eventually (or immediately) converges on an
> xas_try_split() to the required folio_order, with xas.xa_index now the
> same as index: then xas_store() puts the new folio into the xarray there.
> 
> But if a new node was needed, and GFP_NOWAIT allocation did not get one,
> the lock is dropped, xas_nomem() used to allocate, and sequence retried.
> If (that part of) the xarray is unchanged when the lock is reacquired,
> no problem. But what if the conflict was meanwhile resolved by another
> thread (perhaps even doing the same thing, inserting a folio at that same
> index)? Isn't there a danger of now putting our folio into the xarray at
> an intermediate rounded-down index? With !folio_contains() bug to follow,
> when CONFIG_DEBUG_VM=y is checking for that.
> 
> Fix this with an xas_set_order() to restore the original xas.xa_index at
> the bottom of the loop, so the retry does a full re-evaluation after
> reacquiring the lock, and cannot reach xas_store() with the wrong index.
> 
> Production was suffering from rare SIGILLs and SIGSEGVs, executable text
> found a page away from where it belonged, !folio_contains() bug hit when
> debug enabled: symptoms not seen since this patch went in.
> 
> Fixes: 200a89c159a7 ("mm/filemap: use xas_try_split() in __filemap_add_folio()")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org

Makes sense to me.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

