Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C125CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 06:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BDE78E0007; Thu, 23 Oct 2025 02:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295868E0002; Thu, 23 Oct 2025 02:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB238E0007; Thu, 23 Oct 2025 02:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0607D8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 02:16:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F577BC9C0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:16:05 +0000 (UTC)
X-FDA: 84028368690.10.65C78A3
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf22.hostedemail.com (Postfix) with ESMTP id 396AEC0010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:16:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Oz7tDJwM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761200163; a=rsa-sha256;
	cv=none;
	b=0pNLp4DZjDh/MpGj0DOAVuWJjOXu3xNMfodnH+EsUeGQQi/ScR34csFLSgti+VJlwxXO0t
	q9WDrm3uJuYjB0uXMjVZe5l+NQLqBFVomlTy/Sq1NiDN5R1yqbRj0WacA8jK79mMGj1Ln6
	2uWNlGUDC7gQksGw9IzVNUIsm/5LMcw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Oz7tDJwM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761200163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhj1VLtSYO+AfqlDWQL1li1LYgXwZ69chK1m/bx772o=;
	b=cQSo8TSjSM/uKUzA7+Vmq0pXAFQEiPyShVboa8pBO2RJABJT4keUu33sSc96kVbfiWNXMA
	HvsXfMoGNxHRSe2J9UN9VuWFuXiYE//eTJrQFOEACnUlBUG3y88eGxgZSkINJR54uTc7Od
	ABIkcPVceetmQ8l2fX7wGFE2sGCY30M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761200157; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=hhj1VLtSYO+AfqlDWQL1li1LYgXwZ69chK1m/bx772o=;
	b=Oz7tDJwMASc/sBnzb8tuijEStdyfAngNV7W0jgMMEw5yZHgP4K8C2bo2rZXy3Pae18TIesBs/egYEa3HTkIleGO+WwTE0UV3w/QgDxvMneRVMNfABZjvRdePww0M2hw+odYE7Eq4hAUk8rvKYhPwK6ZcdiJWeUILpFm519+PKeM=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wqq5ZkD_1761200155 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 14:15:56 +0800
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
In-Reply-To: <CAGsJ_4z7SASir4gWThfePdnvw82TB8E6rXnzJ=CieaFnJpJt7g@mail.gmail.com>
	(Barry Song's message of "Thu, 23 Oct 2025 18:39:39 +1300")
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
	<87ms5j4444.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4xhJSLnXOZy4kPmnif5Paq+OPN_Ww+rPk2WO4-ADSC0Yw@mail.gmail.com>
	<87qzuu1kg2.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4z7SASir4gWThfePdnvw82TB8E6rXnzJ=CieaFnJpJt7g@mail.gmail.com>
Date: Thu, 23 Oct 2025 14:15:53 +0800
Message-ID: <874irqywh2.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kxc97oq9zorbfasiqanpmetmfbepdqhf
X-Rspamd-Queue-Id: 396AEC0010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761200161-34180
X-HE-Meta: U2FsdGVkX19oFwXKIhwH3auaozx2E0LgbLKAPdovHyS5luJtkPNWGZR36KpJMzc7giHuNk45FUrHh7WIKqlJPZ7B6qMUxlo5O1M2lzBm+ubsP+HOJLK56ynu5Ub4ZuyP6S/tkNgigwSPwJowPRHdPRS0bFf4IAnANG3XBdT+1vTQlOxFOtqjnBHBcpi7mASHz5XJak6DVH2RCr+jOUen7rIHTUeHu5bW6pShmlSXXSvAR+83vjTHd8joryZvmECdbwUwN8cIfixgbA/VoHSEwD1BgjSJahIivonUZG0nyg/fCTjyptqpLbeBg1HfA8UtR7/cikp7DHOaNDcq4rnm+NrMKWXvEJm1ioprH3OssJc6ogW87J2Wkux4ghjcaxLQK38JBRTvvA//MMZUxiES2NgoJ3O7x+IqZjjSLwKb6b065uJi3/NNi90lLkJtxCJoWuEzv+k4DZ2sqn8Y6oPiv9cHAYDPJxlHRQhcYjE8uiv2jfJI92P97G4KXQk5PHuY2HcaoYk2hOjGmgOt3Olz4/mW4kdcF5/R32Sy2fcyiytjzE980/wxuO3gO1pxfrtriZeGK90FOa5wpXX673Q1t2ANmV+4n22/DA5/q4txW88xAUDjDQ0VyZMA0WJCdxxeT+yyhTKjmGwJCzESQgkFRztXe4nlT0kEs1Ulw6SXqajo7++ivRdgVwB5iFcYdQc3kWFz4ulXHfzpFzi81qyxP0xhN+zWx5G3xl9TOQx6h/v6PZfHYMwxzVwvGOlgpgMelM03xLF9yDre1tPBppc+H+3Rrvkrb73bWPb1AfQTQnBuAO70Ww0P8C3NltoApQa/nNjRiRudKfiebUYv5mhrZDmINWlXVbi2Pjb7XzP+j7vPPsWMDnTH08GBjn9S73hTY6vqqMHpmun3u67XBDIQ6A1E1pWCdhY6nb3WSsLfKqOdSwte4lrtxnkaRAzMn7WOTyrA1EqsjcyagGvTbeb
 ibmb7Pas
 I4RHbRvwIn0rCCFi0/NNhcl0OB1JVT06XryhQGYPopjKgKH83H/pxNrun55r8if9G0gLpeYUtjcHEKG3xxwy1I7pq0lPK66zcM9vXvSMYAsffPyXfdwkaqIbVNTBglTXvm9S33Ikm14gIPNn8RUT6K0yr/BF/7M8B6eC1ZdzoR+yDahfG8D9eFL16G38Ihybt1gJ/eyftTry1VKc5b/5Mr9C2VERRMyaa0T+8rL2y+YSrOD37kWcMXTkpscTDWwfHD/04VYkOOqj1hMETioOzoMNPcYhC81S5PeHn9SM669miIfc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> writes:

>> >
>> > A:
>> > write pte
>> > don't broadcast pte
>> > tlbi
>> > don't broadcast tlbi
>> >
>> > with
>> >
>> > B:
>> > write pte
>> > broadcast pte
>>
>> I suspect that pte will be broadcast, DVM broadcast isn't used for
>> the memory coherency IIUC.
>
> I guess you=E2=80=99re right. By =E2=80=9Cbroadcast,=E2=80=9D I actually =
meant the PTE becoming visible
> to other CPUs. With a dsb(ish) before tlbi, other cores=E2=80=99 TLBs can=
 load the new
> PTE after their TLB is shoot down. But as you said, if the hardware doesn=
=E2=80=99t
> propagate the updated PTE faster, it doesn=E2=80=99t seem to help reduce =
page faults.
>
> As a side note, I=E2=80=99m curious about the data between dsb(nsh) and d=
sb(ish) on
> your platform. Perhaps because the number of CPU cores is small, I didn=
=E2=80=99t see
> any noticeable difference between them on phones.

Sure.  I can git it a try.  Can you share the test case?

>>
>> > tlbi
>> > don't broadcast tlbi
>> >
>> > I guess the gain comes from "don't broadcat tlbi" ?
>> > With B, we should be able to share many existing code.
>>
>> Ryan has some plan to reduce the code duplication with the current
>> solution.
>
> Ok.

---
Best Regards,
Huang, Ying

