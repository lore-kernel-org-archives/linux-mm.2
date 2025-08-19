Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A6DCA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 00:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEFB66B00B2; Mon, 18 Aug 2025 20:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0E96B00B3; Mon, 18 Aug 2025 20:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40FB6B00B6; Mon, 18 Aug 2025 20:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A99636B00B2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:55:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A5471A01E9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:55:54 +0000 (UTC)
X-FDA: 83791689828.01.BD125DE
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id 825B920005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:55:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755564952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=qOEUW9LYh1VnRQ1Vc6GRkmqAqpFqgoxQ+i+jp40/RGA=;
	b=zawS2AlfCCHo3/5Ue8UZJXAk2iaVuv547TOUaifFs7/PCGq9mYX+L8JpzOEM6cgOdbXkUk
	ie7yoLh4gFg1WOfYHN6BJoK6X/uGtVkIp9LSF8Zz8yJuJBFTV3XHbxS/IkGcNJ+e4c/eiR
	NrpdlA0Hfevjle40k1zzyKbhVRHIKwU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755564952; a=rsa-sha256;
	cv=none;
	b=NfcGMrNPvKSeHDEWjvy7Zwg6t+J+4L2KRz5GwwtP1rh49TDZT56fwW/lcbRkartdpMAl6K
	hS0FcWnfTB0Uo4s9OlhByBZUHt2Orv4UCz5YnJYkNsHvQ5HYnKJcQwY8UcEHtyaOSKCnZb
	HQGacJAoyjBr4glbqwkJx83MuzTBu68=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c5WNG50K0z14MZj;
	Tue, 19 Aug 2025 08:55:42 +0800 (CST)
Received: from dggpemf100010.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id D52681400D4;
	Tue, 19 Aug 2025 08:55:45 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf100010.china.huawei.com (7.185.36.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 08:55:45 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 19 Aug 2025 08:55:45 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: Vernon Yang <vernon2gm@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "ziy@nvidia.com"
	<ziy@nvidia.com>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "npache@redhat.com" <npache@redhat.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "baohua@kernel.org" <baohua@kernel.org>,
	"glider@google.com" <glider@google.com>, "elver@google.com"
	<elver@google.com>, "dvyukov@google.com" <dvyukov@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "osalvador@suse.de"
	<osalvador@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"richardcochran@gmail.com" <richardcochran@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.or"
	<linux-kernel@vger.kernel.or>
Subject: Re: [RFC PATCH 0/7] add mTHP support for wp
Thread-Topic: [RFC PATCH 0/7] add mTHP support for wp
Thread-Index: AdwQo349CifFP6AVSnqbpVCLzlI4Ig==
Date: Tue, 19 Aug 2025 00:55:45 +0000
Message-ID: <cca76935cc9f480d969340c914a44f3b@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 825B920005
X-Stat-Signature: etozinzdm4huxcpytqo4xekkprz5unfo
X-Rspam-User: 
X-HE-Tag: 1755564950-169274
X-HE-Meta: U2FsdGVkX19VSIlCvm9DB9LMz4oZ4cELQiRes26aN+AOdzjaZ4r80c+wnf/PLc4QYi9sG5Su6EbJTrOeooMYsrYNRzqtVNExEvmBx2tl/GoiVPM3J/xIoj6fxEpjfyc2VS11pUdm2ygxjH53QMlIerbGUMLGh7D78ppLYpGZYKO9cXFKFGRk36rd4T7I7K5aFvv3nYoG9cWZaQoydnxJjQbUxwRaArrEHM8imIQjadBvv8sUsq7X4DoT+Gb1CEghKHkWlooGWQNDRa4/iBzstYOV+Nw/kb6QR3sFFn+RJoiVvA+i8idpA/aRMNEmPHCclLxQP5UQL71dg4+YQGulDmoFMgC/Gg8iyUcxNS8rf9quWiwzm0Xe4w5uRseYMLPtNYBuFlDZsMiy8faT9jgzkjJ7wLWb6kSUvxpBjaCSXtK6o0S9I3egQx5X1T2pyhjKdZwFZrvSu2J9U0bnLuBTXOUvtwVyYhZn4QI2+7bt3kYVc1Vs/SC22NqVzqCLWq3Hxn05AV2+LdqeLz+EZduhbEDGNkNdXDltTanooeaVVheKfTX8A+1I4U8U8c4XSfn6q83XHkrKq21bD6wuf0lwDeSxEI3m6z5sn/FfNl8A02pFwDiV+pDY28FNKwmvekfhyMgQROIdEXBJLZf/KnVMclitlSeJ+1JFynCViYjjJDKMQerYOVj0CYG265iurKi5u1qVK672SJoT81zOv+lQCWXpolJr9RoIHVHzX+vsvWnfbxKBl0pVbeb3Xba8ZRFW4uHxbIn5ZnikjcOhuDvnN/YnxWrlUSFBypsQWZKupk2+SsqswirD5gggJJ8tImUNB26DcVfn5jEuYc/Npn1WuC683Bw43B/glwPYv8JOF/p/LLUpiBvCEGbF+0PWjgo9j+ljDOU443xJPTgv6tPRA632QrJBnHAhXiUfURek46+MQunGEh12oUQVI0Mja1PG3GyZ416L7AEijy8MjQo
 1WSk81Nb
 fSyyEeDqTUe/ZevCGFJ2wYZqBuJ13RDVH75TOtU1yD24ReB1YpnytY9nCcEJtbg37kUKgxfqlpj3tWkG7Cj41mo1a9m6o9Sq23p0x35oZs+DlqWbadbqA6t9HmXSZpoDDAOV1Ws6GsaVOQAX4Igm4QZTSMcs6/L1SxXbp25kM/S+nYh1u4vRm61tehO0XWKtI57s4ddRl0XJFs18r8UvnwJvB436veR0T6aTNMeUdQm2CbxyUADxiZmUYV+4SRCww1A91xtatH1zlZ3BHDYmX1JaW3UzvAh9gRloOWPBD+Dlb4Z6JpCCQcUL4b6+mTuR6rEiAispN0EGBhV0qUTebTN+7obAyKF+6IPGEMV21QMDT9azBlZlZHILbt0E2nUWDJWNrTtGkQsmiJgNRKaUW6xv9qZzl2/Rt+H3P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
> Hi all,
>=20
> This patchset is introduced to make pagefault write-protect copy support
> mthp, with this series, pagefault write-protect copy will have a 9-14%
> performance improvement.
>=20
> Currently pagefaults on anonymous pages support mthp [1], and hardware
> features (such as arm64 contpte) can be used to store multiple ptes in on=
e
> TLB entry, reducing the probability of TLB misses. However, when the
> process is forked and the cow is triggered again, the above optimization
> effect is lost, and only 4KB is requested once at a time.
>=20
> Therefore, make pagefault write-protect copy support mthp to maintain the
> optimization effect of TLB and improve the efficiency of cow pagefault.
>=20
> vm-scalability usemem shows a great improvement, test using: usemem -n
> 32 --prealloc --prefault 249062617 (result unit is KB/s, bigger is better=
)
>=20
> |    size     | w/o patch | w/ patch  |  delta  |
> |-------------|-----------|-----------|---------|
> | baseline 4K | 723041.63 | 717643.21 | -0.75%  |
> | mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
> | mthp 32K    | 746060.91 | 836261.83 | +12.09% |
> | mthp 64K    | 747333.18 | 855570.43 | +14.48% |
>=20
> This series is based on Linux v6.16 (038d61fd6422).
>=20
> Thanks,
> Vernon
>=20
> [1] https://lore.kernel.org/all/20231207161211.2374093-1-
> ryan.roberts@arm.com/
>=20
> Vernon Yang (7):
>   mm: memory: replace single-operation with multi-operation in wp
>   mm: memory: add ptep_clear_flush_range function
>   mm: memory: add kmsan_copy_pages_meta function
>   mm: memory: add offset to start copy for copy_user_gigantic_page
>   mm: memory: improve wp_page_copy readability
>   mm: memory: add mTHP support for wp

Oh, we are also doing similar optimizations, but only for the code segment.=
 :)

>   selftests: mm: support wp mTHP collapse testing
>=20
>  include/linux/huge_mm.h                 |   3 +
>  include/linux/kmsan.h                   |  13 +-
>  include/linux/mm.h                      |   8 +
>  include/linux/pgtable.h                 |   3 +
>  mm/hugetlb.c                            |   6 +-
>  mm/kmsan/shadow.c                       |  26 +-
>  mm/memory.c                             | 309 ++++++++++++++++++------
>  mm/pgtable-generic.c                    |  20 ++
>  tools/testing/selftests/mm/khugepaged.c |   5 +-
>  9 files changed, 302 insertions(+), 91 deletions(-)
>=20
> --
> 2.50.1
>=20


