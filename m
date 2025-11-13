Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADBCACD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157518E0011; Wed, 12 Nov 2025 21:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078608E0003; Wed, 12 Nov 2025 21:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEAB18E0011; Wed, 12 Nov 2025 21:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9D0D8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:11:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E2F51A073E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:11:54 +0000 (UTC)
X-FDA: 84103958148.17.187CC83
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id B73591A0004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:11:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nV8FfQGN;
	spf=pass (imf19.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762999913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/+1BR+z1PXeMCvVSg/Yv+cjc1+rmoxZ3614InYoJRw=;
	b=oBuTFag7uavGgLbZJZZeZXjruMoO1vtdfEmm1+MvlpGZe6QXVxl83BpTShMJ0pbvY9lYXk
	14p0+6vIKLJ8b4KYvl3+dSbc/JxWo1JkVMHzSIX4E4QCmFj2WwNfLu09qRKiVnqFUeI7+D
	zRW/7WhojMpN+KSBc8QSIbcmTGqeawE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nV8FfQGN;
	spf=pass (imf19.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762999913; a=rsa-sha256;
	cv=none;
	b=J0I83SISQJJcM+gx3hrJKaKtSLiQF0XtYbYHLVkLOUpB4qWj6dZW3J3lA3HCtJJc8kYAwn
	iMhdJl+dItuPPNc9CmWiEI/3tK2tcXyek7qqOR8ae3bAmAz21+yxv30SiSv2A636w1/OfZ
	xvOxomgkjWI4yT8H4M5PfJNBp1fmysM=
Message-ID: <a1aa7736-d014-477f-a516-2281a70fc8c1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762999910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w/+1BR+z1PXeMCvVSg/Yv+cjc1+rmoxZ3614InYoJRw=;
	b=nV8FfQGNv/0WHZb3+OThUFBKmCnETJ6CvUvKHHqtuE4TvC5BMA6YBhUrFW0GzBdv8xm1Dq
	aCoTJqNbj7JMz5ef1xN4YwR6MO/M5nk9PYzIx3oGMIiC68ER2dsdEkXRgYpCGvPZOPab1m
	s2iYakGeatJfxLbTpDO+bjD/g/hFZoQ=
Date: Wed, 12 Nov 2025 18:11:45 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
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
 <475ed48d-1f62-4983-94a1-64e41c463c36@linux.dev>
Content-Language: en-US
In-Reply-To: <475ed48d-1f62-4983-94a1-64e41c463c36@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B73591A0004
X-Stat-Signature: 47g7sufzquz6o6pp7nhyzd9aqzsg17af
X-Rspam-User: 
X-HE-Tag: 1762999912-718191
X-HE-Meta: U2FsdGVkX18ndo3SbtXBn1dBAVMZu1yqMqBfn7EzMFnJg0xENJm5sQAUCUsJmQ9Mp/dvFKkwVPeskoZkERlbBTdnbvaI6LijBXsLYA1bWE62x3pAnCeob4sq2B3+wxNcTZPNDOWqYY774pbYcaYenIzAjxBWyaC72cXiGqN5EVyZdqqwBAQvkkYCI8iKC1mbOPFZgj6qEAnZvUUBSUqssIBfe4Si/r6pMA4cukswwLTm4kyVs50dbCyLV08ycjC8v2zakOuZGGfOxvc4yKTuSdztc2QtYsiQ4Xmfd+GLaLn4UuhVtv9iscibErA2ZWqiF/uFxhyDaCb2BzwLnQDGwsp8DpA9pJ6RUJT6m8tXb5P3LwItRxPAXu3NOBZQPko2gxoxXATvSm378SxzodU9dwMMOe6WGO2tMQGBTVgHMfex48QusWYg+TG4Ft9Vppcxh9NsDnb1q/CE0VheltsB2XANssidQvNFnNqQDTjUsoozT5OKAl1Pi2VXAKmrHyavi397HjTGO3jmNHEscXXXTBLni6FdE4EWI49L+CzDR+WjoTrnz+YO/U/0oOGZkjJHwOKlYktORPbG1jQoEmvpqKOKQvezjKmHW/uuBk/9q93Q1mK0Se0mk2pwdSgDWwsbDoI5lsXL7B2xzcd6k2rljYTlXIGwBH2zYHxSML495ZJwgRCBcEXxHnuuuROzk6Z1OAKCV5nuDwBztMdAANOFCEdawKFLWrMGUfXyMmQCyizGl3epidF/OueHKWnYZR3LACj9dU+C21I4fZXGf7B1p+eZOvlfgMFNzUfjOt3S46/3qNVm5le/PdipqYwCAkt8iuetvE/8S1KlrykknkgST3gBylni7TO0I2RzEcP2oc8RcmKk3ww2/Fid4fqrJ3/DIy3Yvo7LgY8inGtq6C2Zt0J9kMLnhVgegqx8/vrdSWXFAgo/Qe4QIV9F6/xLA6BChBXa9+qs2Oi6MGnPaAr
 bMKAz2gD
 09XySVxgXbp9p9pEvhEsdm+nIrvDf1jvTtpdSGNUhYK22sdlT/Fn/9ec8RX6CjU2538/4Ui3sUAreDZHuifiqws0s4cF5qJPLNOn8r5Ekzojol9Gb4Xl+42GQJsWEzNDeE/d79z6ylpVxGjZuM+ZnUC28M6u51dhtf70nkoGV5M6gf4RK2cJPXgcdQys1JUG1yZGW0AIGZu24cdoN63sEEPQ/pJs6nHQTqTUw3pagJrinpsE7Z7Dw5/cRyniUHPZKLqXlDR4glj8CZjx6UvyfJ+3Idp+Nk+W3Io9MCm87d50dqDm5WTfo2mpKmyIQP3XQR8O3HyfmBsher2cWehDczmlr3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/12/25 5:41 PM, Yanjun.Zhu wrote:
>
> On 11/11/25 7:26 AM, Pasha Tatashin wrote:
>> On Mon, Nov 10, 2025 at 11:11 PM Zhu Yanjun <yanjun.zhu@linux.dev> 
>> wrote:
>>> In FC42, when I run "./luo_multi_session"
>>>
>>> # ./luo_multi_session
>>> # [STAGE 1] Starting pre-kexec setup for multi-session test...
>>> # [STAGE 1] Creating state file for next stage (2)...
>>> # [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
>>> 'multi-test-empty-2'...
>>> # [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
>>> # [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
>>> # [STAGE 1] Executing kexec...
>>>
>>> Then the system hang. And via virt-viewer, a calltrace will appear.
>> Looks like mountroot fails, are you passing the same kernel parameters
>> as the during cold boot?
>> i.e. kexec -l -s --reuse-cmdline --initrd=[initramfs] [kernel]
>
>
> Thanks a lot. It can work now.  The logs are as below:
>
> "
>
> # [STAGE 2] Starting post-kexec verification...
> # [STAGE 2] Retrieving all sessions...
> # [STAGE 2] Verifying contents of session 'multi-test-files-1'...
> # [STAGE 2] Verifying contents of session 'multi-test-files-2'...
> # [STAGE 2] Test data verified successfully.
> # [STAGE 2] Finalizing all test sessions...
> # [STAGE 2] Finalizing state session...
> #
> --- MULTI-SESSION KEXEC TEST PASSED ---
> "
>
> Yanjun.Zhu


Hi, Pasha

In my tests, I found that luo_kexec_simple and luo_multi_session 
currently depend on the glibc-static library.
If this library is not installed, build errors occur.
By making the following changes, luo_kexec_simple and luo_multi_session 
would no longer depend on glibc-static, reducing external library 
dependencies.
I am not sure whether you agree with these proposed changes.

diff --git a/tools/testing/selftests/liveupdate/Makefile 
b/tools/testing/selftests/liveupdate/Makefile
index 6ee6efeec62d..b226b9976150 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -3,7 +3,6 @@
  KHDR_INCLUDES ?= -I../../../../usr/include
  CFLAGS += -Wall -O2 -Wno-unused-function
  CFLAGS += $(KHDR_INCLUDES)
-LDFLAGS += -static
  OUTPUT ?= .

  # --- Test Configuration (Edit this section when adding new tests) ---

Yanjun.Zhu

>
>
>>
>> Pasha
>>
>>> The call trace is in the attachment.
>>>
>>> Yanjun.Zhu
>>>
>>> 在 2025/11/10 7:26, Pasha Tatashin 写道:
>>>> On Mon, Nov 10, 2025 at 8:16 AM Pratyush Yadav 
>>>> <pratyush@kernel.org> wrote:
>>>>> On Sun, Nov 09 2025, Zhu Yanjun wrote:
>>>>>
>>>>>> 在 2025/11/8 10:13, Pasha Tatashin 写道:
>>>>>>> On Fri, Nov 7, 2025 at 6:36 PM Yanjun.Zhu <yanjun.zhu@linux.dev> 
>>>>>>> wrote:
>>>>>>>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
>>>>>>>>> On Fri, Nov 7, 2025 at 7:00 AM Pasha Tatashin 
>>>>>>>>> <pasha.tatashin@soleen.com> wrote:
>>>>>>>>>>> Hi, Pasha
>>>>>>>>>>>
>>>>>>>>>>> In our previous discussion, we talked about counting the 
>>>>>>>>>>> number of times
>>>>>>>>>>> the kernel is rebooted via kexec. At that time, you 
>>>>>>>>>>> suggested adding a
>>>>>>>>>>> variable in debugfs to keep track of this count.
>>>>>>>>>>> However, since debugfs is now optional, where would be an 
>>>>>>>>>>> appropriate
>>>>>>>>>>> place to store this variable?
>>>>>>>>>> It is an optional config and can still be enabled if the live 
>>>>>>>>>> update
>>>>>>>>>> reboot number value needs to be accessed through debugfs. 
>>>>>>>>>> However,
>>>>>>>>>> given that debugfs does not guarantee a stable interface, 
>>>>>>>>>> tooling
>>>>>>>>>> should not be built to require these interfaces.
>>>>>>>>>>
>>>>>>>>>> In the WIP LUO [1] I have, I pr_info() the live update number 
>>>>>>>>>> during
>>>>>>>>>> boot and also store it in the incoming LUO FDT tree, which 
>>>>>>>>>> can also be
>>>>>>>>>> accessed through this optional debugfs interface.
>>>>>>>>>>
>>>>>>>>>> The pr_info message appears like this during boot:
>>>>>>>>>> [    0.000000] luo: Retrieved live update data, liveupdate 
>>>>>>>>>> number: 17
>>>>>>>>>>
>>>>>>>>>> Pasha
>>>>>>>>> Forgot to add link to WIP LUOv5:
>>>>>>>>> [1] https://github.com/soleen/linux/tree/luo/v5rc04
>>>>>>>> Thanks a lot. I’ve carefully read this commit:
>>>>>>>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0ff08fa. 
>>>>>>>>
>>>>>>>>
>>>>>>>> To be honest, I’d like to run some tests with who/luo, 
>>>>>>>> including the
>>>>>>>> selftest for kho/luo. Could you please share the steps with me?
>>>>>>>>
>>>>>>>> If the testing steps have already been documented somewhere, 
>>>>>>>> could you
>>>>>>>> please share the link?
>>>>>>> Currently the test performs in-kernel tests for FLB data, it 
>>>>>>> creates a
>>>>>>> number of FLB for every registered LUO file-handler, which at the
>>>>>>> moment is only memfd.
>>>>>>>
>>>>>>> It works together with any of the kexec based live update tests. In
>>>>>>> v5, I introduce two tests:
>>>>>>> luo_kexec_simple
>>>>>>> luo_multi_session
>>>>>>>
>>>>>>> For example, with luo_multi_session:
>>>>>> Hi, Pasha
>>>>>>
>>>>>> I enabled "CONFIG_LIVEUPDATE=y"
>>>>>>
>>>>>> # ./luo_multi_session
>>>>>> 1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module 
>>>>>> loaded?
>>>>>>
>>>>>> # ls /dev/liveupdate
>>>>>> ls: cannot access '/dev/liveupdate': No such file or directory
>>>>>>
>>>>>> # grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
>>>>>> /boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=y
>>>>>> /boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=y
>>>>>>
>>>>>> I made tests on FC42. But /dev/liveupdate is missing.
>>>>> You need to add liveupdate=1 to your kernel cmdline to enable LUO and
>>>>> get /dev/liveupdate.
>>>> +1, kernel parameters require: kho=1 liveupdate=1
>>>>
>>>>> Pasha, your LUO series doesn't add the liveupdate parameter to
>>>>> kernel-parameters.txt. I think it should be done in the next 
>>>>> version to
>>>>> this parameter is discoverable.
>>>> Yeah, that is missing, I will update that in a standalone patch, or in
>>>> a next version.
>>>>
>>>> Thanks,
>>>> Pasha
>>> -- 
>>> Best Regards,
>>> Yanjun.Zhu

