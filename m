Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98645D12694
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBB56B0012; Wed,  3 Dec 2025 06:29:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3AE6B0024; Wed,  3 Dec 2025 06:29:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9BE6B002B; Wed,  3 Dec 2025 06:29:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CFCA6B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:29:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 379428A6CE
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:29:00 +0000 (UTC)
X-FDA: 84177938040.28.259167B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 58A0518000F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:28:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBl22uYM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764761338; a=rsa-sha256;
	cv=none;
	b=OZbFYFu4B3tcS7GQJuZprw0MV+IiSpr2I4gC248k38ykeBkhu4HZsmXytLzzNYx2YuEfB4
	5pnHjDXpYJunVzu3YdksmT+XkHKFJYK1U/t9/h5UO/bJxioo8fW0R2MynovtjXxulrfcAr
	FK1qwe0QuK/pdpIpMPwedxaLirreuuo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBl22uYM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764761338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDv7jVKuqB4LnEM069qeOLD7UtcigUvWNdOuGEPcVS0=;
	b=N5xK/HrHIUX15DYoUeI5KlqQZ5ifXrvJOBZW9TxofqtX6aHosp4QWirmTlSZVCnBMUAqvp
	Fw5WVd5Gx/TeELtqoKmrneL2mEA02plPO3q3nF6VQdo+u6jMqPeXek+9lwDDC/tUNM72D8
	8NvEp17REsvXC+8IPv9UfTlyYiPOVPQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43CFF429D7;
	Wed,  3 Dec 2025 11:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5234C4CEFB;
	Wed,  3 Dec 2025 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764761337;
	bh=WjtABvSbCCnx3nvKrk1EoRHpHn4A/68rGFxZqC4DWH8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JBl22uYMsIHsC6F3gqtDORz+MxQxHSbBOAiSBo1Xft5RQQbGgt3u7NN+kTir6Jhkk
	 1HUyrOhbg05uTTWQcxEE9EYbUue+bgPPA7mfmLCUMfZveif40kflHpRUgwM/wAosio
	 PgG/kwk5iUi8Ar0sDBuqBJ9di/dfWfJOxk/cY1Tq50T0/qJGq5xNylDoT+oKxIV468
	 ddp8ZlwxT6EqgkI1/HqJne4XnVOT5QB/sfBSHj25srM3QTFHVaG7EGbIVwyDUG0yIq
	 1xfKegT6U4o7SfaivnusJbg1MEk+T4PiTJ+apuAO/l9r9+yPH1+IIpvhaZ3vHl/LcD
	 M4mcRafKFJmeQ==
Message-ID: <036614fd-e588-402c-8eb3-770ee9187bbd@kernel.org>
Date: Wed, 3 Dec 2025 12:28:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
To: Gregory Price <gourry@gourry.net>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, Aboorva Devarajan <aboorvad@linux.ibm.com>,
 vbabka@suse.cz, surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <OSalvador@suse.com>, Juan Yescas <jyescas@google.com>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka> <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
 <47a8b4d5-f4d2-4772-b1b2-ee96bc21e742@kernel.org>
 <aS_8ndgdVbffPYGN@gourry-fedora-PF4VCD3F>
 <9de2f7e2-a202-499d-8858-6936beb251d9@kernel.org>
 <aTABiHsL8NbGWNaL@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aTABiHsL8NbGWNaL@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58A0518000F
X-Stat-Signature: kx1bck9s9gxayc774r9zs376zn18ruwn
X-Rspam-User: 
X-HE-Tag: 1764761338-163589
X-HE-Meta: U2FsdGVkX19yeUB8GpjFRYDJLmggvXzn94/MRZSFNbLsfj4CwbJDaGxQTf68LBYJ0DakTd95b2MNBgVhIs/JGxq/RzSiZzXvAny/h0h7Bxnswx/k1hXB59vVgTtNr48dHYT2nf/gvmJnvCtEeqN6RkXkZ960BWGpzWKbCVG0Sleu2GkBLuCp91hQJ6+St7g7e68H5mJo1O6wAiinqxIQDD6F4kXMpRsQF8jMTmt7rNzYoMiMRtZVBX1CQIs0a4BsjHHy/Aovjzv4c6cC2lj0miYOnDfDXiIX7SGMyDb7KBJ57X1pMBKVMF+svMmlsP8HDwWFV5kkIst7c8bG2RL96EJ2pAXOM7liP5CXrtTDG0vYNFKa+gNvozwWZ4arl6LgzU6vuUSqSqBVjGt2BjEsg5N7gdv3KOrKXgu+XhBrNWkjcbhfSzlDeSduK+t4KqkH0I+v+ciFdtCoi9B3h5oBZrvYRcEm4dM3KsUc5YhoMWDEybdqmbpcMdtiGkDOJTWjlMcINberUydQIx1then5XDF+WAHqlzD4foT6rny7uKcTrenLEPKUUkWGuMV5sehLDpbebPiSnkymU7/LJxeTXVglHRRRZFSLTAegpFS3a/CxM75Lz0/YiotuO1eROFxrKsiFwms5J6JrYY/P/1HtdjnNlLkz2CeNslT8dYjrFM14smX/wK9mHzC9GmipbDnXSNweMAIteF9QTFkBKDznzR/IEpBvhlMxLlSZ4wAnY/qR/8qWobVx75xg1aV9EcnYRh2+FCcrmDHhfnx0wnPq3YjSM8Y444fT4bfaps2BqzDiL/4kqb7DMtVC9wo7/m/HDxCRczlIf/cNo8YV/tL/BW4ztAh9/tdDSrI1LSvJPZvVjlgPUoE24fKDyIDj678GgzjbqdtyV1Q7P9qkt3+J0UlTbbTbtUKdr9IfkEgo+O8KpXJx1/Jj+IMKb29YxGxcOFbCCK0t2yW+OeTAka3
 ZfORHXYg
 s9W8JYN+4h+1K1PbPKaMiv97GlFqlU8tqn/CfPPTfqRoMXOM2kTdXnjIfETy3Zl7oA6GDoyzfV1/0S1xmox7lRRXz7GxHl0mxDktCNSLeJJ8KIcNEmZtlyKVoAFUq1EVi/Eny+3kypItcSpiQOJVc8JcVTIalwQMY0qgkie+d01xQ+s1n6RM1RExkKriduPMvPosDcBEmatVDQWFbXt/sktwYoaOgHexLHP4VDoFm+ma9uElPcp5nmD67wlBLPisZWwn7M7HAgxYxswyeV7XmIYJ81KDVPw4WnmHMH2jJY2Hjpo/xCwTs0/tvTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 10:23, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 10:08:55AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/3/25 10:02, Gregory Price wrote:
>>>
>>> My transient failure (although i'm not sure it was actually transient, i
>>> killed it and retried after a few minutes and it succeeded immediately)
>>> was on a ZONE_MOVABLE block.
>>
>> Okay, so that one should not bail out. Longterm pinnins must never end up on
>> such memory, and if it happens, we have to identify why and fix it.
>>
>> We have this known problem of "stream of short-term pinnings" that can
>> temporarily turn memory effectively unmovable. Juan will talk about that at
>> LPC [1].
> 
> Nice, fun, good topic. Looking forward to Japan n_n
> 
>>
>> We have another set of problematic cases (vmsplice(), fuse) but I would
>> assume that these are not the cases you are hitting.
>>
> 
> We do use fuse, but this system was relatively quiet when i tried this.
> 
> We do have some proactive reclaim / demotion going on, but i don't think
> it was that (see below).
> 
>>>
>>> Kind of suggested to me there was some bad condition the resolved once I
>>> took a second to release the lock and try again.
>>
>> Hard to tell I'm afraid. Do you still have the dump_folio() calls we print
>> when migration fails?
>>
> 
> What luck, I do! :D

:)

> And i just noticed it's the same page over and over
> 
> [ 3404.119270] migrating pfn c06f176 failed ret:1
> [ 3404.129152] page: refcount:4 mapcount:0 mapping:0000000061ca20ba index:0xad28e5b pfn:0xc06f176
> [ 3404.148284] memcg:ffff88842e855000
> [ 3404.155834] aops:btree_aops ino:1

Small folio. Not GUP-pinned (FOLL_PIN, otherwise our refcount would be 
 >= 1024.

It could be ordinary GUP (FOLL_GET) e.g., from vmsplice or some older 
O_DIRECT user that was not converted to FOLL_PIN yet. But maybe it's 
just btrfs / something else that temporarily holds a folio reference.


Given that this is from 6.13 ... hard to tell :)

> [ 3404.163193] flags: 0x17ffff066c00420c(referenced|uptodate|workingset|private|node=1|zone=3|lastcpupid=0x1ffff)

Neither dirty nor under writeback.

-- 
Cheers

David

