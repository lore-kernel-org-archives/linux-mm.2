Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F6FCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37226B0093; Mon, 25 May 2026 11:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8466B0095; Mon, 25 May 2026 11:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6FC6B0096; Mon, 25 May 2026 11:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 890556B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:41:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23E548BC13
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:41:04 +0000 (UTC)
X-FDA: 84806355648.16.0206067
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19DA7C0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:41:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vJnA9JPY;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h 07oMAB";
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779723662; a=rsa-sha256;
	cv=none;
	b=LcfMfmgeeiH9qXZ/qESJzaC0SJsScyKmjX3WmCzSavKgRc4DIninMqnwLStdjprZdFuDLE
	fspqFbN+oYRqEFD820X8zNh1MRWotqE4gdnrsmdoT/SPzS9SnpaKPBoOlsi7q/HvjtX/YF
	Ct/lARyT6VV95QBymG251qWmGosrppc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vJnA9JPY;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h 07oMAB";
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779723662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6r85cn+s0tYjNYeT+wcFes8DXkeNkXDuZ3gDEspPb8=;
	b=ateavRB1icdd3xJ9LL+ntNb7cfecQMhDV+vO07gnOeo8DmeSDTRASehsBO8vyZAM8II+zw
	6LtZKlnmUxdRMvG9OXnGtlUJEfbnK38LvVSb81CgtVE5+xErNdlMCHCUFPwR1pKZBI7aZ+
	DitH8HQYs3Mb3HDXjf5Tcyrl9BNmfEA=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 4340C1300AE8;
	Mon, 25 May 2026 11:41:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 25 May 2026 11:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779723660; x=1779730860; bh=S6r85cn+s0tYjNYeT+wcFes8DXkeNkXD
	uZ3gDEspPb8=; b=vJnA9JPYSXcE1aM3x0EGZAWwwVSMpFugkklacW6BM47LtO2a
	4uaYc3DXsJC/PgelfuQCRMlHVfww69f6Xt0eUOaXVEQZRH23rPlfHx/pWYVmwm3C
	KpXodAEbm0TjKaxcq816Kif0Z0tsRySXPJDRF8EkX7hMMkFABojTsAp+G8bmsE50
	AFM4iRRcpyV5qWsRuxYyhSpQCAt1nQs8e/xyLepz1BClyitaloSt0HdLv7dGC7xe
	R21lsidLcrR5QY3Ng8vQYM+edk9NJxxjKNPFD+lKzhpwvi3tG/8Dm22mI3LRrX3k
	+h5+wb655Rgf3062+Zm6NVfv6vMc1R4OaSMQLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779723660; x=
	1779730860; bh=S6r85cn+s0tYjNYeT+wcFes8DXkeNkXDuZ3gDEspPb8=; b=h
	07oMABsAEpTvwd5SrGEWVVvOhdqotPvRO5Ql1Wzfxo883AiNR8xt0VIEnhUfG+Dd
	JV6/lUbGRxE3uCTk35Dr+Fk0Ob8zNqBya4ylUporvdBXb4zpf0gdJ7OnMm24YJ6t
	OBebMgwYyi7fefZNFxY+tvKw2DQZWmgMedI3DqnY7UTp4Dk9h4Khlnk4jj9FWssx
	p9s/eber/QifNUNa/sjjvlfOCbDvzrHwsxk04PIEzxvcTANqB5sTQfWeDbK+apeZ
	jVJgr8LM8W8829c4gvdWDMLbuDkoRH0ky8cJMq+KkT9j0yXmXSWXVbmaYQPoFMLB
	Jpw43LwoBq0OgpJQiPieA==
X-ME-Sender: <xms:i20UauSh_dCVJbeTP56kimuJrtWPa2kVoksNlM7BYlSrDLvvbMkdIA>
    <xme:i20UasJO_tbPfslfr5MHiwNUHAtBtu0yx36lmuXbjM3XCQKbjUFKxXuZ2iUuA-Uc-
    bgmv74CKT-Eyh_R6HAvAgpGUYb0n-TyOR4ja5T46ph92sHQZlspxQ>
X-ME-Received: <xmr:i20UamEaGX3PuRCqowuVuHsnVNLpWh-R0UMnmcsmA7c3evmFTk4FpFl-5WDD3g>
X-ME-Proxy-Cause: dmFkZTF9Dq+do1pjsbXgPYH9Kq6zeKrlAj9bOft0Q/2TJpwfI2rC1Z0p4fA/pL63pzSruc
    zcaHVIMVJ+r2QVPs+AAS0OzZnc4MJPebalm2eqc6RbL5yfH39bzQIR/fPuUYf9zcWFg34k
    M0RP+DtT5NotOyA/iqYq/gUuvu3mn/tsPIoPumrt+aslhCvB38WXlNP+GU+PFIMfSmGlqj
    zW+m8/GW6UeUu2B8C7AOjXHFQfl1zT+J1FgcwNBRFWNmeyz11UAISxWq+XW0zX/mP87KGE
    gw2kaYPOcsZyd2aFWGYTltyMdZE5S7qgu1FKrMm9f2nZHkY3+LV60fTFyPne7bWM50/CeW
    m1qSc1ZemOSqsKK3dbkfcVQHa0JQHtMvz+KCbWnuFjAtNSX1So0K+xr2Sw1XsoC21rMhG1
    ZpGgDCgsJAPCq5GVr6EWlDkYzmpqfMj6z5MqcfFsHFDKzzPs25zZdd5kt5vo3hzAbqv5go
    /qf05PZdJQbWejVvZLYi7JhRR8jYLBy1myonRKpmStHIXY+2I9fRncq3MhMhiafyqVqkVV
    /WwbIR3K0IWpHENZuNYO2wpdKvyWzKwRpc6yLF0gO7fXuERDaNWVv4GPoFeZS6laT/dCks
    oCD45+DdF8pX4ubSmJjywxIJqgm7/wbIMAQ2/2nzUcWVH3K/o06nA76a8O0g
X-ME-Proxy: <xmx:i20Uaulqrlhm256mmOptSob3ueBQysDEqGAAp7AAcGMxyWLOGutMeA>
    <xmx:i20Uak1aJOn5UaUhh7rKFskA3wfkL_mTSdQPxp0JLgcez-40paTe7w>
    <xmx:i20UasyA85unvVqllEH_a4-sWUF0i62xrc7qQZHWiJLOxlPb5RSYSA>
    <xmx:i20Uak8GBD8Bt8tT6Iy80pHOagcm9HitcGqS3ho_71OP1qm_Sem-eA>
    <xmx:jG0UapTltX0tXUHqnqwnEsufNcvPtbohvA_imvg5BEC0D5g2HCYocSw7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:40:59 -0400 (EDT)
Date: Mon, 25 May 2026 16:40:58 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 12/14] userfaultfd: add UFFDIO_SET_MODE for runtime
 sync/async toggle
Message-ID: <ahRsbwvg_hMZ8q3W@thinkstation>
References: <20260525113737.1942478-13-kas@kernel.org>
 <20260525124220.5336F1F00A3A@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525124220.5336F1F00A3A@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 19DA7C0002
X-Stat-Signature: ccmwtsowgnp64fexofdyf19egme4t4p1
X-HE-Tag: 1779723661-619477
X-HE-Meta: U2FsdGVkX194HTvodgUoH0HpBCyppeDGGdL8+flMPI2+b/UY536pyRCmPvYGqOIskEe3WioAF+Z1QrtzWckQKE223tFk11bYmUk8N9rWAmhqMZlZtEJcPdQfwctBC0S92iD8vZNgnNIq4r3jddGjSZ4vlwS6i4pHllnatkbXa+ngNyRGatDfz35ilpeSIr6BfNk0aB/q1+WKPBfQfmTkJ8YtcyjwiQmKA7S1rmBam6RdMN4NHjksAVu3VmIuMaybQ62qq7ilwqHhULEf0khcrFF+lwV9+B5pPrA3dDj2Pn29N8HF5+CH+VW1hmJ/4jflC2MmEw80/RFEXpOLXWtAY/1fUmi3RDCYIuHFT1rKzTYoQXba8Jffsz7GFpZfid3V+CQkCvovFnQ9Rp+N0b8a1GH/Jm3Aj3mFDP3bh3LcGYdEjhKUu7/gX5JeYCJdUI16RKPrVUL+pZFUrh6MamXDFvdVBZEIJHhnliSdt5ddQhUQ4F9sXJZg9S11m6IDSOLcya7yrKgO5Iqt81lVlsDVem4EEuMtHRrp+xN9u6o0p9VvQOo5zxv1JUoYGI6iy31ODIK3kMugWd/jY3jEHf1R7YqSXlk04/LYXFVTilxCNVxy8p7jqaYdVmwqeUdfqQ+B4yDTFpkqF8dIskHPrf4/dP5jeLcTcGus4jaY2wt0zOs5ev2oUN9OVmES2cmXeF8iHFIPIVllfO6rLT55qVIZkPk9v09GgJt0/1ZDkEQF3MIo437AyNiTT9yrb4dHRYznrQB8p7ei84e6DPeba4DARgaEn95+LUy1vrJHw8mwzR3hOEUY7C7jivHJ6t3erNAfQ4TC2euKLITDJ7mcAwf6R7+EW4L424eHBgFvqPh8KxsbC2wQ4mKBN20Ww+rEyzfLP38fL5c/MpCxRzdzl0kedQMQa5NYG/t8sxl+LU7V/qofgkZNIxLEFkSwlehUVLQTLOezXNlSFZSQXNmXRSD
 kcjKPf+G
 pYKd56OrGCGcXBrcjO3eOD9+a7aQGS3VW3g26pOpIMESQ+xnUF9gQKzDFmv+sRApktNDJIaYILjfcan8cSQWo/OnO1/nwIb7juhNC8SPY2ifwdtaet1NPn75dyzfcG98QZGYaPI5DWEDVnN9cDPMGnaLeLsD+R3cosGutJcMC1+ciUePBX+lKns7fk+2jcXD+0yswNySZGvfcgXS+xExIkB/tI+xMZvJJGCK9bJfGWzqp28FuWs9FIF8Ln3gMWrbT2McjeJ98nul+HlCWOdkXiA6W3LaKjUQoisLx3872QgoakW2va4wlltSyRlNo6IRBIaRsE2xdZeI9rL09nqL7H9y9BSWmXhXNkHFhMW2XbWFP6PoSayg6RAi0fE33ghnLsPeMzoOWmbDvJlSlFd5+yxbnE0c8wvnAym3NLH2Xl7IK05dYdZ9UDXARNSV4det3JpsmyQig1isJs6vmMQUneYMScN7wx32w2BvUj/HGeGc3h5aaiGiEHnGW3+MFjdCLcuyBBNa/SoTa0/sq9cvFcNZF3ayX5k73JbM/ULTEs+dQ3oMK0Lepp7moZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:42:20PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The userfaultfd_set_mode function iterates over an external mm_struct's VMAs without verifying address space stability.

Pre-existing pattern across UFFD ioctls -- userfaultfd_register(),
userfaultfd_unregister(), userfaultfd_rwprotect() all iterate VMAs
after mmget_not_zero() + mmap_write_lock() without
check_stable_address_space().

If the XA_ZERO_ENTRY hazard is real, it applies to all of those too;
leave as a separate audit follow-up.

> - [Low] Lockless read of ctx->features races with its own WRITE_ONCE
> update, causing a data race.

Will be fixed in v5:

        -           !(ctx->features & UFFD_FEATURE_RWP))
        +           !(userfaultfd_features(ctx) & UFFD_FEATURE_RWP))

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=12

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

