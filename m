Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC52606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=L4PUEs0T
Received: by kanga.kvack.org (Postfix)
	id 03BE26B05B6; Tue,  3 Nov 2026 11:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07676B05B7; Tue,  3 Nov 2026 11:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6536B05C8; Tue,  3 Nov 2026 11:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2F306B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:30:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 729C5A8024
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:30:25 +0000 (UTC)
X-FDA: 85394345610.02.E01AAA6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0272A18000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:30:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="L4PUEs 0";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mB8ON6MEPW2r/RYWZ0r9GruKi5bPxioVzHjsVLGOro=;
	b=5yrbULtyzE4boLFoj+FxM6RGVd3ynW90aBBSk2DhVKYev/IDvCRCRfO9uwNmFjqKlOB9y8
	N2O4egxEX5jVkpeQvNaNOi4UX1A5tr1hLBFGW1zDek5IvYY7XeLVtsAQZ3Fa9mF2zOcc1T
	TMUm3fZWbL0z+3HYCprAX+itD0MauCY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="L4PUEs 0";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723423;
	b=zFdoXzI44PDX0/fkdfZaFBqCpDJr1WrUwH7DLTCT0kpZKMVKH3qMAWaXGXNQc8NDPZM3Li
	meXCPppn7w+XrJqj8bTwsOSHhFaVcrC4vCgpBGJIbPFc7rZI7RHassbp/7rcnsaR369Xld
	nusixjxIPX4Th8w6qVS/etuqHRgMByQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=5mB8ON6MEPW2r/RYWZ0r9GruKi5bPxioVzHjsVLGOro=; b=L4PUEs
	0TG94wF9l4r0t2PR4te8DQN3Qs2zQOXhW+syyIhDqUNzTOU+0mwkLauDtvDobzC24CywcQsFvTTAe
	xBbY8m72E/cP9VWOkau4UD/FwU5E4QaHXYF/U8+jcpYqrdKfvQyf64A1STi09gabk5DG2UOfIpdEj
	+VVWpHFEKP3C/xhD4RSxGfm+iuAemmFerV2kA3AUP7VLJZvsRSthl8Lvt//X4n9jUJc0gFkoJkZoj
	J9flX3xagZfg1VxZGNlsZAk9L6ebar5/j2EB9XNWEa60YlaxGjJjCX8yyEPIoGqIjYESgcrkmNrrP
	rgR9cepYwK5KBw0vIpeh919QBlng==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xOHOM-00000001jbx-2YuO;
	Tue, 03 Nov 2026 16:29:46 +0000
Message-ID: <3a7d12b52a5de61277842f2cca0dd90d42728135.camel@surriel.com>
Subject: Re: [PATCH 1/8] mm/gup: break out gup_fill_pages() helper
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>,  John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,  Yuan-Hao Hsu
 <aa9736195201@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 linux-mm@kvack.org
Date: Tue, 03 Nov 2026 11:29:45 -0500
In-Reply-To: <df9c504e-e62a-40c0-a513-e8b8c758dd57@kernel.org>
References: <20261102193026.3860700-1-riel@surriel.com>
	 <20261102193026.3860700-2-riel@surriel.com>
	 <df9c504e-e62a-40c0-a513-e8b8c758dd57@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0272A18000A
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qnj15ukau7ayq86njqrsc638rqypenrj
X-HE-Tag: 1793723421-148003
X-HE-Meta: U2FsdGVkX1+suxag2SaKRB/OFUJrFTrnMeixbETk8BIraMKuec/D4S9PzKAAlc3MzZAGnEzSl7sAL9LUBeApdXbBHQU9ckofEXU/omIfwIPjG+dSLPSmiOHERdtit7gREJvMpBJTVZv1HXYFa1L5BgcC3ouqa263ARcSkIYhPBdHT/aEn15eExBWoRCaufZ9YPqHUBrme93s9ifwXLke3aLeXH5Y8ELcBPKX1OzldM8Ub7vKJhPZ7UZdtYcyjHrLUHPo2aQC+05mLwedSfLJyUVZMO3YFNgrIM2hXyObXFI0QJ6eLm5Om6MU9e1tOT9nMv6vWPRtHz91DZwhn+QA8D9lcl9aR68ITOeImCiFN/UFyMED1rJpmmBT7OUBizLgVvIZbi3JX9B2gZVyd1RL2S5/fzC0CUcuBKGo28xh4rW9VcOwRJmHdrEOJC1Vxaca31kchfp1E+HnZdQZGd1Cp9//ZHpz5cP0eE8Xe3ElfwIuxErXXD+7w8PQCWFFuap2Hsj/4ZUIf3BYaO1MHqJ7GnvS9Bivrs7YJyT3naQ0DINVltjfJwdHC3Bge3R06CXZ2Nn/9BF4qVpSvUvktNdYVaK8Vu0oN4ZC3dhr4BhmkN25r4LS8cEt/WqAgfBUupff82dmNYPaJmRIuAxdKDwAYo3In7FeJGYj7SiLAcXwPeNn0W9hFYWKCQ/U0Jqm9GuWAPn4nZzcTKApYZFtlDIzNUGuhnaTx1Nhp9F7F7s3FcasvQInYD+dy2rthN5RqmqiHyaMkgUYVwVQbtt2GueCmrp+1NFMUmBICP0HWOdNml746hZwD6oWRQwQiOkKGo7mbVXBiB6YXus7l+Z83m1xK00URZM+KF2mDe/J6ZEa+qKnx1IBCfRVWoACpWoxRguj1hVq4WIktrR8xnnIWZeV91RONq8B2Bzct+ARD7awSDzzbN2xBEJMZV4MeM6UemGLpNjil1OsYUrGPjNKl+E
 K5A0613x
 MZcGZK9o6OVoGfvJeORx3wD2j3jee1WwOnLB3X2warSOLUueQvzx2EDz55qx3jjKNw4laKzT0EMfnP0IyfYI41S602Isk8G0DDq0qKeLpUQSlA/acztUNEvNl6s4bwQej/hQIc1YL6f1ovqk+tC9mA/sV6ic1xw8Cu7eSzkYTWp7Hrmd/bY9ywPohwlsONvMCU749Xl8bC4Y31Bedd9db6Ma7W5I4Ml6Q313R7eqVzT6fU2PpAJe1uvhobJqaP2MzEGdPLrlLygoY/wgfRA+YsugOLyZUpG9GOf/GWrnt3MyJXrF2TNLtiOfaKUSGl6Gw2UCYBIMmSJ5+ThKV0q7z3Y/p7/j44xdRCv6oGbsZxvgVWxRi01FJukdNbl57c7cm/RBU2hNWP6ZFBGuuL1Pqf4Z+lukGLYUIGMK5U1M73vG2bbPwa03j7uckBNdyDd3QX9xI0xviWuL7QQ95KZKvvBt5IuCXFEvrAqKkjtwWoK+Acuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-03 at 09:43 +0100, David Hildenbrand (Arm) wrote:
> On 11/2/26 20:30, Rik van Riel wrote:
> > __get_user_pages() fills pages[] and flushes each page's caches in
> > an
> > open-coded loop.
> >=20
> > Move it into a gup_fill_pages() helper, which the
> > follow_page_mask()
> > call chain can then use to fill its own pages[] slots.
> >=20
> > No functional changes intended.
> >=20
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Rik van Riel <riel@surriel.com>
> > ---
> > =C2=A0mm/gup.c | 27 ++++++++++++++++++---------
> > =C2=A01 file changed, 18 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 7d43ce717b246..cdbe2ed3e6442 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -633,6 +633,23 @@ static struct page *no_page_table(struct
> > vm_area_struct *vma,
> > =C2=A0	return NULL;
> > =C2=A0}
> > =C2=A0
> > +static void gup_fill_pages(struct vm_area_struct *vma, unsigned
> > long address,
> > +		struct page *page, unsigned long nr, struct page
> > **pages)
>=20
> unsigned long nr_pages ?

Will do. Thank you.
>=20
>=20
> > +{
> > +	unsigned long i;
> > +
> > +	if (!pages)
> > +		return;
>=20
> Why is that check needed? Why should someone try filling something
> that doesn't
> exist?

faultin_page_range() and populate_vma_page_range
both call the GUP code with a NULL pages pointer.

>=20
> > +
> > +	for (i =3D 0; i < nr; i++) {
> > +		struct page *subpage =3D page + i;
>=20
> There is no such thing as a subpage as Willy keeps saying :)
>=20
> Why not reuse "page" ?
>=20
> 	for (i =3D 0; i < nr; i++, page++) {

Will do.

>=20
> > +
> > +		pages[i] =3D subpage;
> > +		flush_anon_page(vma, subpage, address + i *
> > PAGE_SIZE);
> > +		flush_dcache_page(subpage);
>=20
> Now I wonder why GUP-fast doesn't need any of that. Likely because
> architectures
> that support GUP-fast don't need any such magic.

These cache flushes seem to be common on architectures
with virtually indexed caches, where the cache needs=C2=A0
to be flushed if the memory is accessed through a=C2=A0
different virtual address than where userspace might
have written data.

On 32 bit ARM, MIPS, and sh, the kernel seems to
implement an actual cache flush here, but also
claims to support GUP-fast.

I don't understand how that would possibly be safe,
since the pages returned by GUP-fast could be
accessed under a different cache alias than where
userspace accesses the memory.

I think one reason GUP-fast can get away without
a dcache flush is that most of the callers take
care of that, for example by using raw_copy_to_user()
to copy data using the user's virtual address, which
takes care of VIVT cache aliasing.

Likewise, drivers that do zero-copy DMA into user
memory will get the cache flushed on VIVT architectures
inside dma_unmap().

The dcache flush inside GUP covers rarer cases, where
the kernel accesses memory at a different address than
where userspace wrote to that memory.

 cat /proc/<pid>/cmdline              KERNEL
 ----                                 -------------------
 read(buf=3DU)
   -------------------------------->
                                      get_mm_cmdline(mm, U):
                                        access_remote_vm(mm, arg_start,
                                          kbuf, len, FOLL_ANON):
                                          get_user_page_vma_remote()
                                          (slow GUP + its flushes)
                                          kmap_local_folio(P)
                                          memcpy(kbuf <- K)   // read
                                          kunmap_local(K)
                                        copy_to_user(U, kbuf) // write
                                          through U itself
 read buf at U
   ------>
            clean: the final write to U went
            through U. Same line. No hazard.

In this case, the dcache flush in slow GUP ensures
that data written before the GUP is visible to the
reader.

In the write path, e.g. for PTRACE_POKE, __access_remote_vm
flushes after the write has been done, so the other
process will see the data on the next read.

It looks like process_vm_writev() might be missing that
cache flush after a write, though.

However, now we have a situation where:
1) Only a few oddball callers of GUP need the dcache flush, and
2) Those need to do their OWN flush after a write, and
3) The dcache flush is not needed for most other GUP callers.

We could do two different things here to solve the
asymmetry.

Either we could add dcache flushing to=C2=A0
unpin_user_pages_dirty_lock(), and make sure all
the callers that need to call that function, or
we could move the cache flushing to the GUP callers.

Then we have KSM, which uses GUP, and which would like
to see the latest page contents...

>=20
> Maybe we should in fact base this on the gup-fast batching series and
> also use
> the helper in there (passing vma=3DNULL)?

I just moved this code out of __get_user_pages(),
but if we can get rid of it completely by using
a different helper, all the better.

Which GUP-fast batching series are you talking
about, here?

In Yeoreum Yun's series, the batch filling seems=C2=A0
to be done inline in gup_fast_pte_range(), and not
in a helper:

https://lore.kernel.org/all/20261102-refactor_gup_fast-v2-4-bc1ac018c834@ar=
m.com/

Should both paths be using the same gup_fill_pages()
helper?

The cache flushing part is broken out into its own
helper function later in this series, so we could
sequence those differently.

--=20
All Rights Reversed.

