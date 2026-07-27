Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2577C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DD66B009F; Mon, 27 Jul 2026 10:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954716B00A1; Mon, 27 Jul 2026 10:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CD26B00A4; Mon, 27 Jul 2026 10:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56ECE6B009F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:21:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D306B40752
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:21:08 +0000 (UTC)
X-FDA: 85034768616.14.027B2CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11415160009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:21:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q261pOzq;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8YMIiupRbSXknhF/gUGXduHBqtF9qvx9Rn5OJ7l7qg=;
	b=iVDGLMnKr6WJEbFsE65mkNu3qz6ZS5YiKLT1E4l37PZtSIwcZ0woh7KUh8RTlD8gqUl8r3
	xsPD8vlPtoAm0hj5cgN+pk3tRhx+PcwpBKYYsuNZISJO2XFssaK1VlE76ljQHIxJDtrQ2Y
	VlOZ2iehPUgC8o1oQcii8ysECf2+z30=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162067;
	b=4oOF3RA8lldTw4i1CoR5UeffwzLShcITDHBuJAjR1Ytyq/zautM9awBrsnPk7gD1RMMFFL
	Yo3XFhv1GMEGE7R2G48Ax0WXR07A/sWP5rLX/r3tBJBHfDkZElrdUIwCSmuKGZDdZqhMjc
	EjR3r8g2ZCeKb2akV96W5uBjUKZAqUg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q261pOzq;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A9D243765;
	Mon, 27 Jul 2026 14:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899EC1F000E9;
	Mon, 27 Jul 2026 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785162066;
	bh=L8YMIiupRbSXknhF/gUGXduHBqtF9qvx9Rn5OJ7l7qg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q261pOzqDy+B8Ff3jFanfTrvyKm/idwoi8pMCcZLKo778FlycP7l4gb8vqXlFIFc7
	 88ivA90+P1kxfFJb+iCmup+XTuzTIjHNCLlTSmSr3FJ8XnWzTwL3H2kNTkTwqpz8hr
	 xXkK/ltoTpaxLwaycidA2l5yvWhiSW/LPgVkX5ZfOTPx6PckJujePtwGdfrGnVnv7E
	 4kKo00QcVJkXBuH7+Y1QWE9e0dRmqghOPAHff8HJ1Du0yxihOKjxbh9U0IGPcQdLDN
	 ovKcH55oJJEODbR3xCnO20gApkJEPYT/aK/26PeaJ2xOyAjgoGB4swKj5uvJaACMg6
	 wEBQtVKrb78gw==
Message-ID: <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
Date: Mon, 27 Jul 2026 16:20:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 William Roche <william.roche@oracle.com>, Jiaqi Yan <jiaqiyan@google.com>,
 linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
 <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 11415160009
X-Stat-Signature: zj9cmmw53t3itz4u3meghqf37isw8c1j
X-Rspam-User: 
X-HE-Tag: 1785162066-193960
X-HE-Meta: U2FsdGVkX18aQevFonCKfSMVnVxpyJYN7qIx30Zjyb0I76C6Av0MTo5l9oEfpLQvKNvvzETmDlXCYfr0SWQKz+ZcSORkp3/5RKSxJHTe2gDojnsr42c0djTMs4kcCsH66nWzkQC9Q+41slixgCszNsWulsybaZBhvMIKMsOqVW7cRyjhXb3zD/9LmR4OjiqpHQ93kQ+WqWbTkgHhPRfjhEziCSBX7i1oL9h+PeMSvV0wnC06jTsu/8+FIqZeHtcDYZjtx1fDS6nqbZR71B2l1DqSO6NsUaR4EKo+b7mJY6rtrepXvqkMf+FsLgi6MtdJUXvxAdw7U9h0phH9+zG2sYVbrhxL1HAsFOcYjItdvMEq+FAT/TjPniVLy58iVRaQuAkBcRyYFZAtRoYiISZrxGvEeoNsuhkBTmOz/tq7SNG3Av5k+dcaThRm6/GoWie7q41Aj7wi1cgIugUM0bgcbWTUmsTbkyu9uAeAUSEq9n0GwDVQFoouSL6sl6NyHzbGZ8bQ+tNMqhGjdYBvyWPDuz8hLCmQgkqKjiiSLo4X0WMrOpdfDps/EUKeIL2+wdnQOf7PUYxR580c5lViJg+TR3f9YBwpWvFW4W2gtx1t2TJ01ZTg0IsAfeRDZzNlWFEyk0gYEh3bHrC1AWctdx2G3zVnOhgfZwrqu3M14MAbdys9v7aMJ3Sre5cre/+AbiPzrhh/MYMecUsFmEGfmDxJXfURTsfHsJaH3iR+3bPXI0d7nBroyqI7vIXWJbQ61PlD7LEy0eKPwAevnlJ6zGoHQfKpUmc+arHZaGndqs3RGaO6lx7fUMCFQokuGBz5keYZFPXTWdwdT9Kf8XZiq/8DYbt7u0YBlWWVG0hdyOvws0MPThOsEbS4XS6A5YgsQxAlt5WJF+Oko2hTBFPBPyEihe8WcVIEfde+smymCSeTHKxk9vQZaXabRPTvATDZ4QVAiZTE6e8UjqlR5RgqHEY
 cucBk4/l
 UGZoIiu/GH8G/oooLEsmQw6NZYJQjrYIa9KZCnbuWY0Zy9KPmDZmLFGnyX8zKHtSnWQxAPqXZTXfChdG9hYmnDjrgwEW8Qpk3uFJxexvyFPqF3CFqIO4dVLosUfMIp+VnxcYvnVHQpqrieGe+QpHf1JFvNAXPU3sbZ5tDn4uybhvbcv3KOEGAN9jw72BD8MjUjV2A2CqFKU/IjVE5aJAGqDg01/kjbFuuWt411Wuu4IpDg7X62CZqa+VVKJRsvGokOeZC5w82Q3Y0WvjiO9TwuUz9Pnb1POlqwLgZcMXIiO2BdWgWWeUFMNYFYjGh74K3YI9cy/6DriJz2rOGShELT+db+TErtbd41o+DI9qY+UQBv026yC4wTt0x2Vdk1ycVpnledIBYDfLtrZK+02DG0BdtVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 10:27, Vlastimil Babka (SUSE) wrote:
> On 7/17/26 15:06, William Roche wrote:
>> On 7/17/26 12:18, David Hildenbrand (Arm) wrote:
>>>
>>> I still don't like the complexity of this, in particular, as we have different
>>> mechanisms in the page allocator already to try handling this,
>>>
>>> We also do have cases where we set the hwpoison bit, while a page is just about
>>> to get allocated from the buddy. So before we take it off the buddy, we might
>>> just hand out the page.
>>>
>>> check_new_pages() seems to check for PageHWPoison() and make us not hand out
>>> such pages. It's guarded by "check_pages" but it seems to do exactly what we are
>>> looking for, now?
>>
>>
>> Just adding a comment about this aspect:
>> The check_new_pages() mechanism used by the __rmqueue functions should
>> filter these pages out, but this has been disabled by default in 2023
>> with:
>> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
>> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>
>> So it would need to be enabled back, taking some of the performance hit.
>> (and I personally think that it has to be done)
> 
> Would it truly fix the issue, or rather there would still be a race window
> left where we check that there's no hwpoison flag in the re-enabled check,
> and only then someone sets it?

Why are we checking PageHWPoison at all then in check_new_page()?

I think we created a mess.

The PageHWPoison check is not just a "nice to have" sanity check for kernel bugs.

So it should never have been optimized out that way before reworking the bigger
picture.

> 
> Also, can the hardware actually detect a problem with a page that nobody
> accesses? I guess if yes, it's only in some corner cases.

Yes, quite frequently I think.

> 
> So I'm wary about penalizing the allocator paths again.

I get the feeling that we don't have a proper plan on how to handle HWPoisoned
pages. We should take a step back and discuss how we actually want to handle
them instead of optimizing here and there and creating more of a mess.

-- 
Cheers,

David

