Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55CC1111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EDCF6B0088; Wed,  1 Apr 2026 20:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5956B0089; Wed,  1 Apr 2026 20:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602506B008A; Wed,  1 Apr 2026 20:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51C366B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:44:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8AF7138AD2
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:44:44 +0000 (UTC)
X-FDA: 84611770488.19.164DADE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D00540013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:44:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="HA/tmooA";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775090683; a=rsa-sha256;
	cv=none;
	b=WrEvmYBES+wERzcv+DiiNEuyktoJefUkUZbuYEWgu4v4mBV5ZO0HIKGj6dWmMWB3KqrRGQ
	Z2DVscGYNm1MyqwuNK9PnVoQ6yz6gI+FkffyljIkVmSdvhvCbk8iOjDy94/LyEP2XEbyl7
	1ZbxkgvBOcQeSOPb6KWbKXyD326h4Uo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="HA/tmooA";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775090683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpsDEXFH/nbYE3mLYV7MGdHednQHkWrQOz7IdePyYfw=;
	b=Twqu+hRKRd3bZV+Id29HcAN0xKPgbKCumXYl56/ig55q3FG6DuHzNVmbsowYXcCwYKRQQi
	iz8oXyrqR1wASqdAvRnObjJQpCEr5yJdX9c7vnjErWAifrCmJR0iyEFuqLonDVHR+SCgyB
	jlmxnJdP/Tiw2UY2wgq1L+1ooGSP108=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13ED443660;
	Thu,  2 Apr 2026 00:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD0EC4CEF7;
	Thu,  2 Apr 2026 00:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775090681;
	bh=GnHscPrNJRppDEXonawDI1TlSlpSxWRDtvMK8mVhTkg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HA/tmooAm7H0WnStcyUYwNwCrxEXDDjkCXD8RRMBEBxkJmTWFMu9+AXrRydUGHzU1
	 DSdPbQJ0TMVDvsj4SHJBuCZvEOLxbj4HNdamPG5v9/aOnwqxKrwRph4/HY1P7xSSkm
	 dfY8bLps097wtInJHSQhc/5nmZ67k9zwObuphCTg=
Date: Wed, 1 Apr 2026 17:44:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
 Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not
 supported
Message-Id: <20260401174440.0f85ea303f0a027b50d99e5d@linux-foundation.org>
In-Reply-To: <20260402003417.438037-2-anthony.yznaga@oracle.com>
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
	<20260402003417.438037-2-anthony.yznaga@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6j3ciowy55e3me7oeaggkrun9xaqsbtj
X-Rspamd-Queue-Id: 3D00540013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775090683-162951
X-HE-Meta: U2FsdGVkX18+q6qsWNWBR9r9pJUS8ZRx1f2SD96KOtwMyMZojySP1hKQCvZgETJ5Aa/ZJdj5htortwC3qrMCafAIPjea307J6dgf/QAOw20D9DP9U+ZIozHU6gPRsNpQbha9vnff1rKsT81RmTwgtYHUB60MXpc3eYSIBokXigDRBGcLYi3X7gqBJfSuPCxWaKusdqb7yjl7hGjoD397X1APAKwq0I/0WOxxFnXun5E49mZLfr1TxzhxPe5APCHWd3P/nkIMGlShzKZEE4FE9j6HzoOJ09ej5phKv1uVSgNIiBdNUMWxWrTINX4Ep550dZsTgTfzAosdNksPsPuOJ9meQtNyG01o9r098WTV8IMNV2GxYGsnT7Lwa08ACqfb8WwcgrYOZ2lvuUYQrW4ZxpS7hpuK1cO/rMm2goEUDnfRbrLuOWSPk6m9vTouMa5navn/M9Qhwt477FaJfuDdlGfNPWNPJYtO5uaw2Ml3DKKhgtdWD/T3Kb6doF7vWUuzF8MV4w8rGX6RO0YBrGKgP58erJX5BYmGw61yf7icofNA8yRJ2TknGmqOmRQJWEoQiaCDCkYLiGBDGcWjnLWQuA2BQ4uLeO4HQQ8ch6BNq7mGG1CHmsCDyZJKCyWT2i59cbI1OA4L1lDvYYicCjztCR+MNF6M5RS56SbTSV9bYmBH4FROdZRz/tC9K1dhApnmGR89f4pFb6T3yQTeKGVOpaGrfRXwKr1UB4rBFSdAqh7QTpR3z1oS+FBN7uv1Q3hYkSXOSNvT9s6oUrtaq6XYUKp0knmeDjrnlR8ca20b6oFRmYfECWVQtLwNobx9/R8+GJoR5d2DRtwpH0dEqU9m7hDN7m5Z0caSXKgGFiTwitHpbrOoeicLW5UzOQnQdSUVfwb5AE8zNeA2bZx+YKz+WT2fXeX5JV0DUVvgmTEbzcRirRHtOI2Wk9O1/TcRA3q7oXLldJSCLbSJji2KWxT
 Gv2aPiW5
 gKZdZXzOmNmP5tFRN32eiQVNFwYElttp0gNksJWBSbTUOTBN391G/VUs8agdmB4bQd4+SHObwtPosOw0bUMwHVYIx/rL55rUWP/e9KEJpbv38TDcZSycQFw/1t+GvTGw0dmcKGAM5JX70cdy9Lxe8hyd3BxQdgOfzTFZ/3L7FtIs/wNQn1pDBlMAV+qBdLKA6qBfZ9bvNWsYOtW+br71/kyJMer8Jy8xHfe0IEwS8q5oA+zA0/MFSUadM1hpGCgtVvngXG8LhGAqodIuUbFOOCA83Nv28Pu+/smKdzDfnk2ZMqMFfibqNCIpK593g5vWYSuLk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 17:34:16 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:

> On configs where MAP_DROPPABLE is not supported (currently any 32-bit
> config except for PPC32), mmap fails with errno set to ENOTSUPP.
> However, ENOTSUPP is not a standard error value that userspace knows
> about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
> checkpatch.pl has a warning to this affect.

Sounds very reasonable.

EOPNOTSUPP is clearly a networking thing so what on earth is it doing
coming out of mmap code?  Our poor operator is now looking at a networking
error code and wondering what this supposedly non-networking
application is up to.

But just that's a pet peeve - I lost that one decades ago.

> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")

Nearly two years ago so I think I'll add this to mm-unstable for
7.1-rc1 and shall let it trickle back a little more slowly than might a
7.0-rcX hotfix.



