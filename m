Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5FF9CA5FF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEB96B017C; Mon, 19 Jan 2026 06:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6DA6B017E; Mon, 19 Jan 2026 06:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F152A6B017F; Mon, 19 Jan 2026 06:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE1836B017C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:09:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C243140723
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:09:15 +0000 (UTC)
X-FDA: 84348441870.18.6F95FD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6F4DDA0007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:09:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRf1Owty;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768820953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgbsMPlOsBBIWFXTEs+hlklNPcpDRsnhZvhpRicqSSM=;
	b=YXQVvQDO1EV/Te9UWqcpI+EFAEkmcajqInjq9GNwpPzxZNoBn+o0UStYZs3fWZXwUztZDO
	crrEp+/S7tYxfEM6aHrS/Oa6M+4FaJer5fc0ZvPLv5s2r6vhIGofq+gnEeW5nmG09jqskH
	cwx69az3faJ+DoJX83+1KMF99Rh2iPk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRf1Owty;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768820953; a=rsa-sha256;
	cv=none;
	b=3ZMkTX7Xo1TFroYYbJMGBtZ+w7rmkplXHMWIA1qgYN6E27itpif80FaWcUuurV5ruiEvVF
	Q/TJFQJLDR5pDeTRL9Aj2bMj+t0ktnza42gJQfnRLvd4qy2umNAqf+e9IjyEhPpqqJWVoR
	bMGvTcRpilOkpKxxv8TETxBOK9LSnpU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71EB5419D3;
	Mon, 19 Jan 2026 11:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D0DC116C6;
	Mon, 19 Jan 2026 11:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820952;
	bh=rKLM88gxUGPocmEKu54kST8HAh1vpFomnsnpw5ncF/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lRf1OwtyxAECl+Eaa0182Si5tY+rpvdgdW7IC6u6c6Jg4pURVBtxi7oU8rqXZgFdG
	 linyfrNplUxCtEvNjGwlGetPNAuoJeCwq/esuWIPehYSaJ8kGS0gwvRK76cc60SXEI
	 iFwbMU5/NKYMJyQ9SICvxnoGXNDkRBEyHvlmDLAbghYwFvS+uNdOnnmsD2mJ+NsLrF
	 nzdhFMKGkMwQkj7vnuhIfgrYZWpuAegrdB4UUzsTZ/bl28qylovIYP8KeC5hIPev8I
	 9CCPg6Ud1HTxwpXK4KPV/wvvtf9h2CXHbWwIuGqPzSvfLx3xZ1ZwqM9H0YoJoe+UwU
	 2QC9uHpCDYptw==
Message-ID: <cd9e1fca-81ef-4eaa-aea1-aac6dd00623d@kernel.org>
Date: Mon, 19 Jan 2026 12:09:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] selftests/mm: fix faulting-in code in
 pagemap_ioctl test
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Usama Anjum <Usama.Anjum@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-7-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107164842.3289559-7-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6F4DDA0007
X-Stat-Signature: psyhdmih9k3phm9cscdt74edxcwuksy8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768820953-915625
X-HE-Meta: U2FsdGVkX19xan0LbGQ8dQ9W+7M7ObMsySySg6T7KsKl4UIiSMMJO6vjrZoTWmbcp+LT90tFdjRYQegKc5G9GF1mvKrpo6YJFESJ8xWTQeWZ8snpa3BVWriwiG2R7NcLZdSxKpVvZqFLZoJ+thJZULgvFxI5aadmgE8qZIA7jDYkcLnB8QcT7K3H7wLccl/sd5SsvPBpKUMtdAP3UzCb4RtgcHBXE7re2OrWVNghtvqqrPA5nwTBAxpels8PAfnqsIJKhgZrga1qKN6zTkfDt2O8Mbxmaie8Cp4kcuUmjLvODZVLlrIPEjonxcc/QXQZecAczGErBvrbylPDB7Hlql0cMKmfMzK3i9fle+Ys4Js1pXzs4E1dyoL766WrufCcnf89WWQphkmhzVqo+w0N1fQbj1FlXrrcKr+iHVBtd2CWm/a1y8KBwsrN4aGY9mj7o+oF/Tb1ZopUvnfGcZmz0KIxkn5675a0Hp/QtBMZWj5fgOvZLlUX5vY7/imRSLMKXsynPpRo4Cuc6lbZqBsFZ8pYJxZXMAI5MKAb8DdYBxaYr78QNdk6jSuN2mpPZhHj8TQQ6WOTzoheWi9R+78Zb8+7AmOWbpHiSJG7fAGD2boUM4qouG3nahyK4MfwHChwZSIaMTOzhlTQMdrBo+zN+wovM201kXWUDonnuArWQRBfO0MlpgXKNaNM6IDRetBy9iBQN+lmsQd0b2ipkgYjljmpR7VLRy3qNv/2GWPQCpug7oDMcFLJB3ggHUAfg7NSM88gRh7IPPLEmIE64/JSWKAEEcvUsZ7olZ6vCTI73C7Q9nZdNkUw4dlr43IxdypFnch8w2jxh99G9A5NvsOwmDecxjCbupDkIDJUTgD9KqozG0Hvo/gDxTrI3bwqXaI/0SKrwmbV9DqvaTiIoH9owQEVDJIv0tjbJdwcw6fk2E2KH4qiIP/rDKIFvGOcb8juyUTNCj+xfcw5oVCx9sU
 nuSm2LLC
 rItnvT/H8EGCV9SUta+4xdgDLorfGV60nl2OqR5rkDWkb4bUEOWr5vTnhjciQAUSOQHYloV0z3t/2tPrq1qaWpTlJzUWSuSTmhJR1VKN2+ehhVh6TtPFOsXgpMlk9VCdjz2n2+tpGbswEAWAaxNm+Dy6gB3dEdH43ictLMme+iD3aDZj+j3dSJsyVaQr4YkxGm2vKYXO8bHdmZFAK0lnbbBjTvGbY2ExIt+LYBwOsFuzIypHBCxcMx4rc3oD8SPkL7dTNFfH9T+SE5UQW+pV9RrUJnpuLWDyim+uX+/ld+rVsPaGnOZyVHGaReKZ8LPDqYc+dcemHYrIJDAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 17:48, Kevin Brodsky wrote:
> One of the pagemap_ioctl tests attempts to fault in pages by
> memcpy()'ing them to an unused buffer. This probably worked
> originally, but since commit 46036188ea1f ("selftests/mm: build with
> -O2") the compiler is free to optimise away that unused buffer and
> the memcpy() with it. As a result there might not be any resident
> page in the mapping and the test may fail.

Yes, I assume so. Using FORCE_READ() etc is the way to go.


Should we add

Fixes: 46036188ea1f ("selftests/mm: build with -O2")

?

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

