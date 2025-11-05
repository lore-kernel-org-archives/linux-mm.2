Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC09DCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3556E8E000E; Wed,  5 Nov 2025 03:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305E08E0002; Wed,  5 Nov 2025 03:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244388E000E; Wed,  5 Nov 2025 03:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 139278E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:12:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B03F7C0232
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:12:14 +0000 (UTC)
X-FDA: 84075835788.04.3DE35ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17D3A12000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:12:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9KTd5iK;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762330333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Wh2zw+kVlzqFBIKeBrFpgCkgbJvXDbrAYMw25C5PvU=;
	b=kNjH7P9tFz51gRJuZE6CNk9T2kpHf8Gk4eZv2s9i2vdqazk3nv/N5EpMjyPlHXq8dU9NSx
	T4NSJuvuhxt9PW9yWdUyVxr1yiifir6LVe+d0u+MFAgypgQX9nnvhGBZ9vqWRVk/0Hyb63
	2b/0/NaNYCb6u5PGvaKxFMCiY1p/la8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9KTd5iK;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762330333; a=rsa-sha256;
	cv=none;
	b=yzN/cFGZxeuqD03RiovfWcTb6RbfyEmFZw8I7Z+VJpJaJ5QOOYfABvX5OYQBLa7Mj7Wd9V
	Pdlx7eXqZ2YN3BH5Sz00atjDpjhH8/adB0T1FQzwOQCN4k1i+vP4GDqxql1OVJMwERr/cu
	wrMDXDoKuZE/IaUzFcn/WjkcLUcAlS8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5347D60202;
	Wed,  5 Nov 2025 08:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D610C4CEFB;
	Wed,  5 Nov 2025 08:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762330332;
	bh=7Fk+JE049jRq/zXL5tufjYxIcvB4hcpZcXMbt7dUjgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c9KTd5iKkP88XP9XQhtAfMBSRIhe9sA+rFNNqkfPPMLWhXnldgaJ4P+jz+479/mjE
	 HTs2V8zAPf554XF2yCjENkd20C32geFAE3e5fEYClAjs/Rg5w7QVRmijfEcvDlGeex
	 2MOQ8xhjGTWLnUwmNBPZ1+lIM0wt7+kVVRJloUgWy1OX+I4avR8q11yQE7BWHqz7r/
	 5/5H1QjUCf36/VloeQmGJsOYqULVviz/x+rrbSG9onf3Xfzc4ORjolHqRHoxYEBiYO
	 ei2eqoX/HIVlZtHbZNcqWXMrRTurUxRkuZqQ6zdmCefDLn52Y0OPrsIik73VVQH7l2
	 pbBWSSateNTJQ==
Message-ID: <57936358-69b0-4028-a0df-b5f5acc32ca9@kernel.org>
Date: Wed, 5 Nov 2025 09:12:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with
 SPARSEMEM
To: Xie Yuanbin <xieyuanbin1@huawei.com>, dave.hansen@intel.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, liaohua4@huawei.com,
 lilinjie8@huawei.com, linmiaohe@huawei.com, linux-edac@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, luto@kernel.org, mhocko@suse.com,
 mingo@redhat.com, nao.horiguchi@gmail.com, peterz@infradead.org,
 rppt@kernel.org, surenb@google.com, tglx@linutronix.de, tony.luck@intel.com,
 vbabka@suse.cz, will@kernel.org, x86@kernel.org
References: <47b3e8ba-bc95-41ce-be0a-ddfd1323bab3@intel.com>
 <20251105024523.14300-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251105024523.14300-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 17D3A12000E
X-Stat-Signature: s1ik3citqx1ukc8899b5ijyamswkxso4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762330332-486452
X-HE-Meta: U2FsdGVkX1/MV8rvTtYfuptzMY9wITgeQ5VxSVy1JqlljnXLLCs8UqvsU8bzwjjFYxfnfGx0c0F8qjv8emvYF/RPa9/bR06so1rQYRTcSblRW8h9P31Lr2jjPDu9tos5XqPtfWHkkofS0u1bozz1zj9UxbmuFBALdk7+n+UprSArzj1+W7GdRUSr7dn8W+u9alR9td47eEwgz8fo4Ac38ANqf5pDnJVIjSZmBB37mHztmL8FpmTFsoddgl2Ef2LKq19MB6Cw2ydK/oMiOEeGIsQC0X6kLoG83O43k0FvLKDTdpwT1QCTtFFuDBoATTserdK86Mgv7o3az6pL8fQO0GjUhPNK+ew25l97bRMac93ak6oVBugOAZnYICqu7WPabmXBzmCOIY4uOUBMXd1G8k2TKw7sHVCV5BJzoh7KZo8tiHHWRjHVGc9A5fbR/IN3F2yDKIf2yz3h2yv9tAxN+B5mK8b+lb+73yi8SqKZ6phT4Q3M8JWTFy7T1frtMlokZfpE5Xjga34tFzYNSsU1PdAmKJfVWy0cnwKbW8dAWqKUh7z3dNLh3mAtQ4FsK73xuoh2gUwtk1LmEI0E9LEFJM6YiDJcxSOL/aBxHPeuz8MK2db2yx9SHW3PKyhWN7HRsox2pFJ0rK5txgltlzTfrTNl6q3jyDEK+vB6yo/Alrl4+su/1ZY2K6BIeMQdhhTXLT2NsZ2+5boWw2TTeUTNiuD66RO6BvJHRA29yxSx/BNRGxXM7zUoLnkX/zhq9dC/efsavHv2CoPe4PbdQLS3L2BzXIRRwDC3TViG0sqR8QQzIxCvyTD1mTpQqISaOnOQpJ3+0puN846GDIx3oEXuxekG9vHDJDJ6jUDOkKwkiRuwgTG9imH0YjzWYa3rIUgfp3klbJj3xE5x4ZseagQKIt5j5G5gCruNsnJJusLdHl4E/ZnT5ZAmhUob0cc4OeqqvtZ5JVeolvJphvpWe6a
 mc2jRxvF
 N5wkz2MBXMMl4siYh3ugYGvCQZwd3yF1MZTJdO7hnvIroCLsy0gQMCblBvxr0q0XzJdbHwXiGe6QD/ay0j1JebRms/+gz4PbKbftSjHOfhoK7NAMxzZddNo6JEZEBxsPgG2jDLYbDAFI8M5Rcf0xqZJmAi4u/CCGvQtJEQBLMGbkRkUqXQ4Cz9FDDGeX86LwgoFYq2LL7leTc71K4fmIxR7D+eYll79ptBdSvdOHmw3fJq8uN5mmqznm+lO1KIA1eVjvqAfSziG73ZaEvp1VeeNhTI1Ul9a9s3HAP9XHgOkdxtCYtmNLVGfF31F7rB5vfLKLv6fEKMt9PP6C2ggbbxtL2Y20YblHSxGlB0I5WaHYRQtlpr4unbAqWSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 03:45, Xie Yuanbin wrote:
> On Tue, 4 Nov 2025 06:26:58 -0800, Dave Hansen wrote:
>> Which LLM generated that for you, btw?
> 
> I wrote this myself; LLM just helped me with the translation. My English
> isn't very good, so I apologize for any mistakes.
> 
>> I wanted to know _specifically_ what kind of hardware or 32-bit
>> environment you wanted to support with this series, though.
> 
> I think I have explained it clearly enough in this email:
> Link: https://lore.kernel.org/20251104133254.145660-1-xieyuanbin1@huawei.com
> 
> In simple terms, it refers to some old existing equipment and some
> embedded devices. More specifically, it includes some routers, switches,
> and similar devices. From what I know, there is no VM environment that
> using it.
> If you are asking about a specific CPU chip model, I'm sorry, but I may
> not be able to provide that information for you.
> 
> Btw, why do you only ask about which x86_32 devices use memory-failure,
> but not which x86_32 devices use sparsemem? This patch just allows both
> to coexist, and perhaps both are important?

Let me clarify what we need to know:

Will you (or your employer) be running such updated 32bit kernels on 
hardware that supports MCEs.

In other words: is this change driver by *real demand* or just by "oh 
look, we can enable that now, I can come up with a theoretical use case 
but I don't know if anybody would actually care"?

-- 
Cheers

David

