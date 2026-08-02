Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 819FEC55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 07:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B456B0088; Sun,  2 Aug 2026 03:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4796B008A; Sun,  2 Aug 2026 03:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C1C6B0092; Sun,  2 Aug 2026 03:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2FCB6B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 03:40:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5AC9A1B29
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:40:37 +0000 (UTC)
X-FDA: 85055532114.15.8212D8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 266C2140007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:40:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlkYsLpl;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785656436;
	b=POxW2iPU/a2eQIjDBDGWFY4ufLnYt9B8VmwYWz3z5csBeFRzvWLUw6ZIFIc92inpsY5btz
	0wjzzUlaHxXbvv7uTou6SP+g0KhgsC+J/rMM23RWCWKJNlwI155G5arAPNMlPcnKFqxyRx
	N/2DKSxNEb2bzKP+0StYTmz3mqhXJm4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlkYsLpl;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785656436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LbYy5ro5NDFE3DG1YbB/j5IpRtLd57Aeh6qzOqIXCU=;
	b=DB5IArIljp0SaVzPKUE8hA1qoSNnxDbIjg3jXFnOz48N5dZErvhGu/C/iw4S004S912zEI
	nv5sjbI2QaFaAtmvJaxg3uQjzKczqQP7brWSIfjr+chCK9vyGB5XsbnT8/knhX7GrZ+u/u
	kk9dIUPsqmDISAkzHkRcgY7LZTwlUNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AB1A41AFA;
	Sun,  2 Aug 2026 07:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E4A1F00ACA;
	Sun,  2 Aug 2026 07:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785656435;
	bh=5LbYy5ro5NDFE3DG1YbB/j5IpRtLd57Aeh6qzOqIXCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlkYsLplRph3ACb5Y0qShIVauT+VeZYT7DAbyEWRuhNCXupiQXKQeGe48Rp1BoU6o
	 ykH+8hNRMTh3IOq4fgDP11Taaedt3v6TjdFpDBnso8tmFbWPf72X7Dxxz8H9n869lI
	 +o7o4gH44rsEYbf3t0hLdy3zAYU5NrpZ9ts9yUAo6FY+2xzcL24dqG2D+1XtPaA+dr
	 A/Ar28oyD7OKALChWX2DBVAWVLtv4G83BYcrutcRRwl2Tun5geNoLv9MbF01cNbQH0
	 k4mNwEi99GsQEEmwZoveFbRu00OqMa32HK19GG7MCJHW4L/hQP/o9zozMKLK3BZYcl
	 8u+jNC2kvyE9g==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	surenb@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	zhanghongru@xiaomi.com,
	willy@infradead.org,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v1 1/2] x86/mm: use VMA lock for kernel faults on user addresses
Date: Sun,  2 Aug 2026 15:40:17 +0800
Message-Id: <20260802074018.73887-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260802074018.73887-1-baohua@kernel.org>
References: <20260802074018.73887-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 266C2140007
X-Stat-Signature: rezetdb1fh1hboreest6tjq6dw76dyz7
X-Rspam-User: 
X-HE-Tag: 1785656436-212820
X-HE-Meta: U2FsdGVkX1/p1ZC68yXJoVMUAa4AE8cdo5SmqXnvDHlsmRRVpAmf9BZqRu234kQgK4vDLLu2x3t4DFPSsDzinyKVOC3440I+zLY2La6XW04IMyGlctmEQmrNJFwdm+hp3z+CswlyjIrGQQkJBjp/KFMF0vNU3JTGHxAk4FLpSHO8cpJalvNeNEhVlq5YLMMdoOnGZPRawH0bONgjEMOHEPFo0QLX3xAdTvJ5Sh0S7/aaYYnXPcnQBgDvqEiUJHoyA5t4KW5PXNhI1xr2W3mDybdtgeL3hwejSwIDO9dzpOBIzX9G3+Uy4BVCTQTys/vEXoxQgVqNkFK0/5oJB3xMlvO8PoQZ9fKL/5dz4v+kN7FhvNoRPtvG/dQmQghBs7ndjOHjbSicw/T5oy65HPhS0fUEBNzRyNoTRVIXohu5/ZfH0oohTmRW+1Lmvj0Q2RsAM7K7Gm8jEgac9JnWJaVQhw+mlTJKon7cSlGqa64gpJfASby1GjNaH+s+IdXbNzduxuZCh1jmfPvtXvtf71/kXVRp7akMJYJRInz/mcLbHOlrze/HRlG+YpOP4+l4nEHQXy0l1NbnRGW6iJ0QqZiN1gKhfl/s3MGf4wi4YfFlT+sf+0BhQ8ut53o4pILsuQyQ0gOcduZ45lmme/FgPm0r9QteBNvXUnIQGYmgkBYSUZTPEWYhMf95Fd1cE6a0L+t78yQET5GmnTI/YLIyjDhJxJ4JKLOXAVBLUYOt+HZ7jdbXtnzovPE6oppI8VK9B9pUo0YoaVR/Zb7eUAtSyEFzLSgrezcs5375HKZoJSq51Ryz8nFKFZ3g4YZOOhrewm/bXh+9G1Ny3wCWuC05l6GW7Zymr69aiU9yiGYeXNUXoQUhn5JD8ukwNqNK3Px1WYAb09eJeaV22ydEOVtZxSJTVlMq8HkI/ghnUlfoHaWSrhvlvaqtPmOftGYDtk9oYvlpbGtMniz+Ivy7Y5vRtLC
 +qSlxT4b
 m7ubiNo1bd1Lr90rlZDP4lo2GP7lCquGvPv8u9n3BL2YFaDyFaHAGob7Y74WBQwSJB24PP4OR828HMb2ZnLicSdxid0tavVc2FDt4XnrzlUDlPvLMZTQV8iYMxogwkoHZMklE85FtanNmtBd0H03WcJlPTM/IkodzYMdMAeomSgvlCZi2OxVhJ6I1R+uAWzYYzGxqZJ9oHXD5WthGvp0stcGOkAgQcuDu6NX7u2jXdNSg+iHkc7zVNmNR8v2EZtdtLo4w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the VMA lock for kernel faults on user addresses. This also
makes the existing code below meaningful:

  /* Quick path to respond to signals */
  if (fault_signal_pending(fault, regs)) {
          if (!user_mode(regs))
                  kernelmode_fixup_or_oops(regs, error_code, address,
                                           SIGBUS, BUS_ADRERR,
                                           ARCH_DEFAULT_PKEY);
          return;
  }

Right now, the code above is dead because !user_mode always
takes the mmap_lock path.

Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 arch/x86/mm/fault.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..c22b74e0eeaf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1328,9 +1328,6 @@ void do_user_addr_fault(struct pt_regs *regs,
 	}
 #endif
 
-	if (!(flags & FAULT_FLAG_USER))
-		goto lock_mmap;
-
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
-- 
2.39.3 (Apple Git-146)


