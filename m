Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED8ACCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532728E000A; Wed, 22 Oct 2025 05:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2FB8E0002; Wed, 22 Oct 2025 05:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1B88E000A; Wed, 22 Oct 2025 05:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8548E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:46:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51127160741
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:46:57 +0000 (UTC)
X-FDA: 84025271274.09.2AF0CD6
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5F73C000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:46:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lejdTTWj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761126415; a=rsa-sha256;
	cv=none;
	b=dpPK8NfNlMrXBqJ3zSMVa7mcSDOyDIu5IgR8PEyXzMFTdzc5krMsytNcr8yhrqH6L6vyFg
	fkLUYk7cxQIXxM1Mh9bi9WsGdfEoc3k1rh13xzF7vVpJ0Gk7nytU+sZzNMabTIzmye3w7T
	6EcARWliZEbMCvFaUaJwK6E4XbDQp20=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lejdTTWj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761126415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leTG8eQL2d1TJ+ZkjUXd68HfBJsD5TPizgYkX6kdZYY=;
	b=ABLn3PWlbtCDYoDhY/x57rpB4UApmYlVrNGurDLraZqhaNe7BXXSvFOovrubuJtWJLEZOn
	PlNlQ9ixXPlksDbJa4ahkvTT9PfUmOPZzkH2M5pKGItXaOXHK72a66xg/RCmj7WydP+6H0
	Q8G4Ot6jeNXgNTqCNJbiH8ehd9JzWjA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761126411; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=leTG8eQL2d1TJ+ZkjUXd68HfBJsD5TPizgYkX6kdZYY=;
	b=lejdTTWjyOeDXaFrUZDxnnE7kH6QxLl3cYZr0eXW5EMBo2grkiWY4tk8ys2I8E1XjS6WRG7GyZFFeybipzt3NGzOQZkpjjwduvpAHddyEuJkAIAnJvjEGKJTxI9N14WNIarmT/WJPbr7Q3iSV5FAZO+Q1tGy5bLNRxPFRuZOCdw=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqmS8Fc_1761126408 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 17:46:49 +0800
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
In-Reply-To: <CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
	(Barry Song's message of "Wed, 22 Oct 2025 22:37:54 +1300")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-3-ying.huang@linux.alibaba.com>
	<CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
	<87a51jfl44.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
	<871pmv9unr.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
	<875xc78es0.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
Date: Wed, 22 Oct 2025 17:46:48 +0800
Message-ID: <87a51j6zg7.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5F73C000C
X-Stat-Signature: y8u3iic1yhri4sodqjzhmaqgijxtc74f
X-HE-Tag: 1761126414-693808
X-HE-Meta: U2FsdGVkX19aashcTLJxaSpcQZOiAkeSB706AEyDfdYf5y0/P24TU8/SpGZsU7cWyvZI0PhqEu76hWSx/ndiydHWTB595+AINiLQStIRmYzgphVrgdAXHu7LauI8AkmFXp0Thw/ES8OvZysiQ+5mzAn/4cxYK8pbz507J3jEeKzeHNYMo1rv3tCL0XQyBEwE+5UGaHRlpfRCUDp2nGic34mNNAkR6CaEiGdZQsH1IG4VPZklYkAHFYgxGKE3khRQZ1QcvldWkUy4HJPLe9IdUwZlS63k2yZWJz6agf0G+byhBdOO6pbs5ocyU+JDq30OiwmwG/10ZAAznZFIr5UtclV/6J+VAnkKO/21r46BnEkq5MR3kuOmKG70Sq1qcEHxPzNyKnVOWLiagsXewrDkZHzuYxcAhFhkLJ5Ss6JYrEr014lj4L2TwwRI7lE0tovMAWFvPLJTA9FDnRbguaMn/v3JBkSWeKRCMODVJ4TFfykjTnUBPdVB1xZJHx4TPtvubECRgXcrUIQVFT7IHFaE1tU8Nf14dvbbQn0KrcRv+DL/DcipM2wJn0RtOF372yy4RbWGBsiCVmmTj9xut40vvfSzSYUHIG1KeR9+zGVk61AO98Od3y1OrwpTEMuN7G6BRlt5zfSsL7bxV+WoFdjZHldCLBQ1cXS3hx6jhqpTtnHcla63yji08bvZilsPpLLkSzV6XB7XZDJEjXOQZoPr8n8PFaw9xD5oQsByR3ahOGsxtxtQAygnr9A/w9hUZtELRctgTd2MzC+YivrU2zvgBCDD2QPV0a5V+rDpWJMIjrGEW7rdxTZp8bb7YNU53WBK0Eb8a3C1ye1z5AOTL5ETEOBhKt77ZoHbWFaYFzmx0V+4cVn9VBnctibUeh31Hz3uEnsabohS3YmtvAVyqswCzibc2SnSOdFgcg78K1PH9S293wJFh0vGO115Om6omGP5MWBSewWQTjrAfWqcOdF
 iFxIOJKJ
 Ouq4CgmZzv5cNLYa7NtE5txOLtZbVxG808yz3IbyL6ce+W53EOJLT7AR7vOEr7tyf1xuAKyxxBY8ZBrO7TyR1ZHMTG6iJAERFw6006/vf4gGB0hRc1EAjsnEIPOzMMrIfAR7OyDErHI9VhUEs7NAGHN1N9uMgaV3gsH8Tlo9h5rfpbhX6pEdg33Ql+5er+1znmwMMgeSynP30Re+mfDnethyTP3Yupfd6Ex1ynXVav5CcN6EDmTaxMtL3NBj80HX+hFJ8qv6dMMAlnf06ZRhJmHA3C1LBDXtKlGBn+5BLFZfdeKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> writes:

>>
>> With PTL, this becomes
>>
>> CPU0:                           CPU1:
>>
>> page fault                      page fault
>> lock PTL
>> write PTE
>> do local tlbi
>> unlock PTL
>>                                 lock PTL        <- pte visible to CPU 1
>>                                 read PTE        <- new PTE
>>                                 do local tlbi   <- new PTE
>>                                 unlock PTL
>
> I agree. Yet the ish barrier can still avoid the page faults during CPU0's PTL.

IIUC, you think that dsb(ish) compared with dsb(nsh) can accelerate
memory writing (visible to other CPUs).  TBH, I suspect that this is the
case.

> CPU0:                                                                  CPU1:
>
> lock PTL
>
> write pte;
> Issue ish barrier
> do local tlbi;
>
>
>     No page fault occurs if tlb misses
>
>
> unlock PTL
>
>
> Otherwise, it could be:
>
>
> CPU0:                                                                  CPU1:
>
> lock PTL
>
> write pte;
> Issue nsh barrier
> do local tlbi;
>
>
>     page fault occurs if tlb misses
>
>
> unlock PTL
>
>
> Not quite sure if adding an ish right after the PTE modification has any
> noticeable performance impact on the test? I assume the most expensive part
> is still the tlbi broadcast dsb, not the PTE memory sync barrier?

---
Best Regards,
Huang, Ying

