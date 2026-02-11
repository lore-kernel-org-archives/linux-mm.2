Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F62ECD6CD
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 17:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060F46B0005; Wed, 11 Feb 2026 12:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E7A6B0089; Wed, 11 Feb 2026 12:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E323D6B008A; Wed, 11 Feb 2026 12:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D41976B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:24:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E1FB1A049C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:24:31 +0000 (UTC)
X-FDA: 84432849942.19.779D7F2
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 796E0140006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:24:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hHq7jjJl;
	spf=pass (imf23.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770830669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkJlBAcI1hbVLg//alG/mLpM3uEJ/fWZ3GRfLmdUlOQ=;
	b=NlOtGwWreUb8H2YYAhV0T1W+9h9t33X7n93La2mcm8o6WN1xO1XgviZFUtNVLSDswk7Htz
	AHREfhG9wEKf2/oAxRMF+KNh/1qIxYRy4p8R+m2lcHEv1srQXX2hjIVrxfEVdJ2HY8yH4f
	0CV6AL4Nxhs05We68jD6TLQAl7RWgLc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hHq7jjJl;
	spf=pass (imf23.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770830669; a=rsa-sha256;
	cv=pass;
	b=7T4mxzPHpQMxtCJmdpfEC3tCXCEeBaoWBLs5uTBAQW9tEgj7yom9cNllnyb7JJ+MnW6NjH
	HcyghKbQGYO3VR6Yz3Qr7ew0FBXL51dSSSK+98DudKl72NbKeDW+va5YLkgahMU9MOXxeQ
	lH9iE3+bmmVNs643K0fCtO3nGoW15uU=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c6de0364915so2627343a12.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:24:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770830668; cv=none;
        d=google.com; s=arc-20240605;
        b=ldbpqZ6424qVwZAFRZkMhxOhYOO1QKhOH3D88uEvQYBHiYxMwVvUv5RgefDDvCVhNx
         qihh9hkDBmbx42CW9vM5YulHEAWT3kcIRk5l38HPFegwz5KvgvYpQmgbEJgNxxHswK7G
         G+7S5SdCk0ct7L7sDw7VLVWqDXnWZpMC7IihO8YM3Xjzcz6n310C+CZyJ3RhHPpkyy6Q
         O/dJYj01c3MvWcc7cDcT2bZ+lxQN+4DX1cuZLOOLKw+v2N4pxipHjDkhMBOJhjZWd7Uh
         SwLetnsCzL2OL9PzKLTgWx+U25WqWrpyovjI1PV/BzPQF/L3d3lKBolLvvIlDBBk42nj
         cfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PkJlBAcI1hbVLg//alG/mLpM3uEJ/fWZ3GRfLmdUlOQ=;
        fh=XINqDMI4fZE0WrOJrsQuamjzSTixke8V79siERhee/Y=;
        b=ebdfDTJIqeS0AqPjeD99NHbgARnXLCTZRUfheqXuhgyHpwmvL8zB91ll+vrDCk5v1E
         QpA6Vsm/KltK6oJuEP4TzaiHsbTv6QGTfTJnastHzyrOYhQkH3PGSVNmWubpo6zdlbLX
         2m2X/9iEW8mrIHimw4gXlgsA51q1qbJ+T2tdNNxdtB3gU601Mpbya7LjjOvDAd/cR1RW
         axspWuRgOJ2muOpWl333Ta9rdwqHKgoVqBe8b8weNNcVEDOgGnGebnAtvHxaLJIVoBkb
         KSJPlYWtagByYMjyZAsI6PpTEXQcRVRFxv9qbFY5r6NiskN0yVCKYyIeQazVLqU3TjpT
         YlrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770830668; x=1771435468; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkJlBAcI1hbVLg//alG/mLpM3uEJ/fWZ3GRfLmdUlOQ=;
        b=hHq7jjJlRl92MUuo51dx/2aBDctUJZfsFfWKGhovZJbCnX6JtmLAc1obOHy3byR6ab
         gZMiBAIdbEu+WsVtPT3pNpdJ3ybcpZPl+h5euGrCTat7h7Jx7fkdl8GnjQMUtu+l405x
         EKvVPUoXBbHE8HANKKl008hqehwDgAJGWLmwhuTA+rpYWQo+ftuYh71jAdIT0wJlLy9d
         XudWB66SxqbjtxuEt2vwU/IegC35jfcyHWeEKxvuxwbNw6xbA/5MGVEqtEDy1mWkEYA2
         kzm7ZoFGMlFS2agMTTrcSl73yvqeUsxMA2n85EIKU3HgXcQv1lCcH4jep5U/0ipvT/OK
         fXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770830668; x=1771435468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PkJlBAcI1hbVLg//alG/mLpM3uEJ/fWZ3GRfLmdUlOQ=;
        b=ZYwpeDB1pxonpVDjwC8DRZXe+iUWUDD40FnboUQ0aTdKS31F5i0qLkGtEdkYYu6IgN
         uH3mhnMSiP2K5Z8KMozeDLb0Di3Vc+rP+b2766/4fvdIELBlV86vghXI+gYKEXQRdFSv
         qvpwozAXjecAmCfFCBOX/3SaYEvdNlNRF0BO+Pl0hkN1ICOv9f2zyYQLZd5pSGlYHmDJ
         +W3X8BLEb+JkxaDmuW9/LONyVcQ//KesgYL6cx8tobn9V9UyRnOcNrO45XW4umPH2ynx
         hR9dx7JuS4p9HY2fuakM5qWtaEBReEzHHtxivzNaoeE1aOBipDdR6ORYbOCaxsnNvxJP
         FqgA==
X-Forwarded-Encrypted: i=1; AJvYcCUrvHH/W1RXfaSoQjCd9iZc96G1dWppp9EV8KWGTa6HlFjXkqmypKzP94OzKwKXWHIqZ58LEoGOAw==@kvack.org
X-Gm-Message-State: AOJu0YyU0V9neGz4Xmb0GS3F5mz/Tgd5z28mRKZVx36UfW3pxFSli2y1
	OOO8ogSsD3VU2NV4VXMCYvLmlreWhyORsNAIcYWQMUZNYim8M0hLIXjmHKKjJFxrnVhHgEg9xM4
	S0cHm6i7fqjtjY1zy1vwkECw5KtEgtpn+EK2+
X-Gm-Gg: AZuq6aLjqWgngEsN3ueXlkglF5zxEGSYwT6bAzpOWHtl1pm7jsfMi+UdpMlpVpr1a57
	2kxAWyT8BSQ/2fzOQVq4VDCbBJGyh8WgHDgP/9o3UKiDXduFGioWQjlUJ+6rtx0+kpvbHijbJ0n
	xcEuw77orll1ivbtqoOosT5qkuaNnhoehMN4tbV3DZFc1NxMywa1UwvR+V5fMBj9EpL+rX+KxLD
	9MJp3fZt2kmffKrlpqsPfUjNwrZ3/eUH9YRjIdge1ZsBGOHbVVkf4Q+IwUodlMk9lj4m3RfcLuN
	mw5A2ZCu0ZSW3YP7FpYLdBingnN3ZRu+uA==
X-Received: by 2002:a17:90b:2d8c:b0:354:a05d:9dc2 with SMTP id
 98e67ed59e1d1-3568f300d31mr166515a91.9.1770830668125; Wed, 11 Feb 2026
 09:24:28 -0800 (PST)
MIME-Version: 1.0
References: <20260129215340.3742283-1-andrii@kernel.org> <87qzqsa1br.ffs@tglx>
 <CAEf4BzZHktcrxO0_PnMer-oEsAm++R4VZKj-gCmft-mVi58P8g@mail.gmail.com>
 <87ikc49unc.ffs@tglx> <20260211115825.MLF4L4Jq@linutronix.de>
In-Reply-To: <20260211115825.MLF4L4Jq@linutronix.de>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 11 Feb 2026 09:24:15 -0800
X-Gm-Features: AZwV_QgFyUjXcS1gGGgxoc2k8MO_QzouXEXMD7Ys2j6dTV10vd1FV26Sc5dH1cA
Message-ID: <CAEf4BzZ__PYqiYEBxJQhAaV8fyNYSmDB5rKDGsvmpXG-Vu4eMQ@mail.gmail.com>
Subject: Re: [PATCH] procfs: Prevent double mmput() in do_procmap_query()
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, 
	surenb@google.com, shakeel.butt@linux.dev, 
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com, 
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q9szgfz1oxdmskm4g3is1dr33up5o854
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 796E0140006
X-HE-Tag: 1770830669-909896
X-HE-Meta: U2FsdGVkX1+7JDZO9us7FzBnRMih+WFsBZeQOBJzgYiPaj82JB/wd/H9APMjiwcHFqJ7UEEdwNLMCdPlclSfs4BDyAYhzr3Cc16QV2HOAqO6jxSZHmwNCB4yatP0cyEilsXM/7sOkNOmV1mzhl/mAeOaQOnadigvEUI8mJtSKRolcf+DICqNCuxAupveaHzvjfjZDCGZc6nW4hn/4lJOqCZwrkoy9QsniKaKJ/0xpeVVGFsJ3x+6sA6JLKY5v3jJN0B8+gY6xy8weSff9xNd+ZGodYJAlXAKKK/+R4w3bHQ69LWkqybS1yz6YgfyQ1PYc4DQJeKCNk3VLbHV758pWWVVgrFyIyAhpGw2TVee1p+0fzGeqYvWNX7ZwnTFCkvIfIB8Y+klhVBsXbCVY2FYjU3YdFM+KDcL5mVekhtF2MK9gOnLT3h/DTnALCyYWJ+lFR+iZksbj7R3EcaevIqQ6+n2Jc9USCTTuJhjTOzPqbwpSSACXQkfQzAHDoFQh+HBIxZdih5zW/MQV+EPwnWxMjrYl3eIm9VTj5anuhirA6CBrwZi9g9vZHi1J8mxmooZgf2SzDGCXc3uOYWzgKVvnufOYltCFN2oa02eANV2Hb5XCeBOxWBPYk2MUNAnRv2kIFAMlO9gv311H4ASdaNPgxON/aZjetmmfcvRWEOHodojuoZ1EcNYy+mqaqlaoMvbpf02LGt5mgoBPELIwVsFx7Ll0fYDIgWSqDtP2g0CP80fxW1edRB0epO5HhLhutR++x6x0k6YC7gb2xAmXfDRw0vWGELr7i7V4UlSo1waa00a7rREICwsddZs6Mg/qNOiW7C+gNar2lOC6GrIDsaINXrRFf1yAEuOfemkq7eWkSp5J2DC6iwkXr/fv36cgNLAkM6Ln262oEn55mW+MoNAbTYUOpBZRu5Un/Gio5TNLkDrNAarCMS8uMqhYtjMLPVvFNj6bLzSIz4fl9ewMv8
 qwzGxVDK
 yuKzT+k+a82LoHcKRAFkp6XGLrejZSggxFDcXcRvNVJUfpUEilvTwMSfXrWU4VHlo32jTxJOnS3RAjOsxZQrxGaN6j63BTeFpuA4RMxHm9d/TrSDJR3AYX6RifewjQdENDdaiosHKzsUEZTPfxFzOZbBBrcjMXRHpA1TGMyoYFW7SCDzrpaa5Hq0PewZNMCaNrx9PZVOFpV0mbJMRGlL4MlAA+Um9AUh/aVltzhGVVn7q399x5EezPcF3aN5Cbxq/moXVcj7FgD8LxpwcFTJQa0HF5vPo/ge82uMYtpeqEDPh+EnuLrJrIhYGrUxPQOne+R+k22PN6XKPan61ye1T7QE8bz23RU/L74JPF90FqNg74Qnxpoz4z5MgAZmtKKj/8nxX6DM13dbZ2vCXjiTeCH/gBUPFvwBDGGP9ccP5ULsK09pfxqg5FnLTlsR/AzkeUpqiDWwRPKJ/KwuGfNP4aFJJiwSeSmWlqzMPIUVEzmBmkFZl77w/pc5flUScVG2CkLiSHqfQjeWlGLRljYPzpQjBD1pmOKzGjpw0B+Yl4QZimq9/FCVRUoGbBKddW/BH2cAM4chtxZCvL/NUSgjraDR9fKyrZJVTDUm5ccK05+ESc3d0FS199n21Pz3M0feQngLGESVVkJ/I7Op45F1b08I9+I0okVt5cDPnuNidlLCTjtA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 3:58=E2=80=AFAM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2026-02-10 22:05:27 [+0100], Thomas Gleixner wrote:
> > A recent fix moved the build ID evaluation past the mmput() of the succ=
ess
> > path but kept the error goto unchanged, which ends up in doing another
> > quert_vma_teardown() and another mmput().
> >
> > Change the goto so it jumps past the mmput() and only puts the file and
> > the buffer.
> >
> > Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA=
 lock")
> > Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
> > Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> > Closes: https://lore.kernel.org/698aaf3c.050a0220.3b3015.0088.GAE@googl=
e.com/T/#u
>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>

We raced with Thomas sending the same fix, I see that my patch was
staged by Andrew already in [0], just FYI

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/=
patches/procfs-fix-possible-double-mmput-in-do_procmap_query.patch

> Sebastian

