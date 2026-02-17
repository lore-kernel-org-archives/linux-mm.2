Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E749EE9A031
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE496B0088; Tue, 17 Feb 2026 13:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF836B0089; Tue, 17 Feb 2026 13:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBF16B008A; Tue, 17 Feb 2026 13:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC506B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:57:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC27E1B3C6A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:57:39 +0000 (UTC)
X-FDA: 84454857438.27.9D64042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 202B21C000E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:57:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=faekKi3A;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771354658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bwXcOjioFdwS7/gH1RNiAODo0f7GCIOswJXMsp6RiI=;
	b=PnltrcbsaKBaQUAEuaV12ZmX73K/K3EtM8KLn9i2Fq+6ut7cMcuLhs5bEynlh/yuVEoqb2
	rSRzhegK3REKL375WIC9Ltc3yAv/PSK8BCvtXudFzh/67y1Pfgnl+dxKhUKUYZEF1yaztw
	t1nJA2MV8dOKSpHqU4tnft/YLOVmgWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771354658; a=rsa-sha256;
	cv=none;
	b=jmxhiR/Z0P6sSyWAVcFv41Frr7hri+GAffy36QVKV/McLS30M5oYmZqJTPPuFeunSbZ1hF
	wkRWnZb4ye2tCppNHMCc7qqNfFjIEmnEB1Lu2umLtXNSoE9D3ZkmLV6zaCjUApGcA0hYGf
	4+Q20+RJ6KFw8VNEsIC7D+BAaBL1e5U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=faekKi3A;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1EBF44275;
	Tue, 17 Feb 2026 18:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B89C4CEF7;
	Tue, 17 Feb 2026 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771354656;
	bh=wP3hKCDKoD//66i9JGFv6lSpkvVqov8oBCX80QQgxRU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=faekKi3ABnzzfMhf/GpMsx5uQkWh6JzJ/zNH+76CuSqqyBe4U1CoM1BO2CwH11Du/
	 y5M031XAgWUU9X6N5PY7Q3byMy7zPzGlfLynzM8GyEDcKvJP3tQlf6ODwEY/JOsbCX
	 U/XwP3zc7E+s5dMqV0XO7x6Q1FcayH04RS0ZOPS8rZmctg77eHgo3pr+FkNHhM7MdF
	 ux/ujJFqHGjAFfNsJznsV/abNOu7YXbtUVWzo+rUPLhNN+g++JgRhQIAltO0ztjeQ2
	 0BcKWKdXINMt3ctD5hR+J6n+N3O0NfSMTtEUi8W4hYCAeuAiWi9Y7UjU1GlzaNd/WH
	 lwak9KAQkCrew==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Daniel Gomez <da.gomez@kernel.org>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, Alice Ryhl
 <aliceryhl@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, Daniel Gomez <da.gomez@samsung.com>,
 gost.dev@samsung.com, Greg KH <gregkh@linuxfoundation.org>, Julia
 Lawall <julia.lawall@inria.fr>, Kairui Song <kasong@tencent.com>, Luis
 Chamberlain <mcgrof@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
In-Reply-To: <CAJ-ks9mhOAgNKjepUOS918q90JkmyqVU6axKt-v35Rav+MNy3w@mail.gmail.com>
References: <aZRncP-sKLLS2K1U@macos>
 <Zy05aTxJToTSNNCXvTAVZ_iEi3KkZ8R0an9b0G_kemt0or0JyRUp_dfZ79wuF91J6xV1bna6fZwo5rRwsrlgoA==@protonmail.internalid>
 <CAJ-ks9mhOAgNKjepUOS918q90JkmyqVU6axKt-v35Rav+MNy3w@mail.gmail.com>
Date: Tue, 17 Feb 2026 19:57:24 +0100
Message-ID: <875x7vci5n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 87etbk88mzwurhqs5aeg6zdo459kfen1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 202B21C000E
X-HE-Tag: 1771354657-608090
X-HE-Meta: U2FsdGVkX1/1xRschDTkP/KZOsR8QIpdfaQ4pkzHYQQZEVe1SYiNzefWbizwdzsdDIzQ3FBJb5UNrou8drdzUEOIrS61rs+/kZXUKS5lJL61egqebwISf4hPZpUm3dlZC5yKQMtLbFCiAMsLhuqvuy48PcWq2p94w6IDkMxtj9XBMat6rFZrvIviQrs0wOFBA2GLWOw0CptHXL4rT26G3D0GEmkmgnecaymD3XSDwv55e9pBqVVlsqvw+ZsNFiylMijNy4qsIyX78ZMTAnZVR2jBp60s7CS+wqQU89WRob/clfyYZikEUhEKp+Rv+rhLUp39thdap5+0lornBDYCstTExKDniVglDOtXwaVwslcMHXEV/z9ivXeQ8AnDs51glrsyfIYwhipXcMJoqZcf6G5j10H/Dt93RU66lCTkP2CARSn4ReqOigfi7syvBn4YqkJKKje4ZLEwTtV3uwgYjzO7eSQcBZtsUeME7PqqBzCyuMaeqMLXIygJV2TWON10ylT6nBdaN+IVmz6KQPutvpxEmC6qZQq0DwK96C4HpEHVEh77FC4MH23xnLmo5L0k8MLvzDM2QG4nTquO8JbwAyAASkWt3bVIN0nNK6TbEMrBtMjcjxKIihXDTEeRoytzC8hbp2JHpgqSGFKD78XbnG31w65TN1q3Q+0yHqv3cSz9H9827YPq2h+f7lnIC1Aw47nN2Du7tnnbWzu1J/8wy3kRNxMNkKB44K/VbCTI2bdToI0U8HeFEYpQyrnv6pdVN1sii7LoFshHGeQ43OlJ9XH71aFXObII+uAf2HI1CbsxbSTMKq1QJGzCe/mbfutkX9GwKbLoXEc2guN29Wh4KiYKz96EDloAkv1A2Fdo/bzw8IaAJN0RnxD6UsZo8lflIC+8Y7q9xTrzaJLpBvLKOxJZeXQQOay4T0+BkplgnSkxVmqeH+qFEQiJmk96IBSL4OZwI7grAoW0kMvmfdo
 mn4JRSYK
 CIRShmb69h8PwhwNwKJFQuRmuDpAdO3y1dl8H/H2o6miIXmLXi32mj0wSy24NJ6m7iZq3PN/STytyoHRE26mRcRMWpmykfOoo1UIB/5+LeULmvLUIKLn/SU9IogBO/wjcrVSSfm4zgAIZLOEpgytt1jYzG6Ak0eGVIa7IiNcIP1bxU5V4zKPb3dQXq/7L5UweFNHu01k/UQUf5RQ6jBlfigjjURXrS0ZDwq5XNTmgZIb/Qi8G81TQ7iYuloattklTFRRW9U4EQH/J4FMLP9jqjwUDwMIipQsWLWrwf3UJr2MAagU574j3uuUWNQKEHjYf5IydZcHhHwdzZLGu+y20H+dMh83U7zjZOO1BHAwiy0C6MSA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Tamir Duberstein" <tamird@gmail.com> writes:

> On Tue, Feb 17, 2026 at 9:28=E2=80=AFAM Daniel Gomez <da.gomez@kernel.org=
> wrote:
>>
>> We propose a topic to discuss the potential use of Rust in core Linux
>> kernel data structures.
>>
>> The XArray unified the kernel's radix trees into one API back in v4.20
>> (2018). It sits under the page cache, block layer, filesystems, GPU
>> drivers, and dozens of other subsystems.
>>
>> We looked at XArray bugs since 2018. About half are the usual suspects:
>> races, resource leaks, encoding and overflow mistakes. The kind of bugs
>> Greg says make up 60-80% of kernel security bugs [1]. Most of the rest
>> are complex logic bugs where Rust's type system may help but cannot
>> eliminate entirely.
>>
>> The motivation for our interest in evaluating Rust for use in the XArray
>> started with a bug in mm/filemap.c that corrupted page cache data [2].
>> Consumer code called xa_get_order() without the lock, the tree changed,
>> and pages from wrong files ended up in the cache. No CVE was assigned
>> to this issue*, and no reproducer outside production existed before the
>> fix (a synthetic reproducer was only created [5][6] after the issue was
>> escalated). Kairui Song's refactoring and optimization patches [7][8][9]
>> happened to eliminate the issue.
>>
>> In Rust, xa_get_order() would be a method on the lock guard. XArray
>> users would not be able to call it without holding the lock because
>> the type system would not let them. That does not help with the complex
>> logic bugs, but it eliminates the class of mistakes where the API is
>> used outside its required context.
>
> These benefits are compelling, but they materialize when the _caller_
> uses Rust (and when Rust abstractions exist, whether native or
> wrappers around C). A stronger case for a Rust implementation would be
> justified by internal complexity; IIUC that was the motivation behind
> Rust Binder.

I agree with all of this. Having spent a fair amount of time reading the
xarray code, I am very interested in seeing how a feature complete
implementation of xarray would look like in Rust, and how it would read.

For C callers we could do things similar to what our current C data
structures already do. Asserting preconditions for calling certain
functions, lock held, etc. I am curious how much of this we could do
automatically with Rust.

>
>> We have a Rust XArray prototype that implements core operations designed
>> around Rust's ownership model. By the conference we aim to benchmark
>> it against tools/testing/radix-tree/ and use it to back the Rust null
>> block driver for A/B testing performance against the C implementation.
>> In the longer term, we plan to deploy the Rust implementation in the
>> page cache for A/B testing performance of generic workloads. We invite
>> the community to take a look at the code (when published), which at the
>> moment is rather simple as it only covers the core operations.
>>
>> We know that Rust is not magic. The first kernel Rust CVE was a race
>> in an unsafe block where the safety comment was wrong [10]. However, we
>> believe that constraining potential memory safety issues to small unsafe
>> blocks provides a significant advantage over writing in C, where the
>> entire program text is to be considered one big unsafe block.
>>
>> With Rust now part of the kernel's core infrastructure [11], we would
>> like to explore whether Rust is applicable for use in core MM data
>> structures. We invite the community to this exploration and we would
>> like to start the discussion. Specifically, we seek insights into:
>>
>>  - Which workloads set the performance bar?
>>  - Would a type-safe API reduce consumer bugs, or would they just move
>> elsewhere?
>>  - Would rewriting core data structures introduce new, previously
>> unseen, bugs**?
>>
>> *Under the Linux kernel CNA's CVE assignment policy, data corruption
>> issues do not meet the cve.org definition of a vulnerability and are
>> therefore not eligible for CVE assignment [3][4].
>>
>> **Our thought: The existing test suite covers years of real edge cases.
>> A second implementation running against it is not just a rewrite, it is
>> differential testing.
>
> The downside to a second implementation is that it acts as a change
> detector: If the tests run against both implementations (and we can't
> drop the C implementation since Rust is not yet required to build the
> kernel), any change to the C implementation must be accompanied by a
> change to the Rust implementation. I'd be surprised if the C folks
> would be pleased by this.

I don't think anyone suggests putting this Rust code into production
first thing (if ever). Current C development should not be impacted,
they should continue as they please.

It would be a cat and mouse situation the people working on the Rust
code for sure. But maybe that is OK.


Best regards,
Andreas Hindborg



