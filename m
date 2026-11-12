Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01906606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=NXiLHoKt
Received: by kanga.kvack.org (Postfix)
	id 0136B6B05B0; Thu, 12 Nov 2026 10:00:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05ED6B05B1; Thu, 12 Nov 2026 10:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4FE6B05B3; Thu, 12 Nov 2026 10:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B416A6B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:00:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC704A8225
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:59:58 +0000 (UTC)
X-FDA: 85426776876.27.BD2DAC1
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00F89C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:59:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=NXiLHoKt;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf10.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46aJ+NZelMiSr8EhCGm9t3xZEQJS5co1bb36uQP2WSw=;
	b=JmI+Jv8omz6t60w+7AXg/rSdZRBbl4wJu+Oa9Vt3n1L0qek+dQcRkRycjgqSDEH9VbSbuB
	ycwXxUfYaahvp43JMRRxERWPFIaWN+FBfTjqOWyoQ+PZSVjjhsaob2FTdl4FPYSmiPkjSy
	zNrAlYE9oF6PwTXSX6FuYf5UMZP3MFo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=NXiLHoKt;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf10.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495597;
	b=j14A5deu2VB9GhetJXc/10/LvFZ0g8ixcuEDj8ip/a2lVEPNt39HoIL8YdXhmvEohhiRvo
	9GjJTdBYGw+/ta/zNjZL0Zvt6WDTyoX66ozQV8CcBk9Eu5Qn6gq7hiJ3+eps76KE3ojKX+
	wb63JWdLO8LXZ+yagMHm5D+v2XE5A+8=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 11E5B41099
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1794495594; bh=46aJ+NZelMiSr8EhCGm9t3xZEQJS5co1bb36uQP2WSw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NXiLHoKtFO2RgHx7eYlhrXUtXMV5x5VNuCRyC6gAdstMKcNRxFsLQQn19fUFgroDk
	 QmkyyQnlu6xdG1SudH0IHLgz9yHS4NfRTRGPcd3gMN9o3GS8t7du3Ds4dhNlJEuTic
	 SZNZzeU7Qtgr3L+ngVufeLJjterSxycCFcEDM8J4xVjct4qu8NpBjKK6o/GuSqSgy9
	 NA42OWDMxNYmD/d3vbTXAC6ccmySFCXuhZg0kcDvgtxl3rZGTr2W5MKR85iMrcLr8U
	 QP6sZgXUYEDrMccS4M1wB2rxEDah4ibJCdIunLXCJPsy82kTXwwjWs7R6RLzYqY340
	 VRCUuXHjk23HQ==
Received: from localhost (unknown [151.38.237.230])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 11E5B41099;
	Thu, 12 Nov 2026 14:59:53 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Bagas Sanjaya
 <bagasdotme@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Docs: mmap_prepare: don't italicize structs
In-Reply-To: <20261102175619.2274135-1-rdunlap@infradead.org>
References: <20261102175619.2274135-1-rdunlap@infradead.org>
Date: Thu, 12 Nov 2026 07:59:50 -0700
Message-ID: <87zeve5c49.fsf@trenco.lwn.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00F89C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u4jfb5oc3x3t1x1b575n8pnm3o6rc1ge
X-HE-Tag: 1794495596-726012
X-HE-Meta: U2FsdGVkX1/hC89QVuqcMs3WvZzAdc5+2T9+4bm2epY3/oWV/6PYgGt8YwYoBb20lTt2+DJpoACdhaOCY3IPybIY9180pwd48s834rMD1yPhqeRuFrqccuDfLq4bJWjm4ESXHE4DaKCuAADn1FUtFnkKGn+m6hqvTiJ6yvM6m+rktpZt1ngDXygAq0z+mM9l4lAn9iRMKYsZWreHHu+3iaIPQfv8lAUWLz7kIxsRu/8Jqe9KzbYt5X8v95PDH99X2kqsiNa7kPV0dpurS1H5RoqnI3xI3ODuLJIOy9Yi4AYbptp0nOhofYf2PEDDS4Swker14PrCmtRyeIwRaJOw0DZQmIsRhnnmZVDIn72Jo4526cyZh0SLTJgNcMvp35HAfOlMYhnWqgGf2k4bh4XN5tWT7I9EaEpXwBzlxg3UElX3sQc8g8NGWLLYOuOjXgTzO/UOhNY6DTae6FSXd6j4JJQIsJPLhFDr8Fe1r/hYrArZgIWLFzsG1kKFhk7m+vWhbmfHAA91hi5clod1vg1L17wOyD/CLpm3dfNEKjHG4ANoW09hwKRXMvfInITKj8N8UJjbPCs8rMTPufPV4sTpdLT2U9F2lrov4wDuBDzvpehNT8/YcG5vwELw2l5RuGXvhBaHCnLQbhpImgBa8e9uWTon7obaBu58KCfqflIpPMPbzbEviq0SHnfqjU1MLUNUghL8FbK68B9WY7mRlISJPq4YbW1Mbt8NQYl3MJbgpn0spWtwaCxZhAm9i/xGNF/U7gk6q5kYdCu36/4v5U9T9zRdXASiYJqFzNJs13B7Pf0OBbRKwj1yvqD0WH2y+gYbeqslSLP/IhNuM6MsgrDycYGQFYUsaSNUA4cnyYZaCU7PAQEeAlwD4dZCB/IM9Jyp0pAevNHz0TbQqYGphQBECq8xBgNZSFcZ5cKHzm6jkDbrW8lcVFDiuro/eSobrGOSBqpwSCsAEjYqHqmlGz8
 o5aUp+L2
 V7sFTCRN7gm68w/QStMC3OeN0nmsm4C9EVNfPAjgyw8kjXK4Q2bFj96XRsSX15TrHzR0xbMuUC9+qIqSGM112nVnMRjuCyu+FvWsH1HDyx1OGBcpXr7nPWS7a9H6IcB5UWJz7gMts5K8jQy2yUn9XgpJ0b07tmjceaZtfpVLv+lMxTddhzkf1DE6utYqbnUKTIGx0YlnICeNlMQ7VHiGCw+uPh0qzWIPvvwBH3I2gQqQuitwhhnF61hdyDCStQq6XNSHAGzu/hRxvfd/mEQMEff7ai4HqCyZDmXHGT76ZUzQZ3X44DO63VWItmQxV1Fb5CnyuISeFarKoTCTgb83cz8foRla/Q/cNuG/QXnDoyNrtC528pJRGIv5zaBCurdkhf4VHyxMZ9grzhog2H50WhlbYk7YQniF/BtnGlBCTHBS9hKqwY3XQbMZs9cd76DIfzYY+OGJQaM9Q9UKSYaUpMBskJtqQQJr6jBZtaGTKkiaaOENcdUtPKHDRs77ny0RE89yz00rCetlozh9/i1a82A5mp68qGngBmE/5LOyRKGvjyMxjZc2SWkKk30SrJ71okaxyIBEi3BVcHYZ1Cgt//S2p604P1EmrfqdMPDUeEvqHWc6G/HEWKKtQTcapbXo/AYek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Randy Dunlap <rdunlap@infradead.org> writes:

> Using a single quote mark `struct xyz` causes the html output to be
> produced as italic. Omit the quote marks so that kernel-doc's automarkup
> can make the "struct xyz" bold monospace ("code" style") in the
> generated html.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
> v2: fix one more instance of unneeded single quotes
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
>
>  Documentation/filesystems/mmap_prepare.rst |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

jon

