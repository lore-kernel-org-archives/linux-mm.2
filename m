Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B23CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76546B00B2; Tue, 26 May 2026 07:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4EAC6B00C1; Tue, 26 May 2026 07:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C647D6B00C3; Tue, 26 May 2026 07:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7AC96B00B2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:37:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 660BBC1904
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:39 +0000 (UTC)
X-FDA: 84809371038.23.4523E64
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68948180003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CVJYM4eH;
	spf=pass (imf16.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795457; a=rsa-sha256;
	cv=none;
	b=kPa3QBdNR0HuffIIS4TeTHU+dOlyriPlbGVY0hOfMoTWHz0EdUngJLqY0e+UuzCF+Yi2ej
	1UMUoVwdyKfwb4hWfmyqCF65mHGCfGZYndI3TyB2Gu7SbR0DzxcDV8dQpw33+TkswB8Bc2
	OfKkB9VZSsnY1Lt0Vq8LZW+WK9aPEpU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CVJYM4eH;
	spf=pass (imf16.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OB8PxKu5O1haLqyjpxm1OAl69TGxKZ6MYUXMP5i6NZk=;
	b=45KtOvx+67eL6t2uudboBLzRDY04FSSfguas0v2xHo8ApVV+jsSLp76dbLBG7JLwv/3jUr
	Q4yUlHtlp+xnR+0IICZqpnIFPOtK2KlSgW5MtymhJBrRoqhTQ+5Yqno3GWDp+Ntti4SMUW
	jjOjZFclMdxmfw8dVAqzSqG4Y0pC4l8=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a88de2b52eso13036683e87.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779795455; x=1780400255; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OB8PxKu5O1haLqyjpxm1OAl69TGxKZ6MYUXMP5i6NZk=;
        b=CVJYM4eHN1zgPXeQuCUxa9OVXXBRbg1sBwPpMZuBhgG+Zq6AY+Be7T73zUhMpElQap
         Y+l/2S3uO0McnHRoYQIzwlBBnxQ13mk/Vm2Uzei04qjzgf/C5YqnSpe4DoyHXkuZRxds
         PneX/3pvekOG0r78DsMSdWJff1TMvY04M22TscIUv8xMZWXD0pXcR3c3v+OOfbj4LF/u
         FVKrH1rVg87oxkCS6Ch+UUHrWBkXliV2MU9FyLzfcfUsZ4BHsUxiggsAV7AnRlYp2N6Q
         /LkTPYZjzYsY8DtQwBNAOvkBD0r8urRPUVt4i5AqM2Llm6X++ZM0Zg5TxH8EUJ+ClqMa
         FR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779795455; x=1780400255;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OB8PxKu5O1haLqyjpxm1OAl69TGxKZ6MYUXMP5i6NZk=;
        b=TLr86IA6LZgQMlhjV78b0fW9ky8qogilimPgRbyU63IL9u24titJBhuXeRr/R3JtTn
         GL/aMMgEwc53yrZkfaWRoSSHCSuXMspQv6atNRrCzhYFAcJpdMdZ6zlqItiTuDGySRTD
         D0SKqya3KdaGsGG9+mmAp43FkXwF3fgOZuSSyjbczafgIukYvTGIBXJ4XtTcB3ZEGeYh
         zeAlU0YobpsbHxoiuqTz2tiRWqPbIvFCQuFWzvb8fndyJYa9GGIY0rg5N2jlfjj71fJs
         th6mB6JwJigZMTSYmpoTdCV61T7lW8FfDp9vYjfsWYkvWuCR5jgRPyDFoBOnHyuiEg7d
         6Oog==
X-Forwarded-Encrypted: i=1; AFNElJ/PmBYfgxpGuP4LkgW+UzobDhpBiCJk+8xOBCc1h1jZD7pRqTDAeubDW5Bqycwh5MM0Z0PIH5Tz9w==@kvack.org
X-Gm-Message-State: AOJu0YzVa1QX3n6yWCfGJBqXpNGiOMJsP4OnfAZfoc0kB5zQ3Ua2XfRb
	4xj8woFi+CxIxhgeDWWUCDeU6mqRVvNZSbu+nem/o0kHvjG+5QPo+uNR
X-Gm-Gg: Acq92OFqZsR1suPoq0MPwXguiMxEnw5Ydy03zaJLRJewWU+tIY/MwxKFYSm30tU+QZ8
	P/DWDO+aGG+yPgfyk+EbSvUGwEngaLYF8VEwba8LHxE29AVsryE4tqlHC5Ar3lLc0amX5klAjIf
	AjOhbQbVQqZUGu9Gn4NrlFLFHn8k3qYxOQfnNCJ7ndalf2XoI4rEbJ8LDrG7O88YjVLdF2ix8+7
	6a9irshWPZ/eSUAkJesX85YjJXwtnaldZ5wNOQDg8yJG0tmXYkzCAbkewnsqPLXi8uH/XccyglZ
	dtjY4jdAkPbPjveLRrWYMc4Kr75bOOOtqBkgWAPeGPf9kgmFdGW0VaUG7CXiNvlhj5kr60YdHhu
	c5TPLbUvTr/5j0ljji3MsdbVOkosLmKv/seWq5836YExsw8X+ehxC6SCVQS1Z82XhGTsBGSoIMo
	kx2JAxbmtoHCcIJ+ofnAtSYFpscmsimTR+yZ46RZ58coXOdq4RdsgsfMDfrQw4ctaP1tGs
X-Received: by 2002:ac2:4312:0:b0:5a8:a754:4b57 with SMTP id 2adb3069b0e04-5aa323b28e6mr4727265e87.41.1779795455040;
        Tue, 26 May 2026 04:37:35 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa46330d9asm376332e87.59.2026.05.26.04.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 04:37:34 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Subject: [PATCH RFC 0/3] Demote to lower tier using non-temporal stores
Date: Tue, 26 May 2026 13:37:01 +0200
Message-Id: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN2FFWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDUyMz3aK0ZN28Et2U1Nz8klRdg7TEtMSUtJQUAwMzJaCegqLUtMwKsHn
 RSkFuzkqxEMHi0qSs1OQSkElKtbUAPu0T73YAAAA=
X-Change-ID: 20260526-rfc-nt-demote-0fafadfdd006
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
 Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
 Raghavendra K T <rkodsara@amd.com>, 
 "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
 Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 68948180003
X-Rspamd-Server: rspam03
X-Stat-Signature: f47b5hwufhthznzfrsqbyhdgwjrgmj1e
X-HE-Tag: 1779795457-343801
X-HE-Meta: U2FsdGVkX1+QUB7V5RmF+5HwfEI2AdPlNhyA+iKAlCge4hV2uZIqnk5MKMgTZGiTRcafs155wYe3KffrjSD/oGXf9h9T02IcY98aJPd2EZxKyR0hXRW2k3ZEAQH9g3gPrfyie3OWWpjyTyPcxYUl5oPkwJICadjAyyjypgMUL0IhdBJi5L23+IZTVlYpCdwr5RvD0w+7hqnPbxhqcRa5OaAHzUz3xsoRT/abgEfuIkZbNFmzaFCXHuiLyI0xtxKcGLXE44xgzKTuNvcWd12NOH7sj6UP4qTbbiHULuaz6UaNu8I3WDmaKpbiz9bDlSytBi/9f00q/ISiL/RKHvpLzXVYLOSemtdcnbiM67v7MHwLTFGyAsNyaLTLBi2MzQMBIo61mbVBf93jmRVQyELZ28er36KM+Kern0jyIvuQ6QOTo3Mz7Wl5XLjv4mMv5qQvSW4bZStdPkzZxCR9e3Td3b7f01hCShWucesynQxW83e1NQGea3flBdEQJWnChlCoAKwEvbc08+fd0Jgo4wzqiyePw8sI4nUkXpE3QHIa/lTnmXPo02UFLtAlYaAGmle7WBUwkYozZH8gxkYbAvvHqmiDIW9t+6REfDJgb5aOZyExy5tTWmPo4RODCze/+gt0yJHk91T0Xnl6jCjWT/s40aegAjOHGabtsTFs4Kqyks3TYch//+JaqWQchjD0NpNb4p2i8ilD/mf7crlzP17mHnFtBjoGjiJcSI8+OHGOml7Q/UmgU4dKnUKsIa1G073J3fwjUPMWesWPuZkE6sYDIY7IKCE2Yy1CgFSVrMlyxQ1wk3lJPt+rMDzsaMKvAGPaCRLzou8Xkrh9vwEIOs5G2jyAKj/m3vAJhSrYpN+aWb2aZhtYqhXOk3JvXACGJGDi/6JbikMuAI+o8x4o0GMKw14fuCPqlxMsl5qeDIONxKX4BihbhD0S7027XYHy4LRTNaxEeNmBGaK57LuLKpr
 YKNb1APU
 0mT8SsjuHgakpnZIjabjmLDun0tb00facbtDwMBp4+G7oYxxmqhXInvAb2ItYLeg3C0W6Kj678UEaIv8V4dTz7uQnShTSkvzxCK9hWIq5MeKBwByfan7UjrTGrZVnMsZgp8BeuEjlXallessVM0mLDWPeqZB3cDao/u5CS24sPK5RRMkjZIr9YgQLuqYTYqTt9nkWLwknPPp4u/x4dX+P6Ybfbtchh8slb69DwJT1oW4EZ24G4d2H+esxxVQ2TGQ0As0bp/agCUq0xVIb6vV56jb188MGXx3fGGRuVkOgXjUZkfk2UueXiDEQHhBtGfvrGogMiL+B7N1Q5kz7cg7E0/cVK6nM0PW8ZVoQx2IZ7EEnR1NLvY7j9/VTWLbHIOjdjSA3iXXo1n1TiQY0QZU8aUhpPdmKIIeRoSr5CCO6AbdE3/ETrmUpx2BHmuYsdY4W/c4yDrc2NLIz7RV4dVIMrUKuvLg7JVovmQKDp4IfA1fMyqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In most memory tiering scenarios, the memory to be demoted is expected
to be cold and most likely out of the node's last-level cache (as well
as target pages in the target node). Using non-temporal stores instead
of a standard memcpy path can reduce the cache pollution in the local
node and the bandwidth overhead to the target node. Furthermore, for
certain types of CXL devices that support in-line memory compression,
the last-level cache eviction patterns can negatively affect the
bandwidth of the device. Non-temporal stores can mitigate this.

This patch-set introduces a new migrate_mode flag for using non-temporal
stores that is used only in the demotion path. Patch 1 adds some helpers in
x86 and mm to bring non-temporal stores support to a respective folio_copy
function. Patch 2 adds the new flag and necessary changes for compatibility
with the existing behavior. Patch 3 uses the new flag for demotions and
guards this by a Kconfig option.

Experimental data: in a CXL system with 1 memory expander, a microbenchmark
that allocates N=64 GB memory in the local node and then triggers demotion
using memory.reclaim, shows a practically complete elimination of read
traffic on the device, i.e. write traffic is N GB with and without the
patch, while read traffic drops from N to almost 0 with the patch.

Opens:
1. There is some "duplication" in the x86 tree and a bit in mm. Can we do
   something better there? As it is now in copy_mc_to_kernel_nt we
duplicate the machine check functionality, which if available will override
the non-temporal. We were not sure how to prioritize these two and what's
the best approach here. Can we completely skip the machine checked for this
path?
2. We've hidden the use of the new flag behind a Kconfig option. Is this
   the right way to add this?  
3. We have not carefully considered how this should be structured so that
   it is easily adopted in other architecture trees (e.g. aarch64). Arm
support is currently out of our scope but any input is appreciated.

Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
---
Alirad Malek (3):
      mm, x86: support copying a folio using non-temporal stores
      mm: new migrate_mode flag for async using non-temporal stores
      mm: use non-temporal stores for demotion

 arch/x86/include/asm/uaccess.h |  4 ++++
 arch/x86/lib/copy_mc.c         | 26 ++++++++++++++++++++++++++
 fs/nfs/write.c                 |  2 +-
 include/linux/highmem.h        | 32 ++++++++++++++++++++++++++++++++
 include/linux/migrate_mode.h   |  9 +++++++++
 include/linux/mm.h             |  1 +
 include/trace/events/migrate.h |  1 +
 mm/Kconfig                     |  8 ++++++++
 mm/compaction.c                | 18 +++++++++---------
 mm/migrate.c                   | 21 ++++++++++++++-------
 mm/util.c                      | 17 +++++++++++++++++
 11 files changed, 122 insertions(+), 17 deletions(-)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260526-rfc-nt-demote-0fafadfdd006

Best regards,
--  
Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>


