Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89228CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BBA6B008C; Wed, 24 Jun 2026 17:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5727C6B0092; Wed, 24 Jun 2026 17:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1196B0093; Wed, 24 Jun 2026 17:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC936B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:29:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE3DE8E676
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:29:15 +0000 (UTC)
X-FDA: 84916097070.23.F7FECE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABC661C0004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:29:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlW+ElBv;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782336553;
	b=pjWRjoKgooGvAx2HxZ8c9iv8ICG8AzFypuMaqh3U+uOa8baYktyKtQq9PnWIYEmMDftTIw
	t56jQ5klgNf8TJu1y3P0HcpSX1zo+aca2GZbKE+pxfaZ5tOQwUNWCeJHJWErBd+8aZACH7
	G4IpQls9DO4ncVZzjWUexqJa5BzYCwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782336553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fw9DmPAWeJgCq05tqq5cJv32HfUi3ZZuoZn+hQY1KM=;
	b=yvXdO/ts+12+dGeZOwakwceZUFGsMVPhqUsz4OgQfv+CvmG0NfqM6aGPq7wdwtnW6LEOqo
	+wYJBBwZhnvB8uOlxcvZ74gYrJOTC/QQnVZ1jQcO7v01SanZawPVdyC3nOhG5zukK9uOOo
	2cuzhGexedry2uKlP3UUj4Knpuy78Sw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlW+ElBv;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A530544274
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FB11F00ADF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782336552;
	bh=+fw9DmPAWeJgCq05tqq5cJv32HfUi3ZZuoZn+hQY1KM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GlW+ElBvaYXDwUWG39y8Hs/HblbdgMluslHHNzdDhOQbE/m6WZdBI22M03qiL41yr
	 3q36T41Gkh+Fi7UpAdlk2ofq9SV3wHzrr8/VKP8Ewitzl/Gb4Dz/IiMKeFxLj/Dgrb
	 /gjRwwB3UB7ao6tybIAtK3EcM2tjSAYQUbeFFzo1E9M7gLVYQEVhOMpjfO2s02/hR5
	 nTO51t97ng+URdQEp0X2QZbt5Jdl1++srVD/4MYjutcbej8Mb8lA/maUiZESUXarvo
	 iSkJoF8Y4IKLpY+Yr6wxwRcjzqWF8g+vrYv8oZOR2ACORjNr76VgOw0yeaXsf9lTcf
	 ySnvueno4gA5w==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8dc09919aa2so25024266d6.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:29:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqEkIWOtSOIHBl4ewax1jeUY49/HqtFaBus+E6CKXEN4y+Z1zsv4P0OcULBq6a3sIviN/lrv0Xreg==@kvack.org
X-Gm-Message-State: AOJu0YwXDUqmDL+Gkr5hw6T74lvwzvQ0mA51VscHRBBMAmnYffeVppbR
	jA9XsWBTmvqceC7iyNU22B+YtMhRaHts93Zx/wZyYp4CSBuz76ybfGlChRmH7HG/busp7/s7SBu
	IHiWlrxVKDhe0pnKmzWUTTV5a021LO+U=
X-Received: by 2002:a05:6214:1245:b0:8a5:104b:e37b with SMTP id
 6a1803df08f44-8e5313082b6mr81132146d6.42.1782336551793; Wed, 24 Jun 2026
 14:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-3-baohua@kernel.org>
 <24ca671b-074b-4d1c-ab50-1143279480ce@kernel.org>
In-Reply-To: <24ca671b-074b-4d1c-ab50-1143279480ce@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 05:29:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yy_YjAwFpNhq4pXrDQHifiG+zxe5kb1mmxAYnAeyAhGw@mail.gmail.com>
X-Gm-Features: AVVi8CeQR0co_0xzQ4UKjL7F70KnP-mWU7JOqr7t3Uoutvxy6EYuOU9a4F5CWUg
Message-ID: <CAGsJ_4yy_YjAwFpNhq4pXrDQHifiG+zxe5kb1mmxAYnAeyAhGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ABC661C0004
X-Stat-Signature: zc3srpu7jap1njb3wjaotnin6guxzkzn
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782336553-338599
X-HE-Meta: U2FsdGVkX1/6PZTl0VJRNmmV3Pw0M4V+daXCbmBv438t0fGfJaw1k45tutRUQVzZQHnyZZdVh/Bbdv2lq/yP+FkJw8//sM7WRxfBCNpcvRShskNPKee+KMIkaKdcOIy5DlUQCeHccvLQKiQfMSNya2dtoHwcBI9b3549+7VgIdmIH1wp+6xsO9y4quYX0cSkIu+tQ6bvlqxZ/i4owEB7ntrCSlGL4wC6c2FXDDScGs5x2ZjAPX0SiGzkyae2EmKm26yAjLng8s8+nZtgevE5rVlH9kEhNvjV3TlWjqoPSWpCsSceIZ8Y7tipPtNCwcP97KxUHJqyBoFLhzKC4RZSIFpsugTzuzSgh2RAxzTG8auX4lR/S68d23WYOGvpjZCsD8wfu35GhIp7UKEDvfqgise5l4NqIATW9z3ymEh+CmlSnX83MCbWZmk+TMGEzdgDBiFg6VdY67Nr/I7lMvPcB5hsgOTzdxA70UT6Fglr9FFbCZZ97Vb6x4f8eQlZyQgDeBtDvHTOjbN/9KLKTjJEh33hJlb7F7R+iqH6zx/9VmVOQfrEyu15WX1jEO3c42FlWeehFcrUX37DSsjyxhpbuffqu1U9MzQhOEFJzjGuwxX7GSXr20quGWPpoBhdSu99UkiCQlb/UAL9KA+PFHRrJpWXOlTAYhANZcIqni4cCdw7bKvtExZsK9IM3e6Kfym/MIviObhvRsFIERHmmQ8IkwOhtH/3wQe3CiamRJaauaYagQiF9S3xY1kEaqBAimd2vXosdMmoApKEzSo1A+vUB5mg/3N9j0DIyow0n/3D1W4fimofgPp1Jt5h6sFCvbcLVckjcOxQjVTe7zD0KYZYAxlg5HYOHudWWb7Lc4wGXW1zXaLNkty6TpnLkBhRC7X6Gc4cQXTPat/6EuuCMCTJWl9xd/mQbmj46jFEDxGmoQh9JPaCtnPM8vCz5JRySkJCOIbrdVt8gdLg1SDY5dQ
 Wn942ci6
 u1ZBkJr/2Hafz1H0L7+/OgqItGCiGx24mdGUqhQPY4P/IUZ61fjlUaz/vHF7HFwWml/WRUQAFFhC82MeXZplekTuEpHeN8gChYb4ltKhNgjwVvpG89TcpkGTrwSFreFemwnM+G4ltkQoRHPF4dNyEiVnHL6LGem9s6lwuwAeiVvT+vRGlbMHT18DJnOdYzHSVRfHpPoLzMDMUp1cm4uP0bFGbWLyEocu1vdf1H7ISzpUEJ9+se+8PQa8JU8fedpoHZmlUECEFqArjg6ZLdLYwSiVHsR3EHWCEl9DQxEc58BsJp4T0TnVZrQ0AyZP9rxsYHzsaxBcU1qk6O7GmrEUTJUrlqwvnaCpjN7E8padFQCqZVCTxr5x4b0uyXZzDdej2xm45
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 11:08=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> > The "we just allocated them without exposing them to the swapcache"
> > case no longer exists, as Kairui has routed synchronous I/O through
> > the swapcache as well in his series "unify swapin use swap cache and
> > cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> > in this path, since at least two references are held (base ref plus
> > swapcache). Remove the folio_ref_count()=3D=3D1 check and update the
> > comment accordingly.
> >
> > [1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a03=
3@tencent.com/
> >
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Reviewed-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index f6848f4234a6..abd0adcf65f0 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5049,12 +5049,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >
> >       /*
> >        * Same logic as in do_wp_page(); however, optimize for pages tha=
t are
>
> s/Same/Similar/ ?

will change to similar in v3.

>
> > -      * certainly not shared either because we just allocated them wit=
hout
> > -      * exposing them to the swapcache or because the swap entry indic=
ates
> > -      * exclusivity.
> > +      * certainly not because the swap entry indicates exclusivity.
> >        */
> > -     if (!folio_test_ksm(folio) &&
> > -         (exclusive || folio_ref_count(folio) =3D=3D 1)) {
> > +     if (!folio_test_ksm(folio) && exclusive) {
>
> Hmm, but KSM folios should never have "exclusive" set. So I think you can=
 drop
> that as well (was only relevant with folio_ref_count=3D=3D1 check IIRC).

right. will drop !folio_test_ksm(folio) in v3.

Best Regards
Barry

