Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD79CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 07:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BA08E0009; Mon, 20 Oct 2025 03:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302C48E0007; Mon, 20 Oct 2025 03:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FE68E0009; Mon, 20 Oct 2025 03:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 115A78E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:35:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 832D9888F3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:35:07 +0000 (UTC)
X-FDA: 84017681454.20.B59DE53
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6BBC2A0009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:35:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sIujCKHk;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760945705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwY4Mw2Hsvl9+mXWTXLCL2RzlZKdk8AHQMi9pCkPNSQ=;
	b=72L3wisq2yLNpW0KDep1weUhWCKz6VXUl0RvA4d4TQrTfAQgYyHZNasWiu/vIicOpeYqEC
	9iQlYxHTQZpXn0vU8fJcCl/MMW6UgHZpfYpP6U/ENoAer4WbTFOBgmTC7Giw/4AfrLqw67
	IGm4Rm9ZAeN3F8nPlvIXbQzMbdjYS4Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sIujCKHk;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760945705; a=rsa-sha256;
	cv=none;
	b=Cp4kOwQPiVqcqcmnkgbCxfW4QSray6UMCzxdZ+aM42fL86jqHATGgRaKgQHYjEUUTY7wTU
	lZDW0F+/H+iChP0nUKFQUOBOOk8Ns/Cz9ILNIiC7AzucnSufYO6rRxgKW14PIrVg7tSCiV
	+ZNftkG9n7/S/W8pxooRXgOZk4qLkfM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760945701; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FwY4Mw2Hsvl9+mXWTXLCL2RzlZKdk8AHQMi9pCkPNSQ=;
	b=sIujCKHktqqskuFN6L4JjV+lGcV+zkZ/8v8eYJ0u/4DB0Zr3tvg2r8qj6fkxVeKtEm9ztl62cMCSlv8cXyoFPp8ZFhIAjwLilNB8qg7sTJjUz++k5Wf9M//xo1MGTOW88JHzDQHiX3j6rLyIFm1KT3ppVjwdeYrCTbOPIjNKb1U=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqXxQTq_1760945699 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Oct 2025 15:35:00 +0800
Message-ID: <3971f97e-399c-425b-979f-55334eacd925@linux.alibaba.com>
Date: Mon, 20 Oct 2025 15:34:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: vmscan: simplify the logic for activating
 dirty file folios
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1760687075.git.baolin.wang@linux.alibaba.com>
 <ba5c49955fd93c6850bcc19abf0e02e1573768aa.1760687075.git.baolin.wang@linux.alibaba.com>
 <aPIwafJOKUh3N4zX@tiehlicka>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aPIwafJOKUh3N4zX@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6BBC2A0009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hojiippnm5mmc8uywokuknsodfg79tmp
X-HE-Tag: 1760945704-179099
X-HE-Meta: U2FsdGVkX19SrMnDDHDry8ade2lCCl/Vgs+7E9DBxqTPvFeaH5mcvpQcDXLeli3cMypYyZrnXbS5b6eYdts+vE4iRhK3pXrMdJXrkGAxau9kdX9qzTawGH61ahBXJZKzJcFU9MS/+RGJFsNpZUO2JpbAjYnaRpd+rTAd2I3DR6p4T75DiiV8O66EfHDgELtQje2Lbmdn1/VJBqG6B4+TV+TdRSVkiGwqttaKnLGUXtOrfZaQruIfSf+oXyujz7TR2sRNY0cbTqBwUQa4LvmowbPVOG5Xtzj5qAtwOVlC+M5Af1cBqCxGy1m1K+HLSXEUJfm7FAHE+kyptU4kdXixpPxwoIO5joNDCjz4LY2KSu5CE4mWh0hGrYyBm9Sgs0Q51JModVKhfBZgvXAiQdjoLmDoZxEL7JL2NcAMa4SEk5j6UzstRy/6xKbBdG/lmR2HUjcNm8m4nD+wF7MttdPPCMIcOJJ8MkZpAbZfFlMSy9AdFxa5fhYZidSWXxfV6m5lwqiWaqgjBvJwLJ0Vmd04fk/tvmVcudNuaXUpEWZ+v2uDuiqAXzgYftbaNAMoWn1ojb03/7qFsR1FCpfDRnDc1Yt54bHOnJqF5/s6mzeQP5I2y6tHm/zUQdouCQdpDtwQXDz2Qtzrdm0rCd23NtWC9L4BexmiYWeyyL2vOcXdEjSBr5MWaZYb9FLZTqPBgijHAs/K9x7i+MPrm66X7cxA/zK1/oq82zdU4V3gGHcw7bQ0Gs9uXZT6SNz4GWRtQU64uYPlHYXpDWkVFYGLAPe0As+y51g5zOCiIGRW5DvxGijNsKsL5sMcYrj0v9DBafsgtc2DZ8R7HpJ7pcmre5Srg6gkSdjhfzXBLZc9N0M8QzwrJp0JQy94lcHG4tUBjhMkMFR9AHccpV4meXNwFWRoHBtP/dTBqPUrX566KA16Ouw8g1A1dNI2T502uNjHk6a+TTp9myjwyZUjk3FAzi9
 m74ggeQ6
 6deosgVUzxNxhWXCzvFx6KcYK0lADbftPFzY/v+aPMJGOKG0lREc+WlCYbvgVgnHESWVk7bVIDvvcFOzmgKhRJ9WWUF3aTBO8r5Qa38Ey1VxloPJrmgYvTIC3bO5XC4xhj1/deeeiQVtAB9zBKKVfM6TdB16jyp9PZRLlJDDgvIqDTH62XmKftby+W8H0rRIDHQbC962YqaieXNmqOPBpneCycohYWJTCY3znuEXl3hzIn7oR4CJ+tTacdxuS+C9Dh201H9aeQqAmoPyct6vG8GQDAxpKsD4cj8FqBGVAI/TDGMmyavLASjrnV/kavFjgC3U1LuQU0wywmyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 20:02, Michal Hocko wrote:
> On Fri 17-10-25 15:53:07, Baolin Wang wrote:
>> After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
>> attempt to write back filesystem folios through reclaim.
>>
>> However, in the shrink_folio_list() function, there still remains some
>> logic related to writeback control of dirty file folios. The original
>> logic was that, for direct reclaim, or when folio_test_reclaim() is false,
>> or the PGDAT_DIRTY flag is not set, the dirty file folios would be directly
>> activated to avoid being scanned again; otherwise, it will try to writeback
>> the dirty file folios. However, since we can no longer perform writeback on
>> dirty folios, the dirty file folios will still be activated.
>>
>> Additionally, under the original logic, if we continue to try writeback dirty
>> file folios, we will also check the references flag, sc->may_writepage, and
>> may_enter_fs(), which may result in dirty file folios being left in the inactive
>> list. This is unreasonable. Even if these dirty folios are scanned again, we
>> still cannot clean them.
>>
>> Therefore, the checks on these dirty file folios appear to be redundant and can
>> be removed. Dirty file folios should be directly moved to the active list to
>> avoid being scanned again. Since we set the PG_reclaim flag for the dirty folios,
>> once the writeback is completed, they will be moved back to the tail of the
>> inactive list to be retried for quick reclaim.
> 
> Is there any actual problem you are trying to address or is this a code
> clean up? How have you evaluated this change?

This patch is more of a cleanup patch, since dirty file folios are also 
activated in pageout(), so there are essentially no significant logical 
changes. Moreover, this patch set is a continuation of the previous 
cleanup work[1] for dirty file folios, and further cleanup and 
optimization work for file folios reclamation is still ongoing.

I conducted some evaluations (such as building the kernel in memcg to 
reclaim file folios and running thpcompact to reclaim file folios), and 
I did not observe any obvious changes in reclaim efficiency.

[1] 
https://lore.kernel.org/all/cover.1758166683.git.baolin.wang@linux.alibaba.com/T/#u

