Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D94C44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7217A6B0005; Wed, 21 Jan 2026 03:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF3F6B0088; Wed, 21 Jan 2026 03:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1216B0089; Wed, 21 Jan 2026 03:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B75E6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:58:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3D32BB9CB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:58:28 +0000 (UTC)
X-FDA: 84355369896.22.28A2226
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15C16160005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:58:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=g1smLvZ0;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf08.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768985907; a=rsa-sha256;
	cv=none;
	b=GeW52bET5jkI1KDZnPJYCkIvZLBkYjnXjr3V7rwB4pHONL0G4JApndN+baZiptpaMUwCEN
	prAEZSZfIIiKrIySmnFnYgJd/JP6VcFylCjb+KoLQ0xD6Spld/SH6PH6NrjsZqq06fZeEf
	ClVnmUW2FWyz+3sysv7g2m+cFHMpL+I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=g1smLvZ0;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf08.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768985907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G4X8dMKetrdNmqKhKcHZ5SlhB98c1MkwzIAdKHbK4l8=;
	b=zuyBMPab4cs8oC0KJdT6rmc+Y9Y0shI92ehiWFK1cJ5GAVJxqf6WeOoSzn5U+qp9cpyn1r
	UxwAHj/AYBz6mYtG1egVi6cXAstY0mg92TCAlK0O8Bkd0KmZEmqt+i07hxwZL9n8KeXqgs
	VyscIlYEs/iBuom5zC/gPczjhq9wz4A=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47ee3a63300so59977665e9.2
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768985905; x=1769590705; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G4X8dMKetrdNmqKhKcHZ5SlhB98c1MkwzIAdKHbK4l8=;
        b=g1smLvZ0xsNZvLmLlmX7RkuPXAO2Xaechj2sb6Alz/94fdp1rbsDU8HgszKujciHo0
         LYT5Fhe9TPw0f1y8ww61kSskLo3TyWbvZbyJB/OjeY/4RYhJ1C1/s46NVwMf3vNYgUT1
         DJoSXohgbz8t8QuzxpYhSIWJetbOwTAMGVE2wwHvS8kMT2X9AFJjqe9T/IRok6a3wvqd
         WMQTYL6UThczpwwDHvvGAjycKw3YUchvNLj69ogznXVJCOgBa6pRt7w7rLj89aN1neMp
         EUpZ64KbTuWIeANuK9aESYv3nxCFkIFEChtk1nQX88rWPzt3EG1stD9H6xSEXcaRYEy2
         ekWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768985905; x=1769590705;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4X8dMKetrdNmqKhKcHZ5SlhB98c1MkwzIAdKHbK4l8=;
        b=v9eUDdEKNYnsAx95ip2LK41AHBJmALZqaJJchTODkEVxU//PO9yNhLwakSPeAbEaWA
         3OGox+QNNjdWY68vMs9O0t6wLYrose13EThhVKWoTkNKzk2nt6c3VjA8+j0xKOvI15AT
         juYnoCDdHKZWAeIyhRP2aD2V59Mupr1RMNUBCqorVbAkv9OTxKQKoTN4DBdc2lYPr64S
         JWeKUSypRIZdMDElC1RLQoMr9uo+Q3NTaGRYzNK/r1DOZEWGwBIlIK0tK+PtbDogxGWq
         kkmAQEkGA3Z3FATzexRtpGH1NSacqRH/bfw/BuIAD/utK1yUhCDvYECO1Qo1RNIr4e54
         7sjA==
X-Forwarded-Encrypted: i=1; AJvYcCX6Dy4grSkoANHrLlDs7svwyWswtSSIW9sFPlTAVGIIO4T0wZf5qEEnMULXuNZldRSC+lO+9eXAvA==@kvack.org
X-Gm-Message-State: AOJu0Yx0E78rnAW3G6Dpg+ngQZvXDI9aUmthkjDNYFQHKR5dYCa3+tyk
	z+I0IbRxmfC2YBGvrz8shE7+ND7nSK2QDpkx7svjY01dYAkQBzjvyjJT8aeQDL+JGdk=
X-Gm-Gg: AZuq6aLbKPN7ARgP1IbaI9PUrh/xIf3j8GQTnlOdmQCZ6ubZjToARKMw+djLva3CkFc
	tXL3x1y8Ehxwi4/Rdu1WlTwEsEjIRXTPwmFXJuLEIVAdv8IyGRH7vcz+alXYuEaJX12n8ArYbpJ
	ZimTyQKBkoxnUvgzlirlSI1pRULpQ0C17kt/26fWfv6XKlwySYmVsD20ybjlIc/5QFm1SgxB0BC
	I6h5kVCQ/xIH6LCgmDCzf2Y4UrFV1Q5aIw0d8DHMdzl3AbVbd0Yt+HwjrYygTk/xCgl5oObfiDP
	R2pnpmDgvFPdq2HzvTMWS+ir87BhaujZEzcqzzwwpFq4u3dbxavUGALiMuCEsCM+f6JQIsPodBd
	irYCtg0RnPtv/ERLFEEaYus01J2hNMDu8JQJPHC6Lcg+sZCR8ZUOJeZ7CaYsBwpOalTtx7inI0V
	4QrP/1B4iwjZ2MEHuNOpr2DcqRlgY=
X-Received: by 2002:a05:600c:8011:b0:47e:dddc:3369 with SMTP id 5b1f17b1804b1-4803e801e7dmr62810625e9.35.1768985905121;
        Wed, 21 Jan 2026 00:58:25 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804252b02dsm17027785e9.5.2026.01.21.00.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 00:58:24 -0800 (PST)
Date: Wed, 21 Jan 2026 11:58:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc() warn:
 missing error code 'err'
Message-ID: <202601211636.IRaejjdw-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 15C16160005
X-Stat-Signature: m3btpmkbpi31ht1xu6kg5bro5u8hjchi
X-HE-Tag: 1768985906-691833
X-HE-Meta: U2FsdGVkX1870injtps6DRXpa7VHSCdICWGj2cofgvzK3j5pXHTK9P2I0ZYJQpJ4roCRC4pn59Jvqd9erOrdX03YLXirtR1ibVgTK5/b+0IPu3dXkTadDwqUfTpOgMQCglRLeDygBflKCbcdLE85MBzfyThgB5zveI1ise7+ni7+o/9FWZcI0TuOakdbgZ//ibhH+wcWwwY733sbA7F1VKd75uXQbZiqKiSxFuQ6O8q3G5HY+895oeGYOwA5k7IjkAvQZ0HAsAvpXQoUu5SROtNiXNdmFEIdLecKq2ZPaaciHITy+bVVNYeNypAVy8Rl/AMU6fEFa6dT2u3Hu/Iehk3HPgiFMfEj4dxzdnygdVLOaMPlAonnHmMGRnENoHT5eFCzp69Is//jd2qvvxZPkVuZdt+uEGaFpvA/amwNhGlrnoG7g6buVdSDzhZcxjgLegMkGpc4oq8lST05pvLOIIoJHtds6+16FnQcJlj2LpNsh5oIQG7QQU1LP+joWBSNgmzS6630s+x13tn2UAqmdxsMFgekvdEfolryOeFUeqfvHGhwDhHHNcMizRzK3mmkxkzaXWJ6nkbDKSxv3ZBQaZjt4kJhRFLneZvhRV7zbl2Xz9NV+fp8niZir6FAYz+Qvub5IAiC0gePkqubwVIQNpDRxsACFylw/rq/jR8Nm3YshEqIuRzfl08V568S8t7mRBuyZGQ4BQ34UtbeoutKvCodJgLnH2CXeA5HAZJmQsEzfFVn+7/K3QYx7hr+XXpSPg+X3fUGswqh4efO2CtZD2fPaTYPmyZvmqCZcHZcpatnCusmyeMUqlmSYRU5RZsCpjBJUmPOWE4jNIkF29oGFwnb9LvjLywQnEiL12xSJV8zkxp0etMfbObKz0IcztPWfrbTlwsOZrsahMrMuo7sne3zyTTzdBZssxQ7r5uWigzOMovPp+S9FFRRJVNBdnXwA5pu6IVY/WWnag0i2/I
 Ng32czFO
 1xB0SehDQ0SoIFE1UAit6vUjrhXFgQgX0wotNUqN5pQ4igDQ/FzcordygDifxIaHk5dSy9joXil0R1rxr/ZgJjYC8mHBPg7FRC5WcwoZWFDIkE64YPwcU6jZrbgE6Z+/NOmiwmH4ZVznQh+s0PXqh2s0ObrvVqe2LwiMI/Fgl8wyd+jfo+tbOce88vZcJYL2afJd/1uYZ4EiFkZQOfMSyKVkMtffp7mbo2FMAccpiGDfRbABqDZ75zo+3LxlvW+ZFZmhsByu6HYMsgd0GRDjQgmUZTrMKl4GVzuyBQaj6B6QHO/MwWRRB+ajwazyV1t6ngUMxM3fD4bzSbnhxUWhZ2r0jzVcODofil4rhBKVYIwFjtlcGeEu88SILlWppj5pqcRpxhniYiVqh9fUSFQfsmnrzne7C/u7aMzjXEjG8z0RXhwg5T4TxP4mBcFQ3+HdtarRWXx6Zwwx3cqqFRUSWbtFEgBqikvUDUbnJSSnkqxvY9BPf60Z25C9U0B+LYWSD5bn9pISpFWBuxHoyQ2s7PsFPPihOzGuCyE9o9RVbuE0UsSBfDeRH17wt5QlGNEzsWX5c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   6c790212c588fddeb0d852f2790840753bb604b1
commit: 48a1b2321d763b5edeaf20bd4576d8c4b5df772b liveupdate: kho: move to kernel/liveupdate
config: x86_64-randconfig-r071-20260121 (https://download.01.org/0day-ci/archive/20260121/202601211636.IRaejjdw-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
smatch version: v0.5.0-8985-g2614ff1a

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/

smatch warnings:
kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc() warn: missing error code 'err'

vim +/err +994 kernel/liveupdate/kexec_handover.c

a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   960) int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   961) {
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   962) 	struct kho_vmalloc_chunk *chunk;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   963) 	struct vm_struct *vm = find_vm_area(ptr);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   964) 	unsigned int order, flags, nr_contig_pages;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   965) 	unsigned int idx = 0;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   966) 	int err;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   967) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   968) 	if (!vm)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   969) 		return -EINVAL;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   970) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   971) 	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   972) 		return -EOPNOTSUPP;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   973) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   974) 	flags = vmalloc_flags_to_kho(vm->flags);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   975) 	order = get_vm_area_page_order(vm);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   976) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   977) 	chunk = new_vmalloc_chunk(NULL);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   978) 	if (!chunk)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   979) 		return -ENOMEM;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   980) 	KHOSER_STORE_PTR(preservation->first, chunk);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   981) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   982) 	nr_contig_pages = (1 << order);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   983) 	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   984) 		phys_addr_t phys = page_to_phys(vm->pages[i]);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   985) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   986) 		err = kho_preserve_pages(vm->pages[i], nr_contig_pages);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   987) 		if (err)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   988) 			goto err_free;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   989) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   990) 		chunk->phys[idx++] = phys;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   991) 		if (idx == ARRAY_SIZE(chunk->phys)) {
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   992) 			chunk = new_vmalloc_chunk(chunk);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   993) 			if (!chunk)
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  @994) 				goto err_free;

err = -ENOMEM;

a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   995) 			idx = 0;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   996) 		}
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   997) 	}
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   998) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21   999) 	preservation->total_pages = vm->nr_pages;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1000) 	preservation->flags = flags;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1001) 	preservation->order = order;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1002) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1003) 	return 0;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1004) 
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1005) err_free:
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1006) 	kho_vmalloc_free_chunks(preservation);
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1007) 	return err;
a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  1008) }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


