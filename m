Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EC6C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 06:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3666B007B; Fri, 25 Jul 2025 02:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173E36B0088; Fri, 25 Jul 2025 02:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089E96B0089; Fri, 25 Jul 2025 02:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC2606B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:05:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94A30133AE3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:05:21 +0000 (UTC)
X-FDA: 83701749642.26.0E0459F
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90F6940008
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:05:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WYu8qtSJ;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753423519; a=rsa-sha256;
	cv=none;
	b=iDKETdE5ahYjnIH+9CeRCpvykX3dTi1/7kmVMUKSqqlKSyr0s+gqcebpBYXtDX+QYQM7wt
	mqVDtooWXFr2OErwYA9ld1bxImFHmU7uDgPWWxv9bECcbGMVeaMTsuk30xFEmr2lxmnI6l
	tgnxwCI6RwlE/JA+QUlRAiWAglqkPGA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WYu8qtSJ;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753423519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNe1kuAKXpbr7W/PL4R47yQyd9hjp5RPvJ0TgvihILc=;
	b=PikTwb5pzVDgQsGZjeC+vFJ5o0lkP3XIaERwIBs1CBHYVJ5L6wQ4eZkMS+61Y3e2O95mL5
	O0L5Plw8GBe34muer3rGlYZV7lsa+XabXT3nolgntM+xcJUtwVfo/7gAmt3vGzqewD/JiI
	Ro/vmSb5stDnrZ0S1LAbLaxKinpFrM4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753423515; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fNe1kuAKXpbr7W/PL4R47yQyd9hjp5RPvJ0TgvihILc=;
	b=WYu8qtSJD+xCYeU1Uaz+fLphjurL3g74yck0m01zTMrSGk217yYCz4NvO2b/uCPWBi+gSTBwmcAjG866Jfcf8d2l8eQPWSk5X27ACoge339zPn+Togr6rRC/11WqkyxrS0qu3n8KdpFzNSPKGODcsdwaOnrH2iYOwLBnE4zPWQY=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjwLJUu_1753423513 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 25 Jul 2025 14:05:14 +0800
Message-ID: <0c9dc2fa-34c9-4db5-bea3-af4caf05ee6b@linux.alibaba.com>
Date: Fri, 25 Jul 2025 14:05:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: regression - mm: shmem: add large folio support for tmpfs affect
 GPU performance.
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>,
 Patryk Kowalczyk <patryk@kowalczyk.ws>, da.gomez@samsung.com,
 baohua@kernel.org, wangkefeng.wang@huawei.com, ioworker0@gmail.com,
 willy@infradead.org, ryan.roberts@arm.com, akpm@linux-foundation.org,
 eero.t.tamminen@intel.com, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?=
 <ville.syrjala@linux.intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <CAJCW39JCDX6_S2Ojt1HMmX-h_qAKm2eBRzxX5kOHNJz60Zu=vw@mail.gmail.com>
 <d5c6ac93-1af0-4093-afea-94a29a387903@redhat.com>
 <63b69425-2fd1-2c77-06d6-e7ea25c92f34@google.com>
 <3f204974-26c8-4d5f-b7ae-4052cbfdf4ac@redhat.com>
 <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com>
 <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com>
 <dab283bf-a9cf-30be-02ed-da0d7c8ffcf0@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <dab283bf-a9cf-30be-02ed-da0d7c8ffcf0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90F6940008
X-Stat-Signature: jp7i683sxpbmfrhawjcgbfpwpu634647
X-HE-Tag: 1753423518-303598
X-HE-Meta: U2FsdGVkX18m5U6jKpPGvpAPjc6/CKyj+PgHA9aJZBGcw4FAqiG37Nnt19LnlsRSsXD4tjf6xzKzR8J90qH63k1T+ddW4satuk53BrxDX6Jzmnrfck3sJGcB7e1g4U5G58IIzo1SiXQQ9HqTwakEeUbHXQdV7WEJL8rrlMUUa+OuIhkIoLKFZprpVRt00arNTPGbpcpGLjiK9JD/Df5HkHZKBOwus/qhZE7ai3rsdCZkTehJ89Sdp+6lv0DUIzjpdQ6Hi2NqXxkFjn6nhsMSmax23E/vOm0X2x0FrBGc5CJM5wHs6gDHZQTiH7DVWVtVXa7la8rEnhjaR4QjJ4B/B/HH5AJWP6uSY8nynvDRvYRzdZykmG4CCDi67STREKJcGmRvLvBORk+yfo3/5YnbD0SuSv7UYyGYjYd8urXWUztD3mFYvefeqUcOOgAQivp2SSb7kGoiIDanmTJm39mCuR9s3kN7GInoSl9AN9IeOg6Idvm70NfqAEUsrtNmi7x3Y3M3UBHW/me2DbDr//p/aRZrPFYc7jZ09WDEFQrx2y38pXIrxmenq9dq/DN5FCB3whj80XQSuNnxv0blImcEbJ9zqxUk8V4x3G92NwICKJulm/+8HTXo+vKv90gcJJkpQszuob4Jjzm8WmQfVYM/T72XIrsPIVepOdKqvXQFfQ/g4ctCrwLV3W/AZQVXbOBF3gdw42Ekah4xcfu7lHLiipErVrB0J/eFjPEAR8HTexSc3MwUk+DuGgeOKbV1czryPP9i4wnadseFgV9bh/zXE8dH4527CoVkhylJbSzWOYizy+EWNSRJ2ZULxav4NB5PdtCqQjiGGLjN8tAYye7AAsNQ6EZ1gRheLP4g7fTWKMWnA5S+oHbHu06bU0VLPMm4eNDFJ3N1M1TbJVzqNjjE7XEUGYxlDge+SQ9WVqVqOVVvcPYDJgXwQ+ZCi4So3V2NH/fPzZzE+9KMMeAwkz8
 5nT5/0rv
 UqX7f0sR4x8yCPAjcC58TvyISgSFTRHGO5pgGh4nH6f5l2f5E9y264vWqN7HxVkNFtx4ybm+lnlmN93gbGI6eM/SyuhcHrVny2Ozuvn8lTd2D+uglNZ4woTabeuwuUPDWiRtcG4pOwIcWalYqqB5nymiwIwoKdv7mnkLK2695fOYKzbwjGw/TzCSj1QfPNUtQZ3YsLyWDvzuTFqs3z4UrUgVMPDq1hevWAF4mxlebTwnes2iDeABWo1Rcqz3nGiFAtsbw1ylzX7KXOU/IXuAgUBZz9stqdE7Jicd51INJ/gX471APwEFklzB8Zd2rgC0bNTjb1g3tXU5Cum+wDJqUogm8nTQ+gVYw+LCamPH7+PyYMOI4ei3iYEPE1suFmc889yPe/oU4pSYMIxSPNnWJDk5NYOASxNbGArxiMvp5QwR2n44P/vACZ2mMmw87XeT90HsSgXYN0Byg99k0Vnh8DZh55wrA8QFRuZ1v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/25 12:47, Hugh Dickins wrote:
> On Fri, 25 Jul 2025, Baolin Wang wrote:
>>>
>>> I hope to correct the logic of i915 driver's shmem allocation, by extending
>>> the shmem write length in the i915 driver to allocate PMD- sized THPs. IIUC,
>>> some sample fix code is as follows (untested). Patryk, could you help test
>>> it to see if this resolves your issue? Thanks.
> 
> This patch cannot be the right fix.  It may be a very sensible workaround
> for some in-kernel drivers (I've not looked or tried); but unless I
> misunderstand, it does nothing to restore userspace behaviour on a
> huge=always tmpfs.

Yes. Initially, we wanted to maintain compatibility with the 'huge=' 
option, meaning that 'huge=always' tmpfs mount would still allocate 
PMD-sized THPs. However, the current implementation is the consensus we 
reached after much debate:

1. “When using tmpfs as a filesystem, it should behave like other 
filesystems. No more special mount options.” Per Matthew.
2. “Do not let the 'huge=' mount option mean 'PMD-sized' when other 
sizes exist.” Per David.

At the time, we should have sought your advice, but we failed. The long 
historical discussion is in this thread[1]. So now the strategy for 
tmpfs supporting large folios is:

"
Considering that tmpfs already has the 'huge=' option to control the 
PMD-sized large folios allocation, we can extend the 'huge=' option to 
allow any sized large folios. The semantics of the 'huge=' mount option are:
huge=never: no any sized large folios
huge=always: any sized large folios
huge=within_size: like 'always' but respect i_size
huge=advise: like 'always' if requested with madvise()

Note: For tmpfs mmap() faults, due to the lack of a write size hint, 
still allocate the PMD-sized large folios if 
huge=always/within_size/advise is set.

Moreover, the 'deny' and 'force' testing options controlled by 
'/sys/kernel/mm/transparent_hugepage/shmem_enabled' still retain the 
same semantics. The 'deny' can disable any sized large folios for tmpfs, 
while the 'force' can enable PMD sized large folios for tmpfs.
"

Currently, we have observed regression in the i915 driver but have not 
yet seen userspace regression on a huge=always tmpfs.

If you have better suggestions, please feel free to point them out. Thanks.

[1] https://lore.kernel.org/lkml/Zw_IT136rxW_KuhU@casper.infradead.org/

> Please reread my comment earlier in the thread, in particular,
> Passing a new SIGBUS xfstest does not excuse a regression: strict PAGE_SIZE
> SIGBUS behaviour is fine for the newly-featured mTHPs or large folios,
> but not for the long-established huge=always.


