Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DE7EDB7EB
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3926B0088; Tue,  7 Apr 2026 06:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B2E6B0089; Tue,  7 Apr 2026 06:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8326B008A; Tue,  7 Apr 2026 06:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF8E46B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:31:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CCAE13B56B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:31:04 +0000 (UTC)
X-FDA: 84631392048.23.BF971FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C55BAC0009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:31:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sECHkvtH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775557862; a=rsa-sha256;
	cv=none;
	b=rSHFZbdjoetkpe7lnnY6WgEZBoK2HI/r7ODvpQebUBp73HkyoegWbjYmcGAdu30uBxhG2s
	giALxo3IMXa8oFy8uAvIAtlfTD7vFxJOfiVKk0ZpvxJ4J9Dy28nY1yod0Y6wsW8Qgdzp2c
	DAvUPONMjjL7Q/k5tIyHxwaBP2TYNpA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sECHkvtH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775557862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Emv2PAaGEl0bPgbDOuEKzRBxb9CXektrzATbCOMYo2I=;
	b=10n4PVMW9Zp+5ujdUQDpdTKprHR3CUJpzp0YtmblhkV9X+v6WQhccI0NN+y5pGr9hKqY/M
	2HHKHcFkJmK/UCzLAPGCbJPGHZJnDAsmUq+wLpTbmwpGrVBqPEbAnfbFo/ddR2QsAXwMeF
	LkvDt5Flrt0pUjNtZ/dMSWZbiF3IA20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A07560103;
	Tue,  7 Apr 2026 10:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07A9C116C6;
	Tue,  7 Apr 2026 10:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775557861;
	bh=xnPiwWIJZOBJKDM3E43NKbF2H1Ltqj2Y7PvIumMZROg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=sECHkvtHNV1vu3xYEHaXdXfX1O8I+pbJISMQZvpGMKxILLhPO1wACoSBugIEdIFRG
	 HlHTPHfqhlHH+4i4LcFrSWcrb5nabh/qpDLYyhovcHWb2OFhKxNvMY9XfgfC8+1SBB
	 WGS00aiYdPz9XGsGM0dSnNhD8Ht5DKxqBXA3QuDYijFv2vvO8bfpD3rrpycCOU0PTF
	 cxiWxmkn5YtLkVnBv1eAb+N7ZJlNS/u+20fPiVzFrOmgMSIoINw4VPGHAkeCoFNxsz
	 kpwjRARM1QCToL32gs8kkGcDovkjxSVNJBb19/79jVvbUsI9yJCUQf8Kh2q1eoJgIW
	 otkqdv3sQnQyA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Shuah Khan
 <shuah@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Usama
 Arif <usama.arif@linux.dev>,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v3 2/6] selftests/liveupdate: add helper functions for
 memfd tests
In-Reply-To: <b7af6516-1593-4e2b-9149-fc839e2b88bd@linux.dev> (Zhu Yanjun's
	message of "Sun, 5 Apr 2026 09:30:17 -0700")
References: <20260404102452.4091740-1-pratyush@kernel.org>
	<20260404102452.4091740-3-pratyush@kernel.org>
	<c783bc1b-3327-422f-9191-11550513b13c@linux.dev>
	<2vxzecktc13r.fsf@kernel.org>
	<b7af6516-1593-4e2b-9149-fc839e2b88bd@linux.dev>
Date: Tue, 07 Apr 2026 10:30:58 +0000
Message-ID: <2vxz5x63awpp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C55BAC0009
X-Stat-Signature: 35bmpbyj11qieda5jzo5s3crs9jn7yfj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775557862-491876
X-HE-Meta: U2FsdGVkX183V6O2/mz80ojckOEsSwIv+y8MLn3DfJ30OaCIu0MF8m7C2XIEDs4jP8gyXrGNf8Uznc4uUVYOGPnxe4NSkaOK7aAVstJr39uNc3ZXl02a8MViGCGp2xuu1B95OD9htYdw5oRJ1Ndzffk79IYZsoxG+luvDpU0GpnXbz4y748i9kLCoBXmrRT/DUglip4rfY+Iuln61H+X3+jP/7znAP6kp3URudsyrMZlh11pF7KQVwrZSQOQ1g5mv4+6VUAY8X2EXGzTLoYha1qCvtgayOW3aKvk57cHjyz9C9Am3nc4bPTCOcgg+P47GnC0IiUqtZfiAt9ejQ2k4HuaXMJI9mH0gZ9MiFuGN6y+Li+MLLs93DzuSfkAPhY+KUDk5OGdbMAyMvZqFz8rjNwEdoAQgBA4EH+BbQzRxSiQVolhRKfs/jefPnJmQDMc+jl81ZmtN3PxvbkWD+h14mdjagHAyf4nYAEgZP+eUFc7mFIE+DjFp80CD/ex8VB4lqW0SJL8J+RWM0m6zuxT01rncxz5S5jT6xyXNiTl5msTErngaC2kYRRUX2mh3nojAXKDmHkezDN0YMWJeQnhaSDjux1G8ri020jdCGZDSpgxPsOiMc1nC4HmZTWqab1yRv9oH3tsw7LhcLsGK1yuX6zG7SJEqwUsA5EOB1I7T4KV/9CDGvyZcYqrkagqujCE/6wM9wdWuB81JBe1YdpPlazInqn1RP1/9802cSn2gW+Te3I1Z3Zfc6BiJGtyWoLF7Xfad/fCXrNa3TnOv4EyXFKrmgT24qKtGHp9SC/93GW01tY13Aem8sJ732CTg58xmbXc+JAwZCRqtrBTQbLq4NXs8UZSrnZdjCd29Y11ZN4gbM7j3Zj2MXuxRpxKyU+VsDNot/1iAEaH+jWIF1F6mTCtb8quVrHXuU74YuR9fhEqXWIseP+HNqDMllIsf9pKNZfndgNtGk0iXEuzV8/
 Pzy7MPE6
 Ng62fy7Y9AazmI8Apos3xtuyVJfDvyRJ3V7cUei1A/xILLxH2xFK+LSNb869ZE7KX4X0u50PJ+ROSnNJrqlWig6bcwME/RP3KFogRYB3gbljtUEbXLHRrFggwtTofpCwWwNyD/0hCvePFB/w4AQNH++5eOZaLFCkHhMiSqk4t3eRrrwulVHdrKZMfqg1R/5IEeL35QQRTnhKcPGrqgYmOEirZ9lag5Ghb3fiHAa0Un/yTsQLmirh3pMfXkOfShKqQyrPRC+ZaDt06CvQLQHOCcnzirPXvAa0N4826
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05 2026, Zhu Yanjun wrote:

> =E5=9C=A8 2026/4/5 0:34, Pratyush Yadav =E5=86=99=E9=81=93:
>> On Sat, Apr 04 2026, Zhu Yanjun wrote:
>>
>>> =E5=9C=A8 2026/4/4 3:24, Pratyush Yadav =E5=86=99=E9=81=93:
>>>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>>> Add some helper functions that will be used by memfd tests. This moves
>>>> some of the complexity out of the test itself, which results in better
>>>> test readability and less code duplication.
>>>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>>>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>>>> ---
>>>>    .../selftests/liveupdate/luo_test_utils.c     | 191 +++++++++++++++=
++-
>>>>    .../selftests/liveupdate/luo_test_utils.h     |  10 +
>>>>    2 files changed, 200 insertions(+), 1 deletion(-)
>>>> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c
>>>> b/tools/testing/selftests/liveupdate/luo_test_utils.c
>>>> index 3c8721c505df..ceb918ef9813 100644
>>>> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
>>>> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
>>>> @@ -1,8 +1,12 @@
>>>>    // SPDX-License-Identifier: GPL-2.0-only
>>>>      /*
>>>> - * Copyright (c) 2025, Google LLC.
>>>> + * Copyright (c) 2025-2026, Google LLC.
>>>>     * Pasha Tatashin <pasha.tatashin@soleen.com>
>>>> + * Pratyush Yadav (Google) <pratyush@kernel.org>
>>>> + *
>>>> + * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
>>>> + * Pratyush Yadav <ptyadav@amazon.de>
>>>>     */
>>>>      #define _GNU_SOURCE
>>>> @@ -20,9 +24,194 @@
>>>>    #include <sys/stat.h>
>>>>    #include <errno.h>
>>>>    #include <stdarg.h>
>>>> +#include <sys/vfs.h>
>>>> +#include <linux/magic.h>
>>>>      #include "luo_test_utils.h"
>>>>    +int cwd_is_tmpfs(void)
>>>> +{
>>>> +	struct statfs buf;
>>>> +
>>>> +	if (statfs(".", &buf) < 0)
>>>> +		return -errno;
>>>> +
>>>> +	return buf.f_type =3D=3D TMPFS_MAGIC;
>>>> +}
>>>> +
>>>> +/* Read exactly specified size from fd. Any less results in error. */
>>>> +int read_size(int fd, char *buffer, size_t size)
>>>> +{
>>>> +	size_t remain =3D size;
>>>> +	ssize_t bytes_read;
>>>> +
>>>> +	while (remain) {
>>> while (remain > 0) ?
>> I don't think it is needed. bytes_read will always be smaller than or
>> equal to remain, so remain will never go below 0 anyway. And while
>> (remain) is nicer to read.
>
> If a wrong number is transferred, this makes remain less than 0. Then thi=
s loop
> will run again and again.

That can only happen if read() returns more then the requested number of
bytes. That is, if bytes_read > remain. And read() will never do so
since that can be a buffer overflow and would break userspace left and
right.

So, I don't see how this is a problem.

>
> This while (remain > 0) will avoid this kind of scenario.
>
> ZhuYanjun
>
>>
>>>> +		bytes_read =3D read(fd, buffer, remain);
>>>> +		if (bytes_read =3D=3D 0)
>>>> +			return -ENODATA;
>>>> +		if (bytes_read < 0) {
>>>> +			if (errno =3D=3D EINTR)
>>>> +				continue;
>>>> +			else
>>>> +				return -errno;
>>>> +		}
>>>> +
>>>> +		remain -=3D bytes_read;
>>>> +		buffer +=3D bytes_read;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>> [...]
>>

--=20
Regards,
Pratyush Yadav

