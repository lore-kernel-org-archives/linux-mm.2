Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AEA1EE209F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0356B0093; Fri,  6 Feb 2026 08:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65DA86B0096; Fri,  6 Feb 2026 08:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C876B0098; Fri,  6 Feb 2026 08:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41E2D6B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:17:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7E1B1B037C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:17:08 +0000 (UTC)
X-FDA: 84414082536.04.FE20D0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB8BA4000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:17:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gUTo3jnU;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770383827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoCNPr3Euqwwytn4JohYXyt4RAcWuuTxdk13fRsXro4=;
	b=MNXqgAXhhgKEwchagokwhIJYWi0HN3XSBUX3Fggd/ASTDOGOehF48JzTLm1KBaWcXmqx9D
	BBbbL/V83oZ5f7lvoa9YQEcROThdkGO0l71O4BcEQQ2XJkqTUKaiDmjAwRrMU65Wt0iT2+
	OAjJTcDpzeW7DpDphr0ZZNDBeHzKwQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770383827; a=rsa-sha256;
	cv=none;
	b=rQMoJ2eRZjJDxmFPUM236BKw3hmH5Pw/QlkGv9eaB0aPZ+uMwXcU9Szm3vKF+3nzoglsrR
	Lv/dD5hU6selSl9clMKIlbnq2YoTe2xK8t4EF04LWhj4yBldjklWBV3EvbGjEyORwnaU3q
	V9S0qQlCNUFhA2vbqmFbQDFKi+nFosA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gUTo3jnU;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD59240063;
	Fri,  6 Feb 2026 13:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5524C116C6;
	Fri,  6 Feb 2026 13:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770383825;
	bh=oJgqqwI7/ZFyw/6ujlh7oBpV/vwBF1tXc4NLpO55eyI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gUTo3jnU0GI2KANuHEVBFyZGPaou3t2XRkUrEH3RwGAy8RSHO4qBgCCAFFb6fqoX/
	 Rs6rgojz5ZbvmWDS80ws1lpirkEbzwESdyNIcS5QgkvSBWCPuo1hqGAS13S7aqJMDr
	 L3fcvqedZsxTK80j0LEPbt3Vqi5NFqq3Wm0tYJspjKl14C/DX4+h1o/aJ2ncE5y06c
	 GP6h9ZLNjLfgjhzoXQcg7uCGzK6mkI+JCrYy7G7OzfdibDwm7Ok0DC7oaySlBiKJzf
	 4NvMUGkP7V9MbXFvwnfLWp00YyEzZbzAvQYT0GbvsXUixO4/+9F3ngQ6W9vkI8uKWb
	 +ryYntLLQaDPw==
Message-ID: <2c984546-3e26-40e0-b9d8-68383555ced2@kernel.org>
Date: Fri, 6 Feb 2026 14:16:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make ref_unless functions unless_zero only
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>, patchwork@huawei.com
Cc: guohanjun@huawei.com, wangkefeng.wang@huawei.com, weiyongjun1@huawei.com,
 yusongping@huawei.com, leijitang@huawei.com, artem.kuzin@huawei.com,
 stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com,
 gorbunov.ivan@h-partners.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 harry.yoo@oracle.com, willy@infradead.org, yuzhao@google.com,
 baolin.wang@linux.alibaba.com, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <d30cf64b3b48080d21a5d14b79d51a82e0f80e7e.1766145604.git.gladyshev.ilya1@h-partners.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d30cf64b3b48080d21a5d14b79d51a82e0f80e7e.1766145604.git.gladyshev.ilya1@h-partners.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CB8BA4000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xmpatqderkj7mucod3uwj4ms41knio1m
X-HE-Tag: 1770383826-442014
X-HE-Meta: U2FsdGVkX18F7W5N83DaIub26jydIOls4AbhLMYVQcCPvnKkMMzx6f4ll9XD6QaShZtJ5U+sVRYcknb1fGUlXD2hWbITuKRjrqFxWDYf0FLWkDsQ65UFCEEKM9kQPcoFS1jlG3kKXCzpxnh9enSY6IzNlBYwV974SWIA1Ol9jUvJN7e88moraMU3Cmt8bWVMeDiU5ocQZi0c0Aaa2zslVONspiQ9nE+DXOAAaY4wDlAl+EctPRNhGTYySiHHTy2pGysfitGU4iWUTAS0tzNdTpnI8RaWpqU8B6qhORBrdRXsMbyfXyZ3d/J5CNe+L/r5viFLGk2IyvFGsez3WfTanetmc7gW+Ia9p6zRv+py2XdxKr8O+1PYslzWQjdbkp9MfIv+meIN0O8ZKtFNjFlO8LNN0pLLW4TbEiLta1qmpxYJ6zsLbnB2Xoi0ZxeinWXEkEcXpYfsTjO0ONnkcm8NRrcGvzlE1SNG+zh0NwruZB4Np5B3iXoV7W/91PhgXSASgDfTBauUNwRlnDQ0khAP60928lE3yv9GS7SFOMS0FBk8+HnL7nCVQI85OBVZhlZf+5RyCD6HXpB5VPfcfOapCEDoB3bqe5w76qP9L5xql6IY7IMsroOgMxHuscMJU3FZzrEwn8BzOleoHqSuD5KzmI14SpqO8wlOdRD/7SSpkPNt5pgVk1VfKzr/11zhqpMiy52p75wAM1C6RYAeheDkZv0YgZUhHIsEmVr3DpW9bIh3sdkGVEz7eKtLN7mc+XJ6GFv4k5lvOh8pISpWjKzrO+A7QyCyeeC89hf5+F2/RymidatD7gLATYkqr6VpBPRQY1GUPhuuzlz48glUWzzjjjKYad5QUBFDO6SSleh9TRSBnZ1PlMjmijK2obWyovlOjLOhj9VQgqp7l4gsZEYQilOhHa76gkIWHRlPOr4JAAUpqNnvnDf4nEzC7DTYHIpk7t5NJ6KtvzUT6kJ6ggg
 IFVTVedb
 iWK0jpmio0EMmdjsI7gR+r5QP3dcz5rls8wOIg0djuHe9/Q81rrrert/8usoVfSXTEAqym5fnk1bvtKzlqGGZTlANt23H5GL2qqNyWLkT8qI1D2N84560XFfIc1lBu7+4ZPpjZ3wPlxuZiSJZVVBDd0tHiGQuYypx4zHaH6rshu32jVdvYNNyKrhsl7N7YF6hZW4e9Mj3kfO9bu5CqIO8pe4wxAlY+iWvjfrUlq1EbcJIv+kz1Jl8MNeX1lCTmyBOwtUQPqoMBUfm/zrHelqCDi5JpaeiPE9QW0LDfYi6PJe48xfeAznWWXnUz3VKQmggSaYgrBLw4IRAeh3ShCl8uAapbLdJWplZe18P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 13:46, Gladyshev Ilya wrote:
> There are no users of (folio/page)_ref_add_unless(page, nr, u) with
> u != 0 [1] and all current users are "internal" for page refcounting API.
> This allows us to safely drop this parameter and reduce function
> semantics to the "unless zero" cases only, which will be optimized in
> the following patch.
> 
> If needed, these functions for the u!=0 cases can be trivially
> reintroduced later using the same atomic_add_unless operations as before.
> 
> [1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f
> ("mm: remove the extra ZONE_DEVICE struct page refcount"). There is no
> trace of discussion as to why this cleanup wasn't done earlier.
> 
> Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> ---

This one makes a lot of sense even without #2. Can you send that out 
early as a standalone patch?

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

