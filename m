Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE205C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383796B0166; Mon,  5 Jan 2026 10:47:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3310A6B016C; Mon,  5 Jan 2026 10:47:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233A06B016E; Mon,  5 Jan 2026 10:47:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11D516B0166
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:47:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9AB288B3B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:47:37 +0000 (UTC)
X-FDA: 84298340154.18.F71AAC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D8CB0180002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:47:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X24i1ElB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767628056; a=rsa-sha256;
	cv=none;
	b=qUFqnqZf1uTMsgUxZl2DcOrrkxCL4osWDNq/E0hdgExZFV1ndnqEbjDnpnVEWOQEETo6vG
	K0XRzSMTDFMI8FuC2FJHQrIKF4ZjwBAduBB5RP7HNUJFju7FO/3v6ReSJ9EKrXHrEkYw9y
	9jqZWhZnWJLuLa3Dfmrix8LZDjbf61I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X24i1ElB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767628056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1rsslmBgiMQy+dSxfGDIjno39Zg+6YRvf7rbvq9vQY=;
	b=DpUVrzoUwJLTRjIwQefdUgEp15LRmMMQ71zGgU0f0c3vNASYHxv51YFWvdbGP3y5ncQdtW
	6TVfCphJqJRpQqpJ2FzhJdJyOfCsNdyxgXLyQ8Ww7MLau8FVUAJ8kh9rlNRa+aVwSMKKXw
	kbQZ98gBGITBma1L5UXBeg/XuBiOlCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E949941B6C;
	Mon,  5 Jan 2026 15:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBB8C116D0;
	Mon,  5 Jan 2026 15:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628054;
	bh=ANvQzADNiHhNv3LRm2+i7hk6k4iTvSy9hbzpwZaKbHE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X24i1ElBjInjssWJeHWxUqm+aCXxFVonAeEyNnLzEcGm3rXNlWY+/cg/qaoKvkApv
	 zitviB5j8U+oMxJYx/fzNwJcV259ktuMUCdQ3UkAfaUrRrj6GyNMwuUUvNFUD8fsTN
	 +AUStNPwxoLt+Y8jUHySsGigHFPBz1WbTP3rIjkiFU2lwk/76pl6WGgO7xr+Ht9xse
	 sxCco/fqGa2aXF1KNU7TBOmAyfZi3E/aBS+PeyIFG0MlorDyXIDfLKbX78wWh/W6/q
	 g1rNd6MhnUavLjJVZHIKwN6kLqGS0MFI4vkUva7MGb1d2G5BE8XFH4zh79Za2zS5M5
	 O7/2AoAYh7c4w==
Message-ID: <b7425b3d-f614-4099-9f15-51c6c2cea68c@kernel.org>
Date: Mon, 5 Jan 2026 16:47:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] tools/testing/vma/vma_internal.h: provide
 fatal_signal_pending
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <45dd9b02-7867-6e5a-4a64-02c4d43c9b68@redhat.com>
 <18f7f4ff-67f8-4a39-b6c4-893bfbed4955@lucifer.local>
 <7014fb92-0d46-4c64-b3ae-0eb9d6b81878@kernel.org>
 <a09462c7-af2d-4282-89e3-2cc43777338f@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <a09462c7-af2d-4282-89e3-2cc43777338f@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8CB0180002
X-Stat-Signature: tfga3c83pioixr79k1qdwr48khcibez3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767628055-758191
X-HE-Meta: U2FsdGVkX19OMNGE+PwK7Zb7JBOka7zK8PX/J7amoYRht3zsu5LBWC2vewg/NKqZgo8Qxt6ph77XiGvMmw51gMbX0M3lmG0+/FS8tDpXH7HFCCVaZSEDyXrZPpQKaTdcR1SJIr0Jz6wAfEkcjDOAyfGbyzzhzV8wnlJ8oJwW0j5t0kScnNgl3ppIQjcuz+2ldvu8Gyhpm+DUpmJh2xJbcDf4pdWSl+mHE9B0e+FWoFnQtxt5WapdvYcKtbKuNMe5YkaLXEAWcUFbakvy6TcA3e/ho/DCqXKdDok5ljIs26vMRKe30q6qdt8Hw9HCce/rSX3QDOX5AuJ6c39jBz4IxYJxDu71QmaqdWh2sAg4IjX2W64rvtUqPcyKRTfUkn6nVe7MkE3i+kQ+I1ycL2Fkgv+SzEzVloJwwCPdq5Avsc1wBLYtiG9p7qulHeGWNvS/SXdwTThzX2wzQBpGqrGh3aBzt+ezpghhY5CPcWRVgir8frMjBdEtUAI+Zkbe1HwskenLYz+XcELRL4ND/sLRB3eAw3FnPOqakTtVb/2CyT+dfIxjHfA7nPCq0oQPAIB1ddAoq3in/ysTxtF6tERIlNt0lGSo0VseDjdAAPM6+cO3k4pYPJ2AQ5DK6LGbq0oOam/bDQWuAgGQac5bQ1kmGQHTyMkYTs8hFmY6HltkMeFzkb6v6dQlBpMXzfid18Waldqpc0gEb7T0URIt2l2cD/GddsCMi0nAL9eRKhq3hzV/9stwI2UqMD7xwTG7WZXRuyLCnouGzMlMgXVu74OResBOxbHG1zakUOz9nKUbGB+ABl4HyLsic9SqNSWWdgTfrMebpaxvbcMNox5s1e4bmlP/zh2Bu4V2MdxAxc/bWepmjJRG7UB5nYr0NGDfXT+LqNMu0vfu7Ffm5tByEKj/mmLgxmscGMHLa1kDcp3do3ghxq8y/VkK3De6At6RPM5l8Lu47W10WpgoWoyrRFH
 wqXSrNAj
 Fo02204zx9X1PYYeRzWPy4QNGYlgOEIIrEE5X3wV6q+shSS4jWLs50WqoIIJdT7kSAQk6Fk0qeeV40N845pMV2/Mu/m51n4FQcJrFrq6YsXRy7TeeCIRia/g2AV9CY+jWzqdsexDVztDlo7lcZ5wC5oQKY31SEDAH74VIcBTMvo10wLu86ozLmWe/03+rGLE+AL065+7Az/3VwefEgNtfB3vlJ4+ioYICp8ZXn26scuU1r51d8mkBWPtFK/HhFHcFhO98d/vAcuoN6pVrOTuIgdds7UGF7y6oSZca4m0/v3pKTbMB2rlX0i8MF9P+ZIWKVFOeW+KUd8JGmG+Q9peJKJuq9SFpdJkjUjVg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 16:36, Lorenzo Stoakes wrote:
> On Mon, Jan 05, 2026 at 04:06:38PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/5/26 13:18, Lorenzo Stoakes wrote:
>>> On Sun, Jan 04, 2026 at 10:15:36PM +0100, Mikulas Patocka wrote:
>>>> Provide a dummy function fatal_signal_pending, because it will be used in
>>>> the following patch in the function mm_take_all_locks.
>>>>
>>>> This commit avoids a test failure when the following patch will be apllied.
>>>>
>>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>> Cc: stable@vger.kernel.org
>>>
>>> No, please don't cc stable. Also don't cc stable without a Fixes tag.
>>>
>>> This isn't backportable given you now need to backport to 5.10, 5.15, 6.1, 6.6,
>>> 6.12, 6.17.
>>>
>>> I'm not sure how Andrew deals with a mix of Cc: stable and not-cc-stable patches
>>> in a series, think he generally doesn't like, but I'm not sure how exactly we
>>> are supposed to express order here otherwise. Andrew?
>>
>> Can't we just have this hunk here as part of patch #2?
>>
>> Backporting should be rather simple, just drop the hunk on kernels where it
>> doesn't apply. Sure, a bit of manual work, but better than making our life
>> more complicated here.
>>
>> But maybe I am missing something.
> 
> Because the patch was sent with patch sending-101 issues (yet still merged to
> hotfix queue inexplicably) so I assumed manual fixups might be problematic.
> 
> But actually because we moved mm_take_all_locks() between files it'll need
> manual fixups anyway.

Yeah, that's what I thought. Backports might not be that easy either way.

Sending+testing stable backports is not particularly fun (I have some in 
my inbox ...), but sometimes it only requires one backported version 
that can just be used for all older kernels.

-- 
Cheers

David

