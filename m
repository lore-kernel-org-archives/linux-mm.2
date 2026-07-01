Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE6CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FEA6B00A9; Wed,  1 Jul 2026 02:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527DC6B00AB; Wed,  1 Jul 2026 02:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464966B00AC; Wed,  1 Jul 2026 02:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4C96B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:59:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B95E8CB2B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:59:13 +0000 (UTC)
X-FDA: 84939306186.19.BFC3208
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C10CC0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:59:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efNSzYIj;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782889151;
	b=xHZg9Arnyp+p6/fr+hdGWHw047BeL0AcOynNOqQoO3ALstYVo76qtZ/UCVJnrG7Q8NNHTs
	86OEY/Z/xBgPIRvL+unkToxP/CiobcpEPzW4A6YWtTYZZgTMJ7nIy5ewrP1IqpUGTz4lc2
	I7PppsgvlaeznxN1oVeT7mHGUHEnD4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782889151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHKGwiBxgYI98Xm4wqDHQ9M0x90wh/25hgRtEh8ViPc=;
	b=Y2Qwpyaib5m7VrXJxLPfYzg7Mizz1h+HETmv40IIaBWjrERbCOZU8Wgtj0TFIMENhx7xKO
	bEvj1NVyJLJCc8yzhwmwPWm+uklJbhqf2d6lyGshZJCAoRDfSgZ3YD3DuYnluLeugwt8PV
	zez3FG+jcmlVckBxqfcqkNKG9pY4eRg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efNSzYIj;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E21F2BCB;
	Tue, 30 Jun 2026 23:59:06 -0700 (PDT)
Received: from [10.57.81.2] (unknown [10.57.81.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7AA93F85F;
	Tue, 30 Jun 2026 23:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782889150; bh=bNAaRztB9GuqH+0F/E4KtnhKwcxLH0iyorEPyaQESzc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=efNSzYIj53fOdbfCQ+VS/foDFbGIMlDjAQsk85Tki62tDxl6PX3g8sjIgZhqqScDl
	 Ht1+a/dP3Do5WlW5d8eaLxsKnFTCcMy47cUFRMxuKVjIKvDjWjoXITqdLtypQRTjah
	 oqmFK2O2B+vZsRz+mGo4ITl1TZFUf9qY4PB8UOSY=
Message-ID: <2b0e5b7c-d2c6-4680-86d7-1db8e0c02696@arm.com>
Date: Wed, 1 Jul 2026 08:59:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] selftests/mm: refactor pkey helpers and fix mmap
 error handling
To: Andrew Morton <akpm@linux-foundation.org>, Hongfu Li <lihongfu@kylinos.cn>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com, maddy@linux.ibm.com,
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com,
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
 <20260630222022.60d0951b90af8857971ad10c@linux-foundation.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260630222022.60d0951b90af8857971ad10c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: trsroegguj3mub9h1resy7y1nnh8ryuq
X-Rspamd-Queue-Id: 7C10CC0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782889151-911824
X-HE-Meta: U2FsdGVkX1/OoPAw8+YM4nUUNDxLn0Q3eqPiPqbEEg+i7dDV9VBGxag/OzDXki+zerX8GtDjvyxfyRNxwYtmLtgQvK6w/uNK+rMBJQVGHOWiR5UqV7umV0Gx9vEWzV0jrR8akoqxsQqwCwq96Uorw5gciY1ul2tGm6cTdgY5UW0NO4SEugaHUiC3l2s3MsRv/fDSSlniu8PN8meQEXHXNSirua+elZGItFv+gEzh37wDgz+7FcvVm0068ZzvXbLfJRUnt37u8C+EQWwkwZ/0BvsGKZYuG0o9loZZqZ8GNhQEV3h48hENp3M5mk7rypUpK/zmjAZ06Oa/0yeZtrNqo6XbFHEfaIQr5b9ZA1NTv92WaTzS67WlEJKcta18cFNcfNeiEKlhAV4YWfpJlmJ7Pf0f5qWM24bpp4ZEUmM9f+iyq0W+B6L5yCeE7YTelO1Dh9Hb6G0/SBEtg+Ei/shwNIezygxxdgU2kDB5zdXtp1cr4Pm8GMxsWaNOw8lBQbF175v3nBPc1WHRtt+qSXHxDbIk7sTcsur1Ea6Zeiy0eu8pwVW+QqqQVPgYuEAiBCBM459wEpOD/49+qIS0DmKY3asJeIdKEjAt/2+Ba37M8jqoCbp7oSG3+n9gbbKoFvEAHXuXL/baYR7hCL1E1YKfvcrypxVmIrsu++yuWXdVNIrNkTE2vn9iJXbFm+ec2cgrSpap3dkld/H8KwVe/3wWbxHFHYU/cz6wYq8I3hYzFJ26iHwdZ/M7Vsdl1Yqh69rUQFL1gJugVQzyXNR1N4VFfKW2ZPc/NiFfWY4zGXdJi/KWQT3uNs7nx87XOO0xWpdxgnmBXuEf0kW34M8zRgUiVwvI7Jnh4GdG14hRHv8lVMDBWx9/fViKg0Eq/GktdcbPiasRemL0VDEE5EfXOYd2wQEfV+eFc1qNJv/uIk0GZDUZu8JPnm9ZjhnubjlYXPzHMhnn/2X6Aj1CeKC54bE
 N4d8EFSn
 WKtln5IW311ks2KbjihPZCs0WhkzSUEXTvCRbbYx9nUr9hmSyUQWnOCXq/dR+dcStf/jecO0rsf9oKteIdhHemqzN0xWb3BApy/smd2zLU3X48E761UR9sbOetaNe0UZhLFk03WV1zrEehQBomp5ArLA8FrgiCmkWnhj7eo2HFXv9Tr+a2gs0fOb9s2RKUq9jDIeusxkbfbFvcaoUYmURYaBANZ5jr9NwbyLOsFMG/WsdstY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/07/2026 07:20, Andrew Morton wrote:
>> v8:
>> - No code changes (relative to v7).
>> - Updated Cc list: added developers identified via `git blame` and
>>   `git log` on tools/testing/selftests/mm/pkey*
> Kevin, if you have the time, please.

Sure, planning to have a look this week.

- Kevin

