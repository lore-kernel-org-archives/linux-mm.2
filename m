Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBD8606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ic5dd+V2
Received: by kanga.kvack.org (Postfix)
	id 82D9D6B00EF; Sun,  1 Nov 2026 21:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE536B05B1; Sun,  1 Nov 2026 21:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4276B05B6; Sun,  1 Nov 2026 21:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 469F66B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:57:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C63A41A0B78
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:57:03 +0000 (UTC)
X-FDA: 85388667126.29.4B0F35B
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id 615E4180006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:57:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ic5dd+V2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793588221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6eZQaYDZXMgf+0isykjo7ZZmLKawkQEHO01TtOhj3Q=;
	b=YUWXysFCqA0Q9Dtahrqy90dYOpqrgFlvRLJThMEL5fHfJznLSHgw9PTHrlz4Ar3cw80gSc
	PQlziCUg4gBCm8dZxBuQuUb4+E8u33UuTKx90duZkfeZ+ijxZZR/vKiq2iYoa34PuqEdre
	kS6Kr+ZZlLnDGqQfwHCGrH8r77c3Fss=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ic5dd+V2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793588221;
	b=J9ns/98QIUP7NLfWQMC/YlTJQCi4ydNEQLCAvQSXAUZC0xPR/28S6Efj9ywiFnN5NcK8mD
	kw76n7EkaXRTdzX0IXBJX5FS85HIWxjAU2xj8pvOwnuw24EuDyZ0tRNJSbgNpNBc8vSrvG
	f4vRhna3WUs5WVcPy3+RJ9OSbSWIKDk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793588214; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=f6eZQaYDZXMgf+0isykjo7ZZmLKawkQEHO01TtOhj3Q=;
 b=ic5dd+V2JV+cpanb/cyp3CBWM6Wb9T4m0EmoVJjCjw46iu6xdht76Xmsgo5ce13LyhYDYp
 tg6P6gESqvyi+PGpJG5TiLZWVa7IdnhKWjCuDzJK6LuDyI7wQpTMKZKvYA+lgGcmlby1xS
 yAR3QmU7cT/arIuzoqMDjZXEu7J0Uux+DQaXaUClRSDfO5WwIHR6+mJLkTME7mthiZ3BdF
 KgS6N5gugzDr7/24xKuRrz0V5qYgWfYev2nsQRG9+r5OL7BvmwciNj004/mKEC2kVkuH2Q
 OZhdW3r1K+zyyZsJY/OaBdnvtIRrmxp27b7EKOyucwLxRnUjBItnB9qFTCCW8Q==
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <c9cf96bf-f3b1-47da-b22a-9600b5fb01be@amd.com>
X-Lms-Return-Path: <lba+26ae7fbf4+b5498a+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-2-lizhe.67@bytedance.com> <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com> <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com> <a6bcd771-fcf7-4fe4-8c21-5e65bd579de7@amd.com> <1bab234e-8914-4694-b0aa-f265fa49c6d3@bytedance.com> <c9cf96bf-f3b1-47da-b22a-9600b5fb01be@amd.com>
To: "Bharata B Rao" <bharata@amd.com>, <akpm@linux-foundation.org>, 
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <rostedt@goodmis.org>, 
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion bypass configurable
Date: Mon, 2 Nov 2026 10:56:27 +0800
Message-Id: <3318a7f7-4dec-431b-9284-ec7c2807151c@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Queue-Id: 615E4180006
X-Stat-Signature: nkcir75drmr1fs8gqh4f4r84iocyzeu8
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793588220-961131
X-HE-Meta: U2FsdGVkX1/fYGXjSLeI8HG2YBjXFPmxxMr2lAmCtNXUpCxDAhYwUE0ZMJxr2UkAMevwQt0fD3b+cZtjZl1ASKhtXqxoMjO1VdXHog3iWBQj84M04E4tkGqlQSOMxTWldaGRle13Xm89t4wK8KckwMxbrRRvWm/IraL+SnSmlkzBk8O55fetjOAik53ojXH0xZgyg3gszHNQtMZfcWTDn5QKu8Y0SDYYA9oakJ2kiFQIKsgKiK92+Ydi4KNxO4HBBzJqjXNSQEl/Z0R0AVbofQcpQ5QtEIBxKBHv0vwrOjKi5SvueH5TCBlnmACjw4aKg1W7UU7o8He1/+3es4G1zIPJ9B2sfWs1hceWsb8nxklo9GS7kVLlFEK9VHjt8BRDO2mFlZX8PnQsdD3H1bdvrzgF2WygjCou6QfW5jX2Lu2M80bI9Tgzz/xkotcyDBLdflymTWFnyxK2cGyuag2QUdsDvqgnfuLpWH7RRw7438MPmqi8Bhd9xeqwh2snVo3mZXQkXY7EJF18fzN0P3gojoM4APNvtk524X47c1ltYJrtNbuuPtpkxstA9Xwygwk4GWL7ovpUh++8mllCqcqH5wN93YKhzibt6KS2VJP6Ilxd/nVrGOt6v+pObuGCS8lDvapmJvxdp8in4oamywSO1zktS7PTYQ0pHBN2n0qFWVygHdUYD26REYSQH/VpL7IQhf1juH+YBgc70RpRe7+YAijF2jBdZCyW73nrKi7X0nPIw2ysa02iN4COh6RRujkjUtRqzn4rhyTatcsYv6D9KApYFZ1P988jzKJ1eFATgr81MzZpWQThab7qmNj3W8q7aeTwXffFlVrO+c2bRWbDeL2/YvwSiAn3Au2ECCnZqZbdt6PiZ8pFW+S9FR6HnTEIbMJyoeHuE/zytZf9RSF/yOwKxKN+SokYDt9QTJ6oWvQEAcnd/B3UQ0ZTlKedrqJiIDZOPEPj984il5Ekusn
 +YTArS/N
 1l3fI+UP6DWOVVwsCD1PIBB3H0LUyi+pA4ERBanKJzkTomwbWowlSMxPhNVNhzOb07cOFAwowbExGa7FGRA2L0dAQuXWbGqL+2mHzRsHc2w7JCprSQWxepMuSkAV4C5w7tTrYLTOSs/enSoO+A1xjr/SVGciZMPiM1KUGbQw34+uIgaerFNWC1cKZZem+B4BfojlhOJ00j1iMZX3qKK00oevBDUiSa5QsXvv6v/sQ9hl7byTmHxrBpwIq5MFqrhpOFfwVj5UvH/BeWTVVXK9MzpdwQ6R39/EF6xMn6VwZWZ8xw+roEbw98dD9ks/olloo+ZZ74hPnM4Qokhr3RHsKZzoHXj4EBwFtC/nyzeP5Ag4mKWEtoYzrYHUZjcIhI/U3JAun
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 11:44 AM, Bharata B Rao wrote:
> On 29-Oct-26 5:03 PM, Li Zhe wrote:
>> Yes, the case I am trying to cover is closer to the non-overcommitted
>> case.  We do have deployments where memory is intentionally placed across
>> DRAM and CXL memory, instead of relying only on natural spillover from a
>> full top tier.
>>
>> For example, the orchestration layer may want a cgroup to use a planned
>> DRAM/CXL ratio, so that DRAM capacity remains available for later
>> placement decisions or other workloads.
>>
>> In such setups, the top tier can still have free space, but we may not
>> want short cold accesses to refill it simply because the free-space
>> bypass is available.  The intent of this patch is to let those
>> deployments keep using the existing hotness and rate-limit checks even
>> when there is top-tier headroom.
> Thanks for this information about the deployment model. This is a useful
> conclusion to reach.


Thanks, Bharata.

I would appreciate further maintainer feedback on whether this series
looks acceptable.

Thanks,
Zhe

>
> Regards,
> Bharata.

