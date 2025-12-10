Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA3AD3C933
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 17:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5DE6B000C; Wed, 10 Dec 2025 12:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894036B000D; Wed, 10 Dec 2025 12:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB3A6B000E; Wed, 10 Dec 2025 12:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD536B000C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:29:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BA27160622
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:29:29 +0000 (UTC)
X-FDA: 84204248058.24.1034CFC
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5709316001A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:29:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Lj+pOSMQ;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf08.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765387767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+pkg2GeDkkg1tjHYnWfZwgCM2Umwon1r6aRlNC5238=;
	b=2DKp+lFXZ1RIh1jLZ1pdO+m4eirUNLNQ4WggYc8Jv2RYCL5dFFXACk7OQdPnyncFdQ8o1y
	97Gmk2aXYFJ3pHYvlYjwlGaogttxIFjUFNjfubj1LRLz64S/r1InL44u/TvOj+b9MLf2Aj
	9jttIp02NZ4XHWqIQWDuot6A9AAqMaY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Lj+pOSMQ;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf08.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765387767; a=rsa-sha256;
	cv=none;
	b=L/f5feekYdZ584Qj1DgAS1rs9C+92JuVwhPC2FHLwje4SfE7PAGr6wM18NL8IktOzzbWss
	rTnwXetsjEn00Ry0Y7i9+ys8aHTQpUJoeigOJPCFv/kR9PU2fz8TPSPQ3mnJifv4dQJ3hx
	KDu9mxVIy2iIjk/4iyo4RyTJZr78mzI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765387765; x=1765646965;
	bh=I+pkg2GeDkkg1tjHYnWfZwgCM2Umwon1r6aRlNC5238=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Lj+pOSMQylYz5XAt06tggBchaegn2CDrrpuU4tpShVbY/a0MPIRedf6BMgqEak7Ni
	 Hu3mFoA8kzXs342pvLWg4nQ1Mq1ico+N2daQ45qdSXzP4hWul8SPJg7le1bYXkPTkW
	 Vwnkhm8t4hEhk4owF3HmP0NpYrcy8f9N5yuP9zfy+eZrFanHjYOyDXpQc4XyMwmgce
	 p42NNeIyFZeSTmkiMHYG66xTPySKr/REtupTfevBvXXIoEsLYBIs29cr6YZ/FdNBWV
	 Hk6UOhm9tTmc9f5eDOyAkj6iHsnPet4fP3KbMdU9sHOdMenWVqAwAq+meISJ1m8tyt
	 UU+QFoI2qpWrQ==
Date: Wed, 10 Dec 2025 17:29:22 +0000
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 06/15] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <52b76a6b1ea96e476473bcd6df18a8619be919cb.1765386422.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1765386422.git.m.wieczorretman@pm.me>
References: <cover.1765386422.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: af4557dd716700699e277ef47539c4f0962cd1ee
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: jxnj5h1ow3ji6e7j39xdmi8wgpkbsuo7
X-Rspamd-Queue-Id: 5709316001A
X-Rspamd-Server: rspam06
X-HE-Tag: 1765387767-304353
X-HE-Meta: U2FsdGVkX19vBPlXE8vqaILjPzZAUoxFrJttl8StbhSC1Wt+9prwaGZ7ZIC0j8Nw2K1wLOrYLjbvPPohojsigL7c7t55qmGHYVfNioP1d1d7r0bQgKovVpKqMLVfSblmsyxsUelMgjJBur1dZ+7q1nOMEVpRfD5tyAoHGYE2vPRN8QiJ2Llm1WXkfg2s3pjKgB6EY+yxzisQOTBYO1jCJhkqvRSjHrXEAua7kpPx/uffYMNOs3oQtmXqMS9HLeC4UJ9IYyNbMxQOMuv+MsVQ+1KLEEZRxSe8GmtGfKZA226s0bzmxmSoQPRuOLmo/33QYJDSUouFuxjL3nnugFFDQQhWoyK90Fyry0ij2dilDdkirJBewwjikdZwokabQqTANbQ7DsVNddiC1LpAavJ+Q23BFXJ730IPh3GvdFimAd27fmwH4riJQclUm3KpmHVr1xtr3ZzHke97kTs0prPDPDRybPmUHbTqsCEMbAc4lCi2CP8SiasDMBspk4iaxkebQF4erybima2hhV4on6liE25YC6sj2EwUUMMhXr5CviB1dMIC3Ed8jSlgvhmlr09MY5c5kNdEqvFc4PnKHBbLETaGz+ONKxovAhpEAOgaffmq2sLyRIneMOe53+LgRH8OacyBXi3T/A6hNN+wB1RIT/Jv1e9T8RY6wxe7asFCDwUIjMyjIRBryvNrzlskm3BJXflXHmaxGVqVrLXouov7vpgQ1UP5RcK/ZGvpMQgYEwBH15cZNkO4FsV51m4kCAFF3sc0ZE4d35m8dLY56HpvERkNNeisQzvlee/IkLFWKXp02NlHh2zHnhF6OK/Vz+DZS4qxCfCN9gjF1aGdZhp3xNaLSU9ZOY0NWC2FjBKwHrUXJesO3fYEO29msixIu3vl5cjfG6+7pfRwsa2oSyk8R7X235XcObQwDTS6qCDbgDpABSBG4x+7thiNnLfiPvvbb9qgiuCUXINu9JGZuvo
 JHUIZG3k
 dPha7vbGVMoo5edKJ9I4aHjSWq42bab0AmX2x0w4m3lByKYlE0qIceKtCAcwYPzUijVEtZNPt03ni66ksoWcYFarVac9j/bphhXmUBccOQ3DCPY937DOmte7yDGLtQKrj+JTjlyRw088I/EAhYlui2NllKKhPo7ubekb5i4z/8WWE2d/1DF5pFBmfZWND+R/X8EN20k6viP+9NMiQbixm1qT7HrDjDrQ53y29lUIFtRICzad9rUZh43vTF+GNli7kHeNRfkGiTs/Tfn+HY1J1zax593Et/8wYm2ZsCNCJB4UZ7tQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
vm_reset_perms() calculates range's start and end addresses using min()
and max() functions. To do that it compares pointers but, with KASAN
software tags mode enabled, some are tagged - addr variable is, while
start and end variables aren't. This can cause the wrong address to be
chosen and result in various errors in different places.

Reset tags in the address used as function argument in min(), max().

execmem_cache_add() adds tagged pointers to a maple tree structure,
which then are incorrectly compared when walking the tree. That results
in different pointers being returned later and page permission violation
errors panicking the kernel.

Reset tag of the address range inserted into the maple tree inside
execmem_vmalloc() which then gets propagated to execmem_cache_add().

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Alexander Potapenko <glider@google.com>
---
Changelog v7:
- Add Alexander's acked-by tag.
- Add comments on why these tag resets are needed (Alexander)

Changelog v6:
- Move back the tag reset from execmem_cache_add() to execmem_vmalloc()
  (Mike Rapoport)
- Rewrite the changelogs to match the code changes from v6 and v5.

Changelog v5:
- Remove the within_range() change.
- arch_kasan_reset_tag -> kasan_reset_tag.

Changelog v4:
- Add patch to the series.

 mm/execmem.c | 9 ++++++++-
 mm/vmalloc.c | 7 ++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c924..dc7422222cf7 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -59,7 +59,14 @@ static void *execmem_vmalloc(struct execmem_range *range=
, size_t size,
 =09=09return NULL;
 =09}
=20
-=09return p;
+=09/*
+=09 * Resetting the tag here is necessary to avoid the tagged address
+=09 * ending up in the maple tree structure. There it's linear address
+=09 * can be incorrectly compared with other addresses which can result in
+=09 * a wrong address being picked down the line and for example a page
+=09 * permission violation error panicking the kernel.
+=09 */
+=09return kasan_reset_tag(p);
 }
=20
 struct vm_struct *execmem_vmap(size_t size)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..ead22a610b18 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3328,7 +3328,12 @@ static void vm_reset_perms(struct vm_struct *area)
 =09 * the vm_unmap_aliases() flush includes the direct map.
 =09 */
 =09for (i =3D 0; i < area->nr_pages; i +=3D 1U << page_order) {
-=09=09unsigned long addr =3D (unsigned long)page_address(area->pages[i]);
+=09=09/*
+=09=09 * Addresses' tag needs resetting so it can be properly used in
+=09=09 * the min() and max() below. Otherwise the start or end values
+=09=09 * might be favoured.
+=09=09 */
+=09=09unsigned long addr =3D (unsigned long)kasan_reset_tag(page_address(a=
rea->pages[i]));
=20
 =09=09if (addr) {
 =09=09=09unsigned long page_size;
--=20
2.52.0



