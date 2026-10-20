Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6726060A261D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WRTeGXwl
Received: by kanga.kvack.org (Postfix)
	id 918316B0163; Tue, 20 Oct 2026 09:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF3E6B04D0; Tue, 20 Oct 2026 09:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E256B04D2; Tue, 20 Oct 2026 09:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 619FB6B0163
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:31:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2ECA8018D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:31:50 +0000 (UTC)
X-FDA: 85343092380.28.F2C6073
Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	by imf25.hostedemail.com (Postfix) with ESMTP id B39E5A0008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:31:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WRTeGXwl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792503108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgejzNpzFsos1ceD0Tyakzy9X/up4gxl6mutO9Y2A2Y=;
	b=wa4t1MxX70Ii7WrqFZ5QM+PPefBNMXLij8L5FHJpa2IubdXulb/y+4jsLWbSRrXW6XXuy7
	Nb5rfIN8eAoryTMnlZLAXXOWibkfH6E+j828Jel/jciJbzxcRzLFoLYN+DYbaBn9Y/5bza
	/bXp88huSuJkmk1m2L1htlQbV8Ols3c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WRTeGXwl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792503108;
	b=XIa18YIx+EfhGJjCM7FnAqTPXclISYhNylyfmegz+d/ephiHnI6/wy16ZggT0Vfr/ewLHS
	L15Supd0bGGzcv3JJk30Gt4Eg/xgmq/Sbi81XMumup+tcKrJ0BvIv2O6udmpcWAy4GqU/6
	X9+MZXfft8ihdJAgqe2hQ7yybt+Nh5s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7ZCru1odRA7o2VqH04VeCwToaD1wfxYt4FcZF/5+H7Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792503106; v=1; x=1793107906;
 b=WRTeGXwlI6uzGTIwXebYRG7lkXHUpp3h/VE8J64NtOtom4i3+ypXKJGTGCqXQ3TrFDsbgA7Q
 5HBz31P5CvWHJYbfWJYFzZGwOplBckCh3g5CMYwO1/ljde2Cu+yPR6wRLKmK2V0vaY8w2iAd2/B
 /exexrJenXWT7k88klQ3Dtuk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 42b62126c2217a5b;
	Tue, 20 Oct 2026 13:31:46 +0000
X-Mizu-Trace-ID: 42b62126c2217a5b
X-Migadu-Flow: FLOW_OUT
Message-ID: <23d3756c-1a87-402d-80b4-c838dfc29f4d@linux.dev>
Date: Tue, 20 Oct 2026 21:31:38 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
 <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
 <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B39E5A0008
X-Stat-Signature: 7ua59yhxcfxdaujnaimwhxir7471jcuu
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792503107-627840
X-HE-Meta: U2FsdGVkX1+0rhrbfHz5kID/70oWk6wd9T8UWp27FAhKqCKLJn2Rj7niBUnDxi70o4wecOfYL9bIZB9SGb1TrbiNX6iWYMAKxMKr3P0oRM1u00DgvJf9y+9IqzWthfSEn0BHCTDcr9GSg3JvCkhX5E2SBh7UjXvGCfsQF13JJ+20794ROqfAKKf/EmXQcYlxPhM+fgqbke9IEq+81omWlUE7nTvdw5wnwbySP4YxE1Lfb1k4TA+VdzNxW3FyfljMWvaPthREcgQ9qsTzpuMIRwlQ3xOrurNna2pdqoWogZwhBqns13kHItnVmcmA9ldb6ED5MM3Aqo81ItRLBi8GgFGwsYO0Kg81AozqI/cSPiU/4DSc5+oHBR5MJxZDI4mNizE1uZWfuwt9yHNGzRwF66CMn2++0DjewbnPlX0du6TBz8XkIbMT1WCVar1etnUeqDefxn/GU9TFjPh8VXfiq3uJtqyH5YuIEVRef13LqlRjl/Eo/XMAxTHDFg1uH9jgfS5ElTkKis9YT8ik3p9Xq0HaMXnKhT01+iFl776bIIcMjzzq46tb03KeA+HTuoPhnHq8X655i5xMO6r2Z0hrHsHFz7oisy2uNzofT61lyg8N2y4hJPJ4mpS5cw1sDGiXvBjNlWQjqPbOJIrmtFgOOaF0xLlsR70apBFAxZtVHOWX976KA+OcCsBmBaZZMwmtZsar8JfUhVMpW+flug9nFFS/rRyYgut9ZpxmyH0hgraj171LExCfGL+PPGDqYRVWfF4tAWEdt8s+Evbtci2HOiZoQ32HGqN9oCiqPdw+Ax/K7Mlbdt/FW2oikblYeQ5HSe74bBzWQsoug3ru96S/02ZWYzfM05HrNzE4r2AdXkO3MsAu+P+fDceiQ94k1iYr4zhaB49yu/U9SU8svt4Rq/UHpgzJPHljf09brp89PSHDBGHyVRKq7WzdI7Z7g0qkxV36A+d0y7LLyxkY2kO
 58uzYSt1
 5p0OOF8KlRr/SBtrZlBnY8D/KFnHY6PvhS2pbCyPIyLTAzucv65UfdwDavmgjwvRNfUTpGsJMbazC3yDEPEOBL0LRLgqydJUtnPmF/X8Bw4oWGv5OUiS3sFnScqdbPAP4/BEp6R0hA0QVRzkk1TRH5CTqg80pIj25OJNKxZXaf+qKiMcpbgfL5tm61xoJy7k6litjev6yJD5CQ3kTqSeR6dIS0h2K2izn+wDh5UyXmnTtPNk4bm0DJgD4XQHvYvgjUtbxyW5ukjNVYll+P/pusj3NN9mdD/SZjBBoP9pyJO8sPeuxeZjJRsb5cJhZchL+v9Clm+lqk0QSyWWxqyL/UhQyqBDQ4LmO6VRaMOe6kU+84RN6aFak7Wy9RBmFpWuJFskt6mpuOSOZI2m3QE38GcYPzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/20 21:07, David Hildenbrand (Arm) 写道:
> On 10/20/26 13:27, Kaitao Cheng wrote:
>>
>>
>> 在 2026/10/11 21:14, Huang, Ying 写道:
>>> Yuanhe Shu <xiangzao@linux.alibaba.com> writes:
>>>
>>>>
>>>> Agreed, and nothing here replaces copy_mc.  Two things the check adds
>>>> while that work is pending: on archs without copy_mc the plain copy
>>>> does not fail, it consumes the poison - the same poison consumption
>>>> commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
>>>> THP") refused to risk on the split path, at your suggestion; and the
>>>> refusal happens before the copy is attempted at all, while copy_mc
>>>> recovers only during the read.  The check and copy_mc compose.
>>>>
>>>
>>> Is it good to implement the trick in copy_mc_user_highpage() and
>>> copy_mc_highpage() if the macro copy_mc_to_kernel is undefined?
>>
>> On architectures with hardware error correction and exception recovery
>> support, accessing faulty memory automatically triggers an exception,
>> which itself guarantees atomicity.
>>
>> On architectures without such support, even if we implement this logic
>> in copy_mc_user_highpage() and copy_mc_highpage(), checking the hwpoison
>> flag and copying the data remain two separate operations. They cannot
>> be performed atomically, so there is still a race window between them,
>> however small.
> 
> Yes. And you need proper architecture support to fix it?

It does require architecture support, but that doesn't seem practical, haha.

>> Moving the hwpoison check after the copy might address this issue.
>> Is there anything wrong with my understanding?
> 
> Will architectures that are not prepared for copy_mc_user_highpage() not simply
> crash if they trigger an MCE during an access?
> 

Do we need to check both before and after the copy? This feels a bit
redundant, and I'm not sure whether such a small race window warrants
an additional check.

-- 
Thanks
Kaitao Cheng


