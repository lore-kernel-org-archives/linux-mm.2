Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DFCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C588C6B010F; Mon, 29 Jun 2026 12:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C098B6B0110; Mon, 29 Jun 2026 12:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7FC6B0113; Mon, 29 Jun 2026 12:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D67C6B010F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:19:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D98AEA01D4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:19:06 +0000 (UTC)
X-FDA: 84933459492.28.CA51E9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 132A1C0006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:19:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ns1HpxUY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782749945;
	b=DoCoWmj2lF7WkLuiuyixzGWthUdogZYvUtHkghUoP221saWSVIRjoVhtOh+col+MZAVq51
	NXnU0csFyf+ISCkieWBx6lr3TBUpF7mA54ooXTW1tM4SrOWBVJrkynoA6JUczcwejaOXZ4
	f/bpLp8MVgbMwLgwvDullCO77d51GPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782749945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibo377gytuiH+zAA1DlGc+J0ntd31pmDjKTXixp+0P4=;
	b=LnSQLf7J8lMMWer3umc4jv2Cw8gie2Czorn/PeN1fReKhLUb1+1r3CFvrJe0jVtihD0KXx
	1cE6kswM7jpjOW3Nz+Kb5gIRfIrQLcQSq5+MwdtaxjBr6TNmj+/NeQiGfmmya4oyEkRP7o
	vd5LXnZapw9JPY2UhGRT0dJYRlRuCrc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ns1HpxUY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B9A84067F;
	Mon, 29 Jun 2026 16:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41D31F000E9;
	Mon, 29 Jun 2026 16:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782749943;
	bh=ibo377gytuiH+zAA1DlGc+J0ntd31pmDjKTXixp+0P4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ns1HpxUYzzA0svp08ErwLHFvPp9K9nG7flBt+w47R/JL1U5AzUbspZ4Lt25bMJOhu
	 FungwpCqa4GLqwE/fgQSVyG4d9awwVP69g8+lVMKi7UqoGSwxzp1vdZSotrffSgg/5
	 hn5wVzTSZcZ2Q1TeUPhwO5cN7MAmH20AjPvQCKJNFh/22jzT8+WZGQIOK/umsgNP5U
	 cq6YwkT9sGbO1s3eOcV3T/5lFzoRVxLob7iZzfrdRYCaMGlOXNgi56+1urTN1k/AF+
	 C5VvwCqza8WX2qypmPQGKPFs3f1++vvWdaTPA7PK8CQOgtzUJwfSkmmS/poMO1YwIf
	 XPbmUXZ9UQMtQ==
Message-ID: <a1b4b0ba-45c5-4de5-855f-7474918b52ff@kernel.org>
Date: Mon, 29 Jun 2026 18:18:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@kernel.org>,
 Zach O'Keefe <zokeefe@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <87cxxgly12.ffs@fw13> <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 132A1C0006
X-Rspam-User: 
X-Stat-Signature: djemf5jo3585m99zjaqdxrg35q3j5xop
X-HE-Tag: 1782749944-214166
X-HE-Meta: U2FsdGVkX1/jyv6ONWSYEBjO57a9LR4OkldtkBhBOLv+92UyuDkbpmO2ps8M6QINn2cek4LbxnIXiWY6uTJUQXreQ2dn1V9a6DrUPxX99fGEN/1JliUh5sO6FYEpsLHHlbw2EHuaPRDUsbu7YfObOnyYQvVIKyphzJnmgbIBAbeI7sSw6rgK/ymMklkRfW8nF3Z/jf0rLYLlompOikNNLEtl7h4UOLbAxoBBq6UWcNXTujaueWHa//LlYpJPEzRkKCZWGE+G29IxDVCOhQbtaLrTNjbLxfTIFXWfHMZiuVz/liPBbpftpPbEhTaaJvZkHJQSajcLymoW+hT2KDaV9NQ+LuQz+4Df3V80MflMW6XqNAwGJieRpPDqKXCfemTJMkx97xv3nZMEbmI3tKKsSGP4q3htpulGOuDZbo1Cr0OQp+DsSPlFVrxHhRgJXeXVDDHOg4gXe0tHdXTw1AURWewregfUx/kQDFpnLNHIE/bw0qsw+ouSRKw6Xqb79zzvFkTOp1cHT+atEBH3Eh9+sEehZvsj5L+5t+fqiKDqvbu07cfvDIWR+Zjo8dgRigR4Y4lHPPGADrw3TBAMOm/qS7Bt6/If1xa1DoldFdN7v+W84ePpgSPnWDq1NCQj+nyeDOI0y16sMGeN+hlcZi+qIT/CYiWXzb02TqxEHcKV4qNpcHZyfHMSTIbvfjLzdwLxloVnIeC3+bWF64mKcEpYA3GHBwy416x5J6qFYt6dS0ep4aRPtOMvxRV2XTQe1+rGYYyajlYzjKMhEg7y7ZizJtyTZiuwlGtp9lQexTliZB/noe5USYCNO8UINDOl5N74ffdM/bMpJ0s5mzf0erHbZo5TpybFY5r3NYvvp0RQAtBf1QVCzat7hMIWTTRJMuVm+oJf0O0/E5l18LSdWpVU5XieQGDReu68RuqapLS7CNrxfI5EiQp6esiCO1B3ekKhXMdYsYFP0D1rjsOmX16
 E0ZHP21S
 ++auQ3pUrFV8DYP1hvZpeYNXAaHCPawLSiuNU1UZwKVAPC2iRin9SBnGIY1dvyTsp+HJXFAVCl/+snkrIvsBTnVBI0TxCuu43zxQQR90jhJQvCmzZtWzx/1WcMGQ+Sp3Bo4TF7vhHDp2DR+DEJpHuZQGoEheAbBX97rtNKym4J/sngv98A3qCD9RiKpsQkaUnpMgb0UvDWa4vZfB7GRWgKnHI7Er3AtGFSgNeQw+mGEMwAD7olYWxeNqn7CC0410O4EfFBC/0SX7IRvGyj0Os8Evy4zZxJRxlkwJD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 18:02, Dave Hansen wrote:
> On 6/23/26 14:58, Thomas Gleixner wrote:
>> So as you already confirmed that the number of offenders is really low,
>> it'd be definitely a worthwhile effort to fix that for everyone and also
>> make the compiler people to get their act together 🙂
> 
> One other thing comes to mind...
> 
> We have debugging options for looking at max stack depth, like
> CONFIG_DEBUG_STACK_USAGE. But no distros seem to turn that on. There's
> also some ftrace stuff, but I assume none of that is used at runtime either.
> 
> Do we need some max stack depth instrumentation that folks will actually
> turn on? It would be nice if we spat out warnings when folks went
> through 12k (or 8k) of stack so there was a chance of closing the loop
> and getting feedback from them.
> 
> It could be done with really little overhead if the vmalloc()'d stacks
> set Accessed=0 on their PTEs and then checked them near vfree(). The
> PTEs are already getting touched there, so the cachelines should be hot
> anyway.
> 
> The granularity would only be 4k, but it would be so cheap that we could
> turn it on universally. It would also be 100% deterministic.

But it wouldn't tell you what was the large stack? Or we could try to print
it inaccurately, and hope the non-overwritten deep part gives us enough insight?

> There are, of course, more games that could be played with stack depth
> checks on normal interrupts or NMIs. But those would be less deterministic.
> 
> Thoughts?


