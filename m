Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06063CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F29D8E0012; Tue, 19 Aug 2025 21:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA4B8E0011; Tue, 19 Aug 2025 21:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8073A8E0012; Tue, 19 Aug 2025 21:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE5A8E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:21:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22A00B8218
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:21:12 +0000 (UTC)
X-FDA: 83795382384.07.064AE74
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf04.hostedemail.com (Postfix) with ESMTP id 76B3740003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:21:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=Nq5l+gI1;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf04.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755652870; a=rsa-sha256;
	cv=none;
	b=KH3if21YO5EZJfyFeZzf6ujWpvHfNtGnbBYwF4Ymzk96nFDPjz78fuSvae6N4+Dt6pbEl+
	sA6yPOjNM4L9JP4858q/0RfKz5STB9u3luaW5KxRYhzKfCmmbQHaWD5l5MhZizjY+9YyE6
	Y8tKTtgigPIt071O7XtN0MkfsRrW+U8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=Nq5l+gI1;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf04.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755652870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZMvR5QVzbNn1ZOikn+6fLVoCGoDcvmbRo5dA3O2AFA=;
	b=gABpz7DY74M3BSA1Z6jnLYI5QDdlArEpMagn2UzQS3It1PC86a6K/mdF/f/WGowyi5W/fI
	6SCtrCrBWBRJTYltTNS7TaBy/cUUCs3ze+S4l/YK4JSpIKfXu7nrVKz0eqmWvGX5gF6BX7
	68slH2v8t20GtodC4HoaWfAeG9d37ig=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QZMvR5QVzbNn1ZOikn+6fLVoCGoDcvmbRo5dA3O2AFA=; b=Nq5l+gI1HtFSguosgBSX/Fylrt
	KaHEcYe2NywPqF5xFCA0fmbq8xdoJn5wfzv384L0LKwUiREJ5hB4YkFixTpf95tVvwcH2Dc8w3Lrg
	m3eVFjbzZPCNu8aqZqq6C67EMMkok7/7ozw2Hq74t6l7XthKRToiow8WQDUtK/x7lI7DWk07Do06f
	fCUNjke6lwuNclHxpNR/A6fu0zrvxKnAyIhsNm6e8H9o4t/q9gHi9TqeFN75IwnRHXcwyG5+fzCZL
	Um7JL4strIP7r3fxNQRUbkaRrhd0fCz+VKrqXq7meXH0f+w5NI5QHyYv3xKI0C+7RV2keS0HVTjxh
	70F8Ozeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uoXFx-00FfnT-2n;
	Wed, 20 Aug 2025 09:20:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Aug 2025 09:20:46 +0800
Date: Wed, 20 Aug 2025 09:20:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Barry Song <21cnbao@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
References: <20250819193404.46680-1-sj@kernel.org>
 <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 76B3740003
X-Stat-Signature: qnx7uuzppc7phngrn3jksk6jq5hofuy5
X-HE-Tag: 1755652868-407405
X-HE-Meta: U2FsdGVkX19R8B6cw12bHiDXJuf+fot0nFGUO6nYllGPaD4s+JulRFrTEUdNNarfvjCB94UXgxYaZJeuRp/hcFKaE+o5PLvFygnm+KmyMvlTuD9gwrBVVNF0oZfD+yRWn/d5D7vTpTOeArSNPI9z8mJLU8s4f8hVQICdmYBifEM2BCUAOALzF8mBlUAgKLpaegDonhjBcUWnONFuJF/hzTV39/FUoIqkbhltxWDVLX+RkCQLyNsIwFc0JNF/szuvdLhm2hUgnYX49dlcI9dndiLLCfseJUaVy+2UazM91dYyv2gRBBARZzk8An13zp5RzTS3qzHf9YWJ8msbr4JZu78UiJS/72RW1VFu82bLmDe8Dee/TiBUAdg8f8CitRmYwnJhJIBUYqUsJL6zzPMct5tLB0bj3dZjjXO694O5AuqopzJEiP2LKiLAlpY/mMIRzOsACV4syqdPNeNDxMl3ARnrnMjIHWg9yYKdjp0JrjU+3YK+Xb2U09r8zTeBW3Mk6N/eM30yKkJJEFEhDtMYbjSdFscloT8tBBWcWZAjxxPo62mP43G0tWRriHKRe4sdkKcLmJQA07gSogO+eeg4ATpOFJQTWvzsn2vidSaJpvReW4tLNqtQ0etaNWQctu1GbrxfZ5+msbTfp6LpqhQ0VbdmRFaz3p13QAutHA0g8RUbhy/iPqTwNnuziH2EJTCBmg/OGYwmV7ch0bKIKNSU7PCEYiHtJYqlKXyYPdQLpNfq6l9OnvxhWtWRQku7DT3H8+4T1sHEgQ8UOSxzSvAi/LvtIImU4D+fNtEHZSzcu6hCBTiq59tq5Cw0zlv454QJv4BixPfGOfM5a9lYutOw8eLb2J5av71QDf0eu7T/9/frTQaTFcLIBtan9KEJHl3lrnwO5RmiPSA04YxG7hPaPnxW0Bc/6V72kV7BSww2Px0mDg93v/5VCmsQf9X7N5kA/orI5RIzUbgq4tYTM/m
 AY3vuEfb
 ElRk6n2SXga8bJgp6wi9lYvJqUxddK2GzimWg0vFPbppHyUHTIVaqin0B8Htk+OMENw2VdsTU41zO6NaJRPY37t/i7q/cW2yF/ImAwJXO8s6sQhl+I4VlIoEJ+Yk26jMgrj26MNn30U3RKotuPDlFN07qztpNhJr8el3+0KF9XpUg7zxXy+BpVTRcdr++4C7qMg3G2+kpeOS7fqI64qggiGkbYoZfBN04JEMkilQ+QDMq3jVGGu+GbkBYswm7OESlgmgBbg0PbJc5D4APzyalv7lAgrPEurp/BNn+kbQ5fQlokVhlItTNHM60xzlJXiPEqOMmznDbCaGHke9VRymStDMg4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 01:13:13PM +1200, Barry Song wrote:
>
> Let’s sync with Herbert: have we reached the stage where all drivers
> reliably return -ENOSPC when dst_buf is PAGE_SIZE but the compressed
> size would exceed it?

It doesn't matter.  Software compression should never fail, and
if it does fail due to a bug, that's not something that the user
of the API should worry about.

Hardware compression should always fall back to software compression
in case of failure.

IOW all compression errors should be treated as incompressible
data.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

