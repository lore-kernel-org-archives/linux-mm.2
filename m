Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C4EC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9F66B007B; Tue, 11 Aug 2026 11:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B296B008A; Tue, 11 Aug 2026 11:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690776B009E; Tue, 11 Aug 2026 11:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39C026B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:24:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCF501C136B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:24:58 +0000 (UTC)
X-FDA: 85089361476.04.0C8F736
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id F0D6080005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:24:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rl5uPyJT;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcdR/udWOVWmDwaf36nf5yccvfO8UVnYIWMO6Q65BHQ=;
	b=wLlUPzhakYc3MNvZ5lToJmNUfQDmpENmilH0PEmw2uW+VjZ5CD5159yB0rVObPvx1hjici
	4rPSyXksZU8cq2Rhx5qvYqvU5AZ2FgarNKeos82SyT5MR6/6nodpiR3kpPLGkTp84P2tcZ
	1URtnJn9bYZfUc1JZTWeDf7uQ3RtnA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461897;
	b=Pp9Y4UIntaRSlUy6Rn4BqpK/7iS0k+0rsuLMlUT0oYvZgNap2hcMR3JZt+bkQgS2IDWfY5
	3/AJmYT7Hr6V3WGVJXonl0Lsn9DIzoTFZRB6zxmjZtmz9CZcusFKPl6Pn4YOtlPhBbPE+k
	VSeIg/UBMBWE9300rEyitZ+I57Y8ImI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rl5uPyJT;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB2C5414A5;
	Tue, 11 Aug 2026 15:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4711F000E9;
	Tue, 11 Aug 2026 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786461895;
	bh=RcdR/udWOVWmDwaf36nf5yccvfO8UVnYIWMO6Q65BHQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rl5uPyJTVmZrjRtJ6ApP9rvVM8HtNAOAmzIApVhofdCiWqyH3iRLBr1WEl/TV2T5w
	 45udCjYJrThhfYSKyg6kwsFWU44uMATst58mLb/HldI9G/mdfDVsfprKLD/cX6Myn8
	 tX+mNiejAt9N62fL8sm+p82cro//bQX/O88I/GFCnA8Cc8VwSLq4Ub58OC6Q9XmKxv
	 oVIPCRDNdjawcVXYW5sLGBTcwEY/HliXy2E5jMs/IKaWcBckJav6VFGN3nAmNCDyMW
	 +84LC+gHmbfx3hf5XdPZvJW7u6NPhNn4OOo/H+1sWZD6EjQXs1R0gRgUesc7cN9jAv
	 frL6Oukda0l4g==
Message-ID: <0a052bbb-4923-43c1-80dd-099ef4c1fb4a@kernel.org>
Date: Tue, 11 Aug 2026 17:24:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH] mm/cma: don't release CMA pages still in use
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Mason <clm@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260810122737.030f8452@fangorn>
 <50b1dadb-37f1-48a0-adf6-c6ff8b704582@kernel.org>
 <007c8bf2717346bdba791e1a5079f4d0abad41f5.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <007c8bf2717346bdba791e1a5079f4d0abad41f5.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gekgtk8pedq8dw98uidj3fj9f8cg1e9a
X-Rspamd-Queue-Id: F0D6080005
X-HE-Tag: 1786461896-175355
X-HE-Meta: U2FsdGVkX198ZLDbkFwnSOGEXmzDtJFe9M/bM9ou3YuwL510qY/kgq4UAKUBdVgZrr6eSAo0VC/kbRYLzR9XpXNHTPPbxHbdbrhjEZKAXAuXAq4ES9utA9Siulr4u4OHp0H+9iFYLQ/8c5Vm0SyV4HJYO17jGIWf6wHqT51Cwfkza1pcnwUPN2xmqS16eRfDkiquYUlXP8lvDtfZHUUosHscc454UAktNbFyypGgV/TcyqPmyAUCpAxwYiePcvUGf4xeSU7kPFmSpcvX0CuRfKiQjNUgfdXTyYkUkYr+ymu0M9CgHrAC2fIvwxlxgsi02NNX18zyEzEEz6u8JOBG5B7llIGOtA37AF3/I9AODt/HWoj3j8Zji8w7zRq/vu4mVlYCee7eyfasW2IVRTEwJWjR3G5w9tGlhT1vfh386bLwG5KahU7MaB8IxzrPzeT2QhEgHFlZw9Dm6GGVR/G6zxhJkgVFHmIRF5gIrpyvzHCUEJItOdhuKwSFWAHnfIbCobXREnM7ZiuTgOrmaUYfQ122xqW/GtyujjKyf+WhYWqKtIN6lfFebFmiX9TUm0iuVLCGssqzPwGtAxJJXAFriRvSud3wvkRXK/JXs7mEP5QyDT+CnOgsp2qBeHbDQoMvrmzIPnulcfIDcRNMtSZP+dduAA8fnTeDiF4P+iulCPUob0i2lVXDExENkRrP+/s2MqUPKYcq2E8Jk+409bNemeAaYcPWWzCgviCEI2AALb3ojHidxCYPqB2wVLQbrGC5yH9De0Mk9m1OlG1vCS/FRcHegjtZcUWgQSaUgFuHdlH2E2luspRgwznTIF+1YgkzTzzeEMrQsBkxl4Sp9TaoxkaM4YEyGjy6HeJLPmcmU2NYNaCg2Zxf6hBI3vTGpAugaj1CwH8xlXO1fTVU9AkhyZYTy1wDWY1+S5h7Do2YraSRcunqvqKVZ1xmPRC/3ZB1uewoZGBSdsCJTSYTrjL
 5DeYutHo
 8xgTGboOSNEkUuVxw5v/0HdWg0oMtbDX4maCt1Ly4YfSnyt5l+Zz7zNBY4nX9JUDrRKTREKW+UTpNcMqpeOnnajFYqZpKMKnKF8jaWG3XwQLSFRGvZZxnxNqk1xsOrH1HHP7Re/0pmHGAWEKCmEN/Ms9R6YRASBYcItNJkx7wBxw+3Ob4CD+EyQa6wogvm22gQ20mkfFNZlNPabNlZ+apD0htkmA8cnYj5Hj4rHa1/4QLm/yE8z0ukGK9YU0iYuBmWQPGWtNc/o+w2xNvONv6X5L6pv/1DnahiMwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 05:49, Rik van Riel wrote:
> On Mon, 2026-08-10 at 20:53 +0200, David Hildenbrand (Arm) wrote:
>> On 8/10/26 18:27, Rik van Riel wrote:
>>> When a driver calls dma_free_contiguous() before quiescing DMA, the
>>> page still has a reference from the device. put_page_testzero()
>>> there
>>> returns false, WARN fires, but the code proceeds to
>>> free_contig_frozen_range() putting a live page onto buddy and
>>> clearing
>>> the bitmap. Later cma_alloc() hands the same PFN to a new owner
>>> while
>>> the original holder still references it.
>>
>> Hm, it rather sounds like it's really the drivers job to quiescing
>> DMA. Are you
>> aware of an in-tree driver that can trigger this, and if so, how?
>>
>> Freeing memory through CMA, while the memory is still in use is
>> problematic for
>> CMA as you discovered :)
> 
> I agree the driver should not be doing that. 
> 
> I do not know of any driver that currently does it, but
> it has led to CVE-2025-37837 in the past, and there
> appear to have been other cases of this issue happening.
> 
>>> +	WARN(skipped, "%lu pages are still in use!\n", skipped);
>>
>>
>> We still issue a WARN, which itself is problematic. See "Do not WARN
>> lightly" in
>> Documentation/process/coding-style.rst.
>>
>> So it's either
>>
>> (a) This scenario is valid to be triggered. In that case, WARN is not
>> appropriate.
>>
>> (b) This scenario is not valid to be triggered. In that case, this is
>> not a fix.
> 
> If a driver does it with the current code, it can 
> cause free list corruption, with potential for
> temporary data exposure, until the system crashes.
> 
> If we get rid of the free list corruption, it
> can continue to be a WARN, since it will no longer
> kill the system.
> 
> If we continue to corrupt the free list when this
> happens, it should probably be a panic?
> 
> A simpler fix may be to not free any of the memory,
> or the CMA address space, if there are still pages
> in use at cma_release() time.

Yes, keep it as simple as possible and complain.

This is really something that must not happen, and the CVE in that above case is
not this code's fault but the driver's fault.

-- 
Cheers,

David

