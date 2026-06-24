Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4CCCDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 06:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F8E6B0088; Wed, 24 Jun 2026 02:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD05C6B008A; Wed, 24 Jun 2026 02:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E156B008C; Wed, 24 Jun 2026 02:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8736B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:28:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1371A1C5439
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:28:01 +0000 (UTC)
X-FDA: 84913825962.23.EE1C9B6
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3EB06C0002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:27:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="3/XqOd78";
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782282479;
	b=mAKJyS9qsWLu7lbxd/05gqP+ShbQg20mNCBYyIaykt3+B6vx1/AR454KtaJBqLMsU6Tnp5
	kZpFXQoZ0lGLuu1+RxZcTt/gohsVDelW/CrqRB+MIdfLrSf0qXGaXkLKi6etTxPQq/l6Le
	1CoZkZ6JsYaIzhZZoq7Q5MSKEUrMqnQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782282479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIQMxi+VmNpqEYVSNXBtfgzCwL1hzxwmRPCxW01i5vw=;
	b=2KTACalCiINAYVBf+B4f6E3fnlrGJ2us+7SmzJw1S8b5WO2tYYBPKUrWGTioaWA6qQxBlX
	tfbmK2OcnXUhzUUJOYhCxZ4huReKd42Fq5yjoGmtWaZuAy0ff5vkG5/wmqHjNUXCWD5llN
	VpRucWxjix0zNpPFVDCsNMpExz6z/Ck=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="3/XqOd78";
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XIQMxi+VmNpqEYVSNXBtfgzCwL1hzxwmRPCxW01i5vw=;
	b=3/XqOd78KQkFXPSCYb8U3UQnA1Oax63SaGYRK6uId5wnqwFUn3qeWMhPA/1FJpoly9cE7WzPb
	dOGMg+bH5TZb5fb53obTGURGa3sekzOFfhBLZd0vK/RzDdnBAGf6B5STdECnkkdeRtgTVQkOM8l
	c9oqJQh6wwA/29G+XvMgjF0=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4glWwL2NHHzKm5S;
	Wed, 24 Jun 2026 14:18:42 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 1DE324056C;
	Wed, 24 Jun 2026 14:27:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 24 Jun 2026 14:27:49 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 24 Jun 2026 14:27:49 +0800
Subject: Re: [PATCH 2/2] mm/memory-failure: remove redundant initialization
 for hw_memory_failure
To: Igor Putko <igorpetindev@gmail.com>
CC: <akpm@linux-foundation.org>, <kasan-dev@googlegroups.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<ryabinin.a.a@gmail.com>, <glider@google.com>, <andreyknvl@gmail.com>,
	<dvyukov@google.com>, <vincenzo.frascino@arm.com>, <nao.horiguchi@gmail.com>
References: <20260623114743.4565-1-igorpetindev@gmail.com>
 <20260623114743.4565-3-igorpetindev@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <aed29a0b-9be5-4c38-f6f8-ec0986238aa3@huawei.com>
Date: Wed, 24 Jun 2026 14:27:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260623114743.4565-3-igorpetindev@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3EB06C0002
X-Stat-Signature: swgwr5wt6fgigp9qkgcok1okyg3eh3h7
X-HE-Tag: 1782282477-721875
X-HE-Meta: U2FsdGVkX19zUyms7boFXSLWw4JtajbhnoJl7znJJJY2pqgecE5TO71UbuGVGjE0oZUXdO0DcGAWbFFUVj7/hIdQnMDQmd3+b1opqbg+Jq8fcjPgzMR/gC4j4fsec/1c9pQu72Uy2SsjHsleVzIYjtP0zTpmFx33S/Mi6zjJUyBVUmz6om7TSwoKhGedRSV8/3e5GaDoyigixMklWz5lv038JHfgdmjA/REpphgB3t0bo6LH2MLltrOrkCyj420mPGZmaJ+0da+2xhUhrrlX8GJP6X2uhNQtFLTc7THew+rumlUJ3l7O5IynMHT0G44Hp01tezYz55C9c4AZxU4DLxRGH2RW571fO/5Ct9dVlqHGebOQ+TmZ0aDI55+w6Ceg8ncCnJnOUSZ0+e1uBOCF9AsMYsO/7rpuGeJoqdycld7b9x6SHwl99Jz5PNHzVaqrdvsxedm5FFWq9M/jD67RZJpgO8JveleQuqg+hbXA3qAqtOyQkUEfjCLjaSw6moCTFBR25F5QQNTruZRSZ9jAqjr3TGO06vKbRmfp9/bQMry7hO0NvPJy2f9TLliv6swm5MzOFXYUqsvuNReKqexIFl5UGwlwFNIjvuV9Y0AiA0Vxb2OTUOfmWtakhWAuA9r2WUvlkhy3EqgVNUFEZ0VJS341rJX0aWTljpSgD7Xn4m3+3FufLG62O8sLzbqHxHCkG6ozse3NuDD1Wf3Eqr6v9pvxUkqjW/jaFLzu+5naHOv9k+qg+jI5oPGs6OAnve13KaDf0W/c0v7H97J/6WpQJGhxOsD1WT1wjLb4SpSDsZm3+NOKA+wkYN0bByNt+DLZ6lkThpqyYMucMY/O4/P5V/tOtleUQXCpBXza5ijFiYIqJEKqRh/dIdWo3H+db8Q89zdcYm1RGDyidYkw3PYGFcbEl+Bg02qEuDiw/PGfuSl53sXzh0xRNW9m0cW1bEDiEs1qt2txi/BIrybwRxK
 d+s98dkh
 AR9uKn8eUCfIw8D2Rs61Z/oDY8MFDdN4oBhEaJupUfjHdBxmv7OxjPX6boW6laJNIpRBP/X8a3ZmvVwWrlJN1I9ozuDNSA3tmi2g1JXXifbyF70afqDdTYSdxCia+RiRN2ORRmKClPHxcoSkJ6rhHRvMgjTGWGiH4+ur4P0fmqXwNULzigkCPJtX42dSypIqS2Q2coHkcTAA84g10d0d4sVS1KJMX7iu63FMu/6niTEmF0ATmlEyI8e0TDZr4IsbZa+ACKReB+oty38Dnw78IRt4n8qBf28WT5q4p5Ntszyq4zqmK/6gHIh4aA+BIBEXbkSxu45nI66nwsP37Gih5gV7fmDjv+Dlb+TgJeS6ylO8xEI1wZD0Rm09Urd7Fy/MjVURJ0mtcS71gejQShoN7oj+4uObq4Tk68XjMVxstSD18kwk2uk4iQnnMyb3GmMm+DJTr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/23 19:47, Igor Putko wrote:
> The static variable 'hw_memory_failure' is implicitly initialized
> to false. Remove the explicit initialization to follow the Linux
> kernel coding style.
> 
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


