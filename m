Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E1FBFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6DD96B0096; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5746B0095; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47D86B0093; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4AB6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 106C189986
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:29 +0000 (UTC)
X-FDA: 84705463458.17.35613FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 15CD64000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0wwv4qM;
	spf=pass (imf12.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr9bYgIuug3bCDdrgtX53WJv/c9G5LMYMhmlIA3Tf9w=;
	b=Xj0MF15lCl1v/XjPw7j1sV7TvMkZLQ/hVd8sjl9apefFAKGvdzSdWOwQ98cXi/oq7ySKJ2
	mHSPGUXoPgyK9OGdf0oWtqgZA+sEre+nR4cEdXIA9wQH2Seeq9nG/DLFxRa42bvxVy7/mV
	rY9SNqG/Ido4NbcSzl+jGj2frBiuvsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321467; a=rsa-sha256;
	cv=none;
	b=A3fLmQnQGsbIKYaS6QaDE5NuQQXV6v7yeGwjxUCHeNswoAxK9X9uH1npgOg2qfXgHg3pBc
	dXJKfoglTKPIcQH5/d1T/NK0avu6hkTWNlai66qI5LDoVd7IlknuB+dAqoqncPbyXirKi9
	oD6gKnp5r5jCXyFV7RhRCHNJGmjU6r8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0wwv4qM;
	spf=pass (imf12.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 290634397E;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 041EAC2BCB9;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321466;
	bh=SDc+T3e7+LwO88oci/ESlFXaNZSdeI8dvMAEpN6Sk9s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U0wwv4qMKz1JQWG0UWgHt72ZRwiuJHbxTG2KBNO/DSUyKYu+HvTuC6nkvu+WRB3FE
	 2W5v7fUwGoqu4TBoYNvxalB3puAt6AF+sPst/Od/e6PIAOr6L4cTNkFSPA/Fqi/HfC
	 WhJAp4OaMb7KsuUg0bJkudBG1uZjyXnh4bLMrV6FsgyN/X1DwIfJZtE7TgV+tpDBZ4
	 2ELnjaReXF6AgotpgydG1nZ/V9t92cyRhmm/JhLM76EX/Qn1i3lI6WWIHe67mvn3XB
	 s+9lG4232d/Nx7x2D3dJpj3h8tosqpYBneqPhgpSGAdReWDkfARrn2M9jf7QQhoH4/
	 6mPxHlXOfzEDw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA21FF8872;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 28 Apr 2026 01:54:18 +0530
Subject: [PATCH v12 3/5] mm/vmalloc: use physical page count in
 vread_iter()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-vmalloc-shrink-v12-3-3c18c9172eb1@zohomail.in>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
In-Reply-To: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777321463; l=1268;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=IzrpuvbBn3WlkxnhP3YgMF2kBytQxCzQDInbnNPSh4s=;
 b=7okzB/Cxu/mR4PDwNKA/wjJi+ud8fSilxvYtTPmIBHwgQcROTwxb+qvGA2qDyliVp7ZkuFDAG
 RegZNLcWwF8AwQM9LeqZlGIJDhqt2qCGxdYJTi9QcfN3eckCxdVshlG
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15CD64000D
X-Rspam-User: 
X-Stat-Signature: ma9ncnmyytho4m9aoipq86w3eh6ng4hp
X-HE-Tag: 1777321466-187191
X-HE-Meta: U2FsdGVkX18GGhGG0LPiLAcPto5B+n8hpTvIRrXmrraMnGkDTBTiAEuUgUjxswBZUmvoOBVA8qLmb1nQ80IIdPMvGpuYWBQkjIwiO1pOiBR3Wt0WU8gDDOF96N+WxJIRnHiTjCnhS1S9oQsFHk7eqtXb5FyNK2oh+uy21WSRQOYBblUxLtySmg7hLwQsw5tvUnXnG3qnPJeSp/i0cKQQIKDwlRHlJQ+9Q5s2+OuM/mqobqz8NIeECRyxMYOKX5jEb+HFAoHHy3wnLBu+LEb6bTEqf5aDr/T52y0H5+TipS7QkkQw46pcqXkHs6DvlWVgzemZsTuudy1ygmkRVY7PKPnUXVz3ZqmZQEiH2YVqEIlsMEkJPJf3f9ANCtmrDg+iL0lad40lLZgl+tKRkR/SZkbfaQSNTVyfSnjLYyVLfbRhuwhWiFJFDVILwsSGPLErS6PkUHUbpOkmT4y8OpduoUv0vojzd524XzFLKZquaj+Do7dXlHzzuDFgqnT6Xvyj7wkXzWZ4Ca3trpiT8X+Ip3DwkAHsRpfhhriDLDJyMkpepVDKFS51CIQrT8Rri13S1nxzlS2HO1ijlm6jhA26demItcCRMwFv1FH5DRz62an+synEYX4rY7mv7wmeAtF8V++VGvJH6GUSBQz2bhHaZylDsxtYxX3AhCcAi6+3knqlaSk7yN5hKQggzb4HpLP6J8HtOciaewX7BYBOIc54nrvv0PrXQDYpmMFqMMjnwHEdXae6bMkYM+EJwdgT+Rv59WwW+/Ids9N42XDTZR3hrTpGDgTAz/HXdHVLVjECizzePsXSEAojvavKlIdl1dSks7q+ST9XdZ81N41gfEoCh2FeFN1r8GpT1pfdcTlE/pv98RMDZYjfLxaau6Lzi0yHYkyrfoN1ZJF8n68ONDhNOM/HF5/AOtLRF58mt7ZG7IsHj1FvNWJmsh8x78Xxl8rdbnb4q1gdINpRWoq/PRy
 cktiYsZR
 8n3ExdYp4uyfsTGBKfLFKXEq/1wiD2bqlDa5f4fo61RUf2MloRIvTlECKYIgj0KYr0lLLjXFGTcKVkWF5Ri0BcTGnU/acmcOt7b+1d6MpyZGzxqEFiNmszJ1JoDHEmzwvFnJE2XCXS5kkwsyCkglvM5MHJYxIAlU6tS4OEulRv2trqfxzB3dJehi/C+s9GF/8ulHDCkdLdBknxw93tjutNciuNaXYQIvc3NTbzlgpAVv2c9Sc5As3x8TWHIzico7tQrUF1uNOHP31loH4zpT9zEEWXqBaHiq+5zJkxTGLL/Tbz+wBgnCrIfIe0hyiIkmMrLwAD3+xQTp36sGnLEBiGUqNK81YYu9q42JO31FHrrmx17E2w4SoBQBarr1Dpj7YbmstEsnpB4XM9yd1OBW28NoUpiKXCkyISpVhqbQRVqDoS+xaWU47SpB/6AO/rLMCiUQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update vread_iter() to derive the vm area size from vm->nr_pages rather
than get_vm_area_size().

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old get_vm_area_size() based calculation
would overestimate the mapped range, causing vread_iter() to attempt
reading from unmapped addresses. Switch to vm->nr_pages now so the
reader remains correct once shrink support is added.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9cb3e287a1e8..65e0a23efb3b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4661,7 +4661,14 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 		smp_rmb();
 
 		vaddr = (char *) va->va_start;
-		size = vm ? get_vm_area_size(vm) : va_size(va);
+		if (vm)
+			/*
+			 * Cannot use get_vm_area_size() because realloc()
+			 * may shrink the mapping and area->size may be outdated.
+			 */
+			size = vm->nr_pages << PAGE_SHIFT;
+		else
+			size = va_size(va);
 
 		if (addr >= vaddr + size)
 			goto next_va;

-- 
2.43.0



