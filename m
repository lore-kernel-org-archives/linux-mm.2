Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34832606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NxSLpWKD
Received: by kanga.kvack.org (Postfix)
	id 2BD406B05B9; Tue, 10 Nov 2026 12:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DF56B05BA; Tue, 10 Nov 2026 12:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D866B05BB; Tue, 10 Nov 2026 12:59:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5EF96B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 811041609E1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:44 +0000 (UTC)
X-FDA: 85419972288.26.9390D7C
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id C73FA160004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NxSLpWKD;
	spf=pass (imf08.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XmC4GUa/rulCX5qlkxBsaY5GKMUzAQdtcV8eTaZtnBs=;
	b=srh3k9tyocM3Zb3WGyGusGvhCIkUYW3choNZhgUW8fgV0UN+ZBqJY/qRV211raZ6gBZDmx
	Y6JtwZDCFhUuu9CKLqf1wzZbBuM+i4KKdRJIM9DH7jwdfH4M/6Sl7TsUCJkjLjZJN3eFHl
	5TbPEzRAtdWVAbqjHHYXWF7NWPn9Ohg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333582;
	b=KwoJryE/uAnC7ypA9w+Z7DYvQSFpWtbdcMF2zhPiP5OTc2RzOTSNULxUrCEGrTnGhTC7lO
	e2cq7C2m8XaS/NtEv4x1qEXHnOy/raV3BUMrQCGw4YSIe/OWuSOMfd5XGyKtCATUCe6eqb
	6WTbUPMzYs0AVCtzStdoY39bxRx4dnc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NxSLpWKD;
	spf=pass (imf08.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1b3b4944abeso1248997c88.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333581; x=1794938381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XmC4GUa/rulCX5qlkxBsaY5GKMUzAQdtcV8eTaZtnBs=;
        b=NxSLpWKDSDY5/DU8AN8AcjkrPIAZ2pStQD5xcz5/VmF8x/kjDLpXV7OPy72Dbryzz7
         OK3NR6cHJrY+4NRiydekKncQcoQ/9cI5J1gdNfD60+fxas4AJiq4t691OyRYAMdPJuJS
         xt1S+gvI/KPXqDpVki/mWUn8/vrSbR5LC2G0L1zXk8ehtuzqg0FBVzI8sOp1oiVSF9Ge
         0FaOSzNH5dQIA0jsJ7EgDQmKJkkAemZcgsbgyk41J/oOtP0hSG/NaruuXyinMSiDrVFe
         bIZxqof1fckZTxqmajWZole/s5rwGzn0ybuZ/i2qpSsl86mlrRVdlAH0t6Gk2lrkZW9f
         CqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333581; x=1794938381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XmC4GUa/rulCX5qlkxBsaY5GKMUzAQdtcV8eTaZtnBs=;
        b=Dgl/xjd4Udy0M51KC6sKaOXn7J0FhCAripttrSqZ/gICpuxfSBCJLwK/o3ATlz/sM0
         4ksEu+SisfssunGsjLYTlzcaxkO+HczRHNDHe1XIAwMUwn4SJIgVyYUTMc27UMt9m4gS
         50WqrX7AtaQQfM9gDCW5/z9rTFY5R6bVi/6ei5CGpOn7wxrN9L8RQVBRdeiKhEx7MMws
         YVFFZFJ6yOc8lVHvxPktdB4r1xIfXPxH8mlnZah7ow0RqFwVpobVjUw5BqKvaXY+CRyb
         Us7jbJP+1TBeKuIRHlrVxYnGwdcXAG+fwStDmL6vEJP1QSSfuxoOF9GmFES9eS9OLNnG
         wcGQ==
X-Forwarded-Encrypted: i=1; AL+hErFZaplO65R1p7JNEdc1QzDYvLKbkeNejkF1uKnPRM8sBaqgskSYv0Uf04Ti8GOXpPyAj9Pyg8iHTA==@kvack.org
X-Gm-Message-State: APuU4Z+T+sPmusdG9Hov/g1OJQ/WvRNHf4hBf+XALGFlXOwRtkzfWuOA
	67JdRFyYSClEhjQ1pzt33TpOZuFxK8xjwC3yRb3I+YUVasn+pdOiF0AP
X-Gm-Gg: AYBFou0+QdGG/asGxu3r+Cakt5+F209yNzHCwjVmAOqmUgjLbNWJGWM4XiT61bQXWhk
	YDfMmwVjWaP89ADBaBY24lC8baLQ3ZuwdArUpaz0rG3ldf1jX+aNVoUOH+KV4rY/BxP2NOjAp1L
	k9lRDUPZ84nk25Ko1NrhhepKVdeXvV1lObXVxak3G0yxjGigdtDp1txG7/ClCNvXLx9y+Ed+cqn
	X5+siSjqEoneO9Fa0aiJ+gnHsGZ0vzNabZbK0l+bNyPEmJVuQr+1e+fDW2HbAz5Qaqi/m7n3L0x
	8/1IPCKQ3P0T3c1SNR+riJtOYZoBykSrifv+i8fqjwHUfsSztGdSmTHcBMYcXOGuHV5CH0Axt6B
	cabyYdJuYaCJ7uB0slAds50J33qU5NHYWA8luRqU/8A1yG/2qxJuNYf9La2pB1p408F4AwwxKzK
	1Lnfr3UWk8GOJv58VqWU8cMb7eighYvOpCbqinfxjDyxfrOLyAEw/GwQCeJ6ZSn3tb9ZC0zGGJv
	Au5qMJyzt50tsCq9P+qDa5DA3I8G+gJnhgZu2698o1//6T1RwlHjnF1I76mA5olCy1i7PUUszFo
	AaX/UuMkifJjE6ufY857jSB58hod/kgRHBl4BLF3M3aMGTRVxS7TmQ97MV9o33BFY/sSnlZzMiN
	butZq/w==
X-Received: by 2002:a05:7022:7f1b:b0:1b0:430d:d81c with SMTP id a92af1059eb24-1b3b607e53dmr3882636c88.25.1794333581359;
        Tue, 10 Nov 2026 09:59:41 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.09.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 09:59:40 -0800 (PST)
From: Yin Tirui <yintirui@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com
Cc: ljs@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	nico.pache@linux.dev,
	usama.arif@linux.dev,
	liam@infradead.org,
	kas@kernel.org,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	yintirui@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC v2 0/9] mm/huge_memory: refactor __split_huge_pmd_locked()
Date: Wed, 11 Nov 2026 01:59:15 +0800
Message-Id: <20261110175924.2945538-1-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ns91mzguwp5jigfscdhmwi14kuoq1n9c
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: C73FA160004
X-Rspam-User: 
X-HE-Tag: 1794333582-838677
X-HE-Meta: U2FsdGVkX1+XRai6vqxkf1B8UDKBvfS2TODKJyP650Jczf45j14D6ZIYyE2DFPoORkALuRuLnmrZZ+VDstI50iXfU6Y5gP3f7gTZ62Ky+apNTknpaV83kPtjQaT5xHSyYrvz3YvtcPPVmruTLT3X8Wy1LERoOVUvoPFMUKckF4RBopuHNYzO+bZhlawsdZtyPwEngwPlh9qARas+jmYEU4unp1CSiAr8rDr6jBvUTFoYN1fsb4GPRWjFkie4EN22sypO5p2KxDFTRUH4vsImjSWSw4s4A6j/9WQjpAtHNC4RiV9DdkDUQwi8QZyMo6bpG/m6lkeF8sn7uOSeuAB1vgvDTALS4NGNTYCMm5GC5Rk0+dKUYBGfdjM6RqqoT1EynRN5aJpTGE8kXpUnl2sOCq/C1kRqogqYD06nQGXR1j2va9mErknI3mzwU/SDbDqIsxJX41F9OANEr/Lbq2WCuk7YACbPf6tZSmG+GBH9/XoFR0CqDOSzDpl5BdPfp5PKWY9YnV1gcyXnlQkzZG2jX53nWL/KqkyNycauu4WFCJc0ZTvR0Fj3DBEFQDUhjIuOwwAvc8NvFJ30TiUFlkm1r8lDiIXrOZO7kQVXAarFXqolaw/EHfY/EOXps0kUa8r8lQu6JYAUYW8dmRWT78Bk+AwCFcHmmdyxcIMMySXyn50Ru11ul8anajZWV20j66wl+EziKxsKsPZclR3pr7Q523pxOaJPHFzwwjk4JGN7+ZA4JceRmeY0XgsNAvgGL/1uoyl5QxJyUWvmqMvIg+1ELE7t90AVPjjtJBnCnfQOMgPKHbwzWBREvNTa5ik0te8j3SLZNdyyrugcoOlvPGg7gcSC/nij0pJXOwVNCgevZWBw5VzeFnWQbtNJPEv19uYRZiiKwxyEqbV537Cw5fXL+0v9eN0+Wa6AR0gTmkv68iam0gUPcZiyez687Yb5EELK//4e/DQ0LkJVyQ39AT6
 9B/EvJea
 Zn8y/YTf4aXm+Wbi+pdbdq1cJd0uJ7kj6M3J1LNT/r4WKpRmc9HPOHYjMLuSSCv8g1wdJqul/pvT5c8GehdHC4dACQb30RY738NFHSNdFDkamlEdCUi98ywLSsET66Sb2Unh/E8101gpLhqMH6oOg9mumRt0R6ISUBvxZmKkQdVMqHKLtYz7asF2g5CydWFDmRuDzuRa80fxA5G1Q2jqfigbtrw7H3e8v9C3P1fOKOXw0bGHMWyt0S27zPJBhreLKk5Br8MKpMCqsTTnl+IfCdlBE0OWylEQ5Vm64Q/RE7p4iANeQOsu3tEKn5GGklXf12JsxxzjO9e5o351Ii9ARx12f+QfvTuDtI1JRMADMlRjwoikfA4Sfar8PrzzABmQwu7Xy2cyPn5F+KTXLh6Zy97axNypcJjgGcLFx7BgAajuv9ynJEC4M93uN2+gMcECELhe5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__split_huge_pmd_locked() currently decides from the VMA --
vma_is_anonymous(), then vma_is_special_huge() (now replaced by
!vma_is_mm_managed()) -- before inspecting the PMD entry, so split and
zap use different classification logic. The entry itself should decide.
The function also mixes the present and non-present cases, resulting
in duplicated code.

This series uses the PMD entry and its folio to decide how to handle each
PMD, as zap_huge_pmd() does. It separates the present and non-present paths
and moves their common work into helper functions. After this change,
__split_huge_pmd_locked() only selects the appropriate helper.

v1 -> v2:
https://lore.kernel.org/linux-mm/cover.1787941780.git.yintirui@gmail.com/#t
- Rebase onto mainline.
- Use !vma_is_mm_managed() in place of vma_is_special_huge() in patch 3.
- Use vma_has_deposited_pgtable() in patch 4, following Lance Yang's
  pgtable deposit cleanup.
  https://lore.kernel.org/linux-mm/20260917054015.23553-1-lance.yang@linux.dev/

Yin Tirui (9):
  mm/huge_memory: read the huge PMD entry once when splitting it
  mm/huge_memory: add and use huge_zero_pmd_can_split()
  mm/huge_memory: add and use unmap_huge_pmd_entry()
  mm/huge_memory: use normal_or_softleaf_folio_pmd() in the PMD split
    path
  mm/huge_memory: dispatch on the folio when splitting a huge PMD
  mm/huge_memory: add and use split_huge_pmd_anon_rmap()
  mm/huge_memory: add struct split_pmd_state
  mm/huge_memory: split present and non-present huge PMDs separately
  mm/huge_memory: unify the migration and device private PTE loops

 mm/huge_memory.c | 525 +++++++++++++++++++++++++++--------------------
 1 file changed, 302 insertions(+), 223 deletions(-)

-- 
2.34.1


