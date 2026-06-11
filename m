Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C607CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8634A6B0005; Thu, 11 Jun 2026 05:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8128A6B0088; Thu, 11 Jun 2026 05:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727FB6B008C; Thu, 11 Jun 2026 05:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60F4E6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:48:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CBEC12057F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:07 +0000 (UTC)
X-FDA: 84867155814.10.91E37F1
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71CD41C0007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkFaaJBQ;
	spf=pass (imf18.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781171285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qg2kMEb5Xe0fF/D4cKsU6T2DOScJQxYsttzCFMpVKwQ=;
	b=vV+Wstmvy4lTGFvkuM/lUVbvMWs78Ufm4P+sKxrPJPsdmG8R+VT5dtMYmhXe+O5orSSl/a
	NgJdcjLpv5XdoFASXHi1Hu5MWOi34HkSt0blMBtzPz6/N/QBiw58npsYwhuOqlzz+I1bCK
	CQ+Qk0BrkSUGvhUcE8+MBwvi0KomXqs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkFaaJBQ;
	spf=pass (imf18.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781171285;
	b=0OeLuOnwf7L313bJF/KWJ9o5KSZ7R3pqhGAU8vz2lwxUPC7bFTrMrHi65KsA8zYU95ECaF
	Y5oJpQoeFkoKNX228qv+vJuoYe66QvADXaHbt45XrpnsLkR0gslh6oA2sgiTO9gbxKzqmn
	EL/6uM64oNTj6ioSRc7IVZSkg2ZWj5g=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf1f074a12so79141835ad.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781171284; x=1781776084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qg2kMEb5Xe0fF/D4cKsU6T2DOScJQxYsttzCFMpVKwQ=;
        b=XkFaaJBQdoh7d6iUUDwwuuXj65jmrSWUEJAGMRKRd9xbInfKyOty861fJQrkqOfEr4
         M0wCpBqHP61HzUhaGM6qkydgAEVoy2q7upMqVDY0vwtjg37KtSYYHfO5DHgIYlvJNBXf
         3DKp9Nm8+Cxb4qxEdAAv4b4vZlf3NlCKxKCVCKnnx67dDUisBDm2vk5K4QlCzlxVUlTA
         /PKCYFCVCQx5HYoZnmyT2b+LYoo3FUojXQufCFeEdA/vP1uo5MbHZ3RS+zFFdTrYztVB
         uPDujSqt16PfYWNUzHvO8RPCKvTSz/BBpVWhnUOf8984JK1uc6ciXHUTjxwBqNBqOo+1
         XBWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171284; x=1781776084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qg2kMEb5Xe0fF/D4cKsU6T2DOScJQxYsttzCFMpVKwQ=;
        b=rRT8oixrKDUZS++yN6+Q0Vk3U460hfvci0qDhyqWoCxTMJ/afegXJPFr96p6x+C8ZH
         8IfEPMKfnc1xaU9XU3wVoLJ+77IO6HielddBCBw7tlPGbGlpYdRAWhQpacnB8kzs3wUy
         8amGjHaHMFOJc4GvJg4hDWSGQU9XGKyCkkslf/wTR/Q9xHOuOuupF0N60rBGqqoOiOaM
         HV3SaX1nt2fescXgEhyA/4il9e4RT0V5exIbVLb4u43wYDy4X8ehOXuY5mKX5glMRSGe
         McxYsG0U6wRd5H7YkisEO1X+z1gRbyoWmNVSqWr3xK3VkEWBWFbvZZHZP4T26OfsTp7b
         YZcg==
X-Gm-Message-State: AOJu0YzqJUY+u9b2JrDKxNxgFaYTHGcL4Md3GoMNNV4Bc4ta1NRnO+Gh
	IEEBYy6cVRqGPLyCfcnIR4+sH/3XDfj83D4884wnHundNTcpuWZtc090+H+pz+k1
X-Gm-Gg: Acq92OHq3pWTGDI8F2MX+QzcwW9s2Zn+WuQ9WUNDL1u1M2pVoRooQLhfgsC4jqM63zk
	2UGwAiUUiE9HW10X22hsbskG4MQf5TVUaZ6VlgEkOJILagU3cjMnoF+/VfQs/VpEoJi4hl84bY2
	dBqFgE+9LWHg1GXj3CyzKTQ9LkaaoG3yLHcHHBp7WfaZoHo67zTju3hacxXJUS+SJKqpPDENb/K
	KVtQzsPhISUtg/9qlvVsfD5PY8ymvyOzNHDQpLDxar6jvfKfx0Rwl0LmazhD8U1RMR/EXtyAgMw
	sxauYjIzA9xFRSVqH4SI60OK342HLzXM5MPUCbl0jjdOW0dCVFvEBfLkLkQg6Z8sKgwCzcwsqzQ
	D6WdppQvUPnISquHskpmY+SXhdyoS8fA1wuUp7G3q4ReJDNFU0pqugcn/PVpzsNiKKxZCz4kTb7
	qdQoe8SakEF41leSjWN2az9CnKrWOyCjg5NspQ6ju6Xuo=
X-Received: by 2002:a17:902:cccd:b0:2c0:c262:b917 with SMTP id d9443c01a7336-2c2f0059f43mr23628295ad.5.1781171284217;
        Thu, 11 Jun 2026 02:48:04 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629d042sm283324905ad.60.2026.06.11.02.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:48:03 -0700 (PDT)
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
Subject: [PATCH v2 0/3] mm, swap: Enable THP SWAP for PowerPC Book3S64
Date: Thu, 11 Jun 2026 15:17:50 +0530
Message-Id: <cover.1781170904.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71CD41C0007
X-Stat-Signature: of3qo3tdpafoo8ywgqig7ir9q1ofc59z
X-Rspam-User: 
X-HE-Tag: 1781171285-858000
X-HE-Meta: U2FsdGVkX19AG5BDxC2we1PjbU4P6+xHbErMnAV/qExQzAQhNHJgrC7j2wBaB1n4JCE1c5MF0Q9W7UBX7oQpdpqoaDMgPPcVooWgc3i09zqVUNBknTR26kmI/FkHVR7o0sNxXnyzzhOPUCBLaegDvN84+N4zWzPqfmxm+3c3Zf/QGrwPY5pqd72Oj5srbSBG1mFFbCcd8Tgh+ePuuv2mZ7Iph+7dX36n0PVshdZWG4SY5bXQe6IMLqmVvkV1/IthE46TKjpgc4Sbod+GEHY2zyptzJEQoews7v1xMM5Rh3fDikkg36d/KdJlgV+b04mgC8p4J0rzH8GTHn8ANFaIfBLz+fkflYKJbOKbSZ3Uz/1DB5wy14Tbga6V3TYvaei9YpQ81Tay5TcyjQvlCqLkGyFW3fc/E/hPDkNrBaFxTDP/kIDTRWwwj1HWs0q67ntRkkNDe2WqLEDhSd9aGCtwMKp+Mh96u804Fs3508VRhll3LlLZCpO3sk2Fro1bUNwOF1q01wEh4bE4gt9TAg/hXKOvAgsqdZ4zUS/V3c0x9BCyVfJZw/J1avQAqMhs2ZpYveQbLpGqfwCFqhjMRQSdK6wFShEjE4jKmgyBRWGPuCqonenxsgptEzqFROVr0su31Yp3O4+WSjsNV66w02o4o0xfzA8chPFTAK0vnZyELzfA/AKsgzOl+N7k6r7Ec0RGb6W0iYS8JwmtApPn5qTimvmV0WE4cEyB5iivkx54kyL1clGWV8QZVCFGKSHs+WZ0/pMeJVgczRNeGBv1G3cNHBUm5RphI55kNnH1EOKVtClsrMoD0pG7o2u8rOcJ/6GbBKX87Iaz3BEyEqg2LLhHQmgtntJTNOU9oENRRG+ojZpsL7u8Vsspv+SeZtYAAnRL7SW22FQDCDwSzBP7C87kLvZNRXiwiLRhn7wQoAmah1HmADvngUWRG7aTb/5pDt1f5t15xErvwut4n9JEp41
 +5f8CV7E
 jbDcZiqzo9urFgsxQqsRbFKDNwxNR8eiJ4JNuMkzikGmWIyXlZ2Lysaw3Hk0m5hVx2bRXHQO3sX1D7fYjqJ9ETq/WN81B5UV2JDMqoqxxdzkzyaFPvppet4oYdwTiJY3wKh8+5y1s+nnB9N+TPXIF1Z7MEhtqAIqsvMVUUz0bExeiZCIV9GGImaJlTSAwlhfx7sP5e2OYaGP+CPmT+z4lBPU3lmuHTwKZhzOS4H/2nrgVeLLiP2lG5RgOVe3rZ8hdrmf2iWF3Hg1ZYAGyK81+k+X8bz2lMdBgc6Pa6LvB2TV8Q8zev1K0aYJr0COstWL6IZi/JlP9TaY8xxcCyeKUdfZahlnVqerQILqH3lEBZ74FiwErRmkiRXmMXAdhO8OhgVma85eC0Ci9qrhdWYosHWs0GNYSvwlfQAJLnVPMSxknrXMpJjpwyiB2yA8sVuRL4LxtCnxmjChQ1g1gRC/PS7d5ZYBbGqHrIuAk
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

RFC -> v2:
==========
1. Send the unused leftovers change in swap.h separately [1]
2. Changed RFC Patch-3 design from runtime SWAP_NR_ORDERS to arch override
   (ARCH_MAX_PMD_ORDER) - suggested by Youngjun
3. Dropped RFC tag

[1]: https://lore.kernel.org/linux-mm/68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com/
[RFC]: https://lore.kernel.org/linux-mm/cover.1781000840.git.ritesh.list@gmail.com/

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


