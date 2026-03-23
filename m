Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B87D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 22:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFC46B0088; Mon, 23 Mar 2026 18:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB04A6B0089; Mon, 23 Mar 2026 18:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F656B008A; Mon, 23 Mar 2026 18:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4CBE6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:24:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3394D8D199
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:24:10 +0000 (UTC)
X-FDA: 84578757060.26.9DB2131
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C34D4000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:24:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OTjQ4wWm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774304648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMH01xhswRxeY7akcHE4uW++/WwOEsKp15HODGw/Qzc=;
	b=K3bKKBrEiVcmLXa2e0vBm4axZ4Bcfn7iadCJASyevOOVrLUNiTXRSp+4wGQVO6t2Mkpa7Q
	dcDTUspAEkM0j9vnxZNBnApwW3p+m2LSmTo1ig3886UCSHNJmeYhGhizzFdGtmmnqBjySA
	tKq8wkF8TqtjL4JlIvpkSKcuLEUeFhw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774304648; a=rsa-sha256;
	cv=pass;
	b=oWvzt6jB+4qTtpo+NZuOgdbuN1eYS7g9FMdeXXy0R5gHgpZebP+DtWX2DeXyYYyzhKAsvW
	V0cHGVgWP78qLueGcxSYja8FLEdESO//v25VmoymHPMS7xvySgpZjlPAi212oBV4EdwdIw
	5gIpBbQk08LfrdmMjy++iERfcmMHokM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OTjQ4wWm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so912574a12.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774304646; cv=none;
        d=google.com; s=arc-20240605;
        b=U9aCAIaukjznoQaNrNJ+QysqKwq5nKmxXShDjK0sJJ7Z13ITl7n54qUJQbL9Xq1yh8
         ioBNZTr0DUJNbUY/2wBG9Q6KONw51igVCO4GoaIM9BIMtMLOax4xBtqtrL2kqwHJSsbA
         Zn7XJFF976UEVXY93c35LaiiMmY72zmQufb5G+3vPtHqhK1ruqFJUTE2yOgyZvJkx8au
         au/WQ0gCM8rnY+wZnpWGpIHE7X6LQpLJ5PNEACTr3o9CEY5315/pcd56+d+iPKumZWzo
         4GftHXmAN9Zx8SH6wLrky2HCXu+I6n4bA5yS74MjAuQJDU12m/bv/9xsKOOAfKKfZzQW
         es/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rMH01xhswRxeY7akcHE4uW++/WwOEsKp15HODGw/Qzc=;
        fh=oMpc+tBR4PzNSKOY8G8khUWNiFyu3YAHzQ2BVGs7WfQ=;
        b=EIFdA/DkZFCgOn/fOA/1rvFUDy+yrQYMc3DX874Mz0URnzu72HYCG76Ryk5v/C0q11
         FW2sTVlLpOi1Ctx6sFmi4RoeqLHj0dJTzXo4uMF+CtdxinS9uFI23wkiybWwkR1fbBv/
         EcLBYvXh87j4x6phOIQ1OHl0gOUEHQI1jloiJ9UXtym0+x7gVq9J4mrcJ4FeB+SkhRtg
         PQpj7ZxmNAe6kvcs9PdwC/KlX2NzhFXuZxC9d7uo/J7sGpZ0Hr+xxO4ZA/68Ndd2ACz8
         SMCNSK0phiTpjuIZenlY64mPI7UdPlA+f66bKruwkX9YCU3C0u5ecOwlF78AGnWSLLOG
         FI5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774304646; x=1774909446; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMH01xhswRxeY7akcHE4uW++/WwOEsKp15HODGw/Qzc=;
        b=OTjQ4wWm35X0chnh2rooXXDmxZAYKMDWJD3o8sd47tKHvhYaBy0oWAKl/iq/a0VfLl
         2/iA4eTDKlbXF11AsQS37oqzjTV4C61QIBd6TkNAdHd+Icm49cfRGdEw/CeRZFtFza9k
         7HsHMvjkW39JPMjjY2FX1Jwl+GMws5hhRyT2AZpu1Cr/6g+Bp8A3z5UfN21NaRW6/hv+
         Fch+G+Ap53Ff/CJ9EznKHKIA29ysHl4ijnwmhGcmY/X18SrAFQ4sS3w0bO91D4r0RNEs
         Ffm+FlfyDTKHFqJ/BPIcXS0WSAyg6pc6dnd8eSUhf/os+AQg69u/xknRDJRmFqgRsbiY
         5zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774304646; x=1774909446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rMH01xhswRxeY7akcHE4uW++/WwOEsKp15HODGw/Qzc=;
        b=pxOnwysAuWqhwMUUizjg/Wi4yzvw+cYYGHC1Zn7ZFEvCoM3eGtkLZCJtObzK5qKF+P
         /8US7ldCwi9WL1N5SSHTDehY3f3uLymyrXHouCt1mOIUcWSuXnWtfU3GZSEQ/9dRvXZ1
         bRaSe9/jN08JsQ7PYmbCdUIzD7Mns2vWWgmZf2z7TwNnTxUWoaP8hpF5EqFP21uSDfrw
         JT3riOSi72uP81cRuVgSryNZfWBXl2Yt5qo4HbRX7buzcIutCwc76ny5MP0n5sqmKklu
         nuos5WY0IIOc+wB6ws2z53qUIE550pWnDWyjobXs1oO9QHAysWcafcjy5T+xWsD6tIMI
         SSYQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+Yq+71De75ziqz/Uj5U9ZowJ3R7FjK2ww/tfWyDqZerF6bbHdAMBFDAUmj1vKMpBK/Pj4erHPzA==@kvack.org
X-Gm-Message-State: AOJu0YxaGJd5971RHarWMG7AXmUNyQc8fxhnGTmC77Ca4D9kIs1HvQTy
	bDZoscGTXuPYDFBhSn2oxRQ7vi+Tdk6+jsNOp3ExdqY92qHY+gCdP+UA8NJAY4dZiJla6N1Qtr3
	7AkOZhZM4+YtTk8qpt2nPvIXjN54aWyqH+p0lgnJM5A==
X-Gm-Gg: ATEYQzyZfz/luEJwQlfJ3RzMdO2xpk/3Hb8hMJetvfv/R4HedDDQ3HqP5XBRNHuis6I
	koxLa+VWTra+xIShBzKGRNhEJxr236iKwkICoJKTZ6/k1xNMVW7ZHkaOZt6eAjpnpBYOJ5UUyvD
	T0XHdL4Q9bcCqOSc6cuQi1U0Qfx7wlmpBn9mXvOrBtiHVNFisVOmIvKxGkbgCNdOhOaDi9+mwVr
	//ywH8ouFGx5FvzpdSCbk4ov7tBqN55tei4d08hUDHFPLqhL9ePWvJhmsV/rjAwbiz+6MqlxaVy
	YIlqUiGIDJlUpScPudQdxf+YQ7XIXpvA4TnwYA==
X-Received: by 2002:a05:6402:5d0:b0:65b:f342:d1a2 with SMTP id
 4fb4d7f45d1cf-668c8f08c14mr10693463a12.6.1774304646108; Mon, 23 Mar 2026
 15:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260321143642.166313-1-oskar@gerlicz.space> <CA+CK2bAfPSKfV=_Sw20oqF56+H3a4k3x+47i6-EUK8mLV-i2+A@mail.gmail.com>
 <CA+CK2bC8o2p_poLb0yfp6mAAwR42Vg_99Yh_HLK1iJZrCrsVig@mail.gmail.com> <f76e6cbcf6752342ee940ed0dfeca7bd@gerlicz.space>
In-Reply-To: <f76e6cbcf6752342ee940ed0dfeca7bd@gerlicz.space>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 23 Mar 2026 18:23:29 -0400
X-Gm-Features: AQROBzBYmbrN8P_EZJ8f9HXtmmp65c7B8Ck9f-JHx34u3fy-gh4kUtkFo_LM52g
Message-ID: <CA+CK2bDN3bk5Y-LP9OD+6vPrr50Eyy4ALJvhK36ZFGEgj7yjLQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] liveupdate: block outgoing session updates during reboot
To: oskar@gerlicz.space
Cc: Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0C34D4000A
X-Stat-Signature: tdgs8rws9nnddhzu4uzbzum7x8gjkdpa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774304647-597398
X-HE-Meta: U2FsdGVkX18GXCjUiSCLf6mskuPrdrMW52csVvfMO59OiaYIxApbZXrHskTugYQXRqsYsauTfW5z88Y/RhhabwkDnQCSalEpM5CSw4/ASbNQZZs+Zxp/7cvG5LHCIElAhasZnfVEHkcFity7bT0k1ZmFWsEN4t7ssbMsmTY/awC2tCP40y8AgrsfoCTRqkEGgZyXdED/zTEV8FDU8QoF6C4NSaorGulJCbMpmgWMrDmmjucQnxB3UJXJ6N1lG9d+lSWQyRpkg0cRXRKqQ7DeWyfDgbjOq1CX/ZioI7euiisVu1nxThODB3Ph6Cl76sNPXDZ3uKATY7H1lk/1jfKvW9q+S2ej0gLYJYSgGfZ0GiGfc3UwA7GEX/Wz4C2IOqq/mIhn2f5vkxkeToZHviCUlVCwS8NfEmqfCOvG2frKxX/V4Tcd3BBoxgda+mne01Ibvyf0XAIgzI1ZvxAP8KMRhoPqH4PYDlwwVhPJbnniY6nLKVI/MJOTosVaJb206rvc7uQ9BNbIFYHDPl6tMhohBisonI79zfb51iQO5ju42kOlYo7O1heoHZPvoO4dc/YJ5UJaRCgwbz9wFEOoPdC3n8TH4iTjl/3Rt1zFrupe5CCPeo1m73BacBVV/COPG6YwhDpo64RGxJdldiKyc2+qHORMjEE4HqVdXHu9aDTmnPM3LiMRArmmMvyW/BwkFZuT6hOoLM46y3EVdvj1bPt98dTXrpC0EbEYBYd2FIaI8l/vhtuMjVDYBaegeX5YI8HmKVwXnEY/sk1XbJSYR/k0Bug6ZwqlcgWd+nfbdCeomQuAcB8qmnGpztULxzY+13uryF/h/isYVPh//nwmn454Xg4VMr2+UX4+SjWxoNAHcX70SZ6XSsMmajUeXggFMq6IvNPhVgud7VVZtnvkmykCJQ/5bEIv5CJJgQ7eMad2rEIVxHEBJeFTeSG94MLMNLM8+2iYJFum+O65WdoH65g
 pNccfkBw
 C6flLg/bMXz6fvueov09fhppYyYhptNgZF9MORjEOz2QCsGE5fYVyT5b/LtHf0cySPEOuYMLxdkFC69kSCNMhjpiAPRv9gn3NKIFuMzbSBE6vi5r3l+iZCt4V3ESryLd3yNZ8/CQ1hH00+681G7u5UFLrKyDhlLfj/fdxVzT53otRtWPlFlVfJYsB4zJoq/7ibJyecfq15pPGR497AIbrIPuPW02lL/FMbn/nAnq8zeHJmI4CmQJ4EYaf/dvsDFA6TkQEV7AFNEa62TwObImrNj6qn4ccPXgeG036tFD/bXqdrMytOoxPBFGe+Htn2sx6rtLd2C3bjKQ6a5N6OnDXNlZQ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 4:54=E2=80=AFPM <oskar@gerlicz.space> wrote:
>
> On 2026-03-23 20:00, Pasha Tatashin wrote:
> > On Sat, Mar 21, 2026 at 6:28=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> >>
> >> On Sat, Mar 21, 2026 at 10:38=E2=80=AFAM Oskar Gerlicz Kowalczuk
> >> <oskar@gerlicz.space> wrote:
> >> >
> >> > kernel_kexec() serializes outgoing sessions before the reboot path
> >> > freezes tasks, so close() and session ioctls can still mutate a
> >> > session while handover state is being prepared. The original v2 code
> >> > also let incoming lookups keep a bare session pointer after dropping
> >> > the list lock.
> >> >
> >> > That leaves two correctness problems in the reboot path: outgoing st=
ate
> >> > can change after serialization starts, and incoming sessions can be
> >> > freed while another thread still holds a pointer to them.
> >> >
> >> > Add refcounted session lifetime management, track in-flight outgoing
> >> > close() paths with an atomic closing counter, and make serialization
> >> > wait for closing to drain before setting rebooting. Reject phase-inv=
alid
> >> > ioctls, keep incoming release on a common cleanup path, and make the
> >> > release wait freezable without spinning.
> >> >
> >> > Fixes: fc5acd5c89fe ("liveupdate: block outgoing session updates dur=
ing reboot")
> >> > Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
> >> > ---
> >> >  kernel/liveupdate/luo_internal.h |  12 +-
> >> >  kernel/liveupdate/luo_session.c  | 236 +++++++++++++++++++++++++++-=
---
> >> >  2 files changed, 221 insertions(+), 27 deletions(-)
> >>
> >> Hi Oskar,
> >>
> >> Thank you for sending this series and finding these bugs in LUO. I
> >> agree with Andrew that a cover letter would help to understand the
> >> summary of the overall effort.
> >>
> >> I have not reviewed the other patches yet, but for this patch, my
> >> understanding is that it solves two specific races during reboot()
> >> syscalls: session closure after serialization, and the addition of new
> >> sessions or preserving new files after serialization.
> >>
> >> Given that KHO is now stateless, and liveupdate_reboot() is
> >> specifically placed at the last point where we can still return an
> >> error to userspace, we should simply return an error if a userspace is
> >> doing something unexpected.
> >>
> >> Instead of creating a new state machine, let's just reuse the file
> >> references and simply take them for each session at the beginning of
> >> serialization. This ensures that no session closes will happen later.
> >> For file preservation and session addition, we can block them by
> >> simply adding a new boolean.
> >>
> >> Please take a look at the two patches below and see if this approach
> >> would work. It is a much smaller change compared to the proposed state
> >> machine in this patch.
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/log=
/?h=3Dluo-reboot-sync/rfc/1
> >
> > Oskar, I made a few more changes to avoid returning an error if
> > get_file_active() fails. This prevents a race condition where the user
> > might call close(session_fd) right before calling reboot(). I
> > force-updated the above branch. Please let me know if you want to take
> > these changes and use them to in the next version.
> >
> > Pasha
>
> Hi Pasha,
>
> thank you for taking the time to prototype this approach and for the
> detailed explanation, I really appreciate it.
>
> I agree that reusing file references and introducing a simple blocking
> mechanism makes the solution much smaller and easier to reason about
> compared to a dedicated state machine. Your patches definitely move
> things in a nice direction in terms of simplicity.
>
> While going through it, I was wondering if there might still be a couple
> of corner cases worth discussing. In particular, do you think a boolean
> gate is sufficient to cover in-flight operations that may have already
> passed the check before serialization starts? It seems like those paths
> could still potentially mutate session state during serialization.

I think it is robust, it works in conjucition with session mutex. If
an operation already passed the check, it already holds the session
mutex, and since serialization also takes this mutex, it will see
consistent data after pinning sessions via
luo_session_get_all_outgoing().

>
> I was also thinking about the lifetime of incoming sessions (especially
> lookups holding pointers). Do you think file reference handling alone is
> enough there, or would we still need some explicit lifetime protection?

I'm not sure about that; I have not looked into those patches in your
series yet.

>
> I=E2=80=99m currently working on v4 and will take a closer look at your b=
ranch
> to see if we can combine both approaches in a way that keeps the
> solution simple while still covering these cases.

Thanks!

Pasha

