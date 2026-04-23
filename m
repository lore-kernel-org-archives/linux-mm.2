Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C89F589C8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBC06B008A; Thu, 23 Apr 2026 08:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3316B008C; Thu, 23 Apr 2026 08:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9656B0092; Thu, 23 Apr 2026 08:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC6B6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:56:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4606140129
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:56:55 +0000 (UTC)
X-FDA: 84689820390.12.312C259
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id F12DD120012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:56:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M60egiMG;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776949014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NjJs6otazK0pUFP+jX92LOI1+7WZI43Ax0BYsKol0z4=;
	b=ovvsMZGg0GpSkYlOTOafUspo2TVJKg68FUlND9xtXPrLW6flNdyjdLkIu47CwsxasuMGTT
	P8A/S7pA0LK4cnbXBdPnv8NztBW+di4Nc/rQlG+h83k0TLiR8uk0CSNX72PXNwvNsap4m+
	hRPrkzs82qd+AjSRzyxNsLwSxZygA70=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M60egiMG;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776949014; a=rsa-sha256;
	cv=none;
	b=lwTd2eWk97/WGnjFC/rhJM7JnuehnG7s9NDRzzbt3MHrgXnw2Ez9aExlfvt7WvIEV1Mof4
	Rf+6wA5cWDN9qyVBSbOtHtfCuXSOFem2ZeVPF/PYRv9x/kMjA8fM1fClRnA5eV5q65ux+5
	7VJW38bAquk2fUNtKH2Wc6ujzQ6MxO0=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43eb012ac4fso4033059f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776949012; x=1777553812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NjJs6otazK0pUFP+jX92LOI1+7WZI43Ax0BYsKol0z4=;
        b=M60egiMG5mx2Helh/E0cnJxNW5ksnAoLnxwrQEnz5YSc4C/92OZolWjVncf0vhKzB5
         /s0MmhldjgjHIgALnobU9mz2Ie4m74tE8lo4c6WBP97uZPMsM8KUWr3Uo649lpfb01G7
         wIjvL2F0Ym79y3j+wmnsEwlV20rr/dORQOIFfOWsEdMyG4dV5X6HuOJA5kHdoVzfKGrk
         0UEoCYLGP0QBJ8AWhg+KPv+htP/3du5TosBCFLfCPhIpUMaX+HboJ+NSSI7/hvm+dGR2
         v/XdJbKPlTCu+IoB1l6w5dg1RSVp9w3VC69613Iahyj34E+yJTngstquA379yh6t0LYn
         IO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776949012; x=1777553812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjJs6otazK0pUFP+jX92LOI1+7WZI43Ax0BYsKol0z4=;
        b=bZe1Jj2MAvAlZKC7lZuZqDHPNCDqk4jPTnp1cEiMZkod4RE7U7yCzPboC0RyhELTpP
         +FfYXKHp+//HJBV1cNq7635HSFIllw6/lbYTByOYkmTjuabiCYc4L7WaC1Ho9/qTii3i
         DqOkDti1yUnfiFaCE/2iL0SkykHRxlinPQ+GXRqTg3d+8WwFpBJ4xBEHJRONIAL87p9y
         E9nk11PBd2yzOkk3QJnLG98oeGrtsNDFlm0+d3vMP+h4BZIJZ57zzHA44Uc/VA2sjrEc
         6tEYjfVMZJXXxbf4KvM7PZNJtK1z2gwpeJrJ90mbKmYdjt0uzYVFcgWs4OnNTxwe0VHU
         tnXg==
X-Forwarded-Encrypted: i=1; AFNElJ9Aj8bkg3GkXKsAhiU85E7s0lIK5cN7oruibaqgCaU8MCUSQsWe9JWyA5hEhYLSvyerD96eIsuwmg==@kvack.org
X-Gm-Message-State: AOJu0YwS0+rqUAbNko2CkaexcCtMxkLmwQR0l+vNqdEw+I4mWW/7kYWt
	22T7TEhh3TTQeCSs8hNn1fOYe3KaPum3z+DuVVDASin6ZYVBuNWLfFpV
X-Gm-Gg: AeBDiev9GfA47+5Zd9gZn0fltTO+HjdVD5WSgextj2dsNtgU2o4sxE0sVtrBA/eDCa2
	45NpzqYoHX+SdDH1PaK8Up41MFLgH4RaxCzlIvn5Qk6suDFIu8AVX/P9r/OZLSi00ZfaCdssGJZ
	RZPpU9/B04O7Pz3SprWMvXlMfnWXRjRYVUhsTZt/SV3G7TQ3VvgalHosnKu+azfs/PWp2FiF3PE
	voPNubd0nVtJ+hLLVMKuC4z86hEwktCTJqa1hqoILuLzFGN+Imubp6ceiuSpkepzOkK9pEW+/Tg
	Mqg4Qw9EqCcFs8grC/RMkUvwoL8BPva5Asy3zoF6krLIk5AeLKs1zwU2JSsgrSUGf/wND4IV9ob
	JdaQTJNnPzuB0QEyPxYjaj/v9zYTKf1VKAk44Ol/x3HbUa2E7uY+IvojPjUl1h7tB2AEwP5SFxx
	RN9Duiqb1prJTBPXYTGsrdDX6TUh9YHeb77hprpRf1zlLsJNGMVd6VMhDbnZHoRq5SDKZY/7us0
	HxYLUeRTJYDvHtOPITL9Q==
X-Received: by 2002:a05:6000:2dc8:b0:43c:fbfa:20a0 with SMTP id ffacd0b85a97d-43fe3e077d4mr42391674f8f.25.1776949011962;
        Thu, 23 Apr 2026 05:56:51 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1405sm52887714f8f.4.2026.04.23.05.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 05:56:51 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH 1/2] mm/memfd_luo: reject memfds whose page count exceeds UINT_MAX
Date: Thu, 23 Apr 2026 13:56:47 +0100
Message-ID: <20260423125648.152113-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6i1chpaw8rf89hbgqwxdu1c7nm7utacd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F12DD120012
X-HE-Tag: 1776949013-453703
X-HE-Meta: U2FsdGVkX1888UflEe+cFIxJdyeHY+4AzwcHheE4ECwj9uAppR5KT8gps2NhxH8evAsUNozpVn9u21wsVqLEC7eOexYL9d85IYeJCnEkH6Lp3FOVsL4tHFAtjrjC48G7vzYwFh7PpURolYLpO3jiIB9QnGPVegDFfOYDA4C3EKWocmfqIn+5CRwV9rSOJB5Y8c6I1QG6QlZ0qUeH98DsqAsjccnvPBpNdRVHLHnxgeEBjhZ1jmVOAHDag5dr+LjdKXO7pWOZxDseV82X9HWYzqJWbgVLQ1sYei1hok8/XRiAtidCx+2Xa0WgyHkYH5VyA/CWPkVQ1QzPy1asrHz/8afymi+iP06AFdWx1ZeFxy1NnPU87EhDG3OyV1yNCkt3+iOUWrBfNiHkTzMxMdGMnSHVSTD24NgmcayfGhomuhZ7vLmBPGMf3epaQax4yjGZzCfudf4Eo7Fk5kQm8k6Bdsck+45LFB8FZDKyoMh8dlqQSUb9tiXoNPOW6+tDA1nVjisFV2y+mJqOJRBvWwlV1p6dcaVVF+n+GtJov43zlDmobP+kmzI4MWBXxFcvqCSPzkhlRBrrtooOU9lRZD9qyt8LWFDv4IIHTGFRC18dulmbfgz5p+EIMCL16V227p8x0ewLVP6RHUmmrcekL30YG0Y2WJf7aMIuY5UrPrOHURocPKDcXifJYFKBXYHBfaiT7b3r3Y3V3wcpVQuAtr5c1JliUt4J74uiQ2bZDEo6pU1un7+f6zdqeKai9PX2eJmXIwpt4hg6yjIhC25rb5msPXDmYfx3Yh6zzBRrp20rTVY9KC73GbZ/vQPlUmOfrXbz7I8GNNMYv5CpfRP552BTizDxqT48IP8VljII2fWhw/D46kusTTJDaJ2DkyQvg12pBpdt26Jm14ZuqLdlDksARNz4ARiSBhH/S9ChTuIp3mN8snE+QSjDgKuOXWYFtKZ+M4aKhGPpTwzEp50trGU
 y0eDgP+F
 CfUkIR8h+9NIA+XKH88w6ov6WoBsAm6NjCMH7n8aPBGEawGTuxtxPQBu4EMLGnqP8BXlzCPiUOa1yPNSnmDiuDxqxwd0u6FmgYR7KTJCCwlmY4hx6qc+OCzW34GOVEvlaV+I/MNnDOcNp4zDjraFnNueGJUF7l6H1UlzoS4O+P6s+APaqH2cQEE6vj869q/3PgtHQBBzGyde5b7iXetFPGufiBtSyTy8lpFaGk1CSPxsbBBxjbhnYj9nMRoZHhDNF4tnGpiNJgD0mk0rPrDfUnsOjrB9ekwzuTHEJpiRqGtlZPZh90QLF+l9rwjrR3wDWOsDJJgwcZDH7h9FCnJPGlYzI+bPnY5IQt1qQXt/KQlOb154K2I4Cd7XwMdRaJv1GuZVpJrQVZpc7xlMtXzjWl+Co0Du1gAuD4xchTqOWbsGf3jzQrkXjWTy06aWa5uK03foh2QtrW/1iqqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_luo_preserve_folios() declares max_folios as unsigned int and
computes it from the inode size, then passes it to memfd_pin_folios()
which itself caps max_folios at unsigned int.  For files whose base-page
count exceeds UINT_MAX (larger than 16 TiB with 4 KiB pages), the
assignment truncates silently: only a prefix of the file gets pinned and
preserved, while memfd_luo_preserve() still records the full inode size
in ser->size.  On retrieve the inode is restored to the full size but
only the preserved prefix repopulates the page cache, so the tail comes
back as holes and user data is silently lost across the live update.

Reject such files at preserve time with -EFBIG rather than chunk the
pin loop, which would also require enlarging the preserved folios array
well beyond what is practical.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/memfd_luo.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b02b503c750d..f41d11053b7d 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -259,7 +259,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
-	u64 nr_folios;
+	u64 nr_folios, inode_size;
 	int err = 0, seals;
 
 	inode_lock(inode);
@@ -285,7 +285,18 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	}
 
 	ser->pos = args->file->f_pos;
-	ser->size = i_size_read(inode);
+	inode_size = i_size_read(inode);
+
+	/*
+	 * memfd_pin_folios() caps at UINT_MAX folios; refuse larger
+	 * files to avoid silently preserving only a prefix.
+	 */
+	if (DIV_ROUND_UP_ULL(inode_size, PAGE_SIZE) > UINT_MAX) {
+		err = -EFBIG;
+		goto err_free_ser;
+	}
+
+	ser->size = inode_size;
 	ser->seals = seals;
 
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
-- 
2.53.0


