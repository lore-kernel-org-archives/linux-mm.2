Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EB3CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A62F8E0002; Wed,  1 Oct 2025 05:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8326C8E001D; Wed,  1 Oct 2025 05:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C7C8E0002; Wed,  1 Oct 2025 05:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55A2D8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:04:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1390C14094E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:28 +0000 (UTC)
X-FDA: 83948959416.07.CF91BB5
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf06.hostedemail.com (Postfix) with ESMTP id E6928180005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=tnJ0UnZk;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759309466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzPLc+IFhXU2hCT/ga3y8QABI/mqNeOmZhS6AUI98bs=;
	b=rICX5mv8bwABnQYm6KL9rHl2kWUxlxhz6WQoGm+Who/gIPubIU4UtWrdI4bJDOOu463dtD
	VCaL36gVARE2rwiMMTu/COI1oDFv9y34LwX8RwWZA8kHe0TJXmZ682SJ5O0Sww+rU/k2YS
	i6+FP4Oso8EnztLw3uZIqLdy8eecnfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759309466; a=rsa-sha256;
	cv=none;
	b=goTnUUIKu9q6xNXHZA3JcgpKWvQ1ewi6v/iuDJeIQi1KjZmW3FBNz/n+4ml6sFZcR6Yhiy
	bMbbJkYenyIbQRuVqsYjDdk+nxUAyFS5Xxtdhkmq/NCyyuG93VRVjMkfW0gKEsMyQf8Kuc
	licu497LeY4RzJQwk27f5lsdYHcNlKE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=tnJ0UnZk;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759309466; x=1790845466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OzPLc+IFhXU2hCT/ga3y8QABI/mqNeOmZhS6AUI98bs=;
  b=tnJ0UnZkjO+Vs9KtKCFDkowtWXMTKkKU4bEthyYhd6mhvD49q4LalIiU
   tMDNv+/1TZeWsYtqWqDPpB/Ykjl7jyn5g+zU4AS6PAg+WIsJHJpyv1ESH
   lEBxo7X72Mtz7hTCPW5CY+gurK3nMk03dr2xQzJH8jbsGSP4I8Wyh02BT
   YNMng6Gtd51x0msotcCPkFZOVwXqsLk2fpsCZIs6xNeUoin8Z8jJ9ZVZe
   AXBuOltTFetDrfNU8Bl6/cq90J4CTfxEJV4wlTA6BjRbN4S3/3ETivgdH
   p+MQgPS8N2j0m3vn8Ks4Bq8VrLELKHI2QEPS4JrPmCKxY5rRrTIF9g/1L
   g==;
X-CSE-ConnectionGUID: FGEcwYeHToCCs/kvg08eTA==
X-CSE-MsgGUID: fHqXDOd5TZmmQ05DQ2mzkQ==
X-IronPort-AV: E=Sophos;i="6.18,306,1751241600"; 
   d="scan'208";a="4058017"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 09:04:25 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:30255]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.32.190:2525] with esmtp (Farcaster)
 id e9f24429-472f-496a-a05a-30cd931969d7; Wed, 1 Oct 2025 09:04:25 +0000 (UTC)
X-Farcaster-Flow-ID: e9f24429-472f-496a-a05a-30cd931969d7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 1 Oct 2025 09:04:25 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 1 Oct 2025
 09:04:23 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <linux-mm@kvack.org>
CC: <acsjakub@amazon.de>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <peterx@redhat.com>,
	<axelrasmussen@google.com>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH v3 1/2] mm/ksm: fix flag-dropping behavior in ksm_madvise
Date: Wed, 1 Oct 2025 09:03:52 +0000
Message-ID: <20251001090353.57523-2-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001090353.57523-1-acsjakub@amazon.de>
References: <20251001090353.57523-1-acsjakub@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E6928180005
X-Stat-Signature: b6eaq6dxj1ypjx7bb7urhyo1f1eubg6x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759309465-558421
X-HE-Meta: U2FsdGVkX18Ls6gNLL+Y0dmDGPLPEdK7GCbLvcAIvHZyh4xqqwchSayAaOqYAzxGXhOo32QF0wQaQ9LT7JWXcpBfXHQrhxbIW3Z5ZuH7VUlsdJxFlPwJRbqQ0SLnnfvYNAWl7ujIZ4LGC5TgMs0+Wg+qNej5SztmvRNwovzQY0U+YVppDP545tl5uebQl8HdeOz5BjgKZgYf8q2YDwlc6OE856DKWFxcVle2WA3XYVUvXDmgaTKu1l5T6K6lKPN0IavUPBr8NXo+5ro8HyHAQ4mvIvhMaC13J4C9xzKOrvld17986b0JgaLR4/7I0Wl5xPIBwM45yKYe9zdilPMp/XkBLIUK6HcSVw6RUhPzz+U3q65Quq5b2uPMyctVKejuzCJjhEAnXYHMI1XXlkfGf1VhEXDnc1TzCbWsrE4el0lsHfQAIssv81tXAAmXCLEk0tlKnu7wwtmIISMcD0eKTKG03Tev3i7HQcrt9UxEjp/v4xWBbhcT60mnjDJ1mpktT5Wb3r56WD07i+l05m9H6IMtFjH2ILGoBaqLM2yw3JLDBYk1p2vVyPhHw4l95+eARNYMLvEAEeB+jLNkP7N8Csje+fxPVSux0f3Q4Oal5g3gp1mg/rkCEmdkEgfNs1Gz/2dClTkxRwTL71gXVq0CjkHa3IU9k7sCJJ5ARwIZdMeNGt//Pu5CT5ypv8jlq9V3t+JNBItHl4+Ovu1Qd+LbPYsqiOF4ltCZNbipiXnOFs5FG6vXXwcQX0V4/bj47zMyyGIlgnKzR+kVxBCWQ4ouG9QxsDHa7brhcbhpyB91iBrt/8bJg4Db/ZKysanfXbXb6FWkG8H6pkEZeaE5I1kv8HvyDb03TJLO39fzy5iqXm412q0rzZokcGRe9Nl5VngGVkHYSWS9LwD7FMp+L7ghFClXLIVi/SsHd6UVfMDt9gCwcN4nnhb9sDFsD7WXvPoaiium7hQgPPpG+rgawCx
 RN/QsyFH
 pDEzTa8MBT4yxFv8eoVrrxFCHZ02xgiyuII7f5EXpbr5kEtVJt7cvfWVng2dXcCQg9ZAG0m7YGQRkfjwXxnIZkGvQiSJWfzpsVuc3MZofBk8D4tTD7IAl8PLFoeSmno4TBpFz6QWuJ8UXjQGF0pV5xj8+99mQgLl6Kw8maqPEar0pLW7vw/5RiKl8J5NCg0OSJBmr3O0uK5cVFYcksBbdTyoM8L7V3h7P8iRz5sPOev63m+AzH/YTwzE7AZudaaW7oYR674tolEawLzzHqvlyVN0ngTgIWJaieDqWPOECU58q86ttDTcnWokBH9T28rgYkHbNdX/ZlAp5Lzy+OUr23y4x9NpBNKYSusjCI4zgZZduKOAl6bBWHwsmzh8JQULtoWWgg5RlWDcTZhxKUE7dphz9j5T29ZoPWpSxAY4NFvEnTE14cwoZ12Sx9a4cStXpO0aoNQp4Y6CAXDMyJiqH38iPMu55ge98trie16Gd80rPLVnlZHOWxQb7pGvN1qqczFKe/L7yA5XsHjv4AKbxNYkHL37E1xfC1JL2cap2U5yOYrp5HN1/YToNjwkAq6oq6Ygl0UZd66g4eDeusN6JwKmEbkVdAHCmEl84P+MXJkksaFZbBDVyr1nl3icFpHCFzEp3G8JdINHmeSxh842HGQsTaSt11ps9zIHzUl+cd+lVc9NmHK/1KQU2Tb2Gh4yTNh7aD37GCmUgQEOLnHd3DQrSZ/EUh5gvkkpmGVmR4Ha5gIWC2aLsSemFUGQ7bUwKoj0zk5IMcfPq8TLJsU59ONXeKi05pdoDTHBYJMzMvsLUrP5+KS/MWg/ceUfJ6oDNNfPSAEZIhNLWyfRonqedooDBKP6H+Cm8GHzIRbkgttAA0L2iWVuPMtdS3g==
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

Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
BIT() macro.

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
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 include/linux/mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..c6794d0e24eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
+#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


