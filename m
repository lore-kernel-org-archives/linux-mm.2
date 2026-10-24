Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E660606A321
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 03:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=XlupHKHL
Received: by kanga.kvack.org (Postfix)
	id 5A66C6B0B77; Fri, 23 Oct 2026 23:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556C56B0B79; Fri, 23 Oct 2026 23:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470586B0B7B; Fri, 23 Oct 2026 23:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22C1B6B0B77
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:30:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EA1A1C33B9
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:30:33 +0000 (UTC)
X-FDA: 85356092346.26.1A39CA2
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf28.hostedemail.com (Postfix) with ESMTP id 861AAC0006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:30:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=XlupHKHL;
	spf=pass (imf28.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792812631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxREnxXFL74zEXnlXFVXWPlkVOMBFqhGQRo3iyJ0jLE=;
	b=DTeK6VAuUMNP0u+s6Hxf+MdqucIMYwASWi9FEd9+ZZDv6osnC0YqtIlYBbAUPfizZ4V5E/
	oN+6DCCu1lZkI04cD+V9JoWuqslUdE1LbrgvOWrmsY54EBy1zxDTzt5Na0/D4vMWTLY4xY
	TTyl5q2TxqVJQuf8Do+7VUJi/OGl9s0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792812631;
	b=P3rT4fOYjR03fAqmWcGNx2Wgodb3PdnhpXCt9wS5HumEFTETKQEAAQZqP3PBzZYMdDNfwl
	2EZjUCv3OodxW9wmPaLyxVi67yVupN1ua960iQJ0rUun0RswySuW61aZIYmUImpIqeyXfA
	csf9eg75I81RMPBrS0zBGUXGmITOjWE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=XlupHKHL;
	spf=pass (imf28.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DxREnxXFL74zEXnlXFVXWPlkVOMBFqhGQRo3iyJ0jLE=; t=1792812631; x=1793676631; 
	b=XlupHKHLpRFmdluWHfjziaHaQxpnzyIc15B0KGp+IoxQJED0J9Erd/yDzNGAseaEJ0Wx8wo0OSg
	aNRoZl8uJx2PbB7LvwxFu/uHmfJWiUqKW1GrJaBcXbc5s9OzwOONJL51e71f75Sgw/gq88eo1qU3k
	+MiB7VDXOgoA74MXJ0EkGeKZW6amuAR9M2LkN8/QdY2y1XkA1ApHnpYf7PD9KNLjQsvcbQJvPvwCU
	x5T//BAry6XuMSJtevZaCST60tpwg8Z29ZAdcVj/4Q2NVRiv9gZj1h8nvilpyEuiBm40RPJd1Ej0j
	+px0EfzXuA4PHi1AVAU/RxYa9zX/0qCUCdug==;
Received: from mail-dl1-f53.google.com ([74.125.82.53])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xKSSk-00EHeh-IH
	for linux-mm@kvack.org;
	Fri, 23 Oct 2026 23:30:30 -0400
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-170135e43c7so1616378c88.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:30:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByEECNvoDKfNN0wVBcxsdQtoO+B+0AmFyNlWveADWR/Opc+9tn4UPMOH/P5PJpPl2g09c/Ps1prwA==@kvack.org
X-Gm-Message-State: AFq9FYI5jq2bGyI6H0X+86Ak+ia6LXZ04St94Q+o6tKro+t3LwH9acTg
	yqGOF5+1gThLNTkYLW241w5tHLisUKFs+ZRj52oeuEN1Cx9nCvtZdzluCJyZVYyvaS/iBOKxEZx
	kTxTH9fm3i9elt2IhLjIAdA1wOaxg4uI=
X-Received: by 2002:a05:701b:2915:b0:196:e254:db24 with SMTP id
 a92af1059eb24-199375eb26amr1030037c88.21.1792812629421; Fri, 23 Oct 2026
 20:30:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016222721.791785-1-nickolai@csail.mit.edu>
 <atZw_gtMIIKXgc1q@bfoster> <CADGQE7H91ZwPgUzPHoAJmF3WjzRKxeQkQcV8+BLdGn7+kkEduA@mail.gmail.com>
 <atdHhW7JU8j5pozl@bfoster>
In-Reply-To: <atdHhW7JU8j5pozl@bfoster>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Fri, 23 Oct 2026 23:30:17 -0400
X-Gmail-Original-Message-ID: <CADGQE7Gaw9t14nOr_FYcT4d5y+VEjX+oSgkQoNWiNtomCfkVRQ@mail.gmail.com>
X-Gm-Features: AclHuK8U-00Ea83CZV1_hG7vFrciQgbpxapAyoOn_d2XFtjDVI9f8nU_G2FcSqA
Message-ID: <CADGQE7Gaw9t14nOr_FYcT4d5y+VEjX+oSgkQoNWiNtomCfkVRQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/truncate: fix the zeroing end of pagecache_isize_extended()
To: Brian Foster <bfoster@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 861AAC0006
X-Stat-Signature: 8hrb4h3nx7gbz1ctpgi9uj554n9fm9o1
X-Rspam-User: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792812631-973441
X-HE-Meta: U2FsdGVkX1/rQzqcMbAX7nkLBqwz6W8MlNaaVlM9yKKeznu4rSuMorgS4TEyKWVs1UZXter1fL4qq0VAf3el45HZOIHQ/efKA1Uwm0ETjUI6B5ktPsVfxWzrS+sI/mDQT3LI5MBOsCHkw5TZ/I6pYijz5ILQUTntnE9FnmbvxHpGlV6hq2HlOSoLxzxFbOcGA2QykRtn8p7LJiIQZjZmTxM4XUyWPjmsXhvs6tGRgkYW5vR4bMcEpqyb2c2onnZ6OTkTjgGZQycXFa3meUnyzNyf8wfP7ueeDQ4oFx67Oc/ejbHXL2XY9WQr0j6coqvRC3MI3W9DfSgD6H9Iv3fq+TAXQAxJ8k/2+bDEmeIP6cEur4Txe4H0X7DS8jPKccdHoXI9if/vKy6Zmb/0buNJtTsfoFuEP04P+RzQ+T+U//5DyUG9J9e8EYj6N3V5LmAAvCTUEzIZwi/2phxccecpoynUKMSbo9qkppGuKkTzql27nT1VlUUdbZC8sbgnGxsx/9/tCfY1ec1AR4/uZI5/dur8fToYCNnyNpAAQlmmoq3E7Lvg7xv/xNNAcbmZyQvU0ixVBJ+C5SuFVzsIjmPPaUxM/qcZEUB4tCAO5XeugXPnVD23LYtR3G+Jkwi11Bc/Arh7V0zYYCgm7giaJTQHPR1TbtszF/TK993J+ewgkDnyalTrdSFvuTPR1bgsgNIkskxaLOWs6TKL13IRBQotOIg0Ovh7M9+L0re0+QtINAfX46CEn/Rtds8uCetMf02KgeNj6Ooa7IkCUe7gFvdzv8BkieLwFYaxk4E727MoAFuHawMFQppTQl8MTr8mEqd2Zx7Q0WpSrh9qPOFnr9HkkpDVhFmtr6NwH/8Gy3Vc+iF3a2LsGSgnfPm8/FU8OeAk5SUE+3aCMSOmVt/3E7t0FmW/pXGBL+lrxsCjP6vs9NWkFEK3j7iG5zlclboROLXSBivcJUQPrIbF8jSd4Rr
 8JGfvcGj
 acApaBDpfWEGErfAxXZsPjowGpggmgGYCXtqDU16Sy1cyhBvZqq6ACCr7ed6epfI8dmAK1m9PUsqZL6b5f5FKYdk6GXs8IBZiahTTwHusvT1nI3llZty9aP5cweOsmKN1Q48OlOFiFW0LyrzNGBOJpzBrtLPmvj5A9ImHG44wv0aStJUPVLAJqjBhru/0rJFhkW5XqKKrCIpmfKUjBjCL1zATvC5YGtlxLb0j6lGfOiQta1gdipwsuQklF/Azb1Hm+x+NFHQx/vGknb3qNO6gNeV0VhvarWtUi1augLFJz/HMqZBTstKpOFinyiuB0cKbcmtQVuJ/QVlOW0Rq7A5oXHzcPYLifri1j0WX28y6pvIFzJHw9i4SneDxNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 6:51=E2=80=AFAM Brian Foster <bfoster@redhat.com> w=
rote:
> On Mon, Oct 19, 2026 at 03:54:14PM -0400, Nickolai Zeldovich wrote:
> > On Mon, Oct 19, 2026 at 3:35=E2=80=AFPM Brian Foster <bfoster@redhat.co=
m> wrote:
> > > > --- a/mm/truncate.c
> > > > +++ b/mm/truncate.c
> > > > @@ -878,8 +878,7 @@ void pagecache_isize_extended(struct inode *ino=
de, loff_t from, loff_t to)
> > > >               unsigned int offset, end;
> > > >
> > > >               offset =3D from - folio_pos(folio);
> > > > -             end =3D min_t(unsigned int, to - folio_pos(folio),
> > > > -                         folio_size(folio));
> > > > +             end =3D min_t(loff_t, to - folio_pos(folio), folio_si=
ze(folio));
> > >
> > > Good catch...
> > >
> > > folio_size() returns size_t and folio_zero_segment() expects size_t f=
or
> > > the offset params. Perhaps we should that instead of loff_t?
> >
> > size_t is (unsigned int) on 32-bit machines, like i386, which has the
> > same issue (reproducer from the patch).
> >
>
> Ah, Ok. So loff_t makes sense for the min_t(). I do still wonder if it
> makes sense to switch offset and end to size_t while we're here though.

I believe they're always pretty small (bounded by folio_size, which is
bounded by 2^MAX_PAGECACHE_ORDER), so size_t isn't going to make a
difference here.

Nickolai.

