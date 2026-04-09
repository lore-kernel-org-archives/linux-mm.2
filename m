Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 711E410FC466
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 01:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908FC6B0005; Wed,  8 Apr 2026 21:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9CB6B0088; Wed,  8 Apr 2026 21:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFE56B008A; Wed,  8 Apr 2026 21:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE766B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:59:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C0A51B76EB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:59:40 +0000 (UTC)
X-FDA: 84637360920.12.DF55096
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0C47F12000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:59:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="RVC+g/My";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775699978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNbVTRLtlIzgx3xwEx1pceZJ0x/MtL+O8UX1n9LWTgM=;
	b=Lf8hZORCqHWQFEniKy/eRa4aIagZL7FObSOHWbNyRd2FP46sIV4Q2iUt18BP3omXVMF/KL
	zElDl1MgdO45vQDEdUlZ3xL1lEViq3Xcp5ohG+AW3qNBdwMrCQEXP7ZqUU2XKYHxL/rFfK
	H9lRobUfF4GwGZunw4c/ejaOb1z71go=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775699978; a=rsa-sha256;
	cv=none;
	b=DWD8ijTfNkfBi8hAUjk5S6yOeuBEODgAH9XrfyQOqPwySxButMjOxaoBLkxPjOGLMZDF3r
	YklMk4bqA2X16o+nb5/764enKzeA18Yx6X+AwNWQ5dDMV5n7pQ7OXKILOcaOtFD+QC+ETs
	6RJzJHWIQgpwPwVyZIXNgt+X1z47eq4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="RVC+g/My";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35B8135C7;
	Wed,  8 Apr 2026 18:59:31 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BD8F3F632;
	Wed,  8 Apr 2026 18:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775699976; bh=2HrOp37fQxdFB47qXVdNlgwS0HuWdAv82BC0SjBQfS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RVC+g/MypPGtgpKFXu94wOCcPJ3eIBmkEiXHw/lax/gsDseqBbNEtZmJDeS33+zkh
	 wC+Cd92i4lyXqS6rZg9iJMBRJLOEAm+f1YWFMUscBpFSIFDG1QDDxq+6Eoq/SApNkh
	 1NngORXJi74geLZMY+dO5MZP+ze4M+ooDU/mmax0=
Message-ID: <0a466a66-e9a3-4789-a144-8e938df30010@arm.com>
Date: Thu, 9 Apr 2026 07:29:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, David Hildenbrand <david@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
 <1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
 <20260408134923.3a44a703@pumpkin>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260408134923.3a44a703@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0C47F12000B
X-Stat-Signature: wf4yph9zisqc5fkgfskziukz6a87y497
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775699977-378598
X-HE-Meta: U2FsdGVkX1/c4GBeLVvIAnbVDUnDTpQNFaeLUYzeu/5Rzq7ZMX1e+N9cC/E7hjJ9NPoiWl1JPy2+AgeA1nxOHRiAcafSZfg0LzfhQi7+HyM/S6WTIVEDmBL0fajp1rCDC2N+2UMtEa2GY0tPaipwY418cw5y5B97XdmeXL3zOTzjVctaidjTCfqeuC+g4X8laedhHmevSwyGsuei3n/Tr601jMv288Oc7Szwr+OYNBZv1k68vh1uQDFzTZ3XnylUVxhipCOSNjsjFSZfezhhRis/VXFIwId4pU7ynbMPAzT6k/idvx2ZnuwKMpE4fbJHoqdfc3Ln/3cxxtdqEXVGQ5DcEqt2byEVHoay61B6bugqZEkGVUKriCYecGYzKoZMN1PGxhHChStCzNCDA41Jhy/zpkpHKIXPSYwCL+r6/eWbPjHlg634ynADkc6iPTzaNbvrd3gUIaaBAfbxwvVflq4R2W6ccfhvvraHYuXO41XYJ2ES3jBOYgfZYzMmtSljrkYUENQvDZi+kHNK1sCw02hxPnrDx2KUovIPPBAFiqa/gkTuAjeSJyl+IXLZsDXaHVG3AiRBBstAnjoCxedRzYBwpFiLsgNLQw6etsQ2OyvouPqMPyTMT1MSy+9k9Gii4VJwNhcX4tZR7L3Hy6E79rqcwiaS5Bqb0kXFyL8AtwiZ1c9r8GqJPwUSZTMwc9vcA9Uh2XMmeC4y0+L4yyMzs/xq3Oyshzc4FuN2dbgX6naNjHmTKYBJ5qkxV1MRvArOXNc8Pl4OFscBFBDe3nxNgyJDYg0ZRHsDta8ojGk85wGIFOpBpEdM7ccTZL9mqmCuiSaI548fl8P3YYAgFS3lA4WaeNPT3r/oT4u6UzvRUp/FcWUgxlBQ1eCbu+Esda0a8X3eBft1noWYdCJj25UxNyuMbkb1vc9KwwUR/JMW1ANq1LWs6As6pKn2XD04qj/PafpLDaYImwU3vbd2Cxl
 5s1KiDjx
 VD06dTtW3VBRGckFy1DG/dZpYBCi8VEiCH7H5DkwLrS9cwWrO0mPy4K3KWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 6:19 PM, David Laight wrote:
> On Tue, 7 Apr 2026 08:58:46 +0530
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
>> On 27/02/26 11:57 AM, Anshuman Khandual wrote:
>>> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
>>> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
>>> accessors default to READ_ONCE() on platforms that don't override them. So
>>> there is no functional change on such platforms.
>>>
>>> However arm64 platform is being extended to support 128 bit page tables via
>>> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
>>> provide required single copy atomic access for 128 bit page table entries.
>>> Although pxdp_get() accessors can later be overridden on arm64 platform to
>>> extend required single copy atomicity support on 128 bit entries.
>>
> 
> Did you consider enhancing READ_ONCE() to support 128bit accesses on arm64?

Yes although it does not really meet all requirements for 128 bit page table access.

