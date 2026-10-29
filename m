Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0050606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ZtOQpinT
Received: by kanga.kvack.org (Postfix)
	id EA9BE6B05B5; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4DE6B05B7; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8436B05B5; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94F576B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 312231602CA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:58 +0000 (UTC)
X-FDA: 85374675876.14.878C73E
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0C0340003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZtOQpinT;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793255096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/jHONOjsG3jk3ok02og65/P6DgsNIUASy0C0aH+3Fk=;
	b=hxcuQf5P6HN7/v+i1C87swyisa8Pw5NYi3jUTO/mekuMdU82VfwcG2dbfJXqr+rwPMBAzP
	klAqjjpCgeSyDPGyt/jmmlnvT/oUFGOt3A1al1RR4kBi3FU2aIpqqJ0XE/FZE5aT6gNtkz
	B0ZjsFSZhxBXNznPWY2z3tQLfNLb/3U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793255096;
	b=cbDs0ffqpTkwYiQQ6P4IrpCG8aGAI0q6YFrF2YQxJPlYZxyjub9yhJemR8y3yW57GcYDG4
	RQ5Cytc4hHJg1wM0QemoeTZdFEhYt5Z3YA1nzNS7eTQR2T5CNpi51B73KT2hOwVkvpfQsZ
	UkmIp4y8n3YYkEun0NjzZo/ueEPaQrs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZtOQpinT;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793255089; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=G/jHONOjsG3jk3ok02og65/P6DgsNIUASy0C0aH+3Fk=;
 b=ZtOQpinToUAnE5i2fpxWQ/Sbs6hx6Jgx3dpW3z4CMXa0LEp6S3Y36paqfrL4rJcNGoVWbq
 KZMwuwlNWtfKC0yA9VXgkb8z2Q/qya8jztPfkYSV7dIa4JmJhNX9+Z8Kf495etYfmfY/dX
 K0b5qTGbp7fTzS1QuUpYZ9zhCgdiZ0mNw5NSyoISy+/cVBg/3P7vuTodSfZCbT3l3N+2AP
 8BmkXmRzt5lXl6gE6kxFwFo+XR4Gh/kLLGfJGxArIr78cB7LEFOzQWf130WmdAnsuXb5Hz
 DtOZz0TAQTuTCmNTN5AexDn1e1ZGAXlOP/erRKdLEOOw/PZHuv+glcqWJNXWbA==
To: "Bharata B Rao" <bharata@amd.com>, <akpm@linux-foundation.org>, 
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion bypass configurable
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-2-lizhe.67@bytedance.com> <e2fb13e8-6d17-41ea-a9f7-397f62a85f72@amd.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
In-Reply-To: <e2fb13e8-6d17-41ea-a9f7-397f62a85f72@amd.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <74f3a0bf-22cc-42b7-8ced-c8c6ea9f6f93@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Date: Thu, 29 Oct 2026 14:24:24 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ae2e6af+2b1159+kvack.org+lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0C0340003
X-Stat-Signature: t88us6dk4bhdz1ke4u5pthqndnrh77pk
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793255094-159350
X-HE-Meta: U2FsdGVkX1/dQoQkwf9TGxsDrBZWZYztbYYmU4bcY/gZm5ZTVPhHoKImOIG3XrxvqrUZynYYprhtF1t8RGgKOJFDzeC8rsUAOk4eTwrG1CMSyRLFCfB8Lk0Vu63z3RDIcCC069cLNboQqcnUS+/PKc7imp7+B5eiV7A69sRVQh63fPSeRMl2SnAd63F22ktTZv7H6Ri1nUBN5tB703QxJHGU+uUdFR/OBd4EjXRdnp7GARY16ILyMdgT5jEiWFQYEiq4MCiA+m0qiPHab906p6823zjoVEHv6nyDMOuXMACGuLmmvSZ+fsTU1VcGOqNzudiO5qK82wq/sYjQuBiUL+zMSb3VJ4R+BlUlXQbf4JLfpd/pm742bMOTx94vtaskOZVvpsf7+qK7MD52eHPEIclij092B6vMF0tcpVdNCeqkQkBcVPiSkgBXpCgfLIdcwHQseViQ5S9GOYjDEiataWf0BQ689J9HMhKbhINVJc4s671M/Y2XlyI//yLeZKiTNaI8GsIPPJZnFCior62DztHYXkUUS+3/58Fg22Ha9rwUY2uJFCJ9B0c1uoZXI7aMyOhYCWQP7He+OTd9KrlFiSYd/d7h7yyY2ycqRZ1Ukhh88I1FCh3zRMUDrdHb9oR8TVSKvvEGbnbpGxYuXfyEQA79AzBTp9bFWXSZOW4IGmPWKhBvcxDBMMk076wGMoWYb87/CehgSCrTGH2xKctyYk5Tf2iX7tKus4C3Uj8YBCc6U3KAd/1YXU1LnNqKXfGHUGsSw+7TYtwsKH0YIiqwyf9lafpfA3Y4bAQE9AYolMUBE11dev/bELXTEmoabqE+UEzzYRDbkp5vU12AEC371q/R2+ctpkrerNtD9SdC/rBmg8zgPg67ANeGxgAb2QPmGQVDu24RDQr2/zy5YvwPtvw5STKzc9ToAVEdSRz6aIf5G29G0k2rpzT5BL0YbhOLS9ytAt6o2Q3Iqyt8TL+
 b4BRf+Vi
 h4yYpm80uWSmxpK4zbu+8H8aTpLeyHsGWVM79L/WoRRs3RlPN4H+DLky0YGxLjLPcx+E2mmQlNLNty9MHC5G0XESL/6VgKsgVsnUpRvEKilSCRD8kNgpR8kzU40bjvGBq7QwgPlfCC2kO6hBuKIdfNFRKOQKGjzB7TBM0P0K8sUeaR72BXoNaPgZ0kisXPhGMcIfMctHdsMIlt+4H6WX0j+6YwUut/d4FykCDDGqi/Fg7BRSUxAZIbLVFkiHTL8aXsP3x+OPw+LKh6mlnlBEqD0GJ+5dPNr/9mZoKqYkFoYgpfssUJ8t0yCKXraA9pmcwiNqIZSd8I6ne3Pff9YJNMZz6vgYk2v9srj1OoNL3JyYfyvRbFx0c3hYKrRiQE8FpRqhB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 12:16 PM, Bharata B Rao wrote:
> On 28-Oct-26 9:42 AM, Li Zhe wrote:
>> Memory tiering normally promotes any recently accessed slow-tier page if
>> the target fast-tier node has enough free space. This preserves the
>> existing policy of filling available fast memory before relying on
>> hotness and rate-limit control.
>>
>> That is not always the desired policy. Some deployments may intentionall=
y
>> keep part of a workload's memory on CXL-attached memory, for example to
>> preserve a desired DRAM/CXL capacity split or bandwidth distribution. Wi=
th
>> the free-space bypass, short cold accesses and bursts of hot accesses ca=
n
>> refill the fast tier and pull the workload away from that distribution
>> whenever DRAM has free space.
> Currently promotion happens on 1st access. Won't it be more natural to tw=
eak
> this frequency of access and also the time between successive accesses to
> prevent promotion due to short cold accesses and bursts of hot accesses
> rather than free space bypass configuration?
I agree that using hotness and rate-limit controls is the more natural
policy here.=C2=A0 That is exactly what this knob is trying to make possibl=
e.

The current free-space bypass promotes before reaching those existing
checks.=C2=A0 So when the target fast-tier node has enough free space, shor=
t
accesses can still be promoted even if they would not pass the
hotness/rate-limit path.

With this knob disabled, the free-space shortcut is skipped and those
faults fall back to the existing hotness and rate-limit controls instead.
So the patch does not add a new hotness policy; it only makes the
existing one effective even when the fast tier has free space.

Thanks,
Zhe

>
> Regards,
> Bharata.

