Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6C6606A334
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lKo6Hcca
Received: by kanga.kvack.org (Postfix)
	id 7C8CB6B091B; Wed, 25 Nov 2026 01:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779516B091F; Wed, 25 Nov 2026 01:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640446B0920; Wed, 25 Nov 2026 01:56:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36BFA6B091B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:56:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A80731C4945
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:56:58 +0000 (UTC)
X-FDA: 85472734116.11.25B9CB9
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8BEC5100007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:56:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lKo6Hcca;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795589816;
	b=tMIcHx9wPyKsfuxAamjhpPA24VRUZNpIzWhIsc/qlnO/flaP0PxHuvHZKQZUk6FidPkH0l
	RGH9Yg9u2q1kro17UykzWE8G+fRNJgVQ7DG51FD+kLsFCyHLbuWMqCZAb9kVdSu8eUlmIN
	AANhG2wxA+uQUcmTVunPjfTJNnTVZFE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795589816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
	b=i/USIxswUOL65Ys2nVY01TZoDoApTTz59p6KXavuFaxEL0DOh2T7fcPZLORrxZpLYFUT9K
	YN4x3j80DXHD55oJZiuXOXVaboVfUmxfPPPnoZS3u4YvNu+8BwkQ/+sXFqK9zF0u4lmegz
	bNd4yfv5ohbKS2ingDqjGYjvhtoGXyA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lKo6Hcca;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3adf9b1f5aeso55606021fa.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:56:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795589815; cv=none;
        d=google.com; s=arc-20260327;
        b=D7yPsyMYKRHh66ThwWghihsJn3YpcD7gPsBVIp8tp/OiSpZtxBdBl1ftPwP5v/uR/i
         FUzIKWue27yLNlBl/HpV9YurWmGLEUDCIv91RVc0sISzQl7GsrqFl9zkB+/wr7wIjZaP
         agWt0P5XyCXPFMtBUSGUTMwWIwXaONoEnZ3iD96Q8pfB5vKI/tHXuT62SQyQITdqxvLx
         4WXpiAJBbTeiAmWc8Ce5SHrlN8yCuyIWmC8FtVzY6q7lIeubSSVihL3B4Xep0cxvoPsJ
         JKVYZQx31iT+mhrV226d6Qj0H1d43PsiUiuhj/ll7ZXrG2b7HIIgtakJIZ3/cf0/Q83C
         4yCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
        fh=4yO9URcslabwvWamImnzJjsoVLXcpW8zJ7SGjfVxibk=;
        b=JLRke0lu9DP987s7FS+eFUPHc0u0p5cRb6BasqJgsNESgpxz5Z0zuwxIUtvDhh8Pc5
         5+O81mc1ONOGtLtpFDNMnrhABnIl2QVZEXjYz+6k+oGWFrUBGGyFGDaSScilfMjdOT04
         d0D4owt8L2EUEKBroe3fMvNaQhYIznd6GNJm9zSEjRVoj1SDnf34FTP/df6lgJR9Nh/N
         n0wuJgLIi2OGxI7n3bTEgHGVnb0aQEWUoejh+zuqvvdFt/mdRCNR9c4vLQpMEmx1GDLt
         kmmk/D4TFZLlqSRIIhFbt0XsA54D7bXc9EixlhUhdir50Fv65jFra5qCotIw+peTvwWA
         tj2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795589815; x=1796194615; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
        b=lKo6Hcca2yOAagWIf3dYEwlGEw95eWZtsHtsf63cpCULQuoHZmCXBpnZHXjHNxX3bP
         ARBKDst8/nNcFAU+e/u51aDclKZ7Yzp7bsWHlJoEQccUiMgmPRN/fbk8AyVe404Xi95o
         K3OMW/ziKN+y1qXZF7wEp/lB6Y89xhNmCs/vCYgyx2w5b5+T0x0p7AjYv+/qdMvLn75p
         tFuOGdZUtWG+0bvQg9pwVAX2d5KJEyn9Nqdjin17t4F5ToWg4izrxzCm9wZh9bvGwUUt
         KLaBvC/hD96NXKVbnajg8z4s7anT/bgHKlajQmLHwwwL4pTbUL271kpPkKAOvCnPmw1J
         LALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589815; x=1796194615;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
        b=VmsHlZ41yVgOpnoW2iUqU2rfvP70cjZsbXIu1FCbQGqNAoIDD8wZFHyI195xkgzsxW
         5pVbZU8Y28yP7dTxzh7ThVgjcQHUG3GklNSldOO4bTD3PEc/12c/dkRpm5iuOR0sQoSf
         6utxB55Dpc0LR+dFZgKFA85zJDIx1Ii84CvXEKtfs68But4IbkYSiepN4r1ZvTdEY9GM
         +qegVFwxrZrbQAzxCs6Klyr22MggYy5Cv9TpdJGuf5EQ6HGtiOB+IO5CgMaH3uO/aUPh
         rB7UqGiy1nAAdIS1BuGBeSiTz9eYR1gMqx6SdeSC4f1lP5U2NyRNMgcvV4v1/SvgR492
         yNqw==
X-Forwarded-Encrypted: i=1; AL+hErHazkzsflPWaTOYECb8KNbcC/PwChYk1Sz01QA0uRTMwleH3JHVo3RtLFGqpnhqrKZMQ4cpnEAJAQ==@kvack.org
X-Gm-Message-State: APuU4Z+XDqyD09p2zfB/rp3s/1ITRpJutX1vmcwE5W7aQHQk9grb4tnZ
	+8dixJj2k13f5xODaoLBflmdJnmDWgQ36CPOFAQDOo+h2SAePF0i6Y7AJCBd/bhpQpOoqG6cIhx
	NidOMCTVEM/tLxEQIdzhDL2+yKOBqqyw=
X-Gm-Gg: AZFdTZcVAXlqnfh9g4u7WSpcYOvOfuFE1yffzlxBCBzDjvLvzYNrvfDckOU5xahp8uR
	ejY1o7398cvZMAS1OMYhAS4YbgcnbtJQ316C1Ho5npqX/unHHIRVwi8wnXso6huzGfZZ89MQETa
	bzEvssv1WFPrl3Dwhl9XLN5zBGEg55TJmtpW3EflnNpRRLYFsN5y2g3pBO278jE4u3piTzmgUW9
	i8rMLvoZ7EJ5UuE/pEhD4/Ds9vjS0csd+o9B7cV0NxLV+nM8mLBdhK506bHA1oLD4VwvE4jYhys
	6grhU7VR4CJ0KjbgaL0PtlRwcn181+atIpVxzxYgzWq8EMXQokVb6HmRhqvd2OuSFIf9U/txVOz
	lXLhAVh8rhgcKkITvemnUJnHn1WnVzC9GzCHY
X-Received: by 2002:a05:6512:104f:b0:5bf:ca51:e25d with SMTP id
 2adb3069b0e04-5c1bc85debcmr4552963e87.11.1795589814181; Tue, 24 Nov 2026
 22:56:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com> <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com> <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com>
In-Reply-To: <awZt7P_p-GNZ3A2i@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 24 Nov 2026 22:56:42 -0800
X-Gm-Features: Aa3M54oXzyeaRv6QCCuUq_sp7X_zsNBqLra3JmTQYx5ozeA7YpvDzRVEZ_mU90g
Message-ID: <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: fd6s3p8yr5hqfsb9xjxn1wr5xch44c9c
X-Rspamd-Queue-Id: 8BEC5100007
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795589816-136323
X-HE-Meta: U2FsdGVkX19HkSTTlGThiWXsbzS6NsurBNs+xxxsNeHTV1QLV0WJdZEbvZIY7oARQbXNVvBOgbC4cYyQ3Caco7PvQDx8Apcc6Xx/8fY5q7HukEJCW4rxKWk5bM/xVBZD0xXhHtJQULI7miR/k50AE/kliHl53yk4XjjRq7u17Kk80QRPi6xLWNwtIPj/DwU0hPHLu/0Hve0sMhA4Qc7FdVI7SOesPAVOZTNAhG7vO6ZfkoVmRWUiBR1cplBfw0Oe4ZWm0VgWoV4oGVC5eE8jqjeuatfBZCtExtq4WNEFOQsBXsg7ud31W77GSSprx/zRkzNAE6A0rKcEPmxW3f+rSFerMtOBkGGlC2hza9EwlkiJNN0qFfLaLg/g1ziPJj6KqE4yLw/xR/bscB+hV5afV8HikH/NH7ua5b+NPIH9zcsAbmh+6+ywsmZZytWu5iL77dYDQCFFvng13wyJvQT+Zn1KfzSyZ8DcEe6Pld5S6kVejyH+5UmaNpha6o4ITNzThqni2rwtiJIpi/8yVjwa26X5BKAHjhFpnqk3lyR0WL81jet2ve0Oc5ytbGY/pHEXt18l89WfmrX9OY5Sbvl2kBxkpAPzgk8B/JzUg5ZgJlBanJABxHnrrvqsqxYijhneOx/96nt4S/9N9slSf5dcjJw6IwnmX6uIYtVIHzTVsGEYwM6M4NVT95FAUU29YhMpPeLqbgpte6gySy6hGfT7aMbe9WRbdPU8CE61DfbEGhg05bQ7yTh08GJnQvWQNakMqmyYu6aGm306wr6Vqm244PczOJGyOEv+7RDFbQ0sFd3wGj8rPa5a1gVTogu18k8QjWUc2pTLui/W2JoSilxvbugb/ylsARLWNrz74ooc9Xp3Nn3+yXIHvVFrqvGFfNXE4Zr5NdMFpIB8GApBTK3d70Zs0qdkXP8lJ/kbSSfFnUDMVsIye52ZfKH4xdJDvbQQmYRBWT4jwk2Xtoy/zj9
 6qKpH0dJ
 TD1sVzZofFk7uFg0fR4xSPFwvWfnbbTwV8gqZZN8bQOmwo3pHf2s5Ec/N2Wi0/KoQVskIrHXM6w8gd3CAKEbT575DRQtv7FUXSM5ssum1Iavgv3sD8sEjAC9OseDGQeiQcK+PczItShb9SVC0gIJ6b/nLQE+FYA1zVs3f22GNyG2G/+TwM489gw6Out7DQztpyeT0lbQmX2jslGAqfVW9QdfiaWSuzUsQLNxD+HWFWMsx8jFgjjpqq/rmM2w3Whb7g1P1L1Mw6XpMH6OzZL0O993bc6IZbwBZbof1rD0JSnopRajf1zr8pt1UpZmWgaGgInMouMmgK7/KPr8MrtrHT5TN3zVwQM7/AgwA3RpwCoJDZ6alB5GjnUyxak9fYGQ9oAIxe9KrP5Gto3ZKvsUKxZz4YjsJ1SaQ+GkBtT9nytOOXsKofnFCa13ZUZyK+4l+lY5gq+JhtSD1bSNaMUiFLKstOuj+CaYwFYmshLKhrXznmVtaBY0QaM+hXyfsmeJd+lUwqy+IczE02/TDfcjctedntBwk5js1id94nSWp5JahcVGyOhznH4Vpj2bhPfuAmZxvTDwqo31jU1LOVNd6e6yhLjl3NCDJeiA/YxzgJtUsLH25hkTCxhyhOKuQtPKd0l7fpUGeABpRPU7rSQjqEmEoCH1fECHtjOFpNpdCio+qF3/tg87hSEzKVZ52A4qWP10JzmF0gaRQc+KCd+PTjlLlohimWnhPTzEciNWeNpu2qLk4R48Kni77mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 9:51=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Nov 24, 2026 at 06:10:25PM -0800, Kanchana P. Sridhar wrote:
> > On Tue, Nov 24, 2026 at 4:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > [...]
> > >
> > > I think the real gain comes from making the freeing path faster. What=
 I
> > > am saying is that we should optimize the freeing path rather than
> > > batching stores to get better locality in zsmalloc pages, as this onl=
y
> > > speeds up the freeing path when most data in a batch falls into the s=
ame
> > > size class in zsmalloc, which isn't the case for real data (e.g.
> > > Silesia).
> > >
> > > I am not arguing that usemem results are not valuable, I am arguing t=
hat
> > > there's more to the data than just usemem latency/throughput being
> > > better with the patches.
> > >
> > > The hacks were just a way to test the theory by eliminating zsmalloc
> > > class contention. I am looking into proper optimizations for this pat=
h,
> > > the goal was just to see if optimizing the class lock contention in t=
he
> > > freeing path would achieve the desired result.
> > >
> > [...]
> > > Yes. I tried rerunning usemem on a similar setup to yours, and
> > > aggregating throughput, total sys/wall time, as well as write/free ti=
mes
> > > over 10 runs (write comes from throughput lines, free comes from free=
ing
> > > lines). I did this at the baseline, with patches 1-7, and with patch =
8
> > > on top.
> > >
> > > usemem30 (usemem -w -O -b 5 -s 10 -n 30 10g):
> > >       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (=
KB/s)
> > >       base     2355.6 +- 25.3       94.24    55.62    26.82    212,23=
9
> > >       p1-7     2366.7 +- 22.9       94.65    55.91    26.90    211,10=
8
> > >       p1-8     2197.0 +- 37.9       89.65    55.48    21.66    212,85=
3
> > >                (-6.73% vs base,
> > >                 -7.17% vs p1-7)
> > >
> > > AFAICT the speed up happens on the freeing side, not the writing side=
,
> > > so it's not really zswap stores getting faster. In the freeing phase
> > > (66%-100% of the run), ~90-92% of cycles are spinning in zs_free(), a=
nd
> > > total cycles drop from ~1.64T to ~1.30T (-21%).
> >
> > Can you please clarify what "write_s" and "free_s" refer to, and how
> > are they measured? If you are referring to the gettimeofday() reported
> > timing done in user-space by usemem, these times measure child
> > processes' fork, do_unit, join, etc. : IOW, not a reliable indicator
> > of zswap_store() performance.
>
> write_s and free_s are from usemem's output.
>
> Without your patches, here's the raw data I got:
>
>     12079595520 bytes / 36047550 usecs =3D 327247 KB/s
>     12079595520 bytes / 36221811 usecs =3D 325673 KB/s
>     12079595520 bytes / 36539948 usecs =3D 322837 KB/s
>     12079595520 bytes / 36554520 usecs =3D 322709 KB/s
>     12079595520 bytes / 36630659 usecs =3D 322038 KB/s
>     12079595520 bytes / 36705879 usecs =3D 321378 KB/s
>     12079595520 bytes / 36795396 usecs =3D 320596 KB/s
>     12079595520 bytes / 36844030 usecs =3D 320173 KB/s
>     12079595520 bytes / 36936923 usecs =3D 319368 KB/s
>     12079595520 bytes / 36989604 usecs =3D 318913 KB/s
>     12079595520 bytes / 37063935 usecs =3D 318273 KB/s
>     12079595520 bytes / 37065296 usecs =3D 318262 KB/s
>     12079595520 bytes / 37158608 usecs =3D 317462 KB/s
>     12079595520 bytes / 37188329 usecs =3D 317209 KB/s
>     12079595520 bytes / 37176041 usecs =3D 317314 KB/s
>     12079595520 bytes / 37222619 usecs =3D 316916 KB/s
>     12079595520 bytes / 37277605 usecs =3D 316449 KB/s
>     12079595520 bytes / 37382137 usecs =3D 315564 KB/s
>     12079595520 bytes / 37485910 usecs =3D 314691 KB/s
>     12079595520 bytes / 37506482 usecs =3D 314518 KB/s
>     12079595520 bytes / 37582493 usecs =3D 313882 KB/s
>     12079595520 bytes / 37654025 usecs =3D 313286 KB/s
>     12079595520 bytes / 37804401 usecs =3D 312039 KB/s
>     12079595520 bytes / 37872179 usecs =3D 311481 KB/s
>     12079595520 bytes / 38139663 usecs =3D 309296 KB/s
>     12079595520 bytes / 38148594 usecs =3D 309224 KB/s
>     12079595520 bytes / 38149377 usecs =3D 309218 KB/s
>     12079595520 bytes / 38207236 usecs =3D 308749 KB/s
>     12079595520 bytes / 38442241 usecs =3D 306862 KB/s
>     12079595520 bytes / 38445731 usecs =3D 306834 KB/s
>     11147897 usecs to free memory
>     16392260 usecs to free memory
>     22879204 usecs to free memory
>     23382635 usecs to free memory
>     23518192 usecs to free memory
>     24023442 usecs to free memory
>     24176849 usecs to free memory
>     24461635 usecs to free memory
>     24232157 usecs to free memory
>     24571926 usecs to free memory
>     24498438 usecs to free memory
>     24500253 usecs to free memory
>     24197624 usecs to free memory
>     24424616 usecs to free memory
>     24128275 usecs to free memory
>     24646461 usecs to free memory
>     24390349 usecs to free memory
>     24522151 usecs to free memory
>     24563204 usecs to free memory
>     24270881 usecs to free memory
>     24232957 usecs to free memory
>     23980870 usecs to free memory
>     24180573 usecs to free memory
>     24068183 usecs to free memory
>     23758087 usecs to free memory
>     23799366 usecs to free memory
>     23512788 usecs to free memory
>     23749313 usecs to free memory
>     23829669 usecs to free memory
>     23532371 usecs to free memory
>
> write_s would be calculated averaging the time in the ".. bytes / ..
> usecs" lines, and free_s by averaging the time from the ".. usecs to free
> memory" lines.
>
> In this run:
> write_s =3D 37.31 s
> free_s =3D 23.39 s
>
> With your patches, I got:
> write_s =3D 37.03 s
> free_s =3D 18.86 s

I am not sure how useful it is to apply user-space gettimeofday()
results that time many higher level C code API, as an indicator of
zswap_store() performance.

>
> So most of the improvement is in the freeing time.
>
> > Also, there are no calls to zs_free() from zswap_compress() and
> > zswap_update_entries(), so, it is not clear why "free_s" reduces from
> > patch 7 (26.90s) to patch 8 (21.66s), if what you are saying (as I
> > understand it), is zs_free() results in the gains.
> [..]
> > Is this perf run at the workload level? Can you also share the
> > zswap_store() perf breakdown? I don't see any zswap_store() callees
> > here..
>
> Here are perf reports collected with:
>
>     perf report --stdio --children --sort sym --percentage absolute \
>         --symbol-filter=3Dzswap_ -g graph,1,caller,function,period
>
> Baseline:
>
> # Total Lost Samples: 0
> # Samples: 923K of event 'cpu/cycles/P'
> # Event count (approx.): 5783481013054
> #
> # Children      Self  Symbol
> # ........  ........  ..................................................
> #
> 52.06%     0.26%  [.] zswap_store
>         |
>          --2995798359281--zswap_store
>                    |
>                    |--2724723679947--zstd_compress
>                    |          |--2639614263267--ZSTD_compress2
>                    |          ...
>                    |           --66562348127--ZSTD_initStaticCCtx
>                    |
>                     --217649410880--zs_store
>                               |
>                                --126618473697--__pv_queued_spin_lock_slow=
path
> [...]
> 40.26%     0.01%  [.] zswap_invalidate
>         |
>          --2327775248737--zswap_invalidate
>                    |
>                     --2322317048724--zswap_entry_free
>                               |
>                                --2233301817626--zs_free
>                                          |
>                                           --2178824329486--__pv_queued_sp=
in_lock_slowpath
>
> With the patches:
>
> # Total Lost Samples: 0
> # Samples: 863K of event 'cpu/cycles/P'
> # Event count (approx.): 5420333292095
> #
> # Children      Self  Symbol
> # ........  ........  ..................................................
> #
> 55.49%     0.17%  [.] zswap_store
>         |
>          --2998025641673--zswap_store
>                    |
>                    |--2724254313681--crypto_acomp_compress
>                    |          |
>                    |           --2718237550253--zstd_compress
>                    |                     |--2634756568606--ZSTD_compress2
>                    |                     ...
>                    |                      --62825503508--ZSTD_initStaticC=
Ctx
>                    |
>                     --206719808793--zs_store
>                               |
>                                --142932151337--__pv_queued_spin_lock_slow=
path
> [...]
> 36.25%     0.01%  [.] zswap_invalidate
>         |
>          --1964269438386--zswap_invalidate
>                    |
>                     --1959142544382--zswap_entry_free
>                               |
>                                --1874286346020--zs_free
>                                          |
>                                           --1828012531673--__pv_queued_sp=
in_lock_slowpath
>
>
> You can see that the cycles spent on zswap_store() are almost the same,
> and the cycle reduction happens in zswap_invalidate().

The cycles spent in zswap_store() should be normalized to the # of
zswpout events that these CPU cycles represent, for this to be a
reliable measure of latency improvement. There could be an increase in
reclaimed folios for any number of reasons, all of which are not
necessarily due to performance-improvement/degradation of
zswap_store() itself. IOW, more work for less latency per unit of work
is not always indicative of a performance degradation in this case.

A realistic scenario would be that with zswap_store() becoming more
efficient, the 30 allocating threads cause more memory.high breaches,
that causes more zswpout..
This would cause more CPU cycles in zswap_store(), but the fact
remains that zswap_store() efficiency has improved due to batching.

>
> > > Adding some instrumentation I figured out that ~all memory from useme=
m
> > > ends up in the same size class, hence the better zspage locality from
> > > the batching in patch 8.
> >
> > What does this have to do with batching? All usemem memory compresses
> > to the same zsmalloc size class in the baseline too. Can you elaborate
> > what you mean by "better zspage locality from the batching in patch
> > 8"?
>
> With compression batching, pages in a folio call zs_store() in a row, so
> they have a higher chance of landing in the same zspage compared to the
> baseline.
>
> In the baseline, each page's zs_store() is separated by ZSTD
> compression, during which the other 29 processes fill up the current
> zspage. With the patches (especially patch 8), 4 pages are compressed
> first and then stored via zs_store() back-to-back, so they are much more
> likely to land in the same zspage.
>
> I used an LLM-generated bpftrace script to map each folio to the zspage
> its pages end up on (~450 folios sampled), and aggregate the results:
>
>                                          base           patched
> Distinct zspages per 512-page folio:
> mean +- sd                               510.6+-2.8     321.8+-24.0
> median (p10 - p90)                       511 (509-512)  322 (302-341)
> min - max                                483 - 512      215 - 407
> Avg pages of same folio per zspage         1.00         1.59
> Consecutive pages hitting same zspage      0.27%        36.16%
> (same-zspage adjacent pairs / 231,483)   (618)          (83,709)
> Contiguous same-zspage run lengths:
> len =3D 1                                  99.7%          62.8%
> len =3D 2                                   0.3%          22.1%
> len =3D 3                                   0.0%          10.9%
> len =3D 4                                   0.0%          4.2%
>
> This causes zs_free() to run faster (i.e. shorter lock critical section)
> as the zspage (and its metadata) is hot in the cache during freeing.

All these seem to be good kernel improvements caused by zswap store &
compress batching. I don't see an issue here.

>
> >
> > >
> > > Here's the bpftrace data I collected, I don't see a material change w=
hen
> > > probing zswap_store():
> > >
> > >     zswap_store() (2048kB PMD folios, 178.9k calls):
> > >       metric         base           p1-8           delta
> > >       p50            10.76 ms       10.85 ms       +0.87%
> > >       p95            11.34 ms       11.40 ms       +0.59%
> > >       p99            12.15 ms       12.05 ms       -0.82%
> > >       avg            10.80 ms       10.84 ms       +0.40%
> > >
> > >
> > > Also if I run your modified usemem with Silesia like your previous
> > > versions, the improvement goes away (because data no longer all goes =
in
> > > the same zsmalloc class):
> > >
> > >     usemem30 + Silesia (usemem -w --read-silesia -O -b 5 -s 10 -n 30 =
2560m,
> > >     memory.high=3D38G):
> > >       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (=
KB/s)
> > >       base     1779.0 +- 8.5        72.84    55.34    6.92     53,290
> > >       p1-7     1775.7 +- 7.3        72.81    55.29    6.86     53,337
> > >       p1-8     1771.8 +- 7.8        72.58    55.19    6.83     53,435
> > >                (-0.40% vs base,
> > >                 -0.22% vs p1-7)
> >
> > Is this with PMD mTHP? Also, we would get a better idea of concurrency
> > by increasing the memory allocation duration by allocating 10g per
> > process, for 30 processes under memory.high=3D150G. 2g gives much fewer
> > samples to be helpful, imo.
>
> Yes, with PMD mTHP.
>
> 2560m with memory.high=3D38G was chosen purely to stay under the default
> max_pool_percent=3D20 (38G on a 190G host) with zero pool-limit hits or
> disk swapout, since Silesia compresses ~2.5-3x instead of ~7x for
> unmodified usemem. Because ZSTD on Silesia is heavier per page, the
> write duration is actually the same as 10g unmodified usemem with ~31M
> zswpout per run.
>
> >
> > [...]
> > > I am not saying there is no performance improvement, I am saying the
> > > performance improvement is a side effect of locality in zsmalloc, not
> > > faster stores, and that it doesn't reproduce on real data.
> >
> > I don't see the connection between batching and "locality in
> > zspage/zsmalloc" since compressed size is a net wash between baseline
> > and my patch series. Are we drawing the right conclusions?
>
> See above.
>
> >
> > > If we want to address lock contention in zsmalloc freeing we should a=
ddress it as
> > > such, not by batching compression.
> >
> > Lock contention in zsmalloc seems like an independent optimization
> > that is good to solve. What I don't see is a way of explaining the
> > gains in this series based on zs_free() lock contention, and hence
> > drawing a questionable conclusion that this series does not optimize
> > zswap_store(), and further that batch compression is not attributing
> > to the gains. I have provided ~10 reasons as to why the combined
> > zswap_store_pages() batching and zswap_compress() batching improves
> > zswap_store() performance in [2].
>
> See above. I think the performance improvement is a side effect of
> calling zs_store() in rapid succession for pages in the same folio, and
> more pages in the same folio ending up in the same zspage. As I
> previously mentioned, this happens because all pages in usemem end up in
> the same size class.
>
> The right thing to do would be optimize the zs_free() path. I am looking
> into batching zswap entries freeing, which I believe is the right path
> to optimize given those results.

If I can restate what you are suggesting, and please correct me if I am wro=
ng:

1) [Data needed]: Normalized zswap_store() CPU cycles to # of zswpout
vmstat events in baseline and patched.

2) [Data needed]:  Normalized zs_free() CPU cycles to # of calls to zs_free=
().

3) If (2) confirms that zs_free() has become faster, then that is a
beneficial side effect of batching, per your analysis above.

4) Why are you suggesting that *instead* of acknowledging the
beneficial side-effects of zswap store/compress batching, you would
want to find another way to improve zs_free() latency by batching of
zswap entries freeing? I would imagine both need to happen. The zspage
locality side-effect isn't a contra-indicator to zswap compress
batching.

I will run some experiments to quantify zswap_store() improvements
better, with compress batching.

