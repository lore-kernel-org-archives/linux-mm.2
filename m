Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017D8CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4980F8E0007; Mon, 10 Nov 2025 08:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4483B8E0002; Mon, 10 Nov 2025 08:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3364F8E0007; Mon, 10 Nov 2025 08:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0988E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:16:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E395E160D4A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:16:43 +0000 (UTC)
X-FDA: 84094747086.01.BE129FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2CD614000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:16:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PS38d2F+;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762780602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoGgbfLp/CQfLa6tlaYlsw16XKv7B12qAptDkaFl0Wg=;
	b=ytoYrm405M2C+qNhgVPyVC5LTYRwYXPRMAvpTVJyFWJTaMUl/GNTl27CRRYdkAdKnhwFmi
	qTYXDVKg+bvq9t8mMq3zDf56HSD4DBJrianqH6ki/J+z/EEsiB1A75jMWAajalbnLHfGXZ
	qypQfBJYypk7IkuCZPm+EpC1UVDNjig=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PS38d2F+;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762780602; a=rsa-sha256;
	cv=none;
	b=pSttkxnlLL7FBGfQKAtGOytsiJ0rgmIQTYRHYpHQXTPcaG7hJH/kI7pNWTHN1Pw6U9y8wA
	tyFtYq3QmP2332/z5nWVodLH5UlrTGVMMXRZ3GnHfl4tCLHcXQ+o9zY6ZypJjeYVkWHFbM
	RNy1wcRPYNPMr+DOQL4RjuIZaB3aVno=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CDB243BFA;
	Mon, 10 Nov 2025 13:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A7FC4CEF5;
	Mon, 10 Nov 2025 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762780601;
	bh=f0dZjtcP0vxUJBo4nfnO1ah3073NhYiLonrdArYUsXw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PS38d2F+HD6yJ+cCZ27VfTyu/Xb5ZNzr80MqBwuo05yeFYAXUJdvjE5nUUkXYcFFD
	 +5183EI4m7vKpS3ZZwa7ynwmCHyhTwcz+iEuPcYXMSWAvc3cub34I6kp/Cnbduib2k
	 O2om8Jm3FT/iufyjmHEZqTttkvC6e+bBJbYB2icy6vI5KYYdvLq6XlDk1bKyZZ9tZh
	 roMVdrRyxyw38iwxO2aGZ2XNKX9DBFV8xK31IMNliK86ajR/C3rW3abM/BOELVQbfR
	 C0M8uOI3syHk24+OYOUanJp+f96ijtCAJSGZ55L2Ur8Kc8x9HzduLTQ+LWWXzdhMpq
	 ipF5HIEmgZ2pA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  akpm@linux-foundation.org,
  brauner@kernel.org,  corbet@lwn.net,  graf@amazon.com,  jgg@ziepe.ca,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  masahiroy@kernel.org,  ojeda@kernel.org,
  pratyush@kernel.org,  rdunlap@infradead.org,  rppt@kernel.org,
  tj@kernel.org
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
In-Reply-To: <442fa82e-16ef-4bde-84eb-743450222468@linux.dev> (Zhu Yanjun's
	message of "Sun, 9 Nov 2025 16:20:56 -0800")
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
	<20251101142325.1326536-2-pasha.tatashin@soleen.com>
	<d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
	<CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
	<CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
	<029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev>
	<CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
	<442fa82e-16ef-4bde-84eb-743450222468@linux.dev>
Date: Mon, 10 Nov 2025 14:16:37 +0100
Message-ID: <mafs0qzu69gei.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CD614000A
X-Stat-Signature: b4souenhyc6pi75hnff94i3apms7rqja
X-Rspam-User: 
X-HE-Tag: 1762780601-523355
X-HE-Meta: U2FsdGVkX1+KXmLNkOuIKC489tX4VeaatzGzCTLKRI/VDnwxVz+FI2tGALnEMpmp0iMeILvEKKdqZL9pjl5AYOnA1nUzY4dstZbjspTHeDokc9yxWfBcR6pdV5u5S6ihXrA12r7oAi3C/0BKWpGiKF0grb5fNL2iKKH6Y5I+uUs98ICoYJYO7KTKi02xfi0mvFJIxT32SN+QtWHpp9OYWMuRnW6qbXPKTjMylxH4zoj/GdY30lW5GElvbLNnhLY+7wyPyXxllmKO5dqrXVwnAjU2QFHXGgeD11Hp8d4MKFEGUFMn9uLfSOTdxPnZ9nfVuc4+dmBRQ9W7l9t7CQ13mNnhCeuDHnOecdWz3nSCWjuDkPxQ5OLYbrQEnohz/t4oAdBEHdRLWXnnEtS1RMyR84tTdYmG/hkcKKquzKzrGtydeySDxT6R8/jz3giuOeUH2w1ZkZubCeTrU9LdyBWHDKUe8uFwTe+4Kv+O8Yl5YnloJabt7/BOOfYW+5woct/ZvWzM9IptSu0zKmUtMQhalmKTg+WQb97TL+FzvyqGePmZVHVdQeyWZJMnQ/1L0pJbHxl21KmiulDJsf6rA7+2bjW/lbPuneGTvQrEfsHexwq5TaH1GpQaj9ehV6RMedtsdpdtFVJO1Jhb7gk6JWGHCiVbfGoUuk4aszYk4dJ/q9uEnAtdywcoqq/Rj4/mLl0WfFoA5X2I4wlJ79EmyOqdgmhwWkWSZDDglX36zenmrKt86IgBR1JYRuKtfQ+l7nXWa4yw8ZFHu28tl6wf/6PhbROh5KS8xGdinfAXigL1QpMyfk2RMC2OjTeKKxyjX362wv2frcMShMM9iE/zplyt6p9y2doRcmSLxmqKW5qUOi7ta89/sW0lxVikD8HgvddAYI7vEu1tdlKz0Um1CIvEDVPnyDFszvqT60OUTZf/dAfMC0RGKEaeVKa6kYVOaTK9EiYFR8gCfc+BHiKJZhb
 YKwtW4XU
 /1FEA3kJVAx2HJbcOCKevYMMLXhWZ4+lJ8Su+YbHiwvSw4xCVZPheyn0uXsZEyJAYoEJuMOCx7Ahrb0IGiQPE5pRsKnQc9rQTVfW3zuV96SnYqOuoUHkel5uaKIPhlb26d2E5UwAm/FZKJ8a7KKEtDs9P9st4J77m5goc3VPGW3Gu5OizimyfDJ0DHMXZkLrNMIb8vKnE8ik31EEJcacIDXGTbZjcAnlnu7MMb+ilFAJJ2W7nPcU2C9JWFOgs3eiL11CvyMb/DtNr4Ev14pGX2rwDf87Va/pwRhXH6JEFmiZmoT+yEVkqYsxhug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09 2025, Zhu Yanjun wrote:

> =E5=9C=A8 2025/11/8 10:13, Pasha Tatashin =E5=86=99=E9=81=93:
>> On Fri, Nov 7, 2025 at 6:36=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev>=
 wrote:
>>>
>>> On 11/7/25 4:02 AM, Pasha Tatashin wrote:
>>>> On Fri, Nov 7, 2025 at 7:00=E2=80=AFAM Pasha Tatashin <pasha.tatashin@=
soleen.com> wrote:
>>>>>> Hi, Pasha
>>>>>>
>>>>>> In our previous discussion, we talked about counting the number of t=
imes
>>>>>> the kernel is rebooted via kexec. At that time, you suggested adding=
 a
>>>>>> variable in debugfs to keep track of this count.
>>>>>> However, since debugfs is now optional, where would be an appropriate
>>>>>> place to store this variable?
>>>>> It is an optional config and can still be enabled if the live update
>>>>> reboot number value needs to be accessed through debugfs. However,
>>>>> given that debugfs does not guarantee a stable interface, tooling
>>>>> should not be built to require these interfaces.
>>>>>
>>>>> In the WIP LUO [1] I have, I pr_info() the live update number during
>>>>> boot and also store it in the incoming LUO FDT tree, which can also be
>>>>> accessed through this optional debugfs interface.
>>>>>
>>>>> The pr_info message appears like this during boot:
>>>>> [    0.000000] luo: Retrieved live update data, liveupdate number: 17
>>>>>
>>>>> Pasha
>>>> Forgot to add link to WIP LUOv5:
>>>> [1] https://github.com/soleen/linux/tree/luo/v5rc04
>>>
>>> Thanks a lot. I=E2=80=99ve carefully read this commit:
>>> https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83=
f0ff08fa.
>>>
>>> To be honest, I=E2=80=99d like to run some tests with who/luo, includin=
g the
>>> selftest for kho/luo. Could you please share the steps with me?
>>>
>>> If the testing steps have already been documented somewhere, could you
>>> please share the link?
>> Currently the test performs in-kernel tests for FLB data, it creates a
>> number of FLB for every registered LUO file-handler, which at the
>> moment is only memfd.
>>
>> It works together with any of the kexec based live update tests. In
>> v5, I introduce two tests:
>> luo_kexec_simple
>> luo_multi_session
>>
>> For example, with luo_multi_session:
>
> Hi, Pasha
>
> I enabled "CONFIG_LIVEUPDATE=3Dy"
>
> # ./luo_multi_session
> 1..0 # SKIP Failed to open /dev/liveupdate. Is the luo module loaded?
>
> # ls /dev/liveupdate
> ls: cannot access '/dev/liveupdate': No such file or directory
>
> # grep "LIVEUPDATE" -inrHI /boot/config-`uname -r`
> /boot/config-next-20251107-luo+:349:CONFIG_LIVEUPDATE=3Dy
> /boot/config-next-20251107-luo+:11985:CONFIG_LIVEUPDATE_TEST=3Dy
>
> I made tests on FC42. But /dev/liveupdate is missing.

You need to add liveupdate=3D1 to your kernel cmdline to enable LUO and
get /dev/liveupdate.

Pasha, your LUO series doesn't add the liveupdate parameter to
kernel-parameters.txt. I think it should be done in the next version to
this parameter is discoverable.

--=20
Regards,
Pratyush Yadav

