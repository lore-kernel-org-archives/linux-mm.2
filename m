Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FC6C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 20:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D776A6B0005; Mon, 13 Jul 2026 16:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D278E6B0088; Mon, 13 Jul 2026 16:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1816B008A; Mon, 13 Jul 2026 16:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA056B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:27:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17EBB140127
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:27:55 +0000 (UTC)
X-FDA: 84984889710.18.2E55EC4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2023680007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:27:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UPPTFQf5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783974473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEL9o4oj+7QJVOgjtaY1l4iX0AcJInhNsGxq/Bo6fVQ=;
	b=AmPWgSGul29RFP2bKL/IfsNsIQNQQ7uU2pUwM4kgkw0b1m47TKxg9jfiSZkZvdn2yP/YMj
	uA5bcUuE4WCnDsMi/m2eBhp3oD5BLPgisj9K5klKssckd/kw5lBpP/Dchnw9lOkMb82JoA
	CZN07nKp85mLHoM7FUbANa0BtzX0SKo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UPPTFQf5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783974473;
	b=3NFIWn+jIdcYrwKmmSH+ZaKseWuD+o6ZQanH6UP8/L8Ob0SrA5CVXj4ZXGXYkGqkEwCxAM
	aqtd9NzNvEKe33Zg8xN5asz4wsaglh8BEnPzh9HiLVKFHgHFv8g6sJAOyjDQxNulupKkKo
	Kr66wDPy11u+IibaNNj4bDNbWiNzEPc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783974472; x=1815510472;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9NQjd/jk6+v84khxZ0meBR6vI+LsryE+M1M3ljZVeFM=;
  b=UPPTFQf51tjb1LZ7KcJNgYFeQrU4yNBpw6Ruk0hh+QwU7KwryYgBTYUM
   7JyYRPee3n6Et7oYeRePT2w/uJKbFXFjc2Olu2/6xdtLnaUm3Hyvj9S4r
   R+SMBebLewB0IxY4QHSTel5j62DCU/YqnAl1U9WnPHGHH4vigR2b8Mr+t
   4FE/wc6Z+YSB/UlIfS1SyR4unhZd6GhViXy+iquVSXPrkJ53F3w7XHn5R
   4i8WldSoewcDcc9/YZVM4zg39QxA2kS9tgQY+O47L78ZuELWTa1hMJKTh
   ty4fBaxWz/1qoLq4hazFjuLppQckM4BhWGVXgGLZwvN6rQxtTpfJ11TgQ
   Q==;
X-CSE-ConnectionGUID: IdulVBS1RImq4NOTLqSQMA==
X-CSE-MsgGUID: BTW6wAevTdeHxYeaeyj0tA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88491874"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88491874"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 13:27:50 -0700
X-CSE-ConnectionGUID: ZEybRRX6RJqQVVjAf1A2oA==
X-CSE-MsgGUID: luU4O+FGTuKLe67iRwRvGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="260536451"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.108.83]) ([10.125.108.83])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 13:27:47 -0700
Message-ID: <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
Date: Mon, 13 Jul 2026 13:27:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-11-yeoreum.yun@arm.com>
 <c3edfb13-08ec-419c-bc05-8f3f64186b24@intel.com>
 <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
 <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2023680007
X-Stat-Signature: goy3zrep86187qjpzwqoeh8zw4skufch
X-HE-Tag: 1783974471-752939
X-HE-Meta: U2FsdGVkX197yG0CP8IIFMMEUK/kDGEO/+xWZQvCzIu2qPkayShgzTILA3LliuMR42zIDLUCfLRlT/3iB9B6Pvl/uuFJ+UPJK9L/ng7399PBYtn2pv/IawxMf/xS6gJ8c1u8qveZTgNE9lTkDpohFSIsaSQeVlh1ef5hzgFo7eU9VGMsp37fjSn7Jsaa6SPLGzsGyYTNAVc3EwEPSvNa6STIfZ0EcY7pwQucvEi1tqPE++VQeEQvKhUEXHngZfNmjSsjbv18Dq87ui/EB1+cg1ZXAbGjIwljaG4kmOhybswq1X1R8gzadeDV049CDEMFbWlA/Nd2Unljq5rGLZBAX6KoxOxlUGQ9ub/0dXWB9T0uW4xYs1ulFIAAfecqXwx4aL+OHR2xniP4DSiYExJvBSYBxY3UThMKsjNx+0WTbTPQ8DYx+cnAuc3CLDE5imhbhfoxo6/joRwSruT+r6VZcuBoHlODMFxqm/6jnwgRHlSHumhdB/jbD834WYkX2THyzU0DZLoG7Ang9VUDDZEzPf6XJ4BX/M5cv7n1E4FzByyK3FZbSAQxvWvsASiA3oIwLI2LnTSa1VxguX9l2wEYu99oezSM4SPQYxoHRUjZfkLvucMc1pJ9ZcQe+KnQghGyr6Zy0s6LMnDH2Q+aVhYut0AtkgzxZiFVMcIyMbqTKGhsw9b1YFgzvHbKx7aR1H4LzmZvSUHiOf85twsIRciCYxa9YmFvqlJqk8V+kCxSpMpemY9dlYtOBVmDgIcUJ9fJIljHK+QttsFMez4QrhyBVaTX60tJXMdMeS4lNrMlA8vmVtC35ERifr5gvhN3kYB27501rDGaieiIv8TiAurJvuP9ATDl2rLel9I+g78S5912oJc9lQWzjBrqIkC4T6adiGqN18JXWgxE2akWszS8nYopA4on3PCOQmgvrnfFx1b20x4TlLZ3BabptLJKdIym9QY30a6LbiLnzrSIDUf
 3dVCksLd
 mJ8ucCklIPEo7tVN98Qsk5PQsupP65UEK227CJcmoRNRIhK9jb3Y7PTFqoS59WN6wiyj2GW5gu2l1vvkeahwneyVv2IvVMu4QWbEH1I2bZm35MP2tIBktMGvouhPfYnIK5oT14p7AxoK0vhIZATs3xkrI3YLWKRI307S99QCi7M1jB1Xd1xxMPmQz8qf1LOsMuvOGd0O26keQaRmoY2vqc7558TiTt6SrjQl1D1PSTnQduKs2Vcc+KOVOwncqnc0jKuEypmhDixffb4RpoRK56VwLsXxOmTeWohvc6yc7TqWWzBYM1HPIipX+Ip5XUoI9nZc7/U51qgMs0KI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 12:49, David Hildenbrand (Arm) wrote:
>> I really do think this series is changing things, not keeping them the same.
> Looking at it from that angle, I tend do agree: it further moves into the
> direction that actually the p4d_present() carries value, and the previous
> pgd_present() is just a dummy.
> 
> I can see that some more work is required to untangle the mess we already have.
> 
> I don't know why pgd_present() was made a dummy function and not p4d_present(),
> but I'm sure there is a good reason to it. Changing that now ... omg.

Yeah, the p4d addition added even more wrinkles because it was the first
time we tried runtime folding in addition to the historical compile-time
folding.

There were certainly some ugly corners of it that we never found a nice
way to fix. I know Kiryl tried pretty hard.

But, zooming back out... I don't think this diffstat:

 31 files changed, 329 insertions(+), 206 deletions(-)

is nearly justified to eliminate one virtually guaranteed cached memory
read instruction. "Unnecessary", sure. But, worth the diffstat? I'm not
quite there.

Also, I think a series that adds code like this:

> -	if (level > 0) {
> +	/* Ignore folded levels ... */
> +	if (((level == 0) && mm_p4d_folded(st->mm)) ||
> +	    ((level == 1) && mm_pud_folded(st->mm)) ||
> +	    ((level == 2) && mm_pmd_folded(st->mm)))
> +		return;
> +
> +	/* ... and make the actual first level remember the protection. */
> +	if (((level == 0)) ||
> +	    ((level == 1) && mm_p4d_folded(st->mm)) ||
> +	    ((level == 2) && mm_pud_folded(st->mm)) ||
> +	    ((level == 3) && mm_pmd_folded(st->mm)))
> +		first_level = true;

fails the sniff test of being an effective refactor. It unquestionably
makes _that_ code worse, not better.

If the series was:

	Subject: Refactor page table folding in all architectures

and we had a discussion about what the best overall thing to do for all
architectures is, I think we might have a better path forward. It would
also be a smaller series.

To me, the double READ_ONCE() is a non-issue. Having a nice, coherent
page table API in the kernel is much more important to talk about.

