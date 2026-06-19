Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B92CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 01:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623E86B00DD; Thu, 18 Jun 2026 21:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAC16B00DE; Thu, 18 Jun 2026 21:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA0E6B00DF; Thu, 18 Jun 2026 21:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 247426B00DD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:01:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 744D3C1905
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:01:40 +0000 (UTC)
X-FDA: 84894859560.08.E723BCE
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf18.hostedemail.com (Postfix) with ESMTP id B0E321C000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:01:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026052701 header.b=XlyaE6Xz;
	spf=pass (imf18.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781830898;
	b=jTqCuzWt6U2enKCxICwsTOMDbDKTT2AQTDd2x5bR8HL7CMPZoDXZ/K//H6PfoJwIxEtPlF
	2KSmLScLAzsXyW34DKqBlx3xqc/KDdq5OtT22lPLX9sEvaOgFhHGuCSar5CcP07pl/0G3I
	/WnoDgBP3RJhJtQlyc/a2/SbuHBMiL8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026052701 header.b=XlyaE6Xz;
	spf=pass (imf18.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781830898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zebuei/XCfNddBBMH37WBz8qxB70cJgeYGFCIcFgfPE=;
	b=Ob/F38k9qlbQ4pY7xwWQNmaF2MYkUTqz5t7Vx/Y6KEQ/kuOhrSk1JxUBGgtpPKBhLYHlmJ
	02uvY7Au52Y/7GVP9J9if8oSkKvEWLl5gTHwZBpzuxPJU5TlhjUpF2Wu41qnd+GAVyKVrb
	rYtx4cvB67sqj0G7fGXlHVoTH7H1g+4=
Received: from [10.124.222.133] ([192.55.54.43])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65J0ixd54112875
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 18 Jun 2026 17:45:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65J0ixd54112875
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1781829908;
	bh=zebuei/XCfNddBBMH37WBz8qxB70cJgeYGFCIcFgfPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XlyaE6XzFFlyeKW/M885dO3zXh55BryDmNSsUl8+mrzGUHbyUTLRS8ZtXveKBF0un
	 sepTgT9q/f6ZTRHHTHUspo8hQ3lI6ZnlxE8R2nd5tdu043eLqS+UDl1HlZSh6Tv/34
	 9Y17SMbzulbhZDbqsyUf5v2gb/JBkFUpd2u9IojONm6/0WMJNYn43FkUXgmSUjd3Ss
	 9zk1JkvNXOJF0tuBPhaFG6SIS5UkezOnCt21ych72Sp8HcRkg7QbF7vqgxbYJPvWPb
	 bUuEx08slk/WdeLevzHZXrdsi6uqckz6W5t5sW6F+MEr3wdmbtDIK6VrJxoPNrH+/D
	 JrrxSz7gBLpAw==
Message-ID: <91d8ba13-977a-41f1-92e0-791f7ffe0c02@zytor.com>
Date: Thu, 18 Jun 2026 17:44:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: David Stevens <stevensd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "Zach O'Keefe" <zokeefe@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon
 <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
 <c96b9621-16f8-41c2-869e-7310adfe75b6@zytor.com>
 <CAOiLmNF+e1Vuw8HJc6kwcNgee8Qi8h+Dv695O4TWmHKYsKez9w@mail.gmail.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <CAOiLmNF+e1Vuw8HJc6kwcNgee8Qi8h+Dv695O4TWmHKYsKez9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0E321C000F
X-Stat-Signature: e4d6txygkxys8o4oth1omsp1jfk8h3yp
X-HE-Tag: 1781830897-843218
X-HE-Meta: U2FsdGVkX19AJsQhZnS693Qbmc8h19SMx88cFk56m717yqdF2Co04nl9A8kDHnFOP/vjEFZb+iJdMLvbDzqjdOH9CMw06ogMJ9WP+gpyby7JBx5Tlxm36X1vKWN7pADE9qDiavdiFpZEDEza/CRNvxQL74psNpwsbHZupsk6VCqPLXbizoeSZdDIEewrwoRAGEgytjHLOxJXd+8jpsnw2PMVTK98mJJZesOsyCQqQ2h5zLkXMvgOVkckrlDir0GEpIxp1otPb/0/YdO/QMjcNXMVQgNRfSSWPzG7dqkEcerjm29ycrE8A0wXfMt1ECTY/tZA/IVSoCUGLeJbCpxjzBMP77AgpPErM3hTR0ULpFU6sxDWg/21Oi3hIdtQFXWKDGt+N7NKe/I7TAsaws9iC0F/wFzwRakTuNem1aTNP++jkwP9ZLmvwNrgELBSZhBus8Ls2R6D8L6qPvtywRnZ16NjndQbGQYuq+rRG/vLI75Yzq0SopSOcDzab1nUeN2MWawSKDqoMffD2p0ZHVW5PXFgjcS4+RywofLSZ82Cq+q1SZ1FjWONKuqrPBxBg88I53w+2Wj3DSLJDvkoThosvzpKyr7lHFdc8TK1F1s4f7Kjlk13W1H213US0J+GzZeR0Rce3BMb9YQ5XZjGCYnhx/9W4DnaFWNQhQfp2BGXZUHJQdafab6s3ErhgqBIh0d1bOCm2qtBnflO7RVWJ4902BdbHuzbB9t0mVP+is06qn/hp8d6NtkHtsYpqhf8DFkM+6fbx2MiXDMwmWFUDLqwJCFPmXASwBv28MTthZJIo/XudbkXHbfzOmwNnyoh9M1j/PgNV31JWf9vgVUKsu7YFFTPmTJS37opJUEbXa76t8UafjKSksyDTkTo/9b7AegFjMtFk7pJSEuZEdyZ9rgDfaQoiuLzb9HhFF/ZcJesEOchngQb/73rxnZfyxqSNtquq/wewVsFfJQ9agzZ0N9
 EK/zyLas
 H9NN5iPi077MtPvfGIdnS5xgbcUCnI2LmLfPuZDrowzteIeHS8ROfVMxBaDaW1o/25WLJZKaUIZfFtnOtdPzT5xb7xbaNrmxndhr3JIKiJowpI8E73Bd4dn1fK/9m9hXFYLjc6inZqtj/Aj8hh6FNnM22vBB/OQx+6jRYq3A6xCM7hJiXSe0ZZzpVg80L1SP0WGVWyAwnxV2ghv5RePudNnR0j4MsmyL4EOyIy0mINkmmcRGUvRNl2Ji+l0SOlgOTlpo35E6SbLDp5iW/g74uc0TBBhHoTkqsKnHY4Nyn9mP22aLE3drBblyK7ADLQ1QrwYgosEOoHhQ4w2mdwUNubx+bwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-18 17:40, David Stevens wrote:
>>
>> That is most definitely the zeroth-order thing. Extraordinary claims require
>> extraordinary evidence, and this is certainly an extraordinary claim.
> 
> I do acknowledge that there is currently a lack of evidence - this is
> an RFC after all. The question is whether it is possible in principle
> to produce sufficient evidence. From the Android side of Google, we
> are willing to carry the RFC patches downstream for a while to build a
> case for merging them upstream. However, there needs to be at least a
> possibility of success before we undertake that work. If upstream's
> position is that dynamic stacks are no good, full stop, and will
> absolutely never happen, then there's no point in us trying to pursue
> this avenue further. And I assume those from the datacenter side of
> the company are in a similar position.
> 

The answer is pretty much that you would have to present *very* 
impressive-looking evidence. There is very little that's completely 
absolute, but you definitely have a tall hill to climb on this one.

Keep also in mind that there are also people who claim that our current 
page sizes are much too small, and that the kernel should be doing 16K 
or 64K pages. At that point this more or less evaporates, too.

	-hpa


