Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82FD2FD4F0F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A366E6B0095; Tue, 10 Mar 2026 13:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD966B0096; Tue, 10 Mar 2026 13:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFCF6B0098; Tue, 10 Mar 2026 13:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED5D6B0095
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:54:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19675B7915
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:54:22 +0000 (UTC)
X-FDA: 84530902764.07.B6E7BC0
Received: from mail-244121.protonmail.ch (mail-244121.protonmail.ch [109.224.244.121])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B0651C0007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:54:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=TdeiI5Eg;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjM37d5NXgOfN+BbnN5wcd6ufgE9HwUJahACByQ/mOc=;
	b=jCPAvak8SWEqtrcEWcMcZAn804I4+3O5eRukkshaE0H0Xi8bVVGaHAyr/h1N6+lTgzbj+7
	jSNeOqF/TnjUWQacRqovEAXw8vLLf2P7IEXerI6GotJpQsLhXxTJwH3qMxmw+BSiPL4tu2
	ENc8Sy0qUfvIC0gHei6mbxk4fz/nSC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165260; a=rsa-sha256;
	cv=none;
	b=NmN2ONWjYZ5VXaAeZOMYCFE99XQ8EzF8TOdAxGLYU4290vKK/gDLMztDpVYFVU/6hcshNi
	cLqJUCBYVomDeW7fPWgQVI9t1pO88eCDyuXDSr2Qg4Ij5TdS1OAru3p3mM5/BDMB+q9S77
	YjVO3bsJ7CeoLzCEHLv+meZGlUWicRU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=TdeiI5Eg;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773165258; x=1773424458;
	bh=zjM37d5NXgOfN+BbnN5wcd6ufgE9HwUJahACByQ/mOc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=TdeiI5EgKkUmx6lLx62juUTEtbY42Vnt9sE017+UF2+eCFw2FmEWtRhxWnRq9PDZT
	 ojOs2S3zIaUYSZQL+Bzku1FeFz8vDKAbCB+BXQTiGPd+wzgpsGrN0wLZT1qGfviDJp
	 B/RLawSOqIcEmfu4lm3kXkT0+MiOzc5eK8JoJDVHIZ5aAXbizMRIbL11vsL1s4Yupi
	 onz25zm55NCQm4OoD+Gu1c6iEUSNyrG5+DYyNJq2gIP7Hii4iSWVElakf0XS+r2WY9
	 vI6p55YyVL1P4rgd6/TS3X7TQs9HNwQVOsIgP+MVuW4i7mtNZdVzAjp5rI3S9DQlpY
	 m2AfwK8Xf4lXQ==
Date: Tue, 10 Mar 2026 17:54:14 +0000
To: akpm@linux-foundation.org, Mike Rapoport <rppt@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 07/15] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <46124025a71405bd5d830496c79baee047a1f3f3.1773164688.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1773164688.git.m.wieczorretman@pm.me>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 1f2018ca438a91b582bccc0718962a32e2496492
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B0651C0007
X-Stat-Signature: ywxej6oz8mb8z3zdz94pgbzkksq43xzt
X-HE-Tag: 1773165260-174363
X-HE-Meta: U2FsdGVkX19FIntciHXlQyEXG4ImtmR5sR8I+iOfvV3tV6ppZAFf1jWX/+wJ9Y11plTGI+HPyi4F45aBSytudL8c2yfQBpB6Mc0C6TVJ1xYiXodD5HV3XnkEK4wvaLYNCQTe7E63fntCDaXSf/s018i6BSLIlIKKgJlpDinFU+Pi7SScIVRLRz0x2Vm/8tvWvT3cr07gybDFO50X4UWG0yfAIokBvSgJ/Wtotg/0m6OSlQdtcW1N/lbp5HAFuHB8zD8ugMSdDtjw+lDRP+prZQnB1/2LhH2EJlUCDCSupzwah5JsTuITvZYM4KJB+9HeQs7eUS0hhp/wwyFX3Ly8GOLWHUh06KYlUw2TahljzAMInGRRStXg8YpqJyGRKJYugvj8QcM8vl+adNTRGkjG5jYIPSC6QV/NX1ZwBwikURUdQd5kG96BT++LzfuS6iuM0jsEI7RJJTaUK+Q+Bv8RBhDtvM/Ebd0W7ckcwT/JHRgGurj5Xfv4knSKzNKGV2KWv0YxaPP+9y1cVR2mBEoViqs1ppPmxFQRdvFU0JrWy0Zs+YZ3qsSD5vYxZJZyFk9M7XKRNKa18O0Yjjjnc6B8dzP9E6zbkjz6emk8toc2gEWmYBaKr8ZcOQ2vVJeWCkIU6i5JQPYRbbJXqVB+DkQlO0WA1xkHsoRaVQVvIKRROvu3YFfxzHNxDGRdiiAa7qY+SnQEd0ijS51/qRhNflGbDHg/rQq037nkv40nK715ljFrhdCQVU/mlr2RYMbfdJ9JquXj2zEN1X5cVW0NGf4pzrBRcDHr/Byo4xtUM5LCmpt8xKz6F8wa+lFL6Zf+yOY5jF3i6+MhZjzr1JXj9HY9YEjleSFF/mZTgZnb9VaGEB/O3+lgVVpLLRIUhRRcb9XZrL4/788NBskOOJifTJP47UpHJEeGizoEunYyEQmQ4ptHhiSJTv6lBLTcdlmO8PcaRt1QiWBRzbcfTa2jpEH
 +rrO0wMV
 LM8R6RRjwjmmDVUd9z2drcASgGN6WJa+Zy1ptRBlQRrN6++Xq3aVLfKkjszdHGgQHF0qPOMyGkUfe/y6pzMse5684bvUbeuoUtubcR4ZTMYrZsHlqE8icaSFnf2WdAvAoDaJZ7opEbnjOiqB+8mIs1XFqdFRb9km9QpxyVRyI4pADN7r2rIFCvXKL62WMjcpGZOKCCXT148RmYCQa8amEVWcUHGrvOFEUywVDpmIuw2jFgS+bi+MdUnIHWprrH8DC6Vb4J+SJIU+PuLiKUTzXjVaMNjBIJoeD/RlnOtnJyJ1u5+GwonjhSzsrRhPPtizfKyBhJlcFli37Z2E=
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Changelog v10:
- Add Mike's acked-by tag.

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
index c607307c657a..67406e42c4d0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3361,7 +3361,12 @@ static void vm_reset_perms(struct vm_struct *area)
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
2.53.0



