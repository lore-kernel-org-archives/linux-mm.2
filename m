Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3EA606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fWxAGdzY
Received: by kanga.kvack.org (Postfix)
	id 0275D6B05BA; Mon, 26 Oct 2026 23:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F414A6B05BB; Mon, 26 Oct 2026 23:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E575B6B05BC; Mon, 26 Oct 2026 23:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C05C96B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B74191A08C8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:23:10 +0000 (UTC)
X-FDA: 85366960140.15.7DBCCE6
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id D5ECA40006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:23:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fWxAGdzY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793071388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4O96wME59YozreVoXYue1ZzVmrJOWE9hKphAow+pyRk=;
	b=kvTfqEVmzGwPuh71+AGQZMl1vc619g+s1N5lsv4j7lfoBwNZIdg7EfDlUKy7nChdAnZlzs
	Ws/PxuRU/TTppCB8h6Ux5UahvCbx8F+gT2FMfQROKXgZxccCKwmIJDyLu06QepNZ+/fPxV
	57sXhW4LYawjlxtQlYdIxg2VW3pwViA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fWxAGdzY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793071388;
	b=gGHEmScHevkYFnWwsewkLnN5D3Inr9NX0Sp3RUC4mlPxiSYaUJnS+FT86NyFRcTh9DLnXm
	lqui0h84tNNWbi41+dV7T6M6E5kKmdmY8SqPvXG00jdFkKoj9V1BgDJQPz/bfvu43fSpFt
	EYT+JbeX4NqGsyBvfoTIdh3GQCVViMM=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso5962520eec.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793071388; x=1793676188; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4O96wME59YozreVoXYue1ZzVmrJOWE9hKphAow+pyRk=;
        b=fWxAGdzY9Ktgx0KnQDoSW9CSBH+o9LjKajOUIR5xkCDz1yBko4yL+ekxn0DPavHHmn
         FgzYmNSL2XZe8m1vP3489W9tOL9rDcvZS6jpAlO7ic+e1d0n17YCf2Z+/g9cTCR9g3WR
         F84/5ZA6Vs2lJoW/HV8yHx2cuGy3ekJxatw27paNE/p9xxlNBEx9Mehb8UKNuDN5EmGE
         eK1tSMT9LqWmCFkrdfa90JFbEmVwHu07RA1Z5Z9DhWddiAaWMgDXej2x/RjLd/AWdpws
         KpG9TpU/J4bDCjHJoZTKT4NzlFYorttv5A/vRVBQo89ZWxYmLT+0MccmwvRhFXYZC7qY
         WM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793071388; x=1793676188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4O96wME59YozreVoXYue1ZzVmrJOWE9hKphAow+pyRk=;
        b=v+0O7RntRQ7U7lN198/kisorVs/cyRTT7bRJBtYngNseR5N0K6oUq/xbQda5MNTF/1
         dW9/+ZktVrQo5++fISFUc6kQkIjn8JMbZVqgeJUn7RFsrqLgVS4Jx643Q1OtMsDw9l5V
         foEjkcWo7E/UQ1MAfOP/ofZZ34M318rf47uMdUjYw4gKbxNcPPdWZDaX0euvNIuHw8S1
         4BqUxGHmgCEGYHJEijghMo9mlpv+tVa8RgeD8sFF/CkitvdoFgETedGFdvxaSCD8T1Ww
         nqw8u0D/rIUwiRXm6LG/MNSpAUnsoJBWKvoP+r3bWh326P5KbbVDfArI3MwvXMZ1IdND
         QSOA==
X-Gm-Message-State: AFq9FYJuJEcNTciXOz3XIqhQIf0zyfSm6Fr1Xb2aBu3J1d5gaex52CyU
	ziUL6V93sE1XQ2VK/MYJzPjU0VqiQd2SYBQdNYZkyX5pKsK0FKVMNfwYMzT7Nw==
X-Gm-Gg: AYBFou3wAw6P2h7aoMupqZdpRcHpI1lGB80IyVe4NO40OBcx569CP7HB0TKUtZ0eQqD
	nq/02mT22Zo3xGo6B70Q9FHcrPlvBtWOtztH2mjApDcvbIvta8qhOSrzEwx4JGEGfpzbNKRfEu2
	OgEdP8vtWM3Bw9rt5HQQOH8hySBX4p8R6L6qO/CxxUuP0qEDjBlk+Yo/FnHPTx/UQXHKCjbc+2f
	ghMZCtijEzG7+nHGp3m/73xDGxrwOAH2DJ/hFEajxvY/YJAmhIpTwwI731qLAjSvkgsKAt+R0FF
	mFpUmfopmJSoOku1g8G4LZaPGkLvXDq+C2B9IjruFL5ITN4zEIw4mFA1YzGviExwdSPg9UwcwJe
	8Y2WXmNqCkxU5abk6v3Ez27yyhvV/WRbLeJzypz67/1l06wc2PjOLH8tOB/5dfIekVjhGHU9Cl5
	Nz6sGpQykmM9rquTuYMPpLxSeF4JoxGKsuzdYemNMxwpNpWb7B2sjkHltGzlfDcU5AVkonhUA9d
	tmUqzmPMKSpNDJqXIZ1Ritsqei9OFqnweYHf0/D9jKAxPJHbwIrgI/WR6B6
X-Received: by 2002:a05:7301:f09:b0:35f:b0f:d15c with SMTP id 5a478bee46e88-369e867f95emr11035597eec.39.1793071387520;
        Mon, 26 Oct 2026 20:23:07 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ec9276sm49373826eec.25.2026.10.26.20.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:23:06 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Pavithra <pavrampu@linux.ibm.com>
Subject: [PATCH 2/2] mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
Date: Tue, 27 Oct 2026 08:52:49 +0530
Message-Id: <c872f6fdbabe92c1171f3b25448e15247ec34a21.1793070429.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com>
References: <97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5ECA40006
X-Stat-Signature: fnp1yo18ybaieaohjx6xyyfqnrary5te
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793071388-734556
X-HE-Meta: U2FsdGVkX18EAAAdKFqfCUWLdLc4zlHnGqVzDVCcKR4MrIVGtXxSS9Vbk6wEIXoijC3e1wwrWbDqxLE03XQe6TTj4TiLMvzQ+XS/KJnFzujQpjKqPLYaooxHmZ78UCAwYRZLEnHrlNwiYOkwRTcJiL9cww0qs2T/+2pbTei2fF7oNQFjnMmAjPixskKXkkP+t7oLExcQEMwxqjuVhIAFSfX9/ab8zVNSJlSUSu1U7C2FufSc7GesHWy92YQ2OuFqmKXiQj4cK9I2CDnHWwKYLPkp+8aYqMtsNk/aFAcKRumahfhi1LvtfyE632PNLafRUA92UUZunsnNZCdBxARvDlzSLJxVIeXPfgp93o1x1xW/j3I8ldomHbQ/wEIV4CSOJ4Vv/K0EDiAmdZ2xYs+6Q7KQNaXomP9QXL4kWXrwOyMdt/2XqTOyVpwpqOX4Ngf6RUk1Kb+jpLdncLI0+RXQF8BXw8rphtfNItjabsCuNMACUXWxbXLwWkPhtGoatp1zDWX3rS4GCwn3Maee6dKRVttTRDoXIPUuAiY+8zNZ0+M+Lk8FtUpLPcqyHl7qagt8uDbNBqq7ZqeHco+mG8/PCy08NCeAoV/BisJDQ3nKJ/koa1Xk6/025ITQerio/tDx8sM584Qx3YMU1F1g7fENEg/KKqVE+YfynC8H4tGJv+LxkMzorhdz3rrww6D2WxWgCWRJkMbufIvN5pX+vMWmrlTDfxw6E+SKRUwxFIhamgSxdC1Cbl7lBlNRfSEX2f8cLADtiEGQ8afw0CVARtCA/DonAepTxRLL1NqVIVbYfGFV8MbUyC9syOPFfTaoHzaHoyy0LFuqTqKtrGp0D8qMDunIgWORBX+mZk6y4IuotcykUOGBO+rONuhxBKGDtwK5MBdix0mM7sSBUp+xG7Jt/CwwY+1APtgz8KVjsTZUN/7CHsglmXRJBVfekeBRBzeM5viXI02KPAtn7bgCAaC
 Cj+4VBj3
 v3QsgoC5Icd+H8WX28T+HxsXM5VCGsoGkpKivtuKlPrT2VXuAIUriT2cyoHZzGykYtwTtU4UlJVKT1bTJsPZ87+kbjUJ9QNSHxgkuKmtWHIjcLbP0Ln2MB0fT8bkKTmn4akuKvkg+4ua+ekXwfwjIV5pSkyyFjOZzo4e5qGgoCAn/IZpzV3hLpSj0KVQKcEcdW9g8epiOHOjXhDAtZiXqZtetDkBa2InD6XOUqWCB8dlr0j93i4mjYDXvVA7wk6GG/YdTCt57qr5WozCvji1L9xTfJ9r+dmupxgJY8t5drrVaGnEyU2f6rtFhOEW/C6hfKoJcL/H3olf1gmTszUpiQx3d3KWmdMDkh/0V34Mijl1JFd6GD5giYz4AN2EW7tN+2ATpo45Qcd0pEqxB9aj4qBp+tscSUx1Qqfjjs6RwNu/2anHCsn+t6WWYjFNSSrVOAv/MICGJ2eYzkvvqQQhqLuetzQvKHm+JpcUXsOtHgSkiB9l+Q/gOsf5NLtl49NDwvN7e9gBKC5fbtjvG/Wfi8oTyNleDO6j9f3EzBGxWP5yakKv1s94hkLUmIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unmapping a device-dax mapping with 1G alignment on powerpc radix kernel
built with CONFIG_DEBUG_VM triggers this warning on every munmap:

    WARNING: mm/mmu_gather.c:176 at __tlb_remove_folio_pages_size+0x38/0x230
    NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
    LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
    Call Trace:
     zap_huge_pud+0x170/0x2d0 (unreliable)
     __zap_vma_range+0x1604/0x1e20
     unmap_vmas+0xa0/0x1f0
     unmap_region+0xb0/0x130
     vms_complete_munmap_vmas+0x120/0x310
     do_vmi_align_munmap+0x1ec/0x240
     __vm_munmap+0x148/0x220
     sys_munmap+0x28/0x40

To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
byte so that the whole 1G is mapped by a single PUD and then munmap()
it.

PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
the page size for which tlb flush is needed. zap_huge_pmd(),
zap_pte_range(), change_huge_pud() etc all do this already. However,
since commit:
  dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")

a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
tlb->page_size is still whatever the previous user left behind, which is
0 for the fresh gather set up by munmap() and so the check fires.

Fix this in the same way like how other similar paths does.

Fixes: dbe54153296d0 ("mm/huge_memory: add vmf_insert_folio_pud()")
Reported-by: Pavithra <pavrampu@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..7e589a2fb02d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3040,6 +3040,8 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pud_t orig_pud;

+	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
+
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
--
2.39.5


