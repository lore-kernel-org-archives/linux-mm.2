Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E653CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C4C8E01C3; Thu, 30 Oct 2025 08:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843A78E007D; Thu, 30 Oct 2025 08:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7805F8E01C3; Thu, 30 Oct 2025 08:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 692CB8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:16:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1430912B7FD
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:16:08 +0000 (UTC)
X-FDA: 84054677616.23.3E6FB26
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 96DF51C001A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:16:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ctW0uKYu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761826566; a=rsa-sha256;
	cv=none;
	b=CYEtnscaju1kRJY7Flu4VEj2eyYxdGaK/Qk9krsCLqlC7z3yeLLTjOEnxq7U5KSQ59b96h
	OlvUIeawdH3FLyYxp1GB7lOw+R7YXAS2fVkHVGspnSpSc41GFPrG/crMcXqh7Ckn8YpsAv
	MRFNH0ANIP8q0CaasV9WHR+H4qjGyZY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ctW0uKYu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761826566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+Vx3YdOyQTAap4dvbQCFkBJA4MCaz3tkdmY5eMqs/s=;
	b=QicwyT/p2lPcND1rva2/IL0BMuMTHzg/rYxQaiQxsReQVa+7qlklzyxVAA9o3orqx+HZ4q
	3c8qmdd+HBCC1GCXyTV0ifoc25bQkLKkuX6rR4iLBOxvIRwrVkzSCOgCV8wvFnDp2EUfZs
	XrPthH8inMrTbuSIdbpyv0NAAe8d010=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=d+Vx3YdOyQTAap4dvbQCFkBJA4MCaz3tkdmY5eMqs/s=;
	b=ctW0uKYuEuqNTH08N25rcLPgjFdJdMsoFJvYYo0HhwMP8I1f7fEbBU6t6ajFd3ShcW6FG4YJa
	cBDMN4cbf6SKbwlzuEVgw0peCcGnxfxGxQxhy6go8XXJwoU2RiuGYkRjfDuaRI3w1XtTV6QhQ0U
	M/kjoMtnJ7vQpce2ZNeiXlc=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cy32G5kMbzcZyk;
	Thu, 30 Oct 2025 20:14:30 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AD703140144;
	Thu, 30 Oct 2025 20:15:56 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 20:15:56 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 20:15:55 +0800
Subject: Re: [PATCH v4 2/3] mm/memory-failure: improve large block size folio
 handling.
To: Zi Yan <ziy@nvidia.com>
CC: <kernel@pankajraghav.com>, <akpm@linux-foundation.org>,
	<mcgrof@kernel.org>, <nao.horiguchi@gmail.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, "Yang
 Shi" <shy828301@gmail.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <david@redhat.com>,
	<jane.chu@oracle.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-3-ziy@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <68910328-ba58-0554-c961-6a4087c72354@huawei.com>
Date: Thu, 30 Oct 2025 20:15:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251030014020.475659-3-ziy@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: zotftjxwisyg5rch8n3h4um3a4ri67gs
X-Rspamd-Queue-Id: 96DF51C001A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761826564-295040
X-HE-Meta: U2FsdGVkX19cjoZqiybJHzp+KVFGIReeUuwWh285YKoXQFgcfrmF2Jb0zds9xpfvydcuVGXesC2unexge6OBcDbgjdSDH7+fJLuW6QAtAVSGtbM2Ys3tH+zjhVdlC0HmzAo34yvSnwSNhwO/YD/I32+zGTDCV+Xdlv204PZCm49zEKWucKZ408HnvYkkcqnbzl+RA071zbKnXSAL10I+zCN6OYoNcXSP8Oj/Jd0PSq0YpMKr6k5ilpX1GAH+VG+Gb3vkX8MpF8kbcGrbRrMJ87i8ptk15gRgpn1Mm+a0OsYsN9qiafYbxBYCggFfvK/+BLkHF9+wUHw/DMQclb5H1MGwe0bLdo2awXiGL6myql6nsv4W15RcIvURizBKvlYc55+Nt1ksuQieddKhituv/jPBrSKj13z20pXX9Eux6POtesdW1aIExIoNtp17GkL6AJ91DVl5jBR0istzaHSZZtOEfgedk/hHkf3j3kJAo3k1+4oQHvLZiaugvFvHlf1sTYHKDJtqI+PL1AmLmbxp7ThOBhoDDahY7X9413LsS3xprIaQN4aLw/FHrDfasqIghnQex/7kSr9tVCnaE1L68auBQ386C3WJQ9s+bNmzykZQnG++HReDzmZwIpaW1FP3xDhoamBkN83kT/3FvbD9MlbZq8HJXEPWoAyAID2Fl0NbgogUDzWthR8zY6GGL4oDYzYiU0JctNBAWV7sLhhVqudFuELS53Iwt1+gmjwaLcSpkUX5PFPIzUxjxj+BBNJC68mTJ0rfZrIrJS7+1rXytK66atHWG3997P+MBRX2+kJO3O5ME08VbgKWx8yQ7yb7K/60yN+OmLAUXEv38nYxPZRFreaqaZ/g81n8HxaZuyVpUGemzoy+Fs6/bhZjrMmLmRbab5HsVm9WXh3bZDoo5rqhG/yfdBfcxKTm+DdQyjrMr3lhBu67ESQ14cpHS7M2+O581co3JJM8fto58cZ
 j22AkmL1
 o1weqr+IxRTdF1FFq0LxrJbi6/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/30 9:40, Zi Yan wrote:
> Large block size (LBS) folios cannot be split to order-0 folios but
> min_order_for_folio(). Current split fails directly, but that is not
> optimal. Split the folio to min_order_for_folio(), so that, after split,
> only the folio containing the poisoned page becomes unusable instead.
> 
> For soft offline, do not split the large folio if its min_order_for_folio()
> is not 0. Since the folio is still accessible from userspace and premature
> split might lead to potential performance loss.
> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


