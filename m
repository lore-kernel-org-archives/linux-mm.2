Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F7CCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 01:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8B58E0008; Tue, 30 Sep 2025 21:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A978E0005; Tue, 30 Sep 2025 21:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95C18E0008; Tue, 30 Sep 2025 21:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5A908E0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:19:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9419F87EEC
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:19:48 +0000 (UTC)
X-FDA: 83947788456.30.3443E95
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id EF8A64000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:19:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wuGntS7m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3sYHcaAgKCHQbSkgfeamYggYdW.Ugedafmp-eecnSUc.gjY@flex--jasonmiu.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3sYHcaAgKCHQbSkgfeamYggYdW.Ugedafmp-eecnSUc.gjY@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759281587; a=rsa-sha256;
	cv=none;
	b=2t1/Q8h7PtjKi/lrCwqHp6A/EmGuf3JtZ0NEHfmi5W3Fxid/qJqAxWt/OB9J7EtGCWb07/
	6bWD/bSF3otMA4xucFYnLEIa0Oer1PhI1b2OfQzxewJrbcuj/3bZZAP6DCg6C4wch0EY/a
	lJxsq/zR0Qw8IagBmLmWbo8MtjCHQ5Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wuGntS7m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3sYHcaAgKCHQbSkgfeamYggYdW.Ugedafmp-eecnSUc.gjY@flex--jasonmiu.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3sYHcaAgKCHQbSkgfeamYggYdW.Ugedafmp-eecnSUc.gjY@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759281587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ifegM91VMNYCdV3RhGc/5AKOzdvQHyhQ3tKlNLE40ko=;
	b=3qiEsvVIWdW1kdl3CkKCuEX2eo6jmzOcZOT8vwG+tiysSflJdwJTYoAmFJrQUU9Qhj1L3s
	V8SGvO1BhYPV0/+zDwNUG36jAYRueS+BELwqs5I2HSapvzoSLmIpHJDc6SscnWBTViOjnF
	p29algnHcHJ4bSn6XktyXsq8sDPdz0o=
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-76c144b0706so86444307b3.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759281586; x=1759886386; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ifegM91VMNYCdV3RhGc/5AKOzdvQHyhQ3tKlNLE40ko=;
        b=wuGntS7mglR5eoxCku5w9zSjSdtRm3BDMa2UUJALpcqH4LreNDsfR0vOXu+iMd3f7U
         yJQbtXB6aWVGOlmM7VcPP3CTwBNYY790bePljfbcozgbMfG15L4WVCtyFVHiylQH8lB4
         iraHY68Y34hzltavF1if2RlXE6HVQC3WKQlr4pSQVUUvfUCJqywCIWk+BJR0Num5oXJW
         TPIgQ5NSYFffHioMtYJNHVHm1+b0h78hbD9h3BLCreVac9APeSh1UTgWBIN55Loa0R+z
         oFAT+eMCMh7IcYCBeddk8WCjwUmCb+nw+I0ygkd+HPoVUTLdettviw9FX702qcedHuR0
         R+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759281586; x=1759886386;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ifegM91VMNYCdV3RhGc/5AKOzdvQHyhQ3tKlNLE40ko=;
        b=cN3wnu5wxL/PITpTcQCfv/glShmguVyJBptf52OAZn5/Evyp3kdDVnCgmr2B9Ucorw
         Ve0HUAuvRiL5EzjCBidNMJ8O1S6Cq4e6WzJ5QJfrOOB3fBQOZpaqeNhBmAHASs/UgwlR
         sNGfBkYWmZWRb654LDVDibBvyKqGlG6L3WYScwiKfL3k9ORu4XZJRElLAwIZNKEnu1PU
         WchYFxByvJzLYqPTEoy4w7RptpQzvkl5SowaF+IHlSN7nY6MLD3l4lmfFSqkNkTAucpJ
         GgRklKcVv83SUakmWPW+uU/G4HirS1MbiL4OZv59AUE10nOXaTdUIqvzy8xTC2wEBXnh
         Faww==
X-Forwarded-Encrypted: i=1; AJvYcCVlBPEtwOhYQSCKpaivmlXwCm7JLe7QlyeCApvDAtcPH8V/ZfuYlXuacP/WTrJQZEp6t5lcZ95iXg==@kvack.org
X-Gm-Message-State: AOJu0YzOoC4YRVU65Iuv9n1+aAe4kCONgYjZ1TPBY7QR6zgfch2a4Ae6
	egeKZCI7DcXOfK+xWioURSAiXd8kxhM+Oge5y6yV0fij0elS0K41Pal+mIbIuPcDpfrj4ARusvf
	e+CIyJ6bhObi1eA==
X-Google-Smtp-Source: AGHT+IHnDLAnHU4+42jOPdelDKDAAM8AUpJw1mxLW7+QMrPN8GTOVoPsFzFmqWP34QTuhqqEfQMVQ6uv+qBPag==
X-Received: from ywbjd11.prod.google.com ([2002:a05:690c:6f0b:b0:775:154c:72c])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690c:360b:b0:735:8634:be49 with SMTP id 00721157ae682-77f6f117fcemr28154297b3.21.1759281585803;
 Tue, 30 Sep 2025 18:19:45 -0700 (PDT)
Date: Tue, 30 Sep 2025 18:19:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001011941.1513050-1-jasonmiu@google.com>
Subject: [PATCH v1 0/3] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF8A64000A
X-Stat-Signature: atghxc5e7exbhq7zhrcnxdzr9qew5g8w
X-Rspam-User: 
X-HE-Tag: 1759281586-714157
X-HE-Meta: U2FsdGVkX1/weDOOQHi1ZIKC7SUv57N7i4LgLhU3jrxzqnh3cS9G1y7HSCbW73Ktimp8foAsVARy4veJuzZGRD4Z1UNjltBJKo1Y3rzKn8G8rdrq30gRMpXl2P1S1oIeCtbhwl9VUPOpYS3h5UR+oOJRabdpuPsFmVm9kuxtkiYi+Fk+InTiyMeGwd6vVnpwZG2ID6vy3o1bpXP9Td9Sk+6mPTt6bXOrsDuJu4Rn0d1n9McWnmAzRD7gg4YI1X9eb5TM06yiVtmaHUWIQEjB05SPcSsvWzFEEA5/W5VBeqGG2P09SHKL5hS/JNjZWpHWj4Xv1Rk4B0QvTC1PPQvaAlJ75zqpb1HDhiJfzdEG2qgKcK1QsBLlH3Wbhgl7+3lqvCNqL367tetu1G031VB7kFu29J3wVbO1903iS/rMVg1UbtnndOjSvi59eb29iNUG+SlKTfBuv/5X+B3nub1llmD4dDruSXF8L69N5j71laMqCfGvGDWQfnYUUT64HvnPkcay66OaCwdNYkbKSQ0bN6kiuQyBQj64567QgPzyVJlruza0mmDk9xDorz/RaLfWizSl6dtnC9r9tEPA+I2DLoDzZvLgcvBd5kpfbGH7i3qduFEptWSHpkKcB27hP3hcxx7Bo5YVRarwkEN37vYLu5rsEaQtv6HgqDf5IgNRjTxMDoZFVbPF4vz/68YjDNbnjnsDYmMZGB7s69MXuCJ7l7cg2DgGbbwUmRV1FvdWBy9TYB2hzugW6cnxbR7GAVBCCDoKCid4D1OCHYiO57zZ4maqnT6puCwdnXQxJ9I/kW1RXzsmdR+4Bh3O+LtqbanV1enmhjV/SrfWYZN5kpiDXJTuIOWS7GNXv/IkncXmy2tNOZ1XaiAH7qF+ZUhsl5jVJ1FuGMK5u6+5pIS5ktNsExU1DX9gOwpl1fJT3k9okIbMYIvh02DcD0nX3N1b9nOQhcJTrZqK3bpcvqYpzYB
 56aDeBBd
 XGcGjvcO9VB+Fp1vkWuMxi3tCXdiwUY6mNJVnyEH/smwBQx0QDgG0MGr3FkdvLsBWu/Zvf2GqCS+wKC5rft5KjzQQXHCLBVdIEZzfPNgxCsW2aSp6AjwNKo3jN5vZxZ6wd3/2DhNeB/ZcQiHgw7lTfLEuxPEnaK6Q45+dCNPWdqF6n76K0KET6c+Z2x8jAhqw1W5a8EK64UT92i20bcr4Bd7la861w6cCjvJLIUz7Wvg3+M0PokxpWfQZDltWyk6JdrzpToqpLgGrpk/RSiGztwmyfM0/bvzEWDcoXg9qql5EZDaZ/rDahSKaODIiM4WvaeuCXXMPYb7EIl0hceHnqRKn6aph5XA3hLyezhS8HOJxifzW/0FU8dEFaeP6knUQ+URdqJwRrH9H/LN1uALktJ89aO1Qq7xPkHr0XTvFNPPUC01nTZ/dK+vBWSIwqFXucR8agPyaXX5EPzhIKCgxH+g9I2ox5TgIjDsg5Z/A8B2F+Y6BzN6Qv63Omg6613qC5pksYLZGvRKYu7+bntsTi7BnYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to using a radix tree data structure that can be
passed directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the former KHO state machine by deprecating the finalize
  and abort states.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmap tables where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

The series includes the following changes:

1.  kho: Adopt KHO radix tree data structures: Replaces the xarray-based
    tracker with the new radix tree implementation and removes the
    serialization/finalization code, thereby eliminating the KHO finalize
    and abort states.
2.  memblock: Remove KHO notifier usage: Decouples the memblock subsystem
    from the KHO notifier system, switching it to use direct KHO API calls
    and adjusting KHO FDT completion timing.
3.  kho: Remove notifier system infrastructure: Removes the now-unused
    notifier infrastructure from the KHO core.


Jason Miu (3):
  kho: Adopt KHO radix tree data structures
  memblock: Remove KHO notifier usage
  kho: Remove notifier system infrastructure

 include/linux/kexec_handover.h |  44 +-
 kernel/kexec_handover.c        | 788 +++++++++++++++------------------
 mm/memblock.c                  |  45 +-
 3 files changed, 362 insertions(+), 515 deletions(-)

-- 
2.51.0.618.g983fd99d29-goog


