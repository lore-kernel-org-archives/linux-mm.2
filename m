Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5C7CD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CC98E0010; Thu, 13 Nov 2025 15:07:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE018E0003; Thu, 13 Nov 2025 15:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC418E0010; Thu, 13 Nov 2025 15:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C78258E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:07:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75E44C0138
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:07:36 +0000 (UTC)
X-FDA: 84106668912.15.FE6A840
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A6158000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:07:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tMdBmTMd;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763064455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gve1A4IDiHiMD0od6cLkJB7WYPC76TSGRToaIhlzrnc=;
	b=sFLWX3/9s861WuWFQsiQ6hukSj9PyGCVLnmyRI3NaktfQY96bAidaGJsQEzDLV9c6NKleu
	DinEQi3+m/ykSMWCCTTZ2Zo8387W1TgCAQo63QxXUJUyiGvsWQwiXwfsIuup7Ap754ehIA
	9/XfKru/G67cwPADx3fDLiTXJ7IyXtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763064455; a=rsa-sha256;
	cv=none;
	b=H9pWdlVPl13XCwmRXjkUaRqe/AcMIHLHMdcdYOWiVDAduH+ub6y1SfCVYgeWHPRFq9QRV5
	KkS1uc3qEeSQgAWoUqwlUeSAv3Z5vFW4X2J8KgKx87km38hN1/BdUPHqTXlkM2y2HQN/a4
	nknKbfH3+dL/sgW2Uk3xLjmhprHl78o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tMdBmTMd;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: multipart/alternative;
 boundary="------------nahn0TILTzoTrs1qf9Gd0Zv0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763064452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gve1A4IDiHiMD0od6cLkJB7WYPC76TSGRToaIhlzrnc=;
	b=tMdBmTMdSkDrxrPr9G6dA06Le1v42fh0VE+OQlRNd2gsyoCvj07KXaWMgEC7ZXbd+mW2rA
	nJNVcwJmLNQ/FS9Va8wNz+TIOYU2vYpYCQZSpdN9CKjDzAGIsPji/savoItkJHt4ufVoLO
	DxqkFMYN/DL7b6qi3AG6NsAZpiuELmE=
Message-ID: <9e8bc27a-81ed-4270-8289-66bec92bb153@linux.dev>
Date: Thu, 13 Nov 2025 12:07:26 -0800
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
 <475ed48d-1f62-4983-94a1-64e41c463c36@linux.dev>
 <a1aa7736-d014-477f-a516-2281a70fc8c1@linux.dev>
 <CA+CK2bCwqCHr6oecmL6R65qjgXZNuzU7SJ9diVkYX442tUdU+Q@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bCwqCHr6oecmL6R65qjgXZNuzU7SJ9diVkYX442tUdU+Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A6158000B
X-Stat-Signature: stmmbz7hi5qcg6np45ijh665dgfuna91
X-HE-Tag: 1763064454-580177
X-HE-Meta: U2FsdGVkX189N/lXWtbDmvyXnkdWU2EhCCwx/hQ4KNFUzo0b98JTtU+5KqdjSf0+QWhitxEcmyv+/KWFm+UsJhMzuzd/imRaTjROH1vkjPd2CGxTLwgd5SrG6QOHLBTu2UkP+H073lDn8JIFnH3HrTm6Lv5HfGjd4Zm3dJsdHpWh5dyUxdfdSk7cI3AY5T5fsQ4ArRhuaLFbkU31HGcpkhqryWec9sRkyOKX5ftFIQOEjvHWqMpmrIWsm6kJf5YTDA/NYUAX0ZaEr32SY6/e8+kaixJ4i/ib6AhWvlBg7/HX8bfot89s8ZuPEDrHgxnow7+Q0XtyuoyqtwKp2H2mzBYth9thLFcpIQA8PYheXbeM+OXPj6g3EW04n9WHoPXMFN2VQMzyaUNJpvbLWsWPQUS9vSfwxYVysB6zqmD2bGwl9N33UdqQjq7q49bRoytjhHNlh5V3VodqH2tcpCsGpUKFHNLbbiV0rNFnwxLvUt0sqzFeDwMhXrHYm4HuXxMd3FzszvDgILOPlOHpEh1+nsndt2Ocr26Jzv8LE0MVyGJyf7UncqkaSioPA3L4Xvxt6L5kbRAPgU7egXz6CvEY+KbeuCpwIWSinjAfyVlrqaNKRC0VtY8KkfISCxL9OhC9enEc7EHyr6z2sdsmkm9Lp3Sh0aVnzh6BfNBlAw1p5lv7dbumot8KG7uQfiuHc+IbMlDJRUZNn5pCwm9b7DPa25luyD4ax7apLTtqYx9giDHY6ZaE5bc7GqheZhKvu/I/YpPLVfURJiDlk7Wk9qnZOdFgLx/3gZ+Ukvdy3uo9COiANt+T2y6p9jUclI9MUQE49TmOUDVrILIoKIFo5ECfBpd87uFV6v0PcOH77DEnrFnvDyNGKTzlkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------nahn0TILTzoTrs1qf9Gd0Zv0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/13/25 11:59 AM, Pasha Tatashin wrote:
> On Wed, Nov 12, 2025 at 9:11 PM Yanjun.Zhu<yanjun.zhu@linux.dev> wrote:
>>
>> On 11/12/25 5:41 PM, Yanjun.Zhu wrote:
>>> On 11/11/25 7:26 AM, Pasha Tatashin wrote:
>>>> On Mon, Nov 10, 2025 at 11:11 PM Zhu Yanjun<yanjun.zhu@linux.dev>
>>>> wrote:
>>>>> In FC42, when I run "./luo_multi_session"
>>>>>
>>>>> # ./luo_multi_session
>>>>> # [STAGE 1] Starting pre-kexec setup for multi-session test...
>>>>> # [STAGE 1] Creating state file for next stage (2)...
>>>>> # [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
>>>>> 'multi-test-empty-2'...
>>>>> # [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
>>>>> # [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
>>>>> # [STAGE 1] Executing kexec...
>>>>>
>>>>> Then the system hang. And via virt-viewer, a calltrace will appear.
>>>> Looks like mountroot fails, are you passing the same kernel parameters
>>>> as the during cold boot?
>>>> i.e. kexec -l -s --reuse-cmdline --initrd=[initramfs] [kernel]
>>>
>>> Thanks a lot. It can work now.  The logs are as below:
>>>
>>> "
>>>
>>> # [STAGE 2] Starting post-kexec verification...
>>> # [STAGE 2] Retrieving all sessions...
>>> # [STAGE 2] Verifying contents of session 'multi-test-files-1'...
>>> # [STAGE 2] Verifying contents of session 'multi-test-files-2'...
>>> # [STAGE 2] Test data verified successfully.
>>> # [STAGE 2] Finalizing all test sessions...
>>> # [STAGE 2] Finalizing state session...
>>> #
>>> --- MULTI-SESSION KEXEC TEST PASSED ---
>>> "
>>>
>>> Yanjun.Zhu
>>
>> Hi, Pasha
>>
>> In my tests, I found that luo_kexec_simple and luo_multi_session
>> currently depend on the glibc-static library.
>> If this library is not installed, build errors occur.
>> By making the following changes, luo_kexec_simple and luo_multi_session
>> would no longer depend on glibc-static, reducing external library
>> dependencies.
>> I am not sure whether you agree with these proposed changes.
>>
>> diff --git a/tools/testing/selftests/liveupdate/Makefile
>> b/tools/testing/selftests/liveupdate/Makefile
>> index 6ee6efeec62d..b226b9976150 100644
>> --- a/tools/testing/selftests/liveupdate/Makefile
>> +++ b/tools/testing/selftests/liveupdate/Makefile
>> @@ -3,7 +3,6 @@
>>    KHDR_INCLUDES ?= -I../../../../usr/include
>>    CFLAGS += -Wall -O2 -Wno-unused-function
>>    CFLAGS += $(KHDR_INCLUDES)
>> -LDFLAGS += -static
> Hi Yanjun,
>
> Thank you for testing. I prefer to keep the '-static' flag because
> these self-test files are not executed in the same environment where
> they are compiled but in a VM which might have a different userspace.

Hi, Pasha

I agree with your reasoning. Given that the self-tests run in a 
different userspace, keeping the |-static| flag seems reasonable.

Best Regards,

Yanjun.Zhu

>
> Thank you,
> Pasha
>
>>    OUTPUT ?= .
>>
>>    # --- Test Configuration (Edit this section when adding new tests) ---
>>
>> Yanjun.Zhu
>>
>>>
>>>> Pasha
>>>>
>>>>> The call trace is in the attachment.
>>>>>
>>>>> Yanjun.Zhu
>>>>>
>>>>> 在 2025/11/10 7:26, Pasha Tatashin 写道:
>>>>>> On Mon, Nov 10, 2025 at 8:16 AM Pratyush Yadav
>>>>>> <pratyush@kernel.org> wrote:
>>>>>>> On Sun, Nov 09 2025, Zhu Yanjun wrote:
>>>>>>>
>>>>>>>> 在 2025/11/8 10:13, Pasha Tatashin 写道:
>>>>>>>>> On Fri, Nov 7, 2025 at 6:36 PM Yanjun.Zhu<yanjun.zhu@linux.dev>
>>>>>>>>> wrote:
>>>>>>>>>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
>>>>>>>>>>> On Fri, Nov 7, 2025 at 7:00 AM Pasha Tatashin
>>>>>>>>>>> <pasha.tatashin@soleen.com> wrote:
>>>>>>>>>>>>> Hi, Pasha
>>>>>>>>>>>>>
>>>>>>>>>>>>> In our previous discussion, we talked about counting the
>>>>>>>>>>>>> number of times
>>>>>>>>>>>>> the kernel is rebooted via kexec. At that time, you
>>>>>>>>>>>>> suggested adding a
>>>>>>>>>>>>> variable in debugfs to keep track of this count.
>>>>>>>>>>>>> However, since debugfs is now optional, where would be an
>>>>>>>>>>>>> appropriate
>>>>>>>>>>>>> place to store this variable?
>>>>>>>>>>>> It is an optional config and can still be enabled if the live
>>>>>>>>>>>> update
>>>>>>>>>>>> reboot number value needs to be accessed through debugfs.
>>>>>>>>>>>> However,
>>>>>>>>>>>> given that debugfs does not guarantee a stable interface,
>>>>>>>>>>>> tooling
>>>>>>>>>>>> should not be built to require these interfaces.
>>>>>>>>>>>>
>>>>>>>>>>>> In the WIP LUO [1] I have, I pr_info() the live update number
>>>>>>>>>>>> during
>>>>>>>>>>>> boot and also store it in the incoming LUO FDT tree, which
>>>>>>>>>>>> can also be
>>>>>>>>>>>> accessed through this optional debugfs interface.
>>>>>>>>>>>>
>>>>>>>>>>>> The pr_info message appears like this during boot:
>>>>>>>>>>>> [    0.000000] luo: Retrieved live update data, liveupdate
>>>>>>>>>>>> number: 17
>>>>>>>>>>>>
>>>>>>>>>>>> Pasha
>>>>>>>>>>> Forgot to add link to WIP LUOv5:
>>>>>>>>>>> [1]https://github.com/soleen/linux/tree/luo/v5rc04
>>>>>>>>>> Thanks a lot. I’ve carefully read this commit:
>>>>>>>>>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0ff08fa.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> To be honest, I’d like to run some tests with who/luo,
>>>>>>>>>> including the
>>>>>>>>>> selftest for kho/luo. Could you please share the steps with me?
>>>>>>>>>>
>>>>>>>>>> If the testing steps have already been documented somewhere,
>>>>>>>>>> could you
>>>>>>>>>> please share the link?
>>>>>>>>> Currently the test performs in-kernel tests for FLB data, it
>>>>>>>>> creates a
>>>>>>>>> number of FLB for every registered LUO file-handler, which at the
>>>>>>>>> moment is only memfd.
>>>>>>>>>
>>>>>>>>> It works together with any of the kexec based live update tests. In
>>>>>>>>> v5, I introduce two tests:
>>>>>>>>> luo_kexec_simple
>>>>>>>>> luo_multi_session
>>>>>>>>>
>>>>>>>>> For example, with luo_multi_session:
>>>>>>>> Hi, Pasha
>>>>>>>>
>>>>>>>> I enabled "CONFIG_LIVEUPDATE=y"
>>>>>>>>
>>>>>>>> # ./luo_multi_session
>>>>>>>> 1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module
>>>>>>>> loaded?
>>>>>>>>
>>>>>>>> # ls /dev/liveupdate
>>>>>>>> ls: cannot access '/dev/liveupdate': No such file or directory
>>>>>>>>
>>>>>>>> # grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
>>>>>>>> /boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=y
>>>>>>>> /boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=y
>>>>>>>>
>>>>>>>> I made tests on FC42. But /dev/liveupdate is missing.
>>>>>>> You need to add liveupdate=1 to your kernel cmdline to enable LUO and
>>>>>>> get /dev/liveupdate.
>>>>>> +1, kernel parameters require: kho=1 liveupdate=1
>>>>>>
>>>>>>> Pasha, your LUO series doesn't add the liveupdate parameter to
>>>>>>> kernel-parameters.txt. I think it should be done in the next
>>>>>>> version to
>>>>>>> this parameter is discoverable.
>>>>>> Yeah, that is missing, I will update that in a standalone patch, or in
>>>>>> a next version.
>>>>>>
>>>>>> Thanks,
>>>>>> Pasha
>>>>> --
>>>>> Best Regards,
>>>>> Yanjun.Zhu
--------------nahn0TILTzoTrs1qf9Gd0Zv0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 11/13/25 11:59 AM, Pasha Tatashin
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CA+CK2bCwqCHr6oecmL6R65qjgXZNuzU7SJ9diVkYX442tUdU+Q@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">On Wed, Nov 12, 2025 at 9:11 PM Yanjun.Zhu <a class="moz-txt-link-rfc2396E" href="mailto:yanjun.zhu@linux.dev">&lt;yanjun.zhu@linux.dev&gt;</a> wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">

On 11/12/25 5:41 PM, Yanjun.Zhu wrote:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">
On 11/11/25 7:26 AM, Pasha Tatashin wrote:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">On Mon, Nov 10, 2025 at 11:11 PM Zhu Yanjun <a class="moz-txt-link-rfc2396E" href="mailto:yanjun.zhu@linux.dev">&lt;yanjun.zhu@linux.dev&gt;</a>
wrote:
</pre>
            <blockquote type="cite">
              <pre wrap="" class="moz-quote-pre">In FC42, when I run "./luo_multi_session"

# ./luo_multi_session
# [STAGE 1] Starting pre-kexec setup for multi-session test...
# [STAGE 1] Creating state file for next stage (2)...
# [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
'multi-test-empty-2'...
# [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
# [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
# [STAGE 1] Executing kexec...

Then the system hang. And via virt-viewer, a calltrace will appear.
</pre>
            </blockquote>
            <pre wrap="" class="moz-quote-pre">Looks like mountroot fails, are you passing the same kernel parameters
as the during cold boot?
i.e. kexec -l -s --reuse-cmdline --initrd=[initramfs] [kernel]
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">

Thanks a lot. It can work now.  The logs are as below:

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
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">

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
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Hi Yanjun,

Thank you for testing. I prefer to keep the '-static' flag because
these self-test files are not executed in the same environment where
they are compiled but in a VM which might have a different userspace.</pre>
    </blockquote>
    <p>Hi, Pasha</p>
    <p>I agree with your reasoning. Given that the self-tests run in a
      different userspace, keeping the <code data-start="504"
        data-end="513">-static</code> flag seems reasonable.</p>
    <p>Best Regards,</p>
    <p>Yanjun.Zhu</p>
    <blockquote type="cite"
cite="mid:CA+CK2bCwqCHr6oecmL6R65qjgXZNuzU7SJ9diVkYX442tUdU+Q@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">

Thank you,
Pasha

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">  OUTPUT ?= .

  # --- Test Configuration (Edit this section when adding new tests) ---

Yanjun.Zhu

</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">

</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">
Pasha

</pre>
            <blockquote type="cite">
              <pre wrap="" class="moz-quote-pre">The call trace is in the attachment.

Yanjun.Zhu

在 2025/11/10 7:26, Pasha Tatashin 写道:
</pre>
              <blockquote type="cite">
                <pre wrap="" class="moz-quote-pre">On Mon, Nov 10, 2025 at 8:16 AM Pratyush Yadav
<a class="moz-txt-link-rfc2396E" href="mailto:pratyush@kernel.org">&lt;pratyush@kernel.org&gt;</a> wrote:
</pre>
                <blockquote type="cite">
                  <pre wrap="" class="moz-quote-pre">On Sun, Nov 09 2025, Zhu Yanjun wrote:

</pre>
                  <blockquote type="cite">
                    <pre wrap="" class="moz-quote-pre">在 2025/11/8 10:13, Pasha Tatashin 写道:
</pre>
                    <blockquote type="cite">
                      <pre wrap="" class="moz-quote-pre">On Fri, Nov 7, 2025 at 6:36 PM Yanjun.Zhu <a class="moz-txt-link-rfc2396E" href="mailto:yanjun.zhu@linux.dev">&lt;yanjun.zhu@linux.dev&gt;</a>
wrote:
</pre>
                      <blockquote type="cite">
                        <pre wrap="" class="moz-quote-pre">On 11/7/25 4:02 AM, Pasha Tatashin wrote:
</pre>
                        <blockquote type="cite">
                          <pre wrap="" class="moz-quote-pre">On Fri, Nov 7, 2025 at 7:00 AM Pasha Tatashin
<a class="moz-txt-link-rfc2396E" href="mailto:pasha.tatashin@soleen.com">&lt;pasha.tatashin@soleen.com&gt;</a> wrote:
</pre>
                          <blockquote type="cite">
                            <blockquote type="cite">
                              <pre wrap="" class="moz-quote-pre">Hi, Pasha

In our previous discussion, we talked about counting the
number of times
the kernel is rebooted via kexec. At that time, you
suggested adding a
variable in debugfs to keep track of this count.
However, since debugfs is now optional, where would be an
appropriate
place to store this variable?
</pre>
                            </blockquote>
                            <pre wrap="" class="moz-quote-pre">It is an optional config and can still be enabled if the live
update
reboot number value needs to be accessed through debugfs.
However,
given that debugfs does not guarantee a stable interface,
tooling
should not be built to require these interfaces.

In the WIP LUO [1] I have, I pr_info() the live update number
during
boot and also store it in the incoming LUO FDT tree, which
can also be
accessed through this optional debugfs interface.

The pr_info message appears like this during boot:
[    0.000000] luo: Retrieved live update data, liveupdate
number: 17

Pasha
</pre>
                          </blockquote>
                          <pre wrap="" class="moz-quote-pre">Forgot to add link to WIP LUOv5:
[1] <a class="moz-txt-link-freetext" href="https://github.com/soleen/linux/tree/luo/v5rc04">https://github.com/soleen/linux/tree/luo/v5rc04</a>
</pre>
                        </blockquote>
                        <pre wrap="" class="moz-quote-pre">Thanks a lot. I’ve carefully read this commit:
<a class="moz-txt-link-freetext" href="https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0ff08fa">https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0ff08fa</a>.


To be honest, I’d like to run some tests with who/luo,
including the
selftest for kho/luo. Could you please share the steps with me?

If the testing steps have already been documented somewhere,
could you
please share the link?
</pre>
                      </blockquote>
                      <pre wrap="" class="moz-quote-pre">Currently the test performs in-kernel tests for FLB data, it
creates a
number of FLB for every registered LUO file-handler, which at the
moment is only memfd.

It works together with any of the kexec based live update tests. In
v5, I introduce two tests:
luo_kexec_simple
luo_multi_session

For example, with luo_multi_session:
</pre>
                    </blockquote>
                    <pre wrap="" class="moz-quote-pre">Hi, Pasha

I enabled "CONFIG_LIVEUPDATE=y"

# ./luo_multi_session
1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module
loaded?

# ls /dev/liveupdate
ls: cannot access '/dev/liveupdate': No such file or directory

# grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
/boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=y
/boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=y

I made tests on FC42. But /dev/liveupdate is missing.
</pre>
                  </blockquote>
                  <pre wrap="" class="moz-quote-pre">You need to add liveupdate=1 to your kernel cmdline to enable LUO and
get /dev/liveupdate.
</pre>
                </blockquote>
                <pre wrap="" class="moz-quote-pre">+1, kernel parameters require: kho=1 liveupdate=1

</pre>
                <blockquote type="cite">
                  <pre wrap="" class="moz-quote-pre">Pasha, your LUO series doesn't add the liveupdate parameter to
kernel-parameters.txt. I think it should be done in the next
version to
this parameter is discoverable.
</pre>
                </blockquote>
                <pre wrap="" class="moz-quote-pre">Yeah, that is missing, I will update that in a standalone patch, or in
a next version.

Thanks,
Pasha
</pre>
              </blockquote>
              <pre wrap="" class="moz-quote-pre">--
Best Regards,
Yanjun.Zhu
</pre>
            </blockquote>
          </blockquote>
        </blockquote>
      </blockquote>
    </blockquote>
  </body>
</html>

--------------nahn0TILTzoTrs1qf9Gd0Zv0--

