Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F86EF483E5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94C56B0005; Mon, 23 Mar 2026 15:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45BF6B0088; Mon, 23 Mar 2026 15:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34066B008A; Mon, 23 Mar 2026 15:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0B706B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:01:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3ACDE140CE6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:01:40 +0000 (UTC)
X-FDA: 84578246760.10.0C057F0
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12B6C140004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:01:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j29QJXDJ;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774292498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQbe/0T90bj+nzgvCgx/9AZxqMYkz/Zoay6gt6y1obw=;
	b=wpQJBWmeg0yeXoZy1nk71VAs5+KBvvfrbpdLEqoDUSFmxyjmAkJWgUmh/IkxrFe5a/Pk2u
	+ghj5qfGSaQlLpFKIdsMc8PBJ9qK6J0CJYpeqa+o4JKO04gnfAvpxvWgKHTKJ3diRt3j8E
	Owi9mRtorl7IMkBvr+kJ3v3cmZc0FqA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j29QJXDJ;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774292498; a=rsa-sha256;
	cv=pass;
	b=z2ouVweT5SnUG9grRstNJ92jAoKIVhnkNkP5rEVJfEHQGxnVrFNkY1sTbQzahHFNNqvSFH
	B32xGHU92jXWNJzz7LuHO5E+ZqFzwLlabYR6Buj8Ui/YQkw2ZphTy4k/7WboUJBrAW2Hj/
	wju5W2Oe6XajPaZkHKe7MVUPm05GlGw=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-66966a394ceso3567566a12.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774292496; cv=none;
        d=google.com; s=arc-20240605;
        b=G0937mWQi2JjFZltEOSKWxR3SuCjZDa3R5Imx0zy2vx8DrnSqxRRuA+jqicyfRTlbj
         WI7P9wdIHEc1b/GAk7JWc9M/iRTKzVOtwHYeBiDwoVgKdevonuPsFuMPziQr2rJstqiN
         qNP/yQNxL5bMJ+8zDe3oSCi3xez/kXTJ5FwlvF0wJGQ058iETnUtWPjVSdPuYhfYXn7d
         bCI9PMnGuXcf5wQRsiMwYmTHtxWsXsxlUrfTd2wtkDrJxLi7UYAyfbKmnUloFxyLH90O
         gMRNj8ypZDruVJIfnsEBIHpQrzhz7M6STsK61KJHcL2xO/ZxRvPw8yjR3Sg2IhqFE3Z4
         Fnww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sQbe/0T90bj+nzgvCgx/9AZxqMYkz/Zoay6gt6y1obw=;
        fh=7YTbtFTmCQMu3Nw1RtVD7o8zFC0xrfnccR2aAJAMMWk=;
        b=YHDf7jK8iLCYyLoAJN3hMz23O2i2uqg0yUjhJpxoe7BFO/yAANDhtqzpkMGMagMFh+
         wugQ4sZgyxM20ry2DB/mIHHcQXHIhH2DXAMO+M1jSGpQKqGIorQP+62DKFa59uQeyi0P
         HcIKirFxBaGYWq1aiDvcAWYGhPGX1tJnJhw1pWBdUVTVkF0P1tRNmM2PcAmcrbrSpHcA
         RVVoYSHktnJ5OJ33teDV17pRiOzywTaqoelBL2TFaD19dVzQJ0tI3vpdCVcQGZ/eDpjZ
         /L9Fp/Sl2S+BVRUrJ7ZZls2fAgj7vyasgTvJF6kG3HCXyVPMAqPXFKlTknoLXXyTW8O4
         C5eg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774292496; x=1774897296; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQbe/0T90bj+nzgvCgx/9AZxqMYkz/Zoay6gt6y1obw=;
        b=j29QJXDJPUHJnudHmg8RnCYa1/qJSrRNDT0+8YxUK/CRhGiUEeeeJSIJSj5Lz+g5g+
         TV/erZEUOpT1Z7me0guyaJmjVRnoz2TdHKIEt8bcGdB3AA/UEmX0Zckml8YC4Trp/nEW
         T2CInEhKEAm02oqkWEO0qe7sypds5ge/9hJRzhWLjHJbGeGLoxtgPRK6bNycCj5/0qCh
         e9T4peTsWEHe29rMWYbDluO68i5MhYkHcHkiYPvjzVHkLMeiaP4XDqapTV4UK5NEAMKI
         woqoOANaTaZUTw4G5QQE9dwpIz05FiHKsY8MB2nJSj20p28aPQMXbJ7B2BluFdIkhk5h
         xdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774292496; x=1774897296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sQbe/0T90bj+nzgvCgx/9AZxqMYkz/Zoay6gt6y1obw=;
        b=ULcz7Gsbtx55sIHgz6x3gRfhF4UtqRt1Zc1C8rKw/jmRQ3G8Jx29Vlt0uj95udk3IJ
         UCt0CaNpylD3EaadpDQ2RzijhfEII0gHcRkSIOIY3n+Lw+4E/IlWuDci8gDQ5kYDwkhw
         BXsaGJCpvoEsP4y6hrp2FT+tcUAHbDY2Em+XLXczxCy/SBhp2DLUPCB5eTGAyC6gOmxA
         Q1IU6ODb2y7c2sHOEdVh6HhcWbQ+1jLrtAUCoKr2UpkpgYb74L6QKKyIO0R3xg9HVlCz
         mhMxpk9HYSfonqdjJjFlWo0SeONQl6OJ+OpHhQ2p8VI1GJK71Zqygz3072Cn0719CH9j
         gdcQ==
X-Forwarded-Encrypted: i=1; AJvYcCW97wNdqj3rOCaSG/wjCmYFQRB0SowAy8ahqzrAoqHPvrhnlppMF3g5jINehLeCXZlOX48WV/b7sQ==@kvack.org
X-Gm-Message-State: AOJu0YxutaSFGaKGqF9Hwq/PSvI0Dwlei2KFHkDFpx2fhkbkp5m+JPy7
	vKJzmzEyUz6+2oH+HafvuPj7f63PS6i2rQxDeyAQ2NDvENIBZqjDXr7466p34lWmHQmCEpXMaft
	VqevW7I3PuianFHw8aVqQmB5O69l3pwI44x/MVh5RFg==
X-Gm-Gg: ATEYQzxCNWCOx5uzmmwU2PGAw2j6+WZxOIasmbF9l24EJ3v/Au0fm0JaXZAqcVR2PlM
	OBMlkj48dKPRRvL+gc3Voi4AWv8tshWoH1rt3Ksb8K19B3eliXZ8GNut36z67xA8kNHPI9hQtuk
	QrMWNslCFH7GUhf1Qk9GGWOVcL0eikQiDGdgn0NmWniJycOOqzHDCFkLZPnZR7w0+MxBvM5JHK8
	Jg5pUM/Qs3P4X8KKsFuXShTeFfr0Fc/0vV4NuK1mQoys19qc+MqM8HdnNOO714SpH502Hnz+iXD
	efvu+YZ3B6+NgRxxSsSwMu/PX66r9zIePWnBQg==
X-Received: by 2002:a05:6402:4348:b0:667:a5a4:6f9e with SMTP id
 4fb4d7f45d1cf-66a340afccbmr567400a12.13.1774292495934; Mon, 23 Mar 2026
 12:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260321143642.166313-1-oskar@gerlicz.space> <CA+CK2bAfPSKfV=_Sw20oqF56+H3a4k3x+47i6-EUK8mLV-i2+A@mail.gmail.com>
In-Reply-To: <CA+CK2bAfPSKfV=_Sw20oqF56+H3a4k3x+47i6-EUK8mLV-i2+A@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 23 Mar 2026 15:00:59 -0400
X-Gm-Features: AQROBzDtETpQsj-AecoLaywrsY7V3QWBPfaBQyfivtfzpdS2l3t8Zk-_O4mTPN0
Message-ID: <CA+CK2bC8o2p_poLb0yfp6mAAwR42Vg_99Yh_HLK1iJZrCrsVig@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] liveupdate: block outgoing session updates during reboot
To: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Cc: Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: mh8hfzo9hgzj7r1zfrceqjraiz94niyp
X-Rspamd-Queue-Id: 12B6C140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774292497-859451
X-HE-Meta: U2FsdGVkX19zxPqMAWe81vC6v4w0nczeygJ+KyaKKGPHkV9HaxVJlWRs8W/Jfhtb/OJ4oaI72sq66bkUh2lMvCYzuSviQz3mvKTJvd6C/AbbjC9bZpU2lE+2jOsPmZ89cmADt9DiNMw3DFm0LCHOJYY12Hn731sFsJNuJ34n7jR09GjgIDq2WIkYAoKranm86971PPCN6h+eICWSpbHAoZIzdTwBa9Gu8tgyJbnJVnBDA9aLaeCtmeluESkrUp5glKHfFDRZpKo/cSs8NPBUx9pb9S/y1v41Ip4gKk71ZDdVhvaNyqhEd9U9xuhSMgxKG0YUyEyGIvY/TJYcg+byr/ulo3ctOoAbLm+NouBdcdrrcadleAnGSCAGp06LbgdPmpHL+UbthKmbAXQoGBbu55Bk9C/wjJCMTsv80TKm97dS/PaR9q+G8qkzF9sImoqt3+aFdhvgnwTBYadiNiqKEnblKjIBaoNbjffczRtbPIPo8h343arEpRBzsJAzm0MIT3cmPLtX5l55ifxfLQutnrvkuvx3ElewChgdLNo92nnpIt132ZzYS0qQfrZ/MsyFGeTupZXAJ7mdGW21smY8nO1kcOc/kL8CZCK2b+eYMmUga0SF4LGc8Y5yfrqwc2Abtx0bC4JsB4bD0bYhXTK+UTon/c8UXoa2vXfuiLnyllwB1MkyKG6Jc+kcPjc+f3nLlGyM3BIX1zzDhNuICuu3+ZHmYwEvW5Xt3jRRIuR9HW0329+QdQr34tlwZgjksx7BYf0XfcSNYsKr4AEfgTHlvh+nZm5NOusad1EcP8/jmIPRlFNrjYA1OR7b/qdQeDT/hoz5qQaD8jHG04EW1+gits9afc2AypS9SkprSFOCrq5K7I50T0cobTMynMDogcVaVXgmbl07eyA+JDEpIU11XL/5y53G1TLvhqxOAynnwsl1n6xKmRYFgWI1rgS86ZEl7I6MOf6X0MOBQJu9F2T
 te+1eA9g
 9I85cjPCvgFNataqKAesuNT9X/01mSH9AZyRYRJbkovj8JgfOQcbPTddKdW+jin1mP29TuX2M3WnJwuHHgrGsQ4WFdQ8SZ4G5Fxy73cE+eszynm7MOzpyfIxb9WtrkRKRD8X8LSg4Hg5ND75/yluswvzVW1kqSGadcIs9hgeGF8cjpCV7u6dV4T525gtsWv9VV0dIVJRo4RqN0BMXNkNcrdGfGSDrgqyd2QSI7SWyKdco45klnhzywyutoRIsukrw1teWuBRpkfjN4ZljcbbXKK0KZwzCtBcpKKVY8XxdlMh97ZYdUDS2GHH5ivmmCPt1BAzzwR/089LWoAUmcDI67LxoHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 6:28=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Sat, Mar 21, 2026 at 10:38=E2=80=AFAM Oskar Gerlicz Kowalczuk
> <oskar@gerlicz.space> wrote:
> >
> > kernel_kexec() serializes outgoing sessions before the reboot path
> > freezes tasks, so close() and session ioctls can still mutate a
> > session while handover state is being prepared. The original v2 code
> > also let incoming lookups keep a bare session pointer after dropping
> > the list lock.
> >
> > That leaves two correctness problems in the reboot path: outgoing state
> > can change after serialization starts, and incoming sessions can be
> > freed while another thread still holds a pointer to them.
> >
> > Add refcounted session lifetime management, track in-flight outgoing
> > close() paths with an atomic closing counter, and make serialization
> > wait for closing to drain before setting rebooting. Reject phase-invali=
d
> > ioctls, keep incoming release on a common cleanup path, and make the
> > release wait freezable without spinning.
> >
> > Fixes: fc5acd5c89fe ("liveupdate: block outgoing session updates during=
 reboot")
> > Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
> > ---
> >  kernel/liveupdate/luo_internal.h |  12 +-
> >  kernel/liveupdate/luo_session.c  | 236 +++++++++++++++++++++++++++----
> >  2 files changed, 221 insertions(+), 27 deletions(-)
>
> Hi Oskar,
>
> Thank you for sending this series and finding these bugs in LUO. I
> agree with Andrew that a cover letter would help to understand the
> summary of the overall effort.
>
> I have not reviewed the other patches yet, but for this patch, my
> understanding is that it solves two specific races during reboot()
> syscalls: session closure after serialization, and the addition of new
> sessions or preserving new files after serialization.
>
> Given that KHO is now stateless, and liveupdate_reboot() is
> specifically placed at the last point where we can still return an
> error to userspace, we should simply return an error if a userspace is
> doing something unexpected.
>
> Instead of creating a new state machine, let's just reuse the file
> references and simply take them for each session at the beginning of
> serialization. This ensures that no session closes will happen later.
> For file preservation and session addition, we can block them by
> simply adding a new boolean.
>
> Please take a look at the two patches below and see if this approach
> would work. It is a much smaller change compared to the proposed state
> machine in this patch.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/log/?h=
=3Dluo-reboot-sync/rfc/1

Oskar, I made a few more changes to avoid returning an error if
get_file_active() fails. This prevents a race condition where the user
might call close(session_fd) right before calling reboot(). I
force-updated the above branch. Please let me know if you want to take
these changes and use them to in the next version.

Pasha

