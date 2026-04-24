Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0CAFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0166B0005; Fri, 24 Apr 2026 13:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51026B008A; Fri, 24 Apr 2026 13:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40026B008C; Fri, 24 Apr 2026 13:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3ADF6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:12:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36840896E5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:12:03 +0000 (UTC)
X-FDA: 84694092126.26.B07A61D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B16761C0019
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:12:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aBX0w6wj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777050721; a=rsa-sha256;
	cv=none;
	b=jOcbUZumeI8J3a8biYdpzE48u/XsrpVlp5LLxDLyM9lANhKPaMMmD6whocdLU4fezpL8KS
	F+7qQ+Z9eonDU9nrUg4Vec+bs0sm2ky5PpSOXN/CuASNnZD/yozRyZS5+u4BKF2FLXL93l
	31nOeQL0bjRW5KcNpc7dml9WNzq2ByY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aBX0w6wj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777050721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slsp0uJ4UEr9asoG1EzUOVXbkiFCo43hgbkmPupcjMg=;
	b=uHxUvL3mZVXPonnkhFV4SLLnM1wwhGE2/wnoaIyMVs547r8M3LkfG/x8cu795rBdiatYFc
	s7p41/LV+AiyzKcLfD11KvxrXUiSzZ7cKbzFObHlYYcyBbIPmAYGAr7NkkwLYTEs/AOy5L
	/aDgqa48dmqMYT+egVN6l3mURGP+kc0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777050720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slsp0uJ4UEr9asoG1EzUOVXbkiFCo43hgbkmPupcjMg=;
	b=aBX0w6wjbI3avTuXEUbwGptA9tQ/tOqZ6zPkEQPvoRVoHGFoLoq2LgjpVRb6M55zMRM8Zc
	RZXQiJiTiFe7R8yp1881bva5hfjvkQ4Ps1a2d7/qciIYTc4+ENpJCNvd++AFLiyIxgZVmB
	1sooYXVARV5+VRqEb1YKazSae8dxZEE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-TRYjL2XoPMS8qu-Uv-J6sA-1; Fri, 24 Apr 2026 13:11:58 -0400
X-MC-Unique: TRYjL2XoPMS8qu-Uv-J6sA-1
X-Mimecast-MFC-AGG-ID: TRYjL2XoPMS8qu-Uv-J6sA_1777050718
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50fba8d8c40so51842991cf.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777050718; x=1777655518;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=slsp0uJ4UEr9asoG1EzUOVXbkiFCo43hgbkmPupcjMg=;
        b=rTbYcccVMtNoM06w8xxW7zhioTqiA3I6NB4gp+PQL4xnhgS8eRlI5RTi2uaebKg3tt
         plFLo3Bgb6JNQMXAhunVIWcLZx+VpzpiSwWfFWEtA0deWa57tPpStyelD+Bf/0VG3LZi
         4Wc3j+bBQ2gKkb4moVLDTVArYMxyOqcpUJqBKu9S+IshAFFO22/ZNvDBVZE7i4CEW9vR
         HpfS6aqh69iX9serT+7xJCYIQzh09NLYtqNEQ23MkAmyzJuhz/tq9xeW93l8VeKJyZ/0
         LPC1pJ7dFBLhPAme9yTknwQ7KYJkIH/TU1MBBE6axDOpveZUl95JEXCOlijfA1WDhIr2
         eP/g==
X-Forwarded-Encrypted: i=1; AFNElJ/spBao7G3VWq1iyTG8m3MrlLRA9FzGc0lyacBVZRKXcr9oXtBpVaL4ln7lNfQWkPdNrAJG74R93w==@kvack.org
X-Gm-Message-State: AOJu0YwEn+tgLc9zi1GNjbGqlNTjHVmXsfNodu7Xm/Vu75Vfc4Y6zmj9
	ZhzXx5CO0yXPKfd08izugY2/a/eHzsxsRvArOFTG/rRBvcXJmqjaip8/WgmFMooP4NA6e1cz7JG
	jr7RHVT3QI5X8jH7wSAk43oSSDlJ+pz4mKu7TlBzd7CUQauo3V5ze
X-Gm-Gg: AeBDietqt/Irje0aPXtt1iiyM97S4ZaMESgQyRHDDOCC3fzNW/LALfHZIHgb2zr1ts3
	DLV/eDjifUMXpEpro+lHCb8ZXM3F0cbZxwS7mcgy9D71bvs8cXpQY4FNBjbzDVoyt+SEA/kUqFF
	wczhkN1WvaWNKoU10wrTnq8GtXsvo3SdBUnue7eYik0U554YRRaGSd52yh0gpj3YjuGIgoK6aIB
	XaCu5AfFi/ugCuigF7FyTJFoDVoR0g6zSl6+cheByCPECpytGBQbaBseAgNfVCklx/dFBHc0hXT
	FW9RgwPRoLCF/k2onRBcOFk5bNauhDv5cBUGTa+hz1ZRezuIHoRgET2o6At6XMec+QwMzA4Qj+f
	fHudx7u19aVz5YqTJfDmXBO6wXRTOc5NDgy9l
X-Received: by 2002:ac8:5807:0:b0:50d:7c44:e144 with SMTP id d75a77b69052e-50e36b3ecaamr548956811cf.11.1777050717942;
        Fri, 24 Apr 2026 10:11:57 -0700 (PDT)
X-Received: by 2002:ac8:5807:0:b0:50d:7c44:e144 with SMTP id d75a77b69052e-50e36b3ecaamr548955921cf.11.1777050717311;
        Fri, 24 Apr 2026 10:11:57 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fb5fc8e04sm107117251cf.13.2026.04.24.10.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 10:11:56 -0700 (PDT)
Message-ID: <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
Date: Fri, 24 Apr 2026 13:11:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-44-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260418105539.1261536-44-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _ratfNEBNL2h-1gVh3e6UA0LSN_BF7H42ICm4lKtD4w_1777050718
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B16761C0019
X-Rspamd-Server: rspam12
X-Stat-Signature: n5b3ixfemx4whq8hu4arj3u7ftfmjc5w
X-Rspam-User: 
X-HE-Tag: 1777050720-236291
X-HE-Meta: U2FsdGVkX1+mLDZDNwFeC8JgIhT9CbP+tpi1nqMuNts29CZUr9DtEUI8xn13ohnvCK9ZDDSU39xnws19INEzkvOfauP3uYIDsvzsEQqEAywCIplSbZtDPJg40H1Ml2YUffPOsN+B9nSQ9aNYARqWOF+n5ZeET1SurbrtlmGcX5BwYcC88F8YfHnwUF3mc8T1B49kdgsfUHyLrrCC0IU91ILgMfo77ChQQIJFgEB10H8YCco//iNEE/nW+HjPfqTFrwo4j0tJ4AnJAquEZVwyhBavQ9WTFnhQtrjHfOVHthDFmBltcevhZs+eMCzZ+5GDXbIeCZTO2rW01doz9TCYDJeeVZzwaU/Aiuh6uIO/kbgDeFIpbgtDKINLJDDC+2K3vz6GMBFk2Qbs4wrs/sSXP6fcvuwo5aOPz0R+T/zy40xje7TIREh1QJzzKO+GOig4d1CvpSiBUYtfhvtoD5SctyKRk40Ps1M2qrlb4FcI11j3SLH+y94eoeBFQKTej7qmBhPvkqqQfvYRXXtPeedEhjEP+6GOHzs2NzHAx5CGfklCPI/Iy92V8oMR4i8ej8Pd72jhF+G7nrLEpt0tpra+Sm+mAZjiVFVHgo0n7bFUDhXekbcTPrH9pnmgSWeC9jJ4adN3WO2NeczpX8G56U/l4/uJTH4OtreuHkGu10brlYuAag5PkbzhpDjGDnMShtyy1c0qj0PXEOsuNIjWcRflPXNer2W0eGcxKdafhzTZH+EP1GMe91ZOlXJUYY4qY++zvRFA2vtId0OGdyhU3wIxMc3GMa20wfJIX3I7gB0t7qHYYiNLsK1ZhlDOggsmL+eaxq9pbslSfdRAphx38HNaEtZbp16rLunLohii0OfWJut4i3Ww8TmHOaT8SKY6ufwxSHQuy74cGwOjDzOYxAtZZ6urM+I+FEqfweFdYMS5vBhbmCFVuJACmlgGNoMQrelViy3VBnpE85UJqrWv4XO
 R3kR8b5m
 7zAyr1shyPfWfO9uhZHp45ZS+1B5uvUuznry9a0P6IpFkAFLd6y80DqMPGKuxCKPE8SiGTd629TOTMy9Aowb/aYzYpKTFZHVpiUpopn2arO+pe/fAodD5oOZilyCN9ak2+3poBOd/EJuIDIj9IoD0j4cgY2JU0e6FbETK1lvvEfOrz4MksORij8B8kknqszbpSi3QlSaTRqEYpsNJVP3j0Sp9NtPcAjULmno9yiveVoEhEIhlAVvaduL7UZmprMUhQgdSUmaOZpqNtTv2WOlLOYxNhpyxm2Sqsk17TS6+R0uJVz7eQBtkX8NReEUMRL+2LZHwTvow+Nvvl563bybSwRjzlJ4luO0jwRDZD0cxom5GjeldIAO/L4qICkn7ix4NAj5qFoFMKyrDwv+I6pl0tLSoB5bcS9aNqPR1Mq8Hta0gLQabUlzBgMCKiUPvwZQQ0zkavjj3gD06xmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-18 06:55, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> migration skips HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Since kselftest_harness runs fixture setup and the tests in child
> processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
> that runs in the main process and add verification that there are enough
> free huge pages to the tests that use them.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/migration.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index ccf42002ce86..61fb00953f83 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -23,6 +23,8 @@
>   #define MAX_RETRIES	100
>   #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>   
> +HUGETLB_SETUP_DEFAULT_PAGES(1)

Hey Mike,

I've been reviewing and testing this series and got a reproducible issue
with this test when running it on a x86 KVM guest with 88 vCPUs.

The issue is that, when executing the full MM suite with
sudo ./run_vmtests.sh -d -a, all 6 migration test pass but it doesn't exit.
Instead, it gets stuck after this output:

"""
# # PASSED: 6 / 6 tests passed.
# # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
"""

Getting a backtrace from gdb I see:

"""
#0  0x00007efd2f2c247b in __lll_lock_wait_private () from /lib64/libc.so.6
#1  0x00007efd2f26fa88 in __run_exit_handlers () from /lib64/libc.so.6
#2  0x00007efd2f26fabe in exit () from /lib64/libc.so.6
#3  0x0000000000404f2e in hugepage_restore_settings_sighandler ()
#4  <signal handler called>
#5  0x00007efd2f32f416 in __unregister_atfork () from /lib64/libc.so.6
#6  0x00007efd2f26f338 in __cxa_finalize () from /lib64/libc.so.6
#7  0x00007efd2f4548c7 in __do_global_dtors_aux () from /lib64/libm.so.6
#8  0x00007ffd66ae0320 in ?? ()
#9  0x00007efd2f55b2d2 in _dl_call_fini (closure_map=0x7efd2f5500c0) at dl-call_fini.c:43
"""

Could we be messing with libc internal state somehow? I also get systemd
services hung when I try to reboot.

Some of the migration tests fork() and then kill() their children
processes. Won't those all restore the hugetlb state concurrently
from hugepage_restore_settings_atexit()?

Also, for shared_anon_htlb, don't we need to reserve a HugeTLB page per
children?

And there's another issue: when running the migration test individually,
private_anon_htlb gets skipped. I guess it's because the previous test
is restoring the HugeTLB state:

"""
TAP version 13
# -------------------
# running ./migration
# -------------------
# # [INFO] detected hugetlb page size: 2048 KiB
# # [INFO] detected hugetlb page size: 1048576 KiB
# TAP version 13
# 1..6
# # Starting 6 tests from 1 test cases.
# #  RUN           migration.shared_anon_htlb ...
# #            OK  migration.shared_anon_htlb
# ok 1 migration.shared_anon_htlb
# #  RUN           migration.private_anon_htlb ...
# #      SKIP      Not enough huge pages
#
# #            OK  migration.private_anon_htlb
# ok 2 migration.private_anon_htlb # SKIP Not enough huge pages
#
# #  RUN           migration.shared_anon_thp ...
# #            OK  migration.shared_anon_thp
# ok 3 migration.shared_anon_thp
# #  RUN           migration.private_anon_thp ...
# #            OK  migration.private_anon_thp
# ok 4 migration.private_anon_thp
# #  RUN           migration.shared_anon ...
# #            OK  migration.shared_anon
# ok 5 migration.shared_anon
# #  RUN           migration.private_anon ...
# #            OK  migration.private_anon
# ok 6 migration.private_anon
# # PASSED: 6 / 6 tests passed.
# # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# # Totals: pass:5 fail:0 xfail:0 xpass:0 skip:1 error:0
"""

(I have minor comments about earlier patches, but I decided to send this
first since it's the most important).

> +
>   FIXTURE(migration)
>   {
>   	pthread_t *threads;
> @@ -277,6 +279,9 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>   	if (!hugepage_size)
>   		SKIP(return, "Reading HugeTLB pagesize failed\n");
>   
> +	if (hugetlb_free_default_pages() < 1)
> +		SKIP(return, "Not enough huge pages\n");
> +
>   	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>   		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
> @@ -308,6 +313,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	if (!hugepage_size)
>   		SKIP(return, "Reading HugeTLB pagesize failed\n");
>   
> +	if (hugetlb_free_default_pages() < 1)
> +		SKIP(return, "Not enough huge pages\n");
> +
>   	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);


