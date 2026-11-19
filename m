Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DCC606A336
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bTHnkgR/
Received: by kanga.kvack.org (Postfix)
	id 2C1076B05EE; Thu, 19 Nov 2026 13:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299046B0647; Thu, 19 Nov 2026 13:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEAE6B069B; Thu, 19 Nov 2026 13:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E46DA6B05EE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:00:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B0F01C468C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:00:23 +0000 (UTC)
X-FDA: 85452633126.22.F468C34
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id C268FC0032
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:00:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="bTHnkgR/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795111221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zRbJF3eDTIyI8Y0KUyM7gJOV7t0l7GOD9RUKADgxt4c=;
	b=hYIWmsMCcB0Y9nbAuVQLZ/3O08ZLzcAHJMCGCP3QLWoIe6TQ4viyfwaQXcthLNPi4ywfUa
	WxyG8CRQT/y+RIWk0XQpZ4FRP8h6sc/9a/+hNqjW6bMDaI8TktEkkAUcOH5015MmXHcAAB
	KpiX/ROUrnnZrGu1dcwK7JKndu9R8/U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="bTHnkgR/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795111221;
	b=DkoEcQkUe83XrFaRmpaCGcLLDisjAs/zJwEscfvbnhCp9z+H9VhAlKiV+EO1NzsUo34ia5
	ilAfQJy2Y3mFs5CIkXtKg8KJb13tquLUc/Mo49atgGySIwjUDl6P2aRVbH4Z0LLZ+jLFor
	SkB1Zv2JZPX7JR35ppgW1z+QEhBv5h4=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e09aa5264so1527898f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795111220; x=1795716020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zRbJF3eDTIyI8Y0KUyM7gJOV7t0l7GOD9RUKADgxt4c=;
        b=bTHnkgR/KzdLS5AzeszGkSW3r5otS0EY3afoOxelUo3nvgusn8E1wb20oCmQzhAQGI
         ZG9UQv0fnVlgafZqyp3vrJJDx4YNvSxpJ7qdMJbSwuNSfI/Pil/WFQ9vrCDLaMUEoarA
         jxxybNz+URP7p3jifGdMoUqFQELZbtKKawrgo1pOGeOZwfe+t8iHg8DjRxyjkQifh6wt
         6bHkazEaRgOFP8ix1+/QG+PUEVVJrlzO8S5L/0CqYook0+IJEzqSdqu2Q/0rR6vbHGUz
         pk2qV8REgFJJRgDR9Zg+W8kOsdufagSM2HPtqdmJd4SreT5K0X2B0CPrK0MxFfoIczjy
         FoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795111220; x=1795716020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zRbJF3eDTIyI8Y0KUyM7gJOV7t0l7GOD9RUKADgxt4c=;
        b=V6St51UgTW3CsukeogMef/28w+UGDNjEPCktwAAYWPp2FtmNBOntYMmaXa7+SsNnCm
         vN9enoavb32GAdMsrUMf8Dxxf39cq7tD/aVjs83qlwQVGriW7gvnDHlddjQdFa6+2XH0
         CNk5o9RwDwc0xjpolMhg5QPfCg8tYzhhnmZW9tpcBicSPtvJnyF5AZxcpfl9gvAjizB2
         k1n2nhr2YG0+gMCg6fej6kZso/JAoQIP8O9M1FVWmqh22daTx2epoSxoVs5jRh+bejNt
         BUePsm7psFM/RZlduY93WlcJSFxLtvT5jKWfOEWZfqZyGG99kEno/H4PG+hlo7zNq/a/
         5Z4Q==
X-Forwarded-Encrypted: i=1; AL+hErEDZUP+APY/nR6llClM6hY3ig2JcSQefbviscW7YmfKjljFoL3l/LqnOM3RtmXYzUAzJo0lq06ROQ==@kvack.org
X-Gm-Message-State: APuU4Z+mOcbueZugOm3WFC3t34264S5t0w5PyiimJcfsOhBVKFZh/Ity
	W4yZqY208xP3VsFnsj90VA4wXGPnE7GPBvXM2Q+iTlsNV5ees31RY67a
X-Gm-Gg: AZFdTZe//n2z5BmzJiOcf46RXuylNxpZTYlo1lrqFNicoUs23oCH9cccEWPnKOEcInd
	COQNyt17zdX2FFm+ns6xA4m6OLnvwtGPD8nEL/Os/61t2b9pC4GrSh3PdvhyFa3TMtONtokQvYS
	InHjEvk3l84V++wZE9uFjD/zKX/KvudqpCbBkvXO3JKRebTPQS1DtfhlPIUZV5nuWtDb31CKB6v
	Ljl2KQe9SR5a3JSu7+93YOMfSoclMzFxzomSejqMss6NocULqhHvcKmIXzrZHOiAUQTRTL4miLV
	ojW/7o0LAaXQ/F6mqjHYWUQ2KF7A6QzEzXf//ztEnunXa8c8EYctIZ8EwZ7+N+ujg7QE1i3D9je
	h6UFrTk+p4/7Gy5e3wKpzXCQbu15+aLJIYChi1Hwl2i8IClWQ0vfg7TTmR25g50UWHXVTtRCyas
	2yG1J0x+tcC6/IUuErfmvE2JXIeXAu2drEuvT9dYLyF2TdmMwoB5Xeckrehec9WFOsbyHk19p/F
	fcY27cHM07yd696iEHWN0Id+B/jo+6TbB/1tPcBkeWD2uCz0Yr/bnBw/1w2HGGPgsAMLqebACdW
	nMLZc7sLhWoWMpI/Ma81LlX3ivovI9YlwlSb3x5YRCP9kw==
X-Received: by 2002:a5d:64c9:0:b0:488:88ec:59c3 with SMTP id ffacd0b85a97d-4abb0f3c071mr274803f8f.14.1795111220019;
        Thu, 19 Nov 2026 10:00:20 -0800 (PST)
Received: from localhost.localdomain ([2a06:c701:477f:ff00:daf2:6bb3:8bd9:8ae7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf61e8sm900334f8f.11.2026.11.19.10.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 10:00:19 -0800 (PST)
From: Avi Weiss <thnkslprpt@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	rppt@kernel.org,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] mm: skip temporary folio allocation for anonymous UFFD missing faults
Date: Thu, 19 Nov 2026 20:00:15 +0200
Message-ID: <20261119180015.933433-1-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1mammzcfd3f7nz16stu8ikcfdmkbd1jq
X-Rspamd-Queue-Id: C268FC0032
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795111221-426825
X-HE-Meta: U2FsdGVkX1/5TG+vVTBbFzBMWo3AmXCPzlmGV/koqnvJk+PzKxte/JVi/k3T6AIpT9rgFP3inBufdvUcTCmRG4bmyEEo053mLqseoYPQHUZ4w/UOr5SrlEmn72XFO0zPdNO+DaKOB1uD9Y822z3AyKdoiBog3hyY57tNZdR7aNKaJszGaGF1lby4FuoLIzbZ94ELCkMoiOye45uo0FoGHzIoEP8DrtLsVzpHtWBu4tRSE/TDXyWpwwJ3iAQlNKTguSAcW+r40Pg5Ld7myAto3JU3MVyTDZbG943zFXDLQDYaMAIYQLcehTAU2pMHixAB15ufHqFK0JJ52wFRyWp5h4uHJVQ/jqVdyiAu4Pdr6l0XTSk6BzDOnVBMmADYnW3i4drG6a9gZ+ymRjeLkKLiOczJ+SpFSNd5XLAXQOliEDrt5VuddYgFcsU1+J8ulMvn4MLbMW19G1C6TEVbuZKZ4tr5aUT+cJUoNNwT90z69Nv98EH45qQo5Tb4zW1ur1QbH73o0h+jyeEIb/rHr0jWM5J1hRy6CfDemoG/4SYoVxycvxRyQpcZ4IiSSWw1hMJMh8cpDiplqt2uEnC1MJ1OX2O+VgGdYos8NuhjF8rQ0PZdRQH/VL4Lz5k3RYjUn7Qh2Dg655ZJIAs/a0bJg8aEwKGAKP/DPGl3zUqr6j3fNsKkgbfZ16szZuVpbziLd/D/ZRaiqqd6ib6iYSB5CT4XG8IGo9Q3+LuvnLAvRFjooUGnfmdJE6vZZQv7sBpE3foXmMBC+YQ7cFThpvU6GSA8fnCqktEPkAzxzX9vAnRYeBED1Bla2sVlExLFelO/Gvoy4rDLFNi1ayb+jlcdibTJR8WViQk3p5z0UPmBEwH9DDYbyaIZkGUA7lZQ+1BVZWV0Mcpd8fdBuzbi80IHVE2c7+f5U6puy6syAnIpkWMiC+AyIMYl4icetBjUWLybUxl0qzDe1Q4wxoYSy6Jwidk
 WS9GkKPB
 mM8VmPKbZnpYq1zNAiHvc500WZssflc/C61O0C50/N8nSTw/oNs8e1umK4/UOakeMZt9xGqRH/PXtz+XBnQ4tUIgL4RRNkbPEE4iRhn16pljL669/PW9eJK2KJTcOsiv8ku3Z+JpGF6VSX3Nb58SCx3RQ8lZFcvnOPl6oNb4PAlNB663xGfiDlF1Lh+FejdJx2SVyri0oUdKouUg5/Dh/bh3pmEfyBwliY46aitV4sygPnfWgQ/luXnUEPdetnUZO3AcK/y0LRQJDKqyfGMBBE4ezN0+OIgSsNVxzmz4znErYuUw1Ov4j1Czc38LSp6pNV1q83tBIAeyP72auiilYoq0Q1/vkwhJaG1kUUAceMQCwhvrKLHmR3LPKIewgWb2KmQ67lm28GVICFLPfhgvnYcYUwlXZdehVjjWPQtAEr0zxON0pqO+Z2NeYgsZOppm82WOd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An anonymous write fault on a VMA registered for missing userfaultfd
faults currently allocates, zeroes and memcg-charges a folio before
checking the PTE and handing the fault to userspace. The folio is then
immediately discarded without ever being mapped.

Check the PTE and address-space stability under the PTE lock before
allocating a folio when missing faults are registered. Deliver the fault
to userfaultfd without allocating and discarding a temporary folio.

In a four-boot native B/P/B/P comparison, the mean UFFD fault median
fell from 13,997.75 ns to 13,093.55 ns (-904.2 ns, -6.46%). A guest
allocation trace saw 256 fewer allocations in the faulting task for
256 registered missing faults.

Note: this changes OOM ordering. In a fixed 18 MiB memcg test, the
baseline OOM-killed only the faulting client before delivering a UFFD
event. With this change, the event reached an unprotected shared handler,
and its UFFDIO_COPY allocation could trigger an additional OOM kill of the
handler. A separate surviving client consequently lost its handler and
failed a page-content check after the UFFD registration was released.
The same handler-death mechanism was reproducible on the unmodified
(mainline) kernel when memory pressure was imposed after event delivery
but before UFFDIO_COPY, although the fixed-limit outcomes differed.

Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 mm/memory.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0fb676d..63b39fa 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5547,6 +5547,22 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
+
+	if (unlikely(userfaultfd_missing(vma))) {
+		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+				vmf->address, &vmf->ptl);
+		if (!vmf->pte)
+			goto unlock;
+		if (vmf_pte_changed(vmf)) {
+			update_mmu_tlb(vma, vmf->address, vmf->pte);
+			goto unlock;
+		}
+		ret = check_stable_address_space(vma->vm_mm);
+		if (ret)
+			goto unlock;
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return handle_userfault(vmf, VM_UFFD_MISSING);
+	}
 	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
 	folio = alloc_anon_folio(vmf);
 	if (IS_ERR(folio))
@@ -5579,12 +5595,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	if (ret)
 		goto release;
 
-	/* Deliver the page fault to userland, check inside PT lock */
-	if (userfaultfd_missing(vma)) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		folio_put(folio);
-		return handle_userfault(vmf, VM_UFFD_MISSING);
-	}
 	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
 			      vmf_orig_pte_uffd_wp(vmf));
 unlock:
-- 
2.43.0


