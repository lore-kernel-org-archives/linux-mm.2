Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70CF8606A55A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nLoEHnEq
Received: by kanga.kvack.org (Postfix)
	id 931B86B05CD; Fri, 13 Nov 2026 17:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909DF6B05CE; Fri, 13 Nov 2026 17:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8469F6B05CF; Fri, 13 Nov 2026 17:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663BC6B05CD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:36:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3B46802F2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:36:15 +0000 (UTC)
X-FDA: 85431555510.05.37AF482
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf15.hostedemail.com (Postfix) with ESMTP id 84DE6A000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:36:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nLoEHnEq;
	spf=pass (imf15.hostedemail.com: domain of vineet.gupta@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794609374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tm0KsbHdwGJF54Zx8hQsqG6F8oKBBxs/HZqcH7Y8YjI=;
	b=fVZDTf4nNIk11fbiA2ob+B922qYGgeZ97S7AuOsGITbll3b4urVssRh7jsfIHD10geiE49
	yu6wi5ZC4cq4O3KvHh4mloKLjc26S5qTCCGiS/uNHF8ygzh64DqRO0xcooUurzNV/gfmaJ
	VYLHbdGxEpl1Xj5nDokH+g/od1oLE0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794609374;
	b=L7k+Tdaw87LDLmVa3JnzYgrow95OmYdtWs3l9wCAGsKc4kP/9hMPmQkOmojwltqFY5/NC4
	e+hHGSll06ZtegMF58ElD0cz+4FrqECCOy3WSrUejtFYVv9gfA+KfvKeU/T5uDF4eqa/6U
	zQwIk1LvlRZY+25TcO3iaDB3B+hxVJo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nLoEHnEq;
	spf=pass (imf15.hostedemail.com: domain of vineet.gupta@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TtBRXW6QA+XpUjRfc2qsO4A+37Kv5TpP9BUsEKKizFQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794609370; v=1; x=1795214170;
 b=nLoEHnEq1ZQpjZzdWvaZtZme0132ShAMTCjauvoSbqTA6PsII5ve4EpcSu6HR9+7dBd2lWrE
 s6D26Efm5liWkQy9KCBW1jMgEhSdXgMNSRvodyKj95Ucclpp66VuwNcfrg/jz8k7wLhAmYWV1QS
 JDJuAjRrNzexoRuWeBYCRihQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 752cf6fae846f8b5;
	Fri, 13 Nov 2026 22:36:10 +0000
X-Mizu-Trace-ID: 752cf6fae846f8b5
X-Migadu-Flow: FLOW_OUT
Message-ID: <55b6a4f6-46bf-4edd-9da3-e9cfd48e8a5c@linux.dev>
Date: Fri, 13 Nov 2026 14:36:03 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] percpu: do not put btf_type_tag on per-cpu
 variable declarations
To: Chris Down <chris@chrisdown.name>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, peterz@infradead.org,
 mingo@redhat.com, will@kernel.org, boqun@kernel.org, longman@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, acme@kernel.org,
 yonghong.song@linux.dev, eddyz87@gmail.com, martin.lau@linux.dev,
 nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
 justinstitt@google.com, llvm@lists.linux.dev
References: <20261110012235.1024461-1-vineet.gupta@linux.dev>
 <20261110012235.1024461-2-vineet.gupta@linux.dev>
 <20261113115808.87a52a7c74e293ce@chrisdown.name>
From: Vineet Gupta <vineet.gupta@linux.dev>
Content-Language: en-US
In-Reply-To: <20261113115808.87a52a7c74e293ce@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jxq9jc4r97jzpgeoyosuxjadom6wws6a
X-Rspamd-Queue-Id: 84DE6A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794609373-351490
X-HE-Meta: U2FsdGVkX19pyYUyoAXdsROPERIbyaUxJM5YyYYB3BkXaHxXdhNDaXHacrXirbrX7CKSew7FtrUGUTFq2JtGBwqIpZn495x5DJXVnGTGpsqAzPuwS/oBovwgf/rlJQQ+Tkz4AkoWMPrhzKve9FoQnNc6L7o9lYa2FpHHKOmsM+rh9JJDW03UGLLWtordGkvE3jrCz8Qsr/RbB1lDsMhdBoEhN/IjfjEGB8JVVjZr9QT3xU4YtCG/lHsoCG/McBkeNmuH9gLTEOLapjxCTrXM6lGj4Q9ko2nE+5w3wlXo0iOGqDd6wcNzo8RKnJRqhEMNQKtW2jx/t4GGNJ5fDfMnAuzuPQMC60WRjQl4m4NdlGXjahf8CbgDaKEODU1sQjIrwJfnFreCn5fGv9nulOUIHNVbh83itGHUS1P3fVm0mLMYXTSZEtqITs5PWEYWAEwgixr25qxHHiq5+Mvx5XTIKE2msJphJjvjc7w4k8DnAgYOChfx8sXLFlNmDzBkYVPxPcSRTuNdS70NcVTIN7fT/XdayJ3jl3aNSq0c5vQ4/NmHd1GbZ1H0u+1MJau+aIcEeG49mYl2Oz2iMFivTtuZ7NrD3BovCioFpHK82GC0r/RuOJ2BWMct4iNYVddYo9wPCIkdlSOUsF6Iks6GVkPo/sOMBdSmZLgdGuIPYC0uFwk1+HounxWJlqG6T0J2qqfcD8V7W/z3B+8yHkUe/yssKjwXnsbQCCkxqFMWCHOI6PfxIXszNMSzgyN/to0qVd6SClZJm+m24olLI+Iz4fmdoaQ2T/7CbkS1IIu4A4k9POV18/24C1XEzLVHJcfKXIsfHw8ZPBwF8sIOtgRUfaYf/DPJJ9vigyXnhZlRzE91ouzYESf0k+i2ysKT9vuTW2j1ZVWkkg65akbRiDWve01Kk+42xBX51bWqCU5/u678oEeSvl4m5OE7t0Q7Vc3vkQQ+23tOMQf2vRcZ6V+r0lu
 qWhedyRe
 KKhtpMtPnnOksE8rRhn/N2ja0sX2n4UKYF4MGtvgsvZCVAqE+JgfvTk0CQN8disKHno7+ldNcjcRllyTWa3ccM+IlPx1cad4jhtdvlYEibR36ptmzcGuwXn5m7eFAlwNtxj7JorWTbVidqJlDztghxcl7UnPja/LH51o/GoX4HH63j/BxzAi5N9qs74L5rK+8g8ZzJXfyy4BoHwx1xCSgGOVopPGF+HJO26LZjceRPjjOkEh0b7Z7YBnNMCMOUVEza/MikoxY7JMsF1YG0KOmyljKHlOQHTeCfcSJFHEWkmi9hN8VrFEqF9PmlWikhiKItEIg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 11:58 AM, Chris Down wrote:
> Hi Vineet,
>
> Vineet Gupta <vineet.gupta@linux.dev> writes:
>> The message is confusing: this is a declaration, not a definition. But
>> the compiler is right to object to a type tag on the aggregate, and the
>> issue is fundamental: every variant of an aggregate shares one DIE, so
>> there is nowhere to put it. clang drops it silently and GCC warns.
> Not a big deal, but the definition in GCC's message is the definition of
> struct cpuinfo_x86, not of cpu_info. It's saying the attribute is being
> applied to the struct type after the struct was already defined, which is
> accurate. So maybe just drop that first sentence?

Oops, thanks for catching that. I misread which definition it meant. 
Dropping the first sentence in v2.

> I've tested this with clang 23 and GCC 16. With clang, the same 280 types
> and 3360 bytes of BTF go away. Likewise, with GCC, the per-cpu
> declarations no longer warn, and the non-enclosed address space errors
> are gone.

Thanks for verifying, with both the compilers.

> Once the commit message nits are fixed, please feel free to add:
>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

Awesome, I'll add these in v2

Thx,
-Vineet

