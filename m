Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0248EFD23D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D436B00A7; Wed, 25 Feb 2026 06:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0966B00A8; Wed, 25 Feb 2026 06:04:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CCEB6B00A9; Wed, 25 Feb 2026 06:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9D576B00A7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:04:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 613D859592
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:04:46 +0000 (UTC)
X-FDA: 84482696172.19.CBC1331
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBEF91A000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:04:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T2lCwRmE;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g5KVqfadpQstZ/7tuEPjkEGdNo2tYUxFPdG16RZ/7OI=;
	b=bc7QPj2sOnwshoD3CYbePgvACf2OiSeMcM4LYDud8YVtxeE4+jWMZnZnR9ato+GVLsiR7d
	uSrwEvIQ0kW9Ej5BlDAIzNvxosJYEBBD1zze4wrHJnzeZvSYPL3QeJGY0Rbb0D6owOlNrf
	fLVxW6buAMPbYSNue+MfJ9RLr3oH34Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017484; a=rsa-sha256;
	cv=none;
	b=xb3gAxd3alsq3dnj/+gLuA7vB8+qN7emDvMCMLnnycSq932Ddywcvanaj86ZoSfQSIMmPj
	vgjdOTTbmLbQXIbp7j3kzHFv2b8LU1LSKqWxH8jLb36UmQ0zyvFP6prXUdEjtElVkJaU37
	nqBvzfdu9Mcfqq5h2UB7yp/JjgNTn+I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T2lCwRmE;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad9f2ee29aso12454725ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017484; x=1772622284; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g5KVqfadpQstZ/7tuEPjkEGdNo2tYUxFPdG16RZ/7OI=;
        b=T2lCwRmEs9DtykQyVzBPdI8dDb1z0dsE2NRp4t+7iHEI5sDhq1CnsSHDLk56VGAdjt
         IABMBQ6QhqaJCL+gHIZYzbFW1f89j9mkGpj50c2QI16zfM6qKarxnkKD8vU7WEvK6oiS
         0sHDiyZo5w2U7ZlnE4TZaW62hBAOx++WerOfIlswHWsh9i2005/4+xZPGN6OOaCrXdYF
         7LSNjnB9lGpRB4MiDpFw7yWJS6jdb9+KQwTmPjR1ak0AafnqemNN7LJhG0XXMk/RMku3
         MHG05sr5Uu3KApi00oATO+Efylo6L227PPtDMRstz0bEZF7dR+hmQKT6mThq0G1sHz0c
         bpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017484; x=1772622284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5KVqfadpQstZ/7tuEPjkEGdNo2tYUxFPdG16RZ/7OI=;
        b=Uu8FWO57lCayd5kQX0tchQpSLt4pHNj9Sye8i+1iMYS4+R84VtoDLA2a5bJmHdH0C6
         2W7uJX0bUbb7BIug6NBc4aIeKehrunfdk6GIAQX1C3VHPoOniuIr0oSIsWxhhSMB+uEH
         LoCCrLatpAUIzDod1kUaM016/i3hJXgjea0gLeHdyJUmFgUl//XIB0Jq740tIWgLDeYR
         Ky6me605caLj4rOCnHIHeO8ZgptpUEjnk0G6RjMFYNbictuQ1cLKXDGS0W519W4Np5hx
         XhHSJi0j9I86FhL3AOvDrfud9nWhXaSAHHQIWl3wT1V67HUhXt4eC3Bx1+CkywrKH0WD
         JUag==
X-Gm-Message-State: AOJu0YxDFazpT7m1+feIm9v+oxODUMhZPHCbwioHGzB+5OKWl8NQxssB
	+TLA2LLjVHgPti+WW/Pzn6VtVFCXyKchPVceqkvyVa4vBVtFo3+Pm6mm
X-Gm-Gg: ATEYQzy9+ouGbwlzT1SZW+nrsWzwkcXhXShMGxIUtsEGPvmLfHZg3it04qW6np+WLE8
	rKcUQ2dBgnRV32eM+IaUd+bfS7Ac4XtlJit+8fVTWVkXBDfGucscX7AAAvzDx1tfFJwmnyFzoLk
	Ur1NbacvBShxqmPuseyU3CjxwxoyTV0P9D78gku7aaP3ZKfFbhwPUEmiW9asC/n2ogpv8OFTy4+
	ulOfvPbnK+qmShus4PHFrAuqUePmpUcBK+z2HMx2MXuJNSlTK7VtxvaFXorvZxmNUP4M/DOPxe1
	U9MHrLzkK/FP3fh89835JDuVpdkHLG7QsMwgXChujy/CLw0B4/YRtkXJkWs2vb4hzgkl9bukDxl
	cHUHtkv0MmXeIjf5zf9eJCh8tqgcGYErPwRPs8qI1oE9/G7chaQJfsh553ViO0IzPb7WteZmfCv
	MvuVScnn256ieK83CbO+zcYLOQop1SboU=
X-Received: by 2002:a17:903:3885:b0:2aa:daf7:84f6 with SMTP id d9443c01a7336-2ad74597df5mr135442095ad.55.1772017483592;
        Wed, 25 Feb 2026 03:04:43 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:04:42 -0800 (PST)
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
Subject: [RFC v1 00/10] Misc powerpc fixes and refactoring
Date: Wed, 25 Feb 2026 16:34:21 +0530
Message-ID: <cover.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: wmmwyjtqonpi6agzj1x9zzfmdfdt7zws
X-Rspamd-Queue-Id: CBEF91A000C
X-Rspam-User: 
X-HE-Tag: 1772017484-141022
X-HE-Meta: U2FsdGVkX1/oO9sXfLW3z+Cg1A/S04PjWXIEpBMX7yGryvmuMWZJbmOWdY08z0W2h0jo0R2Tu3hxADP9fyMUcTEAvadH7i5qbzmTE5lQiqbxYj8vfjSjKj9tAoce12Wom/DngIaubitl8feX4R5Z/9+bctbGYliRtUy52ncL5DJ4co0GOXvMIkqhZzuE/lM6lRUk8Am6w/K6CL7FxQmkeSxVoMB04x6l1Wtxd+gBWeKZtnaHfi8I2jgwdN6xldx+lHroV62VHZYQUM7u1sIDZIQI103hK7GG1ny52+Y4HDsM8tPsU4bSSuCZ92PHjlT8JCU+gI/XselTXGGS+GzJr9mvLuAAZTk9PVBRUJPit7dQX+/ghG6/LiPrXARJ7KpS7PCCgqcuqwrawNC0+uH5JJKW9Bbs1Z5qM+NtD4eCPV1tYiQX2PtMaj5XiVxkCb/w4t3XveSrXZt1h0F5wUSMjLlidLfaFqeP8sV40PVGM05JKiiKGOsXP7i5L4G/gXA/7obw9gkwxb7syDiRHAhtki4EVfPnh/NE91vM1TA7WFgUpvagU8G+iNc2vpLVs2/GdknwGvk7f1J8hz4Czs0kG6ab/jG6Hfv5BpfG5zB5Ieza4/81N8N4WAWGQXPs3VJpkmbEWBmxDQ1SP5gdkJ/Yd59fefX6apv8L0LuEpxl4DOAxcsLFlj+fyQoc5Ao7e4g3SXZVM0ISCqSCctW0hEhFtEchtxrr5AN7UBQt1HRsxxykSeLYJzL8BvL0d3xdE9imgzFv6+TZ0AOMtlzhdd78Q8BLsRrmxC7czPPOy5UWtqTRzIEwPDYeJsOnh5QJWvTwen7QntdxG0MY3pskECJaZUTQqnQFzIvkTlemUdRCcnCmWDUqM8IHdNOdvy5eNfwQIN4hcqrXXlOnoQ8+Kz5BSxQaE95eeiG9UwUZALB8lETRpBwKUWRtiT6I/CajGoBO2b78tMZoPnE8/L/wRQ
 1b0xLt7a
 KD1CeFEY0lWI9iRRmsgDzMoD5j4ikQ4XD2J29UAtEiIpD1EKlgP7tlgj+er3kUW5UCWQhRjkIhXGXGpyASWPiUQVgCDxQ6RKLqAbS4/O79VeD37G5i5I0/R32M3Rz2cRMKLqkFtWGsmtd3Bh86KQzQPkEiYiWPIs3md4D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello All,

- Patches 1 & 2, are fixes found during reviews and while running mm selftests.
- Patch-3 adds a way to verify / test this race using debug_vm_pgtable.c
- Patches 4-10 are various cleanups and refactoring, that I have been carrying in
  my tree. I felt it's time to push it, if those changes seems logical to others too.

Please review and share your thoughts!

-ritesh


Ritesh Harjani (IBM) (10):
  powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy
  powerpc: book3s64: Fix unmap race with PMD THP migration entry
  mm/debug_vm_pgtable.c: Add test to zap THP migration entry
  powerpc/64s/tlbflush-radix: Remove unused radix__flush_tlb_pwc()
  powerpc/64s: Move serialize_against_pte_lookup() to hash_pgtable.c
  powerpc/64s: Kill the unused argument of exit_lazy_flush_tlb
  powerpc: book3s64: Rename tlbie_va_lpid to tlbie_va_pid_lpid
  powerpc: book3s64: Rename tlbie_lpid_va to tlbie_va_lpid
  powerpc: book3s64: Make use of H_RPTI_TYPE_ALL macro
  powerpc: Add MMU_FTRS_POSSIBLE & MMU_FTRS_ALWAYS

 arch/powerpc/include/asm/book3s/64/pgtable.h  |  1 -
 .../include/asm/book3s/64/tlbflush-radix.h    |  1 -
 arch/powerpc/kernel/setup-common.c            |  4 ++
 arch/powerpc/mm/book3s64/hash_pgtable.c       | 21 +++++++
 arch/powerpc/mm/book3s64/internal.h           |  2 -
 arch/powerpc/mm/book3s64/pgtable.c            | 46 ++++++--------
 arch/powerpc/mm/book3s64/radix_tlb.c          | 61 ++++++++-----------
 arch/powerpc/mm/pgtable-frag.c                |  1 +
 mm/debug_vm_pgtable.c                         | 38 ++++++++++++
 9 files changed, 108 insertions(+), 67 deletions(-)

--
2.53.0


