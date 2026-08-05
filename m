Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD46FC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003516B00A9; Wed,  5 Aug 2026 05:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6F86B00AA; Wed,  5 Aug 2026 05:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34686B00AB; Wed,  5 Aug 2026 05:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C821C6B00A9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:49:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60B44A042D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:49:54 +0000 (UTC)
X-FDA: 85066744308.11.66EC6E0
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf20.hostedemail.com (Postfix) with ESMTP id BC1831C0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:49:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SapNL7JM;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785923392;
	b=vL/a9eQDxc7/nL231DzHmbzeXZEwFpCYyD8ICcGZN1ip83Cv+sDCggWAOSrO+0nCPTAWR1
	VE+0nh1L8oD4T+iE1IILAHzcjfp8pNWBVrxOI0I2GxOpcM9jMwbE0ShLBFf2xjwD54UecS
	eDZ0FOxhbziF9Ipf34sohuyq4aSKDBI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SapNL7JM;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785923392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/uAgkm9aok/nQAEqWTWVKcO/AScdnJJ1CYyygt77ao=;
	b=rNnNYiwUrAh9o5RolKqo0TnBpPJ6P2ZYK7z9OVXdHoHiwSwQhp475juX4Esgb+bWPNSgcW
	bM+H81MW3aOZUlcrihXQrDjHzSb0Iu8SNSZVQ6oMr4D+RcmsYycBTRmpxoGj4sYFuk21Z5
	E2bne4N7kJZnHLu1d2Zs/GDjcc7X0AM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785923386; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Y/uAgkm9aok/nQAEqWTWVKcO/AScdnJJ1CYyygt77ao=;
 b=SapNL7JMPb1FOlhJ98JpcCYff/SGexhYFrVyyr9IdxPtMp08AiOuSpbIoobO1bCjcix+l4
 x0x3gG5Nxlu5wL8jV9lPCk8DGnak+l4AGLb4M13ka3lfnX1Z737gr9lbPvbsPNxTXn+lEp
 +mV3eUrEw7j1OBQ3STL558KJMn2VB1D8DQcAMexAsfL+OKEKh3kaiYcSvl20Ra52zMKwCq
 tdfIX3z4DUqQlxVyq3SKqCbPduETEWvNn4LzXJGoWhC4MWNbde/ZYRC2AkqiIwzrNY0UiC
 AKnpsZQhj5jmhhoukLV6iZMPAhkZX3Xu/CwlT7w944+dyxQeJuRJFI7cp7FEUA==
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a730738+338d5c+kvack.org+lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
References: <20260803070929.86075-1-lizhe.67@bytedance.com> <20260803144014.e2d4ebb83e9471b695f6290d@linux-foundation.org>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260803144014.e2d4ebb83e9471b695f6290d@linux-foundation.org>
Subject: Re: [PATCH v9 0/8] mm: optimize zone-device memmap initialization
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 5 Aug 2026 17:49:22 +0800
Message-Id: <7ce88e5a-8b96-4508-91b1-b72a589e6ac4@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BC1831C0007
X-Stat-Signature: o9ygp74gbpjnfn39utphgeu3jj369hgm
X-Rspam-User: 
X-HE-Tag: 1785923391-779960
X-HE-Meta: U2FsdGVkX1+0r3Ct5TQdI7AdqJvL0MnO/8E09g5VOEPF1zHWyzywFxuwc8Z+X+vKOJF+znxU0PhJpFyYjE18Ylt0xDLXKfpivlVrbVM5UaF9FhFovO33kYmF0GD/8+z0SCTat6xT6bGmOAxDqReq4ft0k64k+MF6Vr+cPfuabnKNho4tYYfaUdA/Czqsx8RU2l5qbGZ4OCXHbgPiiRUYwhUV/EaBpobPXQSIryY4KrWrASJLJ4JFoJGHWKFyNNqafHWLpv7Lp0jC7C7CeztbvveOkebOiUTsb6/YxXcohxxZgnBy4KWJCJkfV18uXg7vws+W49oc3H0hd0aETMA5kdZ1UN/AGG+4IB1NNEHoUv1L5xGc1U99Vz1SG8woMl7ymYHnoq/577wpv68GV8TH6O5ub9U3VWHUfJnEVR20VcWQEF/4ABX8AameEnA8uso3L5HHP4/mOfZJDRaW+fxZis0wCvsnI1sjtn32A5XF+hJznhaz0RENyWeH7mncekiylFjr5LItbps4Ax+X8oJ8WBzGNaKjvAQWNjAoHa4WJVd6x4y/wupLN0sKvLa8bDbEgzGRERd9VRnR4TGkmE08er13V1mW7csTNnrxX0zhtdjuDZhtF6xyA4iErSNQ13o4/DqA0Tdl7ErMr0ycEYN9kFt8TgFtkFHxdzix3hH1HCLvlk5YfWlx1M/gZWV44NcAiHIdZb+ZQ+jgaN0tzyn4UpEVgpw8qvQC5Ax3taieLG8w2M6KaCUxnOQTCEo149AgQIW/KDiFAB9XbHmep3wRGt90vMa/qaD7hC1Z5YHxFK8ohuBBO9/rQO8xv+TtyQUlEBY/ZlfQLaymNViD74FalFmdbMu65qjioFDNRSFDWD95s9DpYzHvcF4ZL/pJpP84eFbnP2r3lDKNOoTWURE2GHucQp0b34QSVirbDf4NLQbSPuLsqWpMlkIW13KcXwvyZL7p02aznEKIu76Z69x
 DSB1RImM
 6fOfZcEQJgAO2K7/CyP38zMzDXI5hoJaqo0XRaIHaj++xA9mL1r3E7yUtM2Mkv3jgDQ0Vt914ogDWeLyH3efyFPpj2iBMgXiYtuGaZDGjjcDQbcON6TmrfUduy+14aDFx/ywRR0ncZ+xPCh0KD5lBZZ9QRb9btI9sMak9z9ehjDth0vJG9rs0a76wTSTwzB0GehLi1L7WHexVjJ2D/5wMH1dhNCOpt+DJYu8cKr8ahQFNfd/ya9+mz0zlDpQ+HxtcH5GtNFcFJn7ICYAHIMzg3Jc/AySZfKyb/JlQCe1cuYs2/vwWi/vCNq8k46CN8Gvkmp8YHt3ExeyM0cOBNKiD8wocMrZu48fONOb2wtSeHD7BC8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 5:40 AM, Andrew Morton wrote:
> On Mon,  3 Aug 2026 15:09:21 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
>
>> Test procedure:
>> Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
>> initialization time from the pr_debug() output of
>> memmap_init_zone_device().
>>
>> Base(v7.2-rc1):
>>    Average of nd_pmem rebinds: 244.28 ms
>>    Average of dax_pmem rebinds: 273.31 ms
>>
>> With this series applied:
>>    Average of nd_pmem rebinds: 96.79 ms
>>    Average of dax_pmem rebinds: 119.04 ms
>>
>> This reduces the average memmap initialization time measured during
>> rebind by about 60.4% for nd_pmem and 56.4% for dax_pmem.
> Well that's nice.
>
> Review is partial and it's late in the cycle so I'd prefer to schedule
> this for the next -rc cycle.
>
> AI review might have found a couple of things, please check?
> 	https://sashiko.dev/#/patchset/20260803070929.86075-1-lizhe.67@bytedance.com


Thanks.

I checked the Sashiko comments. The reported items are the same points
that were discussed in the previous v7/v8 reviews. v9 already folds the
related explanation into patch 7, so I do not plan any additional code
change for these items.

Thanks,
Zhe

