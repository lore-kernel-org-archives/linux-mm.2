Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B693C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EED6B0098; Fri,  4 Sep 2026 06:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98BD6B009B; Fri,  4 Sep 2026 06:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE346B009D; Fri,  4 Sep 2026 06:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA1C66B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:10:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45E831C2220
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:39 +0000 (UTC)
X-FDA: 85175660598.20.2B58D9B
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5F6FC40003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jOYuemRc;
	spf=pass (imf17.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788516637;
	b=LNAtV+331nBafSl0g+lNkvkbcMhVtdKmeC/Nx4rS4gbnNr6HQIEg/9VzPU1jc8nCQ3NUIe
	nqi6RI1JK43jD7SG/ouQh+3dgYWo41UWSbtg5PowyyeoqSluajWIAWvq/U8DFnhZJYxSY9
	oslrTTCPQAP7MwmFj7PEHF57FecpidI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jOYuemRc;
	spf=pass (imf17.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788516637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhjxLhACs+nHcbwiRjUkpDk4h0tix+V7Njvp0UeHg00=;
	b=p8dmsgEfTSoex2Asz18nyu4G94cm8dCPObavCRUpsHDlEVbrWv+Juzf2dJ3ieUgnYJTRA8
	q/1AegQuCBs3pbyuwjrspTc6OWyIlsDpBNUCbGx4itNb8fvIKxmNnhiIZAtcYEG/0bUcpk
	ri9lxnJutr2dFyZoyR526W8KwwGRrT0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3cPgANBsAN0TCTPt7lj+YGACHJ2FHFsC3fuQuOraQMA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516636; v=1; x=1789121436;
 b=jOYuemRcWo5KL+QgZmCOv9MMIDTecQV4sy4qKJZoKBEmf5d3iNXBGG9bnLcIf1/rcI4GcegT
 fTUoHhog/yvL5xoVRmK1vLBPfhssLCgKuA5gqPNvAsN6NJaLVLdygn8180W+R8x0Ym3nDkEmxor
 QWjA6/7/PTIMc6MQxWL3/CAY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 031a72623a973772;
	Fri, 04 Sep 2026 10:10:35 +0000
X-Mizu-Trace-ID: 031a72623a973772
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v5 4/5] LoongArch: enable kexec handover (KHO)
Date: Fri,  4 Sep 2026 18:08:51 +0800
Message-ID: <20260904100852.26006-5-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F6FC40003
X-Stat-Signature: b4mpn44rzaqd9dcdo9q1jhcqn6bjarr8
X-HE-Tag: 1788516637-547649
X-HE-Meta: U2FsdGVkX19Kf/Zi/DHEmdzANnB4lCVmm9n4MRAswE+SQ45vUbZvb4FNJ6iohvNqHM8EJrpiPnygs35V/Dt4ZvRzCBqotFo6aAdG+ZQcB6VEcbqj4qEjq0bav1LYD378UZtlY8DYuX3TNjuag+RVPjq3O2NxDKp+3ByT72pNUklioPdlsXinExZcHrLb31QJPUMIOUHmMVQCwI1PDXmLGxbBF8Cxvot/iTz2AxUtLxK2PA1xqCuxXD/f/2JtRzGAFc53fuqAXwe1L5dK1MJxySPTY+rVMJZig1QMluIHGvH/wkCy9mw8GnA47lR1XQHSdp5so59yzjSJqzMNzHJtOku/xlSlbr5RjUczZL5Q6iXteIdA8bRlP4rg1TwudOhvTtR4Or7qqgWaZa5ZSG9msgj+XIab4s5LXmiYjp8ELPSGPX4Lu13YdPzIl1BVtt/t8npA+0sc/ZmEhdHQRNmpGfUHgPS2soHU1eBs8ZQGrZ7uaPCcQ3xGI6MnFt/+7wSlGOGKDpzmm1lvRffL6vLqQgvxn22U3GjMDNj3+etmCPWOi0dfGmp8hUbKxH/o7VobD4MWuLIylTU2xLdiK9BtRn0IGX0ny/+IEm6VIFo+4/fZaFxu3iUDTx6jRn+guT0TV77QV1sogVi0lJyRkH+0Vs/7Kdzc2QJGea8ERaN7uYIHxhpm7EUKUrKh2jmtgd5FvpRYpMP61cvTktH2Q39puKSC0MiREWwGTNwP649FV5UXZUqUIk23yI96nRgAF8u47ZBAMwsyvVdxOzvuKPkFb0XcpEcVQxeOMidMQe7pdkoA7Y7jNKdRCj/7bI3vCJIN9PHWDH3coXesoTR4V6EKI6VK0pNDRIYATl5c4w/0aBOJwwmdk25XiPTgHNdmYyxHUUmhqRdhMPtcjnxNJ2+VayEgqlFi5NWXxRD7DmWMEZUVr2hwGHTLO5ugAJT6ZOoFzweFt4W2VZ2yKbp+6ye
 FDwdmV5+
 VGzczRRovnwVnCUnVAhCG3o5xoAVQVdoaNKe2h3DPtmU6oMvmnWCRfVORX/blU7LRHPr/QzmrNXnBlmWAWohPYy6yhcUoXiVEFI7hIsxYNPxDjCtJKogPIurEwy9o+mR6iUAq3pF6I81gIcnthOmZtVNuqcNgNnbbc7/mfmLCnSm6FshYD5vCATAu++IeJbhfK4iWrLYlRStBk7eD51uXkg3oupqwW67E9i+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

Enable ARCH_SUPPORTS_KEXEC_HANDOVER for 64-bit LoongArch.  It selects
EFI_KHO whenever KEXEC_HANDOVER is enabled, so LoongArch uses the
architecture-agnostic EFI configuration table channel
(LINUX_EFI_KEXEC_HANDOVER_GUID) introduced by this series to carry the
KHO state across kexec.

LoongArch boots through EFI without a device tree, so it cannot use the
/chosen FDT path that arm64 and riscv use; the EFI configuration table
channel is its handover transport.  No arch-specific setup.c reader or
machine_kexec_file.c writer is needed -- both live in the generic EFI
code.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index a21f51e5815e..5eaa65578d58 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -685,6 +685,10 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool 64BIT
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT && EFI_STUB
+	select EFI_KHO if KEXEC_HANDOVER
+
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool 64BIT
 	depends on KEXEC_FILE
-- 
2.53.0


