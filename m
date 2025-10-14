Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA314CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D988E00C7; Tue, 14 Oct 2025 04:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E208E0005; Tue, 14 Oct 2025 04:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D7B8E00C7; Tue, 14 Oct 2025 04:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D49938E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:16:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C0F45B2CA
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:16:04 +0000 (UTC)
X-FDA: 83996011848.17.F8BDAFD
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3BAC1C0004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:16:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=mYR5aVKk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf21.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760429762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HyVJ9F0sPkvb6d9V8yvLooHwZ3md82CKflBoPN1xb5Y=;
	b=BZTRQqvvKuD7/vrnK7WiPlJDzwmzQT7iuztKUtDK54BCiUgdUbY4qJkziEbXNyDckB0DtY
	n0Q4srf9Ko9j2owN8g9S0QBTYK+uac4iGERSigrpQv2bnQLIXvu7hWvLVbbzgN84jgiYqZ
	UGpGK/gl4ewheLchIacx4vtiHp/zROU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=mYR5aVKk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf21.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760429762; a=rsa-sha256;
	cv=none;
	b=kGjaCyxHsT0pFPQmVQs8AXuNtIBn7/Kf1WoerpOSopebwmrVBQp3YmT4D1wCHSgk03JkaN
	KSZTy5PEEr+Bph8EzeZHDpBY3FeIXakf3WWsJ6CmMv++4BE1d+iyuempQdBZ4EYXhENnAm
	ZUlSkn+ESldN4CU2wlUfdvtaSi/EQyY=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e29d65728so29836665e9.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760429761; x=1761034561; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HyVJ9F0sPkvb6d9V8yvLooHwZ3md82CKflBoPN1xb5Y=;
        b=mYR5aVKktyYkTKhrnFJC8PYZozX4KomZ8rYpLr+0vwRby9xJj2tSx6XjkhRkLYPqyg
         WE++VeO9nR6m3efO4uymNRbLPx2XGyfMV4EgTnxJF8rnnqk5uJT40Xt0Z8b+dgd1yemU
         umaB2ItTW5iXIKgFhykNqO3Mf93/wWiMmDuMCzxlmubrsq4mfVt3+1mhvZmjuPxBYJJP
         0YUlT98gm24ts7f+6LMcXK8AIwdR9XAcUQrL2kaCuthuC01ETtCzkLN0AssZOssIhfLQ
         6KnPbMPrrB5i7iSvoYhQXrsK6a3pUkhMWrB4uGTx4CuKudcKDJuT87Fuwz/PeIrcGPZX
         8UuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760429761; x=1761034561;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HyVJ9F0sPkvb6d9V8yvLooHwZ3md82CKflBoPN1xb5Y=;
        b=Q6fLe0TBKeq2ikKpxEvHOfJ3xK+IOSe3zPV3ZxpxuEaR/PEBNosG7ktTLPH9JbchZG
         qTgqeafEtDc5zL00HlATwn9zxVpJzq33gYx598vHSqB0Ajz+wv1CuPOGkeD7hMvSkmvo
         jkoBNJovb2en/ZFbE0fqa3tKQhuUHLlEmTbrHNSMYDyT6B6IglkFCUyb6rRAUoVnRcZV
         0qp8o6EbplTF3q5qOVf9Qu5I+DXVhVuUjiWvidmEtC8LuYg1L15v9bH8PoC5aXUEI2l6
         NLYDQR50nPjn2SZYy+6lhUxBKfFHdRlHKzV0BY2uovJ1vlQF5Z6aY7i2tUjYOQxv3las
         1l1g==
X-Forwarded-Encrypted: i=1; AJvYcCX9Ujh3eGXQB756HctgzPyGAQa84wMMuKswdNcXwxSRuRejEYy3IF3mW+MeT07jnk8+pq4kGBQiZQ==@kvack.org
X-Gm-Message-State: AOJu0YzOuUFJTJO7h5m0B+yeZEbAvBPicpK10yzEOPAnWjJYfFkmSHb0
	t+5GNgKSI4/jh/d5wItY/mOUSSxU9SX2RNRvF858pnUpfaVgfbsPr7wpf1ncsLlo+GI=
X-Gm-Gg: ASbGncvGxD8ekIMwdWymxX2nC6ig/2cw3HO4BstW4d1i1TdykUOjSvPg24H/zzOXMil
	4l/E2XdRNYCdEGkJAt5ItXCV4hfFX+KvwbzSgonSjrwfpD0DlFUcpsGagDW4OZim95zuQM3WNoU
	n4FkduCU8oAGFRqkXNCfXIqaqlBXrZWvo9yx8MfgWugZOuMX/FlgDAhJXolaFDptsN1/xnnrNrT
	Tzs3SA61dKvAuUxaz8ac/o7zwnrdiROaOOWGGB4XUPgrnatTvQuy44zmlWfSohKU4ZCon8bdYoq
	DzZkVJrUl4WWY2sg9wQYkYAgs/mrtE1vAFfwMpd+HIM8Owubfw4sRYUm0e7J3IrY9+gtpijivaX
	03dFDCLDKta5pDMULtRbjqAO9UJ6MdUGSV0X3fiURQx454gpsKqk=
X-Google-Smtp-Source: AGHT+IEmRqbCSKEmZNfKWDxZ8G3ZB8/M2f4+Xn4uL3VJmZBukjyvTnhQ7J09DzuK9UCi1D9bEFsC1g==
X-Received: by 2002:a05:600c:1d11:b0:46e:5aca:3d26 with SMTP id 5b1f17b1804b1-46fa9aef840mr173171105e9.22.1760429761023;
        Tue, 14 Oct 2025 01:16:01 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46fb4982b30sm224831925e9.6.2025.10.14.01.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 01:16:00 -0700 (PDT)
Date: Tue, 14 Oct 2025 11:15:56 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [linux-next:master 13427/13588]
 kernel/liveupdate/kexec_handover.c:978 kho_preserve_vmalloc() warn: missing
 error code 'err'
Message-ID: <202510100941.GZGMq64U-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: B3BAC1C0004
X-Rspamd-Server: rspam03
X-Stat-Signature: aqi8efmfdz1w61wno7sk76mafhm5ar8b
X-HE-Tag: 1760429762-562594
X-HE-Meta: U2FsdGVkX18YTMdTPWVEYJk7uWq6J8rA1T7lkq2OaB/1Bp21yCFzetNfMPEl84KNgeaPu6I0OOql4cj9NC8NBjc9kC0Exg0D145QKBekM64eeaJ76I80ObZsa5Zasno570LIGqQ7C5sR2vz+hZdWqhlULb0uHhjfPc4WM4dLZoU9XuSvGFqjc+nUUnptVD9b1g5eVetUvZ36f60iER+bP3MQpwR/FUkM4G8GrbshPkvLF3DSKI7v/ZpTOBj7szqhZfBGqWgXHH0ifaFYP/qgmyNt9Kyx54G7x8SWqPxLXAtIUkXKz4jmoQBgYZ5SjK8EZn3oEmQu3WUV5bOk1wekT76sCsJvXf2C5T0w9M2aoqwTUY7TJZEXA5bweF/DOqbnslwywjyOeo/oMUWNKQFGwzRWDrykvCzbgsYH6ql402vqIVAffo2i4dmKRGf5iuTRTZB01gwqnZGCbM96Q5CO0yOV0nY1VbId+fplBR7lJQ7u50gr7xqyS1R8qLn0ipJ+zIz5rDu4hxjVpR24zoAZkCCVWh6g/2V1dRo7FvuRJjnoaHbsl+XKTUhFRj2EbL7p+dMsaXEhZLIp7loZZ1okSsQHf4OYoXcVnXbzmJpsOwKYTgkGP9lRvOFZPoH5MFFR9WT2Zbbh/5mD5eAJqwDk1C9tlZp4j/vIpF04CbndrZLtVmrvaqlZ+PfCa1mVs+zU2YXVMNDQIWPP3hpxPxJBiKbq1DFAHg8YsToN22zhfwu29DUf1p+jw/4fQf78k9/NnkdVQyClHC4U3OcKDikIwYGE+OcALWuHgS8N29QoQEig27nTUWWaU3s5eKR4noscuauYgY+LPwgA08+AxbGSRpTX0NTPUCmzSPq2amkYg3/f69VBObuljdbcFhKSNEqzqEGQolbPeHV6TBUfbcz74OWitLg8vnUaCWtXqOPGj1YqI+9YDNqpErB+lnYPvK8naQ9+rx0cLv2B2/FksLZ
 lrPv9WbH
 b35zyQkuYS7taCwgbdPtIuxFIZo6Cp5bHep/Ct5bHZ36zPtBAJTBkZzs+53g6/0cY65ziZeBwzEhroY3wLjmxNjOltjXSOOfd3oDxuljFgxJzQFjSYp1s91LS4SQkS6lfuX/7+FYg5WnAgpjaIQOV6rvjD3zB4EwUwrmcqE9c2UqhlbFKHVB53/qUIbGzdELGfrMCpldDwYEMm4JHoUCQj7I94Z2v22utU+iEWGmHC7mmJGrZ4teGcCDTQZztgTH1ISaVUQCg5HqZH85GuiykBgEqmycOXc+3VEFRLP3hcx6jZLcLfYlxKbUFt8IXONob+V90EoGJH3pZY6eiUClSKWR3eUB8YxKSeGtC9fZdFR6j+KBmmaDbKvLG4nFRcxwJbK7n8/SeE0sm8ASMZEadXHAfBiG2e0M22VUek1SdFG6MJIAOI2Y2AWiZ7O24eqRwVK3gZlkVZqODTUS5KPsX1eYUvlZQy1srRenQUAv4bwv4IjM3aU++PVFoX4D59i4XfZAe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   0b2f041c47acb45db82b4e847af6e17eb66cd32d
commit: f13bb574707674d1113a40e0b6dc4d9a143d2ec1 [13427/13588] liveupdate: kho: move to kernel/liveupdate
config: x86_64-randconfig-161-20251010 (https://download.01.org/0day-ci/archive/20251010/202510100941.GZGMq64U-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202510100941.GZGMq64U-lkp@intel.com/

smatch warnings:
kernel/liveupdate/kexec_handover.c:978 kho_preserve_vmalloc() warn: missing error code 'err'

vim +/err +978 kernel/liveupdate/kexec_handover.c

a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  944) int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  945) {
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  946) 	struct kho_vmalloc_chunk *chunk;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  947) 	struct vm_struct *vm = find_vm_area(ptr);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  948) 	unsigned int order, flags, nr_contig_pages;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  949) 	unsigned int idx = 0;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  950) 	int err;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  951) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  952) 	if (!vm)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  953) 		return -EINVAL;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  954) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  955) 	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  956) 		return -EOPNOTSUPP;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  957) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  958) 	flags = vmalloc_flags_to_kho(vm->flags);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  959) 	order = get_vm_area_page_order(vm);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  960) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  961) 	chunk = new_vmalloc_chunk(NULL);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  962) 	if (!chunk)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  963) 		return -ENOMEM;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  964) 	KHOSER_STORE_PTR(preservation->first, chunk);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  965) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  966) 	nr_contig_pages = (1 << order);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  967) 	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  968) 		phys_addr_t phys = page_to_phys(vm->pages[i]);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  969) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  970) 		err = kho_preserve_pages(vm->pages[i], nr_contig_pages);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  971) 		if (err)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  972) 			goto err_free;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  973) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  974) 		chunk->phys[idx++] = phys;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  975) 		if (idx == ARRAY_SIZE(chunk->phys)) {
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  976) 			chunk = new_vmalloc_chunk(chunk);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  977) 			if (!chunk)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21 @978) 				goto err_free;

err = -ENOMEM;

a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  979) 			idx = 0;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  980) 		}
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  981) 	}
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  982) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  983) 	preservation->total_pages = vm->nr_pages;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  984) 	preservation->flags = flags;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  985) 	preservation->order = order;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  986) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  987) 	return 0;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  988) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  989) err_free:
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  990) 	kho_vmalloc_free_chunks(preservation);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  991) 	return err;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  992) }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


