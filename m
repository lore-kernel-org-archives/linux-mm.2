Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9146CDB466
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 03:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF2D6B0005; Sat, 20 Jun 2026 23:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0836B008A; Sat, 20 Jun 2026 23:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767566B008C; Sat, 20 Jun 2026 23:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 476C06B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 23:00:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B4E58D178
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 03:00:19 +0000 (UTC)
X-FDA: 84902416158.12.A8A49D6
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F4428000B
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 03:00:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HfBmH3EE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782010817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVrIryE2VF1sDSS46HMWn0Px6aDg+06V1VeyZcyjwRw=;
	b=AL2xJh/nowG/+NXJkDdMRuTBInXXnIqYd450gZ6lBovAse/sNYn0nduPpFXb0fpkYzDl4H
	8H0xbyZjx8EFUwaYxM7BE6w7RyQmIIzgdRfF7GeHtGlTbOCPHsrfXfAhNyKfgQb4HuvGbS
	Jm87HWjYgl1lbLdl4XF0LEVnSWid28M=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HfBmH3EE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782010817;
	b=4Rowp6Lw/qV71K6VbB+ZiAaKJvdEeF5sJymH/pnyNLAxXaplSwj7J7m99cJf4W/DPKmjhV
	nuq+GV7F+6fVaJkEp2hwXNsqnN8X5OijZHGJM1kTviHwtqcsVsl7yw6qeKTHkgsovM6dIp
	1xQtjT6jiy05H+N+YVcm59AFCIyiZbU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c6a4eccab1so77635ad.1
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 20:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782010816; cv=none;
        d=google.com; s=arc-20260327;
        b=JR0jmlgni7jNNKjdnPpyLUUHw6oFJ2yH9uLQjJ1LhOAzeLVV2sTczwMLSLztfUlMIN
         WwHC0quwgHqWHFdJrUhM4N5fljd5LHeSMzrYTQjbVMkI3f3g9LWFspkzyqECvUn4e3sW
         Tl0OjJ7WXTPyVAq8aWCa+CCPc8+UEvhylA0qa70u9weanAv0JDXZZ9Zz5qjsaECoouoj
         3vXiBJv5GigsScG9E4I59MR0KL0g1qP3u+i8BrGkuSMdYOmsuPfC5C1qcbqtGGVRVtfs
         xdzlgOhbX5L39MvU1STY4yFVT+/RlxM7tGDOzoZ5ELtcwGH6RbF7tfuK7oeuHYjYz4x8
         A2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LVrIryE2VF1sDSS46HMWn0Px6aDg+06V1VeyZcyjwRw=;
        fh=SbOltGtRSaHmfzSAa0al4UQx4d2YrLsW+5jBZuNnXHw=;
        b=UAq/Eeamtn6aiRlMNBa5yOsn+vKmmiJRYxDNbRZLJwNQklq2rOKnbFV70lZ2qQRSzg
         eSbPNGZvjZBRRP74jgHt8A42uQllTGOBjp5tAxIpMhOWGeOD6hjFdlqmNGDAqiuL6am7
         Rfs9HRU0Nw+Ht3TcGre+rZslUR3Icr0d8R79w+JrWWU1JayiW8v/FfHXKMQxi9FSZjSg
         UrwF0mbjvgYPWj1FaT2q4gljNrCjnyPOS7LU9BwEiKwQJNLiRrSeNKZsOujalLmB9ipz
         F5L4pelEJ+wXG2Uo1uyj7YUCbBQWVHplOs23+CnK5eHqrArIcJwv9oV/eoxb8iSiYaSA
         SkWg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782010816; x=1782615616; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LVrIryE2VF1sDSS46HMWn0Px6aDg+06V1VeyZcyjwRw=;
        b=HfBmH3EEY2jBDpPoJPg9ooDlMW9JLNhj+gUbME6zYo36LXjlSvtf91zXOeTKTpTWES
         A9vqXsZDtJhxtsQnrQwbxNreVoyzP5jlLWvxuOhFD+qlTExsHXnsSNyYHtb18PfyXMv6
         UY94xVUFvY5Q1QGvUDstWLT1HzrxCocFtFFU13Q1NMD54wuQTMFfY5J1Rrl0icfspSmb
         PpGkqG+Q+P9mL3U68EIGc9B84ewdXeiFTvKAfVn9Q6bFHlIaJcTU1wxTJHdPybmqLcU/
         /9Z64qLXcd+Jf7OkUwU976KlgDXLuvZPZv3GAGwiJPh6EfiojC0RNJFzmTAVZm2Kn5jh
         0eag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782010816; x=1782615616;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LVrIryE2VF1sDSS46HMWn0Px6aDg+06V1VeyZcyjwRw=;
        b=G2c5s86mp7iVGLGHihHrtuIqhpOLBsd891pRAQEHMd8f6ZbGv7I1ocHoF7ybQDFCYx
         BNgY3QIOGcwLIM54vhe9hMaHo7CiDJykj8T3h4tWmsh4Cr/MAHR+3xYATZOWyFhNtiYK
         LPlylzte7MRDSmBGRF8Bk01Pl+p22iepSbxZD+cUcKIBIOu+B/vHFVMxd6WqTZ06FIW+
         2IcmeHFDlMJFF1s5oM/q64r22PiovkwSiLQ9c1HcppAEzHAW8Mv9PDpsAY7m/Ek9GBDC
         SJOKFL+kkf/u5mrqf2f9kGErQ2TlE9Mf6qlonUhW5OJRtsbEq8iWhKyTkicIay1KD3KL
         K5og==
X-Forwarded-Encrypted: i=1; AHgh+RoXL+05iryG+U8na9UzUcwFgoA1WvDhMUYFL+Lls8cdj6bALWQWHKwe/M9L8xUTVeD0Q6h7M8D0WA==@kvack.org
X-Gm-Message-State: AOJu0YwYYKDnE+3HRJCuy2cdp8FAnnl+ud47Es4XNP7DAX2oNkUZfUrR
	ZLIjEe+vnAeOFlftdZrCWmSj0cSPxtEVPli0XCeu/GTzJLPtVATdAri2tZfj2/kEh4UNwrYucZt
	ZiXsZpQaTUlYJ8AJWUG9HMvh2703odDU4Kj2WxLx1
X-Gm-Gg: AfdE7ckc0+wVLgjK11KkCRph7V31HtCpj0plb26/SR9T/PgqvaeGZ1xBSAiI1Q4aVYA
	sGSVC69l0ihH9K0pmUhDgpXwz/FgJ6xwN5Ki12r5RMYYmEz+Z6clOWDTyHurdk1BB9U0Nsw9DAt
	lS/pls178giWYpo7by/hthR4Jmj7+XGj29IWHFBh7ghvYMXdKYmvibIREk/30HfGnpXO4R/GfhF
	6m1mLMVJH8nThqNzYN0VZlvKzKNyiags//WUAJbCkDpB67rhoOTdDSjmqG7WVfS8feRdmg=
X-Received: by 2002:a05:622a:580a:b0:516:4f62:85f1 with SMTP id
 d75a77b69052e-519e4a744d4mr15890001cf.22.1781999348457; Sat, 20 Jun 2026
 16:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
 <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
 <ag4h87CBd-gph9zX@casper.infradead.org> <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
 <ag4kj84EcKqamdB-@casper.infradead.org> <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
 <CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com>
 <ahB6QyHgYq8ksj65@lucifer> <CAGsJ_4zxLvZ01i19vdo0xA47T1hxa1VRYvxLmiDhy5q1GDKPRg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zxLvZ01i19vdo0xA47T1hxa1VRYvxLmiDhy5q1GDKPRg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 20 Jun 2026 16:48:57 -0700
X-Gm-Features: AVVi8CdrqLszoGfh6nxxBjM6ZU4jlgAaXlfN0swetCJNc_4l9-uU6mX0T8CUJHo
Message-ID: <CAJuCfpHTxaU4KdNmefU7C7cWZSLCFDLPdUrnqV6yzxzN+8RQ0Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Barry Song <baohua@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: gjomj8pryknnox6r5h39mxkw8h4xjjj9
X-Rspamd-Queue-Id: 7F4428000B
X-Rspamd-Server: rspam11
X-HE-Tag: 1782010817-438438
X-HE-Meta: U2FsdGVkX197RXulsOOAjAc73W5HxcAxKYZlU8BZ3sdxwEs1QO0u08wqVbq7VYobnUO85msxjz4Xt+KTNvGfMy4VzLznPTKU+z8JtoB3lrKiz+MwypiJeefj6Dby7C/9BGZv7mStkyzETVQfF494ipti6jgCZDViQlpnDw9QoZLfP0AExHRyU3ef7nba2Dv3Le4PjzLQZhDv9uaq2K54K6ZgqAObb3CCh8sJLx/TUMyO+ompA6Y9Fmpsxz44wa6EhzgGVk1AQZLHh6Grgt8jPfUW9qJnWCA2lOdtc5HcF80aJNQaLHrScqWX56Z+aqt9CRTDmTYODCYP0pBIyNVm7SlpZmljUN3SRMnkss5drYcnMriz+10rMvR2gWtrQlrp2n56Y9k1Ut105Q5YGM8I+1WTe2x1aBuIOQfCfg4JiMw4gX0cSFHwVNC+jKrvy7LhOvflmhlW0aLbha4j6zooBmIzGisiHSt2nRwtb/07AnoofHZX/NrLg3vvYaC/XlnCVLkzRsRNhM5OAcUtWNawSpf0os1J4tupxF62+AfN2R8QOi7HE56QKd9411lybSV/qhoGxWeYMOxY27G9JGsbUiPmRhsUd2V1N9OK0o5/DhP+PQDPs78LtlFrwuMxtn/hAmgHyZWNa5GBtGYI+u2aM5ClzeM9yqziz+NcOotx4+ayhjf9d8dP1q1BAz/Z9vgWFaBxmaQ1DN1ULfqAo5h3oJMqt4nk4Lf9aN7YRzg69HX23CuD1j7iDRUOYZUKZyLi5euM7n3nxKeblXvza+OeioXaakinsO2raTLiNPX83CE2LCMfJgSnt0uYcrn1zwAetUGnxj74JsWrldZ9bd1qMt8+N+SZsMSmx1BQndV47kC9Bu+hj9QYmix7wr2wmQxSX63DuYjIyumXOzhFYXB3Ly6Hg/Exu56sQldIQpQqsy7W6HOjsjOfybzg58l6fpIsaxzFq37mZJyDY8acpVL
 UHoy/dmM
 BmPLHYgtJbsJB9SBvTL1aOHGEADOGM7JKpfY01WZDRsN3ZxpwT6e9Fw0vrbJeRldWsOV743l7FuNaJKckLu3h7qQ1gcYtINzNpi+gI8a3LyC3adJmlZhjZTDy2CsYwfwGk0Sqekc68+Zsr19se9xPPa92A3SpVjiHRqJLmMCwXx2/NDngLqW0pcknjj9yxvaiIgYlzl8PFE6VnWc5EXKye9IrZg9hGZNK1IWwBm1GE1ZXtcXx7MPo4KXn3uS9/J88rjDF0SXpOQ7iGuQIEUoFvo1/8c7fPLQXlLX9PfM80Ss+BMn+Da6vkeKZfzuGgyqP89dIsvQm8ufW6wfVzgkEL8guIUUmZEK0hqUGKZFEJ8LfFOE9Ct61PCmP3nD6jGy87F0K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 2:31=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> >
> > Again this is making me want to sit outside and sip on some lemonade an=
d
> > ice :)
> >
> > Yes - android processes are aggressively multi-threaded, sure of course=
.
> >
> > The missing bit here is the forking - what, where, why, when?
> >
>
> I really want to know the what, where, why, and when
> as well. But since most applications are not
> open-source, it is basically a black hole for anyone
> other than the owners of those apps.
>
> Let me try to do more investigation to understand what
> is going on, although it is really hard.
> To be honest, I would rather the Android framework
> completely prohibit apps from calling fork(), if
> possible.
>
> > And then you say zygote is sometimes multi-threaded but sometimes
> > single-threaded, which is adding a whole bunch of confusion on top of a=
ll
> > that.
> >
> > I don't find these stack trace dumps all that useful (though thanks of
> > course for taking the time to gather them), I think we'd be better off =
with
> > specific data on forking, in some _concise_ _summarised_ form, ideally =
with
> > numbers.
> >
> > There's such a thing as too much information :))
>
> This trace shows PF I/O in one thread overlapping
> with a fork() call in another thread.
> But as I explained, I really do not know what kind of
> user behavior is behind it.
>
> >
> > Anyway, again, please let's see a new _RFC_ with the approach proposed =
by
> > Suren, with some _succinct_ data demonstrating _exactly_ what the probl=
em
> > is, so we can make some headway here.
>
> Okay, sure. Thanks for your patience.

Just checking in on the followup plans. IIUC the RFC mentioned will
try to implement the solution we discussed at LSFMM: splitting
VM_FAULT_RETRY into two flags - one for retrying under per-VMA locks
and another one to fallback to mmap_lock.

Barry, if you need any help or clarification, please do not hesitate
to contact me.
Thanks,
Suren.

>
> >
> > And now I'm off for a cornetto! :)
>
> Sounds good :) Enjoy your cornetto!
>
> Best Regards
> Barry

