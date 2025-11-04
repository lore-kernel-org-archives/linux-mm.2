Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D2ACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 15:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331598E0003; Tue,  4 Nov 2025 10:38:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308EE8E0002; Tue,  4 Nov 2025 10:38:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E7A8E0003; Tue,  4 Nov 2025 10:38:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11AF88E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:38:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0A9F88C9A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:38:31 +0000 (UTC)
X-FDA: 84073331622.15.74C8B5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF96F20008
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 15:38:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QOScfZaH;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762270710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPPCYUrkQ4b31RpUoHm2sozk/0REimUGJ814jhQRsHI=;
	b=1BLgjz23ByP4mGjvhny0gfcyxWGtTEZUmlDl0F5WEItQyOz96NiqAZfhcA6oC7f2bvvJwi
	QyE94fDGwcjrsfuWeBzbTshLpB9DcdQXVxN/CHgCBPLJEGNSMX9Bw4CDUvkHxRlMQzpeZW
	8X2lIpGwk6CGWk0r8oSofcxkYKW9MR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762270710; a=rsa-sha256;
	cv=none;
	b=wB61FbyamnUGcTMNXthreGckF+qeLRcilYwx7VqjX+tLuzrVgKLPY2v293SI6od+7iRQzP
	OTKIYTJ1KKhhJNLDbDe1ZFZmW1qrkt+dh4sPKjy9iq+9jI6pjjYCNrm3+Oow/GA9J8ihAN
	439FxcmlHGDkzCFBZChc7K9xdHpWbNA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QOScfZaH;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91E6343676;
	Tue,  4 Nov 2025 15:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FE7C116B1;
	Tue,  4 Nov 2025 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762270708;
	bh=Cy2J3fuWY60QkQU2M8ngzJ5eZQ2C5WxBRZsDSPR2PEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QOScfZaHZ3az+dDuP50EvzmdN+lL8yV1bHUDHlYcjWAsL7QLDE3XzC0dRkfwZdr/q
	 tkzFsQoAh0QnlQr2erUlAfdglfTB/KIsIcTX+Mfa8mAe48pOr8bu+FEkys4Eboxluz
	 J2oFcJEmCXMsCJDf/BQRZjhDxVWs9otbXK2ODvX5ksOFoolvGOUktMBRGAVeImYsx+
	 cKBl8MJQyk4mQijeqp5yk+NU6LCNCan3LRmZiVX3mv6w2hqXuo8659s4WTS7jE0ADJ
	 zzz5u55ggzwP2KKYkyH1uzrQgpgZnf1c3uTFd/TH1gMuPcPzZSecVnABD5GgRNAP0s
	 ru4zV22/FXINA==
Date: Tue, 4 Nov 2025 17:38:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	kernel test robot <lkp@intel.com>
Subject: Re: [linux-next:master 4972/5926]
 kernel/kexec_handover_debug.c:16:18: error: use of undeclared identifier
 'kho_scratch_cnt'
Message-ID: <aQod7jDFBjw9T-u2@kernel.org>
References: <202511042251.paO6f5BZ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511042251.paO6f5BZ-lkp@intel.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF96F20008
X-Stat-Signature: t9ygqyc5zfnbdpjo68wmrtnamg6xshn9
X-Rspam-User: 
X-HE-Tag: 1762270709-696827
X-HE-Meta: U2FsdGVkX19fgGxVxc+Khi9/JfmNOTlqMWWmQIutz2wOymiJ6la9PNWTHxtevj3rtEJg5UaLgp0cUxG5XZhn2CvH5WRzYgGLoY7uKoNf5KAzrMr3+YZUKFJm96KldEnGqBh0SrWng3WGeuNTyEf/5xQnYHyu8fo2/MCr4lwTKoZvT/D45Pq0PpkifCo+fZ5+EFz67/XmPWECK5j9VKcBLV6PzMoBtfu6Z2BY6Wb69jvw6Lg7boJXYMShs0o5MqBmxBvn8MRlxLeGfFyGioYOPdvZrkmqcCYIPPj6dyUTLFiN8nN2dWnhD/Qy3ARZ1WFilGA0TeezgZezD3bySQkd8XrskMqORZFkWPaU0FPywa5Wqn2WcFHO3lD9S1to1AmVLiNfLrRv/iNzCOJM2Mq426VWtfNpRY2vTQVcI0f89KBgITXdLwj4tRIjS+iJSyDpJKkfQKMESMzAR85SvC9RiKZnxFUhz44dy3OYCPtV87k0Coq9mPgH0bDUJotvK+1oN7tcVLaYCGgGSbx4ppbCoGmsWfnBZbJlcFDDtBa1j/fTL6rKG91b5W9WiMg0bG3c2Rt35O3AAkfP0lJbr9KhzUV394uX0rixcX6AdETP4EhSFqEE5PirW7OcmnLGvcJ6cJPjLSvCdDjiUfeJ707Nes4q4u4kAytMztwJrrxAY0ZYgb0a/9lumy8CHh+kJinuj38cihcLx0LOTy17BVMgw6mwr0Bd9Iygkj1v9e+x6GYSHx2xGrY90kBitMRkNwuzQfoaT9lnz604/l4HbOQ+kJsLzOHYTp9TGk6y80WhoWX/iJq1CSLr87FFW1fzPvBbIOgubxmYXSzAYr40vFoQN05tqbB/No1SLOyX3XcJ/xU1TWsaUHbumTDiBv4LUB23cmB87VJmOpEvNYeNXycbnTuvVSw9ffJwkKb7yjK1z03dYkz6ANsX25WTy0Gf2omnCLSgdyzPFTILF9FSqTW
 7kgXurdY
 sUKEyKjmwZ0FHEFXVoXwHZjX5zY7jkWckekJP+LuKY44aYs9IZf8DshwrylAGA+83g+wo9QP6xnkmP75vKRKZLgyym5QmgqrKZG5NmAunrfgXhlbYiy64pWKraDkTILOKyZVoKTpF7AE5vAQT0j1REhSYQbdy4sxkclXotKwLFR8msqbzEgWghegHqnRRqbx4UngGh7jeczHlDNY4234aWcYrtWj0KKO8GuSyJIkSWzbSaSH1iq6RoVIHLpX/y/P79c40nMoE8swdbUj2E/nEY7JblWWY+RVKRZCMm/uzFYMI8tM0M8Izxc+eSUCpRrGTQ1mb2mT63+S9kSpR0CvIWQ62Uqsc9ZS4F691KVnUTXEVopnsojz/LlNAywSyOBmsJH23uQk+j6/A8pM56rQf0vc+i0/yrgK3dAy5FNmCrIMOrjeT0GNsQU6OaVOTHXDo5zN/F1t8w6PO970dQb/y38iYtSBMshc+3Mj1eyfVBMDYkOP0soWnKQI64OBmsaBlKXZ/RVTV5D5HDc61WXfAS8wlJdFkehkpZ644dCOEkjNLmWY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(adding Pasha)

On Tue, Nov 04, 2025 at 10:48:31PM +0800, kernel test robot wrote:
> Hi Mike,
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   17490bd0527f59d841168457b245581f314b5fa0
> commit: 8c211175c3abcebb8bffce8095d78d193e482105 [4972/5926] liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
> config: x86_64-randconfig-071-20251104 (https://download.01.org/0day-ci/archive/20251104/202511042251.paO6f5BZ-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251104/202511042251.paO6f5BZ-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511042251.paO6f5BZ-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> kernel/kexec_handover_debug.c:16:18: error: use of undeclared identifier 'kho_scratch_cnt'
>       16 |         for (i = 0; i < kho_scratch_cnt; i++) {
>          |                         ^
> >> kernel/kexec_handover_debug.c:17:19: error: use of undeclared identifier 'kho_scratch'
>       17 |                 scratch_start = kho_scratch[i].addr;
>          |                                 ^
>    kernel/kexec_handover_debug.c:18:17: error: use of undeclared identifier 'kho_scratch'
>       18 |                 scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
>          |                               ^
>    kernel/kexec_handover_debug.c:18:39: error: use of undeclared identifier 'kho_scratch'
>       18 |                 scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
>          |                                                     ^
>    4 errors generated.
> 
> 
> vim +/kho_scratch_cnt +16 kernel/kexec_handover_debug.c
> 
> 4039a00022d42a Pasha Tatashin 2025-10-20  10  
> 4039a00022d42a Pasha Tatashin 2025-10-20  11  bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> 4039a00022d42a Pasha Tatashin 2025-10-20  12  {
> 4039a00022d42a Pasha Tatashin 2025-10-20  13  	phys_addr_t scratch_start, scratch_end;
> 4039a00022d42a Pasha Tatashin 2025-10-20  14  	unsigned int i;
> 4039a00022d42a Pasha Tatashin 2025-10-20  15  
> 4039a00022d42a Pasha Tatashin 2025-10-20 @16  	for (i = 0; i < kho_scratch_cnt; i++) {
> 4039a00022d42a Pasha Tatashin 2025-10-20 @17  		scratch_start = kho_scratch[i].addr;
> 
> :::::: The code at line 16 was first introduced by commit
> :::::: 4039a00022d42ac3d68b2eea63066bc9f7ef89ce kho: warn and fail on metadata or preserved memory in scratch area
> 
> :::::: TO: Pasha Tatashin <pasha.tatashin@soleen.com>
> :::::: CC: Andrew Morton <akpm@linux-foundation.org>
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

-- 
Sincerely yours,
Mike.

