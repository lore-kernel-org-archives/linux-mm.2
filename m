Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D33ACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AAB6B0298; Mon,  1 Jun 2026 03:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C7F6B0299; Mon,  1 Jun 2026 03:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA366B029A; Mon,  1 Jun 2026 03:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC4906B0298
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:16:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50B904053B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:16:56 +0000 (UTC)
X-FDA: 84830486832.18.69581EC
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2258C16000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:16:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=NrCjURBa;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780298213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMVFGeQet2q9i38H6nc5ggraVuL3XTIUP1O16KEY7o0=;
	b=wA9bVTRbMFZAyvV/cXeaZ3oVelJqJip3ITK4HEefUCwqAxLNNRGby34gapgfcfZ9gLrYqh
	bpHLeap2VJolNcUo86ZBoWuYh5o26TnuVla8dt57BmlVoH9DSvnt89wFNrzTqruxfMquUv
	QgwGpsPvYZ3PkMepyG64SJU3ZO2btzk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=NrCjURBa;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780298213; a=rsa-sha256;
	cv=none;
	b=KH3B3yTR9Wvy8J/CnXF/NSjJmUyfd37ofaDj4d7GRF7wB3zCcLIoLncIW72t1jquKxnzOD
	gVJOFlUad0EE06K8fE1eTWTpcFlqcl8LBkon3UqH3t1xCG7An6sFi+q5xSwQnlGbB/sjUW
	FacLUddB+QUJ6B88ZNEGd+ZwXFvZF2g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:To:
	Content-Type; bh=eMVFGeQet2q9i38H6nc5ggraVuL3XTIUP1O16KEY7o0=;
	b=NrCjURBabv0q9bQWSd7LBR68SUEtmSmqT8Auy7wVdxNSy0Utfnfw9ANFWepPja
	yNFd1GkcL8+a4Fr/LS26WIX8p92ysQr1dDx9TpicPuoZC/Lvt1wCeBOuk780El7a
	eun+91E0ynhrvh5aI5Jv+CbBOwqyPOA4MyYH9WsUmlcfk=
Received: from [192.168.3.148] (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBXW5KxMR1q+JGXFQ--.4S2;
	Mon, 01 Jun 2026 15:16:07 +0800 (CST)
Message-ID: <0c52fc64-3546-4008-af98-6d589ef00c99@163.com>
Date: Mon, 1 Jun 2026 15:16:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] mm/shmem: optimize read with reduced xarray
 lookups and folio batching
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
Content-Language: en-US
In-Reply-To: <20260601055704.167436-1-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PigvCgBXW5KxMR1q+JGXFQ--.4S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4DWrWxKF4UAryrAF17Awb_yoW5JrWxpr
	ySgr1ftry7J3yfArn7Gw1rKFyxJrZ5tF1DWF18KFs3XF1Fyw43t3W8Gr48GrWDCa47Zw1U
	Jry7Jwnrtr15K37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6KZAUUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2xdb+GodMbcZaAAA3v
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2258C16000F
X-Stat-Signature: 173px4mccx7a8rdgu1ywqk6g7w76j8ah
X-Rspam-User: 
X-HE-Tag: 1780298211-688101
X-HE-Meta: U2FsdGVkX18+baFEk3wHCY9Q55le5rgEn+c2pZf+URXA2/1uIYppsZr9JsyvSVZsT+uyO8z4mfpPzLJPuwB9DcFQN52tJkEpzgjVb31etjv9MKQph1HLlY1+ol72ErZV5IJJ4q0obYkxMtbiDCud/zBtD0L0/gU8JhJfG0KUoRvSWY8VmGxI/9IEdUJtxfbaCMKbEnI9fuasSJVVsU1W9jRVvvnhnslvOWbYrQSg1NtYLYEMiddNzxalQUuKeJp1dP5mFltxDkq+2RvKsE5hc+2/wFbo5q7mA3CdlK863rWm4Usiv6jiYNjAXWjYi0n0Mm2nUGhTmWTXsE7xf0//l57ouFCcImS43SZx6Q6w9dGsl5+HBuv+nZMFiaOqtSvONioSuNT70RtyEOLE0p1yadQVBVWUd0MP1CsNlXmyOpJuscJDQwhV6WY6Y2cC/ulsiG71BJ7QT2kvabmWTiRwEo7nHSCh3YpIYxoEnzij/0+TX5U9K2ZY4l9/btis29HCRsrNWU74gpGacK2A2iUDHssMn4QWE/3O8Fun1FnuHh79XN+g28EaQFwszJjUK64PZ5AM/C9jw7mDUwDFnACDUU016sCBS5REt72LgYDuzBwPFc6mz+SP7wlXAlfWHsw2R1TESQuwnqTFdLYUFU62rT8oNaxGzIKMdHrjXzrzMAvwzurqc+b/0n6DdoWIcSjJH2z4PWQGrPw1yr+NC5pP0U8vPF9n6O7SEuQOtBoBfje9NF1L2zbaQniBQUhXgBrZhQqy91WAvJaIZr7AYNPlwi0gRMpq5NzLfLNbPdTrzLLDgavyD4nEfB2kw68qM05D2Tp+bFYR6R9vmRnZc0Tlc1maU8h8aMxlcWcUUlroFu4IR0d2vKVYp31O1tpgVRRX6nuMv094eQV01DTbrtVg3OPQJb+8lt+D6Hb9UO3psZZef6tmhJt7c99qGsZNj/y8/nTr4YVMngZgzo4gWU3
 jCgQM4hh
 Tljuu3oe7DV8FAz/qNUISraSfMPafUDYvy9AkanBvxtVhHxxKhi50L4oMJmsopfF+HcES1O+cArjHF+ySGiOvGbRTHNkvVAMoJ06oGOoOA5Qy4iNDJv9Lotkdr1Ld07lRHf5dywnsen6eoigAJLMlHPZEYdsJY7hVk6kiQO41SKZxW/SOw+kmzz452HdfGhozbqi2nBzhqKArowmIkuRlJuLjECbM7F0e6vw2iayp/7IwTjm7cSLA2570mqBbai391nVtm+GSWK6LCe7iHQHB0Xy4Am+e0FTfYkOIj4VD6fnHofeOrsP2VVk+iueHTaFZr2U37rSv+i8qOkaFwm6OdFR0dJCus9At8o2R8DcsDw7zf4cbx6jfkWzMQT2vL2fq3KqR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 13:56, Chi Zhiling wrote:
> Performance Results:
> 
> fio --ioengine=sync --rw=read --bs=$1 --size=1G --runtime=180 --time_based --group_reporting --name=seq_read_test --filename=testfile
> 
> | THP disabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
> | ---------------------- | ------------ | ----------------- | ----------- |
> | 1M + normal file       | bw=11.5GiB/s | bw=12.7GiB/s      | +10.4%      |
> | 64k + normal file      | bw=11.0GiB/s | bw=12.3GiB/s      | +11.8%      |
> | 4k + normal file       | bw=3826MiB/s | bw=3849MiB/s      | +0.6%       |
> | 1M + fallocated file   | bw=23.8GiB/s | bw=28.6GiB/s      | +20.2%      |
> | 64k + fallocated file  | bw=22.5GiB/s | bw=27.3GiB/s      | +21.3%      |
> | 4k + fallocated file   | bw=4655MiB/s | bw=4680MiB/s      | +0.5%       |
> | 1M + hole              | bw=24.2GiB/s | bw=28.6GiB/s      | +18.2%      |
> | 64k + hole             | bw=22.6GiB/s | bw=27.6GiB/s      | +22.1%      |
> | 4k + hole              | bw=4652MiB/s | bw=4489MiB/s      | -3.5%       |
> 
> 
> | THP enabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
> | --------------------- | ------------ | ----------------- | ----------- |
> | 1M + normal file      | bw=13.7GiB/s | bw=13.9GiB/s      | +1.4%       |
> | 64k + normal file     | bw=13.5GiB/s | bw=13.5GiB/s      | +0.0%       |
> | 4k + normal file      | bw=3833MiB/s | bw=3859MiB/s      | +0.7%       |
> | 1M + fallocated file  | bw=24.9GiB/s | bw=34.2GiB/s      | +37.3%      |
> | 64k + fallocated file | bw=23.0GiB/s | bw=31.4GiB/s      | +36.5%      |
> | 4k + fallocated file  | bw=4710MiB/s | bw=4655MiB/s      | -1.2%       |
> | 1M + hole             | bw=24.3GiB/s | bw=34.5GiB/s      | +42.0%      |
> | 64k + hole            | bw=23.5GiB/s | bw=31.1GiB/s      | +32.3%      |
> | 4k + hole             | bw=4690MiB/s | bw=4647MiB/s      | -0.9%       |
> 
Apologies, due to my oversight, the tests involving hole were incorrect, 
the holes were not successfully created in the files during testing.

Below are the corrected results from a retest:

| THP disabled | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
| ------------ | ------------ | ----------------- | ----------- |
| 1M + hole    | bw=27.3GiB/s | bw=23.4GiB/s      | -14.3%      |
| 64k + hole   | bw=27.3GiB/s | bw=23.3GiB/s      | -14.7%      |
| 4k + hole    | bw=4825MiB/s | bw=4624MiB/s      | -4.2%       |


| THP enabled | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
| ----------- | ------------ | ----------------- | ----------- |
| 1M + hole   | bw=27.0GiB/s | bw=23.1GiB/s      | -14.4%      |
| 64k + hole  | bw=27.5GiB/s | bw=23.3GiB/s      | -15.3%      |
| 4k + hole   | bw=4777MiB/s | bw=4640MiB/s      | -2.9%       |


There is a noticeable performance drop when accessing holes, as every 
read triggers a fallback. I will address this in the next version.


