Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB07CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 15:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42FE6B008C; Fri, 19 Jun 2026 11:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF32B6B0092; Fri, 19 Jun 2026 11:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C312D6B0093; Fri, 19 Jun 2026 11:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0536B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:04:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A36D4049F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:04:26 +0000 (UTC)
X-FDA: 84896983332.23.E9D9F91
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id F30A51C0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:04:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=inj5HqnB;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781881464;
	b=4YHtsNE92XH8R/hurwaAVEHlSHUUmFX/YNeTJSNyMcZ2FzdMSp2BouUpks7cmX20FSlC+s
	UVLEviOOOwzRrxLqzZWNQezfww7FW8D8vMl+hXF5npBkE8GegpCEPT+a8oaoGfgUrulMhF
	yHWk1uo+wwJm7DUoZJZUBrocxh6freg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=inj5HqnB;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781881464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBBlXVrD3NPDLFZzq2oQ+CAHti+Z0numdAbKW0pOS0g=;
	b=SBrGY6YgsH3SBARMI73sP+OmScS6E+Fpjh/FqqBqJ6SHKVlCZNSyKaL7+ZYyhy1z0o7CBX
	RdA/YsMc7YSM3flr2U+udS/qqZYzNzGjJtDavztlTmG7J6t/AKposjcvySE1upBCEOjS17
	ZPpGwFyNlxrPTAtM7A/C12XPZsQwbxc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19EFB2681;
	Fri, 19 Jun 2026 08:04:18 -0700 (PDT)
Received: from [10.57.95.87] (unknown [10.57.95.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 508733F763;
	Fri, 19 Jun 2026 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781881462; bh=KVPM8oTe1yjPB2sYuDI6/O8b4PeAra3PYXJMker2JLI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=inj5HqnB3HLhB+ZOcTo+EJb6Yle1ZdReFsOucB2IoDGXAbl402HqynAjesZJ7ZyUI
	 PKZezIX9nr1MxzU5+AYZf+R+ik28jyuv824kIAM0qOe9q6g2fYVmakv5qlPdd8bxb+
	 k/7AG55oSfmVoe2C82dT4actPwK5wN9OxP/3jGVg=
Message-ID: <160f8cdf-0d26-43f3-b487-4181e6374782@arm.com>
Date: Fri, 19 Jun 2026 16:04:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Content-Language: en-GB
To: Lorenzo Stoakes <ljs@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Alex Williamson <alex@shazbot.org>, Anthony Pighin
 <anthony.pighin@nokia.com>, linux-kernel@vger.kernel.org,
 Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
 linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org> <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org> <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ajQDVAu9b-LX8gUQ@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6unahycqyxdjw6bed46pii8mgwgj5n13
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F30A51C0005
X-HE-Tag: 1781881463-7162
X-HE-Meta: U2FsdGVkX18PQ1O3HYdJ8i6JBEpFy04eM9lwNLmTHkfpq7/hZl6b5+5+cP9wLnPqucs1T9lG64g7y6cO56aGH0rw35DsRTPe07MGKr/+IpXMBE9VA66tjceGeEzhkKf05VYJCblR+uRfIIMnfVmQq+XH/fOplAUihN8vw8XYsrjIrV1lDfybdihbjwU7ABrkEDS50/irp65rk/Tbi9ptqOqG46jjXrfATbn/nDNdD5W3ziTF7OC2Cb5bhaG4fQ3dVT5+qInD+4K0BdHE2JfJeHXHBirdmmcs7NLnE4I3ewwdpcCkiY3j9j72tgDuUbmwFauFZfTT0abZs3Soopc+pAMfayFhHcMEQUSfBaAEGfIuMofXo0EG961sijWxHRDk+KTd28lbpr72JDBEao4+6RUnTA7WtkcYTfZbNa78I7vR0+nReaX8YD/1HBfVa/DMQoEFgSaF5kACYMLF+gLSnNCnqbEl9tMcpBzW0WoJTVhPxmWoTl8qAYPqQZTuSb8JBwwJPSAUlJddpH3MVPeGOIyOMoihCWLC5LWmWDUTpof8ve1p4T1Nxl1fDUoAAuGcYFanUj11MAD+LBlYQKezGogD8fr1Qhtb8MRsE1P2lYILBmMH8FllR2yHTHyEwJLGF30g8TIdMd3bf/wK1UDf3p6kGxC1gnyP5lqcnODwiRrb63iH3lvVtdw4ngriQRkSt7ggsD0V5y0+PfpbsSJspAqqCPDcuUIi/jAknOWorxkWpfIW7rU6zClMatLYzifhujmd4MgNjNdZlzQ7naUohpuksFqrxF44JJpgwXvcwEbukgE2/yD+d5RdiDocoD4u7lwuxwW/zhnkrWF+a+dbcCVU9QVY0lmolNFlO+eAorSg7yXpD4i6J7B+LKxMA9IY8R5zxtOkQUUKl0H+0Ij+rH2V/twb1DLxNup9felbN+ULmqBvmg+8ey2hiBuP9Po+xxTrBsDHbg+u0w+UgX9
 SIBJpULh
 2CEM6PMecNTFi0I4Sh6PnKMzNT9oDCAjlXyje+zhfsWV92calRVZZszc1Y3IsmGcWgmdB91NtsyDBuGyTuT80Z1vYiBjIAczCmprUA2Ehuzn1yKLk2sASN3OJ/WlCG1f4wjUdrzHZrqprl4zGyRh6wrUnEUpaoSQRBAPRqkRN2kOnDw4VTUK9cvJZegieBmb3RckM+P+anCxxsDWT1PYPZLjAn+Okv/lTT6rKAhgDYWJV6WQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/06/2026 15:55, Lorenzo Stoakes wrote:
> +cc Ryan for contPMD
> 
>>
>>> And maybe there's a CONTPMD architecture we should also consider?
>>
>> ARM HW supports "CONTPMD" but I suppose it is not implemented..
> 
> Maybe Ryan has thoughts?

Sorry not quite sure what you're asking so will give a generic answer:

Arm arch does indeed support CONTPMD at level 2 in the same way that it supports
CONTPTE at level 3, as follows:

+-----------+-----------+-----------+-----------+-----------+
| Page Size |  CONTPTE  |    PMD    |  CONTPMD  |    PUD    |
+-----------+-----------+-----------+-----------+-----------+
|    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
|   16KB    |    2MB    |   32MB    |     1GB   |           |
|   64KB    |    2MB    |  512MB    |    16GB   |           |
+-----------+-----------+-----------+-----------+-----------+

For HugeTLB, Linux/arm64 support all of the listed sizes today. For !HugeTLB
(i.e. THP, large file filos) Linux/arm64 supports CONTPTE and PMD only. We could
(and probably would) extend to support CONTPMD once THP PUDs are supported.

Not sure if that answers the question?

Thanks,
Ryan

> 
>>
>> Jason
> 
> Thanks, Lorenzo


