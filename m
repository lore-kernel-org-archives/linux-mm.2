Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B221CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13768E000F; Wed, 22 Oct 2025 21:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3818E0002; Wed, 22 Oct 2025 21:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB33D8E000F; Wed, 22 Oct 2025 21:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 975A68E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:22:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C4C4BC65D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:22:14 +0000 (UTC)
X-FDA: 84027628188.14.670C898
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9773AA000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:22:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hg9t7M7y;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182532; a=rsa-sha256;
	cv=none;
	b=nMk27zEfl7hjKmSD3xZFkyPEwNXNtDOCqzXUG1ZA5mBQOcvRP6tM+IzWwb/GokRDkOg4xp
	9nQoxHiLU5gGWi5TWV1C7164Rj+EEuG7q+1T9J/dkjZRj5EHzUZe1DMY+emhVsxkwv+9KH
	Ppnrz7TxXWhNZODFjAmBzk4LXlAJnYI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hg9t7M7y;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IDMW7CBAbRVu3DReKyJ3tXIFVRCpnWKhvXJ2ha+0SM=;
	b=YpCyJxkEuzn2IT9pCQCRhChNEgpPdnTutyes3+h4Hu9lgXpGMys8K6wMny7t6o87gNMgRX
	DrZLD0u/Oja2J/xZsFhaxRErmdQ9j2Mt9MgntDUet+SzogJILUZLvtKFWoKhg8SLDQPhiz
	1G/ePAW52ntOQHPCwYsRb7vDNYOgoAs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761182528; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=2IDMW7CBAbRVu3DReKyJ3tXIFVRCpnWKhvXJ2ha+0SM=;
	b=hg9t7M7yFy76BfnX8wwq797179BQ5U/alsEYSDuMkFPIyd+anAJeXr+PhPVp1tCYIBw3s0a7QBQVWDhr/jsf37JMxg1A4+orIpQOsa7bvyuoYuMA0t60iTtGqYDI/RyNfvghAHzl2BvfsWpGVXpTQgDTiqS/oo5jMYFV/NMeTtA=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqooiVd_1761182526 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 09:22:07 +0800
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
In-Reply-To: <CAGsJ_4xhJSLnXOZy4kPmnif5Paq+OPN_Ww+rPk2WO4-ADSC0Yw@mail.gmail.com>
	(Barry Song's message of "Wed, 22 Oct 2025 23:52:23 +1300")
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
Date: Thu, 23 Oct 2025 09:22:05 +0800
Message-ID: <87qzuu1kg2.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7w5pez11fs15xmtkqtaifgcmcx4mgons
X-Rspamd-Queue-Id: 9773AA000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761182531-61081
X-HE-Meta: U2FsdGVkX18tPMXtM18eCEWFGEionXIyTngDE1bvV5YhT98H+eyaHOe+us/W14Z/O3GsRnHqXrchsnaizJn+TZO4esz8oBuB6m/Uml2R+xPEbZVVDvCtyT649JpCJJrmXK949Rez2+gd4sBfldXHeXmf1TKZAsnmL0ROUKUsm2+psqCBilp3OcuZvfLDLFT0tPnQ+tUAuunHZOONGI6FBr+aCudyRMFXCKr/42Dx2SNnDllL5HxBvzyPYpzyf1QoXFepDjCJHKRCNKL/Fkjgi8Z2GTeduGbuUJK8iczelRHwdJx5VvSEUo5L+E/2zZ/X9E0KNHk4sPOxwjxaq4QORI7TjVQ/HUmXUBhaCqyRCBOxq1UW6gX++cR96KArPVL+BkcSecyCjvgsWZ4rTYqy/CpVTRpvXCXxHvWIR4ghE/WSKfj8CS/HzUolebZ0Zq4Kc9eYCAdnEduOx2d5ZgD/YK7ORr21hTFbDe37sVM/E/phObbibx9D4/StWI1jKGq+cjT0Kert4Cd2n37DGrUwVxmU0mR9bvTwiiZwFAoxgrBnLBNO+aWkJ8hU2ZfJld0g0JgVbkInJp11gC7ZhzTQ/eT2ZKof5YgZbtsqTHFl0zCF57S4s3Wu//+tZO/0rqXlpQrDBhm9hWBiwRE/dBQzNdWx4yVT8M6uIqDpohobwwn8C6isyUNWA7q6SI5f4j/62TrWYgXVRHy3NZfykVH9Hcof+m/l3jLI/QvyAXyQiUE17m3t5ZCxtfxKIWw+w8XrRnwyFACuVcejOUVOLkElB+4WkhDatbeYThjVSANi2t6gpZOGT4Pff2s959MiWAFIql6hIPwZksc1TPDQdAgy0QM5xODe8irSJxwBDorOQ0AqnaJev/m5ObjIpERs9N52MHMlJvqZzoYxG4jAo3+1JFR1itBInB9swRrqymL7JKoH+2m7ukVB1O28OSpJ5i2XNT+OVdG6EyUjPKI6PTU
 hd9GFRPl
 fXQ+BhPj6JXQO3OYonjIiMCfNm7myk/6+v3G6L/EotxIdS++95Um7Ay1YdVfC2vF9nWd0riI9lk3XeghfAM3yQuSLZuWLAdJ0Z7sxdJAJRvrY/jBNs7ejkwahHewjKEFcshBCONwLO4KiJAfe+CSFdbJaISJirXfoad1kv0rzE0oVhYAZiQxwhoswVJq2t38e8KHrau+e8nekqLFUbkTFkrZqhvsSucbJtlTvZUZAzAmQTOADNFoPIEzZa+cyUdjm2so3HUsUuUqtl6qI3mm54DJOE9Snuug4byMYvpl+sEmShsOFmV9zkzssGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> writes:

> On Wed, Oct 22, 2025 at 11:34=E2=80=AFPM Huang, Ying
> <ying.huang@linux.alibaba.com> wrote:
>>
>> Barry Song <21cnbao@gmail.com> writes:
>>
>> > On Wed, Oct 22, 2025 at 10:46=E2=80=AFPM Huang, Ying
>> > <ying.huang@linux.alibaba.com> wrote:
>> >
>> >> >
>> >> > I agree. Yet the ish barrier can still avoid the page faults during=
 CPU0's PTL.
>> >>
>> >> IIUC, you think that dsb(ish) compared with dsb(nsh) can accelerate
>> >> memory writing (visible to other CPUs).  TBH, I suspect that this is =
the
>> >> case.
>> >
>> > Why? In any case, nsh is not a smp domain.
>>
>> I think dsb(ish) will be slower than dsb(nsh) in theory.  I guess that
>> dsb just wait for the memory write to be visible in the specified
>> shareability domain instead of making write faster.
>>
>> > I believe a dmb(ishst) is sufficient to ensure that the new PTE writes
>> > are visible
>>
>> dmb(ishst) (smp_wmb()) should pair with dmb(ishld) (smp_rmb()).
>>
>> > to other CPUs. I=E2=80=99m not quite sure why the current flush code u=
ses dsb(ish);
>> > it seems like overkill.
>>
>> dsb(ish) here is used for tlbi(XXis) broadcast.  It waits until the page
>> table change is visible to the page table walker of the remote CPU.
>
> It seems we=E2=80=99re aligned on all points[1], although I=E2=80=99m not=
 sure whether
> you have data comparing A and B.
>
> A:
> write pte
> don't broadcast pte
> tlbi
> don't broadcast tlbi
>
> with
>
> B:
> write pte
> broadcast pte

I suspect that pte will be broadcast, DVM broadcast isn't used for
the memory coherency IIUC.

> tlbi
> don't broadcast tlbi
>
> I guess the gain comes from "don't broadcat tlbi" ?
> With B, we should be able to share many existing code.

Ryan has some plan to reduce the code duplication with the current
solution.

> [1]
> https://lore.kernel.org/linux-mm/20251013092038.6963-1-ying.huang@linux.a=
libaba.com/T/#m54312d4914c69aa550bee7df36711c03a4280c52

---
Best Regards,
Huang, Ying

