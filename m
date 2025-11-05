Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67471CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE76C8E0007; Wed,  5 Nov 2025 05:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE898E0003; Wed,  5 Nov 2025 05:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D41F8E0007; Wed,  5 Nov 2025 05:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD498E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:39:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25FFEC0287
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:39:47 +0000 (UTC)
X-FDA: 84076207614.07.40E6B86
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4213BA0006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:39:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=SXTGtxux;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf15.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762339185; a=rsa-sha256;
	cv=none;
	b=YzX370okcwd1OIfttz723XnnNCcn78gtGP+BF/M+5ViPdmAv84nAeT+UPIzKgHowN0pFvv
	lRysZhxjEhU8aZEG/WZgP63WghSnPLvNIgCwk7w/GuQxbDBju2C6gqxx4cFPqW+mnOw8yB
	/OUwkYQBZifk9J07EfLxCnHscMcetzc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=SXTGtxux;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf15.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762339185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZU25+bCLq4D6+jp/5EA8hJsFqIIvHsWyKp0ucrZ3c0=;
	b=m+lrAJGex54W2H6i+XCkD//YKcMNXvqUjMGq4UPwhVQwoHuladmWKNHcbpn4oymxZX7vEW
	sDSV2hsWKkHfiPB0LRZAPL4v9/N9Slw5eZTuC9E+YPV8N5slG1DQRIfc1qpAHjtHAmqv7Z
	xbvsy5P/B0ZdQN0hO5L4GmGEzr6snBs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1762339182; x=1762598382;
	bh=fZU25+bCLq4D6+jp/5EA8hJsFqIIvHsWyKp0ucrZ3c0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=SXTGtxuxL028rdm3htg4zrochHSggNQRjRRAqQAbc9AP9sPGuAPBaJ0esAdk6ObVC
	 f+6sEWVF4SEQ2NU0kmN6a+Lu7CqQeKAozRos0pvMBiASq3hhGanrim8FdoMFDTtE//
	 R0/HoCz2JOeXkLy57jfc/9b3ZRotC3qjHyMO2y3D61RjE4ZXTNWnoFyWMpHqsIzZ7e
	 KEnOFTMsJAPQmNy8FY2zN82YOrRf/Mih5oUnvJrSMF0o5CXGgSrvY7Rqfhr+rgKYJQ
	 8exk0bv2ajecqEdR2bucMgDV9r8F9iVV8bBjseM93A6PyNzEJr75u93s0HyZuveWuW
	 rH+mpCRh/PtDg==
Date: Wed, 05 Nov 2025 10:39:37 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <uhjap3ppoeglldgbu7wtsz57dqmtbntwfssnqfbsnkebni2mdm@7i67d3zoxqbe>
In-Reply-To: <CA+fCnZefD8F7rMu3-M4uDTbWR5R8y7qfLzjrB34sK3bz4di03g@mail.gmail.com>
References: <cover.1762267022.git.m.wieczorretman@pm.me> <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me> <CA+fCnZefD8F7rMu3-M4uDTbWR5R8y7qfLzjrB34sK3bz4di03g@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: c3c3d40e79cb1f13113d2e16d176828d0dc0a69a
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4213BA0006
X-Stat-Signature: o47hg6wynpn1814a6jutu6fhm9tkgkua
X-Rspam-User: 
X-HE-Tag: 1762339185-805696
X-HE-Meta: U2FsdGVkX1/C4DRBH+Eu9PogQOg3q7rgWl2bgzQ+3GX4kQiFzt3BKKRMONLwUfHl4ZgGtHjZ0xr9df9sPHs2f3xP32cCPKvILGNawP/kv8AdpYTvusH7loLs2Pje0sdOwuidEewSN+bqhS7e5R0UQoj8F94uVR36As09s/9dcb8+F3OBnSfZaYfv1j3Ye8GxNr5j9AOlnXDNDWvknT/TX5hW+X45QIKtjW+dXHGg0rbv+RCktHeo4LX4yX/CTSzSIj7z9lFQqyEpQgmgjr5cw9LfBLnDMJzSsKRAmaEeDr9mhI5OXyxS6Nkjxt64Exqk28wwl8RCPlqrsZ+FaZPtVcR18yb2Uu4JKor2GUgio9fqQW8v0H3+4TEFELt/afn2Fw/KVT8f7G644vxQYvZBCjsahPOLzqzF5clAOeD9/grbAdW5DYCUuF3KwWEBroF45s5y6TNcsZiuXTkpDMSEQNcDYXy6/Ken0hzpE/uqy3FwJYrplSTZwPWE/u0JIgxuTJHy1lnABIrQUMn+SB/OaDXzXwfefChypAVnT0diQRl8+ix6g6oi8mMy7ltEO4SIKfn63/hBVo+1zO9E2TVGUncxUXzIsqfZ+2B+wJs5vG7bdPMENkA2lM5fRmH06uHNnd9LK+tp4C9veY+osdZhqyKbBT9/NQxOM7MncNM/I2B0rW2qzOsQJjfTmlHmdomWpOHFTE5XaMJ2qAk9ziF9NzAVhn8qEpdmik6MzLnSL+kRKkXBngXIQX/NDsnvHpSadCh6f7/4jDffgMCtxLHOVzz2josRTqrx3zgEWpphnCjwKfH9fDRQQnjZP9eBjmLjIHZIyr/AILGNs9Ezq9r5894mtMCnJlsvzBdE+nX1RDb8hZ3meJ9lvRFdXazg/MUajRZzBWqnpombtq0jG0AYUYp4UmLEji6M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-05 at 02:12:49 +0100, Andrey Konovalov wrote:
>On Tue, Nov 4, 2025 at 3:49=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
>> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
>> It was reported on arm64 and reproduced on x86. It can be explained in
>> the following points:
>>
>>         1. There can be more than one virtual memory chunk.
>>         2. Chunk's base address has a tag.
>>         3. The base address points at the first chunk and thus inherits
>>            the tag of the first chunk.
>>         4. The subsequent chunks will be accessed with the tag from the
>>            first chunk.
>>         5. Thus, the subsequent chunks need to have their tag set to
>>            match that of the first chunk.
>>
>> Refactor code by moving it into a helper in preparation for the actual
>> fix.
>>
>> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
>> Cc: <stable@vger.kernel.org> # 6.1+
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> Tested-by: Baoquan He <bhe@redhat.com>
>> ---
>> Changelog v1 (after splitting of from the KASAN series):
>> - Rewrite first paragraph of the patch message to point at the user
>>   impact of the issue.
>> - Move helper to common.c so it can be compiled in all KASAN modes.
...
>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>> index d4c14359feaf..c63544a98c24 100644
>> --- a/mm/kasan/common.c
>> +++ b/mm/kasan/common.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/string.h>
>>  #include <linux/types.h>
>>  #include <linux/bug.h>
>> +#include <linux/vmalloc.h>
>>
>>  #include "kasan.h"
>>  #include "../slab.h"
>> @@ -582,3 +583,13 @@ bool __kasan_check_byte(const void *address, unsign=
ed long ip)
>>         }
>>         return true;
>>  }
>> +
>> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>> +{
>> +       int area;
>> +
>> +       for (area =3D 0 ; area < nr_vms ; area++) {
>> +               kasan_poison(vms[area]->addr, vms[area]->size,
>> +                            arch_kasan_get_tag(vms[area]->addr), false)=
;
>
>The patch description says this patch is a refactoring, but the patch
>changes the logic of the code.
>
>We don't call __kasan_unpoison_vmalloc() anymore and don't perform all
>the related checks. This might be OK, assuming the checks always
>succeed/fail, but this needs to be explained (note that there two
>versions of __kasan_unpoison_vmalloc() with different checks).
>
>And also we don't assign a random tag anymore - we should.

Thanks for the pointers, I'll revise the two versions and make it an actual
refactor.

>Also, you can just use get/set_tag(), no need to use the arch_ version
>(and in the following patch too).

Thanks :)

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


