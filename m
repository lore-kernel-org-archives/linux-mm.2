Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC1FFC591C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4C46B0088; Thu, 26 Feb 2026 05:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EA86B0089; Thu, 26 Feb 2026 05:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6641C6B008A; Thu, 26 Feb 2026 05:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 580C56B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:02:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B121C34CD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:02:50 +0000 (UTC)
X-FDA: 84486168900.28.775E49D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5293FC000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:02:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5mcq+9j;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ32N0ggUz+EQ4Cl4Yp/xkAKLBUsCr8TSpCw1q8krdE=;
	b=3b7oGn8iPHhZXWOdWbZ+n8o3nmgs2drEGffrkBQEbSd2i60m5b4alWaIyji2I08m1LsUo/
	jDmsxLVkqNoUFv8N6VQdFM131a4RM5njp4XE3tUWTsKQmwapPy72Zc3HsNRHp4Ntlmv4wg
	Vex0L/dSmnIQRXYWgBjihtXuH8isFR0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5mcq+9j;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100168; a=rsa-sha256;
	cv=none;
	b=J9cqDsP1GCgIe4999G+yORtmWm/uboMqNaag7+VVoNFF9yX3USqxM0Kj9XhcuCXi7uoJ1U
	f4XUgITAjQkpfLZbdzchxaeLjglgCopX3Uhy2dSRMjykJlsoxzPr2gZA4QrPMCHR4ofy2T
	kV0dT4aq6eHQA3SCBmfTKwmq/HhS2BY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A7B94418E;
	Thu, 26 Feb 2026 10:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2891FC19422;
	Thu, 26 Feb 2026 10:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100167;
	bh=biKqRyvpWuguXFm/8QPIOZ5OjWV5g0hWS/d8h9nLg4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k5mcq+9jHOWQHwCsIwdPytzf22xUG1PXgxXrh1jZEGbut8FBQSnZffk41jdeNMa9r
	 RxCt/YDDTmSJfBMNY6FUuoxqEzsV7QIHEfzVdHXNlRZoxCZ9iZTNvJcTIiuYapadcv
	 FCwvSYs1yjkihMGxMaewrJBiKgzeM5TOMiwZBkYvF9ya+o8JPgNBRQ1J/rI/Tl6Kyy
	 2tjnysSQ1QaNQvG2ArYo5qapPY1hDURLbBSh0nHrPSahNAswY7MitJ5FZCJ9Xbcnr0
	 XlCkAbf+6rQCu5UnaqNY/wAVwTOCV0b+Cn0Bz85PBkzDuIf6alj1usL6I/dg6qN4mn
	 ofmO9koIbDOtA==
Message-ID: <751a94a7-d5b2-415e-9591-a7d97b452d81@kernel.org>
Date: Thu, 26 Feb 2026 11:02:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Saturate to SIZE_MAX for allocation size overflows
Content-Language: en-US
To: Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20260225013954.work.319-kees@kernel.org>
 <aZ5zjIpYZYoc-LSX@casper.infradead.org> <202602242315.C9D5430C7@keescook>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <202602242315.C9D5430C7@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wyh3cxonrnsfx1amw8gz7xa95rdgwyqs
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 5293FC000B
X-HE-Tag: 1772100168-79173
X-HE-Meta: U2FsdGVkX19qTKzrhhiUkhpADUqBet4Z783J498dwDi+whC2D+lyr9H1ktpUPeSxsC/KKgPcAAE9zwR00md9XnLxBRqhsFhh8FcxQ6XRec6beu9lXrPf2IIpQM8ozLBPd18jibnYFmhxdl8JErMWvbdMJE4HI66+L/PUxyIMaoxBOAB0s1shVYacy5RbZWK6NiqU4iubEc+T0OHzADKqsB3y42C//60Go2tnn6LES0G+z/Q16W4AF4z56zd/4Vv42vvncxeWQkkBBcsWLTgc4W3lsvt/tkpFjitaC7EAZsXRYtrZV98EDpYPUllhoruBjmGH6txWlqkM8RpLYBQvbK/Y4i7k01zcGo+G/t1Uek90uPa5o0q4xY3OixhZz4h4d1X8fxaxHQMFXCNFQGZ7lH0fuW2LXRawmf3f89x3KiUJ2uGr0Op4iCG1l0ijYT1Y+Ccr56QDcN3RQXjGDfbhfKR/P9boYRT3R+C0/OWQ1BJ7izXVMelkuKTeNHFGPvnE+JB2TFRigb/9uaVudILDZ9FbI9Op62S2lAz9a79lrOXMiWTfT9Kwbid9Q7NoMZvAT3k9RNfAI/J1uZWnPa6HWUMUfG2i25wcrfqanMYV0kNnlyZy6a9AWKu87EKCJxKiIjmZwnGPHyf4mmTdZP6CFJo07YJIlboa30Hu1h1Sl2XvnrFOoIxrp5AywQVRxne0wWOStLmr/b33Em8hevX1bPwrcWj7wmYOPd5WD/TcYYP61BS0II7DAx5EZIgsk23+Xr8q3WH+NgomYWY1lvQMhzbhSqgsldW/iLhvwHAET9Zc/Bt5ur+b7vMTlqlW288UkHtXfL5Kocw36xYlin7UcCnGWyClxjLFkhES6qrlqNZzqWu3TvGrzPQjUDEN0s2Ac9gpTOfeZeBIyQDTcPgLMB6+1K7onTSeQWpe4W7hqWtVOEviRZTBIDjoLVYHx2Ja8ihfimDekQGhLyLb9Eu
 W6FUbqZ4
 5IJyRSl/HyXGlq2ILhRmoKkFkQJDXf9q0K7njJy6Z/kYkyEZ7jz5BrwBLIZ/qZdYasWYGzzXhBC+4ICLeClVbF1TFmU4/6KjvAltEPuy2wecxYzTVU6ZLIQCJVXbYK4ME6QEAjfa9uN4P/nr0xB5clCQdvF4zrVOUb81wTvhM2z91hKI99udhahb9pkvqZUOKCXysgct3hM86bznCKNbCCwkdNOHChqNbFWGagnn3IcLzmdTEQlJOxCSjFwwV9lwggJ37xnt0koTZErx2ARAbCOg+lJj3Q9h8GAjDifRF1soDiWvEYovwY8awGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 08:15, Kees Cook wrote:
> On Wed, Feb 25, 2026 at 03:59:08AM +0000, Matthew Wilcox wrote:
>> On Tue, Feb 24, 2026 at 05:40:02PM -0800, Kees Cook wrote:
>> > +++ b/include/linux/slab.h
>> > @@ -1105,7 +1105,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t siz
>> >  	size_t bytes;
>> >  
>> >  	if (unlikely(check_mul_overflow(n, size, &bytes)))
>> > -		return NULL;
>> > +		bytes = SIZE_MAX;
>> >  	return kmalloc_noprof(bytes, flags);
>> 
>> Wouldn't this be better written as:
>> 
>> 	return kmalloc_noprof(size_mul(n, size), flags);
>> 
>> (etc)
> 
> Sure, I can convert them all that way if that's preferred?

Yeah I think it's better than effectively open-code the same thing?



