Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5592CCA471
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 13:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76DA8E0012; Tue, 30 Sep 2025 09:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4DE68E0002; Tue, 30 Sep 2025 09:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AB98E0012; Tue, 30 Sep 2025 09:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3D6E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:04:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E02016073F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 13:04:03 +0000 (UTC)
X-FDA: 83945934366.09.F1BA8B4
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf14.hostedemail.com (Postfix) with ESMTP id F3163100009
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 13:04:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=J6wpB8bf;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3616c5604=acsjakub@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=3616c5604=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759237441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhlVEI2MoLfPkRucEaBmQrTt04FFRGUJh48fBB87kKs=;
	b=hxv+QoSLBFP8fROiIiwGe7KVdhDtU38yv5eZZmXEnWqV6FmNyu/4u6/KPbquuunGn+AtZl
	9RJGNiiekz3uyjupZLxFM9dGwjozr/771nZDTcRw8KkK/utBMoO+Zx06Rqq8Kc11hZHfUz
	EYAuaBDDMH87wKk9gNvxj1sucSeV8w0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=J6wpB8bf;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3616c5604=acsjakub@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=3616c5604=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759237441; a=rsa-sha256;
	cv=none;
	b=jKdl9tevG1WlpHZTDjSTgRxVKv+Io7KAYSprjFjiNS1+4HkyxIIDL8wxmYMnL8xPcsyWLG
	lblIrtd9SsE0UmT8kMdNnMxz56qo5PhRaMXKWnSUgdswC6YNLlHRay9UwchgET25+OV154
	9a0C15mWrccGKlfgWMKU1TSFEIAQHVw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759237441; x=1790773441;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WhlVEI2MoLfPkRucEaBmQrTt04FFRGUJh48fBB87kKs=;
  b=J6wpB8bfEfL0Vh5TB5VEh/UXLCa+e1MCupb6kX77wzMMknUCHofjquLK
   8yJ3A2bBsDw7v8CHZcgzxY4Wk9B4JtN5BrBviwZ9EsFYMy9pYmaD4TpIf
   zuCLK6fi92jjuWPBVUPCnV8UDgxj3PskH1nWoYsFlC1iGVeN1/GrohBA6
   gDsUq3Z2Kz52daHg4CrN8T1JWwrN9pjiMp+N9DKb6NB3XUUos0lnN8ohK
   saFZmWIL3kLdW2+iAt1pOkK9FPzbps5DqnEfAXWWhezv2FM9M4TJtcJ6Q
   u4uqg2MNfaeJNoGFT56b0Suuehby5fJgR2TlpEfECd5E07UrCpVERQGT7
   Q==;
X-CSE-ConnectionGUID: b0u3MeyNQ9mJ+sk9lFvUHQ==
X-CSE-MsgGUID: 4yr5xNxDQDOS4P53bm7vvQ==
X-IronPort-AV: E=Sophos;i="6.18,304,1751241600"; 
   d="scan'208";a="3879921"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 13:03:58 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.21.151:3093]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.1:2525] with esmtp (Farcaster)
 id 1a53291d-2aa4-4833-888d-41560634f81a; Tue, 30 Sep 2025 13:03:58 +0000 (UTC)
X-Farcaster-Flow-ID: 1a53291d-2aa4-4833-888d-41560634f81a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 30 Sep 2025 13:03:48 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 30 Sep 2025
 13:03:27 +0000
Date: Tue, 30 Sep 2025 13:03:24 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: David Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Xu Xin
	<xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Peter Xu
	<peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, Mike Kravetz
	<mike.kravetz@oracle.com>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] mm/ksm: fix flag-dropping behavior in ksm_madvise
Message-ID: <20250930130324.GA68215@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <20250930063921.62354-1-acsjakub@amazon.de>
 <d25474b8-c340-4546-a41e-60a6ecfc42c3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d25474b8-c340-4546-a41e-60a6ecfc42c3@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: d7tj5w8tbafs3st3ucpasdn4tip5q97p
X-Rspam-User: 
X-Rspamd-Queue-Id: F3163100009
X-Rspamd-Server: rspam04
X-HE-Tag: 1759237440-251851
X-HE-Meta: U2FsdGVkX1+RvbD4tPAqGvq0aqEWMAa/WX0eWn3BbjsY2B8HoEco+FjNzfwnEhvxBSRpKd9P4pSZb4BR8Jg2KVTMRMIj2yQtyhOw9cxhal+pPCO2Fkhq5nCrhVaYGoAse0MnBQpL1F4Ft9RNYN8RKSkL+guVJCJUuMxz36sX6lEWGDHGWbTGVHb6UEQ7t8pNdvHKQMdF3jHZGrm3hVrEvzXHrmR3or3Z4k7JEEmmrr9DCFLQHGBiuQPjcyd51OAHRa4rt8AHBzjWFV0EXum/BE689YSrR6fRYit4Qd0bGbpX96BL/qZIPa2lS6mZRJ86MF1u2Nm0dzMqarkzAx4HsptTyusl+JywrzKtW3RnO/u28+z2bx+5NRnVadFat5l4g1WXk11cVwjS93WZ053Kn8gye9VkdbrQj9IAdUdIRiGHd5tzIpscBKA9zXrdm4nTIoUiveswx/cek3IvW4721RjtR2zVikaEJLsXvgBFiVH1/+Nnbn7DxUmFDA537/ZphGczwd8HG/1D+5eS7Oh2ItMTuwdN04j7UJU2N69ONcxUybw0MGrJqoS4fmos/D3NLt9/HoGd0AR7GVemTFUISrvNqRaknOhiE98r/gcjZ4RtjUbmfzEgQRLOZQYmrAVaYazUHd7FicUonxmnQjJDLIOtUIshvDVIJh1rC/0qmxTiScn7y2l2MxVgeqmcjp3Ti4XOvZonGqn0JsP24EQZeeG/kSahSfiSf0BdQdKoakUxpCxawvlva776YpPix79uMt2BDzOpJJgFCYqv3dfiD+/CB3kifuNA20GjennkV1xFAdNjSWW5BVoXnb2j6M9frFNTMSwMzuVNJ6uDOU6BSJVAT7uIapwFRN0MrqO5pqoXCQ0zZgeWOlWxlmmXnTYfdCDASx4pAnw3/QP65x1Hp8Rc4lKXyICcuheP19KcmGu8YjArKkWMunuWqy8L6Z9Ck9vuDSF8I/tm823TMCQ
 tJ7MQmKm
 3DIaejNUbQYRxzbmThSboEFOFUBc2RidBDQJ6WT/oXBx4x2f7YWi0uOX7xgNvKVp0/wref7x1SIpyMzdJQoS6yooYEyWnVde4TMy8ww6Wd/WRXswNpgHEDd6HteylvLoHaKqBBOu05sHSCYsm8U4HsRnipdGYkZBYD481u+Dfb43mC9w/E48Agdx8Pw+YL/wmRcakZBhqV4oUmVwjupfmoHJ3rtMiw8VGbXPY/2fNwgM+QEQeQSzVsHTiXtTJ2hx/nd7/M6qvFk8aX3uEtt/2R5YmPsljmGMszOQqaVHk8pcl8CzmlLo6bunGdZutatagA2dMjn+sZh8YWTWZjElOtDo6vexJrwuslyr7d888+wMF/n4opaTmNCy8oKUz398MfA/KrPMvSJRBYASjqwLZYth5VAcmN6uXEIYhr+n8f/HA4CgHrsN0SKz4GIKtqqb/yhgZgKgqNfhmsrxvI72jgHEQVghW/G37WYilobrwD2jAxmcl4j5yvHLWwUpdMk5Kl5GqlC/cXxyn2bxoX5BIC+TM/ivlxLwwb9QI1X8xfaiQgCreOILXF8WNJ1/9ozc1DAcGQadsUWjVrNat8Wlhz9noXry4urdIiCHcavdZaHQlpe8m13ux7Z3iXt6iIg6V1fX5Ek6WKJT61PC9prZ8rdeozst/hXusnePkNCg+ndo66EjZR7hoFVsaE9sIAu2VQrV3Hiw/SO7lkdJhJOcox75z+av1bY6tWtQPtzzhQjNiYeXROO96pdapwikvz+hm+gSqXAi+g0qwR7Lkti9XeLlArRvhvxx1HQVz3Zd4EOUZ/mz8YgJgzEfG/Te9nn1u50LW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 08:45:48AM +0200, David Hildenbrand wrote:
> On 30.09.25 08:39, Jakub Acs wrote:
> >syzkaller discovered the following crash: (kernel BUG)
> >
> >[   44.607039] ------------[ cut here ]------------
> >[   44.607422] kernel BUG at mm/userfaultfd.c:2067!
> >[   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> >[   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
> >[   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >[   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
> >
> ><snip other registers, drop unreliable trace>
> >
> >[   44.617726] Call Trace:
> >[   44.617926]  <TASK>
> >[   44.619284]  userfaultfd_release+0xef/0x1b0
> >[   44.620976]  __fput+0x3f9/0xb60
> >[   44.621240]  fput_close_sync+0x110/0x210
> >[   44.622222]  __x64_sys_close+0x8f/0x120
> >[   44.622530]  do_syscall_64+0x5b/0x2f0
> >[   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >[   44.623244] RIP: 0033:0x7f365bb3f227
> >
> >Kernel panics because it detects UFFD inconsistency during
> >userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
> >to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
> >
> >The inconsistency is caused in ksm_madvise(): when user calls madvise()
> >with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
> >mode, it accidentally clears all flags stored in the upper 32 bits of
> >vma->vm_flags.
> >
> >Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
> >and int are 32-bit wide. This setup causes the following mishap during
> >the &= ~VM_MERGEABLE assignment.
> >
> >VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
> >After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
> >promoted to unsigned long before the & operation. This promotion fills
> >upper 32 bits with leading 0s, as we're doing unsigned conversion (and
> >even for a signed conversion, this wouldn't help as the leading bit is
> >0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
> >instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
> >the upper 32-bits of its value.
> >
> >Fix it by casting `VM_MERGEABLE` constant to unsigned long to preserve
> >the upper 32 bits, in case it's needed.
> >
> >Note: other VM_* flags are not affected:
> >This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
> >all constants of type int and after ~ operation, they end up with
> >leading 1 and are thus converted to unsigned long with leading 1s.
> >
> >Note 2:
> >After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
> >no longer a kernel BUG, but a WARNING at the same place:
> >
> >[   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
> >
> >but the root-cause (flag-drop) remains the same.
> >
> >Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")
> >Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> >Cc: Andrew Morton <akpm@linux-foundation.org>
> >Cc: David Hildenbrand <david@redhat.com>
> >Cc: Xu Xin <xu.xin16@zte.com.cn>
> >Cc: Chengming Zhou <chengming.zhou@linux.dev>
> >Cc: Peter Xu <peterx@redhat.com>
> >Cc: Axel Rasmussen <axelrasmussen@google.com>
> >Cc: Mike Kravetz <mike.kravetz@oracle.com>
> >Cc: linux-mm@kvack.org
> >Cc: linux-kernel@vger.kernel.org
> >Cc: stable@vger.kernel.org
> >---
> >
> >I looked around the kernel and found one more flag that might be
> >causing similar issues: "IORESOURCE_BUSY" - as its inverted version is
> >bit-anded to unsigned long fields. However, it seems those fields don't
> >actually use any bits from upper 32-bits as flags (yet?).
> >
> >I also considered changing the constant definition by adding ULL, but am
> >not sure where else that could blow up, plus it would likely call to
> >define all the related constants as ULL for consistency. If you'd prefer
> >that fix, let me know.
> >
> >
> >  mm/ksm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/mm/ksm.c b/mm/ksm.c
> >index 160787bb121c..c24137a1eeb7 100644
> >--- a/mm/ksm.c
> >+++ b/mm/ksm.c
> >@@ -2871,7 +2871,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
> >  				return err;
> >  		}
> >-		*vm_flags &= ~VM_MERGEABLE;
> >+		*vm_flags &= ~((unsigned long) VM_MERGEABLE);
> >  		break;
> >  	}
> 
> Wouldn't it be better to just do
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec75..0eaf8af153f98 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_MIXEDMAP    0x10000000      /* Can contain "struct page" and pure PFN pages */
>  #define VM_HUGEPAGE    0x20000000      /* MADV_HUGEPAGE marked this vma */
>  #define VM_NOHUGEPAGE  0x40000000      /* MADV_NOHUGEPAGE marked this vma */
> -#define VM_MERGEABLE   0x80000000      /* KSM may merge identical pages */
> +#define VM_MERGEABLE   0x80000000ul    /* KSM may merge identical pages */
>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>  #define VM_HIGH_ARCH_BIT_0     32      /* bit only usable on 64-bit architectures */
> 
> 
> And for consistency doing it to all other flags as well? After all we have
> 
> 	typedef unsigned long vm_flags_t;
> 

Makes sense, sent v2:
https://lore.kernel.org/all/20250930130023.60106-1-acsjakub@amazon.de/

Thank you,
Jakub



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


