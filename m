Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A004D29FF9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85BF6B00AB; Wed, 14 Jan 2026 07:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D0D6B00AD; Wed, 14 Jan 2026 07:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35CE6B00B0; Wed, 14 Jan 2026 07:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A10216B00AB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:34:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DC60590F7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:34:06 +0000 (UTC)
X-FDA: 84330511692.30.8DDEF53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 910FC80013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:34:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHMW9ELs;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768394044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4fxDGkJ1COpEfs4fY1a9Gx0b/7xeRqG565p5ki+goM=;
	b=LJfPjDXKfnSCBkpg3YLYMkWyo5zHrZ4HXCQgd73Snc4OB0Cq5ZozJsBYEpDn5JNIedW/yZ
	8vr/lNnQObkN6FcWwAMnma+rR/qM0Ngv1ZONJejuCVk+F9nZsy4ib6nXq2bUm6Ki3S79Mk
	NWhIXHEyZCT+hhKAMDNsbPG/cxCKquw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHMW9ELs;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768394044; a=rsa-sha256;
	cv=none;
	b=kHgyU5cRJkjZ0t9bTIpMJrTKzbmcLFWKOEuah2qpZpIcBPsRkB6sVTBVKWqljXcNVrpmkK
	AK9SOPVRPVHkuGGlVGhElNBnSxzoICV62A5/NjlSfKe/YHEPNhATZXyOynvusifoTfe+Ka
	eSgjGlRfGyA1VzYtdVlt4+3+cUokitg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00D736001D;
	Wed, 14 Jan 2026 12:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA9FC4CEF7;
	Wed, 14 Jan 2026 12:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768394043;
	bh=ys9Z38f6Y6o7m07b4bNBktaqcRj928XOOy+6g1SpdLc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uHMW9ELshB5+oqMK9HOY1STYyJFt2NP/1+UxQONqAwFCb64OIicSVpvCHoS6nxdO8
	 spSHGbQ1TBZ0NqTrA+LVfbLJu0i8YhlcX+UY73J7YufBN7GETK6aUZdS7ghGbRHvnQ
	 8VymyDGHGkHBnEDe0wyBFLO7J+ZqLv0KpNxLOEciSIszKz74SeBlciXlM8yE/ARNMq
	 NQMu6N9/8ZpingNitvv+enlsZUSyGCrIrsba12pAYj6disWQimMTFj01yqVW6cM3EH
	 NB4lHUqqJcOby8xjY8vQIJJHnUPr206f6nOC//D6uPR/j12ZGBAJMfD4G+E8qMIQfJ
	 HnE8jn9dEXz4w==
Message-ID: <d9fbc00d-182b-4463-b718-73c2f0eef3a0@kernel.org>
Date: Wed, 14 Jan 2026 13:33:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, fvdl@google.com, joao.m.martins@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com
References: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
 <20260114113635.97621-1-lizhe.67@bytedance.com>
 <97413239-2bdc-456f-8511-65fb9f1e301c@kernel.org>
 <CAGudoHGb1w92gn89BBuMQOmvcVZkwvt8CK8hFtGg3xmHphmiEw@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAGudoHGb1w92gn89BBuMQOmvcVZkwvt8CK8hFtGg3xmHphmiEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 910FC80013
X-Stat-Signature: iki6rri1jgeef56e8h95kays3mkyj3as
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768394044-193554
X-HE-Meta: U2FsdGVkX1/Ao6u2lRbnzXw/kufTuqzNNkTstEM1NmAgpmMv9FKc/S61ibqPgmdPZaUYYBkBjOKPJvBbKJlz5+XYBSCMEwxwLJzDiDBa0WwiEffDGQ/W7OyrF/uGf8CKR9tJr/mmEdVi6QW9AbYk1MkA1ZiUJudRfrDUDWQ0rJsE+oLK/nb2v8RYYQIDOCK3v1jbgQSaPDC+6N5zb27XMrQrG47LDI1raFUbhzbU15v0YLsoDL9SpQV2KK6xJpHeuTfzX4YhTq+corq2XVTZ2h/qUJsAPVlCmqu+xE/BP3qI4V+sDyUS3vsrdOf0M5/ItOGD7mkBUL7aY4LgxCG04vFj55zV1VDW57whi/P2/JfoYUsXn59p6OXjBqepIa8A4/QWZu48nrxN7qZQAH6mhgB4QYRLVn1CssHAtreXEQlBsfmaNzvQarYOOgisvL/x0VH5+eH/uSg4AQXibmVmdmbK2DLJ1bVyR1ajonW3a44JDQCK0qUMP1+UlX2kvYgCCoFNuC7pDdXjm+OKT0+B1Tfpj9X/QiGSkhx90RcsBFhbpuH505yBBxpKoBh3+ZbYWIIgwPgEm9uc17/l1NkXwoUkl5yn9KnWfxC8WIBxo6a+059ZQz0132d/dZgkP676HNVgJjRbCcDxMVxCe2ZJ9m3IhGqy0dCPbppPSa9Sz/NNw8yw7JMbmRRO+/fo8ZPXhaUKkdb02jDmRdBwdPNATYNlLpdHx/Y5ywZoQGhF1WjmZhXGJ9IZqqsJQEfwxQR9vPoUPuDQ4EbT5jc+AgrHnVcnyM+0k7NRLbz+1j1SEg8w6WBoxqbNPdM7crxbuN1eQiw156tJvcpQDxhsgxQONNU2X6byxxkMaOOikmDkFHYadBwR+jLMH+UBBP4O0gtJfCQdAjNfVSMs2Izwu++7PdDKGj/J8J8VNacnFcjayn5hqckquh3FDJMGLgP6ka6noEK+irvBsdVAH0F6Gnu
 Xia294Qn
 UAijbnZJjrksaG6X8PJJIV1MkIM84IgNqd6VbQ0Hi312xsjOkBHRjKe55b0qjNlIV7oqVzakKXIbF6+WWj+M1OhYFMqseLLyt962YOBGipu+6SUsLworMDkjL/SA7Gtf5eA0Mrwq8HZ8KKnxMrZetQS5y6dqfaDkQaV1pTPcvLQXOM7hUitNcfvG1cTJOZ+T4t8P280rBwyrB69+fPb9fDQK4dkLjoJT2pK0FQGJ6Bof3oIWOUoPMkWJfXXIm1tbtTgEP4ackeEjBTQ8Bs1jQpFX+q6+JFYS6Ytj7LmRATIyjuqfyJTztbVgt7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 13:11, Mateusz Guzik wrote:
> On Wed, Jan 14, 2026 at 12:55 PM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
>> You said "I wonder if implementing hugepage pre-zeroing directly within
>> the kernel would be a simpler and more direct way to accelerate VM
>> creation".
>>
>> And I agree. But to make that fly (no user space polling interface), I
>> was wondering whether we could do it like "init_on_free" and let whoever
>> frees a hugetlb folio just reinitialize it with 0.
>>
>> No kernel thread, no user space thread involved.
>>
> 
> i don't see how this is supposed to address the stated problem of
> zeroing being incredibly expensive.

The price of zeroing has to be paid somewhere.

Currently it's done at allocation time, we could move it to freeing time.

That would make application startup faster and application shutdown slower.

And we're aware that application shutdown can be expensive, which is why 
e.g., QEMU implements an async shutdown operation, where the MM gets 
torn down from another process.

> 
> With machinery to pre-zero and depending on availability of CPU time +
> pages eligible for allocation but not yet zeroed vs vm
> startups/teardowns frequency, there is some amount of real time which
> wont be spent waiting on said zeroing because it was already done.
> 
> Any approach which keeps the overhead with the program allocating the
> page can't take advantage of it, even if said overhead is paid at the
> end of its life.

Let's read again at the main use case of this change here is, as stated:

"... there are some use cases where a large number of hugetlb
pages are touched when an application (such as a VM backed by these
pages) starts. For 256 1G pages and 40ms per page, this would take
10 seconds, a noticeable delay."

-- 
Cheers

David

