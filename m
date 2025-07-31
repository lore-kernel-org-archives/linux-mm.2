Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F05FC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 07:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B667E6B007B; Thu, 31 Jul 2025 03:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17786B0088; Thu, 31 Jul 2025 03:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05D56B008A; Thu, 31 Jul 2025 03:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D48F6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 03:35:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 313B6140632
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:35:41 +0000 (UTC)
X-FDA: 83723750082.19.88DB6F0
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 440E916000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:35:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YTBAr93l;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753947339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mr4nI1RZ0aUC8kJED58iFvgqg3PeLMboTB7tYrXF+Rs=;
	b=P82+gHiivKazlJ/nDTvCLQ5zXdi8Kc9q4wvbkm4Xgchfke2lTuCB/l62skWpfw+2zRhVoD
	WfU8T3Ck5zqr0r78dDWD2YqLeco0wdH/tWaNJ5dn/5Nimw9WN9aInv6+keTBsKmA7ILC2F
	TksZf01+DjI6U9/psrbGo/wPLFu7eik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753947339; a=rsa-sha256;
	cv=none;
	b=oGc71te5qPc1fSKcLHwgJuGsZMjq8jERh86Y1S7+rrp+JU+hKSBT4PY7d5qxnT6h5G0Xj/
	vS/dSBap/HsJST+vjWQ/L3kTobQA9sn03LavYar0BOXjPe7Qgy+fwPLXurTHT+/gngykYh
	Bgk3uy2U3qM0OE90y2TkAwZj+PBP3eg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YTBAr93l;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61543b05b7cso7825a12.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 00:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753947337; x=1754552137; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mr4nI1RZ0aUC8kJED58iFvgqg3PeLMboTB7tYrXF+Rs=;
        b=YTBAr93lrSYEGxKt/hXKV9rOTnhr2ELK8NehI8kZnGO5Z9JYM55GlCRxIOfPl8yTht
         S77mv0+rRsThXzIGwppYrEk2QSlp6OSxokM8VRkStErM47XVKL3kcuCK4pRQfVFDxP9r
         2Y1FQjFCAchSbsE31ZJWsBKPePCahzh0wIK3fKWeCY36jLdgSedkF8zvVxYwNHkeOmx5
         Gmgg2JgVbmnqv94jBaXYuCnaaJsAzWMOl91Rkl2yBplviMzKRP6FkOB0F+znT8f0ymwa
         TUJDB47V0XLkV6CHTfRnwmRjfVQoFIDhPvCuz0PwdC5Q/JKhZA7WSyjrJY5WyGTb1qFp
         wV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753947337; x=1754552137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mr4nI1RZ0aUC8kJED58iFvgqg3PeLMboTB7tYrXF+Rs=;
        b=ZPalmxbweB12IsWtXqtsXnF2coeGd4MOYVYtpdR1YPhjTo7VVw1oGXvExNPB64YWjl
         zoqkwVmSOEALcZi77cBbozWGqSJK51wiQZN2Bsx/NlJkC87Od5PS+B6rJpk7dOBRRebk
         HltspIeqClV9FOsfNXloRFyLGWx8M3ENXeZZSZsgc9C6EmnzmCFMZR1hu8b7f5CDNkYP
         OlEpeZ1mUCL6lhQHVEVoxKuYUXVWng5UaHrSCdpAl6P/gEybpaZp2IGN5IO56YptbtSn
         CfTgG0IwsZPdfwWKl89yEcKfB04lbxM/5/QMCxZQ4gTeyzAtm6iqYYJ36UsJr1mEi00Y
         uTxg==
X-Forwarded-Encrypted: i=1; AJvYcCU/W1IpIy7lyU+aWQsIxI3nJ4bDg7rtp1rRSrYQYCbUEn48XrEWy0JNPJ2f82zT3lA+cQTm+bw0Dg==@kvack.org
X-Gm-Message-State: AOJu0YzsFAvZUSFi9C+Gj5KnKb/wIs9FxujK+mfgUiYMWxkuf7Erbr65
	/NfMEAmZGOFmZCSF3PjYdbPEv5DEjXAagKkZcvzDHOKnCSgSxwLK9nPrVeCLqLq6amQZIEYET0X
	67EhO5fbRJpvGxTTDPnuQXssNZbH5Ay1i656MQAXc
X-Gm-Gg: ASbGncsrHwWysfBUo1TVzSZmVQzhTLiX8Q1k4R+tKpu1Y7XNEKo0t//hBuhZBoDqrOO
	9tricS4VSxzLpfYzZJJGkpn6oPfEz7Tu56YQNX8REfYr7ioq0o+CVCVaV3YQgTnhuqoTitwY8Nc
	47m0sAjFkrhDEXky+mfqLbf2cDhot1EWboN2bxngtQFzKY8QZihnHOFPOsl7kHnXtxRN3FwaV28
	d7yMvCp+GOZsmfa7PaFl706kkBlBeqkR+v1DJ8ABg==
X-Google-Smtp-Source: AGHT+IHtcUhgi8RZY+pP59eZQXFisUqGh+rMLisfzq31p3eUyY8SyT/jd1+e3gmkieggdj/A0+p+GZoIA8lDB3fc2rk=
X-Received: by 2002:a05:6402:24c6:b0:615:60d2:c013 with SMTP id
 4fb4d7f45d1cf-615aeafd1c6mr38128a12.3.1753947337300; Thu, 31 Jul 2025
 00:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250730170733.3829267-1-surenb@google.com> <20250731015241.3576-1-hdanton@sina.com>
In-Reply-To: <20250731015241.3576-1-hdanton@sina.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 31 Jul 2025 00:35:25 -0700
X-Gm-Features: Ac12FXwJBI4mVpBBqUWfGr9jR9lO9A344ujt5HbmzXkVYW0YulijvoNB_gKKPWo
Message-ID: <CA+EESO4mkiedqVMCV3fEnB-xeBMKyct1_WA=YDFVbqSGU4F+6A@mail.gmail.com>
Subject: Re: [PATCH 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles a
 THP hole
To: Hillf Danton <hdanton@sina.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, peterx@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, 
	syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 440E916000B
X-Stat-Signature: xfxf9yk3uykg8iis5766id1r6ibre7h8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753947339-252946
X-HE-Meta: U2FsdGVkX1/rdw13uR7tvZiM7sj5y7V2UxvZMLQM10+hnf7YExalFxVyohlMrqX/qDzRFl9Ev7eXCXKIOxA8m84KVe4CS/sl2je3tqjiP25cOp0deg+p2yE1CqfDqfcn7KWwciTYYJ3NBNfyHNuU7CstrMbkPCCYXhemaoJ9F5GrS/kYewqNFSx8AD3dMqcKIT2sbm81+nBI+yZ3/5SXwmw3xP+thZmB3ay6Cc11sfAX2GRjT4VSC8uNOmBpKQqjFZyV5kgKuu3PboF7/TsrXpbI9aFj20cDBN/IRIp56nBUop1OhNtiwoY5NeZeBUhSRYEXDYqTIUMIQllFA1uDOYR22Bi2pHO/Vh0hJp7GMjKZFxgua7MESlSjyStP/RgEBeTfQB7ZB2cDCaI9KeASY8NQzAq50ArIO2tdB42tA7a7FkbUMoJcvZE3IZzRto2omgSt3hUAyBnFasBENuWP8kllPHRV8T+pnoRtoBA/cj41sTPAvZ1KtFP6VaslXTnj18pccuWxoEV/y2vuv2kqtlSSZDGTPD8FshAshP4RVJ0LBcUp25ZWHpRt83R1pxBXJGczbn7mhq/KGgQZ8NOCTRb0LZg+xz9OgJGTEl05NpR4JpNbhnpDgo7qn3LOrKqGM4XbjLDqijzCnxYwLNEl0ZKTHBFX/A9bpl1XvLPTJx6j3ATUv/sRfr3a6jsIqVvaOxte67xjGMinGkpNZB0QJCFYZ+cB5RXgZdk+3Jmbiesk2LULSRGtYM3faS/Y90nH575bkYAZnzxBONJaiqxseyQPOhaZUhUcAKEjx/w4JW/S60NFVBo1MjWOyT9JlcrILjkpV/NkU79vYMQdL0vDOqfSD9UfxWDB8rNmOboxuSdrpscJY+G8dpSyhyD2QxyCtn4U66jN839/7vsSAZOpovlIgNwnLwvgUNrm+DDOMDPqt3YJ6ZEZQFnfh82KfUjm7UZr1BteaTb/ioKJxtd
 5uF1ThrS
 CHv14d+N3xXRsVjUkZk2/rpUUmBfyqj2N4cwdyf2+8H/LoNBklza0TN1JnzeecFeCvbbmIU5nmcVdB6ohz+Z6idFqGZvDSTccbl52FBo81LQYJ1iG5di/uhLvexcJYOAfbCgl93xuIvalvoakxeWV0aQCHXPtG6se5Sy/eTqY8AkSFjTzfn/f8/Xv5R+hF4xjL7RI1VMF0tOWMlj2fbgfgb41M7nUrIGRkiFLF3xt03tAybs23zr2w/pi6sn9tX00ZdYK5qhocYUu9rQFlx4SEltKabuI+JEe6xfYQUprcKde9tUSBzsJKZ+6vU/MW4myMkc6fBfO7j71csz9MbfBQ97K0daSrYnMjRPho4GZQgqDAZLo0wuXIBWTtgybE85nAozpU/QVx5Hndi2EdWClzYiCf1lhjVPun+XCGzajLWL90u0bPOPu058+jf5RNBe7IuKer/wetWs7bQp9/vnCFSYEHt6vhx9ZseSpKgUrtKMFll8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 6:58=E2=80=AFPM Hillf Danton <hdanton@sina.com> wro=
te:
>
> #syz test
>
> When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> encounters a non-present THP, it fails to properly recognize an unmapped
> hole and tries to access a non-existent folio, resulting in
> a crash. Add a check to skip non-present THPs.
>
Thanks Suren for promptly addressing this issue.

> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@goog=
le.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/userfaultfd.c | 38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index cbed91b09640..60be8080ddd0 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1818,27 +1818,35 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
>
>                 ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
>                 if (ptl) {
> -                       /* Check if we can move the pmd without splitting=
 it. */
> -                       if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
> -                           !pmd_none(dst_pmdval)) {
> -                               struct folio *folio =3D pmd_folio(*src_pm=
d);
> +                       if (pmd_present(*src_pmd) || is_pmd_migration_ent=
ry(*src_pmd)) {
> +                               /* Check if we can move the pmd without s=
plitting it. */
> +                               if (move_splits_huge_pmd(dst_addr, src_ad=
dr, src_start + len) ||
> +                                   !pmd_none(dst_pmdval)) {
> +                                       if (pmd_present(*src_pmd)) {
> +                                               struct folio *folio =3D p=
md_folio(*src_pmd);
> +
> +                                               if (!folio || (!is_huge_z=
ero_folio(folio) &&
> +                                                              !PageAnonE=
xclusive(&folio->page))) {
> +                                                       spin_unlock(ptl);
> +                                                       err =3D -EBUSY;
> +                                                       break;
> +                                               }
> +                                       }
>
> -                               if (!folio || (!is_huge_zero_folio(folio)=
 &&
> -                                              !PageAnonExclusive(&folio-=
>page))) {
>                                         spin_unlock(ptl);
> -                                       err =3D -EBUSY;
> -                                       break;
> +                                       split_huge_pmd(src_vma, src_pmd, =
src_addr);
> +                                       /* The folio will be split by mov=
e_pages_pte() */
> +                                       continue;
>                                 }
>
> +                               err =3D move_pages_huge_pmd(mm, dst_pmd, =
src_pmd,
> +                                                         dst_pmdval, dst=
_vma, src_vma,
> +                                                         dst_addr, src_a=
ddr);
> +                       } else {
> +                               /* nothing to do to move a hole */
>                                 spin_unlock(ptl);
> -                               split_huge_pmd(src_vma, src_pmd, src_addr=
);
> -                               /* The folio will be split by move_pages_=
pte() */
> -                               continue;
> +                               err =3D 0;
I think we need to act here depending on whether
UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES is set or not.

           err =3D (mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES) ? 0 : -ENOENT;

Also, IMO, the step_size in this case should be the minimum of
remaining length and HPAGE_PMD_SIZE.
>                         }
> -
> -                       err =3D move_pages_huge_pmd(mm, dst_pmd, src_pmd,
> -                                                 dst_pmdval, dst_vma, sr=
c_vma,
> -                                                 dst_addr, src_addr);
>                         step_size =3D HPAGE_PMD_SIZE;
>                 } else {
>                         if (pmd_none(*src_pmd)) {
I have a related question/doubt: why do we populate the page-table
hierarchy on the src side [1] (and then also at line 1857) when a hole
is found? IMHO, it shouldn't be needed. Depending on whether
UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES is set or not, it should either
return -ENOENT, or continue past the hole. Please correct me if I'm
wrong.

[1] https://elixir.bootlin.com/linux/v6.16/source/mm/userfaultfd.c#L1797

>
> base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
> --
> 2.50.1.552.g942d659e1b-goog

