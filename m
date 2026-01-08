Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 564BBD1D486
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 18:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69B46B0099; Thu,  8 Jan 2026 13:52:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12B06B009D; Thu,  8 Jan 2026 13:52:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93FCD6B009E; Thu,  8 Jan 2026 13:52:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82C2E6B0099
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:52:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BD83C1652
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:52:24 +0000 (UTC)
X-FDA: 84309692208.09.52C1A07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 701724000D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:52:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GBwQbpPB;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767898342; a=rsa-sha256;
	cv=none;
	b=IDffwDOK+wpHbSMj/EZzLKp5XxZjSpTQFJ+RZmh2mj2y0YhXIftoAPDq29D1gTuJSgqMaR
	GO1uuAnuWfLf/ioWmGjO/ygXwvdmXTs/3wJphSgNOzBgvNcx0mBIr1TZBOTMsuXnU3n05U
	FQG5O74PpG22+Th78CHnTlghaZSNk9k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GBwQbpPB;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767898342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEmWYMVV9fNanjCerE2yD4L+98DFWLQ3j02n+rpZ1cM=;
	b=rrD0S9zlFnoGPejq0XosObjOkgxd0En7fvhoc+tRfjyr3tjVHWr+3xseMwAui/UvUVPZLC
	0RAR3OJPs0I57+1PV6V7C8mQPGqKbZkcsFKK1ql+LpUTeMU+HlnEvg74VsW/QUOprgSG6D
	8OAGNRcF1WYEXR/EBPsLnN0YA5Euvog=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 611DC438A6;
	Thu,  8 Jan 2026 18:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CA4C116C6;
	Thu,  8 Jan 2026 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767898341;
	bh=ZbnEvXp230pXI+qi4LXHb5ZKDnBaAbPPpmp2Xla/2Kw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GBwQbpPBHE363Hu4kpwBMRk2S1B3tNuG/W07vha5i92yuHuGxNlwkZqFcanZsmd7p
	 vtGLn7vXeOEqZP4kEk64akcXlTEqIx0bCSy88wPmbgls3lw8vE3qFbE9zv+rTofFj3
	 wSESXPWStMGB0k3oNO90XCZMpKe5Z3EhtDfzPmlk=
Date: Thu, 8 Jan 2026 10:52:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@vger.kernel.or, linux-mm@kvack.org, rppt@kernel.org
Subject: Re: [PATCH] mm: numa,memblock: include <asm/numa.h> for
 'numa_nodes_parsed'
Message-Id: <20260108105220.f1577b1c1709319e83760699@linux-foundation.org>
In-Reply-To: <20260108101539.229192-1-ben.dooks@codethink.co.uk>
References: <20260108101539.229192-1-ben.dooks@codethink.co.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9th997f54hi9espd8ctwxhykhd86chkh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 701724000D
X-HE-Tag: 1767898342-668707
X-HE-Meta: U2FsdGVkX1/tVRf0WClDvIa+BnK2pGewL8CE6ktIMKdg4humJeJYHdUcKrIL2bx66Ts+LVjQU28PerpuRqqqYS2OtrIsB0P2zoS44Agow4yzVc4GY7YhjM0naqOpDS3YzAZFvimmwYDJmXVLp6HjYgkmAVjL9IX+wlAqU4Imivfk+ivvw9SRrTHvKXsoj1srRp09N/v0oy/ZwZvlR9MDNwURv7a8rP3zf4B824w++Lqo0creWOA6EGrki7ckPGQwU9ZpjPqnMRGkeJByIxSLAbzD5m7+J+8nV5bONdA/cNmhL+ra4rZJeUClhRzyMcyKHXVo8qQ3mYK8Yl2F9fCaqKSJVODP+6AmWvqZpHvYchUaTPYGlqzmZETTWwn1PaLthuA0AiixsyB3pbewVMalHxEvKzHPvYoruhCm+2VfGOC3lw+4o+FJpkG5ADynvSMRYWhOfSYIt4b7kD0gFksq+0oSJitOCDNreQtfP0FuNnQPtfT1U5NhFbzeYr/+3y6zqJKXLsdgXqWS50o4sqfzWwpPU/fZHuS3IsCb2DYkHM/v9rMGuRjokpLi5N6F8sxCUS9zZbyYEyu3vYHm7Z8aKYlR0E+Hliloc9pzCbK1NhwRsrR25lxIw5Twtv7smviLiiPIbTdKB/ex/4hz4kHiY49D9LBCA6OOheWUiF7TuF8exdurpgekcINTi9d1CQtGjgpt7cJscEmf7qA/bBQ9rHuWNluGCIPl7Mn9cKkHB3SwLrpJornoV73/BEihh+qjukb+7UlRGhzU3OqW4yWicnkS6WVDiDLwXEADu7j8wkuDTpspXiqI39oSuLdoKo1axKG26Qfsa1yy2AANYl7FHwyWkJvkfPyPlPXpOB/1BJ7cnXwstyyy4cmOYv5SibRAgYlPhbnRgZnN5wyMWa5LWBi8OE/PR+Ze5EifkL+tI6pdkA9zq1eqU3RW40o/K7o2/nxlya+FXOgKH0D9LgL
 TA9ikB+Z
 qFMSR/00KhJnPVelAlCykudMjkMoKmleVnrOxmq00pNurajQCxgs3g5GmVCNC0WsndbUr11ue2GVnDeD3A1K4suTT2kFL0NMxjREGBqBLL6GPblky479KW9mhOIlAT/bl19DA9hwQD7y30lPqZooV1d+26iphrC2cCUy/xuF0CeXOu92egSxQNIWuqdVnM/a0WwJFMpOLIpGpr5Um2u88OGoFysawoBK70D/0KydT9+pfZZUIrPcCasaaPYEcZzDBYzeuKqkYmWQU1jLEzxxgkX/0wSfcdOS/IjNIpqUG+v6wwk5St4N4lsPUOL55nqN39Mjon65Pgabx5pCcfWKYKAEvgMi2OyvGeMlV7ToY/TMK570kxAgTSSiHgWL//YRCcIPz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  8 Jan 2026 10:15:39 +0000 Ben Dooks <ben.dooks@codethink.co.uk> wrote:

> The 'numa_nodes_parsed' is defined in <asm/numa.h> but this file
> is not included in mm/numa_memblks.c (build x86_64) so add this
> to the incldues to fix the following sparse warning:
> 
> mm/numa_memblks.c:13:12: warning: symbol 'numa_nodes_parsed' was not declared. Should it be static?
> 

huh, I wonder how that snuck through and survived more than a
year.  

Thanks, I'll add

Fixes: 87482708210f ("mm: introduce numa_memblks")
Cc: <stable@vger.kernel.org>

