Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC33C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D576B0092; Thu, 27 Aug 2026 10:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4BA6B0095; Thu, 27 Aug 2026 10:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBF86B0096; Thu, 27 Aug 2026 10:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 645256B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:16:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1326120458
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:16:26 +0000 (UTC)
X-FDA: 85147249572.17.FF5DA15
Received: from mta0.migadu.com (out-76.mta0.migadu.com [91.218.175.76])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1DC640004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:16:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bs/hN+4e";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787840185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3agJakQFT8jxNnlDSctVme314UxaFyu7Rpb/cXtCvKw=;
	b=Q4T6rM7JLJU4C78BD4Lbo98Z7svYbh3b0nsOVz+PhLe8wij8YHCJ5veKlN9j2iA201wWs+
	Lj0e94GkFT9umxb07CKlrWHal/kUbK5yuwK4BDIalZksuutfRxfDNCxWi9dMakMSFihH2j
	lP5ksHKB0lO2lFbhYyRYII9+IOK4/fQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787840185;
	b=EKw2JcE31ZkcDWhcDzV4BlgAlKv1sR8YPuZqjDU2vNZHNPF8LxwDbIYdRgl2g9EkCkfUiC
	EnddiLntlcjhAjMMjuuILpy+Bji0LP51RPM99y2ZRkimRmZSrFnxTrudF2NapA4cW/ceaw
	aXIG5MD5SXwiZ3NAu2n3/aaJ7k8Cbog=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bs/hN+4e";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TeY0K3rD+OSLUPSkBl4m0A05+bMcDxn+Od6P8j6lCUI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787840183; v=1; x=1788444983;
 b=bs/hN+4ecLChxc8+pCEohy4JkP1yasCeDfIM1wVPPaxxU9nirCKteMUPcADPBehlvt5aNMLT
 soOL2oXkLd2dxFSr+bjsE1IheeXjRFw21tFXXGU+gmTs2y6XBujP4fH8RUWZNLwifejiAFG2+n3
 cK3jm4dDlrVZClt6zH9bKG30=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 52c19e7ae802778d;
	Thu, 27 Aug 2026 14:16:23 +0000
X-Mizu-Trace-ID: 52c19e7ae802778d
X-Migadu-Flow: FLOW_OUT
Message-ID: <1eda0282-f4b8-4914-a4fb-733d775d563f@linux.dev>
Date: Thu, 27 Aug 2026 15:16:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add myself as a THP reviewer
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260827103435.1371882-1-kas@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260827103435.1371882-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E1DC640004
X-Stat-Signature: shnc3zxh83ejqgjgoy438588gg7d1x1j
X-Rspam-User: 
X-HE-Tag: 1787840184-949499
X-HE-Meta: U2FsdGVkX1/OCpo24dJ2oSpS+ZwcLXMp3tJCHMghoBOQ13alUB219NOcDYAIp71TB/SKevVFtMLXO4VOG5Cn1xdloMJU9uFUlSyOMHCQsDCKYznQ6Cd0Rb7eeCqWqkDAYgMDFcIoD7eT0CZHl3QMLcbEvITsghbtgcliW7wdDASpjpPWx5UtZeJNhoed3BS1W/OLmWFXg3T6Crz/R5f0AfyPSiuRsBVhuz1qBTncWCZabE3nvWulDEysphLGptsEllBZ0+6KFSIx8xgLxc/Xr8NiaZ/ncN8CH8G0LxhV4qy+sefDVDcUQxxaqUNYRnR/ZYXA0xV7o9U7Yu2i8jaGuymsBcqifnmBArRhPpr4w9LQiuikQw8q1BjTq7RBWkMqX76zgkWMj2hDry1e39/21Q1H1zaAbf/AIvJeGI21tYipdbVXXMieQYXoqN5biQsanIOhwtDYFaqdTra4kCFwjw1JDL6U7Dob1HJpdYyGGOHtyDE7wA4VqXhsKi2oCXPRAUS3xI5l3pwhXIW8w++NTZ22mnu8aBZoArye9NvZsCLIabyj9u8JxaODWl+jXmHm2htU/RqqqWp9zGhM3i2Q5etXDhNN6CIkcdpePnMC2BNNue8r1mlJaBbpIElGHCIk8DUkPC/uNV//5gMC4vHnUZxh9R9jdUauyOeib8iUcWaPOcIe2eKbTdq+yLjac/rbyoIl+/aIdY+KNLYdSvOgxtUnsX7JlgD4VjJv9duIzVQSMOR4jqyiCLHQpBaJqje72wpi5tKp1ZJuB40SJKcrCplRW4V40kgT+Hge1eJV21mFBmmo8P5jxaNDAzfYRijGxpmBICllU/cQekq3K+qzhFu7gaCNhDR8Ln9RkpIdzttVe31j9tZxN5L/PSVzDDIgeQxfOPfcK6IEIn/R/LxhzwW0aUgV2m51Hz01bcnHBzKCIYAQI79N2x3MZLUDdBbb/e3QD1DurkmqLOIAhv5
 uQhOmV7Y
 D49sC+eCDmJ2pqu0jUYNXayIyn0iI43ZtbMj0hZUivV5auBNsapYoLG9R8pE6tDQgLjbwYmFUVq+vOFKBEv9QbkVK48y8bF0vTrRgPUE3nvT4gzG3p9425109ADttAeCZmVpSId5b+wKsU+aNRMjtCNM/g3FpmunfSNsaHIKWV/2MBroH0poNkPIF3DO32zy3k3tCyILGbbW+XHOrpm4Y5fiM6xYRJqK4nkqkOo2EQzP8g81P4u4XFSa7dwYuNPtH17bjY8XQ9fsWfXSCYyIpYp4WIYctZBxD1D1ZPyyY5qn7FEsCRfBFvjqlKQ1WZ88REm9MakV0sC7GekNjClDznOiVgjf+edOK7j17KQQ9vzfHHS7jwZeDDkSE5KFXNQ7JcSZEx+xHPDFY91zO1N92NDyqkVFxTtd3f8INErAZoS1hKkx3Z/r6adpFvp79CEAN03ETfDOPh6kwclpkgU2p3sijZLxAR0eG7jpc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/08/2026 11:34, Kiryl Shutsemau (Meta) wrote:
> I have been working on transparent hugepages since 2012, starting with
> the huge zero page and file-backed THP.  A lot of the code that causes
> pain now traces back to me.  It is only fair if I share the review load
> for THP.
> 
> Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
> well.  It is also my commitment to be more active in reviewing this
> code.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1be7da9b6e2e..f5bb29ba41c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17264,6 +17264,7 @@ R:	Dev Jain <dev.jain@arm.com>
>  R:	Barry Song <baohua@kernel.org>
>  R:	Lance Yang <lance.yang@linux.dev>
>  R:	Usama Arif <usama.arif@linux.dev>
> +R:	Kiryl Shutsemau <kas@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org


Acked-by: Usama Arif <usama.arif@linux.dev>


