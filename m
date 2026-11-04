Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9636086612
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VWdz3awu
Received: by kanga.kvack.org (Postfix)
	id 0A9076B05B4; Wed,  4 Nov 2026 16:55:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080BF6B05B5; Wed,  4 Nov 2026 16:55:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2506B05B6; Wed,  4 Nov 2026 16:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC27D6B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:55:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27B4B80872
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:55:04 +0000 (UTC)
X-FDA: 85398792528.29.F94F43C
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32DE7A0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:55:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VWdz3awu;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793829302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWO5ZRtUlD3MouKRps5rUrYVqEwdz1juVsOJUvMD5qg=;
	b=fkW54le07mEHg7MlSWnCpUn7nq0fbKSKdoo5Vyq+ir1YKEoe1Kxfx8tnV1pcYb1U7wkC9P
	EdmBtjLXmgHmZrVG6kW0DT7KvU/grlwsFfyu2t9E0k337ZCOblMuxpEztAGJt7NK9doIA8
	Ngb0cPfq71eO95+uiSTc4MPSck/2vd8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VWdz3awu;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793829302;
	b=XsRUZKzoXH8SDi8a8mLWIc43bSKCk4fu6VodSUXPJEuIrBurbgtKWgn0elPjnPbdH25t/Y
	weUhRHuqcjhl4H9ouDSuhxSxZjZzcGj2F33MSvdav+IBB8amJIdEb++e8A3NGq0d7J2Y7D
	KlCesUpybHavGuTdHv5TPphSVLJZ71s=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so10753815e9.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:55:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793829300; cv=none;
        d=google.com; s=arc-20260327;
        b=GoYSuzbtV634nKXQZ+6pS5LEGeYWwn8IEYRd5lqf+pdlpnoUO3QS+5ACJTTvJm+Ntb
         8VqHcanHSoNt2BSbHvAmL18jDVMa3h1gNNA3FZySr3kNjyWI63IdaC33ePEBWcNNocXN
         rCZIDfC3km5n1q5YmZGsmJ7BvOgbZTwIGtikKsWwsCi+WMTJLZlUKVNKmpIEmY4an9DZ
         ott0I0ZbO49pk6TI/Dar4a6JoZwxzLQGhCZ93ct1Gl2QSJOLy3KoHUqheHHzAHUys8iC
         eZGLUAs3CA6rAFoD4rRicd1yukz6c+bSoi6V6Uoi8T5m5SSrrMuIyP4HHpFUTNpoLziy
         5V6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bWO5ZRtUlD3MouKRps5rUrYVqEwdz1juVsOJUvMD5qg=;
        fh=WrIS1zdy9LQ4SPpFH0Qe4zr8It6Qx3lFnsLHUFNoDqY=;
        b=X9DuDw1VsvNZ6HznVAkI3PD+gf3q10b7drz35lh3hLMDCEyE1rKJRbBDPAoC/hk2ov
         Bh840qmpVXL+DjTUX/wJdjwpHOQXeTRUvcxo/Ucu0wgEAu3dzz5sKko9ccUoDElrYkN5
         Nlc4J6HaDyWUyFMGn17nul57YZdgoVEesXmwdNS8LnDcDvEOcl+TrX3ZbcIpVuIPjAsI
         CT11JpDv+RVSTuYyUbLNDEqzXuCsERWIMg2I0QE/nclRRDOlZCyc4BE+J6eIKrm1X90c
         kI4M3rPcTfGJXcmIbZpxd72vhIhHC+jtGvifakBDmEz3Yf+AHjknZm0j5EqVKHLKSIYs
         MmbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793829300; x=1794434100; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bWO5ZRtUlD3MouKRps5rUrYVqEwdz1juVsOJUvMD5qg=;
        b=VWdz3awu0vayf8kGXqUUDk6wX8WuPpHgGx2pBLEw+xwgRMeFeDHVnSCT71v49EXyWJ
         m9L1uPDXtTTX5bGASVO4znO7Q/pATRa5ckx3cEZbGYzEPdTaoEK3ee3XCrWYkNuMbe+1
         g16vzr+lf08+O0qIJ7Q1xWE/aEYWNIxuNRPyFsx47FU9Qp0qQF/flJqKkS3ow95Rbxpo
         PDX73MgApEKBLerRua3qAaK/0cu/XoFS225IPjSeMA+U7asDnXt+9/LEu3GwEUpmyvys
         zy0L8bfHZEZzJtaeNV87TemmQ0fcY4sgQ+UB1F+GYc/jJTW6LU2XhSaSlUGiF7b82VTW
         FyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793829300; x=1794434100;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bWO5ZRtUlD3MouKRps5rUrYVqEwdz1juVsOJUvMD5qg=;
        b=NyFwRqywVV4J253y/e1MzC1uXJLbajnO6u02rMYIRHt3U5IE8U3742MP17gYtxFwRE
         7GfxTa9rhke3KI5idL6Yl78xtl+5978rH0BEhd4uMJ66/geNFN5CII5kwwecgnJ7yTMt
         As/GBPVOpPGuWbue87sF6iFu6H3xQwllim5Xy65aJQpbZN+LfwrifWRLe3dca/DjAzyX
         iFwzUyaHk55k/2YabLUkLXPXzmy0F2V+uhqR+IOnawyPaZSMKHLW0jju+50jJH6TjFVz
         tA+o1dr/nR4pTSAJZ7AvM9Wdq1gJoVm6DFD/VSxU+zRbTl/23HizfiBpZI4AnvN0BoD5
         hDNA==
X-Forwarded-Encrypted: i=1; AKwUvBxaHFMzvrj+9vBIOF9YxTwF7QK8vIx6t6LtQZBQ/nxau/C+WuVSAkeAyN6nyR/UEMPbw62rnTrH6w==@kvack.org
X-Gm-Message-State: APuU4Z9BEMhmSAttGQGQyraKSWlf/qB5Lkw8oXYLhojxDl+UarguX78d
	Gz8cS5lPUSDpdKqavXqopvQK3DgIK2kN7RxLBhfdYaIRXgn19eDu7P1gqQAlkKsr2neanqlewzE
	lMw+UQ4aI+1GkibFZzFtglWGZBOcgrCk=
X-Gm-Gg: AYBFou1/jAxjkbFRMkaCmprP4+uWA9IFmMQyW1LwHZj3JNDFnNRIz1IsKNsCaMmvmzp
	PCQPWQ+0aTHv90KqzY3J2oDbJlHu8BVJtPJ3Q8H1p1yBIIJNgjT210f4diHSeU9MDnWY6Dj5YOV
	7oY2EA5flNqyyONyvXRWRVCkTZka/s4L8M0zvV1S8D3apjYzjG7hek9rZrEJ2M4Ov2JpZSuCQLd
	CbdCUQRYJq90ztD1c2JxxSCTi5ETs/nETc3ziCkZ4B/g0c2qandbvN4+nH+/sdc6+I7ITNZXIsd
	KwbVz6uo71i/CP5nBwZj2wD8nqqF9W23WEXMrIsD4otfqRO2lYi0t/EFxHwmqh+T8Pm2UUvony+
	nB5R7lcgZ250x53j6IV4YrD6dOOLVlkTSOYOgxlcWpzJNEXU2u3pX8HJppU6gvtEMhRT4SzTSBq
	JxCv0mvSbwbFgFpJoa7w9hQa5jxU98LcWWVuNu/d8snxDXsqcDXUo3
X-Received: by 2002:a05:600c:6211:b0:4a1:80d8:aed5 with SMTP id
 5b1f17b1804b1-4ac17191046mr398211165e9.6.1793829300386; Wed, 04 Nov 2026
 13:55:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com> <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
In-Reply-To: <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 14:54:49 -0700
X-Gm-Features: AclHuK-pahY2vIB1KG9bF6T0DUY3H16HDwNT-kCctAD9vYuVFu-gHVRP9D3bBro
Message-ID: <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Chris Wiseman <chriswiseman@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32DE7A0002
X-Stat-Signature: nbh3wf8mfkjatcdcwj9sstr8n6qsopxs
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793829301-190520
X-HE-Meta: U2FsdGVkX18xIJqqHzlZPwdsn64EPftJ9NR8BLBelQGvbMdTLfOfaf1OQQKVnZ0qw9ZCNEte7ulIq2mve08W3hckgygPVPKvo7eN/Bf/YO1pdeLF2hocM9UyoJDadNTNUFOnfnvNXz3qRmfKBdXIsCTeCCeDl3xzYIO6Ga8TXuA97O6d46lHsyP3AkJJRBQcso/M+MYeQg9S3ucTEHzD6kONXWCVFzWQ5I3zYNBhau/HEF+cRgL7wU6oqfUIohDNPzbyKLgfa62ApCVWZlExp68264xhDkzWmZaPP9rVtrDFcjTfKhL6c2P5M+daQiXxbVL/+GLxwHtiGeYBecxMSTO2yaa9KEDx+dD7apQJmGaYNHeB54Bu6mNdvUV5DLjH7hvpwfP1h2IAK1eTEymTSyVQ3x/dbJ7gtTNvDY2FjgR0qqNTrf14WGGRCEajWIQiKLFmMBlKYYlncqqsD5+SNZHbnMIWPNFs5nm9/k//414tiE7sJY3qsam+o5PVjEqadpezwC4otXePEuTHl8aBwWWUk8cuZ1KTC/R3Zcq45OjKOxNcHG2AsYnThF2fJK9OdIUzBxNI0kAIzGkVLLTxgYHM/bnX4/H9/hLCdsggTlGIXgGxRkmJ4/0Oy6VR3ZbyfRRjfH70f4jd5GOZ9uvxKTBtkVye2ktltPvjYXuyLp4ISYEsNN7txZDw9YapqISE855LR8p3SYsnJp7CZaJ/uMp2xgtMIc12ec3Sf6q1d5ltG3bEE2uFpRekco0lq9FShsLc5qgqXxb3u9BibXYlg3ZMY9FhWfMLSkFHAZgOX6E1z7PwfNFlHkAi+b9ohtei7HRECLAV/4acTp+iGTTMzt7EOt4W3tUgZUcLi3ABKbDWszukkHFyQJOtLKdhlFoLU53iSto9TMt63JhuiMI686vzCgcxtGVKZiKEFQwBeOULp2So8ej0FQulv36oaN3gdUOxQUHjCLo2EHwxqb2
 CKAuUrjZ
 VW9s48zKOarZ/5EzckG2R5J/VuvdpJcGP7wdfE9nS3dS/gkEC6uR/qrI9k4BYknJSPhCioW4FlYV+C83mg/W78HGhnZQU6LCISzZEFV5/gftyewpZMWJhgLhbL7NS7cYxe+6wZTmO2dvts64Ke3NvIgxPMqp+xzngaOa2JsBdtk+iE/RrYrFB1v0uvCZFs3q5g7tFt3w2rjm+RTKdwlH9mJHBnOvSfvd3l7NOqTyjEIlZfwmv/tum2WlH9BX0cyx+jhjZpaCCrgBQRtyDDDMiUEcyPva4nwnNlL54V0RjYpKRTI2EPd/O2FbA4NRto7oN07HleTezG3GsctLqDVkRAB7pWMx8cvywBXVZS2Qgv9rvXxkEQVXAo/HUhGRG+BKg2s0pku+VWhiLKor2teMOxoCYf2LLa2gBa486PP8FPv30R796cza+J2FUL1N2zQsXz6vas40rR80p0IbC7tYlIrXFayYLjwHvMhyQr/WWLEfcUcvXYxT+8hAPFLTyGO352aDfYoFjMlgMdezSaFneLbTKkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 11:46=E2=80=AFAM Chris Wiseman <chriswiseman@google.=
com> wrote:
>
> On Wed, Nov 4, 2026 at 9:57 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > Is this precheck basically checking if we can free at least one zspage
> > of the size class before proceeding? Yeah the number looks good -
> > let's add that, in parallel!
>
> Yeah, it just checks if a bucket has enough wasted slots to free at
> least one full page before taking the locks.  Sergey pointed out those

You meant full zspage here right? IIUC we keep the entire chain of
zpages around until the entire zspage is gone?

> two counters aren't atomic together so an unlocked check is just a
> best-effort hint - if you and Sergey are good with that, happy to send a
> patch.

Personally I'm happy with it being a best-effort hint!

We can also recheck after we acquire the lock (but I suspect it's
unlikely we'll get radically different decision?)

Sergey, how do you feel about this?

>
> > Ah ok hmm. Sounds like internal compaction isn't that helpful, i.e
> > zsmalloc already does a pretty decent job at packing objects that
> > there aren't a terrible amount of internal fragmentation in the first
> > place...?
> > Should we do CONFIG_ZSMALLOC_SHRINKER (default to N or to
> > CONFIG_ZSWAP) for now, and remove it in a couple of releases if users
> > in the wild do not complain?
>
> Compaction still helps when we trigger it between bursts (freed ~21 MB
> before the swap storm and ~10 MB after).  It just wastes time running
> mid-swap when new writes are filling those open slots right back up.
> Defaulting CONFIG_ZSMALLOC_SHRINKER to N (or CONFIG_ZSWAP) for a couple
> releases makes sense to me.

SGTM, but I'll let Sergey chime in!

