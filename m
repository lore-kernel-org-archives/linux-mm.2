Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB80606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 05:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=l/YxTHDS
Received: by kanga.kvack.org (Postfix)
	id 1A9346B05B0; Sun, 25 Oct 2026 01:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1596D6B05B1; Sun, 25 Oct 2026 01:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048016B05B2; Sun, 25 Oct 2026 01:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C378D6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 01:45:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16C08C051F
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 05:45:15 +0000 (UTC)
X-FDA: 85360060590.17.8367545
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id ECCA320003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 05:45:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l/YxTHDS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792907113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6ZPKCuuJrE0W92gMDuc9JfWeZdsdjWw7nqJZx60/ZFk=;
	b=HoRPrnAvkE7urpGa0XOjUDQTTKl9Ha25GTjGGR//uG8cXMwcG9XviCD9Uy8PGNX8Hal0SR
	/REjcPeuKKu0Ran1Cfhm+fglY3YcEtvgM8ai2FlOB7wsQfnJJDYEnB7WpmhKmULS7Ck7dJ
	1PxgE4Juo7m/h57DHJuj3D0zQ+Efids=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l/YxTHDS";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792907113;
	b=sHGtrHGXUsHCG8lwS4bQSBXlFv1j++qXLJDTVAO2BY+iakwjiSOWuhv4EhrMV1ODI1xhxF
	M7r+xovJimInArATyXgBrRUb8/3gqw2XilHdCOWyhGgyx2mfgjhn/LOq9LFSnaJSXWaymC
	EL8/p6R8jpX7Oia/bk4GrUWb4LmHpcA=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso1029131a91.2
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792907112; x=1793511912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ZPKCuuJrE0W92gMDuc9JfWeZdsdjWw7nqJZx60/ZFk=;
        b=l/YxTHDSOrSGSotPEkzdY4t954LluE2fSFEWTtFIs4qjvqVkL18IctdSrpD2LaOMHs
         pzHhNuH7cbRvAo4Oe47Hff9fH9/BMk9YQTVEKzB1DuU/kOCJkZ9/dTYlIiRpaHq6Usk3
         0pzFSq9/1U+Xcco/7GyvI+FqhBBxXtm3zW4CdiuUERO/n0q7VZ+h6oSWutKLEkG4MYTL
         Hg7KiNGCtT3tp1j/aBc2RlFx08yDlWcqRHNZIXtMgTNIVLcp1/MIfAIswqJNLQugLiZK
         EIjjek2WZs4ZnVW2iNOVWSV4WQI0dxXRY7jgdQCQcq//npledMaw+Z6bkq2ylo1clMKI
         BIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792907112; x=1793511912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ZPKCuuJrE0W92gMDuc9JfWeZdsdjWw7nqJZx60/ZFk=;
        b=SKrgCK30/bHiaNqLfiQ2LwqjNI+rkcF2CfFulvxS1RCB4d5cISVZrtm8dy83Q/JowK
         nN5zBK/0hE7wEOc1z8uSKQJNJRSW3hO8ogGwErLzyvn8FV96SDYXBt1CG1BFaCAMbDw9
         5DZ+JmpbUIgrkI+PwUnkNGPBR9VFQ24Rjz40fNIKV2ayhChU2JrDqiHms1802R6LZxVV
         iN7v6Pogm4pKnZzVaYgN/SOzCT+3GVlZHZ0t5Fa+as6VAu80ciHySZm6OBjJUfDAlQcN
         IkHr022bF+xaME+kwNTZpr3SHBeWY1vKE6NHBvrgbIQ64HuN0wjjBcyBnSIQsx1a6Cep
         cy7A==
X-Forwarded-Encrypted: i=1; AKwUvByHj4a2JbEOsRUmcf/QSWnUoEq3GRVPMRudLRE3luKMkB8OseDyyjGvZk08PZ/KQPUXStUnNa4jag==@kvack.org
X-Gm-Message-State: AFq9FYLR52KYUJgORTe57j8qtSQEYDxqk+1wl2hm6z6i64morWRwl0mW
	kK2HMCFUkNmDRCwmnOytVmcuSDxsz9SgwIk9xadT07L8eUNVBPYQL4o=
X-Gm-Gg: AYBFou3hwTuQV0+8cBC405zHsr3doTBqdk7vBq/jl5Uo0ScILZLbJ893TSxkbxVMUCC
	jOC4eAcJd8kVXkIdPFuAZ8c82Mqo+7jG+hHuKv/ltbvceYSjdzYQ12GYW29lqtToDHMZIe+v4MJ
	fiWJzvhL5ZpdAl8+H1hJe46Ha3QP+ZkMr5G1yKYOnB4iBFo+az99gyEx4abuEZdQyFT869CJ6kA
	3HsVu1d0V0Olfcg6hIvzTU51tnqwiEnZ3tOEmpEkBoMxGMHAv2YjKMXRj38oaSa1sCTdxizYUow
	v92tk3iW9Y2Nr3u30BhFUCDvxgoKYEHmuFTqkZBWXlyY8nJJAknOAvBZyD7F/bbBYFeeUP2X1of
	7I/d2qcJRN+PRS5LjMxNO/9C0D3znXCXh5OUiQ5wycUi+40mYYvusg9OqiQ5F7tQqjSS5tRfU6w
	d/+nWXI7Sx3u57hf7qLQdZx/enNbRinWWLAD/pvHlPD8uspNwf0W2mtC3bZMNHxS/m1ozi4+Wjj
	y1liBpDegeBLWhvAsIH3ngsM0kA0oNFnq+FDYG6fpwfo3W1kjeBYmr3f/XFVCVUAWp4Os6Aji8m
	+6VEIPNma1yCnu7w8bg=
X-Received: by 2002:a17:90b:4b05:b0:3ac:86a0:5764 with SMTP id 98e67ed59e1d1-3adeb197eafmr2937361a91.64.1792907112145;
        Sat, 24 Oct 2026 22:45:12 -0700 (PDT)
Received: from MalHyuk.localdomain ([211.201.32.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb75254sm2620167a91.4.2026.10.24.22.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 22:45:11 -0700 (PDT)
From: "JongHyuk Kim(MalHyuk)" <malhyuk97@gmail.com>
To: stable@vger.kernel.org
Cc: JongHyuk Kim <malhyuk97@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org
Subject: Please backport aedf2efd1897 ("mm/pagewalk: fix stale walk->action escaping walk_pmd_range()") to 6.12.y
Date: Sun, 25 Oct 2026 14:45:05 +0900
Message-ID: <20261025054505.1448278-1-malhyuk97@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ECCA320003
X-Stat-Signature: d5rw8d7zfcmd1n8aitbozw6q8491jgdu
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792907113-809184
X-HE-Meta: U2FsdGVkX1/dN070oJ2pPb+8dsTVPBhDPpT+m3WZrslaO08+ngseeFKt+kwFEOHIcWSxSW7/0hv4VMXakfxTdNX8XUCYIoxHCU2O/tpE9EpoDk/7e7sJLpOefethLG+s7UccEhU3Q+0T1N89JO5GQFoe8bHYBdkLn8be7PfvLpMtTuyMq2retKky9N6H4uhD44hk8ZwyWyiU5J+U4fdsNDSAAeznCUNuNUNPknTUnSrOvDp13RZ6b+OMzju35dCgV7sSs235uiUcPXg3+5iUIB2wUYDo3waz0+JSVWrFDlLPh7t2HrKEctCidBQOKYhimk9xd5+u5wbsAOAbYXwXkaBlk9zy2lsqz434gnurn6pxxA0XSDspeEsnM0J0L+BHgP+7oNkBhta5Fxfuc+Meo4OMrid2W9RAObW1nS2LKwNXhY9MrK3qesHlxxdWH4i4CYz1HcsGpuUpNB7h7hiUQ30gg0t5J5E+44220OiOGZ/6hICokIgfHLqbx2KMa1BZVQ6+Gnp/LpiiXOLkz7giBQGkB0oW9KB2I3DmfWueTWqVwGfd7fAsK6aN8hm3tAWKOUBErp08Wwi6Co7ildo8lJspjOu6bPGBk3SIJcB0fhnK0roX1qUYfTIXZLaG0KcMLb5ikNGKDLJI9XFTH0rcjGb23Dn9V1HGaw1f4Dyl+Byg0XRpA9Q8Xch9mhhypgFHKSa0CZVm2TNa7sSfGqieLOu/T6jcCiH38TLcoCbbbhSh5CO43D0YGI629HsV5PWWKbvZX1AAIzlIs+oYBg7fXGi/MM3/FXFu6B9XTPvy50iUvCvz+9ilepxM/x24BHh/5QQ//7A0bvhOQFTucSKKf0Jq2BFhOJmCC46u+PN+jFuxqYdHYnRmDrjj9Mwim0S5PwhgCJo/GsjeJdfNHmR65/dJlugaOtAzzxQP0iTgaF+dwhLVJSTzIlwE4iAgIipW1GEtKklHLdIAPeUVi0e
 J1Ie0Fsh
 W073xclQV6qI3g9LvcCeA7/iioxgpTuvjYv1Ti6fossbtO8qcJ60DKKWPDIVaC0fPGJmt/R/LXAGXdsatbg6G7VKQLtXbtAgtO8EoWEGg4NVwC1ahQPOXhMaw2t79PAYPgP/Y+Ibld/xpi+Qfw9eAsA2TgYCsfGtXEqmoXAvXf/sxRBRBZqTZH2UzO3cky+WidGDFYvpySTmiIGMSnaK5Mf5OY2hFpygAOIl4LSTfSW/22I8MbmfZZ2I7eDwWKyr3dAofhWRtx7er3TaUrtQvxAvmkqUCBoF78T94e1+I3OtXMTPm4mNUCzpo+CI78f3NGSngY+/niDdT7uhglTM5KMNbYe7wigM3NMZIDVa2Yy0euUsqpmOv9aQ/5dM1Kln7SRJd/uQr87d6VQ9XH2bHDXf4x1mf2jT/Yhc4UKRxl42rASBD1vPWHjFcCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Please consider aedf2efd1897 ("mm/pagewalk: fix stale walk->action escaping
walk_pmd_range()") for 6.12.y.

It fixes 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and
refault"), which is in 6.12.y, but the fix has no Cc: stable so it was never
picked up. 6.12.112 and 6.12.113 still have the pre-fix layout: in
walk_pmd_range() the "walk->action = ACTION_SUBTREE" assignment sits below
the pmd_none() block, so the continue in that block skips it and a stale
ACTION_AGAIN survives into walk_pud_range(), which then re-walks the whole
PUD with walk->private never reset. Same thing in walk_pud_range().

I hit it on the stock 6.12.112 KASAN build:

  BUG: KASAN: use-after-free in __mincore_unmapped_range+0x1ca/0x240
  Write of size 1 at addr ffff888105ae2000 by task exp_root/191
  CPU: 0 UID: 1000 PID: 191 Comm: exp_root Not tainted 6.12.112-dirty #1
   __mincore_unmapped_range+0x1ca/0x240
   mincore_unmapped_range+0x5d/0xd0
   walk_pgd_range+0x8b0/0x1b10
   __walk_page_range+0x418/0x600
   walk_page_range+0x2b1/0x620
   do_mincore+0x1a1/0x350
   __x64_sys_mincore+0x1aa/0x390

The -dirty suffix comes from the kernelCTF build, the tree itself is
unmodified 6.12.112.

Reproducer shape, everything unprivileged (uid 1000): map a memfd so that a
mincore() range of 4096 pages straddles a 1G boundary with exactly one PMD
past the boundary, have a second process call MADV_COLLAPSE on that PMD so
collapse_file() -> retract_page_tables() clears the PMD without holding
mmap_lock, and spin on mincore() in the first process. The raced PMD has to
be the last one in the range, otherwise the next non-none PMD resets
walk->action and the leak is lost. It takes about a minute on a 2 vCPU
guest. I can send the .c off-list if that is useful.

Note that 6.12.y has no CONFIG_PT_RECLAIM, so the MADV_DONTNEED path used by
CVE-2026-89754 does not reach this on 6.12, but MADV_COLLAPSE does.

I only checked 6.12.y. Any stable tree that carries 3b89863c3fa4 without
aedf2efd1897 should be in the same state.

Thanks,
JongHyuk Kim(MalHyuk)

