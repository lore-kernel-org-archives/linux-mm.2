Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993E9CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6EEE8E0007; Thu, 13 Nov 2025 14:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46D98E0003; Thu, 13 Nov 2025 14:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DAC8E0007; Thu, 13 Nov 2025 14:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE9168E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:55:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CA614D1F2
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:55:24 +0000 (UTC)
X-FDA: 84106638168.25.920669F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7B7B11C0004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:55:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L9Djqk54;
	spf=pass (imf18.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763063722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLkXsr0Dvb8T4YrcF/JXkIUXrEDLj7h5d9ku45LOQx4=;
	b=R7PWfHVtT8dlO/fPV4tn+0c8AQPa9UF+1WZxAkmaYjK2Jpm3G4fsCDuiL4xo6yMIHyFmGB
	oASI7kl0G5uHdaXOrCFzQuGkbF3RhRsQhpcUbzZSQPzMQndFcnWvEVWbeGbleJ7rEIMEPy
	XAES5kFBg2xtY7KH064XvkUzUT6cJiw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L9Djqk54;
	spf=pass (imf18.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763063722; a=rsa-sha256;
	cv=none;
	b=v065sNrV1rjEzqswQ6PedhfIzOTxw+p3nCt/7STiogYTJPgRmOLFRttFIUT5YhWUPk2u5O
	OrPn1lSsPZWWW5cTnRui8vUecBV3NfZBM9eKUVNH205ThgMWjMqII4mrdPneEFYZkphc4A
	a5A7kuSiKjcaFn4wfeGxUqh6t6VTMls=
Message-ID: <9e144e21-a5e7-4c12-b8b0-07172787ab37@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763063720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zLkXsr0Dvb8T4YrcF/JXkIUXrEDLj7h5d9ku45LOQx4=;
	b=L9Djqk54pbG5PGyLzny7VbmE5paidw/3zQQ4qTjVQhDBG2dPTyijjqnZzzmuR1NG3ceXVd
	V2PY2EJQX9Nn4ZDbv8H833i3VGP5KGJWBgA5tvzbzYa+Klcorfd+npHW8FAl813NxeDYll
	/ebeALHHipkuCi1C1QMxMzEaUDezA4U=
Date: Thu, 13 Nov 2025 11:55:10 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org,
 brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
 rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com>
 <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev>
 <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
 <442fa82e-16ef-4bde-84eb-743450222468@linux.dev>
 <mafs0qzu69gei.fsf@kernel.org>
 <CA+CK2bBEe16x0em1gRxQD3jhfV9t3QA2vx5ifk2pKb_WEoMTeg@mail.gmail.com>
 <0735e1ef-2b65-4a54-b4d5-964fb875cd09@linux.dev>
 <CA+CK2bBnnGyQ-N8-XS3W3tnSRwvFbstOdo0oDSdkF70KP1AVxw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bBnnGyQ-N8-XS3W3tnSRwvFbstOdo0oDSdkF70KP1AVxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B7B11C0004
X-Stat-Signature: 988se1ceawxnenj4x7du8c7phrbc8awi
X-Rspam-User: 
X-HE-Tag: 1763063722-685374
X-HE-Meta: U2FsdGVkX1/LuI4HlLaEEnN3fB0uSsJQyh/A1/sgCgSTY8RiQHhgSzPledkrujnqHbPiAL2pNQZ6JU411jZ6365vpFAsT/cqByrzvLCKQZyYHqmH7v8rHlhaqb7fjOgD9goLQokWN14IiakQQExUJz0BOWKSri5b6Y2J0F9Ofy0uTd4IvSlhYYDPkr+ThE8feQFo/6lBA8VNszCYNqR8UfEAJRIKEXglQn+aa9man62DXvb4iYpMs60UoiV6v69AEXp8+IK3RmaIR5UAbmqbK09dqSCTqlCxucTwwzUapWjOE+u+nUSLcVreDVFtAF//BrDL9vibNLs9DK3LnQltwgvnfNGZ20omh3Z2Kthy0HZvx4lNFIT+M1ZoyFrT2paftRj4CqaWojdy2iln76BH/ip0qtZYt+LOwZfTsM9Oey2eityP73zHzgS5pesHf1sE5RfFLnBjZQMN0Cb3cTZarCMJPuEtBHGGX3UuLU0Qfm8vh5Vr/9XaNOxBTT0gPgRlkHBRk4ngMvZh5Fj3sO19fJywjlO4+289Z3U3fH/J0CcEwNyyXjV6oefRW+hTVW5VXrwEQVRFN+HnC5QAbsohkaUH4Qqpv+qglhY89LYpWg7AiBhqOS3XrSxmftyKV2kC+QcK3clP5YrB269H03fnCMOmejcxUyYGmvV/y8PZmNAePvbkbIBJT3zSKF9rUJx1ElIM/GS6rJ7+2tYeeR4CkpLFOgVk8VLzF2LAKEMX5Qr5WfDSxGIAhWsDpsaeq0Zamb6Icl3jgQsk0IUPA0+VPKd/qVVvhDJTB5d0siong+H4cNaoLUWrHb7AjEMTOCian9pYMlxhK1hsJ+Z0oUG9JF3b+RNfLUfz+5RAcDedCz+ktd2Uxn+2mWWnKUcD64AtsrGzihMGDzaqg83k4crB1+VY179bVUyWpV3xQIRV3NnqfVyh+ta6ho++PZuJdvLQ7mO3Y2k1BDzDrFpp9XR
 kWE75VNA
 Mo4qhpZsFYlPC5PygiX3fVuuI/5Mxw2WlWzQGLqEjkcGAx2GNYMzXUC9j0M77gv6p/V9HWvb18YWACpfJOlBRAPQSANZFF81wcQ2Ar4AXMvB9YM8qO70Gd39AOS8FMwNw7WB1+crRNreDR+tGyF2rNmr5joN0bNnw52e4O0MBZt3y06lp3j+acs2FMuDeFK8tI0tYTv4rJYx/Hca+1V3x9+krWe4IW46lBuskpmIw5xCWcnikzL7N+B/GcuaJ5FyFpHwGThQu0A1m1Y++CwkyY4o8OFa3UHAKMto4scpBZASNIvoXDL68wPqZbbl9b+4MEIlC5zSvTZFfFC1wUcGu1vNfEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/11/25 7:26 AM, Pasha Tatashin wrote:
> On Mon, Nov 10, 2025 at 11:11 PM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>> In FC42, when I run "./luo_multi_session"
>>
>> # ./luo_multi_session
>> # [STAGE 1] Starting pre-kexec setup for multi-session test...
>> # [STAGE 1] Creating state file for next stage (2)...
>> # [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
>> 'multi-test-empty-2'...
>> # [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
>> # [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
>> # [STAGE 1] Executing kexec...
>>
>> Then the system hang. And via virt-viewer, a calltrace will appear.
> Looks like mountroot fails, are you passing the same kernel parameters
> as the during cold boot?
> i.e. kexec -l -s --reuse-cmdline --initrd=[initramfs] [kernel]
>
> Pasha

Hi, Pasha

Following your advice, the following can work well.

I am not sure if we can merge this commit into selftests/liveupdate 
mainline?

commit 44764c48a658987b7729c5bc2be9fd87832cfbdf (HEAD -> linux-next/master)
Author: Zhu Yanjun <yanjun.zhu@linux.dev>
Date:   Thu Nov 13 11:45:21 2025 -0800

     selftests/liveupdate: Fix the error "Unable to mount root fs on 
unknown-block"

     If the initrd is not provide, the followings will appear.
     "
     Call Trace:
     <TASK>
     dump_stack_lvl+0x5d/0x80
     vpanic+0x118/8x320
     panic+0x6b/0x6b
     ? do_mount_root+0x115/0x130
      mount_root_generic+0x1cf/0x270
      prepare_namespace+0x1e1/0x230
      kernel_init_freeable+0x136/8x140
     ?_pfx_kernel_init+0x10/0x10
      kernel_init+0x1a/0x140
      ret_from_fork+0x130/0x1a8
      ?_pfx_kernel_init+0x10/0x10
      ret_from_fork_asm+0x1a/0x30
      </ TASK>
      Kernel Offset: 0x3000000 from Oxffffffff81000000
     "

     Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

diff --git a/tools/testing/selftests/liveupdate/do_kexec.sh 
b/tools/testing/selftests/liveupdate/do_kexec.sh
index bb396a92c3b8..4ee59abd0dd4 100755
--- a/tools/testing/selftests/liveupdate/do_kexec.sh
+++ b/tools/testing/selftests/liveupdate/do_kexec.sh
@@ -2,5 +2,5 @@
  # SPDX-License-Identifier: GPL-2.0
  set -e

-kexec -l -s --reuse-cmdline /boot/bzImage
+kexec -l -s --reuse-cmdline /boot/bzImage --initrd 
/boot/initramfs-`uname -r`.img
  kexec -e

Thanks a lot.

Yanjun.Zhu

>> The call trace is in the attachment.
>>
>> Yanjun.Zhu
>>
>> 在 2025/11/10 7:26, Pasha Tatashin 写道:
>>> On Mon, Nov 10, 2025 at 8:16 AM Pratyush Yadav <pratyush@kernel.org> wrote:
>>>> On Sun, Nov 09 2025, Zhu Yanjun wrote:
>>>>
>>>>> 在 2025/11/8 10:13, Pasha Tatashin 写道:
>>>>>> On Fri, Nov 7, 2025 at 6:36 PM Yanjun.Zhu <yanjun.zhu@linux.dev> wrote:
>>>>>>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
>>>>>>>> On Fri, Nov 7, 2025 at 7:00 AM Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>>>>>>>>>> Hi, Pasha
>>>>>>>>>>
>>>>>>>>>> In our previous discussion, we talked about counting the number of times
>>>>>>>>>> the kernel is rebooted via kexec. At that time, you suggested adding a
>>>>>>>>>> variable in debugfs to keep track of this count.
>>>>>>>>>> However, since debugfs is now optional, where would be an appropriate
>>>>>>>>>> place to store this variable?
>>>>>>>>> It is an optional config and can still be enabled if the live update
>>>>>>>>> reboot number value needs to be accessed through debugfs. However,
>>>>>>>>> given that debugfs does not guarantee a stable interface, tooling
>>>>>>>>> should not be built to require these interfaces.
>>>>>>>>>
>>>>>>>>> In the WIP LUO [1] I have, I pr_info() the live update number during
>>>>>>>>> boot and also store it in the incoming LUO FDT tree, which can also be
>>>>>>>>> accessed through this optional debugfs interface.
>>>>>>>>>
>>>>>>>>> The pr_info message appears like this during boot:
>>>>>>>>> [    0.000000] luo: Retrieved live update data, liveupdate number: 17
>>>>>>>>>
>>>>>>>>> Pasha
>>>>>>>> Forgot to add link to WIP LUOv5:
>>>>>>>> [1] https://github.com/soleen/linux/tree/luo/v5rc04
>>>>>>> Thanks a lot. I’ve carefully read this commit:
>>>>>>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0ff08fa.
>>>>>>>
>>>>>>> To be honest, I’d like to run some tests with who/luo, including the
>>>>>>> selftest for kho/luo. Could you please share the steps with me?
>>>>>>>
>>>>>>> If the testing steps have already been documented somewhere, could you
>>>>>>> please share the link?
>>>>>> Currently the test performs in-kernel tests for FLB data, it creates a
>>>>>> number of FLB for every registered LUO file-handler, which at the
>>>>>> moment is only memfd.
>>>>>>
>>>>>> It works together with any of the kexec based live update tests. In
>>>>>> v5, I introduce two tests:
>>>>>> luo_kexec_simple
>>>>>> luo_multi_session
>>>>>>
>>>>>> For example, with luo_multi_session:
>>>>> Hi, Pasha
>>>>>
>>>>> I enabled "CONFIG_LIVEUPDATE=y"
>>>>>
>>>>> # ./luo_multi_session
>>>>> 1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module loaded?
>>>>>
>>>>> # ls /dev/liveupdate
>>>>> ls: cannot access '/dev/liveupdate': No such file or directory
>>>>>
>>>>> # grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
>>>>> /boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=y
>>>>> /boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=y
>>>>>
>>>>> I made tests on FC42. But /dev/liveupdate is missing.
>>>> You need to add liveupdate=1 to your kernel cmdline to enable LUO and
>>>> get /dev/liveupdate.
>>> +1, kernel parameters require: kho=1 liveupdate=1
>>>
>>>> Pasha, your LUO series doesn't add the liveupdate parameter to
>>>> kernel-parameters.txt. I think it should be done in the next version to
>>>> this parameter is discoverable.
>>> Yeah, that is missing, I will update that in a standalone patch, or in
>>> a next version.
>>>
>>> Thanks,
>>> Pasha
>> --
>> Best Regards,
>> Yanjun.Zhu

