Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5FB606A332
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L2aQbeKX
Received: by kanga.kvack.org (Postfix)
	id BB1BE6B05B0; Sat, 21 Nov 2026 19:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B625E6B05B1; Sat, 21 Nov 2026 19:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52AD6B05B2; Sat, 21 Nov 2026 19:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8236B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:00:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8488805F6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:00:41 +0000 (UTC)
X-FDA: 85460798682.03.A62B00A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00EFE140009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:00:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L2aQbeKX;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795305640;
	b=mg/tbeUEHmSLX2ShwuHHE3ftTK6uL6NV6wq7LAT3C6/1Mj6DeVr8LoTpWcKeTZyKvOpq4A
	Ik8FiG6zh1U1T6Ex7CPG5DgNy1JmjA+jHGU6rXVxeFSDdze3Xou61lyqcl9ymOrlmljnUu
	CtoPlmC+R9DitU+QwTzkxMAaULMJ2sc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795305640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04EqnkPwf0WubK8I3U0HutElecdyfT91xsPRhXdRrm8=;
	b=yqeTS1q7yNh5AIq3CYpRnnI7dzGR051dS1rXolfsVuIxDrFH2g2ALIJ65OxcQ7gMSGTXFK
	E8UqOI0n8uZS1QO7F49Ezm0yIbJdyZ12dGd7vZN/lrhVx6rxgybInuSYlMFogRuWqlTnX7
	s/+vgTLdMMw4hoGeWefB3lVAG/dv0Jk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L2aQbeKX;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76AF641643;
	Sun, 22 Nov 2026 00:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F7A1F000C4;
	Sun, 22 Nov 2026 00:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795305638;
	bh=04EqnkPwf0WubK8I3U0HutElecdyfT91xsPRhXdRrm8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=L2aQbeKX/CTPckpuCxg/75CkYq7VgqRjjwXERlHfP3ef/xH4jzlR1llKSlU5CeM8e
	 gUoqibFABjeIaklQZ6WRqldqwgKZ5YTZ1h3Bi7puox1t9KLDvG/77rmYY7BqGwgQDR
	 LhWKY3luEuf/ybIxy+nQvMG6VZ1ez9KdmhG98Da8=
Date: Sat, 21 Nov 2026 16:00:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: jgg@nvidia.com, leonro@nvidia.com, airlied@gmail.com,
 apopple@nvidia.com, balbirs@nvidia.com, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost
 <matthew.brost@intel.com>, mm-commits@vger.kernel.org, mpenttil@redhat.com,
 Patchwork <patchwork@emeril.freedesktop.org>, SeongJae Park
 <sj@kernel.org>, thomas.hellstrom@linux.intel.com, Vlastimil Babka
 <vbabka@suse.cz>, ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-Id: <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
In-Reply-To: <179342234355.4.16705453209886955762@gmail.com>
References: <179342234355.4.16705453209886955762@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00EFE140009
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: afnngb9ctuqrw5xau34jg8xaxuc51xwh
X-HE-Tag: 1795305639-865084
X-HE-Meta: U2FsdGVkX1/Zy9/g+zg5V6dlLgBnSf4DaKD4s+fOpSupsVgCGBvyKASOeqgf2wGVtEDn1EGAHw1/fHKcrpC95BrCgT2mfcOa0zz/SvrycRoxPrrum1hLNuZjfp7VHCgnfkXgmSRLl6619ODM+YS+4KJhVGgZxaKEKaqCzmvo9a5u6U8d2PqCH+PXnu/w+pRqGQ2PXcEzR9j9pco7ygQD3rbBq78oi2OxRRMPrpae4sgNVpDDgi0gcx1ixiEF0EnxI83dOZ/f72hzegUyqGGDMiNX/8GaF/40/3iI6UzXyKgETI1MsZZluEmj+G2V10+Q7BPkI5sTzkTm15zjyqJh8XDFIyeYJtUgxcY4n0n62AWvzkn84P2KAf6lbigCQDrK/lfRM64ThmsX4IUJYcul8W6G/K1n6xLj3FHMwauUvfFhlJ4BTcFwkB5ATXLkb3l78tzdrpeDbPztXRPud5WzGYf5mk/ieiG1Qqdli0kULaKV3b8THEZVkXPQa/x5/LFzAv5TgEg8oUkG+lBeXCHYPPZoLQYDTYlLXLNjm7x9lMtFu2XdVywtEuqv4+El+udfWaIQCsL9O7G+ss+EcPhhbWixqw5NTAWsJ3y0B9NlsklgeM/2Xj1KIKq266mIzKp0+ogFNQbJXk02GDExpKVqlZdUwUUxbbKVOO6W1MH7Myp787fBbKDAVcpqB30dhq9YeEL7v0I9CxWnF1PSfa1H8X1K6m73/I95ceeEqLdF/n+F6KS3vZ9f0QJAlTm7PAMO8F+wa+L2CTRSx4xdyoMF5skUXhyNbREMzCoNjhuFeC/Dz+QxBJsw/VGLTHXe+5219YkKB1n6/1Qf09GnpZ+owxwNsRXeO9nWPZoMMThPpuGOD+qxxoDz1cN0cRWTIo7/xCR+TvHuMiVXxmrQOTqMZxZGOdZhbc3zCxBXzmcWpmZmWcNstUjJp9/OdTdC0ebOz5e9iKmSwrUf1NBJWsD
 X1LghpnL
 4rvVMprZdD1fEqH+VQtM/aG6Z3SZrv+FakMUy39Ce+cnF93f+Bt2nAkB076vYGWA7iW0G9pGBmjjAp+qe/wn5RikRxHui19qWCVBf+NrOsG2WknWZyhxbrc4To5kuWPI+03Y0nVbBSff9D6+0vzxjZoiB0lNrYqsS29tZ9hBZ8K0oOjv0xR7EtaX6Fs8JtXp1gma0s0S4p1ZFLCLV8VGwDEUt0OJNT8Sq72RVTIgqaMjc5xBN2TCHoo2x4eU3/GDJpOowdk0FxrawSak9GCyz3cICNFwyfc0OMowsyDZZDtxc8IQ7+jQglaA0oN13qR/TtQ3l0bNIG9NLQZlsheIHBvZYTIBbBDSJymXtbmvbx1V/X71D9WjN0i3v5vPtZP7QBefr7gfKaeBFh1hUn6MpadTjdiaF9A44FyOtya4Br5DJiKeBbUk1KlaaQgA4mFNwYPtvgyznQ2CCUJFrlDUQIbbRVF7uZcrXxbCTEngekP8CSt7MbDSg1uGIawbOqQDO6Lf1DnoT8dz4IDMXcyMxaFt9P1DxldV3knQtne6Fx2M5XnggJJaAOo/bebuleZEDZ7DOViHvoFLNIQkp0eVfqMBsASTgduW3dx0abh4IeiJsKMToctI9v7hVU7hOs1jHgaGMKPP5WBC3n21ZUsuwoHZy/Zb+qvLdGK/4av7v97YsKFwwIRgUfUlMY+ZFjCdSLihZetuR1dLDCmiWRrwFkb2XAE7cXOVGR37FF6aHWz34hD0riBc+8Bg3gvR5HgWFyGPtoheehK1Wabjo5kVynl2se4stzSo4F9J4InQh4UaeOZsmGq35pe0Hx+XuHBf9ICPPO4OfwMHn/Cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 15:07:58 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> When a query starts inside a device-private PMD owned by
> range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
> array from the folio's first page. The returned PFNs therefore refer to
> earlier pages rather than the requested subrange.
>=20
> Add the query's PMD-relative page offset to the initial PFN, as the
> present PMD path already does.
>=20
> Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
>=20
> ---
> Found during a synthetic test_hmm check of device-private THP handling.
> Tested PMD-aligned and non-aligned subranges, PMD boundaries, split
> PTEs and fake-device data accesses with test_hmm in QEMU TCG; all
> executed tests passed with the fix. No real GPU testing was performed.

Thanks.  It appears that the changelog somewhat understates the
seriousness of this so I came up with a more assertive one, below.=20
Please check that.

I fed this through LLM-driven QEMU-based runtime testing and it looks
like it pretty much replicated your testing:

: I tested "mm/hmm: account for subpage offsets in device-private
: PMDs" on matched x86-64 guest kernels. An unprivileged process
: (UID 65534) migrated an anonymous 2 MiB THP to the test_hmm
: device. A second open of the device read pages inside the PMD
: while the first remained open. A snapshot confirmed a
: device-private PMD, and temporary kernel log messages confirmed
: that the reads reached hmm_vma_handle_absent_pmd().
:=20
: Without the patch, requests for pages 1, 7, 255 and 511 returned
: page 0. A request for pages 31-33 returned pages 0-2. With the
: patch, all seven pages returned the requested contents. Page 0
: read correctly on both kernels. Thus an unprivileged device user
: can receive data from the wrong pages.
:
: The fake device needed an identical temporary backing-page
: correction on both kernels to make this read path work. That
: change was removed after testing. This exercises the HMM path
: through test_hmm; I did not test GPU hardware.

So it accidentally found a bug in lib/test_hmm.c on the way.  "The QEMU
run exposed a real test_hmm bug: a second open of /dev/hmm_dmirror0 can
put a device-private page into its page table, then dmirror_do_read()
tries to copy from that non-CPU-accessible page and oopses".  I'll prep
a fix for that separately.



I'll queue the below in mm.git's mm-hotfixes queue and shall await
maintainer input (please).


From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/hmm: account for subpage offsets in device-private PMDs
Date: Sat, 31 Oct 2026 15:07:58 +1100

When a query starts inside a device-private PMD owned by
range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
array from the folio's first page.  The returned PFNs therefore refer to
earlier pages rather than the requested subrange.

Nouveau's GPU fault path can query one page of a device-private PMD at a
time.  Xe's SVM fault, prefetch and userptr mapping paths can also query
subranges of their own device-private PMDs.  An unprivileged process with
access to the GPU render node can reach these paths on hardware supporting
device-private THP migration.  Xe can read the wrong application data or
silently overwrite earlier pages of the same process's device-private
folio.

Nouveau aligns a one-page GPU fault to the PMD head by subtracting the
fault offset from the returned page.  The faulty HMM PFN already refers to
the head, so this subtraction can select a page before the folio.  If the
preceding page belongs to another allocation, GPU access can expose or
overwrite unrelated userspace data; an invalid page can also fault the
kernel during its address conversion.  This worst case follows from the
source, but has not been demonstrated on a real GPU.

Add the query's PMD-relative page offset to the initial PFN, as the
present PMD path already does.

The device-private PMD migration machinery first shipped in 6.19.=20
Backport this fix to the maintained 7.3.y stable series; the HMM path
exists in 6.18.y but cannot be reached through an in-tree PMD-producing
device-private migration path there.

Link: https://patch.msgid.link/179342234355.4.16705453209886955762@gmail.com
Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Patchwork <patchwork@emeril.freedesktop.org>
Cc: SJ Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Christian K=F6nig <christian.koenig@amd.com>
Cc: Mika Penttil=E4 <mpenttil@redhat.com>
Cc: Thomas Hellstr=F6m <thomas.hellstrom@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>

 mm/hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmm-account-for-subpage-offsets-in-device-private-pmds
+++ a/mm/hmm.c
@@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(str
 	    range->dev_private_owner) {
 		unsigned long cpu_flags =3D HMM_PFN_VALID |
 			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
-		unsigned long pfn =3D softleaf_to_pfn(entry);
+		unsigned long pfn =3D softleaf_to_pfn(entry) +
+			((start & ~PMD_MASK) >> PAGE_SHIFT);
 		unsigned long i;
=20
 		if (softleaf_is_device_private_write(entry))
_


