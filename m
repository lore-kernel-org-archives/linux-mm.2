Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4362CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEC38E000A; Wed, 12 Nov 2025 20:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0618E0002; Wed, 12 Nov 2025 20:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6C98E000A; Wed, 12 Nov 2025 20:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F13858E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:41:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84A0A12E274
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:41:48 +0000 (UTC)
X-FDA: 84103882296.03.22121E3
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 783DC80004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:41:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aspetcsn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998107; a=rsa-sha256;
	cv=none;
	b=TTS2iEccuLMeEw4em8koyy9PeWUVKttKenvYVo2gSEWbZJH6c2NYfx+Y3UJgLoFxf8CkTB
	u3WHrZvcNu2diFUSDf4V/gcVK4elffzczzZp+tvJYwa39Tw/pVhjh5mxlRiblrit/Ppco8
	PEdijnUEB4moCU0GjdenMSQR5+Mhw3E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aspetcsn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZOsuzzzQHJpIeK5WeOY1LNAVB/LXukV3KrcVp6/m18=;
	b=NXLQ0/AuneFwSa3bsPqR/TOMXJJm41B71sQnHsP0YRBYL/npgrBuEqmAQb+1sdVjFb6Tfw
	h9rdLhXbbUia/DL3ZoBV4yPwETv5UO1fh5bQi2Dre1N67rjsBvF6cJKimWKWnmAzgGWQzD
	FjgqaM5pBFkociLYhqI3jTKCrWcLIUg=
Message-ID: <475ed48d-1f62-4983-94a1-64e41c463c36@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762998104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOsuzzzQHJpIeK5WeOY1LNAVB/LXukV3KrcVp6/m18=;
	b=AspetcsnJtR4NjDaUovNH2yMqZTZw0RgLT/JVL7iCXS9oi67IL2u0jl/uOr0dksqvGcvUn
	YX+fGFhLg27XpwXq2IW5geaCJE3Xio36ngY70VFJY8922A+P+lFwyw1PcZ2+dwpoMhwRKO
	R85op0rSFY5KSS5iU1NU0AgVIisSR1o=
Date: Wed, 12 Nov 2025 17:41:38 -0800
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 783DC80004
X-Stat-Signature: 91uzq5frzg6jhnjmpkptrdaxq1fezczu
X-Rspam-User: 
X-HE-Tag: 1762998106-637372
X-HE-Meta: U2FsdGVkX181PiifLuzrS1OjrL39D6aRz6Bv+j3kPwv9LPirQNbK8oUdxESnmUQZW+lweSwtuwV/hioGspwC5CbIWZGnGVU+eAeKRomuK70ARolp6EM8sFZiwBTeplG/uCZBVawBxUF28UTD/FCqSX9Xjk1ceeoqDOVMv28nFHEIxmTTFNrzLrnyGHzeCJnB8DeUgYBEKarQbxJ8KEvB5dXWV7AhxyYgOC2vyrEirK5kGcNVdcSmMlseRzhUODOVcxHA+kG2jRMBW6VMJ5d5C24Zs1QOQ37oHaCSIk/KuIImSeRwp+0pTiCinMKrrpp317ReaDGx18DOUMVSSSb3f25kMsOJqZvJ6RRM66AcLZfBkqllChM3HFCjw3sQ0hiAnBhXh1OrNTt9xXRMdH4EH3PCoQaNhAZcuQ1VkqGxWUljk1KWQ84qB4c4Yg/d4fTXP4ad930l72Yv1Bw8AZErRl5uEGaIo66cvBaaxTCHkxicrNrbUglKFiucNzhYuD1vbvcSFmJ3nbBRUMAtiot4wrpxFxTV68tuSqZm/sBkOqHIJyxnMaMfZac3h3hKOsfIbHGyhzp63hlLFnavvldJLMIfjiVs6TOWuGnXSvgkSRlDegRJVHa2bF41+FgmGRZtD0iWeGWnTnvYed6lKW2tLxNKmae1V6SxkTGhxIl3NqCugUa7bI6dHTBbLQSHqsnW1XVjOKikFVPlpohR8MxIGP4ceid6RB9P6kyxMF5jHHwPT4AlCl29+iTCpQRr1KQ+eEWSUBlEt+y7jRybIgPcU5x8hDj5XrbMMU6P7gJHMCxaQCOFyYlZCVy/+S7RqX34na/QVeXPB7e4qeVzkknj1vNT4G3/IF9bEj6Lv0leHY5wttgUJZEGeitkE4GgeuA1K8JvV36wdm4HF3eSXWSzFDlB0I+xuFaDkOdVlBB9H6eioeSGg2nbxuqa1qGyEHdYkiKwV28nwA/A7CKALyO
 dL98EjEM
 vPbqxm+r1mfXpRa1rTLYQ6toyDzjf4vBNNurWuSnngK3H4iOZhzFMkLDpv/0E8seVqLiV0Bpy0H7XAN1lGiV3zRmj+V2jdgrxLzYpwrRmawA1+ROxq8N8KC1wQ5kStxKnGjn/CqPJs+r+thwWHXzU6+IKf7MH42Fu2ZpP3aePoRvA8JVV5iGj+37a99GDdMb+uO80Bod6R56h7JGHOVXlgzm2yOMF0K+hXUh2hPnm/4DLv6KeySrYv06r/iYpWtFb6Tg2j5QXSZUmXc6SXrqfArCftt8JXBoTWuBzw7CmO6NSdnAzsZ4e68mubEIDOvCOSpPKs97+mDLal9QNx2ub4x/ZCw==
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


Thanks a lot. It can work now.  The logs are as below:

"

# [STAGE 2] Starting post-kexec verification...
# [STAGE 2] Retrieving all sessions...
# [STAGE 2] Verifying contents of session 'multi-test-files-1'...
# [STAGE 2] Verifying contents of session 'multi-test-files-2'...
# [STAGE 2] Test data verified successfully.
# [STAGE 2] Finalizing all test sessions...
# [STAGE 2] Finalizing state session...
#
--- MULTI-SESSION KEXEC TEST PASSED ---
"

Yanjun.Zhu

>
> Pasha
>
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

