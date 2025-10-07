Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D85BCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B478E000B; Tue,  7 Oct 2025 12:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22D38E0003; Tue,  7 Oct 2025 12:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60108E000B; Tue,  7 Oct 2025 12:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6A118E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:11:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 596F2140267
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:11:23 +0000 (UTC)
X-FDA: 83971808046.09.C6C1AB3
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D41418000A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:11:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="VfMFE/wG";
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759853481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=un7oXwA8f3JrQhbFm3PmTsLCZIvoEx3NihYquDPKahY=;
	b=Otv05+rBxQdkHmhESsFXuZ+8ArOm9CDwYu4yfASY0C8aDebhgey2dyy7krtIvuxIfCiePx
	rMqBNjcG43Bm9fYdTC5GEgIsEWtG4zN+zmBjGl98QKh6yrMCRXKMq4I9/oAKfitdki4hIU
	QUDSR6Ya9PrIq6FeVLc8sAFTdgEbvlg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="VfMFE/wG";
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759853481; a=rsa-sha256;
	cv=none;
	b=LxSlW4iP9t42BT5nOXz6BGRO6piU1BinnjE8xcRV5thh07FXWSk7NtZxR3pyHjxups7gRn
	bG+efBFByO9Zv5VXH0KxMiURBt5fhsgIGE8BaqRUPO0qCj+Ty+847uA98q6biE0ARvTphx
	4hUvMgGdmXtlLPdwwRZdC20wsA9UxrU=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3f2cf786abeso4443266f8f.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759853480; x=1760458280; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=un7oXwA8f3JrQhbFm3PmTsLCZIvoEx3NihYquDPKahY=;
        b=VfMFE/wGP9JOCPINvkm4tTbDkyqKDnzT6c3k6dR7hZoI++0Z1BOgUdurWhWirSnFrN
         nkiDMzKqA0fT7kKAHf10FD4EyU1SXIYrRNZ1IDBpu8DUKJvuWoVXiO9ilyFFD9bBPq9V
         Gr35M90JkF0zyqVctrmf40Z6otpxO9v0DDvpfTdkvAjLBqYPsnyJIpZABZuJJgmLOl/Q
         cAGEDXcSGT8DunUtNcCwWRUKWazOw1X1zprsAhHXJ1pQHe9gzGnkDNoOqTvSTPIR86+0
         2n97RaHsx8LGJyHQ08qgJjFT4KcjfaOtUjFa5ASVMg/KDb3toGBYWNtcokqv5vgx3SaX
         ih3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759853480; x=1760458280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=un7oXwA8f3JrQhbFm3PmTsLCZIvoEx3NihYquDPKahY=;
        b=HQkTTOstCqCyx+CeJHqcj9e4kZb+W9a25G8vJgysZ93IKkTIIX83N8ceTZoSXgmXYj
         Dcb4uyvyaL7E91XdCOt5d7eoVNGLFGPoCj2IFDvkUH3J32FkAtY3vFZWVT+jtFr2hqxA
         hkQzeEeYqA2q64RnL4nRLdv3wHXkueP6z/iYelKZPmSYUCojOB2rhwtPLIV6qlxmS+71
         f163CLlujsxUTz0Ke4JzQtXU+HVYZ+8vmfaQYKj6HItOVbiFLjc964cBrg+HR1voFxJI
         f5JfjlQ1wdVnsXQesErhQoWog8xOtLMX/6B1KoaVVaN/MoxJwtWq37IT19sF3oC6dcm+
         0a9g==
X-Forwarded-Encrypted: i=1; AJvYcCVC7XctogwsjSO57jZKjwH4zVQQ52VPDJ4debZx77K4vn81i67CVTZ+qFYGUV1tQ0gx4lmXKJJxCg==@kvack.org
X-Gm-Message-State: AOJu0YxEAQUNMicm0Fysrs1dsliuexHjmzPB5c/PiQBckL3/YcfW5CXo
	y5XH8vL1Z+oakt++COMdlmJsYKXMB85s4qUq9fhktcgOvOuUMCIOKwvCe/r9llSpt8QHsqZ0ets
	5LdkL50P+PQS9zxZgxR0Mr6tJiVvtiis=
X-Gm-Gg: ASbGnctVKBW/7tsoL31Di7tZ0orR33frvCsTss9vjnly1OIfhI21MQkmcH4clnIJa87
	tJy90LPNMuFxJpb04AWburacsxcM84v0ObVJ6fb9DY2AQ/1xg7N5wXUX4c6DFmgFJz1dL+/gY1X
	Bvy+IRcCcnxHK1lKORlB+8FW09OElUaRQ79CLcRPhm73q0M2RlhqFn8Nisu4cRoJQvkDMV/gDiL
	2Bm/est1NTDIxBrsrKUVhYvC2mkAfW/IK3qLHriI5NfHmo=
X-Google-Smtp-Source: AGHT+IH4bSYUj91ZX+SaR+kheRoBZ08phaGVNEwoXL7w/LWqmu7QUhdlUPzwtTh0JaMUtvlSQBpIDufP6KHwn9/u+JE=
X-Received: by 2002:a5d:456a:0:b0:425:7cf6:5b9e with SMTP id
 ffacd0b85a97d-4257cf65bb8mr3335600f8f.3.1759853479713; Tue, 07 Oct 2025
 09:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251007052534.2776661-1-kuniyu@google.com> <10d6dec4-665d-493f-97a9-2982dfbc1afe@suse.cz>
In-Reply-To: <10d6dec4-665d-493f-97a9-2982dfbc1afe@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 7 Oct 2025 09:11:06 -0700
X-Gm-Features: AS18NWCn7jbyUpKF7U0Zue-z9xVvG3SBWOS8PL6MXurnmrn-4y_ckg6iXRPSkBM
Message-ID: <CAADnVQJ1AzEL6JD+ePBZctqmK6unYKDYKuARRwDBhNJ3CBykdw@mail.gmail.com>
Subject: Re: [PATCH] slub: Don't call lockdep_unregister_key() for immature kmem_cache.
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kuniyuki Iwashima <kuniyu@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Alexei Starovoitov <ast@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm <linux-mm@kvack.org>, 
	syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D41418000A
X-Stat-Signature: g4wbf86nwbeqq6a8qewibbhcumjjmxet
X-Rspam-User: 
X-HE-Tag: 1759853481-660202
X-HE-Meta: U2FsdGVkX1+hMbxFwUz2XOfNBh7eJgYu5aLX7ltSAha5QwscvHFpNgb2CROeypeW2hGssU60t4YixB1CgUkIn1zDio39l1rY/8fZDlQlqVMhwzFI4DG4mDQA55AordfDJ6xz7lo0TizykwlYEpe0kaE9e9MlHuQRtRv4z7Mj4m23VQwd8myktaLbd27OSlJV2lwjaQCbvJbSPyqPwMtHTEGN/DlMVBqKxx04q2/gJmpUKz3x88Cinl1klvPAnfN3zFTVifLqlGjKfZm8zzriWT69ysQogGX0rWrF0YugikeNJWR7KQdxWWTGC8H2tholJ+7KnNy/QqOwMG6PJ80r6mEy127kBReiaOL8OTIBuL4Lia+jI+s7b81FScnEH7L2y4Fb2dzgDvYCZDYk5b7ev0BD087AhE+UnAvwAKczrpullDBz6KOEu0owBctk258gJHssLESPq/yOZJc7wOc/B7MbHbXCa3oCkCbuGWERvt7ymaqpX/vskqv94b+8cCNagZjPydbFcdi+deg2v2OytBRFklikIlnI7smkbk07eTknhgMumAF4LnA9oU6LB5w0UiJvZXby+0wNGuetLpBJGxRr92If1KGMWHuE9D4qjMFyqtYo6kxGT6PIH3WPc+I40uYw1ybaam/aRUtirrztYLuFavWNIZukQJVP5VlEdD6UIXobIEoUy/iSfxrnoD6nARiZdcDZ9tlUlbDBLJp1BLYs4pBDjdorcDMRNiXR1H9+8tx+x+BhGOWmYo3F0ItV30xw6pssW5tyzw7Ryhf3RfiNxoSOZ+JFZC2ADr+wVTqQ84DTgtNfvWtNjK3Ij5L6pc/U2/mzugBiZUaD/AfbK85WOInJhhBjxJ9Af5qsolRkilDVeDs3qGL2F4r7fEAEiiajupCSTmyYt7wXANfE9PCfksOiXeZ5Qo6+RxdendJaiFRX+ssVg0WYwf0v/bdx2qtBqIxZEh/fKag/7Iq
 ++EODntU
 OkK5PycXfv2d0Q1slcwB2anVzDZhljMOeWriAbuUqiRJW7Vlc89SiKId5bHJX2YMIG6S80z16xigUBjjTnuFicyAgvlQU9n5scHZQ9L1qO5fRxseM2bkuz1NTyj6PdCShZMVo4YoYRMQx0w92CPLLMzMJPz/yaV7q/YdM80Ebs+L84lLUYq7qRH7VF7UzDxc5YC12BxQ4890TZag6LQt9EC1E1jzQAgz5omTL1LXzONhEPHP+eYBK9EIMYcuqDfdfeM5Ey2vfx0+O9byK7wxgjl0LLf5Sh1fM2alSpK5mpDLdkwfAXuUnuchdWgpANrrFOj8SjwgFZ6vBpMkadODiZcNvvjC3IuC6nFfO0bMakd6F4uUk2BDWcFSPmqOhaprh5h8V59aO6hgwoYCt15fo0ubhRQ8L10DVCgvDcAv0K32a3g3POt3WoaHQhy2nV7wA6G7PM6zdc2jtUBLEeP8vqu4OeOE9jRv8h7dRcn4UkmrayqsUPwOzC5/Mn9nqmAL6VwerGroVgXOpofzjvbphicueOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 12:46=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/7/25 07:25, Kuniyuki Iwashima wrote:
> > syzbot reported the lockdep splat below in __kmem_cache_release(). [0]
> >
> > The problem is that __kmem_cache_release() could be called from
> > do_kmem_cache_create() before init_kmem_cache_cpus() registers
> > the lockdep key.

Hmm. If that's the case then alloc_kmem_cache_cpus() wasn't called yet
and s->cpu_slab =3D=3D NULL, so any kmalloc/kmem_cache_alloc from
that slub will crash. The above sounds like it's a race condition,
but it's not. It's a weird error path in do_kmem_cache_create()
due to syzbot pressure.
So the fix isn't quite right.
There is no need to sprinkle #ifdef all over the code.

> >
> > Let's move lockdep_unregister_key() from __kmem_cache_release()
> > to slab_kmem_cache_release() and do_kmem_cache_create().

I wouldn't.

> Thanks, added to slab/for-next-fixes

The following is imo much cleaner fix:

diff --git a/mm/slub.c b/mm/slub.c
index 584a5ff1828b..0a1fbddb77f8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7693,7 +7693,8 @@ void __kmem_cache_release(struct kmem_cache *s)
                pcs_destroy(s);
 #ifndef CONFIG_SLUB_TINY
 #ifdef CONFIG_PREEMPT_RT
-       lockdep_unregister_key(&s->lock_key);
+       if (s->cpu_slab)
+               lockdep_unregister_key(&s->lock_key);
 #endif
        free_percpu(s->cpu_slab);
 #endif

compile tested only...

