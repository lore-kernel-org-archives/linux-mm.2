Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B248DC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544846B0098; Sat, 18 Jul 2026 05:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C536B0099; Sat, 18 Jul 2026 05:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BAE6B009D; Sat, 18 Jul 2026 05:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19FE36B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:35:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A22540339
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:35:20 +0000 (UTC)
X-FDA: 85001389200.02.5730864
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id E1891140008
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:35:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qq7iSJfW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784367318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loAjxjtaw3yEGqZqUekqy0OrttrEXSBviGMwLrtQasc=;
	b=nIlyi4L0WctI8P4lU1KWw88QTdsNZmWpBZivm3pL0ie6ccStocMT9FLDdoObLem+rHuO0S
	q8s1JxBCYi+JHOYreCasW6r9A/BMyIxj0G+RQqlyFK8/bP819LFYGimn4BFXiv0Watu6RD
	DWMCNJPvEdmiLX3ZL6aed8qc2oyLtVw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qq7iSJfW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784367318;
	b=PS9iR8Z7R69D1W/9UNkIYZibmk0nXuc2elYX0UPz4EVXRrHuXXJ+As6vFiGplj5yqlxnpA
	uURkGopCToAVCRLLU+WFpbj5sstSW1HG4cEjcNYEfYisVAZLB0pMIiLqwhKhawuvOP25Tm
	k1AGQgkyyMj04kDVjkQTks7KY7SMowE=
Message-ID: <68b3f507-ab35-4510-b3d7-0e4ff880bca7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784367315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=loAjxjtaw3yEGqZqUekqy0OrttrEXSBviGMwLrtQasc=;
	b=Qq7iSJfWqxcHDcLpE/utZ62IzQJ9fCVicfXNUVZeICKwe/Gmvq7SgqEGXp8KEO6MUxn29N
	qfs418FBLTvDH4cBp/WrIbQCrvE7iQ3GI2iwBNzzuOp76G2iE0Pc/PUcI0WzHHH/p3FUTS
	ghRJIRx+tAm1DMUUsgFcQiOer7QHSlA=
Date: Sat, 18 Jul 2026 17:34:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] mm/vmscan: fix swappiness=max and clean up per-node
 proactive reclaim
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zhongkun He
 <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>,
 Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260717113300.214717-1-ridong.chen@linux.dev>
 <20260717125327.cd3e3cc4e6cc28b0855e6502@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260717125327.cd3e3cc4e6cc28b0855e6502@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1891140008
X-Stat-Signature: imjd1d6s1awctggps4ia9wqm3ejoroyu
X-HE-Tag: 1784367316-480967
X-HE-Meta: U2FsdGVkX1/hQxPohCgXhzjK9iVWB315HaLbRAKTPSAUOAVx1sGQpAvLPYhqa2G+nLu86u2MdOZt578GGLwXQAyj9CPcS3Jpe+72LyhJUc0kigcJ1T2S2BGfzxeXQDAV0HKOQ/svUyTEqrm7Q67JW1sfKhF4pNsUizo3K44+KcSgFjW9QAH1ixnmWmZLQ4qddiYvIu+kQncgwjHUKrNOGDuhnwOobxg0ULML8P7NtaDpn3WnIiB+IOnZ4bCPZaDQW19aDCIIuSDASo8X5U26QnegHZgQbj95dRr2llG7EfiGtOOECg/yp9A9UqNZa0DPAfLWWMuAqdIYEtalTTechAeUQa6h+xWlvQssuMGDgW000KiHAncLBSF3KIjCoIkRm0UYzUTdsIwh15Y3fLveyif3rxTv6oNt6zaZ82gb1ZGthcepDNYwfZOlm924xOPhAY1u4JGqToHrOKnluGH80EXok3JpWyj47+zZ2L1Pdy2PxXX0EGZ4Los2wONGRCogOLYFNOVKY3PD3q+A11bqJVuabV6mNEuDwL/sJYYIzAU1d3QU0mSgEDOkwmyQS4QxJ0WIf8DUW3GAQglGKhO1UOUT1qlBiUf83xzlb0XPO1ngGBq/jyP62j76J4IFo18oN9VIhi4IwMuh4B8fsONEBS9+AXUcCotrPZ22Vsjwkj4aMngmMPoWXW1ZbkfqsTRIJqxRTlsLDCpsRUiZrUkjmkzIEErlaK9/l+tsTsIkq9/Omf+AWx98SqX11XGl50FEszvcmuRZZ0GSkWUZ0v5N7LyYzZLETOLJk0YVRuw33ot8UbgdcYrQw/EEXlT4lyv6iRkck5iMY+JNRf+jCk35/CyoRXEgjYCck3SAIhDeI/hCjUsC4WJiJjVXZMaImCH2RK/VY68ssH1EnjTxITXzdiAJxjaqRm8g1QZXuciAGF/CwwN9iT8C48Zz8nH582APDZ0NA/5Z39L8rLjjDAt
 P6fRClrd
 NXIfj/eIZW3j+3m4wGU1h1EJ5MI0Oyuo3UMonfvul7I5IMLRzcH/URAce9QbHwDIWk7zzUCcPCOK6XIQIhkosgimtzkdTVVe0D3Oi7HjMIIGJDXMVeJtF/tdtym2rUXKLL1Rz8n0sjqOFUDq5Lo134qBd0HLnYu30SC+ekjb3RJJNZaicSDSMuPYgTC+Vx40Ds/p/RSpgGvLfI9D3tgGDtJmuju5oeV/wdjnGrn+o6cRVCw5W3E76foJAa5XKGlpr9xYexrgKdYfSnbmaQvq2lgukdkagaJXS4euiQ4aVIFIyocY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/18/2026 3:53 AM, Andrew Morton wrote:
> On Fri, 17 Jul 2026 19:32:57 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Two fixes and one cleanup.
>>
>> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
>> sat after the "cannot reclaim anon" check, so when no anon was
>> reclaimable the request fell back to SCAN_FILE and evicted page cache
>> instead.
>>
>> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
>> callers can no longer tell an invalid argument from a busy interface;
>> propagate the real error code, matching the memcg path.
>>
>> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
> 
> Thanks.  Sashiko want to know whether MGLRU should also be fixed:
> 	https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev
> 

Yes, it should be fixed. I will add a patch to fix it.

-- 
Best regards,
Ridong


