Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D59103E17A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C005E6B0258; Wed, 18 Mar 2026 10:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1146B025A; Wed, 18 Mar 2026 10:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEEC86B025B; Wed, 18 Mar 2026 10:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08FF6B0258
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:31:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 697EEC27BB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:31:03 +0000 (UTC)
X-FDA: 84559420806.02.DE5FCFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B62ED180002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:31:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKoq9NcN;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773844261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKwk9/qfbHQpJTsiF897dA1H+eexQrENLCO90wgvoME=;
	b=3X+j19MnWi+CTmWKaDMtih2Qqn791NPkEz6sp1kSTG1Xua5WMcAQhZ0pzN/r42gsIYha2U
	rknhUQ04U9ry2lI70aug/BCtFBfOG6piIB5L3CkbH1U7cwQtCPViyFemA87h4yQP8ToM/A
	nGVFuc5gPvbfy+z2x3T14oiB84e28Ps=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKoq9NcN;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773844261; a=rsa-sha256;
	cv=none;
	b=Wd994JPRi1u5HuNBRS2wCPK1qjG9w25/0695RHTS9hlsRwrLPES2rivtSWacpriCqWHQQ7
	CeCr4Dzr/uS/I56rKwd/GoD79DZnbfpgqU4FeF/3pnfOXdoY4dbWg6vU0VQ0nid22Mdqfz
	lcco7NDiqDilWYmZvX7pn2ym6nhw+OA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCBA641899;
	Wed, 18 Mar 2026 14:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93713C19421;
	Wed, 18 Mar 2026 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773844260;
	bh=vDmi4D9iGjVbOJZ7zVFCLFrvInUmkCXAJtsumdbDJsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GKoq9NcN0VzvpFAjtGIslmMleSCRgUwLPdAR4RiGMuwe+gDcnSuO6cnG/CWbbqB8I
	 7iwLZq6N35puxGe7fUhTqSOVvR8RkcgHQA2YvgQKxk6Kf+Qd5smx6zQ+PwKSk8kY43
	 eARrDdfRVkb+qiBckbqTiThWNkRWLfsiTD9ScZbHmPZqn64WymnL+Pfsj9B7GTAuae
	 +qM+R3qvqG8YzPK/ErDQwHRdSQ7q11w5RAstRdh1mEGZ32T3/AN52CvE5AH0gJKhjr
	 jATH0TP0W/QJs1sYdyus4fgivwmRbam5BDfIAO2Qy1+2hiDmTF7wgaQLq49y+3LQF5
	 0rGH/qXdOlFdQ==
Date: Wed, 18 Mar 2026 16:30:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hubert Mazur <hmazur@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Stanislaw Kardach <skardach@google.com>,
	Michal Krawczyk <mikrawczyk@google.com>,
	Slawomir Rosek <srosek@google.com>,
	Lukasz Majczak <lmajczak@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Encapsulate the populate and alloc as one atomic
Message-ID: <abq3HenO8f1c0WBS@kernel.org>
References: <20260317125020.1293472-1-hmazur@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317125020.1293472-1-hmazur@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B62ED180002
X-Rspamd-Server: rspam08
X-Stat-Signature: 69opgsoqq4x8u84f7xeuznkwxhy3upyi
X-HE-Tag: 1773844261-971898
X-HE-Meta: U2FsdGVkX182gIMhQV/0h6UUg6ppqoNmLr1/QDpKDjliO5YMNDsnycSV2K3FZgehkVNI9XKi/3vA2qRp31bOIxtKVPjzoelsDXneSvGIf9ve4a+3F3kywaimWiN1/jnXtLr8ho81U2cCKx/2/S0KQyaoN2pDKTXQVR82zvfQQwObAxl2VmnodAlmvOwaWZehRurwD2dYsc5DoMn6E3xJwnwx67nqxjkHLGhbCbsOcdrDqxdkGvbFT2Sg+DhCqEUK/trl/xGnX0tylllzxJwKzF3FQc2WMkUCHP9E1Ye2sUJodtQSChO9mYjsjR3pP/u3aW7D4jmOgxX0qQxUNyDF9t3TUQdFYcfpyYVW9bb0TBb6eylIS/IpdrCbty8YmUPGVgQyG1xNV8JtW5X3brSuzHcUZNqNwYi41+Hb9djndziC22fjtZE4VBG/HvPenXkBvNlBKCeofj8b6IRHPAWDWKvJAy1ptDkO/QmUGKhHtN5A50tX8bqN6sMgOAcC4sZDWowjR6PPsCBUDCk90pJeSSW6qIZvbHPHg21rIZOw2flinigj2Vd+1T7xPsioxHzXBRsD4KjFxOSGFv3yowyf6AJlm7j4fYIVOOMhpVvrJSzE9H+WHZQI14FaztngF56iUVJjcH9HtsBiMOg3pqhm62cQEP/OiuaARWcTN5JOeC7ik9GnJpRY5E6E67hWWTkI9ZCMWjaHWviRltTs0H2Qex/yKseY78bed9G+wPSI+71LS1Qobz2JnocFb3dt7hYm2pX6wE3QyFQLI5//9ncHqa5dS9IkmjbfvMct3y4ziZ2zPbLxsOlHl8O9XDf9geiQANEgioZHyJfKkXqff7ugi8HkY9ipOOS4Ka87rcfOB7LBGFE8GBK+m0gOSZ5alJEvenwaszXZF3q6x5CTywSeB4d0eHIMp5Q8qzXgQjUBFbivmq/m2kH1Amfnd7u10w6VfQRLtjPNsglSrSSmrLY
 AmaP3MqJ
 3nXAatNH6/L2ba76jnJ/Vlo1oNpVESei0rNUszV1J6w+9y9AG9pzmOaG7a3fDaEn9xa0+78SMOx6AL44Bu/Fp9tcBMOMuMxYUbckDgLA8Pmn3w4sqi89OXNn04sRmLAwAqai5AtIIB0dd2hgO77mQ96f9B+AKzcqcuW1lvU7QV5ok/YITZ37PXgJutp9LgA83xCv9lPKqNgbpBYMwfOUKYpUXtzc3RURSypJaKCyXCLBcNUQOW/G22UaIxZtMlswDj1a/41xgG1fi1DzaodXvPPGEs+TLP7YQQM2emSvVPQAZ9O57v6SEeZRkjNvb9CtyuSbJlMxBDnbRjgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hubert,

On Tue, Mar 17, 2026 at 12:50:19PM +0000, Hubert Mazur wrote:
> Hello,
> thanks for the review of the v1 patchset. I tried to make v2 diff as
> small as possible and without a modification of the core logic.
> 
> When a block of memory is requested from the execmem manager the
> free_areas tree is traversed to find area of given size. If it is not
> found then a new fragment, aligned to a PAGE_SIZE, is allocated and
> added to free_areas. Afterwards, the free_areas tree is being traversed
> again to fullfil the request.
> 
> The above operations of allocation and tree traversal are not atomic
> hence another request may consume this newly allocated memory
> block dedicated to the original request. As a result - the first
> request fails to get the memory. Such occurence can be spotted on
> evices running the 6.18 kernel during the paralell modules loading.

typo: devices

In general, a single patch does not require cover letter, but the details
about why the patch is needed should be a part of the commit message.
 
> Regards
> Hubert
> 
> Changes in v2:
> The __execmem_cache_alloc_locked function (lockless version of
> __execmem_cache_alloc) is introduced and called after
> execmem_cache_add_locked from the __execmem_cache_populate_alloc
> function (renamed from execmem_cache_populate). Both calls are
> guarded now with a single mutex.
> 
> Changes in v1:
> Allocate new memory fragment and assign it directly to the busy_areas
> inside execmem_cache_populate function.
> 
> Link to v1:
> https://lore.kernel.org/all/20260312131438.361746-1-hmazur@google.com/T/#t
> 
> Hubert Mazur (1):
>   mm/execmem: Make the populate and alloc atomic
> 
>  mm/execmem.c | 61 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 34 insertions(+), 27 deletions(-)
> 
> --
> 2.53.0.851.ga537e3e6e9-goog
> 

-- 
Sincerely yours,
Mike.

