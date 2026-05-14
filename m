Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73BB1CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53556B0088; Wed, 13 May 2026 22:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03776B008C; Wed, 13 May 2026 22:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41A56B0092; Wed, 13 May 2026 22:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 992626B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:41:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46A67A023F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:41:54 +0000 (UTC)
X-FDA: 84764475348.27.DAEA895
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf08.hostedemail.com (Postfix) with ESMTP id A0688160004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:41:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Du+NkhSS;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778726512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGC7yF9jJ9cR6pPF1OoIK1SpbTUjOBAjyG5g7YwpyDg=;
	b=oOTB3LlNup2rA8Lk9yBsjbcdsjhDWkh4inXoZzuu/S8zDksnK9f+2S2/WB6Gtwhmy6R8Lj
	fsv0jL+Iu1MC/YRGUn3AtBNfAghKaa9a4KXJZg9HTDmsVFIZK30W9fwdfzHRXjPgTuTY8+
	zehBR+5jd/Gik63c9v4kVbmwXXh9G9o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Du+NkhSS;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778726512; a=rsa-sha256;
	cv=none;
	b=BW924UCYFFpr5zqG8VVeJwR6whpHuV+TVCJjUbeNYwnS/c0d0ED2Osv9Hdq+k9VLvLbWBr
	tpD6UzPJZ5UMDslayOQYJfZ+9GxPrF+YEJzRTRJhn1vYDae9heLn0V1Ajkl0yiVge0YwNc
	/eCI+fR643ORPqm2oHq0dR/CGWbAgLY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778726507; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eGC7yF9jJ9cR6pPF1OoIK1SpbTUjOBAjyG5g7YwpyDg=;
	b=Du+NkhSSSI8HdtxPHWlSVfN9D09T/zSfJ3PVj8e6gzBPRVj8eGgu2V6L+M1y+HFdUBQaRrOG0M18KANZD4+qLmwZJP9ZIXWxxxRn+poY8GGwu/wxQcN0yU4IZMQjTDDpywV29G4+l4Una6Yip/WaN4pcz3y4jTNK5Ii5fS5R17Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2vOsEN_1778726505;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2vOsEN_1778726505 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 10:41:46 +0800
Message-ID: <48a7920b-e624-48c7-bee7-b87cf6ecb436@linux.alibaba.com>
Date: Thu, 14 May 2026 10:41:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_show() with helper arrays
To: ranxiaokai627@163.com, hughd@google.com, akpm@linux-foundation.org
Cc: leitao@debian.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
References: <20260513094508.50888-1-ranxiaokai627@163.com>
 <20260513094508.50888-2-ranxiaokai627@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260513094508.50888-2-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0688160004
X-Stat-Signature: hg9rughqedpw9m4gaphke37y3ntfhxx5
X-HE-Tag: 1778726511-101894
X-HE-Meta: U2FsdGVkX1/mALNIoUsQG8mwEZlCWxVkHuDrwCceWB30993U67etha4YIvYeB8cgTas1sTSOfkSWUfQKFy9SfrvnBZjFRNFs+S49IFfgPe6vJWTsB8+Z+/J/jo+SlQ1tk8kF4l60BjyDom6QT/tlE9jpqRRt4X32NAbtuedVe4gQCytg1ur9wr3Rp2SRke3aoUucvsBgi4Kc0Ju0Hh2K4YSVduk3ne0yKnA+OV01Xmi2CbhP+1SJt8D7F+fYh0MN+DQA1EU57n10xqNchA3Lpim2FroTZhOY7+tWxLD31rfbdrtLoc1OXDfT9U7Nj1vsGhgd9mABqONpe06VHaZD0U+wPajyzcHRtov0OJheL9Vr08hvEjgfnfTHXyWON+gA81OWKY37bue551I0+8ea5/ULdo3Vp7li2n8ihUC0dlbrlvPCSstS1xiMEpCWXthm/AmRfallcwlGZwVROagxuj1PV7YeGQXQJnkdBhwYQAcPUXQSMdxEui9+O9O5cTYY/klFRmm6artZr9065O9V0m86wvkokfTGZKBcJV4y2boUHevtqFHFfimK53YsG0vkg6lEFq78kh2xXtCeHx6PzMelhy4UPV/ollBHJVzD7MFp5xSip1p03f2gW7XbpqUPR+XJg3lH703izLqmdqOJ2sY5Ya3+THaafPtJD2QG7mw8zz+sBiKzocsz49KtoZZtuHPqOBBJgrbzVkIlEdf3foJiKWNeltDOK4lPeaEbbALixX5YW9mNZTyhiwi9ThkVIsUe4PqP4lroNxV//R2+sgdXxS4Vx3w3BGogxrZYQWN59VshyU8yRF4dGIZhgohsRkbao2deT3uhZJn1HmWcTxq7ti/itPGEM4TNy1dMmbbvn7KlEw2Q9aKRUJ/qoDKbt7NZoa9SakQO4Y3My3sgZdKAeoeITWkOrsplQvsD7NWF+Vg7zCjHIz0fuUX+Tncng/Y+BTJ7d2APAhpN2F8
 BVMJENTw
 1inlKwR9pYEotjk7bO/A6tQ+pvge4WF/csvOIMJw1KqU63XX7x1eb6ss21L2VveZFSdZoHaP+uaNSvaPaMAimwQcMg0XmzSwoNtwnZKOi1ZJDHbUOrtJ/SR8/6cdMqdGll42mn+icPmOc5mxtTQBZuXPmpauSRUHb1cktCwm7ACbBXr8FLLbedCk9ozc5uF0H0IXHTeE/mbx3Ut+jAWdIpVIoV07T1CYM4SdxbFAAMeW2kN6uKqIcsTrjF7vyzrxA/CE1W8qtPu2yHQxsADBVhHW+9ZRk5puoWsB9NrSOWbV2wMDUB2R/kJh1MhyK/lDW96/8VvBXmTyOLFh3e3or1KPr8MijEghAZx4rpXmQjmDu42NYnPHw7IafvCN5kjtPiJcx1hA0kI+i3NdlW8HZ8UA1QTkw2Qxv/E3aLyKCta+G8BM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subject line should be: 'mm: shmem: xxx'

On 5/13/26 5:45 PM, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in thpsize_shmem_enabled_show() with a loop over
> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
> 
> This makes thpsize_shmem_enabled_show() consistent with
> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

