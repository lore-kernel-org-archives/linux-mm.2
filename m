Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03C7C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FBD6B008A; Mon, 31 Aug 2026 07:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D09A6B008C; Mon, 31 Aug 2026 07:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00A46B0092; Mon, 31 Aug 2026 07:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D61F16B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:58:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5922640464
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:58:49 +0000 (UTC)
X-FDA: 85161417978.27.DA9DB5F
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf13.hostedemail.com (Postfix) with ESMTP id 71E0A20008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:58:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BHjc2uO+;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788177527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNbCjFVIuJYNB8+haqmfInpJlaQvl8qC6NDl65ZkQyw=;
	b=OhiavxJDfiXN7a72YP8fuSLdd0VWCLnFAtfdQwCTHJ1BiVrudwLv8jDtgUb0uT5OsC2CHM
	bDFMiLr0J6tulbqdFrakxerjlv2ce2ElijsjXITBv7mhaPRalCMAFZk0bE26lKNCFPt88n
	jSBANhGDluE/oOCZPm7g42fNjvEBoaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788177527;
	b=VWcdfQB0XxHHyAkdpVoQzBMhCKqIlUrT8HHo2uRWJgeVNml4i2fqclba2I+dDAvPCl9IKR
	6RUfZ+ouizhc2tHkSk5aBcu2S50P4BKl37Kxk+aSsJ5Ag3ewfIgcdS5/1qxBj6cRvGsDq0
	opVzHlEZ4vr8gMmlEEIQNCVIli1/2Xo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BHjc2uO+;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=longwei27@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aNbCjFVIuJYNB8+haqmfInpJlaQvl8qC6NDl65ZkQyw=;
	b=BHjc2uO+C6lYOZPaXhd34wLAcGOm9vn6mA5Kq60tW021U0S2nmIAhenp50eWh6RYp8b6IpuvJ
	kqZAAt7dx6Lx+ReriWigIjmA9doIwpFm+5F8+koxw/XpvXuG0CtRTb5ZpDpnRtwn9Bs/JXkF0LI
	t7VPNXWMN44+jREmH1JvF1c=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hYS0F4SNkznTVd;
	Mon, 31 Aug 2026 19:47:25 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id DED7840563;
	Mon, 31 Aug 2026 19:58:39 +0800 (CST)
Received: from [10.174.186.187] (10.174.186.187) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 19:58:39 +0800
Message-ID: <b5979755-6089-4e6e-844d-2e6f32f687a6@huawei.com>
Date: Mon, 31 Aug 2026 19:58:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] kho: Convert error handling to immediate return
 pattern
To: Mike Rapoport <rppt@kernel.org>
CC: Alexander Graf <graf@amazon.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <hewenliang4@huawei.com>
References: <00c96a62-f783-497c-a7ac-1de495e4af06@huawei.com>
 <20260824024448.550552-1-longwei27@huawei.com>
 <178817571946.3691424.3757525664520719609.b4-review@b4>
From: "longwei (I)" <longwei27@huawei.com>
In-Reply-To: <178817571946.3691424.3757525664520719609.b4-review@b4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.174.186.187]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71E0A20008
X-Stat-Signature: 8qoe75j5ewdqkiuszr1trwghs5fd46ck
X-Rspam-User: 
X-HE-Tag: 1788177525-343604
X-HE-Meta: U2FsdGVkX18TgBnxBApbO609nSCjsZO4NZxqiEHyoDOqehRDrlia6ca5+DOj+BA2IGgU+8LX6raVZIZA5QZZyjRdRSCpF56JPOU/J/w4nJDEpMTd80Pn8vRcvouQ4d+q1hlShIgMfwUNYOC2ONUpf6DA/RcVJlZdZm6vdQJizCt4okyLCzbBsM6Ejh0jpxS+kDAQxC3Kfm2J9NPAHljPJ9j0qae+HTWX+g9riE5tdnRu7pq78meBH3oUWJFv9ZX61YmKLW2zpJ0hpS9RSpSUShqcBHY4+O77RM7Odw4lfMaaNMaDHhtKcqUCQQ7mz51SJO+WoJrUEl3+ohXWgceYkaOOxrm0aK9sWzuL8C7GP1MdbyEIOLKQ8oxHd/AF0qi3BLwOv3x8vdfoGiVUu5DiW3nMsSc+K9cWUFZOgv4mpJaEC2keRSA56rFOhDd38Ve9MFM4R/k12bvzinJR8DbPU/OkJgDNN4+GxRr5mhGPnGkH7sxVbOVVrah5GkeBvyz7x54TTn7GsfzWeRjcaoZYMbVKNG+EGGHPPGRvSjKU4tB4Hw98veYuYtTlzA9thV0HLqrtUy7SrtzEXFgo3jgwJ9z3VMj+1f9xkf5X99F/z6lFr/xhudBL13eCOBwiIo4tIUkR9r34ihLVmqJZAC5O4FNofD4ZvHRQDdVP6uq0xbUe1bQTrayxMrjHioGNnhiBtzB3VhsIGYX4ez/dnj1GYRt7WzmdyqsiYFJlVRVR5pYSUBytgxvL70iyMk8XRReaOmziRFPcn3lPrrThojCxjlrdJekQj4faeMcjmXTDNg8pYX8iai7EJu+sc1lDgmInlbkmrmGw7LMCEzqo+7BCnIwyGXXjWqYbaAvZwxgIbmJrTsnUvh/R6/4ipx67RzxTde4yqGSLe9cj65aMbdQKgQa8zYidtmhKHPaLf7lPc8w3J1FKLPHGXD6eq4Ef5C9yu8Z7EY0MPinubhXFlzJ
 Ccew0k9f
 gCJgvduLWA9fLdaFlnMi+xwIy2WKc+s+IYUK/EzZdsLa8XDsKQB9nENGrqJ1LnEG4Aku80/dvHQXgaUXIsaqrB1OABxoaWHLecGFyTLCKfjIRxXCnGJjrwgk3juh6nm/BXO6w41EyuRe3+FqjB7/sDIxFk/Dm5m4GXY/WdHUi00Jutb59sZHrk5FXQ1vPfZOXhfxTPVFuEO5mPQB+dc56dRvvcVtlrijZkbzup5rdGZX7hAlQo4nFOa4OhKpNH9ulsfCc/E0lTFbq15fxBi0T+g6JaLcprv2tMKGQSShGY4Zv4nw9VjRin6h6wotqb536Blir
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike Rapoport=EF=BC=8C

Thanks for the review.
To be honest, I haven't observed any actual failures in this path in our =
production environment.
This change was identified during our internal team code review=E2=80=94t=
he err |=3D func() pattern looked concerning to us at first glance, so we=
 attempted to clean it up.

However, I agree with your assessment: the caller doesn't care about the =
exact error value, libfdt uses its own error codes, and this is a cold pa=
th where failures are unlikely. The change is indeed unnecessary churn wi=
thout a concrete bug to fix.

I'll drop this patch. Please ignore this submission.

Thanks,
Long Wei

=E5=9C=A8 2026/8/31 19:28, Mike Rapoport =E5=86=99=E9=81=93:
> Hi,
>=20
>=20
>> Replace the chained error accumulation (err |=3D func()) with immediat=
e
>> per-step error checking and early return in kho_out_fdt_setup().
>>
>> Two problems with the current approach:
>> 1. It continues executing FDT operations even after a failure, which
>>    is pointless and potentially unsafe on an invalid FDT context.
>=20
> Did you actually see failures here or was it an LLM suggesting that the=
y
> may happen?
>=20
>> 2. Bitwise OR of multiple negative error codes produces a result that
>>    may not represent any actual error, making debugging misleading.
>>
>> Early return fails fast and preserves the original error code for
>> accurate diagnosis.
>=20
> The caller does not care about the exact error value, so the diagnosis
> statement is moot at best.
> Moreover, libfdt does not return Linux error values.
>=20


