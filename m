Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC8DCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B7E8018B; Tue, 28 Oct 2025 13:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3198013F; Tue, 28 Oct 2025 13:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720BB8018B; Tue, 28 Oct 2025 13:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED2D8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:13:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DDC34976C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:13:29 +0000 (UTC)
X-FDA: 84048169338.22.E0CB5B9
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 555F68000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:13:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bETZ7msn;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761671607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJHlxyWxpDIMG0ImD4DSen3qTXT0kex5+xGl06qdYJQ=;
	b=uokmtUXKa72/mcHmvxJSUZQDq0qE/9qdNsvOaDvbbNg6cUTNn9MGiiqi5zUD0MfniUKet4
	t5SLxjOVkVXNl/l8zufHvK1d48Sk9tSbQ7GkVJ+KHJsK5pGlBebAsEbnyGSk+OA8PQ40uH
	lnHritmdC7RWhAO1X6yJjCcJ0qUb8zQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bETZ7msn;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761671607; a=rsa-sha256;
	cv=none;
	b=AJ1pHSLrRuuYwOU1oIEe4MUNUHQjgD6iGgwBufifPzRg0urenyd1ukScKxZdANSjw1tjgL
	hczwyYUpBHtsp4XKBkaYVIprnPkznOQX9ajZ4diav+Bi2kzcLXY7GurBA+3UU2vj0w8uXZ
	pR10vrmOsHrmBoxbT5/njOsloDg+WJ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761671605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJHlxyWxpDIMG0ImD4DSen3qTXT0kex5+xGl06qdYJQ=;
	b=bETZ7msn3crSVDtk07snSuCaX4ndFvUlInJPywBUoH+JIAJhjbKmUSZJIqg2qqdHjuvlDo
	zoqTeXodQ4w+M6M/xBvrQB8AkZwUFlYk8+OLNV0DWxbLUJX70grRsKw+15OC/oNxfNXGmr
	dN/DtW3MiI+c4hlgK+6JpFFbM9WMePA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
 ast@kernel.org, surenb@google.com, mhocko@kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, andrii@kernel.org,
 inwardvessel@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, martin.lau@kernel.org, song@kernel.org,
 memxor@gmail.com, tj@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 23/23] bpf: selftests: PSI struct ops test
In-Reply-To: <ab8c7bf2f312e150c22d83e5ebe91e17f3c4be42b3ff0825623caf3aac4086af@mail.kernel.org>
	(bot's message of "Mon, 27 Oct 2025 23:48:28 +0000 (UTC)")
References: <20251027232206.473085-13-roman.gushchin@linux.dev>
	<ab8c7bf2f312e150c22d83e5ebe91e17f3c4be42b3ff0825623caf3aac4086af@mail.kernel.org>
Date: Tue, 28 Oct 2025 10:13:10 -0700
Message-ID: <87ikfzuezd.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rbw7ksze9jw6ycexoboezhnkgoebbg4k
X-Rspamd-Queue-Id: 555F68000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761671607-456006
X-HE-Meta: U2FsdGVkX19yyC3izAH7nk1oadBJ75wkSV2ZrIWFt/z71LkJiEmrNkiEyqW8tI8n99gQbEerTu0BTRckhd3JH2Los7yCqW4UplsE/+TwVakj9ER7APemsgSwvQFUZeaF/DsyfKuzY23xenzq8INdz8yIimDcAj29VfchsfjWRyQ9nEolm1SWjn2gmrvKd451tpC3iI39FWD9lOoHeZfHwRES/7mLjlP4ZWRChmKL5Z/EzwrNiJYySmEANAJZtGpD2iicTCOgxk2Cw8kJeAVUPatVVuXEgwJewdhXMWc07m71+4Yw95SCRDT75WzI/AY9v1V4hk2RuRrnFJ1ACfiyfHkJnBrvZGTGsJkstS7/zhbah9H0vdNJrHySXQfJuJ3naW1nDzLddVRtRdwlN1Y8xl2zYcCeMyEwV07XJv65eX6Yg1EfhAiu00zXMKHhmLtP20FVAAQd3okNKiNum810HoIapCNVghUGLm7PB6gm3VmkAgSVDq4dixBL9TTALp4EeEuC5QlD8o9cEno6A1+iqfHq6DuEZWe2B8sTYcXt8Chz3hLYNm+anIJKyVbUEo1LY2z/x5ysoNkzd7C6b3e31S+NI/MuTYfCwkG7ALH7nI0zW4Uh4k40nupMd/pr3LnNQmrL/OJsnMBon0OLVUQA8r309cCspzNiaA15Zo8dy6rZ9WLpF6/2Z1leWdfG1MWADczIgoXtJg299Juqyw4cEREmjZE75oLwjBVlSXmrceyaNOMopITRVTlQ57J9aNeIxhBkIkj3Z0I2vQl/UMAp0QP6b1RdvLd+7OQuuhrnuGsq4J6JrlWN94SaTBeByVYZ6/7Y5Ix4NVMfFVrAIhiVQVYlSTuxRF00tclnYDBEW68/zUfmsB48+HlSvfWsJvs1P4Aew0QI2MLloScoGTS+1vfYOCmViAh/mcylBmKhvbMMnzXKC4mTXsoH/lEPqsT+xfiBnMx7CgL5NHVU4LI
 Kb4o/eXh
 j0bHttl1OcUyhbkuAbBbVgE30lQrngX97eLB+s6wA2nPftmYgst4TNQ4QbwHgipt1KdawokJ540uyuUT0j623jkDtk8sKH2A/DKEUSGC3JL+oKLy3SPjYe5eoBRnSc0jKIPx2QF9R4lGT2hzYOvIXbZddnujx3I8dYaL6Q5tonw/mUlmqGnNBvuRIIkUaAwCRXy3a8wZJrLnmVDArcBPYl89AtQMlC5uWOVC0BKNw13YjVfLur6GfRFf4d2f9Y3Df06n1a7StZiXnxU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

> ```
> commit 70a4d534559f5708a811241190cd158e83451a42
> Author: Roman Gushchin <roman.gushchin@linux.dev>
>
> bpf: selftests: PSI struct ops test
>
> This patch adds a BPF selftest for PSI struct ops functionality,
> including cgroup lifecycle callbacks, PSI trigger creation, and
> memory pressure event handling.
>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/test_psi.c b/tools/testing/selftests/bpf/prog_tests/test_psi.c
>> new file mode 100644
>> index 000000000..b294cea0a
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/test_psi.c
>
> [ ... ]
>
>> diff --git a/tools/testing/selftests/bpf/progs/test_psi.c b/tools/testing/selftests/bpf/progs/test_psi.c
>> new file mode 100644
>> index 000000000..4ddec7ec3
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_psi.c
>> @@ -0,0 +1,82 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +#define PSI_FULL 0x80000000
>> +
>> +/* cgroup which will experience the high memory pressure */
>> +u64 high_pressure_cgroup_id;
>> +
>> +/* cgroup which will be deleted */
>> +u64 deleted_cgroup_id;
>> +
>> +/* cgroup which will be created */
>> +u64 new_cgroup_id;
>> +
>> +/* cgroup which was deleted */
>> +u64 deleted_cgroup_id;
>>    ^^^^^^^^^^^^^^^^^^
>
> Is deleted_cgroup_id intentionally declared twice here? This appears
> to be a duplicate global variable declaration - the same variable is
> declared at line 13 with comment "cgroup which will be deleted" and
> again at line 19 with comment "cgroup which was deleted".

Correct, fixed.

Thanks!

