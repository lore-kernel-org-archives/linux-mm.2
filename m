Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A79FDCD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 04:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37BF26B0088; Fri, 19 Jun 2026 00:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C3D6B008A; Fri, 19 Jun 2026 00:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21BFD6B008C; Fri, 19 Jun 2026 00:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEC816B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:41:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A2D61660EF
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:22 +0000 (UTC)
X-FDA: 84895413204.11.6D00621
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C70180004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hRczqavc;
	spf=pass (imf30.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781844080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LHipDb4hQnOkueiysmnxTLayb0+ss/N1hnMyC7dj3wA=;
	b=AZdT7f6EVmtHzxswQjLXghZLS0Frb/C+SK2AOlfVSMDeDWPIW6lBrk17X8eiWNSQVtzT6d
	zrdDS20PsmyjbL17NpwOhSHx7EQ241ntD9jAQI7bTBjwkf8ja58y9K/MUhHSrYJCKpYOso
	SbYuyfxisAlM0DD/ZHpWvQ+gVfqQWkE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hRczqavc;
	spf=pass (imf30.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781844080;
	b=X+kR8+lGG5ojmDSxquzBUS2DpkgMMdiOo10BnrrOu7MFgHs1atOO/vAuMfLOerGG41J1NL
	bm2CACFCimzfEkNOYt/b/vL29YI8FStWXEJfiBxFdqcoKeBkv3NvixCXlJ0dIqyDZmpIea
	0IlM51RusJB3vTJB6shCY9IRtQYJEZ0=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c6be9cd89bso7857965ad.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781844079; x=1782448879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LHipDb4hQnOkueiysmnxTLayb0+ss/N1hnMyC7dj3wA=;
        b=hRczqavcTo8/AIcjFoMimiAmi4+VMiVVpJ/5UlP+52rciKaeohkSY0pb2f9wUqRE0f
         aIy2QC+1njLqCBxEJ0nbvoEkfN+xP0gHIgLTQUGPufs8Cgw/PrmJRsSSAZyIdAIoMVQ/
         068GB/JfuoTjeF1JSez+zQUxMsYD48VvFov834qLzM3X7VghBOF8WgKWvFk/F1oZCXjq
         Ijjr2kKpkENThC+a+oMbHN7yjYbIPs9SOjg4WlbDdCrPYKXT/RolF9yt6EFL5J8V4iUf
         6rXx1Po9ML3cRChFDZTsYyI8a6/TFnWhLxqwj7dR1Z4kNp8RKbSEkr69EVRvIHwC30hX
         hxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781844079; x=1782448879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHipDb4hQnOkueiysmnxTLayb0+ss/N1hnMyC7dj3wA=;
        b=IbONw7E8Pj5Fn6LLRenk4ySeNzyiGVTYOoL71Sn7cdKjkNub4eQcOXNxmpZUkp495Q
         MgUSfETC2+nIWw8Nbga8uDbRu35btB/Ea5XfVQHxfksesurRFTmhIualVkOYw6eihtBu
         Zf2/tVmrdjuItwBXabzJNOAQUOPq+8jDImiYGkwrPVlCqAiTLWlxeuakoWhKKN9A68av
         vMrppGsfwrewAp/xrF0ItaMNxo5BF0J/jW07t6OA/kYUhxTAz6KYxflJdIF9QTSaF0ff
         W/mdY4Cz9oNj9EbKF0nYndyXhTlVe2Iy7IwTIurhvtmHWxC5XBvryIee+ST/TrSGlDDD
         FmGw==
X-Gm-Message-State: AOJu0YzjVpohh4MJRM15J8LdkOMUnUFvNYH4wdHncwPd8DP2aNk/rtg+
	1B8mRzSHOl8Mai6Yes2TRzVyy6ZjCa4pYT4LuvcjzmekzRllosSYihnEiXNrkQ==
X-Gm-Gg: AfdE7cn8urB7XJMyl4JZP2Pzzo/sTTJYhE4igkjjYGCOnv60Xh4TRy34WmFGhGxdwNB
	IB+vQLqnpjjjZKF5n02GW1Q36ygLGtRwemUJ6Fvrl8tVA9bAMtFs5mWNNBn3fTLFmmFWvBW+UPQ
	S3z2eF3gApq/Wqz2T3ehh/v+lEEDVQ6SN6N1t/WNw6AgyZgIIuh/g8YCzY/wSpBAHZ55B6R26Xq
	H3fd+cI/QXFAcv8AR7HVXPtHRxWsoo62+BeLS6fvouPmg9DTypdzRrpAA8TE5nU5M9AIbYY6RLQ
	CXmGXeiCQqXbz+WDU36LhIeiRa8EpHhNSjh//TeZnAuc7z5csvdzqAPrAAIw/LI/wYIvw0sP1kk
	lTxlZm0KEI0WyrBXHDsBegvV+pKC0HZRjY1dQF8zuW6Bo8iWMaqZEkNHMUjOiy+itstvgrB3f0U
	gKcXm8XJywJm0RvraHDJg0Vw==
X-Received: by 2002:a17:902:e54b:b0:2c1:a19:8396 with SMTP id d9443c01a7336-2c718f61d05mr23229975ad.31.1781844079424;
        Thu, 18 Jun 2026 21:41:19 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7208e5760sm8293735ad.36.2026.06.18.21.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 21:41:18 -0700 (PDT)
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
Subject: [PATCH v4 0/3] mm, swap: Enable THP SWAP for PowerPC Book3S64
Date: Fri, 19 Jun 2026 10:10:56 +0530
Message-Id: <cover.1781843449.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C70180004
X-Rspam-User: 
X-Stat-Signature: n6pc5gpm3g6bxmco6q6symgk9ckm85eg
X-HE-Tag: 1781844080-864766
X-HE-Meta: U2FsdGVkX18bJuw1dCxmS5hAV50EGHqAXHYbjr/BkNLzz5MsrO0R8VRoj4fDXxcOBJyKfSRwRRI23vnw1aKoBNGh+kDqsE1dytdkkA3YOmyNGkDfZTs9WkyN8ysAYN6zR+jOPD2EyAOG0O5C2RmrXfc2XGwApdSZi2pnhzS4EVulBAXOcuBNE3/L6pKG8Wn/saYV/3BQkniIEvgbqmdv0NsoJwwbh3Mljg91wQ+VvpkOnAeK7d2VJAw7xzWthuzSmYk39Tm7oD5OIbWf4Nf5xxT83vrLJkAdsBdJa/jzDK/xM660vViD7A54Xn/gr/npNCSPbOMp9HjVgRMD/AsNyfcQ7jtW4rK0Ex5DM26pDOX0Z4lRioSfvw6CSOyi7XEMOnj6v9FJCtFpsKpaP/5lfQTJFUdccP5sDaDYLdEqTwz2nwRXUxqCSFrx0W3KLqXujbu8ja8s8E/DVOjbeCeAxAhnxw4Et90awBSu2NuVA5LpX51bDTFhdBt7GW7a50Rx+NDl4Ycmu9ykcPxOMf9o5JbmIVtMhjgExHHNcdcmo8kQJziPEXxeRIOGYesyeKtmYYHvMy5q98/CmbNFCBrRoluZHYbP4jpbDdAyTX3+mKKF/0zjCfWMRQnb3h9A38zroRrB5gTlHIQ4okr/N6XH26B64DibMUUX0xWzlC6RAL2jNwzjteL0whwbtS3xZm/ln//Elyt5fcPBxVLJH+xLKfGvhHC0DLc6m+rsHfBwgdJ2xW1NHR6s8ZRnAteAsL/sd01l8XrvwRuKx895UT6r7CH6lmZZtAH81YkFifBqUtEohnylJN63c6mOcYmNBxvmSQJ6VSOhiH2KXqtEXU2y5A2uW2N8Vzls/UERosq919KqlFkY8ZnZCB9zAdXIEaiUGSvlpin/T0XdOHT25CoLGrE2ZBaRGO4fFnTK5xfXzPsDwoNDRTI9Q3QGo4vR8BZYQb4x6VzS4GOaxruZ9jp
 NLyvHs6L
 6OBiWYYvUsP4Vzb+j01TkbgJjQZqTFjo8jEoJWWLJWcJFGr9UFOLhs4LTUp/6Uo5IbpzKLo308lvIBPLYmzXq6Hr7/Y7oV2JbrypbWeokGQ8/WhcfLmXxQkozP52EkPiP3se5t+ZooszBV/WHTcgJvrNzHZIIcU3ugsCOdYok6H04CPp+NJ2l0+1mJn1Y09ncqVRmu/o4WIcnGeIiWjoG3KXavFq1LVxlElCiAY/jDFH3Ltw4Nu+n6pmeE80f8msN5lFgpgVJGfwJ8NI3G6i530yXL2VPIdEdviGrxsPHQCubSgslLZivbPTqLKOE8nh/6o17uqFVyJm48Y+aI3BwpaNZLYt7d3GDaBA1bfkBunakPBJsuZblJl14c+5YGkokG7VSYM2+k+l9o5GwkNBijlfUoPiKjwAsyBWxrZ/uz/pD6hzqJFs59X/YvLHKfZG42jCQ3XhXJPL91JLCExXUsPVL/LHfF16pr6JQ
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

v3->v4:
======
1. Revert SWAPFILE_CLUSTER definition - since we already adjusted all the users
   of SWAPFILE_CLUSTER and made those users use this value at runtime (Kairui Song)

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

 arch/powerpc/include/asm/book3s/64/pgtable.h |  7 +++++++
 arch/powerpc/platforms/Kconfig.cputype       |  1 +
 include/linux/swap.h                         | 12 +++++++++++-
 mm/swap_table.h                              |  6 ++----
 mm/swapfile.c                                | 17 ++++++++++++-----
 5 files changed, 33 insertions(+), 10 deletions(-)

--
2.39.5


