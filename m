Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E7FC44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C146B00C8; Wed, 22 Jul 2026 00:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D4B6B00C9; Wed, 22 Jul 2026 00:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44276B00CA; Wed, 22 Jul 2026 00:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4C966B00C8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:00:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 076BE1A034E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:00:59 +0000 (UTC)
X-FDA: 85015061838.03.6AF18FC
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf17.hostedemail.com (Postfix) with ESMTP id E0F9E40005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:00:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=q66hMoEW;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784692857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noynmVdv6GOWzBzQEODBsTTH5zKK0O/aYXI/N+MayE4=;
	b=1AT8QCQeM7LcyCPvfJXGgYJMriMWpiZusZz4OBS0W4gW6Vp9tZBfBc5wNfSsEakrKtLarQ
	OR1vp3gZfyuD6XoAzTJ1wOI4cjJYnB/RYJBXnKVz4jcAYboPXs/3P7BpxmBjPbSz7OVaoN
	lYZRPJPg/aSrwNn+viHJtwnZXH5g9hc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=q66hMoEW;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784692857;
	b=7++7vhdBJFinPMm5QyPFimztrzTxnGXd6nPLCaDay+Ej/ExRIc688NpouYgra583yMzGZt
	KfQirRVyPvaluAokE6p6hyR0rOTx4K44Ljw8KR+SULQZqPe3cHHbBLYvvDv6D9Z1J02S3/
	Gg4xNJpT7uTLisuNrgYBVznIceb6NEE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784692843; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=noynmVdv6GOWzBzQEODBsTTH5zKK0O/aYXI/N+MayE4=;
 b=q66hMoEWLHr21wHkDhf956gafpoc6kvCmdYLKPhsLYtPDLHgxw5NVIc58fUastAUG+w6wZ
 m/QHj496nYEUd641ftBov0DKne22M0CY2ReIz9TrZanvLfnJJI1SA2c4RnDBMvgiOOpJJb
 iQDLDGfSKZcMA4326AtMLiKr2x8kNgfEyCwaaZdMpmVSZxx4ofri1Mz/BKhxkDuEmwmCBj
 qUSkx+O2m01my0VgK+SKowsxrULyslOIOQ4mb16dkQff5/41qKSK1vu13sJQTkxP0M98vP
 M/rL3djkPfPshZ53ZQQd393oBW47TdmYP7AtWf8vJqBqdKXYfW0G0Iqc+ylwZA==
To: "Dave Hansen" <dave.hansen@intel.com>, <akpm@linux-foundation.org>, 
	<apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <muchun.song@linux.dev>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>
References: <20260720120259.1545-1-lizhe.67@bytedance.com> <33fae97d-75db-4df7-9aa3-05a51f8747cd@intel.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Date: Wed, 22 Jul 2026 12:00:19 +0800
Message-Id: <5284ba93-13c2-4727-9693-fa192d6c1cda@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v7 0/9] mm: optimize zone-device memmap initialization
X-Lms-Return-Path: <lba+26a604069+8d3e41+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <33fae97d-75db-4df7-9aa3-05a51f8747cd@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0F9E40005
X-Stat-Signature: i5ynpsmxqdqd7djbbx3pqpr4g5jg6tc9
X-HE-Tag: 1784692856-362836
X-HE-Meta: U2FsdGVkX1+gW9FT6KvSrD/n4ZE7aTdIFXPVJ1NAWxnkVSZQd9qRv5gdY2Bt3rTnZWENqOiHfhivgT7h5JhwnsbtNPhlKomFXupdoMQ7U9s6XYnGFiYl378pTRwsUMCzUh2ycpDv7RVMAT8hJQA7yosll756rc96Osa23E1vC42MNtXY6d/xrw2uwQNEVPbxJnlzOG1HjoZy/WvXqvdkVLXqrHB7JZcGi6c6VSuCbhWZ3Ofc5AbhbzifJ6TCEyVxKLqyO5ka87+mQUQiKkMsAdl44stvBvrIkDULf8Z9YYCuvkCBo8QeObKDtgCdgHUfGrPTB1qJcpsht6KonoR96Y/iv/GmBipwkAN3DDuuP2AyFntUwIAH7v8mXPrPsBceCbYE5mzVLW1bWDazpdc/vsiFPw7+1LvFHe0QeDwC7k8xlBT6qG76XyeP4KbeEmkEIBOceHMrxK19FRVaFCXDDK93VYkATiJmzc59u4oNmAGjWb0awZbddp5KVIzxustwqYzU4O3LAGURVHh524yPUBtkEI0GqJKmwLbSP+ZeKuxpgzxhkBUCRytA8vPRdEfHlENhXjgtq8plIrb35rMDDh3XCcd+xpYn25TZXXGHC41ZubnmDdCW5yJfgjpkLbbkMBPx+VbY4N79yHh4XiLd/GEbgDUZqWgnts15CxyMGeaoXrk3SP6RyNMQIvcxcnlq4Wpvbp9uRkVsqpQ4HhxvBu0EjSESOw4Fpu2eK/y9fQdV01QBxXYqo+05YW4rXZVWiHtrHKM9BlcQeV/zBPjx+B9/Bp+89FLU9i5qP0b2+3sNu3AZHMUxKlKm9pgoj5zknogE6J9U7F3NDThDPZhOaTvx1UuyfuSAxHuM0T54MajRGaVyVXYnPjjHlW3VjkjSvj5ixicrv//j/dUSL6IjJkCzHG6cPfnz30HmypHzqNLBk1ycQKY0Y+SIHw6Io8JFOPtTOfcYRPX6QiBxccg
 3QWfnWgY
 54vMgsI103v6LsbyEi4NY/DXDVigIaI7RnOcvWtop+Mu+sF2JIqKcYYaw1XVhOqw0oGcrSDT1M9L847uMiwyj/hS9UpNsESEW1Ih7GTmkiA9yDiHUIeu96Y6AizL52jgvPcQDAdptCWiYwLCJTkBE383DxeC7tFabSttqFKu7kLzd8iyujHm6y3MIirjVnCt3MhQ7bRhIq4HeXVkBoE2lU58ycVuuN9EGoO4KJDShzt3+YHzVkmZr6fbpGMHq1DN/VvZYpKWpvdzuv0hn8wJinc8r5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 9:05 PM, Dave Hansen wrote:
> On 7/20/26 05:02, Li Zhe wrote:
>> This reduces the average memmap initialization time measured during
>> rebind by about 60.4% for nd_pmem and 56.4% for dax_pmem.
> There are lots of things in the kernel we could optimize.
>
> Why is this important?
This is in the synchronous probe/bind path for large DAX/PMEM
ZONE_DEVICE mappings. Userspace operations such as enabling or
reconfiguring nd_pmem/dax_pmem namespaces, or bringing a hot-added PMEM
device online, will benefit from the lower synchronous initialization
latency.

The numbers in the cover letter are only for memmap_init_zone_device(),
not for the full driver bind operation. But that time is still a
blocking part of the user-visible operation. On the 100 GB setup it is
already a few hundred milliseconds per bind/rebind, and the cost grows
with the amount of ZONE_DEVICE memmap initialized. With larger devices,
or several namespaces being brought online, that becomes visible
provisioning and recovery latency.

So the benefit is lower latency for provisioning, hot-add, and recovery
or rebind of large DAX/PMEM devices.

Thanks,
Zhe

