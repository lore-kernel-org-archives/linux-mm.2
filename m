Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F176CCD18D
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC208E009B; Thu,  9 Oct 2025 13:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893928E0010; Thu,  9 Oct 2025 13:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0618E009B; Thu,  9 Oct 2025 13:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6D58E0010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:56:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D35C88662
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:56:54 +0000 (UTC)
X-FDA: 83979331548.26.B173D96
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C6FCC000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:56:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RG/PKOX+";
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760032612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQtDstGb3CyrZpeSWryCX/If0ajj/tB0us6K4GO5uRQ=;
	b=BzVC8trnNI6wt7MzV6kxFQwY4fz7Dg5qpJd1i28bVDsC/HN5Xa25DDZvqW/ecympxWh7p+
	YyIjDtKdcKwUFMITMpcHH2n8s/gfiLTbF1oboMQaJdbdkYwDBh1gaMjLqE668ySekq5YJK
	G1yxhVT1ekYNXNNcg8d2MhRlGkpKVSk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RG/PKOX+";
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760032612; a=rsa-sha256;
	cv=none;
	b=2Y4CbyJLoRwe7F0cbov0cNOfHlOnjGDr+Hb+D8tzd2g98p0zB2RRx16uW2QmpM8skMFgkx
	q3RmBbwIbYmKUAiOdKhp4FDCvdFusg77x9jCAwo8FmYRklZIkz6Y4EuqPrM6mca2gH1dLJ
	33vbsjU0MvYI942sap3SjfheBp3wloE=
Message-ID: <d09881f5-0e0b-4795-99bf-cd3711ee48ab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760032609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQtDstGb3CyrZpeSWryCX/If0ajj/tB0us6K4GO5uRQ=;
	b=RG/PKOX+b9dsfndKPbfywbTI44gZn77HEm5El0GYZFRJnXaZ96AlO6nHjLatm2rS78+wwF
	QXtEotKWbkSVW8f8eb6U1mr+CVTjybidcHrAro4XlxeF0d1q2x5FUfS4hf/V00ZmvJzTPH
	15lOKLt9DFUAB2FtRSdtZGn7XTbUs6Q=
Date: Thu, 9 Oct 2025 10:56:33 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state
 monitoring
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com,
 graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
 dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
 yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
 chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
 jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
 dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org,
 rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org,
 zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org,
 cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
 ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
 leonro@nvidia.com, witu@nvidia.com
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com>
 <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
 <mafs0qzvcmje2.fsf@kernel.org>
 <CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
 <dc71808c-c6a4-434a-aee9-b97601814c92@linux.dev>
 <CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1C6FCC000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ec7771f53rxwz7aqbz9aeagcfrmpc449
X-HE-Tag: 1760032611-431298
X-HE-Meta: U2FsdGVkX1+BbCBWutyyjZPXhYjNYFzjaxBrDZSYcJMbzv1E1fnFjCav8nAYdX1fSN+ah/er5QxtgNvll/WU5tYQO6jdfJwKuOWAL4xt4MbeN9MsbhU1nLetq6iHmXbhQ65AoDFE6jVBAm0S34SWL7rmwELUOiZSADiGNEQ1WPYfRhW9xb0vMmeoKchIDOddmtZCXjNBmuIoy8yr1264Yk9BlnNbtHfHT714E2I9NYjC5U5WxmqSPf6IcVEe3FWuih4mnv9k7qYrz5tcfy1310xIiGwJMuWman0qlXKHeSjL2C/04GoL5ELGeD02yRdqN824cFwekAcupmWrWzjsjpNQS1FmoPkJQTRY1AdZeHRUrgGZuUqlFMCKRptTjrU5H+HuwDtSd/cdnYR/5F36EA9mSkt/sqOkVRemhDPnt3lwWs+oD3npEus6d/aWDWRmm4jgEMvIV+Usn3YR/tK7qM4+IrVUj0RFZ8k9CGuZLbE8JqxIeVMju218mTpijzx2L+oMhqS3QepBoSu2ihP+tFr5vUps6bFzgSjAspZaxNs90dtL3XSUtFiXqfaPBRmVDOTdmrYom7LtI8E4OLqPNnsL2WpNoD2jwGMvOdv8KtVHHq7k6CTS1o7mLsxJrWMrO+DUYgQOw5rrkA40bHywFp0kqopKg5b2zBk0ma5NctB+4npXEUkvKpMssJXxY+6X6Ht5Q9JCBKcvL0WqafzvjyIjV1OSfUqOX0wBhOGxg3wqxoGYLEjxi+nqTCOyOkJSZsjPjTUxvimq42BJB1xcr0IK0DkAKiVVb/xhJJQ1Qwu24F+3DNZKIF4Dmno7igwjQDoVGwaykEHW8R5DR+LgUOpnmK6nazbuDoCB0Wubdc8hrs0bUwfCfo7xnUlUr5MV2g0DzwV7V6lr6N8YcNp0dFDU6xoxE48cQ1d9oB775SCA7mlbEd3jqeynSx5VScYxyFKgOzzTbmL5NqoAhIa
 mK6l6hkM
 Ejd3fnx62sqbs5C1Aegoh8uX+8HASq6IctHFcb3EgZu4CNATs0qpcEpZYgABd8lE0TcKgKeSQscwMV7hK/nYTcmYsQnUqP8bet3Tp/kIObx/gpAtvEr5Fvzc8jYDvZ1r1fAtc/HG9i8VcJKsrVeEyPGwrontckIgNOcwMVPjvpVm44qfqS0fYxHUWl/GwZNqrw3/WbmAo7fNhTKliI8/BkJXrsGgKEjgeVAfdjKgjgnij83+s6Tx7wmev7Z4GLYCeMuWL3D9gCNYPSzwiNUoR1m1RSuoeW9aoUUPXwNxpP9iLPpoulCoEeKmFQy6IM8QfVOdh4dKPc/uT7SxW6hyG/60wNMw77UL/S58O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/9/25 10:04 AM, Pasha Tatashin wrote:
> On Thu, Oct 9, 2025 at 11:35 AM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>>
>> 在 2025/10/9 5:01, Pasha Tatashin 写道:
>>>>> Because the window of kernel live update is short, it is difficult to statistics
>>>>> how many times the kernel is live updated.
>>>>>
>>>>> Is it possible to add a variable to statistics the times that the kernel is live
>>>>> updated?
>>>> The kernel doesn't do the live update on its own. The process is driven
>>>> and sequenced by userspace. So if you want to keep statistics, you
>>>> should do it from your userspace (luod maybe?). I don't see any need for
>>>> this in the kernel.
>>>>
>>> One use case I can think of is including information in kdump or the
>>> backtrace warning/panic messages about how many times this machine has
>>> been live-updated. In the past, I've seen bugs (related to memory
>>> corruption) that occurred only after several kexecs, not on the first
>>> one. With live updates, especially while the code is being stabilized,
>>> I imagine we might have a similar situation. For that reason, it could
>>> be useful to have a count in the dmesg logs showing how many times
>>> this machine has been live-updated. While this information is also
>>> available in userspace, it would be simpler for kernel developers
>>> triaging these issues if everything were in one place.
>> I’m considering this issue from a system security perspective. After the
>> kernel is automatically updated, user-space applications are usually
>> unaware of the change. In one possible scenario, an attacker could
>> replace the kernel with a compromised version, while user-space
>> applications remain unaware of it — which poses a potential security risk.
>>
>> To mitigate this, it would be useful to expose the number of kernel
>> updates through a sysfs interface, so that we can detect whether the
>> kernel has been updated and then collect information about the new
>> kernel to check for possible security issues.
>>
>> Of course, there are other ways to detect kernel updates — for example,
>> by using ftrace to monitor functions involved in live kernel updates —
>> but such approaches tend to have a higher performance overhead. In
>> contrast, adding a simple update counter to track live kernel updates
>> would provide similar monitoring capability with minimal overhead.
> Would a print during boot, i.e. when we print that this kernel is live
> updating, we could include the number, work for you? Otherwise, we
> could export this number in a debugfs.
Since I received a notification that my previous message was not sent 
successfully, I am resending it.

IMO, it would be better to export this number via debugfs. This approach 
reduces the overhead involved in detecting a kernel live update.
If the number is printed in logs instead, the overhead would be higher 
compared to using debugfs.

Thanks a lot.

Yanjun.Zhu

>
> Pasha

