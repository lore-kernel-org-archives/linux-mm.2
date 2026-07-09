Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94CE9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326E76B0088; Thu,  9 Jul 2026 07:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7F16B008A; Thu,  9 Jul 2026 07:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AE46B008C; Thu,  9 Jul 2026 07:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D55136B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:12:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61034140122
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:12:39 +0000 (UTC)
X-FDA: 84968975238.18.4279C1B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E99E20003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:12:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Np88rsgt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783595557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4VR9figtDCsS+palCDnSahRPrIBp0AIAHsHtsLq69k=;
	b=ulKt/s5i5GjvPS035+y8aR9udYQPH6IPl3LgFhf/mzGHKZTHw+0Ysows1S0u6aH/FKeLn4
	LECASd3iLAi/8fRVtiwBKhhDoNZLcu3RxUrmJ2/ecDYU8ix9Ry4rSNRBKAZDs6AmNU62nQ
	YvxhHPvPMZSci0hdV3k+1pgBKzOFFXE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Np88rsgt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783595557;
	b=QclC3BMfXqF+i3fjxFRmj5jn5G/lcZWSA6c61vGYqDbtEGcOsJwev8NOi9pqFbPemXTzMP
	QTz0siTd9aNhK+3O8q5zkuCP8oLRSDdLYDgQxlUOTOBFd1TdC4jyySe3rqGhhsDLQhv4gl
	E4/5sVTGNtS3d0SA8ykD6hl8fAaZnCc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E401F3570;
	Thu,  9 Jul 2026 04:12:31 -0700 (PDT)
Received: from [10.174.42.219] (unknown [10.174.42.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BBCE3FE53;
	Thu,  9 Jul 2026 04:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783595556; bh=ndofg+FHLcXbaZ+NoLuggN/AiIw9lURC3R2d0e+fzXo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Np88rsgtZjjopyeDlMeens7x/4+xIy3dlsldVZrnslOla0EFQrIdqzer0er2ZpCxy
	 qecOd4mhhC9oCH0LbVsC+DYpYsWmr1XC6OtUM2RwlBToMkqYm4xcM8rfVjYjPXhE7t
	 QTJZQEKinNzJUQA39rDJ6+h9rFVAndDZ5KGhxnYY=
Message-ID: <f2b27d81-99cd-411e-8fe6-e9a529f3b68b@arm.com>
Date: Thu, 9 Jul 2026 16:42:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local> <ak9mrw37kTORZXmc@pathway.suse.cz>
 <ak9z3ZRdRqGoOu-T@ashevche-desk.local> <ak90WW3I4tmg7Pwz@ashevche-desk.local>
 <a23c0ace-b52c-4f28-9f40-d0b6dc4ca2d3@kernel.org>
 <ak97RtqgNMV4O-D6@ashevche-desk.local>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ak97RtqgNMV4O-D6@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1gdeuszucp99sq4ijkcz5gup14gwsioi
X-Rspamd-Queue-Id: 4E99E20003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783595557-46591
X-HE-Meta: U2FsdGVkX18uWWh7fI4KfWs0vZZRWw/SH9hLxbWGiHQQXiIWSLI/MfGKEuGIdoBra8VePs2u6bUUnhjNKSN0YZZOPlI8J/2ajZeNqTUwCWpQ9mDSg1qus44a/N86RBWE+t8QNDyeD1xEDlRqVBE2BBaxgkMDsb8mPJz8EYyiGv/pIKdov/YVFKzISupLou5TtFfomUF7emNycF9rJmo/iWd/ezZFJSIqTrFNyFBsujL9Xd14G++/Qfad62yuiKb09NPu1pCwvOwG1/57GLao7obJNtF9fLlFxDqgqtsOtuaulBYenz3eN1MJg8uNeejmGrfl0+2OXJBR/uxjQvrvR8/bRn5xcVQsJScPFYbA31qTZ+OVMTV452uroJ28qrsY9ViFr320eSnCq4rdWz8CJqQAgYxv/Nxk73ZZF3bFvgNHHJT5Ctj8zCKPKfbJaNTQIZsHyvEwNXvpUaYv2nJa0t+/HVhBpO19Lxlihe92n6DeQDc//Tf6o4bba2Pl79/X9s9yWNYAoxjewbYbpdo98zxTIxo+0s1hZY7oQww0wXm+I2gap6SvNN8lMsBgHgZjCSQdbBrgqlGXIUWKAu6OHWKamD42uJN8qRqjP0X7Eai5mld+xke784I4R/7Txss6M+F/gyLclWbSL6xUu2ywmAdgORGf/cMBGCvuTdaEo9YAVT5J/VEsLmpnjaG3BRsB54Pp2/FvoqosRYgODtWuQTvEoIKFdrnjHt8f4b5S3J3/3kRP1abQGQOnpIRGPXo6V5cPtQwhOLXNQgSOKeZHdAQCnTjDXqTemM+ugF0/cBjULtSYwdZVheSUs4UJMNazcb3ulkuw3Xvwly8rbgxO16xOy+i9iDvGxG8PwMbq0de8eu3NVRYJistxLXQjhJx5Eu7Vk2iwjovaERZis/jOzyfVc61861v/qyAyY2bStNbZldodM3WGJ6bfNCUIUbFI7S6sfN5Wo+I+GrcOUla
 dt+iJB11
 BEHhSpoe16IxLKAxHr4A8X54LgWF5+RXBTFv9uYDcGB92hvapYMmXn7Q9wm59H3uTgO9rnttOtDhiUdyPg3hggcI1rKBBYh78ly38phDXkS4/SZ5cYo+ztc1KL5QqZKBYUUZOeBoIJgPvLT9Kc2D3WrYjs9eG3zz2EhMHTRjD40WC+F8T5ZaQ3GsaFOQNoR399M33CfSMPR3Gzx7n50Tu1ecYjpojTTLAJ6Qe/d3aywzeCBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 4:13 PM, Andy Shevchenko wrote:
> On Thu, Jul 09, 2026 at 12:24:08PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/9/26 12:13, Andy Shevchenko wrote:
>>> On Thu, Jul 09, 2026 at 01:11:46PM +0300, Andy Shevchenko wrote:
>>>> On Thu, Jul 09, 2026 at 11:15:27AM +0200, Petr Mladek wrote:
> 
> ...
> 
>>>>> But maybe you had something particular in mind.
>>>>
>>>> Yes, I was thinking of a wrapper on top of special_hex_number(). It takes size
>>>> as an argument and hence will work even for 128-bit cases.
>>>
>>> Okay, the argument is limited to 64-bit in there. But I don't think it's a big
>>> impediment.
>>
>> Rewrite number() / create a new 128bit variants to avoid 3 simple snprintf()
>> statements? :)
>>
>> Hm ...
> 
> Since it's slowly spreading (I mean 128-bit types), I think sooner or later we
> would do it anyway. For now we can just have a wrapper on top of number()
> (yes, special_hex_number() probably too special for this case) to print it.
> And yes, avoiding sprintf() in this case seems beneficial to me, we will have
> one implementation of how we print pointers.

We followed this approach in a self contained manner inside core
MM in order to avoid adding new printk format. TBH don't see too
much value in again trying to create factored common code between
with lib/vsprintf.c As David mentioned this may not be worth it.


