Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF06FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046006B0088; Mon, 27 Apr 2026 08:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39136B008A; Mon, 27 Apr 2026 08:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E269C6B008C; Mon, 27 Apr 2026 08:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D046D6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:56:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71E3E16018F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:56:44 +0000 (UTC)
X-FDA: 84704335128.11.BFFEB28
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 252F7140005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:56:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bW4vgcK7;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777294602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+URdhFKjGzMvMSRmjpUoghA1XThJExmfB2vNvQphk6w=;
	b=nGTTvCICPoL9wm+2bq2289lhKLoO2+ZbuWpYjcWL8s343HZgwfU4qoaC1RhWswKAlj6a+e
	UidTsVhuC9mxVL315LL/wGJp2p4dItz96S5Hp/m35lyx6KaftofHBq0Dg+WIou0wn+Upqp
	ykzDesNcrdstgqowU9tmsPXIlJcFPpI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bW4vgcK7;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777294602; a=rsa-sha256;
	cv=none;
	b=nnkm1QMVr2dYISviq/NeJu/FRbrnhUN/5/OxLhYLximuBDhko+dItIZNh1I+dnU3GaHs2p
	KaRuDEJM+o3yXCeQFsjQ7CM6TH4HB786NOayBwFjW0todPFRw/6ugXFjEfQfBDJIuPDKqj
	ugWwO2x4VczIuGL1TY/9c9AcP8eycN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777294601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+URdhFKjGzMvMSRmjpUoghA1XThJExmfB2vNvQphk6w=;
	b=bW4vgcK7Wqcb3k/PGw61yZXNKv5IA9CU2GnHp3QWbxK96XhI7HYzs00MNversZC/n2yFSm
	QKkX7phMjKY9YfNmTl5rS+hZ+ncXTKRcb5bgsl8nht26WrbFzwjrGYGlErXRMm6nAuWRTu
	xVGSGSvTVDOC8u+xhjmHM9E4PeJ83zM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-Yj7LPVqlNlu5OB8M-crcQQ-1; Mon, 27 Apr 2026 08:56:40 -0400
X-MC-Unique: Yj7LPVqlNlu5OB8M-crcQQ-1
X-Mimecast-MFC-AGG-ID: Yj7LPVqlNlu5OB8M-crcQQ_1777294600
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d3ea68b9cdso1952106585a.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777294600; x=1777899400;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+URdhFKjGzMvMSRmjpUoghA1XThJExmfB2vNvQphk6w=;
        b=UKouyKmrasSRY3xOC6sXO3TFs/QYo7ejbW0ZaEASLuQ9zGjGeUKL3ZjBjcyaXD9Zkj
         BXhscY6RCqRIRuFSBz67xnBNy/RrfO/G20uTlV5UCydAr4WIQEbKiPkiSGyjBHoW0uPE
         eJi1Sk6OCEc8zpfqz7i3/HHK98/oylIbwt5tdlfi14zGYOFP0j5DCCTcrvVtHyz2JqMD
         P3Wfjh2xAtqO4+qQnbdhA+A/UQypIg+W9oQ4AJ+rYgI7MvEqLC78N2YNaWbQXpiBBBBP
         Nib6LgBMkklvrfI6/YIXBTpV4KdfboOaOuc0Vvyoej3TpfY6/49Ss22Cez9CxQlhLi63
         liFA==
X-Forwarded-Encrypted: i=1; AFNElJ8a9FZDTOPO0OzRFc/a06loopH5wwiHUzMz5MpUPpAEktMh3UbF/rRsvuz07oaSmS37ZXimT6o2KQ==@kvack.org
X-Gm-Message-State: AOJu0YybtwfSS6KWFw1fNdqQsw78LanpsKopTnNVN3MZPqhUZDpU9X0N
	Bz5uVG+X1HT+P8Iw1ZmQgprtr1yjlu8WEU3FDk1uhGMJe+szu0LxOvf/+y3WRiObrhKferIcrYD
	v14nfloIPHRrNyt+y4bDq63yehKysMwLG6IC29244CaJUPPKkD2Yf
X-Gm-Gg: AeBDietQI21QpBOtCKh2IekOSZm9a4pzne8ordm8g7RRw4KbPPLw/eT6XqNlabPqyR/
	qdn1Cdxnaqdg9jb4Pj92Ay5wLXnvU+3eTft6Y7uOstued71bDSP/r4illCEyytMJwvNxFCBUXjQ
	/z1pcLsS+LeumZXywXocPR+4oVvwQJi/3fauhctu/U4ssYuFWdUGqCuSrVv9kVu5gtanUWsoVYa
	YHM5A9yIJC+lwGEjH5RaIpbWPjaRP3qRKfgPn6JIoI5eAXPQw8C5bQKDGQRkqKiv4UfeO0Ls30j
	G3I0TD0B4TqkGQvQQEzC50CRCGp7vPJTy2I1RfjfwR8Ii+dOeu+FNy/vN6iV1GpulC4F+QaboJF
	MV0pQn+wM2K3E5/bHingvZLLk3pStMyWKqeag
X-Received: by 2002:a05:620a:31a6:b0:8ee:f43a:bb6d with SMTP id af79cd13be357-8eef44a0499mr3559421385a.57.1777294599740;
        Mon, 27 Apr 2026 05:56:39 -0700 (PDT)
X-Received: by 2002:a05:620a:31a6:b0:8ee:f43a:bb6d with SMTP id af79cd13be357-8eef44a0499mr3559414585a.57.1777294599047;
        Mon, 27 Apr 2026 05:56:39 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aa4f1f9sm256378186d6.0.2026.04.27.05.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 05:56:38 -0700 (PDT)
Message-ID: <67d7b067-97a8-4600-a9a6-46f3e797ffed@redhat.com>
Date: Mon, 27 Apr 2026 08:56:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Donet Tom <donettom@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-44-rppt@kernel.org>
 <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
 <ae3v1cyMLbcvJtYW@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <ae3v1cyMLbcvJtYW@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J3GAh6ZnpiQEd2-u5fb9nMQpmz8247bZwY4tkCwbfho_1777294600
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 252F7140005
X-Rspamd-Server: rspam06
X-Stat-Signature: snj75anqnxrgrwe1q1tbgopbmbyq7qte
X-HE-Tag: 1777294601-694747
X-HE-Meta: U2FsdGVkX1++2yKw1CT5rsn++EkY6trU3cDotqAUqCz4EFrl2bSzpPzATJD1dGStXmm1IB5HBWN/wVC9Xx8cRgemwUyS7oE+oZGDXqBmlvwezbnQOOwIToTH58WGSpKcMJ/LpxhLONoZq/PQSTvaSU5827u7zxarKbM22bfQc5kGBnQMmJEhBH1ajHwNGDpkTddXKSQp5AuJuVexkjBJx+MVF/0tKc4YtiDZZaGn6u5Hel60G8d7wzzRR7dzja+3xn/oxhwaSbfpTY7/2oGaB2rBrWug++8l61qYWCdKedAXmUzXiaGeAB+ygNN9xYJM6rVTKN6XXg2QqEQ2zXDkNnLi1g2BToMwqlIJifsBWNN3OKV6Nr6RuZcEWsGZDFQTQe4Wiz8FzxZfmDq+xRTl1xWaxhRCPZ4dmRfxTnM+xXt5nrttPlfKnkGCNu5SutjWDS4SjLQYoD1jNkh2jYgHADfh+AkZ8YsfqMOrkoIy9QEn/0Ja7TIJJksI8I86CbadUeTmSUn5rcoy0AJJ0pyixnx9V8nyq4fPom60jiEUqpOPFiRkQl/xoFZgPxX3dKasoSrNq+PGpEBgS2ZxywWOkxHXmkpJR7b74Pvu6bDpP43qPAtjbuDX1kxdb/YS4+A44zkAOIlVMZPp8xCeT+Nb2blbVoLrpCWnRZuHqCgWXIrvba5xpWfUnUh3jjCz3bOpkIAztl0KRffQPKBgvZQV0aKqquQfxXpnNGBO31196mUBiGa2NQM0znOiIqkCf8dU1BImMhDRr5FKVAcVgB4VbDVMIb6YY+8iAx4qY6axdM8rO70oa5f7bOWe3mTCo99w7kIHgzEZf2IBZJk2vmU/a7+he7cKp0bV3VEpbJ7nU9KCr78f2jvUaz5OAj6gGdT8rGLMMqp2oenyJ0NVyFf8/Z87PmG4kBziUHiS+2aT+AYJrQWkOBe3UHGa23BWKQHhwgUopVXr+YGVymfuRK8
 fk6OoSpu
 d62PZnmE2YOURvyoU8kgnBqLCuMNvJcPGdnn4/OSXCei6qYIUVr+8US3/jb5A2H++rMMOYLEhnCodOjZWZ75Jp1hkHRZ6Kxiwqf4h5jcc6Zclety8W/uFszRMOdxEJ5vSqmW37fOt6DDTHNpiEpO4HpAjnSAVeIdvFx0nLSQr9b9IrlXRCer+3M40RWzpzhhbL5Qi7H4kIjEvo6x+wa38mT6rlqTcpPGsdBUOiEEIFozKyOhigfjOri/cSBbrXOY0F2z4dWjpOE7Et90aozCEnpxERc22XmVcLOYzupwIYFbD03x/7l/TdosACIluN7ryhmqrYqJyN33SKHexKSimyWGGZbW6Rx2YNBT99lt3HGIKWhC+FwvCpAdfVMBkQBqlK4r74Q9Zx+Yxfu88d0T8QImCKq2cOFVyZd5ZUzi0gou6fBV4dh2fGtGe+S1Ct9Q2SmwkvcrJGQqVLK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-26 06:58, Mike Rapoport wrote:
> On Fri, Apr 24, 2026 at 01:11:45PM -0400, Luiz Capitulino wrote:
>> On 2026-04-18 06:55, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> migration skips HugeTLB tests if there are no free huge pages
>>> prepared by a wrapper script.
>>>
>>> Add setup of HugeTLB pages to the test and make sure that the original
>>> settings are restored on the test exit.
>>>
>>> Since kselftest_harness runs fixture setup and the tests in child
>>> processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
>>> that runs in the main process and add verification that there are enough
>>> free huge pages to the tests that use them.
>>>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>    tools/testing/selftests/mm/migration.c | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
>>> index ccf42002ce86..61fb00953f83 100644
>>> --- a/tools/testing/selftests/mm/migration.c
>>> +++ b/tools/testing/selftests/mm/migration.c
>>> @@ -23,6 +23,8 @@
>>>    #define MAX_RETRIES	100
>>>    #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>>> +HUGETLB_SETUP_DEFAULT_PAGES(1)
>>
>> Hey Mike,
>>
>> I've been reviewing and testing this series and got a reproducible issue
>> with this test when running it on a x86 KVM guest with 88 vCPUs.
>>
>> The issue is that, when executing the full MM suite with
>> sudo ./run_vmtests.sh -d -a, all 6 migration test pass but it doesn't exit.
>> Instead, it gets stuck after this output:
>>
>> """
>> # # PASSED: 6 / 6 tests passed.
>> # # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
>> """
>>
>> Getting a backtrace from gdb I see:
>>
>> """
>> #0  0x00007efd2f2c247b in __lll_lock_wait_private () from /lib64/libc.so.6
>> #1  0x00007efd2f26fa88 in __run_exit_handlers () from /lib64/libc.so.6
>> #2  0x00007efd2f26fabe in exit () from /lib64/libc.so.6
>> #3  0x0000000000404f2e in hugepage_restore_settings_sighandler ()
>> #4  <signal handler called>
>> #5  0x00007efd2f32f416 in __unregister_atfork () from /lib64/libc.so.6
>> #6  0x00007efd2f26f338 in __cxa_finalize () from /lib64/libc.so.6
>> #7  0x00007efd2f4548c7 in __do_global_dtors_aux () from /lib64/libm.so.6
>> #8  0x00007ffd66ae0320 in ?? ()
>> #9  0x00007efd2f55b2d2 in _dl_call_fini (closure_map=0x7efd2f5500c0) at dl-call_fini.c:43
>> """
>>
>> Could we be messing with libc internal state somehow? I also get systemd
>> services hung when I try to reboot.
> 
> I don't think we are messing with libc internal state, but we surely leave
> zombies around.
> All the tests that fork() terminate the children with kill() but they never
> call wait*() to collect the exit status.

Right!

>> Some of the migration tests fork() and then kill() their children
>> processes. Won't those all restore the hugetlb state concurrently
>> from hugepage_restore_settings_atexit()?
> 
> Yeah, I missed the kill()s :/
>   
>> Also, for shared_anon_htlb, don't we need to reserve a HugeTLB page per
>> children?
> 
> We only mmap() a single huge page in the parent, the children don't create
> new mappings.

You're right, I missed the fact that the children only read from the
page.

>> And there's another issue: when running the migration test individually,
>> private_anon_htlb gets skipped. I guess it's because the previous test
>> is restoring the HugeTLB state:
> 
> It could be.
> 
> I pushed the updated version that has the fixes for both zombie and
> signal issues:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=mm-selftest/v3
> 
> Would be great if you can test it in your setup.

This works! Both issues are fixed: the migration test completes w/o
hanging and when I run it individually all tests run.

One last question: should we munmap() the mappings in this test? Though
I understand this goes beyond your series goal.


