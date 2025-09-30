Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52832CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF488E0032; Tue, 30 Sep 2025 02:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FA38E0002; Tue, 30 Sep 2025 02:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E4E8E0032; Tue, 30 Sep 2025 02:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCDC8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:39:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C2AD443B6
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:39:36 +0000 (UTC)
X-FDA: 83944965552.14.F58F323
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B9F14000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:39:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=QHy297PO;
	spf=pass (imf12.hostedemail.com: domain of "prvs=3616c5604=acsjakub@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=3616c5604=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=86mRlECkiQjLn2SJJnK2m65Vsp8KHxy7PFdzrijTjqg=;
	b=mumhNSwQgEVg+DsM22QmzHv5fZxI1dT/9FhHm5XKgcRsHiScAUNO1XUsdL/hBWOa5jR6Nt
	UATMDJ0djo97TTQPMDxJh23vPpSrmrDIkxn6Sdov+6Z1ZX1FxsJ8uDHE75BaarwVLKwmz+
	UidytPNfhvtBqMLZt9b90fGB/NTaTuA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=QHy297PO;
	spf=pass (imf12.hostedemail.com: domain of "prvs=3616c5604=acsjakub@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=3616c5604=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214374; a=rsa-sha256;
	cv=none;
	b=eH2ZbxrpMMNSxBasBZfkvPM+BMjXSETfqvlbj6/sD4y47KBT+hihtg/O2vq6RCRx7+37T9
	GubC7oqq044mzJ6aZah2jZS5yEbJsPkdCvRHmLV+JTCqA7c6hZXLRYDTGcqju9Z8wxapfx
	Ir9HhO3DkjsnkwFakZFpG9NDko8zbqw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759214374; x=1790750374;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=86mRlECkiQjLn2SJJnK2m65Vsp8KHxy7PFdzrijTjqg=;
  b=QHy297POdsgL3OoF6JUZua7IuWHDMHkP3fb0vCHyhrVpb84Dk4CPPFFj
   S5F4p10Jdof8cXkKKBi0pIayYBGaIsMO1/m88DBRW7zCIM8aKicsjE46p
   05kJHwg/iGLBxPxLYucSf2oMjZF2UWtuV+buqwVwmtORkUx6uaNcg4w7+
   p2cN0GS2r+7YsNJNZHWUsuUc4dr7WikMlcHdmu0mQDKmkeROyQgfrBAl5
   cDfNnqAKCitS9LsVmskzgVeXzN2DU3KK8MHZKUNCY9FWZqv9OZfzZLc2g
   SNB7K+WfJl0lyMxOTj7WJ2ru2EIZjtWF4qbOiIuGc5bgXDfubqkUMHRor
   A==;
X-CSE-ConnectionGUID: yVQyi8UHR2GZdvsjzUxYjQ==
X-CSE-MsgGUID: 6QfZ61FCQjKdkpuOMnE98g==
X-IronPort-AV: E=Sophos;i="6.18,303,1751241600"; 
   d="scan'208";a="3869275"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 06:39:31 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.7.35:51513]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.37.222:2525] with esmtp (Farcaster)
 id b09c49d1-cacd-4012-a7e4-1eafac7f67cd; Tue, 30 Sep 2025 06:39:31 +0000 (UTC)
X-Farcaster-Flow-ID: b09c49d1-cacd-4012-a7e4-1eafac7f67cd
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 30 Sep 2025 06:39:31 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 30 Sep 2025
 06:39:29 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <linux-mm@kvack.org>
CC: <acsjakub@amazon.de>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
	<chengming.zhou@linux.dev>, Peter Xu <peterx@redhat.com>, Axel Rasmussen
	<axelrasmussen@google.com>, Mike Kravetz <mike.kravetz@oracle.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] mm/ksm: fix flag-dropping behavior in ksm_madvise
Date: Tue, 30 Sep 2025 06:39:21 +0000
Message-ID: <20250930063921.62354-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B9F14000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: fz1955swgrr9akce7rkgygjxs8bba6j4
X-HE-Tag: 1759214373-165709
X-HE-Meta: U2FsdGVkX1+1HytD/Xe8ZHDiyoO+qklKSTBLcxFqVriPzV9v2PM8gZIQr03nicKZxW4fN5UN8nE/4xMSb0e75z49ZC/rF/p2Q/ukkLHi8d/oH5nUNrdVkcoE9cqTPsv90UgYNsv/0KdEVBJoGBkdR8CcqeTvsKS6YOi8iAoa7yqMU4+VhTqMrmcxUnNlxrhorNldRT1bsWzojVehe0UduHdtM64NvbIzvSSDSdm/BASct9lli7vfcF07aTUbYjexEw155SClOAoIOU8DpdERGSUVrAHZraTN3mKOMKeYr55FEMrTlCXQdzwC8LD5heJJbdlbsnkaOwIUs2yJkd+kNV++qIqoB2OcbaLoks2A4L8JCjC38XbEoYmG7S0IcRNQ64yVx45IDwXvhaLmlIPSL7eMC8nTsZK+t+9PI6T9htfOL7FvvRLJY2kJPEOX5sPAMU2vDwSjk2HdplXu0Ch+Ypx9xsM8i9gPanpk0F1+l5S2e0foSfX3xfgGL+e5ggPZEqJ4I7HEriVJGMvuo1Xi967Y+hKkP68GviEsMR0RbG90paN1781IYw0UUCQqIGwGoCfdKfLI1FqUiSHInnOiuwH62RWgo6v+l1aLYpMK7pDrsg4PnEmgDPAM8twYkZg4Q52BKsQzYy+wMhw2882hPeYncURr8++XL7wN0pyA7xw3+eL2JGDYw5otsqLHxiJO+sRY6qk5+WsCPTkyGimf++8uV1RxDDcbG66RTGkkjSE70qdWaeTllePeWtdY7Ya92v4u7Ji+JFixBVps049wzRUjjBxQMJKpeCimD7Vx46Ypf9NaEX8OVIYVvqocu/NXdBIrE9SSTxeWSJdbgOWyDFFhJgDTpcvhpCYgVlduds1kVOX6FaRjYobDQb9uysKN2MsMOuTSCOn4JKnOFi4NFejyCmJW/BCyBAJq8CXImelJeZfsruF2AAitZ85gTjh9dYj5Yv0eBmfixZQSFZW
 fV9cW/2Z
 kLGI3jwW6SITU/8dpt9B5irX4vlYp7PDwai+1DGFgcoENJkzgcrYalET88J4TExwqPvniYqDk2h+F/fb1+rbthvY8hLhjXy5tgDm2F7xsxSeQ6jzhVj/xNuzrEdOpHVHMIK+APg5dxQ8GKWQ2rPdEwjZWkYVxMmRVwZ+5pnYk93hyOktiLhyUYVCptG1Vm6l+B0qdz2z7FZg/I40QDMOD4g4v4umkus+xb3HoTfUZQp+OnjfWCJuAEKcQqkf4vjRN9U36cV0XvJXQnMWcJxtc/jBNdUuwUWQG0WCrE/iGfvgxXG4e4zR4MQE7dGVkkhhs9RXsUutAWBPDK9ppTq1sGkZipq9S+gd0qdRzfvWUrBRgqFZez4d+EAa70LxijA9jA7WUoI1WJ4V+J4bIQVJwphcfD4460uIuHlWP4FwOpJLx+g2bRm/IBNnYcbML4LEsaVk6nUgUZIYTMvQ5UZTQ10EyqTpro/IOd0cdv1KRb+hZ7PacQGU78FAYuIz9a5soTqTeEoqjhXbPs/zkTBT1GcQu+93hPcfNXEhu958Tar/R24YfKVAXhkLnK1TZ8gonyaIRvvGHKRfOtCAUv8xQbLUCeUxIZ9r0LJJRfGIO1FN20vSR6+hIDzNkug0u+Zt/kVD6VT43tkNR7T1x+DtLaaASVpwfarWVqd1Lbau9vSoof1Ahev3f6S01RR31+X4MC7BXfFzU87z0iYiUk6L4wDvQjHpbu5SaxywGwpjLtRZ7+kI+M4CB/iRdYlVQmb51+ROoEB100d8q3bwwxpxZrDVH7+3ld5yQSWqK6gUpi6F9iQCVrmTK6lAQcSw5u3DnKwExabA5AgNDcnFzsstElinnV5Cy0p0tNjAySiOGMhkMne9T0tvd1oZhKTio/gWYDZ8Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzkaller discovered the following crash: (kernel BUG)

[   44.607039] ------------[ cut here ]------------
[   44.607422] kernel BUG at mm/userfaultfd.c:2067!
[   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
[   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
[   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460

<snip other registers, drop unreliable trace>

[   44.617726] Call Trace:
[   44.617926]  <TASK>
[   44.619284]  userfaultfd_release+0xef/0x1b0
[   44.620976]  __fput+0x3f9/0xb60
[   44.621240]  fput_close_sync+0x110/0x210
[   44.622222]  __x64_sys_close+0x8f/0x120
[   44.622530]  do_syscall_64+0x5b/0x2f0
[   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   44.623244] RIP: 0033:0x7f365bb3f227

Kernel panics because it detects UFFD inconsistency during
userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.

The inconsistency is caused in ksm_madvise(): when user calls madvise()
with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
mode, it accidentally clears all flags stored in the upper 32 bits of
vma->vm_flags.

Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
and int are 32-bit wide. This setup causes the following mishap during
the &= ~VM_MERGEABLE assignment.

VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
promoted to unsigned long before the & operation. This promotion fills
upper 32 bits with leading 0s, as we're doing unsigned conversion (and
even for a signed conversion, this wouldn't help as the leading bit is
0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
the upper 32-bits of its value.

Fix it by casting `VM_MERGEABLE` constant to unsigned long to preserve
the upper 32 bits, in case it's needed.

Note: other VM_* flags are not affected:
This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
all constants of type int and after ~ operation, they end up with
leading 1 and are thus converted to unsigned long with leading 1s.

Note 2:
After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
no longer a kernel BUG, but a WARNING at the same place:

[   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067

but the root-cause (flag-drop) remains the same.

Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---

I looked around the kernel and found one more flag that might be
causing similar issues: "IORESOURCE_BUSY" - as its inverted version is
bit-anded to unsigned long fields. However, it seems those fields don't
actually use any bits from upper 32-bits as flags (yet?).

I also considered changing the constant definition by adding ULL, but am
not sure where else that could blow up, plus it would likely call to
define all the related constants as ULL for consistency. If you'd prefer
that fix, let me know.


 mm/ksm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121c..c24137a1eeb7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2871,7 +2871,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 				return err;
 		}
 
-		*vm_flags &= ~VM_MERGEABLE;
+		*vm_flags &= ~((unsigned long) VM_MERGEABLE);
 		break;
 	}
 
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


