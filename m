Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9337BC5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 05:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725EA6B0337; Sat, 15 Aug 2026 01:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7706B0338; Sat, 15 Aug 2026 01:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C56D6B0339; Sat, 15 Aug 2026 01:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 355576B0337
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:20:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1981FA0332
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:03 +0000 (UTC)
X-FDA: 85102352286.19.6B5712F
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B566180003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rNWUedIZ;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786771200;
	b=Dm5jyKvTf6uu+DWrCpXOu7O2ToZrkBA2ENiGLs9FZphRPsYsJBl+J6Oq3hIbB3sJJ7Pa7B
	xdvFj7DNc4a8tYROZ1Xex0c9c0A7zZNBsvQoeq12LVkpG4DfKrO38kSlVw6r9t557eQibz
	c6pn2FgITWlE0V3hA88HnRYSb8XOCnc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rNWUedIZ;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786771200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jA30uY0QMPf30Z8XdJGvSBccQdQbzrAZ0FgVMAHJpg0=;
	b=SdvKo7HxwKc3LIgxY0bVdCf+s5P0TLXCTSJSk0QIJDDrecuo4n27Tm2l5cU3Q7X/L4wzfV
	abF7oKhoWHAW4yX+xy09OAWzkTDR6/7XL3TReMCVsMT7VwSbrEwCZcvPNh/JGwgKkCVsMU
	y2yuELF9g63zF5HdpK2uQAZRs7Kvtqo=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cedda2ce6fso11899845ad.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786771199; x=1787375999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jA30uY0QMPf30Z8XdJGvSBccQdQbzrAZ0FgVMAHJpg0=;
        b=rNWUedIZddaIRZErmbW7ZezJ/MKMxSMfnkdH4E7V+KnLbRAEVYPrmKzb3ttAebdTqr
         qzNOutmZtQ1GxreV+7x4fj70Tb6UakXpN2Vn96yW/5a0FZqHCy/FsRAq7G5x3MDLs7qS
         bNTn6TYcZDz1UUi5xWVsDMXPtYdl81NhatOZDuzOypkprdTuv4yGx7aVwF6grh+/huzF
         pZ2qFKmAj2dXCyuxWJheGRGHaWj7HnU9otAUpwOIueJj7JeK/+Jl98+XAbnZndwCtSFl
         k1kT1+AetZZnGWT+xtpzVCFAqc0xUD0bmJ6ViSK7cwCebMOoX8SbA1TqnnJU0QA8a2Wh
         +bzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786771199; x=1787375999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jA30uY0QMPf30Z8XdJGvSBccQdQbzrAZ0FgVMAHJpg0=;
        b=YqWK6z+LkM5sG2FKiyvam8uXivq/M9CqJDHweNEYKZknjQBvr3kQk4GAxSBuXhfMTi
         RSczcvxYLtAIfafQTajQ0MZz8Qh75/C/+EesGAr6a5ZA7hVgKyHEYjX+erPmsLomGeEH
         5tEig1P85T88EDOFoqo7PVQMuxsroL5ZJHiYnxHe5sCfJEcNdOt4ODaoqywf36l2Ydji
         yELWWUXKb41Eml9ky7B4rmhxDK99L/aNeV4cIP4ShiEOuFFoZRns5QkrNljMmkB7VM1n
         No6uL0Y4Wtgr2CwX0HuDf5t2OX+vBa91R2MYIaKE/Ud6hVhw81HomGNWLtAipNwHmKBP
         W/kw==
X-Forwarded-Encrypted: i=1; AHgh+RqeoYebNiSuHqowM1l7BGm3c22XJQ0RauzPB7Cq9gnI8WFrc7C7BYVJWnBv3kpX+iZsMBeo85tAKw==@kvack.org
X-Gm-Message-State: AOJu0Ywghhxh26Fqyx/EKKnFtjtFFleIAYcfmLmve6yvSr07Sx8SrL6a
	LK+Ywm+aBrlc9pUgeRETtb652MSUg0WllPOWeXwUO0K+t+SmDZtW8qIe
X-Gm-Gg: AR+sD13pJaNJ0MxKUbDyAdQ47qWoaDhOeOx2ynL2EK/XYP81ALh5sI3EHeX81VH4wW8
	Lp2ZXtFgJ/UIivis5lDxYDFTGH0qKNoEeNXVd4GV27rX8Gqjeyon4679sPyKXdjBVcQsk6WpOUZ
	LIEf1V2GrT1yOFT1jKZv+8PI5spU6BYeSYduhE/ODqOnKCE/RfoDH/WBsjk8X3X4+R6aWqAms/x
	3KaUglYzSuW0IzoFklhrwxCdHgX5bFTkj/vV3+2Cp3O/9W4kykITV0Vz3kXtjrVwmV+UkT6Ks90
	lz0FUBg0VnlIM/vLkGR55IkWUanY6AT8otAjWPFne85TiuPLIoZyViLKtojH+2ewi/fuAXNnyw2
	+6/TZQKCJ9B55hsjExNUjFPKUdxkG2Ia69VBgZwp8dy6rdHOobd1MyEgUH249FOIp3DQBO+hOXJ
	lnr3rGBXDdbv49kX5Ml3J4WqXlemHFa8agnPvdQZaEtiYD1xNf3qmZ34QjV+r2E9e+tCZsoSp8
X-Received: by 2002:a17:90b:586b:b0:381:bc4c:da5b with SMTP id 98e67ed59e1d1-3933b91c2ddmr11148842a91.18.1786771199166;
        Fri, 14 Aug 2026 22:19:59 -0700 (PDT)
Received: from localhost.localdomain ([49.79.111.198])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea96c7fcsm5269702a91.3.2026.08.14.22.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 22:19:58 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
Date: Sat, 15 Aug 2026 13:19:21 +0800
Message-ID: <20260815051924.194810-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B566180003
X-Stat-Signature: 6bbz4p5g5qw4uf5hj6ptj9j83qbjzxdk
X-HE-Tag: 1786771200-593303
X-HE-Meta: U2FsdGVkX18riGUNUHfOkZHIrqHOV70yKNfiyXKoyEgaP0+wsyFBI/B4aF2bapqmMhNjnClqmN+REa4gqStR27OF3mw9jxeOWhaxmvedxYSUMPDeBPklzSH26EUXzEntoUUy/Jy3zM4h28G3K2qPKMuVm5riMR5d5SDoLswd5axrbbNs6mz2C8vhdzAL54RoFmnYoav1M8fDlhnOIOOG7c4596N/QHc7NA2To0yLGAP+OIawC6g7KNhZuiqOLqls5lCI0yf1uNEp7MHhW49XY6hy3Tw2aL6xpX9In4/j8sDRerrccl4WOyJ5kYqrRqRD8DG+6pf0I9CcFCXYX4D+yGVgZu1Pvd6m7hahT889Nvy9Tplr6bYi1+z+5QfH9hvj2Lz56KTb+Yngupx834Ek/3Ly/iaWjUyl/VpTCg4w0sznIPdBQaoLUq9pO/CV10/Dna7/q/scuAcr5CCxpZBbRLu0XpMW6Y7Bcwztm3Ej4iUWRqKXzsz+0P4CCLu5jvoIdNF7k96ZkXFRu89rG8vyf2f4q9CxKGKVaSqyZcFHJFz54uogyza9zfAhzzZelgO7gE7rchjybE2VvuwXYptfmRKjOEGE/x4qw4k9Xn7HM5s/U6OWVKsq3QQ+WKNLDF66GEUI0Jz8pmk/x7k+4DZUZlW3wB7rDFTv5X0usvsCYp5UllNd6fkuzC59F6gSVM6RCeEBGpHj7d+DdCE6uOfmScL0GOzAmcvBsMxcm8UxnkKlgoCoiZTj+0dJM4pwqBmAYs9DZunkQxZbmT+PTKom1tGXQrnjFcj9Y5oIM6kEKDErY//+r4LbsNoEtNac4OMOqSJvNkgBm4dkEk1DCikgwsNbvHtbHeKwzvF1FqTHSpYx/VSwrNR7KJy2eBN3rIDNU3FOI6f2JX5TPc0RLGwDqez8q5qUtzBIPqQT6CoMO1W6SBOKsNABargiI+2yD9Bf8pBDudWO5EP+j1wYcVS
 IqEReFZv
 ZTKf6NQoYedxP0lbTK1d+gSmMISFjFXvfaaiwWpd3j+ovag5MVNhkxAxL9urs0OZw4X5fhd1uSFU+i9R+io9ByfKN4mjjioAyFBkXc/XrFkwMZQsuAJD4/XfNkN42kkk5fRcXwnc5cZkXb3BM/BCrVqLpn9t5P63EG0Zo1/p9YbXcss4EIiOCdmdBoigD+ALWc+RTg8/knnFujdOxRjh/2fcWjXXvyEsAVwe4FkE4D8oKA5jcpXvfi/A24yPONoRIQUqOHMjARgx0Fbhtbe8m8QTmZsj89I365FCVH1kXc03dfdTp4hL1uJeDnaKu2Bm8YnsKqOrUVWpzxlI3928nbhlmtjpkB6w4CulBQAALgvPzFVgMzMMz+QlK5rUkgnbAitKWluz/hxizPLM1R0qnz4yQ5vYwQFe9GKYmyje2Zq86/eBGHxAi56nHRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

The khugepaged tracepoints take a folio pointer and call folio_pfn(),
but by then the folio may no longer be valid: freed after folio_put(),
folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
xarray-encoded swap entry. On classic SPARSEMEM, dereferencing it oopses
khugepaged as soon as the trace event is enabled; on other memory models
it merely prints a bogus pfn.

Pass the pfn to the tracepoints directly, captured while the folio is
still pinned, closing the use-after-free windows in
mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
mm_khugepaged_collapse_file().

V1 -> V2:
- Instead of passing the folio, just pass the pfn directly.
- Using the folio_pfn() before dropping the reference or the page table
  lock.

V1 : https://lore.kernel.org/linux-mm/20260811133655.267739-1-vernon2gm@gmail.com/

Vernon Yang (3):
  mm: khugepaged: fix swap entry value to folio_pfn()
  mm: khugepaged: fix folio is used after pte_unmap_unlock()
  mm: khugepaged: fix folio is used after folio_put/unlock()

 include/trace/events/huge_memory.h | 18 +++++++++---------
 mm/khugepaged.c                    | 23 ++++++++++++++++-------
 2 files changed, 25 insertions(+), 16 deletions(-)


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
--
2.53.0


