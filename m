Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9DED116F2
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 08:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32056B0005; Fri,  3 Apr 2026 04:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE42B6B0089; Fri,  3 Apr 2026 04:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1B26B008A; Fri,  3 Apr 2026 04:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8887B6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:25:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E2B21B8324
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:25:55 +0000 (UTC)
X-FDA: 84616561470.25.14C868D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FC1D80010
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:25:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZIzmx2UZ;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775204753; a=rsa-sha256;
	cv=none;
	b=jmEsghmQT9YjKWcUu/IuYsA7ZJLF8LRqUIE5uTA3exovCKvki6e/x+oFdIe2/4zl5qmwH+
	M2EYSQZ5eBsDxLHRN78+YPPQWxSGqpYZTIRP5hjqey4fgUFCMTiO8iEvV4Hi4wT7pdHkuh
	4LITIUPPznq6LCsLiRJmce5JPIMwpRs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZIzmx2UZ;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775204753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJePRSGvSCQINqxvGVIHI6Ic5ma0/D9msvRTsB/wpe4=;
	b=5BrbAnVhJESy8Mla0BKqyCwkW0luRci45xFq1gN8HDLZBfUtQ6+zZ5CkfjZkQvYSjFRG4j
	Di/8fLPDkNbG1E2iyXFXnzJ8Z3PCfcgpnqS5e9BX0k3XRqUm6rKlm2NFyvxCskoiEzmMrn
	lZtcqSijC++G1aVj8JdHp1G5yM+pB8s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1775204750;
	bh=zfQs8b9jWuHNNoB2IqSRtpJUMEpw89Ypb/CcW4k2Obc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZIzmx2UZyp3BCMBv24XQB2NMSc4MVOdvJsjb1a98choDVXEPoggFm3JuiLc9MY/Gk
	 6OUNPWKNpPYOP4sIscQkysLm6JwxHJTanMUJw5Ag9jH4cQr8ueG3NkDU9nfXtP8K6l
	 nGZ+JzOxTk5iPNagV7c39dTYda1iv0Y13PxA00I+m+4eo6DKeIIyH7xQKIcAGQnjbN
	 3PTcYz9vJOiZlSOHRfztWvfKkHZ9fAUIZ+SnwStzwdXefnf6IQHs2SDkvB5aqWBw+h
	 i/tSpJ02h9bV6Dz/7ux9ix31+fXFDvUJSctmnYOfesohJgcJLdVKe+tNaMJOAZ4RFI
	 SqP6s8zrL8Yag==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 7CC2D17E8622;
	Fri,  3 Apr 2026 10:25:49 +0200 (CEST)
Date: Fri, 3 Apr 2026 10:25:45 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 dri-devel@lists.freedesktop.org, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 kernel@collabora.com, Biju Das <biju.das.jz@bp.renesas.com>, Tommaso
 Merciai <tommaso.merciai.xr@bp.renesas.com>
Subject: Re: [PATCH] drm/shmem_helper: Make sure PMD entries get the
 writeable upgrade
Message-ID: <20260403102545.6085b71f@fedora>
In-Reply-To: <1268c6cf-f3d7-4085-baca-796526125f44@collabora.com>
References: <20260320151914.586945-1-boris.brezillon@collabora.com>
	<1268c6cf-f3d7-4085-baca-796526125f44@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cudg4afr53tjcy8id7fqrpqbncjjbqej
X-Rspamd-Queue-Id: 0FC1D80010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775204752-28819
X-HE-Meta: U2FsdGVkX1+GCH2bpa6gQpYtX3Ssj1rjiSOosEiT2G9SIjrQi9WcI3SoYKHIdizICwwF4B6Fi6BPDPjYO7rW9O3NeKmAevX29mvGYIPva2PBdTxyOeVrIVgx9YdwgA0k03ZRdJeaAXpUbQBQvVewAiNMhYXSh384laC+17QBLgIBiTQZn3QewMd2dPvj2AcC1EpzX/oG3bBghISpEdO2pTVVmaVpMIKJLdlv0wAoZ8J2H4KTELraA6MGZsNLlqeDj26k3yMr9kIS/vu2vUu+DWq4X1cT0MjBXe3t0S2ySsCbWeNgjyPf/rfo+Bk+xIsaiFrwnayMxUu7mAec2A8PP81LTS2GFhHZCn4oprIejIx2nYc3PIkMvWD39pglVQhIvr2DWjk2ChOa7bF8De6Z7YuTjKJMvwJFA6qEgCXrHegStsCP+0ZskX67VszJD59df/IJSumq87LqutjCHvQCE/e7mKxytL1Xzdw8whAzi/5i6xHEkpxIVs2uJa2UpytqQS+1/wHZNpR0nAHjMYnfkyrCEsMxv3a0tj7WyQZwQbfN/eSEJ4TXOtFeklUtz3AEiO9BB//QXxzlADGw27Kn9Ktdgw/WFfflYEPlrY7IHpQ1kf25jRsvM1yLm5YKJ1QlbCeR3wGVFelaxxiyt30Ijp/V1Uxjtx3cI1yyYaqRpjvRCOfwWS0wVJjrAeZAYSDRD5ygitESUykkTgQqkH+NHRZJLtlmK//p9jYnnwKoucRLCkmF3iSomuJV4PkAR6tLyxkXeMY79t0y6wPg4W0MS6dt2GvIyEtOp6HqbCGf37LVZhzVE+D0Y5NiG0KLnzbzesTYp57gnzPbDT8X6VnruVbQUO8ReKyLOlhr4vVR7W70R4N58OhCCEftBnS9v8Q+NfkGlegl+TPFKBBL4Bd2maz4bkPXwaiLR0kD9ACLnoN4QPu5x5kl/nP0J92jI+6zXFdh4E3n/a4hfy7kizx
 ByRFiNOa
 ZWi7StNFZ3O092Jtcil65DQwtbb28rgRn5TyqScDdQyVDi+UkiY2tqk5/7eCGzxfMx8bcFpa0G563J3XaSwL90PNHCTZ1fLjK97si7Auml2OeGdwiJZqw8QPjGNnqkJzNO6GJlkxaftHrGl5GbbdOoDYF8qaTJv+X+YlpbrKdZCo8syKA4a3+Ci25pIMz4ofWkSiXka/IOtS4sXmto9w54pAr2tay43y041SSk5tOWUidSAOeYT+m1Bjy2Nz/+MYQ4UZyfkURs3GgUywuVTlnslikuL3mGMURR6b+n4I3JYJOs/uMeNU6VRlmwtsyqFYVmdC7zREMvVUn13CbKV1QiOCsLGlU7staFp7Ui0u/AOOUjRRimdvL2wF7dOVjyfzdMLprgaP9KzeVKk79Mc/TUZllLzl+I19v/1cvRBjl3m9p1UMYvc083X2hAF9XxTQ6OAZb/hu4mnM5Y0Bug8V0DF9OUt5vP1nBuYnnNIANs9xJZlsl8u0NQzqfzu3vLToK8t8Tcn2rxNP1/3PfB2Ve7h6PYUTZ+pRh8DT473V9QZCY0MHaO6lO2gh6jhVazjteOpUGON0dOImgc3pi3ZN7lQup4Q8qT1sxTJl5PLqqybKHES3moEcOSVeOIoQiW9mHRkzrgxDMNsYohAo9TRjr/rVbr5om40l8/tjyelCepuczP3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Apr 2026 09:57:53 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Hi Boris,
>=20
> On 20/03/2026 16:19, Boris Brezillon wrote:
> > Unlike PTEs which are automatically upgraded to writeable entries if
> > .pfn_mkwrite() returns 0, the PMD upgrades go through .huge_fault(),
> > and we currently pretend to have handled the make-writeable request
> > even though we only ever map things read-only. Make sure we pass the
> > proper "write" info to vmf_insert_pfn_pmd() in that case.
> >=20
> > This also means we have to record the mkwrite event in the .huge_fault()
> > path now. Move the dirty tracking logic to a
> > drm_gem_shmem_record_mkwrite() helper so it can also be called from
> > drm_gem_shmem_pfn_mkwrite().
> >=20
> > Note that this wasn't a problem before commit 28e3918179aa
> > ("drm/gem-shmem: Track folio accessed/dirty status in mmap"), because
> > the pgprot were not lowered to read-only before this commit (see the
> > vma_wants_writenotify() in vma_set_page_prot()).
> >=20
> > Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status =
in mmap")
> > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> > Cc: Biju Das <biju.das.jz@bp.renesas.com>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
> > ---
> >=20
> > This patch is based on drm-tip [2], because that's the only branch
> > that has both [1] and the dirty tracking changes that live in
> > drm-misc-next.
> >=20
> > Also added the THP maintainers in Cc, so I can hopefully get some
> > feedback on the fix. For instance, I'm still unsure
> > drm_gem_shmem_pfn_mkwrite() is race-free (do we need some locking
> > there? should we call folio_mark_dirty_lock()? should we call the
> > fault handler directly from there and have all the dirty tracking
> > in this .[huge_]fault path?).
> >=20
> > [1]https://yhbt.net/lore/dri-devel/20260319015224.46896-1-pedrodemargom=
es@gmail.com/
> > [2]https://gitlab.freedesktop.org/drm/tip
> > ---
> >   drivers/gpu/drm/drm_gem_shmem_helper.c | 46 ++++++++++++++++++--------
> >   1 file changed, 32 insertions(+), 14 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/d=
rm_gem_shmem_helper.c
> > index 2062ca607833..545933c7f712 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -554,6 +554,21 @@ int drm_gem_shmem_dumb_create(struct drm_file *fil=
e, struct drm_device *dev,
> >   }
> >   EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
> >  =20
> > +static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
> > +{
> > +	struct vm_area_struct *vma =3D vmf->vma;
> > +	struct drm_gem_object *obj =3D vma->vm_private_data;
> > +	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> > +	loff_t num_pages =3D obj->size >> PAGE_SHIFT;
> > +	pgoff_t page_offset =3D vmf->pgoff - vma->vm_pgoff; /* page offset wi=
thin VMA */
> > +
> > +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >=3D num_pages=
))
> > +		return;

For full transparency, I'd like to mention the review bot complained [1]
about us not propagating the error to .pfn_mkwrite() as was done before
this patch. In practice, I don't think it matters much: if the pages are
gone and .pfn_mkwrite() is called, we're in trouble anyway, because a
read-only PTE pointing to this missing page exists already, and it
won't be removed if we return an error, it just won't be updated to
read-write.

> > +
> > +	file_update_time(vma->vm_file);
> > +	folio_mark_dirty(page_folio(shmem->pages[page_offset])); =20
>=20
> Unless we're sure the folio can't be truncated by another CPU, maybe we=20
> should use folio_mark_dirty_lock() here.

In practice, we control when the file is truncated
(drm_gem_shmem_purge_locked()), and before we do that, we make sure to
kill all the CPU mappings (drm_vma_node_unmap() called before
shmem_truncate_range()). So I'd say we're good WRT this particular race.

> This is what's done for pages=20
> (not PFNs) in mm/memory.c. Let's wait and see how it goes without=20
> locking for now.

I agree, let's see how it goes and revisit later if needed.

>=20
> Reviewed-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

Thanks for the review. The patch has been queued to drm-misc-next-fixes.

Regards,

Boris

[1]https://lore.gitlab.freedesktop.org/drm-ai-reviews/review-patch1-2026032=
0151914.586945-1-boris.brezillon@collabora.com/

