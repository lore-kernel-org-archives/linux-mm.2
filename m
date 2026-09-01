Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E671C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5529B6B008A; Mon, 31 Aug 2026 22:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC5C6B008C; Mon, 31 Aug 2026 22:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D076B0092; Mon, 31 Aug 2026 22:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE2F6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:06:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8089A1A030A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:06:06 +0000 (UTC)
X-FDA: 85163553132.10.111E92E
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5831540005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:06:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iz7B612J;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788228364;
	b=5URSDun3LJ8I+jZ57+6U9cKB5tsSLAjGsrLuUFNLq/1Mc6aEs7Uix29exK+VBMATaf/ABb
	rJXFZ1f8aqKkEccCY2NY1a4WOoackTLnoWu2B09orsKYtTylsZSZoucY2Oporp9FCokZn1
	YRTDCsaCUQ5YWIIX54K1WkfDao+eQIk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iz7B612J;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788228364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ky50rSgY5tzco+q1f2XF8OoC/+HTORaE9naTNqUCG6g=;
	b=WQc4w1HPH+Tv49v0ygJYRo8U+SgY/GLYpRA5Q0n6SGP0/QbkqlEA/yU5jBKKga6GBTto+/
	ZPhH5Ghwy/Ky7VDMnEw1IEQHNrPLf8HEhKaPgri74WhGNLB58GOPuC91v462UL9kNl5dBD
	izeEQ55co9fPgWEgbWdTj+zztDx3p1M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788228359; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ky50rSgY5tzco+q1f2XF8OoC/+HTORaE9naTNqUCG6g=;
	b=iz7B612JhbR5yFrTsyLKOGwQNY6F858DkilwT4IvgVAfKhOuPky2/MMOJaDEPKbnYr9ng0TqzCGHJeVWDGpB6KDmJ7pMWV+cLxiIYboLB/H7+w41Dze01UpqaM7uomubC3y8zQKGN+w8IonSKje4zMJShOAKMx8e3ui4AkdNmbA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XA0imgg_1788228356;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XA0imgg_1788228356 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 10:05:58 +0800
Message-ID: <07013ca0-a7bf-40ac-837d-e60e6b6b82d2@linux.alibaba.com>
Date: Tue, 1 Sep 2026 10:05:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5831540005
X-Stat-Signature: dq6dpubiycepca4qd9hepj78e41qcto5
X-Rspam-User: 
X-HE-Tag: 1788228362-103933
X-HE-Meta: U2FsdGVkX1+sts1SuzDZjrgK1k1pA2amY0omSiYzh3DPLRzAxnoZ9w5+nn4wCLR3sztp46etVcemajrXQLzzsGJttceHP+meWY4fN9QQ3PnCrkIRjz3lf3dD61HS2kFstV9QYCP98TxoM8aHo/kPCBR9BKuY/UI69wGnUo6JTno14JG1ZAmFpO3aYELYA5V1DpG/fNGpkRcZ63zTbf54i5M6ERAZlBoFRbMZqSMS2HhCbThRhI77/WI0o2rPeaxvsqOBNudQQuDgbWZNXSrs6VrlWgzhu8uKvcXF+1Er0ydsDwwplPbrF9/+0G240heUaG2cAY9uf4CsV6NUWxt3oXn3rz41eKO5nH1DVS7EoKiyIuf1b+gHwxo0HHF0pEYC1CspTqW3Laqi1qM9mW3iMLNINF1uWSqzAj3RUijyfmjK9EcHjRQAlY0I6NTTCisFZNxdB9MbKONmpcR68Jq8VV24jN7Lht5mTkHM25xsnB+vQmEB8MOld6HfZxvBYLQFW9/hjKylGGaYwPe9/XURHmrl9NT0UW3GMZXt0Gv2qTfnLdd5Wg5KSF6ruvcqnp/4Vd+Uv1ea4FUDCAQD6bj3v+ngm/AbU5fB5RUI9KeU/PqWu4iRMfw+bseHj4MRxsl/X7RWPHondDh8Cy7E2NDWsYv6+29VdYn9vs6gqRSYCr37fk0ihx8wTI+Tlph00dlQDsnjLIYcxBiPLhJd9RSE0WC5UAwgCqhEewY5K4kDVBaMEiCJsnDXu7MitRT4yBrL5hnFiPzWgh718ExrZTHEhBlAUQQKgseeJPw/wwkn7a3E7ASeM3aZlYaHe0kvDjugfqzcn0/YdjCM+k055/UiEV6CfTrQhi/s8xTRfDyom0OgZMp+O4ewBbeyT8W757m5Z2xyJsWZrjKI2Ubzl1Ctwf1gftVg+yWOmPs1Yh2aNZBFtM5WV33ACaouKLw71o00h6Ylsu4tvipN2OTowMJ
 azb1tbiG
 x6gE+3gRRdxS5um0WUBts7aQJ2XG/xRdIv1X8vZiaoxf3Gh+as4Ie5ZEiuGi6LW9MeCew55wVm5GNzeC5Eet1GPDpB09s0V6UMIrf9bNT0sCyupwD+2tgQoXVCjrS/YxPYxchBF4JMvo2FUOPqBesmcKgtiUVSBh9QUmoejmJ5r9p2be6Ozh3GnOyRcIK4cjxejFlWOU4Q3/ObPw+Yw0lhqMqBczkamgsK6wa04hWd4FXfHpMl85sERTcVP8vpvKwhRHbhMO7NdOqbkoRpPaLfL0StGhZblKUOcOYbvkWn3wozKOIsK9mIbQZU91BV6S+cEv6cYy9/fYLSFbLIn80tG656eco9ZNhFDorvC7aIMX5yw1ooFymvGVnaZOXPdHu+o9LeYV5+ASXkY4beuBEhnzw/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 2:43 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
> 
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

