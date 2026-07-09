Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 448AEC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CDD6B0088; Wed,  8 Jul 2026 23:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095946B008A; Wed,  8 Jul 2026 23:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA24F6B008C; Wed,  8 Jul 2026 23:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B954F6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:43:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AD051C18C5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:43:04 +0000 (UTC)
X-FDA: 84967842288.29.D62B42C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3E977140006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:43:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fORSMNU4;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783568582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXc552mwYjfpuM9k+e+PDygtHN9wS5TT7T4CHd6Tb48=;
	b=LXBWqdrD7akFFbvDDVCPssvvpJVCkTS/dfUiDuCu2ISj8Lofic25YfjKPnknt4VzJUuRCU
	aa2GZXqrn+i1d6EkSCFC5aiHytf2KDiinl9trW2f0QC1w/p7+YfGjFHRq69zWPO3ZOMEt/
	j+qNr9oJYolNa7q75ErUGw4QE5SEro0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fORSMNU4;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783568582;
	b=e3ak85SjHaeFLjGuWnXRs7ACtpgPuEu8dFlTd28gNxc3VYwQry/Omz81NxKGHu0iFl/RKW
	Ku7IdlSxsXWzhJN24pVrZRl+MiR7NXX8CWosPIiHu0B85qo4U3SrLW2WXyMR0aZmtNnOHR
	8ac5FBtt58EZ+4qNNDCqX8s2/CujAM0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDAD124C0;
	Wed,  8 Jul 2026 20:42:56 -0700 (PDT)
Received: from [10.174.42.219] (unknown [10.174.42.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2164A3F66F;
	Wed,  8 Jul 2026 20:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783568581; bh=9+xFuPnxLkZ0LODqfBFUwgvSDNP4bxjtxLgzTPCHNEY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fORSMNU4zEVwT8g2U1DOTqFo/8e1uD3a/+wgFinKawPjy16yI3GmWrE5EtGTTnbqy
	 Om3fgqpGZdAW9W9K2WneR6tNtN9+pxpuAT3pHkQ7zr4hGqM6cpZIMsmZvlObiaAGfT
	 1aNfOdNc/3gGQ1w9JgtWFyQA08OcwxSFK7AFLRHU=
Message-ID: <40f1a8be-a6a3-4b6b-bab3-e27b16b52983@arm.com>
Date: Thu, 9 Jul 2026 09:12:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-mm@kvack.org, usama.arif@linux.dev, hughd@google.com,
 willy@infradead.org, ryan.roberts@arm.com,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
 <ak4xw2JwyZk3uTPI@ashevche-desk.local>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ak4xw2JwyZk3uTPI@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E977140006
X-Stat-Signature: pek5atqzdzpqs1gamsc7wbqnqzm8f683
X-HE-Tag: 1783568582-843409
X-HE-Meta: U2FsdGVkX19gXpTMUmoJ1CczHmS2cmTc8KqB05gfMnqQtcHhfxW3/vYlqA9NS2Vqsb5TB/O0+PUNUrrtaWVzKswLhL/wHMQj88mA2M5W1gaB/ed/PmKvVG+8ydAqVMBdYKuHHM67civTAOphA0UF5Nh66rrrqdRCfGfTPXEzSAi3kEJsEed9thn1hVyOA1xabM9vZ0mI4PJ+XOk2dAxfvwMSZIokBLWpMK6My43PyEjv6tFU4sJqMmhNr+hJYprQmXzL2sTcx3hmIpL5/VPLcEk8CizBlP4rRugHZsf09kR6x+YYQmZsrC2AP+FMA1VbHK4vioDWmUTlOkShKe+Cy/k53tF4h0B/nACrpwU6IP4QdjMZV7vOjrrDWTaGnKMWDNcagzGwMbZ8ied1sfu8cSfWt9HlNYIPz7XHmlDE/ullPzo/DQUexY1vfmv17dr9spqkoeWhPqyYq7lcuKEKVNZreeLfHPcG+iXp9+b+oW7HeKpD4K8w3rhF+NbEGf5s6q3XpHfzIBq3YeDX6ayeQrOifw2pjNiMSRqlfHm7fZdsDKFBt++J/4QZ7S3Z9Gtr8me1rS1ly4c50Xg81VvvymMPrHN8LBzXtnO7EGeQF5LJvK0NyO+eSt2XVU6hPlZTHanMj4oU/GMfBZbLleVgTU9XuU5XIgg8iqLtnbWVov1PNBsDSC5cx3ZPOTBofzCKNVu0eAcM6wI0CUIGEbyCeSJSZrfaZqh/sh58yR6SQQsp1fwJUeTf+j5sZrp37Xh41bcoOI1sxvruP3abctcPGjHOgDFeW0sISZT9iEgFAveEod7Fsj7qaNOwVHCTMP1/F/H2V8MEXhin6RcD+kvNjBem1CwWxv4b/kat483xbfcduH6nFWUJh1makfHbKnwQCi9NYEQPo3ouoduWvkxUWsbZK7zIntSke8IxVcnbtP94YUdJK6egxDzPymONW6EYP57aza+mJgOemKzOyp6
 HJ75vg/b
 /i0V0szH+ULZ80oDTLvOlgDH03ysuII7q9iYeeMXQHQolp6Vssiqxs83x5R2xlJupxJ+aiJzEWCu1erAFQwdgKLp+dhA4jkN3wu8QXXMEJKpTLsXr2CldC0TV5ZQiCXHlQ132nkoUElESgDUfW+AmsoG9hrlEW1MgPYXcASQU/9V53j4xYsAVYhxT1gQkD2E+PbOdLxkiziZCFkb3l1tli/0TRuC/wUWyRSuOV/Hx5tuvrAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/07/26 4:47 PM, Andy Shevchenko wrote:
> On Wed, Jul 08, 2026 at 08:58:23AM +0530, Anshuman Khandual wrote:
> 
>> Bad page map reporting currently stores page table entry values in an
>> unsigned long long and prints them with fixed 64-bit-oriented format
>> strings. This is inconsistent across call sites and does not work well for
>> architectures where page table entry values are not naturally represented
>> as 64-bit values, such as 32-bit or 128-bit entries.
>>
>> Introduce a common helper to convert raw page table entry values into a
>> fixed-width hexadecimal string based on the actual entry size. Use it for
>> bad page map reporting and for dumping the page table walk in
>> __print_bad_page_map_pgtable().
>>
>> Pass page table entry values to the reporting path as raw bytes together
>> with their size, instead of forcing them through an unsigned long long.
>> It keeps the printed output consistent and avoids truncation or misleading
>> formatting for non-64-bit page table entries.
> 
> Why do you still use __auto_* instead of 'auto'?
> Please, see the comment in compiler_types.h about this.

/*
 * C23 introduces "auto" as a standard way to define type-inferred
 * variables, but "auto" has been a (useless) keyword even since K&R C,
 * so it has always been "namespace reserved."
 *
 * Until at some future time we require C23 support, we need the gcc
 * extension __auto_type, but there is no reason to put that elsewhere
 * in the source code.
 */
#if __STDC_VERSION__ < 202311L
# define auto __auto_type
#endif

Alright 'auto' could be used for toolschain both before and after C23.
Will do the replacement s/__auto_type/auto

