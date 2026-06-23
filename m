Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E005CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C946B008A; Tue, 23 Jun 2026 13:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DE86B008C; Tue, 23 Jun 2026 13:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4058E6B0092; Tue, 23 Jun 2026 13:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF326B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:45:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90601A0594
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:45:27 +0000 (UTC)
X-FDA: 84911904294.26.0FEA877
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3F0D420015
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:45:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782236718;
	b=dl5m3UyUlhnbdFDaPvqYOMd67J4poS8sVKVX6M0h2UT3Zw0JEs+TIvQ89fE9MHJWgA9W8v
	ArUw9zT8PsJXlG+JWidNXrgdWmvchcTyz+Hccws7w07R4eloDaaZjUP9DYqw9ckdeOp4kw
	urrp/6PE3NruvO2Qn6BBIu1C/C5YrjY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782236718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaHNpE1Zx7LWzuTl9WU/7Xg4nmo1G/CpH4NnzoZ4dWs=;
	b=N0+jVMXHZ3gC6y5zdtDBWeaIiXw1p6Ut7EH7nTZDQ5nan2TX8T64sXhrHAlFmyRLlOb35l
	mwPpfg7YFCnG/83A/Yp9vzC7c/6zmZGSaiPrWkcPPINt3Cq0mcMTzVARddcsNefRwe9XKO
	7JLPldG61ylsz2fel2cRU2IOHfJ7j/c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NQ7TMCx/";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACF5A60125;
	Tue, 23 Jun 2026 17:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161AE1F00A3A;
	Tue, 23 Jun 2026 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782236717;
	bh=CaHNpE1Zx7LWzuTl9WU/7Xg4nmo1G/CpH4NnzoZ4dWs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NQ7TMCx/XS0B+A6PVNLqd7dD2fef8rJ57zF3x3fEq2XgKHt1EvFysTvMomVvGEUPD
	 uah/OYD/7kDBv6EBtZxeHPPxg9iBrysFfkQPH3oOj5A95kJGLTYXCizsfsoRSoafW3
	 8V8CIyQewinFC2H13yng115UlE6jdh5LjEAUZASo5GUOW+7v2yajovWhIvr8kk53JA
	 v7jV+nkirJuDlS4P2lPshfeazW5dJ1KwRSzb4xtQ4edekcoBq7SKUAwUcZj5KX3Js0
	 V5M/dPp0iDj6x5d9MQdtHQbkaJDgefLlX0wNTOavut+3gTkhyRMpW+vGw/jf6QqQd2
	 BA2b3j4K3N9Aw==
Message-ID: <e5a1afe0-575c-4155-aec5-fbf1c27df373@kernel.org>
Date: Tue, 23 Jun 2026 19:45:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mprotect: drop 'sub' from batching context
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 chrisl@kernel.org, kasong@tencent.com, liam@infradead.org, ljs@kernel.org
Cc: shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260623125723.2503832-1-dev.jain@arm.com>
 <20260623125723.2503832-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623125723.2503832-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-HE-Tag: 1782236718-198582
X-HE-Meta: U2FsdGVkX1+zI6432a2EYFN7JKJw+qi4e3iK6awhSMyoKljTRU0lxINb/b/DcEOcDDTFSaEB8qfSSn1ix/Xpaa+Oh1yRT1h67fpToyQ4yFs3VqNeDbBXPxU7KpLXx4nbSKxA0GalKhMDlgJ3eKuhMP3Je2WGDz6O9V8kZEqfqjCEihqFot1AqqV/TcFVpWPKP96MMPa1YR1843nldFFU0omISqYFkPcm7CTCkClhP8W4//1xRQsPMKuzoSC2oAqPwTC9SXCnB5tpwmoCPx6jVUncpVNLcvK5bvZCAML7zbxEb45EHy+WxHz0yczbJrOCd+1v5qGKK6Nk5ep7tnoFgmBgdIvByoJzhJ1Nmn0+oQD2kcVUhhcSLr2XNkycCimisnIrjn4aoDkaCrApISIXW3Ky7eGRFiqZ4LtuaVI41c4laizx/uJ0dtfmukK1f2ejT3cbrhrikoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 14:57, Dev Jain wrote:
> Shorten the name of page_anon_exclusive_sub_batch by dropping the
> "sub-batch" context - the function itself doesn't need this context.
> Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the
> usage is clear enough.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

