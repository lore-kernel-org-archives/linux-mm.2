Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6D5CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED17A6B008C; Mon, 18 May 2026 17:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82AB6B0092; Mon, 18 May 2026 17:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D712B6B0093; Mon, 18 May 2026 17:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C43E66B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:15:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 957DA1A0829
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:15:01 +0000 (UTC)
X-FDA: 84781795602.24.FF43246
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F8FD2000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:14:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKnQHg2E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779138899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rs2uqTkIc7aAMCm9u6DZxVd5AsfHqGkk6OElJunpKgE=;
	b=vMA/vNHCMTxACzt3WTp8LmwsgWmFbDzkgFpnz7Roe6ymmfjEQXOVS3ByO3jJoUQsbg0Tbc
	+a15P+4DUWCmr9Bf7V9BdcQj880V6DsTgIjvVaqkAONSDOhyXXf5rkhW8bAVfKoCtEsrJ2
	lTRb8MCkuaitUlb5QtMfxPve0HoF40w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779138899; a=rsa-sha256;
	cv=none;
	b=D8wAd/nqK+BqT5lUkDF2jywgd7teXIfD/cEocP/PDVUbLj++gIxvJiT1J8qWazYtYFoG4P
	werzzLZN2cKgwgUvRMpgtp4MJiF33q9pQSDmTcRCz9kBNciFpyhzj/l634HdM6KmAIcaEW
	wTEbE8KyEIZW4bs23IiFp2oPkXYLL5M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKnQHg2E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 969D2445D0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB59C2BCC6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779138898;
	bh=rs2uqTkIc7aAMCm9u6DZxVd5AsfHqGkk6OElJunpKgE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LKnQHg2EuuoiFeAFnxbyqE2fDmZVEFfJR4ym+5yVJgFpQm71jto6sLdg5WZBmxtnG
	 feASvKZV1Hz5s2U3CIOgVNjCbMO2KjX0U8n0MqD5oIETyTM4cq2dp1kF8q1re74vLb
	 j2vE2OH/h90vuhLO9gHN2qcX8iyk6Gj1VD31+RAQ6EyTWZ4iOjRfdPPOVrvYcxkaZB
	 XBfLDuqUgKG5MGYNKIrR4nHOZTbtTfEwI8Yhu+ZJ5BbOAt8fRt2kA+h5FZmAtjQcpZ
	 rnFDFHuQ6kgr2W3lu3RNNXviIak6dJ8MP1UOPZWyzYJ4m9mWzT3WG+SsY25Gg+DtTb
	 3+Mm4p2TcK06g==
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-95cc1a5fe9cso556344241.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 14:14:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8+pl3kEj2ckvDThix7m6/FpaZaKiko3yGyPLgtpm0jiC/eSJj2X46aqREvhiqPbF0p3yUGyf2HIA==@kvack.org
X-Gm-Message-State: AOJu0YzxMrycLDVoxe3sjfDNeKC1flTQMHhWAejsrv/gEiOzwiG+W/U0
	DGFBPJIiQwHNMbpoOAEBPl8mRlC/0PAvxKUd6k4lfHozY+19vVJMJKdg1p/le/0dO2R0Vn6MteQ
	9eNsKWoXsQf6kvZFif9gVwmyTsvtP/QQ=
X-Received: by 2002:a67:e70a:0:b0:611:e0c2:1604 with SMTP id
 ada2fe7eead31-63a3ee862bemr7850443137.19.1779138897435; Mon, 18 May 2026
 14:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
In-Reply-To: <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 19 May 2026 05:14:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
X-Gm-Features: AVHnY4KjG65G1ecWJLmAXfyGgeXMxqs_Hs937nQXWNlaevhV7YwGMAI3sK3pWtE
Message-ID: <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F8FD2000A
X-Rspamd-Server: rspam04
X-Stat-Signature: basmq9gqhdd5dks93xiryfgs4cfkrbgr
X-HE-Tag: 1779138899-221808
X-HE-Meta: U2FsdGVkX19j3XxD/UXOZxnRT72yiG3wsLgCwQUf9GudH3fTlT//66P3LlTJkZOlGyNHBZFe84Sx8UlPYjahNn8b4KjsPW6pvC2wxskuDDjbr610kr8JsH+sZaph67VR80HglHpEOIQLI7qa3hwNUVGgSLq96dabXOmcNLjl1r1UBX46TsvzIT7KFwcXGpjX7LJSLFSjIAjQ6nRQZqP96GCLdhbzIpQGCDwHRydYR3AV1aCwtWBySEB6+9kRKrCVARD5ir4NUzofpCk224rXX6AjiFy0YQEdYDtLzrIyTFBncEyNaA1gT/wQJQPlUm3yhGH9NdCzojnWAguLgKaYS76P9c7RsKqEKj/Frh+iDpAPY1/4R0T8N2XiaTzhD1go+RRpE1Y+85PZ4m9tMLlodemSC5V3mAyvzpw1plgIJF2baGMkv8fT+K5f76RaayBsn2///1jnmwf9E9+6v84MqTjdf+wBtGy0xCwXO6GTODoozkIudpml8iz8jchlpHSzhjZyr0SaRyNuranRGwU9Qwe1yogdwLNhVgcFDOVEw9qqY085EY+dfhqoe5FtkOzTDJHSggQHynSbtnXjLs4qLZHBjDnUr0qo20KK7ACGjwzyGL0hdoYnAEwF/YdBLT3QpQb+Anm2KXVbFIBOG0QSZKL5arhAtMu1Oa4musXcjA4LSuEMhVIMSzlrrEUN2GQVvxD1WLfVBF4f8C+XVPkpOYt8N8V8mfXYOm9lj6YD0AmvvI9syAp1bvaB8/p4dcaOS0kbM9l1MSTq0vDhXTWEdnS+Qht6RUkpttFmPYXHWWoE3F2xlDC0y90jQqX+GZvudGiZEDDHzuIrYtifW1Hb/iLCpSijrIp6NBChG5jmJ1NxguT0HYsecbU0IA9oEPwo7gq4BbKPaRhNabR4M1P3d1FgefwAI/BpTSZq8FA4KZK3UAM8ppNZ4d9YoluxUWHUDpyntWKEPYGW08VXj+J
 ewLzXOTk
 AEPd+zIv+VESVUs/0pZgCehdUOOLArDPImvqmPDIL2zBwvVy1uZAk5BgYrg3zlnyGpHSCAmtwv2UqEY1arGwaDmwWIT5dxfQ6JF0wjIaPhS/xVvasIKUKhVCFOA3huWwEFBHH3yaif6+SC1VRN/dXwJaetwN2mXZ+gXmwdWha3UOBT6KxnQBkM+9wYh0cYu716r/yzfZ2hOjRSLkFpbCI6kjuu7HWHyJZqqrqfCR+LktTlLnk21BMgQJ7zhO4Xdi8WRZqClfsoWU2aeXJtqfjDrqlg0kGYNC3v0l12b7BAz0mgcETW1otKz/ax5F/qBqlPMqpJEJYI/FIrG9Qs+wJH1yUdDBZOdgGaOJvYdPeXBAVba0gy/lc4Sv7XkHrLg10VCdyamUQ0yVVe24LmZwCMVfSxTzdXJ4zUqCH/DG4iu/jXitMKizJ22NWqdxes5a/RtiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 3:57=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, May 18, 2026 at 4:26=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Mon, May 18, 2026 at 5:47=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> > >
> > > On Sun, May 17, 2026 at 04:45:15PM +0800, Barry Song wrote:
[...]
> >
> > I think we either need to fix `fork()`, or keep the current
> > behavior of dropping the VMA lock before performing I/O.
>
> I see. So, this problem arises from the fact that we are changing the
> pagefaults requiring I/O operation to hold VMA lock...
> And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> anonymous and COW VMAs only while holding mmap_write_lock, preventing
> any VMA modification. On the surface, that looks ok to me but I might
> be missing some corner cases. If nobody sees any obvious issues, I
> think it's worth a try.
>

Thanks. Besides the creation of processes via fork(), I
am also beginning to worry about the death of processes.

One thing that came to my mind this morning
is that when lowmemorykiller decides to kill an app, we
want the memory to be released as quickly as possible so
the new app or user scenario can get memory sooner.

In that case, if the app being killed is performing I/O
while holding the VMA lock, the unmapping procedure
could end up being blocked as well.

If we release the VMA lock as we currently do, we allow
process exit to proceed.

I haven't thought it through very clearly yet, and I
may be wrong. I'd like to do more investigation. I hope
the apps being killed stay very still, but who knows=E2=80=94we
have so many applications in the market.

Meanwhile, if you have any comments regarding the death
of processes, they would be very welcome.

Best Regards
Barry

