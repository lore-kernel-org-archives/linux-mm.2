Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3EACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 03:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98A56B0088; Mon, 28 Sep 2026 23:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49876B008A; Mon, 28 Sep 2026 23:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38756B008C; Mon, 28 Sep 2026 23:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABC3F6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:41:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AF621C233C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:41:45 +0000 (UTC)
X-FDA: 85265400570.06.4410A6A
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf01.hostedemail.com (Postfix) with ESMTP id A986A40006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:41:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ENv40EbY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790653303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8A8WLBQwsgMXTvSGKLNLqfx2C8YkEg5dty3zK3RESs=;
	b=vWIG0rJNzJyREw8ciDbILIlE8SpnS4MA8kEu4BLUl1FiKQZYWv9tD71AGpKpCXDRxr/a4C
	I/MT7XnhhnEVYUtbh3HXWEKH2I1ltxkkbU3BToyonCG8jfJrNZTfgmFcpgv2Tr9p8K5+Ql
	kR2EFccDsxlwdbsVWt0c3yvNOAYiS/E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ENv40EbY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790653303;
	b=Q0B4wAp77BzSR3gEqBRUc3CU6QbptksmrdtRN3jtiQQOIvgUozc7HYBw67SZexNDLkGy4P
	CEt0InK/5pXpxTUCuH/iJZQjp/CyATORAxieMvYB2mhfofVmTkHL44XY8wQBTNUk/BT1VW
	bAmw/Pfwzo6rLnvY+j1G0qYqH9/9CDY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790653298; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=T8A8WLBQwsgMXTvSGKLNLqfx2C8YkEg5dty3zK3RESs=;
	b=ENv40EbYv/p42beCLcj57CV6YjluZolPPNg/TITocQVsO3gc57gafaSbupNlsZ154Cf2lioknlcP35nOiybQGFAqA06iJ++860zL91931Ld/CJff5pZ5/cg+2E44M5NAGF94TSEn75sH4w0/Un0EfsF4z9Obdjf2xaxTPeCU+X4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XBrlRM3_1790653283;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XBrlRM3_1790653283 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Sep 2026 11:41:37 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: david@kernel.org,
	akpm@linux-foundation.org
Cc: xiangzao@linux.alibaba.com,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	kaitao.cheng@linux.dev,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned pages
Date: Tue, 29 Sep 2026 11:41:23 +0800
Message-ID: <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com> <20260928105805.1215770-2-xiangzao@linux.alibaba.com> <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: coipzdzkfj5d93g16whokmyxc7zpdm13
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A986A40006
X-HE-Tag: 1790653301-996656
X-HE-Meta: U2FsdGVkX18QBLNjIas3iopJAFZTbX/PD3rwPz45TaoBAMkYgDICU4156wGabHYU6jpe3u1tJp4U0rWU6DxaSdvXEf4yCuR9H8a8wRLtFipoJxntpk2Pyhia1NMdJHA+KGllEaSZKFBB2goFILvEa0vytRlPwyLo+Vz4BPt4Vpe1nPXYX/clcHAbb80Tmm+eU9bmc3xBZd8wy8xQunvpJQ7JStL40brUxLeR7Coweha3opj3Z22yuCOJs+lcErj9BeUv3N+0SGloB82AzltajXYH885nBQSNpyxYQsXEOoZCY1jM4eukPfszPpPvUqaSJjknvkUhQISeU0sDqdC4HExrzCMEPT76D7VAXS4PqswfOs3rE0RHiGgVmWHN9+iTa0JolSVunrIzAnHjsBorVOl5nSwZlJIkLni0naCT014d/n17gryoQRooaoS6lgb76c07nMiS5udWvVIRz3q5rGBA9T2/p//RcAG1wpnzzXDcMVIHDpVE67YRCh1sMjlOKBBy+PHSFE2/9zewhLEavYBrImLPkPnQpbGLhXF6Ndr78+cKV9mIKFdHq1BgEtdqzVYiDe9NNffoP+cLQFT9lF5Por3R6c6lXYbbTT0HTM/nsSpBe0LnzqBLPOn+hRWjrUjY4B91BSgyB3fo/k4owy6nV2dhEkzbaVqzT/p8+sLMHUEZoQcOvMKe31zMB1dBc0Y98OaSlTqI0VakExwTxBmWB8tEdUKA0NBZIMU8dyJNE5jfb1TsfmO5x9TdaYois80rJ6IHOSTduKo0isDQMyQR7h1Ov6CmDlNjaQUNMxN5GNsC46nSm8IdeLIQkgQwa9Zdx6GmaPsf6C20DfA8ndjCj47AnpsuOccORloZQfsHMfmI5ilfWgBiGXcu+ryI6L4fZib6L/2YN2MsBbX48qmo1ZKMQQ1mNnVWItL89UY1AVSBcZrGlWs8onCmRR3qDszjZvdD9CVU8lZxtqy
 bCkMAasV
 22qtkp3iu13a1MeSWTmHLZyydP/1XLCWrpJbVS3mMOY4/1ig/SHMb3FJnRPDzt+ClnfruizZqD244e5sq6UiIz4BywDTie/a54GwVjJ61nX+3JoXQvWug84nD8EIFaAxoR2YQBXowSpWVcEQEFUfqbDHLtgjoYoEoquI+bR633VpWDTNA3G8qk9dA/JfRg8wwS1hUQwMZ4CscXMlCcZ7riGCVcl564594++Br/c/2hvA8EMrghRNrtsjddQr07TzT4ue8XI5Hmvubq4i3BizI7UepPZ5fKeEZKBObblNpx5JKEedIgQoQx7ws/cHw47I0D28RL9I0XeF/YIfjHpSjxjPhjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 20:12, David Hildenbrand wrote:
> On 9/28/26 12:58, Yuanhe Shu wrote:
>> folio_mc_copy() does not close this hole: it only detects corruption
>> at copy time and only where ARCH_HAS_COPY_MC is implemented (x86_64
>> and PPC64; elsewhere copy_mc_highpage() degrades to a plain copy).
>
> Then they should implement it.

Agreed, and nothing here replaces copy_mc.  Two things the check adds
while that work is pending: on archs without copy_mc the plain copy
does not fail, it consumes the poison - the same poison consumption
commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
THP") refused to risk on the split path, at your suggestion; and the
refusal happens before the copy is attempted at all, while copy_mc
recovers only during the read.  The check and copy_mc compose.

>> Software-injected poison - what MADV_HWPOISON and the hwpoison-inject
>>  interface produce, and what tests and fuzzers exercise - never traps
>>  during the copy on any architecture.
>
> And these are debug interfaces, why do we care?

Because they are how this bug class gets found and reached in
practice: the reclaim-side check this series builds on (1b0449544c64)
exists because of a syzkaller report through these interfaces, and
carries Cc: stable - as does its large-folio follow-up (9f1e8cd0b7c4),
which you Acked.  You were also cc'd when Andrew raised the
urgency on the hugetlb sibling of this fix for the same reason -
"perhaps Bad Guys can find a way of triggering this, so the urgency
becomes higher".

The window itself is not debug-only either: a real UCE landing in it
behaves identically, and on a non-copy_mc arch that copy consumes real
poison instead of failing.

>> An isolation-time check avoids
>>  the migration entirely, on all architectures and for both real and
>>  simulated poison.
>
> It's racy. See the link below.

In isolation, yes - and dealing with that race is what patch 2 is
for, which is why this is a series.  The steady state (split failure
leaves the folio on the LRU with the flag already set) is not a race
at all, and that is what the isolation-time check catches
deterministically: 16/16 such folios migrated unpatched, 0/16 with
it.  For poison racing the batch, the load-bearing check is the one
patch 2 adds, immediately before the copy.  In patch 2's racing
workload, the entry check alone still propagated 693 of 9606 - that
datapoint is exactly why the second check is there.  A GUP-based
path takes its reference before the unmap, and memory_failure()
sets PG_hwpoison before releasing it, so a racing injection is
visible by copy time, unless the injecting thread is delayed
between taking the reference and setting the flag.  A real MCE can
likewise land in the final instructions before the copy; on x86_64
copy_mc catches that one at the read.

That thread is linked from patch 2's changelog precisely because the
concern you raised there is what the pre-copy check tries to answer.
The patch 1 sentence you quoted overstates the isolation check on
its own - I'll scope it to the already-flagged case in a v2.

> Was any of this written by an LLM?

The patches, the reproducer and the measurements are mine.  I used
an LLM mainly for the prose, to keep it accurate and unambiguous,
and also to look up related patches and past discussions on the
mailing lists.  I verified every technical claim against the code
and the test logs.  Fair point on the missing tag - v2 will carry
Assisted-by: LLM.

-- 
Yuanhe

