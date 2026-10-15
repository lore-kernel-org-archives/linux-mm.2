Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A2DCC6B30
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8BA6B0088; Wed, 14 Oct 2026 22:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42746B008A; Wed, 14 Oct 2026 22:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09B66B008C; Wed, 14 Oct 2026 22:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9484F6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:23:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFAD8407B3
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:23:53 +0000 (UTC)
X-FDA: 85323265146.09.AACCEDF
Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	by imf01.hostedemail.com (Postfix) with ESMTP id D258940003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:23:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKUofZl6;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792031032;
	b=N1+DWP0xue9wbaWecHlXH1cL12oBY8hLavIHrxUnM1Q8hPnPEb+y3MqB557m/c2Sj1JR6L
	7tUhn+Gtek6fDPX0F08lkSkcxogqR/YdlUwPNf7rrP/9vexrIu29NykVezt0uMUF09hSoz
	XJMCWzhkWEVrfwYnGG01Y9PSTTh4Eug=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gKUofZl6;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792031032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rFhmBqIgjgfxAD9sxnQNyGCp2kfplwoyuKABN1cENU=;
	b=onbEjIV88GZZOlQ1PDv/SyBx9zg9ClhmjA+Bhnyq6WFKf5ghvrMFSvoHCdjbL4xCfCGYF1
	KLexHkLroDDajSIr4Be1SGP3pf54BwYmSjlHB8ed4bPE9M13xi3YeSjkRHgveeMDpbvO4S
	ai6v8oQSHTft2KSkX0hG04JN9oA92Gw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nUe5p8yDfrxxzbakZWJcPwqsW7cOSu54n5/w3I/l8Gs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792031030; v=1; x=1792635830;
 b=gKUofZl6BXqgTs89E8MKTTxBF6OAgm3Wb0i3YsQW9+YhKg8+KsAmctt0OJnPuwUhlmoz1nD9
 wV2qioOTSH+xP6BXr94EMmDwL3e1/kym7tSFGMy+fARt8p/3mpXWDWn2gCL50EIEL/koVscQqzt
 mWlJ27jbw8SV/mxkl4hSvFvY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce96ad1491dcf66a;
	Thu, 15 Oct 2026 02:23:50 +0000
X-Mizu-Trace-ID: ce96ad1491dcf66a
X-Migadu-Flow: FLOW_OUT
Message-ID: <f6ad4302-3540-458b-aa94-1b306ba23d65@linux.dev>
Date: Thu, 15 Oct 2026 10:23:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] tools/mm: show_page_info.py enhancements and fixes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ye Liu <liuye@kylinos.cn>
References: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
 <20261014170519.d07e3a5f791e16a5cb9f51b2@linux-foundation.org>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20261014170519.d07e3a5f791e16a5cb9f51b2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D258940003
X-Stat-Signature: 1wnrqs7zd6c5jdw5aznhae35cerkaeq1
X-HE-Tag: 1792031031-557903
X-HE-Meta: U2FsdGVkX18Cj81UOAdLZzCHRsPJ9cYNo/jwBjpXBAJ7ywqpadET4RYViQHLv9LtjYufJBRujeVBdJZUCWsVMhXe0L8Ih4UWwO7Fr9iw4s42GuD9sz3WcUvXsEQPnxPA6FOlWAIrtEA6sTEcRW4Zxffw5upek2Ywe03R/F4KEKUqcCzEI3cO4RPIhQ4tC2CL8AxQ+KNA5u3C0vulMlvQLSid4WZFlaZcO3w9kgiUCS0v8tYxShk0rEFK5/7oL9aw72fjaqJ2XWO6C8hwnUqDa0GO0C8l9g5hhOSxUem7vLj35Go/gv9gaoicYThJINehvb8Vz4AXglK0lzOUmJ0WEUvMYch/7xyGMAqSZiXmyBarNH8V4ziiIJpw5ZI/H7UCujBbGvD+2Dq+LN2RrAgxQMlMxvuMYxvRrJZ+7wIQAT8y3ht5puLI/xm8AX63wUd+EC/Xc2pCVmXRT1hrRA7qLPY5zAnkTKUo1Gsakt4Yvd6/y+H0Z4QTYK6d5BH1rQd/T1QkMJsRTFft2bp/sC3VIPQwRCJfvwGSxNI8QP6NdXbIpmokTj1SShzr6QFyr90pT2Gfdpsj23yE3LN6Zs7VqYctAR1lBgIN7nitV8FUkFpnEXryjZ2bwHAHjV6Q+dy822suT6T1Nwmls0mls2ve+EN+jrVHcxWb6PVSJ5cD9ctE/OhMA6bCLzJPVT27C1p7lqrykbCaku7s8puz6BUaQW7bIiBNC1Uz1eFv7b56D4h8EfPi7k3qbrXtbaID9BwFYAOsiKKVwbRDe3UqbavgsSaKzMYdc9IzYC00LrDUJsHJy0K8GLE510F1VgUdIhqNCIPpKLAEasEPnro0XtIqmDxC01UtBMtfJveP/UhEI1LXmyqSFH8P6RY33b5Sb4uzTdKkvG1JXGpEqAvEQ2tuUI4gOgLyHqp1+vlcxu6JjwCAzh06fUDQgXlnIaf+MR9OEXfskpgHcITSZySnYoL
 PCzRNoLd
 BmkUWqDFVePLqgGh8pdFz/RvNeHqml9XCjAvtDK8yp4BQG0NvfDb1BkwFKAFkSwuFwvxNzXtiRwIkzXnQuRYXlCdNMASVpAnPrjLkf82jlOaTkuybcv+gNe2fdF12RAAFpKAqBpLiFYNh5f8WjFdXoDxMBf83oCa9BDyqiniIsKHI926vrwd4WEH43/CgbXzFkOcS9CGwptK1ZHAcaBldfgKZesqRs29ckGcty2lW84U5UJs9kKcsgucOUGtg/01vqVUOeYU35+ocfQStGeZ3SETAoYXxBu/eyHO4MN0hmNXgBwBZ+B8TRQNQNZ4e8ADXe7/UrcqGJq7iREjNGP3MpWkLyn2ZayMUx/v/4Dd48XrZYMpid17Am+yffBsR4rqFwPK39xSjXROTwUfVppq7MG2JiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/10/15 08:05, Andrew Morton 写道:
> On Wed, 14 Oct 2026 15:04:27 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>>
>> This series improves the show_page_info.py drgn script with bug fixes
>> and new features:
>>
>> Patch 1 fixes memory cgroup information retrieval by updating the
>> obj_cgroup type casting and handling slabobj_ext field name changes
>> for compatibility with newer kernel versions.
>>
>> Patch 2 removes the incorrect Page Index field display, as pages
>> don't have indexes - only folios do.
>>
>> Patch 3 adds VMA flags decoding and VMA name display to provide
>> more detailed information about the virtual memory area containing
>> the page.
>>
>> These changes ensure the script works correctly with current kernel
>> memory management structures and provides more comprehensive page
>> state information.
> 
> Thanks for continuing to maintain this.
> 
> I'm curious.  Does this work mean that you're using this tool in
> real-world situations?
> 
Hi Andrew,

Yes. We've been using this tool to investigate real issues on our
production systems at Kylinsoft.

One concrete case: we hit list_del corruption warnings in
isolate_lru_pages() during memory reclaim (shrink_inactive_list /
shrink_active_list path). The system stayed running, but the LRU
list was clearly corrupted for some pages. We needed to inspect the
affected pages' state.

I also use it during kernel development as a general-purpose page
state inspector. There's an rmap analysis feature I haven't posted
yet — it currently only works on our internal kernel version. I also
plan to add a mode that accepts a page address directly rather than
requiring a PID + virtual address, which would be useful for analyzing
pages found in dmesg crash traces.

> 
> Sashiko had quite a lot to say.
> 
> 	https://sashiko.dev/#/patchset/20261014-show_page_info-v1-0-7a68aee0114a@linux.dev
I'll address Sashiko's comments in a v2.

-- 
Thanks,
Ye Liu


