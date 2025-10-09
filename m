Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC3FCCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 23:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6168E007F; Thu,  9 Oct 2025 19:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ADF28E0002; Thu,  9 Oct 2025 19:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3728E007F; Thu,  9 Oct 2025 19:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6318E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:12:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8DC6BD29D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 23:12:31 +0000 (UTC)
X-FDA: 83980126902.02.C3B904C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1B453C0006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 23:12:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XeP1ebEf;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760051550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0b3bpB7s8l8nb1j4Ch+52gcGrqY0BNRSvWR/Vc+228=;
	b=R43vRt2z5nrZNI+a2EAICA6JgrphdhEndGzGvSVXJE83i9e4zoA8A5nOZMK4o1UBuSlxAo
	XlKPR5vHDnD2+KxTvoxx8OJyp5yLj4kFO3qDSpSfoZkVafRB+fTsK0lS3oUsunhE3SBJ1o
	i5ZpJjQ1ufOy5ewqfJE/KhwRxIGYM1g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XeP1ebEf;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760051550; a=rsa-sha256;
	cv=none;
	b=Ij1MGittBJ3G9eigXV6to4eT5gpZQmTFEbfZ3EIuy7KLD0kA3l2sn6/0waxevUgsiJaQ1V
	6ns40ZB70qk85UHPg2m7R2SYQYzEmIbFn/btGTg47PZUWxnZZMnCyJamj6Tf5Lf0R+PBQL
	Cr3Lsc43EPNSWOqFKVshYpa6OltBGGc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 222A262448;
	Thu,  9 Oct 2025 23:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CC8C4CEE7;
	Thu,  9 Oct 2025 23:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760051548;
	bh=Z0b3bpB7s8l8nb1j4Ch+52gcGrqY0BNRSvWR/Vc+228=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XeP1ebEfuiBjXqjcQeevK44aYYYNeTPG/dcoQip/pJY1CJsfvQmUvwxWR8TNIbmu3
	 z36uH+8M6e5FiMhWm56P8q3P7UXHY9OZEViMS9l9btXwcjuj8eSzNbAruipDfd6FJN
	 vlRIKwOHkFvj+jxAPSMsy204E2OiQpuXIhrtcc3RhDGIpX72Rod947g6w6DU5r9OOQ
	 bzt5gxSc9tT/qBiShwr/7Wfj1PhA14WAm1o7J5CKUeuwXBwWiPjaxeBguiDXZ1FIjN
	 TlM0rkP5+LHhf3rWxBlRA0hc51d5O4r0wAydJblwvKFjUqnzWRd3V4UMlxatBokmvw
	 kCvEfBp7JIY8g==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state monitoring
In-Reply-To: <d09881f5-0e0b-4795-99bf-cd3711ee48ab@linux.dev> (Yanjun Zhu's
	message of "Thu, 9 Oct 2025 10:56:33 -0700")
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-20-pasha.tatashin@soleen.com>
	<a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
	<mafs0qzvcmje2.fsf@kernel.org>
	<CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
	<dc71808c-c6a4-434a-aee9-b97601814c92@linux.dev>
	<CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com>
	<d09881f5-0e0b-4795-99bf-cd3711ee48ab@linux.dev>
Date: Fri, 10 Oct 2025 01:12:18 +0200
Message-ID: <mafs0ecrbmzzh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B453C0006
X-Stat-Signature: ja4e9f367szcg3p7uqzj13b88uzxkp1a
X-Rspam-User: 
X-HE-Tag: 1760051549-257276
X-HE-Meta: U2FsdGVkX1/CLYAPUGEj01vAoqHpc0a6/qq2Xd+/y3/HDV+v+18HdV0v2gPmw4TviIJBJjY21syIyrAr590h/+BkCRtvEDVitqosWYRvZli5gZkNNSaYzqAs5ses1WpybrvPYtyd4Akv+qbHOJrWNjV8ij4GD4ZDpItUrvTpWDr7G/YD7Uu2fr5kNHvyYiV54rLNP36H8hMyZkpNC0lgSdCCHxzK/joD9JRligrHPErfpf2tFLAPWVh/oOGus60ilhnzQ/43PuOtvfD3vMoGABHi5OXP3ksPme2TVq+iaeli+JR9cMMvnYKv4+80+AudRGIxRp3IHROUdGYB+mVoPXq/IVWD1GcGpUjT5mBOp4x4hgdgVMIkmw6ytRN2ZngHkzFY9iQexvnnrSRzKCzb3Go9N3kU0VMt6PqunbKxjEhR+VXK6ZybZT/6tgtoGNIRH541sctWhLmy5eFjDqkG8jZCgionAhH2agvIGD27Oy4IPLhspfdTSxt3GZCbKrWaH1FYaSVq8ZScria0gN/CTPfwRm4IhKJwzFcH1/5hA/E+cSDucEHzWvjHrcbhfYwoNyHUsQs+Uz1vJoSt+f6pEwSNXWLtW79nioJ7l27ZIkmo+QplBnunbsPnbvpOa7uKCjiDADf8nhOy4/5oghbvKlf1WVXyFNAgxmcbBa/FcepjZhNh/OknqjEZIJ0WhRi67meeKVRFjkZcLF9DBXpncqNGZ1gytmzkwq79xBM6zsr3D/hmaE4f3xySQPVnjDdsLWlccuoAcTNiluruAlf6xC6IIfpvDnCCmtkfKfLKed44WZ4Sxz5QPu2W7pqKUJYAm+k7FAVTPjXfVNRSpto413ZIsZardhVd3Cs5G5Uj5H1ANtZ4ng8DCCJaAE+3dZAuou6KI0cOFU8yjweDi/dP8iG6wxvwAwXI/vjqN1EkqDN9LwUmIdZNpgLJe441r7Y3DCCsedgxm0NaeWj0I+M
 6alp0QS8
 EXa/mvR98Y6pq5EINQrIm+q0ueOjMg0PF1AJEb2JQG64pd59DzdaFxh9y3Bd73hqI7HbAU6eA3zn/KeccQhotPD/0kr1VbX0I1hm0c97Yn4h6YmzQA1TYlVlis9SfrsXGGVZsD3sNe3JhIGlFLsIyO4KZUcI6jVcQ0Vh1gee7HA5IQOXvJ0x6ot9ku7LHqJzScTNuQCN2Vdbms6Bxvs2yhzMpdaPE1PyE/OlznuJM6rQnjBz1ds0lY/6hQYyrWGAeK1k6cXrUQ4J2qjziH/6awaEVyYv2/ag2poP3DCbrOr3ZZtRoM+VyDaO5VBSgAAro9Bdw/aWs9Br9BvLbcPifxUHOxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09 2025, Yanjun.Zhu wrote:

> On 10/9/25 10:04 AM, Pasha Tatashin wrote:
>> On Thu, Oct 9, 2025 at 11:35=E2=80=AFAM Zhu Yanjun <yanjun.zhu@linux.dev=
> wrote:
>>>
>>> =E5=9C=A8 2025/10/9 5:01, Pasha Tatashin =E5=86=99=E9=81=93:
>>>>>> Because the window of kernel live update is short, it is difficult t=
o statistics
>>>>>> how many times the kernel is live updated.
>>>>>>
>>>>>> Is it possible to add a variable to statistics the times that the ke=
rnel is live
>>>>>> updated?
>>>>> The kernel doesn't do the live update on its own. The process is driv=
en
>>>>> and sequenced by userspace. So if you want to keep statistics, you
>>>>> should do it from your userspace (luod maybe?). I don't see any need =
for
>>>>> this in the kernel.
>>>>>
>>>> One use case I can think of is including information in kdump or the
>>>> backtrace warning/panic messages about how many times this machine has
>>>> been live-updated. In the past, I've seen bugs (related to memory
>>>> corruption) that occurred only after several kexecs, not on the first
>>>> one. With live updates, especially while the code is being stabilized,
>>>> I imagine we might have a similar situation. For that reason, it could
>>>> be useful to have a count in the dmesg logs showing how many times
>>>> this machine has been live-updated. While this information is also
>>>> available in userspace, it would be simpler for kernel developers
>>>> triaging these issues if everything were in one place.

Hmm, good point.

>>> I=E2=80=99m considering this issue from a system security perspective. =
After the
>>> kernel is automatically updated, user-space applications are usually
>>> unaware of the change. In one possible scenario, an attacker could
>>> replace the kernel with a compromised version, while user-space
>>> applications remain unaware of it =E2=80=94 which poses a potential sec=
urity risk.

Wouldn't signing be the way to avoid that? Because if the kernel is
compromised then it can very well fake the reboot count as well.

>>>
>>> To mitigate this, it would be useful to expose the number of kernel
>>> updates through a sysfs interface, so that we can detect whether the
>>> kernel has been updated and then collect information about the new
>>> kernel to check for possible security issues.
>>>
>>> Of course, there are other ways to detect kernel updates =E2=80=94 for =
example,
>>> by using ftrace to monitor functions involved in live kernel updates =
=E2=80=94
>>> but such approaches tend to have a higher performance overhead. In
>>> contrast, adding a simple update counter to track live kernel updates
>>> would provide similar monitoring capability with minimal overhead.
>> Would a print during boot, i.e. when we print that this kernel is live
>> updating, we could include the number, work for you? Otherwise, we
>> could export this number in a debugfs.
> Since I received a notification that my previous message was not sent
> successfully, I am resending it.
>
> IMO, it would be better to export this number via debugfs. This approach =
reduces
> the overhead involved in detecting a kernel live update.
> If the number is printed in logs instead, the overhead would be higher co=
mpared
> to using debugfs.

Yeah, debugfs sounds fine. No ABI at least.

--=20
Regards,
Pratyush Yadav

