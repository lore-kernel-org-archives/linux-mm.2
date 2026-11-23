Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B882606A332
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PuGXFBsW
Received: by kanga.kvack.org (Postfix)
	id 0A3D96B05B5; Mon, 23 Nov 2026 05:00:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DA96B05B6; Mon, 23 Nov 2026 05:00:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED36F6B05B7; Mon, 23 Nov 2026 05:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C70C36B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:00:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9BDBA8442
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:00:08 +0000 (UTC)
X-FDA: 85465938096.15.21FA759
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7367840002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:00:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PuGXFBsW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795428007;
	b=stjzsHjL+V84vFWLBCnuVfrDfJU89/3Hqnj9W1poSORcpMAt4kphIq9V1RNrJMi6T56KPe
	ZZkp2LNXCvlIsBBQE24oBKLr3vUNn4BktaPN5Verk57q4pY2MpMX0lpZcDqf0kERFxd2Ai
	lW2/j7hHhU/M8vG9GFFKEqyClzizDOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795428007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39LszgQ+Vutu5fHaIM6am63oa2TAWVo+AWYFNIzHedw=;
	b=iLuUgfeXKL8h1UsQWHd1pi/U9ADWMTWfkDxlNI0jq09/OLO14HauuWB064EK7966QN2geH
	XZSYFmoc3vdo4zrOMLiNKJ3T2ehQHdkG7oKtszd/R0V975KWMzTB0IOujY9SoJH+R0pfXg
	MZBFTmpXg0AyoP513wZAeJ+97JOEtmo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PuGXFBsW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795427999; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=39LszgQ+Vutu5fHaIM6am63oa2TAWVo+AWYFNIzHedw=;
	b=PuGXFBsW6fHwUVGc4moYEZaLaLwSNpwqEMM189oO7AEaybaG04i32ACpji+DAYtyZphnXzrq1+mZEHnD9dYJz5MGUU44uV962biB7/jFwlFRI9XgsgfIrFl9qaxN1evTsszTWPNBFRpoj6ZlLNqV6VjTjBqEd0s+Cin9Ob4lqjY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XFHJ3WU_1795427995;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFHJ3WU_1795427995 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 17:59:57 +0800
Message-ID: <92bc11db-ef40-48e3-8768-9af36bfb5a7e@linux.alibaba.com>
Date: Mon, 23 Nov 2026 17:59:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-4-max.kellermann@ionos.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261116081403.216452-4-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7367840002
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bob18yf5e5um8moc3ah8e65mhg17jh63
X-HE-Tag: 1795428004-229051
X-HE-Meta: U2FsdGVkX19wRP2+cLej6BHgqUvZ+B4Ve/spujJ6M+rugS+uLg4vxWxlCYs5CTfUuLZi0D8NyhKRcPN8I38ovIhnIRIgqHzOrfk4ZCjuLqTlwKb+wSaL6SuVSSwrAt5eEbSdJjvsy0h7ZBIfjNp84OTBScJYPa//FpFHSALH2UIGa0qUmsh1CcCVRCzYhQNVBinOC8Cn3B4JqNnSSrIlH/SSgWBSMv4FrBMWfSkCSBkoo5w4qR1okCg8OLI58jN3pLOMmKOI4wNyNiFajNijIgnW0qG6c9DBYRsGk6tOIbJ35TT6XZsmi8LmGsvV0ydWipr4C2KMOv4WDjumh3PQ33kWlHyn9V8DhQ+puC21v60IUFAeVCy/N4Pag/EBIzcPR8DLa0GrvxN8seOpwqyIRntHmYb80KseXKqVNE5fW3TjjuO+88IQrA3i0vBPAxBgJGsirRLLPlR99zZUhVbxpa+blwgjprp3nG2lVIDT5nHo8zPyZPP3fHCiMjw9/14ADhMJNdVJ6iv9TD2ex+5l6T7K/VZ4PPzJ8Jn0gnllyCsUcibCiIWniGPT1YTkrQhPxIFTi8+gJsH3ok5BGpGNhMn2/v5jEDRSTnCcl/uJTufXlQfQg9x/ZM1GhCI8uP5g745hfZ08NosfLxSITtBPQQkIREKApdRmRA6flfffzGbNXKkG8bZEtJ52PIiVCbb+oY2liMit65gapl9e+W5bT9X+cOQHpx/utC7hK7NmsiDTFw/+feEPC17YrLmHEiOheCo9Q0GUHd4NrBTzBbDFXpDx9C1hN6Ft8uRG4Vvtu1cV3Rs3bzCcJY8OXLgBbVdaVAsvdDpSXJCxB8NQKCg8v/HqVm/igb1AloUqmMZEPdb0trT4NxLoBydLO9+Q4WLJy0tNC6PgstIkzcTyAZEnEMIz7bWcCLld08ydOObAZNuagmGm43/WTjotsYSmTVzWl3c0/qtmIzOywJQSlYF
 lCtbWSlI
 8bym0V8+g7Trd5o9PnMzXCC5i5gSqB0JQtQ0S1HdHrES6M9CFZfYz7epllrjROk1nyMSZDeC5rrnHtLkbH42NSTa/MCVGqO+1xpIVB7cuDY2/qAmOsiJrG4I7bh5TL8U9sxRcZUAuCScMXEUWGSiOo5yUHgtu6q4zmZlVVuR1fguG6tkceDB4fpa+7gXRcBH3ZAXUYoIX0XL5b4YqdWKCItcdFtXPk39iZq4RHhsWOg/odawTUEed03vqTDK6leUmLSxqx5kcRadunZens12gRRlHn8Y2cZGX55a7Xs6+cAf848cn/E+digIDXqGT9iVaEZAcZ5W6t5/jfGzSIcs54CI+z+rDxoUIO6qjQ2Ru2SU1fRQYAyMm90usWu0kGka+MkKTinwxn/47F+INYfEvR+XlTd+y6iiUZb5lJvtVliHxAGqby8bM1W2cPRf8c1sOIiALhW5dEMev86Fcq0jPKeI7LnrmTr+sgAhjMe0lZRJzyLBRkpZNZ+Tnf1VgapOA2HKb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 4:14 PM, Max Kellermann wrote:
> Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
> which walks the destination bin to find its tail while holding
> `memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
> this takes a long time and causes severe lock contention.
> 
> Cache a pointer to each bin's last node, making tail insertion O(1).
> This requires remembering the bin number (but the new struct field
> occupies a hole, so it does not grow).
> 
> In a micro benchmark that creates 1500 cgroups and repeatedly writes
> `1024M swappiness=0` to `memory.reclaim` in 8 threads, the request
> rate increases by a factor of 9.5 and the average duration of each
> write request is reduced by 89%.
> 
> All writes return EAGAIN in both runs; the benchmark measures the cost
> of reclaim attempts that cannot meet their requested target, not
> reclaimed throughput.
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")

I don't think this fixes anything, right?

> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---

Thanks. We hit the same issue in our stress tests and confirmed that 
this optimization works.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

