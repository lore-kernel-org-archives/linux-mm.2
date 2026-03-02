Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1413BD58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EDD6B0005; Mon,  2 Mar 2026 03:25:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3D06B0089; Mon,  2 Mar 2026 03:25:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0DF6B008A; Mon,  2 Mar 2026 03:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 27B546B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:25:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 935281409F6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:25:43 +0000 (UTC)
X-FDA: 84500439366.28.693AF5E
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9CBC8A000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:25:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gxh+RaFO;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772439941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wM0a0OVyT0VOBhtjoaX80vPbQTd2mo6DMpjpCMupesw=;
	b=IgqFW63qQ+DjGXf/PuoGcz21LDDYBu1l0abbSGuRWj3EIU9CyC4civtE55XzNGdTYNrxly
	nc9+CVkfcGPINJVPXsDJ5Zsp7HLFgxGPgy3Zzm+95/HWoxdS16JGqydHWUOtipGMf8vSX+
	8k2WvXHMJqEHvKwAkNuZv+vtudZAuHA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772439941; a=rsa-sha256;
	cv=pass;
	b=J1nshlPdSf6f4EyZcj7XVrjPjp1YbOmQLeQ22kjZKgam+AXYJ5I7+x252ugMFtg8O8D2Te
	BfcT/nB6U/MiXVORg4rthdQPQgxale9PbgRYgZUK7Wyayk9h3grt5rAB9OAp38LVedArd2
	jSw1lkiWLCF7aIFCODGIP5M4fdKXOuA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gxh+RaFO;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64ca09f2170so4123413d50.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:25:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772439940; cv=none;
        d=google.com; s=arc-20240605;
        b=l0zQPkP3X4ZLkcPYwkMn88IjsTHa0UUoLV+aj/W4vSAlVb6cnr66yEPY4wDIYg+RfT
         NnJSqDgQL8Gi8ASZXm1JXzYlnZZNRhK1mQUYUwxe0rsImhkiiByTS/w4aOMBYcy0ZPOb
         0EXrfHytVWOWXDXpDn0t6cmaXyQAOeOR4v46s4k0Lf7iIRuRHWOFUVxKpsaxA9wt1Ft9
         hHIr6egmKVi1REWRiMIu09+v2wncWRlwrV7ArUlyB72bZVtcQZNCsBe3kRUhD0jJRLc2
         OQlCDHIcFCzcYiAfK/kez+I1WaoaqEMkfaqpmxrWEKJPibFNku+WufjpKhrIN9NFKpK0
         zFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wM0a0OVyT0VOBhtjoaX80vPbQTd2mo6DMpjpCMupesw=;
        fh=WQbCCySiBsmHoqNam/yL+M+IVvAmZtLQ7XPOsAorfi8=;
        b=K09MfRAvBitTx3dItOY5cYsNTC0aqADF/us3zl59wmX2UtPXnszvzJrQiv6MmEy0ZN
         DKzhlVzg48DR8N/9hWgXKtn0+A7M4EhuaDRviunl/RFe8o1iMKOav76z5UhkZTOdwMG7
         xDXngt+dcHufXDkgh/Pd2Y8MB6Zpl0e+pgmzedskJH57WFXAsIB6WCqjqeEW/438xy/M
         04kPdh/a5VBse4R0UfzyUYxAWzfL2/LZHJbAzFrqUvwTnrVZx66gA6bETFbbaNZB9ie/
         wElPrdMIxKqNslXbe3D2QQMhBhITeOVAL+fKKSPbeRbmiQ0C2KvXPn0KQkzgr5sI4WBo
         ag8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772439940; x=1773044740; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wM0a0OVyT0VOBhtjoaX80vPbQTd2mo6DMpjpCMupesw=;
        b=gxh+RaFOUEoQtqgptlnl+F2XLt4FFdmU8qjNjNm7qd/Qn71bz/B1O+KxC03ldWH/HA
         +GuUnfxv30oGO4nENbaRux866C+eKWUWrTTpYfjI33e2vDdvK5h4N0Ufm0TF33FNpW2O
         TfhtYmFkDvnGp0Z8CZaO0EtaSOYqkH9fs7It7FyVcHyCJIpPULvYRBE0yNTrnsNE/HUW
         At8hQWI9FtCdeT0KERUz/M9t7U6yoGKbc0uRgX2hH8Qf+fUEtukGKUTuZZdmj/Hhmfej
         NXyUaJem1wbmrCRK/CeDPzWFxt9sGoKzljuZ96+RFIitHPPy+34kjbQBOS9Lo6dsUlRx
         1Hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772439940; x=1773044740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wM0a0OVyT0VOBhtjoaX80vPbQTd2mo6DMpjpCMupesw=;
        b=erE7jFUb+qFciVkl5urx7Bz1/qOxASyaVWHzna9d5LuA0oYQ8r//XyekmlDjQ0MaE1
         R64uD6J8qGAMFk3EHU7zfuZvyNvXjOvbB4eS+GJZ8fMW+eqEvX3N5gSD14QQzJvFGciu
         /z6L0mVY8fWdPKZ2zxqqfCZFF1Qj4weP6cQKotgNd5IWm+i2OZQLxjkTm2A3v9btAjIj
         fAKS5v72ze30GON28zvEjjt+xTr+AkuqucJfHOQGMKtJBtkhyuPYhAOz1cdZ/8n4tgic
         w3jmVMkCZC9s/r3RzVVq3234i3jPKx/LLT4JsHSapdxUtD73ieIr0xTXKbxl/lMYLHD7
         aVKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJZ06T6MiOzRiDHrU4JimC8T1qwn6nA8iClLsaQIE3FXJ+FFShkjnlDltZHbuDxNvF9T4SYr39VA==@kvack.org
X-Gm-Message-State: AOJu0Ywhl/dJWV3uWs+sN6i5x2RHAkCS5O7PtKTu9Vo6XBMUHrfQh2t1
	++ZcznQB7eQwNLcfLCxVBwRTcEd/5F3nvl5eFWlpBmUZ/kS5w1RiFhB5p50iVROMzcS65dp5b5U
	/5GY0i5raRs92NbS7iFCU+EbSzbHxgMA=
X-Gm-Gg: ATEYQzw6fdsVUA5LHjD2KdAhL1exnKpQXwyFg2jJJWtLWYZ4iT9WcCd0I7RtHMs8u69
	gdbxfZhyXp+4LOxSh7HeizG3b4bTWlqY0mxzWeFPMSn8WggPV11jf0+yh2rkArc9tVzG2Szf0vw
	NZeKvRtjgYFQ6mbHTQZZfgo1FYTwaXJ5DwocfTphkUDHSzbY64saHWBMM1MUDwL4B+kAorQUJ0I
	NOpeXBtydkSUxTsikEJXNRuOumOn2Uv0/xve3l6ceIcVjpFe0fwphw6JIZVuHJ/460uYxwAmnmd
	7giGWKtA
X-Received: by 2002:a53:c5cf:0:b0:646:7a21:f03c with SMTP id
 956f58d0204a3-64cc237d537mr8679938d50.81.1772439940600; Mon, 02 Mar 2026
 00:25:40 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com> <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
In-Reply-To: <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 2 Mar 2026 16:25:04 +0800
X-Gm-Features: AaiRm52e8HPvuN0A35KKNaCT-cQ6u8fBXQqCaZcZmgz-NTzyv1pGZ1VPU0p67Fw
Message-ID: <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Kairui Song <ryncsn@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, lenohou@gmail.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	weixugc@google.com, wjl.linux@gmail.com, yuanchu@google.com, 
	yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CBC8A000A
X-Stat-Signature: ro3gd6d3f4hugpdfhj8i51araxmzso9a
X-Rspam-User: 
X-HE-Tag: 1772439941-234336
X-HE-Meta: U2FsdGVkX18Uf5SerHkka89HW83I4ecyoW182AHjllSGura2KzXAPAyGIb5eeFthOsWHgnKZ3uTDfU1RTmA/0VEJt1WI5GI7MAzp9KORS4FKhw4qO7A0mGjRtst9BuEPoLkvrLUEYnWoSQwyb1o1QXZefSrLVqX++SVuP5UwGpJAX8vo2bh7yLNZV+a9Nc2be+hWJ0d1RnUUKuWSkX9Wnfq/eysdP/c3YF6q/OL5IL5aWyJYvBwK+AqvQ16nC/tINTy66q3DTqWsTTc8b6ugKI6TTJ8aTgv53idHEqxq0emttSrKARR1Fj4qrlSxo8z897QGgmZX3eUl8wOJdqepw8EZWa6HUOUwu0AxVvNREkjgkcxPpZae6rIGvrlxQm+AvPAwVp8KyxJJiPB29bWyfbK9Rf8JbmgbTx6VMPIiQwKcbcX7BuAh80WhNMZydNHyMGxFMNl0dxkmLeWrTz8WT3GjjHXVG9rEP5SMriJjJ+zg61TQJGLAdK7slUFeQmSG2El9MLak7HjZmQ219ZeEBJ0R1a016TXs/ns8Fh5dk00bEsT5WOb1RA7RcI9gvjabzeQCC8A6Kr90VNDBnw51lnBRzb5JUZsaz5DuZ/JuhHG7VKwfz/VPIMpzUoe7ZaqHcdAQD7qYPAUdBgqYU4QDwcqgvWJ7suLXqaxhn4NHiDbFgwGRp+d7NHpvuW5QvStvfdP32IF6AXPbXzwVhmWwROnz059MCkSjfy9fn7eWBznEE4e6MFTsxOuxtnI3pLrzxc6e3NztSwiWklg8H+kHwBtsAbANyKLoXzIg+A2+dkAcWRlhUQKDLB5nujwCLkbfXIAHfN89BOLpu4VllsTqg115nI0WsvMslN7ZVzoiUHqz1K//15XdYD+g2sdLMRXHF19A6MM/Bk3xFjCkHGt2l+73qUv21f0zOwPNhKEI7jLFx8hhzY2m8JbU7Gk3q9HUvtT+zbGrI+urm+bCCGj
 FWUgEP9e
 uQqzJaw7wdLPgiHvqHiXgedGNAA5SY6t4oGcw7e6S2YZIGxcM5s0HZXbD4AH/VFlQHvpHceu06hg4Yaq5JAjdElAn8hIw6NOgceyji5Crbj0Ipzuf35pCudv70kk8b43vPjKyyuW57pR7yIPrno+VDp2svXe+vmNM57BFbkirc5Bpdq/iynE42nhoujsnYN38652XsCpgIaA3pMpDrT1xY1cKzeGHGHgKwr5yuXW3UlnI4YCrAlQDwM/nkk5aYEcV/RHBI8wG+nLKp385QCuSSmgmrD9JCUmzFIylsDw6AtcdhPXkjdZDqF5tM+ZNjrhdtRfcmjcdtXngSG+lb8xbFm1L4CeRroH/Tv4QleiadYLjHYW0MNnAmwQA7h4J5Uj0pqfsJC+qKPUVt4IlHgDK76gUYSfIhqvm6Sq/z0SJuxm7uGzvc8wyJx8Thh71nf0NkAJId/HRYlnA1xppEJGtDXKX+y/67eS1jEZcGGUKiBz0KNFKKFsOxVf4Oe0fObWBxZ66b2TmHEOd36Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 4:00=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Mon, Mar 2, 2026 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > I assume latency is not a concern for a very rare
> > > MGLRU on/off case. Do you require the switch to happen
> > > with zero latency?
> > > My main concern is the correctness of the code.
> > >
> > > Now the proposed patch is:
> > >
> > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enab=
led);
> > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draini=
ng);
> > >
> > > Then choose MGLRU or active/inactive LRU based on
> > > those values.
> > >
> > > However, nothing prevents those values from changing
> > > after they are read. Even within the shrink path,
> > > they can still change.
>
> Hi all,
>
> > If these values are changed during reclaim, the currently running
> > reclaimer will continue to operate with the old settings, while any
> > new reclaimer processes will adopt the new values. This approach
> > should prevent any immediate issues, but the primary risk of this
> > lockless method is the potential for a user to rapidly toggle the
> > MGLRU feature, particularly during an intermediate state.
> >
> > >
> > > So I think we need an rwsem or something similar here =E2=80=94
> > > a read lock for shrink and a write lock for on/off. The
> > > write lock should happen very rarely.
> >
> > We can introduce a lock-based mechanism in v2.
>
> I hope we don't need a lock here. Currently there is only a static
> key, this patch is already adding more branches, a lock will make
> things more complex and the shrinking path is quite performance
> sensitive.
>
> > >
> > > To be honest, the on/off toggle is quite odd. If possible,
> > > I=E2=80=99d prefer not to switch MGLRU or active/inactive
> > > dynamically. Once it=E2=80=99s set up during system boot, it
> > > should remain unchanged.
> >
> > While it is well-suited for Android environments, it is not viable for
> > Kubernetes production servers, where rebooting is highly disruptive.
> > This limitation is precisely why we need to introduce dynamic toggles.
>
> I agree with Barry, the switch isn't supposed to be a knob to be
> turned on/off frequently. And I think in the long term we should just
> identify the workloads where MGLRU doesn't work well, and fix MGLRU.

The challenge we're currently facing is that we don't yet know which
workloads would benefit from it ;)
We do want to enable mglru on our production servers, but first we
need to address the risk of OOM during the switch=E2=80=94that's exactly wh=
y
we're proposing this patch.


> Having two LRUs in the kernel is already very odd.

It's difficult to completely move away from either one.
Looking forward to your work.

--
Regards
Yafang

