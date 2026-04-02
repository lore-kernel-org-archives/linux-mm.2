Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAF2CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 08:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003796B008A; Thu,  2 Apr 2026 04:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D136B008C; Thu,  2 Apr 2026 04:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32F96B0092; Thu,  2 Apr 2026 04:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEFB46B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:25:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F4179C1FD2
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:25:20 +0000 (UTC)
X-FDA: 84612931242.30.66F0A95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1881D12000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:25:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=freCKJAL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775118319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNTzI8CachCVStswfNgemCfi3inSeAOEUnIhuRRB+kg=;
	b=aZ3+8SdjBHy8RnEVE1EJ7ZQM/EGER8OQSV8dokZdQchiPMAf4nXtnw1Gu2KC66XbJXoTDN
	gupfThlMqxWdAyvZzJ0eLbuTmLi4HJJc0dRHQY06RspjcLOUH72+PgPM5S52n/RWHgmByP
	Re+uYuJkR1CjGMSkTc0y9ZqQSqKn3ms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775118319; a=rsa-sha256;
	cv=none;
	b=d9BHHrgDBpSJWZ17Yvs/zy4/ReIE+6SPyauIA/GF3B2GvPFUe20KA0OhYhlF0XzHwEj+Sa
	wtMHUea6hq/yrDvfRrLbdjzt2bLL51Oxl5kBTh0+WDcmk6kKki2l4fZTKRGEkQI5ZyT9E7
	PWSxFz0XkZqpdutAiMjebp91fype4FE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=freCKJAL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2025C4061B;
	Thu,  2 Apr 2026 08:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C2DC19423;
	Thu,  2 Apr 2026 08:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775118318;
	bh=4nZrhlvGnROpvnnAaCEMgDFtiESx6ozrqiSgxGjxgwg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=freCKJAL/5srsOPPHnZ1/GheZ0Tp9YRXahDWdvn3iGHCEVxv5gpEWtcN5AZeT/nXM
	 W6y9p0tMtNiejtHHEP0cZdNjlIj6byDv8RC/sLXE/gbAPVUW78HgVlhKPq7jMxFm5j
	 5BwBx5sUTnAk6DivwvHKl552uXE8VSJd5Iw/Youfeq+bG7N5x2FxacGqUU+Hv+/Ab9
	 31LfL2Tywjais5WFKJpGDPN3k6bwZghOFj6k9urCxW8wFmEZLqd3nh04zMDyHNG+P8
	 qSzNmLFVyDDorL8kSlizEDLy9KP45J9tJoRcb3nGmp3orKXLB70QYu32ikw3XAsvbF
	 f3Y28yYKvvEPQ==
Message-ID: <835725cc-1670-45ae-bf58-593aadec6b88@kernel.org>
Date: Thu, 2 Apr 2026 10:25:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1881D12000F
X-Stat-Signature: ymx589587ihnfu37ncsf7gm5z4tu4am1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775118318-752784
X-HE-Meta: U2FsdGVkX1/TKkmq1XizEDiwZGEfciIRO2HB0Q4VCjobgOJyIxYlTHIlIJSAmJ1qXBv2BnOE/Dhbta/8V7MT3xRn1nGM1v/I6YtbrJpUPccFvoYDIywhADH0pt1wqPNQiuWaJDq33yhg5dwJQ3l8SdP5PYdTjEDe/qS/B6WNJBWw0rBA2kIkjdh6M/aNNJvuQN/JsMOKlNtzE0+pc8RsvKJbf4j4BTU913ADcGafRkieGkClU5PeoFjX13qlcXIaakKu855gSA7Qte2Oj8zp6NkCNWbDxaGwjlaKABg/EWLqTwgAwV9BqlLN3Bi4fWtzfcxvwOnK2XAFqjaxDcivUle3AM7B/Q/+2ghcSjcBGiEK2M7OqIUeir4gPlUKwRO7Asgl2my1aFtL+w0eF8Ldx050UJc7tozoa9z/FPK1cR5vOeBNDof6xSnYqb50KyVhIr9fkk50vP+2f2KWtybT+oqkYKfqMtvhw5kZHwdrWDogEAF4/bHrYv/CsdnWoBlrhPNwEdPxklqAbBMSl9FPafezYBI91IIwn8e2uqWMOsr7IwblBZBtuLkar8SefHAY03V8exccnZo6aU3awAv9uqSSeyxYxnLtCZ3eDcimzAjdCvGkhNE02K9BVRvxuLlmo9jsMZ3wjOY7EeBpSJGN6PemO9spMu+w7CoS8b5tKRV9lrPuvRuptcAUWXpaSzKyFIt1ze49YWJ/rVrsWIcgSako01Nd+duImKqQS5A34bssbpaw3TB9ELxuJaZU1izPOuKnUYfUrZLAvvdvdRvfPv6U8PCJEC008uNE9ic12Nabp4yGjpJ0P80xWsJht6Xrrx/Re1OgZTLneA7d8CM3j1rrSMBlUBSa97ShSpGaxYaiS6iX+6uMUr8LOOmFpeTZFieb/EvLhkn6StBBqosEgXcDu7kyg7KxLozYUNyj2PLt85fqhkDGveT6fDuAqYysvdl6WgdHIVt5QPdp3JU
 1EGabiVv
 SdKllmjqmswVDuR+b653OYJN0ur8YD3vFX4ow8qdgO+1r0bq6Wi8cXNjUp+a/YTe3it86srCLlDiDxBCtLkntT1FoH3P1hmtGMT6Ct1Trc9Gs/GHIkNpMLSUuzRHJx1hIyutZcPMi95Z4oPNqvkPqLRsUnv0v0aXHiE9YoUKCtNHqUMHLZEKURBMu7o9U9taanlKoysBa+rT+aXBr/9iW15Nt/wzip0xnluOA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 23:14, Luiz Capitulino wrote:
> Today, if an architecture implements has_transparent_hugepage() and the CPU
> lacks support for PMD-sized pages, the THP code disables all THP, including
> mTHP. In addition, the kernel lacks a well defined API to check for
> PMD-sized page support. It currently relies on has_transparent_hugepage()
> and thp_disabled_by_hw(), but they are not well defined and are tied to
> THP support.
> 
> This series addresses both issues by introducing a new well defined API
> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
> new helper, we ensure that mTHP remains enabled even when the
> architecture or CPU doesn't support PMD-sized pages.
> 
> Thanks to David Hildenbrand for suggesting this improvement and for
> providing guidance (all bugs and misconceptions are mine).
> 
> This applies to v6.19, but I tested it on v6.19-rc8+.

Apologies for the delay Luiz (as told you off-list :) ), I'll try going
through this soon so we can start queuing this after -rc1.

-- 
Cheers,

David

