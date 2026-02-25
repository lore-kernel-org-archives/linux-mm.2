Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0EBBFD375D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F225A6B0005; Wed, 25 Feb 2026 08:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFDC6B0088; Wed, 25 Feb 2026 08:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1106B008A; Wed, 25 Feb 2026 08:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C674F6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:13:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36C511C7A0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:13:32 +0000 (UTC)
X-FDA: 84483020664.27.8A21124
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 611DA16000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:13:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KRssqyWW;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772025210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCgxlgUh2Kzipr/6PqsqlcJ2dmxQyt6oZKQKS/otnAk=;
	b=JJ+1qD7Yn+6hCIkXaL4s9nyqPdqBUCg3mcOqOJeMPxykZW6I63plZ/sHI/pUtsguZcOz0d
	ZCUlvrO8YbbsaYLziHwjqq9tIZ5tHqOui7/Qc47aFSt0RgQyr+gkhH8sYC2G18wJjwT8Y4
	cSlI8wnpIbQ3q6bRVqMcJionVIimgyQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KRssqyWW;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772025210; a=rsa-sha256;
	cv=none;
	b=46jvI4DbfWwQkAA7z53hgR/fH2rx7SPegDtXJyLGHrfp8Kb4HCl3lOy9o7YH+vWoq+NDYe
	YS0HzwyzZYEyF+1pvxS7TSuulJ/dZ46RJUkMkAyPNEMDQsBkhYyyfdFFEMLg+v4jK2qmEf
	ajrSqVNaRWY3BoI2GZKXKt2zYxiFfx8=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8c70b5594f4so104568085a.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772025209; x=1772630009; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCgxlgUh2Kzipr/6PqsqlcJ2dmxQyt6oZKQKS/otnAk=;
        b=KRssqyWWtdQWFydn7rvaXqJPg4cbT0tw00u4D5QgMuFAXTBADUKnN7CiPHXpYZKzbd
         vTj+zKFJ/JK1eaNAqFEiQ+1tKrzdM4p7XifZqPu3Hgst5f9WrU7CplunSb/OnxF3BlYT
         7HmdaJ8t2OVoNRKKCQM0KPRVajDgsDdqw9ZI4BOJ0ymWiYPnKbRYyZF+nD5w/xAvh0aa
         wbg0MnDB6YLoJdliUFCkSZRychKh3MqzL3CNpdaq5n6wzn5R+r8JKJmpYC0E2+kNcxov
         jHwO8TjsHr46mJt0et7/vh7KVSbN0MkWReMtnoTTm5el19b6BKPJ9gBW90/KByCT4czl
         4hTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772025209; x=1772630009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zCgxlgUh2Kzipr/6PqsqlcJ2dmxQyt6oZKQKS/otnAk=;
        b=ElvBP6giK8fSdnIPHzGCZcjaXnCyTYg0EwaqsprvpXgry81nEOOB8sZ9aNsrA9uRb8
         sVf6sBlD02l+rrfiXPjSDhPg6ViqAYoCWZui/C2XxwlM2gVmXoGqS1AmeLfy3kmTXrhy
         jWc8n2zJqa0foZT8qWOxAivdQzvFYSeAVNBxd2eiLokcFlZuMK1Ar9TrdcZk73TdtlLO
         ZtizS8DhkTKPhRzYoJNzRCcKq/l2vivkQ4W1YXcD80S236XmWofJV3KMmKs99gViPRoR
         LkRuk3D2h4aSO5SGBwOLFXmbhGAWFPIx/Npih88T23G/IurI1DTvx2MpNNzgwMTU3YpK
         AtnQ==
X-Gm-Message-State: AOJu0YzEYHK65msyNZ1ANNCAuXVUyx6QaICBQ6TTU9QyDu2jxa4y2OVX
	8uTVRQfb/ui0jCnLgGHxfJ2ORysfkYfGxJITYZZ6DSjKeMO3hSRAI9tQ/mKllBl+
X-Gm-Gg: ATEYQzxITaLlmDBWn9kBOBTmmFfMSz4jZeQ+PtR3WTPikMPWntV4fu+GbTcBRWVTZPU
	BeHwmT0A4HXmxjrG3APRKML26nuTO9sRkK4w/scbY3UidZ5PFSkLMOzjRZcX4snGXq44d+qurg+
	iBc9PHQ2hMRPptSfJoZ5TU+F+h4WgvFvFC8bupx+bNBx6C/bw4iIdcmNqmyxKx0ZR7ERmrXMPhA
	4/oSvUHNZfsBGX95bKEEe7D4IpJhSscuuW3/Ep0vSR6/Wltdba7NL8wTleQYXYuuSHZysS7WuS/
	9yzQ3K3yQSwi/2iY44szt1B/VQX2bgQfERek7Cjlq/8rIPFFqH6x00Frqe/pGtlszDPyXtIdKNF
	D8+W530SbPgQpJi+5ZIJ/n0EesSrBxPs46s62pQDJteRd+eirCorD+NaJzmke92E2K1Unk8NFTb
	iYHWKgVWfa2UdwAGs26AmVikxhgEe0Rk2h0kcHVrS6jA==
X-Received: by 2002:a17:903:2f8c:b0:2a9:320d:285e with SMTP id d9443c01a7336-2adbde07482mr26085165ad.27.1772017488500;
        Wed, 25 Feb 2026 03:04:48 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:04:47 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 01/10] powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy
Date: Wed, 25 Feb 2026 16:34:22 +0530
Message-ID: <62dfff55a7f4f465ac1f8077cee93e6e87ebddd0.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sxabjcdshex8ri3sbib1rmgfuy9ehi3s
X-Rspam-User: 
X-Rspamd-Queue-Id: 611DA16000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1772025210-846196
X-HE-Meta: U2FsdGVkX18Ah+5S5aFLO9AlmtYgxKFmvZN5UKykCV7RmMPIQpWCuVvv6m8NaIxe3q/FUKzDSPDdawPTKuyCEFgNDmhYlmUFcitYBiIwlhTd2G9izPg5X2qu8QUQGcic6LO4Vf1wZk94Ut1cOz/NBfas6osXNEQc3UsvxN5E2d3d6Docdk46y7x7EfCn7qM5pL2q6OhKmjQ6ZtO/mBICuwE1hRyja9l8kg0+r4y0DM/vuzJDqOWxH+5ie8xJM48cePA42h1kjuMI6awYCZMb+5qXzGLEzsyOzoFMFAKCvwU7DiwoHHBD/in3aISbF38Mu7QgR5sJnhOAzLoHj8VOPn8BZoZeFJJ8HH0qWVfNL7nJ7pR+CfNdU+jR3KMD61AHxEj5Ac97jme5GlnlFHcXc3azQj9qNVr64jtv98UeOKfGxGo/zKO1FtyzH3rf4RUBXsr94/qMrcCQEDYGNGdMWDpJEZASZz74319Hdg4eMi1vd/ca49ehDoOPUY12bBcFvskniM8ptXyB/+LFlOh6Np0N+CZEDrf0X4xab6y+33UZznr3Czm9n8+YKaLYtgGoemhqQLAyuv9l/NkczmVWgNYBR2n7UMve9j+6f4R0/0nW6AzPZ/+oMwgU+AzGzfeox45VngNYTAWtuszRoDOgC3j0mfoIUFe2jJ0SRnA0T/PPuhwMm5p9U47wiR+ifeqSmvNN5u5h7rdBD+42NP7G3NtXNOxc95n6QEE18HjcUlTJyyEFb+zvEycq9JIUPGFHzcZ1UwJaj41Ovf9GZOkhA31PLoEZ2RCohq+SrVjPSoPHDyBxOTXmawiLLadMS2eE5Jzy8wOT6b/mnlFubS4ED976OufC75x1LV/131XN1zydoCAYyuB+2KoBMNH4p07UwebI1quK9IE+mCH4fY/YANTrYVk/hyQozMOe2uoeFyziwDttjzXf+Q4NieU55EXV5rQ3InpvFNnyIHb7b1+
 gGvCWTF+
 fOWuc0Ck0ia7WKJMHKro5wPYNUQLAVObm8sr2eAcE4bnhXWtpgWoFdmGvzKI4N1JIg0M5pSacAuBR/CtUMZErNFZ9/kXEYYdJhJvnT271sfIwFdZXagdZVH/ralGwJsFQvdMy4SaNPLxYsZubC4KXWGchT+EF1g61pQIWwGWqD+HewwdUbYjbC48+muvwSCbKn5PaVQ7L55uAub7/L8BxRSenrdNpGZwBLgBjWUqGydU0qfkejqWsMilVUc6lBOcUzQRZt41yctKN+6rqK9hwSdpZzJdGArNP6/Vlay4iMXnTJrJOHAOFNa//6qImF1DZbUczLVY+rfZyE2afKYZrBQylc/mABUyDY5Op3m+0KsGBNjgdE0YzP078Kx4E6zOLjnpdWTCpqxERi+Hp3zC7x+hUvZu0XcS3HGoVOYkkXr2fYiu3DQp0Q7fsYuI5bgSndf9AMHW4Lu0AsnZJreDLkkVnTdq7bfbEtzgmoNRu/LYy+FL5ykL/vTFwK6oQyox9JL3R6rTARanJU3GYoNzob8WoW9S/4cTFhD4FgZO4+GpQ7JltG0eCRmhxsEL+nXLZvd/FIdfANUv+2VokV9mGCWjksFKBwrwwFSKe0UfOZQ3+9TA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20260225110422.8UoDo5bWodwlTvwgSaVS7mqtVVnwruwwJRcnv-4T82A@z>

powerpc uses pt_frag_refcount as a reference counter for tracking it's
pte and pmd page table fragments. For PTE table, in case of Hash with
64K pagesize, we have 16 fragments of 4K size in one 64K page.

Patch series [1] "mm: free retracted page table by RCU"
added pte_free_defer() to defer the freeing of PTE tables when
retract_page_tables() is called for madvise MADV_COLLAPSE on shmem
range.
[1]: https://lore.kernel.org/all/7cd843a9-aa80-14f-5eb2-33427363c20@google.com/

pte_free_defer() sets the active flag on the corresponding fragment's
folio & calls pte_fragment_free(), which reduces the pt_frag_refcount.
When pt_frag_refcount reaches 0 (no active fragment using the folio), it
checks if the folio active flag is set, if set, it calls call_rcu to
free the folio, it the active flag is unset then it calls pte_free_now().

Now, this can lead to following problem in a corner case...

[  265.351553][  T183] BUG: Bad page state in process a.out  pfn:20d62
[  265.353555][  T183] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20d62
[  265.355457][  T183] flags: 0x3ffff800000100(active|node=0|zone=0|lastcpupid=0x7ffff)
[  265.358719][  T183] raw: 003ffff800000100 0000000000000000 5deadbeef0000122 0000000000000000
[  265.360177][  T183] raw: 0000000000000000 c0000000119caf58 00000000ffffffff 0000000000000000
[  265.361438][  T183] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[  265.362572][  T183] Modules linked in:
[  265.364622][  T183] CPU: 0 UID: 0 PID: 183 Comm: a.out Not tainted 6.18.0-rc3-00141-g1ddeaaace7ff-dirty #53 VOLUNTARY
[  265.364785][  T183] Hardware name: IBM pSeries (emulated by qemu) POWER10 (architected) 0x801200 0xf000006 of:SLOF,git-ee03ae pSeries
[  265.364908][  T183] Call Trace:
[  265.364955][  T183] [c000000011e6f7c0] [c000000001cfaa18] dump_stack_lvl+0x130/0x148 (unreliable)
[  265.365202][  T183] [c000000011e6f7f0] [c000000000794758] bad_page+0xb4/0x1c8
[  265.365384][  T183] [c000000011e6f890] [c00000000079c020] __free_frozen_pages+0x838/0xd08
[  265.365554][  T183] [c000000011e6f980] [c0000000000a70ac] pte_frag_destroy+0x298/0x310
[  265.365729][  T183] [c000000011e6fa30] [c0000000000aa764] arch_exit_mmap+0x34/0x218
[  265.365912][  T183] [c000000011e6fa80] [c000000000751698] exit_mmap+0xb8/0x820
[  265.366080][  T183] [c000000011e6fc30] [c0000000001b1258] __mmput+0x98/0x300
[  265.366244][  T183] [c000000011e6fc80] [c0000000001c81f8] do_exit+0x470/0x1508
[  265.366421][  T183] [c000000011e6fd70] [c0000000001c95e4] do_group_exit+0x88/0x148
[  265.366602][  T183] [c000000011e6fdc0] [c0000000001c96ec] pid_child_should_wake+0x0/0x178
[  265.366780][  T183] [c000000011e6fdf0] [c00000000003a270] system_call_exception+0x1b0/0x4e0
[  265.366958][  T183] [c000000011e6fe50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec

The bad page state error occurs when such a folio gets freed (with
active flag set), from do_exit() path in parallel.

... this can happen when the pte fragment was allocated from this folio,
but when all the fragments get freed, the pte_frag_refcount still had some
unused fragments. Now, if this process exits, with such folio as it's cached
pte_frag in mm->context, then during pte_frag_destroy(), we simply call
pagetable_dtor() and pagetable_free(), meaning it doesn't clear the
active flag. This, can lead to the above bug. Since we are anyway in
do_exit() path, then if the refcount is 0, then I guess it should be
ok to simply clear the folio active flag before calling pagetable_dtor()
& pagetable_free().

Fixes: 32cc0b7c9d50 ("powerpc: add pte_free_defer() for pgtables sharing page")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/pgtable-frag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/pgtable-frag.c b/arch/powerpc/mm/pgtable-frag.c
index 77e55eac16e4..ae742564a3d5 100644
--- a/arch/powerpc/mm/pgtable-frag.c
+++ b/arch/powerpc/mm/pgtable-frag.c
@@ -25,6 +25,7 @@ void pte_frag_destroy(void *pte_frag)
 	count = ((unsigned long)pte_frag & ~PAGE_MASK) >> PTE_FRAG_SIZE_SHIFT;
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (atomic_sub_and_test(PTE_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
+		folio_clear_active(ptdesc_folio(ptdesc));
 		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
-- 
2.53.0


