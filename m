Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B35E92733
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 16:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A9B6B0088; Mon, 29 Dec 2025 11:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBAC6B008C; Mon, 29 Dec 2025 11:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832606B0092; Mon, 29 Dec 2025 11:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4596B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:45:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B891C1676
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:45:03 +0000 (UTC)
X-FDA: 84273083286.16.606DC2A
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FC458000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:45:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767026701; a=rsa-sha256;
	cv=none;
	b=xnNt2KxsDLxzoiKLlPA8zuohKvwtFK/00Co9fdqmEzvbRpGFjPhkdA3A8PwKovZ4T4IPaq
	bt8X0rD3GjOjsPiiB6U/3iXMJl5d9udOFrn0eG1Fc9+kD9yFZaoC0Rne2FdOzbJq97OrQr
	30Sdm8qRfJZ1j6pObpHfCNveGvQsYbg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767026701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rSXDsPw9SWpPdwz0G6LJLeCgBG0923yYOTzxWibmOZo=;
	b=GR34gXubyUlxWJqZ0A5Q3Fq51/gRtYMO+Y4Xu3uchrv1rz0Vhh8UtS8DWhtn1VZcdboVDF
	AfM6lN6d6pNnrmddXX36/w9J+I8Ddi2UxdWC5B//qpHSfvnLyrMds3aPvVXqKJ71SB6IhC
	OruFVZ4uB8Dq41AmC008ouZmeH6EYZQ=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7c6ce4f65f7so9734848a34.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767026700; x=1767631500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rSXDsPw9SWpPdwz0G6LJLeCgBG0923yYOTzxWibmOZo=;
        b=tIofNktkV0XNX7LC6JX9z//DcvO6aFbGR3yNLKV/pSWi6MQ5BlYIXOCnVfa0Eys4hz
         u7cdzAlq9SEa45ObKt2uJvJPRvIe8AuMqNgc1UQlFzi3Cw3DRMbdqQI40tRLmWtuYtud
         xYwX9TmCW710jwqHjrldgJ1/1g+nc/jxn831QMRUmu3fNFDw3LjlVvij0FyG8s0dTBUS
         +UvOv7fI21xtzGOj0UdOGx4d3zaES+rmsw9JFq8vhofydtxCABLdMTmwmVkxWJ775Q/H
         bmBUZDLxfBvYs4dLHGx3T/+Ed+HcHUctOd+xPay9Jvuk08PrYfhL4HxvzleskcLx6s2N
         JrDg==
X-Forwarded-Encrypted: i=1; AJvYcCVp2SilqAIgwA6WZni8nJL4x/v5kemK+xdcN39xJlC/+99iL/VOuNp7StQ7mMbTqQP8Lb3JDc2Y1A==@kvack.org
X-Gm-Message-State: AOJu0YxweqJ7FbIGE1fG2ml5Q3i28SbzW90qD6hwIG1PkZlr2Wz8mjkv
	cSiaRT7wjei8yRjlWtA0BgxzWc835RlJinQ8SnZnE+8Rm7TX/0o/rCaGPAEbX+d8MpM=
X-Gm-Gg: AY/fxX4/JD1tC/pAjFdQu374cgWmgmx5ofXXknRkEDQwQT3UdABo/pdOqpHK82JP+hQ
	EuJ/w2AlDWRHFWUNznmNTnXmjSXBsdiPnhQ0FDfn9F7L4E2koFxfjAGykq7EeSxVjUFoOXnxmUq
	z2GywPG8In61ay2tcL4l8xxiTPMlJ9T0jWJrC+NbUtpIiSD5s+tE1lfga5b9HrnPOzGw5pdssA3
	Ju37z+kyLpKPhg2TBrBNY+I/11Tu0vSrjMUz01a10X7IqKqAH5D+2565UL3CTUE/4bBbl1397YX
	cIHX4g3WEK5FZbSx3WdisUmqErjTic1of6xfju5hVpuXYgfvGrlLfSt2qvBRWxsWiGUsdb4jS3/
	y0qlR48Q8JFfgtu/PSYoZxSn8Le/2XKjDFy4bWH2/IO2EuoLLdHTzErCOgmXh4TReWdmjhSpfeQ
	34cyq7DLoiYNnZfI/CcPOb
X-Google-Smtp-Source: AGHT+IEP/l8Fja7SBvXa0ush+/T4hTB3LaeICnV93wQNMRXO4irWoD5nheCHiMMFR22YVQ8DnynhEA==
X-Received: by 2002:a05:7022:208:b0:119:e56b:c74d with SMTP id a92af1059eb24-121722b2bc9mr31073304c88.18.1767020515978;
        Mon, 29 Dec 2025 07:01:55 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([154.17.20.208])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217253c058sm118358235c88.11.2025.12.29.07.01.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 07:01:55 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: lance.yang@linux.dev
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	arnd@arndb.de,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	hpa@zytor.com,
	ioworker0@gmail.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	npache@redhat.com,
	npiggin@gmail.com,
	peterz@infradead.org,
	riel@surriel.com,
	ryan.roberts@arm.com,
	shy828301@gmail.com,
	tglx@linutronix.de,
	will@kernel.org,
	x86@kernel.org,
	ziy@nvidia.com
Subject: [PATCH v2 0/3] skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 23:01:47 +0800
Message-ID: <20251229150147.89896-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <17a56acb-4e2c-4b14-bdb7-f64b105a3b4f@linux.dev>
References: <17a56acb-4e2c-4b14-bdb7-f64b105a3b4f@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FC458000B
X-Stat-Signature: hammzjgykxexwdb5akenzkdyw4e6gxj4
X-Rspam-User: 
X-HE-Tag: 1767026701-831904
X-HE-Meta: U2FsdGVkX181Gy0Ttj3Lh28OjwbxiRr5CrWH+2P92boEA33Q26qvcTsRm5OL5O1y8z7MuvqNQ0li5qYVVj4imebSJ/+QdzriSbr7jypu+enpQKSNhAs5paLkf4vz58WXWgs6bKCGCIMT7+y8rp6+hI+aVt6r9sdcf8Ylxa5QIVJtYyCwaBMoKjoL6FxrcaMyoSIzT2bjALtwxutFFpzrazEXZV8q26u5deBXuA118AsStF3KQnSzP1Nj/pvJQOTR+kHYLFn9rG+oWg13ujqrOpDqOUBrkJpTf7QnjfTmisJmv+/gkZ/h6QBMihO7SIKynfgQe6JxyEKwlUYsWppOZ6Ngy/vyG2o2S6CAcBfxN6gFS5fGz1Pgl3VnvjZGqIHUVs4U2Pl7RE+fPkWpIrDxo697eVcvbn5u6yiKP5Uby4aM48fK10fLhLzw03dd/gPY1ELAx6bPbkj4+SceBZcD3jSEiG4wRdAnETR483V0iiuleQBPpPkUOaj1ftVHBuEEbw4tPwi8K8GZ6YXprsmyhUjbovdc8UIoVT6FXLqL88IItj1da8a+g4wfB/wSV+R8y3lBPvWeBjQSBdKApPqyjZpSkSNt9o55AH1r+V99j01ZonU1u1GmtiJ0gPfGb38txYVvgHUscl/4CMkcC758D0YFT+BBJJ4cXr4fTufulo2hnWt3O+Y8+Om85mI4mYTonyY57SsoHae7j+3bFGptWBfjFXtbO6neWMI5Um3XvcidBHh07sWrJEH+EDJTxe7un2aKz9rUbFIdSVV69iLEs4/TODesH5b/O/BFknjubTSKiQjdIfE0C2t/obs04fIjZ9cBtohvphrBjLwQVX+HZV4j7yRe6oZ5ZGkbCfVcXTgZKCDfGSjAg1bE9XZdnpxr0yoCSIRPs0XYU6OCElQSKDtIa2iufWQ9bydqNT4RpoxD4TFpXHppKj4OVVDKm+CS2VJ+HffOV7ExTWxQ/+U
 R0ziuwAf
 sDEQzrREZzIOtrAc1W9ioKYXc8nsoL+IPywjERuSrBwUzRphzU+nnYTe6HrN3zj/879eg6y7e1uRV4qWdGdvprNKv75XBZFgTjZP8rjET94P9TgQaqefCkmhMHtBoNo5WRWhB4/CqQsZiJx/frr0IU0Eq+SzketG2ue4zpCc4jY5ZFTpp8kX+X9Iwbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Hi all,

When unsharing hugetlb PMD page tables or collapsing pages in khugepaged,
we send two IPIs: one for TLB invalidation, and another to synchronize
with concurrent GUP-fast walkers. However, if the TLB flush already
reaches all CPUs, the second IPI is redundant. GUP-fast runs with IRQs
disabled, so when the TLB flush IPI completes, any concurrent GUP-fast
must have finished.

This series introduces a way for architectures to indicate their TLB flush
already provides full synchronization, allowing the redundant IPI to be
skipped. For now, the optimization is implemented for x86 first and applied
to all page table operations that free or unshare tables.

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further - thanks a lot David!

v1 -> v2:
- Fix cover letter encoding to resolve send-email issues. Apologies for
  any email flood caused by the failed send attempts :(

RFC -> v1:
- Use a callback function in pv_mmu_ops instead of comparing function
  pointers (per David)
- Embed the check directly in tlb_remove_table_sync_one() instead of
  requiring every caller to check explicitly (per David)
- Move tlb_table_flush_implies_ipi_broadcast() outside of
  CONFIG_MMU_GATHER_RCU_TABLE_FREE to fix build error on architectures
  that don't enable this config.
  https://lore.kernel.org/oe-kbuild-all/202512142156.cShiu6PU-lkp@intel.com/
- https://lore.kernel.org/linux-mm/20251213080038.10917-1-lance.yang@linux.dev/


Lance Yang (3):
  mm/tlb: allow architectures to skip redundant TLB sync IPIs
  x86/mm: implement redundant IPI elimination for page table operations
  mm: embed TLB flush IPI check in tlb_remove_table_sync_one()

 arch/x86/include/asm/paravirt_types.h |  6 ++++++
 arch/x86/include/asm/tlb.h            | 19 ++++++++++++++++++-
 arch/x86/kernel/paravirt.c            | 10 ++++++++++
 include/asm-generic/tlb.h             | 14 ++++++++++++++
 mm/mmu_gather.c                       |  4 ++++
 5 files changed, 52 insertions(+), 1 deletion(-)

-- 
2.49.0


