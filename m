Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9308606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gAlzpKVC
Received: by kanga.kvack.org (Postfix)
	id 1A8976B0153; Tue, 20 Oct 2026 07:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B6F6B0157; Tue, 20 Oct 2026 07:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F351B6B015A; Tue, 20 Oct 2026 07:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D47806B0153
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:27:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50C6340134
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:27:51 +0000 (UTC)
X-FDA: 85342779942.11.AF5FAD5
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B825180002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:27:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gAlzpKVC;
	spf=pass (imf16.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792495669;
	b=fO+ujd70pdSAwNXYFVQHFwCBMED0hNyegp5V2WJlDxp3+aBGf8aZW/jczg1W2A2Q8oH1el
	WsCYcw348qWTUWc/fTMgt95GgI2ghEArH2Xac2WuX9/xLo+dG043bYj4BnpbUyPyylN39r
	a6ToaZNnVVn9NPInSnOtzxGSRoeRkgg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gAlzpKVC;
	spf=pass (imf16.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792495669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54dQOH2g4LxtCry7r3xqEFdS6hXfu/AH/gaD2EbPV8k=;
	b=MjpMMxrBwc6q2C/6/6usqzjqjQWhoFOoeVk6LXUDLaRixf/LnlPIQsmzDNygOhF43qvvju
	yHNZ5HsQuawjXHH5TxzG7uUuG64j4bERKATwazzauXRF7fX/BLoAMI/waSGy1T2jArp4ch
	iUpspQqvRaF/XiogzUA8gZkXBacUFoQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8sOUs6FJNb9GzvdrnPJnQT6cgTMijJ3pE3NhbGSXCRE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792495667; v=1; x=1793100467;
 b=gAlzpKVCZ1wbgklRWJJr1JfcWJ0kgLzMdA+eCoHVyvL3LpdFc7XJT8pFdEw3F7Fdmy3XLlyU
 1bL/mkwRt/q21wfgATsUl+t4w8NiKFCKMtibzQkkDeqxjIetWFwJAQDTcDykAqxppUaEA8ETzBD
 WkN9ODQCpw5CDMvRD+8ww43w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f5736f767ff4eb48;
	Tue, 20 Oct 2026 11:27:47 +0000
X-Mizu-Trace-ID: f5736f767ff4eb48
X-Migadu-Flow: FLOW_OUT
Message-ID: <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
Date: Tue, 20 Oct 2026 19:27:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: david@kernel.org, akpm@linux-foundation.org, vbabka@kernel.org,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, ziy@nvidia.com,
 wangkefeng.wang@huawei.com, tujinjiang@huawei.com,
 mgorman@techsingularity.net, chengkaitao@kylinos.cn, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <877bjowf9i.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B825180002
X-Stat-Signature: e8xfopkw63afjibce784dfcboug56zbm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792495668-836413
X-HE-Meta: U2FsdGVkX1/6DeZiXZCbI+VCvoxTGJ8RBi8uShLi4xyY2dHYeHoaMB6bUtKhUNPoqkhNJp43CUqqVzujsXDN4rlN7duaZDq69sICK2gsx0zCdxmohl+uW7T3HVc6ijrwwWPX+nNaB4DMfKlGpR8nb/hjhEpwBKVZPL2sO+lM/1W4OXf2ZIiIddeVdLcI6E2wbqpq/ByFa67LbznALqRMi3mqgPDNDgikIQzTOzSoYZdIgVgy50aAvI/EKWdUm248tKovuzK7fVSLBwOZJcCJlEllbyN/tDxQrdQq6k/R3GBT+UsoeLybNCrj9DquzfHLE3pm9KAExV0pC0CCzzmGEEUJa5418TqyUWJFffj6dVajdk0VwERC7I7ZdTAjI7VdJrnfR3XrTEthKE3DwWNMqe73kQ2v284jraEsViHK8So/ATry+7eTxTln3gasEPg1loM+LrvM+vuLmkfBwe9kph2qj1HLIaHGOCV94PG50ZCzZm2WSKXX3fWnG0euU9v3nQBYUwC3UwXQAacpMAEyukS4t79AK2iVQlGdzlu0Hd+bGq0NxqV4DDj6aJ5Fw0FAFlw2JUELM9ukI/D3SFOUuX3QWe0McHbp3OgAf/9Zm3yaoK7Lo08P9LN9LraxP1CXDOB8FF8p3bgHXb6oVwV8Hbxm6h7Bh9tFAqwalRrGfys7tUXiAJmsZnEsipwBFD6rBQNDiXGTaVs14cdWbk3rR36+ievdDUnsqzn6yexURghVGXTaK8igNtUFiGNjEjWedX8Kq6k0fXZqiVUWZY71+vR48PV5yftjWGcRgE+hopuk0suB+6JxLSAcksui6LsBBEcQ3kyFBwxc81dgMvvNtf6mXDwm15v2imFsRxkIcnAo9RB0/ef5I5QdDvSx/zkNc0bTrK9tNk3mQ2VMP9QB1oilbjiyH7vIR4evbNOJ2rhCqniRzSg/BXG1p0Cub57SRMfcJ5SLj/E4airX7uE
 GeQ70Ynq
 2t8XivwH1+FirpBVDZCTlz3fM8/LNMZ7eyrSwDmo7K5Wh7w7VvwdRzyJzawqn2A9FzpxDj+VJzOMKW+BEJPkthvmifp1bkdjSHIDQ0hAaGpfLYFu9OjvJuWG36jjETLMiUsDnkBsE6JMG/wDC8epFYaA9Whdk6fBR6U64GkQ7uXeHPyhhk0jRXazGJgkS4m1a3mXajy1kwuYZEUbCmQh8jzNZk8EfVBWTqauDxUvbtHPNABn/d+4OmyQMpN4s4RxPq8VhPjpuZ0gjt96gmxkndRULicFnJffOnH7Ztx+nmh31pn8oML25D1n6LU2Kvl3KBMtMZxjBU0XqE6Z4zpkL+AIX5huiubS+YbQT17HpAKekDRzB4otDpqlsPxeswLIS2LUjgmYu5f6Ui8by5LifLmibfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/11 21:14, Huang, Ying 写道:
> Yuanhe Shu <xiangzao@linux.alibaba.com> writes:
> 
>> On 9/28/26 20:12, David Hildenbrand wrote:
>>> On 9/28/26 12:58, Yuanhe Shu wrote:
>>>> folio_mc_copy() does not close this hole: it only detects corruption
>>>> at copy time and only where ARCH_HAS_COPY_MC is implemented (x86_64
>>>> and PPC64; elsewhere copy_mc_highpage() degrades to a plain copy).
>>>
>>> Then they should implement it.
>>
>> Agreed, and nothing here replaces copy_mc.  Two things the check adds
>> while that work is pending: on archs without copy_mc the plain copy
>> does not fail, it consumes the poison - the same poison consumption
>> commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
>> THP") refused to risk on the split path, at your suggestion; and the
>> refusal happens before the copy is attempted at all, while copy_mc
>> recovers only during the read.  The check and copy_mc compose.
>>
> 
> Is it good to implement the trick in copy_mc_user_highpage() and
> copy_mc_highpage() if the macro copy_mc_to_kernel is undefined?

On architectures with hardware error correction and exception recovery
support, accessing faulty memory automatically triggers an exception,
which itself guarantees atomicity.

On architectures without such support, even if we implement this logic
in copy_mc_user_highpage() and copy_mc_highpage(), checking the hwpoison
flag and copying the data remain two separate operations. They cannot
be performed atomically, so there is still a race window between them,
however small.

Moving the hwpoison check after the copy might address this issue.
Is there anything wrong with my understanding?

> ---
> Best Regards,
> Huang, Ying

-- 
Thanks
Kaitao Cheng


