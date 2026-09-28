Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4DFDC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A9A6B008C; Mon, 28 Sep 2026 09:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCA36B0092; Mon, 28 Sep 2026 09:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA636B0093; Mon, 28 Sep 2026 09:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59A846B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:09:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E51C01C1DD4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:09:39 +0000 (UTC)
X-FDA: 85263202878.01.5DE8824
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf17.hostedemail.com (Postfix) with ESMTP id 091C740012
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:09:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BKCarKSr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790600978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Tv7M63w17ElfFd32vLV8raQp3cLLJqmMrgl8abFNtc=;
	b=FvcUjFyi7ly1YYV7nDcit2VbWP1ZOw0pFyfiCa6HYzDk67F5d1w5zPEj+J4BbdLs1A++1f
	e7fS2Y/fWsuvHxD/9iGuMBxjd7i4idoCQwpIFiLFvIQZpQNxctDxIA3Lf+xZBajn3R9lq3
	tKqV7OKf5mwtIlN/xqXpvJ3Y6wt4uPo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BKCarKSr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790600978;
	b=GoYEMB3RRZnWgAHxmzsIcm036YPWWobqpWvwzH4RsChRk7blrWLm0Sx8uAvcBvADdQuBYY
	MnBDixZJkatDnC9CyNrIFckL5JYwy02CVXFgrH/k0LVe837vVaqxfJ/9AFoK1fJVjP2G8J
	gmd1EGk4r4QW10ZG7mJn40HpyKSikE0=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530de452c33so29330741cf.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:09:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790600977; cv=none;
        d=google.com; s=arc-20260327;
        b=V2Xc2WA3E+Is8oKIsG8zDt99/67MQPIszminrNWRjEpME9t7fqLnG6VMbQxxepnGCa
         6XUk5CNqhE+wW+q4E/diQJ58KwH4Vhpz2Dz6MqWwxjA9EoG0lDsXPIVa96VGi9MFlW7e
         UkcerC1CJMe12r8hiEdsxy8tGsJvqJFYThxhUk1qouY6Be6QQu7MHTIuF4EfH5AotKUa
         wbhNvzHzPa/p1xgqTmm2EDmgCPe1a5lhbY8uJUF3Omc0YXe9BImGgPUiAFzJbvbtKz21
         ycRdVqWeIKhwkOLavLVzLyRVFfxYcNza7h5FwvjaJdp5XOgDPX2pTP6gstoZALkNko+R
         delg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Tv7M63w17ElfFd32vLV8raQp3cLLJqmMrgl8abFNtc=;
        fh=hAmEF9MMl/NXy2UsU6eKXWD0uElAYz1278QmfXBJrSI=;
        b=BXwgIisad8rCFmJ3g2DLEyJRXcUlPh9IwPYaDwAe+8XvLHpXjA4P8Utua/EdUJ++VO
         Q/tU9BF3+SVQ75ulJ5iM2CcjcHJ7hTD1PQdxOPhm8v424IlhA8k8ltooqI+id3UOVfrC
         2chLX87KFNQ9/TtN/IM5xv2qOi/C693JodIizC9KtJghu/5KN/Jz9raPEvj4OVDB45W5
         GzUfTMx6epo2jV5cXBk20GbPQ9D6XLMEuOiFINOSHEeEufSIUVSUS1x5tFhYTeXzASG8
         rKa3esw/kY7VSA0LmfUmMAIIgMQREx4kWdwLuEVNvkmEwGb1XSjIhC7iJuNz5l0bnwG1
         V0ew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790600977; x=1791205777; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8Tv7M63w17ElfFd32vLV8raQp3cLLJqmMrgl8abFNtc=;
        b=BKCarKSr0WpHu5WO8ELB4V1jPWOEZyE19m6iASSR+othr7XoTdkRRcpMTvfw4JMt0q
         EWP7aPdawcfEqWuOKHEMefGlHBRrGEqiyYuss4YU8qQJqgnm1598bXEPP4JjX3d4KztL
         OUlAAYn65CvHK6tmEXZCEGmvsYruak+SO3Hts/8twpw0JPuGuMzt+f1q3gyty+nAwdzq
         oBpjiv235qXWjVcNpx/z6qt9gI1rYrPnRDw4dFOcIy44m+ynAUMdmxcx+6F7dkC2JBCT
         khJ0OGtWkv3bDg1+VrqZGF841Tqu58tFYHNKIHFpySZwAtf/ts4EuxGOJlrIDOzNHLXc
         9BRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790600977; x=1791205777;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Tv7M63w17ElfFd32vLV8raQp3cLLJqmMrgl8abFNtc=;
        b=wJTkDLsbbpQrYFS86ShqTwG5s8ZyHFfgWF1AHhzOjijndUBToeGXPoVtUy76sRGDaD
         9L9DfMRDup5PvAZR1FMr7VELfJX1WjArMQ7qRRjpCu8Q4aqadLfdKXogdek5fUzOOsFU
         OvnnmGwxYBpzu6Xm1vo4kgyBzlwZAQcE8gAy4VhWJGwrvOoWhMuej0nUXqwoPsz5oKt9
         KdNGD61pLLeL1DhK5SqWXYq74VZHQ+7kGUYt+msSeVgy5OmPdjIUPLFiOj0W1Ljx5IL1
         ZP7Dvv5gUikrABk4RPuS6JTo+I64/GIFQhS/8s7dl2NE0oBIpWik+kXhFfQbyeoiy/EF
         Ek4Q==
X-Gm-Message-State: AFuF++mqe7fOw75vY/57l+S/ft+QOtFfMbVQnOZ6OhU1OqFTO22ygo+r
	pEM4IWVtJnIBFyrPWkdMtRfIX4/L/j9R/6Ms6u9pf2s0skGxle4JMUPrZIZH7uwv8Y4rVzZsGB/
	nfetKDQZWTp4+AxVfc4kf2ycjCtlaO8k=
X-Gm-Gg: AYBFou0Gq5lQd8DKoXCwhiBc6KFfBFzPP6EdMEUn0k5OKeXWfUyyZvrwo9HWVJXvXnp
	+dbPSPHg6Y5yvSwKiFdESOfcOe/9PDCs347YEKZO7j0Q9FyU8Q9ZsVcVDk6L0IBi+l8HpNOJ9uA
	uKKhStvmrZ697FBow8hAhhrIisInDuJD6pdUgkV7HBEF/Dxq4S+zwxRVfspWJMtCVIFANo3pvFG
	1VuLPOsfG7Rx1eXSgHKFkMbfVPpKFq0yP8BDAKUpqBSrX0DZKKQNNrpTPwzOCXs5V8pLUgoHTSq
	W5IBDajGsM9xdX9vJsoHdy5Gr91nDbTlwDSoF6vGJo5eopZ6otfFYUAeM3F9Cb/mbOkucZIORPi
	I01a3yOsMO7YjQZ9LKEzorVvYaPf+PPPItKdvgA==
X-Received: by 2002:a05:622a:10b:b0:533:286b:f7f3 with SMTP id
 d75a77b69052e-533286c0360mr163170121cf.14.1790600976900; Mon, 28 Sep 2026
 06:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
In-Reply-To: <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Mon, 28 Sep 2026 21:09:25 +0800
X-Gm-Features: AclHuK_ZQkdzhTQ5abxUqF61EpaiFGHHGKW4iV1UiQpaKJVQSJSUXWR1OO6SJ44
Message-ID: <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qdtogfpb8dhud4i4om6bamon6byg67mx
X-Rspamd-Queue-Id: 091C740012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790600977-514703
X-HE-Meta: U2FsdGVkX18KEJDfuTqGUTUFT1LuOpGrBxXLfo4isNaEB1Z7CqDKaYJH7i0dHSXM8IkCEdaSmwCUhh7xz4HoO7Ev5KeBB+O5eAb8kvGMoNKDwnChXsDFvc41fnTpWzl14qVMgTfYt75tTU14l9118SF7sovJZNxywH7kfQqZdQvdH+iA42LiTCxfm+Mbef2kwKheAOZpI4qEaGVt+HXeI4F7ytYRdya3OTxn0sdP0GLeX9LQREX/9WpxscSadS7cmYOlNl41jWPxMR8OR7A14UBz+puGXpqxXXMamidHeUF78U8UwaFNB181JruUzHbyuj0oHBDDueXlTuSyai+QmntQbPQap5rt0aZlRbDKr0LHL/UeoeTm+fcpNlcHUc3biC15KuIkwjYVaDTUjsdZmzEldvX3JtDom54qCig0zCns14Vj9gwTiN6qbSbjIWXRizyGPL00c3vwiSgXpgdelzR8J16MRFvUThyoPt7ShA9IYsMXe6WoonB0um9gE4LMm1j4gVpfZw3HYDEUXWVzhmNkfvpkHRdsrZXiUM2y5PuQkQqwURq1iDQ8riF+ti+QsIPHSoCtPy8Cb2EeWhu8Hcq102B13xHk/fPSpvAItjcjXJWbjduE+LJbOs0gWB6WUMVZglueBg3oz/kDPXhWu0rNUlEww+udHzxCSgh9ZwGZAgavfbrtPV2hKPqMVAPOkGLVxBrMVw8q59vs/q0yecWZZ9Ch4GVo1s5g4h5iFX7pOwZwoMChp8vIdQ2u8+ALN2tojetCWnvMV02nVYEVRYRzcJKjjiqB5hJMJkAMvek0IRh0C4/m8kQQpyz/8+eZZjSkMbBFC74pfW+unit93et12mDIVAPhEq+wCI1Zywc8e2/tBl2mDxRt0KiV7Q0R2z//Wy+cWqLXp4qzQTLx3m4NkZy1Qv+24WRFeogdS9sxpgzECvcq4sQhhzxyaX9iGOLvJoNMJoIkIv5Wi5B
 4DoFwjVm
 ne+mXyBb5x7VNZUTzzFIfafG0aC/l057NIUfUhZpb3wuVe71NujN/0+7bFb3DKZuzYMGyYgGQApGZ2xTUKLo55Z7qx9SuVIHX0QTrsAKZfyNh1QsjD4V7rKuWSm9aRWS5RfVUjbCjmaWmbafHpIoZMorwq9KE7I94oknENhJAQtpJcUZXTtaVk79KF0U6ONRuWqV7JjybvcrcNG6TXsarxTsVx+/4wjG7xr7tRZh6JHVya8yxS9raNJuBMq9820lmAtSBlzz5x3g6EmQ5KMw/G7JvJbqxd6HRpqneAqR/wV5WfKXO4RDa3s2yrETscyxYmc5LOPWpbrCTbd34jVAVz1akCNNNA150MGH84TEu25/gw3DN1n2CG1V7TZy+xCHc0H3BziG+fyk1NI+NQD7Qi7L470wmdLu9B2bK3qBiOQaTuH9fkwHjMIesWUSbxRrax1R4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

The use case is a concurrent, lock-free, relocatable data structure that
uses offsets rather than absolute pointers. It implements copy-on-write
at the data-structure level and is designed to remain recoverable after
a process crash. We therefore build it directly in a file-backed
MAP_SHARED mapping, so its state is not lost when the constructing
process exits unexpectedly.

Building it in anonymous memory and calling write() only after
construction would lose that state if the process crashed before the
write. It would also require copying the entire structure into the
file's page cache.

During construction, writes are scattered throughout the mapping,
dirtying pages rapidly and repeatedly redirtying pages that may already
have been written back. The goal is to reduce writeback of these
intermediate states while retaining the same page-cache pages for
subsequent readers.

The hint would remain strictly best-effort: memory pressure and explicit
synchronization could override it. By "process crash," I mean termination
of the process while the kernel remains running; recovery after a system
crash or power loss is a separate durability concern.

Regarding the interface, madvise was only a suggestion. A file-level
advisory interface would also work for this use case: deferring background
writeback for the entire file, rather than individual mapped ranges, is
acceptable. The hint would remain best-effort, with memory pressure and
explicit synchronization taking precedence. It should also be cleared
automatically when the owning mapping or file descriptor is released,
including on process exit. Would that be a better fit for the writeback
subsystem?

Thanks,
Peng

David Hildenbrand (Arm) <david@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=88=
28=E6=97=A5=E5=91=A8=E4=B8=80 19:29=E5=86=99=E9=81=93=EF=BC=9A
>
> On 9/28/26 09:07, =E5=A4=A9=E7=8B=BC wrote:
> > Hello,
>
> Hi,
>
> >
> > I would like to request feedback on a mapping-scoped, best-effort hint
> > to defer background writeback while an application is still constructin=
g
> > data in a writable MAP_SHARED mapping of a regular disk-backed file.
> > This is a feature request, not a patch submission or a benchmark report=
.
> >
> > Motivation
> > ----------
> >
> > Consider an application building a large data structure, for example
> > 10 GiB, through multiple passes that repeatedly modify the same pages.
> > After construction, it persists the file and publishes it for other
> > processes to mmap and read.
>
> Is it an option to just construct the data using anonymous memory and the=
n
> write()'in it once ready in one operation?
>
> Why exactly are you using writable MAP_SHARED mappings?
>
> >
> > Building directly in MAP_SHARED keeps the data in the file's page cache=
,
> > which also serves the consumers. However, background writeback can writ=
e
> > intermediate contents that subsequent construction passes dirty again.
> > The application knows when construction ends, but cannot express that
> > knowledge as a mapping-local writeback scheduling hint.
> >
> > Building in private memory and then doing buffered writes adds a bulk
> > copy into the file's page cache. Direct I/O does not itself populate th=
at
> > cache for subsequent file-mapped consumers. A memfd can share the build
> > buffer, but requires a separate object for persistence and changes the
> > consumer interface. Global dirty/writeback tuning is broader than this
> > particular mapping and construction phase.
> >
> > Proposed interface and behavior
> > -------------------------------
> >
> > Tentatively, a pair of madvise operations could express this:
> >
> >     madvise(addr, len, MADV_DEFER_WRITEBACK);
> >     /* Construct and repeatedly update the shared file mapping. */
> >     madvise(addr, len, MADV_ALLOW_WRITEBACK);
> >     /* Use existing synchronization calls if durability is required. */
> >
> > The names are placeholders for discussion, not existing constants.
>
> I don't think this behavior should be part of madvise. Way too specific.
>
> --
> Cheers,
>
> David

