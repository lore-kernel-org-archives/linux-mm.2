Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D46C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CEEA6B0096; Sun, 13 Sep 2026 23:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7226B0098; Sun, 13 Sep 2026 23:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E50D6B0099; Sun, 13 Sep 2026 23:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64BEA6B0096
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:41:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D688F140272
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:40:59 +0000 (UTC)
X-FDA: 85210966638.26.6EF16E6
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B632C0005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:40:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mBEKpevl;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789357258;
	b=vMQcpVi/8/KTJxcrL5oMP+12+mJ7flURgQf7k6X0oV8/GR/1kDSlEqcrTIy7avyI9xmGNw
	3fGy4VtVOKsArdBDEULJuD5ChNXl+JSf1t2ycfncjQ+95ARmvBlPSUaZN51dqh49alJZKP
	t4KtC9QP9of7m4lWBzLImu8+pbGsTFw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mBEKpevl;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789357258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoexynbmVsxSclYh9BsIybBGJ4wqU7ohzfDGpEpM46o=;
	b=Zey/3BGXo+IoZ1diRCAoHN9KtPZ+e0M6QAR7TAh6zmgIug4kVJRbKVlkX45n/cO9RLKYRT
	3IiT79+1tAVWj8/BbPPnsth16hFIgn7Cj1pNeK9vQ/rtjjTwG2mo06S1xwUb0E+g8zuWfk
	1uplskiXQ+MW4NHnaILYsWoPm4XeocI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789357253; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AoexynbmVsxSclYh9BsIybBGJ4wqU7ohzfDGpEpM46o=;
	b=mBEKpevleTdKUY0maLWoOm2Mi45PeaZ9jwdsjjXKVJ33NlgPosdWQb66enGhIIZsIw2QbFxnIos3B2q5OCFlHqDCe67uyuQslKJCwpkB3pEhwsjgVKapY5WM6hxmKS0uU11k7cdDKomgXmwdYMfmzhUKeunDN8KBfT9OzmFFAg0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XAq4-4F_1789357251;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAq4-4F_1789357251 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 11:40:52 +0800
Message-ID: <1e42ffaf-fe9d-4da0-92a4-a003f913e795@linux.alibaba.com>
Date: Mon, 14 Sep 2026 11:40:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: ignore sysfs configs for shmem forced
 collapse
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hughd@google.com, david@kernel.org, ziy@nvidia.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
 <20260913194327.019b3db96ea9b0719fc147f7@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260913194327.019b3db96ea9b0719fc147f7@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B632C0005
X-Stat-Signature: qadr9cu8i91zn16zwjgn35mjc65meuod
X-HE-Tag: 1789357255-344697
X-HE-Meta: U2FsdGVkX1/4N9pcXhp19VwPMhUICAOB3KBGWoLFLdQMfpn6myYlesTRStSMHReogULWVeivJXkJMXD/nT/zS4V1XVQXSaJ+jxNictV64IGwDlOR2TrPrCzel5exSx1XXntIz733gmg0kJbz9Fo6LD5TXBOVB84pMZK+0p4ooEJlBOP4bGUydj+fpilwo9tBHcBqvKShmpLFCeD/DeffAQ2su9XxFZdBMYsyT+eQ3RYKPoIhbq5xlF2b2nCwQ62TAaDNKfenIQfUErs3SO5ZacEYwVKqAdSp3HCTx41zdS1sJOk3flXCyfW224L0jYzgZbrfEYNVh4vyuJDLvnGPwBMpnnFL49h1aQ5bRvwqtZm1ixcIKXcHAmHGW4aElUcnJvNv2zAahmPkjH+mQY8yVYB/W7had8E0GJBNO1IIbuLGaHX7nCE2rGfdSEdMNHyfOyUillOJQwPFjur7n0aGTPMgg7Hyhj6uyVALxOIHfSKGlRogfDLICpavh5YOzOXC4VdEJo41zig4VjqDhV13zIpb7MuXXBBy3zu9EpFmf3dDRt9oqN27dpXl402rMAaqdZAsSW5BKEDT9UzdowxYXcdclckEyj4i1RI1HgN1O8ChQwJBads7eVrGbrvLDUX997ccUmBGl9cIKfijKw8IOIfnavaMQ5rrfWo+S9BdXP+apfy8MGmWt/GEIU+nTk7bH6i5LDAJfTpZmFL5QIn95bZ5QT3HVGq7MOrpn1g7KtvNEvzeTiIUBDx9XDLgq9HOGAjPMM7x4yXQcXztv+FHHeCGmltDBhSQXWijP9fk2XpxLI7NPgqirwRaQjBKuPMfO0N28PN9KjpyUPOrlpMzf+iTnS06QRBCFWqPJAfdDMyFnyQsKoYyfj1sVQaCOQ3Bgpni8AbqYGkiYlaGTS+/enXPPnWGxPpnfqzoVNphhSe6srEiGdW5p4d6VNWnaoss+IwAiqjJma5Z+frXrI8
 1PLNcoXf
 zWyTZJIxeXrJuKK2q1gCunCLJ6KIFI85OEGfkomctXcXf53gpYwhvuqaHnfcODHTwUYyeg3wqp3qiO5YSuwMOEfGLb+C4TaJdyL3FeQsacml7PuWjaHnvdilL/6UanqRs64tOgS/ZGgWFP2EA+n3C9fEpyB+SFw3WTMP3WRTqc6eKIY5k3DJHHxv8rjWGPm3MyecKbcJDa2srDh6yv4G9YfHHx+cnW+BcQxslL70WvCcsgMKXSoGuG0EikI88F0flyWtTR1MViGbUepV+baYUP/TKSuNwDJ1Ct1WlcahAlLQ+41c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/14/26 10:43 AM, Andrew Morton wrote:
> On Mon, 14 Sep 2026 10:12:41 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
>> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
>> ignore any THP or mTHP interface settings.
>>
>> However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible" semantics
>> for mTHP with anonymous shmem"), performing MADV_COLLAPSE on shmem will
>> depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
>> (although that is the default), which can cause MADV_COLLAPSE to fail
>> unexpectedly.
> 
> Userspace-visible runtime regression?

Yes, it could cause a userspace-visible performance regression.

>> Fix this by returning the result of shmem_huge_global_enabled() directly
>> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
>> shmem THP/mTHP settings.
>>
>> Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
> 
> Should we backport?

I'm not sure, since the issue is triggered by a rather uncommon 
configuration. But given that the fix is simple, I think it's fine to CC 
stable.

