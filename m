Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0648C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5D86B009D; Wed,  9 Sep 2026 11:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77756B009F; Wed,  9 Sep 2026 11:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C9B6B00A4; Wed,  9 Sep 2026 11:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A53546B009D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:04:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8E0CA0264
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:04:27 +0000 (UTC)
X-FDA: 85194544974.08.AB0486E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BAC0E180016
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:04:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZylIcvBH;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788966265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaCx51XLgCN8swqlh0PQM0NitDh9OeH7sXEe5ved2kI=;
	b=B0A6l8yGn1PcrzT9paQfVuPDAkll7LRaWIEWGXqPQcWevhKm650X9/AsyVnvVBQzXgfUCt
	ZGXod3P+E32jr0D15EM6etGIG/XuZo+QE+ptwoLXnvuUzzzCzXMnZVQAis/1CXZ7YdLg5w
	sBYPhIgXzioiW5m8eEabP9t760E6PJY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788966265;
	b=oiqwuu9+7F5VVEhRR5lMrV2I7B+j3a6DDi5oxWL//xq2lRbbyL/pzKqZc9Q9j2BfZWjTke
	R/xaSQweh/N6+0aDWnkcad6VV6mvsx64r5NBHiAaXR+J/VGQ1V5nyUbQyw7axr8TKlGpcT
	m9EbZCL7fSnVuIBK0fzR0++LpUSDFEU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZylIcvBH;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D549402D4;
	Wed,  9 Sep 2026 15:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83621F00A3A;
	Wed,  9 Sep 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788966264;
	bh=iaCx51XLgCN8swqlh0PQM0NitDh9OeH7sXEe5ved2kI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=ZylIcvBHV+U8VgjaR/O7ELvyeen4wPPHN8964DOH5QZKh5rmflA4IOcxhW/LYp7KI
	 Rdl9H1oD6GmHKu7FKKR4bp6nnod5loXrYKJXsjs/dp02Lc4DzVXjMjDHJIyptd+QQ4
	 ubsOVRM0mErynwKlB7bBdINIFlBhLJbFGmyZdaUqwOyYQdk92qykS5UEWzDU8HD+rG
	 u8MkrMCrZBpTbeaYGnK+hffFIJ8BlfC7czrsVp1IgzL28X4ezxDXbb99qRv+4LBRH3
	 GikdImAOqhznXmqK1mJ3l5zzJwJ6S8n/96tG5S9YEKHyH3iZBnD2s5TJ4PjHrGyJXv
	 1569KuDR5mzXw==
Message-ID: <c991727d-ad63-46ec-a281-d09980ff08ca@kernel.org>
Date: Wed, 9 Sep 2026 17:04:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 0/2] selftests/mm: Validate selections and scope
 memfd_secret setup
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Tianyi Chen <diannaaav@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Savitz <jsavitz@redhat.com>
References: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
 <CACGbirTZFsyQhOszpfiHhrd7Red-L_Z_=ke7DbRDe5SQfzi9Pw@mail.gmail.com>
 <bef8f543-ffa9-4cc6-8a7b-6118daf14f76@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bef8f543-ffa9-4cc6-8a7b-6118daf14f76@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 48gdndnbt8o5spfqq6j3aoffqj8krdyu
X-Rspamd-Queue-Id: BAC0E180016
X-HE-Tag: 1788966265-295015
X-HE-Meta: U2FsdGVkX19nwaWd/ELf1rjln9ANigW7pn851xAstRUw/6YEQQAt5x/O9X62RzopVgDJZw5M93YoU/DbpqpyIH1K5B1zoLE6ueDdjlZViDbvdcxilbs4y1cuLxqnb2eLBCz7JCMkCLjPe8tH12O3pAHTaauWTQkUCHCOQCU49+M39XiJOlisowhUeG0AH6veuzm9Xfmgrzq7zFw455RmRNZxTdDQbiJg6xggJjA7FFQ7KG+USrtfh8towiUwP/xeC5nAHaj+z4svCIfSWOhvT6UQpPzygFkaxyo5axFuL64kqGoDIgcEs+x6+cFWcm45F8gjy121KAIhfNKvcQdiTU+JyFc3JVSfaIrzNAJumOLsvqAcgp6b28KYWJrZcnag/rB/orf8yq2q5vZVSAI0u4sHd1ItYscu0ptXXZT3Y8fJMAr9zL1xtgYfupNFhCxMiOrOMnrWuU28mRCUyIUCCXeiRG7cRO/vk/QknWjyN3qZcd0XX7S79LidE/Ykv1KEXXp9QUbRQIcvZqF17Q3e/QqKrj2uNJqKsLQRrJqcUgG7nEQSSP4DtOe4spRgCIz2kudF21NqArhYLf8L3AYTkMp/zPuSMly1PZ1DKfLQT0ZPE3We0VEgjbqcdN6VXKkjO/xjX81eIg8JZ6rJ/5U964r6ZYGAaHnLzLlN+aPYj8m2liL75Lr8vqZRl2eLeSDjsLxQNEI5Fa3N7dW+zjKciZ/O5DGA7i3LutNyJ1p7nEyHyZYkgCI2vR2jqORjaypgidD5uVUNN9jl+rnRhENxGKk5dAi3CvVQgcJXjPU07nSRE89+vuOyQpzI0h+4z17IiuBNUoi+Gcb23ss/kpuM5CUZgqjROB5pYwf0aC0aCr5hgrdd02Nqg+ah0s3VtQYkR68vRq+1iTNOUHCVQu0VHYM3r6rlYyO5Q8YZH+KOVjFx1Tgt+yZ7UAI87uFZrINAJXH4DlFL6ahdfrlVcnK
 RSBSSeOm
 X14rlLzF4LLsaL9uX8nSyg19qVBHcYgmSH/IJADYQwqSFsmL+pvlRqongxuIG4GXmwQucHxaLgYSMR0Sn+gb97V7SVxqEKO70fFWhA9iCfMN+Y0TFYFWdgKIoqCV/yEVRuXVI+FQjGolmUJMD5e26GcNIZErxX7sU5F5b20lLAhSql/2qVHJpADwvIg7UIU6jyxjAN5jmuJIG1lW8LGozTVm5qAlIn462UdRRGsw9t5mufjLJX7G0ve3XibOX2PbZqwubVA+QdrmiPe61krKT3g0tGS7nogPj0WyzutUNywDePtFDD9d98zOdpmyi6rfOniyrJqO9CvEaMT6I/IQB9P6x1n+56+Ab+3xLFgzequ8WcVv6JnV1sz5aac1Nr9TvDh5A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 17:02, David Hildenbrand (Arm) wrote:
> On 9/9/26 16:54, Tianyi Chen wrote:
>> Hi David,
>>
>> Following up on your review:
>> https://lore.kernel.org/r/d6ca7f47-39bb-43b4-92d6-63ccc148ebdd@kernel.org
>>
>>> Who would set it at this point?
>>> Can't this just be
>>> VM_SELFTEST_ITEMS="default"
>>
>> V3 makes that change: the default is initialized before getopts, and only
>> -t changes the selection. An explicit empty -t still fails validation.
>> Both patches use Assisted-by: LLM, and patch 2 carries your Acked-by.
>>
>> I have resent v3 at the start of this new thread from my Gmail address
>> after delivery problems with my previous address. The patches are rebased
>> onto current mm-unstable without changes, and the focused parser and VM
>> selection tests passed again.
> 
> That is new:
> 
> $ b4 shazam https://lore.kernel.org/r/CACGbirR9PNt4uhqJFATsOWnwmsNb-v8zau-Rb+9Q5SZmY-=Vug@mail.gmail.com
> Looking up https://lore.kernel.org/all/CACGbirR9PNt4uhqJFATsOWnwmsNb-v8zau-Rb%2B9Q5SZmY-%3DVug@mail.gmail.com/
> Grabbing thread from lore.kernel.org/all/CACGbirR9PNt4uhqJFATsOWnwmsNb-v8zau-Rb%2B9Q5SZmY-%3DVug@mail.gmail.com/t.mbox.gz
> Checking for newer revisions
> Grabbing search results from lore.kernel.org
> Analyzing 4 messages in the thread
> Analyzing 14 code-review messages
> Checking attestation on all messages, may take a moment...
> ---
>   ✓ [PATCH v3 1/2] selftests/mm: Reject invalid test selections before running tests
>   ✓ [PATCH v3 2/2] selftests/mm: Only prepare ptrace_scope when memfd_secret is selected
>   ---
>   ✓ Signed: DKIM/gmail.com
> ---
> Total patches: 2
> ---
> Applying: selftests/mm: Reject invalid test selections before running tests
> Patch failed at 0001 selftests/mm: Reject invalid test selections before running tests
> error: git diff header lacks filename information when removing 1 leading pathname component at /home/dishy/linux/.git/rebase-apply/patch:6
> 
> 

I think what's happening is that something in your mail sending path wraps long
lines and breaks the patch format.

-- 
Cheers,

David

