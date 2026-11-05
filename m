Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F150E606D811
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ewru8Vxm
Received: by kanga.kvack.org (Postfix)
	id 0CC706B05B1; Thu,  5 Nov 2026 05:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A41B6B05BC; Thu,  5 Nov 2026 05:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23266B05BD; Thu,  5 Nov 2026 05:39:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D03876B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:39:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D8B6160971
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:39:52 +0000 (UTC)
X-FDA: 85400719824.07.F1C918C
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf28.hostedemail.com (Postfix) with ESMTP id AE7E7C0009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:39:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ewru8Vxm;
	spf=pass (imf28.hostedemail.com: domain of 39FzsagoKCL0mhqkdrfkhqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jenhaochen.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=39FzsagoKCL0mhqkdrfkhqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jenhaochen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793875190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFIhQY+79JG5rknzOWA6767gSvTCQmC5gGZYO/Mt64s=;
	b=dvYunnilU5wXIYevD3QwB564GqqyhQvpqPgLiA5unFcErR8g2JT4A4W906DsdFdwR/Dfcs
	2BtqFRlKThJ3CsdyVSmegl0/SSGNzIFDUEEFtqLdHwKYFhWKhdYomWA/nzjivJWoooMIds
	t9YHN32/8b3WG5DPHivDNhMU6QD6V6U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793875190;
	b=YGYFsESpCmEWorlTLxLOfSg7rsQBm5w1xYmsejce3awiR8M1s2DJMGaWL9rm0a2T/XxVrc
	dK6b8xoMUVWBV6Co7jb8TPElLwwMi80NwrjMkq4hjhOlUniMOGN7+tFUefJoUo96JTWlu5
	hywORTvgA02NwN7Xe6qRSrJxVMFo/Bc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ewru8Vxm;
	spf=pass (imf28.hostedemail.com: domain of 39FzsagoKCL0mhqkdrfkhqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jenhaochen.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=39FzsagoKCL0mhqkdrfkhqjrrjoh.frpolqx0-ppnydfn.ruj@flex--jenhaochen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e9d52f684fso16983765ad.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 02:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793875189; x=1794479989; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uFIhQY+79JG5rknzOWA6767gSvTCQmC5gGZYO/Mt64s=;
        b=ewru8VxmD1t3GWz4rPRHxs11SIwt0kn3AnPMYzmaXIS9Kq4dJ1FP0E5EwzsHd08aYy
         paDPLgc3zdJ2pjxStRk9mJU4kUWKDefnY1nrygFpM30IZkpMnuMBOTxSKOVDpQBEsr3C
         vCUW10ZtSLq0wnAcsbt6L/7fUNbk2fvQw6MCn+qBhrXJBzrtjyKvTM4xDFe/ropEm4IK
         Dans5wV3RqRbbTzuWqO8v7A1YM15vi/vT5EpEeo/ptWOko2cdFmrKLLUGnOJ/F8Nuhl5
         8fK4J7pOpGIZguAvQudPvTPwzkHywzOprbVEkAFlBBXbYrf4+zS4iKrAQVZStXyOhge9
         Cyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793875189; x=1794479989;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uFIhQY+79JG5rknzOWA6767gSvTCQmC5gGZYO/Mt64s=;
        b=Gj+BkPch7+UMW37/b0E9R13x3ChPbtpovnq96p5hXX22uMX3rrSbvfqZiygAQbS/VU
         SwJkk4XK3USQs0kupKEUycpG+v9uJ3924Fg4+hj3unmwjPNK83JJUSeG9xvZWjjQDOgz
         EyGztAzywBh0VGn/oFMAGnhEjHkeVxS2L/N4sWo7mCEqupdo47FXuBn2iRJjDr97zQdy
         7admSenysJpZDLSc+sgsQR3cHihraGpUCfkm2GMt2PCkjqnsCOO1JlTxNKde+sjgZkAf
         FdIbx7Lkv6vn8udRRJ+emjYdXCRK8+QnlNbG7CSNeGd5bnL0BUBmEmbEumve6577qBVH
         UH/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxd0ojZuPmI4L8bxMtCBzLuFFQ3iAcrpyPJn8NhyRVGLRPdkrFwys+lwVqay/YLBnzlLO4eE1El7Q==@kvack.org
X-Gm-Message-State: APuU4Z/lJ7mGduBG3K0R++IX+1VZh4pWe8fAeE8RoeCqCBl3A+v+3XF0
	1ZEEXAHHCXXR3Yq/pakLsGKmsy9D0t9ZhZ88FnIwUYACSs74VUEhJscmMGciVHAZ48VTb9QSXJs
	ri7gzKsJrpG3u4vj5iBVcKQ==
X-Received: from plao13.prod.google.com ([2002:a17:903:300d:b0:2ea:775d:de30])
 (user=jenhaochen job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2ec3:b0:2d9:464f:d45f with SMTP id d9443c01a7336-2eb364025a8mr173003765ad.5.1793875188940;
 Thu, 05 Nov 2026 02:39:48 -0800 (PST)
Date: Thu,  5 Nov 2026 10:39:47 +0000
In-Reply-To: <auwR7gnuLsF0lpmG@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261030121700.260975-1-jenhaochen@google.com> <auwR7gnuLsF0lpmG@google.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261105103947.7521-1-jenhaochen@google.com>
Subject: Re: [PATCH] mm/zsmalloc: inline obj_malloc() and obj_free()
From: Jenhao Chen <jenhaochen@google.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, minchan@google.com, 
	liumartin@google.com, benwei@google.com, Jenhao Chen <jenhaochen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE7E7C0009
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mekxtpocz77k4ueeji1gzt5397okn1a6
X-Rspam-User: 
X-HE-Tag: 1793875190-873947
X-HE-Meta: U2FsdGVkX1/6aEYGa/jeO9YkW+YOk4T6obBzQVF9GqriByUAaVUaENnyQ0CTGmRY2QojAeptS512aVCv2b+tz+17EVMrz+LqnhMZ15YXWMYet3CfixeG/CwSuP7ZOX1QAOcdAbYzbcS65+egfwNgNVCAVOb/0VOwneyEGJFAF7iLoZblvDef4cZYSc2vOIX0mxHtzdccUd9rGqdPBWmQdKR30CwRCdMZYP5n1iMwLtdBumLNuCCEF7qiJuDKyBmrEuipibOaVBGYH1yJ1R1tAthZacZRbNRD17GeLHU8FPzpx9tHlnLqrBRrbCVRnHCHd90sp9fzd1IKvNMWHFJympa5mapUA3inXfjlRmEHprM4zlLf5vHNtmCS5HD/jQFKtNx8/5+wmklFl8sxmafY7OGqrK7JS8rhrWMPue7cTz8Kee8DfSrbvkkG1KSm0h1flOCk/ittrER0XvARpnE/iAMAW5qY7ILsVwLRAHqfWs5XbgQyCyaYsQ/o8wuaicosDyDc4TAiRWElvZnS2TPod4Qc+rGsWvjzSiAMRDwofDNdj2eOBth3E49Yg/yseHJdCUETSZQNeSQPwEPhQ4M7EF47IXVuxJCJVvIxRNYG1zTNIMHbAgx+otkgVyBr1akAmJFSKMF9lA84IFCQPInAhjQOqygoyrNXCvneuADu1iCNmFyZxLuPXMs/7QRB66zAWAYHSDjaz1I+AawVhqgad2r4XTgNp5L1YCXt15tOC0+clMi14AAn8fCpOff7BZcviBCVxj2gshLmOuDE2bjGuw1vb+4FdMrPJE5fsDDmQYNUm/inPiUmaZmmnQHm4QhHig3mXFpjo5ad6D2MzEWBtvOE8sexO+DIz7cQtiBXDj3P1OnOFOhPOkNEak9Ce7FOjV3mWBYy/7N4vpsqXK/qUhLooVM92jMklvj2oFi/S25sYppfCbhKwTluiwPq0ABQt3w7aWV2ZLqiqkRx/ih
 HwJ1mB4I
 jNK8XIezb/Km9lriD0I7dtZQl9fE5qbMQ3HoTlaNY3CuuDF2WU8Fo7aHjUCt+u6tkrJsPbeQhyp02bPbD5dIbWdEbz1Yp8xOJZLpdnFDlbZfpGzyk6sRlHgoBkLet2vAnSX7/QhpdjDJcU6EmzdRFyQONU9mBh/1N8hD4rAqUqLRZIHwUQ9Ta+E81jSAfUZ66X5dztay49mrRxc7TNqo40rgxCQb1q6E7lxVaF5+j4L0ifNZ3QG2lnQ4kgLfJ+XhKdbPmgxTxAa0Lp5xmENXoa3lRe1FhJfs6b+U78O72QpGpb55j31oy+bVPqklb1OpEx1hgGcoShKa0pVwYwHBHn7YAkmjrO01JwWv7XOAv5fuF9VLtFZLTlaAGkL10gEXjDe7q4Wa6a885YiaQzbpPamLTQ7k0if5TH/9QRU/qVNXEthjenccLapT4qm5wjsLFZJSM6m7MAdLNiuMTMHcgk2NWdLD8zWsN6XJP0B5IZRhPpmdHFcu1RfEDXNuOnQEUN80QFGmrjuD9KVUsgRPBhg7j4bHUcYlvHvgm6nRXDZT1FYom8gGThOm9kbwb0pVDZE1q2CqyGy4/Ov/BqH1yg52KJdsvxa5rW4Ipku2LovxR6eMQBFdge/yS8XzkkKgrvVqI6R9oaj+xlqFsWT9cbNipLedykhomxHwNzQ7ThHuB6+YQsp/gvTb4PEn3tFsmxoTuWW4DPx2VOkOIA22Uf4rSKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 14:23), Sergey Senozhatsky wrote:
> I suppose there is performance benefit?
> 
> I guess I don't mind in principle, one thing to note is that this conflicts
> with [1].
> 
> [1] https://lore.kernel.org/linux-kernel/20261105044752.1997895-1-senozhatsky@chromium.org

Hi Sergey,

Yes -- in a steady-state microbenchmark of paired alloc+write and free
operations across 8 compressed object size classes (384..3136 B):

1. On current mm-new (zs_malloc + zs_obj_write + zs_free):
   - Clang 22 -O2: -7.7 (arm64) / -11.8 (x86_64) retired instructions
     per pair (-3.2% cycles on x86_64).
   - Clang 22 -O2 + CONFIG_AUTOFDO_CLANG: -13.0 (arm64) / -17.5 (x86_64)
     retired instructions per pair (-4.8% cycles on x86_64), while
     shrinking zs_malloc() from 2,872 B to 1,828 B on arm64 (-36%) and
     2,088 B to 1,474 B on x86_64 (-29%).
   - GCC 15 -O2 (x86_64, without AutoFDO): GCC leaves both obj_malloc()
     (306 B) and obj_free() (120 B) out-of-line while inlining the
     single-caller slow path alloc_zspage() into zs_malloc(); the patch
     saves -23.7 retired instructions per pair and shrinks zs_malloc()
     from 1,738 B to 1,441 B (-17%).

2. Rebased on top of [1] (zs_store + zs_free):
   In [PATCH 6/7], the new static obj_write() helper has two call sites
   in zs_store(), so both Clang 22 -O2 (360 B on arm64, 219 B on x86_64)
   and GCC 15 -O2 (obj_write.isra.0, 229 B on x86_64) leave obj_write()
   out-of-line as well. In the zs_store() fast path, obj_malloc() packs
   (m_zpdesc, obj, zspage->class) via location_to_obj(), and the
   out-of-line obj_write() immediately unpacks obj_to_location(),
   recomputes offset_in_page(class->size * obj_idx), and re-checks
   !ZsHugePage(zspage).

   If we also mark obj_write() __always_inline alongside obj_malloc()
   and obj_free() (with noinline on alloc_zspage()), the compiler CSEs
   those redundant operations across the fast path:
   - arm64 (Clang 22): -31.3 (-O2, -4.0%) / -34.7 (-O2 + AUTOFDO, -4.5%)
     retired instructions per zs_store() + zs_free() pair (vs. -8.4 for
     obj_malloc() alone), shrinking zs_store() under AUTOFDO from
     3,144 B to 2,448 B (-22%).
   - x86_64 (Clang 22): -26.6 (-O2) / -31.8 (-O2 + AUTOFDO) retired
     instructions per pair (~4.0-4.5% latency reduction).
   - x86_64 (GCC 15 -O2): -37.1 retired instructions (-5.1%) and -5.3%
     latency (-5.5% cycles) per pair, while keeping zs_store() slightly
     smaller (1,997 B -> 1,943 B).

Would you prefer that I send v2 rebased on top of [1] (including
__always_inline on obj_write()), or send v2 against current mm-new
first?

Thanks,
Jenhao

