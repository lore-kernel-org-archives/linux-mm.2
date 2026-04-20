Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0273AF588C5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5DC6B00A4; Mon, 20 Apr 2026 09:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4676B00A5; Mon, 20 Apr 2026 09:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4276B00A6; Mon, 20 Apr 2026 09:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7636B00A4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:21:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03EF71409B2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:21:55 +0000 (UTC)
X-FDA: 84678997032.04.203A531
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4286220002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:21:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3cSjmaQkbALAiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3cSjmaQkbALAiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776691314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=wiply+2rM/RuN/py8Z9atYEesIGd22oqoTFY+NQwIi4=;
	b=nRnSUWOKM6lkaa4aLt9hJnzPRyXuYGT9j/0jIgOeDJxybqTJHOMuFkhnXIE9CESMKOA2FM
	huTZyqYvmJdo+nP2p4ryvzvKguRs/jy6kNjPn2kTcG5YRaB65SHFv615PSPtJeBmtZMCtJ
	joBJ1zUzxsEA/BuBER1k3JB3kXmyZZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776691314; a=rsa-sha256;
	cv=none;
	b=q6+X1YOvfLEQyRVv/Mcxt9zk5V3OpjkEy6hAMRrucWTqRUvzILoz2gEzQ1xlfkPC+zH4YR
	1l2ly3QHCCUHwHf7vmsWzwaUpRjhvaLRFEDpw/XLswHc7CiFgUW/n9zm5ludHF2i9oBnM5
	4pY3cZadEdg+CVCDqqdeNRrfhfvZ6QY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3cSjmaQkbALAiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3cSjmaQkbALAiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6946e873672so2518471eaf.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:21:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776691313; x=1777296113;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wiply+2rM/RuN/py8Z9atYEesIGd22oqoTFY+NQwIi4=;
        b=poXjqpm99B2JY/F2J1QygJDxiYmDCm8IoHQeVflm9A/G0s3tvg0LgIm+km7iKhV+LZ
         lRanOdiqjBsmdObgLiA0ZRO8mPHKaSybro1EUbpVKFb5OsTFxFgGP88mUm0G23rb7wCd
         1/5fBlK5ClsNVlbFHfIuukDuAaV2uiosLd6X0WLt8zNnEXGSVWgshBaZ7cfBNtjUMPoP
         f1mYdNez5VDsTD/4Gko66+Fe7VYFkWehsMjDoYhCWd9jMx6nGuXawNgnx89bcv5T7JFh
         vlQzSyZHvDktIrJ7fhRMm6m1vox3ZBAstl6Cu1rnkNV4tQRWaMn1AHcOK8+gX06EKJB6
         nd0A==
X-Forwarded-Encrypted: i=1; AFNElJ8Su5S0AenFFZSgVVxLVOWjs4fLxYxzWdrBEVOSqzbfRyJlU+u05V1JyAysnIVmcUFORNALNS7BvA==@kvack.org
X-Gm-Message-State: AOJu0YyAvoCIj/b1ouNuETEAlsET8sylNjfLY91h1RJ2TLvV3vpmhZUv
	yYFFBw80gsrkjNmNQGRhBm76x6loS695nx6qEpA6A9Q1gX2+oHgRFUlb84WmgvDYtJXUz75cn1G
	hC2O05GwR0y5zDASRpDvaPOlCn0KfuSdwx9Qv+8/fp70Q79SXlfzAjVVpttI=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4cc7:b0:67e:16b4:aa13 with SMTP id
 006d021491bc7-69462f2ee3cmr7688964eaf.58.1776691313329; Mon, 20 Apr 2026
 06:21:53 -0700 (PDT)
Date: Mon, 20 Apr 2026 06:21:53 -0700
In-Reply-To: <111dabd0-56ed-4a55-bdd5-fd1ed035bc5b@h-partners.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e62871.a00a0220.17a17.0004.GAE@google.com>
Subject: [syzbot ci] Re: mm: improve folio refcount scalability
From: syzbot ci <syzbot+cice493d3fc69ae0f8@syzkaller.appspotmail.com>
To: gorbunov.ivan@h-partners.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, 
	david@kernel.org, gladyshev.ilya1@h-partners.com, harry.yoo@oracle.com, 
	kirill@shutemov.name, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, rppt@kernel.org, surenb@google.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org, 
	yuzhao@google.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: c1c1osfnuhqytf1kwhtfk11syb7ganrf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4286220002
X-Rspam-User: 
X-HE-Tag: 1776691314-608218
X-HE-Meta: U2FsdGVkX18casuUpppOaCkVaMvYdXDQyJLPvR0R7dAlaZDksEa1Oc/HkEQZ0UBSTIi2QZ5KFwPa+H+Qy09+yXTC7ACJq5TI25QPFZpN1mLdmoPcIyChaSofDKqM+COLoPyGtIfDDb2LU7dcplRKM29YYIKGajT7iMV14ZduVhYeq+VeCACAC6a5AXbWM6FfkleUywJR12udfks1XLVcV+nmJlLnHs3w66gsjLYWnUwsttlJ/jurD8SylK0k4WxFA7xJrKGW3fxGLEG0OxqMXhACvybuTHaQYNrYGaCFOFcbkGlgPd4XP2ND0URRjqsZDo1wGE7m/jqh2idDTLf2/wqBiomP4xeLGrD7W145QjSZR1hUrfxMf17IUZzcWIpg62S4YIyaLHz5pgsr8eHhove2GbmTOMExnx/BBNyn4mWloziM6Ig1IJh8Xx482S7cnXqSswu0Ot6LWQP31UcXo4lDFgV4SqZYRq1Q7000kiY6CtiuTBtC8VwxhAutuoJoI88uIIMh5G/rKo8xY0Qi4fvrXfUpYqNwcSU/bVD0OAiIZhJCxaDKHBuPBNRXaSaI03Sx/IpzJxlx0N2tV8W5OATY2P3WtpdHKeKNtrakTB6gH7jBO6ErYdqL5mSVH++jE98EHf8h6ChkdJgRi85n1kFgaSCMM/KkGnYwa/e7yryzc2TpDmZ9+GyPBxRhI5CIYFxIwPb4E4bDZY2haaWOx5j2CsIImy4Z6+mHuBIsW/88DL9PtB2GYgu4B8NqSvn5o7hCkhSRv2yTpnboVoMHHdhGtq1aAxHHz/Zxsh4naffcMYmuvVRw0o3uPR9kQVP94Cqk4kVhk+V5sdYEiCaPlf3IS8ho7I7kTmfJFLcaU/HhtDPRKtRLWF5MuzOY3a3gxvQNlLJuPCKQNqhMK/014BfnD2YhF6oZlQMEXWrXzv8croXacQ95NsvCzGfrx0wdk7ZW7Gzua4Bew+hDBVD
 9WL8pRL+
 njtkzdk0ysRk3iT0CIBB/orRGqYQlF4NiH/Y9ZckGsDpIRhtwxJef2vJj9327oUyCNO0ZW1qg2+zHcROaIEJePIs771/9vQ6RFFo5PirrLkaIH1EqWntx4iBHSyPYWSMHKRsGwFboo4Qi95L3EomGXTQu3WKbQlwuGczuHKYgYOJltPIoXJndB0hxdNyEo/TnLVbSzefeKO0BdDWzIukH9Ezbn6hVtCgkAIfLhUO/c4gWL3XoVA1lETR4ViRlzTMRtLElullKjZnXpKhyqcRuuvm1AmsWylKP88F1E88jJtVOVBRczYp9VaI1H49dJp/+7edL2E1HsYPWWtbEmSipKFNEOzJivW956Q00sC5BiACY/7Oajvz/U6Y0utGltcQTHuj0WSFFgukYax0spFvK7MbWKphfroz+9jO9MN0SZN+4h1ylLpyeIpw6eXkbHre1Wl/1aJ+hhrkGqJqSFqjyg3Bhj9Lw6W8R5vKQqiW31BPmGAtNbr0Wmd7RrDpFwkykscplcw2jPJC13PbtDN9K70QLHuYUEN9Vk3kswddrtcoQmpV3nx4Ze503TYaK9jHd6RYTO47qiHE4AZn3JUbrOC7Lg/K7YNO5b/pE4Ur9IyrZzsE5dthQnAo1R4R2BIkGHZH8c+pdCWhCcN863ODdkJuhGfZ9S9t7WgV1LkZ+h0sfsXFdNy+ILTlUKAtHZxFn1mRIc+Kl2Owh4BMQXS6TaRqSDtQOtAwA/UXa/ZpC+Y80189jRw6j/zh0UN2hQzh9kjXSGAzJX87Dz60LIczBc3HeZ4UY1VYh6V2r+Y//cCMJTMp6SWEPFoYeM5zvz2PdxAz2145bQk8IrnA+qsxZqINmoDIwWeFbfvQZK7Y0JouFE/isKDfXwenE888pN3BPfKQoWgniRsRkXxCjpsi068tLWgpuZmCLVv/c/gnNETgyAKIyFWEX7WizDpQMpe+kOS9ymbOuMEKqu9++o34TkBmam+Su
 idh3hxPQ
 fF77++rnAIMBp2cVjc16HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the suggested fix patch on top of the following series:

[v2] mm: improve folio refcount scalability
https://lore.kernel.org/all/cover.1776350895.git.gorbunov.ivan@h-partners.com

Patch: https://ci.syzbot.org/jobs/1f75dd6a-7a6f-4420-ae4b-67a071622e07/patch

The patch testing request could not be completed:
Testing failed due to an infrastructure error.
Testing results:
* [build 0] Build Patched: error

Full report is available here:
https://ci.syzbot.org/session/0e12b11a-0902-43fb-b549-6c0cc5ae45eb

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

