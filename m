Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED55D19511
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 01:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED26D6B0088; Mon, 26 Jan 2026 20:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B656B0089; Mon, 26 Jan 2026 20:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62386B008A; Mon, 26 Jan 2026 20:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C34C86B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:12:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70E7ABC2A0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:12:51 +0000 (UTC)
X-FDA: 84375969342.15.9F41E5F
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4103DC000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:12:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=q9fMesqp;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769476369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9z4BMQamy2eIcsA1RCpI0lsFpa8w7wurJv4MoKUiqgg=;
	b=Z+xQEWeZY8W8oY5T0vjGpVFlRrWu4c0XLNkxw7z1T3TuiNQFMLgNncXOTkEvdMzGBunO3B
	XR21Mm36BwN17e26+fQU6rxGQDL2hNwR2HyYfPAc1ldJMVEe6i/nVqMDIYuKEQYg5vLcON
	9XXsIAqPwhTE/v6bFv+Ethe8PPXLu0g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=q9fMesqp;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769476369; a=rsa-sha256;
	cv=none;
	b=Q/drs/S/cN+vYE6jRprYMZcrdie5JJU4t9DxD5LrS8cK5D1gqJdU4QanW4ibkud1kITR/F
	S/qTMxC5GUuZrx0pIn4uBQI5KoFxfVL17vy18gb6eueyI20c3E579OzFlzJuenTR40a74E
	7qiZ0eaKTVNShVglnOuWYVQGm6BwBIM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9z4BMQamy2eIcsA1RCpI0lsFpa8w7wurJv4MoKUiqgg=;
	b=q9fMesqp5S+jlrRGLjwZpMrhDBRagd/VuG1qurXqHkIsdyD1EsZSczXeo+8orQu516MTy7DQ+
	lYcruWuZWu0KPnOPmarujf3Nwapxe1fAgpb1Q43S7d7L00WPgEeEjx3VD3YWuqzFW783yLAGkfp
	60+HTkdT97OYwi7Qot7k4G8=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4f0S3Z5JFPz1prL2;
	Tue, 27 Jan 2026 09:09:14 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C7C3640539;
	Tue, 27 Jan 2026 09:12:43 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 27 Jan 2026 09:12:42 +0800
Message-ID: <496fe218-dca3-477b-89f4-0f71adb155f6@huawei.com>
Date: Tue, 27 Jan 2026 09:12:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
To: Andrew Morton <akpm@linux-foundation.org>, Shardul B
	<shardul.b@mpiricsoftware.com>
CC: <willy@infradead.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dev.jain@arm.com>, <david@kernel.org>, <janak@mpiricsoftware.com>,
	<shardulsb08@gmail.com>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
 <b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
 <19bf8d68cdb.ae2c0d37126486.8380742359510867201@mpiricsoftware.com>
 <20260126120451.0c28a6deb3ab532dfae40a24@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260126120451.0c28a6deb3ab532dfae40a24@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4103DC000A
X-Stat-Signature: ujpkfj59xkiz6dxcwjdkodbp8sewf55w
X-Rspam-User: 
X-HE-Tag: 1769476367-978488
X-HE-Meta: U2FsdGVkX1//12Tb+zoBIcw7ANjHfYnDhuu9h5XLQdTwuFegFDUulHfvjZ7muq0YzkL0oeZk7TUnx5TMO1+9h2nG1qFwLtpzP/8V2v7NG/I5HbPM4x3SKbrVzrrNxcY+cVx9OU3OvMTrlHUAVakpXKjkVgC+wTYr/LR9zU7IMYpJa/inWBIZ++sUOFtHDHjhcg3gJbs0qDXX+M6rhIIAZ0rZ41sJL6TOZz4cHXTdxwQXc6kGzGKl0+U81gfcW2WgLSQtmKehAYsgR9R9zGugjwk9YalpVKtBpmUlQgszDJeC3A+IcHRyB7xEJGha2PoLlyQMicHXf1KteY4sm4oz9Y4QvOuKwqS4qnEBlWZiKqqXSgUYKyzDFZYjgBluQH7SbklnW00Qw8L0QPJdmgQ3GeJP3KczZUQHGLdo29RHFeg7HCxMVltmlk1v7AfwsSnrsV7YpIZWCy61w3gJPAWOObZSI5HnYcPXgYo+rerbW1hQ8PdHXIf1yU2aSP5HfDfHioH10W8raIrlK5xpm0qPIDEa9HgGTymi//4TzX+i/upcJLLY1dy2F3gFiORnUNTAhLn46BQ/ZZEnnQw8rInHUwAyk2mYwu8OtxnG8iqVbqG+hFkBSbsCipej0IbBk+cEQvBdfkfiHzC4dTEv/6/R36uHD840aL5AOi5PNJeP1gZdMmSVLhBoJ83Ko0yzoqfWX5n8dXlMm5SwZNfMc35XdMiOUisej8h61eeCDZw5lgc9oOlyaHjW2w1xXUUzpTg1+ctYuRWcz5lPU7u53Z3l5iNrEk6DkOtI1vrJusAahQhSRiK/3n0IVgitvBOGbOMW5LhEEoVl2AopOZah9D8yKbSJGZ3XDNG5upPISm+BWaI7vBM9UK0s9Dlisg2ziMe97qXEIYVAu8p/HoLLfF0lWy1rfrT1pTgc9wARkyGLfd6QuZOgeEYLL4Ah2Kqmvug0twLWlf8Ft77htvZewzS
 +GCd1uWq
 jhaFPZFJovOSxiHy/ViylHEd5++P5molziaJAmAhRiKjDzGtA8zGnZ8qUSapMqX4KgX4CkdrGsJoEQIWuTx9/7KhH6ogCIsWIV5T/eej5E44078oV4glEzZ/HDDFlTH0tV3s7ibR0T73LVlYlkXDPkzWhny5e65KLkcp6DHsnnSZVC2stZaydjoRkTs5G7Fqv6v8OThcdxsPsHVFZ3HgZ9EZMrPUTf2orck1ioErn3IjuIwZWhcvZgApb6R+VSuJDEmvM0oZxmHGPt2KFx02Gf25hMIKODdiyI52Jfz+ZebtP7B3pQ4hfwEyQPeZG/Wtp4JEIw5cdV9uCvB1NcWwUpEIaH4R6T7nEzZ9EiLWSosREPv1vk4QKluKBsP/tC7+IKhS++u2SjYDM3XcgrNLGYHB8IPJjwR6+0zMKrP3pwgNuBT3dYA5OVT05YdYwmK2pui8rPqzuO19fhiQGAQb3tU9vk6h8h3x7FnAbSk6D+0OH6HQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/27 4:04, Andrew Morton 写道:
> On Mon, 26 Jan 2026 11:16:08 +0530 Shardul B <shardul.b@mpiricsoftware.com> wrote:
>
>> Hi Matthew, Andrew,
>>
>>
>> Gently pinging this patch. I’ve checked the latest linux-next (next-20260123) and the akpm-unstable branches, and it doesn't appear to have been picked up yet.
>>
>>
>> The patch has a Reviewed-by from David Hildenbrand and fixes a memory leak in the XArray library identified by syzbot.
>>
>>
>> If there are no further concerns, could you please let me know if this is queued for the next cycle?
> There are comments from Jinjiang Tu and Dev Jain which remain
> unaddressed, please.

Hi, Andrew

The issue is another problem, independent ofShardul's patch.

I have posted a patch to solve it.
https://lore.kernel.org/linux-mm/20260121062243.1893129-1-tujinjiang@huawei.com

> The leak is a rare and this is a minor problem, I believe?
>
> I'll queue the patch for some exposure and testing but it appears that
> some additional consideration is needed before it should be progressed
> further.
>

