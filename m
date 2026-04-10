Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD6DF36B9A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 01:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A545E6B0005; Thu,  9 Apr 2026 21:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A056C6B0089; Thu,  9 Apr 2026 21:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B746B008A; Thu,  9 Apr 2026 21:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDA56B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:16:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46D781A0341
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:16:29 +0000 (UTC)
X-FDA: 84640880898.14.7E86FB5
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf04.hostedemail.com (Postfix) with ESMTP id 31B0240004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:16:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=kXrvFtEa;
	spf=pass (imf04.hostedemail.com: domain of "prvs=553559970=epetron@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=553559970=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=kXrvFtEa;
	spf=pass (imf04.hostedemail.com: domain of "prvs=553559970=epetron@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=553559970=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775783787; a=rsa-sha256;
	cv=none;
	b=EIsUHTvtpHzTpAMEthe3eLmxNxHN5yMjfc8Kc/WjUxOhaChqj8itFh+9LvrxzD8e06los3
	3uXGGz0A3vqBnBROki4//TsI11+Ru3brkY+AoY9VbMaYQhwx0SKeq9FmtYIcST5zEoydOH
	y1G586MP8tf6oMqDCvRuUA400y/8Bdc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775783787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y+ewA8RjY6nMAFwnoN35zZbuD8YUej+hPFsz1UPCe10=;
	b=riPbXKTTrSu91LQhfJzH3E9fxkAh/qW4lglcVNL429OSUt5NaSqlXVeMyeRzUS7iU70SYR
	GRcnkCErPNBLSO5SU8KE2+V74p9H0Lf5aKmhwEbs8/mgm6cAApS4hgcCkeOnEk03E53ave
	sbWCT90++dUPeC0GfjeJGx1G8s5pYTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1775783787; x=1807319787;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y+ewA8RjY6nMAFwnoN35zZbuD8YUej+hPFsz1UPCe10=;
  b=kXrvFtEajqNkh90l75e5fAywMqaCwFjMAy3KnKwxI+yzRNQTpTZbmPi/
   nQEZGSkihE7+1x4b70WOwXdlz2DhzhVIhkaOAYxpVN3aKIupwRgqH9v/j
   MCm5oroDHkZ9/Te1CxDWesexeg4eI1XHDL+yvyXKzIHTfu0ewVFDCj7QG
   qQ/0Y7laG8R17942nGXT0d1qzkhEJ0Cd3hL7QcSikAXvT8/ifKXkSpxtQ
   /3pEf4oKU4rEDGgOvKYZRcsgzaZav4cZspaqrxS1DXvw1NPL+EsCt6FgR
   UQxVTS0HMDvk4PAqZiEZ4DiJ8PUqIsKNRUaCeMv5n3McFkFQSVos6HIMF
   g==;
X-CSE-ConnectionGUID: DHa5mPRbRGqTlrLccv9+iA==
X-CSE-MsgGUID: Y8/JvhHsQZG4LF/ImZPAFg==
X-IronPort-AV: E=Sophos;i="6.23,170,1770595200"; 
   d="scan'208";a="16989540"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 01:16:23 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:31699]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.82:2525] with esmtp (Farcaster)
 id 0218addb-e3f2-4ce7-89d0-f199987a9e46; Fri, 10 Apr 2026 01:16:23 +0000 (UTC)
X-Farcaster-Flow-ID: 0218addb-e3f2-4ce7-89d0-f199987a9e46
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 01:16:22 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 01:16:20 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Alexander Graf
	<graf@amazon.com>
CC: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Rob
 Herring" <robh@kernel.org>, Saravana Kannan <saravanak@google.com>, Changyuan
 Lyu <changyuanl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [PATCH v2] kho: skip KHO for crash kernel
Date: Fri, 10 Apr 2026 01:16:05 +0000
Message-ID: <20260410011609.1103-1-epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D043UWC001.ant.amazon.com (10.13.139.202) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31B0240004
X-Stat-Signature: xzih9t7873p6tqmwe3knwcwkka9ypn8u
X-Rspam-User: 
X-HE-Tag: 1775783786-831890
X-HE-Meta: U2FsdGVkX19PYXP1OGtrhmJkJhhkbOFSKI8yuzl3qyeHwRx5c1W5MFIuKBoirlfQJG6SdCmEK2z3Bv+WRtVbZy3kCuh8le4xkeuqWqeZh245+iXvlgV3A9kaQUEir1lUwS7pEA+M8DuWWQGhEPWFxTrBUFuX0R1juk8oXFG8WHRuGa/u3HYcksGo0cIbiYUtrbibfVFpie30FILzA/23hv99WEFeFI1tlpv5taOQj7wryqLerw61d+zYB3q5+jRjklLP6fTgGfyFsUym9yxYlk7ibGSdaZDpsuo1MAfoHJAsUw0JF24i378Tr4OJ8Tm42CQeA6Q+FGW4zTTgYQLstROvaPv7JzBjnPvdhMo5jKCbae/XmbRFqdGlAwE/9BAQJWBlMOasdGFyQ01dY6/3XwHPLQ+cwnhCe8uME7Lc8gibNlxM/ly0nyh/vvJCssooBLMeeQbK03Yfzq0+LBDbJ3KUsdapebX4EIk/UILrUioANrp3oiC3MLpKRYMKyAjD+AMSKDM0aaIkYj8QsBSDMPMkGdkVllkw24N/vUzBY1eYI+o2/fzDn82DDGGODcn5m+fXCey1WgXcHZ+xO3o4HSd2uSbEqzfYCjugLHRUW0KL08KBXuTxEs8joyt2DQP+gYfV4is+obvX9gW+G+TRyidwtLFcikw0gTZp3q5VPD64tCg/BjlqVyBbVs/QKE8uQ3U9azKFfjOO3/a45pSXYKzB1tveGkO/eILX8aTmSFkBC8VhrWiSwEd37QNJf2ngDPwDfOeubXRV9Q6Fz6K5BIq34/TfGM7caJe/zWE03iSgIAaWk4XGskFS5z8BCfK8+ZP/jNYIQX7XI31aLd9K7eVpcL//72haMYdG7SvOgsyf69RzKbZdxFnUBVmVy57wrnCGvk24F/J0YU5/K4IHdPXHRTKMbPPm75jo5JZCEycTQr/x7wMSwYt1Bykf5T516y22NPYKHb+nfkoHWLx
 kBclbwsC
 0D7CE9JKagaHG65o43xrX3a777ax5Yscjx0jioyzbtINmR+jiYTEpsZ8ApzlyQKDI/HkatojKhw8QOyV5Z5eUmEG+17ig45RJUlON7WIUwuU2Mp9hP4alRNDgudGVmdV63QHVjlkYsCxShZgu/Sd58w9SSGDYTYKxglbXegpffbxcCQ7kVu4Td+RH9QhUnzh10Ao2+DkWiGc5YtyYeB/4uqi/9u62GI+7yoE9vHbZJS1Aq+wYFbphDWXkJXc1d1p5qtORDl+APJ2p4eav29BVz9ok/8yNEXTpMJ/wOumRSd9sqDMVHZGBpmQsW6s9sbBVEpHBccditk2AOmisJhPE61FF/o4+zbShLTkDzwn0SHLD3TxguETIYwO5zF0fgJXDG6ko/0/wDaFbjfRexkqRZvmp7ch946mUqeLHrwXDf6rc2WSJ5Xb41gWvWC/4ZRVqpi9aR/Qfo8WMknPbsRCqQoJiixjF54amqf7CYFdT25HkRz+dPfYXrxTJhmDEpiE9eWAbSB3Vm6NeH9vNUor0DLcFIPYEA691HG3Yx93rUYFCicLKLWc/r2rUGZJjof5aZsfF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_fill_kimage() unconditionally populates the kimage with KHO
metadata for every kexec image type. When the image is a crash kernel,
this can be problematic as the crash kernel can run in a small reserved
region and the KHO scratch areas can sit outside it.
The crash kernel then faults during kho_memory_init() when it
tries phys_to_virt() on the KHO FDT address:

  Unable to handle kernel paging request at virtual address xxxxxxxx
  ...
    fdt_offset_ptr+...
    fdt_check_node_offset_+...
    fdt_first_property_offset+...
    fdt_get_property_namelen_+...
    fdt_getprop+...
    kho_memory_init+...
    mm_core_init+...
    start_kernel+...

kho_locate_mem_hole() already skips KHO logic for KEXEC_TYPE_CRASH
images, but kho_fill_kimage() was missing the same guard. As
kho_fill_kimage() is the single point that populates image->kho.fdt
and image->kho.scratch, fixing it here is sufficient for both arm64
and x86 as the FDT and boot_params path are bailing out when these
fields are unset.

Fixes: d7255959b69a ("kho: allow kexec load before KHO finalization")
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---

v2: Per Mike's review [1], move the guard into kho_fill_kimage() instead
    of patching the arch-level producers and consumers. This fixes
    both arm64 and x86 in one place and avoids redundant checks. Tested again.

Note regarding backporting
The offending commit was deployed with 6.19. The only other supported
kernel version with 6.18, unless I miss someting uses
```
if (!kho_out.finalized)
```
which in the case of crash kernel it shouldn't be finalised.


[1] https://lore.kernel.org/all/ade2ExpM8ROXV-vy@kernel.org/

 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cc68a3692905..1029fe8778f2 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1551,7 +1551,7 @@ int kho_fill_kimage(struct kimage *image)
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_enable)
+	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


