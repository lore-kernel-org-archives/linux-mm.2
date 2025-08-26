Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C5ECA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F486B0102; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830666B0103; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745ED6B0104; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 652316B0102
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDDFC1A0718
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:34:20 +0000 (UTC)
X-FDA: 83818397880.27.3C9A39F
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 288EF1A0004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:34:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IkcExV7z;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756200859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=W6VbYwRmXo+r5ZTKqVvWwn6M3gW5k+dEdUuyrT2OM6I=;
	b=t1QzRlcDscB48Gjf5MOqbQ5kIxmXnuD1SoR3xjjs7aEQh2NOVA4ysB2KaepMiS0WLbzE0m
	PPuDhV+Vi6b4tSqZq1KL79vRWz385FV6Jcrtoop1sLr/cakwkdLRUaLMRcwa5urLovedtb
	rCnBJmJjJoDC+y2WplXvJpXZF8SJmH4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IkcExV7z;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756200859; a=rsa-sha256;
	cv=none;
	b=MXeMFmsK/R7t2aNqLts9wYNF5ovPhIlbne0eL3I4L6FdxQjFsoySA/PtNBgt+7cc57OE6y
	5TJ70tnzGYBno3jLSqTbSzQRAfb+BMsjT37uaBzdsQhXIJVqJoSDgaj10eG2ZTm99guQlz
	yvCNlbZzBGxEEl8ORolCC94zgtnsJto=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7a8dd3dso800980366b.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756200857; x=1756805657; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6VbYwRmXo+r5ZTKqVvWwn6M3gW5k+dEdUuyrT2OM6I=;
        b=IkcExV7zux1slkyNzoDvQ17nCWlxjZvUHzmxRMUmaVGNovyCwVBQtD1IXmKSlPePNY
         BxqNHmmBghSEzH6QmnqcA65u5aXKxt5niemsDWG9rFXB9/Jz8KqCb/L4kloSiRs15MoV
         KatPexYsRWF/LltVNMIOrtrmVGnGbcN/nzV1Z5sCqZiYO6JU2TKb9ZKmCU23AiQWo5Tp
         74LhPxYim2PmtpLg1U6buhhoHfC0lX+fRLu+ppeGPyrcT2s+53JnJsm2DtQkTvtFWiLu
         T8y61cOf3lYtBc6D3N6IkFGWbJsz9IoQZvw8cgBBa/WezuhBhuFgYz8pFUGGt0DpPAnK
         xuyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756200857; x=1756805657;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6VbYwRmXo+r5ZTKqVvWwn6M3gW5k+dEdUuyrT2OM6I=;
        b=o9Urs6xqdeFDIwLQSnucCvI2r0cyyXbItHBnk7j4Vh5oP/dvgnOAVIEMNsDqGMcvWx
         EXfHDMBNew0l7+rzoGN+TfxCpnWgpeMSd9Qu2hWQUZaFjBXFlYd0aZl9uTUuyLhcfN+/
         oVO+5GQk7wjkw4CFi3pRVfh5l8zMI+Ows2DSXj7bBysdqqnY+Nu07fwEhWX4UcyLfRDi
         IxcfkOdULc/OUXVkUZCaBHj34KsOcog/WMFTh4OVNxWLheieqn1dr1wjNqcoSH3k29oA
         fOkysD1k7prx78e5t8iqx1hWwAdgIPhhfb50s6ZdtApzYdCR9dWSf6XcJ1lOxfBqIRJs
         mdhQ==
X-Gm-Message-State: AOJu0YxWXek8Pyv80w43OH7duKyL6HNJjSR6y63obN8OJCcZYaLNECGG
	PJJUJYnRSPfwqu2tK1U9e2cibuwmnFZOnmML77ylNY21PKS4iv9vfHcx
X-Gm-Gg: ASbGncvttjYu0VFS3TdqRizo7miUkShF9g9WiamI2XWmCANZgtr8JbeMGvhBYXIMUxI
	jX/kCgcDVHl1pvgFIx/dTXFN99B/B3H7EBQfgrFQqVsAqqTwLxeGXMuOzPdeORodNcmJ2BkVv3X
	sychiIlhcndh/qFOuE91LsVk7V3oLSIVmBzR36gn1ijY1p5f8mTrwqah8nCWGuo+OgiXaFD0bL9
	2PWVV3HVa+2hcs4s7tP6idqvxfWYznPEPVxlnaIl0nt5DLlDq6Vb+qMj7WG9II1AMZmt9uBb5BJ
	/A9xlze18O2iwsLua8Z3mdtRTkDQYd9lJwLW0hhM0a3M7+loSwZxeuXClY1aYu3cZwePhu8dOnv
	SmHzG3z6zfwlM55A2AjiHs5/MyDbNUEw4UsuI
X-Google-Smtp-Source: AGHT+IEqkeGXpXT9SHkf+O7A3MCrh7tBOFn8Qh5Kt05zat9aq6V2/wb339LbkJ0E7k/1YF/FVri49w==
X-Received: by 2002:a17:907:72d2:b0:afa:1453:662c with SMTP id a640c23a62f3a-afe28fe7093mr1203611066b.8.1756200857183;
        Tue, 26 Aug 2025 02:34:17 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe48fc3de9sm746721466b.34.2025.08.26.02.34.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 02:34:16 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 0/2] mm/pageblock: improve readability of some pageblock handling
Date: Tue, 26 Aug 2025 09:31:46 +0000
Message-Id: <20250826093148.30190-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: 288EF1A0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cg7wmxmtxo9kckjfnwjjbduwm1c16w9q
X-HE-Tag: 1756200858-853742
X-HE-Meta: U2FsdGVkX1+eBnrNDd4bB2QTXRSEbZ3g3Kl6qNw6F++sqardDX2ZNbnVFu9ZOANEhrrxeQSyOPZ5V+DIB6UNkgViemthtZ+oQgn1VmS5IYM/TtY8zTw9HSOtBWlqUFnYAGpO710S5W9j3anoy262kgoaidEZRxSl+3b2snveriA3uSMLllfWYA06q6O08ZEYlt36/o6/0Nv5T6yvM4rOJZ6k7zxNLlv6yOb2KkDFdBPpoNfA9z0mnXy3803jPaR38LfDmMFpGZ848GUxau/Wf6khBWb8qvdlUZ/2iHQoAl4nBwJWCcvM0rpLflO0k+B6v3JyUixg/uDt1aG4vTUvV27xm9fLejIxlap4aroLCQGUcjDrtNSmWXGQ3lG+g91KWohO+8wEGw05ppWCz3EphO36tLxJsKS6Tf2G+C1eO3hYL8SqdNfTmdBUXqQCIRlfoHxFkgpW/wmZeRX4u8YbaTrC+6DwDrpEsjc/GEbwOAFdBT0zsplKBQeCgo3tPgFQ3sbfph0eHgg8X1jhmzOAMFfTo0wDNAuPX7bwNKI3FglwNzRUN9wwWBP1BWx5uGlHj7NBBnT4c1Hs5Oxrj5xsIDCQX9lWMW6wQaPwJC3P6D6U0L0E3VK29NYqaEK3lBXAy0DsH93pK95KCzJqDmYgAx5ltRw769pkTqwUtqokXt4UtqfWHUhyEUvn9MMnrCrAwkZ/gvygoe2hJ2eVrf70HSPO1UH4QzWM0OYAe7SDHEJqLkN9zi6SeN8z33AiFL/4lfpOpY0aG97BOXkY4bq/Yux2qGH2mSBJGYrrdsbjNaPaV/gxtfpJpen4BDEIOosCz3S4R/RdgMjrkY4mGEjOXlr8jnEWQ7IaVaqVlAGREpCOmlf2MGUPTKuwGOnjVrUndOPYOEMBA5h30dK2urNxMZSALgjuc1LkwWuxKPviLotd+DR5MY+BTutvq14g/B+YSmQgmoUh1S9/tiR84y9
 6i5JvAwI
 t1sjLu0lq3x2H3Jq16Tl3UPEibCJ0LjPrPSgfC8xmR08a/XVoENSRz6HXD91n4dQAT2gB67RCvK3rbgUbxTgwWs/Hvkou84GguTJz+On4Dgw7bCN0G0eGXYEOH7n5L0enIuXlRCfuEU5AsLNdCONq3xOd/iIRi1XZQOEFoTKhPgY6R6W7dx8dxFzxJ3Xl1jbCthd3qvHCEyfHbji5RzvUG64fEmuEGCZc2QzT+9r2IPopDWS0jzF0Xd2nhcVCPu8NPlZQBF7rvkyE5lfw3fqnCxtxugUPBRJ8yJJJ/UY1Xim6u4jXJ9NjxfBoX8lZAZXVpPbaLKqLph/gyM6/A7Meld08rNayZq0FUyq1907fhVzoYXdhgy7G93R0pHVUu8WtqkXLmrYhKSpeNPfV6PJxrob0G0j8PmsVKb43ET0IXxyx+LPslnm0tYXcLkVcxaNM2YoCX2auGPwU2dYP3lMS1RZAvt1VRI+nC3WiQqf+ALv1zaUoviD4W8vM7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During code reading, found two possible points to improve the readability of
pageblock handling.

Patch 1: isolate bit is standalone and there are dedicated helpers. Instead of
check the bit directly, we could use the helper to do it.

Patch 2: First we could use PB_migratetype_bits to define MIGRATETYPE_MASK.
Second use MIGRATETYPE_MASK to define MIGRATETYPE_AND_ISO_MASK instead of
duplicate the definition.

Wei Yang (2):
  mm/page_alloc: use xxx_pageblock_isolate() for better reading
  mm/pageblock-flags: simplify MIGRATETYPE_MASK definition

 include/linux/pageblock-flags.h | 5 ++---
 mm/page_alloc.c                 | 7 +++----
 2 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.34.1


