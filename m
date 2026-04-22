Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52499F94CBB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 02:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC36E6B0088; Tue, 21 Apr 2026 22:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E2D6B0089; Tue, 21 Apr 2026 22:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7BB6B008A; Tue, 21 Apr 2026 22:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2BD6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:50:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66C30E65F1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:50:58 +0000 (UTC)
X-FDA: 84684664596.11.B2673FA
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0B9F81A0003
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:50:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="cPd7jLi/";
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776826256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYYrLeSCtlIwWe1v/taaHs6p4N+WULPdk6AZYoEa9eY=;
	b=LvhlJsIu2jvcBcttBLhwiTy8Dnfu12Jp7ZePvsG7Fiqjp8DcDjBUxXR4/QrEgszT74QP/w
	oTmWjER0Rk57oeCTRKX49CAIN6zRq2sOffRjE4SUAAhXRW/vb2QDpxRYZckyO79truB2yt
	qxlXoyD9Wwclb1qGwyXsdfGwedlsHPY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="cPd7jLi/";
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776826256; a=rsa-sha256;
	cv=none;
	b=pAfkIS5XSUvikAwW+qpy7m85uCGnRaZKPlGzPivABUy1kWT6WBp3IAEjSicrv0p5X/tJBZ
	l3kCl4iUwB+RCgUnq3MJDbZImgp5KvR3hX6LuLeP0wWbiBO20P/huZyLBb0XVXwfwpRJrS
	I+SrGbZVKR0KJdVgTWbn9BnONFbM7WE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zYYrLeSCtlIwWe1v/taaHs6p4N+WULPdk6AZYoEa9eY=;
	b=cPd7jLi/JI+BNpF2FcOInnMUj1bgR/zf+GCcJWH44tkf6D+2aN1oVmPTMGYR405U4jIbech9J
	vH4GSa+JpRx6QadZ0YXtyQpGzeolZ8NYvyrvI8MrkJpI2rTJpeH5R2Qd8yMUpxf6E1tvXlhASWd
	U4JChYSShKYEgYYZWPmqogg=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4g0k8F1cwHzRhQx;
	Wed, 22 Apr 2026 10:44:29 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id A358C40573;
	Wed, 22 Apr 2026 10:50:51 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 10:50:40 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 10:50:39 +0800
Subject: Re: [PATCH v4 1/3] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-1-2d0277f8f601@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b4be1fc4-d793-cac8-7de1-dfe279c8ff8f@huawei.com>
Date: Wed, 22 Apr 2026 10:50:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260415-ecc_panic-v4-1-2d0277f8f601@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B9F81A0003
X-Stat-Signature: 9tf71ybtkt98zdfsqx3j8kpwa1j66y9s
X-Rspam-User: 
X-HE-Tag: 1776826255-147061
X-HE-Meta: U2FsdGVkX1+8OEV0pEnv132B+CU+GxdvGi7OAPzdXT5JMx9sqdOECrPqSm75F731fyFEXY1uQufqtKAvlPRxupZxmYmS+ghNw9UW/DLAaPBcrVNS8W+tDk6MqY7LXVVb/nz5C3aJ0y1Kv33v8zkEoC46ppxNw7/dv3GawD8Vr4u0NjnFRp6cAyvdU578f/s7GGVjsW24zDiQH+rnMPSLtg+Lokq51QyoomnKvRO1v1byLd4EceJe/gMFsRGh2jTLdgggJJgsKdHGFWlvgS23qPYmq832UZ0BBAfkcJg0bTpFPsb3QUvyko7J4KdX6kCL6aXgVVh4ARBm+GGseJMZIWuwxfbN4C9btkzR8jkzploQkD8ydyXTj5+vq7oA7qJUnwprLhnqaCTitKV43/tYX3Pid4ESD5ZSPy57vY8ifVsmexe2rUcxzUTlsZq+lgqql2laIR3+2V8khaShWpd3aHfiIdoWNhUdpkxFmQ8tOO5zhKgpyFC1Zasp6ny4aD7nyl++8zbJ5hhO+ODILgw9dLicbIIpSw4DoGpNVzEZFXW6ejur/WlU4++haCe8UyFBplm3cOEMIcp+9aEeMDoHjkB0Oe/tWkoXm9LzwwDtZUXLMagbOe211Kp4mqwA5ad3bw701+tysyVlbtnpNO7+SMGPW/Zqqra19B4XicIC2K+wAlkCGai5CttTDICVHs1NbQFlOFUnlLZCfD3y8jwOLJLpGslYL6XtFmu4xJgIUP6cYwQdr1yw8PSffe4f6gE1iZFwBQMsPlPbqjG7+TY5Owai1i7zmFYNJuKX3tIIdeo8RZCAAFQWxvIvd06arR/bQ/Ecoqs/35i8BYWQY04Eq7ti7yvTovl8uvi3FNFqS80vPsnnKE9jEkuJnv/Psow01CTdQAXFSbD0tlh6lf7YdPUGTmQHXNqKlEjd6gEdSdyotPMI5gESJ0RYTqes3jSAPVnGIrxdGg3sujqHjUx
 uKq1HyiP
 62uaCfy5JvXDbsn2YkIh4r0EA1MjbZLCgKplwUHFOTXaTc56MtXB8RCVhr/iTYP56Yu53Aq7Qq51b/qxZJ3L1rLstdTlVdUjOrnIq72KUpdTJ2NNPuPa5nhnsBwcW8Toc+bqMD8BCawCY/w5ZXLJ/mnnZfvo+xhOwiHExwVT7Oihq12Ox46ZFyJX6VkA7812O8M/BXVZjThygvXAYkByOluDPDpIuID2lL7rpNBkgjG13TFhLC0NYV5X5S04arrMkBgKHM20m0kPnO2/3s71sJ91PuD002uJnrSVrlePsWyHyD+CuneuRujHq2evjLBkFvezDlNRHgcz61B/oyjDe/1AMxhM7DwqbGC256/eN9d3RH0XKAaYfkmO+c+jQdE2WrOxrw4Teez6OLvVVaQ+sNWIyEOqfKQ4eooYDJwjyCrM8GOLGHdpB7CtJgaUkCrZLE2H9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/15 20:55, Breno Leitao wrote:
> When get_hwpoison_page() returns a negative value, distinguish
> reserved pages from other failure cases by reporting MF_MSG_KERNEL
> instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
> and should be classified accordingly for proper handling.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

