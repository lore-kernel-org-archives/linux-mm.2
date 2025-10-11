Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5AD4CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286DC8E003F; Sat, 11 Oct 2025 05:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E4C8E0005; Sat, 11 Oct 2025 05:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14EE68E003F; Sat, 11 Oct 2025 05:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1D428E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:24:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F58713B471
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:24:04 +0000 (UTC)
X-FDA: 83985296808.27.C72B75A
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08FA81C000B
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:23:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="5RBkcU/Q";
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760174642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh7NoH74T5YktqTUgVgDG2GLtcrYJJBzP7VQdRxnn28=;
	b=I+EdNU48Cf75hyMmjHu/lEYTVZhXy2xZ9pYk4ul0iTYpR4Vfy5dV5qWPvDa326lMjpQmzd
	PmAtBmLUHJhmQr3OYSMVFeo7CMFVIW5BTpgHusjgUwRqKQa/AMjR5S48HfdtgF/2A0ymdi
	rboyq6zVayQ+yiR5rIh3EPEoH8lcQwc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="5RBkcU/Q";
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760174642; a=rsa-sha256;
	cv=none;
	b=mJsFYMMHfnRuDvM5HpNxF+KUZaqXO0F+klEFy/NHrDmTSRZmhICtqEM8yew6yW2vMH85ic
	AyanvoWr9h5nSFiB+CaOj/q9T66JxT88Hel526yjv+R2TdiB+Irl7WI7Ovy7KtBFXtQsMN
	YrclWZtl9zc3/3rWYJdkzdxMH5CVwO8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Gh7NoH74T5YktqTUgVgDG2GLtcrYJJBzP7VQdRxnn28=;
	b=5RBkcU/QQUx0bJ2KJDufRRDtWJesq8Rq4MlITiAH5edFw0pihUjScgU/O2THm8abM9CYJJqBH
	vq5ps5XWnw3Cf4CxTPpG4laKzdVxPvPithlr1Y7mgdgToorkJi60m7p5GOqE0AP5Icn1ftx7wVd
	tkR+/Gk4waRrUjfbkLLzhq8=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ckJ7F12XmznTVB;
	Sat, 11 Oct 2025 17:23:05 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 7F799140123;
	Sat, 11 Oct 2025 17:23:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 17:23:52 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 17:23:51 +0800
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
To: Lance Yang <lance.yang@linux.dev>
CC: Longlong Xia <xialonglong2025@163.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <wangkefeng.wang@huawei.com>,
	<xu.xin16@zte.com.cn>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	Longlong Xia <xialonglong@kylinos.cn>, <david@redhat.com>
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
Date: Sat, 11 Oct 2025 17:23:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08FA81C000B
X-Stat-Signature: 6u6azdjyhoeina9hcbjyxem76oxyxi1n
X-Rspam-User: 
X-HE-Tag: 1760174639-856640
X-HE-Meta: U2FsdGVkX18ut2x61cDKEyh7KyZ1CsU3Faowvj+J6gODnJDlGu6IDGTeXXuSQ3CAWMoEdBd1f8n26RnfOzPVuF7vODxOmQcVK+7ve8CJ0D7sVJ4LktmxDg2cLyTKd3pEqCBurlU1zNndhW/AMZpz/hWLGoA+8ACocMoh1Jxrmf9U9xRBx8b6IVlSiuw4WRuu+47p3H/8RAs60O2NSW37q57muONr6C255LLVsjzbdB8fXSfaXg/wA0NINPNwbeqh1qOgvUfD7LxSGHyGoZsSk7q3Bnj25NRbM9WTsRrM3sOwUzYziCZ+stK3rO/p/+IqVZBljQQK36NjQcO7Q9rslYJ7+3m39/NSmz+KOmGQakBQQJFiWjPACMtQ/ZsElVYalW1BWg1rlI5UTKnuVzs18vmQx6Iyke/avODBf21rsiwLJoForKM3BSpx17VG2IA6qdnmUgJc5hjBURYEvhD48Rxwq5ODo9cv+cHLDhRtrMKpLzy6qiByG5Lnl6y4Opltk5JUCO3RQRUfOoctpq4DJ6pYyQW6p3G+TBxyEN589fgnb8tq69qCZvYl22vAUDkl4W6eGw9LoDSBwKx0Fc2sWW5li9dLUnH8wWGz5Sbr5usXmWQIJOjE2/TPy04TPdqZp8Kft1RqP5voHy1UduJFUAggHNpPdhW6SVAfOvgCcjJYXfJyz2VrYmWSrfmpZypT/rx2ONOLr7DQ+4srJLfjmCvqRVVp27a/nx17viKqs1eY76/CRiU6BIL4ovQoxNttzKZ7KCmIpFTpleEYwTADyhbAcW+ldTmz8w5bKkuIDEnqmIzDvblac6sgJG1TnNtKxmuaLdnv8bQE4Vl9IFEpz0L23r6C0JMWSup2um8pbPU2agvYEWqAPgeOlZSPQpm4OeRSv6evXUqBb13rE6AlckdswKf04TKS+XPH2NRYplIcLPtU/VsVnoRfQg8XHpgnrOIuCEPWvXiaP+Sd1RS
 ICMmTVtZ
 ikT7+7AXlIDS2V2pVZvPYcPKW71sn89LfJimyqsEOivb6G/6GM6hQTBJjOLSobXVfC/begqN/st8WUvMWR3Y2VImLaCtjwWF9NMB2w911QnSNEDOudqQz4A6ll5sVmyNihX2l/wDLedbDGyUj7JUp5mc5KTcOpPrg7HPui2Q9oPUUEejJ+qVsG3ojjf79jLgbFB/r4SZW5AImLIb+bHDTNl913AjTpxwEXJU7L2I3gOMiU7Qd5ye/sjTJd4GhHeotd08NgjG+tqeNJZ5eGcubgkEsTDh+pOgcHjsVWt8ULxGvf5HomOnNr5nlJM8nxiTKYaJRz52wxwpbbLdp0bmVPnZyDQ29fDYAfh5s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/11 15:52, Lance Yang wrote:
> @Miaohe
> 
> I'd like to raise a concern about a potential hardware failure :)

Thanks for your thought.

> 
> My tests show that if the shared zeropage (or huge zeropage) gets marked
> with HWpoison, the kernel continues to install it for new mappings.
> Surprisingly, it does not kill the accessing process ...

Have you investigated the cause? If user space writes to shared zeropage,
it will trigger COW and a new page will be installed. After that, reading
the newly allocated page won't trigger memory error. In this scene, it does
not kill the accessing process.

> 
> The concern is, once the page is no longer zero-filled due to the hardware
> failure, what will happen? Would this lead to silent data corruption for
> applications that expect to read zeros?

IMHO, once the page is no longer zero-filled due to the hardware failure, later
any read will trigger memory error and memory_failure should handle that.

Thanks.
.

