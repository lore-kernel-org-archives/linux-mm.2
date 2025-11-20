Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA9BCF884C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 12:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016646B0010; Thu, 20 Nov 2025 07:24:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FFC6B002A; Thu, 20 Nov 2025 07:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45DA6B002C; Thu, 20 Nov 2025 07:24:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFA286B0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:24:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 833D15B6F6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:24:51 +0000 (UTC)
X-FDA: 84130904382.16.35A0B9C
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8DA78160009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:24:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tyQRrg2z;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763641489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrpSiTB/zy6tqtQWNYybUDpdeQBD/EoPTcGuovzkLAk=;
	b=ooe0BTuOHLD7jdoiv8w2Pu10rueVbEDwoDOH7eIWUkLD3fWcLrE2H1JdSrCjONJ3oiO8Iu
	rLQa/EeUJgdmvXWR7lxCud18Zgh2/JZhb8dQLKyGqs/5gEJ43uBESMsoX++oWkUJB9kDOi
	Pvn9V1HAVFDWcwv2quXWd4EIczmJYOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763641490; a=rsa-sha256;
	cv=none;
	b=JssvtQcexRu3tLLcwW2xi3v18U3GpgqQVqkK6Uomovwk/ZytxG13mVsZaofpXhjX5c2+q8
	ev/0UA/wfQYG+50/xKXyEx+1vyT6DTLn4IWOGjdcwf4kmOkpUTLihfG7GqdLjHBQ5CBm2g
	3N+B5NjsIyotdec7Mh3sab0aPEAhwks=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tyQRrg2z;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <ef4a0c2c-62d1-46de-9ea2-dd946857a03a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763641487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VrpSiTB/zy6tqtQWNYybUDpdeQBD/EoPTcGuovzkLAk=;
	b=tyQRrg2zcjxF25xy5X14pftfbqhkRV9KgqB3y6poZGjp7jBlvejZmiwdnhDFkEh0PFyEUB
	zdAT2EGR9n5UxlBKcW5Xq7ycxyefTn8Vsz1U7CdONNUfLMkJwY8LiNL4JuxahT5sPbS662
	W/6wQwaexPBTBRP5Dpik+r7kXm4/O34=
Date: Thu, 20 Nov 2025 20:24:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V2 2/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: "Garg, Shivank" <shivankg@amd.com>, Dev Jain <dev.jain@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 David Hildenbrand <david@kernel.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-10-shivankg@amd.com>
 <6c1d6b80-d290-4110-9a49-53e7404136bc@arm.com>
 <33476cb4-318b-49db-9cc1-a354eca9e883@amd.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <33476cb4-318b-49db-9cc1-a354eca9e883@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: irpqrq5gqr14a8pst4hb6r4d9fmike4y
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DA78160009
X-Rspamd-Server: rspam01
X-HE-Tag: 1763641489-364515
X-HE-Meta: U2FsdGVkX1/4zqu7HoYlITEDyUhWOMK2PvYpMgxjapxAOd+RiRbeUVtmjGiMACJknmhTp8ucrUqV1Sgx+abloUimniIkII9OrlW370d/bC0pFC9dgn2gnQQQ88U0lHHED1JE2563vE3pMCeqsxRjqUesFxWJsrylJ2BgTd2cc9OFZ2gAbCyQ1fXhHEVvg7/cekyOxGCagSGEc57/nXll4gHWGElOpy1nS+mh23fY8q92OfH1K0IPt629ZOVfrf5lLsOS/OdaN19rlsTIUzGPyo16pK7s2jOxDRen1D+HZNiPTR3N7QiFTi9xhxT/9Muv7CZs7ieWhl9N63cdWu0kh44DlpYYyF5AA09n5sWouFU/2ecSXnhNQIEsi1AGuZJJBmg70vkJVfr6QaivESnX1T5favNQTy1izoi5GBNIgs4ZNg+KtTr3jDvILuG2QG6l2Btuk+jF8h/Ua73M/Kgkef10a2/OiuEeqiilQE5oWvRnXuEhGh5zx4OpCfIVYKMYEuKEvN+cHeJ1LfkCgjBrLwKbAWCOn4xFLHIvu+xkjDH3uWCyNrZDl7eD6QpwpTpCumUqZWs9abJUXOuPmZ1UBRroEVCjEA1i0847OXD/1UuCadVNrAQf6HaguUC8+bGmWqgYBtdxMIo5yXxMYpmo8T5/fr8ATZZMdnhXXGuGd6mAdSqc4wPnPV8UYaYHSUY4Ybi1MUbVr660gAwqZknmCSg231kokY1eMYdGiIlGELIQ0fVsqq/8sXTlyP3mYD2nZW3M2Ajt/ygKFayYgFt6VeP4jszMFPgRMfkptgFk05gzUqarr6VGbbYCTeRJlZhmKpp+LK6pe7MmfIwa4MTEhqU9WpKiGtBiJ4mDNI5OeomqNq8YXUkssnNrkPFWRzgvWh4aVi3GNNWsZbo+rmMhrmi/ON2wnuxLgi4VZ4Dk731c1OtBZKbZUboahdU7AUyj2Uz1ZxpLznbkKakPHVn
 jgs+WFQy
 NcN1PJVQkPI2V7XIP4AqGpkM3cWJLoDQap+CJkFJx6QDjblRcJGw7YP4nm4tzjec2R2QRtnsOBmxuwk7jMOlFjWdzSrKsZXlEiEaMU40VTAaarOsg91Tayt9SxTHYrx/YS4+UkdnLRaRMI2So0m3QJ7euruUPL8p50PQWLgZUKw2lWx/qH+ZymCTgFDjM3hWaiBnJ+fiDDLTIcQWBidBdy1mPHPkS5DCyPsd+6mHMe/rveFlNHKDfqmUz679iGfS6t71eLDUcYZWtz7BE1z9IJ27ht/ksifVH+J4+zdePSzyWW7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/20 16:17, Garg, Shivank wrote:
> 
> 
> On 11/20/2025 1:33 PM, Dev Jain wrote:
>>
>> On 20/11/25 12:20 pm, Shivank Garg wrote:
> 
>> SCAN_PAGE_NOT_CLEAN is confusing - NOT_CLEAN literally means dirty, so why not SCAN_PAGE_DIRTY?
>> Or SCAN_PAGE_DIRTY_OR_UNDER_WRITEBACK? Since folio_test_writeback() is true as a result of
>> the folio being dirty, maybe just SCAN_PAGE_DIRTY can do.
>>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>
> Thanks for the review.
> 
> I chose not to use SCAN_PAGE_DIRTY because dirty and writeback have different meanings[1]:
> 
>      Dirty: Memory that is waiting to be written back to disk
> Writeback: Memory that is actively being written back to disk
> 
> [1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt
> 
> IIUC, a page under writeback is no longer dirty, so using SCAN_PAGE_DIRTY would be misleading
> for pages in the writeback state.
> 
> I considered SCAN_PAGE_DIRTY_OR_WRITEBACK initially but felt it was too long.

Nit: If SCAN_PAGE_DIRTY_OR_WRITEBACK is too verbose, how about 
SCAN_PAGE_DIRTY_WB?

It keeps the specificity without the length, and is arguably more 
descriptive
than NOT_CLEAN ;)

That said, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 
> SCAN_PAGE_NOT_CLEAN covers both states that indicate the page is not in a clean/stable
> state suitable for collapse.
> 
> [1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt
> 
> Thanks,
> Shivank


