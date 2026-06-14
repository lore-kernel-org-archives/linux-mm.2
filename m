Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B4ACD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 01:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7046B0005; Sat, 13 Jun 2026 21:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88576B008A; Sat, 13 Jun 2026 21:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D096B008C; Sat, 13 Jun 2026 21:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5886B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 21:58:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47BEB165B98
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 01:58:10 +0000 (UTC)
X-FDA: 84876857940.04.19ABEF2
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E18718000A
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 01:58:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uV+74kii;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781402288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unvZVA01RCOsE6OHH2kWfSGkp8R7E0svliMMATKZkqc=;
	b=pCmMIiY55Vl4kxIhIp7RgXOm7bXl2kLUAJoJwc6kHt+2IQbmvDVbUkPT41gd64ZLRuKz/v
	lJg7JzvFBPjIneAdWEI+mhE8RAsa/q7LeFfUJmDp8E2ZhTGquBtf+oO0SLhwS3HVDGdSYA
	xd2o4fy7h1fqbXD8n+2ti1QzTiXnUSU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uV+74kii;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781402288;
	b=tVn9qPyCGjTRTB5b/8J0mid+fOUiwWRXiOevTrb3WEUtSFMa4EvWM1GLAUTnluQ2Ykybkh
	nMtjCKmHXZChIjku3x0BiY0AdtAQlPVwxn0Mhs6NpTpk5Sgn8j7SXZjqGPGE7vGrfblC+t
	oxPUIZlDIO4xv9RKLmyDPcaKU40xxmQ=
Message-ID: <7e57e99b-865c-43d9-9f84-2df3f318d03a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781402286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=unvZVA01RCOsE6OHH2kWfSGkp8R7E0svliMMATKZkqc=;
	b=uV+74kiiC8O0Ll78QiLSnyimuryVlqv+vtUZli3RT7nv9VQ4YcfkHCOLL1GDr0qIVdXw56
	xOT2JhAUExDugrj6ZI0SzwQ3/R2x8j6BUnIkYMwBpQ7nppJx3lM+PQE/MiGSjAGbai2G6x
	OA24y1udqeviPhlXS/0JaLsIirPkauA=
Date: Sun, 14 Jun 2026 09:57:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
 <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
 <ainCu2HZTTdP4skd@casper.infradead.org>
 <11cc4dca-7841-4897-8665-e27d7555f246@linux.dev>
 <aizL_QrL4dNWMJ8Y@casper.infradead.org>
 <661b47de-af1a-488f-a691-82df7add1f49@linux.dev>
 <ai2CIGzlCeqbOz5o@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <ai2CIGzlCeqbOz5o@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E18718000A
X-Stat-Signature: 9sz4dmrrmctp3gjuanh8zdgddict49bm
X-Rspam-User: 
X-HE-Tag: 1781402287-214564
X-HE-Meta: U2FsdGVkX1+xJMnsrdPw25MIZ1QicvHcoCa+uk5JxPT2cy+7Ad0G3T9Uh9MEr1BN/TpSWPxASEIbnZKqanOQ56D+QxGRs7Bi0KUznXKO3a7YIq1jBnWKbaBdfYP3IHhoKeweCEdTdhNu+2oY0IwWH7e53lcdj5cdK+a7THSx/2olfrxVxeILoKSYbZrGFrJwtOgoj3XCJ/J9wJg6sIVbcTijtACMSmvXRbngKIJOWJuefB5bSKn3HIQrg1fMwsnti3eiAamN8KBOd0GmCb+pkbzy1yOCQi4tgXQOL3z3HnsS5wSbQr//Rbow32eYdL7VWFlE7xcX5zzYLszxthVURvXW92kh6wC5ptgQq4sq1mTk1mNVm5te949vLXXzbEY6V0Lm3Mow3ZciJWoupcey9ZnymVOsBWpUW7q3lJ/rxVE6K0ws+u/24qIjYgYD0rJAn1Sf0eBdJm3GmwhuFAPr7iVUoFpMm90vyp0dxZ+jb11lPTPmGDf1wZTnd1sZQnt5deO3RvuCzrMqI6DMb08HjbSDJU0r25hjVQpZrIbeCx8WZL1Ob8f7r/cjGduMjoaiUWncXauub1+Qw1e3JCQFj7JzjRrUpYHK0sRgMT0swJolB+F/n1jC4kwYxHmxjQ1+/GkNjWnbZGBnDT7pkO9uPM0pg0J2nhCAgRb/ny0QQol7BYi2AlFosJfTZcMe/0zrBeNHQXHALkJdOjAN4NYvV3BqixHm3Locn9vfuHnXr7jsD3BK1cndX0BocIvCLPorf2Ot5UrN3AtvZNvRedUeaijAVTo+u7kdnEfsICFdv4AzyAn3B99LqFSjLDbNLaWQ8p0l0wloTPGrn/JbtW/HT9v7JmLKkchKTjrWXXAPhh+iizSmLAoSC6EpfTO+uwLKjZaSU4eRN9NRb2GC4iaLBZKMIQ6hlBCSxYKQ/tihfxkPfTlj61bUlfIRDiJd4JvyU75fJMYG0MwCSJAxtDv
 OmM6Osek
 KlwpWbn+lepzDiOvX2iK+e0XTKCbi0SLLM3EhNVyL4JFpWh/aantpZ/cynBv1kNRF/r7kbrqj3vH3Q/uW80W3KLNqNlwx3XkxDkFVhUpaKQFfi0dmf0drL8HjVLVdBumjf6E4ldYjGah5s4yStX7n/pS4O6gHCj+D8gsmXynhhUEofoes8Y/2ncqQZtEOE08KZxGdFW48GfYXt8oIxOzr/lQyowEnFOgmVDIudmslXg33IzrZ5Z5DGAAZDWf82cF0YD166XcTqt7SEETOg2CG9e5v92Ywk5iFq2yDAvcQIAZWk9KpXG6rcs+eAhxOwsuYSV2c5Pnh6pBxo8Gg8dtBZAzflika0FWsdl05C+lqJ65JseHsTOYr/oSVr+YrXr+KcvCEQcZNDVsktuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/14 00:15, Matthew Wilcox 写道:
> On Sat, Jun 13, 2026 at 12:16:38PM +0800, Ye Liu wrote:
>> 在 2026/6/13 11:18, Matthew Wilcox 写道:
>>> On Sat, Jun 13, 2026 at 11:02:06AM +0800, Ye Liu wrote:
>>>> 在 2026/6/11 04:02, Matthew Wilcox 写道:
>>>>> Thanks, but could you explain why you don't just call dump_page()?
>>>>> It's more comprehensive and will continue to be maintained.
>>>>
>>>> This script is based on the drgn tool, but the drgn tool does not
>>>> have a dump_page helper. What kind of method do you mean by      
>>>> directly calling it?                                             
>>>
>>> void dump_page(const struct page *page, const char *reason)
>>>
>>> in mm/debug.c
>>
>> I’m aware of this kernel function, but could you please clarify
>> how to call it from a user program?               
>> Or how to achieve the direct call you mentioned?
> 
> https://drgn.readthedocs.io/en/latest/release_highlights/0.0.28.html

Note that this feature is currently experimental, only supported on x86-64.
Furthermore, I tried calling_function() a long time ago,
which caused the system to crash, so I haven't used it since.

-- 
Thanks,
Ye Liu


