Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B37CE64002
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 07:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A046B0088; Sun,  5 Apr 2026 03:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B066B0089; Sun,  5 Apr 2026 03:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686D96B008A; Sun,  5 Apr 2026 03:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59A5C6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 03:34:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E626BE2210
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 07:34:06 +0000 (UTC)
X-FDA: 84623688492.05.11B86C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2AF7DC000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 07:34:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYGBvzgC;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775374445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WslJOWO5Ut2wLcHjWMRdwyiWb2cD6c8UCdWWzX20V8=;
	b=lBHaLmUVR1JsITUlsODNkRXEY8G4j67gL8SDr1iJHZuWuY7IUhnlsQy6nbIUetVVmFG52L
	aKddAkpXwAeMr8IACqNh+gtY4x6JJtHk/Nos6+I3/QaA8qxMExmr8J74vTyn71gQeiyjKA
	v6SaRJyl61/UoMR1lVJbaXsBSD/+QPo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYGBvzgC;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775374445; a=rsa-sha256;
	cv=none;
	b=yKmi3ZGJkyoH4hC0zBFo0bnurn1BeD7zXuO7JIa1GYNjzltdIdMK3QDVICLvl565tiGftG
	HWsHbLofi8HYhXX98ZtxxdZq0flGaXfZ3WoUpdib/whpzCcTUX5GbdKyD7QiDT3cuFDB3o
	YZsK8dnLP1BhXIfJrl1kUZg68DKFXWQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16DCF43F44;
	Sun,  5 Apr 2026 07:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E61C116C6;
	Sun,  5 Apr 2026 07:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775374443;
	bh=Nfu4Tu+OUsT33sDUmIovSpX5KSqFMsSDTkbmrb8J+pg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CYGBvzgCralwJZXcb0Y2UZClDnlHuroFvQBjHLNkJVVS4+pnQhVEG3V2staNu5jrd
	 IkSKhRt2bkZr1QbF0CxiNYkZCxNPn1F5nOv9euSu8Xa6OKn0LDTqz2zk0xrTB9Uk3A
	 RuPCMW4ps6khOcWMXhEWISemaOHClc8Gk3onWUelkzzt2GggfHsK5JdBF2Spj+wX7l
	 RfCeJ3cVhoQt+G8lagbhV/qnb0nDvti3Z3+8amQxWikfEEq9zlr+uCfLdSDNfEtAgQ
	 z+LHlM9iZRxwW0X18KeNCPduyfa9lS2ZkbfonX5I40ePeYjjuDewHgU8DAXyRV734y
	 JzxZjk2EMqdjA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Shuah Khan
 <shuah@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Usama
 Arif <usama.arif@linux.dev>,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v3 2/6] selftests/liveupdate: add helper functions for
 memfd tests
In-Reply-To: <c783bc1b-3327-422f-9191-11550513b13c@linux.dev> (Zhu Yanjun's
	message of "Sat, 4 Apr 2026 10:53:47 -0700")
References: <20260404102452.4091740-1-pratyush@kernel.org>
	<20260404102452.4091740-3-pratyush@kernel.org>
	<c783bc1b-3327-422f-9191-11550513b13c@linux.dev>
Date: Sun, 05 Apr 2026 07:34:00 +0000
Message-ID: <2vxzecktc13r.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2AF7DC000C
X-Stat-Signature: eiw6ohytrh5ss5t1oj1z6ukbid8akz7d
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775374444-587235
X-HE-Meta: U2FsdGVkX18PIFfTiVoGJE73RzeddRfbVFssRWEK/S+ETWdZU6aBGI7frjlZY4B9Ot4sRtK3ojzD/M/Hvw5fwH7DJ2f9V/w3HIU+lgL9cqDnP0Omw/pViOsx3eNTBoYTY03bgXDL3Vfew/U433UIrolTwo4OO1/+pITI0z6a/esFE3bLhZTn96yOz+cZcZYm24N6MTfKHBPLHRPZxe/Zvjh2HqoUZr8nuCkPNYtH5RtJrhB8C+RCtZrDHLIy07nqMRYcJS3QWmjaUaqrPQRHxzAMLSJT2hduHVA4r3bzjxQYGlNfbvD3A+6WtwJ857VK9Hgsh9WTQ7B73plKen1sLAmk9VgbGLT1G+MtTjTrI6QUWmzMoLrcw9M5nVAxaUi06W/5lssaAsOvb25uM1A+Nu9AKlIjZnHyMnQfheyHNZnp0F019AXILvJ+pENyTj1sKWFbXdMsBCdjGvUkdAqaQvI1WZW2w9I/Pu5u7cLkznDBUVKweLUY8hSjSnQWYI6Pk5VE57+9PBT3QoDvRkdm+/evDt7zAZRTYMJG2xPyTSudi2qKKjnq3Ia5i1E6zqD2QCU0tOzHB5VzYeMKsuQSACgNjJ+bTP+zefdjaVWWUp+cMaXPkSgQw7G76/Y3qgn/zdriqbkNvGucdib4rcld8OTHYuSduBnxADOnWFDsyJgcwiMSMFjP3cgjpIzB5NacQGY4qZHqasAljkXgQ3fK20sCKrze36Yw6OdqF4dDQGrfKg3mHCiVUJ+FQr+GyRobTrw/sTDsWL/CPu1X2fABvrYCD2lk148oL/YlDfQFme/Bn5x/fkuvFHUpumaCx1p1Af0ODkoDfGnxM4LHj6QOpNYN5LcVJkgqM8uIolcAADwiigPY4Zmu+y9OI+b8LslR4jFDce5nTbb61N2PXcyggIqY5avK1FKZfTJUDsN9cHfJAsMERPnaTL1DyvTSVTpN02z8M7kwE1pPpWDBaGS
 Z9b2Siet
 CMZL2Y8LMEB9mlS96Q+i29uZ5LBOpbK0DgPUlrAU1XPY3B2I+wlKidWOeblc1yu0b/1UR25f6weh1XQPdFwC4uHwefQyY7+grbxLeHf/aLWdQzTDa5jiyrQlUdS4Oxmtw2bNnHUtkyrrTJraLOX9A3wL3Kj8YBu/bRm/naE1TCxt7RNXK1H8+AXQFy/ucYlKuYx/LTYoLEwbCUznYwvDbRS+zfQ3NKGQVdHZdgbPom7oOcFQL2SJI4XpW7gfyXWxqekYmW+RlaypDasTc4q4nSfiVteXwCs6WcNO5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 04 2026, Zhu Yanjun wrote:

> =E5=9C=A8 2026/4/4 3:24, Pratyush Yadav =E5=86=99=E9=81=93:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> Add some helper functions that will be used by memfd tests. This moves
>> some of the complexity out of the test itself, which results in better
>> test readability and less code duplication.
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>   .../selftests/liveupdate/luo_test_utils.c     | 191 +++++++++++++++++-
>>   .../selftests/liveupdate/luo_test_utils.h     |  10 +
>>   2 files changed, 200 insertions(+), 1 deletion(-)
>> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c
>> b/tools/testing/selftests/liveupdate/luo_test_utils.c
>> index 3c8721c505df..ceb918ef9813 100644
>> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
>> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
>> @@ -1,8 +1,12 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>>     /*
>> - * Copyright (c) 2025, Google LLC.
>> + * Copyright (c) 2025-2026, Google LLC.
>>    * Pasha Tatashin <pasha.tatashin@soleen.com>
>> + * Pratyush Yadav (Google) <pratyush@kernel.org>
>> + *
>> + * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
>> + * Pratyush Yadav <ptyadav@amazon.de>
>>    */
>>     #define _GNU_SOURCE
>> @@ -20,9 +24,194 @@
>>   #include <sys/stat.h>
>>   #include <errno.h>
>>   #include <stdarg.h>
>> +#include <sys/vfs.h>
>> +#include <linux/magic.h>
>>     #include "luo_test_utils.h"
>>   +int cwd_is_tmpfs(void)
>> +{
>> +	struct statfs buf;
>> +
>> +	if (statfs(".", &buf) < 0)
>> +		return -errno;
>> +
>> +	return buf.f_type =3D=3D TMPFS_MAGIC;
>> +}
>> +
>> +/* Read exactly specified size from fd. Any less results in error. */
>> +int read_size(int fd, char *buffer, size_t size)
>> +{
>> +	size_t remain =3D size;
>> +	ssize_t bytes_read;
>> +
>> +	while (remain) {
>
> while (remain > 0) ?

I don't think it is needed. bytes_read will always be smaller than or
equal to remain, so remain will never go below 0 anyway. And while
(remain) is nicer to read.

>
>> +		bytes_read =3D read(fd, buffer, remain);
>> +		if (bytes_read =3D=3D 0)
>> +			return -ENODATA;
>> +		if (bytes_read < 0) {
>> +			if (errno =3D=3D EINTR)
>> +				continue;
>> +			else
>> +				return -errno;
>> +		}
>> +
>> +		remain -=3D bytes_read;
>> +		buffer +=3D bytes_read;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
[...]

--=20
Regards,
Pratyush Yadav

