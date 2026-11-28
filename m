Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0737C606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 01:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EFKnG+3R
Received: by kanga.kvack.org (Postfix)
	id 5D7D26B05B0; Fri, 27 Nov 2026 20:51:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588D46B05B1; Fri, 27 Nov 2026 20:51:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4779D6B05B2; Fri, 27 Nov 2026 20:51:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18C426B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:51:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 637C21C3D9A
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:51:22 +0000 (UTC)
X-FDA: 85482850404.04.C66B8FE
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6DAA2160003
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:51:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EFKnG+3R;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795830680;
	b=668gzb+PhpXliVOvVRsA3zWrZ9VbH5ZrbvxwLJRMNczVYr4mQoysHED17Ke5hVeyNsrD/Z
	T/QMggRTckNvbZD9wYmCKbQ5AvGCubEzf/sr+wyjUxc/+vvCPoQ5XNGmLdyr4gm5jgKe2e
	fC/dm1xjYzAVMI56nLB7lu/6HuNw81M=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795830680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
	b=xOhtCn4UdXnnsdjZtFw45lX9SbPqGBD7xL9Is+Y1re8DMwrftIEd5jxhgjpMDi4F88NmlD
	kENMM165AhC4Odmj00oVgfE7fFuxKkJsAp9cJ45BFa7lWxpM1ywx2s5deFAi0ykm5IkRpj
	47f0pvfpndnbv1NCuJ3/oLXCMyR2N9A=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EFKnG+3R;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c5198302d38so704099366b.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795830679; cv=none;
        d=google.com; s=arc-20260327;
        b=hV3G055+FAvfyZU0nfO8PT4nlNFxPG5JN+1RF2Jr7iRFs1SjexufoDS10FGu6Vp1qY
         jLNiSSmpTDvJE3G6hiiQVLds5jYWRWOPj4Y2gj2wj0OVDtXNiX7dHRWhPjv2pexvNp+o
         Z4xI9dEXjNMmzXqVDDmV5K84fO9GYrkpzrZD8XogvbA8DJC2k4mPGLLL//1Qq1hXWyHd
         LpHPwG6jwbeGAOKFY7jzfb9kxrmX9BxAbOdYO0UYJIHrXFtKk57vfP6diYRoX+k1gvBj
         XOEL47PHr/hQ9Rge6eQu8ELDWwAl3xazuVViJuIIVWxbWKRZLniiwSOcvEaTr5iipx2d
         QFag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
        fh=ZKO1RyjmnZpDX1IA74TbEoUNWqczLVBrk/Q4nX5vr1c=;
        b=S82kPy3Kzu1fH6JbNcb4iqz607Omx2Md+/ULpHQZuIY/G8K4przIiQP/V+XnnMaV29
         V0H173SAiD0/JdHHYLCG3+7xHNcviHxfQswVOKPN0hfck5oxXwVwMKXDC0cV7YeV8sWm
         3o9P4qwTy2TYpS5CizfHamNXxLyyzGRCi9RMGM4HewtMXMFXYKynVz22tJRe0IYNHRgf
         mDZIXc4tRPLpe+W+XJiW+gHu0wGhEpXdWgiphQzHLaGCS22DYlT12YjOiJKkXMW21/Pn
         bAe4tYbb4UEgGypVj3aSaUyMRrrGieXOZbo+rwzsNAy2flqDgsQdjU4k90ihIrUIVZkn
         OOtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795830679; x=1796435479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
        b=EFKnG+3Re1mZjMMAq6GVF2cWXWOLp9vRwCijHvoMdgooBc5NX6KFg/EzTB4bzJ45//
         3kvNHI3Ek1BtGSfH/LIBzKMWOI9Uctl5NNJABPvU1T6Kwm1vATBSUnc8l/DSQ73cADlb
         xm03UsmoRfpZu4P0YJy2UHz3YurAlbUXPqgvi9pl7gKNF+ZU6ISpZ3sOWb+gHeWpbonE
         iD9cfrY6CZTzzJT119eQ5WUfhHXy0+21mg/TrSY4/dFZPhZhBdecnKMLQaHuO+qG1WBU
         LJn6JqwQwkU9+pzQ5r/yYDlVD/CiNTUMqDQ1KEe70bw1gRIDME3PXQVioPrS4qVQY0Qj
         DWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795830679; x=1796435479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
        b=MoZUColPbwGcVjtxHP+I/dbwfgZ36vrewKLaHbOtWpyzd+Qnu0/xcvetrmQEAGfuYw
         4HeNC6ANIGHUTEUxkAddtadgDeOJa/TddVJ5y89s5N5LgoVt05PBSdNTD8J0KrzbngE6
         Q6HryPMnl4qIiPKBHf4oF89z65MNeSYmgyOnOM7iUe8T3NlWvURXW59dau6yqfN2NC85
         leBOF5iQUti9XkixXn62HnVH9H4VTKDyNwEva5lzCeELAmHY0oKc0u9f38jT6SA1LmED
         S42TlxBJwUwArj2CRqaYTENz17jnD7FrmHMvHWN1Ct6fTf9Sv5be/p6tRj0ABTu5oQya
         d6Tw==
X-Forwarded-Encrypted: i=1; AL+hErHRfEi8KGtNQoOVGyZZz+3Y9n4HPw2cdH7dG/uCnT9678JoJTvEJQcw+diYef4rmWN3prXMYv6W0A==@kvack.org
X-Gm-Message-State: APuU4Z/3ITLjwae89792woT84r7o+kLT7rpdAEZP/hvSGLCx2OeFxsb7
	YFmdh4hmmiEtqV0mzu+MgL1YmA7IJf1/RrGDaAZCcSd9wYzp7yRr0be86LgmQY8Mg2f96b+1CqA
	URypxa3dh9eL2weX8CXIwozyRZLTl/t4=
X-Gm-Gg: AZFdTZfO4rRtN7TetdoAFS4PJhOjaEqfX2zu5yKkAP7NvLvxpFlYTctvyEkuJVIiUaf
	cogqyBWmEGsvZeaynXj5xH9/Nlu/t/Lyj21WOwv+Zu+AiHCDsIyEKzSWCWIfDdkACA5VjqnOyY7
	0oSYYtBssP0FCEqN/28exObyX7kpOmzTCh6ZTb93hupw8P9QZJasg21+RVuCTNoKmCM+2ZqqsjI
	xcWC66vxA8f3Pg3T/zV2bFNWb2cEkdiAh2pCcgYBgf9FM5GECiQDnMN9G9VeVmjYHEhz7pAMlim
	ubxwTxT/mX+3J3ygfh/Qtot8IC0w4U4cykriuJwR9+sumKfoCkAjJVBEZKBTgoyzy2kR55qxxLB
	TdeEon8Y31D2J3kxeNlFF/t5E2rUVs0eD4YMR
X-Received: by 2002:a17:906:fa82:b0:c50:4b6e:329 with SMTP id
 a640c23a62f3a-c513a5eaea2mr1724212966b.15.1795830678877; Fri, 27 Nov 2026
 17:51:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <awOQDOel_72Xwjm7@kernel.org> <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org> <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org> <awoO9R7YF_5_6dHA@kernel.org>
In-Reply-To: <awoO9R7YF_5_6dHA@kernel.org>
From: Askar Safin <safinaskar@gmail.com>
Date: Sat, 28 Nov 2026 04:50:42 +0300
X-Gm-Features: Aa3M54pCi2p8qLdocdLXd3OCMkn8g_j_UUSVEEax8LAEOxwj1oFmxFAoHI8_4lc
Message-ID: <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com, 
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org, 
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com, 
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com, jack@suse.cz, 
	jlayton@kernel.org, josef@toxicpanda.com, kees@kernel.org, kpsingh@kernel.org, 
	lennart@poettering.net, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com, paul@paul-moore.com, 
	ptikhomirov@virtuozzo.com, sergeh@kernel.org, skhan@linuxfoundation.org, 
	viro@zeniv.linux.org.uk, zygmunt.krynicki@canonical.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6DAA2160003
X-Stat-Signature: 5ox1ze9x6y15csaddysyqy3uuf7nkpzi
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795830680-116304
X-HE-Meta: U2FsdGVkX18ae9nJYp8dSjTvhIIyugK3hib1nEX9o5eAjwdwbjBHckd9tRnYyYH42TUX7aRr46XKiBH7bsd10aDnpusUzR35zHauWFo9/MFmtMGJ274pxuBesh3tzTc+b9n8wSH5epMgdS0Z0i2niHn71HdHpyyyxLyrRmREBNAOcMvPiUdrSgxalDPUheKqHQ8rg0R7XOkKY9rrbUd/NXICKc3OyWx1s0rkmHaEJf27eNSM5KcytlNtbe/BzV2PEhN9sRgoY9HIDzhyhyLasMx3Wfo75xF51i31DhUGnpwWZbV1THQs/yABqmH8LwbIYWIwGR453uaSkMgl9uZ5kjp4gC9DyxwnenbkWRtPKo2B6lu5Dh1dJ00PDFmgFtT4611VYGqaqVE08gducGQi8v6L2L2d9v5prGSRkri0q/GPPj3+nE0H7Xll54eAvhDDgg3yDuFIqkvhGhGu8XP8AgS5SGnHH2PRTJWe606ztfLBVFnAiGr9un+/tdUcM6DCj36uQgzL0SthqF95xMImsq7suYbyjBaCgDrTCPUgwB/5iA6BvFXWvEXycq5/Gdru38Zt/MnDV/APf/7PNvKrZhMTqqfWwRQqu9UiOy3Zjrr00MSgOmOCWiWG37XnOZXDx8FwnGQji8r+mHX5Y7M3X7/GL4oqUCFve7OzjBaDGMjvb8QgK0T/YRd5LmlZxdkJPsfq2neojbY0e2pD5BnrjvRKBxqfRvuHtAVRDVvWjzbPR2dR+onKzdeOf/oXR16oZQcapEgx+W5Y8Sc9s3IDRBRRATl21bA9vPXCn9yy8okkJhk0lK0Myo4vZ0y+wbz/gtQ2kaCdJLN4IKI5+4IlOolosma3P727hqul/+MU7+euKdLSjG7BHPT8KmNB/AbPK/GowxnP5jJDCuGNDZKyBWrO1UJHeZKjjPaYl/EVe46Xe0CIMXnuVvAWi0hpnHmB+ln+6TuGfEibF3XXU7u
 OOEU9unu
 yA4xOpupmcUD7o/jtTqApHJj6grOXkxIy+1rLFjBQjXxgVWvBYXKWfCWur4mY84aYj/lO1zV8gqTy/fkeFaUjV3VD/pr5EmhNoRk1Xsy/q3hz/lLT5hHw75k7NXlUoeAWhx9zsHvu8U06R8TM1v3op9NuHWaB82bTgcOwyWUtGCsDKXhGKU6wgEm55aOT06GkGeFxodl2qlZXoWRL5rvi+OejIL4KhGg2TAdb+01yUd/bOMe87NqqhOj3p7n9ZBIwPYNHGTGojo9F2sUsCSkwaI0TMrxY6aJ45f8nKCuRUfeDFkntlmgH8ipI3tria7c2fcYbIHctrLyTOpS4Z1JSdjI1Xk7pcI43WHnfFOfsTpThV4/pmomEj9844IIFbYoLXNNr+0wB0y1kg5FGjYijRDZLrYf5FyB7eASbBvjJ5xtECcr+6qsNkSxStQOboP0hO7DAubbIuPSiY7pCGSW0kBamBvnP25wBERg+jsaXUM5f0O7ZSUHRujEiiLXrB/KFBEnQZ29QugA6kTZhCAP3ceTlQpKs5NQgDhV5o4yzZCkBUbb0KobXP2YFagqcZFlJ2I6DPjHmKCPu9KrdSg+cQvdAg2NwJJfGaMEUwbmkqLZHsz1CgEIF77/g3GiXvl5NWLbq7B+7tRsjwRsrlW4r6Pojo7W3miURJB1KsO25kRgt9RqFEf+MHVkebNeIx6wk9xZt3SPpmTGKmOJxf8UWC6VhpoRRl1pxXrkVOxWxut5IPhtZAEAVve/Ihw08Q6Yq7U/qw8nQoZ3JvN3Illu82kw+kri1VeAiAcQITJvmm1UIf0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 2:15=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
> thinking more sequencing than data structures. I.e. I have a game where
> I need to end up to process creation without embryonic state, and add
> just enough weight to kernel to support that outcome, and that leads
> to ~2K'ish LOC of extra kernel complexity.

So you don't have embryonic state? I don't like this.

Let's assume the following situation. Userland's PID 1 is already running.
Our container manager attempts to spawn yet another process into userland.
As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
and then execve.
This creates time hole when there is process, which already runs inside
userland (i. e. its PID namespace and other namespaces), but runs
container manager's binary and have container manager's mm.
This invites for bugs. Other processes, which already run inside userland,
may somehow take advantage of this.
For example, see section "CVE-2019-5736 Is a Very Very Very Bad
Privilege Escalation to Host Root"
of https://brauner.io/2019/02/12/privileged-containers.html .
So, here I like embryos.

--=20
Askar Safin

