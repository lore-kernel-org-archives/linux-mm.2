Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01DE9C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2596B009E; Fri, 11 Sep 2026 21:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94B66B009F; Fri, 11 Sep 2026 21:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA996B00A0; Fri, 11 Sep 2026 21:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60B926B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:25:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F2C71203BD
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:25:03 +0000 (UTC)
X-FDA: 85203366486.18.E1CBF21
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id C42BCA0009
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:25:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FImGN4y1;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.5 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWOmbgU/cXl9zYssMUB/cx3MltvPnlZGgjW9s6beYp4=;
	b=n5KY64iYIQFL0Tk6VFWbCYreQPhD5WL8E4Y0Yzyhv4Kgzm39a+oBXToiBpOe/aQA7O5WYV
	cmdwMQKaVU868LMeRP/cRxJdjO6K4/oU9Fcf/KeVHk43B1tmNgzWfQ5P2dtQhX4woY6d/o
	u7JoCiPyvH53JLj5xY+MS9WpnT4nhUs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FImGN4y1;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.5 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176301;
	b=q9E51E06d4E2v5++Qv2ukdytvgxX514laNYuyI9u30+hDkwT7T/L9TCX+VY0GCdfYEYwHp
	pCFhWQmR2rF+FfATysv1+Tt+WYK+oU2jw9MVcOwSwXGrnEKTmtDizd30/uZuVHzNJM3g/n
	lxuJpXvmBe5eDNlAxwmz+U8flrbtsTs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789176301; x=1820712301;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YOk3cxlanGIdTmLtQtPKJDwT6LnOdcC7uVqrLVzgVRU=;
  b=FImGN4y1Uta77wW6PCA0JhUBxCV5Q8W1VzNCjPxoNK9tpVaZMg08rt+i
   ofwjtNNDlKlefUnTaFsTZTiN5XK+v920jtaZ68OLciQYGc17hFUlNClUo
   6p5Fc9GWSM7iSGiAYk7DTrqYYeF8dghkXCAyDUJ4vh5uDPVCYNN8AmEjF
   BuDrhodkzGQ6yb7G9rhAEC+VZNdyUfp+dM+TOFjwEiQxhy7/N2h8PYekC
   gBXsr7oGBYvMu78WuJb0ISc9Rw8IZ0k0ePHhSqvEm4klSjqxEUUhjo2ia
   sdXJEt/+MuRcnJ5+xZWiAm2N4yZh5od+FHsQ2O0rex3utVmDNynqxsPon
   Q==;
X-CSE-ConnectionGUID: Lv1Ywhi6RhO2NekDsOEz0g==
X-CSE-MsgGUID: 6ZwnUzOFRRqEHYu7l5E/gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="148697"
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="148697"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 18:25:00 -0700
X-CSE-ConnectionGUID: 9W4u8baaQ/CzWlAcKyP6gg==
X-CSE-MsgGUID: iuQBu0n/Twu1nungr6zV7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="272047984"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 11 Sep 2026 18:24:56 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x5CU2-000000002VF-0PA5;
	Sat, 12 Sep 2026 01:24:49 +0000
Date: Sat, 12 Sep 2026 09:23:35 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Ingo Molnar <mingo@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] x86/mm/pat: use pr_warn() for early W^X warnings
Message-ID: <202609120931.Bo3Gyiqu-lkp@intel.com>
References: <20260911-fixes-verify-rwx-v2-1-e2cde39b6693@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911-fixes-verify-rwx-v2-1-e2cde39b6693@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C42BCA0009
X-Stat-Signature: i1ruqinjbtea93ntpu31crzne5osh85t
X-Rspam-User: 
X-HE-Tag: 1789176300-391655
X-HE-Meta: U2FsdGVkX19e9FfUbMxoL9Fv7DlRuBHQBxxnxgcWxadp/SbGnwl0wFkwZMl+H8Xp0kXY0wJlNw7mCiZqL4ljlZFgGaaoq5tE5++qvU887Op8Ks2fu4Y2XT9Lob2405afbSGEPmDYE5uyr92hD5XNDRRqHenu/DSBDVrrVI0WfpiQZYMy8njI5ulyyltO2sO3AICMv+rElqOUXLXdEsPHoSIGqoD9RmECK/maulwYkNeiy4/1xPH3utqgUaUAH8q9RAuB0d6ePM/rpiNkgiXiG0Vl+pqoPJ3S6gPGQ6v2o1/1C+il/HXoeKOQtTZHcQbnh5yEQamhM7u/fWOL+27w8QQCXLgqrmRF4MDSqTMBa50JZlfdTOVOWEKKC7m1UeN+p2J8PN37wlNJldtHbRCdAq+pXpsoHhFhRBBamJpDeDtRKr8CEkBSLUI9Y/q1y4mhcj9BTBtwrIlkgUmbHBp6kebWPZ2u2hvplOyCv8D7q9ISHaasRxPZKUYqdvQMgkblY47eOMbkwc0BCUkm/YQp9LuN5r0p8FGzvJn6V9hZsGmA3GQUmuKzXPciaIoCESEhvwC3VX2YcRTy+7dFRszKNGrfBAPj1A4+80K3acWSsjvv1adEJDPF2/ZrFuXpLIMwVB6voQlEISkh73U+SnOrT/j/TcXHREOJ4C8pj3ULSwvNl0OP4HbtJ8Ai/IzNO/mCK1vo7+/gsIkK3Mipq9Sm9OKann1hEAV657P47opBwcNxB+Gzmgjm+rtb2fdVnWzejPINvYT1m1jtDN5lzLYOUCRzpjcCQ8D/UzVAuFEKQ4EtVFg1cKC36CNPBXxRY9kt1KPToqegIGRHg33MoaY69zd4KII0/+vco1kNJibmTgcK4bSeqNck05MQaOIeB9KbBtsF0qoy0+/73B88pEjNIhQ/H35zOiLY6jrMP/KsedIgAz2OMKAv7LI2jcJsZu43ONkXpQQQLCfAPT8/Zgu
 TjclTYuM
 vDR+6jXBTjdGr78wjKJUZTDAMPcqwRsWWoxW24Oo0koBB60rOaDSxD1W7+JzvpjFXehl1e8HkZeV/ZIjtXW/ZWmYhaAo+xHpouzwur7rnF9jSfeiPQXzmqQoXFaMMcvkJsP4NGEJe+o+nPvc5k9DOZoTSDSm3KJLexQ9D9mQtKp8/xHXQTnrDHfJve8XuJohpTSXj0cerGqGCw2q6UwAa/rvZAoZPNK/dlmcGJxhGNf5bhISHnpa+gV/l+O91WdcW/yRp7uq7QsImBJYvenX3/hsecGw4KCg/hj46lLieM7m9yoO2t28WxRPtvpsZXJ70KsA3vLAuKBRDK4lH2OFDJTlqB5kxncakW+UTrTncJBHeOxfgwcy8qx+3lw72wF99VvO6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

kernel test robot noticed the following build errors:

[auto build test ERROR on ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Rapoport-Microsoft/x86-mm-pat-use-pr_warn-for-early-W-X-warnings/20260911-142843
base:   ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482
patch link:    https://lore.kernel.org/r/20260911-fixes-verify-rwx-v2-1-e2cde39b6693%40kernel.org
patch subject: [PATCH v2] x86/mm/pat: use pr_warn() for early W^X warnings
config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20260912/202609120931.Bo3Gyiqu-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260912/202609120931.Bo3Gyiqu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609120931.Bo3Gyiqu-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:31,
                    from arch/x86/include/asm/bug.h:195,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/barrier.h:5,
                    from include/asm-generic/bitops/generic-non-atomic.h:7,
                    from include/linux/bitops.h:28,
                    from include/linux/log2.h:12,
                    from arch/x86/include/asm/div64.h:8,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/fs_dirent.h:5,
                    from include/linux/fs/super_types.h:5,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:5,
                    from arch/x86/mm/pat/set_memory.c:6:
   arch/x86/mm/pat/set_memory.c: In function 'verify_rwx':
>> arch/x86/mm/pat/set_memory.c:708:30: error: expected ')' before numeric constant
     708 |                 pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
         |                              ^
   include/linux/printk.h:483:25: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'printk'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/linux/once_lite.h:11:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
      11 |         DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/printk.h:650:9: note: in expansion of macro 'DO_ONCE_LITE'
     650 |         DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~
   include/linux/printk.h:669:9: note: in expansion of macro 'printk_once'
     669 |         printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~
   include/linux/printk.h:669:34: note: in expansion of macro 'pr_fmt'
     669 |         printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                                  ^~~~~~
   arch/x86/mm/pat/set_memory.c:708:17: note: in expansion of macro 'pr_warn_once'
     708 |                 pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
         |                 ^~~~~~~~~~~~
   include/linux/printk.h:483:24: note: to match this '('
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                        ^
   include/linux/printk.h:511:26: note: in expansion of macro 'printk_index_wrap'
     511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'printk'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/linux/once_lite.h:11:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
      11 |         DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/printk.h:650:9: note: in expansion of macro 'DO_ONCE_LITE'
     650 |         DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~
   include/linux/printk.h:669:9: note: in expansion of macro 'printk_once'
     669 |         printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~
   arch/x86/mm/pat/set_memory.c:708:17: note: in expansion of macro 'pr_warn_once'
     708 |                 pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
         |                 ^~~~~~~~~~~~


vim +708 arch/x86/mm/pat/set_memory.c

   667	
   668	/*
   669	 * Validate strict W^X semantics.
   670	 */
   671	static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long start,
   672					  unsigned long pfn, unsigned long npg,
   673					  bool nx, bool rw)
   674	{
   675		unsigned long end;
   676	
   677		/*
   678		 * 32-bit has some unfixable W+X issues, like EFI code
   679		 * and writeable data being in the same page.  Disable
   680		 * detection and enforcement there.
   681		 */
   682		if (IS_ENABLED(CONFIG_X86_32))
   683			return new;
   684	
   685		/* Only verify when NX is supported: */
   686		if (!(__supported_pte_mask & _PAGE_NX))
   687			return new;
   688	
   689		if (!((pgprot_val(old) ^ pgprot_val(new)) & (_PAGE_RW | _PAGE_NX)))
   690			return new;
   691	
   692		if ((pgprot_val(new) & (_PAGE_RW | _PAGE_NX)) != _PAGE_RW)
   693			return new;
   694	
   695		/* Non-leaf translation entries can disable writing or execution. */
   696		if (!rw || nx)
   697			return new;
   698	
   699		end = start + npg * PAGE_SIZE - 1;
   700	
   701		/*
   702		 * If the kernel text is still RWX, gently complain, this could be a
   703		 * false positive.
   704		 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
   705		 * the warning can be removed completely.
   706		 */
   707		if (!kernel_set_to_readonly) {
 > 708			pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
   709			  (unsigned long long)pgprot_val(old),
   710			  (unsigned long long)pgprot_val(new),
   711			  start, end, pfn);
   712			return new;
   713		}
   714	
   715		WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
   716			  (unsigned long long)pgprot_val(old),
   717			  (unsigned long long)pgprot_val(new),
   718			  start, end, pfn);
   719	
   720		/*
   721		 * For now, allow all permission change attempts by returning the
   722		 * attempted permissions.  This can 'return old' to actively
   723		 * refuse the permission change at a later time.
   724		 */
   725		return new;
   726	}
   727	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

