Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA52C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2996B0096; Wed, 16 Sep 2026 04:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A28C6B0098; Wed, 16 Sep 2026 04:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0456B0099; Wed, 16 Sep 2026 04:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4B4F6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:46:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 626A21C2BE3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:46:46 +0000 (UTC)
X-FDA: 85218994812.06.B8C8725
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf24.hostedemail.com (Postfix) with ESMTP id 370EA180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:46:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="F/R0XFgM";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf24.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789548404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iq/G8rFqqBdY0DiJTRHbPh9MIq9KdVN70oeDhYDSjGY=;
	b=qpd/CEXi5eF4y9kHUVYPFT/lAXYICRtlOaTOK+DDWJrt8/PBY0wbFujza/VfPMvUdxhpsH
	x2c5rD+MkqLOZ/yWuaS1rRF+ER/gjmKnJqmbSW/Yg0/PkI+N1b2wX455nqFuPfCXHJx4mw
	3vRe7tgTdJkskbAM5BOR+c719ikVXyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789548404;
	b=qoo5m8YFCS7mjZlEJidYTKN0X/77D/jQMnfRZYdXLlwz/nIZy/6Ysl1jmIB+93rVXsmIwN
	hFcS56ioUrqNXC9amrUJzjG0DtCjIxU8BD/T8YH4bS9GVIlRn35BAqbBpMSCGo3VoUg/C+
	fFiCtWHGq5vVOUv5w6j1Wksk7fdgdvg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="F/R0XFgM";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf24.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=Iq/G8rFqqBdY0DiJTRHbPh9MIq9KdVN70oeDhYDSjGY=;
	b=F/R0XFgMWqW3NuSwSdzsgIoift6TFSo5JBE00G782Xpi5m1hKC9csmIhHWxe7Z
	MJveZhtJUKPzrYbkdDITOTKi3Se1AFvO4/0DsJ7tSu1g4dE5+nNZUuNSNyX+Z4VG
	aqwu/nwVvGg3g4qAbyKx0TcJ5NaqTYfyMrpuNDpPre45E=
Received: from [IPV6:2409:8d1e:e12:10f:f16d:ad0f:fbc2:4ab3] (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBXGgJYV6pqVeX1Sw--.12121S2;
	Wed, 16 Sep 2026 16:46:19 +0800 (CST)
Message-ID: <1537faf6-5a31-4c7f-a3f0-8c88ea947779@163.com>
Date: Wed, 16 Sep 2026 16:46:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] mm/ksm: merge-path cleanups and folio conversion
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-kernel@vger.kernel.org
References: <20260915222545.5683-1-xialonglong2025@163.com>
 <d490e314-b92f-4120-93fc-ae36f487b135@kernel.org>
Content-Language: en-US
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <d490e314-b92f-4120-93fc-ae36f487b135@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBXGgJYV6pqVeX1Sw--.12121S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWxury8XF1DWr1xKrWxWFg_yoW8Gr48pF
	W5Ka4UCr4ktF1xGw1xZa4UZr1SkryfG398Cas3ArW7uFn5Ww1Sgw1jgw4jqayDCrZ3Ww4I
	9FWUX3WkXa1FyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Us2-5UUUUU=
X-Originating-IP: [2409:8d1e:e12:10f:f16d:ad0f:fbc2:4ab3]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3BsxKmqqV1vOIgAA38
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 370EA180004
X-Stat-Signature: bfjx9re4pdz4uww7o5ascdx4we8muy6u
X-HE-Tag: 1789548402-905179
X-HE-Meta: U2FsdGVkX1+ClW9MKpEjSHl/EEe9TGC3s8F2l2AEtIXKmGGHG/9uDQmAnjcs3vrj3tTIzCpurKP7dBhNJI/2lb8mQVFeFb+O+It7mWbBzbKWa+pzlE7tGD7MQRUw/8+lrg4Gx+gIXXmgSEccPz+oy3nc+2rv1+entIDi860KgevIPdL2hj1dr6jLSM+i0CUCA6kXcUeL02KtScQxiTTQJgs+u8TAV8A/VvRjJZIBrJDv4IGSJ6Yo3KG1JPoT2g1WE2nCbbouKOzOEAFHNFUrjPOXyHB9LAu3py16ZBEjzrk5stJ4ySdLIda8XdBmVP3luRy0VK+TNFX+vEQ1k4ROQ6dnVLxh3Yz2EBFOLA6g3i8p4HhFjmyfV0k9GKKnbewW+FB977oqgb5n94MYRO/kplaPYUv9auW6zzXTeZKmWX3sUOjzdqwGWNXqTU18U3jcrYbzvCAqd+2PVeUuVJkp5Q9htbqx+hIYEZs1G2ETTZdCywLEoUgXzbpPkuUHPPwc5UqVcWxjLgnJv/8u5s1tVmNn2PRflyXtHvPHGOKS7Ut2OQukjKT+Aj2qmd/FhGMTTHSki4neNyOwl8d5LFvwyHAAucNQ7os/GsGbqo2eeJ2BKHFU0wOvCcU+f8RxxRuTTgY68MIq20NO/Q0AMeeUjLki79stPGNK/vfPI/hCF2tHQOv+q80Zt3Brt7n+9jur+c6TdVVji/yfl+4e3WsiXIDDsS5DxGLA5Bso1JjYj4adxBrKz+YiJwpOeNlPJKwkU+8FnZjlnJPF11uu0lNr9efbxxISz5CPtwbhg7Svi+SoaM81tN1lwMJORoZ5L6KF3iX/C8gwTLpCk3DpmQhZBljKQpvVLVHp2eg9SHe+epmPCOKgQRHd33JFpsa0qpVu19IB1ogUWoOY9U21xW3Ul/xFvPQdELDIWYeqG50QO+H8U83WT3ZhMTe+MGBCzGPVZ9pAvPMLVTOk35z86Qd
 MFaUORnP
 GQofJ+NmhHXQSmgHIrvJn7zK10pLq/NAlTA6X90AjegFgAforVOybwPsX2oJH7eG9EUJHU9qMfF/WbLwsbuhQ0iKRkYWIBblvTzJVBxdelwmqeKgYHlzde6PnH4i7DktomTy8mf1vHDi8RKjs7w0RloTL2ZpM046PiYfbNaz0F6/qYuS8mJuaJsnW8cg+p33IUhDkojh5k5v5XiTQUQ8QGAc1b2ADSjfNQmMkP9n9/Ctrc7WeSfKiKg9xeaPpssrIVPciZBrMyr8mbTJPg2r046fPKNfwOrT7RUrP67oVNt5UtD+aL4IorprnzGhxl7ya+LqJ+jgKUbXQM//8sHwIYJ9r2r4rq9ktygsytHLb6YExCg8wwZ/IA3lEzy+cS0xW6riuDihD1NBUEQyvwzy7XFb6kGfI1cDlBjn7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/9/16 14:37, David Hildenbrand (Arm) wrote:
> On 9/16/26 00:25, Longlong Xia wrote:
>> Thanks for the review. You are right that I did not justify the
>> page/folio boundary clearly enough.
>>
>> Patches 11-13 only avoid converting the target page back to a folio and
>> provide no functional or performance benefit by themselves.
>>
>> I will separate the independent cleanups and drop or rework 11-13 after
>> getting guidance from the KSM maintainers. I also found a NULL/bisectability
>> issue in v1 patch 12, which I will fix before any follow-up.
> In general: once we have a ksm folio (folio_test_ksm()), it can only be a small
> folio and we can operate on the folio only.
>
> Until that point, we really need the page, because we might be dealing with a
> page in a large folio. Sure, we can carry a folio+page pair to reduce repeated
> folio lookups, but be aware that we have to re-lookup the folio and take care of
> references whenever we call into something that could end up splitting the
> folio. So we have to be a bit careful around that.

Hi David,

Thanks for the clarification. I understand that the page must be 
retained until we confirm it is a KSM folio.

I will drop patches 11–13 from this series and send a new version 
without them. Any reworked folio conversion patches will be sent 
separately later.

Best regards,
Longlong


>


