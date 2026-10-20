Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D974C606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LOnZjXNC
Received: by kanga.kvack.org (Postfix)
	id DEE966B0422; Tue, 20 Oct 2026 03:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F956B0424; Tue, 20 Oct 2026 03:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E3C6B0425; Tue, 20 Oct 2026 03:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A468F6B0422
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:53:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36AC5A093C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:53:08 +0000 (UTC)
X-FDA: 85342238856.18.511396E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6369B140007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:53:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOnZjXNC;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792482786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oreWRsHu0/Y/Reg+AkC/KD5bgP4fkoJRzWsKaFNl2KY=;
	b=lSk4DstJ7ZJRR8RSkmJYyhosbqmUkPanxCn0o+m4PKnVh4zh3IJhbaLHCEZdTyHKBiMo+O
	4Xts9iDmsPso+JXjIyMFkPymADEzqcwnNhMAg3QP77rhuQHeRH0K+DdwywSO3g6df/TDZl
	Af681M8JiORhARBxvzB2Wjwk4ltVMdE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792482786;
	b=xQDxfOKrjnGlPw7fCnhrGoPGtvYrrX4CdGrSDZ227H4e2ZUgQDzjzhULULKBCSBrbE6F/w
	jk+lbDq0+zZNUYZCAgjhIJK+7HkfWkjXGJa5oH1YI74PWjNDPRjAuY1Mpade5V5sFqVzWE
	B4oe6iOGz4/sE0SpkAGiUIC9whIVB1A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOnZjXNC;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45D9643436;
	Tue, 20 Oct 2026 07:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085AB1F000C5;
	Tue, 20 Oct 2026 07:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792482785;
	bh=oreWRsHu0/Y/Reg+AkC/KD5bgP4fkoJRzWsKaFNl2KY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LOnZjXNCL6cpxfuzxz3pLkyebgaHRvb6qiN7MLYZggTKKbawULXCFlu2i/+HTq6R2
	 qujo2942aZsU5deb4T/4Mm6v+3ZxuqDqVc0H1e/5C9aS5STCF8QyB8vj46R0a46MS7
	 glyKhEgBTM8O814OqO8ao1gV/AHHhG0ZNuNCBCp/Hnjy4q9635desihFiDPwa84fnH
	 dGIc5y7CQ79I7gAobtG3JU2Ya/Xknj2iloMXbJwH1AVoEEXqugCrsR4Bes38VVSZny
	 UBIv+SEn5B8thLRBxaGg5p9ks/0Gk6+a96UZu3C9yqYgaAhAJS4XHi21w5ZhvBx4Zo
	 D0JwAM8/9d3tQ==
Message-ID: <95a5ab94-5d91-4a01-a417-19f27aa91b54@kernel.org>
Date: Tue, 20 Oct 2026 09:52:59 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, kaitao.cheng@linux.dev,
 chengkaitao@kylinos.cn, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <877bjowf9i.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6369B140007
X-Stat-Signature: 7b4aieuew8thy69cueogb19wukmy3rgn
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792482786-659154
X-HE-Meta: U2FsdGVkX1++WNMdPz5vfhbjVdm/jWbisnoqoajaId4WV+Y0mZE8YtapJZnw7z2Y/Qbvf59smq3N/9q10Vhkgr3kWD8brfJL7mEBo9y2z7AvIoxfUMsLn/S4wUuzMX2+9Hn8RjxZOWSDQxjIs3JokUWAkJGH+mBUllGgVtNLg+sHr3fLjBuwrqaCPakQJbH2GL/RIWP2mvBHXMdykIp5c4gD1Bw5VGVdB9rl1LAtdVluMftt8bULZ3w5/MC74XmZy8kOc8LcpOkeliUW6SPD0qjS2LZR//0ddr66FdLOgREtjhr1eVhOO2MWd1r5APt8GmcVvKM3+DdeGlXEO+/DU9uPW3WHjTu/7/c/8vUMSYheA+pY/7VfHpXo9MEp0vBUiYKkvuWaPYqzZ1te3kIaZ8EUyG+8eX0qnqveBOn7KS8qp191epFc3kUpf+YxNyY9ybCpQlcXmOF+E/WI9O/F125HeuzCJrDP6nOnPHumEuKZBHIEpmeAUklr1/WUC9Ef4jFhamnav6oMnkqpVYxbVFsNIXiwbCcbJu9/Tg5eohg2dKvhBgzaxJXx1P+MDjjMuEecT89S8ukHLT7LVRtEHCCOpnzRia5kVsQbL/fYFT+EJczNChcIfFBEDFlnBdk9d5WEHii195UH9A1owOwmGKgZNbGUhjpCbiY9ceN3/yaIYi8Nlaz+kfPe0aW56idA7joQFHudtyP3C/99fOeXdnoolT4MPCFttGd4vpFig4O5+i6AbNUR28Sg8/84nSWlrF99yA5jkM8e8P+3XGsyA6yNeqhxhmyHM9wxU6PU2PkdV/wI0vQb+r3yMAiK6JJIW90SQ5KiwRRzYuYFSrDi5lJIyhfeYAtDQx0wsc/cjX3Nga/wTm/oSQHPnLTaXo5RBDAhLtFgSLlDY19PHf1A/GR5pbhEuHXGu6CVlGtLwSjCNqgYYcIJjdMvkh9nJY63VrTpdDQjHISrrtf1z9Y
 Hvc9VsIU
 jB/1ZtAvmYpAsNw91Zb02bXWedCbFLaguSM6ydK7PLCMVC8AfEX+WWozf7+R5NbYymxyXQaKPA2BIhPbcL25E+1YjvCfYr0kjPO7MYl7SqoRdnnU8cy5PKMRjq7t7iRFcxUhARIIf5cgIc/e/i4WgODGE1uCWFMlEm5AKBEJ/nClAQ83v2pqgvy9DVn5uRhOdCG2m5xEnTcdRfNJWKiEicIuwd+wTNNKQ6mcdcCb21eSwzIE8nngEoxv/6j1uZLJ2XdG0mCTd+UQo0irXi30JrPKMGGAVmT6jpAvsYFV8xv0zsoXgv2knTWGqGLLj7+MonQsUAm8QWwHdTszs4AUcCFLfPtVMxDoXe7hi7geR69Ujv+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/26 15:14, Huang, Ying wrote:
> Yuanhe Shu <xiangzao@linux.alibaba.com> writes:
> 
>> On 9/28/26 20:12, David Hildenbrand wrote:
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

That is indeed better.

-- 
Cheers,

David

