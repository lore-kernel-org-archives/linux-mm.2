Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7B2606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWFKsSjK
Received: by kanga.kvack.org (Postfix)
	id D5A156B05B8; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD05F6B05B7; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70516B05B9; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6800B6B05B7
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:04:59 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9D1316088E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:58 +0000 (UTC)
X-FDA: 85387175076.14.348ECD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C807180005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hWFKsSjK;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf24.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJ8xawFkvQChuRbpRvFM3kzwdMyBEtgBeCZPpV2XFyg=;
	b=7qLfpY+tIhrW9dteUjHDx/WOmCFaee4L00viWK5HUe5dTy/zADIIvcGtlQzu7FXzmtTqkG
	d2z6D95cEDX27lL6lN/WyVkwYNTkHDGtOT5KVNQSD0X7IcIKemA1cfNEuZ/4XPGLtg+P0N
	WB9yh4HQf7rG2MUjdxIjni4lsAnc+RQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hWFKsSjK;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf24.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793552696;
	b=b1RzR2oOOpkxQSnYAOzS6sZL03Tnhh7G5GSnQlJxjhGLnUR/Z3FKRA1aU7NbiIubwGndGi
	DKtnrGZZb6f3/gyrX5qtzLtv+26263Em0U2xCu4eUHVsoU24XetbOp7/H/NGCR95J3rfYd
	okqpBhUgSoigokV93Dni7xtc3SYuyFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DCF543FAC;
	Sun,  1 Nov 2026 17:04:55 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793552695;
	b=qfjWH5+04uhsEJN8X5z5hdC1sLJp2JEOm4yJ85mI692oviINv+FwSN+dH0RH6aV1CeDf
	 ChIcnvikNEZ34zDp6lgX4eNMq8foXfhnd0HkQ04y+LzMBwYqsDx8K8cbaIsvJY0LbSz9W
	 UJLD1vEqo4kTsN+TIkgRWAInHEN5NOBjDqMGraAGsqCOYeIxCToHnHRiMZtsW4y5Y66PW
	 AU2Tpc56XaJ798i51td6GFPqt00y2/lOPqTjxATC+EasKndogylniLTVBUKb8ZoiKuYik
	 evCbyDFaexbSF/rw8pRGXM7KRjUYhel3OxvWazIXE5FQiO1HfCQPJg5vsAhaonGZF3A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793552695;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PJ8xawFkvQChuRbpRvFM3kzwdMyBEtgBeCZPpV2XFyg=;
	b=PLpVEs5Gu/t0rFhnijQGjoDiu7//4Sy1P+RVPmUFmfyiTVczSb9u+FCjSJdiGVPx3YGc
	 G8W4aalxyhNlG/Moox6nlGeUVISjqY4/bsXiBiwuDy9vdDbnm3YbLqB3uunf1kqycKY5d
	 OA9/NHSqmj7x0pjlReaCPnzGCdgHbwjFXwRWSOVE18jtVny/pv2bFiTXAE47/qXjlN7MV
	 LZTRbdPvsCK+2CLT4FpuEAa0IXaH1irv8NOvNIctqXs57A0kkkeONiwnRT/78sV3dDg4q
	 UKGb+DW23nSboyHwdOkIqdd7GP70JwntKu7gmf38KRLgCuJKmKPXaQsaNb2hVxQH73g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9CF281F00919;
	Sun,  1 Nov 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793552695;
	bh=PJ8xawFkvQChuRbpRvFM3kzwdMyBEtgBeCZPpV2XFyg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=hWFKsSjKc7QjZnpePN0uyidulXuwPGOXphX9fP0Z+84iVAQEi9A9GSNxvftKw6mGO
	 bJuUDWVi15fLfTPKMoj1mO79uV3ttnXGPogOFxpyZTaETKjdvVn33O4N34NbllxET8
	 oBaBtNFco3YhYlTU8AjjsHQTxb0N+VeVRrMXwW4sw9NuC0tfpBlfulCE8GY+0Wzu7a
	 /4SULSTlHdCMj7d3/05EtGrKxZRxAF3TjWvIJPEh+xbU+RX7pK6fsI2Z349mnylLeq
	 Jx+cnhpapzZIKmwAW8I0+d3vx9v0KQplmmjw1jwywTZMwWpGvB9wO0BLbD3RcOFMkK
	 rNUhM6U+Av+IQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 15737461F2;
	Sun,  1 Nov 2026 17:04:53 +0000 (UTC)
From: Viorel Cernateanu via B4 Relay <devnull+vrilutza.gmail.com@kernel.org>
Date: Sun, 01 Nov 2026 19:04:36 +0200
Subject: [PATCH v2 1/4] x86/mm: Don't randomize the CPU entry area with
 KMSAN
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-kmsan-serie-v2-1-f97f66dc57ef@gmail.com>
References: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
In-Reply-To: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Alexander Potapenko <glider@google.com>, 
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Ilya Leoshkevich <iii@linux.ibm.com>, 
 Viorel Cernateanu <vrilutza@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793552692; l=1962;
 i=vrilutza@gmail.com; s=lenovo-20261005; h=from:subject:message-id;
 bh=3GnlWiRUuop6GUO7x6h5NkCg48nWG8mPXHhT2pkVM5I=;
 b=yKz6MZ9gYqyG+QuCK81CgBR/q2zsFoBHJwnWKEvwQ6EyvvaGBEtoqNWRB3Iz2r9tvXCtvXbik
 qf1R5WMpACrA7a4Vnzww4SNVFt8w/FhpREa3DOYYxUVlJc+Mp+u3K2y
X-Developer-Key: i=vrilutza@gmail.com; a=ed25519;
 pk=HttZd2ffphVYTK/pvlflateaij8E4SdPd6Y+xDQMqDU=
X-Endpoint-Received: by B4 Relay for vrilutza@gmail.com/lenovo-20261005
 with auth_id=1115
X-Original-From: Viorel Cernateanu <vrilutza@gmail.com>
Reply-To: vrilutza@gmail.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C807180005
X-Stat-Signature: 8gx6qp6uf18pfzp3p6cd3bw5qx4xxjjt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793552696-770668
X-HE-Meta: U2FsdGVkX1/pjkWf+QvtMAaFkP7j9I2uTIClJEL5ynlKFfZqWXIlJxzOg++9S9pAyT7C1OKZ6V9eLoJzZeMkAqkLwcX+zvFbb2bTRKlgbJxP0uuXLTf8GSKesJ6j7Eo1RMNDB9yjyhYcAB8z3M2v6UQyZjXo1r5JD5lBL0/cs6fEnMce2U+1aaVZo0i9xGF4lRaA2pJqTBfX+n5kperU7+SQ1Lg/un2BawfF1lN/F/Eg9/aozl7xokK1U2xcMSGJaOgeUzQOIifks4xlGdxh1kvGiGfKe/X0UBCVdcmT3wnGXrRAtAn8nbYMzfysT0tqueaz6LjnGN6OypkRNzx7eAqjkzgVt9xV69oBJPCEniRirOLAdMbbQCZzSngoVztfFlgsEU7QAInsQnMy4wdp7hcPBbwXBcqPWOXHoOI9SH6XyMmPhHmOMGprKDV2e1NeUw1jQU/zzvmd/JVK7YoXLvB+x8daPDFoPKA885vaTmyT1l4CxEMnKAkE2l0n8zEgK68ocNIcPcV7HIsLImFCikmOmeeX6FfClMfGISP3ij5zG2r4XMOmDBcrbwTkimqJMhGuyzShFvIiRVDlxpuWi4ZVlBoRvaCRbK2zCKa5NMpKJZ8c7ak2KBp12rZSCy394XHXnrjpP3kJXcbaMtPgrsdESogUM46t58QjRlIHtaKAOe5l+Uuj3QuelXJvfLn4SnsA/TqT66Id73H9yBHdr13u+1wUIxtFCg4vDpi/b9eVxseut7zL6PpNSSwhCM9cWXsu+vh4VaxL9NQU7kjIJjSH32VtnWGxXmIt8Hei5McjM16XtNNKlh4ua3Q1T4Csf20ODC6NObehQyf7uUUqmWqDgzXU23T7jTThu32Ru8zMQgAFnf7bzPVdLH+oxRD0AmuisWSJIdPyUvfkCiPGXyExsHW49+gc2NMC2PKYxTJQvDlEvx2a42V9Wp7wd51Eco67d6LNfJ037cmIkeP
 NUtJVkaC
 NZHt5cGOPArP/ArsdgS/RlnHs2P9LTQsv7MUdvt8PBZqNGaKM09qjkWrT3RLIHtOG0cfTxfcR2Tq9t3zXUvQfXsq13qqEYJOOrgiKlaOjz0XT0x0E/O/UfmWaFRj1QZJuehta8Th3vD/iMHJJBo0Z7cuh6tKE+U5+bw9PuL7w4GIoSJ8tLrbm0ozCri7S8uGUX+1D+QLWIb1zZep9BT+C9L8iQgYjXxwrAKyKoXbFk+TRG/xknMJ18/2IxOmcYzOcJjyiDu3rY7FvRe76bZMXDZLBuOd3vvu7tdbeRJpblCvvYka0JShDNB9DgwLcT4X9wuYuVeEMImjawAzyHuqOb8NjS8lWzEqkJo20CcG/cwxlNuBHMC2BbgI3mr9lZqO1Lpde1ef8CcnEp2QGvD4r2NXLMX+AsjakUq+5KK4El4R4qHIyfHUdQgUbgA2xCt1wdLlxhqgBFApXBymUjV6b7fcAfFOFLEBd+P0uXle9xUQDOhRbeqNsisEDy3HtVeEAVg6sIffDU0R+3KbMGYn+cLf2NKlHHe4SzwuVO7NoKkx+aerZs7Hd35QAEnUnhS5y2/OK17X2DHbllxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Viorel Cernateanu <vrilutza@gmail.com>

arch_kmsan_get_meta_or_null() derives the CPU number from the offset
of an address within the CPU entry area. This assumes that the areas
are laid out in CPU order.

With KASLR, init_cea_offsets() assigns each CPU a random slot. The
metadata lookup treats that slot number as a CPU number and can pass
an out-of-range index to get_cpu_entry_area().

On an Ivy Bridge laptop, this causes a KMSAN kernel to oops during
boot while the hard lockup detector sets up its perf event. A QEMU
test that reads one byte from the current CPU's GDT alias reproduces
the out-of-bounds access:

  UBSAN: array-index-out-of-bounds in arch/x86/mm/cpu_entry_area.c:25:9
  index 2100006 is out of range for type 'unsigned long[64]'
  RIP: 0010:get_cpu_entry_area+0x14/0x50

Keep the CPU entry areas in CPU order when KMSAN is enabled. This
allows the metadata lookup to identify the CPU directly, without
searching every CPU's area on each lookup.

This disables CPU entry area randomization for KMSAN kernels.
Kernel text randomization remains enabled.

Fixes: 97e3d26b5e5f ("x86/mm: Randomize per-cpu entry area")
Suggested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Viorel Cernateanu <vrilutza@gmail.com>
---
 arch/x86/mm/cpu_entry_area.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 575f863f3c75..ce9b5d0e968d 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -30,7 +30,11 @@ static __init void init_cea_offsets(void)
 	unsigned int max_cea;
 	unsigned int i, j;
 
-	if (!kaslr_enabled()) {
+	/*
+	 * KMSAN works out the CPU of a CPU entry area address from its offset,
+	 * see arch_kmsan_get_meta_or_null(), so keep the areas in CPU order.
+	 */
+	if (!kaslr_enabled() || IS_ENABLED(CONFIG_KMSAN)) {
 		for_each_possible_cpu(i)
 			per_cpu(_cea_offset, i) = i;
 		return;

-- 
2.53.0



