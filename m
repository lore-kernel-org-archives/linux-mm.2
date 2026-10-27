Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642B060A2603
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mF8zRUbq
Received: by kanga.kvack.org (Postfix)
	id 603386B0756; Tue, 27 Oct 2026 09:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAB06B0757; Tue, 27 Oct 2026 09:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5C66B0758; Tue, 27 Oct 2026 09:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C79D6B0756
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:53:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47809C092C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:53:21 +0000 (UTC)
X-FDA: 85368548202.30.2C7F11F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F173C0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:53:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mF8zRUbq;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109199;
	b=Y4K9JnpnJs61TeXfKDUSfFrqvi2vsQUxmXx4XWeSxrlD0exGRMNg1zpr9LIb/pSIOwZSk2
	IwKda6zl9nlIwBYnImIx2ao4xPNHrUeCFRiwnoDjQ3iSg6Scm3GtD0Tw4BWpqecdStgBkI
	PPebPLU6PICV68VvSvMdkFMJtQgUmro=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mF8zRUbq;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGwT1JNbkqmcP8fUAnZimf+aufAiCIdNGNB+5b8MPdA=;
	b=CNIkyHTniO8Z2vTWsEph47tLv89+e6ZgrApYbiPqtrkvEc3prTbOrhgixvZy/WRcGYTDyi
	7AKrP9HXVs5q0y4IzsCHv5x9/0CtQ5t51e8BszdXwNBAxaxnqRMt4HV3D/tjk+TjrtspmS
	uo5Z5paqJeqWjvt4v7J2VQWYKE0HNgk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C518E6021C;
	Tue, 27 Oct 2026 13:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A56A1F01828;
	Tue, 27 Oct 2026 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109198;
	bh=wGwT1JNbkqmcP8fUAnZimf+aufAiCIdNGNB+5b8MPdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mF8zRUbq653nfj1B5K+Z45VMISn5YnE0sHMQhzG2zkRwMerN1u0TrRYVWk97hvTNM
	 uZ0lbteq6tg7KdZ6atcsSTAtfYTmzLqgtX1K28V52vEd6MnMqTJRJtXXcFmIky/8m4
	 WR+SVC3nI3mJmtmiGZw0lBVh9c3YytpGhMYIKmLAbMuSK8tZKjeP376mr2B1DsolpT
	 npnhhnwphjkK431NhDvezTuq5Ni+Vq5zhl/CRuPB0GylScV7NWGxBzcj26Q0m9qpXO
	 ybIZxQd/9nNRMeX/DedkmjK8u6shpdQBEcP8ZqLjIeFW1ucPz08OQzMa15z+dB6HJS
	 6/qy3HLH+nbKA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 85CC7198004A;
	Tue, 27 Oct 2026 09:53:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 27 Oct 2026 09:53:15 -0400
X-ME-Sender: <xms:xqzgal-vr3ZeqbXQYJBliutUwh-BPoCNU76xbXs7mx_Ps-IdSmK23A>
    <xme:xqzgaoksYXGkYGnJF43sYID0Tus98V08BBjG64swDvpdheaZW5VbBJyVOc7DQ6Frl
    aoZ3R23YOrTA4h2thSa7n_eENBiVLh_oK4jdwW4aOnapsUIANjaAKZd>
X-ME-Received: <xmr:xqzgajaYJVYfdqtgodH29574WA_vexf-pM5sNeV3dSMQBjrPqxVqpVsiMiw>
X-ME-Proxy-Cause: dmFkZTEZ/rZ8QL4tKdVH13M4isFoJoqE6mmyk1+ybcvlxgqSp6W0ayLRKd0L7SfTmxuGb5
    U6+Pfm114T++Wp3SC2FV78EqIZ6zQGqKV5XyNS0Q8g8zeea3kGWywXyvNgIRW79CajYQHr
    2jF/D3zyUpa8mENlQ2k9kDlrLHG9vuqIwsGPeExjecTgPLyR3BG4mU+4iFcKzGjlB8O7dl
    rHahXQtAt7H4ct4Hi0ph4caUm45qDhARWvo+NXS6RvFk5in2esxS1VkNF3/wtGoX2gxkDU
    HYhd+ifyLHB/lQg4TvDcO1vty+4TgdFGCdUfD6xIrm+RnS//HTrIeeMZCfQmeBD5mTfrrt
    28F2SJuazbG4sdilPjnUK5Xk2C/b77Urnpd+yJpFkxf0srCyBWlhL6vR0USCQldwnnbiLW
    9q+grn+3rpVTZTV5aFHrdKvOYqBL1I68cy6Ts9EvEo2mG6eqSnlWVGArQuLZTDmYpXGIvS
    wXLvRFTOpi4viZ4HzYk4qCerKNTdy3232MaWMRw4+fGiHl1k0822eLObmoSxbGhZG/SB+U
    RY6eT6x1Fr7R33DiHsTIEPGR6+Uf+O9CEjZE+sUhhEJff/MTsubZ9LmOVI85mrAWUqqbJx
    XWv9aGmJ+yJbAfbRPaNRNIocYryGvdsYvD8pPJi4F3KUYMPNesYsAvQV4dWg
X-ME-Proxy: <xmx:xqzgaudbz8X2mj1TmcVhbSB5pj192_SKV8vP7t-J3qUs-AsDGR5erQ>
    <xmx:x6zgar5lbie9c9vsEIGyR4WR5HHpSCBz3DCSwhV-Wl76bl2cm_9stA>
    <xmx:x6zgaqkT5H7khckA_fD9bSj4bobce4cCO515thNp8GAx2LHLg5LD3g>
    <xmx:x6zgapYUC1r3US7DHJV2QXJyRoI41UHODbj8ZuE46i0U3Qjz7C1IHw>
    <xmx:x6zgagOltv2MpGmQj-wyDgIG_3JLhCWmQzbtOVj1MoCubVlHQLT8Bbj6>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 09:53:10 -0400 (EDT)
Date: Tue, 27 Oct 2026 13:53:09 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	kvm@vger.kernel.org, =?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
Message-ID: <auCsphluu2gwzEPo@thinkstation>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F173C0009
X-Stat-Signature: e8ygjr9kntwaoiuxg3baxc55541khpc6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793109199-315507
X-HE-Meta: U2FsdGVkX187dOylyif/mev66wR+51I1RCS9ZNAkAfvCRXctyZrhPdd1hXLOxiPxnB+Aj1ZB4LmKcnDDqUseqtxAkW4B9sqk6CHXHsybiJupZWnPnLmGzKu8cPaYwF9sO3xUN0d44CWHDGMBAa/g9v0zDQBqnPDjHGYrYs/LZwhd66f1D74IZrajd8o1rLMVxZBG56Wfhtmc0IpfVsvOJdsU/R7pyMqwAgGkJxe3ErQ77GrlebGfXPiZdzJXQz+KZSIa7sP5/9m2lUxe2cWQLkzPbBTHV5ffZhwiLpU+SPuGvvRtDr5XQKAQZDct6DXrcs66B661OoKGES3b5a5MO8KnRBPtxOxOr5IhdH7QAkz+LVLBjd4mgOn+adJ2l/T3iLkYJtma6eKqC6axcZYtV/tmL8q84M/5496ZO8RlBovCsswTOVGYThDCLxRtyJHa5Z0qnpHqNmQGD+y3Oz+81DgTUZD5RQhnVDuGLuzqYzcDqf+5olzvAo3aF9B5KM+T3OdSlEvRPBtplczb4fTh3vXFtTVRdsyCzRlw2Eg+vd//go9c91PkMBPrwKITi0jYl6P6xmedSAJeWwb+x5qTIgU6m4T0YFeWtk0Qszxe3wWTLxp3eoLUU1J0XtIV0k8HunHuDex6ij6mm4FDZPw/IduiF4jw/m2tR8TBUPG3SGyB2Q0HmVcDNeP4p7U4TcBxRAensPF9o6hhGpoToi4oClVKLLhXDd2p3Fc6JjHgPrMth8nnDS69GApr9xbeF5VddZT1GExeNz+Pja9zd9frv3qfPZanFHBp82AZTvp0YRDXdm488JeEb7CNrxPOAaQjDKqR7ntk9zMbj2NfwL64iVCq2TIuAbbqe0fLG66/VyZIC0yGuU8z1/+BHBS9aEfbfiOTJsfhoEH02De3ZqMJX2GsbJYMk3bVHdpUBdqyEp8TbYkD4CbP5boHhn3CABpJE/2slN9y1FeeWj1OybI
 C90kIRqJ
 na306yaOTrjbuRgFkv1/QUECNj9cCuvWNq1355O86b6mUp+B16vs2LNvyI9KTSPWawwJ6l+/oRPM+IKhdES72c9tZlh094VbVBJWxxtEJlpp6U2QHqk+PyfkAnahu1lgMiLkGx+PTNScdWKcPUdRccljtij5mcxFznOmHfxApnSk7N6YaWkfof3X+3WkpHppro00+EMSixGeUnBMBe/e6hTd+T+/Xj24hE6d9lUhyngohrzdn+VQkcA4qORDOgs11zvl/Vtgb5G9feIW1ZLCL5ZEHRCsv+q84+SkWYcE8EMWZzSXs+0QYuEydREhbuaB3uPGoyy3Bzr+ALO4/F993BLpy+yW+N0Dkb8To0u8ovToWNZimaDqKyIFSPfovTiO5aYmGTNbQekgR6GDJCTWYHH9sxEEUZd7eoIAPEQFl2VmuNwmYYuqIwKtr4GG95yNUnLnZyYsjp1vpzWpb06g0dtBMdLujzvG50md7jGQnN3BTPvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:36:00PM +0200, Konstantin Khorenko wrote:
> folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
> __folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
> PTE mappings to the folio instead of one PMD mapping. Each unmap of the
> PMD removes one PMD mapping:
> 
> - the folio's mapcount never returns to zero, and removing the folio
>   from the page cache reports "Bad page cache", or hits a VM_BUG_ON
>   with CONFIG_DEBUG_VM;
> - the first unmap already counts as the last one and drops the
>   PMD-mapped statistics while the other mm still maps the folio;
> - the second one drives the entire mapcount below zero and drops them
>   again.
> 
> The helper has no caller yet, the next patch adds the first one. Pass
> PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.
> 
> Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

