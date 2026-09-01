Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD2EC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EBE06B00D3; Tue,  1 Sep 2026 00:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D2B6B00D5; Tue,  1 Sep 2026 00:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B24E6B00D7; Tue,  1 Sep 2026 00:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57D0C6B00D3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:01:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2DCA1602A6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:01:14 +0000 (UTC)
X-FDA: 85163843268.08.D4C61A1
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf19.hostedemail.com (Postfix) with ESMTP id 621A21A0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:01:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LCJUuRpv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788235273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3Yo6irIZLQFuD9pdpnG9SGQ6Tzo88ZDjoh/R1UIafo=;
	b=BKuTBX4t7/dODFKEFkv8xIY/fowmo9sSp2vr4ToQonuJPxf4AwVUs9cbDOvI+z4lmHbsv8
	a1B5AHUa7OWVvgHrP4W9Z0c4Ck8Lh6X++nU4/IeVycsEmqOlhPhPe4QraLNaPfbvzdN4g7
	OmPaPp5khofCxN6bkyFPs8ceFjqtkr0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LCJUuRpv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788235273;
	b=RwwoFHfWFOSnt/7kK8jmEf4Ygk1Tdh6o+MM2ojc54Lv/swU9AZrM9uzTIJw+cRi290uT1R
	InOj7LC4uNVYpsKeX95QwhpD+4XpOWixIgAsXYZOlH68Q4G8CI52zKcstzMhnUR0EtL0cM
	NlASkPqw4ZWI8Uh6ye34furo+ph4I84=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788235266; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=t3Yo6irIZLQFuD9pdpnG9SGQ6Tzo88ZDjoh/R1UIafo=;
 b=LCJUuRpvIwwzZOYzcZmXwngfBwXo8FA/aX1S/9oy3fzMoQO0wdhT1wj7NDcwyJoVlmshlE
 yWOLvu7h3Ym9W9y8jpmRy0sUICYcwLT0+ub9D7zJqPCNaVbE6rJ1Ofk3xKRTkyaQduvvbc
 TGxppHC4NOeAHO6sZE6FBOEU87w36VEgGZaLFPIDHNVtWFO5a4gfx5DgGUBv+BLr+Ra+Cn
 kzelAj5pnt63n8ae3cn9+97m8IWY/6nz/6Aba8iaujqQsvbpd80N5+sjDTudhUFnzWa667
 QtApXU9pBlemYkYajt21R8/KKkxDDUu5EA8OGCznLkeqwqa65YFfXbPecuX91g==
Date: Tue, 1 Sep 2026 12:00:50 +0800
Message-Id: <e64e6cd5-e7fd-46ed-9116-28e2e97a48ca@bytedance.com>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
References: <20260831091023.66581-1-lizhe.67@bytedance.com> <20260831173220.72ab28190a44a305dacf4d04@linux-foundation.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a964e01+137713+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260831173220.72ab28190a44a305dacf4d04@linux-foundation.org>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<aiqi.i7@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mp1b8ghxs7zmeuwzwksd6e43oq5xpa7o
X-Rspamd-Queue-Id: 621A21A0007
X-HE-Tag: 1788235272-42825
X-HE-Meta: U2FsdGVkX1+rrYDVjqoal4cr3LJAWXMlXm9NcG8wjzyYZw3mcE2jS66o5GOXRIYu2Nrrc6FFKM0PbqH5LTuD39dkD6mlFKB59auJ60KbYGKq20cLJbntw1q/hTifLtGRCsEd2Vf1nPy0s5Joo+dLxRdpqjaE8Q24rKZ2KSiOrdaXs7Pa5l6vEsCA2ykx3vdsrGE1kMg2jFQk49UXGiGcXfT1N+D6uU7VlQG7eulpVdsOCejZlpX8Ooggwq0EbfzNUF58tqS6wzWhl8jXCexPxwiAGcdJW2a1LUjz7m3MhSfANv957giijGxrHLDW1V/1CxBg7tI+TBLED33oD0ee+ndGQwxs1FnYDypcZMF38eNLdouS/ZtAFi6eYi2t1r/dy+IMfNXbOnZrjzw9NMs70UyuXLYxaYs87J9w+vRXCDoTst4IWy3UTITbX8bBB2pD9lnafUwzRS/iasar9SL5F3BlIfMMxmBcFaM0dHgOsgFSVoqLt04qE6yWXcRe/8UTS5E6XwNxtpvuCTuuxA08uZuH3LTJQJ/c5bZeYqQezghe25/8FY2ZQhjKKvNU9ibS2dRlxlyGAbTITGvDdwVfLizpz2AzTGMAcREV3AFutrcvqDvVWrBIMrlr2Sxe50Fona+kl1aImK+Reda8czIpXRRIbWdg8ed37u7eEvRfSO26W5Da8w/K2RRNSI48hCA+KXxmgsiOi95KRLGD1thiyyyUd/lSOSuOTDQ8gyAk5Y/hyWW7RRTndS8wjcdDv81P7RZqiWkKtK4rBO9ZHrL0V3M03gPURyhNNjSIR3EiBqm/oNOZyV3s37a5qZVDUxcJnsiFIzxHzafG38R342R1o2ZdxgkGMiCxFiDfnklj7VkEaLH/fIUWBYvnlCYgo3Wy7XGIZqXsJClLewSBBpxzMCkp1qXky6AxChvBWRVHtEhtoPktPdLvpDzBLvSPgy0wsjiQs8uMTEvy7oW/3Ik
 5DH/0qdB
 ahDGBVFMDu3JJ3S1torrp6Usmjqy9W0UtZ5/vr1Wd4w+HKhA1LkviUco9MOlBrf6tjhZwjRxPHLqeLbiUigU6fU4sJow8sME9nwXKk5uIKqJ+YyZ9kos6/okpwJ2cEhgbgjdt3cfWaXtKaNdIDYp8kfx9UcfZ0nwnQ3qT7thj+TgEPhs9Enamuy3f/xYX8z1iGH+qQYiOZXUhy66kJ7bMm5FILP4L523R1DgpYhHQiE9xw7Le9ArIx7ud6QuzBGypigHub2w4b79IXz3PxyOkt99BF0gpHajy7GI0vTUtadlUwqNhF0yQia4dIVga9ZuPxi5L+TeLY92uuXU12lvsB9tISJ/3EBKmigZj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 8:32 AM, Andrew Morton wrote:
> On Mon, 31 Aug 2026 17:10:23 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
>
>> Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
>> PMD sharing is possible. That is only needed when huge_pmd_unshare()
>> actually detaches a shared PMD page table, because clearing the PUD
>> invalidates the whole PUD-sized virtual address range.
>>
>> For hugetlbfs hole punch and MADV_DONTNEED, a shared mapping can pass
>> the "PMD sharing is possible" range test in function
>> adjust_range_if_pmd_sharing_possible() even when the PMD table covering
>> the target 2M page is not shared. KVM then receives a 1G invalidation for
>> a 2M operation and zaps unrelated secondary mappings, so the guest has to
>> fault them back in.
>>
>> Fix this by using the existing cheap "sharing possible" test only as a
>> gate, then inspect the candidate PMD tables under the locks held by the
>> hugetlb unmap paths. The notifier is expanded only for PUDs whose PMD
>> table is actually shared, while the other callers keep the existing
>> conservative expansion.
> Thanks.
>
>> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this
>> patch improves P99 QPS stability while punching pages, reducing the QPS
>> degradation ratio from 7.09% to 1.45%.
> So a modest performance improvement?

Yes, I would describe the measured end-to-end improvement as modest and
workload-specific. The Redis number is mainly intended to show that the
over-notification can have a visible impact in a real workload; it is not
meant to be a general benchmark result.

>
> This led Sashiko to perhaps discover what it considers a "critical"
> pre-existing bug.
>
> 	https://sashiko.dev/#/patchset/20260831091023.66581-1-lizhe.67@bytedance.com
Regarding the Sashiko report, it looks like a valid pre-existing issue to
me. I have not yet looked into it in full detail, but I will spend more
time analyzing the problem and the proper fix. If that analysis confirms
the issue, I plan to send a separate fix patch for it.

Thanks,
Zhe

