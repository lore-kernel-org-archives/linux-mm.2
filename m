Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ADD9CEACF9
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 00:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A838E001F; Fri, 14 Nov 2025 19:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E23E8E0005; Fri, 14 Nov 2025 19:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F618E001F; Fri, 14 Nov 2025 19:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F90F8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:49:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26D121A05AD
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:49:22 +0000 (UTC)
X-FDA: 84111007764.18.6A4E5A4
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id 71E6CA0004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:49:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="HFxIY/R6";
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763167760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htUByUHiQNU0PaaZJdOzX/xk7D/ge5gLRVLcI608Ows=;
	b=YcuzovtfvQOAFiH0TgZxSJhprx7tHh3W5wUZkus/CmQVEJdti9uIAHPuy1JuZulPwSmUlJ
	ubv5RzpNvmAJpWJ73oCd0lPTEA2+2TT5AFnXpgwL7lZtTr5deeqq0sDsB2BObSjYNo0iDI
	fQLrLPL3nnizeDu/vNhOxLice50I7Y0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="HFxIY/R6";
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763167760; a=rsa-sha256;
	cv=none;
	b=PtE87lyFPd56JELU3IeuVl5RWvTr1qCKoWsG0jxKWfPYweJm/s4T6j8qs2y50i3ferCqM4
	ZZECchY2/MLLN07uzg3nk7Ga5Yr51d3CXfbxrmafSlMFZj/ELamG0MPkrbzQUYQQB+ylst
	jIs65/QHl0jq5sQOog7xosepIB3y15Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763167756; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=htUByUHiQNU0PaaZJdOzX/xk7D/ge5gLRVLcI608Ows=;
	b=HFxIY/R6zaU+tEdfztmjxPmjAs/NjtHZmfF8J0i65XeYXWJ6J38OJKOxmyadiZtX/Zjvm3/pDcXrMy853WPt3cQtnrkMIOWF4TODHZu3cJb150x1RaNrxknDOxQvMdB9aL1azHz2C6dp+l811GvhIX7xmaC9/1OBUV9zc8L/u5c=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsOJfMa_1763167753 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 15 Nov 2025 08:49:14 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>,  Will Deacon <will@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,  Barry Song <baohua@kernel.org>,
  Zi Yan <ziy@nvidia.com>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
  Vlastimil Babka <vbabka@suse.cz>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Yang Shi <yang@os.amperecomputing.com>,
  "Christoph Lameter (Ampere)" <cl@gentwo.org>,  Dev Jain
 <dev.jain@arm.com>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Kefeng Wang <wangkefeng.wang@huawei.com>,  Kevin Brodsky
 <kevin.brodsky@arm.com>,  Yin Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v6 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <2bb9f0c2-a258-4a57-882e-9629f9cc81e6@kernel.org> (David
	Hildenbrand's message of "Fri, 14 Nov 2025 10:49:45 +0100")
References: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
	<20251114085403.101552-3-ying.huang@linux.alibaba.com>
	<2bb9f0c2-a258-4a57-882e-9629f9cc81e6@kernel.org>
Date: Sat, 15 Nov 2025 08:49:12 +0800
Message-ID: <87pl9kf7cn.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71E6CA0004
X-Stat-Signature: d34rex3p8zqciuaxxm19ctw1esk8zor5
X-Rspam-User: 
X-HE-Tag: 1763167759-399623
X-HE-Meta: U2FsdGVkX1/9MBQRtezWgpVT9xITF3NyK6SmPoKnbr/cYIcTiLWtmGV0nsutn+7qbcVpZ3dCvokhZmJ8KDekKXLUTrtbFpD0Wnsb6m+HzYh4EBA9nejTl9m8cqbDgNUwHEgTGDxoIfb76sAhpLicjGF1qYCXZdjGfLt6v2u/W1A4SRr8YQsn9ERmQ6vPohiOpLK0UWHbbEJTAkNlX2x2mImSqqdLyLO9l7wgUvuKOisMA80kqRaif8s+aMyx2WG9FVG6c/901R3HKPXJGuxm1EsgYTNpwbHs41Hyb7dJyUqWUKNGeeQv8zNwON/ml8+JJPyDnSMGDVEvve73tVd49VdAQYMRYS5oit9kRw+Z+3Q5TNixEMyNPPjsfziRSjknM2js/fNtic7qrzAWWrE2ZqJe6vFCOQQSfVKlZ2Zs1EsijUHMEFFuiMhJvQD3za7WCXrt0YRvO5tNIACQv/iPheZHeAqMUgc/Dt+hPLlrfXKWNGgR2gOLukjGB3cJh16H39vMAEm0sdeRWW6q+IHiAGN2SsfpcbglaT2oPIIlU9/5PAApLuQlOwTMh8vNAbGNZoMIaHWJJoNOvtrVLBkqVTrh+7ZxF3Psplw+CQtsXRUz/RkeletGdSzNA0MLkRwsnM3n+4fSrLiCpE9M+gedPl0BheeNT4jiAscOb7HvCT/wdLqPxw+2VYB9cO4Gs1PqVqBlvRDRnpaL6+GEBqchWiLmkeeSv0XpUqKJjHRhaEUA/bujcwPoIypZEtSGHVIFWbkVJtlaZODQYlH6cUyft7qbqxIt0mC5g3HG6oeIMd8PFexJ8SH6RVso6PGQ6guJ9qnM3mjn7rzFo4d+9ODska8wuhRiO+R33ChIyJSbENm+BuXmDPwnwiVOQaN886J8RBgdqBzK+98rjEaE4oNuGJyycdGWHIgs7j5BwEMgtUh9JEz6b5hdUavIoCLXD6qLxrYETToIlu/vdjwil8z
 kJQmFgGg
 eTuG5kPwkQStIhz0pvAemAufR3/qDxsGfHuG+4jQbm0KO2XAfkETIFEbVI3/md76Fyi9TWiQgyKFclN0sn4jiatY3JbNAzJqhLa01NMt41/spLUhS/+f3Asr8skQeiXLzdvI7JGV6Z/7QiHyxod3QsM9ZboFbTBVbkM8vhMeYIQ4pv1kMh5qo2dCImyqKoorAUpdT1WDyLmJqzeBn4iLXbj8oKus3S6m1HNZVtHw4nZRda/eWeJtYhrKx7wisUh8NHxoaH9sB6nFGxBD2B0eSYsI9OUFq9MH3YFogfuJQ2M0qD1vAf7pk1NrXWaZXn1HBFcfsDm1I6tLkYwIlXx+IQz8EXmOKV52MA+3nkMm0V3BurikOQd0gS1TQTaxLOFjvAxnm//jfbbAbAEYrVq3F1iGf9gtPr022RLxxkHIxjRZMOo2Y2hOF/IjTCCzwuMAqrjRetPqKgVYT8rXZQO9gN7YGgLlaa/7u9SkNw60f2jbZG3vOm+3MDD4W16WSrifU4hn24/9Qyyq/qLTZykQujpvByWS6gPUsnUX3AbdsewJz6C12Bkdg8hrDsJlxJeycZ3STKTIbev7FA1wktzO88ZOb9ev3R1Uw+Z7H1b5FYNTkm+GjhhN8N6Rs/8yDh0Dj4PwK702EOKtYD6uWkiFgSx/U70F7WL3rco2+MdSKem8oYtxcz7SbcC81CjFTIMCqS6IYEYesB0DX+eJtgs/+rZXtwuDxL+62T0RK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Red Hat)" <david@kernel.org> writes:

> On 14.11.25 09:54, Huang Ying wrote:
>> A multi-thread customer workload with large memory footprint uses
>> fork()/exec() to run some external programs every tens seconds.  When
>> running the workload on an arm64 server machine, it's observed that
>> quite some CPU cycles are spent in the TLB flushing functions.  While
>> running the workload on the x86_64 server machine, it's not.  This
>> causes the performance on arm64 to be much worse than that on x86_64.
>> During the workload running, after fork()/exec() write-protects all
>> pages in the parent process, memory writing in the parent process
>> will cause a write protection fault.  Then the page fault handler
>> will make the PTE/PDE writable if the page can be reused, which is
>> almost always true in the workload.  On arm64, to avoid the write
>> protection fault on other CPUs, the page fault handler flushes the TLB
>> globally with TLBI broadcast after changing the PTE/PDE.  However, this
>> isn't always necessary.  Firstly, it's safe to leave some stale
>> read-only TLB entries as long as they will be flushed finally.
>> Secondly, it's quite possible that the original read-only PTE/PDEs
>> aren't cached in remote TLB at all if the memory footprint is large.
>> In fact, on x86_64, the page fault handler doesn't flush the remote
>> TLB in this situation, which benefits the performance a lot.
>> To improve the performance on arm64, make the write protection fault
>> handler flush the TLB locally instead of globally via TLBI broadcast
>> after making the PTE/PDE writable.  If there are stale read-only TLB
>> entries in the remote CPUs, the page fault handler on these CPUs will
>> regard the page fault as spurious and flush the stale TLB entries.
>> To test the patchset, make the usemem.c from
>> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
>> support calling fork()/exec() periodically.  To mimic the behavior of
>> the customer workload, run usemem with 4 threads, access 100GB memory,
>> and call fork()/exec() every 40 seconds.  Test results show that with
>> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
>> flush functions reduces from ~50.5% to ~0.3% in perf profile.
>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Yang Shi <yang@os.amperecomputing.com>
>> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
>> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>
> (no need to resend just for acks/rbs, maintainers can pick that up)

Sure.

> Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thank you David!

Hi, Maintainers,

I have collected some acks/rbs.  What do you think about the patchset?
What do I need to do for the next step?

---
Best Regards,
Huang, Ying

