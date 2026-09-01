Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE72C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 22:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B3A6B0088; Tue,  1 Sep 2026 18:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCD56B008A; Tue,  1 Sep 2026 18:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBC36B008C; Tue,  1 Sep 2026 18:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFF06B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:42:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DA8F80401
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:42:55 +0000 (UTC)
X-FDA: 85166669910.29.C6F40EE
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf14.hostedemail.com (Postfix) with ESMTP id 97CD1100007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:42:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CSL9NwfV;
	spf=pass (imf14.hostedemail.com: domain of 37FSXagcKCE8Dwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=37FSXagcKCE8Dwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788302573;
	b=trMeBTxarYlEEwrAAcHBa3K2oqoikOwgiERO9tWUsMdr0JJpKMC1S3Y6my6LpyKrWYvwyf
	d4VXVZUaIsqQXI7atY9EF6u8syfFow5TEDYHCY53GleRljs3Fhc190pRnLW6aGkXM7r+LI
	lmaGmnRPgLZwdk6xpfRHbWoNPQpCfwI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CSL9NwfV;
	spf=pass (imf14.hostedemail.com: domain of 37FSXagcKCE8Dwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=37FSXagcKCE8Dwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788302573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVTLltgWzf3njQKdxafQ0CwqfUSU6XQwj4Ha28EdUxs=;
	b=VMeo81cloYE+JyH2I9c7k0SVqmdJvfmvifZCh0A03B3lCSnwWsDSO5p1Ati+J0d9IDLH9k
	vq8dkbMAXXcA6kO/3JjLlEwaV7AMLHGthxyxrfGubJ5g5JRl8cF2Y1erCn6w0rAr7b+cxl
	3+a8OekTtbFXqOtdgCv5M356Ge/JqYM=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6c166bafcso4010255ad.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 15:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788302572; x=1788907372; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:user-agent:references:mime-version:in-reply-to:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uVTLltgWzf3njQKdxafQ0CwqfUSU6XQwj4Ha28EdUxs=;
        b=CSL9NwfVvqcWPH6WT4bIXyl2Dh2/1nrou9MAUR2vzqVwolPf3HABtUDAYQPkSp8/h3
         aoRjM+Awu8wOPbpQUktV+yyd6htFXMsd5u/nfYzORBZWHkaXWikwlQrnXJ/LFlVxuWA5
         euI5Mm/7EKaei0pyuNDR9jhh4aVSazSqT8CJdiYbWQqqNTLfrX6VyhsKNI/xRlvyWCJE
         7A5dpWGyq3v1NLoVsHBUqP5BeL88zmiFyQeahaud0Ns5GmrRFX381eX3zWGmmIejjtxy
         Tikri9jhrE6ZQfPlmBAMhYf7Fn+kjPKeHhQKhp5KyHtioQtmkaTMJyV8PqbUN8URDO7/
         FLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788302572; x=1788907372;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:user-agent:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uVTLltgWzf3njQKdxafQ0CwqfUSU6XQwj4Ha28EdUxs=;
        b=MO/2DIoSs/LFM2OqC0Ql4+0HwJFmvM1gpgYuvR5dT7+tz0/qNQM3FpZdM9j0M5YuSo
         0B2rLuxbhASAJ3m45BxsJviXfpocAk9CkpV1idi07t9ipNavHI0IZu5GjCaGxXms7U+f
         7DIDukBvckFEO9vm0ZP7tV2m1+wbK7tuE0aZ9HOmsb+2dXulV+BSIfr8ekrdNryUYjBr
         HiqJto2E/C/Hj8P7sTLa19cyYeSTqwJlgOIbzyR2Btez0SC6B1+N/+umJgALAFDkYhUS
         c0oCwSlgA4aNNpoDRMTS1zsMDhNBEPAES1jJzUd9PDJIdjPJRzMUePu3D/kOmo1KHi4H
         OOgA==
X-Forwarded-Encrypted: i=1; AKwUvBydd4cVDjkcl1esiFydyh/Kyys1BaGV1I4BforVkXE+iQiyvPvn6LIznqV5IZpvWwHjTE54T+6eIQ==@kvack.org
X-Gm-Message-State: AFuF++lL6HjifctGk7kUdFpZH8zAw2vvQgs3PjqPQ7EhBygyHUoXC4RS
	896wYt9BA08AQu26d8135TdH4KOe80DsRloLpJFXoOsqomJb47lBGzTq+7Lq4j1AiAVMx0y1+uV
	vPOssKq6/yA==
X-Received: from plup13.prod.google.com ([2002:a17:903:4b2d:b0:2d9:56d3:fc17])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19e6:b0:2d9:2069:a286
 with SMTP id d9443c01a7336-2daec62416cmr6864805ad.9.1788302572056; Tue, 01
 Sep 2026 15:42:52 -0700 (PDT)
Date: Tue, 01 Sep 2026 22:42:51 +0000
In-Reply-To: <apaO1OHVQWJCuJDE@localhost.localdomain> ("Michal =?utf-8?Q?K?=
 =?utf-8?Q?outn=C3=BD=22's?= message of "Tue, 1 Sep 2026 10:57:03 +0200")
Mime-Version: 1.0
References: <20260901052250.154532-1-wfelipe@google.com> <20260901052250.154532-3-wfelipe@google.com>
 <apaO1OHVQWJCuJDE@localhost.localdomain>
User-Agent: mu4e 1.12.15; emacs 30.2
Message-ID: <p9738q5kh9uc.fsf@wfelipe-west1.c.googlers.com>
Subject: Re: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: "Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 97CD1100007
X-Stat-Signature: odjo1cg31asfi1rr9nbnyfksd4ctidbm
X-Rspam-User: 
X-HE-Tag: 1788302573-128798
X-HE-Meta: U2FsdGVkX1+xq7Q5AgaTG5fk4KQ61sPZCV8L9ZpkxhMNfix6DJAEhUrI4YB45RM3+usfkJy11KgR+QqDRb78NvtZnSlZOVigUsmQ5gTg06Lo5+8yPZSyJxBAejSOu+t2Kd6+3eo62i9f1MsrOVVIP5II4ibyUYWHAfwn8bHTevc2THtks3ZFy34JDGhDFVeWp2JCgzPgVOkyAXfyxtPNWIiulB/YBKqm76FbtKZ94y1HA/Mc1whs5gXjCbH+ju7MuRm1APC/IgML2/t/GZsbT60+VbKlNgx/pWVEBF/XGURs9APQcrH7WQl23WZGo0u0sNtlg+QXB1kfNV0xMBvF9ZB+iYUOoL/Z5Sa6IU/CejiKXqTvQYyBWsICWZUGl10AzKWjrai0ISakL6Z1yiNI2r6dswHHvNazeBYWvESDTXDFMHbuYeiKiYb3eXq/8bwPWyr6CRwtE9Fm6kk6shbak2cbPcJcRam8ukeCcUfpvAI0OiQOcSEGfshYqohIYOPYrrndmadTA7/fQ8FfGdYK9afNCOcua/iufObbtXJKE6TOo3mFT9rDgsCIog8qRL+NrGyoVrlsr0YuNMpeXu+dEccJI94Apzq1SGk03XEC6Tf0Gxqpq1RGV1nnQuPVNzlhn0mlY2hAi2QpLaYa46GhmFM8sHnfA6TV44pcPqhcczXt/8r6BvaCpSj9rx+c8QAUrVXeSNVDMskkLCrKn428B3betsrmRawN81qhaJfLx2cYF3ZHjUvMdNc1QqY8Q2SAoUwEAV9do8M0+acZpDCkBBJBF4GYEOqfFBnBWhwefbxc+qxSf3LbViWsiGaf6yI4qFGUlPYUFIKj4wbuJ2bMfzn2ivwK/MIuh3fDt77meK9X/c5PR/osGureTstlO662im8ckwAFouPdi+3xLNmKkO1wQVgiyPXSMNAFVGqTvoKOZuulxsNKaLxLoBkIK1kFU6Nmc3NFQq9Ojf9RdO2
 riIB4jPX
 jKtjxIZTGgz7t3td+jyNHc+H/0j6GuS0MmnT4aTHBpiz61x5LBZSE5GzWfaNecPQ1KXOJ9rTMBCGk1VmcnMAdi+mFhnCcG2FjkXCzn+f1akALRhkTTQ1p/kmNF3TuQfBPYhXxO7nSH5VHmzfHfRggUqhMwxuHc8N3KOMJqFmghUOoxH2Sf/Og6RfDROB+C9Na1GaNeLvBJtNLOK3+KO+8lJIcA75gywTWrDMf613TNGnO0kZwiqjgh1HHoLuOg2CoQsQrR4m4iYoN9S64MEfb2+TFiipAp28TcF0temoZT3FoVNsX/Ma+ElxIAMOWGXRhEqbxAeNjbAOa68uoFsvk/IKvvvyFqS1r3CWHqLn0AfzRg1lLNgCZ0wJHZeZQdPcCgbZNXUyKNbAFSuPvxeO4jZmit6fATgR50VDCD/qMbWERDfQ9H8VgurLCV/T9jCYVtbL3jKoU+QZV8e9MORt7L0xHpSkKBVy58jcN4YC/A2lPhy5A+dmvGIVC0qYQ02x/PnB1rPhjR6p5ujjKuryWlR7p191NBPL19oOnjgnSl5PJtF7z8qcHaK+2YMuvo2fwhvGH2/VMxqCFBCFhX1Sdg/kWmLAzgAbYELWkun48XRpH3KeLQ/QnWCcdHaD3ECWDjOej4QcFjRoCjWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Koutn=C3=BD <mkoutny@suse.com> writes:

> On Tue, Sep 01, 2026 at 05:22:28AM +0000, Wilson Felipe Pereira <wfelipe@=
google.com> wrote:
>> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
>> checked against stored_pages * page_size / 4 to verify that the pages
>> pushed to zswap belong to the test memory cgroup.
>>
>> Due to slight stat update timing differences, delta can evaluate to a sm=
all
>> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
>> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
>> conversions implicitly promote a negative delta to a large unsigned 64-b=
it
>> integer, causing `delta < stored_pages * page_size / 4` to falsely evalu=
ate
>> to 0 and fail the test.
>>
>> Fix this by declaring zswapped and delta as signed long long and compari=
ng
>> against a signed threshold, ensuring negative deltas correctly evaluate
>> to true.
>>
>> Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem by=
pass test")
>> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
>> Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
>
> (The long long helper is a non-trivial change, so the ack should be
> stripped on this version (unless you can convince me ;-).)

I'm sorry for that! Thanks for the review and for the patience.

>
> I'm afraid this bitness propagated too broadly.
>
> The long vs long long difference is only relevant on 32b, right?
> And the bit-width issue only appears because of the product, not the
> values read from memory.stat [1].
>
> I'd consider three ways forward:
> a) Consolidate the helpers into one cg_read_key_s64() (same explicit size
>    regardless of arch),
> b) keep single arch-dependent helper and tackle product(s) only,
> c) do not bother with 32b in these selftests (I have a hunch that
>    they're not so relevant on such archs).
>
> WDYT?

I like this option a), any thoughts on the sequence here?

I thought the following steps:
1) Add cg_read_key_s64() here and make use of it;
2) In another patch (probably 3/3), replace all uses of cg_read_key_long
   by cg_read_key_s64. There are 41 uses currently.

I believe the tests could be flaky in 32b already (just a guess), at
least option a) would make all be more deterministic.

>
> Michal
>
>
> [1] At least the values derived from available memory, memory events
>     could grow indefinitely. It's true that kernel uses explicit u64 for
>     all of the entries.

