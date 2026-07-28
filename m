Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D26DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 17:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26CC6B0088; Tue, 28 Jul 2026 13:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8436B008C; Tue, 28 Jul 2026 13:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F7E6B0098; Tue, 28 Jul 2026 13:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D73F6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:19:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 272801C0999
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:19:01 +0000 (UTC)
X-FDA: 85038845682.16.B85AF81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 58F92180004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:18:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jr5mlojO;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785259139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxIJJXiRH8G6oEJFvD03xGAVBb4fzZs8q0QK44XycUw=;
	b=u3ffHu0iyKYIXqu+xHdNvKLWY6vtTCopHYMSeA8QV6yCf7dzEINOtXxIflTsN50OYmjn0C
	be0Q9nytHkYlXj4e/V/ecUtzl2O4+VQwIn3Pa/VaNxnpjrPtkxspspSpZHdDcyzSuz4xbq
	UWKB8c9K0bcaonSh8ZM/mIxwU0jDBjY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785259139;
	b=WApWWXA8M8tiML2Lq8qYSHPwfbnLQYKhGuyqkYaitibqBGgBJQlS83SI4Sdvp2V4aIhw6S
	c/8ckKxg9vhKZk+GSbL3TlvKMEp3C0rNeDBa+wLeypptNqd4qFXNssR/z20jDlHZqOJ+AU
	AFgwL4OHo8+Nt4Kfs56X3P31k3wFxIM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jr5mlojO;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81E2560A86;
	Tue, 28 Jul 2026 17:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4021F00A3A;
	Tue, 28 Jul 2026 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785259138;
	bh=rxIJJXiRH8G6oEJFvD03xGAVBb4fzZs8q0QK44XycUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jr5mlojOGaSfu4ISjDehd1W64iZsUQ1o8xpyez8Pa8rk/sBJU3mGbSuAxb73C23Yj
	 aUE2dT9H6dTSBBwR/RdguOKgg7PQGOLiytrVw4aXpe9JoIJktQ1qFn5PY3kxu7WJaY
	 g+2WTyso/SFfS6bYaWxeSmPDdRn/qO7zW1besvvl50crCZ90lG488FvFmv59GAVzMJ
	 nVlleZgf8zQk3JZPZrhyXU/DkTfVTs1oxamJmLyupwRB+BgRz9/5ERPfWTFiYsRrhF
	 iv5DPKaBurpyO3Ly58+FK3fh6KJ+RdI6+S/UXUU6UbbyZ6n4hwM6itQVO/+LQqZMzd
	 /pgWZ8yipF69A==
Message-ID: <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
Date: Tue, 28 Jul 2026 19:18:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
 <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 58F92180004
X-Stat-Signature: ua8cbyt13zkftjpcsfkw7a5a3qhhqgf7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785259139-333827
X-HE-Meta: U2FsdGVkX18UexzvamZP6lc0qN1LHCqF/iZVC6R4uYFrN8r7IlLD8suX4B+Fs5WnR3txuOUOyfMsBjP6ztir7kOnJn3dDyk2jyvPoyubzgXTQc/+4ZHW4u3bHywJv+RG56Si3B5wZAlni7GmaYKavFJuP9+KhiDvg8vKftVc5PJ4N+uAni8fwgsoUJSoe8Dkfi3eQuHmS4IUf4yLdz8uljiOcAn4dvx8motXChRe3KaE/6I/2Rt2+W3mE7Csp6/fqlop8B25a1Y/AW6WnbDAt3DZXE6S/2KZdAGu9OCBEcJpIczdNKnkD1n8f43V0MqWF6JcOR7zQCqEOgS5YQdfsNfaHnoOq8RdO9ZOlr8AwZBtvhGk+6kD0JjqB/rLRw+JvfZ10XTTh8MNfJkyqF8regAzvgxlb3PsG+glLKxkdyRFQN+9DWwb/5kczStglrLtpKxLOG9zXJXfUGkcQxr901rIb6ut1BWIwwaf0QVhBR6Ia50Iw8eSfIPMWDkYlmKtYcYgqoMEAbeOSPrhx4zf0sPpb5eJp/qKjFC6WKEliRyWCn1K3qfQipPwchSNmD7mczBTfiB2jenNYLTGYy5cFrwdqvvy9ohLk4NojURI4PDokzuG9/KVXkHNmYfIGxDj3EB7LYOJuxidqO4lX6McCelXxJJzttgKdlC/9oOPBr/HAh4ZwJ1kOv3TqYYiw3ELYET0l9t9i182pb8Y3dYSJUD7O/lUm4OnSHKETBGdmzq4zMFM/S2q0pC46fNwK36UGTMU0aJOuhtEJmsbOkHBtmHtwfdfQs0XwV88dR/VNSvocb44s92YINfqwqlgVgNS2eMjZ8ef+V3W7kaCu3uy0paO2FgdTPurdWtxkzn3cqL5oNOxD+B40Q7bP9kTauWEoe4gBIFFUHkz1M84rGtSRX75aEHNqskqfevMc7RF4pjjgLSSKshsES6TbidmwVIsZOc5ZrbSSr+S6ejqED0
 UgmsLJOr
 YrFa3W/A1gMfe08OsRNUpeOn1oYrRsaSLcxnNWGlg1mX3g/+T+hUvydAJVG0G4g/JwOaw1q49RTMP65Ee6HXIfHpIK0+l8xmMMdbuzhYTsmmLpQ7vWzTvIn7WeRZf1oJTF/JFnzl+JFJHLpBC5fqfRt3H+17epp72NqGhsOuH454xEj4nQ2jxgDUnU8sU4ESIV1NT/jD/5Ij5knyMMILzCHMvsiY7MAHbQnExbk5BDqpZZrKhpMSOUNUHSqs9+ZUGaHq9vDPfTg/t4yw3i2dn0mpAHkv47FMhVfN6L33IJh+pq4YYoneJN6UjzhjH2Vj9hHEQTiHkMNL1pn5tfw0v0XbcnOOz0Uwr0ODoquIfyBi4itg/ViO3bckm6QIMPwN5m1RCOd8M//+yeCWu7qJswkLjpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 16:20, David Hildenbrand (Arm) wrote:
> On 7/22/26 10:27, Vlastimil Babka (SUSE) wrote:
>> On 7/17/26 15:06, William Roche wrote:
>>> On 7/17/26 12:18, David Hildenbrand (Arm) wrote:
>>>>
>>>> I still don't like the complexity of this, in particular, as we have different
>>>> mechanisms in the page allocator already to try handling this,
>>>>
>>>> We also do have cases where we set the hwpoison bit, while a page is just about
>>>> to get allocated from the buddy. So before we take it off the buddy, we might
>>>> just hand out the page.
>>>>
>>>> check_new_pages() seems to check for PageHWPoison() and make us not hand out
>>>> such pages. It's guarded by "check_pages" but it seems to do exactly what we are
>>>> looking for, now?
>>>
>>>
>>> Just adding a comment about this aspect:
>>> The check_new_pages() mechanism used by the __rmqueue functions should
>>> filter these pages out, but this has been disabled by default in 2023
>>> with:
>>> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
>>> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>>
>>> So it would need to be enabled back, taking some of the performance hit.
>>> (and I personally think that it has to be done)
>> 
>> Would it truly fix the issue, or rather there would still be a race window
>> left where we check that there's no hwpoison flag in the re-enabled check,
>> and only then someone sets it?
> 
> Why are we checking PageHWPoison at all then in check_new_page()?

We check all kinds of unexpected state, when that's enable. PageHWPoison
could have been considered unexpected too, when the checks were made more
and more optional (first by Mel and then me).

But indeed it seems the PageHWPoison check is supposed to be load-bearing
(hi, Lorenzo!). It's intentionally handled before bad_page() (with a taint)
in check_new_page_bad(). Commits 2a7684a23e9c and f4c18e6f7b5b are also a hint.

> I think we created a mess.

Yes, the PageHWPoison handling was made part of debugging sanity check and
then not recognized properly as load-bearing later.

> The PageHWPoison check is not just a "nice to have" sanity check for kernel bugs.
> 
> So it should never have been optimized out that way before reworking the bigger
> picture.

Sorry!

>> 
>> Also, can the hardware actually detect a problem with a page that nobody
>> accesses? I guess if yes, it's only in some corner cases.
> 
> Yes, quite frequently I think.
> 
>> 
>> So I'm wary about penalizing the allocator paths again.
> 
> I get the feeling that we don't have a proper plan on how to handle HWPoisoned
> pages. We should take a step back and discuss how we actually want to handle
> them instead of optimizing here and there and creating more of a mess.

Fully agree on having a proper plan, because I got the feeling it's been a
whack-a-mole approach for years. If we then decide to put the check back
(and live with the residual race window), it should be handled completely
separately from check_new_page().


