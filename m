Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6B8EE6B43
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432806B0088; Fri,  6 Feb 2026 12:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC2F6B0089; Fri,  6 Feb 2026 12:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEFC6B0092; Fri,  6 Feb 2026 12:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DEB76B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:34:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B379613A0E6
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:34:58 +0000 (UTC)
X-FDA: 84414732276.15.5C757C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EA97C16000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:34:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqpo5pG5;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/irfuX7uCJVsmYxA/O9z0/Qz7lhoNae/lbYuEbQ1b2w=;
	b=juTb38Qz/E73ZUcf8UDCIecjhw41i+GJOpeHk+2Ingo/YUe1iCGAAzOtMU09TLYLQybCdR
	+ProsJ5+8ZSPyS48Dv+XvWjEfa8Q8Et6+4eGEqCgOlym3WOsSH0G/3al6XUwxdMrzuwXm0
	3BMxrw1bOwWoJ+A7PgFKWIhdOE4awqY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqpo5pG5;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770399297; a=rsa-sha256;
	cv=none;
	b=0ui0YY2ClPab6B7KdxhZOJBKIS86xy12zR0c7vd3xpq9PdEMotVJwFxFbHGNBO92DilByL
	bANtMWVh+EamdVkDmqHeVLCtIHOT8lp2zHBbsQvmMwwZgHlZvT5ShOUU9EmYSesNVVdsRL
	Hk2kgPW/QsTfxXYfCzzge6ygGiGLMqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B0746001A;
	Fri,  6 Feb 2026 17:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772A0C19424;
	Fri,  6 Feb 2026 17:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770399295;
	bh=Fd7/Llkqmfgop7wfbm+CS9ZAz+u9xuI8jwDFWTRMZcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oqpo5pG5grIn4bv4i4+unMjGbNGtw8r9VHYM8Q7ZVIYOhlsj0h9hauHnC/PBaznOi
	 4IKy7vebQpkvpxxXK7qZPsSKch7NO8778rXSOHp4r61PGpitZcIlzwRa1qRJ0fKrEc
	 t2soH9OS+GdrpxlW348pFnWc3IwhR7I8mtFyfcT1SxdDD2wKd2YoYze+eHvIsVCPeL
	 RLSSObxjq54h4f5dd/2WXf8TMI7Ki9WB+BLPNp6G4H8Tt8jZtb3jMqv7dYzlNjrZJe
	 11AkUkYFun44f7oeq/8u+6CmWLUCKG4JKaLZAChiQZIatDs1W3YUuV2QrNSQJNWczS
	 2NT/ziHmbU11g==
Message-ID: <5a1cf097-5ab4-41d1-a707-a709de6210cf@kernel.org>
Date: Fri, 6 Feb 2026 18:34:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksm: initialize rmap values directly and make them const
To: Matthew Wilcox <willy@infradead.org>, xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, hughd@google.com,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
 <aYYIw3h35HOqodAb@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYYIw3h35HOqodAb@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f3p51ugee86o3pupk4sj5egcxxmhhj91
X-Rspamd-Queue-Id: EA97C16000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770399296-982738
X-HE-Meta: U2FsdGVkX1+odA9jQakSpUpkrx24G7k7Pqsm4Arxf08V08tygRYn1kj7ZI7e/Y49GpdZtn8SV3GGuU54h1aZD6FSUrelCw0YVuvz45jOCDk/l1cxJpV6hCgEs5Wod4g5/NT4KKppuH99ToBYkAL5Ticda0FfWU5xqcRDr3EsEBve+ITKeYljpJAtC/44VXmftLxryDWlD/Gns9UNlBCz6fuV4hHAA/Rmhz+SORs6YwZ6x+MNZ35RfhYVDEWcXvsc8WdHTdd9yf0HOUowIuU5eJG7Rj14s2r8xXBQ/Wk3mmBXEOc8Z+WUVqoFOtyx3260dyublG2/QyqXahwWHKNhhVENZSK8DqJ3N0/QBFqO/JDufSI3czRvINZWAkLLefEsONKa7kplobac5Ue/MXB1kQZj2jPJnU4kMNdGHBkcBEdi6CD77c1ZmHHCjf8FSB1pV4nP/Do/W8JqwRO63B+4RgFi7SYFrRe8O/ojo51XS7RfyBI1GpAEZ6WKyErKa2wfryqe57j98EEl/P7AMyz6Bzo1WomuwFTQemUs0zxlPQOZ/PiCcmmYx5KbkWPAqQ37eNIZxLVmI517Kwix9g6QuMXq01i9lKfsHUCUgkBrU/YS4zvk+Z2ZC7Yd+NE/66y02QaBWfK4jeytyFnyGEAh+LQXdf+cjjn0KvIgBzLePXtj2/MB+5P+zWfIoWtjrwSBw474IjM/xPygLxGv7W+JvDCiLQgY5X8gbRV/f4y4xGKInoY59n0Xqxa7x8v/BJgj8fmPgcdFsuSar1am5lINXy5O+4GZqcEz22C6gyHp58y6NS9yTHekUAoD9gD0IquaSchudLeiO2tka32gXXEeCM4Co9d9mgI359qnqG4a+Q6RRs0fs1+T4/GMuZp/NxIIe1TSwD/dBJtE8BqMDvTJ5PHeEogfwwN2vvDSOt4AW8y+AubtSWZAElH4m4N0NmeHl5JWCV4TzWklGYMCWmV
 pQ85uqlm
 uxvZw9nQ9JQULAJYGp/zJLuLf6Ky6pqnxh+A82Mk8g+N/ofciS1Ewq71MfJfH1MRbB2KnlA2HX0M93IgNuYokdej1w5eKRAnCSayv8Abut786wXd9kAaKf9+oFvFAJncvFrqnHr1erRNLCpRTVgZeinXBjQuOwDCJjsZdVm7lgrCNxUgap8NTzkXFd8SiwS1DJfLRy1D1jiLngdyDwD3aeqUWI721zlt8Av3u4TlWRhvBv0+2wtHfPlYATD5CFhdFM5nF5YiJ2u0w0rhHqMKPHj+YEXMdC/EPTi30pjEvHJXdbgdBUjF8uwczmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 16:29, Matthew Wilcox wrote:
> On Fri, Feb 06, 2026 at 03:22:54PM +0800, xu.xin16@zte.com.cn wrote:
>> make them const to make code more robust. Besides, since KSM folios are always
>> order-0, so folio_nr_pages(KSM folio) is always 1, so the line:
>>
>> 	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
>>
>> becomes directly:
>>
>> 	"pgoff_end = pgoff_start;"
> 
> How do you know KSM folios will always be order 0?  I don't.  NAK this
> change.

Once that changes we can revisit. ACK from me stands.

-- 
Cheers,

David

