Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30089C5CFEB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD396B00C8; Wed, 12 Aug 2026 06:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5236B00C9; Wed, 12 Aug 2026 06:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA9D6B00CD; Wed, 12 Aug 2026 06:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B51E6B00C8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:25:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D4FF140240
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:25:48 +0000 (UTC)
X-FDA: 85092236376.21.81B3E2C
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	by imf21.hostedemail.com (Postfix) with ESMTP id 554AF1C0005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:25:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aegPKZyQ;
	spf=pass (imf21.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786530346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOuo0kLBfTaW0LoLZDyKlhu1xxxUaNKKmsbb4h1Z+40=;
	b=5VNx9WOf9S+jOsLbY5oQE08Kd1V71AOoFoCqY5diAm1DoW5oQUlkiZ0qpcRHPJP2x7bMGO
	HcrTfS0DjUCQ1hc+NLXeBVj66Y5wyRNb4VZct9zuM7bIUCZtTEz+lbz1h8riMA+DUKcPMA
	PxA+oNU2gQwLyRm3qKqDKzcwB7LjGHM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aegPKZyQ;
	spf=pass (imf21.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786530346;
	b=5pdSk5oyUgIyAhC92fgedfB1onHaulI01WfsNMpMAzvyKpRr5OT4ktVIsbdwrvWqVMYVBj
	Oruj7bnqokcOinfWHtMkMz8Kgf3Zx5aLMKZ3v1GJU5NGXxQh3fn0ptnip5a30qlIFTXDoT
	58WDuayUISR1njIesNETmzYXPvW91Bs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=q5MYyeCMd7o+EpTB61t9PlYNh3ovoXInblTdWVqkpxw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786530344; v=1; x=1787135144;
 b=aegPKZyQC3yD3GZxw+b0myQk6Io7ghNqSOkWfkMn54+5yDFtxrH1J9lFWIqSSknnKlUQe/ZP
 lKNrVW1u2YhfDDbJ4mWtFWqvOubD7pELATkTOBYi0OInJFnEHXXF961jmSvhMf+i17O0Xt3EdF3
 /IR44tVNmdMzcz0b8GnF1d4Q=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 1b4a02814f740c27;
	Wed, 12 Aug 2026 10:25:44 +0000
X-Migadu-Scanner: mta11.migadu.com
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	shuah@kernel.org,
	ardb@kernel.org,
	chenhuacai@kernel.org,
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
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for virt/phys translation
Date: Wed, 12 Aug 2026 18:25:32 +0800
Message-ID: <20260812102532.32673-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2vxzfr0l6fam.fsf@kernel.org>
References: <2vxzfr0l6fam.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ef6i6awu3fyw3d8fbth47o3weg94qguo
X-Rspamd-Queue-Id: 554AF1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786530346-34301
X-HE-Meta: U2FsdGVkX19AwgU4WHpKAD6jVdFWqKYtYZ1t8ZUqXutT8R1HkCF+jQBbw5cX2GkKAZ9w8Fp22oU4USWeU7YRKh4q6VfbGVBNmtXXxiIFr/LryDyxv0IO6Inj0QogQGbProVHnWfmEyVY7YJOsPBTuFkk01zfvzNVHpDGNlOrnjE7wzJggpDGo+vIWJMR5giklDQA7EbdO4DXimqcqGGRYq4XsR4X/hs9sKjgCHhVI0v4OJNgqtwFZ1+UAypBJi8ApS1jATgoHEgYqrNN2U+uVm3k/pCmmcdI5E14XSh5OWU0LlUpQF1yhyucMPmSwJinlKMacXO3PLRxOMJQ5pdHryT75CWwnZABSPrG6NDoWA4Apn1JKCHicjOWZX3D63SUZZujcpCuop44B5+ZUMTmR/Va52bjS9D9Pf1T1BDFZ0kusw5jOobw77XPbSZivILqWm7ekem7eGH6LC0tcU2mf5cIPkVUOzfdPWqODP0ePgnake25DgDob1go8TbTqj+wnylOguIJ79BQT4ex+OV9/Qz0/vBXBWutCDe0ums0pdn96FeECouII2CyqD5eJ64dJjNlna8Ux62s2mvFX4aRkpJXJz9hvRxpLwt4T6vvW2MbVjjk/7IGizopfPqSgBR0JZ6IzUQFfDOOdmS6JkhrqPnT2B5eVWOM8ktxDN4baF8YpTJQrpZeAcLZyY/PmpWWGEaM0xdIAwbr6dAlMMrDb5VTBSYXSg6EK+qmcux0iy9Z8KFPLGtw2gXuqsD/+8uJDARisBQwRiim8fpvqlbLaECx4hRMSnUzpMECVwx5GNjAYqPSpaZ2oZQbNFD/xWq/HmwRwzkw3+wSSsuz7RTMghlNzP/kxRRjOCEEyyA7ub1EtZz6z13Ayi0M08EGfgvAv1niJ4kqFCMk90DDTbUZ7PGsfMvmiAd8Z1ZiRxkQN9BjVrf4w4krIXVOBn7AEhTeIc5KPdXsF/8+UiGCHGZ
 kfreAsgM
 TQb0GPuVfYDJ51gNXLNFUi5k+6fPQtKpQQu+x+1ic930m2K8YrfYn1ZD3j4iHr8kMMEHdZhDhp9eh+fQoyTOswKGv22W1wAWC0Is2f60xMIjSe74++twiP5Yt+ovkXbM35SqIssIs8qlWUb2+qySBBupz9nnkp04fZtvBcHLZ+xQIEOS1ziTfLTdxNVyrp3ZI2/L+EMJNRA5M3IZ0CCwGM0BEMxBzykUMvDPtIl4K0oG6StsaQnXWq9ODjHWcf8LPqpOdBE6CR9y4JRpaZR+FCB0oxPVm2l3nesS9/vyFj/maGY9RZV6RX+ywfZx481IKslztEqsW7980OU1hoUqqLDkmdW7mf/T54/zSfqLWTnEkErETpwXUP4yPXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

You are right: the current luo_session.c does not call virt_to_phys() or
phys_to_virt(). I failed to update the target of this fix when rebasing the
patch. The calls that trigger the current failure are in
kernel/liveupdate/kho_block.c. Sorry about that.

I also checked the include chain. asm/kfence.h is not included by this
translation unit. include/linux/slab.h does not include linux/kfence.h; that
inclusion is in the MM-private mm/slab.h. Moreover, asm/kfence.h itself
includes linux/kfence.h, which includes linux/mm.h, so
arch_kfence_init_pool() already has the required declarations.

The actual failure is:

  kernel/liveupdate/kho_block.c: In function 'kho_block_set_is_cyclic':
  ./arch/loongarch/include/asm/io.h:81:9: error: implicit declaration of function 'page_address'
  kernel/liveupdate/kho_block.c:210:16: note: in expansion of macro 'phys_to_virt'

The underlying issue is that LoongArch's CONFIG_KFENCE version of
phys_to_virt() uses page_address(), which is provided by linux/mm.h.

Your broader point about fixing this at the architecture level is valid. I
previously tried including linux/mm.h from asm/io.h [1], but that introduces a
circular include through:

  linux/slab.h -> linux/kasan.h -> asm/kasan.h -> asm/io.h
  -> linux/mm.h -> linux/slab.h

As reported by the kernel test robot [2], this leaves kfree() undeclared while
linux/mm.h is being parsed. A proper architecture-wide fix therefore requires
refactoring the address conversion helpers rather than adding that include to
asm/io.h.

For this series I will move the linux/mm.h include from luo_session.c to the
actual user, kho_block.c, and consider the architecture-wide cleanup
separately.

[1] https://lore.kernel.org/r/20260521063310.52926-1-dongtai.guo@linux.dev/
[2] https://lore.kernel.org/r/202605211925.DbDvQ6ii-lkp@intel.com/

Thanks,
George

