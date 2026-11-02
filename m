Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0DC606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S7BWKxBM
Received: by kanga.kvack.org (Postfix)
	id A61176B05B3; Mon,  2 Nov 2026 07:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37D76B05B4; Mon,  2 Nov 2026 07:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94EC16B05B5; Mon,  2 Nov 2026 07:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6FC6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:51:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16C1BA8B3C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:51:58 +0000 (UTC)
X-FDA: 85390166316.17.AF192B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 678C5C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:51:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7BWKxBM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793623916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYrHasKbCnivUZKlafZ5WVAkPwuwplVb+icnUCX5yjY=;
	b=QJB76NOfhOw+bSZjTi+9tbv/CLsj0883YnRU/4x97DR9K1loNfh/Q2DKsPnrTEQXcjErl8
	TJcxFPSozw6HHtyZYg4TlmoQJN7HwisKMHgy4ANdUQvr09RsfNfoXbIRC8uGebj4d1e/Q5
	9/jyCKdbvd0DWSFWg/uL3BHSHK95ZTg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7BWKxBM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793623916;
	b=LtYJkiC9l/e7H4kbhVk7jtpL9DTQca4HYZ0J+a/39cf/G8Z4i7dc49lQgcIRTkC6eyxXRC
	31SF21KpQHE/AecGqqLcrP/rF/UB1fveIXNt+8YEFWurGbWWTzh1ibQ8J3yJ635y6Va+AH
	vFtd05UCXaqvgcQ4vXKK6ADvMO0/I98=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E64A2602C4;
	Mon,  2 Nov 2026 12:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB291F00A16;
	Mon,  2 Nov 2026 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793623915;
	bh=gYrHasKbCnivUZKlafZ5WVAkPwuwplVb+icnUCX5yjY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S7BWKxBMbz2TWV1nf0UCf7ZV5WKchz9k6I6etY/gESRikgsmpQDZBXjP/EXr4akBa
	 /j5B0jJ/sPjy5d6if9n8y7qgBbUVoowfJYp2HGXQLE48D2x/dAqdUJV6QdntlevleI
	 eGno6zZHuKPuxVWDvaM1XsxHGFD3U0Dql/1gRPoPgyHCPBwfJboNlvbJ1moYrPRqvT
	 EDusjqcTxWypyUht1ESIULFpAcrA/zF2TcuHU1A+bVxaSYth0oQ0AW6YHXs5PqMCTc
	 lkF5hkKAFiPuxFWGPibAl6FSdUQZYkrb7S5/hLf938RJ2pMXmQrI3jtqE2IBM1HfAD
	 kJ1ScwyaFZIDA==
Message-ID: <f3ac30ce-4f6c-4ad5-a604-d28ac78cdbb8@kernel.org>
Date: Mon, 2 Nov 2026 13:51:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] tools/mm/thpmaps: fix missing order-1 file THP
 statistics
To: Weilin Tong <tongweilin@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
 <20261027074904.3328878-3-tongweilin@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027074904.3328878-3-tongweilin@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 678C5C0004
X-Stat-Signature: 5ozez3mn6c1usie9fqgtirfi7ywpt5p1
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793623916-28634
X-HE-Meta: U2FsdGVkX1+cQbF+kg/sZWp+N58yqxjMX86Nijax4we80KdU714iRcEzpzSiqVRSnDx6A2Gwt63qOHTFon+FXwGMEF11fFHkw8EqpyZM4QEntthevRdFTEw09jrLICxlgNHfwZUGrnCbTRSiKEV5FnK+IKdfHfKxUG84GXR3c+rKMyG3lIy3c6Bwn8jKnnZ/qMk6/ucz1wq7ahbgxQHHOlLtiGqlmRliFtqX6qwtdCt5ShEk6Q4A8XmXD5q2rAeYfNNk3rkNTBjZyTGIXqFnFXJlkprd0WS9M5u3PGyAMluShXYRxbRyAD/DWA+P6k1rbjqRTAtl5xyC1OMwPE5cSr72M/mqj6UTFf4wQvK2++FH3kHziA7kZCCuNmI7fbpEyqBCuGFsK2JQwJPx1oKU17wIkC7W+2Fx6pN7H9CAVVJej5w8AlCyWdFquEHUnEYzMVxcyBU2K2q8J3gV/Pgqp3BIEjsP09xxKaVHAmzmzdq+l6RSiT6AjPZrpgxbEz7/uh4OO/4i0+RAJis189e64pPtIdzw3IBSKY+KkOxuaSNhvTa5vOVN6UttE41qUNGEFZ6ZnmWZO2mM+4iUtNkUT887xKq/Iow2uBHn+vPUHiI08tkrdZSwnaKZ5yCTrUjrnonyD5KuBLUYwGRJ6a3erWVStA8QyoH873seVmktN6aMk0yrP3NFnuHdLm3QB7fF/fJkOtI+rUZALdUxzHImBpUi2QXgV6T3+0ZVMWixVsjBOxcOeQEP42kFq/ejxi7BCol8KSEC7fGGxphghiOBfo27PPwv9DJQ5IKqOm0nHNUBYo4UPBmmUQW3EgNdiIEEtprED3Cc5hVfTBEVoT8IF+jGNF6pka4Few1Z7NfoFdt6pv1T3d3DmLsnqy0G7n4CVDhNuy35PeFp61COZlKVowRcQOqDLst9o1krxwU7bx9ODslojdi0Ceyj8+6cq17aDL9gL3TvQRPv1jFpAkJ
 S00aa+65
 N2a95jRWlVYJmfsp4TOKwxUJcp3GqDZfFnK+g4Dhws+FQQZ/PfSpHeajj+FkLatGj4B/vU1pQ2utkmOXHN15bObWqyj7fBr6iCTGgZVJQ6tiH2E9zvw4yIZ2KQwroqao/o9/dL4zfP/1cTaq+BVI+O8WzDKdCIVDQ1k//jarU5m7iwwi92H3IojiU94MIyf43zZH2oP59BxcQ8nSD1yVg9e7fslEFL83+LO/CQkqRzcLlq342Pa5NzCT6YZQSm7tv/97e6CUecI0bGCwAa5rgSHkiI3eB67Yarq9Xa0Gw7vHvBmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 08:49, Weilin Tong wrote:
> File-backed THPs can have order 1, but the per-size counters are only
> emitted for order 2 and above. Fully and contiguously mapped order-1
> file THPs are therefore missing from the output.
> 
> Start emitting the per-size counters at order 1.
> 
> Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
> Assisted-by: LLM
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
> ---
>  tools/mm/thpmaps | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
> index d92aace005c1..30a8e915d677 100644
> --- a/tools/mm/thpmaps
> +++ b/tools/mm/thpmaps
> @@ -295,7 +295,7 @@ def thp_parse(vma, kpageflags, ranges, indexes, vfns, pfns, anons, heads):
>  
>      def flatten_sub(type, subtype, stats):
>          param = f"{type}-thp-pte-{subtype}-{{}}kB"
> -        for od, nr in enumerate(stats[2:], 2):
> +        for od, nr in enumerate(stats[1:], 1):
>              rstats[param.format(odkb(od))] = {'type': type, 'value': nrkb(nr)}
>  
>      def flatten_type(type, stats):

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

