Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C51BBC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1AB6B018E; Tue, 18 Aug 2026 12:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97966B075E; Tue, 18 Aug 2026 12:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD50C6B0760; Tue, 18 Aug 2026 12:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A85E86B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:35:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B61480241
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:35:37 +0000 (UTC)
X-FDA: 85114941114.02.07AB98A
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8763E1A000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:35:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OqN3joLS;
	spf=pass (imf19.hostedemail.com: domain of 31omEagkKCFcIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=31omEagkKCFcIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4s3SdzysyF0cpwVmIOh8j6ah+K+701R9CGnrq6hKDk=;
	b=wSaef1gNuqtqBlFom3aGAU84Qzbp7foiwGXRO5wi69zlv/i3RnCjMPVVWBMF0o3kY5of6V
	QfEBlOGcnADqVh9l8qWB/EcxZbd17y//3WuzdI3NUsdIgWnSWu/XJ0iXN+Jo29Spb1tNOY
	Xypo7AuXIKwYX48PWIw+dS2L/7EenlI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787070935;
	b=PRy+w2zAsRFHTJwaXOo6g1JrVyVyE4HdoZCxuZhsJTK2t/Hwu9tvEnLBguEeayC6A/gers
	Vzd3sLr4zwL+sRfWESCYZr+lHGCdJIrVvmRCoWwGmngQ+RYeep5TZ2H/kJfTGpR9/1vnRH
	ai9XlXiEBU2egBBwLij8Ml6eZCVn+vE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OqN3joLS;
	spf=pass (imf19.hostedemail.com: domain of 31omEagkKCFcIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=31omEagkKCFcIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1f74261f67so73494666b.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787070934; x=1787675734; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y4s3SdzysyF0cpwVmIOh8j6ah+K+701R9CGnrq6hKDk=;
        b=OqN3joLSC8JM5kY2cUGw4eE9UktwYWa5zKHwcLqEgYa2hkhtSB1M2MZOe/dGrITGev
         ZVyaIAPyw3J7JMCrHmRhJFnfQ+7krO60VrlzojItRfNma/oG29D7fME4MCjcNkZjh8YO
         avn62bKPJqMD6Cp02ZdZSwLqsdGGRIPEt+U/EXd9xXq9HdRVlgfN7oHb1GBLzKVlATac
         N0cTB7PadegiZHXgJg5MF5s9matxeUieCXYvGru6FnydN6kP/R5HP7v8K+Ns156SXhbe
         nn5l0YtwyweQOlTMf123X1lDHMeFOU8DZiFTQz3OuXPzYGCGPaKrElK2oFnH4TtRvDg1
         +Bqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070934; x=1787675734;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y4s3SdzysyF0cpwVmIOh8j6ah+K+701R9CGnrq6hKDk=;
        b=BHMqrH+6in2XCv+YdqzAH34csE8RCP/BKvY7hEMIsfIDgdAClHzB54LKa7OJwDRS2g
         51mt7VBwEmvb+jYl9d+O/AUm8hPfaTr/wKzlRN5LJEHgzEAdZU+c71E2U7a/OvgBsyO1
         NelpBi/OfqSC6tLR8ng0/4DgKeRO6WeZ400Xo/mj4z6aPHaTcPSTsoEbtz3c3hNe7vI8
         ImJ4I1xnj5r8dPP1jQQmA2ApdUipoWD2dWTTwP3RIasE5nX7yNBUF3EcqfJnQncec6wH
         0P714Axl19MlZZ2ZeeOICgoSQmeKQUtfnJtYopicLP1m/oMwMxxxj38yCS+KcJPjayF+
         vb6Q==
X-Forwarded-Encrypted: i=1; AHgh+RqWohwYGgMvxyu0l06jKQwlwqwRYOT5Yf5qvBuxLFtZBsNoJIrw8MrF6FrSOAkpnglUSrdrbPwirg==@kvack.org
X-Gm-Message-State: AOJu0YzIMqJYEQF7DIwo6V/LRlgiLHLXMdHZtToEBvq2eSY95/SkpJyV
	cZ5ZQQIiGGa7IyfVELWO2OJRMJ6XrPzqi1SrJD6f4iT2thKPRJg/MZN7Gp9NuvJo5vIa6qHzyPi
	3JWyhfOavDO8gstO2vQ==
X-Received: from ejcxb1.prod.google.com ([2002:a17:907:ba01:b0:c12:4f4d:9db6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94cf:b0:c16:101d:7afa with SMTP id a640c23a62f3a-c2188a83758mr569918666b.16.1787070934060;
 Tue, 18 Aug 2026 09:35:34 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:35:33 +0000
In-Reply-To: <9huzv79i6rff.fsf@tarunix.c.googlers.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-12-tarunsahu@google.com> <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
 <9huzv79i6rff.fsf@tarunix.c.googlers.com>
Message-ID: <9huzbjazv12i.fsf@tarunix.c.googlers.com>
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
X-Rspam-User: 
X-Stat-Signature: 676qi1e957zthyskm3dwugnk7qtuwadz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8763E1A000D
X-HE-Tag: 1787070935-105941
X-HE-Meta: U2FsdGVkX18+aigTPy+iGHy033PJ75zvgqErTOKdyndkQhHt4UvfpDWlRpyM3GD2LAhS3lQCQFMErMJobBy46drWUrOxDVA05qgjcmyO4i2R3P23y6QP1TihXOeowxKjc7XKzqIYOQaLCXvmY2EOxvIjQYhDPAbPoEWIqKjfEOY0NmNi9stA9jOCCxF1jMUlepRC6B5lw6iv319tf1Gu7waCwmkQ35rSo39Zz5b/Tbx0kIYHw2z7UQazLhdHRPKlu4e7tkHvLjMrzLKxFmepJnTAbUidBAsKFNWfVanjtuwtj1o9vHSKx+lUeeafWW1B8iIzGf+DhyjqKvVyP8ijljPdmi1z/MChxp8b4H9BqWDELYdQ7VgFO44YGRaG55+d+PJ3rLs78TEIv7wqWQssOKDYA4LH02Z2YJn66WxLhUJx9073q3UYTGb9BTb7LXbRk0CxLWMAZBbx0CtxxLd60pkb1sTnrf+yZSTqf9hoNiOw3vmC+H5iUIDfyHlR5kAjXF75tcWVZs3iHIumzNS7eYBXjhCr97ONEKsrWVF740q8do9L/r4wZQJYH7jCjEponyv1ZCA7TdPoNcqNLFSiMJo65Amhgpzv2hhqomWOt01IeLk4djmgT1b3nyu/ZpN74DzEnroAqhZL7J68RPqPtmYF7OKL4Oo/56gwawmgYfVBdMOx7pkunkF7hVYuKKgGMxhxhbvomW7mf1Uw9w6VywBbCOztODuojmULUeq7uPgV1N06yYFKWLFoFFoiE6yiQXnTzPN0DC1vDOQ1r9/0ctd5LEp76BdaFAcUkSYIJXgO8MmlgBpQSfl33SVV0tf1I8hsddX0J/7RYmU9joPCtJuT4Fp/3DoznOXInIhllN6/dj6dQgvll29FngfStr8gvuhum2O1+GZDr36h8XlfbOW5+ee+iKS0KsZ0A7nLuefEc6Kd4Jv6jDFqiGKxNYKagn3yYPD9bic+JmtExJW
 d9dnqxuG
 oj3f6QgLVorVCjg+IGohu9f1zWLYAEMqPj0Mm1EZd8uAg5DFvw0VXExyZiz8fXvNKt2WwNcw60WHy7B4aAgTOquwWAzAnxgbie4WBQAMZHQ8VcewzjAzwXm8WiE71hYBEFo7GS0Z/yq6dMtwzG817OEVy1S73VBWw14kyF34tO2UqKNhPb2cucE2cuF4Sa+SJHk5m3W3TvAeTiOvEoekru4aBYQhE+2lLel6cSNAjpPq1aM4luwljcmkIaMdIgOtiDr5yB/VtYfHiBq98rRgTbNmLAkeVwMfX6+nJqwvQlFLL/OSYMBMpsux0l8Lqame/2ttPqeRXrfGMXcpVF4DgPAqPMtFLKvs7mj8WMQrgd4gxNQsf0JRZq8hbvhbsMIJYIcpgXrUKZypUI83ZP+6R8E++ETG4eXy+v3b7TnOxaRTngCPYeI8s5w3Bv9bPRxuebeAfCTrlG8WL+vXcAgZMKUGLRw0Odf1+NcqLTfclwhqYQNmYtsG9zo40xRUgdUZM6T/oyrfqQqLCyZrUxRsPNx+MYQ91AWyXd7HrHaLru98eliGl/yC2ZxdpdfQBkXP1RnKE0239vrRZ2S/bmK3AFlmSIzN8kmfp3l2kpKhxsmx3uKCIC2jawOfaMUMkqzOQRjAxo083k7nq7/qjfpahZE/iNJtv3T4Xz1G4iUikJ827GsSUiJQjNHEhjLU4nkQjJ+y1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Ackerley Tng <ackerleytng@google.com> writes:
>
>> Tarun Sahu <tarunsahu@google.com> writes:
>>
>>> Add guest_memfd_preservation_test to verify that KVM VM state and guest
>>> memory backed by guest_memfd are preserved across a kexec reboot via Live
>>> Update Orchestrator (LUO).
>>>
>>> This test includes multiple tests
>>> - (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
>>> - (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
>>> - (C) Test to allocate the guest_memfd memory after preservation because
>>>   preservation makes the guest_memfd frozen. Which must fail as well.
>>> - (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
>>>   kexec: Below is the details of stages in this test.
>>>
>>
>> I think we should split this into multiple patches, where each patch
>> introduces 1 test.
>
> Got it. I will split them. I thought that this test already spawn a VM
> and other test can just reuse the same VM.

From upstream hypervisor liveupdate meeting, I realized you meant to be
same file but saperate commits. Sound good to me. I will take care of that.

>
>>
>>>
>>> [...snip...]
>>>
>>> +++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
>>> @@ -0,0 +1,357 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) 2026, Google LLC.
>>> + *
>>> + * Author: Tarun Sahu <tarunsahu@google.com>
>>> + *
>>> + * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
>>> + *
>>> + * NOTE: This is a MANUAL test and is excluded from automated CI/testing
>>> + * frameworks because Stage 1 daemonizes into the background to pin resources
>>> + * and requires a human operator to manually trigger kexec before Stage 2
>>> + * is executed. Running Stage 1 automatically would leak the background daemon
>>> + * and cause CI runners to falsely interpret it as a passed test.
>>> + *
>>
>> Usually there aren't many printfs in tests, but since this is a MANUAL
>> test, maybe that's ok?
>>
>> Would like to know what Sean thinks of this, and printfs in general.
>>
>>>
>>> [...snip...]
>>>

