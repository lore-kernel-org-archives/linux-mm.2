Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31DCD29FED
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C61F6B0005; Wed, 14 Jan 2026 06:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149BA6B0088; Wed, 14 Jan 2026 06:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B066B0089; Wed, 14 Jan 2026 06:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E57E06B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:13:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 927FC1603D9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:13:22 +0000 (UTC)
X-FDA: 84330308244.30.272DD6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CF1C6180010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:13:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9I8PGtL;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768389200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzUYxb2ZBEYqX/OHgcfN7i9R9sW6zy9ZkhQTYR6yJJQ=;
	b=yjp7kg+GyMRIcl5w7dI0TL5zIrRixcX3LAgLIst7OTi0G90ktolxpYKqzMHzI0lEeMqznt
	I38BrNM9/va8vwL3IS0iN8uj28yw1n3AifmgB+AtD9IB9CR1NS4OlVIX0U2W0I4xepWE9R
	+2drp5CRk5+8GIwmCk8/g8nVA6SslOk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9I8PGtL;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768389200; a=rsa-sha256;
	cv=none;
	b=Ao4u541laaq2OpWmA4OfZqufquT67BB/hhTDO2UaE5mET+V4Cbr4ERoKBJFxEN2YbG7kOI
	cmignoYpMFTyoUcPVVZ3eWjK+yZbHq9TCQ/X45uZSX3/X18P+qSJdkE0OliB+zHrbo5TBZ
	TK7o9HyX2n1Vd7VZM6QeRi3IxbLC1OA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C3AB6001D;
	Wed, 14 Jan 2026 11:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82FEC4CEF7;
	Wed, 14 Jan 2026 11:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768389199;
	bh=OXfU2Jhb5DlsC1S/wbS8RkJ55TIq54m6w773DJVKjrs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O9I8PGtLJWa9DIBRghbCyKURocY6wNLozHNI/XwJoO+Xy5sbuUqV/kQiwg3c0Bny7
	 av+b7ToiQqQRoTZ/M2y1p68hSq6A7m/00VGRElsa8U2FGTmEO/qcFYcG9cDCBlRn4+
	 VWXe07l3Rem4dHGPLf3c5jILT9FIAmwpX8woztHMk6RfMRIkGYaaiLPczGrd73+HHp
	 iewAeyIJObVirsAPI180O76zM208vcADCEHutE9u0ofLI0/iYA/YbH76Tzm8qDqvVL
	 DE9IAyBY6MHrhw5UuIJ9rQU4fFVIwtUdLGGd5SuqqirzqXQnHvpb+TiY8cMJvoUJOv
	 8UhJQMiYEQPBQ==
Message-ID: <a7da047e-0064-4f21-9f8b-fa4bcf40dca3@kernel.org>
Date: Wed, 14 Jan 2026 12:13:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "Li, Tianyou" <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
 <2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org>
 <e9d52093-d11e-4e0d-9bb9-88e0ffb78a19@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <e9d52093-d11e-4e0d-9bb9-88e0ffb78a19@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CF1C6180010
X-Stat-Signature: 5yw46zwgzn3h3tkfg1p7razq1c33wuz1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768389200-761045
X-HE-Meta: U2FsdGVkX19JhIXJR9IJAlwqs7p64P+g8U4ZXYofUdoYdb4IIyZDIiMYMRGOjk7ZL+1cFH/psYShHk8aU8Bffotn2z3WyNmcKYERlbIHW0Lm4kDjZLiki7xVoW4lwIjE8ALm3fxtJuV0TkRIlNGFe7g3ZkLJ2zo6N/FEgjJ+vd2lcZGI7ARXK3ZwpVlg6ZDzxDaURfnUZSHOygJAg9uXYqVFZu5/AWfD+kzOGhnD3YRTQwhGxE1p2VlFhBFqiAROXA/fkGCR9YbqHIG3uKJgLSEe5RDW5VNWg++nJ9l9Cz2x2d7drGlHSEbD3xJOLmntPbvjgN6bz+95Xfeqvpl70iZRNmg65Byg9NFBhCg7CspIfFI0rZ6VWSHmu9f0Jrm8yjTCD9PqVqhr3vGnF9JVObWQGj6U+UihKf9gVmnU4rGejKtGSjJPNbEcGh0jdRvxiQJ9eUrf3coqpH2Oy9AQeth+kQyYM1Hd9s2hxrUAo5zvJ/Jm6GXy1orMkAxOHzFB8JCoUveQtprXBHvDyVfcmk1h8cS+mPQE4u2mCylhAIXpJg33x62eB66nyoGhayGsCQbMV1+MyeLyszZd+WVdVbzny9f2vPl3kWFi4pNtXa1vJcFkpvVOiIWV/jUSZH8ZR4B1FzuErOKzypleYUZTcqKqo0PMBdU+LVRZr2LRqc7jHcvT2VC/U4wbjPBep4TwgZ8PzKhzivk3LWbM0l+SiTCxzItZb/sTtQI8hvar+BEcg65wotnANTaIPaFn8Lng/DBbXsffBRbvqZ9iQv1nqYgnB1FhRlNa0dyT+jpA7Pb65ctj18DuN+4EIgj+86TwDZaIITAqAI4fOYZLPwRX3wAe26jWjrLWDC7oXSDVV8UusGtrWzy63xMrcdS/ZUpLeHJAQLZj+/s8mv/psxM8BcAQoh1BLaLjf9/cby+U6sCER2DTx3lyHH5qNaGcl4UlIYX42t7yqt1xAk4OhGg
 gefINFMw
 ojCXc3dSkwO4s6W0d4bwCPxWjn97D3dSFlzG1bYjb8YamNfiLZVIUsQqabhCK2hmXsHQlmYmcXXsx3gesnkdSQH85ubPoGm668akzLbzJsrfOeIJQLN178NwwpRMJL2nT9eSLF1XSO+Su/iMk95fUmmGeXUGvFDv+DPcbodcWzhXQAQQhX1zNmQ1OwM/dpjoH6udlYcZJTg9LbBDFAG4aCPB5upaChTFFMOwxGjfQWXbSAXvDzxCIWgtn/PKa7PmI0V+QBCWaEQmV0LDk/ED2gWdFsVJuUP9yAWhSPgXKJ2jYfkAl6P+zmmIolfpyKUNhPfvI6/fJaOvkySQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> This is nasty. I would wish we could just leave that code path alone.
>>
>> In particular: I am 99% sure that we never ever run into this case in
>> practice.
>>
>> E.g., on x86, we can have up to 2 GiB memory blocks. But the memmap of
>> that is 64/4096*2GiB == 32 MB ... and a memory section is 128 MiB.
>>
>>
>> As commented on patch #1, we should drop the set_zone_contiguous() in
>> this function either way and let online_pages() deal with it.
>>
>> We just have to make sure that we don't create some inconsistencies by
>> doing that.
>>
>> Can you double-check?

I thought about this some more, and it's all a bit nasty. We have to get this right.

Losing the optimization for memmap_on_memory users indicates that we are doing the wrong thing.

You could introduce the set_zone_contiguous() in this patch here. But then, I think instead of

+	/*
+	 * If the allocated memmap pages are not in a full section, keep the
+	 * contiguous state as ZONE_CONTIG_NO.
+	 */
+	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
+		new_contiguous_state = zone_contig_state_after_growing(zone,
+								pfn, nr_pages);
+

We'd actually unconditionally have to do that, no?

-- 
Cheers

David

