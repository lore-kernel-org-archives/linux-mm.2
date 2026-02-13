Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A09EF48E6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 08:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6F56B0005; Fri, 13 Feb 2026 03:17:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76DFC6B0089; Fri, 13 Feb 2026 03:17:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6666B6B008A; Fri, 13 Feb 2026 03:17:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 554AC6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:17:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE4BAB8C47
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:17:56 +0000 (UTC)
X-FDA: 84438730152.02.2E65CF5
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 318E3100003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:17:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ejg1beT4;
	spf=pass (imf14.hostedemail.com: domain of 3Md6OaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Md6OaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770970675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDWU1Lbtd0nhdeSahw2pXDytysBYHevKMggJu6wq/y8=;
	b=1Tp9d9YNI46c3kQ6i9rZpcHwXU4W7OSbCMH6QxQDpORa/eysQr8lKqOCYMQozhjB9xbVMe
	W87rIatQDiZnXV/kTFEYVDtbx1Ji3qdI8OgVPlCFriP8n79nR2dcqVgZNc+P/fIwGN8ozt
	SDEpFLlQFFVG6f693sUkIl+bK6WH2rs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ejg1beT4;
	spf=pass (imf14.hostedemail.com: domain of 3Md6OaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Md6OaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770970675; a=rsa-sha256;
	cv=none;
	b=8CMn+SghP9LBa1M+sRzvzq0oykffZb3mIpZVUjHaaXXxzsr9tx0S/FfS81kBJUbz5Erfpr
	FtMofWtn/LwZe0McXGe9/DPKsyqJIdahfFEs9MxPHTQ4aoqgD32U2h+5Z9x5sUlXSvEYNS
	3a2KhIB2InDf92xt726P7qHiBO4KO+Y=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836b7c302fso6957015e9.1
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770970674; x=1771575474; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qDWU1Lbtd0nhdeSahw2pXDytysBYHevKMggJu6wq/y8=;
        b=ejg1beT4lkC4Pxkgz09eSwWfbU1doACrjoMz9i2rUVDEJdUCG4Er2j+DnnbjzLk0yR
         OrWJ/VSeDqjcqm6co+QsLBY3iNxRdaW+GZs2k7PZC5HPU8wcVEprDLaG0WJa14zu2ilH
         7KNlhkK8zTtqgahk5ub9GLG4QyVfUWGYSW5YSpEQTkM/7ysifgCQgoHm1+hAiuOITKVv
         HzYDWqtdRCK/Johm1cHqw2m3459EAN6mzVey9TgOOpnSFVy7QxCHsEhV0QX/AEsdEokI
         kaLKzl9pxglxkxYUYd0MKiwUIg7vGr/znXbkbk9NA1P3e28at56x/k5dWBY+M91QAFs7
         V14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770970674; x=1771575474;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qDWU1Lbtd0nhdeSahw2pXDytysBYHevKMggJu6wq/y8=;
        b=akmKkx5NMkMX1WRHnajuhz7RZLUbmmr0rZPPIb+J7mAGDRqmM4tpu+oemdeNeLTlaw
         c6gMwY+oVx5w3y/0WAetAKyT8J8VI1uNQAB6H8PUFszB3qZeVB5xT/aiSCSfvhSqslpJ
         6Sn/0hP8d2jx2Fh+CadOURSntXWFVVnY8/akx+FBS+3RjaLHbxlaDMidfMne8fGHbu+Z
         LMEj/aUCmtu2+Wa6OCHmCIQcoBrh1MVlImEtMI2GXxWueM7PrD05+CWddbFIf9YVnBEv
         0i7UH+PM6inu7RSGSUxDQfZa5xwUMe2hTHtZc0kkhrDowJVPT0jDaXA8YdAYmtIbV44c
         jkyw==
X-Forwarded-Encrypted: i=1; AJvYcCV+p0rtz0DG1tfh/jzbNlPFm4pgFMF/CLUD2L3r/ouWKelz8QjaR2eP2GD7JP/yAPsKMDGKhMbzWQ==@kvack.org
X-Gm-Message-State: AOJu0YxKBuOcNdEZ7i4jRKVwrb4Q7Fngh7jsnwtFmjWnAy7hCF4+5GGK
	wDsAMv0SPr7/vCNbrRLhe0/VNs0X81fKzJWAK8qrNkpf02clx+7Tx+piG0kTnzzUUyDa/T3pUI0
	8U2aAOxbpk61TX/RirQ==
X-Received: from wmbjv13.prod.google.com ([2002:a05:600c:570d:b0:475:dadb:c8f2])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4687:b0:47a:935f:618e with SMTP id 5b1f17b1804b1-48371061414mr27181855e9.15.1770970673570;
 Fri, 13 Feb 2026 00:17:53 -0800 (PST)
Date: Fri, 13 Feb 2026 08:17:52 +0000
In-Reply-To: <87seb6t9t7.fsf@kernel.org>
Mime-Version: 1.0
References: <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set> <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org> <_ZaFqe4HzW4GSDQTrXKDgkSCr7L9bxUh-h5QPqVlMUHSvE0oRFuZJOPi0JItf3VJXHmaX4PA4QWAGBeG73cJYw==@protonmail.internalid>
 <CAH5fLgjfSWfhUkmG6_ugue6Wp5LKtkEFJofWViJSNByq3sO2Sg@mail.gmail.com> <87seb6t9t7.fsf@kernel.org>
Message-ID: <aY7eMIhkPJ3wXD51@google.com>
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 318E3100003
X-Stat-Signature: z5tnau5jxjcm5e6reimwhth3az78kwxw
X-Rspam-User: 
X-HE-Tag: 1770970674-5254
X-HE-Meta: U2FsdGVkX18jO4kUvNXBiFrYpB1tzIXepJnTwLPquJMVaTJ3WSNke4SGtrpefYTeRwKu0oXjyxya/i6ajWVniW7Yl7/w07ruAMGP0hrGJsyywoLV2npYv7eLm3tF85LupCi7viLW4gTRA5+in/7dGD72be9dMUrdfiG0iiSZ14rqBYpQUTuFk3SVl9s9Nx9edUMwzj1ZSC8qE/CvOD03P3xjRjeU0Fe5tIEZdzBtwpfwZ0Gbavxy85jqUdrFoFx8A25YTueqcPDndb6FY9bijo3tUy2+FG6PfSJmEmH902qKMygwxfiCOHED5ugfJyAJUINVZqOCUEii8Q8VgaRbb1y3I0s+nJeWUScurlAJ550PzNSBhkEOdI7D0yQRQcMPj+0rG8w6cQWH+4s677qwpbeuA60m3ZRL7LbncXbRTZ0EoYkm4MKngCl4DMo3MXzQKGQ8vczI303KowNNXtZEQJVmu/J9laMB3xnuXmeijWu2soglsh+IEkPt2ba1dRPCup4WnncJiq9uRssezf0ivo5SjOui+5YVDggYoUe8HyazGYCSmeiWi7HvJUImUg3SoSvs7SC0LMe19Z4sKWMtCDytLh6W1bleQzD6gX8q39r/8K0x8+Dfusuac6bSLcbhxzCuKwwp6n/5F4sSQGea50Q5xFGvuDdwpIYKyq9s/geUlgmEfeqYeLi3p61SZeiS5Fvd1eF6oPQVmTkVzkNbuWv7Vt7GjL5QlyuZ+M++S63ywWb0QCBbbsvxE+9A1S1ygouk2D1jYHyMV/cSLgVYe9Y1k4TXXV9WkVpH2IrCF/dHKpykEURbCwXQGdpNsgZfF9j7BTR27BtoeWyfqQmI92Bg5N7tsD5wxLNXyiVeYSN9VNfmgMwUFtJszcEHmwiGaoXaj2sh24fA5NwP4fK3NJ1e82udK3IBW2kFLrVNsMkZnn/iiyjQYinoyZhNamj4ibHSctQxG8/zirBpi4p
 qMAZwCii
 tI1Q7Q68IcgpQtGHtKQnvw38Ks8tZ8yaNN+Ze4f6hOt/EWSZJPqLZgwBRem31NIyJJS3Y/I0BW/yfz6lFrE7K2SlRj/E/LfosbMfoyRvIpP6+U/9XOTrzR9PgSY/NZGc3lea/3hn6+K+qBh86CPp2wddxKUjc1FpZjykjSmsxzqQD/ZuN6Oetj+jtv/V/o0syjpZF02gmczlkWhF7hUpEN2i7h6KTDEXW7vGJMjj7s1fLAdN4SGpUcw8Ze0plI1FDj8MYgNuBevt0p1lhS8xJ1VK3HAsCtGT7LbXUqZ1IxYzU0rRNKfw9llGRqyxN0r0Q2uBJJB3bzLi8nhcgsI0+7HESRZcbatUZTGefb2QUY7vu5DYtSFUrt3IY0Eb4aQpDZBumomC4cGZU+wQCH9BO0HDea3TGGF3OqspRXrChfzN588Nf6A1eqho822nqly77lo6THdj7Ro4StarwbPRZfV/cWslV3u9uhINylBlK4YIaVP39QqjdBGweo4tw7TKSyXCg6rTyTd4sQlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 01:39:48PM +0100, Andreas Hindborg wrote:
> "Alice Ryhl" <aliceryhl@google.com> writes:
>=20
> > On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg@k=
ernel.org> wrote:
> >>
> >> Andreas Hindborg <a.hindborg@kernel.org> writes:
> >>
> >> > As far as I understand, this is a borrow checker limitation. It is e=
asy
> >> > for us to look at this code and decide that the borrow on line 51 wi=
ll
> >> > never alias with the borrow on line 49.
> >>
> >> I did a bit of googling, and this seems to be a well known issue with
> >> the current implementation of lifetime analysis in the rust compiler.
> >> Apparently this kind of code used to be OK [1] but the Rust devs decid=
ed
> >> to remove the code that allowed this, because it was causing excessive
> >> compilation times [2]. The upside is that this is solved by the new
> >> lifetime analysis implementation called "Polonius" and it is the
> >> intention to replace the existing implementation with Polonius at some
> >> point [3].
> >
> > I believe the standard fix for this issue is to provide an entry api
> > similar to HashMap::entry(). See the rbtree for an example, as it
> > already provides such API.
>=20
> The example above [1] is using the BTreeMap entry API to produce the
> issue. Are the BTreeMap and HashMap entry APIs significantly different,
> or is there something else I missed?
>=20
> Best regards,
> Andreas Hindborg
>=20
> [1] https://lore.kernel.org/r/87y0kytggx.fsf@kernel.org

Hrm, tricky. I think it would work if the entry type had an into_map() that
consumes the entry and returns a &mut to the original map.

  fn transaction_impl1<'a>(maps: &'a mut Maps, key: u32) -> &'a mut u32 {
      match maps.a.entry(key) {
          Entry::Occupied(o) =3D> o.into_mut()
          Entry::Vacant(v) =3D> {
              let map_a =3D v.into_map();
              let value =3D map_a.first_entry().expect("Not empty").remove(=
);
              maps.b.entry(key).or_insert(value)
          }
      }
  }

The HashMap and BTreeMap apis are not particularly different.

Alice

