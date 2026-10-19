Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AFC60A6F48
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dFHssLLp
Received: by kanga.kvack.org (Postfix)
	id B9C3F6B02D6; Mon, 19 Oct 2026 11:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B738E6B02D8; Mon, 19 Oct 2026 11:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A895A6B02D9; Mon, 19 Oct 2026 11:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4A26B02D6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:51:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E952940758
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:05 +0000 (UTC)
X-FDA: 85339814490.25.201E658
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17212120005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dFHssLLp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnQ2J49HpRqmPpQE8xJNKjzZwCJRVru+IexOjX3ZKk8=;
	b=ia3zx83cO72eWJjUcD60ItqvKxEQYPzdi7LfsjcA2CJ6XjTQpb/SSKSk5Xm30uPMUOurTg
	XzX2GC2VFMjSVf/LV7PPgmMZtms1nt26ACKZ66ffVYWOaiE+U62UBm+mYY+u0wJvykAsJ3
	CWoEPi/NqLIcR8wzXvOlqmoBbRIAJJk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dFHssLLp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425064;
	b=ZnGEcPz4Ig/Wone70Yjg2pxAuyJwIpSHyYgUjaZ4KzREyjmokIscESzf7OyJ0J6ell1GKN
	iAFMLxrjbQqHeRRaYIxvQwJTvrZR7fwV2PC2c7430hvAB6dITfMNnqYIQi80uDukufrLIo
	pN1YCR751Trr/imtfsPeBVx5cONUo5I=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-360bd1d1f9bso245208eec.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792425063; x=1793029863; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FnQ2J49HpRqmPpQE8xJNKjzZwCJRVru+IexOjX3ZKk8=;
        b=dFHssLLpApbKLQwHBh1JkBoX1Wwz0pWKGWs9C7zeLgWU3qfmIGLLDmyoc4aqw47rJJ
         zE25VvAbtldU18n1fJk+t1P/5unQdE8rXVJsKD1q3o/FoCLUzllV8LlxAM8LJZVEZwe+
         L6GNuDWu319N1DvtKkJVe2fPYp6eF6P+AP8dlLEU55rfXcKgYFDAkcIpOLst8lwpywOP
         ISlkAV4PxXMIed9qkLgAJeNP/XOJrlEh1xV9UHcMojnQRsmqR6bSlOuwPP/bb2OUaCvR
         A/F56h9VJyvshP+yamdjHNi/hyBzAwe4Kzc0DH6pz0FRsrdnuuMh3TkyXECDcN/rHZYx
         W5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792425063; x=1793029863;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FnQ2J49HpRqmPpQE8xJNKjzZwCJRVru+IexOjX3ZKk8=;
        b=wrPNreIJ0Y9dFYD1YZPxMQcCW3DtzHSqgheRit5hCgVCc11VKOkq9U6mFBqdn71nnh
         avMjH7N4Kan2TOnvHasElEkzo9AviJxwSs2GHliKYDaGFvlWUwv3wS6H4RmfY4n/d5S0
         Z7iymISywt/E50wt44xkEIyf+3KQJ6zas1MTCywkNYaIAH2APhLzIwJz3Rg4bXcxUz0w
         SYAemvvUYdrTUNQr2juZ+A3EOqWTpVy43HWAnEolZ+xultofT5b/7sOZ+oAhDnbJfPyS
         tvDXgwRpBSnQttvBCMqAWpgE6g4HdhGiH2HoipfyR9BTebIfKdm0oXxmX1u4jcYNh6Li
         /ExQ==
X-Forwarded-Encrypted: i=1; AKwUvByHspl66J8ePa7v+HUwDGahSK1wRsxo4Y+200+976ROLgAekIsFJEYIMgq16Vo1x/dUB2C9lCnPOw==@kvack.org
X-Gm-Message-State: AFq9FYJeyztWWhJGrasex3Ke+QnS/+ky14Hb6e0luBmg30/nAdnnPZss
	ElgwheJra73OU/C2a7ZZLrSIJZEikVuGvWUqxj16UoiYg4tUHqRcl4AE
X-Gm-Gg: AYBFou03xIiyZLYEqkNpbwRGaLjOeJp3wjSh/DaNheMTx3pVDTOixVqeoTZF4Ia3pbz
	EcNp0V93N6ex1dtuUy5A4mbYjhxnMkFxDrL9szuJBnscupwDlJ+IFfjISsLR0cm4jmt3p8V3ysu
	ADlAeabqP3Xb8BzAHwK6TOqfEOP2thAWNazNoQRG+dz4IRuMc9Zb5qr7A0Q+ftBfDusUj/ssb6R
	kl0bfvlHWVscWZ5LNSubP4VYpXy//STMRMyqbkEBfbn/qRMX/Y26v2maX7QRCMblMqpH8aHBkSy
	jewaW438/9NfpeHXH8pgpS1KDzWnfrPfvvgIDewqGzqtEmFBt7aV7EDCE5irObzEaPLD5j9Z6ET
	sJEKKzPTnUwdoFrjPvbZeU2YZ5I8MfSRW9hk/s+bzwy23D9J3GSCWD6Oj3fEPmgy45rICsL5/4/
	kbVpb6nS8QSF4WdYWyp95676s1M6dVNw8I7okNAdjx0AL5xoUKBIFcibkT8d5pA/IOfn49jSz2d
	6zPo9gzzUmWWkqui69nPtGioa2H+NOb1SdMAiI36qHAYZq/
X-Received: by 2002:a05:693c:409c:b0:35b:cb8a:8ce7 with SMTP id 5a478bee46e88-361a06a6544mr21354226eec.1.1792425062580;
        Mon, 19 Oct 2026 08:51:02 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360813b6ca5sm31475194eec.9.2026.10.19.08.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 08:51:00 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: zhangbo0325@gmail.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm: compaction: mTHP-friendly memory compaction
Date: Mon, 19 Oct 2026 23:50:48 +0800
Message-ID: <20261019155048.3916405-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17212120005
X-Rspam-User: 
X-Stat-Signature: uq1dxyhtgke368qgaigegqwboyfymbpw
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_PATCH,
	MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792425063-898509
X-HE-Meta: U2FsdGVkX1/Ynahrkju3ZnPf105YcWK43LLRhxelqkGTmvLBrdmr1n/SWEb5jysUU26CXHqER4fEbvmDSn7LKn8nujU5yYXhs7wOPD3NwqjLP+gjINWRVeT4Qp3fBruIx6P1dpgseVEL5AXFTTDctQoB9seNF5rB2vJP68VFCAfY47EwhUxd90EkXk9GSzdz3dUehgCfJAsYEG6w9aytitI4JU30BVKGnm/wEouOcs+Rcg1pxhQpBaKxzb1sFsZ5iGRBqa9Zywa/hefAp/+MO4IleF6W9JxuvNs8M4DbHptNZXBRFyxTrOXWSjyCiomn9WqzTsnSoXb/VOTnqXyVWviwjRDisgsos6xhRyuJ7Bm3aVqokxadOUfku0Xn2WV7OpI5WEV1SBJzv4mV3p06/yI2hdYQxMa7wczxfwdQmRrxZLJIYtEtKLLFwYfoQI3I0Qflg83z6tDbuth5rokd6a3vcx9dDd0+CURRnn1V/QbXR5uxma0VTiVw6DVj2XRSD7s5QMLbXtlzvVRd5waNxZXVtdVBzVsKvqX3UlixYrsYzH0d80k2ccqRnPg501AhfBZa1pBexknh1vKfnbu7Tcj2NU445jO14KgUSBsDN7JnR3d1MQwf1gRxM8NRzZHL4aeOSmkYVB4+C0Of5IvRh0EByogiyzIHxLKhya4940fkn4b6qHyE0SVaQx5KFRCPRGs9Xa/tC8R9Ih+Ok1IuSI6bCjZvSXiPfbPmQdI8Gl0xAyP1trZ5ttcRQ4w0vJzYiMlAhpJAkiPDPNDGEuV8VVQZCq+Dfras9Q3jtFxiLLIgD+qcTFXni+0OkS8Du5m3KEDVkgFspBHnNn0JtbwdodS9gtSRCxl1CEL0DBH8OrnbT+4EVO0Shxb8wL8puRAtaBffTpAIRkvfN9RfiqFnYDZ5WsJVOJFw3VknEZUC8REYuqA7iyUlRsPRSpq1vW1VQlSwx+WT/LQXyiGJx/J
 U8RabCEe
 HibwAGYtQsy3MfGQa9WK7pKUjj4bApVAw16KIUfEyjA7a17z+lZ/P4p5xvEslbB/+/sAr3oaEFVfCybSlMmDrN6O1xbkpE1kvyDcvPaaYTntFLfrhv0EsiDvt37QBAfV9SfDY62Bo9/TumDpuxI15X98H77uIfrqbLqtpTVzshK8/dGJtXwsGZEqFH0jTyuwPkdJ6MhmKZA9OmE6ggw1eq/l0eo2ONefyg+nbMSe/1g6FHo20G7Z5EHh06VKQvXbLUJs33pMHY7HrX4OgNblIpWfjhopMenB3rJzKbcdEWgjQsGUX1O98kO8Ge/9N61H0I75TVWwW1VCsFffDDcUoWgBQmVTpQCm5ueQwDiW19QF0pfpUrd7SMiDccrJXPD73n2MYSma0g+9tnRhwIRv4N3Ppj0p1dNZGTGSCkv5lMdbgFulS6xQxReKjKF5OcQ8hmyETbVJzrrC2e4L2wih9ahrjjp+OrJfyHaf7NGf0Jr4bgTc3E7bM2o3FwEmzJVrMuwFUPYYErWxfwP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Oct 01, 2026 at 08:14:08AM +0800, Bo Zhang wrote:
>Hi all,
>
>This series improves memory compaction to better serve mTHP (multi-size
>THP) allocations, particularly for small orders like order-2 (16KB).
>The changes focus on the proactive (kcompactd) compaction path.
>
>Problem:
>
>The current proactive compaction targets COMPACTION_HPAGE_ORDER (order-9,
>2MB), which is unfriendly to mTHP in two ways:
>
>1. It migrates folios that already satisfy mTHP allocation needs. For
>   example, an order-2 folio is a valid mTHP page, yet compaction still
>   moves it around trying to form order-9 blocks. This is unnecessary
>   work and wastes energy.
>
>2. Compaction designed for 2MB huge pages is too heavyweight for mTHP.
>   mTHP allocations are frequent and only require small contiguous blocks
>   (e.g., 4 pages for order-2). A lighter-weight, mTHP-aware compaction
>   strategy is needed to reduce overhead and power consumption.
>
>Approach:
>
>This series makes four changes:
>
>1. Generalize the fragmentation score functions to accept an order
>   parameter. This is a pure refactor with no functional change; all
>   callers still pass COMPACTION_HPAGE_ORDER.
>
>2. Use the highest always-enabled mTHP order as the proactive compaction
>   target. Because a fragmentation score for a small order is naturally
>   much lower than for order-9 under the same fragmentation state, the
>   proactive watermark is scaled down in proportion to the target order;
>   otherwise a small order would almost never reach the trigger threshold.
>
>3. During proactive compaction (compact_memory), skip isolating folios
>   that already satisfy mTHP requirements, avoiding unnecessary migration
>   overhead.
>
>4. For non-costly mTHP orders, restrict proactive compaction to movable
>   (and CMA) pageblocks. Unmovable/reclaimable blocks are dominated by
>   non-migratable kernel allocations. scanning them wastes cycles because
>   a small order can be satisfied from movable blocks alone. Costly orders
>   keep scanning all blocks, since they are harder to form and benefit
>   from any migratable page available.
>
>Test setup:
>
>x86 host, arm64 cross-build (defconfig + CONFIG_DEBUG_INFO=y,
>CONFIG_DEBUG_INFO_DWARF5=y), booted with mem=4G. order-3 (32KB) mTHP is
>set to "always"; ext4 root mounted data=journal. The kernel build
>naturally fragments order-3 free memory during the run.
>
>Runtime (two defrag modes were tested, see Results):
>  echo always > .../hugepages-32kB/enabled
>  echo madvise > .../transparent_hugepage/defrag   # or: always
>  echo 20 > /proc/sys/vm/compaction_proactiveness
>
>A background loop keeps proactiveness poked every 100ms so kcompactd
>re-evaluates promptly (its default 500ms interval is too coarse to catch
>the transient order-3 fragmentation peaks under this workload):
>
>  while true; do
>      echo 20 > /proc/sys/vm/compaction_proactiveness
>      sleep 0.1
>  done
>
>Workload: make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- vmlinux -j28
>5 rounds per configuration; each round: make clean + drop_caches, then
>counter deltas around the build. The baseline is the unmodified kernel.
>
>Results (5-round means). anon_fault_alloc is within 1% between kernels,
>so the fallback numbers are directly comparable.
>
>defrag=madvise:
>                              w/o patch     w/ patch    change
>  --------------------------  -----------  -----------  --------
>  anon_fault_alloc             14,307,597   14,401,699    +1%
>  anon_fault_fallback              97,701       40,975   -58%
>  fallback ratio                    0.68%        0.28%
>  compact_isolated              8,479,773    1,458,949   -83%
>  compact_migrate_scanned      78,198,828   22,900,359   -71%
>  kcompactd cpu (s)                    43            7   -84%
>  sys (kernel build)                6m34s        6m34s    ~0%
>
>defrag=always:
>                              w/o patch     w/ patch    change
>  --------------------------  -----------  -----------  --------
>  anon_fault_alloc             14,370,984   14,404,234    ~0%
>  anon_fault_fallback                 619          823
>  compact_stall                       979          585   -40%
>  compact_isolated              6,390,940    2,431,800   -62%
>  compact_migrate_scanned      86,171,095   46,339,911   -46%
>  kcompactd cpu (s)                    36           13   -62%
>  sys (kernel build)                6m34s        6m27s   -1.8%
>
>1. With defrag=madvise, the patch cuts mTHP fallback by 58% (ratio
>   0.68% -> 0.28%).
>
>2. With defrag=always, direct compaction already keeps fallback near
>   zero, and the patch instead cuts direct compaction stalls by 40%.
>
>In both cases the compaction is done far more cheaply (kcompactd CPU
>-62..84%, compact_isolated/scanned -46..83%).

Hi Bo,

With proactive compaction enabled, have you measured the change in power
consumption on Android devices after applying this patch series?

>
>Open questions:
>
>1. In skip_isolation_on_order() and elsewhere, the target order is read
>   from huge_anon_orders_always directly, since during proactive
>   compaction cc->order is -1 (via compact_memory) and there is no clean
>   way to plumb the mTHP order down. This variable can change under
>   userspace at any time, making the semantics fragile. Ideas on how to
>   pass the target order through the proactive path cleanly are welcome.
>
>2. The proactive watermark is scaled linearly by the target order
>   (wmark * order / COMPACTION_HPAGE_ORDER). This is empirical; a more
>   principled cross-order normalization of the fragmentation score would
>   be welcome.
>
>Changes since v1
>================
>
>The series is now scoped to the proactive compaction path only. Two
>patches from v1 were dropped, and two new mechanisms were added:
>
>- Dropped v1 patch 3 ("don't skip proactive compaction for non-costly
>  mTHP", i.e. running proactive compaction concurrently with kswapd).
>  Follow-up testing showed it lowered fallback mainly by driving extra
>  anonymous reclaim/swap rather than by better compaction; keeping the
>  original kswapd back-off avoids trading workingset for mTHP fallback.
>
>- Dropped v1 patch 4 (mTHP-aware zone_effective_free_pages() watermark):
>  it added reclaim pressure without a clear net benefit in this scope.
>
>- Split the former patch 1 into a pure refactor (parameterize the
>  fragmentation score by order) plus the mTHP-targeting change, so the
>  mechanical and behavioural parts can be reviewed independently.
>
>- Added the proactive watermark scaling by target order, so a small mTHP
>  order can actually reach the trigger threshold.
>
>- Added patch 4 (skip unmovable blocks for non-costly proactive mTHP
>  compaction). Without it, proactive compaction wastes most of its
>  scanning on unmovable blocks full of kernel allocations; with it,
>  kcompactd's CPU and the scanned/isolated counters drop by an order of
>  magnitude while fallback still improves.
>
>- compact_hpage_order() uses __fls() (highest always-enabled mTHP order)
>  guarded by #ifdef CONFIG_TRANSPARENT_HUGEPAGE (m68k allmodconfig build
>  fix from the kernel test robot).
>
>- Refreshed test data on an mem=4G, order-3, data=journal kernel-build
>  workload; see Results above.
>
>Bo Zhang (4):
>  mm: compaction: parameterize fragmentation score by order
>  mm: compaction: target mTHP order for proactive compaction
>  mm: compaction: skip isolating large folios that already satisfy mTHP
>  mm: compaction: skip unmovable blocks for non-costly proactive mTHP
>    compaction
>
> mm/compaction.c | 85 +++++++++++++++++++++++++++++++++++++++----------
> 1 file changed, 68 insertions(+), 17 deletions(-)
>
>-- 
>2.34.1
>
>

