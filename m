Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E28CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF3C6B00B0; Tue, 16 Jun 2026 23:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531636B00B1; Tue, 16 Jun 2026 23:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F90B6B00B2; Tue, 16 Jun 2026 23:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158C66B00B0
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:24:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F107402EA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:24:17 +0000 (UTC)
X-FDA: 84887961354.16.AD1C9C9
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf12.hostedemail.com (Postfix) with ESMTP id 003C240002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:24:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LA1KyDtw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781666655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXpgPLCGZMBAJlhoq6iPX1R1MqV1uv8ilwrrn60/bL8=;
	b=g9Je1/HCU3nM31a/g/26nE5AqaOMTwZqd8TJHNUE/91L2fPSSgTuufPEnMGICtlWm3GWXU
	Dx4CMa1QoqrVJj06ojo2grMcOwCW0pTy1FlkqqE1mvOzIUntb/ZmGjqPyoOqrsgRtXNIDi
	HQdnnx9HwRXoSAwmZ6eXym4R7LoDuGU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LA1KyDtw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781666655;
	b=8HfMIr4pTUU4QHttKKRKKfMiXSAwNb9KGgJD8K31BQ4fQ1+QyYVpnGcwkB2Ao7+WOz66sI
	U/J1NMbxCULnsNSZUlJozKY+HhKgphD9vMSefls7SOBbGBn+GyAEmMAX8yBewxk45RF7Zo
	JuX+gMUjqlj2hLIyMMdSUDhcWsVnMsY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QXpgPLCGZMBAJlhoq6iPX1R1MqV1uv8ilwrrn60/bL8=;
	b=LA1KyDtw3R5x/rV5uAch8d0C04aDQivZ2h4t1Hz9AeLUdzfsQ+ExwOqkzGgnQ2szCDpcKv1LU
	DBdB63k7PKs9cNMqouWifcVcbcvgUQT9VlOS5cZyNVZZdOqeMTT2Q3caCqQSiuweoiKs+LsxSJ7
	bErq0V0cGYCOCWzDBPb4hb0=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gg8By2QM6zKmTb;
	Wed, 17 Jun 2026 11:16:10 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 320BD405D1;
	Wed, 17 Jun 2026 11:24:11 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 11:24:11 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 11:24:09 +0800
Subject: Re: [PATCH v4 5/7] mm: selftests: Add shmem into memory failure test
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-5-a5bc7db5a9b2@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <c5758613-38b0-fb9a-81ec-0ef709c786ec@huawei.com>
Date: Wed, 17 Jun 2026 11:24:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-5-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 003C240002
X-Stat-Signature: fx6zf1szuf7h31cguoajpf1iacnu3odj
X-Rspam-User: 
X-HE-Tag: 1781666654-378192
X-HE-Meta: U2FsdGVkX18rSvZrRR/IBUoVYw1fI7UYyMNr+l0W/Qt0T+sLxke7luC/nZHtB/zGuUgz8D0uA2vgrKqEjqKrGfbiNqszgt5Fl7aSKWG/IFN38cPrX4ATgzhcdcBsHqcr5VeEPxute5usRWqAjrjssxLQVlwfa6d6fCskj3lLbczqKYu8JwcyX/R5VKqBvSWtbtuMrkSE6GF5f1+yyzeF+svK8W/6OknC1e+rMwClkknag84ZNxHuBy9b0HgI37+0K1O22J2/S8u8FrYeWsWxw7YTnz4uIpr4ik4oz/xOKxmg7DyhqpvksN+v1XcgjlQA4kAFTXqXdUxoRmmluTS4jjwndscKiOKMro/FaShzYEWVaJpY00AGwxreS88SuuuJArM2Mp/8vtUGGIb6j2U3xuM1/jNtScUnQvcY6zEPAd0zc36+4wFSK9m8EdrxaA7dFcz4Hxs2D4yakg/U8gkKzgk2JLjWL8lz/gAzahYFDCCT8AriyDWi7eV3v8krXlgO8CJwwuScJJXKUBh/uIL9W+irWSQpzH3rxqNHWFgxsFb0KE6V00EKHkF8vlxLshzw7uVcyoKZhARYrfvVIG4E3Gwv0rOt1ov/E7EGRZPLm/XJ5YRNgj3lxnxlfm4Em91MU62mU8agCyvxH/78EBne0kP6MTce8T6KOcA9N5hoGCtTGw/PrpDYnu2mqs0M60OTLTsz49e8WKg2FUVx7zSDT3h9Fd4GmZewBpvZe8lHTNxpg2AwHYMGhQblANRwAAaKRW/uQfDJpGeWLxVlUXziTY0XGYMtcywgV8A4gGWkGfLsmiL4RSCjIJuh+B/vZg3YkhrQAtgiYK8Xcv6qoplylhOHyZfYW5Qm/19q53JkuALFpAcu0sOBPJ7f8aEAhJhrktwb8MpyMSZFc+3d6aVA5JnOW22Qkr/pE2xW17/fzrL1zW+mCdqKI6j3Hx+4Y90VbO91d4D3s5Y3NqeJiC/
 u3MP/5Sc
 ZQVVn6xcQ9qwU7uP+kdKwr4ro3ToR1HLt4NYyWk3Ek9qQg+9Wm0lg5iujRwHPnkncH5nj0Hgq74jwzi7MClsPFG+rBRG+4Hzr8FM4jvHZlhOv4TEFxDUMHECXgzZ3HDuQzEaKWCJ61nmMAkiqgNU0cqI5Wa3Hj8GfJFVsYmZ4ZbZgNhqSMQkAOvYZbtJTfzNV4E+hmPPBh+EQnXWK/0OOuiH1bUE+zWRxhkn7Ur/kgK5QyWDuK1gnZ5SAc/EJzAHsKdvHAatZmygNEt2TE5Muhx2/HTnUwwYIeX5mV2rta1J+vXU8Jo1LZxo1DVPpMFpSUsfPHh18TyP8UKdnoImuP571exPw7qcgthCpgOv75RUWHD2f9L9ehlsqWHuRTlIHyE240TiYNrOgpxLe44aypOccUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/3 5:55, Lisa Wang wrote:
> Add a shmem memory failure selftest to test the shmem memory failure is
> correct after modifying shmem return value.
> 
> Specifically, test the expected behavior under various scenarios
> combining page dirtiness (dirty vs clean) and failure types (hard vs
> soft):
> + Dirty + Hard: Trigger a SIGBUS on injection, and trigger another
>   SIGBUS when reading the page again.
> + Dirty + Soft: No SIGBUS is triggered, and the original value can be
>   read successfully.
> + Clean + Hard: No SIGBUS is triggered on injection, but trigger a
>   SIGBUS when trying to read the page again.
> + Clean + Soft: No SIGBUS is triggered, and the page can be read
>   successfully.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>

With David's comment addressed:

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

