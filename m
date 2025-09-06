Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA9FCA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 14:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837B06B0006; Sat,  6 Sep 2025 10:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8BF8E0003; Sat,  6 Sep 2025 10:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FDE88E0002; Sat,  6 Sep 2025 10:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D07E6B0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 10:59:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DECFE16055E
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 14:59:36 +0000 (UTC)
X-FDA: 83859134352.15.AC04FCF
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 081F240002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 14:59:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="El5u/stt";
	spf=pass (imf12.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757170775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQvX6M/SCpwCBwbFUlxqcK5BetnvxrCVF4KsXyyyLn8=;
	b=DsxZfU4KYhZNsApZq6woWhj41zts8iM9SRRG1hoZ5/LlKqIft7GcQK8qjj52+cl5FhrUec
	9sEOGQ+yMGVBL0Hn5WFI6yw8sGhyyESHLA0oUUcLPzU3tX05G6YOhIN+rcDpTUiXZdsCUX
	ZuKHfWKO1J5/EImpZQBzyOXQXem4otg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="El5u/stt";
	spf=pass (imf12.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757170775; a=rsa-sha256;
	cv=none;
	b=qO/o6JznywMJEWiSewctN6r+FFjJw9xnmUnUlik+f9VtaymbqPVcb73jqtxmaYQznhwJue
	UCAhb8Zxv89TsFgs2ua+vmPaH1ydID5vXCp6oytnG0Ddt5VYHdvqyzmLStRoV4Rf5rFTqF
	Ami/lo/weZf8SEDQwn2CLJJEr/HK5Yc=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757170771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kQvX6M/SCpwCBwbFUlxqcK5BetnvxrCVF4KsXyyyLn8=;
	b=El5u/stt/6KWufCnQB4xz+7QvpdTfvjNfSSY/a6Zq6PbLUvnrZ97iCdZrFgTJxaUFUy4wC
	qRg2QUSOCWzcq3ydn3KlgkUvlGCigfDZbQIPROfuTHm/Cb6k1m9dasXtNuQ5eyCSd+1FTD
	agcXorwi/XMcmbi8Z67R4Os88hjt4Jc=
Date: Sat, 06 Sep 2025 14:59:29 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yajun Deng" <yajun.deng@linux.dev>
Message-ID: <405f6c44b4214ff466743ed94d16cb2fbea1b7f3@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/rmap: make num_children and num_active_vmas update in
 internally
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 riel@surriel.com, vbabka@suse.cz, harry.yoo@oracle.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ifsfk44so7ychuu57mkbhujjl4lh5bxt2ufdseskunxsle366@3p6oo7qulwef>
References: <20250905132019.18915-1-yajun.deng@linux.dev>
 <4ifsfk44so7ychuu57mkbhujjl4lh5bxt2ufdseskunxsle366@3p6oo7qulwef>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 081F240002
X-Stat-Signature: 73xkjqix8ur75ehn5qhbo388yq8qnxxt
X-Rspam-User: 
X-HE-Tag: 1757170774-187227
X-HE-Meta: U2FsdGVkX1+exuPQbGnzGSkwNkDIrSi27pey1cNDd+9BxlKP4A/vNvczoM+leRPkjxCRkR5Wqa6HoJFURue6hJ9XhEfaTQXDXeN9gt94MUHEmPmyE6Bbks2WMqPzclBll2lxLwrgzIae8kz/F1Ii5WZ7YrarZjSDzYS4+73ko/A7Y+zVu5sem7fJk6p0Onea9Z9T50agBAwURFQK2HPmP45j528khMG0MvHH8nlIcybDPVXkSFbJrz4raM86A2mB8yDvUHDvFXZruFw7NaoZFL/+F+oYPeIhCxBMp2OeXe6j9HDCZ1Dm6nY/p8Qq83I8hGdKdUZnx662BpkoMouL9wD3Qsr52Iw0Z54Jx9fzFiLRRN5smRLXmr84bDVy+X5jscMiGcNhnU0hcPFzieW6orF5bYggxNXG+KnN3Vra1Idsjho7ZOYssII0eubIG2CT/FnAQQ/IiGR52NGZetN9FDJ/CFK9NDtVO2Ap4hZhCgIK9vvCgeRWUGKHw3wdx56s2Mbdu7lT2RYr6mk/cYt1UbuGIBvoUnre//GhvfQWsdifjpgyRj4EV5ZBS1vjhLGzcpu5DK4E6JiraN2tC+kdWiIhvvhKO22/k3xMEjCZPuCz/7dH39qn2DieGLHsPa59nx88DKtUq6pyy9ujF68WySWcuW1e9hY52loWkfAzGvTnxOkp/rvPYIChJzmrWKYiKgUKX/jZvnlWgL0FVNQVMP0pm6kMbcPEa479v2UIfKzLDi2r9jUgkuvkdwEwu/MO91hoNC+TdqtKhmvKsk7JG/qF3GZixi2GH9BhoviV93Dw2tFNZp8C2hEjcfiKbvclHhcIEsUqAdD2sPeCBKK8b326ORKZxW4cSBk9jUlmVquxQlzBl+XVLjfW7Dshe5jWubEVmL2Rj11AQgoNGNlb08ErdrKjfmcXHudJlGeHl3dd146sGcm1+tXtoXCHgaxkyTmaCWHsbf8Lq5Lbfau
 q3/rwWXx
 nRbgmrfi1cHdykBK96NDWWxrT1PlaR8Y0sq4fao1L6KIZJdZm7A1sfHZ6EP+QYAKU4Yfua9vV422Mi9w+3uO5rPuMuhb2dFdL8eiP3t4xP/ByOuVcebi2IRMRBrpUPUSaHd6akrlbhki4OY/p/plZIDVhAADiu2HYGC4oycGtwrJxKyD44yDJfhJfIrfZSwvHwNqILTldMtb3wlGGuo2dC1lXst22zF+in1glRT52FGqK0BSuVB7K5fhUjfzBjjt9hOUUX2BBkEaUSVYphcjZnVXE3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

September 5, 2025 at 11:16 PM, "Liam R. Howlett" <Liam.Howlett@oracle.com=
 mailto:Liam.Howlett@oracle.com?to=3D%22Liam%20R.%20Howlett%22%20%3CLiam.=
Howlett%40oracle.com%3E > wrote:


>=20
>=20* Yajun Deng <yajun.deng@linux.dev> [250905 09:21]:
>=20
>=20>=20
>=20> If the anon_vma_alloc() is called, the num_children of the parent o=
f
> >  the anon_vma will be updated. But this operation occurs outside of
> >  anon_vma_alloc().
> >=20=20
>=20>  The num_active_vmas are also updated outside of anon_vma.
> >=20=20
>=20>  Pass the parent of anon_vma to the anon_vma_alloc() and update the
> >  num_children inside it.
> >=20=20
>=20>  Introduce anon_vma_attach() and anon_vma_detach() to update
> >  num_active_vmas with the anon_vma.
> >=20=20
>=20>  Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> >  ---
> >  mm/rmap.c | 63 ++++++++++++++++++++++++++++-------------------------=
--
> >  1 file changed, 32 insertions(+), 31 deletions(-)
> >=20=20
>=20>  diff --git a/mm/rmap.c b/mm/rmap.c
> >  index 34333ae3bd80..2a28edfa5734 100644
> >  --- a/mm/rmap.c
> >  +++ b/mm/rmap.c
> >  @@ -86,15 +86,21 @@
> >  static struct kmem_cache *anon_vma_cachep;
> >  static struct kmem_cache *anon_vma_chain_cachep;
> >=20=20
>=20>  -static inline struct anon_vma *anon_vma_alloc(void)
> >  +static inline struct anon_vma *anon_vma_alloc(struct anon_vma *pare=
nt)
> >  {
> >  struct anon_vma *anon_vma;
> >=20=20
>=20>  anon_vma =3D kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> >  - if (anon_vma) {
> >  - atomic_set(&anon_vma->refcount, 1);
> >  - anon_vma->num_children =3D 0;
> >  - anon_vma->num_active_vmas =3D 0;
> >  + if (!anon_vma)
> >  + return NULL;
> >  +
> >  + atomic_set(&anon_vma->refcount, 1);
> >  + anon_vma->num_children =3D 0;
> >  + anon_vma->num_active_vmas =3D 0;
> >  + if (parent) {
> >  + anon_vma->parent =3D parent;
> >  + anon_vma->root =3D parent->root;
> >  + } else {
> >  anon_vma->parent =3D anon_vma;
> >  /*
> >  * Initialise the anon_vma root to point to itself. If called
> >  @@ -102,6 +108,7 @@ static inline struct anon_vma *anon_vma_alloc(vo=
id)
> >  */
> >  anon_vma->root =3D anon_vma;
> >  }
> >  + anon_vma->parent->num_children++;
> >=20=20
>=20>  return anon_vma;
> >  }
> >  @@ -146,6 +153,19 @@ static void anon_vma_chain_free(struct anon_vma=
_chain *anon_vma_chain)
> >  kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
> >  }
> >=20=20
>=20>  +static inline void anon_vma_attach(struct vm_area_struct *vma,
> >  + struct anon_vma *anon_vma)
> >  +{
> >  + vma->anon_vma =3D anon_vma;
> >  + vma->anon_vma->num_active_vmas++;
> >  +}
> >  +
> >  +static inline void anon_vma_detach(struct vm_area_struct *vma)
> >  +{
> >  + vma->anon_vma->num_active_vmas--;
> >  + vma->anon_vma =3D NULL;
> >  +}
> >  +
> >=20
>=20It is a bit odd that you are setting a vma value with the prefix of
> anon_vma. Surely there is a better name: vma_attach_anon() ? And since
> this is editing the vma, should it be in rmap.c or vma.h?
>=20

I=20will move them to vma.h.
> >=20
>=20> static void anon_vma_chain_link(struct vm_area_struct *vma,
> >  struct anon_vma_chain *avc,
> >  struct anon_vma *anon_vma)
> >  @@ -198,10 +218,9 @@ int __anon_vma_prepare(struct vm_area_struct *v=
ma)
> >  anon_vma =3D find_mergeable_anon_vma(vma);
> >  allocated =3D NULL;
> >  if (!anon_vma) {
> >  - anon_vma =3D anon_vma_alloc();
> >  + anon_vma =3D anon_vma_alloc(NULL);
> >=20
>=20I don't love passing NULL for parent, it's two if statements to do th=
e
> same work as before - we already know that parent is NULL by this point=
,
> but we call a function to check it again.
>=20

I=20will add a wapper function.
> >=20
>=20> if (unlikely(!anon_vma))
> >  goto out_enomem_free_avc;
> >  - anon_vma->num_children++; /* self-parent link for new root */
> >  allocated =3D anon_vma;
> >  }
> >=20=20
>=20>  @@ -209,9 +228,8 @@ int __anon_vma_prepare(struct vm_area_struct *=
vma)
> >  /* page_table_lock to protect against threads */
> >  spin_lock(&mm->page_table_lock);
> >  if (likely(!vma->anon_vma)) {
> >  - vma->anon_vma =3D anon_vma;
> >  + anon_vma_attach(vma, anon_vma);
> >  anon_vma_chain_link(vma, avc, anon_vma);
> >  - anon_vma->num_active_vmas++;
> >  allocated =3D NULL;
> >  avc =3D NULL;
> >  }
> >  @@ -306,10 +324,8 @@ int anon_vma_clone(struct vm_area_struct *dst, =
struct vm_area_struct *src)
> >  if (!dst->anon_vma && src->anon_vma &&
> >  anon_vma->num_children < 2 &&
> >  anon_vma->num_active_vmas =3D=3D 0)
> >  - dst->anon_vma =3D anon_vma;
> >  + anon_vma_attach(dst, anon_vma);
> >  }
> >  - if (dst->anon_vma)
> >  - dst->anon_vma->num_active_vmas++;
> >  unlock_anon_vma_root(root);
> >  return 0;
> >=20
>=20anon_vma_clone() has a goto label of enomem_failure that needs to be
> handled correctly. Looks like you have to avoid zeroing dst before
> unlink_anon_vmas(vma) there.
>=20

Yes,=20it's an error.
> >=20
>=20> @@ -356,31 +372,22 @@ int anon_vma_fork(struct vm_area_struct *vma,=
 struct vm_area_struct *pvma)
> >  return 0;
> >=20=20
>=20>  /* Then add our own anon_vma. */
> >  - anon_vma =3D anon_vma_alloc();
> >  + anon_vma =3D anon_vma_alloc(pvma->anon_vma);
> >  if (!anon_vma)
> >  goto out_error;
> >  - anon_vma->num_active_vmas++;
> >  avc =3D anon_vma_chain_alloc(GFP_KERNEL);
> >  if (!avc)
> >  goto out_error_free_anon_vma;
> >=20
>=20At this point anon_vma has a parent set and the parent->num_children+=
+,
> but vma->anon_vma !=3D anon_vma yet. If avc fails here, we will put the
> anon_vma but leave the parent with num_children incremented, since
> unlink_anon_vmas() will not find anything.
>=20

Yes,=20it's an error.
> >=20
>=20> - /*
> >  - * The root anon_vma's rwsem is the lock actually used when we
> >  - * lock any of the anon_vmas in this anon_vma tree.
> >  - */
> >=20
>=20This information is lost when adding the parent passthrough.
>=20

I'll=20add it back.

> >=20
>=20> - anon_vma->root =3D pvma->anon_vma->root;
> >  - anon_vma->parent =3D pvma->anon_vma;
> >  /*
> >  * With refcounts, an anon_vma can stay around longer than the
> >  * process it belongs to. The root anon_vma needs to be pinned until
> >  * this anon_vma is freed, because the lock lives in the root.
> >  */
> >  get_anon_vma(anon_vma->root);
> >  - /* Mark this anon_vma as the one where our new (COWed) pages go. *=
/
> >  - vma->anon_vma =3D anon_vma;
> >  + anon_vma_attach(vma, anon_vma);
> >=20
>=20So now we are in the same situation, we know what we need to do with =
the
> parent, but we have to run through another if statement to get it to
> happen instead of assigning it.
>=20

Some=20code like it.
init_tg_rt_entry() has two callers. One has a parent, the other does not.

> >=20
>=20> anon_vma_lock_write(anon_vma);
> >  anon_vma_chain_link(vma, avc, anon_vma);
> >  - anon_vma->parent->num_children++;
> >  anon_vma_unlock_write(anon_vma);
> >=20=20
>=20>  return 0;
> >  @@ -419,15 +426,9 @@ void unlink_anon_vmas(struct vm_area_struct *vm=
a)
> >  list_del(&avc->same_vma);
> >  anon_vma_chain_free(avc);
> >  }
> >  - if (vma->anon_vma) {
> >  - vma->anon_vma->num_active_vmas--;
> >  + if (vma->anon_vma)
> >  + anon_vma_detach(vma);
> >=20=20
>=20>  - /*
> >  - * vma would still be needed after unlink, and anon_vma will be pre=
pared
> >  - * when handle fault.
> >  - */
> >=20
>=20It is still worth keeping the comment here too.
>=20

Okay.

>=20>=20
>=20> - vma->anon_vma =3D NULL;
> >  - }
> >  unlock_anon_vma_root(root);
> >=20=20
>=20>  /*
> >  --=20
>=20>  2.25.1
> >
>

