Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36ABFEC0F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 19:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA616B0005; Tue, 24 Mar 2026 15:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAAE06B0088; Tue, 24 Mar 2026 15:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99716B008A; Tue, 24 Mar 2026 15:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B80C56B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:24:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A62B58A59
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:24:46 +0000 (UTC)
X-FDA: 84581933772.19.1861141
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D8FE4120011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:24:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mdczY+V7;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774380284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE1Ko+7HdfyNNdkuqqOebpILPEp16g+ZYSTn1w065XE=;
	b=0/WmHDVdcf4mmJnVX4Ja1D9UN/vUrrk1SFRlQ5jnQlq72fm7kgQpMRlQvXxZqWCbqX0hG1
	gD9v3u8lVflC4Zgc/3yX9BfL9PeNl8iiztaP5ILVsHHvDuuzW4P+PJ5JyLaA42kwYmUcIr
	K7Kuq/xKRlQta7oPK2w/d8vX/ky2vXg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mdczY+V7;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774380284; a=rsa-sha256;
	cv=none;
	b=CsdeimrZ4gVYnXao0NfA3vI+3aRC3lcBLYyAzec5lcmHXxOJTSBDUJ/+RK6JvULjjQ3X7N
	fuOqoGEuDUd5Zvq72pbeoqkwVqSMKnLpjLL0o3Lxnnkk8o0l1rg3HjKpzRHjdfE1Qii4Sg
	vYug4RYckfRXJabAEAU/zyfuRd4IyS8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58FF860103;
	Tue, 24 Mar 2026 19:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CD2C19424;
	Tue, 24 Mar 2026 19:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774380284;
	bh=FHtSpk8iPfRcVn8NiRGu3lj9HI/Guia9dsUmUUu5ZC8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mdczY+V70aSjcFxGt0fznlJcbwUNvG3RxqGybsZGYcq5CcYUlFgQZTpHWyBrVCwoA
	 l5UEiL+e5eSWzi32IyqAHgMO2W1gVshGxBjlT91w1UjAhSN/V1uULaqQuDJJPTWD/j
	 mxKVH6xAQ8wtN4+96XRRoQsT2BFcLXLRimOP+MMI=
Date: Tue, 24 Mar 2026 12:24:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@kernel.org>, <willy@infradead.org>, Zi Yan
 <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mm/migrate: rename PAGE_ migration flags to FOLIO_
Message-Id: <20260324122443.0488fecde3e3183856903afa@linux-foundation.org>
In-Reply-To: <20260324190706.964555-4-shivankg@amd.com>
References: <20260324190706.964555-4-shivankg@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8FE4120011
X-Stat-Signature: qx5r11a3w9f5n6exckf3318gnbww5onk
X-Rspam-User: 
X-HE-Tag: 1774380284-344413
X-HE-Meta: U2FsdGVkX19xttvC/i42T0BC8ST4FutZ+Vbl2SLMsJ2CEShZp3BcOU+NcScxBXmgfimMLovL5zP103F05FPkzP/drPFVlkAsdjzj3jMZBVqKc5IXFOHfmWql2INrMt9SRM31kfcfJVz4iAn0r+zztfmJ6RUd42b6OXbXJwN/cSV1wYppBvKXWX9QoTstEyQQwSAS+ceBwPY+VaOq8osz86jO/Icvc1bax33U7sDDqPwQyzglu05RQGYy8XeNudxzgNB0AHppbgSl1y/vHZTfprGrSbmi3ytmo0FpH30t7CfhQXmXQheWxh3Wo2aRXAPUNLvrrK3QYa2Sfqsc3UTx2tUII0IaZrIB2bt7pHlIQWEoASImGf3FHGf4VLcBR+jcyz+JtKdPJPgH5LCkUVTLO/KWLLaGY08MPMfUui3i2+1y+z/PD45z4CFj3axT+YYJi1+584AuArEsgmVK3jK+Egp8ezEtfZp1kfLt/iUdwYRqvaX6l4h8/Sqkf6O4rWXbJ6xId81qAECNTfG+zoWO3nqhxjd/BUObB7Ug1N2UmGs0YlcMF7pShuzMqM/we/ZyYsGa3a+fmM8pIycO9KQ09eVkzFvCFWb1h3i+iGp16WX9GjaRHluDSsAv/8UraYPf04LIuaZz2FRRmB2evflCqwv6qYpenQRTKI8Q1z8fI7iW9nvReAn1frsuCtOqf8vPOnnaIHKuUUnl61wPPQpOuss87GTtxFd5LlLhhDqGyKLgdZEuDlTe7xoqSGBYuziI0rryUqyCoBo+sUNqF45FMq85FCSNWUfVl/zd7tw4LaZbHzWIjlwzzLmZP/a3fntmlFIiNRFaipxzbLxuXVaA7QH7QTat53u1i+Ymfs4I1caAvmgDsN7P2zYUg4dH72SGstvjE9UYrIV47WEhia18ZTCgCsUtTmdokKOgL7rZ1SM/BM2zzkChLUyyq/eB5d2mJonzENQ6hi1SzpZmlVS
 p2dEsXzL
 em+FCzETSq0Ok50Uwv9/uo3jmtHA8rU0XgRm6VvqgYUV3mv86T4wurFPbAMH54FOXo5FdbO6i2RWVJJgtzJ91D3sJYAgVFKC26s2s18y2D1E92ksQNiLpoLJEC6P6tU+jQSLQXAX6szmo0+oiLFYh6zXo/7S14Yr/2g3i3D/xSA4sw+XfWMkxhSx84u8d/uBX3efe2okr/1Gnq2JJLa2qz4jdODU9bfBrMIO9MSFSC4wx9K+sRYVNpu/W1lW9tbcG1xt0tMS/cJ/fnUcmtuuEo2zEIkWteo8ApteHu/E27aa22llaDtFhOTynZmX/M8lExz1BXzL1H7Au9HGqvbtlObQE2otA5dimqwbajupzc866D9EHwrIxPPOoRhWzWCxp09toj+rOV+f0UWdGHqdCi9PBXglhb3iKRCyb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 19:07:09 +0000 Shivank Garg <shivankg@amd.com> wrote:

> These flags only track folio-specific state during migration and are
> not used for movable_ops pages. Rename the enum values and the
> old_page_state variable to match.

eek, sorry, I have a finger in the dike, trying to slow things right
down now.  I'll set this aside for consideration after 7.1-rc1.

