Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D342C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA926B00C5; Mon, 13 Jul 2026 13:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A486B00CB; Mon, 13 Jul 2026 13:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252F86B00CC; Mon, 13 Jul 2026 13:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAF0E6B00C5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 432E3140110
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:57:24 +0000 (UTC)
X-FDA: 84984510408.11.7276A58
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id 792D080006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:57:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C8hsZk70;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783965442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkFtwRM6EqSLDhlZ3nxC2y9VCntrk0ZO1b0TtAWox3Q=;
	b=zw6sQdhD9eMgRzP+uYpOq0ZbgXO2AWh9r/vhBuNeStEUOOkZGePjp978S884bJEhU5njtn
	X44J/k4lTA/+Y837Oa7HLv4XRYeiarMGAuKs3fXwLhd9uWNaJCMgqS14hty1uephZvidB8
	9/P3/ickZ/3qOgNuA7AGKkz9W430Jeg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C8hsZk70;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783965442;
	b=rz4wLRQVEuKKMBbvwbA7E3Kbx2uKOWyPzhABDdS/I5sY37qL9sGL3nCbf8HUSygR5hko/T
	Ot2FyGBYenEPjwhoLvf5WgvZZKCUfdsUvlzcWNRQtljEs/9wlTsfmtWqnCqNEEaV87JHBJ
	JgCENV5wNAKlsrxMNS5PtRrBE0zbp34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783965441; x=1815501441;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WRbL80hDPjLf7xZO/c4mZwcWwZ2vjIKzQLFiN6cVkn8=;
  b=C8hsZk70BM7pauzx3UjSXvR764oMNGxqzT/UC6MToBS+L+uB3JoHL62+
   VKq63COJAWXPNLjSiK89SXDvR32jkAfouzIbwhArnHeJnPY8FE/kXZgSR
   /rI18kD5nxo3RQCsgRe9ImABUMF2M2BlS7gaJclyVs1+xqSlXQn2VPIq1
   s83mqYm/7r9ddk/Yur5cQVJiTjUE4yuDC+MNJFQpnL/QiodpF/LEdxWyT
   iV9u23JM8JdWf80OdvaDeLUuPBFuFfR7suB5Nr2ex6zrJzoZkpHK/2/2s
   KryOUY6SMONj/8a5OOQTrB/wCiKA3HM4/0/uFKdQejbsta5BosT/0c5H7
   w==;
X-CSE-ConnectionGUID: 0v0j4V60Rd6SoPH4w02bOQ==
X-CSE-MsgGUID: Aj8H2ntISEC7LUuWNQKemQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84459238"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84459238"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:57:18 -0700
X-CSE-ConnectionGUID: pKvhLf9LTu+eHV+HNZK7iA==
X-CSE-MsgGUID: BWtH56OzTBSLHcmLMAMQ4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="255108504"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.108.83]) ([10.125.108.83])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:57:16 -0700
Message-ID: <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
Date: Mon, 13 Jul 2026 10:57:18 -0700
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
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 792D080006
X-Stat-Signature: sa8tyydp68xpcf5c64xs7nbu6jxp8ip3
X-HE-Tag: 1783965441-176450
X-HE-Meta: U2FsdGVkX18vnA5WNtap5BJag3teiuxa241z3jEK+spj3x/skF5EML+hXfIvp+yhOgEK70Xzs4ZC3ofxEn7pY+IzmWuKpfCx3Fte8x99BStfX8ojl1xJOBqEfY1SdmuO2Fa/sSYVuORWNn95/ptXYPxir/TVEpcjcd5XST9mMN4nVPT8O8eGMh+jc0nvYxcuPgfPbCSs/KmLNQfsISsuiUzendV2/4NQ+42lQJ6xLVLeldF/RUNZK22+EU+22HtgA6dINID+tUTj2zGfn61TZYYQVsHm83Yg4LmyYZwpt7TWk9sczi1GMMmz5hrh2GuM5DgLx/7ock6POpD2BioEEPaIit6wCvH4+xyW7w5S6hnszAFgWdeIR4W3Qbacz0u22x/eSg0MIVlg0o6j2CfWd6n+OMgUgLZO/V4bBF+JXajCqjfeMMdLyMrW9p5V1s7EnDUUvTQ7lnvuVzruGC50Rd6hKZiWUv2Iw2IcWBr9e2z3hEg+DrQFazdOHMfgiZshxPSTROLN4lqsWMylApKoJBYxsZW/DUeJwf3P1DvzaitI2TyPu5f1V77sbTQOoUSS93VQ3f7OdS/Mc2iI32Rpa3NGqMGdQiKreO1zOPWbPMStTr/5PfrLdWxRn4Cjnz0jBlAtBVe5MDwkXVTTgAZLx8DQtRq9jYFVpBZtQJYc013w6L2MF/PtqyT6qNjGziU+0OMTv/5sZ+1inwGgacYpCbTcKvlp8Uj/SytwInvVxfkjaxQ1/wwT7DPWEc42CWUDsZlpbs3m6Cb4YddZE0MaFSmBaq/Op2nWIYDaH2X7Mr29AduHJBuq/k1qLnZLb9qFjAmazBH4UrAl97sIBuublIeAZ0YtCQgTDQ2e8k7LKzdfktSd/1oLzMr1MdMR2wQsbBxpmWB8qTa3l23MvvEEKb25hzC79cQewUVvo3A3hkSqJtn3recMqIpUDQBvEmSOZ+3X1vO5OMwY6vZdEdn
 7G5skUgZ
 B4NRfDnlRvkf9fEqnIW990DRBUdl5xrRVemTh7GCF/u4ykttbZDAby5oqABj+FJeCS/VbDPb0YeRiiqFU2vEetHldHaG3QVtO3CIGtmaHR5+RPGUlePJuJJyaMgqxcwCg0MBwGPgEPmGc7PqwhSv7zt4ihZ1sa1ifO43JpCNDpRv+HmbTVapu1425kEYhNx9A6PIBRZ+JecgBCL7gaqTGb1k5pG16en3Vkbb9csAmdvvxbaOgFvdtstW04oTejKaBLyhaw1rbEWLBoG/f2a4/l9kQGHdj/Vo6QNlTeJk+dEO3oEHeCx3ppcIbzW30+iWYjwKI7qJWIIpY450=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 08:02, David Hildenbrand (Arm) wrote:
> It's always been the latter:
> 
> 	...folding => PUD => PMD => PTE

This is kinda arguing semantics, and there are different ways to look at
it. But I'd argue it couldn't *possibly* have always been this way.
Linux hasn't always had a PUD or a PMD for that matter. The i386 only
had two levels. PAE support was added later.

I think the pmd_t came with Alpha support (before my time) and pud_t
came later IIRC. I'm pretty sure Linux didn't have a pud_t when I first
started hacking on it circa 2001.

Second (and again this is my subjective opinion) a pgd_t* has always
been the "top" or "base" of the page tables. This is why there's an
mm->pgd and not an mm->pud. We've also talked *forever* about things
like a "special pgd" for the LDT remap. Or having two pgd pages for KPTI.

My point is that the PGD hasn't itself ever been folded. It's the top
hardware level of the page tables and always has been.

I really do think this series is changing things, not keeping them the same.

