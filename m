Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2983ECD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959536B0088; Mon, 11 May 2026 04:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E716B008A; Mon, 11 May 2026 04:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843856B008C; Mon, 11 May 2026 04:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7492D6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:14:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A6791A062D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:14:15 +0000 (UTC)
X-FDA: 84754426470.14.1D03391
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 458D72000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:14:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fQg3rJCT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NYw6DEj765vEMffN/WNkiSsDqCiIV5jrI33rfOI5FE=;
	b=QJMP6bMF99A02PF1x1x0oHPCkTCkURooeC1bR0UWcA96vaQiE9gx942yvYMx6GOaXluSmF
	2YWIqGwligVc+zxKJOem2c9MBkOG5Lee6i/sjrsbrFVEGeKAR5ezJ2nkAQ+veQFqoaotBv
	VP6Zd3UGpX/PAAP2ir3jN4092mC1ukc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487253; a=rsa-sha256;
	cv=none;
	b=UV1+3uuPmlWsYzsn0oqACCTSZWN1p8OukDPPWfPLBfaC8/Uo7wqHfOio5JR8+T5gwZS2Ks
	c5tiexGjz+5lS2G7KM/sZd2fzYtNX+cPQGPX50bHq2AX6jXmI5J2pYmxpfjMdkNFYrsL/g
	TrJwNFO+X4yzfL+m6WmebFfJUghEkUw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fQg3rJCT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB53660120;
	Mon, 11 May 2026 08:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F70C2BCB0;
	Mon, 11 May 2026 08:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487252;
	bh=PUjDjANGQPZ283AFME2jlCq6lN9P6W1MIiJstErYF+Q=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=fQg3rJCTks05pFtt78q7Mg8nv9e3Y8buyKaa4bKuhI5Gh5c3BtObc/sSxD1l5t9OD
	 36/5ic5xZhXWCUZN4tJo08Dag3mGVtXDPggJteDS6tqdun+yqNa+REAewjPXqdTmav
	 WhP8+U0H1PN1KCP7n5VEIzFPPF0M5/ZaQXIb+YLP0U3B+uryVzSJAV5qrEUXr6NDWc
	 wOhlby1rrMmA1jywVkq2GPxNghkTLsCu8JyGNPF3lTpowrmpYPGEdBo5Zv9W+DX+TJ
	 vu8m8fNyawpaMeEqYYdFQoxAL7dOsINnbL/7j5UlRvtagbG6qkei7KSqMfATcGl4Mw
	 T/33mtiTdD82g==
Message-ID: <54f1dfd2-d46a-4813-b188-82b9edae3c62@kernel.org>
Date: Mon, 11 May 2026 10:14:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-9-dev.jain@arm.com>
 <95b8224d-3ed4-4fe3-9954-d5ba0aa373f8@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <95b8224d-3ed4-4fe3-9954-d5ba0aa373f8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 458D72000C
X-Rspamd-Server: rspam04
X-Stat-Signature: spzz1ghk7mhrwjfoy7r1b4easq9z1e4a
X-HE-Tag: 1778487253-974151
X-HE-Meta: U2FsdGVkX19lq10MBM/van1Y41h2+w+YXPoUzUx3xHNdh4TmRmJsEnyanevZHQl9wPjiYr4+k7Px5ng4+Wtuy36SImsxxjuC2RWoJphobcpq7Z9MhvaqB3jP+dSRLKjd1oDd+zleWcEa30ADeVNU/0Sk4uqh0BntKfIOcYfl7A+LEv/WV+Dx7mlFy683LOVat81mTvBKK6w8yc22iTPbeUWV5mGTOqYzSR5sBWTAIgT0W7CL+wiulPpRmlKPWJs/TihpXf+ZCQGiEcrbZaCYwK/byPEOFyqmcNMLTt+WgYhwNv0HwUfjF8wwoGPLBRacJgP/xNp4H50JXry7xsToVkaiFPE2xpJfStphSessb1yhueIKMz2d2UM3zRbelntRB4HUZ3L6+qna4421NI5lyLcjn8gqQEOWS3M7iQK7XCls5CFlSDJEGULMQXI05PwSJk0JAhN1CfhG59MYeuoxCSuYU5bAUY5wISTZlmY8rW06Ky4ugsYQVSUpIfKcW0UzbTDBQgQOTMCcmtx9ElrOsPCODVinH1dd4H/OGAeR8JcyU2erZLH/dCMRM+wppPzbkvZ+iwuY2rGWvzPV1LoWHLjZMz73GZUGMPHfLujF/YWjJ61tozJv/1ZcaQC4aiPJfkwP5jRXEqo4x38Au5SW2gSh+zIX6/tJI4ndtHF7MpNKCCHj4XvY5XIBwbP5/E1MtSiwIS3E+yrpkJmntfi27tfcbBh8+Jk5LPbB1OT+zuxZG+t4qJ9mu5aGKDZIGqpqvUtqgcIktl4Frfm7J2uhsHxVzI7JOIDMapnAoFzEw/8Wpyur+EgBf5IQru9OFNHWppnDagwGBm6cCYWKL87OdhJDpmjOz+ADTSdLZGZXWlSA2GkU6oHsS91z+hKjQFpUa9sTlfyhRM1secc9v6PabPl4fM0M6S0vW1roTjqA51N7yFiJ03RyFH0+pvTvttz6Fp+KrIQnhZNzJUTJZAY
 5H+XlQbo
 irCiYeeQUcdHo81rIEYZDRMQ2Tg34GLir7IYWlh1SjnHOAJrMlx42Wo18wy/nTHz+Da4a++H0sN2IHVWcbkvovjGa/Pm3FX7Zun9MxPcJwZzkx7D/mlj4PAzo0r95UHJN/EzqsaOencxahWg29h4Mj0UWu67BusAoXnGMVlSrgq6/2BJ9mmhEltzDJmAFsIsCWc0uo/vVsAkSG1c8f86I1MUdf6aaHqZfUn1s6oPMPf0r8ge/+J2i+YoaMeTtg+fgUwzUBLqolAnqhsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Something called folio that doesn't consume a folio is odd. I'd prefer we don't add this.
> 
> Is there a chance to simply change __folio_try_share_anon_rmap, so we get a single loop
> inline?
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f00..5a1c874b2112 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -708,16 +708,13 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
>  static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>                 struct page *page, int nr_pages, enum pgtable_level level)
>  {
> +       /* device private folios cannot get pinned via GUP. */
> +       const bool pinnable = !folio_is_device_private(folio);
> +

Throw in likely() to keep that unchanged.

-- 
Cheers,

David

