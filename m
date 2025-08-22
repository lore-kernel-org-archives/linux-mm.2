Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E24DCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 05:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0486B015E; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CD26B0160; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43686B0161; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2D56B015E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:54:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43B2283BE6
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:54:44 +0000 (UTC)
X-FDA: 83803329288.25.B4452A7
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id A82C140007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:54:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=QQOgfpAj;
	spf=pass (imf07.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755842082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcLze6kbolgzoPiY7cjF2F70M12vK9bK55NO9ofqS9Q=;
	b=rzkyHo5vbRROIGFUwsqgzuIxnzU/yjAqLP5TC+47lsConoPm5cpljwKOo2YVIOyUVUYeFP
	KWOatY5st2v/sMX2RzBgEwtSe7Mm9/powomjjfEeXB/SJ+EMgzdsc7QGsvuo17ZkV1pOKs
	Uk1aYct9Nqtg2dRBoN3aZWhwy4Urph0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=QQOgfpAj;
	spf=pass (imf07.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755842082; a=rsa-sha256;
	cv=none;
	b=ETJg4/n8rb1y5qlmn08dbSPLzyYI4Q4n1f2LkPl1oB4ZkBHRKPVMsf3sYvW3vPSO+3Fivi
	CQwKZnMwZoK4796dC+vCSLsHhoAWtbfzgnTXr4Q+zehO212uNgzCVSDYsX6Lvtgp73oUNj
	Z92fTH0EavQGGCY6dvFROZazgWEaqnA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KcLze6kbolgzoPiY7cjF2F70M12vK9bK55NO9ofqS9Q=; b=QQOgfpAjSJBXGftp6CPTQjy8a1
	ljXDYeTVyG36NEVo7P6kKyyJuVwRZTSg2F2GJHapWL0hANvy02upYtz4GDyDn2XLjZ7jcdp0bxTed
	LLvNQ7qIU/UNBKFZ8szLq351UibenvNrNmUvOPeZU7OfO5mKnjPcfCtROJPJpG1fBLqknOMzsTwBM
	/Afko595hAEeRXtFs9+kZzm+GkU6r4uhPh4b6cL3N+01b/w9tyEyAFjHIzJedG2XanAeOFd/2mFFA
	SPE/CkwMdAwDNf8pJ612t4SXRSQjg9FPkfJN1JSmO4qcRwR1f2gWCzqAGDMn93Rl/z/BL2gHnpSuR
	EvJrYrXA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1upKTa-00GJV4-0O;
	Fri, 22 Aug 2025 13:54:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Aug 2025 13:54:06 +0800
Date: Fri, 22 Aug 2025 13:54:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Barry Song <21cnbao@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <aKgF_uJT99rBiyDd@gondor.apana.org.au>
References: <CAF8kJuM++mc5PjcN_bxjZjbByT7QpVdOqRQte=vGJnuQxSTVfw@mail.gmail.com>
 <20250821213630.1771-1-sj@kernel.org>
 <CAGsJ_4xLKVM+1LqKzbwjd0vB_OYnb2E-h-Wb_C2bBxiSdU=3WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4xLKVM+1LqKzbwjd0vB_OYnb2E-h-Wb_C2bBxiSdU=3WA@mail.gmail.com>
X-Stat-Signature: 1meyp85mmsweii1w3mp8ixphd5o1mmi9
X-Rspam-User: 
X-Rspamd-Queue-Id: A82C140007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755842081-17820
X-HE-Meta: U2FsdGVkX18tg7lF8lWBn9MwwL35lfg38HyaIqKfZVcFxoZyenxZGweptdL8LiE3rtc5ozjD+/agSgQ+Q8OL34f7E6g5U8Nbjw2wMbUFeUi6AACotnXO+QD9WmF5H/8Tmk1jrpcJ9jDiTV1gFRLdsugsQTuGi/tyT9mwqZD5fMw2ejPNXN5nQmwp4s6b/Exfh/mpbZL/x7FNLF0E6qrv9tTwXxQrJsl7xflKFV31UupvMa23SWpxUaTkfljTX97CkHWjfhzJmqENCYhImrPfQ3zTZZv+fa8l8qwxMuGzyqoTglioNwB1bNt01PMHxO0mjMSBemmHI52q3GmDRIT4RLddNG0coJuZfyWUFGo5gRJ6W5p8bu4osFNuSOTVP+hoY/C2++0J+8RwTpNWRtLwpwrwTjFtk/xGYPfh3hmOl69snxLt2zlfuckoct2Mi7jGEH/u0P7erMQKxN8k+j66QFZtyuMQpkEpTuzCx+cXooCju//hmAYk++XN7ighL+boV5tYVXcoiN+OPGfTIE0c3+jSoUt6qa22v/tRnnDvUr3wl/qdkW2JPMU5ASZO1FTU0Or36hMPXChLuYUIpLpe957XITHC5fkD0zt2d79cB8Wx5sMci5RVnIGHyHohqJMkEJaBqTv1gvMQMiF0V8t125a1CjGKags4kFA121MDo31R22DxmANwLGQ/EL3uI43l4tbS331fhoB/9P8gQ1ifQW7YF/bZP53jqTo8P/BJBuaHCZIFtbkownR8Ce+0Ec8u7Y4BlxLP7h7Wk9oiqmdNGuj69XjW2wKLjbqDfZYV6rhqvSZd4d2daSyeAlXRh+wMweVM9bM67QbD2/T6+2OSjV6CtrTE086OhmXEamsGBv+XPSXo3+zqNcO1XrxhmVo/UZfUYn4pX5UCMVu/N/xfd/Q1hN1IJul60mZdSYHxWLqGax1uHbwGNvCkqya3rIg9/dJTVmgqt9zJzUY++T6
 Jce6HzgT
 KnlPN4HIfCfZhdbW2jiOGiGBC0Z92vDK8HZmvuszVEH01b1hqQdpiZ7ueE+8v4gA6ePWT2ICGwt5rawnvnXASjycQKionehOUiLZ+TswWsjO8zxHRb4mykbqyHzkRsNMb1uorn70UJrX7532Y57SXYXVExmcRrgHsG7yjAjfv/4zpqMLBs56dPKHVVMOo0zQPCAaVOacmGJs/GOZmbEZe/xOmvNryJK6j+mda7+lsLIfVfHCpWfbPtVXwoRs1UYt7R9z6CdI+JMNOj+EFxs02EUSuNrqm/ZukUCRulGsLOOhu5x105oLDX7JaHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:48:27PM +1200, Barry Song wrote:
>
> Is it even possible for crypto_wait_req() to return -EINPROGRESS, since
> crypto_req_done() will not call complete(&wait->completion) in that case at
> all?

Of course crypto_wait_req cannot return -EINPROGRESS.  However,
I was responding to a request to make the crypto_acomp_compress
call return a boolean instead of an error code.  That is not
possible because it has to be able to return -EINPROGRESS.

Nor is it possible to change crypto_wait_req to be boolean since
other Crypto API operations (including decompression) can indeed
fail.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

