Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAE0C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 13:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F94D6B008A; Mon, 10 Aug 2026 09:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9C66B008C; Mon, 10 Aug 2026 09:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898066B0092; Mon, 10 Aug 2026 09:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658C76B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:22:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB27F80180
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:22:48 +0000 (UTC)
X-FDA: 85085424816.25.7DD897C
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78F41160010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:22:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tItyoQ9s;
	spf=pass (imf08.hostedemail.com: domain of 3pNB5agkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3pNB5agkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786368166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM/Qa4ThtXGVoAOuESD7ZLMy4Hwa1Cb/UO9QtFpTQ7s=;
	b=0tS1R7I250yyfHFcOpe6YcOQHshe897nIG19gmTGLZPmgKEm+iQWEA5xXOU86sxS41Z3kX
	nM+ONTj+GIANxUaYs7TPcY3NqGAnR855N8PHWX1OUY3iW1eMpFLNXzB+rFuSyGeYYhb7qs
	bdjis4CmCnqZiOnDNuADQs2gc4I+J0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786368166;
	b=hUe6M1IPFCwWneU7l7DfqMxPJI12i62zejUxzDUyUWJueFVhlBZbzxmoduSPRaO8Dp9vSY
	mdxBpxWXGw8vQfs8Eg1IKayPhE/XyH71iye916SDOJ17gWBimnqebhAaqnBjKuFfG/vgmf
	vwLaUXoVeLDLHYYGF3R1zIUGY7xVokc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tItyoQ9s;
	spf=pass (imf08.hostedemail.com: domain of 3pNB5agkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3pNB5agkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c158e733fd6so159959366b.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786368165; x=1786972965; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iM/Qa4ThtXGVoAOuESD7ZLMy4Hwa1Cb/UO9QtFpTQ7s=;
        b=tItyoQ9s7xuDWfEcGxrIbjlJwsE7ZCDdSB3WcWJM5lnjMq2YsC0CE5Q9ZtcCpv8vix
         1EzAVZdXtFHqIn43tfQ06nd3am3d/sI9xwEFK7qHQZvh483xwSOmoxMnkPt5+Qyxy74r
         vRwmQtds1qPKGRfb4g49ZwnT/G/UPfIXbpe0X72vVFaNVnMdUETZrXWfz+EgEHuSnlOL
         WoiWVo5ERcb3KFD+3VTwUptscSU7dqHBi1Uj7hhwo3jEgrIvqxusg8ItdJ3k1SMVMlZV
         8Z83RROy9jzMbPL1KSdSeXdLgXX7knB1dbC5rVeOghouZ+vJ0kFEK9yiXYYILSs4Ckt/
         EUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786368165; x=1786972965;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iM/Qa4ThtXGVoAOuESD7ZLMy4Hwa1Cb/UO9QtFpTQ7s=;
        b=Fgxzio3luwFRjB+UbnHc39HM5CcTX0B8nPs1EcW/R8+EFzvCxuS8zobulMKHv9TZoX
         biuAsAJSN76RB2zwhz3gX21EhB5W9k0+FqEPd/tg55UFFCEF9UsRPkGJQHxkq6zElGTW
         U79P/5Ba0saAEqM2dAByO0XLmuJL29Gsv28qMYodrIp3nVQ4IQht0tOPNRuHPVeckPTl
         zkfQaUpyhB7q3eHdwgAee5w+WQDfrttU+RCZgUUfzAQzChz11Ibx6JIG6OB8rjn55d/H
         evbKGUbNcLvt5W31ybk2457+grWuTt0FeUIyrXZ1ys2KX/Yl5smKJJPh8S2fxarZsiNF
         2rkg==
X-Forwarded-Encrypted: i=1; AHgh+Rraxzb6YhPgWPvKBUZ5xpqpjfw7/n59MrP0ZkNsvEdLRh195t3C0FNOv4Q/ZS9DmexWlr6NWUPbvg==@kvack.org
X-Gm-Message-State: AOJu0Ywk9fkamjRsSgax/R7vZjKBT4xSKAlH3v3DSwA0T5AdBjET8XR9
	XyuAsYUngfOB3rdbew5aS7nQa6J2DL19+Fx/D7zM7puGKZ196G+7XrwFVfydPhEQ8yRx6HUi6Z9
	L1wkRWbjU+/uzT3F5rQ==
X-Received: from edap32.prod.google.com ([2002:a05:6402:5020:b0:6a0:ddb8:db7f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a5c1:20b0:6a1:f7f4:200b with SMTP id 4fb4d7f45d1cf-6a1f7f4278bmr5285938a12.12.1786368164940;
 Mon, 10 Aug 2026 06:22:44 -0700 (PDT)
Date: Mon, 10 Aug 2026 13:22:44 +0000
In-Reply-To: <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-12-tarunsahu@google.com> <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Message-ID: <9huzv79i6rff.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 11/11] KVM: selftests: Add guest_memfd_preservation_test
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78F41160010
X-Rspam-User: 
X-Stat-Signature: tks83e4fbz5xsnrigeju11443i9mq9mh
X-HE-Tag: 1786368166-737713
X-HE-Meta: U2FsdGVkX18MSKy0zzyze0IpT1oZ+5u2zwo0zMtU998hcItqlR8yMAtH2sIJyfy1R1D8uzmJflS20wiR3xFKhn2NZQgSCycih+BOAyfQMuYARUKhvdrCmNuymScR47bl1E29/cRORgFZ9JQNEpZbAHM1dUYKKB/I+3jPkOYi1fsuLgJHSISjNRE9V71kHL8mT1hVSz5Lwsy5afQVL2Wy3R4IO3xlNzb2oLUhg86KyfdaB16scHimFCs9wylct7MxqZBWUEf1RAyWI+mBPiEFZaaYkOB60/yqAfLSSer8R7c4oXK0m0v+WfOJMjg/L8kDNER2T0OQA5efhhPPEgnd27/iL9c2EEFxMkGWnXQSUtLOhxiaFottjGENJjrzLsKiEAAsT/IE3JWZuwdGF5mRvIfD9WiSiQ1/JFrcrL5y6E5aC5t/QX9y9/Xcxf+tRg8JHJdIUubRjq+1H0eNT5qfVCFgdjMYpHhyQHuOBafQDdXDSVPg886hPFdGR9qhjxoXlzNcwKMqL7uoFX+MH6b0LZAlGdoNLuoAoi2/8+UozLyg7CYbagdunTdZ2ql09vAUpkZ0wX8GJKsVzdpf1/otQIgJn5ZaFNtP2pbSkD4ULjXK0ui2J1cfbRaCFSdOuKk2mNzHC5XFBdPnppKldHA2KRYNEtN16wnX4dL5AgKPv8XsIfrCiTOXzTuatQ4JflTLsfwZ+S93M32hYk0wSMQMo7insCstStofTAVlRZnkC5kct1V1RtMPfOIPW4gARXgbVreItp4B5BFZLqKrwdcdhkuVKXLN8Lh1jx4K56WkgGXNnzR2Qo7vmWA8lsHWbvXQKbSizElP8iZ39X9ohbNP0H5ZJi6NwVfbeSWc8pYXYPJ8oCB88aWmAqL41l4NnJjs4g2bn/zg+gnB5/Xjrh1rAjmwtJ9Pm3of+w5/SAOKIvJKDrJmqCzfPLlIkUWOXO/4NlH9KF9bb9KhPp1Aewc
 S8MYT1gX
 c3X49mHncq6N4TZT3oGgf+i/IER5miVcvhZnQYqVsHEXnNo2Kxn+WqIkmfuIPIWTRbkKUBnS9kJ0m9QayrHc5rdrFBrybkHXyJkxfZPCrZMy/EHkAVR4JB0GxBNTQqQ9ElzKg9ovrj+K6JRoDo2z66WJ+4dhSaAbPlv+8/geYNygxK32VkSKdC6HdzqWzeCf+xPXpyyEurtmWxmy/0piUkXsO2nLG9NLgutGr+61a8dVSa17baXvkhMTXsBcPlPB3/TvLDTSO/vgpTehNxDgO4tkJ2vtrpY3g8SoF1rMSvXg/k4n8wEPiXZqWdfphZ4xoDrrkfa3DiZuMJa7xQYRjitfSq8dLrd30Iqgo8b3LXHjrAIHLjwFt9sS06A3MSl3z4JIq3hoEB2sR32drngX7ZGJNT9g/V3lP8ogLUB8nNxxoNbVOzqsDc/+c7Xr8NppdFIA/u7yVY0wpCVJTBlENUFiLGCy3FnaQHiiL6fFFxALDz2lciK8wUUDNgA+xW/eGcL94uRnopyXNNmTsKDBJ6SjQUcQGHiyNh9sMm4C0KnHcPiq3J508eK9rRHk08e9q+S6KuZIlJ1KbFoaYcvIJOfJTMOJKY1sKrOqvFQGtr7vKvRbRNshYEELAeJy4ThuaTa75szTUa+5LqGTr3Z7+lV+OUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Add guest_memfd_preservation_test to verify that KVM VM state and guest
>> memory backed by guest_memfd are preserved across a kexec reboot via Live
>> Update Orchestrator (LUO).
>>
>> This test includes multiple tests
>> - (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
>> - (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
>> - (C) Test to allocate the guest_memfd memory after preservation because
>>   preservation makes the guest_memfd frozen. Which must fail as well.
>> - (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
>>   kexec: Below is the details of stages in this test.
>>
>
> I think we should split this into multiple patches, where each patch
> introduces 1 test.

Got it. I will split them. I thought that this test already spawn a VM
and other test can just reuse the same VM.

>
>>
>> [...snip...]
>>
>> +++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
>> @@ -0,0 +1,357 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2026, Google LLC.
>> + *
>> + * Author: Tarun Sahu <tarunsahu@google.com>
>> + *
>> + * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
>> + *
>> + * NOTE: This is a MANUAL test and is excluded from automated CI/testing
>> + * frameworks because Stage 1 daemonizes into the background to pin resources
>> + * and requires a human operator to manually trigger kexec before Stage 2
>> + * is executed. Running Stage 1 automatically would leak the background daemon
>> + * and cause CI runners to falsely interpret it as a passed test.
>> + *
>
> Usually there aren't many printfs in tests, but since this is a MANUAL
> test, maybe that's ok?
>
> Would like to know what Sean thinks of this, and printfs in general.
>
>>
>> [...snip...]
>>

