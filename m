Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682A2CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 00:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4808E0003; Sun,  9 Nov 2025 19:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ABA98E0002; Sun,  9 Nov 2025 19:21:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A8E8E0003; Sun,  9 Nov 2025 19:21:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF7578E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:21:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33839C0B63
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:21:07 +0000 (UTC)
X-FDA: 84092792574.11.14AC1F3
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id 338121A0005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:21:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aFVEiWeL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762734065; a=rsa-sha256;
	cv=none;
	b=WthVnysEJ1MWUFf5rkgf86zBN2BlXYH8gXKTEWiAbZ3dL9YdTfsooucx0NdRmjFrAr6SAv
	UazE6Yzj0HH+MHR4Ud5OJ3iYjLd2vkN+FCxJGw7dd/dMaP+yPKyQtnRvtCz5+gU6pe53zP
	R59USTogI47EyGFK7OZVHw6o/PL/zK4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aFVEiWeL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762734065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLBZG12EpOweg5W//dmheHVzJBlI9SLwueSdt6kZhp0=;
	b=Xz9TTlWUXMknUGZIdYsOyblPAC5S9Ojg/PEayL/GpChmZdmIqGMpdg0GDWSbKaikY3f+w1
	E6RvjuyBnV+StO3hKM3so9/ge9SjCHI32TNxQ8YokbOyEUQRzQV6c9qq4afaY6/jphSSFz
	1RRN+8apd0/P61ak307c7JhiuEAuSro=
Message-ID: <442fa82e-16ef-4bde-84eb-743450222468@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762734062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jLBZG12EpOweg5W//dmheHVzJBlI9SLwueSdt6kZhp0=;
	b=aFVEiWeLxQUK2ISXdf52J2BDzGtfH3DLAlz7RqIMEVvL9ZhZRM6nGB2fRlFMFljDGu5yXu
	JcC07geo4luDBuNKUq/6FdonyAlA8GeAPnuUN8ofevO0Hyxet8ILg/fDdsxUkBh4xp+5kB
	9PLUGv7mP+wX6RNN85JBMCCoTtQXbfg=
Date: Sun, 9 Nov 2025 16:20:56 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
 graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org,
 ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org,
 rppt@kernel.org, tj@kernel.org
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com>
 <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev>
 <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 338121A0005
X-Stat-Signature: hfqnwqr4af91dpptcuskxw4159nhqqd4
X-Rspam-User: 
X-HE-Tag: 1762734064-96840
X-HE-Meta: U2FsdGVkX18/8pWK5kC4NXRLceYsfPCd/3tEnIz0E/IkiZu7ndbXPC1bn5pOikRJvGrZMl/RBPpkm2pbDjsLuNE9moabQRG5wE4VoGL7bo0jvWCFsY5RxGrumNS6nE6JjW9G9GhIbd+/VBOr1XXkqI3rxIyKZN6WTI7OKYb/gkbUj/8wyaWDId6pB6M1Fbia+Y309eqr5rZ5RQCSsJVTFA9SqDp3xxwe4WpsLigg/+/36hcDehLuVPBHmwr8GiirP5l59/J1Mg/lPrg3QTlSf7ADSBkmRCFBadAtEoTpqp1vGXWGCpKvQWxS/WR447jwkRVU2ITuCUefqH3ud+foEaXMqoqpc8fQPvFN/xQDluDhB57uSBMoboknRggWb886dNkt6+z2MK2miGxVs/JLXAVZt4kY6y811VTY/gDLiP+0vPLYZfoLAsVwjW7A1nNhDI6T57DPHcdGqp9ogqNkeGPwFx8cjwics3yK7Km69sTw7v01IwL5O1dRT4mKiJdHJXh4Q9F1ZftVZx7HefdD6iBKkHMrucUbtntWmIaSwcmx1BKU71tgI+IJw+Mj22xNJtPgoOa6TFPfOUc8yAWrfC3UE2+5XxVbwXVj/mw2StZCN2CxfEOkbUKzDS2XhYnrB3RBb3PL2Z1c16E629ihkWw9Mk7qUhEDkW/6dlgzh8UyVpIpWwaGvz4NiUIAq6mMEkh0RzQyxBliB+8qf31uASVKznbNV3qErqDjIN+25QJ/DuWjh/mjOC3vO35jxxCSratnmx7EefKQ2UnftwOWCBuMuJe4VjMlA8g3KLtMcYJ+FkaYE3mMcQKYcVpwIbAOv9JngYHltiPRbFKpmwxcKNMCi9zKttE1Ng/ua6drhKqIGYABces7pf15k4mGF1z9WSFn7xEYPpzPp9gOnGCOcZCyP6OS2eVHnV77b87pkAu+nv8Jc9qaYvkXIN9ukb96sBkoSGZmwJ0c8S/TdzZ
 pO2jhlPW
 mIhQ/PIVGQc3GgaNza0nLdWkwvVyAE5YstJB6CJXu7QyaQKOuNpfgHLOUBOwbLDG7Rsol5nX/1RBInBblk0ZvjGh8InTYYQiXYlTXD7moeyb23MKGu5dAn1mDDVy0+sLWtlvcqPA/evWo++FyS1Wt0s1bw0XEL329fI6fTkAZa/r9IXQ8x/X1nPR2w6vSEdmqoME+NsMN4+SGwEVKbCp8wen+ydAnas+teaFFK83kGQqd/r7djJlNgMEUZzaNW6W4V0yegsyyL5Rk89BBqzVbClwXhNmHv5JNrDjZt8hjKVelDU9DHjDTuOo6zojXV0OEjgNk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/11/8 10:13, Pasha Tatashin 写道:
> On Fri, Nov 7, 2025 at 6:36 PM Yanjun.Zhu <yanjun.zhu@linux.dev> wrote:
>>
>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
>>> On Fri, Nov 7, 2025 at 7:00 AM Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>>>>> Hi, Pasha
>>>>>
>>>>> In our previous discussion, we talked about counting the number of times
>>>>> the kernel is rebooted via kexec. At that time, you suggested adding a
>>>>> variable in debugfs to keep track of this count.
>>>>> However, since debugfs is now optional, where would be an appropriate
>>>>> place to store this variable?
>>>> It is an optional config and can still be enabled if the live update
>>>> reboot number value needs to be accessed through debugfs. However,
>>>> given that debugfs does not guarantee a stable interface, tooling
>>>> should not be built to require these interfaces.
>>>>
>>>> In the WIP LUO [1] I have, I pr_info() the live update number during
>>>> boot and also store it in the incoming LUO FDT tree, which can also be
>>>> accessed through this optional debugfs interface.
>>>>
>>>> The pr_info message appears like this during boot:
>>>> [    0.000000] luo: Retrieved live update data, liveupdate number: 17
>>>>
>>>> Pasha
>>> Forgot to add link to WIP LUOv5:
>>> [1] https://github.com/soleen/linux/tree/luo/v5rc04
>>
>> Thanks a lot. I’ve carefully read this commit:
>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0ff08fa.
>>
>> To be honest, I’d like to run some tests with who/luo, including the
>> selftest for kho/luo. Could you please share the steps with me?
>>
>> If the testing steps have already been documented somewhere, could you
>> please share the link?
> Currently the test performs in-kernel tests for FLB data, it creates a
> number of FLB for every registered LUO file-handler, which at the
> moment is only memfd.
>
> It works together with any of the kexec based live update tests. In
> v5, I introduce two tests:
> luo_kexec_simple
> luo_multi_session
>
> For example, with luo_multi_session:

Hi, Pasha

I enabled "CONFIG_LIVEUPDATE=y"

# ./luo_multi_session
1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module loaded?

# ls /dev/liveupdate
ls: cannot access '/dev/liveupdate': No such file or directory

# grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
/boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=y
/boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=y

I made tests on FC42. But /dev/liveupdate is missing.

Thanks

Yanjun.Zhu

> # ./luo_multi_session
> # [STAGE 1] Starting pre-kexec setup for multi-session test...
> # [STAGE 1] Creating state file for next stage (2)...
> # [STAGE 1] Creating empty sessions 'multi-test-empty-1' and
> 'multi-test-empty-2'...
> # [STAGE 1] Creating session 'multi-test-files-1' with one memfd...
> # [STAGE 1] Creating session 'multi-test-files-2' with two memfds...
> # [STAGE 1] Executing kexec...
>
> ... reboot ...
> After reboot:
>
> $ ./luo_multi_session
> # [STAGE 2] Starting post-kexec verification...
> # [STAGE 2] Retrieving all sessions...
> # [STAGE 2] Verifying contents of session 'multi-test-files-1'...
> # [STAGE 2] Verifying contents of session 'multi-test-files-2'...
> # [STAGE 2] Test data verified successfully.
> # [STAGE 2] Finalizing all test sessions...
> # [STAGE 2] Finalizing state session...
> #
> --- MULTI-SESSION KEXEC TEST PASSED ---
>
> Dmesg data, shows that in-kernel live update test was also successful:
>
> [    0.000000] luo: Retrieved live update data, liveupdate number: 1
> [    0.034513] liveupdate test: test-flb-v0: found flb data from the
> previous boot
> [    0.034517] liveupdate test: test-flb-v1: found flb data from the
> previous boot
> [    0.034518] liveupdate test: test-flb-v2: found flb data from the
> previous boot
> [    0.676891] liveupdate test: Registered 3 FLBs with file handler: [memfd-v1]
>
> Pasha
>
>> Best Regards,
>>
>> Yanjun.Zhu
>>
-- 
Best Regards,
Yanjun.Zhu


