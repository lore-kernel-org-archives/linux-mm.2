Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427DF606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTqsP2PA
Received: by kanga.kvack.org (Postfix)
	id 44DF46B05D3; Thu, 29 Oct 2026 11:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDF66B05D5; Thu, 29 Oct 2026 11:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED986B05D6; Thu, 29 Oct 2026 11:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 026056B05D3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:47:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69E3F8044D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:47:42 +0000 (UTC)
X-FDA: 85376093964.21.AC23CD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B2A811C000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:47:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTqsP2PA;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793288860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeBdTykJBJ5zP35pEpq30uLA6gbbI1i43t2r5osi4yI=;
	b=yiPh+e8+He4+XJGk/9NDIwLpbp38mmjoGUxi9IqKsyelHS33QspGCl3muy1hlpZhNSLUWn
	lCjMQVoLcN5OeUuFdqtJrPF3AhNXnoT+YSPC/p25k2tMZjHxPd5lZwNHnXZQ+cdAMYdCrL
	ec0z/w/MCbHGlZ2RVnbTGfJvNrWYOwA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTqsP2PA;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793288860;
	b=Q9A9viZS0Gwh/Ym3K1b8ceBLPqHI24h7vKn/r3RfzvEMcfMnQOkFgyyWQCPVzBJ4K8niDQ
	kMH8teAHh5F6aNsNN8+CoaOPA/fUkERh26furLCHraD8KDWG1m52BQ1uQ4nDbEpER+O3HL
	SgSLhRhMCkm6KRMkajTlcJMr71vEgP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4908F6061A;
	Thu, 29 Oct 2026 15:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F4D1F01816;
	Thu, 29 Oct 2026 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793288860;
	bh=QeBdTykJBJ5zP35pEpq30uLA6gbbI1i43t2r5osi4yI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fTqsP2PAmZAEPesNIu77yJzu2WgeScvhiTz4nuD8H279nZSvE1OezRAHKmk3C7WWz
	 ry5/blQJFAbCPKWI+sJwySf45jzT5wkQMFvYNiJQw2Gk2HPZMrpGS+ZWU9lkExsmxx
	 Y8Zy0x2D/lqP9Yijad7uSZlsbBZHv2Uysvd6aA6Ay/n71gBHzpegm42Ss10IrRKNrM
	 9KVoPh02+y+wuWPGs7ZbBPvHyUh4fumznfY+Brt4k/NiUpM2Rwj0IMMNAaneRJx/oQ
	 +4/ZdjVOEpzVR9S6ZEU+py0Bwcs8Y6hi1nO5nl6S+AgLivD6kYQpYGitL1O8nrOX8t
	 GT2SC5bE3/BNw==
Message-ID: <bf163c58-a884-4164-bede-974b78f032b3@kernel.org>
Date: Thu, 29 Oct 2026 16:47:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
 <67c30e4c-3576-4ded-a71f-b49075ed42e3@kernel.org>
 <2162e5c9-58f4-427f-984d-0099d9b515fc@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2162e5c9-58f4-427f-984d-0099d9b515fc@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2A811C000D
X-Stat-Signature: kh64rskmiqdhx7bgyxqg59edxhwm7e6f
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793288860-426737
X-HE-Meta: U2FsdGVkX18r4L0B5Cy0P9hT9GQ9nAPupoplC6Z8ZYx2SFab8wSui7HTB1zy/+Qk762GmAwFJVP/RLEdSi6uOyDte0+jyffvtTmBBz6uQb0JopL/BoPEFHYiwEBc9nvDZQzpVhfg68zOVhIz1xx7jrRC8sSas25NL+Jw2jdNn1wcUg9dGlUTJyJMNAFjF6s0+NgGurycjZZzW2a4iq6sfn+/u9XGDa7wp3YKXbnevL1RAYsnOF36ctZ+KyqkAR/TY3Agn05n8EmTphNF3OevdX0w++hM23hrfG8xE55PRk2of0Dn2dTUPJofHCortQll+dYF8ly5aDztRvwE7YH9ZvQtmduW1ULKjU+SL9PX/btVZMpFP0p0PlLfRLVH3AhD5Oadsg9haxXyNJt44VsDxWeUA51VDMGAjPXbkOTI1dACr2LnVN5bSrBxlP5ON8JSKWlTq0rbMwS9skhSUSGu3kyr4vd2v/Wr9YxhoUOYqOVSN2oXgmR005TwSh1nZoL9izTqnVi7cgjaMjGaNxGPoq1zr6a8mh+GuDgMsM/4r9rF5LqxXxM74T1Ul6xOqjbh/bJ9M9YXh3ieDhMQisu8JsxcUvYIdklNBO57KBXvNVKKXln9Dfl0N4k1Veo+vfaXDzkC8e+E773ylIdgc9XqWEC6WQqqR1BTV4/hTMdaX0gH7QraDaZTk9Ie/eIwhYUylTrx1aIfIkFbiV3Tay0Tk9fYBcAbHaqMxdIg6qtFiZVP6TwlgfgwACV0XswslUKOeUcCNUMhI0SsAVwIgM/J6c0yP517T3Ka3zuKdXIQOhe1vQogrr+eqGeEXVfMoKKd3iTM3X1Xqrzsziy6irOZ4QBPgeRdXIB0sS19gZwsj5nPuoJdjeRIx42oQw1TIxO8Erw/mH+XcQx8MUDVtoDhz2ksC3rIBg6oaphs0n9RnA0aOnH5gKWrlGsYqTIME5Jg8s1YocqTNgfg+JvloY7
 H+y+9S9+
 b19bIysx7Ofwq2dshL2/6IvDiZZk/0msL2ghljKIe1+ni8YHKkZ6L+5lT7+yiF3pZq7wAH8MbVDdvHmGvpmWMmvRTuGtCg7XSoMVFnhpB1wNeTksWRo5j9NZXGFsKaJgetGEVbScm1BWXkYoBKColXzKVu/n0OMYuykNS8sz9jMZ7U5vE7Cqs6DbvSO3159wZ5YzjL7Mx/SwUXTXRQDkaUL2vjZp1QMMf+KG0K8OtITgX/YMozY34e2XGgZZt5uMHfkOf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 14:37, Zenghui Yu wrote:
> Hi David,
> 
> On 10/13/26 3:39 PM, David Hildenbrand (Arm) wrote:
>> On 10/11/26 18:35, Zenghui Yu wrote:
>>> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>>>
>>> uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
>>> chunks of chunk_size and moves them one by one.  On arm64 with 64K base
>>> pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
>>> the whole 32MB (UFFD_TEST_MEM_SIZE) test area:
>>>
>>>   step_count = nr_pages / (chunk_size / page_size) == 0
>>>
>>> Because chunk_size > page_size, the test then aligns both areas up to
>>> 512MB, which points far outside of the 32MB mappings, and decrements
>>> step_count, which underflows to ULONG_MAX.  The verification loop then
>>> runs away and the first dereference of area_src faults with a SIGSEGV.
>>>
>>> Skip the test when a single chunk cannot fit into the test area.
>>
>> That leaves 64k untested, though? Why not adjust the chunk size accordingly?
> 
> Right. Apparently this has never been tested on 64k :)

Yeah. And if we start supporting it we should properly test it :)

> 
> I agree that scaling the chunk size is the better approach -- it gives us
> actual test coverage on such configuration, instead of bailing out early.
> 
> If anyone is interested in it, please feel free to send a patch. Otherwise
> I'll work on it when I get some spare time.
I guess no rush on this one.

-- 
Cheers,

David

