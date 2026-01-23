Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D09D74EE4
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752E76B0454; Fri, 23 Jan 2026 10:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384016B0500; Fri, 23 Jan 2026 10:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FFE6B0501; Fri, 23 Jan 2026 10:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFB1D6B04FF
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:19:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3E068B410
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:19:46 +0000 (UTC)
X-FDA: 84363588372.22.5F3C3CA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 655F4140007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:19:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=snKtDNlA;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769181585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JmFhL/SCAYCGHLafTsex3OPzbrlitsDSrF+Rrnv3bY=;
	b=xNSBrEZqTeBKe0k7ph9/TQ71nZhIPWPDIobSBODdAVdNI+hRl3dxt/MRPFovUtQRNDc2vC
	OKqHz+PIF7eC8OyoyqqPJaKEDDl32iQffPTRKXl1Zamzoq+9otLdin8MRr5NbftUc+apf4
	zRVXGAvXrAa3N/TiNq+pG5YR8zvDucg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=snKtDNlA;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769181585; a=rsa-sha256;
	cv=none;
	b=XL7R2wBAqu1EX/afVnCFEXajvGCH4sMGIJbz7Nb+m82xsqfWw5W+oW0V2inDppFzjiG2sC
	T4OArOyEQuEx/XEjL3ZUXkM6XG44fInhNdu5IRpx8b/ngBzGdJWc2Tis4JFsTlG0tpjBeW
	9HFUb82RKlXc2CjhNgTKTtTIZ0lSxok=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6JmFhL/SCAYCGHLafTsex3OPzbrlitsDSrF+Rrnv3bY=; b=snKtDNlAFsEpEKiwCMvJQl6YLL
	C5JwXAdUcx5r6Z+mYeidD5OSEBvC3YCYz++uU1XDjSabN6AU1spOsBPIu6eVvyaAzb05YBAzRkDc1
	k2TsFDzKxAMaNZTxd8mmZvNr70RpQHCqDaTVBAkm28zwflCOTpMMGbVesQ2niF522fK4Lel/bVBs5
	+BFq0Y9EVElpIoE7LMP2IdaSPFyNvl/FLpJaSBdCucLsVO52L1BdEY3Wl4m1CLISzPD2fddbgxLil
	PQWrBa3ZI3kRVWmNohW1ygeMJDmQsbfNESC7clXgKwKohk2cVLxTf/Dzpnd2bnLfed5LaVUXFODMG
	om3ZdClg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vjIwi-00000001vV8-18ac;
	Fri, 23 Jan 2026 15:19:36 +0000
Date: Fri, 23 Jan 2026 15:19:36 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
Message-ID: <aXORiA7_Oy60MSDR@casper.infradead.org>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-3-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123082232.16413-3-vernon2gm@gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 9shcfczrrqj8ybxt19pqrnmcxpfb58cw
X-Rspam-User: 
X-Rspamd-Queue-Id: 655F4140007
X-HE-Tag: 1769181584-612008
X-HE-Meta: U2FsdGVkX19Z+AafEHLUy8gVRilSYzaaT1Z19cEMsAsTSIPmYv/GRmnKZdZSVVV3VfDP2djuMoZGjaE534j69VjyTCWz6msxZIE7silj4wtB9CGOxdFbz/hs/LKCCv4nveYM+1Mq61p7g2NE8gCwlqNcnNFkb8KW658nZ0wwhoc3OEZSLnFh+1nPk7H6qd0NetnFePdFO9v9pUrineagYs+whtHlVELGMNBL2moDa3JKcaBrbvbNO+FO1pwYzGDWT7jn/6Wz5xkNJ5MMVnhbEwYVWvpq+0viPU4nTLwzTPKR6i8ktkL19WIXdpCG4BCOttPqCvSo2M24mIkyeMMDd6oLzXfCN1YqcplcfLqzex6NtC4ZenRfQOtJTQQ+3pzuoUYXgnSubce7MC3sKtich4Fg1ygBZJvnAsUbqtD38cpSg97c6HtniUb21MlfRu0faH6vvRWOFCHZj+0amEUJRxW2M+QZ7LlNpBLOL7F01oNQxDKUYqdSjs5qmpuc9WxAD/1swTyoWyaX8ci1rJB55c/7rmZ4ZL+VN/LQvcZj5S287Na5pfahF5GJNo+W3f8dXBC4O0Xj0+II8YEhCh2RutJL4cKgfGvM9EubYkzjRqQHZF1jd6ov3amhew4ZOxGsRiFT8Jqug0pqF1yHsBWRT0u/qf5TTCPd4Mss7N3yCYpoZ6TBQznJTi3VwjUfvW2XyiUK/sE1MyEeWXeSnS0d16JxUqQuN7SZscgO1Zl7V6T3OOfNHfcFHExgUOymL+fh0yLjSbdjoagb9HUDO7PRwrWq/Hu12winW6bqmdqfn/nkZk3UjPHEzo6LMfR+KFcw1b6MIM1vmIaNjy+70bK9kFSlafKhPbG/1qrq6cAug/0Ke+CfMEURJ8EGcqhpyrWXoB/m/MzRxDlfT2KWq1ynK6y3TC3BAt7W+BtyzvxhxMXMSo167w/0LZQRvzQfP1CMBy7iEoq+PDlkLP6K4iF
 gaRvMmqF
 owj7ZQsYp2mP1xWypbqAt1HCrAN+nJykLcYbi9n40eQGK6YAudvTBMihztt9j2Id1kCE5UxTYf0y238J9vHYDtbRX73THRku5qh8Wf2/5RLkgGck75x01XrkFDAuJkioi4H5Pm8VR1kYPueLIu1ChMNXAJS961c7Xy6LJV0hpnOAEngtAbkRLKvWqY27RQ2VrrdDINzBcajaW5N5pNRD8V9diBn+7GootoEmcUovlOd8lMcZSJNJEcs56hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:22:29PM +0800, Vernon Yang wrote:
> +	if (cur_progress) {
> +		unsigned long idx = xas_get_index(&xas) - start;

I agree with Dev.  This is less readable than:

		unsigned long idx = xas.xa_index - start;


