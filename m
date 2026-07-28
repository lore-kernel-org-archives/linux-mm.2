Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CC6C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 08:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0EA06B007B; Tue, 28 Jul 2026 04:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFA96B0088; Tue, 28 Jul 2026 04:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A136B008A; Tue, 28 Jul 2026 04:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61F166B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:57:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDE00802FE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:57:29 +0000 (UTC)
X-FDA: 85037581818.05.E3B861E
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf23.hostedemail.com (Postfix) with ESMTP id A7B7C140011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:57:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6h9ohDYR;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785229047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2E0wmH0tw98SLcgF2VrOb2d3npZ2qjaYNZ4aVITL8K0=;
	b=KOLnKAQUI8lALF4NDqHmOi9KvxWmA+UhZsD5aYXQh2Coo488eFxo3tF6+R2mUQZt3d6OSI
	Tnnq216dXBQzH25ATvSKXDeT1iymTPv8jeH3uwk3gOyDIBQsiYqcCzvznGh1ljf4dblFBQ
	XDJ9UOtmb9+a++lMQTp4MwSCqr0P3vI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6h9ohDYR;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785229047;
	b=NdSipn5r/JzMtPD/I3/GQFsTWxil9CDOgIJDTre3dBDT4b550C+MyolN4TL8S07psCv4xd
	/nyGhWHhD0CUHLkb13SOn+jRpVXbIANQXV8g8LhlbOe0qO7bLj3ydlNb4kAKWxrfjk65ny
	xo0N3VR2tVn6vRpJ6nQ12giwurRAkCo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2E0wmH0tw98SLcgF2VrOb2d3npZ2qjaYNZ4aVITL8K0=;
	b=6h9ohDYRMrUc1iZIqmFylHx8eQ2pzOoLgSdu5w0Q+mz9toUgzOXOB8R3e81a/J2oHXHzRmgIA
	uEO1JwEBJzergX7yD0qLx6sqjHn+HcQfWC+gOTna8W1nsQBWpL5rzwq5mvJjAc61S1Wl4Lq2uGp
	ZCVYWBGG5e03jA2iqyIapM8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h8Tcf43tzz1T4Fq;
	Tue, 28 Jul 2026 16:47:46 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E189202E6;
	Tue, 28 Jul 2026 16:57:15 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Jul 2026 16:57:15 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Jul 2026 16:57:14 +0800
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
To: Andrew Morton <akpm@linux-foundation.org>, Breno Leitao
	<leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
	<shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, "Liam R.
 Howlett" <liam@infradead.org>, <lance.yang@linux.dev>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
Date: Tue, 28 Jul 2026 16:57:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: A7B7C140011
X-Rspamd-Server: rspam01
X-Stat-Signature: uu8ad4qasgzwa9ayn9fcrnbyruidybia
X-HE-Tag: 1785229045-902961
X-HE-Meta: U2FsdGVkX19QdUrNZgC4AzJIEg7vL9t2oXwXjpzxWUqgiYmvU8R+lj6nLQUfNhgm3YOMHB0w1X34IPDFas5Kzolc2ZaI6RfKhZQaHGDXZqqS5Y8/vd5i4/3KGdT9weqIj1W578ZOKQhl4Ln3Wl9tUP5vS4wU0HZmeypFYgukh/K1U4H4IHKXLJbOrzrqYE6Z8/a8Ml+i+/3TkUouZjIOjJeJRPQydEWcYNlZD2M+nZ51QXeijd2ojpdApyLP9Uft8KygEIl27fwkv5vSTe1Vas52CfCqfcR/OtcIFnjUTGPgPV5HxxfTNemZvoSO6d8F3wU9x+qVeOJ9S0GvCIswpv8f+R917hMz29mJYbQ43A/nY+BMYzFMDBFckL8hP2I8Hny4L0PTRH6RLVOz2Vy8rZVeRcVDheVmI1sQHjO50QYYQ+YGAoOSXWS+BPwcey+e1pCqaCev1PFR+lO0t+7quBoLyHHk2BAc79wQA5o5JtrkdXuHg6FQLLTP5F7SSR85DfeNLyq/mK6+wU+oRAEn7zxDFJjPxdVRPfk3oYdff18ISOTXovTSyqBoGYLaXvO3WIss3SH7U+rmV5s+8umksyrhDmrcft0euJE+H4yN4AR15qE75t65jpCWgTgDtSUcDC36qtHZZynx/chrj436Ui8l6DK7jDoTsneRL29vqw72raa9RQt9cW+MyjeMkO2/Q6S00zVr/BZd8JV/FT9c2tj69MNk+9V0ckLTCM0ag0iOx/fXS56y8kOuwIC7N0QIclYGM1GbKd5vb1PmIakqqFzsB6D2OBRcKn1dlNhnJ+6+pxNtjt3GI1Xar4Hyxav/jGH6km27lttropZ+p9N38OjMoGROsXSDZRIbIF2fZMJLYUduJaTwCee3kLCqAyoFPcP90qk9L95DVkpe9X17D3UgSGSzHnoS1e+zGajdkvanSN0vCIhoMs1WHqnpqgrgMK/c3WJ2FddQYKYaRdq
 cLP1atpT
 JQtS8idAkRBasT1HM/c9e/YfKyvEcmlOJSReU+SFYt+/d992Oi6+y9jRFZ/hkDY0nP02xVmYmhzC2nF/uVwgiQRyRkkX+ARZg6pGoov4UlRTcvuxlXzN9S4c8dHkHOUUPn+APzI2OUKVTgTHgyUhPceGIr4RvQT+bluUxkejkSZpqlv+M8cs1be8w5/tVn4lytcJDuXvV5HP57VIv3HkEX4iNKMj5Ghn5WbZbBBAb0DYxJdT5n5Jdy7Th26gqX7RutW1KLu3yy4wa0IGHWkAOxNOAbGmZfo2aaSxjbsNhTncCtKOP8/H2vnaMAHRZyTjxwDOtZaw57KiDY62ZChEWl2KuPDfLreFbZddsZyRRMGMoOKFgOmLjuWrsbYuZGtKWB/A0TDamdl5/PENRfjw7OnloNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/28 12:24, Andrew Morton wrote:
> On Thu, 9 Jul 2026 11:34:05 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
>>> The script is intentionally NOT wired into run_vmtests.sh: every
>>> successful run panics the kernel, which is incompatible with the
>>> sequential "run each category in the same VM" model that
>>> run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
>>> ksft_* wrapper so a default kselftest run does not opt itself into
>>> a panic.  The script is meant to be executed manually inside a
>>> disposable VM (e.g. virtme-ng), one variant per VM boot, and
>>> requires RUN_DESTRUCTIVE=1 in the environment as a safety net.
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>
>> With Mike's comment addressed:
>>
>> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> As I understand it, Breno would prefer not to rewrite the selftest in C
> at this time.  IOW, we stick with the bash version for now and add
> "convert this to C" to the todo list, OK?

Sure. Should I make this change or should we wait until Breno has time to do it?

Thanks.
.

