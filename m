Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894BC606D807
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6fvU5e4
Received: by kanga.kvack.org (Postfix)
	id B0CF96B05B1; Thu,  5 Nov 2026 08:33:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96E56B05B2; Thu,  5 Nov 2026 08:33:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DDD6B05B3; Thu,  5 Nov 2026 08:33:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 744186B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:33:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16D881A09FF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:33:59 +0000 (UTC)
X-FDA: 85401158598.19.AA839D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06C1640005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:33:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6fvU5e4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793885637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mzxnox2ZqcSOtlYhZiL4hy8PJ7Qt6MthNjRC53Mvu8I=;
	b=skF/qWvb4DeOsPd8wbrrAFzW3cjIRs/HD2Y5Jdh1dphXy5iOko3S7x1n4DiYFr0qlHLWy9
	KAlOzVYMhsyScgDr+51bYgrm+lSChiOLvchV8JIT0O5fW1MT/UHgv26jzddLRp3ENy0Ljz
	OxMJvbR/CIMsZVE133VdQoYW+V4qa08=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6fvU5e4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793885637;
	b=ANrp3qs7Wq6nTG7dZ5Y891xGSB1584rGhII/+B5K/nFBDU2Lg4/4o7Wof3sFg/fZsKnkFA
	P19PG6TWE+p9+QcnMK9RxXDh7SMJ78RAAYTBitZkhRtzbic3yN/mU1JiZWh40+or+F0ZTV
	CuslyUsAl6gGQwwZ5hn3xoK3AFwcp3k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86D9B60267;
	Thu,  5 Nov 2026 13:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E967E1F00919;
	Thu,  5 Nov 2026 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793885636;
	bh=Mzxnox2ZqcSOtlYhZiL4hy8PJ7Qt6MthNjRC53Mvu8I=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=W6fvU5e4v9VXByYxToyGfUblVQFNT5WuWLgquynT0RDF8kyI1X8tPIXHjCOMM8QKi
	 TB36uNlZnJvDpPmcr84r9evk4qeRURYKcquEJnZZTgrSafak9JljZ5qKQIoUGre7wN
	 F/hompvGtt9N53QUQGuqUv3dCi/2jGp8a9h+gUNk4aOMpyJxRVDUCGbPpIyxbjzxoe
	 mGVOhUP2BwdYxoZAZZlzs580AfwUJfcnN+1PAB4j3WtHbGtwbZOmtMpZbD+YudzfO/
	 uGqllzTSWK8GJe2MHIDMiNnX++9xx8AFZSwOcw/6rq4jgxoM3pI0yhV1EQZ9Y9qyNb
	 1hHFGhuEaqxKA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id D3B3AF4006A;
	Thu,  5 Nov 2026 08:33:54 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Thu, 05 Nov 2026 08:33:54 -0500
X-ME-Sender: <xms:woXsammtkXhLPWsH42dXHpryBkz2i7c0bnU2Lcbos2kHCzmRAoeEug>
    <xme:woXsaor_Lf6RBoLVpMG21bH7KQd6BCfSMtpIgKxnDqWGFSMh2mOC5kj2tLxnE5dqW
    H3b_SOiT14cMJSc3cQ95dDArJw6ObEb1IjwO_cBMZrtSQozzrKMBpE>
X-ME-Proxy-Cause: dmFkZTFXNwLxjr3E6RMaivkkQUj61yNTw+BeXqt/FKvD1Sb1j4JPfn+xjgqZl+4+DRKQRe
    3mlUJxce3RaawYdhvit1fIjwgkMuyA1cwwiYj5q0wQM+s3WToqXmiY5vNpMll/QHUocAOC
    dD4HRRG16qL0UNSXwrZRMXRfVo32pPW0neF4XEVJL2OEBtaBwT3L75kDhKsls5Z/VanAkw
    tZfBpQqh0VZ+mNEhUO2zST/Zp/Gj1vmtZKNtHKLQ1Nm0saygMTnCj/dWL0sGne7hCFXKnO
    RbDgZkxQWMDPb4W7D/wEccbEOZ+G8dxVSGwFtLcVup9a9kQxnr5bjO0atIXGEGb7WQE/pC
    kSq+aSjtpNpnd+Qi4U4YmxyBC9sA/6SbSr/MsKzB7wW1UL74y2Ss5C3UyujLzPMP8WG/yq
    r5zXMy0L6GNlxaT0A85WUiDRf4rpKD81/qtDDqVYALIKaaRRfGq17B1px/08Xr6oj9zLVA
    vgIh9uz2Xw3lCh5P+gDmOG0ZbNFnx52PHaFyFhM33DCW8wyuD9EQeMPye2sVW+8/UJ9yh1
    5M7+/BZ5JKAIhsDBrkPvJcgQsNxLgC/zaMMs8WdeGQBY2LZh4bGUPeXGZf9EBxdXaZNpAG
    PhH37UyZ3FWsKQSYeD1Os+dAe0Pf99Zu+CkAskN4X9vT4qniejRYN2FT2gNA
X-ME-Proxy: <xmx:woXsamf3tSjXzZQ4haIv784kpFLWCTAM9kXovrsnrA4MMfNwdf8DlA>
    <xmx:woXsavwf09Tzn6BzjM5c27OkVXfDz7aCUlZGKI2CXjDH3tq4VxIrkg>
    <xmx:woXsar2ZbDMM6LSy8mEm32b3EAu9iB1LuRtbEms2pPVQh1dO9ekZwg>
    <xmx:woXsamfDeVghD6zLhqEou3KbzqeijRKw2q0-uup0Ncf5qUs84TZLog>
    <xmx:woXsagVOFsksHKpQ0-srOIDYQGqnZ3mSF3W7Gs_3Uul5koTzNWOjUTcY>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B0DA8782738; Thu,  5 Nov 2026 08:33:54 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: A-1cIfNAHW1c
Date: Thu, 05 Nov 2026 08:33:34 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>, "Mike Snitzer" <snitzer@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>,
 linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Jens Axboe" <axboe@kernel.dk>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Jonathan Flynn" <jonathan.flynn@hammerspace.com>
Message-Id: <29851456-2e7c-48a7-bf00-11a1f1a35024@app.fastmail.com>
In-Reply-To: <20261105075935.GA18069@lst.de>
References: <20261103211754.35352-1-snitzer@kernel.org>
 <20261103211754.35352-8-snitzer@kernel.org> <20261104091543.GA31130@lst.de>
 <autk-osSQ8l2LKz1@kernel.org> <20261105075935.GA18069@lst.de>
Subject: Re: [PATCH v10 7/7] NFSD: drop a shared boundary page only once both WRITEs
 have written it
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06C1640005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8fdi14kpgjjoj3urbcixcxhc8r4zzf95
X-HE-Tag: 1793885636-939530
X-HE-Meta: U2FsdGVkX18bQiIGxOCZYj9bXbqidOa4xrGJEYrRY6pPhfuo2Tn9sjzRvq00BlJi2+5vVLcSj2WxxUOhx6uuNUih/LNv8HeqW3mqx+u/7I69CzNJV47GKWFk6mU6cIDP5MEr18YvT114GJuI31MatZqmtvmH5hA+WVyShxNlodhnu5jI/dWDnDt4JC6KxYAOCWrxwIEttJom5Zzc8d2eMWx2fXsVtLGYJJLo58xiX8V4EQKRbL7lz6ypjCFsvlnMbCEEEKQaifm1LRCkUzG8gw4A0JzdeupAPkMlOj81Nvt9qXcDx9UXCS9nL1MlK+UnU50mv5QjOFOxXLsLHzXRKsBZ3kkpLkjOo/IlOztwkcDhXd3cKL9SSG4BswcYjZkyBeFn2derjUXSN/vj+aaNhbsDDO+icCtUmwsIi5x1K+86l5tv5uUPiYFf3fMisT8VeUoFqQfJW/ByTD8VTjIl/bQRh1k4KZsLf9t5nPSZ70o0pWFwL7Fhck4f1W9gfIP5oTNYpltSCyno5Fr38svOP/367PWx42Ae5XfeYV5CIJkSYV2FdI9ZJF4+y867BuQM3NvWOfkLifBjnwcnDvBpduaht/Pssuy0wwRMr+oqvqcsh6g0ZpgfXlJxT1UnTbKMPMRcfB7rXoQ96xK0ayIRY7O22JsUV5scgzwvw9xqplZQ348WQ6JZt1n3wL3WzqTwTWJ2OSHGeN4LDYZQoO43Pv0XHSgjK/2wHrLc3IHIoyD7TfY6SbKmimoj13UogS+UNfut5HTY//r3pnYaWrTl8S4vqchyK/yqqUh/ZHAIcyL/Jsq6pfE/Y+KuT/klFw7B7O/IM4MOqTa9cubet1ZQ1m4KMDTi3iZkJmPuwaudxRglU7ks+u3eZciMwJaWBxZBdRdvGsR6KUZ6B+KaQH3YBFbU10+YZDaLdqwiuoaf9Pv/Vr9yrN+h4MIEk8GdvDOMzL8wmTuhvv1Qy/IKlcc
 wkUtrAxA
 24SeOI9RQGObR5cYRIosSuUR8BZFCcc5GrWY4NIyCbiaYj5o/jTtXJqLSqQiJTJ76FofzzkIyPcEylmz3BY+sBVTJ3A6E6rDzi+HNNqk5KESE3QUkucA7H9R88bvBzlKoIcbJNVT6ET7HAZOEGmtWuWpwIw7Kw8XN0S02UAfJlqFH4bYIN/JE/0TCX06IY9VgRKXC76TiIKawQ0sAb0yvjasbzeLriBaoqqDhVHNTvAl+o2xsprLs+C9jTvdtFMc5fFxPtC+/fcCrGXZgbrhsj77ZdHXASGK5Xj/KdgdncURXUDmVbzwCLYH72dOZK0aRCTez7U5ml/LuLr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Thu, Nov 5, 2026, at 2:59 AM, Christoph Hellwig wrote:
> On Wed, Nov 04, 2026 at 12:01:46PM -0500, Mike Snitzer wrote:
>> It is the transfer size of IO500's ior-hard: every rank writes
>> 47008-byte records, interleaved with the other ranks, into one shared
>> file, with O_DIRECT.  It is meant as a hard case, and it is the
>> workload that showed the problem on our servers.  The same happens
>> with any record size that is not a multiple of the page size.  The
>> cover letter also has 6000-byte records.
>
> So based on a bit googling your totally optimize this for an intentionally
> stupid benchmarking workload.  And that's not been disclosed anywhere.
>
> I guess everyone else was right and just ignored this bordline malicious
> submission.

It's not fair to ascribe that kind of intent. I think it's fairly
well known that Mike and Jon are using IO500, and not mentioning it
in the documentation for this series was a simple oversight.

But IMO we do need a broader variety of benchmark results to
understand the impact of these changes. IO500 on big hardware is
an uncommon workload for NFSD.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

