Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E292AFF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 07:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4826B0088; Fri,  1 May 2026 03:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B1D6B008A; Fri,  1 May 2026 03:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0EB6B0093; Fri,  1 May 2026 03:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26D3B6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 03:11:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AADDF8C1C6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:11:56 +0000 (UTC)
X-FDA: 84717981432.22.43505CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C6CB11C0008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:11:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=azGSeyiG;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777619514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/UA2Tglgx0+M7x4ITW4X2NUfOL11e7KWbjiBYu3A6Y=;
	b=QVae7U09268ddwhRxp5TfcBM3UEUr8Un+bswJGxzP435NTXPgire+5E+9XY0bVWilILT9Z
	qY1aaOR4GPWtSrLPAajPGSb2KNvbV5ZfaQWuWcnQtp2mYwln1H2lWl9OwcSBmPNdcfgSTU
	zEoMuAAFood9tlL3CkAt0LaDHg60cXs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=azGSeyiG;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777619514; a=rsa-sha256;
	cv=none;
	b=YyHw8EKDZSyYO2RYYyOz2feNHyQlD+Jo8Wj3m09LHLzMnbpmgIyLEKsR8ypS5kaVyb/ChC
	c66fTsEdWkojzlwA7A88icDiVlqLuMG02iUaJk1HyFV60R1Otv9Usfd9QxrWT8ouddNeyM
	db5lSYgA04fGfZS1lomXoyOswir6LSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BDFE60142;
	Fri,  1 May 2026 07:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834D2C2BCB7;
	Fri,  1 May 2026 07:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777619514;
	bh=Mnyka+LmWryEnh2whF2S1osy42xEfJKWwrmFFfejmlU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=azGSeyiGR0th/MiL92R1fm4aqYEOeltUOOPcLpzkr12sxUmAhbkfv8XKlCFUXbJ2O
	 Hb1LzXjDlmK+SbsmoIlYdJRr/jTVucXxvIu+Dj9AVPXWf+zy4OsN8xjx0TeUhuDsqM
	 GYVTAChod8jlqJJh0oVd3HELRDth88uYNV0QwZbhTrl6xyCCaDN5oPkLboeAtlS28U
	 /jsb1lnuFPXftBhUTyskUyJt6Zk55Um4OyhEvfwpIaiVN3HMLKV1Ld2e1/76Eb1KZc
	 3Cu/SAWR9oqYcIc9CdwgkF3bAx9t1orvCKipK5ND7S5eYHoAG2/dL6ONGO4jsfx8px
	 KrlKa7Px+wlfQ==
Message-ID: <c580340a-48c3-4cfa-92bd-593a95d0090f@kernel.org>
Date: Fri, 1 May 2026 09:11:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: support choosing to do THP COW for anonymous pmd
 entry.
To: Luka Bai <lukafocus@icloud.com>, linux-mm@kvack.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 Luka Bai <lukabai@tencent.com>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
 <20260501-thp_cow-v1-5-005377483738@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260501-thp_cow-v1-5-005377483738@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C6CB11C0008
X-Rspam-User: 
X-Stat-Signature: iyxizgp87mhnc6du7ueqzcfruarrtbi4
X-HE-Tag: 1777619514-509314
X-HE-Meta: U2FsdGVkX1/GYb5KvhRV68ojfSUdtkAt1L4nK6fHs7cssfI2HZhmSkA2THCLs9YicWyFcVl0OhraKVv60BPi/k3kOsg3eyOO4IqfHvahrwv7KlJm3D6WrqjWW9SDP4yyJ5+eHI+QJigT9/nf8TXdVjR718yTAjiAKrwpwaV88T3ICM1yr6SZQ5gekfbb/JiYC3hBWDR9ijcIYq5XQcC+sJOQaCvLbY+ody9WzpJMaZmJ2jep4SawPCaAbWg6rwM40nUY0eVIS4XOtyKssgkcpCa1cv63amwfX7aSjt1dpn/lNDq59qPMPQn1dN/gDL+NCcFAu534HZt7rr7JEtn2vUgj/kiKGPRGNgtiv6+507cfxrmFMKkMSpr2WVQxz5iMJ7m3QRtAm6S1ZX0rESFgvXkeQnvGN0XGupoifawz4ESB0XqLVGP9bKH6p55nRKkv1niSC0RL3eL77i+jDiKaUD+MmPv/b2DnLAQyulnE3KdlDVBaD0NHbxhDKnKBU2MOLyamQdK2pY1qMEY/hxsF5kGMAWI/C3SJ18bacGbCKCTlkTvRDn9rKSKV2YUNObIPGxVWab2bYMxQwXmxSV/WLUxPK9PVqlsi+RXL3bI3oqsxVuZkAQAUKI8XKEbfVqqDANiNq3CqhOvPuKN6pg9kUCauJyrGW1OnrqGKcYRUJ/x+Bz20h3mebJw3UsDt/nsv/yC72X8R+DPuJFZ8LAhm3UhJ4Ra24e7YNkm1h38/e3bdmKL1EXkuqT1rcRaii1SdBqBNHHML5uSu5wFoQdkj/yBCCbmLGOhFVAC4MhLhnEqtKjARDoNQaGfEXCciebGwQSVHLUoGXM+6D4j9hvSNCQhsxzeJipzvbYwcpkGzFB0vPxMyCI6cl5NkFyzf76hFalraGbHjpaetfopq/hPF+H/Jn3cwFZM5C7TjpOL8QMWYK+wOK/OHIHyDpN0T9BFfkGPAn9sBsCELqjhLoJ1
 SgyWGkia
 7DRok5X+3lTuNd4M6sSr2MRczXhfj31jYebhuExP7lAYbfrFN6znWfHWZ7ZPs+a+ZkEXfpBQslIm0XCPtpy2HPvhM3JrT2Klgt7pD9+xX1PCc/DzIo8SuprzMfY7e/j17aRN3eF5cPEkExrJg3Y7Na65ak6DynLozVFpx3t1xKPst7tlHs3650l0O0vA3H4oZQy+gJHiL5X385GTAlb7LMZLXftVvQPRnM+qHAOUs2wj1bxIHX0LdhkkUPiS9RvtOEozG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -	/*
> -	 * See do_wp_page(): we can only reuse the folio exclusively if
> -	 * there are no additional references. Note that we always drain
> -	 * the LRU cache immediately after adding a THP.
> -	 */
> -	if (folio_ref_count(folio) >
> -			1 + folio_test_swapcache(folio) * folio_nr_pages(folio))
> -		goto unlock_fallback;
>  	if (folio_test_swapcache(folio))

I don't see why you would want to remove this check, really. Instead of
"fallback", you might want to try copying the PMD.

-- 
Cheers,

David

