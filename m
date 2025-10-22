Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAD9CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92C08E0012; Wed, 22 Oct 2025 06:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42FC8E0002; Wed, 22 Oct 2025 06:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31FE8E0012; Wed, 22 Oct 2025 06:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADFFD8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:34:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6205C11AE0B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:34:28 +0000 (UTC)
X-FDA: 84025391016.08.79A8ECA
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1DDD4100006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:34:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qRpyAbZF;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761129266; a=rsa-sha256;
	cv=none;
	b=f9YqTNRw0W6Az7UJ7benKjOY3tArsIFgP/YobsakKXMsgWpI4AuUvtn2hXWdDmrY0/xkUr
	ql1oqZTy7atFzIqsn4T3fTPlh3RYGUbzkDG+Q5JsHVo+5sDuTrWDVtyKioaNWcWMwNsbYA
	Bmf0xTMrwO7KFa52k309XtEEgr1MaBw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qRpyAbZF;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761129266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zApZp8kIsLL8CaVDud/rM1l2bNSLJbbDdobxbcxNIAk=;
	b=4gv42oFsrmARXb2DfVgxjBxZn2HGYLo0jvoUWwKu8ASUP/2KAh6tGh6/eiX5I2qJhuqsR7
	5R/hEgQK3XuAAvwO6qnXGZX6yvq1kq405qvzNRvoqYn87gdA5FGEppn2Z/zqJMtrI5MKc+
	YbyNlFZqoKgQt3Nx7BZOVSg5fAjgYTg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761129261; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=zApZp8kIsLL8CaVDud/rM1l2bNSLJbbDdobxbcxNIAk=;
	b=qRpyAbZFZmLuBkW96iFZWGvYTcvU6yEUgg3li9k9FXDXVxQ1vFE7pjAOuGS4yFqPhW5FQjLobrvvGBvTBcCpNatpvEl0S/asGqvk0C9b94o0AxguAddLosmRLiPl/WvNLyrhrYYrdQSnT37ZqxKQJLvAIrErFqG8guS/Iwa3P+k=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqmTUwB_1761129260 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 18:34:20 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,  Zi Yan
 <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Ryan
 Roberts <ryan.roberts@arm.com>,  Yang Shi <yang@os.amperecomputing.com>,
  "Christoph Lameter (Ampere)" <cl@gentwo.org>,  Dev Jain
 <dev.jain@arm.com>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Yicong Yang <yangyicong@hisilicon.com>,  Kefeng Wang
 <wangkefeng.wang@huawei.com>,  Kevin Brodsky <kevin.brodsky@arm.com>,  Yin
 Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <CAGsJ_4y32i3aNYPum=8J3_Kt6vOSisr_jg6btB-YG1uQBqHG7Q@mail.gmail.com>
	(Barry Song's message of "Wed, 22 Oct 2025 22:55:05 +1300")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-3-ying.huang@linux.alibaba.com>
	<CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
	<87a51jfl44.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
	<871pmv9unr.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
	<875xc78es0.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
	<87a51j6zg7.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4y32i3aNYPum=8J3_Kt6vOSisr_jg6btB-YG1uQBqHG7Q@mail.gmail.com>
Date: Wed, 22 Oct 2025 18:34:19 +0800
Message-ID: <87ms5j4444.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: aksj9dc9q38d4gk739op1s6gpa3ctoah
X-Rspamd-Queue-Id: 1DDD4100006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761129264-850287
X-HE-Meta: U2FsdGVkX1/DIkmBhYBByebYge8UF8dYcYpUG8x6veeCXKmTfSVrUCgzzmrV8K853QfrueJKdYL7LfYH5+GfqWBd/XkTgyJdvXd5ttDyQp9JIkAfhYJ32o+dZuFfXQ7PyuVUam/DSl1V4E6IvByf1bHdwVuhu+OveAUOPyZHYcGYL06JUpT4Y8UtCQUTYKu5q1NYiyQCLXrpWcAOJGdWa0gUDfuxtQCA/ZLfyyosV3f+MsjwgQ9PLOlaTeOFnhZTPhulYahDjgnkY3iQDMY2joJMBsbKZx2831eaaB1nn+Ix96D4wg4kSU6YujHeOqP+SLH+vSAaenkNuiUcYu4PMkCqxVgglr4+fOoojtIsv/S11ddFY7D9oLkhNekqRfO6LrOhFYUDhaT0zBhVSVfpisMw3AQ7kiYJysDAgm7fYXZuwwIoa6G1w3OVM0rFb6IIkdrUTaq/Y9m8E2H0HYx+BkGdCQTOJeui5ws2VXwulz8Cp7G/ZrtGNAhSsN3fE5+UigtYu64bornvK8uTqwVOH2xp+hrcRmv/5zk+ERTzOD3VDxcbRcPf++qVFQZTTaX5x1+Bu3T8XJw3n/6LZXBRW5MCkxqKNjUTDZ7oL8K2J3HPY8TUWK/+wA2aRDdl8xg6bzwAABijwNdmt+ArpCG5y5U6z0n7vjZJuv7d+exkqU4nsd3Uy5hMuomtAfyK554JMIqOb2HJUWuh29h1hyNSUhCwbrDfyaf23g5NJ7JQYqiXrckagU95P21Zrjs+nisrpXKr09z0YW134eiuEMesUQ7R3/eGiN/iUqO4HHX+Pj2RBUV0ZIGB1zq4Rs3GEa3CwKl7cjg8BekzhvKw197wFyWtdthNKP7dKys7sX6etiRyU1H90EpaboUjQQeph7166SuTYOySZqPpdpsBW4QIhgvhWt0LdVblhl1nQJWv4mPR6xBnYkST9Kgf4sB+EmuywJNMS/5R6iiGLKff9G+
 Ip/+/V1o
 JrPZF+xlNLQT94+RhKMjR3CcU4GIhMyq8mmq/Ezf4BvLL+1eQtbLWE16aJOiiuc5sp/nSO05IIZzBPcCbQyO2dUMBsZd0vk9PUCB4Jz6uzhtQg+vGJXuNcngMqN2viXLoFGBeN6a8qnl5MZLX6K48Eewek2uuUEvq0rR+J1wG+J2vHk/hXXM9fWEs6RQMcfjMsbi6AYxuXEGP05W5m9zKD0/I5QrM6ZZYcOc/+1M5U4o/X8Ns9GKSsrxawA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> writes:

> On Wed, Oct 22, 2025 at 10:46=E2=80=AFPM Huang, Ying
> <ying.huang@linux.alibaba.com> wrote:
>
>> >
>> > I agree. Yet the ish barrier can still avoid the page faults during CP=
U0's PTL.
>>
>> IIUC, you think that dsb(ish) compared with dsb(nsh) can accelerate
>> memory writing (visible to other CPUs).  TBH, I suspect that this is the
>> case.
>
> Why? In any case, nsh is not a smp domain.

I think dsb(ish) will be slower than dsb(nsh) in theory.  I guess that
dsb just wait for the memory write to be visible in the specified
shareability domain instead of making write faster.

> I believe a dmb(ishst) is sufficient to ensure that the new PTE writes
> are visible

dmb(ishst) (smp_wmb()) should pair with dmb(ishld) (smp_rmb()).

> to other CPUs. I=E2=80=99m not quite sure why the current flush code uses=
 dsb(ish);
> it seems like overkill.

dsb(ish) here is used for tlbi(XXis) broadcast.  It waits until the page
table change is visible to the page table walker of the remote CPU.

---
Best Regards,
Huang, Ying

