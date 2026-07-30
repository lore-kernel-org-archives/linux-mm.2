Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2694C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9756B008C; Thu, 30 Jul 2026 04:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA336B0092; Thu, 30 Jul 2026 04:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF9F6B0093; Thu, 30 Jul 2026 04:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC166B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:58:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B03FE140942
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:58:03 +0000 (UTC)
X-FDA: 85044840846.25.B46FBAB
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62AE3140004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:57:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4ezA0bOW;
	spf=pass (imf26.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785401881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rMtCmYRE4yKFhMmgCu1LbAu5IZOmFSXihnF1nAJiuc=;
	b=uf2FvvRWFxl1LVPBbzhGgRMXdS+EYvYvS+yDCQHs1oLQ0Cf6EY1h2B67WhgQyPZ5aAwtvh
	X6L+8Pbl3hcZHFFOOvGQFaytjUCag2H4G/RW+HNsn1ejLeUM1FMCov9vx3rx2rvMvYYaQC
	NwgrMXK9x1tk20JQ32m490l39jL+zwQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785401881;
	b=8lvRzpbUkVxe0JRNosWmDf/uClxrBHlEhyXLPgBZvs1TgdvDt2QFiW5pMp5aRTFwNtaWNZ
	03ytloWtdkw+dHRKziq6kfwenOzJAvwMQvJE6rSPKYgshzaChU1p/o/CVWUmheLMeU9hxT
	H02e7nlsaKZV6boPFtlrxnvuuyyzQuk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4ezA0bOW;
	spf=pass (imf26.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9rMtCmYRE4yKFhMmgCu1LbAu5IZOmFSXihnF1nAJiuc=;
	b=4ezA0bOWlGuGwTq+3v9Z7hX1eqJhwpRJMbaNvFi9IGnDLWb89LKHYCjqb3hyGTuRqIs7Ooo3F
	q4Ym9hLwdd6ft2eGYmRwnmZbkw+LYQS/bi9qPiW0QCWbOvDfO0W3ZqI7aJNwlXQZngsUOYsCZYy
	2ISns1h1IVv7cItxAga9gV8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h9jXS1DXmznTVd;
	Thu, 30 Jul 2026 16:48:24 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E16114055B;
	Thu, 30 Jul 2026 16:57:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 16:57:50 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 16:57:49 +0800
Subject: Re: [PATCH v7 03/13] hugetlb: Mark some function arguments as const
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>, "Gregory
 Price" <gourry@gourry.net>, Andrew Morton <akpm@linux-foundation.org>, "Jane
 Chu" <jane.chu@oracle.com>, <linux-mm@kvack.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-4-willy@infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <28f41c7d-a869-4495-f2b8-822d8435ac2c@huawei.com>
Date: Thu, 30 Jul 2026 16:57:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260728204409.3396238-4-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62AE3140004
X-Stat-Signature: dxqr3tqx97o8o41mt34u3z1aia5oy6so
X-Rspam-User: 
X-HE-Tag: 1785401879-983594
X-HE-Meta: U2FsdGVkX1/hBVUxNZdQXxGEPtGpOoH9aZBmJTlW9pvi5pxWleDf0zSptSwKGYMIjr2svYB6Z+9v8m+KBnS5FOoEIFIEaBhgCciNg4+S2/8OjD1k2Ru/2CRmrexrjAJd0YG3HGPlHYN3d4sy+1YyQpRsBOKGTtFPDMicSRaM4+wNx+V2FmoYcoi+Q4wXX+o0kKE7rfJcEPS03asnkJgY2Rt6Hh65xBTqJDuN6QuZUTFQ+YcYmP0SMNv0Ikzra7l1XUZYYO4azcswOm7LBkvV1yf0h6LhEDasGq78pf5/XVdAEDnRMuP4lSYSXq+N0SMWZ6hEmoOIdmZLdW4tz9eXAA4NyD9fs0TXQuVLiMt2dRFOoKpHef/gcmmH4S6a28QZu2USBfsSezjePrI10BxnT2IwiARGFZhQFox4AgeQnGD3qmcMGF/bchCG6tFuB0rJgEZM0ZjQUGnQNrqxohIKKaee2QZt1ZckSkrvn+IkbfVAE+5TTi1jNMkpy9MCBFhlFzEyAOw+xg3dHybmVYD/qU3cU9G7y0UgahYjhNGbI3VdzKNR/Kt9ts0nLEmrXFAqsZn+d+jPFxCx/1vJnb6mr2A0yLOkGOR1wTmqMmdvLkjVXahy2SKfeSRZaZyM7xRgzTBqv0ZryMx5VwR6ehyOTUjaWDGXwMG0z+pWRHcE0Ild5UvnsY/2Jf/SXgbmMWU6yvMw03UPYEFv/MJC7kmiCqsyU3tirT7xqnRuWZT7SFTuQBLSdNdWE8mivysTRaGUXgLvCYIlm7bnXpGmnP/k1JPt6h9xhcaFttPpI9mEO4ima8EGekUX3D+whF1Ktkm2czCcujKAlmkZKoUrSBQKvo2sDgJz1su3ieaDWEM9NT5XdaAl/1rtKpzOH2B4Z/ENRv9+LHuD/AQ0ueByWZ6Fx+n3V/2lNgC08+eIc0aYNMHR2l8U9MLz+9sTD8nePJnAohVk8eo1as7ZVM0OC6a
 /Fq5xUsx
 +RBMEA0jggcO4KMVlD9hsVPBtJELzKWXOy8i0aliSPbC0ezdvt2omBgDuFvfSIXLqQCgm/ptpU/zGR9P3mPA3gt4XCGRQHlypXg/c9LwX2fiwqIaCTV1zuzu0FTyj/CZijzG/YybflVvSFsFUTlQkeLtKOnku4d7inpcRMhBq4PO2yUKlFP2qMRRtIj9g8UnLf05GmXFHgQqOeVa1QK9UPl67XhOFbrCi8kRkBBvao+7ldde5ICgTudorVQjmurzrmsVo8Fhw2aaze+GGn2H0UaFvU9CtpYGHN3fH4Kf3yMVSXOU3CfMmjv9wHEbFPfQairYkXOzpXwg1SqTbdN0mkE4QTKVboUGR0D6rZtgsDkYW/0r00bYbv3oKATPnC4kEjQ5QE69tyaJ1aEQusF0iIgwuvkYy20yUJlyAo4ALoKqBct1png3usdaRoL1WQnpvIYSKvXdrds28IeIaKyC/NLIPtd3ydviPHfJ5AOpsWv9PfiOYO+ynpzpkaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/29 4:43, Matthew Wilcox (Oracle) wrote:
> These functions do not modify their folio argument, so we can mark them
> as being const which will allow for some minor optimisations and let us
> mark other function arguments as being const in the future.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

