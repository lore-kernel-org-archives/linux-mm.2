Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C06E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 23:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCBF56B0088; Wed, 18 Feb 2026 18:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79A46B0089; Wed, 18 Feb 2026 18:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B926B008A; Wed, 18 Feb 2026 18:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A26896B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:07:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 411A48B33F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:07:20 +0000 (UTC)
X-FDA: 84459115440.11.7E1E3FD
Received: from sender-pp-o92.zoho.in (sender-pp-o92.zoho.in [103.117.158.92])
	by imf29.hostedemail.com (Postfix) with ESMTP id E0A58120012
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:07:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=WDBrHSgj;
	spf=pass (imf29.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771456038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZFtbSNLOYa5/WuZfzCBsGEH9OpG9aM/P5Wg2d914BrQ=;
	b=LXBnbeaX2G4WFM1Z99wYR5oIsv8VUTUwsnUm8jF12Ne+h1OjtZ6gVTY9iW+BeTCX9yB/Ce
	3yydxPUPwEQoEVLarG3GjLOJWkYnd3wMYy2n/9/l+FB9ogpNvFaxpQrKXn2/8ddYB5qbLr
	3dSmJzvIHhCqooyZ2mTldlX2oUcaaV8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=WDBrHSgj;
	spf=pass (imf29.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771456038; a=rsa-sha256;
	cv=pass;
	b=dqIm09jOe3+HRAS2EPGHyDrocGe3C5YloizWpOwSD9cuHYyr4ApoF05c+lkpLmuXPfqm82
	S//xPiXiopAbgXUtdiasXeUAycC4u7iA94Ky5Ce70Vqc52nmJi+nEf53es0FuN63EqMFM7
	6kf+vQeCtQXg/Oe7h9DhEHUBXRjGOxY=
ARC-Seal: i=1; a=rsa-sha256; t=1771456020; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=LFBCsEkwEoNX1+Kwx2uBhgOVRi9nOT2g0S+IDsPi6cjKTu8MKUaLk0Mv1TnuxwRYKARQERCeP73QO3f4bx82dqLrcnyIF/Ws52kR6fhZeqzGVHiQ/skHQ1rG4jkSxIP5jVE+zslJ9szeH6rL0fDeI/gx0uf1ERmsWEA18TQ9pNg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1771456020; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ZFtbSNLOYa5/WuZfzCBsGEH9OpG9aM/P5Wg2d914BrQ=; 
	b=Qja4iJ3yozdv03sU3rjyga1dxoNqmOmuuSx5h4uJh2qx/aGEF1qaFOk0eR6dCQfZq+O7rnQX4uxxeykPU5PKhuycyf9vRmmJbhNz169KUBc3UbY/aNx9zSd0DjBb+XmzN9L6TWhz/9YM7G6ISU9AGKu5omfEoy3ksmQEviPKJ+U=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1771456019;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:From:From:To:To:Subject:Subject:Cc:Cc:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ZFtbSNLOYa5/WuZfzCBsGEH9OpG9aM/P5Wg2d914BrQ=;
	b=WDBrHSgjfyS3iRrtu8fwfoKyp7WbdjFhHqZjkvafilRna0pbGul/FO6Yz0CuFiG3
	i/EXqsYhpNZL18Jo40UglIKBju0Liiich/P4fhPjl86AiOsdfLRgEdaBdLMTLnpVOL3
	uwRB9IWrj07qUnJBTUIy7m+4rA1AXGKUrQLZZJKA=
Received: by mx.zoho.in with SMTPS id 1771456016192933.9814834405582;
	Thu, 19 Feb 2026 04:36:56 +0530 (IST)
Message-ID: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
Date: Thu, 19 Feb 2026 04:36:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
To: linux-mm@kvack.org
Subject: [RFC] mm/vmalloc: vrealloc() shrink TODO - seeking direction before
 implementing
Cc: Danilo Krummrich <dakr@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0A58120012
X-Stat-Signature: rsjnmum7rh5qrq8pobfxg7zouz8gstws
X-Rspam-User: 
X-HE-Tag: 1771456037-199230
X-HE-Meta: U2FsdGVkX1/dX5dE9dzPemcMya05ChJzo5gbbhhmXdMBvQS7iyNPS6NTBfdmbUR5l5YMSyGHEFU68o/r/wuH0RvdmLGCPcsVd1ObJxSCQK4byX3pTsSxQBp21Oy8cK+v1ntrPfPgScBjwRh0a9z9wvtuOS0pT/+WLC0dvmx4vhtyCDXrrUoPHuXyL/8h0gBsWQugUqFJtrr3bjq3gY8MzCTs5GL80MuPSs4D12BMUN+3WlSbrM/UQGIfsORu5rQS+BWKvOKi7p872COXg7JFHUE3g0F1I6zSvZimQrt/GE7brtXgX5KhwKuNa+SRs/HXoJcZcMGTJ42HunqdP+b9kzvntkFPTQq5t9KAcjI7+5bdiZmhtST0SdMxTkHTnj/Zwl7bwWgIVdP5zZcYPdYj0OUjjEUFfHWws1JtUdWkPi1EMTORSpkWE2CPK8s/O+sNzMU5sw/nrJ8808cLFM6St5sVidW7xM/ZJkxjyn9Yp24r3s/qmwFowJD4O6NxhFH1ND49XwzfXfHCZ6wo2bwoBLtKDLGoq4XU48jDhRbE588wbDgrX7+iv7PZ9Bclbc37YFvjgUFfwAkm3LUZhFxptwbAKBwbMCwDg7Y2IMaplhUi6im61/Go3BfcL+hfDYCtBxf9DBJk4KVEdT+Ic/efsgtNlyUMpgYtYeQo7h5Lh/L/fcQs46D6aVmHwNzdLNNbCh8r0rYNc0IudHmiwLeRMAf86mYpQhIGWeZ7gtq/FZXXpFAIv36B2k2APpvqVxpMLT0q5c/OzfSqctnpi1A7NwMg7vCawbMfbXFm1AhbEqZqN6HIhwM5rajSx6NMXmVI0KX6P0n4jrOHcUUBNZac5MoySonKyJYK2RTT5lpZbp1yUnRUGzH+HndPXBywPAyBCKkyuK3quiuQPubY/SxVHbOtSSi3SGJPYBLf83emu9Wk0CN0Z95DZUSLhpbJWlEhSiwcFyYQXL2XSYN/fLa
 cUSKBtP0
 7cSU4JTh+5cPbO3TLJOjQKoX/3LsqN18TTC0tqm3G6rrjSVinaT48c9xPlOGQbUowh0jWKonUHaVB/xMEo0wYjcUMHo9t/PmJi5Qy4azUibnmqHym4P8C0iOE75P1MSKkyIIFdNRCWp0FJHLBlWuIfKmQZSrbIBWuKjkqjNWhpcYqoHiRzQls728TwaqgJmbiIkfETTYj11IAhN/whsbWPy0GSORetZieRIOQKShq9a8DF2yFgLeHdsd59yTUOYcWsCb3046e7Ccwl5gUkSeZdfqCttJmOGNN/s1nfygGmj8BSFe4LIMfEK5/7CgyM/RbRQo+tUyoOJIdWNOr/TDCkNb0C5dfolreG3jPR+uziiQC7t8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000333, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I've been looking at the TODO comment introduced in commit 3ddc2fefe6f3
("mm: vmalloc: implement vrealloc()"):

```c
/*
 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
 * would be a good heuristic for when to shrink the vm_area?
 */
```

Before spending time on an implementation I'd like to check with
maintainers that the approach is sound.

Current state

When vrealloc() shrinks an allocation, it only updates `vm->requested_size`
and KASAN shadow - no physical pages are freed. This leaves wasted
pages mapped for the lifetime of the allocation.

Proposed approach

When the new size crosses a page boundary, free the tail pages in-place.

I'm proposing to always shrink when pages can be freed (no threshold
heuristic), matching the simplicity of krealloc()'s in-place shrink
approach. For huge-page vmalloc allocations (page_order > 0) I'd skip
the shrink, since partial freeing would require splitting.


Questions

  1. Does the in-place approach (keep `vm->size`, free tail pages) look
     acceptable, or is there a preferred alternative?

  2. Is "always shrink when crossing a page boundary" a reasonable
     heuristic, or would you prefer a threshold (e.g., free only if
     > N pages are reclaimed)?

  3. Is skipping huge-page allocations the right call for a first
     patch, or should it be handled upfront?


Thanks in advance for any guidance

