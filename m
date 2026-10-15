Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CCA0CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC646B0095; Thu, 15 Oct 2026 10:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D5E6B0096; Thu, 15 Oct 2026 10:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D876B0098; Thu, 15 Oct 2026 10:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E58606B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:45:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 709CA140A0F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:45:50 +0000 (UTC)
X-FDA: 85325134860.06.E13E1C0
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 275E4180010
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:45:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=JGbS2GWo;
	spf=pass (imf06.hostedemail.com: domain of "prvs=741bae1ce=fparola@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=741bae1ce=fparola@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mno5u7ZzRZU/+mTenUA2QzGfL90+kMbsdzEVFvrdQKc=;
	b=RtG1nRiRQxsCClB0Q1CMVt61OLfe5hRRTs0AEMptRtkZ5Rf5aIm6q2m7RY/8Nl85f1PhIr
	CxB0Jea93+sBukbN8Dl1TPu35oWuqgnrWSIBrjQHof+ZcBSqBK4d/RdlHXfiO3YGsE5Qwu
	ey48KTdOtAezrVQkx3H1GDO5DDl2MJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075548;
	b=usx/bkleZa6WrRB6OsCaEjYcYBggNAD4ImpGIExuJXW597wrsMDaJJjUibvhXkt94GSDkU
	SBqPNytNCSFb34OteHFH9dmV8tDlu46TUIvKb7dTAIcU05J6ASnee99JdvsVxgJ00AUwGc
	In9NH1Be9pnAEsfy5LCZBv24RxKVtLs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=JGbS2GWo;
	spf=pass (imf06.hostedemail.com: domain of "prvs=741bae1ce=fparola@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=741bae1ce=fparola@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1792075548; x=1823611548;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mno5u7ZzRZU/+mTenUA2QzGfL90+kMbsdzEVFvrdQKc=;
  b=JGbS2GWobKX7ZhiFoS6otIFHbm1EPu70HsDD19AuQRL686E5IAlRS/Zh
   DnkgX90/iGG8ssJkas1G4UxfKirY+Woye2AkHW1x37N/D+5GrXSQmS08Z
   RxH4DutpxDuE2yOXCk8hGQuwBp12Iiyx+1HHIxDQEYLkQwVLmNUAAieCo
   EpV6/gb2UYH5uMCCcji8VcMFEZYAIDNeispeE/OehR6AhwF6y6xZaHKSF
   keiTdNLg5wHWdWCV40nDqFmDOvDCzGchiSTigmnUvfrlMeQA8t7p4xIUH
   6etqTK1XG+qtEVAJ2PkLd6E08VpU+4sUJSG6h4gWu+1X5msR6e7TXi1Ew
   A==;
X-CSE-ConnectionGUID: TQuNEdILSB+qoRk8DsfdOg==
X-CSE-MsgGUID: AMc/D2JPQk2nJkK7XniR7A==
X-IronPort-AV: E=Sophos;i="6.27,160,1787011200"; 
   d="scan'208";a="31325232"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 14:45:43 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:25214]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.1:2525] with esmtp (Farcaster)
 id 42897119-f455-4005-98a6-06b7136192d6; Thu, 15 Oct 2026 14:45:43 +0000 (UTC)
X-Farcaster-Flow-ID: 42897119-f455-4005-98a6-06b7136192d6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 15 Oct 2026 14:45:43 +0000
Received: from dev-dsk-fparola-1b-85ea2014.eu-west-1.amazon.com
 (10.13.236.104) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Thu, 15 Oct 2026
 14:45:41 +0000
From: Federico Parola <fparola@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH 6.18.y 0/2] kho: free buddy-allocated metadata with free_page()
Date: Thu, 15 Oct 2026 14:45:27 +0000
Message-ID: <20261015144529.76911-1-fparola@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.236.104]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 275E4180010
X-Rspam-User: 
X-Stat-Signature: 5hfjuqo51yws5mzfu8895xp1qumkoqru
X-HE-Tag: 1792075547-154630
X-HE-Meta: U2FsdGVkX18StqMc7sVpT3VRyvfAAIo1G837ugEw2W6ntCnKpsQ08xoniXjSE97kGsG9moj5KfzQmFQc9sX29xhbQM7MGO4v/Yq5238ZShzU2jDTKOzc1nAdp3vwtpE6MspcE8uKrWfhdsbKEsUPM/yaVGdUl+J2pqut+dABGx6b5diAquJnQ8fE0INEHm+yZLBLVIdTKJgXUgqC+13jEROJKa/KrGNuTQU4OWpFUdbdXDfS+JYcC/d8aWE7HVPCftL5gi8PmA0LUbqtYnELF3+tuYepVtvTXYoX1/OF7WXteda5gL3oPX7UeY6yt1YBOoSy/3xrCa6608eCb46pLvv1+ElpdtrleYLIV8Y1HX3CCVJLNbxX9RUCrB0JBeEI8KGYImNtGLTinQQMWWLWpeb1v7V/GSEa3wPYFmLNzwz/e/SKsxKc/UdOVlP/ZgRTZ4tDUyYzEovschpg/bpd96wJ4IQK7Pps6trclEitPTT05nuhlF12cOlmR+9lGN2cBQTSNqSpauLCgHgPNlfPlpm6DxkqK0vkBkkfhhYKCgcz5jfV0aOMsCAlCP82HkqxgHZ9WoMILg3bhg+0ntnNVSuhXKNZNyCnwV7jnPbhTTWv9x8vMEe37GsI4xfysQMfNg4Ezp0ObFM14mGvkbrHtlxQYzQmV3uILlPjSRhwFBW1KpKMcTOYLFz5/CeqzZLOzgBYV4xOPcXphCtf9mjpf3cBTTv+GLSJT3m4wp3wZjmJItswVkZ03Z8/UpaSmwoqEftqQloiFNA3zGanEA+G/NuvhbvNUFk5RQYhQhmD7uj7ZjDcataPL6kn2htVgpjwET0cySs+xMuqurBXMQe3yhzphWQZTG1vNhOzR6EO0IQ1rSiOd7o73GkZbRdAPNUXhnmjvTeOu0RlYp1VABMlE4OWOyitwaeVc61HySVu1c7bJ0blJzfTp0mesbym7lx1kwCilhKCXxrq88LAqj5
 nGWnn4nh
 CG/RYaPkJ7VuLBLFMy3+RA+FoTY8zkb9S2T/fTxRRX1oH4T6QJQMEz6bImlMUTJkZmnBXP3+fayCgI8Ix7vRqxlTCCSsV6uY3qZrpkti+kE8dHSVJWbu0Tdx8Qm/9oSBxio1qJmVrbIS8u+vUCEdpjqSQY2slRh9K84RcJXriSD4JJqvyJkXPReWdMtKFbKkNSZ3z5HahCKF1H2XCZT3YqFYLqdO6uc52QmGaltFJxUT0nwS3I0azxHk8jDvW5BJ9fdELh2i0nj9YvDoOZEX6Yit5reTiegKtKjqLw0K8ovJxmklup9J24sdVz+fBkQ/rlftUHqzaj6/94Op8b2zr0E4qrUllCsMFdjXSvTjvbKbL8uF2mMeUkO14vpav8dGuLqQ6j3iWRMuHhBUwdZteAb6e/vVcM9MbHseY5UZUBY4dIm01hG7zWvP6hPpuyVtedXGHPRzsakIAO9c1u3bq4UP1VuHBFHMOs/v+nQbpVVGwj2M0DOs6Nz6wrF3HJonXRjLlLLDVdSbxai+7EEQF3Z3g7YOGQQLRFf7DIfXMlWb2f5h58Izp1/4nIyoiUPgDPc2U5paglL75MeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit fa759cd75bce ("kho: allocate metadata directly from the buddy
allocator"), merged in 6.18, moved the KHO serialization chunks and the
preserved memory bitmaps from kzalloc() to get_zeroed_page(). Two places
still release them with kfree(): kho_mem_ser_free() for the chunks and
__kho_abort() for the bitmaps. kfree() on such a page hits the
WARN_ON_ONCE() in free_large_kmalloc() and returns without freeing it,
so each aborted or failed KHO finalization leaks the metadata pages.

Patch 1 is a clean backport of the upstream fix for the chunks.

Patch 2 fixes the bitmaps and has no upstream counterpart. Upstream
removed the tracking teardown from __kho_abort() in commit 99cd2ffac697
("kho: don't unpreserve memory during abort"), which relies on the
unpreserve interfaces and the notifier removal that came with 6.19. In
6.18.y, KHO users still preserve memory from the KEXEC_KHO_FINALIZE
notifier, and the teardown on abort is the only thing that drops those
preservations. I kept it and changed only the free; patch 2 has the
details.

Federico Parola (1):
  kho: free phys_bits bitmaps using free_page() in __kho_abort()

Pratyush Yadav (1):
  kho: free chunks using free_page() instead of kfree()

 kernel/kexec_handover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.47.3


