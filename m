Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14544CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFBB6B008C; Fri, 12 Jun 2026 14:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171316B0092; Fri, 12 Jun 2026 14:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05EE56B0093; Fri, 12 Jun 2026 14:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAEFA6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:09:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 904B6A01A7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:38 +0000 (UTC)
X-FDA: 84872048436.02.74365BC
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id CABEA12000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rMfVFIrN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781287776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tIviRJIKLG37v3E4DnE8ZIX3XY+lQBK31eI/eTdPTgg=;
	b=ep6h8uOme4kNkEXhDTx2JZi25KU1QGdehKC1W7qAwutlqCsWJZhHaM3pvTLeDK2KptXA/j
	sr7VHrx6CemXS8FKeMY3hGFr46ckQjPPSNq9qycSBClfl4v4PLAAPTTL+/QDPiPfqzvApa
	Ekg07H9rwvDCfmHCQU9wY1yUKTOrpNw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rMfVFIrN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781287776;
	b=Vm/53u71WXz0qu39gLy7F14gSznvI4rAhv7XMXL/AEH0t9VjoowcRuAjc3SmrVNff5eD8f
	yGL7pWdzwaNyrZaOUQXcwyl9OB3Dh9zObSEPt5YBsd3+xdqslw+JYD1Q72Su8scZ3OzkAw
	1ESxT8fAeTlHbJTbVqedOklUmPV03Gs=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c86307c4e6bso546546a12.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781287776; x=1781892576; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tIviRJIKLG37v3E4DnE8ZIX3XY+lQBK31eI/eTdPTgg=;
        b=rMfVFIrNYiq65+l7Ap8QJP3O2qi1QW0feBfIPmAbymxTYaXGifF1YbzdVcvOZ2OM1b
         PZRIBfTPJb1I8ILlfwf8PGeFEgX5I8B3f+u4FmJF4eh1wzUEWx74j6vlzabPtAHliNxO
         vfHR2KMx33EVk5lyaRf9bZFLk8lkrI/dLOKdFQRiMNjXx4EA3lsIKcrLpg31Age/AChq
         S9Zd2bkzPEqO2QxPXMqBj6IgjZ6l/IwA1SR/dl2r+TcTMICyAoS6UOoFyc9uxBBBGk//
         qWJA/4XSjI9bNZcDnJB6mxVIXy1j5KTdX718m9yNtheoepfN7QnZV3PuHXVfVJsoYaEp
         rGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781287776; x=1781892576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIviRJIKLG37v3E4DnE8ZIX3XY+lQBK31eI/eTdPTgg=;
        b=AqZj7Xpi/avVDlqYQS3qF6zC7Cvu76UPwTIWkZm4t3WuON0mDTgTzk9nHfz9jYi+yX
         dL6bmG5svKEIhUxJnToX2x61w8Uxg8jHK/zqULJ/X8Yr3ake1dneUoyQMjk8ygFyeVXX
         IS3x4TQVSmagiJHRcxHtTOh1BMXXOa6vlPFyzbQPw/itb6QdOyy3efxsFP//hPjqQfX6
         n0jEUkqzFuldBG2ny21fv1yqtE1WH5u0GDQukJiBz+LZh/ANoguMRkXUmuGndQqLUXdk
         LqlMh1LQziS1YxpnrPr1/Ijq6QuO/CBkYxdAhDc6+fvQpfDwDhoP4PR105xFJC148wWd
         XIxw==
X-Gm-Message-State: AOJu0Ywvpob7AzQ8YRRb6IafJgKKRdBxQ6Zq+siUmcKc+jPKtZdVeIKY
	V5eEReel/tJ6NNM4fzDlSIbpJj994G4e8BKE2GszfnypN184c7Tno2Om+Lbklcx0
X-Gm-Gg: Acq92OGNCo1OcBB7X/YEOAUWakRJnl1osrxKDWO6CanN4ocTOyd9oEkDVoo1CPtU0+W
	GiDnrgFlP/WckrWM7T2eWdoWO3cVHVltnVGCiHF9ZZ6gSgab3FIo8bcWronLocALPTsNb7kIWUJ
	5veryw87Pou8Q1m4CjtzUKdV4MdetVKEtLMb1nQAuydiIIgn5k5HAIHldhwRjAtyQlYbZMa38Rz
	3Po1HYQGdJTbAiXntyCupM1C44n+GGb1icEYU2SqwSwAeuZmgWZZbNZ51KhX9k2HQ8IbZKWILZk
	IK57SauVPTu2DVRHFACzl1/sdSR23NKJLVQHAdKuWz7M116TjjGHbHgqXAZWEkySd/ooZZ3PUO2
	6ZPVbJ2mk2mNRHRuffDiB2wXlDFIBaPauXpJ/826TAgogS5jiRRvk5Y1Ajka9iwGeLdoTY25u8y
	jGlgvqvnmjGJar8h5ymSdt2y+FNxBlDs6U
X-Received: by 2002:a17:902:cecd:b0:2c2:27be:39a5 with SMTP id d9443c01a7336-2c412749c19mr43103815ad.33.1781287775593;
        Fri, 12 Jun 2026 11:09:35 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f7c70easm38956975ad.25.2026.06.12.11.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:09:34 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v3 0/3] mm, swap: Enable THP SWAP for PowerPC Book3S64
Date: Fri, 12 Jun 2026 23:39:14 +0530
Message-Id: <cover.1781287297.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CABEA12000B
X-Stat-Signature: cwewpofzxbqagqg35hbytm7xkokup84t
X-Rspam-User: 
X-HE-Tag: 1781287776-119111
X-HE-Meta: U2FsdGVkX19oAgsCK2HvrggNAqDx6jvm5vF+X6JxucRX4Yts9sR8GBz6AfXTsdVej+94ZPXrE7J12ZvjwCB+Z2YDPz/7mGPz7yBMTU075dubxIgiU8/Gat54atIC2qFTDIwDLIC/lFE/9jFXe4uJZrrrZKgPvO6ogToXYvgD1Kwmf/+8v6qQlaz/NsGyhRWJWmp3DV/48VACIh2VSzZRp1L8XL0trx3el9AYDk/GnrDjmeiV2/jRcXxqV0sYo7Q8ppinDE1fahzDFf+K0oPVjAFt44VBNx0PkFl/+UB3gmmr2GP2OFb3OrKHyo9IT+MLxPrljxQElFVVcr71OYms3YZMqRt24spYZt+NqK4+TAIAU5Nf4hRrrw1npISckQeWVto2EYFMDSA6P4pFGRkl4D5XlZbVLcTv7pYGpYmpCbRfXcLfoPtmy97h34gv6JA7nRObJaZ/qBzRKY5vIjlJ/nGp8MIyd5A2sHBSELK+3FaoKTKZ1ub6RUL9cLxOs+HRdTjrl3M3ldyKEJAcMGZW/Tb+vhUdsrJrNDzDkKQkZADs8m0fnF6i+C9AZL4D6Fpfxb2g+CswXEm5Qb07MuwbUkaxapqTVVEFw5y8D2IPryfn/Y1YCppFWrROROdE/l7hXt7XdtO/aBVGVI3PBD3Kd9qR8efPN+UE9ufoorpQ84rrBPtXGperY3Pv5T6BRRw4GbYX4VUhYCpJxJ0Iw4Dp2FP4Wi1af3peUVkcVqayWx60zvDIMheO8qg7ppl2Hsqw5rZgK2va0vG/0tD4v3nn6eXsE76h/RxJbx4lwUUrphCKpjL4C9EhEQzLONTpuw1c75iMHUWpB35qcTGZw/F1bc37In+rHvdZ7/Wkd7JFcoNDKp3ZgbV/6fOtfBneRolwT5mPwjWYY2cSmpw5BoL2IKoxjrPi4jf3reTTLoSxc+TIEuNvy9kzYEIORJprUKxNFkIkWM1DBC+anpmc23o
 2hv5j8OJ
 WQnOUTRfx0MvcVoRBU6I9lywcpIvg8xKqDouAjIW3da5xOZow25oRr7lfdWrtM9MtefETGzNMuSlUH4anMXIIyq+0t7bU4Dz/ymTgvQlUwaiTqBgXgV6YMEogEk3xIWm5ZUv7eRmTZpPBHk4OlBR/68MMuuIUUPXPpGRcCBrpJFFsrkzicxyOy66wVpzeJi9J612lrqgh1Sc5SKdRrWgIeHtiT6OertWlAIC4Wd5FiJ6rMBi+IHAq7JaNarMTxq/EwAGj2vyWoESSI/McKUFzhEbouN9xhbjjiYIHO4tSn07Q45ZwaKZr5szQpPCK8VQXxBkxBq8nwxXk/vsWrKMw5NbdQSGE6DavYGai49hqSFFNaYj8w8qo2znXeqUlVt3XXgbtgV9IrH2lweOPvS6WZ6ho+cbPxEHlxQduX9qd9PxwNcsV4szgLO49MVUeM/ZILrP8BT2t6bHGMRQ7eDoz8lRcvJIEfU9253M33Q6VVXct3UWQPa+HmD9SjZ2zD6R+26BtrRCzrwYKzlpiGtfb4VZaCZ4coZ7IHxBbSF3dvCjHr/rvkqrjOaMRQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PowerPC Book3S64, MMU is selected at runtime, so macros like PMD_SHIFT
are effectively runtime variables in the Book3S64 code. THP swap code uses
these macros for e.g. to size some of its array data structures based on
PMD_ORDER. This patch series makes that usage dependent on the runtime
variable and provides an upper-bound architecture override for cases (e.g.
SWAP_NR_ORDERS), where the runtime conversion is not considered beneficial.

This series increases bandwidth throughput with zram backend for swapout by
around 40-50% with Radix and 100-130% with Hash (Tested by Sayali)

Note that this patch series is based out of linux-next (next-20260608).

v2 -> v3:
=========
1. Fixed sparse warning for swap_table_use_page reported by lkp in patch-1

RFC -> v2:
==========
1. Send the unused leftovers change in swap.h separately [1]
2. Changed RFC Patch-3 design from runtime SWAP_NR_ORDERS to arch override
   (ARCH_MAX_PMD_ORDER) - suggested by Youngjun
3. Dropped RFC tag

[1]: https://lore.kernel.org/linux-mm/68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com/
[RFC]: https://lore.kernel.org/linux-mm/cover.1781000840.git.ritesh.list@gmail.com/
[v2]: https://lore.kernel.org/linuxppc-dev/cover.1781170904.git.ritesh.list@gmail.com/

Ritesh Harjani (IBM) (3):
  mm, swap: make SWAPFILE_CLUSTER runtime
  mm, swap: allow archs to override SWAP_NR_ORDERS via ARCH_MAX_PMD_ORDER
  powerpc: Kconfig: Enable THP_SWAP on Book3S64

 arch/powerpc/include/asm/book3s/64/pgtable.h |  7 +++++
 arch/powerpc/platforms/Kconfig.cputype       |  1 +
 include/linux/swap.h                         | 12 ++++++++-
 mm/swap.h                                    |  5 ++--
 mm/swap_table.h                              |  6 ++---
 mm/swapfile.c                                | 27 ++++++++++++++++----
 6 files changed, 46 insertions(+), 12 deletions(-)

--
2.39.5


