Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59282CAC592
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 02:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8913E8E0006; Tue, 16 Sep 2025 22:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8658D8E0001; Tue, 16 Sep 2025 22:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A22F8E0006; Tue, 16 Sep 2025 22:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4118E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:50:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F17E48637F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:32 +0000 (UTC)
X-FDA: 83897213904.12.362ED83
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CB68C0008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GBgVgApw;
	spf=pass (imf22.hostedemail.com: domain of 39SHKaAgKCK4XOgcbaWiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=39SHKaAgKCK4XOgcbaWiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758077431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QvfS0lbIl6nsb5SOfYP9Zx2VfhCPX5J5Iuo96LcGehc=;
	b=qsqKTugh8/v1vji6hfUipTKzxGzYebb9pDcJJWqgWRo9meq7AugGbDwbIBPpt3q7fCCTBp
	U3gGUgaHnMTox2+lQS3V42BhxKpdyujUSznCPDAMTdmrk/Cy0IlXWHmeg1qUlTufibTgxa
	bI1vZZel8tnSai3buNoE/Fd8fLKh1rc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GBgVgApw;
	spf=pass (imf22.hostedemail.com: domain of 39SHKaAgKCK4XOgcbaWiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=39SHKaAgKCK4XOgcbaWiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758077431; a=rsa-sha256;
	cv=none;
	b=iF/ssMiraymFeygQCnJH/W/1U3cBnSj+8WrH+cicl8Gx58bDpnoeoABgR9lE2uH5kR0q1R
	zflTYoAqlbISRZIB5kzJiQmNQcbs4Voz8jP4VTc0uzJqmuGK2yB7gS2YOlLELXv5Izf5hF
	xe/mC2Tg13a0UkFaolGKmng/yl7Gdns=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458274406so119704755ad.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758077430; x=1758682230; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QvfS0lbIl6nsb5SOfYP9Zx2VfhCPX5J5Iuo96LcGehc=;
        b=GBgVgApwnwpW2s6CsV71J/63lEzkVDVDRxbU701JxxrvYZiMtr7gt+zsUQjUHh11wG
         xH5s3AZWsX3kmUgbqe1RKDa0T1ilIcVenIjY0nt+p/S8KAakfRsB+Oe75nPvlD6OWkbi
         ZB3PhKEW0rohr4KdKeFSbGNO9LtgNmDNZ4Cm95XfXWo7KVfieEc3MqkARMbSQhUPGvOe
         xDtQryW7SrjDo616mvola4Bg1q/ZuLc0DAhfg8gEhL4zS44ySQObE9i8rEty8IgfRC3b
         h7YmFd9jyaJhebNh0+Xuz6wFx8xD3p1lTbFfo9HMPW0W4If4tw+vz2e02Rpjs92oxhAY
         C5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758077430; x=1758682230;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QvfS0lbIl6nsb5SOfYP9Zx2VfhCPX5J5Iuo96LcGehc=;
        b=t5awSqFlIXL3ft4J8IQzGa/vAk7j0rKM0vVcS287kGuznTYSbLZrjcpMYvVzoDw3ac
         9fwL+wuEm9uSM0clp5795thMzNlN1n+JFmJUJqDMF+lUj5RC7N0ML/Esn6qHH0MHtTzP
         MSxNbtdfFWwyl5q+lkw1VZ3KARVqxbGWJaUKlUuGO7d5yrVknukFeNw2dxfXDofEaJKY
         rtM7dCN8d8q8k5/wcx1cESi8HOgJRX/iAGXG7Yri8o4IuyGzXFzLg87Gn1CPhS5bTat1
         Hvm9QdioA90nGc6+3iymKc0DOVtB7j+5Vbt7FdmCwm2VFvRU/VpEvrR8GGAkynsfyNOh
         mLDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJV1hEAvnD3Pu1XQ87m4AwJzJnWpoTUHgSn4xwF6HkDR6y617vk4Uwl32hdt6oizGatBrXUR2PEw==@kvack.org
X-Gm-Message-State: AOJu0YyRmR/fPCyfFTCTGG4wH1oE1n3nVCSBTHY8DcEsyk1nbhI2Q4UX
	KKdmCtKhtal4LUulqeO6p5D3VU9q76oN/dOok6VjVDnDqry6cxtHT71xSbh+wZOFUnVFMEsR2BK
	/S2kL8Ofrgrc3yA==
X-Google-Smtp-Source: AGHT+IFsWd78Zl+0JpPchoff8A4M5Kb6apJ4WgYWtl1LRPz8f4ijmhz+IeY75j5Bme4PyrExdVwrt2ZA8lDSow==
X-Received: from plkv16.prod.google.com ([2002:a17:903:1a30:b0:267:ea8a:35da])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:22c9:b0:250:1c22:e7b with SMTP id d9443c01a7336-26813aeee86mr8191395ad.43.1758077429969;
 Tue, 16 Sep 2025 19:50:29 -0700 (PDT)
Date: Tue, 16 Sep 2025 19:50:15 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250917025019.1585041-1-jasonmiu@google.com>
Subject: [RFC v1 0/4] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, 
	Joel Granados <joel.granados@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3CB68C0008
X-Rspamd-Server: rspam05
X-Stat-Signature: u895zztcf8epg5uy5zchmi14xpahuzc6
X-Rspam-User: 
X-HE-Tag: 1758077431-45810
X-HE-Meta: U2FsdGVkX19TvwvSXaZDyB2mMxd9y6vB9lhs3fBnULwSvDziM4C7vvEoh70Cx8JKN2L1cSOWQQ8LivEzui1BC13A9ZoOoHFk5gzxtczDf59ADtFjfC8abfrIwoJWBn3aRhXub/YzepcsOuyDKSZhWDBENlTSP9Ah2bsqR/aulJAUm7LmhkNY7RiXBeqx0z+j7JWhxzUEeRQjneuSzAi8gRt1H5gqpFaZKYF3OuZoqf23M9Hx8H8kK6i4Oo/p/oH5ZZ1dRQSo+/yjxSS5HgQZVMiBN1ZCPPfUrfGKRPuvPm1/mW3H8v76qd00IN2rEWA2cGYq6H4WXkmEIgWjVFpYI1ouPNJIrN2d0MWK7NF/SzHqqaT9bc7eDvJ3TXC/c2OYwubP4HTVtzwET5JfEyCSB0V6kjbMAv+cZ+CN6tWzSqYiQV6PKMMB8HTLEKEoFJWtFwr0vuVTZLkCB2G/UmZ0VfM64cPics2/y0f1d4MYGcuCRbQZrE4ueB1WOFvXoMrFe9O8FFKiRIXDO28iZAbVw+HKQmWbKuDPu/sq7k1K7yIl0u9OrJwG8iyyFM8QfgB+h4mDXLBEsdjo0lnEyQ55GnKHUhUa3yQt9iOi09ZC0IyfE3LbDOvNvYMZ9ZVb6pjDB5owyKHisuLxUHa2oWZEOLAox5jEeVOh/p71IT4OeaPXvyIahcLXbFCtMQjbmGzO1XTtYcOtQ5oyMdO+BSoqp4AG0zVZMYjEqMY08FGdNH4pMpqB2FTsscoyCePyfiBuodoSyWQ+OQLZ7uZGIxGdKVywpsxN+bjCfVYh+WgOAvkyxlmvBGp6RBu4wSb8Rkdhjhq+qwwFlJx/vtuxj229Opdxzy33pJzCpmgrnAsd8Qadfu9cjjeM0hdgXSOCO9/lwGWsji/+CUAMeKH5w8O8pQjIaH1cU/BtJOkjQA6bvFLGJ4IEsE/vAV+BJdn6LJyhN65/Elco3eezpnjP8rf
 sTQhoSrw
 ZS7WvZtTBNjAghaDxdzbLfsKMWkeLcRU34Rmz7xR1JbtK8oDb+P9QgfTUg9BJwBngGt670FjXG6bj8tQhonpu70kTwvAVFNlYxGypsGsX5E6Snu6mtLjEXEbRcuxyb30ES1Bh+LgqmZ92j/VrN28ydKR12gk/88Hx7VkEeV+C0LSfCWFb1ZoT7x6+8g+C1rYB+vud984hoY3hlyGrmYlChzgKRYKDW8q04dx9E0bYAXFZSkSuE6Okqiy+iuhW3ZbXI15AC21tch91/jYluXtoLWDDahTUDZ3KVjCeZ6DVcCTOY5YPTrYitPBeA8Ob7InqoSv4J/GXMeejVpOnLwg+M252O5sRtlYEBKPKHzfdr4Mu9I46wYt+0M4yhe1SD/rI5nc14U4pw4N64MKB8SpI/5i1oJM9j/E5Ptr812A9weFnS17Dvpb1xn6ZyzRYTa77os5OsL5rUal3LjzjpWn4XLh0ZE8RUCe4V+hBXBj6wkF5StsdPHFu15m8tr4+tEYMh22u8gfhGTi5mgw1rKrODHbjcAV1SSkSCcttLghP+Z2JaMSjVnX8H5UVhwA5ke44TpW7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking
system with serialization to using page table like data structures
that can be passed directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the former KHO state machine by deprecating the finalize
  and abort states.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a per-order page table structure (kho_order_table,
kho_page_table, kho_bitmap_table) to mark preserved pages. The physical
address of the root `kho_order_table` is passed in the FDT, allowing the
next kernel to reconstruct the preserved memory map.

The series includes the following changes:
1.  Introduce the KHO page table data structures.
2.  Adopt the KHO page tables, remove the xarray-based tracking and
    the serialization/finalization code.
3.  Update memblock to use direct KHO API calls, and adjust KHO FDT
    completion timing.
4.  Remove the KHO notifier system infrastructure.
        

Jason Miu (4):
  kho: Introduce KHO page table data structures
  kho: Adopt KHO page tables and remove serialization
  memblock: Remove KHO notifier usage
  kho: Remove notifier system infrastructure

 include/linux/kexec_handover.h |  44 +-
 kernel/kexec_core.c            |   4 +
 kernel/kexec_handover.c        | 821 ++++++++++++++++-----------------
 kernel/kexec_internal.h        |   2 +
 mm/memblock.c                  |  46 +-
 5 files changed, 404 insertions(+), 513 deletions(-)

-- 
2.51.0.384.g4c02a37b29-goog


