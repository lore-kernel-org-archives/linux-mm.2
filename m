Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C28B6C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBEB96B0099; Mon, 14 Sep 2026 10:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D965E6B00A3; Mon, 14 Sep 2026 10:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85856B00A6; Mon, 14 Sep 2026 10:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A87C16B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:29:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E067AC0115
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:29:11 +0000 (UTC)
X-FDA: 85212600102.06.AEBC313
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F9CB120006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:29:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3Edea9U;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789396150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qLblU+3Kc4+/X9TepAPoRZL2UWEHpF8i+gM8rIH7Q8=;
	b=MKd5x4+eCxbWgEFRTO83FlV9XoFbysz/YpYEO5t4x6OO/6AeuJl39c0L8+1vGFbl62XCGG
	ndnJGQ7bbwin6STJFEPe6y7twZCYEHa29tanooN7/POhGn4TO+MkCEkvhLzrI3T8ddyavq
	Oi8v6cqKPgycrvL/BZfPdYn64ymn2tg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789396150;
	b=3fbrqPd20r+mhUq8/NhLqeOqXP8UZlux9OG0/P3SYiN1hrwBZkoInyLhupMUeRDWc8wd0r
	vVHhToLl3rjHMPiiSQ9FTVhTq9NYczLtMhVKAhZrmCVMdRpI184RqQtKQ0lQx7xmYTkF+T
	cjZ/blVSHSkZBJqsiAr4lgCIHxBaobo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3Edea9U;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B79D760142;
	Mon, 14 Sep 2026 14:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88771F000FF;
	Mon, 14 Sep 2026 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789396149;
	bh=+qLblU+3Kc4+/X9TepAPoRZL2UWEHpF8i+gM8rIH7Q8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P3Edea9UKwT+ny0d7XBx83UgYk05fCB/jMjEhc0B5PYf7aiiBFtQFxjTF3OBL3f0P
	 /KneYLOoTqqD8j4dFYbfF4TjTLgkXMuXhynrDa7m1NcDL8LeHg1HSwM58+IpByfjy9
	 RV5mGB8ueay6JXN6LVNW4BIiPb+peoqB0VpIkPhcGGIAaqnCTMnHoyiHPnALF13ss+
	 9yChybeBbnpgFhhqZfKjnJud3NnMckIL3A8jhGlzmxbh/FXqrGfZrtbwSWYEGjA+Ne
	 VZ6CuMQL5vc3mwZg6fk9tgPsADZuPPM0i6q/aR4gmfQ6/EFjUQ9xuqpqgPwVJ2A+Aw
	 MHPZokLRbC28A==
Message-ID: <f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org>
Date: Mon, 14 Sep 2026 16:29:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
To: Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, ljs@kernel.org,
 surenb@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
 <20260913072312.52111-1-lance.yang@linux.dev> <aqfRCPheDYTgTdAk@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqfRCPheDYTgTdAk@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F9CB120006
X-Stat-Signature: 5c9wwbmj17g97czben8auy9sjxqd79kf
X-Rspam-User: 
X-HE-Tag: 1789396150-629601
X-HE-Meta: U2FsdGVkX1/Py4ff4gCBaOqyKdgE/B6yFfzrDH2MgrL3iYrGzT99nYMK4lKRINlsUxp0i+dsW2h1rZGEVzA8PtJgv+yEeEeAM/TVpQnNuMn4bTuddi+M612odhTCKBAEUTROthr+4L7cd9MAy+n1ojzwiRxgGlaP8NlC0fKzBk75cLVl2OIlEBpqlurED0sUPUbHuPG9omKFThUH85QcMPJ5/LoGRQwnfac9Vv99BGCbh+a7FEpJXjnuwu4T3MxTgg7ErCgYrLRS9Usqk9E8N6YaE47o8oJjWtsxvenGaOU2kP2PclqNUKJydmoqjxsyKTYBJsCnSaeOA40TlFH5WeDYu6+31bHCNvucQkkYnvbRfeKxDDeE4TurHJ1SgBekoo9YpyEeSHrNXTQhhdEUxDi/P/ndf56AUrCwcUrOR7nOB1Y4Cb3np+lEZ2lRugPGSBVaTFZtmQen80LlxaJ/X/Pk1IgCN8+VW8J/cwracqLYXGQ78/EdxVdr9xVkrzK/bJFujKzstRKMtR6vfMbribq4aUGDG9nLAid7CPc2wezLesGFvKo00bILgMJJXhISEn7NNXB8ZzsU4DRypOXMNwlIYwsdAtxIuKFcSw6luduvpcKJTjE/cEgHHh5jS+9mZKT368ydKE6oLfivVs2fKPEA4xcD1BElpRH7XNmowTQjOM0THBMqosMskU+dr1VwYZzx6noONvtEyZMHbUy2GxhYDdFLWM4UTMo2/1Hw0vQT62UkVvsoKTZBIz66+V7OArfcgBBHvWBYh8ZOQLG6EHGty7YiU0TCL/nn4PB61hAmEWftV03bSRuWkin79kmyf0kJJBAtsgWjL9IHQQNnMPye5ajQ5uYhyIoFKHzGyJYcRZX6EtDMkemqpMT5gWIb1mdl3SRywbhlzEPD9Ui38hAemyoBn7tkZGHBfujSis1WabTG5e8d5cHrpTbbw1lozQno1OW8CtoPQn0LyER
 CzpAWwb9
 dCM64OLt8Lvhja+dY6V753YoR6wxGCGbM9rwuIOjNDFpIV79UNL0v/B81lgtJfLSm+IonQJO0HbGOyoVCRSaD8BZOyTJtw4TwbY0tL2fodUpKPqPNatOHS/5Iys6qzr5T7aXUjQsIzXcjtzJhwoqUe2oFQnsBJ4eQtzPkDuH+izDoCmQkEZFDToTuLKlCGnTgcXJLPUUt6rc9/sIqa2gGO4pk7NPjlZWD9SvjOLd+zpkaJ7LYqFIE8I0CTabMpNaAZFftuOGaHl8tx8+ToW/6v89JoEasZxewscp4AQMBhWGzJb8CfkZcfeCA4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 12:59, Kiryl Shutsemau wrote:
> On Sun, Sep 13, 2026 at 03:23:12PM +0800, Lance Yang wrote:
>>
>> On Sat, Sep 12, 2026 at 11:46:35PM -0700, Andrew Morton wrote:
>>>
>>>
>>> That's the sort of thing we'd prefer to avoid.
>>>
>>>
>>> How real is this?  Is there a reported-by:?  Do you have a reproducer? 
>>
>> Yes, I reproduced it on x86 with a small test module. It sets
>> VM_MIXEDMAP | VM_HUGEPAGE and calls vmf_insert_pfn_pmd() with
>> huge_zero_pfn, without touching the page tables directly. A full-PMD
>> munmap() crashes before the split series[1] as well.
> 
> Ah. So there's no real bug upstream, right?

Matches my understanding.

> 
> And I am not sure it is how we want to address this. I don't think we
> should allow randomly map huge zero page (and non-huge too). It can be a
> security risk if it ever gets exposed writable.

Due to some DAX stuff (and others) we have the shared zeropage in VM_MIXEDMAP.
And we have some elaborate checks in vm_mixed_zeropage_allowed() to test for that.

We should do a similar validation, and ideally just forbid it if not used yet.

-- 
Cheers,

David

