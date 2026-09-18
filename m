Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADB8C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5CC6B008A; Fri, 18 Sep 2026 04:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E486B008C; Fri, 18 Sep 2026 04:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C476B0095; Fri, 18 Sep 2026 04:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC5D26B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:34:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 528AB4061E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:34:29 +0000 (UTC)
X-FDA: 85226221458.08.E0C3EBA
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6AD48180003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:34:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uRXQDTWy;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789720467;
	b=lBmmzRluYQgYnnoQO0/4jDqopF1pp0XFaWKrrf6caH60i7HwyofcOc2iSG3+EMZU4wVOd3
	rCeXYAiPNdD77MwiXuVVxEdiJ51CY3YdeKBUQ7G3/RFCXQWmnSo+lv/gCNvCPe7qqcaJy5
	2BzGuHO5q/xfjUsYevvgA4Is5BpyCvI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uRXQDTWy;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789720467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWLXM9j2Xl4HSK1CsuZG/egpI0kp+xihUtRUm8SGEIE=;
	b=yVl1tHAFXvwNRhYjs5s+eZCuCzUj72b2njqkIOtZ9XfO6KVvsJtvBGVHHP3KXnsB3cpYB/
	70s+MiGIm3pOyH6jsYcKsvPJwq80ZDMjCJ00vac0uw/wIGlh6mccZA19ckNa6zj1Krb2fS
	DFfQ4PXNwqIM1xpWHZWIQl4V3cUe6cY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789720463; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WWLXM9j2Xl4HSK1CsuZG/egpI0kp+xihUtRUm8SGEIE=;
	b=uRXQDTWyZ3hGeAydYuWbycpjtTuhpIfliLCndz5nqHNCkBRN6hTZBkcdxjmgF3qclbZs6olycAcOa7nd1cfXIboAp1l7wa/V0guC841GBHU5ZE3BKdz/XPqdgXNAxW76pQyZbReMhwxnln2kIF8OtbTfs+dLhzh0DDVhR9MthuE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XBAfAEz_1789720461;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBAfAEz_1789720461 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 16:34:22 +0800
Message-ID: <a93d4942-8e21-4205-9f5a-395b8038ee4f@linux.alibaba.com>
Date: Fri, 18 Sep 2026 16:34:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit detection
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org
Cc: ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260917054015.23553-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260917054015.23553-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AD48180003
X-Rspam-User: 
X-Stat-Signature: oq747ny6ghhcg9bowksod3zcnd54zz6h
X-HE-Tag: 1789720465-817167
X-HE-Meta: U2FsdGVkX19IWQyvuhc/J9A+4/ytSS33t3DKXDlupoF5fhygOOeN/VeJHhe76YfbUwWQrgmvtYAhdRGARvodJvn6NL/Xg4afekesvXp9rDr+PVMdpbl/T6zWPhiRwThLixDkAlT8bx2bKmA6+DAqbmeBt5gBXILGG5uQ11Bv9PC9Kl5MsVAPT0E89XZZ0YSJ1WPXW8ap2Jb36pA4cy5sVdpBUeOxx/vXBE06tQHmbG5KwKbeNJ4czbojSzil/LWaaWouTiC5hnN4LKG5VzT9KawUGW+uQ4bJGyNu+7upTAZEXT5F+L71Cmnn1KmvtDXTZjUYKJWiKNRtJkKRj2plR/+Zs45fE76HxxLU8+vl0U3MLCCyCnq6hFW+Ykc1qmZr1qMRNDP2jZrA+S7aLkjuUKEH16GFi9fOaypnU7Hq4S2rWTSfRBMLqbFhEBtn03gZ/q7ACoxlwuaaKY6xGNfSN1nx4ti4VVj0n2Bjpgx93HRMWMIFfk97hyDYwLZNkIs7GAo6zLvxNSdhHQe3U4xzEf11eXpQ2XIl4z1N7Y5DvEExjkU9Ngu0jbMmt7VbPAwFkZrz2EocPz6O2tWOnxgrVqFtCmex/2Ie/Ef//s2P4TkyxL8HAyWrFqLV+caWwSc1qbPv+JrLM31I9XOXg6/7HddzD27tne+iOsuLmnJPdHCwd34faZFGPYWwk8qF/Nj28i6JG1xtsGl07mMu8XNNxKeQMKtnFrJkDl1tTGSFfmGJukAlxpP/QGr+ih4oSmzShhTpVQtwdidSuz3g5Q7/gTOldhsJqgvihT2vvHx/c7MIOmtJ1g/l8JiDpyDJP5Ix8uAjgd6UlEqUHm8a1dO3k3C6IeDBftU0KxBFGsAmoaq2imH5gIHOT3AAJU8sZUqjpoJBq1JGA0RQx4n1PPzgq7If5WKOMnEypoXzD0VMVej+UxelgzbKhE/u45/fhq2PvctTCAZauv1J6SEcTdW
 Zp6Wqq9t
 EkH54jivAe9+MehpWFsNMfRqJno+zqxXwlM2aPablHxymcASeA595YfWR6OtvjWruBy4oxdWlnuCLvIxJuHkLEojfsd+oBSbIbU7zwgv3aNPm2hkEdw3rZ6zL3wiN0OY59nrsWj2fOPWmxgT+1L1tm0Z3X6SXaKT1MDQNINwggsC1oHMnxzc706wgoC5msgT2bDNoXP+DesBYK7bfP8hUle+x23gEhrUnFrx8pnVU56gPGCdFaDq5xHJjz1LyvNR1UWDiHQcYm5S7u46bF/Bv1ZYSEvwIMiBHc967wwgPMA2PW4BrMD8AVUOin99GDGhNb7m2dvfpqXVKci7BrPBlkqgv2iWr0D3m0Ko8Vi9yldfDldpxJlfjPuYtlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/26 1:40 PM, Lance Yang wrote:
> Whether a PMD has a deposited PTE page table only depends on whether the
> architecture requires deposits or the VMA is anonymous.
> 
> Implement this rule directly in vma_has_deposited_pgtable(), avoiding
> mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
> to withdraw a page table that was never deposited.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

