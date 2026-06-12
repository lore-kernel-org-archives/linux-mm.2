Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E50CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3AD6B00A3; Fri, 12 Jun 2026 15:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665AB6B00A4; Fri, 12 Jun 2026 15:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B5E6B00A5; Fri, 12 Jun 2026 15:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 441EE6B00A3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:38:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E5794022C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:38:58 +0000 (UTC)
X-FDA: 84872273556.28.78B663F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9378C18000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:38:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf24.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0LvTVeGTMOvbXCA1RnhFGsENM91XuXn9HvxDXiiqXMU=;
	b=OBvbHGcPflDGYvx7OarRqmu69tVoIvYxrdXXbvv+NQB5kaR3FuZbfxAbLyGDZziZALKkT2
	f1CfwTW46BOtFMZWjPQXYkTCX3RGDZZ79DEe3W0Tj2+M1UiY+2F1l1DbXBcvOHzJitl2IU
	UAUN9EVpd0xd+Ue9bKt8aKSu0lvVN60=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf24.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293135;
	b=vcZI6JUO9lknPcBw5+2TPN+x/WZzHr/oe3455VPP9rMjY7ey1/n9qk+T/3HbEUPAW9WiEG
	PnT6RBIqXm041qqj8iukFksaNGCMjgY5cCTzAySKMKtfBgZfVVxw1A9LJ2JC3Oa+b+C2G1
	iTxKpVq4FeRlE82YAZBMx44LtsCWudI=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gcVF032Z4zHnGhg;
	Sat, 13 Jun 2026 03:38:44 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5E2F04058D;
	Sat, 13 Jun 2026 03:38:53 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Jun 2026 22:38:52 +0300
Message-ID: <a425fbe4-c75f-4fa9-9294-40ca39ffa0d3@huawei-partners.com>
Date: Fri, 12 Jun 2026 22:38:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/4] Documentation/admin-guide/mm/damon: add
 DAMON-based Hugepage Management
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260612003356.83586-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260612003356.83586-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 453wf7djhnrbn5t9hib6behx7ei6zagp
X-Rspamd-Queue-Id: 9378C18000D
X-HE-Tag: 1781293135-758924
X-HE-Meta: U2FsdGVkX1+Woz4q980pYYs8KLXQU3c5DP0TLz8BTzsgc0zlq36eslAlfSSp1pdrNiw81XNZ5M/UDmulYAhBG7wOgn74rEzShLFUsCf2raS3ukQBJfh9cnKWlFzYjw/SSenoTrQ0oMO13m4jJsNDcbKhMdxCH1ocnFMjHhQxL5yW1jDVI4KJV6LrAdT640XLz6MfN3/feXHU0YishZRAt66T79bq/xO5gjpl/yV4eS03NgEpHy2mCQl7eB76N73NyDF+KwsghVCBxJuEZP5T8QLYvUVapeOLgHJWAzrLY4c3QBcVnqCNtLPEJWMesq+Kilk7PqmTEYA3cKs2IdfWradmQpSZHFIdQQoCdMe8Fxd3FbCcInVrX3Y88XCxxsdEANbbfz1muJtTd2rJo9aXLE3g168emkFS0nrs1PHg/pbCYKpHNXxZKR4BsiIsSBHhwVtNaHgmVcsP6YiqE97F+Sngag6HpuNc5FtMV5+ZCQ1k0AgMXGJHZO+azhWvsakH+L8lzTs4Mtyn5Kh8z9xAJOZpaqFbCiJKSc/VbG0Xi58S26iwrhR1jee5g5/LfcAxdUD/Fua/+NVQIZArYdxGEzeKfq4YvMuHtpHruHkz5DvoJwxNII3OHB6Qbxl/SkeSI7sa3NaFQzw63cwyTzNqcTj7GsUVeqJ2kf91CAJ33ZvQrIK7IXOMRbWQxf5JhfxjQFWtGryXotOcOdZZFQvv3P/pk2REl3n/SyJCEm4bjOPjUN1WgqdLCtjbnt4kZOcS8e8J3LpC2X6ehoTweZmfGZGx3IXI9GQ5yeoylSDZc0ddNzoh+tn93jDS3ccM+ElEQitVJyweB/9ZBJnyHdplU4gs5Hl6/yFc/ez1nGTmGOIUbyMlxHmxi/n6bYErrGnbevzKqaSwj+HTkR8xEm0g19n1fnJ6lsV1XQAMEG8wSyeTaf7kSSsLMat1gp00OniY2KHlZ3+LZBFGObk1QuI
 L3o2PmiS
 fneB4yv4LFGzcEUO6rAZ5JiyblOgSZx4L3jifIc/cbLiEAQjzTRrlF5sLSWEfzrk04Yuf5+4i2rs0pIAM3pAmxRkYMpaFVa9mMhyJy1BEIzEJSUb4Ulsc/m8EeHgG9LGlVwCtkxozXbfg1pQO7vfHVhiEEWvTWtUfJkDroIjnpyb5IhRsLHPsfYDYdPgMcTVBj0AXqbaLK3gY+CxSRhSq/1VwWk5gBqCf7nLCCb5O8mlEYulJlZyG8lrJ7v7DWkHANjBb8GHLVftmh44P3GzDBRlS94nRCYtU7+GMWiy+dIUnfRcT1wlpvhhKeHmwHfqstxnw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/12/2026 3:33 AM, SeongJae Park wrote:
> On Thu, 11 Jun 2026 15:02:44 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Add documentation for the DAMON-based Hugepage Management
>> (SAMPLE_DAMON_HUGEPAGE) feature, which automatically manages
>> huge pages by identifying hot memory regions and collapsing
>> them back to regular pages. The documentation covers the
>> module's features, operation, and all available module
>> parameters.
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
>>  .../admin-guide/mm/damon/hugepage.rst (new)   | 113 ++++++++++++++++++
>>  Documentation/admin-guide/mm/damon/index.rst  |   1 +
>>  2 files changed, 114 insertions(+)
> 
> This again feels like following the non-sample DAMON module's patterns.  I
> don't think a dedicated documentation is needed for sample modules.  Could we
> drop this?
Make sense. I didn't see any documentation for other sample modules. I just
submitted this in case needed. I agree with you, I'll drop this.
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


