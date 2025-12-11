Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0479BD3E783
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 00:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61ABF6B0006; Wed, 10 Dec 2025 19:22:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F30A6B0007; Wed, 10 Dec 2025 19:22:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F846B0008; Wed, 10 Dec 2025 19:22:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 448696B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:22:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 958E7133EDD
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:22:06 +0000 (UTC)
X-FDA: 84205287852.13.B2A496F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F06311A0017
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:22:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rqe6UzkZ;
	spf=pass (imf19.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765412525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ybb6B9zUCkxqay2LUJs7i9guib6JBGoNoiItJmOjNA=;
	b=HJ3mS6F5KLrgkwasLxeqL4RaCABq26yx51fLOb6gqFWKxfWEPwKICFY2So4LZj4Bv1SULg
	l1tSK2jlrdUVTc0eqOopzaPbm9e6VwJrVerZVlMBHHjJmt1glyQFvx6kbHB8CzOsWCggX5
	+LEjT9Js/NzPL/uytT1CgusbIanfkaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765412525; a=rsa-sha256;
	cv=none;
	b=mrGh9ghl1YWQV0Nw5BtW80+a315Zu2ZKRvBntjBTmpZkmry0E16w61jegtlfgQB61FfYMk
	EDxmR2R0ajdIwtwZ9uLsJoekG3aEUi5AHNsI9YpD/mTwk+BmQ+m6C5QaPFNOO7wmDXUCxu
	AU7oogz84yDc4uqJfTQJ0yxcP9vfdsI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rqe6UzkZ;
	spf=pass (imf19.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BA4860122;
	Thu, 11 Dec 2025 00:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BED0C4CEF1;
	Thu, 11 Dec 2025 00:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765412524;
	bh=RPl5WnXapSoEpkolaJGlgnCo9f6ZWioOSypmBl5OQ2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rqe6UzkZ4XIgCo5fZ2Vn/2anaRyCbaGxCqzFHStiU2uTPpqi1q6PmKY955a0yU45a
	 3G/BIL0IKVRq817mjInN/Q4Hwa1bezY0e7aDNZpHuI6zy4hNaVHuRqM3PBIx2sp3//
	 7X+O+amkAnWf+tnvHbqnLrEEOMZN37LHT4/UOjLbokrTq3AxsBbkAnQOuz+wWDZzfJ
	 KC8UhrGpJWoKGu2UEF9ffgVrAla59R4cHvcO5GOp6Q9u8M5KOwamxn5Gzq0LFhNpSL
	 MZTpbDTXLyR/Gyk7e/UDxJ0VW9gBsHJCFtGKTl60Bay6nPd8Lo7P03ALBZIswgPgIO
	 +BQv9dIiI7wrw==
Date: Thu, 11 Dec 2025 01:21:59 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wdgm72fj63kh6hzs"
Content-Disposition: inline
In-Reply-To: <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F06311A0017
X-Stat-Signature: u9yyaqt9dspoeut6hcfdmhdkmifofrsz
X-Rspam-User: 
X-HE-Tag: 1765412524-402159
X-HE-Meta: U2FsdGVkX1+bndaaQnFxrZvNCzmDQfOIMWkYRydJo7ELhKUTJ/dfAt6VsH5dSOT/4tZaab/aNpxEP5UCWpldqzRzyd2uqVuzqMFgsu4qJqIp48JiodhDWWSuTdR31Dy61fsi5PfNiN2DJXSjbxRl7d/0WJRPfQpajG3bFiiSPzV1iFIomcOuCMDGcj5Ua3xSttRMsdaa+qVhqupSG+6aUTjw7aWM8P/E0kt3qYnv9HtcUSIFK3AOfaQXLNtu2DCPsEB7IxL5CqG9y18pQ84+OPtxHF3dFVvAPowDvb868YAzu34LAoZU91/42da16rOuair50PLXPV1d2wyeaYrj+KtXHBavNt7AdaKbTOb7S2DsTInm8TcWWwNK+mi8NLKnEoHesseE6yVAgXMn/lzq2csT1hwm//vQvTt387bbylhEZX/iW3Mk3uIW3obFsbJvhpdxaQzsX5P1JC30gk3zS7Ktx50pnz7l4cnNfGZa3paWOtnlRsap4BMYRuwlSNmBel4/aNJ505D1oRqrtNAWfcPxw1jKzeZKxYjnmk3GHS2ZraOxZ+e42mWYO9varJgoCGngXN6YvBgOQrB7CQt2tWNjY5zgaAm+zkRlI0asOpzCpFj+n/n9XnSv8/u/GWTtbfTotyr8r8smd/bNQeaXsRxXnbLdd84hLe1bRXFC8auv9AGm/AFrG/bfJ8kq5EsuoAh1ZnMpA8lepU7QIgu898Ty7B1DJFsgYIu50g9NIBLKtlahASaZzfuk6b/Mpf7hXxoExjvnimk2jzYAIYsBJSd2eHag2l2/IFxRuZ00abdBEmHG4vRXNl3FtWihPn6FXioUCx/qCCYXpu3whJufgq34JxygMRJ14FgM0VhdL/G6v1LvcEKOrYXZjmTb5ChAN7nuYiZYvBhL7quEbWoLaFq0ZxDXxiKfNje+DbiG+/VGtEUpLMlaI53ZXz+VIyHPs5Nmx6BhOotJZsmd6z+
 h3U8zJwV
 rj85RiQxCzESabJk5oBk1brgGsAyA9PWyAje6MXZ5YxXoOZ1w6kIDqgz79qofQYmytXvCg3C3h5oSoJV/QHDe+gDSxnfRs1xMbbUY4tDMFiYq1JjPy/vH3GiIEmLzQqi5cHxpc87gfIsHu59vZbkQiu/ExEtPt/6E/6/CQbBCyf0hTl0LE+rzcu74SHnxxdojd6bFd7PEWELe6o0SI6Cjrwy4GC4u5C+m+X/pRijPyu9xaWXmIXnI3JwSjrfPwsWbxzx/fIe/zbRd5EE8sWWQUavciXSmsRAKGUG208XPt1VcVOklsjcL6pIt6ANDJH3e0UZ5WziEqS/eLAemSnzKmI6Z/Yh2tW9m87Ky3bljK0F0cilLW1FIjm4TMu+Ne6C6PiBCrEUiEPGTBn9jE7/Tw/HQH42bvS/0XsU93uFyL3jX/bS7y3G25XpNmIkNV5ZOSEkbQffx1AFNUd+trqkTNzh5fgwgumbEYdw07NW6CP2meuBzXSTClzErRXupB7tn0dWah10g77Q3Db9Vqu8102GHIkmUCwsUN2o0bJvWQVJ1TPiIAAtIzFJt9cQ+LlCq8Vzn6MmlHXc3ZFiIbby2fPpD6fc4ZARPcVsgHGexVImr0eA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wdgm72fj63kh6hzs
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
MIME-Version: 1.0
In-Reply-To: <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>

Hi Kees,

On Thu, Dec 11, 2025 at 08:18:56AM +0900, Kees Cook wrote:
>=20
>=20
> On December 11, 2025 7:46:49 AM GMT+09:00, Alejandro Colomar <alx@kernel.=
org> wrote:
> >Cc: Kees Cook <kees@kernel.org>
> >Cc: Linus Torvalds <torvalds@linux-foundation.org>
> >Signed-off-by: Alejandro Colomar <alx@kernel.org>
>=20
> Hm, this seems to be missing a commit log body?

Actually, there's not much to it.  The patch uses ARRAY_END() where it
was being open-coded.  There aren't any bugs in this code, so it's
purely cosmetic (and of course, to prevent future issues, in case the
code is modified).  Maybe I could say precisely that.  What would you
say here?

> Are there other open-coded instances that could be replaced? This seems l=
ike a great task for a coccinelle script.

There are many, but I wanted to keep them out of this initial patch set,
to make it easy to apply.  When this one is applied, I could work on a
second round that replaces more of them with coccinelle.  This is just
for showing that this is beneficial, and to make sure that you ask for
more.  :)

Also, it's easier if there are few maintainers that would block an
initial patch set.  If restrict the patch set to a few files, I don't
have to deal with many of them.  Once I get used to this, I'll deal with
all of them.

>=20
> -Kees

Have a lovely night!
Alex

>=20
> >---
> > mm/kmemleak.c      | 2 +-
> > mm/memcontrol-v1.c | 4 ++--
> > 2 files changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> >index 1ac56ceb29b6..fe33f2edfe07 100644
> >--- a/mm/kmemleak.c
> >+++ b/mm/kmemleak.c
> >@@ -510,7 +510,7 @@ static void mem_pool_free(struct kmemleak_object *ob=
ject)
> > {
> > 	unsigned long flags;
> >=20
> >-	if (object < mem_pool || object >=3D mem_pool + ARRAY_SIZE(mem_pool)) {
> >+	if (object < mem_pool || object >=3D ARRAY_END(mem_pool)) {
> > 		kmem_cache_free(object_cache, object);
> > 		return;
> > 	}
> >diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> >index 6eed14bff742..b2f37bd939fa 100644
> >--- a/mm/memcontrol-v1.c
> >+++ b/mm/memcontrol-v1.c
> >@@ -1794,7 +1794,7 @@ static int memcg_numa_stat_show(struct seq_file *m=
, void *v)
> >=20
> > 	mem_cgroup_flush_stats(memcg);
> >=20
> >-	for (stat =3D stats; stat < stats + ARRAY_SIZE(stats); stat++) {
> >+	for (stat =3D stats; stat < ARRAY_END(stats); stat++) {
> > 		seq_printf(m, "%s=3D%lu", stat->name,
> > 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
> > 						   false));
> >@@ -1805,7 +1805,7 @@ static int memcg_numa_stat_show(struct seq_file *m=
, void *v)
> > 		seq_putc(m, '\n');
> > 	}
> >=20
> >-	for (stat =3D stats; stat < stats + ARRAY_SIZE(stats); stat++) {
> >+	for (stat =3D stats; stat < ARRAY_END(stats); stat++) {
> >=20
> > 		seq_printf(m, "hierarchical_%s=3D%lu", stat->name,
> > 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
>=20
> --=20
> Kees Cook

--=20
<https://www.alejandro-colomar.es>

--wdgm72fj63kh6hzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmk6DqYACgkQ64mZXMKQ
wqnO3A//Y/44NuPwFdMR93aY92M4uji8XMPgUWUuBllAjk0sc7RR5iOv7UZSRCBv
4zGidrjrLQxN7pzXPjGPO1vfQ1w4NB1jsNSHN9Pwh7PIwM+/Qhr2t7XZEvv5drCI
VifTsaRtdmhH9qXLDQaMKdl8idazStL+jLDkB+97t+DEH0n4eiAvUSEVXr5BPJrF
4z68qYvzJIpb/XY+5s7t6QYmCcfmjPmj/i623AttoFEXPQD83itK7+3+xvtdOldF
GWBk1IKbPzJseusCDpV0P7jMs7E/sTeY6386psYc5pWMx7I/Tw3X0tM5zdwAOTPW
RgXE57lqIXQwvHXEHksdrBvqT0bNa6L/x5XTc4yUuE7kvt+Ba+QTVRfzo1MSFOht
ROjsSotDmC7UTfqI2PPV/f6r2eItGbwKsjr7+YU2RMjxaiLnLA6PduBbArvIlwOF
J7zNK79bvLEXa91Gw7oD4bzq3mUxf4TLQqC0ASpGpFMFgrVxqMKRWYvjRIXwU3do
AgE6p5KaOwWBCL3Rnsj7hRPp+EUf/Pe0s4/J8UEMR+FOCt0Hjt56W4bjq2i0bhfl
m5rcREdyj5O8mxSR79JrjykIrI3dcwE1i+nFZT8sa+k0IduVmVlkHvEyl4IDLE4l
1e0JAS1KNk8NpqJPaEfhQ/0Msg0XZKC7Q8kqGxbLo0tYB7LnOwo=
=niXK
-----END PGP SIGNATURE-----

--wdgm72fj63kh6hzs--

