Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9D5606A320
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 18:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MFhr+NLQ
Received: by kanga.kvack.org (Postfix)
	id 79CB26B09B3; Thu, 22 Oct 2026 14:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E166B09B4; Thu, 22 Oct 2026 14:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BA66B09B5; Thu, 22 Oct 2026 14:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39A186B09B3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:42:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B68AC1A0280
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:42:43 +0000 (UTC)
X-FDA: 85351133406.22.8651097
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id C13AA1C0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:42:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MFhr+NLQ;
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792694561;
	b=L+SjunYxmQILhT0dj8MXJTNXUJQ6jnokIxyc0eqmonoAJfOghVwSmXdjAlD7whrhGVJpZy
	qj96T9R+QPRaqDiOcDZziGTdci0yaO441emAiEbjn1omlNmPMQCl1MoVPVyY3IQElUgbAv
	iLGiMVE7IrxVcUvpy4h9uS1dmScr6z0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MFhr+NLQ;
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792694561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZ/uBrhQVS3DiMAnoAWQ1amBgCkO8xqm7sNIOjhR87M=;
	b=tOS5Sz2vns+/6B6PvFUwXa/7LjtmAFBlOLLoA4w4Pta5NvSf2ArOhkHmaRCO9aGP+/v/iq
	ZBW/uRfIqXWgTPsQqViLxriNwxamuo0mdLyflW1o2hwlOTe+bdCLHQo3KLczvsNELOOtcP
	5/ZYfIyy2v7WAG1IDDbrfuKNSsJeYGs=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2db33db4de9so10585ad.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:42:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792694560; cv=none;
        d=google.com; s=arc-20260327;
        b=FTkTC+bW80nhie4F8PLtBxKjenpAHARkGmQGhtfYrhq7JffeDgNJxhqtGHbbcxS73I
         5xYx76R1mTjn32Odx+dFrC5TzDwNY9j+KBzR3xgtSUJQ+v0/6jskQ19bEhjneOMzlk0A
         zFIYCzGKL7ESqbrOnrqaWTfFKjI9W4Ou9z16RQ2aMftYwUQRKYhBk6pbW+0ik7J02mFY
         P2lL1y6NnvxWN6qN/6ZI3K/EMFn5cuSLdK+jzXt8Qso1MZQjl+Rim6sP3aysVfnpg15T
         pRWPn+P+uSehQ7JExKMqYl++UlwjlqYy/WS0jEQIMP2aPuczV0/BDSOftYqoL21wzZNG
         +blg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IZ/uBrhQVS3DiMAnoAWQ1amBgCkO8xqm7sNIOjhR87M=;
        fh=5RYm7scnu1FI+JNRGUCsftpWOapnanQXOJ790zUl+d8=;
        b=TT02jG8WnrkQBZlLgMZQoJZufwiGkeDxUDrBCRMxT51L5Wf0VYG6AhLYpOInlZkJvB
         SpB6w/xb9MqJJHL4tkPGQFjBlHxqbJVNk2O/qwN+47332kAY+Gn5CnDluRMTRrpdkSAu
         ZG0FSoe/8ytydBPxLAUlvcGEMSb0vOKM0mGzKPUB1kpjr8YT9qTBFpx3xfLdVDQmwRrf
         K3tEa71P6OSi1oS67jkhUAGNt09AnjVmE/pex/Dh/iTNUlw4o8MKA77WcWVz1xSzE0yj
         AyhvTtmgcQElB1ap74I42Ps6NixE++M8BT5tw7j5lfOkjnvSpRBROHXm3nfOejJaoEZ2
         fjUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792694560; x=1793299360; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IZ/uBrhQVS3DiMAnoAWQ1amBgCkO8xqm7sNIOjhR87M=;
        b=MFhr+NLQsfQkt5PydtnCR5NYwFx2XQCz072BcjhLdf11pgBusbGke4KsT0HU1EIgDI
         0etzYfFHmrd5vuT6IZsgZ/cxSHpJ8wRtDXlT9CpoHEgxULfsTppi+AnQ60y/qZawK56X
         /Y4DF4i9WmTwsN55gplyE3GWK+V07eYW6/3PTcKJJLD/dQ+MhQv8E1mQ4fYQFubAzNoa
         kjql+e775K7NBeywk+DOx3uq2nnsSuTzaE8Wv7sqnpUb8TqJe5sBDU1NThhGRyWd8vpV
         /iZpRKhydZnFrY7J9oh4tkxyRCDPfXAXW5IJOrlaWm3uHPQysYzoSlrY7cZ+32vs9veW
         Rkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694560; x=1793299360;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IZ/uBrhQVS3DiMAnoAWQ1amBgCkO8xqm7sNIOjhR87M=;
        b=P8dhLQkVvCwisbuSCXOgJAPC6bJPWTcA/xZEfy0+B84maCFR/AYsP+3bljsvIC0lxS
         wG5jey4Pt3E4ta2HwwFk97RLPuPl0IDnSPUw+uquxj4S9cv7XM65P6y/BgEAtqVV3+CO
         0vv0+uiK9p6xP+ICqcwaCydXVjXy8GIBsP4vub/iQB5/Acn7CPN80F0BvFPS4NTcgsKN
         sN+wZ+M2QKfSVpxHUeOh2QpIFNQXBhgYoJYi7gVQ/skZCL0mdupw73eYF+wHvecE6u93
         rRpThCoEXl6368zkr2vbtMRi4anjyayhlWBUK9LnhNBpdlX2PW8WnvEuEHhupvpPZ1JY
         hdqQ==
X-Forwarded-Encrypted: i=1; AKwUvBx0PMlcW6y8ze2selVKC86XliKVJkrZmIHYcDbLbGpsdpe1mXIyq7WGLEBIlwavAv7GrGmMmTKE2Q==@kvack.org
X-Gm-Message-State: AFq9FYLjJeAId5Qq1ZbrwHh0TSz66cYMU/USQUub+mLhaX/T9GwB8rZi
	GaP1r76G3FJoFaeEj5cbmsOvYU2/FYDiVxwNSKoXXCXCLczeDwso2sfHWVDe4MiTsYGQInRCIuB
	OkofLmb3TsrZJZ7i5d5pxc968lbphtFKrVudsj7qk
X-Gm-Gg: AYBFou1bW+sHibfmQmRAl9OYllOeUWt15d8wXJgX7Esc7SGXmVDWYF6HRfpa+pna7Cn
	+92RQ6wqR0B8MNoygTDlsS1wOM9CWDz0HspcMqVvzqJU7DbIpNkHbn6M7Lo2CWcKijhf9D1H3UG
	k77xNbbj37weuszig4v7f3t6llwz7zSyEoqm/ucct/8repzRxT8Hp8pWtcvR8xc6ZErLRoCax7S
	fWLEChTRvazTwjD1up7Rx336Un9BGuwzgrMZgzIWqiCsQCiNLLdZSzNpGwmaUBKWEB+7fYpagcs
	EJjbvFidKd+jDbUXrHlYEi5CV1SYexaBkgEvGn8hoSeZGmOgyDka41wH3zXyndWlYFYswfP6RhJ
	VMYoU/cr/Z33DUJnjDsFqT0JBCE9TA4zbXMjLUjX17RWqaF7qPltHAph369ZWnhDS6mVjhHyYyK
	ZtnHO7HJ4GA5snBnJdMkYtmAWpE+/TNbyxCW9x4pOfe1U=
X-Received: by 2002:a17:903:98f:b0:2e6:12af:5b04 with SMTP id
 d9443c01a7336-2ea7c74bcb0mr574065ad.0.1792694560033; Thu, 22 Oct 2026
 11:42:40 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com> <20261022015712.1297331-7-alexei.starovoitov@gmail.com>
In-Reply-To: <20261022015712.1297331-7-alexei.starovoitov@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 22 Oct 2026 20:42:03 +0200
X-Gm-Features: AclHuK-4emBvKnbiUXwxsP0RzswCumffVqYk-pDdBlhbp7tQ8eLavk3E__t9lUU
Message-ID: <CAG48ez28oYxMAxJaXnYtT_8xGReS6SLC5vURw4eStWpuPsSSdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/9] uprobes: Don't sleep on mmap_lock with
 dup_mmap_sem held in dup_mmap()
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, peterz@infradead.org, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, mhiramat@kernel.org, 
	jolsa@kernel.org, akpm@linux-foundation.org, liam@infradead.org, 
	ljs@kernel.org, surenb@google.com, david@kernel.org, vbabka@kernel.org, 
	hughd@google.com, kees@kernel.org, tglx@kernel.org, x86@kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: c4dmgzm48frf3ikyy9jqix7rtpjooybk
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C13AA1C0003
X-Rspam-User: 
X-HE-Tag: 1792694561-191611
X-HE-Meta: U2FsdGVkX1+v8VezB73IX3gsw/cvR6VTeywyD3rj9Hey7vf6IDHkNSWsK/+mLCgeFML5oReD82zdU+ydMM8+l3W7WXuheLlvhVKTeSlIKnq9gnzGjZPJuHlAjF+VeUyX8DPA8xgWrgc+7v1djMat4xxgHcCKeUOzAWWcDvKTpRHVcBYPGP1gCg/DkhLqEtF0IdqmtQfUTdtR4nxyN9qPKkndyjQZRGObLws8vo90pkSyyqwfcGdals2soPLPCXiRLA7n4dYVv86h64Sry+f3ajYujbDhsBeU3h0p2oXBGldwssdqNYlXfmzJPCB0cdkz6/fcsaLMQ5qJaiPbzkBc8NTVydmK3Wpw3zKCk+1yjJu5yiKRmGdzW+rszpF3mnK/txsJhe1K7Z27g87yNcf09da1qpi9Ymiu/sH512k5AuUCVKJeUKeDvoh47mC4VmOmFPka0nE/fMEtazm8TtcnqnrU2qGXqu0fHTDS28HzvLxGXuJ5SfaJdZ94wr/NG/iLUiqfL/4J8f3EUH3UJQgpBPU3BMHI09s05LKY4Zs9iDketGTrdKUIOvu2vmTeFosfgVY0VAdWGIaL+PKBDhEk0KcJ7LTKLNS5D1N6uIfn7/8/GjdQ9cbkU+E9gpOSwIPYcGUs6LbLi6KOB8diMbvFvEvGBWWLcIUVKs25AuuDX5vCq2Jg04LzuTDPcNF09h8V0+LfgIrhU1ajDl1EMuSpwdPvdaRHRnfafj5+IClt3tzL9t1SE/XPvlAtqwedcRxwas519JoSUEf71iOFUj8ugY0xB7kfPOi/23f2JBEjZgumC0GX06Qw5b/Z/ALx58yu1+yrY7W0WDLeTDvtFylqfRfzNRIwoXg6FDGqWyDC1lp0ixjabL+0IawxhDIbB3QeSG0DXmY6ZbNqpMpzPZHAQXf1SEdper7Bxp+dbSFgvf2pVKYocCO5vov9UIjXk7WFX6dBk3mSq2Jur+VR2/L
 akIjAR0s
 spSEB1BqoiKtRp2czxoBs1+hq9oBdkEW2N3vajIXHoGhYSIznOPD4kH3aGkN89+5OospTPxNWxCGib/EjX4iHw7R2zSwIwqqxy3r7e36Imnm8VuMeRsekF+LgxluMD0+dAE/YwzeshlQM9ppPXkW3r5yutk7EOMT7SIVjzmtO0vAffB+B/7Y1xeoT9CyQRKKlHrDI+jBbLp/MGQ24LcxTg+pY2hC0ZCgydQoJkXbwZZzMQv34uNM/TODRXG6ROd6dTLxVmB0AsEH0ZuOdW3hxl2WVrD359wysjijLgHYZalPBSn1Rcc8Z5HoW5u04flefoyjcUl0rr6qZFu5yzFdTOYcyK5/uUEh7Mu9R+VoSQ0t4S2yhba6loSvsuc93cnjXjnba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 3:57=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> @@ -1713,8 +1713,22 @@ __latent_entropy int dup_mmap(struct mm_struct *mm=
, struct mm_struct *oldmm)
>         LIST_HEAD(uf);
>         VMA_ITERATOR(vmi, mm, 0);
>
> -       if (mmap_write_lock_killable(oldmm))
> -               return -EINTR;
> +       /*
> +        * Take mmap_lock of oldmm and dup_mmap_sem of uprobes.
> +        * Don't sleep on one of them while holding the other.
> +        */
> +       for (;;) {
> +               if (mmap_write_lock_killable(oldmm))
> +                       return -EINTR;
> +               if (uprobe_try_start_dup_mmap())
> +                       break;
> +               mmap_write_unlock(oldmm);
> +
> +               uprobe_start_dup_mmap();
> +               if (mmap_write_trylock(oldmm))
> +                       break;
> +               uprobe_end_dup_mmap();
> +       }

I guess in practice that probably works fine, though in theory this
locking pattern could potentially lead to livelock?

Like, if two threads T1/T2 both try to acquire the locks L1 and L2
with this pattern, you could get something like:

Thread 2: lock L1
Thread 2: trylock L2 [fails due to contention by a third thread]
Thread 2: unlock L1

Thread 1: lock L1
Thread 2: lock L2
Thread 1: trylock L2 fails
Thread 2: trylock L1 fails
Thread 1: unlock L1
Thread 2: unlock L2

Thread 1: lock L2
Thread 2: lock L1
Thread 1: trylock L1 fails
Thread 2: trylock L2 fails
Thread 1: unlock L2
Thread 2: unlock L1
... and so on

In practice, it's probably fine as long as SMP cores don't run in
perfect lockstep...

