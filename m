Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB85CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978256B0088; Wed, 24 Jun 2026 21:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929BC6B008A; Wed, 24 Jun 2026 21:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840896B0092; Wed, 24 Jun 2026 21:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AF766B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:42:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A21F016544C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:42:15 +0000 (UTC)
X-FDA: 84916734630.30.77AD23D
Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	by imf03.hostedemail.com (Postfix) with ESMTP id E788720004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:42:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=fMfJFJyT;
	spf=pass (imf03.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.60 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782351733;
	b=IiK7xyjYQWjpqWKDTMA+jjZZYdIkntUnVyrv5pxufcRhP/OZ6rzQqtwI+F3OkZFDSsJewM
	aDZQpHqe1+yav/zw56+Vm+Cp6t0xQBoo96WT8X/BxlpVwZoFgcclS76uGYdSnPM4nd+SRJ
	vIgztmLw/xNUutYl6zJUFoZb2KejTMo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782351733;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4j8f6uFb433Grb8B0eRcI7+Ke5YL/rbbA2Y0K+GuCg=;
	b=mbZLz2ZYfLCr3RGuNLGzCDSJ4mesQKHcWwZi7HAu3MAeXQa/WJf1+zkEhn6ffBpJsKNG6m
	TKPszBfzB4hl7DFolfAqiHVomHGlMHQjaXTcmOEZsMLKGNxpD/cc+ntJolfJYjyOq0yRUr
	zCZiqRflL8n6nCF66Vms1Nze8d1X/NE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=fMfJFJyT;
	spf=pass (imf03.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.60 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782351728;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=w4j8f6uFb433Grb8B0eRcI7+Ke5YL/rbbA2Y0K+GuCg=;
 b=fMfJFJyT58AGjKzbG4LBJYi/Ehgens5KdI2jxzQS81BZNn0UA1zTA3A4qAHXSndya/Sno7
 70AT6VxXyZLVQhs0GEVbQLd7J9HOUDuuzz7d/0594l4+jbua6O1Ne7gAT69RuJY+M1XGO0
 sWGdTmHodHUtx6Iosj8F1dCkXtEeW0yGYetnKwRP0E7YIBI3f8yYrm2UkqwcdQ1b7+DLx7
 mU4CEYcroDUxWhHYpK1yvvXey3mEhO/2Zw+dzGCabbedrz8H14LzkIaKNhHStNhXAYXVaL
 pyRxMmB/h3Vr3FAL8gAbNLRMNsvH5FWX/XHWhVW6L1Tz4kBSJ5JpdxnNx+Q8Ew==
Cc: <akpm@linux-foundation.org>, <chrisl@kernel.org>, <kasong@tencent.com>, 
	<shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <bhe@redhat.com>, 
	<baohua@kernel.org>, <youngjun.park@lge.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <727c7d76-ba00-4905-b64f-e954392b346c@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io> <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io> <34d48fb5-4952-4a48-b92a-f189bc3edd0b@kernel.dk>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Thu, 25 Jun 2026 01:42:06 +0000
X-Lms-Return-Path: <lba+26a3c876f+fd9a20+kvack.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg paths
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Date: Thu, 25 Jun 2026 09:42:02 +0800
To: "Jens Axboe" <axboe@kernel.dk>, <yukuai@fygo.io>, <nilay@linux.ibm.com>, 
	<tom.leiming@gmail.com>, <bvanassche@acm.org>, <tj@kernel.org>, 
	<josef@toxicpanda.com>
In-Reply-To: <34d48fb5-4952-4a48-b92a-f189bc3edd0b@kernel.dk>
X-Stat-Signature: wg1ar4ootaky7mdn8onffjih6ntuwior
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E788720004
X-HE-Tag: 1782351732-233422
X-HE-Meta: U2FsdGVkX1+SzgmDFa7RhWNFPrsHPQYbJXFjyzlhobeOB9rMS8W288DiMdwywhsxjLNoeH6r3BALjVNVcSHDMMPxEhg/Z1ukXEaKVmDWuvTE3kMaRqIhvhBut73W3rogWrpbMg4b9yvBTLKC2WfUxtfZruCJuc8drmZhzs8Qh43ovtr/4lpoBtKGcGyVHnK1V4ANJbTbfeX3mN/sgTnHU6SJxcvmYXvqrHWNaXM9z2Dum75p3bL925av9yqaUy0YzGBFyZWPv+1ENdT8xRDw9o8SZ0Lh7r0NHPCH5kiGRCEUAOSZ/TWmemv/1pUwplqTQjaP/TfraI7fWQAtIPTGpo31VMOnomijwRPxzBUCYJkgvLq1Ocu2KtF9yk0w6w9ujSKhqRoZHZL+y0Kd20blxgkqAZmBaB3ow5CEQVA8Jimyg1GFn8laEgoLHcPKY7pFRmIA8i7A2Lgdj2o8PbGUIsWu4zdo6mIuuDTGCJWkjasYflgMt7tPobS9dsoWcBNXkTGlf7Kf/IajQJWIgxyT0UhcbmWDaJIgNmULNQ7rp7XKtDzJw4/sOx6Kudr94up7TXIr5zpjJrDh6uKCJZPMHi9AyE+2/oNevm7swThfNRn/n/ELKsoEtlbM9e4460MPwswGPGjMGbWIG13sFjDlXNJSCOrgx2rMoYFyvN0uA3HsTPlAH/UatidgOKqLKZzFBmyfIrGQcqLd9EtzAY4CBLl6zYJv6OcFSVdMlZuJD3tWQ5VgT27y/Nism5BuGRB4+OVub6gsFmxTBwVH2bq/wBqcvNfx47I94RSGFV/dC8EHbynmEg1VB54HEccs2TIHWgbwTetM/kYWYzcJw301jorAOOlUK317TvCsqlc7vCM5eETBIWXbZs0czGxigHNvpQc1eqL6Ypm8T78e5VN8Su9wV4UDhP+ORki4lrOxKW4+UMYqBQT3kKWQKOPKntDeyYtEL0wdp+iw6NUheQ+
 Q3uB5QN/
 t/kSiT5/MJJ4i85qPFzaNfVJ1iwBgCcxEjwj11BAkPDRLjvJIbhEQivIGmlSBSP+x8moKz0W9eIZxYu75bycomcWX63bLeXPr0n+h/MLz/02wDA8BZGKkzA1m1zlcP9jEK9YWA3DgUadQvgBbzNbfq80ak3g8ad+emrZN2szm0bEn3DkLEddze9FqmPFmy/ZhGRPTWIyNWRb+RkYECd6FzVN7sxEwyfLQjHhVmW9vyxATdfThqDH1mYIeCsJH0Qx21AOnRBcr8/MLQj6+22243rBXIK1CO4M+lyLxlFJq8BPmN1Cj67mGF2n41O1eW454QH3CyNJ36oXUccRXOjp0u7Q5BkoEoj2sFe2Qc24MqYC/Kik2I1/3cJJIl0/CaMfKgvh5pTb4a6cHL/moYiLc8cs2kY1q1OeFN7D7GJU5gu0MwDih9ZtSHqXx2xTrzZ9bEmq8ltjU/s9BTt985tzL4d25hv4QUYdkcrJpPyR0Juh6RZHizDUjUVmFLQRdC+6x2AqCDvcMJOKS3X9+t6jym7cK8SyW10Drh3ajDkt5YlCX2Hv8Yr1A0UQfH9JYZxh5GQ8j+m6qcXNrFVzI4SzYhO3WvgSH5XSba5hOTySaBYvqzMSKgVukkTFr3dfNQWWl7IP125aYawEcHSjtkgP62RTm4Q7gvK4uBwikQW3G/EVQ/rYvycte+cyreh8adcKwZvdBuMkr4EmFQXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/6/24 20:43, Jens Axboe =E5=86=99=E9=81=93:
> On 6/24/26 12:57 AM, yu kuai wrote:
>> Friendly ping ...
>>
>> This set can still be applied cleanly for block-7.2 branch.
> Not sure how you checked that, because patch 3 very much needs some
> manual attention to get applied. I have applied it now.

Thanks!

This was build on the top of my other set:
blk-cgroup: fix blkg list and policy data races

I'll rebase and resend this set :)

>
--=20
Thanks,
Kuai

