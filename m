Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE29C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081066B007B; Tue, 11 Aug 2026 06:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031696B008A; Tue, 11 Aug 2026 06:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E633A6B008C; Tue, 11 Aug 2026 06:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEEC66B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:06:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD606A23DA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:06:10 +0000 (UTC)
X-FDA: 85088558100.08.1485A06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 27F2614000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:06:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IeDAQ/7I";
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786442769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSgyWUQUOXkT3ixZAZs04DUNanjZeEZwO2+Fu0C0pOU=;
	b=RodXnhwgVhsuJOI8LvdBf7xGDpAe/w8AA7Q/h2bM6gG5UCDFXYkUdn4jDd60v/I9pClGy2
	niDGGSwdlCl3f66ScRGuWKElMBu+HJiRQmP0damRIVka/OqbfpYxiPSTznPNCZE9K3n7VG
	T37Mhdao/ooDvOuvATO9vpHn1jAAB3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786442769;
	b=zHKWMvDShqFHd5LgcJ8c8SDuB/BMi3hVG2U0B5WL8J5X+PToNtc1IbOyBbux1Zo8GnOmLx
	/3m2dj/nTAzvu3cDTFQJgoK54fUCI8jxfYrl8XNPqTCQjKdX6Rqyjnkykbw/WpIFUWb5Ew
	eYAGKLoJ2bv6bIxd602+i4AFO6EfXVs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IeDAQ/7I";
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C904412E1;
	Tue, 11 Aug 2026 10:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4701F000E9;
	Tue, 11 Aug 2026 10:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786442767;
	bh=uSgyWUQUOXkT3ixZAZs04DUNanjZeEZwO2+Fu0C0pOU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IeDAQ/7Ish/yX0U8VJXoYoq4pKb7kydnqDGq/pZDcnkkADYcmeOfiyjd/6K4fk7IH
	 cD1VmCa377mV5C7Cj0vQzAc2AaiKI0TEGHX+U9dsQGnFq+puC2A9vz85sQwUiPpob+
	 br1klWfTZVFVWBlODjbrY3ZmJgoyU5EMYoE8/kHeBCejB6ke4jvIlEH5OBQMIZa5Pl
	 dwv9cup14TcREBxrxzhzwHaGzpYe3kbMzp1upF8cguLIWjEwooCTtLccIjuF7PRNOh
	 pQysWZPHJp3QJ/A7Uqv3HkfY9Gk5toww7/fsEf60j8QNVj4sYYJTNbMd7S/jJfTE8V
	 QXq9+WdeSKFUw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>,  fuad.tabba@linux.dev,  Andrew Morton
 <akpm@linux-foundation.org>,  seanjc@google.com,  dmatlack@google.com,
  Shuah Khan <skhan@linuxfoundation.org>,  Jonathan Corbet
 <corbet@lwn.net>,  david@redhat.com,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  sagis@google.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  linux-kselftest@vger.kernel.org,  andre.przywara@arm.com,
  michael.roth@amd.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  will@kernel.org,  vannapurve@google.com,  maz@kernel.org,
  fvdl@google.com,  kvm@vger.kernel.org,  oliver.upton@linux.dev,
  kvmarm@lists.linux.dev,  alexandru.elisei@arm.com,  skhawaja@google.com,
  aneesh.kumar@kernel.org,  linux-doc@vger.kernel.org,  David Hildenbrand
 <david@kernel.org>,  yan.y.zhao@intel.com,  kexec@lists.infradead.org,
  suzuki.poulose@arm.com
Subject: Re: [PATCH v4 11/11] KVM: selftests: Add guest_memfd_preservation_test
In-Reply-To: <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
	(Ackerley Tng's message of "Thu, 30 Jul 2026 11:18:44 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-12-tarunsahu@google.com>
	<CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Date: Tue, 11 Aug 2026 12:06:00 +0200
Message-ID: <2vxzy0ed3rav.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27F2614000F
X-Stat-Signature: 7b1mq183rfwqqcoztysofhz1jngae9wf
X-HE-Tag: 1786442769-967182
X-HE-Meta: U2FsdGVkX1+5C/9i0blr7jPZmd/Iye5aZE3nO+Lfl8pDdREBWk8kWVUSMgvQdEHz6VepjoRNUGG2fem5B8GT2ZgDV1I0MFDk79hZGI4pdfetcPJVIut0RC+gOPmg9Xu+828Lel93B2ur5AsAeZHtOnwr8TEhZHEKoN3lgC7ifV1dCaGkCnjPrlNlgQ320SgSNhgZXzo2sJbAWwTwH6OaoQhW8tUMpFYHhJsahSjU4HDs/Eiha7WY8Lr1NH+F4A/S+vkVAElvX17u/5SkHtWOKVaLRiIhN1Ju0YTrTaOs8CxeruYTMAKDB+fDlWbBV34LKFZg1IYXJU0inB91IodZbAVi/PnSUsWGL6VU6Wbza0faTh31EClK4brAlCFXUyO77ofqoXf9BzciFQT9C1cmTWqXpXU3EwWPuO5zQkx66faY3Mu82Ukw8GqImIQiMLkJG0YnEpmV3NLNRm8f76lfYGp5aQG8qBQeWH79cK+VVht4LPJ1XiMTHkp7qtGUGSflsCbCILvmSyItNVxnlCKASCSJv/tTwK/AdhA7g/4iGrIPlRn+FD3a4JGRfB85QwUjtctX5nu3K0Z79rDp8qCUCTNgyh3BjoliAhaIVB2qUK8UzZTE788mBt4daFBjCvVNQ77ZJkZke4eieItU0pfRQ9/KSVx5G2784ZqQDo2JONsjkXp+4UFsYk9xidNseYOGF6trqNHFaqcZRYHDHmwyXU+tCn+v86XD708dWlzEYWW4cOxkBKSUgfRjM3890TKZ3k08KU1aZGy687nDDjtzLsl9cyjS5fybQydfR/TXQabi2SarS5xz6lpJx8DoklUsjfn/g6od4i0/5L2ytgBfZKcR54TNhKLTisRTO/aVRhpAauqoFJ94RIpQufK/jYNkhc5252RmpVwoiMaLOBHGIlsbT/oUXeMV527tetqN7A+sMhZreiNfSzr86a16yENcIjqbzT7gOj7ZFOr0lq3
 KRd587Iy
 vesn2RbazPoeL6Hk0iKVQXnwumA+rhShhT1qA//XBcxLOPZTT9gOIt9ylFAEXi8f6PbkYW9/tONQAzx3McvAL1lDW18EROoNNJY9MZZJnHqNRMtsGZ6LDEAYkCDyqa757uaoxBGxkEsF/R454HXEd4AKKhNggPvy19Fxcq4XAJonSlITh1Mtfy5yqBz6Uc/QyxAPvKkDW0Iti/SNoofiGZ5CltnZXvLDvtRNI2sHYZTPyQoNCKQtIzklqF2m+sGAib50pViuhtFiQPT4s79F+OiH6EbNmqeozyk9pPhjrhG8wR2FafKkEqjX6vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30 2026, Ackerley Tng wrote:

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
[...]
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

I think this is fine as a first step but we really should automate
these.

We have some infrastructure to automate other live update tests across
both stages already by launching a VM under qemu and making the test
process as the init task. See tools/testing/selftests/kho/vmtest.sh. For
KVM tests you'd need the runner to be able to run nested VMs.

The script right now is pretty bare bones, but I really think we should
spend time improving it to the point where we can automate all our tests
using it.

>
> Usually there aren't many printfs in tests, but since this is a MANUAL
> test, maybe that's ok?
>
> Would like to know what Sean thinks of this, and printfs in general.

-- 
Regards,
Pratyush Yadav

