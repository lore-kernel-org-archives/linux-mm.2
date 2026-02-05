Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3326E9126B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C655D6B0096; Thu,  5 Feb 2026 01:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C128A6B0099; Thu,  5 Feb 2026 01:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DD86B009D; Thu,  5 Feb 2026 01:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C76C6B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:59:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 469D28B8FA
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:59:00 +0000 (UTC)
X-FDA: 84409500840.08.7B8CD95
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C0B6100005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:58:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NmjiaT9K;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770274738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6qFZpvt332CWfnqiedPQcDy2pMKUb2TChFJK4dmduI=;
	b=H5T0tFx/Z/oCk0vFYu4haorWQjmOKm4CndNEoKnFRExIQtn1XqwWE6BzE/trX5VPf5dVN1
	vB2iMXZ3biStHpMe4e7WJdKD1QDC9p5QK9Ahb30BHH7Cbo0LZlmftEsvS4RmxrKf8FsE3O
	eiWSZg9CneInWsd2ydp69mBmEHD+JCc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NmjiaT9K;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770274738; a=rsa-sha256;
	cv=none;
	b=lRPY8DknBu4Jv9bxxpSQKcCmk4tc+Rny6O803g57EC32/b5xCqEuWYepxB6XJGOWDdxSVu
	Lwn9YU+j7jQNdAfqGAeV0Rh//D0nfjjqhm3ZqEsEb+gcbkiJb4TVwKWcP9nlKQ7XtlCGC0
	I/pfnQ06Jr03xIn6i+vFTO6x+4SHPf8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J6qFZpvt332CWfnqiedPQcDy2pMKUb2TChFJK4dmduI=;
	b=NmjiaT9KAgTcZnqLfzY2T+P0jf5y+K35HhScOksU/2hP8azoXPD5lTVTenvlTv2hjAIGL0yAU
	h4CRBB9XyMG0YGWG719WF28Pse1IzXBfdmzfTpU7Ao3i6ojqE0ATpxexkexdR7BXPeFl62lYMRL
	9YPplnAxmPfwy2LR8C26Yg0=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4f67Hm13f5z1T4fy;
	Thu,  5 Feb 2026 14:54:28 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C983F40538;
	Thu,  5 Feb 2026 14:58:51 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 14:58:51 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 14:58:50 +0800
Subject: Re: [PATCH v3 1/3] selftests/mm: add memory failure anonymous page
 test
To: Mark Brown <broonie@kernel.org>
CC: <akpm@linux-foundation.org>, <shuah@kernel.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
References: <20260204073331.899406-1-linmiaohe@huawei.com>
 <20260204073331.899406-2-linmiaohe@huawei.com>
 <2028f5e1-e032-4909-8240-15fe0b3c82a5@sirena.org.uk>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0a84104a-32e3-8518-ebc0-703814e233d4@huawei.com>
Date: Thu, 5 Feb 2026 14:58:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2028f5e1-e032-4909-8240-15fe0b3c82a5@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C0B6100005
X-Rspamd-Server: rspam07
X-Stat-Signature: k3eojm6agrygkghd5axarmgfukr4hzqn
X-HE-Tag: 1770274736-657612
X-HE-Meta: U2FsdGVkX1/0D74lAgdeYGYs1h/wMT2KPQ8Q2Wd3aKkJ9uwJS+AX7xVA5/M+NfHviyaoeHEX8si5vgSCTNOymJozQ16prX7wf+8eCDl9JB6tchZWPp7MEFujCAaSAfCwBFc4JhzAUH/kWRrMraxZwrkEZgpMtKJW+fulv/wBTyFk6SC2HGeC3zbhc7xoOE5lZUIpDips9POxT41ppco4K8oTSHfXzXQdhNCx+0AZKNRqcGBw+TfAZYaPPKpTqEbgdhrrSHv3CgrdYhN+N/qI8iU5Av1ZszJR63yBBm1RumbK/E7TfORc3IWjOO8+hcswW5KEQ2e/I5zBO4T/ifHZEfVBfU0qeZCiatMNZxJNtjqFGIInuxVqEpcBjeHTjRAqbb7+BDVNtHDKsGOtAsIQ1skzgWD37Kc+3Ajpnk+B882+8PIT2r6vMj4BvQ9OyRVR+Ns0BaR8BS35nF8T2EU7wL7oWZl7W8uQDY5bt8iItEVN3hjkt1DB71tUR16fXQB4wjP49xtfddWYyqX8mlZXTH+fOJOp4qinM9lY7Zp4/z5OXoeAnw5Bo1C8Km5DpWekdktBw8Ze8+ljbI06eAP+Kupt30AM059yX65ZWdTZUrHK2Nhqa1oVlTITDpEs8ksoq9F+cevzCxfsdLROxNaSayyOW38oPoyu7L+QkTOh+GO+WvmZKsY8UgJf06CM2YhQrrQBDxb0kcwOXg01Hv315msIQnB3X3CXWG/Zyy8l65QQdjQZ+VyHxBz/DXQ+uLaN/T0LVHbDpODY8XFK18z4wlALM7nx5zDtAVfsv0JDWYqpRVxSDjZFbSzd8zIYEEydzGa1lRvgQg0FRFXd5Zqozv7ZgEStMU9rohiYXg1Bz/8ucKH3R6ErUTkTCH+Vk9WX/w8pwRXmrA6PINK+o1B8xmqHJsxIhCTkhbnwSGpgH7yj8DWiF7wRqWaomVTC4U1I1CX+q9oKjbvVrB28E2y
 3g+uD89k
 BBvN1+Kk9rIM2GzAQgvo5bAshSS+oPYxZiEHwVyMKnmOUH+I4i60cdh/il6ap94Ucds7yYgMfeQ4lm4MT0M0i5uvvHd6SN4I83FpWmcKj7BhZN/saB1JO1MsrQ++ivn/fOUchwtKswLl+joyZ4kDFObd9ZY3Kq5Va4l8l4Oy0eD3X2rSQN2oI3SxtOrO3TsDmhEZ4KIDzbk3h7Px+wnfRrvoB/TnsTfX1xJP6B7URC1pUn8NqoWRZosaSnM3O4t8LILeBC5RGZAOILRHYjvhnWIQPK4tAcZh0O1ixnGfm6sORJr7hQV4Dw39staoiavdtb5ZqMYSZftyupWG0K7u/MnMXuP46lp6/tvQn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/4 19:26, Mark Brown wrote:
> On Wed, Feb 04, 2026 at 03:33:29PM +0800, Miaohe Lin wrote:
> 
>> +TEST_HARNESS_MAIN
>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>> index 29be9038bfb0..afdcfd0d7cef 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -91,6 +91,8 @@ separated by spaces:
>>  	test VMA merge cases behave as expected
>>  - rmap
>>  	test rmap behaves as expected
>> +- memory-failure
>> +	test memory-failure behaves as expected
> 
> In -next I added a hack with wrapper scripts per category to improve the
> integration of the mm selftests with the kselftest framework, could you
> please wire things up into that, see:
> 
>   6ce964c02f1c (selftests/mm: have the harness run each test category separately)

Sorry, I missed that. Do you mean adding something like below to run memory-failure test separately?

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd7ed1d6769f..b531fd2f4e4c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -171,6 +171,7 @@ TEST_PROGS += ksft_thp.sh
 TEST_PROGS += ksft_userfaultfd.sh
 TEST_PROGS += ksft_vma_merge.sh
 TEST_PROGS += ksft_vmalloc.sh
+TEST_PROGS += ksft_memory_failure.sh

 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
diff --git a/tools/testing/selftests/mm/ksft_memory_failure.sh b/tools/testing/selftests/mm/ksft_memory_failure.sh
new file mode 100644
index 000000000000..ae1614d4d49b
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_memory_failure.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t memory-failure

Thanks.
.


