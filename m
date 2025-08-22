Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893BFCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 10:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A066B01B1; Fri, 22 Aug 2025 06:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EE68E009D; Fri, 22 Aug 2025 06:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0436B01F1; Fri, 22 Aug 2025 06:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80BA46B01B1
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:26:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B182BB046
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:26:44 +0000 (UTC)
X-FDA: 83804014728.03.5364EC6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id 880AC1C0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:26:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ljw6cBxg;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755858402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gtaNEgEO94d5VNueVImI/YaGYs7ylINRCdVXoB2Q0k0=;
	b=SExeOpENBZWBzzMvW8YmAshSC3KWIkberfvC9Jp4XXskBXWESsuqlp+kTB2brGEODLAJiA
	Ej4iJYzmI52s44+wqSEQruU0eSY+M2Rc28P8CXjmymoiSBXPE06H/ktWsQC3eSncnhXBBf
	mfG5GDQoK1Wq5cX0pgLOsrYo3wGlYz4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ljw6cBxg;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755858402; a=rsa-sha256;
	cv=none;
	b=raVxtatvkKit+KjfJl2x/sqF77NXVvVkjN4f/6RnBVi4nhczcg66bVHhHapLGVN9KsOZNs
	BX09E0PUGbfo/5AmI0Zk/8+dcI6g0fNVhjSiI/NetadZiCNPsYJPGsdx1xEQoCZxfFkSRW
	RWodGYKt2J/LVveGZPxEEHOPYkxMy9A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755858401; x=1787394401;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=IszcF2RotSRuBvDTanERbXkAxWvKDlohtlHMO4orRSA=;
  b=ljw6cBxg2MeHYXAaodefDtT7t7E/v1xa8NIpimQmgZSfXIkGFIShU/Zt
   spe3a8qV9F5ntUpseuIqKE3DldVvL3POSKg0uR9Lc5CBOfxTvIafJehkv
   H79kzQqWP+dhXyzvKTG4Yw/gRgjjM4BgPekc9D4/AbDFwm2+8RMrKlNau
   I7M/JCeMEgqB5Xb7RQTiMi+Dac+8riHvz+vgvygHZPD9/rCrrQVSEdlGR
   aeSkUXBxTxfdENs+oo/xl9dGszKWi08GWwGijSuUQo+qg0yo5ylULKGy+
   0gE9lMFrTCtcoQlNxGnwwv5N+RS6MlrxhF7OAY8F3Vs71gNJW/EXQ22Ug
   A==;
X-CSE-ConnectionGUID: iDmAdhc3TneIWWYVVxZZiw==
X-CSE-MsgGUID: +hEZ199DQCeuy1qObSDlrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="68866991"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="68866991"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 03:26:40 -0700
X-CSE-ConnectionGUID: TD9gkzKpQ9e59YgIqGGNpQ==
X-CSE-MsgGUID: 30NAFVU8TjmS9z+wz7lDuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="169073002"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 22 Aug 2025 03:26:38 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upOyi-000L9t-0x;
	Fri, 22 Aug 2025 10:26:36 +0000
Date: Fri, 22 Aug 2025 18:26:33 +0800
From: kernel test robot <lkp@intel.com>
To: Ye Liu <liuye@kylinos.cn>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Dev Jain <dev.jain@arm.com>
Subject: [linux-next:master 3830/4234] include/linux/mm.h:78: warning:
 "PAGES_TO_MB" redefined
Message-ID: <202508221819.lYpl8jIM-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 6bt99q33rud9r4pdemahojbtfikaiscb
X-Rspam-User: 
X-Rspamd-Queue-Id: 880AC1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755858401-108381
X-HE-Meta: U2FsdGVkX1+ZzZ4d5ZUYuqDaMON1ch8TZHo8+bhpuE4C5lR6Kh1SpL3KnPAaGoo6ov1ORXjZU+8rBn/3Y/FcI+OPRhs2jaqOWezjrq+9awC/VYuMUUWCPiRjDarbXafcyvH+o3s4SULUf4NT6LJE0sGIEJgW70/AOhvZwfwZbjWNiuQFt5s7LKQVo9sTs9OYQOZN3BvrCoCKkIiFITkzWtmkleMqMiRNLz9JrJyqqsWYxTFREj//cZIRiqZ8kwjFMYHt3dgP045V867hFGz5ZupjW0NlEJ5tJAuKUw2paAIVU65QLn9+JDF5aX6XGxVRnUSsf/Xd3fRyRFinFKdvWFKlhKV77AHw2U9pcuwK3k2qSk3BlBNSOZMb9CE1bgm5DJfrgP3tmJ+9SEDTB2tosgNBRCCWdsvm//X5pwWDpIm8ziBCmQc23tpQNQPJmJbSyVxL2K81SprmGk5UfP35yVf8+mcmnbbmQWTXJYlhMhpAlfTU4m8oQbDRysj71bA80kMUsqBCr7gYodyqtCnIIQTPN6mY72v4EVw/UKEn5UxqG6Baczo/l9KLW4ocQsiEwmdb4pVH5iVb234hKD3fB98osOFZsP2jYv1/qApcBQl6EIXcGsk3P3uVfu486kY8hTVwLYldgt71Twk1FOAeDeSm5YLZDqttBdb6SzU7nGiS/NaXSeRJmXNU7KbDYJujecPjEH389TWooUede2SHvbfyNBHnk6+ACC3slNQwL2Q3c4uB9IGBJxFsBggzQoKBGgvBQNEcAW2HwnnU/ezljZOp/KCf6KjpWZLJ8QYpoJPjl9m3Epc6ZjObSkwOo3D/4PgqG8Qf1kqwHB++2oA/ofcOMP6c3fKJiLSdOz/UnQ79aEXMLixyyJlbXTgkJisIsyWqJbG+nva/6UQ1fNYBbc1bBMxJEfD7ufRjfGi72jQ4+8beF149e1+LfjSxh8IBMBeXDBO/VYd0E8mA0ju
 3+ulbsPc
 guZoTYJoIb5ayC3ItFRHgDCKFZn4+0teYaC26GIZPlHoymNZ4B6Zf9OoKlmH3hmBi44iF6CwDONS01wTIXblXW+uGDrPlcz+qkbUOBfc2ouxIh5YJNBLsh8hLIfRCUTfLGIZfDc7iVmU/XrvKWDptPTq6GYYgxxyBF4bvz6j+EB0byYq4nBjqwF7d7ZHmzIyjfVCvbq5TIEVBHpeg589/wKFkui7lz3/+YrR9mB4mTTyqTrXQYOqjWROyoN0wr5pvoHyXbZ6DntdgdlyOwJCuu0ZEA6wFiVZrNlJRkH0ZZ8ROjRhGQOmmGzdQd1cwazdyeeYZS9l24Z60QLZCYDr68hhd3jxMgDlV1Pz8LmMIAzU05L6Wa1S7JSFfmPDLDtv9zx7AQPNrwRjIoEe1uQ3DfmaQPU9gFIZPadR9H/YfOaemqKPdkv16MYah3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ye,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   0f4c93f7eb861acab537dbe94441817a270537bf
commit: b91db3a36f79ab7fb796fc3fbbe0950a04ff9589 [3830/4234] mm: replace (20 - PAGE_SHIFT) with common macros for pages<->MB conversion
config: arc-randconfig-001-20250822 (https://download.01.org/0day-ci/archive/20250822/202508221819.lYpl8jIM-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250822/202508221819.lYpl8jIM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508221819.lYpl8jIM-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arc/kernel/asm-offsets.c:7:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from arch/arc/kernel/asm-offsets.c:6:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    
--
   In file included from include/sound/pcm.h:15,
                    from sound/usb/pcm.c:14:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from sound/usb/pcm.c:6:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    
   during RTL pass: mach
   sound/usb/pcm.c: In function 'retire_capture_urb':
   sound/usb/pcm.c:1390:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9110
    }
    ^
   Please submit a full bug report,
   with preprocessed source if appropriate.
   See <https://gcc.gnu.org/bugs/> for instructions.
--
   In file included from include/sound/pcm.h:15,
                    from sound/usb/quirks.c:15:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from sound/usb/quirks.c:6:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    
   during RTL pass: mach
   sound/usb/quirks.c: In function 'snd_usb_apply_boot_quirk':
   sound/usb/quirks.c:1675:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9110
    }
    ^
   Please submit a full bug report,
   with preprocessed source if appropriate.
   See <https://gcc.gnu.org/bugs/> for instructions.
--
   In file included from include/sound/pcm.h:15,
                    from sound/usb/clock.c:16:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from include/linux/delay.h:13,
                    from include/linux/usb.h:15,
                    from sound/usb/clock.c:9:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    
   during RTL pass: mach
   sound/usb/clock.c: In function '__uac_clock_find_source':
   sound/usb/clock.c:435:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9110
    }
    ^
   Please submit a full bug report,
   with preprocessed source if appropriate.
   See <https://gcc.gnu.org/bugs/> for instructions.
--
   In file included from include/sound/pcm.h:15,
                    from pcm.c:14:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from pcm.c:6:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    
   during RTL pass: mach
   pcm.c: In function 'retire_capture_urb':
   pcm.c:1390:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9110
    }
    ^
   Please submit a full bug report,
   with preprocessed source if appropriate.
   See <https://gcc.gnu.org/bugs/> for instructions.
--
   In file included from include/sound/pcm.h:15,
                    from quirks.c:15:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from quirks.c:6:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    
   during RTL pass: mach
   quirks.c: In function 'snd_usb_apply_boot_quirk':
   quirks.c:1675:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9110
    }
    ^
   Please submit a full bug report,
   with preprocessed source if appropriate.
   See <https://gcc.gnu.org/bugs/> for instructions.
--
   In file included from include/sound/pcm.h:15,
                    from clock.c:16:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from include/linux/delay.h:13,
                    from include/linux/usb.h:15,
                    from clock.c:9:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    
   during RTL pass: mach
   clock.c: In function '__uac_clock_find_source':
   clock.c:435:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9110
    }
    ^
   Please submit a full bug report,
   with preprocessed source if appropriate.
   See <https://gcc.gnu.org/bugs/> for instructions.
--
   In file included from arch/arc/kernel/asm-offsets.c:7:
>> include/linux/mm.h:78: warning: "PAGES_TO_MB" redefined
    #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    
   In file included from arch/arc/include/asm/irqflags-arcv2.h:9,
                    from arch/arc/include/asm/irqflags.h:13,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from arch/arc/kernel/asm-offsets.c:6:
   arch/arc/include/asm/arcregs.h:155: note: this is the location of the previous definition
    #define PAGES_TO_MB(n_pages) (PAGES_TO_KB(n_pages) >> 10)
    


vim +/PAGES_TO_MB +78 include/linux/mm.h

    71	
    72	/*
    73	 * Convert between pages and MB
    74	 * 20 is the shift for 1MB (2^20 = 1MB)
    75	 * PAGE_SHIFT is the shift for page size (e.g., 12 for 4KB pages)
    76	 * So (20 - PAGE_SHIFT) converts between pages and MB
    77	 */
  > 78	#define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
    79	#define MB_TO_PAGES(mb)    ((mb) << (20 - PAGE_SHIFT))
    80	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

