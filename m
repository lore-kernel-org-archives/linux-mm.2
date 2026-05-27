Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98EE3CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 23:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B206B0005; Wed, 27 May 2026 19:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C046B0088; Wed, 27 May 2026 19:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51EA6B008A; Wed, 27 May 2026 19:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6FF46B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:09:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56878C25A9
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:09:24 +0000 (UTC)
X-FDA: 84814743048.06.2DFD474
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8AC0EC0003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:09:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Yk0GnaFZ;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779923362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naJphF58gIMQUdGu4pgd6Y3t0BQU+qW6Iz2A86qJ/LU=;
	b=s4lnxQmw7iH+ezoLKis9epkp1PtbQoLqyRg4HTFjFWjwHhWT+SC1m51G0GXJ9pLRI+syLX
	sB1gLjVabpDJAkDKbb4lOtYcTcF0jmKNQBlw8541VxxpUUVVXfUg5/jJmgRdfM5J3qZVUr
	Hylg3rEpn05M1O59Y3DzcPWXGq2yqOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779923362; a=rsa-sha256;
	cv=none;
	b=q+wSvOjd/l0AxnaNt7DG8/DoY6ZxB3Ynh781n0QT+0ew7ACA43KdK7ve3E3H3dG5KBL+rw
	QVVEFkJ3d7u1yh3kohT896VCFbBjPm9tWpi+fIBfvt9VIuFsMdiezExb6fOJ72FS2L56if
	h6ZjlySIllimYURCPlma6F9DPFMvFh8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Yk0GnaFZ;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=naJphF58gIMQUdGu4pgd6Y3t0BQU+qW6Iz2A86qJ/LU=; b=Yk0GnaFZJJUaLcgwL59X6ebBf0
	Biwo8VfeS4xcraPusP8WrRf91iwY9QapvW74Lhcq+E9qXSnWlcz/75bXw+TmUjBeQhTaZBsQEiaBU
	izlaNwAky6YiBnaR31a7GQTr/GEQXL41hEvmk04y9C8V2Rf0JXzRKBFOWcTzB+cW3FP7wc93iGg5l
	nbfxfc9widPOJpETlN4UlyiHOpEsxT8i40D0j+Nt/VLg4BT5loN4TjyRVzXyEzstSn9MVAhavruFf
	dD9+wEcgm3Tnx6wgkQVBQ8IFaXrUlbxsKydKyHAGmRiThe6nUWgll7fN/v7QAcBsGdj9VWzfKVRJV
	jBC7BuuA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSNNA-00000003SLW-3rV4;
	Wed, 27 May 2026 23:09:13 +0000
Date: Thu, 28 May 2026 00:09:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: lirongqing <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempool: use static key for boot-time debug enablement
Message-ID: <ahd5mIMCnI4DQFn9@casper.infradead.org>
References: <20260527104634.2434-1-lirongqing@baidu.com>
 <4da5d090-8272-7f26-9e83-ea4ab489f1f4@gentwo.org>
 <ahdsgyYYDn6juR_R@casper.infradead.org>
 <7f4ec43c-0d9c-190a-0ce5-bc3276b45cb0@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f4ec43c-0d9c-190a-0ce5-bc3276b45cb0@gentwo.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: ernzsoy5hi1zuiy3nu6py379jr4q68ck
X-Rspamd-Queue-Id: 8AC0EC0003
X-Rspam-User: 
X-HE-Tag: 1779923362-183400
X-HE-Meta: U2FsdGVkX1/sRm+DENLa8mN4l9XtoK/zanMCVbnxVUJ7+8CJEnhAhYDkOh47k1Su2P/4bR6WKgUvclMsF6BTQEM/AzR5ITYInsGZbNPMe9a5pq3J9x/EZWEfZPNPRUEvMe60CtcFqHeTKvL01/+0eYIa1kwiv7zYJGF4z/+4sxJR0//bn4Mog15NfuxcgT4d0iSfggGuY+0WoLnLmfY8XSnhm3ic5MY4kJhKp9cDuQmVTGsmuRQUe3qji8xV4qIPHj/0hKWFZTXD+f5/HDEZnevW/pzwBjxT7r2j+VmW39ZDHOq7XXP/dOLJ/WY3PKBvssbm3VDygC663lVJITbeeFeLoRweXax9ZGjr7k53JqKkb41k6G3KbjMBd30/u+oBQhcXoC2jOqn9NGrZB4A1q76mzotFAoqFeRvJaVaPPiWI6M0O/IgD4B+yVayPgX9RMMHXchhEEA8CEiVFKdSx8+5gxwghCo9k/QdgEgm0dOkG+5v6ZjszH7CY/etppkVrdL2/QURWDEzJvk2OmxqCHgHqlp/PXH17GdMn/Xjl2NNLXhR0qWFCHEZzUO1cd1uV/js5i5LdXBhk2cK7R9pUwQmMNWIsA7JYiZHuj53nuvlf1hcomEJXMCROTv/HE8VsLFu7NIYg87J4Xa712wFUrsf1EiJipEBzjv0Veh1UxMKgdXOOJ1sWswLYpfle74u2vY8Jhdfe2biXd2fFxdzweMnvqHayYu5uEykn+J0/CRxRVUBrePjuHG2SyIL39C/3h1Im/qzwnJUNUSRfD4epvvyyDSmoHPlaKml5+QvLNo+pM55KlDFFzlFA0SjU63YLeKQxkWw09MCD7CAyxhocJ+ppygzjNPVu5gR85DA87SW5jTa6ah/IAemsVXxoZQWo5NR20Gf9UkC8wmENMhE2MAG3pjBnIvGazucWRI0y0Wbi0imRfVmEzWKdXV4jZGJvWvX5I5odMdsAeJyaNdR
 WjSpFBif
 RyaudJGf8oWXCjEQ7ln13mheTk3HZTy4LnynlwxZ0wzVLMRzYIvPOoKIWgLZtxpIEeyaezNHuUVbDsXIXnLbeTJc/V/Q7tbR6pa6BUVy9PIPObTQu6tvTQsv4mqQFC4hdh5O/Eff+c8jO3pGkp4x9LAq2iV2dX0/C7hycBHiZiKIrCK9r4snbXALXr5v/356keCIw/0aXxUtS/UWiuO1OUqf2Fwrw4pdGMDspiUnMmNf0L6QuxhaW4gk1HDEP3WvF3+UW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:06:18PM -0700, Christoph Lameter (Ampere) wrote:
> On Wed, 27 May 2026, Matthew Wilcox wrote:
> 
> > > Please clean this mess up.
> >
> > Isn't that what this patch does?
> 
> Its not marked as fixing something nor as addressing the weirdness of
> using CONFIG_SLUB_DEBUG_ON here, A kernel build with CONFIG_SLUB_DEBUG_ON
> can still boot without debugging if a certain kernel command line option
> is given.

Right, but ... if you look at what the patch _does_, doesn't it do what
you're asking for it to do?

