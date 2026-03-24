Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B39A9F532FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF126B0005; Tue, 24 Mar 2026 05:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC226B0088; Tue, 24 Mar 2026 05:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC026B0089; Tue, 24 Mar 2026 05:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEED16B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:04:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 485AB1618F4
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:04:56 +0000 (UTC)
X-FDA: 84580371792.17.ED70460
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 69328C0009
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:04:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOh1Lugr;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774343094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYqEQi6VxpAvuBa4igZdIUKCp5I4Ybp+UoHpL7fNRbs=;
	b=ztY/zU9p1ZRi75ag13fD4a+zlvZ0VljzFUupG5mX1KFBQEzE2rBCJrkV6Q/hR+i+WrqRlC
	XXAFKtdBckvQiSNxZTT/D5zts+/WUjn+SRVtdxpm8C/MyIKKgW/oDc0LvGw0tOW6FSoRUm
	iKOyt9PhQGHELfJEmvA8QYWlB+BtrWE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOh1Lugr;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774343094; a=rsa-sha256;
	cv=none;
	b=UAAVOjQUSaaqQv74FHjGXGJjTdjf9UDr/jzudte+txH3OzUnnvt6B4w5yDncJLEevahKJK
	s18+CF/oQk2CVt9v7/T7vr+5o/POmUnio5EGSOl+pSl8eL5+2/RrfZX42dtKsIqJlrWsMN
	bddkEPdJ6M7rDXcCaLedBZoEVVS0sfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72218407F8;
	Tue, 24 Mar 2026 09:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3609C2BC9E;
	Tue, 24 Mar 2026 09:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774343093;
	bh=+VJKsQZS0iFXbNNyS1wQVoSGqHBx1LnAEpRpQhCT5C0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UOh1Lugr3jdS2XqSBPRXuLbFOTC98kLAVatugzKUPJzBLq2NJEKDHodUaOWVZQqVt
	 y+ib5IZ1y/TY63SCoiH7ZA6tq7OG9AK6hCRt35vSckINbPcULE8dtBo8K9864rehj6
	 15PadOrS71PxQq9HYNpxAWz2T+PGlRppRkYZbEQiuQS3tyBaxFq3mlJe7eLNSzlx50
	 YocHMzLqWCkq7GS4EcJw14h0+Yi11CSG5SFerTMVDP6dKvEtgwI4pxgjLhRkJ0JhUE
	 4lJ3vB6XEHzONGb4InBVt66DwyoDbizX7LHZIHlB9FS1U1YtDKSVkKSRp/ts6Icbax
	 ibAnz98/afdyQ==
Message-ID: <e7de962f-9cf9-4628-8272-0efdfd0931b3@kernel.org>
Date: Tue, 24 Mar 2026 10:04:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/11] selftests/mm: remove READ_ONLY_THP_FOR_FS test
 in khugepaged
To: Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-11-ziy@nvidia.com>
 <acGrokwjvIHqDmSP@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acGrokwjvIHqDmSP@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69328C0009
X-Stat-Signature: y8scqmcqqqu3hozi63xwx9ch3grgb66u
X-Rspam-User: 
X-HE-Tag: 1774343094-909681
X-HE-Meta: U2FsdGVkX1+cmppkYmSpdGjzqm/QtNDnhvCEG/AapIvAUwg2Q09AnINfIJvZpPPn1veN819WO3ZT6eJHNXjwNpAIt8Lfanx2FNfUcHV5gd7hAfA2hwNdzi7jeQPBZPp6VTV21CQaX1LoBH4UUSuHOc866dKNu9+BJwPdL7djkIClYD/r6nqARZBpxU0D8RiqFjntX/rxPG0kwJO+VqOT9IAVb5aMklmf2d44XMqaOLFmhogyWiF1X0+qUdP44DErvSwGhH3wh5HSDxPmcCsfDIrVKme0u9Bl6BumQCCMrLk8LEItDjUTnfsb0IzuESTUn/7Lo6tSWJTr6jlrMSOC5Nk7k+gM/pAbJjjGCyOzHVIh+ZfTlMeYGNjSOvB3ohOTSlVydZ24FqQq6W1EUeLG8DTLhn8iwYFSg8TPaa89Q21kqgoiv1c5jTCdJ50pxYnEQPYAnjRH+MtmWPAK6WbkbAieAsKO6ZkDhygjRe8hDyJo2ENvgs1korgxiIKZ+ejEioQhmzGWOTBGfKlK69X/6LJHmw+4b/hlvnc2YDuBS7EFKPPMs7UsQ5WoZb2x8Tv5T67QSC2yRI+3v8wVr593Zyj0dffL8uhejD9sBw3YgUSGXdgFlLBeUjfWJRH8rT9+44v3sHaYyDWBg50AnBPlvwmWN+ip/5zUKFnIX7GoTndgdnTUWtuv+Kz7Bop3R0YDsC4u4b+h8BBEK93the/PNFdezgzdAtEZWRBttkfBG//eqe62JYKTeDVS6dAtEIB3fOKunKhMoZ1N+PoGQSEFpKOFu6gmFF4WYax5T6BZZ+kihYruG8vwUlvLreqwjyHChGj0Lv4KLpBu8AQ3fA6lhn5c7G2/tAigT2E6mtXWQYto1EOWtTQtk/kJBNtGLq94HxjAio9P17EFtkLl9FUSgh8aiGmmo2DMUWYmQW0Ri7DgeGOVmU3DPGIH8BKqm3Pcr9HKtmFPm0FHMAZvLHv
 7kUOVooA
 GYviPt+1WxxcjVhMvO7fs2GHKBzga5YOjSixesYKY207jaZ/wCCDLPaHXnUjUAE6nfnE3gG9HAkNuN1Z/oHD9snJr+Efablbj0ZNNJ9pcqIWvPFMWLsTvpl5mkt1fBGBiNF99uRCCb4vHk2R6e8YrmuaQiWlloLUBvq1uj6OOkyXajE/+E6AHbjktT1kzv2pEAtuNdBJ3OeubSOZaHotV0np9qr+9EQDYDu70/AUK29U4Q+v7wmjbJcmCn2H7/23izfvQsulQ6OGNzUmrf4z/e5UQliFdsOpVAYSPKrxE405udvI/Xvnwl0iMNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 22:07, Matthew Wilcox wrote:
> On Mon, Mar 23, 2026 at 03:06:43PM -0400, Zi Yan wrote:
>> READ_ONLY_THP_FOR_FS is no longer present, remove related test.
> 
> Um, surely we want to keep the test?  It's no longer conditional on
> READ_ONLY_THP_FOR_FS being enabled, but we still want to collapse
> mapped files.

Right, in particular this patch would also remove MADV_COLLAPSE support
(not just khugepaged support).

-- 
Cheers,

David

