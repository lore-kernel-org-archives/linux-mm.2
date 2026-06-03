Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5DDCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DE46B00AF; Wed,  3 Jun 2026 16:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815A86B00B0; Wed,  3 Jun 2026 16:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BD86B00B1; Wed,  3 Jun 2026 16:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60E516B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:51:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4195C1DAA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:51:37 +0000 (UTC)
X-FDA: 84839797434.13.946841A
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id E1F6EA000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:51:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p7nuhSy3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780519895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hTxm6EsNp3ZZn91hRFR6ginSU70UVDxdZM5vbNNjfA=;
	b=dvGcDtlKrlIQAEtjFiIpLXG1oQ9Svbm5Tr0BiSxKLUb0KYrdLpZQIQ1Ia3bO3bFMFp1n5o
	nKLME9rhcB7g4/Bz7Knt15WqXepk6LiIoRYmc3aX6lQ2aKJMvnEO0Z+5nPABO7+TC8wVqV
	JDROrfjZBtbwjM77kzLOmBY2PXAnxSU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p7nuhSy3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780519895;
	b=m0BUNsRPwltKb65qPjynEb9c3kmR/bFDnUIyNXGoWVhHBaSYKNc93FnCtVGrLPf7PxuEia
	L5rX1Wxk+vR+oMH08J/a+FnoHq/aEhdNJ5cDyWjXGFRWmpBqCJrbRf5E1BkL8gujJ52re8
	KyZHRpUL769av9irpAC8p8SqdjMJuTU=
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-69e1eb34b20so6217eaf.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 13:51:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780519895; cv=none;
        d=google.com; s=arc-20240605;
        b=NY8UWAlNbaupfr2u//rk5Iwf8BMe6RAv58/L4vwr1jcjr64BnvHfGM+L89xrrUhJGj
         f3w2bsBi9keyKu65PiW21nA5XUUrvwAwCPds9dhmg/sMrPZfMmsaBCO4g9JhZbo0p/m4
         mBciQBoy8wHIS3H4KymRc1txqAsRzN7XJg8RD864JDl+KOxmJ0f2auxL3xXJ9D2QB0jP
         +1CqKK4bHD1U5WXEtqehrBX3iqnzIhPjb7VU9mDF82vpYXtw/sOT1NE9BhfIpN3xznYH
         ixOlldHSbBrtEDdB8o7OgT5z+fIloGYABRZ767LiLDpzFrPlR7XdxQ1y5HrfyTZ3zh67
         poyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2hTxm6EsNp3ZZn91hRFR6ginSU70UVDxdZM5vbNNjfA=;
        fh=WHjIlg20QDl6fw01ahHzHJHawZwz/3bStobZ1shKtpQ=;
        b=RW8PB9sfMP78sfUWak7d+VBrt47xIc3FnZzIB3bglwj3Nh/z2oMie3YJIAt/AHPObn
         AY9IOXX8Lklq6ITj9wraUFhFp6behCbePlHnHmK4TbRvAhfpq0fIYoO82+5yizEzudA+
         Oqrm9xXB5sKuK9EAFz6wWvkAsdk3IfXww6q5lJzkfrkpuQcr327YyUvAX5BxbDsmf5wp
         YGHJGQhmCtKpFfliJcve0wX01y+qIQxvwTgAoq7q1YbjmpHnw+WdosZ0TZIQ5Dm1Y4Ka
         0xiO7VvpleX/Eg26WnvqMuPe0Ox3LSnpenuzXnOzA1mFx8iV61Tu3fZlUtpMg/Vw1Vdk
         dMAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780519895; x=1781124695; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hTxm6EsNp3ZZn91hRFR6ginSU70UVDxdZM5vbNNjfA=;
        b=p7nuhSy3NfMKynsxHwT+5jzMiOSG0HWTc+aETzRoqDODduUneiKXntIHJPmmlix7VJ
         txORI1Iu3i/vJLn/qYTOVJnNpzC0wZ09NgYZUer7M3dZI1miBJ3B+DYOnPohws2YSqgx
         BZILWv77Rz/riz98MbSVd8hBnzKDC7sJuE1MDfxrZkRNz4SDZp8ZEVr80UX2TwJJmnjY
         O2Ptb4TKjnpsuC/PjvrQh+K0C0unHQ+8F+U/TpFbLGIEenCbqeOYMqCo3G2mqDnU5OJc
         boqCc1CnY66i7P9uRIPGaIPdakihDoXtvSlCOj4wRB2dxL584RmXpPiHdMpdyxzrHXsk
         j+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780519895; x=1781124695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2hTxm6EsNp3ZZn91hRFR6ginSU70UVDxdZM5vbNNjfA=;
        b=T1JZZxgsmTZ0woTwoWsAsGUscKTlhOW36YyGKTw8d0VtabpVyEpeand3f5C0Bu0A5G
         lYPAIZUR7s8Bvz5d9p59JOgd1P1BCMssbUvsR6G2GisOmwQaSpiqogzIBmWhFEeJXvFd
         CukT6hzovHp4SGGl9BcefJ92vXQYS1FP1z/gYaCmn7hKHOLYUUtV8q2KbUZodAadTvzw
         cwao/OG40HX2paabHHyo2UAwK4cloKkKEpqIEM7E+CqB5b60rPkFNvvkIJkqrGxT7Gqp
         q5X7E+BOMOUflipo9/dRbsTK4shHrpBLORtVQBmJ6op1VnzNj/I6XTJCIXC2sCRxN1k2
         GzVw==
X-Forwarded-Encrypted: i=1; AFNElJ9hG9Jq1b0UqGaJV9cr9SZCVVgyIEcJmvWVamdVMr167a4m0GIBt1MMJrYykyb3ZjMyvv4k2jA/ow==@kvack.org
X-Gm-Message-State: AOJu0YyK+YM0dF5tEGqfOnE9LHzPxnCA556+TwlBC164jSehwQZct4Rm
	alSFB0D3u9NoiJQLT1lxrO64a15YdeAPzkyTRhxCJZux9PfRfBqRYnFB16uEL4oFigO3wz8OgHa
	TTt6WCQ9iKqA1rVX6Q6LNcwyJ3TiT150=
X-Gm-Gg: Acq92OH4tIzvVAzTjeG78hNmvbqacSr3CGBKZDdC6BiMdxpULoKlCdhAylp8ualHr8S
	X1gSx2WKAwvdLqJA2oPJjt8lIBt10DbepRqwoyaT9qpMaWxQa8rDj2WppaizYBeMhryW0uUqZS0
	nDPrM/2otD99u7TwFicJThO6U0zdDNkQyWD+OUZ+hzZP4TQMtEeM9tyf+ScWCCtoEoEd66m/nVR
	FQV/Mpk5hR8csJhuD0uwv8iikH2uF5DnGxA8gf/CaKS+nbBLrY5EwFxPvatsJgVu19YDvjFL80t
	FK/5CkNDKwJ+CK+T12vWyr2oWV3u04WMRJlKfp8odqs27AJx
X-Received: by 2002:a4a:db45:0:b0:69e:14a:f30f with SMTP id
 006d021491bc7-69e4809197amr2037947eaf.41.1780519894809; Wed, 03 Jun 2026
 13:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260602222358.49061-1-devnexen@gmail.com> <CAMgjq7B5sSjJPG7bMyEf0=c-W9heiPL6SQsedicyp8ahXWrYPA@mail.gmail.com>
In-Reply-To: <CAMgjq7B5sSjJPG7bMyEf0=c-W9heiPL6SQsedicyp8ahXWrYPA@mail.gmail.com>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 3 Jun 2026 21:51:23 +0100
X-Gm-Features: AVHnY4KZMwp3hNbhdoqPob52kWdksNuiEmIpeP5tzG-_RR9C6TEd2POiAAL4W6k
Message-ID: <CA+XhMqwwXCaOBc2a7umw1EPKPX-Nz8vJgwdYL1VDp5r=_zs7=A@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: free the cluster extend table on teardown
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+deedf22929084640666f@syzkaller.appspotmail.com, stable@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1F6EA000C
X-Stat-Signature: 4jq4ebhczy7kct8tgtabcjwc49koo1e3
X-HE-Tag: 1780519895-100516
X-HE-Meta: U2FsdGVkX1+K9qySSoLnlutkZ5ydXLbi310079nU5ntXCXnE3HHOpL5DanLbMe6ggbJ2MZYLojjs6A2mO6Ngvk3gyuPq42mSLOm1uMeaMER50IY0CORUIho91R70gTz2wqNH6MwRTDmiBWur+sA/KnLwSy1KJLhIeUZtZMx/cmmuNH/OoifFSaTRetIKezpI8meHx1/nAXUkGYSl4+NG9OZLA7zXe92jf6LdxGFosdxu3/3InPFznOC4tro+t3xuesjvSgCysUMyS/L99TGieFndqvPgKsSJ738InTVdhW0DDyziUOPZWP30tra0rzMryiKOt0l529dmQQuVru5zbc/nXFmmSxRVxyfkG0nAJUSgDpwEvY35mWbZwIRmMH/ZrMJl3ANM4zLNBETw3fDcKkB8gAxQgq4ZeyeVduNlG6JGduDrVjobpaRq1AwFXsNj1rqI8fxGmtmwKdtZdHrZY6C94+5PxjvsmYj52UNUPSGr6bJCEU7BAW2G1jFvqLnkS4RJSSEhCTZzHHjAoMAzgNOLYD5JmCSVGzLqN+bMqbxfQD62TVmJ2+rh+/xfkJEGSr02R9pLAAjmzZQCsYXEIyDzTb0cLjwSgv54U3sK/+Ht2Y+E+Q0oiaLa2SPkBCbLd9QD2g3p2eYVTl+LgFWSmCtykqWkvtS2GvHf20rUJg+/wFKPSa+lWuTFBwJdZV2y0vYb+8HDNw6smGwYrCJbGQk7qaKOSNkYW7GolOSv0Kwcqj6UfzuQ+AbfC+48AhRdMEVLpxt4Xxc/GMcvt80kMJ3+A0ciFD3o4BmSwwweNKqqiTR16epv35aQotYFP8Fh5+4+M3W3lHjHWFeaKmVW7LXP3fPtZgWoRNFLAJohGLIpvwtOAepWGyqo5FbdoEHgysC0CECGulEpY0X0kPMfwF5fj8gyz/spFGP3mYsoFe3aLlukHMZ+B5HuqGFJziJAKZ+uJULAtwNLXNzBRlX
 ufp+5EdA
 h7sstkikB1CETemSqwvZhLgu4icUT/FiM/Yonv2Wz64gvP129t2d9sHWSYgn5AepTEKqUNa4sZagwDFX4ZQCGEBtd7S9yqQ0DAn71cRkP6aNjOdQ4EPZVLeNtLs3VXDtsgVr4UT96uEGEGl+Y5+9SVw7ZQW+zZqc6tCdoOpeYMTxa5PwY9SQR4VQK2SCZFJiqP8Ckd8LyEJ7x106WCOSbAqEDgvyGRDPEH3F95yHsjNzSHCIoFKZ1phaECM63EDJKkKhywp60fEmFG2xMgVmprev6+LXQQS3LOXZ5zuWj8iC4P6HU1J8/mqZXuf400jdxju59KSuiOkrYp7MWw8qCmkACaszc/8g7N5QvzA+vXWScLqUcZT0zhC9lfRafNwnkQ4DlOjlkI/wPw5aXpPew1GKhNaCsDm8wGWPLKuJ1scB1zk/WKfaLVhuOn4E+HyhNjzlurD5Dejy082j88DyQ6StwuPnJBdnFphBdPja/jbxPL9ZPV0ozALq4BsZVwmKevN9bsJzOLYmBmlMNmscd7QJKlcZ3bGw7FCo5fQbqAgZWkZDEMvVGdHquZH5UsgD/ehg17wwsGHcW+Z3IxI0ksVHZ9iBRlZGg+t6PVjEaqrfbPV8nqcryDxsZTikdgXepqaKFuhohD9/8nBnOcURpi/dK6mgd/e4rsQyYH8qij85kx5CJSkilVtb+KCSmH8mnN++sEecTI3dSZC5RFrGcJa4oRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 03:42, Kairui Song <ryncsn@gmail.com> wrote:
>
> On Wed, Jun 3, 2026 at 6:27=E2=80=AFAM David Carlier <devnexen@gmail.com>=
 wrote:
> >
> > swap_cluster_free_table() frees every per-cluster side table but
> > ci->extend_table. That table is only released by
> > swap_extend_table_try_free(), which the teardown path never calls, so a
> > cluster can be freed with an extend table still attached.
> >
> > It can also linger while the cluster is live. swap_dup_entries_cluster(=
)
> > drops the lock to allocate an extend table when a slot reaches
> > SWP_TB_COUNT_MAX - 1, then retries. If the count dropped in the meantim=
e,
> > the retry takes the normal path and leaves the table behind, all entrie=
s
> > zero; only the failure path frees it.
> >
> > Since a swap_cluster_info is reused in place and swap_extend_table_allo=
c()
> > skips allocation when ci->extend_table is set, the next user of the
> > cluster inherits the stale table and its leftover counts, corrupting th=
e
> > swap count of any slot that overflows. CONFIG_DEBUG_VM catches the
>
> There won't be a corruption, extend_table is all zero at this point,
> the leak on swapoff is real though.
>
> > dangling table in swap_cluster_assert_empty(); otherwise it is silent.
> >
> > Free it in swap_cluster_free_table(), and also on the
> > swap_dup_entries_cluster() success path to match the failure path.
> >
> > Reported-by: syzbot+deedf22929084640666f@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Ddeedf22929084640666f
> > Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap co=
unt")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
> >  mm/swapfile.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 615d90867111..a69a26aec4c0 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -432,6 +432,9 @@ static void swap_cluster_free_table(struct swap_clu=
ster_info *ci)
> >         ci->zero_bitmap =3D NULL;
> >  #endif
> >
> > +       kfree(ci->extend_table);
> > +       ci->extend_table =3D NULL;
> > +
>
> Still a bit too late to avoid the WARN? The WARN is already triggered
> at this point, swap_cluster_free_table is called after
> swap_cluster_assert_empty.
>
> >         table =3D (struct swap_table *)rcu_access_pointer(ci->table);
> >         if (!table)
> >                 return;
> > @@ -1711,6 +1714,7 @@ static int swap_dup_entries_cluster(struct swap_i=
nfo_struct *si,
> >                         goto failed;
> >                 }
> >         } while (++ci_off < ci_end);
> > +       swap_extend_table_try_free(ci);
> >         swap_cluster_unlock(ci);
> >         return 0;
> >  failed:
> > --
> > 2.53.0
>
> I think we have already fixed this?
> https://lore.kernel.org/all/6a1eac8e.fbc46276.3c3783.0008.GAE@google.com/=
T/


 Thanks for the review.

  Agreed on all counts. 0475fde0f68d already addresses both the warning
  and the swapoff leak at the allocation site, so this patch is
  redundant. Please drop it.

  Andrew, you're right that no cc:stable was warranted here.

Cheers.

