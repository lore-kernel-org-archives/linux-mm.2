Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0A2CF45B2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015326B0092; Mon, 12 Jan 2026 12:28:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED73C6B0093; Mon, 12 Jan 2026 12:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AC96B0095; Mon, 12 Jan 2026 12:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CED2B6B0092
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:28:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82B2AD177D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:28:01 +0000 (UTC)
X-FDA: 84323994762.02.44ED432
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	by imf29.hostedemail.com (Postfix) with ESMTP id ABF18120009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:27:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="SJ/9KK3F";
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238880; a=rsa-sha256;
	cv=none;
	b=0CjMVmYi7QmDKirXHhBMQaGdaTH6qekR5aYbua4kOIE4Kerfb2Ky4Sb7+21ODCktvq4xC7
	u2fXlkdS/ln6gN8OmppQxr97IZmz7ZJywiFbCn4A/j15+CzDsdHLkiASQeW7LEPWhoJyoB
	pHfjBhadtgirIJDe3G/fTigAdQKrICE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="SJ/9KK3F";
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kx3Q9Q/4s8TjRty/4a8EQIu+e1jQRULqlVoz9Vq2gY=;
	b=1cOy1b2XCJw/l38mSJknmv2fOBnPvlIdsM3HeV1zwm7qsQDM+6a6N7NfrgTgdI5W3UAuSP
	pgjYQEyp4xJknHkKKox+FwXxWAjggQ7W6NOrVaaZpnngPLcg8C/0109xbIkuYc3qQvnUGC
	nFtemdpOXaPdRWhStlvPL55GK9/42XY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768238878; x=1768498078;
	bh=9kx3Q9Q/4s8TjRty/4a8EQIu+e1jQRULqlVoz9Vq2gY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=SJ/9KK3FVuvcxbDVZc0Twvcm6cH/PyT5nrZk8k+Bj1j2njXRGTHy86r2ExjWqB4Dx
	 +1e+4khek0QJTkwr28gBG6/z8bKHFrbixMrp62NFXTTZ2LHKiXUeyJdQTRQxVWON3t
	 eICiz/InvhM3q4jofLf32ofxR+HeE4ShviFXYnS5fcq2VVc712Wp4Js6+MTNRe7jqr
	 A2Auo1M9QtUw+6cxB40DstxU1zn1SoplpnsHWjUgDMp/f/SgFGK7dQ688eX6Cwfesr
	 KlxxZ4m+c+dw18gPTvPFs+yHhfH9cnvX2l+z4iB7YdcmE7RZaGLUA4P+RyDV3Tg8wt
	 zW70UPDuR+cbA==
Date: Mon, 12 Jan 2026 17:27:54 +0000
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 06/14] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <09f5b8d31aaf87cf2ba30a29c56524fdd4958bcc.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768233085.git.m.wieczorretman@pm.me>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 9683f198d95c8ee0943e4cd044d514066bc7e9ca
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABF18120009
X-Stat-Signature: 1uqea17yet8idk4wbsyboyts31jqogow
X-Rspam-User: 
X-HE-Tag: 1768238879-480458
X-HE-Meta: U2FsdGVkX1957fTsWUTn8GhI5fZiT1T4F/LkJZjDh5eLkB/NhC/D9LdD5y5cbxab+nLi5yU09kUf5IgAGspmL6u98cGNLqIApYJktd4fTOLeC8xF3PutnkFlR4qCFbAUom03oK0aNOEzr8paR8+rE7ycv32pSw5uJXbFp9NEIHD6psdi4iECQo9dRDYB4UsErKfnvxO0Mtg4Ow1EY9NTX47NCrJmHOppPkh/pXK4i20GPKoIZPvEOWYrtlX78Ywj4BoHwDRBSdCtmZlABLnVEehFAfDWLakTerSsI5bRRsjfwnMcd+QtGrKHhECqtqC+XABXsRGW9J13BnJDMoeiZ/MnECRDtuejbWt221eBqgzl+CtgQ6zN8BmDqPhzWeInnEaBIdU+DcnmNhWFToqeshiBA1ysgvdQoVakfNc5SMEkcjM/JXl45N8syB88uW3ROzRQocO2uKwkhvMp3gEmS4OxuUngr8GhOFmNJ5OQr28/BsUF0BuYajNzeZN+YgEb2aM1dIaCYgeY26q+mZV7gcqpz+wxZkgSJ0tzJ6JE1xDxkdgpkouqTmziuJLutF/Tm21WDHOCw3BJI21Bd5ThWXhr6q9Va6ZKqTfwTUjkXLnHYV5mFvGlTUAEEJdyRhvavl6n+geG5scCg2vDpmcW3JmMmosLQrLxG7UsDBQPlPu8z0ihGVZaFC0pQtNC2Xfc/2ngf4CL/HsDuVQ4ewhlTATtB2yxtFbzYJtKuzT0GFkRMHbJTDTPc9AdhOiOuHp0lEVtZks6DjJZNzlxny/JJeEq7d84TkQOugCCGllf0ULDHu9a5ZQlXpcGZKGB0lurS1dsck/1Vst53PP6zeKuQ5loZxj2aEAZ5kcYCTVRLWJimPKA3nHWMV4Hu6GLN3qiSi5PEHtEroekBw3MEvIEpGV82M+YhC8oq9ywR3gXv1i1pSWFjaadzrjNm8juZOYmC0XgMIDhY5mpDZzssca
 Rlo7vPZZ
 L3ACd7IsKciE/j2EdlU+/ssT/fkF8XlzMFGeQnlEbA0JjWZZLKvnm7bH6ImQX3UoCUSDjV6F4nQxFXZPThE/DE93fOqDVrLekiSX2o6c3/GoAcI0aO2WkLwgziLKeiTopeigqZUYOUl3U38hIytxEDpSAce97xIlPBtC44nnMYyN56E+PH5YkJcZBYHkMmFkWurbEl+j+uMewMU6oRaWFlIMuTFO70BQEDfxQY9/TmF2hjmPSEICXiKmz8eBtWioDykNMCivtCq8rP+67XSt92E7Eoud7+rA0uXm5bPtjL6rga6LQmHSjLYBaiA==
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
index 41dd01e8430c..6ea8d48f70c2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3354,7 +3354,12 @@ static void vm_reset_perms(struct vm_struct *area)
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



