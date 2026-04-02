Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C707ACC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073A56B0088; Thu,  2 Apr 2026 03:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003BF6B008A; Thu,  2 Apr 2026 03:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DFB6B008C; Thu,  2 Apr 2026 03:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD2AE6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:29:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F4AE140539
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:29:35 +0000 (UTC)
X-FDA: 84612790710.14.3CD7B81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C56E3C000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:29:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oEbTGtN4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775114973; a=rsa-sha256;
	cv=none;
	b=iSCR1ThiK9POp4XZvQiQxXvGFpxgdn+kybWImWqsukmJg2Uvk8f5GrrH9rL6y4xqq3SWCK
	PPJQvD09fBTp8bV2woQQG41Mtw9kpfCREOj7/v4zypc5esXWdD72CNXfhsppYNRcbcHrzM
	VjMLd/VQ0uGlcwQDmyMzYgsa7pIli9w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oEbTGtN4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=un64eBoe9ZYFwk83hqkbv0LE9gZ/9bC+pH4+wTurOss=;
	b=TgGdKDzYveqhIpNQRhixhMgPSS4Y7r5NfHxJNQ27SezXkulWCFERnY1t9TCLiJDHr/kWFP
	RqKeFAjQUY2GQdmx2VKpLkJm9y/LOTFPzFDjP/iFHCR/pfdSO1X4z/tXPIp0S5zdLH7//S
	/ydsd7YKRy6bIWpClH1sSrOrTEJahhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0A004383C;
	Thu,  2 Apr 2026 07:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BD2C2BC9E;
	Thu,  2 Apr 2026 07:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775114972;
	bh=D3ufA3GvRxNkZ3yB8Lv5bR3IMcCAL7OlgmcDrikRdDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oEbTGtN44IqKRJuOKKlOiCRRC84kHfq2mQK7+PWn5umKZwWOdqTMdHFsng6uN6OfN
	 Y/iosafqjhE5MasGteYEquxGpCTBCLFHDfarQnGEvookIFUKG3oDXcow6v04pvWWEZ
	 J2cld0IT+YsnmklOONXiGq3BT/K8PQ/8QmLvxTPbEg0oQ8h83KsPcQDk9wlWrwJFym
	 CipGSFex5/XuOH+7XlvWWCcDIMQ1tKZszSGxFQwz5ARh9/2ItoSOChLj1asIuUA5eu
	 h3Zp7/ZWy7QdK0gxS/pPZxyTZWhUoqH8d33FdzfRVHHUUAmyIi0aBCum7k6+s8aOcB
	 AuCfRgAL/pwkw==
Message-ID: <82c05457-d036-46f5-b249-606c4e55f8c1@kernel.org>
Date: Thu, 2 Apr 2026 09:29:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/page_io: rename swap_iocb fields for clarity
To: David Carlier <devnexen@gmail.com>, Kairui Song <kasong@tencent.com>,
 Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>,
 NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20260402072650.48811-1-devnexen@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260402072650.48811-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C56E3C000A
X-Stat-Signature: yr5hebpsj3nw9bswatksypmnqskncisd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775114973-799271
X-HE-Meta: U2FsdGVkX19V+ZU8XDVWyG6KQ3FlNtnZwu3gToK7CHMdeFXVFUXAeIQ5M/MXEaOFfRjEybwRIuWmnmUwRt0pYh12bjBzS/4CalgMRGZL1vOxIbzpt5ouA7Lu78UnzESvBNcAs7sokipyvRkoGsf2iwEhjnv4BoOpPa200puxqx48OQeaOgKCahNthhILdHd89sbunmqpdxTeX7MhO6Cq2pj9IZOFPFlIE8sBHmZL0uNIP6ax0YBpGTIjD5ThHv5sAKVBioikzNSoMgb4R9GShpTBrq/FEs3GnSRRWAb7zzseYdlW2XFsHGcuOkgQoonYXTdv2+t7qW/EAS2uZM4Xra+hSvbg5lGutoni7AaLQjeKIwGrAmCukF+tlInKld97ESQ1aR14ml7WFyiXpTKwsDpcNZTTAjSEomvlwOKW7oDxLI9Hb0kZn8ASEHLKr+X8/6Q5yAYUvbHcRu7yW4gr0VrrPVcFjhVQf7yTBC2V1XfOtHlMQwDmcETAm9exRXa7QSNUhWrnKSlZ7bCTdFjwk4ZPQz0nkOPFfMMPbgUSlONKGHTCBTGBGYHVLTBgkSCpSnRJFP9QbC4u9pcIx6+iLnRFoMPX67y29ITmV11AoPlpzLFQfSPAJtiEJzmskL7ksA1ro+KZHQrXot8cmQtaIV8WfVkONdYT62IUDD2KAxIkI/Dqs7cYseCOmQfGHl7un3PQGgtTRZWVDbQ1v9CdANGkvRmZoB7ROCDiVqu6NhWQ9xyco93JRJqIe2ixpUQaajU8nIx7aVFmDFv4MVfekyk5VSDxcI+3mQ4n90tcRL7jVuOwjJ8rN0Rg0VyGmVFIeuJBUzh+SeyIJqNDO3JLiIkNEzR/hYXE2bsUbopMLeWnwWfMUDz3rsAyaYRkIStxCquUgAqaMPLG9YV3VTwVNZfD+ehHI4aDPKjRggrO1pKbFQcwk120WOwoEGeP7sFH8PxCdIeeJGF0zep+y2S
 aP7IWn7T
 S1R0e6t+DI0WLeMV2XPl144akO97rcyWUIx12gMdM1w7sro6mpZjEx+ZVwGr2LpyJMN+kNu1aUbHVOdKmeNz3v3047xXIXxY4AXGhDPCDBBo4hS6Yf6pPf6rlGs7gMBh+hGTeh22ZWHEH3t4bWpfp+S5WjOCILliwla9Qw6WGUsPbW6Y3ED8WCAeqHKa+uAyZD0HgWJHBYruLZrg2qUaHjiaFwkuzXBZQzR9vmbQJnZ1oH1SCg4a1Tp5vCbcgo9752+fCGwDQkWXeFRcCCBaJVPDSodbXjdAMniI/OV/5doyUb4zhwyKDnOwf5jaFt4hW7b4GZnVZ4LLhebWL7RWpIP63YDkqIRzZyEIht3mvfT/7P8s74DmSKpCsq7/Ae7E7baUyd1kQbPQZkbu291g3Zd5gmfywhNDgAhWQLo4mbJWYLiV9rNbMm1TfyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 09:26, David Carlier wrote:
> swap_iocb->pages tracks the number of bvec entries (folios), not base
> pages. Rename the array from bvec to bvecs and the counter from pages
> to nr_bvecs to accurately reflect their purpose.
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

