Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D55D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DB66B000C; Thu, 27 Nov 2025 06:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F55A6B000E; Thu, 27 Nov 2025 06:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B526B0011; Thu, 27 Nov 2025 06:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C57C6B000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:30:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DACC0B97FC
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:30:11 +0000 (UTC)
X-FDA: 84156168222.30.78B4CDB
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC04A8000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:30:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SI3P/f4k";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764243010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZ2vKUZnYoEZ15SSkH2UVnB4dLdcLSe3Y7SscFwSwJk=;
	b=Icnnbzpk/U+vqt66sQT1RngOS+uSTdYjZnYapwA3L3QqYFp6tSf8lXYLRtXbUwqippEoGN
	3WkG9fuEbJGpyJsYdkwuJs1RXHCVjB3IgOZrhC4NIX5q/J52V01bpf/T+XG21cK8TnhbU4
	WZ/N7ezYWOA7RD/0+D11e/+PaeRRh1w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SI3P/f4k";
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764243010; a=rsa-sha256;
	cv=none;
	b=vGdnoxUFtFeoYGYTd4YMPHSLRcrGfqFfIuTwcGjqm/mbQKR0s8byt2O9HPP19DkA0X0dL8
	HX194YGS4IhEHixfuljlCtw/1iR0XObCkuAwpQLi+sr8NBLRTAibWM43HNkLCvmc7IByoA
	Mz+wIM0rXvJWT/vjJeV2db6H6Fg+BQM=
Message-ID: <4056b77f-ea23-4c49-975c-006a4a8b4733@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764243007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZ2vKUZnYoEZ15SSkH2UVnB4dLdcLSe3Y7SscFwSwJk=;
	b=SI3P/f4kCIFCa2CK/7Ve19704PX3asqZfw1eur6iqTnQ2DcyEYnafSAgjfNkaVEAWIdf6F
	4y/29YH5E+YbKOhori+Tcfdn1zDKxrKXDUdJ4VsrgTDSsir+6RS4CenyUPjQViU15MV41/
	cRdA6/m2N/dRT/uH76Sh1mT8V24Y+9M=
Date: Thu, 27 Nov 2025 19:29:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
Content-Language: en-US
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: shuah@kernel.org, muchun.song@linux.dev, mkoutny@suse.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-3-zhangguopeng@kylinos.cn>
 <8ce13061-b4a7-4474-9e57-bab9b1a62b63@linux.dev>
 <07b9bdd1-3499-41a7-bef2-9428935fd3f1@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <07b9bdd1-3499-41a7-bef2-9428935fd3f1@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DC04A8000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: b5b577uab3ozdt6fugmncd7nw67y7am5
X-HE-Tag: 1764243009-116838
X-HE-Meta: U2FsdGVkX18IqOZKN2OytlXBgiafp1KweTcHPJAlW/6l07NCLNuQtkO+2lvms1zhwM3zcmY8azJxcjqoBQZCUXkrU5BWP792xwJMYu3x+XNlhPm9Q7XHJ4dhKjjMIKDz6U4+XB/ZTYL1zs3zXvgKIxAaIdBElO88e6r1UKpb0YIEIlYL3q7ILXizlkJnBxdSYhopzn73l9Vc/hKHICh4CtGV6YFEKoCUljeLNXX+AtC5k5FxWzYWindShwcFQvQTAwHoylCNL3Sv+l5BiWDFaiOEOtxhpk2GvxF2vWPuLKFGwXCxo3m+weza3r8OMP9VXa2rlEZB6qKb0dSgrPIA5RoKLZVTuihZXBNP5nhj0eAWwKlMF/nC3EGno8Eek1++jAOJO5RykbI9YsjkqvDoWXaGjDTxQX77jnXdJod66CekKTsIa8IgjSHIAkVtQRmUutNfeGKHN+LmPJpFWvyTuLjZUBd+A67yvsKlALdHWe6WADqyyFkhXOC+1Uq5HvMa3vqKGET5sQj5E5P6w6DDAFOaweZigrOee3zsQhU4lo0RTk3QwbY6pwCSOmLdikckxQD88bhXbUO7PIBTFvVVUUnR34H8a25sRpP/q41FZAOa7dRf3Z33cMonnx3v8K5kiMQ5qw/qpfXnO/yvUxx+/GjCe81bSji6JVAsq+4llA+WnqpoSRYupJUSwN0EO/QtBE8HniIR436nVMqMk/FLwEwthdDYHPxcASf3q60uDFX6J+pc8EweskiZPwoXdG8jOKecGYaezI6S7hKmoKzZfxNu1oiPhs5lOSzvPWr+Ru+k50vZw1NN0BOZLcBvKiqPUhJGdmnmHLyoajYm33IQ/ZpPQvWE5RFTT72kARWsaNDKZ6xWpdVT1DstaYnQ8uBD0tEu3vnFsRjSWQoDI1K5ZQoWsJFonQLGsC6W7FR+hleVob+syqViOsOoOcC87SeUmROE3fXbhl2GZga22qU
 w/YvdBC+
 v4WWRHVWtN5vTvB8ipvONP3QhIVg/MyrCOZVTG429Caan0VIBFgsSJNvoVeo1ah6pNEOUBVKxW1lMha/RvZLP3QXEisjXZJU7fouKTrp+BIJW/Im0STpqGTfob+UEVWxIp3Sc2Pt9MFGgYtE5+yvJdddEVLvM3UeBfxWbjoXBnPJ8sFNBAwMV9jYr+NrBwYmunJZLjdrd1wrvt0wRhPQPqp5ajDN7EXkW98tkMCCiM6AXRZRRw6JxapyF4a5y8OTUWrhStqmfVAoW8kTxRXrZSpeNeM3Du8Hw2jhQKmVcTkzWUE8bHxNHh5L3Lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/27 19:18, Guopeng Zhang wrote:
> 
> 
> On 11/27/25 18:55, Lance Yang wrote:
>>
>>
>> On 2025/11/24 20:38, Guopeng Zhang wrote:
>>> test_memcg_sock() currently requires that memory.stat's "sock " counter
>>> is exactly zero immediately after the TCP server exits. On a busy system
>>> this assumption is too strict:
>>>
>>>     - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>>>     - memcg statistics are updated asynchronously via the rstat flushing
>>>       worker, so the "sock " value in memory.stat can stay non-zero for a
>>>       short period of time even after all socket memory has been uncharged.
>>>
>>> As a result, test_memcg_sock() can intermittently fail even though socket
>>> memory accounting is working correctly.
>>>
>>> Make the test more robust by polling memory.stat for the "sock "
>>> counter and allowing it some time to drop to zero instead of checking
>>> it only once. The timeout is set to 3 seconds to cover the periodic
>>> rstat flush interval (FLUSH_TIME = 2*HZ by default) plus some
>>> scheduling slack. If the counter does not become zero within the
>>> timeout, the test still fails as before.
>>>
>>> On my test system, running test_memcontrol 50 times produced:
>>>
>>>     - Before this patch:  6/50 runs passed.
>>>     - After this patch:  50/50 runs passed.
>>>
>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>    .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
>>>    1 file changed, 19 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>>> index 4e1647568c5b..dda12e5c6457 100644
>>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>>> @@ -21,6 +21,8 @@
>>>    #include "kselftest.h"
>>
>> This patch fails to apply to mm-new ...
>>
>> Hmm, it expects #include "kselftest.h" here, but the tree uses
>> #include "../kselftest.h".
>>
>> Which is odd, as that line hasn't been touched in years ...
> Hi,lance
> 
> Thanks for your review.
> 
> When I prepared this patch I was working on linux-next, where
> tools/testing/selftests/cgroup/test_memcontrol.c already uses:
> 
>      #include "kselftest.h"
> 
> I just checked, and this change comes from the following commit:
> 
>      1aaedc385b9b278dcf91f4e9d0c3e1a078804ff1
>      https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20251127&id=1aaedc385b9b278dcf91f4e9d0c3e1a078804ff1
> 
> So the patch applies cleanly on top of the latest linux-next, but not on
> mm-new which still has `#include "../kselftest.h"`.

Ahh, I see, thanks!

